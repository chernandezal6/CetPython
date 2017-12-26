CREATE OR REPLACE PROCEDURE Next_Sequence(
  p_sequence_name     in  varchar2,
  p_sequence_value    out number,
  p_resultNumber      out varchar2
)
IS
  sql_str         varchar2(500);
  v_exist         integer;
  e_sequence_name exception;
  v_bderror       varchar(1000);
  
BEGIN
  
 SELECT count(*) into v_exist
   FROM user_sequences s
   Where Upper(s.sequence_name) = Upper(p_sequence_name);
   
   if v_exist > 0 then
     sql_str := 'select '||p_sequence_name||'.nextval from dual';
       execute immediate sql_str into p_sequence_value;
       p_resultNumber:= 'OK';
   else     
     RAISE e_sequence_name;
   end if;
  
EXCEPTION
  WHEN e_sequence_name THEN
    p_resultNumber := SUIRPLUS.SEG_RETORNAR_CADENA_ERROR('10', NULL, NULL);
  WHEN OTHERS THEN
    v_bderror := (substr('error '||to_char(sqlcode)||': '||sqlerrm, 1, 255));
    p_resultNumber := seg_retornar_cadena_error(-1, v_bderror,sqlcode);
END;