CREATE OR REPLACE FUNCTION suirplus.NSS_WEBSERVICE_JCE_CED(p_no_documento in varchar2) RETURN VARCHAR2 IS
  v_url         varchar2(500);
  v_success     varchar2(100);  -- TRUE / FALSE
  v_message     varchar2(4000); -- Respuesta del webservices
  jce_respuesta varchar2(4000);
  m_url         varchar2(200);
  m_req         sys.utl_http.req;
  m_resp        sys.utl_http.resp;
  m_txt         varchar2(32000);
  hasta         varchar2(1000);
  v_proxy       varchar2(500);
BEGIN
  select 'http://' || ftp_dir || '\' || ftp_user || ':' || ftp_pass || '@' ||
         ftp_host || ':' || ftp_port, field2
    into v_proxy, hasta
    from suirplus.srp_config_t
   where id_modulo = 'WS_USER';

   select field1 || field2
     into m_url
     from suirplus.srp_config_t
    where id_modulo = 'WS JCE';


  jce_respuesta := null;

  v_url := m_url || CHR(38) || 'ID1=' || substr(p_no_documento,1,3) || CHR(38) || 'ID2=' || substr(p_no_documento,4,7) || CHR(38) || 'ID3=' || substr(p_no_documento,11,1);

  --consumir el webservice
  sys.utl_http.set_proxy(v_proxy);
  m_req := sys.utl_http.begin_request(v_url,'GET','HTTP/1.0');
  utl_http.set_header(m_req, 'user-agent', 'mozilla/4.0');

  --2.3.- Consumir Webservices con el No_Documento solicitado (confirmar si se puede usar "Carácter Set" : UTL-8).
  utl_http.set_header(m_req, 'content-type', 'text/html;charset=UTF-8');
  m_resp := sys.utl_http.get_response(m_req);

  BEGIN
    LOOP
      sys.utl_http.read_line(m_resp, m_txt, TRUE);
      jce_respuesta := jce_respuesta||m_txt;
    END LOOP;
    sys.utl_http.end_response(m_resp);
  EXCEPTION
    WHEN OTHERS THEN
      sys.utl_http.end_response(m_resp);
  END;

  --2.6.1.- Limpiar los caracteres especiales de los distintos campos (Letras No Legibles).
  jce_respuesta := upper(jce_respuesta);
  jce_respuesta := replace(jce_respuesta,chr( 0),'');
  jce_respuesta := replace(jce_respuesta,chr(10),'');
  jce_respuesta := replace(jce_respuesta,chr(13),'');

  -- Buscar status y mensaje de la respuesta del Webservice
  v_success := NSS_PARSEAR_CED(jce_respuesta, 'SUCCESS');
  v_message := NSS_PARSEAR_CED(jce_respuesta, 'MESSAGE');

  -- Grabar estadisticas de consumo
  insert into sre_trans_jce_t d (nro_documento, tipo_documento, status_code, mensaje)
  values (p_no_documento, 'C', m_resp.status_code, m_resp.reason_phrase || ' ' || jce_respuesta);
  commit;

  --2.4.- Validar respuestas del Webservices (OK, ID invalido, Webservices no disponible, error proxy, etc.).
  if (jce_respuesta is null
  or  jce_respuesta not like '<ROOT>%'
  or  jce_respuesta not like '%</ROOT>'
  or  m_resp.status_code <> 200             -- HTTP_OK = 200
  or  v_message = 'SERVICEID IS DISABLED!'  -- Usuario Desabilitado
  or  (v_success = 'FALSE' and v_message not like '%IS NOT FOUND') --
  ) then
    utl_http.close_persistent_conns;
    raise_application_error(-20000,'respuesta invalida:'||jce_respuesta);
  end if;

  -- Actualizar el contador de consumos
  if v_success = 'TRUE' then
    update suirplus.srp_config_t c
    set c.other3_dir  = to_number(c.other3_dir)-1
    where c.id_modulo = 'VTUNIPAGO';
    commit;
  end if;

  utl_http.close_persistent_conns;

  RETURN jce_respuesta;
EXCEPTION
  WHEN OTHERS THEN
    utl_http.close_persistent_conns;  
    raise_application_error(-20000,'error al consumir ws cedulado: '||sqlerrm);
END;