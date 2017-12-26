create or replace package body SUIRPLUS.SUB_SFS_DISPERSION is

  m_Bitacora_Sec Integer;
  v_result       varchar2(1000);

  v_file_handle UTL_FILE.file_type;

  v_file_name     varchar2(100);
  v_FechaCreacion SFS_ARCHIVOS_LOG_T.FECHA_CREACION%TYPE;

  v_FechaGeneracion SFS_ARCHIVOS_LOG_T.FECHA_GENERACION%TYPE;
  v_Mensaje_Error   SFS_ARCHIVOS_LOG_T.Mensaje_Error%TYPE;
  v_MesDia          varchar2(10);
  v_SecuenciaLog    varchar2(30);
  v_parametros  srp_config_t%rowtype;
  v_NumeroAsignado    varchar2(5);
  v_NumeroAsignadoEnf varchar2(5);
  c_ftp_host          varchar2(100);
  c_ftp_user          varchar2(100);
  c_ftp_pass          varchar2(100);
  c_ftp_port          varchar2(100);
  c_ora_outbox        varchar2(100);



  --variables asignadas Requeridas---------------------------------------------
/*  v_NumeroAsignado    varchar2(5) := '00585';
  v_NumeroAsignadoEnf varchar2(5) := '06635';
  c_ftp_host          varchar2(100) := '172.21.0.29';
  c_ftp_user          varchar2(100) := 'TSS';
  c_ftp_pass          varchar2(100) := 'T55FtpSip';
  c_ftp_port          varchar2(100) := '21';
  c_ora_outbox        varchar2(100) := 'ARCHIVOS_SUBSIDIOS';*/

  ----------------------------------------------------------------------------------------
  --- Funcion para saber si esta activa en nomina
  ----------------------------------------------------------------------------------------
  Function IsValidoTipoAjuste(p_id_tipo_ajuste IN sfc_tipo_ajustes_t.id_tipo_ajuste%TYPE)
    return boolean is
    v_count INTEGER := 0;
  Begin
    Select count(*)
      Into v_count
      From sfc_tipo_ajustes_t t
     Where t.id_tipo_ajuste = p_id_tipo_ajuste
       And t.usada_por_sisalril = 'S';

    If (v_count = 0) then
      Return false;
    Else
      Return true;
    End if;
  Exception
    when others then
      Return false;
  End;

  Procedure InsertarCarga(p_nrolote      in sub_carga_t.nro_lote%type,
                          p_tiposubsidio in sub_carga_t.tipo_subsidio%type,
                          p_status       in sub_carga_t.status%type,
                          p_tipo         in sub_carga_t.status%type,
                          p_vista        in sub_carga_t.status%type) As
  Begin

    Insert Into sub_carga_t
      (Nro_Lote,
       tipo_subsidio,
       Status,
       Tipo,
       Vista,
       Fecha_Registro,
       ULT_FECHA_ACT)
    values
      (p_nrolote,
       p_tiposubsidio,
       p_status,
       p_tipo,
       p_vista,
       sysdate,
       sysdate);

    commit;

  End InsertarCarga;
  Procedure InsertarBitacora(p_idproceso in sfc_bitacora_t.id_proceso%type,
                             p_seg       Out sfc_bitacora_t.id_bitacora%Type) As
  Begin

    --busco el secuencial para este proceso
    Select Suirplus.Sfc_Bitacora_Seq.Nextval Into m_Bitacora_Sec From Dual;

    -- Insertar el registro en la bitacora de procesos
    --  Para el proceso 'RS' con estatus 'P' (En proceso)
    Insert Into Suirplus.Sfc_Bitacora_t
      (Id_Proceso, Id_Bitacora, Fecha_Inicio, Status)
    Values
      (p_idproceso, m_Bitacora_Sec, Sysdate, 'P');

    p_seg := m_Bitacora_Sec;
    Commit;

  End InsertarBitacora;

  -- Refactored procedure InsertarAjuste
  procedure InsertarAjuste(v_registropatronal in sfc_trans_ajustes_t.id_registro_patronal%type,
                           v_idnomina         in sfc_trans_ajustes_t.id_nomina%type,
                           v_periodo          in sfc_trans_ajustes_t.periodo_aplicacion%type,
                           v_nss              in sfc_trans_ajustes_t.id_nss%type,
                           v_id_tipo_ajuste   in sfc_trans_ajustes_t.id_tipo_ajuste%type,
                           v_estatus          in sfc_trans_ajustes_t.estatus%type,
                           v_montoajuste      in sfc_trans_ajustes_t.monto_ajuste%type,
                           v_id_ajuste        in sfc_trans_ajustes_t.id_ajuste%type,
                           v_unico            in sfc_trans_ajustes_t.unico%type,
                           v_Nro_Pago         in sfs_subs_maternidad_t.nro_pago%Type,
                           p_RESULTNUMBER     OUT VARCHAR2) is
    v_bd_error VARCHAR(1000);
  begin
    Insert Into suirplus.sfc_trans_ajustes_t
      (id_registro_patronal,
       id_nomina,
       periodo_aplicacion,
       id_nss,
       id_tipo_ajuste,
       estatus,
       monto_ajuste,
       id_ajuste,
       FECHA_REGISTRO,
       unico,
       id)
    values
      (v_registropatronal,
       v_idnomina,
       v_Periodo,
       v_nss,
       v_id_tipo_ajuste,
       v_estatus,
       v_montoajuste,
       v_id_ajuste,
       sysdate,
       v_unico,
       v_Nro_Pago);

    p_resultNumber := '0';

  exception
    WHEN OTHERS THEN
      v_bd_error     := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultNumber := Seg_Retornar_Cadena_Error(-1, v_bd_error, SQLCODE);
      rollback;
      RETURN;
  end InsertarAjuste;

  PROCEDURE InsertarElegible(p_NRO_SOLICITUD     IN SUB_ELEGIBLES_T.NRO_SOLICITUD%type,
                             p_REGISTRO_PATRONAL IN SUB_ELEGIBLES_T.REGISTRO_PATRONAL%type,
                             p_SALARIO_COTIZABLE IN SUB_ELEGIBLES_T.SALARIO_COTIZABLE%type,
                             p_ERROR             IN SUB_ELEGIBLES_T.Error%type,
                             p_FECHA_ERROR       IN SUB_ELEGIBLES_T.Fecha_Error%type,
                             p_FECHA_ENVIO       IN SUB_ELEGIBLES_T.Fecha_Envio%type,
                             p_FECHA_RESPUESTA   IN SUB_ELEGIBLES_T.Fecha_Respuesta%type,
                             p_FECHA_REGISTRO    IN SUB_ELEGIBLES_T.Fecha_Registro%type,
                             p_ID_ESTATUS        IN SUB_ELEGIBLES_T.Id_Estatus%type,
                             p_CATEGORIA_SALARIO IN SUB_ELEGIBLES_T.Categoria_Salario%type,
                             p_NRO_LOTE          IN SUB_ELEGIBLES_T.Nro_Lote%type,
                             p_ID_NOMINA         IN SUB_ELEGIBLES_T.Id_Nomina%type,
                             p_CUOTA             IN SUB_ELEGIBLES_T.Cuota%type,
                             p_NRO_SOLICITUD_SISALRIL IN SUB_ELEGIBLES_T.NRO_SOLICITUD_SISALRIL%type,
                             p_RESULTNUMBER      OUT VARCHAR2) IS
    v_bd_error VARCHAR(1000);
    v_elegible NUMBER;
    v_error NUMBER;

  BEGIN

    --Obtener el numero del elegible
    SELECT sub_elegibles_seq.nextval INTO v_elegible FROM dual;

   --Algunos elegibles vienen con el parametro error con 0 lo que causa un error de integridad en esa columna, hay que pasarlo vacio
   IF p_ERROR = 0 THEN
     v_error := null;
   ELSE
   v_error := p_ERROR;
   END IF;


    INSERT INTO suirplus.SUB_ELEGIBLES_T
      (ID_ELEGIBLES,
       NRO_SOLICITUD,
       REGISTRO_PATRONAL,
       SALARIO_COTIZABLE,
       ERROR,
       FECHA_ERROR,
       ULT_FECHA_ACT,
       FECHA_ENVIO,
       FECHA_RESPUESTA,
       FECHA_REGISTRO,
       ID_ESTATUS,
       CATEGORIA_SALARIO,
       NRO_LOTE,
       ID_NOMINA,
       CUOTA,
       NRO_SOLICITUD_SISALRIL)
    VALUES
      (v_elegible,
       p_NRO_SOLICITUD,
       p_REGISTRO_PATRONAL,
       p_SALARIO_COTIZABLE,
       v_error,
       p_FECHA_ERROR,
       sysdate,
       p_FECHA_ENVIO,
       p_FECHA_RESPUESTA,
       p_FECHA_REGISTRO,
       p_ID_ESTATUS,
       p_CATEGORIA_SALARIO,
       p_NRO_LOTE,
       p_ID_NOMINA,
       p_CUOTA,
       p_NRO_SOLICITUD_SISALRIL);

    p_resultNumber := '0';

  exception
    WHEN OTHERS THEN
      v_bd_error     := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultNumber := Seg_Retornar_Cadena_Error(-1, v_bd_error, SQLCODE);
      rollback;
      RETURN;
  END;

  procedure AgregarLog(p_Secuencia              in SFS_ARCHIVOS_LOG_T.SECUENCIA%type,
                       p_Nombre_Archivo         in SFS_ARCHIVOS_LOG_T.NOMBRE_ARCHIVO%type,
                       p_ID_Entidad_Recaudadora in SFS_ARCHIVOS_LOG_T.ID_ENTIDAD_RECAUDADORA%type,
                       p_Tipo_Subsido           in SFS_ARCHIVOS_LOG_T.TIPO_SUBSIDIO%type,
                       p_Fecha_Creacion         in sfs_archivos_log_t.fecha_creacion%type,
                       p_Fecha_Envio            in SFS_ARCHIVOS_LOG_T.FECHA_ENVIO%type,
                       p_Fecha_Generacion       in SFS_ARCHIVOS_LOG_T.FECHA_GENERACION%type,
                       p_Estatus                in SFS_ARCHIVOS_LOG_T.ESTATUS%type,
                       p_Mensaje_Error          in sfs_archivos_log_t.mensaje_error%type) is
  begin
    insert into SFS_ARCHIVOS_LOG_T
      (SECUENCIA,
       NOMBRE_ARCHIVO,
       ID_ENTIDAD_RECAUDADORA,
       TIPO_SUBSIDIO,
       FECHA_CREACION,
       FECHA_ENVIO,
       FECHA_GENERACION,
       ESTATUS,
       MENSAJE_ERROR)
    values
      (p_Secuencia,
       p_Nombre_Archivo,
       p_ID_Entidad_Recaudadora,
       p_Tipo_Subsido,
       p_Fecha_Creacion,
       p_Fecha_Envio,
       p_Fecha_Generacion,
       p_Estatus,
       p_Mensaje_Error);
    commit;

  end AgregarLog;
  --Proceso para actualizar la carga--
  Procedure ActualizarCarga(p_nrolote      In sub_carga_t.nro_lote%Type,
                            p_registros_ok In sub_carga_t.registros_ok%Type,
                            p_registros_re In sub_carga_t.registros_error%Type,
                            p_estatus      In sub_carga_t.status%Type,
                            p_vista        in sub_carga_t.vista%type) As
  Begin

    If (p_estatus = 'C') Then

      Update Suirplus.sub_carga_t Ca
         Set Ca.Status          = p_estatus,
             ca.fecha_registro  = Sysdate,
             ca.registros_ok    = p_registros_ok,
             ca.registros_error = p_registros_re
       Where ca.nro_lote = p_nrolote
         and ca.vista = nvl(p_vista, ca.vista);
    Else
      Update Sfs_Subs_Carga_t Ca
         Set Ca.Status = p_estatus, ca.fecha_registro = sysdate
       Where Ca.Nro_Lote = p_nrolote;

    End If;

    commit;
  End ActualizarCarga;

  --Proceso para actualizar la bitacora--
  Procedure ActualizarBitacora(p_Bitacora_Sec sfc_bitacora_t.id_bitacora%Type,
                               p_Bitacora_Msg sfc_bitacora_t.mensage%Type,
                               p_status       sfc_bitacora_t.status%Type,
                               p_error        sfc_bitacora_t.id_error%Type) As
  Begin

    If (p_status = 'O') Then

      Update Suirplus.Sfc_Bitacora_t b
         Set b.Fecha_Fin = Sysdate,
             b.Mensage   = p_Bitacora_Msg,
             b.Status    = p_Status,
             b.Id_Error  = p_Error
       Where b.Id_Bitacora = p_Bitacora_Sec;
    Else

      Update Suirplus.Sfc_Bitacora_t b
         Set b.Fecha_Fin  = Sysdate,
             b.Mensage    = p_Bitacora_Msg,
             b.Status     = p_Status,
             b.Id_Error   = p_Error,
             b.seq_number = p_error
       Where b.Id_Bitacora = p_Bitacora_Sec;

    End If;

    commit;

  End ActualizarBitacora;

  procedure ActualizarSubsidios(p_tipo                in sub_solicitud_t.tipo_subsidio%type,
                                p_estatus             in sub_estatus_t.id_estatus%type,
                                p_nrosolicitud        in sub_solicitud_t.nro_solicitud%type,
                                p_id_registropatronal in sre_empleadores_t.id_registro_patronal%type,
                                p_resultNumber        OUT VARCHAR2) is
    v_bd_error VARCHAR(1000);
  begin

    --Actualizando la Maternidad
    if (p_tipo = 'M') then
      update suirplus.sub_sfs_maternidad_t m
         set m.id_estatus = p_estatus
       where m.nro_solicitud = p_nrosolicitud
         and m.id_registro_patronal = p_id_registropatronal;
      --Actualizando la Lactancia
    elsif (p_tipo = 'L') then
      update suirplus.sub_sfs_lactancia_t l
         set l.id_estatus = p_estatus
       where l.nro_solicitud = p_nrosolicitud;
      --Actualizando la Enfermedad comun
    elsif (p_tipo = 'E') then
      update suirplus.sub_sfs_enf_comun_t ef
         set ef.id_estatus = p_estatus
       where ef.nro_solicitud = p_nrosolicitud
         and ef.id_registro_patronal = p_id_registropatronal;
    end if;

    p_resultNumber := '0';

  exception
    WHEN OTHERS THEN
      v_bd_error     := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultNumber := Seg_Retornar_Cadena_Error(-1, v_bd_error, SQLCODE);
      RETURN;
  end ActualizarSubsidios;

  procedure ActualizarFechaEnvio(p_Secuencia     in SFS_ARCHIVOS_LOG_T.SECUENCIA%type,
                                 p_NombreArchvio in sfs_archivos_log_t.nombre_archivo%type,
                                 p_FechaEnvio    in sfs_archivos_log_t.fecha_envio%type,
                                 p_Estatus       in sfs_archivos_log_t.estatus%type) is
  begin
    update SFS_ARCHIVOS_LOG_T
       set fecha_envio = p_FechaEnvio, estatus = p_Estatus
     where secuencia = p_Secuencia
       and nombre_archivo = p_NombreArchvio;
    commit;
  end ActualizarFechaEnvio;

  procedure ActualizarMensajeError(p_Secuencia     in SFS_ARCHIVOS_LOG_T.SECUENCIA%type,
                                   p_NombreArchivo in SFS_ARCHIVOS_LOG_T.NOMBRE_ARCHIVO%type,
                                   p_Mensaje       in SFS_ARCHIVOS_LOG_T.Mensaje_Error%type,
                                   p_tipo_sub      In SFS_ARCHIVOS_LOG_T.Tipo_Subsidio%Type) is
  begin
    update SFS_ARCHIVOS_LOG_T a
       set a.mensaje_error = p_Mensaje
     where a.secuencia = p_Secuencia
       and a.nombre_archivo = p_NombreArchivo
       And a.tipo_subsidio = p_tipo_sub;
    commit;
  end ActualizarMensajeError;

  procedure ActualizarFechaGeneracion(p_Secuencia       in SFS_ARCHIVOS_LOG_T.SECUENCIA%type,
                                      p_NombreArchivo   in SFS_ARCHIVOS_LOG_T.NOMBRE_ARCHIVO%type,
                                      p_FechaGeneracion in SFS_ARCHIVOS_LOG_T.FECHA_GENERACION%type,
                                      p_Estatus         in sfs_archivos_log_t.estatus%type,
                                      p_tipo_subsidio   In sfs_archivos_log_t.tipo_subsidio%Type)

   is
  begin
    Update Sfs_Archivos_Log_t
       Set Fecha_Generacion = p_Fechageneracion, Estatus = p_Estatus
     Where Secuencia = p_Secuencia
       And Nombre_Archivo = p_Nombrearchivo
       And Tipo_Subsidio = p_Tipo_Subsidio;
    commit;
  end ActualizarFechaGeneracion;

  Procedure Actualizarstatus Is
    v_resultnumber VARCHAR2(1000);
  Begin

    Begin
		/*For que busca las solicitudes OK, y con todas sus cuotas pagadas*/
	  for e in (select m.rowid, c.nro_solicitud, m.id_registro_patronal, c.monto_subsidio
				  from suirplus.sub_sfs_maternidad_t m
				  join suirplus.sub_cuotas_t c
					on c.nro_solicitud = m.nro_solicitud
				   and c.id_registro_patronal = m.id_registro_patronal
				where m.id_estatus = 2
				group by m.rowid, c.nro_solicitud, m.id_registro_patronal, c.monto_subsidio
				having count(*) = sum(decode(c.status_pago,'P',1,0)) 
				order by c.nro_solicitud desc)

       loop
	    -- Marcar como completadas las de Maternidad
	   update suirplus.sub_sfs_maternidad_t ma1
         set ma1.id_estatus = 4
       where ma1.rowid in(e.rowid);


        --Insertando el elegible
        InsertarElegible(e.nro_solicitud,
                         e.id_registro_patronal,
                         e.monto_subsidio,
                         null,
                         null,
                         null,
                         null,
                         sysdate,
                         4,
                         null,
                         null,
                         null,
                         0,
                         null,
                         v_resultnumber);

      end loop;
      commit;
    Exception
      When Others Then
        Null;
        rollback;
    End;

  End Actualizarstatus;

  procedure EnviarPorFTP(p_secuencia_archivo in sfs_archivos_log_t.secuencia%type,
                         p_tiposubsidio      in sfs_archivos_log_t.tipo_subsidio%type) is
    v_conn          UTL_TCP.connection;
    v_mensaje_error varchar2(300);
    v_tipo_subsidio sfs_archivos_log_t.tipo_subsidio%type;
  begin
    v_conn := ftp.login(c_ftp_host, c_ftp_port, c_ftp_user, c_ftp_pass);

    select l.nombre_archivo, l.tipo_subsidio
      into v_file_name, v_tipo_subsidio
      from sfs_archivos_log_t l
     where l.secuencia = p_secuencia_archivo
       and l.tipo_subsidio = p_tiposubsidio;

    case v_tipo_subsidio

      when 'M' then

        begin
          ftp.binary(p_conn => v_conn);
          ftp.put_direct(p_conn      => v_conn,
                         p_from_dir  => c_ora_outbox,
                         p_from_file => v_file_name,
                         p_to_file   => v_file_name);
          ftp.logout(p_conn => v_conn);
          utl_tcp.close_all_connections;
          --actualizar fecha en que se envio el archivo por FTP.
          ActualizarFechaEnvio(p_secuencia_archivo,
                               v_file_name,
                               sysdate,
                               'F');
        exception
          when utl_tcp.transfer_timeout then
            v_mensaje_error := 'Ocurrio un timeout en la traferencia del archivo' || ' ' ||
                               v_file_name || '' || 'de tipo maternidad';
            -- AgregarLog(p_secuencia_archivo,v_file_name,v_entidad_recaudadora,v_tipo_subsidio,null,null, null,'E',v_mensaje_error);
            ActualizarMensajeError(p_secuencia_archivo,
                                   v_file_name,
                                   v_mensaje_error,
                                   'M');
          when utl_tcp.network_error then
            v_mensaje_error := 'Ocurrio un error en la red' || ' ' ||
                               v_file_name || '' || 'de tipo maternidad';
            ActualizarMensajeError(p_secuencia_archivo,
                                   v_file_name,
                                   v_mensaje_error,
                                   'M');

            utl_tcp.close_all_connections;
        end;

      when 'L' then

        begin

          ftp.binary(p_conn => v_conn);
          ftp.put_direct(p_conn      => v_conn,
                         p_from_dir  => c_ora_outbox,
                         p_from_file => v_file_name,
                         p_to_file   => v_file_name);
          ftp.logout(p_conn => v_conn);
          utl_tcp.close_all_connections;
          --actualizar fecha en que se envio el archivo por FTP.
          ActualizarFechaEnvio(p_secuencia_archivo,
                               v_file_name,
                               sysdate,
                               'F');
        exception
          when utl_tcp.transfer_timeout then
            v_mensaje_error := 'Ocurrio un timeout en la traferencia del archivo' || ' ' ||
                               v_file_name || '' || 'de tipo lactancia';
            ActualizarMensajeError(p_secuencia_archivo,
                                   v_file_name,
                                   v_mensaje_error,
                                   'L');

          when utl_tcp.network_error then
            v_mensaje_error := 'Ocurrio un error en la red' || ' ' ||
                               v_file_name || '' || 'de tipo lactancia';
            ActualizarMensajeError(p_secuencia_archivo,
                                   v_file_name,
                                   v_mensaje_error,
                                   'L');

            utl_tcp.close_all_connections;
        end;
      when 'E' then

        begin
          ftp.binary(p_conn => v_conn);
          ftp.put_direct(p_conn      => v_conn,
                         p_from_dir  => c_ora_outbox,
                         p_from_file => v_file_name,
                         p_to_file   => v_file_name);
          ftp.logout(p_conn => v_conn);
          utl_tcp.close_all_connections;
          --actualizar fecha en que se envio el archivo por FTP.
          ActualizarFechaEnvio(p_secuencia_archivo,
                               v_file_name,
                               sysdate,
                               'F');
        exception
          when utl_tcp.transfer_timeout then
            v_mensaje_error := 'Ocurrio un timeout en la traferencia del archivo' || ' ' ||
                               v_file_name || '' || 'de tipo maternidad';
            -- AgregarLog(p_secuencia_archivo,v_file_name,v_entidad_recaudadora,v_tipo_subsidio,null,null, null,'E',v_mensaje_error);
            ActualizarMensajeError(p_secuencia_archivo,
                                   v_file_name,
                                   v_mensaje_error,
                                   'E');
          when utl_tcp.network_error then
            v_mensaje_error := 'Ocurrio un error en la red' || ' ' ||
                               v_file_name || '' || 'de tipo maternidad';
            ActualizarMensajeError(p_secuencia_archivo,
                                   v_file_name,
                                   v_mensaje_error,
                                   'E');

            utl_tcp.close_all_connections;
        end;

    end case;

  end EnviarPorFTP;

  procedure SaveDataBR(p_sfs_archivos_br_t sfs_archivos_br_t%rowtype) is
  begin
    insert into sfs_archivos_br_t
      (secuencia, cuenta_a_debitar, cuenta_acreditar, valor, referencia)
    values
      (p_sfs_archivos_br_t.secuencia,
       p_sfs_archivos_br_t.cuenta_a_debitar,
       p_sfs_archivos_br_t.cuenta_acreditar,
       p_sfs_archivos_br_t.valor,
       p_sfs_archivos_br_t.referencia);
    commit;

  end SaveDataBR;
  procedure SaveDataHeaderPopular(p_sfs_archivos_bpd_h_t sfs_archivos_bpd_h_t%Rowtype) is
  begin

    insert into sfs_archivos_bpd_h_t
      (tipo_registro,
       id_compania,
       nombre_compania,
       secuencia,
       tipo_servicio,
       fecha_efectiva,
       cantidad_db,
       monto_total_db,
       cantidad_cr,
       monto_total_cr,
       numero_afiliacion,
       fecha,
       hora,
       e_mail,
       estatus,
       filler,
       tipo_subsidio)
    values
      (p_sfs_archivos_bpd_h_t.tipo_registro,
       p_sfs_archivos_bpd_h_t.id_compania,
       p_sfs_archivos_bpd_h_t.nombre_compania,
       p_sfs_archivos_bpd_h_t.secuencia,
       p_sfs_archivos_bpd_h_t.tipo_servicio,
       p_sfs_archivos_bpd_h_t.fecha_efectiva,
       p_sfs_archivos_bpd_h_t.cantidad_db,
       p_sfs_archivos_bpd_h_t.monto_total_db,
       p_sfs_archivos_bpd_h_t.cantidad_cr,
       p_sfs_archivos_bpd_h_t.monto_total_cr,
       p_sfs_archivos_bpd_h_t.numero_afiliacion,
       p_sfs_archivos_bpd_h_t.fecha,
       p_sfs_archivos_bpd_h_t.hora,
       p_sfs_archivos_bpd_h_t.e_mail,
       p_sfs_archivos_bpd_h_t.estatus,
       p_sfs_archivos_bpd_h_t.filler,
       p_sfs_archivos_bpd_h_t.tipo_subsidio);

  end SaveDataHeaderPopular;

  -- ------------------------------------------
  procedure SaveDataDetallePopular(p_sfs_archivos_bpd_d_t sfs_archivos_bpd_d_t%Rowtype) is
  begin
    insert into sfs_archivos_bpd_d_t
      (tipo_registro,
       id_compania,
       secuencia,
       secuencia_trans,
       cuenta_destino,
       tipo_cuenta_destino,
       moneda_destino,
       cod_banco_destino,
       digi_ver_banco_destino,
       codigo_operacion,
       monto_transaccion,
       tipo_de_identificacion,
       identificacion,
       nombre,
       numero_referencia,
       desc_estado_destino,
       fecha_vencimiento,
       forma_de_contacto,
       e_mail_benef,
       fax_telefono_benef,
       filler_futuro,
       numero_aut,
       codigo_retorno_remoto,
       codigo_razon_remoto,
       codigo_razon_interno,
       procesador_transaccion,
       estatus_transaccion,
       filler)
    values
      (p_sfs_archivos_bpd_d_t.tipo_registro,
       p_sfs_archivos_bpd_d_t.id_compania,
       p_sfs_archivos_bpd_d_t.secuencia,
       p_sfs_archivos_bpd_d_t.secuencia_trans,
       p_sfs_archivos_bpd_d_t.cuenta_destino,
       p_sfs_archivos_bpd_d_t.tipo_cuenta_destino,
       p_sfs_archivos_bpd_d_t.moneda_destino,
       p_sfs_archivos_bpd_d_t.cod_banco_destino,
       p_sfs_archivos_bpd_d_t.digi_ver_banco_destino,
       p_sfs_archivos_bpd_d_t.codigo_operacion,
       p_sfs_archivos_bpd_d_t.monto_transaccion,
       p_sfs_archivos_bpd_d_t.tipo_de_identificacion,
       p_sfs_archivos_bpd_d_t.identificacion,
       p_sfs_archivos_bpd_d_t.nombre,
       p_sfs_archivos_bpd_d_t.numero_referencia,
       p_sfs_archivos_bpd_d_t.desc_estado_destino,
       p_sfs_archivos_bpd_d_t.fecha_vencimiento,
       p_sfs_archivos_bpd_d_t.forma_de_contacto,
       p_sfs_archivos_bpd_d_t.e_mail_benef,
       p_sfs_archivos_bpd_d_t.fax_telefono_benef,
       p_sfs_archivos_bpd_d_t.filler_futuro,
       p_sfs_archivos_bpd_d_t.numero_aut,
       p_sfs_archivos_bpd_d_t.codigo_retorno_remoto,
       p_sfs_archivos_bpd_d_t.codigo_razon_remoto,
       p_sfs_archivos_bpd_d_t.codigo_razon_interno,
       p_sfs_archivos_bpd_d_t.procesador_transaccion,
       p_sfs_archivos_bpd_d_t.estatus_transaccion,
       p_sfs_archivos_bpd_d_t.filler);

  end SaveDataDetallePopular;

  procedure PrepararArchivosBR(p_Secuencia in sfs_archivos_bpd_d_t.secuencia%type,
                               p_Result    out varchar2) is
    cursor c_Arc_Reservas(my_secuencia sfs_archivos_bpd_h_t.secuencia%type) is

      select *
        from sfs_archivos_br_t b
       where b.secuencia = p_Secuencia
       order by b.referencia asc;
  begin

    select to_char(sysdate, 'MMDDYYYY') into v_MesDia from DUAL;
    v_FechaCreacion := sysdate;

    v_SecuenciaLog := LPAD(p_Secuencia, 7, 0);
    v_file_name    := 'BR' || v_MesDia || v_SecuenciaLog || 'E' || '.txt';

    v_file_handle := UTL_FILE.FOPEN('ARCHIVOS_SUBSIDIOS',
                                    v_file_name,
                                    'W',
                                    32767);
    utl_file.fclose(v_file_handle);
    v_file_handle := UTL_FILE.FOPEN('ARCHIVOS_SUBSIDIOS',
                                    v_file_name,
                                    'A',
                                    32767);

    p_Result := 'El Archivo Fue Creado Correctamente.';
    AgregarLog(v_SecuenciaLog,
               v_file_name,
               1,
               'L',
               v_FechaCreacion,
               null,
               null,
               'R',
               p_Result);

    -- Emcabezado del archivo..
    utl_file.put_line(v_file_handle,
                      'Cuenta a Debitar,Cuenta a Acreditar,Valor,Referencia');

    for v_c_Arc_Reservas_Record in c_Arc_Reservas(p_Secuencia) loop
      utl_file.put_line(v_file_handle,
                        '"' || v_c_Arc_Reservas_Record.Cuenta_a_Debitar || '",' || '"' ||
                        v_c_Arc_Reservas_Record.Cuenta_Acreditar || '",' ||
                        to_char(v_c_Arc_Reservas_Record.Valor) || ',' || '"' ||
                        v_c_Arc_Reservas_Record.Referencia || '"');
    end loop;

    utl_file.fclose(v_file_handle);
    v_FechaGeneracion := sysdate;

    --metodo para actualizar la fecha en que se genero el archivo.
    ActualizarFechaGeneracion(v_SecuenciaLog,
                              v_file_name,
                              v_FechaGeneracion,
                              'A',
                              'L');
    p_Result := 'Archivo Generado Correctamente..';
  exception
    when UTL_FILE.write_error then
      utl_file.fclose(v_file_handle);
      v_Mensaje_Error := 'SFS_DISPERION_PKG.preparar_archivos_bpd_d_t: Ha ocurrido un error escribiendo el archivo';
      p_Result        := v_Mensaje_Error;
      ActualizarMensajeError(v_SecuenciaLog,
                             v_file_name,
                             v_Mensaje_Error,
                             'L');

    when UTL_FILE.invalid_path then
      utl_file.fclose(v_file_handle);
      v_Mensaje_Error := 'SFS_DISPERION_PKG.preparar_archivos_bpd_d_t: Ha ocurrido un error ruta invalidad';
      p_Result        := v_Mensaje_Error;
      ActualizarMensajeError(v_SecuenciaLog,
                             v_file_name,
                             v_Mensaje_Error,
                             'L');
  end PrepararArchivosBR;

  procedure PrepararArchivosMaternidad(p_Secuencia in sfs_archivos_bpd_h_t.secuencia%type,
                                       p_Result    out varchar2) is
    v_secuencia        integer := 0;
    v_Tipo_Servicio    sfs_archivos_bpd_h_t.tipo_servicio%type := 2;
    v_Monto_Total_Cr_c varchar2(13);
    v_Monto_Total_Cr   sfs_archivos_bpd_h_t.monto_total_cr%type;

    v_Monto_Transaccion_c varchar2(13);
    v_Monto_Transaccion   sfs_archivos_bpd_d_t.monto_transaccion%type;

    v_parametros varchar2(32000);

    cursor c_Arc_Header_Popular(my_secuencia sfs_archivos_bpd_h_t.secuencia%type) is
      Select h.Tipo_Registro,
             h.Id_Compania,
             h.Nombre_Compania,
             h.Secuencia,
             h.Tipo_Servicio,
             h.Fecha_Efectiva,
             h.Cantidad_Db,
             h.Monto_Total_Db,
             h.Cantidad_Cr,
             h.Monto_Total_Cr,
             h.Numero_Afiliacion,
             h.Fecha,
             h.Hora,
             h.e_Mail,
             h.Estatus,
             h.Filler,
             h.Tipo_Subsidio
        From Sfs_Archivos_Bpd_h_t h
       Where h.Secuencia = my_secuencia
         And h.Tipo_Subsidio = 'M';

    cursor c_Arc_Detalle_Popular(my_secuencia sfs_archivos_bpd_d_t.secuencia%type) is
      Select d.Tipo_Registro,
             d.Id_Compania,
             d.Secuencia,
             d.Secuencia_Trans,
             d.Cuenta_Destino,
             d.Tipo_Cuenta_Destino,
             d.Moneda_Destino,
             d.Cod_Banco_Destino,
             d.Digi_Ver_Banco_Destino,
             d.Codigo_Operacion,
             d.Monto_Transaccion,
             d.Tipo_De_Identificacion,
             d.Identificacion,
             d.Nombre,
             d.Numero_Referencia,
             d.Desc_Estado_Destino,
             d.Fecha_Vencimiento,
             d.Forma_De_Contacto,
             d.e_Mail_Benef,
             d.Fax_Telefono_Benef,
             d.Filler_Futuro,
             d.Numero_Aut,
             d.Codigo_Retorno_Remoto,
             d.Codigo_Razon_Remoto,
             d.Codigo_Razon_Interno,
             d.Procesador_Transaccion,
             d.Estatus_Transaccion,
             d.Filler
        From Sfs_Archivos_Bpd_d_t d
        Join Sfs_Archivos_Bpd_h_t h
          On d.Id_Compania = h.Id_Compania
         And h.Secuencia = d.Secuencia
       Where d.Secuencia = My_Secuencia
         And h.Tipo_Subsidio = 'M';

  begin
    if p_secuencia is null THEN
      select max(secuencia)
        into v_secuencia
        from sfs_archivos_bpd_h_t
       Where Tipo_Subsidio = 'M';
    else
      v_secuencia := p_Secuencia;
    end if;

    v_SecuenciaLog := LPAD(v_secuencia, 7, 0);

    select to_char(sysdate, 'MMDD') into v_MesDia from DUAL;

    v_FechaCreacion := sysdate;

    v_file_name := 'PE' || v_NumeroAsignado || LPAD(v_Tipo_Servicio, 2, 0) ||
                   v_MesDia || v_SecuenciaLog || 'E' || '.txt';

    v_file_handle := UTL_FILE.FOPEN('ARCHIVOS_SUBSIDIOS',
                                    v_file_name,
                                    'W',
                                    32767);
    utl_file.fclose(v_file_handle);
    v_file_handle := UTL_FILE.FOPEN('ARCHIVOS_SUBSIDIOS',
                                    v_file_name,
                                    'A',
                                    32767);

    p_Result := 'Archivo Creado Correctamente.';
    AgregarLog(v_SecuenciaLog,
               v_file_name,
               7,
               'M',
               v_FechaCreacion,
               NULL,
               NULL,
               'R',
               p_Result);

    for v_Arc_Header_Popular_Record in c_Arc_Header_Popular(v_secuencia)

     loop
      v_Monto_Total_Cr := v_Arc_Header_Popular_Record.Monto_Total_Cr;

      -- Agregar 2 ceros a la derecha si es un monto entero (sin centavos) o 1 Cero a la derecha si es multiplo de 10
      select case
               when trunc(v_Monto_Total_Cr) = v_Monto_Total_Cr -- Si es un entero
                then
                lpad(replace(v_Monto_Total_Cr * 100, '.', ''), 13, 0) -- Multiplicar por 100
               else
                case
                  when length(v_Monto_Total_Cr - trunc(v_Monto_Total_Cr)) = 2 -- Si es multiplo de 10 (10, 20,...,90)
                   then
                   lpad(replace(v_Monto_Total_Cr, '.', '') * 10, 13, 0) -- Multiplicar por 10
                  else
                   lpad(replace(v_Monto_Total_Cr, '.', ''), 13, 0) -- en caso contrario, solo rellenar con ceros.
                end
             end
        into v_Monto_Total_Cr_c
        from dual;

      utl_file.put_line(v_file_handle,
                        RPAD(v_Arc_Header_Popular_Record.Tipo_Registro, 1) || '' ||
                        RPAD(v_Arc_Header_Popular_Record.Id_Compania, 15) || '' ||
                        RPAD(v_Arc_Header_Popular_Record.Nombre_Compania,
                             35) || '' ||
                        LPAD(v_Arc_Header_Popular_Record.Secuencia, 7, 0) || '' ||
                        LPAD(v_Arc_Header_Popular_Record.Tipo_Servicio,
                             2,
                             0) || '' || RPAD(to_char(v_Arc_Header_Popular_Record.Fecha_Efectiva,
                                                      'yyyyMMDD'),
                                              8) || '' ||
                        LPAD(v_Arc_Header_Popular_Record.Cantidad_Db, 11, 0) || '' ||
                        LPAD(v_Arc_Header_Popular_Record.Monto_Total_Db,
                             13,
                             0) || '' ||
                        LPAD(v_Arc_Header_Popular_Record.Cantidad_Cr, 11, 0) || '' ||
                        v_Monto_Total_Cr_c || '' ||
                        LPAD(v_Arc_Header_Popular_Record.Numero_Afiliacion,
                             15,
                             0) || '' || RPAD(to_char(v_Arc_Header_Popular_Record.Fecha,
                                                      'YYYYMMDD'),
                                              8) || '' ||
                        RPAD(to_char(v_Arc_Header_Popular_Record.Hora,
                                     'HHMI'),
                             4) || '' ||
                        RPAD(v_Arc_Header_Popular_Record.e_Mail, 40) || '' ||
                        RPAD(nvl(v_Arc_Header_Popular_Record.Estatus, ' '),
                             1,
                             ' ') || '' ||
                        RPAD(nvl(v_Arc_Header_Popular_Record.Filler, ' '),
                             136,
                             ' '));
    end loop;

    for v_Arc_Detalle_Popular_Record in c_Arc_Detalle_Popular(v_secuencia)

     loop

      v_Monto_Transaccion := v_Arc_Detalle_Popular_Record.Monto_Transaccion;
      -- Agregar 2 ceros a la derecha si es un monto entero (sin centavos) o 1 Cero a la derecha si es multiplo de 10

      select case
               when trunc(v_Monto_Transaccion) = v_Monto_Transaccion -- Si es un entero
                then
                lpad(replace(v_Monto_Transaccion * 100, '.', ''), 13, 0) -- Multiplicar por 100
               else
                case
                  when length(v_Monto_Transaccion - trunc(v_Monto_Transaccion)) = 2 -- Si es multiplo de 10 (10, 20,...,90)
                   then
                   lpad(replace(v_Monto_Transaccion, '.', '') * 10, 13, 0) -- Multiplicar por 10
                  else
                   lpad(replace(v_Monto_Transaccion, '.', ''), 13, 0) -- en caso contrario, solo rellenar con ceros.
                end
             end
        into v_Monto_Transaccion_c
        from dual;

      select RPAD(v_Arc_Detalle_Popular_Record.Tipo_Registro, 1) || '' ||
             RPAD(v_Arc_Detalle_Popular_Record.Id_Compania, 15) || '' ||
             LPAD(v_Arc_Detalle_Popular_Record.Secuencia, 7, 0) || '' ||
             LPAD(v_Arc_Detalle_Popular_Record.Secuencia_Trans, 7, 0) || '' ||
             RPAD(v_Arc_Detalle_Popular_Record.Cuenta_Destino, 20) || '' ||
             RPAD(v_Arc_Detalle_Popular_Record.Tipo_Cuenta_Destino, 1) || '' ||
             RPAD(v_Arc_Detalle_Popular_Record.Moneda_Destino, 3) || '' ||
             RPAD(v_Arc_Detalle_Popular_Record.Cod_Banco_Destino, 8) || '' ||
             RPAD(v_Arc_Detalle_Popular_Record.Digi_Ver_Banco_Destino, 1) || '' ||
             RPAD(v_Arc_Detalle_Popular_Record.Codigo_Operacion, 2) || '' ||
             v_Monto_Transaccion_c || '' ||
             RPAD(nvl(v_Arc_Detalle_Popular_Record.Tipo_De_Identificacion,
                      ' '),
                  2,
                  ' ') || '' ||
             RPAD(nvl(v_Arc_Detalle_Popular_Record.Identificacion, ' '),
                  15,
                  ' ') || '' ||
             RPAD(v_Arc_Detalle_Popular_Record.Nombre, 35) || '' ||
             RPAD(v_Arc_Detalle_Popular_Record.Numero_Referencia, 12) || '' ||
             RPAD(v_Arc_Detalle_Popular_Record.Desc_Estado_Destino, 40) || '' ||
             RPAD(' ', 4, ' ') || '' ||
             RPAD(v_Arc_Detalle_Popular_Record.Forma_De_Contacto, 1) || '' ||
             RPAD(nvl(v_Arc_Detalle_Popular_Record.e_Mail_Benef, ' '),
                  40,
                  ' ') || '' ||
             lpad(nvl(v_Arc_Detalle_Popular_Record.Fax_Telefono_Benef, ' '),
                  12,
                  ' ') || '' ||
             RPAD(v_Arc_Detalle_Popular_Record.Filler_Futuro, 2) || '' ||
             RPAD(nvl(v_Arc_Detalle_Popular_Record.Numero_Aut, ' '),
                  15,
                  ' ') || '' || RPAD(nvl(v_Arc_Detalle_Popular_Record.Codigo_Retorno_Remoto,
                                         ' '),
                                     3,
                                     ' ') || '' ||
             RPAD(nvl(v_Arc_Detalle_Popular_Record.Codigo_Razon_Remoto, ' '),
                  3,
                  ' ') || '' || RPAD(nvl(v_Arc_Detalle_Popular_Record.Codigo_Razon_Interno,
                                         ' '),
                                     3,
                                     ' ') || '' ||
             RPAD(nvl(v_Arc_Detalle_Popular_Record.Procesador_Transaccion,
                      ' '),
                  1,
                  ' ') || '' ||
             RPAD(nvl(v_Arc_Detalle_Popular_Record.Estatus_Transaccion, ' '),
                  2,
                  ' ') || '' ||
             RPAD(nvl(v_Arc_Detalle_Popular_Record.Filler, ' '), 52, ' ')
        into v_parametros
        from dual;

      utl_file.put_line(v_file_handle, v_parametros);

      v_Monto_Transaccion_c := 1;

    end loop;

    utl_file.fclose(v_file_handle);
    v_FechaGeneracion := sysdate;
    --metodo para actualizar la fecha en que se genero el archivo.
    ActualizarFechaGeneracion(v_SecuenciaLog,
                              v_file_name,
                              v_FechaGeneracion,
                              'A',
                              'M');
  exception
    when UTL_FILE.write_error then
      utl_file.fclose(v_file_handle);
      v_Mensaje_Error := 'SFS_DISPERION_PKG.preparar_archivos_bpd_d_t: Ha ocurrido un error escribiendo el archivo';
      p_Result        := v_Mensaje_Error;
      ActualizarMensajeError(v_SecuenciaLog,
                             v_file_name,
                             v_Mensaje_Error,
                             'M');
    when UTL_FILE.invalid_path then
      utl_file.fclose(v_file_handle);
      v_Mensaje_Error := 'SFS_DISPERION_PKG.preparar_archivos_bpd_d_t: Ha ocurrido un error ruta invalidad';
      p_Result        := v_Mensaje_Error;
      ActualizarMensajeError(v_SecuenciaLog,
                             v_file_name,
                             v_Mensaje_Error,
                             'M');
    when others then
      v_Mensaje_Error := 'SFS_DISPERION_PKG.preparar_archivos_bpd_d_t: ' ||
                         sqlerrm;
      p_Result        := v_Mensaje_Error;
      ActualizarMensajeError(v_SecuenciaLog,
                             v_file_name,
                             v_Mensaje_Error,
                             'M');
      utl_file.fclose(v_file_handle);
  end PrepararArchivosMaternidad;

  Procedure PrepararArchivoEnfComun(p_Secuencia in sfs_archivos_bpd_h_t.secuencia%type,
                                    p_Result    out varchar2) Is
    v_secuencia        integer := 0;
    v_Tipo_Servicio    sfs_archivos_bpd_h_t.tipo_servicio%type := 2;
    v_Monto_Total_Cr_c varchar2(13);
    v_Monto_Total_Cr   sfs_archivos_bpd_h_t.monto_total_cr%type;

    v_Monto_Transaccion_c varchar2(13);
    v_Monto_Transaccion   sfs_archivos_bpd_d_t.monto_transaccion%type;

    v_parametros varchar2(32000);

    cursor c_Arc_Header_Popular(my_secuencia sfs_archivos_bpd_h_t.secuencia%type) is
      Select h.Tipo_Registro,
             h.Id_Compania,
             h.Nombre_Compania,
             h.Secuencia,
             h.Tipo_Servicio,
             h.Fecha_Efectiva,
             h.Cantidad_Db,
             h.Monto_Total_Db,
             h.Cantidad_Cr,
             h.Monto_Total_Cr,
             h.Numero_Afiliacion,
             h.Fecha,
             h.Hora,
             h.e_Mail,
             h.Estatus,
             h.Filler,
             h.Tipo_Subsidio
        From Sfs_Archivos_Bpd_h_t h
       Where h.Secuencia = my_secuencia
         And h.Tipo_Subsidio = 'E';

    cursor c_Arc_Detalle_Popular(my_secuencia sfs_archivos_bpd_d_t.secuencia%type) is
      Select d.Tipo_Registro,
             d.Id_Compania,
             d.Secuencia,
             d.Secuencia_Trans,
             d.Cuenta_Destino,
             d.Tipo_Cuenta_Destino,
             d.Moneda_Destino,
             d.Cod_Banco_Destino,
             d.Digi_Ver_Banco_Destino,
             d.Codigo_Operacion,
             d.Monto_Transaccion,
             d.Tipo_De_Identificacion,
             d.Identificacion,
             d.Nombre,
             d.Numero_Referencia,
             d.Desc_Estado_Destino,
             d.Fecha_Vencimiento,
             d.Forma_De_Contacto,
             d.e_Mail_Benef,
             d.Fax_Telefono_Benef,
             d.Filler_Futuro,
             d.Numero_Aut,
             d.Codigo_Retorno_Remoto,
             d.Codigo_Razon_Remoto,
             d.Codigo_Razon_Interno,
             d.Procesador_Transaccion,
             d.Estatus_Transaccion,
             d.Filler
        From Sfs_Archivos_Bpd_d_t d
        Join Sfs_Archivos_Bpd_h_t h
          On d.Id_Compania = h.Id_Compania
         And h.Secuencia = d.Secuencia
       Where d.Secuencia = My_Secuencia
         And h.Tipo_Subsidio = 'E';
  Begin
    if p_secuencia is null THEN
      select max(secuencia)
        into v_secuencia
        from sfs_archivos_bpd_h_t
       Where Tipo_Subsidio = 'E';
    else
      v_secuencia := p_Secuencia;
    end if;

    v_SecuenciaLog := LPAD(v_secuencia, 7, 0);

    select to_char(sysdate, 'MMDD') into v_MesDia from DUAL;

    v_FechaCreacion := sysdate;

    v_file_name := 'PE' || v_NumeroAsignadoEnf ||
                   LPAD(v_Tipo_Servicio, 2, 0) || v_MesDia ||
                   v_SecuenciaLog || 'E' || '.txt';

    v_file_handle := UTL_FILE.FOPEN('ARCHIVOS_SUBSIDIOS',
                                    v_file_name,
                                    'W',
                                    32767);
    utl_file.fclose(v_file_handle);
    v_file_handle := UTL_FILE.FOPEN('ARCHIVOS_SUBSIDIOS',
                                    v_file_name,
                                    'A',
                                    32767);

    p_Result := 'Archivo Creado Correctamente.';
    AgregarLog(v_SecuenciaLog,
               v_file_name,
               7,
               'E',
               v_FechaCreacion,
               NULL,
               NULL,
               'R',
               p_Result);

    for v_Arc_Header_Popular_Record in c_Arc_Header_Popular(v_secuencia)

     loop
      v_Monto_Total_Cr := v_Arc_Header_Popular_Record.Monto_Total_Cr;

      -- Agregar 2 ceros a la derecha si es un monto entero (sin centavos) o 1 Cero a la derecha si es multiplo de 10
      select case
               when trunc(v_Monto_Total_Cr) = v_Monto_Total_Cr -- Si es un entero
                then
                lpad(replace(v_Monto_Total_Cr * 100, '.', ''), 13, 0) -- Multiplicar por 100
               else
                case
                  when length(v_Monto_Total_Cr - trunc(v_Monto_Total_Cr)) = 2 -- Si es multiplo de 10 (10, 20,...,90)
                   then
                   lpad(replace(v_Monto_Total_Cr, '.', '') * 10, 13, 0) -- Multiplicar por 10
                  else
                   lpad(replace(v_Monto_Total_Cr, '.', ''), 13, 0) -- en caso contrario, solo rellenar con ceros.
                end
             end
        into v_Monto_Total_Cr_c
        from dual;

      utl_file.put_line(v_file_handle,
                        RPAD(v_Arc_Header_Popular_Record.Tipo_Registro, 1) || '' ||
                        RPAD(v_Arc_Header_Popular_Record.Id_Compania, 15) || '' ||
                        RPAD(v_Arc_Header_Popular_Record.Nombre_Compania,
                             35) || '' ||
                        LPAD(v_Arc_Header_Popular_Record.Secuencia, 7, 0) || '' ||
                        LPAD(v_Arc_Header_Popular_Record.Tipo_Servicio,
                             2,
                             0) || '' || RPAD(to_char(v_Arc_Header_Popular_Record.Fecha_Efectiva,
                                                      'yyyyMMDD'),
                                              8) || '' ||
                        LPAD(v_Arc_Header_Popular_Record.Cantidad_Db, 11, 0) || '' ||
                        LPAD(v_Arc_Header_Popular_Record.Monto_Total_Db,
                             13,
                             0) || '' ||
                        LPAD(v_Arc_Header_Popular_Record.Cantidad_Cr, 11, 0) || '' ||
                        v_Monto_Total_Cr_c || '' ||
                        LPAD(v_Arc_Header_Popular_Record.Numero_Afiliacion,
                             15,
                             0) || '' || RPAD(to_char(v_Arc_Header_Popular_Record.Fecha,
                                                      'YYYYMMDD'),
                                              8) || '' ||
                        RPAD(to_char(v_Arc_Header_Popular_Record.Hora,
                                     'HHMI'),
                             4) || '' ||
                        RPAD(v_Arc_Header_Popular_Record.e_Mail, 40) || '' ||
                        RPAD(nvl(v_Arc_Header_Popular_Record.Estatus, ' '),
                             1,
                             ' ') || '' ||
                        RPAD(nvl(v_Arc_Header_Popular_Record.Filler, ' '),
                             136,
                             ' '));
    end loop;

    for v_Arc_Detalle_Popular_Record in c_Arc_Detalle_Popular(v_secuencia)

     loop

      v_Monto_Transaccion := v_Arc_Detalle_Popular_Record.Monto_Transaccion;
      -- Agregar 2 ceros a la derecha si es un monto entero (sin centavos) o 1 Cero a la derecha si es multiplo de 10

      select case
               when trunc(v_Monto_Transaccion) = v_Monto_Transaccion -- Si es un entero
                then
                lpad(replace(v_Monto_Transaccion * 100, '.', ''), 13, 0) -- Multiplicar por 100
               else
                case
                  when length(v_Monto_Transaccion - trunc(v_Monto_Transaccion)) = 2 -- Si es multiplo de 10 (10, 20,...,90)
                   then
                   lpad(replace(v_Monto_Transaccion, '.', '') * 10, 13, 0) -- Multiplicar por 10
                  else
                   lpad(replace(v_Monto_Transaccion, '.', ''), 13, 0) -- en caso contrario, solo rellenar con ceros.
                end
             end
        into v_Monto_Transaccion_c
        from dual;

      select RPAD(v_Arc_Detalle_Popular_Record.Tipo_Registro, 1) || '' ||
             RPAD(v_Arc_Detalle_Popular_Record.Id_Compania, 15) || '' ||
             LPAD(v_Arc_Detalle_Popular_Record.Secuencia, 7, 0) || '' ||
             LPAD(v_Arc_Detalle_Popular_Record.Secuencia_Trans, 7, 0) || '' ||
             RPAD(v_Arc_Detalle_Popular_Record.Cuenta_Destino, 20) || '' ||
             RPAD(v_Arc_Detalle_Popular_Record.Tipo_Cuenta_Destino, 1) || '' ||
             RPAD(v_Arc_Detalle_Popular_Record.Moneda_Destino, 3) || '' ||
             RPAD(v_Arc_Detalle_Popular_Record.Cod_Banco_Destino, 8) || '' ||
             RPAD(v_Arc_Detalle_Popular_Record.Digi_Ver_Banco_Destino, 1) || '' ||
             RPAD(v_Arc_Detalle_Popular_Record.Codigo_Operacion, 2) || '' ||
             v_Monto_Transaccion_c || '' ||
             RPAD(nvl(v_Arc_Detalle_Popular_Record.Tipo_De_Identificacion,
                      ' '),
                  2,
                  ' ') || '' ||
             RPAD(nvl(v_Arc_Detalle_Popular_Record.Identificacion, ' '),
                  15,
                  ' ') || '' ||
             RPAD(v_Arc_Detalle_Popular_Record.Nombre, 35) || '' ||
             RPAD(v_Arc_Detalle_Popular_Record.Numero_Referencia, 12) || '' ||
             RPAD(v_Arc_Detalle_Popular_Record.Desc_Estado_Destino, 40) || '' ||
             RPAD(' ', 4, ' ') || '' ||
             RPAD(v_Arc_Detalle_Popular_Record.Forma_De_Contacto, 1) || '' ||
             RPAD(nvl(v_Arc_Detalle_Popular_Record.e_Mail_Benef, ' '),
                  40,
                  ' ') || '' ||
             lpad(nvl(v_Arc_Detalle_Popular_Record.Fax_Telefono_Benef, ' '),
                  12,
                  ' ') || '' ||
             RPAD(v_Arc_Detalle_Popular_Record.Filler_Futuro, 2) || '' ||
             RPAD(nvl(v_Arc_Detalle_Popular_Record.Numero_Aut, ' '),
                  15,
                  ' ') || '' || RPAD(nvl(v_Arc_Detalle_Popular_Record.Codigo_Retorno_Remoto,
                                         ' '),
                                     3,
                                     ' ') || '' ||
             RPAD(nvl(v_Arc_Detalle_Popular_Record.Codigo_Razon_Remoto, ' '),
                  3,
                  ' ') || '' || RPAD(nvl(v_Arc_Detalle_Popular_Record.Codigo_Razon_Interno,
                                         ' '),
                                     3,
                                     ' ') || '' ||
             RPAD(nvl(v_Arc_Detalle_Popular_Record.Procesador_Transaccion,
                      ' '),
                  1,
                  ' ') || '' ||
             RPAD(nvl(v_Arc_Detalle_Popular_Record.Estatus_Transaccion, ' '),
                  2,
                  ' ') || '' ||
             RPAD(nvl(v_Arc_Detalle_Popular_Record.Filler, ' '), 52, ' ')
        into v_parametros
        from dual;

      utl_file.put_line(v_file_handle, v_parametros);

      v_Monto_Transaccion_c := 1;

    end loop;

    utl_file.fclose(v_file_handle);
    v_FechaGeneracion := sysdate;
    --metodo para actualizar la fecha en que se genero el archivo.
    ActualizarFechaGeneracion(v_SecuenciaLog,
                              v_file_name,
                              v_FechaGeneracion,
                              'A',
                              'E');
  exception
    when UTL_FILE.write_error then
      utl_file.fclose(v_file_handle);
      v_Mensaje_Error := 'SFS_DISPERION_PKG.preparar_archivos_bpd_d_t: Ha ocurrido un error escribiendo el archivo';
      p_Result        := v_Mensaje_Error;
      ActualizarMensajeError(v_SecuenciaLog,
                             v_file_name,
                             v_Mensaje_Error,
                             'E');
    when UTL_FILE.invalid_path then
      utl_file.fclose(v_file_handle);
      v_Mensaje_Error := 'SFS_DISPERION_PKG.preparar_archivos_bpd_d_t: Ha ocurrido un error ruta invalidad';
      p_Result        := v_Mensaje_Error;
      ActualizarMensajeError(v_SecuenciaLog,
                             v_file_name,
                             v_Mensaje_Error,
                             'E');
    when others then
      v_Mensaje_Error := 'SFS_DISPERION_PKG.preparar_archivos_bpd_d_t: ' ||
                         sqlerrm;
      p_Result        := v_Mensaje_Error;
      ActualizarMensajeError(v_SecuenciaLog,
                             v_file_name,
                             v_Mensaje_Error,
                             'E');
      utl_file.fclose(v_file_handle);
  End PrepararArchivoEnfComun;

  function getMontoSubsidioLactancia_ant(v_nrosolicitud in sub_elegibles_t.nro_solicitud%type)
    return sub_elegibles_t.salario_cotizable%TYPE is
    V_SALARIO_COTIZABLE sub_elegibles_t.salario_cotizable%TYPE := 0;
    v_cat               sub_elegibles_t.categoria_salario%TYPE := 0;
  Begin

    select salario_cotizable, categoria_salario
      into V_SALARIO_COTIZABLE, v_cat
      from (Select salario_cotizable, e.categoria_salario, e.id_elegibles
              from sub_elegibles_t e
             where e.nro_solicitud = v_nrosolicitud
             order by e.id_elegibles desc)
     where rownum = 1;

    if (v_cat = 1) then
      return V_SALARIO_COTIZABLE * .05;
    elsif (v_cat = 2) then
      return V_SALARIO_COTIZABLE * .10;
    elsif (v_cat = 3) then
      return V_SALARIO_COTIZABLE * .25;
    else
      return 0;
    end if;
  End;
  ---------------------------------------------
  function getMontoSubsidioLactancia(v_nrosolicitud in sub_elegibles_t.nro_solicitud%type)
    return sub_elegibles_t.cuota%TYPE is
    V_CUOTA sub_elegibles_t.cuota%TYPE := 0;
    v_fecha_nacimiento date;
    v_fecha_inicio date := parm.get_parm_date(406); --fecha inicio del cambio de cuota
  Begin
    --Para buscar la fecha de nacimiento del lactante
    select l.fecha_nacimiento
      into v_fecha_nacimiento
      from suirplus.sub_sfs_lactancia_t l
     where l.nro_solicitud = v_nrosolicitud;

    --Para saber cual de las dos formas de calcular la cuota elegir
    If v_fecha_nacimiento < v_fecha_inicio then
      --Forma de calculo anterior
      V_CUOTA := getMontoSubsidioLactancia_ant(v_nrosolicitud);

      RETURN V_CUOTA;
    Else
      --Forma de calculo nueva
      select cuota
        into V_CUOTA
        from (Select e.cuota, e.id_elegibles
                from sub_elegibles_t e
               where e.nro_solicitud = v_nrosolicitud
               order by e.id_elegibles desc)
       where rownum = 1;

      RETURN V_CUOTA;
    End if;
  End;

  -- ------------------------------------------
  function GetProximoNumeroLote return INTEGER Is

    v_NroLote INTEGER;

  Begin
    SELECT SFS_DTS_SEQ.NEXTVAL INTO v_NroLote FROM DUAL;
    Return v_NroLote;
  End;

  function GetProximoNumeroCuotaRe return INTEGER Is

    v_NroCuota INTEGER;

  Begin
    SELECT sub_cuotas_re_seq.NEXTVAL INTO v_NroCuota FROM DUAL;
    Return v_NroCuota;
  End;

  function GetProximoNumeroCuota return INTEGER Is

    v_NroCuota INTEGER;

  Begin
    SELECT sub_cuotas_seq.NEXTVAL INTO v_NroCuota FROM DUAL;
    Return v_NroCuota;
  End;

  procedure GetDataDetalleReservas(p_nrolote   sub_cuotas_t.nro_lote%type,
                                   p_secuencia sfs_archivos_br_t.secuencia%type) is
    p_sfs_archivos_br_t sfs_archivos_br_t%rowtype;
    cursor c_reservas is
      select cu.cuenta_banco cuenta_acreditar,
             cu.monto_subsidio valor,
             /*substr(trim(nvl(c.nombres, ' ')) || ' ' ||
                    trim(nvl(c.primer_apellido, ' ')) || ' ' ||
                    trim(nvl(c.segundo_apellido, ' ')),
                    1,
                    35)*/ c.no_documento referencia
        from sub_cuotas_t cu
        join sub_solicitud_t s
          on s.nro_solicitud = cu.nro_solicitud
        join sre_ciudadanos_t c
          on c.id_nss = s.nss
       where cu.status_dispersion = 'D'
         and cu.nro_lote = p_nrolote;
  begin

    for v_reservas in c_reservas loop
      p_sfs_archivos_br_t.secuencia        := p_secuencia;
      p_sfs_archivos_br_t.cuenta_a_debitar := '100-01-240-013595-3';
      p_sfs_archivos_br_t.cuenta_acreditar := v_reservas.cuenta_acreditar;
      p_sfs_archivos_br_t.valor            := v_reservas.valor;
      p_sfs_archivos_br_t.referencia       := v_reservas.referencia;
      SaveDataBR(p_sfs_archivos_br_t);
    end loop;
  end GetDataDetalleReservas;

  procedure GetDataHeaderPopular(p_nrolote   IN sub_cuotas_t.nro_lote%type,
                                 p_secuencia sfs_archivos_bpd_h_t.secuencia%type) is
    v_monto_subsidio       sub_cuotas_t.monto_subsidio%type;
    v_cantidad_registro    integer;
    v_monto_ajuste       sub_cuotas_t.monto_subsidio%type;
    v_cantidad_ajuste    integer;
    p_sfs_archivos_bpd_h_t sfs_archivos_bpd_h_t%ROWTYPE;
    v_email                varchar2(50);
  begin

    SELECT valor_texto
      into v_email
      FROM sfc_det_parametro_t
     WHERE id_parametro = 353
       AND nvl(fecha_fin, sysdate) =
           (SELECT MAX(nvl(fecha_fin, sysdate))
              FROM sfc_det_parametro_t
             WHERE id_parametro = 353);

    select sum(monto_transaccion) monto_subsidio, count(*)
      into v_monto_subsidio, v_cantidad_registro
      from (select distinct cu.cuenta_banco cuenta_destino,
                            cu.tipo_cuenta tipo_cuenta_destino,
                            e.ruta_y_transito cod_banco_destino,
                            e.digito_chequeo digi_ver_banco_destino,
                            sum(cu.monto_subsidio) monto_transaccion,
                            substr(em.razon_social, 1, 35) nombre,
                            cu.periodo numero_referencia,
                            em.email e_mail_benef,
                            em.fax fax_telefono_benef
              from sub_cuotas_t cu
              join sub_solicitud_t s
                on s.nro_solicitud = cu.nro_solicitud
              join sub_sfs_maternidad_t m
                on m.nro_solicitud = cu.nro_solicitud
               and m.id_registro_patronal = cu.id_registro_patronal
              join sfc_entidad_recaudadora_t e
                on e.id_entidad_recaudadora = cu.id_entidad_recaudadora
              join sre_ciudadanos_t c
                on c.id_nss = s.nss
              join sre_empleadores_t em
                on em.id_registro_patronal = m.id_registro_patronal
             where cu.via = 'CB'
               and cu.status_dispersion = 'D'
               and cu.nro_lote = p_nrolote
             group by cu.cuenta_banco,
                      cu.tipo_cuenta,
                      ruta_y_transito,
                      digito_chequeo,
                      em.razon_social,
                      cu.periodo,
                      em.email,
                      em.fax) a;


                select sum(monto_transaccion) monto_subsidio, count(*)
                         into v_monto_ajuste, v_cantidad_ajuste
                         from (select em.cuenta_banco cuenta_destino,
                     em.tipo_cuenta tipo_cuenta_destino,
                     e.ruta_y_transito cod_banco_destino,
                     e.digito_chequeo digi_ver_banco_destino,
                     sum(a.monto_ajuste) monto_transaccion,
                     substr(em.razon_social, 1, 35) nombre,
                     t.periodo_aplicacion numero_referencia,
                     em.email e_mail_benef,
                     em.fax fax_telefono_benef
                from sub_ajustes_t a
                join sfc_trans_ajustes_t t on a.id_ajuste = t.id_ajuste
                join sre_empleadores_t em on a.id_registro_patronal = em.id_registro_patronal
                join sfc_entidad_recaudadora_t e on e.id_entidad_recaudadora =  em.id_entidad_recaudadora
                where a.status = 'DI'
                 and a.nro_lote = p_nrolote
               group by em.cuenta_banco,
                        em.tipo_cuenta,
                        e.ruta_y_transito,
                        e.digito_chequeo,
                        em.razon_social,
                        t.periodo_aplicacion,
                        em.email,
                        em.fax) b;


           v_monto_subsidio := v_monto_subsidio + nvl(v_monto_ajuste, 0);
           v_cantidad_registro := v_cantidad_registro +  nvl(v_cantidad_ajuste,0);



    p_sfs_archivos_bpd_h_t.tipo_registro     := 'H';
    p_sfs_archivos_bpd_h_t.id_compania       := '424002037';
    p_sfs_archivos_bpd_h_t.nombre_compania   := substr('SUPERINTENDENCIA DE SALUD Y RIESGOS LABORALES',
                                                       1,
                                                       35);
    p_sfs_archivos_bpd_h_t.tipo_servicio     := 2;
    p_sfs_archivos_bpd_h_t.fecha_efectiva    := sysdate;
    p_sfs_archivos_bpd_h_t.cantidad_db       := 0;
    p_sfs_archivos_bpd_h_t.monto_total_db    := 0;
    p_sfs_archivos_bpd_h_t.numero_afiliacion := 0;
    p_sfs_archivos_bpd_h_t.fecha             := sysdate;
    p_sfs_archivos_bpd_h_t.hora              := sysdate;
    p_sfs_archivos_bpd_h_t.e_mail            := v_email;
    p_sfs_archivos_bpd_h_t.estatus           := '';
    p_sfs_archivos_bpd_h_t.filler            := '';
    p_sfs_archivos_bpd_h_t.secuencia         := p_secuencia;
    p_sfs_archivos_bpd_h_t.cantidad_cr       := v_cantidad_registro;
    p_sfs_archivos_bpd_h_t.monto_total_cr    := v_monto_subsidio;
    p_sfs_archivos_bpd_h_t.tipo_subsidio     := 'M';

    --- Salvo el Header----------------
    SaveDataHeaderPopular(p_sfs_archivos_bpd_h_t);

  end GetDataHeaderPopular;

  -- ------------------------------------------
  procedure GetDataDetallePopular(p_nro_lote  sub_cuotas_t.nro_lote%TYPE,
                                  p_secuencia sfs_archivos_bpd_d_t.secuencia%type) is
    v_secuencia_trans      number := 0;
    v_sfs_archivos_bpd_d_t sfs_archivos_bpd_d_t%rowtype;

    cursor c_detalle is
      select cu.cuenta_banco cuenta_destino,
             cu.tipo_cuenta tipo_cuenta_destino,
             e.ruta_y_transito cod_banco_destino,
             e.digito_chequeo digi_ver_banco_destino,
             sum(cu.monto_subsidio) monto_transaccion,
             substr(em.razon_social, 1, 35) nombre,
             cu.periodo numero_referencia,
             case
               when length(em.email) > 40 then
                null
               else
                em.email
             end e_mail_benef,
             em.fax fax_telefono_benef
        from sub_cuotas_t cu
        join sub_solicitud_t s
          on s.nro_solicitud = cu.nro_solicitud
        join sub_sfs_maternidad_t m
          on m.nro_solicitud = cu.nro_solicitud
         and m.id_registro_patronal = cu.id_registro_patronal
        join sfc_entidad_recaudadora_t e
          on e.id_entidad_recaudadora = cu.id_entidad_recaudadora
        join sre_ciudadanos_t c
          on c.id_nss = s.nss
        join sre_empleadores_t em
          on em.id_registro_patronal = m.id_registro_patronal
       where cu.via = 'CB'
         and cu.status_dispersion = 'D'
         and cu.nro_lote = p_nro_lote
       group by cu.cuenta_banco,
                cu.tipo_cuenta,
                ruta_y_transito,
                digito_chequeo,
                em.razon_social,
                cu.periodo,
                em.email,
                em.fax
                    union all
      select em.cuenta_banco cuenta_destino,
             em.tipo_cuenta tipo_cuenta_destino,
             e.ruta_y_transito cod_banco_destino,
             e.digito_chequeo digi_ver_banco_destino,
             sum(a.monto_ajuste) monto_transaccion,
             substr(em.razon_social, 1, 35) nombre,
             t.periodo_aplicacion numero_referencia,
             case
               when length(em.email) > 40 then
                null
               else
                em.email
             end e_mail_benef,
             em.fax fax_telefono_benef
                from sub_ajustes_t a
                join sfc_trans_ajustes_t t on a.id_ajuste = t.id_ajuste
                join sre_empleadores_t em on a.id_registro_patronal = em.id_registro_patronal
                join sfc_entidad_recaudadora_t e on e.id_entidad_recaudadora =  em.id_entidad_recaudadora
               where a.status = 'DI'
                 and a.nro_lote = p_nro_lote
               group by em.cuenta_banco,
                        em.tipo_cuenta,
                        e.ruta_y_transito,
                        e.digito_chequeo,
                        em.razon_social,
                        t.periodo_aplicacion,
                        em.email,
                        em.fax;

  begin

    for v_detalle_record in c_detalle loop
      v_secuencia_trans := v_secuencia_trans + 1;

      v_sfs_archivos_bpd_d_t.tipo_registro          := 'N';
      v_sfs_archivos_bpd_d_t.id_compania            := '424002037';
      v_sfs_archivos_bpd_d_t.secuencia              := p_secuencia;
      v_sfs_archivos_bpd_d_t.secuencia_trans        := v_secuencia_trans;
      v_sfs_archivos_bpd_d_t.cuenta_destino         := v_detalle_record.cuenta_destino;
      v_sfs_archivos_bpd_d_t.tipo_cuenta_destino    := v_detalle_record.tipo_cuenta_destino;
      v_sfs_archivos_bpd_d_t.moneda_destino         := '214';
      v_sfs_archivos_bpd_d_t.cod_banco_destino      := v_detalle_record.cod_banco_destino;
      v_sfs_archivos_bpd_d_t.digi_ver_banco_destino := v_detalle_record.digi_ver_banco_destino;

      if v_sfs_archivos_bpd_d_t.tipo_cuenta_destino = '1' then
        v_sfs_archivos_bpd_d_t.codigo_operacion := '22';
      else
        v_sfs_archivos_bpd_d_t.codigo_operacion := '32';
      end if;

      v_sfs_archivos_bpd_d_t.monto_transaccion      := v_detalle_record.monto_transaccion;
      v_sfs_archivos_bpd_d_t.tipo_de_identificacion := null;
      v_sfs_archivos_bpd_d_t.identificacion         := null;
      v_sfs_archivos_bpd_d_t.nombre                 := v_detalle_record.nombre;
      v_sfs_archivos_bpd_d_t.numero_referencia      := v_detalle_record.numero_referencia;
      v_sfs_archivos_bpd_d_t.desc_estado_destino    := 'Pago Sisalril Subsidio Maternidad';
      v_sfs_archivos_bpd_d_t.fecha_vencimiento      := null;
      v_sfs_archivos_bpd_d_t.forma_de_contacto      := ' ';

      v_sfs_archivos_bpd_d_t.e_mail_benef           := v_detalle_record.e_mail_benef;
      v_sfs_archivos_bpd_d_t.fax_telefono_benef     := v_detalle_record.fax_telefono_benef;
      v_sfs_archivos_bpd_d_t.filler_futuro          := '00';
      v_sfs_archivos_bpd_d_t.numero_aut             := null;
      v_sfs_archivos_bpd_d_t.codigo_retorno_remoto  := null;
      v_sfs_archivos_bpd_d_t.codigo_razon_remoto    := null;
      v_sfs_archivos_bpd_d_t.codigo_razon_interno   := null;
      v_sfs_archivos_bpd_d_t.procesador_transaccion := null;
      v_sfs_archivos_bpd_d_t.estatus_transaccion    := null;
      v_sfs_archivos_bpd_d_t.filler                 := null;

      -------Salvo el Detalle-------
      SaveDataDetallePopular(v_sfs_archivos_bpd_d_t);
    end loop;

  end GetDataDetallePopular;

  Procedure GetHeaderEnfComun(p_nrolote   In suirplus.sub_cuotas_t.nro_lote%Type,
                              p_secuencia sfs_archivos_bpd_h_t.secuencia%type) Is
    v_monto_subsidio       suirplus.sub_cuotas_t.monto_subsidio%type;
    v_cantidad_registro    integer;
    v_monto_ajuste       sub_cuotas_t.monto_subsidio%type;
    v_cantidad_ajuste    integer;
    p_sfs_archivos_bpd_h_t sfs_archivos_bpd_h_t%ROWTYPE;

    v_email varchar2(50);
  begin

    SELECT valor_texto
      into v_email
      FROM sfc_det_parametro_t
     WHERE id_parametro = 353
       AND nvl(fecha_fin, sysdate) =
           (SELECT MAX(nvl(fecha_fin, sysdate))
              FROM sfc_det_parametro_t
             WHERE id_parametro = 353);

    select sum(monto_transaccion) monto_subsidio, count(*)
      into v_monto_subsidio, v_cantidad_registro
      from (select distinct cu.cuenta_banco cuenta_destino,
                            cu.tipo_cuenta tipo_cuenta_destino,
                            e.ruta_y_transito cod_banco_destino,
                            e.digito_chequeo digi_ver_banco_destino,
                            sum(cu.monto_subsidio) monto_transaccion,
                            substr(em.razon_social, 1, 35) nombre,
                            cu.periodo numero_referencia,
                            em.email e_mail_benef,
                            em.fax fax_telefono_benef
              from sub_cuotas_t cu
              join sub_solicitud_t s
                on s.nro_solicitud = cu.nro_solicitud
              join sub_sfs_enf_comun_t ef
                on ef.nro_solicitud = cu.nro_solicitud
               and ef.id_registro_patronal = cu.id_registro_patronal
              join sfc_entidad_recaudadora_t e
                on e.id_entidad_recaudadora = cu.id_entidad_recaudadora
              join sre_ciudadanos_t c
                on c.id_nss = s.nss
              join sre_empleadores_t em
                on em.id_registro_patronal = ef.id_registro_patronal
             where cu.via = 'CB'
               and cu.status_dispersion = 'D'
               and cu.nro_lote = p_nrolote
             group by cu.cuenta_banco,
                      cu.tipo_cuenta,
                      ruta_y_transito,
                      digito_chequeo,
                      em.razon_social,
                      cu.periodo,
                      em.email,
                      em.fax) a;


                      select sum(monto_transaccion) monto_subsidio, count(*)
                       into v_monto_ajuste,v_cantidad_ajuste
      from (select distinct em.cuenta_banco cuenta_destino,
                            em.tipo_cuenta tipo_cuenta_destino,
                            e.ruta_y_transito cod_banco_destino,
                            e.digito_chequeo digi_ver_banco_destino,
                            sum(t.monto_ajuste) monto_transaccion,
                            substr(em.razon_social, 1, 35) nombre,
                            t.periodo_aplicacion numero_referencia,
                            em.email e_mail_benef,
                            em.fax fax_telefono_benef
                from sub_ajustes_t a
                join sfc_trans_ajustes_t t on a.id_ajuste = t.id_ajuste
                join sre_empleadores_t em on a.id_registro_patronal = em.id_registro_patronal
                join sfc_entidad_recaudadora_t e on e.id_entidad_recaudadora =  em.id_entidad_recaudadora
               where a.status = 'DI'
                 and a.nro_lote = p_nrolote
               group by em.cuenta_banco,
                        em.tipo_cuenta,
                        e.ruta_y_transito,
                        e.digito_chequeo,
                        em.razon_social,
                        t.periodo_aplicacion,
                        em.email,
                        em.fax) b;

           v_monto_subsidio := v_monto_subsidio + nvl(v_monto_ajuste,0);
           v_cantidad_registro := v_cantidad_registro + nvl(v_cantidad_ajuste,0);



    p_sfs_archivos_bpd_h_t.tipo_registro     := 'H';
    p_sfs_archivos_bpd_h_t.id_compania       := '424002037-1'; --4240020371
    p_sfs_archivos_bpd_h_t.nombre_compania   := substr('SUPERINTENDENCIA DE SALUD Y RIESGOS LABORALES',
                                                       1,
                                                       35);
    p_sfs_archivos_bpd_h_t.tipo_servicio     := 2;
    p_sfs_archivos_bpd_h_t.fecha_efectiva    := sysdate;
    p_sfs_archivos_bpd_h_t.cantidad_db       := 0;
    p_sfs_archivos_bpd_h_t.monto_total_db    := 0;
    p_sfs_archivos_bpd_h_t.numero_afiliacion := 0;
    p_sfs_archivos_bpd_h_t.fecha             := sysdate;
    p_sfs_archivos_bpd_h_t.hora              := sysdate;
    p_sfs_archivos_bpd_h_t.e_mail            := v_email;
    p_sfs_archivos_bpd_h_t.estatus           := '';
    p_sfs_archivos_bpd_h_t.filler            := '';
    p_sfs_archivos_bpd_h_t.secuencia         := p_secuencia;
    p_sfs_archivos_bpd_h_t.cantidad_cr       := v_cantidad_registro;
    p_sfs_archivos_bpd_h_t.monto_total_cr    := v_monto_subsidio;
    p_sfs_archivos_bpd_h_t.tipo_subsidio     := 'E';

    --- Salvo el Header----------------
    SaveDataHeaderPopular(p_sfs_archivos_bpd_h_t);

  End GetHeaderEnfComun;

  Procedure GetDetalleEnfComun(p_nro_lote  sub_cuotas_t.nro_lote%TYPE,
                               p_secuencia sfs_archivos_bpd_d_t.secuencia%type) Is
    v_secuencia_trans      number := 0;
    v_sfs_archivos_bpd_d_t sfs_archivos_bpd_d_t%rowtype;

    cursor c_detalle is
      select cu.cuenta_banco cuenta_destino,
             cu.tipo_cuenta tipo_cuenta_destino,
             e.ruta_y_transito cod_banco_destino,
             e.digito_chequeo digi_ver_banco_destino,
             sum(cu.monto_subsidio) monto_transaccion,
             substr(em.razon_social, 1, 35) nombre,
             cu.periodo numero_referencia,
             case
               when length(em.email) > 40 then
                null
               else
                em.email
             end e_mail_benef,
             em.fax fax_telefono_benef
        from sub_cuotas_t cu
        join sub_solicitud_t s
          on s.nro_solicitud = cu.nro_solicitud
        join sub_sfs_enf_comun_t ef
          on ef.nro_solicitud = cu.nro_solicitud
         and ef.id_registro_patronal = cu.id_registro_patronal
        join sfc_entidad_recaudadora_t e
          on e.id_entidad_recaudadora = cu.id_entidad_recaudadora
        join sre_ciudadanos_t c
          on c.id_nss = s.nss
        join sre_empleadores_t em
          on em.id_registro_patronal = ef.id_registro_patronal
       where cu.via = 'CB'
         and cu.status_dispersion = 'D'
         and cu.nro_lote = p_nro_lote
       group by cu.cuenta_banco,
                cu.tipo_cuenta,
                ruta_y_transito,
                digito_chequeo,
                em.razon_social,
                cu.periodo,
                em.email,
                em.fax
                union all
             select em.cuenta_banco cuenta_destino,
                    em.tipo_cuenta tipo_cuenta_destino,
                    e.ruta_y_transito cod_banco_destino,
                    e.digito_chequeo digi_ver_banco_destino,
                    sum(t.monto_ajuste) monto_transaccion,
                    substr(em.razon_social, 1, 35) nombre,
                    t.periodo_aplicacion numero_referencia,
                    case
                      when length(em.email) > 40 then
                       null
                      else
                       em.email
                    end e_mail_benef,
                    em.fax fax_telefono_benef
               from sub_ajustes_t a
               join sfc_trans_ajustes_t t on a.id_ajuste = t.id_ajuste
               join sre_empleadores_t em on a.id_registro_patronal = em.id_registro_patronal
               join sfc_entidad_recaudadora_t e on e.id_entidad_recaudadora = em.id_entidad_recaudadora
               where a.status = 'DI'
                and a.nro_lote = p_nro_lote
              group by em.cuenta_banco,
                       em.tipo_cuenta,
                       e.ruta_y_transito,
                       e.digito_chequeo,
                       em.razon_social,
                       t.periodo_aplicacion,
                       em.email,
                       em.fax;
  Begin
    for v_detalle_record in c_detalle loop
      v_secuencia_trans := v_secuencia_trans + 1;

      v_sfs_archivos_bpd_d_t.tipo_registro          := 'N';
      v_sfs_archivos_bpd_d_t.id_compania            := '424002037-1'; --4240020371
      v_sfs_archivos_bpd_d_t.secuencia              := p_secuencia;
      v_sfs_archivos_bpd_d_t.secuencia_trans        := v_secuencia_trans;
      v_sfs_archivos_bpd_d_t.cuenta_destino         := v_detalle_record.cuenta_destino;
      v_sfs_archivos_bpd_d_t.tipo_cuenta_destino    := v_detalle_record.tipo_cuenta_destino;
      v_sfs_archivos_bpd_d_t.moneda_destino         := '214';
      v_sfs_archivos_bpd_d_t.cod_banco_destino      := v_detalle_record.cod_banco_destino;
      v_sfs_archivos_bpd_d_t.digi_ver_banco_destino := v_detalle_record.digi_ver_banco_destino;

      if v_sfs_archivos_bpd_d_t.tipo_cuenta_destino = '1' then
        v_sfs_archivos_bpd_d_t.codigo_operacion := '22';
      else
        v_sfs_archivos_bpd_d_t.codigo_operacion := '32';
      end if;

      v_sfs_archivos_bpd_d_t.monto_transaccion      := v_detalle_record.monto_transaccion;
      v_sfs_archivos_bpd_d_t.tipo_de_identificacion := null;
      v_sfs_archivos_bpd_d_t.identificacion         := null;
      v_sfs_archivos_bpd_d_t.nombre                 := v_detalle_record.nombre;
      v_sfs_archivos_bpd_d_t.numero_referencia      := v_detalle_record.numero_referencia;
      v_sfs_archivos_bpd_d_t.desc_estado_destino    := 'Pago Sisalril Subsidio Enfermedad Comun';
      v_sfs_archivos_bpd_d_t.fecha_vencimiento      := null;
      v_sfs_archivos_bpd_d_t.forma_de_contacto      := ' ';

      v_sfs_archivos_bpd_d_t.e_mail_benef           := v_detalle_record.e_mail_benef;
      v_sfs_archivos_bpd_d_t.fax_telefono_benef     := v_detalle_record.fax_telefono_benef;
      v_sfs_archivos_bpd_d_t.filler_futuro          := '00';
      v_sfs_archivos_bpd_d_t.numero_aut             := null;
      v_sfs_archivos_bpd_d_t.codigo_retorno_remoto  := null;
      v_sfs_archivos_bpd_d_t.codigo_razon_remoto    := null;
      v_sfs_archivos_bpd_d_t.codigo_razon_interno   := null;
      v_sfs_archivos_bpd_d_t.procesador_transaccion := null;
      v_sfs_archivos_bpd_d_t.estatus_transaccion    := null;
      v_sfs_archivos_bpd_d_t.filler                 := null;

      -------Salvo el Detalle-------
      SaveDataDetallePopular(v_sfs_archivos_bpd_d_t);
    end loop;
  End GetDetalleEnfComun;

  Function Validarcuotas(p_nrosolicitud In sub_solicitud_t.nro_solicitud%Type)
    Return Integer Is
    v_Registros Integer := 0;
    v_resultdo  integer := 0;
  Begin
    For Registros In (Select Sec.Id_Registro_Patronal,
                             Sec.Id_Nss,
                             Sec.Padecimiento,
                             Sec.Secuencia,
                             Min(Sec.Nro_Pago) As Minimo,
                             Max(Sec.Nro_Pago) As Maximo,
                             sec.nro_solicitud
                        From sisalril_suir.Sfs_Subs_Enf_t Sec
                       Where Sec.Nro_Solicitud = p_nrosolicitud
                       Group By Sec.Nro_Lote,
                                Sec.Id_Registro_Patronal,
                                Sec.Id_Nss,
                                Sec.Padecimiento,
                                Sec.Secuencia,
                                sec.nro_solicitud) Loop
      v_resultdo := 1;
      For Reg In Registros.Minimo .. Registros.Maximo Loop

        Select Count(*)
          Into v_Registros
          From sisalril_suir.Sfs_Subs_Enf_t Se
         Where se.nro_solicitud = Registros.Nro_Solicitud;

        If Not (v_Registros > 0) Then
          v_resultdo := 0;
        End If;
      End Loop;
    End Loop;
    return v_resultdo;
  End Validarcuotas;

  Function ValidarCuotasMaternidad(p_nrosolicitud In sub_solicitud_t.nro_solicitud%Type)
    Return Integer Is
    v_Registros Integer := 0;
    v_resultdo  integer := 0;
  Begin
    For Registros In (Select Sec.Id_Registro_Patronal,
                             Sec.Id_Nss_Madre,
                             Sec.Secuencia,
                             Min(Sec.Nro_Pago) As Minimo,
                             Max(Sec.Nro_Pago) As Maximo,
                             sec.nro_solicitud
                        From sisalril_suir.sfs_subs_maternidad_t Sec
                       Where Sec.Nro_Solicitud = p_nrosolicitud
                       Group By Sec.Nro_Lote,
                                Sec.Id_Registro_Patronal,
                                Sec.Id_Nss_Madre,
                                Sec.Secuencia,
                                sec.nro_solicitud) Loop
      v_resultdo := 1;
      For Reg In Registros.Minimo .. Registros.Maximo Loop

        Select Count(*)
          Into v_Registros
          From sisalril_suir.sfs_subs_maternidad_t Se
         Where se.nro_solicitud = Registros.Nro_Solicitud;

        If Not (v_Registros > 0) Then
          v_resultdo := 0;
        End If;
      End Loop;
    End Loop;
    return v_resultdo;
  End ValidarCuotasMaternidad;


  /*Recibir elegibles*/
  Procedure RecibirLactantes(p_result out varchar2) Is
    v_bitacora         sfc_bitacora_t.id_bitacora%Type;
    m_bitacora_sec     integer;
    m_bitacora_msg     Varchar2(200);
    m_bitacora_return  SEG_ERROR_T.id_error%TYPE;
    v_Count            Integer := 0;
    v_Nro_Lote         Integer := 0;
    v_salario          sub_cuotas_t.monto_subsidio%type;
    v_cantidadLactante number := 0;
    -- Leer la vista sisalril_suir.sfs_nov_cuentas_t;
    Cursor v_Cursor Is
      Select L2.Rowid Id, L1.Status, L2.Nro_Solicitud
        From Sisalril_Suir.Sfs_Lactantes_t L1
        Join Suirplus.sub_lactantes_t L2 On L2.nro_solicitud =
                                            L1.nro_solicitud
                                        and l2.secuencia_lactante =
                                            l1.secuencia_lactante
                                        and L2.estatus = 'PE'
                                        and l1.status != 'PE';
  Begin

    InsertarBitacora('RL', v_bitacora);

    v_Nro_Lote := Getproximonumerolote();

    -- Insertar el registro como pendiente el InsertarCarga-
    InsertarCarga(v_Nro_Lote,
                  null,
                  'P',
                  'R',
                  'Sisalril_Suir.Sfs_Lactantes_t');

    For v_Record In v_Cursor

     Loop

      Update sub_lactantes_t
         Set estatus = Decode(v_Record.Status, 'OK', 'AC', v_Record.Status) -- Status de la Sisalril
       Where Rowid = v_Record.Id;

      select count(*)
        into v_cantidadLactante
        from sub_lactantes_t
       where nro_solicitud = v_Record.Nro_Solicitud
         and estatus = 'AC';


      if v_cantidadLactante > 0 then
         v_salario := getMontoSubsidioLactancia(v_Record.Nro_Solicitud);

        v_salario := v_salario * v_cantidadLactante;

        update sub_cuotas_t cu
           set cu.monto_subsidio = v_salario
         where cu.nro_solicitud = v_Record.Nro_Solicitud
           and cu.status_dispersion = 'C';

      else
        update sub_cuotas_t cu
           set cu.status_dispersion   = 'R',
               cu.fecha_dispersion    = sysdate,
               cu.id_error_dispersion = 64
         where cu.nro_solicitud = v_Record.Nro_Solicitud
           and cu.status_dispersion = 'C';
      end if;

      v_Count := v_Count + 1;

    End Loop;

    commit;

    -- Marcar como completado en sfs_subs_cargar_t--
    ActualizarCarga(v_Nro_Lote, v_Count, 0, 'C', null);

    -- Actualizar el resultado del proceso en la bitacora
    m_Bitacora_Msg := 'OK. Lote: ' || v_Nro_Lote;
    ActualizarBitacora(m_bitacora_sec, m_bitacora_msg, 'O', '000');

    p_result := '0';
  Exception
    When Others Then
      Rollback;

      -- Actualizar el resultado del proceso en la bitacora
      m_Bitacora_Return := 650;
      m_Bitacora_Msg    := Substr('ERROR. Lote: ' || v_Nro_Lote || '. ' ||
                                  Sqlerrm,
                                  1,
                                  200);

      p_result := m_Bitacora_Msg;
      ActualizarBitacora(m_bitacora_sec,
                         m_bitacora_msg,
                         'E',
                         m_bitacora_return);

      --Marcar con error en la tabla de Cargar---
      ActualizarCarga(v_Nro_Lote, v_Count, 0, 'E', null);

  End;

  Procedure RecibirElegibles(p_result out varchar2) As
    v_bitacora     sfc_bitacora_t.id_bitacora%Type;
    v_error        Varchar2(1000);
    v_resultnumber VARCHAR2(1000);
    e_elegible     exception;
    e_actualizando exception;
    v_Id_Estatus         sub_estatus_t.id_estatus%type;
    v_id_ajuste          sfc_trans_ajustes_t.id_ajuste%type;
    m_paso               Integer := 0;
    v_salario            sub_cuotas_t.monto_subsidio%type;
    v_Sysdate            Date := Sysdate;
    v_Start_Date         Date;
    v_Min_Billing_Date   Date;
    v_Fecha_Enf          Date;
    v_Start_Date_Enf     Date;
    v_Periodo_Inicio_Enf sub_cuotas_t.periodo%Type;
    v_Nro_Pago           sub_cuotas_t.nro_pago%Type;
    v_Periodo            sub_cuotas_t.periodo%Type;
    v_Periodo_Inicio     sub_cuotas_t.periodo%Type;
    v_Periodo_Fin        sub_cuotas_t.periodo%Type;
    v_cantidadLactante   number := 0;
    b_solicitud suirplus.sub_elegibles_t.nro_solicitud%type;
    b_id_registro_patronal suirplus.sub_elegibles_t.registro_patronal%type;
    --
    cursor c_RecibidosNoOK is
      Select s.*, se.id_estatus, s.rowid
        From Sisalril_Suir.Sfs_Elegibles_t s
        join (select *
                from suirplus.sub_elegibles_t e
               where e.id_elegibles =
                     (select max(id_elegibles)
                        from suirplus.sub_elegibles_t
                       where nro_solicitud = e.nro_solicitud and registro_patronal = e.registro_patronal)) e
          on s.nro_solicitud = e.nro_solicitud
          and s.id_registro_patronal = e.registro_patronal
        join suirplus.sub_estatus_t st
          on e.id_estatus = st.id_estatus
        join suirplus.sub_estatus_t se
          on s.estatus = se.descripcion
       where e.id_estatus not in (2, 3)
         and s.estatus not in ('OK', 'CA')
         and s.estatus != st.descripcion;

    cursor c_RecibidosOK is
      Select distinct s.*, st.id_estatus, s.rowid
        From Sisalril_Suir.Sfs_Elegibles_t s
        join (select *
                from suirplus.sub_elegibles_t e
               where e.id_elegibles =
                     (select max(id_elegibles)
                        from suirplus.sub_elegibles_t
                      where nro_solicitud = e.nro_solicitud and registro_patronal = e.registro_patronal)) e
          on s.nro_solicitud = e.nro_solicitud
          and s.id_registro_patronal = e.registro_patronal
        join suirplus.sub_estatus_t st
          on e.id_estatus = st.id_estatus
       where s.estatus = 'OK'
         and e.id_estatus in (1, 7, 9, 6,8)
         and not e.nro_solicitud in
              (select lac.nro_solicitud
                    from sub_lactantes_t lac
                   where lac.nro_solicitud = e.nro_solicitud
                     and lac.estatus = 'PE');

  Begin

    InsertarBitacora('RS', v_bitacora);

    --Procesando los No OK--
    For e In c_RecibidosNoOK Loop
      --Insertando el elegible
      InsertarElegible(e.nro_solicitud,
                       e.id_registro_patronal,
                       e.salario_cotizable,
                       e.id_error,
                       e.fecha_error,
                       e.fecha_envio,
                       sysdate,
                       e.fecha_registro,
                       e.id_estatus,
                       e.categoria_salario,
                       e.nro_lote,
                       e.id_nomina,
                       e.cuota,
                       e.nro_solicitud_sisalril,
                       v_resultnumber);

 If (v_resultnumber = '0') then
        --Actualizando el subsidio
        ActualizarSubsidios(e.tipo_subsidio,
                            e.id_estatus,
                            e.nro_solicitud,
                            e.id_registro_patronal,
                            v_resultnumber);

	If (v_resultnumber = '0') Then
     If (e.id_estatus = 3) then
        --Borrando el registro procesado
         Delete from Sisalril_Suir.Sfs_Elegibles_t s
         Where s.rowid = e.rowid;
         Commit;         
     End If;
     
     If (e.id_estatus = 3 and e.tipo_subsidio = 'L') Then
        --Borrando el registro procesado
        Update suirplus.sub_lactantes_t t
          Set t.estatus = 'RE'
        Where t.nro_solicitud = e.nro_solicitud;
        Commit;
        End if;
     End if;

 End if;
End Loop;

    --Procesando los OK--
    -- Verificar fecha Inicio de facturacion--
    Select d.Valor_Fecha
      Into v_Min_Billing_Date
      From Sfc_Det_Parametro_t d
     Inner Join Sfc_Parametros_t p
        On d.Id_Parametro = p.Id_Parametro
     Where d.Id_Parametro = 40
       And d.Fecha_Fin Is Null;


    if ( to_char(v_Sysdate,'YYYYMM') > to_char(v_Min_Billing_Date,'YYYYMM'))  then
     v_Min_Billing_Date := Add_Months(v_Min_Billing_Date, 1);
    end if;

    If v_Sysdate < v_Min_Billing_Date Then
      v_Start_Date := v_Sysdate;
    Else
      v_Start_Date := Add_Months(v_Sysdate, 1);
    End If;

    v_Periodo_Inicio := Suirplus.Parm.Periodo_Vigente(v_Start_Date);

    v_Periodo  := v_Periodo_Inicio;
    v_Nro_Pago := 0;

    -- Buscar la fecha de inicio del subsido de ENF COMUN--
    Select d.Valor_Fecha
      Into v_Fecha_Enf
      From Sfc_Det_Parametro_t d
     Inner Join Sfc_Parametros_t p
        On d.Id_Parametro = p.Id_Parametro
     Where d.Id_Parametro = 42
       And d.Fecha_Fin Is Null;

    If (v_Fecha_Enf > v_Start_Date) Then
      v_Start_Date_Enf := v_Fecha_Enf;
    Else
      v_Start_Date_Enf := v_Start_Date;
    End If;

    v_Periodo_Inicio_Enf := Parm.Periodo_Vigente(v_Start_Date_Enf);

    For o In c_RecibidosOK Loop
      v_Periodo    := v_Periodo_Inicio;
      v_Id_Estatus := 2;
      --Si el tipo subsidio es maternidad agregamos las 3 coutas
      if (o.tipo_subsidio = 'M') then

        Update sisalril_suir.sfs_subs_maternidad_t ma
           Set ma.periodo = to_Char(add_months(To_Date(v_Periodo_Inicio,
                                                       'YYYYMM'),
                                               (ma.nro_pago - 1)),
                                    'YYYYMM')
         Where ma.status_dispersion = 'C'
           And ma.via = 'CU'
           and ma.nro_solicitud = o.nro_solicitud;

        if ValidarCuotasMaternidad(o.nro_solicitud) != 0 then

        For c in(Select o.id_registro_patronal id_registro_patronal,
                   o.id_nomina id_nomina,
                   ma.periodo                    As periodo_aplicacion,
                   o.id_nss id_nss,
                   '1' id_tipo_ajuste,
                   'PE' estatus,
                   ma.monto_subsidio monto_subsidio,
                   sfc_trans_ajustes_seq.nextval id_ajuste,
                   Sysdate                       As FECHA_REGISTRO,
                  ma.nro_lote||'.'||ma.periodo||'.'||ma.id_registro_patronal||'.'||ma.id_nss_madre||'.'||ma.nro_pago||'.'||ma.tipo_pago||'.'||ma.secuencia unico,
                   ma.nro_pago                   id,
                   o.nro_solicitud nro_solicitud
              from sisalril_suir.sfs_subs_maternidad_t ma
             Where ma.nro_solicitud = o.nro_solicitud
             And ma.id_registro_patronal = o.id_registro_patronal
               And ma.status_dispersion = 'C'
               And ma.via = 'CU')

       Loop

       IF suirplus.sub_sfs_dispersion.ValidarAjustesDuplicados(c.unico) = false THEN
       --Capturamos valores para identificar la Solicitud en caso de que este duplicada
       b_solicitud:= c.nro_solicitud;
       b_id_registro_patronal:= c.id_registro_patronal;
       
          --Insertando en TransAjuste
          Insert Into suirplus.sfc_trans_ajustes_t
            (id_registro_patronal,
             id_nomina,
             periodo_aplicacion,
             id_nss,
             id_tipo_ajuste,
             estatus,
             monto_ajuste,
             id_ajuste,
             FECHA_REGISTRO,
             unico,
             id)
            values(
            c.id_registro_patronal,
            c.id_nomina,
            c.periodo_aplicacion,
            c.id_nss,
            c.id_tipo_ajuste,
            c.estatus,
            c.monto_subsidio,
            c.id_ajuste,
            c.fecha_registro,
            c.unico,
            c.id
            );

          --Insertando las cuotas
          Insert Into Suirplus.sub_cuotas_t
            (Id_cuota,
             Nro_Lote,
             nro_solicitud,
             Via,
             Id_Entidad_Recaudadora,
             Tipo_Cuenta,
             Cuenta_Banco,
             Nro_Referencia,
             Monto_Subsidio,
             Nro_Pago,
             Periodo,
             Status_Dispersion,
             Id_Error_Dispersion,
             Status_Pago,
             Id_Error_Pago,
             Ult_Fecha_Act,
             Id_Ajuste,
             tipo_subsidio,
             id_registro_patronal)
            Select SUB_SFS_DISPERSION.GetProximoNumeroCuota,
                   see.Nro_Lote,
                   c.nro_solicitud,
                   see.Via,
                   see.Id_Entidad_Recaudadora,
                   see.Tipo_Cuenta,
                   see.Cuenta_Banco,
                   see.Nro_Referencia,
                   see.Monto_Subsidio,
                   see.Nro_Pago,
                   see.Periodo,
                   NVL(see.Status_Dispersion,'G'),
                   see.Id_Error_Dispersion,
                   NVL(see.Status_Pago,'N'),
                   see.Id_Error_Pago,
                   see.Ult_Fecha_Act,
                   c.id_ajuste,
                   'M',
                   see.id_registro_patronal
              from sisalril_suir.sfs_subs_maternidad_t see
              Where see.nro_lote||'.'||see.periodo||'.'||see.id_registro_patronal||'.'||see.id_nss_madre||'.'||see.nro_pago||'.'||see.tipo_pago||'.'||see.secuencia = c.unico
               And see.status_dispersion = 'C'
               And see.via = 'CU';

                END IF;
         End loop;

        else
          --Actualizando a IC
          Update sisalril_suir.sfs_elegibles_t e
             Set e.estatus = 'IC', e.ult_fecha_act = sysdate
           where e.nro_solicitud = o.nro_solicitud;

          v_Id_Estatus := 9;
        end if;


        --Si el tipo subsidio es Lactancia agregamos las 12 coutas
      elsif (o.tipo_subsidio = 'L') then

       --Insertando el elegible
      InsertarElegible(o.nro_solicitud,
                       o.id_registro_patronal,
                       o.salario_cotizable,
                       o.id_error,
                       o.fecha_error,
                       o.fecha_envio,
                       sysdate,
                       o.fecha_registro,
                       v_Id_Estatus,
                       o.categoria_salario,
                       o.nro_lote,
                       o.id_nomina,
                       o.cuota,
                       o.nro_solicitud_sisalril,
                       v_resultnumber);

If (v_resultnumber = '0') then
 --Actualizando el subsidio
   ActualizarSubsidios(o.tipo_subsidio,
                            v_Id_Estatus,
                            o.nro_solicitud,
                            o.id_registro_patronal,
                            v_resultnumber);

 If (v_resultnumber = '0') then

  If (v_Id_Estatus = 2) Then
    --Borrando el registro procesado
     Delete from Sisalril_Suir.Sfs_Elegibles_t s
     Where s.rowid = o.rowid;     
  End If;
  
  Commit;
End If;

          select count(*)
          into v_cantidadLactante
          from sub_lactantes_t
         where nro_solicitud = o.nro_solicitud
           and estatus = 'AC';

        v_Periodo_Fin := to_Char(add_months(To_Date(v_Periodo_Inicio,
                                                    'YYYYMM'),
                                            11),
                                 'YYYYMM');

        v_Periodo  := v_Periodo_Inicio;
        v_Nro_Pago := 0;

        v_salario := getMontoSubsidioLactancia(o.nro_solicitud);

        if v_cantidadLactante > 0 then
          v_salario := v_salario * v_cantidadLactante;
        end if;

        Loop
          v_Nro_Pago := v_Nro_Pago + 1;

          Insert Into Suirplus.sub_cuotas_t
            (Id_cuota,
             Nro_Lote,
             nro_solicitud,
             Monto_Subsidio,
             Nro_Pago,
             Periodo,
             Status_Dispersion,
             Status_Pago,
             Tipo_Pago,
             Tipo_subsidio,
             via,
             Tipo,
             ID_REGISTRO_PATRONAL)
          values
            (SUB_SFS_DISPERSION.GetProximoNumeroCuota,
             0,
             o.nro_solicitud,
             v_salario,
             v_Nro_Pago,
             v_Periodo,
             'C',
             'N',
             'O',
             'L',
             'CB',
             'M',
             o.id_registro_patronal);

          v_Periodo := to_Char(add_months(To_Date(v_Periodo, 'YYYYMM'), 1),
                               'YYYYMM');

          EXIT WHEN v_Periodo > v_Periodo_Fin;
        End Loop;

         commit;
      end if;

        --Si el tipo subsidio es Enfermedad Comun
      elsif (o.tipo_subsidio = 'E') then
        --Obtener el Periodo de Cada Cuota
        Update sisalril_suir.sfs_subs_enf_t ef
           Set ef.periodo = to_Char(add_months(To_Date(v_Periodo_Inicio_Enf,
                                                       'YYYYMM'),
                                               (ef.nro_pago - 1)),
                                    'YYYYMM')
         Where ef.status_dispersion = 'C'
           And ef.via = 'CU'
           and ef.nro_solicitud = o.nro_solicitud;

        if Validarcuotas(o.nro_solicitud) != 0 then

           For c in (Select o.id_registro_patronal id_registro_patronal,
                        o.id_nomina id_nomina,
                        ef.periodo              periodo_aplicacion,
                        o.id_nss id_nss,
                        '2' id_tipo_ajuste,
                        'PE' estatus,
                        ef.monto_subsidio monto_subsidio,
                        sfc_trans_ajustes_seq.nextval id_ajuste,
                        Sysdate                       As FECHA_REGISTRO,
                        ef.nro_solicitud||'.'||ef.padecimiento||'.'||ef.secuencia||'.'||ef.nro_pago||'.'||ef.id_registro_patronal unico,
                        ef.nro_pago                   id,
                        ef.nro_solicitud nro_solicitud
              from sisalril_suir.sfs_subs_enf_t ef
              Where ef.nro_solicitud = o.nro_solicitud
              And ef.id_registro_patronal = o.id_registro_patronal
              And ef.status_dispersion = 'C'
              And ef.via = 'CU')

         Loop

       IF suirplus.sub_sfs_dispersion.ValidarAjustesDuplicados(c.unico) = false THEN
         --Capturamos valores para identificar la Solicitud en caso de que este duplicada
       b_solicitud:=c.nro_solicitud;
       b_id_registro_patronal:= c.id_registro_patronal;
         
       
         --Insertando en TransAjuste
          Insert Into suirplus.sfc_trans_ajustes_t
            (id_registro_patronal,
             id_nomina,
             periodo_aplicacion,
             id_nss,
             id_tipo_ajuste,
             estatus,
             monto_ajuste,
             id_ajuste,
             FECHA_REGISTRO,
             unico,
             id)
             values(
             c.id_registro_patronal,
             c.id_nomina,
             c.periodo_aplicacion,
             c.id_nss,
             c.id_tipo_ajuste,
             c.estatus,
             c.monto_subsidio,
             c.id_ajuste,
             c.fecha_registro,
             c.unico,
             c.id);

          --Insertando las cuotas
          Insert Into Suirplus.sub_cuotas_t
            (Id_cuota,
             Nro_Lote,
             nro_solicitud,
             Via,
             Id_Entidad_Recaudadora,
             Tipo_Cuenta,
             Cuenta_Banco,
             Nro_Referencia,
             Monto_Subsidio,
             Nro_Pago,
             Periodo,
             Status_Dispersion,
             Id_Error_Dispersion,
             Status_Pago,
             Id_Error_Pago,
             Ult_Fecha_Act,
             Id_Ajuste,
             tipo_subsidio,
             id_registro_patronal)
            Select SUB_SFS_DISPERSION.GetProximoNumeroCuota,
                   see.Nro_Lote,
                   c.nro_solicitud,
                   see.Via,
                   see.Id_Entidad_Recaudadora,
                   see.Tipo_Cuenta,
                   see.Cuenta_Banco,
                   see.Nro_Referencia,
                   see.Monto_Subsidio,
                   see.Nro_Pago,
                   see.Periodo,
                   NVL(see.Status_Dispersion,'G'),
                   see.Id_Error_Dispersion,
                   NVL(see.Status_Pago,'N'),
                   see.Id_Error_Pago,
                   see.Ult_Fecha_Act,
                   c.id_ajuste,
                   'E',
                   see.id_registro_patronal
              from sisalril_suir.sfs_subs_enf_t see
               Where (see.nro_solicitud||'.'||see.padecimiento||'.'||see.secuencia||'.'||see.nro_pago||'.'||see.id_registro_patronal) = c.unico
               And see.status_dispersion = 'C'
               And see.via = 'CU';

            END IF;
         End loop;

        else
          --Actualizando a IC
          Update sisalril_suir.sfs_elegibles_t e
             Set e.estatus = 'IC', e.ult_fecha_act = sysdate
           where e.nro_solicitud = o.nro_solicitud;

          v_Id_Estatus := 9;
        end if;

      End if;

    if (o.tipo_subsidio != 'L') then
      --Insertando el elegible
      InsertarElegible(o.nro_solicitud,
                       o.id_registro_patronal,
                       o.salario_cotizable,
                       o.id_error,
                       o.fecha_error,
                       o.fecha_envio,
                       sysdate,
                       o.fecha_registro,
                       v_Id_Estatus,
                       o.categoria_salario,
                       o.nro_lote,
                       o.id_nomina,
                       o.cuota,
                       o.nro_solicitud_sisalril,
                       v_resultnumber);

      If (v_resultnumber = '0') Then
        --Actualizando el subsidio
        ActualizarSubsidios(o.tipo_subsidio,
                            v_Id_Estatus,
                            o.nro_solicitud,
                            o.id_registro_patronal,
                            v_resultnumber);

       If (v_resultnumber = '0') Then
          If (v_Id_Estatus = 2) Then
            --Borrando el registro procesado
            Delete from Sisalril_Suir.Sfs_Elegibles_t s
             Where s.rowid = o.rowid;
          End if;
          Commit;
       End if;
     End if;     
	End if;
 End Loop;

    v_result := 'OK';
    ActualizarBitacora(v_bitacora, v_result, 'O', '000');

    p_result := '0';

  Exception
    When Others Then
      Rollback;
      v_error := sqlerrm || ' - ' || v_result;
      ActualizarBitacora(v_bitacora ||' '|| 'NumeroSolicitud:' ||' '|| b_solicitud ||' '|| 'RegistroPatronal:' ||' '|| b_id_registro_patronal, v_error, 'E', '650');
      p_result := v_error;

  End RecibirElegibles;

  Procedure RecibirCuentasBancarias(p_result out varchar2) Is
    v_bitacora        sfc_bitacora_t.id_bitacora%Type;
    m_bitacora_sec    integer;
    m_bitacora_msg    Varchar2(200);
    m_bitacora_return SEG_ERROR_T.id_error%TYPE;
    v_Count           Integer := 0;
    v_Nro_Lote        Integer := 0;
    -- Leer la vista sisalril_suir.sfs_nov_cuentas_t;
    Cursor v_Cursor Is
      Select c.Id_Nss,
             c.Secuencia,
             c.Cuenta_Banco,
             c.Ult_Fecha_Act,
             s.nro_solicitud
        From Sisalril_Suir.Sfs_Nov_Cuentas_t c
        join sub_solicitud_t s
          on s.nss = c.id_nss
         and s.secuencia = c.secuencia
         and s.tipo_subsidio = 'L';
  Begin

    InsertarBitacora('RC', v_bitacora);

    v_Nro_Lote := Getproximonumerolote();

    -- Insertar el registro como pendiente el InsertarCarga-
    InsertarCarga(v_Nro_Lote,
                  null,
                  'P',
                  'R',
                  'SISALRIL_SUIR.SFS_NOV_CUENTAS_T');

    For v_Record In v_Cursor

     Loop

      -- Insertar esos registros en la tabla del esquema suirplus que se llama de igual forma
      Insert Into Suirplus.SUB_NOV_CUENTAS_T
        (Id_Nss, Secuencia, Cuenta_Banco, Ult_Fecha_Act, nro_solicitud)
      Values
        (v_Record.Id_Nss,
         v_Record.Secuencia,
         v_Record.Cuenta_Banco,
         v_Record.Ult_Fecha_Act,
         v_Record.Nro_Solicitud);

      v_Count := v_Count + 1;

      -- Actualizar la Cuenta en SUBS a las Cuotas Pendientes.....
      Update sub_cuotas_t l
         set l.cuenta_banco = v_Record.Cuenta_Banco
       where l.nro_solicitud = v_Record.Nro_Solicitud;

    End Loop;

    -- elimino los datos del esquema de sisalril sisalril_suir.sfs_nov_cuentas_t
    Delete From Sisalril_Suir.Sfs_Nov_Cuentas_t;

    commit;

    -- Marcar como completado en sfs_subs_cargar_t--
    ActualizarCarga(v_Nro_Lote, v_Count, 0, 'C', null);

    -- Actualizar el resultado del proceso en la bitacora
    m_Bitacora_Msg := 'OK. Lote: ' || v_Nro_Lote;
    ActualizarBitacora(m_bitacora_sec, m_bitacora_msg, 'O', '000');

    p_result := '0';
  Exception
    When Others Then
      Rollback;

      -- Actualizar el resultado del proceso en la bitacora
      m_Bitacora_Return := 650;
      m_Bitacora_Msg    := Substr('ERROR. Lote: ' || v_Nro_Lote || '. ' ||
                                  Sqlerrm,
                                  1,
                                  200);

      p_result := m_Bitacora_Msg;
      ActualizarBitacora(m_bitacora_sec,
                         m_bitacora_msg,
                         'E',
                         m_bitacora_return);

      --Marcar con error en la tabla de Cargar---
      ActualizarCarga(v_Nro_Lote, v_Count, 0, 'E', null);

  End;

  -- ------------------------------------------
  procedure GenerarDispersionLactancia(p_periodo in sub_cuotas_t.periodo%type,
                                       p_result  out varchar2) is
    m_bitacora_return SEG_ERROR_T.id_error%TYPE;
    m_bitacora_sec    integer;
    m_bitacora_msg    Varchar2(200);
    v_nro_lote        integer := 0;
  begin

    if p_periodo is not null then

      -- Insertar el registro en la bitacora de procesos
      Insertarbitacora('GL', m_bitacora_sec);

      v_nro_lote := getProximoNumeroLote();

      For Generados In (

                        select c.rowid
                          from sub_cuotas_t c
                          join sub_sfs_lactancia_t l
                            on l.nro_solicitud = c.nro_solicitud
                           and l.id_estatus = 2
                          join sub_lactantes_t la
                            on la.nro_solicitud = c.nro_solicitud
                           and la.estatus = 'AC'
                         where c.periodo <= p_periodo
                           and c.nro_lote = 0
                           and c.status_dispersion = 'C'
                           and c.tipo_pago = 'O'
                           and c.cuenta_banco is not null

                        UNION ALL

                        select c.rowid
                          from sub_cuotas_t c
                          join sub_sfs_lactancia_t l
                            on l.nro_solicitud = c.nro_solicitud
                           and l.id_estatus != 5
                          join sub_lactantes_t la
                            on la.nro_solicitud = c.nro_solicitud
                           and la.estatus = 'AC'
                         where c.nro_lote = 0
                           and c.status_dispersion = 'C'
                           and c.tipo_pago != 'O'
                           and c.cuenta_banco is not null

                        ) Loop
        Update Suirplus.sub_cuotas_t c
           Set c.Status_Dispersion = 'G',
               c.Nro_Lote          = v_nro_lote,
               c.status_proceso    = 'PE'
         Where c.Rowid = Generados.Rowid;
      end Loop;

      commit;
      -- Actualizar el resultado del proceso en la bitacora
      m_bitacora_msg := 'OK. Lote: ' || v_nro_lote;
      p_result       := m_bitacora_msg;

      ActualizarBitacora(m_bitacora_sec, m_bitacora_msg, 'O', '000');
    else
      p_result := 'Debe especificar un periodo';
    end if;
  exception
    when others then
      rollback;
      -- Actualizar el resultado del proceso en la bitacora
      m_bitacora_return := 650;

      m_bitacora_msg := substr('ERROR. Lote: ' || v_nro_lote || '. ' ||
                               sqlerrm,
                               1,
                               200);
      p_result       := m_bitacora_msg;

      ActualizarBitacora(m_bitacora_sec,
                         m_bitacora_msg,
                         'E',
                         m_bitacora_return);

  end GenerarDispersionLactancia;

  -- ------------------------------------------
  procedure GenerarDispersionMaternidad(p_periodo in sub_cuotas_t.Periodo%type,
                                        p_result  out varchar2) is
    m_bitacora_return SEG_ERROR_T.id_error%TYPE;
    m_bitacora_sec    integer;
    m_bitacora_msg    Varchar2(200);
    v_nro_lote        integer := 0;
    v_result          Varchar2(1000);
  begin
    if p_periodo is not null then
      -- Insertar el registro en la bitacora de procesos
      Insertarbitacora('GM', m_bitacora_sec);

      v_nro_lote := getProximoNumeroLote();

      For generados In (

                        Select c.rowid,
                                c.Id_Ajuste,
                                c.nro_referencia,
                                em.tipo_cuenta,
                                em.cuenta_banco,
                                em.id_entidad_recaudadora
                          From sub_cuotas_t c
                          Join sub_sfs_maternidad_t m
                            On m.nro_solicitud = c.nro_solicitud
                           and m.id_registro_patronal =
                               c.id_registro_patronal
                           and m.id_estatus = 2
                          Join Sfc_Trans_Ajustes_t ta
                            on ta.id_ajuste = c.id_ajuste
                           And Ta.Estatus = 'PE'
                           And ta.id_tipo_ajuste = '1'
                           And Ta.Periodo_Aplicacion <= p_Periodo
                          Join sre_empleadores_t em
                            On em.id_registro_patronal =
                               m.id_registro_patronal
                           And em.status = 'A'
                         where c.via = 'CU'
                           and c.periodo <= p_Periodo
                           And c.status_dispersion = 'C'
                           and em.pago_subsidios in ('B','M')
                           And not exists
                         (Select 1
                                  from sfc_facturas_t a
                                 where a.id_registro_patronal =
                                       m.id_registro_patronal
                                   and a.periodo_factura = p_periodo
                                   and a.status = 'VE'
                                   and a.no_autorizacion is null)

                        ) Loop

        Update Suirplus.sub_cuotas_t Ma
           Set Ma.Via                    = 'CB',
               ma.tipo_cuenta            = generados.tipo_cuenta,
               ma.cuenta_banco           = generados.cuenta_banco,
               ma.status_pago            = 'N',
               ma.tipo_pago              = 'O',
               ma.id_entidad_recaudadora = generados.id_entidad_recaudadora,
               ma.ult_fecha_act          = Sysdate,
               Ma.Nro_Lote               = v_nro_lote,
               Ma.Status_Dispersion      = 'G',
               ma.status_proceso         = 'PE'
         Where ma.rowid = generados.rowid;

        suirplus.sfc_ajustes_pkg.MarcarGenerado(generados.id_ajuste,
                                                generados.nro_referencia,
                                                v_result);

      End Loop;



       --Nuevo Metodo para manejar Debitos y Creditos
       for c_cursor_record in (
          select a.id_ajuste,
                 a.id_sub_ajuste,
                 a.id_registro_patronal,
                 a.id_nss id_nss_madre,
                 e.tipo_cuenta,
                 e.cuenta_banco,
                 e.id_entidad_recaudadora,
                 a.monto_ajuste,
                 t.periodo_aplicacion periodo,
                 t.id_tipo_ajuste tipo_ajuste
            from sub_ajustes_t a
            join sfc_trans_ajustes_t t on a.id_ajuste = t.id_ajuste
            join sre_empleadores_t e on a.id_registro_patronal = e.id_registro_patronal
           where t.estatus = 'PE' and a.status = 'OK'
           /*and a.id_tipo_ajuste in (8, 6) Modificacion por Ticket 7667*/
           and a.id_tipo_ajuste in (8)
           and t.periodo_aplicacion <= p_periodo and e.pago_subsidios in ('B','M')

   ) Loop

            --Actualizando en SuirPlus
            update suirplus.sub_ajustes_t b
               set b.status           = 'GE',
                   b.fecha_dispersion = sysdate,
                   b.nro_lote = v_nro_lote
             where b.id_ajuste = c_Cursor_Record.Id_Ajuste;

             suirplus.sfc_ajustes_pkg.MarcarGenerado(c_Cursor_Record.Id_Ajuste,
                                                Null,
                                                v_result);

    End Loop;



      commit;

      -- Actualizar el resultado del proceso en la bitacora

      m_bitacora_msg := 'OK. Lote: ' || v_nro_lote;
      p_result       := m_bitacora_msg;

      ActualizarBitacora(m_bitacora_sec, m_bitacora_msg, 'O', '000');
    else
      p_result := 'Debe especificar un periodo';
    end if;
  exception
    when others then
      rollback;
      -- Actualizar el resultado del proceso en la bitacora
      m_bitacora_return := 650;

      m_bitacora_msg := substr('ERROR. Lote: ' || v_nro_lote || '. ' ||
                               sqlerrm,
                               1,
                               200);
      p_result       := m_bitacora_msg;
      ActualizarBitacora(m_bitacora_sec,
                         m_bitacora_msg,
                         'E',
                         m_bitacora_return);

  end GenerarDispersionMaternidad;

  Procedure GenerarDispersionEnfComun(p_periodo in suirplus.sub_cuotas_t.Periodo%type,
                                      p_result  out varchar2) Is
    m_bitacora_return SEG_ERROR_T.id_error%TYPE;
    m_bitacora_sec    integer;
    m_bitacora_msg    Varchar2(200);
    v_nro_lote        integer := 0;
    v_result          Varchar2(1000);
  Begin
    if p_periodo is not null then

      -- Insertar el registro en la bitacora de procesos
      Insertarbitacora('GE', m_bitacora_sec);

      v_nro_lote := getProximoNumeroLote();

      For generados In (

                        Select c.rowid,
                                c.Id_Ajuste,
                                c.nro_referencia,
                                em.cuenta_banco,
                                em.tipo_cuenta,
                                em.id_entidad_recaudadora
                          From Suirplus.sub_cuotas_t c
                          join sub_sfs_enf_comun_t e
                            on e.nro_solicitud = c.nro_solicitud
                           and e.id_registro_patronal =
                               c.id_registro_patronal
                           and e.id_estatus = 2
                          Join Sfc_Trans_Ajustes_t Ta
                            On Ta.Id_Ajuste = c.id_ajuste
                           And Ta.Estatus = 'PE'
                           And ta.id_tipo_ajuste = '2'
                           And Ta.Periodo_Aplicacion <= p_periodo
                          Join sre_empleadores_t em
                            On em.id_registro_patronal =
                               e.id_registro_patronal
                         Where c.via = 'CU'
                           And c.periodo <= p_periodo
                           And c.status_dispersion = 'C'
                           and em.pago_subsidios in ('B','M')
                           )

       Loop

        Update Suirplus.sub_cuotas_t c
           Set c.Via                    = 'CB',
               c.Nro_Lote               = v_nro_lote,
               c.Status_Dispersion      = 'G',
               c.status_pago            = 'N',
               c.tipo_cuenta            = generados.tipo_cuenta,
               c.cuenta_banco           = generados.cuenta_banco,
               c.id_entidad_recaudadora = generados.id_entidad_recaudadora,
               c.ULT_FECHA_ACT          = SYSDATE,
               c.status_proceso         = 'PE'
         Where c.rowid = generados.rowid;

        suirplus.sfc_ajustes_pkg.MarcarGenerado(generados.id_ajuste,
                                                Null,
                                                v_result);

      End Loop;


        --Nuevo Metodo para manejar Debitos y Creditos
       for c_cursor_record in (
          select a.id_ajuste,
                 a.id_sub_ajuste,
                 a.id_registro_patronal,
                 a.id_nss id_nss_madre,
                 e.tipo_cuenta,
                 e.cuenta_banco,
                 e.id_entidad_recaudadora,
                 a.monto_ajuste,
                 t.periodo_aplicacion periodo,
                 t.id_tipo_ajuste tipo_ajuste
            from sub_ajustes_t a
            join sfc_trans_ajustes_t t on a.id_ajuste = t.id_ajuste
            join sre_empleadores_t e on a.id_registro_patronal = e.id_registro_patronal
           where t.estatus = 'PE' and a.status = 'OK'
           /*and a.id_tipo_ajuste in (9, 7)- Modificacion por Ticket 7667*/
           and a.id_tipo_ajuste in (9)
           and t.periodo_aplicacion <= p_periodo
           and e.pago_subsidios in ('B','M')

   ) Loop


            --Actualizando en SuirPlus
            update suirplus.sub_ajustes_t b
               set b.status           = 'GE',
                   b.fecha_dispersion = sysdate,
                   b.nro_lote = v_nro_lote
             where b.id_ajuste = c_Cursor_Record.Id_Ajuste;


             suirplus.sfc_ajustes_pkg.MarcarGenerado(c_Cursor_Record.id_ajuste,
                                                Null,
                                                v_result);


    End Loop;


      commit;
      -- Actualizar el resultado del proceso en la bitacora

      m_bitacora_msg := 'OK. Lote: ' || v_nro_lote;

      p_result := m_bitacora_msg;

      ActualizarBitacora(m_bitacora_sec, m_bitacora_msg, 'O', '000');
    else
      p_result := 'Debe especificar un periodo';
    end if;
  exception
    when others then
      rollback;
      -- Actualizar el resultado del proceso en la bitacora
      m_bitacora_return := 650;
      m_bitacora_msg    := substr('ERROR. Lote: ' || v_nro_lote || '. ' ||
                                  sqlerrm,
                                  1,
                                  200);
      p_result          := m_bitacora_msg;
      ActualizarBitacora(m_bitacora_sec,
                         m_bitacora_msg,
                         'E',
                         m_bitacora_return);

  End GenerarDispersionEnfComun;

  Procedure PublicarDispersionLactancia(p_result out varchar2) Is
    v_Count           Integer;
    v_Cantidad        Integer := 0;
    v_Nro_Lote        Integer := 0;
    m_bitacora_return SEG_ERROR_T.id_error%TYPE;
    m_bitacora_sec    integer;
    m_bitacora_msg    Varchar2(200);
  Begin
    --Insertar en Bitacora
    Insertarbitacora('DL', m_bitacora_sec);

    Select Count(*)
      Into v_Count
      From sub_cuotas_t
     Where Nro_Lote In (Select Max(Nro_Lote)
                          From sub_cuotas_t
                         where tipo_subsidio = 'L'
                           and status_dispersion = 'G'
                           and status_proceso = 'PE');

    If v_Count > 0 Then
      -- Buscar en la sub_cuotas_t del esquema SUIRPLUS el ultimo (max) NroLote y se llevan todos esos
      Select Max(Nro_Lote)
        Into v_Nro_Lote
        From sub_cuotas_t
       where tipo_subsidio = 'L'
         and status_dispersion = 'G'
         and status_proceso = 'PE';

      -- Insertar un registro en la tabla SFS_SUBS_CARGA_T en estatus en proceso para la carga de la SISALRIL
      InsertarCarga(v_Nro_Lote,
                    'L',
                    'P',
                    'P',
                    'SISALRIL_SUIR.SFS_SFS_SUBS_LACTANCIA_T');

      -- registros hacia el esquema de la SISALRIL.
      Insert Into Sisalril_Suir.Sfs_Subs_Lactancia_t
        (Nro_Lote,
         Id_Nss_Madre,
         Secuencia,
         Id_Nss_Tutor,
         Tipo,
         Secuencia_Lactante,
         Id_Nss_Lactante,
         Cuenta_Banco,
         Monto_Subsidio,
         Nro_Pago,
         Periodo,
         Status_Dispersion,
         Fecha_Dispersion,
         Id_Error_Dispersion,
         Status_Pago,
         Fecha_Pago,
         Id_Error_Pago,
         Tipo_Pago,
         NRO_SOLICITUD)
        Select distinct c.Nro_Lote,
                        s.nss,
                        s.Secuencia,
                        m.nss_tutor,
                        c.tipo,
                        l.secuencia_lactante,
                        l.id_nss_lactante,
                        c.Cuenta_Banco,
                        (c.Monto_Subsidio / lact.cant) monto,
                        c.Nro_Pago,
                        c.Periodo,
                        c.Status_Dispersion,
                        c.Fecha_Dispersion,
                        c.Id_Error_Dispersion,
                        c.Status_Pago,
                        c.Fecha_Pago,
                        c.Id_Error_Pago,
                        c.Tipo_Pago,
                        c.nro_solicitud
          From sub_cuotas_t c
          join sub_solicitud_t s
            on s.nro_solicitud = c.nro_solicitud
          join sub_sfs_lactancia_t la
            on la.nro_solicitud = c.nro_solicitud
          join sub_lactantes_t l
            on l.nro_solicitud = c.nro_solicitud
--          join sub_maternidad_t m
          join sfs_maternidad_v m
            on m.nro_solicitud = la.nro_solicitud_mat
          join (select lac.nro_solicitud, count(*) cant
                  from sub_lactantes_t lac
                 where lac.estatus = 'AC'
                 group by nro_solicitud) lact
            on c.nro_solicitud = lact.nro_solicitud
         Where c.Nro_Lote = v_Nro_Lote
           and c.tipo_subsidio = 'L'
           and l.estatus = 'AC'
           And Not
                v_Nro_Lote In (Select Nro_Lote
                                 From Sisalril_Suir.Sfs_Subs_Lactancia_t
                                Where Nro_Lote = v_Nro_Lote);
      Commit;

      select count(*)
        into v_Cantidad
        from sub_cuotas_t
       where nro_lote = v_Nro_Lote;

      --Marcar como procesado en Cargar--
      ActualizarCarga(v_Nro_Lote, v_Cantidad, 0, 'C', null);
    end if;

    -- Actualizar el resultado del proceso en la bitacora
    m_Bitacora_Msg := 'OK. Lote: ' || v_Nro_Lote;
    ActualizarBitacora(m_bitacora_sec, m_bitacora_msg, 'O', '000');

    p_result := m_Bitacora_Msg;
  Exception
    When Others Then
      Rollback;

      -- Actualizar el resultado del proceso en la bitacora
      m_Bitacora_Return := 650;
      m_Bitacora_Msg    := Substr('ERROR. Lote: ' || v_Nro_Lote || '. ' ||
                                  Sqlerrm,
                                  1,
                                  200);

      ActualizarBitacora(m_bitacora_sec,
                         m_bitacora_msg,
                         'E',
                         m_bitacora_return);

      --Marcar con error en la tabla de Cargar---
      ActualizarCarga(v_Nro_Lote, v_Cantidad, 0, 'E', null);

      p_result := m_Bitacora_Msg;
  End PublicarDispersionLactancia;

  Procedure PublicarDispersionMaternidad(p_result out varchar2) Is

    v_Count           Integer;
    v_Cantidad        Integer := 0;
    v_Nro_Lote        Integer := 0;
    m_bitacora_return SEG_ERROR_T.id_error%TYPE;
    m_bitacora_sec    integer;
    m_bitacora_msg    Varchar2(200);
  Begin

    -- Insertar el registro en la bitacora de procesos
    Insertarbitacora('DM', m_bitacora_sec);

    -- Buscar en la SFS_SUBS_MATERNIDAD_T del esquema SUIRPLUS el ultimo (max) NroLote y se llevan todos esos
    select Count(*)
      Into v_Count
      From sub_cuotas_t
     Where Nro_Lote In (Select Max(Nro_Lote)
                          From sub_cuotas_t
                         where tipo_subsidio = 'M'
                           and status_dispersion = 'G'
                           and status_proceso = 'PE');

    If v_Count > 0 Then

      Select Max(Nro_Lote)
        Into v_Nro_Lote
        From sub_cuotas_t
       where tipo_subsidio = 'M'
         and status_dispersion = 'G'
         and status_proceso = 'PE';

      -- Insertar un registro en la tabla SFS_SUBS_CARGA_T en estatus en proceso para la carga de la SISALRIL
      InsertarCarga(v_Nro_Lote,
                    'M',
                    'P',
                    'P',
                    'SISALRIL_SUIR.SFS_SUBS_MATERNIDAD_T');

      Insert Into Sisalril_Suir.Sfs_Subs_Maternidad_t
        (Nro_Lote,
         Id_Registro_Patronal,
         Id_Nss_Madre,
         Secuencia,
         Via,
         Id_Entidad_Recaudadora,
         Tipo_Cuenta,
         Cuenta_Banco,
         Nro_Referencia,
         Monto_Subsidio,
         Nro_Pago,
         Periodo,
         Status_Dispersion,
         Fecha_Dispersion,
         Id_Error_Dispersion,
         Status_Pago,
         Fecha_Pago,
         Id_Error_Pago,
         Tipo_Pago,
         ult_fecha_act,
         NRO_SOLICITUD)
        Select distinct c.Nro_Lote,
               m.id_registro_patronal,
               s.nss,
               s.Secuencia,
               c.Via,
               c.Id_Entidad_Recaudadora,
               c.Tipo_Cuenta,
               c.Cuenta_Banco,
               c.Nro_Referencia,
               c.Monto_Subsidio,
               c.Nro_Pago,
               c.Periodo,
               c.Status_Dispersion,
               c.Fecha_Dispersion,
               c.Id_Error_Dispersion,
               c.Status_Pago,
               c.Fecha_Pago,
               c.Id_Error_Pago,
               c.Tipo_Pago,
               c.ult_fecha_act,
               c.nro_solicitud
          From sub_cuotas_t c
          join sub_solicitud_t s
            on s.nro_solicitud = c.nro_solicitud
          join sub_sfs_maternidad_t m
            on m.nro_solicitud = c.nro_solicitud
           and m.id_registro_patronal = c.id_registro_patronal
         Where Nro_Lote = v_Nro_Lote;


          --Nuevo Metodo para manejar Debitos y Creditos
       for c_cursor_record in (
          select a.id_ajuste,
                 a.id_sub_ajuste,
                 a.id_registro_patronal,
                 a.id_nss id_nss_madre,
                 e.tipo_cuenta,
                 e.cuenta_banco,
                 e.id_entidad_recaudadora,
                 a.monto_ajuste,
                 t.periodo_aplicacion periodo,
                 t.id_tipo_ajuste tipo_ajuste,
                 a.id_ajuste secuencia
            from sub_ajustes_t a
            join sfc_trans_ajustes_t t on a.id_ajuste = t.id_ajuste
            join sre_empleadores_t e on a.id_registro_patronal = e.id_registro_patronal
           where t.estatus = 'GE' and a.status = 'GE' and a.nro_lote = v_Nro_Lote

   ) Loop


           Insert Into Sisalril_Suir.Sfs_Subs_Maternidad_t
             (Nro_Lote,
              Id_Registro_Patronal,
              Id_Nss_Madre,
              Via,
              Id_Entidad_Recaudadora,
              TIPO_CUENTA,
              CUENTA_BANCO,
              Monto_Subsidio,
              Nro_Pago,
              Periodo,
              Status_Dispersion,
              Fecha_Dispersion,
              Status_Pago,
              Fecha_Pago,
              Tipo_Pago,
              ID_TIPO_AJUSTE,
              ULT_FECHA_ACT,
              ID_AJUSTE,
              SECUENCIA)
           values
             (v_nro_lote,
              c_Cursor_Record.id_registro_patronal,
              c_Cursor_Record.id_nss_madre,
              'CB',
              c_Cursor_Record.id_entidad_recaudadora,
              c_Cursor_Record.tipo_cuenta,
              c_Cursor_Record.cuenta_banco,
              c_Cursor_Record.monto_ajuste,
              0,
              c_Cursor_Record.periodo,
              'G',
              sysdate,
              'N',
              sysdate,
              'O',
              c_Cursor_Record.tipo_ajuste,
              sysdate,
              c_Cursor_Record.Id_Ajuste,
              c_Cursor_Record.Secuencia);



    End Loop;



      commit;

      select count(*)
        into v_Cantidad
        from sub_cuotas_t
       where nro_lote = Nro_Lote;

      --Marcar como procesado en Cargar--
      ActualizarCarga(v_Nro_Lote, v_Cantidad, 0, 'C', null);
    End If;

    -- Actualizar el resultado del proceso en la bitacora
    m_Bitacora_Msg := 'OK. Lote: ' || v_Nro_Lote;
    ActualizarBitacora(m_bitacora_sec, m_bitacora_msg, 'O', '000');

    p_result := m_Bitacora_Msg;
  Exception
    When Others Then
      Rollback;

      -- Actualizar el resultado del proceso en la bitacora
      m_Bitacora_Return := 650;
      m_Bitacora_Msg    := Substr('ERROR. Lote: ' || v_Nro_Lote || '. ' ||
                                  Sqlerrm,
                                  1,
                                  200);

      ActualizarBitacora(m_bitacora_sec,
                         m_bitacora_msg,
                         'E',
                         m_bitacora_return);

      --Marcar con error en la tabla de Cargar---
      ActualizarCarga(v_Nro_Lote, v_Cantidad, 0, 'E', null);

      p_result := m_Bitacora_Msg;
  End;

  Procedure PublicarDispersionEnfComun(p_result out varchar2) Is
    v_Count           Integer;
    v_Cantidad        Integer := 0;
    v_Nro_Lote        Integer := 0;
    m_bitacora_return SEG_ERROR_T.id_error%TYPE;
    m_bitacora_sec    integer;
    m_bitacora_msg    Varchar2(200);
  Begin
    --busco el secuencial para este proceso
    Insertarbitacora('DE', m_bitacora_sec);

    -- Buscar en la SFS_SUBS_ENF_COMUN del esquema SUIRPLUS el ultimo (max) NroLote y se llevan todos esos
    -- registros hacia el esquema de la SISALRIL.
    Select Count(*)
      Into v_Count
      From sub_cuotas_t
     Where Nro_Lote In (Select Max(ef2.Nro_Lote)
                          From suirplus.sub_cuotas_t ef2
                         where tipo_subsidio = 'E'
                           and status_dispersion = 'G'
                           and status_proceso = 'PE');

    If v_Count > 0 Then

      Select Max(ef2.Nro_Lote)
        Into v_Nro_Lote
        From suirplus.sub_cuotas_t ef2
       where tipo_subsidio = 'E'
         and status_dispersion = 'G'
         and status_proceso = 'PE';

      -- Insertar un registro en la tabla SFS_SUBS_CARGA_T en estatus en proceso para la carga de la SISALRIL
      InsertarCarga(v_Nro_Lote,
                    'M',
                    'P',
                    'P',
                    'SISALRIL_SUIR.SFS_SUBS_ENF');

      Insert into sisalril_suir.sfs_subs_enf_t
        (NRO_LOTE,
         ID_REGISTRO_PATRONAL,
         ID_NSS,
         PADECIMIENTO,
         SECUENCIA,
         VIA,
         ID_ENTIDAD_RECAUDADORA,
         TIPO_CUENTA,
         CUENTA_BANCO,
         NRO_REFERENCIA,
         MONTO_SUBSIDIO,
         NRO_PAGO,
         PERIODO,
         STATUS_DISPERSION,
         ID_ERROR_DISPERSION,
         STATUS_PAGO,
         ID_ERROR_PAGO,
         ULT_FECHA_ACT,
         FECHA_DISPERSION,
         FECHA_PAGO,
         NRO_SOLICITUD)
        Select c.nro_lote,
               e.id_registro_patronal,
               s.nss,
               s.padecimiento,
               s.secuencia,
               c.via,
               c.id_entidad_recaudadora,
               c.tipo_cuenta,
               c.cuenta_banco,
               c.nro_referencia,
               c.monto_subsidio,
               c.nro_pago,
               c.periodo,
               c.status_dispersion,
               c.id_error_dispersion,
               c.status_pago,
               c.id_error_pago,
               c.ult_fecha_act,
               c.fecha_dispersion,
               c.fecha_pago,
               c.nro_solicitud
          from suirplus.sub_cuotas_t c
          join sub_solicitud_t s
            on s.nro_solicitud = c.nro_solicitud
          join sub_sfs_enf_comun_t e
            on e.nro_solicitud = c.nro_solicitud
           and e.id_registro_patronal = c.id_registro_patronal
         Where c.Nro_Lote = v_Nro_Lote;


           --Nuevo Metodo para manejar Debitos y Creditos
       for c_cursor_record in (
          select a.id_ajuste,
                 a.id_sub_ajuste,
                 a.id_registro_patronal,
                 a.id_nss id_nss_madre,
                 e.tipo_cuenta,
                 e.cuenta_banco,
                 e.id_entidad_recaudadora,
                 a.monto_ajuste,
                 t.periodo_aplicacion periodo,
                 t.id_tipo_ajuste tipo_ajuste,
                 a.id_ajuste SECUENCIA
            from sub_ajustes_t a
            join sfc_trans_ajustes_t t on a.id_ajuste = t.id_ajuste
            join sre_empleadores_t e on a.id_registro_patronal = e.id_registro_patronal
           where t.estatus = 'GE' and a.status = 'GE' and a.nro_lote = v_Nro_Lote

   ) Loop

             Insert Into Sisalril_Suir.sfs_subs_enf_t
             (Nro_Lote,
              Id_Registro_Patronal,
              ID_NSS,
              Via,
              Id_Entidad_Recaudadora,
              tipo_cuenta,
              cuenta_banco,
              Monto_Subsidio,
              Nro_Pago,
              Periodo,
              Status_Dispersion,
              Fecha_Dispersion,
              Status_Pago,
              Fecha_Pago,
              ID_TIPO_AJUSTE,
              ID_AJUSTE,
              ULT_FECHA_ACT,
              secuencia)
           values
             (v_nro_lote,
              c_Cursor_Record.id_registro_patronal,
              c_Cursor_Record.id_nss_madre,
              'CB',
              c_Cursor_Record.id_entidad_recaudadora,
              c_Cursor_Record.tipo_cuenta,
              c_Cursor_Record.cuenta_banco,
              c_Cursor_Record.monto_ajuste,
              0,
              c_Cursor_Record.periodo,
              'G',
              sysdate,
              'N',
              sysdate,
              c_Cursor_Record.tipo_ajuste,
              c_Cursor_Record.ID_AJUSTE,
              sysdate,
              c_Cursor_Record.Secuencia);

    End Loop;

      commit;
      select count(*)
        into v_Cantidad
        from sub_cuotas_t
       where nro_lote = v_Nro_Lote;

      --Marcar como procesado en Cargar--
      ActualizarCarga(v_Nro_Lote, v_Cantidad, 0, 'C', null);
    End If;

    -- Actualizar el resultado del proceso en la bitacora
    m_Bitacora_Msg := 'OK. Lote: ' || v_Nro_Lote;
    ActualizarBitacora(m_bitacora_sec, m_bitacora_msg, 'O', '000');

    p_result := m_Bitacora_Msg;
  Exception
    When Others Then
      Rollback;

      -- Actualizar el resultado del proceso en la bitacora
      m_Bitacora_Return := 650;
      m_Bitacora_Msg    := Substr('ERROR. Lote: ' || v_Nro_Lote || '. ' ||
                                  Sqlerrm,
                                  1,
                                  200);

      ActualizarBitacora(m_bitacora_sec,
                         m_bitacora_msg,
                         'E',
                         m_bitacora_return);

      --Marcar con error en la tabla de Cargar---
      ActualizarCarga(v_Nro_Lote, v_Cantidad, 0, 'E', null);
      p_result := m_Bitacora_Msg;
  End PublicarDispersionEnfComun;

  Procedure RecibirDispersionLactancia(p_Result Out Varchar2) Is
    v_Count           Integer := 0;
    v_Nrolote         Integer := 0;
    v_Cantidad        Integer := 0;
    m_bitacora_return SEG_ERROR_T.id_error%TYPE;
    m_bitacora_sec    integer;
    m_bitacora_msg    Varchar2(200);

    Cursor c_Cursor(p_lote varchar2) Is
      Select Nro_Lote,
             Id_Nss_Madre,
             Secuencia,
             Id_Nss_Tutor,
             Tipo,
             Secuencia_Lactante,
             Id_Nss_Lactante,
             Cuenta_Banco,
             Monto_Subsidio,
             Nro_Pago,
             Periodo,
             Status_Dispersion,
             Fecha_Dispersion,
             Id_Error_Dispersion,
             Status_Pago,
             Fecha_Pago,
             Id_Error_Pago,
             Nro_Lote_Nuevo,
             tipo_pago,
             nro_solicitud
        From Sisalril_Suir.Sfs_Subs_Lactancia_t l
       Where l.Status_Dispersion In ('D', 'R')
         And l.Status_Pago = 'N'
         And Nro_Lote = p_lote;

  Begin

    select max(nro_lote)
      into v_Nrolote
      from sub_cuotas_t c
     where tipo_subsidio = 'L'
       and status_dispersion = 'G'
       and status_proceso = 'PE';

    -- Insertar el registro en la bitacora de procesos
    Insertarbitacora('TL', m_bitacora_sec);

    --Insertar un registro en sfs_subs_carga_t en estatus 'P' (En Proceso)
    InsertarCarga(v_NroLote,
                  'L',
                  'P',
                  'R',
                  'sisalril_suir.sfs_subs_lactancia_t');

    For v_Record In c_Cursor(v_Nrolote) Loop

      Update Suirplus.sub_cuotas_t c
         Set c.Status_Dispersion   = v_Record.Status_Dispersion,
             c.Fecha_Dispersion    = v_Record.Fecha_Dispersion,
             c.Id_Error_Dispersion = v_Record.Id_Error_Dispersion
       Where c.nro_solicitud = v_Record.Nro_Solicitud
         And c.Nro_Pago = v_Record.Nro_Pago
         And c.Nro_Lote = v_Record.Nro_Lote
         and c.tipo_pago = v_Record.tipo_pago;

      v_Count := v_Count + 1;
    End Loop;

    --Marcar como procesado en Cargar--
    ActualizarCarga(v_Nrolote, v_Count, 0, 'C', null);

    m_Bitacora_Msg := 'El proceso con el nro_lote ' || '' || v_Nrolote || '' ||
                      ' termino sastifactoriamente.';
    p_Result       := m_Bitacora_Msg;

    --Actualizar el resultado del proceso en la bitacora si todo ocurrio sastifactoriamente.
    ActualizarBitacora(m_bitacora_sec, m_bitacora_msg, 'O', '000');

  Exception
    When Others Then
      Rollback;

      -- Actualizar el resultado del proceso en la bitacora
      m_Bitacora_Return := 650;
      m_Bitacora_Msg    := Substr('ERROR. Lote: ' || v_NroLote || '. ' ||
                                  Sqlerrm,
                                  1,
                                  200);

      ActualizarBitacora(m_bitacora_sec,
                         m_bitacora_msg,
                         'E',
                         m_bitacora_return);

      --Marcar con error en la tabla de Cargar---
      ActualizarCarga(v_NroLote, v_Cantidad, 0, 'E', null);

  End RecibirDispersionLactancia;

  Procedure RecibirDispersionMaternidad(p_Result Out Varchar2) Is
    v_Count           Integer := 0;
    v_Nrolote         Integer := 0;
    v_Cantidad        Integer := 0;
    v_registrosRe     Integer := 0;
    m_bitacora_return SEG_ERROR_T.id_error%TYPE;
    m_bitacora_sec    integer;
    m_bitacora_msg    Varchar2(200);

    Cursor c_Cursor(p_lote varchar2) Is
      Select Nro_Lote,
             Id_Registro_Patronal,
             Id_Nss_Madre,
             Secuencia,
             Nro_Pago,
             Periodo,
             Status_Dispersion,
             Fecha_Dispersion,
             Id_Error_Dispersion,
             tipo_pago,
             nro_solicitud,
             id_ajuste
        From Sisalril_Suir.Sfs_Subs_Maternidad_t
       Where Status_Dispersion In ('D', 'R')
         And Status_Pago = 'N'
         And Nro_Lote = p_lote;
  Begin

    --Buscando el nro del lote
    select max(nro_lote)
      into v_Nrolote
      from sub_cuotas_t c
     where tipo_subsidio = 'M'
       and status_dispersion = 'G'
       and status_proceso = 'PE';

    -- Insertar el registro en la bitacora de procesos
    Insertarbitacora('TM', m_bitacora_sec);

    --Agregar registro en estatus "P" (En Proceso)--
    InsertarCarga(v_NroLote,
                  'M',
                  'P',
                  'R',
                  'sisalril_suir.sfs_subs_maternidad_t');

    For v_Record In c_Cursor(v_Nrolote) Loop

      Update Suirplus.sub_cuotas_t c
         Set c.Status_Dispersion   = v_Record.Status_Dispersion,
             c.Fecha_Dispersion    = v_Record.Fecha_Dispersion,
             c.Id_Error_Dispersion = v_Record.Id_Error_Dispersion
       Where c.nro_solicitud = v_Record.Nro_Solicitud
         and c.id_registro_patronal = v_Record.Id_Registro_Patronal
         And c.Nro_Pago = v_Record.Nro_Pago
         And c.Nro_Lote = v_Record.Nro_Lote
         And c.tipo_pago = v_Record.tipo_pago;


       if v_record.id_ajuste is not null then

       update suirplus.sub_ajustes_t a set a.status = decode(v_record.Status_Dispersion,'D','DI','R','RE')
       where a.id_ajuste = v_record.id_ajuste;

       end if;


    End Loop;

    For recibirdis In (Select id_ajuste, Status_Dispersion
                         From suirplus.sub_cuotas_t
                        Where Status_Dispersion In ('D', 'R')
                          And Status_Pago = 'N'
                          And Nro_Lote = v_Nrolote)

     Loop

      If (recibirdis.status_dispersion = 'D') Then
        v_Count := v_Count + 1;
      Elsif (recibirdis.status_dispersion = 'R') Then
        v_registrosRe := v_registrosRe + 1;
        sfc_ajustes_pkg.MarcarCancelado(recibirdis.id_ajuste, p_Result);
      End If;

    End Loop;

    --Marcar como completado en sfs_subs_carga_t--
    ActualizarCarga(v_Nrolote, v_Count, v_registrosRe, 'C', null);

    m_Bitacora_Msg := 'El proceso con el nro_lote ' || '' || v_Nrolote || '' ||
                      ' termino sastifactoriamente.';
    p_Result       := m_Bitacora_Msg;
    --Actualizar el resultado del proceso en la bitacora si todo ocurrio sastifactoriamente.
    ActualizarBitacora(m_bitacora_sec, m_bitacora_msg, 'O', '000');

  Exception
    When Others Then
      Rollback;
      -- Actualizar el resultado del proceso en la bitacora
      m_Bitacora_Return := 650;
      m_Bitacora_Msg    := Substr('ERROR. Lote: ' || v_NroLote || '. ' ||
                                  Sqlerrm,
                                  1,
                                  200);

      ActualizarBitacora(m_bitacora_sec,
                         m_bitacora_msg,
                         'E',
                         m_bitacora_return);

      --Marcar con error en la tabla de Cargar---
      ActualizarCarga(v_NroLote, v_Cantidad, 0, 'E', null);

  End RecibirDispersionMaternidad;

  Procedure RecibirDispersionEnfComun(p_Result Out Varchar2)

   Is
    v_Count           Integer := 0;
    v_Nrolote         Integer := 0;
    v_Cantidad        Integer := 0;
    v_registrosRe     Integer := 0;
    m_bitacora_return SEG_ERROR_T.id_error%TYPE;
    m_bitacora_sec    integer;
    m_bitacora_msg    Varchar2(200);

    Cursor c_Cursor(p_lote varchar2) Is
      select nro_lote,
             id_registro_patronal,
             id_nss,
             padecimiento,
             secuencia,
             Nro_Pago,
             PERIODO,
             Fecha_Dispersion,
             Status_Dispersion,
             Id_Error_Dispersion,
             Status_Pago,
             nro_solicitud,
             id_ajuste
        From Sisalril_Suir.Sfs_Subs_Enf_t
       Where Status_Dispersion In ('D', 'R')
         And Status_Pago = 'N'
         And Nro_Lote = p_lote;
  Begin

    select max(nro_lote)
      into v_Nrolote
      from sub_cuotas_t c
     where tipo_subsidio = 'E'
       and status_dispersion = 'G'
       and status_proceso = 'PE';

    -- Insertar el registro en la bitacora de procesos
    Insertarbitacora('TE', m_bitacora_sec);

    --Insertar un registro en sfs_subs_carga_t en estatus 'P' (En Proceso)
    InsertarCarga(v_NroLote,
                  'E',
                  'P',
                  'R',
                  'sisalril_suir.sfs_subs_maternidad_t');

    For v_Record In c_Cursor(v_Nrolote) Loop

      Update Suirplus.sub_cuotas_t c
         Set c.Status_Dispersion   = v_Record.Status_Dispersion,
             c.Fecha_Dispersion    = v_Record.Fecha_Dispersion,
             c.Id_Error_Dispersion = v_Record.Id_Error_Dispersion,
             c.Status_Pago         = v_Record.status_pago
       Where c.nro_solicitud = v_Record.nro_solicitud
         and c.id_registro_patronal = v_Record.Id_Registro_Patronal
         And c.Nro_Pago = v_Record.Nro_Pago
         And c.Nro_Lote = v_Record.Nro_Lote
         And c.periodo = v_Record.PERIODO;

       if v_record.id_ajuste is not null then

       update suirplus.sub_ajustes_t a set a.status = decode(v_record.Status_Dispersion,'D','DI','R','RE')
       where a.id_ajuste = v_record.id_ajuste;

       end if;


    End Loop;

    For recibirdis In (Select id_ajuste, Status_Dispersion
                         From suirplus.sub_cuotas_t
                        Where Status_Dispersion In ('D', 'R')
                          And Status_Pago = 'N'
                          And Nro_Lote = v_Nrolote)

     Loop

      If (recibirdis.status_dispersion = 'D') Then

        v_count := v_count + 1;

      Elsif (recibirdis.status_dispersion = 'R') Then

        sfc_ajustes_pkg.MarcarCancelado(recibirdis.id_ajuste, p_Result);
        v_registrosRe := v_registrosRe + 1;

      End If;

    End Loop;

    --Marcar como completado en sfs_subs_carga_t Registros OK--
    ActualizarCarga(v_Nrolote, v_Count, v_registrosRe, 'C', null);

    -- Actualizar el resultado del proceso en la bitacora
    m_Bitacora_Msg := 'OK. Lote: ' || v_Nrolote;
    p_Result       := m_Bitacora_Msg;

    ActualizarBitacora(m_bitacora_sec, m_bitacora_msg, 'O', '000');

  Exception
    When Others Then
      Rollback;
      -- Actualizar el resultado del proceso en la bitacora
      m_Bitacora_Return := 650;
      m_Bitacora_Msg    := Substr('ERROR. Lote: ' || v_NroLote || '. ' ||
                                  Sqlerrm,
                                  1,
                                  200);

      ActualizarBitacora(m_bitacora_sec,
                         m_bitacora_msg,
                         'E',
                         m_bitacora_return);

      --Marcar con error en la tabla de Cargar---
      ActualizarCarga(v_NroLote, v_Cantidad, 0, 'E', null);

  End RecibirDispersionEnfComun;

  procedure ProcesarArchivoLactancia(p_Result out varchar2) is
    m_bitacora_return SEG_ERROR_T.id_error%TYPE;
    m_bitacora_sec    integer;
    m_bitacora_msg    Varchar2(200);
    V_NRO_LOTE        INTEGER;
    v_secuencia       integer := 0;
  begin

    --Buscando el nro de lote
    select max(nro_lote)
      into V_NRO_LOTE
      from sub_cuotas_t c
     where tipo_subsidio = 'L'
       and status_dispersion = 'D'
       and status_pago = 'N'
       and status_proceso = 'PE';

    -- Insertar el registro en la bitacora de procesos
    Insertarbitacora('PL', m_bitacora_sec);

    select max(secuencia) + 1 into v_secuencia from sfs_archivos_br_t;

    v_secuencia := nvl(v_secuencia, 1);

    ------- Procesar Registro----------
    GetDataDetalleReservas(V_NRO_LOTE, v_secuencia);

    -------- Generar Archivo de Pago---------
    PrepararArchivosBR(v_secuencia, p_Result);

    -------Enviar Archivo de pago por FTP-----------
    --EnviarPorFTP(v_secuencia, 'L');
    -- Actualizar el resultado del proceso en la bitacora

    commit;

    m_bitacora_msg := 'OK. Lote: ' || V_NRO_LOTE;

    ActualizarBitacora(m_bitacora_sec, m_bitacora_msg, 'O', '000');

    p_Result := m_bitacora_msg;
  exception
    when others then
      rollback;
      -- Actualizar el resultado del proceso en la bitacora
      m_bitacora_return := 650;
      m_bitacora_msg    := substr('ERROR. Lote: ' || V_NRO_LOTE || '. ' ||
                                  sqlerrm,
                                  1,
                                  200);

      ActualizarBitacora(m_bitacora_sec,
                         m_bitacora_msg,
                         'E',
                         m_bitacora_return);

      p_Result := m_bitacora_msg;
  end ProcesarArchivoLactancia;

  procedure ProcesarArchivoMaternidad(p_Result out varchar2) is
    m_bitacora_return SEG_ERROR_T.id_error%TYPE;
    m_bitacora_sec    integer;
    m_bitacora_msg    Varchar2(200);
    V_NRO_LOTE        INTEGER;
    v_secuencia       integer := 0;
  begin

    select max(nro_lote)
      into V_NRO_LOTE
      from sub_cuotas_t c
     where tipo_subsidio = 'M'
       and status_dispersion = 'D'
       and status_pago = 'N'
       and status_proceso = 'PE';

    -- Insertar el registro en la bitacora de procesos
    Insertarbitacora('PM', m_bitacora_sec);

    select nvl(max(secuencia), 0) + 1
      into v_secuencia
      from sfs_archivos_bpd_h_t
     Where Tipo_Subsidio = 'M';

    ------- Procesar Registro del Header---------------------
    GetDataHeaderPopular(V_NRO_LOTE, v_secuencia);
    ------- Procesar Registro del Detalle---------------------
    GetDataDetallePopular(V_NRO_LOTE, v_secuencia);
    ------- Generar Archivo de Pago ---------------------
    PrepararArchivosMaternidad(v_secuencia, p_Result);
    -------Enviar Archivo de pago por ftp---------------------
    --EnviarPorFTP(v_secuencia, 'M');

    commit;

    -- Actualizar el resultado del proceso en la bitacora
    m_bitacora_msg := 'OK. Lote: ' || V_NRO_LOTE;

    ActualizarBitacora(m_bitacora_sec, m_bitacora_msg, 'O', '000');

    p_Result := m_bitacora_msg;
  exception
    when others then
      rollback;
      -- Actualizar el resultado del proceso en la bitacora
      m_bitacora_return := 650;
      m_bitacora_msg    := substr('ERROR. Lote: ' || V_NRO_LOTE || '. ' ||
                                  sqlerrm,
                                  1,
                                  200);

      ActualizarBitacora(m_bitacora_sec,
                         m_bitacora_msg,
                         'E',
                         m_bitacora_return);

      p_Result := m_bitacora_msg;
  end ProcesarArchivoMaternidad;

  Procedure ProcesarArchivoEnfComun(p_Result out varchar2) Is
    m_bitacora_return SEG_ERROR_T.id_error%TYPE;
    m_bitacora_sec    integer;
    m_bitacora_msg    Varchar2(200);
    V_NRO_LOTE        INTEGER;
    v_secuencia       integer := 0;
  Begin
    --Buscando el nro del lote
    select max(nro_lote)
      into V_NRO_LOTE
      from sub_cuotas_t c
     where tipo_subsidio = 'E'
       and status_dispersion = 'D'
       and status_pago = 'N'
       and status_proceso = 'PE';

    -- Insertar el registro en la bitacora de procesos
    Insertarbitacora('PC', m_bitacora_sec);

    Select nvl(max(secuencia) + 1, 0 + 1)
      into v_secuencia
      from sfs_archivos_bpd_h_t
     Where Tipo_Subsidio = 'E';

    GetHeaderEnfComun(V_NRO_LOTE, v_secuencia);

    GetDetalleEnfComun(V_NRO_LOTE, v_secuencia);

    PrepararArchivoEnfComun(v_secuencia, p_Result);

    --EnviarPorFTP(v_secuencia, 'E');
    commit;

    -- Actualizar el resultado del proceso en la bitacora
    m_bitacora_msg := 'OK. Lote: ' || V_NRO_LOTE;

    ActualizarBitacora(m_bitacora_sec, m_bitacora_msg, 'O', '000');

    p_Result := m_bitacora_msg;
  exception
    when others then
      rollback;
      -- Actualizar el resultado del proceso en la bitacora
      m_bitacora_return := 650;
      m_bitacora_msg    := substr('ERROR. Lote: ' || V_NRO_LOTE || '. ' ||
                                  sqlerrm,
                                  1,
                                  200);

      ActualizarBitacora(m_bitacora_sec,
                         m_bitacora_msg,
                         'E',
                         m_bitacora_return);

      p_Result := m_bitacora_msg;
  End ProcesarArchivoEnfComun;

  Procedure RecibirSubsLactancia(p_Result Out Varchar2) Is
    v_Count           Integer := 0;
    V_NRO_LOTE        INTEGER;
    m_bitacora_return SEG_ERROR_T.id_error%TYPE;
    m_bitacora_sec    integer;
    m_bitacora_msg    Varchar2(200);
  Begin

    --Buscando el nro de lote
    select max(nro_lote)
      into V_NRO_LOTE
      from sub_cuotas_t c
     where tipo_subsidio = 'L'
       and status_dispersion = 'D'
       and status_pago = 'N'
       and status_proceso = 'PE';

    -- Insertar el registro en la bitacora de procesos
    Insertarbitacora('SL', m_bitacora_sec);

    --Insertar un registro en sfs_subs_carga_t en estatus 'P' (En Proceso)
    InsertarCarga(V_NRO_LOTE,
                  'L',
                  'P',
                  'R',
                  'sisalril_suir.sfs_subs_lactancia_t');

    For v_Record In (Select la.nro_lote,
                            La.Periodo,
                            La.Id_Nss_Madre,
                            La.Nro_Pago,
                            la.secuencia,
                            La.Secuencia_Lactante,
                            La.Status_Pago,
                            La.Fecha_Pago,
                            La.Id_Error_Pago,
                            La.Tipo_Pago,
                            la.nro_solicitud
                       From Sisalril_Suir.Sfs_Subs_Lactancia_t La
                      Where La.Nro_Lote = V_NRO_LOTE
                        And la.status_dispersion = 'D'
                        And Status_Pago In ('P', 'R'))

     Loop

      Update Suirplus.sub_cuotas_t c
         Set c.Status_Pago    = v_Record.Status_Pago,
             c.Fecha_Pago     = v_Record.Fecha_Pago,
             c.Id_Error_Pago  = v_Record.Id_Error_Pago,
             c.status_proceso = 'OK'
       Where c.nro_solicitud = v_Record.nro_solicitud
         And c.Nro_Lote = v_Record.Nro_Lote
         And c.Nro_Pago = v_Record.Nro_Pago
         And c.tipo_pago = v_Record.tipo_pago;

      v_Count := v_Count + 1;

    End Loop;

    For Rechazados In (Select ma.rowid,
                              Ma.Nro_Lote,
                              Ma.Via,
                              Ma.Id_Entidad_Recaudadora,
                              Ma.Tipo_Cuenta,
                              Ma.Cuenta_Banco,
                              Ma.Nro_Referencia,
                              Ma.Monto_Subsidio,
                              Ma.Nro_Pago,
                              Ma.Periodo,
                              Ma.Status_Dispersion,
                              Ma.Fecha_Dispersion,
                              Ma.Id_Error_Dispersion,
                              Ma.Status_Pago,
                              Ma.Fecha_Pago,
                              Ma.Id_Error_Pago,
                              Ma.Ult_Fecha_Act,
                              Ma.Tipo_Pago,
                              Ma.Id_Ajuste,
                              ma.nro_solicitud,
                              ma.id_registro_patronal
                         From Suirplus.sub_cuotas_t ma
                        Where Ma.Status_Dispersion = 'D'
                          And Ma.Status_Pago = 'R'
                          And Ma.Nro_Lote = V_NRO_LOTE) Loop

      --Insertando las Rechazadas

      Insert Into Suirplus.Sub_Cuotas_Re_t
        (Id_cuota,
         Nro_Lote,
         Via,
         Entidad_Recaudadora,
         Tipo_Cuenta,
         Cuenta_Banco,
         Nro_Referencia,
         Monto_Subsidio,
         Nro_Pago,
         Periodo,
         Status_Dispersion,
         Fecha_Dispersion,
         Error_Dispersion,
         Status_Pago,
         Fecha_Pago,
         Error_Pago,
         Ult_Fecha_Act,
         Tipo_Pago,
         Ajuste,
         nro_solicitud)
      Values
        (sub_sfs_dispersion.GetProximoNumeroCuotaRe,
         Rechazados.Nro_Lote,
         Rechazados.Via,
         Rechazados.Id_Entidad_Recaudadora,
         Rechazados.Tipo_Cuenta,
         Rechazados.Cuenta_Banco,
         Rechazados.Nro_Referencia,
         Rechazados.Monto_Subsidio,
         Rechazados.Nro_Pago,
         Rechazados.Periodo,
         Rechazados.Status_Dispersion,
         Rechazados.Fecha_Dispersion,
         Rechazados.Id_Error_Dispersion,
         Rechazados.Status_Pago,
         Rechazados.Fecha_Pago,
         Rechazados.Id_Error_Pago,
         Rechazados.Ult_Fecha_Act,
         Rechazados.Tipo_Pago,
         Rechazados.Id_Ajuste,
         Rechazados.nro_solicitud);

      Update Suirplus.sub_cuotas_t la
         Set la.Status_Dispersion = 'C',
             la.Status_Pago       = 'N',
             la.Via               = 'CB',
             la.tipo_pago         = 'O',
             la.nro_lote          = 0,
             la.status_proceso    = null
       Where la.rowid = Rechazados.rowid;

    end loop;

    -- Marcar como completado el registro que fue intresadoSFS_SUBS_CARGA_T

    ActualizarCarga(v_Nro_Lote, v_Count, 0, 'C', null);

    -- Actualizar el resultado del proceso en la bitacora
    m_Bitacora_Msg := 'OK. Lote: ' || V_NRO_LOTE;
    ActualizarBitacora(m_bitacora_sec, m_bitacora_msg, 'O', '000');
    p_Result := m_Bitacora_Msg;

  Exception
    When Others Then
      Rollback;

      -- Actualizar el resultado del proceso en la bitacora
      m_Bitacora_Return := 650;
      m_Bitacora_Msg    := Substr('ERROR. Lote: ' || V_NRO_LOTE || '. ' ||
                                  Sqlerrm,
                                  1,
                                  200);

      ActualizarBitacora(m_bitacora_sec,
                         m_bitacora_msg,
                         'E',
                         m_bitacora_return);

      --Marcar con error en la tabla de Cargar---
      ActualizarCarga(V_NRO_LOTE, v_Count, 0, 'E', null);

  End Recibirsubslactancia;

  Procedure RecibirSubsmaternidad(p_Result Out Varchar2) Is
    V_NRO_LOTE        INTEGER;
    v_Count           Integer := 0;
    v_registroRE      Integer := 0;
    v_sec_error       suirplus.Sfc_Ajustes_Error_t.id_ajuste_error%type;
    v_mensaje         varchar2(2000);
    m_bitacora_return SEG_ERROR_T.id_error%TYPE;
    m_bitacora_sec    integer;
    m_bitacora_msg    Varchar2(200);
  Begin

    --Buscando el nro de lote
    select max(nro_lote)
      into V_NRO_LOTE
      from sub_cuotas_t c
     where tipo_subsidio = 'M'
       and status_dispersion = 'D'
       and status_pago = 'N'
       and status_proceso = 'PE';

    -- Insertar el registro en la bitacora de procesos
    Insertarbitacora('SM', m_bitacora_sec);

    --Insertar un registro en sfs_subs_carga_t en estatus 'P' (En Proceso)
    InsertarCarga(V_NRO_LOTE,
                  'M',
                  'P',
                  'R',
                  'sisalril_suir.sfs_subs_maternidad_t');

    For v_Record In (Select ma.Nro_Lote,
                            ma.Periodo,
                            ma.Id_Registro_Patronal,
                            ma.Id_Nss_Madre,
                            ma.secuencia,
                            ma.Nro_Pago,
                            ma.Tipo_Pago,
                            ma.Status_Pago,
                            ma.Fecha_Pago,
                            ma.Id_Error_Pago,
                            ma.nro_solicitud,
                            ma.id_ajuste
                       From Sisalril_Suir.Sfs_Subs_Maternidad_t ma
                      Where ma.Status_Dispersion = 'D'
                        And ma.Status_Pago In ('P', 'R')
                        And ma.Nro_Lote = V_NRO_LOTE) Loop

      Update Suirplus.sub_cuotas_t c
         Set c.Status_Pago    = v_Record.Status_Pago,
             c.Fecha_Pago     = v_Record.Fecha_Pago,
             c.Id_Error_Pago  = v_Record.Id_Error_Pago,
             c.status_proceso = 'OK'
       Where c.nro_solicitud = v_Record.nro_solicitud
         and c.id_registro_patronal = v_Record.Id_Registro_Patronal
         And c.Nro_Lote = v_Record.Nro_Lote
         And c.Nro_Pago = v_Record.Nro_Pago
         And c.tipo_pago = v_Record.tipo_pago;



       if v_Record.id_ajuste is not null then


       if v_Record.Status_Pago = 'P' then
        sfc_ajustes_pkg.MarcarAplicado(v_Record.id_ajuste, p_Result);
       else
        sfc_ajustes_pkg.MarcarCancelado(v_Record.id_ajuste, p_Result);
       end if;


       update suirplus.sub_ajustes_t a set a.status = decode(v_record.Status_Pago,'P','PA','R','RE')
       where a.id_ajuste = v_record.id_ajuste;


       update sisalril_suir.sub_ajustes_t a set a.status = decode(v_record.Status_Pago,'P','PA','R','RE')
       where a.id_ajuste = v_record.id_ajuste;


       end if;




    End Loop;

    For pagados In (Select ma.rowid,
                           Ma.Nro_Lote,
                           Ma.Via,
                           Ma.Id_Entidad_Recaudadora,
                           Ma.Tipo_Cuenta,
                           Ma.Cuenta_Banco,
                           Ma.Nro_Referencia,
                           Ma.Monto_Subsidio,
                           Ma.Nro_Pago,
                           Ma.Periodo,
                           Ma.Status_Dispersion,
                           Ma.Fecha_Dispersion,
                           Ma.Id_Error_Dispersion,
                           Ma.Status_Pago,
                           Ma.Fecha_Pago,
                           Ma.Id_Error_Pago,
                           Ma.Ult_Fecha_Act,
                           Ma.Tipo_Pago,
                           Ma.Id_Ajuste,
                           ma.nro_solicitud,
                           ma.id_registro_patronal
                      From Suirplus.sub_cuotas_t ma
                     Where Ma.Status_Dispersion = 'D'
                       And Ma.Status_Pago In ('P', 'R')
                       And Ma.Nro_Lote = V_NRO_LOTE) Loop

      If (pagados.status_pago = 'P') Then

        sfc_ajustes_pkg.MarcarAplicado(pagados.id_ajuste, p_Result);
        v_Count := v_Count + 1;

        if (p_Result != '0') then
          --obtener la secuencia del error proceso
          Select Suirplus.Ajuste_Err_Seq.Nextval
            Into v_sec_error
            From Dual;

          v_mensaje := 'Ocurrio el sigueitne error' || ' ' || p_Result || ' ' || ' ' ||
                       'Marcando como Aplicado en TransAjuste';

          insert into suirplus.Sfc_Ajustes_Error_t
            (id_ajuste_error, id_ajuste, mensaje, fecha_error, proceso)
          values
            (v_sec_error, pagados.id_ajuste, v_mensaje, sysdate, 'AM');

        end if;

      Elsif (pagados.status_pago = 'R') Then

        --insetar el registro en la tabla de rechazos.--
        Insert Into Suirplus.Sub_Cuotas_Re_t
          (Id_cuota,
           Nro_Lote,
           Via,
           Entidad_Recaudadora,
           Tipo_Cuenta,
           Cuenta_Banco,
           Nro_Referencia,
           Monto_Subsidio,
           Nro_Pago,
           Periodo,
           Status_Dispersion,
           Fecha_Dispersion,
           Error_Dispersion,
           Status_Pago,
           Fecha_Pago,
           Error_Pago,
           Ult_Fecha_Act,
           Tipo_Pago,
           Ajuste,
           nro_solicitud)
        Values
          (sub_sfs_dispersion.GetProximoNumeroCuotaRe,
           pagados.Nro_Lote,
           pagados.Via,
           pagados.Id_Entidad_Recaudadora,
           pagados.Tipo_Cuenta,
           pagados.Cuenta_Banco,
           pagados.Nro_Referencia,
           pagados.Monto_Subsidio,
           pagados.Nro_Pago,
           pagados.Periodo,
           pagados.Status_Dispersion,
           pagados.Fecha_Dispersion,
           pagados.Id_Error_Dispersion,
           pagados.Status_Pago,
           pagados.Fecha_Pago,
           pagados.Id_Error_Pago,
           pagados.Ult_Fecha_Act,
           pagados.Tipo_Pago,
           pagados.Id_Ajuste,
           pagados.nro_solicitud);

        sfc_ajustes_pkg.MarcarPendiente(pagados.id_ajuste, p_Result);

        if (p_Result != '0') then

          --obtener la secuencia del error proceso
          Select Suirplus.Ajuste_Err_Seq.Nextval
            Into v_sec_error
            From Dual;

          v_mensaje := 'Ocurrio el sigueitne error' || ' ' || p_Result || ' ' || ' ' ||
                       'Marcando como pendiente en TransAjuste';

          insert into suirplus.Sfc_Ajustes_Error_t
            (id_ajuste_error, id_ajuste, mensaje, fecha_error, proceso)
          values
            (v_sec_error, pagados.id_ajuste, v_mensaje, sysdate, 'AM');

        end if;

        v_registroRE := v_registroRE + 1;

        Update Suirplus.sub_cuotas_t Ma
           Set Ma.Status_Dispersion = 'C',
               Ma.Status_Pago       = 'N',
               Ma.Via               = 'CU',
               ma.nro_lote          = 0,
               ma.status_proceso    = null
         Where Ma.rowid = Pagados.Rowid;
      End If;

    End Loop;

	/*For que busca las solicitudes OK, y con todas sus cuotas pagadas*/
 for e in (select m.rowid, c.nro_solicitud, m.id_registro_patronal, c.monto_subsidio
				  from suirplus.sub_sfs_maternidad_t m
				  join suirplus.sub_cuotas_t c
					on c.nro_solicitud = m.nro_solicitud
				   and c.id_registro_patronal = m.id_registro_patronal
				where m.id_estatus = 2
				group by m.rowid, c.nro_solicitud, m.id_registro_patronal, c.monto_subsidio
				having count(*) = sum(decode(c.status_pago,'P',1,0)) 
				order by c.nro_solicitud desc)

     loop
	    -- Marcar como completadas las de Maternidad
	  update suirplus.sub_sfs_maternidad_t ma1
         set ma1.id_estatus = 4
       where ma1.rowid in(e.rowid);

      --Insertando el elegible
      InsertarElegible(e.nro_solicitud,
                       e.id_registro_patronal,
                       e.monto_subsidio,
                       null,
                       null,
                       null,
                       null,
                       sysdate,
                       4,
                       null,
                       null,
                       null,
                       0,
                       null,
                       p_Result);

    end loop;

    --Marcar como completado en sfs_subs_carga_t--
    ActualizarCarga(v_Nro_Lote, v_Count, v_registroRE, 'C', null);

    -- Actualizar el resultado del proceso en la bitacora
    m_Bitacora_Msg := 'OK. Lote: ' || V_NRO_LOTE;
    ActualizarBitacora(m_bitacora_sec, m_bitacora_msg, 'O', '000');

    p_Result := m_Bitacora_Msg;
  Exception
    When Others Then
      Rollback;

      -- Actualizar el resultado del proceso en la bitacora
      m_Bitacora_Return := 650;
      m_Bitacora_Msg    := Substr('ERROR. Lote: ' || V_NRO_LOTE || '. ' ||
                                  Sqlerrm,
                                  1,
                                  200);

      ActualizarBitacora(m_bitacora_sec,
                         m_bitacora_msg,
                         'E',
                         m_bitacora_return);

      --Marcar con error en la tabla de Cargar---
      ActualizarCarga(V_NRO_LOTE, 0, 0, 'E', null);

      Commit;
      p_Result := m_Bitacora_Msg;

  End Recibirsubsmaternidad;

  Procedure RecibirSubsEnfComun(p_Result Out Varchar2) Is
    v_registroRE      Integer := 0;
    v_sec_error       suirplus.Sfc_Ajustes_Error_t.id_ajuste_error%type;
    v_mensaje         varchar2(2000);
    v_Count           Integer := 0;
    V_NRO_LOTE        INTEGER;
    m_bitacora_return SEG_ERROR_T.id_error%TYPE;
    m_bitacora_sec    integer;
    m_bitacora_msg    Varchar2(200);
  Begin

    --Buscando el nro de lote
    select max(nro_lote)
      into V_NRO_LOTE
      from sub_cuotas_t c
     where tipo_subsidio = 'E'
       and status_dispersion = 'D'
       and status_pago = 'N'
       and status_proceso = 'PE';

    -- Insertar el registro en la bitacora de procesos
    Insertarbitacora('SE', m_bitacora_sec);

    --Insertar un registro en sfs_subs_carga_t en estatus 'P' (En Proceso)
    InsertarCarga(V_NRO_LOTE,
                  'E',
                  'P',
                  'R',
                  'sisalril_suir.Sfs_Subs_Enf_t');

    For v_Record In (Select ef.Nro_Lote,
                            ef.Periodo,
                            ef.Id_Registro_Patronal,
                            ef.Id_Nss,
                            ef.secuencia,
                            ef.padecimiento,
                            ef.Nro_Pago,
                            ef.Status_Pago,
                            ef.fecha_pago,
                            ef.Id_Error_Pago,
                            ef.nro_solicitud,
                            ef.id_ajuste
                       From Sisalril_Suir.Sfs_Subs_Enf_t ef
                      Where ef.Status_Dispersion = 'D'
                        And ef.Status_Pago In ('P', 'R')
                        And ef.Nro_Lote = V_NRO_LOTE) Loop
      Update Suirplus.sub_cuotas_t c
         Set c.Status_Pago    = v_Record.Status_Pago,
             c.Fecha_Pago     = v_Record.Fecha_Pago,
             c.Id_Error_Pago  = v_Record.Id_Error_Pago,
             c.status_proceso = 'OK'
       Where c.nro_solicitud = v_Record.nro_solicitud
         and c.id_registro_patronal = v_Record.Id_Registro_Patronal
         And c.Nro_Lote = v_Record.Nro_Lote
         And c.Nro_Pago = v_Record.Nro_Pago
         And c.Periodo = v_Record.Periodo;

           if v_Record.id_ajuste is not null then


       if v_Record.Status_Pago = 'P' then
        sfc_ajustes_pkg.MarcarAplicado(v_Record.id_ajuste, p_Result);
       else
        sfc_ajustes_pkg.MarcarCancelado(v_Record.id_ajuste, p_Result);
       end if;


       update suirplus.sub_ajustes_t a set a.status = decode(v_record.Status_Pago,'P','PA','R','RE')
       where a.id_ajuste = v_record.id_ajuste;


       update sisalril_suir.sub_ajustes_t a set a.status = decode(v_record.Status_Pago,'P','PA','R','RE')
       where a.id_ajuste = v_record.id_ajuste;


       end if;


    End Loop;

    For pagados In (Select Ma.rowid,
                           Ma.Nro_Lote,
                           Ma.Via,
                           Ma.Id_Entidad_Recaudadora,
                           Ma.Tipo_Cuenta,
                           Ma.Cuenta_Banco,
                           Ma.Nro_Referencia,
                           Ma.Monto_Subsidio,
                           Ma.Nro_Pago,
                           Ma.Periodo,
                           Ma.Status_Dispersion,
                           Ma.Fecha_Dispersion,
                           Ma.Id_Error_Dispersion,
                           Ma.Status_Pago,
                           Ma.Fecha_Pago,
                           Ma.Id_Error_Pago,
                           Ma.Ult_Fecha_Act,
                           Ma.Tipo_Pago,
                           Ma.Id_Ajuste,
                           ma.nro_solicitud,
                           ma.id_registro_patronal
                      From Suirplus.sub_cuotas_t ma
                     Where Ma.Status_Dispersion = 'D'
                       And Ma.Status_Pago In ('P', 'R')
                       And Ma.Nro_Lote = V_NRO_LOTE) Loop

      If (pagados.Status_Pago = 'P') Then

        SFC_AJUSTES_PKG.MarcarAplicado(pagados.id_ajuste, p_Result);
        v_Count := v_Count + 1;

        if (p_Result != '0') then
          --obtener la secuencia del error proceso
          Select Suirplus.Ajuste_Err_Seq.Nextval
            Into v_sec_error
            From Dual;

          v_mensaje := 'Ocurrio el sigueitne error' || ' ' || p_Result || ' ' || ' ' ||
                       'Marcando como Aplicado en TransAjuste';
          insert into suirplus.Sfc_Ajustes_Error_t
            (id_ajuste_error, id_ajuste, mensaje, fecha_error, proceso)
          values
            (v_sec_error, pagados.id_ajuste, p_Result, sysdate, 'AE');

        end if;

      Elsif (pagados.Status_Pago = 'R') Then

        -- iNSERTAR EL REGISTRO EN LA TABLA DE RECHAZOS--
        Insert Into Suirplus.Sub_Cuotas_Re_t
          (Id_cuota,
           Nro_Lote,
           Via,
           Entidad_Recaudadora,
           Tipo_Cuenta,
           Cuenta_Banco,
           Nro_Referencia,
           Monto_Subsidio,
           Nro_Pago,
           Periodo,
           Status_Dispersion,
           Fecha_Dispersion,
           Error_Dispersion,
           Status_Pago,
           Fecha_Pago,
           Error_Pago,
           Ult_Fecha_Act,
           Tipo_Pago,
           Ajuste,
           nro_solicitud)
        Values
          (sub_sfs_dispersion.GetProximoNumeroCuotaRe,
           pagados.Nro_Lote,
           pagados.Via,
           pagados.Id_Entidad_Recaudadora,
           pagados.Tipo_Cuenta,
           pagados.Cuenta_Banco,
           pagados.Nro_Referencia,
           pagados.Monto_Subsidio,
           pagados.Nro_Pago,
           pagados.Periodo,
           pagados.Status_Dispersion,
           pagados.Fecha_Dispersion,
           pagados.Id_Error_Dispersion,
           pagados.Status_Pago,
           pagados.Fecha_Pago,
           pagados.Id_Error_Pago,
           pagados.Ult_Fecha_Act,
           pagados.Tipo_Pago,
           pagados.Id_Ajuste,
           pagados.nro_solicitud);

        SFC_AJUSTES_PKG.MarcarPendiente(pagados.id_ajuste, p_Result);

        if (p_Result != '0') then

          v_mensaje := 'Ocurrio el sigueitne error' || ' ' || p_Result || ' ' || ' ' ||
                       'Marcando como pendiente en TransAjuste';

          --obtener la secuencia del error proceso
          Select Suirplus.Ajuste_Err_Seq.Nextval
            Into v_sec_error
            From Dual;

          insert into suirplus.Sfc_Ajustes_Error_t
            (id_ajuste_error, id_ajuste, mensaje, fecha_error, proceso)
          values
            (v_sec_error, pagados.id_ajuste, v_mensaje, sysdate, 'AE');

        end if;

        Update Suirplus.sub_cuotas_t ef
           Set ef.Status_Dispersion      = 'C',
               ef.Status_Pago            = 'N',
               ef.Via                    = 'CU',
               ef.nro_lote               = 0,
               ef.id_entidad_recaudadora = Null,
               ef.tipo_cuenta            = Null,
               ef.cuenta_banco           = Null,
               ef.status_proceso         = null
         Where ef.rowid = pagados.rowid;

        v_registroRE := v_registroRE + 1;

      End If;

    End Loop;

    --Marcar como completado en sfs_subs_carga_t--
    ActualizarCarga(v_Nro_Lote, v_Count, v_registroRE, 'C', null);

    --Actualizar el resultado del proceso en la bitacora
    m_Bitacora_Msg := 'OK. Lote: ' || v_Nro_Lote;
    ActualizarBitacora(m_bitacora_sec, m_bitacora_msg, 'O', '000');
    p_Result := m_Bitacora_Msg;

  Exception
    When Others Then
      Rollback;

      -- Actualizar el resultado del proceso en la bitacora
      m_Bitacora_Return := 650;
      m_Bitacora_Msg    := Substr('ERROR. Lote: ' || v_Nro_Lote || '. ' ||
                                  Sqlerrm,
                                  1,
                                  200);
      ActualizarBitacora(m_bitacora_sec,
                         m_bitacora_msg,
                         'E',
                         m_bitacora_return);

      --Marcar con error en la tabla de Cargar---
      ActualizarCarga(V_NRO_LOTE, 0, 0, 'E', null);

      p_Result := m_Bitacora_Msg;
  End Recibirsubsenfcomun;

  procedure PublicarNP(p_fecha  in suirplus.sfc_facturas_t.fecha_registro_pago%type,
                       p_Result Out Varchar2) is
    m_bitacora_return SEG_ERROR_T.id_error%TYPE;
    m_bitacora_sec    integer;
    m_bitacora_msg    Varchar2(200);
    v_nro_lote        integer := 0;
    v_countmaternidad integer := 0;
    v_countenfcomun   Integer := 0;
    v_result          Varchar2(1000);

  begin

    v_nro_lote := getProximoNumeroLote();

    -- Insertar el registro en la bitacora de procesos
    Insertarbitacora('NP', m_bitacora_sec);

    --Insertar un registro en sfs_subs_carga_t en estatus 'P' (En Proceso)
    InsertarCarga(v_nro_lote, 'M', 'P', 'P', 'SFS_SUBS_MATERNIDAD_T');

    --Insertar un registro en sfs_subs_carga_t en estatus 'P' (En Proceso)
    InsertarCarga(v_nro_lote, 'E', 'P', 'P', 'Sfs_Subs_Enf_t');

    for c_cursor_record in (select f.id_registro_patronal id_registro_patronal,
                                   a.id_nss id_nss_madre,
                                   'NP' via,
                                   f.id_entidad_recaudadora,
                                   null tipo_cuenta,
                                   null cuenta_banco,
                                   f.id_referencia nro_referencia,
                                   a.monto monto_subsidio,
                                   f.periodo_factura periodo,
                                   'D' status_dispersion,
                                   fecha_registro_pago fecha_dispersion,
                                   null id_error_dispersion,
                                   'P' status_pago,
                                   f.fecha_registro_pago,
                                   null id_error_pago,
                                   null nro_lote_nuevo,
                                   f.monto_ajuste,
                                   a.id_ajuste,
                                   a.tipo_ajuste,
                                   f.id_referencia
                              from sfc_facturas_t f, sfc_det_ajustes_t a
                             where f.id_referencia = a.id_referencia
                               and f.status = 'PA'
                               and f.monto_ajuste != 0
                               and a.monto != 0
                               and trunc(f.fecha_registro_pago) >=
                                   trunc(p_fecha)

                                   ) Loop

      Case

        When c_cursor_record.tipo_ajuste = '1' Then

          suirplus.sfc_ajustes_pkg.MarcarAplicado(c_Cursor_Record.Id_Ajuste,
                                                  v_result);

          If (v_result = '0') Then

            Update Suirplus.sub_cuotas_t Ma
               Set Ma.Via                    = 'NP',
                   Ma.Status_Dispersion      = 'D',
                   Ma.Status_Pago            = 'P',
                   Ma.Fecha_Pago             = c_Cursor_Record.Fecha_Registro_Pago,
                   Ma.Id_Entidad_Recaudadora = c_Cursor_Record.Id_Entidad_Recaudadora,
                   Ma.Nro_Referencia         = c_Cursor_Record.Id_Referencia,
                   Ma.Fecha_Dispersion       = c_Cursor_Record.fecha_dispersion,
                   ma.nro_lote               = v_nro_lote
             Where ma.id_ajuste = c_Cursor_Record.Id_Ajuste;

            Insert Into Sisalril_Suir.Sfs_Subs_Maternidad_t
              (Nro_Lote,
               Id_Registro_Patronal,
               Id_Nss_Madre,
               Secuencia,
               Via,
               Id_Entidad_Recaudadora,
               Tipo_Cuenta,
               Cuenta_Banco,
               Nro_Referencia,
               Monto_Subsidio,
               Nro_Pago,
               Periodo,
               Status_Dispersion,
               Fecha_Dispersion,
               Id_Error_Dispersion,
               Status_Pago,
               Fecha_Pago,
               Id_Error_Pago,
               Tipo_Pago,
               ULT_FECHA_ACT,
               nro_solicitud,
               ID_TIPO_AJUSTE,
               id_ajuste)
              Select distinct v_nro_lote,
                     m.id_registro_patronal,
                     s.nss,
                     s.Secuencia,
                     c.Via,
                     c.Id_Entidad_Recaudadora,
                     c.Tipo_Cuenta,
                     c.Cuenta_Banco,
                     c.Nro_Referencia,
                     c.Monto_Subsidio,
                     c.Nro_Pago,
                     c.Periodo,
                     c.Status_Dispersion,
                     c.Fecha_Dispersion,
                     c.Id_Error_Dispersion,
                     c.Status_Pago,
                     c.Fecha_Pago,
                     c.Id_Error_Pago,
                     c.Tipo_Pago,
                     c.ult_fecha_act,
                     c.nro_solicitud,
                     c_Cursor_Record.tipo_ajuste,
                     c_Cursor_Record.Id_Ajuste
                From sub_cuotas_t c
                join sub_solicitud_t s
                  on s.nro_solicitud = c.nro_solicitud
                join sub_sfs_maternidad_t m
                  on m.nro_solicitud = c.nro_solicitud
                 and m.id_registro_patronal = c.id_registro_patronal
               where c.id_ajuste = c_Cursor_Record.Id_Ajuste;

            v_countmaternidad := v_countmaternidad + 1;
          else

            sfc_ajustes_pkg.AgregarAjusteError(c_Cursor_Record.Id_Ajuste,
                                               v_result);

          End If;

        When c_cursor_record.tipo_ajuste = '2' Then

          suirplus.sfc_ajustes_pkg.MarcarAplicado(c_Cursor_Record.Id_Ajuste,
                                                  v_result);

          If (v_result = '0') Then

            Update Suirplus.sub_cuotas_t Ef
               Set Ef.Via                    = 'NP',
                   Ef.Status_Dispersion      = 'D',
                   Ef.Status_Pago            = 'P',
                   Ef.Fecha_Pago             = c_Cursor_Record.Fecha_Registro_Pago,
                   ef.Id_Entidad_Recaudadora = c_Cursor_Record.Id_Entidad_Recaudadora,
                   ef.Nro_Referencia         = c_Cursor_Record.Id_Referencia,
                   ef.fecha_dispersion       = c_Cursor_Record.fecha_dispersion,
                   ef.nro_lote               = v_nro_lote
             Where ef.id_ajuste = c_Cursor_Record.Id_Ajuste;

            Insert into sisalril_suir.sfs_subs_enf_t
              (NRO_LOTE,
               ID_REGISTRO_PATRONAL,
               ID_NSS,
               PADECIMIENTO,
               SECUENCIA,
               VIA,
               ID_ENTIDAD_RECAUDADORA,
               TIPO_CUENTA,
               CUENTA_BANCO,
               NRO_REFERENCIA,
               MONTO_SUBSIDIO,
               NRO_PAGO,
               PERIODO,
               STATUS_DISPERSION,
               ID_ERROR_DISPERSION,
               STATUS_PAGO,
               ID_ERROR_PAGO,
               ULT_FECHA_ACT,
               FECHA_DISPERSION,
               FECHA_PAGO,
               NRO_SOLICITUD,
               ID_TIPO_AJUSTE,
               id_ajuste)
              Select v_nro_lote,
                     e.id_registro_patronal,
                     s.nss,
                     s.padecimiento,
                     s.secuencia,
                     c.via,
                     c.id_entidad_recaudadora,
                     c.tipo_cuenta,
                     c.cuenta_banco,
                     c.nro_referencia,
                     c.monto_subsidio,
                     c.nro_pago,
                     c.periodo,
                     c.status_dispersion,
                     c.id_error_dispersion,
                     c.status_pago,
                     c.id_error_pago,
                     c.ult_fecha_act,
                     c.fecha_dispersion,
                     c.fecha_pago,
                     c.nro_solicitud,
                     c_Cursor_Record.tipo_ajuste,
                     c_Cursor_Record.Id_Ajuste
                from suirplus.sub_cuotas_t c
                join sub_solicitud_t s
                  on s.nro_solicitud = c.nro_solicitud
                join sub_sfs_enf_comun_t e
                  on e.nro_solicitud = c.nro_solicitud
                 and e.id_registro_patronal = c.id_registro_patronal
               Where c.id_ajuste = c_Cursor_Record.Id_Ajuste;

            v_countenfcomun := v_countenfcomun + 1;
          else

            sfc_ajustes_pkg.AgregarAjusteError(c_Cursor_Record.Id_Ajuste,
                                               v_result);

          End If;
        when c_cursor_record.tipo_ajuste = '6' or c_cursor_record.tipo_ajuste = '8' then

          suirplus.sfc_ajustes_pkg.MarcarAplicado(c_Cursor_Record.Id_Ajuste,
                                                  v_result);

          If (v_result = '0') Then

            --Actualizando en sisalril
            update sisalril_suir.sub_ajustes_t a
               set a.status           = 'PA',
                   a.fecha_dispersion = sysdate,
                   a.id_referencia    = c_Cursor_Record.Id_Referencia
             where a.id_ajuste = c_Cursor_Record.Id_Ajuste;

            --Actualizando en SuirPlus
            update suirplus.sub_ajustes_t b
               set b.status           = 'PA',
                   b.fecha_dispersion = sysdate,
                   b.id_referencia    = c_Cursor_Record.Id_Referencia
             where b.id_ajuste = c_Cursor_Record.Id_Ajuste;

           Insert Into Sisalril_Suir.Sfs_Subs_Maternidad_t
             (Nro_Lote,
              Id_Registro_Patronal,
              Id_Nss_Madre,
              Via,
              Id_Entidad_Recaudadora,
              Nro_Referencia,
              Monto_Subsidio,
              Nro_Pago,
              Periodo,
              Status_Dispersion,
              Fecha_Dispersion,
              Status_Pago,
              Fecha_Pago,
              Tipo_Pago,
              ID_TIPO_AJUSTE,
              ULT_FECHA_ACT,
               id_ajuste,
               secuencia)
           values
             (v_nro_lote,
              c_Cursor_Record.id_registro_patronal,
              c_Cursor_Record.id_nss_madre,
              'NP',
              c_Cursor_Record.id_entidad_recaudadora,
              c_Cursor_Record.nro_referencia,
              abs(c_Cursor_Record.monto_subsidio),
              0,
              c_Cursor_Record.periodo,
              'D',
              sysdate,
              'P',
              sysdate,
              'O',
              c_Cursor_Record.tipo_ajuste,
              sysdate,
              c_Cursor_Record.Id_Ajuste,
              c_Cursor_Record.Id_Ajuste);

            v_countmaternidad := v_countmaternidad + 1;

          else
            sfc_ajustes_pkg.AgregarAjusteError(c_Cursor_Record.Id_Ajuste,
                                               v_result);
          end if;

          when c_cursor_record.tipo_ajuste = '7' or c_cursor_record.tipo_ajuste = '9' then
          suirplus.sfc_ajustes_pkg.MarcarAplicado(c_Cursor_Record.Id_Ajuste,
                                                  v_result);

          If (v_result = '0') Then
            --Actualizando en sisalril
            update sisalril_suir.sub_ajustes_t a
               set a.status           = 'PA',
                   a.fecha_dispersion = sysdate,
                   a.id_referencia    = c_Cursor_Record.Id_Referencia
             where a.id_ajuste = c_Cursor_Record.Id_Ajuste;

            --Actualizando en SuirPlus
            update suirplus.sub_ajustes_t b
               set b.status           = 'PA',
                   b.fecha_dispersion = sysdate,
                   b.id_referencia    = c_Cursor_Record.Id_Referencia
             where b.id_ajuste = c_Cursor_Record.Id_Ajuste;


              Insert Into Sisalril_Suir.sfs_subs_enf_t
             (Nro_Lote,
              Id_Registro_Patronal,
              ID_NSS,
              Via,
              Id_Entidad_Recaudadora,
              Nro_Referencia,
              Monto_Subsidio,
              Nro_Pago,
              Periodo,
              Status_Dispersion,
              Fecha_Dispersion,
              Status_Pago,
              Fecha_Pago,
              ID_TIPO_AJUSTE,
              ULT_FECHA_ACT,
              id_ajuste,
              secuencia)
           values
             (v_nro_lote,
              c_Cursor_Record.id_registro_patronal,
              c_Cursor_Record.id_nss_madre,
              'NP',
              c_Cursor_Record.id_entidad_recaudadora,
              c_Cursor_Record.nro_referencia,
              abs(c_Cursor_Record.monto_subsidio),
              0,
              c_Cursor_Record.periodo,
              'D',
              sysdate,
              'P',
              sysdate,
              c_Cursor_Record.tipo_ajuste,
              sysdate,
              c_Cursor_Record.Id_Ajuste,
              c_Cursor_Record.Id_Ajuste);
          else
            sfc_ajustes_pkg.AgregarAjusteError(c_Cursor_Record.Id_Ajuste,
                                               v_result);
          end if;

        else

          suirplus.sfc_ajustes_pkg.MarcarAplicado(c_Cursor_Record.Id_Ajuste,
                                                  v_result);

          If (v_result != '0') Then
            sfc_ajustes_pkg.AgregarAjusteError(c_Cursor_Record.Id_Ajuste,
                                               v_result);
          end if;
      End Case;

    end loop;

    commit;

    ActualizarStatus;


    --Marcar como procesado en Cargar--
    ActualizarCarga(v_Nro_Lote,
                    v_countmaternidad,
                    0,
                    'C',
                    'SFS_SUBS_MATERNIDAD_T');

    ActualizarCarga(v_Nro_Lote, v_countenfcomun, 0, 'C', 'Sfs_Subs_Enf_t');

    -- Actualizar el resultado del proceso en la bitacora
    m_bitacora_msg := 'OK. Lote: ' || v_nro_lote;
    ActualizarBitacora(m_bitacora_sec, m_bitacora_msg, 'O', '000');

    p_Result := m_Bitacora_Msg;

  exception
    when others then
      rollback;

      -- Actualizar el resultado del proceso en la bitacora
      m_Bitacora_Return := 650;
      m_Bitacora_Msg    := Substr('ERROR. Lote: ' || v_Nro_Lote || '. ' ||
                                  Sqlerrm,
                                  1,
                                  200);
      ActualizarBitacora(m_bitacora_sec,
                         m_bitacora_msg,
                         'E',
                         m_bitacora_return);

      --Marcar con error en la tabla de Cargar---
      ActualizarCarga(V_NRO_LOTE, 0, 0, 'E', null);

      p_Result := m_Bitacora_Msg;
  end PublicarNP;

  /* ------------------------------------------------------------------------
     Procedure: RecibirDebitosNP
     Objetivo: Recibir los Debitos desde SISALRIL para colocarlo como ajustes
  */ ------------------------------------------------------------------------
  Procedure RecibirDebitosNP(p_result out varchar2) Is
    v_bitacora        sfc_bitacora_t.id_bitacora%Type;
    m_bitacora_sec    integer;
    m_bitacora_msg    Varchar2(200);
    m_bitacora_return SEG_ERROR_T.id_error%TYPE;
    v_Count           Integer := 0;
    v_Nro_Lote        Integer := 0;
    v_ajuste          sub_ajustes_t.id_ajuste%type;
    v_result          varchar2(200);
    e_Error exception;
    v_Error Integer := 0;
    v_Start_Date         Date;
    v_Min_Billing_Date   Date;
    v_Periodo            sub_cuotas_t.periodo%Type;
    v_Periodo_Inicio     sub_cuotas_t.periodo%Type;
    v_Sysdate            Date := Sysdate;

  Begin

    InsertarBitacora('RD', v_bitacora);

    v_Nro_Lote := Getproximonumerolote();


        -- Buscar la fecha de inicio del subsido de Maternidad--
    Select d.Valor_Fecha
      Into v_Min_Billing_Date
      From Sfc_Det_Parametro_t d
     Inner Join Sfc_Parametros_t p
        On d.Id_Parametro = p.Id_Parametro
     Where d.Id_Parametro = 40
       And d.Fecha_Fin Is Null;


    if ( to_char(v_Sysdate,'YYYYMM') > to_char(v_Min_Billing_Date,'YYYYMM'))  then
     v_Min_Billing_Date := Add_Months(v_Min_Billing_Date, 1);
    end if;

    If v_Sysdate < v_Min_Billing_Date Then
      v_Start_Date := v_Sysdate;
    Else
      v_Start_Date := Add_Months(v_Sysdate, 1);
    End If;

    v_Periodo_Inicio := Suirplus.Parm.Periodo_Vigente(v_Start_Date);

    v_Periodo  := v_Periodo_Inicio;



    -- Insertar el registro como pendiente el InsertarCarga-
    InsertarCarga(v_Nro_Lote,
                  null,
                  'P',
                  'R',
                  'SISALRIL_SUIR.sub_ajustes_t');

    insert into sub_ajustes_t
      (ID_AJUSTE,
       ID_REGISTRO_PATRONAL,
       ID_NSS,
       STATUS,
       ID_TIPO_AJUSTE,
       MONTO_AJUSTE,
       FECHA_REGISTRO,
       FECHA_REPUESTA,
       COMENTARIO,
       ID_SUB_AJUSTE)
      select ID_AJUSTE,
             ID_REGISTRO_PATRONAL,
             ID_NSS,
             STATUS,
             ID_TIPO_AJUSTE,
             MONTO_AJUSTE,
             FECHA_REGISTRO,
             FECHA_REPUESTA,
             COMENTARIO,
             rowid
      from sisalril_suir.sub_ajustes_t
      where status = 'PE'
        and NVL(procesado,'N') = 'N';
    Commit;

    -- Marcamos inmediatamente como procesados en SISALRIL los registros que acabamos de traer para nuestro lado
    -- Esto es por si da error durante las validaciones, no cargarlo otra vez desde SISALRIL,
    -- sino procesar solo los pendientes en nuestro lado
    Update sisalril_suir.sub_ajustes_t
       Set procesado = 'S'
    Where status = 'PE'
      and NVL(procesado,'N') = 'N';
    Commit;

    For v_Record In (select a.rowid,
                            a.id_ajuste,
                            a.id_registro_patronal,
                            a.id_nss,
                            a.status,
                            a.id_tipo_ajuste,
                            a.monto_ajuste,
                            a.fecha_registro,
                            a.fecha_repuesta,
                            a.comentario,
                            a.id_motivo_rechazo
                       from sub_ajustes_t a
                      where a.status = 'PE')
     Loop
      begin
        if v_Record.Id_Ajuste is not null then
          v_Error := 1;
          raise e_error;
        end if;

        if sre_empleadores_pkg.existeregistropatronal(v_Record.Id_Registro_Patronal) =
           false then
          v_Error := 2;
          raise e_error;
        end if;

       if v_Record.Id_Nss is not null then

        if sre_trabajador_pkg.isexisteidnss(v_Record.Id_Nss) = false then
          v_Error := 3;
          raise e_error;
        end if;


        if NOT sub_sfs_validaciones.isactivanomina(v_Record.Id_Nss,
                                               v_Record.Id_Registro_Patronal) then
          v_Error := 4;
          raise e_error;
        end if;
       end if;

        IF v_Record.Monto_Ajuste <= 0 THEN
          v_Error := 5;
          raise e_error;
        end if;

        if trunc(v_Record.Fecha_Registro) > trunc(sysdate) then
          v_Error := 6;
          raise e_error;
        end if;

        if v_Record.Fecha_Registro is null then
          v_Error := 7;
          raise e_error;
        end if;

        if IsValidoTipoAjuste(v_Record.Id_Tipo_Ajuste) = false then
          v_Error := 8;
          raise e_error;
        end if;

        select sfc_trans_ajustes_seq.nextval into v_ajuste from dual;


        -- insertar en transajuste--
        InsertarAjuste(v_Record.id_registro_patronal,
                       1,
                       v_Periodo, --Suirplus.Parm.Periodo_Vigente(sysdate),
                       v_Record.id_nss,
                       v_Record.Id_Tipo_Ajuste,
                       'PE',
                       v_Record.Monto_Ajuste,
                       v_ajuste,
                       v_Record.rowid,
                       1,
                       v_result);

        if v_result = '0' then
          v_Count := v_Count + 1;
          -- Actualizar la Cuenta en SUBS a las Cuotas Pendientes.....
          Update sub_ajustes_t l
             set l.status         = 'OK',
                 l.fecha_repuesta = sysdate,
                 l.id_ajuste      = v_ajuste
           where l.rowid = v_Record.rowid;
        else
          Update sub_ajustes_t l
             set l.status         = 'RE',
                 l.fecha_repuesta = sysdate,
                 l.comentario     = v_result
           where l.rowid = v_Record.rowid;
        end if;
      Exception
        when e_Error then
          Update sub_ajustes_t l
             set l.status            = 'RE',
                 l.fecha_repuesta    = sysdate,
                 l.id_motivo_rechazo = v_Error
           where l.rowid = v_Record.rowid;
        when Others Then
          Update sub_ajustes_t l
             set l.status            = 'RE',
                 l.comentario        = l.comentario||' Error no controlado en la base de datos',
                 l.fecha_repuesta    = sysdate,
                 l.id_motivo_rechazo = 9 --Error no controlado en la base de datos
           where l.rowid = v_Record.rowid;
      end;
      commit;
    End Loop;

    --Actualizando sisalril
    UPDATE sisalril_suir.sub_ajustes_t sa
       SET (
            sa.status, sa.fecha_repuesta, sa.id_motivo_rechazo, sa.id_ajuste, sa.comentario
           ) =
           (
            select aj.status, aj.fecha_repuesta, aj.id_motivo_rechazo, aj.id_ajuste, aj.comentario
            from sub_ajustes_t aj
            where aj.id_sub_ajuste = sa.rowid
           )
     WHERE sa.status = 'PE'
       and sa.procesado = 'S';

    -- Marcar como completado en sfs_subs_cargar_t--
    ActualizarCarga(v_Nro_Lote, v_Count, 0, 'C', null);

    -- Actualizar el resultado del proceso en la bitacora
    m_Bitacora_Msg := 'OK. Lote: ' || v_Nro_Lote;
    ActualizarBitacora(m_bitacora_sec, m_bitacora_msg, 'O', '000');

    p_result := m_Bitacora_Msg;
  Exception
    When Others Then
      Rollback;

      -- Actualizar el resultado del proceso en la bitacora
      m_Bitacora_Return := 650;
      m_Bitacora_Msg    := Substr('ERROR. Lote: ' || v_Nro_Lote || '. ' ||
                                  Sqlerrm,
                                  1,
                                  200);

      p_result := m_Bitacora_Msg;
      ActualizarBitacora(m_bitacora_sec,
                         m_bitacora_msg,
                         'E',
                         m_bitacora_return);

      --Marcar con error en la tabla de Cargar---
      ActualizarCarga(v_Nro_Lote, v_Count, 0, 'E', null);
  End;

  ---

  Procedure RecibirCancelaciones(p_result out varchar2) Is
    v_bitacora        sfc_bitacora_t.id_bitacora%Type;
    m_bitacora_sec    integer;
    m_bitacora_msg    Varchar2(200);
    m_bitacora_return SEG_ERROR_T.id_error%TYPE;
    v_Count           Integer := 0;
    v_Counteo         Integer := 0;
    v_Nro_Lote        Integer := 0;
    v_result          varchar2(200);
    e_Error exception;
    v_Error        Integer := 0;
    v_nrosolicitud sub_solicitud_t.nro_solicitud%type;
  Begin

    InsertarBitacora('RD', v_bitacora);

    v_Nro_Lote := Getproximonumerolote();

    -- Insertar el registro como pendiente el InsertarCarga-
    InsertarCarga(v_Nro_Lote,
                  null,
                  'P',
                  'R',
                  'SISALRIL_SUIR.sub_ajustes_t');

    insert into sub_sfs_cancelacion_t
      (ID_REGISTRO_PATRONAL,
       ID_NSS,
       SECUENCIA,
       SECUENCIA_LACTANTE,
       PADECIMIENTO,
       TIPO_SUBSIDIO,
       ESTATUS,
       FECHA_REGISTRO,
       FECHA_RESPUESTA,
       ID_ERROR,
       MOTIVO_RECHAZO,
       ID_CANCELACION)
      select ID_REGISTRO_PATRONAL,
             ID_NSS,
             SECUENCIA,
             SECUENCIA_LACTANTE,
             PADECIMIENTO,
             TIPO_SUBSIDIO,
             ESTATUS,
             FECHA_REGISTRO,
             FECHA_RESPUESTA,
             ID_ERROR,
             MOTIVO_RECHAZO,
             rowid
        from sisalril_suir.sub_sfs_cancelacion_t
       where estatus = 'PE';

    For v_Record In (select a.rowid,
                            a.ID_REGISTRO_PATRONAL,
                            a.ID_NSS,
                            a.SECUENCIA,
                            a.SECUENCIA_LACTANTE,
                            a.PADECIMIENTO,
                            a.TIPO_SUBSIDIO,
                            a.ESTATUS,
                            a.FECHA_REGISTRO,
                            a.FECHA_RESPUESTA,
                            a.ID_ERROR,
                            a.MOTIVO_RECHAZO,
                            a.ID_CANCELACION
                       from sub_sfs_cancelacion_t a
                      where a.estatus = 'PE')

     Loop

      begin

        begin
          if v_record.tipo_subsidio = 'E' then
            select s.nro_solicitud
              into v_nrosolicitud
              from sub_solicitud_t s
             where s.nss = v_record.id_nss
               and s.secuencia = v_record.secuencia
               and s.padecimiento = v_record.padecimiento
               and s.tipo_subsidio = v_record.tipo_subsidio;
          else
            select s.nro_solicitud
              into v_nrosolicitud
              from sub_solicitud_t s
             where s.nss = v_record.id_nss
               and s.secuencia = v_record.secuencia
               and s.tipo_subsidio = v_record.tipo_subsidio;

          end if;

        Exception
          WHEN NO_DATA_FOUND THEN
            v_nrosolicitud := 0;
        end;

        if v_nrosolicitud = 0 then
          v_Error := 1;
          raise e_error;
        end if;

        if v_record.tipo_subsidio = 'E' then
          select count(*)
            into v_Counteo
            from sub_sfs_enf_comun_t ef
           where ef.nro_solicitud = v_nrosolicitud
             and ef.id_registro_patronal = v_record.id_registro_patronal
             and ef.id_estatus not in (2);

        elsif v_record.tipo_subsidio = 'M' then
          select count(*)
            into v_Counteo
            from sub_sfs_maternidad_t ma
           where ma.nro_solicitud = v_nrosolicitud
             and ma.id_registro_patronal = v_record.id_registro_patronal
             and ma.id_estatus not in (2);
        else
          select count(*)
            into v_Counteo
            from sub_sfs_lactancia_t la
           where la.nro_solicitud = v_nrosolicitud
             and la.id_estatus not in (2);
        end if;

        if v_Counteo > 0 then
          v_Error := 2;
          raise e_error;
        end if;

        --Insertando el elegible
        InsertarElegible(v_nrosolicitud,
                         v_record.id_registro_patronal,
                         null,
                         null,
                         null,
                         null,
                         null,
                         sysdate,
                         5,
                         null,
                         null,
                         null,
                         0,
                         null,
                         v_result);

        --Actualizando el subsidio
        ActualizarSubsidios(v_record.tipo_subsidio,
                            5,
                            v_nrosolicitud,
                            v_record.id_registro_patronal,
                            v_result);

        --Verificando los ajustes
        For v_Reg In (select aj.id_ajuste, aj.id_referencia
                        from sub_cuotas_t cu
                        join sfc_trans_ajustes_t aj
                          on aj.id_ajuste = cu.id_ajuste
                         and aj.estatus = 'PE'
                       where nro_solicitud = v_nrosolicitud)

         Loop

          select count(*)
            into v_Counteo
            from sfc_facturas_t fa
           where fa.id_referencia = v_Reg.Id_Referencia
             and fa.status not in ('PA', 'VE', 'VI');

          if v_Counteo = 0 then

            update sub_cuotas_t cu
               set cu.status_dispersion   = 'R',
                   cu.fecha_dispersion    = sysdate,
                   cu.id_error_dispersion = 65
             where cu.id_ajuste = v_Reg.Id_Ajuste;

            sfc_ajustes_pkg.marcarcancelado(v_Reg.Id_Ajuste, v_result);
          end if;

        End Loop;

        --Cancelando las cuotas de lactancia

        if v_record.tipo_subsidio = 'L' then
          update sub_cuotas_t cu
             set cu.status_dispersion   = 'R',
                 cu.fecha_dispersion    = sysdate,
                 cu.id_error_dispersion = 65
           where cu.nro_solicitud = v_nrosolicitud
             and cu.status_dispersion = 'C';
        end if;

        if v_result = '0' then
          v_Count := v_Count + 1;

          -- Actualizar la Cuenta en SUBS a las Cuotas Pendientes.....
          Update sub_sfs_cancelacion_t l
             set l.estatus = 'OK', l.FECHA_RESPUESTA = sysdate
           where l.rowid = v_Record.rowid;
        else
          Update sub_sfs_cancelacion_t l
             set l.estatus = 'RE', l.FECHA_RESPUESTA = sysdate
           where l.rowid = v_Record.rowid;
        end if;

      Exception
        when e_Error then
          Update sub_sfs_cancelacion_t l
             set l.estatus         = 'RE',
                 l.FECHA_RESPUESTA = sysdate,
                 l.MOTIVO_RECHAZO  = v_Error
           where l.rowid = v_Record.rowid;
      end;

      commit;
    End Loop;

    --Actualizando sisalril

    UPDATE sisalril_suir.sub_sfs_cancelacion_t sa
       SET (sa.estatus, sa.fecha_respuesta, sa.motivo_rechazo) =
           (select aj.estatus, aj.fecha_respuesta, aj.motivo_rechazo
              from sub_sfs_cancelacion_t aj
             where aj.ID_CANCELACION = sa.rowid)
     WHERE sa.estatus = 'PE';

    -- Marcar como completado en sfs_subs_cargar_t--
    ActualizarCarga(v_Nro_Lote, v_Count, 0, 'C', null);

    -- Actualizar el resultado del proceso en la bitacora
    m_Bitacora_Msg := 'OK. Lote: ' || v_Nro_Lote;
    ActualizarBitacora(m_bitacora_sec, m_bitacora_msg, 'O', '000');

    p_result := m_Bitacora_Msg;
  Exception
    When Others Then
      Rollback;

      -- Actualizar el resultado del proceso en la bitacora
      m_Bitacora_Return := 650;
      m_Bitacora_Msg    := Substr('ERROR. Lote: ' || v_Nro_Lote || '. ' ||
                                  Sqlerrm,
                                  1,
                                  200);

      p_result := m_Bitacora_Msg;
      ActualizarBitacora(m_bitacora_sec,
                         m_bitacora_msg,
                         'E',
                         m_bitacora_return);

      --Marcar con error en la tabla de Cargar---
      ActualizarCarga(v_Nro_Lote, v_Count, 0, 'E', null);

  End;

  --------------------------------------------------------------------------------------------------------------------
  --- Funcion para validar ajustes duplicados, si el ajuste existe retorna true, si no existe retorna false
  --Autor: Eury Vallejo
  --15/5/2017
  --------------------------------------------------------------------------------------------------------------------
  Function ValidarAjustesDuplicados(p_unico in nvarchar2)
    return boolean is
    v_count INTEGER := 0;
  Begin

  Select count(*)
    Into v_count
    from suirplus.sfc_trans_ajustes_t see
    Where see.unico = p_unico;


    If (v_count = 0) then
      Return false;
    Else
      Return true;
    End if;
  Exception
    when others then
      Return false;
  End ValidarAjustesDuplicados;
  

Begin
   SELECT * into v_parametros
   FROM srp_config_t t
   WHERE t.id_modulo = 'DISP_SFS';

 --variables asignadas Requeridas---------------------------------------------
  v_NumeroAsignado := v_parametros.field1;
  v_NumeroAsignadoEnf := v_parametros.field2;
  c_ftp_host := v_parametros.ftp_host;
  c_ftp_user := v_parametros.ftp_user;
  c_ftp_pass := v_parametros.ftp_pass;
  c_ftp_port := v_parametros.ftp_port;
  c_ora_outbox := v_parametros.field3;

end SUB_SFS_DISPERSION;