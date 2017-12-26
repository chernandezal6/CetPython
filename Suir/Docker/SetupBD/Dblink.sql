set define off;

declare
  userexist integer;
begin
  -- Creacion del usuario SUIRPLUS y asignacion de privilegios
  select count(*) into userexist from dba_users where username='SUIRPLUS';

  if (userexist = 0) then
    execute immediate 'CREATE USER SUIRPLUS IDENTIFIED BY sp1010 DEFAULT TABLESPACE USERS';
  end if;

-- Creacion del usuario UNIPAGO y asignacion de privilegios
  select count(*) into userexist from dba_users where username='DGIISUIR';

  if (userexist = 0) then
    execute immediate 'CREATE USER DGIISUIR IDENTIFIED BY sp1010 DEFAULT TABLESPACE USERS';
  end if;

  -- Creacion del usuario UN_ACCESO_EXTERIOR y asignacion de privilegios
  select count(*) into userexist from dba_users where username='TSS';

  if (userexist = 0) then
    execute immediate 'CREATE USER TSS IDENTIFIED BY sp1010 DEFAULT TABLESPACE USERS';
  end if;

  execute immediate 'GRANT DBA to SUIRPLUS WITH ADMIN OPTION';
  execute immediate 'GRANT DBA to DGIISUIR WITH ADMIN OPTION';
  execute immediate 'GRANT DBA to TSS WITH ADMIN OPTION';

  execute immediate 'GRANT ALL PRIVILEGES TO SUIRPLUS';
  execute immediate 'GRANT ALL PRIVILEGES TO DGIISUIR';
  execute immediate 'GRANT ALL PRIVILEGES TO TSS';

  execute immediate 'CREATE DIRECTORY DOCKER AS ''/u01/app/oracle/product/11.2.0/xe/docker''';
  execute immediate 'ALTER DATABASE DATAFILE ''/u01/app/oracle/oradata/XE/system.dbf'' AUTOEXTEND ON NEXT 1M MAXSIZE 1024M';
EXCEPTION
    WHEN OTHERS THEN
  		dbms_output.put_line('Error message was: ' || SQLERRM);
end;
/

-- Create table
create table DGIISUIR.DECLARACIONES_PAGOS_DGII_P
(
  rnc_cedula         VARCHAR2(11),
  periodo_pago       NUMBER(6),
  tipo_declaracion   VARCHAR2(1),
  fecha_presentacion DATE,
  fecha_pago         DATE,
  total_pagado       NUMBER(13,2),
  total_impuesto     NUMBER(13,2),
  total_recargo      NUMBER(13,2),
  total_interes      NUMBER(13,2),
  fecha_proceso      DATE
);
-- Add comments to the columns 
comment on column DGIISUIR.DECLARACIONES_PAGOS_DGII_P.rnc_cedula
  is 'RNC o Cedula del empleador';
comment on column DGIISUIR.DECLARACIONES_PAGOS_DGII_P.periodo_pago
  is 'Período del pago';
comment on column DGIISUIR.DECLARACIONES_PAGOS_DGII_P.tipo_declaracion
  is 'Tipo de declacion N= Normal, R= Regenerada';
comment on column DGIISUIR.DECLARACIONES_PAGOS_DGII_P.fecha_presentacion
  is 'Fecha de presentación de la declaración';
comment on column DGIISUIR.DECLARACIONES_PAGOS_DGII_P.fecha_pago
  is 'Fecha en que se realizó en pago en la entidad bancaria';
comment on column DGIISUIR.DECLARACIONES_PAGOS_DGII_P.total_pagado
  is 'Total pagado de la declaración';
comment on column DGIISUIR.DECLARACIONES_PAGOS_DGII_P.total_impuesto
  is 'Total de impuesto a pagar';
comment on column DGIISUIR.DECLARACIONES_PAGOS_DGII_P.total_recargo
  is 'Total recargo liquidación';
comment on column DGIISUIR.DECLARACIONES_PAGOS_DGII_P.total_interes
  is 'Total intereses de IR3';
comment on column DGIISUIR.DECLARACIONES_PAGOS_DGII_P.fecha_proceso
  is 'Fecha proceso del pago';

-- Create table
create table DGIISUIR.DGIITSS_RUC_GENERAL_D
(
  drg_rnc_cedula           VARCHAR2(14),
  drg_nombre_razon_social  VARCHAR2(115),
  drg_tipo_persona         VARCHAR2(14),
  drg_nombre_comercial     VARCHAR2(60),
  drg_telefono             VARCHAR2(10),
  drg_fax                  VARCHAR2(10),
  drg_cod_unidad           NUMBER(4),
  drg_administracion_local VARCHAR2(40),
  drg_tae_cod_actividad    NUMBER(8),
  drg_actividad_economica  VARCHAR2(200),
  drg_direccion            VARCHAR2(60),
  drg_numero               VARCHAR2(8),
  drg_num_apto_ofic        VARCHAR2(30),
  drg_referencia           VARCHAR2(200),
  drg_urbanizacion         VARCHAR2(120),
  drg_ciudad               VARCHAR2(30),
  fec_nac_const            DATE,
  fec_ini_act              DATE,
  fec_ini_obligaciones     DATE,
  estatus                  VARCHAR2(12),
  rge_tmu_cod_municipio    NUMBER(6),
  fecha_act                DATE
);
-- Add comments to the columns 
comment on column DGIISUIR.DGIITSS_RUC_GENERAL_D.drg_rnc_cedula
  is 'RNC o Cedula del empleador';
comment on column DGIISUIR.DGIITSS_RUC_GENERAL_D.drg_nombre_razon_social
  is 'Razón social del empleador';
comment on column DGIISUIR.DGIITSS_RUC_GENERAL_D.drg_tipo_persona
  is 'Tipo persona del empleador en DGII';
comment on column DGIISUIR.DGIITSS_RUC_GENERAL_D.drg_nombre_comercial
  is 'Nombre comercial del empleador';
comment on column DGIISUIR.DGIITSS_RUC_GENERAL_D.drg_telefono
  is 'Telefono del empleador';
comment on column DGIISUIR.DGIITSS_RUC_GENERAL_D.drg_fax
  is 'Fax del empleador';
comment on column DGIISUIR.DGIITSS_RUC_GENERAL_D.drg_cod_unidad
  is 'Codigo de la unidad del empleador';
comment on column DGIISUIR.DGIITSS_RUC_GENERAL_D.drg_administracion_local
  is 'Administración local del empleador';
comment on column DGIISUIR.DGIITSS_RUC_GENERAL_D.drg_tae_cod_actividad
  is 'Codigo de la actividad economica';
comment on column DGIISUIR.DGIITSS_RUC_GENERAL_D.drg_actividad_economica
  is 'Actividad económica del empleador';
comment on column DGIISUIR.DGIITSS_RUC_GENERAL_D.drg_direccion
  is 'Dirección del empleador';
comment on column DGIISUIR.DGIITSS_RUC_GENERAL_D.drg_numero
  is 'Número';
comment on column DGIISUIR.DGIITSS_RUC_GENERAL_D.drg_num_apto_ofic
  is 'Número de apartamento';
comment on column DGIISUIR.DGIITSS_RUC_GENERAL_D.drg_referencia
  is 'Referencia de la dirección';
comment on column DGIISUIR.DGIITSS_RUC_GENERAL_D.drg_urbanizacion
  is 'Urbanización del empleador';
comment on column DGIISUIR.DGIITSS_RUC_GENERAL_D.drg_ciudad
  is 'Ciudad del empleador';
comment on column DGIISUIR.DGIITSS_RUC_GENERAL_D.fec_nac_const
  is 'Fecha de nacimiento o constitución de la empresa';
comment on column DGIISUIR.DGIITSS_RUC_GENERAL_D.fec_ini_act
  is 'Fecha inicio actividades del empleador en DGII';
comment on column DGIISUIR.DGIITSS_RUC_GENERAL_D.fec_ini_obligaciones
  is 'Fecha inicio oblicaciones del empleador en DGII';
comment on column DGIISUIR.DGIITSS_RUC_GENERAL_D.estatus
  is 'Estatus empleador DGII';
comment on column DGIISUIR.DGIITSS_RUC_GENERAL_D.rge_tmu_cod_municipio
  is 'Codigo del municipio del empleador';
comment on column DGIISUIR.DGIITSS_RUC_GENERAL_D.fecha_act
  is 'Fecha actualización del empleador';

-- Create table
create table SUIRPLUS.ARCHIVOS_TSS_MV
(
  n_num_control    NUMBER(9),
  c_cve_proceso    VARCHAR2(2),
  c_cve_subproceso VARCHAR2(2),
  c_nombre         VARCHAR2(100),
  d_fecha          DATE,
  b_data           BLOB
);

-- Create table
create table SUIRPLUS.ARS_CARTERA_ACEPTADA
(
  codigo_ars         NUMBER(2),
  periodo_factura    VARCHAR2(6),
  tipo_afiliado      VARCHAR2(1),
  cedula_titular     VARCHAR2(11),
  nss_titular        NUMBER,
  cedula_dependiente VARCHAR2(11),
  nss_dependiente    NUMBER,
  estatus_afiliado   VARCHAR2(2),
  codigo_parentesco  VARCHAR2(2),
  discapacitado      VARCHAR2(1),
  estudiante         VARCHAR2(1)
);
-- Add comments to the columns 
comment on column SUIRPLUS.ARS_CARTERA_ACEPTADA.codigo_ars
  is 'ID del ARS, ver SUIRPLUS.ARS_CATALOGO_T';
comment on column SUIRPLUS.ARS_CARTERA_ACEPTADA.periodo_factura
  is 'Período de la factura';
comment on column SUIRPLUS.ARS_CARTERA_ACEPTADA.tipo_afiliado
  is 'T = Titular, D = Dependiente, A = Dependiente Adicional';
comment on column SUIRPLUS.ARS_CARTERA_ACEPTADA.cedula_titular
  is 'Número de documento del titular';
comment on column SUIRPLUS.ARS_CARTERA_ACEPTADA.nss_titular
  is 'Número de seguridad social del titular, ver SUIRPLUS.SRE_CIUDADANOS_T';
comment on column SUIRPLUS.ARS_CARTERA_ACEPTADA.cedula_dependiente
  is 'Número de documento del dependiente';
comment on column SUIRPLUS.ARS_CARTERA_ACEPTADA.nss_dependiente
  is 'Número de seguridad social del dependiente, ver SUIRPLUS.SRE_CIUDADANOS_T';
comment on column SUIRPLUS.ARS_CARTERA_ACEPTADA.estatus_afiliado
  is 'Estatus del afiliado en la cartera';
comment on column SUIRPLUS.ARS_CARTERA_ACEPTADA.codigo_parentesco
  is 'Código del parentesco, ver suirplus.ars_parentescos_t';
comment on column SUIRPLUS.ARS_CARTERA_ACEPTADA.discapacitado
  is 'Si el ciudadano es discapacitado o no, S/N';
comment on column SUIRPLUS.ARS_CARTERA_ACEPTADA.estudiante
  is 'Si el ciudadano es estudiante o no, S/N';

-- Create table
create table SUIRPLUS.ARS_COBERTURA
(
  codigo_ars               NUMBER(2),
  periodo_factura          VARCHAR2(6),
  nss_titular              NUMBER(9),
  nss_reporta_pago         NUMBER(9),
  id_referencia            VARCHAR2(16),
  fecha_creacion_cobertura DATE
);
-- Add comments to the columns 
comment on column SUIRPLUS.ARS_COBERTURA.codigo_ars
  is 'ID del ARS, ver SUIRPLUS.ARS_CATALOGO_T';
comment on column SUIRPLUS.ARS_COBERTURA.periodo_factura
  is 'Período de la factura';
comment on column SUIRPLUS.ARS_COBERTURA.nss_titular
  is 'Número de seguridad social del titular, ver SUIRPLUS.SRE_CIUDADANOS_T';
comment on column SUIRPLUS.ARS_COBERTURA.nss_reporta_pago
  is 'Número de seguridad social del afiliado que disparó el pago de la cobertura del período, ver SUIRPLUS.SRE_CIUDADANOS_T';
comment on column SUIRPLUS.ARS_COBERTURA.id_referencia
  is 'Nro. de la referencia';
comment on column SUIRPLUS.ARS_COBERTURA.fecha_creacion_cobertura
  is 'Fecha en que se creó la cobertura';

-- Create table
create table SUIRPLUS.ARS_DISPERSION
(
  codigo_ars          NUMBER,
  periodo_factura     VARCHAR2(6),
  nss_titular         NUMBER,
  nss_afiliado_pagado NUMBER,
  nss_dispara_pago    NUMBER,
  id_referencia       VARCHAR2(16),
  monto_dispersar     NUMBER,
  fecha_consolidado   DATE
);

-- Create table
create table SUIRPLUS.ARS_DISPERSION_FONAMAT_MV
(
  codigo_ars          NUMBER(2),
  periodo_factura     VARCHAR2(6),
  nss_titular         NUMBER(9),
  nss_afiliado_pagado NUMBER(9),
  nss_dispara_pago    NUMBER(9),
  id_referencia       VARCHAR2(16),
  monto_dispersar     NUMBER,
  fecha_consolidado   DATE
);
-- Add comments to the columns 
comment on column SUIRPLUS.ARS_DISPERSION_FONAMAT_MV.codigo_ars
  is 'ID del ARS, ver SUIRPLUS.ARS_CATALOGO_T';
comment on column SUIRPLUS.ARS_DISPERSION_FONAMAT_MV.periodo_factura
  is 'Período de la factura';
comment on column SUIRPLUS.ARS_DISPERSION_FONAMAT_MV.nss_titular
  is 'Número de seguridad social del titular, ver SUIRPLUS.SRE_CIUDADANOS_T';
comment on column SUIRPLUS.ARS_DISPERSION_FONAMAT_MV.nss_afiliado_pagado
  is 'Número de seguridad social del afiliado pagado, ver SUIRPLUS.SRE_CIUDADANOS_T';
comment on column SUIRPLUS.ARS_DISPERSION_FONAMAT_MV.nss_dispara_pago
  is 'Número de seguridad social del afiliado que disparó el pago de la cobertura del período, ver SUIRPLUS.SRE_CIUDADANOS_T';
comment on column SUIRPLUS.ARS_DISPERSION_FONAMAT_MV.id_referencia
  is 'Nro. de la referenciao';
comment on column SUIRPLUS.ARS_DISPERSION_FONAMAT_MV.monto_dispersar
  is 'Monto del percapita a dispersar';
comment on column SUIRPLUS.ARS_DISPERSION_FONAMAT_MV.fecha_consolidado
  is 'Fecha de consolidación';

-- Create table
create table SUIRPLUS.ARS_NUEVOS_OK_PERIODO
(
  codigo_ars         NUMBER,
  periodo_factura    VARCHAR2(255),
  tipo_afiliado      VARCHAR2(255),
  nss_titular        NUMBER,
  nss_dependiente    NUMBER,
  codigo_parentesco  VARCHAR2(255),
  discapacitado      VARCHAR2(255),
  estudiante         VARCHAR2(255),
  ciclo              VARCHAR2(255),
  cedula_titular     VARCHAR2(255),
  cedula_dependiente VARCHAR2(255),
  estatus_afiliado   VARCHAR2(255),
  cod_escenario      NUMBER
);

-- Create table
create table SUIRPLUS.ARS_NUEVOS_OK_PERIODO_TMP
(
  codigo_ars        NUMBER(2),
  periodo_factura   VARCHAR2(6),
  tipo_afiliado     VARCHAR2(1),
  nss_titular       VARCHAR2(9),
  nss_dependiente   VARCHAR2(9),
  codigo_parentesco VARCHAR2(2),
  discapacitado     VARCHAR2(1),
  estudiante        VARCHAR2(1)
);
-- Add comments to the columns 
comment on column SUIRPLUS.ARS_NUEVOS_OK_PERIODO_TMP.codigo_ars
  is 'ID del ARS, ver SUIRPLUS.ARS_CATALOGO_T';
comment on column SUIRPLUS.ARS_NUEVOS_OK_PERIODO_TMP.periodo_factura
  is 'Período de la factura';
comment on column SUIRPLUS.ARS_NUEVOS_OK_PERIODO_TMP.tipo_afiliado
  is 'T = Titular, D = Dependiente, A = Dependiente Adicional';
comment on column SUIRPLUS.ARS_NUEVOS_OK_PERIODO_TMP.nss_titular
  is 'Número de seguridad social del titular, ver SUIRPLUS.SRE_CIUDADANOS_T';
comment on column SUIRPLUS.ARS_NUEVOS_OK_PERIODO_TMP.nss_dependiente
  is 'Número de seguridad social del dependiente, ver SUIRPLUS.SRE_CIUDADANOS_T';
comment on column SUIRPLUS.ARS_NUEVOS_OK_PERIODO_TMP.codigo_parentesco
  is 'Código del parentesco, ver suirplus.ars_parentescos_t';
comment on column SUIRPLUS.ARS_NUEVOS_OK_PERIODO_TMP.discapacitado
  is 'Si el ciudadano es discapacitado o no, S/N';
comment on column SUIRPLUS.ARS_NUEVOS_OK_PERIODO_TMP.estudiante
  is 'Si el ciudadano es estudiante o no, S/N';

-- Create table
create table SUIRPLUS.ARS_RECLAMO_RECIEN_NACIDOS_MV
(
  codigo_ars        NUMBER(2),
  periodo_factura   VARCHAR2(6),
  tipo_afiliado     VARCHAR2(1),
  nss_titular       VARCHAR2(9),
  nss_dependiente   VARCHAR2(9),
  codigo_parentesco VARCHAR2(2),
  discapacitado     VARCHAR2(1),
  estudiante        VARCHAR2(1)
);
-- Add comments to the columns 
comment on column SUIRPLUS.ARS_RECLAMO_RECIEN_NACIDOS_MV.codigo_ars
  is 'ID del ARS, ver SUIRPLUS.ARS_CATALOGO_T';
comment on column SUIRPLUS.ARS_RECLAMO_RECIEN_NACIDOS_MV.periodo_factura
  is 'Período de la factura';
comment on column SUIRPLUS.ARS_RECLAMO_RECIEN_NACIDOS_MV.tipo_afiliado
  is 'T = Titular, D = Dependiente, A = Dependiente Adicional';
comment on column SUIRPLUS.ARS_RECLAMO_RECIEN_NACIDOS_MV.nss_titular
  is 'Número de seguridad social del titular, ver SUIRPLUS.SRE_CIUDADANOS_T';
comment on column SUIRPLUS.ARS_RECLAMO_RECIEN_NACIDOS_MV.nss_dependiente
  is 'Número de seguridad social del dependiente, ver SUIRPLUS.SRE_CIUDADANOS_T';
comment on column SUIRPLUS.ARS_RECLAMO_RECIEN_NACIDOS_MV.codigo_parentesco
  is 'Código del parentesco, ver suirplus.ars_parentescos_t';
comment on column SUIRPLUS.ARS_RECLAMO_RECIEN_NACIDOS_MV.discapacitado
  is 'Si el ciudadano es discapacitado o no, S/N';
comment on column SUIRPLUS.ARS_RECLAMO_RECIEN_NACIDOS_MV.estudiante
  is 'Si el ciudadano es estudiante o no, S/N';

-- Create table
create table SUIRPLUS.BAJA_DEP_SIN_ACTUAL_ACTA_MV
(
  codigo_ars       NUMBER(2),
  cedula_titular   VARCHAR2(11),
  nss_titular      NUMBER(9),
  nss_dependiente  NUMBER(9),
  acta_municipio   VARCHAR2(10),
  acta_oficialia   VARCHAR2(10),
  acta_libro       VARCHAR2(10),
  acta_folio       VARCHAR2(10),
  numero_de_acta   VARCHAR2(10),
  acta_anio        VARCHAR2(4),
  fecha_nacimiento VARCHAR2(8),
  fecha_insercion  VARCHAR2(10)
);
-- Add comments to the columns 
comment on column SUIRPLUS.BAJA_DEP_SIN_ACTUAL_ACTA_MV.codigo_ars
  is 'ID del ARS, ver SUIRPLUS.ARS_CATALOGO_T';
comment on column SUIRPLUS.BAJA_DEP_SIN_ACTUAL_ACTA_MV.cedula_titular
  is 'Número de documento del titular';
comment on column SUIRPLUS.BAJA_DEP_SIN_ACTUAL_ACTA_MV.nss_titular
  is 'Número de seguridad social del titular, ver SUIRPLUS.SRE_CIUDADANOS_T';
comment on column SUIRPLUS.BAJA_DEP_SIN_ACTUAL_ACTA_MV.nss_dependiente
  is 'Número de seguridad social del dependiente, ver SUIRPLUS.SRE_CIUDADANOS_T';
comment on column SUIRPLUS.BAJA_DEP_SIN_ACTUAL_ACTA_MV.acta_municipio
  is 'Codigo de municipio del acta de nacimiento';
comment on column SUIRPLUS.BAJA_DEP_SIN_ACTUAL_ACTA_MV.acta_oficialia
  is 'Codigo de oficialia del acta de nacimiento';
comment on column SUIRPLUS.BAJA_DEP_SIN_ACTUAL_ACTA_MV.acta_libro
  is 'Número de libro del acta de nacimiento';
comment on column SUIRPLUS.BAJA_DEP_SIN_ACTUAL_ACTA_MV.acta_folio
  is 'Número de folio del acta de nacimiento';
comment on column SUIRPLUS.BAJA_DEP_SIN_ACTUAL_ACTA_MV.numero_de_acta
  is 'Número del acta de nacimiento del ciudadano';
comment on column SUIRPLUS.BAJA_DEP_SIN_ACTUAL_ACTA_MV.acta_anio
  is 'Año del acta de nacimiento';
comment on column SUIRPLUS.BAJA_DEP_SIN_ACTUAL_ACTA_MV.fecha_nacimiento
  is 'Fecha de nacimiento';
comment on column SUIRPLUS.BAJA_DEP_SIN_ACTUAL_ACTA_MV.fecha_insercion
  is 'Fecha de inserción';

-- Create table
create table SUIRPLUS.CREDITO_IR3
(
  rnc_cedula      VARCHAR2(11),
  periodo_credito NUMBER(6),
  total_credito   NUMBER(13,2),
  codigo_credito  VARCHAR2(10)
);
-- Add comments to the columns 
comment on column SUIRPLUS.CREDITO_IR3.rnc_cedula
  is 'RNC o Cedula del empleador';
comment on column SUIRPLUS.CREDITO_IR3.periodo_credito
  is 'Período en el cual se aplicará el crédito';
comment on column SUIRPLUS.CREDITO_IR3.total_credito
  is 'Total del crédito IR3';
comment on column SUIRPLUS.CREDITO_IR3.codigo_credito
  is 'Codigo del Credito (Valores: R18, Credito, etc).';

-- Create table
create table SUIRPLUS.CS_C_RUBROS
(
  n_cve_rubro  NUMBER(2),
  c_desc_rubro VARCHAR2(50),
  n_seguro     NUMBER(1)
);
-- Add comments to the columns 
comment on column SUIRPLUS.CS_C_RUBROS.n_cve_rubro
  is 'Número del Rubro';
comment on column SUIRPLUS.CS_C_RUBROS.c_desc_rubro
  is 'Descripcion del Rubro.';
comment on column SUIRPLUS.CS_C_RUBROS.n_seguro
  is 'Número de seguro';

-- Create table
create table SUIRPLUS.CS_R_ENTRADAS
(
  n_proceso         NUMBER(2),
  n_tipo_entidad    NUMBER(2),
  n_cve_entidad     NUMBER(2),
  n_seguro          NUMBER(1),
  n_cve_rubro       NUMBER(2),
  n_tipo_registro   NUMBER(1),
  n_tipo_referencia NUMBER(1),
  n_monto           NUMBER(13,2),
  c_fecha           VARCHAR2(8),
  n_num_entrada     NUMBER(9)
);
-- Add comments to the columns 
comment on column SUIRPLUS.CS_R_ENTRADAS.n_proceso
  is 'Número de proceso';
comment on column SUIRPLUS.CS_R_ENTRADAS.n_tipo_entidad
  is 'Número del tipo de entidad que realizó movimiento.';
comment on column SUIRPLUS.CS_R_ENTRADAS.n_cve_entidad
  is 'Número de la entidad';
comment on column SUIRPLUS.CS_R_ENTRADAS.n_seguro
  is 'Número de seguro';
comment on column SUIRPLUS.CS_R_ENTRADAS.n_cve_rubro
  is 'Número del Rubro';
comment on column SUIRPLUS.CS_R_ENTRADAS.n_tipo_registro
  is 'Número de tipo de registro';
comment on column SUIRPLUS.CS_R_ENTRADAS.n_tipo_referencia
  is 'Número del tipo de referencia';
comment on column SUIRPLUS.CS_R_ENTRADAS.n_monto
  is 'Monto de la entrada';
comment on column SUIRPLUS.CS_R_ENTRADAS.c_fecha
  is 'Fecha de la entrada contable';
comment on column SUIRPLUS.CS_R_ENTRADAS.n_num_entrada
  is 'Número de la entrada contable';

-- Create table
create table SUIRPLUS.DGIITSS_RUC_GENERAL
(
  drg_rnc_cedula           VARCHAR2(14),
  drg_nombre_razon_social  VARCHAR2(115),
  drg_tipo_persona         VARCHAR2(14),
  drg_nombre_comercial     VARCHAR2(60),
  drg_telefono             VARCHAR2(10),
  drg_fax                  VARCHAR2(10),
  drg_cod_unidad           NUMBER(4),
  drg_administracion_local VARCHAR2(40),
  drg_tae_cod_actividad    NUMBER(8),
  drg_actividad_economica  VARCHAR2(200),
  drg_direccion            VARCHAR2(60),
  drg_numero               VARCHAR2(8),
  drg_num_apto_ofic        VARCHAR2(30),
  drg_referencia           VARCHAR2(2000),
  drg_urbanizacion         VARCHAR2(120),
  drg_ciudad               VARCHAR2(30),
  fec_nac_const            DATE,
  fec_ini_act              DATE,
  fec_ini_obligaciones     DATE,
  estatus                  VARCHAR2(12),
  rge_tmu_cod_municipio    NUMBER(6)
);
-- Add comments to the columns 
comment on column SUIRPLUS.DGIITSS_RUC_GENERAL.drg_rnc_cedula
  is 'RNC o Cedula del empleador';
comment on column SUIRPLUS.DGIITSS_RUC_GENERAL.drg_nombre_razon_social
  is 'Razón social del empleador';
comment on column SUIRPLUS.DGIITSS_RUC_GENERAL.drg_tipo_persona
  is 'Tipo persona del empleador en DGII';
comment on column SUIRPLUS.DGIITSS_RUC_GENERAL.drg_nombre_comercial
  is 'Nombre comercial del empleador';
comment on column SUIRPLUS.DGIITSS_RUC_GENERAL.drg_telefono
  is 'Telefono del empleador';
comment on column SUIRPLUS.DGIITSS_RUC_GENERAL.drg_fax
  is 'Fax del empleador';
comment on column SUIRPLUS.DGIITSS_RUC_GENERAL.drg_cod_unidad
  is 'Codigo de la unidad del empleador';
comment on column SUIRPLUS.DGIITSS_RUC_GENERAL.drg_administracion_local
  is 'Administración local del empleador';
comment on column SUIRPLUS.DGIITSS_RUC_GENERAL.drg_tae_cod_actividad
  is 'Codigo de la actividad economica';
comment on column SUIRPLUS.DGIITSS_RUC_GENERAL.drg_actividad_economica
  is 'Actividad económica del empleador';
comment on column SUIRPLUS.DGIITSS_RUC_GENERAL.drg_direccion
  is 'Dirección del empleador';
comment on column SUIRPLUS.DGIITSS_RUC_GENERAL.drg_numero
  is 'Número';
comment on column SUIRPLUS.DGIITSS_RUC_GENERAL.drg_num_apto_ofic
  is 'Número de apartamento';
comment on column SUIRPLUS.DGIITSS_RUC_GENERAL.drg_referencia
  is 'Referencia de la dirección';
comment on column SUIRPLUS.DGIITSS_RUC_GENERAL.drg_urbanizacion
  is 'Urbanización del empleador';
comment on column SUIRPLUS.DGIITSS_RUC_GENERAL.drg_ciudad
  is 'Ciudad del empleador';
comment on column SUIRPLUS.DGIITSS_RUC_GENERAL.fec_nac_const
  is 'Fecha de nacimiento o constitución de la empresa';
comment on column SUIRPLUS.DGIITSS_RUC_GENERAL.fec_ini_act
  is 'Fecha inicio actividades del empleador en DGII';
comment on column SUIRPLUS.DGIITSS_RUC_GENERAL.fec_ini_obligaciones
  is 'Fecha inicio oblicaciones del empleador en DGII';
comment on column SUIRPLUS.DGIITSS_RUC_GENERAL.estatus
  is 'Estatus empleador DGII';
comment on column SUIRPLUS.DGIITSS_RUC_GENERAL.rge_tmu_cod_municipio
  is 'Codigo del municipio del empleador';

-- Create table
create table SUIRPLUS.DGIITSS_RUC_GENERAL_D_2
(
  drg_rnc_cedula           VARCHAR2(14),
  drg_nombre_razon_social  VARCHAR2(115),
  drg_tipo_persona         VARCHAR2(14),
  drg_nombre_comercial     VARCHAR2(60),
  drg_telefono             VARCHAR2(10),
  drg_fax                  VARCHAR2(10),
  drg_cod_unidad           NUMBER(4),
  drg_administracion_local VARCHAR2(40),
  drg_tae_cod_actividad    VARCHAR2(8),
  drg_actividad_economica  VARCHAR2(200),
  drg_direccion            VARCHAR2(60),
  drg_numero               VARCHAR2(8),
  drg_num_apto_ofic        VARCHAR2(30),
  drg_referencia           VARCHAR2(200),
  drg_urbanizacion         VARCHAR2(60),
  drg_ciudad               VARCHAR2(30),
  fec_nac_const            DATE,
  fec_ini_act              DATE,
  fec_ini_obligaciones     DATE,
  estatus                  VARCHAR2(14),
  rge_tmu_cod_municipio    NUMBER(6),
  fecha_act                DATE
);

-- Create table
create table SUIRPLUS.DGII_ISR_STATUS_LOCAL_V
(
  rnc                       VARCHAR2(11) not null,
  periodo_liquidacion       NUMBER(6) not null,
  is_presento               CHAR(1),
  is_pago                   CHAR(1),
  is_autoriza_rectificativa CHAR(1)
);
-- Add comments to the columns 
comment on column SUIRPLUS.DGII_ISR_STATUS_LOCAL_V.rnc
  is 'RNC o Cedula del empleador';
comment on column SUIRPLUS.DGII_ISR_STATUS_LOCAL_V.periodo_liquidacion
  is 'Período de la liquidación';
comment on column SUIRPLUS.DGII_ISR_STATUS_LOCAL_V.is_presento
  is 'Si el empleador presentó declaración en DGII, S="SI", N="NO"';
comment on column SUIRPLUS.DGII_ISR_STATUS_LOCAL_V.is_pago
  is 'Si el empleador pago declaración en DGII, S="SI", N="NO"';
comment on column SUIRPLUS.DGII_ISR_STATUS_LOCAL_V.is_autoriza_rectificativa
  is 'Para saber si puede realizar rectificativa';

-- Create table
create table SUIRPLUS.DGII_ISR_STATUS_V
(
  rnc                       VARCHAR2(11) not null,
  periodo_liquidacion       NUMBER(6) not null,
  is_presento               CHAR(1),
  is_pago                   CHAR(1),
  is_autoriza_rectificativa CHAR(1)
);

-- Create table
create table SUIRPLUS.DDGII_PAGOS_IR3_MV
(
  rnc_cedula         VARCHAR2(11),
  periodo_pago       NUMBER(6),
  tipo_declaracion   VARCHAR2(1),
  fecha_presentacion DATE,
  fecha_pago         DATE,
  total_pagado       NUMBER(13,2),
  total_impuesto     NUMBER(13,2),
  total_recargo      NUMBER(13,2),
  total_interes      NUMBER(13,2),
  fecha_proceso      DATE
);
-- Add comments to the columns 
comment on column SUIRPLUS.DDGII_PAGOS_IR3_MV.rnc_cedula
  is 'RNC o Cedula del empleador';
comment on column SUIRPLUS.DDGII_PAGOS_IR3_MV.periodo_pago
  is 'Período del pago';
comment on column SUIRPLUS.DDGII_PAGOS_IR3_MV.tipo_declaracion
  is 'Tipo de declacion N= Normal, R= Regenerada';
comment on column SUIRPLUS.DDGII_PAGOS_IR3_MV.fecha_presentacion
  is 'Fecha de presentación de la declaración';
comment on column SUIRPLUS.DDGII_PAGOS_IR3_MV.fecha_pago
  is 'Fecha en que se realizó en pago en la entidad bancaria';
comment on column SUIRPLUS.DDGII_PAGOS_IR3_MV.total_pagado
  is 'Total pagado de la declaración';
comment on column SUIRPLUS.DDGII_PAGOS_IR3_MV.total_impuesto
  is 'Total de impuesto a pagar';
comment on column SUIRPLUS.DDGII_PAGOS_IR3_MV.total_recargo
  is 'Total recargo liquidación';
comment on column SUIRPLUS.DDGII_PAGOS_IR3_MV.total_interes
  is 'Total intereses de IR3';
comment on column SUIRPLUS.DDGII_PAGOS_IR3_MV.fecha_proceso
  is 'Fecha proceso del pago';

-- Create table
create table SUIRPLUS.DGI_ACTIVIDADES_ECONOMICAS_MV
(
  tae_cod_actividad NUMBER(8) not null,
  tae_nom_actividad VARCHAR2(200) not null
);
-- Add comments to the columns 
comment on column SUIRPLUS.DGI_ACTIVIDADES_ECONOMICAS_MV.tae_cod_actividad
  is 'Código de la actividad económica';
comment on column SUIRPLUS.DGI_ACTIVIDADES_ECONOMICAS_MV.tae_nom_actividad
  is 'Nombre de la actividad economica';

-- Create table
create table SUIRPLUS.DGI_ADMINISTRACION_LOCAL_MV
(
  tab_cod_unidad NUMBER(4) not null,
  tab_nom_unidad VARCHAR2(40),
  tab_tip_unidad NUMBER(1)
);
-- Add comments to the columns 
comment on column SUIRPLUS.DGI_ADMINISTRACION_LOCAL_MV.tab_cod_unidad
  is 'Código de la unidad de la administración local';
comment on column SUIRPLUS.DGI_ADMINISTRACION_LOCAL_MV.tab_nom_unidad
  is 'Nombre de la unidad de la administración local';
comment on column SUIRPLUS.DGI_ADMINISTRACION_LOCAL_MV.tab_tip_unidad
  is 'Tipo de la unidad de la administración local';

-- Create table
create table SUIRPLUS.DGI_CREDITOS_IR3_MV
(
  rnc_cedula      VARCHAR2(11) not null,
  periodo_credito NUMBER(6),
  total_credito   NUMBER(13,2),
  codigo_credito  VARCHAR2(10)
);
-- Add comments to the columns 
comment on column SUIRPLUS.DGI_CREDITOS_IR3_MV.rnc_cedula
  is 'RNC o Cedula del empleador';
comment on column SUIRPLUS.DGI_CREDITOS_IR3_MV.periodo_credito
  is 'Período en el cual se aplicará el crédito';
comment on column SUIRPLUS.DGI_CREDITOS_IR3_MV.total_credito
  is 'Total del crédito IR3';
comment on column SUIRPLUS.DGI_CREDITOS_IR3_MV.codigo_credito
  is 'Codigo del Credito (Valores: R18, Credito, etc).';

-- Create table
create table SUIRPLUS.DGI_EMPLEADORES_DIARIOS_MV
(
  drg_rnc_cedula           VARCHAR2(14) not null,
  drg_nombre_razon_social  VARCHAR2(115),
  drg_tipo_persona         VARCHAR2(14),
  drg_nombre_comercial     VARCHAR2(60),
  drg_telefono             VARCHAR2(10),
  drg_fax                  VARCHAR2(10),
  drg_cod_unidad           NUMBER(4),
  drg_administracion_local VARCHAR2(40),
  drg_tae_cod_actividad    NUMBER(8),
  drg_actividad_economica  VARCHAR2(200),
  drg_direccion            VARCHAR2(60),
  drg_numero               VARCHAR2(8),
  drg_num_apto_ofic        VARCHAR2(30),
  drg_referencia           VARCHAR2(200),
  drg_urbanizacion         VARCHAR2(120),
  drg_ciudad               VARCHAR2(30),
  fec_nac_const            DATE,
  fec_ini_act              DATE,
  fec_ini_obligaciones     DATE,
  estatus                  VARCHAR2(12),
  rge_tmu_cod_municipio    NUMBER(6),
  fecha_act                DATE
);
-- Add comments to the columns 
comment on column SUIRPLUS.DGI_EMPLEADORES_DIARIOS_MV.drg_rnc_cedula
  is 'RNC o cédula del empleador';
comment on column SUIRPLUS.DGI_EMPLEADORES_DIARIOS_MV.drg_nombre_razon_social
  is 'Razón social del empleador';
comment on column SUIRPLUS.DGI_EMPLEADORES_DIARIOS_MV.drg_tipo_persona
  is 'Tipo persona del empleador en DGII';
comment on column SUIRPLUS.DGI_EMPLEADORES_DIARIOS_MV.drg_nombre_comercial
  is 'Nombre comercial del empleador';
comment on column SUIRPLUS.DGI_EMPLEADORES_DIARIOS_MV.drg_telefono
  is 'Telefono del empleador';
comment on column SUIRPLUS.DGI_EMPLEADORES_DIARIOS_MV.drg_fax
  is 'Fax del empleador';
comment on column SUIRPLUS.DGI_EMPLEADORES_DIARIOS_MV.drg_cod_unidad
  is 'Codigo de la unidad del empleador';
comment on column SUIRPLUS.DGI_EMPLEADORES_DIARIOS_MV.drg_administracion_local
  is 'Administración local del empleador';
comment on column SUIRPLUS.DGI_EMPLEADORES_DIARIOS_MV.drg_tae_cod_actividad
  is 'Codigo de la actividad economica';
comment on column SUIRPLUS.DGI_EMPLEADORES_DIARIOS_MV.drg_actividad_economica
  is 'Actividad económica del empleador';
comment on column SUIRPLUS.DGI_EMPLEADORES_DIARIOS_MV.drg_direccion
  is 'Dirección del empleador';
comment on column SUIRPLUS.DGI_EMPLEADORES_DIARIOS_MV.drg_numero
  is 'Número';
comment on column SUIRPLUS.DGI_EMPLEADORES_DIARIOS_MV.drg_num_apto_ofic
  is 'Número de apartamento';
comment on column SUIRPLUS.DGI_EMPLEADORES_DIARIOS_MV.drg_referencia
  is 'Referencia de la dirección';
comment on column SUIRPLUS.DGI_EMPLEADORES_DIARIOS_MV.drg_urbanizacion
  is 'Urbanización del empleador';
comment on column SUIRPLUS.DGI_EMPLEADORES_DIARIOS_MV.drg_ciudad
  is 'Ciudad del empleador';
comment on column SUIRPLUS.DGI_EMPLEADORES_DIARIOS_MV.fec_nac_const
  is 'Fecha de nacimiento o constitución de la empresa';
comment on column SUIRPLUS.DGI_EMPLEADORES_DIARIOS_MV.fec_ini_act
  is 'Fecha inicio actividades del empleador en DGII';
comment on column SUIRPLUS.DGI_EMPLEADORES_DIARIOS_MV.fec_ini_obligaciones
  is 'Fecha inicio oblicaciones del empleador en DGII';
comment on column SUIRPLUS.DGI_EMPLEADORES_DIARIOS_MV.estatus
  is 'Estatus empleador DGII';
comment on column SUIRPLUS.DGI_EMPLEADORES_DIARIOS_MV.rge_tmu_cod_municipio
  is 'Codigo del municipio del empleador';
comment on column SUIRPLUS.DGI_EMPLEADORES_DIARIOS_MV.fecha_act
  is 'Fecha actualización del empleador';

-- Create table
create table SUIRPLUS.DGI_EMPLEADORES_MV
(
  drg_rnc_cedula           VARCHAR2(14) not null,
  drg_nombre_razon_social  VARCHAR2(115),
  drg_tipo_persona         VARCHAR2(14),
  drg_nombre_comercial     VARCHAR2(60),
  drg_telefono             VARCHAR2(10),
  drg_fax                  VARCHAR2(10),
  drg_cod_unidad           NUMBER(4),
  drg_administracion_local VARCHAR2(40),
  drg_tae_cod_actividad    NUMBER(8),
  drg_actividad_economica  VARCHAR2(200),
  drg_direccion            VARCHAR2(60),
  drg_numero               VARCHAR2(8),
  drg_num_apto_ofic        VARCHAR2(30),
  drg_referencia           VARCHAR2(2000),
  drg_urbanizacion         VARCHAR2(120),
  drg_ciudad               VARCHAR2(30),
  fec_nac_const            DATE,
  fec_ini_act              DATE,
  fec_ini_obligaciones     DATE,
  estatus                  VARCHAR2(12),
  rge_tmu_cod_municipio    NUMBER(6)
);
-- Add comments to the columns 
comment on column SUIRPLUS.DGI_EMPLEADORES_MV.drg_rnc_cedula
  is 'RNC o cédula del empleador';
comment on column SUIRPLUS.DGI_EMPLEADORES_MV.drg_nombre_razon_social
  is 'Razón social del empleador';
comment on column SUIRPLUS.DGI_EMPLEADORES_MV.drg_tipo_persona
  is 'Tipo persona del empleador en DGII';
comment on column SUIRPLUS.DGI_EMPLEADORES_MV.drg_nombre_comercial
  is 'Nombre comercial del empleador';
comment on column SUIRPLUS.DGI_EMPLEADORES_MV.drg_telefono
  is 'Telefono del empleador';
comment on column SUIRPLUS.DGI_EMPLEADORES_MV.drg_fax
  is 'Fax del empleador';
comment on column SUIRPLUS.DGI_EMPLEADORES_MV.drg_cod_unidad
  is 'Codigo de la unidad del empleador';
comment on column SUIRPLUS.DGI_EMPLEADORES_MV.drg_administracion_local
  is 'Administración local del empleador';
comment on column SUIRPLUS.DGI_EMPLEADORES_MV.drg_tae_cod_actividad
  is 'Codigo de la actividad economica';
comment on column SUIRPLUS.DGI_EMPLEADORES_MV.drg_actividad_economica
  is 'Actividad económica del empleador';
comment on column SUIRPLUS.DGI_EMPLEADORES_MV.drg_direccion
  is 'Dirección del empleador';
comment on column SUIRPLUS.DGI_EMPLEADORES_MV.drg_numero
  is 'Número';
comment on column SUIRPLUS.DGI_EMPLEADORES_MV.drg_num_apto_ofic
  is 'Número de apartamento';
comment on column SUIRPLUS.DGI_EMPLEADORES_MV.drg_referencia
  is 'Referencia de la dirección';
comment on column SUIRPLUS.DGI_EMPLEADORES_MV.drg_urbanizacion
  is 'Urbanización del empleador';
comment on column SUIRPLUS.DGI_EMPLEADORES_MV.drg_ciudad
  is 'Ciudad del empleador';
comment on column SUIRPLUS.DGI_EMPLEADORES_MV.fec_nac_const
  is 'Fecha de nacimiento o constitución de la empresa';
comment on column SUIRPLUS.DGI_EMPLEADORES_MV.fec_ini_act
  is 'Fecha inicio actividades del empleador en DGII';
comment on column SUIRPLUS.DGI_EMPLEADORES_MV.fec_ini_obligaciones
  is 'Fecha inicio oblicaciones del empleador en DGII';
comment on column SUIRPLUS.DGI_EMPLEADORES_MV.estatus
  is 'Estatus empleador DGII';
comment on column SUIRPLUS.DGI_EMPLEADORES_MV.rge_tmu_cod_municipio
  is 'Codigo del municipio del empleador';

-- Create table
create table SUIRPLUS.SFC_FACTURA_INFOTEP_EXT_T
(
  rnc_o_cedula        VARCHAR2(11),
  periodo_liquidacion NUMBER(6),
  monto               NUMBER(13,2),
  status              VARCHAR2(2),
  id_tipo_factura     VARCHAR2(2),
  ult_fecha_act       DATE,
  id_error            VARCHAR2(3)
)
tablespace SYSTEM
  pctfree 10
  pctused 40
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
-- Add comments to the table 
comment on table SUIRPLUS.SFC_FACTURA_INFOTEP_EXT_T
  is 'Informacion proveniente de Infotep para generar facturas extraordinarias';
-- Add comments to the columns 
comment on column SUIRPLUS.SFC_FACTURA_INFOTEP_EXT_T.rnc_o_cedula
  is 'RNC o Cedula del empleador';
comment on column SUIRPLUS.SFC_FACTURA_INFOTEP_EXT_T.periodo_liquidacion
  is 'Período de la liquidación';
comment on column SUIRPLUS.SFC_FACTURA_INFOTEP_EXT_T.monto
  is 'Monto de cada empleador de las facturas extraordinarias de infotep .';
comment on column SUIRPLUS.SFC_FACTURA_INFOTEP_EXT_T.status
  is 'Null = registro nuevo, debe generársele una factura, G  = Factura generada';
comment on column SUIRPLUS.SFC_FACTURA_INFOTEP_EXT_T.id_tipo_factura
  is 'Identificador de los tipos de facturas definidos en la tabla SFC_TIPO_FACTURAS_T';
comment on column SUIRPLUS.SFC_FACTURA_INFOTEP_EXT_T.ult_fecha_act
  is 'Ultima fecha de actualización del registro';
comment on column SUIRPLUS.SFC_FACTURA_INFOTEP_EXT_T.id_error
  is 'Número del error de la factura';

-- Create table
create table SUIRPLUS.SUIR_CIUDADANO_FALLECIDO_MV
(
  n_tipo_entidad_notificacion  NUMBER(2),
  n_entidad_notificacion       NUMBER(2) not null,
  n_num_control                NUMBER(10) not null,
  n_id_registro                NUMBER(9),
  c_tipo_novedad               VARCHAR2(2),
  d_fecha_notificacion         DATE not null,
  n_nss                        NUMBER(10),
  c_num_cedula                 VARCHAR2(11),
  d_fecha_defuncion            DATE,
  b_imagen_acta_defuncion      BLOB,
  c_tipo_imagen_acta_defuncion VARCHAR2(5),
  n_estado_id                  NUMBER(2) not null,
  d_fecha_actualizacion        DATE not null
);

-- Create table
create table SUIRPLUS.SUIR_C_ENTIDAD
(
  n_cve_tipo_entidad NUMBER(2) not null,
  n_cve_entidad      NUMBER(2) not null,
  c_desc_entidad     VARCHAR2(100) not null
);
-- Add comments to the columns 
comment on column SUIRPLUS.SUIR_C_ENTIDAD.n_cve_tipo_entidad
  is 'ID de la entidad recaudadora';
comment on column SUIRPLUS.SUIR_C_ENTIDAD.n_cve_entidad
  is 'Número de la entidad';
comment on column SUIRPLUS.SUIR_C_ENTIDAD.c_desc_entidad
  is 'Descripción del parentesco';

-- Create table
create table SUIRPLUS.SUIR_C_ESTANCIAS_INFANTILES
(
  n_cve_estancia      NUMBER(4) not null,
  c_nombre_estancia   VARCHAR2(250) not null,
  c_rnc               VARCHAR2(15) not null,
  c_calle             VARCHAR2(150),
  c_numero            VARCHAR2(12),
  c_edificio          VARCHAR2(50),
  c_piso              VARCHAR2(20),
  c_apto              VARCHAR2(15),
  c_tel1              VARCHAR2(10),
  c_ext1              VARCHAR2(4),
  c_tel2              VARCHAR2(10),
  c_ext2              VARCHAR2(4),
  c_fax               VARCHAR2(10),
  c_pagina_web        VARCHAR2(150),
  d_fecha_inscripcion DATE not null,
  c_acreditacion      VARCHAR2(20),
  c_cod_provincia     VARCHAR2(3),
  c_cod_municipio     VARCHAR2(4),
  c_cod_sector        VARCHAR2(6),
  c_cod_tipo          VARCHAR2(2),
  c_cod_tipo_hab      VARCHAR2(1),
  c_estatus           VARCHAR2(2)
);

-- Create table
create table SUIRPLUS.SUIR_C_TIPO_ENTIDAD
(
  n_cve_tipo_entidad  NUMBER(2) not null,
  c_desc_tipo_entidad VARCHAR2(100) not null
);
-- Add comments to the columns 
comment on column SUIRPLUS.SUIR_C_TIPO_ENTIDAD.n_cve_tipo_entidad
  is 'Tipo de entidad del registro';
comment on column SUIRPLUS.SUIR_C_TIPO_ENTIDAD.c_desc_tipo_entidad
  is 'Descripción del tipo de entidad del regimen subsidiado';

-- Create table
create table SUIRPLUS.SUIR_R_ASIG_CEDULA_MV
(
  no_documento   VARCHAR2(15) not null,
  tipo_documento VARCHAR2(1) not null,
  fecha_registro DATE,
  status         VARCHAR2(2) not null,
  id_error       VARCHAR2(3)
);

-- Create table
create table SUIRPLUS.SUIR_R_SOL_ACTA_NAC_MENORES_MV
(
  numero_lote      NUMBER(9) not null,
  id_registro      NUMBER(9) not null,
  acta_municipio   VARCHAR2(10),
  acta_oficialia   NUMBER,
  acta_libro       VARCHAR2(10),
  acta_folio       VARCHAR2(10),
  acta_numero      VARCHAR2(10),
  acta_anio        VARCHAR2(10),
  primer_apellido  VARCHAR2(40),
  segundo_apellido VARCHAR2(40),
  primer_nombre    VARCHAR2(50),
  segundo_nombre   VARCHAR2(40),
  fecha_nacimiento VARCHAR2(8),
  sexo             VARCHAR2(1),
  fecha_solicitud  DATE,
  nss_dependiente  NUMBER,
  b_imagen         BLOB
);

-- Create table
create table SUIRPLUS.SUIR_R_SOL_ASIG_CEDULA_MV
(
  no_documento      VARCHAR2(15) not null,
  tipo_documento    VARCHAR2(1) not null,
  fecha_registro    DATE,
  status            VARCHAR2(2) not null,
  id_error          VARCHAR2(3),
  ult_fecha_act     DATE,
  n_num_control     NUMBER(9) not null,
  n_id_registro     NUMBER(9) not null,
  ars_solicitante   NUMBER(2),
  nss_titular       NUMBER(9),
  codigo_parentesco NUMBER(2),
  id_ars            NUMBER(2),
  usuario           VARCHAR2(30),
  usuario_solicita  VARCHAR2(30)
);
-- Add comments to the table 
comment on table SUIRPLUS.SUIR_R_SOL_ASIG_CEDULA_MV
  is 'Asignacion de Cedula de JCE.';
-- Add comments to the columns 
comment on column SUIRPLUS.SUIR_R_SOL_ASIG_CEDULA_MV.no_documento
  is 'Numero de identificación (Cedula o NUI)';
comment on column SUIRPLUS.SUIR_R_SOL_ASIG_CEDULA_MV.tipo_documento
  is 'Tipo de documento (C = Cedula, N = NUI)';
comment on column SUIRPLUS.SUIR_R_SOL_ASIG_CEDULA_MV.fecha_registro
  is 'Fecha en que se inserto el registro (se con la fecha del dia por defecto)';
comment on column SUIRPLUS.SUIR_R_SOL_ASIG_CEDULA_MV.status
  is 'OK = Procesado correctamente, PE = Pendiente de ser procesado, RE = Rechazado';
comment on column SUIRPLUS.SUIR_R_SOL_ASIG_CEDULA_MV.id_error
  is 'Codigo por el cual fue rechazado el registro';
comment on column SUIRPLUS.SUIR_R_SOL_ASIG_CEDULA_MV.ult_fecha_act
  is 'Ultima fecha en que se actualizo el registro.';
comment on column SUIRPLUS.SUIR_R_SOL_ASIG_CEDULA_MV.n_num_control
  is 'Numero de lote insertado por UNIPAGO';
comment on column SUIRPLUS.SUIR_R_SOL_ASIG_CEDULA_MV.n_id_registro
  is 'Numero de registro insertado por UNIPAGO';
comment on column SUIRPLUS.SUIR_R_SOL_ASIG_CEDULA_MV.id_ars
  is 'Código de la ARS';
comment on column SUIRPLUS.SUIR_R_SOL_ASIG_CEDULA_MV.usuario
  is 'Usuario que inserta el registro en la tabla (dida, sisalril o unipago)';
comment on column SUIRPLUS.SUIR_R_SOL_ASIG_CEDULA_MV.usuario_solicita
  is 'Será el usuario de la aplicación que inserta en la tabla – viene dado por la entidad';

-- Create table
create table SUIRPLUS.SUIR_R_SOL_ASIG_NSS_MENORES_MV
(
  n_num_control      NUMBER(9) not null,
  n_id_registro      NUMBER(9) not null,
  acta_municipio     VARCHAR2(10),
  c_acta_oficialia   VARCHAR2(10),
  c_acta_libro       VARCHAR2(10),
  c_acta_folio       VARCHAR2(10),
  c_acta_acta        VARCHAR2(10),
  c_acta_anio        VARCHAR2(10),
  c_apepat           VARCHAR2(40),
  c_apemat           VARCHAR2(40),
  primer_nom         VARCHAR2(40),
  c_nombre2          VARCHAR2(40),
  c_fecha_nacimiento VARCHAR2(8),
  c_sexo             VARCHAR2(1),
  fecha_solicitud    DATE,
  codigo_pendiente   VARCHAR2(250),
  c_cve_entidad      VARCHAR2(2),
  nss_titular        NUMBER,
  c_dep_extranjero   VARCHAR2(1),
  c_id_nacionalidad  NUMBER,
  id_unipago         ROWID,
  n_tipo_documento   NUMBER(2),
  c_numero_documento VARCHAR2(50),
  n_cve_parentesco   NUMBER(2),
  b_imagen           BLOB
);

-- Create table
create table SUIRPLUS.SUIR_T_PAGO
(
  n_num_control       NUMBER(9),
  d_fecha_envio       DATE,
  c_no_referencia     VARCHAR2(16),
  c_registro_patronal VARCHAR2(9),
  c_fecha_pago        VARCHAR2(8),
  c_num_autorizacion  VARCHAR2(16),
  c_cve_medio_pago    VARCHAR2(2),
  c_total_pagado      VARCHAR2(25),
  c_status_carga      VARCHAR2(2),
  n_error_carga       NUMBER,
  n_registro_contable NUMBER(9),
  c_cve_entidad       VARCHAR2(2),
  c_cve_subproceso    VARCHAR2(2)
);
-- Add comments to the table 
comment on table SUIRPLUS.SUIR_T_PAGO
  is 'Tabla con los registros de pago de NP via UNIPAGO';
-- Add comments to the columns 
comment on column SUIRPLUS.SUIR_T_PAGO.n_num_control
  is 'Número Lote';
comment on column SUIRPLUS.SUIR_T_PAGO.d_fecha_envio
  is 'Fecha de envío del pago a TSS';
comment on column SUIRPLUS.SUIR_T_PAGO.c_no_referencia
  is 'Número de referencia TSS de la cual se aplicó el pago.';
comment on column SUIRPLUS.SUIR_T_PAGO.c_registro_patronal
  is 'ID del empleador';
comment on column SUIRPLUS.SUIR_T_PAGO.c_fecha_pago
  is 'Fecha en que se realizó en pago en la entidad bancaria';
comment on column SUIRPLUS.SUIR_T_PAGO.c_num_autorizacion
  is 'Número de autorización';
comment on column SUIRPLUS.SUIR_T_PAGO.c_cve_medio_pago
  is 'Medio por el cual se realizó el pago.';
comment on column SUIRPLUS.SUIR_T_PAGO.c_total_pagado
  is 'Monto total de la NP parago en la entidad recaudadora';
comment on column SUIRPLUS.SUIR_T_PAGO.c_status_carga
  is 'Estatus de la carga ( AC,IN,OK)';
comment on column SUIRPLUS.SUIR_T_PAGO.n_error_carga
  is 'ID del error de carga, 0 sin error, ver seg_error_t';
comment on column SUIRPLUS.SUIR_T_PAGO.n_registro_contable
  is 'Número de registro contable';
comment on column SUIRPLUS.SUIR_T_PAGO.c_cve_entidad
  is 'ID generado por cada ARS';
comment on column SUIRPLUS.SUIR_T_PAGO.c_cve_subproceso
  is 'Subproceso generado ya sea de aclaración o pago.';

-- Create table
create table SUIRPLUS.SUIR_T_PAGO_T
(
  n_num_control       NUMBER(9),
  d_fecha_envio       DATE,
  c_no_referencia     VARCHAR2(16),
  c_registro_patronal VARCHAR2(9),
  c_fecha_pago        VARCHAR2(8),
  c_num_autorizacion  VARCHAR2(16),
  c_cve_medio_pago    VARCHAR2(2),
  c_total_pagado      VARCHAR2(25),
  c_status_carga      VARCHAR2(2),
  n_error_carga       NUMBER,
  n_registro_contable NUMBER(9),
  c_cve_entidad       VARCHAR2(2),
  c_cve_subproceso    VARCHAR2(2)
)
tablespace SYSTEM
  pctfree 10
  pctused 40
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
-- Add comments to the table 
comment on table SUIRPLUS.SUIR_T_PAGO_T
  is 'Tabla con los registros de pago de NP via UNIPAGO';
-- Add comments to the columns 
comment on column SUIRPLUS.SUIR_T_PAGO_T.n_num_control
  is 'Número Lote';
comment on column SUIRPLUS.SUIR_T_PAGO_T.d_fecha_envio
  is 'Fecha de envío del pago a TSS';
comment on column SUIRPLUS.SUIR_T_PAGO_T.c_no_referencia
  is 'Número de referencia TSS de la cual se aplicó el pago.';
comment on column SUIRPLUS.SUIR_T_PAGO_T.c_registro_patronal
  is 'ID del empleador';
comment on column SUIRPLUS.SUIR_T_PAGO_T.c_fecha_pago
  is 'Fecha en que se realizó en pago en la entidad bancaria';
comment on column SUIRPLUS.SUIR_T_PAGO_T.c_num_autorizacion
  is 'Número de autorización';
comment on column SUIRPLUS.SUIR_T_PAGO_T.c_cve_medio_pago
  is 'Medio por el cual se realizó el pago.';
comment on column SUIRPLUS.SUIR_T_PAGO_T.c_total_pagado
  is 'Monto total de la NP parago en la entidad recaudadora';
comment on column SUIRPLUS.SUIR_T_PAGO_T.c_status_carga
  is 'Estatus de la carga ( AC,IN,OK)';
comment on column SUIRPLUS.SUIR_T_PAGO_T.n_error_carga
  is 'ID del error de carga, 0 sin error, ver seg_error_t';
comment on column SUIRPLUS.SUIR_T_PAGO_T.n_registro_contable
  is 'Número de registro contable';
comment on column SUIRPLUS.SUIR_T_PAGO_T.c_cve_entidad
  is 'ID generado por cada ARS';
comment on column SUIRPLUS.SUIR_T_PAGO_T.c_cve_subproceso
  is 'Subproceso generado ya sea de aclaración o pago.';

-- Create table
create table SUIRPLUS.TAB_ACTIVIDADES_ECONOMICAS
(
  tae_cod_actividad NUMBER(8),
  tae_nom_actividad VARCHAR2(200)
);
-- Add comments to the columns 
comment on column SUIRPLUS.TAB_ACTIVIDADES_ECONOMICAS.tae_cod_actividad
  is 'código de la actividad económica';
comment on column SUIRPLUS.TAB_ACTIVIDADES_ECONOMICAS.tae_nom_actividad
  is 'nombre de la actividad economica';

-- Create table
create table SUIRPLUS.TAB_UNIDADES
(
  tab_cod_unidad NUMBER(4),
  tab_nom_unidad VARCHAR2(40),
  tab_tip_unidad NUMBER(1)
);
-- Add comments to the columns 
comment on column SUIRPLUS.TAB_UNIDADES.tab_cod_unidad
  is 'código de la unidad de la administración local';
comment on column SUIRPLUS.TAB_UNIDADES.tab_nom_unidad
  is 'código de la unidad de la administración local';
comment on column SUIRPLUS.TAB_UNIDADES.tab_tip_unidad
  is 'Tipo de la unidad de la administración local';

-- Create table
create table SUIRPLUS.TSS_CATALOGO_EI_MV
(
  cve_estancia         NUMBER(4) not null,
  descripcion_estancia VARCHAR2(250) not null,
  estatus              VARCHAR2(2)
);
-- Add comments to the columns 
comment on column SUIRPLUS.TSS_CATALOGO_EI_MV.cve_estancia
  is 'Código de la estancia infantil';
comment on column SUIRPLUS.TSS_CATALOGO_EI_MV.descripcion_estancia
  is 'Descripción de la estancia en el catálogo';
comment on column SUIRPLUS.TSS_CATALOGO_EI_MV.estatus
  is 'AC = Activo, BA = BAJA';

-- Create table
create table SUIRPLUS.TSS_DATOS_CEDULAS_IDSS_MV
(
  c_num_cedula       VARCHAR2(11),
  n_nss              NUMBER(10),
  c_sexo             VARCHAR2(1),
  d_fecha_nacimiento DATE,
  afp                VARCHAR2(250)
);
-- Add comments to the columns 
comment on column SUIRPLUS.TSS_DATOS_CEDULAS_IDSS_MV.c_num_cedula
  is 'Número de cédula';
comment on column SUIRPLUS.TSS_DATOS_CEDULAS_IDSS_MV.n_nss
  is 'Número de seguridad social del individuo, ver SUIRPLUS.SRE_CIUDADANOS_T';
comment on column SUIRPLUS.TSS_DATOS_CEDULAS_IDSS_MV.c_sexo
  is 'Sexo del ciudadano, M=Masculino, F=Femenino';
comment on column SUIRPLUS.TSS_DATOS_CEDULAS_IDSS_MV.d_fecha_nacimiento
  is 'Fecha de nacimiento del ciudadano';
comment on column SUIRPLUS.TSS_DATOS_CEDULAS_IDSS_MV.afp
  is 'AFP a la que pertenece el individuo';

-- Create table
create table SUIRPLUS.TSS_DEPENDIENTES_OK_PE_MV
(
  ars              NUMBER,
  nss_titular      NUMBER,
  nss_dependiente  NUMBER,
  status           VARCHAR2(2),
  cve_parentesco   NUMBER,
  c_discapacitado  VARCHAR2(1),
  c_dependiente    VARCHAR2(1),
  tipo_afiliacion  CHAR(2),
  fecha_afiliacion DATE
);

-- Create table
create table SUIRPLUS.TSS_DEPENDIENTE_CONYUGE_RE_MV
(
  c_num_cedula_dep VARCHAR2(11),
  c_num_cedula_tit VARCHAR2(11)
);
-- Add comments to the columns 
comment on column SUIRPLUS.TSS_DEPENDIENTE_CONYUGE_RE_MV.c_num_cedula_dep
  is 'Número de cédula del dependiente';
comment on column SUIRPLUS.TSS_DEPENDIENTE_CONYUGE_RE_MV.c_num_cedula_tit
  is 'Número de cédula del titular';

-- Create table
create table SUIRPLUS.TSS_DISPERSION_AEISS_MV
(
  secuencia                    NUMBER,
  cve_administradora_ei        NUMBER,
  cve_estancia                 NUMBER,
  periodo                      NUMBER,
  nss_titular                  NUMBER,
  nss_dependiente              NUMBER,
  fecha_generacion_consolidado DATE,
  monto_dispersar              NUMBER,
  nss_reporta_pago             NUMBER,
  c_no_referencia              VARCHAR2(255),
  cve_clasificacion_pago       NUMBER
);

-- Create table
create table SUIRPLUS.TSS_FACTURABLES_SENASA
(
  n_tipo_entidad    NUMBER,
  n_entidad         INTEGER,
  nss_titular       NUMBER,
  nss_dependiente   NUMBER,
  parentesco        NUMBER,
  tipo_afiliado     VARCHAR2(1),
  periodo_factura   VARCHAR2(6),
  n_tipo_facturable NUMBER
);

-- Create table
create table SUIRPLUS.TSS_SENASA_DEPENDIENTES
(
  n_nss_dep          VARCHAR2(9),
  n_nss_tit          VARCHAR2(9),
  cedula_dependiente VARCHAR2(11),
  c_acta_municipio   VARCHAR2(10),
  c_acta_oficialia   VARCHAR2(10),
  c_acta_libro       VARCHAR2(10),
  c_acta_folio       VARCHAR2(10),
  c_acta_acta        VARCHAR2(10),
  c_acta_anio        VARCHAR2(10),
  cedula_titular     VARCHAR2(11),
  c_apepat           VARCHAR2(40),
  c_apemat           VARCHAR2(40),
  c_nombre1          VARCHAR2(40),
  c_nombre2          VARCHAR2(40),
  c_region           VARCHAR2(2),
  c_provincia        VARCHAR2(3),
  c_municipio        VARCHAR2(4),
  n_cve_parentesco   NUMBER(2),
  c_desc_parentesco  VARCHAR2(100)
);
-- Add comments to the columns 
comment on column SUIRPLUS.TSS_SENASA_DEPENDIENTES.n_nss_dep
  is 'Número de seguridad social del dependiente, ver SUIRPLUS.SRE_CIUDADANOS_T';
comment on column SUIRPLUS.TSS_SENASA_DEPENDIENTES.n_nss_tit
  is 'Número de seguridad social del titular, ver SUIRPLUS.SRE_CIUDADANOS_T';
comment on column SUIRPLUS.TSS_SENASA_DEPENDIENTES.cedula_dependiente
  is 'Número de documento del dependiente';
comment on column SUIRPLUS.TSS_SENASA_DEPENDIENTES.c_acta_municipio
  is 'Codigo de municipio del acta de nacimiento';
comment on column SUIRPLUS.TSS_SENASA_DEPENDIENTES.c_acta_oficialia
  is 'Codigo de oficialia del acta de nacimiento';
comment on column SUIRPLUS.TSS_SENASA_DEPENDIENTES.c_acta_libro
  is 'Número de libro del acta de nacimiento';
comment on column SUIRPLUS.TSS_SENASA_DEPENDIENTES.c_acta_folio
  is 'Número de folio del acta de nacimiento';
comment on column SUIRPLUS.TSS_SENASA_DEPENDIENTES.c_acta_acta
  is 'Numero del acta de nacimiento';
comment on column SUIRPLUS.TSS_SENASA_DEPENDIENTES.c_acta_anio
  is 'Año del acta de nacimiento';
comment on column SUIRPLUS.TSS_SENASA_DEPENDIENTES.cedula_titular
  is 'Número de documento del titular';
comment on column SUIRPLUS.TSS_SENASA_DEPENDIENTES.c_apepat
  is 'Apellido paterno';
comment on column SUIRPLUS.TSS_SENASA_DEPENDIENTES.c_apemat
  is 'Apellido materno';
comment on column SUIRPLUS.TSS_SENASA_DEPENDIENTES.c_nombre1
  is 'Primer nombre del ciudadano';
comment on column SUIRPLUS.TSS_SENASA_DEPENDIENTES.c_nombre2
  is 'Segundo nombre del ciudadano';
comment on column SUIRPLUS.TSS_SENASA_DEPENDIENTES.c_region
  is 'Código de la región';
comment on column SUIRPLUS.TSS_SENASA_DEPENDIENTES.c_provincia
  is 'Código de la provincia';
comment on column SUIRPLUS.TSS_SENASA_DEPENDIENTES.c_municipio
  is 'Codigo del municipio';
comment on column SUIRPLUS.TSS_SENASA_DEPENDIENTES.n_cve_parentesco
  is 'Codigo de parentesco';
comment on column SUIRPLUS.TSS_SENASA_DEPENDIENTES.c_desc_parentesco
  is 'Descripción del parentesco';

-- Create table
create table SUIRPLUS.TSS_SENASA_DEPENDIENTES_MV
(
  n_nss_dep          VARCHAR2(9),
  n_nss_tit          VARCHAR2(9),
  cedula_dependiente VARCHAR2(11),
  c_acta_municipio   VARCHAR2(10),
  c_acta_oficialia   VARCHAR2(10),
  c_acta_libro       VARCHAR2(10),
  c_acta_folio       VARCHAR2(10),
  c_acta_acta        VARCHAR2(10),
  c_acta_anio        VARCHAR2(10),
  cedula_titular     VARCHAR2(11),
  c_apepat           VARCHAR2(40),
  c_apemat           VARCHAR2(40),
  c_nombre1          VARCHAR2(40),
  c_nombre2          VARCHAR2(40),
  c_region           VARCHAR2(2),
  c_provincia        VARCHAR2(3),
  c_municipio        VARCHAR2(4),
  n_cve_parentesco   NUMBER(2),
  c_desc_parentesco  VARCHAR2(100)
);
-- Add comments to the columns 
comment on column SUIRPLUS.TSS_SENASA_DEPENDIENTES_MV.n_nss_dep
  is 'Número de seguridad social del dependiente, ver SUIRPLUS.SRE_CIUDADANOS_T';
comment on column SUIRPLUS.TSS_SENASA_DEPENDIENTES_MV.n_nss_tit
  is 'Número de seguridad social del titular, ver SUIRPLUS.SRE_CIUDADANOS_T';
comment on column SUIRPLUS.TSS_SENASA_DEPENDIENTES_MV.cedula_dependiente
  is 'Número de documento del dependiente';
comment on column SUIRPLUS.TSS_SENASA_DEPENDIENTES_MV.c_acta_municipio
  is 'Codigo de municipio del acta de nacimiento';
comment on column SUIRPLUS.TSS_SENASA_DEPENDIENTES_MV.c_acta_oficialia
  is 'Codigo de oficialia del acta de nacimiento';
comment on column SUIRPLUS.TSS_SENASA_DEPENDIENTES_MV.c_acta_libro
  is 'Número de libro del acta de nacimiento';
comment on column SUIRPLUS.TSS_SENASA_DEPENDIENTES_MV.c_acta_folio
  is 'Número de folio del acta de nacimiento';
comment on column SUIRPLUS.TSS_SENASA_DEPENDIENTES_MV.c_acta_acta
  is 'Numero del acta de nacimiento';
comment on column SUIRPLUS.TSS_SENASA_DEPENDIENTES_MV.c_acta_anio
  is 'Año del acta de nacimiento';
comment on column SUIRPLUS.TSS_SENASA_DEPENDIENTES_MV.cedula_titular
  is 'Número de documento del titular';
comment on column SUIRPLUS.TSS_SENASA_DEPENDIENTES_MV.c_apepat
  is 'Apellido paterno';
comment on column SUIRPLUS.TSS_SENASA_DEPENDIENTES_MV.c_apemat
  is 'Apellido materno';
comment on column SUIRPLUS.TSS_SENASA_DEPENDIENTES_MV.c_nombre1
  is 'Primer nombre del ciudadano';
comment on column SUIRPLUS.TSS_SENASA_DEPENDIENTES_MV.c_nombre2
  is 'Segundo nombre del ciudadano';
comment on column SUIRPLUS.TSS_SENASA_DEPENDIENTES_MV.c_region
  is 'Código de la región';
comment on column SUIRPLUS.TSS_SENASA_DEPENDIENTES_MV.c_provincia
  is 'Código de la provincia';
comment on column SUIRPLUS.TSS_SENASA_DEPENDIENTES_MV.c_municipio
  is 'Codigo del municipio';
comment on column SUIRPLUS.TSS_SENASA_DEPENDIENTES_MV.n_cve_parentesco
  is 'Codigo de parentesco';
comment on column SUIRPLUS.TSS_SENASA_DEPENDIENTES_MV.c_desc_parentesco
  is 'Descripción del parentesco';

-- Create table
create table SUIRPLUS.TSS_SENASA_TITULARES
(
  n_nss            VARCHAR2(255),
  c_num_cedula     VARCHAR2(255),
  c_apepat         VARCHAR2(255),
  c_apemat         VARCHAR2(255),
  c_primer_nombre  VARCHAR2(255),
  c_segundo_nombre VARCHAR2(255),
  c_region         VARCHAR2(255),
  c_provincia      VARCHAR2(255),
  c_municipio      VARCHAR2(255)
)
tablespace SYSTEM
  pctfree 10
  pctused 40
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
-- Add comments to the columns 
comment on column SUIRPLUS.TSS_SENASA_TITULARES.n_nss
  is 'Número de seguridad social del individuo, ver SUIRPLUS.SRE_CIUDADANOS_T';
comment on column SUIRPLUS.TSS_SENASA_TITULARES.c_num_cedula
  is 'Número de cédula';
comment on column SUIRPLUS.TSS_SENASA_TITULARES.c_apepat
  is 'Apellido paterno';
comment on column SUIRPLUS.TSS_SENASA_TITULARES.c_apemat
  is 'Apellido materno';
comment on column SUIRPLUS.TSS_SENASA_TITULARES.c_primer_nombre
  is 'Primer nombre del ciudadano';
comment on column SUIRPLUS.TSS_SENASA_TITULARES.c_segundo_nombre
  is 'Segundo nombre del ciudadano';
comment on column SUIRPLUS.TSS_SENASA_TITULARES.c_region
  is 'Código de la región';
comment on column SUIRPLUS.TSS_SENASA_TITULARES.c_provincia
  is 'Código de la provincia';
comment on column SUIRPLUS.TSS_SENASA_TITULARES.c_municipio
  is 'Codigo del municipio';

-- Create table
create table SUIRPLUS.TSS_SENASA_TITULARES_MV
(
  n_nss            VARCHAR2(255),
  c_num_cedula     VARCHAR2(255),
  c_apepat         VARCHAR2(255),
  c_apemat         VARCHAR2(255),
  c_primer_nombre  VARCHAR2(255),
  c_segundo_nombre VARCHAR2(255),
  c_region         VARCHAR2(255),
  c_provincia      VARCHAR2(255),
  c_municipio      VARCHAR2(255)
);
-- Add comments to the columns 
comment on column SUIRPLUS.TSS_SENASA_TITULARES_MV.n_nss
  is 'Número de seguridad social del individuo, ver SUIRPLUS.SRE_CIUDADANOS_T';
comment on column SUIRPLUS.TSS_SENASA_TITULARES_MV.c_num_cedula
  is 'Número de cédula';
comment on column SUIRPLUS.TSS_SENASA_TITULARES_MV.c_apepat
  is 'Apellido paterno';
comment on column SUIRPLUS.TSS_SENASA_TITULARES_MV.c_apemat
  is 'Apellido materno';
comment on column SUIRPLUS.TSS_SENASA_TITULARES_MV.c_primer_nombre
  is 'Primer nombre del ciudadano';
comment on column SUIRPLUS.TSS_SENASA_TITULARES_MV.c_segundo_nombre
  is 'Segundo nombre del ciudadano';
comment on column SUIRPLUS.TSS_SENASA_TITULARES_MV.c_region
  is 'Código de la región';
comment on column SUIRPLUS.TSS_SENASA_TITULARES_MV.c_provincia
  is 'Código de la provincia';
comment on column SUIRPLUS.TSS_SENASA_TITULARES_MV.c_municipio
  is 'Codigo del municipio';

-- Create table
create table SUIRPLUS.TSS_SUIR_C_TIPO_AFILIACION_MV
(
  c_tipo_afiliacion VARCHAR2(2) not null,
  c_descripcion     VARCHAR2(100)
);
-- Add comments to the columns 
comment on column SUIRPLUS.TSS_SUIR_C_TIPO_AFILIACION_MV.c_tipo_afiliacion
  is 'Tipo afiliacion (Dato informativo proveniente de Unipago)';
comment on column SUIRPLUS.TSS_SUIR_C_TIPO_AFILIACION_MV.c_descripcion
  is 'Descripción del tipo de afiliación';

-- Create table
create table SUIRPLUS.TSS_TITULARES_ARS_OK_PE_MV
(
  ars              NUMBER,
  nss              NUMBER(10),
  c_status         VARCHAR2(2),
  tipo_afiliacion  VARCHAR2(2),
  fecha_afiliacion DATE
);

-- Create table
create table SUIRPLUS.TSS_TRASPASO_SEHA_CCI_MV
(
  n_nss             NUMBER(9) not null,
  d_fecha_proceso   DATE not null,
  c_tipo_proceso    VARCHAR2(2),
  n_cve_afp         NUMBER(2) not null,
  c_razonsocial_afp VARCHAR2(250) not null
);
-- Add comments to the columns 
comment on column SUIRPLUS.TSS_TRASPASO_SEHA_CCI_MV.n_nss
  is 'Número de seguridad social del individuo, ver SUIRPLUS.SRE_CIUDADANOS_T';
comment on column SUIRPLUS.TSS_TRASPASO_SEHA_CCI_MV.d_fecha_proceso
  is 'Fecha del proceso ';
comment on column SUIRPLUS.TSS_TRASPASO_SEHA_CCI_MV.c_tipo_proceso
  is 'Tipo de proceso';
comment on column SUIRPLUS.TSS_TRASPASO_SEHA_CCI_MV.n_cve_afp
  is 'Número AFP';
comment on column SUIRPLUS.TSS_TRASPASO_SEHA_CCI_MV.c_razonsocial_afp
  is 'Nombre de la  AFP';

-- Create table
create table TSS.ARS_NUEVOS_OK_PERIODO_TMP
(
  codigo_ars        NUMBER(2),
  periodo_factura   VARCHAR2(6),
  tipo_afiliado     VARCHAR2(1),
  nss_titular       VARCHAR2(9),
  nss_dependiente   VARCHAR2(9),
  codigo_parentesco VARCHAR2(2),
  discapacitado     VARCHAR2(1),
  estudiante        VARCHAR2(1)
);
-- Add comments to the columns 
comment on column TSS.ARS_NUEVOS_OK_PERIODO_TMP.codigo_ars
  is 'ID del ARS, ver SUIRPLUS.ARS_CATALOGO_T';
comment on column TSS.ARS_NUEVOS_OK_PERIODO_TMP.periodo_factura
  is 'Período de la factura';
comment on column TSS.ARS_NUEVOS_OK_PERIODO_TMP.tipo_afiliado
  is 'T = Titular, D = Dependiente, A = Dependiente Adicional';
comment on column TSS.ARS_NUEVOS_OK_PERIODO_TMP.nss_titular
  is 'Número de seguridad social del titular, ver SUIRPLUS.SRE_CIUDADANOS_T';
comment on column TSS.ARS_NUEVOS_OK_PERIODO_TMP.nss_dependiente
  is 'Número de seguridad social del dependiente, ver SUIRPLUS.SRE_CIUDADANOS_T';
comment on column TSS.ARS_NUEVOS_OK_PERIODO_TMP.codigo_parentesco
  is 'Código del parentesco, ver suirplus.ars_parentescos_t';
comment on column TSS.ARS_NUEVOS_OK_PERIODO_TMP.discapacitado
  is 'Si el ciudadano es discapacitado o no, S/N';
comment on column TSS.ARS_NUEVOS_OK_PERIODO_TMP.estudiante
  is 'Si el ciudadano es estudiante o no, S/N';

-- Create table
CREATE TABLE SUIRPLUS.TSS_CARTERA_PENSIONADOS_MV
  (
    ars               NUMBER (4) NOT NULL ,
    nss_titular       NUMBER (9) NOT NULL ,
    nss_dependiente   NUMBER (9) NOT NULL ,
    parentesco        VARCHAR2 (2) ,
    tipo_afiliado     VARCHAR2 (1) NOT NULL ,
    periodo_factura   VARCHAR2 (6) NOT NULL ,
    n_tipo_facturable NUMBER (1) NOT NULL ,
    estudiante        VARCHAR2 (1) NOT NULL ,
    discapacitado     VARCHAR2 (1) NOT NULL ,
    n_cve_institucion NUMBER (3) NOT NULL
  );

COMMENT ON COLUMN SUIRPLUS.TSS_CARTERA_PENSIONADOS_MV.ARS
IS 'Código de la ARS correspondiente al Plan Especial de Salud Pensionados.';

COMMENT ON COLUMN SUIRPLUS.TSS_CARTERA_PENSIONADOS_MV.NSS_TITULAR
IS 'Número de Seguridad Social del titular.' ;

COMMENT ON COLUMN SUIRPLUS.TSS_CARTERA_PENSIONADOS_MV.NSS_DEPENDIENTE
IS 'Número de Seguridad Social del dependiente.' ;

COMMENT ON COLUMN SUIRPLUS.TSS_CARTERA_PENSIONADOS_MV.PARENTESCO
IS 'Código del parentesco asociado al afiliado. Solo aplica para dependientes.' ;

COMMENT ON COLUMN SUIRPLUS.TSS_CARTERA_PENSIONADOS_MV.TIPO_AFILIADO
IS 'Código del tipo de afiliado. Posibles valores (T=Titular, D=Directo, A=Adicional).' ;

COMMENT ON COLUMN SUIRPLUS.TSS_CARTERA_PENSIONADOS_MV.PERIODO_FACTURA
IS 'Periodo de facturación en formato AAAAMM.' ;

COMMENT ON COLUMN SUIRPLUS.TSS_CARTERA_PENSIONADOS_MV.N_TIPO_FACTURABLE
IS 'Indica el tipo de facturable. Posibles valores 1=FACTURABLE.' ;

COMMENT ON COLUMN SUIRPLUS.TSS_CARTERA_PENSIONADOS_MV.ESTUDIANTE
IS 'Indica si el dependiente está marcado como Estudiante. Posibles Valores (S=Si es estudiante, N=No es estudiante).' ;

COMMENT ON COLUMN SUIRPLUS.TSS_CARTERA_PENSIONADOS_MV.DISCAPACITADO
IS 'Indica si el dependiente está marcado como Discapacitado. Posibles Valores (S=Es Discapacitado N=No es Discapacitado).' ;

COMMENT ON COLUMN SUIRPLUS.TSS_CARTERA_PENSIONADOS_MV.N_CVE_INSTITUCION
IS 'Clave de la institución a la que corresponde el Pensionado. Posibles Valores (1=Pensionados de la Policía Nacional, 2=Pensionados del Sector Salud, 3=Pensionados de las Fuerzas Armadas).';

-- Create table
CREATE TABLE SUIRPLUS.TSS_DEPENDIENTES_ADIC_MV
  (
    nss_titular                 NUMBER (9) NOT NULL ,
    nss_dependiente_adicional   NUMBER (9) NOT NULL ,
    nss_conyuge                 NUMBER (9)          ,
    codigo_parentesco           NUMBER (2) NOT NULL 
  );

COMMENT ON COLUMN SUIRPLUS.TSS_DEPENDIENTES_ADIC_MV.NSS_TITULAR
IS 'Número de Seguridad Social del titular del nucleo.' ;

COMMENT ON COLUMN SUIRPLUS.TSS_DEPENDIENTES_ADIC_MV.NSS_DEPENDIENTE_ADICIONAL
IS 'Número de Seguridad Social del dependiente adicional.' ;

COMMENT ON COLUMN SUIRPLUS.TSS_DEPENDIENTES_ADIC_MV.NSS_CONYUGE
IS 'Número de Seguridad Social del conyuge del nucleo.' ;

COMMENT ON COLUMN SUIRPLUS.TSS_DEPENDIENTES_ADIC_MV.CODIGO_PARENTESCO
IS 'Código del parentesco asociado al afiliado. Solo aplica para dependientes.' ;

exit;