CREATE OR REPLACE PROCEDURE SUIRPLUS.NSS_CALL_ACTUALIZAR_CIUDADANO
(
 p_nss in suirplus.sre_ciudadanos_t.id_nss%type,
 p_id_registro in suirplus.nss_det_solicitudes_t.id_registro%Type,
 p_ult_usuario_act suirplus.seg_usuario_t.id_usuario%Type,
 p_resultado out varchar2
) is  
  v_ciudadano in suirplus.sre_ciudadanos_t%rowtype;

BEGIN

  v_ciudadano.id_nss := p_nss;
  nss_actualizar_ciudadano(p_id_registro,
                         v_ciudadano, 
                         p_ult_usuario_act, 
                         p_resultado);
exception
  when others  then
   p_resultado := SQLERRM||' - '|| dbms_utility.format_error_backtrace;

END;
