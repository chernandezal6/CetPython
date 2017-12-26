create or replace package suirplus.SRE_CIUDADANO_PKG as
  -- *****************************************************************************************************
  -- program:        SRE_CIUDADANO_PKG
  -- descripcion: Crea Ciudadanos.
  --
  -- modification history
  -- -----------------------------------------------------------------------------------------------------
  -- date            by                    remark
  -- -----------------------------------------------------------------------------------------------------
  -- 11/29/2004    Elinor Rodriguez     creation
  -- *****************************************************************************************************

  Type t_cursor is ref cursor;

  e_no9no11 exception;
  e_excedelogintud exception;
  e_ciudadanoeexiste exception;
  e_invaliduser exception;
  e_existeracceso exception;
  v_bderror varchar(1000);

  -- **************************************************************************************************
  -- PROCEDIMIENTO:  ciudadano_crear
  -- DESCRIPCION:    Procedimiento mediante el cual se inserta un registro nuevo en la tabla de sre_ciudadanos_t.
  -- **************************************************************************************************
  /*   PARAMETROS
         **********************************************************************************************************************************
         *  NOMBRE                   ** TIPO_DATO         **   TIPO_PARAMETRO      **  DESCRIPCION                         **    VALIDACION
         **********************************************************************************************************************************
         * p_nombres                 ** VARCHAR2(50)        **  IN                  ** Nombres del ciudadano
         * p_primer_apellido         ** VARCHAR2(40)        **  IN                  ** Primer apellido del ciudadano
         * p_segundo_apellido        ** VARCHAR2(40)        **  IN                  ** Segundo apellido del ciudadano
         * p_fecha_nacimiento        ** DATE                **  IN                  ** Fecha de nacimiento
         * p_no_documento            ** VARCHAR2(25)        **  IN                  ** Numero de documento (cedula / pasaporte)
         * p_tipo_documento          ** VARCHAR2(1)         **  IN                  ** Tipo de documento C (Cedula) P (Pasaporte)
         * p_ult_usuario_act         ** VARCHAR2(35)        **  IN                  ** Usuario que inserte el registro.
         * p_resultnumber            ** VARCHAR2            **  IN/OUT              ** Variable resultado (Si todo sale bien envia 0)
         **********************************************************************************************************************************
         **********************************************************************************************************************************
  */
  PROCEDURE ciudadano_crear(p_nombres          suirplus.SRE_CIUDADANOS_T.nombres%TYPE,
                            p_primer_apellido  suirplus.SRE_CIUDADANOS_T.primer_apellido%TYPE,
                            p_segundo_apellido suirplus.SRE_CIUDADANOS_T.segundo_apellido%TYPE,
                            p_fecha_nacimiento VARCHAR,
                            p_sexo             suirplus.SRE_CIUDADANOS_T.sexo%TYPE,
                            p_no_documento     suirplus.SRE_CIUDADANOS_T.no_documento%TYPE,
                            p_tipo_documento   suirplus.SRE_CIUDADANOS_T.tipo_documento%TYPE,
                            p_ult_usuario_act  suirplus.SRE_CIUDADANOS_T.ult_usuario_act%TYPE,
                            p_resultnumber     IN OUT VARCHAR);

--********************************************************************************
--ciudadano_tutor_crear
--para crear un nuevo tipo de ciudadano titular por excepcion para estancias infantiles 
--by Charlie pena
--*********************************************************************************
  PROCEDURE ciudadano_titular_crear(p_nombres    suirplus.SRE_EMPLEADORES_T.RAZON_SOCIAL%TYPE,
                            p_nombre_padre       suirplus.SRE_EMPLEADORES_T.RNC_O_CEDULA%TYPE,
                            p_ult_usuario_act    suirplus.SRE_CIUDADANOS_T.ult_usuario_act%TYPE,
                            p_resultnumber       IN OUT VARCHAR);
  -- **************************************************************************************************
  -- PROCEDIMIENTO:  verificar_ciudadano_existe
  -- DESCRIPCION:    Procedimiento mediante el cual se verifica la existencia de un registro en la tabla de sre_ciudadanos_t.
  -- **************************************************************************************************
  /*   PARAMETROS
         **********************************************************************************************************************************
         *  NOMBRE                   ** TIPO_DATO         **   TIPO_PARAMETRO      **  DESCRIPCION                         **    VALIDACION
         **********************************************************************************************************************************
         * p_no_documento            ** VARCHAR2(25)        **  IN                  ** Numero de documento (cedula / pasaporte)
         * p_tipo_documento          ** VARCHAR2(1)         **  IN                  ** Tipo de documento C (Cedula) P (Pasaporte)
         * p_nombres                 ** VARCHAR2(50)        **  IN                  ** Nombres del ciudadano
         * p_apellidos               ** VARCHAR2(40)        **  IN                  ** Apellidos del ciudadano (Primero / Segundo)
         * p_nss                     ** Number(10)          **  IN                  ** Id nss
         * p_resultnumber            ** VARCHAR2            **  IN/OUT              ** Variable resultado (Si todo sale bien envia 0)
         **********************************************************************************************************************************
         **********************************************************************************************************************************
  */
  PROCEDURE verificar_ciudadano_existe(p_numerodocumento in suirplus.sre_ciudadanos_t.no_documento%type,
                                       p_tipodocumento   in suirplus.sre_ciudadanos_t.tipo_documento%type,
                                       p_nombres         out suirplus.sre_ciudadanos_t.nombres%type,
                                       p_apellidos       out varchar,
                                       p_nss             out suirplus.sre_ciudadanos_t.id_nss%type,
                                       p_resultnumber    out varchar);

  /******************************************************************************/
  -- Procedimiento: IsExisteCiudadano
  -- Descripcion:   Validar si el ciudadano existe
  -- Creado por:    Gregorio Herrera
  /******************************************************************************/
  PROCEDURE IsExisteCiudadano(p_nrodocumento  IN suirplus.SRE_CIUDADANOS_T.no_documento%TYPE,
                              p_tipodocumento IN suirplus.SRE_CIUDADANOS_T.tipo_documento%TYPE,
                              p_resultnumber  OUT VARCHAR);

  -- **************************************************************************************************
  -- PROCEDIMIENTO:  verificar_ciudadano_existe
  -- DESCRIPCION:    Procedimiento mediante el cual se verifica la existencia de un registro en la tabla de sre_ciudadanos_t.
  -- **************************************************************************************************
  /*   PARAMETROS
         **********************************************************************************************************************************
         *  NOMBRE                   ** TIPO_DATO         **   TIPO_PARAMETRO      **  DESCRIPCION                         **    VALIDACION
         **********************************************************************************************************************************
         * p_no_documento            ** VARCHAR2(25)        **  IN                  ** Numero de documento (cedula / pasaporte)
         * p_tipo_documento          ** VARCHAR2(1)         **  IN                  ** Tipo de documento C (Cedula) P (Pasaporte)
         * p_nombres                 ** VARCHAR2(50)        **  IN                  ** Nombres del ciudadano
         * p_apellidos               ** VARCHAR2(40)        **  IN                  ** Apellidos del ciudadano (Primero / Segundo)
         * p_nss                     ** Number(10)          **  IN                  ** Id nss
         * p_resultnumber            ** VARCHAR2            **  IN/OUT              ** Variable resultado (Si todo sale bien envia 0)
         **********************************************************************************************************************************
         **********************************************************************************************************************************
  */
  PROCEDURE SRE_VERIFICAR_CIUDADANO_EXISTE(p_NumeroDocumento IN suirplus.sre_ciudadanos_t.no_documento%type,
                                           p_TipoDocumento   IN suirplus.sre_ciudadanos_t.tipo_documento%type,
                                           p_Nombres         OUT suirplus.sre_ciudadanos_t.nombres%type,
                                           p_Apellidos       OUT varchar,
                                           p_NSS             OUT suirplus.sre_ciudadanos_t.id_nss%type,
                                           p_ResultNumber    OUT VARCHAR);
  -- **************************************************************************************************
  -- PROCEDIMIENTO:  Consulta_Nss
  -- DESCRIPCION:    Procedimiento mediante el cual se realiza un select a la tabla de ciudadanos por los parametros especificados.
  -- **************************************************************************************************
  /*   PARAMETROS
         **********************************************************************************************************************************
         *  NOMBRE                   ** TIPO_DATO         **   TIPO_PARAMETRO      **  DESCRIPCION                         **    VALIDACION
         **********************************************************************************************************************************
         * p_no_documento            ** VARCHAR2(25)        **  IN                  ** Numero de documento (cedula / pasaporte)
         * p_nss                     ** Number(10)          **  IN                  ** Id nss
         * p_tipo_documento          ** VARCHAR2(1)         **  IN                  ** Tipo de documento C (Cedula) P (Pasaporte)
         * p_nombres                 ** VARCHAR2(50)        **  IN                  ** Nombres del ciudadano
         * p_primer_apellido         ** VARCHAR2(40)        **  IN                  ** Primer apellido del ciudadano
         * p_segundo_apellido        ** VARCHAR2(40)        **  IN                  ** Segundo apellido del ciudadano
         * io_cursor                 **  CURSOR             **  IN/OUT              ** Cursor devuelto        *************************************
         **********************************************************************************************************************************
         **********************************************************************************************************************************
  */
  PROCEDURE Consulta_Nss(p_no_documento     in suirplus.sre_ciudadanos_t.no_documento%TYPE,
                         p_id_nss           in varchar2,
                         p_nombres          in suirplus.sre_ciudadanos_t.nombres%TYPE,
                         p_primer_apellido  in suirplus.sre_ciudadanos_t.primer_apellido%TYPE,
                         p_segundo_apellido in suirplus.sre_ciudadanos_t.segundo_apellido%TYPE,
                         p_ResultNumber     OUT VARCHAR,
                         io_cursor          out t_cursor);
  FUNCTION CancelacionCedula(p_NumeroDocumento IN suirplus.SRE_CIUDADANOS_T.no_documento%TYPE,
                             p_ResultNumber    OUT VARCHAR) RETURN varchar2;
  FUNCTION CancelacionCedulaDesc(p_NumeroDocumento IN suirplus.SRE_CIUDADANOS_T.no_documento%TYPE,
                                 p_ResultNumber    OUT VARCHAR)
    RETURN varchar2;

  PROCEDURE P_CancelacionCedula(p_NumeroDocumento IN suirplus.SRE_CIUDADANOS_T.no_documento%TYPE,
                                p_ResultNumber    OUT VARCHAR);
  /*PROCEDURE CancelacionCedulaDesc(p_NumeroDocumento             IN  SRE_CIUDADANOS_T.no_documento%TYPE,
  p_ResultNumber                OUT VARCHAR);*/
  PROCEDURE CedulaCancelada(p_NumeroDocumento IN suirplus.SRE_CIUDADANOS_T.no_documento%TYPE,
                            io_cursor         OUT t_cursor);

  function Get_Nombres(p_id_nss in number) return varchar2;

  PROCEDURE pageConsulta_Nss(p_no_documento     in suirplus.sre_ciudadanos_t.no_documento%TYPE,
                             p_id_nss           in suirplus.sre_ciudadanos_t.id_nss%type,
                             p_nombres          in suirplus.sre_ciudadanos_t.nombres%TYPE,
                             p_primer_apellido  in suirplus.sre_ciudadanos_t.primer_apellido%TYPE,
                             p_segundo_apellido in suirplus.sre_ciudadanos_t.segundo_apellido%TYPE,
                             p_ResultNumber     OUT VARCHAR,
                             p_pagenum          in number,
                             p_pagesize         in number,
                             io_cursor          out t_cursor);
  --****************************

  -- *****************************************************************************************************
  PROCEDURE crearCiudadano(p_nombres          suirplus.SRE_CIUDADANOS_T.nombres%TYPE,
                           p_primer_apellido  suirplus.SRE_CIUDADANOS_T.primer_apellido%TYPE,
                           p_segundo_apellido suirplus.SRE_CIUDADANOS_T.segundo_apellido%TYPE,
                           p_estado_civil     suirplus.SRE_CIUDADANOS_T.Estado_Civil%TYPE,
                           p_fecha_nacimiento suirplus.SRE_CIUDADANOS_T.Fecha_Nacimiento%TYPE,
                           p_no_documento     suirplus.SRE_CIUDADANOS_T.no_documento%TYPE,
                           p_sexo             suirplus.SRE_CIUDADANOS_T.sexo%TYPE,
                           p_id_provincia     suirplus.SRE_CIUDADANOS_T.Id_Provincia%TYPE,
                           p_id_tipo_sangre   suirplus.SRE_CIUDADANOS_T.Id_Tipo_Sangre%TYPE,
                           p_id_nacionalidad  suirplus.SRE_CIUDADANOS_T.Id_Nacionalidad%TYPE,
                           p_nombre_padre     suirplus.SRE_CIUDADANOS_T.Nombre_Padre%TYPE,
                           p_nombre_madre     suirplus.SRE_CIUDADANOS_T.Nombre_Madre%TYPE,
                           p_municipio_acta   suirplus.SRE_CIUDADANOS_T.Municipio_Acta%TYPE,
                           p_oficialia_acta   suirplus.SRE_CIUDADANOS_T.Oficialia_Acta%TYPE,
                           p_libro_acta       suirplus.SRE_CIUDADANOS_T.Libro_Acta%TYPE,
                           p_folio_acta       suirplus.SRE_CIUDADANOS_T.Folio_Acta%TYPE,
                           p_numero_acta      suirplus.SRE_CIUDADANOS_T.Numero_Acta%TYPE,
                           p_ano_acta         suirplus.SRE_CIUDADANOS_T.Ano_Acta%TYPE,
                           p_cedula_anterior  suirplus.SRE_CIUDADANOS_T.Cedula_Anterior%TYPE,
                           p_ult_usuario_act  suirplus.SRE_CIUDADANOS_T.ULT_USUARIO_ACT%TYPE,
                           p_ImagenActa       suirplus.sre_ciudadanos_t.imagen_acta%type,
                           p_resultnumber     IN OUT VARCHAR);

  PROCEDURE getTipoSangre(p_iocursor     out t_cursor,
                          p_resultnumber IN OUT VARCHAR);

  PROCEDURE getNacionalidad(p_iocursor     out t_cursor,
                            p_resultnumber IN OUT VARCHAR);

  -- *****************************************************************************************************
  -- Procedimiento que Registrar un Acta de Nacimiento
  --*****************************************************************************************************
  PROCEDURE RegistrarActaNacimiento(p_nombres          suirplus.SRE_CIUDADANOS_T.nombres%TYPE,
                                    p_primer_apellido  suirplus.SRE_CIUDADANOS_T.primer_apellido%TYPE,
                                    p_segundo_apellido suirplus.SRE_CIUDADANOS_T.segundo_apellido%TYPE,
                                    p_fecha_nacimiento suirplus.SRE_CIUDADANOS_T.Fecha_Nacimiento%TYPE,
                                    p_no_documento     suirplus.SRE_CIUDADANOS_T.no_documento%TYPE,
                                    p_sexo             suirplus.SRE_CIUDADANOS_T.Sexo%TYPE,
                                    p_nombre_padre     suirplus.SRE_CIUDADANOS_T.Nombre_Padre%TYPE,
                                    p_nombre_madre     suirplus.SRE_CIUDADANOS_T.Nombre_Madre%TYPE,
                                    p_municipio_acta   suirplus.SRE_CIUDADANOS_T.Municipio_Acta%TYPE,
                                    p_oficialia_acta   suirplus.SRE_CIUDADANOS_T.Oficialia_Acta%TYPE,
                                    p_libro_acta       suirplus.SRE_CIUDADANOS_T.Libro_Acta%TYPE,
                                    p_folio_acta       suirplus.SRE_CIUDADANOS_T.Folio_Acta%TYPE,
                                    p_numero_acta      suirplus.SRE_CIUDADANOS_T.Numero_Acta%TYPE,
                                    p_ano_acta         suirplus.SRE_CIUDADANOS_T.Ano_Acta%TYPE,
                                    p_ult_usuario_act  suirplus.SRE_CIUDADANOS_T.ULT_USUARIO_ACT%TYPE,
                                    p_ImagenActa       suirplus.sre_ciudadanos_t.imagen_acta%type,
                                    p_resultnumber     IN OUT VARCHAR);
  ------------------------------------------------------------------------------------------------------------
  ----Procedimiento que Verifica si un ciudadano existe pasandole el nombre, apellido y la fecha de nacimiento
  ----Mayreni Vargas
  ------------------------------------------------------------------------------------------------------------
  PROCEDURE Validar_Existe_Ciudadano(p_Nombres         in suirplus.SRE_CIUDADANOS_T.nombres%TYPE,
                                     p_PrimerApellido  in suirplus.SRE_CIUDADANOS_T.Primer_Apellido%TYPE,
                                     p_SegundoApellido in suirplus.SRE_CIUDADANOS_T.Segundo_Apellido%TYPE,
                                     p_FechaNac        in suirplus.SRE_CIUDADANOS_T.Fecha_Nacimiento%TYPE,
                                     p_ResultNumber    OUT VARCHAR);

  -- **************************************************************************************************
  -- Program:     function IsMadre
  -- Description: funcion que retorna la existencia de una madre.

  -- **************************************************************************************************

  function isMadre(p_idnss varchar2) return varchar2;

  -------------------------------------------
  -- procedimiento para registrar los menores extranjerons
  -- cha. 16-04-2009.
  -------------------------------------------
  procedure RegistroMenorExtranjero(p_nombres          in suirplus.sre_ciudadanos_t.nombres%type,
                                    p_primer_apellido  in suirplus.sre_ciudadanos_t.primer_apellido%type,
                                    p_segundo_apellido in suirplus.sre_ciudadanos_t.primer_apellido%type,
                                    p_fecha_nacimiento in suirplus.sre_ciudadanos_t.fecha_nacimiento%type,
                                    p_sexo             in suirplus.sre_ciudadanos_t.sexo%TYPE,
                                    p_id_nacionalidad  in suirplus.sre_ciudadanos_t.id_nacionalidad%type,
                                    p_nss_titular      in suirplus.sre_menores_ext_t.nss_titular%type,
                                    p_ult_usuario_act  in suirplus.sre_ciudadanos_t.ult_usuario_act%type,
                                    p_ImagenActa       in suirplus.sre_ciudadanos_t.imagen_acta%type,
                                    p_resultnumber     out varchar2);

  -------------------------------------------------------------
  -- procedimiento para obtener los menores extrangeros
  -- FR. 16/04/2009
  -----------------------------------------------------
  procedure ObtenerMenorExtranjero(p_nombres          in suirplus.sre_ciudadanos_t.nombres%type,
                                   p_primer_apellido  in suirplus.sre_ciudadanos_t.primer_apellido%type,
                                   p_segundo_apellido in suirplus.sre_ciudadanos_t.primer_apellido%type,
                                   p_io_cursor        out t_cursor,
                                   p_result_number    IN OUT VARCHAR);

  /***********************************************************************************
  -- Milciades Hernández
  -- 14/01/2010
  -- Actualizar_Ciudadano
  -- Proceso que actualiza ciudadanos..
   *-**********************************************************************************/

  PROCEDURE Insertar_Ciudadano_act(p_id_nss           suirplus.SRE_CIUDADANOS_T.id_nss%TYPE,
                                   p_no_documento     suirplus.SRE_CIUDADANOS_T.no_documento%TYPE,
                                   p_nombres          suirplus.SRE_CIUDADANOS_T.nombres%TYPE,
                                   p_primer_apellido  suirplus.SRE_CIUDADANOS_T.primer_apellido%TYPE,
                                   p_segundo_apellido suirplus.SRE_CIUDADANOS_T.segundo_apellido%TYPE,
                                   p_fecha_nacimiento suirplus.SRE_CIUDADANOS_T.FECHA_NACIMIENTO%TYPE,
                                   p_sexo             suirplus.SRE_CIUDADANOS_T.sexo%TYPE,
                                   p_ult_usuario_act  suirplus.SRE_CIUDADANOS_T.ult_usuario_act%TYPE,
                                   p_resultnumber     IN OUT VARCHAR);

  --Verifica si ciudadanos existe
  PROCEDURE getconsultaciudadanoact(p_id_nss       suirplus.SRE_CIUDADANOS_T.id_nss%TYPE,
                                    p_resultnumber OUT VARCHAR2,
                                    p_io_cursor    IN OUT T_CURSOR);

  /*
  procedure Actualizar_Ciudadano(
             p_nombres               SRE_CIUDADANOS_T.nombres%TYPE,
             p_primer_apellido       SRE_CIUDADANOS_T.primer_apellido%TYPE,
             p_segundo_apellido      SRE_CIUDADANOS_T.segundo_apellido%TYPE,
             p_fecha_nacimiento      SRE_CIUDADANOS_T.FECHA_NACIMIENTO%TYPE,
             p_sexo                  SRE_CIUDADANOS_T.sexo%TYPE,
             p_no_documento          SRE_CIUDADANOS_T.no_documento%TYPE,
             p_tipo_documento        SRE_CIUDADANOS_T.tipo_documento%TYPE,
             p_ult_usuario_act       SRE_CIUDADANOS_T.ult_usuario_act%TYPE,
             p_resultnumber          IN  OUT VARCHAR);
             */
  /*PROCEDURE Aplicar_Ciudadano(
  p_nombres              SRE_CIUDADANOS_T.nombres%TYPE,
  p_primer_apellido       SRE_CIUDADANOS_T.primer_apellido%TYPE,
  p_segundo_apellido      SRE_CIUDADANOS_T.segundo_apellido%TYPE,
  p_fecha_nacimiento      SRE_CIUDADANOS_T.FECHA_NACIMIENTO%TYPE,
  p_sexo                  SRE_CIUDADANOS_T.sexo%TYPE,
  p_no_documento          SRE_CIUDADANOS_T.no_documento%TYPE,
  p_tipo_documento        SRE_CIUDADANOS_T.tipo_documento%TYPE,
  p_ult_usuario_act       SRE_CIUDADANOS_T.ult_usuario_act%TYPE,
  p_resultnumber          IN  OUT VARCHAR);     */

  PROCEDURE Aplicar_Ciudadano(p_sequence     suirplus.SRE_CIU_CAMBIOS_T.ID_SECUENCIA%TYPE,
                              p_resultnumber IN OUT VARCHAR);

  --buscar ciudadanos de sre_ciud_cambios_t
  procedure buscarciudadanos(p_resultnumber out varchar2,
                             p_io_cursor    in out t_cursor);

  PROCEDURE getconsultaciudcambio(p_id_nss       suirplus.SRE_CIUDADANOS_T.id_nss%TYPE,
                                  p_resultnumber OUT VARCHAR2,
                                  p_io_cursor    IN OUT T_CURSOR);

  --***************************************************************************************--
  --procesa un ciudadano, si no existe lo inserta..
  --by cmha
  --20/6/2012
  --***************************************************************************************--
  PROCEDURE procesarCiudadanoTSS(p_no_documento         suirplus.SRE_CIUDADANOS_T.no_documento%TYPE,
                                 p_nombres              suirplus.SRE_CIUDADANOS_T.nombres%TYPE,
                                 p_primer_apellido      suirplus.SRE_CIUDADANOS_T.primer_apellido%TYPE,
                                 p_segundo_apellido     suirplus.SRE_CIUDADANOS_T.segundo_apellido%TYPE,
                                 p_estado_civil         suirplus.SRE_CIUDADANOS_T.Estado_Civil%TYPE,
                                 p_fecha_nacimiento     suirplus.SRE_CIUDADANOS_T.Fecha_Nacimiento%TYPE,
                                 p_sexo                 suirplus.SRE_CIUDADANOS_T.sexo%TYPE,
                                 p_id_tipo_sangre       suirplus.SRE_CIUDADANOS_T.Id_Tipo_Sangre%TYPE,
                                 p_id_nacionalidad      suirplus.SRE_CIUDADANOS_T.Id_Nacionalidad%TYPE,
                                 p_nombre_padre         suirplus.SRE_CIUDADANOS_T.Nombre_Padre%TYPE,
                                 p_nombre_madre         suirplus.SRE_CIUDADANOS_T.Nombre_Madre%TYPE,
                                 p_municipio_acta       suirplus.SRE_CIUDADANOS_T.Municipio_Acta%TYPE,
                                 p_oficialia_acta       suirplus.SRE_CIUDADANOS_T.Oficialia_Acta%TYPE,
                                 p_libro_acta           suirplus.SRE_CIUDADANOS_T.Libro_Acta%TYPE,
                                 p_folio_acta           suirplus.SRE_CIUDADANOS_T.Folio_Acta%TYPE,
                                 p_numero_acta          suirplus.SRE_CIUDADANOS_T.Numero_Acta%TYPE,
                                 p_ano_acta             suirplus.SRE_CIUDADANOS_T.Ano_Acta%TYPE,
                                 p_tipo_causa           suirplus.SRE_CIUDADANOS_T.tipo_causa%TYPE,
                                 p_id_causa_inhabilidad suirplus.SRE_CIUDADANOS_T.id_causa_inhabilidad%TYPE,
                                 p_status               suirplus.SRE_CIUDADANOS_T.Status%TYPE,
                                 p_ult_usuario_act      suirplus.SRE_CIUDADANOS_T.ULT_USUARIO_ACT%TYPE,
                                 p_accion               in varchar,
                                 p_resultnumber         IN OUT VARCHAR);

  --***************************************************************************************--
  --busca los datos de los ciudadanos
  --26/07/2011
  --***************************************************************************************--
  procedure getCiudadano(p_no_documento     in suirplus.sre_ciudadanos_t.no_documento%type,
                         p_nombres          suirplus.SRE_CIUDADANOS_T.nombres%TYPE,
                         p_primer_apellido  suirplus.SRE_CIUDADANOS_T.primer_apellido%TYPE,
                         p_segundo_apellido suirplus.SRE_CIUDADANOS_T.segundo_apellido%TYPE,
                         p_fecha_nacimiento suirplus.SRE_CIUDADANOS_T.Fecha_Nacimiento%TYPE,
                         p_municipio_acta   suirplus.SRE_CIUDADANOS_T.Municipio_Acta%TYPE,                         
                         p_ano_acta         suirplus.SRE_CIUDADANOS_T.Ano_Acta%TYPE,
                         p_numero_acta      suirplus.SRE_CIUDADANOS_T.Numero_Acta%TYPE,
                         p_folio_acta       suirplus.SRE_CIUDADANOS_T.Folio_Acta%TYPE,
                         p_libro_acta       suirplus.SRE_CIUDADANOS_T.Libro_Acta%TYPE,
                         p_oficilia_acta    suirplus.SRE_CIUDADANOS_T.Oficialia_Acta%TYPE,
                         p_iocursor         out t_cursor,
                         p_resultnumber     out varchar2);

  --***************************************************************************************--
  --busca los datos de un ciudadano a partir de su NSS
  --by Gregorio Herrera
  --30/06/2015
  --***************************************************************************************--
  procedure getCiudadanoNSS(p_id_nss       in suirplus.sre_ciudadanos_t.id_nss%type,
                            p_iocursor     out t_cursor,
                            p_resultnumber out varchar2);

  --***************************************************************************************--
  --busca los datos de los ciudadanos con coincidencia
  --by Gregorio Herrera
  --30/06/2015
  --***************************************************************************************--
  procedure getCiudadanoDup(p_no_documento     in suirplus.sre_ciudadanos_t.no_documento%type,
                            p_nombres          suirplus.SRE_CIUDADANOS_T.nombres%TYPE,
                            p_primer_apellido  suirplus.SRE_CIUDADANOS_T.primer_apellido%TYPE,
                            p_segundo_apellido suirplus.SRE_CIUDADANOS_T.segundo_apellido%TYPE,
                            p_fecha_nacimiento suirplus.SRE_CIUDADANOS_T.Fecha_Nacimiento%TYPE,
                            p_sexo             suirplus.SRE_CIUDADANOS_T.Sexo%TYPE,                            
                            p_municipio_acta   suirplus.SRE_CIUDADANOS_T.Municipio_Acta%TYPE,
                            p_ano_acta         suirplus.SRE_CIUDADANOS_T.Ano_Acta%TYPE,
                            p_numero_acta      suirplus.SRE_CIUDADANOS_T.Numero_Acta%TYPE,
                            p_folio_acta       suirplus.SRE_CIUDADANOS_T.Folio_Acta%TYPE,
                            p_libro_acta       suirplus.SRE_CIUDADANOS_T.Libro_Acta%TYPE,
                            p_oficilia_acta    suirplus.SRE_CIUDADANOS_T.Oficialia_Acta%TYPE,
                            p_iocursor         out t_cursor,
                            p_resultnumber     out varchar2);

  --***************************************************************************************--
  --procesa un ciudadano, si no existe lo inserta, de lo contrario lo actualiza...
  --by charlie pena
  --02/ago/2011
  --***************************************************************************************--
  PROCEDURE procesarCiudadano(p_no_documento         suirplus.SRE_CIUDADANOS_T.no_documento%TYPE,
                              p_nombres              suirplus.SRE_CIUDADANOS_T.nombres%TYPE,
                              p_primer_apellido      suirplus.SRE_CIUDADANOS_T.primer_apellido%TYPE,
                              p_segundo_apellido     suirplus.SRE_CIUDADANOS_T.segundo_apellido%TYPE,
                              p_estado_civil         suirplus.SRE_CIUDADANOS_T.Estado_Civil%TYPE,
                              p_fecha_nacimiento     suirplus.SRE_CIUDADANOS_T.Fecha_Nacimiento%TYPE,
                              p_sexo                 suirplus.SRE_CIUDADANOS_T.sexo%TYPE,
                              p_id_tipo_sangre       suirplus.SRE_CIUDADANOS_T.Id_Tipo_Sangre%TYPE,
                              p_id_nacionalidad      suirplus.SRE_CIUDADANOS_T.Id_Nacionalidad%TYPE,
                              p_nombre_padre         suirplus.SRE_CIUDADANOS_T.Nombre_Padre%TYPE,
                              p_nombre_madre         suirplus.SRE_CIUDADANOS_T.Nombre_Madre%TYPE,
                              p_municipio_acta       suirplus.SRE_CIUDADANOS_T.Municipio_Acta%TYPE,
                              p_oficialia_acta       suirplus.SRE_CIUDADANOS_T.Oficialia_Acta%TYPE,
                              p_libro_acta           suirplus.SRE_CIUDADANOS_T.Libro_Acta%TYPE,
                              p_folio_acta           suirplus.SRE_CIUDADANOS_T.Folio_Acta%TYPE,
                              p_numero_acta          suirplus.SRE_CIUDADANOS_T.Numero_Acta%TYPE,
                              p_ano_acta             suirplus.SRE_CIUDADANOS_T.Ano_Acta%TYPE,
                              p_tipo_causa           suirplus.SRE_CIUDADANOS_T.tipo_causa%TYPE,
                              p_id_causa_inhabilidad suirplus.SRE_CIUDADANOS_T.id_causa_inhabilidad%TYPE,
                              p_status               suirplus.SRE_CIUDADANOS_T.Status%TYPE,
                              p_ult_usuario_act      suirplus.SRE_CIUDADANOS_T.ULT_USUARIO_ACT%TYPE,
                              p_accion               in varchar,
                              p_fecha_cancelacion    in suirplus.sre_ciudadanos_cancelados_t.fecha_de_cancelacion%type,
                              p_nss                  in out suirplus.SRE_CIUDADANOS_T.ID_NSS%TYPE,
                              p_resultnumber         IN OUT VARCHAR2);

  --***************************************************************************************--
  --busca los parametros de conección con el webservice de la jce
  --10/08/2011
  -- by charlie pena
  --***************************************************************************************--
  procedure getWS_JCE_Parametros(p_id_modulo    in suirplus.srp_config_t.id_modulo%type,
                                 p_iocursor     in out t_cursor,
                                 p_resultnumber out varchar2);

  ---------------------------------------------------
  -- Borra los ultimos 7 dias de data a partir de hoy
  ---------------------------------------------------
  procedure Borrar_Ult_7_Dias_Ciudadanos;

  /*
  ----------------------------------------------------------------------
  Procedure: Insertar_Ciudadano_Cancelado
  Autor    : Gregorio Herrera
  Objectivo: Insertar en la tabla SUIRPLUS.SRE_CIUDADANOS_CANCELADOS_T al
             momento de inhabilitar o habilitar nuevamente un ciudadano
  Fecha    : 19/07/2012
  -----------------------------------------------------------------------
  */
  Procedure Insertar_Ciudadano_Cancelado(p_id_oficio            suirplus.ofc_oficios_t.id_oficio%type,
                                         p_id_nss               suirplus.sre_ciudadanos_t.id_nss%type,
                                         p_tipo_causa           suirplus.sre_inhabilidad_jce_t.tipo_causa%type,
                                         p_id_causa_inhabilidad suirplus.sre_inhabilidad_jce_t.id_causa_inhabilidad%type,
                                         p_fecha_cancelacion    date,
                                         p_ult_usuario_act      suirplus.seg_usuario_t.id_usuario%type);

  /*
  ----------------------------------------------------------------------
  Procedure: Pasaporte_Crear
  Autor    : Eury Vallejo
  Objectivo: Insertar en la tabla SUIRPLUS.SRE_PASAPORTES_T al
             momento de inhabilitar o habilitar nuevamente un ciudadano
  Fecha    : 19/07/2012
  -----------------------------------------------------------------------
  */
  PROCEDURE Pasaporte_Crear(p_id_registro_patronal in decimal,
                            p_nro_pasaporte        suirplus.SRE_CIUDADANOS_T.No_Documento%TYPE,
                            p_nombres              suirplus.SRE_CIUDADANOS_T.nombres%TYPE,
                            p_primer_apellido      suirplus.SRE_CIUDADANOS_T.primer_apellido%TYPE,
                            p_segundo_apellido     suirplus.SRE_CIUDADANOS_T.segundo_apellido%TYPE,
                            p_fecha_nacimiento     suirplus.SRE_CIUDADANOS_T.FECHA_NACIMIENTO%TYPE,
                            p_sexo                 suirplus.SRE_CIUDADANOS_T.sexo%TYPE,
                            p_nacionalidad         suirplus.sre_ciudadanos_t.id_nacionalidad%TYPE,
                            p_status               suirplus.sre_pasaportes_t.status%TYPE,
                            p_ult_usuario_act      suirplus.SRE_CIUDADANOS_T.ult_usuario_act%TYPE,
                            p_imagen_p             suirplus.sre_pasaportes_t.imagen_p%TYPE,
                            p_fecha_registro       suirplus.sre_pasaportes_t.fecha_registro%TYPE,
                            p_resultnumber         IN OUT VARCHAR);

  /*
  ----------------------------------------------------------------------
  Procedure: Obtener_Pasaportes
  Autor    : Eury Vallejo
  Objectivo: Obtiene un resultado de pasaportes utilizando registro patronal y fecha_registro
  Fecha    : 19/07/2012
  -----------------------------------------------------------------------
  */

  procedure getPasaportes_registrados(p_id_registro_patronal suirplus.sre_pasaportes_t.id_registro_patronal%TYPE,
                                      p_fecha_desde          suirplus.sre_pasaportes_t.fecha_registro%TYPE,
                                      p_fecha_hasta          suirplus.sre_pasaportes_t.fecha_registro%TYPE,
                                      p_iocursor             in out t_cursor,
                                      p_resultnumber         out varchar2);

  /*
    ----------------------------------------------------------------------
    Procedure: Get pasaportes registrados para evaluacion
    Autor    : Eury Vallejo
    Objectivo: Obtiene un resultado un listado de pasaportes
    Fecha    : 19/07/2012
    -----------------------------------------------------------------------
  */
  procedure getDatosPasaportesEvaluacion(p_iocursor     in out t_cursor,
                                         p_resultnumber out varchar2);
  /*
    ----------------------------------------------------------------------
    Procedure: Get Empleadores han creado pasaporte
    Autor    : Eury Vallejo
    Objectivo: obtiene un listado de empleadores que han creado pasaporte
    Fecha    : 19/07/2012
    -----------------------------------------------------------------------
  */
  procedure getEmpleadoresConPasaporte(p_iocursor     in out t_cursor,
                                       p_resultnumber out varchar2);

  /*
    ----------------------------------------------------------------------
    Procedure: Get Imagen pasaporte
    Autor    : Eury Vallejo
    Objectivo: obtiene una imagen del pasaporte creado
    Fecha    : 19/07/2012
    -----------------------------------------------------------------------
  */
  procedure getImagenPasaporte(p_nro_pasaporte suirplus.SRE_CIUDADANOS_T.No_Documento%TYPE,
                               p_iocursor      in out t_cursor,
                               p_resultnumber  out varchar2);

/*
    ----------------------------------------------------------------------
    Procedure: getImagenNSS
    Autor    : Gregorio Herrera
    Objectivo: obtiene una imagen de un NSS
    Fecha    : 29/06/2015
    -----------------------------------------------------------------------
  */
  procedure getImagenNSS(p_id_nss       suirplus.SRE_CIUDADANOS_T.id_nss%TYPE,
                         p_iocursor     in out t_cursor,
                         p_resultnumber out varchar2);

  /*
    ----------------------------------------------------------------------
    Procedure: Rechazar Pasaporte
    Autor    : Eury Vallejo
    Objectivo: obtiene una imagen del pasaporte creado
    Fecha    : 19/07/2012
    -----------------------------------------------------------------------
  */
  procedure RechazarPasaporte(p_nro_pasaporte suirplus.Sre_Pasaportes_t.Pasaporte%TYPE,
                              p_motivo        suirplus.Sre_Pasaportes_t.Id_Motivo%TYPE,
                              p_resultnumber  out varchar2);

  /*
    ----------------------------------------------------------------------
    Procedure: Get Motivos rechazo pasaporte
    Autor    : Eury Vallejo
    Objectivo: --------------------------------------------
    Fecha    : 19/07/2012
    -----------------------------------------------------------------------
  */
  procedure getMotivosPasaporte(p_iocursor     in out t_cursor,
                                p_resultnumber out varchar2);

  /*
    ----------------------------------------------------------------------
    Procedure: AprobarPasaporteCiudadano
    Autor    : Eury Vallejo
    Objectivo: aprueba el pasaporte y registra la informacion del pasaporte en sre_ciudadano_t
    Fecha    : 19/07/2012
    -----------------------------------------------------------------------
  */
  procedure AprobarPasaporteCiudadano(p_nro_pasaporte   suirplus.Sre_Pasaportes_t.Pasaporte%TYPE,
                                      p_ult_usuario_act suirplus.Sre_Pasaportes_t.Ult_Usuario_Act%TYPE,
                                      p_resultnumber    out varchar2);

  ----******************************************************************************---
  -- 15/10/2014
  -- verficamos de los catalogos las descriciones de los tipos causa inhabilidad, 
  -- tipo sangre, nacionalidad y municipio. 
  ----******************************************************************************---
  procedure getComplementoCiudadano(p_idMunicipio        in varchar2,
                                    p_idSangre           in varchar2,
                                    p_idNacionalidad     in varchar2,
                                    p_idCausaInhabilidad in varchar2,
                                    p_tipocausa          in varchar2,
                                    p_iocursor           in out t_cursor,
                                    p_resultnumber       out varchar2);

  ---verfiicamos si el valor es numerico 
  FUNCTION is_number(p_string IN VARCHAR2) RETURN INT;

  ----------------------------------------------------------------------------------
  -- Actualizamos el limite de consulta JCE e insertamos en sre_trans_jce_t para ser llamado desde la pagina
  --*******************************************************************************--
  procedure prc_trans_limite(p_nro_documento  varchar2,
                             p_tipo_documento varchar2);

  ---------------------------------------------------------------------------------
  --buscamo el motivo de error por la cual se rechazo el ciudadanos---
  ---------------------------------------------------------------------------------
  function getMotivoRechazo(p_error in varchar2) return varchar2;

end SRE_CIUDADANO_PKG;
