create or replace package suirplus.sre_nominas_pkg as
  -- *****************************************************************************************************
  -- program:   sre_nominas_pkg
  -- descripcion: Edita o actualiza las Nominas.
  --
  -- modification history
  -- -----------------------------------------------------------------------------------------------------
  -- date     by          remark
  -- -----------------------------------------------------------------------------------------------------
  -- 11/11/2004 Elinor Rodriguez  creation
  -- *****************************************************************************************************
  type t_cursor is ref cursor;
  e_invalidregistropatronal exception;
  e_invaliduser exception;
  e_invalidnss exception;
  e_InvalidNomina exception;
  e_excedelogintud exception;
  v_bderror                  varchar(1000);
  p_id_nomina                varchar(1000);
  v_existeidnomina           number;
  v_existeidregistropatronal number;
  -- **************************************************************************************************
  -- PROCEDIMIENTO:  nominas_crear
  -- DESCRIPCION:    Procedimiento mediante el cual se inserta un registro nuevo en la tabla de sre_nominas_t.
  -- **************************************************************************************************
  /*   PARAMETROS
         **********************************************************************************************************************************
         *  NOMBRE                 ** TIPO_DATO      **   TIPO_PARAMETRO    **  DESCRIPCION                         **    VALIDACION
         **********************************************************************************************************************************
         * p_id_registro_patronal    ** NUMBER(9)           **  IN                  ** Id del registro patronal
         * p_nomina_des              ** VARCHAR2(80)        **  IN                  ** Descripcion de la nomina, nombre que llevara
         * p_status                  ** VARCHAR2(1)         **  IN                  ** Status de la nomina
         * p_tipo_nomina             ** VARCHAR2(1)         **  IN                  ** Cursor devuelto
         * p_ult_usuario_act         ** VARCHAR2(35)        **  IN                  ** Usuario que inserte el registro.
         * p_resultnumber            ** VARCHAR2            **  IN/OUT              ** Variable resultado (Si todo sale bien envia 0)
         **********************************************************************************************************************************
         **********************************************************************************************************************************
  */
  procedure nominas_crear(p_id_registro_patronal sre_nominas_t.id_registro_patronal%type,
                          p_nomina_des           sre_nominas_t.nomina_des%type,
                          p_status               sre_nominas_t.status%type,
                          p_tipo_nomina          sre_nominas_t.tipo_nomina%type,
                          p_ult_usuario_act      sre_nominas_t.ult_usuario_act%type,
                          p_resultnumber         in out varchar2);

  -- **************************************************************************************************
  -- PROCEDIMIENTO:  nominas_editar
  -- DESCRIPCION:    Procedimiento mediante el cual se modifica un registro en la tabla de sre_nominas_t.
  -- **************************************************************************************************
  /*   PARAMETROS
         **********************************************************************************************************************************
         *  NOMBRE                 ** TIPO_DATO      **   TIPO_PARAMETRO    **  DESCRIPCION                         **    VALIDACION
         **********************************************************************************************************************************
         * p_id_registro_patronal    ** NUMBER(9)           **  IN                  ** Id del registro patronal
         * p_id_nomina               ** NUMBER(6)           **  IN                  ** Id de la nomina
         * p_nomina_des              ** VARCHAR2(80)        **  IN                  ** Descripcion de la nomina, nombre que llevara
         * p_status                  ** VARCHAR2(1)         **  IN                  ** Status de la nomina
         * p_tipo_nomina             ** VARCHAR2(1)         **  IN                  ** Cursor devuelto
         * p_ult_usuario_act         ** VARCHAR2(35)        **  IN                  ** Usuario que inserte el registro.
         * p_resultnumber            ** VARCHAR2            **  IN/OUT              ** Variable resultado (Si todo sale bien envia 0)
         **********************************************************************************************************************************
         **********************************************************************************************************************************
  */
  procedure nominas_editar(p_id_registro_patronal sre_nominas_t.id_registro_patronal%type,
                           p_id_nomina            sre_nominas_t.id_nomina%type,
                           p_nomina_des           sre_nominas_t.nomina_des%type,
                           p_status               sre_nominas_t.status%type,
                           p_tipo_nomina          sre_nominas_t.tipo_nomina%type,
                           p_ult_usuario_act      sre_nominas_t.ult_usuario_act%type,
                           p_resultnumber         in out varchar2);
  -- **************************************************************************************************
  -- PROCEDIMIENTO:  nominas_borrar
  -- DESCRIPCION:    Procedimiento mediante el cual se borra un registro en la tabla de sre_nominas_t.
  -- **************************************************************************************************
  /*   PARAMETROS
         **********************************************************************************************************************************
         *  NOMBRE                 ** TIPO_DATO      **   TIPO_PARAMETRO    **  DESCRIPCION                         **    VALIDACION
         **********************************************************************************************************************************
         * p_id_registro_patronal    ** NUMBER(9)           **  IN                  ** Id del registro patronal
         * p_id_nomina               ** NUMBER(6)           **  IN                  ** Id de la nomina
         * p_ult_usuario_act         ** VARCHAR2(35)        **  IN                  ** Usuario que inserte el registro.
         * p_resultnumber            ** VARCHAR2            **  IN/OUT              ** Variable resultado (Si todo sale bien envia 0)
         **********************************************************************************************************************************
         **********************************************************************************************************************************
  */
  procedure nominas_borrar(p_id_registro_patronal sre_nominas_t.id_registro_patronal%type,
                           p_id_nomina            sre_nominas_t.id_nomina%type,
                           p_ult_usuario_act      sre_nominas_t.ult_usuario_act%type,
                           p_resultnumber         in out varchar2);
  -- **************************************************************************************************
  -- PROCEDIMIENTO:  nominas_select
  -- DESCRIPCION:    Procedimiento mediante el cual se realiza un select de sre_nominas_t.
  -- **************************************************************************************************
  /*   PARAMETROS
         **********************************************************************************************************************************
         *  NOMBRE                 ** TIPO_DATO      **   TIPO_PARAMETRO    **  DESCRIPCION                         **    VALIDACION
         **********************************************************************************************************************************
         * p_id_registro_patronal    ** NUMBER(9)           **  IN                  ** Id del registro patronal
         * p_id_nomina               ** NUMBER(6)           **  IN                  ** Id de la nomina
         * io_cursor                **  CURSOR             **  IN/OUT              ** Cursor devuelto        **********************************************************************************************************************************
         **********************************************************************************************************************************
  */
  procedure nominas_select(p_id_nomina            sre_nominas_t.id_nomina%type,
                           p_id_registro_patronal sre_nominas_t.id_registro_patronal%type,
                           io_cursor              in out t_cursor);

  -- **************************************************************************************************
  -- PROCEDIMIENTO:  get_Detalle_Nomina
  -- DESCRIPCION:    Procedimiento por el que se obtiene el detalle de una nomina.
  -- **************************************************************************************************
  /*   PARAMETROS
         **********************************************************************************************************************************
         *  NOMBRE                 ** TIPO_DATO      **   TIPO_PARAMETRO    **  DESCRIPCION                         **    VALIDACION
         **********************************************************************************************************************************
         * p_id_registro_patronal    ** NUMBER(9)           **  IN                  ** Id del registro patronal
         * p_id_nomina               ** NUMBER(6)           **  IN                  ** Id de la nomina
         * io_cursor                **  CURSOR             **  IN/OUT              ** Cursor devuelto        **********************************************************************************************************************************
         * p_resultnumber            ** VARCHAR2            **  IN/OUT              ** Variable resultado (Si todo sale bien envia 0)
         **********************************************************************************************************************************
  */
  procedure get_Detalle_Nomina(p_id_nomina            sre_nominas_t.id_nomina%type,
                               p_id_registro_patronal sre_nominas_t.id_registro_patronal%type,
                               p_io_cursor            in out t_cursor,
                               p_resultnumber         out varchar2);
  -- **************************************************************************************************
  -- PROCEDIMIENTO:  get_Detalle_Ced_Cancelada
  -- DESCRIPCION:    Procedimiento por el que se obtiene el detalle de una nomina.
  -- **************************************************************************************************
  /*   PARAMETROS
         **********************************************************************************************************************************
         *  NOMBRE                 ** TIPO_DATO      **   TIPO_PARAMETRO    **  DESCRIPCION                         **    VALIDACION
         **********************************************************************************************************************************
         * p_id_registro_patronal    ** NUMBER(9)           **  IN                  ** Id del registro patronal
         * p_id_nomina               ** NUMBER(6)           **  IN                  ** Id de la nomina
         * io_cursor                **  CURSOR             **  IN/OUT              ** Cursor devuelto        **********************************************************************************************************************************
         * p_resultnumber            ** VARCHAR2            **  IN/OUT              ** Variable resultado (Si todo sale bien envia 0)
         **********************************************************************************************************************************
  */
  PROCEDURE get_Detalle_Ced_Cancelada(p_id_nomina            SRE_NOMINAS_T.id_nomina%TYPE,
                                      p_id_registro_patronal SRE_NOMINAS_T.id_registro_patronal%TYPE,
                                      p_io_cursor            IN OUT t_cursor,
                                      p_resultnumber         OUT VARCHAR2);
  -- **************************************************************************************************
  -- PROCEDIMIENTO:  Consulta_Trabajadores
  -- DESCRIPCION:    Procedimiento mediante el cual se realiza un select de sre_trabajadores_t para esa nomina.
  -- **************************************************************************************************
  /*   PARAMETROS
         **********************************************************************************************************************************
         *  NOMBRE                 ** TIPO_DATO      **   TIPO_PARAMETRO    **  DESCRIPCION                         **    VALIDACION
         **********************************************************************************************************************************
         * p_id_registro_patronal    ** NUMBER(9)           **  IN                  ** Id del registro patronal
         * io_cursor                **  CURSOR             **  IN/OUT              ** Cursor devuelto        **********************************************************************************************************************************
         **********************************************************************************************************************************
  */
  PROCEDURE Consulta_Trabajadores(p_id_registro_patronal SRE_ACCESO_NOMINA.id_registro_patronal%TYPE,
                                  io_cursor              OUT t_cursor);

  -- **************************************************************************************************
  -- PROCEDIMIENTO:  Consulta_Dependientes
  -- DESCRIPCION:    Procedimiento mediante el cual se realiza un select para buscar los trabajadores con dependientes
  -- **************************************************************************************************
  PROCEDURE Consulta_Dependientes(p_id_registro_patronal SRE_ACCESO_NOMINA.id_registro_patronal%TYPE,
                                  io_cursor              OUT t_cursor);

  -- **************************************************************************************************
  -- FUNCION:  isNominaValida
  -- DESCRIPCION:    Funcion para obtener si la nomina es valida.
  -- **************************************************************************************************
  /*   PARAMETROS
         **********************************************************************************************************************************
         *  NOMBRE                 ** TIPO_DATO      **   TIPO_PARAMETRO    **  DESCRIPCION                         **    VALIDACION
         **********************************************************************************************************************************
         * p_id_registro_patronal    ** NUMBER(9)           **  IN                  ** Id del registro patronal
         * p_id_nomina               ** NUMBER(6)           **  IN                  ** Id de la nomina
         * La misma retorna un valor booleano (True / False)
         **********************************************************************************************************************************
  */

  FUNCTION isNominaValida(p_Id_Registro_Patronal sre_nominas_t.id_registro_patronal%type,
                          p_id_nomina            sre_nominas_t.id_nomina%type)
    RETURN BOOLEAN;

  -- **************************************************************************************************
  -- FUNCION:  isNominaProxima
  -- DESCRIPCION:    Funcion para obtener la secuencia de la nomina que le corresponde a una empresa.
  -- **************************************************************************************************
  /*   PARAMETROS
         **********************************************************************************************************************************
         *  NOMBRE                 ** TIPO_DATO      **   TIPO_PARAMETRO    **  DESCRIPCION                         **    VALIDACION
         **********************************************************************************************************************************
         * p_id_registro_patronal    ** NUMBER(9)           **  IN                  ** Id del registro patronal
         * p_id_nomina               ** NUMBER(6)           **  IN                  ** Id de la nomina
         * La misma retorna un valor varchar conteniendo la secuencia de la nomina siguiente
         **********************************************************************************************************************************
  */
  FUNCTION isNominaProxima(p_Id_Registro_Patronal sre_nominas_t.id_registro_patronal%type)
    RETURN varchar;
  -- **************************************************************************************************
  -- FUNCION:  ocultaNSS
  -- DESCRIPCION:    Funcion para obtener en nss de un cicudadano.
  -- **************************************************************************************************
  /*   PARAMETROS
         **********************************************************************************************************************************
         *  NOMBRE                 ** TIPO_DATO      **   TIPO_PARAMETRO    **  DESCRIPCION                         **    VALIDACION
         **********************************************************************************************************************************
         * p_tipoDocumento    ** VARCHAR(25)             ** IN                  ** Tipo de Documento en Ciudadano C (cedula), P (Pasaporte)
         * p_NSS              ** VARCHAR(1)              ** IN                  ** Id de la nomina
         * La misma retorna un valor number conteniendo el NSS de un ciudadano
         **********************************************************************************************************************************
  */
  function ocultaNSS(p_tipoDocumento sre_ciudadanos_t.tipo_documento%type,
                     p_NSS           sre_ciudadanos_t.id_nss%type)
    return number;

  --****************************************************************************************

  PROCEDURE Cedulas_Canceladas(p_id_nomina            SRE_NOMINAS_T.id_nomina%TYPE,
                               p_id_registro_patronal SRE_NOMINAS_T.id_registro_patronal%TYPE,
                               p_io_cursor            IN OUT t_cursor,
                               p_resultnumber         OUT VARCHAR2);

  PROCEDURE getNominasPorRNC(p_rnc          sre_empleadores_t.rnc_o_cedula%TYPE,
                             p_io_cursor    OUT t_cursor,
                             p_resultnumber OUT VARCHAR2);

  PROCEDURE getPage_Detalle_Nomina(p_id_nomina            SRE_NOMINAS_T.id_nomina%TYPE,
                                   p_id_registro_patronal SRE_NOMINAS_T.id_registro_patronal%TYPE,
                                   p_tipo                 in varchar2,
                                   p_criterio             in varchar2,
                                   p_pagenum              in number,
                                   p_pagesize             in number,
                                   p_io_cursor            OUT t_cursor,
                                   p_resultnumber         OUT VARCHAR2);

  procedure getNominaDiscapacitados(p_idnss              in sre_trabajadores_t.id_nss%type,
                                    p_idRegistroPatronal in sre_trabajadores_t.id_registro_patronal%type,
                                    p_resultnumber       OUT varchar2,
                                    p_io_cursor          OUT t_cursor);

  PROCEDURE getTipoNominas(p_io_cursor    OUT t_cursor,
                           p_resultnumber OUT VARCHAR2);
                           
/*****************************************************************************************/
--evallejo - 24/06/2014
--Metodo para obtener las distintas nominas de un empleador especificando, el Registro patronal 
--y el tipode nomina a obtener
/*****************************************************************************************/
  PROCEDURE getTipoNominasXEmpresas(p_id_registro_patronal SRE_NOMINAS_T.id_registro_patronal%TYPE,
                                    p_tipo_nomina sfc_tipo_nominas_t.id_tipo_nomina%type,
                                    p_io_cursor    OUT t_cursor,
                                    p_resultnumber OUT VARCHAR2);

end;