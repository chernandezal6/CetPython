CREATE OR REPLACE PROCEDURE SUIRPLUS.sfc_historico_deudores_p(p_resultnumber out varchar2) is

  v_monto number(13,2);
  v_periodos number(4);  
  v_bderror varchar2(500);
  v_count  varchar(500);

  begin
     select c.field1,
         c.field2
       into v_periodos,
            v_monto
       from suirplus.srp_config_t c
      where c.id_modulo = 'HIST_DEUDA';
  
     insert into suirplus.sfc_historico_deudores_t h
     (fecha,
      id_registro_patronal,
      periodos_vencidos,
      nps_vencidas,
      total_deuda
     )

    select trunc(sysdate) as Fecha,
            f.id_registro_patronal Registro_Patronal,
            count(distinct f.periodo_factura) as Periodos_Vencidos,
            count(f.id_referencia) as Nps_Vencidas,
            sum(f.total_general_factura) as Total_Deuda
      from suirplus.sfc_facturas_v f
     where f.status in ('VE')
    having count(distinct f.periodo_factura) > v_periodos
           and sum(f.total_general_factura) > v_monto
    group by  f.id_registro_patronal;
    
    commit;    
    suirplus.sfc_rep_empleadores_deudores_p(v_count);
    
    if v_count = '0' then
      p_resultnumber:= '0';
    else
      p_resultnumber := v_count;
    end if;    
        
  exception
  when others then
    v_bderror      := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' || SQLERRM, 1, 255));
    p_resultnumber := Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
    return;
 end;
