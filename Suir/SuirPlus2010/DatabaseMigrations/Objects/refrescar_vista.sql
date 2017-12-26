CREATE OR REPLACE FUNCTION suirplus.REFRESCAR_VISTA(p_nombre_vista in varchar2, p_refrescar_vista in char) RETURN VARCHAR2 IS
BEGIN
  If UPPER(NVL(TRIM(p_refrescar_vista), 'S')) = 'S' Then
    -- Validar si el nombre de la vista viene en blanco
    If NVL(TRIM(p_nombre_vista), '~') = '~' Then
      return SUIRPLUS.SEG_RETORNAR_CADENA_ERROR('243', NULL, NULL);
    Else   
      EXECUTE IMMEDIATE 'BEGIN SYS.DBMS_SNAPSHOT.REFRESH(''suirplus.'||p_nombre_vista||'''); END;'; 
    End if;  
  End if;  
  return NULL;
EXCEPTION WHEN OTHERS THEN
  return SQLERRM;  
END;