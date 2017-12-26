CREATE OR REPLACE PACKAGE SUIRPLUS.SFC_FACTURA_PKG IS

  -- Author  : CHARLIE_PENA
  -- Created : 11/30/2004 4:02:11 PM
  -- Purpose : Paquete para manejar los usuarios.

  type t_cursor is ref cursor;
  e_InvalidRequerimientos EXCEPTION;
  e_InvalidTSSDGII EXCEPTION;
  /*
  -- **************************************************************************************************
  ----------------------------------- CONSTANTES A UTILIZAR ------------------------------------------
  -- **************************************************************************************************
         *  NOMBRE       **   TIPO_DATO      **   TIPO_PARAMETRO        **  DESCRIPCION
         *********************************************************************************************
         * v_tt_TSS      **   VARCHAR2(4)    **      CONSTANTE           ** Contendra lo siguiente : "TSS" . Representa la institucion TSS.
         * v_tt_DGII     **   VARCHAR2(4)    **      CONSTANTE           ** Contendra lo siguiente  "DGII" . Representa la institucion DGII.
         *********************************************************************************************
         *********************************************************************************************
  
  
  */
  -- **************************************************************************************************
  -- PROCEDIMIENTO:     Cargar_Datos
  -- DESCRIPCION:       realiza una carga de datos de las vistas "sfc_facturas_v" y "sfc_liquidacion_isr_v"
  --                    tambien de las tablas "sre_empleadores_t", "sre_nominas_t", "sfc_tipo_facturas_t"
  --                    tomando en cuenta el parametro institucion.
  -- **************************************************************************************************
  /*
  PARAMETROS
         ******************************************************************************************************************************************************
         *  NOMBRE                 **   TIPO_DATO            **   TIPO_PARAMETRO        **  DESCRIPCION                                      **    VALIDACION
         ******************************************************************************************************************************************************
         * p_NoReferencia          **  VARCHAR2              **        IN               ** Numero de la factura (Notificacion de pago)       ** Verifica que el campo no este nulo
         * p_NoAutorizacion        **  NUMBER                **        IN               ** Numero de Autorizacion de la Notificacion de Pago ** N/A
         * p_concepto              **  VARCHAR2              **        IN               ** Contiene las iniciales de la institucion          ** Se asegura que el parametro sea en mayuscula.
         * p_IOCursor              **  CURSOR                **        IN/OUT           ** Contiene le valor de un cursor                    ** N/A
         * p_resultnumber          **  VARCHAR2)             **        OUT              ** Resultado                                         ** Si los datos de la Factura se carga correctamente devolvera 0, en caso de error devuelve el mensaje de error.
         ******************************************************************************************************************************************************
          ******************************************************************************************************************************************************
   */
  procedure Cargar_Datos(p_NoReferencia   Varchar2,
                         p_NoAutorizacion Number,
                         p_concepto       Varchar2,
                         p_IOCursor       out t_Cursor,
                         p_resultnumber   out varchar2);
  --***************************************************************************************************
  -- PROCEDIMIENTO:   CARGARDATOS_ISR_IR17
  -- DESCRIPCION:     Cargar los datos que conciernen a ISR e IR17
  --***************************************************************************************************
  PROCEDURE CargarDatosISRIR17(p_NoReferencia   VARCHAR2,
                               p_NoAutorizacion NUMBER,
                               p_IOCursor       OUT t_cursor,
                               p_resultnumber   OUT VARCHAR2);

  -- **************************************************************************************************
  -- PROCEDIMIENTO:     Get_Nominas
  -- DESCRIPCION:       Trae la nomina solicitada de acuerdo al RNCo Cedula que se le introduce como parametro.
  -- **************************************************************************************************
  /*
  PARAMETROS
         ******************************************************************************************************************************************************
         *  NOMBRE                 **   TIPO_DATO            **   TIPO_PARAMETRO        ** DESCRIPCION                                       **    VALIDACION
         ******************************************************************************************************************************************************
         * p_RNCoCedula            ** VARCHAR2(11)           **       IN                ** RNC o Cedula del empleador                        ** N/A
         * p_IOCursor              ** CURSOR                 **       IN/OUT            ** Contiene le valor de un cursor                    ** N/A
         * p_resultnumber          ** VARCHAR(2)             **       OUT               ** Resultado                                         ** Si el procedimiento se realiza correctamente devolvera "0", en caso de error devuelve el mensaje de error.
         ******************************************************************************************************************************************************
         ******************************************************************************************************************************************************
    */

  procedure Get_Nominas(p_RNCoCedula   in sre_empleadores_t.RNC_O_CEDULA%type,
                        p_IOCursor     in out t_Cursor,
                        p_resultnumber out varchar2);

  -- **************************************************************************************************
  -- PROCEDIMIENTO:     Insertar_Job
  -- DESCRIPCION:       Procedimiento que inserta p_job_id, p_nombre_job, status = 'S' y fecha_envio = fecha_actual
  -- **************************************************************************************************
  /*
  PARAMETROS
         ******************************************************************************************************************************************************
         *  NOMBRE                 **   TIPO_DATO            **  TIPO_PARAMETRO         ** DESCRIPCION                               **    VALIDACION
         ******************************************************************************************************************************************************
         * p_job_id                **   NUMBER               **  IN                     ** Representa el codigo de JOB a introducir  **   N/A
         * p_nombre_job            **   VARCHAR2(200)        **  IN                     ** Representa el Nombre del Job intorducido  **   N/A
         ******************************************************************************************************************************************************
         ******************************************************************************************************************************************************
    */

  PROCEDURE Insertar_Job(p_job_id     SEG_JOB_T.id_job%TYPE,
                         p_nombre_job SEG_JOB_T.nombre_job%TYPE);
  -- **************************************************************************************************
  -- PROCEDIMIENTO:     get_facturas_pendientes
  -- DESCRIPCION:       Utilizado para obtener las facturas pendientes y vigentes de un empleador.
  -- AUTOR:       Ronny J. Carreras
  -- DATE:        27/01/2004
  -- **************************************************************************************************
  /*
  PARAMETROS
         ******************************************************************************************************************************************************
         *  NOMBRE                 **   TIPO_DATO            **   TIPO_PARAMETRO        ** DESCRIPCION                                ** VALIDACION
         ******************************************************************************************************************************************************
         * p_RNCoCedula            ** VARCHAR2(11)           **       IN                ** RNC o Cedula del empleador                 ** N/A
         * p_IOCursor              ** CURSOR                 **       IN/OUT            ** Contiene le valor de un cursor             ** N/A
         ******************************************************************************************************************************************************
         ******************************************************************************************************************************************************
    */

  Procedure get_facturas_pendientes(p_RNCoCedula sre_empleadores_t.rnc_o_cedula%type,
                                    p_IOCursor   out t_cursor);

  PROCEDURE get_ConsultaDeuda_ARL(p_RNCoCedula SRE_EMPLEADORES_T.rnc_o_cedula%TYPE,
                                  p_IOCursor   OUT t_cursor);

  Procedure EncabezadoConsultaRNC(p_RNCoCedula          SRE_EMPLEADORES_T.rnc_o_cedula%TYPE,
                                  p_concepto            IN VARCHAR2,
                                  p_CodigoNomina        IN SRE_NOMINAS_T.id_nomina%TYPE,
                                  p_status              IN VARCHAR2,
                                  p_Razon_Social        out varchar2,
                                  p_Nombre_Comercial    out varchar2,
                                  p_Total_de_Referencia out varchar2,
                                  p_Total_Importe       out varchar2,
                                  p_Total_Recargo       out varchar2,
                                  p_Total_Intereses     out varchar2,
                                  p_Total_General       out varchar2,
                                  p_resultnumber        out varchar2);

  -- **************************************************************************************************
  -- PROCEDIMIENTO:     Cons_Facturas
  -- DESCRIPCION:       Hace una consulta de factura tomando en consideracion el parametro p_concepto y el p_RegistroPatronal.
  -- **************************************************************************************************
  /*
  PARAMETROS
         ******************************************************************************************************************************************************
         *  NOMBRE                 **   TIPO_DATO       **   TIPO_PARAMETRO   **  DESCRIPCION                                                          **    VALIDACION
         ******************************************************************************************************************************************************
         * p_RegistroPatronal      **   NUMBER(9)       **         IN         ** ID generado por cada empleador definido en la tabla SRE_EMPLEADORES_T **  N/A
         * p_concepto              **   VARCHAR2        **         IN         ** Contiene las iniciales de la institucion                              **  N/A
         * p_IOCursor              **   CURSOR          **         IN/OUT     ** Contiene le valor de un cursor                                        **  N/A
         * p_resultnumber          **   VARCHART        **         OUT        ** Resultado                                                             **  Si el procedimiento se realiza correctamente devolvera "0", en caso de error devuelve el mensaje de error.
         ******************************************************************************************************************************************************
         ******************************************************************************************************************************************************
  */

  procedure Cons_Facturas(p_RegistroPatronal in sre_empleadores_t.id_registro_patronal%type,
                          p_concepto         in varchar2,
                          p_IOCursor         in out t_Cursor,
                          p_resultnumber     out varchar2);

  -- **************************************************************************************************
  -- PROCEDIMIENTO:     Cons_Facturas
  -- DESCRIPCION:       Consulta de facturas por un Representante, se utiliza en el estado de Cuentas.
  -- **************************************************************************************************
  /*
  PARAMETROS
         ******************************************************************************************************************************************************
         *  NOMBRE                 **   TIPO_DATO       **   TIPO_PARAMETRO   **  DESCRIPCION                                                           **    VALIDACION
         ******************************************************************************************************************************************************
         * p_RegistroPatronal      **   NUMBER(9)       ** IN                 ** ID generado por cada empleador definido en la tabla SRE_EMPLEADORES_T  **  Hace referencia a la funcion isexisteRegistroPatronal que existe en el paquete SFC_Factura_Pkg. Si el parametro es incorrecto levanta la  excepcion e_invalidRegPatronal con mensaje de error.
         * p_idusuario             **   VARCHAR2(35)    ** IN                 ** Identificador del usuario.                                             **
         * p_concepto              **   VARCHAR22       ** IN                 ** Contiene las iniciales de la institucion                               **  N/A
         * p_status                **   VARCHAR2        ** IN                 ** Representa el estatus en que se encuentra la factura
         * p_IOCursor              **   CURSOR          ** IN/OUT             ** Contiene le valor de un cursor                                         ** N/A
         * p_resultnumber          **   VARCHAR2        **  OUT               ** Resultado                                                              ** Si el procedimiento se realiza correctamente devolvera "0", en caso de error devuelve el mensaje de error.
         ******************************************************************************************************************************************************
         ******************************************************************************************************************************************************
    */

  procedure Cons_Facturas(p_RegistroPatronal in sre_empleadores_t.id_registro_patronal%type,
                          p_idusuario        in seg_usuario_t.ID_USUARIO%type,
                          p_concepto         in varchar2,
                          p_status           in varchar2,
                          p_IOCursor         out t_Cursor,
                          p_resultnumber     out varchar2);

  -- **************************************************************************************************
  -- PROCEDIMIENTO:     Cons_Facturas
  -- DESCRIPCION:       Trae una consulta general de una factura.
  -- **************************************************************************************************
  /*
  PARAMETROS
         ******************************************************************************************************************************************************
         *  NOMBRE                 **   TIPO_DATO       **   TIPO_PARAMETRO   **  DESCRIPCION                                                       **    VALIDACION
         ******************************************************************************************************************************************************
          * p_RNCoCedula           **   VARCHAR2(11)    **     IN             **  RNC o Cedula del empleador                                        **  N/A
          * p_CodigoNomina         **   NUMBER(6)       **     IN             **  ID de las nominas de empleadores creada en la tabla SRE_NOMINA_T  **  N/A
          * p_Status               **   VARCHAR2        **     IN             **  Representa el estatus en que se encuentra la factura              **  N/A
          * p_concepto             **   VARCHAR2        **     IN             **  Contiene las iniciales de la institucion                          **  N/A
          * p_IOCursor             **   CURSOR          **     IN/OUT         **  Contiene le valor de un cursor                                    ** N/A
          * p_resultnumber         **   VARCHAR2        **     OUT            **  Resultado                                                         ** Si el procedimiento se realiza correctamente devolvera "0", en caso de error devuelve el mensaje de error.
         ******************************************************************************************************************************************************
         ******************************************************************************************************************************************************
  */

  -- **************************************************************************************************
  -- PROCEDIMIENTO:     Cons_Facturas
  -- DESCRIPCION:       Trae una consulta general de una factura.
  -- **************************************************************************************************
  /*
  PARAMETROS
         ******************************************************************************************************************************************************
         *  NOMBRE                 **   TIPO_DATO       **   TIPO_PARAMETRO   **  DESCRIPCION                                                       **    VALIDACION
         ******************************************************************************************************************************************************
          * p_RNCoCedula           **   VARCHAR2(11)    **     IN             **  RNC o Cedula del empleador                                        **  N/A
          * p_Status               **   VARCHAR2        **     IN             **  Representa el estatus en que se encuentra la factura              **  N/A
          * p_concepto             **   VARCHAR2        **     IN             **  Contiene las iniciales de la institucion                          **  N/A
          * p_IOCursor             **   CURSOR          **     IN/OUT         **  Contiene le valor de un cursor                                    ** N/A
          * p_resultnumber         **   VARCHAR2        **     OUT            **  Resultado                                                         ** Si el procedimiento se realiza correctamente devolvera "0", en caso de error devuelve el mensaje de error.
         ******************************************************************************************************************************************************
         ******************************************************************************************************************************************************
  */
  procedure Cons_Facturas(p_RNCoCedula   in sre_empleadores_t.RNC_O_CEDULA%type,
                          p_CodigoNomina in sre_nominas_t.id_nomina%type,
                          p_Status       in varchar2,
                          p_concepto     in varchar2,
                          p_IOCursor     out t_Cursor,
                          p_resultnumber out varchar2);

  --/////////////////////////////////////
  PROCEDURE Cons_Facturas(p_RNCoCedula IN SRE_EMPLEADORES_T.RNC_O_CEDULA%TYPE,
                          --  p_Status              IN VARCHAR2,
                          p_concepto     IN char,
                          p_algo         in varchar2,
                          p_IOCursor     OUT t_Cursor,
                          p_resultnumber OUT VARCHAR2);

  -- **************************************************************************************************
  -- PROCEDIMIENTO:     Cons_Facturas
  -- DESCRIPCION:       Trae una consulta general de una factura.
  -- **************************************************************************************************
  /*
  PARAMETROS
         ******************************************************************************************************************************************************
         *  NOMBRE                 **   TIPO_DATO       **   TIPO_PARAMETRO   **  DESCRIPCION                                                       **    VALIDACION
         ******************************************************************************************************************************************************
         * p_RNCoCedula            ** VARCHAR2(11)      **       IN           ** RNC o Cedula del empleador                                         ** N/A
         * p_CodigoNomina          ** NUMBER(6)         **       IN           ** ID de las nominas de empleadores creada en la tabla SRE_NOMINA_T   ** N/A
         * p_concepto              ** VARCHAR2          **       IN           ** Contiene las iniciales de la institucion                           ** N/A
         * p_IOCursor              ** CURSOR            **       IN/OUT       ** Contiene le valor de un cursor                                     ** N/A
         * p_resultnumber          ** VARCHAR2          **       OUT          ** Resultado                                                          ** Si el procedimiento se realiza correctamente devolvera "0", en caso de error devuelve el mensaje de error.
         ******************************************************************************************************************************************************
         ******************************************************************************************************************************************************
    */

  procedure Cons_Facturas(p_RNCoCedula   in sre_empleadores_t.RNC_O_CEDULA%type,
                          p_CodigoNomina in sre_nominas_t.id_nomina%type,
                          p_concepto     in varchar2,
                          p_IOCursor     in out t_Cursor,
                          p_resultnumber out varchar2);

  -- **************************************************************************************************
  -- PROCEDIMIENTO:     Cons_Facturas
  -- DESCRIPCION:      Trae una consulta general de una factura invocada por un No.de referencia
  -- **************************************************************************************************

  /*
  PARAMETROS
         ******************************************************************************************************************************************************
         *  NOMBRE                 **   TIPO_DATO       **   TIPO_PARAMETRO        **  DESCRIPCION                                                          **    VALIDACION
         ******************************************************************************************************************************************************
         * p_NoReferencia          **   in VARCHAR2(16) **      IN                 ** Numero de factura generado por el sistema en la tabla SFC_FACTURA_T   ** Hace referencia a la funcion isExisteNoReferencia que se encuentra en le paquete SFC_Factura_PKG. Si el parametro es incorrecto levanta la  excepcion e_invalidNoReferencia con mensaje de error.
         * p_concepto              **   VARCHAR2        **      IN                 ** Contiene las iniciales de la institucion                              ** N/A
         * p_IOCursor              **   CURSOR          **      IN/OUT             ** Contiene le valor de un cursor                                        ** N/A
         * p_resultnumber          **   VARCHAR2        **      OUT                ** Resultado                                                             ** Si el procedimiento se realiza correctamente devolvera "0", en caso de error devuelve el mensaje de error.
         ******************************************************************************************************************************************************
         ******************************************************************************************************************************************************
    */

  procedure Cons_Facturas(p_concepto     in varchar2,
                          p_NoReferencia in sfc_facturas_t.id_referencia%type,
                          p_IOCursor     in out t_Cursor,
                          p_resultnumber out varchar2);

  -- **************************************************************************************************
  -- PROCEDIMIENTO:     Cons_Autorizacion
  -- DESCRIPCION: trae todas las facturas autorizadas por un usuario
  --
  -- **************************************************************************************************
  /*
  PARAMETROS
         ******************************************************************************************************************************************************
         *  NOMBRE                 **   TIPO_DATO       **   TIPO_PARAMETRO   **  DESCRIPCION                                                   **    VALIDACION
         ******************************************************************************************************************************************************
         * p_idusuario             **   VARCHAR2(35)    **      IN            **  Identificador del usuario.                                          ** Hace referencia a la funcion isExisteUsuario que se encuentra en el paquete SEG_Usuarios_pkg. Si el parametro es incorrecto levanta la  excepcion e_invalidUser con mensaje de error.
         * p_NoReferencia          **   VARCHAR2(16)    **      IN            **  Numero de factura generado por el sistema en la tabla SFC_FACTURA_T ** Hace referencia a la funcion isExisteNoReferencia que se encuentra en le paquete SFC_Factura_PKG. Si el parametro es incorrecto levanta la  excepcion e_invalidNoReferencia con mensaje de error.
         * p_concepto              **   VARCHAR2        **      IN            ** Contiene las iniciales de la institucion                             ** N/A
         * p_IOCursor              **   CURSOR          **      IN/OUT        ** Contiene le valor de un cursor                                       ** N/A
         * p_resultnumber          **   VRACHAR2        **      OUT           ** Resultado                                                            ** Si el procedimiento se realiza correctamente devolvera "0", en caso de error devuelve el mensaje de error.
         ******************************************************************************************************************************************************
         ******************************************************************************************************************************************************
    */

  procedure Cons_Autorizacion(p_idusuario    in sfc_facturas_t.id_usuario_autoriza%type,
                              p_NoReferencia in sfc_facturas_t.id_referencia%type,
                              p_concepto     in varchar2,
                              p_IOCursor     in out t_Cursor,
                              p_resultnumber out varchar2);
  --///////////////////////////////////////
  PROCEDURE Cons_Referencias_Pendientes(p_RNCoCedula   IN SRE_EMPLEADORES_T.RNC_O_CEDULA%TYPE,
                                        p_IOCursor     IN OUT t_Cursor,
                                        p_resultnumber OUT VARCHAR2);

  -- **************************************************************************************************
  -- PROCEDIMIENTO:     Aut_Referencia
  -- DESCRIPCION:       Crea un Numero de Autorizacion para el ID de Referencia se?alado (autorizacion que realizan los Bancos)
  --
  -- **************************************************************************************************
  /*
  PARAMETROS
         ******************************************************************************************************************************************************
         *  NOMBRE                 **   TIPO_DATO       **   TIPO_PARAMETRO   **  DESCRIPCION                                                        **    VALIDACION
         ******************************************************************************************************************************************************
         * p_NoReferencia          **  VARCHAR2(16)     **    IN              ** Numero de factura generado por el sistema en la tabla SFC_FACTURA_T **  Hace referencia a la funcion isExisteNoReferencia que se encuentra en le paquete SFC_Factura_PKG. Si el parametro es incorrecto levanta la  excepcion e_invalidNoReferencia con mensaje de error.
         * p_idusuario             **  VARCHAR2(35)     **    IN              ** Identificador del usuario.                                          **  Hace referencia a la funcion isExisteUsuario que se encuentra en el paquete SEG_Usuarios_pkg. Si el parametro es incorrecto levanta la  excepcion e_invalidUser con mensaje de error.
         * p_concepto              **  VARCHAR          **    IN              ** Contiene las iniciales de la institucion                            ** N/A
         * p_nro_aut               **  NUMBER(10)       **    OUT             ** Numero de autorizacion.                                             **
         * p_resultnumber          **  VARCHAR2)        **    OUT             ** Resultado                                                           ** Si el procedimiento se realiza correctamente devolvera "0", en caso de error devuelve el mensaje de error.
         ******************************************************************************************************************************************************
         ******************************************************************************************************************************************************
    */

  procedure Aut_Referencia(p_NoReferencia in sfc_facturas_t.id_referencia%type,
                           p_idusuario    in sfc_facturas_t.id_usuario_autoriza%type,
                           p_concepto     in varchar2,
                           p_nro_aut      out sfc_facturas_t.no_autorizacion%type,
                           p_resultnumber out varchar2);

  -- **************************************************************************************************
  -- Program:     PAG_Referencia
  -- Description: Para pagar una referencia cuyo estatus este en 'VE' o 'VI y que este autorizada
  -- **************************************************************************************************
  PROCEDURE PAG_Referencia(p_NoReferencia IN SFC_FACTURAS_T.id_referencia%TYPE,
                           p_idusuario    IN SFC_FACTURAS_T.id_usuario_desautoriza%TYPE,
                           p_concepto     IN VARCHAR2,
                           p_resultnumber OUT VARCHAR2);

  -- **************************************************************************************************
  -- PROCEDIMIENTO:     Cancelar_Autorizacion
  -- DESCRIPCION:       Para cancelar una autorizacion realizada
  --
  -- **************************************************************************************************
  /*
  PARAMETROS
         ******************************************************************************************************************************************************
         *  NOMBRE                 **   TIPO_DATO       **   TIPO_PARAMETRO   **  DESCRIPCION                                                       **    VALIDACION
         ******************************************************************************************************************************************************
         * p_NoReferencia          **    VARCHAR2(16)   **  IN                ** Numero de factura generado por el sistema en la tabla SFC_FACTURA_T **  Hace referencia a la funcion isExisteNoReferencia que se encuentra en le paquete SFC_Factura_PKG. Si el parametro es incorrecto levanta la  excepcion e_invalidNoReferencia con mensaje de error.
         * p_idusuario             **    VARCHAR2(35)   **  IN                ** Identificador del usuario.                                          **  Hace referencia a la funcion isExisteUsuario que se encuentra en el paquete SEG_Usuarios_pkg. Si el parametro es incorrecto levanta la  excepcion e_invalidUser con mensaje de error.
         * p_concepto              **    VARCHAR2       **  IN                ** Contiene las iniciales de la institucion                            ** N/A
         * p_fecha_caja            **    DATE           **  IN                ** Fecha de desautorizacion                                            **  N/A
         * p_resultnumber          **    VARCHAR2       **  OUT               ** Resultado                                                           ** Si el procedimiento se realiza correctamente devolvera "0", en caso de error devuelve el mensaje de error.
         ******************************************************************************************************************************************************
         ******************************************************************************************************************************************************
    */
  procedure Cancelar_Autorizacion(p_NoReferencia in sfc_facturas_t.id_referencia%type,
                                  p_idusuario    in sfc_facturas_t.id_usuario_desautoriza%type,
                                  p_concepto     in varchar2,
                                  p_fecha_caja   in sfc_facturas_t.fecha_desautorizacion%type,
                                  p_resultnumber out varchar2);
  -- **************************************************************************************************
  -- PROCEDIMENTO:     Cons_Detalle
  -- DESCRIPCION:      Consulta los detalles de las facturas de acuerdo a la institucion TSS O DGII
  --
  -- **************************************************************************************************
  /*
  PARAMETROS
         ******************************************************************************************************************************************************
         *  NOMBRE                 **   TIPO_DATO       **   TIPO_PARAMETRO   **  DESCRIPCION                                                        ** VALIDACION
         ******************************************************************************************************************************************************
         * p_NoReferencia          **   VARCHAR2(16)    **    IN              ** Numero de factura generado por el sistema en la tabla SFC_FACTURA_T ** Hace referencia a la funcion isExisteNoReferencia que se encuentra en le paquete SFC_Factura_PKG. Si el parametro es incorrecto levanta la  excepcion e_invalidNoReferencia con mensaje de error.
         * p_concepto              **   VARCHAR2        **    IN              ** Contiene las iniciales de la institucion                            ** N/A
         * p_IOCursor              **   CURSOR          **    IN/OUT          ** Contiene le valor de un cursor                                      ** N/A
         * p_resultnumber          **   VARCHAR2)       **    OUT             ** Resultado                                                           ** Si el procedimiento se realiza correctamente devolvera "0", en caso de error devuelve el mensaje de error.
         ******************************************************************************************************************************************************
         ******************************************************************************************************************************************************
    */

  procedure Cons_Detalle(p_NoReferencia in sfc_facturas_t.id_referencia%type,
                         p_concepto     in varchar2,
                         p_IOCursor     in out t_Cursor,
                         p_resultnumber out varchar2);

  --**********************************************
  --**********************************************
  PROCEDURE Cons_Detalle_Auditoria(p_NoReferencia IN SFC_FACTURAS_T.id_referencia%TYPE,
                                   p_IOCursor     IN OUT t_Cursor,
                                   p_resultnumber OUT VARCHAR2);
  -- **************************************************************************************************
  -- PROCEDIMIENTO:     function isExisteRegistroPatronal()
  -- DESCRPICION:       funcion que retorna la existencia de un registro patronal.
  --          Recibe :  El parametro p_id_registro_patronal
  --         Devuelve:  un valor booleano (0,1) . 0 = no existe  1 = existe.
  -- **************************************************************************************************

  function isExisteRegistroPatronal(p_id_registro_patronal varchar2)
    return boolean;
  -- **************************************************************************************************
  -- FUNCION:     function isExisteNoReferencia()
  -- DESCRIPCION: funcion que retorna la existencia de un No. de referencia
  --          Recibe : Los parametros p_concepto y p_NoReferencia
  --         Devuelve: un valor booleano (0,1) . 0 = no existe  1 = existe.
  -- **************************************************************************************************

  function isExisteNoReferencia(p_concepto     varchar2,
                                p_NoReferencia in sfc_facturas_t.id_referencia%type)
    return boolean;

  -- **************************************************************************************************
  -- Program:     function isReferenciaAutorizada()
  -- Description: funcion que retorna si la referencia esta o no autorizada
  -- **************************************************************************************************
  FUNCTION isReferenciaAutorizada(p_concepto     VARCHAR2,
                                  p_NoReferencia IN SFC_FACTURAS_T.id_referencia%TYPE)
    RETURN BOOLEAN;

  --*****************************************************************************
  FUNCTION isExisteReferencia(p_NoReferencia IN SFC_FACTURAS_T.id_referencia%TYPE)
    RETURN BOOLEAN;

  FUNCTION isExisteIdRecepcion(p_idrecepcion in sre_det_movimiento_recaudo_t.id_recepcion%type)
    RETURN BOOLEAN;

  -- **************************************************************************************************
  -- Program:     isReferenciaValida
  -- Description: Valida si la factura existe en las distintas tablas de factura dependiendo del concepto
  -- **************************************************************************************************
  PROCEDURE isReferenciaValida(p_referencia   IN SFC_FACTURAS_T.ID_REFERENCIA%TYPE,
                               p_rnc          IN Sre_Empleadores_t.Rnc_o_Cedula%type,
                               p_concepto     IN VARCHAR2,
                               p_resultnumber OUT VARCHAR2);

  --*****************************************************************************
  -- PROCEDIMIENTO:     Cons_Pagos
  -- DESCRIPCION:       Procedimiento para los Campos de TSS (Mamey).
  --*****************************************************************************
  /*
  PARAMETROS
         *****************************************************************************************************************************************************************************
         *  NOMBRE                 **   TIPO_DATO                   **   TIPO_PARAMETRO   **  DESCRIPCION                                                           **    VALIDACION
         *****************************************************************************************************************************************************************************
         * p_NoReferencia          **  VARCHAR2(16)                 **   IN               **  Numero de factura generado por el sistema en la tabla SFC_FACTURA_T   ** Se verifica que el valor del parametro no sea NULO, de lo contrario levanta la excepcion e_invalidRequerimientos con mensaje de error
         * p_NoAutorizacion   sfc_facturas_t.no_autorizacion%type,  **   IN               **  Numero de autorizacion.                                               ** Se verifica que el valor del parametro no sea NULO, de lo contrario levanta la excepcion e_invalidRequerimientos con mensaje de error
         * p_concepto         varchar2,                             **   IN               **
         * p_IOCursor         t_Cursor,                             **   IN/OUT           **  Contiene le valor de un cursor                                        ** N/A
         * p_resultnumber     varchar2)                             **   OUT              **  Resultado                                                             ** Si el procedimiento se realiza correctamente devolvera "0", en caso de error devuelve el mensaje de error.
         ****************************************************************************************************************************************************************************
         ****************************************************************************************************************************************************************************
    */
  procedure Cons_Pagos(p_NoReferencia   in sfc_facturas_t.id_referencia%type,
                       p_NoAutorizacion in sfc_facturas_t.no_autorizacion%type,
                       p_concepto       in varchar2,
                       p_IOCursor       in out t_Cursor,
                       p_resultnumber   out varchar2);

  --******************************************************************************************
  -- PROCEDIMIENTO:     Cons_Envios
  -- DESCPIPCION:       Consulta a la tabla SFC_PAGOS_MV tomando en cuenta el parametro p_NoReferencia.
  --******************************************************************************************

  /*
  PARAMETROS
         ******************************************************************************************************************************************************
         *  NOMBRE           **   TIPO_DATO       **   TIPO_PARAMETRO   **  DESCRIPCION                                                        **    VALIDACION
         ******************************************************************************************************************************************************
         * p_NoReferencia    **  VARCHAR2(16)     **    IN              ** Numero de factura generado por el sistema en la tabla SFC_FACTURA_T ** Hace referencia a la funcion isExisteNoReferencia que se encuentra en le paquete SFC_Factura_PKG. Si el parametro es incorrecto levanta la  excepcion e_invalidNoReferencia con mensaje de error.
         * p_IOCursor        **  CURSOR           **    IN/OUT          ** Contiene le valor de un cursor                                      ** N/A
         * p_resultnumber    **  VARCHAR2)        **    OUT             ** Resultado                                                           ** Si la certificacion se crea correctamente devolvera 0, en caso de error devuelve el mensaje de error.
         ******************************************************************************************************************************************************
         ******************************************************************************************************************************************************
  */
  procedure Cons_Envios(p_NoReferencia in sfc_facturas_t.id_referencia%type,
                        p_IOCursor     in out t_Cursor,
                        p_resultnumber out varchar2);

  -- *****************************************************************************************
  -- PROCEDIMIENTO:     Cons_AnalisisRecaudoRef
  -- DESCRIPCION :      Consulta Analisis de Recaudo.
  -- *****************************************************************************************
  /*
  PARAMETROS
         ******************************************************************************************************************************************************
         *  NOMBRE                 **   TIPO_DATO       **   TIPO_PARAMETRO   **  DESCRIPCION                         **    VALIDACION
         ******************************************************************************************************************************************************
         * p_NoAutorizacion        **  NUMBER(10)       **      IN            **  Numero de autorizacion.             **  N/A
         * p_IOCursor              **  CURSOR           **      IN/OUT        **  Contiene le valor de un cursor      **  N/A
         * p_resultnumber          **  VARCHAR2)        **      OUT           **  Resultado                           **  Si la certificacion se crea correctamente devolvera 0, en caso de error devuelve el mensaje de error.
         ******************************************************************************************************************************************************
         ******************************************************************************************************************************************************
    */
  PROCEDURE Cons_AnalisisRecaudoRef(p_NoReferencia IN sre_tmp_movimiento_recaudo_t.id_referencia_isr%TYPE,
                                    p_IOCursor     IN OUT t_Cursor,
                                    p_resultnumber OUT VARCHAR2);

  --***************************************************************************************
  -- PROCEDIMIENTO:     Cons_AnalisisRecaudoAut
  -- DESCRIPCION:       Presenta un analisis de lo recaudado  filtrado por facturas autorizadas
  --***************************************************************************************
  /*
  PARAMETROS
         ******************************************************************************************************************************************************
         *  NOMBRE                 **   TIPO_DATO       **   TIPO_PARAMETRO   **  DESCRIPCION                         **    VALIDACION
         ******************************************************************************************************************************************************
         * p_NoAutorizacion        **  NUMBER(10)       **      IN            **  Numero de autorizacion.             **  N/A
         * p_IOCursor              **  CURSOR           **      IN/OUT        **  Contiene le valor de un cursor      **  N/A
         * p_resultnumber          **  VARCHAR2)        **      OUT           **  Resultado                           **  Si la certificacion se crea correctamente devolvera 0, en caso de error devuelve el mensaje de error.
         ******************************************************************************************************************************************************
         ******************************************************************************************************************************************************
    */
  PROCEDURE Cons_AnalisisRecaudoAut(p_NoAutorizacion IN sre_tmp_movimiento_recaudo_t.no_autorizacion%TYPE,
                                    p_IOCursor       IN OUT t_Cursor,
                                    p_resultnumber   OUT VARCHAR2);

  --************************************************************************************************
  -- PROCEDIMIENTO:     Cons_AnalisisRecaudoAut
  -- DESCRIPCION:       Procedimiento para obtener el numero de referencia a partir del numero de autorizacion.
  --************************************************************************************************
  /*
  PARAMETROS
         ******************************************************************************************************************************************************
         *  NOMBRE                 **   TIPO_DATO       **   TIPO_PARAMETRO   **  DESCRIPCION                        **    VALIDACION
         ******************************************************************************************************************************************************
         * p_NoAutorizacion        **  NUMBER(10)       **      IN            ** Numero de autorizacion.             **  N/A
         * p_IOCursor              **  CURSOR           **      IN/OUT        ** Contiene le valor de un cursor      **  N/A
         * p_resultnumber          **  VARCHAR2)        **      OUT           ** Resultado                           **  Si la certificacion se crea correctamente devolvera 0, en caso de error devuelve el mensaje de error.
         ******************************************************************************************************************************************************
         ******************************************************************************************************************************************************
    */
  PROCEDURE Get_Numeroreferencia(p_NoAutorizacion IN sre_tmp_movimiento_recaudo_t.no_autorizacion%TYPE,
                                 p_IOCursor       IN OUT t_Cursor,
                                 p_resultnumber   OUT VARCHAR2);
  --************************************************************************************************
  -- PROCEDIMIENTO:     Cons_AnalisisRecaudoAut
  -- DESCRIPCION:       Procedimiento para obtener el numero de oficio y el motivo de las facturas canceladas.
  --************************************************************************************************
  /*
  PARAMETROS
         ******************************************************************************************************************************************************
         *  NOMBRE                 **   TIPO_DATO       **   TIPO_PARAMETRO   **  DESCRIPCION                        **    VALIDACION
         ******************************************************************************************************************************************************
         * p_NoAutorizacion        **  NUMBER(10)       **      IN            ** Numero de autorizacion.             **  N/A
         * p_IOCursor              **  CURSOR           **      IN/OUT        ** Contiene le valor de un cursor      **  N/A
         * p_resultnumber          **  VARCHAR2)        **      OUT           ** Resultado                           **  Si la certificacion se crea correctamente devolvera 0, en caso de error devuelve el mensaje de error.
         ******************************************************************************************************************************************************
         ******************************************************************************************************************************************************
    */

  PROCEDURE Cons_OficiosVencidas(p_NoReferencia   IN SFC_FACTURAS_T.id_referencia%TYPE,
                                 p_NoAutorizacion IN SFC_FACTURAS_T.no_autorizacion%TYPE,
                                 p_concepto       VARCHAR2,
                                 p_IOCursor       IN OUT t_Cursor,
                                 p_resultnumber   OUT VARCHAR2);

  PROCEDURE Liquidacion_NoReferencia(p_NoReferencia in sre_det_movimiento_recaudo_t.id_referencia_isr%type,
                                     p_resultnumber out varchar2,
                                     p_iocursor     in out t_cursor);

  PROCEDURE Liquidacion_NoEnvio(p_idrecepcion  in sre_det_movimiento_recaudo_t.id_recepcion%type,
                                p_resultnumber out varchar2,
                                p_iocursor     in out t_cursor);

  FUNCTION isExisteReferenciaStatus(p_NoReferencia IN SFC_FACTURAS_T.id_referencia%TYPE)
    RETURN BOOLEAN;

  PROCEDURE Get_facturas_srl(p_rnc          in sre_empleadores_t.rnc_o_cedula%type,
                             p_periodo      in sfc_facturas_t.periodo_factura%type,
                             p_resultnumber out varchar2,
                             p_iocursor     in out t_cursor);

  PROCEDURE Esta_En_FechaPago(p_concepto     IN VARCHAR2,
                              p_resultnumber OUT VARCHAR2);

  -- **************************************************************************************************
  -- Description: Utilizada desde el paquete e certificaciones para buscar si un empleador tiene
  --              Facturas vencidas y pagadas
  -- **************************************************************************************************
  Function TieneFactVencidasPagadas(p_registro_patronal in varchar2)
    return char;

  -- **************************************************************************************************
  -- Program:     Procedimiento
  -- Description: funcion que retorna si la referencia esta o no autorizada, 0 = autorizada, 1 = no autorizada
  -- **************************************************************************************************
  PROCEDURE isReferenciaAutorizada(p_concepto     VARCHAR2,
                                   p_NoReferencia IN SFC_FACTURAS_T.id_referencia%TYPE,
                                   p_ResultNumber out number);

  Procedure get_ResumenFactura(p_IdReferencia in sfc_facturas_t.id_referencia%type,
                               p_IOCursor     out t_Cursor,
                               p_Resultnumber out varchar2);

  PROCEDURE ConsPage_Detalle_v2(p_NoReferencia IN SFC_FACTURAS_T.id_referencia%TYPE,
                                p_concepto     IN VARCHAR2,
                                p_pagenum      in number,
                                p_pagesize     in number,
                                p_IOCursor     IN OUT t_Cursor,
                                p_resultnumber OUT VARCHAR2);

  PROCEDURE ConsPage_Detalle_Auditoria(p_NoReferencia IN SFC_FACTURAS_T.id_referencia%TYPE,
                                       p_pagenum      in number,
                                       p_pagesize     in number,
                                       p_IOCursor     IN OUT t_Cursor,
                                       p_resultnumber OUT VARCHAR2);

  ------------------------------------------------------------
  -- Devuelve un cursor con las referencias pendientes de pago
  -- Autor: Gregorio Herrera
  ------------------------------------------------------------
  Procedure ReferenciasDisponiblesParaPago(p_rnc_o_cedula     in suirplus.sre_empleadores_t.rnc_o_cedula%type,
                                           p_concepto         in varchar2,
                                           p_id_nomina        in suirplus.sre_nominas_t.id_nomina%type,
                                           p_tipoAcuerdo      in suirplus.lgl_acuerdos_t.tipo%type,
                                           p_razon_social     out suirplus.sre_empleadores_t.razon_social%type,
                                           p_nombre_comercial out suirplus.sre_empleadores_t.nombre_comercial%type,
                                           p_IOCursor         out t_Cursor,
                                           p_resultnumber     out varchar2);

  ------------------------------------------------------------
  -- Devuelve un cursor con las referencias pendientes de pago
  -- Autor: Roberto Jaquez
  ------------------------------------------------------------
  Procedure LasRefsDisponiblesParaPago(p_rnc_o_cedula     in suirplus.sre_empleadores_t.rnc_o_cedula%type,
                                       p_concepto         in varchar2,
                                       p_razon_social     out suirplus.sre_empleadores_t.razon_social%type,
                                       p_nombre_comercial out suirplus.sre_empleadores_t.nombre_comercial%type,
                                       p_IOCursor         out t_Cursor,
                                       p_resultnumber     out varchar2);

  ------------------------------------------------------------
  -- Devuelve un cursor con las referencias pendientes de pago
  -- Autor: Roberto Jaquez y Gregorio Herrera
  ------------------------------------------------------------
  Procedure LasRefsDisponiblesParaPagoWS(p_rnc_o_cedula in suirplus.sre_empleadores_t.rnc_o_cedula%type,
                                         p_concepto     in varchar2,
                                         p_IOCursor     out t_Cursor,
                                         p_resultnumber out varchar2);

  -------------------------------------------------------
  -- Para verificar si existe al menos una referencia
  -- pendiente de pago mas antigua que la se esta pagando
  -- Autor: Gregorio Herrera
  -------------------------------------------------------
  Function DisponibleAutorizar(p_Noreferencia in suirplus.sfc_facturas_t.id_referencia%type)
    return char;

  PROCEDURE ConsPage_Facturas(p_RNCoCedula   IN SRE_EMPLEADORES_T.RNC_O_CEDULA%TYPE,
                              p_CodigoNomina IN SRE_NOMINAS_T.id_nomina%TYPE,
                              p_Status       IN VARCHAR2,
                              p_concepto     IN VARCHAR2,
                              p_pagenum      in number,
                              p_pagesize     in number,
                              p_IOCursor     IN OUT t_Cursor,
                              p_resultnumber OUT VARCHAR2);

  -- ---------------------------------------------------------------------------------
  -- Este metodo actualiza la fecha limite de pago de las facturas en acuerdo de pago
  -- Autor: Roberto Jaquez
  -- ---------------------------------------------------------------------------------

  PROCEDURE SetFechaLimitePagoAcuerdo(p_id_referencia             in varchar2,
                                      p_fecha_limite_pago_acuerdo in date,
                                      p_resultnumber              OUT VARCHAR2);

  ---***********************************************
  --- Mayreni Vargas
  --- Procedure para validar que una referencia exista
  ---***********************************************
  procedure isValidaReferencia(p_referencia   IN SFC_FACTURAS_T.ID_REFERENCIA%TYPE,
                               p_concepto     IN VARCHAR2,
                               p_resultnumber OUT VARCHAR2);

  /*Detalle de Ajuste*/
  PROCEDURE ConsPage_Detalle_Ajuste(p_NoReferencia IN sfc_det_ajustes_t.id_referencia%TYPE,
                                    p_pagenum      in number,
                                    p_pagesize     in number,
                                    p_IOCursor     IN OUT t_Cursor,
                                    p_resultnumber OUT VARCHAR2);

  procedure getMontoTotalAjuste(p_NoReferencia IN sfc_det_ajustes_t.id_referencia%TYPE,
                                p_IOCursor     IN OUT t_Cursor,
                                p_resultnumber OUT VARCHAR2);

  --------------------------------------------------------------------------------------------------------
  -- Get_Det_Liquidacion_ISR
  -- by Kerlin de la cruz
  -- 09-02-2012
  -- Para mostrar el detalle de las Liquidaciones ISR del 201201 en adelante
  --------------------------------------------------------------------------------------------------------
  procedure Get_Det_Liquidacion_ISR(p_rnc_o_cedula     in sre_empleadores_t.rnc_o_cedula%type,
                                    p_periodo          in sfc_liquidacion_isr_v.periodo_liquidacion%type,
                                    p_tipo_liquidacion in sfc_liquidacion_isr_v.id_tipo_factura%type,
                                    p_pagenum          in number,
                                    p_pagesize         in number,
                                    p_io_cursor        IN OUT t_cursor,
                                    p_resultnumber     OUT VARCHAR2);

  --------------------------------------------------------------------------------------------------------
  -- Get_Liquidacion_ISR
  -- by Kerlin de la cruz
  -- 09-02-2012
  -- Para mostrar el detalle de las Liquidaciones ISR del 201201 en adelante
  --------------------------------------------------------------------------------------------------------
  procedure Get_Liquidacion_ISR(p_rnc_o_cedula     in sre_empleadores_t.rnc_o_cedula%type,
                                p_periodo          in sfc_liquidacion_isr_v.periodo_liquidacion%type,
                                p_tipo_liquidacion in sfc_liquidacion_isr_v.id_tipo_factura%type,
                                p_io_cursor        IN OUT t_cursor,
                                p_resultnumber     OUT VARCHAR2);

  -- **************************************************************************************************
  -- Program:     MarcarReferenciaAuditoriaDefinitiva
  -- Description: Para marcar una referencia de auditoria definitiva
  -- **************************************************************************************************
  PROCEDURE MarcarRefAuditoriaDefinitiva(p_NoReferencia IN SFC_FACTURAS_T.id_referencia%TYPE,
                                         p_idusuario    IN SFC_FACTURAS_T.id_usuario_desautoriza%TYPE,
                                         p_resultnumber OUT VARCHAR2);
  ---***********************************************
  --- Eury Vallejo
  --- Procedure para validar que una referencia de tipo Pre-CalculoMDT
  ---***********************************************
  procedure isValidaReferenciaPreCalculo(p_referencia   IN SFC_FACTURAS_T.ID_REFERENCIA%TYPE,
                                         p_resultnumber OUT VARCHAR2);
  
  -- **************************************************************************************************
  -- Program:     Cons_Detalle_SIPEN
  -- evallejo:
  --
  -- **************************************************************************************************

/*  PROCEDURE Cons_Detalle_Sipen(p_NoReferencia IN SFC_FACTURAS_T.id_referencia%TYPE,
                                   p_IOCursor     IN OUT t_Cursor,
                                   p_resultnumber OUT VARCHAR2);
*/                     

END SFC_FACTURA_PKG;
