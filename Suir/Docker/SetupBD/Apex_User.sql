ALTER SESSION SET CURRENT_SCHEMA = APEX_040000;

BEGIN 
  -------------------------------------------------------
  --Crear el WORKSPACE 'SUIRPLUS' en APEX
  --asociandolo con el schema de base de datos 'SUIRPLUS'
  -------------------------------------------------------
  APEX_INSTANCE_ADMIN.ADD_WORKSPACE(NULL,'SUIRPLUS', 'SUIRPLUS', NULL);

  ------------------------------------------------------------------
  --Para permitir operaciones DML dentro del schema SUIRPLUS en APEX
  ------------------------------------------------------------------
  WWV_FLOW_API.SET_SECURITY_GROUP_ID(APEX_UTIL.FIND_SECURITY_GROUP_ID('SUIRPLUS'));

  ---------------------------------------------------------
  --Crear el usuario SUIRPLUS dentro de APEX y
  --asociarlo con el schema 'SUIRPLUS' y a la vez
  --con el o los WORKSPACES a los que pertenece
  --el schema default al que se asociara el usuario creado.
  ---------------------------------------------------------
  APEX_UTIL.CREATE_USER(
   p_user_name => 'SUIRPLUS',
   p_web_password => 'sp1010',
   p_default_schema => 'SUIRPLUS',
   p_change_password_on_first_use => 'N',
   p_developer_privs => 'CREATE:DATA_LOADER:EDIT:HELP:MONITOR:SQL');
  
  COMMIT;
END;
/