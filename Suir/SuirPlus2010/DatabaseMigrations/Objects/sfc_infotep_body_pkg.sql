create or replace package body suirplus.sfc_infotep_pkg is
  -- Objetivo: Verificar en la tabla de facturas de INFOTEP si hay una factura de bonificacion creada para el RNC y periodo que se envia con estatus PA o con un Nro. De Autorizacion.
  -- Autor: Gregorio U. Herrera
  -- Fecha: 01/03/2007
  Procedure ExisteFactBonificacion(p_rnc_o_cedula in sre_empleadores_t.rnc_o_cedula%type,
                                   p_periodo sfc_facturas_t.periodo_factura%type,
                                   p_result out char) is
  Begin
    p_result := 'N';
    -- Busca 
    For c_inf in(Select *
                 From suirplus.sfc_liquidacion_infotep_t i
                 join suirplus.sre_empleadores_t e on e.id_registro_patronal = i.id_registro_patronal
                  and e.rnc_o_cedula = p_rnc_o_cedula
                 where i.id_tipo_factura = 'B'
                   and i.periodo_liquidacion = p_periodo
                   and (i.status = 'PA' or i.no_autorizacion is not null)) Loop
      p_result := 'S'; 
      Exit;              
    End Loop;
  End;
  
-- **************************************************************************************************
-- Program:     Liquidacion_NoEnvio_Inf
-- Description: Utilizado para consulta de liquidacion del Infotep
-- **************************************************************************************************

    PROCEDURE Liquidacion_NoEnvio_Inf(
        p_idrecepcion         IN SRE_DET_MOVIMIENTO_RECAUDO_T.id_recepcion%TYPE,
        p_resultnumber        OUT VARCHAR2,
        p_iocursor            IN OUT t_cursor)

    IS

        e_invalidrerecepcion      EXCEPTION;
        v_bd_error                 VARCHAR(1000);
        c_cursor t_cursor;

    BEGIN

        IF NOT suirplus.Sfc_Factura_Pkg.isExisteIdRecepcion(p_idrecepcion) THEN
           RAISE e_invalidrerecepcion;
        END IF;
                
            Open c_cursor for
                select l.id_referencia_infotep, e.rnc_o_cedula RNC, m.no_autorizacion Autorizacion, TRUNC(m.fecha_pago), m.monto
                from suirplus.sre_det_movimiento_recaudo_t m
                join suirplus.sfc_liquidacion_infotep_t l on l.id_referencia_infotep = m.id_referencia_isr and m.status = 'OK'
                join suirplus.sre_empleadores_t e on e.id_registro_patronal = l.id_registro_patronal
                where m.id_recepcion = p_idrecepcion;
                

            p_IOCursor := c_cursor;
            p_resultnumber := 0;


    EXCEPTION

        WHEN e_invalidrerecepcion THEN
            p_resultnumber := Seg_Retornar_Cadena_Error(57, NULL, NULL);
        RETURN;

        WHEN OTHERS THEN
            v_bd_error := (SUBSTR('error '||TO_CHAR(SQLCODE)||': '||SQLERRM, 1, 255));
            p_resultnumber := Seg_Retornar_Cadena_Error(-1, v_bd_error, SQLCODE);
        RETURN;

    END;
    
--**************************************************************************************************
-- Program:  Get_DetallesRecaudacionPago
-- Description:(Detalle del resumen de recaudacion por Banco)
--**************************************************************************************************
PROCEDURE Get_DetallesRecaudacionPago(
        p_identidad_rec     IN SRE_ARCHIVOS_T.id_entidad_recaudadora%TYPE,
        p_fechaini          IN DATE,
        p_fechafin          IN DATE,
        p_iocursor          IN OUT t_cursor,
        p_resultnumber      OUT VARCHAR2)

IS
        e_invaliduser       EXCEPTION;
        v_bderror           VARCHAR(1000);
        v_fechainicio       date;
        v_fechafin          date;
        c_cursor            t_cursor;
BEGIN

         v_fechainicio:= trunc(p_fechaini);
         v_fechafin   := trunc(p_fechafin);
         
        OPEN c_cursor FOR
         select l.id_referencia_infotep, r.ID_ENTIDAD_RECAUDADORA , r.ENTIDAD_RECAUDADORA_DES, 
         SUM(l.total_pago_infotep) Total_Importe, e.razon_social, l.STATUS 
         from suirplus.sfc_liquidacion_infotep_t l
         join suirplus.sre_det_movimiento_recaudo_t d on d.id_referencia_isr = l.id_referencia_infotep
         join suirplus.sfc_entidad_recaudadora_t r on r.id_entidad_recaudadora = l.id_entidad_recaudadora
         join suirplus.sre_archivos_t a on a.id_recepcion = d.id_recepcion and a.id_tipo_movimiento = 'EP'
         join suirplus.sre_empleadores_t e on e.id_registro_patronal = l.id_registro_patronal
         where trunc(a.fecha_carga) BETWEEN  v_fechainicio and  v_fechafin
         and l.ID_ENTIDAD_RECAUDADORA = p_identidad_rec
         and d.fecha_aclaracion is null   
         
         GROUP BY l.id_referencia_infotep, e.razon_social, r.ID_ENTIDAD_RECAUDADORA, r.ENTIDAD_RECAUDADORA_DES, a.ID_ENTIDAD_RECAUDADORA, l.STATUS
         
        union all
         select li.id_referencia_infotep, r.ID_ENTIDAD_RECAUDADORA , r.ENTIDAD_RECAUDADORA_DES, 
         SUM(li.total_pago_infotep) Total_Importe, e.razon_social, li.STATUS 
         from suirplus.sfc_liquidacion_infotep_t li
         join suirplus.sre_det_movimiento_recaudo_t d on d.id_referencia_isr = li.id_referencia_infotep
         join suirplus.sfc_entidad_recaudadora_t r on r.id_entidad_recaudadora = li.id_entidad_recaudadora
         join suirplus.sre_archivos_t a on a.id_recepcion = d.id_recepcion and a.id_tipo_movimiento = 'AC'
         join suirplus.sre_empleadores_t e on e.id_registro_patronal = li.id_registro_patronal
         where trunc(a.fecha_carga) BETWEEN  v_fechainicio and  v_fechafin
         and li.ID_ENTIDAD_RECAUDADORA = p_identidad_rec
           
         GROUP BY li.id_referencia_infotep, e.razon_social, r.ID_ENTIDAD_RECAUDADORA, r.ENTIDAD_RECAUDADORA_DES, a.ID_ENTIDAD_RECAUDADORA, li.STATUS;
         p_iocursor := c_cursor;
         
        RETURN;


        EXCEPTION

        WHEN e_invaliduser THEN
            p_resultnumber := Seg_Retornar_Cadena_Error(1, NULL, NULL);
        RETURN;

        WHEN OTHERS THEN
            v_bderror := (SUBSTR('error '||TO_CHAR(SQLCODE)||': '||SQLERRM, 1, 255));
            p_resultnumber := Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
      RETURN;


END Get_DetallesRecaudacionPago;


--*************************************************************
-- Conocer la cantidad total de Pagos.
--(Detalle del resumen de recaudacion por Pagos)
--*************************************************************
    procedure get_cuenta_pagos( 
        p_entidad sfc_liquidacion_isr_v.ID_REFERENCIA_ISR%type,
        p_fechaini          IN DATE,
        p_fechafin          IN DATE,
        p_result_number out varchar,
        io_cursor       out t_cursor)
    is
       c_cursor        t_cursor;
       v_cuenta        number(1);
       v_fechainicio   date;
       v_fechafin      date;
    begin
       v_fechainicio:= trunc(p_fechaini);
       v_fechafin   := trunc(p_fechafin);
       open c_cursor for
       Select count(*) as cuenta from (
           SELECT l.id_referencia_infotep, r.ID_ENTIDAD_RECAUDADORA , r.ENTIDAD_RECAUDADORA_DES, 
               SUM(l.total_pago_infotep) Total_Importe, e.razon_social, l.STATUS
               from suirplus.sfc_entidad_recaudadora_t r
               join suirplus.sre_archivos_t a on a.id_entidad_recaudadora = r.id_entidad_recaudadora
               join suirplus.sre_det_movimiento_recaudo_t m on m.id_recepcion = a.id_recepcion and a.id_tipo_movimiento = 'EP'
               join suirplus.sfc_liquidacion_infotep_t l on l.id_referencia_infotep = m.id_referencia_isr 
               join suirplus.sre_empleadores_t e on e.id_registro_patronal = l.ID_REGISTRO_PATRONAL
               where trunc(a.fecha_carga) BETWEEN  v_fechainicio and  v_fechafin
               and l.id_entidad_recaudadora = p_entidad
               and m.fecha_aclaracion is null
           GROUP BY l.id_referencia_infotep, e.razon_social, r.ID_ENTIDAD_RECAUDADORA, r.ENTIDAD_RECAUDADORA_DES, a.ID_ENTIDAD_RECAUDADORA, l.STATUS);

        io_cursor := c_cursor;
        p_result_number:= Seg_Retornar_Cadena_Error(0, null, null);
        return;
end get_cuenta_pagos;

--*************************************************************
-- Conocer la cantidad total de Aclaraciones.
--(Detalle del resumen de recaudacion por aclaraciones)
--*************************************************************
    procedure get_cuenta_aclaraciones( 
        p_entidad sfc_liquidacion_isr_v.ID_REFERENCIA_ISR%type,
        p_fechaini          IN DATE,
        p_fechafin          IN DATE,
        p_result_number out varchar,
        io_cursor       out t_cursor)
    is
        c_cursor        t_cursor;
        v_cuenta        number(1);
        v_fechainicio   date;
        v_fechafin      date;
    begin
        v_fechainicio:= trunc(p_fechaini);
        v_fechafin   := trunc(p_fechafin);
        open c_cursor for
        Select count(*) as cuenta from (
        SELECT l.id_referencia_infotep, r.ID_ENTIDAD_RECAUDADORA , r.ENTIDAD_RECAUDADORA_DES, 
        SUM(l.total_pago_infotep) Total_Importe, e.razon_social, l.STATUS
        from suirplus.sfc_entidad_recaudadora_t r
        join suirplus.sre_archivos_t a on a.id_entidad_recaudadora = r.id_entidad_recaudadora
        join suirplus.sre_det_movimiento_recaudo_t m on m.id_recepcion = a.id_recepcion and a.id_tipo_movimiento = 'AC'
        join suirplus.sfc_liquidacion_infotep_t l on l.id_referencia_infotep =  m.id_referencia_isr
        join suirplus.sre_empleadores_t e on e.id_registro_patronal = l.ID_REGISTRO_PATRONAL
        where trunc(a.fecha_carga) BETWEEN  v_fechainicio and  v_fechafin
        and l.id_entidad_recaudadora = p_entidad
        GROUP BY l.id_referencia_infotep, e.razon_social, r.ID_ENTIDAD_RECAUDADORA, r.ENTIDAD_RECAUDADORA_DES, a.ID_ENTIDAD_RECAUDADORA, l.STATUS);

        io_cursor := c_cursor;
        p_result_number:= Seg_Retornar_Cadena_Error(0, null, null);
        return;
    end get_cuenta_aclaraciones;

-- **************************************************************************************************
-- Program:  Get_ResumenRecaudacion
-- Description:
-- **************************************************************************************************
PROCEDURE Get_ResumenRecaudacion(
        p_fechaini      IN DATE,
        p_fechafin      IN DATE,
        p_requerimiento IN VARCHAR,
        p_iocursor      IN OUT t_cursor,
        p_resultnumber  OUT VARCHAR2)

IS
        e_invaliduser   EXCEPTION;
        v_bderror       VARCHAR(1000);
        v_fechainicio   date;
        v_fechafin      date;

        c_cursor t_cursor;
BEGIN

       v_fechainicio:= trunc(p_fechaini);
       v_fechafin   := trunc(p_fechafin);

    IF (p_requerimiento = 'P') THEN
        OPEN c_cursor FOR
            -- Para los Pagos
        select r.ID_ENTIDAD_RECAUDADORA , r.ENTIDAD_RECAUDADORA_DES, SUM(l.total_pago_infotep) Total_Importe
            from suirplus.sfc_entidad_recaudadora_t r
            join suirplus.sre_archivos_t a on a.id_entidad_recaudadora = r.id_entidad_recaudadora and a.id_tipo_movimiento = 'EP'
            join suirplus.sre_det_movimiento_recaudo_t m on m.id_recepcion = a.id_recepcion and m.fecha_aclaracion is null
            join suirplus.sfc_liquidacion_infotep_t l on l.id_referencia_infotep = m.id_referencia_isr
         
        where trunc(a.fecha_carga) between v_fechainicio AND v_fechafin
        group by r.ID_ENTIDAD_RECAUDADORA , r.ENTIDAD_RECAUDADORA_DES
        order by r.id_entidad_recaudadora;
         
        p_iocursor := c_cursor;
        RETURN;     

    END IF;
    -- Para las Aclaraciones
    IF (p_requerimiento = 'A') THEN
     
        OPEN c_cursor FOR
        SELECT r.ID_ENTIDAD_RECAUDADORA , r.ENTIDAD_RECAUDADORA_DES, SUM(l.total_pago_infotep) total_importe
           from suirplus.sfc_entidad_recaudadora_t r
           join suirplus.SRE_ARCHIVOS_T a on a.id_entidad_recaudadora=r.id_entidad_recaudadora and a.id_tipo_movimiento='AC'
           join suirplus.SRE_DET_MOVIMIENTO_RECAUDO_T m on m.id_recepcion=a.id_recepcion
           join suirplus.sfc_liquidacion_infotep_t l on l.id_referencia_infotep=m.id_referencia_isr
        where trunc(a.fecha_carga) BETWEEN v_fechainicio AND v_fechafin
        group by r.ID_ENTIDAD_RECAUDADORA , r.ENTIDAD_RECAUDADORA_DES;
    
        p_iocursor := c_cursor;
        RETURN;
    END IF;

    IF (p_requerimiento = 'T') THEN
             OPEN c_cursor FOR
             SELECT r.ID_ENTIDAD_RECAUDADORA , r.ENTIDAD_RECAUDADORA_DES, pagos.sub_total_pagos, aclara.sub_total_aclaraciones,
             SUM(nvl(pagos.sub_total_pagos, 0) + nvl(aclara.sub_total_aclaraciones, 0))AS Total
             FROM SFC_ENTIDAD_RECAUDADORA_T r,
            (
             SELECT SUM(l.total_pago_infotep) sub_total_pagos, a.ID_ENTIDAD_RECAUDADORA
             from suirplus.sre_archivos_t a
             join suirplus.sre_det_movimiento_recaudo_t m on m.id_recepcion = a.id_recepcion and a.id_tipo_movimiento = 'EP'
             join suirplus.sfc_liquidacion_infotep_t l on l.id_referencia_infotep = m.id_referencia_isr
             where trunc(a.fecha_carga) BETWEEN v_fechainicio AND v_fechafin
             and m.fecha_aclaracion is null
             group by a.id_entidad_recaudadora           
            ) pagos,
            (
             SELECT SUM(l2.total_pago_infotep) sub_total_aclaraciones , a2.ID_ENTIDAD_RECAUDADORA
             from suirplus.sre_archivos_t a2
             join suirplus.sre_det_movimiento_recaudo_t m2 on m2.id_recepcion = a2.id_recepcion and a2.id_tipo_movimiento = 'AC'
             join suirplus.sfc_liquidacion_infotep_t  l2 on l2.id_referencia_infotep = m2.id_referencia_isr
             where trunc(a2.fecha_carga) BETWEEN v_fechainicio AND v_fechafin
             group by a2.id_entidad_recaudadora 
                          
            ) aclara
             WHERE pagos.ID_ENTIDAD_RECAUDADORA = r.ID_ENTIDAD_RECAUDADORA
             AND aclara.ID_ENTIDAD_RECAUDADORA(+) = r.ID_ENTIDAD_RECAUDADORA
             
             GROUP BY r.ENTIDAD_RECAUDADORA_DES, r.ID_ENTIDAD_RECAUDADORA , pagos.sub_total_pagos, aclara.sub_total_aclaraciones 
             order by r.id_entidad_recaudadora;
       END IF;
            p_iocursor := c_cursor;
            RETURN;

        EXCEPTION

        WHEN e_invaliduser THEN
            p_resultnumber := Seg_Retornar_Cadena_Error(1, NULL, NULL);
        RETURN;
        WHEN OTHERS THEN
            v_bderror := (SUBSTR('error '||TO_CHAR(SQLCODE)||': '||SQLERRM, 1, 255));
            p_resultnumber := Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
      RETURN;
END;  
-- **************************************************************************************************
-- Program:  Resumen Aclaraciones Pendientes
-- Description: Trae el todas las aclaraciones pendientes existentes.
-- ************************************************************************************************** 
PROCEDURE Get_Aclaraciones (
        p_iocursor       IN OUT t_cursor,
        p_resultnumber   OUT VARCHAR2)

IS
        v_bderror       VARCHAR(1000);
        c_cursor        t_cursor;
        v_rango1        DATE;
        v_rango2        DATE;
        v_fechaini      varchar2(20);
        v_fechafin      varchar2(20);
begin

        OPEN c_cursor FOR
            select b.id_entidad_recaudadora, b.entidad_recaudadora_des,
            'de '||to_char((trunc(a2.dias/7)+1)*7+1)||' a '||to_char((trunc(a2.dias/7)+1)*7+7)||' dias' as Periodo, sum(a2.monto) monto
            from sfc_entidad_recaudadora_t b,
           (select a.id_entidad_recaudadora, a.id_recepcion envio, sysdate-a.fecha_carga dias, a.id_tipo_movimiento tipo, d.secuencia_mov_recaudo linea,
                d.id_referencia_isr ref_isr, d.no_autorizacion no_aut, d.monto, d.status,d.id_error,e.error_des descripcion
            from suirplus.sre_archivos_t a
            join suirplus.sre_tmp_movimiento_recaudo_t d on d.id_recepcion=a.id_recepcion and d.status='AC'
            join suirplus.seg_error_t e on e.id_error=d.id_error 
            where a.id_tipo_movimiento='EP' 
            and a.status<>'N'
            and a.nombre_archivo like 'INFOTEP%'
            and not exists (select 1 from suirplus.sre_tmp_movimiento_recaudo_t x -- ningun registro de pago
                            where x.lote_aclaracion=d.id_recepcion 
                            and x.secuencia_aclaracion=d.secuencia_mov_recaudo
                            and x.status='OK')) a2
                            
            where a2.id_entidad_recaudadora=b.id_entidad_recaudadora   
            and not exists (select 1 from suirplus.sfc_liquidacion_infotep_t y -- que aun no este pagada la referencia ni el numero de autorizacion
                            where y.id_referencia_infotep = a2.ref_isr and y.status ='PA' 
                            and y.id_entidad_recaudadora=a2.id_entidad_recaudadora)                            
            and not exists (select 1 from suirplus.sfc_liquidacion_infotep_t z -- que aun no este pagada la autorizacion
                where z.no_autorizacion=to_number(a2.no_aut) and z.status='PA' 
                and z.id_entidad_recaudadora = a2.id_entidad_recaudadora)                
                         
            group by b.id_entidad_recaudadora, b.entidad_recaudadora_des,'de '||to_char((trunc(a2.dias/7)+1)*7+1)||' a '||to_char((trunc(a2.dias/7)+1)*7+7)||' dias';
  
            p_iocursor := c_cursor;
            
            RETURN;

            EXCEPTION

            WHEN OTHERS THEN
                v_bderror := (SUBSTR('error '||TO_CHAR(SQLCODE)||': '||SQLERRM, 1, 255));
                p_resultnumber := Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
          RETURN;

    END; 

-- **************************************************************************************************
-- Program:  Get_DetallesAclaraciones(Detalle del resumen de las aclaraciones)
-- Description:Trae el detalle de las aclaraciones pendientes por banco
-- **************************************************************************************************
PROCEDURE Get_DetallesAclaraciones (
        p_identidad_rec     IN SRE_ARCHIVOS_T.id_entidad_recaudadora%TYPE,
        p_iocursor          IN OUT t_cursor,
        p_resultnumber      OUT VARCHAR2)

IS
        e_invaliduser       EXCEPTION;
        v_bderror           VARCHAR(1000);
        c_cursor t_cursor;

BEGIN
        OPEN c_cursor FOR
            
 select b.id_entidad_recaudadora, b.entidad_recaudadora_des, a.lote_secuencia, a.clave_transaccion, 
        a.ref_isr, a.no_aut, a.monto, a.status, a.envio
        from sfc_entidad_recaudadora_t b,
         (select a.id_entidad_recaudadora,
             a.id_recepcion envio,
             a.id_tipo_movimiento,
             d.id_referencia_isr as ref_isr,
             d.no_autorizacion as no_aut,
             d.monto,
             d.status,
             d.id_error,e.error_des descripcion,
             d.secuencia_mov_recaudo as lote_secuencia,
             d.clave_transaccion             
      from suirplus.sre_archivos_t a
      join suirplus.sre_tmp_movimiento_recaudo_t d on d.id_recepcion=a.id_recepcion and d.status='AC'
      join suirplus.seg_error_t e on e.id_error=d.id_error 
      where a.id_tipo_movimiento='EP' 
      and a.status<>'N'
      and a.nombre_archivo like 'INFOTEP%'
      and not exists (select 1 from suirplus.sre_tmp_movimiento_recaudo_t x -- ningun registro de pago
                      where x.lote_aclaracion=d.id_recepcion 
                      and x.secuencia_aclaracion=d.secuencia_mov_recaudo
                      and x.status='OK')) a
    where a.id_entidad_recaudadora=b.id_entidad_recaudadora
    and b.id_entidad_recaudadora = p_identidad_rec
    and not exists (select 1 from suirplus.sfc_liquidacion_infotep_t y -- que aun no este pagada la referencia
                where y.id_referencia_infotep=a.ref_isr and y.status='P' 
                and y.ID_ENTIDAD_RECAUDADORA=a.id_entidad_recaudadora)
    and not exists (select 1 from suirplus.sfc_liquidacion_infotep_t z -- que aun no este pagada la autorizacion
                where z.no_autorizacion=to_number(a.no_aut) and z.status='P' 
                and z.ID_ENTIDAD_RECAUDADORA=a.id_entidad_recaudadora)
    order by b.id_entidad_recaudadora,a.envio,a.lote_secuencia;            
            
            
            p_iocursor := c_cursor;
     
        RETURN;


    EXCEPTION

        WHEN e_invaliduser THEN
            p_resultnumber := Seg_Retornar_Cadena_Error(1, NULL, NULL);
        RETURN;

        WHEN OTHERS THEN
            v_bderror := (SUBSTR('error '||TO_CHAR(SQLCODE)||': '||SQLERRM, 1, 255));
            p_resultnumber := Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
      RETURN;


END;

-- **************************************************************************************************
-- Program:  validarLiquidacion
-- Description:Verifica el status de una liquidacion de infotep
--Autor: Eury Vallejo
-- **************************************************************************************************
function validarLiquidacion(p_liquidacion in sfc_liquidacion_infotep_t.id_referencia_infotep%type) RETURN VARCHAR
is 
v_status varchar2(2) default null;
v_no_autorizacion suirplus.sfc_liquidacion_isr_t.no_autorizacion%type;
e_liquidacionNoexiste exception;
e_liquidacionPagada exception;
e_liquidacionCancelada exception;
e_liquidacionVencida exception;
e_liquidacionInhabilidataPago exception;
v_bderror           VARCHAR(1000);
counter integer;
begin

select count(*)
into counter
from sfc_liquidacion_infotep_t t 
where t.id_referencia_infotep = p_liquidacion;

if counter > 0 then
select t.status,t.no_autorizacion
into v_status,v_no_autorizacion
from sfc_liquidacion_infotep_t t 
where t.id_referencia_infotep = p_liquidacion;  
end if;


if v_status is null then
   raise e_liquidacionNoexiste;
else
  if v_status = 'PA' then
     raise e_liquidacionPagada;
  end if;
  if v_status = 'CA' then
     raise e_liquidacionCancelada;
  end if;
  if v_status = 'IN' then
     raise  e_liquidacionInhabilidataPago;
  end if;
end if;

return 'OK';
  
EXCEPTION
WHEN e_liquidacionNoexiste THEN
   return Seg_Retornar_Cadena_Error('WS001', NULL, NULL); 
WHEN e_liquidacionPagada THEN
    return Seg_Retornar_Cadena_Error('WS002', NULL, NULL);           
WHEN e_liquidacionCancelada THEN
     return Seg_Retornar_Cadena_Error('WS003', NULL, NULL);           
WHEN e_liquidacionVencida THEN
     return Seg_Retornar_Cadena_Error('WS004', NULL, NULL);
WHEN e_liquidacionInhabilidataPago THEN
     return Seg_Retornar_Cadena_Error('WS005', NULL, NULL);
WHEN OTHERS THEN
     v_bderror := (SUBSTR('error '||TO_CHAR(SQLCODE)||': '||SQLERRM, 1, 255));
     return Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);          

END validarLiquidacion;

-- **************************************************************************************************
-- Program:  MarcarPagada
-- Description:Para marcar una liquidacion como pagada
--Autor: Eury Vallejo
-- **************************************************************************************************
procedure MarcarPagada(p_usuario in seg_usuario_t.id_usuario%type,
                       p_liquidacion in sfc_liquidacion_infotep_t.id_referencia_infotep%type,
                       p_fecha_pago in sfc_liquidacion_infotep_t.fecha_pago%type,
                       p_entidad_recaudadora in sfc_liquidacion_infotep_t.id_entidad_recaudadora%type,
                       p_resultado OUT VARCHAR2) Is
counter integer;
v_resultado varchar2(1000);
v_fechaEmision date;
v_EntidadRecaudadora integer;
e_fechapagoInvalida exception; 
e_entidadRecaudadora exception; 
e_liquidacionNoexiste exception;
e_fechafutura exception;
v_bderror           VARCHAR(1000);
BEGIN


select count(*)
into counter
from sfc_liquidacion_infotep_t t 
where t.id_referencia_infotep = p_liquidacion;

if counter > 0 then


if p_fecha_pago > sysdate then
raise e_fechafutura;
end if;


/*Validamos que la fecha pago sea mayor o igual a la fecha emision*/
select li.fecha_emision
into v_fechaEmision
from suirplus.sfc_liquidacion_infotep_t li
where li.id_referencia_infotep = p_liquidacion;

if v_fechaEmision > p_fecha_pago then
raise e_fechapagoInvalida;
end if;

/*Validamos que la entidad recaudadora exista en nuestra base de datos*/
select count(*) 
into v_EntidadRecaudadora
from sfc_entidad_recaudadora_t en 
where en.id_entidad_recaudadora = p_entidad_recaudadora
and en.bancosrecaudadoresinf = 1;

if v_EntidadRecaudadora = 0 then
raise e_entidadRecaudadora;
end if;

/*Validamos que la liquidacion este con un estatus valido para pagarse*/
v_resultado := suirplus.sfc_infotep_pkg.validarLiquidacion(p_liquidacion);

if v_resultado = 'OK' then
update suirplus.sfc_liquidacion_infotep_t l
set l.status             = 'PA',
l.id_entidad_recaudadora = p_entidad_recaudadora,                            
l.fecha_pago             = p_fecha_pago,
l.ult_usuario_act        = upper(p_usuario),
l.ult_fecha_act          = sysdate
where l.id_referencia_infotep = p_liquidacion;
commit;
end if;

p_resultado := v_resultado;

ELSE
    raise e_liquidacionNoexiste;
END IF;

EXCEPTION
  WHEN e_liquidacionNoexiste THEN
   p_resultado := Seg_Retornar_Cadena_Error('WS001', NULL, NULL); 
WHEN e_fechapagoInvalida THEN
     p_resultado := Seg_Retornar_Cadena_Error('WS006', NULL, NULL);
WHEN e_entidadRecaudadora THEN
     p_resultado := Seg_Retornar_Cadena_Error('WS007', NULL, NULL);
WHEN e_fechafutura THEN
     p_resultado := Seg_Retornar_Cadena_Error('WS012', NULL, NULL);
WHEN OTHERS THEN
 v_bderror := (SUBSTR('error '||TO_CHAR(SQLCODE)||': '||SQLERRM, 1, 255));
 p_resultado := Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
END;

-- **************************************************************************************************
-- Program:  MarcarCancelada
-- Description:Para marcar una liquidacion como Cancelada
--Autor: Eury Vallejo
-- **************************************************************************************************
procedure MarcarCancelada(p_usuario in seg_usuario_t.id_usuario%type,
                       p_liquidacion in sfc_liquidacion_infotep_t.id_referencia_infotep%type,
                       p_resultado OUT VARCHAR2) Is
counter integer;
v_status varchar(2);
v_no_autorizacion suirplus.sfc_liquidacion_isr_t.no_autorizacion%type;
v_fecha_desautorizacion suirplus.sfc_liquidacion_isr_t.fecha_desautorizacion%type;
v_fecha_autorizacion suirplus.sfc_liquidacion_isr_t.fecha_autorizacion%type;
v_autorizacion suirplus.sfc_liquidacion_infotep_t.no_autorizacion%type;
v_bderror           VARCHAR(1000);
e_liquidacionNoexiste exception;
e_liquidacionCancelada exception;
e_liquidacionPagada exception;
BEGIN


select count(*)
into counter
from sfc_liquidacion_infotep_t t 
where t.id_referencia_infotep = p_liquidacion;

if counter > 0 then

/*Validamos que la liquidacion este con un estatus valido para cancelarse*/
select t.status,t.fecha_autorizacion,t.fecha_desautorizacion,t.no_autorizacion
into v_status,v_fecha_autorizacion,v_fecha_desautorizacion,v_autorizacion
from sfc_liquidacion_infotep_t t 
where t.id_referencia_infotep = p_liquidacion
group by t.status,t.fecha_autorizacion,t.fecha_desautorizacion,t.no_autorizacion;

IF (v_status <> 'PA' and v_status <> 'CA' and v_autorizacion is null) THEN
 update suirplus.sfc_liquidacion_infotep_t l
    set l.status = 'CA',
        l.fecha_cancela = sysdate,
        l.ult_fecha_act = sysdate,
        l.ult_usuario_act = upper(p_usuario)
  where l.id_referencia_infotep = p_liquidacion;
  commit;
  p_resultado := 'OK';


ELSIF (v_status = 'PA' and (v_fecha_desautorizacion is not null and v_fecha_desautorizacion > v_fecha_autorizacion )) THEN
update suirplus.sfc_liquidacion_infotep_t l
       set l.status = 'CA',
            l.fecha_cancela = sysdate,
            l.ult_fecha_act = sysdate,
            l.ult_usuario_act = upper(p_usuario)
where l.id_referencia_infotep = p_liquidacion;
COMMIT;
p_resultado := 'OK';

ELSIF (v_status = 'CA') THEN
 raise e_liquidacionCancelada;

ELSIF v_autorizacion is not null THEN
 raise e_liquidacionPagada; 
END IF;

ELSE
    raise e_liquidacionNoexiste;
END IF;

EXCEPTION
WHEN e_liquidacionNoexiste THEN
   p_resultado := Seg_Retornar_Cadena_Error('WS001', NULL, NULL); 
WHEN e_liquidacionCancelada THEN
     p_resultado := Seg_Retornar_Cadena_Error('WS003', NULL, NULL);   
WHEN e_liquidacionPagada THEN
    p_resultado := Seg_Retornar_Cadena_Error('WS002', NULL, NULL);        
WHEN OTHERS THEN
 v_bderror := (SUBSTR('error '||TO_CHAR(SQLCODE)||': '||SQLERRM, 1, 255));
 p_resultado := Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
END;

-- **************************************************************************************************
-- Program:  PagaInfotep
-- Description:Para marcar una empresa, indicando que paga infotep
--Autor: Eury Vallejo
-- **************************************************************************************************
procedure PagaInfotep(p_usuario in seg_usuario_t.id_usuario%type,
                       p_rnc in sre_empleadores_t.rnc_o_cedula%type,
                       p_resultado OUT VARCHAR2) Is
e_rncInvalido exception;
v_bderror           VARCHAR(1000);
e_empleadorPagaInfotep exception;
v_status varchar(1);
v_pagainfotep varchar(1);
e_rncBaja exception;
e_rncSuspendido exception;
e_rncNoExiste exception;
v_count number;
BEGIN

select count(*)
into v_count
from sre_empleadores_t e
where e.rnc_o_cedula = p_rnc;

if v_count > 0 then


v_status := suirplus.sre_empleadores_pkg.isrncocedularetornarestatus(p_rnc);

IF v_status = 'A' THEN
  
select e.paga_infotep
into v_pagainfotep
from SRE_EMPLEADORES_T e
where e.rnc_o_cedula = p_rnc;

IF v_pagainfotep is null THEN
  
update suirplus.sre_empleadores_t e 
set e.paga_infotep = 'S',
e.ult_fecha_act = sysdate,
e.ult_usuario_act = upper(p_usuario)
where e.rnc_o_cedula = p_rnc;
commit;
p_resultado := 'OK';

ELSE
raise e_empleadorPagaInfotep;
END IF;

ELSIF v_status = 'B' THEN
   raise e_rncBaja;
ELSIF v_status = 'S' THEN
 raise e_rncSuspendido;
ELSE
 raise e_rncInvalido;
END IF;

ELSE
 raise e_rncNoExiste;  
END IF;


EXCEPTION
WHEN e_rncInvalido THEN
   p_resultado := Seg_Retornar_Cadena_Error('WS011', NULL, NULL); 
WHEN e_empleadorPagaInfotep THEN
   p_resultado := Seg_Retornar_Cadena_Error('WS009', NULL, NULL); 
   WHEN e_rncBaja THEN
   p_resultado := Seg_Retornar_Cadena_Error('WS015', NULL, NULL); 
   WHEN e_rncSuspendido THEN
   p_resultado := Seg_Retornar_Cadena_Error('WS016', NULL, NULL); 
   WHEN e_rncNoExiste THEN
   p_resultado := Seg_Retornar_Cadena_Error('WS017', NULL, NULL); 
   
WHEN OTHERS THEN
 v_bderror := (SUBSTR('error '||TO_CHAR(SQLCODE)||': '||SQLERRM, 1, 255));
 p_resultado := Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
END;

-- **************************************************************************************************
-- Program:  NoPagaInfotep
-- Description:Para marcar una empresa, indicando que No paga infotep
--Autor: Eury Vallejo
-- **************************************************************************************************
procedure NoPagaInfotep(p_usuario in seg_usuario_t.id_usuario%type,
                       p_rnc in sre_empleadores_t.rnc_o_cedula%type,
                       p_resultado OUT VARCHAR2) Is
e_rncInvalido exception;
v_bderror           VARCHAR(1000);
e_empleadorNoPagaInfotep exception;
v_status varchar(1);
v_pagaNoInfotep varchar(1);
e_rncBaja exception;
e_rncSuspendido exception;
e_rncNoExiste exception;
v_count number;
BEGIN

select count(*)
into v_count
from sre_empleadores_t e
where e.rnc_o_cedula = p_rnc;

if v_count > 0 then

v_status := suirplus.sre_empleadores_pkg.isrncocedularetornarestatus(p_rnc);
IF v_status = 'A' THEN  

select e.paga_infotep
into v_pagaNoInfotep
from SRE_EMPLEADORES_T e
where e.rnc_o_cedula = p_rnc;

IF v_pagaNoInfotep is not null THEN

update suirplus.sre_empleadores_t e 
               set e.paga_infotep = null,
                   e.ult_fecha_act = sysdate,
                   e.ult_usuario_act = upper(p_usuario)
             where e.rnc_o_cedula = p_rnc;
commit;
p_resultado := 'OK';
ELSE
  raise e_empleadorNoPagaInfotep;
END IF;
ELSIF v_status = 'B' THEN
   raise e_rncBaja;
ELSIF v_status = 'S' THEN
 raise e_rncSuspendido;
 
ELSE
  raise e_rncInvalido;
END IF;
ELSE
 raise e_rncNoExiste;  
END IF;

EXCEPTION
WHEN e_rncInvalido THEN
   p_resultado := Seg_Retornar_Cadena_Error('WS011', NULL, NULL); 
WHEN e_empleadorNoPagaInfotep THEN
   p_resultado := Seg_Retornar_Cadena_Error('WS008', NULL, NULL); 
    WHEN e_rncBaja THEN
   p_resultado := Seg_Retornar_Cadena_Error('WS015', NULL, NULL); 
   WHEN e_rncSuspendido THEN
   p_resultado := Seg_Retornar_Cadena_Error('WS016', NULL, NULL); 
    WHEN e_rncNoExiste THEN
   p_resultado := Seg_Retornar_Cadena_Error('WS017', NULL, NULL); 
WHEN OTHERS THEN
 v_bderror := (SUBSTR('error '||TO_CHAR(SQLCODE)||': '||SQLERRM, 1, 255));
 p_resultado := Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
END;

End sfc_infotep_pkg;