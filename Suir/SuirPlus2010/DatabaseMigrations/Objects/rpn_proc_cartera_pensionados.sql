CREATE OR REPLACE PROCEDURE SUIRPLUS.RPN_PROC_CARTERA_PENSIONADOS
(
 p_id_usuario in suirplus.seg_usuario_t.id_usuario%type,
 p_resultado  out varchar2
)
AS
  v_ult_fecha_tss     suirplus.ars_actualizacion_vistas_t.ult_fecha_act%type;
  v_ult_fecha_unipago date; 
  v_hora_inicio       date;
  v_hora_termina      date;
  v_resultado         varchar2(1000);
  
  v_id_bitacora       suirplus.sfc_bitacora_t.id_bitacora%type;
  v_id_proceso        suirplus.sfc_procesos_t.id_proceso%TYPE := 'RP'; -- Proceso de validacion Regimen Cartera Pensionados
  v_nombre_vista      varchar2(30) := 'RPN_CARTERA_PENSIONADOS_MV';
  v_conteo            pls_integer;
  v_refrescar         suirplus.ars_actualizacion_vistas_t.ejecutar%type;
  
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
    From seg_usuario_t t
   Where t.id_usuario = upper(p_id_usuario);

  If v_conteo = 0 Then
    RAISE e_usuario_no_existe;
  End if;

  v_hora_inicio := sysdate;
  p_resultado   := 'OK';

  -- Grabar primer seguimiento en detalle de bitacora
  suirplus.detalle_bitacora(v_id_bitacora, sysdate,SUBSTR('Inicio del PROCESO '||v_id_proceso||' a las '||to_char(sysdate,'dd/mm/yyyy hh:mi:ss')||chr(13)||chr(10)||
                                                    'PARAMETROS: p_id_usuario = '||p_id_usuario,1,500));

  --Para buscar la fecha de actualizacion de la vista desde UNIPAGO.
  --Esta forma me permite compilar en ambientes donde no esta disponible el DBLINK con UNIPAGO, aunque no asi en tiempo de ejecucion.
  Begin
    execute immediate 'select last_refresh from user_snapshots@unipro_dbl where name = ''TSS_CARTERA_PENSIONADOS_MV'''
    into v_ult_fecha_unipago;
  Exception
    When No_Data_Found Then
      v_ult_fecha_unipago := sysdate;
  End;  

  --Para obtener la fecha de la ultima de corrida del proceso para la vista TSS_CARTERA_PENSIONADOS_MV
  Begin
    select ult_fecha_act, UPPER(NVL(ejecutar,'N'))
      into v_ult_fecha_tss, v_refrescar
      from suirplus.ars_actualizacion_vistas_t
     where nombre_vista = v_nombre_vista;
  Exception
    When No_Data_Found Then
      v_refrescar     := 'S';
      v_ult_fecha_tss := sysdate;
  End;

  --Si las fechas son identicas cancelo el proceso, la primera corrida en v_ult_fecha_tss tendrá NULL lo que hara que no se cumpla la pregunta
  If (v_ult_fecha_tss = v_ult_fecha_unipago) Then
    v_hora_termina := sysdate;

    -- Para grabar mensaje a notificar
    suirplus.registrar_mensaje(v_id_proceso, SUBSTR('La fecha de actualizacion de la vista '''||v_nombre_vista||''' no ha sufrido cambio desde la ultima corrida.',1,500), 'P', p_resultado);

    -- Grabar fin seguimiento en detalle de bitacora
    suirplus.detalle_bitacora(v_id_bitacora,
                              sysdate,
                              SUBSTR('La fecha de actualizacion de la vista '''||v_nombre_vista||''' no ha sufrido cambio desde la ultima corrida.', 1, 500));
    
    -- Grabar fin seguimiento en detalle de bitacora
    suirplus.detalle_bitacora(v_id_bitacora,
                              sysdate,
                              SUBSTR('Fin del Proceso '||v_id_proceso||' - terminado a las '||to_char(v_hora_termina,'dd/mm/yyyy hh:mi:ss am')||
                                     ' - Tiempo total: ('||TRIM(TO_CHAR(EXTRACT(HOUR FROM NUMTODSINTERVAL(v_hora_termina - v_hora_inicio, 'DAY')),'00'))||':'||
                                                           TRIM(TO_CHAR(EXTRACT(MINUTE FROM NUMTODSINTERVAL(v_hora_termina - v_hora_inicio, 'DAY')),'00'))||':'||
                                                           TRIM(TO_CHAR(EXTRACT(SECOND FROM NUMTODSINTERVAL(v_hora_termina - v_hora_inicio, 'DAY')),'00'))||')', 1, 500));
    -- Para cerrar la bitacora
    suirplus.bitacora(v_id_bitacora,
                     'FIN',
                     v_ID_PROCESO,
                     SUBSTR('La fecha de actualizacion de la vista '''||v_nombre_vista||''' no ha sufrido cambio desde la ultima corrida.', 1, 200),
                     'O',
                     '000');    
  Elsif v_refrescar = 'S' Then -- Son diferentes las fechas, pero puede que no se quiera refrescar la vista
    --Refrescamos la vista maerializada para traer los registros desde la fuente externa o DBLINK
    execute immediate 'begin sys.dbms_snapshot.refresh('''||v_nombre_vista||'''); end;';

    --Actualizo la ultima fecha de actualizacion de la vista tal como esta en UNIPAGO
    Update suirplus.ars_actualizacion_vistas_t
       set ult_fecha_act = v_ult_fecha_unipago
     Where nombre_vista = v_nombre_vista;
    Commit;

    v_hora_termina := sysdate;
    
    -- Para grabar mensaje a notificar
    suirplus.registrar_mensaje(v_id_proceso, SUBSTR('La vista '''||v_nombre_vista||''' fue refrescada satisfactoriamente.',1,500), 'P', p_resultado);

    suirplus.detalle_bitacora(v_id_bitacora,
                              sysdate,
                              SUBSTR('Fin del Proceso '||v_id_proceso||' - terminado a las '||to_char(v_hora_termina,'dd/mm/yyyy hh:mi:ss am')||
                                     ' - Tiempo total: ('||TRIM(TO_CHAR(EXTRACT(HOUR FROM NUMTODSINTERVAL(v_hora_termina - v_hora_inicio, 'DAY')),'00'))||':'||
                                                           TRIM(TO_CHAR(EXTRACT(MINUTE FROM NUMTODSINTERVAL(v_hora_termina - v_hora_inicio, 'DAY')),'00'))||':'||
                                                           TRIM(TO_CHAR(EXTRACT(SECOND FROM NUMTODSINTERVAL(v_hora_termina - v_hora_inicio, 'DAY')),'00'))||')', 1, 500));
    -- Para cerrar la bitacora
    suirplus.bitacora(v_id_bitacora,
                     'FIN',
                     v_ID_PROCESO,
                     SUBSTR('La vista '''||v_nombre_vista||''' fue refrescada satisfactoriamente.', 1, 200),
                     'O',
                     '000');
  Elsif v_refrescar = 'N' Then -- Flag de no actualizar vista esta apagado
    v_hora_termina := sysdate;

    -- Para grabar mensaje a notificar
    suirplus.registrar_mensaje(v_id_proceso, SUBSTR('La configuracion para actualizar la vista '''||v_nombre_vista||''' esta desabilitada. Enciendala para poder refrescar la vista.',1,500), 'P', p_resultado);

    -- Grabar fin seguimiento en detalle de bitacora
    suirplus.detalle_bitacora(v_id_bitacora,
                              sysdate,
                              SUBSTR('La configuracion para actualizar la vista '''||v_nombre_vista||''' esta desabilitada. Enciendala para poder refrescar la vista.',1,500));
    
    -- Grabar fin seguimiento en detalle de bitacora
    suirplus.detalle_bitacora(v_id_bitacora,
                              sysdate,
                              SUBSTR('Fin del Proceso '||v_id_proceso||' - terminado a las '||to_char(v_hora_termina,'dd/mm/yyyy hh:mi:ss am')||
                                     ' - Tiempo total: ('||TRIM(TO_CHAR(EXTRACT(HOUR FROM NUMTODSINTERVAL(v_hora_termina - v_hora_inicio, 'DAY')),'00'))||':'||
                                                           TRIM(TO_CHAR(EXTRACT(MINUTE FROM NUMTODSINTERVAL(v_hora_termina - v_hora_inicio, 'DAY')),'00'))||':'||
                                                           TRIM(TO_CHAR(EXTRACT(SECOND FROM NUMTODSINTERVAL(v_hora_termina - v_hora_inicio, 'DAY')),'00'))||')', 1, 500));
    -- Para cerrar la bitacora
    suirplus.bitacora(v_id_bitacora,
                     'FIN',
                     v_ID_PROCESO,
                     SUBSTR('La configuracion para actualizar la vista '''||v_nombre_vista||''' esta desabilitada. Enciendala para poder refrescar la vista.',1,200),
                     'O',
                     '000');
  End if;                     
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
  WHEN OTHERS THEN
    p_resultado := SQLERRM||' - '||dbms_utility.format_error_backtrace;


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
END;