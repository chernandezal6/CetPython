CREATE OR REPLACE PROCEDURE SUIRPLUS.NSS_VALIDAR_SOLICITUD_NUI_2
(
 p_id_solicitud in suirplus.nss_solicitudes_t.id_solicitud%type,
 p_ult_usuario_act in suirplus.seg_usuario_t.id_usuario%type,
 p_nui_cadena in varchar2,
 p_resultado out varchar2
) IS
  v_id_bitacora      suirplus.sfc_bitacora_t.id_bitacora%type;
  v_id_proceso       suirplus.sfc_procesos_t.id_proceso%TYPE := '69'; --Validar solicitud nss a NUI
  v_nss_dup          suirplus.sre_ciudadanos_t.id_nss%Type;
  v_id_evaluacion    suirplus.nss_evaluacion_visual_t.id_evaluacion%Type;  
  
  v_inicio           date := sysdate;
  v_final            date;
  v_conteo           pls_integer;
  v_mensaje          varchar2(500);
  v_resultado        varchar2(200);
  v_jce_respuesta    varchar2(32767);
  v_sre_ciudadano    suirplus.sre_ciudadanos_t%rowtype;

  e_usuario_no_existe    EXCEPTION;
  e_solicitud_no_existe  EXCEPTION;
  e_estatus_sol_invalido EXCEPTION;
  e_tipo_sol_no_existe   EXCEPTION;
  e_proceso_no_existe    EXCEPTION;

  -- ---------------------------------------------------------------
  function validar_fecha(p_fecha in date) return varchar2 is
    validacion Varchar2(1) := 'S';
  begin
    if (p_fecha is null) then      -- Fecha Invalida 
      validacion := 'N';
    elsif p_fecha > trunc(sysdate) then -- No sea Fecha Futura
      validacion := 'F';
    elsif p_fecha < trunc(add_months(sysdate, -18 * 12)) then -- Es mayor de edad
      validacion := 'M';
    else
      validacion := 'S';  -- Fecha Validad
    end if;
    
    return validacion;
  exception when others  then
    return 'N';
  end;
BEGIN
  if TRIM(p_nui_cadena) is null then
    p_resultado := 'Parametro p_nui_cadena no debe venir en blanco.';
    RETURN;
  end if;
    
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
     And s.id_tipo = 2; -- Solicitud NSS a NUI

  IF v_conteo = 0 THEN
    RAISE e_tipo_sol_no_existe;
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
                                                    'PARAMETROS: p_id_solicitud = '||TO_CHAR(p_id_solicitud)||
                                                    ', p_ult_usuario_act = '||p_ult_usuario_act||' p_nui_cadena = '||p_nui_cadena,1,500));

  -- Ver si existen solicitudes de asignacion nns a menores en evaluacion visual
  -- Si existe rechazarla todas y dejar solo la que estoy procesando
  FOR C_SOL IN
    (
     Select d.*
       From suirplus.nss_solicitudes_t s
       Join suirplus.nss_det_solicitudes_t d
         On d.id_solicitud = s.id_solicitud
        And d.id_estatus = 1 -- Pendiente de procesar en detalle de solicitud
      Where s.id_solicitud = p_id_solicitud
      Order by d.id_registro DESC
    )
  LOOP
    BEGIN
      -- Buscamos duplicado por tipo y nro documento en varias solicitudes en estatus 'PE'
      Select count(*)
        Into v_conteo
        From suirplus.nss_solicitudes_t s
        Join suirplus.nss_det_solicitudes_t d
          On d.id_solicitud = s.id_solicitud
         And d.id_estatus IN(1,4) -- Pendiente de procesar o enviado a evaluacion visual en detalle de solicitud
         And d.id_tipo_documento = C_SOL.ID_TIPO_DOCUMENTO
         And d.no_documento_sol  = C_SOL.NO_DOCUMENTO_SOL
         And d.id_registro < C_SOL.ID_REGISTRO -- Diferente al regitro del cursor
       Where s.id_tipo = 2; --Solicitud NSS a NUI

      --433: Si existe una solicitud identica, pero creada anteriormente, rechazo la que estoy procesando
      IF v_conteo >= 1 THEN
        SUIRPLUS.NSS_ACTUALIZAR_SOLICITUD(C_SOL.ID_REGISTRO, 6, 'NSS403', NULL, p_ult_usuario_act, p_resultado); --Ya existe otra solicitud para el mismo ciudadano
         
        IF p_resultado <> 'OK' THEN
          -- Grabar fin seguimiento en detalle de bitacora
          suirplus.detalle_bitacora(v_id_bitacora,
                                    sysdate,
                                    SUBSTR('Solicitud ASIGNACION NSS A MENOR CON NUI #'||to_char(P_ID_SOLICITUD)||': ignorada.'||chr(13)||chr(10)||
                                    'MOTIVO: '||p_resultado,1,500));
        ELSE
          -- Grabar primer seguimiento en detalle de bitacora
          suirplus.detalle_bitacora(v_id_bitacora,
                                    sysdate,
                                    SUBSTR('Solicitud ASIGNACION NSS A MENOR CON NUI #'||to_char(P_ID_SOLICITUD)||': rechazada.'||chr(13)||chr(10)||
                                    'MOTIVO: '||Suirplus.Seg_Retornar_Cadena_Error('NSS403', NULL, NULL),1,500));
        END IF;

        -- Pasamos al proximo registro
        CONTINUE;
      END IF;

      --310: Validar la longitud sea 11 (campo solo número), responder RE a UNIPAGO.
      IF (NOT REGEXP_LIKE(C_SOL.NO_DOCUMENTO_SOL, '^\d{11}$')) THEN
        SUIRPLUS.NSS_ACTUALIZAR_SOLICITUD(C_SOL.ID_REGISTRO, 6, 'NSS402', NULL, p_ult_usuario_act, p_resultado); --Número de documento inválido

        IF p_resultado <> 'OK' THEN
          -- Grabar fin seguimiento en detalle de bitacora
          suirplus.detalle_bitacora(v_id_bitacora,
                                    sysdate,
                                    SUBSTR('Solicitud ASIGNACION NSS A MENOR CON NUI #'||to_char(P_ID_SOLICITUD)||': ignorada.'||chr(13)||chr(10)||
                                    'MOTIVO: '||p_resultado,1,500));
        ELSE
          -- Grabar primer seguimiento en detalle de bitacora
          suirplus.detalle_bitacora(v_id_bitacora,
                                    sysdate,
                                    SUBSTR('Solicitud ASIGNACION NSS A MENOR CON NUI #'||to_char(P_ID_SOLICITUD)||': rechazada.'||chr(13)||chr(10)||
                                    'MOTIVO: '||Suirplus.Seg_Retornar_Cadena_Error('NSS402', NULL, NULL),1,500));
        END IF;

        -- Pasamos al proximo registro
        CONTINUE;
      END IF;

      -- Llamamos WEBSERVICE de la JCE para NUI
      v_jce_respuesta := p_nui_cadena; --suirplus.NSS_WEBSERVICE_JCE_NUI(C_SOL.NO_DOCUMENTO_SOL);
      
      -- J01: Si no encuentra el documento en la JCE
      IF (v_jce_respuesta LIKE '%<MENSAJE>DOCUMENTO INVALIDO O INCORRECTO</MENSAJE>%') THEN
        SUIRPLUS.NSS_ACTUALIZAR_SOLICITUD(C_SOL.ID_REGISTRO, 6, 'NSS501', NULL, p_ult_usuario_act, p_resultado); --Documento no existe en JCE

        IF p_resultado <> 'OK' THEN
          -- Grabar fin seguimiento en detalle de bitacora
          suirplus.detalle_bitacora(v_id_bitacora,
                                    sysdate,
                                    SUBSTR('Solicitud ASIGNACION NSS A MENOR CON NUI #'||to_char(P_ID_SOLICITUD)||': ignorada.'||chr(13)||chr(10)||
                                    'MOTIVO: '||p_resultado,1,500));
        ELSE
          -- Grabar primer seguimiento en detalle de bitacora
          suirplus.detalle_bitacora(v_id_bitacora,
                                    sysdate,
                                    SUBSTR('Solicitud ASIGNACION NSS A MENOR CON NUI #'||to_char(P_ID_SOLICITUD)||': rechazada.'||chr(13)||chr(10)||
                                    'MOTIVO: '||Suirplus.Seg_Retornar_Cadena_Error('NSS501', NULL, NULL),1,500));
        END IF;

        -- Pasamos al proximo registro
        CONTINUE;
      END IF;
      
      v_sre_ciudadano.TIPO_DOCUMENTO   := C_SOL.ID_TIPO_DOCUMENTO;
      v_sre_ciudadano.NO_DOCUMENTO     := C_SOL.NO_DOCUMENTO_SOL;
      v_sre_ciudadano.NOMBRES          := SUIRPLUS.NSS_PARSEAR_NUI(v_jce_respuesta, 'nombre');
      v_sre_ciudadano.PRIMER_APELLIDO  := SUIRPLUS.NSS_PARSEAR_NUI(v_jce_respuesta, 'primer_apellido');
      v_sre_ciudadano.SEGUNDO_APELLIDO := SUIRPLUS.NSS_PARSEAR_NUI(v_jce_respuesta, 'segundo_apellido');
      v_sre_ciudadano.FECHA_NACIMIENTO := TO_DATE(SUIRPLUS.NSS_PARSEAR_NUI(v_jce_respuesta, 'fechaevento'),'dd/mm/yyyy');
      
      BEGIN
        v_sre_ciudadano.SEXO           := SUIRPLUS.NSS_PARSEAR_NUI(v_jce_respuesta, 'sexo');
      EXCEPTION WHEN OTHERS THEN
        v_sre_ciudadano.SEXO           := NULL;
      END;
          
      v_sre_ciudadano.NUMERO_ACTA      := SUIRPLUS.NSS_VALIDACIONES_PKG.LIMPIAR_NUMERO_ACTA(SUIRPLUS.NSS_PARSEAR_NUI(v_jce_respuesta, 'noacta'));
      v_sre_ciudadano.ANO_ACTA         := SUIRPLUS.NSS_VALIDACIONES_PKG.LIMPIAR_ANO_ACTA(SUIRPLUS.NSS_PARSEAR_NUI(v_jce_respuesta, 'ano'));
      v_sre_ciudadano.MUNICIPIO_ACTA   := SUIRPLUS.NSS_VALIDACIONES_PKG.LIMPIAR_MUNICIPIO_ACTA(SUIRPLUS.NSS_PARSEAR_NUI(v_jce_respuesta, 'municipio'));
      v_sre_ciudadano.OFICIALIA_ACTA   := SUIRPLUS.NSS_VALIDACIONES_PKG.LIMPIAR_OFICIALIA_ACTA(SUIRPLUS.NSS_PARSEAR_NUI(v_jce_respuesta, 'oficialia'));
      v_sre_ciudadano.FOLIO_ACTA       := SUIRPLUS.NSS_VALIDACIONES_PKG.LIMPIAR_FOLIO_ACTA(SUIRPLUS.NSS_PARSEAR_NUI(v_jce_respuesta, 'nofolio'));
      v_sre_ciudadano.LIBRO_ACTA       := SUIRPLUS.NSS_VALIDACIONES_PKG.LIMPIAR_LIBRO_ACTA(SUIRPLUS.NSS_PARSEAR_NUI(v_jce_respuesta, 'nolibro'), v_sre_ciudadano.ANO_ACTA);
      v_sre_ciudadano.TIPO_LIBRO_ACTA  := SUIRPLUS.NSS_PARSEAR_NUI(v_jce_respuesta, 'idtipolibro');
      v_sre_ciudadano.LITERAL_ACTA     := SUIRPLUS.NSS_VALIDACIONES_PKG.LIMPIAR_LITERAL_ACTA(SUIRPLUS.NSS_PARSEAR_NUI(v_jce_respuesta, 'literal'));
      
      --Para sanear los casos de cedulas mayores de 11 digitos
      --Esto porque se esta poniendo el valor que viene de la JCE
      --En un campo tipo SRE_CIUDADANOS_T.cedula_padre
      BEGIN
        v_sre_ciudadano.CEDULA_PADRE   := REPLACE(SUIRPLUS.NSS_PARSEAR_NUI(v_jce_respuesta, 'cedulapadre'),'-','');
      EXCEPTION WHEN OTHERS THEN
        v_sre_ciudadano.CEDULA_PADRE   := NULL;
      END;  

      --Para sanear los casos de cedulas mayores de 11 digitos
      --Esto porque se esta poniendo el valor que viene de la JCE
      --En un campo tipo SRE_CIUDADANOS_T.cedula_madre
      BEGIN
        v_sre_ciudadano.CEDULA_MADRE   := REPLACE(SUIRPLUS.NSS_PARSEAR_NUI(v_jce_respuesta, 'cedulamadre'),'-','');
      EXCEPTION WHEN OTHERS THEN
        v_sre_ciudadano.CEDULA_MADRE   := NULL;
      END;
      
      -- Cedula padre debe ser de 11 digitos
      IF (NOT REGEXP_LIKE(v_sre_ciudadano.CEDULA_PADRE, '^\d{11}$')) THEN
        v_sre_ciudadano.CEDULA_PADRE := null;
      ELSE  
        BEGIN
          select i.nombres || ' ' || i.primer_apellido || ' ' || i.segundo_apellido nombre
            into v_sre_ciudadano.NOMBRE_PADRE
            from suirplus.sre_ciudadanos_t i
           where i.no_documento = v_sre_ciudadano.CEDULA_PADRE
             and i.tipo_documento='C';
        EXCEPTION
          WHEN OTHERS THEN
            v_sre_ciudadano.NOMBRE_PADRE := null;
        END;
      END IF;
               
      -- Cedula madre debe ser de 11 digitos
      IF (NOT REGEXP_LIKE(v_sre_ciudadano.CEDULA_MADRE, '^\d{11}$')) THEN
        v_sre_ciudadano.CEDULA_MADRE := null;
      ELSE  
        BEGIN
          select i.nombres || ' ' || i.primer_apellido || ' ' || i.segundo_apellido nombre
            into v_sre_ciudadano.NOMBRE_MADRE
            from suirplus.sre_ciudadanos_t i
           where i.no_documento = v_sre_ciudadano.CEDULA_MADRE
             and i.tipo_documento='C';
        EXCEPTION
          WHEN OTHERS THEN
            v_sre_ciudadano.NOMBRE_MADRE := null;
        END;
      END IF;

      IF NOT suirplus.NSS_VALIDACIONES_PKG.VALIDAR_MUNICIPIO(v_sre_ciudadano.MUNICIPIO_ACTA) THEN
        --Insertamos el municipio en la provincia default='99'
        INSERT INTO suirplus.sre_municipio_t
          (id_municipio,
           municipio_des,
           id_provincia,
           id_municipio_pa,
           ult_usuario_act,
           ult_fecha_act)
        VALUES
          (v_sre_ciudadano.MUNICIPIO_ACTA,
           'DESCONOCIDO',
           '99',
           Null,
           'OPERACIONES',
           Sysdate);
        COMMIT;
      END IF;

      -- Si en alguno de los campos obligatorios llega data invalida
      IF (v_sre_ciudadano.NO_DOCUMENTO IS NULL OR
          v_sre_ciudadano.NOMBRES IS NULL OR
          v_sre_ciudadano.PRIMER_APELLIDO IS NULL OR
          v_sre_ciudadano.FECHA_NACIMIENTO IS NULL OR
          NVL(v_sre_ciudadano.SEXO, '~') NOT IN ('M','F') OR
          validar_fecha(v_sre_ciudadano.FECHA_NACIMIENTO) <> 'S') THEN
        -- Verificamos la fecha de nacimiento
        -- 428: Es mayor de edad
        IF validar_fecha(v_sre_ciudadano.FECHA_NACIMIENTO) = 'M' THEN
          SUIRPLUS.NSS_ACTUALIZAR_SOLICITUD(C_SOL.ID_REGISTRO, 6, 'NSS906', NULL, p_ult_usuario_act, p_resultado); --Dependiente menor con 18 años o mas

          IF p_resultado <> 'OK' THEN
            -- Grabar fin seguimiento en detalle de bitacora
            suirplus.detalle_bitacora(v_id_bitacora,
                                      sysdate,
                                      SUBSTR('Solicitud ASIGNACION NSS A MENOR CON NUI #'||to_char(P_ID_SOLICITUD)||': ignorada.'||chr(13)||chr(10)||
                                      'MOTIVO: '||p_resultado,1,500));
          ELSE
            -- Grabar primer seguimiento en detalle de bitacora
            suirplus.detalle_bitacora(v_id_bitacora,
                                      sysdate,
                                      SUBSTR('Solicitud ASIGNACION NSS A MENOR CON NUI #'||to_char(P_ID_SOLICITUD)||': rechazada.'||chr(13)||chr(10)||
                                      'MOTIVO: '||Suirplus.Seg_Retornar_Cadena_Error('NSS906', NULL, NULL),1,500));
          END IF;
            
          -- Pasamos al proximo registro
          CONTINUE;
        END IF;
        
        --Actualizamos la solicitud
        SUIRPLUS.NSS_ACTUALIZAR_SOLICITUD(C_SOL.ID_REGISTRO, 6, 'NSS502', NULL, p_ult_usuario_act, p_resultado); --Ciudadano debe gestionar actualización datos en JCE

        IF p_resultado <> 'OK' THEN
          -- Grabar fin seguimiento en detalle de bitacora
          suirplus.detalle_bitacora(v_id_bitacora,
                                    sysdate,
                                    SUBSTR('Solicitud ASIGNACION NSS A MENOR CON NUI #'||to_char(P_ID_SOLICITUD)||': ignorada.'||chr(13)||chr(10)||
                                    'MOTIVO: '||p_resultado,1,500));
        ELSE
          -- Grabar primer seguimiento en detalle de bitacora
          suirplus.detalle_bitacora(v_id_bitacora,
                                    sysdate,
                                    SUBSTR('Solicitud ASIGNACION NSS A MENOR CON NUI #'||to_char(P_ID_SOLICITUD)||': rechazada.'||chr(13)||chr(10)||
                                    'MOTIVO: '||Suirplus.Seg_Retornar_Cadena_Error('NSS502', NULL, NULL),1,500));
        END IF;
            
        -- Pasamos al proximo registro
        CONTINUE;
      END IF;
      
      --Si existe en TSS en la maestra de CIUDADANO, actualizamos con los datos de la JCE
      Select count(*), min(id_nss)
        Into v_conteo, v_nss_dup
        From suirplus.sre_ciudadanos_t c
       Where c.tipo_documento = C_SOL.ID_TIPO_DOCUMENTO
         And c.no_documento   = C_SOL.NO_DOCUMENTO_SOL;

      IF v_conteo > 0 THEN --Existe en ciudadanos
        Select count(*)
          Into v_conteo
          From suirplus.sre_ciudadanos_t c
         Where c.tipo_documento = C_SOL.ID_TIPO_DOCUMENTO
           And c.no_documento   = C_SOL.NO_DOCUMENTO_SOL
           And SUIRPLUS.NSS_VALIDACIONES_PKG.validar_inhabilidad_tss(c.id_causa_inhabilidad, c.tipo_causa) = 'N'; --no Cancelado por la TSS

        IF v_conteo > 0 THEN
          v_sre_ciudadano.ID_NSS := v_nss_dup;
          --Actualizamos el ciudadano en base a los datos de la JCE y la solicitud a: NSS ACTUALIZADO
          SUIRPLUS.NSS_ACTUALIZAR_CIUDADANO(C_SOL.ID_REGISTRO, v_sre_ciudadano, p_ult_usuario_act, p_resultado);

          IF p_resultado <> 'OK' THEN
            -- Grabar fin seguimiento en detalle de bitacora
            suirplus.detalle_bitacora(v_id_bitacora,
                                      sysdate,
                                      SUBSTR('Solicitud ASIGNACION NSS A MENOR CON NUI #'||to_char(P_ID_SOLICITUD)||': ignorada.'||chr(13)||chr(10)||
                                      'MOTIVO: '||p_resultado,1,500));
          ELSE
            -- Grabar primer seguimiento en detalle de bitacora
            suirplus.detalle_bitacora(v_id_bitacora,
                                      sysdate,
                                      SUBSTR('Solicitud ASIGNACION NSS A MENOR CON NUI #'||to_char(P_ID_SOLICITUD)||': procesada.',1,500));
          END IF;
        
          -- Pasamos al proximo registro
          CONTINUE;        
        ELSE
          --Rechazamos la solicitud, ciudadano esta cancelado POR TSS
          SUIRPLUS.NSS_ACTUALIZAR_SOLICITUD(C_SOL.ID_REGISTRO, 6, 'NSS601', NULL, p_ult_usuario_act, p_resultado); --
          
          IF p_resultado <> 'OK' THEN
            -- Grabar fin seguimiento en detalle de bitacora
            suirplus.detalle_bitacora(v_id_bitacora,
                                      sysdate,
                                      SUBSTR('Solicitud ASIGNACION NSS A MENOR CON NUI #'||to_char(P_ID_SOLICITUD)||': ignorada.'||chr(13)||chr(10)||
                                      'MOTIVO: '||p_resultado,1,500));
          ELSE
            -- Grabar primer seguimiento en detalle de bitacora
            suirplus.detalle_bitacora(v_id_bitacora,
                                      sysdate,
                                      SUBSTR('Solicitud ASIGNACION NSS A MENOR CON NUI #'||to_char(P_ID_SOLICITUD)||': rechazada.'||chr(13)||chr(10)||
                                      'MOTIVO: '||Suirplus.Seg_Retornar_Cadena_Error('NSS601', NULL, NULL),1,500));
          END IF;
              
          -- Pasamos al proximo registro
          CONTINUE;
        END IF;    
      END IF;
      
      --Validar: PRIMER NOMBRE, PRIMER APELLIDO, FECHA NACIMIENTO, SEXO, ACTA DE NACIMIENTO, TIPO DOCUMENTO y DIFERENTE NUMERO DOCUMENTO DUPLICADO
      --         COMO CEDULADO
      SELECT COUNT(ID_NSS), MIN(ID_NSS)
        INTO v_conteo, v_nss_dup
        FROM suirplus.sre_ciudadanos_t
       WHERE no_documento != C_SOL.NO_DOCUMENTO_SOL
          -- 
         AND tipo_documento = 'C' --Cedula
          --
         AND SUIRPLUS.NSS_VALIDACIONES_PKG.limpiar_municipio_acta(municipio_acta) = SUIRPLUS.NSS_VALIDACIONES_PKG.limpiar_municipio_acta(v_sre_ciudadano.MUNICIPIO_ACTA)
          --
         AND SUIRPLUS.NSS_VALIDACIONES_PKG.limpiar_ano_acta(ano_acta) = SUIRPLUS.NSS_VALIDACIONES_PKG.limpiar_ano_acta(v_sre_ciudadano.ANO_ACTA)
          --
         AND SUIRPLUS.NSS_VALIDACIONES_PKG.limpiar_oficialia_acta(oficialia_acta) = SUIRPLUS.NSS_VALIDACIONES_PKG.limpiar_oficialia_acta(v_sre_ciudadano.OFICIALIA_ACTA)
          --
         AND SUIRPLUS.NSS_VALIDACIONES_PKG.convertir_letra(nombres) = SUIRPLUS.NSS_VALIDACIONES_PKG.convertir_letra(v_sre_ciudadano.NOMBRES)
          --
         AND SUIRPLUS.NSS_VALIDACIONES_PKG.convertir_letra(primer_apellido) = SUIRPLUS.NSS_VALIDACIONES_PKG.convertir_letra(v_sre_ciudadano.PRIMER_APELLIDO)
          --
         AND SUIRPLUS.NSS_VALIDACIONES_PKG.convertir_letra(segundo_apellido) = SUIRPLUS.NSS_VALIDACIONES_PKG.convertir_letra(v_sre_ciudadano.SEGUNDO_APELLIDO)
          --
         AND SUIRPLUS.NSS_VALIDACIONES_PKG.convertir_letra(sexo) = SUIRPLUS.NSS_VALIDACIONES_PKG.convertir_letra(v_sre_ciudadano.SEXO)
          --
         AND TRUNC(fecha_nacimiento) = TRUNC(v_sre_ciudadano.FECHA_NACIMIENTO)
          --
        AND SUIRPLUS.NSS_VALIDACIONES_PKG.validar_inhabilidad_tss(id_causa_inhabilidad, tipo_causa) = 'N'; --no inhabilitado en TSS
      
      IF v_conteo > 0 THEN
        --Actualizamos la solicitud
        SUIRPLUS.NSS_ACTUALIZAR_SOLICITUD(C_SOL.ID_REGISTRO, 6, 'NSS001', v_nss_dup, p_ult_usuario_act, p_resultado); --Este Ciudadano ya posee Cedula

        IF p_resultado <> 'OK' THEN
          -- Grabar fin seguimiento en detalle de bitacora
          suirplus.detalle_bitacora(v_id_bitacora,
                                    sysdate,
                                    SUBSTR('Solicitud ASIGNACION NSS A MENOR CON NUI #'||to_char(P_ID_SOLICITUD)||': ignorada.'||chr(13)||chr(10)||
                                    'MOTIVO: '||p_resultado,1,500));
        ELSE
          -- Grabar primer seguimiento en detalle de bitacora
          suirplus.detalle_bitacora(v_id_bitacora,
                                    sysdate,
                                    SUBSTR('Solicitud ASIGNACION NSS A MENOR CON NUI #'||to_char(P_ID_SOLICITUD)||': rechazada.'||chr(13)||chr(10)||
                                    'MOTIVO: '||Suirplus.Seg_Retornar_Cadena_Error('NSS001', NULL, NULL),1,500));
        END IF;
              
        -- Pasamos al proximo registro
        CONTINUE;
      END IF;

      --Validar: PRIMER NOMBRE, PRIMER APELLIDO, FECHA NACIMIENTO, SEXO, ACTA DE NACIMIENTO, TIPO DOCUMENTO y DIFERENTE NUMERO DOCUMENTO DUPLICADO
      --         COMO NUI
      SELECT COUNT(ID_NSS)
        INTO v_conteo
        FROM suirplus.sre_ciudadanos_t
       WHERE no_documento != C_SOL.NO_DOCUMENTO_SOL
          -- 
         AND tipo_documento = 'U' --NUI
          --
         AND SUIRPLUS.NSS_VALIDACIONES_PKG.limpiar_municipio_acta(municipio_acta) = SUIRPLUS.NSS_VALIDACIONES_PKG.limpiar_municipio_acta(v_sre_ciudadano.MUNICIPIO_ACTA)
          --
         AND SUIRPLUS.NSS_VALIDACIONES_PKG.limpiar_ano_acta(ano_acta) = SUIRPLUS.NSS_VALIDACIONES_PKG.limpiar_ano_acta(v_sre_ciudadano.ANO_ACTA)
          --
         AND SUIRPLUS.NSS_VALIDACIONES_PKG.limpiar_oficialia_acta(oficialia_acta) = SUIRPLUS.NSS_VALIDACIONES_PKG.limpiar_oficialia_acta(v_sre_ciudadano.OFICIALIA_ACTA)
          --
         AND SUIRPLUS.NSS_VALIDACIONES_PKG.convertir_letra(nombres) = SUIRPLUS.NSS_VALIDACIONES_PKG.convertir_letra(v_sre_ciudadano.NOMBRES)
          --
         AND SUIRPLUS.NSS_VALIDACIONES_PKG.convertir_letra(primer_apellido) = SUIRPLUS.NSS_VALIDACIONES_PKG.convertir_letra(v_sre_ciudadano.PRIMER_APELLIDO)
          --
         AND SUIRPLUS.NSS_VALIDACIONES_PKG.convertir_letra(segundo_apellido) = SUIRPLUS.NSS_VALIDACIONES_PKG.convertir_letra(v_sre_ciudadano.SEGUNDO_APELLIDO)
          --
         AND SUIRPLUS.NSS_VALIDACIONES_PKG.convertir_letra(sexo) = SUIRPLUS.NSS_VALIDACIONES_PKG.convertir_letra(v_sre_ciudadano.SEXO)
          --
         AND TRUNC(fecha_nacimiento) = TRUNC(v_sre_ciudadano.FECHA_NACIMIENTO)
          --
         AND SUIRPLUS.NSS_VALIDACIONES_PKG.validar_inhabilidad_tss(id_causa_inhabilidad, tipo_causa) = 'N'; --no inhabilitado en TSS

      IF v_conteo > 0 THEN
        v_id_evaluacion := NULL;
        FOR R IN (
                  SELECT id_nss
                    FROM suirplus.sre_ciudadanos_t
                   WHERE no_documento != C_SOL.NO_DOCUMENTO_SOL
                      -- 
                     AND tipo_documento = 'U' --NUI
                      --
                     AND SUIRPLUS.NSS_VALIDACIONES_PKG.limpiar_municipio_acta(municipio_acta) = SUIRPLUS.NSS_VALIDACIONES_PKG.limpiar_municipio_acta(v_sre_ciudadano.MUNICIPIO_ACTA)
                      --
                     AND SUIRPLUS.NSS_VALIDACIONES_PKG.limpiar_ano_acta(ano_acta) = SUIRPLUS.NSS_VALIDACIONES_PKG.limpiar_ano_acta(v_sre_ciudadano.ANO_ACTA)
                      --
                     AND SUIRPLUS.NSS_VALIDACIONES_PKG.limpiar_oficialia_acta(oficialia_acta) = SUIRPLUS.NSS_VALIDACIONES_PKG.limpiar_oficialia_acta(v_sre_ciudadano.OFICIALIA_ACTA)
                      --
                     AND SUIRPLUS.NSS_VALIDACIONES_PKG.convertir_letra(nombres) = SUIRPLUS.NSS_VALIDACIONES_PKG.convertir_letra(v_sre_ciudadano.NOMBRES)
                      --
                     AND SUIRPLUS.NSS_VALIDACIONES_PKG.convertir_letra(primer_apellido) = SUIRPLUS.NSS_VALIDACIONES_PKG.convertir_letra(v_sre_ciudadano.PRIMER_APELLIDO)
                      --
                     AND SUIRPLUS.NSS_VALIDACIONES_PKG.convertir_letra(segundo_apellido) = SUIRPLUS.NSS_VALIDACIONES_PKG.convertir_letra(v_sre_ciudadano.SEGUNDO_APELLIDO)
                      --
                     AND SUIRPLUS.NSS_VALIDACIONES_PKG.convertir_letra(sexo) = SUIRPLUS.NSS_VALIDACIONES_PKG.convertir_letra(v_sre_ciudadano.SEXO)
                      --
                     AND TRUNC(fecha_nacimiento) = TRUNC(v_sre_ciudadano.FECHA_NACIMIENTO)
                      --
                     AND SUIRPLUS.NSS_VALIDACIONES_PKG.validar_inhabilidad_tss(id_causa_inhabilidad, tipo_causa) = 'N' --no inhabilitado en TSS
                   ORDER BY id_nss
               )
        LOOP
          -- Poner solicitud en evaluacion visual con los NSS que coinciden
          -- Insertamos la solicitud en el maestro de Evaluacion Visual
          IF v_id_evaluacion IS NULL THEN
            DECLARE
              v_nss_det_solicitudes_t suirplus.nss_det_solicitudes_t%ROWTYPE;
            BEGIN
              v_sre_ciudadano.ID_NSS := R.id_nss; --Primer NSS con coincidencia
                
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

              -- Insertamos en el detalle de Evaluacion Visual
              SUIRPLUS.NSS_INSERTAR_EVALUACION_VISUAL
               ('D',
                NULL,
                R.ID_NSS,
                C_SOL.NO_DOCUMENTO_SOL,
                NULL,
                NULL,
                V_ID_EVALUACION,
                V_RESULTADO
               );
                
              SELECT d.*
                INTO v_nss_det_solicitudes_t --RECORD
                FROM suirplus.nss_det_solicitudes_t d
               WHERE d.id_registro = C_SOL.ID_REGISTRO;
                      
              -- Pongo la data que me interesa para presentación de Evaluacion visual
              v_nss_det_solicitudes_t.NOMBRES          := v_sre_ciudadano.NOMBRES;
              v_nss_det_solicitudes_t.PRIMER_APELLIDO  := v_sre_ciudadano.PRIMER_APELLIDO;
              v_nss_det_solicitudes_t.SEGUNDO_APELLIDO := v_sre_ciudadano.SEGUNDO_APELLIDO;
              v_nss_det_solicitudes_t.FECHA_NACIMIENTO := v_sre_ciudadano.FECHA_NACIMIENTO;
              v_nss_det_solicitudes_t.SEXO             := v_sre_ciudadano.SEXO;
              v_nss_det_solicitudes_t.MUNICIPIO_ACTA   := v_sre_ciudadano.MUNICIPIO_ACTA;
              v_nss_det_solicitudes_t.ANO_ACTA         := v_sre_ciudadano.ANO_ACTA;
              v_nss_det_solicitudes_t.NUMERO_ACTA      := v_sre_ciudadano.NUMERO_ACTA;
              v_nss_det_solicitudes_t.FOLIO_ACTA       := v_sre_ciudadano.FOLIO_ACTA;
              v_nss_det_solicitudes_t.OFICIALIA_ACTA   := v_sre_ciudadano.OFICIALIA_ACTA;
              v_nss_det_solicitudes_t.LIBRO_ACTA       := v_sre_ciudadano.LIBRO_ACTA;
              v_nss_det_solicitudes_t.TIPO_LIBRO_ACTA  := v_sre_ciudadano.TIPO_LIBRO_ACTA;
              v_nss_det_solicitudes_t.LITERAL_ACTA     := v_sre_ciudadano.LITERAL_ACTA;
              v_nss_det_solicitudes_t.CEDULA_MADRE     := v_sre_ciudadano.CEDULA_MADRE;
              v_nss_det_solicitudes_t.CEDULA_PADRE     := v_sre_ciudadano.CEDULA_PADRE;
              v_nss_det_solicitudes_t.NOMBRE_MADRE     := v_sre_ciudadano.NOMBRE_MADRE;
              v_nss_det_solicitudes_t.NOMBRE_PADRE     := v_sre_ciudadano.NOMBRE_PADRE;
              v_nss_det_solicitudes_t.ESTADO_CIVIL     := v_sre_ciudadano.ESTADO_CIVIL;
              v_nss_det_solicitudes_t.ID_NACIONALIDAD  := v_sre_ciudadano.ID_NACIONALIDAD;
                    
              --Como va para evaluacion visual, debo llenar los campos que trae el WEBSERVICE de la JCE
              UPDATE suirplus.nss_det_solicitudes_t d
                 SET ROW = v_nss_det_solicitudes_t
               WHERE d.id_registro = C_SOL.ID_REGISTRO;
                    
              --Actualizamos la solicitud
              SUIRPLUS.NSS_ACTUALIZAR_SOLICITUD(C_SOL.ID_REGISTRO, 4, 'NSS404', v_sre_ciudadano.ID_NSS, p_ult_usuario_act, p_resultado); --Pendiente de Evaluación Visual
                    
              IF V_RESULTADO <> 'OK' THEN
                -- Grabar fin seguimiento en detalle de bitacora
                suirplus.detalle_bitacora(v_id_bitacora,
                                          sysdate,
                                          SUBSTR('Solicitud ASIGNACION NSS A MENOR CON NUI #'||to_char(P_ID_SOLICITUD)||': ignorada.'||chr(13)||chr(10)||
                                          'MOTIVO: '||p_resultado,1,500));
              ELSE
                -- Grabar primer seguimiento en detalle de bitacora
                suirplus.detalle_bitacora(v_id_bitacora,
                                          sysdate,
                                          SUBSTR('Solicitud ASIGNACION NSS A MENOR CON NUI #'||to_char(P_ID_SOLICITUD)||': puesta en evaluacion visual.',1,500));
              END IF;
            END;
          ELSE
            -- Insertamos en el detalle de Evaluacion Visual
            SUIRPLUS.NSS_INSERTAR_EVALUACION_VISUAL
             ('D',
              NULL,
              R.ID_NSS,
              C_SOL.NO_DOCUMENTO_SOL,
              NULL,
              NULL,
              V_ID_EVALUACION,
              V_RESULTADO
             );
          END IF;
        END LOOP;
        
        CONTINUE; -- Pasamos al proximo registro          
      END IF;

      --Validar: PRIMER NOMBRE, PRIMER APELLIDO, FECHA NACIMIENTO, SEXO, ACTA DE NACIMIENTO Y TIPO DOCUMENTO DUPLICADO
      --         COMO MENOR NACIONAL SIN DOCUMENTO
      SELECT COUNT(ID_NSS), MIN(ID_NSS)
        INTO v_conteo, v_nss_dup
        FROM suirplus.sre_ciudadanos_t
       WHERE  tipo_documento = 'N' --MENOR NACIONAL SIN DOCUMENTO
          --
         AND SUIRPLUS.NSS_VALIDACIONES_PKG.limpiar_municipio_acta(municipio_acta) = SUIRPLUS.NSS_VALIDACIONES_PKG.limpiar_municipio_acta(v_sre_ciudadano.MUNICIPIO_ACTA)
          --
         AND SUIRPLUS.NSS_VALIDACIONES_PKG.limpiar_ano_acta(ano_acta) = SUIRPLUS.NSS_VALIDACIONES_PKG.limpiar_ano_acta(v_sre_ciudadano.ANO_ACTA)
          --
         AND SUIRPLUS.NSS_VALIDACIONES_PKG.limpiar_oficialia_acta(oficialia_acta) = SUIRPLUS.NSS_VALIDACIONES_PKG.limpiar_oficialia_acta(v_sre_ciudadano.OFICIALIA_ACTA)
          --
         AND SUIRPLUS.NSS_VALIDACIONES_PKG.convertir_letra(nombres) = SUIRPLUS.NSS_VALIDACIONES_PKG.convertir_letra(v_sre_ciudadano.NOMBRES)
          --
         AND SUIRPLUS.NSS_VALIDACIONES_PKG.convertir_letra(primer_apellido) = SUIRPLUS.NSS_VALIDACIONES_PKG.convertir_letra(v_sre_ciudadano.PRIMER_APELLIDO)
          --
         AND SUIRPLUS.NSS_VALIDACIONES_PKG.convertir_letra(segundo_apellido) = SUIRPLUS.NSS_VALIDACIONES_PKG.convertir_letra(v_sre_ciudadano.SEGUNDO_APELLIDO)
          --
         AND SUIRPLUS.NSS_VALIDACIONES_PKG.convertir_letra(sexo) = SUIRPLUS.NSS_VALIDACIONES_PKG.convertir_letra(v_sre_ciudadano.SEXO)
          --
         AND TRUNC(fecha_nacimiento) = TRUNC(v_sre_ciudadano.FECHA_NACIMIENTO)
          --
         AND SUIRPLUS.NSS_VALIDACIONES_PKG.validar_inhabilidad_tss(id_causa_inhabilidad, tipo_causa) = 'N'; --no inhabilitado en TSS

      IF v_conteo > 1 THEN
        v_id_evaluacion := NULL;

        FOR R IN (
                  SELECT id_nss
                    FROM suirplus.sre_ciudadanos_t
                   WHERE tipo_documento = 'N' --MENOR NACIONAL SIN DOCUMENTO
                      --
                     AND SUIRPLUS.NSS_VALIDACIONES_PKG.limpiar_municipio_acta(municipio_acta) = SUIRPLUS.NSS_VALIDACIONES_PKG.limpiar_municipio_acta(v_sre_ciudadano.MUNICIPIO_ACTA)
                      --
                     AND SUIRPLUS.NSS_VALIDACIONES_PKG.limpiar_ano_acta(ano_acta) = SUIRPLUS.NSS_VALIDACIONES_PKG.limpiar_ano_acta(v_sre_ciudadano.ANO_ACTA)
                      --
                     AND SUIRPLUS.NSS_VALIDACIONES_PKG.limpiar_oficialia_acta(oficialia_acta) = SUIRPLUS.NSS_VALIDACIONES_PKG.limpiar_oficialia_acta(v_sre_ciudadano.OFICIALIA_ACTA)
                      --
                     AND SUIRPLUS.NSS_VALIDACIONES_PKG.convertir_letra(nombres) = SUIRPLUS.NSS_VALIDACIONES_PKG.convertir_letra(v_sre_ciudadano.NOMBRES)
                      --
                     AND SUIRPLUS.NSS_VALIDACIONES_PKG.convertir_letra(primer_apellido) = SUIRPLUS.NSS_VALIDACIONES_PKG.convertir_letra(v_sre_ciudadano.PRIMER_APELLIDO)
                      --
                     AND SUIRPLUS.NSS_VALIDACIONES_PKG.convertir_letra(segundo_apellido) = SUIRPLUS.NSS_VALIDACIONES_PKG.convertir_letra(v_sre_ciudadano.SEGUNDO_APELLIDO)
                      --
                     AND SUIRPLUS.NSS_VALIDACIONES_PKG.convertir_letra(sexo) = SUIRPLUS.NSS_VALIDACIONES_PKG.convertir_letra(v_sre_ciudadano.SEXO)
                      --                  
                     AND TRUNC(fecha_nacimiento) = TRUNC(v_sre_ciudadano.FECHA_NACIMIENTO)
                      --
                     AND SUIRPLUS.NSS_VALIDACIONES_PKG.validar_inhabilidad_tss(id_causa_inhabilidad, tipo_causa) = 'N' --no inhabilitado en TSS
                   ORDER BY id_nss
               )
        LOOP
          -- Poner solicitud en evaluacion visual con los NSS que coinciden
          -- Insertamos la solicitud en el maestro de Evaluacion Visual
          IF v_id_evaluacion IS NULL THEN
            DECLARE
              v_nss_det_solicitudes_t suirplus.nss_det_solicitudes_t%ROWTYPE;
            BEGIN
              v_sre_ciudadano.ID_NSS := R.id_nss; --Primer NSS con coincidencia
                  
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

              -- Insertamos en el detalle de Evaluacion Visual
              SUIRPLUS.NSS_INSERTAR_EVALUACION_VISUAL
               ('D',
                NULL,
                R.ID_NSS,
                C_SOL.NO_DOCUMENTO_SOL,
                NULL,
                NULL,
                V_ID_EVALUACION,
                V_RESULTADO
               );
                  
              SELECT d.*
                INTO v_nss_det_solicitudes_t --RECORD
                FROM suirplus.nss_det_solicitudes_t d
               WHERE d.id_registro = C_SOL.ID_REGISTRO;
                        
              -- Pongo la data que me interesa para presentación de Evaluacion visual
              v_nss_det_solicitudes_t.NOMBRES          := v_sre_ciudadano.NOMBRES;
              v_nss_det_solicitudes_t.PRIMER_APELLIDO  := v_sre_ciudadano.PRIMER_APELLIDO;
              v_nss_det_solicitudes_t.SEGUNDO_APELLIDO := v_sre_ciudadano.SEGUNDO_APELLIDO;
              v_nss_det_solicitudes_t.FECHA_NACIMIENTO := v_sre_ciudadano.FECHA_NACIMIENTO;
              v_nss_det_solicitudes_t.SEXO             := v_sre_ciudadano.SEXO;
              v_nss_det_solicitudes_t.MUNICIPIO_ACTA   := v_sre_ciudadano.MUNICIPIO_ACTA;
              v_nss_det_solicitudes_t.ANO_ACTA         := v_sre_ciudadano.ANO_ACTA;
              v_nss_det_solicitudes_t.NUMERO_ACTA      := v_sre_ciudadano.NUMERO_ACTA;
              v_nss_det_solicitudes_t.FOLIO_ACTA       := v_sre_ciudadano.FOLIO_ACTA;
              v_nss_det_solicitudes_t.OFICIALIA_ACTA   := v_sre_ciudadano.OFICIALIA_ACTA;
              v_nss_det_solicitudes_t.LIBRO_ACTA       := v_sre_ciudadano.LIBRO_ACTA;
              v_nss_det_solicitudes_t.TIPO_LIBRO_ACTA  := v_sre_ciudadano.TIPO_LIBRO_ACTA;
              v_nss_det_solicitudes_t.LITERAL_ACTA     := v_sre_ciudadano.LITERAL_ACTA;
              v_nss_det_solicitudes_t.CEDULA_MADRE     := v_sre_ciudadano.CEDULA_MADRE;
              v_nss_det_solicitudes_t.CEDULA_PADRE     := v_sre_ciudadano.CEDULA_PADRE;
              v_nss_det_solicitudes_t.NOMBRE_MADRE     := v_sre_ciudadano.NOMBRE_MADRE;
              v_nss_det_solicitudes_t.NOMBRE_PADRE     := v_sre_ciudadano.NOMBRE_PADRE;
              v_nss_det_solicitudes_t.ESTADO_CIVIL     := v_sre_ciudadano.ESTADO_CIVIL;
              v_nss_det_solicitudes_t.ID_NACIONALIDAD  := v_sre_ciudadano.ID_NACIONALIDAD;
                      
              --Como va para evaluacion visual, debo llenar los campos que trae el WEBSERVICE de la JCE
              UPDATE suirplus.nss_det_solicitudes_t d
                 SET ROW = v_nss_det_solicitudes_t
               WHERE d.id_registro = C_SOL.ID_REGISTRO;
                      
              --Actualizamos la solicitud
              SUIRPLUS.NSS_ACTUALIZAR_SOLICITUD(C_SOL.ID_REGISTRO, 4, 'NSS404', v_sre_ciudadano.ID_NSS, p_ult_usuario_act, p_resultado); --Pendiente de Evaluación Visual
                      
              IF V_RESULTADO <> 'OK' THEN
                -- Grabar fin seguimiento en detalle de bitacora
                suirplus.detalle_bitacora(v_id_bitacora,
                                          sysdate,
                                          SUBSTR('Solicitud ASIGNACION NSS A MENOR CON NUI #'||to_char(P_ID_SOLICITUD)||': ignorada.'||chr(13)||chr(10)||
                                          'MOTIVO: '||p_resultado,1,500));
              ELSE
                -- Grabar primer seguimiento en detalle de bitacora
                suirplus.detalle_bitacora(v_id_bitacora,
                                          sysdate,
                                          SUBSTR('Solicitud ASIGNACION NSS A MENOR CON NUI #'||to_char(P_ID_SOLICITUD)||': puesta en evaluacion visual.',1,500));
              END IF;
            END;  
          ELSE
            -- Insertamos en el detalle de Evaluacion Visual
            SUIRPLUS.NSS_INSERTAR_EVALUACION_VISUAL
             ('D',
              NULL,
              R.ID_NSS,
              C_SOL.NO_DOCUMENTO_SOL,
              NULL,
              NULL,
              V_ID_EVALUACION,
              V_RESULTADO
             );
          END IF;
        END LOOP;
        
        CONTINUE; -- Pasamos al proximo registro
      ELSIF v_conteo = 1 THEN
        v_sre_ciudadano.ID_NSS := v_nss_dup; --Se actualiza a NUI
                    
        -- Actualizar en CIUDADANO
        SUIRPLUS.NSS_ACTUALIZAR_CIUDADANO(C_SOL.ID_REGISTRO, v_sre_ciudadano, p_ult_usuario_act, p_resultado);
                    
        IF p_resultado <> 'OK' THEN
          -- Grabar fin seguimiento en detalle de bitacora
          suirplus.detalle_bitacora(v_id_bitacora,
                                    sysdate,
                                    SUBSTR('Solicitud ASIGNACION NSS A MENOR CON NUI #'||to_char(P_ID_SOLICITUD)||': ignorada.'||chr(13)||chr(10)||
                                    'MOTIVO: '||p_resultado,1,500));
        ELSE
          -- Grabar primer seguimiento en detalle de bitacora
          suirplus.detalle_bitacora(v_id_bitacora,
                                    sysdate,
                                    SUBSTR('Solicitud ASIGNACION NSS A MENOR CON NUI #'||to_char(P_ID_SOLICITUD)||': actualizo en ciudadano.',1,500));
        END IF;
                  
        CONTINUE; -- Pasamos al proximo registro
      END IF;
               
      --Si llega hasta aqui, creamos el cuidadano
      SUIRPLUS.NSS_INSERTAR_CIUDADANO(C_SOL.ID_REGISTRO, v_sre_ciudadano, p_ult_usuario_act, p_resultado);
              
      IF p_resultado <> 'OK' THEN
        -- Grabar fin seguimiento en detalle de bitacora
        suirplus.detalle_bitacora(v_id_bitacora,
                                  sysdate,
                                  SUBSTR('Solicitud ASIGNACION NSS A MENOR CON NUI #'||to_char(P_ID_SOLICITUD)||': ignorada.'||chr(13)||chr(10)||
                                  'MOTIVO: '||p_resultado,1,500));
      ELSE
        -- Grabar primer seguimiento en detalle de bitacora
        suirplus.detalle_bitacora(v_id_bitacora,
                                  sysdate,
                                  SUBSTR('Solicitud ASIGNACION NSS A MENOR CON NUI #'||to_char(P_ID_SOLICITUD)||': creo el ciudadano.',1,500));
      END IF;
    EXCEPTION WHEN OTHERS THEN
      p_resultado := SQLERRM||' - '||dbms_utility.format_error_backtrace;
      
      -- Grabar primer seguimiento en detalle de bitacora
      suirplus.detalle_bitacora(v_id_bitacora,
                                sysdate,
                                SUBSTR('Solicitud ASIGNACION NSS A MENOR CON NUI #'||to_char(P_ID_SOLICITUD)||': ignorada por error: '||p_resultado,1,500));
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
  WHEN e_tipo_sol_no_existe THEN
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