set define off

-- Create database link 
create database link unipro_dbl
  connect to suirplus identified by sp1010
  using '//box:1006/xe';

create database link suirpru_dbl
  connect to suirplus identified by sp1010
  using '//box:1006/xe';

create database link dgii_dbl
  connect to suirplus identified by sp1010
  using '//box:1006/xe';

create database link infotep_dbl
  connect to suirplus identified by sp1010
  using '//box:1006/xe';

exit;