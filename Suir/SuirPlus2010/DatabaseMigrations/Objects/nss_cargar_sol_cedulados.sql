CREATE OR REPLACE PROCEDURE SUIRPLUS.NSS_CARGAR_SOL_CEDULADOS
(
 p_ult_usuario_act in suirplus.SEG_USUARIO_T.id_usuario%TYPE
) IS
  v_id_bitacora      suirplus.sfc_bitacora_t.id_bitacora%type;
  v_id_proceso       suirplus.SFC_PROCESOS_T.id_proceso%TYPE := '73'; -- Solicitud de NSS a CEDULADOS
  v_inicio           date := sysdate;
  v_final            date;
  v_conteo           pls_integer;
  v_totalMov         pls_integer;
  v_mensaje          varchar2(500);
  v_resultado        varchar2(200);
  v_id_solicitud     suirplus.nss_solicitudes_t.id_solicitud%type;
  v_id_det_solicitud suirplus.nss_det_solicitudes_t.id_registro%type;
  v_tracking         suirplus.SFC_PROCESOS_T.registros%type;

  e_proceso_no_existe Exception;
  e_usuario_no_existe Exception;
  e_nombre_vista      Exception;
BEGIN
  -- Grabar en Bitacora que va a comenzar el proceso
  suirplus.bitacora(v_id_bitacora, 'INI', v_id_proceso);

  -- Traigo los registros a considerar para ser puesto en el detalle de bitacora
  Begin
    Select a.registros
    Into v_tracking
    From suirplus.Sfc_Procesos_t a
    Where id_proceso = v_id_proceso;
  Exception When NO_DATA_FOUND Then
    RAISE e_proceso_no_existe;
  End;

  -- Grabar primer seguimiento en detalle de bitacora
  suirplus.detalle_bitacora(v_id_bitacora, sysdate, 'Inicio del PROCESO = '||v_id_proceso||' a las '||to_char(sysdate,'dd/mm/yyyy hh:mi:ss')||chr(13)||chr(10)||
                                                    'PARAMETROS: p_ult_usuario_act = '||p_ult_usuario_act||chr(13)||chr(10)||
                                                    'EJECUTADO POR: '|| SYS_CONTEXT('USERENV', 'SESSION_USER'));

  -- Ver si existe el usuario, si no existe termina la ejecucion
  Select count(*)
    Into v_conteo
    From seg_usuario_t t
   Where t.id_usuario = upper(p_ult_usuario_act);

  If v_conteo = 0 Then
    RAISE e_usuario_no_existe;
  End if;

  -- recojer las solicitudes de dichos lotes
  v_totalMov := 0;
  FOR Solicitudes IN (Select a.*, a.rowid
                      From suirplus.suir_r_sol_asig_cedula_mv a
                      Where a.status = 'PE'
                       AND NOT EXISTS 
                        (SELECT 1
                           FROM SUIRPLUS.NSS_DET_SOLICITUDES_T D
                          WHERE D.ID = A.ID
                        )
                      )
  LOOP
    BEGIN
      -- Insertamos primero en la maestra de solicitud
      v_id_solicitud := NULL;
      
      INSERT INTO suirplus.nss_solicitudes_t
      (
       id_solicitud,
       id_tipo,
       fecha_solicitud,
       usuario_solicita,
       ult_fecha_act,
       ult_usuario_act
      )
      VALUES
      (
       SUIRPLUS.NSS_SOLICITUDES_T_SEQ.NEXTVAL,
       CASE WHEN UPPER(Solicitudes.Tipo_Documento) = 'U' Then 2 ELSE 3 END, -- Viene del catalogo NSS_TIPO_SOLICITUD_T
       SYSDATE,
       CASE WHEN Solicitudes.Usuario IS NULL THEN 'UNIPAGO' ELSE Solicitudes.Usuario END,
       SYSDATE,
       p_ult_usuario_act
      ) RETURNING id_solicitud INTO v_id_solicitud;

      COMMIT;

      -- Insertamos los datos que completan la solicitud en el detalle de la solicitud
      v_id_det_solicitud := NULL;
      INSERT INTO suirplus.nss_det_solicitudes_t
      (
       id_registro,
       id_solicitud,
       secuencia,
       id_tipo_documento,
       no_documento_sol,
       id_estatus,
       id_parentesco,
       id_ars,
       id_nss_titular,
       num_control,
       id_control,
       ult_fecha_act,
       ult_usuario_act,
       ID
      )
      VALUES
      (
       SUIRPLUS.NSS_DET_SOLICITUDES_T_SEQ.NEXTVAL,
       v_id_solicitud,
       1,    -- Secuencia, fija, por el momento siempre 1
       solicitudes.tipo_documento,
       solicitudes.no_documento,
       1,    -- Nace pendiente de procesar
       Solicitudes.Codigo_Parentesco, -- Id_parentesco, debe venir desde unipago
       Solicitudes.Ars_Solicitante, -- Id_ars que hizo la afiliacion
       Solicitudes.Nss_Titular, -- NSS Titular
       solicitudes.N_NUM_CONTROL,
       solicitudes.N_ID_REGISTRO,
       SYSDATE,
       CASE WHEN Solicitudes.Usuario IS NULL THEN 'UNIPAGO' ELSE Solicitudes.Usuario END,
       solicitudes.ID
      ) RETURNING id_registro INTO v_id_det_solicitud;

      COMMIT;

      v_totalMov := v_totalMov + 1; -- contar los registros que se van procesando en esta corrida

       -- Si el total registros procesados es multiplo de la cantidad que el proceso debe guardar en detalle de bitacora
      IF REMAINDER(v_totalMov, v_tracking) = 0 THEN
        -- Grabar seguimiento en detalle de bitacora
        suirplus.detalle_bitacora(v_id_bitacora, sysdate, TRIM(TO_CHAR(v_totalMov,'999,999,999'))||' REGISTROS PROCESADOS.');
      END IF;
    EXCEPTION
      WHEN OTHERS THEN
        -- Grabar error en detalle de bitacora
        suirplus.detalle_bitacora(v_id_bitacora, sysdate,
                                  SUBSTR('ERROR EN LOTE = '||TO_CHAR(Solicitudes.N_NUM_CONTROL)||
                                         ', ID_CONTROL = '||TO_CHAR(Solicitudes.N_ID_REGISTRO)||
                                         CASE
                                           WHEN v_id_solicitud IS NULL THEN ' INSERTANDO EN NSS_SOLICITUDES_T: '
                                           WHEN v_id_det_solicitud IS NULL THEN ' INSERTANDO EN NSS_DET_SOLICITUDES_T: '
                                         END||
                                         SQLERRM
                                         ||' a las '||to_char(sysdate,'dd/mm/yyyy hh:mi:ss'), 1, 500
                                        )
                                 );
    END;
  END LOOP;

  IF v_totalMov > 0 THEN
    -- Registros remanentes sin poner en detalle de bitacora
    IF REMAINDER(v_totalMov, v_tracking) < 0 THEN
      -- Grabar seguimiento en detalle de bitacora
      suirplus.detalle_bitacora(v_id_bitacora, sysdate, TRIM(TO_CHAR(v_totalMov,'999,999,999'))||' REGISTROS PROCESADOS.');
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
    v_mensaje := Suirplus.Seg_Retornar_Cadena_Error(240, NULL, NULL);

    -- Para grabar mensaje a notificar
    suirplus.registrar_mensaje(v_id_proceso, SUBSTR(v_mensaje,1,500), 'P', v_resultado);

    -- Grabar fin seguimiento en detalle de bitacora
    suirplus.detalle_bitacora(v_id_bitacora,
                              sysdate,
                              SUBSTR('PROCESO TERMINADO CON ERROR: '||v_mensaje, 1, 500));

    -- Para cerrar la bitacora
    suirplus.bitacora(v_id_bitacora,
                     'FIN',
                     v_ID_PROCESO,
                     substr(v_mensaje, 1, 200),
                     'E',
                     '000');
  WHEN e_usuario_no_existe THEN
    v_mensaje := Suirplus.Seg_Retornar_Cadena_Error(1, NULL, NULL);

    -- Para grabar mensaje a notificar
    suirplus.registrar_mensaje(v_id_proceso, SUBSTR(v_mensaje,1,500), 'P', v_resultado);

    -- Grabar fin seguimiento en detalle de bitacora
    suirplus.detalle_bitacora(v_id_bitacora,
                              sysdate,
                              SUBSTR('PROCESO TERMINADO CON ERROR: '||v_mensaje, 1, 500));

    -- Para cerrar la bitacora
    suirplus.bitacora(v_id_bitacora,
                     'FIN',
                     v_ID_PROCESO,
                     substr(v_mensaje, 1, 200),
                     'E',
                     '000');
  WHEN e_nombre_vista THEN
    -- Para grabar mensaje a notificar
    suirplus.registrar_mensaje(v_id_proceso, SUBSTR(v_mensaje,1,500), 'P', v_resultado);

    -- Grabar fin seguimiento en detalle de bitacora
    suirplus.detalle_bitacora(v_id_bitacora,
                              sysdate,
                              SUBSTR('PROCESO TERMINADO CON ERROR: '||v_mensaje, 1, 500));

    -- Para cerrar la bitacora
    suirplus.bitacora(v_id_bitacora,
                     'FIN',
                     v_ID_PROCESO,
                     substr(v_mensaje, 1, 200),
                     'E',
                     '000');
  WHEN OTHERS THEN
    v_mensaje := SQLERRM||' - '||dbms_utility.format_error_backtrace;

    -- Para grabar mensaje a notificar
    suirplus.registrar_mensaje(v_id_proceso, SUBSTR(v_mensaje,1,500), 'P', v_resultado);

    -- Grabar fin seguimiento en detalle de bitacora
    suirplus.detalle_bitacora(v_id_bitacora,
                              sysdate,
                              SUBSTR('PROCESO TERMINADO CON ERROR: '||v_mensaje, 1, 500));

    -- Para cerrar la bitacora
    suirplus.bitacora(v_id_bitacora,
                     'FIN',
                     v_ID_PROCESO,
                     substr(v_mensaje, 1, 200),
                     'E',
                     '000');
END;