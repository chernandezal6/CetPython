create or replace package body suirplus.seg_permisos_pkg is
-- **************************************************************************************************
-- Program:     seg_permisos_pkg
-- Description: Paquete para manejar los permisos
--
-- Modification History
-- --------------------------------------------------------------------------------------------------
-- Fecha        por     Comentario
-- --------------------------------------------------------------------------------------------------
--
-- **************************************************************************************************

-- **************************************************************************************************
-- Program:     get_permisos_sin_usuario
-- Description: Trae permisos para los Usuarios que no tienen
-- **************************************************************************************************

    procedure get_permisos_sin_usuario(
        p_IdUsuario         in seg_usuario_t.id_usuario%type,
        p_IOCursor          in out t_Cursor,
        p_ResultNumber      out varchar2)
    is
        e_invaliduser       exception;
        v_bdError           varchar(1000);
        c_cursor t_cursor;

    begin

        if not seg_usuarios_pkg.isExisteUsuario(p_IdUsuario) then

            raise e_invaliduser;
        end if;

        open c_cursor for
            select p.id_permiso, p.permiso_des, p.direccion_electronica, sc.seccion_des
            from seg_permiso_t p, seg_seccion_t sc
            where not exists
                (
                Select 1 from seg_usuario_permisos_t t
                where t.id_usuario = p_IdUsuario
                and t.id_permiso = p.id_permiso
                )
            and p.id_seccion = sc.id_seccion
            order by sc.seccion_des,p.orden_menu,p.permiso_des;

        p_resultnumber := 0;
        p_IOCursor := c_cursor;

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
-- Program:     get_permisos_sin_role
-- Description: Trae permisos para un rol que no tiene
-- **************************************************************************************************

    procedure get_permisos_sin_role(
        p_IDRole          in seg_roles_t.id_role%type,
        p_IOCursor        in out t_Cursor,
        p_resultnumber    out varchar2)
    is
        e_invalidrole     exception;
        v_bderror       varchar(1000);
        c_cursor t_cursor;

    begin

        if not seg_roles_pkg.isExisteRole(p_IDRole) then
            raise e_invalidrole;
        end if;

        open c_cursor for
            select p.id_permiso, p.permiso_des, p.direccion_electronica, sc.seccion_des
            from seg_permiso_t p, seg_seccion_t sc
            where not exists
                (
                Select 1 from seg_rel_permiso_roles_t t
                where id_role = p_IDRole
                and t.id_permiso = p.id_permiso
                )
            and p.id_seccion = sc.id_seccion
            order by sc.seccion_des,p.orden_menu,p.permiso_des;
            
            

        p_resultnumber := 0;
        p_IOCursor := c_cursor;

    exception

        when e_invalidrole then
            p_resultnumber := seg_retornar_cadena_error(6, null, null);
            return;

        when others then
            v_bderror := (substr('error '||to_char(sqlcode)||': '||sqlerrm, 1, 255));
            p_resultnumber := seg_retornar_cadena_error(-1, v_bderror, sqlcode);
        return;


    end;

-- **************************************************************************************************
-- Program:     permiso_borrar
-- Description: Para borrar los permisos
-- **************************************************************************************************

    procedure permiso_borrar(
        p_id_permiso        seg_permiso_t.id_permiso%type,
        p_resultnumber    out varchar2)
    as

    e_invalidpermiso          exception;
    e_invaliduser             exception;
    e_existentchildrows       exception;
    v_exisid_permiso          number;

    v_bd_error                varchar(1000);

    cursor existentpermiso  is
        select id_permiso from seg_usuario_permisos_t tp
        where tp.id_permiso = p_id_permiso;

    cursor existentpermiso2 is
        select id_permiso from seg_rel_permiso_roles_t tr
        where tr.id_permiso = p_id_permiso;

    begin

        if not seg_permisos_pkg.isExistePermiso(p_id_permiso) then
           raise e_invalidpermiso;
        end if;


        open existentpermiso;
        open existentpermiso2;

            fetch existentpermiso into v_exisid_permiso;
            fetch existentpermiso2 into v_exisid_permiso;


        if existentpermiso%found or existentpermiso2%found then
           raise e_existentchildrows;
        end if;

        delete seg_permiso_t tr where tr.id_permiso = p_id_permiso;

        p_resultnumber := 0;
        commit;

    exception

        when e_invalidpermiso then
           p_resultnumber := seg_retornar_cadena_error(5, null, null);

        when e_existentchildrows then
           p_resultnumber := seg_retornar_cadena_error(9, null, null);

        when others then
           v_bd_error := (substr('error '||to_char(sqlcode)||': '||sqlerrm, 1, 255));
           p_resultnumber := seg_retornar_cadena_error(-1, v_bd_error, sqlcode);
        return;
    end;


-- **************************************************************************************************
-- Program:     permiso_crear
-- Description: Para crear los permisos
--modificado por:Eury Vallejo
-- **************************************************************************************************

    procedure permiso_crear(
        p_permiso_des           seg_permiso_t.permiso_des%type,
        p_id_seccion            seg_permiso_t.id_seccion%type,
        p_orden_menu            seg_permiso_t.orden_menu%type,
        p_direccion_electronica seg_permiso_t.direccion_electronica%type,
        p_tipo_permiso          seg_permiso_t.tipo_permiso%type,
        p_marca_cuota           seg_permiso_t.marca_cuota%type,
        p_ult_usuario_act       seg_usuario_t.id_usuario%type,
        p_resultnumber          out varchar2
        )

    is
        e_existentpermisodesc     exception;
        e_nonexistentusuario    exception;
        e_invalidseccion          exception;
        e_longervalue             exception;

        v_bd_error                varchar(1000);

    begin
        if seg_get_largo_columna('SEG_PERMISO_T', 'PERMISO_DES') < length(p_permiso_des) then
           raise e_longervalue;
        end if;

        if seg_permisos_pkg.isExisteDescPermiso(p_permiso_des, p_id_seccion ) then
           raise e_existentpermisodesc;
        end if;

        if not seg_usuarios_pkg.isExisteUsuario(p_ult_usuario_act) then
           raise e_nonexistentusuario;
        end if;

        if not seg_seccion_pkg.isExisteSeccion(p_id_seccion) then
           raise e_invalidseccion;
        end if;

        insert into seg_permiso_t
            (id_permiso, permiso_des, direccion_electronica, ult_usuario_act,
             tipo_permiso, id_seccion, orden_menu, ult_fecha_act,marca_cuota)
        values
            (seq_permiso.nextval, p_permiso_des, p_direccion_electronica,
             p_ult_usuario_act, p_tipo_permiso, p_id_seccion,p_orden_menu, sysdate,p_marca_cuota);

        Commit;
        p_resultnumber := 0;

    exception

        when e_existentpermisodesc then
           p_resultnumber := seg_retornar_cadena_error(4, null,null);
        when e_nonexistentusuario then
           p_resultnumber := seg_retornar_cadena_error(1, null, null);
        when e_invalidseccion then
             p_resultnumber := seg_retornar_cadena_error(17, null, null);
        when e_longervalue then
             p_resultnumber := seg_retornar_cadena_error(18, null, null);
        when others then

           v_bd_error := (substr('error '||to_char(sqlcode)||': '||sqlerrm, 1, 255));
           p_resultnumber := seg_retornar_cadena_error(-1, v_bd_error, sqlcode);
        return;
    end;

-- **************************************************************************************************
-- Program:     permiso_editar
-- Description: Para editar los permisos
--modificado por:Eury Vallejo
-- **************************************************************************************************

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
        p_resultnumber    out varchar2)

    is

        e_invalidpermiso  exception;
        e_invaliduser   exception;
        e_invalidseccion    exception;
        e_longervalue       exception;

        v_bd_error      varchar(1000);


    begin
        if not seg_permisos_pkg.isExistePermiso(p_id_permiso) then
           raise e_invalidpermiso;
           end if;

        if not seg_usuarios_pkg.isExisteUsuario(p_ult_usuario_act) then
           raise e_invaliduser;
           end if;

        if not seg_seccion_pkg.isExisteSeccion(p_id_seccion) then
           raise e_invalidseccion;
           end if;

        if seg_get_largo_columna('SEG_PERMISO_T', 'PERMISO_DES') < length(p_permiso_des) then
           raise e_longervalue;
        end if;

    update seg_permiso_t tr
         set  tr.permiso_des = p_permiso_des,
              tr.direccion_electronica = p_direccion_elec,
              tr.ult_usuario_act = p_ult_usuario_act,
              tr.id_seccion = p_id_seccion,
              tr.orden_menu = p_orden_menu,
              tr.ult_fecha_act = sysdate,
              tr.status = p_estatus,
              tr.tipo_permiso = p_tipo_permiso,
              tr.marca_cuota = p_marca_cuota

         where tr.id_permiso = p_id_permiso;
         p_resultnumber :=0;
         commit;

    exception

        when e_invalidpermiso then
           p_resultnumber := seg_retornar_cadena_error(5, null, null);

        when e_invaliduser then
           p_resultnumber := seg_retornar_cadena_error(1, null, null);

        when e_invalidseccion then
             p_resultnumber := seg_retornar_cadena_error(17, null, null);

        when e_longervalue then
             p_resultnumber := seg_retornar_cadena_error(18, null, null) ;

        when others then
           v_bd_error := (substr('error '||to_char(sqlcode)||': '||sqlerrm, 1, 255));
           p_resultnumber := seg_retornar_cadena_error(-1, v_bd_error, sqlcode);
        return;
    end;

-- **************************************************************************************************
-- Program:     get_permisos
-- Description: Para traer los permisos
-- **************************************************************************************************

    procedure get_permisos(
        p_id_permiso      in number,
        p_iocursor       in out t_cursor,
        p_resultnumber    out varchar2)

    is
        e_invalidpermiso    exception;
        v_bd_error        varchar(1000);
        c_cursor t_cursor;

    begin

        if p_id_permiso is not null then
           if not seg_permisos_pkg.isExistePermiso(p_id_permiso) then
           raise e_invalidpermiso;
           end if;

            open c_cursor for
                select p.id_permiso, p.id_seccion,p.permiso_des, p.direccion_electronica,
                    p.tipo_permiso, p.ult_usuario_act, p.ult_fecha_act, p.status,p.orden_menu,p.marca_cuota
                from seg_permiso_t p
                where id_permiso = p_id_permiso;

        else
            open c_cursor for
                select p.id_permiso, p.id_seccion, p.permiso_des, p.direccion_electronica,
                    p.tipo_permiso, p.ult_usuario_act, p.ult_fecha_act, s.seccion_des, p.status,p.orden_menu,p.marca_cuota
                from seg_permiso_t p, seg_seccion_t s
                where p.id_seccion = s.id_seccion
                order by seccion_des, orden_menu, permiso_des;
        end if;

        p_resultnumber := 0;
        p_iocursor := c_cursor;

    exception

        when e_invalidpermiso then
           p_resultnumber := seg_retornar_cadena_error(5, null, null);
        return;

        when others then
           v_bd_error := (substr('error '||to_char(sqlcode)||': '||sqlerrm, 1, 255));
           p_resultnumber := seg_retornar_cadena_error(-1, v_bd_error, sqlcode);
        return;
    end;

-- **************************************************************************************************
-- Program:     permisos_role
-- Description: Para traer los permisos de los roles
-- **************************************************************************************************

    procedure permisos_role(
        p_id_role         in number,
        p_iocursor       in out t_cursor,
        p_resultnumber    out varchar2)
    is
        e_invalidrole     exception;
        v_bderror       varchar(1000);
        c_cursor t_cursor;

    begin

        if not seg_roles_pkg.isExisteRole(p_id_role) then
            raise e_invalidrole;
        end if;

        open c_cursor for
            select p.id_permiso, p.id_seccion, p.permiso_des, p.direccion_electronica, p.tipo_permiso,
                p.ult_usuario_act, p.ult_fecha_act, secc.seccion_des
            from seg_permiso_t p, seg_rel_permiso_roles_t rolper, seg_seccion_t secc
            where p.id_permiso = rolper.id_permiso
            and rolper.id_role = p_id_role
            and p.id_seccion = secc.id_seccion;

        p_resultnumber := 0;
        p_iocursor := c_cursor;

    exception

        when e_invalidrole then
            p_resultnumber := seg_retornar_cadena_error(6, null, null);
            return;

        when others then
            v_bderror := (substr('error '||to_char(sqlcode)||': '||sqlerrm, 1, 255));
            p_resultnumber := seg_retornar_cadena_error(-1, v_bderror, sqlcode);
        return;

        end;

-- **************************************************************************************************
-- Program:     permisos_usuarios
-- Description: Para traer los permisos de los usuarios
-- **************************************************************************************************

    procedure permisos_usuario(
        p_id_usuario        in seg_usuario_t.id_usuario%type,
        p_io_cursor         in out t_cursor,
        p_ResultNumber      out varchar2)
    is
        e_invaliduser       exception;
        v_bderror           varchar(1000);
        c_cursor t_cursor;

    begin
        if not seg_usuarios_pkg.isExisteUsuario(p_Id_Usuario) then
            raise e_invaliduser;
        end if;


        open c_cursor for
            select per.id_permiso, per.id_seccion, sc.seccion_des, per.permiso_des,
                per.permiso_des, per.direccion_electronica
            from seg_permiso_t per, seg_usuario_permisos_t usuper, seg_seccion_t sc
            where per.id_permiso  = usuper.id_permiso
            and usuper.id_usuario = p_id_usuario
            and per.id_seccion = sc.id_seccion
            order by sc.seccion_des, per.orden_menu, per.permiso_des;

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
-- Program:     deasignar_permiso
-- Description: Para deasignar los permisos a usuarios
-- **************************************************************************************************

    procedure deasignar_permiso(
        p_id_permiso          seg_permiso_t.id_permiso%type,
        p_id_role             seg_roles_t.id_role%type,
        p_ult_usuario_act       seg_usuario_t.id_usuario%type,
        p_resultnumber          out varchar2)

    is

        e_invalidpermiso        exception;
        e_invalidrole         exception;
        e_invaliduser         exception;
        e_nonexistentrow          exception;
        e_actiontakenexception    exception;

        v_tmpidpermiso            number;
        v_bd_error              varchar(1000);

    cursor existentrow is
        select id_permiso from seg_rel_permiso_roles_t
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

        open existentrow;
            fetch existentrow into v_tmpidpermiso;
            if existentrow%notfound then
                close existentrow;
                raise e_nonexistentrow;
            else
                close existentrow;
            end if;

        delete from seg_rel_permiso_roles_t tr
        where tr.id_role = p_id_role
        and tr.id_permiso = p_id_permiso;

        p_resultnumber := 0;

    exception

        when e_invalidpermiso then
            p_resultnumber := seg_retornar_cadena_error(5, null, null);

        when e_invalidrole then
            p_resultnumber := seg_retornar_cadena_error(6, null, null);

        when e_invaliduser then
            p_resultnumber := seg_retornar_cadena_error(1, null, null);

        when e_nonexistentrow then
            p_resultnumber := seg_retornar_cadena_error(5, null, null);

        when others then
            v_bd_error := (substr('error '||to_char(sqlcode)||': '||sqlerrm, 1, 255));
            p_resultnumber := seg_retornar_cadena_error(-1, v_bd_error, sqlcode);
        return;

    end;

-- **************************************************************************************************
-- Program:     function isExistePermiso()
-- Description: funcion que retorna la existencia de un permiso de seguridad y que el mismo
--              se encuentre activo en el registro.
-- **************************************************************************************************

    function isExistePermiso(p_id_permiso number) return boolean

    is

    cursor existe_permiso is
        select t.id_permiso from seg_permiso_t t
        where t.id_permiso = p_id_permiso;

    returnvalue boolean;
    pidpermiso seg_permiso_t.id_permiso%type;

    begin
        open existe_permiso;
            fetch existe_permiso into pidpermiso;
            returnvalue := existe_permiso%found;
            close existe_permiso;

        return(returnvalue);

    end isExistePermiso;

-- **************************************************************************************************
-- Program:     function isExisteDescPermiso()
-- Description: funcion que retorna la existencia de una descripcion de un permiso y que el mismo
--              se encuentre activo en el registro para una seccion especifica.
-- **************************************************************************************************

    function isExisteDescPermiso(
        p_permiso_des   seg_permiso_t.permiso_des%type,
        p_id_seccion    seg_permiso_t.id_seccion%type) return boolean

    is

    cursor existe_perm is
        select t.permiso_des, t.id_seccion from seg_permiso_t t
        where t.permiso_des = p_permiso_des
        and t.id_seccion =  p_id_seccion;


    returnvalue    boolean;
    ppermisodes    seg_permiso_t.permiso_des%type;
    pidseccion     seg_permiso_t.id_seccion%type;

    begin
        open existe_perm;
            fetch existe_perm into ppermisodes, pidseccion;
            returnvalue := existe_perm%found;
            close existe_perm;

        return(returnvalue);

    end isExisteDescPermiso;
    
    procedure permisos_bancos_dgii is
      hoy date;
      lim date;
      dia number(2);
      res varchar2(250);
      per varchar2(6);
      par Parm;

      mail_to varchar2(500) := 'roberto_jaquez@mail.tss2.gov.do,hector_minaya@mail.tss2.gov.do';
      mensaje varchar2(500);
    begin
      if to_char(add_months(sysdate,-1),'DD')='05' then
        SEH_PENSIONADOS_PKG.generar_cartera();
        SEH_PENSIONADOS_PKG.generar_notificacion_cartera();
        SEH_PENSIONADOS_PKG.generar_notifiacion_carteraSEH();
        SEH_PENSIONADOS_PKG.notifiacion_cartera_SIJUPEN();       
      end if;

      if to_char(add_months(sysdate,-1),'DD')='10' then
        suirplus.seh_pensionados_pkg.generar_dispersion;     
      end if;
   
      --inicalizar parametros
      per := to_char(add_months(sysdate,-1),'YYYYMM');
      par := Parm(per);
      IF per >= par.periodo_inicio_isr THEN
        Srp_Pkg.initialize_isr_parm(par, per);
      END IF;

      hoy := trunc(sysdate);
      dia := to_number(to_char(hoy,'dd'));
      lim := par.fecha_limite_pago_isr;
      mensaje := 'Hoy:'||hoy
               ||'<br>Mes atras:'||add_months(sysdate,-1)
               ||'<br>Periodo:'||per
               ||'<br>Fecha Limite:'||lim;

/*
      if (dia=1) then
        -- si es el primer dia del mes, asignar permisos
        
        -- dejado de otorgar  en 1-feb-2008
        --seg_roles_pkg.otorgar_permiso(
        --  p_id_permiso      => 132,
        --  p_id_role         => 59,
        --  p_ult_usuario_act => 'CDURAN',
        --  p_resultnumber    => res
        --);

        seg_roles_pkg.otorgar_permiso(
          p_id_permiso      => 48,
          p_id_role         => 58,
          p_ult_usuario_act => 'CDURAN',
          p_resultnumber    => res
        );
        seg_roles_pkg.otorgar_permiso(
          p_id_permiso      => 48,
          p_id_role         => 59,
          p_ult_usuario_act => 'CDURAN',
          p_resultnumber    => res
        );
        system.html_mail(
          p_sender    => 'info@mail.tss2.gov.do',
          p_recipient => mail_to,
          p_subject   => 'Ejecucion de seg_permisos_pkg.permisos_bancos_dgii - '||to_char(sysdate,'dd/mm/yyyy'),
          p_message   => mensaje||' RESULTADO: asignar permisos'
        );
      elsif (hoy >= lim + 1) then
        -- si hoy es mayor o igual que fecha limite pago, quitar
        seg_permisos_pkg.deasignar_permiso(
          p_id_permiso      => 132,
          p_id_role         => 59,
          p_ult_usuario_act => 'CDURAN',
          p_resultnumber    => res
        );
        seg_permisos_pkg.deasignar_permiso(
          p_id_permiso      => 48,
          p_id_role         => 58,
          p_ult_usuario_act => 'CDURAN',
          p_resultnumber    => res
        );
        seg_permisos_pkg.deasignar_permiso(
          p_id_permiso      => 48,
          p_id_role         => 59,
          p_ult_usuario_act => 'CDURAN',
          p_resultnumber    => res
        );
        system.html_mail(
          p_sender    => 'info@mail.tss2.gov.do',
          p_recipient => mail_to,
          p_subject   => 'Ejecucion de seg_permisos_pkg.permisos_bancos_dgii - '||to_char(sysdate,'dd/mm/yyyy'),
          p_message   => mensaje||' RESULTADO: revocar permisos'
        );
      else
*/      
        system.html_mail(
          p_sender    => 'info@mail.tss2.gov.do',
          p_recipient => mail_to,
          p_subject   => 'Ejecucion de seg_permisos_pkg.permisos_bancos_dgii - '||to_char(sysdate,'dd/mm/yyyy'),
          p_message   => mensaje||' RESULTADO: ninguna accion'
        );
/*      end if;*/
      commit;
    exception when others then
      system.html_mail('info@mail.tss2.gov.do',mail_to,'Error en permisos_bancos_dgii dia '||sysdate,sqlerrm);
    end;


-- **************************************************************************************************
-- Program:     get_ServicioCuota
-- Description: Para traer la informacion de los Permisos con marcas de cuota
--Autor:Eury Vallejo
-- **************************************************************************************************
   procedure get_ServicioCuota(
        p_iocursor       in out t_cursor,
        p_resultnumber    out varchar2)

    is
        v_bd_error        varchar(1000);
        c_cursor t_cursor;

    begin

    open c_cursor for
    select p.id_permiso, p.permiso_des
    from seg_permiso_t p
    where p.marca_cuota='S';

        p_resultnumber := 0;
        p_iocursor := c_cursor;

    exception

      
        when others then
           v_bd_error := (substr('error '||to_char(sqlcode)||': '||sqlerrm, 1, 255));
           p_resultnumber := seg_retornar_cadena_error(-1, v_bd_error, sqlcode);
        return;
    end;
    
-- **************************************************************************************************
-- Program:     DatasetServiciosCuotas
-- Description: Para traer la informacion de los servicios relacionados con Cuotas
--Autor:Eury Vallejo
-- **************************************************************************************************
   procedure DatasetServiciosCuotas(
        p_iocursor       in out t_cursor,
        p_resultnumber    out varchar2)

    is
        v_bd_error        varchar(1000);
        c_cursor t_cursor;

    begin

    open c_cursor for
    select t.id_permiso Id, s.permiso_des servicio,t.id_usuario usuario,t.cuota,t.consumo
    from seg_cuota_t t join seg_permiso_t s
    on t.id_permiso =s.id_permiso;             
       
    p_resultnumber := 0;
    p_iocursor := c_cursor;

    exception    
        when others then
           v_bd_error := (substr('error '||to_char(sqlcode)||': '||sqlerrm, 1, 255));
           p_resultnumber := seg_retornar_cadena_error(-1, v_bd_error, sqlcode);
        return;
    end;

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
             p_resultnumber    out varchar2)

    is
     v_bd_error        varchar(1000);
     e_cuota           exception;
    begin

    if suirplus.seg_permisos_pkg.ValidarCuotasUsuarios(p_id_permiso,p_id_usuario) = true then 
       raise e_cuota;
    end if;

    Insert into seg_cuota_t(id_permiso,id_usuario,cuota,consumo,ult_fecha_act,ult_usuario_act)
    values(p_id_permiso,p_id_usuario,p_cuota,p_cuota,sysdate,p_usuario_act);
    commit;
       
    p_resultnumber := 0;
    exception    
       when e_cuota then
            p_resultnumber := seg_retornar_cadena_error('WS024', null, null);
            
        when others then
           v_bd_error := (substr('error '||to_char(sqlcode)||': '||sqlerrm, 1, 255));
           p_resultnumber := seg_retornar_cadena_error(-1, v_bd_error, sqlcode);
        return;
    end;

-- **************************************************************************************************
-- Program:     ActualizarCuota
-- Description: Actualizar la cuota del servicio a utilizar por el usuario
--Autor: Eury Vallejo
-- **************************************************************************************************
   procedure ActualizarCuota(
             p_id_permiso in seg_permiso_t.id_permiso%type,
             p_id_usuario in seg_usuario_t.id_usuario%type,
             p_resultnumber    out varchar2)

    is
        v_bd_error varchar(1000);
        v_consumo number(8);
    begin

    select t.consumo into v_consumo
    from seg_cuota_t t
    where lower(t.id_usuario) = lower(p_id_usuario) and t.id_permiso= p_id_permiso;

    update seg_cuota_t t
    set t.consumo = v_consumo - 1
    where lower(t.id_usuario) = lower(p_id_usuario) and t.id_permiso= p_id_permiso;
    
    commit;  
     
    p_resultnumber := 0;
    exception    
        when others then
           v_bd_error := (substr('error '||to_char(sqlcode)||': '||sqlerrm, 1, 255));
           p_resultnumber := seg_retornar_cadena_error(-1, v_bd_error, sqlcode);
        return;
    end;


-- **************************************************************************************************
-- Program:     BorrarCuota
-- Description: Borrar la cuota del servicio a utilizar por el usuario
--Autor: Eury Vallejo
-- **************************************************************************************************
   procedure BorrarCuota(
             p_id_permiso in seg_permiso_t.id_permiso%type,
             p_id_usuario in seg_usuario_t.id_usuario%type,
             p_resultnumber    out varchar2)

    is
        v_bd_error varchar(1000);
     
    begin

    delete from seg_cuota_t t where t.id_usuario = p_id_usuario and t.id_permiso= p_id_permiso;
       
    p_resultnumber := 0;
    exception    
        when others then
           v_bd_error := (substr('error '||to_char(sqlcode)||': '||sqlerrm, 1, 255));
           p_resultnumber := seg_retornar_cadena_error(-1, v_bd_error, sqlcode);
        return;
    end;

-- **************************************************************************************************
-- Program:     ValidarCuotasUsuarios
-- Description: Valida si el usuario tiene una relacion con un Servicio
--Autor: Eury Vallejo
-- **************************************************************************************************
FUNCTION ValidarCuotasUsuarios(p_id_permiso in seg_permiso_t.id_permiso%type,
                               p_id_usuario in seg_usuario_t.id_usuario%type) RETURN BOOLEAN IS
  v_count INTEGER := 0;
  v_resultado boolean;
BEGIN
  
select count(*)
       into v_count
from seg_cuota_t t 
where lower(t.id_usuario) = lower(p_id_usuario) 
      and t.id_permiso= p_id_permiso;   
  if v_count > 0 then
    v_resultado := true;
  else
    v_resultado := false;
  end if;

return v_resultado;
END;

-- **************************************************************************************************
-- Program:     BuscarIdPermiso
-- Description: Buscar Id de Permiso
--Autor: Eury Vallejo
-- **************************************************************************************************
procedure BuscarIdPermiso(p_permiso_url in seg_permiso_t.direccion_electronica%type,
                             p_resultnumber out varchar2)
IS  
v_id_permiso varchar2(50);
Begin
  select t.id_permiso
  into v_id_permiso
  from suirplus.seg_permiso_t t 
  where lower(t.direccion_electronica) = lower(p_permiso_url);
  
  p_resultnumber := v_id_permiso;
End;

-- **************************************************************************************************
-- Program:     ValidarCuotasConsumidas
-- Description: Valida si el usuario tiene cuotas disponibles para ser consumidas
--Autor: Eury Vallejo
-- **************************************************************************************************
procedure ValidarCuotasConsumidas(p_id_permiso in seg_permiso_t.id_permiso%type,
                               p_id_usuario in seg_usuario_t.id_usuario%type, p_resultnumber    out varchar2)
                                IS
v_count INTEGER := 0;
v_resultado INTEGER;
e_cuota           exception;
v_bd_error varchar(1000);
BEGIN

 if suirplus.seg_permisos_pkg.ValidarCuotasUsuarios(p_id_permiso,p_id_usuario) = false then 
     raise e_cuota;
 end if;

  
select t.consumo into v_count
from seg_cuota_t t 
where lower(t.id_usuario) = lower(p_id_usuario) and t.id_permiso= p_id_permiso;
         
  if v_count <> 0 then
    v_resultado := 1;
  else
    v_resultado := 0;
  end if;

p_resultnumber := v_resultado;

exception   
   when e_cuota then
            p_resultnumber := seg_retornar_cadena_error('WS025', null, null);             
        when others then
           v_bd_error := (substr('error '||to_char(sqlcode)||': '||sqlerrm, 1, 255));
           p_resultnumber := seg_retornar_cadena_error(-1, v_bd_error, sqlcode);
        return;
END;

end seg_permisos_pkg;