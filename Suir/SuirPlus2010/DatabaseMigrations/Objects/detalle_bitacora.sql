CREATE OR REPLACE PROCEDURE suirplus.DETALLE_BITACORA (
  p_id_bitacora   IN suirplus.SFC_DET_BITACORA_T.id_bitacora%TYPE,
  p_fecha_mensaje IN suirplus.SFC_DET_BITACORA_T.fecha_mensaje%TYPE,
  p_mensaje       IN suirplus.SFC_DET_BITACORA_T.mensaje%TYPE
) IS
PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
  INSERT INTO suirplus.SFC_DET_BITACORA_T
    (id, id_bitacora, fecha_mensaje, mensaje)
  VALUES
    (suirplus.SFC_DET_BITACORA_T_SEQ.nextval, p_id_bitacora, p_fecha_mensaje, p_mensaje);
  COMMIT WORK;
EXCEPTION WHEN OTHERS THEN
  RAISE_APPLICATION_ERROR(-20000, SQLERRM);
END;