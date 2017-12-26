create or replace procedure suirplus.ars_cobertura_fono_senasa_p as
  mail_from varchar2(1000) := 'info@mail.tss2.gov.do';
  mail_to   varchar2(1000);
  mail_err  varchar2(1000);
 
  HTML      VARCHAR2(2000);
  v_titulo  varchar2(150);
begin
  v_titulo := 'Actualizacion de Tabla ARS_COBERTURA_FONOMAT_DIARIA';
  html := '<html><head><title>'||v_titulo||'</title></head><body>';
  html := html||'<table border=1><tr><th bgcolor=silver>Proceso</th><th bgcolor=silver align=right>Seg.</th></tr>';
    
   Select p.lista_ok, p.lista_error
    Into mail_to, mail_err
   From suirplus.sfc_procesos_t p
   Where p.id_proceso = 'AF';

  --refrescar la vista
  --execute immediate 'begin sys.dbms_snapshot.refresh(''SUIRPLUS.ARS_COBERTURA_DIARIA''); end;';
  --truncar la tabla
  execute immediate 'truncate table suirplus.ars_cobertura_fonomat_diaria';
  
  for cobertura in (
    with afiliados as (
      select t.ars,t.nss titular, t.nss dependiente,'T' tipo_afiliado, '0' parentesco
      from suirplus.tss_titulares_ars_ok_pe_mv t
      union all
      select d.ars, d.nss_titular titular, d.nss_dependiente dependiente, 
             case when d.cve_parentesco in ('3','4','5','6','17','18','19','20') then 'D' else 'A' end tipo_afiliado,
             trim(to_char(d.cve_parentesco)) parentesco
      from suirplus.tss_dependientes_ok_pe_mv d
    )
    select e.rnc_o_cedula         rnc,
           a.codigo_ars           ars,
           a.periodo_factura      periodo,
           a.nss_titular          nsstit, 
           b.dependiente          nssdep,
           b.tipo_afiliado        tipo,
           c.nombres              nombre,
           c.primer_apellido      apellido1,
           c.segundo_apellido     apellido2,
           c.no_documento         cedula,
           c.sexo                 sexo,
           c.fecha_nacimiento     fecnac,
           c.estado_civil         estadocivil,
           b.parentesco
    from suirplus.ars_cobertura_diaria  a
    left join suirplus.sfc_facturas_t f on f.id_referencia=a.id_referencia
    left join suirplus.sre_empleadores_t e on e.id_registro_patronal=f.id_registro_patronal
    left join afiliados b on b.titular=a.nss_titular
    left join suirplus.sre_ciudadanos_t c on c.id_nss=b.dependiente
  ) loop
    insert into suirplus.ars_cobertura_fonomat_diaria (
      rnc,  
      ars,
      periodo,
      nsstit, 
      nssdep,
      tipo,
      nombre,
      apellido1,
      apellido2,
      cedula,
      sexo,
      fecnac,
      estadocivil,
      parentesco
    ) values (
      cobertura.rnc,
      cobertura.ars,
      cobertura.periodo,
      cobertura.nsstit, 
      cobertura.nssdep,
      cobertura.tipo,
      cobertura.nombre,
      cobertura.apellido1,
      cobertura.apellido2,
      cobertura.cedula,
      cobertura.sexo,
      cobertura.fecnac,
      cobertura.estadocivil,
      cobertura.parentesco
    );
    commit;
  end loop;       
  system.html_mail(mail_from,mail_to,v_titulo,html);
exception 
when others then
  system.html_mail(mail_from,mail_err,'Error en '||v_titulo,sqlerrm);
end; 
 