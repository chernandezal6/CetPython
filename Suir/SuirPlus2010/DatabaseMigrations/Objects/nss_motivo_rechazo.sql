  -- -------------------------------------------------------------------------------
  --Charlie pena
  --05/10/2016
  --retorna una lista de motivos de rechazos para una solicitud de asignacion de NSS
CREATE OR REPLACE PROCEDURE NSS_Motivo_Rechazo
  (
    P_CURSOR out SYS_REFCURSOR,
    p_resultado out Varchar2
  )
  is
  v_bderror varchar2(2000);
    begin
    open P_CURSOR for
      select s.id_error , initcap(s.error_des)error_des
      from seg_error_t s
      where s.id_error like 'NSS9%'
      order by s.error_des;
    p_resultado:=0;
   exception
   when others then
   v_bderror := (SUBSTR('error '||TO_CHAR(SQLCODE)||': '||SQLERRM, 1, 255));
 p_resultado := Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);

  end;