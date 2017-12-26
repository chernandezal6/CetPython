CREATE OR REPLACE FUNCTION SUIRPLUS.NSS_PARSEAR_NUI(p_cadena in varchar2, p_campo in varchar2)
  RETURN VARCHAR2 IS
    resultado varchar2(4000);
BEGIN
  --verificar si el campo solicitado existe
  if (p_cadena not like '%<'||upper(p_campo)||'>%') or (p_cadena not like '%</'||upper(p_campo)||'>%') then
    if (p_cadena like '%<'||upper(p_campo)||' />%') or (p_cadena like '%<'||upper(p_campo)||'/>%') then
      resultado := null;
    else
      resultado := 'campo '||p_campo||' no existe';
    end if;
  else
    SELECT SUBSTR(p_cadena, str_start, str_end - str_start)
    into resultado
    FROM (
        SELECT INSTR(p_cadena, '<'||upper(p_campo)||'>') + LENGTH('<'||upper(p_campo)||'>') AS str_start
             , INSTR(p_cadena, '</'||upper(p_campo)||'>')                                   AS str_end
          FROM dual
    );
  end if;
  return resultado;
EXCEPTION 
  WHEN OTHERS THEN
    raise_application_error(-20000,'WEBSERVICE NUI - error al parsear:'||p_campo||' en '||p_cadena);
END;