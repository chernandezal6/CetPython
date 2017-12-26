DECLARE
  v_conteo         pls_integer;
  v_string         varchar2(32767);
  v_cadena         varchar2(32767);
  v_script_create  varchar2(32767);
  v_script_drop    varchar2(32767);  
  type t_trg_names is table of varchar2(30) index by varchar2(30);
  v_trg_names      t_trg_names;
  v_longitud       pls_integer := 30;
  v_name           varchar2(30);
BEGIN
  --Todas las tablas de SUIRPLUS
  FOR R IN(select a.TABLE_NAME, a.OWNER
           from all_tables a
           join all_tab_cols b
             on b.owner = a.owner
            and b.table_name = a.table_name
            and b.column_name = 'ULT_FECHA_ACT'
          where a.owner = 'SUIRPLUS'
            and substr(a.table_name,-2,2) = '_T'
            and a.table_name NOT LIKE '%_BAK_%'
            and a.table_name != 'SFC_FACTURAS_20121231_T'
          order by 1, 2) LOOP
    v_conteo := 0;

    --Las que tienen trigger
    FOR J in(select tr.*
               from all_triggers tr
              where tr.table_owner = R.owner
                and tr.table_name = R.table_name
                and (
                     INSTR(tr.triggering_event,'INSERT OR UPDATE') > 0 
                     OR 
                     INSTR(tr.triggering_event,'UPDATE OR INSERT') > 0 
                     )) LOOP
      v_string := J.trigger_body;
      v_string := UPPER(v_string);
      --Ver si ya existe un trigger sobre esta tabla que considera el campo ULT_FECHA_ACT en el evento before insert or update
      if INSTR(v_string, ':NEW.ULT_FECHA_ACT') > 0 then
        v_conteo := v_conteo + 1;
        exit;
      end if;  
    END LOOP;
    
    --Si no hay trigger que contenga el campo ULT_FECHA_ACT
    if v_conteo = 0 then
      --Para saber si este nombre existe
      v_longitud := 30;
      while v_longitud > 0 loop
        v_name := SUBSTR('DATE_ON_'||R.TABLE_NAME||'_TRG',1,v_longitud);
        begin
          if v_trg_names(v_name) = v_name then
            v_longitud := v_longitud - 1;
          end if;
        exception when no_data_found then
          v_trg_names(v_name) := v_name;
          exit;
        end;      
      end loop;
      
      --Para saber si la tabla tiene el campo ULT_USUARIO_ACT
      execute immediate 'select count(*) from all_tab_cols where owner = '''||R.OWNER||''' and table_name = '''||R.TABLE_NAME||''' and column_name = ''ULT_USUARIO_ACT''' into v_conteo;
      
      --Si la tabla NO tiene el campo ULT_USUARIO_ACT
      if v_conteo = 0 then
        v_cadena := '  CREATE OR REPLACE TRIGGER '||R.OWNER||'.'||v_name||chr(10)||
                    '  BEFORE INSERT OR UPDATE ON '||R.OWNER||'.'||R.TABLE_NAME||' for each row'||chr(10)||
                    '  Begin'||chr(10)||
                    '    :new.ULT_FECHA_ACT := sysdate;'||chr(10)||
                    '  End;';
      else --Si la tabla TIENE el campo ULT_USUARIO_ACT
        v_cadena := '  CREATE OR REPLACE TRIGGER '||R.OWNER||'.'||v_name||chr(10)||
                    '  BEFORE INSERT OR UPDATE ON '||R.OWNER||'.'||R.TABLE_NAME||' for each row'||chr(10)||
                    '  Begin '||chr(10)||
                    '    IF :old.ULT_USUARIO_ACT is not null AND :new.ULT_USUARIO_ACT is null THEN'||chr(10)||
                    '      :new.ULT_USUARIO_ACT := :old.ULT_USUARIO_ACT;'||chr(10)||
                    '    END IF;'||chr(10)||
                    '    :new.ULT_FECHA_ACT := sysdate;'||chr(10)||
                    '  End;';
      end if;
      
      v_script_create := v_script_create || '  EXECUTE IMMEDIATE '''||chr(10)||v_cadena||''';'||chr(10)||chr(10);
    
      v_cadena := '  DECLARE'||chr(10)||
                  '    v_conteo pls_integer;'||chr(10)||
                  '  BEGIN'||chr(10)||
                  '    select count(*) into v_conteo from all_triggers where table_owner = '''''||R.OWNER||''''' and trigger_name = '''''||v_name||''''';'||chr(10)||chr(13)||
                  '    if v_conteo > 0 then'||chr(10)||
                  '      EXECUTE IMMEDIATE ''''DROP TRIGGER '||R.owner||'.'||v_name||''''';'||chr(10)||
                  '    end if;'||chr(10)||
                  '  END;';
    
      v_script_drop := v_script_drop || '  EXECUTE IMMEDIATE '''||chr(10)||v_cadena||''';'||chr(10)||chr(10);
    end if;
  END LOOP;

  If v_string IS NOT NULL Then
    dbms_output.put_line('BEGIN'||chr(10)||v_script_create ||'END;');
    dbms_output.put_line(chr(10)||'-- ===================================================== --');        
    dbms_output.put_line(         '-- Script para borrar los triggers que acabamos de crear --');
    dbms_output.put_line(         '-- ===================================================== --');    
    dbms_output.put_line('BEGIN'||chr(10)|| v_script_drop ||'END;');
  End if;  
END;