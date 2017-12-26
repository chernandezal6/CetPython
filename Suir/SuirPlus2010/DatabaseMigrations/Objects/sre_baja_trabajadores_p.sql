CREATE OR REPLACE PROCEDURE SUIRPLUS.SRE_BAJA_TRABAJADORES_P
(
 p_fecha_salida in date,
 p_id_usuario in suirplus.seg_usuario_t.id_usuario%type
) IS
  v_conteo      pls_integer;
  v_resultado   varchar2(1000);
  v_resultado_1 varchar2(1000);
  v_id_bitacora suirplus.sfc_bitacora_t.id_bitacora%type;
  v_id_proceso  suirplus.sfc_procesos_t.id_proceso%TYPE := 'BT'; -- Proceso de Baja a trabajadores activos de empleadores en estatus SUSPENDIDO

  e_proceso_no_existe EXCEPTION;
  e_usuario_no_existe EXCEPTION;
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

  -- Ver si existe el usuario, si no existe termina la ejecucion
  Select count(*)
    Into v_conteo
    From suirplus.seg_usuario_t t
   Where t.id_usuario = upper(p_id_usuario);

  If v_conteo = 0 Then
    RAISE e_usuario_no_existe;
  End if;

  -- Grabar primer seguimiento en detalle de bitacora
  suirplus.detalle_bitacora(v_id_bitacora, sysdate,SUBSTR('Inicio del PROCESO '||v_id_proceso||' a las '||to_char(sysdate,'dd/mm/yyyy hh:mi:ss')||chr(13)||chr(10)||
                                                          'PARÁMETROS: p_fecha_salida = '||TO_CHAR(p_fecha_salida,'dd/mm/yyyy')||
                                                          ', p_id_usuario = '||upper(p_id_usuario),1,500));


  For suspendido in (
   select id_registro_patronal
     from suirplus.sre_empleadores_t e
    where NVL(e.status, 'N') = 'S'
    Order by e.id_registro_patronal
  ) Loop
    Update suirplus.sre_trabajadores_t t
       set t.status          = 'B',
           t.ult_usuario_act = p_id_usuario,
           t.ult_fecha_act   = sysdate,
           t.fecha_salida    = p_fecha_salida
     Where t.id_registro_patronal = suspendido.id_registro_patronal
       And t.status = 'A';

    If sql%rowcount > 0 Then
      -- grabar seguimiento en detalle bitacora
      suirplus.detalle_bitacora(v_id_bitacora,
                                sysdate,
                                SUBSTR('Se dio de baja a '||TRIM(to_char(sql%rowcount,'999,999'))||' trabajadores del empleador: '||to_char(suspendido.id_registro_patronal), 1, 500));
      commit;
    Else
      rollback;
	End if;
  End loop;

  -- Para grabar mensaje a notificar
  suirplus.registrar_mensaje(v_id_proceso, SUBSTR('FIN del proceso que da de baja a trabajadores de empleadores SUSPENDIDOS', 1, 500), 'P', v_resultado);

  -- Grabar fin seguimiento en detalle de bitacora
  suirplus.detalle_bitacora(v_id_bitacora,
                            sysdate,
                            SUBSTR('FIN del proceso que da de baja a trabajadores de empleadores SUSPENDIDOS a las '||to_char(sysdate,'dd/mm/yyyy hh:mi:ss'), 1, 500));

  -- Para cerrar la bitacora
  suirplus.bitacora(v_id_bitacora,
                   'FIN',
                   v_ID_PROCESO,
                   SUBSTR('FIN del proceso que da de baja a trabajadores de empleadores SUSPENDIDOS', 1, 200),
                   'O',
                   '000');
EXCEPTION
  WHEN e_proceso_no_existe THEN
    v_resultado := Suirplus.Seg_Retornar_Cadena_Error('240', NULL, NULL);

    -- Para grabar mensaje a notificar
    suirplus.registrar_mensaje(v_id_proceso, SUBSTR(v_resultado,1,500), 'P', v_resultado_1);

    -- Grabar fin seguimiento en detalle de bitacora
    suirplus.detalle_bitacora(v_id_bitacora,
                              sysdate,
                              SUBSTR('PROCESO TERMINADO CON ERROR: '||v_resultado, 1, 500));

    -- Para cerrar la bitacora
    suirplus.bitacora(v_id_bitacora,
                     'FIN',
                     v_ID_PROCESO,
                     substr(v_resultado, 1, 200),
                     'E',
                     '000');
  WHEN e_usuario_no_existe THEN
    v_resultado := Suirplus.Seg_Retornar_Cadena_Error('1', NULL, NULL);

    -- Para grabar mensaje a notificar
    suirplus.registrar_mensaje(v_id_proceso, SUBSTR(v_resultado,1,500), 'P', v_resultado_1);

    -- Grabar fin seguimiento en detalle de bitacora
    suirplus.detalle_bitacora(v_id_bitacora,
                              sysdate,
                              SUBSTR('PROCESO TERMINADO CON ERROR: '||v_resultado, 1, 500));

    -- Para cerrar la bitacora
    suirplus.bitacora(v_id_bitacora,
                     'FIN',
                     v_ID_PROCESO,
                     substr(v_resultado, 1, 200),
                     'E',
                     '000');
  WHEN OTHERS THEN
    v_resultado := SQLERRM||' - '||dbms_utility.format_error_backtrace;

    -- Para grabar mensaje a notificar
    suirplus.registrar_mensaje(v_id_proceso, SUBSTR(v_resultado,1,500), 'P', v_resultado_1);

    -- Grabar fin seguimiento en detalle de bitacora
    suirplus.detalle_bitacora(v_id_bitacora,
                              sysdate,
                              SUBSTR('PROCESO TERMINADO CON ERROR: '||v_resultado, 1, 500));

    -- Para cerrar la bitacora
    suirplus.bitacora(v_id_bitacora,
                     'FIN',
                     v_ID_PROCESO,
                     substr(v_resultado, 1, 200),
                     'E',
                     '000');
END SRE_BAJA_TRABAJADORES_P;