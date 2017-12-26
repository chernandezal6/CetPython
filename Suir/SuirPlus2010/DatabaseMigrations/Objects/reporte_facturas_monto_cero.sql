create or replace procedure suirplus.reporte_facturas_monto_cero(p_resultnumber out varchar2) is

v_mailerror   varchar2(1000);
v_mailfrom    varchar2(1000) := 'info@mail.tss2.gov.do';
html          clob;
html2         clob;
v_mailsubject varchar2(1000) := 'Resumen de NP''s con valor 0 o Duplicadas';
isExiste      number := 0;

begin
  html := '<html><head><style> table {border-collapse: collapse;}th,td {border: 1px solid black; padding: 5px;}th {background-color: #4CAF50;color: white;}</style></head><body>';
  html := html ||
          '<h2>Resumen diario de Np''s con valor 0 </h2><table border="1">';
  html := html || '<tr>' || '<th bgcolor="silver">Nro. Referencia</th>' || '</tr>';  

  FOR r_facturas in (select *
                      from suirplus.sfc_facturas_t a
                     where a.status in ('VI', 'VE')
                       and (a.total_aporte_afiliados_sfs + a.total_aporte_empleador_sfs +
                           a.total_aporte_afiliados_svds + a.total_aporte_empleador_svds +
                           a.total_aporte_srl + a.total_per_capita_adicional +
                           a.total_aporte_afiliados_t3 + a.total_aporte_empleador_t3 +
                           a.total_aporte_voluntario) <= 0
                       and ((sysdate - a.fecha_emision) * 24 * 60) > 60) LOOP   
     
   if (r_facturas.id_referencia is not null) then
      isExiste := 1; 
      html := html || '<tr>';
      html := html || '<td>' || r_facturas.id_referencia || '</td>';     
     html := html || '<tr>';      
   end if;                     
   
   END LOOP;  
   
   html := html || '</table></body></html>';  
     
   html2 := '<html><head><style> table {border-collapse: collapse;}th,td {border: 1px solid black; padding: 5px;}th {background-color: #4CAF50;color: white;}</style></head><body>';
   html2 := html2 ||
            '<h2>Resumen diario de Np''s duplicadas </h2><table border="1">';  
   html2 := html2 || '<tr>' || '<th bgcolor="silver">Rnc o Cedula</th>'; 
   html2 := html2 || '<th bgcolor="silver">Periodo</th>'; 
   html2 := html2 || '<th bgcolor="silver">Nomina</th>' || '</tr>';   
  
  FOR r_facturas_dup in (select e.rnc_o_cedula,
                                id_nomina,
                                f.id_registro_patronal,
                                f.periodo_factura
                          from suirplus.sfc_facturas_t f
                          join suirplus.sre_empleadores_t e on e.id_registro_patronal = f.id_registro_patronal
                         where f.status not in ('CA','RE')
                           and f.id_tipo_factura <> 'U'                   
                      group by  e.rnc_o_cedula, id_nomina,f.id_registro_patronal,f.periodo_factura
                  having count(*) > 1
                       and max(f.fecha_emision)>'1-jun-2013') LOOP
               
    if (r_facturas_dup.rnc_o_cedula is not null) then
      isExiste := 1; 
      html2 := html2 || '<tr>';     
      html2 := html2 || '<td>' || r_facturas_dup.rnc_o_cedula || '</td>';
       html2 := html2 || '<td>' || r_facturas_dup.periodo_factura || '</td>';
       html2 := html2 || '<td>' || r_facturas_dup.id_nomina || '</td>';
      html2 := html2 || '</tr>';
    end if;      
  END LOOP;
  
  html2 := html2 || '</table></body></html>';
  
  html := html || '</table></body></html>';
  html := replace(html, 'á', '&aacute;');
  html := replace(html, 'é', '&eacute;');
  html := replace(html, 'í', '&iacute;');
  html := replace(html, 'ó', '&oacute;');
  html := replace(html, 'ú', '&uacute;');
  html := replace(html, 'ñ', '&ntilde;');
  html := replace(html, 'Ñ', '&Ntilde;');
  
  html2 := html2 || '</table></body></html>';
  html2 := replace(html2, 'á', '&aacute;');
  html2 := replace(html2, 'é', '&eacute;');
  html2 := replace(html2, 'í', '&iacute;');
  html2 := replace(html2, 'ó', '&oacute;');
  html2 := replace(html2, 'ú', '&uacute;');
  html2 := replace(html2, 'ñ', '&ntilde;');
  html2 := replace(html2, 'Ñ', '&Ntilde;');
  
  --buscamos los email destino para general los reportes de solicitudes diarias de nss
  select lista_ok
    into v_mailerror
    from suirplus.sfc_procesos_t s
   where s.id_proceso = 'N0';
   
  IF (isExiste = 1) THEN
    system.html_mail(v_mailfrom,
                     v_mailerror,
                     'Resumen de NP''s con valor 0 o Duplicadas',
                      html ||'</br>'||html2);
  ELSE
    html := html ||
            '<br><b><font color= "Red">No hay registros</font></b>';
    html := html || '</tr>';
    html := html || '</table>';
  
    system.html_mail(v_mailfrom,
                     v_mailerror,
                     'Resumen de NP''s con valor 0 o Duplicadas',
                     html ||'</br>'||html2);
  END IF;
  
  p_resultnumber:= '0';  

EXCEPTION
  WHEN OTHERS THEN
    system.html_mail(v_mailfrom,
                     v_mailerror,
                     'Ocurrio un error en ' || v_mailsubject,
                     SQLERRM);
end;
