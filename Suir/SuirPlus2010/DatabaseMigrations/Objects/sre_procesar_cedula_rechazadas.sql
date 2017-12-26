create or replace procedure suirplus.sre_procesar_cedula_rechazadas(p_id_recepcion  in suirplus.sre_archivos_t.id_recepcion%type,
                                                           p_resultnumber out varchar2) is
                                                           
 v_RegistroPatronal  suirplus.sre_empleadores_t.id_registro_patronal%type;     
 v_secuencia        number;                                    
 v_idSolicitud      number(10);
 v_conteo           pls_integer;
 e_solicitud_no_existe  exception;

BEGIN
    for archivo in (select a.rowid id, a.*, e.id_registro_patronal
                      from sre_archivos_t a,
                           sre_empleadores_t e
                     where e.rnc_o_cedula = a.id_rnc_cedula and e.solicitud_nss_aut = 'S'
                       and a.id_recepcion = p_id_recepcion
                       and a.id_tipo_movimiento in ('NV', 'AM', 'AR')
                       and a.status in ('P', 'R')
                       and a.id_error not in('0','000')) loop
                    
      v_secuencia := 1;
     
     -- obtener el Reg. Pat.
       v_RegistroPatronal:= archivo.id_registro_patronal;
        
       select count(*) 
         into v_conteo
       from sre_tmp_movimiento_t
       where id_error = '24'
         and id_recepcion = p_id_recepcion;
         
         if v_conteo > 0 then
            nss_insert_solicitudes( p_id_tipo => 3,p_usuario_solicita => archivo.usuario_carga,p_fecha_solicitud => trunc(sysdate),
                                   p_id_registro_patronal => v_RegistroPatronal,p_ult_fecha_act => archivo.ult_fecha_act,
                                   p_ult_usuario_act => archivo.usuario_carga, p_id_solicitud => v_idSolicitud, p_resultado => p_resultnumber);
         
             for detalle in (select d.rowid id, d.*
                               from sre_tmp_movimiento_t d
                              where d.id_recepcion = p_id_recepcion
                                and d.id_error = '24') loop     

                   if v_idSolicitud <> 0 then
                        nss_insert_det_solicitudes( p_id_solicitud => v_idSolicitud, 
                                                  p_secuencia =>  v_secuencia, 
                                                  p_id_tipo_documento => detalle.tipo_documento, 
                                                  p_no_documento_sol => detalle.no_documento, 
                                                  p_id_estatus => 1 , 
                                                  p_ult_fecha_act => trunc(sysdate), 
                                                  p_ult_usuario_act => detalle.ult_usuario_act, 
                                                  p_resultado => p_resultnumber); 
                        
                    end if;   
                      v_secuencia := v_secuencia + 1;
                   end loop;
        else
           p_resultnumber:= '1'; 
        end if;
 
      --agreado por: CMHA
       --fecha : 16/11/2016 
       --enviamos un  mensaje al empleador quien solicitad      
       if v_RegistroPatronal is not null then
          --InsertarMensajeInbox(p_id_registro_patronal => v_RegistroPatronal ,p_mensaje => 'Solicitud de asignación de NSS procesada correctamente. Solicitud número - '||v_idSolicitud  ,p_asunto => 'Solicitud de Asignación de NSS',p_usuario => archivo.usuario_carga,p_resultnumber => p_resultnumber);
            InsertarMensajeInbox(p_id_registro_patronal => v_RegistroPatronal ,p_mensaje => 'Se ha creado la solicitud de asignación de NSS número- '||v_idSolicitud||' '||'para las cédulas no registradas en TSS de su archivo de '||archivo.id_tipo_movimiento||' número de envío - '||archivo.id_recepcion ,p_asunto => 'Solicitud de Asignación de NSS',p_usuario => archivo.usuario_carga,p_resultnumber => p_resultnumber);

          if (p_resultnumber ='0' and  v_idSolicitud is not null) then
               --buscamos los cedulados no encontrados en el WebServices de la JCE
               NSS_VALIDAR_SOL_CEDULADOS(p_id_solicitud => v_idSolicitud ,p_ult_usuario_act => archivo.usuario_carga  ,p_resultado => p_resultnumber);
          end if; 
       end if;       
 
 end loop;
exception
  when e_solicitud_no_existe then
    p_resultnumber := Suirplus.Seg_Retornar_Cadena_Error('181', NULL, NULL);
  when others then
    p_resultnumber := sqlerrm;
end;