BEGIN
  EXECUTE IMMEDIATE 'CREATE OR REPLACE FORCE VIEW UNIPAGO.SFC_DET_FACTURAS_MV
AS
SELECT   df.id_referencia n_no_referencia,
         DECODE (
            f.id_tipo_factura,
            ''N'',
            SUBSTR (df.periodo_aplicacion, 5)
            || SUBSTR (df.periodo_aplicacion, 1, 4),
            ''U'',
            SUBSTR (df.periodo_aplicacion, 5)
            || SUBSTR (df.periodo_aplicacion, 1, 4),
            SUBSTR (f.periodo_factura, 5) || SUBSTR (f.periodo_factura, 1, 4)
         )
            c_mes_aplicacion,
         f.id_registro_patronal n_registro_patronal,
         df.id_nss n_nss,
         f.id_nomina n_cve_nomina,
         df.secuencia n_num_detalle,
         df.salario_ss / (sys.DBMS_RANDOM.VALUE + 123) n_sal_cot,
         df.per_capita_adicional + df.per_capita_fonamat n_ppc,
         df.aporte_voluntario n_apo,
         0 n_cve_concepto,                         -- NO TIENE USO ACTUALMENTE
         df.cuenta_personal n_monto_cp,
         df.seguro_vida n_monto_sva,
         df.fondo_solidaridad n_monto_fss,
         df.operacion_sipen n_monto_osp,
         df.subsidios_salud n_monto_s,
         df.operacion_sisalril_sfs n_monto_oss,
         df.estancias_infantiles n_monto_ei,
         df.cuidado_salud n_monto_csp,
         df.proporcion_arl_srl n_monto_srl,
         df.operacion_sisalril_srl n_monto_osr,
         df.recargo_sfs n_monto_rec_salud,
         df.interes_sfs n_total_interes_salud,
         df.recargo_srl n_monto_rec_rl,
         df.aporte_empleador_sfs n_total_sal_emp,
         df.aporte_afiliados_sfs n_total_sal_afi,
         df.aporte_empleador_svds n_total_pen_emp,
         df.aporte_afiliados_svds n_total_pen_afi,
         df.aporte_srl n_total_rl_emp,
         df.comision_afp n_monto_afp,
         df.recargo_svds n_monto_rec,
         df.interes_cpe n_interes_cp,
         df.interes_apo n_interes_apo,
         df.interes_seguro_vida n_interes_sva,
         df.interes_fss n_interes_fss,
         df.interes_afp n_interes_afp,
         df.interes_osipen n_interes_osp,
           df.interes_cpe
         + df.interes_apo
         + df.interes_seguro_vida
         + df.interes_fss
         + df.interes_afp
         + df.interes_osipen
            n_total_interes,
         df.interes_srl n_interes_srl,
         0 n_interes_osr,
         df.interes_srl n_total_interes_rl,
         NVL (df.monto_ajuste, 0) monto_ajuste
  FROM   suirplus.sfc_det_facturas_t df, suirplus.sfc_facturas_t f
 WHERE       f.status NOT IN (''CA'', ''RE'', ''PA'')
         AND f.id_referencia = df.id_referencia
         AND f.id_usuario_autoriza IS NOT NULL
         AND f.no_autorizacion IS NOT NULL
         ORDER BY F.ULT_FECHA_ACT DESC';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN "UNIPAGO"."SFC_DET_FACTURAS_MV"."N_NO_REFERENCIA" IS ''Numero de refrencia de la factura''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN "UNIPAGO"."SFC_DET_FACTURAS_MV"."C_MES_APLICACION" IS ''Periodo al que corresponde este registro''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN "UNIPAGO"."SFC_DET_FACTURAS_MV"."N_REGISTRO_PATRONAL" IS ''ID generado por cada empleador definido en la tabla SRE_EMPLEADORES_T''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN "UNIPAGO"."SFC_DET_FACTURAS_MV"."N_NSS" IS ''Numero de seguridad social del individuo, ver SUIRPLUS.SRE_CIUDADANOS_T''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN "UNIPAGO"."SFC_DET_FACTURAS_MV"."N_CVE_NOMINA" IS ''Numero de nomina''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN "UNIPAGO"."SFC_DET_FACTURAS_MV"."N_NUM_DETALLE" IS ''N¿mero secuencia del detalle''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN "UNIPAGO"."SFC_DET_FACTURAS_MV"."N_SAL_COT" IS ''Salario cotizable para fines de la seguridad social''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN "UNIPAGO"."SFC_DET_FACTURAS_MV"."N_PPC" IS ''Percapita por dependientes adicionales''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN "UNIPAGO"."SFC_DET_FACTURAS_MV"."N_APO" IS ''Total de aportes voluntarios ordinarios''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN "UNIPAGO"."SFC_DET_FACTURAS_MV"."N_CVE_CONCEPTO" IS ''Concepto de la factura''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN "UNIPAGO"."SFC_DET_FACTURAS_MV"."N_MONTO_CP" IS ''Aportes cuenta personal del afiliado''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN "UNIPAGO"."SFC_DET_FACTURAS_MV"."N_MONTO_SVA" IS ''Total para el seguro de vida''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN "UNIPAGO"."SFC_DET_FACTURAS_MV"."N_MONTO_FSS" IS ''Total de aportes al fondo de solidaridad''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN "UNIPAGO"."SFC_DET_FACTURAS_MV"."N_MONTO_OSP" IS ''Total dee Operacion de Superintendencia de Pensiones.''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN "UNIPAGO"."SFC_DET_FACTURAS_MV"."N_MONTO_S" IS ''Total de subsidio al seguro familiar de salud''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN "UNIPAGO"."SFC_DET_FACTURAS_MV"."N_MONTO_OSS" IS ''Total de Operaciones de la Sisalril del Seguro Familial de Salud''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN "UNIPAGO"."SFC_DET_FACTURAS_MV"."N_MONTO_EI" IS ''Total de aportes para las estancias intantiles''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN "UNIPAGO"."SFC_DET_FACTURAS_MV"."N_MONTO_CSP" IS ''Total de aportes para el cuidado de salud''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN "UNIPAGO"."SFC_DET_FACTURAS_MV"."N_MONTO_SRL" IS ''Total de la proporcion del la Administradora de Riesgo Laboral del Seguro de Riesgo Laboral''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN "UNIPAGO"."SFC_DET_FACTURAS_MV"."N_MONTO_OSR" IS ''Total de Operaciones del Sisalril del Seguro Riesgo Laboral''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN "UNIPAGO"."SFC_DET_FACTURAS_MV"."N_MONTO_REC_SALUD" IS ''Total de los Recargos para el Seguro Familiar de Salud''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN "UNIPAGO"."SFC_DET_FACTURAS_MV"."N_TOTAL_INTERES_SALUD" IS ''Total de Interes para el Seguro Familiar de Salud''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN "UNIPAGO"."SFC_DET_FACTURAS_MV"."N_MONTO_REC_RL" IS ''Total de recargos para SRL''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN "UNIPAGO"."SFC_DET_FACTURAS_MV"."N_TOTAL_SAL_EMP" IS ''Total del Salario Cotizable para la Seguridad Social''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN "UNIPAGO"."SFC_DET_FACTURAS_MV"."N_TOTAL_SAL_AFI" IS ''Total del aporte del Afiliado al Seguro Familiar de Salud''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN "UNIPAGO"."SFC_DET_FACTURAS_MV"."N_TOTAL_PEN_EMP" IS ''Total del aporte del Empleador al Seguro de Vida''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN "UNIPAGO"."SFC_DET_FACTURAS_MV"."N_TOTAL_PEN_AFI" IS ''Total del aporte del Afiliado al Seguro de Vida''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN "UNIPAGO"."SFC_DET_FACTURAS_MV"."N_TOTAL_RL_EMP" IS ''Total del aporte al seguro de riesgos laborales''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN "UNIPAGO"."SFC_DET_FACTURAS_MV"."N_MONTO_AFP" IS ''Comision  para AFP''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN "UNIPAGO"."SFC_DET_FACTURAS_MV"."N_MONTO_REC" IS ''Total de los Recargos para el Seguro de Vida''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN "UNIPAGO"."SFC_DET_FACTURAS_MV"."N_INTERES_CP" IS ''Total de Interes para la cuenta personal''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN "UNIPAGO"."SFC_DET_FACTURAS_MV"."N_INTERES_APO" IS ''Total de interes del Aporte Voluntario''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN "UNIPAGO"."SFC_DET_FACTURAS_MV"."N_INTERES_SVA" IS ''Total de Interes para el Seguro de Vida''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN "UNIPAGO"."SFC_DET_FACTURAS_MV"."N_INTERES_FSS" IS ''Total de Interes para el fondo de solidaridad social''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN "UNIPAGO"."SFC_DET_FACTURAS_MV"."N_INTERES_AFP" IS ''Total de Interes para la comision de la AFP''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN "UNIPAGO"."SFC_DET_FACTURAS_MV"."N_INTERES_OSP" IS ''Interes de la Operacion SIPEN''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN "UNIPAGO"."SFC_DET_FACTURAS_MV"."N_TOTAL_INTERES" IS ''Monto total de interes''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN "UNIPAGO"."SFC_DET_FACTURAS_MV"."N_INTERES_SRL" IS ''Total de Interes para el Seguro de Riesgos Laborales''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN "UNIPAGO"."SFC_DET_FACTURAS_MV"."N_INTERES_OSR" IS ''Interes de la Operacion SISALRIL''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN "UNIPAGO"."SFC_DET_FACTURAS_MV"."N_TOTAL_INTERES_RL" IS ''Total de Interes para el Seguro de Riesgos Laborales''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN "UNIPAGO"."SFC_DET_FACTURAS_MV"."MONTO_AJUSTE" IS ''Monto del ajuste realizado''';
   END;