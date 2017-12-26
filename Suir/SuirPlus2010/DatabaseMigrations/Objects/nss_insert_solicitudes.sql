CREATE OR REPLACE PROCEDURE SUIRPLUS.NSS_INSERT_SOLICITUDES
(
 p_id_tipo in suirplus.nss_solicitudes_t.id_tipo%type, 
 p_usuario_solicita in suirplus.nss_solicitudes_t.usuario_solicita%type, 
 p_fecha_solicitud in suirplus.nss_solicitudes_t.fecha_solicitud%type, 
 p_id_registro_patronal in suirplus.nss_solicitudes_t.id_registro_patronal%type, 
 p_ult_fecha_act in suirplus.nss_solicitudes_t.ult_fecha_act%type, 
 p_ult_usuario_act in suirplus.nss_solicitudes_t.ult_usuario_act%type,
 p_id_solicitud out suirplus.nss_solicitudes_t.id_solicitud%type,
 p_resultado out varchar2
) is
  e_tipo_sol_no_existe exception;
  e_registro_patronal_no_existe exception;
  v_conteo pls_integer;
begin
  --Si no existe la solicitud con el tipo adecuado, si no existe termina la ejecucion
  Select count(*)
    Into v_conteo
    From suirplus.nss_tipo_solicitudes_t t
   Where t.id_tipo = p_id_tipo;

  IF v_conteo = 0 THEN
    RAISE e_tipo_sol_no_existe;
  END IF;

  --Si no existe el registro patronal
  Select count(*)
    Into v_conteo
    From suirplus.sre_empleadores_t e
   Where e.id_registro_patronal = p_id_registro_patronal;

  IF v_conteo = 0 THEN
    RAISE e_registro_patronal_no_existe;
  END IF;

  insert into suirplus.nss_solicitudes_t
  (
   id_solicitud, 
   id_tipo, 
   usuario_solicita, 
   fecha_solicitud, 
   id_registro_patronal, 
   ult_fecha_act, 
   ult_usuario_act
  )
  values
  (
   suirplus.nss_solicitudes_t_seq.nextval,
   p_id_tipo, 
   p_usuario_solicita, 
   p_fecha_solicitud, 
   p_id_registro_patronal, 
   p_ult_fecha_act, 
   p_ult_usuario_act
  ) returning id_solicitud into p_id_solicitud;
  
  commit;  
  p_resultado := 'OK';
exception 
  when e_tipo_sol_no_existe then
    p_resultado := Suirplus.Seg_Retornar_Cadena_Error('178', NULL, NULL);
  when e_registro_patronal_no_existe then
    p_resultado := suirplus.seg_retornar_cadena_error('3',null,null);
  when others then    
    p_resultado := sqlerrm;
end;