CREATE OR REPLACE PACKAGE SUIRPLUS.SUB_SFS_NOVEDADES is

  -- Author  : MAYRENI_VARGAS
  -- Created : 10/14/2010 10:44:07 AM
  -- Purpose :

  -- Public type declarations
  type t_cursor is ref cursor;
  --type t_lactante is table of SUIRPLUS.type_lactantes;
  type t_lactante is table of sub_lactantes_t%rowtype index by binary_integer;

  ----------------------------------------------------------------------------------------
  --- Metodo que devuelve las opciones del menu que el empleador puede acceder
  ----------------------------------------------------------------------------------------
  procedure getOpcionesMenu(p_idnss              sre_ciudadanos_t.id_nss%type,
                            p_idregistropatronal sre_empleadores_t.id_registro_patronal%type,
                            p_resultnumber       out varchar2,
                            p_iocursor           IN OUT t_cursor);

  ----------------------------------------------------------------------------------------
  --- Metodo que devuelve las opciones del menu que el empleador puede acceder para E. C.
  ----------------------------------------------------------------------------------------
  procedure getOpcionesMenuEC(p_idnss              sre_ciudadanos_t.id_nss%type,
                              p_idregistropatronal sre_empleadores_t.id_registro_patronal%type,
                              p_resultnumber       out varchar2,
                              p_iocursor           IN OUT t_cursor);

  /*  ----------------------------------------------------------------------------------------
    --- Metodo crea la solicitud
    ----------------------------------------------------------------------------------------
    PROCEDURE crearSolicitud(p_NSS               IN SUB_SOLICITUD_T.NSS%type,
                             p_PADECIMIENTO      IN SUB_SOLICITUD_T.PADECIMIENTO%type,
                             p_CATEGORIA_SALARIO IN SUB_SOLICITUD_T.CATEGORIA_SALARIO%type,
                             p_TIPO_SUBSIDIO     IN SUB_SOLICITUD_T.TIPO_SUBSIDIO%type,
                             p_TIPO_SOLICITUD    IN SUB_SOLICITUD_T.TIPO_SOLICITUD%type,
                             p_ID_NOMINA         IN SUB_SOLICITUD_T.ID_NOMINA%type,
                             p_NRO_SOLICITUD_MAT IN SUB_SOLICITUD_T.NRO_SOLICITUD%type,
                             p_NRO_SOLICITUD     OUT SUB_SOLICITUD_T.NRO_SOLICITUD%type,
                             p_RESULTNUMBER      OUT VARCHAR2);
  */
  ----------------------------------------------------------------------------------------
  --- Metodo crea el embarazo
  ----------------------------------------------------------------------------------------
  PROCEDURE crearEmbarazo(p_NSS                     IN SUB_SOLICITUD_T.NSS%type,
                          p_TELEFONO                IN SUB_MATERNIDAD_T.TELEFONO%type,
                          p_CELULAR                 IN SUB_MATERNIDAD_T.CELULAR%type,
                          p_EMAIL                   IN SUB_MATERNIDAD_T.EMAIL%type,
                          p_FECHA_DIAGNOSTICO       IN SUB_MATERNIDAD_T.FECHA_DIAGNOSTICO%type,
                          p_FECHA_ESTIMADA_PARTO    IN SUB_MATERNIDAD_T.FECHA_ESTIMADA_PARTO%type,
                          p_NSS_TUTOR               IN SUB_MATERNIDAD_T.NSS_TUTOR%type,
                          p_TELEFONO_TUTOR          IN SUB_MATERNIDAD_T.TELEFONO_TUTOR%type,
                          p_EMAIL_TUTOR             IN SUB_MATERNIDAD_T.EMAIL_TUTOR%type,
                          p_ULT_USUARIO_ACT         IN SUB_MATERNIDAD_T.ULT_USUARIO_ACT%type,
                          p_ID_REGISTRO_PATRONAL_RE IN SUB_MATERNIDAD_T.ID_REGISTRO_PATRONAL_RE%type,
                          p_esRetroativa            in varchar2,
                          P_NROFORMULARIO           OUT VARCHAR2,
                          P_NRO_SOLICITUD           OUT SUB_SOLICITUD_T.NRO_SOLICITUD%type,
                          p_RESULTNUMBER            OUT VARCHAR2);

  ----------------------------------------------------------------------------------------
  --- Metodo elimina una solicitud
  ----------------------------------------------------------------------------------------
  /*  PROCEDURE eliminarSolicitud(p_NRO_SOLICITUD IN SUB_SOLICITUD_T.NRO_SOLICITUD%type,
                                p_RESULTNUMBER  OUT VARCHAR2);
  */
  ----------------------------------------------------------------------------------------
  --- Metodo que crea una licencia
  ----------------------------------------------------------------------------------------
  PROCEDURE crearLicencia(p_ID_NSS               IN SUB_SOLICITUD_T.NSS%type,
                          p_FECHA_LICENCIA       IN SUB_SFS_MATERNIDAD_T.FECHA_LICENCIA%type,
                          p_ID_REGISTRO_PATRONAL IN SUB_SFS_MATERNIDAD_T.ID_REGISTRO_PATRONAL%type,
                          p_USUARIO_REGISTRO     IN SUB_SFS_MATERNIDAD_T.USUARIO_REGISTRO%type,
                          p_TIPO_LICENCIA        IN SUB_SFS_MATERNIDAD_T.TIPO_LICENCIA%type,
                          p_TIPO_FORMULARIO      IN SUB_FORMULARIOS_T.TIPO_FORMULARIO%type,
                          p_NRO_FORMULARIO       IN SUB_FORMULARIOS_T.NRO_FORMULARIO%type,
                          p_ID_PSS_MED           IN SUB_FORMULARIOS_T.ID_PSS_MED%type,
                          p_NO_DOCUMENTO_MED     IN SUB_FORMULARIOS_T.NO_DOCUMENTO_MED%type,
                          p_NOMBRE_MED           IN SUB_FORMULARIOS_T.NOMBRE_MED%type,
                          p_DIRECCION_MED        IN SUB_FORMULARIOS_T.DIRECCION_MED%type,
                          p_TELEFONO_MED         IN SUB_FORMULARIOS_T.TELEFONO_MED%type,
                          p_CELULAR_MED          IN SUB_FORMULARIOS_T.CELULAR_MED%type,
                          p_EMAIL_MED            IN SUB_FORMULARIOS_T.EMAIL_MED%type,
                          p_ID_PSS_CEN           IN SUB_FORMULARIOS_T.ID_PSS_CEN%type,
                          p_NOMBRE_CEN           IN SUB_FORMULARIOS_T.NOMBRE_CEN%type,
                          p_DIRECCION_CEN        IN SUB_FORMULARIOS_T.DIRECCION_CEN%type,
                          p_TELEFONO_CEN         IN SUB_FORMULARIOS_T.TELEFONO_CEN%type,
                          p_FAX_CEN              IN SUB_FORMULARIOS_T.FAX_CEN%type,
                          p_EMAIL_CEN            IN SUB_FORMULARIOS_T.EMAIL_CEN%type,
                          p_EXEQUATUR            IN SUB_FORMULARIOS_T.EXEQUATUR%type,
                          p_ULT_USUARIO_ACT      IN SUB_FORMULARIOS_T.ULT_USUARIO_ACT%type,
                          p_DIAGNOSTICO          IN SUB_FORMULARIOS_T.DIAGNOSTICO%type,
                          p_SIGNOS_SINTOMAS      IN SUB_FORMULARIOS_T.SIGNOS_SINTOMAS%type,
                          p_PROCEDIMIENTOS       IN SUB_FORMULARIOS_T.PROCEDIMIENTOS%type,
                          p_FECHA_DIAGNOSTICO    IN SUB_FORMULARIOS_T.FECHA_DIAGNOSTICO%type,
                          p_esRetroativa         in varchar2,
                          p_NRO_SOLICITUD        IN SUB_SOLICITUD_T.NRO_SOLICITUD%type,
                          p_MODO                 IN VARCHAR2,
                          p_RESULTNUMBER         OUT VARCHAR2);

  ----------------------------------------------------------------------------------------
  --- Metodo que crea un formulario
  ----------------------------------------------------------------------------------------
  PROCEDURE crearFormulario(p_NRO_SOLICITUD     IN SUB_FORMULARIOS_T.NRO_SOLICITUD%type,
                            p_TIPO_FORMULARIO   IN SUB_FORMULARIOS_T.TIPO_FORMULARIO%type,
                            p_NRO_FORMULARIO    IN SUB_FORMULARIOS_T.NRO_FORMULARIO%type,
                            p_ID_PSS_MED        IN SUB_FORMULARIOS_T.ID_PSS_MED%type,
                            p_NO_DOCUMENTO_MED  IN SUB_FORMULARIOS_T.NO_DOCUMENTO_MED%type,
                            p_NOMBRE_MED        IN SUB_FORMULARIOS_T.NOMBRE_MED%type,
                            p_DIRECCION_MED     IN SUB_FORMULARIOS_T.DIRECCION_MED%type,
                            p_TELEFONO_MED      IN SUB_FORMULARIOS_T.TELEFONO_MED%type,
                            p_CELULAR_MED       IN SUB_FORMULARIOS_T.CELULAR_MED%type,
                            p_EMAIL_MED         IN SUB_FORMULARIOS_T.EMAIL_MED%type,
                            p_ID_PSS_CEN        IN SUB_FORMULARIOS_T.ID_PSS_CEN%type,
                            p_NOMBRE_CEN        IN SUB_FORMULARIOS_T.NOMBRE_CEN%type,
                            p_DIRECCION_CEN     IN SUB_FORMULARIOS_T.DIRECCION_CEN%type,
                            p_TELEFONO_CEN      IN SUB_FORMULARIOS_T.TELEFONO_CEN%type,
                            p_FAX_CEN           IN SUB_FORMULARIOS_T.FAX_CEN%type,
                            p_EMAIL_CEN         IN SUB_FORMULARIOS_T.EMAIL_CEN%type,
                            p_EXEQUATUR         IN SUB_FORMULARIOS_T.EXEQUATUR%type,
                            p_ULT_USUARIO_ACT   IN SUB_FORMULARIOS_T.ULT_USUARIO_ACT%type,
                            p_DIAGNOSTICO       IN SUB_FORMULARIOS_T.DIAGNOSTICO%type,
                            p_SIGNOS_SINTOMAS   IN SUB_FORMULARIOS_T.SIGNOS_SINTOMAS%type,
                            p_PROCEDIMIENTOS    IN SUB_FORMULARIOS_T.PROCEDIMIENTOS%type,
                            p_FECHA_DIAGNOSTICO IN SUB_FORMULARIOS_T.FECHA_DIAGNOSTICO%type,
                            p_RESULTNUMBER      OUT VARCHAR2);

  ----------------------------------------------------------------------------------------
  --- Metodo que crea el lactante
  ----------------------------------------------------------------------------------------
  PROCEDURE crearLactantes(p_ID_NSS_LACTANTE         IN SUB_LACTANTES_T.ID_NSS_LACTANTE%type,
                           p_NUI                     IN SUB_LACTANTES_T.NUI%type,
                           p_NOMBRES                 IN SUB_LACTANTES_T.NOMBRES%type,
                           p_PRIMER_APELLIDO         IN SUB_LACTANTES_T.PRIMER_APELLIDO%type,
                           p_SEGUNDO_APELLIDO        IN SUB_LACTANTES_T.SEGUNDO_APELLIDO%type,
                           p_SEXO                    IN SUB_LACTANTES_T.SEXO%type,
                           p_ULT_USUARIO_ACT         IN SUB_LACTANTES_T.ULT_USUARIO_ACT%type,
                           p_ID_REGISTRO_PATRONAL_NC IN SUB_LACTANTES_T.ID_REGISTRO_PATRONAL_NC%type,
                           p_esRetroativa            in varchar2,
                           p_nro_solicitud           IN sub_solicitud_t.nro_solicitud%type,
                           p_Modo                    In Varchar2,
                           p_RESULTNUMBER            OUT VARCHAR2);

  ----------------------------------------------------------------------------------------
  --- Metodo que el numero del formulario
  ----------------------------------------------------------------------------------------
  procedure getNumeroFormulario(p_id_nss               sub_solicitud_t.nss%type,
                                p_id_registro_patronal sub_maternidad_t.id_registro_patronal_re%type,
                                p_tipo                 sub_solicitud_t.tipo_subsidio%type,
                                p_nroformulario        out varchar2,
                                p_resultnumber         out varchar2);

  ----------------------------------------------------------------------------------------
  --- Metodo que crea el nacimiento
  ----------------------------------------------------------------------------------------
  PROCEDURE crearNacimiento(p_ID_NSS               in sub_solicitud_t.nss%type,
                            p_ID_REGISTRO_PATRONAL IN SUB_SFS_MATERNIDAD_T.ID_REGISTRO_PATRONAL%type,
                            p_cant_lactantes       in sub_sfs_lactancia_t.cant_lactantes%type,
                            p_fecha_nacimiento     in sub_sfs_lactancia_t.fecha_nacimiento%type,
                            p_esRetroativa         in varchar2,
                            P_NRO_SOLICITUD_MAT    IN SUB_SOLICITUD_T.NRO_SOLICITUD%TYPE,
                            P_NRO_SOLICITUD        IN OUT sub_solicitud_t.nro_solicitud%type,
                            p_Modo                 In Varchar2,
                            p_RESULTNUMBER         OUT VARCHAR2);

  ----------------------------------------------------------------------------------------
  --- Metodo que crea un reporte de muerte madre
  ----------------------------------------------------------------------------------------
  PROCEDURE crearMuerteMadre(p_ID_NSS               IN SUB_SOLICITUD_T.NSS%type,
                             p_ID_REGISTRO_PATRONAL IN sub_maternidad_t.id_registro_patronal_mm%type,
                             p_FECHA_MUERTE         in sub_maternidad_t.fecha_defuncion_madre%type,
                             p_ULT_USUARIO_ACT      IN sub_maternidad_t.ult_usuario_act%type,
                             p_esRetroativa         in varchar2,
                             p_RESULTNUMBER         OUT VARCHAR2);

  ----------------------------------------------------------------------------------------
  --- Metodo que crea la fecha perdida de embarazo
  ----------------------------------------------------------------------------------------
  PROCEDURE crearPerdidaEmbarazo(p_ID_REGISTRO_PATRONAL IN sub_maternidad_t.id_registro_patronal_pe%type,
                                 p_FECHA_PERDIDA        in sub_maternidad_t.fecha_perdida%type,
                                 p_ULT_USUARIO_ACT      IN sub_maternidad_t.ult_usuario_act%type,
                                 p_esRetroativa         in varchar2,
                                 p_NRO_SOLICITUD        IN SUB_SOLICITUD_T.NRO_SOLICITUD%type,
                                 p_RESULTNUMBER         OUT VARCHAR2);

  ----------------------------------------------------------------------------------------
  --- Metodo que crea la muerte del lactante
  ----------------------------------------------------------------------------------------
  Procedure crearMuerteLactante(p_ID_NSS                IN SUB_SOLICITUD_T.NSS%type,
                                p_ID_REGISTRO_PATRONAL  IN SUB_LACTANTES_T.ID_REGISTRO_PATRONAL_ML%type,
                                p_ID_LACTANTE           IN SUB_LACTANTES_T.ID_LACTANTE%type,
                                p_FECHA_MUERTE_LACTANTE IN SUB_LACTANTES_T.FECHA_REGISTRO_ML%type,
                                p_ULT_USUARIO_ACT       IN SUB_LACTANTES_T.ULT_USUARIO_ACT%type,
                                p_RESULTNUMBER          OUT VARCHAR2);

  ----------------------------------------------------------------------------------------
  --- Metodo para llamar todos los que crea los registros
  ----------------------------------------------------------------------------------------
  Procedure Registro_Embarazo_Rectroactivo(
                                           -- Parametros para registrar el Embarazo
                                           p_ID_NSS               IN SUB_SOLICITUD_T.NSS%type,
                                           p_TELEFONO             IN SUB_MATERNIDAD_T.TELEFONO%type,
                                           p_CELULAR              IN SUB_MATERNIDAD_T.CELULAR%type,
                                           p_EMAIL                IN SUB_MATERNIDAD_T.EMAIL%type,
                                           p_FECHA_DIAGNOSTICO    IN SUB_MATERNIDAD_T.FECHA_DIAGNOSTICO%type,
                                           p_FECHA_ESTIMADA_PARTO IN SUB_MATERNIDAD_T.FECHA_ESTIMADA_PARTO%type,
                                           p_NSS_TUTOR            IN SUB_MATERNIDAD_T.NSS_TUTOR%type,
                                           p_TELEFONO_TUTOR       IN SUB_MATERNIDAD_T.TELEFONO_TUTOR%type,
                                           p_EMAIL_TUTOR          IN SUB_MATERNIDAD_T.EMAIL_TUTOR%type,
                                           p_ULT_USUARIO_ACT      IN SUB_MATERNIDAD_T.ULT_USUARIO_ACT%type,
                                           p_ID_REGISTRO_PATRONAL IN SUB_MATERNIDAD_T.ID_REGISTRO_PATRONAL_RE%type,
                                           p_esRetroativa         IN VARCHAR2,
                                           -- Parametro para registrar la licencia
                                           p_FECHA_LICENCIA        IN SUB_SFS_MATERNIDAD_T.FECHA_LICENCIA%type,
                                           p_TIPO_LICENCIA         IN SUB_SFS_MATERNIDAD_T.TIPO_LICENCIA%type,
                                           p_TIPO_FORMULARIO       IN SUB_FORMULARIOS_T.TIPO_FORMULARIO%type,
                                           p_ID_PSS_MED            IN SUB_FORMULARIOS_T.ID_PSS_MED%type,
                                           p_NO_DOCUMENTO_MED      IN SUB_FORMULARIOS_T.NO_DOCUMENTO_MED%type,
                                           p_NOMBRE_MED            IN SUB_FORMULARIOS_T.NOMBRE_MED%type,
                                           p_DIRECCION_MED         IN SUB_FORMULARIOS_T.DIRECCION_MED%type,
                                           p_TELEFONO_MED          IN SUB_FORMULARIOS_T.TELEFONO_MED%type,
                                           p_CELULAR_MED           IN SUB_FORMULARIOS_T.CELULAR_MED%type,
                                           p_EMAIL_MED             IN SUB_FORMULARIOS_T.EMAIL_MED%type,
                                           p_ID_PSS_CEN            IN SUB_FORMULARIOS_T.ID_PSS_CEN%type,
                                           p_NOMBRE_CEN            IN SUB_FORMULARIOS_T.NOMBRE_CEN%type,
                                           p_DIRECCION_CEN         IN SUB_FORMULARIOS_T.DIRECCION_CEN%type,
                                           p_TELEFONO_CEN          IN SUB_FORMULARIOS_T.TELEFONO_CEN%type,
                                           p_FAX_CEN               IN SUB_FORMULARIOS_T.FAX_CEN%type,
                                           p_EMAIL_CEN             IN SUB_FORMULARIOS_T.EMAIL_CEN%type,
                                           p_EXEQUATUR             IN SUB_FORMULARIOS_T.EXEQUATUR%type,
                                           p_DIAGNOSTICO           IN SUB_FORMULARIOS_T.DIAGNOSTICO%type,
                                           p_SIGNOS_SINTOMAS       IN SUB_FORMULARIOS_T.SIGNOS_SINTOMAS%type,
                                           p_PROCEDIMIENTOS        IN SUB_FORMULARIOS_T.PROCEDIMIENTOS%type,
                                           p_FECHA_DIAGNOSTICO_LIC IN SUB_FORMULARIOS_T.FECHA_DIAGNOSTICO%type,
                                           -- Parametros para el nacimiento
                                           p_cant_lactantes   IN sub_sfs_lactancia_t.cant_lactantes%type,
                                           p_fecha_nacimiento IN sub_sfs_lactancia_t.fecha_nacimiento%type,
                                           -- Parametro para los lactantes
                                           p_DATOS_LACTANTES IN VARCHAR2,
                                           -- Parametro para la muerte de la madre
                                           p_FECHA_MUERTE IN sub_maternidad_t.fecha_defuncion_madre%type,
                                           -- Parametro para la perdida del embarazo
                                           p_FECHA_PERDIDA IN sub_maternidad_t.fecha_perdida%type,
                                           -- Numero de solicitud creado
                                           P_NRO_SOLICITUD IN OUT SUB_SOLICITUD_T.NRO_SOLICITUD%type,
                                           -- Parametro para indicar si es una reconsideracion o no
                                           P_MODO IN VARCHAR2,
                                           -- Parametro para retener el resultado de la corrida
                                           p_RESULTNUMBER OUT VARCHAR2);

  -----------------------------------------------------------------------------------------------
  --- Metodo para llamar todos los metodos que intevienen en la cracion de la licencia POST-NATAL
  -----------------------------------------------------------------------------------------------
  Procedure Registro_Licencia_Post_Natal(
                                         -- Parametros para registrar el Embarazo
                                         p_ID_NSS               IN SUB_SOLICITUD_T.NSS%type,
                                         p_ULT_USUARIO_ACT      IN SUB_SFS_MATERNIDAD_T.USUARIO_REGISTRO%type,
                                         p_ID_REGISTRO_PATRONAL IN SUB_SFS_MATERNIDAD_T.ID_REGISTRO_PATRONAL%type,
                                         -- Parametro para registrar la licencia
                                         p_FECHA_LICENCIA        IN SUB_SFS_MATERNIDAD_T.FECHA_LICENCIA%type,
                                         p_ID_PSS_MED            IN SUB_FORMULARIOS_T.ID_PSS_MED%type,
                                         p_NO_DOCUMENTO_MED      IN SUB_FORMULARIOS_T.NO_DOCUMENTO_MED%type,
                                         p_NOMBRE_MED            IN SUB_FORMULARIOS_T.NOMBRE_MED%type,
                                         p_DIRECCION_MED         IN SUB_FORMULARIOS_T.DIRECCION_MED%type,
                                         p_TELEFONO_MED          IN SUB_FORMULARIOS_T.TELEFONO_MED%type,
                                         p_CELULAR_MED           IN SUB_FORMULARIOS_T.CELULAR_MED%type,
                                         p_EMAIL_MED             IN SUB_FORMULARIOS_T.EMAIL_MED%type,
                                         p_ID_PSS_CEN            IN SUB_FORMULARIOS_T.ID_PSS_CEN%type,
                                         p_NOMBRE_CEN            IN SUB_FORMULARIOS_T.NOMBRE_CEN%type,
                                         p_DIRECCION_CEN         IN SUB_FORMULARIOS_T.DIRECCION_CEN%type,
                                         p_TELEFONO_CEN          IN SUB_FORMULARIOS_T.TELEFONO_CEN%type,
                                         p_FAX_CEN               IN SUB_FORMULARIOS_T.FAX_CEN%type,
                                         p_EMAIL_CEN             IN SUB_FORMULARIOS_T.EMAIL_CEN%type,
                                         p_EXEQUATUR             IN SUB_FORMULARIOS_T.EXEQUATUR%type,
                                         p_DIAGNOSTICO           IN SUB_FORMULARIOS_T.DIAGNOSTICO%type,
                                         p_SIGNOS_SINTOMAS       IN SUB_FORMULARIOS_T.SIGNOS_SINTOMAS%type,
                                         p_PROCEDIMIENTOS        IN SUB_FORMULARIOS_T.PROCEDIMIENTOS%type,
                                         p_FECHA_DIAGNOSTICO_LIC IN SUB_FORMULARIOS_T.FECHA_DIAGNOSTICO%type,
                                         -- Parametros para el nacimiento
                                         p_cant_lactantes   IN sub_sfs_lactancia_t.cant_lactantes%type,
                                         p_fecha_nacimiento IN sub_sfs_lactancia_t.fecha_nacimiento%type,
                                         -- Parametro para los lactantes
                                         p_DATOS_LACTANTES IN VARCHAR2,
                                         -- Numero de solicitud creado
                                         P_NRO_SOLICITUD IN OUT SUB_SOLICITUD_T.NRO_SOLICITUD%type,
                                         -- Parametro para retener el resultado de la corrida
                                         p_RESULTNUMBER OUT VARCHAR2);

  -----------------------------------------------------------------------------------------
  --- Metodo para traer todos los lactantes activos y pendientes de aprobacion de una madre
  -----------------------------------------------------------------------------------------
  Procedure getLactantes(p_ID_NSS       IN suirplus.sub_solicitud_t.nss%type,
                         p_iocursor     OUT t_cursor,
                         p_RESULTNUMBER OUT VARCHAR2);

  ---------------------------------------------------------------
  -- Devuelve los datos de un m?dico
  ---------------------------------------------------------------
  PROCEDURE GetMedico(P_CEDULA_MED   IN SFS_MEDICOS_T.CEDULA%TYPE,
                      p_resultnumber OUT VARCHAR2,
                      p_io_cursor    OUT T_CURSOR);

  ---------------------------------------------------------------
  -- Devuelve el NSS en base a un Documento
  ---------------------------------------------------------------
  Function getNSS(NroDocumento IN SRE_CIUDADANOS_T.NO_DOCUMENTO%TYPE)
    return sre_ciudadanos_t.id_nss%type;

  ---------------------------------------------------------------------------------
  -- Procedure para hacer la pre-validacion del registro de Enfermedad Com?n
  ---------------------------------------------------------------------------------
  Procedure ValidarRegistroEnfermedadComun(p_NroDocumento     SRE_CIUDADANOS_T.NO_DOCUMENTO%TYPE,
                                           p_RegistroPatronal SRE_EMPLEADORES_T.ID_REGISTRO_PATRONAL%type,
                                           p_io_cursor        OUT t_cursor,
                                           p_ResultNumber     OUT varchar2);

  -- -------------------------------------------------------------------------
  -- Para registrar el registro en Sub_enfermedad_comun_t como pendiente
  ----------------------------------------------------------------------------
  Procedure RegistrarDatosInicialesEnf(p_id_nss           In sfs_enfermedad_comun_t.id_nss%Type Default 0,
                                       p_tipo_solicitud   In Varchar2,
                                       p_direccion        In sfs_enfermedad_comun_t.direccion%Type,
                                       p_telefono         In sfs_enfermedad_comun_t.telefono%Type,
                                       p_correo           In sfs_enfermedad_comun_t.email%Type,
                                       p_celular          In sfs_enfermedad_comun_t.celular%Type,
                                       p_usuario_registro In sfs_enfermedad_comun_t.usuario_registro%Type,
                                       p_Pin              Out Varchar2,
                                       p_nro_solicitud    In Out Varchar2,
                                       p_nro_formulario   Out sub_formularios_t.nro_formulario%type,
                                       p_resultNumber     Out Varchar2);

  -----------------------------------------------------------------------------
  -- Para registra el subsidio por efermedad comun
  ----------------------------------------------------------------------------
  Procedure RegistroEnfComun(p_id_nss               In sub_solicitud_t.nss%type,
                             p_Nro_Solicitud        In sub_enfermedad_comun_t.nro_solicitud%type,
                             p_Direccion            In sub_enfermedad_comun_t.direccion%Type,
                             p_Telefono             In sub_enfermedad_comun_t.telefono%Type,
                             p_Email                In sub_enfermedad_comun_t.email%Type,
                             p_Celular              In sub_enfermedad_comun_t.celular%Type,
                             p_ult_usuario          In sub_enfermedad_comun_t.ult_usuario_act%Type,
                             p_id_pss_med           In sub_formularios_t.id_pss_med%Type,
                             p_no_documento_med     In sub_formularios_t.no_documento_med%Type,
                             p_Nombre_med           In sub_formularios_t.nombre_med%Type,
                             p_Direccion_med        In sub_formularios_t.direccion_med%Type,
                             p_Telefono_med         In sub_formularios_t.telefono_med%Type,
                             p_celular_med          In sub_formularios_t.celular_med%Type,
                             p_Email_med            In sub_formularios_t.email_med%Type,
                             p_id_pss_cen           In sub_formularios_t.id_pss_cen%Type,
                             p_nombre_cen           In sub_formularios_t.nombre_cen%Type,
                             p_Direccion_cen        In sub_formularios_t.direccion_cen%Type,
                             p_Telefono_cen         In sub_formularios_t.telefono_cen%Type,
                             p_Fax_cen              In sub_formularios_t.fax_cen%Type,
                             p_Email_cen            In sub_formularios_t.email_cen%Type,
                             p_Tipo_Discapacidad    In sub_enfermedad_comun_t.tipo_discapacidad%Type,
                             p_Diagnostico          In sub_formularios_t.diagnostico%Type,
                             p_Signos_Sintomas      In sub_formularios_t.signos_sintomas%Type,
                             p_Procedimientos       In sub_formularios_t.procedimientos%Type,
                             p_Ambulatorio          In sub_enfermedad_comun_t.ambulatorio%Type,
                             p_Fecha_Inicio_amb     In sub_enfermedad_comun_t.fecha_inicio_amb%Type,
                             p_dias_cal_amb         In sub_enfermedad_comun_t.dias_cal_amb%Type,
                             p_Hospitalario         In sub_enfermedad_comun_t.hospitalizacion%Type,
                             p_Fecha_inicio_hos     In sub_enfermedad_comun_t.fecha_inicio_hos%Type,
                             p_dias_cal_hos         In sub_enfermedad_comun_t.dias_cal_hos%Type,
                             p_Fecha_Diagnostico    In sub_formularios_t.fecha_diagnostico%Type,
                             p_id_registro_patronal In sub_sfs_enf_comun_t.id_registro_patronal%type,
                             p_id_usuario           In sub_formularios_t.usuario_registro%type,
                             p_Codigo_CIE10         In sub_enfermedad_comun_t.codigocie10%Type,
                             p_Exequatur            In sub_formularios_t.exequatur%Type,
                             p_id_nomina            In sre_nominas_t.id_nomina%type,
                             p_Modo                 In Varchar2,
                             p_ResultNumber         Out varchar2);

  --------------------------------------------------------------
  --Devuelve todos los registros de enfermedad comun completados
  --------------------------------------------------------------
  procedure ObtenerPadecimientoCompletado(p_id_nss               IN sre_ciudadanos_t.id_nss%type,
                                          p_id_registro_patronal IN sre_empleadores_t.id_registro_patronal%type,
                                          p_io_cursor            OUT t_cursor,
                                          p_resultnumber         OUT VARCHAR2);

  ---------------------------------------------------------------
  --Devuelve todos los registros de enfermedad comun a convalidar
  ---------------------------------------------------------------
  procedure PadecimientosaConvalidar(p_id_nss               IN sre_ciudadanos_t.id_nss%type,
                                     p_id_registro_patronal IN sre_empleadores_t.id_registro_patronal%type,
                                     p_io_cursor            OUT t_cursor,
                                     p_resultnumber         OUT VARCHAR2);

  ------------------------------------------------------------------------
  --Devuelve todos los registros de enfermedad que pueden ser reintegrados
  ------------------------------------------------------------------------
  procedure MostrarDatosReintegro(p_nro_solicitud IN sub_solicitud_t.nro_solicitud%type,
                                  p_io_cursor     OUT t_cursor,
                                  p_resultnumber  OUT Varchar2);

  --------------------------------------------------------------
  --Recibe datos de un reintegro de enfermedad comun
  --------------------------------------------------------------
  procedure RecibirDatosReintegro(p_nro_solicitud   IN sub_solicitud_t.nro_solicitud%type,
                                  p_fecha_reintegro IN sub_reintegro_t.fecha_reintegro%type,
                                  p_usuario         IN seg_usuario_t.id_usuario%type,
                                  p_id_reg_pat      IN sre_empleadores_t.id_registro_patronal%type,
                                  p_resultnumber    OUT Varchar2);

  Procedure ConvalidarPadecimiento(p_nro_solicitud        IN sub_solicitud_t.nro_solicitud%type,
                                   p_id_registro_patronal IN sre_empleadores_t.id_registro_patronal%type,
                                   p_id_nomina            IN sre_nominas_t.id_nomina%type,
                                   p_usuario              IN seg_usuario_t.id_usuario%type,
                                   p_resultnumber         OUT Varchar2);

  -----------------------------------------------------------------------------------------
  --- Metodo que devuelve los datos de un registro de enfermad comun a partir de un id_enfermedad_comun
  -----------------------------------------------------------------------------------------
  Procedure getEnfermedadComun(p_id_enfermedad_comun  IN suirplus.sub_enfermedad_comun_t.id_enfermedad_comun%type,
                               p_id_registro_patronal in suirplus.sub_sfs_enf_comun_t.id_registro_patronal%type,
                               p_iocursor             OUT t_cursor,
                               p_RESULTNUMBER         OUT VARCHAR2);

  -----------------------------------------------------------------------------------------
  --- Metodo que devuelve los datos de un registro de maternidad a partir de un id_enfermedad_comun
  -----------------------------------------------------------------------------------------
  Procedure getMaternidad(p_id_sub_maternidad    IN suirplus.sub_sfs_maternidad_t.id_sub_maternidad%type,
                          p_id_registro_patronal in suirplus.sub_sfs_maternidad_t.id_registro_patronal%type,
                          p_iocursor             OUT t_cursor,
                          p_RESULTNUMBER         OUT VARCHAR2);

  -----------------------------------------------------------------------------------------
  --- Metodo que devuelve los datos de un registro de lactancia a partir de un p_id_sub_lactancia
  -----------------------------------------------------------------------------------------
  Procedure getLactancia(p_id_sub_lactancia IN suirplus.sub_sfs_lactancia_t.id_sub_lactancia%type,
                         p_iocursor         OUT t_cursor,
                         p_RESULTNUMBER     OUT VARCHAR2);

Procedure EliminarLactancia(p_nroSolicitud in number,
                            p_RESULTNUMBER OUT VARCHAR2);
                            
------------------------------------------------------------------------------------------------------------
--Autor: Eury Vallejo
--Validar que la madre no tenga licencias activas con la empresa
------------------------------------------------------------------------------------------------------------
 FUNCTION ValidarLicenciaMaternidad(p_nss in suirplus.sub_solicitud_t.nss%type,
                                    p_modo in varchar2,
                                    p_id_registro_patronal in suirplus.sub_elegibles_t.registro_patronal%type) RETURN VARCHAR;                            

end SUB_SFS_NOVEDADES;