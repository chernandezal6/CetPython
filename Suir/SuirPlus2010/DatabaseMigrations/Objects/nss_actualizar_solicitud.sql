CREATE OR REPLACE PROCEDURE SUIRPLUS.NSS_ACTUALIZAR_SOLICITUD
(
 p_id_registro in suirplus.Nss_det_solicitudes_t.id_registro%Type,
 p_id_estatus in suirplus.nss_estatus_t.id_estatus%Type, 
 p_id_error in suirplus.seg_error_t.id_error%type,
 p_id_nss in suirplus.sre_ciudadanos_t.id_nss%type,  
 p_ult_usuario_act in suirplus.seg_usuario_t.id_usuario%Type,
 p_resultado out varchar2
) IS
  v_conteo   pls_integer;
  v_id_tipo suirplus.nss_solicitudes_t.id_tipo%Type;
  v_id_evaluacion suirplus.nss_evaluacion_visual_t.id_evaluacion%Type;
  v_id_estatus    suirplus.nss_det_solicitudes_t.id_estatus%Type;
  v_id_solicitud  suirplus.nss_solicitudes_t.id_solicitud%type;
  
  e_ciudadano_no_existe  EXCEPTION;
  e_usuario_no_existe    EXCEPTION;
  e_solicitud_no_existe  EXCEPTION;
  e_estatus_sol_invalido EXCEPTION;
  
  FUNCTION SEMAFORO 
  (
   p_id_registro in suirplus.Nss_det_solicitudes_t.id_registro%Type,
   p_id_estatus in suirplus.nss_estatus_t.id_estatus%Type, 
   p_id_error in suirplus.seg_error_t.id_error%type   
  ) RETURN BOOLEAN IS
    PRAGMA AUTONOMOUS_TRANSACTION; --Para garantizar que el commit de este metodo no afecte otras transacciones pendientes por fijar
  BEGIN
    -- Ponemos el registro
    INSERT INTO suirplus.nss_det_solicitud_en_proceso_t
    (
     id_registro,
     id_estatus,
     id_error,
     ult_fecha_act,
     ult_usuario_act
    )
    VALUES
    (
     p_id_registro,
     p_id_estatus,
     p_id_error,
     sysdate,
     p_ult_usuario_act     
    );
    
    COMMIT;
    RETURN TRUE;
  EXCEPTION WHEN OTHERS THEN
    ROLLBACK;
    RETURN FALSE;
  END;  
BEGIN
  -- Ponemos especie de "semaforo" para evitar que esta logica de negocio se ejecute varia veces
  SELECT count(*)
    INTO v_conteo
    FROM suirplus.nss_det_solicitud_en_proceso_t
   WHERE id_registro = p_id_registro
     AND id_estatus  = p_id_estatus
     AND id_error    = p_id_error;
    
  -- Si existe, no procesamo el registro y dejamos que el proceso anterior lo termine
  -- Revocamos todas las transacciones pendientes de commit para evitar bloqueos en las tablas
  IF v_conteo > 0 THEN
    -- devolvemos todas las transacciones pendientes de fijar
    ROLLBACK;
    
    -- Para dejar rastro en la tabla de log
    p_resultado := 'Solicitud #'||to_char(v_id_solicitud)||', ID_REGISTRO #'||to_char(p_id_registro)||' esta siendo trabajada por otro proceso.';
    
    -- Paramos la ejecucion de la logica de negocios
    RETURN;
  ELSE
    IF NOT SEMAFORO(p_id_registro, p_id_estatus, p_id_error) THEN
      -- devolvemos todas las transacciones pendientes de fijar
      ROLLBACK;
      
      -- Para dejar rastro en la tabla de log
      p_resultado := 'Solicitud #'||to_char(v_id_solicitud)||', ID_REGISTRO #'||to_char(p_id_registro)||' no se pudo poner en tabla semaforo. Pendiente para ser procesada en otro momento.';

      RETURN;
    END IF;    
  END IF;      

  -- Si no existe la solicitud, termina la ejecucion informando en bitacora
  BEGIN
    SELECT s.id_tipo, d.id_estatus, s.id_solicitud
      INTO v_id_tipo, v_id_estatus, v_id_solicitud
      FROM suirplus.nss_det_solicitudes_t d
      JOIN suirplus.nss_solicitudes_t s
        ON s.id_solicitud = d.id_solicitud
     WHERE d.id_registro = p_id_registro;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RAISE e_solicitud_no_existe;
  END;

  --Ver si existe el estatus de la solicitud, si no existe termina la ejecucion
  Select count(*)
    Into v_conteo
    From suirplus.nss_estatus_t e
   Where e.id_estatus = p_id_estatus;

  IF v_conteo = 0 THEN
    RAISE e_estatus_sol_invalido;
  END IF;

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

  -- Ver si existe el usuario, si no existe termina la ejecucion
  Select count(*)
    Into v_conteo
    From suirplus.seg_usuario_t t
   Where t.id_usuario = upper(p_ult_usuario_act);

  If v_conteo = 0 Then
    RAISE e_usuario_no_existe;
  End if;

  -- Actualizamos la solicitud en el detalle
  UPDATE suirplus.nss_det_solicitudes_t d
     SET d.id_error        = p_id_error,
         d.id_estatus      = p_id_estatus,
         d.id_nss          = CASE WHEN p_id_estatus = 6 AND p_id_error != 'NSS904' THEN NULL ELSE p_id_nss END, --Rechazamos no por Duplicado
         d.fecha_procesa   = SYSDATE,
         d.usuario_procesa = p_ult_usuario_act,
         d.ult_fecha_act   = SYSDATE,
         d.ult_usuario_act = p_ult_usuario_act
   WHERE d.id_registro = p_id_registro;

  -- Actualizar maestra y detalle de evaluacion visual si el id_estatus = '6'
  IF p_id_estatus = 6 THEN --Rechazada
    UPDATE suirplus.nss_evaluacion_visual_t e
       SET e.fecha_respuesta = SYSDATE,
           e.usuario_procesa = p_ult_usuario_act,
           e.estatus         = 'CO', -- Evaluacion Visual Completada
           e.ult_fecha_act   = SYSDATE,
           e.ult_usuario_act = p_ult_usuario_act
     WHERE e.id_registro = p_id_registro
    RETURNING ID_EVALUACION INTO v_id_evaluacion;
                   
    -- Actualizar detalle evaluacion visual y ciudadanos marcarlo como "posible duplicado"
    FOR C_EV IN (SELECT E.ID_DET_EVALUACION, E.ID_NSS
                   FROM suirplus.Nss_Det_Evaluacion_Visual_t e
                  WHERE e.id_evaluacion = v_id_evaluacion) 
    LOOP
      UPDATE suirplus.nss_det_evaluacion_visual_t d
         SET d.id_accion_ev = 3 -- Rechazar el detalle
       WHERE d.id_det_evaluacion = C_EV.ID_DET_EVALUACION;
    END LOOP;
  END IF;

  CASE 
    WHEN v_id_tipo = 1 THEN --SOLICITUD ASIGNACION NSS MENOR NACIONAL CON ACTA
      IF p_id_estatus IN (2, 3)  THEN --NSS ASIGNADO: NUEVO O EXISTENTE EN CIUDADANO O ACTUALIZADA
        INSERT INTO un_acceso_exterior.tss_ciudadanos_menores_mv
        (
         n_num_control,
         n_id_registro,
         fecha_solicitud,
         n_nss,
         c_num_cedula,
         c_apepat_ciu,
         c_apemat_ciu,
         c_nombre1_ciu,
         c_nombre2_ciu,
         d_fecha_nacimiento,
         d_fecha_defuncion,
         c_sexo,
         c_cve_edo_civil,
         c_acta_nac_municipio,
         c_acta_nac_oficialia,
         c_acta_nac_libro,
         c_acta_nac_folio,
         c_acta_nac_acta,
         c_acta_nac_anio,
         c_tipo_causa,
         c_cod_causa,
         c_categoria,
         fecha_asignacion,
         c_estatus
        )
        SELECT d.num_control,
               d.id_control,
               d.fecha_procesa,
               d.id_nss,
               c.no_documento,
               d.primer_apellido,
               d.segundo_apellido,
               d.nombres,
               null,
               d.fecha_nacimiento,
               null,
               d.sexo,
               d.estado_civil,
               d.municipio_acta,
               d.oficialia_acta,
               d.libro_acta,
               d.folio_acta,
               d.numero_acta,
               d.ano_acta,
               d.tipo_causa,
               d.id_causa_inhabilidad,
               null,
               d.fecha_procesa,
               d.id_error
          FROM suirplus.nss_det_solicitudes_t d
      JOIN suirplus.sre_ciudadanos_t c
        ON c.id_nss = d.id_nss
         WHERE d.id_registro = p_id_registro;
      ELSIF p_id_estatus in (6, 7) THEN --SOLICITUD RECHAZADA O ACTUALIZADA DESDE EV
        --Insertamos el registro en la vista de rechazados de UNIPAGO
        INSERT INTO un_acceso_exterior.tss_rechazos_asignacion_nss_mv
        (
         n_num_control,
         n_id_registro,
         c_acta_municipio,
         c_acta_oficialia,
         c_acta_libro,
         c_acta_folio,
         c_acta_acta,
         c_acta_anio,
         c_fecha_nacimiento,
         d_fecha_solicitud,
         d_fecha_asignacion,
         c_motivo,
         n_nss_duplicidad,
         c_cve_entidad,
         nss_titular,
         c_dep_menor_extranjero
        )
        SELECT d.num_control,
               d.id_control,
               d.municipio_acta,
               d.oficialia_acta,
               d.libro_acta,
               d.folio_acta,
               d.numero_acta,
               d.ano_acta,
               to_char(d.fecha_nacimiento,'ddmmyyyy'),
               s.fecha_solicitud,
               d.fecha_procesa,
               e.uso_unipago,
               d.id_nss,
               d.id_ars,
               d.id_nss_titular,
               d.extranjero
          FROM suirplus.nss_det_solicitudes_t d
          JOIN suirplus.nss_solicitudes_t s
            ON s.id_solicitud = d.id_solicitud
          JOIN suirplus.seg_error_t e on e.id_error=d.id_error
         WHERE d.id_registro = p_id_registro;
      END IF;
    WHEN v_id_tipo = 2 THEN --SOLICITUD ASIGNACION NSS MENOR CON NUI
      IF p_id_estatus IN (2, 3, 6, 7) THEN --ACEPTADO O RECHAZADO
        UPDATE suirplus.suir_r_sol_asig_cedula_mv r
           SET status            = CASE 
                                     WHEN p_id_estatus = 2 THEN 'OK'
                                     WHEN p_id_estatus = 3 THEN 'OK'
                                     WHEN p_id_estatus = 6 THEN 'RE'
                                     WHEN p_id_estatus = 7 THEN 'OK'
                                   END,
               id_error          = (select uso_unipago from suirplus.seg_error_t where id_error=p_id_error),
               id_ars            = (select d.id_ars from suirplus.nss_det_solicitudes_t d where d.id_registro = p_id_registro),
               nss_titular       = (select d.id_nss_titular from suirplus.nss_det_solicitudes_t d where d.id_registro = p_id_registro),
               codigo_parentesco = (select d.id_parentesco from suirplus.nss_det_solicitudes_t d where d.id_registro = p_id_registro),
               ult_fecha_act     = sysdate
         WHERE r.ID = 
               (SELECT d.ID
                  FROM suirplus.nss_det_solicitudes_t d
                 WHERE d.id_registro = p_id_registro
               );
      END IF;   
    WHEN v_id_tipo = 3 THEN --SOLICITUD ASIGNACION NSS A CEDULADO
      IF p_id_estatus IN (2, 3, 6, 7) THEN --ACEPTADO O RECHAZADO
        UPDATE suirplus.suir_r_sol_asig_cedula_mv r
           SET status            = CASE 
                                     WHEN p_id_estatus = 2 THEN 'OK'
                                     WHEN p_id_estatus = 3 THEN 'OK' 
                                     WHEN p_id_estatus = 6 THEN 'RE' 
                                     WHEN p_id_estatus = 7 THEN 'OK'
                                   END,
               id_error          = (select uso_unipago from suirplus.seg_error_t where id_error=p_id_error),
               id_ars            = (select d.id_ars from suirplus.nss_det_solicitudes_t d where d.id_registro = p_id_registro),
               nss_titular       = (select d.id_nss_titular from suirplus.nss_det_solicitudes_t d where d.id_registro = p_id_registro),
               codigo_parentesco = (select d.id_parentesco from suirplus.nss_det_solicitudes_t d where d.id_registro = p_id_registro),
               ult_fecha_act = sysdate
         WHERE r.ID = 
               (SELECT d.ID
                  FROM suirplus.nss_det_solicitudes_t d
                 WHERE d.id_registro = p_id_registro
               );
      END IF;
    WHEN v_id_tipo = 5 THEN --SOLICITUD ASIGNACION NSS MENOR TRABAJADORES EXTRANJEROS
      IF p_id_estatus IN (2, 3)THEN --NSS ASIGNADO: NUEVO O EXISTENTE EN CIUDADANO O ACTUALIZADA
        INSERT INTO un_acceso_exterior.tss_ciudadanos_menores_mv
        (
         n_num_control,
         n_id_registro,
         fecha_solicitud,
         n_nss,
         c_num_cedula,
         c_apepat_ciu,
         c_apemat_ciu,
         c_nombre1_ciu,
         c_nombre2_ciu,
         d_fecha_nacimiento,
         d_fecha_defuncion,
         c_sexo,
         c_cve_edo_civil,
         c_acta_nac_municipio,
         c_acta_nac_oficialia,
         c_acta_nac_libro,
         c_acta_nac_folio,
         c_acta_nac_acta,
         c_acta_nac_anio,
         c_tipo_causa,
         c_cod_causa,
         c_categoria,
         fecha_asignacion,
         c_estatus
        )
        SELECT d.num_control,
               d.id_control,
               d.fecha_procesa,
               d.id_nss,
               c.no_documento,
               d.primer_apellido,
               d.segundo_apellido,
               d.nombres,
               null,
               d.fecha_nacimiento,
               null,
               d.sexo,
               d.estado_civil,
               d.municipio_acta,
               d.oficialia_acta,
               d.libro_acta,
               d.folio_acta,
               d.numero_acta,
               d.ano_acta,
               d.tipo_causa,
               d.id_causa_inhabilidad,
               null,
               d.fecha_procesa,
               d.id_error
          FROM suirplus.nss_det_solicitudes_t d
          JOIN suirplus.sre_ciudadanos_t c
             ON c.id_nss = d.id_nss
         WHERE d.id_registro = p_id_registro;
      ELSIF p_id_estatus in(6, 7) THEN --SOLICITUD RECHAZADA O ACTUALIZADA
        --Insertamos el registro en la vista de rechazados de UNIPAGO
        INSERT INTO un_acceso_exterior.tss_rechazos_asignacion_nss_mv
        (
         n_num_control,
         n_id_registro,
         c_acta_municipio,
         c_acta_oficialia,
         c_acta_libro,
         c_acta_folio,
         c_acta_acta,
         c_acta_anio,
         c_fecha_nacimiento,
         d_fecha_solicitud,
         d_fecha_asignacion,
         c_motivo,
         n_nss_duplicidad,
         c_cve_entidad,
         nss_titular,
         c_dep_menor_extranjero
        )
        SELECT d.num_control,
               d.id_control,
               d.municipio_acta,
               d.oficialia_acta,
               d.libro_acta,
               d.folio_acta,
               d.numero_acta,
               d.ano_acta,
               to_char(d.fecha_nacimiento,'ddmmyyyy'),
               s.fecha_solicitud,
               d.fecha_procesa,
               e.uso_unipago,
               d.id_nss,
               d.id_ars,
               d.id_nss_titular,
               d.extranjero
          FROM suirplus.nss_det_solicitudes_t d
          JOIN suirplus.nss_solicitudes_t s
            ON s.id_solicitud = d.id_solicitud
          JOIN suirplus.seg_error_t e on e.id_error=d.id_error
         WHERE d.id_registro = p_id_registro;
      END IF;
    ELSE
      NULL;  
  END CASE;
  
  -- Fijamos todas las transacciones pendientes     
  COMMIT;
  
  -- Para eliminar el registro de la tabla de control o semaforo  
  DELETE FROM suirplus.nss_det_solicitud_en_proceso_t
  WHERE id_registro = p_id_registro
    AND id_estatus  = p_id_estatus
    AND id_error    = p_id_error;
    
  COMMIT;
  
  p_resultado := 'OK';
EXCEPTION
  WHEN e_ciudadano_no_existe THEN
    p_resultado := Suirplus.Seg_Retornar_Cadena_Error('151', NULL, NULL);
    
    -- Para devolver las transacciones pendientes
    ROLLBACK;
    
    -- Para eliminar el registro de la tabla de control o semaforo para permitir que sea procesado nuevamente
    DELETE FROM suirplus.nss_det_solicitud_en_proceso_t
    WHERE id_registro = p_id_registro
      AND id_estatus  = p_id_estatus
      AND id_error    = p_id_error;
      
    COMMIT;    
  WHEN e_solicitud_no_existe THEN
    p_resultado := Suirplus.Seg_Retornar_Cadena_Error('181', NULL, NULL);
    
    -- Para devolver las transacciones pendientes
    ROLLBACK;

    -- Para eliminar el registro de la tabla de control o semaforo para permitir que sea procesado nuevamente
    DELETE FROM suirplus.nss_det_solicitud_en_proceso_t
    WHERE id_registro = p_id_registro
      AND id_estatus  = p_id_estatus
      AND id_error    = p_id_error;
      
    COMMIT;
  WHEN e_estatus_sol_invalido THEN
    p_resultado := Suirplus.Seg_Retornar_Cadena_Error('183', NULL, NULL);

    -- Para devolver las transacciones pendientes
    ROLLBACK;

    -- Para eliminar el registro de la tabla de control o semaforo para permitir que sea procesado nuevamente
    DELETE FROM suirplus.nss_det_solicitud_en_proceso_t
    WHERE id_registro = p_id_registro
      AND id_estatus  = p_id_estatus
      AND id_error    = p_id_error;
      
    COMMIT;
  WHEN e_usuario_no_existe THEN
    p_resultado := Suirplus.Seg_Retornar_Cadena_Error('1', NULL, NULL);

    -- Para devolver las transacciones pendientes
    ROLLBACK;

    -- Para eliminar el registro de la tabla de control o semaforo para permitir que sea procesado nuevamente
    DELETE FROM suirplus.nss_det_solicitud_en_proceso_t
    WHERE id_registro = p_id_registro
      AND id_estatus  = p_id_estatus
      AND id_error    = p_id_error;
      
    COMMIT;
  WHEN OTHERS THEN
    p_resultado := SQLERRM||' - '||dbms_utility.format_error_backtrace;
    
    -- Para devolver las transacciones pendientes
    ROLLBACK;
    
    -- Para eliminar el registro de la tabla de control o semaforo para permitir que sea procesado nuevamente
    DELETE FROM suirplus.nss_det_solicitud_en_proceso_t
    WHERE id_registro = p_id_registro
      AND id_estatus  = p_id_estatus
      AND id_error    = p_id_error;
      
    COMMIT;
END;
