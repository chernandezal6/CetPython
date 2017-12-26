CREATE OR REPLACE PACKAGE BODY suirplus.cer_certificaciones_pkg IS

  -- **************************************************************************************************
  -- PROGRAM:           CER_CERTIFICACIONES_PKG
  -- DESCRIPTION:       Paquete para manejar las certificaciones

  -- **************************************************************************************************

  Function getSecuenciaCerHis return integer is
    v_return integer := 0;
  Begin
    Select SEG_CER_HIST_SEQ.Nextval into v_return from dual;
    return v_return;
  End getSecuenciaCerHis;

  -- refactored
  procedure AgregarCRM(p_id_tipo      IN CER_CERTIFICACIONES_T.ID_TIPO_CERTIFICACION%TYPE,
                       p_id_usuario   IN CER_CERTIFICACIONES_T.id_usuario%TYPE,
                       p_resultnumber IN out VARCHAR2,
                       p_RegPatronal  IN cer_certificaciones_t.id_registro_patronal%type,
                       p_comentario   in varchar2

                       ) is
    v_tipoCertificacion cer_tipos_certificaciones_t.tipo_certificacion_des%type;
  begin
    select cer.tipo_certificacion_des
      into v_tipoCertificacion
      from cer_tipos_certificaciones_t cer
     where cer.id_tipo_certificacion = p_id_tipo;

    Suirplus.Emp_Crm_Pkg.CrearEmp_Crm(p_RegPatronal,
                                      v_tipoCertificacion,
                                      8,
                                      null,
                                      null,
                                      p_comentario || ' : ' ||
                                      v_tipoCertificacion,
                                      p_id_usuario,
                                      null,
                                      null,
                                      null,
                                      p_resultNumber);
  end AgregarCRM;

  -- **************************************************************************************************
  -- PROCEDIMIENTO:     CrearCertificacionesCer
  -- Description:       Crea nueva certificacion en la tabla CER_CERTIFICACIONES_T
  -- **************************************************************************************************
  PROCEDURE CrearCertificacionesCer(p_id_usuario   IN CER_CERTIFICACIONES_T.id_usuario%TYPE,
                                    p_id_tipo      IN OUT CER_CERTIFICACIONES_T.ID_TIPO_CERTIFICACION%TYPE,
                                    p_rnc_cedula   IN SRE_EMPLEADORES_T.rnc_o_cedula%TYPE,
                                    p_idnss        IN SRE_CIUDADANOS_T.ID_NSS%TYPE,
                                    p_id_firma     IN CER_CERTIFICACIONES_T.ID_FIRMA%type,
                                    p_fecha_desde  varchar2,
                                    p_fecha_hasta  varchar2,
                                    p_resultnumber OUT VARCHAR2)

   IS
    e_rnc_cedula EXCEPTION;
    e_invalidnss EXCEPTION;
    e_errorInsert     exception;
    v_fechadesde      varchar(15);
    v_fechahasta      varchar(15);
    v_idcertificacion VARCHAR2(50);
    v_RegPatronal     VARCHAR2(50);
    v_bderror         VARCHAR(1000);
    v_seg_his_cer     integer := 0;
    v_nocertificacion suirplus.cer_certificaciones_t.no_certificacion%type;
    v_pin             suirplus.cer_certificaciones_t.pin%type;
    v_count           number(10);
    v_firma integer;
    e_apor_tra exception;
    e_apor_tra_empl exception;
    e_balance_dia exception;
    e_facturas_vencidas exception;

    CURSOR c_regpatronal IS
      SELECT e.id_registro_patronal
        FROM SRE_EMPLEADORES_T e
       WHERE e.rnc_o_cedula = p_rnc_cedula;

  BEGIN
    
    if (nvl(p_id_firma,0)=0) then
      --buscarla firma por default
      if p_id_tipo = '88' then
        select c.ftp_pass
        into v_firma
        from suirplus.srp_config_t c
        where c.id_modulo='CERTIFICAC';
      else          
        select c.ftp_host
        into v_firma
        from suirplus.srp_config_t c
        where c.id_modulo='CERTIFICAC';
      end if;
    else
      v_firma := p_id_firma;
    end if;


    v_fechadesde := NVL(TO_DATE(p_fecha_desde, 'DD/MM/YYYY'), '01-JUN-2003');
    v_fechahasta := NVL(TO_DATE(p_fecha_hasta, 'DD/MM/YYYY'), sysdate);

    --Empleador
    IF p_rnc_cedula is not null THEN
      IF NOT Sre_Empleadores_Pkg.isRncOCedulaValida(p_rnc_cedula) THEN
        RAISE e_rnc_cedula;
      END IF;
    END IF;

    --Empleado

    IF p_idnss is not null THEN
      IF NOT Sre_Trabajador_Pkg.isexisteidnss(p_idnss) THEN
        RAISE e_invalidnss;
      END IF;
    END IF;

    OPEN c_regpatronal;
    FETCH c_regpatronal
      INTO v_RegPatronal;
    CLOSE c_regpatronal;

/*    SELECT cer_certificaciones_seq.NEXTVAL
      INTO v_idcertificacion
      FROM dual;*/

   --Cambio realizado para cambiar la forma en que se obtenia la secuencia de la certificacion
   select nvl(max(ID_CERTIFICACION), 0) + 1 into v_idcertificacion from cer_certificaciones_t;


    select CER_NOCERTIFICACION_SEQ.NEXTVAL
      INTO v_nocertificacion
      from dual;

    --No Certificacion Alpha no
    SELECT CHR(65 + floor(v_nocertificacion / 100000)) ||
           TO_CHAR(v_nocertificacion, 'fm0000000') || '-' || p_id_tipo
      into v_nocertificacion
      from dual;

    --Para obtener aleatoriamente (random) un numero de 4 digitos entre mil y nueve (buscar que quede de cuatro digitos)
    select ceil(dbms_random.value(1000, 9000)) into v_pin from dual;

/*    IF p_id_tipo = '2' and p_idnss is not null and p_rnc_cedula is not null Then
      Select count(*)
        into v_count
        from sfc_facturas_t f
        join sfc_det_facturas_t d
          on f.id_referencia = d.id_referencia
         and d.id_nss = p_idnss
       where f.id_registro_patronal = v_RegPatronal
         and f.status = 'PA';

      if v_count = 0 then
        raise e_apor_tra_empl;
      end if;

      --- Certificacion Aportes personales

*/  If p_id_tipo in ('9') and p_idnss is not null Then

      Select count(*)
        into v_count
        from sfc_facturas_t f
        join sfc_det_facturas_t d
          on f.id_referencia = d.id_referencia
         and d.id_nss = p_idnss
       where f.status = 'PA'; --f.id_registro_patronal = v_RegPatronal

      if v_count = 0 then
        raise e_apor_tra;
      end if;

      --- Certificacion Balance al dia

    Elsif p_id_tipo = '5' and p_rnc_cedula is not null Then

      If (suirplus.sre_trabajador_pkg.TieneTrabajadoresActivos(v_RegPatronal)) = 'N' and
         (suirplus.sfc_factura_pkg.TieneFactVencidasPagadas(v_RegPatronal)) = 'N' then
        If length(trim(p_rnc_cedula)) = 9 then
          p_id_tipo := '8';
        Else
          p_id_tipo := '7';
        End if;
      End if;

/*Esta Validacion esta realizada para resolver un incoveniente reportado en el task 10947,
 a causa de Certificaciones entregadas sin estar al dia por parte de los empleadores*/
      select count (*)
      into v_count
      from sfc_facturas_t f
      where f.status = 'VE' and f.fecha_limite_acuerdo_pago is null
      and f.id_registro_patronal = v_RegPatronal;

      if v_count > 0 then
       raise e_balance_dia;
      end if;
 
 select count (*)
      into v_count
      from sfc_facturas_t f
      where f.status = 'VE' and f.fecha_limite_acuerdo_pago is not null and trunc(f.fecha_limite_acuerdo_pago) < trunc(sysdate)
      and f.id_registro_patronal = v_RegPatronal;

      if v_count > 0 then
       raise e_balance_dia;
      end if;


/*      select count(*)
        into v_count
        from sre_empleadores_t e
       where e.status_cobro = 'N'
         and e.id_registro_patronal = v_RegPatronal;

      if v_count = 0 then
        raise e_balance_dia;
      end if;
*/
      --Ticket 6837
      --Para buscar el status cobro del empleador en linea
    /*  If sre_empleadores_pkg.IsEmpleadorEnLegal(v_RegPatronal) = 'L' Then
        raise e_balance_dia;
      End if;*/
      
    --Task 10539 - Creaciones de certificaciones de balance al dia
    /*Estas llamadas fueron comentadas debido a que ya estas validaciones se hacen en linea en la 
    parte web */
      /*select count (*)
      into v_count
      from sfc_facturas_t f
      where f.status in ('VE')
      and f.id_registro_patronal = v_RegPatronal;

      if v_count > 0 then
       raise e_facturas_vencidas;
      end if;*/
    End if;

    -- insertar la certificacion--*
   Begin
    INSERT INTO suirplus.CER_CERTIFICACIONES_T
      (id_certificacion,
       id_usuario,
       id_tipo_certificacion,
       id_registro_patronal,
       id_nss,
       fecha_desde,
       fecha_hasta,
       ID_FIRMA,
       fecha_creacion,
       id_status_certificacion,
       COMENTARIO,
       ULT_FECHA_ACT,
       ULT_USUARIO_ACT,
       no_certificacion,
       PIN)
    VALUES
      (v_idcertificacion,
       p_id_usuario,
       p_id_tipo,
       v_RegPatronal,
       p_idnss,
       v_fechadesde,
       v_fechahasta,
       v_firma,
       SYSDATE,
       1,
       'Nueva Certificacion',
       sysdate,
       p_id_usuario,
       v_nocertificacion,
       v_pin);
   exception
   when OTHERS then
     raise e_errorInsert;
     RETURN;
   end;
    --insertamos el registro con el estatus correspondiente en la tabla cer_his_certificaciones_t

    v_seg_his_cer := getSecuenciaCerHis();

    insert into cer_his_certificaciones_t
      (id_his_certificacion,
       id_certificacion,
       status,
       usuario,
       fecha,
       comentario)
    values
      (v_seg_his_cer,
       v_idcertificacion,
       1,
       p_id_usuario,
       sysdate,
       'Nueva Certificacion');

    -- Agrear el CRM--

    AgregarCRM(p_id_tipo,
               p_id_usuario,
               p_resultnumber,
               v_RegPatronal,
               'Se Creo una Certificación de Tipo '||p_id_tipo);
               
    --buscamos si este tipo de certificacion requiere completarse automaticamente
    select count(*) into v_count 
    from cer_tipos_certificaciones_t t
    where t.id_tipo_certificacion = p_id_tipo and t.automatica='S';
    
    if v_count > 0 then
      CambiarStatusCert(v_idcertificacion,4,'CER_AUTOMATICA','Certificación completada automaticamente',p_resultnumber);
    end if;               

    p_resultnumber := v_idcertificacion || '|' || v_nocertificacion || '|' || 0;
    commit;
    
  EXCEPTION

    WHEN e_rnc_cedula THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(150, NULL, NULL);
      RETURN;

    WHEN e_invalidnss THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(30, NULL, NULL);
      RETURN;

    WHEN e_apor_tra_empl THEN
      p_resultnumber := Seg_Retornar_Cadena_Error('C07', NULL, NULL);
      RETURN;

    WHEN e_apor_tra THEN
      p_resultnumber := Seg_Retornar_Cadena_Error('C04', NULL, NULL);
      RETURN;

    WHEN e_balance_dia THEN
      p_resultnumber := Seg_Retornar_Cadena_Error('C02', NULL, NULL);
      RETURN;

     WHEN e_facturas_vencidas THEN
      p_resultnumber := Seg_Retornar_Cadena_Error('C05', NULL, NULL);
      RETURN;
     WHEN e_errorInsert Then
      v_bderror := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                      SQLERRM,
                      1,
                      255));
      --Guardamos en la tabla seg_errores_t todos los parametros enviados y el mensaje de error.
      p_resultnumber := 'Error al crear la certificación, estos son los parametros: p_id_usuario = '||p_id_usuario||' | p_id_tipo = '||p_id_tipo||' | p_rnc_cedula = '||p_rnc_cedula||
      ' | p_idnss = '||p_idnss||' | p_id_firma = '||p_id_firma||' | p_fecha_desde = '||p_fecha_desde||' | p_fecha_hasta = '||p_fecha_hasta ||' | Este es el mensaje de error: '||Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
      seg_usuarios_pkg.logerror(p_resultnumber,p_id_usuario);

      p_resultnumber := '4 | A ocurrido un error favor intentar mas tarde';
      RETURN;
    WHEN OTHERS THEN
      v_bderror      := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultnumber := Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
      RETURN;
  END;
  /*
  -- **************************************************************************************************
  -- PROCEDIMIENTO:     Function ExisteStatus
  -- DESCRIPCION:       Funcion que retorna la existencia del estatus de una certificacion
                        Recibe : el parametro p_id_certificacion.
                        Devuelve: un valor booleano (0,1) . 0 = no existe  1 = existe
  -- Autor:             Francis Ramirez
  -- Fecha              2010-09-02--
  -- **************************************************************************************************
  */
  Function ExisteStatus(p_id_status_certificacion cer_status_certificaciones_t.id_status_certificacion%type)
    RETURN boolean is
    v_id_status_certificacion cer_status_certificaciones_t.id_status_certificacion%type;
    v_returnvalue             boolean;
    cursor c_ExisteStatus is
      Select s.id_status_certificacion
        from cer_status_certificaciones_t s
       where s.id_status_certificacion = p_id_status_certificacion;
  begin
    Open c_ExisteStatus;
    FETCH c_ExisteStatus
      into v_id_status_certificacion;
    v_returnvalue := c_ExisteStatus%found;
    close c_ExisteStatus;

    return(v_returnvalue);
  end ExisteStatus;

  --refactored
  procedure ActualizarStatusCer(p_comentario              IN CER_CERTIFICACIONES_T.COMENTARIO%type,
                                p_id_certificacion        IN CER_CERTIFICACIONES_T.id_certificacion%TYPE,
                                p_id_status_certificacion IN cer_status_certificaciones_t.id_status_certificacion%type,
                                p_id_usuario              IN CER_CERTIFICACIONES_T.id_usuario%TYPE) is
  begin

    update cer_certificaciones_t c
       set c.id_status_certificacion = p_id_status_certificacion,
           c.Ult_Usuario_Act         = p_id_usuario,
           c.Ult_Fecha_Act           = Sysdate,
           c.comentario              = p_comentario
     where c.id_certificacion = p_id_certificacion;

  end ActualizarStatusCer;

  -- **************************************************************************************************
  -- PROCEDIMIENTO:     CambiarStatusCert
  -- Description:       Metodo para cambiar el estatus de las certificaciones.
  -- **************************************************************************************************

  procedure CambiarStatusCert(p_id_certificacion        IN CER_CERTIFICACIONES_T.id_certificacion%TYPE,
                              p_id_status_certificacion cer_status_certificaciones_t.id_status_certificacion%type,
                              p_id_usuario              IN CER_CERTIFICACIONES_T.id_usuario%TYPE,
                              p_comentario              in CER_CERTIFICACIONES_T.COMENTARIO%type,
                              p_resultnumber            OUT VARCHAR2) is
    e_invalidcertificacion EXCEPTION;
    e_Existe_Status EXCEPTION;
    e_pendiente_autorizacion exception;
    e_rechazada_certificacion exception;
    v_bderror              VARCHAR(1000);
    v_seg_his_cer          INTEGER := 0;
    v_registros            INTEGER := 0;
    v_registros1           INTEGER := 0;
    v_status_certificacion suirplus.cer_certificaciones_t.id_status_certificacion%type;
    v_tipo_certificacion   suirplus.CER_CERTIFICACIONES_T.ID_TIPO_CERTIFICACION%type;
    v_tipo_certificacion2   suirplus.CER_CERTIFICACIONES_T.ID_TIPO_CERTIFICACION%type;
    v_id_registro_patronal suirplus.cer_certificaciones_t.id_registro_patronal%type;
  begin

    IF NOT Cer_Certificaciones_Pkg.isExisteCertificacion(p_id_certificacion) THEN
      RAISE e_invalidcertificacion;
    END IF;

    if not ExisteStatus(p_id_status_certificacion) then
      raise e_Existe_Status;
    end if;

    --Si el Status es pendiente de autorizacion--
    if p_id_status_certificacion = 1 then
      -- Ver si la certificacion esta rechazada--
      select count(*)
        into v_registros1
        from cer_certificaciones_t
       where id_certificacion = p_id_certificacion
         and id_status_certificacion = 2;

      if (v_registros1 = 0) then
        raise e_rechazada_certificacion;
      end if;

    end if;

    if p_id_status_certificacion in (2, 3) then
      -- ver si la certificacion esta pendiente de autorizacion--
      select count(*)
        into v_registros
        from cer_certificaciones_t
       where id_certificacion = p_id_certificacion
         and id_status_certificacion = 1;

      if (v_registros = 0) then
        raise e_pendiente_autorizacion;
      end if;
    end if;

    --insertamos el registro con el estatus correspondiente en la tabla cer_his_certificaciones_t
    v_seg_his_cer := getSecuenciaCerHis();
      insert into cer_his_certificaciones_t
      (id_his_certificacion,
       id_certificacion,
       status,
       usuario,
       fecha,
       comentario)
    values
      (v_seg_his_cer,
       p_id_certificacion,
       p_id_status_certificacion,
       p_id_usuario,
       sysdate,
       p_comentario);

    if p_id_status_certificacion = 4 then
     -- ver si la certificacion esta autorizada
      select id_status_certificacion
        into v_status_certificacion
        from suirplus.cer_certificaciones_t
       where id_certificacion = p_id_certificacion;

      if v_status_certificacion = 3 then
     --Le actualizamos el estatus de entregada a la certificacion que este con status autorizada.---
         ActualizarStatusCer(p_comentario,
                            p_id_certificacion,
                            p_id_status_certificacion,
                           p_id_usuario);
      end if;
    end if;


    select count(*)
    into v_tipo_certificacion2
    from cer_certificaciones_t t join cer_roles_certificaciones_t r
    on t.id_tipo_certificacion = r.id_tipo_certificacion
    where t.id_certificacion = p_id_certificacion;

   if p_id_status_certificacion = 3 and v_tipo_certificacion2 > 0 then
        --Le actualizamos el estatus de entregada a la certificacion que este con status autorizada.---

        ActualizarStatusCer('Completado por proceso de Certificaciones Interactivas',
                            p_id_certificacion,
                            4,
                            p_id_usuario);

    --insertamos nuevamente el registro en el historico ahora con el estatus entregado
    v_seg_his_cer := getSecuenciaCerHis();
    insert into cer_his_certificaciones_t
      (id_his_certificacion,
       id_certificacion,
       status,
       usuario,
       fecha,
       comentario)
    values
      (v_seg_his_cer,
       p_id_certificacion,
       4,
       p_id_usuario,
       sysdate,
       'Completado por proceso de Certificaciones Interactivas');



   else
      --Le actualizamos el estatus a la certificacion especificada--
    ActualizarStatusCer(p_comentario,
                        p_id_certificacion,
                        p_id_status_certificacion,
                        p_id_usuario);

    -- buscar el tipo de certificacion correspondiente a la certificacion que se le esta cambiando el estatus.
    -- Para luego insertar el CRM--

   end if;


    Begin
      select t.id_tipo_certificacion, t.id_registro_patronal
        into v_tipo_certificacion, v_id_registro_patronal
        from cer_certificaciones_t t
       where t.id_certificacion = p_id_certificacion;

      AgregarCRM(v_tipo_certificacion,
                 p_id_usuario,
                 p_resultnumber,
                 v_id_registro_patronal,
                 'Se Modifico una Certificacion de Tipo '||v_tipo_certificacion);

    EXCEPTION

      When no_data_found then
        p_resultnumber := null;
        return;
      when others then
        v_bderror      := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                  SQLERRM,
                                  1,
                                  255));
        p_resultnumber := Seg_Retornar_Cadena_Error(-1, v_bderror, null);
    End;

    p_resultnumber := 0;
    commit;
  exception
    When e_invalidcertificacion then
      p_resultnumber := Seg_Retornar_Cadena_Error(32, NULL, NULL);
      RETURN;
    When e_Existe_Status then
      p_resultnumber := Seg_Retornar_Cadena_Error(300, NULL, NULL);
      RETURN;
    when e_pendiente_autorizacion then
      p_resultnumber := Seg_Retornar_Cadena_Error(81, NULL, NULL);
      RETURN;
    when e_rechazada_certificacion then
      p_resultnumber := Seg_Retornar_Cadena_Error(82, NULL, NULL);
      RETURN;
    when others then
      v_bderror      := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultnumber := Seg_Retornar_Cadena_Error(-1, v_bderror, null);
      RETURN;
  end CambiarStatusCert;

-- ************************************************************************--
-- ************************************************************************--
 function getFechaCertificacion(p_id_certificacion in cer_certificaciones_t.id_certificacion%type)
    return date  is

 v_fecha_entrega date;
 v_fecha_creacion date;
 v_count number;

 BEGIN
    BEGIN
      SELECT max(h.fecha), count(*)
        INTO v_fecha_entrega, v_count
       FROM  cer_his_certificaciones_t h
       WHERE H.id_certificacion = p_id_certificacion
         AND h.status = 4;

      if v_count = 0 then
            SELECT  c.fecha_creacion
              INTO v_fecha_creacion
             FROM cer_certificaciones_t c
            WHERE c.id_certificacion = p_id_certificacion;

            RETURN v_fecha_creacion;
      end if;

     END;

     RETURN v_fecha_entrega;

 END;


  -- **************************************************************************************************
  -- PROCEDIMIENTO: getCertificacion(Nuevo by charlie pena)
  -- DESCRIPCION: Consulta que presenta el contenido de una certificacion,tomando en consideracion el parametro de entrada (p_id_certificacion).
  -- **************************************************************************************************
  PROCEDURE getCertificacion(p_id_certificacion IN CER_CERTIFICACIONES_T.id_certificacion%TYPE,
                             p_iocursor         OUT t_cursor,
                             p_resultnumber     OUT VARCHAR2)

   IS
    e_invalidcertificacion EXCEPTION;
    v_nss               number(10);
    v_FechaPago         varchar2(15);
    v_TipoCertificacion varchar2(2);
    v_bderror           VARCHAR(1000);

    c_cursor t_cursor;

  BEGIN
    IF NOT Cer_Certificaciones_Pkg.isExisteCertificacion(p_id_certificacion) THEN
      RAISE e_invalidcertificacion;
    END IF;

    select c.id_nss, c.id_tipo_certificacion
      into v_nss, v_TipoCertificacion
      from cer_certificaciones_t c
     where c.id_certificacion = p_id_certificacion;

    if (v_TipoCertificacion = 'B') then
      SELECT MAX(f2.FECHA_PAGO)
        into v_FechaPago
        FROM SFC_DET_FACTURAS_T d, SFC_FACTURAS_V f2
       WHERE d.ID_REFERENCIA = f2.ID_REFERENCIA
         AND f2.STATUS = 'PA'
         AND d.ID_NSS = v_nss;

      Open c_cursor for
        SELECT f.id_referencia,
               c.id_certificacion,
               c.id_usuario,
               c.id_tipo_certificacion Id_Tipo,
               c.id_status_certificacion Id_Status,
               t.tipo_certificacion_des Descripcion,
               NVL(e.rnc_o_cedula, '') rnc,
               ci.id_nss nss,
               replace(to_char(c.fecha_desde,
                               'dd/Month/yyyy',
                               'NLS_DATE_LANGUAGE = spanish'),
                       ' ',
                       '') fecha_desde,
               replace(to_char(c.fecha_hasta,
                               'dd/Month/yyyy',
                               'NLS_DATE_LANGUAGE = spanish'),
                       ' ',
                       '') fecha_hasta,
               c.firma,
               Cer_Certificaciones_pkg.getFechaCertificacion(p_id_certificacion) fecha_creacion,
               NVL(e.razon_social, '') razonsocial,
               e.nombre_comercial,
               NVL(ci.no_documento, '') cedula,
               InitCap((ci.nombres || ' ' || NVL(ci.primer_apellido, '') || ' ' ||
                       NVL(ci.segundo_apellido, ''))) nombre,
               t.encabezado_1,
               t.encabezado_2,
               t.pie_de_pagina,
               e.fecha_inicio_actividades,
               f.periodo_factura,
               (df.aporte_afiliados_svds + df.aporte_afiliados_sfs +
               df.aporte_voluntario) retenciones,
               df.salario_ss,
               TRUNC(f.FECHA_PAGO) fecha_pago,
               fi.firma as nombre_resp_firma,
               fi.puesto_resp_firma as puesto_resp_firma,
               s.id_status_certificacion as id_status,
               s.descripcion as desc_status,
               c.comentario,
               c.no_certificacion,
               c.pin,
               fi.firma_imagen "firma_imagen",
               c.pdf
          from cer_certificaciones_t c
          join cer_tipos_certificaciones_t t
            on c.id_tipo_certificacion = t.id_tipo_certificacion
          left join sre_empleadores_t e
            on c.id_registro_patronal = e.id_registro_patronal
          left join sfc_det_facturas_v df
            on c.id_nss = df.id_nss
          left join sfc_facturas_v f
            on f.id_referencia = df.id_referencia
          left join sre_ciudadanos_t ci
            on c.id_nss = ci.id_nss
          join cer_status_certificaciones_t s
            on c.id_status_certificacion = s.id_status_certificacion
          join cer_catalogo_firmas_t fi
            on c.id_firma = fi.id_firma
         where c.id_certificacion = p_id_certificacion
           and ci.id_nss = v_nss
           and f.fecha_pago = v_FechaPago
         order by f.fecha_pago desc;

      p_resultnumber := 0;
      p_iocursor     := c_cursor;
      return;

    end if;

    if v_TipoCertificacion = '7' then
      OPEN c_cursor FOR
        select f.id_referencia,
               c.id_certificacion,
               c.id_usuario,
               c.id_tipo_certificacion Id_Tipo,
               c.id_status_certificacion Id_Status,
               t.tipo_certificacion_des Descripcion,
               NVL(e.rnc_o_cedula, '') rnc,
               ci.id_nss nss,
               replace(to_char(c.fecha_desde,
                               'dd/Month/yyyy',
                               'NLS_DATE_LANGUAGE = spanish'),
                       ' ',
                       '') fecha_desde,
               replace(to_char(c.fecha_hasta,
                               'dd/Month/yyyy',
                               'NLS_DATE_LANGUAGE = spanish'),
                       ' ',
                       '') fecha_hasta,
               c.firma,
               Cer_Certificaciones_pkg.getFechaCertificacion(p_id_certificacion) fecha_creacion,
               NVL(e.razon_social, '') razonsocial,
               e.nombre_comercial,
               NVL(ci.no_documento, '') cedula,
               (ci.nombres || ' ' || NVL(ci.primer_apellido, '') || ' ' ||
               NVL(ci.segundo_apellido, '')) nombre,
               replace(replace(to_char(c.fecha_desde,
                                       'Month"_del_"yyyy',
                                       'NLS_DATE_LANGUAGE = spanish'),
                               ' ',
                               ''),
                       '_',
                       ' ') Periodo_Desde,
               replace(replace(to_char(c.fecha_hasta,
                                       'Month"_del_"yyyy',
                                       'NLS_DATE_LANGUAGE = spanish'),
                               ' ',
                               ''),
                       '_',
                       ' ') Periodo_Hasta,
               t.encabezado_1,
               t.encabezado_2,
               t.pie_de_pagina,
               e.fecha_inicio_actividades,
               f.periodo_factura,
               (df.aporte_afiliados_svds + df.aporte_afiliados_sfs +
               df.aporte_voluntario) retenciones,
               df.salario_ss,
               TRUNC(f.FECHA_PAGO) fecha_pago,
               fi.firma as nombre_resp_firma,
               fi.puesto_resp_firma as puesto_resp_firma,
               s.id_status_certificacion as id_status,
               s.descripcion as desc_status,
               c.comentario,
               c.documento,
               c.no_certificacion,
               c.pin,
               fi.firma_imagen "firma_imagen",
               c.pdf
          from cer_certificaciones_t c
          join cer_tipos_certificaciones_t t
            on c.id_tipo_certificacion = t.id_tipo_certificacion
          join sre_empleadores_t e
            on c.id_registro_patronal = e.id_registro_patronal
          left join sfc_det_facturas_v df
            on c.id_nss = df.id_nss
          left join sfc_facturas_v f
            on f.id_referencia = df.id_referencia
          left join sre_ciudadanos_t ci
            on ci.no_documento = e.rnc_o_cedula
          left join cer_status_certificaciones_t s
            on c.ID_STATUS_CERTIFICACION = s.id_status_certificacion
          left join cer_catalogo_firmas_t fi
            on c.id_firma = fi.id_firma
         where c.id_certificacion = p_id_certificacion
         order by f.fecha_pago desc;

      p_resultnumber := 0;
      p_iocursor     := c_cursor;
      return;
    end if;

    OPEN c_cursor FOR
      select c.id_certificacion,
             c.id_usuario,
             c.id_tipo_certificacion Id_Tipo,
             c.id_status_certificacion Id_Status,
             t.tipo_certificacion_des Descripcion,
             NVL(e.rnc_o_cedula, '') rnc,
             ci.id_nss nss,
             replace(to_char(c.fecha_desde,
                             'dd/Month/yyyy',
                             'NLS_DATE_LANGUAGE = spanish'),
                     ' ',
                     '') fecha_desde,
             replace(to_char(c.fecha_hasta,
                             'dd/Month/yyyy',
                             'NLS_DATE_LANGUAGE = spanish'),
                     ' ',
                     '') fecha_hasta,
             c.firma,
             Cer_Certificaciones_pkg.getFechaCertificacion(p_id_certificacion) fecha_creacion,
             NVL(e.razon_social, '') razonsocial,
             e.nombre_comercial,
             NVL(ci.no_documento, '') cedula,
             (ci.nombres || ' ' || NVL(ci.primer_apellido, '') || ' ' ||
             NVL(ci.segundo_apellido, '')) nombre,
             ci.fecha_nacimiento,
             na.nacionalidad_des,
             replace(replace(to_char(c.fecha_desde,
                                     'Month"_del_"yyyy',
                                     'NLS_DATE_LANGUAGE = spanish'),
                             ' ',
                             ''),
                     '_',
                     ' ') Periodo_Desde,
             replace(replace(to_char(c.fecha_hasta,
                                     'Month"_del_"yyyy',
                                     'NLS_DATE_LANGUAGE = spanish'),
                             ' ',
                             ''),
                     '_',
                     ' ') Periodo_Hasta,
             t.encabezado_1,
             t.encabezado_2,
             t.pie_de_pagina,
             e.fecha_inicio_actividades,
             fi.firma as nombre_resp_firma,
             fi.puesto_resp_firma as puesto_resp_firma,
             s.id_status_certificacion as id_status,
             s.descripcion as desc_status,
             c.comentario,
             c.documento,             
             c.no_certificacion,
             c.pin,
             fi.firma_imagen "firma_imagen",
             c.pdf
        from cer_certificaciones_t c
        join cer_tipos_certificaciones_t t
          on c.id_tipo_certificacion = t.id_tipo_certificacion
        left join sre_empleadores_t e
          on c.id_registro_patronal = e.id_registro_patronal
        left join sre_ciudadanos_t ci
          on c.id_nss = ci.id_nss  
        left join sre_nacionalidad_t na on na.id_nacionalidad = ci.id_nacionalidad
        left join cer_status_certificaciones_t s
          on c.id_status_certificacion = s.id_status_certificacion
        left join cer_catalogo_firmas_t fi
          on c.id_firma = fi.id_firma         
       where c.id_certificacion = p_id_certificacion;

    p_resultnumber := 0;
    p_iocursor     := c_cursor;

  EXCEPTION

    WHEN e_invalidcertificacion THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(32, NULL, NULL);
      RETURN;

    WHEN OTHERS THEN
      v_bderror      := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultnumber := Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
      RETURN;
  END;

  -- **************************************************************************************************
  -- Program:     getDetalleCertificacion(Nuevo by charlie pena)
  -- Description:
  -- **************************************************************************************************

  PROCEDURE getDetalleCertificacion(p_IdCertificacion in cer_certificaciones_t.id_certificacion%type,
                                    p_TipoDetalle     in varchar2,
                                    p_iocursor        OUT t_cursor)

   IS
    --0 e_invalidnss        exception;
    v_conteo            number;
    v_conteo2           number;
    v_fechadesde        date;
    v_fechahasta        date;
    v_regpatronal       number(9);
    v_Status            varchar2(50);
    v_existe            varchar(1);
    v_PeriodoVigente    number;
    v_periodoCalculado  number;
    v_idnss             number(10);
    v_TipoCertificacion varchar2(3);
    -- v_bderror           VARCHAR(1000);
    c_cursor t_cursor;

  BEGIN

    select c.id_registro_patronal,
           c.id_nss,
           c.id_tipo_certificacion,
           c.fecha_desde,
           c.fecha_hasta
      into v_regpatronal,
           v_idnss,
           v_TipoCertificacion,
           v_fechadesde,
           v_fechahasta
      from cer_certificaciones_t c
     where c.id_certificacion = p_IdCertificacion;

    IF v_TipoCertificacion = '1' THEN

      OPEN c_cursor FOR
        SELECT DISTINCT A.PERIODO_FACTURA PERIODO,
                        A.ID_REFERENCIA NO_REFERENCIA,
                        TO_CHAR(a.FECHA_PAGO, 'DD/MM/YYYY') FECHA_PAGO,
                        TO_CHAR(a.FECHA_PAGO, 'DD/MM/YYYY') FECHA2,
                        --                        srp_mantenimiento_pkg.Get_FechaFinPeriodo(to_CHAR(a.FECHA_EMISION,'MM/DD/YYYY')) FECHA_LIMITE_PAGO,
                        srp_mantenimiento_pkg.Get_FechaFinPeriodo(to_char(to_date(A.periodo_factura || '01',
                                                                                  'yyyymmdd'),
                                                                          'MM/DD/YYYY')) FECHA_LIMITE_PAGO,
                        a.Total_Importe MONTO_PAGADO,
                        SUBSTR(a.PERIODO_FACTURA, 5, 6) C_MES_APLICACION,
                        A.ID_TIPO_FACTURA C_TIPO_FACTURA,
                        (case
                          when a.fecha_pago >
                              --                               srp_mantenimiento_pkg.Get_FechaFinPeriodo(to_CHAR(a.FECHA_EMISION,'MM/DD/YYYY')) then
                               srp_mantenimiento_pkg.Get_FechaFinPeriodo(to_char(to_date(A.periodo_factura || '01',
                                                                                         'yyyymmdd'),
                                                                                 'MM/DD/YYYY')) then
                           'SI'
                          else
                           'NO'
                        end) Pago_Atrasado
          FROM sfc_facturas_v A, SRE_EMPLEADORES_T B, sfc_det_facturas_v D
         WHERE A.ID_REGISTRO_PATRONAL = B.ID_REGISTRO_PATRONAL
           AND A.ID_REFERENCIA = D.ID_REFERENCIA
           AND A.STATUS = 'PA'
           AND TRUNC(a.FECHA_EMISION) BETWEEN (v_fechadesde) AND
               (v_fechahasta)
           AND b.id_registro_patronal = v_regpatronal
         ORDER BY TO_DATE(FECHA_PAGO, 'DD/MM/YYYY') DESC;
    END IF;

    IF v_TipoCertificacion = '2' THEN
      --Certificacion de emp`leado de empleador

      OPEN c_cursor FOR
        SELECT a.PERIODO_FACTURA PERIODO,
               d.SALARIO_SS SALARIO,
               (d.APORTE_EMPLEADOR_SFS + d.APORTE_EMPLEADOR_SVDS +
               d.APORTE_EMPLEADOR_T3 + d.APORTE_EMPLEADOR_IDSS) CONTRIBUCION_EMPLEADOR,
               (d.APORTE_AFILIADOS_SFS + d.APORTE_AFILIADOS_SVDS +
               d.APORTE_AFILIADOS_T3 + d.APORTE_AFILIADOS_IDSS) APORTE_TRABAJADOR,
               d.APORTE_VOLUNTARIO APORTE_VOLUNTARIO,
               ((d.APORTE_EMPLEADOR_SFS + d.APORTE_EMPLEADOR_SVDS +
               d.APORTE_EMPLEADOR_T3 + d.APORTE_EMPLEADOR_IDSS) +
               (d.APORTE_AFILIADOS_SFS + d.APORTE_AFILIADOS_SVDS +
               d.APORTE_AFILIADOS_T3 + d.APORTE_AFILIADOS_IDSS) +
               (d.APORTE_VOLUNTARIO)) SUB_TOTAL,
               a.ID_REFERENCIA NO_REFERENCIA,
               TO_CHAR(a.FECHA_PAGO, 'DD/MM/YYYY') FECHA_PAGO,
               TO_CHAR(a.FECHA_PAGO, 'DD/MM/YYYY') FECHA2,
               --               srp_mantenimiento_pkg.Get_FechaFinPeriodo(to_CHAR(a.FECHA_EMISION,'MM/DD/YYYY')) FECHA_LIMITE_PAGO,
               srp_mantenimiento_pkg.Get_FechaFinPeriodo(to_char(to_date(A.periodo_factura || '01',
                                                                         'yyyymmdd'),
                                                                 'MM/DD/YYYY')) FECHA_LIMITE_PAGO,
               SUBSTR(a.PERIODO_FACTURA, 5, 6) C_MES_APLICACION,
               A.ID_TIPO_FACTURA C_TIPO_FACTURA,
               (case
                 when a.fecha_pago >
                     --                      srp_mantenimiento_pkg.Get_FechaFinPeriodo(to_CHAR(a.FECHA_EMISION,'MM/DD/YYYY')) then
                      srp_mantenimiento_pkg.Get_FechaFinPeriodo(to_char(to_date(A.periodo_factura || '01',
                                                                                'yyyymmdd'),
                                                                        'MM/DD/YYYY')) THEN
                  'SI'
                 else
                  'NO'
               end) Pago_Atrasado,
               (d.APORTE_AFILIADOS_SVDS + d.APORTE_EMPLEADOR_SVDS +
               d.APORTE_VOLUNTARIO + d.APORTE_AFILIADOS_SFS +
               d.APORTE_EMPLEADOR_SFS) APORTE --(d.APORTE_AFILIADOS_SVDS + d.APORTE_AFILIADOS_SFS)RETENCION

          FROM sfc_facturas_v A, SRE_EMPLEADORES_T B, sfc_det_facturas_v D
         WHERE A.ID_REGISTRO_PATRONAL = B.ID_REGISTRO_PATRONAL
           AND A.ID_REFERENCIA = D.ID_REFERENCIA
           AND A.STATUS = 'PA'
           AND TRUNC(a.FECHA_EMISION) BETWEEN (v_fechadesde) AND
               (v_fechahasta)
           AND d.ID_NSS = v_idnss
           AND b.id_registro_patronal = v_regpatronal
         ORDER BY TO_DATE(FECHA_PAGO, 'DD/MM/YYYY') DESC;

      p_iocursor := c_cursor;

    END IF;
    -----------------------------------------------------------------------------------------
    --Certificacion personal
    IF p_TipoDetalle = '3Empleador' THEN
      OPEN c_cursor FOR
        SELECT b.rnc_o_cedula RNC,
               b.razon_social RAZON_SOCIAL,
               COUNT(*) CANTIDAD,
               SUM(d.APORTE_EMPLEADOR_SFS + d.APORTE_EMPLEADOR_SVDS +
                   d.APORTE_EMPLEADOR_T3 + d.APORTE_EMPLEADOR_IDSS) CONTRIBUCION_EMPLEADOR,
               SUM(d.APORTE_AFILIADOS_SFS + d.APORTE_AFILIADOS_SVDS +
                   d.APORTE_AFILIADOS_T3 + d.APORTE_AFILIADOS_IDSS) APORTE_TRABAJADOR,
               SUM(d.APORTE_VOLUNTARIO) APORTE_VOLUNTARIO,
               SUM((d.APORTE_EMPLEADOR_SFS + d.APORTE_EMPLEADOR_SVDS +
                   d.APORTE_EMPLEADOR_T3 + d.APORTE_EMPLEADOR_IDSS) +
                   (d.APORTE_AFILIADOS_SFS + d.APORTE_AFILIADOS_SVDS +
                   d.APORTE_AFILIADOS_T3 + d.APORTE_AFILIADOS_IDSS) +
                   (d.APORTE_VOLUNTARIO)) SUB_TOTAL
          FROM sfc_facturas_v A, SRE_EMPLEADORES_T B, sfc_det_facturas_v D
         WHERE A.ID_REGISTRO_PATRONAL = B.ID_REGISTRO_PATRONAL
           AND A.ID_REFERENCIA = D.ID_REFERENCIA
           AND A.STATUS = 'PA'
           AND TRUNC(a.FECHA_EMISION) BETWEEN (v_fechadesde) AND
               (v_fechahasta)
           AND d.ID_NSS = v_idnss
         GROUP BY b.rnc_o_cedula, b.razon_social;

      p_iocursor := c_cursor;

    END IF;
    --------------------------------------------------------------------------------------------
    --Detalle Certificacion personal
    IF p_TipoDetalle = '3Aporte' THEN
      OPEN c_cursor FOR
        SELECT a.PERIODO_FACTURA PERIODO,
               b.rnc_o_cedula RNC,
               d.SALARIO_SS SALARIO,
               (d.APORTE_EMPLEADOR_SFS + d.APORTE_EMPLEADOR_SVDS +
               d.APORTE_EMPLEADOR_T3 + d.APORTE_EMPLEADOR_IDSS) CONTRIBUCION_EMPLEADOR,
               (d.APORTE_AFILIADOS_SFS + d.APORTE_AFILIADOS_SVDS +
               d.APORTE_AFILIADOS_T3 + d.APORTE_AFILIADOS_IDSS) APORTE_TRABAJADOR,
               d.APORTE_VOLUNTARIO APORTE_VOLUNTARIO,
               ((d.APORTE_EMPLEADOR_SFS + d.APORTE_EMPLEADOR_SVDS +
               d.APORTE_EMPLEADOR_T3 + d.APORTE_EMPLEADOR_IDSS) +
               (d.APORTE_AFILIADOS_SFS + d.APORTE_AFILIADOS_SVDS +
               d.APORTE_AFILIADOS_T3 + d.APORTE_AFILIADOS_IDSS) +
               (d.APORTE_VOLUNTARIO)) SUB_TOTAL,
               a.ID_REFERENCIA NO_REFERENCIA,
               TO_CHAR(a.FECHA_PAGO, 'DD/MM/YYYY') FECHA_PAGO,
               TO_CHAR(a.FECHA_PAGO, 'DD/MM/YYYY') FECHA2,
               --srp_mantenimiento_pkg.Get_FechaFinPeriodo(to_CHAR(a.FECHA_EMISION,'MM/DD/YYYY')) FECHA_LIMITE_PAGO,
               srp_mantenimiento_pkg.Get_FechaFinPeriodo(to_char(to_date(A.periodo_factura || '01',
                                                                         'yyyymmdd'),
                                                                 'MM/DD/YYYY')) FECHA_LIMITE_PAGO,
               a.ID_TIPO_FACTURA C_TIPO_FACTURA,
               SUBSTR(a.PERIODO_FACTURA, 5, 6) C_MES_APLICACION,
               (case
                 when a.fecha_pago >
                     --                      srp_mantenimiento_pkg.Get_FechaFinPeriodo(to_CHAR(a.FECHA_EMISION,'MM/DD/YYYY')) then
                      srp_mantenimiento_pkg.Get_FechaFinPeriodo(to_char(to_date(A.periodo_factura || '01',
                                                                                'yyyymmdd'),
                                                                        'MM/DD/YYYY')) THEN
                  'SI'
                 else
                  'NO'
               end) Pago_Atrasado,
               (d.APORTE_AFILIADOS_SVDS + d.APORTE_EMPLEADOR_SVDS +
               d.APORTE_VOLUNTARIO + d.APORTE_AFILIADOS_SFS +
               d.APORTE_EMPLEADOR_SFS) APORTE --(d.APORTE_AFILIADOS_SVDS + d.APORTE_AFILIADOS_SFS)RETENCION
          FROM sfc_facturas_v A, SRE_EMPLEADORES_T B, sfc_det_facturas_v D
         WHERE A.ID_REGISTRO_PATRONAL = B.ID_REGISTRO_PATRONAL
           AND A.ID_REFERENCIA = D.ID_REFERENCIA
           AND A.STATUS = 'PA'
           AND TRUNC(a.FECHA_EMISION) BETWEEN (v_fechadesde) AND
               (v_fechahasta)
           AND d.ID_NSS = v_idnss

         ORDER BY TO_CHAR(A.FECHA_PAGO, 'DD/MM/YYYY') DESC;

      p_iocursor := c_cursor;

    END IF;
    ------------------------------------------------------------------------------------------
    if v_TipoCertificacion = '9' then

      ---Detalle Certificacion de Ingreso Tardio(AFP)

      v_Status := null;

      v_PeriodoVigente := parm.periodo_vigente();
      select to_char(ADD_MONTHS(to_date(v_PeriodoVigente, 'YYYYMM'), -3),'YYYYMM')
        into v_periodoCalculado
        from dual;

      begin
        select count(*)
          into v_conteo
          from suirplus.sre_trabajadores_t t
          join suirplus.sre_empleadores_t e
            on e.id_registro_patronal = t.id_registro_patronal
           and e.status = 'A'
          join suirplus.sre_nominas_t n
            on n.id_registro_patronal = t.id_registro_patronal
           and n.id_nomina = t.id_nomina
           and n.status = 'A'
         where t.id_nss = v_idnss
           and t.status = 'A'
           and n.tipo_nomina <> 'P';
      end;

      --activo en nomina--

      if (v_conteo > 0) then
        v_status := 'Activo en Nomina';
      else
        --Cesante Menos de 3 Meses--
        select count(*)
          into v_conteo
          from suirplus.sfc_det_facturas_t df
          join suirplus.sfc_facturas_v f
            on f.id_referencia = df.id_referencia
           and f.status in ('VI', 'VE', 'PA')
           and f.id_tipo_factura <> 'U'
           and f.periodo_factura >= v_periodoCalculado
         where df.id_nss = v_idnss;

        select count(*)
          into v_conteo2
          from suirplus.sfc_det_facturas_t df
          join suirplus.sfc_facturas_v f
            on f.id_referencia = df.id_referencia
           and f.status in ('VI', 'VE', 'PA')
           and f.id_tipo_factura = 'U'
         where df.id_nss = v_idnss
           and df.periodo_aplicacion >= v_periodoCalculado;

        if (v_Conteo > 0 or v_Conteo2 > 0) then
          v_status := 'Cesante Menos de 3 Meses';

          -------------------------------------------------
        else
          --Cesante Mas de 3 Meses--
          select count(*)
            into v_conteo
            from suirplus.sfc_det_facturas_t df
            join suirplus.sfc_facturas_v f
              on f.id_referencia = df.id_referencia
             and f.status in ('VI', 'VE', 'PA')
             and f.id_tipo_factura <> 'U'
             and f.periodo_factura < v_periodoCalculado
           where df.id_nss = v_idnss;

          select count(*)
            into v_conteo2
            from suirplus.sfc_det_facturas_t df
            join suirplus.sfc_facturas_v f
              on f.id_referencia = df.id_referencia
             and f.status in ('VI', 'VE', 'PA')
             and f.id_tipo_factura = 'U'
           where df.id_nss = v_idnss
             and df.periodo_aplicacion < v_periodoCalculado;

          if (v_Conteo > 0 or v_Conteo2 > 0) then
            v_status := 'Cesante Mas de 3 Meses';
          end if;

        end if;
      end if;

      --traemos el registro correspondiente al nss recibido
      if v_Status <> 'Activo en Nomina' then
      Open c_cursor for
        select c.id_nss nss,
               c.no_documento Cedula,
               c.nombres || ' ' || nvl(c.primer_apellido, '') || ' ' ||
               nvl(c.segundo_apellido, '') Nombre,
               v_Status Status
          from sre_ciudadanos_t c
         where c.id_nss = v_idnss;

         else
         -- Task #7186:
         --Agregamos los datos del empleador y el tipo de nomina para el caso en que el solicitante se encuentre activo.
          Open c_cursor for
             select c.id_nss nss,c.no_documento Cedula,c.nombres || ' ' || nvl(c.primer_apellido, '') || ' ' ||
               nvl(c.segundo_apellido, '') Nombre,v_Status Status,e.rnc_o_cedula,e.razon_social,tn.descripcion tipo_nomina
          from suirplus.sre_trabajadores_t t
          join sre_ciudadanos_t c on c.id_nss = t.id_nss
          join suirplus.sre_empleadores_t e
            on e.id_registro_patronal = t.id_registro_patronal
           and e.status = 'A'
          join suirplus.sre_nominas_t n
            on n.id_registro_patronal = t.id_registro_patronal
          join sfc_tipo_nominas_t tn on tn.id_tipo_nomina = n.tipo_nomina
           and n.id_nomina = t.id_nomina
           and n.status = 'A'
         where t.id_nss = v_idnss
           and t.status = 'A'
           and n.tipo_nomina <> 'P';
      end if;

      p_iocursor := c_cursor;
      -- p_resultnumber := 0;
    end if;

    if v_TipoCertificacion = '13' then
      OPEN c_cursor FOR

        select s.periodo_factura,
               s.id_referencia,
               s.status_des,
               sysdate,
               s.total_importe,
               tc.encabezado_1,
               tc.pie_de_pagina,
               c.fecha_creacion,
               n.nomina_des,
               NVL(e.razon_social, '') razonsocial,
               e.rnc_o_cedula
          from sfc_facturas_v s
          join cer_certificaciones_t c
            on c.id_registro_patronal = s.id_registro_patronal
          join cer_tipos_certificaciones_t tc
            on tc.id_tipo_certificacion = c.id_tipo_certificacion
          left join sre_nominas_t n
            on n.id_nomina = s.id_nomina
           and n.id_registro_patronal = s.id_registro_patronal
          join sre_empleadores_t e
            on e.id_registro_patronal = c.id_registro_patronal
         where c.id_certificacion = p_IdCertificacion
           and s.status_des in ('Vencida')
           and s.no_autorizacion is null
         group by s.periodo_factura,
                  s.id_referencia,
                  s.status_des,
                  s.total_importe,
                  tc.encabezado_1,
                  tc.pie_de_pagina,
                  c.fecha_creacion,
                  n.nomina_des,
                  e.razon_social,
                  e.rnc_o_cedula
         order by s.periodo_factura desc;

      --p_resultnumber := 0;
      p_iocursor := c_cursor;
      return;
    end if;

    ------------------------------------------------------------------------------------

    if v_TipoCertificacion = 10 then

      ---Detalle Certificacion de Discapacidad
      Open c_cursor for
      /*
        Select e.rnc_o_cedula rnc,e.razon_social,f.id_nomina,df.salario_ss Salario_Cotizable,f.periodo_factura,
               srp_pkg.fecha_limite_pago_ss(f.periodo_factura) FechaLimitePago,f.fecha_pago,
               decode(f.id_tipo_factura, 'U', 'Auditoria', 'Normal') TipoPago
        from sre_trabajadores_t t, suirplus.sfc_facturas_v f, suirplus.sfc_det_facturas_t df, suirplus.sre_empleadores_t  e
        WHERE t.id_nss = v_idnss
        and t.id_registro_patronal = e.id_registro_patronal
        and t.id_registro_patronal = f.id_registro_patronal
        and f.id_referencia = df.id_referencia
        and t.id_nss= df.id_nss
        and f.status = 'PA'
        order by f.id_registro_patronal,f.ID_NOMINA,f.periodo_factura;*/

        Select e.rnc_o_cedula rnc,
               e.razon_social,
               f.id_nomina,
               df.salario_ss Salario_Cotizable,
               f.periodo_factura,
               srp_pkg.fecha_limite_pago_ss(f.periodo_factura) FechaLimitePago,
               f.fecha_pago,
               decode(f.id_tipo_factura, 'U', 'Auditoria', 'Normal') TipoPago
          from suirplus.sfc_facturas_v     f,
               suirplus.sfc_det_facturas_t df,
               suirplus.sre_empleadores_t  e
         WHERE df.id_nss = v_idnss
           and f.id_registro_patronal = e.id_registro_patronal
           and f.id_referencia = df.id_referencia
           and f.status = 'PA'
         order by f.id_registro_patronal, f.ID_NOMINA, f.periodo_factura;

      p_iocursor := c_cursor;

    end if;

    IF v_TipoCertificacion = '15' THEN

      OPEN c_cursor FOR
        select count(t.id_nss) Total_Empleados,
               '100,000.00' MontoNomina,
               '0.10' Porcentaje,
               '0.25' Categoria
          from sre_trabajadores_t t
         where t.id_registro_patronal = v_regpatronal
           and t.status = 'A';

      p_iocursor := c_cursor;

      return;
    END IF;

    if v_TipoCertificacion = '18' then
      OPEN c_cursor FOR

       select s.periodo_factura,
               s.id_referencia,
               s.status_des,
               s.total_importe,
               n.nomina_des,
               NVL(e.razon_social, '') razonsocial,
               e.rnc_o_cedula,
               s.total_trabajadores
          from sfc_facturas_v s
          left join sre_nominas_t n
            on n.id_nomina = s.id_nomina
           and n.id_registro_patronal = s.id_registro_patronal
          join sre_empleadores_t e
            on e.id_registro_patronal = s.id_registro_patronal
        WHERE  s.STATUS = 'PA'
          AND TRUNC(s.FECHA_EMISION) BETWEEN (v_fechadesde) AND
               (v_fechahasta)
         AND E.Id_Registro_Patronal = v_regpatronal;

      --p_resultnumber := 0;
      p_iocursor := c_cursor;
      return;
    end if;


    /*
    EXCEPTION

        WHEN e_invalidnss THEN
            p_resultnumber := Seg_Retornar_Cadena_Error(30, NULL, NULL);
        RETURN;

        WHEN OTHERS THEN
            v_bderror := (SUBSTR('error '||TO_CHAR(SQLCODE)||': '||SQLERRM, 1, 255));
            p_resultnumber := Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
        RETURN;*/
  END;

  -- **************************************************************************************************
  -- PROCEDIMIENTO:     getMontoAdeudado
  -- DESCRIPTION:       Trae trae el monto total que debe un empleador para una certificacion especifica.
  -- AUTOR:             Yacell Borges
  -- FECHA:             08-03-2012
  -- **************************************************************************************************
  Procedure getMontoAdeudado(p_idcertificacion in cer_certificaciones_t.id_certificacion%type,
                             p_monto           out number,
                             p_resultnumber    out varchar2)

   is
    e_invalidcertificacion exception;
    v_bderror VARCHAR(1000);
    v_monto   number;

  begin
    select sum(s.total_importe)
      into v_monto
      from sfc_facturas_v s
      join cer_certificaciones_t c
        on c.id_registro_patronal = s.id_registro_patronal
      join cer_tipos_certificaciones_t tc
        on tc.id_tipo_certificacion = c.id_tipo_certificacion
      left join sre_nominas_t n
        on n.id_nomina = s.id_nomina
       and n.id_registro_patronal = s.id_registro_patronal
      join sre_empleadores_t e
        on e.id_registro_patronal = c.id_registro_patronal
     where c.id_certificacion = p_idcertificacion
       and s.status_des in ('Vencida')
       and s.no_autorizacion is null;

    if v_monto is null then
      p_resultnumber := Seg_Retornar_Cadena_Error(234, NULL, NULL);
    else
      p_resultnumber := 0;
      p_monto        := v_monto;
    end if;

  EXCEPTION
    when e_invalidcertificacion then
      p_resultnumber := Seg_Retornar_Cadena_Error(32, NULL, NULL);
      RETURN;
    WHEN OTHERS THEN
      v_bderror      := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ':' ||
                                SQLERRM,
                                1,
                                255));
      p_resultnumber := Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);

  end getMontoAdeudado;
  -- ******************************************************************************************************
  -- PROCEDIMIENTO:     getCertificaciones
  -- DESCRIPTION:       Trae trae el listado de las certificaciones por el Status especificado
  -- AUTOR:             Francis Ramirez
  -- FECHA:             2010-08-02
  -- ******************************************************************************************************
  Procedure getCertificaciones(p_numCert                 IN CER_CERTIFICACIONES_T.ID_CERTIFICACION%TYPE,
                               p_no_certificacion        IN CER_CERTIFICACIONES_T.No_Certificacion%TYPE,
                               p_rnc_o_cedula            IN SRE_EMPLEADORES_T.rnc_o_cedula%TYPE,
                               p_cedula                  IN SRE_CIUDADANOS_T.no_documento%TYPE,
                               p_id_status_certificacion in cer_status_certificaciones_t.id_status_certificacion%type,
                               p_tipo                    in varchar2,
                               p_pagenum                 in number,
                               p_pagesize                in number,
                               p_desde                   in date,
                               p_hasta                   in date,
                               p_iocursor                IN OUT t_cursor,
                               p_resultnumber            OUT VARCHAR2) is
    c_cursor       t_cursor;
    v_bderror      VARCHAR(1000);
    v_dinamicQuery VARCHAR2(5000);
    e_rnc_cedula exception;
    e_Existe_Ciudadano exception;
    e_invalidcertificacion exception;
    e_Existe_Status exception;
    vDesde integer := (p_pagesize * (p_pagenum - 1)) + 1;
    vhasta integer := p_pagesize * p_pagenum;
  begin

    IF p_numCert IS NOT NULL THEN

      if not
          SUIRPLUS.Cer_Certificaciones_Pkg.isExisteCertificacion(p_numCert) then
        raise e_invalidcertificacion;
      end if;

    END IF;

    IF p_no_certificacion IS NOT NULL THEN
      IF NOT
        Cer_Certificaciones_Pkg.isExisteNoCertificacion(p_no_certificacion) THEN
      RAISE e_invalidcertificacion;
    END IF;
     END IF;


    IF p_rnc_o_cedula IS NOT NULL THEN
      if not sre_empleadores_pkg.isRncOCedulaValida(p_rnc_o_cedula) then
        raise e_rnc_cedula;
      end if;

    END IF;

    IF p_cedula IS NOT NULL THEN
      if not SUIRPLUS.Cer_Certificaciones_Pkg.isExisteNodoc(p_cedula) then
        raise e_Existe_Ciudadano;
      end if;
    END IF;

    if p_id_status_certificacion is not null then
      if not ExisteStatus(p_id_status_certificacion) then
        raise e_Existe_Status;
      end if;
    end if;

    OPEN c_cursor FOR
      with pages as
       (Select rownum num, y.*
          from (Select c.id_certificacion,
                       INITCAP(t.tipo_certificacion_des) as tipo,
                       INITCAP(en.razon_social) razon_social,
                       en.rnc_o_cedula,
                       INITCAP(nvl(ci.nombres, '')) || ' ' ||
                       INITCAP(nvl(ci.primer_apellido, '')) || ' ' ||
                       INITCAP(nvl(ci.segundo_apellido, '')) Nombre,
                       c.id_nss,
                       ci.no_documento as Cedula,
                       c.fecha_creacion Fecha,
                       c.id_usuario Usuario,
                       nvl(f.firma, 'N/A') firma,
                       nvl(f.puesto_resp_firma, 'N/A') puesto_resp_firma,
                       nvl(s.descripcion, 'N/A') Estatus_Desc,
                       nvl(c.comentario, 'N/A') comentario,
                       c.documento,
                       C.ULT_USUARIO_ACT Ult_Usuario,
                       c.pin
                  from cer_certificaciones_t c
                  join cer_status_certificaciones_t s
                    on c.id_status_certificacion = s.id_status_certificacion
                  join cer_tipos_certificaciones_t t
                    on c.id_tipo_certificacion = t.id_tipo_certificacion
                  join cer_catalogo_firmas_t f
                    on c.id_firma = f.id_firma
                  left join sre_empleadores_t en
                    on c.id_registro_patronal = en.id_registro_patronal
                  left join sre_ciudadanos_t ci
                    on c.id_nss = ci.id_nss
                 Where (p_numCert is null or c.id_certificacion = p_numCert)
                   and (p_no_certificacion is null or c.NO_CERTIFICACION = p_no_certificacion)
                   and (p_cedula is null or ci.no_documento = p_cedula)
                   and (p_rnc_o_cedula is null or
                       en.rnc_o_cedula = p_rnc_o_cedula)
                   and (p_id_status_certificacion is null or
                       s.id_status_certificacion = p_id_status_certificacion)
                   and ((p_tipo = 'CI' and p_id_status_certificacion = 1) or
                       (
                       --comentado a partir de que se requiriese que salieran todos los estatus en la consulta general
                       /*(p_tipo = 'CAE') and ((p_id_status_certificacion is null and c.id_status_certificacion in (2,3,4,5))
                       or (c.id_status_certificacion = p_id_status_certificacion))*/
                       --habilitada esta linea en sustitucion de la comentada:
                        p_id_status_certificacion is null or
                        c.id_status_certificacion = p_id_status_certificacion))
                   and (p_desde is null or c.FECHA_CREACION >= p_desde)
                   and (p_hasta is null or c.FECHA_CREACION <= p_hasta)
                 order by c.id_status_certificacion asc, c.fecha_creacion desc

                ) y order by num)  
      Select y.recordcount, pages.*
        from pages, (Select max(num) recordcount from pages) y
       where num between vDesde and vhasta
       order by num;

    p_iocursor     := c_cursor;
    p_resultnumber := 0;

  EXCEPTION
    when e_invalidcertificacion then
      p_resultnumber := Seg_Retornar_Cadena_Error(32, NULL, NULL);
      RETURN;
    when e_rnc_cedula then
      p_resultnumber := Seg_Retornar_Cadena_Error(150, NULL, NULL);
      RETURN;
    when e_Existe_Ciudadano then
      p_resultnumber := Seg_Retornar_Cadena_Error(65, NULL, NULL);
      RETURN;
    when e_Existe_Status then
      p_resultnumber := Seg_Retornar_Cadena_Error(300, NULL, NULL);
      RETURN;
    WHEN OTHERS THEN
      v_bderror      := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ':' ||
                                SQLERRM,
                                1,
                                255));
      p_resultnumber := Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);

  end getCertificaciones;
  -- **************************************************************************************************
  -- PROCEDIMIENTO:     consCert
  -- DESCRIPCION:       Consulta de Certificaciones
  -- **************************************************************************************************
  PROCEDURE consCert(p_numCert      IN CER_CERTIFICACIONES_T.ID_CERTIFICACION%TYPE,
                     p_rnc_o_cedula IN SRE_EMPLEADORES_T.rnc_o_cedula%TYPE,
                     p_cedula       IN SRE_CIUDADANOS_T.no_documento%TYPE,
                     p_iocursor     OUT t_cursor,
                     p_resultnumber OUT VARCHAR2) IS

    v_bderror      VARCHAR(1000);
    v_dinamicQuery VARCHAR2(5000);
    e_rnc_cedula exception;
    e_Existe_Ciudadano exception;
    e_invalidcertificacion exception;
    c_cursor t_cursor;

  BEGIN

    IF p_numCert IS NOT NULL THEN

      if not
          SUIRPLUS.Cer_Certificaciones_Pkg.isExisteCertificacion(p_numCert) then
        raise e_invalidcertificacion;
      end if;

    END IF;

    IF p_rnc_o_cedula IS NOT NULL THEN
      if not sre_empleadores_pkg.isRncOCedulaValida(p_rnc_o_cedula) then
        raise e_rnc_cedula;
      end if;
    END IF;

    IF p_cedula IS NOT NULL THEN
      if not SUIRPLUS.Cer_Certificaciones_Pkg.isExisteNodoc(p_cedula) then
        raise e_Existe_Ciudadano;
      end if;
    END IF;

    open c_cursor for
      Select c.id_certificacion,
             INITCAP(t.tipo_certificacion_des) as tipo,
             INITCAP(en.razon_social),
             en.rnc_o_cedula,
             INITCAP(nvl(ci.nombres, '')) || ' ' ||
             INITCAP(nvl(ci.primer_apellido, '')) || ' ' ||
             INITCAP(nvl(ci.segundo_apellido, '')) Nombre,
             c.id_nss,
             ci.no_documento as Cedula,
             c.fecha_creacion Fecha,
             c.id_usuario Usuario,
             nvl(f.firma, 'N/A') firma,
             nvl(f.puesto_resp_firma, 'N/A') puesto_resp_firma,
             nvl(s.descripcion, 'N/A') Estatus_Desc,
             nvl(c.comentario, 'N/A') comentario,
             c.documento
        from cer_certificaciones_t c
        left join cer_status_certificaciones_t s
          on c.id_status_certificacion = s.id_status_certificacion
        left join cer_tipos_certificaciones_t t
          on c.id_tipo_certificacion = t.id_tipo_certificacion
        left join cer_catalogo_firmas_t f
          on c.id_firma = f.id_firma
        left join sre_empleadores_t en
          on c.id_registro_patronal = en.id_registro_patronal
        left join sre_ciudadanos_t ci
          on c.id_nss = ci.id_nss
       Where (p_numCert is null or c.id_certificacion = p_numCert)
         and (p_cedula is null or ci.no_documento = p_cedula)
         and (p_rnc_o_cedula is null or en.rnc_o_cedula = p_rnc_o_cedula);

    p_resultnumber := 0;
    p_iocursor     := c_cursor;

  EXCEPTION

    WHEN e_invalidcertificacion THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(32, NULL, NULL);
      RETURN;

    WHEN e_rnc_cedula THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(150, NULL, NULL);
      RETURN;

    WHEN e_Existe_Ciudadano THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(65, NULL, NULL);
      RETURN;

    WHEN OTHERS THEN
      v_bderror      := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultnumber := Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
      RETURN;
  END;

  -- **************************************************************************************************
  -- Program:    Get_Empleador_Ciudadano
  -- Description:
  -- **************************************************************************************************

  PROCEDURE Get_Empleador_Ciudadano(p_Rnc_Cedula       in sre_empleadores_t.rnc_o_cedula%type,
                                    p_TipoVerificacion in varchar2,
                                    p_iocursor         IN OUT t_cursor)

   IS

    v_cursor  varchar2(500);
    v_bderror VARCHAR(1000);
    c_cursor  t_cursor;

  BEGIN

    if (p_Rnc_Cedula is not null) and p_TipoVerificacion = 'E' then

      Open c_cursor for
        select e.rnc_o_cedula,
               e.razon_social             Razon_Social,
               e.nombre_comercial,
               e.fecha_inicio_actividades Inicio_Actividades
          from sre_empleadores_t e
         where e.rnc_o_cedula = p_Rnc_Cedula;

      p_iocursor := c_cursor;

    end if;

    if (p_Rnc_Cedula is not null) and p_TipoVerificacion = 'C' then

      Open c_cursor for
        SELECT c.no_documento No_Documento,
               c.id_nss Nss,
               c.nombres || ' ' || nvl(c.primer_apellido, '') || ' ' ||
               nvl(c.segundo_apellido, '') Nombre
          FROM sre_ciudadanos_t c
         WHERE c.no_documento = p_Rnc_Cedula;

      p_iocursor := c_cursor;

    end if;

  END;

  -- **************************************************************************************************
  -- Program:     Existe_Empleador_Ciudadano
  -- Description: Verifica el rnc_cedula existe en la tabla empleadores_t o si un ciudadano existe en la tabla ciudadanos_t
  -- **************************************************************************************************

  PROCEDURE Existe_Empleador_Ciudadano(p_Rnc_Cedula       in sre_empleadores_t.rnc_o_cedula%type,
                                       p_TipoVerificacion in varchar2,
                                       p_resultnumber     OUT VARCHAR2)

   IS
    e_Existe_Empleador exception;
    e_Existe_Ciudadano exception;
    v_empleador varchar2(5);
    v_ciudadano varchar2(5);
    v_bderror   VARCHAR(1000);

  BEGIN

    if (p_Rnc_Cedula is not null) and p_TipoVerificacion = 'E' then
      if not sre_empleadores_pkg.isRncOCedulaValida(p_Rnc_Cedula) then
        raise e_Existe_Empleador;
      else
        p_resultnumber := 0;

      end if;
    end if;

    if (p_Rnc_Cedula is not null) and p_TipoVerificacion = 'C' then
      if not cer_certificaciones_pkg.isExisteNodoc(p_Rnc_Cedula) then
        raise e_Existe_Ciudadano;
      else
        p_resultnumber := 0;

      end if;
    end if;

  EXCEPTION

    WHEN e_Existe_Empleador THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(64, NULL, NULL);
      RETURN;

    WHEN e_Existe_Ciudadano THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(65, NULL, NULL);
      RETURN;

    WHEN OTHERS THEN
      v_bderror      := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultnumber := Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
      RETURN;
  END;

  -- **************************************************************************************************
  -- Program:    Get_Facturas_Vencidas
  -- Description:
  -- **************************************************************************************************

  PROCEDURE Get_Facturas_Vencidas(p_Rnc_Cedula in sre_empleadores_t.rnc_o_cedula%type,
                                  p_iocursor   IN OUT t_cursor)

   IS
    e_Existe_Empleador exception;
    e_Existe_Ciudadano exception;
    v_cursor  varchar2(500);
    v_bderror VARCHAR(1000);
    c_cursor  t_cursor;

  BEGIN

    if (p_Rnc_Cedula is not null) then

      Open c_cursor for
        select substr(f.PERIODO_FACTURA, 5, 2) || '-' ||
               substr(f.PERIODO_FACTURA, 1, 4) PERIODO_FACTURA,
               f.ID_REFERENCIA,
               f.FECHA_LIMITE_PAGO,
               f.TOTAL_GENERAL_FACTURA
          from sfc_facturas_v f, sre_empleadores_t e
         where f.ID_REGISTRO_PATRONAL = e.id_registro_patronal
           and e.rnc_o_cedula = p_Rnc_Cedula
           and f.STATUS in ('VE')
           and f.no_autorizacion is null
         order by f.PERIODO_FACTURA;

      p_iocursor := c_cursor;

    end if;

  END;

  -- **************************************************************************************************
  -- Program:     TieneAporte
  -- Description: Verifica si un empleador ha realizado algun aporte para un ciudadano especifico
  -- **************************************************************************************************

  PROCEDURE TieneAporte(p_Rnc_Cedula   in sre_empleadores_t.rnc_o_cedula%type,
                        p_cedula       in sre_ciudadanos_t.no_documento%type,
                        p_resultnumber OUT VARCHAR2)

   IS
    v_TieneAporte varchar(1);

    cursor c_TieneAporte is
      SELECT 1
        FROM SFC_FACTURAS_V     F,
             SRE_EMPLEADORES_T  E,
             sre_ciudadanos_t   c,
             sre_trabajadores_t t
       WHERE F.ID_REGISTRO_PATRONAL = E.ID_REGISTRO_PATRONAL
         and e.id_registro_patronal = t.id_registro_patronal
         and c.id_nss = t.id_nss
         AND F.STATUS = 'PA'
         AND E.RNC_O_CEDULA = p_Rnc_Cedula
         and c.no_documento = p_cedula;

  BEGIN

    if (p_Rnc_Cedula is not null) and (p_cedula is not null) then
      Open c_TieneAporte;
      fetch c_TieneAporte
        into v_TieneAporte;
      Close c_TieneAporte;

      if v_TieneAporte is not null then
        p_resultnumber := 'S';
      else
        p_resultnumber := 'N';
      end if;

    end if;

  END;

  -- **************************************************************************************************
  -- Program:     TieneAporte
  -- Description: Verifica si un empleador ha realizado algun aporte para un ciudadano especifico
  -- **************************************************************************************************

  PROCEDURE TieneAporte(p_Rnc_Cedula   in sre_empleadores_t.rnc_o_cedula%type,
                        p_cedula       in sre_ciudadanos_t.no_documento%type,
                        p_fecha_desde  in sfc_facturas_t.fecha_emision%type,
                        p_fecha_hasta  in sfc_facturas_t.fecha_emision%type,
                        p_resultnumber OUT VARCHAR2)

   IS
    v_TieneAporte varchar(1);

    cursor c_TieneAporte is
     SELECT 1
        FROM SFC_FACTURAS_V     F,
             SRE_EMPLEADORES_T  E,
             sfc_det_facturas_v D,
             sre_ciudadanos_t   c
       WHERE F.ID_REGISTRO_PATRONAL = E.ID_REGISTRO_PATRONAL
        AND f.ID_REFERENCIA = D.ID_REFERENCIA
         and c.id_nss = d.id_nss
         AND F.STATUS = 'PA'
          AND TRUNC(f.FECHA_EMISION) BETWEEN (p_fecha_desde) AND
               (p_fecha_hasta)
         AND E.RNC_O_CEDULA = p_Rnc_Cedula
         and c.no_documento = p_cedula;

  BEGIN

    if (p_Rnc_Cedula is not null) and (p_cedula is not null) then
      Open c_TieneAporte;
      fetch c_TieneAporte
        into v_TieneAporte;
      Close c_TieneAporte;

      if v_TieneAporte is not null then
        p_resultnumber := 'S';
      else
        p_resultnumber := 'N';
      end if;

    end if;

  END;

  -- **************************************************************************************************
  -- Program:     TieneAporte
  -- Description: Verifica si un ciudadano especifico tiene aporte
  -- **************************************************************************************************

  PROCEDURE TieneAporte(p_cedula       in sre_ciudadanos_t.no_documento%type,
                        p_resultnumber OUT VARCHAR2)

   IS
    v_idnss number(10);

  BEGIN

    select c.id_nss
      into v_idnss
      from sre_ciudadanos_t c
     where c.no_documento = p_cedula;

    IF NOT Sre_Trabajador_Pkg.TieneAporte(v_idnss) THEN
      p_resultnumber := 'N';
    else
      p_resultnumber := 'S';
    END IF;

  END;

  -- **************************************************************************************************
  -- Program:     ElegibleIngresoTardio
  -- Description:
  -- **************************************************************************************************

  PROCEDURE ElegibleIngresoTardio(p_cedula       in sre_ciudadanos_t.no_documento%type,
                                  p_resultnumber OUT VARCHAR2)

   IS
    v_idnss number(10);

  BEGIN

    select c.id_nss
      into v_idnss
      from sre_ciudadanos_t c
     where c.no_documento = p_cedula;

    IF NOT Sre_Trabajador_Pkg.isElegibleIngresoTardio(v_idnss) THEN
      p_resultnumber := 'N';
    else
      p_resultnumber := 'S';
    END IF;

  END;

  -- **************************************************************************************************
  -- Program:    ValidaUltimoAporte
  -- Description:
  -- **************************************************************************************************

  PROCEDURE ValidaUltimoAporte(p_Cedula   in sre_ciudadanos_t.no_documento%type,
                               p_iocursor IN OUT t_cursor)

   IS
    v_NssNominas  number(10);
    v_NssFacturas number(10);
    v_bderror     VARCHAR(1000);
    c_cursor      t_cursor;

    cursor c_CursorNominas is
      select t.id_nss
        from sre_nominas_t n, sre_trabajadores_t t, sre_ciudadanos_t c
       where n.id_registro_patronal = t.id_registro_patronal
         and n.id_nomina = t.id_nomina
         and c.id_nss = t.id_nss
         and t.status = 'A'
         and c.no_documento = p_Cedula;

    cursor c_CursorFacturas is
      select distinct (t.id_nss)
        from sfc_facturas_v     f,
             sfc_det_facturas_t df,
             sre_trabajadores_t t,
             sre_ciudadanos_t   c
       where f.id_registro_patronal = t.id_registro_patronal
         and f.id_referencia = df.id_referencia
         and df.id_nss = t.id_nss
         and f.id_nomina = t.id_nomina
         and t.id_nss = c.id_nss
         and f.status in ('VI', 'VE')
         and c.no_documento = p_Cedula;

  BEGIN

    --NOMINAS
    open c_CursorNominas;
    fetch c_CursorNominas
      into v_NssNominas;
    close c_CursorNominas;

    if v_NssNominas is not null then

      Open c_cursor for
        select e.rnc_o_cedula, e.razon_social, n.nomina_des
          from sre_empleadores_t e, sre_nominas_t n, sre_trabajadores_t t
         where e.id_registro_patronal = n.id_registro_patronal
           and n.id_registro_patronal = t.id_registro_patronal
           and n.id_nomina = t.id_nomina
           and t.status = 'A'
           and t.id_nss = v_NssNominas;

      p_iocursor := c_cursor;
      return;
    end if;

    --FACTURAS
    open c_CursorFacturas;
    fetch c_CursorFacturas
      into v_NssFacturas;
    close c_CursorFacturas;

    if v_NssFacturas is not null then

      Open c_cursor for
        select e.rnc_o_cedula, e.razon_social, f.id_referencia
          from sre_empleadores_t  e,
               sfc_facturas_v     f,
               sfc_det_facturas_t df,
               sre_trabajadores_t t
         where F.ID_REFERENCIA = df.id_referencia
           and df.id_nss = t.id_nss
           and f.id_nomina = t.id_nomina
           and e.id_registro_patronal = f.id_registro_patronal
           and f.status in ('VI', 'VE')
           and t.id_nss = v_NssFacturas;

      p_iocursor := c_cursor;
      return;
    end if;

    if (v_NssNominas is null) and (v_NssFacturas is null) then
      Open c_cursor for
        select 'OK' STATUS from dual;
      p_iocursor := c_cursor;
      return;
    end if;

  END;

  -- **************************************************************************************************
  -- Program:  Get_Certificacion_No_Operacion
  -- Description: Trae las facturas que estan en estatus(VE,VI,PA) y las liquidaciones ISR que estan
  -- en estatus (EX,VI,PA) para un empleador en un rango de periodos.
  -- **************************************************************************************************

  PROCEDURE Get_Certificacion_No_Operacion(p_Rnc_Cedula  in sre_empleadores_t.rnc_o_cedula%type,
                                           p_fecha_desde IN CER_CERTIFICACIONES_T.fecha_desde%TYPE,
                                           p_fecha_hasta IN CER_CERTIFICACIONES_T.fecha_hasta%TYPE,
                                           p_iocursor    IN OUT t_cursor)

   IS
    v_idRegistroPatronal number(9);
    v_periodo_desde      number(6);
    v_periodo_hasta      number(6);
    v_bderror            VARCHAR(1000);
    c_cursor             t_cursor;

  BEGIN

    select e.id_registro_patronal
      into v_idRegistroPatronal
      from sre_empleadores_t e
     where e.rnc_o_cedula = p_Rnc_Cedula;

    if (p_Rnc_Cedula is not null) and (p_fecha_desde is not null) and
       (p_fecha_hasta is not null) then
      v_periodo_desde := to_char(p_fecha_desde, 'yyyymm');
      v_periodo_hasta := to_char(p_fecha_hasta, 'yyyymm');

      if (v_periodo_desde >= 200501) and
         (v_periodo_hasta >= v_periodo_desde) then

        Open c_cursor for

          select data2.*
            from (select rownum as Numero, data1.*
                    from (select f.ID_REFERENCIA,
                                 decode(F.STATUS,
                                        'VE',
                                        'VENCIDA',
                                        'VI',
                                        'VIGENTE',
                                        'PA',
                                        'PAGADA') STATUS,
                                 f.PERIODO_FACTURA,
                                 f.TOTAL_GENERAL_FACTURA,
                                 'TSS' TIPO_FACTURA
                            from sfc_facturas_v f
                           where f.STATUS in ('VE', 'VI', 'PA')
                             and f.ID_REGISTRO_PATRONAL =
                                 v_idRegistroPatronal
                             and f.PERIODO_FACTURA between v_periodo_desde and
                                 v_periodo_hasta
                           order by f.PERIODO_FACTURA DESC) data1) data2
           where numero <= 5

          union all

          select data4.*
            from (select rownum as numero2, data3.*
                    from (select l.ID_REFERENCIA_ISR,
                                 decode(l.STATUS,
                                        'EX',
                                        'EXENTA',
                                        'VI',
                                        'VIGENTE',
                                        'PA',
                                        'PAGADA') STATUS,
                                 l.PERIODO_LIQUIDACION,
                                 l.TOTAL_A_PAGAR,
                                 'DGII' TIPO_FACTURA
                            from sfc_liquidacion_isr_v l
                           where L.STATUS in ('EX', 'VI', 'PA')
                             and l.ID_REGISTRO_PATRONAL =
                                 v_idRegistroPatronal
                             and L.PERIODO_LIQUIDACION between
                                 v_periodo_hasta and v_periodo_hasta
                           order by L.PERIODO_LIQUIDACION DESC) data3) data4
           where numero2 <= 5;

        p_iocursor := c_cursor;

      end if;
    end if;

  END;

  -- **************************************************************************************************
  -- Program:    Get_Nominas_Empleador
  -- Description: trae las nominas existentes para un empleador
  -- **************************************************************************************************

  PROCEDURE Get_Nominas_Empleador(p_Rnc_Cedula in sre_empleadores_t.rnc_o_cedula%type,
                                  p_iocursor   IN OUT t_cursor)

   IS

    v_bderror VARCHAR(1000);
    c_cursor  t_cursor;

  BEGIN

    if (p_Rnc_Cedula is not null) then

      Open c_cursor for

        select n.id_nomina,
               n.nomina_des,
               n.fecha_registro,
               count(t.id_nss) Cant_Trabajadores
          from sre_empleadores_t e, sre_nominas_t n, sre_trabajadores_t t
         where e.id_registro_patronal = n.id_registro_patronal
           and n.id_registro_patronal = t.id_registro_patronal
           and n.id_nomina = t.id_nomina
           and e.rnc_o_cedula = p_Rnc_Cedula
           and n.status = 'A'
           and t.status = 'A'
         group by n.id_nomina, n.nomina_des, n.fecha_registro;

      p_iocursor := c_cursor;

    end if;

  END;

  -- ******************************************************************
  -- Program:    Existe_Factura
  -- Description: ********************************
  -- **************************************************************************************************

  PROCEDURE Existe_Factura(p_Rnc_Cedula in sre_empleadores_t.rnc_o_cedula%type,
                           p_iocursor   IN OUT t_cursor)

   IS
    v_existe  varchar(1);
    v_Periodo number(6) := parm.periodo_vigente();
    v_bderror VARCHAR(1000);
    c_cursor  t_cursor;

    cursor c_factura is
      SELECT 1
        FROM SFC_FACTURAS_V F, SRE_EMPLEADORES_T E, sre_nominas_t n
       WHERE F.ID_REGISTRO_PATRONAL = E.ID_REGISTRO_PATRONAL
         AND f.ID_NOMINA = n.id_nomina
         and f.ID_REGISTRO_PATRONAL = n.id_registro_patronal
         AND F.STATUS NOT IN ('CA','RE')
         AND E.RNC_O_CEDULA = p_Rnc_Cedula
         and f.PERIODO_FACTURA = v_Periodo;

  BEGIN
    if (p_Rnc_Cedula is not null) then

      Open c_factura;
      fetch c_factura
        into v_existe;
      close c_factura;

      if v_existe is not null then

        open c_cursor for
          SELECT f.ID_REFERENCIA,
                 n.nomina_des,
                 f.FECHA_LIMITE_PAGO,
                 f.TOTAL_GENERAL_FACTURA
            FROM SFC_FACTURAS_V F, SRE_EMPLEADORES_T E, sre_nominas_t n
           WHERE F.ID_REGISTRO_PATRONAL = E.ID_REGISTRO_PATRONAL
             AND f.ID_NOMINA = n.id_nomina
             and f.ID_REGISTRO_PATRONAL = n.id_registro_patronal
             AND F.STATUS NOT IN ('CA','RE')
             AND E.RNC_O_CEDULA = p_Rnc_Cedula
             and f.PERIODO_FACTURA = v_Periodo;

        p_iocursor := c_cursor;

      else

        Open c_cursor for
          select 'OK' STATUS from dual;
        p_iocursor := c_cursor;
      end if;

    end if;
  End;

  -- **************************************************************************************************
  -- Program:     Tipo_Certificaciones_OnLine
  -- Description:
  -- **************************************************************************************************

  PROCEDURE GetTipoCertificaciones(p_OnLine       in cer_tipos_certificaciones_t.on_line%type,
                                   p_iocursor     IN OUT t_cursor,
                                   p_resultnumber OUT VARCHAR2)

   IS
    v_bderror VARCHAR(1000);
    c_cursor  t_cursor;

  BEGIN

    OPEN c_cursor FOR
      SELECT t.id_tipo_certificacion, t.tipo_certificacion_des
        FROM cer_tipos_certificaciones_t t
       WHERE t.status = 'A'
         and t.on_line = p_OnLine
       order by t.tipo_certificacion_des asc;
    --order by t.id_tipo_certificacion;

    p_iocursor     := c_cursor;
    p_resultnumber := 0;

  EXCEPTION

    WHEN OTHERS THEN
      v_bderror      := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultnumber := Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
      RETURN;
  END;
  
  -- **************************************************************************************************
  -- Program: Tipo_Certificaciones_OnLine
  -- Description: Muestra los tipos de certificaciones activas
  -- Date: 24/05/2017 
  -- By: Kerlin de la Cruz
  -- **************************************************************************************************

  PROCEDURE GetTipoCertificacion(p_iocursor     IN OUT t_cursor,
                                   p_resultnumber OUT VARCHAR2)

   IS
    v_bderror VARCHAR(1000);
    c_cursor  t_cursor;

  BEGIN

    OPEN c_cursor FOR
      SELECT t.id_tipo_certificacion, t.tipo_certificacion_des
        FROM cer_tipos_certificaciones_t t
       WHERE t.status = 'A'         
       order by t.tipo_certificacion_des asc;    

    p_iocursor     := c_cursor;
    p_resultnumber := 0;

  EXCEPTION

    WHEN OTHERS THEN
      v_bderror      := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultnumber := Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
      RETURN;
  END;
  
  -- **************************************************************************************************
  -- Program: GetCertificacionPorRol
  -- Description: Muestra los tipos de certificaciones Que no tiene un rol
  -- Date: 25/05/2017 
  -- By: Kerlin de la Cruz
  -- **************************************************************************************************

  PROCEDURE GetCertificacionPorRol(p_id_rol in seg_roles_t.id_role%type,
                                   p_iocursor IN OUT t_cursor,
                                   p_resultnumber OUT VARCHAR2)

   IS
    v_bderror VARCHAR(1000);
    c_cursor  t_cursor;

  BEGIN

    OPEN c_cursor FOR
      select c.id_tipo_certificacion,c.tipo_certificacion_des
        from cer_tipos_certificaciones_t c
       where c.id_tipo_certificacion not in
             (select t.id_tipo_certificacion
                from cer_roles_certificaciones_t t
               where t.id_role = p_id_rol)
         and c.status = 'A';

    p_iocursor     := c_cursor;
    p_resultnumber := 0;

  EXCEPTION

    WHEN OTHERS THEN
      v_bderror      := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultnumber := Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
      RETURN;
  END;



  -- **************************************************************************************************
  -- Program:     GetTipoCertificacionActiva
  -- Description: Este metodo devuelve un 1 si esta activa y 0 si esta inactiva
  -- **************************************************************************************************

  PROCEDURE GetTipoCertificacionActiva(p_id_tipo_certificacion in cer_tipos_certificaciones_t.id_tipo_certificacion%type,
                                       p_resultnumber          OUT VARCHAR2)

   IS
    v_resultado integer;
    v_bderror VARCHAR(1000);
    c_cursor  t_cursor;

  BEGIN
    begin
      SELECT count(*)
        into v_resultado
        FROM cer_tipos_certificaciones_t t
       WHERE t.status = 'A'
       and t.id_tipo_certificacion=p_id_tipo_certificacion;
     EXCEPTION
       WHEN NO_DATA_FOUND THEN
         v_resultado := 0;
    end;
    p_resultnumber := v_resultado;

  EXCEPTION

    WHEN OTHERS THEN
      v_bderror      := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultnumber := Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
      RETURN;
  END;

  -- ******************************************************************************************************
  -- PROCEDIMIENTO:     getFirmaResponsable
  -- DESCRIPTION:       Trae la firma y el responsable para un tipo de certificacion especifico
  -- ******************************************************************************************************
  PROCEDURE getFirmaResponsable(p_TipoCertificacion in cer_certificaciones_t.id_tipo_certificacion%type,
                                p_IdUsuario         in cer_certificaciones_t.id_usuario%type,
                                p_Firma             out cer_certificaciones_t.firma%type,
                                p_Puesto            out varchar2,
                                p_resultnumber      out varchar2) IS

    v_IdOficina   varchar(10);
    v_firma       varchar2(30);
    v_responsable varchar2(100);
    v_bderror     varchar(1000);

  BEGIN

    --Si la firma no es nula entonces traemos la firma y el responsable de la tabla cer_certificaciones_t

    if p_TipoCertificacion is not null then
      select t.nombre_resp_firma, t.puesto_resp_firma
        into p_Firma, p_Puesto
        from cer_tipos_certificaciones_t t
       where t.id_tipo_certificacion = p_TipoCertificacion;
      p_resultnumber := 0;

    else
      p_resultnumber := 'El parametro tipo certificacion es requerido';
    end if;
    --Si la firma es nula entonces con el parametro p_idUsuario buscamos los roles que sean de tipo "o" y buscamos el IDOficina
    --de lo que este entre parentesis en la columna descripcion en la tabla de roles.
    if p_Firma is null then
      if p_IdUsuario is not null then
        select substr(substr(r.roles_des, instr(r.roles_des, '(') + 1),
                      1,
                      instr(substr(r.roles_des, instr(r.roles_des, '(') + 1),
                            ')') - 1) IdOficina
          into v_IdOficina
          from seg_usuario_permisos_t u, seg_roles_t r
         where u.id_role = r.id_role
           and r.tipo_role = 'O'
           and u.id_usuario = p_IdUsuario;

        --Utilizamos el IdOficina encontrado para trae de la tabla de sel_oficinas_t las columnas "Firma" y "responsable"

        select o.nombre_resp_firma, o.puesto_resp_firma
          into p_Firma, p_Puesto
          from sel_oficinas_t o
         where o.id_oficina = v_IdOficina;
        p_resultnumber := 0;
      else
        p_resultnumber := 'El parametro del usuario es requerido';
      end if;
    end if;

  EXCEPTION

    when no_data_found then
      p_resultnumber := seg_retornar_cadena_error(10, null, null);
      return;

    WHEN OTHERS THEN
      v_bderror      := (substr('error ' || to_char(sqlcode) || ': ' ||
                                sqlerrm,
                                1,
                                255));
      p_resultnumber := seg_retornar_cadena_error(-1, v_bderror, sqlcode);
      return;
  END;
  -- ******************************************************************************************************
  -- PROCEDIMIENTO:     getFirmasOficinas
  -- DESCRIPTION:       Trae el listado de todas las firmas activas.
  -- AUTOR:             Francis Ramirez
  -- Fecha:              2010-08-02--
  -- ******************************************************************************************************
  PROCEDURE getFirmasOficinas(p_iocursor     IN OUT t_cursor,
                              p_resultnumber OUT VARCHAR2) IS
    c_cursor  t_cursor;
    v_bderror varchar(1000);
  BEGIN
    Open c_cursor for
      Select c.id_firma as id, c.oficina || ' - ' || c.firma descripcion
        From cer_catalogo_firmas_t c
       where c.status = 'AC';
    p_iocursor     := C_CURSOR;
    p_resultnumber := 0;
  EXCEPTION
    when others then
      v_bderror      := (substr('error ' || to_char(sqlcode) || ': ' ||
                                sqlerrm,
                                1,
                                255));
      p_resultnumber := seg_retornar_cadena_error(-1, v_bderror, sqlcode);

  END getFirmasOficinas;
  -- ******************************************************************************************************
  -- PROCEDIMIENTO:     getStatusCertificaciones
  -- DESCRIPTION:       Trae el listado de todas los estatus activos.
  -- AUTOR:             Francis Ramirez
  -- Fecha:              2010-09-02--
  -- ******************************************************************************************************
  PROCEDURE getStatusCertificaciones(p_iocursor     IN OUT t_cursor,
                                     p_resultnumber OUT VARCHAR2) is
    c_cursor  t_cursor;
    v_bderror varchar(1000);
  Begin
    Open c_cursor for
      Select c.id_status_certificacion Id_Status,
             c.descripcion             Status_Descripcion
        From cer_status_certificaciones_t c
       Where c.status = 'AC';

    p_iocursor     := c_cursor;
    p_resultnumber := 0;
  EXCEPTION
    when others then
      v_bderror      := (substr('error ' || to_char(sqlcode) || ': ' ||
                                sqlerrm,
                                1,
                                255));
      p_resultnumber := seg_retornar_cadena_error(-1, v_bderror, sqlcode);

  end getStatusCertificaciones;
  -- ******************************************************************************************************
  -- PROCEDIMIENTO:     getImagenCertificacion
  -- DESCRIPTION:       Devuelve la imagen de la Certificacion Especificada.
  -- AUTOR:             Francis Ramirez
  -- FECHA:             2010-10-02
  -- ******************************************************************************************************
  procedure getImagenCertificacion(p_id_certificacion in cer_certificaciones_t.id_certificacion%type,
                                   p_iocursor         IN OUT t_cursor,
                                   p_resultnumber     OUT VARCHAR2) is
    e_InvialidCertificacion exception;
    c_cursor  t_cursor;
    v_bderror VARCHAR(1000);
  Begin
    if not cer_certificaciones_pkg.isexistecertificacion(p_id_certificacion) then
      raise e_InvialidCertificacion;
    end if;

    open c_cursor for
      Select ce.documento
        From cer_certificaciones_t ce
       where ce.id_certificacion = p_id_certificacion;

    p_iocursor     := c_cursor;
    p_resultnumber := 0;

  EXCEPTION
    when e_InvialidCertificacion then
      p_resultnumber := Seg_Retornar_Cadena_Error(300, NULL, NULL);
    when others then
      v_bderror      := (substr('error ' || to_char(sqlcode) || ': ' ||
                                sqlerrm,
                                1,
                                255));
      p_resultnumber := seg_retornar_cadena_error(-1, v_bderror, sqlcode);
  End getImagenCertificacion;

  -- ******************************************************************************************************
  -- PROCEDIMIENTO:     subirImagenCertificacion
  -- DESCRIPTION:       para subir una imagen a una certificacion existente
  -- AUTOR:             Francis Ramirez
  -- Fecha:              2010-09-02--
  -- ******************************************************************************************************
  PROCEDURE subirImagenCertificacion(p_id_certificacion in cer_certificaciones_t.id_certificacion%type,
                                     p_imagen           in cer_certificaciones_t.documento%type,
                                     p_id_firma         in cer_certificaciones_t.id_firma%type,
                                     p_usuario          in cer_certificaciones_t.id_usuario%type,
                                     p_resultnumber     OUT VARCHAR2) Is
    e_InvialidCertificacion exception;
    v_bderror VARCHAR(1000);
  Begin

    if not cer_certificaciones_pkg.isexistecertificacion(p_id_certificacion) then
      raise e_InvialidCertificacion;
    end if;

    if p_imagen is not null and p_id_firma is not null then

      --Actualizar la imagen y cambiarle la firma a la certificacion enviada--
      update SUIRPLUS.cer_certificaciones_t c
         set c.id_firma        = p_id_firma,
             c.documento       = p_imagen,
             c.Ult_Usuario_Act = p_usuario,
             c.Ult_Fecha_act   = sysdate
       where c.id_certificacion = p_id_certificacion;

    elsif p_imagen is not null then
      --Actualizar la imagen a la de la certificacion enviada.
      update SUIRPLUS.cer_certificaciones_t c
         set c.documento       = p_imagen,
             c.Ult_Usuario_Act = p_usuario,
             c.Ult_Fecha_act   = sysdate
       where c.id_certificacion = p_id_certificacion;

    elsif p_id_firma is not null then

      --cambiarle la firma a la certificacion enviada.
      update SUIRPLUS.cer_certificaciones_t c
         set c.id_firma      = p_id_firma,
             c.id_usuario    = p_usuario,
             c.Ult_Fecha_act = sysdate
       where c.id_certificacion = p_id_certificacion;

    end if;
    commit;
    p_resultnumber := 0;

  EXCEPTION
    when e_InvialidCertificacion then
      p_resultnumber := Seg_Retornar_Cadena_Error(300, NULL, NULL);
    when others then
      v_bderror      := (substr('error ' || to_char(sqlcode) || ': ' ||
                                sqlerrm,
                                1,
                                255));
      p_resultnumber := seg_retornar_cadena_error(-1, v_bderror, sqlcode);
  End subirImagenCertificacion;

  -- **************************************************************************************************
  -- Program:     Get_Periodo_UltimaFactura(Nuevo by charlie pena)
  -- Description: Trae el periodo de la ultima factura diferente de cancelada para un rnc
  -- **************************************************************************************************

  PROCEDURE Get_Periodo_UltimaFactura(p_Rnc_Cedula   in sre_empleadores_t.rnc_o_cedula%type,
                                      p_resultnumber OUT VARCHAR2)

   IS
    v_existe_periodo number(6);

    cursor c_existe_periodo is
      SELECT max(f.PERIODO_FACTURA)
        FROM SFC_FACTURAS_V F, SRE_EMPLEADORES_T E
       WHERE F.ID_REGISTRO_PATRONAL = E.ID_REGISTRO_PATRONAL
         AND F.STATUS NOT IN ('CA','RE')
         AND E.RNC_O_CEDULA = p_Rnc_Cedula;

  BEGIN

    if (p_Rnc_Cedula is not null) then
      Open c_existe_periodo;
      fetch c_existe_periodo
        into v_existe_periodo;
      Close c_existe_periodo;

      if v_existe_periodo is not null then
        p_resultnumber := replace(replace(to_char(to_date(v_existe_periodo || '01',
                                                          'yyyymmdd'),
                                                  'Month"_del_"yyyy',
                                                  'NLS_DATE_LANGUAGE = spanish'),
                                          ' ',
                                          ''),
                                  '_',
                                  ' ');
      end if;

    end if;

  END;

  /*Seccion de funciones*/

  /*
  -- **************************************************************************************************
  -- PROCEDIMIENTO:     Function isExisteCertificacion
  -- DESCRIPCION:       Funcion que retorna la existencia de un id_certificacion.
                        Recibe : el parametro p_id_certificacion.
                        Devuelve: un valor booleano (0,1) . 0 = no existe  1 = existe
  -- **************************************************************************************************
  */
  FUNCTION isExisteCertificacion(p_id_certificacion VARCHAR2) RETURN BOOLEAN

   IS

    CURSOR c_ExisteCertificacion IS
      SELECT c.id_certificacion
        FROM CER_CERTIFICACIONES_T c
       WHERE c.id_certificacion = p_id_certificacion;
    --variable
    returnvalue       BOOLEAN;
    v_idcertificacion VARCHAR(22);
    --
  BEGIN
    OPEN c_ExisteCertificacion;
    FETCH c_ExisteCertificacion
      INTO v_idcertificacion;
    returnvalue := c_ExisteCertificacion%FOUND;
    CLOSE c_ExisteCertificacion;

    RETURN(returnvalue);

  END isExisteCertificacion;
  /*
  -- **************************************************************************************************
  -- FUNCION:     Function isExisteNodoc
  -- DESCRIPCION: Funcion que retorna la existencia de un No_documento cuando su tipo de doc. es cedula.
                  Recibe : el parametro p_no_doc.
                  Devuelve: un valor booleano (0,1) . 0 = no existe  1 = existe.
  -- **************************************************************************************************
  */
  FUNCTION isExisteNodoc(p_no_doc VARCHAR2) RETURN BOOLEAN

   IS

    CURSOR c_ExisteNodoc IS
      SELECT c.no_documento
        FROM SRE_CIUDADANOS_T c
       WHERE c.no_documento = p_no_doc
         AND c.tipo_documento = 'C';

    returnvalue BOOLEAN;
    v_nodoc     VARCHAR(22);

  BEGIN
    OPEN c_ExisteNodoc;
    FETCH c_ExisteNodoc
      INTO v_nodoc;
    returnvalue := c_ExisteNodoc%FOUND;
    CLOSE c_ExisteNodoc;

    RETURN(returnvalue);

  END isExisteNodoc;

  -- **************************************************************************************************
  -- PROCEDIMIENTO:     Function isExisteCertificacion
  -- DESCRIPCION:       Funcion que retorna la existencia de un id_certificacion.
  --                      Recibe : el parametro p_id_certificacion.
  --                      Devuelve: un valor booleano (0,1) . 0 = no existe  1 = existe
  -- **************************************************************************************************

  FUNCTION isExisteNoCertificacion(p_no_certificacion VARCHAR2)
    RETURN BOOLEAN

   IS

    CURSOR c_ExisteCertificacion IS
      SELECT c.id_certificacion
        FROM CER_CERTIFICACIONES_T c
       WHERE c.no_certificacion = p_no_certificacion;
    --variable
    returnvalue       BOOLEAN;
    v_idcertificacion VARCHAR(22);
    --
  BEGIN
    OPEN c_ExisteCertificacion;
    FETCH c_ExisteCertificacion
      INTO v_idcertificacion;
    returnvalue := c_ExisteCertificacion%FOUND;
    CLOSE c_ExisteCertificacion;

    RETURN(returnvalue);

  END isExisteNoCertificacion;

  --------------------------------------------------------------------------------------------
  -- FUNCTION isRncOCedulaActivo
  -- BY KERLIN DE LA CRUZ
  -- 04/02/2013
  --------------------------------------------------------------------------------------------

  FUNCTION isRncOCedulaActivo(p_rnc_o_cedula SRE_EMPLEADORES_T.rnc_o_cedula%TYPE)
    RETURN BOOLEAN IS

    CURSOR c_existe_rnccedula IS

      SELECT t.rnc_o_cedula
        FROM SRE_EMPLEADORES_T t
       WHERE t.rnc_o_cedula = p_rnc_o_cedula
         AND T.Status = 'A';
    returnValue  BOOLEAN;
    p_RncOCedula VARCHAR(22);

  BEGIN
    OPEN c_existe_rnccedula;
    FETCH c_existe_rnccedula
      INTO p_RncOCedula;
    returnValue := c_existe_rnccedula%FOUND;
    CLOSE c_existe_rnccedula;

    RETURN(returnValue);

  END isRncOCedulaActivo;

  -- * -----------------------------------------------------------------------------------------
  -- Verificamo si el ciudadanos existe y existe en trabajadores
  -- 05/02/2013
  --* -----------------------------------------------------------------------------------------
 /* FUNCTION isExisteCiu(p_no_doc VARCHAR2) RETURN BOOLEAN

   IS

    CURSOR c_ExisteNodoc IS
      SELECT distinct c.no_documento
        FROM SRE_CIUDADANOS_T c
       WHERE c.no_documento = p_no_doc
         AND c.tipo_documento = 'C';

    returnvalue BOOLEAN;
    v_nodoc     VARCHAR(22);

  BEGIN
    OPEN c_ExisteNodoc;
    FETCH c_ExisteNodoc
      INTO v_nodoc;
    returnvalue := c_ExisteNodoc%FOUND;
    CLOSE c_ExisteNodoc;

    RETURN(returnvalue);

  END isExisteCiudTra;
*/
  -- **************************************************************************************************
  -- PROCEDIMIENTO: getCertificacion(Nuevo by Mayreni Vargas)
  -- DESCRIPCION: Consulta que presenta el contenido de una certificacion,tomando en consideracion el parametro de entrada (p_no_certificacion).
  -- **************************************************************************************************
  PROCEDURE getCertificacion(p_no_certificacion IN CER_CERTIFICACIONES_T.No_Certificacion%TYPE,
                             p_iocursor         OUT t_cursor,
                             p_resultnumber     OUT VARCHAR2)

   IS
    e_invalidcertificacion EXCEPTION;
    v_nss               number(10);
    v_id_certificacion  number(9);
    v_FechaPago         varchar2(15);
    v_TipoCertificacion varchar2(2);
    v_bderror           VARCHAR(1000);

    c_cursor t_cursor;

  BEGIN
    IF NOT
        Cer_Certificaciones_Pkg.isExisteNoCertificacion(p_no_certificacion) THEN
      RAISE e_invalidcertificacion;
    END IF;

    select c.id_nss, c.id_tipo_certificacion, c.id_certificacion
      into v_nss, v_TipoCertificacion, v_id_certificacion
      from cer_certificaciones_t c
     where c.no_certificacion = p_no_certificacion;

    if (v_TipoCertificacion = 'B') then
      SELECT MAX(f2.FECHA_PAGO)
        into v_FechaPago
        FROM SFC_DET_FACTURAS_T d, SFC_FACTURAS_V f2
       WHERE d.ID_REFERENCIA = f2.ID_REFERENCIA
         AND f2.STATUS = 'PA'
         AND d.ID_NSS = v_nss;

      Open c_cursor for
        SELECT f.id_referencia,
               c.id_certificacion,
               c.id_usuario,
               c.id_tipo_certificacion Id_Tipo,
               c.id_status_certificacion Id_Status,
               t.tipo_certificacion_des Descripcion,
               NVL(e.rnc_o_cedula, '') rnc,
               ci.id_nss nss,
               replace(to_char(c.fecha_desde,
                               'dd/Month/yyyy',
                               'NLS_DATE_LANGUAGE = spanish'),
                       ' ',
                       '') fecha_desde,
               replace(to_char(c.fecha_hasta,
                               'dd/Month/yyyy',
                               'NLS_DATE_LANGUAGE = spanish'),
                       ' ',
                       '') fecha_hasta,
               c.firma,
               c.fecha_creacion,
               NVL(e.razon_social, '') razonsocial,
               e.nombre_comercial,
               NVL(ci.no_documento, '') cedula,
               InitCap((ci.nombres || ' ' || NVL(ci.primer_apellido, '') || ' ' ||
                       NVL(ci.segundo_apellido, ''))) nombre,
               t.encabezado_1,
               t.encabezado_2,
               t.pie_de_pagina,
               e.fecha_inicio_actividades,
               f.periodo_factura,
               (df.aporte_afiliados_svds + df.aporte_afiliados_sfs +
               df.aporte_voluntario) retenciones,
               df.salario_ss,
               TRUNC(f.FECHA_PAGO) fecha_pago,
               fi.firma as nombre_resp_firma,
               fi.puesto_resp_firma as puesto_resp_firma,
               s.id_status_certificacion as id_status,
               s.descripcion as desc_status,
               c.comentario,
               c.no_certificacion,
               c.pin,
               fi.firma_imagen "firma_imagen",
                c.pdf
          from cer_certificaciones_t c
          join cer_tipos_certificaciones_t t
            on c.id_tipo_certificacion = t.id_tipo_certificacion
          left join sre_empleadores_t e
            on c.id_registro_patronal = e.id_registro_patronal
          left join sfc_det_facturas_v df
            on c.id_nss = df.id_nss
          left join sfc_facturas_v f
            on f.id_referencia = df.id_referencia
          left join sre_ciudadanos_t ci
            on c.id_nss = ci.id_nss
          join cer_status_certificaciones_t s
            on c.id_status_certificacion = s.id_status_certificacion
          join cer_catalogo_firmas_t fi
            on c.id_firma = fi.id_firma
         where c.id_certificacion = v_id_certificacion
           and ci.id_nss = v_nss
           and f.fecha_pago = v_FechaPago
         order by f.fecha_pago desc;

      p_resultnumber := 0;
      p_iocursor     := c_cursor;
      return;

    end if;

    if v_TipoCertificacion = '7' then
      OPEN c_cursor FOR
        select f.id_referencia,
               c.id_certificacion,
               c.id_usuario,
               c.id_tipo_certificacion Id_Tipo,
               c.id_status_certificacion Id_Status,
               t.tipo_certificacion_des Descripcion,
               NVL(e.rnc_o_cedula, '') rnc,
               ci.id_nss nss,
               replace(to_char(c.fecha_desde,
                               'dd/Month/yyyy',
                               'NLS_DATE_LANGUAGE = spanish'),
                       ' ',
                       '') fecha_desde,
               replace(to_char(c.fecha_hasta,
                               'dd/Month/yyyy',
                               'NLS_DATE_LANGUAGE = spanish'),
                       ' ',
                       '') fecha_hasta,
               c.firma,
               c.fecha_creacion,
               NVL(e.razon_social, '') razonsocial,
               e.nombre_comercial,
               NVL(ci.no_documento, '') cedula,
               (ci.nombres || ' ' || NVL(ci.primer_apellido, '') || ' ' ||
               NVL(ci.segundo_apellido, '')) nombre,
               replace(replace(to_char(c.fecha_desde,
                                       'Month"_del_"yyyy',
                                       'NLS_DATE_LANGUAGE = spanish'),
                               ' ',
                               ''),
                       '_',
                       ' ') Periodo_Desde,
               replace(replace(to_char(c.fecha_hasta,
                                       'Month"_del_"yyyy',
                                       'NLS_DATE_LANGUAGE = spanish'),
                               ' ',
                               ''),
                       '_',
                       ' ') Periodo_Hasta,
               t.encabezado_1,
               t.encabezado_2,
               t.pie_de_pagina,
               e.fecha_inicio_actividades,
               f.periodo_factura,
               (df.aporte_afiliados_svds + df.aporte_afiliados_sfs +
               df.aporte_voluntario) retenciones,
               df.salario_ss,
               TRUNC(f.FECHA_PAGO) fecha_pago,
               fi.firma as nombre_resp_firma,
               fi.puesto_resp_firma as puesto_resp_firma,
               s.id_status_certificacion as id_status,
               s.descripcion as desc_status,
               c.comentario,
               c.documento,
               c.no_certificacion,
               c.pin,
               fi.firma_imagen "firma_imagen",
                c.pdf
          from cer_certificaciones_t c
          join cer_tipos_certificaciones_t t
            on c.id_tipo_certificacion = t.id_tipo_certificacion
          join sre_empleadores_t e
            on c.id_registro_patronal = e.id_registro_patronal
          left join sfc_det_facturas_v df
            on c.id_nss = df.id_nss
          left join sfc_facturas_v f
            on f.id_referencia = df.id_referencia
          left join sre_ciudadanos_t ci
            on ci.no_documento = e.rnc_o_cedula
          left join cer_status_certificaciones_t s
            on c.ID_STATUS_CERTIFICACION = s.id_status_certificacion
          left join cer_catalogo_firmas_t fi
            on c.id_firma = fi.id_firma
         where c.id_certificacion = v_id_certificacion
         order by f.fecha_pago desc;

      p_resultnumber := 0;
      p_iocursor     := c_cursor;
      return;
    end if;

    OPEN c_cursor FOR
      select c.id_certificacion,
             c.id_usuario,
             c.id_tipo_certificacion Id_Tipo,
             c.id_status_certificacion Id_Status,
             t.tipo_certificacion_des Descripcion,
             NVL(e.rnc_o_cedula, '') rnc,
             ci.id_nss nss,
             replace(to_char(c.fecha_desde,
                             'dd/Month/yyyy',
                             'NLS_DATE_LANGUAGE = spanish'),
                     ' ',
                     '') fecha_desde,
             replace(to_char(c.fecha_hasta,
                             'dd/Month/yyyy',
                             'NLS_DATE_LANGUAGE = spanish'),
                     ' ',
                     '') fecha_hasta,
             c.firma,
             c.fecha_creacion,
             NVL(e.razon_social, '') razonsocial,
             e.nombre_comercial,
             NVL(ci.no_documento, '') cedula,
             (ci.nombres || ' ' || NVL(ci.primer_apellido, '') || ' ' ||
             NVL(ci.segundo_apellido, '')) nombre,
             replace(replace(to_char(c.fecha_desde,
                                     'Month"_del_"yyyy',
                                     'NLS_DATE_LANGUAGE = spanish'),
                             ' ',
                             ''),
                     '_',
                     ' ') Periodo_Desde,
             replace(replace(to_char(c.fecha_hasta,
                                     'Month"_del_"yyyy',
                                     'NLS_DATE_LANGUAGE = spanish'),
                             ' ',
                             ''),
                     '_',
                     ' ') Periodo_Hasta,
             t.encabezado_1,
             t.encabezado_2,
             t.pie_de_pagina,
             e.fecha_inicio_actividades,
             fi.firma as nombre_resp_firma,
             fi.puesto_resp_firma as puesto_resp_firma,
             s.id_status_certificacion as id_status,
             s.descripcion as desc_status,
             c.comentario,
             c.documento,
             c.no_certificacion,
             c.pin,
             fi.firma_imagen "firma_imagen",
             c.pdf
        from cer_certificaciones_t c
        join cer_tipos_certificaciones_t t
          on c.id_tipo_certificacion = t.id_tipo_certificacion
        left join sre_empleadores_t e
          on c.id_registro_patronal = e.id_registro_patronal
        left join sre_ciudadanos_t ci
          on c.id_nss = ci.id_nss
        left join cer_status_certificaciones_t s
          on c.id_status_certificacion = s.id_status_certificacion
        left join cer_catalogo_firmas_t fi
          on c.id_firma = fi.id_firma
       where c.id_certificacion = v_id_certificacion;

    p_resultnumber := 0;
    p_iocursor     := c_cursor;

  EXCEPTION

    WHEN e_invalidcertificacion THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(32, NULL, NULL);
      RETURN;

    WHEN OTHERS THEN
      v_bderror      := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultnumber := Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
      RETURN;
  END;

  --************************************************************************************************************--
  --CHA
  --24/01/2013
  --Hace la confirmarcion de las certificaciones
  --************************************************************************************************************--
  PROCEDURE ProcesarSolicitud(p_id_usuario    IN CER_CERTIFICACIONES_T.id_usuario%TYPE,
                              p_id_tipo       IN OUT CER_CERTIFICACIONES_T.ID_TIPO_CERTIFICACION%TYPE,
                              p_rnc_cedula    IN SRE_EMPLEADORES_T.rnc_o_cedula%TYPE,
                              p_nro_documento IN SRE_CIUDADANOS_T.NO_DOCUMENTO%TYPE,
                              p_fecha_desde  varchar2,
                              p_fecha_hasta  varchar2,
                              p_resultnumber  OUT VARCHAR2)

   IS
    v_idcertificacion VARCHAR2(50);
    v_nocertificacion VARCHAR2(50);
    v_bderror         VARCHAR2(200);
    v_idnss           number(10);
    v_RegPatronal     VARCHAR2(50);
    v_count           number(10);
    V_existe          boolean;
    e_Existe_Empleador exception;
    E_CREANDO_CER exception;
    e_ciu_no_existe exception;

    CURSOR c_regpatronal IS
      SELECT e.id_registro_patronal
        FROM SRE_EMPLEADORES_T e
       WHERE e.rnc_o_cedula = p_rnc_cedula;

    cursor c_Idnss is
      select id_nss
        from sre_ciudadanos_t
       where no_documento = p_nro_documento
         and tipo_documento = 'C';

  BEGIN

    OPEN c_regpatronal;
    FETCH c_regpatronal
      INTO v_RegPatronal;
    CLOSE c_regpatronal;

    -- Verificamos el p_nro_documento
    If p_nro_documento is not null Then

        OPEN c_Idnss;
        FETCH c_Idnss
          INTO v_idnss;
        CLOSE c_Idnss;

       If  v_idnss is null Then
          raise e_ciu_no_existe;
       End If;

    End If;
    --Creamos la confirmacion de la certificacion
    CrearCertificacionesCer(p_id_usuario,
                            p_id_tipo,
                            p_rnc_cedula,
                            v_idnss,
                            1,
                            p_fecha_desde,
                            p_fecha_hasta,
                            p_resultnumber);

    IF substr(p_resultnumber, length(p_resultnumber), 1) = '0' THEN
       SELECT max(id_certificacion)
       INTO v_idcertificacion
       FROM CER_CERTIFICACIONES_T C
       WHERE ((C.ID_NSS = v_idnss) or
             (C.ID_REGISTRO_PATRONAL = v_RegPatronal));

       SELECT no_certificacion
       INTO v_nocertificacion
       FROM CER_CERTIFICACIONES_T C
       WHERE id_certificacion = v_idcertificacion;
    ELSE
      RAISE E_CREANDO_CER;
    END IF;

    p_resultnumber := '0' || '|' || v_nocertificacion || '|' || v_idcertificacion;

  EXCEPTION

    WHEN e_Existe_Empleador THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(34, NULL, NULL);
      RETURN;

    WHEN e_ciu_no_existe THEN
      p_resultnumber := Seg_Retornar_Cadena_Error('65', NULL, NULL);
      RETURN;

    WHEN E_CREANDO_CER THEN
      RETURN;

    WHEN OTHERS THEN
      v_bderror      := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultnumber := Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
      RETURN;
  END;
  --****************************************************************************************************--
  --CHA
  --24/01/2013
  --Busca todas las certificaciones filtrada por tipo, fecha_desde , fecha_hasta
  --****************************************************************************************************--
PROCEDURE getSolitudCert(p_id_tipo          IN CER_CERTIFICACIONES_T.ID_TIPO_CERTIFICACION%TYPE,
                           p_rnc_cedula       IN SRE_EMPLEADORES_T.rnc_o_cedula%TYPE,
                           p_id_usuario       IN CER_CERTIFICACIONES_T.id_usuario%TYPE,
                           p_nro_documento    IN sre_ciudadanos_t.no_documento%type,
                           p_id_certificacion in cer_certificaciones_t.id_certificacion%type,
                           p_no_certificacion in cer_certificaciones_t.no_certificacion%type,
                           p_fecha_desde      IN varchar2,
                           p_fecha_hasta      IN varchar2,
                           p_pagenum          in number,
                           p_pagesize         in number,
                           p_io_cursor        out t_cursor,
                           p_resultnumber     OUT varchar2) IS

    vRegPat     number(9);
    vDesde        integer := (p_pagesize * (p_pagenum - 1)) + 1;
    vhasta        integer := p_pagesize * p_pagenum;
    v_bderror     varchar2(1000);
    v_usuarios    varchar2(32000);
    v_select      varchar2(32000);

  BEGIN
    if (p_id_usuario is not null) then
/*
      select id_registro_patronal
      into vRegpat
      from suirplus.seg_usuario_t
      where id_usuario = p_id_usuario;

      For r in (SELECT distinct up2.id_usuario, U.id_registro_patronal
                FROM SUIRPLUS.SEG_USUARIO_PERMISOS_T UP1
                JOIN suirplus.SEG_USUARIO_PERMISOS_T up2 on up2.id_role=up1.id_role
                JOIN SUIRPLUS.SEG_USUARIO_T U ON U.ID_USUARIO=UP2.ID_USUARIO
                 and nvl(u.id_registro_patronal,0) = nvl(vRegpat,0)
                WHERE UP1.ID_USUARIO=p_id_usuario
      ) Loop
        v_usuarios := v_usuarios || ''''||R.id_usuario||''',';
      End Loop;
*/
      For r in (SELECT distinct u2.id_usuario
                FROM SUIRPLUS.SEG_USUARIO_T U
                JOIN SUIRPLUS.SEG_USUARIO_T u2
                  on NVL(u2.id_entidad_recaudadora, 0) = NVL(u.id_entidad_recaudadora, 0)
                 and NVL(u2.id_registro_patronal, 0) = NVL(u.id_registro_patronal, 0)
                WHERE U.ID_USUARIO=p_id_usuario
      ) Loop
        v_usuarios := v_usuarios || ''''||r.id_usuario||''',';
      End Loop;


      --Para quitarle la ultima coma
      v_usuarios := substr(v_usuarios, 1, length(v_usuarios)-1);

      -- SACAR LA DATA
      v_select :=
      'with x as
         (select rownum num, y.*
            from (
                    Select c.id_certificacion,
                          c.id_tipo_certificacion,
                          nvl(e.rnc_o_cedula, d.no_documento) rnc_o_cedula,
                          c.no_certificacion,
                          Case
                            When (c.id_nss is not null) and (c.id_registro_patronal is not null) then
                              e.razon_social || '' - '' || d.nombres || '' ''  || d.primer_apellido || '' ''  || d.segundo_apellido
                            When (c.id_nss is null) and (c.id_registro_patronal is not null) then
                              e.razon_social
                            When (c.id_nss is not null) and (c.id_registro_patronal is null) then
                              d.nombres || '' '' || d.primer_apellido || '' '' || d.segundo_apellido
                          End razon_social,
                         Case
                          When (u.id_tipo_usuario = 2) then
                               d1.nombres || '' '' || d1.primer_apellido || '' '' || d1.segundo_apellido
                          When (u.id_tipo_usuario = 1) then
                               upper(u.nombre_usuario || '' ''  || u.apellidos)
                           End Usuario_solicita,
                          t.tipo_certificacion_des, s.descripcion estatus,h.comentario,c.fecha_creacion
                   From  SUIRPLUS.cer_certificaciones_t        c
                        ,SUIRPLUS.cer_tipos_certificaciones_t  t
                        ,SUIRPLUS.cer_status_certificaciones_t s
                        ,SUIRPLUS.sre_empleadores_t            e
                        ,SUIRPLUS.cer_his_certificaciones_t    h
                        ,SUIRPLUS.sre_ciudadanos_t             d
                        ,SUIRPLUS.sre_ciudadanos_t             d1
                        ,SUIRPLUS.seg_usuario_t               u

                   Where c.id_usuario in (' ||v_usuarios|| ')';

      If Trim(p_id_certificacion) is not null Then
        v_select := v_select ||'  and c.id_certificacion = ' || p_id_certificacion;
      End if;

      If Trim(p_no_certificacion) is not null Then
        v_select := v_select ||'  and c.no_certificacion = '''|| p_no_certificacion ||'''';
      End if;

      If Trim(p_id_tipo) is not null Then
        v_select := v_select ||'  and c.id_tipo_certificacion = ''' || p_id_tipo ||'''';
      End if;

      If (Trim(p_fecha_desde) is not null) or (Trim(p_fecha_hasta) is not null) Then
        v_select := v_select ||'  and trunc(c.fecha_creacion) between to_date('''||nvl(p_fecha_desde,'01/01/03')||''', ''dd/mm/yy'')
                                  and to_date('''||nvl(p_fecha_hasta,to_char(sysdate,'dd/mm/yy'))||''', ''dd/mm/yy'')';
      End if;

      v_select := v_select ||
      '  and t.id_tipo_certificacion = c.id_tipo_certificacion
         and s.id_status_certificacion = c.id_status_certificacion
         and h.id_certificacion(+) = c.id_certificacion
         and h.status(+) = c.ID_STATUS_CERTIFICACION
         and h.status(+) = 2
         and e.id_registro_patronal(+) = c.id_registro_patronal
         and d.id_nss(+) = c.id_nss
         and d1.id_nss(+) = u.id_nss
         and u.id_usuario(+) = c.id_usuario
      order by fecha_creacion desc) y)
    Select y.recordcount, x.*
    From x, (select max(num) recordcount from x) y
    Where num between '|| vDesde ||' and '|| vHasta;

    OPEN p_io_cursor FOR v_select;

      p_resultnumber := 0;
    ELSE
      p_resultnumber := 1;
    end if;
  EXCEPTION

    WHEN OTHERS THEN
      v_bderror      := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultnumber := Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
      RETURN;
  END;
  ----------------------------------------------------------------------------------------------------------------------
  -- PROCEDURE GET_INFO_GENERAL
  -- BY KERLIN DE LA CRUZ
  -- 24/01/2013
  ----------------------------------------------------------------------------------------------------------------------

  procedure get_info_general(p_rnc_o_cedula in sre_empleadores_t.rnc_o_cedula%type,
                             p_id_usuario   in seg_usuario_t.id_usuario%type,
                             p_iocursor     in out t_cursor,
                             p_resultnumber out varchar2)

   is
    v_bderror varchar(1000);
    c_cursor  t_cursor;

  begin
    open c_cursor for
       select distinct
             tc.id_tipo_certificacion,
             tc.tipo_certificacion_des,
             tc.descripcion
       from cer_tipos_certificaciones_t tc
       join seg_usuario_permisos_t u
         on u.id_usuario = p_id_usuario
        and u.id_role is not null
       join cer_roles_certificaciones_t r
         on r.id_role = u.id_role
        and r.id_tipo_certificacion = tc.id_tipo_certificacion
       where tc.status = 'A'
       order by tc.tipo_certificacion_des;

    p_iocursor     := c_cursor;
    p_resultnumber := 0;

  exception

    when others then
      v_bderror      := (substr('error ' || to_char(sqlcode) || ': ' ||
                                sqlerrm,
                                1,
                                255));
      p_resultnumber := seg_retornar_cadena_error(-1, v_bderror, sqlcode);
      return;
  end;

  ----------------------------------------------------------------------------------------------------------------------
  -- PROCEDURE GET_INFO_CERT
  -- BY KERLIN DE LA CRUZ
  -- 25/01/2013
  ----------------------------------------------------------------------------------------------------------------------

  procedure get_info_cert(p_rnc_o_cedula in sre_empleadores_t.rnc_o_cedula%type,
                          p_id_usuario   in seg_usuario_t.id_usuario%type,
                          p_iocursor     in out t_cursor,
                          p_resultnumber out varchar2)

   is
    v_bderror           varchar(1000);
    v_registro_patronal sre_empleadores_t.id_registro_patronal%type;
    c_cursor            t_cursor;

  begin

    open c_cursor for
       select distinct
              tc.id_tipo_certificacion  tipo_certificacion,
              tc.tipo_certificacion_des descripcion_certificacion
       from cer_tipos_certificaciones_t tc
       join seg_usuario_permisos_t u
         on u.id_usuario = p_id_usuario
        and u.id_role is not null
       join cer_roles_certificaciones_t r
         on r.id_role = u.id_role
        and r.id_tipo_certificacion = tc.id_tipo_certificacion
       where tc.status = 'A'
       order by tc.tipo_certificacion_des;

    p_iocursor     := c_cursor;
    p_resultnumber := 0;

  exception

    when others then
      v_bderror      := (substr('error ' || to_char(sqlcode) || ': ' ||
                                sqlerrm,
                                1,
                                255));
      p_resultnumber := seg_retornar_cadena_error(-1, v_bderror, sqlcode);
      return;
  end;

  ----------------------------------------------------------------------------------------------------------------------
  -- PROCEDURE GET_ID_CERTIFICACION
  -- BY KERLIN DE LA CRUZ
  -- 30/01/2013
  ----------------------------------------------------------------------------------------------------------------------

  procedure get_id_certificacion(p_certificacion in varchar2,
                                 p_pin           in cer_certificaciones_t.pin%type,
                                 p_iocursor      in out t_cursor,
                                 p_resultnumber  out varchar2)

   is
    v_bderror varchar(1000);
    c_cursor  t_cursor;

  begin

    open c_cursor for

      select c.id_certificacion
        from cer_certificaciones_t c
       where to_char(c.id_certificacion || '-' || c.no_certificacion ||
                     to_char(c.fecha_creacion, 'yyyy')) =
             to_char(p_certificacion)
         and c.pin = p_pin;

    p_iocursor     := c_cursor;
    p_resultnumber := 0;

  exception

    when others then
      v_bderror      := (substr('error ' || to_char(sqlcode) || ': ' ||
                                sqlerrm,
                                1,
                                255));
      p_resultnumber := seg_retornar_cadena_error(-1, v_bderror, sqlcode);
      return;
  end;


  -- ------------------------------------------------------------------------------ --
  -- Kerlin De La ruz
  -- 18/02/2013
  -- Verifica si el trabajador en cuestion trabaja o trabajo para el registro patronal en cuestion
  -- ------------------------------------------------------------------------------ --
procedure getTrabajador(p_id_registro_patronal in sre_trabajadores_t.id_registro_patronal%type,
                          p_Nro_Documento        in sre_ciudadanos_t.no_documento%type,
                          p_resultnumber         out varchar2)is



e_apor_tra_empl exception;
v_count number;
v_bderror  varchar2(1000);


 Begin


 select count(*)
   into v_count
   from sre_trabajadores_t t
   join sre_ciudadanos_t c on c.id_nss = t.id_nss
                          and c.tipo_documento = 'C'
  where c.no_documento = p_Nro_Documento;
  --where t.id_registro_patronal = p_id_registro_patronal;

  If v_count = 0 Then
    raise e_apor_tra_empl;
  End If;
  p_resultnumber :=0;

 exception

   when e_apor_tra_empl then
      p_resultnumber := seg_retornar_cadena_error('C06', null, null);
      return;

    when others then
      v_bderror      := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultnumber := Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
      return;

end;

  ----------------------------------------------------------------------------------------------------------------------
  -- PROCEDURE GET_TOTAL_CERT
  -- BY KERLIN DE LA CRUZ
  -- 23/07/2013
  ----------------------------------------------------------------------------------------------------------------------

  procedure get_total_cert(p_fecha_desde            in cer_sol_certificaciones_t.fecha_solicitud%type,
                           p_fecha_hasta            in cer_sol_certificaciones_t.fecha_solicitud%type,
                           p_id_usuario             in seg_usuario_t.id_usuario%type,
                           p_rnc_cedula             in sre_empleadores_t.rnc_o_cedula%type,
                           p_pagenum                in number,
                           p_pagesize               in number,
                           p_io_cursor              out t_cursor,
                           p_resultnumber           out varchar2)

is


vDesde        integer := (p_pagesize * (p_pagenum - 1)) + 1;
vhasta        integer := p_pagesize * p_pagenum;
v_bderror     varchar(1000);
c_cursor      t_cursor;
v_usuarios    varchar2(32000);
v_registro_patronal    sre_empleadores_t.id_registro_patronal%type;
v_id_tipo_usuario varchar2(1);


begin


OPEN c_cursor FOR

with pages as
       (Select rownum num, y.*
          from ( Select  ce.id_usuario,
                         initcap(u.nombre_usuario || ' ' || u.apellidos) solicita,
                         count(*) Total_Certificaciones,
                         sum( case when ce.id_status_certificacion in (1,3) then 1 else 0 end) pendiente,
                         sum( case when ce.id_status_certificacion in (2,5) then 1 else 0 end) rechazada,
                         sum( case when ce.id_status_certificacion = 4 then 1 else 0 end) aprobada

                 From SUIRPLUS.seg_usuario_t    u
                 join SUIRPLUS.cer_certificaciones_t ce on ce.id_usuario = u.id_usuario
                                                       and trunc(ce.fecha_creacion) between trunc(p_fecha_desde) and trunc(p_fecha_hasta)
                 Where u.id_usuario in ( SELECT distinct  u2.id_usuario
                                                     FROM SUIRPLUS.SEG_USUARIO_T U
                                                     JOIN SUIRPLUS.SEG_USUARIO_T u2 on NVL(u2.id_entidad_recaudadora, 0) = NVL(u.id_entidad_recaudadora, 0)
                                                                                    AND NVL(u2.id_registro_patronal, 0) = NVL(u.id_registro_patronal, 0)
                                                    WHERE U.ID_USUARIO=p_id_usuario)
                                                      and u.id_tipo_usuario = '1'

                 group by ce.id_usuario, initcap(u.nombre_usuario || ' ' || u.apellidos)



     Union all

               Select ce.id_usuario,
                       initcap(ci.nombres || ' ' || ci.primer_apellido || ' ' || ci.segundo_apellido) solicita,
                       count(*) Total_Certificaciones,
                       sum( case when ce.id_status_certificacion in (1,3) then 1 else 0 end) pendiente,
                       sum( case when ce.id_status_certificacion in (2,5) then 1 else 0 end) rechazada,
                       sum( case when ce.id_status_certificacion = 4 then 1 else 0 end) aprobada

               From SUIRPLUS.seg_usuario_t    u
               join SUIRPLUS.cer_certificaciones_t ce on ce.id_usuario = u.id_usuario
                                                      and trunc(ce.fecha_creacion) between trunc(p_fecha_desde) and trunc(p_fecha_hasta)
               join SUIRPLUS.sre_ciudadanos_t ci on ci.id_nss = u.id_nss
               Where ce.id_usuario in ( SELECT distinct  u2.id_usuario
                                                    FROM SUIRPLUS.SEG_USUARIO_T U
                                                    JOIN SUIRPLUS.SEG_USUARIO_T u2 on NVL(u2.id_entidad_recaudadora, 0) = NVL(u.id_entidad_recaudadora, 0)
                                                                                  AND NVL(u2.id_registro_patronal, 0) = NVL(u.id_registro_patronal, 0)
                                                   WHERE U.ID_USUARIO = p_id_usuario)
               group by ce.id_usuario, initcap(ci.nombres || ' ' || ci.primer_apellido || ' ' || ci.segundo_apellido)
               order by 2 asc

             ) y)
      Select y.recordcount, pages.*
        from pages, (Select max(num) recordcount from pages) y
       where num between vDesde and vhasta;


    p_io_cursor     := c_cursor;
    p_resultnumber := 0;

  EXCEPTION
    WHEN OTHERS THEN
      v_bderror      := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ':' ||
                                SQLERRM,
                                1,
                                255));
      p_resultnumber := Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
      return;

 end;




 ----------------------------------------------------------------------------------------------------------------------
 -- ActualizarPDF
 -- BY Mayreni Vargas
 -- 03/06/2014
 -------------------------------------------------------------------------------------------------------------
 procedure ActualizarPDF(p_pdf              IN CER_CERTIFICACIONES_T.Pdf%type,
                         p_id_certificacion IN CER_CERTIFICACIONES_T.id_certificacion%TYPE,
                         p_id_usuario       IN CER_CERTIFICACIONES_T.id_usuario%TYPE,
                         p_resultnumber     out varchar2) is
 begin

   update cer_certificaciones_t c
      set c.pdf             = p_pdf,
          c.Ult_Usuario_Act = p_id_usuario,
          c.Ult_Fecha_Act   = Sysdate

    where c.id_certificacion = p_id_certificacion;


     p_resultnumber := '0';
 end ActualizarPDF;


 PROCEDURE isExisteEmpleadorConAcuerdo(
            p_Rnc in sre_empleadores_t.rnc_o_cedula%type,
            p_resultnumber        IN OUT varchar2)

   IS

    v_Emp       number(10);
    v_regPat    number(10);
    returnvalue BOOLEAN;

    CURSOR c_ExisteEmpleadorConAcuerdo IS
      SELECT a.id_registro_patronal FROM lgl_acuerdos_t a
       WHERE a.id_registro_patronal = v_regPat
       and a.status in (3,4);

  BEGIN
  --Buscamos el registro patronal de un empleador de acuerdo a un RNC
  select e.id_registro_patronal into v_regPat
  from sre_empleadores_t e where e.rnc_o_cedula = p_Rnc;

  --Validamos que el empleador  tenga un acuerdo de pago
   OPEN c_ExisteEmpleadorConAcuerdo;
      FETCH c_ExisteEmpleadorConAcuerdo  INTO v_Emp;
      returnvalue := c_ExisteEmpleadorConAcuerdo%FOUND;
      CLOSE c_ExisteEmpleadorConAcuerdo;

        if returnvalue = false then
        p_resultnumber := '0';
        else
        p_resultnumber:= '1';
        end if;


  END isExisteEmpleadorConAcuerdo;



    PROCEDURE CuotasPagadasAcuerdo(p_RncCedula    in sre_empleadores_t.rnc_o_cedula%type,
                                   p_iocursor     IN OUT t_cursor,
                                   p_resultnumber out varchar2) IS
      v_bderror VARCHAR(1000);
      c_cursor  t_cursor;
      v_count   number;

    BEGIN

      --Validando si tiene una pagada al dia
      select count(*)
        into v_count
        from suirplus.lgl_acuerdos_t a
        join suirplus.lgl_det_acuerdos_t d
          on d.id_acuerdo = a.id_acuerdo
         and a.tipo = d.tipo
        join suirplus.sre_empleadores_t e
          on e.id_registro_patronal = a.id_registro_patronal
        join suirplus.sfc_facturas_v f
          on f.ID_REFERENCIA = d.id_referencia
         and f.status = 'PA'
         and trunc(f.fecha_pago) < trunc(f.fecha_limite_acuerdo_pago)
       where e.rnc_o_cedula = p_RncCedula;

      if v_count = 0 then
        p_resultnumber := '1';
      else

        --Validando si pago una factura fuera de fecha
        select count(*)
          into v_count
          from suirplus.lgl_acuerdos_t a
          join suirplus.lgl_det_acuerdos_t d
            on d.id_acuerdo = a.id_acuerdo
           and a.tipo = d.tipo
          join suirplus.sre_empleadores_t e
            on e.id_registro_patronal = a.id_registro_patronal
          join suirplus.sfc_facturas_v f
            on f.ID_REFERENCIA = d.id_referencia
           and f.status = 'PA'
           and trunc(f.fecha_pago) > trunc(f.fecha_limite_acuerdo_pago)
         where e.rnc_o_cedula = p_RncCedula;

        if v_count > 0 then
          p_resultnumber := '2';
        else
          open c_cursor for

            select count(f.id_referencia) AS cantidad,
                   a.id_acuerdo,
                   a.periodo_ini,
                   a.periodo_fin,
                   a.cuotas,
                   a.fecha_registro
              from suirplus.lgl_acuerdos_t a
              join suirplus.lgl_det_acuerdos_t d
                on d.id_acuerdo = a.id_acuerdo
               and a.tipo = d.tipo
              join suirplus.sre_empleadores_t e
                on e.id_registro_patronal = a.id_registro_patronal
              join suirplus.sfc_facturas_v f
                on f.ID_REFERENCIA = d.id_referencia
               and f.status = 'PA'
               and trunc(f.fecha_pago) < trunc(f.fecha_limite_acuerdo_pago)
             where e.rnc_o_cedula = p_RncCedula
             group by a.id_acuerdo,
                      a.periodo_ini,
                      a.periodo_fin,
                      a.cuotas,
                      a.fecha_registro;

          p_iocursor     := c_cursor;
          p_resultnumber := '0';
        end if;

      end if;

    EXCEPTION

      WHEN OTHERS THEN
        v_bderror      := (substr('error ' || to_char(sqlcode) || ': ' ||
                                  sqlerrm,
                                  1,
                                  255));
        p_resultnumber := seg_retornar_cadena_error(-1, v_bderror, sqlcode);
        return;

    END;

  -- **************************************************************************************************
  -- Program:     TieneAporte
  -- Description: Verifica si un empleador ha realizado algun aporte para un ciudadano especifico
  -- **************************************************************************************************

  PROCEDURE TieneAporteGeneral(p_Rnc_Cedula   in sre_empleadores_t.rnc_o_cedula%type,
                        p_fecha_desde  in sfc_facturas_t.fecha_emision%type,
                        p_fecha_hasta  in sfc_facturas_t.fecha_emision%type,
                        p_resultnumber OUT VARCHAR2)

   IS
    v_TieneAporte varchar(1);

    cursor c_TieneAporte is
     SELECT 1
        FROM SFC_FACTURAS_V     F,
             SRE_EMPLEADORES_T  E
        WHERE F.ID_REGISTRO_PATRONAL = E.ID_REGISTRO_PATRONAL
        AND F.STATUS = 'PA'
          AND TRUNC(f.FECHA_EMISION) BETWEEN (p_fecha_desde) AND
               (p_fecha_hasta)
         AND E.RNC_O_CEDULA = p_Rnc_Cedula;

  BEGIN


      Open c_TieneAporte;
      fetch c_TieneAporte
        into v_TieneAporte;
      Close c_TieneAporte;

      if v_TieneAporte is not null then
        p_resultnumber := 'S';
      else
        p_resultnumber := 'N';
      end if;



  END;

END Cer_Certificaciones_Pkg;
