BEGIN
  --Permiso de select para el esquema UNIPAGO sobre el objeto SUIRPLUS.SRE_HISTORICO_DOCUMENTOS_T
  EXECUTE IMMEDIATE 'GRANT SELECT ON SUIRPLUS.SRE_HISTORICO_DOCUMENTOS_T TO UNIPAGO';

  EXECUTE IMMEDIATE 'CREATE MATERIALIZED VIEW UNIPAGO.SRE_HISTORICO_DOCUMENTOS_MV
    REFRESH FORCE ON DEMAND
    AS 
    SELECT
           id,
           id_nss,
           tipo_documento,
           no_documento,
           ult_fecha_act
      FROM suirplus.sre_historico_documentos_t';
  EXECUTE IMMEDIATE  'COMMENT ON MATERIALIZED VIEW "UNIPAGO"."SRE_HISTORICO_DOCUMENTOS_MV" IS ''Vista materializada que contiene los cambios realizados a documentos de ciudadanos cedulados.''';
  EXECUTE IMMEDIATE  'COMMENT ON COLUMN "UNIPAGO"."SRE_HISTORICO_DOCUMENTOS_MV"."ID" IS ''Primary key de la tabla.''';
  EXECUTE IMMEDIATE  'COMMENT ON COLUMN "UNIPAGO"."SRE_HISTORICO_DOCUMENTOS_MV"."ID_NSS" IS ''Numero unico de Seguridad Social del ciudadano.''';
  EXECUTE IMMEDIATE  'COMMENT ON COLUMN "UNIPAGO"."SRE_HISTORICO_DOCUMENTOS_MV"."TIPO_DOCUMENTO" IS ''Tipo de documento anterior del ciudadano emitido por la JCE. Puede ser el mismo si solo cambia el numero de documento.''';
  EXECUTE IMMEDIATE  'COMMENT ON COLUMN "UNIPAGO"."SRE_HISTORICO_DOCUMENTOS_MV"."NO_DOCUMENTO" IS ''Numero anterior del documento emitido por la JCE. Puede ser el mismo si solo cambia el tipo de documento.''';
  EXECUTE IMMEDIATE  'COMMENT ON COLUMN "UNIPAGO"."SRE_HISTORICO_DOCUMENTOS_MV"."ULT_FECHA_ACT" IS ''Fecha en que se realizo el cambio del registro.''';

  --Permiso de select para el esquema UN_ACCESO_EXTERIOR sobre la vista materializada UNIPAGO.SRE_HISTORICO_DOCUMENTOS_MV
  EXECUTE IMMEDIATE 'GRANT SELECT ON UNIPAGO.SRE_HISTORICO_DOCUMENTOS_MV TO UN_ACCESO_EXTERIOR';

  --Creacion se synonym en el esquema UN_ACCESO_EXTERIOR para acceder a la vista materializada UNIPAGO.SRE_HISTORICO_DOCUMENTOS_MV
  EXECUTE IMMEDIATE 'CREATE SYNONYM UN_ACCESO_EXTERIOR.SRE_HISTORICO_DOCUMENTOS_MV FOR UNIPAGO.SRE_HISTORICO_DOCUMENTOS_MV';
END;
