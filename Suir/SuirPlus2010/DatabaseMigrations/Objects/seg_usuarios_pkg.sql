create or replace package suirplus.seg_usuarios_pkg is

  -- Author  : HECTOR_MINAYA
  -- Created : 11/12/2004 1:33:33 AM
  -- Purpose : Manejo de Usuarios en el modulo de seguridad

  type t_cursor is ref cursor;

  procedure Login(p_idusuario    in suirplus.seg_usuario_t.id_usuario%type,
                  p_class        in suirplus.seg_usuario_t.password%type,
                  p_ip           varchar2,
                  p_tipousuario  varchar2,
                  p_servidor in suirplus.seg_log_t.servidor%type,
                  p_resultnumber out varchar2);
                  
  procedure Login(p_idusuario    in suirplus.seg_usuario_t.id_usuario%type,
                  p_class        in suirplus.seg_usuario_t.password%type,
                  p_ip           varchar2,
                  p_tipousuario  varchar2,
                  p_resultnumber out varchar2);                  
                  
  procedure ReseteoClass(p_idusuario    in suirplus.seg_usuario_t.id_usuario%type,
                         p_classNew     out suirplus.seg_usuario_t.password%type,
                         p_resultnumber out varchar2);
  procedure CambioClass(p_idusuario    in suirplus.seg_usuario_t.id_usuario%type,
                        p_classNew     in suirplus.seg_usuario_t.password%type,
                        p_classOld     in suirplus.seg_usuario_t.password%type,
                        p_resultnumber out varchar2);
  procedure Usuarios_sin_Role(p_IDRole       in suirplus.seg_roles_t.id_role%type,
                              p_IOCursor     in out t_Cursor,
                              p_resultnumber out varchar2);

  procedure Usuarios_sin_Permiso(p_IDPermiso    in suirplus.seg_permiso_t.id_permiso%type,
                                 p_IOCursor     in out t_Cursor,
                                 p_resultnumber out varchar2);

  procedure Actualizar_UsuarioRep(p_IDUsuario          in suirplus.seg_usuario_t.id_usuario%type,
                                  p_Tipo_Representante in suirplus.sre_representantes_t.tipo_representante%type,
                                  p_Email              in suirplus.seg_usuario_t.email%type,
                                  p_UltUsuarioAct      in suirplus.seg_usuario_t.ult_usuario_act%type,
                                  p_ResultNumber       out varchar2);

  procedure Insertar_UsuarioRep(p_idusuario          in suirplus.seg_usuario_t.id_usuario%type,
                                p_password           in suirplus.seg_usuario_t.password%type,
                                p_idnss              in suirplus.seg_usuario_t.id_nss%type,
                                p_idregistropatronal in suirplus.seg_usuario_t.id_registro_patronal%type,
                                p_email              in suirplus.seg_usuario_t.email%type,
                                p_ultusuarioact      in suirplus.seg_usuario_t.ult_usuario_act%type,
                                p_tipo_representante in suirplus.sre_representantes_t.tipo_representante%type,
                                p_resultnumber       out varchar2);



  procedure Insertar_UsuarioPersona(p_idusuario          in suirplus.seg_usuario_t.id_usuario%type,
                                p_password           in suirplus.seg_usuario_t.password%type,
                                p_idnss              in suirplus.seg_usuario_t.id_nss%type,
                                p_idregistropatronal in suirplus.seg_usuario_t.id_registro_patronal%type,
                                p_email              in suirplus.seg_usuario_t.email%type,
                                p_ultusuarioact      in suirplus.seg_usuario_t.ult_usuario_act%type,
                                p_tipo_representante in suirplus.sre_representantes_t.tipo_representante%type,
                                p_resultnumber       out varchar2);

  procedure Inactivar_UsuarioRep(p_IDUsuario     in suirplus.seg_usuario_t.id_usuario%type,
                                 p_UltUsuarioAct in suirplus.seg_usuario_t.ult_usuario_act%type,
                                 p_ResultNumber  out varchar2);

   -- **************************************************************************************************
  -- Procedure: Actualizar_Usuario
  -- Description: Actualiza el status del usuario a peticion (B=bloqueado A=activo, I=inactivo)
  -- by: Kerlin De La Cruz
  -- fecha: 11/01/2017
  -- **************************************************************************************************
  
Procedure Actualizar_Usuario(p_usuario in suirplus.seg_usuario_t.id_usuario%type,
							               p_status in suirplus.seg_usuario_t.status%type,
                             p_link_params   in varchar2,                             
                             p_resultnumber OUT varchar2);

 -- **************************************************************************************************
  -- Procedure: Desbloquear_Usuario
  -- Description: Desbloquea el usuario
  -- by: Kerlin De La Cruz
  -- fecha: 12/01/2017
  -- **************************************************************************************************
  
 PROCEDURE DesbloquearUsuario(p_idusuario    in suirplus.seg_usuario_t.id_usuario%type,
                               p_status       in suirplus.seg_usuario_t.status%type,                             
                               p_accion       in varchar2,
                               p_resultnumber OUT varchar2);

  procedure Roles_Activos(p_IDUsuario    in suirplus.seg_usuario_t.id_usuario%type,
                          p_IOCursor     in out t_Cursor,
                          p_ResultNumber out varchar2);

  procedure Permisos_Activos(p_IDUsuario    in suirplus.seg_usuario_t.id_usuario%type,
                             p_IOCursor     in out t_Cursor,
                             p_ResultNumber out varchar2);

  procedure Menu_Get_Secciones(p_IDUsuario    in suirplus.seg_usuario_t.id_usuario%type,
                               p_IOCursor     in out t_Cursor,
                               p_ResultNumber out varchar2);

  procedure Menu_Permisos_Por_Seccion(p_IDUsuario    in suirplus.seg_usuario_t.id_usuario%type,
                                      p_IDSeccion    in suirplus.seg_seccion_t.id_seccion%type,
                                      p_IOCursor     in out t_Cursor,
                                      p_ResultNumber out varchar2);

  procedure Get_Usuarios(p_idusuario in suirplus.seg_usuario_t.id_usuario%type,
                         p_nombres   in suirplus.seg_usuario_t.nombre_usuario%type,
                         p_apellidos in suirplus.seg_usuario_t.apellidos%type,
                         p_role      in suirplus.seg_roles_t.id_role%type,
                         p_idEntidad in suirplus.sfc_entidad_recaudadora_t.id_entidad_recaudadora%type,
                         p_iocursor  in out t_cursor);

  procedure Crear_Usuario(p_IDUsuario        suirplus.seg_usuario_t.id_usuario%type,
                          p_Password         suirplus.seg_usuario_t.password%type,
                          p_NombreUsuario    suirplus.seg_usuario_t.NOMBRE_USUARIO%type,
                          p_ApellidosUsuario suirplus.seg_usuario_t.APELLIDOS%type,
                          p_Email            suirplus.seg_usuario_t.email%type,
                          p_Estatus          suirplus.seg_usuario_t.status%type,
                          p_UltUsuarioAct    suirplus.seg_usuario_t.ULT_USUARIO_ACT%type,
                          p_departamento     suirplus.seg_usuario_t.departamento%type,
                          p_eRecaudadora     suirplus.seg_usuario_t.id_entidad_recaudadora%type,
                          p_comentario       suirplus.seg_usuario_t.comentario%type,
                          p_ResultNumber     out varchar2);
                          
  -- **************************************************************************************************
  -- Program:     Crear_UsuarioExterno
  -- Description: Este metodo crea un usuario para el registro de empleadores externos
  -- Modification: Eury Vallejo
  -- **************************************************************************************************

   procedure Crear_UsuarioExterno(p_idusuario        suirplus.seg_usuario_t.id_usuario%type,
                                 p_tipo_documento suirplus.seg_usuario_t.id_usuario%type,
                          p_password         suirplus.seg_usuario_t.password%type,
                          p_nombreusuario    in out suirplus.seg_usuario_t.nombre_usuario%type,
                          p_apellidosusuario in out suirplus.seg_usuario_t.apellidos%type,
                          p_email            suirplus.seg_usuario_t.email%type,
                          p_estatus          suirplus.seg_usuario_t.status%type,
                          p_ultusuarioact    suirplus.seg_usuario_t.ult_usuario_act%type,
                          p_resultnumber out varchar2);                          
                          

  procedure Borrar_Usuario(p_IDUsuario    suirplus.seg_usuario_t.id_usuario%type,
                           p_ResultNumber out varchar2);

  procedure Editar_Usuario(p_id_usuario        suirplus.seg_usuario_t.id_usuario%type,
                           p_password          suirplus.seg_usuario_t.password%type, -- *  parametros para insertar usuario
                           p_nombre_usuario    suirplus.seg_usuario_t.nombre_usuario%type,
                           p_apellidos_usuario suirplus.seg_usuario_t.apellidos%type,
                           p_email             suirplus.seg_usuario_t.email%type,
                           p_estatus           suirplus.seg_usuario_t.status%type,
                           p_ult_usuario_act   suirplus.seg_usuario_t.ult_usuario_act%type,
                           p_departamento      suirplus.seg_usuario_t.departamento%type,
                           p_eRecaudadora      suirplus.seg_usuario_t.id_entidad_recaudadora%type,
                           p_comentario        suirplus.seg_usuario_t.comentario%type,
                           p_resultnumber      out varchar2);

  procedure Eliminar_Perm_Usuario(p_id_permiso      suirplus.seg_permiso_t.id_permiso%type,
                                  p_id_role         suirplus.seg_roles_t.id_role%type,
                                  p_id_usuario      suirplus.seg_usuario_t.id_usuario%type,
                                  p_ult_usuario_act suirplus.seg_usuario_t.id_usuario%type,
                                  p_resultnumber    out varchar2);

  procedure Asignar_Perm_Usuario(p_id_permiso      suirplus.seg_permiso_t.id_permiso%type,
                                 p_id_role         suirplus.seg_roles_t.id_role%type,
                                 p_id_usuario      suirplus.seg_usuario_t.id_usuario%type,
                                 p_ult_usuario_act suirplus.seg_usuario_t.id_usuario%type,
                                 p_resultnumber    out varchar2);

  procedure Usuarios_Permiso(p_id_permiso   in number,
                             p_io_cursor    in out t_cursor,
                             p_resultnumber out varchar2);

  procedure Usuarios_Role(p_id_role      in number,
                          p_io_cursor    in out t_cursor,
                          p_resultnumber out varchar2);

  procedure LogError(p_mensaje in suirplus.seg_errores_t.DESCRIPCION%type,
                     p_usuario in suirplus.seg_errores_t.usuario%type);

  function isExisteUsuario(p_idusuario varchar2) return boolean;

  function isExisteRepresentante(p_id_usuario varchar2) return boolean;

  function isExisteEntRecaudadora(p_id_entidad_recaudadora varchar2)
    return boolean;

  function getNombreUsuario(p_id_usuario suirplus.sre_archivos_t.usuario_carga%type)
    return varchar;

  -- **************************************************************************************************
  -- Program:     getMenuItems
  -- Description: Trae los permisos que tiene un usuario en el suirplus
  -- Autor: Roberto Jaquez
  -- Fecha: Julio 6, 2007.
  -- **************************************************************************************************
  procedure getMenuItems(p_id_usuario   in varchar2,
                         p_cursor1      in out t_cursor,
                         p_cursor2      in out t_cursor,
                         p_resultnumber out varchar2);

  procedure isUsuarioAutorizado(p_id_usuario   suirplus.seg_usuario_t.id_usuario%type,
                                p_url          suirplus.seg_permiso_t.direccion_electronica%type,
                                p_resultnumber out varchar2);
  procedure isInPermiso(p_id_usuario   suirplus.seg_usuario_t.id_usuario%type,
                        p_permiso      suirplus.seg_permiso_t.id_permiso%type,
                        p_resultnumber out varchar2);

  procedure isInRole(p_id_usuario   suirplus.seg_usuario_t.id_usuario%type,
                     p_id_role      in number,
                     p_resultnumber out varchar2);

  ---**************************************************************************************--
  --CMHA
  --14/6/2012
  --Recuperar Class
  ---**************************************************************************************--
  PROCEDURE RecuperarClass(p_idusuario    in suirplus.seg_usuario_t.id_usuario%type,
                           p_email        in suirplus.seg_usuario_t.email%type,
                           p_link_params   in varchar2,
                           p_accion       in varchar2,
                           p_resultnumber OUT varchar2);   

-- *********************************************************************************************************************
-- Program:     procedure UsuarioWebServicesAutorizado
-- Description: procedure que retorno un valor S/N si el usuario tiene permiso para ejecutar el webservice
-- modificado por: Eury Vallejo
-- *********************************************************************************************************************
procedure UsuarioWebServicesAutorizado(p_id_usuario in suirplus.seg_usuario_t.id_usuario%type,
                                      p_permiso_des in suirplus.seg_permiso_t.permiso_des%type,
                                      p_resultnumber OUT varchar2);

end seg_usuarios_pkg;
