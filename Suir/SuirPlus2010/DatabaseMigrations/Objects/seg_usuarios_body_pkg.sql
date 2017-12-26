create or replace package body suirplus.seg_usuarios_pkg is
  -- **************************************************************************************************
  -- Program:     seg_usuarios_pkg
  -- Description: Paquete para manejar los usuarios
  --
  -- Modification History
  -- --------------------------------------------------------------------------------------------------
  -- Fecha        por     Comentario
  -- --------------------------------------------------------------------------------------------------
  --
  -- **************************************************************************************************

  -- **************************************************************************************************
  -- Program:     GetUsuariosNoTieneRole
  -- Description: Trae todos los Usuarios que no tiene un Role
  -- **************************************************************************************************

  procedure Login(p_idusuario    in suirplus.seg_usuario_t.id_usuario%type,
                  p_class        in suirplus.seg_usuario_t.password%type,
                  p_ip           varchar2,
                  p_tipousuario  varchar2,
                  p_resultnumber out varchar2) is
  begin
  
       Login(p_idusuario, p_class, p_ip, p_tipousuario, ' ', p_resultnumber);
  
  end;

  procedure Login(p_idusuario    in suirplus.seg_usuario_t.id_usuario%type,
                  p_class        in suirplus.seg_usuario_t.password%type,
                  p_ip           varchar2,
                  p_tipousuario  varchar2,
                  p_servidor in suirplus.seg_log_t.servidor%type,
                  p_resultnumber out varchar2) is
    v_bderror      varchar(1000);
    v_resultado    number;
    v_CambiarClass varchar(1);
    e_invalidUser EXCEPTION;
    e_maxTrialsCountReached EXCEPTION;
    V_CANTIDAD_INTENTOS INTEGER;
    v_regPatronal       number(9);
    v_nss               number(11);
  begin

    if (p_tipousuario = 2 and p_idusuario is not null) then
      --buscamos el nss y el registro patronal del representante logueado en la tabla de usuarios
      begin
        select u.id_registro_patronal, u.id_nss
          into v_regPatronal, v_nss
          from suirplus.seg_usuario_t u
         where u.id_usuario = p_idusuario;
        --verificamos el status del representante logueado en la tabla de representantes
        --si su estatus es "T" no lo dejamos pasar y lanzamos un mensaje
        Select count(*)
          into v_resultado
          from suirplus.sre_representantes_t r
         where r.id_nss = v_nss
           and r.id_registro_patronal = v_regPatronal
           and status in('T','I');

        if v_resultado > 0 then
           suirplus.seg_log_pkg.crearLog(v_regPatronal,6,p_ip,p_ip,UPPER(p_idusuario),UPPER(p_idusuario),'Representante inactivo',p_servidor,v_bderror);  
        
          raise e_invalidUser;
        end if;

      exception
        when NO_DATA_FOUND then
          suirplus.seg_log_pkg.crearLog(null,6,p_ip,p_ip,UPPER(p_idusuario),UPPER(p_idusuario),'Usuario no encontrado',p_servidor,v_bderror);  
        
          p_resultnumber := '';
      end;
    end if;

    if (p_tipousuario = 1) then
      Select count(*)
        into v_resultado
        from suirplus.seg_usuario_t
       where id_usuario = UPPER(p_idusuario)
         and (password = md5_digest(lower(p_class)) or
             password = md5_digest(upper(p_class)) or
             password = md5_digest(p_class))
         and status = 'A';

    else
      Select count(*)
        into v_resultado
        from suirplus.seg_usuario_t
       where id_usuario = UPPER(p_idusuario)
         and password = md5_digest(lower(p_class))
         and status = 'A' and ID_TIPO_USUARIO <> '3';
    end if;

    if (v_resultado > 0) THEN
      SELECT CANTIDAD_INTENTOS
        INTO V_CANTIDAD_INTENTOS
        FROM suirplus.seg_usuario_t
       WHERE id_usuario = UPPER(p_idusuario);

      IF V_CANTIDAD_INTENTOS > 2 THEN
        UPDATE suirplus.seg_usuario_t
           SET CANTIDAD_INTENTOS = 0
         WHERE id_usuario = UPPER(p_idusuario);
        COMMIT;
      ELSE
        SELECT cambiar_class
          into v_CambiarClass
          FROM suirplus.seg_usuario_t
         WHERE id_usuario = UPPER(p_idusuario);
      END IF;

      if v_CambiarClass = 'S' then
        suirplus.seg_log_pkg.crearLog(v_regPatronal,6,p_ip,p_ip,UPPER(p_idusuario),UPPER(p_idusuario),'Debe cambiar el Class',p_servidor,v_bderror);  
        
        p_resultnumber := 9;
      ELSE
         suirplus.seg_log_pkg.crearLog(v_regPatronal,6,p_ip,p_ip,UPPER(p_idusuario),UPPER(p_idusuario),'Login correcto',p_servidor,v_bderror);  
        
        --Para actualizar la ultima vez que entro al sistema
        UPDATE suirplus.seg_usuario_t
           SET ult_login = sysdate,
               ip = p_ip
         WHERE id_usuario = UPPER(p_idusuario);
        COMMIT;
        
        p_resultnumber := 0;
      end if;

    ELSE
       suirplus.seg_log_pkg.crearLog(v_regPatronal,6,p_ip,p_ip,UPPER(p_idusuario),UPPER(p_idusuario),'Error con el Usuario o el Class',p_servidor,v_bderror);  
        
      Select count(*)
        into v_resultado
        from suirplus.seg_usuario_t
       where id_usuario = UPPER(p_idusuario)
         and status = 'A';

      IF v_resultado = 1 THEN

        SELECT CANTIDAD_INTENTOS + 1
          INTO V_CANTIDAD_INTENTOS
          FROM suirplus.seg_usuario_t
         WHERE id_usuario = UPPER(p_idusuario);

        SAVEPOINT SAVE_LOGIN_TRIALS;
        UPDATE suirplus.seg_usuario_t
           SET CANTIDAD_INTENTOS = V_CANTIDAD_INTENTOS
         WHERE id_usuario = UPPER(p_idusuario);
        COMMIT;
        IF V_CANTIDAD_INTENTOS > 2 THEN
          RAISE e_maxTrialsCountReached;
        END IF;
      END IF;
      p_resultnumber := 1;
    end if;

  exception
    WHEN e_maxTrialsCountReached THEN
      p_resultnumber := 3;
      RETURN;

    WHEN e_invalidUser THEN
      p_resultnumber := 4; --p_resultnumber := seg_retornar_cadena_error(121, null, null);
      RETURN;

    when others then
      v_bderror      := (substr('error ' || to_char(sqlcode) || ': ' ||
                                sqlerrm,
                                1,
                                255));
      p_resultnumber := seg_retornar_cadena_error(-1, v_bderror, sqlcode);
      return;
  end;
  procedure LogError(p_mensaje in suirplus.seg_errores_t.DESCRIPCION%type,
                     p_usuario in suirplus.seg_errores_t.usuario%type) is
    v_proximo_error number(9);
  begin

    select seq_errores_t.nextval into v_proximo_error from dual;

    Insert into suirplus.seg_errores_t
      (id, descripcion, fecha, usuario)
    values
      (v_proximo_error, p_mensaje, sysdate, p_usuario);
    commit;

  end;

  procedure ReseteoClass(p_idusuario    in suirplus.seg_usuario_t.id_usuario%type,
                         p_classNew     out suirplus.seg_usuario_t.password%type,
                         p_resultnumber out varchar2) is
    e_invaliduser exception;
    v_bderror  varchar(1000);
    p_password varchar(32);
  begin

    if not suirplus.seg_usuarios_pkg.isExisteUsuario(p_idusuario) then
      raise e_invaliduser;
    end if;

    SELECT Sre_Crea_Users_F(8) INTO p_password FROM dual;

    update suirplus.seg_usuario_t u
       set u.password      = md5_digest(lower(p_password)),
           u.cambiar_class = 'S'
     where u.id_usuario = p_idusuario;

    p_classNew     := p_password;
    p_resultnumber := '0|' || lower(p_classNew);

  exception
    when e_invaliduser then
      p_resultnumber := seg_retornar_cadena_error(1, null, null);
      return;

    when others then
      v_bderror      := (substr('error ' || to_char(sqlcode) || ': ' ||
                                sqlerrm,
                                1,
                                255));
      p_resultnumber := seg_retornar_cadena_error(-1, v_bderror, sqlcode);
      return;

  end;

  procedure CambioClass(p_idusuario    in suirplus.seg_usuario_t.id_usuario%type,
                        p_classNew     in suirplus.seg_usuario_t.password%type,
                        p_classOld     in suirplus.seg_usuario_t.password%type,
                        p_resultnumber out varchar2) is
    e_invalidUser exception;
    v_bderror   varchar(1000);
    v_resultado number;
  begin

    Select count(*)
      into v_resultado
      from suirplus.seg_usuario_t
     where id_usuario = UPPER(p_idusuario)
       and password = md5_digest(lower(p_classOld))
       and status = 'A'
       and ID_TIPO_USUARIO <> '3';

    if (v_resultado = 1) then
      update suirplus.seg_usuario_t
         set password = md5_digest(lower(p_classNew)), Cambiar_Class = 'N'
       where id_usuario = UPPER(p_idusuario);
      COMMIT;
      p_resultnumber := 0;
    else

      raise e_invalidUser;

    end if;

  exception
    when e_invalidUser then
      p_resultnumber := seg_retornar_cadena_error(1, null, null);
      return;

    when others then
      v_bderror      := (substr('error ' || to_char(sqlcode) || ': ' ||
                                sqlerrm,
                                1,
                                255));
      p_resultnumber := seg_retornar_cadena_error(-1, v_bderror, sqlcode);
      return;
  end;

  procedure Usuarios_sin_Role(p_idrole       in suirplus.seg_roles_t.id_role%type,
                              p_iocursor     in out t_cursor,
                              p_resultnumber out varchar2) is
    e_invalidrole exception;
    v_bderror varchar(1000);
    c_cursor  t_cursor;

  begin
    if not suirplus.seg_roles_pkg.isExisteRole(p_idrole) then
      raise e_invalidrole;
    end if;

    open c_cursor for
      select u.id_usuario, u.nombre_usuario || ' ' || u.apellidos nombre
        from suirplus.seg_usuario_t u
       where not exists (select 1
                from suirplus.seg_usuario_permisos_t p
               where p.id_role = p_idrole
                 and p.id_usuario = u.id_usuario)
         and u.id_tipo_usuario = 1
         and u.status = 'A'
       order by u.nombre_usuario || ' ' || u.apellidos;

    p_iocursor := c_cursor;

  exception

    when e_invalidrole then
      p_resultnumber := seg_retornar_cadena_error(6, null, null);
      return;

    when others then
      v_bderror      := (substr('error ' || to_char(sqlcode) || ': ' ||
                                sqlerrm,
                                1,
                                255));
      p_resultnumber := seg_retornar_cadena_error(-1, v_bderror, sqlcode);
      return;

  end;

  -- **************************************************************************************************
  -- Program:     GetUsuariosNoTienenPermiso
  -- Description: Trae todos los Usuarios que no tiene un Permiso
  -- **************************************************************************************************

  procedure Usuarios_sin_Permiso(p_idpermiso    in suirplus.seg_permiso_t.id_permiso%type,
                                 p_iocursor     in out t_cursor,
                                 p_resultnumber out varchar2)

   is
    e_invalidpermiso exception;
    v_bd_error varchar(1000);
    c_cursor   t_cursor;

  begin
    if not suirplus.seg_permisos_pkg.isExistePermiso(p_idpermiso) then
      raise e_invalidpermiso;
    end if;

    open c_cursor for
      select u.id_usuario, u.nombre_usuario || ' ' || u.apellidos nombre
        from suirplus.seg_usuario_t u
       where not exists (select 1
                from suirplus.seg_usuario_permisos_t p
               where p.id_permiso = p_idpermiso
                 and p.id_usuario = u.id_usuario)
         and u.id_tipo_usuario = 1
         and u.status = 'A'
       order by upper(u.nombre_usuario || ' ' || u.apellidos);

    p_iocursor := c_cursor;

  exception

    when e_invalidpermiso then
      p_resultnumber := seg_retornar_cadena_error(5, null, null);

    when others then
      v_bd_error     := (substr('error ' || to_char(sqlcode) || ': ' ||
                                sqlerrm,
                                1,
                                255));
      p_resultnumber := seg_retornar_cadena_error(-1, v_bd_error, sqlcode);
      return;
  end;

  -- **************************************************************************************************
  -- Program:     Actualizar_UsuarioRep
  -- Description: Actualizar usuario
  -- **************************************************************************************************

  procedure Actualizar_UsuarioRep(p_idusuario          in suirplus.seg_usuario_t.id_usuario%type,
                                  p_tipo_representante in suirplus.sre_representantes_t.tipo_representante%type,
                                  p_email              in suirplus.seg_usuario_t.email%type,
                                  p_ultusuarioact      in suirplus.seg_usuario_t.ult_usuario_act%type,
                                  p_resultnumber       out varchar2) is
    e_invaliduser exception;
    v_bderror   varchar(1000);
    v_idusuario varchar2(35);

    cursor c_cursor is
      select id_usuario
        from suirplus.seg_usuario_t u
       where u.id_usuario = p_idusuario;

  begin

    if not suirplus.seg_usuarios_pkg.isExisteUsuario(p_idusuario) then
      raise e_invaliduser;

    elsif not suirplus.seg_usuarios_pkg.isExisteUsuario(p_ultusuarioact) then
      raise e_invaliduser;
    end if;

    open c_cursor;
    fetch c_cursor
      into v_idusuario;
    close c_cursor;

    if v_idusuario = p_idusuario then

      delete from suirplus.seg_usuario_permisos_t u
       where u.id_usuario = p_idusuario;

      if p_tipo_representante = 'A' then
        insert into suirplus.seg_usuario_permisos_t
          (id_usuario, id_role, ult_usuario_act, ult_fecha_act)
        values
          (p_idusuario, 31, p_ultusuarioact, sysdate);
        insert into suirplus.seg_usuario_permisos_t
          (id_usuario, id_role, ult_usuario_act, ult_fecha_act)
        values
          (p_idusuario, 41, p_ultusuarioact, sysdate);

      else
        if p_tipo_representante = 'N' then
          insert into suirplus.seg_usuario_permisos_t
            (id_usuario, id_role, ult_usuario_act, ult_fecha_act)
          values
            (p_idusuario, 31, p_ultusuarioact, sysdate);
        end if;
      end if;
      update suirplus.seg_usuario_t u
         set u.email = p_email, u.status = 'A'
       where u.id_usuario = p_idusuario;
    end if;

    p_resultnumber := 0;
    commit;

  exception

    when e_invaliduser then
      p_resultnumber := seg_retornar_cadena_error(1, null, null);

    when others then
      v_bderror      := (substr('error ' || to_char(sqlcode) || ': ' ||
                                sqlerrm,
                                1,
                                255));
      p_resultnumber := seg_retornar_cadena_error(-1, v_bderror, sqlcode);
      return;

  end;

  -- **************************************************************************************************
  -- Program:     Insertar_UsuarioRep
  -- Description: Inserta un usuario
  -- **************************************************************************************************

  procedure Insertar_UsuarioRep(p_idusuario          in suirplus.seg_usuario_t.id_usuario%type,
                                p_password           in suirplus.seg_usuario_t.password%type,
                                p_idnss              in suirplus.seg_usuario_t.id_nss%type,
                                p_idregistropatronal in suirplus.seg_usuario_t.id_registro_patronal%type,
                                p_email              in suirplus.seg_usuario_t.email%type,
                                p_ultusuarioact      in suirplus.seg_usuario_t.ult_usuario_act%type,
                                p_tipo_representante in suirplus.sre_representantes_t.tipo_representante%type,
                                p_resultnumber       out varchar2)

   is

    e_usuarioactivo exception;
    e_faltinfo exception;
    e_invalidregpatronal exception;
    v_bderror   varchar(1000);
    v_idusuario varchar2(35);
    v_status    varchar2(1);

    cursor c_cursor is
      select u.id_usuario, u.status
        from suirplus.seg_usuario_t u
       where u.id_usuario = p_idusuario;

  begin

    if (p_idnss is null) or (p_idregistropatronal is null) then
      raise e_faltinfo;
    end if;

    if not suirplus.Sre_Empleadores_Pkg.existeregistropatronal(p_idregistropatronal) then
      raise e_invalidregpatronal;
    end if;

    open c_cursor;
    fetch c_cursor
      into v_idusuario, v_status;
    close c_cursor;

    if p_idusuario is not null then

      if v_idusuario = p_idusuario then
        if v_status = 'A' then
          raise e_usuarioactivo;

        else
          update suirplus.seg_usuario_t u
             set u.status               = 'I',
                 u.password             = md5_digest(lower(p_password)),
                 u.id_nss               = p_idnss,
                 u.id_registro_patronal = p_idregistropatronal,
                 u.id_tipo_usuario      = 2
           where u.id_usuario = p_idusuario
             and u.status = 'A';
        end if;
      end if;

      if v_idusuario is null then
        insert into suirplus.seg_usuario_t
          (id_usuario,
           id_tipo_usuario,
           id_nss,
           id_registro_patronal,
           nombre_usuario,
           apellidos,
           password,
           email,
           status,
           ult_usuario_act,
           CAMBIAR_CLASS,
           ACTUALIZAR_EMAIL)
        values
          (p_idusuario,
           2,
           p_idnss,
           p_idregistropatronal,
           '  ',
           '  ',
           md5_digest(lower(p_password)),
           p_email,
           'A',
           p_ultusuarioact,
           'S',
           'N');

        commit;

        if p_tipo_representante = 'A' then
          insert into suirplus.seg_usuario_permisos_t
            (id_usuario, id_role, ult_usuario_act, ult_fecha_act)
          values
            (p_idusuario, 31, p_ultusuarioact, sysdate);
          insert into suirplus.seg_usuario_permisos_t
            (id_usuario, id_role, ult_usuario_act, ult_fecha_act)
          values
            (p_idusuario, 41, p_ultusuarioact, sysdate);

        else
          if p_tipo_representante = 'N' then
            insert into suirplus.seg_usuario_permisos_t
              (id_usuario, id_role, ult_usuario_act, ult_fecha_act)
            values
              (p_idusuario, 31, p_ultusuarioact, sysdate);
          end if;
        end if;

      end if;

    end if;
    p_resultnumber := 0;
    commit;
    return;

  exception

    when e_faltinfo then
      p_resultnumber := seg_retornar_cadena_error(41, null, null);
      return;

    when e_usuarioactivo then
      p_resultnumber := seg_retornar_cadena_error(42, null, null);
      return;

    when e_invalidregpatronal then
      p_resultnumber := seg_retornar_cadena_error(3, null, null);
      return;

    when others then
      v_bderror      := (substr('error ' || to_char(sqlcode) || ': ' ||
                                sqlerrm,
                                1,
                                255));
      p_resultnumber := seg_retornar_cadena_error(-1, v_bderror, sqlcode);
      return;
  end;

  -- **************************************************************************************************
  -- Program:     Insertar_UsuarioPersona
  -- Description: Inserta un usuario
  -- **************************************************************************************************

  procedure Insertar_UsuarioPersona(p_idusuario      in suirplus.seg_usuario_t.id_usuario%type,
                                p_password           in suirplus.seg_usuario_t.password%type,
                                p_idnss              in suirplus.seg_usuario_t.id_nss%type,
                                p_idregistropatronal in suirplus.seg_usuario_t.id_registro_patronal%type,
                                p_email              in suirplus.seg_usuario_t.email%type,
                                p_ultusuarioact      in suirplus.seg_usuario_t.ult_usuario_act%type,
                                p_tipo_representante in suirplus.sre_representantes_t.tipo_representante%type,
                                p_resultnumber       out varchar2)

   is

    e_usuarioactivo exception;
    e_faltinfo exception;
    e_invalidregpatronal exception;
    v_bderror   varchar(1000);
    v_idusuario varchar2(35);
    v_status    varchar2(1);

    cursor c_cursor is
      select u.id_usuario, u.status
        from suirplus.seg_usuario_t u
       where u.id_usuario = p_idusuario;

  begin

    if (p_idnss is null) or (p_idregistropatronal is null) then
      raise e_faltinfo;
    end if;

    if not suirplus.Sre_Empleadores_Pkg.existeregistropatronal(p_idregistropatronal) then
      raise e_invalidregpatronal;
    end if;

    open c_cursor;
    fetch c_cursor
      into v_idusuario, v_status;
    close c_cursor;

    if p_idusuario is not null then

      if v_idusuario = p_idusuario then
        if v_status = 'A' then
          raise e_usuarioactivo;

        else
          update suirplus.seg_usuario_t u
             set u.status               = 'A',
                 u.password             = md5_digest(lower(p_password)),
                 u.id_nss               = p_idnss,
                 u.id_registro_patronal = p_idregistropatronal,
                 u.id_tipo_usuario      = 2
           where u.id_usuario = p_idusuario
             and u.status = 'I';
        end if;
      end if;

      if v_idusuario is null then
        insert into suirplus.seg_usuario_t
          (id_usuario,
           id_tipo_usuario,
           id_nss,
           id_registro_patronal,
           nombre_usuario,
           apellidos,
           password,
           email,
           status,
           ult_usuario_act,
           CAMBIAR_CLASS,
           ACTUALIZAR_EMAIL)
        values
          (p_idusuario,
           2,
           p_idnss,
           p_idregistropatronal,
           '  ',
           '  ',
           md5_digest(lower(p_password)),
           p_email,
           'A',
           p_ultusuarioact,
           'S',
           'N');

        commit;

          insert into suirplus.seg_usuario_permisos_t
            (id_usuario, id_role, ult_usuario_act, ult_fecha_act)
          values
            (p_idusuario, 51, p_ultusuarioact, sysdate);


      end if;

    end if;
    p_resultnumber := 0;
    commit;
    return;

  exception

    when e_faltinfo then
      p_resultnumber := seg_retornar_cadena_error(41, null, null);
      return;

    when e_usuarioactivo then
      p_resultnumber := seg_retornar_cadena_error(42, null, null);
      return;

    when e_invalidregpatronal then
      p_resultnumber := seg_retornar_cadena_error(3, null, null);
      return;

    when others then
      v_bderror      := (substr('error ' || to_char(sqlcode) || ': ' ||
                                sqlerrm,
                                1,
                                255));
      p_resultnumber := seg_retornar_cadena_error(-1, v_bderror, sqlcode);
      return;
  end;

  -- **************************************************************************************************
  -- Program:     Inactivar_Usuario
  -- Description: Inactiva un usuario
  -- **************************************************************************************************

  procedure Inactivar_UsuarioRep(p_idusuario     in suirplus.seg_usuario_t.id_usuario%type,
                                 p_ultusuarioact in suirplus.seg_usuario_t.ult_usuario_act%type,
                                 p_resultnumber  out varchar2) is
    e_invaliduser exception;
    v_bderror varchar(1000);

  begin

    if not suirplus.seg_usuarios_pkg.isExisteUsuario(p_idusuario) then
      raise e_invaliduser;
    elsif not suirplus.seg_usuarios_pkg.isExisteUsuario(p_ultusuarioact) then
      raise e_invaliduser;
    end if;

    update suirplus.seg_usuario_t u
       set u.status = 'I',
           u.ult_usuario_act = p_ultusuarioact,
           u.ult_fecha_act = sysdate
    where u.id_usuario = p_idusuario;
    commit;
    p_resultnumber :=0;

  exception
    when e_invaliduser then
      p_resultnumber := seg_retornar_cadena_error(1, null, null);
      return;

    when others then
      v_bderror      := (substr('error ' || to_char(sqlcode) || ': ' ||
                                sqlerrm,
                                1,
                                255));
      p_resultnumber := seg_retornar_cadena_error(-1, v_bderror, sqlcode);
      return;

  end;
 
  -- **************************************************************************************************
  -- Program:     Get_Roles_Activos
  -- Description: Trae los roles activos
  -- **************************************************************************************************

  procedure Roles_Activos(p_idusuario    in suirplus.seg_usuario_t.id_usuario%type,
                          p_iocursor     in out t_cursor,
                          p_resultnumber out varchar2) is
    e_invaliduser exception;
    v_bderror varchar(1000);
    c_cursor  t_cursor;

  begin

    if not suirplus.seg_usuarios_pkg.isExisteUsuario(p_idusuario) then
      raise e_invaliduser;
    end if;

    open c_cursor for
      select rl.id_role, rl.roles_des
        from suirplus.seg_usuario_permisos_t usu, suirplus.seg_roles_t rl
       where usu.id_usuario = p_idusuario
         and usu.id_role = rl.id_role
         and rl.status = 'A'
       order by rl.id_role;

    p_iocursor := c_cursor;

  exception

    when e_invaliduser then
      p_resultnumber := seg_retornar_cadena_error(1, null, null);
      return;

    when others then
      v_bderror      := (substr('error ' || to_char(sqlcode) || ': ' ||
                                sqlerrm,
                                1,
                                255));
      p_resultnumber := seg_retornar_cadena_error(-1, v_bderror, sqlcode);
      return;

  end;

  -- **************************************************************************************************
  -- Program:     Get_Permisos_Activos
  -- Description: Trae los permisos activos
  -- **************************************************************************************************

  procedure Permisos_Activos(p_idusuario    in suirplus.seg_usuario_t.id_usuario%type,
                             p_iocursor     in out t_cursor,
                             p_resultnumber out varchar2) is
    e_invaliduser exception;
    v_bderror varchar(1000);
    c_cursor  t_cursor;
  begin

    if not suirplus.seg_usuarios_pkg.isExisteUsuario(p_idusuario) then
      raise e_invaliduser;
    end if;

    open c_cursor for
      select distinct (id_permiso), permiso_des
        from (select p.id_permiso, p.permiso_des
                from suirplus.seg_usuario_permisos_t up, suirplus.seg_permiso_t p
               where up.id_usuario = p_idusuario
                 and up.id_permiso = p.id_permiso
                 and p.status = 'A'
              union all
              select pr.id_permiso, p.permiso_des
                from suirplus.seg_usuario_permisos_t  usu,
                     suirplus.seg_roles_t             rl,
                     suirplus.seg_rel_permiso_roles_t pr,
                     suirplus.seg_permiso_t           p
               where usu.id_usuario = p_idusuario
                 and usu.id_role = rl.id_role
                 and rl.id_role = pr.id_role
                 and pr.id_permiso = p.id_permiso
                 and rl.status = 'A'
              -- and pr.status = 'A'--**
              )
       order by id_permiso;

    p_iocursor := c_cursor;

  exception

    when e_invaliduser then
      p_resultnumber := seg_retornar_cadena_error(1, null, null);
      return;

    when others then
      v_bderror      := (substr('error ' || to_char(sqlcode) || ': ' ||
                                sqlerrm,
                                1,
                                255));
      p_resultnumber := seg_retornar_cadena_error(-1, v_bderror, sqlcode);
      return;

  end;

  -- **************************************************************************************************
  -- Program:     Get_Secciones
  -- Description: Trae las secciones
  -- **************************************************************************************************

  procedure Menu_Get_Secciones(p_idusuario    in suirplus.seg_usuario_t.id_usuario%type,
                               p_iocursor     in out t_cursor,
                               p_resultnumber out varchar2) is
    e_invaliduser exception;
    v_bderror varchar(1000);
    c_cursor  t_cursor;
  begin

    if not suirplus.seg_usuarios_pkg.isExisteUsuario(p_idusuario) then
      raise e_invaliduser;
    end if;

    open c_cursor for
      select distinct (seccion_des) seccion, id_seccion
        from (select s.seccion_des, s.id_seccion
                from suirplus.seg_usuario_permisos_t up,
                     suirplus.seg_permiso_t          p,
                     suirplus.seg_seccion_t          s
               where up.id_usuario = p_idusuario
                 and up.id_permiso = p.id_permiso
                 and p.id_seccion = s.id_seccion
                 and p.status = 'A'
              union all
              select s.seccion_des, s.id_seccion
                from suirplus.seg_usuario_permisos_t  usu,
                     suirplus.seg_roles_t             rl,
                     suirplus.seg_rel_permiso_roles_t pr,
                     suirplus.seg_permiso_t           p,
                     suirplus.seg_seccion_t           s
               where usu.id_usuario = p_idusuario
                 and usu.id_role = rl.id_role
                 and rl.id_role = pr.id_role
                 and pr.id_permiso = p.id_permiso
                 and p.id_seccion = s.id_seccion
                 and rl.status = 'A'
              --  and pr.status = 'A'--**
              )
       order by seccion_des;

    p_iocursor := c_cursor;

  exception

    when e_invaliduser then
      p_resultnumber := seg_retornar_cadena_error(1, null, null);
      return;

    when others then
      v_bderror      := (substr('error ' || to_char(sqlcode) || ': ' ||
                                sqlerrm,
                                1,
                                255));
      p_resultnumber := seg_retornar_cadena_error(-1, v_bderror, sqlcode);
      return;

  end;

  -- **************************************************************************************************
  -- Program:     Permisos_Por_Seccion
  -- Description: Trae los permisos por secciones
  -- **************************************************************************************************

  procedure Menu_Permisos_Por_Seccion(p_idusuario    in suirplus.seg_usuario_t.id_usuario%type,
                                      p_idseccion    in suirplus.seg_seccion_t.id_seccion%type,
                                      p_iocursor     in out t_cursor,
                                      p_resultnumber out varchar2) is
    e_invaliduser exception;
    e_invalidseccion exception;
    v_bderror varchar(1000);
    c_cursor  t_cursor;

  begin

    if not suirplus.seg_usuarios_pkg.isExisteUsuario(p_idusuario) then
      raise e_invaliduser;
    end if;

    if not suirplus.seg_seccion_pkg.isExisteSeccion(p_idseccion) then
      raise e_invalidseccion;
    end if;

    open c_cursor for
      select distinct (id_permiso), permiso_des, direccion_electronica
        from (select p.id_permiso, p.permiso_des, p.direccion_electronica
                from suirplus.seg_usuario_permisos_t up, suirplus.seg_permiso_t p
               where up.id_usuario = p_idusuario
                 and up.id_permiso = p.id_permiso
                 and p.id_seccion = p_idseccion
                 and p.tipo_permiso = 'M'
                 and p.status = 'A'
              union all
              select p.id_permiso, p.permiso_des, p.direccion_electronica
                from suirplus.seg_usuario_permisos_t  usu,
                     suirplus.seg_roles_t             rl,
                     suirplus.seg_rel_permiso_roles_t pr,
                     suirplus.seg_permiso_t           p
               where usu.id_usuario = p_idusuario
                 and usu.id_role = rl.id_role
                 and rl.id_role = pr.id_role
                 and pr.id_permiso = p.id_permiso
                 and p.id_seccion = p_idseccion
                 and p.tipo_permiso = 'M'
                 and rl.status = 'A'
              -- and pr.status = 'A'--**
              )
       order by permiso_des;

    p_iocursor := c_cursor;

  exception

    when e_invaliduser then
      p_resultnumber := seg_retornar_cadena_error(1, null, null);
      return;

    when e_invalidseccion then
      p_resultnumber := seg_retornar_cadena_error(10, null, null);
      return;

    when others then
      v_bderror      := (substr('error ' || to_char(sqlcode) || ': ' ||
                                sqlerrm,
                                1,
                                255));
      p_resultnumber := seg_retornar_cadena_error(-1, v_bderror, sqlcode);
      return;

  end;

  -- **************************************************************************************************
  -- Program:     Get_Usuarios
  -- Description: Trae los Usuarios
  -- **************************************************************************************************
  procedure Get_Usuarios(p_idusuario in suirplus.seg_usuario_t.id_usuario%type,
                         p_nombres   in suirplus.seg_usuario_t.nombre_usuario%type,
                         p_apellidos in suirplus.seg_usuario_t.apellidos%type,
                         p_role      in suirplus.seg_roles_t.id_role%type,
                         p_idEntidad in suirplus.sfc_entidad_recaudadora_t.id_entidad_recaudadora%type,
                         p_iocursor  in out t_cursor) is
    v_tipousuario suirplus.seg_usuario_t.id_tipo_usuario%type;
    c_cursor      t_cursor;
  begin

    if p_idusuario is not null then
      if p_role is null then
        if suirplus.seg_usuarios_pkg.isExisteUsuario(p_idusuario) then
          select u.id_tipo_usuario
            into v_tipousuario
            from suirplus.seg_usuario_t u
           where u.id_usuario = upper(p_idusuario);
          if v_tipousuario = 1 then
            -- usuario normal
            open c_cursor for
              select u.id_usuario,
                     initcap(u.nombre_usuario || ' ' || u.apellidos) nombre,
                     u.nombre_usuario,
                     u.apellidos,
                     u.cantidad_intentos,
                     suirplus.srp_pkg.descestatus(u.status) statusdesc,
                     u.status,
                     lower(u.email) email,
                     u.id_tipo_usuario,
                     u.password,
                     u.id_entidad_recaudadora,
                     u.departamento,
                     u.comentario,
                     u.cambiar_class,
                     u.ult_login,
                     u.ip,
                     u.ult_fecha_act,
                     u.ult_usuario_act
                from suirplus.seg_usuario_t u
               where id_usuario = upper(p_idusuario)
               order by u.nombre_usuario, u.apellidos;
          else
            -- representante
            open c_cursor for
              select u.id_usuario,
                     initcap(c.nombres || ' ' || c.primer_apellido || ' ' ||
                             c.segundo_apellido) nombre,
                     c.nombres nombre_usuario,
                     c.primer_apellido || ' ' || c.segundo_apellido apellidos,
                     u.cantidad_intentos,
                     suirplus.srp_pkg.descestatus(u.status) statusdesc,
                     u.status,
                     lower(u.email) email,
                     u.id_tipo_usuario,
                     u.password,
                     u.id_entidad_recaudadora,
                     u.departamento,
                     u.comentario,
                     u.cambiar_class,
                     u.ult_login,
                     u.ip,
                     u.ult_fecha_act,
                     u.ult_usuario_act
                from suirplus.seg_usuario_t u, suirplus.sre_ciudadanos_t c
               where id_usuario = upper(p_idusuario)
                 and u.id_nss = c.id_nss
               order by u.nombre_usuario, u.apellidos;
          end if;
        else
          open c_cursor for
            select u.id_usuario,
                   u.id_tipo_usuario,
                   u.id_nss,
                   u.id_registro_patronal,
                   u.password,
                   u.nombre_usuario,
                   u.apellidos,
                   u.cantidad_intentos,
                   u.status,
                   u.email,
                   u.ult_fecha_act,
                   u.ult_usuario_act,
                   u.id_entidad_recaudadora,
                   u.departamento,
                   u.comentario,
                   u.cambiar_class,
                   u.ult_login,
                   u.ip,
                   u.ult_fecha_act,
                   u.ult_usuario_act
              from suirplus.seg_usuario_t u
             where u.id_usuario = p_idusuario;

        end if;
      else
        --Ok es de un Banco o de la DGII
        if suirplus.seg_usuarios_pkg.isExisteUsuario(p_idusuario) then
          select u.id_tipo_usuario
            into v_tipousuario
            from suirplus.seg_usuario_t u
           where u.id_usuario = upper(p_idusuario);
          if v_tipousuario = 1 then
            -- usuario normal
            open c_cursor for
              select u.id_usuario,
                     initcap(u.nombre_usuario || ' ' || u.apellidos) nombre,
                     u.nombre_usuario,
                     u.apellidos,
                     u.cantidad_intentos,
                     suirplus.srp_pkg.descestatus(u.status) statusdesc,
                     u.status,
                     lower(u.email) email,
                     u.id_tipo_usuario,
                     u.password,
                     u.id_entidad_recaudadora,
                     u.departamento,
                     u.comentario,
                     u.cambiar_class,
                     u.ult_login,
                     u.ip,
                     u.ult_fecha_act,
                     u.ult_usuario_act
                from suirplus.seg_usuario_t u, suirplus.seg_usuario_permisos_t p
               where u.id_usuario = upper(p_idusuario)
                 and u.id_usuario = p.id_usuario
                 and p.id_role = p_role
                 and u.id_entidad_recaudadora = p_idEntidad
               order by u.nombre_usuario, u.apellidos;
          else
            -- representante
            open c_cursor for
              select u.id_usuario,
                     initcap(c.nombres || ' ' || c.primer_apellido || ' ' ||
                             c.segundo_apellido) nombre,
                     c.nombres nombre_usuario,
                     c.primer_apellido || ' ' || c.segundo_apellido apellidos,
                     u.cantidad_intentos,
                     suirplus.srp_pkg.descestatus(u.status) statusdesc,
                     u.status,
                     lower(u.email) email,
                     u.id_tipo_usuario,
                     u.password,
                     u.id_entidad_recaudadora,
                     u.departamento,
                     u.comentario,
                     u.cambiar_class,
                     u.ult_login,
                     u.ip,
                     u.ult_fecha_act,
                     u.ult_usuario_act
                from suirplus.seg_usuario_t u, suirplus.sre_ciudadanos_t c
               where 7 = 8;
          end if;
        else
          open c_cursor for
            select u.id_usuario,
                   u.id_tipo_usuario,
                   u.id_nss,
                   u.id_registro_patronal,
                   u.password,
                   u.nombre_usuario,
                   u.apellidos,
                   u.cantidad_intentos,
                   u.status,
                   u.email,
                   u.ult_fecha_act,
                   u.ult_usuario_act,
                   u.id_entidad_recaudadora,
                   u.departamento,
                   u.comentario,
                   u.cambiar_class,
                   u.ult_login,
                   u.ip,
                   u.ult_fecha_act,
                   u.ult_usuario_act
              from suirplus.seg_usuario_t u
             where u.id_usuario = p_idusuario;

        end if;
      end if;

    else
      -- La busqueda es por Nombre o Apellido
      if p_role is null then
        -- Es un Usuario Normal
        open c_cursor for
          select *
          from (SELECT  u.id_usuario,
                 initcap(c.nombres || ' ' || c.primer_apellido) nombre,
                   c.nombres,
                 c.primer_apellido || ' ' || c.segundo_apellido apellidos,
                 u.cantidad_intentos,
                suirplus.srp_pkg.descestatus(u.status) statusdesc,
                 u.status,
                 lower(u.email) email,
                 u.id_tipo_usuario,
                 u.password,
                 u.id_entidad_recaudadora,
                 u.departamento,
                 u.comentario,
                 u.cambiar_class,
                 u.ult_login,
                 u.ip,
                 u.ult_fecha_act,
                 u.ult_usuario_act

            FROM suirplus.seg_usuario_t u inner join suirplus.sre_ciudadanos_t c
            on u.id_nss = c.id_nss            
            union all            
            select u.id_usuario,
                 initcap(u.nombre_usuario || ' ' || u.apellidos) nombre,
                 u.nombre_usuario,
                 u.apellidos,
                 u.cantidad_intentos,
                 suirplus.srp_pkg.descestatus(u.status) statusdesc,
                 u.status,
                 lower(u.email) email,
                 u.id_tipo_usuario,
                 u.password,
                 u.id_entidad_recaudadora,
                 u.departamento,
                 u.comentario,
                 u.cambiar_class,
                 u.ult_login,
                 u.ip,
                 u.ult_fecha_act,
                 u.ult_usuario_act
            FROM suirplus.seg_usuario_t u 
            where u.id_nss is null) n
            where upper(n.nombre) like upper(p_nombres) || '%' and upper(n.apellidos) like upper(p_apellidos) || '%'
          order by n.nombres, n.apellidos;
      elsif ((p_role = 56) or (p_role = 46) or (p_role = 699) or (p_role = 135)) then
        -- Es un Usuario de un Banco o la DGII
        open c_cursor for
          select u.id_usuario,
                 initcap(u.nombre_usuario || ' ' || u.apellidos) nombre,
                 u.nombre_usuario,
                 u.apellidos,
                 u.cantidad_intentos,
                 suirplus.srp_pkg.descestatus(u.status) statusdesc,
                 u.status,
                 lower(u.email) email,
                 u.id_tipo_usuario,
                 u.password,
                 u.id_entidad_recaudadora,
                 u.departamento,
                 u.comentario,
                 u.cambiar_class,
                 u.ult_login,
                 u.ip,
                 u.ult_fecha_act,
                 u.ult_usuario_act
            from suirplus.seg_usuario_t u, suirplus.seg_usuario_permisos_t p
           where u.id_usuario = p.id_usuario
             and p.id_role = p_role
             and upper(u.nombre_usuario) like upper(p_nombres) || '%'
             and upper(u.apellidos) like upper(p_apellidos) || '%'
             and u.id_entidad_recaudadora = p_idEntidad
           order by u.nombre_usuario, u.apellidos;
      end if;

    end if;

    p_iocursor := c_cursor;
  end;


  -- **************************************************************************************************
  -- Program:     Crear_Usuario
  -- Description: Crea un usuario
  -- Modification: Abizer Matos 26/05/2008 | Se agregaron mas campos.
  -- **************************************************************************************************

  procedure Crear_Usuario(p_idusuario        suirplus.seg_usuario_t.id_usuario%type,
                          p_password         suirplus.seg_usuario_t.password%type,
                          p_nombreusuario    suirplus.seg_usuario_t.nombre_usuario%type,
                          p_apellidosusuario suirplus.seg_usuario_t.apellidos%type,
                          p_email            suirplus.seg_usuario_t.email%type,
                          p_estatus          suirplus.seg_usuario_t.status%type,
                          p_ultusuarioact    suirplus.seg_usuario_t.ult_usuario_act%type
                          --abiezer
                         ,
                          p_departamento suirplus.seg_usuario_t.departamento%type,
                          p_eRecaudadora suirplus.seg_usuario_t.id_entidad_recaudadora%type,
                          p_comentario   suirplus.seg_usuario_t.comentario%type,
                          p_resultnumber out varchar2) is

    -- variables a utilizar
    e_nonexistentuser exception;
    e_existentuser exception;
    e_longervalue exception;
    e_statusinvalido exception;
    e_parametrosnulos exception;
    v_bderror    varchar(1000);
    v_Cuenta     number;
    v_EntidadRec number;
    --v_valorIdRecaudadora int;

  begin

    -- verificar que no vengan campos nulos
    if (p_idusuario is null) or (p_password is null) or
       (p_nombreusuario is null) or (p_apellidosusuario is null) or
       (p_estatus is null) or (p_email is null) or
       (p_ultusuarioact is null) then
      raise e_parametrosnulos;
    end if;

    -- verificar que el username no este ya en la base de datos.
    if suirplus.seg_usuarios_pkg.isExisteUsuario(p_idusuario) then
      raise e_existentuser;
    end if;

    -- verificar que el username que este actualizado exista en la base de datos
    if not suirplus.seg_usuarios_pkg.isExisteUsuario(p_ultusuarioact) then
      raise e_nonexistentuser;
    end if;

    -- verificar que el status sea valido
    if not suirplus.srp_pkg.is_validoestatus(p_estatus) then
      raise e_statusinvalido;
    end if;

    if seg_get_largo_columna('SEG_USUARIO_T', 'NOMBRE_USUARIO') <
       length(p_nombreusuario) or
       seg_get_largo_columna('SEG_USUARIO_T', 'APELLIDOS') <
       length(p_apellidosusuario) or
       seg_get_largo_columna('SEG_USUARIO_T', 'PASSWORD') <
       length(p_password) or
       seg_get_largo_columna('SEG_USUARIO_T', 'EMAIL') < length(p_email) then
      raise e_longervalue;
    end if;

    -----------------------------------
    -- CPena: 2011-10-27
    -----------------------------------
    if p_eRecaudadora = '-1' then
      v_EntidadRec := 0;
    end if;
    --  v_EntidadRec := p_eRecaudadora;
    -----------------------------------

    if v_EntidadRec = 0 then
      v_EntidadRec := null;
    else
      v_EntidadRec := p_eRecaudadora;
    end if;

    -- insertar el usuario
    insert into suirplus.seg_usuario_t
      (id_usuario,
       id_tipo_usuario,
       password,
       nombre_usuario,
       apellidos,
       cantidad_intentos,
       status,
       email,
       ult_usuario_act,
       CAMBIAR_CLASS,
       id_entidad_recaudadora,
       departamento,
       comentario)
    values
      (upper(p_idusuario),
       '1',
       md5_digest(lower(p_password)),
       p_nombreusuario,
       p_apellidosusuario,
       0,
       p_estatus,
       p_email,
       p_ultusuarioact,
       'S',
       v_EntidadRec,
       p_departamento,
       p_comentario);

    -- Verificar si es Usuario de un Banco
    Select count(*)
      into v_Cuenta
      from suirplus.seg_usuario_t u, suirplus.seg_usuario_permisos_t p
     where u.id_usuario = p_ultusuarioact
       and u.id_usuario = p.id_usuario
       and p.id_role = 56;

    if v_Cuenta = 1 then
      -- Es de un Banco

      Select u.id_entidad_recaudadora
        into v_EntidadRec
        from suirplus.seg_usuario_t u
       where u.id_usuario = p_ultusuarioact;

      Update suirplus.seg_usuario_t u
         set u.id_entidad_recaudadora = v_EntidadRec
       where u.id_usuario = upper(p_idusuario);

      Insert into suirplus.seg_usuario_permisos_t
        (id_usuario, id_role)
      values
        (upper(p_idusuario), 56);

    end if;

    -- Verificar si es de la DGII
    Select count(*)
      into v_Cuenta
      from suirplus.seg_usuario_t u, suirplus.seg_usuario_permisos_t p
     where u.id_usuario = p_ultusuarioact
       and u.id_usuario = p.id_usuario
       and p.id_role = 46;

    if v_Cuenta = 1 then
      -- Es de un DGII

      Select u.id_entidad_recaudadora
        into v_EntidadRec
        from suirplus.seg_usuario_t u
       where u.id_usuario = p_ultusuarioact;

      Update suirplus.seg_usuario_t u
         set u.id_entidad_recaudadora = v_EntidadRec
       where u.id_usuario = upper(p_idusuario);

      Insert into suirplus.seg_usuario_permisos_t
        (id_usuario, id_role)
      values
        (upper(p_idusuario), 46);

    end if;

    -- Verificar si es Usuario de un CCG
    Select count(*)
      into v_Cuenta
      from suirplus.seg_usuario_t u, suirplus.seg_usuario_permisos_t p
     where u.id_usuario = p_ultusuarioact
       and u.id_usuario = p.id_usuario
       and p.id_role = 235;

    if v_Cuenta = 1 then
      -- Es de un CCG

      Select u.id_entidad_recaudadora
        into v_EntidadRec
        from suirplus.seg_usuario_t u
       where u.id_usuario = p_ultusuarioact;

      Update suirplus.seg_usuario_t u
         set u.id_entidad_recaudadora = v_EntidadRec
       where u.id_usuario = upper(p_idusuario);

      Insert into suirplus.seg_usuario_permisos_t
        (id_usuario, id_role)
      values
        (upper(p_idusuario), 235);

    end if;


    -- Verificar si es Usuario de una AFP
    Select count(*)
      into v_Cuenta
      from suirplus.seg_usuario_t u, suirplus.seg_usuario_permisos_t p
     where u.id_usuario = p_ultusuarioact
       and u.id_usuario = p.id_usuario
       and p.id_role = 699;

    if v_Cuenta = 1 then


      Select u.id_entidad_recaudadora
        into v_EntidadRec
        from suirplus.seg_usuario_t u
       where u.id_usuario = p_ultusuarioact;

      Update suirplus.seg_usuario_t u
         set u.id_entidad_recaudadora = v_EntidadRec
       where u.id_usuario = upper(p_idusuario);

      Insert into suirplus.seg_usuario_permisos_t
        (id_usuario, id_role)
      values
        (upper(p_idusuario), 699);

    end if;


    -- Verificar si es Usuario de la DIDA
    Select count(*)
      into v_Cuenta
      from suirplus.seg_usuario_t u, suirplus.seg_usuario_permisos_t p
     where u.id_usuario = p_ultusuarioact
       and u.id_usuario = p.id_usuario
       and p.id_role = 135;

    if v_Cuenta = 1 then


      Select u.id_entidad_recaudadora
        into v_EntidadRec
        from suirplus.seg_usuario_t u
       where u.id_usuario = p_ultusuarioact;

      Update suirplus.seg_usuario_t u
         set u.id_entidad_recaudadora = v_EntidadRec
       where u.id_usuario = upper(p_idusuario);

      Insert into suirplus.seg_usuario_permisos_t
        (id_usuario, id_role)
      values
        (upper(p_idusuario), 135);

    end if;

    p_resultnumber := 0;

    commit;

    -- manejo de excepciones
  exception
    when e_nonexistentuser then
      p_resultnumber := seg_retornar_cadena_error(1, null, null);
      return;

    when e_existentuser then
      p_resultnumber := seg_retornar_cadena_error(4, null, null);
      return;

    when e_longervalue then
      p_resultnumber := seg_retornar_cadena_error(18, null, null);
      return;

    when e_statusinvalido then
      p_resultnumber := seg_retornar_cadena_error(22, null, null);
      return;

    when e_parametrosnulos then
      p_resultnumber := seg_retornar_cadena_error(8, null, null);
      return;

    when others then
      v_bderror      := (substr('error ' || to_char(sqlcode) || ': ' ||
                                sqlerrm,
                                1,
                                255));
      p_resultnumber := seg_retornar_cadena_error(-1, v_bderror, sqlcode);
      return;
  end;



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
                          p_estatus         suirplus.seg_usuario_t.status%type,
                          p_ultusuarioact    suirplus.seg_usuario_t.ult_usuario_act%type,
                          p_resultnumber out varchar2) is

    -- variables a utilizar
    e_nonexistentuser exception;
    e_existentuser exception;
    e_longervalue exception;
    e_statusinvalido exception;
    e_parametrosnulos exception;
    e_noexisteusuariopasaporte exception;
    v_bderror    varchar(1000);
    v_nombres    suirplus.seg_usuario_t.nombre_usuario%type;
    v_apellido    suirplus.seg_usuario_t.apellidos%type;

  begin

    -- verificar que no vengan campos nulos
    if (p_idusuario is null) or (p_password is null) or
       (p_estatus is null) or (p_email is null) or
       (p_ultusuarioact is null) then
      raise e_parametrosnulos;
    end if;

    -- verificar que el username no este ya en la base de datos.
   /* if seg_usuarios_pkg.isExisteUsuario(p_idusuario) then
      raise e_existentuser;
    end if;*/

    -- verificar que el username que este actualizado exista en la base de datos
    if not suirplus.seg_usuarios_pkg.isExisteUsuario(p_ultusuarioact) then
      raise e_nonexistentuser;
    end if;

    -- verificar que el status sea valido
    if not suirplus.srp_pkg.is_validoestatus(p_estatus) then
      raise e_statusinvalido;
    end if;


   if  seg_get_largo_columna('SEG_USUARIO_T', 'PASSWORD') <
       length(p_password) or
       seg_get_largo_columna('SEG_USUARIO_T', 'EMAIL') < length(p_email) then
      raise e_longervalue;
    end if;

    if length(p_idusuario) > 0 then
      
    if p_tipo_documento = 'C' then
        select ciu.nombres,(ciu.primer_apellido||' '||ciu.segundo_apellido) apellidos
        into v_nombres,v_apellido
        from suirplus.sre_ciudadanos_t ciu
        where ciu.no_documento = p_idusuario and ciu.tipo_documento = p_tipo_documento;

        p_nombreusuario:= v_nombres;
        p_apellidosusuario:= v_apellido;
      /*else                             
        suirplus.sre_ciudadano_pkg.IsExisteCiudadano(p_idusuario,p_tipo_documento,p_resultnumber);
            
            if not p_resultnumber = 0 then
              select ciu.nombres,(ciu.primer_apellido||' '||ciu.segundo_apellido) apellidos
              into v_nombres,v_apellido
              from sre_ciudadanos_t ciu
              where ciu.no_documento = p_idusuario and ciu.tipo_documento = p_tipo_documento;

              p_nombreusuario:= v_nombres;
              p_apellidosusuario:= v_apellido;
              else
                raise e_noexisteusuariopasaporte;
              
          end if;*/
      end if;
   end if;

    -- insertar el usuario
    insert into suirplus.seg_usuario_t
      (id_usuario,
       id_tipo_usuario,
       password,
       nombre_usuario,
       apellidos,
       cantidad_intentos,
       status,
       email,
       ult_usuario_act)
    values
      (upper(p_idusuario),
       '3',
       md5_digest(lower(p_password)),
       p_nombreusuario,
       p_apellidosusuario,
       0,
       p_estatus,
       p_email,
       p_ultusuarioact);

    p_resultnumber := 0;

    commit;

    -- manejo de excepciones
  exception
    when e_nonexistentuser then
      p_resultnumber := seg_retornar_cadena_error(1, null, null);
      return;

    when e_existentuser then
      p_resultnumber := seg_retornar_cadena_error(42, null, null);
      return;

    when e_longervalue then
      p_resultnumber := seg_retornar_cadena_error(18, null, null);
      return;

    when e_statusinvalido then
      p_resultnumber := seg_retornar_cadena_error(22, null, null);
      return;
      
      when e_noexisteusuariopasaporte then
        p_resultnumber := seg_retornar_cadena_error(-1,'Pasaporte invalido,favor verificar',null);

    when e_parametrosnulos then
      p_resultnumber := seg_retornar_cadena_error(8, null, null);
      return;

    when others then
      v_bderror      := (substr('error ' || to_char(sqlcode) || ': ' ||
                                sqlerrm,
                                1,
                                255));
      p_resultnumber := seg_retornar_cadena_error(-1, v_bderror, sqlcode);
      return;
  end;

  -- **************************************************************************************************
  -- Program:     Borrar_Usuario
  -- Description: Elimina un usuario de la tabla SEG_USUARIO_T
  -- **************************************************************************************************

  procedure Borrar_Usuario(p_idusuario    suirplus.seg_usuario_t.id_usuario%type,
                           p_resultnumber out varchar2) is
    e_existentuser exception;
    v_bderror varchar(1000);
  begin
    if not suirplus.seg_usuarios_pkg.isExisteUsuario(p_idusuario) then
      raise e_existentuser;
    end if;

    delete from suirplus.seg_usuario_t u where u.id_usuario = p_idusuario;
    Commit;
    p_resultnumber := '0';

  exception

    when e_existentuser then
      p_resultnumber := seg_retornar_cadena_error(4, null, null);
      return;

    /*
            when others then
              p_resultnumber := seg_retornar_cadena_error(9, null, null);
            return;
    */
    when others then
      v_bderror      := (substr('error ' || to_char(sqlcode) || ': ' ||
                                sqlerrm,
                                1,
                                255));
      p_resultnumber := seg_retornar_cadena_error(-1, v_bderror, sqlcode);
      return;
  end;

  -- **************************************************************************************************
  -- Program:     Editar_usuario
  -- Description: Edita el registro de los usuarios
  -- **************************************************************************************************

  procedure Editar_Usuario(p_id_usuario        suirplus.seg_usuario_t.id_usuario%type, -- *  parametros para insertar usuario
                           p_password          suirplus.seg_usuario_t.password%type,
                           p_nombre_usuario    suirplus.seg_usuario_t.nombre_usuario%type,
                           p_apellidos_usuario suirplus.seg_usuario_t.apellidos%type,
                           p_email             suirplus.seg_usuario_t.email%type,
                           p_estatus           suirplus.seg_usuario_t.status%type,
                           p_ult_usuario_act   suirplus.seg_usuario_t.ult_usuario_act%type,
                           p_departamento      suirplus.seg_usuario_t.departamento%type,
                           p_eRecaudadora      suirplus.seg_usuario_t.id_entidad_recaudadora%type,
                           p_comentario        suirplus.seg_usuario_t.comentario%type,
                           p_resultnumber      out varchar2)

   is
    -- variables a utilizar
    e_invaliduser exception;
    e_invalidpermiso exception;
    v_bd_error           varchar(1000);
    v_valorIdRecaudadora int;
  begin

    if not suirplus.seg_usuarios_pkg.isExisteUsuario(p_id_usuario) then
      raise e_invaliduser;

    elsif not suirplus.seg_usuarios_pkg.isExisteUsuario(p_ult_usuario_act) then
      raise e_invaliduser;

    end if;

    -----------------------------------
    -- CPena: 2011-10-27
    -----------------------------------
    if p_eRecaudadora = '-1' then
      v_valorIdRecaudadora := 0;
    end if;

    -- v_valorIdRecaudadora := p_eRecaudadora;
    -----------------------------------

    if v_valorIdRecaudadora = 0 then
      v_valorIdRecaudadora := null;
    else
      v_valorIdRecaudadora := p_eRecaudadora;
    end if;

    update suirplus.seg_usuario_t
       set nombre_usuario         = p_nombre_usuario,
           apellidos              = p_apellidos_usuario,
           status                 = p_estatus,
           email                  = p_email,
           ult_usuario_act        = p_ult_usuario_act,
           ult_fecha_act          = sysdate,
           id_entidad_recaudadora = v_valorIdRecaudadora,
           departamento           = p_departamento,
           comentario             = p_comentario
     where id_usuario = p_id_usuario;

    p_resultnumber := 0;
    commit;
    return;

  exception

    when e_invaliduser then
      p_resultnumber := seg_retornar_cadena_error(1, null, null);

    when others then
      v_bd_error     := (substr('error ' || to_char(sqlcode) || ': ' ||
                                sqlerrm,
                                1,
                                255));
      p_resultnumber := seg_retornar_cadena_error(-1, v_bd_error, sqlcode);
      return;
  end;

  -- **************************************************************************************************
  -- Program:     Eliminar_Asig_Perm_Usuario
  -- Description: Para eliminar una asignacion de permiso a un usuario
  -- **************************************************************************************************

  procedure Eliminar_Perm_Usuario(p_id_permiso      suirplus.seg_permiso_t.id_permiso%type,
                                  p_id_role         suirplus.seg_roles_t.id_role%type,
                                  p_id_usuario      suirplus.seg_usuario_t.id_usuario%type,
                                  p_ult_usuario_act suirplus.seg_usuario_t.id_usuario%type,
                                  p_resultnumber    out varchar2)

   is
    -- variables a utilizar
    e_invalidpermiso exception;
    e_invalidrole exception;
    e_invaliduser exception;
    e_ambiguousvalues exception;
    e_nullparameter exception;
    e_rownotfound exception;

    v_bd_error varchar(1000);
    v_tmpid    number;

    cursor existentrole is
      select id_role
        from suirplus.seg_usuario_permisos_t tr
       where tr.id_role = p_id_role;

    cursor existentpermiso is
      select id_permiso
        from suirplus.seg_usuario_permisos_t tr
       where tr.id_permiso = p_id_permiso;

  begin
    if p_id_permiso is null and p_id_role is null then
      raise e_nullparameter;
    end if;

    if p_id_permiso is not null then
      if not suirplus.seg_permisos_pkg.isExistePermiso(p_id_permiso) then
        raise e_invalidpermiso;
      end if;
    end if;

    if p_id_role is not null then
      if not suirplus.seg_roles_pkg.isExisteRole(p_id_role) then
        raise e_invalidrole;
      end if;
    end if;

    if not suirplus.seg_usuarios_pkg.isExisteUsuario(p_id_usuario) then
      raise e_invaliduser;
    end if;

    if not suirplus.seg_usuarios_pkg.isExisteUsuario(p_ult_usuario_act) then
      raise e_invaliduser;
    end if;

    if nvl(p_id_role, 0) < 1 and nvl(p_id_permiso, 0) < 1 then
      raise e_nullparameter;

    elsif nvl(p_id_role, 0) > 1 and nvl(p_id_permiso, 0) > 1 then
      raise e_ambiguousvalues;
    end if;

    if nvl(p_id_role, 0) > nvl(p_id_permiso, 0) then
      open existentrole;
      fetch existentrole
        into v_tmpid;
      if existentrole%notfound then
        close existentrole;
        raise e_rownotfound;
      else
        close existentrole;
      end if;

      delete suirplus.seg_usuario_permisos_t t
       where t.id_role = p_id_role
         and t.id_usuario = p_id_usuario;

      p_resultnumber := 0;
      commit;

    elsif nvl(p_id_permiso, 0) > nvl(p_id_role, 0) then

      open existentpermiso;
      fetch existentpermiso
        into v_tmpid;
      if existentpermiso%notfound then
        close existentpermiso;
        raise e_rownotfound;
      else
        close existentpermiso;
      end if;

      delete suirplus.seg_usuario_permisos_t t
       where t.id_permiso = p_id_permiso
         and t.id_usuario = p_id_usuario;

      p_resultnumber := 0;
      commit;
      return;

    end if;

  exception

    when e_invalidpermiso then
      p_resultnumber := seg_retornar_cadena_error(5, null, null);
      return;

    when e_invalidrole then
      p_resultnumber := seg_retornar_cadena_error(6, null, null);
      return;

    when e_invaliduser then
      p_resultnumber := seg_retornar_cadena_error(1, null, null);
      return;

    when e_ambiguousvalues then
      p_resultnumber := seg_retornar_cadena_error(7, null, null);
      return;

    when e_nullparameter then
      p_resultnumber := seg_retornar_cadena_error(8, null, null);
      return;

    when e_rownotfound then
      p_resultnumber := seg_retornar_cadena_error(10, null, null);
      return;

    when others then
      v_bd_error     := (substr('error ' || to_char(sqlcode) || ': ' ||
                                sqlerrm,
                                1,
                                255));
      p_resultnumber := seg_retornar_cadena_error(-1, v_bd_error, sqlcode);
      return;
  end;

  -- **************************************************************************************************
  -- Program:     Asignar_Perm_Usuario
  -- Description: Para realizar una asignacion de permiso a un usuario
  -- **************************************************************************************************
  procedure Asignar_Perm_Usuario(p_id_permiso      suirplus.seg_permiso_t.id_permiso%type,
                                 p_id_role         suirplus.seg_roles_t.id_role%type,
                                 p_id_usuario      suirplus.seg_usuario_t.id_usuario%type,
                                 p_ult_usuario_act suirplus.seg_usuario_t.id_usuario%type,
                                 p_resultnumber    out varchar2)

   as
    -- variables a utilizar
    e_ambiguousvalues exception;
    e_nullparameter exception;
    e_invalidrole exception;
    e_invalidpermiso exception;
    e_invaliduser exception;

    v_bd_error varchar(1000);

  begin

    if (nvl(p_id_role, 0) > 0) and (nvl(p_id_permiso, 0) > 0) then
      raise e_ambiguousvalues;
    end if;

    if nvl(p_id_role, 0) > nvl(p_id_permiso, 0) then
      if not suirplus.seg_roles_pkg.isExisteRole(p_id_role) then
        raise e_invalidrole;
      end if;

    elsif nvl(p_id_permiso, 0) > nvl(p_id_role, 0) then
      if not suirplus.seg_permisos_pkg.isExistePermiso(p_id_permiso) then
        raise e_invalidpermiso;
      end if;

    elsif nvl(p_id_permiso, 0) < 1 and nvl(p_id_role, 0) < 1 then
      raise e_nullparameter;
    end if;

    if not suirplus.seg_usuarios_pkg.isExisteUsuario(p_id_usuario) then
      raise e_invaliduser;
    end if;

    if not suirplus.seg_usuarios_pkg.isExisteUsuario(p_ult_usuario_act) then
      raise e_invaliduser;
    end if;

    if nvl(p_id_role, 0) > nvl(p_id_permiso, 0) then

      insert into suirplus.seg_usuario_permisos_t
        (id_role, id_usuario, ult_usuario_act, ult_fecha_act)
      values
        (p_id_role, p_id_usuario, p_ult_usuario_act, sysdate);

      p_resultnumber := 0;
      commit;
      return;

    elsif nvl(p_id_permiso, 0) > nvl(p_id_role, 0) then
      insert into suirplus.seg_usuario_permisos_t
        (id_permiso, id_usuario, ult_usuario_act)
      values
        (p_id_permiso, p_id_usuario, p_ult_usuario_act);

      p_resultnumber := 0;
      commit;
      return;
    end if;

  exception

    when e_ambiguousvalues then
      p_resultnumber := seg_retornar_cadena_error(7, null, null);

    when e_nullparameter then
      p_resultnumber := seg_retornar_cadena_error(8, null, null);

    when e_invalidrole then
      p_resultnumber := seg_retornar_cadena_error(6, null, null);

    when e_invalidpermiso then
      p_resultnumber := seg_retornar_cadena_error(5, null, null);

    when e_invaliduser then
      p_resultnumber := seg_retornar_cadena_error(1, null, null);

    when others then
      v_bd_error     := (substr('error ' || to_char(sqlcode) || ': ' ||
                                sqlerrm,
                                1,
                                255));
      p_resultnumber := seg_retornar_cadena_error(-1, v_bd_error, sqlcode);
      return;
  end;

  -- **************************************************************************************************
  -- Program:     Usuarios_Permiso
  -- Description: Para traer el permiso de un usuario
  -- **************************************************************************************************

  procedure Usuarios_Permiso(p_id_permiso   in number,
                             p_io_cursor    in out t_cursor,
                             p_resultnumber out varchar2)

   is
    e_invalidpermiso exception;
    v_bd_error varchar(1000);
    c_cursor   t_cursor;

  begin
    if not suirplus.seg_permisos_pkg.isExistePermiso(p_id_permiso) then
      raise e_invalidpermiso;
    end if;

    open c_cursor for
      select usu.id_usuario,
             usu.nombre_usuario || ' ' || usu.apellidos nombre
        from suirplus.seg_usuario_t usu, suirplus.seg_usuario_permisos_t per
       where usu.id_usuario = per.id_usuario
         and per.id_permiso = p_id_permiso
       order by upper(usu.nombre_usuario || ' ' || usu.apellidos);

    p_io_cursor := c_cursor;

  exception

    when e_invalidpermiso then
      p_resultnumber := seg_retornar_cadena_error(5, null, null);

    when others then
      v_bd_error     := (substr('error ' || to_char(sqlcode) || ': ' ||
                                sqlerrm,
                                1,
                                255));
      p_resultnumber := seg_retornar_cadena_error(-1, v_bd_error, sqlcode);
      return;

  end;

  -- **************************************************************************************************
  -- Program:     Usuarios_Role
  -- Description: Para traer los usuarios que tiene un rol
  -- **************************************************************************************************

  procedure Usuarios_Role(p_id_role      in number,
                          p_io_cursor    in out t_cursor,
                          p_resultnumber out varchar2)

   is
    e_invalidrole exception;
    v_bd_error varchar(1000);
    c_cursor   t_cursor;

  begin
    if not suirplus.seg_roles_pkg.isExisteRole(p_id_role) then
      raise e_invalidrole;
    end if;

    open c_cursor for
      select usu.id_usuario,
             usu.nombre_usuario || ' ' || usu.apellidos nombre
        from suirplus.seg_usuario_t usu, suirplus.seg_usuario_permisos_t r
       where usu.id_usuario = r.id_usuario
         and r.id_role = p_id_role
       order by upper(usu.nombre_usuario || ' ' || usu.apellidos);

    p_io_cursor := c_cursor;

  exception

    when e_invalidrole then
      p_resultnumber := seg_retornar_cadena_error(5, null, null);

    when others then
      v_bd_error     := (substr('error ' || to_char(sqlcode) || ': ' ||
                                sqlerrm,
                                1,
                                255));
      p_resultnumber := seg_retornar_cadena_error(-1, v_bd_error, sqlcode);
      return;

  end;

  -- **************************************************************************************************
  -- Program:     function usuarioexiste
  -- Description: funcion que retorna la existencia de un usuario y que el mismo
  --              se encuentre activo en el registro.
  -- modificado por: CMHA  30/11/2016
  -- descripcion : se coloco a la variables pidusuario la longitud maxima del campo de la tabla seg_usuarios_t
  -- **************************************************************************************************

  function isExisteUsuario(p_idusuario varchar2) return boolean

   is
     cursor existe_usuario is
      select t.id_usuario
        from suirplus.seg_usuario_t t
       where t.id_usuario = upper(p_idusuario);

    returnvalue boolean;
    pidusuario  suirplus.seg_usuario_t.id_usuario%type;

  begin
    open existe_usuario;
    fetch existe_usuario
      into pidusuario;
    returnvalue := existe_usuario%found;
    close existe_usuario;

    return(returnvalue);

  end isexisteusuario;

  -- **************************************************************************************************
  -- Program:     function isExisteRepresentante
  -- Description: funcion que retorna la existencia de un representante y que el mismo
  --              se encuentre activo en el registro.
  -- modificado por: CMHA  30/11/2016 
  -- descripcion : se coloco a la variables pidusuario la longitud maxima del campo de la tabla seg_usuarios_t
  -- **************************************************************************************************

  function isExisteRepresentante(p_id_usuario varchar2) return boolean is

    cursor existe_representante is
      select t.id_usuario
        from suirplus.seg_usuario_t t
       where t.id_usuario = p_id_usuario
         and t.id_tipo_usuario = 2
         and t.status = 'A';

    returnvalue   boolean;
    prepresentate suirplus.seg_usuario_t.id_usuario%type;

  begin
    open existe_representante;
    fetch existe_representante
      into prepresentate;
    returnvalue := existe_representante%found;
    close existe_representante;

    return(returnvalue);

  end isexisterepresentante;

  -- **************************************************************************************************
  -- Program:     function isExisteEntRecaudadora
  -- Description: funcion que retorna la existencia de una entidad recaudadora.
  -- **************************************************************************************************

  function isExisteEntRecaudadora(p_id_entidad_recaudadora varchar2)
    return boolean is

    returnvalue boolean;

  begin
    ReturnValue := False;

    For c_cursor in (Select e.id_entidad_recaudadora
                       From suirplus.sfc_entidad_recaudadora_t e
                      Where e.id_entidad_recaudadora =
                            p_id_entidad_recaudadora) Loop
      ReturnValue := True;
    End Loop;

    Return(returnvalue);

  end isExisteEntRecaudadora;

  function getNombreUsuario(p_id_usuario suirplus.sre_archivos_t.usuario_carga%type)
    return varchar is

    v_nombre varchar(100);

  begin
    select trim(u.nombre_usuario || ' ' || u.apellidos) Nombre_Usuario
      into v_nombre
      from suirplus.seg_usuario_t u
     where u.id_usuario = trim(p_id_usuario);

    if v_nombre is null then
      if (length(trim(p_id_usuario)) = 20 or
         length(trim(p_id_usuario)) = 22) then
        select c.nombres || ' ' || c.primer_apellido || ' ' ||
               c.segundo_apellido Nombre_Usuario
          into v_nombre
          from suirplus.sre_ciudadanos_t c
         where c.tipo_documento = 'C'
           and c.no_documento = substr(trim(p_id_usuario), -11, 11);
      else
        v_nombre := null;
      end if;
    end if;

    return initcap(v_nombre);

  end getNombreUsuario;

  -- **************************************************************************************************
  -- Program:     getMenuItems
  -- Description: Trae los permisos que tiene un usuario en el suirplus
  -- Autor: Roberto Jaquez
  -- Fecha: Julio 6, 2007.
  -- **************************************************************************************************
  procedure getMenuItems(p_id_usuario   in varchar2,
                         p_cursor1      in out t_cursor,
                         p_cursor2      in out t_cursor,
                         p_resultnumber out varchar2) is
    v_bderror varchar(1000);
  begin
    open p_cursor1 for
      Select distinct seccion_des Seccion, id_seccion id
        from (select s.seccion_des, s.id_seccion
                from suirplus.seg_usuario_permisos_t up,
                     suirplus.seg_permiso_t          p,
                     suirplus.seg_seccion_t          s
               where up.id_usuario = p_id_usuario
                 and up.id_permiso = p.id_permiso
                 and p.id_seccion = s.id_seccion
                 and p.status = 'A'
              union all
              select s.seccion_des, s.id_seccion
                from suirplus.seg_usuario_permisos_t  usu,
                     suirplus.seg_roles_t             rl,
                     suirplus.seg_rel_permiso_roles_t pr,
                     suirplus.seg_permiso_t           p,
                     suirplus.seg_seccion_t           s
               where usu.id_usuario = p_id_usuario
                 and usu.id_role = rl.id_role
                 and rl.id_role = pr.id_role
                 and pr.id_permiso = p.id_permiso
                 and p.id_seccion = s.id_seccion
                 and rl.status = 'A')
       order by seccion_des;

    open p_cursor2 for
      Select distinct id_permiso            IDPermiso,
                      id_seccion            IDSeccion,
                      permiso_des           Permiso,
                      direccion_electronica URL,
                      orden_menu
        from (select p.id_permiso,
                     p.id_seccion,
                     p.permiso_des,
                     p.direccion_electronica,
                     p.orden_menu
                from suirplus.seg_usuario_permisos_t up, suirplus.seg_permiso_t p
               where up.id_usuario = p_id_usuario
                 and up.id_permiso = p.id_permiso
                 and p.tipo_permiso = 'M'
                 and p.status = 'A'
              union all
              select p.id_permiso,
                     p.id_seccion,
                     p.permiso_des,
                     p.direccion_electronica,
                     p.orden_menu
                from suirplus.seg_usuario_permisos_t  usu,
                     suirplus.seg_roles_t             rl,
                     suirplus.seg_rel_permiso_roles_t pr,
                     suirplus.seg_permiso_t           p
               where usu.id_usuario = p_id_usuario
                 and usu.id_role = rl.id_role
                 and rl.id_role = pr.id_role
                 and pr.id_permiso = p.id_permiso
                 and p.tipo_permiso = 'M'
                 and rl.status = 'A'
                 and p.status = 'A')
       order by id_seccion, orden_menu, permiso_des;

    p_resultnumber := '0';
    return;
  exception
    when others then
      v_bderror      := (substr('error ' || to_char(sqlcode) || ': ' ||
                                sqlerrm,
                                1,
                                255));
      p_resultnumber := seg_retornar_cadena_error(-1, v_bderror, sqlcode);
      return;
  end;

  procedure isUsuarioAutorizado(p_id_usuario   suirplus.seg_usuario_t.id_usuario%type,
                                p_url          suirplus.seg_permiso_t.direccion_electronica%type,
                                p_resultnumber out varchar2) is
    m_url varchar2(32000);
  begin
    if upper(p_url) like '%.ASPX%' then
      m_url := substr(p_url, 1, instr(upper(p_url), '.ASPX') + 4);
    else
      m_url := p_url;
    end if;



    Select sum(Cantidad)
      into p_resultnumber
      from (Select COUNT(*) Cantidad
              from suirplus.seg_usuario_permisos_t up, suirplus.seg_permiso_t p
             where up.id_usuario = upper(p_id_usuario)
               and up.id_permiso = p.id_permiso
               and p.status = 'A'
               and upper(p.direccion_electronica) like upper(m_url) || '%'
            union all
            Select count(*) Cantidad
              from suirplus.seg_usuario_permisos_t  usu,
                   suirplus.seg_roles_t             rl,
                   suirplus.seg_rel_permiso_roles_t pr,
                   suirplus.seg_permiso_t           p
             where usu.id_usuario = upper(p_id_usuario)
               and usu.id_role = rl.id_role
               and rl.id_role = pr.id_role
               and pr.id_permiso = p.id_permiso
               and rl.status = 'A'
               and upper(p.direccion_electronica) like upper(m_url) || '%');

    if nvl(p_resultnumber,0) = 0 then
       Insert into dev(texto, fecha) values(p_id_usuario || ' - ' || m_url, sysdate);
       commit;
    end if;

           return;

  end;

  procedure isInPermiso(p_id_usuario   suirplus.seg_usuario_t.id_usuario%type,
                        p_permiso      suirplus.seg_permiso_t.id_permiso%type,
                        p_resultnumber out varchar2) is

  begin

    Select sum(Cantidad)
      into p_resultnumber
      from (Select COUNT(*) Cantidad
              from suirplus.seg_usuario_permisos_t up, suirplus.seg_permiso_t p
             where up.id_usuario = upper(p_id_usuario)
               and up.id_permiso = p.id_permiso
               and p.status = 'A'
               and p.id_permiso = p_permiso
            union all
            Select count(*) Cantidad
              from suirplus.seg_usuario_permisos_t  usu,
                   suirplus.seg_roles_t             rl,
                   suirplus.seg_rel_permiso_roles_t pr,
                   suirplus.seg_permiso_t           p
             where usu.id_usuario = upper(p_id_usuario)
               and usu.id_role = rl.id_role
               and rl.id_role = pr.id_role
               and pr.id_permiso = p.id_permiso
               and rl.status = 'A'
               and p.id_permiso = p_permiso)

           return;

  end;

  procedure isInRole(p_id_usuario   suirplus.seg_usuario_t.id_usuario%type,
                     p_id_role      in number,
                     p_resultnumber out varchar2) is

  begin
    select count(*)
      into p_resultnumber
      from suirplus.seg_usuario_permisos_t usu
     where usu.id_usuario = UPPER(p_id_usuario)
       and usu.id_role = p_id_role;
    return;
  end;

  ---**************************************************************************************--
  --CMHA
  --14/6/2012
  --Recuperar Class
  ---**************************************************************************************--
  PROCEDURE RecuperarClass(p_idusuario    in suirplus.seg_usuario_t.id_usuario%type,
                           p_email        in suirplus.seg_usuario_t.email%type,
                           p_link_params   in varchar2,
                           p_accion       in varchar2,
                           p_resultnumber OUT varchar2) IS

    v_usuario              varchar2(35);
    v_tipo_user            number;
    v_email                varchar2(200);
    v_param_usuario        varchar2(200);
    v_param_email          varchar2(200);
    v_params_link          varchar2(4000);
    v_params_link_decrypt  varchar2(4000);
    v_ClassTemporal        varchar2(200);
    v_TokenGenerado        varchar2(6);
    v_TokenUsuario         varchar2(6);
    v_status               varchar2(1);
    v_FechaCreacionToken   date;
    v_expiracionToken      number;
    v_id                   number;
    e_status_invalido      exception;


    html varchar2(32000);
  BEGIN

      IF ((p_idusuario is null) or (p_email is null) or (p_accion is null)) and (p_accion='R') THEN
          P_Resultnumber := '-1'||'|'||'Todos los parametros son requerido.';
          return;
      end if;

      IF (p_accion = 'C') THEN
      --desencriptamos el usuario , el email y el token
      v_params_link_decrypt:= SEG_ENCRYPTION_PKG.decrypt(p_link_params);
        v_param_usuario := suirplus.split_string(v_params_link_decrypt,'|',1);
        v_param_email   := suirplus.split_string(v_params_link_decrypt,'|',2);
        v_TokenGenerado := suirplus.split_string(v_params_link_decrypt,'|',3);
      else
        v_param_usuario := p_idusuario;
        v_param_email   := p_email;
        v_params_link   := p_link_params;
      end if;

      begin
        --verificamos que el usuario exista
        select u.id_usuario, u.email, u.id_tipo_usuario
          into v_usuario, v_email, v_tipo_user
          from suirplus.seg_usuario_t u
         where u.status in ('A','B')
           and upper(u.id_usuario) = upper(v_param_usuario)
           and upper(u.email) = upper(v_param_email);
      exception
        when no_data_found then
          p_resultnumber := seg_retornar_cadena_error(430, null, null);
          return;
      end;

 if (p_accion = 'R') THEN
      --generamos un token de seguridad
         select DBMS_RANDOM.string('X', 6)into v_TokenGenerado from dual;
      --Encriptamos el idusuario, el email y el token generado
      v_params_link   := SEG_ENCRYPTION_PKG.Encrypt(v_usuario||'|'||v_email||'|'||v_TokenGenerado);
      --Enviamos el correo de confirmacion del Email al usuario
      html := '<html><body>';
      html := html || 'Estimado(a) Sr(a):<br>';
      html := html || '<br>';
      html := html ||
              'Hemos recibido una solicitud para recuperar su class para el SuirPlus,  ';
      html := html || 'para confirmar dicha solicitud y proceder ,';
      html := html ||
              ' por favor, haga click en el link que se muestra mas abajo, ';
      html := html ||
              'si no le es posible hacer click sobre el link, copielo, peguelo en la barra de direcciones de su navegador y presione enter.';
      html := html || '<br>';

      html := html ||
              '<a href="http://www.tss2.gov.do/sys/ConfirmRecuperarClass.aspx?params=' ||
              v_params_link ||
              '">http://www.tss2.gov.do/sys/ConfirmRecuperarClass.aspx?params=' ||
              v_params_link || '</a>';

      html := html || '<br>';
      html := html || '<br>';
      html := html || '<br>';
      html := html || '</body></html>';

      --insertamos un token de seguridad en la tabla seg_usuario_t
      update suirplus.seg_usuario_t u
      set u.token= v_TokenGenerado,
          u.fecha_creacion_token= sysdate
      where u.id_usuario = v_usuario;
      commit;

      SYSTEM.Html_Mail(p_sender    => 'info@mail.tss2.gov.do',
                       p_recipient => v_email,
                       p_subject   => 'Confirmacion Recuperacion Class TSS',
                       p_message   => html);

      P_Resultnumber := 0||'|'||'Correo Enviado'||'|'||v_tipo_user;

    ELSIF (p_accion = 'C') THEN
    --validamos el token generado
      begin
         select u.token,u.fecha_creacion_token, u.status 
          into v_TokenUsuario,v_FechaCreacionToken, v_status
           from suirplus.seg_usuario_t u
          where u.id_usuario = v_usuario;
         
          if v_status = 'I' then
            raise e_status_invalido;
          end if;

        select p.valor_numerico into v_expiracionToken
        from suirplus.sfc_det_parametro_t p
        where p.id_parametro = 368;

        if (upper(v_TokenUsuario) = upper(v_TokenGenerado))then
          if ABS(round(((v_FechaCreacionToken-sysdate) * 24),1)) < v_expiracionToken then
              ReseteoClass(v_usuario, v_ClassTemporal, P_Resultnumber);
              -- Actualizamos la cantidad de intentos y el status
              update suirplus.seg_usuario_t u
                 set u.cantidad_intentos = 0,
                     u.status = 'A'
              where u.id_usuario = v_usuario; 
              
              commit;
              P_Resultnumber := 0||'|'||v_ClassTemporal||'|'||v_tipo_user;
            else
              P_Resultnumber := '-1'||'|'||'La seccion de recuperacion de su class ha expirado luego de '||v_expiracionToken||'hrs de espera, favor iniciar el proceso de recuperacion de class nuevamente.';
          end if;
        else
           P_Resultnumber := '-1'||'|'||'Los datos suministrados son incorrectos, favor iniciar el proceso de recuperacion de class nuevamente.';
        end if;
      exception
        when e_status_invalido then
           p_resultnumber := seg_retornar_cadena_error(430, null, null);
        when no_data_found then
           P_Resultnumber := '-1'||'|'||'Los datos suministrados son incorrectos, favor iniciar el proceso de recuperacion de class nuevamente.';
          return;
      end;
    END IF;

  EXCEPTION
    when others then
      P_Resultnumber := seg_retornar_cadena_error(-1, null, null);
      return;
  END;

  ---**************************************************************************************--
  --by: Kerlin de la cruz
  --12/01/2017
  --Desbloquear usuario
  ---**************************************************************************************--
  PROCEDURE DesbloquearUsuario(p_idusuario    in suirplus.seg_usuario_t.id_usuario%type,
                               p_status       in suirplus.seg_usuario_t.status%type,                             
                               p_accion       in varchar2,
                               p_resultnumber OUT varchar2) IS

    v_usuario              varchar2(35);
    v_email                varchar2(200);
    v_param_usuario        varchar2(200);
    v_param_status          varchar2(200);
    v_params_link          varchar2(4000);
    v_params_link_decrypt  varchar2(4000);
    v_ClassTemporal        varchar2(200);
    v_TokenGenerado        varchar2(6);
    v_TokenUsuario         varchar2(6);
    v_FechaCreacionToken   date;
    v_expiracionToken      number;
    v_id                   number;
    v_bd_error             varchar2(500);


    html varchar2(32000);
  BEGIN

      IF ((p_idusuario is null) or (p_status is null) or (p_accion is null)) and (p_accion='B') THEN
          P_Resultnumber := '-1'||'|'||'Todos los parametros son requerido.';
          return;
      end if;

      IF (p_accion = 'C') THEN
      --desencriptamos el usuario , el email y el token
      --v_params_link_decrypt:= SEG_ENCRYPTION_PKG.decrypt(p_link_params);
        v_param_usuario := suirplus.split_string(v_params_link_decrypt,'|',1);
        v_param_status   := suirplus.split_string(v_params_link_decrypt,'|',2);
        v_TokenGenerado := suirplus.split_string(v_params_link_decrypt,'|',3);
      else
        v_param_usuario := p_idusuario;
        v_param_status   := p_status;        
      end if;

      begin
        --verificamos que el usuario exista
        select u.id_usuario, u.email
          into v_usuario, v_email
          from suirplus.seg_usuario_t u
         where u.status = 'B'
           and upper(u.id_usuario) = upper(v_param_usuario);           
      exception
        when no_data_found then
          P_Resultnumber := seg_retornar_cadena_error('US001', null, null);
          return;
      end;

 if (p_accion = 'B') THEN
      --generamos un token de seguridad
         select DBMS_RANDOM.string('X', 6)into v_TokenGenerado from dual;
      --Encriptamos el idusuario, el email y el token generado
      v_params_link   := SEG_ENCRYPTION_PKG.Encrypt(v_usuario||'|'||v_email||'|'||v_TokenGenerado);
      --Enviamos el correo de confirmacion del Email al usuario
      html := '<html><body>';
      html := html || 'Estimado(a) Sr(a):<br>';
      html := html || '<br>';
      html := html ||
              'Hemos recibido una solicitud para desbloquear su usuario para el SuirPlus,  ';
      html := html || 'para confirmar dicha solicitud y proceder ,';
      html := html ||
              ' por favor, haga click en el link que se muestra mas abajo, ';
      html := html ||
              'si no le es posible hacer click sobre el link, copielo, peguelo en la barra de direcciones de su navegador y presione enter.';
      html := html || '<br>';

      html := html ||
              '<a href="http://www.tss2.gov.do/sys/ConfirmDesbloquearUR.aspx?params=' ||
              v_params_link ||
              '">http://www.tss2.gov.do/sys/ConfirmDesbloquearUR.aspx?params=' ||
              v_params_link || '</a>';

      html := html || '<br>';
      html := html || '<br>';
      html := html || '<br>';
      html := html || '</body></html>';

      --insertamos un token de seguridad en la tabla seg_usuario_t
      update suirplus.seg_usuario_t u
      set u.token= v_TokenGenerado,
          u.fecha_creacion_token= sysdate,
          u.cantidad_intentos = 0          
      where u.id_usuario = v_usuario;
      commit;

      SYSTEM.Html_Mail(p_sender    => 'info@mail.tss2.gov.do',
                       p_recipient => v_email,
                       p_subject   => 'Confirmacion Desbloqueo de Usuario',
                       p_message   => html);

      P_Resultnumber := 0||'|'||'Correo Enviado';

    ELSIF (p_accion = 'C') THEN
    --validamos el token generado
      begin
        select u.token,u.fecha_creacion_token into v_TokenUsuario,v_FechaCreacionToken
        from suirplus.seg_usuario_t u
        where u.id_usuario = v_usuario;

        select p.valor_numerico into v_expiracionToken
        from suirplus.sfc_det_parametro_t p
        where p.id_parametro = 368;

        if (upper(v_TokenUsuario) = upper(v_TokenGenerado))then
          if ABS(round(((v_FechaCreacionToken-sysdate) * 24),1)) < v_expiracionToken then
              ReseteoClass(v_usuario, v_ClassTemporal, P_Resultnumber);
              commit;
              P_Resultnumber := 0||'|'||v_ClassTemporal;
            else
              P_Resultnumber := '-1'||'|'||'La seccion de desbloqueo de usuario ha expirado luego de '||v_expiracionToken||'hrs de espera, favor iniciar el proceso de desbloqueo de usuario nuevamente';
          end if;
        else
           P_Resultnumber := '-1'||'|'||'Los datos suministrados son incorrectos, favor iniciar el proceso de desbloqueo de usuario nuevamente.';
        end if;
      exception
        when no_data_found then
          P_Resultnumber := '-1'||'|'||'Los datos suministrados son incorrectos, favor iniciar el proceso de desbloqueo de usuario nuevamente.';
          return;
      end;
    END IF;

  EXCEPTION
    when others then
     v_bd_error     := (substr('error ' || to_char(sqlcode) || ': ' ||
                                sqlerrm,
                                1,
                                255));
      p_resultnumber := seg_retornar_cadena_error(-1, v_bd_error, sqlcode);
      return;
  END;
  
  
  -- **************************************************************************************************
  -- Procedure: Actualizar_Usuario
  -- Description: Actualiza el status del usuario a peticion (B=bloqueado A=activo, I=inactivo)
  -- by: Kerlin De La Cruz
  -- fecha: 11/01/2017
  -- **************************************************************************************************
  
Procedure Actualizar_Usuario(p_usuario in suirplus.seg_usuario_t.id_usuario%type,
							               p_status in suirplus.seg_usuario_t.status%type,
                             p_link_params   in varchar2,                             
                             p_resultnumber OUT varchar2) is
                             
    v_usuario              varchar2(35);
    v_email                varchar2(200);
    v_param_usuario        varchar2(200);
    v_param_status          varchar2(200);
    v_params_link          varchar2(4000);
    v_params_link_decrypt  varchar2(4000);
    v_ClassTemporal        varchar2(200);
    v_TokenGenerado        varchar2(6);
    v_TokenUsuario         varchar2(6);
    v_FechaCreacionToken   date;
    v_expiracionToken      number;
    v_id                   number;
    v_bd_error             varchar2(500);
    v_tipo_user            number;
    v_status               varchar2(1);
    e_status_invalido      exception;
                             
Begin
   IF (p_usuario is null) THEN
      --desencriptamos el usuario , el email y el token
        v_params_link_decrypt:= SEG_ENCRYPTION_PKG.decrypt(p_link_params);
        v_param_usuario := suirplus.split_string(v_params_link_decrypt,'|',1);
        v_param_status   := suirplus.split_string(v_params_link_decrypt,'|',2);
        v_TokenGenerado := suirplus.split_string(v_params_link_decrypt,'|',3);
      else
        v_param_usuario := p_usuario;
        v_param_status   := p_status;        
      end if;

 select u.id_tipo_usuario, u.status
 into v_tipo_user, v_status
 from suirplus.seg_usuario_t u
 where u.id_usuario = v_param_usuario;
 
 if v_status = 'I' then 
   raise e_status_invalido;
 end if;

 if (p_status = 'A') then
  Update suirplus.seg_usuario_t u
     set u.status = p_status,
         u.ult_fecha_act = sysdate, 
         u.ult_usuario_act = upper(v_param_usuario)     
   where u.id_usuario = upper(v_param_usuario);
   else
     Update suirplus.seg_usuario_t u
     set u.status = p_status,
         u.ult_fecha_act = sysdate, 
         u.ult_usuario_act = upper(p_usuario)     
   where u.id_usuario = upper(p_usuario);
       
  end if;
     
  commit; 
   p_resultnumber := 'OK'||'|'||v_tipo_user;   
   
 EXCEPTION
 when e_status_invalido then
      p_resultnumber := seg_retornar_cadena_error(430, null, null);
 when others then
       v_bd_error     := (substr('error ' || to_char(sqlcode) || ': ' || sqlerrm,1, 255));
       p_resultnumber := seg_retornar_cadena_error(-1, v_bd_error, sqlcode);
       return;
End;

-- *********************************************************************************************************************
-- Program:     procedure UsuarioWebServicesAutorizado
-- Description: procedure que retorno un valor S/N si el usuario tiene permiso para ejecutar el webservice
-- modificado por: Eury Vallejo
-- *********************************************************************************************************************
procedure UsuarioWebServicesAutorizado(p_id_usuario in suirplus.seg_usuario_t.id_usuario%type,
                                      p_permiso_des in suirplus.seg_permiso_t.permiso_des%type,
                                      p_resultnumber OUT varchar2) is

v_count number;
 v_bd_error             varchar2(500);
BEGIN
  
select count(*)
into v_count
from suirplus.seg_usuario_t s 
join suirplus.seg_usuario_permisos_t p
on s.id_usuario = p.id_usuario
join suirplus.seg_permiso_t pe
on pe.id_permiso = p.id_permiso
where upper(s.id_usuario) = upper(p_id_usuario) 
      and lower(pe.direccion_electronica) = lower(p_permiso_des)
      and pe.tipo_permiso = 'O';
      
if v_count > 0 then
  p_resultnumber:= 'S';
else
  p_resultnumber:= 'N';  
end if;      

EXCEPTION
   when others then
     v_bd_error     := (substr('error ' || to_char(sqlcode) || ': ' ||
                                sqlerrm,
                                1,
                                255));
      p_resultnumber := seg_retornar_cadena_error(-1, v_bd_error, sqlcode);
      return;
end UsuarioWebServicesAutorizado;

end Seg_Usuarios_Pkg;
