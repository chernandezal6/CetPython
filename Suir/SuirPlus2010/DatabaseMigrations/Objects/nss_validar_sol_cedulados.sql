CREATE OR REPLACE PROCEDURE SUIRPLUS.NSS_VALIDAR_SOL_CEDULADOS
(
 p_id_solicitud in suirplus.nss_solicitudes_t.id_solicitud%type,
 p_ult_usuario_act in suirplus.seg_usuario_t.id_usuario%type,
 p_resultado out varchar2
) IS
  v_id_bitacora      suirplus.sfc_bitacora_t.id_bitacora%type;
  v_id_proceso       suirplus.sfc_procesos_t.id_proceso%TYPE := '74'; --Validar solicitud nss a CEDULADOS
  v_nss_dup          suirplus.sre_ciudadanos_t.id_nss%Type;
  v_id_evaluacion    suirplus.nss_evaluacion_visual_t.id_evaluacion%Type;
  v_id_registro      suirplus.nss_det_solicitudes_t.id_registro%type;
  
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
    else
      validacion := 'S';  -- Fecha Validad
    end if;
    
    return validacion;
  exception when others  then
    return 'N';
  end;  
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
     And s.id_tipo = 3; -- Solicitud NSS A CEDULADO

  IF v_conteo = 0 THEN
    RAISE e_tipo_sol_no_existe;
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
      --Para retener el id_registro actual para reportarlo en el when other del exception
      v_id_registro := C_SOL.ID_REGISTRO;

      -- Buscamos duplicado por tipo y nro documento en varias solicitudes en estatus 'PE' O 'EV'
      Select count(*)
        Into v_conteo
        From suirplus.nss_solicitudes_t s
        Join suirplus.nss_det_solicitudes_t d
          On d.id_solicitud = s.id_solicitud
         And d.id_estatus IN(1,4) -- Pendiente de procesar o enviado a evaluacion visual en detalle de solicitud
         And d.id_tipo_documento = C_SOL.ID_TIPO_DOCUMENTO
         And d.no_documento_sol  = C_SOL.NO_DOCUMENTO_SOL
         And d.id_registro < C_SOL.ID_REGISTRO -- Diferente al regitro del cursor
       Where s.id_tipo = 3;  -- Solicitud NSS A CEDULADO

      --433: Si existe una solicitud identica, pero creada anteriormente, rechazo la que estoy procesando
      IF v_conteo >= 1 THEN
        SUIRPLUS.NSS_ACTUALIZAR_SOLICITUD(C_SOL.ID_REGISTRO, 6, 'NSS403', NULL, p_ult_usuario_act, p_resultado);
         
        IF p_resultado <> 'OK' THEN
          -- Grabar fin seguimiento en detalle de bitacora
          suirplus.detalle_bitacora(v_id_bitacora,
                                    sysdate,
                                    SUBSTR('Solicitud ASIGNACION NSS A CEDULADO, ID_SOLICITUD #'||to_char(P_ID_SOLICITUD)||', ID_REGISTRO #'||to_char(C_SOL.ID_REGISTRO)||': ignorada ('||to_char(sysdate,'dd/mm/yyyy hh:mi:ss am')||').'||chr(13)||chr(10)||
                                    'MOTIVO: '||p_resultado,1,500));
        ELSE
          -- Grabar primer seguimiento en detalle de bitacora
          suirplus.detalle_bitacora(v_id_bitacora,
                                    sysdate,
                                    SUBSTR('Solicitud ASIGNACION NSS A CEDULADO, ID_SOLICITUD #'||to_char(P_ID_SOLICITUD)||', ID_REGISTRO #'||to_char(C_SOL.ID_REGISTRO)||': rechazada ('||to_char(sysdate,'dd/mm/yyyy hh:mi:ss am')||').'||chr(13)||chr(10)||
                                    'MOTIVO: '||Suirplus.Seg_Retornar_Cadena_Error('NSS403', NULL, NULL),1,500));
        END IF;

        -- Pasamos al proximo registro
        CONTINUE;
      END IF;

      --310: Validar la longitud sea 11 (campo solo número), responder RE a UNIPAGO.
      IF (NOT REGEXP_LIKE(C_SOL.NO_DOCUMENTO_SOL, '^\d{11}$')) THEN
        SUIRPLUS.NSS_ACTUALIZAR_SOLICITUD(C_SOL.ID_REGISTRO, 6, 'NSS402', NULL, p_ult_usuario_act, p_resultado);

        IF p_resultado <> 'OK' THEN
          -- Grabar fin seguimiento en detalle de bitacora
          suirplus.detalle_bitacora(v_id_bitacora,
                                    sysdate,
                                    SUBSTR('Solicitud ASIGNACION NSS A CEDULADO, ID_SOLICITUD #'||to_char(P_ID_SOLICITUD)||', ID_REGISTRO #'||to_char(C_SOL.ID_REGISTRO)||': ignorada  ('||to_char(sysdate,'dd/mm/yyyy hh:mi:ss am')||').'||chr(13)||chr(10)||
                                    'MOTIVO: '||p_resultado,1,500));
        ELSE
          -- Grabar primer seguimiento en detalle de bitacora
          suirplus.detalle_bitacora(v_id_bitacora,
                                    sysdate,
                                    SUBSTR('Solicitud ASIGNACION NSS A CEDULADO, ID_SOLICITUD #'||to_char(P_ID_SOLICITUD)||', ID_REGISTRO #'||to_char(C_SOL.ID_REGISTRO)||': rechazada ('||to_char(sysdate,'dd/mm/yyyy hh:mi:ss am')||').'||chr(13)||chr(10)||
                                    'MOTIVO: '||Suirplus.Seg_Retornar_Cadena_Error('NSS402', NULL, NULL),1,500));
        END IF;

        -- Pasamos al proximo registro
        CONTINUE;
      END IF;

      -- Llamamos WEBSERVICE de la JCE para CEDULADO
      v_jce_respuesta := suirplus.NSS_WEBSERVICE_JCE_CED(C_SOL.NO_DOCUMENTO_SOL);
          
      -- J01: Si no encuentra el documento en la JCE
      IF (v_jce_respuesta LIKE '%<MESSAGE>%IS NOT FOUND</MESSAGE>%') THEN
        SUIRPLUS.NSS_ACTUALIZAR_SOLICITUD(C_SOL.ID_REGISTRO, 6, 'NSS501', NULL, p_ult_usuario_act, p_resultado);

        IF p_resultado <> 'OK' THEN
          -- Grabar fin seguimiento en detalle de bitacora
          suirplus.detalle_bitacora(v_id_bitacora,
                                    sysdate,
                                    SUBSTR('Solicitud ASIGNACION NSS A CEDULADO, ID_SOLICITUD #'||to_char(P_ID_SOLICITUD)||', ID_REGISTRO #'||to_char(C_SOL.ID_REGISTRO)||': ignorada ('||to_char(sysdate,'dd/mm/yyyy hh:mi:ss am')||').'||chr(13)||chr(10)||
                                    'MOTIVO: '||p_resultado,1,500));
        ELSE
          -- Grabar primer seguimiento en detalle de bitacora
          suirplus.detalle_bitacora(v_id_bitacora,
                                    sysdate,
                                    SUBSTR('Solicitud ASIGNACION NSS A CEDULADO, ID_SOLICITUD #'||to_char(P_ID_SOLICITUD)||', ID_REGISTRO #'||to_char(C_SOL.ID_REGISTRO)||': rechazada ('||to_char(sysdate,'dd/mm/yyyy hh:mi:ss am')||').'||chr(13)||chr(10)||
                                    'MOTIVO: '||Suirplus.Seg_Retornar_Cadena_Error('NSS501', NULL, NULL),1,500));
        END IF;

        -- Pasamos al proximo registro
        CONTINUE;
      END IF;
      
      v_sre_ciudadano.TIPO_DOCUMENTO       := C_SOL.ID_TIPO_DOCUMENTO;
      v_sre_ciudadano.NO_DOCUMENTO         := C_SOL.NO_DOCUMENTO_SOL;
      v_sre_ciudadano.NOMBRES              := SUIRPLUS.NSS_PARSEAR_CED(v_jce_respuesta, 'nombres');
      v_sre_ciudadano.PRIMER_APELLIDO      := SUIRPLUS.NSS_PARSEAR_CED(v_jce_respuesta, 'apellido1');
      v_sre_ciudadano.SEGUNDO_APELLIDO     := SUIRPLUS.NSS_PARSEAR_CED(v_jce_respuesta, 'apellido2');
      v_sre_ciudadano.FECHA_NACIMIENTO     := TO_DATE(NSS_PARSEAR_CED(v_jce_respuesta, 'fecha_nac'),'MM/DD/YYYY HH:MI:SS AM');
      v_sre_ciudadano.ESTADO_CIVIL         := SUIRPLUS.NSS_PARSEAR_CED(v_jce_respuesta, 'est_civil');
      v_sre_ciudadano.ID_NACIONALIDAD      := SUIRPLUS.NSS_PARSEAR_CED(v_jce_respuesta, 'cod_nacion');
      v_sre_ciudadano.ID_TIPO_SANGRE       := SUIRPLUS.NSS_PARSEAR_CED(v_jce_respuesta, 'cod_sangre');
      v_sre_ciudadano.TIPO_CAUSA           := SUIRPLUS.NSS_PARSEAR_CED(v_jce_respuesta, 'tipo_causa');
      v_sre_ciudadano.ID_CAUSA_INHABILIDAD := SUIRPLUS.NSS_PARSEAR_CED(v_jce_respuesta, 'cod_causa');
      v_sre_ciudadano.FECHA_CANCELACION_JCE:= TO_DATE(SUIRPLUS.NSS_PARSEAR_CED(v_jce_respuesta, 'fecha_cancelacion'),'MM/DD/YYYY HH:MI:SS AM');
      v_sre_ciudadano.STATUS               := SUIRPLUS.NSS_PARSEAR_CED(v_jce_respuesta, 'estatus');    
      v_sre_ciudadano.SEXO                 := SUIRPLUS.NSS_PARSEAR_CED(v_jce_respuesta, 'sexo');
      v_sre_ciudadano.NUMERO_ACTA          := SUIRPLUS.NSS_VALIDACIONES_PKG.LIMPIAR_NUMERO_ACTA(SUIRPLUS.NSS_PARSEAR_CED(v_jce_respuesta, 'acta_numero'));
      v_sre_ciudadano.ANO_ACTA             := SUIRPLUS.NSS_VALIDACIONES_PKG.LIMPIAR_ANO_ACTA(SUIRPLUS.NSS_PARSEAR_CED(v_jce_respuesta, 'acta_ano'));
      v_sre_ciudadano.MUNICIPIO_ACTA       := SUIRPLUS.NSS_VALIDACIONES_PKG.LIMPIAR_MUNICIPIO_ACTA(SUIRPLUS.NSS_PARSEAR_CED(v_jce_respuesta, 'acta_mun'));
      v_sre_ciudadano.OFICIALIA_ACTA       := SUIRPLUS.NSS_VALIDACIONES_PKG.LIMPIAR_OFICIALIA_ACTA(SUIRPLUS.NSS_PARSEAR_CED(v_jce_respuesta, 'acta_ofic'));
      v_sre_ciudadano.FOLIO_ACTA           := SUIRPLUS.NSS_VALIDACIONES_PKG.LIMPIAR_FOLIO_ACTA(SUIRPLUS.NSS_PARSEAR_CED(v_jce_respuesta, 'acta_folio'));
      v_sre_ciudadano.LIBRO_ACTA           := SUIRPLUS.NSS_VALIDACIONES_PKG.LIMPIAR_LIBRO_ACTA(SUIRPLUS.NSS_PARSEAR_CED(v_jce_respuesta, 'acta_libro'), v_sre_ciudadano.ANO_ACTA);
      v_sre_ciudadano.TIPO_LIBRO_ACTA      := SUIRPLUS.NSS_PARSEAR_CED(v_jce_respuesta, 'tipo_libro');
      
      --Para sanear los casos de cedulas mayores de 11 digitos
      --Esto porque se esta poniendo el valor que viene de la JCE
      --En un campo tipo SRE_CIUDADANOS_T.cedula_padre
      BEGIN
        v_sre_ciudadano.CEDULA_PADRE := TRIM(REPLACE(SUIRPLUS.NSS_PARSEAR_CED(v_jce_respuesta, 'cedula_padre'),'-',''));
      EXCEPTION WHEN OTHERS THEN
        v_sre_ciudadano.CEDULA_PADRE := NULL;
      END;
        
      BEGIN
        v_sre_ciudadano.NUMERO_EVENTO := SUIRPLUS.NSS_PARSEAR_CED(v_jce_respuesta, 'acta_automatizada');
      EXCEPTION WHEN OTHERS THEN
        v_sre_ciudadano.NUMERO_EVENTO := NULL;
      END;
      --Para sanear los casos de cedulas mayores de 11 digitos
      --Esto porque se esta poniendo el valor que viene de la JCE
      --En un campo tipo SRE_CIUDADANOS_T.cedula_madre
      BEGIN
        v_sre_ciudadano.CEDULA_MADRE := TRIM(REPLACE(SUIRPLUS.NSS_PARSEAR_CED(v_jce_respuesta, 'cedula_madre'),'-',''));
      EXCEPTION WHEN OTHERS THEN
        v_sre_ciudadano.CEDULA_MADRE := NULL;
      END;
      
      v_sre_ciudadano.NOMBRE_PADRE := TRIM(nvl(SUIRPLUS.NSS_PARSEAR_CED(v_jce_respuesta, 'padre_nombres'), ' ') ||' '||
                                           nvl(SUIRPLUS.NSS_PARSEAR_CED(v_jce_respuesta, 'padre_apellido1'), ' ')||' '||
                                           nvl(SUIRPLUS.NSS_PARSEAR_CED(v_jce_respuesta, 'padre_apellido2'), ' '));    
      v_sre_ciudadano.NOMBRE_MADRE := TRIM(nvl(SUIRPLUS.NSS_PARSEAR_CED(v_jce_respuesta, 'madre_nombres'), ' ') ||' '||
                                           nvl(SUIRPLUS.NSS_PARSEAR_CED(v_jce_respuesta, 'madre_apellido1'), ' ')||' '||
                                           nvl(SUIRPLUS.NSS_PARSEAR_CED(v_jce_respuesta, 'madre_apellido2'), ' '));
      
      -- Cedula padre debe ser de 11 digitos
      IF (NOT REGEXP_LIKE(v_sre_ciudadano.CEDULA_PADRE, '^\d{11}$')) THEN
        v_sre_ciudadano.CEDULA_PADRE := null;
      END IF;
               
      -- Cedula madre debe ser de 11 digitos
      IF (NOT REGEXP_LIKE(v_sre_ciudadano.CEDULA_MADRE, '^\d{11}$')) THEN
        v_sre_ciudadano.CEDULA_MADRE := null;
      END IF;

      -- Validar fecha JCE canceló el documento
      IF (validar_fecha(v_sre_ciudadano.FECHA_CANCELACION_JCE) = 'N') THEN
        v_sre_ciudadano.FECHA_CANCELACION_JCE := null;
      END IF;
      
      -- Validar estado Civil              
      IF (nvl(v_sre_ciudadano.ESTADO_CIVIL,'~') NOT IN ('~','S','C','D')) THEN
        v_sre_ciudadano.ESTADO_CIVIL := null;
      END IF;
      
      -- si no está el codigo sanguineo
      IF (v_sre_ciudadano.ID_TIPO_SANGRE IS NOT NULL) THEN
        SELECT COUNT(*) 
        INTO v_conteo
        FROM suirplus.sre_tipo_sangre_t i
        WHERE i.id_tipo_sangre = v_sre_ciudadano.ID_TIPO_SANGRE;
                  
        IF (v_conteo=0) THEN
          INSERT INTO suirplus.sre_tipo_sangre_t i (
            id_tipo_sangre, tipo_sangre_des, ult_fecha_act, ult_usuario_act
          ) VALUES (
            v_sre_ciudadano.ID_TIPO_SANGRE, 'DESCONOCIDO', SYSDATE, p_ult_usuario_act
          );

          COMMIT;
        END IF;      
      END IF;
      
      -- si no está la nacionalidad 
      IF (v_sre_ciudadano.ID_NACIONALIDAD IS NOT NULL) THEN
        SELECT COUNT(*) 
        INTO v_conteo
        FROM suirplus.sre_nacionalidad_t i
        WHERE i.id_nacionalidad = v_sre_ciudadano.ID_NACIONALIDAD;
                  
        IF (v_conteo=0) THEN
          INSERT INTO suirplus.sre_nacionalidad_t i (
            id_nacionalidad, nacionalidad_des, pais_nacionalidad, ult_fecha_act, ult_usuario_act
          ) VALUES (
            v_sre_ciudadano.ID_NACIONALIDAD, 'DESCONOCIDO', 'DESCONOCIDO', SYSDATE, p_ult_usuario_act
          );
    
          COMMIT;
        END IF;      
      END IF;    
      
      --si no está el codigo de cancelacion 
      IF (nvl(v_sre_ciudadano.TIPO_CAUSA,'~') NOT IN ('~','C','I')) THEN
        v_sre_ciudadano.TIPO_CAUSA           := null;
        v_sre_ciudadano.ID_CAUSA_INHABILIDAD := null;
      ELSIF (v_sre_ciudadano.TIPO_CAUSA IS NOT NULL AND v_sre_ciudadano.ID_CAUSA_INHABILIDAD IS NOT NULL) THEN
        BEGIN
          SELECT COUNT(*) 
          INTO v_conteo
          FROM suirplus.sre_inhabilidad_jce_t i
          WHERE i.tipo_causa = v_sre_ciudadano.TIPO_CAUSA
            and i.id_causa_inhabilidad = v_sre_ciudadano.ID_CAUSA_INHABILIDAD;
                    
          IF (v_conteo=0) THEN
            INSERT INTO suirplus.sre_inhabilidad_jce_t i (
              id_causa_inhabilidad, tipo_causa, cancelacion_des, ult_fecha_act, ult_usuario_act
            ) VALUES (
              v_sre_ciudadano.ID_CAUSA_INHABILIDAD, v_sre_ciudadano.TIPO_CAUSA, 'DESCONOCIDO', SYSDATE, p_ult_usuario_act
            );
            
            COMMIT;
          END IF;
        EXCEPTION WHEN OTHERS THEN
          v_sre_ciudadano.ID_CAUSA_INHABILIDAD := null;
        END;
      END IF;
      
      -- si no está el codigo de Municipio del Acta    
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
          (suirplus.Nss_Validaciones_Pkg.limpiar_municipio_acta(v_sre_ciudadano.MUNICIPIO_ACTA),
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
        --Actualizamos la solicitud  
        SUIRPLUS.NSS_ACTUALIZAR_SOLICITUD(C_SOL.ID_REGISTRO, 6, 'NSS502', NULL, p_ult_usuario_act, p_resultado);

        IF p_resultado <> 'OK' THEN
          -- Grabar fin seguimiento en detalle de bitacora
          suirplus.detalle_bitacora(v_id_bitacora,
                                    sysdate,
                                    SUBSTR('Solicitud ASIGNACION NSS A CEDULADO, ID_SOLICITUD #'||to_char(P_ID_SOLICITUD)||', ID_REGISTRO #'||to_char(C_SOL.ID_REGISTRO)||': ignorada ('||to_char(sysdate,'dd/mm/yyyy hh:mi:ss am')||').'||chr(13)||chr(10)||
                                    'MOTIVO: '||p_resultado,1,500));
        ELSE
          -- Grabar primer seguimiento en detalle de bitacora
          suirplus.detalle_bitacora(v_id_bitacora,
                                    sysdate,
                                    SUBSTR('Solicitud AASIGNACION NSS A CEDULADO, ID_SOLICITUD #'||to_char(P_ID_SOLICITUD)||', ID_REGISTRO #'||to_char(C_SOL.ID_REGISTRO)||': rechazada ('||to_char(sysdate,'dd/mm/yyyy hh:mi:ss am')||').'||chr(13)||chr(10)||
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
         And c.no_documento   = C_SOL.NO_DOCUMENTO_SOL
         And c.id_nss < 900000000;

      IF v_conteo > 0 THEN --Existe en ciudadanos
        Select count(*)
          Into v_conteo
          From suirplus.sre_ciudadanos_t c
         Where c.tipo_documento = C_SOL.ID_TIPO_DOCUMENTO
           And c.no_documento   = C_SOL.NO_DOCUMENTO_SOL
           And c.id_nss < 900000000         
           And (SUIRPLUS.NSS_VALIDACIONES_PKG.validar_inhabilidad_tss_act(c.id_causa_inhabilidad, c.tipo_causa) = 'S' or (c.id_causa_inhabilidad is null and c.tipo_causa is null)) --no Cancelado por la TSS
            or (c.id_causa_inhabilidad > 100 and c.tipo_causa = 'C' and (v_sre_ciudadano.id_causa_inhabilidad = 2 ) and v_sre_ciudadano.tipo_causa = 'C');
            
        IF v_conteo > 0 THEN
          v_sre_ciudadano.ID_NSS := v_nss_dup;     
          --Actualizamos el ciudadano en base a los datos de la JCE y la solicitud a: NSS ACTUALIZADO
          SUIRPLUS.NSS_ACTUALIZAR_CIUDADANO(C_SOL.ID_REGISTRO, v_sre_ciudadano, p_ult_usuario_act, p_resultado);

          IF p_resultado <> 'OK' THEN
            -- Grabar fin seguimiento en detalle de bitacora
            suirplus.detalle_bitacora(v_id_bitacora,
                                      sysdate,
                                      SUBSTR('Solicitud ASIGNACION NSS A CEDULADO, ID_SOLICITUD #'||to_char(P_ID_SOLICITUD)||', ID_REGISTRO #'||to_char(C_SOL.ID_REGISTRO)||': ignorada ('||to_char(sysdate,'dd/mm/yyyy hh:mi:ss am')||').'||chr(13)||chr(10)||
                                      'MOTIVO: '||p_resultado,1,500));
          ELSE
            -- Grabar primer seguimiento en detalle de bitacora
            suirplus.detalle_bitacora(v_id_bitacora,
                                      sysdate,
                                      SUBSTR('Solicitud ASIGNACION NSS A CEDULADO, ID_SOLICITUD #'||to_char(P_ID_SOLICITUD)||', ID_REGISTRO #'||to_char(C_SOL.ID_REGISTRO)||': procesada ('||to_char(sysdate,'dd/mm/yyyy hh:mi:ss am')||').',1,500));
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
                                      SUBSTR('Solicitud ASIGNACION NSS A CEDULADO, ID_SOLICITUD #'||to_char(P_ID_SOLICITUD)||', ID_REGISTRO #'||to_char(C_SOL.ID_REGISTRO)||': ignorada ('||to_char(sysdate,'dd/mm/yyyy hh:mi:ss am')||').'||chr(13)||chr(10)||
                                      'MOTIVO: '||p_resultado,1,500));
          ELSE
            -- Grabar primer seguimiento en detalle de bitacora
            suirplus.detalle_bitacora(v_id_bitacora,
                                      sysdate,
                                      SUBSTR('Solicitud ASIGNACION NSS A CEDULADO, ID_SOLICITUD #'||to_char(P_ID_SOLICITUD)||', ID_REGISTRO #'||to_char(C_SOL.ID_REGISTRO)||': rechazada ('||to_char(sysdate,'dd/mm/yyyy hh:mi:ss am')||').'||chr(13)||chr(10)||
                                      'MOTIVO: '||Suirplus.Seg_Retornar_Cadena_Error('NSS601', NULL, NULL),1,500));
          END IF;
              
          -- Pasamos al proximo registro
          CONTINUE;        
        END IF;    
      END IF;

      --Validar: TIPO DOCUMENTO, MUNICIPIO ACTA, ANIO ACTA, OFICIALIA ACTA, NOMBRES, PRIMER APELLIDO, SEGUNDO APELLIDO, SEXO, FECHA NACIMIENTO DUPLICADO
      --         COMO NUI
      SELECT COUNT(ID_NSS), MIN(ID_NSS)
        INTO v_conteo, v_nss_dup
        FROM suirplus.sre_ciudadanos_t
       WHERE no_documento = v_sre_ciudadano.NO_DOCUMENTO
          -- 
         AND tipo_documento = 'U'
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
         AND SUIRPLUS.NSS_VALIDACIONES_PKG.convertir_letra(NVL(segundo_apellido,'~')) = SUIRPLUS.NSS_VALIDACIONES_PKG.convertir_letra(NVL(v_sre_ciudadano.SEGUNDO_APELLIDO,'~'))
          --
         AND SUIRPLUS.NSS_VALIDACIONES_PKG.convertir_letra(sexo) = SUIRPLUS.NSS_VALIDACIONES_PKG.convertir_letra(v_sre_ciudadano.SEXO)
          --
         AND TRUNC(fecha_nacimiento) = TRUNC(v_sre_ciudadano.FECHA_NACIMIENTO)
          --
         AND SUIRPLUS.NSS_VALIDACIONES_PKG.validar_inhabilidad_tss(id_causa_inhabilidad, tipo_causa) = 'N'; --no inhabilitado en TSS
         
      -- Si existe solo una coincidencia, lo cambio a CEDULADO
      IF v_conteo = 1 THEN
        v_sre_ciudadano.ID_NSS := v_nss_dup; --Actualizamos a Cedulado
                
        -- Actualizar en CIUDADANO y la solicitud a: NSS ASIGNADO
        SUIRPLUS.NSS_ACTUALIZAR_CIUDADANO(C_SOL.ID_REGISTRO, v_sre_ciudadano, p_ult_usuario_act, p_resultado);
                
        IF p_resultado <> 'OK' THEN
          -- Grabar fin seguimiento en detalle de bitacora
          suirplus.detalle_bitacora(v_id_bitacora,
                                    sysdate,
                                    SUBSTR('Solicitud ASIGNACION NSS A CEDULADO, ID_SOLICITUD #'||to_char(P_ID_SOLICITUD)||', ID_REGISTRO #'||to_char(C_SOL.ID_REGISTRO)||': ignorada ('||to_char(sysdate,'dd/mm/yyyy hh:mi:ss am')||').'||chr(13)||chr(10)||
                                    'MOTIVO: '||p_resultado,1,500));
        ELSE
          -- Grabar primer seguimiento en detalle de bitacora
          suirplus.detalle_bitacora(v_id_bitacora,
                                    sysdate,
                                    SUBSTR('Solicitud ASIGNACION NSS A CEDULADO, ID_SOLICITUD #'||to_char(P_ID_SOLICITUD)||', ID_REGISTRO #'||to_char(C_SOL.ID_REGISTRO)||': actualizo en ciudadano ('||to_char(sysdate,'dd/mm/yyyy hh:mi:ss am')||').',1,500));
        END IF;
          
        -- Pasamos al proximo registro
        CONTINUE;        
      END IF;

      -- Buscamos el mismo registro procesado, antes de los procesos de EVALUACION VISUAL.
      -- Esto ocurre si lanzan dos veces esta validacion para una solicitud con multiples cedulas que tarde en procesarse.
      -- El cursor puede tener varios registros en estatus pendiente, pero una puede procesarla primero que la otra.
      -- En este caso, antes de procesarla hay que ver si ya cambio su estatus de pendiente.
      -- Con esto se evita el caso comun de tener duplicidad en el maestro y detalle de evaluacion visual para una misma solicitud.
      Select count(*)
        Into v_conteo
        From suirplus.nss_solicitudes_t s
        Join suirplus.nss_det_solicitudes_t d
          On d.id_solicitud = s.id_solicitud
         And d.id_estatus <> 1 -- ya procesada
         And d.id_tipo_documento = C_SOL.ID_TIPO_DOCUMENTO
         And d.no_documento_sol  = C_SOL.NO_DOCUMENTO_SOL
         And d.id_registro = C_SOL.ID_REGISTRO -- Diferente al regitro del cursor
       Where s.id_tipo = 3;  -- Solicitud NSS A CEDULADO

      -- Si existe el mismo registro procesado, no tomo ninguna accion, pero dejo rastro en bitacora y paso al siguiente registro
      IF v_conteo >= 1 THEN
        -- Grabar fin seguimiento en detalle de bitacora
        suirplus.detalle_bitacora(v_id_bitacora,
                                  sysdate,
                                  SUBSTR('Solicitud ASIGNACION NSS A CEDULADO #'||to_char(P_ID_SOLICITUD)||', ID_REGISTRO #'||to_char(C_SOL.ID_REGISTRO)||' ha sido procesada anteriormente.',1,500));

        -- Pasamos al proximo registro
        CONTINUE;
      END IF;

      --Validar: PRIMER NOMBRE, PRIMER APELLIDO, FECHA NACIMIENTO, SEXO, ACTA DE NACIMIENTO, TIPO DOCUMENTO y NUMERO DOCUMENTO DUPLICADO
      --Validar: TIPO DOCUMENTO, MUNICIPIO ACTA, ANIO ACTA, OFICIALIA ACTA, NOMBRES, PRIMER APELLIDO, SEGUNDO APELLIDO, SEXO, FECHA NACIMIENTO DUPLICADO

      --         COMO MENOR NACIONAL SIN DOCUMENTO
      SELECT COUNT(ID_NSS), MIN(ID_NSS)
        INTO v_conteo, v_nss_dup
        FROM suirplus.sre_ciudadanos_t
       WHERE tipo_documento = 'N'
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
         AND SUIRPLUS.NSS_VALIDACIONES_PKG.convertir_letra(NVL(segundo_apellido,'~')) = SUIRPLUS.NSS_VALIDACIONES_PKG.convertir_letra(NVL(v_sre_ciudadano.SEGUNDO_APELLIDO,'~'))
          --
         AND SUIRPLUS.NSS_VALIDACIONES_PKG.convertir_letra(sexo) = SUIRPLUS.NSS_VALIDACIONES_PKG.convertir_letra(v_sre_ciudadano.SEXO)
          --
         AND TRUNC(fecha_nacimiento) = TRUNC(v_sre_ciudadano.FECHA_NACIMIENTO)
          --
         AND SUIRPLUS.NSS_VALIDACIONES_PKG.validar_inhabilidad_tss(id_causa_inhabilidad, tipo_causa) = 'N'; --no inhabilitado en TSS

      IF v_conteo = 1 THEN
        v_sre_ciudadano.ID_NSS := v_nss_dup; --Actualizar a Cedulado
                
        -- Actualizar en CIUDADANO y la solicitud a: NSS ASIGNADO
        SUIRPLUS.NSS_ACTUALIZAR_CIUDADANO(C_SOL.ID_REGISTRO, v_sre_ciudadano, p_ult_usuario_act, p_resultado);
                
        IF p_resultado <> 'OK' THEN
          -- Grabar fin seguimiento en detalle de bitacora
          suirplus.detalle_bitacora(v_id_bitacora,
                                    sysdate,
                                    SUBSTR('Solicitud ASIGNACION NSS A CEDULADO, ID_SOLICITUD #'||to_char(P_ID_SOLICITUD)||', ID_REGISTRO #'||to_char(C_SOL.ID_REGISTRO)||': ignorada ('||to_char(sysdate,'dd/mm/yyyy hh:mi:ss am')||').'||chr(13)||chr(10)||
                                    'MOTIVO: '||p_resultado,1,500));
        ELSE
          -- Grabar primer seguimiento en detalle de bitacora
          suirplus.detalle_bitacora(v_id_bitacora,
                                    sysdate,
                                    SUBSTR('Solicitud ASIGNACION NSS A CEDULADO, ID_SOLICITUD #'||to_char(P_ID_SOLICITUD)||', ID_REGISTRO #'||to_char(C_SOL.ID_REGISTRO)||': actualizo en ciudadano ('||to_char(sysdate,'dd/mm/yyyy hh:mi:ss am')||').',1,500));
        END IF;

        -- Pasamos al proximo registro
        CONTINUE;
      ELSIF v_conteo > 1 THEN
        -- Poner solicitud en evaluacion visual con los NSS que coinciden
        -- Insertamos la solicitud en el maestro de Evaluacion Visual
        v_id_evaluacion := NULL;
        FOR R IN
          (
            SELECT id_nss
              FROM suirplus.sre_ciudadanos_t
             WHERE tipo_documento = 'N'
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
               AND SUIRPLUS.NSS_VALIDACIONES_PKG.convertir_letra(NVL(segundo_apellido,'~')) = SUIRPLUS.NSS_VALIDACIONES_PKG.convertir_letra(NVL(v_sre_ciudadano.SEGUNDO_APELLIDO,'~'))
                --
               AND SUIRPLUS.NSS_VALIDACIONES_PKG.convertir_letra(sexo) = SUIRPLUS.NSS_VALIDACIONES_PKG.convertir_letra(v_sre_ciudadano.SEXO)
                --
               AND TRUNC(fecha_nacimiento) = TRUNC(v_sre_ciudadano.FECHA_NACIMIENTO)
                --
               AND SUIRPLUS.NSS_VALIDACIONES_PKG.validar_inhabilidad_tss(id_causa_inhabilidad, tipo_causa) = 'N' --no inhabilitado en TSS
             ORDER BY id_nss
          ) 
        LOOP      
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
              v_nss_det_solicitudes_t.NOMBRES               := v_sre_ciudadano.NOMBRES;
              v_nss_det_solicitudes_t.PRIMER_APELLIDO       := v_sre_ciudadano.PRIMER_APELLIDO;
              v_nss_det_solicitudes_t.SEGUNDO_APELLIDO      := v_sre_ciudadano.SEGUNDO_APELLIDO;
              v_nss_det_solicitudes_t.FECHA_NACIMIENTO      := v_sre_ciudadano.FECHA_NACIMIENTO;
              v_nss_det_solicitudes_t.SEXO                  := v_sre_ciudadano.SEXO;
              v_nss_det_solicitudes_t.MUNICIPIO_ACTA        := v_sre_ciudadano.MUNICIPIO_ACTA;
              v_nss_det_solicitudes_t.ANO_ACTA              := v_sre_ciudadano.ANO_ACTA;
              v_nss_det_solicitudes_t.NUMERO_ACTA           := v_sre_ciudadano.NUMERO_ACTA;
              v_nss_det_solicitudes_t.FOLIO_ACTA            := v_sre_ciudadano.FOLIO_ACTA;
              v_nss_det_solicitudes_t.OFICIALIA_ACTA        := v_sre_ciudadano.OFICIALIA_ACTA;
              v_nss_det_solicitudes_t.LIBRO_ACTA            := v_sre_ciudadano.LIBRO_ACTA;
              v_nss_det_solicitudes_t.TIPO_LIBRO_ACTA       := v_sre_ciudadano.TIPO_LIBRO_ACTA;
              v_nss_det_solicitudes_t.LITERAL_ACTA          := v_sre_ciudadano.LITERAL_ACTA;
              v_nss_det_solicitudes_t.CEDULA_MADRE          := v_sre_ciudadano.CEDULA_MADRE;
              v_nss_det_solicitudes_t.CEDULA_PADRE          := v_sre_ciudadano.CEDULA_PADRE;
              v_nss_det_solicitudes_t.NOMBRE_MADRE          := v_sre_ciudadano.NOMBRE_MADRE;
              v_nss_det_solicitudes_t.NOMBRE_PADRE          := v_sre_ciudadano.NOMBRE_PADRE;
              v_nss_det_solicitudes_t.ESTADO_CIVIL          := v_sre_ciudadano.ESTADO_CIVIL;
              v_nss_det_solicitudes_t.ID_NACIONALIDAD       := v_sre_ciudadano.ID_NACIONALIDAD;
              v_nss_det_solicitudes_t.TIPO_CAUSA            := v_sre_ciudadano.TIPO_CAUSA;
              v_nss_det_solicitudes_t.ID_CAUSA_INHABILIDAD  := v_sre_ciudadano.ID_CAUSA_INHABILIDAD;
              v_nss_det_solicitudes_t.FECHA_CANCELACION_JCE := v_sre_ciudadano.FECHA_CANCELACION_JCE;
              v_nss_det_solicitudes_t.ESTATUS_JCE           := v_sre_ciudadano.STATUS;
              v_nss_det_solicitudes_t.NUMERO_EVENTO         := v_sre_ciudadano.NUMERO_EVENTO;
                    
              --Como va para evaluacion visual, debo llenar los campos que trae el WEBSERVICE de la JCE
              UPDATE suirplus.nss_det_solicitudes_t d
                 SET ROW = v_nss_det_solicitudes_t
               WHERE d.id_registro = C_SOL.ID_REGISTRO;
                
              --Actualizamos la solicitud
              SUIRPLUS.NSS_ACTUALIZAR_SOLICITUD(C_SOL.ID_REGISTRO, 4, 'NSS404', v_sre_ciudadano.ID_NSS, p_ult_usuario_act, p_resultado); --Pendiente de Evaluación Visual
                    
              IF P_RESULTADO <> 'OK' THEN
                -- Grabar fin seguimiento en detalle de bitacora
                suirplus.detalle_bitacora(v_id_bitacora,
                                          sysdate,
                                          SUBSTR('Solicitud ASIGNACION NSS A CEDULADO, ID_SOLICITUD #'||to_char(P_ID_SOLICITUD)||', ID_REGISTRO #'||to_char(C_SOL.ID_REGISTRO)||': ignorada ('||to_char(sysdate,'dd/mm/yyyy hh:mi:ss am')||').'||chr(13)||chr(10)||
                                          'MOTIVO: '||p_resultado,1,500));
              ELSE
                -- Grabar primer seguimiento en detalle de bitacora
                suirplus.detalle_bitacora(v_id_bitacora,
                                          sysdate,
                                          SUBSTR('Solicitud ASIGNACION NSS A CEDULADO, ID_SOLICITUD #'||to_char(P_ID_SOLICITUD)||', ID_REGISTRO #'||to_char(C_SOL.ID_REGISTRO)||': puesta en evaluacion visual ('||to_char(sysdate,'dd/mm/yyyy hh:mi:ss am')||').',1,500));
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

        -- Pasamos al proximo registro
        CONTINUE;        
      END IF;

      --Validar: TIPO DOCUMENTO, NO DOCUMENTO (PRIMERO DOS DIGITOS = 88), NOMBRES, PRIMER APELLIDO, SEGUNDO APELLIDO, SEXO, FECHA NACIMIENTO DUPLICADO
      --         COMO TRABAJADOR EXTRANJERO
      SELECT COUNT(ID_NSS), MIN(ID_NSS)
        INTO v_conteo, v_nss_dup
        FROM suirplus.sre_ciudadanos_t
       WHERE tipo_documento = 'C'
          --
         AND SUBSTR(no_documento,1,2) = '88'
          --
         AND SUIRPLUS.NSS_VALIDACIONES_PKG.convertir_letra(nombres) = SUIRPLUS.NSS_VALIDACIONES_PKG.convertir_letra(v_sre_ciudadano.NOMBRES)
          --
         AND SUIRPLUS.NSS_VALIDACIONES_PKG.convertir_letra(primer_apellido) = SUIRPLUS.NSS_VALIDACIONES_PKG.convertir_letra(v_sre_ciudadano.PRIMER_APELLIDO)
          --
         AND SUIRPLUS.NSS_VALIDACIONES_PKG.convertir_letra(NVL(segundo_apellido,'~')) = SUIRPLUS.NSS_VALIDACIONES_PKG.convertir_letra(NVL(v_sre_ciudadano.SEGUNDO_APELLIDO,'~'))
          --
         AND SUIRPLUS.NSS_VALIDACIONES_PKG.convertir_letra(sexo) = SUIRPLUS.NSS_VALIDACIONES_PKG.convertir_letra(v_sre_ciudadano.SEXO)
          --
         AND TRUNC(fecha_nacimiento) = TRUNC(v_sre_ciudadano.FECHA_NACIMIENTO)
          --
         AND SUIRPLUS.NSS_VALIDACIONES_PKG.validar_inhabilidad_tss(id_causa_inhabilidad, tipo_causa) = 'N'; --no inhabilitado en TSS

      IF v_conteo = 1 THEN
        v_sre_ciudadano.ID_NSS := v_nss_dup; --Actualizar a Cedulado
                
        -- Actualizar en CIUDADANO y la solicitud a: NSS ASIGNADO
        SUIRPLUS.NSS_ACTUALIZAR_CIUDADANO(C_SOL.ID_REGISTRO, v_sre_ciudadano, p_ult_usuario_act, p_resultado);
                
        IF p_resultado <> 'OK' THEN
          -- Grabar fin seguimiento en detalle de bitacora
          suirplus.detalle_bitacora(v_id_bitacora,
                                    sysdate,
                                    SUBSTR('Solicitud ASIGNACION NSS A CEDULADO #'||to_char(P_ID_SOLICITUD)||': ignorada.'||chr(13)||chr(10)||
                                    'MOTIVO: '||p_resultado,1,500));
        ELSE
          -- Grabar primer seguimiento en detalle de bitacora
          suirplus.detalle_bitacora(v_id_bitacora,
                                    sysdate,
                                    SUBSTR('Solicitud ASIGNACION NSS A CEDULADO #'||to_char(P_ID_SOLICITUD)||': actualizo en ciudadano.',1,500));
        END IF;

        -- Pasamos al proximo registro
        CONTINUE;
      ELSIF v_conteo > 1 THEN
        -- Poner solicitud en evaluacion visual con los NSS que coinciden
        -- Insertamos la solicitud en el maestro de Evaluacion Visual
        v_id_evaluacion := NULL;
        FOR R IN
          (
            SELECT id_nss
              FROM suirplus.sre_ciudadanos_t
             WHERE tipo_documento = 'C'
                --
               AND SUBSTR(no_documento,1,2) = '88'
                --
               AND SUIRPLUS.NSS_VALIDACIONES_PKG.convertir_letra(nombres) = SUIRPLUS.NSS_VALIDACIONES_PKG.convertir_letra(v_sre_ciudadano.NOMBRES)
                --
               AND SUIRPLUS.NSS_VALIDACIONES_PKG.convertir_letra(primer_apellido) = SUIRPLUS.NSS_VALIDACIONES_PKG.convertir_letra(v_sre_ciudadano.PRIMER_APELLIDO)
                --
               AND SUIRPLUS.NSS_VALIDACIONES_PKG.convertir_letra(NVL(segundo_apellido,'~')) = SUIRPLUS.NSS_VALIDACIONES_PKG.convertir_letra(NVL(v_sre_ciudadano.SEGUNDO_APELLIDO,'~'))
                --
               AND SUIRPLUS.NSS_VALIDACIONES_PKG.convertir_letra(sexo) = SUIRPLUS.NSS_VALIDACIONES_PKG.convertir_letra(v_sre_ciudadano.SEXO)
                --
               AND TRUNC(fecha_nacimiento) = TRUNC(v_sre_ciudadano.FECHA_NACIMIENTO)
                --
               AND SUIRPLUS.NSS_VALIDACIONES_PKG.validar_inhabilidad_tss(id_causa_inhabilidad, tipo_causa) = 'N' --no inhabilitado en TSS
             ORDER BY id_nss
          ) 
        LOOP      
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
              v_nss_det_solicitudes_t.NOMBRES               := v_sre_ciudadano.NOMBRES;
              v_nss_det_solicitudes_t.PRIMER_APELLIDO       := v_sre_ciudadano.PRIMER_APELLIDO;
              v_nss_det_solicitudes_t.SEGUNDO_APELLIDO      := v_sre_ciudadano.SEGUNDO_APELLIDO;
              v_nss_det_solicitudes_t.FECHA_NACIMIENTO      := v_sre_ciudadano.FECHA_NACIMIENTO;
              v_nss_det_solicitudes_t.SEXO                  := v_sre_ciudadano.SEXO;
              v_nss_det_solicitudes_t.MUNICIPIO_ACTA        := v_sre_ciudadano.MUNICIPIO_ACTA;
              v_nss_det_solicitudes_t.ANO_ACTA              := v_sre_ciudadano.ANO_ACTA;
              v_nss_det_solicitudes_t.NUMERO_ACTA           := v_sre_ciudadano.NUMERO_ACTA;
              v_nss_det_solicitudes_t.FOLIO_ACTA            := v_sre_ciudadano.FOLIO_ACTA;
              v_nss_det_solicitudes_t.OFICIALIA_ACTA        := v_sre_ciudadano.OFICIALIA_ACTA;
              v_nss_det_solicitudes_t.LIBRO_ACTA            := v_sre_ciudadano.LIBRO_ACTA;
              v_nss_det_solicitudes_t.TIPO_LIBRO_ACTA       := v_sre_ciudadano.TIPO_LIBRO_ACTA;
              v_nss_det_solicitudes_t.LITERAL_ACTA          := v_sre_ciudadano.LITERAL_ACTA;
              v_nss_det_solicitudes_t.CEDULA_MADRE          := v_sre_ciudadano.CEDULA_MADRE;
              v_nss_det_solicitudes_t.CEDULA_PADRE          := v_sre_ciudadano.CEDULA_PADRE;
              v_nss_det_solicitudes_t.NOMBRE_MADRE          := v_sre_ciudadano.NOMBRE_MADRE;
              v_nss_det_solicitudes_t.NOMBRE_PADRE          := v_sre_ciudadano.NOMBRE_PADRE;
              v_nss_det_solicitudes_t.ESTADO_CIVIL          := v_sre_ciudadano.ESTADO_CIVIL;
              v_nss_det_solicitudes_t.ID_NACIONALIDAD       := v_sre_ciudadano.ID_NACIONALIDAD;
              v_nss_det_solicitudes_t.TIPO_CAUSA            := v_sre_ciudadano.TIPO_CAUSA;
              v_nss_det_solicitudes_t.ID_CAUSA_INHABILIDAD  := v_sre_ciudadano.ID_CAUSA_INHABILIDAD;
              v_nss_det_solicitudes_t.FECHA_CANCELACION_JCE := v_sre_ciudadano.FECHA_CANCELACION_JCE;
              v_nss_det_solicitudes_t.ESTATUS_JCE           := v_sre_ciudadano.STATUS;
              v_nss_det_solicitudes_t.NUMERO_EVENTO         := v_sre_ciudadano.NUMERO_EVENTO;
                    
              --Como va para evaluacion visual, debo llenar los campos que trae el WEBSERVICE de la JCE
              UPDATE suirplus.nss_det_solicitudes_t d
                 SET ROW = v_nss_det_solicitudes_t
               WHERE d.id_registro = C_SOL.ID_REGISTRO;
                
              --Actualizamos la solicitud
              SUIRPLUS.NSS_ACTUALIZAR_SOLICITUD(C_SOL.ID_REGISTRO, 4, 'NSS404', v_sre_ciudadano.ID_NSS, p_ult_usuario_act, p_resultado); --Pendiente de Evaluación Visual
                    
              IF P_RESULTADO <> 'OK' THEN
                -- Grabar fin seguimiento en detalle de bitacora
                suirplus.detalle_bitacora(v_id_bitacora,
                                          sysdate,
                                          SUBSTR('Solicitud ASIGNACION NSS A CEDULADO #'||to_char(P_ID_SOLICITUD)||': ignorada.'||chr(13)||chr(10)||
                                          'MOTIVO: '||p_resultado,1,500));
              ELSE
                -- Grabar primer seguimiento en detalle de bitacora
                suirplus.detalle_bitacora(v_id_bitacora,
                                          sysdate,
                                          SUBSTR('Solicitud ASIGNACION NSS A CEDULADO #'||to_char(P_ID_SOLICITUD)||': puesta en evaluacion visual.',1,500));
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

        -- Pasamos al proximo registro
        CONTINUE;
      ELSE
        --Buscarlo como pasaporte con el mismo numero de documento
        SELECT COUNT(ID_NSS)
        INTO v_conteo
        FROM suirplus.sre_ciudadanos_t
        WHERE id_nss       >= 900000000 
          AND no_documento = v_sre_ciudadano.NO_DOCUMENTO;
        
        IF v_conteo > 0 THEN
          FOR R IN (SELECT * 
                      FROM suirplus.sre_ciudadanos_t
                     WHERE id_nss       >= 900000000 
                       AND no_documento = v_sre_ciudadano.NO_DOCUMENTO
                   ) LOOP
            -- Crear el registro en historico de documento antes de actualizar
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
            VALUES
            (
             suirplus.sre_his_documentos_t_seq.nextval,
             r.id_nss,
             r.tipo_documento,
             r.no_documento,
             SYSDATE,
             'A', --A=Activo
             p_ult_usuario_act,
             SYSDATE,
             SYSDATE,
             p_ult_usuario_act
            );
                        
            --Actualizamos el ciudadano, falta cancelar el ciudadano   
            UPDATE suirplus.sre_ciudadanos_t
            SET tipo_documento = 'P',
                no_documento   = 'P'||TRIM(TO_CHAR(id_nss))
            WHERE id_nss = R.id_nss;
          END LOOP;
        ELSE
          --Buscarlo por numero de documento
          SELECT COUNT(ID_NSS)
            INTO v_conteo
            FROM suirplus.sre_ciudadanos_t
           WHERE no_documento = v_sre_ciudadano.NO_DOCUMENTO;
          
          IF v_conteo > 0 THEN
            v_id_evaluacion := NULL;          
            FOR R IN (
                      SELECT * 
                        FROM suirplus.sre_ciudadanos_t
                       WHERE no_documento = v_sre_ciudadano.NO_DOCUMENTO
                     ) 
            LOOP
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
                  v_nss_det_solicitudes_t.NOMBRES               := v_sre_ciudadano.NOMBRES;
                  v_nss_det_solicitudes_t.PRIMER_APELLIDO       := v_sre_ciudadano.PRIMER_APELLIDO;
                  v_nss_det_solicitudes_t.SEGUNDO_APELLIDO      := v_sre_ciudadano.SEGUNDO_APELLIDO;
                  v_nss_det_solicitudes_t.FECHA_NACIMIENTO      := v_sre_ciudadano.FECHA_NACIMIENTO;
                  v_nss_det_solicitudes_t.SEXO                  := v_sre_ciudadano.SEXO;
                  v_nss_det_solicitudes_t.MUNICIPIO_ACTA        := v_sre_ciudadano.MUNICIPIO_ACTA;
                  v_nss_det_solicitudes_t.ANO_ACTA              := v_sre_ciudadano.ANO_ACTA;
                  v_nss_det_solicitudes_t.NUMERO_ACTA           := v_sre_ciudadano.NUMERO_ACTA;
                  v_nss_det_solicitudes_t.FOLIO_ACTA            := v_sre_ciudadano.FOLIO_ACTA;
                  v_nss_det_solicitudes_t.OFICIALIA_ACTA        := v_sre_ciudadano.OFICIALIA_ACTA;
                  v_nss_det_solicitudes_t.LIBRO_ACTA            := v_sre_ciudadano.LIBRO_ACTA;
                  v_nss_det_solicitudes_t.TIPO_LIBRO_ACTA       := v_sre_ciudadano.TIPO_LIBRO_ACTA;
                  v_nss_det_solicitudes_t.LITERAL_ACTA          := v_sre_ciudadano.LITERAL_ACTA;
                  v_nss_det_solicitudes_t.CEDULA_MADRE          := v_sre_ciudadano.CEDULA_MADRE;
                  v_nss_det_solicitudes_t.CEDULA_PADRE          := v_sre_ciudadano.CEDULA_PADRE;
                  v_nss_det_solicitudes_t.NOMBRE_MADRE          := v_sre_ciudadano.NOMBRE_MADRE;
                  v_nss_det_solicitudes_t.NOMBRE_PADRE          := v_sre_ciudadano.NOMBRE_PADRE;
                  v_nss_det_solicitudes_t.ESTADO_CIVIL          := v_sre_ciudadano.ESTADO_CIVIL;
                  v_nss_det_solicitudes_t.ID_NACIONALIDAD       := v_sre_ciudadano.ID_NACIONALIDAD;
                  v_nss_det_solicitudes_t.TIPO_CAUSA            := v_sre_ciudadano.TIPO_CAUSA;
                  v_nss_det_solicitudes_t.ID_CAUSA_INHABILIDAD  := v_sre_ciudadano.ID_CAUSA_INHABILIDAD;
                  v_nss_det_solicitudes_t.FECHA_CANCELACION_JCE := v_sre_ciudadano.FECHA_CANCELACION_JCE;
                  v_nss_det_solicitudes_t.ESTATUS_JCE           := v_sre_ciudadano.STATUS;
                  v_nss_det_solicitudes_t.NUMERO_EVENTO         := v_sre_ciudadano.NUMERO_EVENTO;
                        
                  --Como va para evaluacion visual, debo llenar los campos que trae el WEBSERVICE de la JCE
                  UPDATE suirplus.nss_det_solicitudes_t d
                     SET ROW = v_nss_det_solicitudes_t
                   WHERE d.id_registro = C_SOL.ID_REGISTRO;
                    
                  --Actualizamos la solicitud
                  SUIRPLUS.NSS_ACTUALIZAR_SOLICITUD(C_SOL.ID_REGISTRO, 4, 'NSS404', v_sre_ciudadano.ID_NSS, p_ult_usuario_act, p_resultado); --Pendiente de Evaluación Visual
                        
                  IF P_RESULTADO <> 'OK' THEN
                    -- Grabar fin seguimiento en detalle de bitacora
                    suirplus.detalle_bitacora(v_id_bitacora,
                                              sysdate,
                                              SUBSTR('Solicitud ASIGNACION NSS A CEDULADO, ID_SOLICITUD #'||to_char(P_ID_SOLICITUD)||', ID_REGISTRO #'||to_char(C_SOL.ID_REGISTRO)||': ignorada ('||to_char(sysdate,'dd/mm/yyyy hh:mi:ss am')||').'||chr(13)||chr(10)||
                                              'MOTIVO: '||p_resultado,1,500));
                  ELSE
                    -- Grabar primer seguimiento en detalle de bitacora
                    suirplus.detalle_bitacora(v_id_bitacora,
                                              sysdate,
                                              SUBSTR('Solicitud ASIGNACION NSS A CEDULADO, ID_SOLICITUD #'||to_char(P_ID_SOLICITUD)||', ID_REGISTRO #'||to_char(C_SOL.ID_REGISTRO)||': puesta en evaluacion visual ('||to_char(sysdate,'dd/mm/yyyy hh:mi:ss am')||').',1,500));
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

            -- Pasamos al proximo registro
            CONTINUE;
          END IF;
        END IF;  

        --Si llego hasta aqui, creamos el cuidadano
        SUIRPLUS.NSS_INSERTAR_CIUDADANO(C_SOL.ID_REGISTRO, v_sre_ciudadano, p_ult_usuario_act, p_resultado);
                  
        IF p_resultado <> 'OK' THEN
          -- Grabar fin seguimiento en detalle de bitacora
          suirplus.detalle_bitacora(v_id_bitacora,
                                    sysdate,
                                    SUBSTR('Solicitud ASIGNACION NSS A CEDULADO, ID_SOLICITUD #'||to_char(P_ID_SOLICITUD)||', ID_REGISTRO #'||to_char(C_SOL.ID_REGISTRO)||': ignorada ('||to_char(sysdate,'dd/mm/yyyy hh:mi:ss am')||').'||chr(13)||chr(10)||
                                    'MOTIVO: '||p_resultado,1,500));
        ELSE
          -- Grabar primer seguimiento en detalle de bitacora
          suirplus.detalle_bitacora(v_id_bitacora,
                                    sysdate,
                                    SUBSTR('Solicitud ASIGNACION NSS A CEDULADO, ID_SOLICITUD #'||to_char(P_ID_SOLICITUD)||', ID_REGISTRO #'||to_char(C_SOL.ID_REGISTRO)||': creo el ciudadano ('||to_char(sysdate,'dd/mm/yyyy hh:mi:ss am')||').',1,500));
        END IF;
      END IF;
    EXCEPTION WHEN OTHERS THEN
      p_resultado := SQLERRM||' - '||sys.dbms_utility.format_error_backtrace;
      
      -- Grabar primer seguimiento en detalle de bitacora
      suirplus.detalle_bitacora(v_id_bitacora,
                                sysdate,
                                SUBSTR('Solicitud ASIGNACION NSS A CEDULADO, ID_SOLICITUD #'||to_char(P_ID_SOLICITUD)||', ID_REGISTRO #'||to_char(C_SOL.ID_REGISTRO)||': ignorada por error: '||p_resultado,1,500));
    END;  
  END LOOP;

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
