CREATE OR REPLACE FUNCTION SUIRPLUS.NSS_WEBSERVICE_JCE_NUI(p_no_documento in varchar2) RETURN VARCHAR2 IS
  intentos      integer := 0;
  maximo        integer := 15;
  m_url         varchar2(2000);
  jce_respuesta varchar2(4000);
  i_exito       pls_integer;  --Para saber si pudo sonsumir el webservice

  v_success varchar2(100);  -- TRUE / FALSE
  m_req     sys.utl_http.req;
  m_resp    sys.utl_http.resp;
  m_txt     varchar2(32000);
BEGIN
  -- Buscar la URL del Webservices.
  select field1
    into m_url
    from suirplus.srp_config_t
   where id_modulo='WS_USER';

  --consumir el webservice
  intentos := 0;
  i_exito  := 0;
  WHILE (intentos < maximo) LOOP
    BEGIN
      jce_respuesta := null;

      m_req := sys.utl_http.begin_request(m_url||substr(p_no_documento,1,3)||'-'||substr(p_no_documento,4,7)||'-'||substr(p_no_documento,11,1),'GET','HTTP/1.0');
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
      EXCEPTION WHEN OTHERS THEN
        sys.utl_http.end_response(m_resp);
      END;
      
      --2.6.1.- Limpiar los caracteres especiales de los distintos campos (Letras No Legibles).
      jce_respuesta := upper(jce_respuesta);
      jce_respuesta := replace(jce_respuesta,chr( 0),'');
      jce_respuesta := replace(jce_respuesta,chr(10),'');
      jce_respuesta := replace(jce_respuesta,chr(13),'');

      -- Buscar status y mensaje de la respuesta del Webservice
      v_success := NSS_PARSEAR_NUI(jce_respuesta, 'CONSULTAVALIDA');

      -- Grabar estadisticas de consumo
      insert into suirplus.sre_trans_jce_t d (nro_documento, tipo_documento, status_code, mensaje)
      values (p_no_documento, 'U', m_resp.status_code, m_resp.reason_phrase || ' ' || jce_respuesta);
      commit;

      -- Actualizar el contador de consumos
      if v_success = 'TRUE' then
        update suirplus.srp_config_t c
        set c.other3_dir  = to_number(c.other3_dir)-1
        where c.id_modulo = 'VTUNIPAGO';
        commit;
      end if;
      
      i_exito  := 1;
      intentos := maximo; --por si acaso
      EXIT; --Sale de la iteacion     
    EXCEPTION WHEN OTHERS THEN
      intentos := intentos+1; 
    END;
  END LOOP;
  
  utl_http.close_persistent_conns;

  if i_exito = 0 then -- si no cambio la variable, no pudo consultar el webservice
    raise_application_error(-20000,'error al consumir ws NUI');
  else
    RETURN jce_respuesta;
  end if;
EXCEPTION WHEN OTHERS THEN
  utl_http.close_persistent_conns;
  raise_application_error(-20000,'error al consumir ws NUI '||sqlerrm);
END;