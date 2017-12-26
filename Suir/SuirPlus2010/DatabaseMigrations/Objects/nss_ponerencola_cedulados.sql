CREATE OR REPLACE PROCEDURE SUIRPLUS.NSS_PONERENCOLA_CEDULADOS(p_tipo_documento in suirplus.sre_tipo_documentos_t.id_tipo_documento%type) IS
  v_msg VARCHAR2(32767);  
BEGIN
  FOR R IN (SELECT s.id_solicitud, s.id_tipo, s.ult_usuario_act
              FROM suirplus.nss_solicitudes_t s
             WHERE EXISTS
			   (
			    SELECT id_solicitud
                  FROM suirplus.nss_det_solicitudes_t d
                 WHERE d.id_solicitud = s.id_solicitud
                   AND d.id_estatus = 1
                   AND d.id_tipo_documento = P_TIPO_DOCUMENTO
               )
             ORDER BY S.ID_SOLICITUD DESC)
  LOOP
    --Llama proceso que vifurca la solicitud para validarla
    SUIRPLUS.NSS_VALIDAR_SOLICITUD(R.ID_SOLICITUD, R.ULT_USUARIO_ACT, v_msg);
  END LOOP;
END;