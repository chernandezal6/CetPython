create or replace package body suirplus.sre_procesar_RD_pkg is
  procedure procesar as
  begin
    sre_envio_archivos_pkg.log_anotar('Ejecutando Pre-validaciones');
    if pre_validaciones then
      begin
        HEAD_Statement;
        BODY_Statement;
        FOOT_Statement;
      exception
        when others then
          sre_envio_archivos_pkg.log_anotar('Error:' || SQLCODE || ' ' ||
                                            SUBSTR(SQLERRM, 1, 250));
          sre_envio_archivos_pkg.set_status('R', '650');
      end;
    end if;
  end;
  -- --------------------------------------------------------------------------------------------------
  function pre_validaciones return boolean as
    vConteo number(9);
    vResult boolean := true;
  begin
    h_RNC := trim(substr(sre_envio_archivos_pkg.v_doc_header, 004, 011));
  
    -- que sea un rnc o cedula valido
    select count(*)
      into vConteo
      from sre_empleadores_t
     where rnc_o_cedula = h_RNC
       and status = 'A';
  
    if (vConteo = 0) then
      sre_envio_archivos_pkg.log_anotar('  RNC no existe o no esta activo : [' ||
                                        h_RNC || ']');
      sre_envio_archivos_pkg.set_status('R', '150');
      vResult := false;
    end if;
  
    -- veamos el parametro 40
    begin
      select max(valor_fecha)
        into v_fecha_fac
        from sfc_det_parametro_t
       where id_parametro = 40; --FECHA FACTURACION DEL PERIODO
    exception
      when others then
        v_fecha_fac := null;
    end;
  
    if (v_fecha_fac is null) then
      sre_envio_archivos_pkg.log_anotar('No se pudo determinar la fecha del periodo de facturacion');
      sre_envio_archivos_pkg.set_status('R', '250');
      vResult := false;
    else
      v_periodo_fac := to_number(to_char(v_fecha_fac, 'yyyymm'));
    end if;
  
    return vResult;
  end;
  -- --------------------------------------------------------------------------------------------------
  procedure head_statement as
  begin
    sre_envio_archivos_pkg.log_anotar('HEAD Statements');
    update sre_archivos_t
       set id_rnc_cedula = trim(h_RNC)
     where id_recepcion = sre_envio_archivos_pkg.v_recepcion;
  
    delete from sre_tmp_movimiento_t
     where id_recepcion = sre_envio_archivos_pkg.v_recepcion;
  end;
  -- --------------------------------------------------------------------------------------------------
  procedure crear_movimiento_dependientes(pId_recepcion    in number,
                                          pPeriodo_factura in number,
                                          pMovimiento      out number) is
    v_conteo  number(9);
    v_rp      sre_movimiento_t.id_registro_patronal%type;
    v_nss_tit sre_ciudadanos_t.id_nss%type;
    v_nss_dep sre_ciudadanos_t.id_nss%type;
    v_existe  number(9);
  
  begin
    -- obtener el proximo numero de movimiento
    select sre_movimientos_seq.nextval into pMovimiento from dual;
    -- ------------------------------------------------------------------------------------
    -- en este punto, el archivo ha pasado todas validaciones y tiene registros validos
    -- ------------------------------------------------------------------------------------
    for archivo in (select *
                      from sre_archivos_t
                     where id_recepcion = pId_recepcion) loop
      -- obtener el registro patronal
      select id_registro_patronal
        into v_rp
        from sre_empleadores_t
       where rnc_o_cedula = archivo.id_rnc_cedula;
    
      -- obtener el proximo numero de movimiento
      -- select sre_movimientos_seq.nextval into pMovimiento from dual;
    
      --insertar el movimiento
      insert into sre_movimiento_t
        (ID_MOVIMIENTO,
         ID_REGISTRO_PATRONAL,
         ID_USUARIO,
         ID_TIPO_MOVIMIENTO,
         STATUS,
         FECHA_REGISTRO,
         PERIODO_FACTURA,
         ULT_FECHA_ACT,
         ULT_USUARIO_ACT,
         ID_RECEPCION)
      values
        (pMovimiento,
         v_rp,
         archivo.usuario_carga,
         'NV',
         'N',
         sysdate,
         pPeriodo_factura,
         sysdate,
         archivo.usuario_carga,
         pId_recepcion);
      commit;
    
      v_conteo := 1;
      for detalle in (select *
                        from sre_tmp_movimiento_t
                       where id_recepcion = pId_recepcion
                         and id_error in ('0', '000')) loop
        -- obtener el nss del titular
        if (detalle.tipo_documento = 'N') then
          v_nss_tit := to_number(detalle.no_documento);
        else
          select id_nss
            into v_nss_tit
            from sre_ciudadanos_t
           where tipo_documento = detalle.tipo_documento
             and no_documento = detalle.no_documento;
        end if;
      
        -- obtener el nss del dependiente
        if (detalle.tipo_documento_dependiente = 'N') then
          v_nss_dep := to_number(detalle.no_documento_dependiente);
        else
          select id_nss
            into v_nss_dep
            from sre_ciudadanos_t
           where tipo_documento = detalle.tipo_documento_dependiente
             and no_documento = detalle.no_documento_dependiente;
        end if;
      
        select count(*)
          into v_existe
          from sre_det_movimiento_t
         where id_movimiento = pMovimiento
           and id_nss = v_nss_tit
           and id_nss_dependiente = v_nss_dep;
      
        if (v_existe = 0) then
          -- insertar el registro
          insert into sre_det_movimiento_t
            (ID_MOVIMIENTO,
             ID_LINEA,
             ID_NSS,
             ID_NSS_DEPENDIENTE,
             ID_TIPO_NOVEDAD,
             id_parentesco,
             ID_NOMINA,
             PERIODO_APLICACION,
             FECHA_INICIO,
             APORTE_VOLUNTARIO,
             APORTE_AFILIADOS_T3,
             APORTE_EMPLEADOR_T3,
             REMUNERACION_ISR_OTROS,
             REMUNERACION_SS_OTROS,
             SALARIO_ISR,
             SALARIO_SS,
             SALDO_FAVOR_ISR,
             OTROS_INGRESOS_ISR,
             PA_SALARIO_SS,
             PA_APORTE_VOLUNTARIO,
             ULT_FECHA_ACT,
             ULT_USUARIO_ACT)
          values
            (pMovimiento,
             v_conteo,
             v_nss_tit,
             v_nss_dep,
             detalle.id_tipo_novedad,
             trim(detalle.id_parentesco),
             detalle.id_nomina,
             pPeriodo_factura,
             trunc(sysdate),
             0.00,
             0.00,
             0.00,
             0.00,
             0.00,
             0.00,
             0.00,
             0.00,
             0.00,
             0.00,
             0.00,
             sysdate,
             archivo.usuario_carga);
          commit;
        end if;
        v_conteo := v_conteo + 1;
      end loop;
    end loop;
  
    sre_load_movimiento_pkg.poner_en_cola(pMovimiento);
  end;
  -- --------------------------------------------------------------------------------------------------
  procedure body_statement as
    v_filehandle   UTL_FILE.FILE_TYPE;
    v_linea        varchar2(2000);
    v_no           integer;
    d_NOMINA       varchar2(3);
    d_TIP_DOC_TRAB varchar2(1);
    d_NUM_DOC_TRAB varchar2(11);
    d_tipo_novedad varchar2(2);
    d_TIP_DOC_DEP  varchar2(1);
    d_NUM_DOC_DEP  varchar2(11);
    d_NOMBRES      varchar2(50);
    d_APELLIDO1    varchar2(40);
    d_APELLIDO2    varchar2(40);
    d_parentesco   varchar2(2);
  begin
    sre_envio_archivos_pkg.log_anotar('BODY Statements');
  
    -- abrir el archivo y recorrer cada una de sus lineas
    v_no         := 0;
    v_filehandle := UTL_FILE.FOPEN(sre_envio_archivos_pkg.c_file_inbox,
                                   sre_envio_archivos_pkg.v_filename,
                                   'r');
    loop
      begin
        utl_file.get_line(v_filehandle, v_linea);
        if substr(v_linea, 1, 1) = 'D' then
          -- data parsing
          d_NOMINA       := substr(v_linea, 2, 3);
          d_TIP_DOC_TRAB := substr(v_linea, 5, 1);
          d_NUM_DOC_TRAB := substr(v_linea, 6, 11);
          d_tipo_novedad := substr(v_linea, 17, 2);
          d_TIP_DOC_DEP  := substr(v_linea, 19, 1);
          d_NUM_DOC_DEP  := substr(v_linea, 20, 11);
          d_NOMBRES      := substr(v_linea, 31, 50);
          d_APELLIDO1    := substr(v_linea, 81, 40);
          d_APELLIDO2    := substr(v_linea, 121, 40);
          d_parentesco   := substr(v_linea, 161, 2);
          v_no           := v_no + 1;
        
          insert into sre_tmp_movimiento_t
            (ID_RECEPCION,
             SECUENCIA_MOVIMIENTO,
             id_tipo_novedad,
             ID_NOMINA,
             TIPO_DOCUMENTO,
             NO_DOCUMENTO,
             TIPO_DOCUMENTO_DEPENDIENTE,
             NO_DOCUMENTO_DEPENDIENTE,
             id_parentesco,
             STATUS,
             FECHA_REGISTRO,
             NOMBRES,
             PRIMER_APELLIDO,
             SEGUNDO_APELLIDO,
             ULT_FECHA_ACT,
             ULT_USUARIO_ACT)
          values
            (sre_envio_archivos_pkg.v_recepcion,
             v_no,
             d_tipo_novedad,
             trim(d_NOMINA),
             trim(d_TIP_DOC_TRAB),
             trim(d_NUM_DOC_TRAB),
             trim(d_TIP_DOC_DEP),
             trim(d_NUM_DOC_DEP),
             d_parentesco,
             'N',
             trunc(sysdate),
             trim(d_NOMBRES),
             trim(d_APELLIDO1),
             trim(d_APELLIDO2),
             sysdate,
             sre_envio_archivos_pkg.v_usuario);
        end if;
      exception
        when no_data_found then
          exit;
      end;
    end loop;
    UTL_FILE.FCLOSE(v_filehandle);
  end;
  -- --------------------------------------------------------------------------------------------------
  procedure foot_statement as
    v_patronal sre_empleadores_t.id_registro_patronal%type;
    v_nomina   sre_nominas_t.id_nomina%type;
    v_conteo   integer;
    v_status   sre_tmp_movimiento_t.status%type;
    v_error    sre_tmp_movimiento_t.id_error%type;
    v_nss_emp  sre_ciudadanos_t.id_nss%type;
    v_nss_dep  sre_ciudadanos_t.id_nss%type;
  
    v_sexo_dep sre_ciudadanos_t.sexo%type; --sexo del dependiente
    --    v_sexo_par  sre_ciudadanos_t.sexo%type;  --sexo del parentesco
  
    v_doc_good   integer := 0;
    v_doc_bad    integer := 0;
    res_val_dep  seg_error_t.error_des%type;
    v_mov_creado sre_movimiento_t.id_movimiento%type;
  begin
    sre_envio_archivos_pkg.log_anotar('FOOT Statements');
  
    -- determinar el ID del empleador
    select id_registro_patronal
      into v_patronal
      from sre_empleadores_t
     where rnc_o_cedula = h_RNC;
  
    for archivos in (select a.rowid id, a.*
                       from sre_archivos_t a
                      where a.id_recepcion =
                            sre_envio_archivos_pkg.v_recepcion) loop
      for detalle in (select a.rowid id, a.*
                        from sre_tmp_movimiento_t a
                       where a.id_recepcion =
                             sre_envio_archivos_pkg.v_recepcion) loop
        v_status := 'P';
        v_error  := '000';
      
        -- ver si el tipo de novedad
        if (detalle.id_tipo_novedad not in ('ID', 'SD')) then
          v_status := 'R';
          v_error  := '164';
        end if;
      
        /*
                -- ver si el codigo de parentesco existe
                begin
                  select sexo
                  into v_sexo_par
                  from suirplus.ars_parentescos_t
                  where id_parentesco = trim(detalle.id_parentesco);
                exception when no_data_found then
                  v_status := 'R';
                  v_error  := '322';
                end;
        */
      
        if v_error = '000' then
          -- ver si este mismo registro ya esta
          select count(*)
            into v_conteo
            from sre_tmp_movimiento_t a
           where a.id_recepcion = sre_envio_archivos_pkg.v_recepcion
             and a.tipo_documento = detalle.tipo_documento
             and a.no_documento = detalle.no_documento
             and a.id_nomina = detalle.id_nomina
             and a.tipo_documento_dependiente =
                 detalle.tipo_documento_dependiente
             and a.no_documento_dependiente =
                 detalle.no_documento_dependiente
             and a.secuencia_movimiento < detalle.secuencia_movimiento;
        
          if (v_conteo > 0) then
            v_status := 'R';
            v_error  := '422';
          end if;
        end if;
      
        -- tipo de documento del trabajador
        if v_error = '000' then
          if (detalle.tipo_documento not in ('C', 'N')) or
             (detalle.tipo_documento_dependiente not in ('C', 'N')) then
            v_status := 'R';
            v_error  := '101';
          end if;
        end if;
      
        -- obtener nss empleado
        if v_error = '000' then
          if (detalle.tipo_documento = 'N') then
            begin
              select id_nss, sexo
                into v_nss_emp, v_sexo_dep
                from sre_ciudadanos_t
               where id_nss = detalle.no_documento
                 and tipo_documento in ('C', 'P');
            exception
              when others then
                v_nss_emp := null;
            end;
          else
            begin
              select id_nss, sexo
                into v_nss_emp, v_sexo_dep
                from sre_ciudadanos_t
               where tipo_documento = detalle.tipo_documento
                 and no_documento = detalle.no_documento;
            exception
              when others then
                v_nss_emp := null;
            end;
          end if;
        
          if v_nss_emp is null then
            v_status := 'R';
            v_error  := '111';
          end if;
        end if;
      
        -- nss obtener dependiente
        if v_error = '000' then
          begin
            if (detalle.tipo_documento_dependiente = 'N') then
              select id_nss
                into v_nss_dep
                from sre_ciudadanos_t
               where id_nss = to_number(detalle.no_documento_dependiente)
               and tipo_documento in ('C', 'P');
            else
              select id_nss
                into v_nss_dep
                from sre_ciudadanos_t
               where tipo_documento = detalle.tipo_documento_dependiente
                 and no_documento = detalle.no_documento_dependiente;
            end if;
          exception
            when others then
              v_nss_dep := null;
          end;
        
          if v_nss_dep is null then
            dbms_output.put_line('1');
            v_status := 'R';
            v_error  := '110';
          end if;
        end if;
      
        /*
                -- validar el sexo del dependiente contra el sexo del parentesco
                if v_error='000' then
                  select sexo
                  into v_sexo_dep
                  from sre_ciudadanos_t
                  where id_nss = v_nss_dep;
        
                  if (v_sexo_dep <> v_sexo_par) then
                    v_status := 'R';
                     v_error  := '323';
                  end if;
                end if;
        */
      
        -- que la nomina exista
        if v_error = '000' then
          begin
            v_nomina := to_number(detalle.id_nomina);
            select count(*)
              into v_conteo
              from sre_nominas_t
             where id_registro_patronal = v_patronal
               and id_nomina = v_nomina;
          exception
            when others then
              v_conteo := 0;
          end;
        
          if v_conteo = 0 then
            v_status := 'R';
            v_error  := '155';
          end if;
        end if;
      
        -- ejecutar ademas las mismas validaciones que usa la pagina
        if v_error = '000' then
          Validar_Dependiente(detalle.id_tipo_novedad,
                              v_patronal,
                              v_nomina,
                              v_nss_emp,
                              v_nss_dep,
                              res_val_dep);
        
          if (res_val_dep <> 'OK') then
            v_status := 'R';
            select id_error
              into v_error
              from seg_error_t
             where error_des = res_val_dep;
          end if;
        end if;
      
        /*
                -- ---------------------------------------------------------------
                -- ya no se actualizara automaticamente la tabla de dependientes
                -- en ves de, se creara un movimiento y se llamara a aplica_mov
                -- ---------------------------------------------------------------
                if v_error='000' then
                  -- ver si existe el dependiente
                  select count(*)
                  into v_conteo
                  from sre_dependiente_t
                  where id_nss_dependiente = v_nss_dep;
        
                  if (v_conteo=0) then
                    -- todo esta correcto, insertar el registro
                    insert into sre_dependiente_t (
                      id_registro_patronal,
                      id_nomina,
                      id_nss,
                      id_nss_dependiente,
                      fecha_registro,
                      ult_fecha_act,
                      ult_usuario_act,
                      status
                    ) values (
                      v_patronal,
                      v_nomina,
                      v_nss_emp,
                      v_nss_dep,
                      trunc(sysdate),
                      sysdate,
                      sre_envio_archivos_pkg.v_usuario,
                      'A'
                    );
                 else
                   --existe, de baja, de el o de otro, actualizar
                   update sre_dependiente_t
                   set id_registro_patronal = v_patronal
                      ,id_nomina            = v_nomina
                      ,id_nss               = v_nss_emp
                      ,fecha_registro       = trunc(sysdate)
                      ,ult_fecha_act        = sysdate
                      ,ult_usuario_act      = sre_envio_archivos_pkg.v_usuario
                      ,status               = 'A'
                   where id_nss_dependiente = v_nss_dep;
                 end if;
                end if;
        */
      
        if v_error = '000' then
          v_doc_good := v_doc_good + 1;
        else
          v_doc_bad := v_doc_bad + 1;
        end if;
      
        -- actualizar estado registro de detalle
        update sre_tmp_movimiento_t t
           set t.status = v_status, t.id_error = v_error
         where t.rowid = detalle.id;
      
        update sre_archivos_t
           set registros_ok = v_doc_good, registros_bad = v_doc_bad
         where id_recepcion = sre_envio_archivos_pkg.v_recepcion;
      end loop;
    
      -- si sysdate es mayor que fecha es que ya se genero la factura del periodo
      if (v_doc_good >= 1) then
        crear_movimiento_dependientes(sre_envio_archivos_pkg.v_recepcion,
                                      v_periodo_fac,
                                      v_mov_creado);
        sre_load_movimiento_pkg.poner_en_cola(v_mov_creado);
      end if;
    
      /*
             if (sysdate >= v_fecha_fac) then
              sre_envio_archivos_pkg.log_anotar('Si');
              -- seleccionar las diferentes nominas que resultaron con cambios exitosos
              for nominas in (
                select distinct d.id_nomina
                from sre_tmp_movimiento_t d
                where d.id_recepcion=sre_envio_archivos_pkg.v_recepcion
                and d.id_error='000'
              ) loop
                sre_envio_archivos_pkg.log_anotar('Nomina '||nominas.id_nomina||' periodo '||v_periodo_fac);
                for facturas in (
                  select f.id_referencia
                  from sfc_facturas_t f
                  where f.id_registro_patronal=v_patronal
                  and f.id_nomina=nominas.id_nomina
                  and f.periodo_factura=v_periodo_fac
                  and f.status in ('VE','VI')
                  and f.no_autorizacion is null
                ) loop
                  -- no quitar
                  begin
                    sre_envio_archivos_pkg.log_anotar('a crear movimiento');
                    crear_movimiento_dependientes(sre_envio_archivos_pkg.v_recepcion,v_periodo_fac,v_mov_creado);
                    sre_envio_archivos_pkg.log_anotar('mov '||v_mov_creado);
                    sre_load_movimiento_pkg.poner_en_cola(v_mov_creado);
                    sre_envio_archivos_pkg.log_anotar('ok');
                  exception when others then
                    system.html_mail('info@mail.tss2.gov.do','roberto_jaquez@mail.tss2.gov.do','error al crear movimiento de dependientes',sqlerrm);
                  end;
                end loop;
              end loop;
             end if;
            end if;
      */
    
      -- setea el estado del archivo
      if (v_doc_bad <> 0) then
        sre_envio_archivos_pkg.set_status('P', '250');
      else
        sre_envio_archivos_pkg.set_status('P', '000');
      end if;
    end loop;
  end;
  -- --------------------------------------------------------------------------------------------------
  procedure Validar_Dependiente(pTipo_mov             in varchar2,
                                pId_Registro_Patronal in number,
                                pId_Nomina            in number,
                                pId_Nss_Titular       in number,
                                pId_Nss_Dependiente   in number,
                                pResult               out varchar2) is
    v_conteo integer := 0;
    v_error  integer := 0;
  begin
    -- que no manden el mismo titular como dependiente
    if (pId_Nss_Titular = pId_Nss_Dependiente) then
      v_error := 192;
      goto fin_validaciones;
    end if;
  
    -- validar el registro_patronal
    select count(*)
      into v_conteo
      from sre_empleadores_t s
     where id_registro_patronal = pId_Registro_Patronal;
    if (v_conteo = 0) then
      v_error := 3;
      goto fin_validaciones;
    end if;
  
    -- validar el empleador/nomina
    select count(*)
      into v_conteo
      from sre_nominas_t s
     where id_registro_patronal = pId_Registro_Patronal
       and id_nomina = pId_Nomina;
    if (v_conteo = 0) then
      v_error := 155;
      goto fin_validaciones;
    end if;
  
    -- validar el trabajador en dicha nomina
    select count(*)
      into v_conteo
      from sre_trabajadores_t s
     where id_registro_patronal = pId_Registro_Patronal
       and id_nomina = pId_Nomina
       and status ='A'
       and id_nss = pId_Nss_Titular;
       
    if (v_conteo = 0) then
      v_error := 514;
      goto fin_validaciones;
    end if;
  
    -- validar la cedula del trabajador
    select count(*)
      into v_conteo
      from sre_ciudadanos_t
     where tipo_documento = 'C'
       and id_nss = pId_Nss_Titular;
    if (v_conteo = 0) then
      v_error := 111;
      goto fin_validaciones;
    end if;
  
    -- Considerar estas validaciones solo en caso de altas a dependientes
    -- Colocado por Gregorio Herrera
    -- 01-Oct-2009
    if (pTipo_mov = 'ID') then
      -- el dependiente no debe ser un empleado activo
      select count(*)
        into v_conteo
        from sre_trabajadores_t t
        join sre_empleadores_t e
          on e.id_registro_patronal = t.id_registro_patronal
         and e.status = 'A'
        join sre_nominas_t n
          on n.id_registro_patronal = t.id_registro_patronal
         and n.id_nomina = t.id_nomina
         and n.tipo_nomina <> 'P'
       where t.id_nss = pId_Nss_Dependiente
         and t.status = 'A';
      if (v_conteo > 0) then
        v_error := 120;
        goto fin_validaciones;
      end if;
    end if;
  
    --validar si existe para otro empleador/nomina/trabajador
    if (pTipo_mov = 'ID') then
       select count(*)
        into v_conteo
        from sre_dependiente_t d
       where d.id_nss_dependiente = pId_Nss_Dependiente
         and d.status = 'A'
         and (d.id_registro_patronal <> pId_Registro_Patronal or
             d.id_nomina <> pId_Nomina or d.id_nss <> pId_Nss_Titular);
      if (v_conteo > 0) then
        v_error := 112;
        goto fin_validaciones;
      end if;
    end if;
    
    --validar si existe de alta para el mismo
    if (pTipo_mov = 'ID') then
      select count(*)
        into v_conteo
        from sre_dependiente_t d
       where d.status = 'A'
         and d.id_registro_patronal = pId_Registro_Patronal
         and d.id_nomina = pId_Nomina
         and d.id_nss = pId_Nss_Titular
         and d.id_nss_dependiente = pId_Nss_Dependiente;
      if (v_conteo > 0) then
        v_error := 191;
        goto fin_validaciones;
      end if;
    end if;
  
    --validar si existe de baja para el mismo
    if (pTipo_mov = 'SD') then
      select count(*)
        into v_conteo
        from sre_dependiente_t d
       where d.id_registro_patronal = pId_Registro_Patronal
         and d.id_nomina = pId_Nomina
         and d.id_nss = pId_Nss_Titular
         and d.id_nss_dependiente = pId_Nss_Dependiente
         and d.status <> 'A';
      if (v_conteo > 0) then
        v_error := 115;
        goto fin_validaciones;
      end if;
    end if;
  
    -- Considerar estas validaciones solo en caso de altas a dependientes
    -- Colocado por Gregorio Herrera
    -- 01-Oct-2009
    if pTipo_mov = 'ID' then
/*
      -- validar que solo los titulares y/o conyuges puedan agregar un dependiente adiconal
      -- Charlie: 19-03-2009
      if not sre_novedades_pkg.isTitular_Conyuge(pId_Nss_Titular) then
        v_error := 199;
        goto fin_validaciones;
      end if;
    
      -- validar que el dependiente adicional a registrar no exista como titular AC en la vista diaria
      -- Charlie: 19-03-2009
      if sre_novedades_pkg.isDependienteTitularAC(pId_Nss_Dependiente) then
        v_error := 198;
        goto fin_validaciones;
      end if;
*/      
      --validar que un dependiente adicional existe activo dentro del mismo núcleo familiar de la persona que lo va a pagar
      if NOT sre_novedades_pkg.IsDepNucleoValido(pId_NSS_titular, pId_NSS_Dependiente) then
        v_error := 195;
        goto fin_validaciones;
      end if;
    end if;

    -- fin de las validaciones -------------------------------
    <<fin_validaciones>>
    if (v_error = 0) then
      pResult := 'OK';
    else
      select error_des
        into pResult
        from seg_error_t
       where id_error = to_char(v_error);
    end if;
  end;
  -- --------------------------------------------------------------------------------------------------

  procedure procesar_rd(p_recepcion IN sre_archivos_t.id_recepcion%TYPE) is
  
    v_patronal       sre_empleadores_t.id_registro_patronal%type;
    v_nomina         sre_nominas_t.id_nomina%type;
    v_conteo         integer;
    v_status         sre_tmp_movimiento_t.status%type;
    v_error          sre_tmp_movimiento_t.id_error%type;
    v_nss_emp        sre_ciudadanos_t.id_nss%type;
    v_nss_dep        sre_ciudadanos_t.id_nss%type;
    v_sexo_dep       sre_ciudadanos_t.sexo%type; --sexo del dependiente
    v_doc_good       integer := 0;
    v_doc_bad        integer := 0;
    res_val_dep      seg_error_t.error_des%type;
    v_mov_creado     sre_movimiento_t.id_movimiento%type;
    vRnc             sre_archivos_t.id_rnc_cedula%type;
    vConteo          number(9);
    v_ErrorArchivo   number(3);
    v_ErrorDetallePY number(3); --para identificar los registros rechazados desde python por incumplimiento de layout del archivo
    v_error_a        seg_error_t.id_error%type := '000';
  begin
  
    select t.id_rnc_cedula
      into vRnc
      from sre_archivos_t t
     where t.id_recepcion = p_recepcion;
  
    -- que sea un rnc o cedula valido
    select count(*)
      into vConteo
      from sre_empleadores_t
     where rnc_o_cedula = vRnc
       and status = 'A';
  
    if (vConteo = 0) then
      sre_envio_archivos_pkg.log_anotar('  RNC no existe o no esta activo : [' || vRnc || ']');
      v_error_a := '150';
      goto abortar;
    end if;
  
    begin
      select max(valor_fecha)
        into v_fecha_fac
        from sfc_det_parametro_t
       where id_parametro = 40; --FECHA FACTURACION DEL PERIODO
    exception
      when others then
        v_fecha_fac := null;
    end;
  
    if (v_fecha_fac is null) then
      sre_envio_archivos_pkg.log_anotar('No se pudo determinar la fecha del periodo de facturacion');
      SRE_PROCESAR_PYTHON_PKG.set_status(p_recepcion, 'R', '250');
      v_error_a := '250';
      goto abortar;
    else
      v_periodo_fac := to_number(to_char(v_fecha_fac, 'yyyymm'));
    end if;
  
    <<abortar>>
    if v_error_a != '000' then
      suirplus.sre_procesar_python_pkg.set_status(p_recepcion,
                                                  'R',
                                                  v_error_a);
      --borramos lo que se haya insertado en tmp para este envio
      delete from suirplus.sre_tmp_movimiento_t t
       where t.id_recepcion = p_recepcion;
      commit;
      return;
    end if;
    --------------------------------------------------------------------------------------------------------
    sre_envio_archivos_pkg.log_anotar('HEAD Statements');
    --------------------------------------------------------------------------------------------------------
  
    sre_envio_archivos_pkg.log_anotar('FOOT Statements');
  
    -- determinar el ID del empleador
    select id_registro_patronal
      into v_patronal
      from sre_empleadores_t
     where rnc_o_cedula = vRnc;
  
    for archivos in (select a.rowid id, a.*
                       from sre_archivos_t a
                      where a.id_recepcion = p_recepcion) loop
      v_ErrorArchivo := 0;
      for detalle in (select a.rowid id, a.*
                        from sre_tmp_movimiento_t a
                       where a.id_recepcion = p_recepcion) loop
      
        v_status         := 'P';
        v_error          := '000';
        v_ErrorDetallePY := 0;
      
        --buscamos en tmp si tiene un id_error PY1 para que el registro no sea evaluado
        select count(*)
          into Vconteo
          from sre_tmp_movimiento_t
         where rowid = detalle.id
           and detalle.id_error = 'PY1';
      
        if Vconteo > 0 then
          v_ErrorDetallePY := 999;
          goto fin_validaciones;
        end if;
      
        -- ver si el tipo de novedad
        if (detalle.id_tipo_novedad not in ('ID', 'SD')) then
          v_error := '164';
          goto fin_validaciones;
        end if;
      
        if (v_error = '000') then
          -- ver si este mismo registro ya esta
          select count(*)
            into v_conteo
            from sre_tmp_movimiento_t a
           where a.id_recepcion = p_recepcion
             and a.tipo_documento = detalle.tipo_documento
             and a.no_documento = detalle.no_documento
             and a.id_nomina = detalle.id_nomina
             and a.tipo_documento_dependiente =
                 detalle.tipo_documento_dependiente
             and a.no_documento_dependiente =
                 detalle.no_documento_dependiente
             and a.secuencia_movimiento < detalle.secuencia_movimiento;
        
          if (v_conteo > 0) then
            v_error := '422';
            goto fin_validaciones;
          end if;
        end if;
      
        -- tipo de documento del trabajador
        if v_error = '000' then
          if (detalle.tipo_documento not in ('C', 'N')) or
             (detalle.tipo_documento_dependiente not in ('C', 'N')) then
            v_error := '101';
            goto fin_validaciones;
          end if;
        end if;
      
        -- obtener nss empleado
        if v_error = '000' then
          if (detalle.tipo_documento = 'N') then
            begin
              select id_nss, sexo
                into v_nss_emp, v_sexo_dep
                from sre_ciudadanos_t
               where id_nss = detalle.no_documento
                 and tipo_documento in ('C', 'P');
            exception
              when others then
                v_nss_emp := null;
            end;
          else
            begin
              select id_nss, sexo
                into v_nss_emp, v_sexo_dep
                from sre_ciudadanos_t
               where tipo_documento = detalle.tipo_documento
                 and no_documento = detalle.no_documento;                 
            exception
              when others then
                v_nss_emp := null;
            end;
          end if;
        
          if v_nss_emp is null then
            v_error := '111';
            goto fin_validaciones;
          end if;
        end if;
      
        -- nss obtener dependiente
        if v_error = '000' then
          begin
            if (detalle.tipo_documento_dependiente = 'N') then
              select id_nss
                into v_nss_dep
                from sre_ciudadanos_t
               where id_nss = to_number(detalle.no_documento_dependiente)
                 and tipo_documento in ('C', 'P');
            else
              select id_nss
                into v_nss_dep
                from sre_ciudadanos_t
               where tipo_documento = detalle.tipo_documento_dependiente
                 and no_documento = detalle.no_documento_dependiente;
            end if;
          exception
            when others then
              v_nss_dep := null;
          end;
        
          if v_nss_dep is null then
            v_error := '110';
            goto fin_validaciones;
          end if;
        end if;
      
        -- que la nomina exista
        if v_error = '000' then
          begin
            v_nomina := to_number(detalle.id_nomina);
            select count(*)
              into v_conteo
              from sre_nominas_t
             where id_registro_patronal = v_patronal
               and id_nomina = v_nomina;
          exception
            when others then
              v_conteo := 0;
          end;
        
          if v_conteo = 0 then
            v_error := '155';
            goto fin_validaciones;
          else
            --validar permiso nomina representante               
            if not
                sre_archivos_pkg.isnominaRepresentante(archivos.usuario_carga,
                                                       detalle.id_nomina) then
              v_error := 116;
              goto fin_validaciones;
            end if;
          end if;
        end if;
      
        -- ejecutar ademas las mismas validaciones que usa la pagina
        if v_error = '000' then
          Validar_Dependiente(detalle.id_tipo_novedad,
                              v_patronal,
                              v_nomina,
                              v_nss_emp,
                              v_nss_dep,
                              res_val_dep);
        
          if (res_val_dep <> 'OK') then
            select id_error
              into v_error
              from seg_error_t
             where upper(error_des) = upper(res_val_dep);
          end if;
        end if;
      
        <<fin_validaciones>>
        if (v_error = '000') and (v_ErrorDetallePY = 0) then
          -- no hubo error
          v_doc_good := v_doc_good + 1;
        else
          v_doc_bad      := v_doc_bad + 1;
          v_errorArchivo := '250';
        end if; 
             
        -- actualizar estado registro de detalle          
        if v_ErrorDetallePY = 0 then
          update sre_tmp_movimiento_t
             set id_error = v_error,
                 status   = decode(v_error, '000', 'P', 'R')
           where rowid = detalle.id;
          commit;
        end if;
      end loop;
    end loop;

    -- actualizar los registros ok/bad del archivo
      update sre_archivos_t a
         set a.status                 = Decode(v_doc_good,0,'R','P'),
             a.id_error               = Decode(v_doc_good,0,'301',v_errorArchivo),
             a.registros_ok           = v_doc_good,
             a.registros_bad          = v_doc_bad
       where id_recepcion = p_recepcion;
      commit;  
  

    if (v_doc_good > 0) then
    --este metodo se encarga de crear un movimiento para el empleador en curso y busca 
    --el/los registros que pasaron bien las validaciones para crear sus dependientes
      crear_movimiento_dependientes(p_recepcion,
                                    v_periodo_fac,
                                    v_mov_creado);
    end if;
  
  Exception
    When Others Then
      Sre_Envio_Archivos_Pkg.Log_Anotar('Error:' || Sqlcode || ' ' ||
                                        Substr(Sqlerrm, 1, 650));
    
      SRE_PROCESAR_PYTHON_PKG.set_status(p_recepcion, 'R', '650');
    
  end;
  -- --------------------------------------------------------------------------------------------------

end sre_procesar_RD_pkg;
