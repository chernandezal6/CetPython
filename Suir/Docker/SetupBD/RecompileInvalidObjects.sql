BEGIN
  FOR cur_rec IN (SELECT owner,
                         object_name,
                         object_type,
                         DECODE(owner, 'SUIRPLUS', 1, 'UN_ACCESO_EXTERIOR', 2, 'UNIPAGO', 2, 'SISALRIL_SUIR', 2, 'ANALISIS_SUIR', 2, 3) AS owner_order,
                         DECODE(object_type, 'PACKAGE', 1, 'TYPE', 1, 2) AS recompile_order
                   FROM  dba_objects
                  WHERE  owner in ('SUIRPLUS', 'UNIPAGO', 'UN_ACCESO_EXTERIOR', 'SISALRIL_SUIR')
                    AND  object_type IN ('PACKAGE', 'PACKAGE BODY', 'PROCEDURE', 'FUNCTION', 'VIEW', 'MATERIALIZED VIEW', 'TRIGGER', 'TYPE', 'TYPE BODY', 'SYNONYM')
                    AND  status != 'VALID'
                  ORDER BY 4, 5)
  LOOP
    BEGIN
      IF cur_rec.object_type = 'PACKAGE BODY' THEN
        EXECUTE IMMEDIATE 'ALTER PACKAGE ' || cur_rec.owner || '.' || cur_rec.object_name || ' COMPILE BODY';
      ELSIF cur_rec.object_type = 'TYPE BODY' THEN
        EXECUTE IMMEDIATE 'ALTER TYPE ' || cur_rec.owner || '.' || cur_rec.object_name || ' COMPILE BODY';  
      ELSE
        EXECUTE IMMEDIATE 'ALTER ' || cur_rec.object_type || ' ' || cur_rec.owner || '.' || cur_rec.object_name || ' COMPILE';
      END IF;  
    EXCEPTION WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
    END;
  END LOOP;
END;
/
exit