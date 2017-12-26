create or replace procedure suirplus.reporte_proceso_sol_diarias(p_fecha in date) is
  v_mailerror   varchar2(1000);
  v_mailfrom    varchar2(1000) := 'info@mail.tss2.gov.do';
  html          varchar2(32000);
  v_mailsubject varchar2(1000) := 'Resumen de solicitudes procesadas y rechazadas ';
  isExiste      number := 0;

BEGIN
  html := '<html><head><style> table {border-collapse: collapse;}th,td {border: 1px solid black; padding: 5px;}th {background-color: #4CAF50;color: white;}</style></head><body>';
  html := html ||
          '<h2>Resumen diario de solicitudes de asignación nss procesadas y rechazadas</h2><table border="1">';
  html := html || '<tr>' || '<th bgcolor="silver">Entidad</th>' ||
          '<th bgcolor="silver">Tipo de Solicitud</th>' ||
          '<th bgcolor="silver">OK</th>' ||
          '<th bgcolor="silver">Rechazadas</th>' || '</tr>';

  FOR r_ent in (SELECT UPPER(s.usuario_solicita) Entidad,
                       count(distinct s.id_tipo) cuantas
                  From suirplus.nss_solicitudes_t     s,
                       suirplus.nss_det_solicitudes_t d
                 WHERE s.id_tipo IN (2, 3)
                   AND s.id_solicitud = d.id_solicitud
                   and d.id_estatus in (2, 3, 6, 7)
                   AND TRUNC(s.fecha_solicitud) =trunc(nvl(p_fecha,sysdate-1))
                 group by UPPER(s.usuario_solicita)) LOOP
  
    html := html || '<tr>';
    html := html || '<td rowspan="' || r_ent.cuantas || '">' ||
            r_ent.entidad || '</td>';
  
    isExiste := 0;
    FOR r_det in (select UPPER(t.descripcion) descripcion,
                         SUM(CASE
                               WHEN d.id_estatus IN (2, 3, 7) THEN
                                1
                               ELSE
                                0
                             END) OK,
                         SUM(CASE
                               WHEN d.id_estatus = 6 THEN
                                1
                               ELSE
                                0
                             END) RE
                    from suirplus.nss_solicitudes_t s
                    join suirplus.nss_det_solicitudes_t d
                      on d.id_solicitud = s.id_solicitud
                     and d.id_tipo_documento in ('C', 'U')
                     and d.id_estatus in (2, 3, 6, 7)
                    join suirplus.nss_tipo_solicitudes_t t
                      on s.id_tipo = t.id_tipo
                   where s.usuario_solicita = r_ent.entidad
                     AND TRUNC(s.fecha_solicitud) =trunc(nvl(p_fecha,sysdate-1)) --to_date(to_char(p_fecha, 'DD-mon-YYYY'),'DD-mon-YYYY')
                   group by UPPER(t.descripcion)) LOOP
    
      if (isExiste > 0) then
        html := html || '<tr>';
      end if;
      isExiste := 1;
    
      html := html || '<td>' || r_det.descripcion || '</td>';
      html := html || '<td style="text-align: right;">' || r_det.ok ||
              '</td>';
      html := html || '<td style="text-align: right;">' || r_det.re ||
              '</td>';
      html := html || '</tr>';
    
    END LOOP;
  END LOOP;
  html := html || '</table></body></html>';

  html := replace(html, 'á', '&aacute;');
  html := replace(html, 'é', '&eacute;');
  html := replace(html, 'í', '&iacute;');
  html := replace(html, 'ó', '&oacute;');
  html := replace(html, 'ú', '&uacute;');
  html := replace(html, 'ñ', '&ntilde;');
  html := replace(html, 'Ñ', '&Ntilde;');

  --buscamos los email destino para general los reportes de solicitudes diarias de nss
  select lista_ok
    into v_mailerror
    from sfc_procesos_t s
   where s.id_proceso = '93';

  IF isExiste = 1 THEN
    system.html_mail(v_mailfrom,
                     v_mailerror,
                     'Resumen diario de solicitudes procesadas y rechazadas',
                     html);
  ELSE
    html := html ||
            '<br><b><font color= "Red">No hay solicitudes</font></b>';
    html := html || '</tr>';
    html := html || '</table>';
  
    system.html_mail(v_mailfrom,
                     v_mailerror,
                     'Resumen diario de solicitudes procesadas y rechazadas',
                     html);
  END IF;

EXCEPTION
  WHEN OTHERS THEN
    system.html_mail(v_mailfrom,
                     v_mailerror,
                     'Ocurrio un error en ' || v_mailsubject,
                     SQLERRM);
END;
