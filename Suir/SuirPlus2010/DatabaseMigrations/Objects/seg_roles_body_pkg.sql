create or replace package body suirplus.seg_roles_pkg is
-- **************************************************************************************************
-- Program:     seg_roles_pkg
-- Description: Paquete para manejar los roles
--
-- Modification History
-- --------------------------------------------------------------------------------------------------
-- Fecha        por     Comentario
-- --------------------------------------------------------------------------------------------------
--
-- **************************************************************************************************

-- **************************************************************************************************
-- Program:     role_borrar
-- Description: Borrar roles
-- **************************************************************************************************

    procedure role_borrar(
        p_id_role  		  seg_roles_t.id_role%type,
        p_resultnumber 	  out varchar2
        )
    is

        e_invalidrole 	  	  exception;
        e_existentchildrows   exception;
        v_existerole		  number;

        v_bd_error			  varchar(1000);


        cursor existentrole  is select id_role from seg_usuario_permisos_t tp where tp.id_role = p_id_role;

        cursor existentrole2 is select id_role from seg_rel_permiso_roles_t tr where tr.id_role = p_id_role;


    begin

        if not seg_roles_pkg.isExisteRole(p_id_role) then
           raise e_invalidrole;
        end if;

        open existentrole;
        open existentrole2;

        fetch existentrole into v_existerole;
        fetch existentrole2 into v_existerole;

        if existentrole%found or existentrole2%found  then
           	close existentrole;
        	close existentrole2;
        	raise e_existentchildrows;
        else
           	close existentrole;
        	close existentrole2;
        end if ;

        delete seg_roles_t t where t.id_role = p_id_role;
    --role borrado. retorna 0 para indicar.
        p_resultnumber := 0;
        commit;
        return;
    -- Manejo de Excepciones
    exception

        when e_invalidrole then
            p_resultnumber := seg_retornar_cadena_error(6, null, null);
            return;

        when e_existentchildrows then
            p_resultnumber := seg_retornar_cadena_error(9, null, null);
            return;

        when others then
            v_bd_error := (substr('error '||to_char(sqlcode)||': '||sqlerrm, 1, 255));
            p_resultnumber := seg_retornar_cadena_error(-1, v_bd_error, sqlcode);
        return;

        end;

-- **************************************************************************************************
-- Program:     role_crear
-- Description: Crear roles
-- **************************************************************************************************

    procedure role_crear(
        p_role_des  	   seg_roles_t.roles_des%type,
        p_ult_usuario_act  seg_usuario_t.id_usuario%type,
        p_resultnumber 	   out varchar2
        )

    is
    -- Variables a utilizar
        e_existentroledesc  exception;
        e_invaliduser  	    exception;
        e_longervalue       exception;

        v_bd_error		    varchar(1000);

    begin

        if seg_get_largo_columna('SEG_ROLES_T', 'ROLES_DES') < length(p_role_des) then
           raise e_longervalue;
        end if;

        if seg_roles_pkg.isExisteDescRole(p_role_des) then
           raise e_existentroledesc;
        end if;

        if not seg_usuarios_pkg.isExisteUsuario(p_ult_usuario_act) then
           raise e_invaliduser;
        end if;


        insert into seg_roles_t
            (id_role, roles_des, ult_usuario_act, ult_fecha_act)
        values
            (
            seg_roles_seq.nextval, p_role_des, p_ult_usuario_act,
            (select sysdate from dual)
            );
    --role creado. retorna 0 para indicar.
        p_resultnumber := 0;
        commit;

    -- Manejo de Excepciones
    exception
        when e_existentroledesc then
            p_resultnumber := seg_retornar_cadena_error(4, null, null);
            return;

        when e_invaliduser then
    	    p_resultnumber := seg_retornar_cadena_error(1, null, null);
    	    return;

        when e_longervalue then
            p_resultnumber := seg_retornar_cadena_error(18, null, null);
            return;

        when others then
        	v_bd_error := (substr('error '||to_char(sqlcode)||': '||sqlerrm, 1, 255));
        	p_resultnumber := seg_retornar_cadena_error(-1, v_bd_error, sqlcode);
    	return;
    end;

-- **************************************************************************************************
-- Program:     role_editar
-- Description: editar roles
-- **************************************************************************************************

    procedure role_editar(
        p_id_role   	   seg_roles_t.id_role%type,
        p_roles_des		   seg_roles_t.roles_des%type,
        p_estatus          seg_roles_t.status%type,
        p_ult_usuario_act  seg_usuario_t.id_usuario%type,
        p_resultnumber	   out varchar2)

    is
        e_invalidrole   exception;
        e_invaliduser	exception;
        e_longervalue   exception;

        v_bd_error	    varchar(1000);

    begin

        if seg_get_largo_columna('SEG_ROLES_T', 'ROLES_DES') < length(p_roles_des) then
            raise e_longervalue;
        end if;

        if not seg_roles_pkg.isExisteRole(p_id_role) then
            raise e_invalidrole;
        end if;

        if not seg_usuarios_pkg.isExisteUsuario(p_ult_usuario_act) then
            raise e_invaliduser;
        end if;

    update seg_roles_t tr
        set    tr.roles_des = p_roles_des,
               tr.ult_usuario_act = p_ult_usuario_act,
    	       tr.ult_fecha_act = sysdate,
               tr.status = p_estatus
        where tr.id_role = p_id_role;

        p_resultnumber := 0;
        commit;
        return;

    exception

        when e_invalidrole then
            p_resultnumber := seg_retornar_cadena_error(6, null, null);
            return;
        when e_invaliduser then
            p_resultnumber := seg_retornar_cadena_error(1, null, null);
        return;

        when e_longervalue then
            p_resultnumber := seg_retornar_cadena_error(18, null,null);

        when others then
            v_bd_error := (substr('error '||to_char(sqlcode)||': '||sqlerrm, 1, 255));
            p_resultnumber := seg_retornar_cadena_error(-1, v_bd_error, sqlcode);
        return;
    end ;

-- **************************************************************************************************
-- Program:     otorgar_permiso
-- Description: Para otorgar permisos
-- **************************************************************************************************

    procedure otorgar_permiso(
        p_id_permiso 		  seg_permiso_t.id_permiso%type,
        p_id_role			  seg_roles_t.id_role%type,
        p_ult_usuario_act	  seg_usuario_t.id_usuario%type,
        p_resultnumber 	      out varchar2 )

    is

        e_invalidpermiso      exception;
        e_invalidrole	      exception;
        e_invaliduser	      exception;
        e_existentrow         exception;
        v_tmpidpermiso        number;
        v_cuenta              number;

        v_bd_error	          varchar(1000);

    cursor existeregistro is
        select id_permiso
        from seg_rel_permiso_roles_t r
        where id_permiso = p_id_permiso
        and id_role = p_id_role;

    begin

        if not seg_permisos_pkg.isExistePermiso(p_id_permiso) then
           raise e_invalidpermiso;
        end if;

        if not seg_roles_pkg.isExisteRole(p_id_role) then
           raise e_invalidrole;
        end if;

        if not seg_usuarios_pkg.isExisteUsuario(p_ult_usuario_act) then
           raise e_invaliduser;
        end if;

        open existeregistro;
            fetch existeregistro into v_tmpidpermiso;

        if existeregistro%found then
           close existeregistro;
           raise e_existentrow;
        else
            close existeregistro;
        end if;

        select count(*) into v_cuenta
        from seg_rel_permiso_roles_t pr
        where pr.id_permiso = p_id_permiso
        and pr.id_role = p_id_role;

        if v_cuenta = 0 then
            insert into seg_rel_permiso_roles_t
                (id_permiso, id_role, ult_usuario_act, ult_fecha_act)
            values
                (p_id_permiso, p_id_role, p_ult_usuario_act, sysdate);
        end if;

        p_resultnumber := 0;
        commit;
        return;


    exception

        when e_invalidpermiso then
            p_resultnumber := seg_retornar_cadena_error(5, null, null);

        when  e_invalidrole then
            p_resultnumber := seg_retornar_cadena_error(6, null, null);

        when e_invaliduser then
            p_resultnumber := seg_retornar_cadena_error(1, null, null);

        when e_existentrow then
            p_resultnumber := seg_retornar_cadena_error(4, null, null);

        when others then
            v_bd_error := (substr('error '||to_char(sqlcode)||': '||sqlerrm, 1, 255));
            p_resultnumber := seg_retornar_cadena_error(-1, v_bd_error, sqlcode);
        return;

    end ;

-- **************************************************************************************************
-- Program:  get_roles
-- Description: Para traer los roles
-- **************************************************************************************************

    procedure get_roles(
        p_id_role         in number,
        p_io_cursor       in out t_cursor,
        p_resultnumber    out varchar2)

        is
        e_invalidrole       exception;
        v_bd_error		  	varchar(1000);
        c_cursor t_cursor;

    begin

    if p_id_role is not null then
        if not seg_roles_pkg.isExisteRole(p_id_role) then
            raise e_invalidrole;
        end if;

        open c_cursor for
            select r.id_role, r.roles_des, r.status, r.ult_usuario_act, r.ult_fecha_act
            from seg_roles_t r
            where id_role = p_id_role;

    else

        open c_cursor for
         	select r.id_role, r.roles_des, r.status, r.ult_usuario_act, r.ult_fecha_act
            from seg_roles_t r
            order by roles_des;
    end if;

        p_resultnumber := 0;
        p_io_cursor := c_cursor;

    exception

        when e_invalidrole then
            p_resultnumber := seg_retornar_cadena_error(6, null, null);
        return;

        when others then
        	 v_bd_error := (substr('error '||to_char(sqlcode)||': '||sqlerrm, 1, 255));
        	 p_resultnumber := seg_retornar_cadena_error(-1, v_bd_error, sqlcode);
        return;


    end;

-- **************************************************************************************************
-- Program:     get_roles_sin_per
-- Description: traer los roles que no tienen permisos
-- **************************************************************************************************

    procedure get_roles_sin_per(
        p_id_permiso      in seg_permiso_t.id_permiso%type,
        p_io_cursor       in out t_cursor,
        p_resultnumber    out varchar2)

        is
        e_invalidpermiso    exception;
        v_bd_error		  	varchar(1000);
        c_cursor t_cursor;

    begin

        if not seg_permisos_pkg.isExistePermiso(p_id_permiso) then
           raise e_invalidpermiso;
        end if;

    	open c_cursor for
            select r.id_role, r.roles_des, r.tipo_role
            from seg_roles_t r
            where not exists
                (
                select 1
                from seg_rel_permiso_roles_t pr
                where pr.id_permiso = p_id_permiso
                and pr.id_role = r.id_role
                )
         order by r.roles_des;

         p_resultnumber := 0;
         p_io_cursor := c_cursor;

    exception

        when e_invalidpermiso then
        	 p_resultnumber := seg_retornar_cadena_error(5, null, null);

        when others then
        	 v_bd_error := (substr('error '||to_char(sqlcode)||': '||sqlerrm, 1, 255));
        	 p_resultnumber := seg_retornar_cadena_error(-1, v_bd_error, sqlcode);
        return;
    end;
-- **************************************************************************************************
-- Program:     get_roles_sin_usr
-- Description: traer los roles que no tienen usuarios
-- **************************************************************************************************

    procedure get_roles_sin_usr(
        p_id_usuario      in seg_usuario_t.id_usuario%type,
        p_io_cursor       in out t_cursor,
        p_ResultNumber    out varchar2)
    is
        e_invaliduser     exception;
        v_bdError         varchar(1000);
        c_cursor t_cursor;

    begin
        if not seg_usuarios_pkg.isExisteUsuario(p_id_usuario) then
            raise e_invaliduser;
        end if;

       	open c_cursor for
            select r.id_role, r.roles_des, r.tipo_role
            from seg_roles_t r
            where not exists
                (
                select 1 from seg_usuario_permisos_t t
                where t.id_usuario = p_id_usuario
                and t.id_role = r.id_role
                )
            order by r.roles_des;

        p_resultnumber := 0;
        p_io_cursor := c_cursor;

    exception

        when e_invaliduser then
            p_resultnumber := seg_retornar_cadena_error(1, null, null);
        return;

        when others then
        	v_bderror := (substr('error '||to_char(sqlcode)||': '||sqlerrm, 1, 255));
        	p_resultnumber := seg_retornar_cadena_error(-1, v_bderror, sqlcode);
        return;

    end;

-- **************************************************************************************************
-- Program:     get_roles_permiso
-- Description: traer los permiso que tiene un rol
-- **************************************************************************************************

    procedure get_roles_permiso(
        p_id_permiso      in number,
        p_io_cursor       in out t_cursor,
        p_resultnumber    out varchar2)

    is
        e_invalidpermiso    exception;
        v_bd_error		  	varchar(1000);
        c_cursor t_cursor;

    begin
        if not seg_permisos_pkg.isExistePermiso(p_id_permiso) then
           raise e_invalidpermiso;
        end if;

        open c_cursor for
            select rol.id_role, rol.roles_des
            from seg_roles_t rol, seg_rel_permiso_roles_t per
            where rol.id_role = per.id_role
            and  per.id_permiso = p_id_permiso
            order by rol.roles_des;

         p_resultnumber := 0;
         p_io_cursor := c_cursor;

    exception

        when e_invalidpermiso then
        	 p_resultnumber := seg_retornar_cadena_error(5, null, null);

        when others then
        	 v_bd_error := (substr('error '||to_char(sqlcode)||': '||sqlerrm, 1, 255));
        	 p_resultnumber := seg_retornar_cadena_error(-1, v_bd_error, sqlcode);
        return;
    end;
-- **************************************************************************************************
-- Program:     get_roles_usuario
-- Description: traer los roles de los usuarios
-- **************************************************************************************************

    procedure get_roles_usuario(
        p_id_usuario      seg_usuario_t.id_usuario%type,
        p_io_cursor       in out t_cursor,
        p_ResultNumber    out varchar2)
    is
        e_invaliduser       exception;
        v_bdError           varchar(1000);
        c_cursor t_cursor;

    begin
        if not seg_usuarios_pkg.isExisteUsuario(p_id_usuario) then
            raise e_invaliduser;
        end if;

        open c_cursor for
            select rl.id_role, rl.roles_des, rl.status
            from seg_usuario_permisos_t usu, seg_roles_t rl
            where usu.id_usuario = p_id_usuario
            and usu.id_role = rl.id_role
            order by rl.roles_des;

         p_resultnumber := 0;
         p_io_cursor := c_cursor;

    exception

        when e_invaliduser then
            p_resultnumber := seg_retornar_cadena_error(1, null, null);
        return;

        when others then
        	v_bderror := (substr('error '||to_char(sqlcode)||': '||sqlerrm, 1, 255));
        	p_resultnumber := seg_retornar_cadena_error(-1, v_bderror, sqlcode);
        return;
    end;

-- **************************************************************************************************
-- Program:     function isExisteRole()
-- Description: funcion que retorna la existencia de un role de seguridad y que el mismo
--              se encuentre activo en el registro.
-- **************************************************************************************************

    function isExisteRole(p_id_role number) return boolean

    is

    cursor existe_role is
-- tener en cuenta no se ha creado campo de activo
        select t.id_role from seg_roles_t t where t.id_role = p_id_role;

    returnvalue boolean;
    prole seg_roles_t.id_role%type;

    begin
    open existe_role;
    	 fetch existe_role into prole;
    	 returnvalue := existe_role%found;
    	 close existe_role;

    return(returnvalue);

    end isExisteRole;

-- **************************************************************************************************
-- Program:     function isExisteDescRole()
-- Description: funcion que retorna la existencia de una descripcion de un role y que el mismo
--              se encuentre activo en el registro.
-- **************************************************************************************************

    function isExisteDescRole(role_des seg_roles_t.roles_des%type) return boolean

    is

    cursor existe_desc is
        select t.roles_des from seg_roles_t t
        where t.roles_des = role_des
        and t.status = 'A';

    returnvalue boolean;
    pdescrole seg_roles_t.roles_des%type;

    begin
    open existe_desc;
    	 fetch existe_desc into pdescrole;
    	 returnvalue := existe_desc%found;
    	 close existe_desc;

    return(returnvalue);

    end isExisteDescRole;
    
  
  -- **************************************************************************************************
  -- Program: InsertarRolCertificacion
  -- Description: Insertar rol a las certificaciones
  -- BY: Kerlin de la cruz
  -- Date: 22/05/2017
  -- **************************************************************************************************

  PROCEDURE InsertarRolCertificacion(p_id_role in cer_roles_certificaciones_t.id_role%type,
                                     p_id_tipo_certificacion in cer_roles_certificaciones_t.id_tipo_certificacion%type,
                                     p_ult_usuario_act in seg_usuario_t.id_usuario%type,
                                     p_resultnumber OUT VARCHAR2)

   IS
    v_bderror VARCHAR(1000);
   
  BEGIN
    
    insert into cer_roles_certificaciones_t
    (id_role, 
     id_tipo_certificacion,
     ult_usuario_act,
     ult_fecha_act)
     
    values  
      
    (p_id_role,
     p_id_tipo_certificacion,
     p_ult_usuario_act,
     sysdate
    );
                                       
    commit;
    p_resultnumber := 0;

  EXCEPTION

    WHEN OTHERS THEN
      v_bderror      := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultnumber := Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
      RETURN;
  END;
  
      

end seg_roles_pkg;
