CREATE OR REPLACE PROCEDURE SUIRPLUS.NSS_ACTUALIZAR_CIUDADANO
(
 p_id_registro in suirplus.nss_det_solicitudes_t.id_registro%Type,
 p_sre_ciudadano in suirplus.sre_ciudadanos_t%rowtype,
 p_ult_usuario_act suirplus.seg_usuario_t.id_usuario%Type,
 p_resultado out varchar2
) IS
  v_id_tipo       suirplus.nss_tipo_solicitudes_t.id_tipo%type;
  v_id_nss        suirplus.sre_ciudadanos_t.id_nss%Type;
  v_id_solicitud  suirplus.nss_solicitudes_t.id_solicitud%type;
  v_id_evaluacion suirplus.nss_evaluacion_visual_t.id_evaluacion%Type;
  v_id_bitacora   suirplus.sfc_bitacora_t.id_bitacora%type;
  v_id_proceso    suirplus.sfc_procesos_t.id_proceso%TYPE := '75'; -- Actualizar CIUDADANO
  v_inicio        DATE := SYSDATE;
  v_final         DATE;
  v_conteo        PLS_INTEGER;
  v_mensaje       VARCHAR2(500);
  v_resultado     VARCHAR2(200);

  e_proceso_no_existe   EXCEPTION;
  e_solicitud_no_existe EXCEPTION;
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

  -- Si no existe la solicitud, termina la ejecucion informando en bitacora
  BEGIN
    SELECT s.id_tipo, s.id_solicitud
      INTO v_id_tipo, v_id_solicitud
      FROM suirplus.nss_det_solicitudes_t d
      JOIN suirplus.nss_solicitudes_t s
        ON s.id_solicitud = d.id_solicitud
     WHERE d.id_registro = p_id_registro;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RAISE e_solicitud_no_existe;
  END;

  -- Por tipo de solicitud realizamos la accion correspondiente
  CASE
    WHEN v_id_tipo = 1 THEN -- MENORES SIN DOCUMENTOS NACIONALES
      DECLARE
        v_libro_acta suirplus.sre_ciudadanos_t.libro_acta%Type;
        v_literal_acta suirplus.sre_ciudadanos_t.literal_acta%Type;
      BEGIN
        FOR C_SOL IN
          (
           SELECT D.*
             FROM suirplus.nss_det_solicitudes_t d
            WHERE d.id_registro = p_id_registro
              AND d.id_estatus in (1, 4) -- Pendiente o en Evaluacion Visual
          )
        LOOP
          -- Para saber de donde vamos a tomar el ID_NSS
          IF NVL(p_sre_ciudadano.Id_Nss,0) = 0 THEN
            v_id_nss := C_SOL.ID_NSS;
          ELSE
            v_id_nss := p_sre_ciudadano.Id_Nss;
          END IF;

          -- Crear el registro en historico de documento
          INSERT INTO suirplus.sre_his_documentos_t
          (
           id,
           id_nss,
           id_tipo_documento,
           no_documento,
           fecha_emision,
           estatus,
           registrado_por,
           fecha_registro,
           ult_fecha_act,
           ult_usuario_act
          )
          SELECT
           suirplus.sre_his_documentos_t_seq.nextval,
           c.id_nss,
           c.tipo_documento,
           c.no_documento,
           SYSDATE,
           'A', --A=Activo
           p_ult_usuario_act,
           SYSDATE,
           SYSDATE,
           p_ult_usuario_act
          FROM suirplus.sre_ciudadanos_t c
         WHERE c.id_nss = v_id_nss;

          --Actualiza los registro del ciudadano con los datos de la Evaluación Visual
          v_libro_acta := SUIRPLUS.NSS_VALIDACIONES_PKG.LIMPIAR_LIBRO_ACTA(C_SOL.LIBRO_ACTA, C_SOL.ANO_ACTA, v_literal_acta);

          update suirplus.sre_ciudadanos_t c
          set MUNICIPIO_ACTA    = SUIRPLUS.NSS_VALIDACIONES_PKG.LIMPIAR_MUNICIPIO_ACTA(C_SOL.MUNICIPIO_ACTA),
              ANO_ACTA          = SUIRPLUS.NSS_VALIDACIONES_PKG.LIMPIAR_ANO_ACTA(C_SOL.ANO_ACTA),
              NUMERO_ACTA       = SUIRPLUS.NSS_VALIDACIONES_PKG.LIMPIAR_NUMERO_ACTA(C_SOL.NUMERO_ACTA),
              FOLIO_ACTA        = SUIRPLUS.NSS_VALIDACIONES_PKG.LIMPIAR_FOLIO_ACTA(C_SOL.FOLIO_ACTA),
              LIBRO_ACTA        = v_libro_acta,
              OFICIALIA_ACTA    = SUIRPLUS.NSS_VALIDACIONES_PKG.LIMPIAR_OFICIALIA_ACTA(C_SOL.OFICIALIA_ACTA),
              NOMBRES           = Decode(C_SOL.NOMBRES,null,c.nombres,Trim(C_SOL.NOMBRES)),
              PRIMER_APELLIDO   = Decode(C_SOL.PRIMER_APELLIDO,null,c.primer_apellido,Trim(C_SOL.PRIMER_APELLIDO)),
              SEGUNDO_APELLIDO  = Decode(C_SOL.SEGUNDO_APELLIDO,null,c.segundo_apellido,Trim(C_SOL.SEGUNDO_APELLIDO)),
              SEXO              = Decode(C_SOL.SEXO,null,c.sexo,C_SOL.sexo),
              IMAGEN_ACTA       = C_SOL.IMAGEN_SOLICITUD,
              FECHA_NACIMIENTO  = C_SOL.FECHA_NACIMIENTO,
              POSIBLE_DUPLICADO = NULL,
              ULT_FECHA_ACT     = SYSDATE,
              ULT_USUARIO_ACT   = p_ult_usuario_act
          where id_nss = v_id_nss;

          -- Actualizar maestra evaluacion visual
          IF C_SOL.ID_ESTATUS = 4 THEN
            UPDATE suirplus.nss_evaluacion_visual_t e
               SET e.fecha_respuesta = SYSDATE,
                   e.usuario_procesa = p_ult_usuario_act,
                   e.estatus         = 'CO', -- Evaluacion Visual Completada
                   e.ult_fecha_act   = SYSDATE,
                   e.ult_usuario_act = p_ult_usuario_act
             WHERE e.id_registro = p_id_registro
            RETURNING ID_EVALUACION INTO v_id_evaluacion;

            -- Actualizar detalle evaluacion visual y ciudadanos marcarlo como "posible duplicado"
            FOR C_EV IN (SELECT E.ID_DET_EVALUACION, E.ID_NSS, 
                                (select count(*) 
                                 from suirplus.Nss_Det_Evaluacion_Visual_t
                                 WHERE id_evaluacion = v_id_evaluacion) CUANTOS
                           FROM suirplus.Nss_Det_Evaluacion_Visual_t e
                          WHERE e.id_evaluacion = v_id_evaluacion)
            LOOP
              UPDATE suirplus.sre_ciudadanos_t c
                 SET c.posible_duplicado = CASE WHEN C_EV.CUANTOS > 1 THEN 'X' ELSE NULL END
               WHERE c.id_nss = C_EV.ID_NSS;
               
              UPDATE suirplus.sre_ciudadanos_t c
                 SET c.posible_duplicado = CASE WHEN C_EV.CUANTOS > 1 THEN 'X' ELSE NULL END
               WHERE c.id_nss = v_id_nss;               

              UPDATE suirplus.nss_det_evaluacion_visual_t d
                 SET d.id_accion_ev = 2 -- Actualizar el NSS
               WHERE d.id_det_evaluacion = C_EV.ID_DET_EVALUACION;
            END LOOP;
          END IF;

          -- Actualizar estatus solicitud a: NSS ACTUALIZADO
          SUIRPLUS.NSS_ACTUALIZAR_SOLICITUD(C_SOL.ID_REGISTRO, 7, 'NSS904', v_id_nss, p_ult_usuario_act, p_resultado);

          IF p_resultado <> 'OK' THEN
            -- Grabar fin seguimiento en detalle de bitacora
            suirplus.detalle_bitacora(v_id_bitacora,
                                      sysdate,
                                      SUBSTR('Solicitud ASIGNACION NSS A '||CASE v_id_tipo WHEN 1 THEN 'MENOR NACIONAL, ' WHEN 5 THEN 'MENOR EXTRANJERO, ' END||'ID_SOLICITUD #'||to_char(V_ID_SOLICITUD)||', ID_REGISTRO #'||to_char(P_ID_REGISTRO)||': no pudo ser actualizada a estatus 7 ('||to_char(sysdate,'dd/mm/yyyy hh:mi:ss am')||').'||chr(13)||chr(10)||
                                      'MOTIVO: '||p_resultado,1,500));
          ELSE
            -- Grabar seguimiento en detalle de bitacora
            suirplus.detalle_bitacora(v_id_bitacora,
                                      sysdate,
                                      SUBSTR('Solicitud ASIGNACION NSS A '||CASE v_id_tipo WHEN 1 THEN 'MENOR NACIONAL, ' WHEN 5 THEN 'MENOR EXTRANJERO, ' END||'ID_SOLICITUD #'||to_char(V_ID_SOLICITUD)||', ID_REGISTRO #'||to_char(P_ID_REGISTRO)||': actualizada a estatus 7 ('||to_char(sysdate,'dd/mm/yyyy hh:mi:ss am')||').',1,500));
          END IF;
        END LOOP;
      END;
    WHEN v_id_tipo = 2 THEN -- MENOR CON NUI
      FOR C_SOL IN
        (
         SELECT D.*, S.ID_TIPO
           FROM suirplus.nss_det_solicitudes_t d
           JOIN suirplus.nss_solicitudes_t s
             ON s.id_solicitud = d.id_solicitud
          WHERE d.id_registro = p_id_registro
            AND d.id_estatus in (1, 4) -- Pendiente o en Evaluacion Visual
        )
      LOOP
        -- Para saber de donde vamos a tomar el ID_NSS
        IF NVL(p_sre_ciudadano.Id_Nss,0) = 0 THEN
          v_id_nss := C_SOL.ID_NSS;
        ELSE
          v_id_nss := p_sre_ciudadano.Id_Nss;
        END IF;
        
        IF C_SOL.ID_ESTATUS = 1 THEN --Pendiente, tomo los datos del ciudadano desde el WEBSERVICE
          -- Crear el registro en historico de documento
          INSERT INTO suirplus.sre_his_documentos_t
          (
           id,
           id_nss,
           id_tipo_documento,
           no_documento,
           fecha_emision,
           estatus,
           registrado_por,
           fecha_registro,
           ult_fecha_act,
           ult_usuario_act
          )
          SELECT
           suirplus.sre_his_documentos_t_seq.nextval,
           c.id_nss,
           c.tipo_documento,
           c.no_documento,
           SYSDATE,
           'A', --A=Activo
           p_ult_usuario_act,
           SYSDATE,
           SYSDATE,
           p_ult_usuario_act
          FROM suirplus.sre_ciudadanos_t c
         WHERE c.id_nss = v_id_nss;

          -- ACTUALIZAMOS EL CIUDADANO
          UPDATE suirplus.sre_ciudadanos_t
          SET TIPO_DOCUMENTO    = p_sre_ciudadano.TIPO_DOCUMENTO,
              NO_DOCUMENTO      = p_sre_ciudadano.NO_DOCUMENTO,
              NOMBRES           = p_sre_ciudadano.NOMBRES,
              PRIMER_APELLIDO   = p_sre_ciudadano.PRIMER_APELLIDO,
              SEGUNDO_APELLIDO  = p_sre_ciudadano.SEGUNDO_APELLIDO,
              FECHA_NACIMIENTO  = p_sre_ciudadano.FECHA_NACIMIENTO,
              ID_NACIONALIDAD   = p_sre_ciudadano.ID_NACIONALIDAD,
              TIPO_LIBRO_ACTA   = p_sre_ciudadano.TIPO_LIBRO_ACTA,
              LITERAL_ACTA      = p_sre_ciudadano.LITERAL_ACTA,
              CEDULA_MADRE      = p_sre_ciudadano.CEDULA_MADRE,
              CEDULA_PADRE      = p_sre_ciudadano.CEDULA_PADRE,
              NOMBRE_MADRE      = p_sre_ciudadano.NOMBRE_MADRE,
              NOMBRE_PADRE      = p_sre_ciudadano.NOMBRE_PADRE,
              NUMERO_EVENTO     = p_sre_ciudadano.NUMERO_EVENTO,
              ULT_FECHA_ACT     = SYSDATE,
              ULT_USUARIO_ACT   = p_ult_usuario_act              
          WHERE ID_NSS = v_id_nss;
        ELSIF C_SOL.ID_ESTATUS = 4 THEN --Evaluacion Visual, tomo los datos del ciudadano en el detalle de la solicitud
          -- Crear el registro en historico de documento
          INSERT INTO suirplus.sre_his_documentos_t
          (
           id,
           id_nss,
           id_tipo_documento,
           no_documento,
           fecha_emision,
           estatus,
           registrado_por,
           fecha_registro,
           ult_fecha_act,
           ult_usuario_act
          )
          SELECT
           suirplus.sre_his_documentos_t_seq.nextval,
           c.id_nss,
           c.tipo_documento,
           c.no_documento,
           SYSDATE,
           'A', --A=Activo
           p_ult_usuario_act,
           SYSDATE,
           SYSDATE,
           p_ult_usuario_act
          FROM suirplus.sre_ciudadanos_t c
         WHERE c.id_nss = v_id_nss;

          -- ACTUALIZAMOS EL CIUDADANO
          UPDATE suirplus.sre_ciudadanos_t
          SET TIPO_DOCUMENTO    = C_SOL.ID_TIPO_DOCUMENTO,
              NO_DOCUMENTO      = C_SOL.NO_DOCUMENTO_SOL,
              NOMBRES           = C_SOL.NOMBRES,
              PRIMER_APELLIDO   = C_SOL.PRIMER_APELLIDO,
              SEGUNDO_APELLIDO  = C_SOL.SEGUNDO_APELLIDO,
              FECHA_NACIMIENTO  = C_SOL.FECHA_NACIMIENTO,
              ID_NACIONALIDAD   = C_SOL.ID_NACIONALIDAD,              
              TIPO_LIBRO_ACTA   = C_SOL.TIPO_LIBRO_ACTA,
              LITERAL_ACTA      = C_SOL.LITERAL_ACTA,
              CEDULA_MADRE      = C_SOL.CEDULA_MADRE,
              CEDULA_PADRE      = C_SOL.CEDULA_PADRE,
              NOMBRE_MADRE      = C_SOL.NOMBRE_MADRE,
              NOMBRE_PADRE      = C_SOL.NOMBRE_PADRE,
              NUMERO_EVENTO     = C_SOL.NUMERO_EVENTO,
              ULT_FECHA_ACT     = SYSDATE,
              ULT_USUARIO_ACT   = p_ult_usuario_act
          WHERE ID_NSS = v_id_nss;

          -- Actualizar maestra evaluacion visual
          UPDATE suirplus.nss_evaluacion_visual_t e
             SET e.fecha_respuesta = SYSDATE,
                 e.usuario_procesa = p_ult_usuario_act,
                 e.estatus         = 'CO', -- Evaluacion Visual Completada
                 e.ult_fecha_act   = SYSDATE,
                 e.ult_usuario_act = p_ult_usuario_act
           WHERE e.id_registro = p_id_registro
          RETURNING ID_EVALUACION INTO v_id_evaluacion;

          -- Actualizar detalle evaluacion visual y ciudadanos marcarlo como "posible duplicado"
          FOR C_EV IN (SELECT E.ID_DET_EVALUACION, E.ID_NSS, 
                              (select count(*) 
                                 from suirplus.Nss_Det_Evaluacion_Visual_t
                                 WHERE id_evaluacion = v_id_evaluacion) CUANTOS
                          FROM suirplus.Nss_Det_Evaluacion_Visual_t e
                         WHERE e.id_evaluacion = v_id_evaluacion)
          LOOP
            UPDATE suirplus.sre_ciudadanos_t c
               SET c.posible_duplicado = CASE WHEN C_EV.CUANTOS > 1 THEN 'X' ELSE NULL END
             WHERE c.id_nss = C_EV.ID_NSS;

            UPDATE suirplus.sre_ciudadanos_t c
               SET c.posible_duplicado = CASE WHEN C_EV.CUANTOS > 1 THEN 'X' ELSE NULL END
             WHERE c.id_nss = v_id_nss;

            UPDATE suirplus.nss_det_evaluacion_visual_t d
               SET d.id_accion_ev = 2 -- Actualizar el NSS
             WHERE d.id_det_evaluacion = C_EV.ID_DET_EVALUACION;
          END LOOP;
        END IF;

        -- Actualizar estatus solicitud a: NSS ASIGNADO
        SUIRPLUS.NSS_ACTUALIZAR_SOLICITUD(p_id_registro, 7, '0', v_id_nss, p_ult_usuario_act, p_resultado);

        IF p_resultado <> 'OK' THEN
          -- Grabar fin seguimiento en detalle de bitacora
          suirplus.detalle_bitacora(v_id_bitacora,
                                    sysdate,
                                    SUBSTR('Solicitud ASIGNACION NSS A MENOR CON NUI, ID_SOLICITUD #'||to_char(V_ID_SOLICITUD)||', ID_REGISTRO #'||to_char(P_ID_REGISTRO)||': no pudo ser actualizada a estatus 7 ('||to_char(sysdate,'dd/mm/yyyy hh:mi:ss am')||').'||chr(13)||chr(10)||
                                    'MOTIVO: '||p_resultado,1,500));
        ELSE
          -- Grabar seguimiento en detalle de bitacora
          suirplus.detalle_bitacora(v_id_bitacora,
                                    sysdate,
                                    SUBSTR('Solicitud ASIGNACION NSS A MENOR CON NUI, ID_SOLICITUD #'||to_char(V_ID_SOLICITUD)||', ID_REGISTRO #'||to_char(P_ID_REGISTRO)||': actualizada a estatus 7 ('||to_char(sysdate,'dd/mm/yyyy hh:mi:ss am')||').',1,500));
        END IF;
      END LOOP;
    WHEN v_id_tipo = 3 THEN -- CEDULADOS
      FOR C_SOL IN
        (
         SELECT D.*, S.ID_TIPO
           FROM suirplus.nss_det_solicitudes_t d
           JOIN suirplus.nss_solicitudes_t s
             ON s.id_solicitud = d.id_solicitud
          WHERE d.id_registro = p_id_registro
            AND d.id_estatus in (1, 4) -- Pendiente o en Evaluacion Visual
        )
      LOOP
        DECLARE
          v_conteo     pls_integer;
          v_cambiar    pls_integer := 1;
          v_causa_inha suirplus.sre_inhabilidad_jce_t.id_causa_inhabilidad%type;
          v_tipo_causa suirplus.sre_inhabilidad_jce_t.tipo_causa%type;
        BEGIN
          -- Para saber de donde vamos a tomar el ID_NSS
          IF NVL(p_sre_ciudadano.Id_Nss,0) = 0 THEN
            v_id_nss := C_SOL.ID_NSS;
          ELSE
            v_id_nss := p_sre_ciudadano.Id_Nss;
          END IF;

          --Estatus cancelacion en TSS
          Select c.id_causa_inhabilidad, c.tipo_causa
            into v_causa_inha, v_tipo_causa
            from suirplus.sre_ciudadanos_t c
           where c.id_nss = v_id_nss;

          --Ver si tiene una novedad de fallecido
          Select count(*)
            Into v_conteo
            From suirplus.sre_det_novedades_fallecidos_t
           where id_nss = v_id_nss
             and status = 'OK';

          if v_conteo > 0 then
            v_cambiar := 0; --no se cambia
          end if;

          IF C_SOL.ID_ESTATUS = 1 THEN --Pendiente, tomo los datos del ciudadano desde el WEBSERVICE
            -- Crear el registro en historico de documento
            INSERT INTO suirplus.sre_his_documentos_t
            (
             id,
             id_nss,
             id_tipo_documento,
             no_documento,
             fecha_emision,
             estatus,
             registrado_por,
             fecha_registro,
             ult_fecha_act,
             ult_usuario_act
            )
            SELECT
             suirplus.sre_his_documentos_t_seq.nextval,
             c.id_nss,
             c.tipo_documento,
             c.no_documento,
             SYSDATE,
             'A', --A=Activo
             p_ult_usuario_act,
             SYSDATE,
             SYSDATE,
             p_ult_usuario_act
            FROM suirplus.sre_ciudadanos_t c
           WHERE c.id_nss = v_id_nss;

            -- ACTUALIZAMOS EL CIUDADANO
            UPDATE suirplus.sre_ciudadanos_t
            SET TIPO_DOCUMENTO        = p_sre_ciudadano.TIPO_DOCUMENTO,
                NO_DOCUMENTO          = p_sre_ciudadano.NO_DOCUMENTO,
                NOMBRES               = p_sre_ciudadano.NOMBRES,
                PRIMER_APELLIDO       = p_sre_ciudadano.PRIMER_APELLIDO,
                SEGUNDO_APELLIDO      = p_sre_ciudadano.SEGUNDO_APELLIDO,
                FECHA_NACIMIENTO      = p_sre_ciudadano.FECHA_NACIMIENTO,
                SEXO                  = p_sre_ciudadano.SEXO,
                ID_PROVINCIA          = p_sre_ciudadano.ID_PROVINCIA,
                ID_TIPO_SANGRE        = p_sre_ciudadano.ID_TIPO_SANGRE,
                ID_NACIONALIDAD       = p_sre_ciudadano.ID_NACIONALIDAD,
                CEDULA_MADRE          = p_sre_ciudadano.CEDULA_MADRE,
                CEDULA_PADRE          = p_sre_ciudadano.CEDULA_PADRE,
                NOMBRE_MADRE          = p_sre_ciudadano.NOMBRE_MADRE,
                NOMBRE_PADRE          = p_sre_ciudadano.NOMBRE_PADRE,
                MUNICIPIO_ACTA        = p_sre_ciudadano.MUNICIPIO_ACTA,
                ANO_ACTA              = p_sre_ciudadano.ANO_ACTA,
                NUMERO_ACTA           = p_sre_ciudadano.NUMERO_ACTA,
                FOLIO_ACTA            = p_sre_ciudadano.FOLIO_ACTA,
                LIBRO_ACTA            = p_sre_ciudadano.LIBRO_ACTA,
                OFICIALIA_ACTA        = p_sre_ciudadano.OFICIALIA_ACTA,
                TIPO_LIBRO_ACTA       = p_sre_ciudadano.TIPO_LIBRO_ACTA,
                STATUS                = p_sre_ciudadano.STATUS,
                ESTADO_CIVIL          = p_sre_ciudadano.ESTADO_CIVIL,            
                TIPO_CAUSA            = CASE
                                          WHEN V_CAMBIAR = 0 THEN
                                            TIPO_CAUSA --como dice en TSS
                                          WHEN V_CAUSA_INHA >= 100 AND V_TIPO_CAUSA = 'C' AND p_sre_ciudadano.TIPO_CAUSA IS NULL THEN
                                            TIPO_CAUSA --como dice en TSS
                                          ELSE
                                            p_sre_ciudadano.TIPO_CAUSA --como dice en JCE
                                        END,
                ID_CAUSA_INHABILIDAD  = CASE
                                          WHEN V_CAMBIAR = 0 THEN
                                            ID_CAUSA_INHABILIDAD --como dice en TSS
                                          WHEN V_CAUSA_INHA >= 100 AND V_TIPO_CAUSA = 'C' AND p_sre_ciudadano.TIPO_CAUSA IS NULL THEN
                                            ID_CAUSA_INHABILIDAD --como dice en TSS
                                          ELSE
                                            p_sre_ciudadano.ID_CAUSA_INHABILIDAD --como dice en JCE
                                        END,
                FECHA_CANCELACION_TSS = CASE
                                          WHEN V_CAMBIAR = 0 THEN
                                            FECHA_CANCELACION_TSS --como dice en TSS
                                          WHEN V_CAUSA_INHA >= 100 AND V_TIPO_CAUSA = 'C' AND p_sre_ciudadano.TIPO_CAUSA IS NULL THEN
                                            FECHA_CANCELACION_TSS --como dice en TSS
                                          ELSE
                                            SYSDATE --el dia que nos enteramos del evento
                                        END,
                FECHA_CANCELACION_JCE = p_sre_ciudadano.FECHA_CANCELACION_JCE,
                FECHA_FALLECIMIENTO   = CASE
                                          WHEN V_CAMBIAR = 0 THEN
                                            FECHA_FALLECIMIENTO --como dice en TSS
                                          WHEN V_CAUSA_INHA >= 100 AND V_TIPO_CAUSA = 'C' AND p_sre_ciudadano.TIPO_CAUSA IS NULL THEN
                                            FECHA_FALLECIMIENTO --como dice en TSS
                                          ELSE
                                            p_sre_ciudadano.FECHA_CANCELACION_JCE --como dice en JCE
                                        END,
                ULT_FECHA_ACT         = SYSDATE,
                ULT_USUARIO_ACT       = p_ult_usuario_act,
                NUMERO_EVENTO         = p_sre_ciudadano.NUMERO_EVENTO
            WHERE ID_NSS = v_id_nss;
          ELSIF C_SOL.ID_ESTATUS = 4 THEN --Evaluacion Visual, tomo los datos del ciudadano en el detalle de la solicitud
            -- Crear el registro en historico de documento
            INSERT INTO suirplus.sre_his_documentos_t
            (
             id,
             id_nss,
             id_tipo_documento,
             no_documento,
             fecha_emision,
             estatus,
             registrado_por,
             fecha_registro,
             ult_fecha_act,
             ult_usuario_act
            )
            SELECT
             suirplus.sre_his_documentos_t_seq.nextval,
             c.id_nss,
             c.tipo_documento,
             c.no_documento,
             SYSDATE,
             'A', --A=Activo
             p_ult_usuario_act,
             SYSDATE,
             SYSDATE,
             p_ult_usuario_act
            FROM suirplus.sre_ciudadanos_t c
           WHERE c.id_nss = v_id_nss;

            -- ACTUALIZAMOS EL CIUDADANO
            UPDATE suirplus.sre_ciudadanos_t
            SET TIPO_DOCUMENTO        = C_SOL.ID_TIPO_DOCUMENTO,
                NO_DOCUMENTO          = C_SOL.NO_DOCUMENTO_SOL,
                NOMBRES               = C_SOL.NOMBRES,
                PRIMER_APELLIDO       = C_SOL.PRIMER_APELLIDO,
                SEGUNDO_APELLIDO      = C_SOL.SEGUNDO_APELLIDO,
                FECHA_NACIMIENTO      = C_SOL.FECHA_NACIMIENTO,
                SEXO                  = C_SOL.SEXO,
                ID_TIPO_SANGRE        = C_SOL.ID_TIPO_SANGRE,
                ID_NACIONALIDAD       = C_SOL.ID_NACIONALIDAD,
                CEDULA_MADRE          = C_SOL.CEDULA_MADRE,
                CEDULA_PADRE          = C_SOL.CEDULA_PADRE,
                NOMBRE_MADRE          = C_SOL.NOMBRE_MADRE,
                NOMBRE_PADRE          = C_SOL.NOMBRE_PADRE,
                MUNICIPIO_ACTA        = C_SOL.MUNICIPIO_ACTA,
                ANO_ACTA              = C_SOL.ANO_ACTA,
                NUMERO_ACTA           = C_SOL.NUMERO_ACTA,
                FOLIO_ACTA            = C_SOL.FOLIO_ACTA,
                LIBRO_ACTA            = C_SOL.LIBRO_ACTA,
                OFICIALIA_ACTA        = C_SOL.OFICIALIA_ACTA,
                TIPO_LIBRO_ACTA       = C_SOL.TIPO_LIBRO_ACTA,
                STATUS                = C_SOL.ESTATUS_JCE,
                ESTADO_CIVIL          = C_SOL.ESTADO_CIVIL,
                TIPO_CAUSA            = CASE
                                          WHEN V_CAMBIAR = 0 THEN
                                            TIPO_CAUSA --como dice en TSS
                                          WHEN V_CAUSA_INHA >= 100 AND V_TIPO_CAUSA = 'C' AND p_sre_ciudadano.TIPO_CAUSA IS NULL THEN
                                            TIPO_CAUSA --como dice en TSS
                                          ELSE
                                            p_sre_ciudadano.TIPO_CAUSA --como dice en JCE
                                        END,
                ID_CAUSA_INHABILIDAD  = CASE
                                          WHEN V_CAMBIAR = 0 THEN
                                            ID_CAUSA_INHABILIDAD --como dice en TSS
                                          WHEN V_CAUSA_INHA >= 100 AND V_TIPO_CAUSA = 'C' AND p_sre_ciudadano.TIPO_CAUSA IS NULL THEN
                                            ID_CAUSA_INHABILIDAD --como dice en TSS
                                          ELSE
                                            p_sre_ciudadano.ID_CAUSA_INHABILIDAD --como dice en JCE
                                        END,
                FECHA_CANCELACION_TSS = CASE
                                          WHEN V_CAMBIAR = 0 THEN
                                            FECHA_CANCELACION_TSS --como dice en TSS
                                          WHEN V_CAUSA_INHA >= 100 AND V_TIPO_CAUSA = 'C' AND p_sre_ciudadano.TIPO_CAUSA IS NULL THEN
                                            FECHA_CANCELACION_TSS --como dice en TSS
                                          ELSE
                                            SYSDATE --el dia que nos enteramos del evento
                                        END,
                FECHA_CANCELACION_JCE = C_SOL.FECHA_CANCELACION_JCE,
                FECHA_FALLECIMIENTO   = CASE
                                          WHEN V_CAMBIAR = 0 THEN
                                            FECHA_FALLECIMIENTO --como dice en TSS
                                          WHEN V_CAUSA_INHA >= 100 AND V_TIPO_CAUSA = 'C' AND p_sre_ciudadano.TIPO_CAUSA IS NULL THEN
                                            FECHA_FALLECIMIENTO --como dice en TSS
                                          ELSE
                                            p_sre_ciudadano.FECHA_CANCELACION_JCE --como dice en JCE
                                        END,
                ULT_FECHA_ACT         = SYSDATE,
                ULT_USUARIO_ACT       = p_ult_usuario_act,
                NUMERO_EVENTO         = C_SOL.NUMERO_EVENTO
            WHERE ID_NSS = v_id_nss;

            -- Actualizar maestra evaluacion visual
            UPDATE suirplus.nss_evaluacion_visual_t e
               SET e.fecha_respuesta = SYSDATE,
                   e.usuario_procesa = p_ult_usuario_act,
                   e.estatus         = 'CO', -- Evaluacion Visual Completada
                   e.ult_fecha_act   = SYSDATE,
                   e.ult_usuario_act = p_ult_usuario_act
             WHERE e.id_registro = p_id_registro
            RETURNING ID_EVALUACION INTO v_id_evaluacion;

            -- Actualizar detalle evaluacion visual y ciudadanos marcarlo como "posible duplicado"
            FOR C_EV IN (SELECT E.ID_DET_EVALUACION, E.ID_NSS, 
                                (select count(*) 
                                 from suirplus.Nss_Det_Evaluacion_Visual_t
                                 WHERE id_evaluacion = v_id_evaluacion) CUANTOS
                           FROM suirplus.Nss_Det_Evaluacion_Visual_t e
                          WHERE e.id_evaluacion = v_id_evaluacion)
            LOOP
              UPDATE suirplus.sre_ciudadanos_t c
                 SET c.posible_duplicado = CASE WHEN C_EV.CUANTOS > 1 THEN 'X' ELSE NULL END
               WHERE c.id_nss = C_EV.ID_NSS;

              UPDATE suirplus.sre_ciudadanos_t c
                 SET c.posible_duplicado = CASE WHEN C_EV.CUANTOS > 1 THEN 'X' ELSE NULL END
               WHERE c.id_nss = v_id_nss;

              UPDATE suirplus.nss_det_evaluacion_visual_t d
                 SET d.id_accion_ev = 2 -- Actualizar el NSS
               WHERE d.id_det_evaluacion = C_EV.ID_DET_EVALUACION;
            END LOOP;
          END IF;

          -- Actualizar estatus solicitud a: NSS ASIGNADO
          SUIRPLUS.NSS_ACTUALIZAR_SOLICITUD(p_id_registro, 7, '0', v_id_nss, p_ult_usuario_act, p_resultado);

          IF p_resultado <> 'OK' THEN
            -- Grabar fin seguimiento en detalle de bitacora
            suirplus.detalle_bitacora(v_id_bitacora,
                                      sysdate,
                                      SUBSTR('Solicitud ASIGNACION NSS A CEDULADO, ID_SOLICITUD #'||to_char(V_ID_SOLICITUD)||', ID_REGISTRO #'||to_char(P_ID_REGISTRO)||': no pudo ser actualizada a estatus 7 ('||to_char(sysdate,'dd/mm/yyyy hh:mi:ss am')||').'||chr(13)||chr(10)||
                                      'MOTIVO: '||p_resultado,1,500));
          ELSE
            -- Grabar seguimiento en detalle de bitacora
            suirplus.detalle_bitacora(v_id_bitacora,
                                      sysdate,
                                      SUBSTR('Solicitud ASIGNACION NSS A CEDULADO, ID_SOLICITUD #'||to_char(V_ID_SOLICITUD)||', ID_REGISTRO #'||to_char(P_ID_REGISTRO)||': actualizada a estatus 7 ('||to_char(sysdate,'dd/mm/yyyy hh:mi:ss am')||').',1,500));
          END IF;
        END;
      END LOOP;
    WHEN v_id_tipo = 4 THEN -- TRABAJADORES EXTRANJEROS
      FOR C_SOL IN
        (
         SELECT D.*
           FROM suirplus.nss_det_solicitudes_t d
          WHERE d.id_registro = p_id_registro
            AND d.id_estatus = 4 -- En Evaluacion Visual
        )
      LOOP
        -- Para saber de donde vamos a tomar el ID_NSS
        IF NVL(p_sre_ciudadano.Id_Nss,0) = 0 THEN
          v_id_nss := C_SOL.ID_NSS;
        ELSE
          v_id_nss := p_sre_ciudadano.Id_Nss;
        END IF;

        -- Crear el registro en historico de documento
        INSERT INTO suirplus.sre_his_documentos_t
        (
         id,
         id_nss,
         id_tipo_documento,
         no_documento,
         fecha_emision,
         estatus,
         registrado_por,
         fecha_registro,
         ult_fecha_act,
         ult_usuario_act
        )
        SELECT
         suirplus.sre_his_documentos_t_seq.nextval,
         c.id_nss,
         c.tipo_documento,
         c.no_documento,
         SYSDATE,
         'A', --A=Activo
         p_ult_usuario_act,
         SYSDATE,
         SYSDATE,
         p_ult_usuario_act
        FROM suirplus.sre_ciudadanos_t c
       WHERE c.id_nss = v_id_nss;

        -- Actualizamos el ciudadano
        UPDATE suirplus.sre_ciudadanos_t
           SET no_documento      = '88'||LPAD(TO_CHAR(C_SOL.ID_NSS),9,'0'),
               nombres           = C_SOL.NOMBRES,
               primer_apellido   = C_SOL.PRIMER_APELLIDO,
               segundo_apellido  = C_SOL.SEGUNDO_APELLIDO,
               fecha_nacimiento  = C_SOL.FECHA_NACIMIENTO,
               sexo              = C_SOL.SEXO,
               id_nacionalidad   = C_SOL.ID_NACIONALIDAD,
               imagen_acta       = C_SOL.IMAGEN_SOLICITUD,
               ult_usuario_act   = p_ult_usuario_act,
               ult_fecha_act     = SYSDATE
         WHERE id_nss = v_id_nss;

        -- Actualizar maestro de extranjeros con el id_nss asignado
        UPDATE suirplus.Nss_Maestro_Extranjeros_t m
           SET m.id_nss = v_id_nss
         WHERE m.id_tipo_documento = C_SOL.ID_TIPO_DOCUMENTO
           AND m.id_expediente = C_SOL.NO_DOCUMENTO_SOL;

        -- Actualizar maestra evaluacion visual
        UPDATE suirplus.nss_evaluacion_visual_t e
           SET e.fecha_respuesta = SYSDATE,
               e.usuario_procesa = p_ult_usuario_act,
               e.estatus         = 'CO', -- Evaluacion Visual Completada
               e.ult_fecha_act   = SYSDATE,
               e.ult_usuario_act = p_ult_usuario_act
         WHERE e.id_registro = p_id_registro
        RETURNING ID_EVALUACION INTO v_id_evaluacion;

        -- Actualizar detalle evaluacion visual y ciudadanos marcarlo como "posible duplicado"
        FOR C_EV IN (SELECT E.ID_DET_EVALUACION, E.ID_NSS, 
                            (select count(*) 
                             from suirplus.Nss_Det_Evaluacion_Visual_t
                             WHERE id_evaluacion = v_id_evaluacion) CUANTOS
                       FROM suirplus.Nss_Det_Evaluacion_Visual_t e
                      WHERE e.id_evaluacion = v_id_evaluacion)
        LOOP
          UPDATE suirplus.sre_ciudadanos_t c
             SET c.posible_duplicado = CASE WHEN C_EV.CUANTOS > 1 THEN 'X' ELSE NULL END
           WHERE c.id_nss = C_EV.ID_NSS;

          UPDATE suirplus.sre_ciudadanos_t c
             SET c.posible_duplicado = CASE WHEN C_EV.CUANTOS > 1 THEN 'X' ELSE NULL END
           WHERE c.id_nss = v_id_nss;

          UPDATE suirplus.nss_det_evaluacion_visual_t d
             SET d.id_accion_ev = 2 -- Actualizar el NSS
           WHERE d.id_det_evaluacion = C_EV.ID_DET_EVALUACION;
        END LOOP;

        -- Actualizar estatus solicitud a: NSS ASIGNADO
        SUIRPLUS.NSS_ACTUALIZAR_SOLICITUD(C_SOL.ID_REGISTRO, 7, '0', v_id_nss, p_ult_usuario_act, p_resultado);

        IF p_resultado <> 'OK' THEN
          -- Grabar fin seguimiento en detalle de bitacora
          suirplus.detalle_bitacora(v_id_bitacora,
                                    sysdate,
                                    SUBSTR('Solicitud ASIGNACION NSS A TRABAJADOR EXTRANJERO, ID_SOLICITUD #'||to_char(V_ID_SOLICITUD)||', ID_REGISTRO #'||to_char(P_ID_REGISTRO)||': no pudo ser actualizada a estatus 7 ('||to_char(sysdate,'dd/mm/yyyy hh:mi:ss am')||').'||chr(13)||chr(10)||
                                    'MOTIVO: '||p_resultado,1,500));
        ELSE
          -- Grabar seguimiento en detalle de bitacora
          suirplus.detalle_bitacora(v_id_bitacora,
                                    sysdate,
                                    SUBSTR('Solicitud ASIGNACION NSS A TRABAJADOR EXTRANJERO, ID_SOLICITUD #'||to_char(V_ID_SOLICITUD)||', ID_REGISTRO #'||to_char(P_ID_REGISTRO)||': actualizada a estatus 7 ('||to_char(sysdate,'dd/mm/yyyy hh:mi:ss am')||').',1,500));
        END IF;
     END LOOP;
    WHEN v_id_tipo = 5 THEN -- MENOR DEPENDIENTES TRABAJADORES EXTRANJEROS
      DECLARE
        v_libro_acta suirplus.sre_ciudadanos_t.libro_acta%Type;
        v_literal_acta suirplus.sre_ciudadanos_t.literal_acta%Type;
      BEGIN
        FOR C_SOL IN
          (
           SELECT D.*
             FROM suirplus.nss_det_solicitudes_t d
            WHERE d.id_registro = p_id_registro
              AND d.id_estatus = 4 -- E Evaluacion Visual para extranjeros
          )
        LOOP
          -- Para saber de donde vamos a tomar el ID_NSS
          IF NVL(p_sre_ciudadano.Id_Nss,0) = 0 THEN
            v_id_nss := C_SOL.ID_NSS;
          ELSE
            v_id_nss := p_sre_ciudadano.Id_Nss;
          END IF;

          -- Crear el registro en historico de documento
          INSERT INTO suirplus.sre_his_documentos_t
          (
           id,
           id_nss,
           id_tipo_documento,
           no_documento,
           fecha_emision,
           estatus,
           registrado_por,
           fecha_registro,
           ult_fecha_act,
           ult_usuario_act
          )
          SELECT
           suirplus.sre_his_documentos_t_seq.nextval,
           c.id_nss,
           c.tipo_documento,
           c.no_documento,
           SYSDATE,
           'A', --A=Activo
           p_ult_usuario_act,
           SYSDATE,
           SYSDATE,
           p_ult_usuario_act
          FROM suirplus.sre_ciudadanos_t c
         WHERE c.id_nss = v_id_nss;

          --Actualiza los registro del ciudadano con los datos de la Evaluación Visual
          v_libro_acta := SUIRPLUS.NSS_VALIDACIONES_PKG.LIMPIAR_LIBRO_ACTA(C_SOL.LIBRO_ACTA, C_SOL.ANO_ACTA, v_literal_acta);

          update suirplus.sre_ciudadanos_t c
          set MUNICIPIO_ACTA   = SUIRPLUS.NSS_VALIDACIONES_PKG.LIMPIAR_MUNICIPIO_ACTA(C_SOL.MUNICIPIO_ACTA),
              ANO_ACTA         = SUIRPLUS.NSS_VALIDACIONES_PKG.LIMPIAR_ANO_ACTA(C_SOL.ANO_ACTA),
              NUMERO_ACTA      = SUIRPLUS.NSS_VALIDACIONES_PKG.LIMPIAR_NUMERO_ACTA(C_SOL.NUMERO_ACTA),
              FOLIO_ACTA       = SUIRPLUS.NSS_VALIDACIONES_PKG.LIMPIAR_FOLIO_ACTA(C_SOL.FOLIO_ACTA),
              LIBRO_ACTA       = v_libro_acta,
              OFICIALIA_ACTA   = SUIRPLUS.NSS_VALIDACIONES_PKG.LIMPIAR_OFICIALIA_ACTA(C_SOL.OFICIALIA_ACTA),
              NOMBRES          = Decode(C_SOL.NOMBRES,null,c.nombres,Trim(C_SOL.NOMBRES)),
              PRIMER_APELLIDO  = Decode(C_SOL.PRIMER_APELLIDO,null,c.primer_apellido,Trim(C_SOL.PRIMER_APELLIDO)),
              SEGUNDO_APELLIDO = Decode(C_SOL.SEGUNDO_APELLIDO,null,c.segundo_apellido,Trim(C_SOL.SEGUNDO_APELLIDO)),
              SEXO             = Decode(C_SOL.SEXO,null,c.sexo,C_SOL.sexo),
              IMAGEN_ACTA      = C_SOL.IMAGEN_SOLICITUD,
              FECHA_NACIMIENTO = TO_DATE(C_SOL.FECHA_NACIMIENTO,'dd/mm/yyyy'),
              ID_NACIONALIDAD  = C_SOL.ID_NACIONALIDAD,
              ULT_FECHA_ACT    = SYSDATE,           
              ULT_USUARIO_ACT  = p_ult_usuario_act,
              TIPO_DOCUMENTO   = CASE WHEN C_SOL.ID_TIPO_DOCUMENTO IN ('I','G','V') THEN 'E' ELSE C_SOL.ID_TIPO_DOCUMENTO END
          where id_nss = v_id_nss;

          -- Actualizar maestro de extranjeros con el id_nss asignado
          UPDATE suirplus.Nss_Maestro_Extranjeros_t m
             SET m.id_nss = v_id_nss
           WHERE m.id_tipo_documento = C_SOL.ID_TIPO_DOCUMENTO
             AND m.id_expediente = C_SOL.NO_DOCUMENTO_SOL;

          -- Actualizar maestra evaluacion visual
          UPDATE suirplus.nss_evaluacion_visual_t e
             SET e.fecha_respuesta = SYSDATE,
                 e.usuario_procesa = p_ult_usuario_act,
                 e.estatus         = 'CO', -- Evaluacion Visual Completada
                 e.ult_fecha_act   = SYSDATE,
                 e.ult_usuario_act = p_ult_usuario_act
           WHERE e.id_registro = p_id_registro
          RETURNING ID_EVALUACION INTO v_id_evaluacion;

          -- Actualizar detalle evaluacion visual y ciudadanos marcarlo como "posible duplicado"
          FOR C_EV IN (SELECT E.ID_DET_EVALUACION, E.ID_NSS, 
                              (select count(*) 
                               from suirplus.Nss_Det_Evaluacion_Visual_t
                               WHERE id_evaluacion = v_id_evaluacion) CUANTOS
                         FROM suirplus.Nss_Det_Evaluacion_Visual_t e
                        WHERE e.id_evaluacion = v_id_evaluacion)
          LOOP
            UPDATE suirplus.sre_ciudadanos_t c
               SET c.posible_duplicado = CASE WHEN C_EV.CUANTOS > 1 THEN 'X' ELSE NULL END
             WHERE c.id_nss = C_EV.ID_NSS;
             
            UPDATE suirplus.sre_ciudadanos_t c
               SET c.posible_duplicado = CASE WHEN C_EV.CUANTOS > 1 THEN 'X' ELSE NULL END
             WHERE c.id_nss = v_id_nss;

            UPDATE suirplus.nss_det_evaluacion_visual_t d
               SET d.id_accion_ev = 2 -- Actualizar el NSS
             WHERE d.id_det_evaluacion = C_EV.ID_DET_EVALUACION;
          END LOOP;

          -- Actualizar estatus solicitud a: NSS ASIGNADO
          SUIRPLUS.NSS_ACTUALIZAR_SOLICITUD(C_SOL.ID_REGISTRO, 7, 'NSS904', v_id_nss, p_ult_usuario_act, p_resultado);

          IF p_resultado <> 'OK' THEN
            -- Grabar fin seguimiento en detalle de bitacora
            suirplus.detalle_bitacora(v_id_bitacora,
                                      sysdate,
                                      SUBSTR('Solicitud ASIGNACION NSS A '||CASE v_id_tipo WHEN 1 THEN 'MENOR NACIONAL, ' WHEN 5 THEN 'MENOR EXTRANJERO, ' END||'ID_SOLICITUD #'||to_char(V_ID_SOLICITUD)||', ID_REGISTRO #'||to_char(P_ID_REGISTRO)||': no pudo ser actualizada a estatus 7 ('||to_char(sysdate,'dd/mm/yyyy hh:mi:ss am')||').'||chr(13)||chr(10)||
                                      'MOTIVO: '||p_resultado,1,500));
          ELSE
            -- Grabar seguimiento en detalle de bitacora
            suirplus.detalle_bitacora(v_id_bitacora,
                                      sysdate,
                                      SUBSTR('Solicitud ASIGNACION NSS A '||CASE v_id_tipo WHEN 1 THEN 'MENOR NACIONAL, ' WHEN 5 THEN 'MENOR EXTRANJERO, ' END||'ID_SOLICITUD #'||to_char(V_ID_SOLICITUD)||', ID_REGISTRO #'||to_char(P_ID_REGISTRO)||': actualizada a estatus 7 ('||to_char(sysdate,'dd/mm/yyyy hh:mi:ss am')||').',1,500));
          END IF;
        END LOOP;
      END;
  END CASE;

  -- Grabar fin seguimiento en detalle de bitacora
  suirplus.detalle_bitacora(v_id_bitacora, sysdate, 'PROCESO TERMINADO, a las '||to_char(sysdate,'dd/mm/yyyy hh:mi:ss am'));

  v_final := sysdate;

  v_mensaje := 'Inicio  : '||to_char(v_inicio,'dd/mm/yyyy hh:mi:ss am')||chr(13)||chr(10)||
               'Final   : '||to_char(v_final ,'dd/mm/yyyy hh:mi:ss am')||chr(13)||chr(10)||
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
  WHEN OTHERS THEN
    p_resultado := SQLERRM||' - '||sys.dbms_utility.format_error_backtrace;

    ROLLBACK; -- Devolvemos las transacciones pendientes de commits

    -- Para grabar mensaje a notificar
    suirplus.registrar_mensaje(v_id_proceso, 
                               SUBSTR('PROCESO TERMINADO CON ERROR: '||p_resultado||'. ID_SOLICITUD #'||to_char(V_ID_SOLICITUD)||', ID_REGISTRO #'||to_char(P_ID_REGISTRO), 1, 500),
                               'P',
                               v_resultado);

    -- Grabar fin seguimiento en detalle de bitacora
    suirplus.detalle_bitacora(v_id_bitacora,
                              sysdate,
                              SUBSTR('PROCESO TERMINADO CON ERROR: '||p_resultado||'. ID_SOLICITUD #'||to_char(V_ID_SOLICITUD)||', ID_REGISTRO #'||to_char(P_ID_REGISTRO), 1, 500));

    -- Para cerrar la bitacora
    suirplus.bitacora(v_id_bitacora,
                     'FIN',
                     v_ID_PROCESO,
                     substr(p_resultado, 1, 200),
                     'E',
                     '000');
END;
