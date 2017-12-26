CREATE OR REPLACE PACKAGE BODY SUIRPLUS.SRE_PROCESAR_RT_PKG IS
  -- --------------------------------------------------------------------------------------------------
  -- no usar variables del paquete de archivos, por si la sesion muere se sepa que archivo estamos procesando
  v_recepcion  sre_archivos_t.id_recepcion%type;
  v_usuario    sre_archivos_t.usuario_carga%type;
  v_doc_header varchar2(1000);
  c_file_inbox varchar2(1000);
  v_filename   varchar2(1000);
  -- --------------------------------------------------------------------------------------------------
  procedure insertar_equivalencia(p_rp      in number,
                                  p_ano     in number,
                                  p_nss_rep in number,
                                  p_nss_utl in number,
                                  p_usr     in varchar) is
    existe integer;
  begin
    dbms_output.put_line('~1');
    select count(*)
      into existe
      from sfc_equivalencias_ir13_t
     where id_registro_patronal = p_rp
       and ano_fiscal = p_ano
       and id_nss_reportado = p_nss_rep
       and id_nss_utilizado = p_nss_utl;
  
    dbms_output.put_line('~2');
    if (existe = 0) then
      dbms_output.put_line('~3');
      delete from sfc_equivalencias_ir13_t
       where id_registro_patronal = p_rp
         and ano_fiscal = p_ano
         and ((id_nss_reportado = p_nss_rep and
             id_nss_utilizado = p_nss_rep) or
             (id_nss_reportado = p_nss_utl and
             id_nss_utilizado = p_nss_utl));
    
      insert into sfc_equivalencias_ir13_t
        (id_registro_patronal,
         ano_fiscal,
         id_nss_reportado,
         id_nss_utilizado,
         ult_usuario_act,
         ult_fecha_act)
      values
        (p_rp, p_ano, p_nss_rep, p_nss_utl, p_usr, sysdate);
      dbms_output.put_line('~4');
      commit;
    end if;
    dbms_output.put_line('~5');
  end;
  -- --------------------------------------------------------------------------------------------------
  procedure insertar_equivalencia(p_rp  in number,
                                  p_ano in number,
                                  p_nss in number,
                                  p_usr in varchar) is
    existe integer;
  begin
    select count(*)
      into existe
      from sfc_equivalencias_ir13_t
     where id_registro_patronal = p_rp
       and ano_fiscal = p_ano
       and id_nss_reportado = p_nss;
  
    if (existe = 0) then
      insert into sfc_equivalencias_ir13_t
        (id_registro_patronal,
         ano_fiscal,
         id_nss_reportado,
         id_nss_utilizado,
         ult_usuario_act,
         ult_fecha_act)
      values
        (p_rp, p_ano, p_nss, p_nss, p_usr, sysdate);
      commit;
    end if;
  end;
  -- --------------------------------------------------------------------------------------------------
  function nss_equivalente(p_id_registro_patronal in number,
                           p_ano_fiscal           in number,
                           p_id_nss_reportado     in number) return number as
    result_nss integer;
  begin
    begin
      select id_nss_utilizado
        into result_nss
        from suirplus.sfc_equivalencias_ir13_t e
       where e.id_registro_patronal = p_id_registro_patronal
         and e.ano_fiscal = p_ano_fiscal
         and e.id_nss_reportado = p_id_nss_reportado;
    exception
      when no_data_found then
        result_nss := p_id_nss_reportado;
    end;
    return result_nss;
  end;
  -- --------------------------------------------------------------------------------------------------
  procedure mailme(texto in varchar2, mensaje in varchar2) is
  begin
    system.html_mail('info@mail.tss2.gov.do',
                     '_operaciones@mail.tss2.gov.do',
                     'RT:' || v_recepcion || '/' || texto,
                     mensaje);
  end;
  -- --------------------------------------------------------------------------------------------------
  procedure procesar as
  begin
    -- no usar variables del paquete de archivos, por si la sesion muere se sepa que archivo estamos procesando
    v_recepcion  := sre_envio_archivos_pkg.v_recepcion;
    v_usuario    := sre_envio_archivos_pkg.v_usuario;
    v_doc_header := sre_envio_archivos_pkg.v_doc_header;
    c_file_inbox := sre_envio_archivos_pkg.c_file_inbox;
    v_filename   := sre_envio_archivos_pkg.v_filename;
  
    dbms_output.put_line('!');
    sre_envio_archivos_pkg.log_anotar('Ejecutando Pre-validaciones');
    if pre_validaciones then
      begin
        sre_envio_archivos_pkg.log_anotar('head');
        HEAD_Statement;
        sre_envio_archivos_pkg.log_anotar('body');
        BODY_Statement;
        sre_envio_archivos_pkg.log_anotar('foot');
        FOOT_Statement;
        sre_envio_archivos_pkg.log_anotar('end');
      exception
        when others then
          mailme('1)ORA-' || sqlcode, sqlerrm);
          sre_envio_archivos_pkg.set_status('R', '650');
          raise;
      end;
    end if;
    sre_envio_archivos_pkg.log_anotar('fin');
  end;
  -- --------------------------------------------------------------------------------------------------
  -- El IR-3 esta inactivo, presentar error si se envia un archivo con este periodo
  function validar_periodo(p_periodo in varchar2) return boolean as
    vResult boolean := false;
  begin
    if p_periodo >= to_number(h_periodo_rectificativa) then
      -- Si es IR-3
      vResult :=  --false;     -- IR-3 habilitado
       true; -- presentar error
    end if;
  
    return vResult;
  end;
  -- --------------------------------------------------------------------------------------------------
  procedure validar_periodo(p_periodo   in varchar2,
                            p_id_error  out number,
                            p_error_des out varchar2) is
  begin
    /*
        if to_number(p_periodo) <> to_number(to_char(sysdate,'yyyy'))-1 then
          p_id_error := 213;
        else
          p_id_error := 0;
        end if;
    */
    p_id_error := p_periodo; -- esto solo es para que no de warning de parametro no usado
    p_id_error := 0;
  
    select max(error_des)
      into p_error_des
      from seg_error_t
     where id_error = p_id_error;
  end;
  -- --------------------------------------------------------------------------------------------------
  procedure validar_pagos(p_rnc       in varchar2,
                          p_periodo   in varchar2,
                          p_id_error  out number,
                          p_error_des out varchar2) is
    vConteo number(9) := 0;
    vRP     number(9);
    vper    number(9);
  begin
  
    p_id_error := 0; -- Sin errores, por default
    vPer       := to_number(substr(p_periodo, 3, 4) ||
                            substr(p_periodo, 1, 2));
  
    --    if to_number(substr(p_periodo,3,4)) <> to_number(to_char(add_months(sysdate,-12),'yyyy')) then
    --      p_id_error := 213;
    if not validar_periodo(vPer) then
      p_id_error := 83; -- Periodo invalido (IR-3 inactivo)
    else
    
      begin
        select id_registro_patronal
          into vRP
          from sre_empleadores_t
         where rnc_o_cedula = p_rnc;
      
        -- Task 1205 (begin)
        if vPer >= to_number(h_periodo_rectificativa) then
          -- Si es IR-3
          -- validar que no tenga liquidaciones VEncidas o VIgentes y que no son Rectificativas
          /*
                    select count(*) into vConteo
                    from sfc_liquidacion_isr_t l
                    where l.id_registro_patronal=vRP
                    and l.periodo_liquidacion=vPer
                    and l.id_tipo_factura<>'T'       -- que no son Rectificativas
                    and l.status in('VE','VI','PE'); -- VEncidas o VIgentes
                    if (vconteo>0) then
                      p_id_error := 517;
                    else
                      -- Verificar si tiene liquidaciones PAgadas o EXentas (debe tener).
                      /*select count(*) into vConteo
                      from sfc_liquidacion_isr_t l
                      where l.id_registro_patronal=vRP
                      and l.periodo_liquidacion=vPer
                      and l.status in('PA','EX');
                      Comentado by HM....
          */
          if (vPer >= 201201) then
            -- si es 2012-01 en adelante para rectificar debe aprobarlo dgii
            Select count(*)
              into vConteo
              from DGII_ISR_STATUS_LOCAL_T i
             where i.is_autoriza_rectificativa = 'S'
               and i.periodo_liquidacion = vPer
               and i.rnc = p_rnc;
          
            if (vConteo = 0) then
              p_id_error := 325; -- No tiene liquidaciones pagadas para este periodo
            end if;
          else
            -- anterior a 2012-01 siempre puede rectificar SI HA PAGADO
            select count(*)
              into vConteo
              from sfc_liquidacion_isr_t l
             where l.id_registro_patronal = vRP
               and l.periodo_liquidacion = vPer
               and l.status in ('PA', 'EX');
          
            if (vconteo = 0) then
              p_id_error := 517;
            end if;
          end if;
        
          /*
                    if (vConteo = 0) then
                      p_id_error := 325; -- No tiene liquidaciones pagadas para este periodo
                      --p_id_error := 519; -- No tiene liquidaciones pagadas para este periodo
                      /* Comented by RJ on 2009/10/07
                                  else
                                    -- Verificar que no tenga una liquidacion rectificada vencida
                                    select count(*) into vConteo
                                    from sfc_liquidacion_isr_t l
                                    where l.id_registro_patronal=vRP
                                    and l.periodo_liquidacion=vPer
                                    and l.id_tipo_factura='T'
                                    and l.status in ('VI','VE');
          
                                    if (vConteo>0) then --RJ 24/07/2009
                                      p_id_error := 551; -- Tiene una liquidacion T vigente o vencida, debe pagarla
                                    end if;
                                  end if;
                      end of comment
                    end if;
          */
        else
          -- es IR-13
          --verificar si ya declaró
          select count(*)
            into vconteo
            from sfc_resumen_ir13_t r
           where r.id_registro_patronal = p_rnc
             and r.ano_fiscal = to_number(substr(p_periodo, 3, 4))
             and r.status = 'P';
        
          if (vconteo > 0) then
            p_id_error := 180;
          else
            select count(*)
              into vConteo
              from dgii_pagos_ir3_t p
             where p.id_registro_patronal = vRP
               and p.periodo_pago = vPer;
          
            if vConteo = 0 then
              -- Verificar si tiene liquidaciones PAgadas o EXentas
              select count(*)
                into vConteo
                from sfc_liquidacion_isr_t l
               where l.id_registro_patronal = vRP
                 and l.periodo_liquidacion = vPer
                 and l.status in ('PA', 'EX');
            
              if (vConteo = 0) then
                p_id_error := 214;
              end if;
            end if;
          end if;
        end if;
        -- Task 1205 (end)
      exception
        when others then
          p_id_error := '150';
      end;
    end if; -- IR-3 inactivo
  
    select max(error_des)
      into p_error_des
      from seg_error_t
     where id_error = to_char(p_id_error);
  end;
  -- --------------------------------------------------------------------------------------------------
  function aporte_empleado(p_rp      in number,
                           p_nss     in number,
                           p_periodo in number) return number is
    resultado number := 0;
    mConteo   integer;
    mAno      integer;
  begin
    mAno := substr(p_periodo, 1, 4);
    select count(*)
      into mConteo
      from sfc_equivalencias_ir13_t e
     where e.id_registro_patronal = p_rp
       and e.ano_fiscal = mAno
       and (e.id_nss_reportado = p_nss or e.id_nss_utilizado = p_nss);
    if (mConteo = 0) then
      insert into sfc_equivalencias_ir13_t
        (id_registro_patronal,
         ano_fiscal,
         id_nss_reportado,
         id_nss_utilizado,
         ult_usuario_act,
         ult_fecha_act)
      values
        (p_rp, mAno, p_nss, p_nss, 'SUIRPLUS', SYSDATE);
      commit;
    end if;
  
    begin
      select sum(nvl(d.aporte_afiliados_svds, 0) +
                 nvl(d.aporte_afiliados_sfs, 0) +
                 nvl(d.aporte_afiliados_t3, 0) +
                 nvl(d.aporte_afiliados_idss, 0) +
                 nvl(d.per_capita_adicional, 0) +
                 nvl(d.per_capita_fonamat, 0))
        into resultado
        from sfc_facturas_t f
        join sfc_det_facturas_t d
          on d.id_referencia = f.id_referencia
       where f.id_registro_patronal = p_rp
         and f.periodo_factura = p_periodo
         and f.id_tipo_factura <> 'U'
         and f.status NOT IN ('CA', 'RE')
         and d.id_nss in
             ( --buscar nss equivalentes
              select e2.id_nss_reportado
                from sfc_equivalencias_ir13_t e1
                join sfc_equivalencias_ir13_t e2
                  on e2.id_registro_patronal = e1.id_registro_patronal
                 and e2.ano_fiscal = e1.ano_fiscal
                 and e2.id_nss_utilizado = e1.id_nss_utilizado
               where e1.id_registro_patronal = p_rp
                 and e1.ano_fiscal = substr(p_periodo, 1, 4)
                 and e1.id_nss_reportado = p_nss); --buscar nss equivalentes
    exception
      when no_data_found then
        resultado := 0;
    end;
    return(resultado);
  end;
  -- --------------------------------------------------------------------------------------------------
  function isr_empleado(p_tipo     in varchar2,
                        p_per      in number,
                        p_meses    in number,
                        p_ingresos in number,
                        p_aportes  in number) return number is
    resultado  number := 0;
    v_ingresos number(18, 2);
    v_aportes  number(18, 2);
  begin
    v_ingresos := nvl(p_ingresos, 0);
    v_aportes  := nvl(p_aportes, 0);
    if (p_ingresos = 0) then
      resultado := 0;
    else
      begin
        if (p_tipo = 'N') then
          --buscar en los rangos de ISR de empleados normales
          select (r.impuesto_fijo / p_meses) +
                 ((v_ingresos - v_aportes - (r.rni_desde / p_meses)) *
                 r.porciento_excedente / 100)
            into resultado
            from suirplus.sfc_rangos_anuales_isr_new_t r
           where p_per between r.periodo_ini and r.periodo_fin
             and (v_ingresos - v_aportes) between (r.rni_desde / p_meses) and
                 (r.rni_hasta / p_meses);
        else
          --buscar en los rangos de ISR de empleados pensionados
          select (r.impuesto_fijo / p_meses) +
                 ((v_ingresos - v_aportes - (r.rni_desde / p_meses)) *
                 r.porciento_excedente / 100)
            into resultado
            from suirplus.sfc_rangos_anuales_isr_pen_t r
           where p_per between r.periodo_ini and r.periodo_fin
             and (v_ingresos - v_aportes) between (r.rni_desde / p_meses) and
                 (r.rni_hasta / p_meses);
        end if;
      exception
        when others then
          resultado := 0;
      end;
    end if;
    return(resultado);
  end;
  -- --------------------------------------------------------------------------------------------------
  function pre_validaciones return boolean as
    vConteo number(9);
    vResult boolean := true;
    vError  seg_error_t.id_error%type;
    vDesc   seg_error_t.error_des%type;
  begin
    dbms_output.put_line('pv1');
    h_RNC     := trim(substr(v_doc_header, 004, 011));
    h_PERIODO := substr(v_doc_header, 017, 004) ||
                 substr(v_doc_header, 015, 002);
    --trim(substr(v_doc_header,015,006));
  
    dbms_output.put_line('pv2');
    -- que sea un rnc o cedula valido
    select count(*)
      into vConteo
      from sre_empleadores_t
     where rnc_o_cedula = h_RNC
       and status = 'A';
  
    dbms_output.put_line('pv3');
    if vConteo = 0 then
      dbms_output.put_line('pv4');
      sre_envio_archivos_pkg.set_status('R', '150');
      vResult := False;
    else
      dbms_output.put_line('pv5');
    
      -- que el empleador tenga registros pagados para el periodo especificado
      validar_pagos(h_rnc,
                    substr(h_periodo, 5, 2) || substr(h_periodo, 1, 4),
                    vError,
                    vDesc);
    
      if (vError <> 0) then
        dbms_output.put_line('pv6');
        sre_envio_archivos_pkg.set_status('R', vError);
        vResult := False;
      else
        dbms_output.put_line('pv7');
        -- que sea un representante valido
        select count(*)
          into vConteo
          from seg_usuario_t u, sre_representantes_t r, sre_empleadores_t e
         where u.id_tipo_usuario = 2
           and u.id_usuario = v_usuario
           and r.id_nss = u.id_nss
           and e.id_registro_patronal = r.id_registro_patronal
           and e.rnc_o_cedula = h_RNC
           and e.status = 'A';
      
        if vConteo = 0 then
          dbms_output.put_line('pv8');
          sre_envio_archivos_pkg.set_status('R', '203');
          vResult := False;
        end if;
      end if;
    end if;
  
    dbms_output.put_line('pv9');
    return vResult;
  end;
  -- --------------------------------------------------------------------------------------------------
  procedure head_statement as
  begin
    update sre_archivos_t
       set id_rnc_cedula = trim(h_RNC)
     where id_recepcion = v_recepcion;
    commit;
  
    delete from sre_tmp_movimiento_t where id_recepcion = v_recepcion;
    commit;
  end;
  -- --------------------------------------------------------------------------------------------------
  procedure body_statement as
    v_filehandle  UTL_FILE.FILE_TYPE;
    v_linea       varchar2(2000);
    v_no          integer;
    v_pension     sre_tmp_movimiento_t.tipo_trabajador%type;
    v_tipo        sre_tmp_movimiento_t.tipo_documento%type;
    v_documento   sre_tmp_movimiento_t.no_documento%type;
    v_nombres     sre_tmp_movimiento_t.nombres%type;
    v_apellido1   sre_tmp_movimiento_t.primer_apellido%type;
    v_apellido2   sre_tmp_movimiento_t.segundo_apellido%type;
    v_sexo        sre_tmp_movimiento_t.sexo%type;
    v_nacimiento  sre_tmp_movimiento_t.fecha_nacimiento%type;
    v_salario_isr sre_tmp_movimiento_t.salario_isr%type;
    v_otras_remun sre_tmp_movimiento_t.otros_ingresos_isr%type;
    v_agente_ret  sre_tmp_movimiento_t.agente_retencion_isr%type;
    v_remun_otros sre_tmp_movimiento_t.remuneracion_isr_otros%type;
    v_ing_exentos sre_tmp_movimiento_t.ingresos_exentos_isr%type;
    v_saldo_favor sre_tmp_movimiento_t.saldo_favor_isr%type;
  
    mSegNss varchar2(25);
    mSegDoc varchar2(25);
    mNss    varchar2(25);
    mNss2   varchar2(25);
    mAno    integer;
    mRegPat integer;
    mConteo integer;
  begin
  
    -- abrir el archivo y recorrer cada una de sus lineas
    v_no         := 0;
    v_filehandle := UTL_FILE.FOPEN(c_file_inbox, v_filename, 'r');
    loop
      begin
        utl_file.get_line(v_filehandle, v_linea);
        if substr(v_linea, 1, 1) = 'D' then
          -- data parsing
          v_pension   := substr(v_linea, 2, 1);
          v_tipo      := substr(v_linea, 3, 1);
          v_documento := substr(v_linea, 4, 25);
          -- evaluar equivalencia de nss-------------------------------------------------------------
          if v_documento like '%=%' then
            dbms_output.put_line('-------------------------------------------------------');
            mSegDoc := trim(substr(v_documento,
                                   1,
                                   instr(v_documento, '=') - 1));
            mSegNss := trim(substr(v_documento,
                                   instr(v_documento, '=') + 1,
                                   99));
          
            dbms_output.put_line('v_documento:' || v_documento);
            dbms_output.put_line('mSegDoc:' || mSegDoc);
            dbms_output.put_line('mSegNss:' || mSegNss);
            -- ver si ex un numero: nss
            begin
              mNss := to_number(mSegNss);
            exception
              when others then
                mNss := null;
            end;
            dbms_output.put_line('mNss:' || mNss);
          
            -- ver si ex un numero: año
            begin
              mAno := to_number(substr(h_PERIODO, 1, 4));
            exception
              when others then
                mAno := null;
            end;
            dbms_output.put_line('mAno:' || mAno);
          
            if (mNss is not null and mano is not null) then
              dbms_output.put_line('>1');
              -- ver si existe y no es él mismo
              select count(*)
                into mConteo
                from sre_ciudadanos_t
               where id_nss = mNss
                 and no_documento <> upper(mSegDoc);
              dbms_output.put_line('mConteo:' || mConteo);
            
              if (mConteo = 1) then
                dbms_output.put_line('>2');
                -- el nss equivalente existe, insertarlo
                begin
                  select id_registro_patronal
                    into mRegPat
                    from sre_empleadores_t
                   where rnc_o_cedula = h_RNC;
                exception
                  when others then
                    mRegPat := null;
                end;
                dbms_output.put_line('mRegPat:' || mRegPat);
              
                select id_nss
                  into mNss2
                  from suirplus.sre_ciudadanos_t
                 where tipo_documento = v_tipo
                   and no_documento = upper(mSegDoc);
                dbms_output.put_line('mNss2:' || mNss2);
              
                if (mRegPat is not null) then
                  dbms_output.put_line('mRegPat:' || mRegPat);
                  dbms_output.put_line('mAno:' || mAno);
                  dbms_output.put_line('mNss:' || mNss);
                  dbms_output.put_line('mNss2:' || mNss2);
                  dbms_output.put_line('v_usuario:' || v_usuario);
                  insertar_equivalencia(mRegPat,
                                        mAno,
                                        mNss,
                                        mNss2,
                                        v_usuario);
                end if;
              end if;
            end if;
            v_documento := rpad(mSegDoc, 25, ' ');
            dbms_output.put_line('-------------------------------------------------------');
          end if;
          -- lo dejamos solo con la cedula que enviaron ---------------------------------------------
          v_nombres     := substr(v_linea, 29, 50);
          v_apellido1   := substr(v_linea, 79, 40);
          v_apellido2   := substr(v_linea, 119, 40);
          v_sexo        := substr(v_linea, 159, 1);
          v_nacimiento  := substr(v_linea, 160, 8);
          v_salario_isr := substr(v_linea, 168, 16);
          v_otras_remun := substr(v_linea, 184, 16);
          v_agente_ret  := substr(v_linea, 200, 11);
          v_remun_otros := substr(v_linea, 211, 16);
          v_ing_exentos := substr(v_linea, 227, 16);
          v_saldo_favor := substr(v_linea, 243, 16);
          v_no          := v_no + 1;
        
          insert into sre_tmp_movimiento_t
            (ID_RECEPCION,
             SECUENCIA_MOVIMIENTO,
             STATUS,
             ULT_FECHA_ACT,
             ULT_USUARIO_ACT,
             PERIODO_APLICACION,
             FECHA_REGISTRO,
             TIPO_trabajador,
             TIPO_DOCUMENTO,
             NO_DOCUMENTO,
             NOMBRES,
             PRIMER_APELLIDO,
             SEGUNDO_APELLIDO,
             FECHA_NACIMIENTO,
             SEXO,
             SALARIO_ISR,
             AGENTE_RETENCION_ISR,
             REMUNERACION_ISR_OTROS,
             OTROS_INGRESOS_ISR,
             SALDO_FAVOR_ISR,
             INGRESOS_EXENTOS_ISR)
          values
            (v_recepcion,
             v_no,
             'N',
             sysdate,
             trim(v_usuario),
             trim(h_PERIODO),
             trunc(sysdate),
             trim(v_pension),
             trim(v_tipo),
             trim(v_documento),
             trim(v_nombres),
             trim(v_apellido1),
             trim(v_apellido2),
             trim(v_nacimiento),
             trim(v_sexo),
             trim(v_salario_isr),
             trim(v_agente_ret),
             trim(v_remun_otros),
             trim(v_otras_remun),
             trim(v_saldo_favor),
             trim(v_ing_exentos));
          commit;
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
  begin
    procesar_registros(v_recepcion);
  exception
    when others then
      mailme('2)ORA-' || sqlcode, sqlerrm);
      sre_envio_archivos_pkg.set_status('R', '650');
  end;
  -- --------------------------------------------------------------------------------------------------
  procedure procesar_registros(p_recepcion in number) is
    vConteo integer;
    vSts    sre_tmp_movimiento_t.status%type;
    vErr    integer;
    vPer    sre_tmp_movimiento_t.periodo_aplicacion%type;
    vAno    number(4);
    vRP     sre_empleadores_t.id_registro_patronal%type;
    vNSS    sre_ciudadanos_t.id_nss%type;
    vDesde  integer;
    vHasta  integer;
  
    vErrores number(18) := 0;
    vOK      number(18) := 0;
  
    v_ot_isr_otros          sre_det_movimiento_t.ot_retencion_isr%type;
    v_ot_otros_ingresos_isr sre_det_movimiento_t.ot_retencion_isr%type;
    v_ot_salario_isr        sre_det_movimiento_t.ot_retencion_isr%type;
    v_ot_retencion_isr      sre_det_movimiento_t.ot_retencion_isr%type;
    v_ot_retencion_ss       sre_det_movimiento_t.ot_retencion_ss%type;
    v_ot_saldo_compensado   sre_det_movimiento_t.ot_retencion_ss%type;
    v_rp_agente_unico_ret   sre_det_movimiento_t.agente_retencion_isr%type;
  
    v_maestro       char(1) := 'N';
    v_linea         sre_det_movimiento_t.id_linea%type;
    v_movimiento    sre_movimiento_t.id_movimiento%type;
    v_usuario_carga sre_movimiento_t.ult_usuario_act%type; -- Usuario que realiza la carga
  
    -- ---------------------------------------------------------
    function validar_monto(texto varchar2) return number is
      r number;
    begin
      r := to_number(nvl(texto, '0.00'));
      if (r > 999999999.99) then
        return(null);
      end if;
      return(r);
    exception
      when others then
        return(null);
    end;
  
    -- ---------------------------------------------------------
    procedure verificar_trabajador is
      -- ver si existe como trabajador de ese empleador, si no, crearlo de BAJA en nomina 1.
    begin
      -- ver si existe como trabajador de ese empleador
      select count(*)
        into vConteo
        from sre_trabajadores_t t
       where t.id_registro_patronal = vRP
         and t.id_nss = vNSS;
    
      if (vConteo = 0) then
        -- si no existe en ninguna nomina, lo inserta DE BAJA en la nomina 1 (principal) para dicho periodo
        insert into sre_trabajadores_t
          (id_registro_patronal,
           id_nomina,
           id_nss,
           fecha_ingreso,
           fecha_salida,
           salario_ss,
           status,
           salario_isr,
           fecha_ult_reintegro,
           aporte_voluntario,
           fecha_registro,
           ult_usuario_act,
           ult_fecha_act,
           saldo_favor_disponible,
           aporte_afiliados_t3,
           aporte_empleador_t3)
        values
          (vRP,
           1,
           vNSS,
           to_date(vper || '01', 'yyyymmdd'),
           add_months(to_date(vper || '01', 'yyyymmdd'), 1) - 1,
           0,
           'B',
           v_ot_salario_isr,
           null,
           0,
           to_date(vper || '01', 'yyyymmdd'),
           v_usuario_carga, -- Usuario que realiza la carga
           sysdate,
           0,
           0,
           0);
        commit;
      end if;
    end;
  
    -- ---------------------------------------------------------
    function validar_fecha(texto varchar2) return date is
      r date;
    begin
      if trim(nvl(texto, 'algo')) is not null then
        r := to_date(texto, 'ddmmyyyy');
      end if;
      return(r);
    exception
      when others then
        return(null);
    end;
  
  begin
    for archivo in (select *
                      from sre_archivos_t a
                     where a.id_recepcion = p_recepcion) loop
      --obtener el periodo del detalle (siempre será el mismo para un archivo)
      select max(periodo_aplicacion)
        into vPer
        from sre_tmp_movimiento_t
       where id_recepcion = p_recepcion;
    
      vAno   := substr(vPer, 1, 4);
      vDesde := to_number(vAno || '01');
      vHasta := to_number(vAno || '12');
    
      --obtener el Registro_Patronal
      select id_registro_patronal
        into vRp
        from sre_empleadores_t
       where rnc_o_cedula = archivo.id_rnc_cedula;
    
      v_usuario_carga := archivo.usuario_carga; -- Usuario que realiza la carga
      v_movimiento    := 0; -- Inicializar el ID Movimiento a cero
    
      for detalle in (select *
                        from sre_tmp_movimiento_t
                       where id_recepcion = p_recepcion) loop
      
        --Les quito los espacios en blanco y lo convierto a mayuscula sobre el mismo cursor
        detalle.tipo_documento := upper(trim(detalle.tipo_documento));
        detalle.no_documento   := upper(trim(detalle.no_documento));
      
        vSts := 'P';
        vErr := 0;
        -- validar todo el registro
        begin
          -- que no envien dos o mas veces el mismo registro
          select count(*)
            into vConteo
            from sre_tmp_movimiento_t d
           where d.id_recepcion = detalle.id_recepcion
             and upper(trim(d.tipo_documento)) = detalle.tipo_documento
             and upper(trim(d.no_documento)) = detalle.no_documento;
          if (vConteo > 1) then
            vSts := 'R';
            vErr := '422';
            goto fin_validaciones;
          end if;
          -- validar tipo_documento
          if (detalle.tipo_documento not in ('C', 'N', 'P')) then
            vSts := 'R';
            vErr := '101';
            goto fin_validaciones;
          end if;
          -- validar no_documento
          if (detalle.no_documento is null) then
            vSts := 'R';
            vErr := '104';
            goto fin_validaciones;
          elsif (detalle.tipo_documento = 'P' and
                length(detalle.no_documento) in (9, 11)) then
            -- Buscamos un cedulado con este numero de documento, si existe rechazamos el registro
            select count(*)
              into vConteo
              from sre_ciudadanos_t c
             where c.tipo_documento = 'C'
               and c.no_documento = detalle.no_documento;
          
            if (vConteo > 0) then
              vSts := 'R';
              vErr := '609';
              goto fin_validaciones;
              /*
                          else
                            -- si es un pasaporte de 9 u 11 y no existe, rechazarlo
                            select count(*)
                              into vConteo
                              from sre_ciudadanos_t c
                             where c.tipo_documento = 'P'
                               and c.no_documento = detalle.no_documento;
              
                            if (vConteo = 0) then
                              vSts := 'R';
                              vErr := '61';
                            end if;
              */
            end if;
          elsif (detalle.tipo_documento in ('C', 'N')) then
            select count(*)
              into vConteo
              from sre_ciudadanos_t
             where tipo_documento = detalle.tipo_documento
               and no_documento = detalle.no_documento;
            if (vConteo = 0) then
              vSts := 'R';
              vErr := '104';
              goto fin_validaciones;
            end if;
          end if;
          -- validar nombres
          if (detalle.tipo_documento = 'P') and (detalle.nombres is null) then
            vSts := 'R';
            vErr := '105';
            goto fin_validaciones;
          end if;
          -- validar apellido1
          if (detalle.tipo_documento = 'P') and
             (detalle.primer_apellido is null) then
            vSts := 'R';
            vErr := '106';
            goto fin_validaciones;
          end if;
          -- validar sexo
          if (detalle.tipo_documento = 'P') and
             (detalle.sexo is not null and
             detalle.sexo not in ('M', 'F', '', ' ')) then
            vSts := 'R';
            vErr := '107';
            goto fin_validaciones;
          end if;
          -- validar nacimiento
          if (detalle.tipo_documento = 'P') and
             (validar_fecha(detalle.fecha_nacimiento) is null) then
            vSts := 'R';
            vErr := '108';
            goto fin_validaciones;
          end if;
          --que el agente de retencion exista
          if (detalle.agente_retencion_isr is not null and
             trim(detalle.agente_retencion_isr) <> archivo.id_rnc_cedula) then
            select count(*)
              into vConteo
              from sre_empleadores_t
             where rnc_o_cedula = trim(detalle.agente_retencion_isr);
            if (vConteo = 0) then
              vSts := 'R';
              vErr := '161';
              goto fin_validaciones;
            end if;
          end if;
          -- validar salario isr
          if validar_monto(detalle.salario_isr) is null then
            vSts := 'R';
            vErr := '158';
            goto fin_validaciones;
          end if;
          -- validar otras_renum
          if validar_monto(detalle.otros_ingresos_isr) is null then
            vSts := 'R';
            vErr := '159';
            goto fin_validaciones;
          end if;
          -- validar renum otros empleadores
          if validar_monto(detalle.remuneracion_isr_otros) is null then
            vSts := 'R';
            vErr := '160';
            goto fin_validaciones;
          end if;
          -- validar ingresos exentos
          if validar_monto(detalle.ingresos_exentos_isr) is null then
            vSts := 'R';
            vErr := '176';
            goto fin_validaciones;
          end if;
          -- validar ingresos saldo favor isr
          if validar_monto(detalle.saldo_favor_isr) is null then
            vSts := 'R';
            vErr := '177';
            goto fin_validaciones;
          end if;
          -- validar tipo de trabajador
          if detalle.tipo_trabajador not in ('N', 'P') then
            vSts := 'R';
            vErr := '109';
            goto fin_validaciones;
          end if;
        
          if vPer >= h_periodo_rectificativa then
            -- Solo ejecutar si es IR-3 (mensual)
            begin
              -- obtener el nss
              select id_nss
                into vNss
                from sre_ciudadanos_t
               where tipo_documento = detalle.tipo_documento
                 and no_documento = detalle.no_documento;
            
              -- Obtener aporte del empleado
              v_ot_retencion_ss := nvl(aporte_empleado(vRP, vNss, vPer), 0);
            
              -- obtener salarios reportados
              select sum(nvl(d.REMUNERACION_ISR_OTROS, 0)),
                     sum(nvl(d.OTROS_INGRESOS_ISR, 0)),
                     sum(nvl(d.SALARIO_ISR, 0)),
                     sum(nvl(d.isr, 0)),
                     sum(nvl(d.saldo_compensado, 0))
                into v_ot_isr_otros,
                     v_ot_otros_ingresos_isr,
                     v_ot_salario_isr,
                     v_ot_retencion_isr,
                     v_ot_saldo_compensado
                from SFC_DET_LIQUIDACION_ISR_T d
               where d.id_referencia_isr in
                     (select max(h.id_referencia_isr) -- Ultima Liquidacion Pagada
                        from SFC_LIQUIDACION_ISR_T     h,
                             SFC_DET_LIQUIDACION_ISR_T d
                       where h.id_registro_patronal = vRP
                         and h.periodo_liquidacion = vPer
                         and h.status in ('PA', 'EX')
                         and h.id_tipo_factura <> 'T' -- Que este PAgada o EXenta.
                         and d.id_referencia_isr = h.id_referencia_isr
                         and d.id_nss = vNss)
                 and d.id_nss = vNss;
            
              -- obtener impuestos pagados RJ 17/03/2010
              select sum(nvl(d.isr, 0))
                into v_ot_retencion_isr
                from SFC_DET_LIQUIDACION_ISR_T d
               where d.id_referencia_isr in
                     (select h.id_referencia_isr
                        from SFC_LIQUIDACION_ISR_T     h,
                             SFC_DET_LIQUIDACION_ISR_T d
                       where h.id_registro_patronal = vRP
                         and h.periodo_liquidacion = vPer
                         and h.status in ('PA', 'EX')
                         and d.id_referencia_isr = h.id_referencia_isr
                         and d.id_nss = vNss)
                 and d.id_nss = vNss;
            exception
              when no_data_found then
                v_ot_isr_otros          := 0;
                v_ot_otros_ingresos_isr := 0;
                v_ot_salario_isr        := 0;
                v_ot_retencion_isr      := 0;
                v_ot_saldo_compensado   := 0;
            end;
            v_ot_isr_otros          := nvl(v_ot_isr_otros, 0);
            v_ot_otros_ingresos_isr := nvl(v_ot_otros_ingresos_isr, 0);
            v_ot_salario_isr        := nvl(v_ot_salario_isr, 0);
            v_ot_retencion_isr      := nvl(v_ot_retencion_isr, 0);
            v_ot_saldo_compensado   := nvl(v_ot_saldo_compensado, 0);
          end if;
        exception
          when others then
            mailme(detalle.no_documento, sqlerrm);
            vSts := 'R';
            vErr := '650';
            goto fin_validaciones;
        end;
      
        <<fin_validaciones>>
        begin
          if (vSts = 'R') then
            --alguna validacion no se cumplió
            update sre_tmp_movimiento_t c
               set c.status = vSts, c.id_error = vErr
             where c.id_recepcion = detalle.id_recepcion
               and c.secuencia_movimiento = detalle.secuencia_movimiento;
            commit;
            vErrores := vErrores + 1;
          else
            -- Actualizar registro temporal de movimiento como procesado.
            update sre_tmp_movimiento_t c
               set c.status = 'P', id_error = '000'
             where c.id_recepcion = detalle.id_recepcion
               and c.secuencia_movimiento = detalle.secuencia_movimiento;
            commit;
            vOK := vOK + 1;
          
            --si es un pasaporte y no existe, crearlo
            if (detalle.Tipo_Documento in ('P')) then
              select count(*)
                into vConteo
                from sre_ciudadanos_t
               where tipo_documento = detalle.tipo_documento
                 and no_documento = detalle.no_documento;
              if (vConteo = 0) then
                insert into sre_ciudadanos_t
                  (NOMBRES,
                   PRIMER_APELLIDO,
                   SEGUNDO_APELLIDO,
                   FECHA_NACIMIENTO,
                   NO_DOCUMENTO,
                   TIPO_DOCUMENTO,
                   SEXO,
                   FECHA_REGISTRO,
                   STATUS,
                   ULT_FECHA_ACT,
                   ULT_USUARIO_ACT)
                values
                  (detalle.nombres,
                   detalle.primer_apellido,
                   detalle.segundo_apellido,
                   to_date(detalle.fecha_nacimiento, 'ddmmyyyy'),
                   detalle.no_documento,
                   detalle.tipo_documento,
                   detalle.sexo,
                   sysdate,
                   'I',
                   archivo.ult_fecha_act,
                   archivo.usuario_carga -- Usuario que realiza la carga
                   );
                commit;
              end if;
            end if;
          
            -- obtener el nss
            select id_nss
              into vNss
              from sre_ciudadanos_t
             where tipo_documento = detalle.tipo_documento
               and no_documento = detalle.no_documento;
          
            if vPer >= h_periodo_rectificativa then
              -- Solo ejecutar si es IR-3 (mensual)
              verificar_trabajador; -- Verificar si el trabajador existe(crearlo si es necesario).
            
              -- grabar registros maestro/detalle de movimiento.
              if (v_maestro = 'N') then
              
                -- buscar el siguiente nro de movimiento
                select sre_movimientos_seq.NEXTVAL
                  into v_movimiento
                  from dual;
              
                sre_envio_archivos_pkg.log_anotar('Mov#' ||
                                                  to_char(v_movimiento));
              
                -- insertar solo una vez el registro maestro del movimiento
                insert into sre_movimiento_t
                  (id_movimiento,
                   id_registro_patronal,
                   id_usuario,
                   id_tipo_movimiento,
                   status,
                   fecha_registro,
                   periodo_factura,
                   ult_fecha_act,
                   ult_usuario_act,
                   id_recepcion)
                values
                  (v_movimiento,
                   vRP,
                   archivo.usuario_carga, -- Usuario que realiza la carga
                   archivo.id_tipo_movimiento,
                   'N',
                   archivo.fecha_carga,
                   vper,
                   sysdate,
                   archivo.ult_usuario_act,
                   p_recepcion);
                commit;
              
                v_maestro := 'S';
                v_linea   := 1;
              end if;
            
              begin
                select id_registro_patronal
                  into v_rp_agente_unico_ret
                  from sre_empleadores_t
                 where rnc_o_cedula =
                       nvl(detalle.agente_retencion_isr, '~');
              exception
                when others then
                  v_rp_agente_unico_ret := null;
              end;
            
              -- insertar el registro de detalle del movimiento
              insert into sre_det_movimiento_t
                (id_movimiento,
                 id_linea,
                 agente_retencion_ss,
                 agente_retencion_isr,
                 id_nss,
                 id_nss_dependiente,
                 id_error,
                 id_tipo_novedad,
                 id_nomina,
                 periodo_aplicacion,
                 fecha_inicio,
                 fecha_fin,
                 afiliado_idss,
                 aporte_empleador_t3,
                 remuneracion_isr_otros,
                 remuneracion_ss_otros,
                 retencion_unico_isr,
                 retencion_unico_ss,
                 salario_isr,
                 salario_ss,
                 aporte_voluntario,
                 saldo_favor_isr,
                 saldo_favor_ss,
                 otros_ingresos_isr,
                 tipo_contratado,
                 pa_salario_ss,
                 pa_aporte_voluntario,
                 ingresos_exentos_isr,
                 ult_fecha_act,
                 ult_usuario_act,
                 ot_retencion_ss,
                 ot_retencion_isr,
                 aporte_afiliados_t3 --temporalmente, luego se creara y usara el campo ot_saldo_compensado
                 )
              values
                (v_movimiento,
                 v_linea,
                 null,
                 v_rp_agente_unico_ret,
                 vnss,
                 null,
                 '0',
                 archivo.id_tipo_movimiento,
                 1, -- Nomina 1 por default.  Estos es Obligatorio.
                 vper,
                 to_date(vper || '01', 'yyyymmdd'),
                 add_months(to_date(vper || '01', 'yyyymmdd'), 1) - 1,
                 'N',
                 0,
                 nvl(detalle.remuneracion_isr_otros, 0), -- remuneracion_isr_otros
                 0,
                 'N',
                 'N',
                 detalle.salario_isr, -- salario_isr
                 0,
                 0,
                 detalle.saldo_favor_isr, -- Saldo a Favor ISR
                 0,
                 detalle.otros_ingresos_isr, -- otros_ingresos_isr
                 detalle.tipo_trabajador, -- normal o pensionado
                 0,
                 0,
                 detalle.ingresos_exentos_isr, -- Exentos ISR
                 sysdate,
                 archivo.ult_usuario_act,
                 v_ot_retencion_ss,
                 v_ot_retencion_isr,
                 v_ot_saldo_compensado);
              commit;
            
              v_linea := v_linea + 1;
            end if;
          end if; -- if (vSts='R') then
        exception
          when others then
            mailme(detalle.secuencia_movimiento, sqlerrm);
            update sre_tmp_movimiento_t c
               set c.status = 'R', id_error = '650'
             where c.id_recepcion = detalle.id_recepcion
               and c.secuencia_movimiento = detalle.secuencia_movimiento;
            commit;
        end;
      end loop; -- Loop Detalle
    
      if (vErrores = 0) then
        --marcar el archivo como procesado
        update sre_archivos_t a
           set a.status        = 'P',
               a.id_error      = 000,
               a.registros_ok  = vOK,
               a.registros_bad = vErrores
         where a.id_recepcion = p_recepcion;
        commit;
      else
        update sre_archivos_t a
           set a.status        = 'P',
               id_error        = 250,
               a.registros_ok  = vOK,
               a.registros_bad = vErrores
         where a.id_recepcion = p_recepcion;
        commit;
      end if;
    
      if (vPer >= h_periodo_rectificativa) and (v_movimiento > 0) then
        -- Manda a aplicar el movimiento
        suirplus.sre_load_movimiento_pkg.poner_en_cola(v_movimiento);
      end if;
    end loop;
    commit;
  end;
  -- --------------------------------------------------------------------------------------------------
  procedure declaracion_regular(p_ano          in number,
                                p_rnc          in varchar2,
                                p_usr          in varchar2,
                                p_resultnumber out number) is
    vConteo         number(9);
    vPaEx           number(9);
    vVencidas       number(9);
    vTodas          number(9);
    vStatus         char(1);
    vDeclaradoOtros number(18, 2);
    vTipoNomina     char(1);
    vAportes        number(18, 2);
  
    mDeclaracionFinal integer;
    mStatus           char(1);
  
    mSalarioIsr           number(18, 2);
    mOtrosIngresosIsr     number(18, 2);
    mRemuneracionIsrOtros number(18, 2);
    mIngresosExentosIsr   number(18, 2);
    mSaldoFavorPeriodo    number(18, 2);
    vIsrEmp               number(18, 2);
    vSaldoCompensado      number(18, 2);
    vPorCompensar         number(18, 2);
    vSALDO_FAVOR_ANTERIOR number(18, 2);
    vISR_LIQUIDADO        number(18, 2);
    vFormula              number(18, 2);
    vSALDO_FAVOR_EMPLEADO number(18, 2);
    vSALDO_FAVOR_DGII     number(18, 2);
  
    procedure esperar(p_rp number) is
    begin
      -- ver el status del empleador
      select status
        into mStatus
        from sfc_resumen_ir13_t x
       where x.id_registro_patronal = p_rp
         and x.ano_fiscal = p_Ano;
    
      /*
            while (mStatus is not null)
            loop
              -- esperar un numero random de segundos
              dbms_lock.sleep(trunc(dbms_random.value(15,45)));
      
              -- vuelve a mirar el status
              select status into mStatus
              from sfc_resumen_ir13_t x
              where x.id_registro_patronal=p_rp
              and x.ano_fiscal=p_Ano;
            end loop;
      
            -- ya no esta null (otro termino lo que estaba haciendo
            update sfc_resumen_ir13_t x
            set x.status = 'E'
            where x.id_registro_patronal=p_rp
            and x.ano_fiscal=p_Ano;
            commit;
      */
    end;
  begin
/* Comentada por Task #10995
    --empleadores que no aparescan en la tabla de pagos de la dgii (rectificados)
    for empleadores in (select id_registro_patronal, rnc_o_cedula
                          from sre_empleadores_t a
                         where rnc_o_cedula = p_rnc
                           and not exists
                         (select 1
                                  from suirplus.sfc_resumen_ir13_T r
                                 WHERE r.id_registro_patronal =
                                       a.id_registro_patronal
                                   and r.ano_fiscal = p_ano
                                   and nvl(r.status, '~') in ('P', 'A'))) loop
      begin
        -- ver si no existe el registro resumen
        select count(*), max(status)
          into vConteo, mStatus
          from sfc_resumen_ir13_t x
         where x.id_registro_patronal = empleadores.id_registro_patronal
           and x.ano_fiscal = p_Ano;
      
        if (vConteo = 0) then
          -- si no existe insertarlo
          begin
            insert into sfc_resumen_ir13_t
              (ID_REGISTRO_PATRONAL, ANO_FISCAL, TIPO_DECLARACION, STATUS)
            values
              (empleadores.ID_REGISTRO_PATRONAL, p_ano, 'N', 'E');
            commit;
          exception
            when others then
              esperar(empleadores.id_registro_patronal);
          end;
        else
          -- si existe y esta en proceso, esperar que termine
          esperar(empleadores.id_registro_patronal);
        end if;
      
        -- si se definieron equivalencias  borrar todos los meses que se hayan calculado
        delete from sfc_det_resumen_ir13_t
         where id_registro_patronal = empleadores.id_registro_patronal
           and ano_fiscal = p_Ano;
        commit;
      
        delete from sfc_saldos_favor_t
         where id_registro_patronal = empleadores.id_registro_patronal
           and ano_fiscal = p_Ano;
        commit;
      
        for periodos in (select p_ano || '01' periodo
                           from dual
                         union all
                         select p_ano || '02' periodo
                           from dual
                         union all
                         select p_ano || '03' periodo
                           from dual
                         union all
                         select p_ano || '04' periodo
                           from dual
                         union all
                         select p_ano || '05' periodo
                           from dual
                         union all
                         select p_ano || '06' periodo
                           from dual
                         union all
                         select p_ano || '07' periodo
                           from dual
                         union all
                         select p_ano || '08' periodo
                           from dual
                         union all
                         select p_ano || '09' periodo
                           from dual
                         union all
                         select p_ano || '10' periodo
                           from dual
                         union all
                         select p_ano || '11' periodo
                           from dual
                         union all
                         select p_ano || '12' periodo from dual order by 1) loop
          -- prioridad 1: lo que diga una declaracion final:
          select count(*), max(id_recepcion)
            into vConteo, mDeclaracionFinal
            from sre_archivos_t a
           where a.id_tipo_movimiento = 'DF'
             and a.id_rnc_cedula = p_rnc
             and a.status = 'P'
             and a.registros_ok > 0
             and exists
           (select 1
                    from sre_tmp_movimiento_t d
                   where d.id_recepcion = a.id_recepcion
                     and d.status = 'P'
                     and d.id_error = '000'
                     and d.periodo_aplicacion = periodos.periodo);
        
          if (vConteo > 0) then
            -- ==========================================================================================
            -- hay una declaracion final, insertar cada uno de los trabajadores
            for trabajadores in (select c.id_nss,
                                        x.ID_RECEPCION,
                                        x.PERIODO_APLICACION,
                                        x.TIPO_trabajador,
                                        to_number(nvl(x.SALARIO_ISR, '0')) salario_isr,
                                        to_number(nvl(x.AGENTE_RETENCION_ISR,
                                                      '0')) agente_retencion_isr,
                                        to_number(nvl(x.REMUNERACION_ISR_OTROS,
                                                      '0')) remuneracion_isr_otros,
                                        to_number(nvl(x.OTROS_INGRESOS_ISR,
                                                      '0')) otros_ingresos_isr,
                                        to_number(nvl(x.SALDO_FAVOR_ISR, '0')) saldo_favor_isr,
                                        to_number(nvl(x.INGRESOS_EXENTOS_ISR,
                                                      '0')) ingresos_exentos_isr
                                   from sre_tmp_movimiento_t x
                                   join sre_ciudadanos_t c
                                     on c.tipo_documento = x.tipo_documento
                                    and c.no_documento = x.no_documento
                                  where x.id_recepcion = mDeclaracionFinal
                                    and x.status = 'P'
                                    and x.id_error = '000') loop
              -- insertar el trabajador como su mismo equivalente
              insertar_equivalencia(empleadores.id_registro_patronal,
                                    p_ano,
                                    trabajadores.id_nss,
                                    p_usr);
            
              -- buscar los aportes reportados en otros RNC (no les cobrara ISR en este empleador)
              if (trabajadores.agente_retencion_isr not in
                 ('0', empleadores.rnc_o_cedula)) then
                vDeclaradoOtros := nvl(trabajadores.salario_isr, 0) +
                                   nvl(trabajadores.otros_ingresos_isr, 0) +
                                   nvl(trabajadores.remuneracion_isr_otros,
                                       0);
              else
                vDeclaradoOtros := 0;
              end if;
              vDeclaradoOtros := nvl(vDeclaradoOtros, 0);
            
              -- obtener el aporte de las facturas, no de las liquidaciones
              vAportes := nvl(aporte_empleado(p_rp      => empleadores.id_registro_patronal,
                                              p_nss     => trabajadores.id_nss,
                                              p_periodo => periodos.periodo),
                              0);
            
              vIsrEmp := nvl(isr_empleado(p_tipo     => trabajadores.tipo_trabajador,
                                          p_per      => periodos.periodo,
                                          p_meses    => 12,
                                          p_ingresos => trabajadores.salario_isr +
                                                        trabajadores.otros_ingresos_isr +
                                                        trabajadores.remuneracion_isr_otros -
                                                        vDeclaradoOtros,
                                          p_aportes  => vAportes),
                             0);
            
              if trabajadores.saldo_favor_isr >= vIsrEmp then
                vSaldoCompensado := vIsrEmp;
              else
                vSaldoCompensado := trabajadores.saldo_favor_isr;
              end if;
            
              -- insertarlo en status P - ya fue declarado finalmente
              insert into sfc_det_resumen_ir13_t
                (id_registro_patronal,
                 ano_fiscal,
                 id_nss,
                 periodo,
                 salario_isr,
                 otros_ingresos_isr,
                 remuneracion_isr_otros,
                 ingresos_exentos_isr,
                 retencion_ss,
                 isr,
                 saldo_favor_del_periodo,
                 saldo_compensado,
                 saldo_por_compensar,
                 status,
                 tipo_trabajador,
                 ing_reportado_en_otros)
              values
                (empleadores.id_registro_patronal,
                 p_ano,
                 trabajadores.id_nss,
                 periodos.periodo,
                 trabajadores.salario_isr,
                 trabajadores.otros_ingresos_isr,
                 trabajadores.remuneracion_isr_otros,
                 trabajadores.ingresos_exentos_isr,
                 vAportes,
                 vIsrEmp,
                 trabajadores.saldo_favor_isr,
                 vSaldoCompensado,
                 trabajadores.saldo_favor_isr - vSaldoCompensado,
                 'P',
                 trabajadores.tipo_trabajador,
                 vDeclaradoOtros);
              commit;
            end loop;
            -- ==========================================================================================
          else
            -- ==========================================================================================
            --contar las liquidaciones en sus distintos estados
            select sum(case
                         when status in ('PA', 'EX', 'AP') then
                          1
                         else
                          0
                       end),
                   sum(case
                         when status = 'VE' and id_tipo_factura <> 'T' then
                          1
                         else
                          0
                       end),
                   count(*)
              into vPaEx, vVencidas, vTodas
              from sfc_liquidacion_isr_t f
             where f.id_registro_patronal =
                   empleadores.id_registro_patronal
               and f.periodo_liquidacion = periodos.periodo
               and f.status <> 'CA';
          
            -- ver si todas estan PA o EX
            if (vVencidas > 0) then
              vStatus := 'V';
            elsif (vTodas = vPaEx) then
              vStatus := 'P';
            else
              vStatus := null;
            end if;
          
            -- insertar el trabajador como su mismo equivalente
            for trabajadores in (select distinct d.id_nss
                                   from sfc_liquidacion_isr_t f
                                   join sfc_det_liquidacion_isr_t d
                                     on d.id_referencia_isr =
                                        f.id_referencia_isr
                                  where f.id_registro_patronal =
                                        empleadores.id_registro_patronal
                                    and f.periodo_liquidacion =
                                        periodos.periodo
                                    and f.status <> 'CA') loop
              insertar_equivalencia(empleadores.id_registro_patronal,
                                    p_ano,
                                    trabajadores.id_nss,
                                    p_usr);
            end loop;
          
            for trabajadores in (select e2.id_nss_utilizado id_nss,
                                        max(d.id_referencia_isr) ultima_liquidacion,
                                        sum(d.isr) total_isr,
                                        sum(d.saldo_compensado) total_compensado
                                   from sfc_liquidacion_isr_t f
                                   join sfc_det_liquidacion_isr_t d
                                     on d.id_referencia_isr =
                                        f.id_referencia_isr
                                 --buscar nss equivalentes
                                   join sfc_equivalencias_ir13_t e1
                                     on e1.id_registro_patronal =
                                        f.id_registro_patronal
                                    and e1.ano_fiscal = p_ano
                                    and e1.id_nss_reportado = d.id_nss
                                   join sfc_equivalencias_ir13_t e2
                                     on e2.id_registro_patronal =
                                        e1.id_registro_patronal
                                    and e2.ano_fiscal = e1.ano_fiscal
                                    and e2.id_nss_utilizado =
                                        e1.id_nss_utilizado
                                 --buscar nss equivalentes
                                  where f.id_registro_patronal =
                                        empleadores.id_registro_patronal
                                    and f.periodo_liquidacion =
                                        periodos.periodo
                                    and f.status in ('PA', 'EX') -- decia = PA
                                  group by e2.id_nss_utilizado) loop
              -- obtener el aporte de las facturas, no de las liquidaciones
              vAportes := nvl(aporte_empleado(empleadores.id_registro_patronal,
                                              trabajadores.id_nss,
                                              periodos.periodo),
                              0);
            
              -- buscar los aportes reportados en otros RNC (no les cobrara ISR en este empleador)
              begin
                select sum(nvl(d.salario_isr, 0) +
                           nvl(d.otros_ingresos_isr, 0))
                  into vDeclaradoOtros
                  from sfc_liquidacion_isr_t f
                  join sfc_det_liquidacion_isr_t d
                    on d.id_referencia_isr = f.id_referencia_isr
                   and d.id_nss in
                       ( --buscar nss equivalentes
                        select e2.id_nss_reportado
                          from sfc_equivalencias_ir13_t e1
                          join sfc_equivalencias_ir13_t e2
                            on e2.id_registro_patronal =
                               e1.id_registro_patronal
                           and e2.ano_fiscal = e1.ano_fiscal
                           and e2.id_nss_utilizado = e1.id_nss_utilizado
                         where e1.id_registro_patronal =
                               empleadores.id_registro_patronal
                           and e1.ano_fiscal = p_ano
                           and e1.id_nss_reportado = trabajadores.id_nss) --buscar nss equivalentes
                   and d.agente_retencion_isr is not null
                   and d.agente_retencion_isr <> f.id_registro_patronal
                 where f.id_referencia_isr =
                       trabajadores.ultima_liquidacion;
              exception
                when no_data_found then
                  vDeclaradoOtros := 0;
              end;
              vDeclaradoOtros := nvl(vDeclaradoOtros, 0);
            
              -- obtener los salarios de la ultima liquidacion
              select min(nvl(d.tipo_nomina, 'N')),
                     sum(nvl(d.salario_isr, 0)),
                     sum(nvl(d.otros_ingresos_isr, 0)),
                     sum(nvl(remuneracion_isr_otros, 0)),
                     sum(nvl(ingresos_exentos_isr, 0)),
                     sum(nvl(saldo_favor_del_periodo, 0))
                into vTipoNomina,
                     mSalarioIsr,
                     mOtrosIngresosIsr,
                     mRemuneracionIsrOtros,
                     mIngresosExentosIsr,
                     mSaldoFavorPeriodo
                from sfc_det_liquidacion_isr_t d
               where d.id_referencia_isr = trabajadores.ultima_liquidacion
                 and d.id_nss in
                     ( --buscar nss equivalentes
                      select e2.id_nss_reportado
                        from sfc_equivalencias_ir13_t e1
                        join sfc_equivalencias_ir13_t e2
                          on e2.id_registro_patronal =
                             e1.id_registro_patronal
                         and e2.ano_fiscal = e1.ano_fiscal
                         and e2.id_nss_utilizado = e1.id_nss_utilizado
                       where e1.id_registro_patronal =
                             empleadores.id_registro_patronal
                         and e1.ano_fiscal = p_Ano
                         and e1.id_nss_reportado = trabajadores.id_nss); --buscar nss equivalentes
            
              insert into sfc_det_resumen_ir13_t
                (id_registro_patronal,
                 ano_fiscal,
                 id_nss,
                 periodo,
                 salario_isr,
                 otros_ingresos_isr,
                 remuneracion_isr_otros,
                 ingresos_exentos_isr,
                 retencion_ss,
                 isr,
                 saldo_favor_del_periodo,
                 saldo_compensado,
                 saldo_por_compensar,
                 status,
                 tipo_trabajador,
                 ing_reportado_en_otros)
              values
                (empleadores.id_registro_patronal,
                 p_ano,
                 trabajadores.id_nss,
                 periodos.periodo,
                 mSalarioIsr,
                 mOtrosIngresosIsr,
                 mRemuneracionIsrOtros,
                 mIngresosExentosIsr,
                 vAportes,
                 trabajadores.total_isr,
                 mSaldoFavorPeriodo,
                 trabajadores.total_compensado,
                 mSaldoFavorPeriodo - trabajadores.total_compensado,
                 vStatus,
                 vTipoNomina,
                 vDeclaradoOtros);
              commit;
            end loop; --los trabajadores del periodo
            -- ==========================================================================================
          end if;
        end loop;
      
        -- ==========================================================================================
        -- calcular el resumen (saldos a favor) por cada empleado
        for empleados in (select d.id_nss,
                                 count(*) PerTodos,
                                 sum(decode(d.tipo_trabajador, 'P', 1, 0)) PerPensionado,
                                 max(d.periodo) UltPeriodo,
                                 sum(d.salario_isr) salario_isr,
                                 sum(d.otros_ingresos_isr) otros_ingresos,
                                 sum(d.remuneracion_isr_otros) remun_otros,
                                 sum(d.ingresos_exentos_isr) exentos,
                                 sum(d.retencion_ss) retencion_ss,
                                 sum(d.isr) retenido,
                                 sum(d.saldo_compensado) compensado,
                                 sum(d.ing_reportado_en_otros) ing_reportado_en_otros
                            from sfc_det_resumen_ir13_t d
                           where d.id_registro_patronal =
                                 empleadores.id_registro_patronal
                             and d.ano_fiscal = p_ano
                           group by d.id_nss) loop
          --obtener lo POR Compensar de su ultimo periodo
          begin
            select d.saldo_por_compensar
              into vPorCompensar
              from sfc_det_resumen_ir13_t d
             where d.id_registro_patronal =
                   empleadores.id_registro_patronal
               and d.ano_fiscal = p_ano
               and d.periodo = empleados.UltPeriodo
               and d.id_nss = empleados.id_nss;
          exception
            when no_data_found then
              vPorCompensar := 0;
          end;
        
          --obtener el saldo a favor por compenzar del periodo anterior
          vSALDO_FAVOR_ANTERIOR := abs(nvl(empleados.compensado, 0)) +
                                   abs(nvl(vPorCompensar, 0));
        
          -- SOLO si todas sus nominas son pensionadas
          if (empleados.PerTodos = empleados.PerPensionado) then
            vTipoNomina := 'P';
          else
            vTipoNomina := 'N';
          end if;
        
          -- obtener el ISR liquidado
          vISR_LIQUIDADO := isr_empleado(p_tipo     => vTipoNomina,
                                         p_per      => to_number(p_ano || '12'),
                                         p_meses    => 1,
                                         p_ingresos => empleados.salario_isr +
                                                       empleados.otros_ingresos +
                                                       empleados.remun_otros -
                                                       empleados.ing_reportado_en_otros,
                                         p_aportes  => empleados.retencion_ss);
        
          vFormula := (vSALDO_FAVOR_ANTERIOR - empleados.compensado) +
                      (empleados.retenido - vISR_LIQUIDADO);
        
          if (vFormula > 0) then
            -- saldo a favor del empleado
            vSALDO_FAVOR_EMPLEADO := vFormula;
            vSALDO_FAVOR_DGII     := 0;
          else
            -- falta dinero para la DGII
            vSALDO_FAVOR_EMPLEADO := 0;
            vSALDO_FAVOR_DGII     := abs(vFormula);
          end if;
        
          insert into sfc_saldos_favor_t
            (ID_REGISTRO_PATRONAL,
             ID_NSS,
             ANO_FISCAL,
             SALARIOS,
             OTROS_INGRESOS,
             REMUN_OTROS,
             EXENTOS,
             RETENCION_SS,
             SALDO_FAVOR_ANTERIOR,
             ISR_LIQUIDADO,
             ISR_RETENIDO,
             SALDO_COMPENSADO,
             SALDO_FAVOR_EMPLEADO,
             SALDO_FAVOR_DGII,
             tipo_trabajador)
          values
            (empleadores.id_registro_patronal,
             empleados.id_nss,
             p_ano,
             empleados.salario_isr,
             empleados.otros_ingresos,
             empleados.remun_otros,
             empleados.exentos,
             nvl(empleados.retencion_ss, 0),
             vSALDO_FAVOR_ANTERIOR,
             vISR_LIQUIDADO,
             empleados.retenido,
             empleados.compensado,
             vSALDO_FAVOR_EMPLEADO,
             vSALDO_FAVOR_DGII,
             vTipoNomina);
          commit;
        end loop; -- de los trabajadores
        -- ==========================================================================================
      exception
        when others then
          mailme('4 )ORA rp:' || empleadores.id_registro_patronal, sqlerrm);
      end;
    
      update sfc_resumen_ir13_t
         set status = null
       where id_registro_patronal = empleadores.id_registro_patronal
         and ano_fiscal = p_ano;
      commit;
    end loop; -- de los empleadores

    commit; */
	  
    p_resultnumber := 0;
  exception
    when others then
      mailme('3)ORA', sqlerrm);
      rollback;
      p_resultnumber := 650;
  end;
  -- --------------------------------------------------------------------------------------------------
  procedure declaracion_regular_call(p_ano in number,
                                     p_rnc in varchar2,
                                     p_job in number) is
    m_result varchar2(1000);
  begin
    begin
      declaracion_regular(p_ano          => p_ano,
                          p_rnc          => p_rnc,
                          p_usr          => 'SUIRPLUS',
                          p_resultnumber => m_result);
    exception
      when others then
        system.html_mail('info@mail.tss2.gov.do',
                         '_operaciones@mail.tss2.gov.do',
                         'error al regener IR13:' || p_rnc || '/' || p_ano,
                         sqlerrm);
    end;
  
    UPDATE seg_job_t
       SET status = 'P', fecha_termino = SYSDATE
     WHERE id_job = p_job;
    commit;
  end;
  -- --------------------------------------------------------------------------------------------------
  procedure refrescar_vistas is
    html        varchar2(32000) := '';
    not_found   integer := 0;
    v_inicio    date;
    v_antes     integer := 0;
    v_despues   integer := 0;
    v_nuevos    integer := 0;
    v_regpat    integer;
    v_invalidos integer := 0;
    v_conteo    integer;
  begin
    html := '<html><head><title>Refrescamiento de vista de pagos de la DGII</title>' ||
            '<STYLE TYPE="text/css"><!--.smallfont{font-size:9pt;}--></STYLE></head>' ||
            '<body><table border="1" cellpadding=3 cellspacing=0 CLASS="smallfont" style="border-collapse: collapse">' ||
            '<tr><td bgcolor=silver><b>Inicio</b></td><td bgcolor=silver align=right><b>' ||
            to_char(sysdate, 'HH24:MI:SS') || '</b></td></tr>';
  
    begin
      --contar los registros actuales de la vista
      select count(*) into v_antes from dgii_pagos_ir3_mv;
      html := html ||
              '<tr><td>Cantidad de registros ANTES de refrescar</td>' ||
              '<td align=right>' || trim(to_char(v_antes, '999,999,999')) ||
              '</td></tr>';
    
      --refrescar la vista
      v_inicio := sysdate;
      sys.dbms_refresh.refresh('SUIRPLUS.DGII_PAGOS_IR3_RG');
      commit;
      suirplus.sfc_marca_liq_dgii_p;
      html := html || '<tr><td>Refrescamiento completado</td>' ||
              '<td align=right>' ||
              trim(to_char((sysdate - v_inicio) * 24 * 60 * 60,
                           '999,999,999')) || ' seg.</td></tr>';
    
      --contar los registros DESPUES
      select count(*) into v_despues from dgii_pagos_ir3_mv;
    
      html := html ||
              '<tr><td>Cantidad de registros DESPUES de refrescar</td>' ||
              '<td align=right>' || trim(to_char(v_despues, '999,999,999')) ||
              '</td></tr>';
    
      -- procesar los registros existentes
      for rncs in (select distinct rnc_cedula rnc_cedula
                     from dgii_pagos_ir3_mv a) loop
        --ver si existe el rnc
        select count(*)
          into v_conteo
          from sre_empleadores_t
         where rnc_o_cedula = rncs.rnc_cedula;
      
        if (v_conteo = 0) then
          v_invalidos := v_invalidos + 1;
          not_found   := not_found + 1;
        else
          for data in (select *
                         from dgii_pagos_ir3_mv a
                        where a.rnc_cedula = rncs.rnc_cedula) loop
            --obtener registro patronal
            select id_registro_patronal
              into v_regpat
              from sre_empleadores_t
             where rnc_o_cedula = data.rnc_cedula;
          
            --ver si existe en dgii_pagos_t
            select count(*)
              into v_conteo
              from dgii_pagos_ir3_t p
             where p.id_registro_patronal = v_regpat
               and p.periodo_pago = data.periodo_pago;
          
            if (v_conteo = 0) then
              --si no existe insertar
              v_nuevos := v_nuevos + 1;
              insert into dgii_pagos_ir3_t
                (ID_REGISTRO_PATRONAL,
                 PERIODO_PAGO,
                 TIPO_DECLARACION,
                 FECHA_PRESENTACION,
                 FECHA_PAGO,
                 TOTAL_PAGADO,
                 STATUS)
              values
                (v_regpat,
                 data.periodo_pago,
                 data.tipo_declaracion,
                 data.fecha_presentacion,
                 data.fecha_pago,
                 data.total_pagado,
                 null);
              commit;
            end if;
          end loop;
        end if;
      end loop;
      html := html || '<tr><td>Registros Nuevos</td>' || '<td align=right>' ||
              trim(to_char(v_nuevos, '999,999,999')) || '</td></tr>';
      html := html || '<tr><td>Registros con RNC no encontrados<br>' ||
              not_found || '</td>' || '<td align=right>' ||
              trim(to_char(v_invalidos, '999,999,999')) || '</td></tr>';
    
      html := html ||
              '<tr><td bgcolor=silver><b>Fin</b></td><td bgcolor=silver align=right><b>' ||
              to_char(sysdate, 'HH24:MI:SS') || '</b></td></tr>';
    exception
      when others then
        html := html || '<tr><td>Error:' || sqlerrm || '</td>' ||
                '<td align=right>ORA' || '</td></tr>';
    end;
  
    html := html || '</table></body></html>';
    system.html_mail(p_sender    => 'info@mail.tss2.gov.do',
                     p_recipient => 'hector_mota@mail.tss2.gov.do,dbao@mail.tss2.gov.do,roberto_jaquez@mail.tss2.gov.do',
                     p_subject   => 'Refrescamiento de vista de pagos de la DGII',
                     p_message   => html);
  end;
 -- --------------------------------------------------------------------------------------------------
  procedure paralelizar(p_ano in number, p_terminal in varchar2) is
    vResult varchar(1000);
  begin
    for empleadores in (select distinct e.id_registro_patronal,
                                        e.rnc_o_cedula
                          from suirplus.sfc_liquidacion_isr_t l
                          join suirplus.sre_empleadores_t e
                            on e.id_registro_patronal =
                               l.id_registro_patronal
                           and e.id_registro_patronal like '%' || p_terminal
                         where l.id_referencia_isr like p_ano || '%'
                           and l.status <> 'CA') loop
      begin
        declaracion_regular(p_ano          => p_ano,
                            p_rnc          => empleadores.rnc_o_cedula,
                            p_usr          => 'OPERACIONES',
                            p_resultnumber => vResult);
      exception
        when others then
          vResult := '';
      end;
    end loop;
  end;
  -- --------------------------------------------------------------------------------------------------

  Procedure Procesar_RT(p_Recepcion In sre_archivos_t.Id_Recepcion%Type) As
  
    v_usuario               Suirplus.Seg_Usuario_t.Id_Usuario%Type;
    v_rnc                   Suirplus.Sre_Empleadores_t.Rnc_o_Cedula%Type;
    v_Tipo_Movimiento       Suirplus.Sre_Archivos_t.Id_Tipo_Movimiento%Type;
    v_Periodo_Encabezado    Suirplus.Sre_Tmp_Movimiento_t.Periodo_Aplicacion%Type;
    v_PerMov                number(6);
    v_PerVig                number(6);
    v_Nss                   number(12);
    v_RegistroPatronal      number(12);
    v_conteo                number(9);
    v_Error_Respuesta       seg_error_t.id_error%type;
    v_Desc                  seg_error_t.error_des%type;
    v_ErrorDetalle          sre_archivos_t.id_error%type := '000';
    v_ErrorArchivo          sre_archivos_t.id_error%type := '000';
    v_ErrorDetallePY        number(3); --para identificar los registros rechazados desde python por incumplimiento de layout del archivo
    v_OK                    number(12);
    v_Err                   number(12);
    v_maestro               char(1) := 'N';
    v_linea                 sre_det_movimiento_t.id_linea%type;
    v_periodo_rectificativa varchar2(6);
  
    v_ot_isr_otros          sre_det_movimiento_t.ot_retencion_isr%type;
    v_ot_otros_ingresos_isr sre_det_movimiento_t.ot_retencion_isr%type;
    v_ot_salario_isr        sre_det_movimiento_t.ot_retencion_isr%type;
    v_ot_retencion_isr      sre_det_movimiento_t.ot_retencion_isr%type;
    v_ot_retencion_ss       sre_det_movimiento_t.ot_retencion_ss%type;
    v_ot_saldo_compensado   sre_det_movimiento_t.ot_retencion_ss%type;
    v_rp_agente_unico_ret   sre_det_movimiento_t.agente_retencion_isr%type;
    v_movimiento            sre_movimiento_t.id_movimiento%type;
  begin
    ------------------------------------------------------
    -- Buscar el parametro de inicio de Rectificacion.
    begin
      select valor_numerico
        into v_periodo_rectificativa
        from sfc_det_parametro_t
       where id_parametro = 203
         and rownum = 1
       order by fecha_ini desc;
    exception
      when no_data_found then
        v_periodo_rectificativa := null;
    end;
  
    Select Id_Rnc_Cedula, Id_Tipo_Movimiento, Usuario_Carga
      Into v_rnc, v_Tipo_Movimiento, v_usuario
      From Sre_Archivos_t
     Where Id_Recepcion = p_Recepcion;
  
    -- buscamos el periodo del encabezado en tmp
    Select Max(s.Periodo_Aplicacion)
      Into v_Periodo_Encabezado
      From Sre_Tmp_Movimiento_t s
     Where s.Id_Recepcion = p_Recepcion;
    -- que sea un mes valido
    If Substr(v_Periodo_Encabezado, 1, 2) Not In
       ('01',
        '02',
        '03',
        '04',
        '05',
        '06',
        '07',
        '08',
        '09',
        '10',
        '11',
        '12') Then
      Sre_Envio_Archivos_Pkg.Log_Anotar('Mes Invalido: [' ||
                                        Substr(v_Periodo_Encabezado, 1, 2) || ']');
      v_ErrorArchivo := '251';
      goto abortar;
    Else
      v_permov := To_Number(Substr(v_Periodo_Encabezado, 3, 4) ||
                            Substr(v_Periodo_Encabezado, 1, 2));
      v_pervig := Parm.Periodo_Vigente(Sysdate);
    End If;
  
    -- que sea un rnc o cedula valido
    begin
      Select e.id_registro_patronal
        Into v_RegistroPatronal
        From Sre_Empleadores_t e
       Where Rnc_o_Cedula = v_rnc
         And Status = 'A';
    
      -- que el empleador tenga registros pagados para el periodo especificado
      validar_pagos(v_rnc,
                    substr(v_Periodo_Encabezado, 1, 4) ||
                    substr(v_Periodo_Encabezado, 5, 2),
                    v_Error_Respuesta,
                    v_Desc);
      if (v_Error_Respuesta <> 0) then
        v_ErrorArchivo := v_Error_Respuesta;
        goto abortar;
      end if;
    exception
      when no_data_found then
        Sre_Envio_Archivos_Pkg.Log_Anotar('RNC no existe o no esta activo : [' ||
                                          v_rnc || ']');
        v_ErrorArchivo := '150';
        goto abortar;
    end;
    --que sea un representante valido
    Select Count(*)
      Into v_conteo
      From Seg_Usuario_t u, Sre_Representantes_t r, Sre_Empleadores_t e
     Where u.Id_Tipo_Usuario = 2
       And u.Id_Usuario = v_usuario
       And r.Id_Nss = u.Id_Nss
       And e.Id_Registro_Patronal = r.Id_Registro_Patronal
       And e.Rnc_o_Cedula = v_rnc
       And e.Status = 'A';
    If v_conteo = 0 Then
      Sre_Envio_Archivos_Pkg.Log_Anotar('Representante no existe, no es valido o no esta activo : [' ||
                                        v_usuario || '] en [' || v_rnc || ']');
      v_ErrorArchivo := '203';
      goto abortar;
    End If;
    --
    <<abortar>>
    if v_ErrorArchivo != '000' then
      suirplus.sre_procesar_python_pkg.set_status(p_recepcion,
                                                  'R',
                                                  v_ErrorArchivo);
      --borramos lo que se haya insertado en tmp para este envio
      delete from suirplus.sre_tmp_movimiento_t t
       where t.id_recepcion = p_recepcion;
      commit;
      return;
    end if;
  
    --procesamos el detalle del archivo
    for archivo in (select a.rowid id, a.*
                      from sre_archivos_t a
                     where a.id_recepcion = p_recepcion
                       and a.id_tipo_movimiento = 'RT') loop
      v_ErrorArchivo := '000';
      v_OK           := 0;
      v_Err          := 0;
      for detalle in (select d.rowid id, d.*
                        from sre_tmp_movimiento_t d
                       where d.id_recepcion = p_recepcion) loop
        begin
          v_ErrorDetalle   := '000';
          v_ErrorDetallePY := 0;
        
          --buscamos en tmp si tiene un id_error PY1 para que el registro no sea evaluado
          select count(*)
            into v_conteo
            from sre_tmp_movimiento_t
           where rowid = detalle.id
             and detalle.id_error = 'PY1';
          if v_conteo > 0 then
            v_ErrorDetallePY := '999';
            goto fin_validaciones;
          end if;
        
          -- que no envien dos o mas veces el mismo registro
          select count(*)
            into v_Conteo
            from sre_tmp_movimiento_t d
           where d.id_recepcion = detalle.id_recepcion
             and upper(trim(d.tipo_documento)) = detalle.tipo_documento
             and upper(trim(d.no_documento)) = detalle.no_documento;
          if (v_Conteo > 1) then
            v_ErrorDetalle := '422';
            goto fin_validaciones;
          end if;
        
          --Validamos el tipo de documento y el nro de documento        
          if (detalle.tipo_documento is null or
             detalle.tipo_documento not in ('P', 'C', 'N')) then
            v_ErrorDetalle := '101';
            goto fin_validaciones;
          end if;
          --si el documento es P (Pasaporte)
          if (detalle.tipo_documento = 'P') then
            select count(*)
              into v_Conteo
              from sre_ciudadanos_t
             where tipo_documento = detalle.tipo_documento
               and no_documento = detalle.no_documento;
            if (v_Conteo = 0) then
              v_ErrorDetalle := '24';
              goto fin_validaciones;
            end if;
            --*****verificar si esta validacion es necesaria en operaciones------------------------------
            if (length(detalle.no_documento) in (9, 11)) then
              -- Buscamos un cedulado con este numero de documento, si existe rechazamos el registro
              select count(*)
                into v_Conteo
                from sre_ciudadanos_t c
               where c.tipo_documento = 'C'
                 and c.no_documento = detalle.no_documento;
            
              if (v_Conteo > 0) then
                v_ErrorDetalle := '609';
                goto fin_validaciones;
              end if;
            end if;
            ---------------------------------------
          elsif detalle.tipo_documento = 'N' then
            -- ver si existe como nss
            select count(*)
              into v_Conteo
              from sre_ciudadanos_t
             where id_nss = detalle.no_documento;
            if (v_Conteo = 0) then
              v_ErrorDetalle := '24';
              goto fin_validaciones;
            end if;
            v_Nss := detalle.no_documento;
          elsif detalle.tipo_documento = 'C' then
            -- ver si existe como cedula
            select count(*)
              into v_Conteo
              from sre_ciudadanos_t
             where tipo_documento = detalle.tipo_documento
               and no_documento = replace(detalle.no_documento, ' ', '');
            if (v_Conteo = 0) then
              v_ErrorDetalle := '24';
              goto fin_validaciones;
            end if;
          end if;
          -- buscamos el nss correspondiente
          if (detalle.tipo_documento <> 'N') then
            select id_nss
              into v_Nss
              from sre_ciudadanos_t
             where tipo_documento = detalle.tipo_documento
               and no_documento = replace(detalle.no_documento, ' ', '');
          end if;
        
          --que el agente de retencion exista
          if (detalle.agente_retencion_isr is not null and
             trim(detalle.agente_retencion_isr) <> archivo.id_rnc_cedula) then
            select count(*)
              into v_Conteo
              from sre_empleadores_t
             where rnc_o_cedula = trim(detalle.agente_retencion_isr);
            if (v_Conteo = 0) then
              v_ErrorDetalle := '161';
              goto fin_validaciones;
            end if;
          end if;
          -- validar salario isr
          if not sre_load_movimiento_pkg.Is_Dinero(detalle.salario_isr) then
            v_ErrorDetalle := '158';
            goto fin_validaciones;
          end if;
          -- validar otras_renum
          if not
              sre_load_movimiento_pkg.Is_Dinero(detalle.otros_ingresos_isr) then
            v_ErrorDetalle := '159';
            goto fin_validaciones;
          end if;
          -- validar renum otros empleadores
          if not
              sre_load_movimiento_pkg.Is_Dinero(detalle.remuneracion_isr_otros) then
            v_ErrorDetalle := '160';
            goto fin_validaciones;
          end if;
          -- validar ingresos exentos
          if not
              sre_load_movimiento_pkg.Is_Dinero(detalle.ingresos_exentos_isr) then
            v_ErrorDetalle := '176';
            goto fin_validaciones;
          end if;
          -- validar ingresos saldo favor isr
          if not sre_load_movimiento_pkg.Is_Dinero(detalle.saldo_favor_isr) then
            v_ErrorDetalle := '177';
            goto fin_validaciones;
          end if;
          -- validar tipo de trabajador
          if detalle.tipo_trabajador not in ('N', 'P') then
            v_ErrorDetalle := '109';
            goto fin_validaciones;
          end if;
        
          if v_Periodo_Encabezado >= v_periodo_rectificativa then
            -- Solo ejecutar si es IR-3 (mensual)
            begin
              -- Obtener aporte del empleado
              v_ot_retencion_ss := nvl(aporte_empleado(v_RegistroPatronal,
                                                       v_Nss,
                                                       v_Periodo_Encabezado),
                                       0);
              -- obtener salarios reportados
              select sum(nvl(d.REMUNERACION_ISR_OTROS, 0)),
                     sum(nvl(d.OTROS_INGRESOS_ISR, 0)),
                     sum(nvl(d.SALARIO_ISR, 0)),
                     sum(nvl(d.isr, 0)),
                     sum(nvl(d.saldo_compensado, 0))
                into v_ot_isr_otros,
                     v_ot_otros_ingresos_isr,
                     v_ot_salario_isr,
                     v_ot_retencion_isr,
                     v_ot_saldo_compensado
                from SFC_DET_LIQUIDACION_ISR_T d
               where d.id_referencia_isr in
                     (select max(h.id_referencia_isr) -- Ultima Liquidacion Pagada
                        from SFC_LIQUIDACION_ISR_T     h,
                             SFC_DET_LIQUIDACION_ISR_T d
                       where h.id_registro_patronal = v_RegistroPatronal
                         and h.periodo_liquidacion = v_Periodo_Encabezado
                         and h.status in ('PA', 'EX')
                         and h.id_tipo_factura <> 'T' -- Que este PAgada o EXenta.
                         and d.id_referencia_isr = h.id_referencia_isr
                         and d.id_nss = v_Nss)
                 and d.id_nss = v_Nss;
            
              -- obtener impuestos pagados RJ 17/03/2010
              select sum(nvl(d.isr, 0))
                into v_ot_retencion_isr
                from SFC_DET_LIQUIDACION_ISR_T d
               where d.id_referencia_isr in
                     (select h.id_referencia_isr
                        from SFC_LIQUIDACION_ISR_T     h,
                             SFC_DET_LIQUIDACION_ISR_T d
                       where h.id_registro_patronal = v_RegistroPatronal
                         and h.periodo_liquidacion = v_Periodo_Encabezado
                         and h.status in ('PA', 'EX')
                         and d.id_referencia_isr = h.id_referencia_isr
                         and d.id_nss = v_Nss)
                 and d.id_nss = v_Nss;
            exception
              when no_data_found then
                v_ot_isr_otros          := 0;
                v_ot_otros_ingresos_isr := 0;
                v_ot_salario_isr        := 0;
                v_ot_retencion_isr      := 0;
                v_ot_saldo_compensado   := 0;
            end;
            v_ot_isr_otros          := nvl(v_ot_isr_otros, 0);
            v_ot_otros_ingresos_isr := nvl(v_ot_otros_ingresos_isr, 0);
            v_ot_salario_isr        := nvl(v_ot_salario_isr, 0);
            v_ot_retencion_isr      := nvl(v_ot_retencion_isr, 0);
            v_ot_saldo_compensado   := nvl(v_ot_saldo_compensado, 0);
          end if;
        exception
          when others then
            mailme(detalle.no_documento, sqlerrm);
            v_ErrorDetalle := '650';
            goto fin_validaciones;
        end;
      
        <<fin_validaciones>>
      -- actualizar
        if v_ErrorDetallePY = 0 then
          update sre_tmp_movimiento_t
             set id_error = v_ErrorDetalle,
                 status   = decode(v_ErrorDetalle, '000', 'P', 'R')
           where rowid = detalle.id;
          commit;
        end if;
      
        if (v_ErrorDetalle = '000') and (v_ErrorDetallePY = 0) then
          -- no hubo error
          v_OK := v_OK + 1;
          begin
            if v_Periodo_Encabezado >= v_periodo_rectificativa then
              -- Solo ejecutar si es IR-3 (mensual)
              --verificar_trabajador; -- Verificar si el trabajador existe(crearlo si es necesario).
              -- ver si existe como trabajador de ese empleador
              select count(*)
                into v_Conteo
                from sre_trabajadores_t t
               where t.id_registro_patronal = v_RegistroPatronal
                 and t.id_nss = v_Nss;
            
              if (v_Conteo = 0) then
                -- si no existe en ninguna nomina, lo inserta DE BAJA en la nomina 1 (principal) para dicho periodo
                insert into sre_trabajadores_t
                  (id_registro_patronal,
                   id_nomina,
                   id_nss,
                   fecha_ingreso,
                   fecha_salida,
                   salario_ss,
                   status,
                   salario_isr,
                   fecha_ult_reintegro,
                   aporte_voluntario,
                   fecha_registro,
                   ult_usuario_act,
                   ult_fecha_act,
                   saldo_favor_disponible,
                   aporte_afiliados_t3,
                   aporte_empleador_t3)
                values
                  (v_RegistroPatronal,
                   1,
                   v_NSS,
                   to_date(v_Periodo_Encabezado || '01', 'yyyymmdd'),
                   add_months(to_date(v_Periodo_Encabezado || '01',
                                      'yyyymmdd'),
                              1) - 1,
                   0,
                   'B',
                   v_ot_salario_isr,
                   null,
                   0,
                   to_date(v_Periodo_Encabezado || '01', 'yyyymmdd'),
                   v_usuario, -- Usuario que realiza la carga
                   sysdate,
                   0,
                   0,
                   0);
                commit;
              end if;
            
              -- grabar registros maestro/detalle de movimiento.
              if (v_maestro = 'N') then
                -- buscar el siguiente nro de movimiento
                select sre_movimientos_seq.NEXTVAL
                  into v_movimiento
                  from dual;
                sre_envio_archivos_pkg.log_anotar('Mov#' ||
                                                  to_char(v_movimiento));
                -- insertar solo una vez el registro maestro del movimiento
                insert into sre_movimiento_t
                  (id_movimiento,
                   id_registro_patronal,
                   id_usuario,
                   id_tipo_movimiento,
                   status,
                   fecha_registro,
                   periodo_factura,
                   ult_fecha_act,
                   ult_usuario_act,
                   id_recepcion)
                values
                  (v_movimiento,
                   v_RegistroPatronal,
                   archivo.usuario_carga, -- Usuario que realiza la carga
                   archivo.id_tipo_movimiento,
                   'N',
                   archivo.fecha_carga,
                   v_Periodo_Encabezado,
                   sysdate,
                   archivo.ult_usuario_act,
                   p_recepcion);
                commit;
              
                v_maestro := 'S';
                v_linea   := 1;
              end if;
            
              begin
                select id_registro_patronal
                  into v_rp_agente_unico_ret
                  from sre_empleadores_t
                 where rnc_o_cedula =
                       nvl(detalle.agente_retencion_isr, '~');
              exception
                when others then
                  v_rp_agente_unico_ret := null;
              end;
            
              -- insertar el registro de detalle del movimiento
              insert into sre_det_movimiento_t
                (id_movimiento,
                 id_linea,
                 agente_retencion_ss,
                 agente_retencion_isr,
                 id_nss,
                 id_nss_dependiente,
                 id_error,
                 id_tipo_novedad,
                 id_nomina,
                 periodo_aplicacion,
                 fecha_inicio,
                 fecha_fin,
                 afiliado_idss,
                 aporte_empleador_t3,
                 remuneracion_isr_otros,
                 remuneracion_ss_otros,
                 retencion_unico_isr,
                 retencion_unico_ss,
                 salario_isr,
                 salario_ss,
                 aporte_voluntario,
                 saldo_favor_isr,
                 saldo_favor_ss,
                 otros_ingresos_isr,
                 tipo_contratado,
                 pa_salario_ss,
                 pa_aporte_voluntario,
                 ingresos_exentos_isr,
                 ult_fecha_act,
                 ult_usuario_act,
                 ot_retencion_ss,
                 ot_retencion_isr,
                 aporte_afiliados_t3 --temporalmente, luego se creara y usara el campo ot_saldo_compensado
                 )
              values
                (v_movimiento,
                 v_linea,
                 null,
                 v_rp_agente_unico_ret,
                 v_nss,
                 null,
                 '0',
                 archivo.id_tipo_movimiento,
                 1, -- Nomina 1 por default.  Estos es Obligatorio.
                 v_Periodo_Encabezado,
                 to_date(v_Periodo_Encabezado || '01', 'yyyymmdd'),
                 add_months(to_date(v_Periodo_Encabezado || '01',
                                    'yyyymmdd'),
                            1) - 1,
                 'N',
                 0,
                 nvl(detalle.remuneracion_isr_otros, 0), -- remuneracion_isr_otros
                 0,
                 'N',
                 'N',
                 detalle.salario_isr, -- salario_isr
                 0,
                 0,
                 detalle.saldo_favor_isr, -- Saldo a Favor ISR
                 0,
                 detalle.otros_ingresos_isr, -- otros_ingresos_isr
                 detalle.tipo_trabajador, -- normal o pensionado
                 0,
                 0,
                 detalle.ingresos_exentos_isr, -- Exentos ISR
                 sysdate,
                 archivo.ult_usuario_act,
                 v_ot_retencion_ss,
                 v_ot_retencion_isr,
                 v_ot_saldo_compensado);
              commit;
              v_linea := v_linea + 1;
            end if;
          exception
            when others then
              mailme(detalle.secuencia_movimiento, sqlerrm);
              update sre_tmp_movimiento_t c
                 set c.status = 'R', id_error = '650'
               where c.id_recepcion = detalle.id_recepcion
                 and c.secuencia_movimiento = detalle.secuencia_movimiento;
              commit;
          end;
        else
          -- hubo error
          v_Err          := v_Err + 1;
          v_ErrorArchivo := '250';
        end if;
      
      end loop; -- Loop Detalle
    
      -- actualizar los registros ok/bad del archivo
      update sre_archivos_t a
         set a.status        = Decode(v_OK, 0, 'R', 'P'),
             a.id_error      = Decode(v_OK, 0, '301', v_ErrorArchivo),
             a.registros_ok  = v_OK,
             a.registros_bad = v_Err
       where rowid = archivo.id;
      commit;
      if (v_Periodo_Encabezado >= v_periodo_rectificativa) and
         (v_movimiento > 0) then
        -- Manda a aplicar el movimiento
        suirplus.sre_load_movimiento_pkg.poner_en_cola(v_movimiento);
      end if;
    
    end loop;
  
  end;
  -- --------------------------------------------------------------------------------------------------
begin
  -- Anonymous Blocks - Constructor del paquete
  -- Buscar el parametro de inicio de Rectificacion.
  select valor_numerico
    into h_periodo_rectificativa
    from sfc_det_parametro_t
   where id_parametro = 203
     and rownum = 1
   order by fecha_ini desc;
end sre_procesar_RT_pkg;