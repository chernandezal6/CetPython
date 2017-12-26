create or replace package suirplus.SEH_PENSIONADOS_PKG is

  TYPE t_cursor IS REF CURSOR ;
  v_bderror    varchar2(1000);
  v_mail_from  varchar2(250) := 'info@mail.tss2.gov.do';
  v_mail_to    varchar2(250);
  v_mail_error varchar2(250) := '_operaciones@mail.tss2.gov.do';

  PROCEDURE GetArchivosPage(P_Tipo_Archivo in SEH_ARCHIVOS_T.TIPO%TYPE,
                            P_Fecha_Desde  in   DATE,
                            P_Fecha_Hasta  in  DATE,
                            P_IdARS        in  SEH_ARCHIVOS_T.ID_ARS%TYPE,
                            p_pagenum      in number,
                            p_pagesize     in number,
                            p_resultnumber OUT varchar2,
                            p_io_cursor    in OUT t_cursor);

  PROCEDURE GETARCHIVO(P_IDARCHIVO     in  SEH_ARCHIVOS_T.ID_ARCHIVO%TYPE,
                       p_resultnumber  OUT varchar2,
                       p_io_cursor     in OUT t_cursor);

  --------------------------------------------------------------------------------------------------
  PROCEDURE GetInfoPensionado(P_CEDULA         IN  SEH_PENSIONADOS_T.NO_DOCUMENTO%TYPE,
                              P_NRO_PENSIONADO IN SEH_PENSIONADOS_T.PENSIONADO%TYPE,
                              p_resultnumber  OUT varchar2,
                              p_io_cursor    in OUT t_cursor);

  ---------------------------------------------------------------------------------------------------
  PROCEDURE getDocumentoInvalido(P_Fecha_Desde  in   DATE,
                                 P_Fecha_Hasta  in  DATE,
                                 p_idars        IN SEH_NOV_T.ID_ARS%TYPE,
                                 p_pagenum      in number,
                                 p_pagesize     in number,
                                 p_resultnumber OUT varchar2,
                                 p_io_cursor    in OUT t_cursor);

  -------------------------------------------------------------------------------------------------
  PROCEDURE getAfiliacionesPendiente(p_idars        IN SEH_NOV_T.ID_ARS%TYPE,
                                     p_pagenum      in number,
                                     p_pagesize     in number,
                                     p_resultnumber OUT varchar2,
                                     p_io_cursor    in OUT t_cursor);

  -------------------------------------------------------------------------------------------------
  procedure  AgregarDocInvalidados(p_ID_ARS         SEH_DOC_INVALIDOS_T.ID_ARS%type,
                                   p_NOMBRE         SEH_DOC_INVALIDOS_T.Nombre%type,
                                   p_CODIGO_ERROR   SEH_DOC_INVALIDOS_T.Codigo_Error%type,
                                   p_resultnumber  OUT varchar2);

  ---------------------------------------------------------------------------------------------------
 
  -------------------------------------------------------------------------------------------------------------
  -- AUTOR: YACELL BORGES
  -- FECHA: 15/5/2015
  -- NOMBRE: AgregarDocValidados
  -- OBJETIVO: Inserta informacion sobre las imagenes validadas de pensionados
  -------------------------------------------------------------------------------------------------------------
  procedure AgregarDocValidados  (p_ID_ARS        SEH_DOC_VALIDOS_T.ID_ARS%type,
                                  p_NOMBRE_IMAGEN SEH_DOC_VALIDOS_T.NOMBRE_IMAGEN%type,
                                  p_resultnumber  OUT varchar2);
  -------------------------------------------------------------------------------------------------------------

  procedure validarPensionado(p_idars         in seh_pensionados_t.id_ars%type,
                              p_nropensionado in seh_pensionados_t.pensionado%type,
                              p_resultnumber  OUT varchar2);
  ---------------------------------------------------------------------------------------------------
  procedure MarcarStatusPens(p_nropensionado  in SEH_PENSIONADOS_T.Pensionado%type,
                             p_imagen in seh_pensionados_t.documentacion%type,
                             p_resultnumber  OUT varchar2);

  --------------------------------------------------------------------------------------------------
  procedure getpensionado(p_no_documento    IN seh_pensionados_t.no_documento%type,
                          p_nro_pensionado  IN seh_pensionados_t.pensionado%type,
                          p_resultnumber    OUT varchar2,
                          p_io_cursor       IN OUT t_cursor);

  procedure getnovedadespensionado(p_nro_pensionado  IN seh_det_nov_t.id_pensionado%type,
                                   p_resultnumber    OUT varchar2,
                                   p_io_cursor       IN OUT t_cursor );

  -- --------------------------------------------------------------------------------------------------
  -- Objetivo: devuelve recordset con los archivos cargados de acuerdo a los parametros indicados
  --    Autor: Gregorio Herrera.
  --    Fecha: 05/06/2009
  -- --------------------------------------------------------------------------------------------------
  procedure get_Info_Archivo(p_id_recepcion sre_archivos_t.id_recepcion%type,
                             p_fecha_desde  sre_archivos_t.fecha_carga%type,
                             p_fecha_hasta  sre_archivos_t.fecha_carga%type,
                             p_idars        IN SEH_NOV_T.ID_ARS%TYPE,
                             p_result_number out varchar,
                             io_cursor       out t_cursor);

  -- --------------------------------------------------------------------------------------------------
  -- Objetivo: devuelve recordset con los archivos cargados de acuerdo a los parametros indicados
  --    Autor: Gregorio Herrera.
  --    Fecha: 05/06/2009
  -- --------------------------------------------------------------------------------------------------
  procedure getPage_Detalle_Archivo(p_id_recepcion sre_archivos_t.id_recepcion%type,
                                    p_pagenum  in number,
                                    p_pagesize in number,
                                    io_cursor  out t_cursor);

  ----------------------------------------------------------------------------------------
  -- Autor   : Gregorio Herrera
  -- Fecha   : 03/06/2009
  -- Objetivo: Generar el contenido del archivo de notificacion de afiliacion para las ARS
  -- -------------------------------------------------------------------------------------
  procedure generar_notificacion_alta(p_fecha in date default sysdate);

  -------------------------------------------------------------------------------------------
  -- Autor   : Gregorio Herrera
  -- Fecha   : 04/06/2009
  -- Objetivo: Generar el contenido del archivo de notificacion de afiliacion para la ARS SEH
  -- ----------------------------------------------------------------------------------------
  procedure generar_notificacion_alta_SEH(p_fecha in date default sysdate);

  ----------------------------------------------------------------------------------
  -- Autor   : Gregorio Herrera
  -- Fecha   : 04/06/2009
  -- Objetivo: Generar el contenido del archivo de notificacion de baja para las ARS
  -- -------------------------------------------------------------------------------
  procedure generar_notificacion_baja(p_fecha in date default sysdate);

  -------------------------------------------------------------------------------------
  -- Autor   : Gregorio Herrera
  -- Fecha   : 04/06/2009
  -- Objetivo: Generar el contenido del archivo de notificacion de baja para la ARS SEH
  -- ----------------------------------------------------------------------------------
  procedure generar_notificacion_baja_SEH(p_fecha in date default sysdate);

  -- --------------------------------------------------------------------------------------------------
  -- Objetivo: insertar un registro en la tabla suirplus.seh_nov_t por ARS y uno o varios registros en la
  --           tabla suirplus.seh_det_nov_t con todos los pensionados de esa ARS,
  --           basado en las validaciones realizadas.
  --    Autor: Gregorio Herrera.
  --    Fecha: 05/06/2009
  -- --------------------------------------------------------------------------------------------------
  procedure generar_movimientos_baja(p_fecha in date default sysdate);

  -- --------------------------------------------------------------------------------------------------
  -- Objetivo: genera la cartera de pensionados SEH para las ARS
  --    Autor: Gregorio Herrera.
  --    Fecha: 08/06/2009
  -- --------------------------------------------------------------------------------------------------
  procedure generar_cartera(p_fecha in date default sysdate);

  -------------------------------------------------------------------------------------
  -- Autor   : Gregorio Herrera
  -- Fecha   : 08/06/2009
  -- Objetivo: Generar el contenido del archivo de notificacion de cartera para las ARS
  -- ----------------------------------------------------------------------------------
  procedure generar_notificacion_cartera(p_fecha in date default sysdate);

  ----------------------------------------------------------------------------------------
  -- Autor   : Gregorio Herrera
  -- Fecha   : 09/06/2009
  -- Objetivo: Generar el contenido del archivo de notificacion de cartera para la ARS SEH
  -- -------------------------------------------------------------------------------------
  procedure generar_notifiacion_carteraSEH(p_fecha in date default sysdate);

  ----------------------------------------------------------------------------------------
  -- Autor   : Gregorio Herrera
  -- Fecha   : 09/06/2009
  -- Objetivo: Generar el contenido del archivo de notificacion de cartera para la ARS SEH
  --           con la estructura de SIJUPEN
  -- -------------------------------------------------------------------------------------
  procedure notifiacion_cartera_SIJUPEN(p_fecha in date default sysdate);

  -- -----------------------------------------------------------------------------------
  -- Objetivo: genera la dispersion de las ARS a partir de la cartera de pensionados SEH
  --    Autor: Gregorio Herrera.
  --    Fecha: 12/06/2009
  -- -----------------------------------------------------------------------------------
  procedure generar_dispersion(p_fecha in date default sysdate);

  --------------------------------------------------------------------------
  -- Procedure: getHistoricoPensionado
  -- Objetivo : Muestra el historico de un Pensionado
  -- Fecha    : 30/07/2009
  -- Autor    : Mayreni Vargas
  --------------------------------------------------------------------------
  procedure getHistoricoPensionado(p_idpensionado in seh_pensionados_t.pensionado%type,
                                   p_iocursor out t_cursor,
                                   p_resultNumber out varchar2);

  -- -----------------------------------------------------------------------
  -- cargar_resumen_dispersion_pensionados: resumen de dispersion
  -- Greiman_Garcia
  -- 18/11/2009
  -- -----------------------------------------------------------------------
  procedure cargar_resumen_pensionados(p_result out varchar2);

  --*********************************************************************************************---
  --CMHA
  --24/11/2010
  --RESUMEN DISPENSION PENSIONADO
  --*********************************************************************************************---
  procedure getResumePensionado(p_periodo      in  seh_resumen_pensionados_t.periodo_cartera%type,
                                p_iocursor out t_cursor,
                                p_resultnumber out varchar2);

  ---************************************************************************************--
  -- prog = getPeriodosDispersion
  -- by charile peña
  -- trae una lista de los distintos periodos que existen en dispersion.
  ---************************************************************************************--
  procedure getPeriodosDispPensionado(p_iocursor     in out t_cursor,
                                      p_resultnumber out Varchar2);

 -- -------------------------------------------------------------------------
  -- generar_notificacion_traslados: informe de pensionados pendientes por ARS
  -- Gregorio Herrera
  -- 04/08/2011
  -- -------------------------------------------------------------------------
  procedure generar_notificacion_traspasos(p_fecha in date default trunc(sysdate - 1));

end SEH_PENSIONADOS_PKG;