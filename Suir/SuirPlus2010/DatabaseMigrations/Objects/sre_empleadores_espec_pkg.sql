create or replace package suirplus.sre_empleadores_pkg as
  -- *****************************************************************************************************
  -- program:   sre_empleadores_pkg
  -- descripcion: Crea y Edita los Empleadores.
  --
  -- modification history
  -- -----------------------------------------------------------------------------------------------------
  -- date     by          remark
  -- -----------------------------------------------------------------------------------------------------
  -- 11/11/2004 Elinor Rodriguez  creation
  -- *****************************************************************************************************

  type t_cursor is ref cursor;

  e_invalidregistropatronal exception;
  e_invalidmotivoimpresion exception;
  e_invalidsectoreconomico exception;
  e_invalidsectoreconomicodes exception;
  e_invalidprovincias exception;
  e_invalidoficios exception;
  e_invalidactividadeconomica exception;
  e_invalidriesgo exception;
  e_invalidmunicipio exception;
  e_invaliduser exception;
  e_excedelogintud exception;
  e_invalidrncocedula exception;

  v_bderror               varchar(32000);
  v_fetchvalue            varchar(1000);
  v_newidregistropatronal varchar(20);

  -- PROCEDIMIENTO:  empleadores_editar
  -- DESCRIPCION:    Procedimiento mediante el cual se modifica un registro en la tabla de sre_empleadores_t.
  -- **************************************************************************************************
  /*   PARAMETROS
         **********************************************************************************************************************************
         *  NOMBRE                 ** TIPO_DATO      **   TIPO_PARAMETRO    **  DESCRIPCION                         **    VALIDACION
         **********************************************************************************************************************************
         * id_registro_patronal    ** number(9)          **  IN               ** ID generado por cada empleador definido en la tabla SRE_EMPLEADORES_T
         * id_motivo_no_impresion    ** varchar2(2)        **  IN               ** ID de los motivos definidos para no imprimir una factura
         * id_sector_economico     ** number(2)          **  IN               ** ID del sector economico al que pertencen las empresas
         * id_oficio                 ** number             **  IN               ** Codigo secuencial de oficio.
         * id_actividad_eco        ** varchar2(6)        **  IN               ** ID de la actividad economica
         * id_riesgo                 ** varchar2(3)        **  IN               ** ID de la categoria de riesgo
         * id_municipio            ** varchar2(6)        **  IN               ** ID de los municipios creados en la tabla SRE_MUNICIPIO_T
         * rnc_o_cedula            ** varchar2(11)       **  IN               ** RNC o Cedula del empleador
         * razon_social            ** varchar2(150)      **  IN               ** Nombre de la empresa
         * nombre_comercial        ** varchar2(150)      **  IN               ** Nombe del comercio definido por cada empleador,en la DGI ( Direccion General de Impuestos internos)
         * status                    ** varchar2(1)        **  IN               ** A=Activo, B=Baja
         * calle                     ** varchar2(150)      **  IN               ** Calle de la direccion
         * numero                    ** varchar2(12)       **  IN               ** Numero de la casa o local de la direccion
         * edificio                ** varchar2(25)       **  IN               ** Edificio de la direccion
         * piso                    ** varchar2(2)        **  IN               ** Numero del piso donde vive el  empleador
         * apartamento             ** varchar2(10)       **  IN               ** Apartamento de la direccion
         * sector                    ** varchar2(150)      **  IN               ** Nombre del sector de la direccion
         * telefono_1                ** varchar2(10)       **  IN               ** Telefono primario o principal
         * ext_1                     ** varchar2(4)        **  IN               ** Extension telefonica primaria
         * telefono_2                ** varchar2(10)       **  IN               ** Telefono secundario
         * ext_2                     ** varchar2(4)        **  IN               ** Extension telefonica secundaria
         * fax                     ** varchar2(10)       **  IN               ** Numero de Fax
         * email                     ** varchar2(50)       **  IN               ** Email
         * tipo_empresa            ** varchar2(2)        **  IN               ** PR=Privada, PU=Publica no centralizada, PC=Publica centralizada
         * descuento_penalidad     ** number(3,2)        **  IN               ** Descuento o penalidad por accidentes laborales.
         * ruta_distribucion         ** number(3)          **  IN               ** Indica  la ruta de distribucion que tiene con Caribe Express para las facturas
         * no_paga_idss            ** varchar2(1)        **  IN               ** S=Si, N=No
         * completo_encuesta         ** varchar2(1)        **  IN               ** Indica si el empleador a completado la encuesta
         * ult_usuario_act         ** varchar2(35)       **  IN               ** Usuario que actualizo por ultima vez el registro
         * p_resultnumber            ** VARCHAR2           **  IN/OUT           ** Variable resultado (Si todo sale bien envia 0)
         **********************************************************************************************************************************
         **********************************************************************************************************************************
  */
  procedure empleadores_editar(p_id_registro_patronal   sre_empleadores_t.id_registro_patronal%type,
                               p_id_motivo_no_impresion sre_empleadores_t.id_motivo_no_impresion%type,
                               p_id_sector_economico    sre_empleadores_t.id_sector_economico%type,
                               p_id_oficio              sre_empleadores_t.id_oficio%type,
                               p_id_actividad_eco       sre_empleadores_t.id_actividad_eco%type,
                               p_id_riesgo              sre_empleadores_t.id_riesgo%type,
                               p_id_municipio           sre_empleadores_t.id_municipio%type,
                               p_rnc_o_cedula           sre_empleadores_t.rnc_o_cedula%type,
                               p_razon_social           sre_empleadores_t.razon_social%type,
                               p_nombre_comercial       sre_empleadores_t.nombre_comercial%type,
                               p_status                 sre_empleadores_t.status%type,
                               p_calle                  sre_empleadores_t.calle%type,
                               p_numero                 sre_empleadores_t.numero%type,
                               p_edificio               sre_empleadores_t.edificio%type,
                               p_piso                   sre_empleadores_t.piso%type,
                               p_apartamento            sre_empleadores_t.apartamento%type,
                               p_sector                 sre_empleadores_t.sector%type,
                               p_telefono_1             sre_empleadores_t.telefono_1%type,
                               p_ext_1                  sre_empleadores_t.ext_1%type,
                               p_telefono_2             sre_empleadores_t.telefono_2%type,
                               p_ext_2                  sre_empleadores_t.ext_2%type,
                               p_fax                    sre_empleadores_t.fax%type,
                               p_email                  sre_empleadores_t.email%type,
                               p_tipo_empresa           sre_empleadores_t.tipo_empresa%type,
                               p_descuento_penalidad    sre_empleadores_t.descuento_penalidad%type,
                               p_ruta_distribucion      sre_empleadores_t.ruta_distribucion%type,
                               p_no_paga_idss           sre_empleadores_t.no_paga_idss%type,
                               p_completo_encuesta      sre_empleadores_t.completo_encuesta%type,
                               p_ult_usuario_act        sre_empleadores_t.ult_usuario_act%type,
                               p_resultnumber           in out varchar2);

  -- PROCEDIMIENTO:  empleadores_crear
  -- DESCRIPCION:    Procedimiento mediante el cual se inserta un registro en la tabla de sre_empleadores_t.
  -- **************************************************************************************************
  /*   PARAMETROS
         **********************************************************************************************************************************
         *  NOMBRE                 ** TIPO_DATO      **   TIPO_PARAMETRO    **  DESCRIPCION                         **    VALIDACION
         **********************************************************************************************************************************
         * id_sector_economico     ** number(2)          **  IN               ** ID del sector economico al que pertencen las empresas
         * id_oficio                 ** number             **  IN               ** Codigo secuencial de oficio.
         * id_actividad_eco        ** varchar2(6)        **  IN               ** ID de la actividad economica
         * id_riesgo                 ** varchar2(3)        **  IN               ** ID de la categoria de riesgo
         * id_municipio            ** varchar2(6)        **  IN               ** ID de los municipios creados en la tabla SRE_MUNICIPIO_T
         * rnc_o_cedula            ** varchar2(11)       **  IN               ** RNC o Cedula del empleador
         * razon_social            ** varchar2(150)      **  IN               ** Nombre de la empresa
         * nombre_comercial        ** varchar2(150)      **  IN               ** Nombe del comercio definido por cada empleador,en la DGI ( Direccion General de Impuestos internos)
         * status                    ** varchar2(1)        **  IN               ** A=Activo, B=Baja
         * calle                     ** varchar2(150)      **  IN               ** Calle de la direccion
         * numero                    ** varchar2(12)       **  IN               ** Numero de la casa o local de la direccion
         * edificio                ** varchar2(25)       **  IN               ** Edificio de la direccion
         * piso                    ** varchar2(2)        **  IN               ** Numero del piso donde vive el  empleador
         * apartamento             ** varchar2(10)       **  IN               ** Apartamento de la direccion
         * sector                    ** varchar2(150)      **  IN               ** Nombre del sector de la direccion
         * telefono_1                ** varchar2(10)       **  IN               ** Telefono primario o principal
         * ext_1                     ** varchar2(4)        **  IN               ** Extension telefonica primaria
         * telefono_2                ** varchar2(10)       **  IN               ** Telefono secundario
         * ext_2                     ** varchar2(4)        **  IN               ** Extension telefonica secundaria
         * fax                     ** varchar2(10)       **  IN               ** Numero de Fax
         * email                     ** varchar2(50)       **  IN               ** Email
         * tipo_empresa            ** varchar2(2)        **  IN               ** PR=Privada, PU=Publica no centralizada, PC=Publica centralizada
         * ult_usuario_act         ** varchar2(35)       **  IN               ** Usuario que actualizo por ultima vez el registro
         * p_resultnumber            ** VARCHAR2           **  IN/OUT           ** Variable resultado (Si todo sale bien envia 0)
         **********************************************************************************************************************************
         **********************************************************************************************************************************
  */
  procedure empleadores_crear(p_id_sector_economico sre_empleadores_t.id_sector_economico%type,
                              p_id_municipio        sre_empleadores_t.id_municipio%type,
                              p_rnc_o_cedula        sre_empleadores_t.rnc_o_cedula%type,
                              p_razon_social        sre_empleadores_t.razon_social%type,
                              p_nombre_comercial    sre_empleadores_t.nombre_comercial%type,
                              p_calle               sre_empleadores_t.calle%type,
                              p_numero              sre_empleadores_t.numero%type,
                              p_edificio            sre_empleadores_t.edificio%type,
                              p_piso                sre_empleadores_t.piso%type,
                              p_apartamento         sre_empleadores_t.apartamento%type,
                              p_sector              sre_empleadores_t.sector%type,
                              p_telefono_1          sre_empleadores_t.telefono_1%type,
                              p_ext_1               sre_empleadores_t.ext_1%type,
                              p_telefono_2          sre_empleadores_t.telefono_2%type,
                              p_ext_2               sre_empleadores_t.ext_2%type,
                              p_fax                 sre_empleadores_t.fax%type,
                              p_email               sre_empleadores_t.email%type,
                              p_tipo_empresa        sre_empleadores_t.tipo_empresa%type,
                              p_sector_salarial     sre_empleadores_t.cod_sector%type,
                              p_documentos_registro SRE_EMPLEADORES_T.Documentos_Registro%TYPE,
                              p_Id_Actividad        SRE_EMPLEADORES_T.Id_Actividad%TYPE,
                              p_Id_Zona_Franca      SRE_EMPLEADORES_T.Id_Zona_Franca%TYPE,
                              p_Es_Zona_Franca      SRE_EMPLEADORES_T.Es_Zona_Franca%TYPE,
                              p_tipo_zona_franca    SRE_EMPLEADORES_T.TIPO_ZONA_FRANCA%TYPE,
                              p_ult_usuario_act     sre_empleadores_t.ult_usuario_act%type,
                              p_resultnumber        in out varchar2);

  procedure empleadores_select(p_id_registro_patronal in sre_empleadores_t.id_registro_patronal%type,
                               p_rnc_o_cedula         in sre_empleadores_t.rnc_o_cedula%type,
                               io_cursor              in out t_cursor);

  -- verificar que el empleador ya existe.
  procedure empleadores_verificar_existe(

                                         p_rnc_cedula       in dgi_maestro_empleadores_t.rnc_cedula%type,
                                         p_razon_social     out dgi_maestro_empleadores_t.razon_social%type,
                                         p_nombre_comercial out dgi_maestro_empleadores_t.nombre_comercial%type,
                                         p_calle            out dgi_maestro_empleadores_t.calle%type,
                                         p_numero           out dgi_maestro_empleadores_t.numero%type,
                                         p_edificio         out dgi_maestro_empleadores_t.edificio%type,
                                         p_piso             out dgi_maestro_empleadores_t.piso%type,
                                         p_apartamento      out dgi_maestro_empleadores_t.apartamento%type,
                                         p_telefono_1       out dgi_maestro_empleadores_t.telefono_1%type,
                                         p_email            out dgi_maestro_empleadores_t.email%type,
                                         p_cod_municipio    out dgi_maestro_empleadores_t.cod_municipio%type,
                                         p_id_provincia     out sre_municipio_t.id_provincia%type,
                                         p_tipo_empresa     out sre_empleadores_t.tipo_empresa%type,
                                         p_resultnumber     out varchar2);

  procedure Consulta_Empleadores(p_id_registro_patronal in sre_empleadores_t.id_registro_patronal%type,
                                 p_rnc_o_cedula         sre_empleadores_t.rnc_o_cedula%type,
                                 p_nombre_comercial     sre_empleadores_t.nombre_comercial%type,
                                 p_razon_Social         sre_empleadores_t.razon_social%type,
                                 p_telefono             in sre_empleadores_t.telefono_1%type,
                                 io_cursor              in out t_cursor);

  PROCEDURE Get_MotivoNoImpresion(p_iocursor     IN OUT t_cursor,
                                  p_resultnumber OUT VARCHAR2);

  -- Funcion que devuelve si el rnc_o_cedula existe en la tabla SRE_EMPLEADORES_T
  FUNCTION isRncOCedulaValida(p_rnc_o_cedula sre_empleadores_t.rnc_o_cedula%type)
    RETURN BOOLEAN;

  -- Funcion que devuelve si el rnc_o_cedula está activo en la tabla SRE_EMPLEADORES_T
  PROCEDURE isRncOCedulaInactiva(p_rnc_o_cedula  SRE_EMPLEADORES_T.rnc_o_cedula%TYPE,
                                 p_result_number out varchar2);

  -- para hacer la selecciond de los empleadores.
  /*procedure get_registropatronal(
  p_rnc_o_cedula              in varchar2 ,
  p_resultnumber             in out varchar2); */

  FUNCTION get_registropatronal(p_rnc_o_cedula SRE_EMPLEADORES_T.rnc_o_cedula%TYPE)
    RETURN varchar2;

  --***********************************************************
  -- Procedure que devuelve el Registro Patronal a partir del RnC
  --**************************************************************
  --procedure getRegistroPatronal(p_rnc_o_cedula in SRE_EMPLEADORES_T.rnc_o_cedula%TYPE, OUT VARCHAR2);
  procedure getRegistroPatronal(p_rnc_o_cedula in SRE_EMPLEADORES_T.rnc_o_cedula%TYPE,
                                p_resultnumber OUT VARCHAR2);
                                
  --*****************************************************************************
  -- Procedure que devuelve el Registro Patronal a partir del RnC en estatus = A
  --*****************************************************************************
  procedure getRegistroPatronalActivo(p_rnc_o_cedula in SRE_EMPLEADORES_T.rnc_o_cedula%TYPE,
                                      p_resultnumber OUT VARCHAR2);                                

  function get_rncocedula(p_id_registro_patronal sre_empleadores_t.id_registro_patronal%type)
    return varchar2;

  FUNCTION ExisteRegistroPatronal(p_Id_Registro_Patronal VARCHAR2)
    RETURN BOOLEAN;

  -- Funcion que retorna si el empleador tiene movimientos pendientes o no.
  FUNCTION isExisteMovimiento(p_id_registro_patronal sre_representantes_t.id_registro_patronal%type)
    RETURN varchar;

  -- Procedimiento que retorna si el empleador esta en legal.
  procedure IsEmpleadorEnLegal(p_RNC          in sre_empleadores_t.rnc_o_cedula%type,
                               p_resultnumber out varchar2);

  --===================================================================================================
  -- Funcion para determinar en linea si un empleador esta en Legal .
  -- Buscando un acuerdo de pago activo o una referencia de tres o mas periodos vencidos.
  -- Creada por Gregorio U. Herrera
  -- 22/07/2014
  -- Ticket #6837
  --===================================================================================================
  Function IsEmpleadorEnLegal(p_id_registro_patronal in sre_empleadores_t.id_registro_patronal%type)
  Return Char;
  --***************************************************************************************************
  -- Funcion para determinar si un empleador tiene acuerdo de pago en status 1,2,3,4
  -- Creada por charlie pena
  -- 15/12/2014
  -- Ticket #7271
  --***************************************************************************************************
  function IsTieneAcuerdodePago(p_regPatronal in sre_empleadores_t.id_registro_patronal%type)
    return integer;

  PROCEDURE Get_Representantes(p_id_registro_patronal IN SRE_EMPLEADORES_T.id_registro_patronal%TYPE,
                               io_cursor              IN OUT t_cursor);

  PROCEDURE Empleadores_Con_AcuerdoPago(p_iocursor     IN OUT t_cursor,
                                        p_resultnumber OUT VARCHAR2);

  PROCEDURE empleadores_rnc_select(p_rnc_o_cedula IN SRE_EMPLEADORES_T.rnc_o_cedula%TYPE,
                                   p_resultnumber IN OUT VARCHAR2,
                                   io_cursor      IN OUT t_cursor);
  PROCEDURE Cambiar_Rnc(p_Rnc_viejo in sre_empleadores_t.rnc_o_cedula%type,
                        p_Rnc_Nuevo in sre_empleadores_t.rnc_o_cedula%type,
                        --  p_iocursor         IN OUT t_cursor,
                        p_resultnumber in OUT VARCHAR2);

  procedure get_Empleadores_byRazon(p_criterio  in sre_empleadores_t.razon_social%type,
                                    p_registros in number,
                                    p_iocursor  IN OUT t_cursor);

  procedure get_Empleadores_byNombre(p_criterio  in sre_empleadores_t.nombre_comercial%type,
                                     p_registros in number,
                                     p_iocursor  OUT t_cursor);

  PROCEDURE pageConsulta_Empleadores(p_id_registro_patronal IN SRE_EMPLEADORES_T.id_registro_patronal%TYPE,
                                     p_rnc_o_cedula         SRE_EMPLEADORES_T.rnc_o_cedula%TYPE,
                                     p_nombre_comercial     SRE_EMPLEADORES_T.nombre_comercial%TYPE,
                                     p_razon_Social         SRE_EMPLEADORES_T.razon_social%TYPE,
                                     p_telefono             IN SRE_EMPLEADORES_T.telefono_1%TYPE,
                                     p_pagenum              in number,
                                     p_pagesize             in number,
                                     io_cursor              IN OUT t_cursor);

  function isExisteUsuario(p_idusuario varchar2) return boolean;

  function Permitir_Pago(p_id_registro_patronal IN SRE_EMPLEADORES_T.id_registro_patronal%TYPE)
    return varchar2;

  procedure Get_Cuenta_Bancaria(p_id_registro_patronal in SRE_EMPLEADORES_T.id_registro_patronal%TYPE,
                                p_rnc                  in SRE_EMPLEADORES_T.RNC_O_CEDULA%TYPE,
                                cuentas_cursor         in out t_cursor,
                                p_result_number        in out varchar2);
  procedure Get_Historico_Cuentas(p_id_registro_patronal   in SRE_EMPLEADORES_T.id_registro_patronal%TYPE,
                                  historico_cuentas_cursor in out t_cursor,
                                  p_result_number          in out varchar2);
  procedure Actualizar_Cuenta_Bancaria(p_id_entidad_recaudadora in SRE_EMPLEADORES_T.Id_Entidad_Recaudadora%TYPE,
                                       p_rnc_o_cedula           in SRE_EMPLEADORES_T.Sfs_Rnc_o_Cedula%TYPE,
                                       p_cuenta_bancaria        in SRE_EMPLEADORES_T.Cuenta_Banco%TYPE,
                                       p_id_registro_patronal   in SRE_EMPLEADORES_T.ID_REGISTRO_PATRONAL%TYPE,
                                       p_tipo_cuenta            in Sre_Empleadores_t.Tipo_Cuenta%TYPE,
                                       p_usuario                in sfs_historico_cuentas_t.ult_usuario_act%TYPE,
                                       p_result_number          in out varchar2);
  procedure get_PSS_byNombre(p_criterio  in sfs_prestadoras_t.prestadora_nombre%type,
                             p_registros in number,
                             p_iocursor  IN OUT t_cursor);
  procedure getPagosExcesoExterno(p_Nro_Documento sre_ciudadanos_t.no_documento%type,
                                  p_IOCursor      OUT t_cursor);
 procedure getPagosExcesoRepresentante(p_id_registro_patronal SRE_EMPLEADORES_T.ID_REGISTRO_PATRONAL%TYPE,
                                       p_referencia sfs_pagos_ad_exceso_t.id_referencia%type,
                                        p_IOCursor             OUT t_cursor);

  PROCEDURE ConsEmpleadorSinSectorSalarial(p_rnc_o_cedula SRE_EMPLEADORES_T.rnc_o_cedula%TYPE,
                                           p_razon_Social SRE_EMPLEADORES_T.razon_social%TYPE,
                                           io_cursor      IN OUT t_cursor);
  -- *****************************************************************************************************
  -- program:   sre_empleadores_pkg
  -- descripcion: Edita o actualiza el sector salarial.
  --
  -- modification history
  -- -----------------------------------------------------------------------------------------------------
  -- date     by          remark
  -- -----------------------------------------------------------------------------------------------------
  -- 14/04/2010 Mayreni Vargas  creation
  -- *****************************************************************************************************
  PROCEDURE empleadores_edit_cod_salarial(p_id_registro_patronal SRE_EMPLEADORES_T.id_registro_patronal%TYPE,
                                          p_id_sector_salarial   SRE_EMPLEADORES_T.Cod_Sector%TYPE,
                                          p_ult_usuario_act      SRE_EMPLEADORES_T.ult_usuario_act%TYPE,
                                          p_resultnumber         IN OUT VARCHAR2);

  Procedure getDocumentoEmpleador(p_id_registro_patronal in sre_empleadores_t.id_registro_patronal%type,
                                  p_iocursor             out t_cursor,
                                  p_resultnumber         out Varchar2);

  Procedure setDocumentoEmpleador(p_id_registro_patronal in sre_empleadores_t.id_registro_patronal%type,
                                  p_documento            in sre_empleadores_t.documentos_registro%type,
                                  p_usuario              in sre_empleadores_t.ult_usuario_act%type,
                                  p_resultnumber         out Varchar2);

  --**************************************************************************************************
  --CMHA
  --03/05/2010
  --
  --**************************************************************************************************
  Procedure getClaseEmpresa(p_iocursor     out t_cursor,
                            p_resultnumber out Varchar2);
  --**************************************************************************************************
  --CMHA
  --03/05/2010
  --
  --**************************************************************************************************
  Procedure getDocClaseEmpresa(p_id_clase_empresa in sre_clase_empresa_t.id_clase_emp%type,
                               p_iocursor         out t_cursor,
                               p_resultnumber     out Varchar2);

  --******************************************************************************************
  --CMHA
  --03/05/2010
  --******************************************************************************************
  procedure getDgiiEmpleador(p_rnc_emp      in dgi_maestro_empleadores_t.rnc_cedula%type,
                             p_iocursor     out t_cursor,
                             p_resultnumber out Varchar2);

  --********************************************************************************************
  --CMHA
  --04/05/2010
  --Actualiza los resgistros de la Empresa
  --********************************************************************************************
  procedure ActualizaRegistroEmpresa(p_idRegPatronal       in sre_representantes_t.id_registro_patronal%type,
                                     p_razon_social        in sre_empleadores_t.razon_social%TYPE,
                                     p_nombre_comercial    in sre_empleadores_t.nombre_comercial%TYPE,
                                     p_cod_sector          in sre_empleadores_t.cod_sector%TYPE,
                                     p_id_sector_economico in sre_empleadores_t.id_sector_economico%TYPE,
                                     p_capital             in sre_empleadores_t.Capital%TYPE,
                                     p_tipo_empresa        in sre_empleadores_t.Tipo_Empresa%TYPE,
                                     p_resultnumber        out varchar2);

  --********************************************************************************************
  --CMHA
  --06/02/2012
  --Verifica si exite motivo en empresa
  --********************************************************************************************

  PROCEDURE isExisteMovimiento(p_id_registro_patronal SRE_REPRESENTANTES_T.id_registro_patronal%TYPE,
                               p_resultnumber         IN OUT VARCHAR2);

  -- **************************************************************************************************
  -- CHA  06/02/2012
  -- Program:     TieneMovimientosPendientes
  -- Description: Metodo para verificar si tiene movimeintos pendientes
  -- **************************************************************************************************
  PROCEDURE Permitir_Pago(p_id_registro_patronal IN SRE_EMPLEADORES_T.id_registro_patronal%TYPE,
                          p_resultnumber         IN OUT VARCHAR2);


--********************************************************************************************
--Eury Vallejo
--04/05/2010
--Obtiene la informacion de Pagos en exceso de forma filtrada
--********************************************************************************************

procedure FiltrarDatosPagosExceso(p_id_registro_patronal in sre_empleadores_t.id_registro_patronal%type,
                                  p_referencia_ajustes in sfc_trans_ajustes_t.id_referencia%type,
                                  p_referencia_exceso in sfs_pagos_ad_exceso_t.id_referencia%type,
                                  p_cedula_titular in sre_ciudadanos_t.no_documento%type,
                                  p_cedula_dependiente in sre_ciudadanos_t.no_documento%type,
                                  p_IOCursor             OUT t_cursor );

  --***************************************************************************************************
  --12/12/2013
  --procedure:IsSectorEconomico
  --verifica si el id de sector economico es válido contra el catálogo
  --by charlie peña
  --***************************************************************************************************
  procedure IsSectorEconomico(p_Id in sre_sector_economico_t.id_sector_economico%type,
                              p_resultnumber out varchar2);

  --***************************************************************************************************
  --12/12/2013
  --procedure: IsSectorSalarial
  --verifica si el id de sector salarial es válido contra el catálogo
  --by charlie peña
  --***************************************************************************************************
  procedure IsSectorSalarial(p_Id in sre_sectores_salariales_t.cod_sector%type,
                              p_resultnumber out varchar2);

  --***************************************************************************************************
  --12/12/2013
  --procedure: IsZonaFranca
  --verifica si el id de zona franca es válido contra el catálogo
  --by charlie peña
  --***************************************************************************************************
  procedure IsZonaFranca(p_Id in mdt_parques_zona_franca_t.id_zona_franca%type,
                              p_resultnumber out varchar2);

  --***************************************************************************************************
  --12/12/2013
  --procedure: IsMunicipio
  --verifica si el id de municipio es válido contra el catálogo
  --by charlie peña
  --***************************************************************************************************
  procedure IsMunicipio(p_Id in sre_municipio_t.id_municipio%type,
                        p_resultnumber out varchar2);
                          --**************************************************************************************************
  --evallejo
  --18/07/2014
  --
  --**************************************************************************************************
  /*Procedure getRequisitoEmpresas(p_Id_Clase_Emp in sre_clase_emp_docs_t.id_clase_emp%type,
                                  p_iocursor     out t_cursor,
                                  p_resultnumber out Varchar2);*/
                                   --**************************************************************************************************
  --evallejo
  --18/07/2014
  --
  --**************************************************************************************************
  /*Procedure getListadoTipoEmpresas(p_id_clase_empresa in sre_clase_empresa_t.id_clase_emp%type,
                                   p_pagenum      in number,
                                   p_pagesize     in number,
                                   p_iocursor         out t_cursor,
                                   p_resultnumber     out Varchar2);*/

 PROCEDURE Get_Mensajes(p_id_registro_patronal IN SRE_EMPLEADORES_T.id_registro_patronal%TYPE,
                         io_cursor              IN OUT t_cursor);



  --***************************************************************************************************
  --30/09/2014
  --procedure: GET_MENSAJES_SIN_LEER
  --Devuelve la cantidad de mensajes que tenga sin leer un empleador en especifico
  --Author: Yacell Borges
  --***************************************************************************************************


  PROCEDURE Get_Mensajes_sin_leer(p_id_registro_patronal IN SRE_EMPLEADORES_T.id_registro_patronal%TYPE,
                                  p_resultnumber         OUT number);


  --***************************************************************************************************
  --30/09/2014
  --procedure: GET_MENSAJES_EMPLEADOR
  --Obtiene todos los mensajes del empleador sin importar el status del mensaje
  --Author: Yacell Borges
  --***************************************************************************************************


  PROCEDURE GET_MENSAJES_EMPLEADOR(p_id_registro_patronal IN SRE_EMPLEADORES_T.id_registro_patronal%TYPE,
                                   io_cursor              IN OUT t_cursor);




   --***************************************************************************************************
  --21/10/2014
  --procedure: GET_MENSAJES_LEIDOS_PENDIENTES
  --Obtiene todos los mensajes del empleador sin importar el status del mensaje
  --Author: Yacell Borges
  --***************************************************************************************************
  PROCEDURE Get_Mensajes_Leidos_Pendientes(p_id_registro_patronal IN SRE_EMPLEADORES_T.id_registro_patronal%TYPE,
                                           p_pagenum      in number,
                                           p_pagesize     in number,
                                           io_cursor      IN OUT t_cursor);


 --***************************************************************************************************
  --21/10/2014
  --procedure: GET_MENSAJES_ARCHIVADOS
  --Obtiene todos los mensajes del empleador sin importar el status del mensaje
  --Author: Yacell Borges
  --***************************************************************************************************


  PROCEDURE Get_Mensajes_Archivados(p_id_registro_patronal IN SRE_EMPLEADORES_T.id_registro_patronal%TYPE,
                                    p_pagenum      in number,
                                    p_pagesize     in number,
                                    io_cursor      IN OUT t_cursor);

   --***************************************************************************************************
  --30/09/2014
  --Procedure: GET_MENSAJE_LEER
  --Obtiene un mensaje en especifico para un empleador a partir de un id y un registro patronal.
  --Author: Yacell Borges
  --***************************************************************************************************


  PROCEDURE Get_Mensaje_Leer(p_id_registro_patronal IN SRE_EMPLEADORES_T.id_registro_patronal%TYPE,
                              p_id_mensaje           in sre_mensajes_t.id_mensaje%TYPE,
                              io_cursor              IN OUT t_cursor);



 --***************************************************************************************************
  --03/10/2014
  --Procedure: Actualizar_mensaje_empleador
  --Actualiza un mensaje en especifico para un empleador a partir de un id y un registro patronal.
  --Author: Yacell Borges
  --***************************************************************************************************



 PROCEDURE Actualizar_Mensaje_Empleador(p_id_registro_patronal   IN SRE_EMPLEADORES_T.id_registro_patronal%TYPE,
                                        p_id_mensaje             in sre_mensajes_t.id_mensaje%type,
                                        p_usuario                in seg_usuario_t.id_usuario%type,
                                        p_resultnumber           out Varchar2);



 --***************************************************************************************************
  --16/10/2014
  --Procedure: Marcar_Mensaje_Archivado
  --Actualiza un mensaje en especifico para un empleador a partir de un id y un registro patronal.
  --Author: Yacell Borges
  --***************************************************************************************************



 PROCEDURE Marcar_Mensaje_Archivado(p_id_registro_patronal   IN SRE_EMPLEADORES_T.id_registro_patronal%TYPE,
                                        p_id_mensaje             in sre_mensajes_t.id_mensaje%type,
                                        p_usuario                in seg_usuario_t.id_usuario%type,
                                        p_resultnumber           out Varchar2);

 PROCEDURE Actualizar_Mensaje(p_id_registro_patronal   IN SRE_EMPLEADORES_T.id_registro_patronal%TYPE,
                               p_usuario      in seg_usuario_t.id_usuario%type,
                               p_resultnumber out Varchar2);
/*
  --***************************************************************************************************
  --28/11/2014
  --Procedure: ActualizarEmpleador
  --Actualiza el status de los nuevos empleadores registrados en TSS, actualiza el nuevo representante creado,
  -- Actualiza las nuevas nominas creadas
  --Author: Kerlin De La Cruz
  --***************************************************************************************************


 PROCEDURE ActualizarEmpleador (p_id_registro_patronal   IN SRE_EMPLEADORES_T.id_registro_patronal%TYPE,
                                p_usuario                in seg_usuario_t.id_usuario%type,
                                p_resultnumber           out Varchar2);

*/

/*------------------------------------------------------------------------------------------------------*/ 
--Nombre: Procedure que retorna el estatus del empleador como se encuentre en la table de SRE_EMPLEADOR_T
--Autor:  Eury Vallejo
/*------------------------------------------------------------------------------------------------------*/ 
function isRncOCedulaRetornarEstatus(p_rnc_o_cedula  SRE_EMPLEADORES_T.rnc_o_cedula%TYPE) return varchar2;

/*------------------------------------------------------------------------------------------------------*/ 
-- Function: isEmpleadorAlDia
-- Description : Validamos si el empleador esta al dia con respeto a las facturas 
-- By: Kerlin De La Cruz
-- Fecha : 27/07/2017
/*------------------------------------------------------------------------------------------------------*/ 

FUNCTION isEmpleadorAlDia(p_rnc_o_cedula  SRE_EMPLEADORES_T.rnc_o_cedula%TYPE) return varchar2;
end;
