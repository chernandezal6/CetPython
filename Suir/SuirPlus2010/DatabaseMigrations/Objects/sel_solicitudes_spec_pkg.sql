create or replace package SEL_SOLICITUDES_PKG is

	-- Author  : CHARLIE_PENA
	-- Created : 8/29/2006 11:13:03 AM
	-- Purpose : SOLICITUDES

	-- Public type declarations
	TYPE t_cursor IS REF CURSOR;
	v_bderror varchar2(500);

	-- **************************************************************************************************
	-- PROCEDIMIENTO:     Crear_Solicitud
	-- DESCRIPTION:       Crea nuevo registro  de Solicitud en la tabla sel_solicitudes_t y
	--                    devuelve el id_solicitud del registro insertado
	-- **************************************************************************************************
	PROCEDURE Crear_Solicitud(p_id_tipo_solicitud  in sel_solicitudes_t.id_tipo_solicitud%type,
														p_id_oficina_entrega in sel_solicitudes_t.id_oficina_entrega%type,
														p_rnc_o_cedula       in sel_solicitudes_t.rnc_o_cedula%type,
														p_representante      in sel_solicitudes_t.representante%type,
														p_operador           in sel_solicitudes_t.operador%type,
														p_comentarios        in sel_solicitudes_t.comentarios%type,
														p_resultnumber       out varchar2);

	-- **************************************************************************************************
	-- PROCEDIMIENTO:     Crear_RegistroEmp
	-- DESCRIPTION:       Crea nuevo registro  de Empresa en la tabla sel_Registro_Emp_t
	-- **************************************************************************************************
	PROCEDURE Crear_RegistroEmp(p_IdSolicitud      in sel_registro_emp_t.id_solicitud%type,
															p_rnc_o_cedula     in sel_registro_emp_t.rnc_o_cedula%type,
															p_razon_social     in sel_registro_emp_t.razon_social%type,
															p_nombre_comercial in sel_registro_emp_t.nombre_comercial%type,
															p_cedula           in sel_registro_emp_t.cedula%type,
															p_telefono1        in sel_registro_emp_t.telefono1%type,
															p_telefono2        in sel_registro_emp_t.telefono2%type,
															p_resultnumber     out varchar2);

	-- **************************************************************************************************
	-- PROCEDIMIENTO:     Crear_Cancelacion
	-- DESCRIPTION:       Crea nueva cancelacion en la tabla sel_cancelacion_t
	-- **************************************************************************************************
	PROCEDURE Crear_Cancelacion(p_IdSolicitud           in sel_cancelacion_t.id_solicitud%type,
															p_rnc_o_cedula          in sel_cancelacion_t.rnc_o_cedula%type,
															p_persona_contacto      in sel_cancelacion_t.persona_contacto%type,
															p_cargo                 in sel_cancelacion_t.cargo%type,
															p_telefono              in sel_cancelacion_t.telefono%type,
															p_tipo                  in sel_cancelacion_t.tipo%type,
															p_motivo                in sel_cancelacion_t.motivo%type,
															p_rnc_o_cedula_cancelar in sel_cancelacion_t.rnc_o_cedula_cancelar%type,
															p_fax                   in sel_cancelacion_t.fax%type,
															p_email                 in sel_cancelacion_t.email%type,
															p_resultnumber          out varchar2);

	-- **************************************************************************************************
	-- PROCEDIMIENTO:     Crear_Det_Cancelacion
	-- DESCRIPTION:       Crea nueva cancelacion en la tabla sel_det_cancelacion_t
	-- **************************************************************************************************
	PROCEDURE Crear_Det_Cancelacion(p_IdSolicitud   in sel_det_cancelacion_t.id_solicitud%type,
																	p_id_referencia in sel_det_cancelacion_t.id_referencia%type,
																	p_tipo          in sel_det_cancelacion_t.tipo%type,
																	p_resultnumber  out varchar2);

	-- **************************************************************************************************
	-- PROCEDIMIENTO:     Crear_Informacion
	-- DESCRIPTION:       Crea nuevo registro en la tabla sel_informacion_t
	--OLD
	-- **************************************************************************************************
	PROCEDURE Crear_Informacion(p_IdSolicitud   in sel_informacion_t.id_solicitud%type,
															p_nro_documento in sel_informacion_t.nro_documento%type,
															p_institucion   in sel_informacion_t.institucion%type,
															p_informacion   in sel_informacion_t.informacion%type,
															p_motivo        in sel_informacion_t.motivo%type,
															p_direccion     in sel_informacion_t.direccion%type,
															p_telefono      in sel_informacion_t.telefono%type,
															p_celular       in sel_informacion_t.celular%type,
															p_cargo         in sel_informacion_t.cargo%type,
															p_resultnumber  out varchar2);
	-- **************************************************************************************************
	-- PROCEDIMIENTO:     Crear_Informacion
	-- DESCRIPTION:       Crea nuevo registro en la tabla sel_informacion_t
	-- **************************************************************************************************
	PROCEDURE Crear_Informacion(p_idSolicitud    in sel_informacion_t.id_solicitud%type,
															p_nombreCompleto in sel_informacion_t.nombre_completo%type,
															p_nro_documento  in sel_informacion_t.nro_documento%type,
															p_direccion      in sel_informacion_t.direccion%type,
															p_telefono       in sel_informacion_t.telefono%type,
															p_celular        in sel_informacion_t.celular%type,
															p_fax            in sel_informacion_t.fax%type,
															p_email          in sel_informacion_t.email%type,
															p_institucion    in sel_informacion_t.institucion%type,
															p_cargo          in sel_informacion_t.cargo%type,
															p_informacion    in sel_informacion_t.informacion%type,
															p_motivo         in sel_informacion_t.motivo%type,
															p_autoridad      in sel_informacion_t.autoridad%type,
															p_medio          in sel_informacion_t.medio%type,
															p_lugar          in sel_informacion_t.lugar%type,
															p_resultnumber   out varchar2);

	-- **************************************************************************************************
	-- PROCEDIMIENTO:     Crear_InformacionGral
	-- DESCRIPTION:       Crea nuevo registro en la tabla sel_informacion_grl_t
	-- **************************************************************************************************
	PROCEDURE Crear_InformacionGral(p_IdSolicitud  in sel_informacion_grl_t.id_solicitud%type,
																	p_informacion  in sel_informacion_grl_t.informacion%type,
																	p_telefono1    in sel_informacion_grl_t.telefono1%type,
																	p_telefono2    in sel_informacion_grl_t.telefono2%type,
																	p_Idprovincia  in sel_informacion_grl_t.id_provincia%type,
																	p_resultnumber out varchar2);

	-- ******************************************************************************************************
	-- PROCEDIMIENTO:     CambiarStatus
	-- DESCRIPTION:       Actualiza el status de la solicitud a partir del ID de la solicitud
	--                    recibido como parametro
	-- ******************************************************************************************************
	PROCEDURE CambiarSolicitud(p_idSolicitud    in sel_solicitudes_t.id_solicitud%type,
														 p_status         in sel_solicitudes_t.status%type,
														 p_ultimo_usuario in sel_solicitudes_t.ult_usr_modifico%type,
														 p_comentarios    in sel_solicitudes_t.comentarios%type,
														 p_resultnumber   out varchar2);

	-- **************************************************************************************************
	-- PROCEDIMIENTO:     getTipoSolicitudes
	-- DESCRIPTION:       Trae todos los tipos de solicitudes existentes en la tabla sel_tipo_solicitudes_t
	-- **************************************************************************************************
	PROCEDURE getTipoSolicitudes(p_iocursor     out t_cursor,
															 p_resultnumber out varchar2);

	-- **************************************************************************************************
	-- PROCEDIMIENTO:  getTipoSolicitud
	-- DESCRIPTION:    Trae el tipo de solicitud desde la tabla sel_solicitudes_t buscando a traves del
	--                 parametro P_idSolicitud
	-- **************************************************************************************************
	PROCEDURE getTipoSolicitud(p_idSolicitud  in sel_solicitudes_t.id_solicitud%type,
														 p_resultnumber out varchar2);

	-- **************************************************************************************************
	-- PROCEDIMIENTO:     CargarDatos
	-- DESCRIPTION:       Trae el registro solicitado de la tabla sel_solicitudes_t para un id especifico
	-- **************************************************************************************************
	PROCEDURE CargarDatos(p_idSolicitud  in sel_solicitudes_t.id_solicitud%type,
												p_iocursor     out t_cursor,
												p_resultnumber out varchar2);

	-- **************************************************************************************************
	-- PROCEDIMIENTO:     getCancelacion
	-- DESCRIPTION:       Trae los registros que pertenezcan a una solicitud cancelada especifica
	-- **************************************************************************************************
	PROCEDURE getCancelacion(p_idSolicitud  in sel_solicitudes_t.id_solicitud%type,
													 p_iocursor     out t_cursor,
													 p_resultnumber out varchar2);

	-- ******************************************************************************************************
	-- PROCEDIMIENTO:     getDetCancelacion
	-- DESCRIPTION:       Trae los registros en detalles que pertenezcan a una solicitud cancelada especifica
	-- ******************************************************************************************************
	PROCEDURE getDetCancelacion(p_idSolicitud  in sel_solicitudes_t.id_solicitud%type,
															p_iocursor     out t_cursor,
															p_resultnumber out varchar2);

	-- **************************************************************************************************
	-- PROCEDIMIENTO:     getRegistroEmp
	-- DESCRIPTION:       Trae los registros que pertenezcan a una solicitud especifica
	-- **************************************************************************************************
	PROCEDURE getRegistroEmp(p_idSolicitud  in sel_solicitudes_t.id_solicitud%type,
													 p_iocursor     out t_cursor,
													 p_resultnumber out varchar2);

	-- **************************************************************************************************
	-- PROCEDIMIENTO:     getRecuperacionClave
	-- DESCRIPTION:       Trae los registros que pertenezcan a una solicitud especifica
	-- **************************************************************************************************
	PROCEDURE getRecuperacionClave(p_idSolicitud  in sel_solicitudes_t.id_solicitud%type,
																 p_iocursor     out t_cursor,
																 p_resultnumber out varchar2);

	-- **************************************************************************************************
	-- PROCEDIMIENTO:     getEstCuentaViaFax
	-- DESCRIPTION:       Trae los registros que pertenezcan a una solicitud especifica
	-- **************************************************************************************************
	PROCEDURE getEstadoCuentaViaFax(p_idSolicitud  in sel_solicitudes_t.id_solicitud%type,
																	p_iocursor     out t_cursor,
																	p_resultnumber out varchar2);

	-- **************************************************************************************************
	-- PROCEDIMIENTO:     getEstCuentaViaEmail
	-- DESCRIPTION:       Trae los registros que pertenezcan a una solicitud especifica
	-- **************************************************************************************************
	PROCEDURE getEnvioFacturasEmail(p_idSolicitud  in sel_solicitudes_t.id_solicitud%type,
																	p_iocursor     out t_cursor,
																	p_resultnumber out varchar2);

	-- ******************************************************************************************************
	-- PROCEDIMIENTO:     getSolicitud
	-- DESCRIPTION:       Trae los registros de una solicitud basada en el ID de la misma
	-- ******************************************************************************************************
	PROCEDURE getSolicitud(p_idSolicitud  in sel_solicitudes_t.id_solicitud%type,
												 p_iocursor     out t_cursor,
												 p_resultnumber out varchar2);
                         
 	-- ******************************************************************************************************
	-- PROCEDIMIENTO:     getInfoSol
	-- DESCRIPTION:       Trae los registros de una solicitid basada en el no de la misma
  -- FECHA : 21/05/2015
  -- BY : KERLIN DE LA CRUZ
	-- ******************************************************************************************************
                       

	PROCEDURE getNovedades(p_idSolicitud  in sel_solicitudes_t.id_solicitud%type,
												 p_iocursor     out t_cursor,
												 p_resultnumber out varchar2);

	-- ******************************************************************************************************
	-- PROCEDIMIENTO:     getSolicitud
	-- DESCRIPTION:       Trae los registros de una solicitud basada en los parametros recibidos
	-- ******************************************************************************************************
	PROCEDURE getSolicitud(p_idSolicitud   in sel_solicitudes_t.id_solicitud%type,
												 p_status        in sel_solicitudes_t.status%type,
												 p_tipoSolicitud in sel_solicitudes_t.id_tipo_solicitud%type,
												 p_idOficina     in sel_solicitudes_t.id_oficina_entrega%type,
												 p_idProvincia   in sre_provincias_t.id_provincia%type,
												 p_registros     in number,
												 p_iocursor      out t_cursor,
												 p_resultnumber  out varchar2);

	-- ******************************************************************************************************
	-- PROCEDIMIENTO:     getSolicitud_RNC
	-- DESCRIPTION:       Trae los registros de una solicitud basada en el RNC o la Cedula del empleador
	-- ******************************************************************************************************
	PROCEDURE getSolicitud_RNC(p_rnc_o_cedula in sre_empleadores_t.rnc_o_cedula%type,
														 p_iocursor     out t_cursor,
														 p_resultnumber out varchar2);

	-- ******************************************************************************************************
	-- PROCEDIMIENTO:     getSolicitud_Oficina
	-- DESCRIPTION:       Trae los registros de una solicitud basada en el ID de la oficina
	-- ******************************************************************************************************
	PROCEDURE getSolicitud_Oficina(p_id_oficina   in sel_oficinas_t.id_oficina%type,
																 p_iocursor     out t_cursor,
																 p_resultnumber out varchar2);

	-- ******************************************************************************************************
	-- PROCEDIMIENTO:     getSolicitud_Status
	-- DESCRIPTION:       Trae los registros de una solicitud basada en el status pasado como parametro
	-- ******************************************************************************************************
	PROCEDURE getSolicitud_Status(p_status       in sel_solicitudes_t.status%type,
																p_iocursor     out t_cursor,
																p_resultnumber out varchar2);

	-- ****************************************************************************************************
	-- PROCEDIMIENTO:     getNombreCiudadano
	-- DESCRIPTION:       Devuelve el nombre completo del ciudadano basado en el tipo y numero de documento
	--                    dependiendo de los parametros que se le pasen.
	-- ****************************************************************************************************
	PROCEDURE getNombreCiudadano(p_tipo         in sre_ciudadanos_t.tipo_documento%type,
															 p_documento    in sre_ciudadanos_t.no_documento%type,
															 p_resultnumber out varchar2);

	-- ****************************************************************************************************
	-- PROCEDIMIENTO:     getInformacion
	-- DESCRIPTION:       Devuelve un registro de la tabla sel_informacion_t y numero de documento
	--                    basado en el id de la solicitud
	-- ****************************************************************************************************
	PROCEDURE getInformacion(p_idSolicitud  in sel_solicitudes_t.id_solicitud%type,
													 p_iocursor     out t_cursor,
													 p_resultnumber out varchar2);

	-- ****************************************************************************************************
	-- PROCEDIMIENTO:     getInformacionGral
	-- DESCRIPTION:       Devuelve un registro de la tabla sel_informacion_grl_t y numero de documento
	--                    basado en el id de la solicitud
	-- ****************************************************************************************************
	PROCEDURE getInformacionGral(p_idSolicitud  in sel_solicitudes_t.id_solicitud%type,
															 p_iocursor     out t_cursor,
															 p_resultnumber out varchar2);

	-- ****************************************************************************************************
	-- PROCEDIMIENTO:     getStatus
	-- DESCRIPTION:       Devuelve el contenido de la tabla sel_status_t como un dataset
	-- ****************************************************************************************************
	PROCEDURE getStatus(p_iocursor out t_cursor);

	-- ****************************************************************************************************
	-- PROCEDIMIENTO:     getOficinas
	-- DESCRIPTION:       Devuelve el contenido de la tabla sel_oficinas_t como un dataset
	-- ****************************************************************************************************
	PROCEDURE getOficinas(p_iocursor out t_cursor);

	-- **************************************************************************************************
	-- PROCEDIMIENTO: EstadoCuentaEmail
	-- DESCRIPCION:   Genera un estado de cuenta y lo envia a un email especificado
	-- **************************************************************************************************
	procedure EstadoCuentaEmail(p_rnc          in sre_empleadores_t.rnc_o_cedula%type,
															p_cedula       in sre_ciudadanos_t.no_documento%type,
															p_email        in sre_empleadores_t.email%type,
															p_resultnumber out varchar2);

	-- **************************************************************************************************
	-- PROCEDIMIENTO:     IsRncRegistrado
	-- DESCRIPTION:       recibe un rnc_cedula y devuelve 1 si existe y 0 si no existe
	-- **************************************************************************************************
	PROCEDURE IsRncRegistrado(p_rnc_o_cedula in SRE_EMPLEADORES_T.Rnc_o_Cedula%type,
														p_resultnumber out varchar2);

	-- **************************************************************************************************
	-- PROCEDIMIENTO:     sRepresentanteEnEmpresa
	-- DESCRIPTION:       recibe el rnc del empleador y la cedula del representante para:
	--                    validar que el empleador exista y que este activo y que el representante
	--                    corresponda al empleador y que tambien este activo
	-- **************************************************************************************************
	PROCEDURE IsRepresentanteEnEmpresa(p_rnc          in SRE_EMPLEADORES_T.Rnc_o_Cedula%type,
																		 p_cedula       in SRE_CIUDADANOS_T.No_documento%type,
																		 p_resultnumber out varchar2);

	-- **************************************************************************************************
	-- PROCEDIMIENTO:     getRazonSocialEnDGII
	-- DESCRIPTION:       recibe un rnc_cedula, busca y devuelve la razon social de la talba dgi_maestro_empleadores_t
	-- **************************************************************************************************
	PROCEDURE getRazonSocialEnDGII(p_rnc_o_cedula in dgi_maestro_empleadores_t.rnc_cedula%type,
																 p_resultnumber out varchar2);

	PROCEDURE IsIdSolicitudValido(p_IdSolicitud  in sel_solicitudes_t.id_solicitud%type,
																p_resultnumber out varchar2);

	-- **************************************************************************************************
	-- Function:     Function isExisteTipoSolicitud
	-- DESCRIPCION:       Funcion que retorna la existencia de un id_Tipo_Solicitud..
	--                     Recibe : el parametro p_id_Tipo_Solicitud.
	--                     Devuelve: un valor booleano (0,1) . 0 = no existe  1 = existe

	-- **************************************************************************************************
	FUNCTION isExisteTipoSolicitud(p_id_Tipo_Solicitud VARCHAR2) RETURN BOOLEAN;

	-- **************************************************************************************************
	-- Function:     Function isExisteIdSolicitud
	-- DESCRIPCION:       Funcion que retorna la existencia de un id_Solicitud.
	--                     Recibe : el parametro p_id_Solicitud.
	--                     Devuelve: un valor booleano (0,1) . 0 = no existe  1 = existe

	-- **************************************************************************************************
	function isExisteIdSolicitud(p_IdSolicitud varchar2) return boolean;

	-- **************************************************************************************************
	-- Function:     Function isExisteOficina
	-- DESCRIPCION:  Valida que exista la oficina
	--               Recibe  : el parametro p_id_oficina.
	--               Devuelve: un valor booleano (true,false). true = existe false = no existe
	-- **************************************************************************************************
	FUNCTION isExisteOficina(p_id_oficina VARCHAR2) RETURN BOOLEAN;

	-- **************************************************************************************************
	-- Function:     getProvinciaDes
	-- DESCRIPCION:  Devuelve el nombre de la provincia a partir del RCN del empleador
	--               Recibe  : el RNC del empleador
	--               Devuelve: varchar2
	-- **************************************************************************************************
	FUNCTION getProvinciaDes(p_rnc VARCHAR2) RETURN varchar2;

	-- **************************************************************************************************
	-- Function:     getProvinciaID
	-- DESCRIPCION:  Devuelve el ID de la provincia a partir del RCN del empleador
	--               Recibe  : el RNC del empleador
	--               Devuelve: varchar2
	-- **************************************************************************************************
	FUNCTION getProvinciaID(p_rnc VARCHAR2) RETURN varchar2;

	-- ******************************************************************************************************
	-- PROCEDIMIENTO:     BorrarSolicitud
	-- DESCRIPTION:       Borra la solicitud especificada en el parametro
	-- ******************************************************************************************************
	PROCEDURE BorrarSolicitud(p_IdSolicitud  in sel_solicitudes_t.id_solicitud%type,
														p_resultnumber out varchar2);

	PROCEDURE getpageSolicitud_RNC(p_rnc_o_cedula in sre_empleadores_t.rnc_o_cedula%type,
																 p_pagenum      in number,
																 p_pagesize     in number,
																 p_iocursor     out t_cursor,
																 p_resultnumber out varchar2);

	--*********************************************************************************************************
	-- PROCEDIMIENTO:  getSolicitudes
	-- DESCRIPTION:    Trae las solicitudes trabajadas por el CAE según el rango de fecha especificado
	-- **************************************************************************************************
	PROCEDURE getSolicitudes(p_fecha_desde  date,
													 p_fecha_hasta  date,
													 p_iocursor     out t_cursor,
													 p_resultnumber out Varchar2);

	--*********************************************************************************************************
	-- PROCEDIMIENTO:  getPagesolicitudes
	-- DESCRIPTION:    Trae las solicitudes trabajadas por el CAE según el rango de fecha especificado y paginada agrupado por operador
	-- **************************************************************************************************
	PROCEDURE getPagesolicitudes(p_fecha_desde  date,
															 p_fecha_hasta  date,
															 p_pagenum      in number,
															 p_pagesize     in number,
															 p_iocursor     out t_cursor,
															 p_resultnumber out Varchar2);

	--*********************************************************************************************************
	-- PROCEDIMIENTO:  getPageDetsolicitudes
	-- DESCRIPTION:    Trae el detalle de las solicitudes trabajadas por un usuario especificado, paginado.
	-- **************************************************************************************************
	PROCEDURE getPageDetsolicitudes(p_id_tipo_solicitud in sel_solicitudes_t.id_tipo_solicitud%type,
																	p_fecha_desde       date,
																	p_fecha_hasta       date,
																	p_pagenum           in number,
																	p_pagesize          in number,
																	p_iocursor          out t_cursor,
																	p_resultnumber      out Varchar2);

	-- **************************************************************************************************
	-- PROCEDIMIENTO:  getReferencias
	-- DESCRIPTION:    Trae referencias para un rnc especificado
	-- **************************************************************************************************
	PROCEDURE getReferencias(p_rnc_o_cedula in sre_empleadores_t.rnc_o_cedula%type,
													 p_iocursor     out t_cursor,
													 p_resultnumber out varchar2);

	--*********************************************************************************************************
	-- PROCEDIMIENTO:  getSolicitudesGeneral
	-- DESCRIPTION:    Trae las solicitudes
	-- **************************************************************************************************
	PROCEDURE getSolicitudesGeneral(p_status         in sel_solicitudes_t.status%type,
                                  p_usuario        in sel_solicitudes_t.ult_usr_modifico%type,
                                  p_tipo_solicitud in sel_solicitudes_t.id_tipo_solicitud%type,
                                  p_fecha_desde    in sel_solicitudes_t.fecha_registro%type,
                                  p_fecha_hasta    in sel_solicitudes_t.fecha_cierre%type,
                                  p_pagenum        in number,
                                  p_pagesize       in number,
                                  p_iocursor       out t_cursor,
                                  p_resultnumber   out Varchar2);

	--******************************************************************************************
	--Milciades Hernandez
	--08/02/2010
	--Function tre los cantidades de dias y horas de jornadas durante proceso de solitud
	--CantidadDiasJornadas
	--******************************************************************************************

	FUNCTION CantidadDiasJornadas(p_fecha_inicio in date,
																p_fecha_fin    in date,
																p_solicitud    in sel_solicitud_pausa_t.id_solicitud%type)
		RETURN NUMBER;

	PROCEDURE getSolicitudesServicio(p_iocursor     out t_cursor,
																	 p_resultnumber out varchar2);
	--******************************************************************************************
	--
	--******************************************************************************************
	PROCEDURE getHistoricoUsuarioSol(p_idsolicitud  in sel_solicitudes_t.id_solicitud%type,
																	 p_iocursor     out t_cursor,
																	 p_resultnumber out varchar2);

	--********************************************************************************************
	--CMHA
	--23/04/10
	--********************************************************************************************
	procedure getSolicitudByRNC(p_rnc          sel_solicitudes_t.rnc_o_cedula%type,
															p_resultnumber out varchar2);
	--******************************************************************************************
	--Heidi Peralta
	--Funcion que calcula el tiempo total en pausa de una solicitud dada
	--******************************************************************************************
	FUNCTION TiempoEnPausa(p_solicitud in sel_solicitud_pausa_t.id_solicitud%type)
		return number;

	function hours_worked(p_stime       in date,
												p_etime       in date,
												p_clockin     number,
												p_clockout    number,
												p_ignore_days in varchar2) return number;

	-- **************************************************************************************************
	-- Function:     procedure isExisteNroSolicitud
	-- DESCRIPCION:       procedimiento que retorna la existencia de un numero de solicitud..
	--                     Recibe : el parametro p_Nro_Solicitud.
	--                     Devuelve: un valor booleano (0,1) . 0 = no existe  1 = existe

	-- **************************************************************************************************
	PROCEDURE isExisteNroSolicitud(p_Nro_Solicitud VARCHAR2,
																 p_resultnumber  out VARCHAR2);
	-- **************************************************************************************************
	-- PROCEDIMIENTO:     Crear_SolicitudRegEmp
	-- DESCRIPTION:       Crea nuevo registro de Solicitud de Registro de nueva empresa
	-- **************************************************************************************************
PROCEDURE Crear_RegEmpresa_Solicitud(p_nro_solicitud    in sel_solicitudes_t.no_solicitud%type,																			
																			 p_usuario          in sel_solicitudes_t.representante%type,
																			 p_id_clase_empresa in sel_solicitudes_t.id_clase_emp%type, 
                                       p_rnc_o_cedula     in sel_solicitudes_t.rnc_o_cedula%type,
																			 p_comentarios      in sel_solicitudes_t.comentarios%type,
																			 p_resultnumber     out varchar2);
	--****************************************************************************************---
	--29/09/2014
	--****************************************************************************************--
	procedure ActualizaSolicitud(p_no_solicitud  in number,
															 p_representante in varchar2,
															 p_rnc_o_cedula  in varchar2,
															 p_resultnumber  out varchar2);
	--*******************************************************************************************--\
	--30/09/2014
	--Registra el historico de solicitud 
	--********************************************************************************************-- 
	procedure getHistoricoSolicitudes(p_no_solicitud in varchar2,
																		p_iocursor     out t_cursor,
																		p_resultnumber out varchar2);

	--*******************************************************************************************--\
	--14/10/2014
	--Actualiza el status de los registros en el historico de solicitudes
	--By kerlin de la cruz 
	--********************************************************************************************-- 
	procedure ActualizarStatusSol(p_id_solicitud in sel_solicitudes_t.id_solicitud%type,
																p_status       in sel_solicitudes_t.status%type,
																p_resultnumber out varchar2); 
                                
  	--****************************************************************************************--- -- Procedimiento: ActualizaStatusSol
  -- By: Kerlin de la cruz
	-- Fecha : 11/05/2015  
  
	--****************************************************************************************--
	procedure ActualizaStatus(p_no_solicitud  in sel_solicitudes_t.no_solicitud%type,	
                               p_status in sel_solicitudes_t.status%type,                                                                                       														 
															 p_resultnumber  out varchar2); 
                               
  --*********************************************************************************
  -- Procedimiento: ActualizaStatus 
  -- Actualiza el status de la solicitud en cuestion
  -- By: Kerlin de la cruz              
	-- Fecha : 11/05/2015  
  
	--*************************************************************************************
  
	procedure ActualizaStatus1(p_id_solicitud  in sel_solicitudes_t.id_solicitud%type,	
                               p_status in sel_solicitudes_t.status%type,                                                                                       														 
															 p_resultnumber  out varchar2);                                                              

	--*********************************************************************************************************
	-- By Kerlin De La Cruz 
	-- PROCEDIMIENTO:  InsertarDocs
	-- DESCRIPTION:    Se insertan los documentos correspondiente con el nuevo registro de empresa
	-- Fecha: 21/11/2014
	-- **************************************************************************************************
	PROCEDURE InsertarDocs(p_no_solicitud     in sel_solicitudes_t.no_solicitud%type,
												 p_id_requisito     in sre_clase_emp_docs_cargados_t.id_requisito%type,
												 p_documento        in blob,
												 p_nombre_documento in sre_clase_emp_docs_cargados_t.nombre_documento%type,
												 p_tipo_archivo     in sre_clase_emp_docs_cargados_t.tipoarchivo%type,
												 p_resultnumber     out Varchar2);

	--*********************************************************************************************************
	-- By Kerlin De La Cruz 
	-- PROCEDIMIENTO: InsertarHistSol
	-- DESCRIPTION: Se inserta el estatus en el cual se encuentra alctualmente la solicitud
	-- Fecha: 26/11/2014
	-- **************************************************************************************************
	PROCEDURE InsertarHistSol(p_no_solicitud      in sel_solicitudes_t.no_solicitud%type,
														p_id_tipo_solicitud in sel_historico_solicitudes_t.id_tipo_solicitud%type,
														p_status            in sel_historico_solicitudes_t.id_status%type,
														p_resultnumber      out Varchar2);
	--**************************************************************************************************
	--Eury Vallejo - Modificando uso de la carga de los requisitos
	--08/01/2015
	-- SEL_SOLICITUDES_PKG - Mostrar Requisitos
	--**************************************************************************************************
	Procedure SolicitudCargaDocs(p_no_solicitud     in sel_solicitudes_t.no_solicitud%type,
															 p_id_clase_empresa in sre_clase_empresa_t.id_clase_emp%type,
															 p_iocursor         out t_cursor,
															 p_resultnumber     out Varchar2);

	--*********************************************************************************************************
	-- By Kerlin De La Cruz 
	-- PROCEDIMIENTO: GetDocCargados
	-- DESCRIPTION: Muestra las imagenes cargadas para una solicitud en especifico
	-- Fecha: 19/01/2015
	-- **************************************************************************************************
	Procedure GetDocCargados(p_no_solicitud in sel_solicitudes_t.no_solicitud%type,
													 p_iocursor     out t_cursor,
													 p_resultnumber out Varchar2);

	--*********************************************************************************************************
	-- By Kerlin De La Cruz 
	-- PROCEDIMIENTO: Insertar_Emp_Tmp
	-- DESCRIPTION: Inserta las informaciones temporales del empleador a registrar en cuestion
	-- Fecha: 27/01/2015
	-- *********************************************************************************************************

	Procedure Insertar_Emp_Tmp(p_rnc_o_cedula         in sel_empleadores_tmp_t.rnc_o_cedula%type,
														 p_razon_social         in sel_empleadores_tmp_t.razon_social%type,
														 p_nombre_comercial     in sel_empleadores_tmp_t.nombre_comercial%type,
														 p_status               in sel_empleadores_tmp_t.status%type,
														 p_tipo_empresa         in sel_empleadores_tmp_t.tipo_empresa%type,
														 p_sector_salarial      in sel_empleadores_tmp_t.sector_salarial%type,
														 p_id_sector_economico  in sel_empleadores_tmp_t.id_sector_economico%type,
														 p_id_actividad_eco     in sel_empleadores_tmp_t.id_actividad_eco%type,
														 p_tipo_zona_franca     in sel_empleadores_tmp_t.tipo_zona_franca%type,
														 p_parque               in sel_empleadores_tmp_t.parque%type,
														 p_calle                in sel_empleadores_tmp_t.calle%type,
														 p_numero               in sel_empleadores_tmp_t.numero%type,
														 p_apartamento          in sel_empleadores_tmp_t.apartamento%type,
														 p_sector               in sel_empleadores_tmp_t.sector%type,
														 p_provincia            in sel_empleadores_tmp_t.provincia%type,
														 p_id_municipio         in sel_empleadores_tmp_t.id_municipio%type,
														 p_telefono_1           in sel_empleadores_tmp_t.telefono_1%type,
														 p_ext_1                in sel_empleadores_tmp_t.ext_1%type,
														 p_telefono_2           in sel_empleadores_tmp_t.telefono_2%type,
														 p_ext_2                in sel_empleadores_tmp_t.ext_2%type,
														 p_fax                  in sel_empleadores_tmp_t.fax%type,
														 p_email                in sel_empleadores_tmp_t.email%type,
														 p_cedula_representante in sel_empleadores_tmp_t.cedula_representante%type,
														 p_telefono_rep_1       in sel_empleadores_tmp_t.telefono_rep_1%type,
														 p_ext_rep_1            in sel_empleadores_tmp_t.ext_rep_1%type,
														 p_telefono_rep_2       in sel_empleadores_tmp_t.telefono_rep_2%type,
														 p_ext_rep_2            in sel_empleadores_tmp_t.ext_rep_2%type,
														 p_ult_usuario_act      in sel_empleadores_tmp_t.ult_usuario_act%type,
														 p_ult_fecha_act        in sel_empleadores_tmp_t.ult_fecha_act%type,
														 P_id_solicitud         in sel_empleadores_tmp_t.id_solicitud%type,
														 p_resultnumber         out Varchar2
														 
														 );

	--*********************************************************************************************************
	-- By Kerlin De La Cruz 
	-- PROCEDIMIENTO: Get_Resumen_Emp
	-- DESCRIPTION: Muestra la informacion temporal de los nuevos registros de empleadores
	-- Fecha: 05/02/2015
	-- *********************************************************************************************************

	Procedure Get_Resumen_Emp(p_cod_sol      in sel_solicitudes_t.no_solicitud%type,
														p_iocursor     out t_cursor,
														p_resultnumber out Varchar2);

	--*********************************************************************************************************
	-- By: Kerlin De La Cruz 
	-- PROCEDIMIENTO: Get_historico_pasos
	-- DESCRIPTION: Muestra en el paso actual en el cual se encuentra la solicitud que se esta procesando
	-- Fecha: 12/02/2015
	-- *********************************************************************************************************

	Procedure Get_historico_pasos(p_cod_sol      in sel_solicitudes_t.no_solicitud%type,
																p_iocursor     out t_cursor,
																p_resultnumber out Varchar2);

	--*********************************************************************************************************
	-- By: Kerlin De La Cruz 
	-- PROCEDIMIENTO: Actualizar_his_status
	-- DESCRIPTION: Actualiza la fecha de actualizacion de la carga del ultimo archivo cargado para dicha solicitud
	--              en el historico de solicitudes
	-- Fecha: 17/02/2015
	-- *********************************************************************************************************

	Procedure Actualizar_his_status(p_cod_sol      in sel_solicitudes_t.no_solicitud%type,
																	p_resultnumber out Varchar2);

	-- **************************************************************************************************
	-- By: Kerlin De La Cruz
	-- Function:     Function isExisteIdSolicitud
	-- DESCRIPCION: Funcion que retorna la existencia de un id_Solicitud en sel_historico_solicitudes.
	-- Fecha: 20/02/2015
	-- **************************************************************************************************
	function isExisteHistorico(p_IdSolicitud varchar2) return boolean;

	-- **************************************************************************************************
	-- By: Kerlin De La Cruz
	-- Function: isExisteUsuario
	-- DESCRIPCION: Funcion que retorna la existencia de un usuario en seg_usuario_t.
	-- Fecha: 10/03/2015
	-- **************************************************************************************************
/*	procedure isExisteUsuario(p_usuario in seg_usuario_t.id_usuario%type,
                            p_class in seg_usuario_t.password%type,
                            p_resultnumber out Varchar2); */
                            
  -- **************************************************************************************************
	-- By: Kerlin De La Cruz
	-- Function: IsValidarEmail
	-- DESCRIPCION: Verifica si el usuario confirmo su emails  
	-- Fecha: 11/05/2015
	-- **************************************************************************************************
	procedure isExisteUsuario (p_usuario in seg_usuario_t.email%type,
                            p_class in seg_usuario_t.password%type,
                            p_resultnumber out Varchar2);                            
                            
  	-- **************************************************************************************************
	-- By: Kerlin De La Cruz
	-- Function: isExisteUsuario1
	-- DESCRIPCION: Funcion que retorna la existencia de un usuario en seg_usuario_t.
	-- Fecha: 05/005/2015
	-- **************************************************************************************************
	procedure isExisteUsuario1(p_usuario in seg_usuario_t.email%type,                           
                            p_resultnumber out Varchar2); 
                            
-- *****************************************************************************************
	-- By: Kerlin De La Cruz
	-- Function: isExisteUsuario2
	-- DESCRIPCION: Funcion que retorna la existencia de un usuario en seg_usuario_t.
	-- Fecha: 15/05/2015
	-- **************************************************************************************************
	procedure isExisteUsuario2(p_usuario in seg_usuario_t.id_usuario%type,                           
                            p_resultnumber out Varchar2);                                                       

	--*********************************************************************************************************
	-- By: Kerlin De La Cruz 
	-- PROCEDIMIENTO: SolEnProceso
	-- DESCRIPTION: Buscamos las solicitudes realizadas por el usuario en cuestion.
	-- Fecha: 10/03/2015
	-- *********************************************************************************************************
	Procedure SolEnProceso(p_usuario      in sel_solicitudes_t.representante%type,
												 p_iocursor     out t_cursor,
												 p_resultnumber out Varchar2);
                         
 	--*********************************************************************************************************
	-- By Kerlin De La Cruz 
	-- PROCEDIMIENTO: GetDocCargados
	-- DESCRIPTION: Muestra las cantidad de documentos cargados para una solicitud en especifico
	-- Fecha: 19/01/2015
	-- *********************************************************************************************************
	Procedure GetCantidadDoc(p_no_solicitud in sel_solicitudes_t.no_solicitud%type,
													 p_iocursor     out t_cursor,
													 p_resultnumber out Varchar2); 
                           
	-- **************************************************************************************************
	-- Procedure isExisteSolProceso
	-- DESCRIPCION: procedimiento que retorna la existencia de un numero de solicitud..
	--              Recibe : el parametro p_rnc_cedula.
	--              Devuelve: un valor booleano (0,1) . 1 = no existe  0 = existe
  -- By: Kerlin de la cruz
  -- Fecha: 17/04/2015
	-- **************************************************************************************************
	PROCEDURE isExisteSolProceso(p_rnc_o_cedula in suirplus.sel_solicitudes_t.rnc_o_cedula%type,
															 p_resultnumber  out VARCHAR2); 
                               
	--*********************************************************************************************************
	-- By Kerlin De La Cruz 
	-- PROCEDIMIENTO: GetNombreUsuario
	-- DESCRIPTION: Muestra el nombre completo del usuario en cuestion
	-- Fecha: 20/04/2015
	-- *********************************************************************************************************
	Procedure GetNombreUsuario(p_usuario in sel_solicitudes_t.representante%type,
													  p_iocursor     out t_cursor,
													  p_resultnumber out Varchar2); 
                            
	--*********************************************************************************************************
	-- PROCEDIMIENTO:  getConsSolicitudes
	-- DESCRIPTION: Muestra la informacion del empleador que se encuentra en sel_empleadores_tmp_t
  -- By: Kerlin de la cruz
  -- Fecha: 20/05/2015
	-- **************************************************************************************************
	PROCEDURE getInfoEmpresa(p_no_solicitud   in sel_solicitudes_t.no_solicitud%type,                              
													    p_iocursor     out t_cursor,
													    p_resultnumber out Varchar2);
                              
  	--*********************************************************************************************************
	-- PROCEDIMIENTO:  getInfoEmpresaEdit
	-- DESCRIPTION: Muestra la informacion del empleador que se encuentra en sel_empleadores_tmp_t
  -- By: Kerlin de la cruz
  -- Fecha: 20/05/2015
	-- **************************************************************************************************
	PROCEDURE getInfoEmpresaEdit(p_id_solicitud   in sel_solicitudes_t.id_solicitud%type,                              
													  p_iocursor     out t_cursor,
													  p_resultnumber out Varchar2);                               
                              
	-- PROCEDIMIENTO:  ActualizaInfoEmpresa
	-- DESCRIPTION: Actualiza la informacion que el representante decida editar antes de someterla
  --              a la revision de un representante de TSS
  -- By: Kerlin de la cruz
  -- Fecha: 20/05/2015
	-- **************************************************************************************************
	PROCEDURE ActualizaInfoEmpresa ( p_razon_social       in sel_empleadores_tmp_t.razon_social%type,
                                   p_nombre_comercial    in sel_empleadores_tmp_t.nombre_comercial%type,
                                   p_sector_salarial     in sel_empleadores_tmp_t.sector_salarial%type,
                                   p_id_sector_economico in sel_empleadores_tmp_t.id_sector_economico%type,
                                   p_id_actividad_eco    in sel_empleadores_tmp_t.id_actividad_eco%type,
                                   p_tipo_zona_franca    in sel_empleadores_tmp_t.tipo_zona_franca%type,
                                   p_parque              in sel_empleadores_tmp_t.parque%type,
                                   p_calle               in sel_empleadores_tmp_t.calle%type,
                                   p_numero              in sel_empleadores_tmp_t.numero%type,
                                   p_apartamento         in sel_empleadores_tmp_t.apartamento%type,                                   
                                   p_sector              in sel_empleadores_tmp_t.sector%type,
                                   p_provincia           in sel_empleadores_tmp_t.provincia%type,
                                   p_id_municipio        in sel_empleadores_tmp_t.id_municipio%type,
                                   p_telefono_1          in sel_empleadores_tmp_t.telefono_1%type,
                                   p_ext_1               in sel_empleadores_tmp_t.ext_1%type,
                                   p_telefono_2          in sel_empleadores_tmp_t.telefono_2%type,
                                   p_ext_2               in sel_empleadores_tmp_t.ext_2%type,
                                   p_fax                 in sel_empleadores_tmp_t.fax%type,
                                   p_email               in sel_empleadores_tmp_t.email%type,
                                   p_ced_rep             in sel_empleadores_tmp_t.cedula_representante%type,
                                   p_telefono_rep_1      in sel_empleadores_tmp_t.telefono_rep_1%type,
                                   p_ext_rep_1           in sel_empleadores_tmp_t.ext_rep_1%type,
                                   p_telefono_rep_2      in sel_empleadores_tmp_t.telefono_rep_2%type,
                                   p_ext_rep_2           in sel_empleadores_tmp_t.ext_rep_2%type,
                                   p_id_solicitud        in sel_empleadores_tmp_t.id_solicitud%type,
                                   p_resultnumber        out Varchar2);
                                     
	-- **************************************************************************************************
	-- PROCEDIMIENTO:     CargarArchivos
	-- DESCRIPTION:       Trae los archivos cargados  en una solicitud
  -- BY : Kerlin De La Cruz
  -- Fecha : 27/05/2015
	-- **************************************************************************************************
	PROCEDURE CargarArchivos(p_idSolicitud  in sel_solicitudes_t.id_solicitud%type,
												   p_iocursor     out t_cursor,
												   p_resultnumber out varchar2);     
  -- **************************************************************************************************
	-- PROCEDIMIENTO:     CargarArchivos - Sobrecarga
	-- DESCRIPTION:       Trae los archivos cargados  en una solicitud
  -- BY : Kerlin De La Cruz
  -- Fecha : 27/05/2015
	-- **************************************************************************************************
	PROCEDURE CargarArchivos(p_idSolicitud  in sel_solicitudes_t.id_solicitud%type,   
                           p_idrequisito  in sre_clase_emp_docs_cargados_t.id_requisito%type,
												   p_iocursor     out t_cursor,
												   p_resultnumber out varchar2);
                           
	-- **************************************************************************************************
	-- PROCEDIMIENTO:     CargarComentario
	-- DESCRIPTION:       Trae los archivos cargados  en una solicitud
  -- BY : Kerlin De La Cruz
  -- Fecha : 27/05/2015
	-- **************************************************************************************************
	PROCEDURE CargarComentario(p_no_Solicitud  in sel_solicitudes_t.no_solicitud%type,
												     p_iocursor     out t_cursor,
												     p_resultnumber out varchar2);
                             
-- ****************************************************************************************************
	-- PROCEDIMIENTO:     getNombreRepresentante
	-- DESCRIPTION:       Devuelve el nombre completo del ciudadano basado en el tipo y numero de documento
	--                    dependiendo de los parametros que se le pasen.
  --FECHA : 01/06/2015
  -- By: Kerlin de la cruz
	-- ****************************************************************************************************
	PROCEDURE getNombreRepresentante(p_documento    in sre_ciudadanos_t.no_documento%type, 
                                  p_iocursor     out t_cursor,
															    p_resultnumber out varchar2) ; 
                                  
                                  
	--*********************************************************************************************************
	-- PROCEDIMIENTO:  ActStatusEmpTmp
	-- DESCRIPTION: Actualiza la informacion que el representante decida editar antes de someterla
  --              a la revision de un representante de TSS
  -- By: Kerlin de la cruz
  -- Fecha: 02/06/2015
	-- **************************************************************************************************
	PROCEDURE ActStatusEmpTmp(p_id_solicitud  in sel_empleadores_tmp_t.id_solicitud%type,
                            p_status        in sel_empleadores_tmp_t.status%type,                            
                            p_resultnumber  out Varchar2); 
                            
                            
	--*********************************************************************************************************
	-- PROCEDIMIENTO:  ActRequisitos
	-- DESCRIPTION: Modifica el archivo ya cargado en un registro de empresa   
  -- By: Kerlin de la cruz
  -- Fecha: 12/06/2015
	-- **************************************************************************************************
	PROCEDURE ActRequisitos(p_id_solicitud  in sre_clase_emp_docs_cargados_t.id_solicitud%type,
                          p_nombre_doc    in sre_clase_emp_docs_cargados_t.nombre_documento%type, 
                          p_documento     in blob,                           
                          p_resultnumber  out Varchar2); 
                          
-- ****************************************************************************************************
	-- PROCEDIMIENTO:     getDocCargados
	-- DESCRIPTION:       Devuelve los documentos cargados para una solicitud en cuestion
  -- FECHA : 12/06/2015
  -- By: Kerlin de la cruz
	-- ****************************************************************************************************
	PROCEDURE GetEditDoc(p_id_solicitud  in sre_clase_emp_docs_cargados_t.id_solicitud%type, 
                           p_iocursor     out t_cursor,
													 p_resultnumber out varchar2);                                                                                                                                                                                                                                                                                                                        
  --******************************************************************************************
  --Eury Vallejo
  --Creacion de Funcion para medir tiempo Solicitudes
  --******************************************************************************************
    FUNCTION TiempoSolicitudes(p_solicitud in sel_solicitudes_t.id_solicitud%type)
    RETURN NUMBER;

end SEL_SOLICITUDES_PKG;