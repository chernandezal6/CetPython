CREATE OR REPLACE PROCEDURE SUIRPLUS.ARS_ACTUALIZA_DEP_ADICIONALES
(
  p_id_usuario in suirplus.seg_usuario_t.id_usuario%type,
  p_resultado  out varchar2
)
AS
  v_hora_inicio_1     date;
  v_hora_inicio       date;
  v_hora_termina      date;
  
  v_ult_fecha_unipago date;
  v_ult_fecha_tss     date;
  v_ejecutar          char(1);
  v_resultado         varchar2(32767);
  
  v_id_bitacora       suirplus.sfc_bitacora_t.id_bitacora%type;
  v_id_proceso        suirplus.sfc_procesos_t.id_proceso%TYPE := 'AA'; -- Proceso de actualizacion Dependientes Adicionales
  v_nombre_vista      varchar2(30) := 'ARS_DEP_ADICIONALES_MV';
  v_conteo            pls_integer;
  v_dias_a_sumar      suirplus.sfc_det_parametro_t.valor_numerico%type;

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

  v_hora_inicio   := sysdate;
  v_hora_inicio_1 := sysdate;  

  -- Grabar primer seguimiento en detalle de bitacora
  suirplus.detalle_bitacora(v_id_bitacora, sysdate,SUBSTR('Inicio del PROCESO '||v_id_proceso||' a las '||to_char(v_hora_inicio_1,'dd/mm/yyyy hh:mi:ss')||chr(13)||chr(10)||
                                                          'PARÁMETRO: p_id_usuario = '||p_id_usuario,1,500));

  --Para buscar la fecha de actualizacion de la vista desde UNIPAGO.
  --Esta forma me permite compilar en ambientes donde no esta disponible el DBLINK con UNIPAGO, aunque no asi en tiempo de ejecucion.
  Begin
    execute immediate 'select last_refresh from user_snapshots@unipro_dbl where name = ''TSS_DEPENDIENTES_ADIC_MV'''
    into v_ult_fecha_unipago;
  Exception When No_Data_Found Then
    v_ult_fecha_unipago := sysdate;
  End;  

  --Para obtener la fecha de la ultima de corrida del proceso para la vista TSS_CARTERA_PENSIONADOS_MV
  Begin
    select ult_fecha_act, UPPER(NVL(ejecutar,'N'))
      into v_ult_fecha_tss, v_ejecutar
      from suirplus.ars_actualizacion_vistas_t
     where nombre_vista = v_nombre_vista;
  Exception When No_Data_Found Then
    v_ejecutar      := 'S';
    v_ult_fecha_tss := sysdate;
  End;

  --Si las fechas son identicas cancelo el proceso, la primera corrida en v_ult_fecha_tss tendrá NULL lo que hara que no se cumpla la pregunta
  If (v_ult_fecha_tss = v_ult_fecha_unipago) Then
    -- Para grabar mensaje a notificar
    suirplus.registrar_mensaje(v_id_proceso, SUBSTR('La fecha de actualización de la vista '||v_nombre_vista||' no ha sufrido cambios desde su último refrescamiento.',1,500), 'P', p_resultado);
  Else
    --Busco los dias de gracias
    v_dias_a_sumar := suirplus.Parm.get_parm_number(408);

    --Si la fecha actual es menor a la fecha que resulte del primer dia de recaudo mas los dias de gracia, aborto el proceso
    If TRUNC(sysdate) < suirplus.srp_pkg.business_date(TO_DATE('01-'||to_char(sysdate,'MON-YYYY'),'DD-MON-YYYY'), v_dias_a_sumar) Then
      v_hora_termina := sysdate;

        -- Para grabar mensaje a notificar
      suirplus.registrar_mensaje(v_id_proceso, SUBSTR('Estamos dentro de los días de recaudo y corrida de recargos, no se refresca la vista '||v_nombre_vista,1,500), 'P', p_resultado);

      -- Grabar fin seguimiento en detalle de bitacora
      suirplus.detalle_bitacora(v_id_bitacora,
                                sysdate,
                                SUBSTR('Estamos dentro de los días de recaudo y corrida de recargos, no se refresca la vista '||v_nombre_vista, 1, 500));
      
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
                        SUBSTR('Estamos dentro de los días de recaudo y corrida de recargos, no se refresca la vista '||v_nombre_vista, 1, 200),
                        'O',
                        '000');
      RETURN; --Aborto el proceso
    End If;

    v_hora_inicio := sysdate;
    
    --Refrescamos la vista maerializada para traer los registros desde la fuente externa o DBLINK
    execute immediate 'BEGIN sys.dbms_snapshot.refresh('''||v_nombre_vista||'''); END;';

    --Actualizo la ultima fecha de actualizacion de la vista tal como esta en UNIPAGO
    Update suirplus.ars_actualizacion_vistas_t
       set ult_fecha_act = v_ult_fecha_unipago
     Where nombre_vista = v_nombre_vista;
    Commit;

    v_hora_termina := sysdate;

    -- Grabar fin seguimiento en detalle de bitacora
    suirplus.detalle_bitacora(v_id_bitacora,
                              sysdate,
                              SUBSTR('Refrescamiento de la vista '||v_nombre_vista||' - terminado a las '||to_char(v_hora_termina,'dd/mm/yyyy hh:mi:ss am')||
                                     ' - Tiempo total: ('||TRIM(TO_CHAR(EXTRACT(HOUR FROM NUMTODSINTERVAL(v_hora_termina - v_hora_inicio, 'DAY')),'00'))||':'||
                                                           TRIM(TO_CHAR(EXTRACT(MINUTE FROM NUMTODSINTERVAL(v_hora_termina - v_hora_inicio, 'DAY')),'00'))||':'||
                                                           TRIM(TO_CHAR(EXTRACT(SECOND FROM NUMTODSINTERVAL(v_hora_termina - v_hora_inicio, 'DAY')),'00'))||')', 1, 500));
  End if;

  -- Despues de refrescar o no la vista, puede que no se quiera realizar toda la logica de negocio de este proceso  
  If v_ejecutar = 'N' Then
    v_hora_termina := sysdate;

    -- Para grabar mensaje a notificar
    suirplus.registrar_mensaje(v_id_proceso, SUBSTR('La configuración para ejecutar este proceso está desabilitada. Enciendala para proceder a su ejecución.',1,500), 'P', p_resultado);

    -- Grabar fin seguimiento en detalle de bitacora
    suirplus.detalle_bitacora(v_id_bitacora,
                              sysdate,
                              SUBSTR('La configuración para ejecutar este proceso está desabilitada. Enciendala para proceder a su ejecución.',1,500));
    
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
                     SUBSTR('La configuración para ejecutar este proceso está desabilitada. Enciendala para proceder a su ejecución.',1,200),
                     'O',
                     '000');
    RETURN; --Aborto el proceso
  End if;

  --Tomamos la cantidad de registros que trajo la vista materializada
  Select Count(*)
	  Into v_conteo
    From SUIRPLUS.ARS_DEP_ADICIONALES_MV;

  --Comparo la cantidad de registros con el parametro, si es menor aborto el proceso
  If v_conteo < Parm.get_parm_number(407) Then
    v_hora_termina := sysdate;
     
    -- Para grabar mensaje a notificar
    suirplus.registrar_mensaje(v_id_proceso, SUBSTR('La cantidad de registros en la vista '||v_nombre_vista||' es menor que la esperada. Registros esperados: '||TRIM(to_char(Parm.get_parm_number(407),'999,999,999'))||', Registros recibidos: '||TRIM(to_char(v_conteo,'999,999,999')), 1, 500), 'P', p_resultado);

    -- Grabar fin seguimiento en detalle de bitacora
    suirplus.detalle_bitacora(v_id_bitacora,
                              sysdate,
                              SUBSTR('La cantidad de registros en la vista '||v_nombre_vista||' es menor que la esperada. Registros esperados: '||TRIM(to_char(Parm.get_parm_number(407),'999,999,999'))||', Registros recibidos: '||TRIM(to_char(v_conteo,'999,999,999')), 1, 500));

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
                      SUBSTR('La cantidad de registros en la vista '||v_nombre_vista||' es menor que la esperada.', 1, 200),
                      'O',
                      '000');
    RETURN; --Aborto el proceso
  End if;

  suirplus.detalle_bitacora(v_id_bitacora,
                            sysdate,
                            SUBSTR('Total de registros en la vista '||v_nombre_vista||': '||TRIM(to_char(v_conteo,'999,999,999')), 1, 500));

  v_hora_inicio := sysdate;
  
  --Insertamos todos los registros que estan en la vista y no estan en la tabla
  MERGE INTO SUIRPLUS.ARS_DEP_ADICIONALES_T t_dp
     USING (
            SELECT id_nss_titular,
                   id_nss_dependiente,
                   id_nss_conyuge,
                   id_parentesco
              FROM suirplus.ars_dep_adicionales_mv v
           ) v_dp
        ON (
            t_dp.id_nss_titular = v_dp.id_nss_titular AND 
            t_dp.id_nss_dependiente = v_dp.id_nss_dependiente AND
            NVL(t_dp.id_nss_conyuge,-1) = NVL(v_dp.id_nss_conyuge,-1)
           )
  WHEN NOT MATCHED THEN
      INSERT (
              t_dp.id_nss_titular,
              t_dp.id_nss_dependiente,
              t_dp.id_nss_conyuge,
              t_dp.id_parentesco,
              t_dp.ult_usuario_act,
              t_dp.ult_fecha_act
             )
      VALUES (
              v_dp.id_nss_titular,
              v_dp.id_nss_dependiente,
              v_dp.id_nss_conyuge,
              v_dp.id_parentesco,
              p_id_usuario,
              sysdate
             );

  v_hora_termina := sysdate;
  
  -- Grabar fin seguimiento en detalle de bitacora
  suirplus.detalle_bitacora(v_id_bitacora,
                            sysdate,
                            SUBSTR('Registros insertados en la tabla SUIRPLUS.ARS_DEP_ADICIONALES_T: '||TRIM(to_char(sql%rowcount,'999,999,999'))||' - terminado a las '||to_char(v_hora_termina,'dd/mm/yyyy hh:mi:ss am')||
                                   ' - Tiempo total: ('||TRIM(TO_CHAR(EXTRACT(HOUR FROM NUMTODSINTERVAL(v_hora_termina - v_hora_inicio, 'DAY')),'00'))||':'||
                                                         TRIM(TO_CHAR(EXTRACT(MINUTE FROM NUMTODSINTERVAL(v_hora_termina - v_hora_inicio, 'DAY')),'00'))||':'||
                                                         TRIM(TO_CHAR(EXTRACT(SECOND FROM NUMTODSINTERVAL(v_hora_termina - v_hora_inicio, 'DAY')),'00'))||')', 1, 500));
  COMMIT;

  v_hora_inicio := sysdate;
  
  --Borramos todos los registros que estan en la tabla y no estan en la vista
  DELETE FROM SUIRPLUS.ARS_DEP_ADICIONALES_T t_dp
   WHERE NOT EXISTS
   (
    SELECT id_nss_titular
      FROM suirplus.ars_dep_adicionales_mv v_dp
     WHERE v_dp.id_nss_titular = t_dp.id_nss_titular
       AND v_dp.id_nss_dependiente = t_dp.id_nss_dependiente
       AND NVL(v_dp.id_nss_conyuge,-1) = NVL(t_dp.id_nss_conyuge,-1)
   );

  v_hora_termina := sysdate;

  -- Grabar fin seguimiento en detalle de bitacora
  suirplus.detalle_bitacora(v_id_bitacora,
                            sysdate,
                            SUBSTR('Registros borrados de la tabla SUIRPLUS.ARS_DEP_ADICIONALES_T que no vinieron en la vista '||v_nombre_vista||': '||TRIM(to_char(sql%rowcount,'999,999,999'))||' - terminado a las '||to_char(v_hora_termina,'dd/mm/yyyy hh:mi:ss am')||
                                   ' - Tiempo total: ('||TRIM(TO_CHAR(EXTRACT(HOUR FROM NUMTODSINTERVAL(v_hora_termina - v_hora_inicio, 'DAY')),'00'))||':'||
                                                         TRIM(TO_CHAR(EXTRACT(MINUTE FROM NUMTODSINTERVAL(v_hora_termina - v_hora_inicio, 'DAY')),'00'))||':'||
                                                         TRIM(TO_CHAR(EXTRACT(SECOND FROM NUMTODSINTERVAL(v_hora_termina - v_hora_inicio, 'DAY')),'00'))||')', 1, 500));
  COMMIT;

  --Llamo el stores procedure que da de baja a los dependientes adicionales en SRE_DEPENDIENTES_T que no esten en la tabla ARS_DEP_ADICIONALES_T
  SUIRPLUS.ARS_BAJA_DEP_ADICIONALES(p_id_usuario, p_resultado);

  --Para dejar rastro en bitacora de la corrida del proceso de baja de dependientes adicionales lanzado desde este proceso
  If p_resultado <> 'OK' Then
    suirplus.detalle_bitacora(v_id_bitacora,
                              sysdate,
                              SUBSTR('Error en el proceso SUIRPLUS.ARS_BAJA_DEP_ADICIONALES: '||p_resultado, 1, 500));
  Else
    suirplus.detalle_bitacora(v_id_bitacora,
                              sysdate,
                              SUBSTR('Proceso SUIRPLUS.ARS_BAJA_DEP_ADICIONALES ejecutado satisfactoriamente.', 1, 500));
  End if;

  v_hora_termina := sysdate;
    
  suirplus.detalle_bitacora(v_id_bitacora,
                            sysdate,
                            SUBSTR('Fin del Proceso '||v_id_proceso||' - terminado a las '||to_char(v_hora_termina,'dd/mm/yyyy hh:mi:ss am')||
                                   ' - Tiempo total: ('||TRIM(TO_CHAR(EXTRACT(HOUR FROM NUMTODSINTERVAL(v_hora_termina - v_hora_inicio_1, 'DAY')),'00'))||':'||
                                                         TRIM(TO_CHAR(EXTRACT(MINUTE FROM NUMTODSINTERVAL(v_hora_termina - v_hora_inicio_1, 'DAY')),'00'))||':'||
                                                         TRIM(TO_CHAR(EXTRACT(SECOND FROM NUMTODSINTERVAL(v_hora_termina - v_hora_inicio_1, 'DAY')),'00'))||')', 1, 500));
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