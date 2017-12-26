create or replace package body suirplus.sre_estadisticas_pkg is
  -- ------------------------------------------------------------------------------------------------------------------------------------
  ok integer := 0;
  er integer := 0;
  -- ------------------------------------------------------------------------------------------------------------------------------------
  PROCEDURE log_anotar(texto IN VARCHAR2) AS
    v_databasename varchar2(1000);
  BEGIN
    IF (texto = 'START') THEN
      begin
        select d.valor_texto
          into v_databasename
          from sfc_parametros_t p, sfc_det_parametro_t d
         where p.parametro_des = 'NOMBRE DE LA BASE DE DATOS'
           and d.id_parametro = p.id_parametro;
      exception
        when no_data_found then
          v_databasename := 'DATABASENAME parameter not set';
      end;
      c_log_file := '<html><head><title>' || c_log_title || '</title>' ||
                    '<STYLE TYPE="text/css"><!--.smallfont{font-size:9pt;}--></STYLE></head>' ||
                    '<body><table border=1 CLASS="smallfont"><tr><td bgcolor=AliceBlue><b>TSS (c)<br>suirplus.sre_envio_archivos_pkg on ' ||
                    v_databasename || '<br>' || c_log_title ||
                    '</b></td></tr><tr><td>';
    ELSIF (texto = 'END') THEN
      c_log_file := c_log_file || '<tr><td bgcolor=silver><b>Inicio: ' ||
                    TO_CHAR(c_log_start, 'DD/MM/YYYY HH:MI:SS PM') ||
                    '<br>Fin: ' ||
                    TO_CHAR(SYSDATE, 'DD/MM/YYYY HH:MI:SS PM') ||
                    '<br>Duracion : ' || TRUNC(SYSDATE - c_log_start) ||
                    ' Dias ' ||
                    TRUNC(MOD((SYSDATE - c_log_start) * 24, 24)) ||
                    ' Hor. ' ||
                    TRUNC(MOD((SYSDATE - c_log_start) * 24 * 60, 60)) ||
                    ' Min. ' ||
                    TRUNC(MOD((SYSDATE - c_log_start) * 24 * 60 * 60, 60)) ||
                    ' Seg.' || '</b></td></tr></table></body></html>';
    ELSE
      c_log_file := c_log_file || texto;
    END IF;
  END log_anotar;
  -- ------------------------------------------------------------------------------------------------------------------------------------
  procedure recolectar_estadisticas is
    v_valor  sre_estadisticas_diarias_t.valor%type;
    v_status varchar2(32000);
  begin
    log_anotar('START');
    log_anotar('<table borders=0 CLASS="smallfont">');
    delete sre_estadisticas_diarias_t d where d.fecha = trunc(sysdate);
    commit;
    for datos in (select * from sre_estadisticas_t order by id_estadistica) loop
      begin
        execute immediate datos.estadistica_sql
          into v_valor;
        v_status := to_char(nvl(v_valor, 0));
      exception
        when others then
          v_valor  := 0;
          v_status := sqlerrm;
      end;
      insert into sre_estadisticas_diarias_t
        (fecha, id_estadistica, valor)
      values
        (trunc(sysdate), datos.id_estadistica, nvl(v_valor, 0));
      commit;
      log_anotar('<tr><td>' || datos.estadistica_des || '</td><td>' ||
                 substr(v_status, 1, 250) || '</td></tr>');
    end loop;
    log_anotar('</table>');
    log_anotar('END');
    system.html_mail(c_mail_from, c_mail_to, c_log_title, c_log_file);
  end;
  -- ------------------------------------------------------------------------------------------------------------------------------------
  procedure actualizar_ciudadanos_cotizan is
  begin
    -- procesar cada nss que no cotize
    for nuevos in (select distinct d.id_nss
                     from sfc_facturas_t f
                     join sfc_det_facturas_t d
                       on d.id_referencia = f.id_referencia
                     join sre_ciudadanos_t c
                       on c.id_nss = d.id_nss
                      and c.cotizacion is null
                    where f.status = 'PA'
                      and trunc(f.fecha_registro_pago) = trunc(sysdate)) loop
      update sre_ciudadanos_t
         set cotizacion      = 'S',
             ult_usuario_act = 'PROCESO ACTUALIZA COTIZACION'
       where id_nss = nuevos.id_nss;
      commit;
    end loop;
  end;
  -- ------------------------------------------------------------------------------------------------------------------------------------
  procedure DesautNoPagadasTssbanco is
    r varchar2(100);  
  begin  
    for facturas in (select f.id_referencia,
                            f.no_autorizacion,
                            id_usuario_autoriza
                       from sfc_facturas_t f
                       join sre_empleadores_t e
                         on e.id_registro_patronal = f.id_registro_patronal
                      where f.id_usuario_autoriza in
                            ('TSSBANCO', 'JVIDAL', 'JRAMIREZ')
                        and f.status <> 'PA'
                        and e.tipo_empresa = 'PR'
                        and f.no_autorizacion is not null) loop
      begin
        ok := ok + 1;
        sfc_factura_pkg.Cancelar_Autorizacion(p_NoReferencia => facturas.id_referencia,
                                              p_idusuario    => facturas.id_usuario_autoriza,
                                              p_concepto     => 'SDSS',
                                              p_fecha_caja   => trunc(sysdate),
                                              p_resultnumber => r);
      exception
        when others then
          er := er + 1;
          system.html_mail('info@mail.tss2.gov.do',
                           c_mail_error,
                           'error al cancelar autorizacion de TSSBANCO: ' ||
                           facturas.id_referencia,
                           sqlerrm);
          commit;
      end;
    end loop;
    commit;
  end;
  -- ------------------------------------------------------------------------------------------------------------------------------------
  procedure historico_facturas is
    periodo_vigente number(6);
    insert_count    number(6);
    commit_batch    number(6);
  begin
    if extract(day from sysdate) = 1 then
      ok              := 0;
      insert_count    := 0;
      commit_batch    := 5000;
      periodo_vigente := suirplus.parm.periodo_vigente();
      for facturas in (select id_referencia
                         from sfc_facturas_t
                        where status in ('VE', 'VI')
                          and no_autorizacion is null) loop
        begin
          insert into SFC_HISTORICO_FACTURAS_T
            (ANO_MES_PROCESO, ID_REFERENCIA)
          values
            (periodo_vigente, facturas.Id_referencia);
          ok := ok + 1;
          if (insert_count = commit_batch) then
            insert_count := 0;
            commit;
          else
            insert_count := insert_count + 1;
          end if;
        exception
          when others then
            er := er + 1;
        end;
      end loop;
      commit;
    end if;
  end;
  -- ------------------------------------------------------------------------------------------------------------------------------------
  procedure procesar is
    html     varchar2(32000);
    v_inicio date;
    p_result varchar2(1000);    
    p_fecha  date := sysdate;
    v_sender varchar2(1000);
    v_recipient varchar2(1000);
    v_recipient_bad  varchar2(1000);
    v_recipient_ok  varchar2(1000);
    v_error  varchar2(1000);
    

  begin
    html := '<html><head><title>Recoleccion de datos estadisticos</title></head><body>';
    html := html ||
            '<table border=1><tr><th bgcolor=silver>Proceso</th><th bgcolor=silver align=right>Seg.</th></tr>';

    begin
      -- actualizar las facturas pagadas
      
      ok       := 0;
      er       := 0;
      v_inicio := sysdate;
      v_sender := 'info@mail.tss2.gov.do';
      
      select p.lista_error into v_recipient  from sfc_procesos_t p where p.id_proceso = '13';
      select e.error_des into v_error  from seg_error_t e where e.id_error = 'E01';
      
      
      sfc_actualiza_factura_p;
      html := html ||
              '<tr><td>sfc_actualiza_factura_p</td><td align=right>' ||
              trim(to_char((sysdate - v_inicio) * 24 * 60 * 60,
                           '999,999,999.99')) || ' Seg.</td></tr>';                         
                                                      
    exception
      when others then
        system.html_mail(v_sender,
                         v_recipient,
                         v_error,
                         sqlerrm);
    end;
    

    begin
      -- Publicar vista a Unipago de facturas Pagadas con Subsidios
      ok       := 0;
      er       := 0;
      v_inicio := sysdate; 
      v_sender := 'info@mail.tss2.gov.do';
      
      select p.lista_error into v_recipient from sfc_procesos_t p where p.id_proceso = 'NP';  
      select e.error_des into v_error  from seg_error_t e where e.id_error = 'E02';
        
      sub_sfs_dispersion.publicarnp(p_fecha, p_result);
      html := html ||
              '<tr><td>sfs_dispersion_pkg.publicarnp</td><td align=right>' ||
              trim(to_char((sysdate - v_inicio) * 24 * 60 * 60,
                           '999,999,999.99')) || ' Seg.</td></tr>';
    exception
      when others then
        system.html_mail(v_sender,
                         v_recipient,
                         v_error,
                         sqlerrm);
    end;

    begin
      -- cancelar autorizaciones de TSSbanco no pagadas
      ok          := 0;
      er          := 0;
      v_inicio    := sysdate;
      c_log_start := sysdate;
      v_sender := 'info@mail.tss2.gov.do';
      
      select p.lista_error into v_recipient from sfc_procesos_t p where p.id_proceso = 'AC';
      select e.error_des into v_error  from seg_error_t e where e.id_error = 'E03';
      
      DesautNoPagadasTssbanco;
      html := html || '<tr><td>DesautNoPagadasTssbanco OK=' || ok ||
              ' ERR=' || er || '</td><td align=right>' ||
              trim(to_char((sysdate - v_inicio) * 24 * 60 * 60,
                           '999,999,999.99')) || ' Seg.</td></tr>';
    exception
      when others then
        system.html_mail(v_sender,
                         v_recipient,
                         v_error,
                         sqlerrm);
    end;

    begin
      -- actualizar los ciudadanos que cotizan
      ok          := 0;
      er          := 0;
      v_inicio    := sysdate;
      c_log_start := sysdate;
      v_sender := 'info@mail.tss2.gov.do';
      
      select p.lista_error into v_recipient from sfc_procesos_t p where p.id_proceso = 'CC';
      select e.error_des into v_error  from seg_error_t e where e.id_error = 'E04';
      actualizar_ciudadanos_cotizan;
      html := html ||
              '<tr><td>actualizar_ciudadanos_cotizan</td><td align=right>' ||
              trim(to_char((sysdate - v_inicio) * 24 * 60 * 60,
                           '999,999,999.99')) || ' Seg.</td></tr>';
    exception
      when others then
        system.html_mail(v_sender,
                         v_recipient,
                         v_error,
                         sqlerrm);
    end;

    begin
      -- recoletar datos estadisticos
      ok       := 0;
      er       := 0;
      v_inicio := sysdate;
      v_sender := 'info@mail.tss2.gov.do';
      
      select p.lista_error into v_recipient from sfc_procesos_t p where p.id_proceso = 'RF';
      select e.error_des into v_error  from seg_error_t e where e.id_error = 'E05';
      
      recolectar_estadisticas;
      html := html ||
              '<tr><td>recolectar_estadisticas</td><td align=right>' ||
              trim(to_char((sysdate - v_inicio) * 24 * 60 * 60,
                           '999,999,999.99')) || ' Seg.</td></tr>';
    exception
      when others then
        system.html_mail(v_sender,
                         v_recipient,
                         v_error,
                         sqlerrm);
    end;

    begin
      -- historico de facturas
      ok       := 0;
      er       := 0;
      v_inicio := sysdate;
      v_sender := 'info@mail.tss2.gov.do';
      
      select p.lista_error into v_recipient from sfc_procesos_t p where p.id_proceso = 'HF';
      select e.error_des into v_error  from seg_error_t e where e.id_error = 'E06';
      
      historico_facturas;
      html := html || '<tr><td>historico_facturas OK=' || ok || ' ERR=' || er ||
              '</td><td align=right>' ||
              trim(to_char((sysdate - v_inicio) * 24 * 60 * 60,
                           '999,999,999.99')) || ' Seg.</td></tr>';
    exception
      when others then
        system.html_mail(v_sender,
                         v_recipient,
                         v_error,
                         sqlerrm);
    end;

    declare
      p_result varchar2(1000);
    begin
      -- marcar ap completados
      v_inicio := sysdate;
      v_sender := 'info@mail.tss2.gov.do';
      
      select p.lista_error into v_recipient from sfc_procesos_t p where p.id_proceso = 'MC';
      select e.error_des into v_error  from seg_error_t e where e.id_error = 'E07';
      
      suirplus.lgl_legal_pkg.Marcar_AP_Completados(p_result);
      html := html || '<tr><td>Marcar_AP_Completados</td><td align=right>' ||
              trim(to_char((sysdate - v_inicio) * 24 * 60 * 60,
                           '999,999,999.99')) || ' Seg.</td></tr>';
    exception
      when others then
        system.html_mail(v_sender,
                         v_recipient,
                         v_error,
                         sqlerrm);
    end;
    
    select p.lista_error into v_recipient_bad from sfc_procesos_t p where p.id_proceso = 'ER';
    select p.lista_ok into v_recipient_ok from sfc_procesos_t p where p.id_proceso = 'ER'; 
    select e.error_des into v_error  from seg_error_t e where e.id_error = 'E08';
    

    html := html || '</table></body></html>';
    system.html_mail(v_sender,
                     v_recipient_ok,
                     'Actualizacion y Recoleccion de datos',
                     html);
  exception
    when others then
      system.html_mail(v_sender,
                       v_recipient_bad,
                       v_error,
                       sqlerrm);
  end;
  begin
  -- Anonimus block
  select lista_ok, lista_error
    into c_mail_to, c_mail_error
    from suirplus.sfc_procesos_t
   where id_proceso = 'ER';
   
end sre_estadisticas_pkg;
