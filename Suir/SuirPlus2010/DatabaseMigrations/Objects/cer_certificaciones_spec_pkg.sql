CREATE OR REPLACE PACKAGE suirplus.cer_certificaciones_pkg IS


  -- Author  : CHARLIE_PE?A
  -- Created : 2/3/2005 9:49:42 AM
  -- Purpose : Manejo de certificaciones

  -- Public type declarations
  TYPE t_cursor IS REF CURSOR;

  -- **************************************************************************************************
  -- PROCEDIMIENTO: getCertificacion(Nuevo by charlie pena)
  -- DESCRIPCION: Consulta que presenta el contenido de una certificacion,tomando en consideracion el parametro de entrada (p_id_certificacion).
  -- **************************************************************************************************
  PROCEDURE getCertificacion(p_id_certificacion IN CER_CERTIFICACIONES_T.id_certificacion%TYPE,
                             p_iocursor         OUT t_cursor,
                             p_resultnumber     OUT VARCHAR2);

  --***************************************************************************************************
  PROCEDURE CrearCertificacionesCer(p_id_usuario  IN CER_CERTIFICACIONES_T.id_usuario%TYPE,
                                    p_id_tipo     IN OUT CER_CERTIFICACIONES_T.ID_TIPO_CERTIFICACION%TYPE,
                                    p_rnc_cedula  IN SRE_EMPLEADORES_T.rnc_o_cedula%TYPE,
                                    p_idnss       IN SRE_CIUDADANOS_T.ID_NSS%TYPE,
                                    p_id_firma    IN CER_CERTIFICACIONES_T.ID_FIRMA%type,
                                    p_fecha_desde varchar2,
                                    p_fecha_hasta varchar2,
                                    --  p_comentario   in CER_CERTIFICACIONES_T.COMENTARIO%type,
                                    -- p_documento    in CER_CERTIFICACIONES_T.DOCUMENTO%type,
                                    p_resultnumber OUT VARCHAR2);

  PROCEDURE getTipoCertificaciones(p_OnLine       in cer_tipos_certificaciones_t.on_line%type,
                                   p_iocursor     IN OUT t_cursor,
                                   p_resultnumber OUT VARCHAR2);
                                   
   -- **************************************************************************************************
  -- Program: Tipo_Certificaciones_OnLine
  -- Description: Muestra los tipos de certificaciones activas
  -- Date: 24/05/2017 
  -- By: Kerlin de la Cruz
  -- **************************************************************************************************

  PROCEDURE GetTipoCertificacion(p_iocursor     IN OUT t_cursor,
                                   p_resultnumber OUT VARCHAR2);                                  
                                   
  -- **************************************************************************************************
  -- Program:     GetTipoCertificacionActiva
  -- Description: Este metodo devuelve un 1 si esta activa y 0 si esta inactiva
  -- **************************************************************************************************
  PROCEDURE GetTipoCertificacionActiva(p_id_tipo_certificacion in cer_tipos_certificaciones_t.id_tipo_certificacion%type,
                                       p_resultnumber          OUT VARCHAR2);                                   

  PROCEDURE Existe_Empleador_Ciudadano(p_Rnc_Cedula       in sre_empleadores_t.rnc_o_cedula%type,
                                       p_TipoVerificacion in varchar2,
                                       p_resultnumber     OUT VARCHAR2);

  PROCEDURE Get_Empleador_Ciudadano(p_Rnc_Cedula       in sre_empleadores_t.rnc_o_cedula%type,
                                    p_TipoVerificacion in varchar2,
                                    p_iocursor         IN OUT t_cursor);

  PROCEDURE Get_Nominas_Empleador(p_Rnc_Cedula in sre_empleadores_t.rnc_o_cedula%type,
                                  p_iocursor   IN OUT t_cursor);

  PROCEDURE ValidaUltimoAporte(p_Cedula   in sre_ciudadanos_t.no_documento%type,
                               p_iocursor IN OUT t_cursor);

  PROCEDURE Get_Periodo_UltimaFactura(p_Rnc_Cedula   in sre_empleadores_t.rnc_o_cedula%type,
                                      p_resultnumber OUT VARCHAR2);

  PROCEDURE Get_Facturas_Vencidas(p_Rnc_Cedula in sre_empleadores_t.rnc_o_cedula%type,
                                  p_iocursor   IN OUT t_cursor);

  PROCEDURE Existe_Factura(p_Rnc_Cedula in sre_empleadores_t.rnc_o_cedula%type,
                           p_iocursor   IN OUT t_cursor);

  PROCEDURE TieneAporte(p_Rnc_Cedula   in sre_empleadores_t.rnc_o_cedula%type,
                        p_cedula       in sre_ciudadanos_t.no_documento%type,
                        p_resultnumber OUT VARCHAR2);

  PROCEDURE TieneAporte(p_Rnc_Cedula   in sre_empleadores_t.rnc_o_cedula%type,
                        p_cedula       in sre_ciudadanos_t.no_documento%type,
                        p_fecha_desde  in sfc_facturas_t.fecha_emision%type,
                        p_fecha_hasta  in sfc_facturas_t.fecha_emision%type,
                        p_resultnumber OUT VARCHAR2);

  PROCEDURE Get_Certificacion_No_Operacion(p_Rnc_Cedula  in sre_empleadores_t.rnc_o_cedula%type,
                                           p_fecha_desde IN CER_CERTIFICACIONES_T.fecha_desde%TYPE,
                                           p_fecha_hasta IN CER_CERTIFICACIONES_T.fecha_hasta%TYPE,
                                           p_iocursor    IN OUT t_cursor);

  PROCEDURE TieneAporte(p_cedula       in sre_ciudadanos_t.no_documento%type,
                        p_resultnumber OUT VARCHAR2);

  PROCEDURE ElegibleIngresoTardio(p_cedula       in sre_ciudadanos_t.no_documento%type,
                                  p_resultnumber OUT VARCHAR2);

  PROCEDURE getDetalleCertificacion(p_IdCertificacion in cer_certificaciones_t.id_certificacion%type,
                                    p_TipoDetalle     in varchar2,
                                    p_iocursor        OUT t_cursor);
  -- **************************************************************************************************
  -- PROCEDIMIENTO:     getMontoAdeudado
  -- DESCRIPTION:       Trae trae el monto total que debe un empleador para una certificacion especifica.
  -- AUTOR:             Yacell Borges
  -- FECHA:             08-03-2012
  -- **************************************************************************************************
  Procedure getMontoAdeudado(p_idcertificacion in cer_certificaciones_t.id_certificacion%type,
                             p_monto           out number,
                             p_resultnumber    out varchar2);

  -- **************************************************************************************************
  -- PROCEDIMIENTO:     consCert
  -- DESCRIPCION:       Consulta de Certificaciones
  -- **************************************************************************************************
  /*PARAMETROS

         ******************************************************************************************************************************************************
         *  NOMBRE         ** TIPO_DATO          **   TIPO_PARAMETRO    **  DESCRIPCION                                 **    VALIDACION
         ******************************************************************************************************************************************************
         * p_numCert       **  NUMBER(9)         **       IN            **  Codigo de Cerfificacion asignado            **  Se verifica que el parametro no sea nulo
         * p_rnc_o_cedula  **  VARCHAR2(11)      **       IN            **  Numero de RNC o Cedula empleador            **  Se verifica que el parametro no sea nulo
         * p_cedula        **  VARCHAR2(25)      **       IN            **  Numero de Documento del ciudadano.          **  Se verifica que el parametro no sea nulo
         * p_iocursor      **  CURSOR            **       IN/OUT        **  Parametro de Entrada y/o salida que devuelve**  N/A
         *                 **                    **                     **  el contenido del query asignado al cursor   **  N/A
         * p_resultnumber  **  VARCHAR2          **       OUT           **  Resultado                                   **  Si el procedimiento se realiza satisfactoriamente devolvera "0", de lo contrario devuelve mensaje de error                                             **
         ******************************************************************************************************************************************************
         ******************************************************************************************************************************************************
  */
  PROCEDURE consCert(p_numCert      IN CER_CERTIFICACIONES_T.ID_CERTIFICACION%TYPE,
                     p_rnc_o_cedula IN SRE_EMPLEADORES_T.rnc_o_cedula%TYPE,
                     p_cedula       IN SRE_CIUDADANOS_T.no_documento%TYPE,
                     p_iocursor     OUT t_cursor,
                     p_resultnumber OUT VARCHAR2);

  PROCEDURE getFirmaResponsable(p_TipoCertificacion in cer_certificaciones_t.id_tipo_certificacion%type,
                                p_IdUsuario         in cer_certificaciones_t.id_usuario%type,
                                p_Firma             out cer_certificaciones_t.firma%type,
                                p_Puesto            out varchar2,
                                p_resultnumber      out varchar2);

  /*
  -- **************************************************************************************************
  -- PROCEDIMIENTO:     Function isExisteCertificacion
  -- DESCRIPCION:       Funcion que retorna la existencia de un id_certificacion.
                        Recibe : el parametro p_id_certificacion.
                        Devuelve: un valor booleano (0,1) . 0 = no existe  1 = existe
  -- **************************************************************************************************
  */
  FUNCTION isExisteCertificacion(p_id_certificacion VARCHAR2) RETURN BOOLEAN;

  /*
  -- **************************************************************************************************
  -- FUNCION:     Function isExisteNodoc
  -- DESCRIPCION: Funcion que retorna la existencia de un No_documento cuando su tipo de doc. es cedula.
                  Recibe : el parametro p_no_doc.
                  Devuelve: un valor booleano (0,1) . 0 = no existe  1 = existe.
  -- **************************************************************************************************
  */
  FUNCTION isExisteNodoc(p_no_doc VARCHAR2) RETURN BOOLEAN;

-- ************************************************************************--
-- ************************************************************************--
 function getFechaCertificacion(p_id_certificacion in cer_certificaciones_t.id_certificacion%type)
    return date;

  -- ******************************************************************************************************
  -- PROCEDIMIENTO:     getCertificaciones
  -- DESCRIPTION:       Trae trae el listado de las certificaciones por el Status especificado
  -- AUTOR:             Francis Ramirez
  -- FECHA:             2010-08-02
  -- ******************************************************************************************************
  Procedure getCertificaciones(p_numCert                 IN CER_CERTIFICACIONES_T.ID_CERTIFICACION%TYPE,
                               p_no_certificacion        IN CER_CERTIFICACIONES_T.No_Certificacion%TYPE,
                               p_rnc_o_cedula            IN SRE_EMPLEADORES_T.rnc_o_cedula%TYPE,
                               p_cedula                  IN SRE_CIUDADANOS_T.no_documento%TYPE,
                               p_id_status_certificacion in cer_status_certificaciones_t.id_status_certificacion%type,
                               p_tipo                    in varchar2,
                               p_pagenum                 in number,
                               p_pagesize                in number,
                               p_desde                   in date,
                               p_hasta                   in date,
                               p_iocursor                IN OUT t_cursor,
                               p_resultnumber            OUT VARCHAR2);

  -- ******************************************************************************************************
  -- PROCEDIMIENTO:     getFirmasOficinas
  -- DESCRIPTION:       Trae el listado de todas las firmas activas activas.
  -- AUTOR:             Francis Ramirez
  -- Fecha:              2010-08-02--
  -- ******************************************************************************************************
  PROCEDURE getFirmasOficinas(p_iocursor     IN OUT t_cursor,
                              p_resultnumber OUT VARCHAR2);

  -- ******************************************************************************************************
  -- PROCEDIMIENTO:     getStatusCertificaciones
  -- DESCRIPTION:       Trae el listado de todas los estatus activos.
  -- AUTOR:             Francis Ramirez
  -- Fecha:              2010-09-02--
  -- ******************************************************************************************************
  PROCEDURE getStatusCertificaciones(p_iocursor     IN OUT t_cursor,
                                     p_resultnumber OUT VARCHAR2);
  -- ******************************************************************************************************
  -- PROCEDIMIENTO:     subirImagenCertificacion
  -- DESCRIPTION:       para subir una imagen a una certificacion existente
  -- AUTOR:             Francis Ramirez
  -- Fecha:              2010-09-02--
  -- ******************************************************************************************************
  Procedure subirImagenCertificacion(p_id_certificacion in cer_certificaciones_t.id_certificacion%type,
                                     p_imagen           in cer_certificaciones_t.documento%type,
                                     p_id_firma         in cer_certificaciones_t.id_firma%type,
                                     p_usuario          in cer_certificaciones_t.id_usuario%type,
                                     p_resultnumber     OUT VARCHAR2);

  -- ******************************************************************************************************
  -- PROCEDIMIENTO:     getImagenCertificacion
  -- DESCRIPTION:       Devuelve la imagen de la Certificacion Especificada.
  -- AUTOR:             Francis Ramirez
  -- FECHA:             2010-10-02
  -- ******************************************************************************************************
  procedure getImagenCertificacion(p_id_certificacion in cer_certificaciones_t.id_certificacion%type,
                                   p_iocursor         IN OUT t_cursor,
                                   p_resultnumber     OUT VARCHAR2);

  -- **************************************************************************************************
  -- PROCEDIMIENTO:     CambiarStatusCert
  -- Description:       Metodo para cambiar el estatus de las certificaciones.
  -- **************************************************************************************************
  procedure CambiarStatusCert(p_id_certificacion        IN CER_CERTIFICACIONES_T.id_certificacion%TYPE,
                              p_id_status_certificacion cer_status_certificaciones_t.id_status_certificacion%type,
                              p_id_usuario              IN CER_CERTIFICACIONES_T.id_usuario%TYPE,
                              p_comentario              in CER_CERTIFICACIONES_T.COMENTARIO%type,
                              p_resultnumber            OUT VARCHAR2);

  -- **************************************************************************************************
  -- PROCEDIMIENTO: getCertificacion(Nuevo by Mayreni Vargas)
  -- DESCRIPCION: Consulta que presenta el contenido de una certificacion,tomando en consideracion el parametro de entrada (p_no_certificacion).
  -- **************************************************************************************************
  PROCEDURE getCertificacion(p_no_certificacion IN CER_CERTIFICACIONES_T.No_Certificacion%TYPE,
                             p_iocursor         OUT t_cursor,
                             p_resultnumber     OUT VARCHAR2);

  --------------------------------------------------------------------------------------------
  -- FUNCTION isRncOCedulaActivo
  -- BY KERLIN DE LA CRUZ
  -- 04/02/2013
  --------------------------------------------------------------------------------------------

  FUNCTION isRncOCedulaActivo(p_rnc_o_cedula SRE_EMPLEADORES_T.rnc_o_cedula%TYPE)
    RETURN BOOLEAN;
  -- * -----------------------------------------------------------------------------------------
  -- Verificamo si el ciudadanos existe y existe en trabajadores
  -- 05/02/2013
  -- * -----------------------------------------------------------------------------------------
 /* FUNCTION isExisteCiu(p_no_doc VARCHAR2) RETURN BOOLEAN;*/

  --************************************************************************************************************--
  --CHA
  --24/01/2013
  --Hace la confirmarcion de las certificaciones
  --************************************************************************************************************--
  PROCEDURE ProcesarSolicitud(p_id_usuario    IN CER_CERTIFICACIONES_T.id_usuario%TYPE,
                              p_id_tipo       IN OUT CER_CERTIFICACIONES_T.ID_TIPO_CERTIFICACION%TYPE,
                              p_rnc_cedula    IN SRE_EMPLEADORES_T.rnc_o_cedula%TYPE,
                              p_nro_documento IN SRE_CIUDADANOS_T.NO_DOCUMENTO%TYPE,
                              p_fecha_desde  varchar2,
                              p_fecha_hasta  varchar2,
                              p_resultnumber  OUT VARCHAR2);
  --****************************************************************************************************--
  --CHA
  --24/01/2013
  --Busca todas las certificaciones filtrada por tipo, fecha_desde , fecha_hasta
  --****************************************************************************************************--
  PROCEDURE getSolitudCert(p_id_tipo          IN CER_CERTIFICACIONES_T.ID_TIPO_CERTIFICACION%TYPE,
                           p_rnc_cedula       IN SRE_EMPLEADORES_T.rnc_o_cedula%TYPE,
                           p_id_usuario       IN CER_CERTIFICACIONES_T.id_usuario%TYPE,
                           p_nro_documento    IN sre_ciudadanos_t.no_documento%type,
                           p_id_certificacion in cer_certificaciones_t.id_certificacion%type,
                           p_no_certificacion in cer_certificaciones_t.no_certificacion%type,
                           p_fecha_desde      IN varchar2,
                           p_fecha_hasta      IN varchar2,
                           p_pagenum          in number,
                           p_pagesize         in number,
                           p_io_cursor        out t_cursor,
                           p_resultnumber     OUT varchar2);

  ----------------------------------------------------------------------------------------------------------------------
  --PROCEDURE GET_INFO_GENERAL
  --BY KERLIN DE LA CRUZ
  --24/01/2013
  ----------------------------------------------------------------------------------------------------------------------

  PROCEDURE GET_INFO_GENERAL(P_RNC_O_CEDULA IN SRE_EMPLEADORES_T.RNC_O_CEDULA%TYPE,
                             P_ID_USUARIO   IN SEG_USUARIO_T.ID_USUARIO%TYPE,
                             P_IOCURSOR     IN OUT T_CURSOR,
                             P_RESULTNUMBER OUT VARCHAR2);

  -- **************************************************************************************************
  -- PROCEDIMIENTO:     Function isExisteCertificacion
  -- DESCRIPCION:       Funcion que retorna la existencia de un id_certificacion.
  --                      Recibe : el parametro p_id_certificacion.
  --                      Devuelve: un valor booleano (0,1) . 0 = no existe  1 = existe
  -- **************************************************************************************************

  FUNCTION isExisteNoCertificacion(p_no_certificacion VARCHAR2)
    RETURN BOOLEAN;

  ----------------------------------------------------------------------------------------------------------------------
  -- PROCEDURE GET_INFO_CERT
  -- BY KERLIN DE LA CRUZ
  -- 25/01/2013
  ----------------------------------------------------------------------------------------------------------------------

  PROCEDURE GET_INFO_CERT(P_RNC_O_CEDULA IN SRE_EMPLEADORES_T.RNC_O_CEDULA%TYPE,
                          P_ID_USUARIO   IN SEG_USUARIO_T.ID_USUARIO%TYPE,
                          P_IOCURSOR     IN OUT T_CURSOR,
                          P_RESULTNUMBER OUT VARCHAR2);

  ----------------------------------------------------------------------------------------------------------------------
  -- PROCEDURE GET_ID_CERTIFICACION
  -- BY KERLIN DE LA CRUZ
  -- 30/01/2013
  ----------------------------------------------------------------------------------------------------------------------

  PROCEDURE GET_ID_CERTIFICACION(P_CERTIFICACION IN varchar2,
                                 P_PIN           IN CER_CERTIFICACIONES_T.PIN%TYPE,
                                 P_IOCURSOR      IN OUT T_CURSOR,
                                 P_RESULTNUMBER  OUT VARCHAR2);

 -- ------------------------------------------------------------------------------ --
  -- Kerlin De La ruz
  -- 18/02/2013
  -- Verifica si el trabajador en cuestion trabaja o trabajo para el registro patronal en cuestion
  -- ------------------------------------------------------------------------------ --
 procedure getTrabajador(p_id_registro_patronal in sre_trabajadores_t.id_registro_patronal%type,
                          p_Nro_Documento        in sre_ciudadanos_t.no_documento%type,
                          p_resultnumber         out varchar2);

  ----------------------------------------------------------------------------------------------------------------------
  -- PROCEDURE GET_TOTAL_CERT
  -- BY KERLIN DE LA CRUZ
  -- 23/07/2013
  ----------------------------------------------------------------------------------------------------------------------

  procedure get_total_cert(p_fecha_desde            in cer_sol_certificaciones_t.fecha_solicitud%type,
                           p_fecha_hasta            in cer_sol_certificaciones_t.fecha_solicitud%type,
                           p_id_usuario             in seg_usuario_t.id_usuario%type,
                           p_rnc_cedula             in sre_empleadores_t.rnc_o_cedula%type,
                           p_pagenum                in number,
                           p_pagesize               in number,
                           p_io_cursor              out t_cursor,
                           p_resultnumber           out varchar2);

----------------------------------------------------------------------------------------------------------------------
 -- ActualizarPDF
 -- BY Mayreni Vargas
 -- 03/06/2014
 -------------------------------------------------------------------------------------------------------------
 procedure ActualizarPDF(p_pdf              IN CER_CERTIFICACIONES_T.Pdf%type,
                         p_id_certificacion IN CER_CERTIFICACIONES_T.id_certificacion%TYPE,
                         p_id_usuario       IN CER_CERTIFICACIONES_T.id_usuario%TYPE,
                         p_resultnumber     out varchar2);

PROCEDURE isExisteEmpleadorConAcuerdo(
            p_Rnc in sre_empleadores_t.rnc_o_cedula%type,
            p_resultnumber        IN OUT varchar2);


PROCEDURE CuotasPagadasAcuerdo(p_RncCedula    in sre_empleadores_t.rnc_o_cedula%type,
                                   p_iocursor     IN OUT t_cursor,
                                   p_resultnumber out varchar2);


PROCEDURE TieneAporteGeneral(p_Rnc_Cedula   in sre_empleadores_t.rnc_o_cedula%type,
                        p_fecha_desde  in sfc_facturas_t.fecha_emision%type,
                        p_fecha_hasta  in sfc_facturas_t.fecha_emision%type,
                        p_resultnumber OUT VARCHAR2);
                        
  -- **************************************************************************************************
  -- Program: GetCertificacionPorRol
  -- Description: Muestra los tipos de certificaciones Que no tiene un rol
  -- Date: 25/05/2017 
  -- By: Kerlin de la Cruz
  -- **************************************************************************************************

  PROCEDURE GetCertificacionPorRol(p_id_rol in seg_roles_t.id_role%type,
                                   p_iocursor IN OUT t_cursor,
                                   p_resultnumber OUT VARCHAR2);                        

END Cer_Certificaciones_Pkg;
