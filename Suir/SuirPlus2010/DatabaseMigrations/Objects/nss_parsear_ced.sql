CREATE OR REPLACE FUNCTION SUIRPLUS.NSS_PARSEAR_CED(P_CADENA IN VARCHAR2, P_CAMPO IN VARCHAR2)
return varchar2 is
  resultado varchar2(2000);
  m_campo   varchar2(2000);
BEGIN
  m_campo := upper(p_campo);

  --verificar si el campo solicitado existe
  if (p_cadena not like '%<'||m_campo||'>%') or (p_cadena not like '%</'||m_campo||'>%') then
    resultado := null;
  else
    SELECT SUBSTR(p_cadena, str_start, str_end - str_start)
    into resultado
    FROM (
        SELECT INSTR(p_cadena, '<'||m_campo||'>') + LENGTH('<'||m_campo||'>') AS str_start
             , INSTR(p_cadena, '</'||m_campo||'>')                            AS str_end
          FROM dual
    );
  end if;
  return resultado;
EXCEPTION
  WHEN OTHERS THEN
    raise_application_error(-20000,'WEBSERVICE CEDULADO - error al parsear:'||p_campo||' en '||p_cadena);
END;