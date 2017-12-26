CREATE OR REPLACE PROCEDURE SUIRPLUS.NSS_VALIDAR_SOL_MENORES_EXT
(
 p_id_solicitud in suirplus.nss_solicitudes_t.id_solicitud%type,
 p_ult_usuario_act in suirplus.seg_usuario_t.id_usuario%type,
 p_resultado out varchar2
) IS
  v_id_bitacora      suirplus.sfc_bitacora_t.id_bitacora%type;
  v_id_proceso       suirplus.sfc_procesos_t.id_proceso%TYPE := '77'; --EVALUAR SOLICITUD NSS A MENORES EXTRANJEROS
  v_id_error         suirplus.seg_error_t.id_error%type;
  v_estatus          suirplus.nss_estatus_t.id_estatus%type;
  v_nss_dup          suirplus.sre_ciudadanos_t.id_nss%Type;
  v_id_nss           suirplus.sre_ciudadanos_t.id_nss%type;   
  v_id_evaluacion    suirplus.nss_evaluacion_visual_t.id_evaluacion%Type;    
  v_id_registro      suirplus.nss_det_solicitudes_t.id_registro%type;
  
  v_inicio           date := sysdate;
  v_final            date;
  v_conteo           pls_integer;
  v_mensaje          varchar2(500);
  v_resultado        varchar2(200);

  e_usuario_no_existe    EXCEPTION;
  e_solicitud_no_existe  EXCEPTION;
  e_estatus_sol_invalido EXCEPTION;    
  e_tipo_sol_invalido    EXCEPTION;
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
  Select count(*)
    Into v_conteo
    From suirplus.nss_solicitudes_t s
   Where s.id_solicitud = p_id_solicitud;

  IF v_conteo = 0 THEN
    RAISE e_solicitud_no_existe;
  END IF;

  --Ver si el estatus de la solicitud es 1 = 'Pendiente'
  Select count(*)
    Into v_conteo
    From suirplus.nss_solicitudes_t s
    Join suirplus.nss_det_solicitudes_t d
      On d.id_solicitud = s.id_solicitud
     And d.id_estatus = 1 -- Pendiente 
   Where s.id_solicitud = p_id_solicitud;

  IF v_conteo = 0 THEN
    RAISE e_estatus_sol_invalido;
  END IF;

  --Si no existe la solicitud con el tipo adecuado, si no existe termina la ejecucion
  Select count(*)
    Into v_conteo
    From suirplus.nss_solicitudes_t s
   Where s.id_solicitud = p_id_solicitud
     And s.id_tipo = 5; --Solicitud de NSS A MENORES SIN DOCUMENTOS EXTRANJEROS

  IF v_conteo = 0 THEN
    RAISE e_tipo_sol_invalido;
  END IF;

  -- Ver si existe el usuario, si no existe termina la ejecucion
  Select count(*)
    Into v_conteo
    From suirplus.seg_usuario_t t
   Where t.id_usuario = upper(p_ult_usuario_act);

  If v_conteo = 0 Then
    RAISE e_usuario_no_existe;
  End if;

  -- Grabar primer seguimiento en detalle de bitacora
  suirplus.detalle_bitacora(v_id_bitacora, sysdate,SUBSTR('Inicio del PROCESO '||v_id_proceso||' a las '||to_char(sysdate,'dd/mm/yyyy hh:mi:ss am')||chr(13)||chr(10)||
                                                    'PARAMETROS: p_id_solicitud = '||TO_CHAR(p_id_solicitud)||
                                                    ', p_ult_usuario_act = '||p_ult_usuario_act,1,500));

  -- Ver si existen solicitudes de asignacion nns a menores en evaluacion visual
  -- Si existe rechazarla todas y dejar solo la que estoy procesando
  FOR C_SOL IN
    (
     Select d.*, t.validacion_mayoria_edad
       From suirplus.nss_solicitudes_t s
       Join suirplus.nss_det_solicitudes_t d
         On d.id_solicitud = s.id_solicitud
       Join suirplus.sre_tipo_documentos_t t
         On t.id_tipo_documento = d.id_tipo_documento  
        And d.id_estatus = 1 -- Pendiente de procesar en detalle de solicitud
      Where s.id_solicitud = p_id_solicitud
      Order by d.id_registro DESC
    )
  LOOP
    BEGIN
      --Para retener el id_registro actual para reportarlo en el when other del exception
      v_id_registro := C_SOL.ID_REGISTRO;
      
      Select count(*)
        Into v_conteo
        From suirplus.nss_solicitudes_t s
        Join suirplus.nss_det_solicitudes_t d
          On d.id_solicitud = s.id_solicitud
         And d.id_estatus IN(1,4) -- Pendiente de procesar o enviado a evaluacion visual en detalle de solicitud
         And suirplus.Nss_Validaciones_Pkg.primer_nombre(d.Nombres) = suirplus.Nss_Validaciones_Pkg.primer_nombre(C_SOL.NOMBRES)
         And TRIM(d.primer_apellido) = TRIM(C_SOL.PRIMER_APELLIDO)
         And d.Fecha_Nacimiento = C_SOL.FECHA_NACIMIENTO
         And TRIM(d.Sexo) = TRIM(C_SOL.SEXO)
         And TRIM(d.id_nacionalidad) = TRIM(C_SOL.ID_NACIONALIDAD)
         And d.id_registro < C_SOL.ID_REGISTRO -- Diferente al regitro del cursor
       Where s.id_tipo = 5; --Solicitud de NSS A MENORES SIN DOCUMENTOS EXTRANJEROS
         
      IF v_conteo >= 1 THEN
        v_id_error := 'NSS403';
        v_estatus  := 6;
      END IF;
      
      --Buscar en la maestra de extranjera
      Select count(*), nvl(min(id_nss),0) id_nss
        Into v_conteo, v_id_nss
        From suirplus.nss_maestro_extranjeros_t m
       Where m.id_tipo_documento = C_SOL.ID_TIPO_DOCUMENTO
         And m.id_expediente = C_SOL.NO_DOCUMENTO_SOL;

      IF v_conteo = 0 THEN
        IF UPPER(C_SOL.ID_TIPO_DOCUMENTO) = 'I' THEN -- Documento emitido por el MIP
          -- Rechazamos la solicitud
          SUIRPLUS.NSS_ACTUALIZAR_SOLICITUD(C_SOL.ID_REGISTRO, 6, 'NSS402', NULL, p_ult_usuario_act, p_resultado); --Numero de documento invalido

          IF p_resultado <> 'OK' THEN
            ROLLBACK;
            -- Grabar fin seguimiento en detalle de bitacora
            suirplus.detalle_bitacora(v_id_bitacora,
                                      sysdate,
                                      SUBSTR('Solicitud ASIGNACION NSS A DEPENDIENTE TRABAJADOR EXTRANJERO, ID_SOLICITUD #'||to_char(P_ID_SOLICITUD)||', ID_REGISTRO #'||to_char(C_SOL.ID_REGISTRO)||' ignorada ('||to_char(sysdate,'dd/mm/yyyy hh:mi:ss am')||').'||chr(13)||chr(10)||
                                      'MOTIVO: '||p_resultado,1,500));
          ELSE
            -- Grabar primer seguimiento en detalle de bitacora
            suirplus.detalle_bitacora(v_id_bitacora,
                        sysdate,
                        SUBSTR('Solicitud ASIGNACION NSS A DEPENDIENTE TRABAJADOR EXTRANJERO, ID_SOLICITUD #'||to_char(P_ID_SOLICITUD)||', ID_REGISTRO #'||to_char(C_SOL.ID_REGISTRO)||' rechazada ('||to_char(sysdate,'dd/mm/yyyy hh:mi:ss am')||').'||chr(13)||chr(10)||
                        'MOTIVO: '||Suirplus.Seg_Retornar_Cadena_Error('NSS406', NULL, NULL),1,500));
          END IF;

          CONTINUE; --Pasamos al proximo registro
        END IF;  

        -- Ver si se le ha dado respuesta a este tipo documento y documento anteriormente
        Select count(*), nvl(min(id_nss),0) id_nss
          Into v_conteo, v_id_nss
          From suirplus.nss_det_solicitudes_t d
         Where d.id_tipo_documento = C_SOL.ID_TIPO_DOCUMENTO
           And d.no_documento_sol = C_SOL.NO_DOCUMENTO_SOL
           And d.id_estatus IN(2, 3, 7);          
        
        If v_conteo > 0 Then
          -- Rechazamos la solicitud
          SUIRPLUS.NSS_ACTUALIZAR_SOLICITUD(C_SOL.ID_REGISTRO, 6, 'NSS001', v_id_nss, p_ult_usuario_act, p_resultado); --Numero de documento invalido

          IF p_resultado <> 'OK' THEN
            ROLLBACK;
            -- Grabar fin seguimiento en detalle de bitacora
            suirplus.detalle_bitacora(v_id_bitacora,
                                      sysdate,
                                      SUBSTR('Solicitud ASIGNACION NSS A DEPENDIENTE TRABAJADOR EXTRANJERO, ID_SOLICITUD #'||to_char(P_ID_SOLICITUD)||', ID_REGISTRO #'||to_char(C_SOL.ID_REGISTRO)||' ignorada ('||to_char(sysdate,'dd/mm/yyyy hh:mi:ss am')||').'||chr(13)||chr(10)||
                                      'MOTIVO: '||p_resultado,1,500));
          ELSE
            -- Grabar primer seguimiento en detalle de bitacora
            suirplus.detalle_bitacora(v_id_bitacora,
                        sysdate,
                        SUBSTR('Solicitud ASIGNACION NSS A DEPENDIENTE TRABAJADOR EXTRANJERO, ID_SOLICITUD #'||to_char(P_ID_SOLICITUD)||', ID_REGISTRO #'||to_char(C_SOL.ID_REGISTRO)||' rechazada ('||to_char(sysdate,'dd/mm/yyyy hh:mi:ss am')||').'||chr(13)||chr(10)||
                        'MOTIVO: '||Suirplus.Seg_Retornar_Cadena_Error('NSS001', NULL, NULL),1,500));
          END IF;

          CONTINUE; --Pasamos al proximo registro
        END IF;  
      ELSE
        -- si tiene en la maestra de extranjero un NSS asignado, rechazamos la solicitud y devolvemos el nss asignado
        IF v_id_nss > 0 THEN
          -- Rechazamos la solicitud
          SUIRPLUS.NSS_ACTUALIZAR_SOLICITUD(C_SOL.ID_REGISTRO, 6, 'NSS001', v_id_nss, p_ult_usuario_act, p_resultado); --Este nro de expediente ya tiene un NSS asignado

          IF p_resultado <> 'OK' THEN
            ROLLBACK;
            -- Grabar fin seguimiento en detalle de bitacora
            suirplus.detalle_bitacora(v_id_bitacora,
                                      sysdate,
                                      SUBSTR('Solicitud ASIGNACION NSS A DEPENDIENTE TRABAJADOR EXTRANJERO, ID_SOLICITUD #'||to_char(P_ID_SOLICITUD)||', ID_REGISTRO #'||to_char(C_SOL.ID_REGISTRO)||' no pudo ser cambiada de estatus ('||to_char(sysdate,'dd/mm/yyyy hh:mi:ss am')||').'||chr(13)||chr(10)||
                                      'MOTIVO: '||p_resultado,1,500));
          ELSE
            -- Grabar primer seguimiento en detalle de bitacora
            suirplus.detalle_bitacora(v_id_bitacora,
                                      sysdate,
                                      SUBSTR('Solicitud ASIGNACION NSS A DEPENDIENTE TRABAJADOR EXTRANJERO, ID_SOLICITUD #'||to_char(P_ID_SOLICITUD)||', ID_REGISTRO #'||to_char(C_SOL.ID_REGISTRO)||' rechazada ('||to_char(sysdate,'dd/mm/yyyy hh:mi:ss am')||').'||chr(13)||chr(10)||
                                      'MOTIVO: '||Suirplus.Seg_Retornar_Cadena_Error('NSS001', NULL, NULL),1,500));
          END IF;

          CONTINUE; --Pasamos al proximo registro
        END IF;
      END IF;    
      
      -- Documento invalido
      If v_id_error IS NULL Then
        IF UPPER(C_SOL.ID_TIPO_DOCUMENTO) IN ('I','V','G') AND NVL(C_SOL.NO_DOCUMENTO_SOL,'~') = '~' THEN -- Documento emitido por el MIP, DGM y CANCILLERIA
          v_id_error := 'NSS402';  
          v_estatus  := 6;
        END IF;
      End if;
        
      -- Solicitud con ARS invalida
      If v_id_error IS NULL Then
        -- Si es numerico
        If suirplus.NSS_VALIDACIONES_PKG.validar_numero(C_SOL.ID_ARS) Then
          If NOT suirplus.NSS_VALIDACIONES_PKG.validar_ars(C_SOL.ID_ARS) Then
            v_id_error := 'NSS506';
            v_estatus  := 6;
          End if;
        Else
          v_id_error := 'NSS506';
          v_estatus  := 6;
        End if;
      End if;

      -- Solicitud con PARENTESCO invalido
      If v_id_error IS NULL Then
        If NOT suirplus.NSS_VALIDACIONES_PKG.validar_parentesco(C_SOL.ID_PARENTESCO) Then
          v_id_error := 'NSS504';
          v_estatus  := 6;
        End if;
      End if;

      -- Solicitud con nacionalidad invalida
      If v_id_error IS NULL Then
        -- La Solicitud debe traer la nacionalidad y existir en nuestro catalogo de nacionalidades
        If (NVL(C_SOL.ID_NACIONALIDAD, '~') = '~') OR (NVL(C_SOL.ID_NACIONALIDAD ,'~') = '1') Then
          v_id_error := 'NSS910';
          v_estatus  := 6;
        Else
          If NOT suirplus.NSS_VALIDACIONES_PKG.validar_nacionalidad(C_SOL.ID_NACIONALIDAD) Then
            v_id_error := 'NSS910';
            v_estatus  := 6;
          End if;
        End if;
      End if;

      -- Solicitud con el indicador de extranjero invalido
      If v_id_error IS NULL Then
        If NVL(C_SOL.EXTRANJERO,'~') <> 'S' then
          v_id_error := 'NSS509';
          v_estatus  := 6;
        End if;
      End if;

      -- Acta debe venir en blanco si es extranjero
      If v_id_error IS NULL then
        If (
            Trim(C_SOL.MUNICIPIO_ACTA) is not null or
            Trim(C_SOL.ANO_ACTA)       is not null or
            Trim(C_SOL.NUMERO_ACTA)    is not null or
            Trim(C_SOL.FOLIO_ACTA)     is not null or
            Trim(C_SOL.LIBRO_ACTA)     is not null or
            Trim(C_SOL.OFICIALIA_ACTA) is not null
           )
        Then
          v_id_error := 'NSS510';
          v_estatus  := 6;
        End if;
      End if;

      -- Solicitud sin imagen
      If v_id_error IS NULL Then
        If NOT suirplus.NSS_VALIDACIONES_PKG.validar_imagen(C_SOL.IMAGEN_SOLICITUD) Then
          v_id_error := 'NSS511';
          v_estatus  := 6;
        End if;
      End if;

      -- Solicitud con sexo invalido
      If v_id_error IS NULL Then
        If NOT suirplus.NSS_VALIDACIONES_PKG.validar_sexo(NVL(C_SOL.SEXO,'~')) Then
          v_id_error := 'NSS508';
          v_estatus  := 6; --'RE';
        End if;
      End if;

      -- Solicitud con fecha de nacimiento invalida
      If v_id_error IS NULL Then
        If NOT suirplus.NSS_VALIDACIONES_PKG.validar_fecha(NVL(C_SOL.FECHA_NACIMIENTO,TO_DATE('01011800','ddmmyyyy'))) Then
          v_id_error := 'NSS514';
          v_estatus  := 6;
        End if;
      End if;

      -- validar la conformacion correcta del nombre
      If v_id_error IS NULL Then
        If NOT suirplus.NSS_VALIDACIONES_PKG.validar_nombre_correcto(C_SOL.NOMBRES,
                                                                     C_SOL.PRIMER_APELLIDO,
                                                                     C_SOL.SEGUNDO_APELLIDO)
        Then
          v_id_error := 'NSS515';
          v_estatus  := 6;
        End if;
      End if;

      -- Solicitud con titular invalido
      If v_id_error IS NULL Then
        If NOT suirplus.NSS_VALIDACIONES_PKG.validar_titular(NVL(C_SOL.ID_NSS_TITULAR,-1)) Then
          v_id_error := 'NSS505';
          v_estatus  := 6; --'RE';
        End if;
      End if;

      -- Solicitud con nombre incorrecto
      If v_id_error IS NULL Then
        If NOT suirplus.NSS_VALIDACIONES_PKG.validar_caracteres_invalidos(NVL(trim(C_SOL.NOMBRES),'~')) Then
          v_id_error := 'NSS905';
          v_estatus  := 6; --'RE';
        End if;
      End if;

      -- Solicitud con primer apellido incorrecto
      If v_id_error IS NULL Then
        If NOT suirplus.NSS_VALIDACIONES_PKG.validar_caracteres_invalidos(NVL(trim(C_SOL.PRIMER_APELLIDO),'~')) Then
          v_id_error := 'NSS905';
          v_estatus  := 6; --'RE';
        End if;
      End if;

      -- Solicitud con segundo apellido incorrecto
      If v_id_error IS NULL Then
        If NOT suirplus.NSS_VALIDACIONES_PKG.validar_caracteres_invalidos(C_SOL.SEGUNDO_APELLIDO) Then
          v_id_error := 'NSS905';
          v_estatus  := 6; --'RE';
        End if;
      End if;

      -- diferencia de edad
      If v_id_error IS NULL Then
        If (C_SOL.VALIDACION_MAYORIA_EDAD = 'S') AND (NOT suirplus.nss_validaciones_pkg.validar_nacimiento(NVL(C_SOL.FECHA_NACIMIENTO,TO_DATE('01011800','ddmmyyyy')))) Then
          v_id_error := 'NSS906';
          v_estatus  := 6;
        End if;
      End if;

      --Validamos que no sea meor de 18 años y que el id_parentesco sea (5,6,17 o 18) correspondientes a hijos/as o hijastros/as
       If v_id_error IS NULL Then
        If (nss_validaciones_pkg.validar_nacimiento(C_SOL.Fecha_Nacimiento) = false) Then
          v_id_error := 'NSS514';
          v_estatus  := 6;
        End if;
      End if; 
      --Validamos que el id_parentesco sea (5,6,17 o 18) correspondientes a hijos/as o hijastros/as
       If v_id_error IS NULL Then
        If (nss_validaciones_pkg.validar_nacimiento(C_SOL.Fecha_Nacimiento) = true) and (C_SOL.Id_Parentesco not in (5,6,17,18)) Then
          v_id_error := 'NSS514';
          v_estatus  := 6;
        End if;
      End if; 

      --Colocada como ultima validacion para permitir que pasen los duplicados a evaluacion visual
      --y que no se vean afectados por esta evaluacion
      --43:Ars invalidada (TODAS LAS ARS que tengan la marca 'S' en el campo EN_EVALUACION_VISUAL)
      IF V_ID_ERROR IS NULL THEN      
        IF suirplus.nss_validaciones_pkg.ars_evaluacion_visual(C_SOL.ID_ARS,v_id_proceso, v_estatus, v_id_error) THEN
          v_id_error := 'NSS506';
          v_estatus  := 6;      
        END IF;
      END IF;
      
      -- nombre duplicado
      If v_id_error IS NULL Then
        -- Insertamos en la maestra de Evaluacion Visual
        SUIRPLUS.NSS_INSERTAR_EVALUACION_VISUAL
         ('H',
          C_SOL.ID_REGISTRO,
          NULL,
          NULL,
          NULL,
          P_ULT_USUARIO_ACT,
          V_ID_EVALUACION,
          V_RESULTADO
         );

        v_conteo := 0;
        FOR DUP IN (Select c.id_nss
                      From suirplus.sre_ciudadanos_t c
                     Where suirplus.nss_validaciones_pkg.primer_nombre(c.nombres) = suirplus.nss_validaciones_pkg.primer_nombre(C_SOL.NOMBRES)
                       And TRIM(c.primer_apellido) = TRIM(C_SOL.Primer_Apellido)
                       And TRUNC(c.fecha_nacimiento) = TRUNC(C_SOL.FECHA_NACIMIENTO)
                       And TRIM(c.sexo) = TRIM(C_SOL.SEXO)
                       And TRIM(c.tipo_documento) <> 'P' --No pasaporte
                       And suirplus.nss_validaciones_pkg.validar_inhabilidad_tss(c.id_causa_inhabilidad, c.tipo_causa) = 'N')
        LOOP
          -- Insertamos en el detalle de Evaluacion Visual los NSS que coinciden por nombre
          SUIRPLUS.NSS_INSERTAR_EVALUACION_VISUAL
           ('D',
            NULL,
            DUP.id_nss,
            NULL,
            NULL,
            P_ULT_USUARIO_ACT,
            V_ID_EVALUACION,
            V_RESULTADO
           );
           
          v_conteo := v_conteo + 1;
        END LOOP;
        
        v_id_error := 'NSS404';  
        v_estatus  := 4;
      End If;
      
      -- Actualizamos la solicitud en evaluacion visual por ser extranjero
      SUIRPLUS.NSS_ACTUALIZAR_SOLICITUD(C_SOL.ID_REGISTRO, v_estatus, v_id_error, v_nss_dup, p_ult_usuario_act, p_resultado);
      
      IF p_resultado <> 'OK' THEN
        ROLLBACK;
        -- Grabar fin seguimiento en detalle de bitacora
        suirplus.detalle_bitacora(v_id_bitacora,
                                  sysdate,
                                  SUBSTR('Solicitud ASIGNACION NSS A DEPENDIENTE TRABAJADOR EXTRANJERO, ID_SOLICITUD #'||to_char(P_ID_SOLICITUD)||', ID_REGISTRO #'||to_char(C_SOL.ID_REGISTRO)||': ignorada ('||to_char(sysdate,'dd/mm/yyyy hh:mi:ss am')||').'||chr(13)||chr(10)||
                                  'MOTIVO: '||p_resultado,1,500));
      ELSE
        -- Grabar primer seguimiento en detalle de bitacora
        suirplus.detalle_bitacora(v_id_bitacora,
                                  sysdate,
                                  SUBSTR('Solicitud ASIGNACION NSS A DEPENDIENTE TRABAJADOR EXTRANJERO, ID_SOLICITUD #'||to_char(P_ID_SOLICITUD)||', ID_REGISTRO #'||to_char(C_SOL.ID_REGISTRO)||': puesta en evaluacion visual ('||to_char(sysdate,'dd/mm/yyyy hh:mi:ss am')||').',1,500));
      END IF;
    EXCEPTION WHEN OTHERS THEN
      p_resultado := SQLERRM||' - '||dbms_utility.format_error_backtrace;
      
      -- Grabar primer seguimiento en detalle de bitacora
      suirplus.detalle_bitacora(v_id_bitacora,
                                sysdate,
                                SUBSTR('Solicitud ASIGNACION NSS A DEPENDIENTE TRABAJADOR EXTRANJERO, ID_SOLICITUD #'||to_char(P_ID_SOLICITUD)||', ID_REGISTRO #'||to_char(C_SOL.ID_REGISTRO)||': ignorada por error: '||p_resultado,1,500));
    END;      
  END LOOP;
  
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
  WHEN e_tipo_sol_invalido THEN
    p_resultado := Suirplus.Seg_Retornar_Cadena_Error('178', NULL, NULL);

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

    IF v_id_bitacora IS NOT NULL THEN
      -- Para grabar mensaje a notificar
      suirplus.registrar_mensaje(v_id_proceso,
                                 SUBSTR('PROCESO TERMINADO CON ERROR: '||p_resultado||'. ID_SOLICITUD #'||to_char(P_ID_SOLICITUD)||', ID_REGISTRO #'||to_char(v_id_registro), 1, 500),
                                 'P',
                                 v_resultado);

      -- Grabar fin seguimiento en detalle de bitacora
      suirplus.detalle_bitacora(v_id_bitacora,
                                sysdate,
                                SUBSTR('PROCESO TERMINADO CON ERROR: '||p_resultado||'. ID_SOLICITUD #'||to_char(P_ID_SOLICITUD)||', ID_REGISTRO #'||to_char(v_id_registro), 1, 500));

      -- Para cerrar la bitacora
      suirplus.bitacora(v_id_bitacora,
                       'FIN',
                       v_ID_PROCESO,
                       substr(p_resultado, 1, 200),
                       'E',
                       '000');
   END IF;                    
END;
