CREATE OR REPLACE PROCEDURE suirplus.NSS_INSERTAR_EVALUACION_VISUAL
(
 p_tipo in char,
 p_id_registro in suirplus.nss_det_solicitudes_t.id_registro%Type,
 p_id_nss in suirplus.sre_ciudadanos_t.id_nss%Type,
 p_no_documento_sol in suirplus.nss_det_solicitudes_t.No_documento_sol%Type,
 p_id_accion_ev in suirplus.nss_accion_evaluacion_visual_t.id_accion_ev%Type,
 p_ult_usuario_act in suirplus.seg_usuario_t.id_usuario%Type,
 p_id_evaluacion in out suirplus.nss_evaluacion_visual_t.id_evaluacion%Type,
 p_resultado out varchar2
) IS
  v_conteo  pls_integer;

  e_ciudadano_no_existe  EXCEPTION;
  e_usuario_no_existe    EXCEPTION;
  e_solicitud_no_existe  EXCEPTION;
BEGIN
  IF upper(p_tipo) = 'H' THEN -- Header
    --Ver si existe el detalle de la solicitud, si no existe termina la ejecucion
    Select count(*)
      Into v_conteo
      From suirplus.nss_det_solicitudes_t d
     Where d.id_registro = p_id_registro;

    IF v_conteo = 0 THEN
      RAISE e_solicitud_no_existe;
    END IF;

    Select count(*)
      Into v_conteo
      From seg_usuario_t t
     Where t.id_usuario = upper(p_ult_usuario_act);

    If v_conteo = 0 Then
      RAISE e_usuario_no_existe;
    End if;

    -- Insertamos la solicitud en el maestro de Evaluacion Visual
    INSERT INTO Suirplus.Nss_Evaluacion_Visual_t
    (
     ID_EVALUACION,
     ID_REGISTRO,
     FECHA_REGISTRO,
     FECHA_RESPUESTA,
     ESTATUS,
     USUARIO_PROCESA,
     ULT_FECHA_ACT,
     ULT_USUARIO_ACT
    )
    VALUES
    (
     Suirplus.NSS_EVALUACION_VISUAL_T_SEQ.NEXTVAL,
     P_ID_REGISTRO,
     SYSDATE,
     NULL,
     'PE',
     NULL,
     SYSDATE,
     p_ult_usuario_act
    )
    RETURNING ID_EVALUACION INTO p_id_evaluacion;
  ELSIF upper(p_tipo) = 'D' THEN --Detail
    --Ver si existe el ciudadano sino viene nulo, si no existe termina la ejecucion
    IF p_id_nss IS NOT NULL THEN
      Select count(*)
        Into v_conteo
        From suirplus.sre_ciudadanos_t c
       Where c.id_nss = p_id_nss;

      IF v_conteo = 0 THEN
        RAISE e_ciudadano_no_existe;
      END IF;
    END IF;

    -- Insertamos el detalle de la Evaluacion Visual
    INSERT INTO Suirplus.Nss_Det_Evaluacion_Visual_t
    (
     ID_DET_EVALUACION,
     ID_EVALUACION,
     ID_NSS,
     ID_EXPEDIENTE,
     ID_ACCION_EV
    )
    VALUES
    (
     Suirplus.NSS_DET_EV_SEQ.NEXTVAL,
     P_ID_EVALUACION,
     P_ID_NSS,
     P_NO_DOCUMENTO_SOL,
     P_ID_ACCION_EV
    );
  END IF;

  p_resultado := 'OK';
EXCEPTION
  WHEN e_ciudadano_no_existe THEN
    p_resultado := Suirplus.Seg_Retornar_Cadena_Error('151', NULL, NULL);
  WHEN e_solicitud_no_existe THEN
    p_resultado := Suirplus.Seg_Retornar_Cadena_Error('181', NULL, NULL);
  WHEN e_usuario_no_existe THEN
    p_resultado := Suirplus.Seg_Retornar_Cadena_Error('1', NULL, NULL);
  WHEN OTHERS THEN
    p_resultado := SQLERRM||' - '||dbms_utility.format_error_backtrace;
END;