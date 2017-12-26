CREATE OR REPLACE PROCEDURE InsertarMensajeInbox(p_id_registro_patronal IN SRE_EMPLEADORES_T.id_registro_patronal%TYPE,
												p_mensaje               in sre_mensajes_t.mensaje%type,
												p_asunto                in sre_mensajes_t.asunto%type,
												p_usuario               in seg_usuario_t.id_usuario%type,
												p_resultnumber          out Varchar2)
   IS    
   v_id_mensaje number(10);
   v_bderror    varchar2(1000);   

  BEGIN 
  
   select max(m.id_mensaje)+1  
   into v_id_mensaje
   from suirplus.sre_mensajes_t m;  
   
  if v_id_mensaje is null then 
      v_id_mensaje := 1;  
      
      insert into suirplus.sre_mensajes_t
            (id_mensaje,
              id_registro_patronal,
              mensaje,
              fecha_registro,
              status,
              usuario_leido,
              asunto,
              usuario_archivado)
       values
               (v_id_mensaje,
                p_id_registro_patronal,
                p_mensaje,
                sysdate,
                'P', 
                null,
                p_asunto,
                p_usuario);
   else 
      insert into suirplus.sre_mensajes_t
          (id_mensaje,
            id_registro_patronal,
            mensaje,
            fecha_registro,
            status,
            usuario_leido,
            asunto,
            usuario_archivado)
      values
             (v_id_mensaje,
              p_id_registro_patronal,
              p_mensaje,
              sysdate,
              'P', 
              null,
              p_asunto,
              p_usuario);
   
   end if;  
           
   commit;  
   p_resultnumber := '0';

EXCEPTION 
  WHEN OTHERS THEN
    v_bderror := (substr('error '||to_char(sqlcode)||': '||sqlerrm, 1, 255));
    p_resultNumber := seg_retornar_cadena_error(-1, v_bderror,sqlcode);
END;
