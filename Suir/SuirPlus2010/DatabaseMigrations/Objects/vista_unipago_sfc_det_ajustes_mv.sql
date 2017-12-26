BEGIN
  EXECUTE IMMEDIATE 'CREATE OR REPLACE FORCE VIEW UNIPAGO.SFC_DET_AJUSTES_MV
   AS SELECT   a.id_referencia,
         a.id_nss,
         a.monto,
         LPAD (tipo_ajuste, 2, ''0'') tipo_ajuste,
         a.id_ajuste
  FROM   suirplus.sfc_det_ajustes_t a, suirplus.sfc_facturas_t f
 WHERE       a.id_referencia = f.id_referencia
         AND f.status NOT IN (''CA'', ''RE'', ''PA'')
         AND a.id_referencia = f.id_referencia
         AND f.id_usuario_autoriza IS NOT NULL
         AND f.no_autorizacion IS NOT NULL';
 EXECUTE IMMEDIATE  'COMMENT ON COLUMN "UNIPAGO"."SFC_DET_AJUSTES_MV"."ID_REFERENCIA" IS ''Nro. de la referencia''';
 EXECUTE IMMEDIATE  'COMMENT ON COLUMN "UNIPAGO"."SFC_DET_AJUSTES_MV"."ID_NSS" IS ''Numero de seguridad social del individuo, ver SUIRPLUS.SRE_CIUDADANOS_T''';
 EXECUTE IMMEDIATE  'COMMENT ON COLUMN "UNIPAGO"."SFC_DET_AJUSTES_MV"."MONTO" IS ''Monto de los ajustes de cada NSS''';
 EXECUTE IMMEDIATE  'COMMENT ON COLUMN "UNIPAGO"."SFC_DET_AJUSTES_MV"."TIPO_AJUSTE" IS ''Tipo de ajuste''';
 EXECUTE IMMEDIATE  'COMMENT ON COLUMN "UNIPAGO"."SFC_DET_AJUSTES_MV"."ID_AJUSTE" IS ''ID de la transaccion de ajuste, ver SUIRPLUS.SFC_TRANS_AJUSTES_T''';
 END;