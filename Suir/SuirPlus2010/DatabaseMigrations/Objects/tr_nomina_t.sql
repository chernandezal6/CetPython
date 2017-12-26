CREATE OR REPLACE TRIGGER SUIRPLUS.TR_NOMINA_T
BEFORE UPDATE
ON SRE_NOMINAS_T REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
DECLARE
/******************************************************************************
   NAME:
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        05/01/2005             1. Created this trigger.

   NOTES:

   Automatically available Auto Replace Keywords:
      Object Name:
      Sysdate:         05/01/2005
      Date and Time:   05/01/2005, 8:45:06 PM, and 05/01/2005 8:45:06 PM
      Username:         (set in TOAD Options, Proc Templates)
      Table Name:       (set in the "New PL/SQL Object" dialog)
      Trigger Options:  (set in the "New PL/SQL Object" dialog)
******************************************************************************/

 vproceso          seg_job_t.NOMBRE_JOB%type;
 vidjob            seg_job_t.ID_JOB%type;
 v_periodo_factura sfc_facturas_t.periodo_factura%type;
BEGIN
  IF :new.TIPO_NOMINA <> :old.TIPO_NOMINA then
    select parm.periodo_vigente(sysdate), seg_job_seq.nextval 
      into v_periodo_factura, vidjob
      from dual;

    vproceso := 'SRE_GENERA_FACTURA_P('||:new.id_registro_patronal||','||:new.id_nomina||','||v_periodo_factura||','||vidjob||');';
    insert into suirplus.seg_job_t(id_job, nombre_job, status, resultado)
    values (vidjob, vproceso, 'S', null);
  END IF;
EXCEPTION
   WHEN OTHERS THEN
       -- Consider logging the error and then re-raise
   RAISE;
END;