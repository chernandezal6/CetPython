CREATE OR REPLACE PROCEDURE SUIRPLUS.NSS_INSERTAR_CIUDADANO
(
 p_id_registro in suirplus.nss_det_solicitudes_t.id_registro%Type,
 p_sre_ciudadano in suirplus.sre_ciudadanos_t%rowtype, 
 p_ult_usuario_act suirplus.seg_usuario_t.id_usuario%Type,
 p_resultado out varchar2
) IS
  v_id_tipo       suirplus.nss_tipo_solicitudes_t.id_tipo%type;
  v_id_nss        suirplus.sre_ciudadanos_t.id_nss%Type;
  v_id_evaluacion suirplus.nss_evaluacion_visual_t.id_evaluacion%Type;
  v_id_solicitud  suirplus.nss_solicitudes_t.id_solicitud%type;
  v_id_bitacora   suirplus.sfc_bitacora_t.id_bitacora%type;
  v_id_provincia  suirplus.Sre_Municipio_t.id_provincia%Type;
  v_id_proceso    suirplus.sfc_procesos_t.id_proceso%TYPE := '68'; -- Insertar CIUDADANO
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
        -- determinar la provincia del municipio del acta
        begin
          select a.id_provincia 
            into v_id_provincia
            from suirplus.sre_municipio_t a
           where a.id_municipio = C_SOL.MUNICIPIO_ACTA;
        exception when others then
          v_id_provincia := null;
        end;
          
        -- CREAMOS EL CIUDADANO
        INSERT INTO suirplus.sre_ciudadanos_t
        (
          NOMBRES,
          PRIMER_APELLIDO,
          SEGUNDO_APELLIDO,
          ESTADO_CIVIL,
          FECHA_NACIMIENTO,
          TIPO_DOCUMENTO,
          SEXO,
          ID_PROVINCIA,
          ID_NACIONALIDAD,
          FECHA_REGISTRO,
          MUNICIPIO_ACTA,
          ANO_ACTA,
          NUMERO_ACTA,
          FOLIO_ACTA,
          LIBRO_ACTA,
          OFICIALIA_ACTA,
          IMAGEN_ACTA,
          ULT_FECHA_ACT,
          ULT_USUARIO_ACT
        )
        VALUES
        (
         UPPER(C_SOL.NOMBRES),
         UPPER(C_SOL.PRIMER_APELLIDO),
         UPPER(C_SOL.SEGUNDO_APELLIDO),
         'S', --Estado civil
         C_SOL.FECHA_NACIMIENTO,
         'N', --Menor nacional sin documento
         UPPER(C_SOL.SEXO),
         v_id_provincia,
         C_SOL.ID_NACIONALIDAD,
         SYSDATE,
         SUIRPLUS.NSS_VALIDACIONES_PKG.LIMPIAR_MUNICIPIO_ACTA(C_SOL.MUNICIPIO_ACTA),
         SUIRPLUS.NSS_VALIDACIONES_PKG.LIMPIAR_ANO_ACTA(C_SOL.ANO_ACTA),
         SUIRPLUS.NSS_VALIDACIONES_PKG.LIMPIAR_NUMERO_ACTA(C_SOL.NUMERO_ACTA),
         SUIRPLUS.NSS_VALIDACIONES_PKG.LIMPIAR_FOLIO_ACTA(C_SOL.FOLIO_ACTA),
         SUIRPLUS.NSS_VALIDACIONES_PKG.LIMPIAR_LIBRO_ACTA(C_SOL.LIBRO_ACTA, C_SOL.ANO_ACTA),
         SUIRPLUS.NSS_VALIDACIONES_PKG.LIMPIAR_OFICIALIA_ACTA(C_SOL.OFICIALIA_ACTA),
         C_SOL.IMAGEN_SOLICITUD,
         SYSDATE,
         p_ult_usuario_act
        )
        RETURNING ID_NSS INTO v_id_nss;          

        -- Crear el registro en historico de documento
        INSERT INTO suirplus.sre_his_documentos_t
        (
         id, 
         id_nss, 
         id_tipo_documento, 
         no_documento, 
         fecha_emision, 
         estatus, 
         imagen_acta, 
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
         c.imagen_acta,
         p_ult_usuario_act,
         SYSDATE,
         SYSDATE,
         p_ult_usuario_act
        FROM suirplus.sre_ciudadanos_t c
       WHERE c.id_nss = v_id_nss;  
        
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
          FOR C_EV IN (SELECT E.ID_DET_EVALUACION, E.ID_NSS
                         FROM suirplus.Nss_Det_Evaluacion_Visual_t e
                        WHERE e.id_evaluacion = v_id_evaluacion) 
          LOOP
            UPDATE suirplus.sre_ciudadanos_t c
               SET c.posible_duplicado = 'X'
             WHERE c.id_nss = C_EV.ID_NSS;
               
            UPDATE suirplus.sre_ciudadanos_t c
               SET c.posible_duplicado = 'X'
             WHERE c.id_nss = v_id_nss;

            UPDATE suirplus.nss_det_evaluacion_visual_t d
               SET d.id_accion_ev = 1 -- Asignar el NSS
             WHERE d.id_det_evaluacion = C_EV.ID_DET_EVALUACION;
          END LOOP;   
        END IF;

        -- Actualizar estatus solicitud a: NSS ASIGNADO
        SUIRPLUS.NSS_ACTUALIZAR_SOLICITUD(C_SOL.ID_REGISTRO, 2, '0', v_id_nss, p_ult_usuario_act, p_resultado);

        IF p_resultado <> 'OK' THEN
          -- Grabar fin seguimiento en detalle de bitacora
          suirplus.detalle_bitacora(v_id_bitacora,
                                    sysdate,
                                    SUBSTR('Solicitud ASIGNACION NSS A MENOR NACIONAL, ID_SOLICITUD #'||to_char(V_ID_SOLICITUD)||', ID_REGISTRO #'||to_char(P_ID_REGISTRO)||': no pudo ser actualizada a estatus 2 ('||to_char(sysdate,'dd/mm/yyyy hh:mi:ss am')||').'||chr(13)||chr(10)||
                                    'MOTIVO: '||p_resultado,1,500));
        ELSE
          -- Grabar seguimiento en detalle de bitacora
          suirplus.detalle_bitacora(v_id_bitacora,
                                    sysdate,
                                    SUBSTR('Solicitud ASIGNACION NSS A MENOR NACIONAL, ID_SOLICITUD #'||to_char(V_ID_SOLICITUD)||', ID_REGISTRO #'||to_char(P_ID_REGISTRO)||': actualizada a estatus 2 ('||to_char(sysdate,'dd/mm/yyyy hh:mi:ss am')||').',1,500));
        END IF;
     END LOOP;
    WHEN v_id_tipo = 2 THEN -- MENORES CON NUI
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
        IF C_SOL.ID_ESTATUS = 1 THEN --Pendiente, tomo los datos del ciudadano desde el WEBSERVICE
          -- CREAMOS EL CIUDADANO
          INSERT INTO suirplus.sre_ciudadanos_t
          (
            TIPO_DOCUMENTO,
            NO_DOCUMENTO,
            NOMBRES,
            PRIMER_APELLIDO,
            SEGUNDO_APELLIDO,
            FECHA_NACIMIENTO,
            SEXO,
            MUNICIPIO_ACTA,
            ANO_ACTA,
            NUMERO_ACTA,
            FOLIO_ACTA,
            LIBRO_ACTA,
            OFICIALIA_ACTA,
            TIPO_LIBRO_ACTA,
            LITERAL_ACTA,
            ESTADO_CIVIL,
            ID_NACIONALIDAD,
            ID_PROVINCIA,
            CEDULA_MADRE,
            CEDULA_PADRE,
            NOMBRE_MADRE,
            NOMBRE_PADRE,
            ULT_FECHA_ACT,
            ULT_USUARIO_ACT,
            NUMERO_EVENTO
          )
          VALUES
          (
           p_sre_ciudadano.TIPO_DOCUMENTO,
           p_sre_ciudadano.NO_DOCUMENTO,
           p_sre_ciudadano.NOMBRES,
           p_sre_ciudadano.PRIMER_APELLIDO,
           p_sre_ciudadano.SEGUNDO_APELLIDO,
           p_sre_ciudadano.FECHA_NACIMIENTO,
           p_sre_ciudadano.SEXO,
           p_sre_ciudadano.MUNICIPIO_ACTA,
           p_sre_ciudadano.ANO_ACTA,
           p_sre_ciudadano.NUMERO_ACTA,
           p_sre_ciudadano.FOLIO_ACTA,
           p_sre_ciudadano.LIBRO_ACTA,
           p_sre_ciudadano.OFICIALIA_ACTA,
           p_sre_ciudadano.TIPO_LIBRO_ACTA,
           p_sre_ciudadano.LITERAL_ACTA,
           'S', --Estado civil
           p_sre_ciudadano.ID_NACIONALIDAD,
           p_sre_ciudadano.ID_PROVINCIA,
           p_sre_ciudadano.CEDULA_MADRE,
           p_sre_ciudadano.CEDULA_PADRE,
           p_sre_ciudadano.NOMBRE_MADRE,
           p_sre_ciudadano.NOMBRE_PADRE,
           SYSDATE,
           p_ult_usuario_act,
           p_sre_ciudadano.NUMERO_EVENTO
          )
          RETURNING ID_NSS INTO v_id_nss;          
        ELSIF C_SOL.ID_ESTATUS = 4 THEN --Evaluacion Visual, tomo los datos del ciudadano en el detalle de la solicitud
          -- CREAMOS EL CIUDADANO
          INSERT INTO suirplus.sre_ciudadanos_t
          (
            TIPO_DOCUMENTO,
            NO_DOCUMENTO,
            NOMBRES,
            PRIMER_APELLIDO,
            SEGUNDO_APELLIDO,
            FECHA_NACIMIENTO,
            SEXO,
            MUNICIPIO_ACTA,
            ANO_ACTA,
            NUMERO_ACTA,
            FOLIO_ACTA,
            LIBRO_ACTA,
            OFICIALIA_ACTA,
            TIPO_LIBRO_ACTA,
            LITERAL_ACTA,
            ESTADO_CIVIL,
            ID_NACIONALIDAD,
            CEDULA_MADRE,
            CEDULA_PADRE,
            NOMBRE_MADRE,
            NOMBRE_PADRE,
            ULT_FECHA_ACT,
            ULT_USUARIO_ACT,
            NUMERO_EVENTO
          )
          VALUES
          (
           C_SOL.ID_TIPO_DOCUMENTO,
           C_SOL.NO_DOCUMENTO_SOL,
           C_SOL.NOMBRES,
           C_SOL.PRIMER_APELLIDO,
           C_SOL.SEGUNDO_APELLIDO,
           C_SOL.FECHA_NACIMIENTO,
           C_SOL.SEXO,
           C_SOL.MUNICIPIO_ACTA,
           C_SOL.ANO_ACTA,
           C_SOL.NUMERO_ACTA,
           C_SOL.FOLIO_ACTA,
           C_SOL.LIBRO_ACTA,
           C_SOL.OFICIALIA_ACTA,
           C_SOL.TIPO_LIBRO_ACTA,
           C_SOL.LITERAL_ACTA,
           'S', --Estado civil
           C_SOL.ID_NACIONALIDAD,
           C_SOL.CEDULA_MADRE,
           C_SOL.CEDULA_PADRE,
           C_SOL.NOMBRE_MADRE,
           C_SOL.NOMBRE_PADRE,
           SYSDATE,
           p_ult_usuario_act,
           C_SOL.NUMERO_EVENTO
          ) RETURNING ID_NSS INTO v_id_nss;

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
          FOR C_EV IN (SELECT E.ID_DET_EVALUACION, E.ID_NSS
                         FROM suirplus.Nss_Det_Evaluacion_Visual_t e
                        WHERE e.id_evaluacion = v_id_evaluacion) 
          LOOP
            UPDATE suirplus.sre_ciudadanos_t c
               SET c.posible_duplicado = 'X'
             WHERE c.id_nss = C_EV.ID_NSS;
               
            UPDATE suirplus.sre_ciudadanos_t c
               SET c.posible_duplicado = 'X'
             WHERE c.id_nss = v_id_nss;

            UPDATE suirplus.nss_det_evaluacion_visual_t d
               SET d.id_accion_ev = 1 -- Asignar el NSS
             WHERE d.id_det_evaluacion = C_EV.ID_DET_EVALUACION;
          END LOOP;   
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
         v_id_nss,
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

        -- Actualizar estatus solicitud a: NSS ASIGNADO
        SUIRPLUS.NSS_ACTUALIZAR_SOLICITUD(p_id_registro, 2, '0', v_id_nss, p_ult_usuario_act, p_resultado);

        IF p_resultado <> 'OK' THEN
          -- Grabar fin seguimiento en detalle de bitacora
          suirplus.detalle_bitacora(v_id_bitacora,
                                    sysdate,
                                    SUBSTR('Solicitud ASIGNACION NSS A MENOR CON NUI, ID_SOLICITUD #'||to_char(V_ID_SOLICITUD)||', ID_REGISTRO #'||to_char(P_ID_REGISTRO)||': no pudo ser actualizada a estatus 2 ('||to_char(sysdate,'dd/mm/yyyy hh:mi:ss am')||').'||chr(13)||chr(10)||
                                    'MOTIVO: '||p_resultado,1,500));
        ELSE
          -- Grabar seguimiento en detalle de bitacora
          suirplus.detalle_bitacora(v_id_bitacora,
                                    sysdate,
                                    SUBSTR('Solicitud ASIGNACION NSS A MENOR CON NUI, ID_SOLICITUD #'||to_char(V_ID_SOLICITUD)||', ID_REGISTRO #'||to_char(P_ID_REGISTRO)||': actualizada a estatus 2 ('||to_char(sysdate,'dd/mm/yyyy hh:mi:ss am')||').',1,500));
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
        IF C_SOL.ID_ESTATUS = 1 THEN --Pendiente, tomo los datos del ciudadano desde el WEBSERVICE
          -- CREAMOS EL CIUDADANO
          INSERT INTO suirplus.sre_ciudadanos_t
          (
            TIPO_DOCUMENTO,
            NO_DOCUMENTO,
            NOMBRES,
            PRIMER_APELLIDO,
            SEGUNDO_APELLIDO,
            FECHA_NACIMIENTO,
            ID_PROVINCIA,
            SEXO,
            MUNICIPIO_ACTA,
            OFICIALIA_ACTA,
            ANO_ACTA,
            TIPO_LIBRO_ACTA,
            LIBRO_ACTA,
            ID_TIPO_SANGRE,
            FOLIO_ACTA,
            NUMERO_ACTA,
            NOMBRE_PADRE,
            NOMBRE_MADRE,
            ESTADO_CIVIL,
            ID_NACIONALIDAD,
            CEDULA_MADRE,
            CEDULA_PADRE,
            TIPO_CAUSA,
            ID_CAUSA_INHABILIDAD,
            FECHA_CANCELACION_JCE,
            FECHA_CANCELACION_TSS,
            FECHA_FALLECIMIENTO,
            STATUS,
            ULT_USUARIO_ACT,
            ULT_FECHA_ACT,
            NUMERO_EVENTO
          ) 
          VALUES
          (
            p_sre_ciudadano.TIPO_DOCUMENTO,
            p_sre_ciudadano.NO_DOCUMENTO,
            p_sre_ciudadano.NOMBRES,
            p_sre_ciudadano.PRIMER_APELLIDO,
            p_sre_ciudadano.SEGUNDO_APELLIDO,
            p_sre_ciudadano.FECHA_NACIMIENTO,
            p_sre_ciudadano.ID_PROVINCIA,
            p_sre_ciudadano.SEXO,
            p_sre_ciudadano.MUNICIPIO_ACTA,
            p_sre_ciudadano.OFICIALIA_ACTA,
            p_sre_ciudadano.ANO_ACTA,
            p_sre_ciudadano.TIPO_LIBRO_ACTA,
            p_sre_ciudadano.LIBRO_ACTA,
            p_sre_ciudadano.ID_TIPO_SANGRE,
            p_sre_ciudadano.FOLIO_ACTA,
            p_sre_ciudadano.NUMERO_ACTA,
            p_sre_ciudadano.NOMBRE_PADRE,
            p_sre_ciudadano.NOMBRE_MADRE,
            p_sre_ciudadano.ESTADO_CIVIL,
            p_sre_ciudadano.ID_NACIONALIDAD,
            p_sre_ciudadano.CEDULA_MADRE,
            p_sre_ciudadano.CEDULA_PADRE,
            p_sre_ciudadano.TIPO_CAUSA,
            p_sre_ciudadano.ID_CAUSA_INHABILIDAD,
            p_sre_ciudadano.FECHA_CANCELACION_JCE,
            SYSDATE, --el dia que nos enteramos del evento
            p_sre_ciudadano.FECHA_CANCELACION_JCE,
            p_sre_ciudadano.STATUS,
            p_ult_usuario_act,            
            SYSDATE,
            p_sre_ciudadano.NUMERO_EVENTO
            
          ) RETURNING ID_NSS INTO v_id_nss;          
        ELSIF C_SOL.ID_ESTATUS = 4 THEN --Evaluacion Visual, tomo los datos del ciudadano en el detalle de la solicitud
          INSERT INTO suirplus.sre_ciudadanos_t
          (
            TIPO_DOCUMENTO,
            NO_DOCUMENTO,
            NOMBRES,
            PRIMER_APELLIDO,
            SEGUNDO_APELLIDO,
            FECHA_NACIMIENTO,
            SEXO,
            MUNICIPIO_ACTA,
            OFICIALIA_ACTA,
            ANO_ACTA,
            TIPO_LIBRO_ACTA,
            LIBRO_ACTA,
            ID_TIPO_SANGRE,
            FOLIO_ACTA,
            NUMERO_ACTA,
            NOMBRE_PADRE,
            NOMBRE_MADRE,
            ESTADO_CIVIL,
            ID_NACIONALIDAD,
            CEDULA_MADRE,
            CEDULA_PADRE,
            TIPO_CAUSA,
            ID_CAUSA_INHABILIDAD,
            FECHA_CANCELACION_JCE,
            FECHA_CANCELACION_TSS,
            FECHA_FALLECIMIENTO,
            STATUS,
            ULT_USUARIO_ACT,
            ULT_FECHA_ACT,
            NUMERO_EVENTO
          ) 
          VALUES
          (
            C_SOL.ID_TIPO_DOCUMENTO,
            C_SOL.NO_DOCUMENTO_SOL,
            C_SOL.NOMBRES,
            C_SOL.PRIMER_APELLIDO,
            C_SOL.SEGUNDO_APELLIDO,
            C_SOL.FECHA_NACIMIENTO,
            C_SOL.SEXO,
            C_SOL.MUNICIPIO_ACTA,
            C_SOL.OFICIALIA_ACTA,
            C_SOL.ANO_ACTA,
            C_SOL.TIPO_LIBRO_ACTA,
            C_SOL.LIBRO_ACTA,
            C_SOL.ID_TIPO_SANGRE,
            C_SOL.FOLIO_ACTA,
            C_SOL.NUMERO_ACTA,
            C_SOL.NOMBRE_PADRE,
            C_SOL.NOMBRE_MADRE,
            C_SOL.ESTADO_CIVIL,
            C_SOL.ID_NACIONALIDAD,
            C_SOL.CEDULA_MADRE,
            C_SOL.CEDULA_PADRE,
            C_SOL.TIPO_CAUSA,
            C_SOL.ID_CAUSA_INHABILIDAD,
            C_SOL.FECHA_CANCELACION_JCE,
            SYSDATE, --el dia que nos enteramos del evento,
            C_SOL.FECHA_CANCELACION_JCE,
            C_SOL.ESTATUS_JCE,
            p_ult_usuario_act,
            SYSDATE,
            C_SOL.NUMERO_EVENTO
          ) RETURNING ID_NSS INTO v_id_nss;

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
          FOR C_EV IN (SELECT E.ID_DET_EVALUACION, E.ID_NSS
                         FROM suirplus.Nss_Det_Evaluacion_Visual_t e
                        WHERE e.id_evaluacion = v_id_evaluacion) 
          LOOP
            UPDATE suirplus.sre_ciudadanos_t c
               SET c.posible_duplicado = 'X'
             WHERE c.id_nss = C_EV.ID_NSS;

            UPDATE suirplus.sre_ciudadanos_t c
               SET c.posible_duplicado = 'X'
             WHERE c.id_nss = v_id_nss;
               
            UPDATE suirplus.nss_det_evaluacion_visual_t d
               SET d.id_accion_ev = 1 -- Asignar el NSS
             WHERE d.id_det_evaluacion = C_EV.ID_DET_EVALUACION;
          END LOOP;   
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
         v_id_nss,
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
       
        -- Actualizar estatus solicitud a: NSS ASIGNADO
        SUIRPLUS.NSS_ACTUALIZAR_SOLICITUD(p_id_registro, 2, '0', v_id_nss, p_ult_usuario_act, p_resultado);

        IF p_resultado <> 'OK' THEN
          -- Grabar fin seguimiento en detalle de bitacora
          suirplus.detalle_bitacora(v_id_bitacora,
                                    sysdate,
                                    SUBSTR('Solicitud ASIGNACION NSS A CEDULADO, ID_SOLICITUD #'||to_char(V_ID_SOLICITUD)||', ID_REGISTRO #'||to_char(P_ID_REGISTRO)||': no pudo ser actualizada a estatus 2 ('||to_char(sysdate,'dd/mm/yyyy hh:mi:ss am')||').'||chr(13)||chr(10)||
                                    'MOTIVO: '||p_resultado,1,500));
        ELSE
          -- Grabar seguimiento en detalle de bitacora
          suirplus.detalle_bitacora(v_id_bitacora,
                                    sysdate,
                                    SUBSTR('Solicitud ASIGNACION NSS A CEDULADO, ID_SOLICITUD #'||to_char(V_ID_SOLICITUD)||', ID_REGISTRO #'||to_char(P_ID_REGISTRO)||': actualizada a estatus 2 ('||to_char(sysdate,'dd/mm/yyyy hh:mi:ss am')||').',1,500));
        END IF;
      END LOOP;  
    WHEN v_id_tipo = 4 THEN -- TRABAJADORES EXTRANJEROS      
      FOR C_SOL IN
        (
         SELECT ID_REGISTRO,
                UPPER(d.nombres) nombres,
                UPPER(d.primer_apellido) primer_apellido,
                UPPER(d.segundo_apellido) segundo_apellido,
                TRUNC(d.fecha_nacimiento) fecha_nacimiento,
                UPPER(d.sexo) sexo,
                d.id_nacionalidad,
                d.imagen_solicitud,
                d.id_tipo_documento,
                'S' estado_civil,
                d.no_documento_sol,
                SYSDATE ult_fecha_act,
                p_ult_usuario_act ult_usuario_act
           FROM suirplus.nss_det_solicitudes_t d
           LEFT JOIN suirplus.nss_maestro_extranjeros_t m
             ON m.id_expediente = d.no_documento_sol
          WHERE d.id_registro = p_id_registro
            AND d.id_estatus = 4 -- En Evaluacion Visual 
        )
      LOOP
        -- Creamos el ciudadano
        INSERT INTO suirplus.sre_ciudadanos_t
        (
         nombres,
         primer_apellido,
         segundo_apellido,
         fecha_nacimiento,
         sexo,
         id_nacionalidad,
         imagen_acta,
         tipo_documento,
         estado_civil,
         ult_usuario_act,
         ult_fecha_act
        )
        VALUES
        (
         C_SOL.NOMBRES,
         C_SOL.PRIMER_APELLIDO,
         C_SOL.SEGUNDO_APELLIDO,
         C_SOL.FECHA_NACIMIENTO,
         C_SOL.SEXO,
         C_SOL.ID_NACIONALIDAD,
         C_SOL.IMAGEN_SOLICITUD,
         'C',
         C_SOL.ESTADO_CIVIL,
         C_SOL.ULT_USUARIO_ACT,
         C_SOL.ULT_FECHA_ACT
        )
        RETURNING ID_NSS INTO v_id_nss;
        
        -- Actualizar nro documento en ciudadanos con 88+id_nss
        UPDATE suirplus.sre_ciudadanos_t c
           SET c.no_documento = '88'||LPAD(TO_CHAR(C.ID_NSS),9,'0')
         WHERE c.id_nss = v_id_nss;
        
        -- Actualizar maestro de extranjeros con el id_nss asignado
        UPDATE suirplus.Nss_Maestro_Extranjeros_t m
           SET m.id_nss = v_id_nss
         WHERE m.id_tipo_documento = C_SOL.ID_TIPO_DOCUMENTO
           AND m.id_expediente = C_SOL.NO_DOCUMENTO_SOL;

        -- Crear el registro en historico de documento
        INSERT INTO suirplus.sre_his_documentos_t
        (
         id, 
         id_nss, 
         id_tipo_documento, 
         no_documento, 
         fecha_emision, 
         estatus, 
         imagen_acta, 
         registrado_por, 
         fecha_registro, 
         ult_fecha_act, 
         ult_usuario_act
        )
        SELECT 
         suirplus.sre_his_documentos_t_seq.nextval,
         v_id_nss,
         c.tipo_documento,
         c.no_documento,
         SYSDATE,
         'A', --A=Activo
         c.imagen_acta,
         p_ult_usuario_act,
         SYSDATE,
         SYSDATE,
         p_ult_usuario_act
        FROM suirplus.sre_ciudadanos_t c
       WHERE c.id_nss = v_id_nss;  
        
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
        FOR C_EV IN (SELECT E.ID_DET_EVALUACION, E.ID_NSS
                       FROM suirplus.Nss_Det_Evaluacion_Visual_t e
                      WHERE e.id_evaluacion = v_id_evaluacion)
        LOOP
          UPDATE suirplus.sre_ciudadanos_t c
             SET c.posible_duplicado = 'X'
           WHERE c.id_nss = C_EV.ID_NSS; 

          UPDATE suirplus.sre_ciudadanos_t c
             SET c.posible_duplicado = 'X'
           WHERE c.id_nss = v_id_nss; --El que se acaba de crear

          UPDATE suirplus.nss_det_evaluacion_visual_t d
             SET d.id_accion_ev = 1 -- Asignar el NSS
           WHERE d.id_det_evaluacion = C_EV.ID_DET_EVALUACION;
        END LOOP;

        -- Actualizar estatus solicitud a: NSS ASIGNADO
        SUIRPLUS.NSS_ACTUALIZAR_SOLICITUD(C_SOL.ID_REGISTRO, 2, '0', v_id_nss, p_ult_usuario_act, p_resultado);

        IF p_resultado <> 'OK' THEN
          -- Grabar fin seguimiento en detalle de bitacora
          suirplus.detalle_bitacora(v_id_bitacora,
                                    sysdate,
                                    SUBSTR('Solicitud ASIGNACION NSS TRABAJADORES EXTRANJEROS, ID_SOLICITUD #'||to_char(V_ID_SOLICITUD)||', ID_REGISTRO #'||to_char(P_ID_REGISTRO)||': no pudo ser actualizada a estaus 2 ('||to_char(sysdate,'dd/mm/yyyy hh:mi:ss am')||').'||chr(13)||chr(10)||
                                    'MOTIVO: '||p_resultado,1,500));
        ELSE
          -- Grabar seguimiento en detalle de bitacora
          suirplus.detalle_bitacora(v_id_bitacora,
                                    sysdate,
                                    SUBSTR('Solicitud ASIGNACION NSS TRABAJADORES EXTRANJEROS, ID_SOLICITUD #'||to_char(V_ID_SOLICITUD)||', ID_REGISTRO #'||to_char(P_ID_REGISTRO)||': actualizada a estatus 2 ('||to_char(sysdate,'dd/mm/yyyy hh:mi:ss am')||').',1,500));
        END IF;
     END LOOP;
    WHEN v_id_tipo = 5 THEN -- MENOR DEPENDIENTES TRABAJADORES EXTRANJEROS           
      FOR C_SOL IN
        (
         SELECT D.*, S.ID_TIPO
           FROM suirplus.nss_det_solicitudes_t d
           JOIN suirplus.nss_solicitudes_t s
             ON s.id_solicitud = d.id_solicitud
          WHERE d.id_registro = p_id_registro
            AND d.id_estatus = 4 -- en evaluacion visual para extranjeros
        )
      LOOP
        -- Creamos el ciudadano como menor extranjero
        INSERT INTO suirplus.sre_ciudadanos_t
        (
         nombres,
         primer_apellido,
         segundo_apellido,
         fecha_nacimiento,
         sexo,
         id_nacionalidad,
         imagen_acta,
         tipo_documento,
         estado_civil,
         ult_usuario_act,
         ult_fecha_act
        )
        VALUES
        (
         UPPER(C_SOL.NOMBRES),
         UPPER(C_SOL.PRIMER_APELLIDO),
         UPPER(C_SOL.SEGUNDO_APELLIDO),
         trunc(C_SOL.FECHA_NACIMIENTO),
         UPPER(C_SOL.SEXO),
         C_SOL.ID_NACIONALIDAD,
         C_SOL.IMAGEN_SOLICITUD,
         'E', -- Dependiente Trabajador Extranjero
         'S', --Estado civil
         C_SOL.ULT_USUARIO_ACT,
         C_SOL.ULT_FECHA_ACT
        )
        RETURNING ID_NSS INTO v_id_nss;

        -- Actualizar maestro de extranjeros con el id_nss asignado
        UPDATE suirplus.Nss_Maestro_Extranjeros_t m
           SET m.id_nss = v_id_nss
         WHERE m.id_tipo_documento = C_SOL.ID_TIPO_DOCUMENTO
           AND m.id_expediente = C_SOL.NO_DOCUMENTO_SOL;

        -- Crear el registro en historico de documento
        INSERT INTO suirplus.sre_his_documentos_t
        (
         id, 
         id_nss, 
         id_tipo_documento, 
         no_documento, 
         fecha_emision, 
         estatus, 
         imagen_acta, 
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
         c.imagen_acta,
         p_ult_usuario_act,
         SYSDATE,
         SYSDATE,
         p_ult_usuario_act
        FROM suirplus.sre_ciudadanos_t c
       WHERE c.id_nss = v_id_nss;  
        
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
        FOR C_EV IN (SELECT E.ID_DET_EVALUACION, E.ID_NSS
                       FROM suirplus.Nss_Det_Evaluacion_Visual_t e
                      WHERE e.id_evaluacion = v_id_evaluacion)
        LOOP
          UPDATE suirplus.sre_ciudadanos_t c
             SET c.posible_duplicado = 'X'
           WHERE c.id_nss = C_EV.ID_NSS;

          UPDATE suirplus.sre_ciudadanos_t c
             SET c.posible_duplicado = 'X'
           WHERE c.id_nss = v_id_nss; --el que se acaba de crear

          UPDATE suirplus.nss_det_evaluacion_visual_t d
             SET d.id_accion_ev = 1 -- Asignar el NSS
           WHERE d.id_det_evaluacion = C_EV.ID_DET_EVALUACION;
        END LOOP;

        -- Actualizar estatus solicitud a: NSS ASIGNADO
        SUIRPLUS.NSS_ACTUALIZAR_SOLICITUD(C_SOL.ID_REGISTRO, 2, '0', v_id_nss, p_ult_usuario_act, p_resultado);

        IF p_resultado <> 'OK' THEN
          -- Grabar fin seguimiento en detalle de bitacora
          suirplus.detalle_bitacora(v_id_bitacora,
                                    sysdate,
                                    SUBSTR('Solicitud ASIGNACION NSS A MENOR EXTRANJERO, ID_SOLICITUD #'||to_char(V_ID_SOLICITUD)||', ID_REGISTRO #'||to_char(P_ID_REGISTRO)||': no pudo ser actualizada a estatus 2 ('||to_char(sysdate,'dd/mm/yyyy hh:mi:ss am')||').'||chr(13)||chr(10)||
                                    'MOTIVO: '||p_resultado,1,500));
        ELSE
          -- Grabar seguimiento en detalle de bitacora
          suirplus.detalle_bitacora(v_id_bitacora,
                                    sysdate,
                                    SUBSTR('Solicitud ASIGNACION NSS A MENOR EXTRANJERO, ID_SOLICITUD #'||to_char(V_ID_SOLICITUD)||', ID_REGISTRO #'||to_char(P_ID_REGISTRO)||': actualizada a estatus 2 ('||to_char(sysdate,'dd/mm/yyyy hh:mi:ss am')||').',1,500));
        END IF;
      END LOOP;      
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
