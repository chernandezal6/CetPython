CREATE OR REPLACE PROCEDURE suirplus.SFC_reenvio_de_movimiento_P IS
  inicio  date;
  conteo  number(9);
 
  mail_from    varchar2(250) := 'info@mail.tss2.gov.do';
  mail_to      varchar2(4000);
  mail_error   varchar2(4000);
  mail_subject varchar2(250) := 'Proceso de reenvio de movimientos';
begin
  conteo :=  0;
  inicio := sysdate;
  suirplus.sre_load_movimiento_pkg.relanzar_movimientos_detenidos;
        -- modificado por: CMHA
   -- fecha         : 03/03/2017
   --Buscamos la receptor en la tabla sfc_procesos_t 
    select p.lista_error,p.lista_error 
    into mail_to, mail_error
    from suirplus.sfc_procesos_t p
    where p.id_proceso = '92';

  for movs in (select id_movimiento from Sre_movimiento_t WHERE status ='N')
  loop
    begin
      suirplus.sre_load_movimiento_pkg.someter_movimiento_web(movs.id_movimiento);
    exception when others then
      system.html_mail(mail_from,mail_error,'Error en '||mail_subject||': mov. '||movs.id_movimiento,sqlerrm);
    end;
    conteo := conteo+1;
  end loop;
  commit;
  
  system.html_mail(
    p_sender    => mail_from,
    p_recipient => mail_to,
    p_subject   => mail_subject,
    p_message   => 'Inicio: '||to_char(inicio ,'dd/mm/yyyy hh24:mi:ss')
      || '<br>' || 'Final : '||to_char(sysdate,'dd/mm/yyyy hh24:mi:ss')
      || '<br>' || 'Tiempo: '||trim(to_char((sysdate-inicio)/24/60/60,'999,999,999.99'))||' segs.'
      || '<br>' || 'Movs. : '||conteo||' movimientos.'
  );
exception when others then
 
  system.html_mail(mail_from,mail_error,'Error en '||mail_subject,sqlerrm);
end; 
 