create or replace procedure suirplus.sfc_rep_empleadores_deudores_p(p_resultnumber out varchar2) is

v_porcentaje  number(3);
v_mailerror   varchar2(1000);
v_mailfrom    varchar2(1000) := 'info@mail.tss2.gov.do';
html          clob;
v_fecha       varchar2(10);
v_mailsubject varchar2(1000) := '';
isExiste      number := 0;

BEGIN

 select to_number(c.field3)
   into v_porcentaje
   from suirplus.srp_config_t c
  where c.id_modulo = 'HIST_DEUDA';

  html := '<html><head><style> table {border-collapse: collapse;}th,td {border: 1px solid black; padding: 5px;}th {background-color: #4CAF50;color: white;}</style></head><body>';
  html := html ||
          '<h2></h2><table border="1">';
  html := html || '<tr>' || '<th bgcolor="silver">RNC o Cédula</th>' ||
          '<th bgcolor="silver">Razón Social</th>' ||
          '<th bgcolor="silver">Deuda de ayer</th>' ||
          '<th bgcolor="silver">Deuda de hoy</th>' ||
          '<th bgcolor="silver">Pagos del día</th>' || '</tr>';

FOR r_deuda in (with pagos_hoy as
                     (select f.id_registro_patronal,
                         sum(f.total_general_factura) total_general_factura
                        from suirplus.sfc_facturas_v f
                       where trunc(f.fecha_registro_pago) = trunc(sysdate)
                         and f.status = 'PA'
                    group by f.id_registro_patronal)
                      select e.rnc_o_cedula,
                             e.razon_social,
                             to_char(ha.total_deuda, '999,999,999,999,999,990.00') as deuda_ayer,
                             to_char(nvl(h.total_deuda,0), '999,999,999,999,999,990.00') as deuda_hoy,
                             to_char(nvl(f.total_general_factura,0), '999,999,999,999,999,990.00') as pagos_del_dia
                        from suirplus.sfc_historico_deudores_t ha
                   left join suirplus.sfc_historico_deudores_t h
                          on h.id_registro_patronal = ha.id_registro_patronal
                         and h.fecha=trunc(sysdate)
                        join suirplus.sre_empleadores_t e
                          on e.id_registro_patronal = ha.id_registro_patronal
                   left join pagos_hoy f
                          on f.id_registro_patronal = ha.id_registro_patronal
                       where ha.fecha = trunc(sysdate)-1
                         and (nvl(h.total_deuda,0) / ha.total_deuda ) < (v_porcentaje / 100)
                    order by h.fecha desc) LOOP

 If (r_deuda.rnc_o_cedula is not null) then
   isExiste := 1;
   html := html || '<tr>';
   html := html || '<td>' || r_deuda.rnc_o_cedula || '</td>';
   html := html || '<td>' || r_deuda.razon_social || '</td>';
   html := html || '<td style="text-align: right";>' || r_deuda.deuda_ayer || '</td>';
   html := html || '<td style="text-align: right";>' || r_deuda.deuda_hoy || '</td>';
   html := html || '<td style="text-align: right";>' || r_deuda.pagos_del_dia || '</td>';
   html := html || '</tr>';
  End if;

  END LOOP;

  html := replace(html, 'á', '&aacute;');
  html := replace(html, 'é', '&eacute;');
  html := replace(html, 'í', '&iacute;');
  html := replace(html, 'ó', '&oacute;');
  html := replace(html, 'ú', '&uacute;');
  html := replace(html, 'ñ', '&ntilde;');
  html := replace(html, 'Ñ', '&Ntilde;');


--buscamos los email destino para generar el resumen de empleadores deudores
select lista_ok
  into v_mailerror
  from suirplus.sfc_procesos_t s
 where s.id_proceso = 'ED';

select to_char(trunc(sysdate), 'dd/mm/yyyy')
into v_fecha
from dual;

 v_mailsubject := 'Empleadores que redujeron su deuda a menos de un ' || v_porcentaje || '%' || ' del ' || v_fecha;

 IF (isExiste = 1) THEN
   html := html || '</table></body></html>';
   system.html_mail(v_mailfrom, v_mailerror, v_mailsubject, html);
  ELSE
    html := html ||
            '<br><b><font color= "Red">No hay registros</font></b>';
    html := html || '</table></body></html>';
    system.html_mail(v_mailfrom, v_mailerror, v_mailsubject, html);
  END IF;
  p_resultnumber:= '0';

EXCEPTION
  WHEN OTHERS THEN
    system.html_mail(v_mailfrom,
                     v_mailerror,
                     'Ocurrio un error en ' || v_mailsubject,  SQLERRM);
END;
