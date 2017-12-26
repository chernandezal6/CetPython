CREATE OR REPLACE PROCEDURE SUIRPLUS.NSS_CARGAR_SOLICITUDES_MENORES
(
 p_refrescar_vista in char,
 p_ult_usuario_act in suirplus.SEG_USUARIO_T.id_usuario%TYPE
) IS
  v_id_bitacora      suirplus.sfc_bitacora_t.id_bitacora%type;
  v_id_proceso       suirplus.SFC_PROCESOS_T.id_proceso%TYPE := 'AN'; -- Solicitud de NSS a Menores
  v_inicio           date := sysdate;
  v_final            date;
  v_conteo           pls_integer;
  v_totalMov         pls_integer;
  v_mensaje          varchar2(500);
  v_resultado        varchar2(200);
  v_id_solicitud     suirplus.nss_solicitudes_t.id_solicitud%type;
  v_id_det_solicitud suirplus.nss_det_solicitudes_t.id_registro%type;
  v_tracking         suirplus.SFC_PROCESOS_T.registros%type;

  v_msg              VARCHAR2(32767);
  
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
                                                    'PARAMETROS: p_refrescar_vista = '||NVL(p_refrescar_vista, 'S')||
                                                    ', p_ult_usuario_act = '||p_ult_usuario_act);

  -- Ver si existe el usuario, si no existe termina la ejecucion
  Select count(*)
    Into v_conteo
    From seg_usuario_t t
   Where t.id_usuario = upper(p_ult_usuario_act);

  If v_conteo = 0 Then
    RAISE e_usuario_no_existe;
  End if;

  -- Grabar fin seguimiento en detalle de bitacora
  suirplus.detalle_bitacora(v_id_bitacora, sysdate, 'Refrescando vista SUIR_R_SOL_ASIG_NSS_MENORES_MV con opcion P_REFRESCAR_VISTA = '||NVL(p_refrescar_vista,'N')||' iniciado a las '||to_char(sysdate,'dd/mm/yyyy hh:mi:ss'));

  -- Refrescamos la vista en cuestion
  v_mensaje := SUIRPLUS.REFRESCAR_VISTA('SUIR_R_SOL_ASIG_NSS_MENORES_MV', p_refrescar_vista);

  If v_mensaje IS NOT NULL Then
    RAISE e_nombre_vista;
  End if;

  -- Grabar fin seguimiento en detalle de bitacora
  suirplus.detalle_bitacora(v_id_bitacora, sysdate, 'Vista refrescada, finalizado a las '||to_char(sysdate,'dd/mm/yyyy hh:mi:ss'));

  -- recojer las solicitudes de dichos lotes
  v_totalMov := 0;
  FOR Solicitudes IN (Select a.N_NUM_CONTROL,
                             a.N_ID_REGISTRO,
                             upper(trim(a.C_ACTA_MUNICIPIO)) C_ACTA_MUNICIPIO,
                             upper(trim(a.C_ACTA_OFICIALIA)) C_ACTA_OFICIALIA,
                             upper(trim(a.C_ACTA_LIBRO))     C_ACTA_LIBRO,
                             upper(trim(a.C_ACTA_FOLIO))     C_ACTA_FOLIO,
                             upper(trim(a.C_ACTA_ACTA))      C_ACTA_ACTA,
                             upper(trim(a.C_ACTA_ANIO))      C_ACTA_ANIO,
                             upper(trim(a.C_APEPAT))         C_APEPAT,
                             upper(trim(a.C_APEMAT))         C_APEMAT,
                             upper(trim(a.PRIMER_NOM))       PRIMER_NOM,
                             upper(trim(a.C_NOMBRE2))        C_NOMBRE2,
                             a.C_FECHA_NACIMIENTO,
                             a.C_SEXO,
                             a.FECHA_SOLICITUD,
                             a.CODIGO_PENDIENTE,
                             a.C_CVE_ENTIDAD,
                             a.NSS_TITULAR,
                             a.C_DEP_EXTRANJERO,
                             a.C_ID_NACIONALIDAD,
                             a.N_TIPO_DOCUMENTO,
                             a.C_NUMERO_DOCUMENTO,
                             a.N_CVE_PARENTESCO
                        From suirplus.suir_r_sol_asig_nss_menores_mv a)
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
       CASE UPPER(solicitudes.C_DEP_EXTRANJERO) WHEN 'S' THEN 5 ELSE 1 END, -- Viene del catalogo NSS_TIPO_SOLICITUD_T
       SYSDATE,
       'UNIPAGO',
       SYSDATE,
       p_ult_usuario_act
      ) RETURNING id_solicitud INTO v_id_solicitud;

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
       nombres,
       primer_apellido,
       segundo_apellido,
       fecha_nacimiento,
       sexo,
       id_nacionalidad,
       municipio_acta,
       ano_acta,
       numero_acta,
       folio_acta,
       libro_acta,
       oficialia_acta,
       extranjero,
       id_nss_titular,
       id_parentesco,
       id_ars,
       num_control,
       id_control,
       ult_fecha_act,
       ult_usuario_act
      )
      VALUES
      (
       SUIRPLUS.NSS_DET_SOLICITUDES_T_SEQ.NEXTVAL,
       v_id_solicitud,
       1,    -- Secuencia, fija, por el momento siempre 1
	     CASE WHEN Solicitudes.C_DEP_EXTRANJERO = 'S' THEN 
           CASE Solicitudes.N_TIPO_DOCUMENTO 
             WHEN  9 THEN 'V' 
             WHEN 10 THEN 'G' 
             WHEN 11 THEN 'I'
             ELSE 'E'
           END 
	     ELSE 'N'
	     END, --9 - Visa de Trabajo. 10 - Carnet de Migración. 11 - Documento Expedido por el MIP. 
	     Solicitudes.C_NUMERO_DOCUMENTO,
       1,    -- Nace pendiente de procesar
       UPPER(SUBSTR(TRIM(solicitudes.PRIMER_NOM||' '||NVL(solicitudes.C_NOMBRE2,' ')), 1, 50)),
       UPPER(solicitudes.C_APEPAT),
       UPPER(solicitudes.C_APEMAT),
       to_date(solicitudes.C_FECHA_NACIMIENTO,'ddmmyyyy'),
       UPPER(solicitudes.C_SEXO),
       TO_CHAR(solicitudes.C_ID_NACIONALIDAD),
       UPPER(solicitudes.C_ACTA_MUNICIPIO),
       UPPER(solicitudes.C_ACTA_ANIO),
       UPPER(solicitudes.C_ACTA_ACTA),
       UPPER(solicitudes.C_ACTA_FOLIO),
       UPPER(solicitudes.C_ACTA_LIBRO),
       UPPER(solicitudes.C_ACTA_OFICIALIA),
       UPPER(solicitudes.C_DEP_EXTRANJERO),
       solicitudes.NSS_TITULAR,
       solicitudes.n_cve_parentesco, -- Id_parentesco, debe venir desde unipago
       solicitudes.C_CVE_ENTIDAD, -- Id_ars que hizo la afiliacion
       solicitudes.N_NUM_CONTROL,
       solicitudes.N_ID_REGISTRO,
       SYSDATE,
       p_ult_usuario_act
      ) RETURNING id_registro INTO v_id_det_solicitud;

      COMMIT;

      -- Para traer la imagen desde UNIPAGO para este registro en particular
      -- y reducir el consumo de ancho de banda al no incluirlo en el refrescamiento de la vista
      EXECUTE IMMEDIATE 'BEGIN
                           UPDATE suirplus.nss_det_solicitudes_t
                           SET imagen_solicitud = (
                                                   Select b_imagen
                                                     From SUIR_R_SOL_ASIG_NSS_MENORES_MV@UNIPRO_DBL
                                                    Where N_NUM_CONTROL = :N_NUM_CONTROL
                                                     And N_ID_REGISTRO = :N_ID_REGISTRO
                                                  )
                           WHERE id_registro = :ID_REGISTRO;
                           COMMIT;
                         END;'
      USING solicitudes.N_NUM_CONTROL, solicitudes.N_ID_REGISTRO, v_id_det_solicitud;

      v_totalMov := v_totalMov + 1; -- contar los registros que se van procesando en esta corrida

       -- Si el total registros procesados es multiplo de la cantidad que el proceso debe guardar en detalle de bitacora
      IF REMAINDER(v_totalMov, v_tracking) = 0 THEN
        -- Grabar seguimiento en detalle de bitacora
        suirplus.detalle_bitacora(v_id_bitacora, sysdate, TRIM(TO_CHAR(v_totalMov,'999,999,999'))||' REGISTROS PROCESADOS.');
      END IF;

      --Llama proceso que vifurca la solicitud para validarla
      SUIRPLUS.NSS_VALIDAR_SOLICITUD(v_id_solicitud, p_ult_usuario_act, v_msg);
    EXCEPTION
      WHEN OTHERS THEN
        -- Grabar error en detalle de bitacora
        suirplus.detalle_bitacora(v_id_bitacora, sysdate,
                                  SUBSTR('ERROR EN LOTE = '||TO_CHAR(Solicitudes.N_NUM_CONTROL)||
                                         ', ID_CONTROL = '||TO_CHAR(Solicitudes.N_ID_REGISTRO)||
                                         CASE
                                           WHEN v_id_solicitud IS NULL THEN 'INSERTANDO EN NSS_SOLICITUDES_T: '
                                           WHEN v_id_det_solicitud IS NULL THEN 'INSERTANDO EN NSS_DET_SOL_SOLICITUDES_T: '
                                           ELSE 'ACTUALIZANDO LA IMAGEN EN NSS_DET_SOLICITUDES_T: '
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