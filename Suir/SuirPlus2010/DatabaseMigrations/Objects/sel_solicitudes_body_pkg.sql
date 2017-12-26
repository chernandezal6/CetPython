create or replace package body SUIRPLUS.SEL_SOLICITUDES_PKG is
  -- **************************************************************************************************
  -- PROGRAM:           SEL_SOLICITUDES_PKG
  -- DESCRIPTION:       PAQUETE PARA LAS SOLICITUDES

  -- **************************************************************************************************
  -- PROCEDIMIENTO:     Crear_Solicitud
  -- DESCRIPTION:       Crea nuevo registro  de Solicitud en la tabla sel_solicitudes_t y
  --                    devuelve el id_solicitud del registro insertado
  -- **************************************************************************************************
  PROCEDURE Crear_Solicitud(p_id_tipo_solicitud  in sel_solicitudes_t.id_tipo_solicitud%type,
                            p_id_oficina_entrega in sel_solicitudes_t.id_oficina_entrega%type,
                            p_rnc_o_cedula       in sel_solicitudes_t.rnc_o_cedula%type,
                            p_representante      in sel_solicitudes_t.representante%type,
                            p_operador           in sel_solicitudes_t.operador%type,
                            p_comentarios        in sel_solicitudes_t.comentarios%type,
                            p_resultnumber       out varchar2) IS
    v_IdSolicitud        number(9);
    v_countEmp           int;
    v_status             sel_solicitudes_t.status%type;
    v_fechaProceso       sel_solicitudes_t.fecha_proceso%type;
    v_idRegistroPatronal sre_empleadores_t.id_registro_patronal%type;
    v_tipoSolicitudDes   sel_tipos_solicitudes_t.descripcion%type;
    v_idUsuario          crm_registro_t.id_usuario%type;
    v_email              seg_usuario_t.email%type;
    v_fax                sre_empleadores_t.fax%type;
    v_bderror            varchar(1000);
    e_InvalidTipoSol   exception;
    e_rnc_cedula       exception;
    e_InvalidRepresent exception;
    e_InvalidOperador  exception;
  
  BEGIN
    --validamos algunos parametros para asegurarnos que sean datos validos
    -- p_id_tipo_solicitud, p_rnc_o_cedula, p_representante, p_operador
    if not sel_solicitudes_pkg.isExisteTipoSolicitud(p_id_tipo_solicitud) then
      raise e_InvalidTipoSol;
    end if;
  
    if (p_rnc_o_cedula is not null) and (p_id_tipo_solicitud <> 2) then
      if (not sre_empleadores_pkg.isrncocedulavalida(p_rnc_o_cedula)) then
        raise e_rnc_cedula;
      else
        v_idRegistroPatronal := sre_empleadores_pkg.get_registropatronal(p_rnc_o_cedula);
      end if;
    elsif (p_rnc_o_cedula is not null) and (p_id_tipo_solicitud = 2) then
    
      select count(*)
        into v_countEmp
        FROM DGI_MAESTRO_EMPLEADORES_T dgi
       where dgi.rnc_cedula = p_rnc_o_cedula;
      if (v_countEmp = 0) then
        raise e_rnc_cedula;
      end if;
    end if;
  
    if (p_operador is not null) and
       (not seg_usuarios_pkg.isExisteUsuario(p_operador)) then
      raise e_InvalidOperador;
    end if;
  
    -- para condicionar el status antes de grabar
    If p_id_tipo_solicitud in (4, 8, 10, 11) then
      v_status := 3;
      ---------------------------------------------------
      -- Para llamar procedures de enviar email o fax
      -- segun las primera letra del parametro comentario
      -- E=email, F=fax
      ---------------------------------------------------
      If p_id_tipo_solicitud = 4 Then
        If Substr(ltrim(p_comentarios), 1, 1) = 'E' Then
          Select u.email
            into v_email
            From seg_usuario_t u
           Where u.id_usuario = p_rnc_o_cedula || p_representante;
        
          Sel_Solicitudes_Pkg.EstadoCuentaEmail(p_rnc_o_cedula,
                                                p_representante,
                                                v_email,
                                                p_resultnumber);
        ElsIf Substr(ltrim(p_comentarios), 1, 1) = 'F' Then
          Select e.fax
            into v_fax
            From sre_empleadores_t e
           Where e.rnc_o_cedula = p_rnc_o_cedula;
        
          commit;
        End if;
      End if;
    Elsif p_id_tipo_solicitud in (22, 1, 2, 3) then
      v_status       := 1;
      v_fechaProceso := sysdate;
    else
      v_status := 0;
    End if;
  
    --insertar registro de Solicitud en la tabla sel_solicitudes_t y devuelve el id de el registro insertado
    SELECT sel_solicitudes_seq.NEXTVAL INTO v_IdSolicitud FROM dual;
  
    insert into sel_solicitudes_t
      (id_solicitud,
       id_tipo_solicitud,
       status,
       id_oficina_entrega,
       rnc_o_cedula,
       representante,
       operador,
       comentarios,
       fecha_registro,
       fecha_cierre,
       ult_usr_modifico,
       entregado_a,
       fecha_entrega,
       via,
       fecha_proceso)
    values
      (v_IdSolicitud,
       p_id_tipo_solicitud,
       v_status,
       p_id_oficina_entrega,
       p_rnc_o_cedula,
       p_representante,
       p_operador,
       nvl(p_comentarios, ' '),
       sysdate,
       NULL,
       p_operador,
       NULL,
       NULL,
       decode(p_operador, null, 'W', 'C'),
       v_fechaProceso);
  
    ----------------------------------------------------------------
    -- Si la solicitud es de tipo devolucion de aportes, insertar registro en la tabla DVA_REGRISTROS_T
    ----------------------------------------------------------------
  
    if p_id_tipo_solicitud = '22' then
      insert into dva_registros_t
        (NRO_RECLAMACION, ID_REGISTRO_PATRONAL, ID_STATUS, FECHA_SOLICITUD)
      values
        (v_IdSolicitud, v_idRegistroPatronal, 'AP', sysdate());
    end if;
  
    ----------------------------------------------------------------
    -- Para insertar registro en la tabla CRM_REGISTRO_T
    -- solo si el tipo de solicitud esta en el rango 1,3,5,6,8,22
    ----------------------------------------------------------------
    If p_id_tipo_solicitud in (1, 3, 5, 6, 8, 22) Then
      Select t.descripcion
        Into v_tipoSolicitudDes
        From sel_tipos_solicitudes_t t
       Where t.id_tipo_solicitud = p_id_tipo_solicitud;
    
      If p_operador is null Then
        v_idUsuario := p_rnc_o_cedula || p_representante;
      Else
        v_idUsuario := p_operador;
      End if;
    
      Emp_Crm_Pkg.CrearEmp_Crm(v_idRegistroPatronal,
                               Substr(v_tipoSolicitudDes, 1, 50),
                               8,
                               null,
                               p_representante,
                               p_comentarios,
                               v_idUsuario,
                               sysdate,
                               null,
                               null,
                               p_resultnumber);
    
    End if;
  
    p_resultnumber := '0|' || v_IdSolicitud;
  
    commit;
  
  EXCEPTION
  
    WHEN e_InvalidTipoSol THEN
      p_resultnumber := '1|' || Seg_Retornar_Cadena_Error(178, NULL, NULL);
      RETURN;
    
    WHEN e_rnc_cedula THEN
      p_resultnumber := '1|' || Seg_Retornar_Cadena_Error(150, NULL, NULL);
      RETURN;
    
    when e_InvalidRepresent then
      p_resultnumber := '1|' || seg_retornar_cadena_error(154, null, null);
      return;
    
    when e_InvalidOperador then
      p_resultnumber := '1|' || seg_retornar_cadena_error(1, null, null);
      return;
    
    WHEN OTHERS THEN
      v_bderror      := (substr('error ' || to_char(sqlcode) || ': ' ||
                                sqlerrm,
                                1,
                                255));
      p_resultnumber := '1|' ||
                        seg_retornar_cadena_error(-1, v_bderror, sqlcode);
      return;
  END;

  -- **************************************************************************************************
  -- PROCEDIMIENTO:     Crear_RegistroEmp
  -- DESCRIPTION:       Crea nuevo registro  de Empresa en la tabla sel_Registro_Emp_t
  -- **************************************************************************************************
  PROCEDURE Crear_RegistroEmp(p_IdSolicitud      in sel_registro_emp_t.id_solicitud%type,
                              p_rnc_o_cedula     in sel_registro_emp_t.rnc_o_cedula%type,
                              p_razon_social     in sel_registro_emp_t.razon_social%type,
                              p_nombre_comercial in sel_registro_emp_t.nombre_comercial%type,
                              p_cedula           in sel_registro_emp_t.cedula%type,
                              p_telefono1        in sel_registro_emp_t.telefono1%type,
                              p_telefono2        in sel_registro_emp_t.telefono2%type,
                              p_resultnumber     out varchar2) IS
    e_InvalidSolicitud exception;
    v_bderror varchar(1000);
  
  BEGIN
    --validamos algunos parametros para asegurarnos que sean datos validos
  
    if not sel_solicitudes_pkg.isExisteIdSolicitud(p_idSolicitud) then
      raise e_InvalidSolicitud;
    end if;
  
    insert into sel_registro_emp_t
      (id_solicitud,
       rnc_o_cedula,
       razon_social,
       nombre_comercial,
       cedula,
       telefono1,
       telefono2)
    values
      (p_idsolicitud,
       p_rnc_o_cedula,
       p_razon_social,
       p_nombre_comercial,
       p_cedula,
       p_telefono1,
       p_telefono2);
  
    p_resultnumber := 0 || '|' || p_idsolicitud;
    commit;
  
  EXCEPTION
  
    when e_InvalidSolicitud then
      p_resultnumber := '1|' || seg_retornar_cadena_error(181, null, null);
      /*Para borrar la solicitud y evitar que se quede sin detalle previo a una excepcion*/
      BorrarSolicitud(p_IdSolicitud, p_resultnumber);
      Return;
    
    WHEN OTHERS THEN
      v_bderror      := (substr('error ' || to_char(sqlcode) || ': ' ||
                                sqlerrm,
                                1,
                                255));
      p_resultnumber := '1|' ||
                        seg_retornar_cadena_error(-1, v_bderror, sqlcode);
      /*Para borrar la solicitud y evitar que se quede sin detalle previo a una excepcion*/
      BorrarSolicitud(p_IdSolicitud, p_resultnumber);
      Return;
  END;

  -- **************************************************************************************************
  -- PROCEDIMIENTO:     Crear_Cancelacion
  -- DESCRIPTION:       Crea nueva cancelacion en la tabla sel_cancelacion_t
  -- **************************************************************************************************
  PROCEDURE Crear_Cancelacion(p_IdSolicitud           in sel_cancelacion_t.id_solicitud%type,
                              p_rnc_o_cedula          in sel_cancelacion_t.rnc_o_cedula%type,
                              p_persona_contacto      in sel_cancelacion_t.persona_contacto%type,
                              p_cargo                 in sel_cancelacion_t.cargo%type,
                              p_telefono              in sel_cancelacion_t.telefono%type,
                              p_tipo                  in sel_cancelacion_t.tipo%type,
                              p_motivo                in sel_cancelacion_t.motivo%type,
                              p_rnc_o_cedula_cancelar in sel_cancelacion_t.rnc_o_cedula_cancelar%type,
                              p_fax                   in sel_cancelacion_t.fax%type,
                              p_email                 in sel_cancelacion_t.email%type,
                              p_resultnumber          out varchar2) IS
    e_InvalidSolicitud exception;
    e_rnc_cedula       exception;
    v_bderror varchar(1000);
  
  BEGIN
    --validamos algunos parametros para asegurarnos que sean datos validos
  
    if not sel_solicitudes_pkg.isExisteIdSolicitud(p_idSolicitud) then
      raise e_InvalidSolicitud;
    end if;
  
    if not sre_empleadores_pkg.isrncocedulavalida(p_rnc_o_cedula) then
      raise e_rnc_cedula;
    end if;
  
    insert into sel_cancelacion_t
      (id_solicitud,
       rnc_o_cedula,
       persona_contacto,
       cargo,
       telefono,
       tipo,
       motivo,
       rnc_o_cedula_cancelar,
       fax,
       email)
    values
      (p_idsolicitud,
       p_rnc_o_cedula,
       p_persona_contacto,
       p_cargo,
       p_telefono,
       p_tipo,
       p_motivo,
       p_rnc_o_cedula_cancelar,
       p_fax,
       p_email);
  
    p_resultnumber := 0 || '|' || p_idsolicitud;
    commit;
  
  EXCEPTION
  
    When e_InvalidSolicitud then
      p_resultnumber := '1|' || seg_retornar_cadena_error(181, null, null);
      /*Para borrar la solicitud y evitar que se quede sin detalle previo a una excepcion*/
      BorrarSolicitud(p_IdSolicitud, p_resultnumber);
      Return;
    
    WHEN e_rnc_cedula THEN
      p_resultnumber := '1|' || Seg_Retornar_Cadena_Error(150, NULL, NULL);
      /*Para borrar la solicitud y evitar que se quede sin detalle previo a una excepcion*/
      BorrarSolicitud(p_IdSolicitud, p_resultnumber);
      Return;
    
    WHEN OTHERS THEN
      v_bderror      := (substr('error ' || to_char(sqlcode) || ': ' ||
                                sqlerrm,
                                1,
                                255));
      p_resultnumber := '1|' ||
                        seg_retornar_cadena_error(-1, v_bderror, sqlcode);
      /*Para borrar la solicitud y evitar que se quede sin detalle previo a una excepcion*/
      BorrarSolicitud(p_IdSolicitud, p_resultnumber);
      Return;
  END;

  -- **************************************************************************************************
  -- PROCEDIMIENTO:     Crear_Det_Cancelacion
  -- DESCRIPTION:       Crea nueva cancelacion en la tabla sel_det_cancelacion_t
  -- **************************************************************************************************
  PROCEDURE Crear_Det_Cancelacion(p_IdSolicitud   in sel_det_cancelacion_t.id_solicitud%type,
                                  p_id_referencia in sel_det_cancelacion_t.id_referencia%type,
                                  p_tipo          in sel_det_cancelacion_t.tipo%type,
                                  p_resultnumber  out varchar2) IS
    e_InvalidSolicitud exception;
    v_bderror varchar(1000);
  
  BEGIN
    --validamos algunos parametros para asegurarnos que sean datos validos
  
    if not sel_solicitudes_pkg.isExisteIdSolicitud(p_idSolicitud) then
      raise e_InvalidSolicitud;
    end if;
  
    insert into sel_det_cancelacion_t
      (id_solicitud, id_referencia, tipo)
    values
      (p_idsolicitud, p_id_referencia, p_tipo);
  
    p_resultnumber := 0 || '|' || p_idsolicitud;
    commit;
  
  EXCEPTION
  
    when e_InvalidSolicitud then
      p_resultnumber := '1|' || seg_retornar_cadena_error(181, null, null);
      return;
    
    WHEN OTHERS THEN
      v_bderror      := (substr('error ' || to_char(sqlcode) || ': ' ||
                                sqlerrm,
                                1,
                                255));
      p_resultnumber := '1|' ||
                        seg_retornar_cadena_error(-1, v_bderror, sqlcode);
      return;
  END;
  -- **************************************************************************************************
  -- PROCEDIMIENTO:     Crear_Informacion
  -- DESCRIPTION:       Crea nuevo registro en la tabla sel_informacion_t
  --OLD
  -- **************************************************************************************************
  PROCEDURE Crear_Informacion(p_IdSolicitud   in sel_informacion_t.id_solicitud%type,
                              p_nro_documento in sel_informacion_t.nro_documento%type,
                              p_institucion   in sel_informacion_t.institucion%type,
                              p_informacion   in sel_informacion_t.informacion%type,
                              p_motivo        in sel_informacion_t.motivo%type,
                              p_direccion     in sel_informacion_t.direccion%type,
                              p_telefono      in sel_informacion_t.telefono%type,
                              p_celular       in sel_informacion_t.celular%type,
                              p_cargo         in sel_informacion_t.cargo%type,
                              p_resultnumber  out varchar2) IS
    e_Solicitud exception;
    e_cedula    exception;
    v_tipo    sre_ciudadanos_t.tipo_documento%type;
    v_bderror varchar(1000);
  
  BEGIN
    --validamos algunos parametros para asegurarnos que sean datos validos
  
    if not sel_solicitudes_pkg.isExisteIdSolicitud(p_idSolicitud) then
      raise e_Solicitud;
    end if;
  
    if length(p_nro_documento) = 11 then
      v_tipo := 'C';
    else
      v_tipo := 'P';
    end if;
  
    /*Momentaneamente utilizo el parametro p_resultnumber para obtener el return value
    del procedure IsExisteCiudadano, esto no crea conflicto, mas abajo este parametro toma
    el valor que devuelve este procedimiento*/
    sre_ciudadano_pkg.IsExisteCiudadano(p_nro_documento,
                                        v_tipo,
                                        p_resultnumber);
  
    if p_resultnumber = 0 then
      raise e_cedula;
    end if;
  
    insert into sel_informacion_t
      (id_solicitud,
       nro_documento,
       institucion,
       informacion,
       motivo,
       direccion,
       telefono,
       celular,
       cargo)
    values
      (p_idsolicitud,
       p_nro_documento,
       p_institucion,
       p_informacion,
       p_motivo,
       p_direccion,
       p_telefono,
       p_celular,
       p_cargo);
  
    p_resultnumber := 0 || '|' || p_idsolicitud;
    commit;
  
  EXCEPTION
  
    when e_Solicitud then
      p_resultnumber := '1|' || seg_retornar_cadena_error(181, null, null);
      /*Para borrar la solicitud y evitar que se quede sin detalle previo a una excepcion*/
      BorrarSolicitud(p_IdSolicitud, p_resultnumber);
      Return;
    
    WHEN e_cedula THEN
      p_resultnumber := '1|' || Seg_Retornar_Cadena_Error(64, NULL, NULL);
      /*Para borrar la solicitud y evitar que se quede sin detalle previo a una excepcion*/
      BorrarSolicitud(p_IdSolicitud, p_resultnumber);
      Return;
    
    WHEN OTHERS THEN
      v_bderror      := (substr('error ' || to_char(sqlcode) || ': ' ||
                                sqlerrm,
                                1,
                                255));
      p_resultnumber := '1|' +
                        seg_retornar_cadena_error(-1, v_bderror, sqlcode);
      /*Para borrar la solicitud y evitar que se quede sin detalle previo a una excepcion*/
      BorrarSolicitud(p_IdSolicitud, p_resultnumber);
      Return;
  END;
  -- **************************************************************************************************
  -- PROCEDIMIENTO:     Crear_Informacion
  -- DESCRIPTION:       Crea nuevo registro en la tabla sel_informacion_t
  -- **************************************************************************************************
  PROCEDURE Crear_Informacion(p_idSolicitud    in sel_informacion_t.id_solicitud%type,
                              p_nombreCompleto in sel_informacion_t.nombre_completo%type,
                              p_nro_documento  in sel_informacion_t.nro_documento%type,
                              p_direccion      in sel_informacion_t.direccion%type,
                              p_telefono       in sel_informacion_t.telefono%type,
                              p_celular        in sel_informacion_t.celular%type,
                              p_fax            in sel_informacion_t.fax%type,
                              p_email          in sel_informacion_t.email%type,
                              p_institucion    in sel_informacion_t.institucion%type,
                              p_cargo          in sel_informacion_t.cargo%type,
                              p_informacion    in sel_informacion_t.informacion%type,
                              p_motivo         in sel_informacion_t.motivo%type,
                              p_autoridad      in sel_informacion_t.autoridad%type,
                              p_medio          in sel_informacion_t.medio%type,
                              p_lugar          in sel_informacion_t.lugar%type,
                              p_resultnumber   out varchar2) IS
    /*
    e_cedula exception;
    v_tipo    sre_ciudadanos_t.tipo_documento%type;*/
    e_Solicitud exception;
    v_bderror varchar(1000);
  
  BEGIN
    --validamos algunos parametros para asegurarnos que sean datos validos
  
    if not sel_solicitudes_pkg.isExisteIdSolicitud(p_idSolicitud) then
      raise e_Solicitud;
    end if;
  
    if (p_nombreCompleto is not null) and (p_telefono is not null) and
       (p_informacion is not null) and (p_motivo is not null) and
       (p_medio is not null) then
      insert into sel_informacion_t
        (id_solicitud,
         nombre_completo,
         nro_documento,
         direccion,
         telefono,
         celular,
         fax,
         email,
         institucion,
         cargo,
         informacion,
         motivo,
         autoridad,
         medio,
         lugar,
         fecha_registro)
      values
        (p_idSolicitud,
         p_nombreCompleto,
         p_nro_documento,
         p_direccion,
         p_telefono,
         p_celular,
         p_fax,
         p_email,
         p_institucion,
         p_cargo,
         p_informacion,
         p_motivo,
         p_autoridad,
         p_medio,
         p_lugar,
         sysdate);
    
      p_resultnumber := 0 || '|' || p_idsolicitud;
      commit;
    else
      p_resultnumber := 1 || '|' || 'Error procesando la solicitud.';
    end if;
  EXCEPTION
  
    when e_Solicitud then
      BorrarSolicitud(p_IdSolicitud, p_resultnumber);
      p_resultnumber := '1|Error procesando la solicitud.';
      /*Para borrar la solicitud y evitar que se quede sin detalle previo a una excepcion*/
    
      Return;
    WHEN OTHERS THEN
      /*Para borrar la solicitud y evitar que se quede sin detalle previo a una excepcion*/
      BorrarSolicitud(p_IdSolicitud, p_resultnumber);
      v_bderror      := (substr('error ' || to_char(sqlcode) || ': ' ||
                                sqlerrm,
                                1,
                                255));
      p_resultnumber := seg_retornar_cadena_error(-1, v_bderror, sqlcode);
    
      Return;
  END;

  -- **************************************************************************************************
  -- PROCEDIMIENTO:     Crear_InformacionGral
  -- DESCRIPTION:       Crea nuevo registro en la tabla sel_informacion_grl_t
  -- **************************************************************************************************
  PROCEDURE Crear_InformacionGral(p_IdSolicitud  in sel_informacion_grl_t.id_solicitud%type,
                                  p_informacion  in sel_informacion_grl_t.informacion%type,
                                  p_telefono1    in sel_informacion_grl_t.telefono1%type,
                                  p_telefono2    in sel_informacion_grl_t.telefono2%type,
                                  p_Idprovincia  in sel_informacion_grl_t.id_provincia%type,
                                  p_resultnumber out varchar2) IS
    e_Solicitud exception;
    e_cedula    exception;
    v_bderror varchar(1000);
  
  BEGIN
  
    --validamos algunos parametros para asegurarnos que sean datos validos
    if not sel_solicitudes_pkg.isExisteIdSolicitud(p_idSolicitud) then
      raise e_Solicitud;
    end if;
  
    insert into sel_informacion_grl_t
      (id_solicitud, informacion, telefono1, telefono2, id_provincia)
    values
      (p_idsolicitud,
       p_informacion,
       p_telefono1,
       p_telefono2,
       p_Idprovincia);
  
    p_resultnumber := 0 || '|' || p_idsolicitud;
    commit;
  
  EXCEPTION
  
    when e_Solicitud then
      p_resultnumber := '1|' || seg_retornar_cadena_error(181, null, null);
      /*Para borrar la solicitud y evitar que se quede sin detalle previo a una excepcion*/
      BorrarSolicitud(p_IdSolicitud, p_resultnumber);
      Return;
    
    WHEN e_cedula THEN
      p_resultnumber := '1|' || Seg_Retornar_Cadena_Error(64, NULL, NULL);
      /*Para borrar la solicitud y evitar que se quede sin detalle previo a una excepcion*/
      BorrarSolicitud(p_IdSolicitud, p_resultnumber);
      Return;
    
    WHEN OTHERS THEN
      v_bderror      := (substr('error ' || to_char(sqlcode) || ': ' ||
                                sqlerrm,
                                1,
                                255));
      p_resultnumber := '1|' +
                        seg_retornar_cadena_error(-1, v_bderror, sqlcode);
      /*Para borrar la solicitud y evitar que se quede sin detalle previo a una excepcion*/
      BorrarSolicitud(p_IdSolicitud, p_resultnumber);
      Return;
  END;

  -- ******************************************************************************************************
  -- PROCEDIMIENTO:     CambiarStatus
  -- DESCRIPTION:       Actualiza el status de la solicitud a partir del ID de la solicitud
  --                    recibido como parametro
  -- ******************************************************************************************************
  PROCEDURE CambiarSolicitud(p_idSolicitud    in sel_solicitudes_t.id_solicitud%type,
                             p_status         in sel_solicitudes_t.status%type,
                             p_ultimo_usuario in sel_solicitudes_t.ult_usr_modifico%type,
                             p_comentarios    in sel_solicitudes_t.comentarios%type,
                             p_resultnumber   out varchar2) IS
    v_idRegistroPatronal sre_empleadores_t.id_registro_patronal%type;
    v_tipoSolicitudDes   sel_tipos_solicitudes_t.descripcion%type;
    v_rnc_o_cedula       sel_solicitudes_t.rnc_o_cedula%type;
    v_id_tipo_solicitud  sel_solicitudes_t.id_tipo_solicitud%type;
    v_representante      sel_solicitudes_t.representante%type;
    e_InvalidSolicitud exception;
    v_bderror      varchar(1000);
    v_status_viejo sel_solicitudes_t.status%type;
  
  BEGIN
  
    --validar idsolicitud existe
    if not sel_solicitudes_pkg.isExisteIdSolicitud(p_idSolicitud) then
      raise e_InvalidSolicitud;
    end if;
  
    Select status
      into v_status_viejo
      from sel_solicitudes_t
     where id_solicitud = p_idSolicitud;
    --------------------------------------------------------------------------
    -- para actualizar el comentario agregandole el operador y la fecha actual
    --------------------------------------------------------------------------
    update sel_solicitudes_t s
       set status           = p_status,
           fecha_cierre     = decode(p_status,
                                     '3',
                                     sysdate,
                                     '4',
                                     sysdate,
                                     fecha_cierre),
           ult_usr_modifico = p_ultimo_usuario,
           comentarios      = p_comentarios || chr(13) || chr(10) ||
                              'Operador: ' ||
                              seg_usuarios_pkg.getNombreUsuario(p_ultimo_usuario) ||
                              chr(13) || chr(10) || 'Fecha: ' || sysdate ||
                              chr(13) || chr(10) || '----------' || chr(13) ||
                              chr(10) || ''
     where id_solicitud = p_idSolicitud;
  
    --------------------------------------------------------------------------
    -- para insertar tiempo en pausa, si el estatus suplido es el 2
    --------------------------------------------------------------------------
    If p_status = 2 then
      insert into sel_solicitud_pausa_t
        (id_solicitud, fecha_inicio)
      values
        (p_idSolicitud, sysdate);
    end if;
  
    --------------------------------------------------------------------------
    -- para registrar el tiempo fin de la pausa, si el estatus anterior es el 2
    --------------------------------------------------------------------------
    If p_status <> 2 and v_status_viejo = 2 then
      update sel_solicitud_pausa_t
         set fecha_fin = sysdate
       where id_solicitud = p_idSolicitud
         and fecha_fin is null;
    end if;
  
    --------------------------------------------------------------------------
    -- Para insertar historico en la tabla SEL_DET_USR_SOLICITUD_T
    --------------------------------------------------------------------------
  
    insert into sel_det_usr_solicitud_t
      (id_sol, id_solicitud, id_usuario, fecha_registro)
    values
      (seq_SelDetSol.Nextval, p_idSolicitud, p_ultimo_usuario, sysdate);
    commit;
  
    ----------------------------------------------------------------
    -- Para insertar registro en la tabla CRM_REGISTRO_T
    -- solo si el tipo de solicitud esta en el rango 1,3,5,6,8
    ----------------------------------------------------------------
    Select s.id_tipo_solicitud, s.rnc_o_cedula, s.representante
      Into v_id_tipo_solicitud, v_rnc_o_cedula, v_representante
      From sel_solicitudes_t s
     Where s.id_solicitud = p_idSolicitud;
  
    -----------------------------------------------
    -- solo aplica para cierto tipos de solicitudes
    -----------------------------------------------
    If v_id_tipo_solicitud in (1, 3, 5, 6, 8, 12, 20, 21) and
       p_comentarios != 'cambio automatico' Then
      Select t.descripcion
        Into v_tipoSolicitudDes
        From sel_tipos_solicitudes_t t
       Where t.id_tipo_solicitud = v_id_tipo_solicitud;
    
      Select e.id_registro_patronal
        Into v_idRegistroPatronal
        From sre_empleadores_t e
       Where e.rnc_o_cedula = v_rnc_o_cedula;
    
      Emp_Crm_Pkg.CrearEmp_Crm(v_idRegistroPatronal,
                               Substr(v_tipoSolicitudDes, 1, 50),
                               8,
                               null,
                               v_representante,
                               p_comentarios,
                               p_ultimo_usuario,
                               sysdate,
                               null,
                               null,
                               p_resultnumber);
    
    End if;
  
    commit;
    p_resultnumber := 0;
  
  EXCEPTION
  
    when e_InvalidSolicitud then
      p_resultnumber := seg_retornar_cadena_error(181, null, null);
      return;
    
    WHEN OTHERS THEN
      v_bderror      := (substr('error ' || to_char(sqlcode) || ': ' ||
                                sqlerrm,
                                1,
                                255));
      p_resultnumber := seg_retornar_cadena_error(-1, v_bderror, sqlcode);
      return;
  END;

  -- **************************************************************************************************
  -- PROCEDIMIENTO:     getTipoSolicitudes
  -- DESCRIPTION:       Trae todos los tipos de solicitudes existentes en la tabla sel_tipo_solicitudes_t
  -- **************************************************************************************************
  PROCEDURE getTipoSolicitudes(p_iocursor     out t_cursor,
                               p_resultnumber out varchar2) IS
  
    v_bderror varchar(1000);
    c_cursor  t_cursor;
  BEGIN
  
    open c_cursor for
      select t.id_tipo_solicitud  IdTipo,
             t.descripcion        TipoSolicitud,
             t.id_oficina_entrega IdOficina,
             o.descripcion        Oficina
        from sel_tipos_solicitudes_t t, sel_oficinas_t o
       where t.id_oficina_entrega = o.id_oficina
         and status = 'A'
       order by TipoSolicitud;
  
    p_iocursor     := c_cursor;
    p_resultnumber := 0;
  
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
  -- PROCEDIMIENTO:  getTipoSolicitud
  -- DESCRIPTION:    Trae el tipo de solicitud desde la tabla sel_solicitudes_t buscando a traves del
  --                 parametro P_idSolicitud
  -- **************************************************************************************************
  PROCEDURE getTipoSolicitud(p_idSolicitud  in sel_solicitudes_t.id_solicitud%type,
                             p_resultnumber out varchar2) is
    v_bderror varchar(1000);
  
  BEGIN
    Select s.id_tipo_solicitud
      into p_resultnumber
      From sel_solicitudes_t s
     Where s.id_solicitud = p_idSolicitud;
  
  EXCEPTION
    when no_data_found then
      p_resultnumber := seg_retornar_cadena_error(104, null, null);
      return;
    
    WHEN OTHERS THEN
      v_bderror      := (substr('error ' || to_char(sqlcode) || ': ' ||
                                sqlerrm,
                                1,
                                255));
      p_resultnumber := seg_retornar_cadena_error(-1, v_bderror, sqlcode);
      return;
  END;

  /*-- **************************************************************************************************
  -- PROCEDIMIENTO:     getSubTipoSolicitudes
  -- DESCRIPTION:       Trae todos los tipos de solicitudes existentes en la tabla sel_tipo_solicitudes_t
  -- **************************************************************************************************
     PROCEDURE getSubTipoSolicitudes(
          p_iocursor      out t_cursor,
          p_resultnumber  out varchar2)
      IS
  
      v_bderror           varchar(1000);
      c_cursor t_cursor;
      BEGIN
  
      open c_cursor for
          select t.id_tipo_solicitud,t.descripcion,t.id_oficina_entrega
          from sel_tipos_solicitudes_t t;
  
          p_iocursor := c_cursor;
          p_resultnumber := 0;
  
  
      EXCEPTION
  
          WHEN OTHERS THEN
              v_bderror := (substr('error '||to_char(sqlcode)||': '||sqlerrm, 1, 255));
              p_resultnumber := seg_retornar_cadena_error(-1, v_bderror,sqlcode);
          return;
      END;
  
  */
  -- **************************************************************************************************
  -- PROCEDIMIENTO:     CargarDatos
  -- DESCRIPTION:       Trae el registro solicitado de la tabla sel_solicitudes_t para un id especifico
  -- **************************************************************************************************
  PROCEDURE CargarDatos(p_idSolicitud  in sel_solicitudes_t.id_solicitud%type,
                        p_iocursor     out t_cursor,
                        p_resultnumber out varchar2) IS
  
    v_bderror varchar(1000);
    c_cursor  t_cursor;
  BEGIN
  
    open c_cursor for
      select s.id_solicitud,
             s.id_tipo_solicitud,
             t.descripcion,
             est.descripcion Status,
             s.status idStatus,
             s.id_oficina_entrega,
             o.descripcion,
             s.rnc_o_cedula,
             e.razon_social,
             e.nombre_comercial,
             s.representante,
             c.nombres ||
             Decode(c.primer_apellido, null, '', ' ' || c.primer_apellido) ||
             Decode(c.segundo_apellido, null, '', ' ' || c.segundo_apellido) NombreRepresentante,
             s.operador,
             u.nombre_usuario ||
             Decode(u.apellidos, null, '', ' ' || u.apellidos) NombreOperador,
             s.comentarios,
             s.fecha_registro,
             s.fecha_cierre,
             s.ult_usr_modifico,
             u2.nombre_usuario ||
             Decode(u2.apellidos, null, '', ' ' || u2.apellidos) UsuarioModifica,
             s.entregado_a,
             s.fecha_entrega,
             s.id_tipo_solicitud,
             t.descripcion Tipo_Solicitud
        from sel_solicitudes_t s
        join sel_tipos_solicitudes_t t
          on s.id_tipo_solicitud = t.id_tipo_solicitud
        join sel_oficinas_t o
          on s.id_oficina_entrega = o.id_oficina
        left join seg_usuario_t u
          on s.operador = u.id_usuario
        left join sre_ciudadanos_t c
          on s.representante = c.no_documento
        left join seg_usuario_t u2
          on s.ult_usr_modifico = u2.id_usuario
        left join sre_empleadores_t e
          on s.rnc_o_cedula = e.rnc_o_cedula
        join sel_status_t est
          on est.id_status = s.status
       where s.id_solicitud = p_idSolicitud;
  
    p_iocursor     := c_cursor;
    p_resultnumber := 0;
  
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
  -- PROCEDIMIENTO:     getCancelacion
  -- DESCRIPTION:       Trae los registros que pertenezcan a una solicitud cancelada especifica
  -- **************************************************************************************************
  PROCEDURE getCancelacion(p_idSolicitud  in sel_solicitudes_t.id_solicitud%type,
                           p_iocursor     out t_cursor,
                           p_resultnumber out varchar2) IS
    e_InvalidSolicitud exception;
    v_bderror varchar(1000);
    c_cursor  t_cursor;
  
  BEGIN
  
    --validar si la solicitud existe
    if not sel_solicitudes_pkg.isExisteIdSolicitud(p_idSolicitud) then
      raise e_InvalidSolicitud;
    end if;
  
    open c_cursor for
      select c.id_solicitud,
             c.rnc_o_cedula,
             c.persona_contacto,
             c.cargo,
             c.telefono,
             decode(c.tipo,
                    'R',
                    'Rnc o Cedula',
                    'F',
                    'Recargo y/o Notificacion de Pago') Tipo,
             c.motivo,
             c.rnc_o_cedula_cancelar,
             c.fax,
             c.email,
             s.status,
             s.operador,
             s.comentarios,
             u.nombre_usuario ||
             decode(u.apellidos, null, '', ' ' || u.apellidos) Operador_Nombre,
             s.fecha_registro,
             s.fecha_cierre,
             s.fecha_entrega,
             s.ult_usr_modifico,
             s.id_tipo_solicitud,
             t.descripcion Tipo_Solicitud,
             s.status,
             e.razon_social,
             e.nombre_comercial,
             s.representante,
             ci.nombres || ' ' || nvl(ci.primer_apellido, '') || ' ' ||
             nvl(ci.segundo_apellido, '') Representante_Nombre,
             est.descripcion Descripcion_Status
        from sel_cancelacion_t c
        join sel_solicitudes_t s
          on s.id_solicitud = c.id_solicitud
        left join seg_usuario_t u
          on u.id_usuario = s.operador
        join sel_tipos_solicitudes_t t
          on t.id_tipo_solicitud = s.id_tipo_solicitud
        join sre_empleadores_t e
          on e.rnc_o_cedula = c.rnc_o_cedula
        left join sre_ciudadanos_t ci
          on s.representante = ci.no_documento
         and ci.tipo_documento = 'C'
        join sel_status_t est
          on est.id_status = s.status
      
       where c.id_solicitud = p_idSolicitud;
  
    p_iocursor     := c_cursor;
    p_resultnumber := 0;
  
  EXCEPTION
  
    when e_InvalidSolicitud then
      p_resultnumber := seg_retornar_cadena_error(181, null, null);
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
  -- PROCEDIMIENTO:     getDetCancelacion
  -- DESCRIPTION:       Trae los registros en detalles que pertenezcan a una solicitud cancelada especifica
  -- ******************************************************************************************************
  PROCEDURE getDetCancelacion(p_idSolicitud  in sel_solicitudes_t.id_solicitud%type,
                              p_iocursor     out t_cursor,
                              p_resultnumber out varchar2) IS
  
    e_InvalidSolicitud exception;
    v_bderror varchar(1000);
    c_cursor  t_cursor;
  BEGIN
  
    --validar idsolicitud existe
    if not sel_solicitudes_pkg.isExisteIdSolicitud(p_idSolicitud) then
      raise e_InvalidSolicitud;
    end if;
  
    open c_cursor for
      select d.id_solicitud,
             d.id_referencia,
             decode(d.tipo, 'R', 'Recargo', 'F', 'Factura') Tipo
        from sel_det_cancelacion_t d
       where d.id_solicitud = p_idSolicitud;
  
    p_iocursor     := c_cursor;
    p_resultnumber := 0;
  
  EXCEPTION
  
    when e_InvalidSolicitud then
      p_resultnumber := seg_retornar_cadena_error(181, null, null);
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
  -- PROCEDIMIENTO:     getSolicitud
  -- DESCRIPTION:       Trae los registros de una solicitid basada en el ID de la misma
  -- ******************************************************************************************************
  PROCEDURE getSolicitud(p_idSolicitud  in sel_solicitudes_t.id_solicitud%type,
                         p_iocursor     out t_cursor,
                         p_resultnumber out varchar2) IS
  
    e_InvalidSolicitud exception;
    v_bderror varchar(1000);
    c_cursor  t_cursor;
  
  BEGIN
  
    --validar idsolicitud existe
    if not sel_solicitudes_pkg.isExisteIdSolicitud(p_idSolicitud) then
      raise e_InvalidSolicitud;
    end if;
  
    open c_cursor for
      select tip.descripcion Tipo_solicitud,
             sol.status,
             est.descripcion Descripcion_Status,
             c.nombres ||
             decode(c.primer_apellido, null, '', ' ' || c.primer_apellido) ||
             decode(c.segundo_apellido, null, '', ' ' || c.segundo_apellido) Solicitante,
             emp.razon_social,
             sol.comentarios,
             sol.id_tipo_solicitud
        from sel_solicitudes_t sol
        join sel_tipos_solicitudes_t tip
          on tip.id_tipo_solicitud = sol.id_tipo_solicitud
        left join sre_ciudadanos_t c
          on c.no_documento = sol.representante
         and c.tipo_documento = 'C'
        left join sre_empleadores_t emp
          on emp.rnc_o_cedula = sol.rnc_o_cedula
        join sel_status_t est
          on est.id_status = sol.status
       where sol.id_solicitud = p_idSolicitud
       order by tip.descripcion;
  
    p_iocursor     := c_cursor;
    p_resultnumber := 0;
  
  EXCEPTION
  
    when e_InvalidSolicitud then
      p_resultnumber := seg_retornar_cadena_error(181, null, null);
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
  -- PROCEDIMIENTO:     getNovedades
  -- DESCRIPTION:       Trae los registros de una solicitid basada en el ID de la misma
  -- ******************************************************************************************************
  PROCEDURE getNovedades(p_idSolicitud  in sel_solicitudes_t.id_solicitud%type,
                         p_iocursor     out t_cursor,
                         p_resultnumber out varchar2) IS
  
    e_InvalidSolicitud exception;
    v_bderror varchar(1000);
    c_cursor  t_cursor;
  
  BEGIN
  
    --validar idsolicitud existe
    if not sel_solicitudes_pkg.isExisteIdSolicitud(p_idSolicitud) then
      raise e_InvalidSolicitud;
    end if;
  
    open c_cursor for
      select tip.descripcion Tipo_solicitud,
             sol.status,
             est.descripcion Descripcion_Status,
             sol.representante,
             c.nombres ||
             decode(c.primer_apellido, null, '', ' ' || c.primer_apellido) ||
             decode(c.segundo_apellido, null, '', ' ' || c.segundo_apellido) Representante_Nombre,
             sol.operador,
             u.nombre_usuario ||
             decode(u.apellidos, null, '', ' ' || u.apellidos) Operador_Nombre,
             sol.fecha_cierre,
             sol.fecha_registro,
             sol.fecha_entrega,
             sol.entregado_a,
             emp.rnc_o_cedula,
             emp.razon_social,
             emp.nombre_comercial,
             sol.comentarios,
             sol.id_tipo_solicitud,
             sol.ult_usr_modifico
      
        from sel_solicitudes_t sol
        left join seg_usuario_t u
          on u.id_usuario = sol.operador
        join sel_tipos_solicitudes_t tip
          on tip.id_tipo_solicitud = sol.id_tipo_solicitud
        left join sre_ciudadanos_t c
          on c.no_documento = sol.representante
         and c.tipo_documento = 'C'
        left join sre_empleadores_t emp
          on emp.rnc_o_cedula = sol.rnc_o_cedula
        join sel_status_t est
          on est.id_status = sol.status
       where sol.id_solicitud = p_idSolicitud
       order by tip.descripcion, sol.fecha_registro;
  
    p_iocursor     := c_cursor;
    p_resultnumber := 0;
  
  EXCEPTION
  
    when e_InvalidSolicitud then
      p_resultnumber := seg_retornar_cadena_error(181, null, null);
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
  -- PROCEDIMIENTO:     getSolicitud
  -- DESCRIPTION:       Trae los registros de una solicitud basada en los parametros recibidos
  -- ******************************************************************************************************
  PROCEDURE getSolicitud(p_idSolicitud   in sel_solicitudes_t.id_solicitud%type,
                         p_status        in sel_solicitudes_t.status%type,
                         p_tipoSolicitud in sel_solicitudes_t.id_tipo_solicitud%type,
                         p_idOficina     in sel_solicitudes_t.id_oficina_entrega%type,
                         p_idProvincia   in sre_provincias_t.id_provincia%type,
                         p_registros     in number,
                         p_iocursor      out t_cursor,
                         p_resultnumber  out varchar2) IS
  
    e_InvalidSolicitud exception;
    v_bderror varchar(1000);
    c_cursor  t_cursor;
    rn        NUMBER(20);
  BEGIN
    -- para obtener numeros random confiables
    SELECT to_number(to_char(sysdate, 'ssmihh24dd')) INTO rn FROM dual;
    dbms_random.initialize(rn);
  
    --validar idsolicitud existe
    if (p_idSolicitud <> 0) and (p_idSolicitud is not null) and
       (not sel_solicitudes_pkg.isExisteIdSolicitud(p_idSolicitud)) then
      raise e_InvalidSolicitud;
    end if;
  
    open c_cursor for
      select b.*
        from (select dbms_random.random al_azar, a.*
                from (select sol.id_solicitud,
                             tip.descripcion Tipo_solicitud,
                             sol.status,
                             sol.fecha_registro,
                             est.descripcion Descripcion_Status,
                             ofi.descripcion Descripcion_Oficina,
                             c.nombres ||
                             decode(c.primer_apellido,
                                    null,
                                    '',
                                    ' ' || c.primer_apellido) ||
                             decode(c.segundo_apellido,
                                    null,
                                    '',
                                    ' ' || c.segundo_apellido) Solicitante,
                             emp.razon_social,
                             substr(sol.comentarios, 1, 20) || '...' Comentarios,
                             sol.id_tipo_solicitud,
                             InitCap(sel_solicitudes_pkg.getProvinciaDes(sol.rnc_o_cedula)) provincia,
                             sol.via,
                             decode(sol.via, 'W', 'TSS', 'C', 'CCG') Descripcion_Via
                        from sel_solicitudes_t sol
                        join sel_tipos_solicitudes_t tip
                          on tip.id_tipo_solicitud = sol.id_tipo_solicitud
                        left join sre_ciudadanos_t c
                          on c.no_documento = sol.representante
                         and c.tipo_documento = 'C'
                        left join sre_empleadores_t emp
                          on emp.rnc_o_cedula = sol.rnc_o_cedula
                        join sel_status_t est
                          on est.id_status = sol.status
                        join sel_oficinas_t ofi
                          on ofi.id_oficina = sol.id_oficina_entrega
                       where sol.id_solicitud =
                             decode(p_idSolicitud,
                                    0,
                                    sol.id_solicitud,
                                    null,
                                    sol.id_solicitud,
                                    p_idSolicitud)
                         and sol.id_tipo_solicitud =
                             decode(p_tipoSolicitud,
                                    0,
                                    sol.id_tipo_solicitud,
                                    null,
                                    sol.id_tipo_solicitud,
                                    p_tipoSolicitud)
                         and sol.status = decode(p_status,
                                                 99,
                                                 sol.status,
                                                 null,
                                                 sol.status,
                                                 p_status)
                         and sol.id_oficina_entrega =
                             decode(p_idOficina,
                                    99,
                                    sol.id_oficina_entrega,
                                    null,
                                    sol.id_oficina_entrega,
                                    p_idOficina)
                         and ((sel_solicitudes_pkg.getProvinciaID(sol.rnc_o_cedula) =
                             p_idProvincia) or (p_idProvincia = 0))
                      Union all
                      select sol.id_solicitud,
                             tip.descripcion Tipo_solicitud,
                             sol.status,
                             sol.fecha_registro,
                             est.descripcion Descripcion_Status,
                             ofi.descripcion Descripcion_Oficina,
                             c.nombres ||
                             decode(c.primer_apellido,
                                    null,
                                    '',
                                    ' ' || c.primer_apellido) ||
                             decode(c.segundo_apellido,
                                    null,
                                    '',
                                    ' ' || c.segundo_apellido) Solicitante,
                             emp.razon_social,
                             substr(inf.informacion, 1, 20) || '...' Comentarios,
                             sol.id_tipo_solicitud,
                             InitCap(pro.provincia_des) provincia,
                             sol.via,
                             decode(sol.via, 'W', 'TSS', 'C', 'CCG') Descripcion_Via
                        from sel_solicitudes_t sol
                        join sel_tipos_solicitudes_t tip
                          on tip.id_tipo_solicitud = sol.id_tipo_solicitud
                        left join sre_ciudadanos_t c
                          on c.no_documento = sol.representante
                         and c.tipo_documento = 'C'
                        left join sre_empleadores_t emp
                          on emp.rnc_o_cedula = sol.rnc_o_cedula
                        join sel_status_t est
                          on est.id_status = sol.status
                        join sel_oficinas_t ofi
                          on ofi.id_oficina = sol.id_oficina_entrega
                        join sel_informacion_grl_t inf
                          on inf.id_solicitud = sol.id_solicitud
                        join sre_provincias_t pro
                          on pro.id_provincia = inf.id_provincia
                       where sol.id_solicitud =
                             decode(p_idSolicitud,
                                    0,
                                    sol.id_solicitud,
                                    null,
                                    sol.id_solicitud,
                                    p_idSolicitud)
                         and sol.id_tipo_solicitud =
                             decode(p_tipoSolicitud,
                                    0,
                                    sol.id_tipo_solicitud,
                                    null,
                                    sol.id_tipo_solicitud,
                                    p_tipoSolicitud)
                         and sol.status = decode(p_status,
                                                 99,
                                                 sol.status,
                                                 null,
                                                 sol.status,
                                                 p_status)
                         and sol.id_oficina_entrega =
                             decode(p_idOficina,
                                    99,
                                    sol.id_oficina_entrega,
                                    null,
                                    sol.id_oficina_entrega,
                                    p_idOficina)
                         and inf.id_provincia = p_idProvincia) a
               order by a.id_solicitud desc) b
       where rownum <= p_registros;
       
  
    p_iocursor     := c_cursor;
    p_resultnumber := 0;
  
  EXCEPTION
  
    when e_InvalidSolicitud then
      p_resultnumber := seg_retornar_cadena_error(181, null, null);
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
  -- PROCEDIMIENTO:     getSolicitud_RNC
  -- DESCRIPTION:       Trae los registros de una solicitud basada en el RNC o la Cedula del empleador
  -- ******************************************************************************************************
  PROCEDURE getSolicitud_RNC(p_rnc_o_cedula in sre_empleadores_t.rnc_o_cedula%type,
                             p_iocursor     out t_cursor,
                             p_resultnumber out varchar2) IS
  
    e_rnc_o_cedula exception;
    v_bderror varchar(1000);
    c_cursor  t_cursor;
  
  BEGIN
  
    --validar si el RNC o la Cedula esxiste en la tabla de empleadores
    /*        sel_solicitudes_pkg.isRNCRegistrado(p_rnc_o_cedula, p_resultnumber);
    
    if p_resultnumber = 0 then
        raise e_rnc_o_cedula;
    end if;  */
  
    open c_cursor for
      select sol.id_solicitud,
             tip.descripcion Tipo_Solicitud,
             sol.status,
             est.descripcion Descripcion_Status,
             sol.fecha_registro,
             sol.id_oficina_entrega,
             ofi.descripcion Descripcion_Oficina,
             c.nombres ||
             decode(c.primer_apellido, null, '', ' ' || c.primer_apellido) ||
             decode(c.segundo_apellido, null, '', ' ' || c.segundo_apellido) Solicitante,
             emp.razon_social,
             sol.comentarios,
             sol.id_tipo_solicitud
        from sel_solicitudes_t sol
        join sel_tipos_solicitudes_t tip
          on tip.id_tipo_solicitud = sol.id_tipo_solicitud
        left join sre_ciudadanos_t c
          on c.no_documento = sol.representante
         and c.tipo_documento = 'C'
        left join sre_empleadores_t emp
          on emp.rnc_o_cedula = sol.rnc_o_cedula
        join sel_status_t est
          on est.id_status = sol.status
        join sel_oficinas_t ofi
          on ofi.id_oficina = sol.id_oficina_entrega
       where sol.rnc_o_cedula = p_rnc_o_cedula
      
      union all
      
      select sol.id_solicitud,
             tip.descripcion Tipo_Solicitud,
             sol.status,
             est.descripcion Descripcion_Status,
             sol.fecha_registro,
             sol.id_oficina_entrega,
             ofi.descripcion Descripcion_Oficina,
             c.nombres ||
             decode(c.primer_apellido, null, '', ' ' || c.primer_apellido) ||
             decode(c.segundo_apellido, null, '', ' ' || c.segundo_apellido) Solicitante,
             emp.razon_social,
             sol.comentarios,
             sol.id_tipo_solicitud
        from sel_registro_emp_t remp
        join sel_solicitudes_t sol
          on sol.id_solicitud = remp.id_solicitud
        join sel_tipos_solicitudes_t tip
          on tip.id_tipo_solicitud = sol.id_tipo_solicitud
        left join sre_ciudadanos_t c
          on c.no_documento = sol.representante
         and c.tipo_documento = 'C'
        left join sre_empleadores_t emp
          on emp.rnc_o_cedula = sol.rnc_o_cedula
        join sel_status_t est
          on est.id_status = sol.status
        join sel_oficinas_t ofi
          on ofi.id_oficina = sol.id_oficina_entrega
       where remp.rnc_o_cedula = p_rnc_o_cedula
      
       order by 1;
  
    p_iocursor     := c_cursor;
    p_resultnumber := 0;
  
  EXCEPTION
  
    when e_rnc_o_cedula then
      p_resultnumber := seg_retornar_cadena_error(150, null, null);
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
  -- PROCEDIMIENTO:     getSolicitud_Oficina
  -- DESCRIPTION:       Trae los registros de una solicitud basada en el ID de la oficina
  -- ******************************************************************************************************
  PROCEDURE getSolicitud_Oficina(p_id_oficina   in sel_oficinas_t.id_oficina%type,
                                 p_iocursor     out t_cursor,
                                 p_resultnumber out varchar2) IS
  
    e_oficina exception;
    v_bderror varchar(1000);
    c_cursor  t_cursor;
  
  BEGIN
  
    --validar si el RNC o la Cedula esxiste en la tabla de empleadores
    if sel_solicitudes_pkg.isExisteOficina(p_id_oficina) then
      raise e_oficina;
    end if;
  
    open c_cursor for
      select sol.id_solicitud,
             tip.descripcion Tipo_Solicitud,
             sol.status,
             est.descripcion Descripcion_Status,
             sol.fecha_registro,
             sol.id_oficina_entrega,
             ofi.descripcion Descripcion_Oficina,
             c.nombres ||
             decode(c.primer_apellido, null, '', ' ' || c.primer_apellido) ||
             decode(c.segundo_apellido, null, '', ' ' || c.segundo_apellido) Solicitante,
             emp.razon_social,
             sol.comentarios,
             sol.id_tipo_solicitud
        from sel_solicitudes_t sol
        join sel_tipos_solicitudes_t tip
          on tip.id_tipo_solicitud = sol.id_tipo_solicitud
        left join sre_ciudadanos_t c
          on c.no_documento = sol.representante
         and c.tipo_documento = 'C'
        left join sre_empleadores_t emp
          on emp.rnc_o_cedula = sol.rnc_o_cedula
        join sel_status_t est
          on est.id_status = sol.status
        join sel_oficinas_t ofi
          on ofi.id_oficina = sol.id_oficina_entrega
       where sol.id_oficina_entrega = p_id_oficina;
  
    p_iocursor     := c_cursor;
    p_resultnumber := 0;
  
  EXCEPTION
  
    when e_oficina then
      p_resultnumber := seg_retornar_cadena_error(182, null, null);
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
  -- PROCEDIMIENTO:     getSolicitud_Status
  -- DESCRIPTION:       Trae los registros de una solicitud basada en el status pasado como parametro
  -- ******************************************************************************************************
  PROCEDURE getSolicitud_Status(p_status       in sel_solicitudes_t.status%type,
                                p_iocursor     out t_cursor,
                                p_resultnumber out varchar2) IS
  
    e_status exception;
    v_bderror varchar(1000);
    c_cursor  t_cursor;
  
  BEGIN
  
    --validar si el status de la solicitud es valido
    if p_status not in (0, 1, 2, 3, 4) then
      raise e_status;
    end if;
  
    open c_cursor for
      select sol.id_solicitud,
             tip.descripcion Tipo_Solicitud,
             sol.status,
             est.descripcion Descripcion_Status,
             sol.fecha_registro,
             sol.id_oficina_entrega,
             ofi.descripcion Descripcion_Oficina,
             c.nombres ||
             decode(c.primer_apellido, null, '', ' ' || c.primer_apellido) ||
             decode(c.segundo_apellido, null, '', ' ' || c.segundo_apellido) Solicitante,
             emp.razon_social,
             sol.comentarios,
             sol.id_tipo_solicitud
        from sel_solicitudes_t sol
        join sel_tipos_solicitudes_t tip
          on tip.id_tipo_solicitud = sol.id_tipo_solicitud
        left join sre_ciudadanos_t c
          on c.no_documento = sol.representante
         and c.tipo_documento = 'C'
        left join sre_empleadores_t emp
          on emp.rnc_o_cedula = sol.rnc_o_cedula
        join sel_status_t est
          on est.id_status = sol.status
        join sel_oficinas_t ofi
          on ofi.id_oficina = sol.id_oficina_entrega
       where sol.status = p_status;
  
    p_iocursor     := c_cursor;
    p_resultnumber := 0;
  
  EXCEPTION
  
    when e_status then
      p_resultnumber := seg_retornar_cadena_error(183, null, null);
      return;
    
    WHEN OTHERS THEN
      v_bderror      := (substr('error ' || to_char(sqlcode) || ': ' ||
                                sqlerrm,
                                1,
                                255));
      p_resultnumber := seg_retornar_cadena_error(-1, v_bderror, sqlcode);
      return;
  END;

  -- **************************************************************************************************
  -- PROCEDIMIENTO:     getRegistroEmp
  -- DESCRIPTION:       Trae los registros que pertenezcan a una solicitud especifica
  -- **************************************************************************************************
  PROCEDURE getRegistroEmp(p_idSolicitud  in sel_solicitudes_t.id_solicitud%type,
                           p_iocursor     out t_cursor,
                           p_resultnumber out varchar2) IS
  
    e_InvalidSolicitud exception;
    v_bderror varchar(1000);
    c_cursor  t_cursor;
  BEGIN
  
    --validar idsolicitud existe
    if not sel_solicitudes_pkg.isExisteIdSolicitud(p_idSolicitud) then
      raise e_InvalidSolicitud;
    end if;
  
    open c_cursor for
      select r.id_solicitud,
             r.rnc_o_cedula,
             r.razon_social,
             r.nombre_comercial,
             r.cedula,
             c.nombres ||
             decode(c.primer_apellido, null, '', ' ' || c.primer_apellido) ||
             decode(c.segundo_apellido, null, '', ' ' || c.segundo_apellido) Representante_Nombre,
             r.telefono1,
             r.telefono2,
             s.status,
             est.descripcion Descripcion_Status,
             s.operador,
             s.comentarios,
             s.fecha_registro,
             s.fecha_cierre,
             s.fecha_entrega,
             s.ult_usr_modifico,
             u.nombre_usuario ||
             decode(u.apellidos, null, '', ' ' || u.apellidos) Operador_Nombre,
             s.id_tipo_solicitud,
             t.descripcion Tipo_Solicitud
        from sel_registro_emp_t r
        join sel_solicitudes_t s
          on s.id_solicitud = r.id_solicitud
        left join seg_usuario_t u
          on u.id_usuario = s.operador
        join sel_tipos_solicitudes_t t
          on t.id_tipo_solicitud = s.id_tipo_solicitud
        join sre_ciudadanos_t c
          on c.no_documento = r.cedula
         and c.tipo_documento = 'C'
        join sel_status_t est
          on est.id_status = s.status
       where r.id_solicitud = p_idSolicitud;
  
    p_iocursor     := c_cursor;
    p_resultnumber := 0;
  
  EXCEPTION
  
    when e_InvalidSolicitud then
      p_resultnumber := seg_retornar_cadena_error(181, null, null);
      return;
    
    WHEN OTHERS THEN
      v_bderror      := (substr('error ' || to_char(sqlcode) || ': ' ||
                                sqlerrm,
                                1,
                                255));
      p_resultnumber := seg_retornar_cadena_error(-1, v_bderror, sqlcode);
      return;
  END;

  -- ****************************************************************************
  -- PROCEDIMIENTO: getRecuperacionClave
  -- DESCRIPTION:   Trae los registros que pertenezcan a una solicitud especifica
  -- ****************************************************************************
  PROCEDURE getRecuperacionClave(p_idSolicitud  in sel_solicitudes_t.id_solicitud%type,
                                 p_iocursor     out t_cursor,
                                 p_resultnumber out varchar2) IS
    e_InvalidSolicitud exception;
    v_bderror varchar(1000);
    c_cursor  t_cursor;
  
  BEGIN
  
    --validar si la solicitud existe
    if not sel_solicitudes_pkg.isExisteIdSolicitud(p_idSolicitud) then
      raise e_InvalidSolicitud;
    end if;
  
    open c_cursor for
      select s.status,
             s.rnc_o_cedula,
             s.representante,
             s.operador,
             s.comentarios,
             est.descripcion Descripcion_Status,
             o.nombre_usuario ||
             decode(o.apellidos, null, '', ' ' || o.apellidos) Operador_Nombre,
             c.nombres ||
             decode(c.primer_apellido, null, '', ' ' || c.primer_apellido) ||
             decode(c.segundo_apellido, null, '', ' ' || c.segundo_apellido) Representante_Nombre,
             s.fecha_registro,
             s.fecha_cierre,
             s.fecha_entrega,
             s.ult_usr_modifico,
             s.id_tipo_solicitud,
             t.descripcion Tipo_solicitud,
             e.razon_social,
             e.nombre_comercial
        from sel_solicitudes_t s
        left join seg_usuario_t o
          on o.id_usuario = s.operador
        left join sre_ciudadanos_t c
          on c.no_documento = s.representante
         and c.tipo_documento = 'C'
        join sel_tipos_solicitudes_t t
          on t.id_tipo_solicitud = s.id_tipo_solicitud
        join sre_empleadores_t e
          on e.rnc_o_cedula = s.rnc_o_cedula
        join sel_status_t est
          on est.id_status = s.status
       where s.id_solicitud = p_idSolicitud;
  
    p_iocursor     := c_cursor;
    p_resultnumber := 0;
  
  EXCEPTION
  
    when e_InvalidSolicitud then
      p_resultnumber := seg_retornar_cadena_error(181, null, null);
      return;
    
    WHEN OTHERS THEN
      v_bderror      := (substr('error ' || to_char(sqlcode) || ': ' ||
                                sqlerrm,
                                1,
                                255));
      p_resultnumber := seg_retornar_cadena_error(-1, v_bderror, sqlcode);
      return;
  END;

  -- **************************************************************************************************
  -- PROCEDIMIENTO:     getEstCuentaViaFax
  -- DESCRIPTION:       Trae los registros que pertenezcan a una solicitud especifica
  -- **************************************************************************************************
  PROCEDURE getEstadoCuentaViaFax(p_idSolicitud  in sel_solicitudes_t.id_solicitud%type,
                                  p_iocursor     out t_cursor,
                                  p_resultnumber out varchar2) IS
    e_InvalidSolicitud exception;
    v_bderror varchar(1000);
    c_cursor  t_cursor;
  
  BEGIN
  
    --validar si la solicitud existe
    if not sel_solicitudes_pkg.isExisteIdSolicitud(p_idSolicitud) then
      raise e_InvalidSolicitud;
    end if;
  
    open c_cursor for
      select s.status,
             s.rnc_o_cedula,
             s.representante,
             s.operador,
             s.comentarios,
             est.descripcion Descripcion_Status,
             ope.nombre_usuario ||
             decode(ope.apellidos, null, '', ' ' || ope.apellidos) Operador_Nombre,
             ciu.nombres ||
             decode(ciu.primer_apellido,
                    null,
                    '',
                    ' ' || ciu.primer_apellido) ||
             decode(ciu.segundo_apellido,
                    null,
                    '',
                    ' ' || ciu.segundo_apellido) Representante_Nombre,
             s.fecha_registro,
             s.fecha_cierre,
             s.fecha_entrega,
             s.ult_usr_modifico,
             s.id_tipo_solicitud,
             t.descripcion Tipo_solicitud,
             emp.fax,
             emp.razon_social,
             emp.nombre_comercial
        from sel_solicitudes_t s
        left join seg_usuario_t ope
          on ope.id_usuario = s.operador
        left join sre_ciudadanos_t ciu
          on ciu.no_documento = s.representante
         and ciu.tipo_documento = 'C'
        join sel_tipos_solicitudes_t t
          on t.id_tipo_solicitud = s.id_tipo_solicitud
        join sre_empleadores_t emp
          on emp.rnc_o_cedula = s.rnc_o_cedula
        join sel_status_t est
          on est.id_status = s.status
       where s.id_solicitud = p_idSolicitud;
  
    p_iocursor     := c_cursor;
    p_resultnumber := 0;
  
  EXCEPTION
  
    when e_InvalidSolicitud then
      p_resultnumber := seg_retornar_cadena_error(181, null, null);
      return;
    
    WHEN OTHERS THEN
      v_bderror      := (substr('error ' || to_char(sqlcode) || ': ' ||
                                sqlerrm,
                                1,
                                255));
      p_resultnumber := seg_retornar_cadena_error(-1, v_bderror, sqlcode);
      return;
  END;

  -- **************************************************************************************************
  -- PROCEDIMIENTO:     getEstCuentaViaEmail
  -- DESCRIPTION:       Trae los registros que pertenezcan a una solicitud especifica
  -- **************************************************************************************************
  PROCEDURE getEnvioFacturasEmail(p_idSolicitud  in sel_solicitudes_t.id_solicitud%type,
                                  p_iocursor     out t_cursor,
                                  p_resultnumber out varchar2) IS
    e_InvalidSolicitud exception;
    v_bderror varchar(1000);
    c_cursor  t_cursor;
  
  BEGIN
  
    --validar si la solicitud existe
    if not sel_solicitudes_pkg.isExisteIdSolicitud(p_idSolicitud) then
      raise e_InvalidSolicitud;
    end if;
  
    open c_cursor for
      select s.status,
             s.rnc_o_cedula,
             s.representante,
             s.operador,
             s.comentarios,
             est.descripcion Descripcion_Status,
             ope.nombre_usuario ||
             decode(ope.apellidos, null, '', ' ' || ope.apellidos) Operador_Nombre,
             c.nombres ||
             decode(c.primer_apellido, null, '', ' ' || c.primer_apellido) ||
             decode(c.segundo_apellido, null, '', ' ' || c.segundo_apellido) Representante_Nombre,
             s.fecha_registro,
             s.fecha_cierre,
             s.fecha_entrega,
             s.ult_usr_modifico,
             s.id_tipo_solicitud,
             t.descripcion Tipo_Solicitud,
             emp.email,
             emp.razon_social,
             emp.nombre_comercial
        from sel_solicitudes_t s
        left join seg_usuario_t ope
          on ope.id_usuario = s.operador
        left join sre_ciudadanos_t c
          on c.no_documento = s.representante
         and c.tipo_documento = 'C'
        join sel_tipos_solicitudes_t t
          on t.id_tipo_solicitud = s.id_tipo_solicitud
        join sre_empleadores_t emp
          on emp.rnc_o_cedula = s.rnc_o_cedula
        join sel_status_t est
          on est.id_status = s.status
       where s.id_solicitud = p_idSolicitud;
  
    p_iocursor     := c_cursor;
    p_resultnumber := 0;
  
  EXCEPTION
  
    when e_InvalidSolicitud then
      p_resultnumber := seg_retornar_cadena_error(181, null, null);
      return;
    
    WHEN OTHERS THEN
      v_bderror      := (substr('error ' || to_char(sqlcode) || ': ' ||
                                sqlerrm,
                                1,
                                255));
      p_resultnumber := seg_retornar_cadena_error(-1, v_bderror, sqlcode);
      return;
  END;

  -- ****************************************************************************************************
  -- PROCEDIMIENTO:     getNombreCiudadano
  -- DESCRIPTION:       Devuelve el nombre completo del ciudadano basado en el tipo y numero de documento
  --                    dependiendo de los parametros que se le pasen.
  --FECHA : 01/06/2015
  -- By: Kerlin de la cruz
  -- ****************************************************************************************************
  PROCEDURE getNombreCiudadano(p_tipo         in sre_ciudadanos_t.tipo_documento%type,
                               p_documento    in sre_ciudadanos_t.no_documento%type,
                               p_resultnumber out varchar2) IS
    e_InvalidTipo exception;
    v_bderror varchar(1000);
  BEGIN
    if p_tipo not in ('C', 'P') then
      raise e_InvalidTipo;
    end if;
  
    Select c.nombres || ' ' || nvl(c.primer_apellido, '') || ' ' ||
           nvl(c.segundo_apellido, '')
      into p_resultnumber
      From sre_ciudadanos_t c
     Where c.tipo_documento = p_tipo
       and c.no_documento = p_documento;
  
  EXCEPTION
    when e_InvalidTipo then
      p_resultnumber := seg_retornar_cadena_error(101, null, null);
      return;
    
    when no_data_found then
      p_resultnumber := seg_retornar_cadena_error(104, null, null);
      return;
    
    WHEN OTHERS THEN
      v_bderror      := (substr('error ' || to_char(sqlcode) || ': ' ||
                                sqlerrm,
                                1,
                                255));
      p_resultnumber := seg_retornar_cadena_error(-1, v_bderror, sqlcode);
      return;
  END;

  -- ****************************************************************************************************
  -- PROCEDIMIENTO:     getInformacion
  -- DESCRIPTION:       Devuelve un registro de la tabla sel_informacion_t y numero de documento
  --                    basado en el id de la solicitud
  -- ****************************************************************************************************
  PROCEDURE getInformacion(p_idSolicitud  in sel_solicitudes_t.id_solicitud%type,
                           p_iocursor     out t_cursor,
                           p_resultnumber out varchar2) IS
    e_InvalidSolicitud exception;
    v_bderror varchar(1000);
    c_cursor  t_cursor;
  
  BEGIN
  
    --validar si la solicitud existe
    if not sel_solicitudes_pkg.isExisteIdSolicitud(p_idSolicitud) then
      raise e_InvalidSolicitud;
    end if;
  
    open c_cursor for
    /*select i.id_solicitud,i.nombre_completo,i.nro_documento,i.direccion,i.telefono,
                                                         i.celular,i.email,i.institucion,i.cargo,i.informacion,i.motivo,i.autoridad,
                                                         i.medio,i.lugar,
                                                         s.status,
                                                         est.descripcion Descripcion_Status,
                                                         s.operador,
                                                         u.nombre_usuario ||
                                                         decode(u.apellidos, null, '', ' ' || u.apellidos) Operador_Nombre,
                                                         c.nombres ||
                                                         decode(c.primer_apellido, null, '', ' ' || c.primer_apellido) ||
                                                         decode(c.segundo_apellido, null, '', ' ' || c.segundo_apellido) Solicitante,
                                                         s.comentarios,
                                                         s.fecha_registro,
                                                         s.fecha_cierre,
                                                         s.fecha_entrega,
                                                         s.ult_usr_modifico,
                                                         s.id_tipo_solicitud,
                                                         t.descripcion Tipo_Solicitud
                                                    from sel_informacion_t i
                                                    join sel_solicitudes_t s
                                                      on s.id_solicitud = i.id_solicitud
                                                    left join seg_usuario_t u
                                                      on u.id_usuario = s.operador
                                                    join sel_tipos_solicitudes_t t
                                                      on t.id_tipo_solicitud = s.id_tipo_solicitud
                                                    join sre_ciudadanos_t c
                                                      on c.no_documento = i.nro_documento
                                                     and c.tipo_documento = 'C'
                                                    join sel_status_t est
                                                      on est.id_status = s.status
                                                   where i.id_solicitud = p_idSolicitud;*/
      select i.id_solicitud,
             i.nombre_completo,
             i.nro_documento,
             i.direccion,
             i.telefono,
             i.celular,
             i.fax,
             i.email,
             i.institucion,
             i.cargo,
             i.informacion,
             i.motivo,
             i.autoridad,
             i.medio,
             i.lugar,
             s.status,
             est.descripcion Descripcion_Status,
             s.operador,
             u.nombre_usuario ||
             decode(u.apellidos, null, '', ' ' || u.apellidos) Operador_Nombre,
             initcap(nvl(c.nombres ||
                         decode(c.primer_apellido,
                                null,
                                '',
                                ' ' || c.primer_apellido) ||
                         decode(c.segundo_apellido,
                                null,
                                '',
                                ' ' || c.segundo_apellido),
                         i.nombre_completo)) Solicitante,
             s.comentarios,
             s.fecha_registro,
             s.fecha_cierre,
             s.fecha_entrega,
             s.ult_usr_modifico,
             s.id_tipo_solicitud,
             t.descripcion Tipo_Solicitud
        from sel_informacion_t i
        join sel_solicitudes_t s
          on s.id_solicitud = i.id_solicitud
        left join seg_usuario_t u
          on u.id_usuario = s.operador
        join sel_tipos_solicitudes_t t
          on t.id_tipo_solicitud = s.id_tipo_solicitud
        left join sre_ciudadanos_t c
          on c.no_documento = i.nro_documento
      --and c.tipo_documento = 'C'
        join sel_status_t est
          on est.id_status = s.status
       where i.id_solicitud = p_idSolicitud;
    p_iocursor     := c_cursor;
    p_resultnumber := 0;
  
  EXCEPTION
  
    when e_InvalidSolicitud then
      p_resultnumber := seg_retornar_cadena_error(181, null, null);
      return;
    
    WHEN OTHERS THEN
      v_bderror      := (substr('error ' || to_char(sqlcode) || ': ' ||
                                sqlerrm,
                                1,
                                255));
      p_resultnumber := seg_retornar_cadena_error(-1, v_bderror, sqlcode);
      return;
  END;

  -- ****************************************************************************************************
  -- PROCEDIMIENTO:     getInformacionGral
  -- DESCRIPTION:       Devuelve un registro de la tabla sel_informacion_grl_t y numero de documento
  --                    basado en el id de la solicitud
  -- ****************************************************************************************************
  PROCEDURE getInformacionGral(p_idSolicitud  in sel_solicitudes_t.id_solicitud%type,
                               p_iocursor     out t_cursor,
                               p_resultnumber out varchar2) IS
    e_InvalidSolicitud exception;
    v_bderror varchar(1000);
    c_cursor  t_cursor;
  
  BEGIN
  
    --validar si la solicitud existe
    if not sel_solicitudes_pkg.isExisteIdSolicitud(p_idSolicitud) then
      raise e_InvalidSolicitud;
    end if;
  
    open c_cursor for
      select i.id_solicitud,
             i.informacion as motivo,
             s.comentarios,
             i.telefono1,
             i.telefono2,
             s.status,
             est.descripcion Descripcion_Status,
             s.operador,
             u.nombre_usuario ||
             decode(u.apellidos, null, '', ' ' || u.apellidos) Operador_Nombre,
             s.representante,
             ciu.nombres ||
             decode(ciu.primer_apellido,
                    null,
                    '',
                    ' ' || ciu.primer_apellido) ||
             decode(ciu.segundo_apellido,
                    null,
                    '',
                    ' ' || ciu.segundo_apellido) Representante_Nombre,
             s.fecha_registro,
             s.fecha_cierre,
             s.fecha_entrega,
             s.ult_usr_modifico,
             s.id_tipo_solicitud,
             t.descripcion Tipo_Solicitud,
             e.razon_social,
             e.nombre_comercial,
             s.representante
        from sel_informacion_grl_t i
        join sel_solicitudes_t s
          on s.id_solicitud = i.id_solicitud
        left join seg_usuario_t u
          on u.id_usuario = s.operador
        join sel_tipos_solicitudes_t t
          on t.id_tipo_solicitud = s.id_tipo_solicitud
        join sel_status_t est
          on est.id_status = s.status
        join sre_empleadores_t e
          on e.rnc_o_cedula = s.rnc_o_cedula
        left join sre_ciudadanos_t ciu
          on ciu.no_documento = s.representante
         and ciu.tipo_documento = 'C'
       where i.id_solicitud = p_idSolicitud;
  
    p_iocursor     := c_cursor;
    p_resultnumber := 0;
  
  EXCEPTION
  
    when e_InvalidSolicitud then
      p_resultnumber := seg_retornar_cadena_error(181, null, null);
      return;
    
    WHEN OTHERS THEN
      v_bderror      := (substr('error ' || to_char(sqlcode) || ': ' ||
                                sqlerrm,
                                1,
                                255));
      p_resultnumber := seg_retornar_cadena_error(-1, v_bderror, sqlcode);
      return;
  END;

  -- ****************************************************************************************************
  -- PROCEDIMIENTO:     getStatus
  -- DESCRIPTION:       Devuelve el contenido de la tabla sel_status_t como un dataset
  -- ****************************************************************************************************
  PROCEDURE getStatus(p_iocursor out t_cursor) IS
    c_cursor t_cursor;
  BEGIN
    open c_cursor for
      select s.id_status, s.descripcion from sel_status_t s;
  
    p_iocursor := c_cursor;
  END;

  -- ****************************************************************************************************
  -- PROCEDIMIENTO:     getOficinas
  -- DESCRIPTION:       Devuelve el contenido de la tabla sel_oficinas_t como un dataset
  -- ****************************************************************************************************
  PROCEDURE getOficinas(p_iocursor out t_cursor) IS
    c_cursor t_cursor;
  BEGIN
    open c_cursor for
      select o.id_oficina,
             o.descripcion,
             o.nombre_resp_firma,
             o.puesto_resp_firma,
             o.email
        from sel_oficinas_t o;
  
    p_iocursor := c_cursor;
  END;

  -- **************************************************************************************************
  -- PROCEDIMIENTO: EstadoCuentaEmail
  -- DESCRIPCION:   Genera un estado de cuenta y lo envia a un email especificado
  -- **************************************************************************************************
  procedure EstadoCuentaEmail(p_rnc          in sre_empleadores_t.rnc_o_cedula%type,
                              p_cedula       in sre_ciudadanos_t.no_documento%type,
                              p_email        in sre_empleadores_t.email%type,
                              p_resultnumber out varchar2)
  
   is
  
    --variables
    v_html clob;
  
    v_rnc             varchar2(20);
    v_RazonSocial     varchar2(250);
    v_NombreComercial varchar2(250);
    v_IdReferencia    varchar2(50);
    v_Periodo         varchar2(15);
    v_Concepto        varchar2(250);
    v_FechaLimite     varchar2(20);
    v_SubTotal        number;
    v_SubTotal2       varchar2(50);
    v_Total           number;
    v_Total2          varchar2(50);
    e_rnc_o_cedula exception;
    v_bderror       varchar(1000);
    v_Representante varchar2(150);
  
    PROCEDURE ADD(TEXTO IN VARCHAR2) AS
    BEGIN
      dbms_lob.writeAppend(v_html, length(texto), texto);
    END;
  
  begin
  
    if (p_email is not null) and (p_rnc is not null) and
       (p_cedula is not null) then
    
      dbms_lob.createtemporary(v_html, TRUE);
      dbms_lob.open(v_html, dbms_lob.lob_readwrite);
    
      v_rnc             := null;
      v_RazonSocial     := null;
      v_NombreComercial := null;
      v_IdReferencia    := null;
      v_Periodo         := null;
      v_Concepto        := null;
      v_FechaLimite     := null;
      v_SubTotal        := null;
      v_Total           := null;
      v_Total2          := null;
      v_Representante   := null;
    
      --buscamos el nombre completo del ciudadano
      select c.nombres || ' ' || nvl(c.primer_apellido, '') || ' ' ||
             nvl(c.segundo_apellido, '')
        into v_Representante
        from sre_ciudadanos_t c
       where c.no_documento = p_cedula
         and c.tipo_documento = 'C';
    
      for i in (select e.rnc_o_cedula, e.razon_social, e.nombre_comercial
                  from sre_empleadores_t e
                 where e.rnc_o_cedula = p_rnc) loop
      
        v_rnc             := null;
        v_RazonSocial     := null;
        v_NombreComercial := null;
      
        v_rnc             := i.rnc_o_cedula;
        v_RazonSocial     := i.razon_social;
        v_NombreComercial := i.nombre_comercial;
      
        add('

        <html>
        <head>
        <th>Sr.(a), ' || v_Representante ||
            ', en atenci;n a su solicitud realizada a la Tesorer;a de la Seguridad Social, remitimos su estado de cuenta en formato electr;nico.
            Cualquier inquietud, por favor remita un correo a info@tss.gov.do
        </th>
        <br />
          <h4 align="left">' || 'RNC: ' || v_rnc ||
            '</h4>
          <h4 align="left">' || 'Raz;n Social: ' ||
            v_RazonSocial || '</h4>
          <h4 align="left">' || 'Nombre Comercial: ' ||
            v_NombreComercial || '</h4>

          <style type="text/css">
          td {font-family: verdana,helvetica, impact, sans-serif;
             font-size: 9pt; color: "black";
            }
          h4{font-family: verdana,helvetica, impact, sans-serif;
             font-size: 9pt; color: "black";
            }

             th{font-family: verdana,helvetica, impact, sans-serif;
             font-size: 9pt; color: "black";
            }
          </style>

           <table border= 0 width="600" cellpading="0" cellspacing="0">
                <tr>
                <td>
      ');
      
        --ESTADO CUENTA TSS
        add(' <table>
               <tr>
               <td>
               <th align="left">DEUDA CON LA TSS</th>
               </td>
               </tr>
               </table>
               <table border=1 width="100%" cellpading="0" cellspacing="0">

                <tr bgcolor = "Silver">
                <th BGCOLOR="#99CCFF" align="center">Per;odo</th>
                <th BGCOLOR="#99CCFF" align="center">Referencia</th>
                <th BGCOLOR="#99CCFF" align="center">N;mina</th>
                <th BGCOLOR="#99CCFF" align="center">Monto</th>


                </tr>');
      
        --TSS
        for j in (SELECT SUBSTR(f.ID_REFERENCIA, 1, 4) || '-' ||
                         SUBSTR(f.ID_REFERENCIA, 5, 4) || '-' ||
                         SUBSTR(f.ID_REFERENCIA, 9, 4) || '-' ||
                         SUBSTR(f.ID_REFERENCIA, 13, 4) id_referencia,
                         f.id_nomina as id_nomina,
                         Srp_Pkg.ProperCase(n.nomina_des) nomina_des,
                         Srp_Pkg.FORMATEAPERIODO(f.periodo_factura) periodo_factura,
                         f.total_general_factura total_general,
                         e.razon_social,
                         e.rnc_o_cedula
                    FROM sfc_facturas_v    f,
                         SRE_EMPLEADORES_T e,
                         SRE_NOMINAS_T     n
                   WHERE e.RNC_O_CEDULA = p_RNC
                     AND f.id_registro_patronal = e.id_registro_patronal
                     AND f.id_registro_patronal = n.id_registro_patronal
                     AND f.id_nomina = n.id_nomina
                     and f.STATUS in ('VE', 'VI')
                     and f.NO_AUTORIZACION is null
                  
                   ORDER BY f.periodo_factura asc, f.id_nomina)
        
         loop
        
          v_Periodo      := null;
          v_IdReferencia := null;
          v_Concepto     := null;
          v_SubTotal     := null;
          v_SubTotal2    := null;
        
          --llenar variables para el detalle del estado de cuenta
        
          v_Periodo      := j.periodo_factura;
          v_IdReferencia := j.id_referencia;
          v_Concepto     := j.nomina_des;
          v_SubTotal     := j.total_general;
        
          v_SubTotal2 := trim(to_char(v_SubTotal, '999,999,999,999.99'));
        
          if v_SubTotal2 is null then
            v_SubTotal2 := '0.00';
          end if;
        
          --INSERTAR VALORES AL REPORTE--
          add('
                     <tr>
                        <td align="center" width="150">' ||
              v_Periodo ||
              '</td>

                        <td align="center" width="400">' ||
              v_IdReferencia ||
              '</td>

                        <td align="left" width="600">' ||
              INITCAP(v_Concepto) ||
              '</td>

                        <td align="right" width="150">' ||
              v_SubTotal2 || '</td>

                       </tr>');
        
        end loop; --j
      
        v_Total  := 0.00;
        v_Total2 := '0.00';
      
        --buscando el total general
        select sum(f.TOTAL_GENERAL_FACTURA)
          into v_Total
          from sfc_facturas_v f, sre_empleadores_t e
         where e.id_registro_patronal = f.id_registro_patronal
           and f.STATUS in ('VE', 'VI')
           and e.rnc_o_cedula = i.rnc_o_cedula
           and f.NO_AUTORIZACION is null;
        v_Total2 := trim(to_char(v_Total, '999,999,999,999.99'));
      
        if v_Total2 is null then
          v_Total2 := '0.00';
        end if;
        --agregamos la sumatoria al archivo
        add('<tr>

                       <td align="right" colspan="3"><b>' ||
            'Total: ' ||
            '</b></td>
                       <td align="right"width="150"><b>' ||
            v_Total2 || '</b></td>
                       </tr>

                    </table>
                       ');
      
        --ESTADO CUENTA ISR
      
        add('
                <br />
                <table>
                <tr>
                <td>
                <th align="left">DEUDA CON DGII POR CONCEPTO DE RETENCION A ASALARIADOS</th>
                </td>
                </tr>
                </table>

                <table border=1 width="100%" cellpading="0" cellspacing="0">
                <tr bgcolor = "Silver">
                <th BGCOLOR="#99CCFF" align="center">Per;odo</th>
                <th BGCOLOR="#99CCFF" align="center">Referencia</th>
                <th BGCOLOR="#99CCFF" align="center">Concepto</th>
                <th BGCOLOR="#99CCFF" align="center">Monto</th>


                </tr>');
      
        --ISR
        for k in (SELECT SUBSTR(l.ID_REFERENCIA_ISR, 1, 4) || '-' ||
                         SUBSTR(l.ID_REFERENCIA_ISR, 5, 4) || '-' ||
                         SUBSTR(l.ID_REFERENCIA_ISR, 9, 4) || '-' ||
                         SUBSTR(l.ID_REFERENCIA_ISR, 13, 4) id_referencia,
                         l.id_nomina as id_nomina,
                         'Liquidacion ISR' nomina_des,
                         Srp_Pkg.FORMATEAPERIODO(l.periodo_liquidacion) periodo_factura,
                         l.TOTAL_A_PAGAR total_general,
                         e.razon_social,
                         e.rnc_o_cedula
                    FROM sfc_liquidacion_isr_v l,
                         SRE_EMPLEADORES_T     e,
                         SRE_NOMINAS_T         n
                   WHERE e.RNC_O_CEDULA = p_RNC
                     AND l.id_registro_patronal = e.id_registro_patronal
                     AND l.id_registro_patronal = n.id_registro_patronal
                     AND l.id_nomina = n.id_nomina
                     AND l.STATUS in ('VE', 'VI')
                     and l.NO_AUTORIZACION is null
                   ORDER BY l.periodo_liquidacion asc, l.id_nomina)
        
         loop
        
          v_Periodo      := null;
          v_IdReferencia := null;
          v_Concepto     := null;
          v_SubTotal     := null;
          v_SubTotal2    := null;
        
          --llenar variables para el detalle del estado de cuenta
        
          v_Periodo      := k.periodo_factura;
          v_IdReferencia := k.id_referencia;
          v_Concepto     := k.nomina_des;
          v_SubTotal     := k.total_general;
        
          v_SubTotal2 := trim(to_char(v_SubTotal, '999,999,999,999.99'));
        
          if v_SubTotal2 is null then
            v_SubTotal2 := '0.00';
          end if;
        
          --INSERTAR VALORES AL REPORTE--
          add('
                     <tr>
                        <td align="center" width="150">' ||
              v_Periodo ||
              '</td>

                        <td align="center" width="400">' ||
              v_IdReferencia ||
              '</td>

                        <td align="left" width="600">' ||
              INITCAP(v_Concepto) ||
              '</td>

                        <td align="right" width="150">' ||
              v_SubTotal2 || '</td>

                       </tr>');
        
        end loop; --k
      
        v_Total  := 0.00;
        v_Total2 := '0.00';
      
        --buscando el total general
        select sum(liq.TOTAL_A_PAGAR)
          into v_Total
          from sfc_liquidacion_isr_v liq, sre_empleadores_t e
         where e.id_registro_patronal = liq.ID_REGISTRO_PATRONAL
           and liq.STATUS in ('VE', 'VI')
           and e.rnc_o_cedula = i.rnc_o_cedula
           and liq.NO_AUTORIZACION is null;
        v_Total2 := trim(to_char(v_Total, '999,999,999,999.99'));
      
        if v_Total2 is null then
          v_Total2 := '0.00';
        end if;
        --agregamos la sumatoria al archivo
        add('<tr>

                       <td align="right" colspan="3"><b>' ||
            'Total: ' ||
            '</b></td>
                       <td align="right"width="150"><b>' ||
            v_Total2 || '</b></td>
                       </tr>

                    </table>
                       ');
      
        --ESTADO CUENTA IR17
      
        add(' <br />

                <table>
                <tr>
                <td>
                <th align="left">DEUDA CON DGII POR CONCEPTO DE OTRAS RETENCIONES</th>
                </td>
                </tr>
                </table>

                <table border=1 width="100%" cellpading="0" cellspacing="0">
                <tr bgcolor = "Silver">
                <th BGCOLOR="#99CCFF" align="center">Per;odo</th>
                <th BGCOLOR="#99CCFF" align="center">Referencia</th>

                <th BGCOLOR="#99CCFF" align="center">Monto</th>


                </tr>');
      
        --IR17
        for l in (SELECT SUBSTR(li.ID_REFERENCIA_IR17, 1, 4) || '-' ||
                         SUBSTR(li.ID_REFERENCIA_IR17, 5, 4) || '-' ||
                         SUBSTR(li.ID_REFERENCIA_IR17, 9, 4) || '-' ||
                         SUBSTR(li.ID_REFERENCIA_IR17, 13, 4) id_referencia,
                         Srp_Pkg.FORMATEAPERIODO(li.PERIODO_LIQUIDACION) periodo_factura,
                         li.LIQUIDACION total_general,
                         e.razon_social /*, N.ID_NOMINA as id_nomina, ' ' Nomina_des*/,
                         e.rnc_o_cedula
                    FROM sfc_liquidacion_ir17_v li, SRE_EMPLEADORES_T e --, SRE_NOMINAS_T n
                   WHERE e.RNC_O_CEDULA = p_RNC
                        --AND N.ID_REGISTRO_PATRONAL= E.ID_REGISTRO_PATRONAL
                     AND li.ID_REGISTRO_PATRONAL = e.id_registro_patronal
                     AND li.STATUS in ('VE', 'VI')
                     and li.NO_AUTORIZACION is null
                   ORDER BY li.PERIODO_LIQUIDACION asc --, N.ID_NOMINA
                  )
        
         loop
        
          v_Periodo      := null;
          v_IdReferencia := null;
          -- v_Concepto           := null;
          v_SubTotal  := null;
          v_SubTotal2 := null;
        
          --llenar variables para el detalle del estado de cuenta
        
          v_Periodo      := l.periodo_factura;
          v_IdReferencia := l.id_referencia;
          --v_Concepto           := l.nomina_des;
          v_SubTotal := l.total_general;
        
          v_SubTotal2 := trim(to_char(v_SubTotal, '999,999,999,999.99'));
        
          if v_SubTotal2 is null then
            v_SubTotal2 := '0.00';
          end if;
        
          --INSERTAR VALORES AL REPORTE--
          add('
                     <tr>
                        <td align="center" width="150">' ||
              v_Periodo ||
              '</td>

                        <td align="center" width="400">' ||
              v_IdReferencia ||
              '</td>



                        <td align="right" width="150">' ||
              v_SubTotal2 || '</td>

                       </tr>');
        
        end loop; --l
      
        v_Total  := 0.00;
        v_Total2 := '0.00';
      
        --buscando el total general
        select sum(ir.LIQUIDACION)
          into v_Total
          from sfc_liquidacion_ir17_v ir, sre_empleadores_t e
         where e.id_registro_patronal = ir.id_registro_patronal
           and ir.STATUS in ('VE', 'VI')
           and e.rnc_o_cedula = i.rnc_o_cedula
           and ir.NO_AUTORIZACION is null;
      
        v_Total2 := trim(to_char(v_Total, '999,999,999,999.99'));
      
        if v_Total2 is null then
          v_Total2 := '0.00';
        end if;
        --agregamos la sumatoria al archivo
        add('<tr>

                       <td align="right" colspan="2"><b>' ||
            'Total: ' ||
            '</b></td>
                       <td align="right"width="150"><b>' ||
            v_Total2 || '</b></td>
                       </tr>
                       </table>
            </td>
           </tr>
          </table>
          </body>
          </html>');
      
      end loop; --i
    
      -- ------------------------------
      system.html_mail('info@mail.tss2.gov.do',
                       p_email,
                       'Estado de Cuenta',
                       v_html);
      dbms_lob.freetemporary(v_html);
    
      p_resultnumber := 0;
    
    else
      p_resultnumber := 'El RNC y el email son requeridos';
    end if;
  
  EXCEPTION
    when e_rnc_o_cedula then
      p_resultnumber := seg_retornar_cadena_error(150, null, null);
      return;
    
    WHEN OTHERS THEN
      v_bderror      := (substr('error ' || to_char(sqlcode) || ': ' ||
                                sqlerrm,
                                1,
                                255));
      p_resultnumber := seg_retornar_cadena_error(-1, v_bderror, sqlcode);
      return;
    
  end EstadoCuentaEmail;

  -- **************************************************************************************************
  -- PROCEDIMIENTO:     IsRncRegistrado
  -- DESCRIPTION:       recibe un rnc_cedula y devuelve 1 si existe y 0 si no existe
  -- **************************************************************************************************
  PROCEDURE IsRncRegistrado(p_rnc_o_cedula in SRE_EMPLEADORES_T.Rnc_o_Cedula%type,
                            p_resultnumber out varchar2) IS
    --returnValue BOOLEAN;
    v_RncOCedula varchar(11);
    v_bderror    varchar(1000);
  
    CURSOR c_IsRncRegistrado IS
      SELECT e.rnc_o_cedula
        FROM SRE_EMPLEADORES_T e
       WHERE e.rnc_o_cedula = p_rnc_o_cedula
         and e.status = 'A';
  
  BEGIN
  
    OPEN c_IsRncRegistrado;
    FETCH c_IsRncRegistrado
      INTO v_RncOCedula;
    --returnValue := c_IsRncRegistrado%FOUND;
    CLOSE c_IsRncRegistrado;
  
    if v_RncOCedula is not null then
      p_resultnumber := 1;
    else
      p_resultnumber := 0;
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
  -- PROCEDIMIENTO:     sRepresentanteEnEmpresa
  -- DESCRIPTION:       recibe el rnc del empleador y la cedula del representante para:
  --                    validar que el empleador exista y que este activo y que el representante
  --                    corresponda al empleador y que tambien este activo
  -- **************************************************************************************************
  PROCEDURE IsRepresentanteEnEmpresa(p_rnc          in SRE_EMPLEADORES_T.Rnc_o_Cedula%type,
                                     p_cedula       in SRE_CIUDADANOS_T.No_documento%type,
                                     p_resultnumber out varchar2) IS
    e_rnc_empleador         exception;
    e_estatus_empleador     exception;
    e_ciudadanos            exception;
    e_cedula_representante  exception;
    e_estatus_representante exception;
  
    v_estatusEmpleador     SRE_EMPLEADORES_T.STATUS%type;
    v_idregistro           SRE_EMPLEADORES_T.Id_Registro_Patronal%type;
    v_idNssCiudadanos      SRE_CIUDADANOS_T.ID_NSS%type;
    v_estatusRepresentante SRE_REPRESENTANTES_T.STATUS%type;
    v_idNssRepresentante   SRE_REPRESENTANTES_T.ID_NSS%type;
  
    cursor c_Empleador is
      select e.status, e.id_registro_patronal
        from sre_empleadores_t e
       where e.rnc_o_cedula = p_rnc;
  
    cursor c_Ciudadanos is
      select c.id_nss
        from sre_ciudadanos_t c
       where c.no_documento = p_cedula
         and c.tipo_documento = 'C';
  
    cursor c_Representantes is
      select r.id_nss, r.status
        from sre_representantes_t r
       where r.id_nss = v_idNssCiudadanos
         and r.id_registro_patronal = v_idregistro;
  
    v_bderror varchar(1000);
  
  BEGIN
    open c_Empleador;
    fetch c_Empleador
      into v_estatusEmpleador, v_idregistro;
    close c_Empleador;
  
    /*Empleador no Existe*/
    if v_idRegistro is null then
      p_resultnumber := 0;
      raise e_rnc_empleador;
    end if;
  
    /*Empleador de baja*/
    if v_estatusEmpleador <> 'A' then
      p_resultnumber := 0;
      return;
      --            raise e_estatus_empleador;
    end if;
  
    open c_Ciudadanos;
    fetch c_Ciudadanos
      into v_idNssCiudadanos;
    close c_Ciudadanos;
  
    /*Ciudadano no Existe*/
    if v_idNssCiudadanos is null then
      p_resultnumber := 0;
      raise e_ciudadanos;
    end if;
  
    open c_Representantes;
    fetch c_Representantes
      into v_idNssRepresentante, v_estatusRepresentante;
    close c_Representantes;
  
    /*Representante no Existe para ese empleador*/
    if v_idNssRepresentante is null then
      p_resultnumber := 0;
      raise e_cedula_Representante;
    end if;
  
    /*Representante inactivo*/
    if v_estatusRepresentante <> 'A' then
      p_resultnumber := 0;
      return;
      --            raise e_estatus_Representante;
    end if;
  
    p_resultnumber := 1;
  
  EXCEPTION
    WHEN e_rnc_empleador then
      p_resultnumber := seg_retornar_cadena_error(150, null, null);
      return;
    
    WHEN e_estatus_empleador then
      p_resultnumber := seg_retornar_cadena_error(43, null, null);
      return;
    
    WHEN e_ciudadanos then
      p_resultnumber := seg_retornar_cadena_error(151, null, null);
      return;
    
    WHEN e_cedula_representante then
      p_resultnumber := seg_retornar_cadena_error(154, null, null);
      return;
    
    WHEN e_estatus_representante then
      p_resultnumber := seg_retornar_cadena_error(40, null, null);
      return;
    
    WHEN OTHERS THEN
      v_bderror      := (substr('error ' || to_char(sqlcode) || ': ' ||
                                sqlerrm,
                                1,
                                255));
      p_resultnumber := seg_retornar_cadena_error(-1, v_bderror, sqlcode);
      return;
  END;

  -- **************************************************************************************************
  -- PROCEDIMIENTO:     getRazonSocialEnDGII
  -- DESCRIPTION:       recibe un rnc_cedula, busca y devuelve la razon social de la talba dgi_maestro_empleadores_t
  -- **************************************************************************************************
  PROCEDURE getRazonSocialEnDGII(p_rnc_o_cedula in dgi_maestro_empleadores_t.rnc_cedula%type,
                                 p_resultnumber out varchar2) IS
    --returnValue BOOLEAN;
    e_RazonSocial exception;
    v_RazonSocial varchar(150);
  
    v_bderror varchar(1000);
  
    CURSOR c_IsRazonSocialEnDGII IS
      SELECT e.razon_social
        FROM dgi_maestro_empleadores_t e
       WHERE e.rnc_cedula = p_rnc_o_cedula;
  
  BEGIN
  
    OPEN c_IsRazonSocialEnDGII;
    FETCH c_IsRazonSocialEnDGII
      INTO v_RazonSocial;
    --returnValue := c_IsRazonSocialEnDGII%FOUND;
    CLOSE c_IsRazonSocialEnDGII;
  
    if v_RazonSocial is not null then
      p_resultnumber := v_RazonSocial;
    else
      raise e_RazonSocial;
    end if;
  
  EXCEPTION
  
    when e_RazonSocial then
      p_resultnumber := seg_retornar_cadena_error(179, null, null);
      return;
    
    WHEN OTHERS THEN
      v_bderror      := (substr('error ' || to_char(sqlcode) || ': ' ||
                                sqlerrm,
                                1,
                                255));
      p_resultnumber := seg_retornar_cadena_error(-1, v_bderror, sqlcode);
      return;
  END;

  -- **************************************************************************************************
  -- PROCEDIMIENTO:     IsIdSolicitudValido
  -- DESCRIPTION:       recibe un IdSolicitud y devuelve 1 si existe y 0 si no existe
  -- **************************************************************************************************
  PROCEDURE IsIdSolicitudValido(p_IdSolicitud  in sel_solicitudes_t.id_solicitud%type,
                                p_resultnumber out varchar2) IS
    --returnValue BOOLEAN;
    v_Solicitud number;
    v_bderror   varchar(1000);
  
    CURSOR c_IdSolicitudValido IS
      SELECT s.id_solicitud
        FROM sel_solicitudes_t s
       WHERE s.id_solicitud = p_IdSolicitud;
  
  BEGIN
  
    OPEN c_IdSolicitudValido;
    FETCH c_IdSolicitudValido
      INTO v_Solicitud;
    --returnValue := c_IsRncRegistrado%FOUND;
    CLOSE c_IdSolicitudValido;
  
    if v_Solicitud is not null then
      p_resultnumber := 1;
    else
      p_resultnumber := 0;
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

  ---
  -- **************************************************************************************************
  -- Function:     Function isExisteTipoSolicitud
  -- DESCRIPCION:       Funcion que retorna la existencia de un id_Tipo_Solicitud..
  --                     Recibe : el parametro p_id_Tipo_Solicitud.
  --                     Devuelve: un valor booleano (0,1) . 0 = no existe  1 = existe

  -- **************************************************************************************************
  FUNCTION isExisteTipoSolicitud(p_id_Tipo_Solicitud VARCHAR2) RETURN BOOLEAN
  
   IS
  
    CURSOR c_ExisteTipoSolicitud IS
      SELECT s.id_tipo_solicitud
        FROM sel_tipos_solicitudes_t s
       WHERE s.id_tipo_solicitud = p_id_Tipo_Solicitud;
  
    --variables
    returnvalue       BOOLEAN;
    v_idTipoSolicitud VARCHAR(22);
    --
  BEGIN
    OPEN c_ExisteTipoSolicitud;
    FETCH c_ExisteTipoSolicitud
      INTO v_idTipoSolicitud;
    returnvalue := c_ExisteTipoSolicitud%FOUND;
    CLOSE c_ExisteTipoSolicitud;
  
    RETURN(returnvalue);
  
  END isExisteTipoSolicitud;

  -- **************************************************************************************************
  -- Function:     Function isExisteIdSolicitud
  -- DESCRIPCION:       Funcion que retorna la existencia de un id_Solicitud.
  --                     Recibe : el parametro p_id_Solicitud.
  --                     Devuelve: un valor booleano (0,1) . 0 = no existe  1 = existe

  -- **************************************************************************************************
  function isExisteIdSolicitud(p_IdSolicitud varchar2) return boolean is
    cursor c_ExisteIdSolicitud is
      select s.id_solicitud
        from sel_solicitudes_t s
       where s.id_solicitud = p_IdSolicitud;
  
    --Variables
    returnvalue   Boolean;
    v_IdSolicitud number;
  
  begin
    Open c_ExisteIdSolicitud;
    fetch c_ExisteIdSolicitud
      into v_IdSolicitud;
    returnvalue := c_ExisteIdSolicitud%found;
    close c_ExisteIdSolicitud;
  
    return(returnvalue);
  end isExisteIdSolicitud;

  -- **************************************************************************************************
  -- Function:     Function isExisteOficina
  -- DESCRIPCION:  Valida que exista la oficina
  --               Recibe  : el parametro p_id_oficina.
  --               Devuelve: un valor booleano (true,false). true = existe false = no existe
  -- **************************************************************************************************
  FUNCTION isExisteOficina(p_id_oficina VARCHAR2) RETURN BOOLEAN
  
   IS
  
    CURSOR c_ExisteOficina IS
      SELECT o.id_oficina
        FROM sel_oficinas_t o
       WHERE o.id_oficina = p_id_oficina;
  
    --variables
    returnvalue  BOOLEAN;
    v_id_oficina sel_oficinas_t.id_oficina%type;
  
  BEGIN
    OPEN c_ExisteOficina;
    FETCH c_ExisteOficina
      INTO v_id_oficina;
    returnvalue := c_ExisteOficina%FOUND;
    CLOSE c_ExisteOficina;
  
    RETURN(returnvalue);
  
  END isExisteOficina;

  -- **************************************************************************************************
  -- Function:     getProvinciaDes
  -- DESCRIPCION:  Devuelve el nombre de la provincia a partir del RCN del empleador
  --               Recibe  : el RNC del empleador
  --               Devuelve: varchar2
  -- **************************************************************************************************
  FUNCTION getProvinciaDes(p_rnc VARCHAR2) RETURN varchar2
  
   IS
  
    v_descripcion sre_provincias_t.provincia_des%type;
  
  BEGIN
  
    v_descripcion := '';
    For c in (select p.provincia_des
                From sre_empleadores_t e
                left join sre_municipio_t m
                  on m.id_municipio = e.id_municipio
                left join sre_provincias_t p
                  on p.id_provincia = m.id_provincia
               where e.rnc_o_cedula = p_rnc) Loop
      v_descripcion := c.provincia_des;
    End Loop;
    RETURN v_descripcion;
  
  END getProvinciaDes;

  -- **************************************************************************************************
  -- Function:     getProvinciaID
  -- DESCRIPCION:  Devuelve el ID de la provincia a partir del RCN del empleador
  --               Recibe  : el RNC del empleador
  --               Devuelve: varchar2
  -- **************************************************************************************************
  FUNCTION getProvinciaID(p_rnc VARCHAR2) RETURN varchar2
  
   IS
  
    v_id_provincia sre_provincias_t.id_provincia%type;
  
  BEGIN
  
    v_id_provincia := '';
    For c in (select p.id_provincia
                From sre_empleadores_t e
                left join sre_municipio_t m
                  on m.id_municipio = e.id_municipio
                left join sre_provincias_t p
                  on p.id_provincia = m.id_provincia
               where e.rnc_o_cedula = p_rnc) Loop
      v_id_provincia := c.id_provincia;
    End Loop;
    RETURN v_id_provincia;
  
  END getProvinciaID;

  -- ******************************************************************************************************
  -- PROCEDIMIENTO:     getFirmaResponsable
  -- DESCRIPTION:       Trae la firma y el responsable para un tipo de certificacion especifico
  -- ******************************************************************************************************
  PROCEDURE getFirmaResponsable(p_TipoCertificacion in cer_certificaciones_t.id_tipo_certificacion%type,
                                p_IdUsuario         in cer_certificaciones_t.id_usuario%type,
                                p_Firma             out cer_certificaciones_t.firma%type,
                                p_Responsable       out varchar2,
                                p_resultnumber      out varchar2) IS
  
    v_IdOficina varchar(10);
    v_bderror   varchar(1000);
  
  BEGIN
  
    --Si la firma no es nula entonces traemos la firma y el responsable de la tabla cer_certificaciones_t
  
    if p_TipoCertificacion is not null then
      select t.nombre_resp_firma, t.puesto_resp_firma
        into p_Firma, p_Responsable
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
          into p_Firma, p_Responsable
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
  -- PROCEDIMIENTO:     BorrarSolicitud
  -- DESCRIPTION:       Borra la solicitud especificada en el parametro
  -- ******************************************************************************************************
  PROCEDURE BorrarSolicitud(p_IdSolicitud  in sel_solicitudes_t.id_solicitud%type,
                            p_resultnumber out varchar2) IS
    v_bderror varchar(1000);
  Begin
    Delete From Sel_Solicitudes_t Where id_solicitud = p_IDSolicitud;
    Commit;
    p_resultnumber := 0;
  Exception
    WHEN OTHERS THEN
      v_bderror      := (substr('error ' || to_char(sqlcode) || ': ' ||
                                sqlerrm,
                                1,
                                255));
      p_resultnumber := seg_retornar_cadena_error(-1, v_bderror, sqlcode);
      return;
  End BorrarSolicitud;

  -- ******************************************************************************************************
  -- PROCEDIMIENTO:     getpageSolicitud_RNC
  -- DESCRIPTION:       Muestra las solicitudes por su rnc correspondiente
  -- ******************************************************************************************************
  PROCEDURE getpageSolicitud_RNC(p_rnc_o_cedula in sre_empleadores_t.rnc_o_cedula%type,
                                 p_pagenum      in number,
                                 p_pagesize     in number,
                                 p_iocursor     out t_cursor,
                                 p_resultnumber out varchar2) IS
    e_rnc_o_cedula exception;
    v_bderror varchar(1000);
    vDesde    integer := (p_pagesize * (p_pagenum - 1)) + 1;
    vhasta    integer := p_pagesize * p_pagenum;
  
  BEGIN
  
    if not suirplus.sre_empleadores_pkg.isRncOCedulaValida(p_rnc_o_cedula) then
      raise e_rnc_o_cedula;
    end if;
  
    open p_iocursor for
      with x as
       (select rownum num, y.*
          from (select sol.id_solicitud,
                       tip.descripcion Tipo_Solicitud,
                       sol.status,
                       est.descripcion Descripcion_Status,
                       sol.fecha_registro,
                       sol.id_oficina_entrega,
                       ofi.descripcion Descripcion_Oficina,
                       c.nombres ||
                       decode(c.primer_apellido,
                              null,
                              '',
                              ' ' || c.primer_apellido) ||
                       decode(c.segundo_apellido,
                              null,
                              '',
                              ' ' || c.segundo_apellido) Solicitante,
                       emp.razon_social,
                       sol.comentarios,
                       sol.id_tipo_solicitud,
                       usu.nombre_usuario ||
                       decode(usu.apellidos, null, '', ' ' || usu.apellidos) ult_usuario
                  from sel_solicitudes_t sol
                  join sel_tipos_solicitudes_t tip
                    on tip.id_tipo_solicitud = sol.id_tipo_solicitud
                  left join sre_ciudadanos_t c
                    on c.no_documento = sol.representante
                   and c.tipo_documento = 'C'
                  left join sre_empleadores_t emp
                    on emp.rnc_o_cedula = sol.rnc_o_cedula
                  join sel_status_t est
                    on est.id_status = sol.status
                  join sel_oficinas_t ofi
                    on ofi.id_oficina = sol.id_oficina_entrega
                  left join seg_usuario_t usu
                    on usu.id_usuario = sol.ult_usr_modifico
                 where sol.rnc_o_cedula = p_rnc_o_cedula
                union all
                select sol.id_solicitud,
                       tip.descripcion Tipo_Solicitud,
                       sol.status,
                       est.descripcion Descripcion_Status,
                       sol.fecha_registro,
                       sol.id_oficina_entrega,
                       ofi.descripcion Descripcion_Oficina,
                       c.nombres ||
                       decode(c.primer_apellido,
                              null,
                              '',
                              ' ' || c.primer_apellido) ||
                       decode(c.segundo_apellido,
                              null,
                              '',
                              ' ' || c.segundo_apellido) Solicitante,
                       emp.razon_social,
                       sol.comentarios,
                       sol.id_tipo_solicitud,
                       usu.nombre_usuario ||
                       decode(usu.apellidos, null, '', ' ' || usu.apellidos) ult_usuario
                  from sel_registro_emp_t remp
                  join sel_solicitudes_t sol
                    on sol.id_solicitud = remp.id_solicitud
                  join sel_tipos_solicitudes_t tip
                    on tip.id_tipo_solicitud = sol.id_tipo_solicitud
                  left join sre_ciudadanos_t c
                    on c.no_documento = sol.representante
                   and c.tipo_documento = 'C'
                  left join sre_empleadores_t emp
                    on emp.rnc_o_cedula = sol.rnc_o_cedula
                  join sel_status_t est
                    on est.id_status = sol.status
                  join sel_oficinas_t ofi
                    on ofi.id_oficina = sol.id_oficina_entrega
                  left join seg_usuario_t usu
                    on usu.id_usuario = sol.ult_usr_modifico
                 where remp.rnc_o_cedula = p_rnc_o_cedula
                 order by 1) y)
      select y.recordcount, x.*
        from x, (select max(num) recordcount from x) y
       where num between vDesde and vHasta
       order by num desc;
  
    p_resultnumber := 0;
  EXCEPTION
    when e_rnc_o_cedula then
      p_resultnumber := seg_retornar_cadena_error(150, null, null);
      return;
    WHEN OTHERS THEN
      v_bderror      := (substr('error ' || to_char(sqlcode) || ': ' ||
                                sqlerrm,
                                1,
                                255));
      p_resultnumber := seg_retornar_cadena_error(-1, v_bderror, sqlcode);
      return;
  END;

  --*********************************************************************************************************
  -- PROCEDIMIENTO:  getSolicitudes
  -- DESCRIPTION:    Trae las solicitudes trabajadas por el CAE según el rango de fecha especificado
  -- **************************************************************************************************
  PROCEDURE getSolicitudes(p_fecha_desde  date,
                           p_fecha_hasta  date,
                           p_iocursor     out t_cursor,
                           p_resultnumber out Varchar2) IS
    v_bderror VARCHAR(1000);
    e_RegistroPatronal  exception;
    e_IvalidAcuerdoPago exception;
  
  BEGIN
  
    open p_iocursor for
      select s.status,
             u.nombre_usuario ||
             decode(u.apellidos, null, '', ' ' || u.apellidos) Usuario,
             count(*) "Solicitudes Trabajadas"
        from sel_solicitudes_t s
        join seg_usuario_t u
          on u.id_usuario = s.ult_usr_modifico
         and u.id_tipo_usuario = 1
       where s.status in (3, 4)
         and trunc(s.fecha_cierre) between trunc(p_fecha_desde) and
             trunc(p_fecha_hasta)
      
       group by s.status, u.nombre_usuario, u.apellidos
       order by u.nombre_usuario asc;
    p_resultnumber := 0;
  
  EXCEPTION
  
    WHEN OTHERS THEN
      v_bderror      := (substr('error ' || to_char(sqlcode) || ': ' ||
                                sqlerrm,
                                1,
                                255));
      p_resultnumber := seg_retornar_cadena_error(-1, v_bderror, sqlcode);
    
  END;

  --*********************************************************************************************************
  -- PROCEDIMIENTO:  getPagesolicitudes
  -- DESCRIPTION:    Trae las solicitudes trabajadas por el CAE según el rango de fecha especificado y paginada agrupado por operador
  -- **************************************************************************************************
  PROCEDURE getPagesolicitudes(p_fecha_desde  date,
                               p_fecha_hasta  date,
                               p_pagenum      in number,
                               p_pagesize     in number,
                               p_iocursor     out t_cursor,
                               p_resultnumber out Varchar2) IS
  
    vDesde    integer := (p_pagesize * (p_pagenum - 1)) + 1;
    vhasta    integer := p_pagesize * p_pagenum;
    v_bderror VARCHAR(1000);
    e_RegistroPatronal  exception;
    e_IvalidAcuerdoPago exception;
  
  BEGIN
  
    open p_iocursor for
      with x as
       (select rownum num, y.*
          from (select s.id_tipo_solicitud,
                       t.descripcion,
                       count(*) "Solicitudes Trabajadas"
                  from sel_solicitudes_t s
                  join sel_tipos_solicitudes_t t
                    on t.id_tipo_solicitud = s.id_tipo_solicitud
                 where s.status = 3
                   and s.fecha_cierre is not null
                   and trunc(s.fecha_cierre) between trunc(p_fecha_desde) and
                       trunc(p_fecha_hasta)
                 group by s.id_tipo_solicitud, t.descripcion
                 order by 2) y)
      select y.recordcount, x.*
        from x, (select max(num) recordcount from x) y
       where num between vDesde and vHasta
       order by num asc;
  
    p_resultnumber := 0;
  
  EXCEPTION
  
    WHEN OTHERS THEN
      v_bderror      := (substr('error ' || to_char(sqlcode) || ': ' ||
                                sqlerrm,
                                1,
                                255));
      p_resultnumber := seg_retornar_cadena_error(-1, v_bderror, sqlcode);
    
  END;

  --*********************************************************************************************************
  -- PROCEDIMIENTO:  getPageDetsolicitudes
  -- DESCRIPTION:    Trae el detalle de las solicitudes trabajadas por un usuario especificado, paginado.
  -- **************************************************************************************************
  PROCEDURE getPageDetsolicitudes(p_id_tipo_solicitud in sel_solicitudes_t.id_tipo_solicitud%type,
                                  p_fecha_desde       date,
                                  p_fecha_hasta       date,
                                  p_pagenum           in number,
                                  p_pagesize          in number,
                                  p_iocursor          out t_cursor,
                                  p_resultnumber      out Varchar2) IS
  
    vDesde    integer := (p_pagesize * (p_pagenum - 1)) + 1;
    vhasta    integer := p_pagesize * p_pagenum;
    v_bderror VARCHAR(1000);
    e_RegistroPatronal  exception;
    e_IvalidAcuerdoPago exception;
  
  BEGIN
  
    open p_iocursor for
      with x as
       (select rownum num, y.*
          from (select s.ult_usr_modifico usuario,
                       to_char(s.fecha_registro, 'dd/mm/yyyy') Fecha_Registro,
                       to_char(s.fecha_registro, 'HH:MI:SS am') hora_registro,
                       to_char(s.fecha_cierre, 'dd/mm/yyyy') Fecha_Cierre,
                       to_char(s.fecha_cierre, 'HH:MI:SS am') hora_cierre,
                       nvl(trim(u.nombre_usuario ||
                                decode(u.apellidos,
                                       null,
                                       '',
                                       ' ' || u.apellidos)),
                           s.ult_usr_modifico) Operador,
                       s.id_tipo_solicitud,
                       t.descripcion TipoSolicitud
                  from sel_solicitudes_t s
                  join sel_tipos_solicitudes_t t
                    on t.id_tipo_solicitud = s.id_tipo_solicitud
                  join seg_usuario_t u
                    on u.id_usuario = s.ult_usr_modifico
                 where s.status = 3
                   and s.fecha_cierre is not null
                   and s.id_tipo_solicitud = p_id_tipo_solicitud
                   and trunc(s.fecha_cierre) between trunc(p_fecha_desde) and
                       trunc(p_fecha_hasta)
                 order by 4) y)
      select y.recordcount, x.*
        from x, (select max(num) recordcount from x) y
       where num between vDesde and vHasta
       order by num asc;
  
    p_resultnumber := 0;
  
  EXCEPTION
  
    WHEN OTHERS THEN
      v_bderror      := (substr('error ' || to_char(sqlcode) || ': ' ||
                                sqlerrm,
                                1,
                                255));
      p_resultnumber := seg_retornar_cadena_error(-1, v_bderror, sqlcode);
    
  END;
  -- **************************************************************************************************
  -- PROCEDIMIENTO:  getReferencias
  -- DESCRIPTION:    Trae referencias para un rnc especificado
  -- **************************************************************************************************
  PROCEDURE getReferencias(p_rnc_o_cedula in sre_empleadores_t.rnc_o_cedula%type,
                           p_iocursor     out t_cursor,
                           p_resultnumber out varchar2) IS
    e_rnc_o_cedula exception;
    v_bderror varchar(1000);
  
  BEGIN
  
    if not suirplus.sre_empleadores_pkg.isRncOCedulaValida(p_rnc_o_cedula) then
      raise e_rnc_o_cedula;
    end if;
  
    Open p_iocursor for
      select f.ID_REFERENCIA
        from sfc_facturas_v f
        join sre_empleadores_t e
          on e.id_registro_patronal = f.ID_REGISTRO_PATRONAL
       where e.rnc_o_cedula = p_rnc_o_cedula
         and f.status in ('VE', 'VI')
         and f.NO_AUTORIZACION is null;
  
    p_resultnumber := 0;
  
  EXCEPTION
  
    when e_rnc_o_cedula then
      p_resultnumber := seg_retornar_cadena_error(150, null, null);
      return;
    
    when no_data_found then
      p_resultnumber := seg_retornar_cadena_error(104, null, null);
      return;
    
    WHEN OTHERS THEN
      v_bderror      := (substr('error ' || to_char(sqlcode) || ': ' ||
                                sqlerrm,
                                1,
                                255));
      p_resultnumber := seg_retornar_cadena_error(-1, v_bderror, sqlcode);
      return;
  END;

  --*********************************************************************************************************
  -- PROCEDIMIENTO:  getSolicitudesGeneral
  -- DESCRIPTION:    Trae las solicitudes
  -- **************************************************************************************************
  PROCEDURE getSolicitudesGeneral(p_status         in sel_solicitudes_t.status%type,
                                  p_usuario        in sel_solicitudes_t.ult_usr_modifico%type,
                                  p_tipo_solicitud in sel_solicitudes_t.id_tipo_solicitud%type,
                                  p_fecha_desde    in sel_solicitudes_t.fecha_registro%type,
                                  p_fecha_hasta    in sel_solicitudes_t.fecha_cierre%type,
                                  p_pagenum        in number,
                                  p_pagesize       in number,
                                  p_iocursor       out t_cursor,
                                  p_resultnumber   out Varchar2) IS
  
    vDesde    integer := (p_pagesize * (p_pagenum - 1)) + 1;
    vhasta    integer := p_pagesize * p_pagenum;
    v_bderror VARCHAR(1000);  
    
    v_fecha_desde date :=  to_date(to_char(p_fecha_desde, 'MON-DD-YY'),'MON-DD-YY');
    v_fecha_hasta date :=  to_date(to_char(p_fecha_hasta, 'MON-DD-YY'),'MON-DD-YY');
  querin varchar(5000);   
  BEGIN
  
    querin := 'with x as
       (select rownum num, y.*
          from (select s.id_solicitud,
                        s.id_tipo_solicitud,
                        t.descripcion tipo_solicitud,
                        s.status,
                        st.descripcion descStatus,
                        s.rnc_o_cedula,
                        InitCap(e.razon_social) razon_social,
                        s.representante,
                        initcap(ct.nombres || '' '' || ct.primer_apellido || '' '' ||
                                ct.segundo_apellido) NombreRep,
                        s.ult_usr_modifico,
                        u.nombre_usuario ||
                        decode(u.apellidos, null,''z '', '' '' || u.apellidos) Usuario,
                        s.fecha_registro,
                        s.fecha_cierre,
                        s.Fecha_Proceso,
                       -- nvl(FLOOR(sel_solicitudes_pkg.hours_worked(s.fecha_registro,s.fecha_cierre,8.5,17,''Sat/Sun'')),0) dias,
                        nvl(FLOOR(sel_solicitudes_pkg.TiempoSolicitudes(s.id_solicitud) / 8.5),0) dias,
                        nvl(FLOOR(mod(sel_solicitudes_pkg.TiempoSolicitudes(s.id_solicitud),8.5)),0) horas,
                        nvl(floor((sel_solicitudes_pkg.TiempoSolicitudes(s.id_solicitud) - 
                        TRUNC(sel_solicitudes_pkg.TiempoSolicitudes(s.id_solicitud),0)) * 60),0) minutos,                     
                        nvl(FLOOR(sel_solicitudes_pkg.TiempoEnPausa(s.id_solicitud) / 8.5),0) || '' Dias, '' || 
                        nvl(FLOOR(mod(sel_solicitudes_pkg.TiempoEnPausa(s.id_solicitud),8.5)),0) || '' Horas, '' ||
                        nvl(floor((sel_solicitudes_pkg.TiempoEnPausa(s.id_solicitud) - 
                        TRUNC(sel_solicitudes_pkg.TiempoEnPausa(s.id_solicitud),0)) * 60),0) || '' Minutos '' Pausa
                  from sel_solicitudes_t s
                  join sel_tipos_solicitudes_t t
                    on s.id_tipo_solicitud = t.id_tipo_solicitud
                  join sel_status_t st
                    on s.status = st.id_status
                  left join sre_empleadores_t e
                    on s.rnc_o_cedula = e.rnc_o_cedula
                  left join seg_usuario_t u
                    on s.ult_usr_modifico = u.id_usuario
                  left join sre_ciudadanos_t ct
                    on s.representante = ct.no_documento
                   Where s.id_tipo_solicitud in
                       (select ts.id_tipo_solicitud
                          from sel_tipos_solicitudes_t ts
                         where ts.status = ''A''
                           and ts.formulario_servicio = ''S'')
                           and s.id_solicitud not in
                       (select id_solicitud
                          from sel_solicitudes_t
                         where status = 4
                           and fecha_cierre is null)
                            and trunc(s.fecha_registro) >= to_date('''|| v_fecha_desde ||''') and trunc(s.fecha_registro) <= to_date('''|| v_fecha_hasta ||''')';


if p_status is not null then
  querin := querin || ' and s.status ='|| p_status ||''; 
end if;

if p_tipo_solicitud is not null then
  querin := querin || ' and s.id_tipo_solicitud ='|| p_tipo_solicitud ||''; 
end if;

if p_usuario is not null then
  querin := querin || ' and s.ult_usr_modifico ='''|| p_usuario ||''''; 
end if;

querin := querin || ' order by s.id_solicitud desc ) y)
      select y.recordcount, x.*
        from x, (select max(num) recordcount from x) y
       where num between ('|| vDesde ||') and ('|| vHasta ||')
       order by num';

p_resultnumber := 0;

OPEN p_iocursor FOR querin;

EXCEPTION
  
    WHEN OTHERS THEN
      v_bderror      := (substr('error ' || to_char(sqlcode) || ': ' ||
                                sqlerrm,
                                1,
                                255));
      p_resultnumber := seg_retornar_cadena_error(-1, v_bderror, sqlcode);
    
  END;

  --*********************************************************************************************
  --******************************************************************************************
  --Milciades Hernandez
  --08/02/2010
  --Metodo tre los cantidades de dias y horas de jornadas durante proceso de solitud
  --CantidadDiasJornadas
  --******************************************************************************************

  FUNCTION CantidadDiasJornadas(p_fecha_inicio in date,
                                p_fecha_fin    in date,
                                p_solicitud    in sel_solicitud_pausa_t.id_solicitud%type)
    RETURN NUMBER IS
    diff           NUMBER;
    m_diasFeriados Number;
    v_pausas       number;
  BEGIN
  
    if not p_fecha_inicio is null then
      diff := sel_solicitudes_pkg.hours_worked(p_fecha_inicio,
                                               p_fecha_fin,
                                               8.5,
                                               17,
                                               'Sat/Sun');
    
      --Dia Feriado
      select COUNT(*)
        into m_diasFeriados
        from sco_dias_feriados_t d
       where d.dia_feriado between trunc(p_fecha_inicio) and
             trunc(p_fecha_fin);
    
      m_diasFeriados := floor(m_diasFeriados / 24);
    
      --Pausa
      v_pausas := sel_solicitudes_pkg.TiempoEnPausa(p_solicitud);
    
      RETURN diff - m_diasFeriados - nvl(v_pausas, 0);
    
    else
    
      RETURN 0;
    end if;
  
  END CantidadDiasJornadas;

  --******************************************************************************************
  --Heidi Peralta
  --Funcion que calcula el tiempo total en pausa de una solicitud dada
  --******************************************************************************************

  FUNCTION TiempoEnPausa(p_solicitud in sel_solicitud_pausa_t.id_solicitud%type)
    RETURN NUMBER IS
    v_pausa        NUMBER;
    m_diasFeriados Number;
    v_fecha_inicio date;
    v_fecha_fin    date;
  
  BEGIN
    select max(nvl(fecha_inicio, sysdate)), max(nvl(fecha_fin, sysdate))
      into v_fecha_inicio, v_fecha_fin
      from sel_solicitud_pausa_t
     where id_solicitud = p_solicitud;
  
    if (v_fecha_inicio is not null) then
    
      --cantidad de dias menos los sabados y domingos
      v_pausa := sel_solicitudes_pkg.hours_worked(v_fecha_inicio,
                                                  v_fecha_fin,
                                                  8.5,
                                                  17,
                                                  'Sat/Sun');
    
      --Dia Feriado
      select COUNT(*)
        into m_diasFeriados
        from sco_dias_feriados_t d
       where d.dia_feriado between trunc(v_fecha_inicio) and
             trunc(v_fecha_fin);
    
    end if;
  
    RETURN nvl(v_pausa, 0) - nvl(m_diasFeriados, 0);
  
  END TiempoEnPausa;

  --***********************************************************************************--
  --***********************************************************************************--

  PROCEDURE getSolicitudesServicio(p_iocursor     out t_cursor,
                                   p_resultnumber out varchar2) IS
  
    v_bderror varchar(1000);
    c_cursor  t_cursor;
  BEGIN
  
    open c_cursor for
      select t.id_tipo_solicitud  IdTipo,
             t.descripcion        TipoSolicitud,
             t.id_oficina_entrega IdOficina,
             o.descripcion        Oficina
        from sel_tipos_solicitudes_t t, sel_oficinas_t o
       where t.id_oficina_entrega = o.id_oficina
         and status = 'A'
         and t.formulario_servicio = 'S'
       order by TipoSolicitud;
  
    p_iocursor     := c_cursor;
    p_resultnumber := 0;
  
  EXCEPTION
  
    WHEN OTHERS THEN
      v_bderror      := (substr('error ' || to_char(sqlcode) || ': ' ||
                                sqlerrm,
                                1,
                                255));
      p_resultnumber := seg_retornar_cadena_error(-1, v_bderror, sqlcode);
      return;
  END;

  --***********************************************************************************--
  --Metodo
  --***********************************************************************************--

  PROCEDURE getHistoricoUsuarioSol(p_idsolicitud  in sel_solicitudes_t.id_solicitud%type,
                                   p_iocursor     out t_cursor,
                                   p_resultnumber out varchar2) IS
  
    v_bderror varchar(1000);
    c_cursor  t_cursor;
  BEGIN
  
    open c_cursor for
      select s.fecha_registro,
             s.id_usuario,
             u.nombre_usuario ||
             decode(u.apellidos, null, '', ' ' || u.apellidos) Usuario
        from sel_det_usr_solicitud_t s
        join seg_usuario_t u
          on s.id_usuario = u.id_usuario
       where s.id_solicitud = p_idsolicitud;
  
    p_iocursor     := c_cursor;
    p_resultnumber := 0;
  
  EXCEPTION
  
    WHEN OTHERS THEN
      v_bderror      := (substr('error ' || to_char(sqlcode) || ': ' ||
                                sqlerrm,
                                1,
                                255));
      p_resultnumber := seg_retornar_cadena_error(-1, v_bderror, sqlcode);
      return;
  END;
  ---*******************************************************************************--
  --CMHA
  --23/04/10
  --
  ---*******************************************************************************--
  procedure getSolicitudByRNC(p_rnc          sel_solicitudes_t.rnc_o_cedula%type,
                              p_resultnumber out varchar2) is
  
    v_count        number;
    v_nrosolicitud number;
  
  begin
    --verifica si hay mas de una numero de solicitud para un rnc.
    select count(*)
      into v_count
      from sel_solicitudes_t
     where rnc_o_cedula = p_rnc
       and id_tipo_solicitud = 2
       and status in (0, 1, 2, 5);
  
    --si v_count es mayor que uno:
    if v_count > 1 then
      p_resultnumber := 0 || '|' ||
                        'Este RNC tiene varias solicitudes de este tipo que no se han completado.' ||
                        'Para completar esta solicitud debe dirigirse al módulo de manejo de solicitudes.';
      return;
    
    elsif v_count = 1 then
    
      select id_solicitud
        into v_nrosolicitud
        from sel_solicitudes_t
       where rnc_o_cedula = p_rnc
         and id_tipo_solicitud = 2
         and status in (0, 1, 2, 5);
    
      p_resultnumber := 0 || '|' || v_nrosolicitud;
      return;
    elsif v_count = 0 then
      p_resultnumber := -1 || '|' ||
                        'No existe Nro Solicitud asocianda a este RNC para ser completada..';
      return;
    end if;
  
  end;

  --25/07/2012
  --calcula el tiempo transcurido de un dia al otro, tomando encuenta las horas laborales..
  FUNCTION hours_worked(p_stime       in date,
                        p_etime       in date,
                        p_clockin     number,
                        p_clockout    number,
                        p_ignore_days in varchar2) RETURN number AS
    l_ignore_days long := '/' || upper(p_ignore_days) || '/';
    sub_tot       number := 0;
    l_tot         number := 0;
    
  BEGIN
    
    for i in 0 .. trunc(p_etime) - trunc(p_stime) loop
    if not (to_char(p_stime + i, 'd') in (7,1)) then
   -- if (to_char(p_stime + i, 'DY')) then
        sub_tot := least(trunc(p_stime) + i + p_clockout / 24, p_etime) -
                   greatest(p_stime, trunc(p_stime) + p_clockin / 24 + i);
        if sub_tot > 0 then
          l_tot := l_tot + sub_tot;
        end if;
      end if;
    end loop;
    return l_tot * 24;
  END;

  -- **************************************************************************************************
  -- Function:     procedure isExisteNroSolicitud
  -- DESCRIPCION:       procedimiento que retorna la existencia de un numero de solicitud..
  --                     Recibe : el parametro p_Nro_Solicitud.
  --                     Devuelve: un valor booleano (0,1) . 1 = no existe  0 = existe

  -- **************************************************************************************************
   PROCEDURE isExisteNroSolicitud(p_Nro_Solicitud VARCHAR2,
                                 p_resultnumber  out VARCHAR2)
  
   IS
  
    v_bderror      varchar(1000);
    v_NroSolicitud VARCHAR(22);
  
    CURSOR c_ExisteNroSolicitud IS
      SELECT s.id_solicitud
        FROM sel_solicitudes_t s
       WHERE s.no_solicitud = upper(p_Nro_Solicitud);
  
  BEGIN
    OPEN c_ExisteNroSolicitud;
    FETCH c_ExisteNroSolicitud
      INTO v_NroSolicitud;
  
    CLOSE c_ExisteNroSolicitud;
  
    if v_NroSolicitud is not null then
      p_resultnumber := 1;
    else
      p_resultnumber := 0;
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
  -- PROCEDIMIENTO:     Crear_SolicitudRegEmp
  -- DESCRIPTION:       Crea nuevo registro de Solicitud de Registro de nueva empresa
  -- **************************************************************************************************
  PROCEDURE Crear_RegEmpresa_Solicitud(p_nro_solicitud    in sel_solicitudes_t.no_solicitud%type,                                     
                                       p_usuario          in sel_solicitudes_t.representante%type,
                                       p_id_clase_empresa in sel_solicitudes_t.id_clase_emp%type, 
                                       p_rnc_o_cedula     in sel_solicitudes_t.rnc_o_cedula%type,
                                       p_comentarios      in sel_solicitudes_t.comentarios%type,
                                       p_resultnumber     out varchar2) IS
  
    v_IdSolicitud  number(9);
    v_status       sel_solicitudes_t.status%type;
    v_fechaProceso sel_solicitudes_t.fecha_proceso%type;
    v_bderror      varchar(1000);
  
  BEGIN
  
    --insertar registro de Solicitud en la tabla sel_solicitudes_t y devuelve el id de el registro insertado
    SELECT sel_solicitudes_seq.NEXTVAL INTO v_IdSolicitud FROM dual;
    v_status       := 1;
    v_fechaProceso := sysdate;
  
    insert into sel_solicitudes_t
      (id_solicitud,
       id_tipo_solicitud,
       status,
       id_oficina_entrega,
       rnc_o_cedula,
       representante,
       comentarios,
       fecha_registro,
       fecha_cierre,
       ult_usr_modifico,
       entregado_a,
       fecha_entrega,
       via,
       fecha_proceso,
       NO_SOLICITUD,
       id_clase_emp)
    values
      (v_IdSolicitud,
       2,
       1,
       1, 
       p_rnc_o_cedula,
       p_usuario,
       nvl(p_comentarios, ' '),
       sysdate,
       NULL,
       'OPERACIONES',
       NULL,
       NULL,
       decode('OPERACIONES', null, 'W', 'C'),
       v_fechaProceso,
       p_nro_solicitud,
       p_id_clase_empresa);
  
    p_resultnumber := '0|' || v_IdSolicitud;
    Commit;
  
    if (p_resultnumber = '0') then
      suirplus.sel_solicitudes_pkg.ActualizarStatusSol(v_IdSolicitud,
                                                       1,
                                                       p_resultnumber);
    end if;
  
  EXCEPTION
  
    WHEN OTHERS THEN
      v_bderror      := (substr('error ' || to_char(sqlcode) || ': ' ||
                                sqlerrm,
                                1,
                                255));
      p_resultnumber := '1|' ||
                        seg_retornar_cadena_error(-1, v_bderror, sqlcode);
      return;
  END;

  --****************************************************************************************---
  --29/09/2014
  --****************************************************************************************--
  procedure ActualizaSolicitud(p_no_solicitud  in number,
                               p_representante in varchar2,
                               p_rnc_o_cedula  in varchar2,
                               p_resultnumber  out varchar2) is
  BEGIN
  
    update sel_solicitudes_t s
       set s.rnc_o_cedula  = p_rnc_o_cedula,
           s.representante = p_representante
     where s.no_solicitud = p_no_solicitud;
    commit;
  
    p_resultnumber := 0;
  end;
  
    --****************************************************************************************
  -- Procedimiento: ActualizaStatus 
  -- Actualiza el status de la solicitud en cuestion
  -- By: Kerlin de la cruz              
  -- Fecha : 11/05/2015  
  
  --****************************************************************************************--
  procedure ActualizaStatus(p_no_solicitud  in sel_solicitudes_t.no_solicitud%type, 
                               p_status in sel_solicitudes_t.status%type,                                                                                                                    
                               p_resultnumber  out varchar2) is
  BEGIN
  
    update sel_solicitudes_t s
       set s.status = p_status
     where s.no_solicitud = upper(p_no_solicitud);
    commit;
  
    p_resultnumber := 0;
  end; 
  
  
  --*********************************************************************************
  -- Procedimiento: ActualizaStatus 
  -- Actualiza el status de la solicitud en cuestion
  -- By: Kerlin de la cruz              
  -- Fecha : 11/05/2015  
  
  --*************************************************************************************
  
  procedure ActualizaStatus1(p_id_solicitud  in sel_solicitudes_t.id_solicitud%type,  
                               p_status in sel_solicitudes_t.status%type,                                                                                                                    
                               p_resultnumber  out varchar2) is
  BEGIN
  
    update sel_solicitudes_t s
       set s.status = p_status
     where s.id_solicitud = p_id_solicitud;
    commit;
  
    p_resultnumber := 0;
  end;



  --*******************************************************************************************--\
  --30/09/2014
  --Registra el historico de solicitud 
  --********************************************************************************************-- 
  procedure getHistoricoSolicitudes(p_no_solicitud in varchar2,
                                    p_iocursor     out t_cursor,
                                    p_resultnumber out varchar2) is
    v_bderror      varchar(1000);
    c_cursor       t_cursor;
    v_id_solicitud sel_solicitudes_t.id_solicitud%type;
  BEGIN
  
    begin
      select id_solicitud
        into v_id_solicitud
        from sel_solicitudes_t
       where no_solicitud = upper(p_no_solicitud);
    exception
      when no_data_found then
        p_resultnumber := '1|' ||
                          seg_retornar_cadena_error(-1,
                                                    'No existe esta solicitud',
                                                    sqlcode);
    end;                   
  
    open c_cursor for
    
      select decode(h.id_status,
                    0,
                    'Abierta',
                    1,
                    'En Proceso',
                    2,
                    'Incompleta, esperando mas informacion del Solicitante',
                    3,
                    'Completada',
                    4,
                    'Entregada',
                    5,
                    'Rechazada') Status,
             to_date(h.fecha_registro) "Fecha",
             s.id_clase_emp
        from sel_historico_solicitudes_t h
        join sel_solicitudes_t s
          on s.id_solicitud = h.id_solicitud
        join sel_tipos_solicitudes_t t
          on t.id_tipo_solicitud = s.id_tipo_solicitud
        join sel_status_t e
          on e.id_status = s.status
       where h.id_solicitud = v_id_solicitud
       order by h.id_status asc;
  
    p_iocursor     := c_cursor;
    p_resultnumber := 0;
  
  exception
    when others then
      v_bderror      := (substr('error ' || to_char(sqlcode) || ': ' ||
                                sqlerrm,
                                1,
                                255));
      p_resultnumber := '1|' ||
                        seg_retornar_cadena_error(-1, v_bderror, sqlcode);
      return;
    
  end;

  --*******************************************************************************************--\
  -- Procedimiento: ActualizarStatusSol 
  -- Descripcion: Actualiza el status de los registros en el historico de solicitudes
  -- Fecha: 14/10/2014    
  -- By: kerlin de la cruz 
  --********************************************************************************************-- 
  procedure ActualizarStatusSol(p_id_solicitud in sel_solicitudes_t.id_solicitud%type,
                                p_status       in sel_solicitudes_t.status%type,
                                p_resultnumber out varchar2) is
  
    v_bderror      varchar(1000);
    v_id_solicitud sel_solicitudes_t.id_solicitud%type;
  
  BEGIN     
  
    insert into sel_historico_solicitudes_t
      (id_solicitud, ID_TIPO_SOLICITUD, ID_STATUS, FECHA_REGISTRO)
    values
      (p_id_solicitud, '2', p_status, sysdate);
    p_resultnumber := 0;
    commit;
  
  exception
    when no_data_found then
      p_resultnumber := seg_retornar_cadena_error(181, null, null);
      return;
    when others then
      v_bderror      := (substr('error ' || to_char(sqlcode) || ': ' ||
                                sqlerrm,
                                1,
                                255));
      p_resultnumber := '1|' ||
                        seg_retornar_cadena_error(-1, v_bderror, sqlcode);
      return;
    
  end;

  --*********************************************************************************************************
  -- By Kerlin De La Cruz 
  -- PROCEDIMIENTO:  InsertarDocs
  -- DESCRIPTION:    Se insertan los documentos correspondiente con el nuevo registro de empresa
  -- Fecha: 21/11/2014
  -- **************************************************************************************************
  PROCEDURE InsertarDocs(p_no_solicitud     in sel_solicitudes_t.no_solicitud%type,
                         p_id_requisito     in sre_clase_emp_docs_cargados_t.id_requisito%type,
                         p_documento        in blob,
                         p_nombre_documento in sre_clase_emp_docs_cargados_t.nombre_documento%type,
                         p_tipo_archivo     in sre_clase_emp_docs_cargados_t.tipoarchivo%type,
                         p_resultnumber     out Varchar2) IS
  
    v_id_solicitud sel_solicitudes_t.id_solicitud%type;
    v_bderror      varchar2(1000);
    v_secuencia    sre_clase_emp_docs_cargados_t.id_seq%type;
    e_longitud_invalida exception;
  BEGIN
  
    --validamos la longitud del nombre del archivo antes de insertar.
    if length(p_nombre_documento) > 50 then
      raise e_longitud_invalida;
      /*              p_resultnumber := 'El nombre del archivo es muy largo...';      
      return;*/
    end if;
  
    select sec_documentos.nextval into v_secuencia from dual;
  
    begin
      select s.id_solicitud
        into v_id_solicitud
        from sel_solicitudes_t s
       where s.no_solicitud = upper(p_no_solicitud);
    exception
      when no_data_found then
        p_resultnumber := '1|' ||
                          seg_retornar_cadena_error(-1,
                                                    'No existe esta solicitud',
                                                    sqlcode);
    end;
  
    insert into suirplus.sre_clase_emp_docs_cargados_t c
      (id_seq,
       id_solicitud,
       id_requisito,
       fecha_registro,
       documento,
       nombre_documento,
       tipoarchivo)
    values
      (v_secuencia,
       v_id_solicitud,
       p_id_requisito,
       sysdate,
       p_documento,
       p_nombre_documento,
       p_tipo_archivo);
  
    commit;
  
    p_resultnumber := '0';
  
  EXCEPTION
    WHEN e_longitud_invalida then
      p_resultnumber := seg_retornar_cadena_error(-1,
                                                  'La longitud del nombre es muy larga',
                                                  sqlcode);
    WHEN OTHERS THEN
      v_bderror      := (substr('error ' || to_char(sqlcode) || ': ' ||
                                sqlerrm,
                                1,
                                255));
      p_resultnumber := seg_retornar_cadena_error(-1, v_bderror, sqlcode);
    
  END;

  --*********************************************************************************************************
  -- By Kerlin De La Cruz 
  -- PROCEDIMIENTO: InsertarHistSol
  -- DESCRIPTION: Se inserta el estatus en el cual se encuentra alctualmente la solicitud
  -- Fecha: 26/11/2014
  -- **************************************************************************************************
  PROCEDURE InsertarHistSol(p_no_solicitud      in sel_solicitudes_t.no_solicitud%type,
                            p_id_tipo_solicitud in sel_historico_solicitudes_t.id_tipo_solicitud%type,
                            p_status            in sel_historico_solicitudes_t.id_status%type,
                            p_resultnumber      out Varchar2) IS
  
    v_id_solicitud sel_solicitudes_t.id_solicitud%type;
    v_bderror      varchar2(1000);
    e_error_solicitud exception;
  
  begin
    select s.id_solicitud
      into v_id_solicitud
      from sel_solicitudes_t s
     where s.no_solicitud = upper(p_no_solicitud);
  
    if v_id_solicitud is null then
      raise e_error_solicitud;
    end if;
  
    insert into suirplus.sel_historico_solicitudes_t h
      (ID_SOLICITUD, ID_TIPO_SOLICITUD, ID_STATUS, FECHA_REGISTRO)
    values
      (v_id_solicitud, p_id_tipo_solicitud, p_status, sysdate);
  
    commit;
  
    p_resultnumber := '0';
  
  EXCEPTION
  
    when e_error_solicitud then
      p_resultnumber := seg_retornar_cadena_error(180, v_bderror, sqlcode);
    
    WHEN OTHERS THEN
      v_bderror      := (substr('error ' || to_char(sqlcode) || ': ' ||
                                sqlerrm,
                                1,
                                255));
      p_resultnumber := seg_retornar_cadena_error(-1, v_bderror, sqlcode);
    
  end;

  --**************************************************************************************************
  --Eury Vallejo - Modificando uso de la carga de los requisitos
  --08/01/2015
  -- SEL_SOLICITUDES_PKG - Mostrar Requisitos
  --**************************************************************************************************
  Procedure SolicitudCargaDocs(p_no_solicitud     in sel_solicitudes_t.no_solicitud%type,
                               p_id_clase_empresa in sre_clase_empresa_t.id_clase_emp%type,
                               p_iocursor         out t_cursor,
                               p_resultnumber     out Varchar2) is
  
    v_id_solicitud sel_solicitudes_t.id_solicitud%type;
    v_bderror      varchar2(1000);
    v_contador     number default 0;
    e_error_solicitud exception;
  Begin
  
    select s.id_solicitud
      into v_id_solicitud
      from sel_solicitudes_t s
     where s.no_solicitud = upper(p_no_solicitud);
  
    if v_id_solicitud is null then
      raise e_error_solicitud;
    end if;
  
    select count(docs.id_seq)
      into v_contador
      from sre_clase_emp_docs_cargados_t docs
     where docs.id_solicitud = v_id_solicitud;
  
    if v_contador <> 0 then
    
      Open p_iocursor for
      
        Select e.id_seq,
               e.id_clase_emp,
               (e.descripcion) descripcion,
               decode(e.obligatorio, 'S', 'SI', 'N', 'NO') obligatorio,
               e.estatus,
               e.ult_fecha_act,
               e.ult_usuario_act
          From suirplus.sre_clase_emp_docs_t e
         where e.id_clase_emp = p_id_clase_empresa
           and e.id_seq not in
               (select docs.id_requisito
                  from sre_clase_emp_docs_cargados_t docs
                 where docs.id_solicitud = v_id_solicitud);
    
    else
      Open p_iocursor for
        Select e.id_seq,
               e.id_clase_emp,
               INITCAP(e.descripcion) descripcion,
               decode(e.obligatorio, 'S', 'SI', 'N', 'NO') obligatorio,
               e.estatus,
               e.ult_fecha_act,
               e.ult_usuario_act
          From suirplus.sre_clase_emp_docs_t e,
               suirplus.sre_clase_empresa_t  c
         where e.id_clase_emp = c.id_clase_emp
           and C.id_clase_emp = p_id_clase_empresa;
    end if;
  
    p_resultnumber := '0';
  
  Exception
    when e_error_solicitud then
      p_resultnumber := seg_retornar_cadena_error(180, v_bderror, sqlcode);
    
    When others then
      v_bderror      := (substr('error ' || to_char(sqlcode) || ': ' ||
                                sqlerrm,
                                1,
                                255));
      p_resultnumber := seg_retornar_cadena_error(-1, v_bderror, sqlcode);
  End;

  --*********************************************************************************************************
  -- By Kerlin De La Cruz 
  -- PROCEDIMIENTO: GetDocCargados
  -- DESCRIPTION: Muestra las imagenes cargadas para una solicitud en especifico
  -- Fecha: 19/01/2015
  -- *********************************************************************************************************
  Procedure GetDocCargados(p_no_solicitud in sel_solicitudes_t.no_solicitud%type,
                           p_iocursor     out t_cursor,
                           p_resultnumber out Varchar2) is
  
    v_id_solicitud sel_solicitudes_t.id_solicitud%type;
    v_contador     number default 0;
    e_error_solicitud exception;
    v_bderror varchar2(1000);
  
  Begin
  
    /*Buscamos el id_solicitud en base al codigo de la solicitud*/
    select s.id_solicitud
      into v_id_solicitud
      from sel_solicitudes_t s
     where s.no_solicitud = upper(p_no_solicitud);
  
    /*Validamos si el id_solicitud existe*/
    if v_id_solicitud is null then
      raise e_error_solicitud;
    end if;
  
    select count(docs.id_seq)
      into v_contador
      from sre_clase_emp_docs_cargados_t docs
     where docs.id_solicitud = v_id_solicitud;
  
    if v_contador <> 0 then
    
      Open p_iocursor for
      
        Select d.nombre_documento, d.documento
          From suirplus.sre_clase_emp_docs_cargados_t d
         where d.id_solicitud = v_id_solicitud
         group by d.nombre_documento, d.documento;
    
    end if;
  
    p_resultnumber := '0';
  
  Exception
    when e_error_solicitud then
      p_resultnumber := seg_retornar_cadena_error(180, v_bderror, sqlcode);
    
    When others then
      v_bderror      := (substr('error ' || to_char(sqlcode) || ': ' ||
                                sqlerrm,
                                1,
                                255));
      p_resultnumber := seg_retornar_cadena_error(-1, v_bderror, sqlcode);
  End;

  --*********************************************************************************************************
  -- By Kerlin De La Cruz 
  -- PROCEDIMIENTO: Insertar_Emp_Tmp
  -- DESCRIPTION: Inserta las informaciones temporales del empleador a registrar en cuestion
  -- Fecha: 27/01/2015
  -- *********************************************************************************************************

  Procedure Insertar_Emp_Tmp(p_rnc_o_cedula         in sel_empleadores_tmp_t.rnc_o_cedula%type,
                             p_razon_social         in sel_empleadores_tmp_t.razon_social%type,
                             p_nombre_comercial     in sel_empleadores_tmp_t.nombre_comercial%type,
                             p_status               in sel_empleadores_tmp_t.status%type,
                             p_tipo_empresa         in sel_empleadores_tmp_t.tipo_empresa%type,
                             p_sector_salarial      in sel_empleadores_tmp_t.sector_salarial%type,
                             p_id_sector_economico  in sel_empleadores_tmp_t.id_sector_economico%type,
                             p_id_actividad_eco     in sel_empleadores_tmp_t.id_actividad_eco%type,
                             p_tipo_zona_franca     in sel_empleadores_tmp_t.tipo_zona_franca%type,
                             p_parque               in sel_empleadores_tmp_t.parque%type,
                             p_calle                in sel_empleadores_tmp_t.calle%type,
                             p_numero               in sel_empleadores_tmp_t.numero%type,
                             p_apartamento          in sel_empleadores_tmp_t.apartamento%type,
                             p_sector               in sel_empleadores_tmp_t.sector%type,
                             p_provincia            in sel_empleadores_tmp_t.provincia%type,
                             p_id_municipio         in sel_empleadores_tmp_t.id_municipio%type,
                             p_telefono_1           in sel_empleadores_tmp_t.telefono_1%type,
                             p_ext_1                in sel_empleadores_tmp_t.ext_1%type,
                             p_telefono_2           in sel_empleadores_tmp_t.telefono_2%type,
                             p_ext_2                in sel_empleadores_tmp_t.ext_2%type,
                             p_fax                  in sel_empleadores_tmp_t.fax%type,
                             p_email                in sel_empleadores_tmp_t.email%type,
                             p_cedula_representante in sel_empleadores_tmp_t.cedula_representante%type,
                             p_telefono_rep_1       in sel_empleadores_tmp_t.telefono_rep_1%type,
                             p_ext_rep_1            in sel_empleadores_tmp_t.ext_rep_1%type,
                             p_telefono_rep_2       in sel_empleadores_tmp_t.telefono_rep_2%type,
                             p_ext_rep_2            in sel_empleadores_tmp_t.ext_rep_2%type,
                             p_ult_usuario_act      in sel_empleadores_tmp_t.ult_usuario_act%type,
                             p_ult_fecha_act        in sel_empleadores_tmp_t.ult_fecha_act%type,
                             P_id_solicitud         in sel_empleadores_tmp_t.id_solicitud%type,
                             p_resultnumber         out Varchar2
                             
                             ) is
  
    e_rnc_o_cedula exception;
  
  Begin
  
    if p_rnc_o_cedula is null then
      raise e_rnc_o_cedula;
    end if;
  
    Insert into Suirplus.sel_empleadores_tmp_t
      (Rnc_o_cedula,
       razon_social,
       nombre_comercial,
       status,
       tipo_empresa,
       sector_salarial,
       id_sector_economico,
       id_actividad_eco,
       tipo_zona_franca,
       parque,
       calle,
       numero,
       apartamento,
       sector,
       provincia,
       id_municipio,
       telefono_1,
       ext_1,
       telefono_2,
       ext_2,
       fax,
       email,
       cedula_representante,
       telefono_rep_1,
       ext_rep_1,
       telefono_rep_2,
       ext_rep_2,
       ult_usuario_act,
       ult_fecha_act,
       id_solicitud
       
       )
    values
      (p_rnc_o_cedula,
       p_razon_social,
       p_nombre_comercial,
       p_status,
       p_tipo_empresa,
       p_sector_salarial,
       p_id_sector_economico,
       p_id_actividad_eco,
       p_tipo_zona_franca,
       p_parque,
       p_calle,
       p_numero,
       p_apartamento,
       p_sector,
       p_provincia,
       p_id_municipio,
       p_telefono_1,
       p_ext_1,
       p_telefono_2,
       p_ext_2,
       p_fax,
       p_email,
       p_cedula_representantE,
       p_telefono_rep_1,
       p_ext_rep_1,
       p_telefono_rep_2,
       p_ext_rep_2,
       p_ult_usuario_act,
       sysdate,
       P_id_solicitud
       
       );
  
    update Suirplus.Sel_Solicitudes_t s
       set s.rnc_o_cedula = p_rnc_o_cedula
     where s.id_solicitud = P_id_solicitud;
  
    commit;
  
    p_resultnumber := '0';
  
  Exception
    when e_rnc_o_cedula then
      p_resultnumber := seg_retornar_cadena_error(150, v_bderror, sqlcode);
    
    When others then
      v_bderror      := (substr('error ' || to_char(sqlcode) || ': ' ||
                                sqlerrm,
                                1,
                                255));
      p_resultnumber := seg_retornar_cadena_error(-1, v_bderror, sqlcode);
    
  End;

  --*********************************************************************************************************
  -- By Kerlin De La Cruz 
  -- PROCEDIMIENTO: Get_Resumen_Emp
  -- DESCRIPTION: Muestra la informacion temporal de los nuevos registros de empleadores
  -- en base al codigo de solicitud
  -- Fecha: 05/02/2015
  -- *********************************************************************************************************

  Procedure Get_Resumen_Emp(p_cod_sol      in sel_solicitudes_t.no_solicitud%type,
                            p_iocursor     out t_cursor,
                            p_resultnumber out Varchar2) is
  
    v_id_solicitud sel_solicitudes_t.id_solicitud%type;
    v_bderror      varchar2(500);
  
  begin
  
    select s.id_solicitud
      into v_id_solicitud
      from suirplus.sel_solicitudes_t s
      join suirplus.sel_empleadores_tmp_t e
        on e.id_solicitud = s.id_solicitud
     where s.no_solicitud = upper(p_cod_sol);
  
    Open p_iocursor for
    Select em.rnc_o_cedula,
             upper(em.razon_social) razon_social,
             upper(em.nombre_comercial) nombre_comercial,
             s.representante,
             upper(ci.nombres || ' ' || ci.primer_apellido || ' '|| ci.segundo_apellido) Nombre,
             em.email,
             em.telefono_rep_1
        From suirplus.sel_empleadores_tmp_t em
        join suirplus.sel_solicitudes_t s on s.id_solicitud = em.id_solicitud 
        join suirplus.sre_ciudadanos_t ci on ci.no_documento = em.cedula_representante
        --join suirplus.seg_usuario_t ci  on ci.email = s.representante
       where em.id_solicitud = v_id_solicitud;
  
    p_resultnumber := '0';
  
  Exception
    When others then
      v_bderror      := (substr('error ' || to_char(sqlcode) || ': ' || sqlerrm, 1, 255));
      p_resultnumber := seg_retornar_cadena_error(-1, v_bderror, sqlcode);
  end;

  --*********************************************************************************************************
  -- By: Kerlin De La Cruz 
  -- PROCEDIMIENTO: Get_historico_pasos
  -- DESCRIPTION: Muestra en el paso actual en el cual se encuentra la solicitud que se esta procesando
  -- Fecha: 12/02/2015
  -- *********************************************************************************************************

  Procedure Get_historico_pasos(p_cod_sol      in sel_solicitudes_t.no_solicitud%type,
                                p_iocursor     out t_cursor,
                                p_resultnumber out Varchar2) is
  
    v_id_solicitud sel_solicitudes_t.id_solicitud%type;
    v_bderror      varchar2(500);
    e_solicitud_error exception;
  
  Begin
  
    select s.id_solicitud
      into v_id_solicitud
      from suirplus.sel_solicitudes_t s     
     where s.no_solicitud = upper(p_cod_sol);
  
    if v_id_solicitud is not null then
    
      Open p_iocursor for
        Select max(h.id_status) Status, s.descripcion, so.id_solicitud, h.fecha_registro
          From suirplus.sel_historico_solicitudes_t h
          join suirplus.sel_solicitudes_t so
            on so.id_solicitud = h.id_solicitud
          join suirplus.sel_status_t s
            on s.id_status = h.id_status
         where h.id_solicitud = v_id_solicitud
         group by (h.id_status), s.descripcion, so.id_solicitud, h.fecha_registro
         order by h.fecha_registro desc;
    
    else
      raise e_solicitud_error;
    
    end if;
  
    p_resultnumber := '0';
  
  Exception
    when e_solicitud_error then
      p_resultnumber := seg_retornar_cadena_error(150, v_bderror, sqlcode);
    When others then
      v_bderror      := (substr('error ' || to_char(sqlcode) || ': ' || sqlerrm,  1,  255));
      p_resultnumber := seg_retornar_cadena_error(-1, v_bderror, sqlcode);
  end;

  --*********************************************************************************************************
  -- By: Kerlin De La Cruz 
  -- PROCEDIMIENTO: Actualizar_his_status
  -- DESCRIPTION: Actualiza la fecha de actualizacion de la carga del ultimo archivo cargado para dicha solicitud
  --              en el historico de solicitudes
  -- Fecha: 17/02/2015
  -- *********************************************************************************************************
  Procedure Actualizar_his_status(p_cod_sol      in sel_solicitudes_t.no_solicitud%type,
                                  p_resultnumber out Varchar2) is
  
    v_id_solicitud sel_solicitudes_t.id_solicitud%type;
    v_bderror      varchar2(500);
    e_solicitud_error exception;
  
  Begin
  
    select s.id_solicitud
      into v_id_solicitud
      from suirplus.sel_solicitudes_t s
     where s.no_solicitud = upper(p_cod_sol);
  
    if v_id_solicitud is not null then
      update suirplus.sel_historico_solicitudes_t h
         set h.fecha_registro = sysdate
       where h.id_solicitud = v_id_solicitud
         and h.id_status = 3;
    else
      raise e_solicitud_error;
    end if;
  
    commit;
  
    p_resultnumber := '0';
  
  Exception
    when e_solicitud_error then
      p_resultnumber := seg_retornar_cadena_error(181, v_bderror, sqlcode);
    When others then
      v_bderror      := (substr('error ' || to_char(sqlcode) || ': ' ||   sqlerrm,  1,  255));
      p_resultnumber := seg_retornar_cadena_error(-1, v_bderror, sqlcode);
  End;

  -- **************************************************************************************************
  -- By: Kerlin De La Cruz
  -- Function:     Function isExisteIdSolicitud
  -- DESCRIPCION: Funcion que retorna la existencia de un id_Solicitud en sel_historico_solicitudes.
  -- Fecha: 20/02/2015
  -- **************************************************************************************************
  function isExisteHistorico(p_IdSolicitud varchar2) return boolean is
  
    cursor c_ExisteHistorico is
      select h.id_solicitud
        from sel_historico_solicitudes_t h
       where h.id_solicitud = p_IdSolicitud;
  
    --Variables
    returnvalue   Boolean;
    v_IdSolicitud number;
  
  begin
    Open c_ExisteHistorico;
    fetch c_ExisteHistorico
      into v_IdSolicitud;
    returnvalue := c_ExisteHistorico%found;
    close c_ExisteHistorico;
  
    return(returnvalue);
  end isExisteHistorico;

  -- **************************************************************************************************
  -- By: Kerlin De La Cruz
  -- Function: isExisteUsuario
  -- DESCRIPCION: Funcion que retorna la existencia de un usuario en seg_usuario_t.
  -- Fecha: 10/03/2015
  -- **************************************************************************************************
/*  procedure isExisteUsuario(p_usuario in seg_usuario_t.id_usuario%type,
                            p_class in seg_usuario_t.password%type,
                            p_resultnumber out Varchar2) is  
                            
  
  v_Id_usuario varchar2(50);
  
  
  
    cursor c_ExisteUsuario is
      select u.id_usuario
        from seg_usuario_t u
       where u.id_usuario = p_usuario
         and u.password = md5_digest(lower(p_class))
         and u.status = 'A';  
    
  
  begin
    Open c_ExisteUsuario;
    fetch c_ExisteUsuario
      into v_Id_usuario;    
    close c_ExisteUsuario;
    
    if v_Id_usuario is not null then  
     p_resultnumber := '0';
    else
     p_resultnumber := '1';               
    end if;
    
    exception
    When others then
      v_bderror      := (substr('error ' || to_char(sqlcode) || ': ' || sqlerrm,  1, 255));
      p_resultnumber := seg_retornar_cadena_error(-1, v_bderror, sqlcode);
  end; */
  
  
  
  -- **************************************************************************************************
  -- By: Kerlin De La Cruz
  -- Function: IsValidarEmail
  -- DESCRIPCION: Verifica si el usuario confirmo su emails  
  -- Fecha: 11/05/2015
  -- **************************************************************************************************
  procedure isExisteUsuario(p_usuario in seg_usuario_t.email%type,
                            p_class in seg_usuario_t.password%type,
                            p_resultnumber out Varchar2) is  
                            
  
  v_Id_usuario varchar2(50);
  v_status  seg_usuario_t.status%type;
  v_confirmar_email  seg_usuario_t.confirmar_email%type;
  e_emailNoConfirmado exception;
   
  
  cursor c_ConfirmarEmail is
      select u.id_usuario,u.status,u.confirmar_email
        from seg_usuario_t u
       where u.email = p_usuario
         and u.password = md5_digest(lower(p_class));
        
    
  
  begin
    Open c_ConfirmarEmail;
    fetch c_ConfirmarEmail
      into v_Id_usuario,v_status,v_confirmar_email; 
    close c_ConfirmarEmail;
    
    
    if v_Id_usuario is null then  
      p_resultnumber := 'Invalido' || '|' || 1;  
    
    elsif (v_Id_usuario is not null and v_status = 'I' and v_confirmar_email = 'N') then
         raise e_emailNoConfirmado;   
    
    else
     p_resultnumber := 'OK' || '|' || 0;               
    end if;
   
    
    exception  
    
    when  e_emailNoConfirmado then
    p_resultnumber := Seg_Retornar_Cadena_Error('S01', NULL, NULL);
      RETURN;
    When others then
      v_bderror      := (substr('error ' || to_char(sqlcode) || ': ' || sqlerrm,  1, 255));
      p_resultnumber := seg_retornar_cadena_error(-1, v_bderror, sqlcode);
  end; 
  
 -- *****************************************************************************************
  -- By: Kerlin De La Cruz
  -- Function: isExisteUsuario1
  -- DESCRIPCION: Funcion que retorna la existencia de un usuario en seg_usuario_t.
  -- Fecha: 05/005/2015
  -- **************************************************************************************************
  procedure isExisteUsuario1(p_usuario in seg_usuario_t.email%type,                           
                            p_resultnumber out Varchar2) is  
                            
  
  v_Id_usuario varchar2(50);
  
    cursor c_ExisteUsuario is
      select u.id_usuario
        from seg_usuario_t u
       where u.email = p_usuario;
          
    
  
  begin
    Open c_ExisteUsuario;
    fetch c_ExisteUsuario
      into v_Id_usuario;    
    close c_ExisteUsuario;
    
    if v_Id_usuario is not null then  
     p_resultnumber := '0';
    else
     p_resultnumber := '1';               
    end if;
    
    exception
    When others then
      v_bderror      := (substr('error ' || to_char(sqlcode) || ': ' || sqlerrm,  1, 255));
      p_resultnumber := seg_retornar_cadena_error(-1, v_bderror, sqlcode);
  end; 
  
   
 -- *****************************************************************************************
  -- By: Kerlin De La Cruz
  -- Function: isExisteUsuario2
  -- DESCRIPCION: Funcion que retorna la existencia de un usuario en seg_usuario_t.
  -- Fecha: 15/05/2015
  -- **************************************************************************************************
  procedure isExisteUsuario2(p_usuario in seg_usuario_t.id_usuario%type,                           
                            p_resultnumber out Varchar2) is  
                            
  
  v_Id_usuario varchar2(50);
  
    cursor c_ExisteUsuario is
      select u.id_usuario
        from seg_usuario_t u
       where u.id_usuario = p_usuario;
          
    
  
  begin
    Open c_ExisteUsuario;
    fetch c_ExisteUsuario
      into v_Id_usuario;    
    close c_ExisteUsuario;
    
    if v_Id_usuario is not null then  
     p_resultnumber := '0';
    else
     p_resultnumber := '1';               
    end if;
    
    exception
    When others then
      v_bderror      := (substr('error ' || to_char(sqlcode) || ': ' || sqlerrm,  1, 255));
      p_resultnumber := seg_retornar_cadena_error(-1, v_bderror, sqlcode);
  end;

  --*********************************************************************************************************
  -- By: Kerlin De La Cruz 
  -- PROCEDIMIENTO: SolEnProceso
  -- DESCRIPTION: Buscamos las solicitudes realizadas por el usuario en cuestion.
  -- Fecha: 10/03/2015
  -- *********************************************************************************************************
  Procedure SolEnProceso(p_usuario      in sel_solicitudes_t.representante%type,
                         p_iocursor     out t_cursor,
                         p_resultnumber out Varchar2) is
  
    v_id_solicitud sel_solicitudes_t.id_solicitud%type;
    v_bderror      varchar2(500);
    e_solicitud_error exception;
  
  Begin
  
    Open p_iocursor for
      Select s.no_solicitud,
             initcap(e.descripcion) descripcion,
             initcap(em.rnc_cedula) rnc_cedula,
             initcap(em.razon_social) razon_social,
             decode(s.status,                   
                    1,
                    'En Proceso',
                    2,
                    'Incompleta',
                    3,
                    'Completada',
                    4,
                    'Entregada',
                    5,
                    'Rechazada') Status,
             s.fecha_registro
        From suirplus.sel_solicitudes_t s
        join suirplus.sre_clase_empresa_t e on e.id_clase_emp = s.id_clase_emp 
        join suirplus.dgi_maestro_empleadores_t em on em.rnc_cedula = s.rnc_o_cedula
       where s.representante = p_usuario
         and s.status in (0,1,2,3,4,5)
       order by s.fecha_registro desc;
  
    p_resultnumber := '0';
  exception
    When others then
      v_bderror      := (substr('error ' || to_char(sqlcode) || ': ' ||
                                sqlerrm,
                                1,
                                255));
      p_resultnumber := seg_retornar_cadena_error(-1, v_bderror, sqlcode);
  End;
    
  --*********************************************************************************************************
  -- By Kerlin De La Cruz 
  -- PROCEDIMIENTO: GetCantidadDoc
  -- DESCRIPTION: Muestra las cantidad de documentos cargados para una solicitud en especifico
  -- Fecha: 19/01/2015
  -- *********************************************************************************************************
  Procedure GetCantidadDoc(p_no_solicitud in sel_solicitudes_t.no_solicitud%type,
                           p_iocursor     out t_cursor,
                           p_resultnumber out Varchar2) is
  
    v_id_solicitud sel_solicitudes_t.id_solicitud%type;
    v_contador     number default 0;
    e_error_solicitud exception;
    v_bderror varchar2(1000);
  
  Begin
  
    /*Buscamos el id_solicitud en base al codigo de la solicitud*/
    select s.id_solicitud
      into v_id_solicitud
      from sel_solicitudes_t s
     where s.no_solicitud = upper(p_no_solicitud);    
    
  
    if v_id_solicitud is not null then        
      Open p_iocursor for
      
      select count(docs.id_seq) cant_docs     
      from sre_clase_emp_docs_cargados_t docs
      where docs.id_solicitud = v_id_solicitud;
    
    end if;
  
    p_resultnumber := '0';
  
  Exception   
    
    When others then
      v_bderror      := (substr('error ' || to_char(sqlcode) || ': ' ||
                                sqlerrm,
                                1,
                                255));
      p_resultnumber := seg_retornar_cadena_error(-1, v_bderror, sqlcode);
  End; 
  
  
  -- **************************************************************************************************
  -- Procedure isExisteSolProceso
  -- DESCRIPCION: procedimiento que retorna la existencia de un numero de solicitud..
  --              Recibe : el parametro p_rnc_cedula.
  --              Devuelve: un valor booleano (0,1) . 1 = existe  0 = no existe
  -- By: Kerlin de la cruz
  -- Fecha: 17/04/2015
  -- **************************************************************************************************
  PROCEDURE isExisteSolProceso(p_rnc_o_cedula in suirplus.sel_solicitudes_t.rnc_o_cedula%type,
                               p_resultnumber  out VARCHAR2)
  
   IS
  
    v_bderror      varchar(1000);
    v_NroSolicitud VARCHAR(22);
  
    CURSOR isExisteSolProceso IS
      SELECT s.id_solicitud
        FROM sel_solicitudes_t s
       WHERE s.rnc_o_cedula = p_rnc_o_cedula
         AND s.status in (0,1,2,3);
  
  BEGIN
    OPEN isExisteSolProceso;
    FETCH isExisteSolProceso
      INTO v_NroSolicitud;
  
    CLOSE isExisteSolProceso;
  
    if v_NroSolicitud is not null then
      p_resultnumber := 1 ||'|' || 'No puede registrar esta empresa, posee una solicitud en proceso';
    else
      p_resultnumber := 0;
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
  
  
  --*********************************************************************************************************
  -- By Kerlin De La Cruz 
  -- PROCEDIMIENTO: GetNombreUsuario
  -- DESCRIPTION: Muestra el nombre completo del usuario en cuestion
  -- Fecha: 20/04/2015
  -- *********************************************************************************************************
  Procedure GetNombreUsuario(p_usuario in sel_solicitudes_t.representante%type,
                            p_iocursor     out t_cursor,
                            p_resultnumber out Varchar2) is
  
    v_usuario seg_usuario_t.id_usuario%type;    
    v_bderror varchar2(1000);
  
  Begin
  
    /*Buscamos el id_solicitud en base al codigo de la solicitud*/
    select u.email
      into v_usuario
      from seg_usuario_t u
     where u.email = upper(p_usuario);    
    
  
    if v_usuario is not null then
            
      Open p_iocursor for     
      select u.email      
      from seg_usuario_t u
      where u.id_usuario = p_usuario ;
    
    end if;
  
    p_resultnumber := '0';
  
  Exception   
    
    When others then
      v_bderror      := (substr('error ' || to_char(sqlcode) || ': ' ||
                                sqlerrm,
                                1,
                                255));
      p_resultnumber := seg_retornar_cadena_error(-1, v_bderror, sqlcode);
  End; 
  
  
  
  --*********************************************************************************************************
  -- PROCEDIMIENTO:  getConsSolicitudes
  -- DESCRIPTION: Muestra la informacion del empleador que se encuentra en sel_empleadores_tmp_t
  -- By: Kerlin de la cruz
  -- Fecha: 20/05/2015
  -- **************************************************************************************************
  PROCEDURE getInfoEmpresa (p_no_solicitud   in sel_solicitudes_t.no_solicitud%type,                              
                            p_iocursor     out t_cursor,
                            p_resultnumber out Varchar2) IS
    v_bderror VARCHAR(1000);      
  
  BEGIN
  
    open p_iocursor for
      select e.razon_social,
             e.nombre_comercial,
             e.rnc_o_cedula,
             e.sector_salarial,
             e.id_sector_economico,
             e.id_actividad_eco,
             e.tipo_zona_franca,
             e.parque,
             e.calle,
             e.numero,
             e.apartamento,
             e.sector,
             e.provincia,
             e.id_municipio,
             e.telefono_1,
             e.ext_1,
             e.telefono_2,
             e.ext_2,
             e.fax,
             e.email,
             e.cedula_representante,
             e.telefono_rep_1,
             e.ext_rep_1,
             e.telefono_rep_2,
             e.ext_rep_2                          
        from sel_empleadores_tmp_t e  
        join sel_solicitudes_t s on s.id_solicitud = e.id_solicitud      
        where s.no_solicitud = upper(p_no_solicitud) ;          
       
    p_resultnumber := 0;
  
  EXCEPTION
  
    WHEN OTHERS THEN
      v_bderror      := (substr('error ' || to_char(sqlcode) || ': ' ||
                                sqlerrm,
                                1,
                                255));
      p_resultnumber := seg_retornar_cadena_error(-1, v_bderror, sqlcode);
    
  END; 
  
    --*********************************************************************************************************
  -- PROCEDIMIENTO:  getInfoEmpresaEdit
  -- DESCRIPTION: Muestra la informacion del empleador que se encuentra en sel_empleadores_tmp_t
  -- By: Kerlin de la cruz
  -- Fecha: 20/05/2015
  -- **************************************************************************************************
  PROCEDURE getInfoEmpresaEdit(p_id_solicitud   in sel_solicitudes_t.id_solicitud%type,                              
                            p_iocursor     out t_cursor,
                            p_resultnumber out Varchar2) IS
    v_bderror VARCHAR(1000);      
  
  BEGIN
  
    open p_iocursor for
      select e.razon_social,
             e.nombre_comercial,
             e.rnc_o_cedula,
             e.sector_salarial,
             e.id_sector_economico,
             e.id_actividad_eco,
             e.tipo_zona_franca,
             e.parque,
             e.calle,
             e.numero,
             e.apartamento,
             e.sector,
             e.provincia,
             e.id_municipio,
             e.telefono_1,
             e.ext_1,
             e.telefono_2,
             e.ext_2,
             e.fax,
             e.email, 
             e.cedula_representante,
             e.telefono_rep_1,
             e.ext_rep_1,
             e.telefono_rep_2,
             e.ext_rep_2
                                       
        from sel_empleadores_tmp_t e  
        join sel_solicitudes_t s on s.id_solicitud = e.id_solicitud      
        where s.id_solicitud = p_id_solicitud ;         
       
    p_resultnumber := 0;
  
  EXCEPTION
  
    WHEN OTHERS THEN
      v_bderror      := (substr('error ' || to_char(sqlcode) || ': ' ||
                                sqlerrm,
                                1,
                                255));
      p_resultnumber := seg_retornar_cadena_error(-1, v_bderror, sqlcode);
    
  END;    
                      
 
  --*********************************************************************************************************
  -- PROCEDIMIENTO:  ActualizaInfoEmpresa
  -- DESCRIPTION: Actualiza la informacion que el representante decida editar antes de someterla
  --              a la revision de un representante de TSS
  -- By: Kerlin de la cruz
  -- Fecha: 20/05/2015
  -- **************************************************************************************************
  PROCEDURE ActualizaInfoEmpresa ( p_razon_social       in sel_empleadores_tmp_t.razon_social%type,
                                   p_nombre_comercial    in sel_empleadores_tmp_t.nombre_comercial%type,
                                   p_sector_salarial     in sel_empleadores_tmp_t.sector_salarial%type,
                                   p_id_sector_economico in sel_empleadores_tmp_t.id_sector_economico%type,
                                   p_id_actividad_eco    in sel_empleadores_tmp_t.id_actividad_eco%type,
                                   p_tipo_zona_franca    in sel_empleadores_tmp_t.tipo_zona_franca%type,
                                   p_parque              in sel_empleadores_tmp_t.parque%type,
                                   p_calle               in sel_empleadores_tmp_t.calle%type,
                                   p_numero              in sel_empleadores_tmp_t.numero%type,
                                   p_apartamento         in sel_empleadores_tmp_t.apartamento%type,                                   
                                   p_sector              in sel_empleadores_tmp_t.sector%type,
                                   p_provincia           in sel_empleadores_tmp_t.provincia%type,
                                   p_id_municipio        in sel_empleadores_tmp_t.id_municipio%type,
                                   p_telefono_1          in sel_empleadores_tmp_t.telefono_1%type,
                                   p_ext_1               in sel_empleadores_tmp_t.ext_1%type,
                                   p_telefono_2          in sel_empleadores_tmp_t.telefono_2%type,
                                   p_ext_2               in sel_empleadores_tmp_t.ext_2%type,
                                   p_fax                 in sel_empleadores_tmp_t.fax%type,
                                   p_email               in sel_empleadores_tmp_t.email%type,
                                   p_ced_rep             in sel_empleadores_tmp_t.cedula_representante%type,
                                   p_telefono_rep_1      in sel_empleadores_tmp_t.telefono_rep_1%type,
                                   p_ext_rep_1           in sel_empleadores_tmp_t.ext_rep_1%type,
                                   p_telefono_rep_2      in sel_empleadores_tmp_t.telefono_rep_2%type,
                                   p_ext_rep_2           in sel_empleadores_tmp_t.ext_rep_2%type,
                                   p_id_solicitud        in sel_empleadores_tmp_t.id_solicitud%type,                                                                     
                                   p_resultnumber        out Varchar2) IS  
                                      
begin

Update sel_empleadores_tmp_t e  
   set e.razon_social =        nvl(p_razon_social, e.razon_social),
       e.nombre_comercial =    nvl(p_nombre_comercial, e.nombre_comercial),         
       e.sector_salarial =     nvl(p_sector_salarial, e.sector_salarial),     
       e.id_sector_economico = nvl(p_id_sector_economico, e.id_sector_economico), 
       e.id_actividad_eco =    nvl(p_id_actividad_eco, e.id_actividad_eco),    
       e.tipo_zona_franca =    nvl(p_tipo_zona_franca, e.tipo_zona_franca),    
       e.parque =              nvl(p_parque,e.parque),             
       e.calle =               nvl(p_calle, e.calle),               
       e.numero =              nvl(p_numero, e.numero),             
       e.apartamento =         nvl(p_apartamento, e.apartamento),         
       e.sector =              nvl(p_sector, e.sector),             
       e.provincia =           nvl(p_provincia, e.provincia),           
       e.id_municipio =        nvl(p_id_municipio,e.id_municipio),       
       e.telefono_1 =          nvl(p_telefono_1, e.telefono_1),        
       e.ext_1 =               nvl(p_ext_1, e.ext_1),              
       e.telefono_2 =          nvl(p_telefono_2,e.telefono_2),         
       e.ext_2 =               nvl(p_ext_2, e.ext_2),              
       e.fax =                 nvl(p_fax, e.fax),                 
       e.email =               nvl(p_email, e.email),
       e.cedula_representante = nvl(p_ced_rep, e.cedula_representante),
       e.telefono_rep_1 =       nvl(p_telefono_rep_1, e.telefono_rep_1),
       e.ext_rep_1 =            nvl(p_ext_rep_1, e.ext_rep_1),
       e.telefono_rep_2 =       nvl(p_telefono_rep_2, e.telefono_rep_2),
       e.ext_rep_2 =            nvl(p_ext_rep_2, e.ext_rep_2)
       
 where e.id_solicitud = p_id_solicitud; 
 commit;
  
    p_resultnumber := 0; 
    
    
Exception 
    When others then
      v_bderror      := (substr('error ' || to_char(sqlcode) || ': ' ||   sqlerrm,  1,  255));
      p_resultnumber := seg_retornar_cadena_error(-1, v_bderror, sqlcode);    

end;   

  -- **************************************************************************************************
  -- PROCEDIMIENTO:     CargarArchivos
  -- DESCRIPTION:       Trae los archivos cargados  en una solicitud
  -- BY : Kerlin De La Cruz
  -- Fecha : 27/05/2015
  -- **************************************************************************************************
  PROCEDURE CargarArchivos(p_idSolicitud  in sel_solicitudes_t.id_solicitud%type,
                           p_iocursor     out t_cursor,
                           p_resultnumber out varchar2) IS
  
    v_bderror varchar(1000);
    c_cursor  t_cursor;
  BEGIN
  
    open c_cursor for
      select s.id_solicitud,c.descripcion , a.documento,a.tipoarchivo,a.id_requisito
       from sre_clase_emp_docs_cargados_t a 
       left join sel_solicitudes_t s on s.id_solicitud = a.id_solicitud  
       join sre_clase_empresa_t b on b.id_clase_emp = s.id_clase_emp
       join sre_clase_emp_docs_t c on c.id_seq = a.id_requisito
       where a.id_solicitud = p_idSolicitud;
  
    p_iocursor     := c_cursor;
    p_resultnumber := 0;
  
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
  -- PROCEDIMIENTO:     CargarArchivos
  -- DESCRIPTION:       Trae los archivos cargados  en una solicitud
  -- BY : Kerlin De La Cruz
  -- Fecha : 27/05/2015
  -- **************************************************************************************************
  PROCEDURE CargarArchivos(p_idSolicitud  in sel_solicitudes_t.id_solicitud%type,   
                           p_idrequisito  in sre_clase_emp_docs_cargados_t.id_requisito%type,
                           p_iocursor     out t_cursor,
                           p_resultnumber out varchar2) IS
  
    v_bderror varchar(1000);
    c_cursor  t_cursor;
  BEGIN
  
    open c_cursor for
      select s.id_solicitud,c.descripcion , a.documento,a.tipoarchivo
       from sre_clase_emp_docs_cargados_t a 
       left join sel_solicitudes_t s on s.id_solicitud = a.id_solicitud  
       join sre_clase_empresa_t b on b.id_clase_emp = s.id_clase_emp
       join sre_clase_emp_docs_t c on c.id_seq = a.id_requisito
       where a.id_solicitud = p_idSolicitud and a.id_requisito = p_idrequisito;
  
    p_iocursor     := c_cursor;
    p_resultnumber := 0;
  
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
  -- PROCEDIMIENTO:     CargarComentario
  -- DESCRIPTION:       Trae los archivos cargados  en una solicitud
  -- BY : Kerlin De La Cruz
  -- Fecha : 27/05/2015
  -- **************************************************************************************************
  PROCEDURE CargarComentario(p_no_Solicitud  in sel_solicitudes_t.no_solicitud%type,
                             p_iocursor     out t_cursor,
                             p_resultnumber out varchar2) IS
  
    v_bderror varchar(1000);
    c_cursor  t_cursor;
  BEGIN
  
    open c_cursor for
      select s.comentarios
        from sel_solicitudes_t s
        where s.no_solicitud = p_no_Solicitud;       
  
    p_iocursor     := c_cursor;
    p_resultnumber := 0;
  
  EXCEPTION
  
    WHEN OTHERS THEN
      v_bderror      := (substr('error ' || to_char(sqlcode) || ': ' ||
                                sqlerrm,
                                1,
                                255));
      p_resultnumber := seg_retornar_cadena_error(-1, v_bderror, sqlcode);
      return;
  END;
  
-- ****************************************************************************************************
  -- PROCEDIMIENTO:     getNombreRepresentante
  -- DESCRIPTION:       Devuelve el nombre completo del ciudadano basado en el tipo y numero de documento
  --                    dependiendo de los parametros que se le pasen.
  --FECHA : 01/06/2015
  -- By: Kerlin de la cruz
  -- ****************************************************************************************************
  PROCEDURE getNombreRepresentante(p_documento   in sre_ciudadanos_t.no_documento%type, 
                                  p_iocursor     out t_cursor,
                                  p_resultnumber out varchar2) IS
    
    v_bderror varchar(1000);
    c_cursor  t_cursor;
  BEGIN
  
  open c_cursor for
      Select c.nombres || ' ' || nvl(c.primer_apellido, '') || ' ' ||
           nvl(c.segundo_apellido, '') Nombre
      into p_resultnumber
      From sre_ciudadanos_t c
     Where c.no_documento = p_documento;       
  
    p_iocursor     := c_cursor;
    p_resultnumber := 0;  
  
  EXCEPTION     
    
    when no_data_found then
      p_resultnumber := seg_retornar_cadena_error(104, null, null);
      return;
    
    WHEN OTHERS THEN
      v_bderror      := (substr('error ' || to_char(sqlcode) || ': ' ||
                                sqlerrm,
                                1,
                                255));
      p_resultnumber := seg_retornar_cadena_error(-1, v_bderror, sqlcode);
      return;
  END; 
  
  
  --*********************************************************************************************************
  -- PROCEDIMIENTO:  ActStatusEmpTmp
  -- DESCRIPTION: Actualiza la informacion que el representante decida editar antes de someterla
  --              a la revision de un representante de TSS
  -- By: Kerlin de la cruz
  -- Fecha: 02/06/2015
  -- **************************************************************************************************
  PROCEDURE ActStatusEmpTmp(p_id_solicitud  in sel_empleadores_tmp_t.id_solicitud%type,
                            p_status        in sel_empleadores_tmp_t.status%type,                            
                            p_resultnumber  out Varchar2) IS  
                                      
begin

  Update sel_empleadores_tmp_t e  
     set e.status = p_status         
   where e.id_solicitud = p_id_solicitud;
  
 commit;
  
    p_resultnumber := 0;     
    
Exception 
    When others then
      v_bderror      := (substr('error ' || to_char(sqlcode) || ': ' ||   sqlerrm,  1,  255));
      p_resultnumber := seg_retornar_cadena_error(-1, v_bderror, sqlcode);    

end; 


  --*********************************************************************************************************
  -- PROCEDIMIENTO:  ActRequisitos
  -- DESCRIPTION: Modifica el archivo ya cargado en un registro de empresa   
  -- By: Kerlin de la cruz
  -- Fecha: 12/06/2015
  -- **************************************************************************************************
  PROCEDURE ActRequisitos(p_id_solicitud  in sre_clase_emp_docs_cargados_t.id_solicitud%type,
                          p_nombre_doc    in sre_clase_emp_docs_cargados_t.nombre_documento%type, 
                          p_documento     in blob,                           
                          p_resultnumber  out Varchar2) IS  
                                      
begin

  Update sre_clase_emp_docs_cargados_t e 
     set e.documento = p_documento         
   where e.id_solicitud = p_id_solicitud
     and e.nombre_documento = p_nombre_doc;    
 commit;  
 
    p_resultnumber := 0;     
    
Exception 
    When others then
      v_bderror      := (substr('error ' || to_char(sqlcode) || ': ' ||   sqlerrm,  1,  255));
      p_resultnumber := seg_retornar_cadena_error(-1, v_bderror, sqlcode);    

end;


-- ****************************************************************************************************
  -- PROCEDIMIENTO:     GetEditDoc
  -- DESCRIPTION:       Devuelve los documentos cargados para una solicitud en cuestion
  -- FECHA : 12/06/2015
  -- By: Kerlin de la cruz
  -- ****************************************************************************************************
  PROCEDURE GetEditDoc(p_id_solicitud  in sre_clase_emp_docs_cargados_t.id_solicitud%type, 
                           p_iocursor     out t_cursor,
                           p_resultnumber out varchar2) IS
    
    v_bderror varchar(1000);
    c_cursor  t_cursor;
  BEGIN
  
  open c_cursor for
   select (r.descripcion), r.obligatorio,d.nombre_documento, d.documento 
     from sel_solicitudes_t  s
     left join sre_clase_emp_docs_t r          on r.id_clase_emp = s.id_clase_emp
     left join sre_clase_emp_docs_cargados_t d on d.id_solicitud = s.id_solicitud
                                               and d.id_requisito=  r.id_seq                             
     where d.id_solicitud = p_id_solicitud;       
  
  p_iocursor     := c_cursor;
  p_resultnumber := 0;  
  
  EXCEPTION     
    
    when no_data_found then
      p_resultnumber := seg_retornar_cadena_error(104, null, null);
      return;
    
    WHEN OTHERS THEN
      v_bderror      := (substr('error ' || to_char(sqlcode) || ': ' ||
                                sqlerrm,
                                1,
                                255));
      p_resultnumber := seg_retornar_cadena_error(-1, v_bderror, sqlcode);
      return;
  END;          
  
  --******************************************************************************************
  --Eury Vallejo
  --Creacion de Funcion para medir tiempo Solicitudes
  --******************************************************************************************
 FUNCTION TiempoSolicitudes(p_solicitud in sel_solicitudes_t.id_solicitud%type)
    RETURN NUMBER IS
    v_pausa        NUMBER;
    m_diasFeriados Number;
    v_fecha_inicio date;
    v_fecha_fin    date;
  
  BEGIN
    select max(nvl(fecha_registro, sysdate)), max(nvl(fecha_cierre, sysdate))
      into v_fecha_inicio, v_fecha_fin
      from sel_solicitudes_t t
     where id_solicitud = p_solicitud;
  
    if (v_fecha_inicio is not null) then
    
      --cantidad de dias menos los sabados y domingos
      v_pausa := sel_solicitudes_pkg.hours_worked(v_fecha_inicio,
                                                  v_fecha_fin,
                                                  8.5,
                                                  17,
                                                  'Sat/Sun');
    
      --Dia Feriado
      select COUNT(*)
        into m_diasFeriados
        from sco_dias_feriados_t d
       where d.dia_feriado between trunc(v_fecha_inicio) and
             trunc(v_fecha_fin);
    
    end if;
    
   m_diasFeriados := nvl(m_diasFeriados, 0);
   m_diasFeriados := m_diasFeriados * 8.5;
  
    RETURN nvl(v_pausa, 0) - m_diasFeriados;  
  END;                
end SEL_SOLICITUDES_PKG;