CREATE OR REPLACE PROCEDURE SUIRPLUS.NSS_INSERT_DET_SOLICITUDES
(
  p_id_solicitud in suirplus.nss_det_solicitudes_t.id_solicitud%type,
  p_secuencia in suirplus.nss_det_solicitudes_t.secuencia%type,
  p_id_tipo_documento in suirplus.nss_det_solicitudes_t.id_tipo_documento%type,
  p_no_documento_sol in suirplus.nss_det_solicitudes_t.no_documento_sol%type,
  p_id_estatus in suirplus.nss_estatus_t.id_estatus%type default 1, 
  p_id_error in suirplus.seg_error_t.id_error%type default null, 
  p_nombres in suirplus.nss_det_solicitudes_t.nombres%type default null,
  p_primer_apellido in suirplus.nss_det_solicitudes_t.primer_apellido%type default null,
  p_segundo_apellido in suirplus.nss_det_solicitudes_t.segundo_apellido%type default null,
  p_fecha_nacimiento in suirplus.nss_det_solicitudes_t.fecha_nacimiento%type default null,
  p_sexo in suirplus.nss_det_solicitudes_t.sexo%type default null,
  p_id_nacionalidad in suirplus.nss_det_solicitudes_t.id_nacionalidad%type default null,
  p_municipio_acta in suirplus.nss_det_solicitudes_t.municipio_acta%type default null,
  p_ano_acta in suirplus.nss_det_solicitudes_t.ano_acta%type default null,
  p_numero_acta in suirplus.nss_det_solicitudes_t.numero_acta%type default null,
  p_folio_acta in suirplus.nss_det_solicitudes_t.folio_acta%type default null,
  p_libro_acta in suirplus.nss_det_solicitudes_t.libro_acta%type default null,
  p_oficialia_acta in suirplus.nss_det_solicitudes_t.oficialia_acta%type default null,
  p_tipo_libro_acta in suirplus.nss_det_solicitudes_t.tipo_libro_acta%type default null,
  p_literal_acta in suirplus.nss_det_solicitudes_t.literal_acta%type default null,
  p_estado_civil in suirplus.nss_det_solicitudes_t.estado_civil%type default null,
  p_id_tipo_sangre in suirplus.nss_det_solicitudes_t.id_tipo_sangre%type default null,
  p_cedula_madre in suirplus.nss_det_solicitudes_t.cedula_madre%type default null,
  p_cedula_padre in suirplus.nss_det_solicitudes_t.cedula_padre%type default null,
  p_nombre_madre in suirplus.nss_det_solicitudes_t.nombre_madre%type default null,
  p_nombre_padre in suirplus.nss_det_solicitudes_t.nombre_padre%type default null,
  p_tipo_causa in suirplus.nss_det_solicitudes_t.tipo_causa%type default null,
  p_id_causa_inhabilidad in suirplus.nss_det_solicitudes_t.id_causa_inhabilidad%type default null,
  p_fecha_cancelacion_jce in suirplus.nss_det_solicitudes_t.fecha_cancelacion_jce%type default null,
  p_estatus_jce in suirplus.nss_det_solicitudes_t.estatus_jce%type default null,
  p_imagen_solicitud in suirplus.nss_det_solicitudes_t.imagen_solicitud%type default null,
  p_imagen_acta_defuncion in suirplus.nss_det_solicitudes_t.imagen_acta_defuncion%type default null,
  p_comentario in suirplus.nss_det_solicitudes_t.comentario%type default null,
  p_extranjero in suirplus.nss_det_solicitudes_t.extranjero%type default null,
  p_id_nss_titular in suirplus.nss_det_solicitudes_t.id_nss_titular%type default null,
  p_id_parentesco in suirplus.nss_det_solicitudes_t.id_parentesco%type default null,
  p_id_ars in suirplus.nss_det_solicitudes_t.id_ars%type default null,
  p_id_nss in suirplus.nss_det_solicitudes_t.id_nss%type default null,
  p_id_control in suirplus.nss_det_solicitudes_t.id_control%type default null,
  p_num_control in suirplus.nss_det_solicitudes_t.num_control%type default null,
  p_id_certificacion in suirplus.nss_det_solicitudes_t.id_certificacion%type default null,
  p_usuario_procesa in suirplus.nss_det_solicitudes_t.usuario_procesa%type default null,
  p_fecha_procesa in suirplus.nss_det_solicitudes_t.fecha_procesa%type default null,
  p_ult_fecha_act in suirplus.nss_det_solicitudes_t.ult_fecha_act%type,
  p_ult_usuario_act in suirplus.nss_det_solicitudes_t.ult_usuario_act%type, 
  p_id in suirplus.nss_det_solicitudes_t.id%type default null,
  p_resultado out varchar2
) is
  e_solicitud_no_existe exception;
  e_solicitud_incompleta exception;  
  v_conteo pls_integer;
begin
  --Si no existe la solicitud con el tipo adecuado, si no existe termina la ejecucion
  Select count(*)
    Into v_conteo
    From suirplus.nss_solicitudes_t t
   Where t.id_solicitud = p_id_solicitud;

  IF v_conteo = 0 THEN
    RAISE e_solicitud_no_existe;
  END IF;

  if (trim(p_no_documento_sol) is null or trim(p_id_tipo_documento) is null) and
     (trim(p_nombres) is null or trim(p_primer_apellido) is null) then
    RAISE e_solicitud_incompleta;     
  end if;     
    
  insert into suirplus.nss_det_solicitudes_t
  (
    id_registro, 
    id_solicitud, 
    secuencia, 
    id_tipo_documento, 
    no_documento_sol, 
    id_estatus, 
    id_error, 
    nombres, 
    primer_apellido, 
    segundo_apellido, 
    fecha_nacimiento, 
    sexo, 
    id_nacionalidad, 
    municipio_acta, 
    ano_acta, 
    numero_acta, 
    folio_acta, 
    libro_acta, 
    oficialia_acta, 
    tipo_libro_acta, 
    literal_acta, 
    estado_civil, 
    id_tipo_sangre, 
    cedula_madre, 
    cedula_padre, 
    nombre_madre, 
    nombre_padre, 
    tipo_causa, 
    id_causa_inhabilidad, 
    fecha_cancelacion_jce, 
    estatus_jce, 
    imagen_solicitud, 
    imagen_acta_defuncion, 
    comentario, 
    extranjero, 
    id_nss_titular, 
    id_parentesco, 
    id_ars, 
    id_nss, 
    id_control, 
    num_control, 
    id_certificacion, 
    usuario_procesa, 
    fecha_procesa, 
    ult_fecha_act, 
    ult_usuario_act, 
    id
  )
  values
  (
    suirplus.nss_det_solicitudes_t_seq.nextval, 
    p_id_solicitud, 
    p_secuencia, 
    p_id_tipo_documento, 
    p_no_documento_sol, 
    p_id_estatus, 
    p_id_error, 
    p_nombres, 
    p_primer_apellido, 
    p_segundo_apellido, 
    p_fecha_nacimiento, 
    p_sexo, 
    p_id_nacionalidad, 
    p_municipio_acta, 
    p_ano_acta, 
    p_numero_acta, 
    p_folio_acta, 
    p_libro_acta, 
    p_oficialia_acta, 
    p_tipo_libro_acta, 
    p_literal_acta, 
    p_estado_civil, 
    p_id_tipo_sangre, 
    p_cedula_madre, 
    p_cedula_padre, 
    p_nombre_madre, 
    p_nombre_padre, 
    p_tipo_causa, 
    p_id_causa_inhabilidad, 
    p_fecha_cancelacion_jce, 
    p_estatus_jce, 
    p_imagen_solicitud, 
    p_imagen_acta_defuncion, 
    p_comentario, 
    p_extranjero, 
    p_id_nss_titular, 
    p_id_parentesco, 
    p_id_ars, 
    p_id_nss, 
    p_id_control, 
    p_num_control, 
    p_id_certificacion, 
    p_usuario_procesa, 
    p_fecha_procesa, 
    p_ult_fecha_act, 
    p_ult_usuario_act, 
    p_id
  );
  
  commit;  
  p_resultado := 'OK';
exception 
  when e_solicitud_no_existe then
    p_resultado := Suirplus.Seg_Retornar_Cadena_Error('181', NULL, NULL);
  when e_solicitud_incompleta then
    p_resultado := Suirplus.Seg_Retornar_Cadena_Error('NSS909', NULL, NULL);
  when others then    
    p_resultado := sqlerrm;
end;