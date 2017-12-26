CREATE OR REPLACE PACKAGE BODY DVA_MANEJO_PKG AS
  ---**********************************************************************************************----
  -- Milciades Hernandez
  -- 24-Abril-2009
  -- get_Reclamaciones
  -- Busca las reclamaciones de acuerdo a los parametros especificados..
  ---**********************************************************************************************----
  -- Version: 1.1
  -- Fecha  : 30-Abril-2009
  -- Autor  : Gregorio Herrera
  -- Asunto : Poner logica de negocio para llenar vista DVA_SIPEN_T
  -- Modificaciones:
  --  Se a?ade el procedimiento "bitacora"
  --  Se a?ade el procedimiento "enviar_sipen"
  ---**********************************************************************************************----

  m_id_bitacora     SFC_BITACORA_T.id_bitacora%TYPE;

  -- ==============================================
  -- Insertar el registro en la maestra de bitacora
  -- ==============================================
  procedure bitacora (
  	p_id_bitacora IN OUT SFC_BITACORA_T.id_bitacora%TYPE,
  	p_accion      IN VARCHAR2 DEFAULT 'INI',
  	p_id_proceso  IN SFC_BITACORA_T.id_proceso%TYPE,
  	p_mensage     IN SFC_BITACORA_T.mensage%TYPE DEFAULT NULL,
  	p_status      IN SFC_BITACORA_T.status%TYPE DEFAULT NULL,
  	p_id_error    IN SEG_ERROR_T.id_error%TYPE DEFAULT NULL,
  	p_seq_number  IN ERRORS.seq_number%TYPE DEFAULT NULL,
  	p_periodo     IN SFC_BITACORA_T.periodo%TYPE DEFAULT NULL
  ) is
  Begin
  	CASE p_accion
  	WHEN 'INI' THEN
      SELECT sfc_bitacora_seq.NEXTVAL INTO p_id_bitacora FROM dual;
      INSERT INTO SFC_BITACORA_T(id_proceso, id_bitacora, fecha_inicio, fecha_fin, mensage, status, periodo)
          VALUES(p_id_proceso, p_id_bitacora, SYSDATE, NULL, p_mensage, 'P', p_periodo);

  	WHEN 'FIN' THEN
      UPDATE SFC_BITACORA_T
         SET fecha_fin   = SYSDATE,
             mensage     = p_mensage,
             status      = p_status,
             seq_number  = p_seq_number,
             id_error    = p_id_error
  		 WHERE id_bitacora = p_id_bitacora;
  	ELSE
  		RAISE_APPLICATION_ERROR(010, 'Parametro invalido');
  	END CASE;
  	COMMIT;
  End;
---**********************************************************************************************----
-- Milciades Hernandez
-- 24-Abril-2009
-- get_Reclamaciones
-- Busca las Reclamaiones de acuerdo a los parametros especificados.
---**********************************************************************************************----
 Procedure get_Reclamaciones (
        p_desde            IN date,
        p_hasta            IN date,
        p_rnc              IN sre_empleadores_t.rnc_o_cedula%type,
        p_nro_reclamacion  IN dva_registros_t.nro_reclamacion%TYPE,
        p_estatus          IN dva_registros_t.id_status%type,
        p_pagenum          in number,
        p_pagesize         in number,
        p_resultnumber     OUT varchar2,
        p_io_cursor        IN OUT t_cursor)
   IS
        v_cursor t_cursor;
        e_Existe_Empleador exception;
        e_Existe_Reclamacion exception;
        v_regPatronal varchar2(9);
        vDesde integer := (p_pagesize*(p_pagenum-1))+1;
        vhasta integer := p_pagesize*p_pagenum;


 BEGIN

  IF p_rnc is not null THEN
     IF not sre_empleadores_pkg.isRncOCedulaValida(p_Rnc) THEN
        raise e_Existe_Empleador;
     END IF;

     select e.id_registro_patronal into v_regPatronal
     from sre_empleadores_t e
     where e.rnc_o_cedula= p_rnc;
  END IF;

  --Validamos si existe la reclamacion
    IF p_nro_reclamacion is not null THEN
     IF not dva_manejo_pkg.IsExisteReclamacion(p_nro_reclamacion) THEN
        raise e_Existe_Reclamacion ;
     END IF;
  END IF;

    OPEN v_cursor FOR
      with x as (select rownum num,y.* from (
           SELECT r.Nro_Reclamacion,
                 e.rnc_o_cedula Rnc,
                 INITCAP(e.Razon_social) Razon_Social,
                 nvl("Cantidad_Registros",'0') Cantidad_Registros,nvl("MONTO_TOTAL",'0.00')MONTO_TOTAL,
                 t.id_status,
                 INITCAP(t.descripcion) Estatus,
                 r.Fecha_Solicitud,
                 r.Fecha_Envio,
                 r.Fecha_Cancelacion,
                 r.Fecha_Devolucion,
                 r.Fecha_Respuesta,
                 r.nro_cheque,r.nro_documento,r.tipo_documento,InitCap(r.entregado_por)entregado_por
              FROM dva_registros_t r ,
                   sre_empleadores_t e,  (SELECT dt.nro_reclamacion, COUNT(DT.NRO_RECLAMACION)"Cantidad_Registros", sum(dt.monto_devolucion)"MONTO_TOTAL"
                                           FROM dva_det_registros_t dt
                                          WHERE DT.NRO_RECLAMACION = nro_reclamacion
                                          group by dt.nro_reclamacion
                                          ) d,
                   dva_status_t t
              WHERE r.id_registro_patronal = e.id_registro_patronal
              and d.nro_reclamacion(+) = r.nro_reclamacion
              and  r.nro_reclamacion = decode(p_nro_reclamacion,null,r.nro_reclamacion,p_nro_reclamacion)
              and  r.id_registro_patronal = decode(v_regPatronal,null,r.id_registro_patronal,v_regPatronal)
              and  inStr(decode(p_estatus,null,r.id_status,'T',r.id_status,p_estatus),r.id_status)>0
              and trunc(nvl(r.fecha_respuesta, sysdate)) between decode(p_desde,null,trunc(nvl(r.fecha_respuesta,sysdate)),p_desde)
                     and decode(p_hasta,null,trunc(nvl(r.fecha_respuesta,sysdate)),p_hasta)
              and t.id_status = r.id_status
         )y) select y.recordcount,x.*
                 from x,(select max(num) recordcount from x) y
                where num between (vDesde) and (vHasta)
                order by x.nro_reclamacion desc;

       p_io_cursor := v_cursor;
       p_resultnumber := 0;

 EXCEPTION
      WHEN e_Existe_Empleador THEN
           p_resultnumber := Seg_Retornar_Cadena_Error(64, NULL, NULL);
      RETURN;

      WHEN e_Existe_Reclamacion THEN
           p_resultnumber := Seg_Retornar_Cadena_Error(223, NULL, NULL);
      RETURN;

       WHEN OTHERS THEN
          v_bderror := (SUBSTR('error '||TO_CHAR(SQLCODE)||': '||SQLERRM, 1, 255));
          p_resultnumber := Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
        RETURN;

   END get_Reclamaciones;

---**********************************************************************************************----
-- Milciades Hernandez
-- 24-Abril-2009
-- get_Det_Reclamacion
-- Busca los detalles las Reclamaiones de acuerdo a los parametros especificados.
---**********************************************************************************************----
 Procedure get_Det_Reclamacion (
        p_nro_reclamacion  IN dva_registros_t.nro_reclamacion%TYPE,
        p_estatus          IN dva_registros_t.id_status%type,
        p_pagenum          in number,
        p_pagesize         in number,
        p_resultnumber     OUT varchar2,
        p_io_cursor        IN OUT t_cursor)
   IS
   e_Existe_Reclamacion exception;

   v_cursor  t_cursor;
   vDesde integer := (p_pagesize*(p_pagenum-1))+1;
   vhasta integer := p_pagesize*p_pagenum;

 BEGIN

   --Validamos si existe la reclamacion
    IF (p_nro_reclamacion is not null) and (p_estatus is not null) THEN
     IF not dva_manejo_pkg.IsExisteReclamacion(p_nro_reclamacion) THEN
        raise e_Existe_Reclamacion ;
     END IF;
  END IF;


      OPEN v_cursor FOR
           with x as (select rownum num,y.* from (
              SELECT dv.id_referencia, "Trabajador", dv.secuencia,
                     INITCAP(decode(dv.tipo_reclamacion,'T','Total','P','Parcial')) as Tipo_Reclamacion,
                     INITCAP(decode(dv.motivo_devolucion,	'001','Devolucion total de fondos a empleadores',
                                                  '002','Devolucion pacial de fondos a empleadores',
                                                  '003','Tranferencia de fondos de CCI a CCI',
                                                  '004','Tranferencia de fondos para unificaion de CCI',
                                                  '005','Devolucion de fondos por desafiliacion')) as Motivo_Devolucion,
                      dv.salario, dv.monto_devolucion,(dv.monto_devolucion_resp+dv.monto_rentabilidad_resp+dv.monto_otros+dv.interes_otros)Total_Devolver,
                     dv.cuenta_personal, dv.seguro_vida, dv.aporte_voluntario,
                     dv.comision_afp, dv.interes_cpe, dv.interes_seguro_vida,
                     dv.interes_apo, dv.interes_afp, dv.recargo_svds,
                     INITCAP(decode(dv.status,'GE','Generado por la TSS','OK','Aprobado',
                       'RE','Rechazado')) Estatus,cr.descripcion Motivo_Rechazo,
                     dv.fecha_registro
                FROM dva_registros_t r ,
                     dva_det_registros_t dv,dva_condicion_reclamos_t cr,(
                                             select c.id_nss, c.id_nss||'-'||initcap(trim(c.nombres || ' ' || c.primer_apellido || ' ' ||c.segundo_apellido))"Trabajador"
                                             from sre_ciudadanos_t c
                                             where c.id_nss = id_nss
                                             )ciu
              WHERE r.nro_reclamacion = dv.nro_reclamacion
                and dv.id_condicion= cr.id_condicion(+)
                and ciu.id_nss(+) = dv.id_nss
                AND dv.status = decode(p_estatus,'T',dv.status,p_estatus)
                AND dv.nro_reclamacion = p_nro_reclamacion
                ORDER BY  DV.NRO_RECLAMACION DESC
             )y) select y.recordcount,x.*
            from x,(select max(num) recordcount from x) y
            where num between (vDesde) and (vHasta)
            order by num;


       p_io_cursor := v_cursor;
       p_resultnumber := 0;

 EXCEPTION

       WHEN e_Existe_Reclamacion THEN
           p_resultnumber := Seg_Retornar_Cadena_Error(223, NULL, NULL);
      RETURN;

      WHEN OTHERS THEN
          v_bderror := (SUBSTR('error '||TO_CHAR(SQLCODE)||': '||SQLERRM, 1, 255));
          p_resultnumber := Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
      RETURN;

   END get_Det_Reclamacion;

---**********************************************************************************************----
-- Milciades Hernandez
-- IsExisteReclamacion
-- 24-Abril-2009
-- Verifica si el Numero de Reclamacion existe
---**********************************************************************************************----
FUNCTION IsExisteReclamacion(p_Nro_Reclamacion  IN  dva_registros_t.nro_reclamacion%type) RETURN BOOLEAN
IS


CURSOR c_existe_Reclamacion IS

SELECT t.nro_reclamacion FROM dva_registros_t t WHERE t.nro_reclamacion = p_Nro_Reclamacion;
returnValue BOOLEAN;
v_reclamacion VARCHAR(22);

BEGIN
OPEN c_existe_Reclamacion;
	 FETCH c_existe_Reclamacion INTO v_reclamacion;
	 returnValue := c_existe_Reclamacion%FOUND;
	 CLOSE c_existe_Reclamacion;

	 RETURN(returnValue);
EXCEPTION WHEN NO_DATA_FOUND THEN
  RETURN FALSE;
END IsExisteReclamacion ;

---**********************************************************************************************----
-- Milciades Hernandez
-- MarcarReclamacion
-- 24-Abril-2009
-- Modifica el estatus de las Reclamacion
---**********************************************************************************************----
procedure MarcarReclamacion (
     p_nro_reclamacion  in dva_registros_t.nro_reclamacion%TYPE,
     p_status           in varchar2,
     p_resultnumber     out varchar2
     )
     is
BEGIN
if (p_nro_reclamacion is not null)and(p_status is not null)then
 if (p_status = 'CA')then
    --marcamos el registro como cancelado
    UPDATE dva_registros_t
     SET id_status = p_status,
         fecha_cancelacion = TRUNC(SYSDATE)
     WHERE  nro_reclamacion = p_nro_reclamacion;

    p_resultnumber := 0;
    COMMIT;
else
    UPDATE dva_registros_t
     SET id_status = p_status
     WHERE  nro_reclamacion = p_nro_reclamacion;

    p_resultnumber := 0;
    COMMIT;
 end if;
end if;
 EXCEPTION WHEN OTHERS THEN
     v_bderror := (SUBSTR('error '||TO_CHAR(SQLCODE)||': '||SQLERRM, 1, 255));
     p_resultnumber := Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
   ROLLBACK;
end MarcarReclamacion;

  -- ==============================================
  -- Insertar el registro en el esquema UNIPAGO
  -- ==============================================
  procedure enviar_UNIPAGO(p_nro_reclamacion dva_registros_t.nro_reclamacion%type, p_result out varchar2) is
    --Para verificar la existencia de la reclamacion y el estatus de la misma
    cursor c_estado is
      select nro_reclamacion, id_status
      from dva_registros_t
      where nro_reclamacion = p_nro_reclamacion;

    l_estado     dva_registros_t.id_status%type := null;
    c_mail_ok    sfc_procesos_t.lista_ok%type;
    c_mail_error sfc_procesos_t.lista_error%type;
  Begin
    -- Insertamos el registro en la bitacora
    BITACORA(m_id_bitacora, 'INI', 'ES');

    for c_proceso in(select lista_ok, lista_error from sfc_procesos_t p where p.id_proceso = 'ES') loop
      c_mail_ok    := c_proceso.lista_ok;
      c_mail_error := c_proceso.lista_error;
    end loop;

    p_result := 'OK';

    -- para examinar la existencia de la reclamacion y a la vez el estatus de la misma
    for r_estado in c_estado loop
      l_estado := r_estado.id_status;
    end loop;

    -- validamos si la reclamacion existe y el estatus en que se encuentra
    if (l_estado is null) then
      p_result := 'El nro. de reclamacion indicado "'||p_nro_reclamacion||'" no existe.';
      BITACORA(m_id_bitacora, 'FIN', 'ES', p_result, 'E', '650');
      system.html_mail('info@mail.tss2.gov.do', c_mail_error, 'Actualizacion vista UNIPAGO.TSS_SOLICITUDES_DEVOLUCION_MV', 'Error en actualizacion vista UNIPAGO.TSS_SOLICITUDES_DEVOLUCION_MV para nro reclmacion="'||p_nro_reclamacion||'"<br>Error='||p_result);
      RETURN;
    elsif (l_estado != 'EN') then
      p_result := 'El estatus en el que se encuenta el nro. de reclamacion indicado "'||p_nro_reclamacion||'" no se corresponde con el proceso.';
      BITACORA(m_id_bitacora, 'FIN', 'ES', p_result, 'E', '650');
      system.html_mail('info@mail.tss2.gov.do', c_mail_error, 'Actualizacion vista UNIPAGO.TSS_SOLICITUDES_DEVOLUCION_MV', 'Error en actualizacion vista UNIPAGO.TSS_SOLICITUDES_DEVOLUCION_MV para nro reclmacion="'||p_nro_reclamacion||'"<br>Error='||p_result);
      RETURN;
    end if;

    --Limpiamos toda la tabla antes de publicar
    delete from unipago.tss_solicitudes_devolucion_mv;
    commit;

    --Procedemos a pasar los registros a la vista DVA_SIPEN_T del esquema suirplus
    insert into unipago.tss_solicitudes_devolucion_mv
    (
     n_no_reclamacion,
     c_tipo_reclamacion,
     c_rnc,
     n_registro_patronal,
     n_nss,
     n_no_referencia,
     n_num_detalle,
     n_monto_cp,
     n_monto_sva,
     n_monto_apo,
     n_monto_afp,
     n_monto_ape,
     n_interes_cp,
     n_interes_sva,
     n_interes_apo,
     n_interes_afp,
     n_monto_rec,
     n_motivo_dev,
     d_fecha_reclamacion
    )

    select a.nro_reclamacion,
           b.tipo_reclamacion,
           e.rnc_o_cedula,
           a.id_registro_patronal,
           b.id_nss,
           d.id_referencia,
           d.secuencia,
           b.cuenta_personal,
           b.seguro_vida,
           b.aporte_voluntario,
           b.comision_afp,
           0,
           b.interes_cpe,
           b.interes_seguro_vida,
           b.interes_apo,
           b.interes_afp,
           b.recargo_svds,
           b.motivo_devolucion,
           a.fecha_solicitud
    from dva_registros_t a
    join dva_det_registros_t b
      on b.nro_reclamacion = a.nro_reclamacion
    join sre_empleadores_t e
      on e.id_registro_patronal = a.id_registro_patronal
    join sfc_det_facturas_t d
      on d.id_referencia = b.id_referencia
      and d.id_nss = b.id_nss
    where a.nro_reclamacion = p_nro_reclamacion
      and a.id_status = 'EN';
    commit;

    -- cambio el estatus de la reclamacion a 'EN'
    update dva_registros_t
    set id_status = 'EV',
        fecha_envio = sysdate
    where nro_reclamacion = p_nro_reclamacion
      and id_status = 'EN';
    commit;

    -- Si llego hasta aqui, no hubo errores de excepciones
    BITACORA(m_id_bitacora, 'FIN', 'ES', 'OK. reclamacion nro='||p_nro_reclamacion, 'O', '000');
  Exception when others then
    ROLLBACK;
    p_result := substr(SQLERRM,1,200);
    BITACORA(m_id_bitacora, 'FIN', 'ES', p_result, 'E', '650');
    system.html_mail('info@mail.tss2.gov.do', c_mail_error, 'Actualizacion vista UNIPAGO.TSS_SOLICITUDES_DEVOLUCION_MV', 'Error en actualizacion vista UNIPAGO.TSS_SOLICITUDES_DEVOLUCION_MV para nro. reclamacion "'||p_nro_reclamacion||'"<br>Error='||p_result);
  End;

  --**********************************************************************************************----
  -- Gregorio Hererra
  -- Recibir respuesta desde UNIPAGO para una reclamacion
  -- 01-Septiembre-2010
  --**********************************************************************************************----
  procedure recibir_repuesta_UNIPAGO(p_result out varchar2) is
    v_total_enc       PLS_INTEGER;
    v_total_det       PLS_INTEGER;
    v_total_dev       suirplus.dva_det_registros_t.monto_devolucion%type;
    v_nacha_cancelado Unipago.Tss_da_Solicitudes_proc_Mv.c_Archivo_Nacha%type;
    v_id_error        suirplus.seg_error_t.id_error%type;
    c_mail_ok         sfc_procesos_t.lista_ok%type;
    c_mail_error      sfc_procesos_t.lista_error%type;
    v_rowid_erroneo   ROWID;
  Begin
    -- Insertamos el registro en la bitacora
    BITACORA(m_id_bitacora, 'INI', 'DA');

    for c_proceso in(select lista_ok, lista_error from sfc_procesos_t p where p.id_proceso = 'DA') loop
      c_mail_ok    := c_proceso.lista_ok;
      c_mail_error := c_proceso.lista_error;
    end loop;

    --Proceso los registros rechazados por las AFP
    For r in (Select *
              From Unipago.Tss_da_Solicitudes_proc_Mv a
              Where c_condicion_reclamacion != '001'
                and not exists (Select 1
                                From suirplus.dva_solicitudes_proc_t
                                Where no_reclamacion = a.n_no_reclamacion
                                  and nss = a.n_nss
                                  and no_referencia = a.n_no_referencia
                                  and num_detalle = a.n_num_detalle
                                  and archivo_nacha = a.c_archivo_nacha
                                  and id_condicion = a.c_condicion_reclamacion
                               )
     ) Loop
      --Validar los campos en DVA_DET_REGISTROS_T
      Select count(*)
      Into v_total_det
      From suirplus.dva_det_registros_t
      Where nro_reclamacion = r.n_no_reclamacion
        and id_referencia = LPAD(r.n_no_referencia,16,'0')
        and id_nss = r.n_nss
        --and secuencia = r.n_num_detalle
        and status = 'GE';

      --codificamos los errores
      If (v_total_det = 0) then
        Select count(*)
        Into v_total_det
        From suirplus.dva_det_registros_t
        Where nro_reclamacion = r.n_no_reclamacion
          and id_referencia = LPAD(r.n_no_referencia,16,'0')
          and id_nss = r.n_nss
          --and secuencia = r.n_num_detalle
          and status = 'RE';

        If (v_total_det = 0) Then
          v_id_error := 'D02';
        Else
          v_id_error := 'D05';
        End if;
      Else
        v_id_error := 'D05';

        --Actualizo en el detalle de la reclamacion a rechazado
        update suirplus.dva_det_registros_t d
        set d.id_condicion = r.c_condicion_reclamacion,
            d.status = 'RE'
        where d.nro_reclamacion = r.n_no_reclamacion
          and d.id_nss = r.n_nss
          and d.id_referencia = LPAD(r.n_no_referencia,16,'0')
          --and d.secuencia = r.n_num_detalle
          and d.status = 'GE';

        --Actualizo la reclamacion a repuesta parcial
        update suirplus.dva_registros_t d
        set d.fecha_respuesta = sysdate,
            d.id_status = 'RP'
        where d.nro_reclamacion = r.n_no_reclamacion
          and d.id_status = 'EV';

        commit;
      End if;

      --Inserto tal cual viene desde la AFP
      Insert into suirplus.dva_solicitudes_proc_t
      (
       no_reclamacion,
       tipo_reclamacion,
       nss,
       no_referencia,
       num_detalle,
       fecha_indiv,
       rnc,
       monto_devolucion,
       monto_rentabilidad,
       archivo_nacha,
       id_motivo,
       status_archivo_nacha,
       fecha_envio_nacha,
       id_condicion,
       monto_otros,
       interes_otros
      )
      values
      (
       r.n_no_reclamacion,
       r.c_tipo_reclamacion,
       r.n_nss,
       r.n_no_referencia,
       r.n_num_detalle,
       r.d_fecha_indiv,
       r.c_rnc,
       NVL(r.n_monto_devolucion,0),
       NVL(r.n_monto_rentabilidad,0),
       r.c_archivo_nacha,
       v_id_error,
       decode(r.c_archivo_nacha, null, 'P', 'R'),
       sysdate,
       r.c_condicion_reclamacion,
       NVL(r.n_monto_otros,0),
       NVL(r.n_interes_otros,0)
      );
      Commit;
    End Loop;

    --Procesamos los registros aprobados por las AFP
    For s in (Select distinct c_archivo_nacha
              From Unipago.Tss_da_Solicitudes_proc_Mv a
              Where c_condicion_reclamacion = '001'
                and not exists (Select 1
                                From suirplus.dva_solicitudes_proc_t
                                Where archivo_nacha = a.c_archivo_nacha
                                  and id_condicion = a.c_condicion_reclamacion
                               )
              ) Loop
      v_nacha_cancelado := null;
      v_id_error := null;
      For r in(select a.*, a.rowid
               From Unipago.Tss_da_Solicitudes_proc_Mv a
               Where c_archivo_nacha = s.c_archivo_nacha
               ) Loop
        --Registros aceptados por las AFP
        If (v_nacha_cancelado is null) Then
          --Validar los campos en DVA_REGISTROS_T
          Select count(*)
          Into v_total_enc
          From suirplus.dva_registros_t a
          Join suirplus.sre_empleadores_t e
            on e.id_registro_patronal = a.id_registro_patronal
           and e.rnc_o_cedula = r.c_rnc
          Where a.nro_reclamacion = r.n_no_reclamacion
            and a.id_status in ('EV','RP');

          --Validar los campos en DVA_DET_REGISTROS_T
          Select count(*),
                 sum(nvl(monto_devolucion,0)) monto_devolucion
          Into v_total_det, v_total_dev
          From suirplus.dva_det_registros_t
          Where nro_reclamacion = r.n_no_reclamacion
            and id_referencia = LPAD(r.n_no_referencia,16,'0')
            and id_nss = r.n_nss
            --and secuencia = r.n_num_detalle
            and status = 'GE';

          --codificamos los errores
          If (v_total_enc = 0) then
            v_id_error := 'D01';
          Elsif (v_total_det = 0) Then
            v_id_error := 'D02';
--          Elsif (v_total_dev != (r.n_monto_devolucion - r.n_monto_otros - r.n_interes_otros)) or
          Elsif (v_total_dev != r.n_monto_devolucion) or
                (NVL(r.n_monto_devolucion,0) + NVL(r.n_monto_rentabilidad,0) <= 0) then
            v_id_error := 'D03';
          End if;

          If (v_id_error is not null) Then
            --Para discriminar la cancelacion masiva para un archivo NACHA
            v_nacha_cancelado := r.c_archivo_nacha;
            v_rowid_erroneo   := r.rowid;

            --Inserto con el codigo de la variable el registro que disparo el error
            Insert into suirplus.dva_solicitudes_proc_t
            (
             no_reclamacion,
             tipo_reclamacion,
             nss,
             no_referencia,
             num_detalle,
             fecha_indiv,
             rnc,
             monto_devolucion,
             monto_rentabilidad,
             archivo_nacha,
             id_motivo,
             status_archivo_nacha,
             fecha_envio_nacha,
             id_condicion,
             monto_otros,
             interes_otros
            )
            values
            (
             r.n_no_reclamacion,
             r.c_tipo_reclamacion,
             r.n_nss,
             r.n_no_referencia,
             r.n_num_detalle,
             r.d_fecha_indiv,
             r.c_rnc,
             NVL(r.n_monto_devolucion,0),
             NVL(r.n_monto_rentabilidad,0),
             r.c_archivo_nacha,
             v_id_error,
             'R',
             sysdate,
             r.c_condicion_reclamacion,
             NVL(r.n_monto_otros,0),
             NVL(r.n_interes_otros,0)
            );
            Commit;
            Exit;
          End if;
        End if;
      End Loop;

      --Si no fallo ninguna validacion para este archivo NACHA procedemos a mover los registros
      --con codigo '000'
      If (v_nacha_cancelado is null) Then
        --Inserto con codigo '000' todos los registros que traen este archivo NACHA
        Insert into suirplus.dva_solicitudes_proc_t
        (
         no_reclamacion,
         tipo_reclamacion,
         nss,
         no_referencia,
         num_detalle,
         fecha_indiv,
         rnc,
         monto_devolucion,
         monto_rentabilidad,
         archivo_nacha,
         id_motivo,
         status_archivo_nacha,
         fecha_envio_nacha,
         id_condicion,
         monto_otros,
         interes_otros
        )
        Select n_no_reclamacion,
               c_tipo_reclamacion,
               n_nss,
               n_no_referencia,
               n_num_detalle,
               d_fecha_indiv,
               c_rnc,
               NVL(n_monto_devolucion,0),
               NVL(n_monto_rentabilidad,0),
               c_archivo_nacha,
               '000',
               'P',
               sysdate,
               c_condicion_reclamacion,
               NVL(n_monto_otros,0),
               NVL(n_interes_otros,0)
        From Unipago.Tss_da_Solicitudes_proc_Mv
        Where c_archivo_nacha = s.c_archivo_nacha;

        --Para actualizar los registros en DVA_DET_REGISTROS_T
        For r in (select *
                  from Unipago.Tss_da_Solicitudes_proc_Mv
                  where c_archivo_nacha = s.c_archivo_nacha
                 ) Loop
          -- cambio el estatus del NSS en el detalle de la reclamacion a 'GE'
          -- Esto revierte lo registros marcados con 'OK' hasta el momento que fallo la validacion

          update suirplus.dva_det_registros_t d
          set d.monto_devolucion_resp = r.n_monto_devolucion,
              d.monto_rentabilidad_resp = r.n_monto_rentabilidad,
              d.monto_otros = r.n_monto_otros,
              d.interes_otros = r.n_interes_otros,
              d.nombre_archivo_nacha = r.c_archivo_nacha,
              d.fecha_envio_nacha = sysdate,
              d.status_archivo_nacha = 'P',
              d.id_condicion = r.c_condicion_reclamacion,
              d.status = 'OK'
          where d.nro_reclamacion = r.n_no_reclamacion
            and d.id_nss = r.n_nss
            and d.id_referencia = LPAD(r.n_no_referencia,16,'0')
            --and d.secuencia = r.n_num_detalle
            and d.status = 'GE';
        End Loop;

        --Para actualizar los registros en DVA_REGISTROS_T
        For r in (select distinct n_no_reclamacion
                  from Unipago.Tss_da_Solicitudes_proc_Mv
                  where c_archivo_nacha = s.c_archivo_nacha
                 ) Loop
          -- cambio el estatus de la reclamacion a 'GE'
          -- Esto revierte lo registros marcados con 'OK' hasta el momento que fallo la validacion

          update suirplus.dva_registros_t d
          set d.fecha_respuesta = sysdate,
              d.id_status = 'RP'
          where d.nro_reclamacion = r.n_no_reclamacion
            and d.id_status = 'EV';
        End Loop;
      Else
        -- Insertamos todos los demas registros como erroneos con el id_motivo="D04"
        Insert into suirplus.dva_solicitudes_proc_t
        (
         no_reclamacion,
         tipo_reclamacion,
         nss,
         no_referencia,
         num_detalle,
         fecha_indiv,
         rnc,
         monto_devolucion,
         monto_rentabilidad,
         archivo_nacha,
         id_motivo,
         status_archivo_nacha,
         fecha_envio_nacha,
         id_condicion,
         monto_otros,
         interes_otros
        )
        Select n_no_reclamacion,
               c_tipo_reclamacion,
               n_nss,
               n_no_referencia,
               n_num_detalle,
               d_fecha_indiv,
               c_rnc,
               NVL(n_monto_devolucion,0),
               NVL(n_monto_rentabilidad,0),
               c_archivo_nacha,
               'D04',
               'R',
               sysdate,
               c_condicion_reclamacion,
               NVL(n_monto_otros,0),
               NVL(n_interes_otros,0)
        From Unipago.Tss_da_Solicitudes_proc_Mv
        Where c_archivo_nacha = s.c_archivo_nacha
          and c_condicion_reclamacion = '001'
          and Rowid != v_rowid_erroneo;
      End if;
      Commit;
    End Loop;

    -- Si llego hasta aqui, no hubo errores de excepciones
    BITACORA(m_id_bitacora, 'FIN', 'DA', 'OK. Actualizacion tabla suirplus.DVA_SOLICITUDES_PROC_T satisfactoria.', 'O', '000');
    p_result := '0';

  Exception when others then
    Rollback;
    p_result := substr(SQLERRM,1,200);
    BITACORA(m_id_bitacora, 'FIN', 'DA', p_result, 'E', '650');
    system.html_mail('info@mail.tss2.gov.do', c_mail_error, 'Actualizacion tabla suirplus.DVA_SOLICITUDES_PROC_T', 'Actualizacion tabla suirplus.DVA_SOLICITUDES_PROC_T realizada con errores.');
  End;

  --**********************************************************************************************----
  -- Gregorio Hererra
  -- Recibir rechazos desde UNIPAGO para una reclamacion en la tabla TSS_RESP_SOLICITUD_DEV_MV
  -- 14-Octubre-2010
  --**********************************************************************************************----
  procedure recibir_rechazos_UNIPAGO(p_result out varchar2) is
    v_id_error        suirplus.seg_error_t.id_error%type;
    c_mail_ok         sfc_procesos_t.lista_ok%type;
    c_mail_error      sfc_procesos_t.lista_error%type;
    v_total_enc       PLS_INTEGER;
    v_total_det       PLS_INTEGER;
  Begin
    -- Insertamos el registro en la bitacora
    BITACORA(m_id_bitacora, 'INI', 'RU');

    for c_proceso in(select lista_ok, lista_error from sfc_procesos_t p where p.id_proceso = 'RU') loop
      c_mail_ok    := c_proceso.lista_ok;
      c_mail_error := c_proceso.lista_error;
    end loop;

    --Para actualizar los registros en DVA_DET_REGISTROS_T con la data
    --que viene en la vista TSS_RESP_SOLICITUDES_DEV_MV desde UNIPAGO
    For r in (select a.*, a.rowid
              From Unipago.Tss_Resp_Solicitudes_Dev_Mv a
              Where a.c_estatus_registro = 'RE'
                and not exists (Select 1
                                From suirplus.dva_solicitudes_proc_t
                                Where no_reclamacion = a.n_no_reclamacion
                                  and nss = a.n_nss
                                  and no_referencia = a.n_no_referencia
                                  and num_detalle = a.n_num_detalle
                                  and archivo_nacha is null
                                  and id_condicion = substr(a.c_codigo_respuesta,1,3)
                               )
             ) Loop
      v_id_error := null;

      --Validar los campos en DVA_REGISTROS_T
      Select count(*)
      Into v_total_enc
      From suirplus.dva_registros_t a
      Join suirplus.sre_empleadores_t e
        on e.id_registro_patronal = a.id_registro_patronal
       and e.rnc_o_cedula = r.c_rnc
      Where a.nro_reclamacion = r.n_no_reclamacion
        and a.id_status in ('EV','RP');

      --Validar los campos en DVA_DET_REGISTROS_T
      Select count(*)
      Into v_total_det
      From suirplus.dva_det_registros_t
      Where nro_reclamacion = r.n_no_reclamacion
        and id_referencia = LPAD(r.n_no_referencia,16,'0')
        and id_nss = r.n_nss
        and secuencia = r.n_num_detalle
        and status = 'GE';

      --codificamos los errores
      If (v_total_enc = 0) then
        v_id_error := 'D01';
      Elsif (v_total_det = 0) Then
        v_id_error := 'D02';
      End if;

      If (v_id_error is null) Then
        -- cambio el estatus de la reclamacion a 'RP'
        update suirplus.dva_registros_t d
        set d.fecha_respuesta = sysdate,
            d.id_status = 'RP'
        where d.nro_reclamacion = r.n_no_reclamacion
          and d.id_status = 'EV';

        -- cambio el estatus del NSS en el detalle de la reclamacion a 'RE'
        update suirplus.dva_det_registros_t d
        set d.id_condicion = substr(r.c_codigo_respuesta,1,3),
            d.status = 'RE'
        where d.nro_reclamacion = r.n_no_reclamacion
          and d.id_nss = r.n_nss
          and d.id_referencia = LPAD(r.n_no_referencia,16,'0')
          and d.secuencia = r.n_num_detalle
          and d.status = 'GE';

        --agarramos el codigo de error enviado desde unipago
        v_id_error := 'D05';
      End if;

      --Inserto el registros rechazado que viene desde UNIPAGO
      Insert into suirplus.dva_solicitudes_proc_t
      (
       no_reclamacion,
       tipo_reclamacion,
       nss,
       no_referencia,
       num_detalle,
       fecha_indiv,
       rnc,
       monto_devolucion,
       monto_rentabilidad,
       id_motivo,
       id_condicion
      )
      Select n_no_reclamacion,
             c_tipo_reclamacion,
             n_nss,
             n_no_referencia,
             n_num_detalle,
             sysdate,
             c_rnc,
             0,
             0,
             v_id_error,
             substr(c_codigo_respuesta,1,3)
      From Unipago.Tss_Resp_Solicitudes_Dev_Mv
      Where Rowid = r.rowid;
    End Loop;
    Commit;

    -- Si llego hasta aqui, no hubo errores de excepciones
    BITACORA(m_id_bitacora, 'FIN', 'RU', 'OK. Recepcion de Rechazos de de UNIPAGO - Devolucion de Aportes, satisfactoria.', 'O', '000');
    p_result := '0';

  Exception when others then
    Rollback;
    p_result := substr(SQLERRM,1,200);
    BITACORA(m_id_bitacora, 'FIN', 'RU', p_result, 'E', '650');
    system.html_mail('info@mail.tss2.gov.do', c_mail_error, 'Recepcion de Rechazos desd UNIPAGO - Devolucion de Aportes', 'Proceso de Recepcion de Rechazos desde UNIPAGO - Devolucion de Aporte, realizada con errores.');
  End;

PROCEDURE GetPagosExceso(
               P_cedula IN SRE_CIUDADANOS_T.NO_DOCUMENTO%type,
               p_io_cursor     IN OUT T_CURSOR,
                p_resultnumber OUT VARCHAR2 ) IS

  v_cursor   T_CURSOR;

BEGIN

OPEN V_CURSOR FOR
     SELECT e.razon_social, sum(s.apo_afi_devolver) SUMATORIA,
            RTRIM(LTRIM(c.nombres))||' '||RTRIM(LTRIM(c.primer_apellido))||' '||RTRIM(LTRIM(c.segundo_apellido)) NOMBRE
      FROM sfc_pagos_exceso_t s,
           sre_empleadores_t e,
           SRE_CIUDADANOS_T C
      WHERE  c.id_nss = s.id_nss
       and e.id_registro_patronal = s.id_registro_patronal
       and c.no_documento = P_cedula
      group by e.razon_social,RTRIM(LTRIM(c.nombres))||' '||RTRIM(LTRIM(c.primer_apellido))||' '||RTRIM(LTRIM(c.segundo_apellido));

p_resultnumber := 0;
p_io_cursor := v_cursor;

EXCEPTION

 WHEN OTHERS THEN
  v_bderror := (SUBSTR('error '||TO_CHAR(SQLCODE)||': '||SQLERRM, 1, 255));
   p_resultnumber := Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
 RETURN;

END GetPagosExceso;

-------------------------------------------------------------------------
--Milciades Hernandez
--23/09/09
--GetPagosExcesoEmpresa
-------------------------------------------------------------------------
PROCEDURE GetPagosExcesoEmpresa(
                           P_RNC          IN sre_empleadores_t.rnc_o_cedula%type,
                           p_io_cursor    OUT T_CURSOR,
                           p_resultnumber OUT VARCHAR2 ) IS

  v_cursor   T_CURSOR;

BEGIN

OPEN V_CURSOR FOR
     SELECT e.razon_social,e.nombre_comercial,sum(s.apo_emp_devolver) MontoDevEmpresa, sum(s.apo_afi_devolver) MontoDevEmpleado
      FROM sfc_pagos_exceso_t s,
           sre_empleadores_t e
      WHERE   e.id_registro_patronal = s.id_registro_patronal
      and E.Rnc_o_Cedula = P_RNC
      group by e.razon_social,e.nombre_comercial ;

p_resultnumber := 0;
p_io_cursor := v_cursor;

EXCEPTION

 WHEN OTHERS THEN
  v_bderror := (SUBSTR('error '||TO_CHAR(SQLCODE)||': '||SQLERRM, 1, 255));
   p_resultnumber := Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
 RETURN;

END GetPagosExcesoEmpresa;

---**********************************************************************************************----
-- charlie pena
-- 31/08/2010
-- getNachas
-- Busca los archivos nacha pendientes de aprobacion, cuya reclamacion se encuentra en estatus OK
---**********************************************************************************************----
 Procedure getNachas (
        p_resultnumber     OUT varchar2,
        p_io_cursor        IN OUT t_cursor)
   IS

   v_cursor  t_cursor;

 BEGIN

      OPEN v_cursor FOR
      SELECT r.archivo_nacha nombre_archivo_nacha,
             r.status_archivo_nacha,
             decode(r.status_archivo_nacha,'R','Rechazado','P','Pendiente','N/A') status_desc,
             trunc(r.fecha_envio_nacha) fecha_envio_nacha,
             sum(nvl(monto_devolucion,0) + nvl(monto_rentabilidad,0)) monto_nacha
      FROM suirplus.dva_solicitudes_proc_t r
      WHERE r.status_archivo_nacha != 'A'
      GROUP BY r.archivo_nacha,
               r.status_archivo_nacha,
               trunc(r.fecha_envio_nacha)
      ORDER BY trunc(r.fecha_envio_nacha) desc;

       p_io_cursor := v_cursor;
       p_resultnumber := 0;

 EXCEPTION

      WHEN OTHERS THEN
          v_bderror := (SUBSTR('error '||TO_CHAR(SQLCODE)||': '||SQLERRM, 1, 255));
          p_resultnumber := Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
      RETURN;

   END getNachas;

---**********************************************************************************************----
-- Gregorio Herrera
-- 21/09/2010
-- Busca las reclamaciones para un archivo nacha
---**********************************************************************************************----
 Procedure getDetNachas (
        p_archivo_nacha IN suirplus.dva_solicitudes_proc_t.archivo_nacha%type,
        p_pagenum       in number,
        p_pagesize      in number,
        p_resultnumber  OUT varchar2,
        p_io_cursor     IN OUT t_cursor)
   IS

   v_cursor  t_cursor;
   vDesde integer := (p_pagesize*(p_pagenum-1))+1;
   vhasta integer := p_pagesize*p_pagenum;

 BEGIN

    OPEN v_cursor FOR
    with x as (select rownum num, y.* from (
      SELECT r.no_reclamacion,
             r.rnc,
             e.razon_social,
             sum(nvl(monto_devolucion,0)) monto_devolucion,
             sum(nvl(monto_rentabilidad,0)) monto_rentabilidad,
             sum(nvl(monto_devolucion,0) + nvl(monto_rentabilidad,0)) monto_reclamacion
      FROM suirplus.dva_solicitudes_proc_t r
      JOIN suirplus.sre_empleadores_t e
        ON e.rnc_o_cedula = r.rnc
      WHERE r.archivo_nacha = p_archivo_nacha
      GROUP BY r.no_reclamacion,
               r.rnc,
               e.razon_social) y)
      select y.recordcount, x.*
      from x,(select max(num) recordcount from x) y
      where x.num between (vDesde) and (vHasta)
      order by x.no_reclamacion desc;

    p_io_cursor := v_cursor;
    p_resultnumber := 0;

 EXCEPTION

    WHEN OTHERS THEN
      v_bderror := (SUBSTR('error '||TO_CHAR(SQLCODE)||': '||SQLERRM, 1, 255));
      p_resultnumber := Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
    RETURN;

 END getDetNachas;

---**********************************************************************************************----
-- charlie pena
-- 31/08/2010
-- getNachas
-- Marcar como aprobado el archivo nacha pendiente de aprobacion.
---**********************************************************************************************----

procedure aprobarNacha (
     p_nacha  in dva_det_registros_t.nombre_archivo_nacha%TYPE,
     p_usuario in seg_usuario_t.id_usuario%type,
     p_resultnumber     out varchar2
     )
     is
     e_Existe_Nacha exception;
     v_proximo suirplus.sfc_trans_ajustes_t.id_ajuste%type;
     v_periodo number(6) := parm.periodo_vigente();
BEGIN

    IF not dva_manejo_pkg.IsExisteNacha(p_nacha) THEN
      raise e_Existe_Nacha ;
    END IF;

    For r in (select a.*, a.rowid
              from suirplus.dva_solicitudes_proc_t a
              where archivo_nacha = p_nacha
                and status_archivo_nacha = 'P'
                and id_motivo = '000'
              ) Loop
      --marcamos el archivo nacha como aprobado en el detalle de la devolucion de aporte
      UPDATE dva_det_registros_t
      SET status_archivo_nacha = 'A',
          fecha_aprobacion_nacha = SYSDATE
      WHERE nro_reclamacion = r.no_reclamacion
        and id_referencia = r.no_referencia
        and id_nss = r.nss
        and secuencia = r.num_detalle
        and nombre_archivo_nacha = r.archivo_nacha
        and status = 'OK';

      If Sql%Rowcount > 0 Then
        --Para actualizar los registros en el historico para este NACHA
        Update suirplus.dva_solicitudes_proc_t
        Set status_archivo_nacha = 'A'
        Where Rowid = r.rowid;
      End if;
    End Loop;
    Commit;

    --Para marcar la reclamacion como completada
    For r in (select a.no_reclamacion,
                     count(b.nro_reclamacion) registros,
                     sum(decode(b.status,'OK',1,'RE',1,0)) procesados
              from suirplus.dva_solicitudes_proc_t a
              join suirplus.dva_det_registros_t b
                on b.nro_reclamacion = a.no_reclamacion
              where a.archivo_nacha = p_nacha
                and a.status_archivo_nacha = 'P'
                and a.id_motivo = '000'
              group by a.no_reclamacion
              ) Loop

      --Marcamos la reclamacion como completada si todos sus registros estan procesados
      If r.registros = r.procesados then
        UPDATE suirplus.dva_registros_t
        SET id_status = 'CP',
            fecha_devolucion = SYSDATE
        WHERE nro_reclamacion = r.no_reclamacion
          and id_status = 'RP';

        --Para cerrar la orden de solicitud de servicios
        suirplus.sel_solicitudes_pkg.CambiarSolicitud(r.no_reclamacion,3,p_usuario,'Solicitud completada por el proceso de DEVOLUCION DE APORTES.',p_resultnumber);

        --Para insertar el registro de ajuste.
        For p in(select x.id_registro_patronal,
                        4 tipo_ajuste,
                        'PE' status,
                        sysdate fecha,
                        f.id_nomina,
                        v_periodo periodo_aplicacion,
                        sum(nvl(z.monto_devolucion_resp,0) + nvl(z.monto_rentabilidad_resp,0)) monto
                 from suirplus.dva_registros_t x
                 join suirplus.dva_det_registros_t z
                   on z.nro_reclamacion = x.nro_reclamacion
                 join suirplus.sfc_facturas_t f
                   on f.id_referencia = z.id_referencia
                 where x.nro_reclamacion = r.no_reclamacion
                 group by x.id_registro_patronal, f.id_nomina, f.periodo_factura) loop

          v_proximo := suirplus.sfc_trans_ajustes_seq.nextval;

          insert into suirplus.sfc_trans_ajustes_t
           (id_registro_patronal,
            id_tipo_ajuste,
            estatus,
            monto_ajuste,
            fecha_registro,
            periodo_aplicacion,
            id_nomina,
            id_ajuste
            )
          values
           (p.id_registro_patronal,
            p.tipo_ajuste,
            p.status,
            p.monto,
            p.fecha,
            p.periodo_aplicacion,
            p.id_nomina,
            v_proximo
           );
        End Loop;
        Commit;
      End if;
    End loop;

    p_resultnumber := 0;
 EXCEPTION

   WHEN e_Existe_Nacha THEN
       p_resultnumber := Seg_Retornar_Cadena_Error(260, NULL, NULL);

   WHEN OTHERS THEN
     v_bderror := (SUBSTR('error '||TO_CHAR(SQLCODE)||': '||SQLERRM, 1, 255));
     p_resultnumber := Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);

   ROLLBACK;

end aprobarNacha;

---**********************************************************************************************----
-- Gregorio Herrera
-- 23/09/2010
-- Marcar como rechazado el archivo nacha
---**********************************************************************************************----
procedure rechazarNacha (
     p_nacha  in dva_det_registros_t.nombre_archivo_nacha%TYPE,
     p_usuario in seg_usuario_t.id_usuario%type,
     p_resultnumber     out varchar2
     )
     is
     e_Existe_Nacha exception;
BEGIN

    IF not dva_manejo_pkg.IsExisteNacha(p_nacha) THEN
      raise e_Existe_Nacha ;
    END IF;

    For r in (select a.*, a.rowid
              from suirplus.dva_solicitudes_proc_t a
              where archivo_nacha = p_nacha
              ) Loop
      --marcamos el archivo nacha como aprobado en el detalle de la devolucion de aporte
      UPDATE dva_det_registros_t x
      SET x.monto_devolucion_resp = 0,
          x.monto_rentabilidad_resp = 0,
          x.nombre_archivo_nacha = null,
          x.status_archivo_nacha = null,
          x.fecha_envio_nacha = null,
          x.fecha_aprobacion_nacha = null,
          x.status='GE'
      WHERE nro_reclamacion = r.no_reclamacion
        and id_referencia = r.no_referencia
        and id_nss = r.nss
        and secuencia = r.num_detalle
        and nombre_archivo_nacha = r.archivo_nacha
        and status = 'OK';

      If Sql%Rowcount > 0 Then
        --Para actualizar los registros en el historico para este NACHA
        Update suirplus.dva_solicitudes_proc_t
        Set status_archivo_nacha = 'R', id_motivo = 'D04'
        Where Rowid = r.rowid;
      End if;
    End Loop;
    Commit;

    --Para marcar la reclamacion como pendiente o en repuesta parcial
    For r in (select a.no_reclamacion,
                     count(b.nro_reclamacion) registros,
                     sum(decode(b.status,'GE',1,0)) pendientes,
                     sum(decode(b.status,'OK',1,'RE',1,0)) procesados
              from suirplus.dva_solicitudes_proc_t a
              join suirplus.dva_det_registros_t b
                on b.nro_reclamacion = a.no_reclamacion
              where a.archivo_nacha = p_nacha
                and a.status_archivo_nacha = 'R'
                and a.id_motivo = 'D04'
              group by a.no_reclamacion
              ) Loop

      --Marcamos la reclamacion como pendiente si no todos sus registros estan procesados
      If r.registros = r.pendientes then
        UPDATE suirplus.dva_registros_t
        SET id_status = 'EV', fecha_respuesta = null, fecha_devolucion = null
        WHERE nro_reclamacion = r.no_reclamacion
          and id_status = 'RP';
        Commit;
      Elsif r.procesados > 0 Then
        UPDATE suirplus.dva_registros_t
        SET id_status = 'RP', fecha_devolucion = null
        WHERE nro_reclamacion = r.no_reclamacion;
        Commit;
      End if;
    End loop;

    For m in (select distinct e.id_registro_patronal
              from suirplus.dva_solicitudes_proc_t s
              join suirplus.sre_empleadores_t e
                on e.rnc_o_cedula = s.rnc
              where s.archivo_nacha = p_nacha
             ) Loop

        --Para crear un CRM para el empleador
        Emp_Crm_Pkg.CrearEmp_Crm(m.id_registro_Patronal, 'Nacha Rechazado.', 8, null, p_usuario,
                                 'El archivo nacha '||p_nacha||' ha sido rechazado.', p_usuario, sysdate, null, null, p_resultnumber);
    End Loop;

    COMMIT;
    p_resultnumber := 0;
 EXCEPTION

   WHEN e_Existe_Nacha THEN
       p_resultnumber := Seg_Retornar_Cadena_Error(260, NULL, NULL);

   WHEN OTHERS THEN
     v_bderror := (SUBSTR('error '||TO_CHAR(SQLCODE)||': '||SQLERRM, 1, 255));
     p_resultnumber := Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);

   ROLLBACK;

end rechazarNacha;

FUNCTION IsExisteNacha(p_Nacha  IN dva_det_registros_t.nombre_archivo_nacha%type) RETURN BOOLEAN
IS

CURSOR c_existe_Nacha IS

SELECT t.no_reclamacion FROM suirplus.dva_solicitudes_proc_t t WHERE t.archivo_nacha = p_Nacha;
returnValue BOOLEAN;
v_Nacha VARCHAR(22);

BEGIN
OPEN c_existe_Nacha;
	 FETCH c_existe_Nacha INTO v_Nacha;
	 returnValue := c_existe_Nacha%FOUND;
	 CLOSE c_existe_Nacha;

	 RETURN(returnValue);

END IsExisteNacha ;

  -- **************************************************************************************************
  -- Para saber si un empleador tiene Facturas pagadas
  -- **************************************************************************************************
  Procedure TieneFactPagadas(p_registro_patronal in varchar2, p_result out varchar2) is
  Begin
    p_result := 'N';
    For c_fact in (select count(id_referencia) total
                   from suirplus.sfc_facturas_v v
                   where v.ID_REGISTRO_PATRONAL = p_registro_patronal
                     and v.status = 'PA') Loop
      If c_fact.total > 0 then
        p_result := 'S';
      End if;
    End loop;
  End TieneFactPagadas;

  ---------------------------------------------------------------------------
  -- Objetivo: Traer los diferentes estatus de devolucion de aportes
  -- Autor: charlie Pe?a
  -- Fecha: 15/10/2010
  ---------------------------------------------------------------------------
  Procedure getStatus
  (
   p_iocursor     out t_cursor,
   p_resultnumber out varchar2
  )
  Is
   v_bderror VARCHAR(1000);
  Begin
    Open p_iocursor for
    Select t.id_status, InitCap(Descripcion) Descripcion
    From dva_status_t t
    Order by 1;

    p_resultNumber := 0;
  Exception
    When others Then
      v_bderror := (substr('error '||to_char(sqlcode)||': '||sqlerrm, 1, 255));
      p_resultnumber := seg_retornar_cadena_error(-1, v_bderror,sqlcode);
  End;
 ---------------------------------------------------------------------------
  -- Objetivo: Obtener el monto a devolver a cada ciudadano con cedulas validas.
  -- Autor: Eury Vallejo
  ---------------------------------------------------------------------------
PROCEDURE GetPagosExcesoCiudadanos(
               P_cedula         IN SRE_CIUDADANOS_T.NO_DOCUMENTO%type,
               p_io_cursor      IN OUT T_CURSOR,
               p_resultnumber   OUT VARCHAR2 ) IS

  v_cursor                      T_CURSOR;
  v_existe                      integer;
  e_cedulaCancelada             exception;
  e_cedulaInvalida              exception;      
  
 BEGIN  
 
 if not suirplus.lgl_legal_pkg.isExisteCiudadano(P_cedula,'C') then
         raise e_cedulaInvalida;
     end if;
 
 select count(*)
   into v_existe
   from sre_ciudadanos_t c
  where c.id_causa_inhabilidad is not null
    and c.tipo_causa = 'C'
    and c.tipo_documento = 'C'
    and c.no_documento = P_cedula;

 if (v_existe > 0) then
    raise e_cedulaCancelada;
end if;

   OPEN V_CURSOR FOR       
       select sum(trans.monto_ajuste) as monto, ciu.nombres,ciu.primer_apellido,ciu.fecha_nacimiento,ciu.no_documento,trans.estatus,trans.log,aju.descripcion, trans.nro_cuenta 
       from sre_ciudadanos_t ciu join sfc_trans_ajustes_t trans
       on ciu.id_nss = trans.id_nss
       join sfc_tipo_ajustes_t aju
       on trans.id_tipo_ajuste = aju.id_tipo_ajuste
       where trans.estatus = 'GE'
       and ciu.no_documento = P_cedula
       and trans.id_tipo_ajuste in(3,4)
       and trans.id_registro_patronal is null
       and trans.id_nomina is null
       and trans.id_nss is not null           
       group by ciu.nombres,ciu.primer_apellido,ciu.fecha_nacimiento,ciu.no_documento,trans.estatus,trans.log,                                                                                              aju.descripcion, trans.nro_cuenta,trans.periodo_aplicacion
       order by trans.periodo_aplicacion desc;

    p_resultnumber := 0;
    p_io_cursor := v_cursor;

EXCEPTION

   When e_cedulaInvalida then
       p_resultnumber := Seg_Retornar_Cadena_Error(104, NULL, NULL);
   Return;

   WHEN e_cedulaCancelada THEN
       p_resultnumber := Seg_Retornar_Cadena_Error(114, NULL, NULL);
   return;

    WHEN OTHERS THEN
    v_bderror := (SUBSTR('error '||TO_CHAR(SQLCODE)||': '||SQLERRM, 1, 255));
    p_resultnumber := Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
    RETURN;


END GetPagosExcesoCiudadanos;


 ---**********************************************************************************************----
-- Milciades Hernandez
-- MarcarReclamacion
-- 24-Abril-2009
-- Modifica el estatus de las Reclamacion
---**********************************************************************************************----

procedure EntregarFondos (
     p_nro_reclamacion   in dva_registros_t.nro_reclamacion%TYPE,
     P_tipodoc           in dva_registros_t.Tipo_documento%TYPE,
     P_nro_documento     in dva_registros_t.Nro_documento%TYPE,
     P_nro_cheque        in dva_registros_t.Nro_Cheque%TYPE,
     P_status            in dva_registros_t.id_status%TYPE,
     P_entregado_por     in dva_registros_t.entregado_por%TYPE,
     p_resultnumber      out varchar2
     )
     is
     e_Existe_Reclamacion  exception;
BEGIN

IF (p_nro_reclamacion is not null) THEN
     IF not dva_manejo_pkg.IsExisteReclamacion(p_nro_reclamacion) THEN
        raise e_Existe_Reclamacion ;
     END IF;
  END IF;

  --marcamos el registro como entregado
    UPDATE dva_registros_t
       SET Tipo_documento = p_tipodoc,
           Nro_documento  = p_nro_documento,
           Nro_cheque     = p_nro_cheque,
           id_status      = p_status,
           entregado_por  = p_entregado_por
      where nro_reclamacion = p_nro_reclamacion;

    p_resultnumber := 0;
    COMMIT;


 EXCEPTION
    WHEN e_Existe_Reclamacion THEN
           p_resultnumber := Seg_Retornar_Cadena_Error(223, NULL, NULL);
      RETURN;

   WHEN OTHERS THEN
     v_bderror := (SUBSTR('error '||TO_CHAR(SQLCODE)||': '||SQLERRM, 1, 255));
     p_resultnumber := Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);


end EntregarFondos;


---**********************************************************************************************----
-- Kerlin De La Cruz
-- ValidaCiudadano
-- 15/02/2013
-- Verifica si el ciudadano no se encuentra cancelado o inhabilitado en la tabla sre_ciudadanos_t
---**********************************************************************************************----
Procedure ValidaCiudadano(p_no_documento   in sre_ciudadanos_t.no_documento%type,
                       p_tipo_documento in sre_ciudadanos_t.tipo_documento%type,
                       p_resultnumber   OUT VARCHAR2)

IS

v_count  integer;
e_ciudadano_canc  exception;
e_ciudadano_no_existe  exception;

Begin

  select count(*)
   into v_count
   from sre_ciudadanos_t c
  where c.no_documento = p_no_documento
    and c.tipo_documento = p_tipo_documento;

  if v_count = 0 then
    raise e_ciudadano_no_existe;
  end if;

 select count(*)
   into v_count
   from sre_ciudadanos_t c
  where ((c.tipo_causa is null and c.id_causa_inhabilidad is null) or
          (c.tipo_causa = 'I' and c.id_causa_inhabilidad is not null))
    and c.no_documento = p_no_documento
    and c.tipo_documento = p_tipo_documento;

 if v_count > 0 then
   p_resultnumber := 0;
 else
   raise e_ciudadano_canc;
 end if;


EXCEPTION

 WHEN e_ciudadano_canc THEN
       p_resultnumber := Seg_Retornar_Cadena_Error('800',null, NULL);
   return;

 WHEN e_ciudadano_no_existe THEN
       p_resultnumber := Seg_Retornar_Cadena_Error('65',null, NULL);
   return;

 WHEN OTHERS THEN
    v_bderror := (SUBSTR('error '||TO_CHAR(SQLCODE)||': '||SQLERRM, 1, 255));
    p_resultnumber := Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
    RETURN;

End;


END DVA_MANEJO_PKG;
