declare
userexist integer;
begin
  select count(*) into userexist from dba_users where username='SUIRPLUS';

  if (userexist = 1) then
  	--execute immediate 'DROP TRIGGER SUIRPLUS.CVS_AUDITORIA_BEFORE_TRG';
    execute immediate 'DROP USER SUIRPLUS CASCADE';
  end if;

  select count(*) into userexist from dba_users where username='UNIPAGO';

  if (userexist = 1) then
    execute immediate 'DROP USER UNIPAGO';
  end if;

  select count(*) into userexist from dba_users where username='UN_ACCESO_EXTERIOR';

  if (userexist = 1) then
    execute immediate 'DROP USER UN_ACCESO_EXTERIOR';
  end if;
end;
/
exit;