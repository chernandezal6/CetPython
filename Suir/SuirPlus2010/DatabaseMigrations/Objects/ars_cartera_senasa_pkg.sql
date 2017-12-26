CREATE OR REPLACE PACKAGE BODY suirplus.ars_cartera_senasa_pkg IS
  m_debug        integer := 0;
  m_hora_inicio  date;
  m_hora_termina date;
  m_registros    integer := 0;

  --agregado por: CETHY HERNANDEZ
  --07/03/2016
  Procedure Refrescar_vista_senasa is
  begin
    --Refrescamos la vista desde ars_cartera_senasa_t
    execute immediate 'begin sys.dbms_snapshot.refresh(''SUIRPLUS.ARS_SENASA_SUBSIDIADOS_MV''); end;';
  end;

  Procedure Refrescar_vistas is
  begin
    --Refrescamos la vista desde UNIPAGO
    execute immediate 'begin sys.dbms_snapshot.refresh(''SUIRPLUS.TSS_FACTURABLES_SUBSIDIADO_MV''); end;';
  end;

  procedure debug(p_texto in varchar2) is
    m_Texto suirplus.ars_log_t.texto%type;
  begin
    m_debug := m_debug + 1;
    m_Texto := to_char(m_debug, '00000000000') || ' ' || p_texto;
  
    insert into suirplus.ars_log_t values (sysdate, m_Texto);
    commit;
  end;

  Procedure enviar_email(p_mes in integer, p_id_carga in number) is
    mail_from varchar2(1000) := 'info@mail.tss2.gov.do';
    mail_to   varchar2(1000);
  
    HTML     VARCHAR2(32000);
    v_titulo varchar2(150);
  
    v_dep_tot  integer := 0; -- Total Enviado Dependientes
    v_dep_ok_f integer := 0; -- Total Dependientes OK Facturables
    v_dep_er_f integer := 0; -- Total Dependientes Rechazados Facturables
    v_dep_ok_r integer := 0; -- Total Dependientes OK Reclamos recien nacido
    v_dep_er_r integer := 0; -- Total Dependientes Rechazados Reclamos recien nacido
  
    v_tit_tot integer := 0; -- Total Enviado Titulares
    v_tit_ok  integer := 0; -- Total Titulares OK Factuables
    v_tit_er  integer := 0; -- Total Titulares Rechazados Facturables
  begin
    --Estadisticas dependientes-----------------------------
    --Total dependientes facturables
    select count(*)
      into v_dep_tot
      from suirplus.tss_facturables_subsidiado_mv d
     where d.tipo_afiliado = 'D';
  
    --Total dependientes facturables aceptados
    select count(d.nss_dependiente)
      into v_dep_ok_f
      from suirplus.tss_facturables_subsidiado_mv d
      join suirplus.ars_cartera_senasa_t c
        on c.codigo_ars = d.n_entidad
       and c.periodo_factura = d.periodo_factura
       and c.nss_titular = d.nss_titular
       and c.nss_dependiente = d.nss_dependiente
       and c.tipo_dependencia = d.tipo_afiliado
       and c.id_carga = p_id_carga
       and c.tipo_facturable = d.n_tipo_facturable
     where d.tipo_afiliado = 'D' --dependientes
       and d.n_tipo_facturable = 1; --facturables
  
    --Total dependientes facturables menos los aceptados debe dar los rechazados
    select count(d.nss_dependiente)
      into v_dep_er_f
      from suirplus.tss_facturables_subsidiado_mv d
      join suirplus.ars_cartera_senasa_con_error_t c
        on c.codigo_ars = d.n_entidad
       and c.periodo_factura = d.periodo_factura
       and c.nss_titular = d.nss_titular
       and c.nss_dependiente = d.nss_dependiente
       and c.tipo_dependencia = d.tipo_afiliado
       and c.id_carga = p_id_carga
       and c.tipo_facturable = d.n_tipo_facturable
     where d.tipo_afiliado = 'D' --dependientes
       and d.n_tipo_facturable = 1; --facturables
  
    --Total reclamos dependientes recien nacidos aceptados
    select count(d.nss_dependiente)
      into v_dep_ok_r
      from suirplus.tss_facturables_subsidiado_mv d
      join suirplus.ars_cartera_senasa_t c
        on c.codigo_ars = d.n_entidad
       and c.periodo_factura = d.periodo_factura
       and c.nss_titular = d.nss_titular
       and c.nss_dependiente = d.nss_dependiente
       and c.tipo_dependencia = d.tipo_afiliado
       and c.id_carga = p_id_carga
       and c.tipo_facturable = d.n_tipo_facturable
     where d.tipo_afiliado = 'D' --dependientes
       and d.n_tipo_facturable = 2; --reclamos recien nacidos
  
    --Total reclamos dependientes recien nacidos menos los aceptados debe dar los rechazados
    select count(d.nss_dependiente)
      into v_dep_er_r
      from suirplus.tss_facturables_subsidiado_mv d
      join suirplus.ars_cartera_senasa_con_error_t c
        on c.codigo_ars = d.n_entidad
       and c.periodo_factura = d.periodo_factura
       and c.nss_titular = d.nss_titular
       and c.nss_dependiente = d.nss_dependiente
       and c.tipo_dependencia = d.tipo_afiliado
       and c.id_carga = p_id_carga
       and c.tipo_facturable = d.n_tipo_facturable
     where d.tipo_afiliado = 'D'
       and d.n_tipo_facturable = 2; --reclamos recien nacidos; 
  
    --Estadisticas titulares-----------------------------
    --Total titulares
    select count(*)
      into v_tit_tot
      from suirplus.tss_facturables_subsidiado_mv d
     where d.tipo_afiliado = 'T';
  
    --Total titulares aceptados
    select count(d.nss_titular)
      into v_tit_ok
      from suirplus.tss_facturables_subsidiado_mv d
      join suirplus.ars_cartera_senasa_t c
        on c.codigo_ars = d.n_entidad
       and c.periodo_factura = d.periodo_factura
       and c.nss_titular = d.nss_titular
       and NVL(c.nss_dependiente, 0) = NVL(d.nss_dependiente, 0)
       and c.tipo_dependencia = d.tipo_afiliado
       and c.id_carga = p_id_carga
       and c.tipo_facturable = d.n_tipo_facturable
     where d.tipo_afiliado = 'T'; --titulares
  
    --Total titulares menos los aceptados debe dar los rechazados
    select count(d.nss_titular)
      into v_tit_er
      from suirplus.tss_facturables_subsidiado_mv d
      join suirplus.ars_cartera_senasa_con_error_t c
        on c.codigo_ars = d.n_entidad
       and c.periodo_factura = d.periodo_factura
       and c.nss_titular = d.nss_titular
       and NVL(c.nss_dependiente, 0) = NVL(d.nss_dependiente, 0)
       and c.tipo_dependencia = d.tipo_afiliado
       and c.id_carga = p_id_carga
       and c.tipo_facturable = d.n_tipo_facturable
     where d.tipo_afiliado = 'T'; --titulares
  
    v_titulo := 'Actualizacion de Titulares y Dependientes del Periodo: ' ||
                TO_CHAR(p_mes) || ' Carga: ' || TO_CHAR(p_id_carga);
    html     := '<html><head><title>' || v_titulo ||
                '</title></head><body>';
    html     := html ||
                '<table border=1><tr><th bgcolor=silver>Proceso</th><th bgcolor=silver align=right>Seg.</th></tr>';
  
    html := html ||
            '<tr><td>Total Dependientes Facturables - OK</td><td align=right>' ||
            trim(to_char(v_dep_ok_f, '999,999,999')) || '</td></tr>';
    html := html ||
            '<tr><td>Total Dependientes Facturables - ERROR</td><td align=right>' ||
            trim(to_char(v_dep_er_f, '999,999,999')) || '</td></tr>';
    html := html ||
            '<tr><td>Total Dependientes Reclamos - OK</td><td align=right>' ||
            trim(to_char(v_dep_ok_r, '999,999,999')) || '</td></tr>';
    html := html ||
            '<tr><td>Total Dependientes Reclamos - ERROR</td><td align=right>' ||
            trim(to_char(v_dep_er_r, '999,999,999')) || '</td></tr>';
    html := html || '<tr><td>Total Dependientes</td><td align=right>' ||
            trim(to_char(v_dep_tot, '999,999,999')) || '</td></tr>';
  
    html := html || '<tr><td>Total Titulares - OK</td><td align=right>' ||
            trim(to_char(v_tit_ok, '999,999,999')) || '</td></tr>';
    html := html || '<tr><td>Total Titulares - ERROR</td><td align=right>' ||
            trim(to_char(v_tit_er, '999,999,999')) || '</td></tr>';
    html := html || '<tr><td>Total Titulares</td><td align=right>' ||
            trim(to_char(v_tit_tot, '999,999,999')) || '</td></tr>';
  
    html := html || '</table></body></html>';
  
    --Sacamos la lista de correos de la tabla de procesos
      Select p.lista_ok
        Into mail_to
        From suirplus.sfc_procesos_t p
       Where p.id_proceso = '05';
     
    system.html_mail(mail_from, mail_to, v_titulo, html);
  end;

  /* --------------------------------------------------------------------------
    Objetivo: procesar los registros de cartera del regimen subsidiado SENASA
    Fecha   : Reestructurado en Diciembre 2014
    Autor   : Gregorio U. Herrera
  */ --------------------------------------------------------------------------
  Procedure procesar(p_mes in integer, p_result out varchar2) is
  
    c_mes integer := nvl(p_mes, to_char(add_months(sysdate, -1), 'YYYYMM')); -- Periodo actual (mes anterior)
  
    r_ciudadano suirplus.sre_ciudadanos_t%rowtype;
    c_usr       varchar2(25) := 'UNIPAGO';
    c_fec       date := sysdate;
  
    v_error integer := 0;
  
    v_ok_tit  integer := 0;
    v_err_tit integer := 0;
    v_ok_dep  integer := 0;
    v_err_dep integer := 0;
  
    v_commit integer := 1000;
    v_van    integer := 0;
  
    m_carga_seq suirplus.ars_cartera_senasa_t.id_carga%type;
  
    v_validacion integer := 0; -- Se utiliza para retener el id error de la validacion.
  
    m_ult_fecha_unipago date;
    m_ult_fecha_tss     date;
    m_vista             suirplus.ars_carga_t.vista%type := 'TSS_FACTURABLES_SUBSIDIADO_MV';
    m_bitacora_sec      integer;
  begin
    -- Insertar el registro en la bitacora de procesos
    select suirplus.sfc_bitacora_seq.nextval into m_bitacora_sec from dual;
  
    insert into suirplus.sfc_bitacora_t
      (ID_PROCESO, ID_BITACORA, FECHA_INICIO, STATUS)
    values
      ('SS', m_bitacora_sec, sysdate, 'P');
    commit;
  
    --Para buscar la fecha de actualizacion de la vista desde UNIPAGO.
    --Esta forma me permite compilar en ambientes donde no esta disponible el DBLINK con UNIPAGO.
    Begin
      execute immediate 'select last_refresh from user_snapshots@unipro_dbl where name = ''TSS_FACTURABLES_SENASA'''
        into m_ult_fecha_unipago;
    Exception
      when others then
        m_ult_fecha_unipago := NULL;
    End;
  
    --Para obtener la fecha de la ultima de corrida del proceso para la vista ARS_CARTERA_ACEPTADA
    Begin
      select ult_fecha_act
        into m_ult_fecha_tss
        from suirplus.ars_actualizacion_vistas_t
       where nombre_vista = m_vista;
    Exception
      When No_Data_Found Then
        m_ult_fecha_tss := sysdate;
    End;
  
    --Si las fechas son identicas cancelo el proceso
    if (m_ult_fecha_tss = m_ult_fecha_unipago) then
      update suirplus.sfc_bitacora_t b
         set b.fecha_fin = sysdate,
             b.mensage   = 'La fecha de actualizacion de la vista ' ||
                           m_vista ||
                           ' no ha sufrido cambio desde la ultima corrida.',
             b.status    = 'E'
       where b.id_bitacora = m_bitacora_sec;
      commit;
    
      RETURN; --Termina la ejecucion
    end if;
  
    -- Llamar proceso que refresca la vista desde UNIPAGO
    Refrescar_vistas;
  
    -- Insertar el registro en historico de cargas
    select suirplus.ars_carga_seq.nextval into m_carga_seq from dual;
  
    -- insertamos nuevo registro en la maestra de cargas
    insert into suirplus.ars_carga_t
      (ID_CARGA, FECHA, STATUS, VISTA, REGISTROS_OK, REGISTROS_ERROR)
    values
      (m_carga_seq, sysdate, 'P', m_vista, null, null);
    commit;
  
    m_hora_inicio := sysdate;
    debug('Total de registros a procesar cartera SENASA - iniciado a las ' ||
          to_char(m_hora_inicio, 'dd/mm/yyyy hh:mi:ss am'));
  
    --obtener el total de registros a procesar
    select count(*)
      into m_registros
      from suirplus.tss_facturables_subsidiado_mv a;
  
    m_hora_termina := sysdate;
    debug('Total de registros a procesar cartera SENASA - terminado a las ' ||
          to_char(m_hora_termina, 'dd/mm/yyyy hh:mi:ss am') ||
          ' - Tiempo total: (' ||
          TRIM(TO_CHAR(EXTRACT(HOUR FROM NUMTODSINTERVAL(m_hora_termina -
                                               m_hora_inicio,
                                               'DAY')),
                       '00')) || ':' ||
          TRIM(TO_CHAR(EXTRACT(MINUTE FROM NUMTODSINTERVAL(m_hora_termina -
                                               m_hora_inicio,
                                               'DAY')),
                       '00')) || ':' ||
          TRIM(TO_CHAR(EXTRACT(SECOND FROM NUMTODSINTERVAL(m_hora_termina -
                                               m_hora_inicio,
                                               'DAY')),
                       '00')) || ') - registros a procesar: ' ||
          m_registros);
  
    m_hora_inicio := sysdate;
    debug('Cartera SENASA: procesamiento TITULARES - iniciado a las ' ||
          to_char(m_hora_inicio, 'dd/mm/yyyy hh:mi:ss'));
  
    --Procesamos los titulares primeros, ya que es requisito que exista
    --para el mismo periodo y ARS que el reclamo del dependiente.
    for tit in (select t.*
                  from suirplus.tss_facturables_subsidiado_mv t
                 where t.tipo_afiliado = 'T') loop
      -- Caso 2
      -- Valida que el titular exista en Ciudadano
      Begin
        select *
          into r_ciudadano
          from suirplus.sre_ciudadanos_t c
         where c.id_nss = tit.nss_titular;
      
        v_error := 0;
      Exception
        when no_data_found then
          v_error      := 1;
          v_validacion := 4;
      End;
    
      --Valida que el tipo facturable sea correcto
      if (v_error = 0) then
        if nvl(tit.n_tipo_facturable, 0) != 1 then
          v_validacion := 69;
          v_error      := 1;
        end if;
      end if;
    
      -- Valida que la cedula no este cancelada segun el catalogo de causa y tipo de inhabilidad
      if (v_error = 0) then
        v_validacion := 37;
      
        -- Si la funcion evalua que no se debe pagar la cápita.        
		if SUIRPLUS.SRE_CIUDADANO_INACTIVO_F(r_ciudadano.id_nss, TO_NUMBER(tit.periodo_factura)) = 'N' then
          v_error := 1;
        end if;
      end if;
    
      -- No debe ser una empresa activa con trabajadores activos
      if (v_error = 0) then
        v_validacion := 39;
      
        Select count(*)
          into v_error
          from suirplus.sre_trabajadores_t t, suirplus.sre_empleadores_t e
         where t.id_registro_patronal = e.id_registro_patronal
           and t.status = 'A'
           and e.status = 'A'
           and e.rnc_o_cedula = r_ciudadano.no_documento;
      end if;
    
      -- No debe ser un pensionado
      if (v_error = 0) then
        v_validacion := 40;
      
        select count(*)
          into v_error
          from suirplus.seh_pensionados_ok_v c
         where id_nss = r_ciudadano.id_nss;
      end if;
    
      --Caso 8
      --Rechaza los que ya están de nuestro lado aceptados.
      if (v_error = 0) then
        v_validacion := 64;
      
        select count(*)
          into v_error
          from suirplus.ars_cartera_senasa_t x
         where x.codigo_ars = tit.n_entidad
           and x.nss_titular = tit.nss_titular
           and x.periodo_factura = tit.periodo_factura
           and nvl(x.nss_dependiente, 0) = nvl(tit.nss_dependiente, 0);
      end if;
    
      -- Evaluar el resultado
      if (v_error > 0) then
        v_err_tit := v_err_tit + 1;
        insert into suirplus.ars_cartera_senasa_con_error_t
          (id_carga,
           periodo_factura,
           codigo_ars,
           nss_titular,
           nss_dependiente,
           tipo_dependencia,
           codigo_parentesco,
           id_error,
           ULT_FECHA_AC,
           TIPO_FACTURABLE)
        values
          (m_carga_seq,
           tit.periodo_factura,
           tit.n_entidad,
           tit.nss_titular,
           tit.nss_dependiente,
           tit.tipo_afiliado,
           tit.parentesco,
           v_validacion,
           sysdate,
           tit.n_tipo_facturable);
      else
        v_ok_tit := v_ok_tit + 1;
        insert into suirplus.ars_cartera_senasa_t
          (ID_CARGA,
           CODIGO_ARS,
           PERIODO_FACTURA,
           NSS_TITULAR,
           NSS_DEPENDIENTE,
           CODIGO_PARENTESCO,
           TIPO_DEPENDENCIA,
           ULT_USUARIO_ACT,
           ULT_FECHA_AC,
           TIPO_FACTURABLE)
        values
          (m_carga_seq,
           tit.n_entidad,
           tit.periodo_factura,
           tit.nss_titular,
           tit.nss_dependiente,
           tit.parentesco,
           tit.tipo_afiliado,
           c_usr,
           c_fec,
           tit.n_tipo_facturable);
      end if;
    
      v_van := v_van + 1;
      if (v_van >= v_commit) then
        commit;
        v_van := 0;
      end if;
    end loop;
    commit;
  
    m_hora_termina := sysdate;
    debug('Cartera: SENASA - procesamiento TITULARES terminado a las ' ||
          to_char(m_hora_termina, 'dd/mm/yyyy hh:mi:ss') ||
          ' - Tiempo total: (' ||
          TRIM(TO_CHAR(EXTRACT(HOUR FROM NUMTODSINTERVAL(m_hora_termina -
                                               m_hora_inicio,
                                               'DAY')),
                       '00')) || ':' ||
          TRIM(TO_CHAR(EXTRACT(MINUTE FROM NUMTODSINTERVAL(m_hora_termina -
                                               m_hora_inicio,
                                               'DAY')),
                       '00')) || ':' ||
          TRIM(TO_CHAR(EXTRACT(SECOND FROM NUMTODSINTERVAL(m_hora_termina -
                                               m_hora_inicio,
                                               'DAY')),
                       '00')) || ') - total registros: ' ||
          TO_CHAR(v_ok_tit + v_err_tit));
  
    --Procesamos los dependientes
    m_hora_inicio := sysdate;
    debug('Cartera SENASA: procesamiento DEPENDIENTES - iniciado a las ' ||
          to_char(m_hora_inicio, 'dd/mm/yyyy hh:mi:ss'));
  
    v_van := 0;
  
    for dep in (select d.*
                  from suirplus.tss_facturables_subsidiado_mv d
                 where d.tipo_afiliado != 'T'
                 order by d.n_tipo_facturable) loop
      v_error := 0;
    
      --Valida que el tipo de afiliacion sea correcto
      if nvl(dep.tipo_afiliado, 'X') not in ('T', 'D') then
        v_validacion := 3;
        v_error      := 1;
      end if;
    
      --Valida que el tipo facturable sea correcto
      if (v_error = 0) then
        if nvl(dep.n_tipo_facturable, 0) not in (1, 2) then
          v_validacion := 69;
          v_error      := 1;
        end if;
      end if;
    
      --Valida que la combinacion de tipo facturable y tipo afiliado sea correcta
      if (v_error = 0) then
        if (nvl(dep.n_tipo_facturable, 0) = 1) and
           (nvl(dep.tipo_afiliado, 'X') not in ('T', 'D')) then
          v_validacion := 70;
          v_error      := 1;
        elsif (nvl(dep.n_tipo_facturable, 0) = 2) and
              (nvl(dep.tipo_afiliado, 'X') != 'D') then
          v_validacion := 70;
          v_error      := 1;
        end if;
      end if;
    
      --A partir de aqui solo proceso los dependientes
      if (dep.tipo_afiliado = 'D') then
        -- Caso 2
        -- Valida que el dependiente exista en Ciudadano
        if (v_error = 0) then
          Begin
            select c.*
              into r_ciudadano
              from suirplus.sre_ciudadanos_t c
             where c.id_nss = NVL(dep.nss_dependiente, 0);
          
            v_error := 0;
          Exception
            when no_data_found then
              v_validacion := 5;
              v_error      := 1;
          End;
        end if;
      
        -- Valida el parentesco solo del dependiente
        if (v_error = 0) then
          Begin
            select 0
              into v_error
              from suirplus.ars_parentescos_t p
             where p.id_parentesco = nvl(dep.parentesco, 0);
          Exception
            when no_data_found then
              v_validacion := 9;
              v_error      := 1;
          End;
        end if;
      
        -- Valida que la cedula no este cancelada segun el catalogo de causa y tipo de inhabilidad
        if (v_error = 0) then
          v_validacion := 37;
        
          -- Si la funcion evalua que no se debe pagar la cápita.        
	  	  if SUIRPLUS.SRE_CIUDADANO_INACTIVO_F(r_ciudadano.id_nss, TO_NUMBER(dep.periodo_factura)) = 'N' then
            v_error := 1;
          end if;
        end if;
      
        -- No debe ser una empresa activa con trabajadores activos
        if (v_error = 0) then
          v_validacion := 39;
        
          Select count(*)
            into v_error
            from suirplus.sre_trabajadores_t t,
                 suirplus.sre_empleadores_t  e
           where t.id_registro_patronal = e.id_registro_patronal
             and t.status = 'A'
             and e.status = 'A'
             and e.rnc_o_cedula = r_ciudadano.no_documento;
        end if;
      
        -- No debe ser un pensionado
        if (v_error = 0) then
          v_validacion := 40;
        
          select count(*)
            into v_error
            from suirplus.seh_pensionados_ok_v c
           where id_nss = r_ciudadano.id_nss;
        end if;
      
        --Caso 6
        --Rechaza dependiente con periodo nacimiento mayor periodo reclamado.
        if (v_error = 0) then
          if dep.periodo_factura <
             to_char(add_months(r_ciudadano.fecha_nacimiento, -1), 'YYYYMM') then
            v_validacion := 68;
            v_error      := 1;
          else
            v_error := 0;
          end if;
        end if;
      
        --Caso 7
        --Rechaza dependiente que no tengan el titular de nuestro lado aceptado.
        if (v_error = 0) then
          Begin
            if dep.parentesco != 23 then
              --Parentesco 23 (Tutoria Institucional u Orfanatos), no llevan esta validacion
              select 0
                into v_error
                from suirplus.ars_cartera_senasa_t x
               where x.codigo_ars = dep.n_entidad
                 and x.nss_titular = dep.nss_titular
                 and x.periodo_factura = dep.periodo_factura
                 and x.tipo_dependencia = 'T';
            end if;
          Exception
            When no_data_found then
              v_validacion := 11;
              v_error      := 1;
          End;
        end if;
      
        --Caso 1 y 8
        --Rechaza dependiente que ya están de nuestro lado aceptado.
        if (v_error = 0) then
          v_validacion := 64;
        
          select count(*)
            into v_error
            from suirplus.ars_cartera_senasa_t x
           where x.codigo_ars = dep.n_entidad
             and x.nss_dependiente = r_ciudadano.id_nss
             and x.periodo_factura = dep.periodo_factura;
        end if;
      
        --Caso 9 y 10
        --recien nacido
        if (v_error = 0) and (dep.n_tipo_facturable = 2) then
        
          --Valida que el dependiente ya tenga dos reclamos recien nacido
          v_validacion := 71;
        
          select count(*)
            into v_error
            from suirplus.ars_cartera_senasa_t p
           where p.nss_dependiente = nvl(dep.nss_dependiente, 0)
             and p.tipo_facturable = 2;
        
          if (v_error < 2) then
            v_error := 0;
          
            --Entre periodo corriente y periodo reclamo hay mas de 12 meses
            if MONTHS_BETWEEN(to_date(c_mes, 'YYYYMM'),
                              to_date(dep.periodo_factura, 'YYYYMM')) > 12 then
              v_validacion := 65; --Caso 9
              v_error      := 1;
            else
              --rechazar si periodo reclamado no esta dentro de los 60 dias reglamentario de la resolucion 351-02
              if dep.periodo_factura >
                 to_char(add_months(r_ciudadano.fecha_nacimiento, 2),
                         'YYYYMM') then
                v_validacion := 66; --Caso X por definir
                v_error      := 1;
                --modificado por: CMHA
                --fecha:04/03/2015
                --nota: se comento este clausula..
                /* else
                 --rechazar si no existe un periodo pagado posterior al de reclamo
                 select count(*)
                 into v_error
                 from suirplus.ars_cartera_senasa_t x
                where x.codigo_ars = dep.n_entidad
                  and x.nss_dependiente = r_ciudadano.id_nss --este es el nss del dependiente
                  and x.periodo_factura > dep.periodo_factura;*/
              
                --No existe, cambio el valor de la variable v_error para que sea evaluad a error
                if v_error = 0 then
                  v_validacion := 67; --Caso 10
                  v_error      := 1;
                end if;
              end if;
            end if;
          end if;
        end if;
      end if;
    
      -- Evaluar el resultado
      if (v_error > 0) then
        v_err_dep := v_err_dep + 1;
        v_van     := v_van + 1;
      
        insert into suirplus.ars_cartera_senasa_con_error_t
          (id_carga,
           periodo_factura,
           codigo_ars,
           nss_titular,
           nss_dependiente,
           codigo_parentesco,
           tipo_dependencia,
           id_error,
           ULT_FECHA_AC,
           TIPO_FACTURABLE)
        values
          (m_carga_seq,
           dep.periodo_factura,
           dep.n_entidad,
           dep.nss_titular,
           dep.nss_dependiente,
           dep.parentesco,
           dep.tipo_afiliado,
           v_validacion,
           sysdate,
           dep.n_tipo_facturable);
      else
        if (dep.tipo_afiliado = 'D') then
          v_ok_dep := v_ok_dep + 1;
          v_van    := v_van + 1;
        
          insert into suirplus.ars_cartera_senasa_t
            (ID_CARGA,
             CODIGO_ARS,
             PERIODO_FACTURA,
             NSS_TITULAR,
             NSS_DEPENDIENTE,
             CODIGO_PARENTESCO,
             TIPO_DEPENDENCIA,
             ULT_USUARIO_ACT,
             ULT_FECHA_AC,
             TIPO_FACTURABLE)
          values
            (m_carga_seq,
             dep.n_entidad,
             dep.periodo_factura,
             dep.nss_titular,
             dep.nss_dependiente,
             dep.parentesco,
             dep.tipo_afiliado,
             c_usr,
             c_fec,
             dep.n_tipo_facturable);
        end if;
      end if;
    
      if (v_van >= v_commit) then
        commit;
        v_van := 0;
      end if;
    end loop;
  
    m_hora_termina := sysdate;
    debug('Cartera: SENASA - procesamiento DEPENDIENTES terminado a las ' ||
          to_char(m_hora_termina, 'dd/mm/yyyy hh:mi:ss') ||
          ' - Tiempo total: (' ||
          TRIM(TO_CHAR(EXTRACT(HOUR FROM NUMTODSINTERVAL(m_hora_termina -
                                               m_hora_inicio,
                                               'DAY')),
                       '00')) || ':' ||
          TRIM(TO_CHAR(EXTRACT(MINUTE FROM NUMTODSINTERVAL(m_hora_termina -
                                               m_hora_inicio,
                                               'DAY')),
                       '00')) || ':' ||
          TRIM(TO_CHAR(EXTRACT(SECOND FROM NUMTODSINTERVAL(m_hora_termina -
                                               m_hora_inicio,
                                               'DAY')),
                       '00')) || ') - total registros: ' ||
          TO_CHAR(v_ok_dep + v_err_dep));
  
    -- Actualizar el registro en historico de cargas con el resultado
    update suirplus.ars_carga_t
       set STATUS          = 'C',
           REGISTROS_OK    = v_ok_tit + v_ok_dep,
           REGISTROS_ERROR = v_err_tit + v_err_dep
     where ID_CARGA = m_carga_seq;
    commit;
  
    -- Actualizar el resultado del proceso en la bitacora
    update suirplus.sfc_bitacora_t b
       set b.fecha_fin = sysdate,
           b.mensage   = 'OK. CARGA: ' || to_char(m_carga_seq),
           b.status    = 'O',
           b.id_error  = '000'
     where b.id_bitacora = m_bitacora_sec;
    commit;
  
    --Actualizo la ultima fecha de actualizacion de la vista tal como esta en UNIPAGO
    Update suirplus.ars_actualizacion_vistas_t
       set ult_fecha_act = m_ult_fecha_unipago
     Where nombre_vista = m_vista;
    Commit;
  
    p_result := 'OK';
  EXCEPTION
    WHEN OTHERS THEN
      -- Actualizar el registro en historico de cargas con el resultado
      update suirplus.ars_carga_t
         set STATUS = 'E'
       where ID_CARGA = m_carga_seq;
      commit;
    
      p_result := Substr(SQLERRM, 1, 200);
    
      -- Actualizar el resultado del proceso en la bitacora
      update suirplus.sfc_bitacora_t b
         set b.fecha_fin  = sysdate,
             b.mensage    = p_result,
             b.status     = 'E',
             b.id_error   = '650',
             b.seq_number = 0
       where b.id_bitacora = m_bitacora_sec;
    
      p_result := SUBSTR('Proceso ejecutado con error: ' || SQLERRM, 1, 400);
  END; -- carga_paralelizada

  /* --------------------------------------------------------------------------
    Objetivo: actualizar como completado el JOB que llama el metodo PROCESAR
              a sugerencia de operaciones
    Fecha   : 19 agosto 2015
    Autor   : Gregorio U. Herrera
  */ --------------------------------------------------------------------------
  Procedure carga_NO_paralelizada(p_mes      in integer,
                                  p_terminal in integer,
                                  p_job      IN suirplus.seg_job_t.id_job%TYPE) is
    c_mes       integer := nvl(p_mes,
                               to_char(add_months(sysdate, -1), 'YYYYMM')); -- Periodo a procesar (mes anterior)
    p_result    Varchar2(32000);
    c_resultado Varchar2(400) := null;
  begin
    suirplus.ars_cartera_senasa_pkg.procesar(c_mes, p_result);
  
    UPDATE suirplus.seg_job_t
       SET status = 'P', fecha_termino = SYSDATE
     WHERE id_job = p_job;
    commit;
  EXCEPTION
    WHEN OTHERS THEN
      c_resultado := SUBSTR('Job Ejecutado con Error: ' || SQLERRM, 1, 400);
    
      UPDATE suirplus.seg_job_t j
         SET status        = 'P',
             fecha_termino = SYSDATE,
             j.resultado   = c_resultado
       WHERE id_job = p_job;
      commit;
  end;

  /* --------------------------------------------------------------------------
    Objetivo: poner en JOB la corrida del metodo PROCESAR, a sugerencia de operaciones
    Fecha   : 19 agosto 2015
    Autor   : Gregorio U. Herrera
  */ --------------------------------------------------------------------------
  Procedure Procesar_produccion(p_mes in integer) is
    c_mes         integer := nvl(p_mes,
                                 to_char(add_months(sysdate, -1), 'YYYYMM')); -- Periodo a procesar (mes anterior)
    v_Proximo_Job number(10);
    v_comando     varchar2(1000);
  begin
    Select suirplus.Seg_Job_Seq.Nextval Into v_Proximo_Job From Dual;
    v_Comando := 'suirplus.ars_cartera_senasa_pkg.carga_NO_paralelizada (' ||
                 c_mes || ', ' || 0 || ', ' || v_Proximo_Job || ');';
    dbms_output.put_line('Job: ' || v_Comando);
    Insert Into suirplus.Seg_Job_t
      (Id_Job, Nombre_Job, Status, Fecha_Envio)
    Values
      (v_Proximo_Job, v_Comando, 'S', Sysdate);
  
    commit;
  end;

end;
