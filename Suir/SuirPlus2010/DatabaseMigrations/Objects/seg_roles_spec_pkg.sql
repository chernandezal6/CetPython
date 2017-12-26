create or replace package suirplus.seg_roles_pkg is

  -- Author  : HECTOR_MINAYA
  -- Created :
  -- Purpose :

    type t_cursor is ref cursor;

    procedure role_borrar(
        p_id_role  		  seg_roles_t.id_role%type,
        p_resultnumber 	  out varchar2
        );

    procedure role_crear(
        p_role_des  	   seg_roles_t.roles_des%type,
        p_ult_usuario_act  seg_usuario_t.id_usuario%type,
        p_resultnumber 	   out varchar2
        );

    procedure role_editar(
        p_id_role   	   seg_roles_t.id_role%type,
        p_roles_des		   seg_roles_t.roles_des%type,
        p_estatus           seg_roles_t.status%type,
        p_ult_usuario_act  seg_usuario_t.id_usuario%type,
        p_resultnumber	   out varchar2
        );

    procedure otorgar_permiso(
        p_id_permiso 		  seg_permiso_t.id_permiso%type,
        p_id_role			  seg_roles_t.id_role%type,
        p_ult_usuario_act	  seg_usuario_t.id_usuario%type,
        p_resultnumber 	      out varchar2
        );

    procedure get_roles(
        p_id_role         in number,
        p_io_cursor       in out t_cursor,
        p_resultnumber    out varchar2);

    procedure get_roles_sin_per(
        p_id_permiso      in seg_permiso_t.id_permiso%type,
        p_io_cursor       in out t_cursor,
        p_resultnumber    out varchar2);

    procedure get_roles_sin_usr(
        p_id_usuario      in seg_usuario_t.id_usuario%type,
        p_io_cursor       in out t_cursor,
        p_ResultNumber    out varchar2
        );

    procedure get_roles_permiso(
        p_id_permiso      in number,
        p_io_cursor       in out t_cursor,
        p_resultnumber    out varchar2);

    procedure get_roles_usuario(
        p_id_usuario      seg_usuario_t.id_usuario%type,
        p_io_cursor       in out t_cursor,
        p_ResultNumber    out varchar2
        );

    function isExisteRole(p_id_role number) return boolean;

    function isExisteDescRole(role_des seg_roles_t.roles_des%type) return boolean;
    
  -- **************************************************************************************************
  -- Program: InsertarRolCertificacion
  -- Description: Insertar rol a las certificaciones
  -- BY: Kerlin de la cruz
  -- Date: 22/05/2017
  -- **************************************************************************************************

  PROCEDURE InsertarRolCertificacion(p_id_role in cer_roles_certificaciones_t.id_role%type,
                                     p_id_tipo_certificacion in cer_roles_certificaciones_t.id_tipo_certificacion%type,
                                     p_ult_usuario_act in seg_usuario_t.id_usuario%type,
                                     p_resultnumber OUT VARCHAR2);    

end seg_roles_pkg;

 