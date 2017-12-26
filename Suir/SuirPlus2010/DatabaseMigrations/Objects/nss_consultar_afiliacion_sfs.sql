CREATE OR REPLACE FUNCTION suirplus.NSS_CONSULTAR_AFILIACION_SFS(p_id_nss suirplus.sre_ciudadanos_t.id_nss%type) RETURN SYS_REFCURSOR IS
  l_http_request   utl_http.req;
  l_http_response  utl_http.resp;
  l_string_request VARCHAR2(32767);
  l_proxy          VARCHAR2(150);
  v_msg            VARCHAR2(32767);
  xml_data         XMLTYPE;
  C_RESULT         SYS_REFCURSOR;
BEGIN
  FOR r IN (
            Select ftp_host, ftp_user, ftp_pass, ftp_port, ftp_dir
              From suirplus.srp_config_t
             Where id_modulo = 'WS_SDSS'
           ) 
  LOOP
    l_string_request := '<?xml version="1.0" encoding="utf-8"?>'||chr(13)||chr(10)||
                        '<soap:Envelope'||
                        ' xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"'||
                        ' xmlns:xsd="http://www.w3.org/2001/XMLSchema"'||
                        ' xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">'||chr(13)||chr(10)||
                        '  <soap:Body>'||chr(13)||chr(10)||
                        '    <ConsultarAfiliacionSDSSporNSS xmlns="https://serviciosweb.com.do/consafiws/">'||chr(13)||chr(10)||
                        '      <nss>'||TO_CHAR(p_id_nss)||'</nss>'||chr(13)||chr(10)||
                        '      <usuario>'||r.ftp_user||'</usuario>'||chr(13)||chr(10)||
                        '      <clave>'||utl_raw.cast_to_varchar2(utl_encode.base64_decode(utl_raw.cast_to_raw(r.ftp_pass)))||'</clave>'||chr(13)||chr(10)||
                        '    </ConsultarAfiliacionSDSSporNSS>'||chr(13)||chr(10)||
                        '  </soap:Body>'||chr(13)||chr(10)||
                        '</soap:Envelope>';

    --Para buscar las credenciales del proxy
    Select 'http://' || ftp_dir || '\' || ftp_user || ':' || ftp_pass || '@' || ftp_host || ':' || ftp_port
      Into l_proxy
      From srp_config_t
     Where id_modulo = 'WS_USER';

    UTL_HTTP.set_proxy(l_proxy);
    UTL_HTTP.set_wallet('file:' || r.ftp_dir, r.ftp_port);

    l_http_request := UTL_HTTP.begin_request(url => r.ftp_host, method => 'POST', http_version => 'HTTP/1.1');

    UTL_HTTP.set_header(l_http_request, 'User-Agent', 'Mozilla/4.0');
    UTL_HTTP.set_header(l_http_request, 'Content-Type', 'text/xml; charset=utf-8');
    UTL_HTTP.set_header(l_http_request, 'SOAPAction', '"https://serviciosweb.com.do/consafiws/ConsultarAfiliacionSDSSporNSS"');
    UTL_HTTP.set_header(l_http_request, 'Content-Length', LENGTH(l_string_request));

    UTL_HTTP.write_text(l_http_request, l_string_request);

    l_http_response := UTL_HTTP.get_response(r => l_http_request);

    UTL_HTTP.read_text(l_http_response, v_msg);

    utl_http.end_response(r => l_http_response);

    --El webservice se ejecuto sin error
    If l_http_response.status_code = 200 then
      v_msg := replace(replace(v_msg,'&lt;','<'),'&gt;','>');

      xml_data := XMLTYPE.createxml(v_msg);

      xml_data := xml_data.extract('/soap:Envelope/soap:Body/child::node()',
                                   'xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"');

      OPEN C_RESULT FOR
        Select Extract(xml_data,
               '/ConsultarAfiliacionSDSSporNSSResponse/ConsultarAfiliacionSDSSporNSSResult/DatosAfiliacion/AfiliacionesSFS/AfiliacionSFS[@ciudadanoConsultado="1"]/NSS/child::text()',
               'xmlns="https://serviciosweb.com.do/consafiws/"').getNumberVal() AS ID_NSS,
               0 AS ERROR,
               NULL AS ERR_MSG
          From dual;
          
      RETURN C_RESULT;    
    End if;
  END LOOP;
EXCEPTION 
  WHEN OTHERS THEN
    v_msg := sqlerrm;
    OPEN C_RESULT FOR
      Select NULL AS ID_NSS,
             1 AS ERROR,
             v_msg AS ERR_MSG
        From dual;
    RETURN C_RESULT;    
END;