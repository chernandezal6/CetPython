create or replace procedure suirplus.sfc_nacha_p(p_id_recepcion sre_det_movimiento_recaudo_t.id_recepcion%type) is

  /*
     *********************************************************************
     ** PROCEDIMIENTO QUE GENERA EL ARCHIVO NACHA CORRESPONDIENTE A LA
     ** ENTIDAD RECAUDADORA (ID_RECEPCION) A PARTIR DE LOS REGISTROS DE
     ** SRE_DET_MOVIMIENTO_RECAUDO_T VALIDADOS OK
     ** AUTOR : JOSE LUIS RIERA TONA
     ** FECHA : 18/ENERO/2005
     *********************************************************************
  */

  /* Declaracion de Variables locales */

  v_encabezado_archivo        varchar2(100);
  v_encabezado_lote           varchar2(100);
  v_detalle_lote              varchar2(100);
  v_adenda_detalle            varchar2(100);
  v_control_lote              varchar2(100);
  v_control_archivo           varchar2(100);
  v_control_relleno           varchar2(100);
  v_descripcion_tran          varchar2(80);
  v_nombre_archivo            sre_archivos_t.nombre_archivo_nacha_ne%type;
  v_id_archivo                NUMBER;
  v_cantidad_registro         number;
  v_archivos_generados        number;
  v_id_entidad_recaudadora    sre_archivos_t.id_entidad_recaudadora%type;
  v_codigo_origen_transaccion varchar2(25);
  v_fecha_efectiva            varchar2(6);
  v_fecha_descriptiva         varchar2(6);
  p_resultado                 varchar2(100);
  continua_lote               boolean;
  v_hasta                     number;
  v_cant_reg                  number;
  v_tran_adendas              number;
  v_monto_debito              number;
  v_hora_limite               sfc_det_parametro_t.valor_texto%type;
  v_digito_chequeo            number;
  v_cta_concentradora         sfc_det_parametro_t.valor_texto%type;
  v_ruta_transito             sfc_det_parametro_t.valor_texto%type;
  v_total_control_lote        number;
  v_total_control_archivo     number;
  v_secuencia_lote            number;
  v_monto_total_archivo       sre_det_movimiento_recaudo_t.monto%type;
  v_monto_parcial_archivo     sre_det_movimiento_recaudo_t.monto%type;
  v_monto_max_lote            sre_det_movimiento_recaudo_t.monto%type;
  v_monto_detalle             sre_det_movimiento_recaudo_t.monto%type;
  v_mailfrom                  varchar2(100);
  mail_to                     varchar2(4000);

  l_conn          UTL_TCP.connection;
  c               ib_config := ib_config('IB BPTSS');
  c_ftp_host      VARCHAR2(100) := c.ftp_host;
  c_ftp_user      VARCHAR2(100) := c.ftp_user;
  c_ftp_pass      VARCHAR2(100) := c.ftp_pass;
  c_ftp_port      VARCHAR2(100) := c.ftp_port;
  c_ftp_nacha     VARCHAR2(100) := '/archivos_nacha_se/';
  c_ftp_encripted VARCHAR2(100) := '/archivos_nacha/';
  c_line_end      varchar2(5) := chr(13) || chr(10);
  v_filename      varchar2(250);
  v_filedata      clob;
  v_del_nacha     sre_archivos_t.nombre_archivo_respuesta%type;

  /* Declaracion de cursores */

  -- Inicio
begin
  v_mailfrom := 'info@mail.tss2.gov.do';
  begin
  
    --Validar que Existan Registros en SRE_DET_MOVIMIENTO_RECAUDO_T
    BEGIN
      select count(mr.id_referencia_isr)
        into v_cant_reg
        from sre_det_movimiento_recaudo_t mr
       where mr.id_recepcion = p_id_recepcion
         and mr.status = 'OK';
      if nvl(v_cant_reg, 0) = 0 then
        goto salir;
      end if;
    exception
      when others then
        p_resultado := 'ERROR OTHERS BUSCANDO Registros CON EL NO. DE RECEPCION ' ||
                       p_id_recepcion || ' ' || sqlerrm;
        goto salir;
    END;
  
    --Buscar el id de la Entidad Recaudadora.
    SELECT a.id_entidad_recaudadora
      INTO v_id_entidad_recaudadora
      FROM sre_archivos_t a
     where a.id_recepcion = p_id_recepcion;
  
    --Buscar  Hora Limite.
    SELECT dp.valor_texto
      INTO v_hora_limite
      FROM sfc_det_parametro_t dp
     where dp.id_parametro = 50;
  
    --Buscar  Digito de Chequeo.
    SELECT dp.valor_numerico
      INTO v_digito_chequeo
      FROM sfc_det_parametro_t dp
     where dp.id_parametro = 51;
  
    --Buscar Cta. Concentradora.
    SELECT dp.valor_texto
      INTO v_cta_concentradora
      FROM sfc_det_parametro_t dp
     where dp.id_parametro = 52;
  
    --Buscar Ruta y Transito.
    SELECT dp.valor_numerico
      INTO v_ruta_transito
      FROM sfc_det_parametro_t dp
     where dp.id_parametro = 53;
  
    v_fecha_descriptiva := to_char(sysdate, 'yymmdd');
    if to_char(sysdate, 'hh24miss') between '000001' and v_hora_limite then
      v_fecha_efectiva := to_char(sysdate, 'yymmdd');
    else
      v_fecha_efectiva := to_char(srp_pkg.business_date(trunc(sysdate), 1),
                                  'yymmdd');
    end if;
  
    --Armar el nombre del archivo.
    v_nombre_archivo := 'nacha' ||
                        LPAD(to_char(v_id_entidad_recaudadora), 2, '0') ||
                        LPAD(to_char(p_id_recepcion), 10, '0') ||
                        v_fecha_efectiva || '.txt';
    select sfc_nacha_seq.nextval into v_id_archivo from dual;
  exception
    when no_data_found then
      p_resultado := 'TRANSACCION CANCELADA:ERROR ASIGNANDO EL NOMBRE DEL ARCHIVO, ' ||
                     sqlerrm;
      goto salir;
    when others then
      p_resultado := 'TRANSACCION CANCELADA:ERROR BUSCANDO LA ENTIDAD RECAUDADORA AL ASIGNAR EL NOMBRE DEL ARCHIVO, ERROR ORACLE: ' ||
                     sqlerrm;
      goto salir;
  end;

  v_filename := v_nombre_archivo;
  dbms_lob.createtemporary(v_filedata, TRUE);
  dbms_lob.open(v_filedata, dbms_lob.lob_readwrite);

  v_cantidad_registro     := 0;
  v_tran_adendas          := 0;
  v_monto_debito          := 0;
  v_total_control_lote    := 0;
  v_total_control_archivo := 0;
  v_descripcion_tran      := 'CONCENTRACION RECAUDO ISR';

  -- start RJ 11/05/2005
  if v_id_entidad_recaudadora = 11 then
    -- solo para el banco del progreso --
    select trim(to_char(codigo_origen_transaccion, '0000000000'))
      into v_codigo_origen_transaccion
      from sfc_entidad_recaudadora_t
     where id_entidad_recaudadora = v_id_entidad_recaudadora;
  else
    -- para todos los demas bancos
    select rpad(to_char(codigo_origen_transaccion), 10, ' ')
      into v_codigo_origen_transaccion
      from sfc_entidad_recaudadora_t
     where id_entidad_recaudadora = v_id_entidad_recaudadora;
  end if;
  -- end RJ 11/05/2005

  -- Preparacion del Registro de Encabezado de Archivo
  select '1' || rpad('01', 2, '0') ||
         lpad(to_char(er.ruta_y_transito || er.digito_chequeo), 10, ' ') ||
         v_codigo_origen_transaccion || -- by RJ 18/05/2005 rpad(to_char(er.codigo_origen_transaccion), 10, ' ')||
         v_fecha_descriptiva || to_char(sysdate, 'hh24mi') ||
         lpad(v_id_archivo, 1, '0') || lpad('094', 3, '0') ||
         lpad('10', 2, '0') || lpad('1', 1, '0') ||
         rpad(er.entidad_recaudadora_des, 23, ' ') ||
         rpad(er.texto_origen, 23, ' ') || rpad(' ', 8, ' ')
    into v_encabezado_archivo
    from sfc_entidad_recaudadora_t er
   where er.id_entidad_recaudadora = v_id_entidad_recaudadora;
  dbms_lob.writeAppend(v_filedata,
                       length(v_encabezado_archivo || c_line_end),
                       v_encabezado_archivo || c_line_end);

  v_cantidad_registro := v_cantidad_registro + 1;
  select sum(nvl(mr.monto, 0))
    into v_monto_total_archivo
    from sre_det_movimiento_recaudo_t mr
   where mr.id_recepcion = p_id_recepcion
     and mr.status = 'OK';
  v_monto_parcial_archivo := 0;
  v_monto_max_lote        := 100000000;
  v_monto_detalle         := 99000000;
  if v_monto_total_archivo > v_monto_max_lote then
    v_monto_parcial_archivo := v_monto_total_archivo - v_monto_detalle;
  else
    v_monto_detalle := v_monto_total_archivo;
  end if;
  continua_lote    := true;
  v_secuencia_lote := 1;
  while continua_lote loop
    continua_lote := false;
    -- Preparacion de los Registros de Encabezado de Lote
    select '5' || lpad('200', 3, '0') || rpad(er.texto_origen, 16, ' ') ||
           rpad(er.cuenta_recaudadora, 20, ' ') ||
           v_codigo_origen_transaccion || -- by RJ 11/05/2005 --rpad(to_char(er.codigo_origen_transaccion), 10, ' ')||
           rpad('PPD', 3, ' ') || rpad('06', 10, ' ') ||
           v_fecha_descriptiva || v_fecha_efectiva || rpad('000', 3, ' ') ||
           rpad('1', 1, ' ') || lpad(to_char(er.ruta_y_transito), 8, ' ') ||
           lpad(to_char(v_secuencia_lote), 7, '0')
      into v_encabezado_lote
      from sfc_entidad_recaudadora_t er
     where er.id_entidad_recaudadora = v_id_entidad_recaudadora;
    dbms_lob.writeAppend(v_filedata,
                         length(v_encabezado_lote || c_line_end),
                         v_encabezado_lote || c_line_end);
  
    v_cantidad_registro := v_cantidad_registro + 1;
  
    -- Preparacion de los Registros de Detalle
    select '6' || lpad('22', 2, '0') || lpad(v_ruta_transito, 8, ' ') ||
           lpad(v_digito_chequeo, 1, ' ') ||
           rpad(v_cta_concentradora, 17, ' ') ||
           lpad(trim(to_char(v_monto_detalle, '99999999v99')), 10, '0') ||
           rpad(to_char(er.codigo_origen_transaccion), 15, ' ') ||
           rpad(er.texto_origen, 22, ' ') || lpad(' ', 2, ' ') ||
           lpad('1', 1, '1') || lpad(to_char(er.ruta_y_transito), 8, ' ') ||
           lpad(to_char(v_secuencia_lote * 10), 7, '0')
      into v_detalle_lote
      from sre_archivos_t a, sfc_entidad_recaudadora_t er
     where a.id_recepcion = p_id_recepcion
       and er.id_entidad_recaudadora = a.id_entidad_recaudadora;
  
    dbms_lob.writeAppend(v_filedata,
                         length(v_detalle_lote || c_line_end),
                         v_detalle_lote || c_line_end);
    v_cantidad_registro := v_cantidad_registro + 1;
    v_tran_adendas      := v_tran_adendas + 1;
    --  v_total_control_lote := v_total_control_lote + v_ruta_transito;
    v_total_control_lote := v_ruta_transito; -- Temporalmente, mientras se genera solo un detalle por Lote.
  
    -- Preparacion del Registro de Adenda
    select '7' || lpad('05', 2, '0') || rpad(v_descripcion_tran, 80, ' ') ||
           lpad('0001', 4, '0') ||
           lpad(to_char(v_secuencia_lote * 10), 7, '0')
      into v_adenda_detalle
      from dual;
  
    dbms_lob.writeAppend(v_filedata,
                         length(v_adenda_detalle || c_line_end),
                         v_adenda_detalle || c_line_end);
    v_cantidad_registro := v_cantidad_registro + 1;
    v_tran_adendas      := v_tran_adendas + 1;
  
    -- Preparacion del Registro de Control de Lote
    select '8' || lpad('200', 3, '0') || lpad(v_tran_adendas, 6, '0') ||
           lpad(v_total_control_lote, 10, '0') ||
           lpad(trim(to_char(v_monto_debito, '9999999999v99')), 12, '0') ||
           lpad(trim(to_char(v_monto_detalle, '9999999999v99')), 12, '0') ||
           rpad(to_char(er.codigo_origen_transaccion), 10, ' ') ||
           rpad(' ', 19, ' ') || rpad(' ', 6, ' ') ||
           lpad(to_char(er.ruta_y_transito), 8, ' ') ||
           lpad(to_char(v_secuencia_lote), 7, '0')
      into v_control_lote
      from sre_archivos_t a, sfc_entidad_recaudadora_t er
     where a.id_recepcion = p_id_recepcion
       and er.id_entidad_recaudadora = a.id_entidad_recaudadora;
  
    dbms_lob.writeAppend(v_filedata,
                         length(v_control_lote || c_line_end),
                         v_control_lote || c_line_end);
    v_cantidad_registro     := v_cantidad_registro + 1;
    v_total_control_archivo := v_total_control_archivo +
                               v_total_control_lote;
    if v_monto_parcial_archivo > v_monto_max_lote then
      v_monto_parcial_archivo := v_monto_parcial_archivo - v_monto_detalle;
      v_secuencia_lote        := v_secuencia_lote + 1;
      continua_lote           := true;
    elsif v_monto_parcial_archivo > 0 then
      v_monto_detalle         := v_monto_parcial_archivo;
      v_monto_parcial_archivo := 0;
      v_secuencia_lote        := v_secuencia_lote + 1;
      continua_lote           := true;
    end if;
  end loop; -- Fin del Loop While Continua_lote

  -- Preparacion del Registro de Control de Archivo
  select '9' || lpad('1', 6, '0') || lpad('1', 6, '0') ||
         lpad(v_tran_adendas, 8, '0') ||
         lpad(v_total_control_archivo, 10, '0') ||
         lpad(trim(to_char(v_monto_debito, '9999999999v99')), 12, '0') ||
         lpad(trim(to_char(v_monto_detalle, '9999999999v99')), 12, '0') ||
         lpad(' ', 39, ' ')
    into v_control_archivo
    from sre_archivos_t a, sfc_entidad_recaudadora_t er
   where a.id_recepcion = p_id_recepcion
     and er.id_entidad_recaudadora = a.id_entidad_recaudadora;

  dbms_lob.writeAppend(v_filedata,
                       length(v_control_archivo || c_line_end),
                       v_control_archivo || c_line_end);
  v_cantidad_registro := v_cantidad_registro + 1;
  if v_cantidad_registro <> 10 then
    select 10 - mod(v_cantidad_registro, 10) into v_hasta from dual;
  else
    v_hasta := 0;
  end if;
  for contador in 1 .. v_hasta loop
    select lpad('9', 94, '9') into v_control_relleno from dual;
    dbms_lob.writeAppend(v_filedata,
                         length(v_control_relleno || c_line_end),
                         v_control_relleno || c_line_end);
    v_cantidad_registro := v_cantidad_registro + 1;
  end loop;

  -- SI EL ARCHIVO GENERO LINEAS CREAMOS EL ARCHIVO Y SUS DEPENDENCIAS
  if nvl(v_cantidad_registro, 0) != 0 then
    v_archivos_generados := nvl(v_archivos_generados, 0) + 1;
  
    update sre_archivos_t a
       set a.nombre_archivo_nacha_ne = v_filename
     where a.id_recepcion = p_id_recepcion;
  
    -- obtener los nombres de los archivos de respuesta
    select a.nombre_archivo_nacha
      into v_del_nacha
      from sre_archivos_t a
     where id_recepcion = p_id_recepcion;
  
    l_conn := ftp.login(c_ftp_host, c_ftp_port, c_ftp_user, c_ftp_pass);
  
    begin
      if (v_del_nacha is not null) then
        ftp.send_command(l_conn, 'DELE ' || c_ftp_encripted || v_del_nacha);
      end if;
    exception
      when others then
        -- modificado por: CMHA
        -- fecha         : 03/03/2017
        --Buscamos la receptor en la tabla sfc_procesos_t 
        select p.lista_error
          into mail_to
          from suirplus.sfc_procesos_t p
         where p.id_proceso = '91';
      
        system.html_mail(v_mailfrom,
                         mail_to,
                         'BORRAR ARCHIVO NACHA',
                         'DELE ' || c_ftp_encripted || v_del_nacha);
    end;
  
    ftp.binary(p_conn => l_conn);
    ftp.put_clob(p_conn => l_conn,
                 p_file => c_ftp_nacha || v_filename,
                 p_data => v_filedata);
  
    -- marcar como procesado (un windows application lo toma, lo encripta y lo marca "E")
    update sre_archivos_t a
       set a.status_crypto_nacha = 'P'
     where id_recepcion = p_id_recepcion;
  
    -- cerrar la coneccion al ftp server
    ftp.logout(l_conn);
    utl_tcp.close_all_connections;
    dbms_lob.freetemporary(v_filedata);
  end if; -- Fin de condicion si se generaron lineas en el archivo (v_cantidad_registro != 0)

  <<salir>>
  if p_resultado is null then
    -- si no hubo errores
    if nvl(v_archivos_generados, 0) = 1 then
      p_resultado := 'PROCESO FINALIZADO CON EXITO, ' ||
                     ltrim(rtrim(to_char(nvl(v_archivos_generados, 0),
                                         '99,999'))) ||
                     ' ARCHIVOS GENERADOS CON ' ||
                     ltrim(rtrim(to_char(nvl(v_cantidad_registro, 0),
                                         '999,999,999'))) || ' LINEAS';
    elsif nvl(v_archivos_generados, 0) > 1 then
      p_resultado := 'PROCESO FINALIZADO CON EXITO ' ||
                     ltrim(rtrim(to_char(nvl(v_archivos_generados, 0),
                                         '99,999'))) ||
                     ' ARCHIVOS GENERADOS ';
    elsif nvl(v_archivos_generados, 0) = 0 then
      p_resultado := 'FIN DEL PROCESO, NO EXISTEN MOVIMIENTOS HISTORICOS PENDIENTES DE GENERACION DE ARCHIVOS  ';
    end if;
    dbms_output.put_line(p_resultado || chr(13));
    commit; -- Grabamos
  else
    rollback; -- Como hubo errores, no grabamos y devolvemos todo lo realizado
  end if;
end sfc_nacha_p;
