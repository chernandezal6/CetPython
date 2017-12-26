BEGIN
  FOR c IN
  (SELECT c.owner, c.table_name, c.constraint_name
   FROM all_constraints c, all_tables t
   WHERE t.owner in ('SUIRPLUS','UNIPAGO','UN_ACCESO_EXTERIOR','SISALRIL_SUIR','ANALISIS_SUIR')
   AND c.table_name = t.table_name
   AND c.status = 'DISABLED'
   ORDER BY c.constraint_type)
  LOOP

    BEGIN

      dbms_utility.exec_ddl_statement('alter table "' || c.owner || '"."' || c.table_name || '" enable NOVALIDATE constraint ' || c.constraint_name);
      
      exception when others then
      dbms_output.put_line(sqlerrm);

    end;
    
  END LOOP;

  dbms_utility.exec_ddl_statement('alter trigger suirplus.asignar_nss_trg enable');  
  
END;
/
exit