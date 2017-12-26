CREATE OR REPLACE PROCEDURE SUIRPLUS.NSS_CAMBIAR_STATUS_SOLICITUD
(p_id_solicitud in suirplus.nss_solicitudes_t.id_solicitud%type,
 p_id_registro in suirplus.nss_det_solicitudes_t.id_registro%type,
 p_ult_usuario_act in suirplus.seg_usuario_t.id_usuario%type,
 p_resultado out varchar2
) IS
  v_id_bitacora  suirplus.sfc_bitacora_t.id_bitacora%TYPE;
  v_id_proceso   suirplus.sfc_procesos_t.id_proceso%TYPE := '78'; --Cambiar Estatus a Solicitud Asignacion NSS
  v_id_solicitud suirplus.nss_solicitudes_t.id_solicitud%TYPE := NULL;
  
  v_inicio           date := sysdate;
  v_final            date;
  v_conteo           pls_integer;
  v_mensaje          varchar2(500);
  v_resultado        varchar2(200);

  e_usuario_no_existe    EXCEPTION;
  e_solicitud_no_existe  EXCEPTION;
  e_estatus_sol_invalido EXCEPTION;
  e_proceso_no_existe    EXCEPTION;
BEGIN
  -- Grabar en Bitacora que va a comenzar el proceso
  suirplus.bitacora(v_id_bitacora, 'INI', v_id_proceso);

  --Si no existe el proceso, termina la ejecucion informando en bitacora
  SELECT COUNT(*)
    INTO v_conteo
    FROM suirplus.Sfc_Procesos_t a
   WHERE id_proceso = v_id_proceso;

  IF v_conteo = 0 THEN
    RAISE e_proceso_no_existe;
  END IF;

  --Ver si existe la solicitud, si no existe termina la ejecucion
  If (p_id_solicitud is null and p_id_registro is null) Then
    RAISE e_solicitud_no_existe;    
  End if;
    
  --Ver si la solicitud existe
  Select count(*)
    Into v_conteo
    From suirplus.nss_solicitudes_t s
    Join suirplus.nss_det_solicitudes_t d
      On d.id_solicitud = s.id_solicitud    
   Where s.id_solicitud = NVL(p_id_solicitud, s.id_solicitud)
     And d.id_registro = NVL(p_id_registro, d.id_registro);

  IF v_conteo = 0 THEN
    RAISE e_solicitud_no_existe;
  END IF;

  --Ver si la solicitud teiene algun registro rechazado o en evaluacion visual
  Select count(*)
    Into v_conteo
    From suirplus.nss_solicitudes_t s
    Join suirplus.nss_det_solicitudes_t d
      On d.id_solicitud = s.id_solicitud
     And d.id_estatus IN(4, 6) --Solo si esta Rechazado o en Evaluacion Visual
   Where s.id_solicitud = NVL(p_id_solicitud, s.id_solicitud) --Para salvar el NULO
     And d.id_registro = NVL(p_id_registro, d.id_registro); --Para salvar el NULO

  IF v_conteo = 0 THEN
    RAISE e_estatus_sol_invalido;
  END IF;

  -- Ver si existe el usuario, si no existe termina la ejecucion
  Select count(*)
    Into v_conteo
    From seg_usuario_t t
   Where t.id_usuario = upper(p_ult_usuario_act);

  If v_conteo = 0 Then
    RAISE e_usuario_no_existe;
  End if;

  -- Grabar primer seguimiento en detalle de bitacora
  suirplus.detalle_bitacora(v_id_bitacora, sysdate,SUBSTR('Inicio del PROCESO '||v_id_proceso||' a las '||to_char(sysdate,'dd/mm/yyyy hh:mi:ss')||chr(13)||chr(10)||
                                                    'PARAMETROS: p_id_solicitud = '||CASE NVL(p_id_solicitud,0) WHEN 0 THEN 'N/A' ELSE to_char(p_id_solicitud) END||
                                                    ', p_id_registro = '||CASE NVL(p_id_registro,0) WHEN 0 THEN 'N/A' ELSE TO_CHAR(p_id_registro) END||
                                                    ', p_ult_usuario_act = '||p_ult_usuario_act,1,500));

  -- Ver si existen solicitudes de asignacion nns a menores en evaluacion visual
  -- Si existe rechazarla todas y dejar solo la que estoy procesando
  FOR C_SOL IN
    (
     Select d.*
       From suirplus.nss_solicitudes_t s
       Join suirplus.nss_det_solicitudes_t d
         On d.id_solicitud = s.id_solicitud
        And d.id_estatus IN (4, 6) --Solo si esta Rechazado o en Evaluacion Visual
      Where s.id_solicitud = NVL(p_id_solicitud, s.id_solicitud) --Para salvar el valor NULO
        And d.id_registro = NVL(p_id_registro, d.id_registro) --Para salvar el valor NULO
      Order by d.id_registro DESC
    )
  LOOP
    BEGIN
      --Para actualizar la solicitud
      v_id_solicitud := C_SOL.ID_SOLICITUD;
      
      --Actualizamos la solicitud a PENDIENTE
      SUIRPLUS.NSS_ACTUALIZAR_SOLICITUD(C_SOL.ID_REGISTRO, 1, NULL, NULL, p_ult_usuario_act, p_resultado);
         
      IF p_resultado <> 'OK' THEN
        -- Grabar fin seguimiento en detalle de bitacora
        suirplus.detalle_bitacora(v_id_bitacora,
                                  sysdate,
                                  SUBSTR('CAMBIAR ESTATUS A ID_SOLICITUD #'||to_char(C_SOL.ID_SOLICITUD)||', ID_REGISTRO #'||to_char(C_SOL.Id_Registro)||' DE '||C_SOL.id_estatus||' A 1: ignorada.'||chr(13)||chr(10)||
                                  'MOTIVO: '||p_resultado,1,500));
        -- Pasamos al proximo registro
        CONTINUE;
      ELSE
        -- Grabar primer seguimiento en detalle de bitacora
        suirplus.detalle_bitacora(v_id_bitacora,
                                  sysdate,
                                  SUBSTR('CAMBIAR ESTATUS A ID_SOLICITUD #'||to_char(C_SOL.ID_SOLICITUD)||', ID_REGISTRO #'||to_char(C_SOL.Id_Registro)||' DE '||C_SOL.id_estatus||' A 1: realizada.',1,500));
      END IF;
      
      --Borrar en el detalle de la evaluacion visual
      DELETE FROM suirplus.nss_det_evaluacion_visual_t d
       WHERE d.id_evaluacion IN (
                                 SELECT id_evaluacion
                                   FROM suirplus.nss_evaluacion_visual_t e
                                  WHERE e.id_registro = C_SOL.ID_REGISTRO
                                );
           
      -- Grabar primer seguimiento en detalle de bitacora
      suirplus.detalle_bitacora(v_id_bitacora,
                                sysdate,
                                SUBSTR('BORRANDO DETALLE EVALUACION VISUAL ID_SOLICITUD #'||to_char(C_SOL.ID_SOLICITUD)||', ID_REGISTRO #'||to_char(C_SOL.Id_Registro)||'. Total Registros '||to_char(SQL%ROWCOUNT),1,500));

      --Borrando en el maestro de la evaluacion visual
      DELETE FROM suirplus.nss_evaluacion_visual_t e
       WHERE e.id_registro = C_SOL.ID_REGISTRO;
         
      -- Grabar primer seguimiento en detalle de bitacora
      suirplus.detalle_bitacora(v_id_bitacora,
                                sysdate,
                                SUBSTR('BORRANDO MAESTRO EVALUACION VISUAL ID_SOLICITUD #'||to_char(C_SOL.ID_SOLICITUD)||', ID_REGISTRO #'||to_char(C_SOL.Id_Registro)||'. Total Registros '||to_char(SQL%ROWCOUNT),1,500));
        
      --Borrando respuesta anterior a UNIPAGO
      DELETE FROM un_acceso_exterior.tss_rechazos_asignacion_nss_mv
       WHERE n_num_control = C_SOL.NUM_CONTROL
         AND n_id_registro = C_SOL.ID_CONTROL;

      -- Grabar primer seguimiento en detalle de bitacora
      suirplus.detalle_bitacora(v_id_bitacora,
                                sysdate,
                                SUBSTR('BORRANDO RESPUESTA POR ACTA A UNIPAGO ID_SOLICITUD #'||to_char(C_SOL.ID_SOLICITUD)||', ID_REGISTRO #'||to_char(C_SOL.Id_Registro)||'. Total Registros '||to_char(SQL%ROWCOUNT),1,500));

      --Actualizando a pendiente respuesta anterior a UNIPAGO
      UPDATE suirplus.suir_r_sol_asig_cedula_mv
         SET status = 'PE'
       WHERE ID = C_SOL.ID;

      -- Grabar primer seguimiento en detalle de bitacora
      suirplus.detalle_bitacora(v_id_bitacora,
                                sysdate,
                                SUBSTR('ACTUALIZANDO RESPUESTA POR CEDULA A UNIPAGO ID_SOLICITUD #'||to_char(C_SOL.ID_SOLICITUD)||', ID_REGISTRO #'||to_char(C_SOL.Id_Registro)||'. Total Registros '||to_char(SQL%ROWCOUNT),1,500));

      COMMIT;                
    EXCEPTION WHEN OTHERS THEN
      p_resultado := SQLERRM||' - '||dbms_utility.format_error_backtrace;
      
      -- Grabar primer seguimiento en detalle de bitacora
      suirplus.detalle_bitacora(v_id_bitacora,
                                sysdate,
                                SUBSTR('CAMBIAR ESTATUS A SOLICITUD #'||to_char(C_SOL.ID_SOLICITUD)||', ID_REGISTRO #'||to_char(C_SOL.Id_Registro)||' DE '||C_SOL.id_estatus||' A 1: ignorada por error: '||p_resultado,1,500));
    END;  
  END LOOP;

  IF V_ID_SOLICITUD IS NOT NULL THEN
    --Procesamos la solicitud
    NSS_VALIDAR_SOLICITUD(v_id_solicitud, p_ult_usuario_act, p_resultado);
    
    IF p_resultado <> 'OK' THEN
      -- Grabar fin seguimiento en detalle de bitacora
      suirplus.detalle_bitacora(v_id_bitacora,
                                sysdate,
                                SUBSTR('NO SE PUDO PROCESAR LA SOLICITUD #'||to_char(V_ID_SOLICITUD)||chr(13)||chr(10)||
                                'MOTIVO: '||p_resultado,1,500));
    ELSE
      -- Grabar primer seguimiento en detalle de bitacora
      suirplus.detalle_bitacora(v_id_bitacora,
                                sysdate,
                                SUBSTR('CAMBIO A SOLICITUD #'||to_char(V_ID_SOLICITUD)||' PROCESADA SASTIFACTORIAMENTE.',1,500));
    END IF;    
  END IF;

  -- Grabar fin seguimiento en detalle de bitacora
  suirplus.detalle_bitacora(v_id_bitacora, sysdate, 'PROCESO TERMINADO, a las '||to_char(sysdate,'dd/mm/yyyy hh:mi:ss'));

  v_final := sysdate;

  v_mensaje := 'Inicio  : '||to_char(v_inicio,'dd/mm/yyyy hh:mi:ss')||chr(13)||chr(10)||
               'Final   : '||to_char(v_final ,'dd/mm/yyyy hh:mi:ss')||chr(13)||chr(10)||
               'Duracion: '||to_char((v_inicio-v_final)/24/60/60,'999,999,999.99')||' segs.';

  -- Para grabar mensaje a notificar
  suirplus.registrar_mensaje(v_id_proceso, v_mensaje, 'P', v_resultado);

  -- Grabar en Bitacora que el proceso termino
  suirplus.bitacora(v_id_bitacora,
                   'FIN',
                   v_ID_PROCESO,
                   'OK',
                   'O',
                   '000');
EXCEPTION
  WHEN e_proceso_no_existe THEN
    p_resultado := Suirplus.Seg_Retornar_Cadena_Error('240', NULL, NULL);

    -- Para grabar mensaje a notificar
    suirplus.registrar_mensaje(v_id_proceso, SUBSTR(p_resultado,1,500), 'P', v_resultado);

    -- Grabar fin seguimiento en detalle de bitacora
    suirplus.detalle_bitacora(v_id_bitacora,
                              sysdate,
                              SUBSTR('PROCESO TERMINADO CON ERROR: '||p_resultado, 1, 500));

    -- Para cerrar la bitacora
    suirplus.bitacora(v_id_bitacora,
                     'FIN',
                     v_ID_PROCESO,
                     substr(p_resultado, 1, 200),
                     'E',
                     '000');
  WHEN e_usuario_no_existe THEN
    p_resultado := Suirplus.Seg_Retornar_Cadena_Error('1', NULL, NULL);

    -- Para grabar mensaje a notificar
    suirplus.registrar_mensaje(v_id_proceso, SUBSTR(p_resultado,1,500), 'P', v_resultado);

    -- Grabar fin seguimiento en detalle de bitacora
    suirplus.detalle_bitacora(v_id_bitacora,
                              sysdate,
                              SUBSTR('PROCESO TERMINADO CON ERROR: '||p_resultado, 1, 500));

    -- Para cerrar la bitacora
    suirplus.bitacora(v_id_bitacora,
                     'FIN',
                     v_ID_PROCESO,
                     substr(p_resultado, 1, 200),
                     'E',
                     '000');
  WHEN e_solicitud_no_existe THEN
    p_resultado := Suirplus.Seg_Retornar_Cadena_Error('181', NULL, NULL);

    -- Para grabar mensaje a notificar
    suirplus.registrar_mensaje(v_id_proceso, SUBSTR(p_resultado,1,500), 'P', v_resultado);

    -- Grabar fin seguimiento en detalle de bitacora
    suirplus.detalle_bitacora(v_id_bitacora,
                              sysdate,
                              SUBSTR('PROCESO TERMINADO CON ERROR: '||p_resultado, 1, 500));

    -- Para cerrar la bitacora
    suirplus.bitacora(v_id_bitacora,
                     'FIN',
                     v_ID_PROCESO,
                     substr(p_resultado, 1, 200),
                     'E',
                     '000');
  WHEN e_estatus_sol_invalido THEN
    p_resultado := Suirplus.Seg_Retornar_Cadena_Error('183', NULL, NULL);

    -- Para grabar mensaje a notificar
    suirplus.registrar_mensaje(v_id_proceso, SUBSTR(p_resultado,1,500), 'P', v_resultado);

    -- Grabar fin seguimiento en detalle de bitacora
    suirplus.detalle_bitacora(v_id_bitacora,
                              sysdate,
                              SUBSTR('PROCESO TERMINADO CON ERROR: '||p_resultado, 1, 500));

    -- Para cerrar la bitacora
    suirplus.bitacora(v_id_bitacora,
                     'FIN',
                     v_ID_PROCESO,
                     substr(p_resultado, 1, 200),
                     'E',
                     '000');
  WHEN OTHERS THEN
    ROLLBACK;
    p_resultado := SQLERRM||' - '||dbms_utility.format_error_backtrace;

    IF v_id_bitacora IS NOT NULL THEN
      -- Para grabar mensaje a notificar
      suirplus.registrar_mensaje(v_id_proceso, SUBSTR(p_resultado,1,500), 'P', v_resultado);

      -- Grabar fin seguimiento en detalle de bitacora
      suirplus.detalle_bitacora(v_id_bitacora,
                                sysdate,
                                SUBSTR('PROCESO TERMINADO CON ERROR: '||p_resultado, 1, 500));

      -- Para cerrar la bitacora
      suirplus.bitacora(v_id_bitacora,
                       'FIN',
                       v_ID_PROCESO,
                       substr(p_resultado, 1, 200),
                       'E',
                       '000');
   END IF;                    
END;
