CREATE OR REPLACE PROCEDURE suirplus.BITACORA (
  p_id_bitacora IN OUT suirplus.SFC_BITACORA_T.id_bitacora%TYPE,
  p_accion      IN VARCHAR2 DEFAULT 'INI',
  p_id_proceso  IN suirplus.SFC_BITACORA_T.id_proceso%TYPE,
  p_mensage     IN suirplus.SFC_BITACORA_T.mensage%TYPE DEFAULT NULL,
  p_status      IN suirplus.SFC_BITACORA_T.status%TYPE DEFAULT NULL,
  p_id_error    IN suirplus.SEG_ERROR_T.id_error%TYPE DEFAULT NULL,
  p_seq_number  IN suirplus.ERRORS.seq_number%TYPE DEFAULT NULL,
  p_periodo     IN suirplus.SFC_BITACORA_T.periodo%TYPE DEFAULT NULL
) IS
PRAGMA AUTONOMOUS_TRANSACTION;

  v_is_bitacora  suirplus.SFC_PROCESOS_T.is_bitacora%type;
  
  --Para saber si el proceso debe grabar en bitacora
  CURSOR c_bit IS
    SELECT is_bitacora
    FROM suirplus.SFC_PROCESOS_T
    WHERE id_proceso = p_id_proceso;
BEGIN
  OPEN c_bit;
  
  FETCH c_bit INTO v_is_bitacora;
  
  CLOSE c_bit;

  --Si el proceso no guarda en bitacora, sale.
  IF NVL(upper(v_is_bitacora), 'N') = 'N' THEN
    RETURN;
  END IF;
  
  CASE p_accion
  WHEN 'INI' THEN
    --Crea el registro en bitacora
    SELECT sfc_bitacora_seq.NEXTVAL INTO p_id_bitacora FROM dual;
    INSERT INTO SFC_BITACORA_T
      (id_proceso, id_bitacora, fecha_inicio, fecha_fin, mensage, status, periodo)
    VALUES
      (p_id_proceso, p_id_bitacora, SYSDATE, NULL, NULL, 'P', p_periodo);
  WHEN 'FIN' THEN
    --Actualizamos la bitacora para finalizar el proceso
    UPDATE suirplus.SFC_BITACORA_T
      SET fecha_fin  = SYSDATE,
          mensage    = p_mensage,
          status     = p_status,
          seq_number = p_seq_number,
          id_error   = p_id_error
    WHERE id_bitacora = p_id_bitacora;
  ELSE
    RAISE_APPLICATION_ERROR(-20000, 'Parámetro invalido');
  END CASE;

  COMMIT WORK;

END;