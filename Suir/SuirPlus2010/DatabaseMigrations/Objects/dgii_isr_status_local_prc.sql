CREATE OR REPLACE PROCEDURE SUIRPLUS.DGII_ISR_STATUS_PRC IS
  v_inicio varchar2(30);
  v_desde  varchar2(30);
  v_hasta  varchar2(30);
  v_desde1 varchar2(30);
  v_hasta1 varchar2(30);
  v_clr    varchar2(30);
  v_clr1   varchar2(30);
  v_fin    varchar2(30);
  l_temp   clob;
  v_result CHAR(2) DEFAULT CHR(13) || CHR(10);

  v_id_bitacora suirplus.sfc_bitacora_t.id_bitacora%type;
  v_id_proceso  suirplus.SFC_PROCESOS_T.id_proceso%TYPE := '52'; --Sincronizacion de dgii_isr_status_local_t
  v_lista_ok    suirplus.SFC_PROCESOS_T.lista_ok%TYPE;
  v_lista_err   suirplus.SFC_PROCESOS_T.lista_error%TYPE;
  e_proceso_no_existe Exception;
BEGIN
  -- Grabar en Bitacora que va a comenzar el proceso
  suirplus.bitacora(v_id_bitacora, 'INI', v_id_proceso);

  -- Traigo los registros a considerar para ser puesto en el detalle de bitacora
  Begin
    Select a.lista_ok, a.lista_error
    Into v_lista_ok, v_lista_err 
    From suirplus.Sfc_Procesos_t a
    Where id_proceso = v_id_proceso;
  Exception When NO_DATA_FOUND Then
    RAISE e_proceso_no_existe;
  End;

  v_inicio := to_char(sysdate, 'Hh24:MI:ss');

  dbms_snapshot.refresh('dgii_isr_status_local_v', 'c');

  v_desde  := to_char(sysdate, 'Hh24:MI:SS');
  v_desde1 := v_inicio || '-->' || v_desde;

  --Buscamos todos los registros que vinieron en la vista desde DGII
  MERGE INTO DGII_ISR_STATUS_LOCAL_T e
       USING (
              SELECT rnc,
                     periodo_liquidacion,
                     is_presento,
                     is_pago,
                     is_autoriza_rectificativa
                FROM dgii_isr_status_v
             ) Activo
          ON (e.rnc = activo.rnc AND e.periodo_liquidacion = activo.periodo_liquidacion)
  WHEN MATCHED
  THEN
      --Actualiza los registro que ya existe en TSS y que tengan cambios en DGII.    
      UPDATE 
        SET e.is_presento = Activo.is_presento,
            e.is_pago = Activo.is_pago,
            e.is_autoriza_rectificativa = Activo.is_autoriza_rectificativa
      WHERE e.rnc = Activo.rnc
        AND e.periodo_liquidacion = Activo.periodo_liquidacion
        AND (
             nvl(e.is_presento, '@') <> nvl(Activo.is_presento, '@') OR
             nvl(e.is_pago, '@') <> nvl(Activo.is_pago, '@') OR
             nvl(e.is_autoriza_rectificativa, '@') <> nvl(Activo.is_autoriza_rectificativa, '@')
            )
  WHEN NOT MATCHED
  THEN
      --Inserta los registros que no exitan en TSS y que estan en DGII    
      INSERT (
              rnc,
              periodo_liquidacion,
              is_presento,
              is_pago,
              is_autoriza_rectificativa
             )
      VALUES (
              Activo.rnc,
              Activo.periodo_liquidacion,
              Activo.is_presento,
              Activo.is_pago,
              Activo.is_autoriza_rectificativa
             );
  COMMIT;

  v_hasta  := to_char(sysdate, 'Hh24:MI:ss');
  v_hasta1 := v_desde || '-->' || v_hasta;
    
  FOR c_pen IN (SELECT rnc, periodo_liquidacion
                  FROM dgii_isr_status_local_t r
                 WHERE r.periodo_liquidacion >= 201201
                MINUS
                SELECT c.rnc, c.periodo_liquidacion
                  FROM dgii_isr_status_v c
                 WHERE c.periodo_liquidacion >= 201201)
  LOOP
    --Borra todos los registros que esten en TSS que no vinieron en la vista desde DGII
    DELETE FROM dgii_isr_status_local_t
     WHERE rnc = c_pen.rnc
       AND periodo_liquidacion = c_pen.periodo_liquidacion;
  END LOOP;
  COMMIT;
  
  v_clr  := to_char(sysdate, 'Hh24:MI:ss');
  v_clr1 := v_hasta || '-->' || v_clr;
  
  v_fin  := to_char(sysdate, 'Hh24:MI:ss');
  l_temp := 'Inicio:' || '-->' || v_inicio || v_result ||
            'refrescando vista:' || '-->' || v_desde1 || v_result ||
            'sincronizando registros:' || v_hasta1 || v_result ||
            'borrado:' || v_clr1 || v_result || 'Fin:' || v_fin || v_result;

  system.html_mail(p_sender    => 'info@mail.tss2.gov.do',
                   p_recipient => v_lista_ok,
                   p_subject   => 'Sincronizacion de dgii_isr_status_local_t del dia ' ||
                                  to_char(sysdate, 'yyyy/mm/dd'),
                   p_message   => l_temp);
                   
  -- Para cerrar la bitacora
  suirplus.bitacora(v_id_bitacora,
                   'FIN',
                   v_ID_PROCESO,
                   'OK',
                   'O',
                   '000');                   
EXCEPTION
  WHEN e_proceso_no_existe THEN
    -- Para cerrar la bitacora
    suirplus.bitacora(v_id_bitacora,
                     'FIN',
                     v_ID_PROCESO,
                     substr(Suirplus.Seg_Retornar_Cadena_Error(240, NULL, NULL), 1, 200),
                     'E',
                     '000');  
  WHEN OTHERS THEN
    system.html_mail(p_sender    => 'info@mail.tss2.gov.do',
                     p_recipient => v_lista_err,
                     p_subject   => 'Error en sincronizacion de dgii_isr_status_local_t del dia ' ||
                                    to_char(sysdate, 'yyyy/mm/dd'),
                     p_message   => sqlerrm);
END;