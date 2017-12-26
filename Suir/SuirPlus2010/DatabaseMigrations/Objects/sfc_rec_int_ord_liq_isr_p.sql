create or replace procedure sfc_rec_int_ord_liq_isr_p (
  p_return out                    seg_error_t.id_error%type,
  p_error_seq out                 number,
	p_periodo_procesar 		          sfc_liquidacion_isr_t.periodo_liquidacion%type,
	p_is_bitacora                   boolean default true,
	p_is_commit                     boolean default true
) is

-- *****************************************************************************************************
-- Program:		SFC_REC_INT_ORD_LIQ_ISR_P
-- Descripcion: Genera los recargos e intereses Ordinarios (Mensual) de las Liquidaciones de ISR
--
-- Modification History
-- -----------------------------------------------------------------------------------------------------
-- Date	  by  Remark
-- -----------------------------------------------------------------------------------------------------
-- 090205 jlr Creation
-- 280408 jlr Actualizacion satus para Infotep.
-- 300310 dp  Aplicación DESCUENTO RECARGO ISR .
-- 220610 dp  Manejo nuevo campo SRE_EMPLEADORES_T.PAGA_RECARGOS_DGII.
--
--
-- jlr - Jose Luis Riera
-- dp - David Pineda
-- *****************************************************************************************************

-- *****************************************************************************************************
--											  Global variables
-- *****************************************************************************************************

v_ID_PROCESO 						    	CONSTANT sfc_procesos_t.id_proceso%type := '07';
v_MODULE     						    	CONSTANT errors.module%type := upper('SFC_REC_INT_ORD_LIQ_ISR_P');
e_Houston                     exception;
v_ErrorSeq 								    number;
v_error_mesg								  errors.error_mesg%type;
v_id_bitacora       				  sfc_bitacora_t.id_bitacora%type;
v_mensage                     sfc_bitacora_t.mensage%type default null;
v_fecha_proceso      				  date;
p               							Parm;
v_periodo_factura             sfc_liquidacion_isr_t.periodo_liquidacion%type;
v_secuencia                   number;
v_recargo_isr                 number;
v_descuento_recargo_isr       number; --dp300310
v_interes_isr                 number;
continua                      boolean;
cont                          integer;

-- *****************************************************************************************************
--											  Local Process
-- *****************************************************************************************************

procedure crea_recargos_int_ord_liq is

	cursor c_liq is
	 	 select li.*
	 	   from sfc_liquidacion_isr_t li,
	 	        sre_empleadores_t b 								--dp220610
         --where li.no_autorizacion is null 						--dp220610
         where li.id_registro_patronal = b.id_registro_patronal  	--dp220610
           and li.no_autorizacion is null
           and li.status = 'VE'
           and nvl(b.PAGA_RECARGOS_DGII, 'S') = 'S'					--dp220610
         order by li.id_referencia_isr;

begin
  select trunc(sysdate) into v_fecha_proceso from dual;
  p := Parm(p_periodo_procesar);

  dbms_output.put_line(p.fecha_corrida_recargos_isr);
  dbms_output.put_line(trunc(nvl(p.fecha_corrida_recargos_isr, v_fecha_proceso+1)));
  dbms_output.put_line(v_fecha_proceso);

/*  Begin
    cont := 0;
    select 1
       into cont
         from dual
           where trunc(nvl(p.fecha_corrida_recargos_isr, v_fecha_proceso+1)) <= v_fecha_proceso;
    exception
         when no_data_found then
                              continua := false;
  End;
  if cont = 1 then continua := true; end if;*/

  continua := true;
  if continua then

     UPDATE sfc_liquidacion_isr_t li
        SET li.status = 'VE'
      WHERE li.status = 'VI';

      --dp280408
     UPDATE sfc_liquidacion_infotep_t
        SET status = 'VE'
      WHERE status = 'VI';

  	for i in c_liq loop
       v_recargo_isr  := 0;
       v_descuento_recargo_isr  := 0; --dp300310
       v_interes_isr  := 0;

       if i.periodo_liquidacion is not null then
          v_periodo_factura := i.periodo_liquidacion;
       else
          select to_number(to_char(v_fecha_proceso, 'yyyymm'))
            into v_periodo_factura
            from dual;
       end if;

       if v_periodo_factura < p_periodo_procesar then
          v_recargo_isr  :=  (i.total_isr - i.total_saldo_compensado) * p.isr_recargo;
       else
          v_recargo_isr  := (i.total_isr - i.total_saldo_compensado) * p.isr_recargo_primer_mes;
       end if;

       --dp300310
       if i.id_tipo_factura = 'T' then
       		v_descuento_recargo_isr := v_recargo_isr * p.isr_descuento_recargo;
       end if;
       --end dp300310

       v_interes_isr   := (i.total_isr - i.total_saldo_compensado) * p.isr_interes;

       UPDATE sfc_liquidacion_isr_t li
          --SET li.total_recargo = li.total_recargo + v_recargo_isr,  --dp300310
          SET li.total_recargo = li.total_recargo + (v_recargo_isr - v_descuento_recargo_isr),
              li.total_interes = li.total_interes + v_interes_isr
        WHERE li.id_referencia_isr = i.id_referencia_isr;

       select sfc_recargo_liquid_isr_seq.nextval into v_secuencia from dual;

       insert into sfc_recargo_liquidacion_isr_t
         (id_referencia_isr,
          secuencia,
          interes_isr,
          recargo_isr,
          descuento_recargo_isr, --dp300310
          fecha_recargo,
          periodo_recargo)
       values
         (i.id_referencia_isr,
          v_secuencia,
          v_interes_isr,
          v_recargo_isr,
          v_descuento_recargo_isr, --dp300310
          v_fecha_proceso,
          p_periodo_procesar);
  	end loop; -- fin del loop for i in c_liq

  end if;
EXCEPTION WHEN OTHERS THEN ErrorPkg.HandleAll(FALSE); RAISE;
end crea_recargos_int_ord_liq;

-- *****************************************************************************************************

procedure lock_tablas_isr is
begin

  lock table sfc_liquidacion_isr_t IN EXCLUSIVE MODE NOWAIT;
  lock table sfc_recargo_liquidacion_isr_t IN EXCLUSIVE MODE NOWAIT;

EXCEPTION WHEN OTHERS THEN ErrorPkg.HandleAll(FALSE); RAISE;
end lock_tablas_isr;

-- *****************************************************************************************************
--
--										  Main Procedure (Anonymous block)
--
-- *****************************************************************************************************

begin

begin

  p_return := '000';
 	if p_is_bitacora then srp_pkg.bitacora(v_id_bitacora, 'INI', v_ID_PROCESO); end if;
  /*Lock_tablas_isr;
  crea_recargos_int_ord_liq;*/

 	if p_is_bitacora then srp_pkg.bitacora(v_id_bitacora, 'FIN', v_ID_PROCESO, 'OK', 'O'); end if;

  if p_is_commit then commit work; end if;

EXCEPTION WHEN OTHERS THEN ErrorPkg.HandleAll(FALSE); RAISE;
end; -- Anonymous block

EXCEPTION
  WHEN e_Houston then
	if p_is_bitacora then
    if v_mensage is not null then v_mensage := 'Houston'; end if;
  	srp_pkg.bitacora(v_id_bitacora, 'FIN', v_ID_PROCESO, 'E', p_return, p_Error_Seq);
		srp_pkg.notifica_ejecucion(v_id_bitacora);
  end if;
  WHEN OTHERS THEN
 	rollback;
    ErrorPkg.HandleAll(TRUE);
    ErrorPkg.StoreStacks(v_MODULE, v_ErrorSeq, TRUE);
    ErrorPkg.PrintStacks(v_MODULE, v_ErrorSeq);
	if p_is_bitacora then
    select error_mesg into v_error_mesg from errors where module = v_MODULE and seq_number = v_ErrorSeq;
    p_return := '650';
  	srp_pkg.bitacora(v_id_bitacora, 'FIN', v_ID_PROCESO, v_error_mesg, 'E', p_return, v_ErrorSeq);
		srp_pkg.notifica_ejecucion(v_id_bitacora);
  end if;

end sfc_rec_int_ord_liq_isr_p;

-- *****************************************************************************************************
 