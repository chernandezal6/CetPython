declare
  userexist integer;
begin
  -- Creacion del usuario SUIRPLUS
  select count(*) into userexist from dba_users where username='SUIRPLUS';

  if (userexist = 0) then
    execute immediate 'CREATE USER SUIRPLUS IDENTIFIED BY sp1010 DEFAULT TABLESPACE USERS';
  end if;

-- Creacion del usuario UNIPAGO
  select count(*) into userexist from dba_users where username='UNIPAGO';

  if (userexist = 0) then
    execute immediate 'CREATE USER UNIPAGO IDENTIFIED BY sp1010 DEFAULT TABLESPACE USERS';
  end if;

  -- Creacion del usuario UN_ACCESO_EXTERIOR
  select count(*) into userexist from dba_users where username='UN_ACCESO_EXTERIOR';

  if (userexist = 0) then
    execute immediate 'CREATE USER UN_ACCESO_EXTERIOR IDENTIFIED BY sp1010 DEFAULT TABLESPACE USERS';
  end if;

  -- Creacion del usuario SISALRIL_SUIR
  select count(*) into userexist from dba_users where username='SISALRIL_SUIR';

  if (userexist = 0) then
    execute immediate 'CREATE USER SISALRIL_SUIR IDENTIFIED BY sp1010 DEFAULT TABLESPACE USERS';
  end if;

  -- Creacion del usuario ANALISIS_SUIR
  select count(*) into userexist from dba_users where username='ANALISIS_SUIR';

  if (userexist = 0) then
    execute immediate 'CREATE USER ANALISIS_SUIR IDENTIFIED BY sp1010 DEFAULT TABLESPACE USERS';
  end if;

  -- Creacion del usuario USRMAILER
  select count(*) into userexist from dba_users where username='USRMAILER';

  if (userexist = 0) then
    execute immediate 'CREATE USER USRMAILER IDENTIFIED BY sp1010 DEFAULT TABLESPACE USERS';
  end if;

  -- Creacion del usuario USRARCHIVOS_PY
  select count(*) into userexist from dba_users where username='USRARCHIVOS_PY';

  if (userexist = 0) then
    execute immediate 'CREATE USER USRARCHIVOS_PY IDENTIFIED BY sp1010 DEFAULT TABLESPACE USERS';
  end if;

  -- Creacion del usuario USRPENSIONADOS_SEH
  select count(*) into userexist from dba_users where username='USRPENSIONADOS_SEH';

  if (userexist = 0) then
    execute immediate 'CREATE USER USRPENSIONADOS_SEH IDENTIFIED BY sp1010 DEFAULT TABLESPACE USERS';
  end if;

  -- Creacion del usuario USRCRYPTONACHA
  select count(*) into userexist from dba_users where username='USRCRYPTONACHA';

  if (userexist = 0) then
    execute immediate 'CREATE USER USRCRYPTONACHA IDENTIFIED BY sp1010 DEFAULT TABLESPACE USERS';
  end if;

  -- Asignacion de privilegios a todos los usuarios creados
  execute immediate 'GRANT DBA to SUIRPLUS WITH ADMIN OPTION';
  execute immediate 'GRANT DBA to UNIPAGO WITH ADMIN OPTION';
  execute immediate 'GRANT DBA to UN_ACCESO_EXTERIOR WITH ADMIN OPTION';
  execute immediate 'GRANT DBA to SISALRIL_SUIR WITH ADMIN OPTION';  
  execute immediate 'GRANT DBA to ANALISIS_SUIR WITH ADMIN OPTION';    
  execute immediate 'GRANT DBA to USRMAILER WITH ADMIN OPTION';  
  execute immediate 'GRANT DBA to USRARCHIVOS_PY WITH ADMIN OPTION';  
  execute immediate 'GRANT DBA to USRPENSIONADOS_SEH WITH ADMIN OPTION';  
  execute immediate 'GRANT DBA to USRCRYPTONACHA WITH ADMIN OPTION';  

  execute immediate 'GRANT ALL privileges to SYSTEM';
  execute immediate 'GRANT ALL privileges to SUIRPLUS';
  execute immediate 'GRANT ALL privileges to UNIPAGO';
  execute immediate 'GRANT ALL privileges to UN_ACCESO_EXTERIOR';
  execute immediate 'GRANT ALL privileges to SISALRIL_SUIR';
  execute immediate 'GRANT ALL privileges to ANALISIS_SUIR';    
  execute immediate 'GRANT ALL privileges to USRMAILER';    
  execute immediate 'GRANT ALL privileges to USRARCHIVOS_PY';    
  execute immediate 'GRANT ALL privileges to USRPENSIONADOS_SEH';    
  execute immediate 'GRANT ALL privileges to USRCRYPTONACHA';    

  execute immediate 'CREATE DIRECTORY DOCKER AS ''/u01/app/oracle/product/11.2.0/xe/docker''';
  execute immediate 'ALTER DATABASE DATAFILE ''/u01/app/oracle/oradata/XE/system.dbf'' AUTOEXTEND ON NEXT 1M MAXSIZE 1024M';
EXCEPTION
    WHEN OTHERS THEN
      dbms_output.put_line('Error message was: ' || SQLERRM);
end;
/
exit;