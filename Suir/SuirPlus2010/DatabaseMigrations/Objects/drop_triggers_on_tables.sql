BEGIN
  EXECUTE IMMEDIATE '
  DECLARE
    v_conteo pls_integer;
  BEGIN
    select count(*) into v_conteo from all_triggers where table_owner = ''SUIRPLUS'' and trigger_name = ''DATE_ON_ARS_ACTUALIZACION_ACTA'';

    if v_conteo > 0 then
      EXECUTE IMMEDIATE ''DROP TRIGGER SUIRPLUS.DATE_ON_ARS_ACTUALIZACION_ACTA'';
    end if;
  END;';

  EXECUTE IMMEDIATE '
  DECLARE
    v_conteo pls_integer;
  BEGIN
    select count(*) into v_conteo from all_triggers where table_owner = ''SUIRPLUS'' and trigger_name = ''DATE_ON_ARS_ACTUALIZACION_VIST'';

    if v_conteo > 0 then
      EXECUTE IMMEDIATE ''DROP TRIGGER SUIRPLUS.DATE_ON_ARS_ACTUALIZACION_VIST'';
    end if;
  END;';

  EXECUTE IMMEDIATE '
  DECLARE
    v_conteo pls_integer;
  BEGIN
    select count(*) into v_conteo from all_triggers where table_owner = ''SUIRPLUS'' and trigger_name = ''DATE_ON_ARS_DET_ACTUALIZACION_'';

    if v_conteo > 0 then
      EXECUTE IMMEDIATE ''DROP TRIGGER SUIRPLUS.DATE_ON_ARS_DET_ACTUALIZACION_'';
    end if;
  END;';

  EXECUTE IMMEDIATE '
  DECLARE
    v_conteo pls_integer;
  BEGIN
    select count(*) into v_conteo from all_triggers where table_owner = ''SUIRPLUS'' and trigger_name = ''DATE_ON_ARS_DET_SOLICITUD_NSS_'';

    if v_conteo > 0 then
      EXECUTE IMMEDIATE ''DROP TRIGGER SUIRPLUS.DATE_ON_ARS_DET_SOLICITUD_NSS_'';
    end if;
  END;';

  EXECUTE IMMEDIATE '
  DECLARE
    v_conteo pls_integer;
  BEGIN
    select count(*) into v_conteo from all_triggers where table_owner = ''SUIRPLUS'' and trigger_name = ''DATE_ON_ARS_DET_SOLICITUD_T_TR'';

    if v_conteo > 0 then
      EXECUTE IMMEDIATE ''DROP TRIGGER SUIRPLUS.DATE_ON_ARS_DET_SOLICITUD_T_TR'';
    end if;
  END;';

  EXECUTE IMMEDIATE '
  DECLARE
    v_conteo pls_integer;
  BEGIN
    select count(*) into v_conteo from all_triggers where table_owner = ''SUIRPLUS'' and trigger_name = ''DATE_ON_ARS_SOLICITUD_T_TRG'';

    if v_conteo > 0 then
      EXECUTE IMMEDIATE ''DROP TRIGGER SUIRPLUS.DATE_ON_ARS_SOLICITUD_T_TRG'';
    end if;
  END;';

  EXECUTE IMMEDIATE '
  DECLARE
    v_conteo pls_integer;
  BEGIN
    select count(*) into v_conteo from all_triggers where table_owner = ''SUIRPLUS'' and trigger_name = ''DATE_ON_CER_CERTIFICACIONES_T_'';

    if v_conteo > 0 then
      EXECUTE IMMEDIATE ''DROP TRIGGER SUIRPLUS.DATE_ON_CER_CERTIFICACIONES_T_'';
    end if;
  END;';

  EXECUTE IMMEDIATE '
  DECLARE
    v_conteo pls_integer;
  BEGIN
    select count(*) into v_conteo from all_triggers where table_owner = ''SUIRPLUS'' and trigger_name = ''DATE_ON_CER_ROLES_CERTIFICACIO'';

    if v_conteo > 0 then
      EXECUTE IMMEDIATE ''DROP TRIGGER SUIRPLUS.DATE_ON_CER_ROLES_CERTIFICACIO'';
    end if;
  END;';

  EXECUTE IMMEDIATE '
  DECLARE
    v_conteo pls_integer;
  BEGIN
    select count(*) into v_conteo from all_triggers where table_owner = ''SUIRPLUS'' and trigger_name = ''DATE_ON_CER_SOL_CERTIFICACIONE'';

    if v_conteo > 0 then
      EXECUTE IMMEDIATE ''DROP TRIGGER SUIRPLUS.DATE_ON_CER_SOL_CERTIFICACIONE'';
    end if;
  END;';

  EXECUTE IMMEDIATE '
  DECLARE
    v_conteo pls_integer;
  BEGIN
    select count(*) into v_conteo from all_triggers where table_owner = ''SUIRPLUS'' and trigger_name = ''DATE_ON_JCE_ACTUALIZACION_T_TR'';

    if v_conteo > 0 then
      EXECUTE IMMEDIATE ''DROP TRIGGER SUIRPLUS.DATE_ON_JCE_ACTUALIZACION_T_TR'';
    end if;
  END;';

  EXECUTE IMMEDIATE '
  DECLARE
    v_conteo pls_integer;
  BEGIN
    select count(*) into v_conteo from all_triggers where table_owner = ''SUIRPLUS'' and trigger_name = ''DATE_ON_LGL_ACUERDOS_T_TRG'';

    if v_conteo > 0 then
      EXECUTE IMMEDIATE ''DROP TRIGGER SUIRPLUS.DATE_ON_LGL_ACUERDOS_T_TRG'';
    end if;
  END;';

  EXECUTE IMMEDIATE '
  DECLARE
    v_conteo pls_integer;
  BEGIN
    select count(*) into v_conteo from all_triggers where table_owner = ''SUIRPLUS'' and trigger_name = ''DATE_ON_LGL_SOLICITUDES_T_TRG'';

    if v_conteo > 0 then
      EXECUTE IMMEDIATE ''DROP TRIGGER SUIRPLUS.DATE_ON_LGL_SOLICITUDES_T_TRG'';
    end if;
  END;';

  EXECUTE IMMEDIATE '
  DECLARE
    v_conteo pls_integer;
  BEGIN
    select count(*) into v_conteo from all_triggers where table_owner = ''SUIRPLUS'' and trigger_name = ''DATE_ON_NCH_CUENTAS_T_TRG'';

    if v_conteo > 0 then
      EXECUTE IMMEDIATE ''DROP TRIGGER SUIRPLUS.DATE_ON_NCH_CUENTAS_T_TRG'';
    end if;
  END;';

  EXECUTE IMMEDIATE '
  DECLARE
    v_conteo pls_integer;
  BEGIN
    select count(*) into v_conteo from all_triggers where table_owner = ''SUIRPLUS'' and trigger_name = ''DATE_ON_NCH_PROCESOS_T_TRG'';

    if v_conteo > 0 then
      EXECUTE IMMEDIATE ''DROP TRIGGER SUIRPLUS.DATE_ON_NCH_PROCESOS_T_TRG'';
    end if;
  END;';

  EXECUTE IMMEDIATE '
  DECLARE
    v_conteo pls_integer;
  BEGIN
    select count(*) into v_conteo from all_triggers where table_owner = ''SUIRPLUS'' and trigger_name = ''DATE_ON_NCH_SUBPROCESOS_T_TRG'';

    if v_conteo > 0 then
      EXECUTE IMMEDIATE ''DROP TRIGGER SUIRPLUS.DATE_ON_NCH_SUBPROCESOS_T_TRG'';
    end if;
  END;';

  EXECUTE IMMEDIATE '
  DECLARE
    v_conteo pls_integer;
  BEGIN
    select count(*) into v_conteo from all_triggers where table_owner = ''SUIRPLUS'' and trigger_name = ''DATE_ON_NSS_DET_SOLICITUDES_T_'';

    if v_conteo > 0 then
      EXECUTE IMMEDIATE ''DROP TRIGGER SUIRPLUS.DATE_ON_NSS_DET_SOLICITUDES_T_'';
    end if;
  END;';

  EXECUTE IMMEDIATE '
  DECLARE
    v_conteo pls_integer;
  BEGIN
    select count(*) into v_conteo from all_triggers where table_owner = ''SUIRPLUS'' and trigger_name = ''DATE_ON_NSS_DET_SOLICITUD_EN_P'';

    if v_conteo > 0 then
      EXECUTE IMMEDIATE ''DROP TRIGGER SUIRPLUS.DATE_ON_NSS_DET_SOLICITUD_EN_P'';
    end if;
  END;';

  EXECUTE IMMEDIATE '
  DECLARE
    v_conteo pls_integer;
  BEGIN
    select count(*) into v_conteo from all_triggers where table_owner = ''SUIRPLUS'' and trigger_name = ''DATE_ON_NSS_EVALUACION_VISUAL_'';

    if v_conteo > 0 then
      EXECUTE IMMEDIATE ''DROP TRIGGER SUIRPLUS.DATE_ON_NSS_EVALUACION_VISUAL_'';
    end if;
  END;';

  EXECUTE IMMEDIATE '
  DECLARE
    v_conteo pls_integer;
  BEGIN
    select count(*) into v_conteo from all_triggers where table_owner = ''SUIRPLUS'' and trigger_name = ''DATE_ON_NSS_SOLICITUDES_T_TRG'';

    if v_conteo > 0 then
      EXECUTE IMMEDIATE ''DROP TRIGGER SUIRPLUS.DATE_ON_NSS_SOLICITUDES_T_TRG'';
    end if;
  END;';

  EXECUTE IMMEDIATE '
  DECLARE
    v_conteo pls_integer;
  BEGIN
    select count(*) into v_conteo from all_triggers where table_owner = ''SUIRPLUS'' and trigger_name = ''DATE_ON_OFC_DOCUMENTACION_T_TR'';

    if v_conteo > 0 then
      EXECUTE IMMEDIATE ''DROP TRIGGER SUIRPLUS.DATE_ON_OFC_DOCUMENTACION_T_TR'';
    end if;
  END;';

  EXECUTE IMMEDIATE '
  DECLARE
    v_conteo pls_integer;
  BEGIN
    select count(*) into v_conteo from all_triggers where table_owner = ''SUIRPLUS'' and trigger_name = ''DATE_ON_SEG_AUD_USUARIO_T_TRG'';

    if v_conteo > 0 then
      EXECUTE IMMEDIATE ''DROP TRIGGER SUIRPLUS.DATE_ON_SEG_AUD_USUARIO_T_TRG'';
    end if;
  END;';

  EXECUTE IMMEDIATE '
  DECLARE
    v_conteo pls_integer;
  BEGIN
    select count(*) into v_conteo from all_triggers where table_owner = ''SUIRPLUS'' and trigger_name = ''DATE_ON_SEG_ERROR_ACTAS_T_TRG'';

    if v_conteo > 0 then
      EXECUTE IMMEDIATE ''DROP TRIGGER SUIRPLUS.DATE_ON_SEG_ERROR_ACTAS_T_TRG'';
    end if;
  END;';

  EXECUTE IMMEDIATE '
  DECLARE
    v_conteo pls_integer;
  BEGIN
    select count(*) into v_conteo from all_triggers where table_owner = ''SUIRPLUS'' and trigger_name = ''DATE_ON_SEH_DET_NOV_TMP_T_TRG'';

    if v_conteo > 0 then
      EXECUTE IMMEDIATE ''DROP TRIGGER SUIRPLUS.DATE_ON_SEH_DET_NOV_TMP_T_TRG'';
    end if;
  END;';

  EXECUTE IMMEDIATE '
  DECLARE
    v_conteo pls_integer;
  BEGIN
    select count(*) into v_conteo from all_triggers where table_owner = ''SUIRPLUS'' and trigger_name = ''DATE_ON_SEH_MOTIVO_BAJA_T_TRG'';

    if v_conteo > 0 then
      EXECUTE IMMEDIATE ''DROP TRIGGER SUIRPLUS.DATE_ON_SEH_MOTIVO_BAJA_T_TRG'';
    end if;
  END;';

  EXECUTE IMMEDIATE '
  DECLARE
    v_conteo pls_integer;
  BEGIN
    select count(*) into v_conteo from all_triggers where table_owner = ''SUIRPLUS'' and trigger_name = ''DATE_ON_SEL_EMPLEADORES_TMP_T_'';

    if v_conteo > 0 then
      EXECUTE IMMEDIATE ''DROP TRIGGER SUIRPLUS.DATE_ON_SEL_EMPLEADORES_TMP_T_'';
    end if;
  END;';

  EXECUTE IMMEDIATE '
  DECLARE
    v_conteo pls_integer;
  BEGIN
    select count(*) into v_conteo from all_triggers where table_owner = ''SUIRPLUS'' and trigger_name = ''DATE_ON_SEL_STATUS_HISTORICO_T'';

    if v_conteo > 0 then
      EXECUTE IMMEDIATE ''DROP TRIGGER SUIRPLUS.DATE_ON_SEL_STATUS_HISTORICO_T'';
    end if;
  END;';

  EXECUTE IMMEDIATE '
  DECLARE
    v_conteo pls_integer;
  BEGIN
    select count(*) into v_conteo from all_triggers where table_owner = ''SUIRPLUS'' and trigger_name = ''DATE_ON_SFC_APLICACIONES_T_TRG'';

    if v_conteo > 0 then
      EXECUTE IMMEDIATE ''DROP TRIGGER SUIRPLUS.DATE_ON_SFC_APLICACIONES_T_TRG'';
    end if;
  END;';

  EXECUTE IMMEDIATE '
  DECLARE
    v_conteo pls_integer;
  BEGIN
    select count(*) into v_conteo from all_triggers where table_owner = ''SUIRPLUS'' and trigger_name = ''DATE_ON_SFC_DET_NACHA_T_TRG'';

    if v_conteo > 0 then
      EXECUTE IMMEDIATE ''DROP TRIGGER SUIRPLUS.DATE_ON_SFC_DET_NACHA_T_TRG'';
    end if;
  END;';

  EXECUTE IMMEDIATE '
  DECLARE
    v_conteo pls_integer;
  BEGIN
    select count(*) into v_conteo from all_triggers where table_owner = ''SUIRPLUS'' and trigger_name = ''DATE_ON_SFC_DET_RECAUDO_IBANKI'';

    if v_conteo > 0 then
      EXECUTE IMMEDIATE ''DROP TRIGGER SUIRPLUS.DATE_ON_SFC_DET_RECAUDO_IBANKI'';
    end if;
  END;';

  EXECUTE IMMEDIATE '
  DECLARE
    v_conteo pls_integer;
  BEGIN
    select count(*) into v_conteo from all_triggers where table_owner = ''SUIRPLUS'' and trigger_name = ''DATE_ON_SFC_EQUIVALENCIAS_IR13'';

    if v_conteo > 0 then
      EXECUTE IMMEDIATE ''DROP TRIGGER SUIRPLUS.DATE_ON_SFC_EQUIVALENCIAS_IR13'';
    end if;
  END;';

  EXECUTE IMMEDIATE '
  DECLARE
    v_conteo pls_integer;
  BEGIN
    select count(*) into v_conteo from all_triggers where table_owner = ''SUIRPLUS'' and trigger_name = ''DATE_ON_SFC_IR17_T_TRG'';

    if v_conteo > 0 then
      EXECUTE IMMEDIATE ''DROP TRIGGER SUIRPLUS.DATE_ON_SFC_IR17_T_TRG'';
    end if;
  END;';

  EXECUTE IMMEDIATE '
  DECLARE
    v_conteo pls_integer;
  BEGIN
    select count(*) into v_conteo from all_triggers where table_owner = ''SUIRPLUS'' and trigger_name = ''DATE_ON_SFC_NACHA_T_TRG'';

    if v_conteo > 0 then
      EXECUTE IMMEDIATE ''DROP TRIGGER SUIRPLUS.DATE_ON_SFC_NACHA_T_TRG'';
    end if;
  END;';

  EXECUTE IMMEDIATE '
  DECLARE
    v_conteo pls_integer;
  BEGIN
    select count(*) into v_conteo from all_triggers where table_owner = ''SUIRPLUS'' and trigger_name = ''DATE_ON_SFC_RANGOS_ANUALES_ISR'';

    if v_conteo > 0 then
      EXECUTE IMMEDIATE ''DROP TRIGGER SUIRPLUS.DATE_ON_SFC_RANGOS_ANUALES_ISR'';
    end if;
  END;';

  EXECUTE IMMEDIATE '
  DECLARE
    v_conteo pls_integer;
  BEGIN
    select count(*) into v_conteo from all_triggers where table_owner = ''SUIRPLUS'' and trigger_name = ''DATE_ON_SFC_RANGOS_ANUALES_IS'';

    if v_conteo > 0 then
      EXECUTE IMMEDIATE ''DROP TRIGGER SUIRPLUS.DATE_ON_SFC_RANGOS_ANUALES_IS'';
    end if;
  END;';

  EXECUTE IMMEDIATE '
  DECLARE
    v_conteo pls_integer;
  BEGIN
    select count(*) into v_conteo from all_triggers where table_owner = ''SUIRPLUS'' and trigger_name = ''DATE_ON_SFC_RECAUDO_IBANKING_T'';

    if v_conteo > 0 then
      EXECUTE IMMEDIATE ''DROP TRIGGER SUIRPLUS.DATE_ON_SFC_RECAUDO_IBANKING_T'';
    end if;
  END;';

  EXECUTE IMMEDIATE '
  DECLARE
    v_conteo pls_integer;
  BEGIN
    select count(*) into v_conteo from all_triggers where table_owner = ''SUIRPLUS'' and trigger_name = ''DATE_ON_SFC_RENGLONES_T_TRG'';

    if v_conteo > 0 then
      EXECUTE IMMEDIATE ''DROP TRIGGER SUIRPLUS.DATE_ON_SFC_RENGLONES_T_TRG'';
    end if;
  END;';

  EXECUTE IMMEDIATE '
  DECLARE
    v_conteo pls_integer;
  BEGIN
    select count(*) into v_conteo from all_triggers where table_owner = ''SUIRPLUS'' and trigger_name = ''DATE_ON_SFC_RENGLON_NOMINA_T_T'';

    if v_conteo > 0 then
      EXECUTE IMMEDIATE ''DROP TRIGGER SUIRPLUS.DATE_ON_SFC_RENGLON_NOMINA_T_T'';
    end if;
  END;';

  EXECUTE IMMEDIATE '
  DECLARE
    v_conteo pls_integer;
  BEGIN
    select count(*) into v_conteo from all_triggers where table_owner = ''SUIRPLUS'' and trigger_name = ''DATE_ON_SFC_RESUMEN_IR13_T_TRG'';

    if v_conteo > 0 then
      EXECUTE IMMEDIATE ''DROP TRIGGER SUIRPLUS.DATE_ON_SFC_RESUMEN_IR13_T_TRG'';
    end if;
  END;';

  EXECUTE IMMEDIATE '
  DECLARE
    v_conteo pls_integer;
  BEGIN
    select count(*) into v_conteo from all_triggers where table_owner = ''SUIRPLUS'' and trigger_name = ''DATE_ON_SFC_TIPO_AJUSTES_T_TRG'';

    if v_conteo > 0 then
      EXECUTE IMMEDIATE ''DROP TRIGGER SUIRPLUS.DATE_ON_SFC_TIPO_AJUSTES_T_TRG'';
    end if;
  END;';

  EXECUTE IMMEDIATE '
  DECLARE
    v_conteo pls_integer;
  BEGIN
    select count(*) into v_conteo from all_triggers where table_owner = ''SUIRPLUS'' and trigger_name = ''DATE_ON_SFC_TIPO_NOMINAS_T_TRG'';

    if v_conteo > 0 then
      EXECUTE IMMEDIATE ''DROP TRIGGER SUIRPLUS.DATE_ON_SFC_TIPO_NOMINAS_T_TRG'';
    end if;
  END;';

  EXECUTE IMMEDIATE '
  DECLARE
    v_conteo pls_integer;
  BEGIN
    select count(*) into v_conteo from all_triggers where table_owner = ''SUIRPLUS'' and trigger_name = ''DATE_ON_SRE_ADICIONALES_RES_26'';

    if v_conteo > 0 then
      EXECUTE IMMEDIATE ''DROP TRIGGER SUIRPLUS.DATE_ON_SRE_ADICIONALES_RES_26'';
    end if;
  END;';

  EXECUTE IMMEDIATE '
  DECLARE
    v_conteo pls_integer;
  BEGIN
    select count(*) into v_conteo from all_triggers where table_owner = ''SUIRPLUS'' and trigger_name = ''DATE_ON_SRE_ADICIONALES_RES_2'';

    if v_conteo > 0 then
      EXECUTE IMMEDIATE ''DROP TRIGGER SUIRPLUS.DATE_ON_SRE_ADICIONALES_RES_2'';
    end if;
  END;';

  EXECUTE IMMEDIATE '
  DECLARE
    v_conteo pls_integer;
  BEGIN
    select count(*) into v_conteo from all_triggers where table_owner = ''SUIRPLUS'' and trigger_name = ''DATE_ON_SRE_AUD_REPRESENTANTES'';

    if v_conteo > 0 then
      EXECUTE IMMEDIATE ''DROP TRIGGER SUIRPLUS.DATE_ON_SRE_AUD_REPRESENTANTES'';
    end if;
  END;';

  EXECUTE IMMEDIATE '
  DECLARE
    v_conteo pls_integer;
  BEGIN
    select count(*) into v_conteo from all_triggers where table_owner = ''SUIRPLUS'' and trigger_name = ''DATE_ON_SRE_CIUDADANOS_API_T_T'';

    if v_conteo > 0 then
      EXECUTE IMMEDIATE ''DROP TRIGGER SUIRPLUS.DATE_ON_SRE_CIUDADANOS_API_T_T'';
    end if;
  END;';

  EXECUTE IMMEDIATE '
  DECLARE
    v_conteo pls_integer;
  BEGIN
    select count(*) into v_conteo from all_triggers where table_owner = ''SUIRPLUS'' and trigger_name = ''DATE_ON_SRE_CIUDADANOS_CANCELA'';

    if v_conteo > 0 then
      EXECUTE IMMEDIATE ''DROP TRIGGER SUIRPLUS.DATE_ON_SRE_CIUDADANOS_CANCELA'';
    end if;
  END;';

  EXECUTE IMMEDIATE '
  DECLARE
    v_conteo pls_integer;
  BEGIN
    select count(*) into v_conteo from all_triggers where table_owner = ''SUIRPLUS'' and trigger_name = ''DATE_ON_SRE_CIUDADANOS_ULT_T_T'';

    if v_conteo > 0 then
      EXECUTE IMMEDIATE ''DROP TRIGGER SUIRPLUS.DATE_ON_SRE_CIUDADANOS_ULT_T_T'';
    end if;
  END;';

  EXECUTE IMMEDIATE '
  DECLARE
    v_conteo pls_integer;
  BEGIN
    select count(*) into v_conteo from all_triggers where table_owner = ''SUIRPLUS'' and trigger_name = ''DATE_ON_SRE_CIU_CAMBIOS_T_TRG'';

    if v_conteo > 0 then
      EXECUTE IMMEDIATE ''DROP TRIGGER SUIRPLUS.DATE_ON_SRE_CIU_CAMBIOS_T_TRG'';
    end if;
  END;';

  EXECUTE IMMEDIATE '
  DECLARE
    v_conteo pls_integer;
  BEGIN
    select count(*) into v_conteo from all_triggers where table_owner = ''SUIRPLUS'' and trigger_name = ''DATE_ON_SRE_CLASE_EMPRESA_T_TR'';

    if v_conteo > 0 then
      EXECUTE IMMEDIATE ''DROP TRIGGER SUIRPLUS.DATE_ON_SRE_CLASE_EMPRESA_T_TR'';
    end if;
  END;';

  EXECUTE IMMEDIATE '
  DECLARE
    v_conteo pls_integer;
  BEGIN
    select count(*) into v_conteo from all_triggers where table_owner = ''SUIRPLUS'' and trigger_name = ''DATE_ON_SRE_CLASE_EMP_DOCS_T_T'';

    if v_conteo > 0 then
      EXECUTE IMMEDIATE ''DROP TRIGGER SUIRPLUS.DATE_ON_SRE_CLASE_EMP_DOCS_T_T'';
    end if;
  END;';

  EXECUTE IMMEDIATE '
  DECLARE
    v_conteo pls_integer;
  BEGIN
    select count(*) into v_conteo from all_triggers where table_owner = ''SUIRPLUS'' and trigger_name = ''DATE_ON_SRE_DET_CIUDADANOS_API'';

    if v_conteo > 0 then
      EXECUTE IMMEDIATE ''DROP TRIGGER SUIRPLUS.DATE_ON_SRE_DET_CIUDADANOS_API'';
    end if;
  END;';

  EXECUTE IMMEDIATE '
  DECLARE
    v_conteo pls_integer;
  BEGIN
    select count(*) into v_conteo from all_triggers where table_owner = ''SUIRPLUS'' and trigger_name = ''DATE_ON_SRE_ESCALA_SALARIAL_T_'';

    if v_conteo > 0 then
      EXECUTE IMMEDIATE ''DROP TRIGGER SUIRPLUS.DATE_ON_SRE_ESCALA_SALARIAL_T_'';
    end if;
  END;';

  EXECUTE IMMEDIATE '
  DECLARE
    v_conteo pls_integer;
  BEGIN
    select count(*) into v_conteo from all_triggers where table_owner = ''SUIRPLUS'' and trigger_name = ''DATE_ON_SRE_ESTADISTICAS_T_TRG'';

    if v_conteo > 0 then
      EXECUTE IMMEDIATE ''DROP TRIGGER SUIRPLUS.DATE_ON_SRE_ESTADISTICAS_T_TRG'';
    end if;
  END;';

  EXECUTE IMMEDIATE '
  DECLARE
    v_conteo pls_integer;
  BEGIN
    select count(*) into v_conteo from all_triggers where table_owner = ''SUIRPLUS'' and trigger_name = ''DATE_ON_SRE_HISTORICO_DOCUMENT'';

    if v_conteo > 0 then
      EXECUTE IMMEDIATE ''DROP TRIGGER SUIRPLUS.DATE_ON_SRE_HISTORICO_DOCUMENT'';
    end if;
  END;';

  EXECUTE IMMEDIATE '
  DECLARE
    v_conteo pls_integer;
  BEGIN
    select count(*) into v_conteo from all_triggers where table_owner = ''SUIRPLUS'' and trigger_name = ''DATE_ON_SRE_HIS_DOCUMENTOS_T_T'';

    if v_conteo > 0 then
      EXECUTE IMMEDIATE ''DROP TRIGGER SUIRPLUS.DATE_ON_SRE_HIS_DOCUMENTOS_T_T'';
    end if;
  END;';

  EXECUTE IMMEDIATE '
  DECLARE
    v_conteo pls_integer;
  BEGIN
    select count(*) into v_conteo from all_triggers where table_owner = ''SUIRPLUS'' and trigger_name = ''DATE_ON_SRE_INFORMES_AUDITORIA'';

    if v_conteo > 0 then
      EXECUTE IMMEDIATE ''DROP TRIGGER SUIRPLUS.DATE_ON_SRE_INFORMES_AUDITORIA'';
    end if;
  END;';

  EXECUTE IMMEDIATE '
  DECLARE
    v_conteo pls_integer;
  BEGIN
    select count(*) into v_conteo from all_triggers where table_owner = ''SUIRPLUS'' and trigger_name = ''DATE_ON_SRE_INHABILIDAD_EMPLEA'';

    if v_conteo > 0 then
      EXECUTE IMMEDIATE ''DROP TRIGGER SUIRPLUS.DATE_ON_SRE_INHABILIDAD_EMPLEA'';
    end if;
  END;';

  EXECUTE IMMEDIATE '
  DECLARE
    v_conteo pls_integer;
  BEGIN
    select count(*) into v_conteo from all_triggers where table_owner = ''SUIRPLUS'' and trigger_name = ''DATE_ON_SRE_INHABILIDAD_PROCES'';

    if v_conteo > 0 then
      EXECUTE IMMEDIATE ''DROP TRIGGER SUIRPLUS.DATE_ON_SRE_INHABILIDAD_PROCES'';
    end if;
  END;';

  EXECUTE IMMEDIATE '
  DECLARE
    v_conteo pls_integer;
  BEGIN
    select count(*) into v_conteo from all_triggers where table_owner = ''SUIRPLUS'' and trigger_name = ''DATE_ON_SRE_LOCALIDADES_T_TRG'';

    if v_conteo > 0 then
      EXECUTE IMMEDIATE ''DROP TRIGGER SUIRPLUS.DATE_ON_SRE_LOCALIDADES_T_TRG'';
    end if;
  END;';

  EXECUTE IMMEDIATE '
  DECLARE
    v_conteo pls_integer;
  BEGIN
    select count(*) into v_conteo from all_triggers where table_owner = ''SUIRPLUS'' and trigger_name = ''DATE_ON_SRE_MENORES_CANCELADOS'';

    if v_conteo > 0 then
      EXECUTE IMMEDIATE ''DROP TRIGGER SUIRPLUS.DATE_ON_SRE_MENORES_CANCELADOS'';
    end if;
  END;';

  EXECUTE IMMEDIATE '
  DECLARE
    v_conteo pls_integer;
  BEGIN
    select count(*) into v_conteo from all_triggers where table_owner = ''SUIRPLUS'' and trigger_name = ''DATE_ON_SRE_MOTIVOS_PASAPORTES'';

    if v_conteo > 0 then
      EXECUTE IMMEDIATE ''DROP TRIGGER SUIRPLUS.DATE_ON_SRE_MOTIVOS_PASAPORTES'';
    end if;
  END;';

  EXECUTE IMMEDIATE '
  DECLARE
    v_conteo pls_integer;
  BEGIN
    select count(*) into v_conteo from all_triggers where table_owner = ''SUIRPLUS'' and trigger_name = ''DATE_ON_SRE_OCUPACIONES_T_TRG'';

    if v_conteo > 0 then
      EXECUTE IMMEDIATE ''DROP TRIGGER SUIRPLUS.DATE_ON_SRE_OCUPACIONES_T_TRG'';
    end if;
  END;';

  EXECUTE IMMEDIATE '
  DECLARE
    v_conteo pls_integer;
  BEGIN
    select count(*) into v_conteo from all_triggers where table_owner = ''SUIRPLUS'' and trigger_name = ''DATE_ON_SRE_PASAPORTES_T_TRG'';

    if v_conteo > 0 then
      EXECUTE IMMEDIATE ''DROP TRIGGER SUIRPLUS.DATE_ON_SRE_PASAPORTES_T_TRG'';
    end if;
  END;';

  EXECUTE IMMEDIATE '
  DECLARE
    v_conteo pls_integer;
  BEGIN
    select count(*) into v_conteo from all_triggers where table_owner = ''SUIRPLUS'' and trigger_name = ''DATE_ON_SRE_SECTORES_SALARIALE'';

    if v_conteo > 0 then
      EXECUTE IMMEDIATE ''DROP TRIGGER SUIRPLUS.DATE_ON_SRE_SECTORES_SALARIALE'';
    end if;
  END;';

  EXECUTE IMMEDIATE '
  DECLARE
    v_conteo pls_integer;
  BEGIN
    select count(*) into v_conteo from all_triggers where table_owner = ''SUIRPLUS'' and trigger_name = ''DATE_ON_SRE_TIPO_ARCHIVOS_T_TR'';

    if v_conteo > 0 then
      EXECUTE IMMEDIATE ''DROP TRIGGER SUIRPLUS.DATE_ON_SRE_TIPO_ARCHIVOS_T_TR'';
    end if;
  END;';

  EXECUTE IMMEDIATE '
  DECLARE
    v_conteo pls_integer;
  BEGIN
    select count(*) into v_conteo from all_triggers where table_owner = ''SUIRPLUS'' and trigger_name = ''DATE_ON_SRE_TIPO_INGRESO_T_TRG'';

    if v_conteo > 0 then
      EXECUTE IMMEDIATE ''DROP TRIGGER SUIRPLUS.DATE_ON_SRE_TIPO_INGRESO_T_TRG'';
    end if;
  END;';

  EXECUTE IMMEDIATE '
  DECLARE
    v_conteo pls_integer;
  BEGIN
    select count(*) into v_conteo from all_triggers where table_owner = ''SUIRPLUS'' and trigger_name = ''DATE_ON_SRE_TMP_MOVIMIENTO_REC'';

    if v_conteo > 0 then
      EXECUTE IMMEDIATE ''DROP TRIGGER SUIRPLUS.DATE_ON_SRE_TMP_MOVIMIENTO_REC'';
    end if;
  END;';

  EXECUTE IMMEDIATE '
  DECLARE
    v_conteo pls_integer;
  BEGIN
    select count(*) into v_conteo from all_triggers where table_owner = ''SUIRPLUS'' and trigger_name = ''DATE_ON_SRE_TURNOS_T_TRG'';

    if v_conteo > 0 then
      EXECUTE IMMEDIATE ''DROP TRIGGER SUIRPLUS.DATE_ON_SRE_TURNOS_T_TRG'';
    end if;
  END;';

  EXECUTE IMMEDIATE '
  DECLARE
    v_conteo pls_integer;
  BEGIN
    select count(*) into v_conteo from all_triggers where table_owner = ''SUIRPLUS'' and trigger_name = ''DATE_ON_SUB_ERRORES_SISALRIL_O'';

    if v_conteo > 0 then
      EXECUTE IMMEDIATE ''DROP TRIGGER SUIRPLUS.DATE_ON_SUB_ERRORES_SISALRIL_O'';
    end if;
  END;';

  EXECUTE IMMEDIATE '
  DECLARE
    v_conteo pls_integer;
  BEGIN
    select count(*) into v_conteo from all_triggers where table_owner = ''SUIRPLUS'' and trigger_name = ''DATE_ON_SUIR_SOL_ASIG_CEDULA_T'';

    if v_conteo > 0 then
      EXECUTE IMMEDIATE ''DROP TRIGGER SUIRPLUS.DATE_ON_SUIR_SOL_ASIG_CEDULA_T'';
    end if;
  END;';
END;