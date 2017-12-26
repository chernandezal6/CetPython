create or replace procedure suirplus.REENVIO_MOVIMIENTOS is
  v_id_bitacora   suirplus.sfc_bitacora_t.id_bitacora%type;
  v_id_bitacora_1 suirplus.sfc_bitacora_t.id_bitacora%type;  
  v_proceso       suirplus.sre_movimiento_t.id_movimiento%TYPE; 
  v_id_proceso    CONSTANT suirplus.SFC_PROCESOS_T.id_proceso%TYPE := 'RM'; -- Relanzar Movimiento.
  v_next          number(10);
  v_error         varchar2(200);  
begin
  -- Grabar en Bitacora que va a comenzar el proceso
  suirplus.bitacora(p_id_bitacora => v_id_bitacora, p_accion => 'INI', p_id_proceso => v_id_proceso);

  v_Proceso := 0;

  -- movimientos ejecutandose por mas de 24 horas (1 dia)
  For movs_detenidos in (select m.id_movimiento
                           from suirplus.sre_movimiento_t m
                          where m.status = 'E'
                            and trunc(sysdate - m.fecha_registro, 0) >= 1) loop

      -- Grabar en Bitacora por cada movimiento en status = 'E'
      suirplus.bitacora(v_id_bitacora_1, 'INI', v_id_proceso);

      v_proceso := movs_detenidos.id_movimiento;
      
      --Rechazamos el movimiento
      update suirplus.sre_movimiento_t
         set status = 'R' -- Marcar movimiento como Rechazado
       where id_movimiento = movs_detenidos.id_movimiento;

      commit;

      --Para indicar en bitacora que esta parte del proceso termino
      suirplus.bitacora(v_id_bitacora_1,
                        'FIN',
                        v_id_proceso,
                        'ID Movimiento: ' || to_char(v_proceso),
                        'O',
                        '000');
  End loop;
  
  --Para saber si la bitacora v_id_bitacora_1 esta pendiente de cerrar, en caso de error.
  v_Proceso := 0;

  -- Si hay movimientos pendientes de procesar, los serializas para su ejecucion.
  for movs_detenidos in (select distinct m.id_registro_patronal
                           from suirplus.sre_movimiento_t m
                          where m.status = 'C'
                            and not exists
                          (select 1
                             from suirplus.sre_movimiento_t x
                            where x.id_registro_patronal = m.id_registro_patronal
                              and x.status = 'E')) loop
    
    select suirplus.seg_job_seq.nextval into v_next from dual;

    -- insertar job de serializacion al registro patronal
    insert into suirplus.seg_job_t
      (id_job, nombre_job, status, fecha_envio)
    values
      (v_next,
       'suirplus.sre_load_movimiento_pkg.serializar_ejecucion(' ||
       movs_detenidos.id_registro_patronal || ',' || v_next || ');',
       'S',
       sysdate);
    commit;
  end loop;

  --someter los movimientos sin procesar
  for movs in (select id_movimiento 
                 from suirplus.sre_movimiento_t 
                Where status ='N')
  loop
    suirplus.sre_load_movimiento_pkg.someter_movimiento_web(movs.id_movimiento);
  end loop;
  commit;

  -- Grabar en Bitacora que el proceso termino
  suirplus.bitacora(v_id_bitacora,
                   'FIN',
                   v_ID_PROCESO,
                   'Header. OK.',
                   'O',
                   '000'); 
Exception when others then
  v_error := SQLERRM;

  suirplus.bitacora(v_id_bitacora,
                   'FIN',
                   v_ID_PROCESO,
                   substr('Header. ' || v_Error, 1, 200),
                   'E',
                   '000');

  if NVL(v_proceso, 0) > 0 then
    suirplus.bitacora(v_id_bitacora_1,
                     'FIN',
                     v_ID_PROCESO,
                     substr('Detail. ' || to_char(v_proceso) || '.  ' || v_Error, 1, 200),
                     'E',
                     '000');
  end if;
end;