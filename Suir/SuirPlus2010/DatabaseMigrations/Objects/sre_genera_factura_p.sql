CREATE OR REPLACE PROCEDURE SUIRPLUS.SRE_GENERA_FACTURA_P
(p_id_registro_patronal sfc_facturas_t.id_registro_patronal%type,
 p_id_nomina sfc_facturas_t.id_nomina%type ,
 p_periodo_factura sfc_facturas_t.periodo_factura%type,
 pid_job seg_job_t.id_job%type
) is
  error varchar2(1000);
v_return seg_error_t.id_error%type;
v_error_seq number;
v_id_tipo_factura sfc_facturas_t.id_tipo_factura%type:='O';
BEGIN
  if sfc_genera_fac_liq_ordinaria_f(
                                    v_return,
                                    v_error_seq,
                                    p_periodo_factura,
                                    p_id_registro_patronal,
                                    p_id_nomina
                                   ) then
    update suirplus.seg_job_t set status='P', resultado='true'||v_return where id_job =  pid_job  ;
  else
    update suirplus.seg_job_t set status = 'P', resultado= 'error (sfc_genera_fac_liq_ordinaria_f ) ' || v_return || 'p_error_seq ' || to_char(v_error_seq) || 'p_id_registro_patronal ' || p_id_registro_patronal || 'p_periodo_factura  ' || p_periodo_factura || '  p_id_nomina ' || p_id_nomina

      where id_job = pid_job  ;
end if;
  commit;
exception
when others then
  error:= 'Proceso concluido con error....'||SQLCODE||') '||SUBSTR(SQLERRM,1,200);
update seg_job_t set status = 'P', resultado = 'error (sfc_genera_fac_liq_ordinaria_f ) ' || error where id_job = pid_job;
dbms_output.put_line (' error '|| error );
  SRE_ENVIA_EMAIL_P( '18' , error, 'ERROR');
commit;
END;