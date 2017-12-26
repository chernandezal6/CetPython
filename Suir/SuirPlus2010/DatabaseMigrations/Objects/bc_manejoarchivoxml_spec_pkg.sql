CREATE OR REPLACE PACKAGE SUIRPLUS.bc_manejoarchivoxml_pkg is
TYPE t_cursor IS REF cursor;

procedure getMailAddress(p_listok out sfc_procesos_t.lista_ok%type,
                         p_listerror out sfc_procesos_t.lista_error%type);


procedure addarchivolog(p_nombrearchivo in bc_log_archivo_t.nombrearchivo%type,
                        p_tipo_archivo in varchar2,
                        p_sec out bc_log_archivo_t.secuencia_log%type,
                        p_result out bc_archivo_msg_t.descripcion%type);

procedure set_archive_status(p_operacion in varchar2,
                             p_error_id in bc_log_archivo_t.mensaje_id%type,
                             p_sec in bc_log_archivo_t.secuencia_log%type,
                             p_nombre_archivo bc_log_archivo_t.nombrearchivo%type,
                             p_error_ap in bc_log_archivo_t.erroraplicacion%type default null,
                             p_error_db in bc_log_archivo_t.errordb%type default null);

procedure get_llaves_XML (
  p_id_parametro               SFC_DET_PARAMETRO_T.id_parametro%TYPE,
  p_llave out                SFC_DET_PARAMETRO_T.valor_texto%type
);
procedure RunCmd(p_cmd in varchar2, p_result out number);


procedure getNombreEntidad(p_id_entidad in sfc_entidad_recaudadora_t.id_entidad_recaudadora%type,
                             p_entidadnombre out sfc_entidad_recaudadora_t.entidad_recaudadora_des%type,
                             p_result out varchar2);

procedure getDesProceso(p_trn in bc_cod_trn_t.codigo%type,
                          p_desproceso out bc_cod_trn_t.proceso%type,
                          p_result out varchar2);

procedure getEntidadNombrePorBic(p_bic in sfc_entidad_recaudadora_t.cod_bic_swift%type,
                                   p_entidadnombre out sfc_entidad_recaudadora_t.entidad_recaudadora_des%type,
                                   p_result out varchar2);
function getProceso(p_trn in bc_cod_trn_t.codigo%type)
 return bc_cod_trn_t.proceso%type;

procedure ManejoExcepciones(p_exceptiontype varchar2,
                            p_secuencia bc_encabezado_t.secuencia%type,
                            p_error_db varchar2 default null);

procedure getArchivos(p_tipo_archivo      in varchar2,
                                    p_fecha_ini          in bc_log_archivo_t.fechaadd%type,
                                    p_fecha_fin         in  bc_log_archivo_t.fechaadd%type,
                                    p_pagenum            in number,
                                    p_pagesize            in number,
                                    p_resultnumber      out varchar2,
                                    p_io_cursor           in out t_cursor);

procedure getArchivoEncConcentracion(p_nombre_archivo in bc_co_encabezado_t.nombrearchivo%type,
                                                             p_io_cursor            in out t_cursor,
                                                             p_result                 out varchar2);
procedure getArchvioDetConcentracion(p_nombre_archivo in bc_co_encabezado_t.nombrearchivo%type,
                                                             p_io_cursor          in out t_cursor,
                                                             p_result                out varchar2);

procedure getArchivoDetLiquidacion(p_nombre_archivo in bc_encabezado_t.nombrearchivo%type,
                                                         p_io_cursor          in out t_cursor,
                                                         p_result            out varchar2);
procedure getArchivoEncLiquidacion(p_nombre_archivo in bc_encabezado_t.nombrearchivo%type,
                                                         p_io_cursor          in out t_cursor,
                                                         p_result                out varchar2);


Procedure ActualizarVista(p_id_error in varchar2);

function IsArchivoValido(p_archivo in bc_encabezado_t.nombrearchivo%type,
                         p_cod_bic_swith_cr in bc_encabezado_t.codigobicentidadcr%type,
                         p_cod_bic_swith_db in bc_encabezado_t.codigobicentidaddb%type,
                         p_trnopcrlbtr in bc_encabezado_t.trnopcrlbtr%type)
return boolean;

procedure Reenviar_Email(p_fecha in date);

Procedure Enviar_ZIP_XLS(p_fecha in date);

Procedure ProcesarDB(p_fecha in Date, p_result Out varchar2);

end bc_manejoarchivoxml_pkg;