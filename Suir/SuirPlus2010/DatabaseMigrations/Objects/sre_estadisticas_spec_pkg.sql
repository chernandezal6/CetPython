create or replace package suirplus.sre_estadisticas_pkg is
  -- Author  : ROBERTO_JAQUEZ
  -- Created : 20/01/2006 11:00:15 a.m.
  -- Purpose : Recoleccion de datos estadisticos
  c_log_file  VARCHAR2(32000);
  c_log_title VARCHAR2(100) := 'Recoleccion de datos estadisticos';
  c_log_start date := sysdate;
  c_mail_from varchar2(100) := 'info@mail.tss2.gov.do';
  c_mail_to   varchar2(500); 
  c_mail_error varchar2(500);
  procedure procesar;
  procedure recolectar_estadisticas;
end sre_estadisticas_pkg;

 