CREATE OR REPLACE PROCEDURE SUIRPLUS.ARS_BAJA_DEP_ADICIONALES
(
 p_id_usuario in suirplus.seg_usuario_t.id_usuario%type,
 p_resultado  out varchar2
)
AS
  v_hora_inicio       date;
  v_hora_termina      date;
  v_resultado         varchar2(32767);
  
  v_id_bitacora        suirplus.sfc_bitacora_t.id_bitacora%type;
  v_id_proceso         suirplus.sfc_procesos_t.id_proceso%TYPE := 'BA'; -- Proceso de baja Dependientes Adicionales
  v_conteo             pls_integer;
  v_linea              pls_integer;
  v_total_empleadores  pls_integer;
  v_total_dependientes pls_integer;
  v_dias_a_sumar       suirplus.sfc_det_parametro_t.valor_numerico%type;
  v_id_reg_pat         suirplus.sre_empleadores_t.id_registro_patronal%type;
  v_id_movimiento      suirplus.sre_movimiento_t.id_movimiento%type;
  v_periodo            NUMBER(6) := Parm.periodo_vigente(sysdate);

  e_proceso_no_existe EXCEPTION;
  e_usuario_no_existe EXCEPTION;
BEGIN
  -- Grabar en Bitacora que va a comenzar el proceso
  suirplus.bitacora(v_id_bitacora, 'INI', v_id_proceso);

  --Si no existe el proceso, termina la ejecucion informando en bitacora
  SELECT COUNT(*)
    INTO v_conteo
    FROM suirplus.Sfc_Procesos_t a
   WHERE id_proceso = v_id_proceso;

  IF v_conteo = 0 THEN
    RAISE e_proceso_no_existe;
  END IF;

  -- Ver si existe el usuario, si no existe termina la ejecucion
  Select count(*)
    Into v_conteo
    From suirplus.seg_usuario_t t
   Where t.id_usuario = upper(p_id_usuario);

  If v_conteo = 0 Then
    RAISE e_usuario_no_existe;
  End if;

  v_hora_inicio   := sysdate;

  -- Grabar primer seguimiento en detalle de bitacora
  suirplus.detalle_bitacora(v_id_bitacora, sysdate,SUBSTR('Inicio del PROCESO '||v_id_proceso||' a las '||to_char(sysdate,'dd/mm/yyyy hh:mi:ss')||chr(13)||chr(10)||
                                                          'PARÁMETROS: p_id_usuario = '||p_id_usuario,1,500));
  --Busco los dias de gracias
  v_dias_a_sumar := suirplus.Parm.get_parm_number(408);

  --Si la fecha actual es menor a la fecha que resulte del primer dia de recaudo mas los dias de gracia, aborto el proceso
  If TRUNC(sysdate) < suirplus.srp_pkg.business_date(TO_DATE('01-'||to_char(sysdate,'MON-YYYY'),'DD-MON-YYYY'), v_dias_a_sumar) Then
    v_hora_termina := sysdate;

	  -- Para grabar mensaje a notificar
	  suirplus.registrar_mensaje(v_id_proceso, SUBSTR('Estamos dentro de los días de recaudo y corrida de recargos, no se altera la tabla SUIRPLUS.SRE_DEPENDIENTES_T.',1,500), 'P', p_resultado);

    -- Grabar fin seguimiento en detalle de bitacora
    suirplus.detalle_bitacora(v_id_bitacora,
                              sysdate,
                              SUBSTR('Estamos dentro de los días de recaudo y corrida de recargos, no se altera la tabla SUIRPLUS.SRE_DEPENDIENTES_T.', 1, 500));
    
    -- Grabar fin seguimiento en detalle de bitacora
    suirplus.detalle_bitacora(v_id_bitacora,
                              sysdate,
                              SUBSTR('Fin del Proceso '||v_id_proceso||' - terminado a las '||to_char(v_hora_termina,'dd/mm/yyyy hh:mi:ss am')||
                                     ' - Tiempo total: ('||TRIM(TO_CHAR(EXTRACT(HOUR FROM NUMTODSINTERVAL(v_hora_termina - v_hora_inicio, 'DAY')),'00'))||':'||
                                                           TRIM(TO_CHAR(EXTRACT(MINUTE FROM NUMTODSINTERVAL(v_hora_termina - v_hora_inicio, 'DAY')),'00'))||':'||
                                                           TRIM(TO_CHAR(EXTRACT(SECOND FROM NUMTODSINTERVAL(v_hora_termina - v_hora_inicio, 'DAY')),'00'))||')', 1, 500));
    -- Para cerrar la bitacora
    suirplus.bitacora(v_id_bitacora,
                      'FIN',
                      v_ID_PROCESO,
                      SUBSTR('Estamos dentro de los días de recaudo y corrida de recargos, no se altera la tabla SUIRPLUS.SRE_DEPENDIENTES_T.', 1, 200),
                      'O',
                      '000');
    RETURN; --Aborto el proceso
  End If;

  v_id_reg_pat        := 0;
  v_total_empleadores := 0;
  v_total_dependientes:= 0;
  v_id_movimiento     := 0;
  
  --Tomamos todos los dependientes adicionales con estatus ACTIVO y que sean de trabajadores con estatus ACTIVO 
  FOR R in (
            Select d.id_registro_patronal, d.id_nomina, d.id_nss, d.id_nss_dependiente
            From suirplus.sre_dependiente_t d
            Join suirplus.sre_trabajadores_t t
              On t.id_registro_patronal = d.id_registro_patronal
             And t.id_nomina = d.id_nomina
             And t.id_nss = d.id_nss
             And t.status = 'A' --Activo en Trabajadores
            Where d.status = 'A' --Activo en Dependientes Adicionales
            Order by d.id_registro_patronal, d.id_nomina, d.id_nss, id_nss_dependiente
           )
  LOOP
    --Buscamos este registro en la tabla SUIRPLUS.ARS_DEP_ADICIONALES_T, primero como titular del nucleo
    Select Count(*)
      Into v_conteo
      From suirplus.ars_dep_adicionales_t
     Where id_nss_dependiente = r.id_nss_dependiente
	     And (
	          id_nss_titular = r.id_nss --Que el trabajador sea el titular del nucleo
			      OR 
			      NVL(id_nss_conyuge,-1) = r.id_nss --Que el trabajador sea el conyuge del nucleo
           );

    If v_conteo = 0 Then
      --Debemos considerar crear un movimiento cabecera con detalles por Empleador
      IF v_id_reg_pat != R.ID_REGISTRO_PATRONAL THEN
        --Si ya se creo un movimiento y vamos a crear otro, antes pongo en cola de ejecucion el actual
        If v_linea > 1 Then
          suirplus.sre_load_movimiento_pkg.poner_en_cola(v_id_movimiento);
          Suirplus.InsertarMensajeInbox(
                                        p_id_registro_patronal => v_id_reg_pat, 
                                        p_mensaje => 'Se ha creado una novedad de baja de dependientes adicionales con el #'||v_id_movimiento||' para aquellos dependientes adicionales que no estan afiliados en UNIPAGO.',
                                        p_asunto => 'Novedad de Baja Dependiente Adicional',
                                        p_usuario => p_id_usuario, 
                                        p_resultnumber => v_resultado
                                       );
        End if;  
        
        v_id_reg_pat        := r.id_registro_patronal;
        v_id_movimiento     := SUIRPLUS.SRE_MOVIMIENTOS_SEQ.NEXTVAL;
        v_total_empleadores := v_total_empleadores + 1;
        v_linea             := 1; --Secuencia inicial establecida
              
        INSERT INTO SUIRPLUS.SRE_MOVIMIENTO_T
          (ID_MOVIMIENTO,
           ID_REGISTRO_PATRONAL,
           ID_USUARIO,
           ID_TIPO_MOVIMIENTO,
           STATUS,
           FECHA_REGISTRO,
           PERIODO_FACTURA,
           ULT_FECHA_ACT,
           ULT_USUARIO_ACT)
        VALUES
          (v_id_movimiento,
           v_id_reg_pat,
           p_id_usuario,
           'NV',
           'N',
           sysdate,
           v_Periodo,
           sysdate,
           p_id_usuario);
        COMMIT;
      END IF;

      INSERT INTO SUIRPLUS.SRE_DET_MOVIMIENTO_T
        (id_movimiento,
         id_linea,
         id_nss,
         id_nss_dependiente,
         id_tipo_novedad,
         id_nomina,
         periodo_aplicacion,
         fecha_inicio,
         ult_fecha_act,
         ult_usuario_act)
      VALUES
        (v_id_movimiento,
         v_linea,
         r.id_nss,
         r.id_nss_dependiente,
         'SD',
         r.id_Nomina,
         v_periodo,
         SYSDATE,
         SYSDATE,
         p_id_usuario);
      COMMIT;

      v_total_dependientes := v_total_dependientes + 1;
      v_linea              := v_linea + 1; --incrementar secuencia
    End If;
  END LOOP;
  
  --Si esta variable tiene valor es un movimiento que debemos poner en cola de ejecucion
  If v_id_movimiento > 0 Then
    suirplus.sre_load_movimiento_pkg.poner_en_cola(v_id_movimiento);    
    Suirplus.InsertarMensajeInbox(
                                  p_id_registro_patronal => v_id_reg_pat, 
                                  p_mensaje => 'Se ha creado una novedad de baja de dependientes adicionales con el #'||v_id_movimiento||' para aquellos dependientes adicionales que no estan afiliados en UNIPAGO.',
                                  p_asunto => 'Novedad de Baja Dependiente Adicional',
                                  p_usuario => p_id_usuario,
                                  p_resultnumber => p_resultado
                                 );
  End if;
    
  v_hora_termina := sysdate;

  -- Para grabar mensaje a notificar
  suirplus.registrar_mensaje(v_id_proceso, SUBSTR('Cantidad de empleadores con dependientes dados de baja: '||TRIM(to_char(v_total_empleadores,'999,999,999'))||'. Cantidad de dependientes dados de baja: '||TRIM(to_char(v_total_dependientes,'999,999,999')),1,500), 'P', p_resultado);

  -- Grabar fin seguimiento en detalle de bitacora
  suirplus.detalle_bitacora(v_id_bitacora,
                            sysdate,
                            SUBSTR('Cantidad de empleadores con dependientes dados de baja: '||TRIM(to_char(v_total_empleadores,'999,999,999'))||'. Cantidad de dependientes dados de baja: '||TRIM(to_char(v_total_dependientes,'999,999,999')),1,500));

  -- Grabar fin seguimiento en detalle de bitacora
  suirplus.detalle_bitacora(v_id_bitacora,
                            sysdate,
                            SUBSTR('Fin del Proceso '||v_id_proceso||' - terminado a las '||to_char(v_hora_termina,'dd/mm/yyyy hh:mi:ss am')||
                                   ' - Tiempo total: ('||TRIM(TO_CHAR(EXTRACT(HOUR FROM NUMTODSINTERVAL(v_hora_termina - v_hora_inicio, 'DAY')),'00'))||':'||
                                   TRIM(TO_CHAR(EXTRACT(MINUTE FROM NUMTODSINTERVAL(v_hora_termina - v_hora_inicio, 'DAY')),'00'))||':'||
                                   TRIM(TO_CHAR(EXTRACT(SECOND FROM NUMTODSINTERVAL(v_hora_termina - v_hora_inicio, 'DAY')),'00'))||')', 1, 500));

  -- Para cerrar la bitacora
  suirplus.bitacora(v_id_bitacora,
                    'FIN',
                    v_ID_PROCESO,
                    SUBSTR('Cantidad de empleadores con dependientes dados de baja: '||TRIM(to_char(v_total_empleadores,'999,999,999'))||'. Cantidad de dependientes dados de baja: '||TRIM(to_char(v_total_dependientes,'999,999,999')),1,200),
                    'O',
                    '000');
EXCEPTION
  WHEN e_proceso_no_existe THEN
    p_resultado := Suirplus.Seg_Retornar_Cadena_Error('240', NULL, NULL);

    -- Para grabar mensaje a notificar
    suirplus.registrar_mensaje(v_id_proceso, SUBSTR(p_resultado,1,500), 'P', v_resultado);

    -- Grabar fin seguimiento en detalle de bitacora
    suirplus.detalle_bitacora(v_id_bitacora,
                              sysdate,
                              SUBSTR('PROCESO TERMINADO CON ERROR: '||p_resultado, 1, 500));

    -- Para cerrar la bitacora
    suirplus.bitacora(v_id_bitacora,
                     'FIN',
                     v_ID_PROCESO,
                     substr(p_resultado, 1, 200),
                     'E',
                     '000');
  WHEN e_usuario_no_existe THEN
    p_resultado := Suirplus.Seg_Retornar_Cadena_Error('1', NULL, NULL);

    -- Para grabar mensaje a notificar
    suirplus.registrar_mensaje(v_id_proceso, SUBSTR(p_resultado,1,500), 'P', v_resultado);

    -- Grabar fin seguimiento en detalle de bitacora
    suirplus.detalle_bitacora(v_id_bitacora,
                              sysdate,
                              SUBSTR('PROCESO TERMINADO CON ERROR: '||p_resultado, 1, 500));

    -- Para cerrar la bitacora
    suirplus.bitacora(v_id_bitacora,
                     'FIN',
                     v_ID_PROCESO,
                     substr(p_resultado, 1, 200),
                     'E',
                     '000');
  WHEN OTHERS THEN
    p_resultado := SQLERRM||' - '||dbms_utility.format_error_backtrace;


    -- Para grabar mensaje a notificar
    suirplus.registrar_mensaje(v_id_proceso, SUBSTR(p_resultado,1,500), 'P', v_resultado);

    -- Grabar fin seguimiento en detalle de bitacora
    suirplus.detalle_bitacora(v_id_bitacora,
                              sysdate,
                              SUBSTR('PROCESO TERMINADO CON ERROR: '||p_resultado, 1, 500));

    -- Para cerrar la bitacora
    suirplus.bitacora(v_id_bitacora,
                     'FIN',
                     v_ID_PROCESO,
                     substr(p_resultado, 1, 200),
                     'E',
                     '000');  
END;
