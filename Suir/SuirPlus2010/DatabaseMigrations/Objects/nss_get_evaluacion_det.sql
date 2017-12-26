CREATE OR REPLACE PROCEDURE SUIRPLUS.NSS_Get_Evaluacion_Detalle
(p_id_registro in nss_det_solicitudes_t.id_registro%type,
 P_CURSOR OUT SYS_REFCURSOR,
 p_resultnumber OUT varchar2) is 
                                   
Begin 

  open P_CURSOR for
                                   
    select ds.id_solicitud as Solicitud,
            c.id_nss as Nss,
           td.id_tipo_documento as IdTipoDoc,
           td.descripcion as TipoDoc,  
           c.tipo_documento || '-' || c.no_documento as NroDocumento,
           c.nombres as Nombres,
           c.primer_apellido || ' ' || c.segundo_apellido as Apellidos,            
           c.sexo as sexo, 
           n.nacionalidad_des as Nacionalidad,
           c.fecha_nacimiento as FechaNacimiento,
           c.municipio_acta as Municipio,
           c.ano_acta as AnoActa,
           c.numero_acta as NumeroActa,
           c.folio_acta as folioActa,
           c.libro_acta as LibroActa,
           c.oficialia_acta as OficiliaActa,
            i.cancelacion_des as Inhabilidad,
            max(to_date(ca.periodo_factura_ars,'yyyy-mm')) as periodo               
    from nss_det_evaluacion_visual_t dev
    join nss_evaluacion_visual_t ev on ev.id_evaluacion = dev.id_evaluacion
    join nss_det_solicitudes_t ds on ds.id_registro = ev.id_registro
    left join sre_ciudadanos_t c on c.id_nss = dev.id_nss
    join sre_tipo_documentos_t td on td.id_tipo_documento = ds.id_tipo_documento
    left join sre_inhabilidad_jce_t i on i.id_causa_inhabilidad = c.id_causa_inhabilidad
                                     and i.tipo_causa = c.tipo_causa
    join sre_nacionalidad_t n on n.id_nacionalidad = ds.id_nacionalidad
    left join ars_cartera_t ca on ca.nss_dependiente = c.id_nss
                              and ca.registro_dispersado = 'S'                                                              
    where ds.id_registro = p_id_registro
      and ds.id_estatus = 4  
      group by  ds.id_solicitud,
            c.id_nss,
           td.id_tipo_documento,
           td.descripcion, 
           c.tipo_documento,
           c.no_documento,
           c.nombres,
           c.primer_apellido,
           c.segundo_apellido,
           c.sexo, 
           n.nacionalidad_des,
           c.fecha_nacimiento,
           c.municipio_acta,
           c.ano_acta,
           c.numero_acta,
           c.folio_acta,
           c.libro_acta,
           c.oficialia_acta,
           i.cancelacion_des;
  
  p_resultnumber := '0';
          
EXCEPTION
  when others then
  p_resultnumber := SQLERRM;
return;  
        
End;
