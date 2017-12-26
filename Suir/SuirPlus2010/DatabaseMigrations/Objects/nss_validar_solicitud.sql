CREATE OR REPLACE PROCEDURE suirplus.NSS_VALIDAR_SOLICITUD
(
 p_id_solicitud    in suirplus.nss_solicitudes_t.id_solicitud%type,
 p_ult_usuario_act in suirplus.seg_usuario_t.id_usuario%type,
 p_resultado       out varchar2
) IS
  v_id_tipo suirplus.nss_solicitudes_t.id_tipo%type;
  e_solicitud_no_existe EXCEPTION;
BEGIN
  --Si no existe la solicitud, termina la ejecucion informando en bitacora
  BEGIN
    SELECT s.id_tipo
      INTO v_id_tipo
      FROM suirplus.nss_solicitudes_t s
     WHERE s.id_solicitud = p_id_solicitud;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RAISE e_solicitud_no_existe;
  END;

  -- Llamamos lor procedures especificos por tipo de solicitud
  CASE
     WHEN v_id_tipo = 1 THEN -- MENORES SIN DOCUMENTOS NACIONALES
       SUIRPLUS.NSS_VALIDAR_SOL_MENORES_NAC(p_id_solicitud, p_ult_usuario_act, p_resultado);
     WHEN v_id_tipo = 2 THEN -- MENORES CON NUI
       SUIRPLUS.NSS_VALIDAR_SOLICITUD_NUI(p_id_solicitud, p_ult_usuario_act, p_resultado);
     WHEN v_id_tipo = 3 THEN -- CEDULADOS
       SUIRPLUS.NSS_VALIDAR_SOL_CEDULADOS(p_id_solicitud, p_ult_usuario_act, p_resultado);
     WHEN v_id_tipo = 4 THEN -- TRABAJADORES EXTRANJEROS      
       SUIRPLUS.NSS_VALIDAR_SOL_EXTRANJEROS(p_id_solicitud, p_ult_usuario_act, p_resultado);
     WHEN v_id_tipo = 5 THEN -- MENORES SIN DOCUMENTOS EXTRANJEROS
       SUIRPLUS.NSS_VALIDAR_SOL_MENORES_EXT(p_id_solicitud, p_ult_usuario_act, p_resultado);
  END CASE;
EXCEPTION
  WHEN e_solicitud_no_existe THEN
    p_resultado := Suirplus.Seg_Retornar_Cadena_Error('181', NULL, NULL); --Solicitud Invalida.
  WHEN OTHERS THEN
    p_resultado := SQLERRM;
END;