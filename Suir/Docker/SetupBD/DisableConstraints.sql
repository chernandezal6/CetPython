BEGIN

  --dbms_utility.exec_ddl_statement('drop trigger SUIRPLUS.asignar_nss_trg');
  dbms_utility.exec_ddl_statement('alter trigger SUIRPLUS.asignar_nss_trg disable');  

  FOR c IN
  (SELECT c.owner, c.table_name, c.constraint_name
   FROM all_constraints c, all_tables t
   WHERE t.owner in ('SUIRPLUS','UNIPAGO','UN_ACCESO_EXTERIOR','SISALRIL_SUIR','ANALISIS_SUIR')
   AND c.table_name = t.table_name
   AND c.status = 'ENABLED'
   AND NOT (t.iot_type IS NOT NULL AND c.constraint_type = 'P')
   ORDER BY c.constraint_type DESC)
  LOOP

    BEGIN

      dbms_utility.exec_ddl_statement('alter table "' || c.owner || '"."' || c.table_name || '" disable constraint ' || c.constraint_name);

      exception when others then
        dbms_output.put_line(sqlerrm);
        
    END;

  END LOOP;

END;
/
exit;