create or replace package suirplus.nss_validaciones_pkg is

  -- Author  : GREGORIO HERRERA
  -- Created : 16/06/2015 10:52:06 a.m.
  -- Purpose : Contiene todas las funciones utilizadas para validar los datos de un ciudadano

  -- Valida el sexo del ciudadano
  function validar_sexo(p_sexo in varchar2) return boolean;

  -- Valida el municipio en el catalogo de municipios
  function validar_municipio(p_mun in varchar2) return boolean;

  -- Valida el municipio (para caso 777)
  function validar_municipio_777(p_municipio in varchar2) return boolean;

  -- Valida el municipio (combinado con la oficialia)
  function validar_municipio_oficialia(p_mun in varchar2, p_ofic in varchar2) return boolean;

  -- Valida el municipio y la provincia (opcional)
  function validar_municipio_provincia(p_mun in varchar2, p_prov in varchar2, p_result out varchar2) return boolean;

  -- Valida el tipo y causa de inhabilidad para la JCE
  function validar_inhabilidad_jce(p_causa in number, p_tipo in varchar2) return boolean;

  -- Valida el tipo y causa de inhabilidad para la TSS
  function validar_inhabilidad_tss(p_causa in number, p_tipo in varchar2) return char;
  -- Valida el tipo y causa de inhabilidad para la TSS para actualizaciones
  function validar_inhabilidad_tss_act(p_causa in number, p_tipo in varchar2) return char;

  -- Valida caracteres invalidos en la cadena recibida
  function validar_caracteres_invalidos(v_data in varchar2) return boolean;

  -- Valida si ciudadano existe por documento
  function validar_ciudadano_documento(p_doc in varchar2, p_tdoc in varchar2) return boolean;

  -- Valida si ciudadano existe por documento para la JCE
  function validar_ciudadano_doc_JCE(p_doc       in varchar2,
                                     p_tdoc      in varchar2,
                                     p_count     out number,
                                     p_proceso   in varchar2,
                                     p_tipocausa out varchar2,
                                     p_idcausa   out number,
                                     p_id_nss    out number,
                                     p_estado    out boolean) return boolean;

  -- Valida si ciudadano existe por NSS
  function validar_ciudadano_NSS(p_id_nss in number, p_tipo_doc char default null) return boolean;

  -- Valida el caracter como numero
  function validar_numero(p_numero in varchar2) return boolean;

  -- Valida el caracter como fecha a partir del 1/1/1900
  function validar_fecha(p_fecha in date) return boolean;

  -- Valida que la fecha no exceda la minoria de edad (17 anios)
  function validar_nacimiento(p_fecha in date) return boolean;

  -- Valida el anio del acta de nacimiento
  function validar_ano_acta(p_ano in varchar2) return boolean;

  -- Valida el anio del acta de nacimiento combinada con la fecha de nacimiento
  function validar_ano_acta_fecha(p_ano in varchar2, p_fecha in date) return boolean;

  -- Valida que todos los caracteres no sean ceros
  function validar_ceros(p_texto in varchar2) return boolean;

  -- Valida el numero del acta de nacimiento
  function validar_numero_acta (p_acta in varchar2) return boolean;

  -- Valida el libro del acta de nacimiento
  function validar_libro_acta (p_libro in varchar2) return boolean;

  -- Valida el titular del ciudadano
  function validar_titular(p_titular in number) return boolean;

  -- Valida la ARS de la afiliacion
  function validar_ars(p_ars in suirplus.ars_catalogo_t.id_ars%type) return boolean;

  -- Valida el parentesco
  function validar_parentesco(p_id_parentesco in suirplus.ars_parentescos_t.id_parentesco%type) return boolean;
  
  -- Valida si para esta ARS sus registros van al EV automaticamente
  function ars_evaluacion_visual(p_id_ars in varchar2,
                                 p_proceso in varchar2,
                                 p_id_estatus out number,
                                 p_id_error out varchar2) return boolean;

  -- Devuelve una cadena conteniendo solo numeros sin los ceros a la izquierda
  function convertir_numero(p_texto in varchar2) return varchar2;

  -- Devuelve una cadena solo con caracteres, sin ceros ni a la derecha ni a la izquierda
  function convertir_letra(p_texto in varchar2) return varchar2;

  -- Devuelve una cadena conteniendo los datos del acta en formato texto, sin ceros a la derecha ni a la izquierda
  function sinnumeros(p_nom in varchar2, p_ape in varchar2, p_sex in varchar2 default null)
  return varchar2;

  -- Devuelve la primera palabra de una palabra compuesta separada por espacio, si no tiene espacion, devuelve la palabra completa.
  function primer_nombre(p_nombres suirplus.sre_ciudadanos_t.nombres%type)
  return varchar2 DETERMINISTIC;

  -- Valida acta de nacimiento duplicada
  function acta_duplicada(p_mun in varchar2,
                          p_ano in varchar2,
                          p_num in varchar2,
                          p_fol in varchar2,
                          p_lib in varchar2,
                          p_ofi in varchar2,
                          p_proceso in varchar2,
                          p_id_estatus out number,
                          p_id_error out varchar2,
                          p_cursor out sys_refcursor) return boolean;

    -- Valida nombre duplicado, toma en cuenta primer nombre, primer apellido, sexo y la fecha de nacimiento
  function nombre_duplicado(p_nom  in varchar2,
                            p_ape  in varchar2,
                            p_fec  in varchar2,
                            p_sex in varchar2,
                            p_proceso in varchar2,
                            p_id_estatus out number,
                            p_id_error out varchar2,
                            p_cursor out sys_refcursor) return boolean;

  -- Valida acta de nacimiento duplicada combinada con el nombre
  function nombre_acta_duplicada(p_mun in varchar2,
                                 p_ano in varchar2,
                                 p_num in varchar2,
                                 p_fol in varchar2,
                                 p_lib in varchar2,
                                 p_ofi in varchar2,
                                 p_nom in varchar2,
                                 p_ape in varchar2,
                                 p_sex in varchar2,
                                 p_fec in varchar2,
                                 p_proceso in varchar2,
                                 p_id_estatus out number,
                                 p_id_error out varchar2,
                                 p_cursor out sys_refcursor) return boolean;

  -- Valida nombre y acta de nacimiento duplicada excluyendo la fecha nacimiento
  function nomacta_nofecha_duplicada(p_mun  in varchar2,
                                   p_ano  in varchar2,
                                   p_num  in varchar2,
                                   p_fol  in varchar2,
                                   p_lib  in varchar2,
                                   p_ofi in varchar2,
                                   p_nom  in varchar2,
                                   p_ape  in varchar2,
                                   p_sex in varchar2,
                                   p_proceso in varchar2,
                                   p_id_estatus out number,
                                   p_id_error out varchar2,
                                   p_cursor out sys_refcursor) return boolean;

  -- Valida nombre duplicado con su acta. Esta validacion prospera solo si el libro es diferente
  function nomacta_diflibro_duplicada(p_mun  in varchar2,
                                      p_ano  in varchar2,
                                      p_num  in varchar2,
                                      p_fol  in varchar2,
                                      p_lib  in varchar2,
                                      p_ofi in varchar2,
                                      p_nom  in varchar2,
                                      p_ape  in varchar2,
                                      p_fec  in varchar2,
                                      p_sex in varchar2,
                                      p_proceso in varchar2,
                                      p_id_estatus out number,
                                      p_id_error out varchar2,
                                      p_cursor out sys_refcursor) return boolean;

  -- Valida nombre y acta de nacimiento duplicada excluyendo el sexo
  function nomacta_nosexo_duplicada(p_mun  in varchar2,
                                    p_ano  in varchar2,
                                    p_num  in varchar2,
                                    p_fol  in varchar2,
                                    p_lib  in varchar2,
                                    p_ofi in varchar2,
                                    p_nom  in varchar2,
                                    p_ape  in varchar2,
                                    p_fec  in varchar2,
                                    p_proceso in varchar2,
                                    p_id_estatus out number,
                                    p_id_error out varchar2,
                                    p_cursor out sys_refcursor) return boolean;

  -- Valida nombre y acta de nacimiento duplicada excluyendo la fecha nacimiento y el sexo
  function nomacta_nosexofecha_duplicada(p_mun in varchar2,
                                         p_ano in varchar2,
                                         p_num in varchar2,
                                         p_fol in varchar2,
                                         p_lib in varchar2,
                                         p_ofi in varchar2,
                                         p_nom in varchar2,
                                         p_ape in varchar2,
                                         p_proceso in varchar2,
                                         p_id_estatus out number,
                                         p_id_error out varchar2,
                                         p_cursor out sys_refcursor) return boolean;

  -- Valida nombre, acta de nacimiento, tipo de documento y diferente no documento duplicado
  function nombre_acta_tip_difdoc_dup(p_mun in varchar2,
                                      p_ano in varchar2,
                                      p_num in varchar2,
                                      p_fol in varchar2,
                                      p_lib in varchar2,
                                      p_ofi in varchar2,
                                      p_nom in varchar2,
                                      p_ape in varchar2,
                                      p_sex in varchar2,
                                      p_fec in varchar2,
                                      p_tip in varchar2,
                                      p_doc in varchar2,
                                      p_proceso in varchar2,
                                      p_id_estatus out number,
                                      p_id_error out varchar2,
                                      p_cursor out sys_refcursor) return boolean;

  -- Valida nombre, acta de nacimiento, tipo documento, no documento duplicado
  function nombre_acta_tip_doc_dup(p_mun in varchar2,
                                   p_ano in varchar2,
                                   p_num in varchar2,
                                   p_fol in varchar2,
                                   p_lib in varchar2,
                                   p_ofi in varchar2,
                                   p_nom in varchar2,
                                   p_ape in varchar2,
                                   p_sex in varchar2,
                                   p_fec in varchar2,
                                   p_tip in varchar2,
                                   p_doc in varchar2,                                   
                                   p_proceso in varchar2,
                                   p_id_estatus out number,
                                   p_id_error out varchar2,
                                   p_cursor out sys_refcursor) return boolean;

  -- Valida nombre, acta de nacimiento, tipo documento duplicado
  function nombre_acta_tip_dup(p_mun in varchar2,
                               p_ano in varchar2,
                               p_num in varchar2,
                               p_fol in varchar2,
                               p_lib in varchar2,
                               p_ofi in varchar2,
                               p_nom in varchar2,
                               p_ape in varchar2,
                               p_sex in varchar2,
                               p_fec in varchar2,
                               p_tip in varchar2,
                               p_proceso in varchar2,
                               p_id_estatus out number,
                               p_id_error out varchar2,
                               p_cursor out sys_refcursor) return boolean;
                                                                                                                                        
  -- Valida nombre duplicado, toma en cuenta primer nombre, primer apellido y la fecha de nacimiento, deja el sexo
  function nombre_nosexo_duplicada(p_nom in varchar2,
                                   p_ape in varchar2,
                                   p_fec in varchar2,
                                   p_proceso in varchar2,
                                   p_id_estatus out number,
                                   p_id_error out varchar2,
                                   p_cursor out sys_refcursor) return boolean;

  -- Valida nombre duplicado, toma en cuenta primer nombre, primer apellido, sexo y la fecha de nacimiento, deja fuera los cinco campos del acta
  function validar_nombre_duplicado_JCE(p_mun      in varchar2,
                                        p_ano      in varchar2,
                                        p_num      in varchar2,
                                        p_fol      in varchar2,
                                        p_lib      in varchar2,
                                        p_ofi      in varchar2,
                                        p_nom      in varchar2,
                                        p_ape      in varchar2,
                                        p_fec      in varchar2,
                                        p_nss      out number,
                                        p_count    out number,
                                        p_proceso  in varchar2,
                                        p_estado   out boolean) return boolean;

  -- Valida datos del acta y datos del nombre en blanco
  function validar_acta_nombre_blanco(p_nom  in varchar2,
                                      p_ape1 in varchar2,
                                      p_ape2 in varchar2,
                                      p_mun  in varchar2,
                                      p_ano  in varchar2,
                                      p_num  in varchar2,
                                      p_fol  in varchar2,
                                      p_lib  in varchar2,
                                      p_ofic in varchar2,
                                      p_lit  in varchar2 default null) return boolean;

  -- Valida si hay otro dependiente con el mismo nombre, apellido y fecha de nacimiento en el nucleo familiar
  function validar_nucleo_familiar(p_nss in suirplus.ars_cartera_t.nss_titular%type,
                                   p_nombres in suirplus.sre_ciudadanos_t.nombres%type,
                                   p_primer_apellido in suirplus.sre_ciudadanos_t.primer_apellido%type,
                                   p_fecha_nacimiento in varchar2,
                                   p_proceso in varchar2) return boolean;

  -- Valida la nacionalidad en el catalogo de nacionalidades
  function validar_nacionalidad(p_nacionalidad in suirplus.sre_nacionalidad_t.id_nacionalidad%type) return boolean;

  -- Valida la provincia en el catalogo de provincias
  function validar_provincia(p_provincia in suirplus.sre_provincias_t.id_provincia%type) return boolean;

  -- Valida el flag de extranjero
  function validar_extranjero(p_extranjero in varchar2) return boolean;

  -- Valida la longitud de la imagen
  function validar_imagen(p_imagen in blob) return boolean;

  -- Valida la conformacion correcta del nombre (incluyendo los apellidos)
  function validar_nombre_correcto(p_nombres in varchar2,
                                   p_primer_apellido in varchar2,
                                   p_segundo_apellido in varchar2) return boolean;

  -- Valida la conformacion correcta del acta (seis campos del acta)
  function validar_acta_correcta(p_mun in varchar2,
                                 p_ano in varchar2,
                                 p_num in varchar2,
                                 p_fol in varchar2,
                                 p_lib in varchar2,
                                 p_ofi in varchar2,
                                 p_lit in varchar2 default null) return boolean;

  -- Limpiar la oficialia del acta, debe terminar con numeros
  function limpiar_oficialia_acta(p_ofi in varchar2) return varchar2;

  -- Limpiar el municipio del acta, debe terminar con numeros
  function limpiar_municipio_acta(p_mun in varchar2) return varchar2;

  -- Limpiar el ano del acta, debe terminar con numeros
  function limpiar_ano_acta(p_ano in varchar2) return varchar2;

  -- Limpiar el numero del acta, debe terminar con numeros
  function limpiar_numero_acta(p_num in varchar2) return varchar2;

  -- Limpiar el folio del acta, debe terminar con numeros
  function limpiar_folio_acta(p_fol in varchar2) return varchar2;

  -- Limpiar el libro del acta, debe terminar con numeros
  function limpiar_libro_acta(p_lib in varchar2, p_ano in varchar2, p_lit in out varchar2) return varchar2;

  -- Limpiar el libro del acta, debe terminar con numeros, sobrecarga que no toma een cuenta el literal
  function limpiar_libro_acta(p_lib in varchar2, p_ano in varchar2) return varchar2;

  -- Limpiar el literal del acta, debe terminar con letras
  function limpiar_literal_acta(p_lit in varchar2) return varchar2;

  -- Limpiar los datos del acta
  function limpiar_datos_acta(p_mun in varchar2, p_ano in varchar2, p_num in varchar2, p_fol in varchar2, p_lib in varchar2, p_ofi in varchar2, p_lit in varchar2, p_exc in varchar2 default null)
  return varchar2 DETERMINISTIC;

  -- Limpiar los datos del acta, sobrecarga que no toma en cuenta el literal
  function limpiar_datos_acta(p_mun in varchar2, p_ano in varchar2, p_num in varchar2, p_fol in varchar2, p_lib in varchar2, p_ofi in varchar2, p_exc in varchar2 default null)
  return varchar2 DETERMINISTIC;

  function limpiar_fecha_nacimiento(p_fecha in varchar2)
    return varchar2 DETERMINISTIC;

end;
