create or replace package suirplus.seg_permisos_pkg is

  -- Author  : HECTOR_MINAYA
  -- Created : 11/12/2004 12:21:52 AM
  -- Purpose : Manejo de permisos para el modulo de seguridad

  type t_cursor is ref cursor;

  -- Procedimiento que devuelve todos los permisos que estan activos y no tiene el Usuario especificado.
    procedure get_permisos_sin_usuario(
        p_IdUsuario         in seg_usuario_t.id_usuario%type,
        p_IOCursor          in out t_Cursor,
        p_ResultNumber      out varchar2);

  -- Procedimiento que devuelve todos los permisos que estan activos y no tiene el Role especificado.
    procedure get_permisos_sin_role(
        p_IDRole          in seg_roles_t.id_role%type,
        p_IOCursor        in out t_Cursor,
        p_resultnumber    out varchar2);

    procedure permiso_borrar(
        p_id_permiso        seg_permiso_t.id_permiso%type,
        p_resultnumber		out varchar2);

    procedure permiso_crear(
        p_permiso_des           seg_permiso_t.permiso_des%type,
        p_id_seccion            seg_permiso_t.id_seccion%type,
        p_orden_menu            seg_permiso_t.orden_menu%type,
        p_direccion_electronica seg_permiso_t.direccion_electronica%type,
        p_tipo_permiso          seg_permiso_t.tipo_permiso%type,
        p_marca_cuota           seg_permiso_t.marca_cuota%type,
        p_ult_usuario_act       seg_usuario_t.id_usuario%type,
        p_resultnumber          out varchar2
        );

    procedure permiso_editar(
        p_id_permiso      seg_permiso_t.id_permiso%type,
        p_permiso_des     seg_permiso_t.permiso_des%type,
        p_direccion_elec  seg_permiso_t.direccion_electronica%type,
        p_ult_usuario_act seg_usuario_t.id_usuario%type,
        p_estatus         seg_permiso_t.status%type,
        p_id_seccion      seg_permiso_t.id_seccion%type,
        p_orden_menu      seg_permiso_t.orden_menu%type,
        p_tipo_permiso    seg_permiso_t.tipo_permiso%type,   
        p_marca_cuota     seg_permiso_t.marca_cuota%type,
        p_resultnumber    out varchar2);

    procedure get_permisos(
        p_id_permiso      in number,
        p_iocursor       in out t_cursor,
        p_resultnumber    out varchar2);

    procedure permisos_role(
        p_id_role         in number,
        p_iocursor       in out t_cursor,
        p_resultnumber    out varchar2);

    procedure permisos_usuario(
        p_id_usuario        in seg_usuario_t.id_usuario%type,
        p_io_cursor         in out t_cursor,
        p_ResultNumber      out varchar2);

    procedure deasignar_permiso(
        p_id_permiso 		  		seg_permiso_t.id_permiso%type,
        p_id_role 		  			seg_roles_t.id_role%type,
        p_ult_usuario_act	  		seg_usuario_t.id_usuario%type,
        p_resultnumber	  			out varchar2);


    function isExistePermiso(p_id_permiso number) return boolean;

    function isExisteDescPermiso(
        p_permiso_des   seg_permiso_t.permiso_des%type,
        p_id_seccion    seg_permiso_t.id_seccion%type) return boolean;

    procedure permisos_bancos_dgii;

-- **************************************************************************************************
-- Program:     get_ServicioCuota
-- Description: Para traer la informacion de los servicios relacionados con Cuotas
-- **************************************************************************************************

    procedure get_ServicioCuota(
        p_iocursor       in out t_cursor,
        p_resultnumber    out varchar2);
        
        -- **************************************************************************************************
-- Program:     DatasetServiciosCuotas
-- Description: Para traer la informacion de los servicios relacionados con Cuotas
--Autor:Eury Vallejo
-- **************************************************************************************************
   procedure DatasetServiciosCuotas(
        p_iocursor       in out t_cursor,
        p_resultnumber    out varchar2);
        
 -- **************************************************************************************************
-- Program:     InsertarCuota
-- Description: Inserta la cuota del servicio a utilizar por el usuario
--Autor:Eury Vallejo
-- **************************************************************************************************
   procedure InsertarCuota(
             p_id_permiso in seg_permiso_t.id_permiso%type,
             p_id_usuario in seg_usuario_t.id_usuario%type,
             p_cuota in seg_cuota_t.cuota%type,
             p_usuario_act in seg_cuota_t.ult_usuario_act%type,
             p_resultnumber    out varchar2);             
             
-- **************************************************************************************************
-- Program:     ActualizarCuota
-- Description: Actualizar la cuota del servicio a utilizar por el usuario
--Autor: Eury Vallejo
-- **************************************************************************************************
   procedure ActualizarCuota(
             p_id_permiso in seg_permiso_t.id_permiso%type,
             p_id_usuario in seg_usuario_t.id_usuario%type,
             p_resultnumber    out varchar2);
             
-- **************************************************************************************************
-- Program:     BorrarCuota
-- Description: Borrar la cuota del servicio a utilizar por el usuario
--Autor: Eury Vallejo
-- **************************************************************************************************
   procedure BorrarCuota(
             p_id_permiso in seg_permiso_t.id_permiso%type,
             p_id_usuario in seg_usuario_t.id_usuario%type,
             p_resultnumber    out varchar2);
             
             
-- **************************************************************************************************
-- Program:     ValidarCuotasUsuarios
-- Description: Valida si el usuario tiene una relacion con un Servicio
--Autor: Eury Vallejo
-- **************************************************************************************************
FUNCTION ValidarCuotasUsuarios(p_id_permiso in seg_permiso_t.id_permiso%type,
                               p_id_usuario in seg_usuario_t.id_usuario%type) RETURN BOOLEAN;
                               
                               
-- **************************************************************************************************
-- Program:     BuscarIdPermiso
-- Description: Buscar Id de Permiso
--Autor: Eury Vallejo
-- **************************************************************************************************
procedure BuscarIdPermiso(p_permiso_url in seg_permiso_t.direccion_electronica%type,
                               p_resultnumber out varchar2);     
                               -- **************************************************************************************************
-- Program:     ValidarCuotasConsumidas
-- Description: Valida si el usuario tiene cuotas disponibles para ser consumidas
--Autor: Eury Vallejo
-- **************************************************************************************************
procedure ValidarCuotasConsumidas(p_id_permiso in seg_permiso_t.id_permiso%type,
                               p_id_usuario in seg_usuario_t.id_usuario%type,
                                p_resultnumber    out varchar2);                          

end seg_permisos_pkg;