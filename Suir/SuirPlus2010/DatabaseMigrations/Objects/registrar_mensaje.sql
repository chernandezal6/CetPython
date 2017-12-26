CREATE OR REPLACE PROCEDURE suirplus.REGISTRAR_MENSAJE(
  p_id_proceso suirplus.sfc_procesos_t.id_proceso%type,
  p_mensaje    suirplus.seg_msg_t.mensaje%type,
  p_status     suirplus.seg_msg_t.status%type,
  p_result     out varchar2
) is
  v_canal      suirplus.sfc_procesos_t.proceso_ejecutar%type;
  v_usuarios   suirplus.sfc_procesos_t.lista_ok%type;
  E_ID_PROCESO Exception;
  E_STATUS     Exception;
  E_CANAL      Exception;
  E_USUARIOS   Exception;
BEGIN
  --Validamos los parametros de entrada
  If NVL(p_id_proceso, '~') = '~' then
    RAISE E_ID_PROCESO;
  Elsif NVL(p_status, '~') = '~' then
    RAISE E_STATUS;  
  End if;

  --Puede dar NO_DATA_FOUND si el proceso no existe. Controlado en las Excepciones.
  Select proceso_validar, lista_ok
    Into v_canal, v_usuarios
    From suirplus.sfc_procesos_t p
   Where p.id_proceso = p_id_proceso;

  --Validamos las variables de configuracion del proceso
  If NVL(TRIM(v_canal), '~') = '~' Then
    RAISE E_CANAL;
  Elsif NVL(TRIM(v_usuarios), '~') = '~' Then
    RAISE E_USUARIOS;
  End if;

  --Creamos el registro
  INSERT INTO suirplus.seg_msg_t
  (Id, Id_Proceso, Mensaje, Canal, Usuarios, Status, Fecha_Registro)
  VALUES
  (SUIRPLUS.SEG_MSG_T_SEQ.NEXTVAL, p_id_proceso, p_mensaje, v_canal, v_usuarios, p_status, Sysdate);
    
  commit;    
    
  p_result := 'OK';
EXCEPTION 
  WHEN E_ID_PROCESO THEN
    p_result := SUIRPLUS.SEG_RETORNAR_CADENA_ERROR('236', NULL, NULL);
  WHEN E_STATUS THEN  
    p_result := SUIRPLUS.SEG_RETORNAR_CADENA_ERROR('237', NULL, NULL);
  WHEN E_CANAL THEN
    p_result := SUIRPLUS.SEG_RETORNAR_CADENA_ERROR('238', NULL, NULL);
  WHEN E_USUARIOS THEN      
    p_result := SUIRPLUS.SEG_RETORNAR_CADENA_ERROR('239', NULL, NULL);
  WHEN NO_DATA_FOUND THEN
    p_result := SUIRPLUS.SEG_RETORNAR_CADENA_ERROR('240', NULL, NULL);
  WHEN OTHERS THEN
    p_result := substr('ERROR CODE: ' || to_char(SQLCODE) || chr(13) || chr(10) ||
                       'ERROR MESSAGE: '|| SQLERRM, 1, 200);
END;