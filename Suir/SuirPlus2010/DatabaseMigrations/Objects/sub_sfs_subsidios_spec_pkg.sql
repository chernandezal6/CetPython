create or replace package SUIRPLUS.SUB_SFS_SUBSIDIOS is

  -- Author  : MAYRENI_VARGAS
  -- Created : 10/14/2010 10:45:55 AM
  -- Purpose :

  -- Public type declarations
  type t_cursor is ref cursor;
  PROCEDURE ObtenerDatosLactante(p_id_nss        SRE_CIUDADANOS_T.id_nss%TYPE,
                                 P_IOCURSOR      OUT T_CURSOR,
                                 p_result_number OUT VARCHAR2);
  procedure getPss(p_razon        in sfs_prestadoras_t.prestadora_nombre%TYPE,
                   p_resultnumber OUT varchar2,
                   p_io_cursor    IN OUT T_CURSOR);
  procedure getPssList(p_prestadora_nombre IN sfs_prestadoras_t.prestadora_nombre%type,
                       p_iocursor          OUT t_cursor);

  procedure getNSS(P_NroDocumento IN SRE_CIUDADANOS_T.NO_DOCUMENTO%TYPE,
                   P_NSS          OUT SRE_CIUDADANOS_T.ID_NSS%TYPE);

  Function getFechaInicioEnf Return Date;

  -- ******************************************************************************************************
  -- PROCEDIMIENTO:     cargarImagen
  -- DESCRIPTION:       para subir una imagen a un formulario existente
  -- AUTOR:             charlie Pena
  -- Fecha:             25/01/2011
  -- ******************************************************************************************************
  PROCEDURE cargarImagen(p_nro_solicitud  in sub_solicitud_t.nro_solicitud%type,
                         p_imagen         in sub_solicitud_t.imagen%type,
                         p_nombre_archivo in sub_solicitud_t.nombre_archivo%type,
                         p_resultnumber   OUT VARCHAR2);

  -- ******************************************************************************************************
  -- PROCEDIMIENTO:     getSubsidiosSFS
  -- DESCRIPTION:       Trae un listado de solicitudes para un empleador
  -- AUTOR:             charlie Pena
  -- Fecha:             11/Feb/2011
  -- ******************************************************************************************************
  PROCEDURE getSubsidiosSFS(p_rnc          in sre_empleadores_t.rnc_o_cedula %type,
                            p_cedula       in sre_ciudadanos_t.no_documento%type,
                            p_Status       in sub_sfs_maternidad_t.id_estatus%type,
                            p_tipo         in sub_solicitud_t.tipo_subsidio%type,
                            p_fechaDesde   in sub_solicitud_t.fecha_registro%type,
                            p_fechaHasta   in sub_solicitud_t.fecha_registro%type,
                            p_pagenum      in number,
                            p_pagesize     in number,
                            p_iocursor     IN OUT t_cursor,
                            p_resultnumber OUT VARCHAR2);
  -- ******************************************************************************************************
  -- PROCEDIMIENTO:     getDetSubsidiosSFS_M
  -- DESCRIPTION:       Trae el detalle de una solicitud de subsidio de maternidad para un empleador
  -- AUTOR:             charlie Pena
  -- Fecha:             16/Feb/2011
  -- ******************************************************************************************************
  PROCEDURE getDetSubsidiosSFS_M(p_nro_solicitud in sub_solicitud_t.nro_solicitud%type,
                                 p_regPatronal   in sre_empleadores_t.rnc_o_cedula %type,
                                 p_iocursor      IN OUT t_cursor,
                                 p_resultnumber  OUT VARCHAR2);

  -- ******************************************************************************************************
  -- PROCEDIMIENTO:     getDetSubsidiosSFS_L
  -- DESCRIPTION:       Trae el detalle de una solicitud de subsidio de lactancia para un empleador
  -- AUTOR:             charlie Pena
  -- Fecha:             16/Feb/2011
  -- ******************************************************************************************************
  PROCEDURE getDetSubsidiosSFS_L(p_nro_solicitud in sub_solicitud_t.nro_solicitud%type,
                                 p_regPatronal   in sre_empleadores_t.rnc_o_cedula %type,
                                 p_iocursor      IN OUT t_cursor,
                                 p_resultnumber  OUT VARCHAR2);

  -- ******************************************************************************************************
  -- PROCEDIMIENTO:     getDetSubsidiosSFS_E
  -- DESCRIPTION:       Trae el detalle de una solicitud de subsidio de Enfermedad Comun para un empleador
  -- AUTOR:             charlie Pena
  -- Fecha:             16/Feb/2011
  -- ******************************************************************************************************
  PROCEDURE getDetSubsidiosSFS_E(p_nro_solicitud in sub_solicitud_t.nro_solicitud%type,
                                 p_regPatronal   in sre_empleadores_t.rnc_o_cedula %type,
                                 p_iocursor      IN OUT t_cursor,
                                 p_resultnumber  OUT VARCHAR2);

  -- ******************************************************************************************************
  -- PROCEDIMIENTO:     getCuotasSubsidios
  -- DESCRIPTION:       Trae las cuotas asociadas a un subsidio
  -- AUTOR:             charlie Pena
  -- Fecha:             1/Mar/2011
  -- ******************************************************************************************************
  PROCEDURE getCuotasSubsidios(p_nro_solicitud in sub_solicitud_t.nro_solicitud%type,
                               p_regPatronal   in sre_empleadores_t.rnc_o_cedula %type,
                               p_tipo_Subsidio in sub_solicitud_t.tipo_subsidio%type,
                               p_iocursor      IN OUT t_cursor,
                               p_resultnumber  OUT VARCHAR2);
  -- ******************************************************************************************************
  -- PROCEDIMIENTO:     getImagenSubSFS
  -- DESCRIPTION:       Devuelve la imagen.
  -- AUTOR:             charlie Pena
  -- FECHA:             15-02-2011
  -- ******************************************************************************************************
  procedure getImagenSubSFS(p_nro_solicitud in sub_solicitud_t.nro_solicitud%type,
                            p_iocursor      IN OUT t_cursor,
                            p_resultnumber  OUT VARCHAR2);

  -- ******************************************************************************************************
  -- PROCEDIMIENTO:     getEstatusSubSFS
  -- DESCRIPTION:       Devuelve la lista de estatus para los subsidios SFS.
  -- AUTOR:             charlie Pena
  -- FECHA:             15-02-2011
  -- ******************************************************************************************************
  PROCEDURE getEstatusSubSFS(p_iocursor     IN OUT t_cursor,
                             p_resultnumber OUT VARCHAR2);

  -- ******************************************************************************************************
  -- PROCEDIMIENTO:     existeSolicitud
  -- DESCRIPTION:       Devuelve "true" si la solicitud existe, "false" si la solicitud no existe.
  -- AUTOR:             charlie Pena
  -- FECHA:             15-02-2011
  -- ******************************************************************************************************
  function existeSolicitud(p_nroSolicitud in number) return boolean;

  procedure getNominaDiscapacitados(p_idnss              in sre_trabajadores_t.id_nss%type,
                                    p_idRegistroPatronal in sre_trabajadores_t.id_registro_patronal%type,
                                    p_resultnumber       OUT varchar2,
                                    p_io_cursor          OUT t_cursor);

  -- ******************************************************************************************************
  -- PROCEDIMIENTO:     ObtenerDatosIniciales
  -- DESCRIPTION:       Devuelve los datos iniciales de un subsidio de enfermedad comun
  -- AUTOR:             Gregroio Herrera
  -- FECHA:             21-02-2011
  -- ******************************************************************************************************
  procedure ObtenerDatosIniciales(p_nro_solicitud IN sub_solicitud_t.nro_solicitud%TYPE,
                                  p_resultnumber  OUT varchar2,
                                  p_io_cursor     OUT t_cursor);

  --***************************************************************************************
  PROCEDURE GetReImpresionEnfComun(P_CEDULA       IN SRE_CIUDADANOS_T.NO_DOCUMENTO%type,
                                   P_PIN          IN SFS_ENFERMEDAD_COMUN_T.PIN%TYPE,
                                   p_io_cursor    OUT T_CURSOR,
                                   P_RESULTNUMBER OUT VARCHAR2);

  --***************************************************************************************
  PROCEDURE GetReImpresionMaternidad(P_CEDULA       IN SUIRPLUS.SRE_CIUDADANOS_T.NO_DOCUMENTO%type,
                                     P_PIN          IN SUIRPLUS.SUB_SOLICITUD_T.NRO_SOLICITUD%TYPE,
                                     p_io_cursor    OUT T_CURSOR,
                                     P_RESULTNUMBER OUT VARCHAR2);

/*
-- ===================================================
-- Para traer las cuotas de las subsidios pendientes
-- Gregorio Herrera
-- 03/nov/2011
-- ===================================================
*/
PROCEDURE GetDetSubsidioEmpresa (
               P_NroSolicitud     in varchar2,
               P_RegistroPatronal IN SUB_SFS_ENF_COMUN_T.id_registro_patronal%type,
               p_io_cursor        OUT sys_refcursor,
               p_resultnumber     OUT VARCHAR2);

  -- ******************************************************************************************************
  -- PROCEDIMIENTO:     GetPagosSubsidiosSFS
  -- DESCRIPTION:       Trae el reporte de los pagos de los subsidios del SFS realizados por un registro patronal.
  -- AUTOR:             Yacell Borges
  -- FECHA:             9-4-2012
  -- ******************************************************************************************************

PROCEDURE GetPagosSubsidiosSFS(P_RegistroPatronal IN sub_cuotas_t.id_registro_patronal%type,
                                                  p_cedula in Sre_Ciudadanos_t.No_Documento%type,
                                                  p_tiposubsidio in sub_solicitud_t.tipo_subsidio%type,
                                                  p_fechadesde in sub_solicitud_t.fecha_registro%type,
                                                  p_fechahasta in sub_solicitud_t.fecha_registro%type,
                                                  p_fechapagodesde in sub_cuotas_t.fecha_pago%type,
                                                  p_fechapagohasta in sub_cuotas_t.fecha_pago%type,
                                                  p_pagenum  in number,
                                                  p_pagesize in number,
                                                  p_io_cursor        OUT T_CURSOR,
                                                  p_resultnumber     OUT VARCHAR2);



 -- ******************************************************************************************************
 -- PROCEDIMIENTO:     getCuotasSubsidios
 -- DESCRIPTION:       Trae las cuotas asociadas a un subsidio
 -- AUTOR:             Mayreni Vargas
 -- Fecha:             1/Jun/2013
 -- ******************************************************************************************************
PROCEDURE getCuotasSubsidios(p_fechaDesde   in sub_solicitud_t.fecha_registro%type,
                             p_fechaHasta   in sub_solicitud_t.fecha_registro%type,
                             p_tipoempresa  in sre_empleadores_t.tipo_empresa%type,
                             p_pagenum      in number,
                             p_pagesize     in number,
                             p_iocursor     IN OUT t_cursor,
                             p_resultnumber OUT VARCHAR2);

end SUB_SFS_SUBSIDIOS;