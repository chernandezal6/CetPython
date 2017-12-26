CREATE OR REPLACE PACKAGE BODY SUIRPLUS.SFC_FACTURA_PKG IS
  -- **************************************************************************************************
  -- Program: SUIRPLUS.SFC_FACTURA_PKG
  -- Description: Paquete para manejar los usuarios
  --
  -- Modification History
  -- --------------------------------------------------------------------------------------------------
  -- Fecha        por     Comentario
  -- --------------------------------------------------------------------------------------------------
  --
  -- **************************************************************************************************

  -- **************************************************************************************************
  -- Program:     Cargar_Datos
  -- Description: realiza una carga de datos de las vistas "sfc_facturas_v" y "sfc_liquidacion_isr_v"
  --      tambien de las tablas "sre_empleadores_t", "sre_nominas_t", "sfc_tipo_facturas_t"
  --      tomando en cuenta el parametro institucion.
  -- **************************************************************************************************
  -- Declaracion de constantes a utilizar --* VALORES CONSTANTES PARA P_Concepto
  v_tt_SDSS VARCHAR2(4); -- TSS
  v_tt_ISR  VARCHAR2(4); -- DGII
  v_tt_IR17 VARCHAR2(4); -- DGII
  v_tt_DGII varchar2(4); -- AMBOS (ISR, IR17)
  v_tt_INF  varchar2(4); -- INF para INFOTEP)
  v_tt_MDT  varchar2(4); -- MDT para MDT PLANILLA
  v_tt_ISRP varchar2(4); -- ISR PRELIMINAR

  PROCEDURE Cargar_Datos(p_NoReferencia   VARCHAR2,
                         p_NoAutorizacion NUMBER,
                         p_concepto       VARCHAR2,
                         p_IOCursor       OUT t_cursor,
                         p_resultnumber   OUT VARCHAR2)
  
   IS
    e_invalidNoReferencia EXCEPTION;
    v_ReferenciaValida boolean;
    v_bd_error         VARCHAR(1000);
    v_noReferencia     VARCHAR2(16);
    c_cursor           t_cursor;
    --*************************************
    --TSS
    CURSOR c_cursorTSS is
      SELECT id_referencia
        FROM sfc_facturas_v
       WHERE NO_AUTORIZACION = p_NoAutorizacion;
    --ISR
    CURSOR c_cursorISR is
      SELECT id_referencia_isr
        FROM sfc_liquidacion_isr_v
       WHERE NO_AUTORIZACION = p_NoAutorizacion;
    --IR17
    CURSOR c_cursorIR17 is
      SELECT i.ID_REFERENCIA_IR17
        FROM sfc_liquidacion_ir17_v i
       WHERE NO_AUTORIZACION = p_NoAutorizacion;
    --INF
    CURSOR c_cursorINF is
      SELECT i.ID_REFERENCIA_INFOTEP
        FROM suirplus.sfc_liquidacion_infotep_t i
       WHERE NO_AUTORIZACION = p_NoAutorizacion;
    --MDT
    CURSOR c_cursorMDT is
      SELECT i.ID_REFERENCIA_PLANILLA
        FROM suirplus.sfc_planilla_mdt_t i
       WHERE NO_AUTORIZACION = p_NoAutorizacion;
  
    --*************************************
  BEGIN
  
    v_noReferencia := p_NoReferencia;
  
    IF UPPER(p_concepto) = v_tt_SDSS THEN
    
      IF v_noReferencia IS NULL THEN
        open c_cursorTSS;
        fetch c_cursorTSS
          into v_noReferencia;
        close c_cursorTSS;
      END IF;
    
      --VALIDAMOS LA REFERENCIA
      v_ReferenciaValida := sfc_factura_pkg.isExisteNoReferencia(v_tt_SDSS,
                                                                 v_noReferencia);
    
      if v_ReferenciaValida = false THEN
        raise e_invalidNoReferencia;
      end if;
    
      OPEN c_cursor FOR
        SELECT f.id_referencia,
               f.id_tipo_factura,
               f.id_nomina,
               f.id_riesgo,
               f.FECHA_REPORTE_PAGO,
               f.id_entidad_recaudadora,
               r.entidad_recaudadora_des,
               f.fecha_emision,
               f.fecha_limite_pago,
               f.periodo_factura,
               f.fecha_cancela,
               decode(f.status,
                      'VE',
                      'Vencida',
                      'VI',
                      'Vigente',
                      'PA',
                      'Pagada',
                      'CA',
                      'Revocada',
                      'RE',
                      'Recalculada',
                      f.status) Status,
               f.id_referencia_origen,
               NVL(f.no_autorizacion, 0) no_autorizacion,
               f.fecha_autorizacion,
               f.FECHA_DESAUTORIZACION,
               f.id_usuario_autoriza,
               f.id_usuario_desautoriza,
               f.descuento_penalidad,
               f.total_salario_ss,
               f.FECHA_PAGO,
               f.total_aporte_afiliados_sfs,
               f.total_aporte_empleador_sfs,
               f.total_aporte_afiliados_svds,
               f.total_aporte_empleador_svds,
               f.total_aporte_srl,
               f.total_per_capita_adicional,
               f.total_recargo_svds,
               f.total_interes_srl,
               f.total_interes_afp,
               f.total_interes_cpe,
               f.total_interes_fss,
               f.total_interes_osipen,
               f.total_interes_seguro_vida,
               f.total_recargo_sfs,
               f.total_interes_sfs,
               f.total_recargo_srl,
               f.total_trabajadores,
               f.total_aporte_afiliados_t3,
               f.total_aporte_empleador_t3,
               f.total_aporte_afiliados_idss,
               f.total_recargo_idss,
               f.total_intereses_idss,
               f.total_aporte_empleador_idss,
               f.total_aporte_voluntario,
               f.total_cuenta_personal,
               f.total_seguro_vida,
               f.total_interes_pension,
               f.total_fondo_solidaridad,
               f.total_comision_afp,
               f.total_operacion_sipen,
               f.total_interes_apo,
               f.total_operacion_sisalril_srl,
               f.total_proporcion_arl_srl,
               f.total_cuidado_salud,
               f.total_estancias_infantiles,
               f.total_subsidios_salud,
               f.fecha_pago,
               f.total_operacion_sisalril_sfs,
               f.ult_fecha_act,
               f.ult_usuario_act,
               f.total_recargos_factura,
               f.total_interes_factura,
               f.total_aporte_sfs,
               f.total_aporte_svds,
               f.total_general_factura,
               f.monto_ajuste,
               e.rnc_o_cedula,
               e.id_registro_patronal,
               Srp_Pkg.ProperCase(e.nombre_comercial) nombre_comercial,
               Srp_Pkg.ProperCase(e.razon_social) razon_social,
               Srp_Pkg.ProperCase(n.nomina_des) nomina_des,
               tn.descripcion Tipo_Nomina,
               Srp_Pkg.ProperCase(t.tipo_factura_des) tipo_factura_des,
               f.origen as OrigenPago,
               f.status_generacion
          FROM sfc_facturas_v            f,
               SRE_EMPLEADORES_T         e,
               SRE_NOMINAS_T             n,
               sfc_tipo_nominas_t        tn,
               SFC_TIPO_FACTURAS_T       t,
               SFC_ENTIDAD_RECAUDADORA_T r
         WHERE f.id_referencia = v_noReferencia
           AND f.id_registro_patronal = n.id_registro_patronal
           AND f.id_registro_patronal = e.id_registro_patronal
           AND f.id_nomina = n.id_nomina
           and n.tipo_nomina = tn.id_tipo_nomina
           AND f.id_tipo_factura = t.id_tipo_factura
           AND f.id_entidad_recaudadora = r.id_entidad_recaudadora(+);
    END IF;
  
    IF UPPER(p_concepto) = v_tt_ISR THEN
    
      IF v_noReferencia IS NULL THEN
        open c_cursorISR;
        fetch c_cursorISR
          into v_noReferencia;
        close c_cursorISR;
      END IF;
      --VALIDAMOS LA LIQUIDACION
      v_ReferenciaValida := sfc_factura_pkg.isExisteNoReferencia(v_tt_ISR,
                                                                 v_noReferencia);
    
      if v_ReferenciaValida = false THEN
        raise e_invalidNoReferencia;
      end if;
    
      OPEN c_cursor FOR
        SELECT l.id_referencia_isr,
               l.id_tipo_factura,
               l.id_entidad_recaudadora,
               r.entidad_recaudadora_des,
               l.id_nomina,
               NVL(l.no_autorizacion, 0) no_autorizacion,
               l.fecha_emision,
               l.fecha_limite_pago,
               l.periodo_liquidacion periodo_factura,
               decode(l.status,
                      'PE',
                      'Pendiente',
                      'VI',
                      'Vigente',
                      'PA',
                      'Pagada',
                      'CA',
                      'Cancelada',
                      'EX',
                      'Exenta',
                      l.status) Status,
               l.fecha_autorizacion,
               l.FECHA_DESAUTORIZACION,
               l.FECHA_REPORTE_PAGO,
               l.total_trabajadores,
               l.total_trabajadores_retencion,
               l.fecha_pago,
               l.total_salario_isr,
               l.TOTAL_PAGADO,
               l.total_remuneracion_otros,
               l.total_otras_remuneraciones,
               l.total_isr,
               l.total_saldo_compensado,
               l.total_por_compensar,
               l.total_saldo_favor,
               NVL(l.total_recargo, 0) AS total_recargo,
               NVL(l.total_interes, 0) AS total_interes,
               l.TOTAL_RETENCION_SS,
               l.total_ingresos_exentos_isr,
               NVL(L.TOTAL_IMPORTE, 0) AS TOTAL_IMPORTE,
               l.id_usuario_autoriza,
               l.id_usuario_desautoriza,
               l.ult_fecha_act,
               l.ult_usuario_act,
               l.TOTAL_A_PAGAR total_general_factura,
               l.fecha_pago,
               e.rnc_o_cedula,
               e.id_registro_patronal,
               e.nombre_comercial,
               Srp_Pkg.ProperCase(e.razon_social) razon_social,
               Srp_Pkg.ProperCase(n.nomina_des) nomina_des,
               Srp_Pkg.ProperCase(NVL(t.tipo_factura_des, ' ')) tipo_factura_des,
               l.total_sujeto_retencion,
               nvl((l.total_credito_aplicado * -1), 0) as CREDITO_APLICADO,
               l.origen as OrigenPago
          FROM sfc_liquidacion_isr_v     l,
               SRE_EMPLEADORES_T         e,
               SRE_NOMINAS_T             n,
               SFC_TIPO_FACTURAS_T       t,
               SFC_ENTIDAD_RECAUDADORA_T r
         WHERE l.id_referencia_isr = v_noReferencia
           AND l.id_registro_patronal = n.id_registro_patronal
           AND l.id_registro_patronal = e.id_registro_patronal
           AND l.id_nomina = n.id_nomina
           AND l.id_tipo_factura = t.id_tipo_factura
           AND l.id_entidad_recaudadora = r.id_entidad_recaudadora(+);
    
    END IF;
  
    IF UPPER(p_concepto) = v_tt_IR17 THEN
    
      IF v_noReferencia IS NULL THEN
        open c_cursorIR17;
        fetch c_cursorIR17
          into v_noReferencia;
        close c_cursorIR17;
      END IF;
    
      --VALIDAMOS LA LIQUIDACION
      v_ReferenciaValida := sfc_factura_pkg.isExisteNoReferencia(v_tt_IR17,
                                                                 v_noReferencia);
    
      if v_ReferenciaValida = false THEN
        raise e_invalidNoReferencia;
      end if;
    
      OPEN c_cursor FOR
        SELECT i.id_referencia_ir17,
               i.id_entidad_recaudadora,
               i.periodo_liquidacion,
               i.alquileres,
               i.honorarios_servicios,
               i.premios,
               i.transferencia_titulos,
               i.dividendos,
               i.interes_exterior,
               i.remesas_exterior,
               i.provedor_estado,
               i.otras_rentas,
               i.Otras_Retenciones,
               i.ret_complementarias,
               i.saldos_compensables,
               i.saldo_favor_anterior,
               i.recargo,
               i.intereses,
               decode(i.status,
                      'PE',
                      'Pendiente',
                      'VI',
                      'Vigente',
                      'PA',
                      'Pagada',
                      'CA',
                      'Cancelada',
                      'EX',
                      'Exenta',
                      i.status) Status,
               i.id_usuario_autoriza,
               i.id_usuario_desautoriza,
               i.fecha_autorizacion,
               i.fecha_desautorizacion,
               NVL(I.no_autorizacion, 0) no_autorizacion,
               i.fecha_emision,
               i.fecha_limite_pago,
               i.fecha_pago,
               i.fecha_cancela,
               i.fecha_reporte_pago,
               i.tipo_reporte_banco,
               i.ult_fecha_act,
               i.ult_usuario_act,
               i.pagos_computables_cuenta,
               i.total_otras_retenciones,
               i.impuesto,
               i.liquidacion,
               e.rnc_o_cedula,
               e.id_registro_patronal,
               e.nombre_comercial,
               Srp_Pkg.ProperCase(e.razon_social) razon_social,
               r.entidad_recaudadora_des,
               i.origen as OrigenPago
          FROM sfc_liquidacion_ir17_v    i,
               SRE_EMPLEADORES_T         e,
               SFC_ENTIDAD_RECAUDADORA_T r
         WHERE i.ID_REFERENCIA_IR17 = v_noReferencia
           AND i.ID_REGISTRO_PATRONAL = e.id_registro_patronal
           AND i.ID_ENTIDAD_RECAUDADORA = r.id_entidad_recaudadora(+);
    
    END IF;
  
    -- Para facturas de INFOTEP
    IF UPPER(p_concepto) = v_tt_INF THEN
    
      IF v_noReferencia IS NULL THEN
        open c_cursorINF;
        fetch c_cursorINF
          into v_noReferencia;
        close c_cursorINF;
      END IF;
      --VALIDAMOS LA LIQUIDACION
      v_ReferenciaValida := sfc_factura_pkg.isExisteNoReferencia(v_tt_INF,
                                                                 v_noReferencia);
    
      if v_ReferenciaValida = false THEN
        raise e_invalidNoReferencia;
      end if;
    
      OPEN c_cursor FOR
        SELECT i.id_referencia_infotep id_referencia_inf,
               i.id_entidad_recaudadora,
               i.periodo_liquidacion periodo_factura,
               decode(i.status,
                      'VE',
                      'Vencida',
                      'VI',
                      'Vigente',
                      'PA',
                      'Pagada',
                      'CA',
                      'Cancelada',
                      'IN',
                      'Inhabilitado para pago',
                      i.status) Status,
               i.id_tipo_factura,
               i.id_usuario_autoriza,
               i.id_usuario_desautoriza,
               i.fecha_autorizacion,
               i.total_trabajadores,
               i.total_salario_bonificacion,
               i.total_pago_infotep,
               i.fecha_desautorizacion,
               NVL(I.no_autorizacion, 0) no_autorizacion,
               i.fecha_emision,
               i.fecha_limite_pago,
               i.fecha_pago,
               i.fecha_cancela,
               i.fecha_reporte_pago,
               i.tipo_reporte_banco,
               i.ult_fecha_act,
               i.ult_usuario_act,
               e.rnc_o_cedula,
               e.id_registro_patronal,
               e.nombre_comercial,
               Srp_Pkg.ProperCase(e.razon_social) razon_social,
               r.entidad_recaudadora_des,
               i.origen as OrigenPago,
               Srp_Pkg.ProperCase(t.tipo_factura_des) tipo_factura_des
          FROM suirplus.sfc_liquidacion_infotep_t i,
               SRE_EMPLEADORES_T                  e,
               SFC_ENTIDAD_RECAUDADORA_T          r,
               SFC_TIPO_FACTURAS_T                t
         WHERE i.ID_REFERENCIA_INFOTEP = v_noReferencia
           AND i.ID_REGISTRO_PATRONAL = e.id_registro_patronal
           AND i.ID_ENTIDAD_RECAUDADORA = r.id_entidad_recaudadora(+)
           and t.id_tipo_factura = i.id_tipo_factura;
    
    END IF;
  
    -- Para facturas de MDT
    IF UPPER(p_concepto) = v_tt_MDT THEN
    
      IF v_noReferencia IS NULL THEN
        open c_cursorMDT;
        fetch c_cursorMDT
          into v_noReferencia;
        close c_cursorMDT;
      END IF;
      --VALIDAMOS LA LIQUIDACION
      v_ReferenciaValida := sfc_factura_pkg.isExisteNoReferencia(v_tt_MDT,
                                                                 v_noReferencia);
    
      if v_ReferenciaValida = false THEN
        raise e_invalidNoReferencia;
      end if;
    
      OPEN c_cursor FOR
        SELECT i.id_referencia_planilla,
               i.id_entidad_recaudadora,
               id_planilla,
               i.id_registro_patronal,
               i.no_autorizacion,
               i.periodo_liquidacion periodo_factura,
               i.fecha_emision,
               i.fecha_limite_pago,
               decode(i.status,
                      'VE',
                      'Vencida',
                      'VI',
                      'Vigente',
                      'PA',
                      'Pagada',
                      'CA',
                      'Cancelada',
                      i.status) Status,
               I.ID_TIPO_FACTURA,
               i.fecha_autorizacion,
               i.fecha_desautorizacion,
               i.total_localidades,
               i.total_trabajadores,
               i.total_salario,
               i.total_pago,
               i.id_usuario_autoriza,
               i.id_usuario_desautoriza,
               i.fecha_pago,
               i.fecha_cancela,
               i.fecha_reporte_pago,
               i.tipo_reporte_banco,
               i.origen,
               i.fecha_efectiva_pago,
               i.fecha_1ra_autorizacion,
               i.observacion,
               i.ult_fecha_act,
               i.ult_usuario_act,
               e.rnc_o_cedula,
               e.id_registro_patronal,
               e.nombre_comercial,
               Srp_Pkg.ProperCase(e.razon_social) razon_social,
               r.entidad_recaudadora_des,
               i.origen as OrigenPago,
               Srp_Pkg.ProperCase(t.tipo_factura_des) tipo_factura_des
          FROM suirplus.sfc_planilla_mdt_t i,
               SRE_EMPLEADORES_T           e,
               SFC_ENTIDAD_RECAUDADORA_T   r,
               SFC_TIPO_FACTURAS_T         t
         WHERE i.ID_REFERENCIA_PLANILLA = v_noReferencia
           AND i.ID_REGISTRO_PATRONAL = e.id_registro_patronal
           AND i.ID_ENTIDAD_RECAUDADORA = r.id_entidad_recaudadora(+)
           and t.id_tipo_factura = i.id_tipo_factura;
    
    END IF;
  
    p_resultnumber := 0;
    p_IOCursor     := c_cursor;
  
  EXCEPTION
  
    WHEN e_invalidNoReferencia THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(16, NULL, NULL);
      RETURN;
    
    WHEN OTHERS THEN
      v_bd_error     := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultNumber := Seg_Retornar_Cadena_Error(-1, v_bd_error, SQLCODE);
      RETURN;
    
  END;
  --***************************************************************************************************
  -- Trabajar ISR // IR17
  --***************************************************************************************************
  PROCEDURE CargarDatosISRIR17(p_NoReferencia   VARCHAR2,
                               p_NoAutorizacion NUMBER,
                               p_IOCursor       OUT t_cursor,
                               p_resultnumber   OUT VARCHAR2)
  
   IS
    e_invalidNoReferencia EXCEPTION;
    v_bd_error     VARCHAR(1000);
    v_noReferencia VARCHAR2(16);
    c_cursor       t_cursor;
  
  BEGIN
  
    v_noReferencia := p_NoReferencia;
  
    IF v_noReferencia IS NULL THEN
      SELECT id_referencia
        INTO v_noReferencia
        FROM sfc_liquidacion_dgii_v
       WHERE NO_AUTORIZACION = p_NoAutorizacion;
    END IF;
  
    OPEN c_cursor FOR
      select v.tipo tipo,
             e.rnc_o_cedula rnc,
             e.razon_social razon_social,
             e.id_registro_patronal registropatronal,
             b.entidad_recaudadora_des banco,
             nvl(v.id_referencia, 0) referencia,
             v.no_autorizacion no_aut,
             v.STATUS status,
             v.FECHA_EMISION fecha_emision,
             i.TOTAL_IMPORTE importe,
             i.TOTAL_INTERES interes,
             i.TOTAL_RECARGO recargo,
             v.monto_a_pagar total,
             i.FECHA_AUTORIZACION fecha_aut,
             i.FECHA_DESAUTORIZACION fecha_desaut,
             i.ID_USUARIO_AUTORIZA usuario_aut,
             i.ID_USUARIO_DESAUTORIZA usuario_desaut
        from sfc_liquidacion_dgii_v v
        left join sfc_entidad_recaudadora_t b
          on b.id_entidad_recaudadora = v.ID_ENTIDAD_RECAUDADORA
        join sfc_liquidacion_isr_v i
          on i.id_referencia_isr = v.id_referencia
        join sre_empleadores_t e
          on e.id_registro_patronal = i.id_registro_patronal
       where v.id_referencia = v_noReferencia
      union all
      select v.tipo tipo,
             e.rnc_o_cedula rnc,
             e.razon_social razon_social,
             e.id_registro_patronal registropatronal,
             b.entidad_recaudadora_des banco,
             nvl(v.id_referencia, 0) referencia,
             v.no_autorizacion no_aut,
             v.STATUS status,
             v.FECHA_EMISION fecha_emision,
             i.impuesto importe,
             i.INTERESES interes,
             i.RECARGO recargo,
             v.monto_a_pagar total,
             i.FECHA_AUTORIZACION fecha_aut,
             i.FECHA_DESAUTORIZACION fecha_desaut,
             i.ID_USUARIO_AUTORIZA usuario_aut,
             i.ID_USUARIO_DESAUTORIZA usuario_desaut
        from sfc_liquidacion_dgii_v v
        left join sfc_entidad_recaudadora_t b
          on b.id_entidad_recaudadora = v.ID_ENTIDAD_RECAUDADORA
        join sfc_liquidacion_ir17_v i
          on i.ID_REFERENCIA_IR17 = v.id_referencia
        join sre_empleadores_t e
          on e.id_registro_patronal = i.id_registro_patronal
       where v.id_referencia = v_noReferencia;
  
    p_resultnumber := 0;
    p_IOCursor     := c_cursor;
  
  EXCEPTION
  
    WHEN e_invalidNoReferencia THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(16, NULL, NULL);
      RETURN;
    
    WHEN OTHERS THEN
      v_bd_error     := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultNumber := Seg_Retornar_Cadena_Error(-1, v_bd_error, SQLCODE);
      RETURN;
    
  END;
  --***************************************************************************************************
  -- **************************************************************************************************
  -- Program:     Get_Nominas
  -- Description: Trae la nomina solicitada
  -- **************************************************************************************************
  PROCEDURE Get_Nominas(p_RNCoCedula   IN SRE_EMPLEADORES_T.RNC_O_CEDULA%TYPE,
                        p_IOCursor     IN OUT t_Cursor,
                        p_resultnumber OUT VARCHAR2) IS
    v_bd_error VARCHAR(1000);
    c_cursor   t_cursor;
  BEGIN
  
    OPEN c_cursor FOR
      SELECT 6321 ID_Nomina,
             '  ----  todas las nominas  ----  ' Nomina_des,
             'N' tipo_nomina
        FROM dual
      UNION ALL
      SELECT ID_Nomina,
             Srp_Pkg.ProperCase(Nomina_des) Nomina_des,
             tipo_nomina
        FROM SRE_NOMINAS_T n, SRE_EMPLEADORES_T e
       WHERE e.rnc_o_cedula = p_RNCoCedula
         AND e.id_registro_patronal = n.id_registro_patronal
         AND n.id_nomina <> 999
       ORDER BY nomina_des;
  
    p_resultnumber := 0;
    p_IOCursor     := c_cursor;
  
  EXCEPTION
  
    WHEN OTHERS THEN
      v_bd_error     := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultnumber := Seg_Retornar_Cadena_Error(-1, v_bd_error, SQLCODE);
      RETURN;
    
  END;

  -- Insertar_job
  -- **************************************************************************************************
  -- Program:     Insertar_job
  -- Description:
  -- **************************************************************************************************

  PROCEDURE Insertar_Job(p_job_id     SEG_JOB_T.id_job%TYPE,
                         p_nombre_job SEG_JOB_T.nombre_job%TYPE)
  
   IS
  
  BEGIN
  
    INSERT INTO SEG_JOB_T
      (id_job, nombre_job, status, fecha_envio)
    VALUES
      (p_job_id, p_nombre_job, 'S', SYSDATE);
  
  END;

  -- **************************************************************************************************
  -- Program:     get_facturas_pendientes
  -- Description:
  /*
      Program: Get_facturas_pendientes
      Description: Utilizado para obtener las facturas pendientes y vigentes de un empleador.
      Autor: Ronny J. Carreras
      Date: 27/01/2004
  */
  -- **************************************************************************************************

  PROCEDURE get_facturas_pendientes(p_RNCoCedula SRE_EMPLEADORES_T.rnc_o_cedula%TYPE,
                                    p_IOCursor   OUT t_cursor) IS
  
    c_cursor t_cursor;
  
  BEGIN
  
    OPEN c_cursor FOR
      SELECT f.id_referencia,
             DECODE(f.status, 'VI', 'Vigente', 'VE', 'Vencida') status,
             f.fecha_emision,
             f.fecha_limite_pago,
             f.total_general_factura
        FROM sfc_facturas_v f, SRE_EMPLEADORES_T e
       WHERE e.rnc_o_cedula = p_RNCoCedula
         AND f.id_registro_patronal = e.id_registro_patronal
         AND f.status IN ('VE', 'VI')
       ORDER BY f.fecha_emision DESC;
  
    p_IOCursor := c_cursor;
  
  END get_facturas_pendientes;

  -- **************************************************************************************************
  -- Program:     get_ConsultaDeuda_ARL
  -- Description:
  /*
      Program: get_ConsultaDeuda_ARL
      Description: Utilizado para obtener las facturas pendientes de un empleador.
      Autor: Ronny J. Carreras
      Date: 27/01/2004
  */
  -- **************************************************************************************************

  PROCEDURE get_ConsultaDeuda_ARL(p_RNCoCedula SRE_EMPLEADORES_T.rnc_o_cedula%TYPE,
                                  p_IOCursor   OUT t_cursor) IS
  
    c_cursor t_cursor;
  
  BEGIN
  
    OPEN c_cursor FOR
      SELECT f.id_referencia,
             DECODE(f.status, 'VE', 'Vencida') status,
             f.fecha_emision,
             f.fecha_limite_pago,
             f.total_general_factura
        FROM sfc_facturas_v f, SRE_EMPLEADORES_T e
       WHERE e.rnc_o_cedula = p_RNCoCedula
         AND f.id_registro_patronal = e.id_registro_patronal
         AND f.status IN ('VE')
         and f.ID_TIPO_FACTURA <> 'U'
         and f.NO_AUTORIZACION is null
      
       ORDER BY f.fecha_emision DESC;
  
    p_IOCursor := c_cursor;
  
  END get_ConsultaDeuda_ARL;

  --********************************************************************
  --********************************************************************

  Procedure EncabezadoConsultaRNC(p_RNCoCedula          SRE_EMPLEADORES_T.rnc_o_cedula%TYPE,
                                  p_concepto            IN VARCHAR2,
                                  p_CodigoNomina        IN SRE_NOMINAS_T.id_nomina%TYPE,
                                  p_status              IN VARCHAR2,
                                  p_Razon_Social        out varchar2,
                                  p_Nombre_Comercial    out varchar2,
                                  p_Total_de_Referencia out varchar2,
                                  p_Total_Importe       out varchar2,
                                  p_Total_Recargo       out varchar2,
                                  p_Total_Intereses     out varchar2,
                                  p_Total_General       out varchar2,
                                  p_resultnumber        out varchar2)
  
   is
    e_invalidRNC exception;
    e_NoDataFound exception;
    v_bd_error VARCHAR(1000);
  Begin
  
    if not suirplus.sre_empleadores_pkg.isRncOCedulaValida(p_RNCoCedula) then
      raise e_invalidRNC;
    end if;
  
    IF UPPER(p_concepto) = v_tt_SDSS THEN
    
      begin
      
        Select e.razon_social,
               e.nombre_comercial,
               count(f.ID_REFERENCIA),
               sum(f.Total_Importe),
               sum(f.TOTAL_RECARGOS_FACTURA),
               sum(f.TOTAL_INTERES_FACTURA),
               sum(f.TOTAL_GENERAL_FACTURA)
          into p_Razon_Social,
               p_Nombre_Comercial,
               p_Total_de_Referencia,
               p_Total_Importe,
               p_Total_Recargo,
               p_Total_Intereses,
               p_Total_General
          from sre_empleadores_t e
          left join sfc_facturas_v f
            on f.ID_REGISTRO_PATRONAL = e.id_registro_patronal
           and f.status = decode(p_status, 'TODOS', f.status, p_status)
           and f.id_nomina =
               decode(p_CodigoNomina, 6321, f.id_nomina, p_CodigoNomina)
         where e.rnc_o_cedula = p_RNCoCedula
         group by e.razon_social, e.nombre_comercial;
      
      exception
      
        when no_data_found then
          raise e_NoDataFound;
      end;
    
    END IF;
  
    IF UPPER(p_concepto) = v_tt_ISR THEN
      begin
        Select e.razon_social,
               e.nombre_comercial,
               count(f.ID_REFERENCIA_ISR),
               sum(f.TOTAL_IMPORTE),
               sum(f.TOTAL_RECARGO),
               sum(f.TOTAL_INTERES),
               sum(f.TOTAL_A_PAGAR)
          into p_Razon_Social,
               p_Nombre_Comercial,
               p_Total_de_Referencia,
               p_Total_Importe,
               p_Total_Recargo,
               p_Total_Intereses,
               p_Total_General
          from sre_empleadores_t e
          left join suirplus.sfc_liquidacion_isr_v f
            on f.ID_REGISTRO_PATRONAL = e.id_registro_patronal
           and f.status = decode(p_status, 'TODOS', f.status, p_status)
         where e.rnc_o_cedula = p_RNCoCedula
         group by e.razon_social, e.nombre_comercial;
      
      exception
      
        when no_data_found then
          raise e_NoDataFound;
      end;
    
    END IF;
  
    IF UPPER(p_concepto) = v_tt_IR17 THEN
    
      begin
        Select e.razon_social,
               e.nombre_comercial,
               count(f.ID_REFERENCIA_IR17),
               sum(f.LIQUIDACION),
               sum(f.RECARGO),
               sum(f.INTERESES),
               sum(f.LIQUIDACION)
          into p_Razon_Social,
               p_Nombre_Comercial,
               p_Total_de_Referencia,
               p_Total_Importe,
               p_Total_Recargo,
               p_Total_Intereses,
               p_Total_General
          from sre_empleadores_t e
          left join suirplus.sfc_liquidacion_ir17_v f
            on f.ID_REGISTRO_PATRONAL = e.id_registro_patronal
           and f.status = decode(p_status, 'TODOS', f.status, p_status)
         where e.rnc_o_cedula = p_RNCoCedula
         group by e.razon_social, e.nombre_comercial;
      
      exception
      
        when no_data_found then
          raise e_NoDataFound;
      end;
    
    END IF;
  
    IF UPPER(p_concepto) = v_tt_INF THEN
      begin
        Select e.razon_social,
               e.nombre_comercial,
               count(f.id_referencia_infotep),
               sum(f.total_pago_infotep),
               sum(f.total_pago_infotep),
               sum(f.total_pago_infotep),
               sum(f.total_pago_infotep)
          into p_Razon_Social,
               p_Nombre_Comercial,
               p_Total_de_Referencia,
               p_Total_Importe,
               p_Total_Recargo,
               p_Total_Intereses,
               p_Total_General
          from sre_empleadores_t e
          left join suirplus.sfc_liquidacion_infotep_t f
            on f.ID_REGISTRO_PATRONAL = e.id_registro_patronal
           and f.status = decode(p_status, 'TODOS', f.status, p_status)
         where e.rnc_o_cedula = p_RNCoCedula
         group by e.razon_social, e.nombre_comercial;
      
      exception
      
        when no_data_found then
          raise e_NoDataFound;
      end;
    
    END IF;
  
    IF UPPER(p_concepto) = v_tt_MDT THEN
      begin
        Select e.razon_social,
               e.nombre_comercial,
               count(f.id_referencia_planilla),
               sum(f.total_pago),
               sum(f.total_pago),
               sum(f.total_pago),
               sum(f.total_pago)
          into p_Razon_Social,
               p_Nombre_Comercial,
               p_Total_de_Referencia,
               p_Total_Importe,
               p_Total_Recargo,
               p_Total_Intereses,
               p_Total_General
          from sre_empleadores_t e
          left join suirplus.sfc_planilla_mdt_t f
            on f.ID_REGISTRO_PATRONAL = e.id_registro_patronal
           and f.status = decode(p_status, 'TODOS', f.status, p_status)
         where e.rnc_o_cedula = p_RNCoCedula
         group by e.razon_social, e.nombre_comercial;
      
      exception
      
        when no_data_found then
          raise e_NoDataFound;
      end;
    END IF;
  
    p_Total_de_Referencia := nvl(p_Total_de_Referencia, '0');
    p_Total_Importe       := nvl(p_Total_Importe, '0.00');
    p_Total_Recargo       := nvl(p_Total_Recargo, '0.00');
    p_Total_Intereses     := nvl(p_Total_Intereses, '0.00');
    p_Total_General       := nvl(p_Total_General, '0.00');
    p_resultnumber        := 0;
  
  EXCEPTION
  
    WHEN e_invalidRNC THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(150, NULL, NULL);
      RETURN;
    
    WHEN e_NoDataFound THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(10, NULL, NULL);
      RETURN;
    
    WHEN OTHERS THEN
      v_bd_error     := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultnumber := Seg_Retornar_Cadena_Error(-1, v_bd_error, SQLCODE);
      RETURN;
  END;

  -- **************************************************************************************************
  -- Program:     Cons_Facturas
  -- Description:
  -- **************************************************************************************************

  PROCEDURE Cons_Facturas(p_RegistroPatronal IN SRE_EMPLEADORES_T.id_registro_patronal%TYPE,
                          p_concepto         IN VARCHAR2,
                          p_IOCursor         IN OUT t_Cursor,
                          p_resultnumber     OUT VARCHAR2) IS
    v_bd_error VARCHAR(1000);
    c_cursor   t_cursor;
  BEGIN
  
    IF UPPER(p_concepto) = v_tt_SDSS THEN
      OPEN c_cursor FOR
        SELECT f.ID_REFERENCIA,
               f.TOTAL_GENERAL_FACTURA total_notificacion,
               f.TOTAL_INTERES_FACTURA + f.TOTAL_RECARGOS_FACTURA recargos
          FROM sfc_facturas_v f
         WHERE f.ID_REGISTRO_PATRONAL = p_RegistroPatronal
           AND f.STATUS IN ('VI', 'VE');
    END IF;
  
    IF UPPER(p_concepto) = v_tt_ISR THEN
    
      OPEN c_cursor FOR
        SELECT l.ID_REFERENCIA_ISR ID_REFERENCIA,
               l.TOTAL_A_PAGAR total_notificacion,
               l.TOTAL_INTERES + l.TOTAL_RECARGO recargos
          FROM sfc_liquidacion_isr_v l
         WHERE l.ID_REGISTRO_PATRONAL = p_RegistroPatronal
           AND l.STATUS IN ('VI', 'VE');
    
    END IF;
  
    IF UPPER(p_concepto) = v_tt_IR17 THEN
    
      OPEN c_cursor FOR
        SELECT i.id_referencia_ir17 ID_REFERENCIA,
               i.liquidacion total_notificacion,
               i.INTERESES + i.RECARGO recargos
          FROM sfc_liquidacion_ir17_v i
         WHERE i.ID_REGISTRO_PATRONAL = p_RegistroPatronal
           AND i.STATUS IN ('VI', 'VE');
    
    END IF;
  
    IF UPPER(p_concepto) = v_tt_INF THEN
    
      OPEN c_cursor FOR
        SELECT i.id_referencia_infotep ID_REFERENCIA,
               i.total_pago_infotep    total_notificacion
          FROM suirplus.sfc_liquidacion_infotep_t i
         WHERE i.ID_REGISTRO_PATRONAL = p_RegistroPatronal
           AND i.STATUS IN ('VI', 'VE');
    
    END IF;
  
    IF UPPER(p_concepto) = v_tt_MDT THEN
    
      OPEN c_cursor FOR
        SELECT i.id_referencia_planilla ID_REFERENCIA,
               i.total_pago             total_notificacion
          FROM suirplus.sfc_planilla_mdt_t i
         WHERE i.ID_REGISTRO_PATRONAL = p_RegistroPatronal
           AND i.STATUS IN ('VI', 'VE');
    
    END IF;
  
    IF UPPER(p_concepto) IS NULL THEN
      OPEN c_cursor FOR
        SELECT f.ID_REFERENCIA,
               f.TOTAL_GENERAL_FACTURA total_notificacion,
               f.TOTAL_INTERES_FACTURA + f.TOTAL_RECARGOS_FACTURA recargos
          FROM sfc_facturas_v f
         WHERE f.ID_REGISTRO_PATRONAL = p_RegistroPatronal
           AND f.STATUS IN ('VI', 'VE')
        UNION ALL
        SELECT l.ID_REFERENCIA_ISR ID_REFERENCIA,
               l.TOTAL_A_PAGAR total_notificacion,
               l.TOTAL_INTERES + l.TOTAL_RECARGO recargos
          FROM sfc_liquidacion_isr_v l
         WHERE l.ID_REGISTRO_PATRONAL = p_RegistroPatronal
           AND l.STATUS IN ('VI', 'VE')
        UNION ALL
        SELECT i.id_referencia_ir17 ID_REFERENCIA,
               i.liquidacion total_notificacion,
               i.INTERESES + i.RECARGO recargos
          FROM sfc_liquidacion_ir17_v i
         WHERE i.ID_REGISTRO_PATRONAL = p_RegistroPatronal
           AND i.STATUS IN ('VI', 'VE')
        UNION ALL
        SELECT i.id_referencia_infotep ID_REFERENCIA,
               i.total_pago_infotep    total_notificacion,
               0                       recargos
          FROM suirplus.sfc_liquidacion_infotep_t i
         WHERE i.ID_REGISTRO_PATRONAL = p_RegistroPatronal
           AND i.STATUS IN ('VI', 'VE')
        UNION ALL
        SELECT i.id_referencia_planilla ID_REFERENCIA,
               i.total_pago             total_notificacion,
               0                        recargos
          FROM suirplus.sfc_planilla_mdt_t i
         WHERE i.ID_REGISTRO_PATRONAL = p_RegistroPatronal
           AND i.STATUS IN ('VI', 'VE');
    END IF;
  
    p_resultnumber := 0;
    p_IOCursor     := c_cursor;
  
  EXCEPTION
  
    WHEN OTHERS THEN
      v_bd_error     := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultnumber := Seg_Retornar_Cadena_Error(-1, v_bd_error, SQLCODE);
      RETURN;
  END;
  -- **************************************************************************************************
  -- Program:     Cons_Facturas
  -- Description: Consulta de facturas por un Representante, se utiliza en el estado de Cuentas.
  -- **************************************************************************************************

  PROCEDURE Cons_Facturas(p_RegistroPatronal IN SRE_EMPLEADORES_T.id_registro_patronal%TYPE,
                          p_idusuario        IN SEG_USUARIO_T.ID_USUARIO%TYPE,
                          p_concepto         IN VARCHAR2,
                          p_status           IN VARCHAR2,
                          p_IOCursor         OUT t_Cursor,
                          p_resultnumber     OUT VARCHAR2) IS
    e_invalidNoReferencia EXCEPTION;
    e_invalidRegPatronal EXCEPTION;
    v_bd_error     VARCHAR(1000);
    c_cursor       t_cursor;
    v_status       varchar2(100);
    v_cadena       varchar2(4000);
    v_rnc_o_cedula suirplus.sre_empleadores_t.rnc_o_cedula%type;
  
  BEGIN
    if length(p_status) = 4 then
      v_status := '''' || substr(p_status, 1, 2) || ''',''' ||
                  substr(p_status, 3, 2) || '''';
    else
      v_status := '''' || p_status || '''';
    end if;
  
    IF NOT Sfc_Factura_Pkg.isExisteRegistroPatronal(p_RegistroPatronal) THEN
      RAISE e_invalidRegPatronal;
    END IF;
  
    IF p_concepto = v_tt_SDSS THEN
      v_cadena := 'SELECT f.id_referencia id_referencia,
               Srp_Pkg.ProperCase(n.nomina_des) nomina_des,
               f.periodo_factura,
               f.NO_AUTORIZACION,
               (f.total_general_factura) total_general,
               f.TOTAL_RECARGOS_FACTURA total_recargo,
               f.TOTAL_INTERES_FACTURA total_interes,
               f.Total_Importe total_importe,
               f.monto_ajuste,
               e.razon_social,
               Srp_Pkg.DESCESTATUSFactura(f.STATUS) status,
               f.STATUS CodStatus,
               f.FECHA_EMISION,
               f.periodo_factura periodo
          FROM sfc_facturas_v f, SRE_EMPLEADORES_T e, SRE_NOMINAS_T n
         WHERE f.id_registro_patronal = ' ||
                  p_registropatronal || '
           AND f.id_registro_patronal = e.id_registro_patronal
           AND f.id_registro_patronal = n.id_registro_patronal
           AND f.id_nomina = n.id_nomina
           AND f.id_nomina IN
               (SELECT id_nomina
                  FROM SRE_ACCESO_NOMINA t, SEG_USUARIO_T u
                 WHERE u.id_usuario = ''' || p_idusuario || '''
                   AND t.id_nss = u.id_nss
                   AND t.id_registro_patronal = u.id_registro_patronal
                   AND t.status = ''A''
                UNION
                SELECT 999 FROM dual)';
    
      --Para considerar los estatus de la N.P.
      If (p_status = 'VIVE') then
        v_cadena := v_cadena || ' and f.status in (' || v_status || ')
              and f.no_autorizacion is null';
      Else
        --cualquier N.P autorizadas la considero pagada sin importar su estatus
        v_cadena := v_cadena || ' and f.no_autorizacion is not null';
      End if;
    
      v_cadena := v_cadena || ' ORDER BY f.periodo_factura DESC,
                  f.FECHA_EMISION   DESC,
                  f.status          asc,
                  f.id_nomina,
                  f.periodo_factura';
    
      OPEN c_cursor FOR v_cadena;
    END IF;
  
    IF UPPER(p_concepto) = v_tt_ISR THEN
      v_cadena := 'SELECT l.id_referencia_isr id_referencia,
               l.id_nomina as id_nomina,
               ''Liquidacion ISR'' nomina_des,
               l.periodo_liquidacion periodo_factura,
               l.NO_AUTORIZACION,
               l.TOTAL_IMPORTE total_importe,
               l.TOTAL_A_PAGAR total_general,
               l.TOTAL_RECARGO total_recargo,
               l.TOTAL_INTERES total_interes,
               e.razon_social,
               Srp_Pkg.DESCESTATUSFactura(l.STATUS) status,
               l.STATUS CodStatus,
               l.FECHA_EMISION,
               l.periodo_liquidacion periodo
          FROM sfc_liquidacion_isr_v l,
               SRE_EMPLEADORES_T     e,
               SRE_NOMINAS_T         n
         WHERE l.id_registro_patronal = ' ||
                  p_registropatronal || '
           AND l.id_registro_patronal = e.id_registro_patronal
           AND l.id_registro_patronal = n.id_registro_patronal
           AND l.id_nomina = n.id_nomina
           AND ''A'' = (SELECT tipo_representante
                        FROM SRE_REPRESENTANTES_T r, SEG_USUARIO_T u
                       WHERE r.id_nss = u.id_nss
                         AND r.id_registro_patronal = u.id_registro_patronal
                         AND u.id_usuario = ''' ||
                  p_idusuario || ''')';
    
      --Para considerar los status de la liquidacion
      If (p_status = 'VIVE') then
        v_cadena := v_cadena || ' and l.status in (' || v_status ||
                    ') and l.no_autorizacion is null';
      ElsIf (p_status = 'EX') then
        --las exentas
        v_cadena := v_cadena || ' and l.status = ' || v_status ||
                    ' and l.no_autorizacion is null';
      Else
        --cualquier N.P autorizadas la considero pagada sin importar su estatus
        v_cadena := v_cadena || ' and l.no_autorizacion is not null';
      End if;
    
      v_cadena := v_cadena || ' ORDER BY l.periodo_liquidacion DESC,
                  l.FECHA_EMISION       DESC,
                  l.status              asc,
                  l.id_nomina,
                  l.periodo_liquidacion';
    
      OPEN c_cursor FOR v_cadena;
    END IF;
  
    IF UPPER(p_concepto) = v_tt_IR17 THEN
      v_cadena := 'SELECT i.id_referencia_ir17 id_referencia,
               '' '' Nomina_des,
               I.PERIODO_LIQUIDACION periodo_factura,
               i.NO_AUTORIZACION,
               I.IMPUESTO total_importe,
               i.LIQUIDACION total_general,
               i.RECARGO total_recargo,
               i.INTERESES total_interes,
               e.razon_social,
               Srp_Pkg.DESCESTATUSFactura(i.STATUS) STATUS,
               i.STATUS CodStatus,
               i.FECHA_EMISION,
               i.PERIODO_LIQUIDACION periodo
          FROM sfc_liquidacion_ir17_v i, SRE_EMPLEADORES_T e
         WHERE i.ID_REGISTRO_PATRONAL = ' ||
                  p_registropatronal || '
           AND i.ID_REGISTRO_PATRONAL = e.id_registro_patronal';
      /*            AND 'A' = (
              SELECT tipo_representante
              FROM SRE_REPRESENTANTES_T r, SEG_USUARIO_T u
              WHERE r.id_nss = u.id_nss
              AND r.id_registro_patronal = u.id_registro_patronal
              AND u.id_usuario = p_idusuario
      )*/
      --Para considerar los estatus de la liquidacion
      If (p_status = 'VIVE') then
        v_cadena := v_cadena || ' and i.status in (' || v_status ||
                    ') and i.no_autorizacion is null';
      ElsIf (p_status = 'EX') then
        --las exentas
        v_cadena := v_cadena || ' and l.status = ' || v_status ||
                    ' and l.no_autorizacion is null';
      Else
        --cualquier N.P autorizadas la considero pagada sin importar su estatus
        v_cadena := v_cadena || ' and i.no_autorizacion is not null';
      End if;
    
      v_cadena := v_cadena || ' ORDER BY i.PERIODO_LIQUIDACION DESC,
                  i.FECHA_EMISION       DESC,
                  i.STATUS              asc';
    
      OPEN c_CURSOR FOR v_cadena;
    END IF;
  
    IF UPPER(p_concepto) = v_tt_INF THEN
      v_cadena := 'SELECT i.id_referencia_infotep id_referencia,
               '' '' Nomina_des,
               I.PERIODO_LIQUIDACION periodo_factura,
               i.NO_AUTORIZACION,
               i.total_pago_infotep total_general,
               e.razon_social,
               Srp_Pkg.DESCESTATUSFactura(i.STATUS) STATUS,
               i.STATUS CodStatus,
               i.FECHA_EMISION,
               i.PERIODO_LIQUIDACION periodo
          FROM suirplus.sfc_liquidacion_infotep_t i, SRE_EMPLEADORES_T e
         WHERE i.ID_REGISTRO_PATRONAL = ' ||
                  p_registropatronal || '
           AND i.ID_REGISTRO_PATRONAL = e.id_registro_patronal';
    
      --Para considerar los estatus de la liquidacion
      If (p_status = 'VIVE') then
        v_cadena := v_cadena || ' and i.status in (' || v_status || ')
              and i.no_autorizacion is null';
      Else
        --cualquier N.P autorizadas la considero pagada sin importar su estatus
        v_cadena := v_cadena || ' and i.no_autorizacion is not null';
      End if;
    
      v_cadena := v_cadena || ' ORDER BY i.PERIODO_LIQUIDACION DESC,
                  i.FECHA_EMISION       DESC,
                  i.STATUS              asc';
    
      OPEN c_CURSOR FOR v_cadena;
    END IF;
  
    IF UPPER(p_concepto) = v_tt_MDT THEN
      v_cadena := 'SELECT i.id_referencia_planilla id_referencia,
                '' '' Nomina_des,
                I.PERIODO_LIQUIDACION periodo_factura,
                i.NO_AUTORIZACION,
                i.total_pago total_general,
                e.razon_social,
                Srp_Pkg.DESCESTATUSFactura(i.STATUS) STATUS,
                i.STATUS CodStatus,
                i.FECHA_EMISION,
                i.PERIODO_LIQUIDACION periodo,
                i.id_planilla tipo_formulario
           FROM suirplus.sfc_planilla_mdt_t i, SRE_EMPLEADORES_T e
          WHERE i.ID_REGISTRO_PATRONAL = ' ||
                  p_registropatronal || '
            AND i.ID_REGISTRO_PATRONAL = e.id_registro_patronal';
    
      --Para considerar los estatus de la planilla
      If (p_status = 'VIVE') then
        v_cadena := v_cadena || ' and i.status in (' || v_status || ')
              and i.no_autorizacion is null';
      Else
        --cualquier N.P autorizadas la considero pagada sin importar su estatus
        v_cadena := v_cadena || ' and i.no_autorizacion is not null';
      End if;
    
      v_cadena := v_cadena || ' ORDER BY i.PERIODO_LIQUIDACION DESC,
                   i.FECHA_EMISION       DESC,
                   i.STATUS              asc';
    
      OPEN c_CURSOR FOR v_cadena;
    END IF;
  
    IF UPPER(p_concepto) = v_tt_ISRP THEN
      v_cadena := 'select d.periodo_aplicacion periodo,
        count(distinct(d.id_nss)) Total_asalariados,
        d.id_tipo_factura,
        case d.id_tipo_factura
          when ''O'' Then ''Ordinaria''
          when ''R'' Then ''Regenerada por Novedad''
          when ''T'' Then ''Rectificativa''
        end tipo_liquidacion,
        sum (d.salario_isr + d.otros_ingresos_isr + d.ingresos_exentos_isr) Sueldos_Pag_Ag_Re,
        sum (d.ingresos_exentos_isr) Ingresos_exentos,
        sum (d.remuneracion_isr_otros) Rem_otros_agentes,
        sum (d.otros_ingresos_isr) Otras_remuneraciones,
        sum (d.salario_isr + d.otros_ingresos_isr + d.ingresos_exentos_isr + d.remuneracion_isr_otros) Total_pagado,
        sum (d.salario_isr + d.otros_ingresos_isr + d.remuneracion_isr_otros - d.retencion_ss) pago_total_ret
       from suirplus.dgii_det_liquidacion_isr_v d
       where d.rnc_o_cedula = ''' ||
                  suirplus.sre_empleadores_pkg.get_rncocedula(p_registropatronal) || '''
       Group by d.periodo_aplicacion, d.id_tipo_factura';
    
      OPEN c_CURSOR FOR v_cadena;
    END IF;
  
    p_resultnumber := 0;
    p_IOCursor     := c_cursor;
  
  EXCEPTION
  
    WHEN e_invalidRegPatronal THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(3, NULL, NULL);
      RETURN;
    
    WHEN OTHERS THEN
      v_bd_error     := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultnumber := Seg_Retornar_Cadena_Error(-1, v_bd_error, SQLCODE);
      RETURN;
    
  END;

  -- **************************************************************************************************
  -- Program:     Cons_Facturas **
  -- Description: Trae una consulta general de una factura
  -- **************************************************************************************************

  PROCEDURE Cons_Facturas(p_RNCoCedula   IN SRE_EMPLEADORES_T.RNC_O_CEDULA%TYPE,
                          p_CodigoNomina IN SRE_NOMINAS_T.id_nomina%TYPE,
                          p_Status       IN VARCHAR2,
                          p_concepto     IN VARCHAR2,
                          p_IOCursor     OUT t_Cursor,
                          p_resultnumber OUT VARCHAR2) IS
    v_cant_referencias varchar2(50);
    v_bd_error         VARCHAR(1000);
    c_cursor           t_cursor;
  BEGIN
  
    IF p_Status = 'TODAS' THEN
      IF p_CodigoNomina = 6321 THEN
        IF p_concepto = v_tt_SDSS THEN
          SELECT count(NVL(f.id_referencia, '0'))
            INTO v_cant_referencias
            FROM sfc_facturas_v f, SRE_EMPLEADORES_T e
           WHERE e.RNC_O_CEDULA = p_RNCoCedula
             AND f.id_registro_patronal = e.id_registro_patronal;
          OPEN c_cursor FOR
            SELECT f.id_referencia id_referencia,
                   f.id_nomina as id_nomina,
                   Srp_Pkg.ProperCase(n.nomina_des) nomina_des,
                   'Detalles' as Detalles,
                   DECODE(f.tipo_nomina, 'N', 'NOR', 'P', 'PEN', 'D', 'DIS') tipo_nomina,
                   Srp_Pkg.FORMATEAPERIODO(f.periodo_factura) periodo_factura,
                   f.total_general_factura total_general,
                   e.razon_social,
                   f.FECHA_EMISION fecha_emision,
                   f.FECHA_PAGO,
                   Srp_Pkg.DESCESTATUSFactura(f.STATUS) STATUS,
                   f.TOTAL_APORTE_EMPLEADOR_SVDS,
                   f.TOTAL_APORTE_AFILIADOS_SVDS,
                   f.TOTAL_APORTE_EMPLEADOR_SFS,
                   f.TOTAL_APORTE_AFILIADOS_SFS,
                   f.TOTAL_APORTE_VOLUNTARIO,
                   f.TOTAL_APORTE_SRL,
                   f.TOTAL_RECARGOS_FACTURA,
                   f.TOTAL_INTERES_FACTURA,
                   f.Total_Importe,
                   f.TOTAL_GENERAL_FACTURA,
                   'Detalle Factura' AS detalles,
                   v_cant_referencias as Cant_Referencias,
                   f.fecha_limite_pago
              FROM sfc_facturas_v f, SRE_EMPLEADORES_T e, SRE_NOMINAS_T n
             WHERE e.RNC_O_CEDULA = p_RNCoCedula
               AND f.id_registro_patronal = e.id_registro_patronal
               AND f.id_registro_patronal = n.id_registro_patronal
               AND f.id_nomina = n.id_nomina
             ORDER BY f.periodo_factura DESC, f.id_nomina;
        END IF;
      
        IF p_concepto = v_tt_ISR THEN
          BEGIN
            SELECT count(NVL(l.ID_REFERENCIA_ISR, '0'))
              INTO v_cant_referencias
              FROM sfc_liquidacion_isr_v l, SRE_EMPLEADORES_T e
             WHERE e.RNC_O_CEDULA = p_RNCoCedula
               AND l.ID_REGISTRO_PATRONAL = e.id_registro_patronal;
            OPEN c_cursor FOR
              SELECT l.id_referencia_isr id_referencia,
                     l.id_nomina as id_nomina,
                     'Liquidacion ISR' nomina_des,
                     ' ' tipo_nomina,
                     Srp_Pkg.FORMATEAPERIODO(l.periodo_liquidacion) periodo_factura,
                     l.TOTAL_A_PAGAR total_general,
                     e.razon_social,
                     l.FECHA_EMISION fecha_emision,
                     l.fecha_pago,
                     Srp_Pkg.DESCESTATUSFactura(l.STATUS) STATUS,
                     'Detalle Factura' AS detalles,
                     v_cant_referencias as Cant_Referencias,
                     ' ' TOTAL_RECARGOS_FACTURA,
                     ' ' TOTAL_INTERES_FACTURA,
                     ' ' Total_Importe
                FROM sfc_liquidacion_isr_v l,
                     SRE_EMPLEADORES_T     e,
                     SRE_NOMINAS_T         n
               WHERE e.RNC_O_CEDULA = p_RNCoCedula
                 AND l.id_registro_patronal = e.id_registro_patronal
                 AND l.id_registro_patronal = n.id_registro_patronal
                 AND l.id_nomina = n.id_nomina
               ORDER BY l.id_nomina,
                        l.periodo_liquidacion DESC,
                        l.FECHA_EMISION       DESC,
                        l.status;
          END;
        END IF;
      
        IF p_concepto = v_tt_IR17 THEN
          BEGIN
            SELECT count(NVL(i.ID_REFERENCIA_IR17, '0'))
              INTO v_cant_referencias
              FROM sfc_liquidacion_ir17_v i, SRE_EMPLEADORES_T e
             WHERE e.RNC_O_CEDULA = p_RNCoCedula
               AND i.ID_REGISTRO_PATRONAL = e.id_registro_patronal;
            OPEN c_cursor FOR
              SELECT i.id_referencia_ir17 id_referencia,
                     Srp_Pkg.FORMATEAPERIODO(I.PERIODO_LIQUIDACION) periodo_factura,
                     I.LIQUIDACION total_general,
                     e.razon_social,
                     i.FECHA_EMISION,
                     i.FECHA_PAGO,
                     Srp_Pkg.DESCESTATUSFactura(i.STATUS) STATUS,
                     ' ' Nomina_des,
                     ' ' tipo_nomina,
                     'Detalle Factura' AS detalles,
                     v_cant_referencias as Cant_Referencias,
                     ' ' TOTAL_RECARGOS_FACTURA,
                     ' ' TOTAL_INTERES_FACTURA,
                     ' ' Total_Importe
                FROM sfc_liquidacion_ir17_v i, SRE_EMPLEADORES_T e
               WHERE e.RNC_O_CEDULA = p_RNCoCedula
                 AND i.ID_REGISTRO_PATRONAL = e.id_registro_patronal
               ORDER BY i.PERIODO_LIQUIDACION DESC,
                        i.FECHA_EMISION       DESC,
                        i.STATUS;
          END;
        END IF;
      
        IF p_concepto = v_tt_INF THEN
          BEGIN
            SELECT count(NVL(i.ID_REFERENCIA_INFOTEP, '0'))
              INTO v_cant_referencias
              FROM sfc_liquidacion_infotep_t i, SRE_EMPLEADORES_T e
             WHERE e.RNC_O_CEDULA = p_RNCoCedula
               AND i.ID_REGISTRO_PATRONAL = e.id_registro_patronal;
            OPEN c_cursor FOR
              SELECT i.id_referencia_infotep id_referencia,
                     Srp_Pkg.FORMATEAPERIODO(I.PERIODO_LIQUIDACION) periodo_factura,
                     I.TOTAL_PAGO_INFOTEP total_general,
                     e.razon_social,
                     i.FECHA_EMISION,
                     i.FECHA_PAGO,
                     Srp_Pkg.DESCESTATUSFactura(i.STATUS) STATUS,
                     ' ' Nomina_des,
                     ' ' tipo_nomina,
                     'Detalle Factura' AS detalles,
                     v_cant_referencias as Cant_Referencias,
                     ' ' TOTAL_RECARGOS_FACTURA,
                     ' ' TOTAL_INTERES_FACTURA,
                     ' ' Total_Importe
                FROM suirplus.sfc_liquidacion_infotep_t i,
                     SRE_EMPLEADORES_T                  e
               WHERE e.RNC_O_CEDULA = p_RNCoCedula
                 AND i.ID_REGISTRO_PATRONAL = e.id_registro_patronal
               ORDER BY i.PERIODO_LIQUIDACION DESC,
                        i.FECHA_EMISION       DESC,
                        i.STATUS;
          END;
        END IF;
      
        IF p_concepto = v_tt_MDT THEN
          BEGIN
            SELECT count(NVL(i.ID_REFERENCIA_PLANILLA, '0'))
              INTO v_cant_referencias
              FROM sfc_planilla_mdt_t i, SRE_EMPLEADORES_T e
             WHERE e.RNC_O_CEDULA = p_RNCoCedula
               AND i.ID_REGISTRO_PATRONAL = e.id_registro_patronal;
            OPEN c_cursor FOR
              SELECT i.id_referencia_planilla id_referencia,
                     Srp_Pkg.FORMATEAPERIODO(I.PERIODO_LIQUIDACION) periodo_factura,
                     I.TOTAL_PAGO total_general,
                     e.razon_social,
                     i.FECHA_EMISION,
                     i.FECHA_PAGO,
                     Srp_Pkg.DESCESTATUSFactura(i.STATUS) STATUS,
                     ' ' Nomina_des,
                     ' ' tipo_nomina,
                     'Detalle Factura' AS detalles,
                     v_cant_referencias as Cant_Referencias,
                     ' ' TOTAL_RECARGOS_FACTURA,
                     ' ' TOTAL_INTERES_FACTURA,
                     ' ' Total_Importe
                FROM suirplus.sfc_planilla_mdt_t i, SRE_EMPLEADORES_T e
               WHERE e.RNC_O_CEDULA = p_RNCoCedula
                 AND i.ID_REGISTRO_PATRONAL = e.id_registro_patronal
               ORDER BY i.PERIODO_LIQUIDACION DESC,
                        i.FECHA_EMISION       DESC,
                        i.STATUS;
          END;
        END IF;
      ELSE
      
        IF p_concepto = v_tt_SDSS THEN
          SELECT count(NVL(f.id_referencia, '0'))
            INTO v_cant_referencias
            FROM sfc_facturas_v f, SRE_EMPLEADORES_T e
           WHERE e.RNC_O_CEDULA = p_RNCoCedula
             AND f.id_registro_patronal = e.id_registro_patronal;
          OPEN c_cursor FOR
            SELECT f.id_referencia id_referencia,
                   f.id_nomina as id_nomina,
                   Srp_Pkg.ProperCase(n.nomina_des) nomina_des,
                   DECODE(f.tipo_nomina, 'N', 'NOR', 'P', 'PEN', 'D', 'DIS') tipo_nomina,
                   Srp_Pkg.FORMATEAPERIODO(f.periodo_factura) periodo_factura,
                   f.total_general_factura total_general,
                   e.razon_social,
                   f.FECHA_EMISION,
                   f.FECHA_PAGO,
                   Srp_Pkg.DESCESTATUSFactura(f.STATUS) STATUS,
                   f.TOTAL_APORTE_EMPLEADOR_SVDS,
                   f.TOTAL_APORTE_AFILIADOS_SVDS,
                   f.TOTAL_APORTE_EMPLEADOR_SFS,
                   f.TOTAL_APORTE_AFILIADOS_SFS,
                   f.TOTAL_APORTE_VOLUNTARIO,
                   f.TOTAL_APORTE_SRL,
                   f.TOTAL_RECARGOS_FACTURA,
                   f.TOTAL_INTERES_FACTURA,
                   f.Total_Importe,
                   f.TOTAL_GENERAL_FACTURA,
                   'Detalle Factura' AS detalles,
                   v_cant_referencias as Cant_Referencias,
                   ' ' TOTAL_RECARGOS_FACTURA,
                   ' ' TOTAL_INTERES_FACTURA,
                   ' ' Total_Importe,
                   f.fecha_limite_pago
              FROM sfc_facturas_v f, SRE_EMPLEADORES_T e, SRE_NOMINAS_T n
             WHERE e.RNC_O_CEDULA = p_RNCoCedula
               AND f.id_registro_patronal = e.id_registro_patronal
               AND f.id_registro_patronal = n.id_registro_patronal
                  --AND f.id_nomina = p_CodigoNomina
               AND f.id_nomina = n.id_nomina
             ORDER BY f.periodo_factura DESC, f.id_nomina;
        END IF;
      
        IF p_concepto = v_tt_ISR THEN
          BEGIN
            SELECT count(NVL(l.ID_REFERENCIA_ISR, '0'))
              INTO v_cant_referencias
              FROM sfc_liquidacion_isr_v l, SRE_EMPLEADORES_T e
             WHERE e.RNC_O_CEDULA = p_RNCoCedula
               AND l.ID_REGISTRO_PATRONAL = e.id_registro_patronal;
            OPEN c_cursor FOR
              SELECT l.id_referencia_isr id_referencia,
                     l.id_nomina as id_nomina,
                     'Liquidacion ISR' nomina_des,
                     ' ' tipo_nomina,
                     Srp_Pkg.FORMATEAPERIODO(l.periodo_liquidacion) periodo_factura,
                     l.TOTAL_A_PAGAR total_general,
                     e.razon_social,
                     l.FECHA_EMISION,
                     l.FECHA_PAGO,
                     Srp_Pkg.DESCESTATUSFactura(l.STATUS) STATUS,
                     'Detalle Factura' AS detalles,
                     v_cant_referencias as Cant_Referencias,
                     ' ' TOTAL_RECARGOS_FACTURA,
                     ' ' TOTAL_INTERES_FACTURA,
                     ' ' Total_Importe
                FROM sfc_liquidacion_isr_v l,
                     SRE_EMPLEADORES_T     e,
                     SRE_NOMINAS_T         n
               WHERE e.RNC_O_CEDULA = p_RNCoCedula
                 AND l.id_registro_patronal = e.id_registro_patronal
                 AND l.id_registro_patronal = n.id_registro_patronal
                    --AND l.id_nomina = p_CodigoNomina
                 AND l.id_nomina = n.id_nomina
               ORDER BY l.id_nomina,
                        l.periodo_liquidacion DESC,
                        l.FECHA_EMISION       DESC,
                        l.status;
          END;
        END IF;
      
        IF p_concepto = v_tt_IR17 THEN
          BEGIN
            SELECT count(NVL(i.ID_REFERENCIA_IR17, '0'))
              INTO v_cant_referencias
              FROM sfc_liquidacion_ir17_v i, SRE_EMPLEADORES_T e
             WHERE e.RNC_O_CEDULA = p_RNCoCedula
               AND i.ID_REGISTRO_PATRONAL = e.id_registro_patronal;
            OPEN c_cursor FOR
              SELECT i.id_referencia_ir17 id_referencia,
                     Srp_Pkg.FORMATEAPERIODO(I.PERIODO_LIQUIDACION) periodo_factura,
                     'Liquidacion IR17' nomina_des,
                     ' ' tipo_nomina,
                     I.LIQUIDACION total_general,
                     e.razon_social,
                     i.FECHA_EMISION,
                     i.FECHA_PAGO,
                     Srp_Pkg.DESCESTATUSFactura(i.STATUS) STATUS,
                     v_cant_referencias as Cant_Referencias,
                     ' ' TOTAL_RECARGOS_FACTURA,
                     ' ' TOTAL_INTERES_FACTURA,
                     ' ' Total_Importe
                FROM sfc_liquidacion_ir17_v i, SRE_EMPLEADORES_T e
               WHERE e.RNC_O_CEDULA = p_RNCoCedula
                 AND i.ID_REGISTRO_PATRONAL = e.id_registro_patronal
               ORDER BY i.PERIODO_LIQUIDACION DESC,
                        i.FECHA_EMISION       DESC,
                        i.STATUS;
          END;
        END IF;
      
        IF p_concepto = v_tt_INF THEN
          BEGIN
            SELECT count(NVL(i.ID_REFERENCIA_INFOTEP, '0'))
              INTO v_cant_referencias
              FROM suirplus.sfc_liquidacion_infotep_t i,
                   SRE_EMPLEADORES_T                  e
             WHERE e.RNC_O_CEDULA = p_RNCoCedula
               AND i.ID_REGISTRO_PATRONAL = e.id_registro_patronal;
            OPEN c_cursor FOR
              SELECT i.id_referencia_infotep id_referencia,
                     Srp_Pkg.FORMATEAPERIODO(I.PERIODO_LIQUIDACION) periodo_factura,
                     'Liquidacion INFOTEP' nomina_des,
                     ' ' tipo_nomina,
                     ' ' detalles,
                     I.TOTAL_PAGO_INFOTEP total_general,
                     e.razon_social,
                     i.FECHA_EMISION,
                     i.FECHA_PAGO,
                     Srp_Pkg.DESCESTATUSFactura(i.STATUS) STATUS,
                     v_cant_referencias as Cant_Referencias,
                     ' ' TOTAL_RECARGOS_FACTURA,
                     ' ' TOTAL_INTERES_FACTURA,
                     ' ' Total_Importe
                FROM suirplus.sfc_liquidacion_infotep_t i,
                     SRE_EMPLEADORES_T                  e
               WHERE e.RNC_O_CEDULA = p_RNCoCedula
                 AND i.ID_REGISTRO_PATRONAL = e.id_registro_patronal
               ORDER BY i.PERIODO_LIQUIDACION DESC,
                        i.FECHA_EMISION       DESC,
                        i.STATUS;
          END;
        END IF;
      
        IF p_concepto = v_tt_MDT THEN
          BEGIN
            SELECT count(NVL(i.ID_REFERENCIA_planilla, '0'))
              INTO v_cant_referencias
              FROM suirplus.sfc_planilla_mdt_t i, SRE_EMPLEADORES_T e
             WHERE e.RNC_O_CEDULA = p_RNCoCedula
               AND i.ID_REGISTRO_PATRONAL = e.id_registro_patronal;
            OPEN c_cursor FOR
              SELECT i.id_referencia_planilla id_referencia,
                     Srp_Pkg.FORMATEAPERIODO(I.PERIODO_LIQUIDACION) periodo_factura,
                     'Liquidacion PLANILLA MDT' nomina_des,
                     ' ' tipo_nomina,
                     ' ' detalles,
                     I.TOTAL_PAGO total_general,
                     e.razon_social,
                     i.FECHA_EMISION,
                     i.FECHA_PAGO,
                     Srp_Pkg.DESCESTATUSFactura(i.STATUS) STATUS,
                     v_cant_referencias as Cant_Referencias,
                     ' ' TOTAL_RECARGOS_FACTURA,
                     ' ' TOTAL_INTERES_FACTURA,
                     ' ' Total_Importe
                FROM suirplus.sfc_planilla_mdt_t i, SRE_EMPLEADORES_T e
               WHERE e.RNC_O_CEDULA = p_RNCoCedula
                 AND i.ID_REGISTRO_PATRONAL = e.id_registro_patronal
               ORDER BY i.PERIODO_LIQUIDACION DESC,
                        i.FECHA_EMISION       DESC,
                        i.STATUS;
          END;
        END IF;
      END IF;
    
    ELSE
      IF p_CodigoNomina = 6321 THEN
        IF p_concepto = v_tt_SDSS THEN
          SELECT count(NVL(f.id_referencia, '0'))
            INTO v_cant_referencias
            FROM sfc_facturas_v f, SRE_EMPLEADORES_T e
           WHERE e.RNC_O_CEDULA = p_RNCoCedula
             AND f.id_registro_patronal = e.id_registro_patronal
             AND f.status = p_Status;
          OPEN c_cursor FOR
            SELECT f.id_referencia id_referencia,
                   f.id_nomina as id_nomina,
                   Srp_Pkg.ProperCase(n.nomina_des) nomina_des,
                   DECODE(f.tipo_nomina, 'N', 'NOR', 'P', 'PEN', 'D', 'DIS') tipo_nomina,
                   Srp_Pkg.FORMATEAPERIODO(f.periodo_factura) periodo_factura,
                   f.total_general_factura total_general,
                   e.razon_social,
                   f.FECHA_EMISION,
                   f.FECHA_PAGO,
                   Srp_Pkg.DESCESTATUSFactura(f.STATUS) STATUS,
                   f.TOTAL_APORTE_EMPLEADOR_SVDS,
                   f.TOTAL_APORTE_AFILIADOS_SVDS,
                   f.TOTAL_APORTE_EMPLEADOR_SFS,
                   f.TOTAL_APORTE_AFILIADOS_SFS,
                   f.TOTAL_APORTE_VOLUNTARIO,
                   f.TOTAL_APORTE_SRL,
                   f.TOTAL_RECARGOS_FACTURA,
                   f.TOTAL_INTERES_FACTURA,
                   f.Total_Importe,
                   f.TOTAL_GENERAL_FACTURA,
                   'Detalle Factura' AS detalles,
                   v_cant_referencias as Cant_Referencias,
                   f.fecha_limite_pago
              FROM sfc_facturas_v f, SRE_EMPLEADORES_T e, SRE_NOMINAS_T n
             WHERE e.RNC_O_CEDULA = p_RNCoCedula
               AND f.id_registro_patronal = e.id_registro_patronal
               AND f.id_registro_patronal = n.id_registro_patronal
               AND f.id_nomina = n.id_nomina
               AND f.status = p_Status
             ORDER BY f.periodo_factura DESC, f.id_nomina;
        END IF;
      
        IF p_concepto = v_tt_ISR THEN
          BEGIN
            SELECT count(NVL(l.ID_REFERENCIA_ISR, '0'))
              INTO v_cant_referencias
              FROM sfc_liquidacion_isr_v l, SRE_EMPLEADORES_T e
             WHERE e.RNC_O_CEDULA = p_RNCoCedula
               AND l.id_registro_patronal = e.id_registro_patronal
               AND l.status = p_Status;
            OPEN c_cursor FOR
              SELECT l.id_referencia_isr id_referencia,
                     l.id_nomina as id_nomina,
                     'Liquidacion ISR' nomina_des,
                     ' ' tipo_nomina,
                     Srp_Pkg.FORMATEAPERIODO(l.periodo_liquidacion) periodo_factura,
                     l.TOTAL_A_PAGAR total_general,
                     e.razon_social,
                     l.FECHA_EMISION,
                     l.fecha_pago,
                     Srp_Pkg.DESCESTATUSFactura(l.STATUS) STATUS,
                     'Detalle Factura' AS detalles,
                     v_cant_referencias as Cant_Referencias,
                     ' ' TOTAL_RECARGOS_FACTURA,
                     ' ' TOTAL_INTERES_FACTURA,
                     ' ' Total_Importe
                FROM sfc_liquidacion_isr_v l,
                     SRE_EMPLEADORES_T     e,
                     SRE_NOMINAS_T         n
               WHERE e.RNC_O_CEDULA = p_RNCoCedula
                 AND l.id_registro_patronal = e.id_registro_patronal
                 AND l.id_registro_patronal = n.id_registro_patronal
                 AND l.id_nomina = n.id_nomina
                 AND l.status = p_Status
               ORDER BY l.id_nomina,
                        l.periodo_liquidacion DESC,
                        l.FECHA_EMISION       DESC,
                        l.status;
          
          END;
        END IF;
      
        IF p_concepto = v_tt_IR17 THEN
          BEGIN
            SELECT count(NVL(i.ID_REFERENCIA_IR17, '0'))
              INTO v_cant_referencias
              FROM sfc_liquidacion_ir17_v i, SRE_EMPLEADORES_T e
             WHERE e.RNC_O_CEDULA = p_RNCoCedula
               AND i.ID_REGISTRO_PATRONAL = e.id_registro_patronal
               AND i.status = p_Status;
            OPEN c_cursor FOR
              SELECT i.id_referencia_ir17 id_referencia,
                     Srp_Pkg.FORMATEAPERIODO(I.PERIODO_LIQUIDACION) periodo_factura,
                     'Liquidacion IR17' nomina_des,
                     ' ' tipo_nomina,
                     I.LIQUIDACION total_general,
                     e.razon_social,
                     i.FECHA_EMISION,
                     i.FECHA_PAGO,
                     Srp_Pkg.DESCESTATUSFactura(i.STATUS) STATUS,
                     v_cant_referencias as Cant_Referencias,
                     'Detalle Factura' AS detalles,
                     ' ' TOTAL_RECARGOS_FACTURA,
                     ' ' TOTAL_INTERES_FACTURA,
                     ' ' Total_Importe
                FROM sfc_liquidacion_ir17_v i, SRE_EMPLEADORES_T e
               WHERE e.RNC_O_CEDULA = p_RNCoCedula
                 AND i.ID_REGISTRO_PATRONAL = e.id_registro_patronal
                 AND i.status = p_Status
               ORDER BY i.PERIODO_LIQUIDACION DESC,
                        i.FECHA_EMISION       DESC,
                        i.STATUS;
          END;
        END IF;
      
        IF p_concepto = v_tt_INF THEN
          BEGIN
            SELECT count(NVL(i.ID_REFERENCIA_INFOTEP, '0'))
              INTO v_cant_referencias
              FROM suirplus.sfc_liquidacion_infotep_t i,
                   SRE_EMPLEADORES_T                  e
             WHERE e.RNC_O_CEDULA = p_RNCoCedula
               AND i.ID_REGISTRO_PATRONAL = e.id_registro_patronal
               AND i.status = p_Status;
            OPEN c_cursor FOR
              SELECT i.id_referencia_infotep id_referencia,
                     Srp_Pkg.FORMATEAPERIODO(I.PERIODO_LIQUIDACION) periodo_factura,
                     'Liquidacion INFOTEP' nomina_des,
                     ' ' tipo_nomina,
                     ' ' detalles,
                     I.Total_Pago_Infotep total_general,
                     e.razon_social,
                     i.FECHA_EMISION,
                     i.FECHA_PAGO,
                     Srp_Pkg.DESCESTATUSFactura(i.STATUS) STATUS,
                     v_cant_referencias as Cant_Referencias,
                     ' ' TOTAL_RECARGOS_FACTURA,
                     ' ' TOTAL_INTERES_FACTURA,
                     ' ' Total_Importe
                FROM suirplus.sfc_liquidacion_infotep_t i,
                     SRE_EMPLEADORES_T                  e
               WHERE e.RNC_O_CEDULA = p_RNCoCedula
                 AND i.ID_REGISTRO_PATRONAL = e.id_registro_patronal
                 AND i.status = p_Status
               ORDER BY i.PERIODO_LIQUIDACION DESC,
                        i.FECHA_EMISION       DESC,
                        i.STATUS;
          END;
        END IF;
      
        IF p_concepto = v_tt_MDT THEN
          BEGIN
            SELECT count(NVL(i.ID_REFERENCIA_PLANILLA, '0'))
              INTO v_cant_referencias
              FROM suirplus.sfc_planilla_mdt_t i, SRE_EMPLEADORES_T e
             WHERE e.RNC_O_CEDULA = p_RNCoCedula
               AND i.ID_REGISTRO_PATRONAL = e.id_registro_patronal
               AND i.status = p_Status;
            OPEN c_cursor FOR
              SELECT i.id_referencia_planilla id_referencia,
                     Srp_Pkg.FORMATEAPERIODO(I.PERIODO_LIQUIDACION) periodo_factura,
                     'Liquidacion PLANILLA MDT' nomina_des,
                     ' ' tipo_nomina,
                     ' ' detalles,
                     I.Total_Pago total_general,
                     e.razon_social,
                     i.FECHA_EMISION,
                     i.FECHA_PAGO,
                     Srp_Pkg.DESCESTATUSFactura(i.STATUS) STATUS,
                     v_cant_referencias as Cant_Referencias,
                     ' ' TOTAL_RECARGOS_FACTURA,
                     ' ' TOTAL_INTERES_FACTURA,
                     ' ' Total_Importe
                FROM suirplus.sfc_planilla_mdt_t i, SRE_EMPLEADORES_T e
               WHERE e.RNC_O_CEDULA = p_RNCoCedula
                 AND i.ID_REGISTRO_PATRONAL = e.id_registro_patronal
                 AND i.status = p_Status
               ORDER BY i.PERIODO_LIQUIDACION DESC,
                        i.FECHA_EMISION       DESC,
                        i.STATUS;
          END;
        END IF;
      ELSE
        IF p_concepto = v_tt_SDSS THEN
          SELECT count(NVL(f.id_referencia, '0'))
            INTO v_cant_referencias
            FROM sfc_facturas_v f, SRE_EMPLEADORES_T e
           WHERE e.RNC_O_CEDULA = p_RNCoCedula
             AND f.id_registro_patronal = e.id_registro_patronal
             AND f.status = p_Status;
          OPEN c_cursor FOR
            SELECT f.id_referencia id_referencia,
                   f.id_nomina as id_nomina,
                   Srp_Pkg.ProperCase(n.nomina_des) nomina_des,
                   DECODE(f.tipo_nomina, 'N', 'NOR', 'P', 'PEN', 'D', 'DIS') tipo_nomina,
                   Srp_Pkg.FORMATEAPERIODO(f.periodo_factura) periodo_factura,
                   f.total_general_factura total_general,
                   e.razon_social,
                   f.FECHA_EMISION,
                   f.FECHA_PAGO,
                   Srp_Pkg.DESCESTATUSFactura(f.STATUS) STATUS,
                   f.TOTAL_APORTE_EMPLEADOR_SVDS,
                   f.TOTAL_APORTE_AFILIADOS_SVDS,
                   f.TOTAL_APORTE_EMPLEADOR_SFS,
                   f.TOTAL_APORTE_AFILIADOS_SFS,
                   f.TOTAL_APORTE_VOLUNTARIO,
                   f.TOTAL_APORTE_SRL,
                   f.TOTAL_RECARGOS_FACTURA,
                   f.TOTAL_INTERES_FACTURA,
                   f.Total_Importe,
                   f.TOTAL_GENERAL_FACTURA,
                   'Detalle Factura' AS detalles,
                   v_cant_referencias as Cant_Referencias,
                   f.fecha_limite_pago
              FROM sfc_facturas_v f, SRE_EMPLEADORES_T e, SRE_NOMINAS_T n
             WHERE e.RNC_O_CEDULA = p_RNCoCedula
               AND f.id_registro_patronal = e.id_registro_patronal
               AND f.id_registro_patronal = n.id_registro_patronal
               AND f.id_nomina = p_CodigoNomina
               AND f.id_nomina = n.id_nomina
               AND f.status = p_Status
             ORDER BY f.periodo_factura DESC, f.id_nomina;
        END IF;
      
        IF p_concepto = v_tt_ISR THEN
          BEGIN
            SELECT count(NVL(L.ID_REFERENCIA_ISR, '0'))
              INTO v_cant_referencias
              FROM sfc_liquidacion_isr_v l, SRE_EMPLEADORES_T e
             WHERE e.RNC_O_CEDULA = p_RNCoCedula
               AND l.id_registro_patronal = e.id_registro_patronal
               AND l.status = p_Status;
            OPEN c_cursor FOR
              SELECT l.id_referencia_isr id_referencia,
                     l.id_nomina as id_nomina,
                     'Liquidacion ISR' nomina_des,
                     ' ' tipo_nomina,
                     Srp_Pkg.FORMATEAPERIODO(l.periodo_liquidacion) periodo_factura,
                     l.TOTAL_A_PAGAR total_general,
                     e.razon_social,
                     l.FECHA_EMISION,
                     l.FECHA_PAGO,
                     Srp_Pkg.DESCESTATUSFactura(l.STATUS) STATUS,
                     'Detalle Factura' AS detalles,
                     v_cant_referencias as Cant_Referencias,
                     ' ' TOTAL_RECARGOS_FACTURA,
                     ' ' TOTAL_INTERES_FACTURA,
                     ' ' Total_Importe
                FROM sfc_liquidacion_isr_v l,
                     SRE_EMPLEADORES_T     e,
                     SRE_NOMINAS_T         n
               WHERE e.RNC_O_CEDULA = p_RNCoCedula
                 AND l.id_registro_patronal = e.id_registro_patronal
                 AND l.id_registro_patronal = n.id_registro_patronal
                 AND l.id_nomina = p_CodigoNomina
                 AND l.id_nomina = n.id_nomina
                 AND l.status = p_Status
               ORDER BY l.id_nomina,
                        l.periodo_liquidacion DESC,
                        l.FECHA_EMISION       DESC,
                        l.status;
          END;
        END IF;
      
        IF p_concepto = v_tt_IR17 THEN
          BEGIN
            SELECT count(NVL(I.ID_REFERENCIA_IR17, '0'))
              INTO v_cant_referencias
              FROM sfc_liquidacion_ir17_v i, SRE_EMPLEADORES_T e
             WHERE e.RNC_O_CEDULA = p_RNCoCedula
               AND i.id_registro_patronal = e.id_registro_patronal
               AND i.status = p_Status;
            OPEN c_cursor FOR
              SELECT i.id_referencia_ir17 id_referencia,
                     Srp_Pkg.FORMATEAPERIODO(I.PERIODO_LIQUIDACION) periodo_factura,
                     'Liquidacion IR17' nomina_des,
                     ' ' tipo_nomina,
                     I.LIQUIDACION total_general,
                     e.razon_social,
                     i.FECHA_EMISION,
                     i.FECHA_PAGO,
                     Srp_Pkg.DESCESTATUSFactura(i.STATUS) STATUS,
                     v_cant_referencias as Cant_Referencias,
                     'Detalle Factura' AS detalles,
                     ' ' TOTAL_RECARGOS_FACTURA,
                     ' ' TOTAL_INTERES_FACTURA,
                     ' ' Total_Importe
                FROM sfc_liquidacion_ir17_v i, SRE_EMPLEADORES_T e
               WHERE e.RNC_O_CEDULA = p_RNCoCedula
                 AND i.ID_REGISTRO_PATRONAL = e.id_registro_patronal
                 and i.status = p_Status
               ORDER BY i.PERIODO_LIQUIDACION DESC,
                        i.FECHA_EMISION       DESC,
                        i.STATUS;
          END;
        END IF;
      
        IF p_concepto = v_tt_INF THEN
          BEGIN
            SELECT count(NVL(I.ID_REFERENCIA_INFOTEP, '0'))
              INTO v_cant_referencias
              FROM suirplus.sfc_liquidacion_infotep_t i,
                   SRE_EMPLEADORES_T                  e
             WHERE e.RNC_O_CEDULA = p_RNCoCedula
               AND i.id_registro_patronal = e.id_registro_patronal
               AND i.status = p_Status;
            OPEN c_cursor FOR
              SELECT i.id_referencia_infotep id_referencia,
                     Srp_Pkg.FORMATEAPERIODO(I.PERIODO_LIQUIDACION) periodo_factura,
                     'Liquidacion INFOTEP' nomina_des,
                     ' ' tipo_nomina,
                     ' ' detalles,
                     I.Total_Pago_Infotep total_general,
                     e.razon_social,
                     i.FECHA_EMISION,
                     i.FECHA_PAGO,
                     Srp_Pkg.DESCESTATUSFactura(i.STATUS) STATUS,
                     v_cant_referencias as Cant_Referencias,
                     ' ' TOTAL_RECARGOS_FACTURA,
                     ' ' TOTAL_INTERES_FACTURA,
                     ' ' Total_Importe
                FROM suirplus.sfc_liquidacion_infotep_t i,
                     SRE_EMPLEADORES_T                  e
               WHERE e.RNC_O_CEDULA = p_RNCoCedula
                 AND i.ID_REGISTRO_PATRONAL = e.id_registro_patronal
                 and i.status = p_Status
               ORDER BY i.PERIODO_LIQUIDACION DESC,
                        i.FECHA_EMISION       DESC,
                        i.STATUS;
          END;
        END IF;
      
        IF p_concepto = v_tt_MDT THEN
          BEGIN
            SELECT count(NVL(I.ID_REFERENCIA_PLANILLA, '0'))
              INTO v_cant_referencias
              FROM suirplus.sfc_planilla_mdt_t i, SRE_EMPLEADORES_T e
             WHERE e.RNC_O_CEDULA = p_RNCoCedula
               AND i.id_registro_patronal = e.id_registro_patronal
               AND i.status = p_Status;
            OPEN c_cursor FOR
              SELECT i.id_referencia_planilla id_referencia,
                     Srp_Pkg.FORMATEAPERIODO(I.PERIODO_LIQUIDACION) periodo_factura,
                     'Liquidacion PLANILLA MDT' nomina_des,
                     ' ' tipo_nomina,
                     ' ' detalles,
                     I.Total_Pago total_general,
                     e.razon_social,
                     i.FECHA_EMISION,
                     i.FECHA_PAGO,
                     Srp_Pkg.DESCESTATUSFactura(i.STATUS) STATUS,
                     v_cant_referencias as Cant_Referencias,
                     ' ' TOTAL_RECARGOS_FACTURA,
                     ' ' TOTAL_INTERES_FACTURA,
                     ' ' Total_Importe
                FROM suirplus.sfc_planilla_mdt_t i, SRE_EMPLEADORES_T e
               WHERE e.RNC_O_CEDULA = p_RNCoCedula
                 AND i.ID_REGISTRO_PATRONAL = e.id_registro_patronal
                 and i.status = p_Status
               ORDER BY i.PERIODO_LIQUIDACION DESC,
                        i.FECHA_EMISION       DESC,
                        i.STATUS;
          END;
        END IF;
      END IF;
    END IF;
  
    p_resultnumber := p_Status;
    p_IOCursor     := c_cursor;
  
  EXCEPTION
  
    WHEN OTHERS THEN
      v_bd_error     := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultnumber := Seg_Retornar_Cadena_Error(-1, v_bd_error, SQLCODE);
      RETURN;
    
  END;

  --/////////////////////////////////////////////////////////////

  -- **************************************************************************************************
  -- Program:     Cons_Facturas
  -- Description: Trae una consulta general de una factura
  -- **************************************************************************************************

  PROCEDURE Cons_Facturas(p_RNCoCedula   IN SRE_EMPLEADORES_T.RNC_O_CEDULA%TYPE,
                          p_concepto     IN char,
                          p_algo         in varchar2,
                          p_IOCursor     OUT t_Cursor,
                          p_resultnumber OUT VARCHAR2) IS
    --     v_cant_referencias        varchar2(50);
    v_bd_error VARCHAR(1000);
    c_cursor   t_cursor;
  
  BEGIN
  
    IF p_concepto = v_tt_SDSS THEN
    
      OPEN c_cursor FOR
        SELECT f.id_referencia id_referencia,
               f.id_nomina as id_nomina,
               Srp_Pkg.ProperCase(n.nomina_des) nomina_des,
               suirplus.Srp_Pkg.FORMATEAPERIODO(f.periodo_factura) periodo_factura,
               f.total_general_factura total_general,
               e.razon_social,
               e.rnc_o_cedula
          FROM sfc_facturas_v f, SRE_EMPLEADORES_T e, SRE_NOMINAS_T n
         WHERE e.RNC_O_CEDULA = p_RNCoCedula
           AND f.id_registro_patronal = e.id_registro_patronal
           AND f.id_registro_patronal = n.id_registro_patronal
           AND f.id_nomina = n.id_nomina
           and f.STATUS in ('VE', 'VI')
           and f.NO_AUTORIZACION is null
         ORDER BY f.periodo_factura asc, f.id_nomina;
    
    END IF;
  
    IF p_concepto = v_tt_ISR THEN
      BEGIN
      
        OPEN c_cursor FOR
          SELECT l.id_referencia_isr id_referencia,
                 l.id_nomina as id_nomina,
                 'Liquidacion ISR' nomina_des,
                 Srp_Pkg.FORMATEAPERIODO(l.periodo_liquidacion) periodo_factura,
                 l.TOTAL_A_PAGAR total_general,
                 e.razon_social,
                 e.rnc_o_cedula
            FROM sfc_liquidacion_isr_v l,
                 SRE_EMPLEADORES_T     e,
                 SRE_NOMINAS_T         n
           WHERE e.RNC_O_CEDULA = p_RNCoCedula
             AND l.id_registro_patronal = e.id_registro_patronal
             AND l.id_registro_patronal = n.id_registro_patronal
             AND l.id_nomina = n.id_nomina
             AND L.STATUS in ('VE', 'VI')
             and l.NO_AUTORIZACION is null
           ORDER BY l.periodo_liquidacion asc, l.id_nomina;
      END;
    END IF;
  
    IF p_concepto = v_tt_IR17 THEN
      BEGIN
      
        OPEN c_cursor FOR
          SELECT i.id_referencia_ir17 id_referencia,
                 Srp_Pkg.FORMATEAPERIODO(I.PERIODO_LIQUIDACION) periodo_factura,
                 I.LIQUIDACION total_general,
                 e.razon_social,
                 '1' as id_nomina,
                 ' ' Nomina_des,
                 e.rnc_o_cedula
            FROM sfc_liquidacion_ir17_v i, SRE_EMPLEADORES_T e
           WHERE e.RNC_O_CEDULA = p_RNCoCedula
             AND i.ID_REGISTRO_PATRONAL = e.id_registro_patronal
             AND i.STATUS in ('VE', 'VI')
             and i.NO_AUTORIZACION is null
           ORDER BY i.PERIODO_LIQUIDACION asc;
      
      END;
    END IF;
  
    IF p_concepto = v_tt_INF THEN
      BEGIN
      
        OPEN c_cursor FOR
          SELECT i.id_referencia_infotep id_referencia,
                 Srp_Pkg.FORMATEAPERIODO(I.PERIODO_LIQUIDACION) periodo_factura,
                 I.Total_Pago_Infotep total_general,
                 e.razon_social,
                 '1' as id_nomina,
                 ' ' Nomina_des,
                 e.rnc_o_cedula
            FROM suirplus.sfc_liquidacion_infotep_t i, SRE_EMPLEADORES_T e
           WHERE e.RNC_O_CEDULA = p_RNCoCedula
             AND i.ID_REGISTRO_PATRONAL = e.id_registro_patronal
             AND i.STATUS in ('VE', 'VI')
             and i.NO_AUTORIZACION is null
           ORDER BY i.PERIODO_LIQUIDACION asc;
      
      END;
    END IF;
  
    IF p_concepto = v_tt_MDT THEN
      BEGIN
        OPEN c_cursor FOR
          SELECT i.id_referencia_planilla id_referencia,
                 Srp_Pkg.FORMATEAPERIODO(I.PERIODO_LIQUIDACION) periodo_factura,
                 I.Total_Pago total_general,
                 e.razon_social,
                 '1' as id_nomina,
                 ' ' Nomina_des,
                 e.rnc_o_cedula
            FROM suirplus.sfc_planilla_mdt_t i, SRE_EMPLEADORES_T e
           WHERE e.RNC_O_CEDULA = p_RNCoCedula
             AND i.ID_REGISTRO_PATRONAL = e.id_registro_patronal
             AND i.STATUS in ('VE', 'VI')
             and i.NO_AUTORIZACION is null
           ORDER BY i.PERIODO_LIQUIDACION asc;
      
      END;
    END IF;
  
    p_resultnumber := 0;
    -- p_resultnumber := p_Status;
    p_IOCursor := c_cursor;
  
  EXCEPTION
  
    WHEN OTHERS THEN
      v_bd_error     := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultnumber := Seg_Retornar_Cadena_Error(-1, v_bd_error, SQLCODE);
      RETURN;
    
  END;

  --LEVANTA UNA EXCEPCION DE ERROR SI EL CURSOR NO TRAE DATOS PARA UN RNC
  /*
     PROCEDURE Cons_Facturas(
          p_RNCoCedula           IN SRE_EMPLEADORES_T.RNC_O_CEDULA%TYPE,
       --   p_Status              IN VARCHAR2,
          p_concepto            IN VARCHAR2,
          p_IOCursor            IN OUT t_Cursor,
          p_resultnumber        OUT VARCHAR2
     )
     IS
       e_datos_no_registrados    exception;
       v_idreferencia            varchar2(50);
       v_cant_referencias        varchar2(50);
       v_bd_error                 VARCHAR(1000);
       c_cursor t_cursor;
  
       --SDSS
       CURSOR c_cursorSDSS is
           SELECT f.id_referencia FROM sfc_facturas_v f, SRE_EMPLEADORES_T e, SRE_NOMINAS_T n
           WHERE e.RNC_O_CEDULA = p_RNCoCedula AND f.id_registro_patronal = e.id_registro_patronal
           AND f.id_registro_patronal = n.id_registro_patronal AND f.id_nomina = n.id_nomina
           and f.STATUS in('VE','VI')
           ORDER BY f.periodo_factura DESC, f.id_nomina ;
       --ISR
       CURSOR c_cursorISR is
          SELECT l.id_referencia_isr FROM sfc_liquidacion_isr_v l, SRE_EMPLEADORES_T e, SRE_NOMINAS_T n
          WHERE e.RNC_O_CEDULA = p_RNCoCedula AND l.id_registro_patronal = e.id_registro_patronal
          AND l.id_registro_patronal = n.id_registro_patronal AND l.id_nomina = n.id_nomina
          AND L.STATUS in('VE','VI')
          ORDER BY l.periodo_liquidacion DESC, l.id_nomina;
       --IR17
       CURSOR c_cursorIR17 is
          SELECT i.id_referencia_ir17 FROM sfc_liquidacion_ir17_v i, SRE_EMPLEADORES_T e, SRE_NOMINAS_T n
          WHERE e.RNC_O_CEDULA = p_RNCoCedula AND N.ID_REGISTRO_PATRONAL= E.ID_REGISTRO_PATRONAL
          AND i.ID_REGISTRO_PATRONAL = e.id_registro_patronal AND i.STATUS in('VE','VI')
          ORDER BY i.PERIODO_LIQUIDACION DESC, N.ID_NOMINA;
  
     BEGIN
  
    -- IF p_Status = 'TODAS' THEN
        --  IF p_CodigoNomina = 6321 THEN
          IF p_concepto =  v_tt_SDSS THEN
              open c_cursorSDSS;
              fetch c_cursorSDSS into v_idreferencia;
              close c_cursorSDSS;
  
              if v_idreferencia is not null then
                  OPEN c_cursor FOR
                      SELECT f.id_referencia id_referencia, f.id_nomina, Srp_Pkg.ProperCase(n.nomina_des) nomina_des,
                      Srp_Pkg.FORMATEAPERIODO(f.periodo_factura) periodo_factura, f.total_general_factura total_general, e.razon_social
                      FROM sfc_facturas_v f, SRE_EMPLEADORES_T e, SRE_NOMINAS_T n
                      WHERE e.RNC_O_CEDULA = p_RNCoCedula
                      AND f.id_registro_patronal = e.id_registro_patronal
                      AND f.id_registro_patronal = n.id_registro_patronal
                      AND f.id_nomina = n.id_nomina
                      and f.STATUS in('VE','VI')
  
                      ORDER BY f.periodo_factura DESC, f.id_nomina ;
  
                  p_resultnumber := 0;
                  p_IOCursor:= c_cursor;
              else
                  raise e_datos_no_registrados;
              end if;
  
          END IF;
  
          IF p_concepto =  v_tt_ISR THEN
              open c_cursorISR;
              fetch c_cursorISR into v_idreferencia;
              close c_cursorISR;
  
              if v_idreferencia is not null then
  
                  OPEN c_cursor FOR
                      SELECT l.id_referencia_isr id_referencia, l.id_nomina, 'Liquidacion ISR' nomina_des,
                      Srp_Pkg.FORMATEAPERIODO(l.periodo_liquidacion) periodo_factura, l.TOTAL_A_PAGAR total_general, e.razon_social
                      FROM sfc_liquidacion_isr_v l, SRE_EMPLEADORES_T e, SRE_NOMINAS_T n
                      WHERE e.RNC_O_CEDULA = p_RNCoCedula
                      AND l.id_registro_patronal = e.id_registro_patronal
                      AND l.id_registro_patronal = n.id_registro_patronal
                      AND l.id_nomina = n.id_nomina
                      AND L.STATUS in('VE','VI')
                      ORDER BY l.periodo_liquidacion DESC, l.id_nomina;
  
                  p_resultnumber := 0;
                  p_IOCursor:= c_cursor;
              else
                  raise e_datos_no_registrados;
  
              end if;
          END IF;
  
          IF p_concepto =  v_tt_IR17 THEN
              open c_cursorIR17;
              fetch c_cursorIR17 into v_idreferencia;
              close c_cursorIR17;
  
              if v_idreferencia is not null then
  
                  OPEN c_cursor FOR
                      SELECT i.id_referencia_ir17 id_referencia, Srp_Pkg.FORMATEAPERIODO(I.PERIODO_LIQUIDACION) periodo_factura,
                      I.LIQUIDACION total_general, e.razon_social, N.ID_NOMINA, ' ' Nomina_des
                      FROM sfc_liquidacion_ir17_v i, SRE_EMPLEADORES_T e, SRE_NOMINAS_T n
                      WHERE e.RNC_O_CEDULA = p_RNCoCedula
                      AND N.ID_REGISTRO_PATRONAL= E.ID_REGISTRO_PATRONAL
                      AND i.ID_REGISTRO_PATRONAL = e.id_registro_patronal
                      AND i.STATUS in('VE','VI')
                      ORDER BY i.PERIODO_LIQUIDACION DESC, N.ID_NOMINA;
  
                  p_resultnumber := 0;
                  p_IOCursor:= c_cursor;
              else
                  raise e_datos_no_registrados;
  
              end if;
          END IF;
  
   --  END IF;
  
      EXCEPTION
  
          WHEN e_datos_no_registrados THEN
              p_resultnumber := Seg_Retornar_Cadena_Error(62, NULL, NULL);
          RETURN;
  
          WHEN OTHERS THEN
              v_bd_error := (SUBSTR('error '||TO_CHAR(SQLCODE)||': '||SQLERRM, 1, 255));
              p_resultnumber := Seg_Retornar_Cadena_Error(-1, v_bd_error, SQLCODE);
          RETURN;
  
  
     END;
  
  
  --/////////////////////////////////////////////////
  --/////////////////////////////////////////////////
  
  -- **************************************************************************************************
  -- Program:     Cons_Facturas
  -- Description: Trae una consulta general de una factura
  -- **************************************************************************************************
  /**/
  PROCEDURE Cons_Facturas(p_RNCoCedula   IN SRE_EMPLEADORES_T.RNC_O_CEDULA%TYPE,
                          p_CodigoNomina IN SRE_NOMINAS_T.id_nomina%TYPE,
                          p_concepto     IN VARCHAR2,
                          p_IOCursor     IN OUT t_Cursor,
                          p_resultnumber OUT VARCHAR2)
  
   IS
    e_invalidNoReferencia EXCEPTION;
    e_invalidRegPatronal EXCEPTION;
    v_bd_error VARCHAR(1000);
    c_cursor   t_cursor;
  
  BEGIN
  
    IF p_CodigoNomina = 6321 THEN
      IF p_concepto = v_tt_SDSS THEN
        OPEN c_cursor FOR
          SELECT f.id_referencia id_referencia,
                 f.id_nomina,
                 Srp_Pkg.ProperCase(n.nomina_des) nomina_des,
                 'A' tipo_factura,
                 Srp_Pkg.FormateaPeriodo(f.periodo_factura) periodo_factura,
                 f.total_general_factura total_general,
                 e.razon_social
            FROM sfc_facturas_v f, SRE_EMPLEADORES_T e, SRE_NOMINAS_T n
           WHERE e.rnc_o_cedula = p_RNCoCedula
             AND f.id_registro_patronal = e.id_registro_patronal
             AND f.id_registro_patronal = n.id_registro_patronal
             AND f.id_nomina = n.id_nomina
             AND f.status IN ('VI', 'VE')
             AND f.no_autorizacion IS NULL
           ORDER BY f.id_nomina,
                    f.periodo_factura ASC,
                    f.FECHA_EMISION   DESC,
                    f.status;
      END IF;
    
      IF p_concepto = v_tt_ISR THEN
        BEGIN
          OPEN c_cursor FOR
            SELECT l.id_referencia_isr id_referencia,
                   l.id_nomina,
                   'Liquidacion ISR' nomina_des,
                   'A' tipo_factura,
                   Srp_Pkg.FormateaPeriodo(l.periodo_liquidacion) periodo_factura,
                   l.TOTAL_A_PAGAR total_general,
                   e.razon_social
              FROM sfc_liquidacion_isr_v l,
                   SRE_EMPLEADORES_T     e,
                   SRE_NOMINAS_T         n
             WHERE e.rnc_o_cedula = p_RNCoCedula
               AND l.id_registro_patronal = e.id_registro_patronal
               AND l.id_registro_patronal = n.id_registro_patronal
               AND l.id_nomina = n.id_nomina
               AND l.status IN ('VI', 'VE')
               AND l.no_autorizacion IS NULL
             ORDER BY l.id_nomina,
                      l.periodo_liquidacion ASC,
                      l.FECHA_EMISION       DESC,
                      l.status;
        
        END;
      END IF;
    
      IF p_concepto = v_tt_IR17 THEN
        BEGIN
          OPEN c_cursor FOR
            SELECT i.id_referencia_ir17 id_referencia,
                   Srp_Pkg.FORMATEAPERIODO(I.PERIODO_LIQUIDACION) periodo_factura,
                   'A' tipo_factura,
                   I.LIQUIDACION total_general,
                   e.razon_social,
                   ' ' Nomina_des,
                   'Detalle Factura' as detalles,
                   '1' ID_NOMINA
              FROM sfc_liquidacion_ir17_v i, SRE_EMPLEADORES_T e
             WHERE e.RNC_O_CEDULA = p_RNCoCedula
               and i.ID_REGISTRO_PATRONAL = e.id_registro_patronal
               and i.STATUS in ('VI')
               and i.NO_AUTORIZACION is null
               and i.LIQUIDACION > 0
             ORDER BY i.PERIODO_LIQUIDACION ASC,
                      i.FECHA_EMISION       DESC,
                      i.STATUS;
        
        END;
      END IF;
    
      IF p_concepto = v_tt_INF THEN
        BEGIN
          OPEN c_cursor FOR
            SELECT i.id_referencia_infotep id_referencia,
                   Srp_Pkg.FORMATEAPERIODO(I.PERIODO_LIQUIDACION) periodo_factura,
                   i.id_tipo_factura tipo_factura,
                   I.Total_Pago_Infotep total_general,
                   e.razon_social,
                   Srp_Pkg.ProperCase(f.tipo_factura_des) Nomina_des,
                   'Detalle Factura' as detalles,
                   '1' ID_NOMINA
              FROM suirplus.sfc_liquidacion_infotep_t i,
                   SRE_EMPLEADORES_T                  e,
                   sfc_tipo_facturas_t                f
             WHERE e.RNC_O_CEDULA = p_RNCoCedula
               and i.ID_REGISTRO_PATRONAL = e.id_registro_patronal
               and i.STATUS in ('VI', 'VE')
               and i.NO_AUTORIZACION is null
               and i.total_pago_infotep > 0
               and f.id_tipo_factura = i.id_tipo_factura
             ORDER BY i.PERIODO_LIQUIDACION ASC,
                      i.FECHA_EMISION       DESC,
                      i.STATUS;
        
        END;
      END IF;
    
      IF p_concepto = v_tt_MDT THEN
        BEGIN
          OPEN c_cursor FOR
            SELECT i.id_referencia_planilla id_referencia,
                   Srp_Pkg.FORMATEAPERIODO(I.PERIODO_LIQUIDACION) periodo_factura,
                   i.id_tipo_factura tipo_factura,
                   I.Total_Pago total_general,
                   e.razon_social,
                   Srp_Pkg.ProperCase(f.tipo_factura_des) Nomina_des,
                   'Detalle Factura' as detalles,
                   '1' ID_NOMINA
              FROM suirplus.sfc_PLANILLA_MDT_t i,
                   SRE_EMPLEADORES_T           e,
                   sfc_tipo_facturas_t         f
             WHERE e.RNC_O_CEDULA = p_RNCoCedula
               and i.ID_REGISTRO_PATRONAL = e.id_registro_patronal
               and i.STATUS in ('VI', 'VE')
               and i.NO_AUTORIZACION is null
               and i.total_pago > 0
               and f.id_tipo_factura = i.id_tipo_factura
             ORDER BY i.PERIODO_LIQUIDACION ASC,
                      i.FECHA_EMISION       DESC,
                      i.STATUS;
        
        END;
      END IF;
    ELSE
      IF p_concepto = v_tt_SDSS THEN
        OPEN c_cursor FOR
          SELECT f.id_referencia id_referencia,
                 f.id_nomina,
                 Srp_Pkg.ProperCase(n.nomina_des) nomina_des,
                 '' tipo_factura,
                 Srp_Pkg.FormateaPeriodo(f.periodo_factura) periodo_factura,
                 f.total_general_factura total_general,
                 e.razon_social
            FROM sfc_facturas_v f, SRE_EMPLEADORES_T e, SRE_NOMINAS_T n
           WHERE e.rnc_o_cedula = p_RNCoCedula
             AND f.id_registro_patronal = e.id_registro_patronal
             AND f.id_registro_patronal = n.id_registro_patronal
             AND f.id_nomina = p_CodigoNomina
             AND f.id_nomina = n.id_nomina
             AND f.status IN ('VI', 'VE')
             AND f.no_autorizacion IS NULL
           ORDER BY f.id_nomina,
                    f.periodo_factura ASC,
                    f.FECHA_EMISION   DESC,
                    f.status;
      END IF;
    
      IF p_concepto = v_tt_ISR THEN
        BEGIN
          OPEN c_cursor FOR
            SELECT l.id_referencia_isr id_referencia,
                   l.id_nomina,
                   'Liquidacion ISR' nomina_des,
                   '' tipo_factura,
                   Srp_Pkg.FormateaPeriodo(l.periodo_liquidacion) periodo_factura,
                   l.TOTAL_A_PAGAR total_general,
                   e.razon_social
              FROM sfc_liquidacion_isr_v l,
                   SRE_EMPLEADORES_T     e,
                   SRE_NOMINAS_T         n
             WHERE e.rnc_o_cedula = p_RNCoCedula
               AND l.id_registro_patronal = e.id_registro_patronal
               AND l.id_registro_patronal = n.id_registro_patronal
               AND l.id_nomina = p_CodigoNomina
               AND l.id_nomina = n.id_nomina
               AND l.status IN ('VI', 'VE')
               AND l.no_autorizacion IS NULL
             ORDER BY l.id_nomina,
                      l.periodo_liquidacion ASC,
                      l.FECHA_EMISION       DESC,
                      l.status;
        
        END;
      END IF;
    
      IF p_concepto = v_tt_IR17 THEN
        BEGIN
          OPEN c_cursor FOR
            SELECT i.id_referencia_ir17 id_referencia,
                   Srp_Pkg.FORMATEAPERIODO(I.PERIODO_LIQUIDACION) periodo_factura,
                   '' tipo_factura,
                   I.LIQUIDACION total_general,
                   e.razon_social
              FROM sfc_liquidacion_ir17_v i, SRE_EMPLEADORES_T e
             WHERE e.RNC_O_CEDULA = p_RNCoCedula
               and i.ID_REGISTRO_PATRONAL = e.id_registro_patronal
               and i.STATUS in ('VI', 'VE')
               and i.NO_AUTORIZACION is null
               and i.LIQUIDACION > 0
             ORDER BY i.PERIODO_LIQUIDACION ASC,
                      i.FECHA_EMISION       DESC,
                      i.STATUS;
        
        END;
      END IF;
    
      IF p_concepto = v_tt_INF THEN
        BEGIN
          OPEN c_cursor FOR
            SELECT i.id_referencia_infotep id_referencia,
                   Srp_Pkg.FORMATEAPERIODO(I.PERIODO_LIQUIDACION) periodo_factura,
                   '' tipo_factura,
                   I.total_pago_infotep total_general,
                   e.razon_social
              FROM suirplus.sfc_liquidacion_infotep_t i,
                   SRE_EMPLEADORES_T                  e
             WHERE e.RNC_O_CEDULA = p_RNCoCedula
               and i.ID_REGISTRO_PATRONAL = e.id_registro_patronal
               and i.STATUS in ('VI', 'VE')
               and i.NO_AUTORIZACION is null
               and i.total_pago_infotep > 0
             ORDER BY i.PERIODO_LIQUIDACION ASC,
                      i.FECHA_EMISION       DESC,
                      i.STATUS;
        
        END;
      END IF;
    
      IF p_concepto = v_tt_MDT THEN
        BEGIN
          OPEN c_cursor FOR
            SELECT i.id_referencia_planilla id_referencia,
                   Srp_Pkg.FORMATEAPERIODO(I.PERIODO_LIQUIDACION) periodo_factura,
                   '' tipo_factura,
                   I.total_pago total_general,
                   e.razon_social
              FROM suirplus.sfc_planilla_mdt_t i, SRE_EMPLEADORES_T e
             WHERE e.RNC_O_CEDULA = p_RNCoCedula
               and i.ID_REGISTRO_PATRONAL = e.id_registro_patronal
               and i.STATUS in ('VI', 'VE')
               and i.NO_AUTORIZACION is null
               and i.total_pago > 0
             ORDER BY i.PERIODO_LIQUIDACION ASC,
                      i.FECHA_EMISION       DESC,
                      i.STATUS;
        
        END;
      END IF;
    END IF;
  
    p_resultnumber := 0;
    p_IOCursor     := c_cursor;
  
  EXCEPTION
  
    WHEN e_invalidRegPatronal THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(3, NULL, NULL);
      RETURN;
    
    WHEN OTHERS THEN
      v_bd_error     := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultnumber := Seg_Retornar_Cadena_Error(-1, v_bd_error, SQLCODE);
      RETURN;
    
  END;

  -- **************************************************************************************************
  -- Program:     Cons_Facturas
  -- Description: Trae una consulta general de una factura invocada por un No.de referencia
  --
  -- **************************************************************************************************
  /**/
  PROCEDURE Cons_Facturas(p_concepto     IN VARCHAR2,
                          p_NoReferencia IN SFC_FACTURAS_T.id_referencia%TYPE,
                          p_IOCursor     IN OUT t_Cursor,
                          p_resultnumber OUT VARCHAR2)
  
   IS
    e_invalidNoReferencia EXCEPTION;
    v_bd_error VARCHAR(1000);
    c_cursor   t_cursor;
  
  BEGIN
  
    IF NOT Sfc_Factura_Pkg.isExisteNoReferencia(p_concepto, p_NoReferencia) THEN
      RAISE e_invalidNoReferencia;
    END IF;
  
    IF p_concepto = v_tt_SDSS THEN
      OPEN c_cursor FOR
        SELECT f.id_referencia id_referencia,
               f.id_nomina,
               Srp_Pkg.ProperCase(n.nomina_des) nomina_des,
               Srp_Pkg.FormateaPeriodo(f.periodo_factura) periodo_factura,
               f.total_general_factura total_general,
               e.razon_social,
               e.rnc_o_cedula RNC
          FROM sfc_facturas_v f, SRE_EMPLEADORES_T e, SRE_NOMINAS_T n
         WHERE f.id_referencia = p_NoReferencia
           AND f.id_registro_patronal = e.id_registro_patronal
           AND f.id_registro_patronal = n.id_registro_patronal
           AND f.id_nomina = n.id_nomina
           AND f.status IN ('VI', 'VE')
           AND f.no_autorizacion IS NULL
         ORDER BY f.id_nomina, f.periodo_factura, f.status;
    END IF;
  
    IF p_concepto = v_tt_ISR THEN
      OPEN c_cursor FOR
        SELECT l.id_referencia_isr id_referencia,
               l.id_nomina,
               'Liquidacion ISR' nomina_des,
               Srp_Pkg.FormateaPeriodo(l.periodo_liquidacion) periodo_factura,
               l.TOTAL_A_PAGAR total_general,
               e.razon_social,
               e.rnc_o_cedula RNC
          FROM sfc_liquidacion_isr_v l,
               SRE_EMPLEADORES_T     e,
               SRE_NOMINAS_T         n
         WHERE l.id_referencia_isr = p_NoReferencia
           AND l.id_registro_patronal = e.id_registro_patronal
           AND l.id_registro_patronal = n.id_registro_patronal
           AND l.id_nomina = n.id_nomina
           AND l.status IN ('VI', 'VE')
           AND l.no_autorizacion IS NULL
         ORDER BY l.id_nomina, l.periodo_liquidacion, l.status;
    END IF;
  
    IF p_concepto = v_tt_IR17 THEN
      BEGIN
        OPEN c_cursor FOR
          SELECT i.id_referencia_ir17 id_referencia,
                 Srp_Pkg.FORMATEAPERIODO(I.PERIODO_LIQUIDACION) periodo_factura,
                 I.LIQUIDACION total_general,
                 e.razon_social,
                 e.rnc_o_cedula RNC
            FROM sfc_liquidacion_ir17_v i, SRE_EMPLEADORES_T e
           WHERE i.ID_REFERENCIA_IR17 = p_NoReferencia
             AND i.ID_REGISTRO_PATRONAL = e.id_registro_patronal
             AND i.STATUS IN ('VI', 'VE')
             AND i.NO_AUTORIZACION IS NULL
             AND i.LIQUIDACION > 0
           ORDER BY i.PERIODO_LIQUIDACION, i.STATUS;
      
      END;
    END IF;
  
    IF p_concepto = v_tt_INF THEN
      BEGIN
        OPEN c_cursor FOR
          SELECT i.id_referencia_infotep id_referencia,
                 Srp_Pkg.FORMATEAPERIODO(I.PERIODO_LIQUIDACION) periodo_factura,
                 I.total_pago_infotep total_general,
                 e.razon_social,
                 e.rnc_o_cedula RNC
            FROM suirplus.sfc_liquidacion_infotep_t i, SRE_EMPLEADORES_T e
           WHERE i.ID_REFERENCIA_INFOTEP = p_NoReferencia
             AND i.ID_REGISTRO_PATRONAL = e.id_registro_patronal
             AND i.STATUS IN ('VI', 'VE')
             AND i.NO_AUTORIZACION IS NULL
             AND i.total_pago_infotep > 0
           ORDER BY i.PERIODO_LIQUIDACION, i.STATUS;
      
      END;
    END IF;
  
    IF p_concepto = v_tt_MDT THEN
      BEGIN
        OPEN c_cursor FOR
          SELECT i.id_referencia_planilla id_referencia,
                 Srp_Pkg.FORMATEAPERIODO(I.PERIODO_LIQUIDACION) periodo_factura,
                 I.total_pago total_general,
                 e.razon_social,
                 e.rnc_o_cedula RNC
            FROM suirplus.sfc_planilla_mdt_t i, SRE_EMPLEADORES_T e
           WHERE i.ID_REFERENCIA_planilla = p_NoReferencia
             AND i.ID_REGISTRO_PATRONAL = e.id_registro_patronal
             AND i.STATUS IN ('VI', 'VE')
             AND i.NO_AUTORIZACION IS NULL
             AND i.total_pago > 0
           ORDER BY i.PERIODO_LIQUIDACION, i.STATUS;
      
      END;
    END IF;
  
    p_resultnumber := 0;
    p_IOCursor     := c_cursor;
  
  EXCEPTION
  
    WHEN e_invalidNoReferencia THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(16, NULL, NULL);
      RETURN;
    
    WHEN OTHERS THEN
      v_bd_error     := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultnumber := Seg_Retornar_Cadena_Error(-1, v_bd_error, SQLCODE);
      RETURN;
    
  END;

  -- **************************************************************************************************
  -- Program:     Cons_Autorizacion
  -- Description: trae todas las facturas autorizadas por un usuario
  --
  -- **************************************************************************************************

  PROCEDURE Cons_Autorizacion(p_idusuario    IN SFC_FACTURAS_T.id_usuario_autoriza%TYPE,
                              p_NoReferencia IN SFC_FACTURAS_T.id_referencia%TYPE,
                              p_concepto     IN VARCHAR2,
                              p_IOCursor     IN OUT t_Cursor,
                              p_resultnumber OUT VARCHAR2)
  
   IS
    e_invaliduser EXCEPTION;
    e_invalidNoReferencia EXCEPTION;
    v_bd_error             VARCHAR(1000);
    c_cursor               t_cursor;
    v_Count                NUMBER;
    v_IDEntidadRecaudadora NUMBER;
  
  BEGIN
    IF NOT Seg_Usuarios_Pkg.isExisteUsuario(p_idusuario) THEN
      RAISE e_invaliduser;
    END IF;
  
    SELECT COUNT(*)
      INTO v_Count
      FROM SEG_USUARIO_PERMISOS_T
     WHERE id_usuario = p_idusuario
       AND id_role = 58;
  
    IF v_Count > 0 THEN
      SELECT u.id_entidad_recaudadora
        INTO v_IDEntidadRecaudadora
        FROM SEG_USUARIO_T u
       WHERE u.id_usuario = p_idusuario;
    
      IF p_NoReferencia IS NOT NULL THEN
        IF NOT
            Sfc_Factura_Pkg.isExisteNoReferencia(p_concepto, p_NoReferencia) THEN
          RAISE e_invalidNoReferencia;
        END IF;
        IF p_concepto = v_tt_SDSS THEN
          OPEN c_cursor FOR
            SELECT f.no_autorizacion,
                   f.id_referencia,
                   e.rnc_o_cedula,
                   f.fecha_autorizacion,
                   f.total_general_factura total_general,
                   f.ID_USUARIO_AUTORIZA,
                   n.nomina_des,
                   f.PERIODO_FACTURA,
                   e.razon_social
              FROM sfc_facturas_v f, SRE_EMPLEADORES_T e, sre_nominas_t n
             WHERE f.ID_ENTIDAD_RECAUDADORA = v_IDEntidadRecaudadora
               AND f.id_referencia = p_NoReferencia
               AND f.id_registro_patronal = e.id_registro_patronal
               AND f.no_autorizacion IS NOT NULL
               AND F.STATUS NOT IN ('PA', 'CA', 'RE')
               AND n.id_registro_patronal = f.id_registro_patronal
               AND n.id_nomina = f.id_nomina
             ORDER BY f.fecha_autorizacion DESC;
        
        ELSIF p_concepto = v_tt_ISR THEN
          OPEN c_cursor FOR
            SELECT l.no_autorizacion,
                   l.id_referencia_isr   id_referencia,
                   e.rnc_o_cedula,
                   l.fecha_autorizacion,
                   l.TOTAL_A_PAGAR       total_general,
                   l.ID_USUARIO_AUTORIZA,
                   n.nomina_des,
                   l.periodo_liquidacion,
                   e.razon_social
              FROM suirplus.sfc_liquidacion_isr_v l,
                   SRE_EMPLEADORES_T              e,
                   sre_nominas_t                  n
             WHERE l.ID_ENTIDAD_RECAUDADORA = v_IDEntidadRecaudadora
               AND l.id_referencia_isr = p_NoReferencia
               AND l.id_registro_patronal = e.id_registro_patronal
               AND l.no_autorizacion IS NOT NULL
               AND l.STATUS NOT IN ('PA', 'CA')
               AND n.id_registro_patronal = l.id_registro_patronal
               AND n.id_nomina = l.id_nomina
             ORDER BY l.fecha_autorizacion DESC;
        
        ELSIF p_concepto = v_tt_IR17 THEN
          BEGIN
            OPEN c_cursor FOR
              SELECT I.NO_AUTORIZACION,
                     i.id_referencia_ir17  id_referencia,
                     e.rnc_o_cedula,
                     i.FECHA_AUTORIZACION,
                     I.LIQUIDACION         total_general,
                     i.ID_USUARIO_AUTORIZA,
                     i.periodo_liquidacion,
                     e.razon_social
                FROM suirplus.sfc_liquidacion_ir17_v i, SRE_EMPLEADORES_T e
               WHERE i.ID_ENTIDAD_RECAUDADORA = v_IDEntidadRecaudadora
                 AND i.ID_REFERENCIA_IR17 = p_NoReferencia
                 AND i.ID_REGISTRO_PATRONAL = e.id_registro_patronal
                 AND i.NO_AUTORIZACION IS NOT NULL
                 AND i.STATUS NOT IN ('PA', 'CA')
               ORDER BY i.FECHA_AUTORIZACION DESC;
          
          END;
        
        ELSIF p_concepto = v_tt_INF THEN
          BEGIN
            OPEN c_cursor FOR
              SELECT I.NO_AUTORIZACION,
                     i.id_referencia_infotep id_referencia,
                     e.rnc_o_cedula,
                     i.FECHA_AUTORIZACION,
                     I.total_pago_infotep    total_general,
                     i.ID_USUARIO_AUTORIZA,
                     i.periodo_liquidacion,
                     e.razon_social
                FROM suirplus.sfc_liquidacion_infotep_t i,
                     SRE_EMPLEADORES_T                  e
               WHERE i.ID_ENTIDAD_RECAUDADORA = v_IDEntidadRecaudadora
                 AND i.ID_REFERENCIA_INFOTEP = p_NoReferencia
                 AND i.ID_REGISTRO_PATRONAL = e.id_registro_patronal
                 AND i.NO_AUTORIZACION IS NOT NULL
                 AND i.STATUS NOT IN ('PA', 'CA')
               ORDER BY i.FECHA_AUTORIZACION DESC;
          
          END;
        ELSIF p_concepto = v_tt_MDT THEN
          BEGIN
            OPEN c_cursor FOR
              SELECT I.NO_AUTORIZACION,
                     i.id_referencia_planilla id_referencia,
                     e.rnc_o_cedula,
                     i.FECHA_AUTORIZACION,
                     I.total_pago             total_general,
                     i.ID_USUARIO_AUTORIZA,
                     i.periodo_liquidacion,
                     e.razon_social
                FROM suirplus.sfc_planilla_mdt_t i, SRE_EMPLEADORES_T e
               WHERE i.ID_ENTIDAD_RECAUDADORA = v_IDEntidadRecaudadora
                 AND i.ID_REFERENCIA_planilla = p_NoReferencia
                 AND i.ID_REGISTRO_PATRONAL = e.id_registro_patronal
                 AND i.NO_AUTORIZACION IS NOT NULL
                 AND i.STATUS NOT IN ('PA', 'CA')
               ORDER BY i.FECHA_AUTORIZACION DESC;
          
          END;
        END IF;
      ELSE
      
        IF p_concepto = v_tt_SDSS THEN
          OPEN c_cursor FOR
            SELECT f.no_autorizacion,
                   f.id_referencia,
                   e.rnc_o_cedula,
                   f.fecha_autorizacion,
                   f.total_general_factura total_general,
                   f.ID_USUARIO_AUTORIZA,
                   n.nomina_des,
                   f.PERIODO_FACTURA,
                   e.razon_social
              FROM sfc_facturas_v f, SRE_EMPLEADORES_T e, sre_nominas_t n
             WHERE f.ID_ENTIDAD_RECAUDADORA = v_IDEntidadRecaudadora
               AND f.id_registro_patronal = e.id_registro_patronal
               AND f.no_autorizacion IS NOT NULL
               AND F.STATUS NOT IN ('PA', 'CA', 'RE')
               AND n.id_registro_patronal = f.id_registro_patronal
               AND n.id_nomina = f.id_nomina
             ORDER BY f.fecha_autorizacion DESC;
        ELSIF p_concepto = v_tt_ISR THEN
          OPEN c_cursor FOR
            SELECT l.no_autorizacion,
                   l.id_referencia_isr   id_referencia,
                   e.rnc_o_cedula,
                   l.fecha_autorizacion,
                   l.TOTAL_A_PAGAR       total_general,
                   l.ID_USUARIO_AUTORIZA,
                   n.nomina_des,
                   l.periodo_liquidacion,
                   e.razon_social
              FROM sfc_liquidacion_isr_v l,
                   SRE_EMPLEADORES_T     e,
                   sre_nominas_t         n
             WHERE l.ID_ENTIDAD_RECAUDADORA = v_IDEntidadRecaudadora
               AND l.id_registro_patronal = e.id_registro_patronal
               AND l.no_autorizacion IS NOT NULL
               AND l.STATUS NOT IN ('PA', 'CA')
               AND n.id_registro_patronal = l.id_registro_patronal
               AND n.id_nomina = l.id_nomina
             ORDER BY l.fecha_autorizacion DESC;
        ELSIF p_concepto = v_tt_IR17 THEN
          BEGIN
            OPEN c_cursor FOR
              SELECT I.NO_AUTORIZACION,
                     i.id_referencia_ir17  id_referencia,
                     e.rnc_o_cedula,
                     i.FECHA_AUTORIZACION,
                     I.LIQUIDACION         total_general,
                     i.ID_USUARIO_AUTORIZA,
                     i.periodo_liquidacion,
                     e.razon_social
                FROM sfc_liquidacion_ir17_v i, SRE_EMPLEADORES_T e
               WHERE i.ID_ENTIDAD_RECAUDADORA = v_IDEntidadRecaudadora
                 AND i.ID_REGISTRO_PATRONAL = e.id_registro_patronal
                 AND i.NO_AUTORIZACION IS NOT NULL
                 AND i.STATUS NOT IN ('PA', 'CA')
               ORDER BY i.FECHA_AUTORIZACION DESC;
          
          END;
        ELSIF p_concepto = v_tt_INF THEN
          BEGIN
            OPEN c_cursor FOR
              SELECT I.NO_AUTORIZACION,
                     i.id_referencia_infotep id_referencia,
                     e.rnc_o_cedula,
                     i.FECHA_AUTORIZACION,
                     I.total_pago_infotep    total_general,
                     i.ID_USUARIO_AUTORIZA,
                     i.periodo_liquidacion,
                     e.razon_social
                FROM suirplus.sfc_liquidacion_infotep_t i,
                     SRE_EMPLEADORES_T                  e
               WHERE i.ID_ENTIDAD_RECAUDADORA = v_IDEntidadRecaudadora
                 AND i.ID_REGISTRO_PATRONAL = e.id_registro_patronal
                 AND i.NO_AUTORIZACION IS NOT NULL
                 AND i.STATUS NOT IN ('PA', 'CA')
               ORDER BY i.FECHA_AUTORIZACION DESC;
          
          END;
        ELSIF p_concepto = v_tt_MDT THEN
          BEGIN
            OPEN c_cursor FOR
              SELECT I.NO_AUTORIZACION,
                     i.id_referencia_PLANILLA id_referencia,
                     e.rnc_o_cedula,
                     i.FECHA_AUTORIZACION,
                     I.total_pago             total_general,
                     i.ID_USUARIO_AUTORIZA,
                     i.periodo_liquidacion,
                     e.razon_social
                FROM suirplus.sfc_planilla_mdt_t i, SRE_EMPLEADORES_T e
               WHERE i.ID_ENTIDAD_RECAUDADORA = v_IDEntidadRecaudadora
                 AND i.ID_REGISTRO_PATRONAL = e.id_registro_patronal
                 AND i.NO_AUTORIZACION IS NOT NULL
                 AND i.STATUS NOT IN ('PA', 'CA')
               ORDER BY i.FECHA_AUTORIZACION DESC;
          
          END;
        END IF;
      
      END IF;
    ELSE
      -- No es un Usuario Administrador de Sucursal
      IF p_NoReferencia IS NOT NULL THEN
        IF NOT
            Sfc_Factura_Pkg.isExisteNoReferencia(p_concepto, p_NoReferencia) THEN
          RAISE e_invalidNoReferencia;
        END IF;
        IF p_concepto = v_tt_SDSS THEN
          OPEN c_cursor FOR
            SELECT f.no_autorizacion,
                   f.id_referencia,
                   e.rnc_o_cedula,
                   f.fecha_autorizacion,
                   f.total_general_factura total_general,
                   f.ID_USUARIO_AUTORIZA,
                   n.nomina_des,
                   f.PERIODO_FACTURA,
                   e.razon_social
              FROM sfc_facturas_v f, SRE_EMPLEADORES_T e, sre_nominas_t n
             WHERE f.id_usuario_autoriza = upper(p_idusuario)
               AND f.id_referencia = p_NoReferencia
               AND f.id_registro_patronal = e.id_registro_patronal
               AND f.no_autorizacion IS NOT NULL
               AND F.STATUS <> 'PA'
               AND n.id_registro_patronal = f.id_registro_patronal
               AND n.id_nomina = f.id_nomina
             ORDER BY f.fecha_autorizacion DESC;
        
        ELSIF p_concepto = v_tt_ISR THEN
          OPEN c_cursor FOR
            SELECT l.no_autorizacion,
                   l.id_referencia_isr   id_referencia,
                   e.rnc_o_cedula,
                   l.fecha_autorizacion,
                   l.TOTAL_A_PAGAR       total_general,
                   l.ID_USUARIO_AUTORIZA,
                   n.nomina_des,
                   l.periodo_liquidacion,
                   e.razon_social
              FROM sfc_liquidacion_isr_v l,
                   SRE_EMPLEADORES_T     e,
                   sre_nominas_t         n
             WHERE l.id_usuario_autoriza = upper(p_idusuario)
               AND l.id_referencia_isr = p_NoReferencia
               AND l.id_registro_patronal = e.id_registro_patronal
               AND l.no_autorizacion IS NOT NULL
               AND l.STATUS <> 'PA'
               AND n.id_registro_patronal = l.id_registro_patronal
               AND n.id_nomina = l.id_nomina
             ORDER BY l.fecha_autorizacion DESC;
        
        ELSIF p_concepto = v_tt_IR17 THEN
          BEGIN
            OPEN c_cursor FOR
              SELECT I.NO_AUTORIZACION,
                     i.id_referencia_ir17  id_referencia,
                     e.rnc_o_cedula,
                     i.FECHA_AUTORIZACION,
                     I.LIQUIDACION         total_general,
                     i.ID_USUARIO_AUTORIZA,
                     i.periodo_liquidacion,
                     e.razon_social
                FROM sfc_liquidacion_ir17_v i, SRE_EMPLEADORES_T e
               WHERE i.ID_USUARIO_AUTORIZA = upper(p_idusuario)
                 AND i.ID_REFERENCIA_IR17 = p_NoReferencia
                 AND i.ID_REGISTRO_PATRONAL = e.id_registro_patronal
                 AND i.NO_AUTORIZACION IS NOT NULL
                 AND i.STATUS <> 'PA'
               ORDER BY i.FECHA_AUTORIZACION DESC;
          
          END;
        
        ELSIF p_concepto = v_tt_INF THEN
          BEGIN
            OPEN c_cursor FOR
              SELECT I.NO_AUTORIZACION,
                     i.id_referencia_infotep id_referencia,
                     e.rnc_o_cedula,
                     i.FECHA_AUTORIZACION,
                     I.total_pago_infotep    total_general,
                     i.ID_USUARIO_AUTORIZA,
                     i.periodo_liquidacion,
                     e.razon_social
                FROM suirplus.sfc_liquidacion_infotep_t i,
                     SRE_EMPLEADORES_T                  e
               WHERE i.ID_USUARIO_AUTORIZA = upper(p_idusuario)
                 AND i.ID_REFERENCIA_INFOTEP = p_NoReferencia
                 AND i.ID_REGISTRO_PATRONAL = e.id_registro_patronal
                 AND i.NO_AUTORIZACION IS NOT NULL
                 AND i.STATUS <> 'PA'
               ORDER BY i.FECHA_AUTORIZACION DESC;
          
          END;
        ELSIF p_concepto = v_tt_MDT THEN
          BEGIN
            OPEN c_cursor FOR
              SELECT I.NO_AUTORIZACION,
                     i.id_referencia_planilla id_referencia,
                     e.rnc_o_cedula,
                     i.FECHA_AUTORIZACION,
                     I.total_pago             total_general,
                     i.ID_USUARIO_AUTORIZA,
                     i.periodo_liquidacion,
                     e.razon_social
                FROM suirplus.sfc_planilla_mdt_t i, SRE_EMPLEADORES_T e
               WHERE i.ID_USUARIO_AUTORIZA = upper(p_idusuario)
                 AND i.ID_REFERENCIA_PLANILLA = p_NoReferencia
                 AND i.ID_REGISTRO_PATRONAL = e.id_registro_patronal
                 AND i.NO_AUTORIZACION IS NOT NULL
                 AND i.STATUS <> 'PA'
               ORDER BY i.FECHA_AUTORIZACION DESC;
          
          END;
        END IF;
      ELSE
      
        IF p_concepto = v_tt_SDSS THEN
          OPEN c_cursor FOR
            SELECT f.no_autorizacion,
                   f.id_referencia,
                   e.rnc_o_cedula,
                   f.fecha_autorizacion,
                   f.total_general_factura total_general,
                   f.ID_USUARIO_AUTORIZA,
                   n.nomina_des,
                   f.PERIODO_FACTURA,
                   e.razon_social
              FROM sfc_facturas_v f, SRE_EMPLEADORES_T e, sre_nominas_t n
             WHERE f.id_usuario_autoriza = upper(p_idusuario)
               AND f.id_registro_patronal = e.id_registro_patronal
               AND f.no_autorizacion IS NOT NULL
               AND F.STATUS <> 'PA'
               AND n.id_registro_patronal = f.id_registro_patronal
               AND n.id_nomina = f.id_nomina
             ORDER BY f.fecha_autorizacion DESC;
        ELSIF p_concepto = v_tt_ISR THEN
          OPEN c_cursor FOR
            SELECT l.no_autorizacion,
                   l.id_referencia_isr   id_referencia,
                   e.rnc_o_cedula,
                   l.fecha_autorizacion,
                   l.TOTAL_A_PAGAR       total_general,
                   l.ID_USUARIO_AUTORIZA,
                   n.nomina_des,
                   l.periodo_liquidacion,
                   e.razon_social
              FROM sfc_liquidacion_isr_v l,
                   SRE_EMPLEADORES_T     e,
                   sre_nominas_t         n
             WHERE l.id_usuario_autoriza = upper(p_idusuario)
               AND l.id_registro_patronal = e.id_registro_patronal
               AND l.no_autorizacion IS NOT NULL
               AND l.STATUS <> 'PA'
               AND n.id_registro_patronal = l.id_registro_patronal
               AND n.id_nomina = l.id_nomina
             ORDER BY l.fecha_autorizacion DESC;
        ELSIF p_concepto = v_tt_IR17 THEN
          BEGIN
            OPEN c_cursor FOR
              SELECT I.NO_AUTORIZACION,
                     i.id_referencia_ir17  id_referencia,
                     e.rnc_o_cedula,
                     i.FECHA_AUTORIZACION,
                     I.LIQUIDACION         total_general,
                     i.ID_USUARIO_AUTORIZA,
                     i.periodo_liquidacion,
                     e.razon_social
                FROM sfc_liquidacion_ir17_v i, SRE_EMPLEADORES_T e
               WHERE i.ID_USUARIO_AUTORIZA = upper(p_idusuario)
                 AND i.ID_REGISTRO_PATRONAL = e.id_registro_patronal
                 AND i.NO_AUTORIZACION IS NOT NULL
                 AND i.STATUS <> 'PA'
               ORDER BY i.FECHA_AUTORIZACION DESC;
          END;
        ELSIF p_concepto = v_tt_INF THEN
          BEGIN
            OPEN c_cursor FOR
              SELECT I.NO_AUTORIZACION,
                     i.id_referencia_infotep id_referencia,
                     e.rnc_o_cedula,
                     i.FECHA_AUTORIZACION,
                     I.total_pago_infotep    total_general,
                     i.ID_USUARIO_AUTORIZA,
                     i.periodo_liquidacion,
                     e.razon_social
                FROM suirplus.sfc_liquidacion_infotep_t i,
                     SRE_EMPLEADORES_T                  e
               WHERE i.ID_USUARIO_AUTORIZA = upper(p_idusuario)
                 AND i.ID_REGISTRO_PATRONAL = e.id_registro_patronal
                 AND i.NO_AUTORIZACION IS NOT NULL
                 AND i.STATUS <> 'PA'
               ORDER BY i.FECHA_AUTORIZACION DESC;
          END;
        ELSIF p_concepto = v_tt_MDT THEN
          BEGIN
            OPEN c_cursor FOR
              SELECT I.NO_AUTORIZACION,
                     i.id_referencia_planilla id_referencia,
                     e.rnc_o_cedula,
                     i.FECHA_AUTORIZACION,
                     I.total_pago             total_general,
                     i.ID_USUARIO_AUTORIZA,
                     i.periodo_liquidacion,
                     e.razon_social
                FROM suirplus.sfc_planilla_mdt_t i, SRE_EMPLEADORES_T e
               WHERE i.ID_USUARIO_AUTORIZA = upper(p_idusuario)
                 AND i.ID_REGISTRO_PATRONAL = e.id_registro_patronal
                 AND i.NO_AUTORIZACION IS NOT NULL
                 AND i.STATUS <> 'PA'
               ORDER BY i.FECHA_AUTORIZACION DESC;
          END;
        END IF;
      END IF;
    END IF;
  
    p_resultnumber := 0;
    p_IOCursor     := c_cursor;
  
  EXCEPTION
  
    WHEN e_invaliduser THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(1, NULL, NULL);
      RETURN;
    
    WHEN e_invalidNoReferencia THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(16, NULL, NULL);
      RETURN;
    
    WHEN OTHERS THEN
      v_bd_error     := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultnumber := Seg_Retornar_Cadena_Error(-1, v_bd_error, SQLCODE);
      RETURN;
    
  END;

  --/////////////////////////////////////////////////////////////

  -- **************************************************************************************************
  -- Program:     Cons_Referencias_Pendientes
  -- Description: Trae una consulta general de las referencias pendientes para un RNC y un tipo de institucion especifica
  -- **************************************************************************************************

  PROCEDURE Cons_Referencias_Pendientes(p_RNCoCedula   IN SRE_EMPLEADORES_T.RNC_O_CEDULA%TYPE,
                                        p_IOCursor     IN OUT t_Cursor,
                                        p_resultnumber OUT VARCHAR2) IS
    v_cant_referencias varchar2(50);
    v_bd_error         VARCHAR(1000);
    c_cursor           t_cursor;
  
    cursor c_refencias_SDSS is
      SELECT count(f.id_referencia)
        FROM sfc_facturas_v f, sre_empleadores_t e, SRE_NOMINAS_T n
       WHERE f.id_registro_patronal = e.id_registro_patronal
         and f.id_registro_patronal = n.id_registro_patronal
         and f.id_nomina = n.id_nomina
         and f.STATUS in ('VE', 'VI')
         AND f.no_autorizacion IS NULL
         and e.rnc_o_cedula = p_RNCoCedula
       ORDER BY f.id_nomina, f.periodo_factura, f.status;
    /*
    cursor c_refencias_ISR is
         SELECT count(L.ID_REFERENCIA_ISR)  FROM sfc_liquidacion_isr_v l, SRE_EMPLEADORES_T e
         WHERE L.ID_REGISTRO_PATRONAL = e.id_registro_patronal
         and l.STATUS in('VE','VI')
         and e.rnc_o_cedula = p_RNCoCedula;
    
    cursor c_refencias_IR17 is
         SELECT count(i.ID_REFERENCIA_IR17)  FROM sfc_liquidacion_ir17_v i, SRE_EMPLEADORES_T e
         WHERE i.ID_REGISTRO_PATRONAL = e.id_registro_patronal
         and i.STATUS in('VE','VI')
         and e.rnc_o_cedula = p_RNCoCedula;      */
  
  BEGIN
  
    OPEN c_refencias_SDSS;
    fetch c_refencias_SDSS
      into v_cant_referencias;
    if v_cant_referencias <> 0 then
      p_resultnumber := 1;
    else
      p_resultnumber := 0;
    end if;
  
    close c_refencias_SDSS;
  
    OPEN c_cursor FOR
      SELECT f.id_referencia id_referencia,
             f.id_nomina,
             Srp_Pkg.ProperCase(n.nomina_des) nomina_des,
             Srp_Pkg.FormateaPeriodo(f.periodo_factura) periodo_factura,
             f.total_general_factura total_general,
             e.razon_social
        FROM sfc_facturas_v f, SRE_EMPLEADORES_T e, SRE_NOMINAS_T n
       WHERE e.rnc_o_cedula = p_RNCoCedula
         AND f.id_registro_patronal = e.id_registro_patronal
         AND f.id_registro_patronal = n.id_registro_patronal
         AND f.id_nomina = n.id_nomina
         AND f.status IN ('VI', 'VE')
         AND f.no_autorizacion IS NULL
       ORDER BY f.id_nomina, f.periodo_factura, f.status;
  
    p_IOCursor := c_cursor;
  
    /*
                IF p_concepto =  v_tt_ISR THEN
    
                    OPEN c_refencias_ISR;
                    fetch c_refencias_ISR into v_cant_referencias;
                        if v_cant_referencias <> 0 then
                            p_resultnumber := 1;
                        else
                            p_resultnumber:= 0;
                        end if;
                    close c_refencias_ISR;
    
                END IF;
    
                IF p_concepto =  v_tt_IR17 THEN
    
                    OPEN c_refencias_IR17;
                    fetch c_refencias_IR17 into v_cant_referencias;
                        if v_cant_referencias <> 0 then
                            p_resultnumber := 1;
                        else
                            p_resultnumber:= 0;
                        end if;
                    close c_refencias_IR17;
    
                END IF;
    */
  EXCEPTION
  
    WHEN OTHERS THEN
      v_bd_error     := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultnumber := Seg_Retornar_Cadena_Error(-1, v_bd_error, SQLCODE);
      RETURN;
    
  END;
  -- -----------------------------------------------------------------------------------------------------
  -- identificar_refs_para_pago
  -- metodo para reutilizar la logica de determinar las referencias disponibles para pago en la consulta
  -- y el web-service
  -- -----------------------------------------------------------------------------------------------------
  procedure identificar_refs_para_pago(p_regpat in number) is
    min_per              number(6);
    fecha_lim_acuerdo    date;
    conteo               number(6);
    tiene_acuerdo_activo number(6);
    FormaParte           number(6);
  
    function min_periodo(p_nomina in number) return number is
      res number(6);
    begin
      -- periodo mas viejo de esa nomina
      select min(f.PERIODO_FACTURA)
        into res
        from suirplus.sfc_facturas_t f
       where f.id_registro_patronal = p_regpat
         and f.id_nomina = p_nomina
         and f.status in ('VI', 'VE')
         and (((f.id_tipo_factura = 'U') and (f.status_generacion = 'D')) or
             (f.id_tipo_factura != 'U'))
         and f.no_autorizacion is null
         and f.id_referencia not in
             (select d.id_referencia -- que no salgan facturas de acuedos que no han sido aprobados
                from suirplus.lgl_acuerdos_t a
                join suirplus.lgl_det_acuerdos_t d
                  on d.id_acuerdo = a.id_acuerdo
                 and d.tipo = a.tipo
               where a.id_registro_patronal = p_regpat
                 and a.status in (1, 2, 3, 4));
      return nvl(res, -1);
    end;
  
    procedure add(referencia varchar2, sino varchar2) is
      vPer suirplus.sfc_facturas_v.periodo_factura%type;
      vTot suirplus.sfc_facturas_v.TOTAL_GENERAL_FACTURA%type;
      vNom suirplus.sre_nominas_t.nomina_des%type;
    begin
      select f.PERIODO_FACTURA, f.TOTAL_GENERAL_FACTURA, n.nomina_des
        into vPer, vTot, vNom
        from suirplus.sfc_facturas_v f
        join suirplus.sre_nominas_t n
          on n.id_registro_patronal = f.ID_REGISTRO_PATRONAL
         and n.ID_NOMINA = f.ID_NOMINA
       where f.ID_REFERENCIA = referencia;
    
      insert into sfc_acuerdo_pago
        (id_registro_patronal,
         id_referencia,
         periodo_factura,
         total_general,
         nomina_des,
         sino)
      values
        (p_regpat, referencia, vPer, vTot, vNom, sino);
      commit;
    end;
  begin
    --Borramos la data para este empleador
    Delete from sfc_acuerdo_pago Where id_registro_patronal = p_regpat;
    commit;
  
    -- ver si tiene un acuerdo de pago en curso
    select count(*)
      into tiene_acuerdo_activo
      from suirplus.lgl_acuerdos_t a
     where a.id_registro_patronal = p_regpat
       and a.status in (3, 4);
  
    for facturas in (select f.id_referencia,
                            f.status,
                            f.id_tipo_factura,
                            id_nomina,
                            f.periodo_factura,
                            f.fecha_limite_pago,
                            fecha_limite_acuerdo_pago
                       from suirplus.sfc_facturas_t f
                      where f.id_registro_patronal = p_regpat
                        and f.status in ('VI', 'VE')
                        and f.no_autorizacion is null
                        and (((f.id_tipo_factura = 'U') and
                            (f.status_generacion = 'D')) or
                            (f.id_tipo_factura != 'U'))
                        and f.id_referencia not in
                            (select d.id_referencia -- que no salgan facturas de acuedos que no han sido aprobados
                               from suirplus.lgl_acuerdos_t a
                               join suirplus.lgl_det_acuerdos_t d
                                 on d.id_acuerdo = a.id_acuerdo
                                and d.tipo = a.tipo
                              where a.id_registro_patronal = p_regpat
                                and a.status in (1, 2))) loop
      if (tiene_acuerdo_activo > 0) then
        select count(*)
          into conteo
          from suirplus.lgl_det_acuerdos_t a
          join suirplus.lgl_acuerdos_t b
            on b.id_acuerdo = a.id_acuerdo
           and b.tipo = a.tipo
           and b.status in (3, 4)
         where a.id_referencia = facturas.id_referencia;
      
        if (conteo > 0) then
          --si, la referencia esta en un acuerdo
          select min(f.fecha_limite_acuerdo_pago)
            into fecha_lim_acuerdo
            from suirplus.sfc_facturas_t f
           where f.id_registro_patronal = p_regpat
             and f.status in ('VI', 'VE')
             and f.no_autorizacion is null
             and f.id_referencia not in
                 (select d.id_referencia -- que no salgan facturas de acuedos que no han sido aprobados
                    from suirplus.lgl_acuerdos_t a
                    join suirplus.lgl_det_acuerdos_t d
                      on d.id_acuerdo = a.id_acuerdo
                     and d.tipo = a.tipo
                   where a.id_registro_patronal = p_regpat
                     and a.status in (1, 2));
        
          if (facturas.fecha_limite_acuerdo_pago = fecha_lim_acuerdo) then
            add(facturas.id_referencia, 'S');
          else
            add(facturas.id_referencia, 'N');
          end if;
        else
          -- no, la referencia no esta en acuerdo, el empleador si
          -- VER SI cumplio sus cuotas de acuerdo de pago
          select count(*)
            into conteo
            from sfc_facturas_v f
            join suirplus.lgl_det_acuerdos_t d
              on d.id_referencia = f.id_referencia
            join suirplus.lgl_acuerdos_t a
              on a.id_acuerdo = d.id_acuerdo
             and a.tipo = d.tipo
             and a.status in (3, 4)
           where f.id_registro_patronal = p_regpat
             and f.status in ('VI', 'VE')
             and f.no_autorizacion is null
             and trunc(f.fecha_limite_acuerdo_pago) < trunc(sysdate);
        
          if (conteo > 0) then
            -- tiene cuotas vencidas, no puede pagar lo que este fuera del acuerdo
            add(facturas.id_referencia, 'N');
          else
            -- no tiene cuotas vencidas, si es la mas vieja de esa nomina, la puede pagar
            if (min_periodo(facturas.id_nomina) = facturas.periodo_factura) then
              add(facturas.id_referencia, 'S');
            else
              add(facturas.id_referencia, 'N');
            end if;
          end if;
        end if;
      else
        -- no titne acuerdos , si es la mas vieja de esa nomina, la puede pagar
        if (min_periodo(facturas.id_nomina) = facturas.periodo_factura) then
          add(facturas.id_referencia, 'S');
        else
          add(facturas.id_referencia, 'N');
        end if;
      end if;
    end loop;
  end;

  -- **************************************************************************************************
  -- Program:     Aut_Referencia
  -- Description:
  --
  -- **************************************************************************************************

  PROCEDURE Aut_Referencia(p_NoReferencia IN SFC_FACTURAS_T.id_referencia%TYPE,
                           p_idusuario    IN SFC_FACTURAS_T.id_usuario_autoriza%TYPE,
                           p_concepto     IN VARCHAR2,
                           p_nro_aut      OUT SFC_FACTURAS_T.no_autorizacion%TYPE,
                           p_resultnumber OUT VARCHAR2)
  
   IS
  
    e_invaliduser EXCEPTION;
    e_invalidNoReferencia EXCEPTION;
    e_NoHabilParaPagar EXCEPTION;
    e_AntiguedadReferencia EXCEPTION;
    v_permiso     NUMBER;
    v_permiso1    NUMBER;
    v_permiso2    NUMBER;
    v_RegPatronal NUMBER;
    --        v_PermitirPago               VARCHAR(2);
    v_bd_error          VARCHAR(1000);
    v_entidad           NUMBER;
    v_noreferencia      VARCHAR(16);
    v_status            VARCHAR2(2);
    v_total_liquidacion NUMBER;
    v_ahora             date;
    v_conteo            number(9);
  
    CURSOR c_cursor IS
      SELECT i.ID_REFERENCIA_IR17, i.STATUS, i.LIQUIDACION
        FROM sfc_liquidacion_ir17_v i
       WHERE i.ID_REFERENCIA_IR17 = p_NoReferencia
         AND i.LIQUIDACION > 0
         AND i.STATUS = 'VI';
  
    cursor c_permiso1 is
      select 1
        from seg_rel_permiso_roles_t t
       where t.id_role = 59
         and t.id_permiso = '132';
    cursor c_permiso2 is
      select 2
        from seg_rel_permiso_roles_t t
       where t.id_role = 59
         and t.id_permiso = '48';
  
  BEGIN
  
    IF NOT Seg_Usuarios_Pkg.isExisteUsuario(upper(p_idusuario)) THEN
      RAISE e_invaliduser;
    END IF;
  
    IF NOT Sfc_Factura_Pkg.isExisteNoReferencia(p_concepto, p_NoReferencia) THEN
      RAISE e_invalidNoReferencia;
    END IF;
  
    --Cambio para el pago con PIN  del MDT
    if p_concepto != v_tt_MDT then
      SELECT u.id_entidad_recaudadora
        INTO v_entidad
        FROM SEG_USUARIO_T u
       WHERE u.id_usuario = upper(p_idusuario);
    end if;
  
    -- En caso de que sea una Factura de la TSS
    IF p_concepto = v_tt_SDSS THEN
    
      SELECT fa.id_registro_patronal
        INTO v_RegPatronal
        FROM SFC_FACTURAS_v fa
       WHERE fa.id_referencia = p_NoReferencia;
    
      /*
                  SELECT permitir_pago(e.) INTO v_PermitirPago
                  FROM SRE_EMPLEADORES_T e
                  WHERE e.id_registro_patronal = v_RegPatronal;
      */
    
      dbms_output.put_line('antes:');
      IF suirplus.sre_empleadores_pkg.Permitir_Pago(v_RegPatronal) = 'N' THEN
        dbms_output.put_line('dentro');
        RAISE e_NoHabilParaPagar;
      END IF;
      dbms_output.put_line('despues:');
    
      /*          Comentado por GH -- 07/nov/2011
                  -- Para buscar la referencia en un acuerdo de pago
                  -- se agregó esta línea según ticket 4095, GH - 02/nov/2011
                  For c_AcuerdoPago in (Select 1
                                        from lgl_det_acuerdos_t d
                                        join lgl_acuerdos_t a
                                          on a.id_acuerdo = d.id_acuerdo
                                         and a.tipo = d.tipo
                                         and a.id_registro_patronal = v_RegPatronal
                                         and a.status in (1,2)
                                        where d.id_referencia = p_NoReferencia) Loop
                    RAISE e_NoHabilParaPagar;
                  End Loop;
      
                  ---- Para validar si existe alguna referencia mas antigua que la que se esta pagando
                  For c_Nomina in (select id_nomina, periodo_factura, id_registro_patronal
                            from suirplus.sfc_facturas_v
                            where id_referencia = p_NoReferencia) Loop
      
                    For c_Antiguedad in (
                                         select count(id_referencia) total
                                         from suirplus.sfc_facturas_v f
                                         where id_registro_patronal = c_Nomina.id_registro_patronal
                                           and id_nomina = c_Nomina.id_nomina
                                           and periodo_factura < c_Nomina.periodo_factura
                                           and status in ('VE','VI')
                                           and no_autorizacion is null
                                           and ID_TIPO_FACTURA <> 'Y'
                                           and not exists
                                             (
                                              Select 1
                                              from lgl_det_acuerdos_t d, lgl_acuerdos_t a
                                              where a.id_acuerdo = d.id_acuerdo and a.tipo=d.tipo
                                              and a.id_registro_patronal = f.id_registro_patronal
                                              and d.id_referencia = f.id_referencia
                                             )
                                           )
      
                                           Loop
      
                      If c_Antiguedad.total > 0 Then
                        RAISE e_AntiguedadReferencia;
                      End if;
      
                    End loop;
      
                  End loop;
      */
      -- GH -- 07/nov/2011
      -- Esta lógica fue sacada de "LasRefsDisponiblesParaPago"
      -- Buscar todas las referencias pendientes para esa empresa
      -- El resultado se guarda en la tabla sfc_acuerdo_pago
      identificar_refs_para_pago(v_RegPatronal);
    
      -- Confirmar si la referencia esta en la tabla sfc_acuerdo_pago
    
      select count(*)
        into v_conteo
        from sfc_acuerdo_pago
       where id_registro_patronal = v_RegPatronal
         and id_referencia = p_NoReferencia
         and sino = 'S';
    
      -- Si no la encuentra, rechazar. GH -- 07/nov/2011
      if v_conteo = 0 then
        RAISE e_AntiguedadReferencia;
      end if;
    
      SELECT sfc_autorizacion_seq.NEXTVAL INTO p_nro_aut FROM dual;
      p_resultnumber := 0;
    
      UPDATE SFC_FACTURAS_T f
         SET f.no_autorizacion        = p_nro_aut,
             f.id_usuario_autoriza    = upper(p_idusuario),
             f.fecha_autorizacion     = SYSDATE,
             f.id_entidad_recaudadora = v_entidad,
             f.ult_usuario_act        = upper(p_idusuario)
       WHERE f.id_referencia = p_NoReferencia
         and status not in ('PA', 'CA', 'RE');
      commit;
    
    END IF;
  
    -- En caso de que sea una Liquidacion de la DGII
    IF p_concepto = v_tt_ISR THEN
      -------------------------------------
      open c_permiso1;
      fetch c_permiso1
        into v_permiso1;
      close c_permiso1;
      open c_permiso2;
      fetch c_permiso2
        into v_permiso2;
      close c_permiso2;
    
      if (v_permiso2 is not null) then
        ----------------------------------------
      
        Esta_En_FechaPago(p_concepto, v_permiso);
      
        if v_permiso = 1 then
        
          SELECT li.id_registro_patronal
            INTO v_RegPatronal
            FROM SFC_LIQUIDACION_ISR_v li
           WHERE li.id_referencia_isr = p_NoReferencia;
        
          /*
                              SELECT permitir_pago INTO v_PermitirPago
                              FROM SRE_EMPLEADORES_T e
                              WHERE e.id_registro_patronal = v_RegPatronal;
          */
        
          IF suirplus.sre_empleadores_pkg.Permitir_Pago(v_RegPatronal) = 'N' THEN
            RAISE e_NoHabilParaPagar;
          END IF;
        
          ---- Para validar si existe alguna referencia mas antigua que la que se esta pagando
          /*                    For c_Nomina in (select periodo_liquidacion, id_registro_patronal
                                        from suirplus.sfc_liquidacion_isr_v
                                        where id_referencia_isr = p_NoReferencia) Loop
          
                                For c_Antiguedad in (select count(id_referencia_isr) total
                                                     from suirplus.sfc_liquidacion_isr_v
                                                     where id_registro_patronal = c_Nomina.id_registro_patronal
                                                       and periodo_liquidacion < c_Nomina.periodo_liquidacion
                                                       and status in ('VE','VI')
                                                       and no_autorizacion is null) Loop
          
                                  If c_Antiguedad.total > 0 Then
                                    RAISE e_AntiguedadReferencia;
                                  End if;
          
                                End loop;
                              End loop;
          */
        
          SELECT sfc_autorizacion_seq.NEXTVAL INTO p_nro_aut FROM dual;
          p_resultnumber := 0;
        
          v_ahora := sysdate;
        
          UPDATE SFC_LIQUIDACION_ISR_T l
             SET l.no_autorizacion        = p_nro_aut,
                 l.id_usuario_autoriza    = upper(p_idusuario),
                 l.fecha_autorizacion     = v_ahora,
                 l.id_entidad_recaudadora = v_entidad,
                 l.ult_usuario_act        = upper(p_idusuario)
           WHERE l.id_referencia_isr = p_NoReferencia;
          if (upper(p_idusuario) = upper('tesoreria')) then
            UPDATE SFC_LIQUIDACION_ISR_T l
               SET l.status = 'PA', l.fecha_pago = v_ahora
             WHERE l.id_referencia_isr = p_NoReferencia;
          end if;
          commit;
        
        else
          p_resultnumber := 'Esta fuera del periodo de pago para estos impuestos';
        end if;
      end if;
    END IF;
  
    --********
    -- En caso de que sea una Liquidacion de la DGII_IR17
    IF p_concepto = v_tt_IR17 THEN
    
      OPEN c_cursor;
      FETCH c_cursor
        INTO v_noreferencia, v_status, v_total_liquidacion;
      CLOSE c_cursor;
    
      IF v_noreferencia IS NOT NULL THEN
      
        --------------------------------------------
        open c_permiso1;
        fetch c_permiso1
          into v_permiso1;
        close c_permiso1;
        open c_permiso2;
        fetch c_permiso2
          into v_permiso2;
        close c_permiso2;
      
        if (v_permiso1 is not null) then
        
          -----------------------------------------------*/
          Esta_En_FechaPago(p_concepto, v_permiso);
        
          if v_permiso = 1 then
            SELECT i.id_registro_patronal
              INTO v_RegPatronal
              FROM SFC_LIQUIDACION_IR17_T i
             WHERE i.id_referencia_ir17 = p_NoReferencia;
          
            /*
                                        SELECT e.permitir_pago INTO v_PermitirPago
                                        FROM SRE_EMPLEADORES_T e
                                        WHERE e.id_registro_patronal = v_RegPatronal;
            */
          
            IF suirplus.sre_empleadores_pkg.Permitir_Pago(v_RegPatronal) = 'N' THEN
              RAISE e_NoHabilParaPagar;
            END IF;
          
            ---- Para validar si existe alguna referencia mas antigua que la que se esta pagando
            /*                            For c_Nomina in (select periodo_liquidacion, id_registro_patronal
                                                  from suirplus.sfc_liquidacion_ir17_v
                                                  where id_referencia_ir17 = p_NoReferencia) Loop
            
                                          For c_Antiguedad in (select count(id_referencia_ir17) total
                                                               from suirplus.sfc_liquidacion_ir17_v
                                                               where id_registro_patronal = c_Nomina.id_registro_patronal
                                                                 and periodo_liquidacion < c_Nomina.periodo_liquidacion
                                                                 and status in ('VE','VI')
                                                                 and no_autorizacion is null) Loop
            
                                            If c_Antiguedad.total > 0 Then
                                              RAISE e_AntiguedadReferencia;
                                            End if;
            
                                          End loop;
            
                                        End loop;
            */
            SELECT sfc_autorizacion_seq.NEXTVAL INTO p_nro_aut FROM dual;
            p_resultnumber := 0;
          
            v_ahora := sysdate;
          
            UPDATE SFC_LIQUIDACION_IR17_T i
               SET i.no_autorizacion        = p_nro_aut,
                   i.id_usuario_autoriza    = upper(p_idusuario),
                   i.fecha_autorizacion     = v_ahora,
                   i.id_entidad_recaudadora = v_entidad,
                   i.ult_usuario_act        = upper(p_idusuario)
             WHERE i.id_referencia_ir17 = v_noreferencia;
          
            if (upper(p_idusuario) = upper('tesoreria')) then
              UPDATE SFC_LIQUIDACION_IR17_T i2
                 SET i2.status = 'PA', i2.fecha_pago = v_ahora
               WHERE i2.id_referencia_ir17 = p_NoReferencia;
            end if;
            commit;
          
          else
            p_resultnumber := 'Esta fuera del periodo de pago para estos impuestos';
          end if;
        
        end if;
      
      ELSE
      
        p_resultnumber := 'Esta factura debe estar vigente o su total debe ser mayor que 0 para ser autorizada';
      
      END IF;
    END IF;
  
    -- En caso de que sea una Factura de INFOTEP
    IF p_concepto = v_tt_INF THEN
    
      SELECT i.id_registro_patronal
        INTO v_RegPatronal
        FROM suirplus.sfc_liquidacion_infotep_t i
       WHERE i.id_referencia_infotep = p_NoReferencia;
    
      /*
                  SELECT permitir_pago INTO v_PermitirPago
                  FROM SRE_EMPLEADORES_T e
                  WHERE e.id_registro_patronal = v_RegPatronal;
      */
    
      IF suirplus.sre_empleadores_pkg.Permitir_Pago(v_RegPatronal) = 'N' THEN
        RAISE e_NoHabilParaPagar;
      END IF;
    
      SELECT sfc_autorizacion_seq.NEXTVAL INTO p_nro_aut FROM dual;
      p_resultnumber := 0;
    
      UPDATE suirplus.sfc_liquidacion_infotep_t f
         SET f.no_autorizacion        = p_nro_aut,
             f.id_usuario_autoriza    = upper(p_idusuario),
             f.fecha_autorizacion     = SYSDATE,
             f.id_entidad_recaudadora = v_entidad,
             f.ult_usuario_act        = upper(p_idusuario)
       WHERE f.id_referencia_infotep = p_NoReferencia
         and status not in ('PA', 'CA');
    
      select count(*)
        into v_conteo
        from seg_usuario_t
       where id_entidad_recaudadora = 7
         and id_usuario = upper(p_idusuario)
         and upper(p_idusuario) = 'TESORERIA';
    
      if (v_conteo >= 1) then
        UPDATE SFC_LIQUIDACION_INFOTEP_T l
           SET l.status = 'PA', l.fecha_pago = v_ahora
         WHERE l.id_referencia_infotep = p_NoReferencia;
      end if;
    
      /*Ticket 81: * Para el Banco Popular y el Banco de Reservas cuando se autoriza una
      liquidacion del INFOTEP se necesita que la FECHA_PAGO se marque con el sysdate.
      */
      if v_entidad in (1, 7) then
        UPDATE suirplus.sfc_liquidacion_infotep_t f
           SET f.fecha_pago = sysdate
         WHERE f.id_referencia_infotep = p_NoReferencia;
      end if;
    
      commit;
    
    END IF;
  
    -- En caso de que sea una Factura de PLANILLA MDT
    IF p_concepto = v_tt_MDT THEN
    
      SELECT i.id_registro_patronal
        INTO v_RegPatronal
        FROM suirplus.sfc_planilla_mdt_t i
       WHERE i.id_referencia_planilla = p_NoReferencia;
    
      /*
                  SELECT permitir_pago INTO v_PermitirPago
                  FROM SRE_EMPLEADORES_T e
                  WHERE e.id_registro_patronal = v_RegPatronal;
      */
    
      IF suirplus.sre_empleadores_pkg.Permitir_Pago(v_RegPatronal) = 'N' THEN
        RAISE e_NoHabilParaPagar;
      END IF;
    
      SELECT sfc_autorizacion_seq.NEXTVAL INTO p_nro_aut FROM dual;
      p_resultnumber := 0;
    
      UPDATE suirplus.sfc_planilla_mdt_t f
         SET f.no_autorizacion        = p_nro_aut,
             f.id_usuario_autoriza    = upper(p_idusuario),
             f.fecha_autorizacion     = SYSDATE,
             f.id_entidad_recaudadora = 98,
             f.ult_usuario_act        = upper(p_idusuario)
       WHERE f.id_referencia_planilla = p_NoReferencia
         and status not in ('PA', 'CA');
    
      select count(*)
        into v_conteo
        from seg_usuario_t
       where id_entidad_recaudadora = 7
         and id_usuario = upper(p_idusuario)
         and upper(p_idusuario) = 'TESORERIA';
    
      if (v_conteo >= 1) then
        UPDATE SFC_planilla_mdt_T l
           SET l.status = 'PA', l.fecha_pago = v_ahora
         WHERE l.id_referencia_planilla = p_NoReferencia;
      end if;
    
      /*Ticket 81: * Para el Banco Popular y el Banco de Reservas cuando se autoriza una
      liquidacion del INFOTEP se necesita que la FECHA_PAGO se marque con el sysdate.
      */
      if v_entidad in (1, 7) then
        UPDATE suirplus.sfc_planilla_mdt_t f
           SET f.fecha_pago = sysdate
         WHERE f.id_referencia_planilla = p_NoReferencia;
      end if;
    
      commit;
    
    END IF;
  
  EXCEPTION
  
    WHEN e_NoHabilParaPagar THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(31, NULL, NULL);
      RETURN;
    
    WHEN e_invaliduser THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(1, NULL, NULL);
      RETURN;
    
    WHEN e_invalidNoReferencia THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(16, NULL, NULL);
      RETURN;
    
    WHEN e_AntiguedadReferencia THEN
      p_resultnumber := 999;
      RETURN;
    
    WHEN OTHERS THEN
      v_bd_error     := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultnumber := Seg_Retornar_Cadena_Error(-1, v_bd_error, SQLCODE);
      RETURN;
    
  END;

  -- **************************************************************************************************
  -- Program:     PAG_Referencia
  -- Description: Para pagar una referencia cuyo estatus este en 'VE' o 'VI y que este autorizada
  -- **************************************************************************************************
  PROCEDURE PAG_Referencia(p_NoReferencia IN SFC_FACTURAS_T.id_referencia%TYPE,
                           p_idusuario    IN SFC_FACTURAS_T.id_usuario_desautoriza%TYPE,
                           p_concepto     IN VARCHAR2,
                           p_resultnumber OUT VARCHAR2)
  
   IS
    e_invaliduser EXCEPTION;
    e_invalidNoReferencia EXCEPTION;
    e_ReferenciaNoautorizada EXCEPTION;
    v_bd_error VARCHAR(1000);
  
  BEGIN
  
    IF NOT Seg_Usuarios_Pkg.isExisteUsuario(p_idusuario) THEN
      RAISE e_invaliduser;
    END IF;
  
    IF NOT Sfc_Factura_Pkg.isExisteNoReferencia(p_concepto, p_NoReferencia) THEN
      RAISE e_invalidNoReferencia;
    END IF;
  
    IF NOT
        Sfc_Factura_Pkg.isReferenciaAutorizada(p_concepto, p_NoReferencia) THEN
      RAISE e_ReferenciaNoAutorizada;
    END IF;
  
    IF p_concepto = v_tt_SDSS THEN
    
      UPDATE SFC_FACTURAS_T f
         SET f.status              = 'PA',
             f.ult_usuario_act     = p_idusuario,
             f.fecha_pago          = sysdate,
             f.fecha_registro_pago = sysdate
       WHERE f.id_referencia = p_NoReferencia
         AND f.status in ('VE', 'VI');
    
    END IF;
  
    IF p_concepto = v_tt_ISR THEN
    
      UPDATE SFC_LIQUIDACION_ISR_T l
         SET l.status             = 'PA',
             l.ult_usuario_act    = p_idusuario,
             l.fecha_pago         = sysdate,
             l.fecha_reporte_pago = sysdate
       WHERE l.id_referencia_isr = p_NoReferencia
         AND l.status in ('VE', 'VI');
    
    END IF;
  
    IF p_concepto = v_tt_IR17 THEN
    
      UPDATE SFC_LIQUIDACION_IR17_T i
         SET i.status             = 'PA',
             i.ult_usuario_act    = p_idusuario,
             i.fecha_pago         = sysdate,
             i.fecha_reporte_pago = sysdate
       WHERE i.id_referencia_ir17 = p_NoReferencia
         AND i.status in ('VE', 'VI');
    
    END IF;
    p_resultnumber := 0;
  
  EXCEPTION
  
    WHEN e_invaliduser THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(1, NULL, NULL);
      RETURN;
    
    WHEN e_invalidNoReferencia THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(16, NULL, NULL);
      RETURN;
    
    WHEN e_ReferenciaNoAutorizada THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(656, NULL, NULL);
      RETURN;
    
    WHEN OTHERS THEN
      v_bd_error     := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultnumber := Seg_Retornar_Cadena_Error(-1, v_bd_error, SQLCODE);
      RETURN;
    
  END PAG_Referencia;

  -- **************************************************************************************************
  -- Program:     Cancelar_Autorizacion
  -- Description: Para cancelar una autorizacion realizada
  --
  -- **************************************************************************************************

  PROCEDURE Cancelar_Autorizacion(p_NoReferencia IN SFC_FACTURAS_T.id_referencia%TYPE,
                                  p_idusuario    IN SFC_FACTURAS_T.id_usuario_desautoriza%TYPE,
                                  p_concepto     IN VARCHAR2,
                                  p_fecha_caja   IN SFC_FACTURAS_T.fecha_desautorizacion%TYPE,
                                  p_resultnumber OUT VARCHAR2)
  
   IS
    e_invaliduser EXCEPTION;
    e_invalidNoReferencia EXCEPTION;
    e_invalidOrigen EXCEPTION;
    v_bd_error      VARCHAR(1000);
    v_id_referencia SFC_FACTURAS_T.id_referencia%TYPE;
    v_nombre_job    SEG_JOB_T.nombre_job%TYPE;
    v_id_job        SEG_JOB_T.id_job%TYPE;
    v_curdate       DATE := SYSDATE;
    v_fechalimite   DATE;
    --        v_OrigenPago  char(1);
  
  BEGIN
  
    v_id_referencia := p_NoReferencia;
  
    IF NOT Seg_Usuarios_Pkg.isExisteUsuario(p_idusuario) THEN
      RAISE e_invaliduser;
    END IF;
  
    IF NOT Sfc_Factura_Pkg.isExisteNoReferencia(p_concepto, p_NoReferencia) THEN
      RAISE e_invalidNoReferencia;
    END IF;
  
    /*select v.origen into v_OrigenPago from sfc_facturas_v v
    where v.ID_REFERENCIA = v_id_referencia;
    
    if v_OrigenPago = 'I' then
        RAISE e_invalidOrigen;
    END IF;*/
  
    IF p_concepto = v_tt_SDSS THEN
    
      UPDATE SFC_FACTURAS_T f
         SET f.no_autorizacion        = NULL,
             f.id_usuario_desautoriza = upper(p_idusuario),
             f.fecha_desautorizacion  = SYSDATE,
             --                    f.id_entidad_recaudadora = 01,
             f.ult_usuario_act = upper(p_idusuario)
       WHERE f.id_referencia = p_NoReferencia;
    
      --Formamos el nombre del job para insertarlo invocando el procedure para estos fines.
      /*SELECT seg_job_seq.NEXTVAL INTO v_id_job FROM dual;
      v_nombre_job:= 'sfc_rec_int_retro_fac_ss_p(' || CHR(39) || v_id_referencia || CHR(39) || ',' || v_id_job || ');';
      insertar_job(v_id_job, v_nombre_job);
      */
    
      --FRANCIS RAMIREZ. 25/02/2009
      SELECT seg_job_seq.NEXTVAL INTO v_id_job FROM dual;
      v_nombre_job := 'sfs_VerificarFactVencida(' || CHR(39) ||
                      v_id_referencia || CHR(39) || ',' || v_id_job || ');';
      insertar_job(v_id_job, v_nombre_job);
    
    END IF;
  
    IF p_concepto = v_tt_ISR THEN
    
      UPDATE SFC_LIQUIDACION_ISR_T l
         SET l.no_autorizacion        = NULL,
             l.id_usuario_desautoriza = upper(p_idusuario),
             l.fecha_desautorizacion  = SYSDATE,
             --                    l.id_entidad_recaudadora = 01,
             l.ult_usuario_act = upper(p_idusuario)
       WHERE l.id_referencia_isr = p_NoReferencia;
    
      SELECT seg_job_seq.NEXTVAL INTO v_id_job FROM dual;
      v_nombre_job := 'sfc_rec_int_retro_liq_isr_p(' || CHR(39) ||
                      v_id_referencia || CHR(39) || ',' || v_id_job || ');';
      insertar_job(v_id_job, v_nombre_job);
    
    END IF;
  
    IF p_concepto = v_tt_IR17 THEN
      BEGIN
      
        Sfc_Ir17_Pkg.fecha_limite(v_fechalimite);
      
        IF TRUNC(v_curdate) > TRUNC(v_fechalimite) THEN
          UPDATE SFC_LIQUIDACION_IR17_T i
             SET i.no_autorizacion        = NULL,
                 i.id_usuario_desautoriza = upper(p_idusuario),
                 i.fecha_desautorizacion  = SYSDATE,
                 i.ult_usuario_act        = upper(p_idusuario),
                 i.status                 = 'VE'
           WHERE i.id_referencia_ir17 = p_NoReferencia;
        ELSE
          UPDATE SFC_LIQUIDACION_IR17_T i
             SET i.no_autorizacion        = NULL,
                 i.id_usuario_desautoriza = upper(p_idusuario),
                 i.fecha_desautorizacion  = SYSDATE,
                 i.ult_usuario_act        = upper(p_idusuario)
           WHERE i.id_referencia_ir17 = p_NoReferencia;
        
        END IF;
      END;
    END IF;
  
    -- Para cancelar facturas de INFOTEP
    IF p_concepto = v_tt_INF THEN
    
      UPDATE suirplus.sfc_liquidacion_infotep_t f
         SET f.no_autorizacion        = NULL,
             f.id_usuario_desautoriza = upper(p_idusuario),
             f.fecha_desautorizacion  = SYSDATE,
             f.ult_usuario_act        = upper(p_idusuario)
       WHERE f.id_referencia_infotep = p_NoReferencia;
    
    END IF;
  
    -- Para cancelar facturas de INFOTEP
    IF p_concepto = v_tt_MDT THEN
    
      UPDATE suirplus.sfc_PLANILLA_MDT_t f
         SET f.no_autorizacion        = NULL,
             f.id_usuario_desautoriza = upper(p_idusuario),
             f.fecha_desautorizacion  = SYSDATE,
             f.ult_usuario_act        = upper(p_idusuario)
       WHERE f.id_referencia_planilla = p_NoReferencia;
    
    END IF;
  
    p_resultnumber := 0;
  
  EXCEPTION
  
    WHEN e_invaliduser THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(1, NULL, NULL);
      RETURN;
    
    WHEN e_invalidNoReferencia THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(16, NULL, NULL);
      RETURN;
    
    WHEN e_invalidOrigen THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(188, NULL, NULL);
      RETURN;
    
    WHEN OTHERS THEN
      v_bd_error     := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultnumber := Seg_Retornar_Cadena_Error(-1, v_bd_error, SQLCODE);
      RETURN;
    
  END;

  -- **************************************************************************************************
  -- Program:     Cons_Detalle
  -- Description: Consulta los detalles de las facturas de acuerdo a la institucion TSS O DGII
  --
  -- **************************************************************************************************

  PROCEDURE Cons_Detalle(p_NoReferencia IN SFC_FACTURAS_T.id_referencia%TYPE,
                         p_concepto     IN VARCHAR2,
                         p_IOCursor     IN OUT t_Cursor,
                         p_resultnumber OUT VARCHAR2) IS
    e_invalidNoReferencia EXCEPTION;
    v_bd_error VARCHAR(1000);
    c_cursor   t_cursor;
  BEGIN
  
    IF NOT Sfc_Factura_Pkg.isExisteNoReferencia(p_concepto, p_NoReferencia) THEN
      RAISE e_invalidNoReferencia;
    END IF;
  
    IF p_concepto = v_tt_SDSS THEN
      OPEN c_cursor FOR
      
        SELECT c.no_documento,
               Srp_Pkg.ProperCase(c.primer_apellido || ' ' ||
                                  c.segundo_apellido || ', ' || c.nombres) Nombres,
               d.id_referencia,
               d.id_nss,
               d.salario_ss,
               d.aporte_afiliados_sfs,
               d.aporte_empleador_sfs,
               d.aporte_afiliados_svds,
               d.aporte_empleador_svds,
               d.aporte_srl,
               d.aporte_voluntario,
               d.per_capita_adicional,
               d.total_intereses_recargos,
               d.total_general_det_factura,
               Srp_Pkg.FormateaPeriodo(d.periodo_aplicacion) AS periodo_aplicacion
          FROM SRE_CIUDADANOS_T c, sfc_det_facturas_v d
         WHERE d.id_referencia = p_NoReferencia
           AND c.id_nss = d.id_nss
         ORDER BY Srp_Pkg.ProperCase(c.primer_apellido || ' ' ||
                                     c.segundo_apellido || ', ' ||
                                     c.nombres);
    
    END IF;
  
    IF p_concepto = v_tt_ISR THEN
      OPEN c_cursor FOR
      
        SELECT CHR(32) || c.no_documento || CHR(32) no_documento,
               Srp_Pkg.ProperCase(c.primer_apellido || ' ' ||
                                  c.segundo_apellido || ', ' || c.nombres) Nombres,
               dl.salario_isr,
               dl.otros_ingresos_isr,
               dl.remuneracion_isr_otros,
               dl.TOTAL_PAGADO,
               dl.RETENCION_SS,
               dl.ISR,
               dl.total_sujeto_retencion,
               dl.saldo_favor_del_periodo,
               dl.saldo_compensado,
               dl.saldo_por_compensar,
               dl.INGRESOS_EXENTOS_ISR,
               dl.impuesto_pagar
          FROM sfc_liquidacion_isr_v     l,
               SRE_CIUDADANOS_T          c,
               sfc_det_liquidacion_isr_v dl
         WHERE l.ID_REFERENCIA_ISR = p_NoReferencia
           AND dl.id_referencia_isr = l.ID_REFERENCIA_ISR
           AND c.id_nss = dl.id_nss
         ORDER BY Srp_Pkg.ProperCase(c.primer_apellido || ' ' ||
                                     c.segundo_apellido || ', ' ||
                                     c.nombres);
    
    END IF;
  
    -- Para traer el detalle de las facturas de INFOTEP
    -- debe tomarse en cuenta que las facturas de acuerdo de pago (facturas tipo 'E') no tienen detalle
    IF p_concepto = v_tt_INF THEN
      OPEN c_cursor FOR
      
        SELECT c.no_documento,
               Srp_Pkg.ProperCase(c.primer_apellido || ' ' ||
                                  c.segundo_apellido || ', ' || c.nombres) Nombres,
               d.id_referencia_infotep,
               d.id_nss,
               d.salario,
               d.pago_infotep,
               Srp_Pkg.FormateaPeriodo(d.periodo_aplicacion) AS periodo_aplicacion
          FROM SRE_CIUDADANOS_T c, suirplus.sfc_det_liquidacion_infotep_t d
         WHERE d.id_referencia_infotep = p_NoReferencia
           AND c.id_nss = d.id_nss
         ORDER BY Srp_Pkg.ProperCase(c.primer_apellido || ' ' ||
                                     c.segundo_apellido || ', ' ||
                                     c.nombres);
    
    END IF;
  
    -- Para traer el detalle de las facturas de PLANILLA MDT
    -- debe tomarse en cuenta que las facturas de acuerdo de pago (facturas tipo 'E') no tienen detalle
    IF p_concepto = v_tt_MDT THEN
      OPEN c_cursor FOR
      
        SELECT c.no_documento,
               Srp_Pkg.ProperCase(c.primer_apellido || ' ' ||
                                  c.segundo_apellido || ', ' || c.nombres) Nombres,
               d.id_referencia_planilla,
               d.id_nss,
               d.salario_mdt salario --, Srp_Pkg.FormateaPeriodo(d.periodo_aplicacion) AS periodo_aplicacion
          FROM SRE_CIUDADANOS_T c, suirplus.sfc_det_planilla_mdt_t d
         WHERE d.id_referencia_planilla = p_NoReferencia
           AND c.id_nss = d.id_nss
         ORDER BY Srp_Pkg.ProperCase(c.primer_apellido || ' ' ||
                                     c.segundo_apellido || ', ' ||
                                     c.nombres);
    
    END IF;
  
    p_resultnumber := 0;
    p_IOCursor     := c_cursor;
  
  EXCEPTION
  
    WHEN e_invalidNoReferencia THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(16, NULL, NULL);
      RETURN;
    
    WHEN OTHERS THEN
      v_bd_error     := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultNumber := Seg_Retornar_Cadena_Error(-1, v_bd_error, SQLCODE);
      RETURN;
    
  END;

  -- **************************************************************************************************
  -- Program:     Cons_Detalle_Auditoria
  -- Description:
  --
  -- **************************************************************************************************

  PROCEDURE Cons_Detalle_Auditoria(p_NoReferencia IN SFC_FACTURAS_T.id_referencia%TYPE,
                                   p_IOCursor     IN OUT t_Cursor,
                                   p_resultnumber OUT VARCHAR2) IS
    e_invalidNoReferencia EXCEPTION;
    v_bd_error VARCHAR(1000);
    c_cursor   t_cursor;
  BEGIN
  
    IF p_NoReferencia IS NOT NULL THEN
      OPEN c_cursor FOR
        with mov as
         (select z.id_referencia,
                 z.id_nss,
                 nvl(z.periodo_aplicacion, y.periodo_factura) periodo,
                 sum(z.salario_ss) pa_salario_ss,
                 sum(z.aporte_voluntario) pa_aporte_voluntario
            from suirplus.sfc_facturas_v x
            join suirplus.sfc_det_facturas_t w
              on w.id_referencia = x.id_referencia
            join suirplus.sfc_facturas_v y
              on y.id_registro_patronal = x.id_registro_patronal
             and y.periodo_factura = w.periodo_aplicacion
             and y.status = 'PA'
             and y.id_referencia <> x.id_referencia
             and y.fecha_emision <= x.fecha_emision
             and y.fecha_pago <= x.fecha_emision
            join suirplus.sfc_det_facturas_t z
              on z.id_referencia = y.id_referencia
             and z.id_nss = w.id_nss
           where x.id_referencia = p_NoReferencia
           group by z.id_referencia,
                    z.id_nss,
                    nvl(z.periodo_aplicacion, y.periodo_factura))
        SELECT DET.ID_NSS,
               CIU.PRIMER_APELLIDO || ' ' || CIU.SEGUNDO_APELLIDO || ', ' ||
               CIU.NOMBRES NOMBRES,
               DET.PERIODO_APLICACION,
               nvl(MOV.PA_SaLARIO_Ss, 0) AS SALARIO_ORIGINAL,
               det.SALARIO_SS AS SALARIO_REPORTADO,
               (det.SALARIO_SS - nvl(MOV.PA_SALARIO_SS, 0)) AS DIF_SALARIO,
               DET.APORTE_AFILIADOS_SFS,
               DET.APORTE_EMPLEADOR_SFS,
               DET.APORTE_AFILIADOS_SVDS,
               DET.APORTE_EMPLEADOR_SVDS,
               DET.APORTE_SRL,
               DET.PER_CAPITA_ADICIONAL,
               nvl(MOV.PA_APORTE_VOLUNTARIO, 0) AS APORTE_ORIGINAL,
               det.APORTE_VOLUNTARIO AS APORTE_REPORTADO,
               (det.APORTE_VOLUNTARIO - nvl(MOV.PA_APORTE_VOLUNTARIO, 0)) AS DIF_APORTE,
               (DET.APORTE_AFILIADOS_SVDS + DET.APORTE_EMPLEADOR_SVDS +
               DET.APORTE_SRL + DET.APORTE_AFILIADOS_SFS +
               DET.APORTE_EMPLEADOR_SFS) AS NUEVO_IMPORTE,
               DET.TOTAL_RECARGOS,
               DET.TOTAL_INTERES,
               DET.TOTAL_GENERAL_DET_FACTURA
          FROM suirplus.SFC_FACTURAS_V FAC
          join suirplus.SFC_DET_FACTURAS_V DET
            on det.id_referencia = fac.ID_REFERENCIA
          join suirplus.SRE_CIUDADANOS_T CIU
            on ciu.id_nss = det.id_nss
          left join mov
            on mov.id_nss = det.id_nss
           and mov.periodo = det.periodo_aplicacion
         WHERE FAC.ID_REFERENCIA = p_NoReferencia
         ORDER BY DET.ID_NSS, DET.PERIODO_APLICACION;
      /*
              -- los movimientos y detalles de movimientos son borrados regularmente
              -- por eso no se deben usar dichas tablas en esta consulta
              -- por roberto jaquez 07/09/2006
              SELECT  DET.ID_NSS, Srp_Pkg.ProperCase(CIU.PRIMER_APELLIDO || ' ' || CIU.SEGUNDO_APELLIDO || ', ' || CIU.NOMBRES) NOMBRES, Srp_Pkg.FormateaPeriodo(DET.PERIODO_APLICACION) AS PERIODO,
                      MOV.PA_SALARIO_SS AS SALARIO_ORIGINAL, MOV.SALARIO_SS AS SALARIO_REPORTADO, (MOV.SALARIO_SS - MOV.PA_SALARIO_SS) AS DIF_SALARIO,
                      DET.APORTE_AFILIADOS_SFS, DET.APORTE_EMPLEADOR_SFS, DET.APORTE_AFILIADOS_SVDS, DET.APORTE_EMPLEADOR_SVDS, DET.APORTE_SRL, DET.PER_CAPITA_ADICIONAL,
                      MOV.PA_APORTE_VOLUNTARIO AS APORTE_ORIGINAL, MOV.APORTE_VOLUNTARIO AS APORTE_REPORTADO,
                      (MOV.APORTE_VOLUNTARIO - MOV.PA_APORTE_VOLUNTARIO) AS DIF_APORTE,
                      (DET.APORTE_AFILIADOS_SVDS + DET.APORTE_EMPLEADOR_SVDS + DET.APORTE_SRL + DET.APORTE_AFILIADOS_SFS + DET.APORTE_EMPLEADOR_SFS) AS NUEVO_IMPORTE,
                      DET.TOTAL_RECARGOS, DET.TOTAL_INTERES, DET.TOTAL_GENERAL_DET_FACTURA
              FROM    SFC_FACTURAS_V FAC, SFC_DET_FACTURAS_V DET,
                      SRE_CIUDADANOS_T CIU, SRE_DET_MOVIMIENTO_T MOV
              WHERE   FAC.ID_REFERENCIA = p_NoReferencia
              AND     FAC.ID_REFERENCIA = DET.ID_REFERENCIA
              AND     DET.ID_NSS = CIU.ID_NSS
              AND     FAC.ID_MOVIMIENTO = MOV.ID_MOVIMIENTO
              AND     DET.ID_NSS = MOV.ID_NSS
              AND     DET.PERIODO_APLICACION = MOV.PERIODO_APLICACION
              ORDER BY DET.ID_NSS, DET.PERIODO_APLICACION;
      */
    
      p_resultnumber := 0;
      p_IOCursor     := c_cursor;
    
    END IF;
  
  EXCEPTION
  
    WHEN e_invalidNoReferencia THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(16, NULL, NULL);
      RETURN;
    
    WHEN OTHERS THEN
      v_bd_error     := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultNumber := Seg_Retornar_Cadena_Error(-1, v_bd_error, SQLCODE);
      RETURN;
    
  END;

  -- **************************************************************************************************
  -- Program:     function isExisteRegistroPatronal()
  -- Description: funcion que retorna la existencia de un registro patronal.
  --
  -- **************************************************************************************************

  FUNCTION isExisteRegistroPatronal(p_id_registro_patronal VARCHAR2)
    RETURN BOOLEAN IS
  
    CURSOR c_existe_registro_patronal IS
    
      SELECT t.id_registro_patronal
        FROM SRE_EMPLEADORES_T t
       WHERE t.id_registro_patronal = p_id_registro_patronal;
  
    returnvalue          BOOLEAN;
    p_idregistropatronal VARCHAR(22);
  
  BEGIN
    OPEN c_existe_registro_patronal;
    FETCH c_existe_registro_patronal
      INTO p_idregistropatronal;
    returnvalue := c_existe_registro_patronal%FOUND;
    CLOSE c_existe_registro_patronal;
  
    RETURN(returnvalue);
  
  END isExisteRegistroPatronal;

  -- **************************************************************************************************
  -- Program:     function isExisteNoReferencia()
  -- Description: funcion que retorna la existencia de un No. de referencia segun su institucion
  --
  -- **************************************************************************************************

  FUNCTION isExisteNoReferencia(p_concepto     VARCHAR2,
                                p_NoReferencia IN SFC_FACTURAS_T.id_referencia%TYPE)
    RETURN BOOLEAN IS
  
    CURSOR c_NoReferenciaTSS IS
      SELECT f.id_referencia
        FROM SFC_FACTURAS_v f
       WHERE f.id_referencia = p_NoReferencia;
  
    CURSOR c_NoReferenciaDGII IS
      SELECT l.id_referencia_isr
        FROM SFC_LIQUIDACION_ISR_v l
       WHERE l.id_referencia_isr = p_NoReferencia;
  
    CURSOR c_NoReferenciaDGII_IR17 IS
      SELECT I.ID_REFERENCIA_IR17
        FROM SFC_LIQUIDACION_IR17_T I
       WHERE I.ID_REFERENCIA_IR17 = p_NoReferencia;
  
    CURSOR c_NoReferenciaINFOTEP IS
      SELECT I.ID_REFERENCIA_INFOTEP
        FROM suirplus.SFC_LIQUIDACION_INFOTEP_T I
       WHERE I.ID_REFERENCIA_INFOTEP = p_NoReferencia;
  
    CURSOR c_NoReferenciaMDT IS
      SELECT I.ID_REFERENCIA_PLANILLA
        FROM suirplus.SFC_PLANILLA_MDT_T I
       WHERE I.ID_REFERENCIA_PLANILLA = p_NoReferencia;
  
    pNoReferenciaTSS       SFC_FACTURAS_T.id_referencia%TYPE;
    pNoReferenciaDGII      SFC_LIQUIDACION_ISR_T.id_referencia_isr%TYPE;
    pNoReferenciaDGII_IR17 SFC_LIQUIDACION_IR17_T.ID_REFERENCIA_IR17%TYPE;
    pNoReferenciaINFOTEP   suirplus.SFC_LIQUIDACION_INFOTEP_T.ID_REFERENCIA_INFOTEP%TYPE;
    pNoReferenciaMDT       suirplus.SFC_PLANILLA_MDT_T.ID_REFERENCIA_PLANILLA%TYPE;
  
  BEGIN
  
    IF p_concepto = 'SDSS' THEN
      OPEN c_NoReferenciaTSS;
      FETCH c_NoReferenciaTSS
        INTO pNoReferenciaTSS;
      RETURN(c_NoReferenciaTSS%FOUND);
      CLOSE c_NoReferenciaTSS;
    
    ELSIF p_concepto = 'ISR' THEN
    
      OPEN c_NoReferenciaDGII;
      FETCH c_NoReferenciaDGII
        INTO pNoReferenciaDGII;
      RETURN(c_NoReferenciaDGII%FOUND);
      CLOSE c_NoReferenciaDGII;
    
    ELSIF p_concepto = 'IR17' THEN
    
      OPEN c_NoReferenciaDGII_IR17;
      FETCH c_NoReferenciaDGII_IR17
        INTO pNoReferenciaDGII_IR17;
      RETURN(c_NoReferenciaDGII_IR17%FOUND);
      CLOSE c_NoReferenciaDGII_IR17;
    
    ELSIF p_concepto = 'INF' THEN
    
      OPEN c_NoReferenciaINFOTEP;
      FETCH c_NoReferenciaINFOTEP
        INTO pNoReferenciaINFOTEP;
      RETURN(c_NoReferenciaINFOTEP%FOUND);
      CLOSE c_NoReferenciaINFOTEP;
    
    ELSIF p_concepto = 'MDT' THEN
    
      OPEN c_NoReferenciaMDT;
      FETCH c_NoReferenciaMDT
        INTO pNoReferenciaMDT;
      RETURN(c_NoReferenciaMDT%FOUND);
      CLOSE c_NoReferenciaMDT;
    
    END IF;
  
  END isExisteNoReferencia;

  -- **************************************************************************************************
  -- Program:     function isReferenciaAutorizada()
  -- Description: funcion que retorna si la referencia esta o no autorizada
  -- **************************************************************************************************

  FUNCTION isReferenciaAutorizada(p_concepto     VARCHAR2,
                                  p_NoReferencia IN SFC_FACTURAS_T.id_referencia%TYPE)
    RETURN BOOLEAN IS
  
    CURSOR c_NoReferenciaTSS IS
      SELECT f.No_autorizacion
        FROM SFC_FACTURAS_v f
       WHERE f.id_referencia = p_NoReferencia;
  
    CURSOR c_NoReferenciaDGII IS
      SELECT l.No_autorizacion
        FROM SFC_LIQUIDACION_ISR_v l
       WHERE l.id_referencia_isr = p_NoReferencia;
  
    CURSOR c_NoReferenciaDGII_IR17 IS
      SELECT I.No_autorizacion
        FROM SFC_LIQUIDACION_IR17_T I
       WHERE I.ID_REFERENCIA_IR17 = p_NoReferencia;
  
    CURSOR c_NoReferenciaINFOTEP IS
      SELECT I.No_autorizacion
        FROM suirplus.SFC_LIQUIDACION_INFOTEP_T I
       WHERE I.ID_REFERENCIA_INFOTEP = p_NoReferencia;
  
    CURSOR c_NoReferenciaMDT IS
      SELECT I.No_autorizacion
        FROM suirplus.SFC_PLANILLA_MDT_T I
       WHERE I.ID_REFERENCIA_PLANILLA = p_NoReferencia;
  
    pNoAutorizacionTSS       SFC_FACTURAS_T.No_autorizacion%TYPE;
    pNoAutorizacionDGII      SFC_LIQUIDACION_ISR_T.No_autorizacion%TYPE;
    pNoAutorizacionDGII_IR17 SFC_LIQUIDACION_IR17_T.No_autorizacion%TYPE;
    pNoAutorizacionINFOTEP   suirplus.SFC_LIQUIDACION_INFOTEP_T.No_autorizacion%TYPE;
    pNoAutorizacionMDT       suirplus.SFC_PLANILLA_MDT_T.No_autorizacion%TYPE;
  
    vAutorizada Boolean;
  BEGIN
  
    IF p_concepto = 'SDSS' THEN
      OPEN c_NoReferenciaTSS;
      FETCH c_NoReferenciaTSS
        INTO pNoAutorizacionTSS;
      vAutorizada := (pNoAutorizacionTSS is Not Null);
      CLOSE c_NoReferenciaTSS;
    ELSIF p_concepto = 'ISR' THEN
      OPEN c_NoReferenciaDGII;
      FETCH c_NoReferenciaDGII
        INTO pNoAutorizacionDGII;
      vAutorizada := (pNoAutorizacionDGII is Not Null);
      CLOSE c_NoReferenciaDGII;
    ELSIF p_concepto = 'IR17' THEN
      OPEN c_NoReferenciaDGII_IR17;
      FETCH c_NoReferenciaDGII_IR17
        INTO pNoAutorizacionDGII_IR17;
      vAutorizada := (pNoAutorizacionDGII_IR17 is Not Null);
      CLOSE c_NoReferenciaDGII_IR17;
    ELSIF p_concepto = 'INF' THEN
      OPEN c_NoReferenciaINFOTEP;
      FETCH c_NoReferenciaINFOTEP
        INTO pNoAutorizacionINFOTEP;
      vAutorizada := (pNoAutorizacionINFOTEP is Not Null);
      CLOSE c_NoReferenciaINFOTEP;
    ELSIF p_concepto = 'MDT' THEN
      OPEN c_NoReferenciaMDT;
      FETCH c_NoReferenciaMDT
        INTO pNoAutorizacionMDT;
      vAutorizada := (pNoAutorizacionMDT is Not Null);
      CLOSE c_NoReferenciaMDT;
    END IF;
  
    RETURN vAutorizada;
  END isReferenciaAutorizada;

  -- **************************************************************************************************
  -- Program:     function isExisteReferencia()
  -- Description: funcion que retorna la existencia de un No. de referencia
  -- Utilizado para consulta de liquidacion de la DGII
  -- **************************************************************************************************

  FUNCTION isExisteReferencia(p_NoReferencia IN SFC_FACTURAS_T.id_referencia%TYPE)
    RETURN BOOLEAN
  
   IS
  
    CURSOR c_NoReferencia IS
      SELECT l.id_referencia_isr
        FROM SFC_LIQUIDACION_ISR_v l
       WHERE l.id_referencia_isr = p_NoReferencia;
  
    v_NoReferencia VARCHAR2(50);
    returnvalue    BOOLEAN;
  
  BEGIN
  
    OPEN c_NoReferencia;
    FETCH c_NoReferencia
      INTO v_NoReferencia;
    returnvalue := c_NoReferencia%FOUND;
    CLOSE c_NoReferencia;
  
    RETURN(returnvalue);
  
  END isExisteReferencia;
  --********

  -- **************************************************************************************************
  -- Program:     function isExisteReferenciaStatus()
  -- Description: funcion que retorna la existencia de un No. de referencia
  -- Utilizado para consulta de liquidacion de la DGII
  -- **************************************************************************************************

  FUNCTION isExisteReferenciaStatus(p_NoReferencia IN SFC_FACTURAS_T.id_referencia%TYPE)
    RETURN BOOLEAN
  
   IS
  
    CURSOR c_NoReferencia IS
      SELECT l.id_referencia
        FROM sfc_liquidacion_dgii_v l
       WHERE l.id_referencia = p_NoReferencia
         AND l.no_autorizacion IS NOT NULL;
  
    v_NoReferencia VARCHAR2(50);
    returnvalue    BOOLEAN;
  
  BEGIN
  
    OPEN c_NoReferencia;
    FETCH c_NoReferencia
      INTO v_NoReferencia;
    returnvalue := c_NoReferencia%FOUND;
    CLOSE c_NoReferencia;
  
    RETURN(returnvalue);
  
  END isExisteReferenciaStatus;

  -- **************************************************************************************************
  -- Program:     function isExisteIdRecepcion()
  -- Description: funcion que retorna la existencia de un Id_Recepcion
  -- Utilizado para consulta de liquidacion de la DGII
  -- **************************************************************************************************

  FUNCTION isExisteIdRecepcion(p_idrecepcion IN SRE_DET_MOVIMIENTO_RECAUDO_T.id_recepcion%TYPE)
    RETURN BOOLEAN
  
   IS
  
    CURSOR c_IdRecepcion IS
      SELECT m.id_recepcion
        FROM SRE_DET_MOVIMIENTO_RECAUDO_T m
       WHERE m.id_recepcion = p_idrecepcion;
  
    v_idrecepciona VARCHAR2(50);
    returnvalue    BOOLEAN;
  
  BEGIN
  
    OPEN c_IdRecepcion;
    FETCH c_IdRecepcion
      INTO v_idrecepciona;
    returnvalue := c_IdRecepcion%FOUND;
    CLOSE c_IdRecepcion;
  
    RETURN(returnvalue);
  
  END isExisteIdRecepcion;

  -- **************************************************************************************************
  -- Program:     isReferenciaValida
  -- Description: Valida si la factura existe en las distintas tablas de factura dependiendo del concepto
  -- **************************************************************************************************
  PROCEDURE isReferenciaValida(p_referencia   IN SFC_FACTURAS_T.ID_REFERENCIA%TYPE,
                               p_rnc          IN Sre_Empleadores_t.Rnc_o_Cedula%type,
                               p_concepto     IN VARCHAR2,
                               p_resultnumber OUT VARCHAR2) IS
    v_bd_error VARCHAR(1000);
  BEGIN
  
    IF UPPER(p_concepto) = v_tt_SDSS THEN
      p_resultnumber := 0;
      For c_referencia in (Select f.id_referencia
                             From sfc_facturas_v f
                             join sre_empleadores_t e
                               on e.id_registro_patronal =
                                  f.id_registro_patronal
                            Where f.id_referencia = p_referencia
                              and e.rnc_o_cedula = p_rnc) Loop
        p_resultnumber := 1;
      End Loop;
      Return;
    END IF;
  
    IF UPPER(p_concepto) = v_tt_ISR THEN
      p_resultnumber := 0;
      For c_referencia in (Select l.id_referencia_isr
                             From sfc_liquidacion_isr_v l
                             join sre_empleadores_t e
                               on e.id_registro_patronal =
                                  l.id_registro_patronal
                            Where l.id_referencia_isr = p_referencia
                              and e.rnc_o_cedula = p_rnc) Loop
        p_resultnumber := 1;
      End Loop;
      Return;
    END IF;
  
    IF UPPER(p_concepto) = v_tt_IR17 THEN
      p_resultnumber := 0;
      For c_referencia in (Select i.id_referencia_ir17
                             From sfc_liquidacion_ir17_t i
                             join sre_empleadores_t e
                               on e.id_registro_patronal =
                                  i.id_registro_patronal
                            Where i.id_referencia_ir17 = p_referencia
                              and e.rnc_o_cedula = p_rnc) Loop
        p_resultnumber := 1;
      End Loop;
      Return;
    END IF;
  
    -- Para referencias de INFOTEP
    IF UPPER(p_concepto) = v_tt_INF THEN
      p_resultnumber := 0;
      For c_referencia in (Select i.id_referencia_infotep
                             From suirplus.sfc_liquidacion_infotep_t i
                             join sre_empleadores_t e
                               on e.id_registro_patronal =
                                  i.id_registro_patronal
                            Where i.id_referencia_infotep = p_referencia
                              and e.rnc_o_cedula = p_rnc) Loop
        p_resultnumber := 1;
      End Loop;
      Return;
    END IF;
  
    -- Para referencias de PLANILLA MDT
    IF UPPER(p_concepto) = v_tt_MDT THEN
      p_resultnumber := 0;
      For c_referencia in (Select i.id_referencia_planilla
                             From suirplus.sfc_PLANILLA_MDT_t i
                             join sre_empleadores_t e
                               on e.id_registro_patronal =
                                  i.id_registro_patronal
                            Where i.id_referencia_planilla = p_referencia
                              and e.rnc_o_cedula = p_rnc) Loop
        p_resultnumber := 1;
      End Loop;
      Return;
    END IF;
  
  EXCEPTION
  
    WHEN OTHERS THEN
      v_bd_error     := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultnumber := Seg_Retornar_Cadena_Error(-1, v_bd_error, SQLCODE);
      RETURN;
  END isReferenciaValida;

  --*****************************************************************************
  -- Procedimiento para los Campos de TSS (Mamey).
  --*****************************************************************************

  PROCEDURE Cons_Pagos(p_NoReferencia   IN SFC_FACTURAS_T.id_referencia%TYPE,
                       p_NoAutorizacion IN SFC_FACTURAS_T.no_autorizacion%TYPE,
                       p_concepto       IN VARCHAR2,
                       p_IOCursor       IN OUT t_Cursor,
                       p_resultnumber   OUT VARCHAR2) IS
    e_invalidNoReferencia EXCEPTION;
    v_bd_error VARCHAR(1000);
    c_cursor   t_cursor;
    --        v_tipostatus            VARCHAR(50);
    --        v_iderror               VARCHAR(50);
  
    --        CURSOR c_tipostatus IS SELECT mv.c_status_carga, mv.n_error_carga FROM SFC_PAGOS_MV mv WHERE mv.c_no_referencia = p_NoReferencia OR mv.c_num_autorizacion = p_NoAutorizacion;
  
  BEGIN
  
    IF (p_NoReferencia IS NULL) AND (p_NoAutorizacion IS NULL) THEN
      RAISE e_InvalidRequerimientos;
    END IF;
  
    IF (p_concepto = v_tt_SDSS) THEN
    
      IF (p_NoReferencia IS NOT NULL) THEN
      
        OPEN c_cursor FOR
          SELECT e.entidad_recaudadora_des,
                 u.nombre_usuario || ' ' || u.apellidos AS Nombres,
                 f.no_autorizacion,
                 f.fecha_autorizacion,
                 f.fecha_pago,
                 p.c_status_carga,
                 p.n_error_carga,
                 p.d_fecha_envio,
                 f.fecha_reporte_pago,
                 f.FECHA_CANCELA,
                 f.ID_REFERENCIA_ORIGEN,
                 f.FECHA_DESAUTORIZACION,
                 f.ID_USUARIO_DESAUTORIZA,
                 us.nombre_usuario || ' ' || us.apellidos AS Nombre_Desautorizo
            FROM SFC_FACTURAS_V            f,
                 SFC_ENTIDAD_RECAUDADORA_T e,
                 SEG_USUARIO_T             u,
                 SEG_USUARIO_T             us,
                 SFC_PAGOS_MV              p
           WHERE e.id_entidad_recaudadora(+) = f.id_entidad_recaudadora
             AND u.id_usuario(+) = f.id_usuario_autoriza
             AND us.id_usuario(+) = f.id_usuario_desautoriza
             AND f.id_referencia = p.c_no_referencia(+)
             AND f.id_referencia = p_NoReferencia;
      
        p_resultnumber := 0;
        p_IOCursor     := c_cursor;
        RETURN;
      
      ELSIF (p_NoAutorizacion IS NOT NULL) THEN
      
        OPEN c_cursor FOR
          SELECT e.entidad_recaudadora_des,
                 u.nombre_usuario || ' ' || u.apellidos AS Nombres,
                 f.no_autorizacion,
                 f.fecha_autorizacion,
                 f.fecha_pago,
                 p.c_status_carga,
                 p.n_error_carga,
                 p.d_fecha_envio,
                 f.fecha_reporte_pago,
                 f.FECHA_CANCELA,
                 f.ID_REFERENCIA_ORIGEN,
                 f.FECHA_DESAUTORIZACION,
                 f.ID_USUARIO_DESAUTORIZA,
                 us.nombre_usuario || ' ' || us.apellidos AS Nombre_Desautorizo
            FROM SFC_FACTURAS_V            f,
                 SFC_ENTIDAD_RECAUDADORA_T e,
                 SEG_USUARIO_T             u,
                 SEG_USUARIO_T             us,
                 SFC_PAGOS_MV              p
           WHERE e.id_entidad_recaudadora(+) = f.id_entidad_recaudadora
             AND f.id_referencia = p.c_no_referencia(+)
             AND u.id_usuario(+) = f.id_usuario_autoriza
             AND us.id_usuario(+) = f.id_usuario_desautoriza
             AND f.no_autorizacion = p_NoAutorizacion
           ORDER BY p.D_FECHA_ENVIO DESC;
      
        p_resultnumber := 0;
        p_IOCursor     := c_cursor;
        RETURN;
      END IF;
    END IF;
  
    IF (p_concepto = v_tt_ISR) THEN
      IF (p_NoReferencia IS NOT NULL) THEN
        OPEN c_cursor FOR
          SELECT e.entidad_recaudadora_des,
                 u.nombre_usuario || ' ' || u.apellidos Nombres,
                 l.no_autorizacion,
                 l.fecha_autorizacion,
                 l.fecha_pago,
                 l.fecha_reporte_pago,
                 '' AS c_status_carga,
                 '' AS n_error_carga,
                 '' AS d_fecha_envio,
                 l.fecha_cancela,
                 l.fecha_desautorizacion,
                 '' AS ID_REFERENCIA_ORIGEN,
                 us.nombre_usuario || ' ' || us.apellidos AS Nombre_Desautorizo
            FROM SFC_LIQUIDACION_ISR_v     l,
                 SFC_ENTIDAD_RECAUDADORA_T e,
                 SEG_USUARIO_T             u,
                 SEG_USUARIO_T             us
           WHERE e.id_entidad_recaudadora = l.id_entidad_recaudadora
             AND u.id_usuario(+) = l.id_usuario_autoriza
             AND us.id_usuario(+) = l.id_usuario_desautoriza
             AND l.id_referencia_isr = p_NoReferencia;
      
        p_resultnumber := 0;
        p_IOCursor     := c_cursor;
        RETURN;
      
      ELSE
        OPEN c_cursor FOR
          SELECT e.entidad_recaudadora_des,
                 u.nombre_usuario || ' ' || u.apellidos Nombres,
                 l.no_autorizacion,
                 l.fecha_autorizacion,
                 l.fecha_pago,
                 '' AS c_status_carga,
                 '' AS n_error_carga,
                 '' AS d_fecha_envio,
                 l.fecha_reporte_pago,
                 '' AS FECHA_CANCELA,
                 '' AS ID_REFERENCIA_ORIGEN,
                 '' AS FECHA_DESAUTORIZACION,
                 l.id_usuario_desautoriza,
                 us.nombre_usuario || ' ' || us.apellidos AS Nombre_Desautorizo
            FROM SFC_LIQUIDACION_ISR_v     l,
                 SFC_ENTIDAD_RECAUDADORA_T e,
                 SEG_USUARIO_T             u,
                 SEG_USUARIO_T             us
           WHERE e.id_entidad_recaudadora = l.id_entidad_recaudadora
             AND u.id_usuario(+) = l.id_usuario_autoriza
             AND us.id_usuario(+) = l.id_usuario_desautoriza
             AND l.no_autorizacion = p_NoAutorizacion;
        p_resultnumber := 0;
        p_IOCursor     := c_cursor;
        RETURN;
      END IF;
    END IF;
  
    IF (p_concepto = v_tt_IR17) THEN
      IF (p_NoReferencia IS NOT NULL) THEN
        OPEN c_cursor FOR
          SELECT e.entidad_recaudadora_des,
                 u.nombre_usuario || ' ' || u.apellidos Nombres,
                 i.no_autorizacion,
                 i.fecha_autorizacion,
                 i.fecha_pago,
                 i.fecha_reporte_pago,
                 '' AS c_status_carga,
                 '' AS n_error_carga,
                 '' AS d_fecha_envio,
                 i.fecha_cancela,
                 i.fecha_desautorizacion,
                 '' AS ID_REFERENCIA_ORIGEN,
                 us.nombre_usuario || ' ' || us.apellidos AS Nombre_Desautorizo
            FROM SFC_LIQUIDACION_IR17_T    i,
                 SFC_ENTIDAD_RECAUDADORA_T e,
                 SEG_USUARIO_T             u,
                 SEG_USUARIO_T             us
           WHERE e.id_entidad_recaudadora = I.ID_ENTIDAD_RECAUDADORA
             AND u.id_usuario(+) = I.ID_USUARIO_AUTORIZA
             AND us.id_usuario(+) = I.ID_USUARIO_DESAUTORIZA
             AND I.ID_REFERENCIA_IR17 = p_NoReferencia;
      
        p_resultnumber := 0;
        p_IOCursor     := c_cursor;
        RETURN;
      
      ELSE
        OPEN c_cursor FOR
          SELECT e.entidad_recaudadora_des,
                 u.nombre_usuario || ' ' || u.apellidos Nombres,
                 i.no_autorizacion,
                 i.fecha_autorizacion,
                 i.fecha_pago,
                 '' AS c_status_carga,
                 '' AS n_error_carga,
                 '' AS d_fecha_envio,
                 i.fecha_reporte_pago,
                 '' AS FECHA_CANCELA,
                 '' AS ID_REFERENCIA_ORIGEN,
                 '' AS FECHA_DESAUTORIZACION,
                 i.id_usuario_desautoriza,
                 us.nombre_usuario || ' ' || us.apellidos AS Nombre_Desautorizo
            FROM SFC_LIQUIDACION_IR17_T    i,
                 SFC_ENTIDAD_RECAUDADORA_T e,
                 SEG_USUARIO_T             u,
                 SEG_USUARIO_T             us
           WHERE e.id_entidad_recaudadora = I.ID_ENTIDAD_RECAUDADORA
             AND u.id_usuario(+) = I.ID_USUARIO_AUTORIZA
             AND us.id_usuario(+) = I.ID_USUARIO_DESAUTORIZA
             AND I.No_Autorizacion = p_NoAutorizacion;
      
        p_resultnumber := 0;
        p_IOCursor     := c_cursor;
        RETURN;
      END IF;
    END IF;
  
    -- Para consulta de pago de INFOTEP
    IF (p_concepto = v_tt_INF) THEN
      IF (p_NoReferencia IS NOT NULL) THEN
        OPEN c_cursor FOR
          SELECT e.entidad_recaudadora_des,
                 u.nombre_usuario || ' ' || u.apellidos Nombres,
                 i.no_autorizacion,
                 i.fecha_autorizacion,
                 i.fecha_pago,
                 i.fecha_reporte_pago,
                 '' AS c_status_carga,
                 '' AS n_error_carga,
                 '' AS d_fecha_envio,
                 i.fecha_cancela,
                 i.fecha_desautorizacion,
                 '' AS ID_REFERENCIA_ORIGEN,
                 us.nombre_usuario || ' ' || us.apellidos AS Nombre_Desautorizo
            FROM suirplus.SFC_LIQUIDACION_INFOTEP_T i,
                 SFC_ENTIDAD_RECAUDADORA_T          e,
                 SEG_USUARIO_T                      u,
                 SEG_USUARIO_T                      us
           WHERE e.id_entidad_recaudadora = I.ID_ENTIDAD_RECAUDADORA
             AND u.id_usuario(+) = I.ID_USUARIO_AUTORIZA
             AND us.id_usuario(+) = I.ID_USUARIO_DESAUTORIZA
             AND I.ID_REFERENCIA_INFOTEP = p_NoReferencia;
      
        p_resultnumber := 0;
        p_IOCursor     := c_cursor;
        RETURN;
      END IF;
    END IF;
  
    -- Para consulta de pago de PLANILLA MDT
    IF (p_concepto = v_tt_MDT) THEN
      IF (p_NoReferencia IS NOT NULL) THEN
        OPEN c_cursor FOR
          SELECT e.entidad_recaudadora_des,
                 u.nombre_usuario || ' ' || u.apellidos Nombres,
                 i.no_autorizacion,
                 i.fecha_autorizacion,
                 i.fecha_pago,
                 i.fecha_reporte_pago,
                 '' AS c_status_carga,
                 '' AS n_error_carga,
                 '' AS d_fecha_envio,
                 i.fecha_cancela,
                 i.fecha_desautorizacion,
                 '' AS ID_REFERENCIA_ORIGEN,
                 us.nombre_usuario || ' ' || us.apellidos AS Nombre_Desautorizo
            FROM suirplus.sfc_planilla_mdt_t i,
                 SFC_ENTIDAD_RECAUDADORA_T   e,
                 SEG_USUARIO_T               u,
                 SEG_USUARIO_T               us
           WHERE e.id_entidad_recaudadora = I.ID_ENTIDAD_RECAUDADORA
             AND u.id_usuario(+) = I.ID_USUARIO_AUTORIZA
             AND us.id_usuario(+) = I.ID_USUARIO_DESAUTORIZA
             AND I.ID_REFERENCIA_PLANILLA = p_NoReferencia;
      
        p_resultnumber := 0;
        p_IOCursor     := c_cursor;
        RETURN;
      ELSE
        OPEN c_cursor FOR
          SELECT e.entidad_recaudadora_des,
                 u.nombre_usuario || ' ' || u.apellidos Nombres,
                 i.no_autorizacion,
                 i.fecha_autorizacion,
                 i.fecha_pago,
                 '' AS c_status_carga,
                 '' AS n_error_carga,
                 '' AS d_fecha_envio,
                 i.fecha_reporte_pago,
                 '' AS FECHA_CANCELA,
                 '' AS ID_REFERENCIA_ORIGEN,
                 '' AS FECHA_DESAUTORIZACION,
                 i.id_usuario_desautoriza,
                 us.nombre_usuario || ' ' || us.apellidos AS Nombre_Desautorizo
            FROM suirplus.sfc_planilla_mdt_t i,
                 SFC_ENTIDAD_RECAUDADORA_T   e,
                 SEG_USUARIO_T               u,
                 SEG_USUARIO_T               us
           WHERE e.id_entidad_recaudadora = I.ID_ENTIDAD_RECAUDADORA
             AND u.id_usuario(+) = I.ID_USUARIO_AUTORIZA
             AND us.id_usuario(+) = I.ID_USUARIO_DESAUTORIZA
             AND I.No_Autorizacion = p_NoAutorizacion;
      
        p_resultnumber := 0;
        p_IOCursor     := c_cursor;
        RETURN;
      END IF;
    END IF;
  
  EXCEPTION
  
    WHEN e_InvalidRequerimientos THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(660, NULL, NULL);
      RETURN;
    WHEN e_InvalidTSSDGII THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(661, NULL, NULL);
      RETURN;
    WHEN OTHERS THEN
      v_bd_error     := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultNumber := Seg_Retornar_Cadena_Error(-1, v_bd_error, SQLCODE);
      RETURN;
    
  END;
  --******************************************************************************************
  -- Compendio de Envios
  --******************************************************************************************
  PROCEDURE Cons_Envios(p_NoReferencia IN SFC_FACTURAS_T.id_referencia%TYPE,
                        p_IOCursor     IN OUT t_Cursor,
                        p_resultnumber OUT VARCHAR2) IS
    e_invalidNoReferencia EXCEPTION;
    v_bd_error VARCHAR(1000);
    c_cursor   t_cursor;
  
  BEGIN
  
    IF NOT Sfc_Factura_Pkg.isExisteNoReferencia('SDSS', p_NoReferencia) THEN
      RAISE e_invalidNoReferencia;
    END IF;
  
    OPEN c_cursor FOR
      SELECT p.c_no_referencia,
             p.d_fecha_envio,
             p.c_status_carga,
             p.n_error_carga
        FROM SFC_PAGOS_MV p
       WHERE p.c_no_referencia = p_NoReferencia
       ORDER BY p.d_fecha_envio DESC;
  
    p_resultnumber := 0;
    p_IOCursor     := c_cursor;
    RETURN;
  
  EXCEPTION
    WHEN e_invalidNoReferencia THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(16, NULL, NULL);
      RETURN;
    WHEN OTHERS THEN
      v_bd_error     := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultNumber := Seg_Retornar_Cadena_Error(-1, v_bd_error, SQLCODE);
      RETURN;
    
  END;
  -- *****************************************************************************************
  -- Consulta Analisis de Recaudo.
  -- *****************************************************************************************
  PROCEDURE Cons_AnalisisRecaudoRef(p_NoReferencia IN SRE_TMP_MOVIMIENTO_RECAUDO_T.id_referencia_isr%TYPE,
                                    p_IOCursor     IN OUT t_Cursor,
                                    p_resultnumber OUT VARCHAR2) IS
    e_invalidNoReferencia EXCEPTION;
    v_bd_error VARCHAR(1000);
    c_cursor   t_cursor;
    --        v_noreferencia          VARCHAR(50);
  
  BEGIN
  
    OPEN c_cursor FOR
      SELECT mr.id_recepcion,
             mr.secuencia_mov_recaudo,
             mr.id_referencia_isr,
             mr.no_autorizacion,
             mr.monto,
             mr.fecha_pago,
             mr.lote_aclaracion,
             mr.secuencia_aclaracion,
             mr.status,
             mr.fecha_aclaracion,
             mr.id_referencia_aclaracion,
             mr.no_autorizacion_aclaracion,
             mr.monto_aclaracion,
             a.fecha_carga,
             e.entidad_recaudadora_des,
             se.error_des,
             decode(a.id_tipo_movimiento,
                    'EP',
                    'Pagos',
                    'AC',
                    'Aclaraciones') as tipo_envio
        FROM SRE_TMP_MOVIMIENTO_RECAUDO_T mr,
             sre_archivos_t               a,
             SFC_ENTIDAD_RECAUDADORA_T    e,
             SEG_ERROR_T                  se
       WHERE mr.id_recepcion = a.id_recepcion
         AND a.id_entidad_recaudadora = e.id_entidad_recaudadora
         AND mr.id_error = se.id_error(+)
         AND (mr.id_referencia_isr = p_NoReferencia OR
             mr.id_referencia_aclaracion = p_NoReferencia)
       order by a.fecha_carga asc;
  
    p_resultnumber := 0;
    p_IOCursor     := c_cursor;
    RETURN;
  
  EXCEPTION
    WHEN e_invalidNoReferencia THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(16, NULL, NULL);
      RETURN;
    WHEN OTHERS THEN
      v_bd_error     := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultNumber := Seg_Retornar_Cadena_Error(-1, v_bd_error, SQLCODE);
      RETURN;
    
  END;
  --***************************************************************************************
  --         p_NoAutorizion    IN sre_tmp_movimiento_recaudo_t.no_autorizacion%type,
  --***************************************************************************************
  PROCEDURE Cons_AnalisisRecaudoAut(p_NoAutorizacion IN SRE_TMP_MOVIMIENTO_RECAUDO_T.no_autorizacion%TYPE,
                                    p_IOCursor       IN OUT t_Cursor,
                                    p_resultnumber   OUT VARCHAR2) IS
    e_invalidNoReferencia EXCEPTION;
    e_invalidnss EXCEPTION;
  
    v_bd_error     VARCHAR(1000);
    c_cursor       t_cursor;
    v_noreferencia VARCHAR(50);
    CURSOR c_noreferencia IS
      SELECT mr.id_referencia_isr
        FROM SRE_TMP_MOVIMIENTO_RECAUDO_T mr
       WHERE mr.no_autorizacion_aclaracion = p_NoAutorizacion;
  
  BEGIN
  
    OPEN c_noreferencia;
  
    FETCH c_noreferencia
      INTO v_noreferencia;
    IF NOT c_noreferencia%FOUND THEN
      CLOSE c_noreferencia;
    ELSE
      CLOSE c_noreferencia;
    END IF;
  
    OPEN c_cursor FOR
      SELECT mr.id_recepcion,
             mr.secuencia_mov_recaudo,
             mr.id_referencia_isr,
             mr.no_autorizacion,
             mr.monto,
             mr.fecha_pago,
             NVL(mr.lote_aclaracion, '0') AS lote_aclaracion,
             NVL(mr.secuencia_aclaracion, '0') AS secuencia_aclaracion,
             NVL(mr.status, '-') AS status,
             NVL(mr.fecha_aclaracion, '-') AS fecha_aclaracion,
             mr.id_referencia_aclaracion,
             mr.no_autorizacion_aclaracion,
             NVL(mr.monto_aclaracion, '0') AS monto_aclaracion,
             a.fecha_carga,
             e.entidad_recaudadora_des,
             se.error_des,
             decode(a.id_tipo_movimiento,
                    'EP',
                    'Pagos',
                    'AC',
                    'Aclaraciones') as tipo_envio
        FROM SRE_TMP_MOVIMIENTO_RECAUDO_T mr,
             sre_archivos_t               a,
             SFC_ENTIDAD_RECAUDADORA_T    e,
             SEG_ERROR_T                  se
       WHERE mr.id_recepcion = a.id_recepcion
         AND a.id_entidad_recaudadora = e.id_entidad_recaudadora
         AND mr.id_error = se.id_error(+)
         AND (mr.no_autorizacion = p_NoAutorizacion OR
             mr.no_autorizacion_aclaracion = p_NoAutorizacion);
  
    p_resultnumber := 0;
    p_IOCursor     := c_cursor;
    RETURN;
  
  EXCEPTION
    WHEN e_invalidNoReferencia THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(16, NULL, NULL);
      RETURN;
    WHEN OTHERS THEN
      v_bd_error     := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultNumber := Seg_Retornar_Cadena_Error(-1, v_bd_error, SQLCODE);
      RETURN;
    
  END;
  --************************************************************************************************
  -- Procedimiento para obtener el numero de referencia a partir del numero de autorizacion.
  --************************************************************************************************
  PROCEDURE Get_Numeroreferencia(p_NoAutorizacion IN SRE_TMP_MOVIMIENTO_RECAUDO_T.no_autorizacion%TYPE,
                                 p_IOCursor       IN OUT t_Cursor,
                                 p_resultnumber   OUT VARCHAR2) IS
    --        v_noreferencia          VARCHAR(50);
    c_cursor t_cursor;
    --        CURSOR c_noreferencia IS SELECT mr.id_referencia_isr FROM SRE_TMP_MOVIMIENTO_RECAUDO_T mr WHERE mr.no_autorizacion = p_NoAutorizacion ;
  
  BEGIN
  
    OPEN c_cursor FOR
      SELECT mr.id_referencia_isr AS referencia
        FROM SRE_TMP_MOVIMIENTO_RECAUDO_T mr
       WHERE mr.no_autorizacion = p_NoAutorizacion;
    p_resultnumber := 0;
    p_IOCursor     := c_cursor;
    RETURN;
  
  END;
  --**********************************************************
  --**********************************************************
  --  Para especificar el oficio y motivo de las facturas canceladas.

  PROCEDURE Cons_OficiosVencidas(p_NoReferencia   IN SFC_FACTURAS_T.id_referencia%TYPE,
                                 p_NoAutorizacion IN SFC_FACTURAS_T.no_autorizacion%TYPE,
                                 p_concepto       VARCHAR2,
                                 p_IOCursor       IN OUT t_Cursor,
                                 p_resultnumber   OUT VARCHAR2) IS
    e_invalidNoReferencia EXCEPTION;
    v_bd_error VARCHAR(1000);
    c_cursor   t_cursor;
    --        v_tipostatus            VARCHAR(50);
    --        v_iderror               VARCHAR(50);
    v_noreferencia VARCHAR(50);
  
    --        CURSOR c_tipostatus IS SELECT mv.c_status_carga, mv.n_error_carga FROM SFC_PAGOS_MV mv WHERE mv.c_no_referencia = p_NoReferencia OR mv.c_num_autorizacion = p_NoAutorizacion;
    CURSOR c_noreferencia IS
      SELECT mr.id_referencia_isr
        FROM SRE_TMP_MOVIMIENTO_RECAUDO_T mr
       WHERE mr.no_autorizacion_aclaracion = p_NoAutorizacion;
  
  BEGIN
  
    OPEN c_noreferencia;
  
    FETCH c_noreferencia
      INTO v_noreferencia;
    IF NOT c_noreferencia%FOUND THEN
      CLOSE c_noreferencia;
    ELSE
      CLOSE c_noreferencia;
    END IF;
  
    IF (p_NoReferencia IS NULL) AND (p_NoAutorizacion IS NULL) THEN
      RAISE e_InvalidRequerimientos;
    END IF;
  
    IF (p_NoReferencia IS NOT NULL) THEN
    
      OPEN c_cursor FOR
      /*                      SELECT m.texto_motivo, o.id_oficio FROM OFC_OFICIOS_T o, OFC_MOTIVOS_T m
                                                                                                                WHERE o.id_motivo = m.id_motivo AND o.id_accion = m.id_accion
                                                                                                                AND o.id_oficio IN
                                                                                                                (SELECT DO.id_oficio FROM OFC_DET_OFICIOS_T DO, SFC_FACTURAS_V f
                                                                                                                 WHERE DO.id_referencia = p_NoReferencia
                                                                                                                 AND   DO.id_referencia = f.id_referencia AND f.status = 'CA');*/
      
        SELECT m.texto_motivo, o.id_oficio
          FROM OFC_OFICIOS_T o, OFC_MOTIVOS_T m
         WHERE o.id_motivo = m.id_motivo
           AND o.id_accion = m.id_accion
           AND o.id_oficio IN
              
               (SELECT f.id_oficio
                  FROM SFC_FACTURAS_T f
                 WHERE f.id_referencia = p_NoReferencia
                   AND f.status IN ('CA', 'RE'));
    
      p_resultnumber := 0;
      p_IOCursor     := c_cursor;
      RETURN;
    
    ELSIF (p_NoAutorizacion IS NOT NULL) THEN
    
      OPEN c_cursor FOR
      /*                     SELECT m.texto_motivo, o.id_oficio FROM OFC_OFICIOS_T o, OFC_MOTIVOS_T m
                                                                                                               WHERE o.id_motivo = m.id_motivo AND o.id_accion = m.id_accion AND o.id_oficio IN
                                                                                                               (SELECT DO.id_oficio FROM OFC_DET_OFICIOS_T DO, SFC_FACTURAS_V f WHERE DO.id_referencia = v_noreferencia AND
                                                                                                                DO.id_referencia = f.id_referencia AND f.status = 'CA');*/
      
        SELECT m.texto_motivo, o.id_oficio
          FROM OFC_OFICIOS_T o, OFC_MOTIVOS_T m
         WHERE o.id_motivo = m.id_motivo
           AND o.id_accion = m.id_accion
           AND o.id_oficio IN
               (SELECT f.id_oficio
                  FROM SFC_FACTURAS_T f
                 WHERE f.id_referencia = v_noreferencia
                   AND f.status IN ('CA', 'RE'));
    
      p_resultnumber := 0;
      p_IOCursor     := c_cursor;
      RETURN;
    
    END IF;
  
    p_resultnumber := 0;
    p_IOCursor     := c_cursor;
    RETURN;
  
  EXCEPTION
    WHEN OTHERS THEN
      v_bd_error     := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultNumber := Seg_Retornar_Cadena_Error(-1, v_bd_error, SQLCODE);
      RETURN;
    
  END;

  -- **************************************************************************************************
  -- Program:     Liquidacion_NoReferencia
  -- Description: Utilizado para consulta de liquidacion de la DGII
  -- **************************************************************************************************

  PROCEDURE Liquidacion_NoReferencia(p_NoReferencia IN SRE_DET_MOVIMIENTO_RECAUDO_T.id_referencia_isr%TYPE,
                                     p_resultnumber OUT VARCHAR2,
                                     p_iocursor     IN OUT t_cursor)
  
   IS
    e_invalidnoreferencia EXCEPTION;
    e_invalidstatus EXCEPTION;
    v_bd_error VARCHAR(1000);
    c_cursor   t_cursor;
  
  BEGIN
  
    IF NOT Sfc_Factura_Pkg.isExisteReferencia(p_noreferencia) THEN
      RAISE e_invalidnoreferencia;
    END IF;
  
    IF NOT Sfc_Factura_Pkg.isExisteReferenciaStatus(p_noreferencia) THEN
      RAISE e_invalidstatus;
    END IF;
  
    OPEN c_cursor FOR
      SELECT e.entidad_recaudadora_des banco,
             a.id_recepcion,
             a.fecha_carga fecha_envio,
             DECODE(a.id_tipo_movimiento, 'EP', 'Pago', 'Aclaracion') Tipo,
             SUM(d.monto) total_aceptado
        FROM SRE_ARCHIVOS_T               a,
             SFC_ENTIDAD_RECAUDADORA_T    e,
             SRE_DET_MOVIMIENTO_RECAUDO_T d
       WHERE a.id_recepcion = d.id_recepcion
         AND e.id_entidad_recaudadora = a.id_entidad_recaudadora
         AND d.status = 'OK'
         AND d.id_referencia_isr = p_NoReferencia
       GROUP BY e.entidad_recaudadora_des,
                a.id_recepcion,
                a.fecha_carga,
                a.id_tipo_movimiento;
  
    p_resultnumber := 0;
    p_IOCursor     := c_cursor;
  
  EXCEPTION
  
    WHEN e_invalidnoreferencia THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(16, NULL, NULL);
      RETURN;
    
    WHEN e_invalidstatus THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(60, NULL, NULL);
      RETURN;
    
    WHEN OTHERS THEN
      v_bd_error     := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultnumber := Seg_Retornar_Cadena_Error(-1, v_bd_error, SQLCODE);
      RETURN;
    
  END;

  -- **************************************************************************************************
  -- Program:     Liquidacion_NoEnvio
  -- Description: Utilizado para consulta de liquidacion de la DGII
  -- **************************************************************************************************

  PROCEDURE Liquidacion_NoEnvio(p_idrecepcion  IN SRE_DET_MOVIMIENTO_RECAUDO_T.id_recepcion%TYPE,
                                p_resultnumber OUT VARCHAR2,
                                p_iocursor     IN OUT t_cursor)
  
   IS
  
    e_invalidrerecepcion EXCEPTION;
    v_bd_error VARCHAR(1000);
    c_cursor   t_cursor;
  
  BEGIN
  
    IF NOT Sfc_Factura_Pkg.isExisteIdRecepcion(p_idrecepcion) THEN
      RAISE e_invalidrerecepcion;
    END IF;
  
    OPEN c_cursor FOR
      SELECT d.id_referencia_isr Referencia,
             e.rnc_o_cedula RNC,
             d.no_autorizacion Autorizacion,
             TRUNC(l.fecha_pago),
             d.monto
        FROM SRE_DET_MOVIMIENTO_RECAUDO_T d,
             SFC_LIQUIDACION_ISR_v        l,
             SRE_EMPLEADORES_T            e
       WHERE d.id_referencia_isr = l.id_referencia_isr
         AND l.id_registro_patronal = e.id_registro_patronal
         AND d.status = 'OK'
         AND d.id_recepcion = p_idrecepcion;
  
    p_IOCursor     := c_cursor;
    p_resultnumber := 0;
  
    IF c_cursor%rowcount IS NULL THEN
    
      OPEN c_cursor FOR
        SELECT d.id_referencia_isr Referencia,
               e.rnc_o_cedula RNC,
               d.no_autorizacion Autorizacion,
               TRUNC(i.fecha_pago),
               d.monto
          FROM SRE_DET_MOVIMIENTO_RECAUDO_T d,
               SFC_LIQUIDACION_IR17_T       i,
               SRE_EMPLEADORES_T            e
         WHERE d.id_referencia_isr = i.id_referencia_ir17
           AND i.id_registro_patronal = e.id_registro_patronal
           AND d.status = 'OK'
           AND d.id_recepcion = p_idrecepcion;
    
      p_IOCursor     := c_cursor;
      p_resultnumber := 0;
    
    END IF;
  
  EXCEPTION
  
    WHEN e_invalidrerecepcion THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(57, NULL, NULL);
      RETURN;
    
    WHEN OTHERS THEN
      v_bd_error     := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultnumber := Seg_Retornar_Cadena_Error(-1, v_bd_error, SQLCODE);
      RETURN;
    
  END;

  -- **************************************************************************************************
  -- Program:     Get_facturas_srl
  -- Description: utilizado para consultar facturas de idss
  -- **************************************************************************************************

  PROCEDURE Get_facturas_srl(p_rnc          IN SRE_EMPLEADORES_T.rnc_o_cedula%TYPE,
                             p_periodo      IN SFC_FACTURAS_T.periodo_factura%TYPE,
                             p_resultnumber OUT VARCHAR2,
                             p_iocursor     IN OUT t_cursor)
  
   IS
  
    e_rnc_cedula EXCEPTION;
    v_bd_error VARCHAR(1000);
    c_cursor   t_cursor;
  
  BEGIN
  
    IF NOT Sre_Empleadores_Pkg.isRncOCedulaValida(p_rnc) THEN
      RAISE e_rnc_cedula;
    END IF;
  
    OPEN c_cursor FOR
      SELECT f.id_referencia,
             f.total_aporte_srl,
             f.total_interes_srl,
             f.total_recargo_srl,
             f.total_proporcion_arl_srl,
             f.total_operacion_sisalril_srl,
             to_char(f.fecha_pago, 'DD/MM/YYYY') fecha_pago
        FROM SFC_FACTURAS_V f, SRE_EMPLEADORES_T e
       WHERE f.id_registro_patronal = e.id_registro_patronal
         AND f.status = 'PA'
         AND e.rnc_o_cedula = p_rnc
         AND f.periodo_factura = p_periodo
       GROUP BY f.id_referencia,
                f.total_aporte_srl,
                f.total_interes_srl,
                f.total_recargo_srl,
                f.total_proporcion_arl_srl,
                f.total_operacion_sisalril_srl,
                f.fecha_pago;
  
    p_resultnumber := 0;
    p_IOCursor     := c_cursor;
  
  EXCEPTION
  
    WHEN e_rnc_cedula THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(150, NULL, NULL);
      RETURN;
    
    WHEN OTHERS THEN
      v_bd_error     := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultnumber := Seg_Retornar_Cadena_Error(-1, v_bd_error, SQLCODE);
      RETURN;
    
  END;

  --*****************

  -- **************************************************************************************************
  -- Program:     Aut_Referencia
  -- Description:
  --
  -- **************************************************************************************************

  PROCEDURE Esta_En_FechaPago(p_concepto     IN VARCHAR2,
                              p_resultnumber OUT VARCHAR2)
  
   IS
  
    v_bd_error VARCHAR(1000);
  
    e_NoHabilParaPagar EXCEPTION;
    v_permiso1 NUMBER;
    v_permiso2 NUMBER;
    --        v_RegPatronal                NUMBER;
    --        v_PermitirPago               VARCHAR(2);
  
    cursor c_permiso1 is
      select 1
        from seg_rel_permiso_roles_t t
       where t.id_role = 59
         and t.id_permiso = '132';
    cursor c_permiso2 is
      select 2
        from seg_rel_permiso_roles_t t
       where t.id_role = 59
         and t.id_permiso = '48';
  
  BEGIN
    IF p_concepto in ('ISR', 'IR17') THEN
    
      -- En caso de que sea una Liquidacion de la DGII
      IF p_concepto = v_tt_ISR THEN
        open c_permiso1;
        fetch c_permiso1
          into v_permiso1;
        close c_permiso1;
        open c_permiso2;
        fetch c_permiso2
          into v_permiso2;
        close c_permiso2;
      
        if (v_permiso2 is not null) then
          p_resultnumber := '1';
        else
          p_resultnumber := '0';
        
        end if;
      END IF;
    
      --********
      -- En caso de que sea una Liquidacion de la DGII_IR17
      IF p_concepto = v_tt_IR17 THEN
        open c_permiso1;
        fetch c_permiso1
          into v_permiso1;
        close c_permiso1;
        open c_permiso2;
        fetch c_permiso2
          into v_permiso2;
        close c_permiso2;
      
        if (v_permiso1 is not null) then
          p_resultnumber := '1';
        else
          p_resultnumber := '0';
        
        end if;
      end if;
    else
      p_resultnumber := 'Entidad Invalida';
    end if;
  EXCEPTION
  
    WHEN OTHERS THEN
      v_bd_error     := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultnumber := Seg_Retornar_Cadena_Error(-1, v_bd_error, SQLCODE);
      RETURN;
    
  END;

  -- **************************************************************************************************
  -- Description: Utilizada desde el paquete e certificaciones para buscar si un empleador tiene
  --              Facturas vencidas y pagadas
  -- **************************************************************************************************
  Function TieneFactVencidasPagadas(p_registro_patronal in varchar2)
    return char is
    resultado char(1);
  Begin
    resultado := 'N';
    For c_fact in (select count(id_referencia) total
                     from suirplus.sfc_facturas_v v
                    where v.ID_REGISTRO_PATRONAL = p_registro_patronal
                      and v.status in ('VE', 'PA')) Loop
      If c_fact.total > 0 then
        resultado := 'S';
      End if;
    End loop;
    return resultado;
  End TieneFactVencidasPagadas;

  -- **************************************************************************************************
  -- Program:     Procedimiento
  -- Description: funcion que retorna si la referencia esta o no autorizada, 0 = autorizada, 1 = no autorizada
  -- **************************************************************************************************
  PROCEDURE isReferenciaAutorizada(p_concepto     VARCHAR2,
                                   p_NoReferencia IN SFC_FACTURAS_T.id_referencia%TYPE,
                                   p_ResultNumber out number) IS
    CURSOR c_NoReferenciaTSS IS
      SELECT f.No_autorizacion, id_usuario_desautoriza
        FROM SFC_FACTURAS_v f
       WHERE f.id_referencia = p_NoReferencia;
  
    CURSOR c_NoReferenciaDGII IS
      SELECT l.No_autorizacion, id_usuario_desautoriza
        FROM SFC_LIQUIDACION_ISR_v l
       WHERE l.id_referencia_isr = p_NoReferencia;
  
    CURSOR c_NoReferenciaDGII_IR17 IS
      SELECT I.No_autorizacion, id_usuario_desautoriza
        FROM SFC_LIQUIDACION_IR17_T I
       WHERE I.ID_REFERENCIA_IR17 = p_NoReferencia;
  
    CURSOR c_NoReferenciaINFOTEP IS
      SELECT I.No_autorizacion, id_usuario_desautoriza
        FROM suirplus.SFC_LIQUIDACION_INFOTEP_T I
       WHERE I.ID_REFERENCIA_INFOTEP = p_NoReferencia;
  
    CURSOR c_NoReferenciaMDT IS
      SELECT I.No_autorizacion, id_usuario_desautoriza
        FROM suirplus.sfc_planilla_mdt_t I
       WHERE I.ID_REFERENCIA_PLANILLA = p_NoReferencia;
  
    pNoAutorizacionTSS           SFC_FACTURAS_T.No_autorizacion%TYPE;
    pUsuarioDesautorizaTSS       SFC_FACTURAS_T.Id_usuario_desautoriza%TYPE;
    pNoAutorizacionDGII          SFC_LIQUIDACION_ISR_T.No_autorizacion%TYPE;
    pUsuarioDesautorizaDGII      SFC_LIQUIDACION_ISR_T.Id_usuario_desautoriza%TYPE;
    pNoAutorizacionDGII_IR17     SFC_LIQUIDACION_IR17_T.No_autorizacion%TYPE;
    pUsuarioDesautorizaDGII_IR17 SFC_LIQUIDACION_IR17_T.Id_usuario_desautoriza%TYPE;
    pNoAutorizacionINFOTEP       suirplus.SFC_LIQUIDACION_INFOTEP_T.No_autorizacion%TYPE;
    pUsuarioDesautorizaINFOTEP   suirplus.SFC_LIQUIDACION_INFOTEP_T.Id_usuario_desautoriza%TYPE;
    pNoAutorizacionMDT           suirplus.sfc_planilla_mdt_t.No_autorizacion%TYPE;
    pUsuarioDesautorizaMDT       suirplus.SFC_PLANILLA_MDT_t.Id_usuario_desautoriza%TYPE;
  BEGIN
    p_ResultNumber := 1;
  
    IF p_concepto = 'SDSS' THEN
      OPEN c_NoReferenciaTSS;
      FETCH c_NoReferenciaTSS
        INTO pNoAutorizacionTSS, pUsuarioDesautorizaTSS;
      If (pNoAutorizacionTSS is Not Null) or
         (pUsuarioDesautorizaTSS is not null) then
        p_ResultNumber := 0;
      End if;
      CLOSE c_NoReferenciaTSS;
    ELSIF p_concepto = 'ISR' THEN
      OPEN c_NoReferenciaDGII;
      FETCH c_NoReferenciaDGII
        INTO pNoAutorizacionDGII, pUsuarioDesautorizaDGII;
      If (pNoAutorizacionDGII is Not Null) or
         (pUsuarioDesautorizaDGII is not null) then
        p_ResultNumber := 0;
      End if;
      CLOSE c_NoReferenciaDGII;
    ELSIF p_concepto = 'IR17' THEN
      OPEN c_NoReferenciaDGII_IR17;
      FETCH c_NoReferenciaDGII_IR17
        INTO pNoAutorizacionDGII_IR17, pUsuarioDesautorizaDGII_IR17;
      If (pNoAutorizacionDGII_IR17 is Not Null) or
         (pUsuarioDesautorizaDGII_IR17 is not null) then
        p_ResultNumber := 0;
      End if;
      CLOSE c_NoReferenciaDGII_IR17;
    ELSIF p_concepto = 'INF' THEN
      OPEN c_NoReferenciaINFOTEP;
      FETCH c_NoReferenciaINFOTEP
        INTO pNoAutorizacionINFOTEP, pUsuarioDesautorizaINFOTEP;
      If (pNoAutorizacionINFOTEP is Not Null) or
         (pUsuarioDesautorizaINFOTEP is not null) then
        p_ResultNumber := 0;
      End if;
    ELSIF p_concepto = v_tt_MDT THEN
      OPEN c_NoReferenciaMDT;
      FETCH c_NoReferenciaMDT
        INTO pNoAutorizacionMDT, pUsuarioDesautorizaMDT;
      If (pNoAutorizacionMDT is Not Null) or
         (pUsuarioDesautorizaMDT is not null) then
        p_ResultNumber := 0;
      End if;
    END IF;
  
  END isReferenciaAutorizada;

  Procedure get_ResumenFactura(p_IdReferencia in sfc_facturas_t.id_referencia%type,
                               p_IOCursor     out t_Cursor,
                               p_Resultnumber out varchar2) is
    c_cursor   t_cursor;
    v_bd_error VARCHAR(1000);
  Begin
    OPEN c_cursor FOR
      SELECT f.id_referencia id_referencia,
             f.id_nomina as id_nomina,
             Srp_Pkg.ProperCase(n.nomina_des) nomina_des,
            -- DECODE(f.tipo_nomina, 'N', 'NOR', 'P', 'PEN', 'D', 'DIS') tipo_nomina,
             c.descripcion tipo_nomina, 
             Srp_Pkg.FORMATEAPERIODO(f.periodo_factura) periodo_factura,
             f.total_general_factura total_general,
             e.razon_social,
             f.FECHA_EMISION fecha_emision,
             f.FECHA_PAGO,
             Srp_Pkg.DESCESTATUSFactura(f.STATUS) STATUS,
             f.TOTAL_APORTE_EMPLEADOR_SVDS,
             f.TOTAL_APORTE_AFILIADOS_SVDS,
             f.TOTAL_APORTE_EMPLEADOR_SFS,
             f.TOTAL_APORTE_AFILIADOS_SFS,
             f.TOTAL_APORTE_VOLUNTARIO,
             f.TOTAL_APORTE_SRL,
             f.TOTAL_RECARGOS_FACTURA,
             f.TOTAL_INTERES_FACTURA,
             f.TOTAL_GENERAL_FACTURA,
             'Detalle Factura' AS detalles
        FROM sfc_facturas_v f, SRE_EMPLEADORES_T e, SRE_NOMINAS_T n, sfc_tipo_nominas_t c
       WHERE f.id_referencia = P_idReferencia
         AND e.id_registro_patronal = f.id_registro_patronal
         AND n.id_nomina = f.id_nomina
         AND n.id_registro_patronal = f.id_registro_patronal
         AND c.id_tipo_nomina =  f.tipo_nomina;
  
    p_IOCursor     := c_cursor;
    p_resultnumber := 0;
  
  EXCEPTION
  
    WHEN OTHERS THEN
      v_bd_error     := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultnumber := Seg_Retornar_Cadena_Error(-1, v_bd_error, SQLCODE);
      RETURN;
    
  End get_ResumenFactura;

  --**********************************************************************************
  PROCEDURE ConsPage_Detalle_v2(p_NoReferencia IN SFC_FACTURAS_T.id_referencia%TYPE,
                                p_concepto     IN VARCHAR2,
                                p_pagenum      in number,
                                p_pagesize     in number,
                                p_IOCursor     IN OUT t_Cursor,
                                p_resultnumber OUT VARCHAR2) IS
    e_invalidNoReferencia EXCEPTION;
    v_bd_error         VARCHAR(1000);
    v_statusReferencia varchar(2);
    c_cursor           t_cursor;
    vDesde             integer := (p_pagesize * (p_pagenum - 1)) + 1;
    vHasta             integer := p_pagesize * p_pagenum;
  BEGIN
  
    IF NOT Sfc_Factura_Pkg.isExisteNoReferencia(p_concepto, p_NoReferencia) THEN
      RAISE e_invalidNoReferencia;
    END IF;
  
    IF p_concepto = v_tt_SDSS THEN
      --buscamos el estatus de la referencia consultada para saber de donde sacar la data
      if p_NoReferencia is not null then
        begin
          select t.status
            into v_statusReferencia
            from sfc_facturas_t t
           where t.id_referencia = p_NoReferencia;
        Exception
          When No_Data_Found Then
            p_resultnumber := 'Error al consultar la referencia=' ||
                              p_NoReferencia;
            Return;
        End;
      end if;
    
      if (v_statusReferencia in ('CA', 'RE')) then
        OPEN c_cursor FOR
          with x as
           (select rownum num, y.*
              from (SELECT c.no_documento,
                           initcap(c.primer_apellido || ' ' ||
                                   c.segundo_apellido || ', ' || c.nombres) Nombres,
                           d.id_referencia,
                           d.id_nss,
                           d.salario_ss,
                           d.aporte_afiliados_sfs,
                           d.aporte_empleador_sfs,
                           d.aporte_afiliados_svds,
                           d.aporte_empleador_svds,
                           d.monto_ajuste,
                           d.aporte_srl,
                           d.aporte_voluntario,
                           d.per_capita_adicional,
                           d.interes_apo + d.interes_seguro_vida +
                           d.interes_afp + d.interes_cpe + d.interes_fss +
                           d.interes_osipen + d.interes_sfs + d.interes_srl +
                           d.recargo_svds + d.recargo_sfs + d.recargo_srl total_intereses_recargos,
                           d.aporte_afiliados_sfs + d.aporte_empleador_sfs +
                           d.aporte_afiliados_svds + d.aporte_empleador_svds +
                           d.aporte_srl + d.aporte_voluntario +
                           d.per_capita_adicional + d.interes_apo +
                           d.interes_seguro_vida + d.interes_afp +
                           d.interes_cpe + d.interes_fss + d.interes_osipen +
                           d.interes_sfs + d.interes_srl + d.recargo_svds +
                           d.recargo_sfs + d.recargo_srl total_general_det_factura,
                           Srp_Pkg.FormateaPeriodo(d.periodo_aplicacion) AS periodo_aplicacion,
                           d.salario_ss_reportado
                      FROM SRE_CIUDADANOS_T               c,
                           sfc_det_facturas_recalculada_t d
                     WHERE d.id_referencia = p_NoReferencia
                       and d.id_nss = c.id_nss
                     ORDER BY 2) y)
          select y.recordcount, x.*
            from x, (select max(num) recordcount from x) y
           where num between vDesde and vHasta
           order by num;
      else
        OPEN c_cursor FOR
          with x as
           (select rownum num, y.*
              from (SELECT c.no_documento,
                           initcap(c.primer_apellido || ' ' ||
                                   c.segundo_apellido || ', ' || c.nombres) Nombres,
                           d.id_referencia,
                           d.id_nss,
                           d.salario_ss,
                           d.aporte_afiliados_sfs,
                           d.aporte_empleador_sfs,
                           d.aporte_afiliados_svds,
                           d.aporte_empleador_svds,
                           d.monto_ajuste,
                           d.aporte_srl,
                           d.aporte_voluntario,
                           d.per_capita_adicional,
                           d.total_intereses_recargos,
                           d.total_general_det_factura,
                           Srp_Pkg.FormateaPeriodo(d.periodo_aplicacion) AS periodo_aplicacion,
                           d.salario_ss_reportado
                      FROM SRE_CIUDADANOS_T c, sfc_det_facturas_v d
                     WHERE d.id_referencia = p_NoReferencia
                       and d.id_nss = c.id_nss
                     ORDER BY 2) y)
          select y.recordcount, x.*
            from x, (select max(num) recordcount from x) y
           where num between vDesde and vHasta
           order by num;
      end if;
    END IF;
  
    IF p_concepto = v_tt_ISR THEN
      OPEN c_cursor FOR
      
        with x as
         (select rownum num, y.*
            from (
                  
                  SELECT CHR(32) || c.no_documento || CHR(32) no_documento,
                          Srp_Pkg.ProperCase(c.primer_apellido || ' ' ||
                                             c.segundo_apellido || ', ' ||
                                             c.nombres) Nombres,
                          dl.salario_isr,
                          dl.otros_ingresos_isr,
                          dl.remuneracion_isr_otros,
                          dl.TOTAL_PAGADO,
                          dl.RETENCION_SS,
                          dl.ISR,
                          dl.total_sujeto_retencion,
                          dl.saldo_favor_del_periodo,
                          dl.saldo_compensado,
                          dl.saldo_por_compensar,
                          dl.INGRESOS_EXENTOS_ISR,
                          dl.impuesto_pagar
                    FROM sfc_liquidacion_isr_v     l,
                          SRE_CIUDADANOS_T          c,
                          sfc_det_liquidacion_isr_v dl
                   WHERE l.ID_REFERENCIA_ISR = p_NoReferencia
                     AND dl.id_referencia_isr = l.ID_REFERENCIA_ISR
                     AND c.id_nss = dl.id_nss
                   ORDER BY 2) y)
        select y.recordcount, x.*
          from x, (select max(num) recordcount from x) y
         where num between vDesde and vHasta
         order by num;
    
    END IF;
  
    -- Para traer el detalle de las facturas de INFOTEP
    -- debe tomarse en cuenta que las facturas de acuerdo de pago (facturas tipo 'E') no tienen detalle
    IF p_concepto = v_tt_INF THEN
    
      OPEN c_cursor FOR
      
        with x as
         (select rownum num, y.*
            from (SELECT c.no_documento,
                         initcap(c.primer_apellido || ' ' ||
                                 c.segundo_apellido || ', ' || c.nombres) Nombres,
                         d.id_referencia_infotep,
                         d.id_nss,
                         d.salario,
                         d.pago_infotep,
                         Srp_Pkg.FormateaPeriodo(d.periodo_aplicacion) AS periodo_aplicacion
                    FROM SRE_CIUDADANOS_T                       c,
                         suirplus.sfc_det_liquidacion_infotep_t d
                   WHERE d.id_referencia_infotep = p_NoReferencia
                     AND c.id_nss = d.id_nss
                   ORDER BY 2) y)
        select y.recordcount, x.*
          from x, (select max(num) recordcount from x) y
         where num between vDesde and vHasta
         order by num;
    
    END IF;
  
    -- Para traer el detalle de las facturas de PLANILLA MDT
    -- debe tomarse en cuenta que las facturas de acuerdo de pago (facturas tipo 'E') no tienen detalle
    IF p_concepto = v_tt_MDT THEN
    
      OPEN c_cursor FOR
      
        with x as
         (select rownum num, y.*
            from (SELECT c.no_documento,
                         initcap(c.primer_apellido || ' ' ||
                                 c.segundo_apellido || ', ' || c.nombres) Nombres,
                         d.id_referencia_planilla,
                         d.id_nss,
                         d.salario_mdt salario,
                         DECODE(d.id_novedad,
                                'NS',
                                'Novedad de Salida',
                                'NI',
                                'Novedad de Ingreso',
                                'NC',
                                'Novedad de Cambio') novedad_desc,
                         initcap(d.ocupacion_desc) ocupacion_desc,
                         initcap(loc.descripcion) localidad_desc,
                         initcap(tur.descripcion) turno_desc,
                         d.FECHA_INGRESO
                  
                  --, Srp_Pkg.FormateaPeriodo(d.periodo_aplicacion) AS periodo_aplicacion
                    FROM SRE_CIUDADANOS_T                c,
                         suirplus.sfc_det_planilla_mdt_t d,
                         sre_localidades_t               loc,
                         sre_turnos_t                    tur
                   WHERE d.id_referencia_planilla = p_NoReferencia
                     and d.id_localidad = loc.id_localidad
                     and d.id_turno = tur.id_turno
                     AND c.id_nss = d.id_nss
                   ORDER BY 2) y)
        select y.recordcount, x.*
          from x, (select max(num) recordcount from x) y
         where num between vDesde and vHasta
         order by num;
    
    END IF;
  
    p_resultnumber := 0;
    p_IOCursor     := c_cursor;
  
  EXCEPTION
  
    WHEN e_invalidNoReferencia THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(16, NULL, NULL);
      RETURN;
    
    WHEN OTHERS THEN
      v_bd_error     := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultNumber := Seg_Retornar_Cadena_Error(-1, v_bd_error, SQLCODE);
      RETURN;
    
  END;

  PROCEDURE ConsPage_Detalle_Auditoria(p_NoReferencia IN SFC_FACTURAS_T.id_referencia%TYPE,
                                       p_pagenum      in number,
                                       p_pagesize     in number,
                                       p_IOCursor     IN OUT t_Cursor,
                                       p_resultnumber OUT VARCHAR2) is
    e_invalidNoReferencia EXCEPTION;
    v_bd_error VARCHAR(1000);
    c_cursor   t_cursor;
    vDesde     integer := (p_pagesize * (p_pagenum - 1)) + 1;
    vHasta     integer := p_pagesize * p_pagenum;
  begin
    IF p_NoReferencia IS NOT NULL THEN
      OPEN c_cursor FOR
        with x as
         (select rownum num, y.*
            from (SELECT ciu.no_documento,
                         DET.ID_NSS,
                         CIU.PRIMER_APELLIDO || ' ' || CIU.SEGUNDO_APELLIDO || ', ' ||
                         CIU.NOMBRES NOMBRES,
                         DET.PERIODO_APLICACION,
                         nvl(MOV.PA_SaLARIO_Ss, 0) AS SALARIO_ORIGINAL,
                         det.SALARIO_SS AS SALARIO_REPORTADO,
                         (det.SALARIO_SS - nvl(MOV.PA_SALARIO_SS, 0)) AS DIF_SALARIO,
                         DET.APORTE_AFILIADOS_SFS,
                         DET.APORTE_EMPLEADOR_SFS,
                         DET.APORTE_AFILIADOS_SVDS,
                         DET.APORTE_EMPLEADOR_SVDS,
                         DET.APORTE_SRL,
                         DET.PER_CAPITA_ADICIONAL,
                         nvl(MOV.PA_APORTE_VOLUNTARIO, 0) AS APORTE_ORIGINAL,
                         det.APORTE_VOLUNTARIO AS APORTE_REPORTADO,
                         (det.APORTE_VOLUNTARIO -
                         nvl(MOV.PA_APORTE_VOLUNTARIO, 0)) AS DIF_APORTE,
                         (DET.APORTE_AFILIADOS_SVDS +
                         DET.APORTE_EMPLEADOR_SVDS + DET.APORTE_SRL +
                         DET.APORTE_AFILIADOS_SFS + DET.APORTE_EMPLEADOR_SFS) AS NUEVO_IMPORTE,
                         DET.TOTAL_RECARGOS,
                         DET.TOTAL_INTERES,
                         DET.TOTAL_GENERAL_DET_FACTURA
                    FROM suirplus.SFC_FACTURAS_V FAC
                    join suirplus.SFC_DET_FACTURAS_V DET
                      on det.id_referencia = fac.ID_REFERENCIA
                    join suirplus.SRE_CIUDADANOS_T CIU
                      on ciu.id_nss = det.id_nss
                    left join (select z.id_referencia,
                                     z.id_nss,
                                     nvl(z.periodo_aplicacion,
                                         y.periodo_factura) periodo,
                                     sum(z.salario_ss) pa_salario_ss,
                                     sum(z.aporte_voluntario) pa_aporte_voluntario
                                from suirplus.sfc_facturas_v x
                                join suirplus.sfc_det_facturas_t w
                                  on w.id_referencia = x.id_referencia
                                join suirplus.sfc_facturas_v y
                                  on y.id_registro_patronal =
                                     x.id_registro_patronal
                                 and y.periodo_factura = w.periodo_aplicacion
                                 and y.status = 'PA'
                                 and y.id_referencia <> x.id_referencia
                                 and y.fecha_emision <= x.fecha_emision
                                 and y.fecha_pago <= x.fecha_emision
                                join suirplus.sfc_det_facturas_t z
                                  on z.id_referencia = y.id_referencia
                                 and z.id_nss = w.id_nss
                               where x.id_referencia = p_NoReferencia
                               group by z.id_referencia,
                                        z.id_nss,
                                        nvl(z.periodo_aplicacion,
                                            y.periodo_factura)) mov
                      on mov.id_nss = det.id_nss
                     and mov.periodo = det.periodo_aplicacion
                   WHERE FAC.ID_REFERENCIA = p_NoReferencia
                   ORDER BY DET.ID_NSS, DET.PERIODO_APLICACION) y)
        select y.recordcount, x.*
          from x, (select max(num) recordcount from x) y
         where num between vDesde and vHasta
         order by num;
    
      p_resultnumber := 0;
      p_IOCursor     := c_cursor;
    
    END IF;
  EXCEPTION
    WHEN e_invalidNoReferencia THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(16, NULL, NULL);
      RETURN;
    
    WHEN OTHERS THEN
      v_bd_error     := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultNumber := Seg_Retornar_Cadena_Error(-1, v_bd_error, SQLCODE);
      RETURN;
  end;

  ------------------------------------------------------------
  -- Devuelve un cursor con las referencias pendientes de pago
  -- Autor: Gregorio Herrera
  ------------------------------------------------------------
  Procedure ReferenciasDisponiblesParaPago(p_rnc_o_cedula     in suirplus.sre_empleadores_t.rnc_o_cedula%type,
                                           p_concepto         in varchar2,
                                           p_id_nomina        in suirplus.sre_nominas_t.id_nomina%type,
                                           p_tipoAcuerdo      in suirplus.lgl_acuerdos_t.tipo%type,
                                           p_razon_social     out suirplus.sre_empleadores_t.razon_social%type,
                                           p_nombre_comercial out suirplus.sre_empleadores_t.nombre_comercial%type,
                                           p_IOCursor         out t_Cursor,
                                           p_resultnumber     out varchar2) Is
    v_regPat   suirplus.sre_empleadores_t.id_registro_patronal%type;
    v_bd_error varchar(1000);
    e_invalidRNC exception;
    e_referencias exception;
    v_referencias number;
  Begin
    -- Validamos la cedula o el RNC pasado como parametro
    If Not suirplus.sre_empleadores_pkg.isRncOCedulaValida(p_rnc_o_cedula) Then
      Raise e_invalidRNC;
    End if;
  
    -- Informacion del empleador para las variables de salidas
    For c_Emp in (Select e.razon_social,
                         e.nombre_comercial,
                         e.id_registro_patronal
                    From suirplus.sre_empleadores_t e
                   Where e.rnc_o_cedula = p_rnc_o_cedula) Loop
      v_regPat           := c_Emp.Id_Registro_Patronal;
      p_razon_social     := c_Emp.razon_social;
      p_nombre_comercial := c_Emp.nombre_comercial;
    End Loop;
  
    If Trim(p_concepto) = v_tt_SDSS then
      -- Referencias SDSS del empleador pendientes de pago
      -- Validamos si este empelador tiene referencias pendientes de pago
      select count(id_referencia)
        into v_referencias
        from suirplus.sfc_facturas_v f
       Where f.ID_REGISTRO_PATRONAL = v_regPat
         and f.status in ('VE')
         and (((f.id_tipo_factura = 'U') and (f.status_generacion = 'D')) or
             (f.id_tipo_factura != 'U'))
         and Nvl(f.NO_AUTORIZACION, 0) = 0
         and Nvl(f.TOTAL_GENERAL_FACTURA, 0) > 0
         and f.ID_NOMINA = Decode(p_id_nomina,
                                  0,
                                  f.ID_NOMINA,
                                  6321,
                                  f.ID_NOMINA,
                                  p_id_nomina);
    
      If v_referencias = 0 Then
        Raise e_referencias;
      End if;
    
      if p_tipoAcuerdo = 2 then
        /*Si el tipo de Acuerdo es Ley189*/
        Open p_IOCursor for
          Select f.ID_REFERENCIA,
                 InitCap(n.nomina_des) nomina_des,
                 suirplus.srp_pkg.FormateaPeriodo(f.PERIODO_FACTURA) periodo_factura,
                 f.TOTAL_GENERAL_FACTURA total,
                 Suirplus.Sfc_Factura_Pkg.DisponibleAutorizar(f.ID_REFERENCIA) Autorizar
            From suirplus.sfc_facturas_v f
            Join suirplus.sre_nominas_t n
              on n.id_registro_patronal = f.ID_REGISTRO_PATRONAL
             and n.id_nomina = f.ID_NOMINA
           Where f.ID_REGISTRO_PATRONAL = v_regPat
             and f.status in ('VE')
             and f.PERIODO_FACTURA < 200708 /* by RJ 09/06/2007 */
             and Nvl(f.NO_AUTORIZACION, 0) = 0
             and Nvl(f.TOTAL_GENERAL_FACTURA, 0) > 0
             and f.ID_NOMINA = Decode(p_id_nomina,
                                      0,
                                      f.ID_NOMINA,
                                      6321,
                                      f.ID_NOMINA,
                                      p_id_nomina)
           Order by f.PERIODO_FACTURA, f.id_nomina;
      Elsif p_tipoAcuerdo = 3 then
        /*Si el tipo de Acuerdo es Ordinario*/
        Open p_IOCursor for
          Select f.ID_REFERENCIA,
                 InitCap(n.nomina_des) nomina_des,
                 f.PERIODO_FACTURA, --suirplus.srp_pkg.FormateaPeriodo(f.PERIODO_FACTURA) periodo_factura,
                 f.TOTAL_GENERAL_FACTURA total,
                 Suirplus.Sfc_Factura_Pkg.DisponibleAutorizar(f.ID_REFERENCIA) Autorizar
            From suirplus.sfc_facturas_v f
            Join suirplus.sre_nominas_t n
              on n.id_registro_patronal = f.ID_REGISTRO_PATRONAL
             and n.id_nomina = f.ID_NOMINA
           Where f.ID_REGISTRO_PATRONAL = v_regPat
             and f.status in ('VE')
             and Nvl(f.NO_AUTORIZACION, 0) = 0
             and Nvl(f.TOTAL_GENERAL_FACTURA, 0) > 0
             and f.ID_NOMINA = Decode(p_id_nomina,
                                      0,
                                      f.ID_NOMINA,
                                      6321,
                                      f.ID_NOMINA,
                                      p_id_nomina)
           Order by f.PERIODO_FACTURA asc;
      
      Elsif p_tipoAcuerdo = 4 then
        /*Si el tipo de Acuerdo es de Embajadas*/
        Open p_IOCursor for
          Select f.ID_REFERENCIA,
                 InitCap(n.nomina_des) nomina_des,
                 f.PERIODO_FACTURA, --suirplus.srp_pkg.FormateaPeriodo(f.PERIODO_FACTURA) periodo_factura,
                 f.TOTAL_GENERAL_FACTURA total,
                 Suirplus.Sfc_Factura_Pkg.DisponibleAutorizar(f.ID_REFERENCIA) Autorizar
            From suirplus.sfc_facturas_v f
            Join suirplus.sre_nominas_t n
              on n.id_registro_patronal = f.ID_REGISTRO_PATRONAL
             and n.id_nomina = f.ID_NOMINA
           Where f.ID_REGISTRO_PATRONAL = v_regPat
             and f.status in ('VE')
             and Nvl(f.NO_AUTORIZACION, 0) = 0
             and Nvl(f.TOTAL_GENERAL_FACTURA, 0) > 0
             and f.ID_NOMINA = Decode(p_id_nomina,
                                      0,
                                      f.ID_NOMINA,
                                      6321,
                                      f.ID_NOMINA,
                                      p_id_nomina)
           Order by f.PERIODO_FACTURA asc;
      end if;
    
    Elsif Trim(p_concepto) = v_tt_ISR then
      -- Referencias ISR del empleador pendientes de pago
      -- Validamos si este empelador tiene referencias pendientes de pago
      select count(id_referencia_isr)
        into v_referencias
        from suirplus.sfc_liquidacion_isr_v f
       Where f.ID_REGISTRO_PATRONAL = v_regPat
         and f.status in ('VE', 'VI')
         and Nvl(f.NO_AUTORIZACION, 0) = 0
         and Nvl(f.TOTAL_A_PAGAR, 0) > 0;
    
      If v_referencias = 0 Then
        Raise e_referencias;
      End if;
    
      Open p_IOCursor for
        Select f.ID_REFERENCIA_ISR,
               suirplus.srp_pkg.FormateaPeriodo(f.PERIODO_LIQUIDACION) periodo_liquidacion,
               f.TOTAL_A_PAGAR total,
               Suirplus.Sfc_Factura_Pkg.DisponibleAutorizar(f.ID_REFERENCIA_ISR) Autorizar
          From suirplus.sfc_liquidacion_isr_v f
         Where f.ID_REGISTRO_PATRONAL = v_regPat
           and f.status in ('VE', 'VI')
           and Nvl(f.NO_AUTORIZACION, 0) = 0
           and Nvl(f.TOTAL_A_PAGAR, 0) > 0
         Order by f.PERIODO_LIQUIDACION;
    Elsif Trim(p_concepto) = v_tt_IR17 then
      -- Referencias IR17 del empleador pendientes de pago
      -- Validamos si este empelador tiene referencias pendientes de pago
      select count(id_referencia_ir17)
        into v_referencias
        from suirplus.sfc_liquidacion_ir17_v f
       Where f.ID_REGISTRO_PATRONAL = v_regPat
         and f.status in ('VE', 'VI')
         and Nvl(f.NO_AUTORIZACION, 0) = 0
         and Nvl(f.LIQUIDACION, 0) > 0;
    
      If v_referencias = 0 Then
        Raise e_referencias;
      End if;
    
      Open p_IOCursor for
        Select f.ID_REFERENCIA_IR17,
               suirplus.srp_pkg.FormateaPeriodo(f.PERIODO_LIQUIDACION) periodo_liquidacion,
               f.LIQUIDACION total,
               Suirplus.Sfc_Factura_Pkg.DisponibleAutorizar(f.ID_REFERENCIA_IR17) Autorizar
          From suirplus.sfc_liquidacion_ir17_v f
         Where f.ID_REGISTRO_PATRONAL = v_regPat
           and f.status in ('VE', 'VI')
           and Nvl(f.NO_AUTORIZACION, 0) = 0
           and Nvl(f.LIQUIDACION, 0) > 0
         Order by f.PERIODO_LIQUIDACION;
    Elsif Trim(p_concepto) = v_tt_INF then
      -- Referencias INF del empleador pendientes de pago
      -- Validamos si este empelador tiene referencias pendientes de pago
      select count(id_referencia_infotep)
        into v_referencias
        from suirplus.sfc_liquidacion_infotep_t f
       Where f.id_registro_patronal = v_regPat
         and f.status in ('VE', 'VI')
         and Nvl(f.no_autorizacion, 0) = 0
         and Nvl(f.periodo_liquidacion, 0) > 0;
    
      If v_referencias = 0 Then
        Raise e_referencias;
      End if;
    
      Open p_IOCursor for
        Select f.id_referencia_infotep,
               suirplus.srp_pkg.FormateaPeriodo(f.periodo_liquidacion) periodo_liquidacion,
               f.total_salario_bonificacion total,
               Suirplus.Sfc_Factura_Pkg.DisponibleAutorizar(f.id_referencia_infotep) Autorizar
          From suirplus.sfc_liquidacion_infotep_t f
         Where f.id_registro_patronal = v_regPat
           and f.status in ('VE', 'VI')
           and Nvl(f.no_autorizacion, 0) = 0
           and Nvl(f.periodo_liquidacion, 0) > 0
         Order by f.periodo_liquidacion;
    
    Elsif Trim(p_concepto) = v_tt_MDT then
      -- Referencias MDT del empleador pendientes de pago
      -- Validamos si este empelador tiene referencias pendientes de pago
      select count(id_referencia_planilla)
        into v_referencias
        from suirplus.sfc_planilla_mdt_t f
       Where f.id_registro_patronal = v_regPat
         and f.status in ('VE', 'VI')
         and Nvl(f.no_autorizacion, 0) = 0
         and Nvl(f.periodo_liquidacion, 0) > 0;
    
      If v_referencias = 0 Then
        Raise e_referencias;
      End if;
    
      Open p_IOCursor for
        Select f.id_referencia_planilla,
               suirplus.srp_pkg.FormateaPeriodo(f.periodo_liquidacion) periodo_liquidacion,
               f.total_salario total,
               Suirplus.Sfc_Factura_Pkg.DisponibleAutorizar(f.id_referencia_planilla) Autorizar
          From suirplus.sfc_planilla_mdt_t f
         Where f.id_registro_patronal = v_regPat
           and f.status in ('VE', 'VI')
           and Nvl(f.no_autorizacion, 0) = 0
           and Nvl(f.periodo_liquidacion, 0) > 0
         Order by f.periodo_liquidacion;
    End if;
  
    p_resultnumber := 0;
  
  Exception
    When e_invalidRNC then
      p_resultnumber := Seg_Retornar_Cadena_Error(150, NULL, NULL);
      Return;
    
    When e_referencias then
      p_resultnumber := Seg_Retornar_Cadena_Error(187, NULL, NULL);
      Return;
    
    When others then
      v_bd_error     := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultNumber := Seg_Retornar_Cadena_Error(-1, v_bd_error, SQLCODE);
  End ReferenciasDisponiblesParaPago;

  -------------------------------------------------------
  -- Para verificar si existe al menos una referencia
  -- pendiente de pago mas antigua que la se esta pagando
  -- Autor: Gregorio Herrera
  -------------------------------------------------------
  Function DisponibleAutorizar(p_Noreferencia in suirplus.sfc_facturas_t.id_referencia%type)
    return char is
    v_resultado char(1);
  Begin
    v_resultado := 'S';
    -- Para validar si existe alguna referencia SDSS mas antigua que la que se esta autorizando
    If substr(trim(p_Noreferencia), 1, 1) in ('0', '1') then
      For c_Ref in (select id_nomina, periodo_factura, id_registro_patronal
                      from suirplus.sfc_facturas_v f
                     where id_referencia = p_NoReferencia
                       and status in ('VE', 'VI')
                       and Nvl(no_autorizacion, 0) = 0
                       and exists
                     (select 1
                              from suirplus.sfc_facturas_v
                             where id_registro_patronal =
                                   f.id_registro_patronal
                               and id_nomina = f.id_nomina
                               and periodo_factura < f.periodo_factura
                               and status in ('VE', 'VI')
                               and no_autorizacion is null)) Loop
        v_resultado := 'N';
      End loop;
      -- Para validar si existe alguna referencia ISR mas antigua que la que se esta autorizando
    ElsIf substr(trim(p_Noreferencia), 1, 1) = '2' then
      For c_Ref in (select periodo_liquidacion, id_registro_patronal
                      from suirplus.sfc_liquidacion_isr_v l
                     where l.id_referencia_isr = p_NoReferencia
                       and status in ('VE', 'VI')
                       and Nvl(no_autorizacion, 0) = 0
                       and exists
                     (select 1
                              from suirplus.sfc_liquidacion_isr_v
                             where id_registro_patronal =
                                   l.id_registro_patronal
                               and periodo_liquidacion <
                                   l.periodo_liquidacion
                               and status in ('VE', 'VI')
                               and no_autorizacion is null)) Loop
        v_resultado := 'N';
      End loop;
      -- Para validar si existe alguna referencia IR17 mas antigua que la que se esta autorizando
    ElsIf substr(trim(p_Noreferencia), 1, 1) = '3' then
      For c_Ref in (select periodo_liquidacion, id_registro_patronal
                      from suirplus.sfc_liquidacion_ir17_v l
                     where id_referencia_ir17 = p_NoReferencia
                       and status in ('VE', 'VI')
                       and Nvl(no_autorizacion, 0) = 0
                       and exists
                     (select 1
                              from suirplus.sfc_liquidacion_ir17_v
                             where id_registro_patronal =
                                   l.id_registro_patronal
                               and periodo_liquidacion <
                                   l.periodo_liquidacion
                               and status in ('VE', 'VI')
                               and no_autorizacion is null)) Loop
        v_resultado := 'N';
      End loop;
      -- Para validar si existe alguna referencia INF mas antigua que la que se esta autorizando
    ElsIf substr(trim(p_Noreferencia), 1, 1) = '5' then
      For c_Ref in (select periodo_liquidacion, id_registro_patronal
                      from suirplus.sfc_liquidacion_infotep_t l
                     where l.id_referencia_infotep = p_NoReferencia
                       and status in ('VE', 'VI')
                       and Nvl(no_autorizacion, 0) = 0
                       and exists
                     (select 1
                              from suirplus.sfc_liquidacion_infotep_t
                             where id_registro_patronal =
                                   l.id_registro_patronal
                               and periodo_liquidacion <
                                   l.periodo_liquidacion
                               and status in ('VE', 'VI')
                               and no_autorizacion is null)) Loop
        v_resultado := 'N';
      End loop;
      -- Para validar si existe alguna referencia MDT mas antigua que la que se esta autorizando
    ElsIf substr(trim(p_Noreferencia), 1, 1) = '6' then
      For c_Ref in (select periodo_liquidacion, id_registro_patronal
                      from suirplus.sfc_planilla_mdt_t l
                     where l.id_referencia_planilla = p_NoReferencia
                       and status in ('VE', 'VI')
                       and Nvl(no_autorizacion, 0) = 0
                       and exists
                     (select 1
                              from suirplus.sfc_planilla_mdt_t
                             where id_registro_patronal =
                                   l.id_registro_patronal
                               and periodo_liquidacion <
                                   l.periodo_liquidacion
                               and status in ('VE', 'VI')
                               and no_autorizacion is null)) Loop
        v_resultado := 'N';
      End loop;
    End if;
    Return v_resultado;
  End DisponibleAutorizar;

  PROCEDURE ConsPage_Facturas(p_RNCoCedula   IN SRE_EMPLEADORES_T.RNC_O_CEDULA%TYPE,
                              p_CodigoNomina IN SRE_NOMINAS_T.id_nomina%TYPE,
                              p_Status       IN VARCHAR2,
                              p_concepto     IN VARCHAR2,
                              p_pagenum      in number,
                              p_pagesize     in number,
                              p_IOCursor     IN OUT t_Cursor,
                              p_resultnumber OUT VARCHAR2) IS
    --v_cant_referencias varchar2(50);
    v_bd_error VARCHAR(1000);
    vDesde     integer := (p_pagesize * (p_pagenum - 1)) + 1;
    vHasta     integer := p_pagesize * p_pagenum;
  BEGIN
  
    IF p_concepto = v_tt_SDSS then
      -- --------------------------------------------------------------- SDSS
      OPEN p_iocursor FOR
        with x as
         (select rownum num, y.*
            from (SELECT f.id_referencia id_referencia,
                         f.id_nomina as id_nomina,
                         initcap(n.nomina_des) nomina_des,
                         'Detalles' as Detalles,
                         /*DECODE(f.tipo_nomina,
                                'N',
                                'NOR',
                                'P',
                                'PEN',
                                'D',
                                'DIS')*/ c.descripcion tipo_nomina,
                         Srp_Pkg.FORMATEAPERIODO(f.periodo_factura) periodo_factura,
                         f.total_general_factura total_general,
                         e.razon_social,
                         f.FECHA_EMISION fecha_emision,
                         f.FECHA_PAGO,
                         f.status_des STATUS,
                         f.TOTAL_APORTE_EMPLEADOR_SVDS,
                         f.TOTAL_APORTE_AFILIADOS_SVDS,
                         f.TOTAL_APORTE_EMPLEADOR_SFS,
                         f.TOTAL_APORTE_AFILIADOS_SFS,
                         f.TOTAL_APORTE_VOLUNTARIO,
                         f.TOTAL_APORTE_SRL,
                         f.TOTAL_RECARGOS_FACTURA,
                         f.TOTAL_INTERES_FACTURA,
                         f.Total_Importe,
                         f.TOTAL_GENERAL_FACTURA,
                         f.id_tipo_factura,
                         f.fecha_limite_acuerdo_pago
                    from sre_empleadores_t e
                    join sfc_facturas_v f
                      on f.id_registro_patronal = e.id_registro_patronal
                    join SRE_NOMINAS_T n
                      on n.id_registro_patronal = f.id_registro_patronal
                     and n.id_nomina = f.id_nomina
                    LEFT join sfc_tipo_nominas_t c
                     on c.id_tipo_nomina = f.tipo_nomina
                   WHERE e.RNC_O_CEDULA = p_RNCoCedula
                     and p_status in (f.status, 'TODOS')
                     and p_CodigoNomina in (f.id_nomina, '6321')
                   ORDER BY f.periodo_factura DESC, f.id_nomina) y)
        select y.recordcount, x.*
          from x, (select max(num) recordcount from x) y
         where num between vDesde and vHasta
         order by num;
    Elsif p_concepto = v_tt_ISR then
      -- -------------------------------------------------------------- ISR
      OPEN p_iocursor FOR
        with x as
         (select rownum num, y.*
            from (SELECT l.id_referencia_isr id_referencia,
                         l.id_nomina as id_nomina,
                         'Liquidacion ISR' nomina_des,
                         ' ' tipo_nomina,
                         Srp_Pkg.FORMATEAPERIODO(l.periodo_liquidacion) periodo_factura,
                         l.TOTAL_A_PAGAR total_general,
                         e.razon_social,
                         l.FECHA_EMISION fecha_emision,
                         l.fecha_pago,
                         l.status_des STATUS,
                         'Detalle Factura' AS detalles,
                         ' ' TOTAL_RECARGOS_FACTURA,
                         ' ' TOTAL_INTERES_FACTURA,
                         ' ' Total_Importe,
                         l.id_tipo_factura,
                         ' ' fecha_limite_acuerdo_pago
                    FROM sre_empleadores_t e
                    join sfc_liquidacion_isr_v l
                      on l.id_registro_patronal = e.id_registro_patronal
                   WHERE e.RNC_O_CEDULA = p_RNCoCedula
                     and p_status in (l.status, 'TODOS')
                   ORDER BY l.periodo_liquidacion DESC, l.FECHA_EMISION DESC) y)
        select y.recordcount, x.*
          from x, (select max(num) recordcount from x) y
         where num between vDesde and vHasta
         order by num;
    Elsif p_concepto = v_tt_IR17 then
      -- -------------------------------------------------------------- IR17
      OPEN p_iocursor FOR
        with x as
         (select rownum num, y.*
            from (SELECT i.id_referencia_ir17 id_referencia,
                         Srp_Pkg.FORMATEAPERIODO(I.PERIODO_LIQUIDACION) periodo_factura,
                         I.LIQUIDACION total_general,
                         e.razon_social,
                         i.FECHA_EMISION fecha_emision,
                         i.FECHA_PAGO,
                         i.status_des STATUS,
                         ' ' Nomina_des,
                         ' ' tipo_nomina,
                         'Detalle Factura' AS detalles,
                         ' ' TOTAL_RECARGOS_FACTURA,
                         ' ' TOTAL_INTERES_FACTURA,
                         ' ' Total_Importe,
                         ' ' id_tipo_factura,
                         ' ' fecha_limite_acuerdo_pago
                    FROM SRE_EMPLEADORES_T e
                    join sfc_liquidacion_ir17_v i
                      on i.id_registro_patronal = e.id_registro_patronal
                   WHERE e.RNC_O_CEDULA = p_RNCoCedula
                     and p_status in (i.status, 'TODOS')
                   ORDER BY i.PERIODO_LIQUIDACION DESC, i.FECHA_EMISION DESC) y)
        select y.recordcount, x.*
          from x, (select max(num) recordcount from x) y
         where num between vDesde and vHasta
         order by num;
    Elsif p_concepto = v_tt_INF then
      -- -------------------------------------------------------------- INF
      OPEN p_iocursor FOR
        with x as
         (select rownum num, y.*
            from (SELECT i.id_referencia_infotep id_referencia,
                         Srp_Pkg.FORMATEAPERIODO(I.PERIODO_LIQUIDACION) periodo_factura,
                         I.TOTAL_PAGO_INFOTEP total_general,
                         e.razon_social,
                         i.FECHA_EMISION fecha_emision,
                         i.FECHA_PAGO,
                         decode(i.status,
                                'PA',
                                'Pagada',
                                'VE',
                                'Vencida',
                                'VI',
                                'Vigente',
                                'PE',
                                'pendiente',
                                'CA',
                                'Cancelada',
                                'EX',
                                'Exenta',
                                i.status) STATUS,
                         ' ' Nomina_des,
                         ' ' tipo_nomina,
                         'Detalle Factura' AS detalles,
                         ' ' TOTAL_RECARGOS_FACTURA,
                         ' ' TOTAL_INTERES_FACTURA,
                         ' ' Total_Importe,
                         i.id_tipo_factura,
                         ' ' fecha_limite_acuerdo_pago
                    FROM SRE_EMPLEADORES_T e
                    join suirplus.sfc_liquidacion_infotep_t i
                      on i.id_registro_patronal = e.id_registro_patronal
                   WHERE e.RNC_O_CEDULA = p_RNCoCedula
                     and p_status in (i.status, 'TODOS')
                   ORDER BY i.PERIODO_LIQUIDACION DESC, i.FECHA_EMISION DESC) y)
        select y.recordcount, x.*
          from x, (select max(num) recordcount from x) y
         where num between vDesde and vHasta
         order by num;
    Elsif p_concepto = v_tt_MDT then
      -- -------------------------------------------------------------- INF
      OPEN p_iocursor FOR
        with x as
         (select rownum num, y.*
            from (SELECT i.id_referencia_planilla id_referencia,
                         Srp_Pkg.FORMATEAPERIODO(I.PERIODO_LIQUIDACION) periodo_factura,
                         I.TOTAL_PAGO total_general,
                         e.razon_social,
                         i.FECHA_EMISION fecha_emision,
                         i.FECHA_PAGO,
                         decode(i.status,
                                'PA',
                                'Pagada',
                                'VE',
                                'Vencida',
                                'VI',
                                'Vigente',
                                'PE',
                                'pendiente',
                                'CA',
                                'Cancelada',
                                'EX',
                                'Exenta',
                                'IN',
                                'Inhabilitado para pago',
                                i.status) STATUS,
                         ' ' Nomina_des,
                         ' ' tipo_nomina,
                         'Detalle Factura' AS detalles,
                         ' ' TOTAL_RECARGOS_FACTURA,
                         ' ' TOTAL_INTERES_FACTURA,
                         ' ' Total_Importe,
                         i.id_tipo_factura,
                         ' ' fecha_limite_acuerdo_pago
                    FROM SRE_EMPLEADORES_T e
                    join suirplus.sfc_planilla_mdt_t i
                      on i.id_registro_patronal = e.id_registro_patronal
                   WHERE e.RNC_O_CEDULA = p_RNCoCedula
                     and p_status in (i.status, 'TODOS')
                   ORDER BY i.PERIODO_LIQUIDACION DESC, i.FECHA_EMISION DESC) y)
        select y.recordcount, x.*
          from x, (select max(num) recordcount from x) y
         where num between vDesde and vHasta
         order by num;
    End if;
  
    /* ---------------------------------------------------------------------------------------------------------------------
       NO DESCOMENTAR NI BORRAR ESTA AREA, EN CASO DE QUE FALTE ALGUN CAMPO EN ALGUNA CONDICION
       ---------------------------------------------------------------------------------------------------------------------
       IF p_Status = 'TODOS' THEN
            IF p_CodigoNomina = 6321 THEN
                IF p_concepto =  v_tt_SDSS THEN
                        SELECT count(NVL(f.id_referencia, '0')) INTO v_cant_referencias
                        FROM sfc_facturas_v f, SRE_EMPLEADORES_T e
                        WHERE e.RNC_O_CEDULA = p_RNCoCedula
                        AND f.id_registro_patronal = e.id_registro_patronal;
    
                    OPEN p_iocursor FOR
                    with x as (select rownum num,y.* from (
                        SELECT  f.id_referencia id_referencia, f.id_nomina as id_nomina, initcap(n.nomina_des) nomina_des, 'Detalles' as Detalles, DECODE(f.tipo_nomina, 'N' , 'NOR' , 'P' , 'PEN' , 'D' , 'DIS' ) tipo_nomina,
                                Srp_Pkg.FORMATEAPERIODO(f.periodo_factura) periodo_factura, f.total_general_factura total_general, e.razon_social, f.FECHA_EMISION fecha_emision,
                      f.FECHA_PAGO, f.status_des STATUS, f.TOTAL_APORTE_EMPLEADOR_SVDS, f.TOTAL_APORTE_AFILIADOS_SVDS,
                                f.TOTAL_APORTE_EMPLEADOR_SFS, f.TOTAL_APORTE_AFILIADOS_SFS, f.TOTAL_APORTE_VOLUNTARIO, f.TOTAL_APORTE_SRL,
                                f.TOTAL_RECARGOS_FACTURA, f.TOTAL_INTERES_FACTURA, f.Total_Importe, f.TOTAL_GENERAL_FACTURA, v_cant_referencias as Cant_Referencias
                        FROM sfc_facturas_v f, SRE_EMPLEADORES_T e, SRE_NOMINAS_T n
                        WHERE e.RNC_O_CEDULA = p_RNCoCedula
                        AND f.id_registro_patronal = e.id_registro_patronal
                        AND f.id_registro_patronal = n.id_registro_patronal
                        AND f.id_nomina = n.id_nomina
                        ORDER BY f.periodo_factura DESC, f.id_nomina
                    )y) select y.recordcount,x.*
                    from x,(select max(num) recordcount from x) y
                    where num between vDesde and vHasta
                    order by num;
                END IF;
    
                IF p_concepto =  v_tt_ISR THEN
                BEGIN
                    SELECT count(NVL(l.ID_REFERENCIA_ISR, '0')) INTO v_cant_referencias
                    FROM sfc_liquidacion_isr_v l, SRE_EMPLEADORES_T e
                    WHERE e.RNC_O_CEDULA = p_RNCoCedula
                    AND l.ID_REGISTRO_PATRONAL = e.id_registro_patronal;
    
                    OPEN p_iocursor FOR
                    with x as (select rownum num,y.* from (
                        SELECT  l.id_referencia_isr id_referencia, l.id_nomina as id_nomina, 'Liquidacion ISR' nomina_des, ' ' tipo_nomina,
                                Srp_Pkg.FORMATEAPERIODO(l.periodo_liquidacion) periodo_factura, l.TOTAL_A_PAGAR total_general, e.razon_social, l.FECHA_EMISION fecha_emision,
                              l.fecha_pago, l.status_des STATUS, 'Detalle Factura' AS detalles, v_cant_referencias as Cant_Referencias, ' ' TOTAL_RECARGOS_FACTURA, ' ' TOTAL_INTERES_FACTURA, ' ' Total_Importe
                        FROM sfc_liquidacion_isr_v l, SRE_EMPLEADORES_T e, SRE_NOMINAS_T n
                        WHERE e.RNC_O_CEDULA = p_RNCoCedula
                        AND l.id_registro_patronal = e.id_registro_patronal
                        AND l.id_registro_patronal = n.id_registro_patronal
                        AND l.id_nomina = n.id_nomina
                        ORDER BY l.id_nomina, l.periodo_liquidacion DESC, l.FECHA_EMISION DESC, l.status
                    )y) select y.recordcount,x.*
                    from x,(select max(num) recordcount from x) y
                    where num between vDesde and vHasta
                    order by num;
                END;
                END IF;
    
                IF p_concepto =  v_tt_IR17 THEN
                BEGIN
                    SELECT count(NVL(i.ID_REFERENCIA_IR17, '0')) INTO v_cant_referencias
                    FROM sfc_liquidacion_ir17_v i, SRE_EMPLEADORES_T e
                    WHERE e.RNC_O_CEDULA = p_RNCoCedula
                    AND i.ID_REGISTRO_PATRONAL = e.id_registro_patronal;
    
                    OPEN p_iocursor FOR
                    with x as (select rownum num,y.* from (
                        SELECT i.id_referencia_ir17 id_referencia, Srp_Pkg.FORMATEAPERIODO(I.PERIODO_LIQUIDACION) periodo_factura,
                        I.LIQUIDACION total_general, e.razon_social, i.FECHA_EMISION fecha_emision, i.FECHA_PAGO, i.status_des STATUS,
                        ' ' Nomina_des, ' ' tipo_nomina, 'Detalle Factura' AS detalles, v_cant_referencias as Cant_Referencias,' ' TOTAL_RECARGOS_FACTURA, ' ' TOTAL_INTERES_FACTURA, ' ' Total_Importe
                        FROM sfc_liquidacion_ir17_v i, SRE_EMPLEADORES_T e
                        WHERE e.RNC_O_CEDULA = p_RNCoCedula
                        AND i.ID_REGISTRO_PATRONAL = e.id_registro_patronal
                        ORDER BY i.PERIODO_LIQUIDACION DESC, i.FECHA_EMISION DESC, i.STATUS
                    )y) select y.recordcount,x.*
                    from x,(select max(num) recordcount from x) y
                    where num between vDesde and vHasta
                    order by num;
                END;
                END IF;
    
                IF p_concepto =  v_tt_INF THEN
                BEGIN
                    SELECT count(NVL(i.ID_REFERENCIA_INFOTEP, '0')) INTO v_cant_referencias
                    FROM sfc_liquidacion_infotep_t i, SRE_EMPLEADORES_T e
                    WHERE e.RNC_O_CEDULA = p_RNCoCedula
                    AND i.ID_REGISTRO_PATRONAL = e.id_registro_patronal;
    
                    OPEN p_iocursor FOR
                    with x as (select rownum num,y.* from (
                        SELECT i.id_referencia_infotep id_referencia, Srp_Pkg.FORMATEAPERIODO(I.PERIODO_LIQUIDACION) periodo_factura,
                        I.TOTAL_PAGO_INFOTEP total_general, e.razon_social, i.FECHA_EMISION fecha_emision, i.FECHA_PAGO
                        ,decode(i.status,'PA','Pagada','VE','Vencida','VI','Vigente','PE','pendiente','CA','Cancelada','EX','Exenta',i.status) STATUS,
                        ' ' Nomina_des, ' ' tipo_nomina, 'Detalle Factura' AS detalles, v_cant_referencias as Cant_Referencias, ' ' TOTAL_RECARGOS_FACTURA, ' ' TOTAL_INTERES_FACTURA, ' ' Total_Importe
                        FROM suirplus.sfc_liquidacion_infotep_t i, SRE_EMPLEADORES_T e
                        WHERE e.RNC_O_CEDULA = p_RNCoCedula
                        AND i.ID_REGISTRO_PATRONAL = e.id_registro_patronal
                        ORDER BY i.PERIODO_LIQUIDACION DESC, i.FECHA_EMISION DESC, i.STATUS
                    )y) select y.recordcount,x.*
                    from x,(select max(num) recordcount from x) y
                    where num between vDesde and vHasta
                    order by num;
                END;
                END IF;
    
            ELSE
                IF p_concepto =  v_tt_SDSS THEN
                    SELECT count(NVL(f.id_referencia, '0')) INTO v_cant_referencias
                    FROM sfc_facturas_v f, SRE_EMPLEADORES_T e
                    WHERE e.RNC_O_CEDULA = p_RNCoCedula
                    AND f.id_registro_patronal = e.id_registro_patronal;
    
                    OPEN p_iocursor FOR
                    with x as (select rownum num,y.* from (
                        SELECT  f.id_referencia id_referencia, f.id_nomina as id_nomina, Srp_Pkg.ProperCase(n.nomina_des) nomina_des, DECODE(f.tipo_nomina, 'N' , 'NOR' , 'P' , 'PEN' , 'D' , 'DIS' ) tipo_nomina,
                                Srp_Pkg.FORMATEAPERIODO(f.periodo_factura) periodo_factura, f.total_general_factura total_general, e.razon_social, f.FECHA_EMISION fecha_emision,
                      f.FECHA_PAGO, f.STATUS_des status, f.TOTAL_APORTE_EMPLEADOR_SVDS, f.TOTAL_APORTE_AFILIADOS_SVDS,
                                f.TOTAL_APORTE_EMPLEADOR_SFS, f.TOTAL_APORTE_AFILIADOS_SFS, f.TOTAL_APORTE_VOLUNTARIO, f.TOTAL_APORTE_SRL,
                                'Detalle Factura' AS detalles,v_cant_referencias as Cant_Referencias, f.TOTAL_RECARGOS_FACTURA, f.TOTAL_INTERES_FACTURA, f.Total_Importe
                        FROM sfc_facturas_v f, SRE_EMPLEADORES_T e, SRE_NOMINAS_T n
                        WHERE e.RNC_O_CEDULA = p_RNCoCedula
                        AND f.id_registro_patronal = e.id_registro_patronal
                        AND f.id_registro_patronal = n.id_registro_patronal
                        --AND f.id_nomina = p_CodigoNomina
                        AND f.id_nomina = n.id_nomina
                        ORDER BY f.periodo_factura DESC, f.id_nomina
                    )y) select y.recordcount,x.*
                    from x,(select max(num) recordcount from x) y
                    where num between vDesde and vHasta
                    order by num;
                END IF;
    
                IF p_concepto =  v_tt_ISR THEN
                BEGIN
                    SELECT count(NVL(l.ID_REFERENCIA_ISR, '0')) INTO v_cant_referencias
                    FROM sfc_liquidacion_isr_v l, SRE_EMPLEADORES_T e
                    WHERE e.RNC_O_CEDULA = p_RNCoCedula
                    AND l.ID_REGISTRO_PATRONAL = e.id_registro_patronal;
    
                    OPEN p_iocursor FOR
                    with x as (select rownum num,y.* from (
                        SELECT l.id_referencia_isr id_referencia, l.id_nomina as id_nomina, 'Liquidacion ISR' nomina_des, ' ' tipo_nomina,
                        Srp_Pkg.FORMATEAPERIODO(l.periodo_liquidacion) periodo_factura, l.TOTAL_A_PAGAR total_general, e.razon_social, l.FECHA_EMISION fecha_emision,
                        l.FECHA_PAGO, l.status_des STATUS, 'Detalle Factura' AS detalles,v_cant_referencias as Cant_Referencias, ' ' TOTAL_RECARGOS_FACTURA, ' ' TOTAL_INTERES_FACTURA, ' ' Total_Importe
                        FROM sfc_liquidacion_isr_v l, SRE_EMPLEADORES_T e, SRE_NOMINAS_T n
                        WHERE e.RNC_O_CEDULA = p_RNCoCedula
                        AND l.id_registro_patronal = e.id_registro_patronal
                        AND l.id_registro_patronal = n.id_registro_patronal
                        --AND l.id_nomina = p_CodigoNomina
                        AND l.id_nomina = n.id_nomina
                        ORDER BY l.id_nomina, l.periodo_liquidacion DESC, l.FECHA_EMISION DESC, l.status
                    )y) select y.recordcount,x.*
                    from x,(select max(num) recordcount from x) y
                    where num between vDesde and vHasta
                    order by num;
                END;
                END IF;
    
                IF p_concepto =  v_tt_IR17 THEN
                BEGIN
                    SELECT count(NVL(i.ID_REFERENCIA_IR17, '0')) INTO v_cant_referencias
                    FROM sfc_liquidacion_ir17_v i, SRE_EMPLEADORES_T e
                    WHERE e.RNC_O_CEDULA = p_RNCoCedula
                    AND i.ID_REGISTRO_PATRONAL = e.id_registro_patronal;
    
                    OPEN p_iocursor FOR
                    with x as (select rownum num,y.* from (
                        SELECT i.id_referencia_ir17 id_referencia, Srp_Pkg.FORMATEAPERIODO(I.PERIODO_LIQUIDACION) periodo_factura, 'Liquidacion IR17' nomina_des, ' ' tipo_nomina,
                        I.LIQUIDACION total_general, e.razon_social, i.FECHA_EMISION fecha_emision, i.FECHA_PAGO, i.status_des STATUS,v_cant_referencias as Cant_Referencias, ' ' TOTAL_RECARGOS_FACTURA, ' ' TOTAL_INTERES_FACTURA, ' ' Total_Importe
                        FROM sfc_liquidacion_ir17_v i, SRE_EMPLEADORES_T e
                        WHERE e.RNC_O_CEDULA = p_RNCoCedula
                        AND i.ID_REGISTRO_PATRONAL = e.id_registro_patronal
                        ORDER BY i.PERIODO_LIQUIDACION DESC, i.FECHA_EMISION DESC, i.STATUS
                    )y) select y.recordcount,x.*
                    from x,(select max(num) recordcount from x) y
                    where num between vDesde and vHasta
                    order by num;
                END;
                END IF;
    
                IF p_concepto =  v_tt_INF THEN
                BEGIN
                    SELECT count(NVL(i.ID_REFERENCIA_INFOTEP, '0')) INTO v_cant_referencias
                    FROM suirplus.sfc_liquidacion_infotep_t i, SRE_EMPLEADORES_T e
                    WHERE e.RNC_O_CEDULA = p_RNCoCedula
                    AND i.ID_REGISTRO_PATRONAL = e.id_registro_patronal;
    
                    OPEN p_iocursor FOR
                    with x as (select rownum num,y.* from (
                        SELECT i.id_referencia_infotep id_referencia, Srp_Pkg.FORMATEAPERIODO(I.PERIODO_LIQUIDACION) periodo_factura, 'Liquidacion INFOTEP' nomina_des, ' ' tipo_nomina,' ' detalles,
                        I.TOTAL_PAGO_INFOTEP total_general, e.razon_social, i.FECHA_EMISION fecha_emision, i.FECHA_PAGO
                        ,decode(i.status,'PA','Pagada','VE','Vencida','VI','Vigente','PE','pendiente','CA','Cancelada','EX','Exenta',i.status) STATUS,v_cant_referencias as Cant_Referencias, ' ' TOTAL_RECARGOS_FACTURA, ' ' TOTAL_INTERES_FACTURA, ' ' Total_Importe
                        FROM suirplus.sfc_liquidacion_infotep_t i, SRE_EMPLEADORES_T e
                        WHERE e.RNC_O_CEDULA = p_RNCoCedula
                        AND i.ID_REGISTRO_PATRONAL = e.id_registro_patronal
                        ORDER BY i.PERIODO_LIQUIDACION DESC, i.FECHA_EMISION DESC, i.STATUS
                    )y) select y.recordcount,x.*
                    from x,(select max(num) recordcount from x) y
                    where num between vDesde and vHasta
                    order by num;
                END;
                END IF;
    
            END IF;
    
       ELSE
            IF p_CodigoNomina = 6321 THEN
                IF p_concepto =  v_tt_SDSS THEN
                    SELECT count(NVL(f.id_referencia, '0')) INTO v_cant_referencias
                    FROM sfc_facturas_v f, SRE_EMPLEADORES_T e
                    WHERE e.RNC_O_CEDULA = p_RNCoCedula
                    AND f.id_registro_patronal = e.id_registro_patronal
                    AND f.status = p_Status;
    
                    OPEN p_iocursor FOR
                    with x as (select rownum num,y.* from (
                        SELECT f.id_referencia id_referencia, f.id_nomina as id_nomina, Srp_Pkg.ProperCase(n.nomina_des) nomina_des, DECODE(f.tipo_nomina, 'N' , 'NOR' , 'P' , 'PEN' , 'D' , 'DIS' ) tipo_nomina,
                        Srp_Pkg.FORMATEAPERIODO(f.periodo_factura) periodo_factura, f.total_general_factura total_general, e.razon_social, f.FECHA_EMISION fecha_emision,
              f.FECHA_PAGO, f.status_des STATUS, f.TOTAL_APORTE_EMPLEADOR_SVDS, f.TOTAL_APORTE_AFILIADOS_SVDS,
                        f.TOTAL_APORTE_EMPLEADOR_SFS, f.TOTAL_APORTE_AFILIADOS_SFS, f.TOTAL_APORTE_VOLUNTARIO, f.TOTAL_APORTE_SRL,
                        f.TOTAL_RECARGOS_FACTURA, f.TOTAL_INTERES_FACTURA, f.Total_Importe, f.TOTAL_GENERAL_FACTURA, 'Detalle Factura' AS detalles,v_cant_referencias as Cant_Referencias
                        FROM sfc_facturas_v f, SRE_EMPLEADORES_T e, SRE_NOMINAS_T n
                        WHERE e.RNC_O_CEDULA = p_RNCoCedula
                        AND f.id_registro_patronal = e.id_registro_patronal
                        AND f.id_registro_patronal = n.id_registro_patronal
                        AND f.id_nomina = n.id_nomina
                        AND f.status = p_Status
                        ORDER BY f.periodo_factura DESC, f.id_nomina
                    )y) select y.recordcount,x.*
                    from x,(select max(num) recordcount from x) y
                    where num between vDesde and vHasta
                    order by num;
                END IF;
    
                IF p_concepto =  v_tt_ISR THEN
                BEGIN
                    SELECT count(NVL(l.ID_REFERENCIA_ISR, '0')) INTO v_cant_referencias
                    FROM sfc_liquidacion_isr_v l, SRE_EMPLEADORES_T e
                    WHERE e.RNC_O_CEDULA = p_RNCoCedula
                    AND l.id_registro_patronal = e.id_registro_patronal
                    AND l.status = p_Status;
    
                    OPEN p_iocursor FOR
                    with x as (select rownum num,y.* from (
                        SELECT l.id_referencia_isr id_referencia, l.id_nomina as id_nomina, 'Liquidacion ISR' nomina_des, ' ' tipo_nomina,
                        Srp_Pkg.FORMATEAPERIODO(l.periodo_liquidacion) periodo_factura, l.TOTAL_A_PAGAR total_general, e.razon_social, l.FECHA_EMISION fecha_emision,
              l.fecha_pago, l.status_des STATUS, 'Detalle Factura' AS detalles,v_cant_referencias as Cant_Referencias,
                        ' ' TOTAL_RECARGOS_FACTURA, ' ' TOTAL_INTERES_FACTURA, ' ' Total_Importe
                        FROM sfc_liquidacion_isr_v l, SRE_EMPLEADORES_T e, SRE_NOMINAS_T n
                        WHERE e.RNC_O_CEDULA = p_RNCoCedula
                        AND l.id_registro_patronal = e.id_registro_patronal
                        AND l.id_registro_patronal = n.id_registro_patronal
                        AND l.id_nomina = n.id_nomina
                        AND l.status = p_Status
                        ORDER BY l.id_nomina, l.periodo_liquidacion DESC, l.FECHA_EMISION DESC, l.status
                    )y) select y.recordcount,x.*
                    from x,(select max(num) recordcount from x) y
                    where num between vDesde and vHasta
                    order by num;
    
                END;
                END IF;
    
                IF p_concepto =  v_tt_IR17 THEN
                BEGIN
                    SELECT count(NVL(i.ID_REFERENCIA_IR17, '0')) INTO v_cant_referencias
                    FROM sfc_liquidacion_ir17_v i, SRE_EMPLEADORES_T e
                    WHERE e.RNC_O_CEDULA = p_RNCoCedula
                    AND i.ID_REGISTRO_PATRONAL = e.id_registro_patronal
                    AND i.status = p_Status;
    
                    OPEN p_iocursor FOR
                    with x as (select rownum num,y.* from (
                        SELECT i.id_referencia_ir17 id_referencia, Srp_Pkg.FORMATEAPERIODO(I.PERIODO_LIQUIDACION) periodo_factura, 'Liquidacion IR17' nomina_des, ' ' tipo_nomina,
                        I.LIQUIDACION total_general, e.razon_social, i.FECHA_EMISION fecha_emision, i.FECHA_PAGO,
                        i.status_des STATUS,v_cant_referencias as Cant_Referencias,
                        'Detalle Factura' AS detalles, ' ' TOTAL_RECARGOS_FACTURA, ' ' TOTAL_INTERES_FACTURA, ' ' Total_Importe
                        FROM sfc_liquidacion_ir17_v i, SRE_EMPLEADORES_T e
                        WHERE e.RNC_O_CEDULA = p_RNCoCedula
                        AND i.ID_REGISTRO_PATRONAL = e.id_registro_patronal
                        AND i.status = p_Status
                        ORDER BY i.PERIODO_LIQUIDACION DESC, i.FECHA_EMISION DESC, i.STATUS
                    )y) select y.recordcount,x.*
                    from x,(select max(num) recordcount from x) y
                    where num between vDesde and vHasta
                    order by num;
                END;
                END IF;
    
                IF p_concepto =  v_tt_INF THEN
                BEGIN
                    SELECT count(NVL(i.ID_REFERENCIA_INFOTEP, '0')) INTO v_cant_referencias
                    FROM suirplus.sfc_liquidacion_infotep_t i, SRE_EMPLEADORES_T e
                    WHERE e.RNC_O_CEDULA = p_RNCoCedula
                    AND i.ID_REGISTRO_PATRONAL = e.id_registro_patronal
                    AND i.status = p_Status;
    
                    OPEN p_iocursor FOR
                    with x as (select rownum num,y.* from (
                        SELECT i.id_referencia_infotep id_referencia, Srp_Pkg.FORMATEAPERIODO(I.PERIODO_LIQUIDACION) periodo_factura, 'Liquidacion INFOTEP' nomina_des, ' ' tipo_nomina, ' ' detalles,
                        I.Total_Pago_Infotep total_general, e.razon_social, i.FECHA_EMISION fecha_emision, i.FECHA_PAGO,
                        decode(i.status,'PA','Pagada','VE','Vencida','VI','Vigente','PE','pendiente','CA','Cancelada','EX','Exenta',i.status) STATUS,v_cant_referencias as Cant_Referencias,
                        ' ' TOTAL_RECARGOS_FACTURA, ' ' TOTAL_INTERES_FACTURA, ' ' Total_Importe
                        FROM suirplus.sfc_liquidacion_infotep_t i, SRE_EMPLEADORES_T e
                        WHERE e.RNC_O_CEDULA = p_RNCoCedula
                        AND i.ID_REGISTRO_PATRONAL = e.id_registro_patronal
                        AND i.status = p_Status
                        ORDER BY i.PERIODO_LIQUIDACION DESC, i.FECHA_EMISION DESC, i.STATUS
                    )y) select y.recordcount,x.*
                    from x,(select max(num) recordcount from x) y
                    where num between vDesde and vHasta
                    order by num;
                END;
                END IF;
    
            ELSE
                IF p_concepto =  v_tt_SDSS THEN
                    SELECT count(NVL(f.id_referencia, '0')) INTO v_cant_referencias
                    FROM sfc_facturas_v f, SRE_EMPLEADORES_T e
                    WHERE e.RNC_O_CEDULA = p_RNCoCedula
                    AND f.id_registro_patronal = e.id_registro_patronal
                    AND f.status = p_Status;
    
                    OPEN p_iocursor FOR
                    with x as (select rownum num,y.* from (
                        SELECT f.id_referencia id_referencia, f.id_nomina as id_nomina, Srp_Pkg.ProperCase(n.nomina_des) nomina_des, DECODE(f.tipo_nomina, 'N' , 'NOR' , 'P' , 'PEN' , 'D' , 'DIS' ) tipo_nomina,
                        Srp_Pkg.FORMATEAPERIODO(f.periodo_factura) periodo_factura, f.total_general_factura total_general, e.razon_social, f.FECHA_EMISION fecha_emision,
              f.FECHA_PAGO, f.status_des STATUS, f.TOTAL_APORTE_EMPLEADOR_SVDS, f.TOTAL_APORTE_AFILIADOS_SVDS,
                        f.TOTAL_APORTE_EMPLEADOR_SFS, f.TOTAL_APORTE_AFILIADOS_SFS, f.TOTAL_APORTE_VOLUNTARIO, f.TOTAL_APORTE_SRL,
                        f.TOTAL_RECARGOS_FACTURA, f.TOTAL_INTERES_FACTURA, f.Total_Importe, f.TOTAL_GENERAL_FACTURA, 'Detalle Factura' AS detalles,v_cant_referencias as Cant_Referencias
                        FROM sfc_facturas_v f, SRE_EMPLEADORES_T e, SRE_NOMINAS_T n
                        WHERE e.RNC_O_CEDULA = p_RNCoCedula
                        AND f.id_registro_patronal = e.id_registro_patronal
                        AND f.id_registro_patronal = n.id_registro_patronal
                        AND f.id_nomina = p_CodigoNomina
                        AND f.id_nomina = n.id_nomina
                        AND f.status = p_Status
                        ORDER BY f.periodo_factura DESC, f.id_nomina
                    )y) select y.recordcount,x.*
                    from x,(select max(num) recordcount from x) y
                    where num between vDesde and vHasta
                    order by num;
                END IF;
    
                IF p_concepto =  v_tt_ISR THEN
                BEGIN
                    SELECT count(NVL(L.ID_REFERENCIA_ISR, '0')) INTO v_cant_referencias
                    FROM sfc_liquidacion_isr_v l, SRE_EMPLEADORES_T e
                    WHERE e.RNC_O_CEDULA = p_RNCoCedula
                    AND l.id_registro_patronal = e.id_registro_patronal
                    AND l.status = p_Status;
    
                    OPEN p_iocursor FOR
                    with x as (select rownum num,y.* from (
                        SELECT l.id_referencia_isr id_referencia, l.id_nomina as id_nomina, 'Liquidacion ISR' nomina_des, ' ' tipo_nomina,
                        Srp_Pkg.FORMATEAPERIODO(l.periodo_liquidacion) periodo_factura, l.TOTAL_A_PAGAR total_general, e.razon_social, l.FECHA_EMISION fecha_emision,
              l.FECHA_PAGO, l.status_des STATUS, 'Detalle Factura' AS detalles,v_cant_referencias as Cant_Referencias,
                        ' ' TOTAL_RECARGOS_FACTURA, ' ' TOTAL_INTERES_FACTURA, ' ' Total_Importe
                        FROM sfc_liquidacion_isr_v l, SRE_EMPLEADORES_T e, SRE_NOMINAS_T n
                        WHERE e.RNC_O_CEDULA = p_RNCoCedula
                        AND l.id_registro_patronal = e.id_registro_patronal
                        AND l.id_registro_patronal = n.id_registro_patronal
                        AND l.id_nomina = p_CodigoNomina
                        AND l.id_nomina = n.id_nomina
                        AND l.status = p_Status
                        ORDER BY l.id_nomina, l.periodo_liquidacion DESC, l.FECHA_EMISION DESC, l.status
                    )y) select y.recordcount,x.*
                    from x,(select max(num) recordcount from x) y
                    where num between vDesde and vHasta
                    order by num;
                END;
                END IF;
    
                IF p_concepto =  v_tt_IR17 THEN
                BEGIN
                    SELECT count(NVL(I.ID_REFERENCIA_IR17, '0')) INTO v_cant_referencias
                    FROM sfc_liquidacion_ir17_v i, SRE_EMPLEADORES_T e
                    WHERE e.RNC_O_CEDULA = p_RNCoCedula
                    AND i.id_registro_patronal = e.id_registro_patronal
                    AND i.status = p_Status;
    
                    OPEN p_iocursor FOR
                    with x as (select rownum num,y.* from (
                        SELECT i.id_referencia_ir17 id_referencia, Srp_Pkg.FORMATEAPERIODO(I.PERIODO_LIQUIDACION) periodo_factura, 'Liquidacion IR17' nomina_des, ' ' tipo_nomina,
                        I.LIQUIDACION total_general, e.razon_social, i.FECHA_EMISION fecha_emision, i.FECHA_PAGO, i.status_des STATUS,v_cant_referencias as Cant_Referencias,
                        'Detalle Factura' AS detalles, ' ' TOTAL_RECARGOS_FACTURA, ' ' TOTAL_INTERES_FACTURA, ' ' Total_Importe
                        FROM sfc_liquidacion_ir17_v i, SRE_EMPLEADORES_T e
                        WHERE e.RNC_O_CEDULA = p_RNCoCedula
                        AND i.ID_REGISTRO_PATRONAL = e.id_registro_patronal
                        and i.status = p_Status
                        ORDER BY i.PERIODO_LIQUIDACION DESC, i.FECHA_EMISION DESC, i.STATUS
                    )y) select y.recordcount,x.*
                    from x,(select max(num) recordcount from x) y
                    where num between vDesde and vHasta
                    order by num;
                END;
                END IF;
    
                IF p_concepto =  v_tt_INF THEN
                BEGIN
                    SELECT count(NVL(I.ID_REFERENCIA_INFOTEP, '0')) INTO v_cant_referencias
                    FROM suirplus.sfc_liquidacion_infotep_t i, SRE_EMPLEADORES_T e
                    WHERE e.RNC_O_CEDULA = p_RNCoCedula
                    AND i.id_registro_patronal = e.id_registro_patronal
                    AND i.status = p_Status;
    
                    OPEN p_iocursor FOR
                    with x as (select rownum num,y.* from (
                        SELECT i.id_referencia_infotep id_referencia, Srp_Pkg.FORMATEAPERIODO(I.PERIODO_LIQUIDACION) periodo_factura, 'Liquidacion INFOTEP' nomina_des, ' ' tipo_nomina, ' ' detalles,
                        I.Total_Pago_Infotep total_general, e.razon_social, i.FECHA_EMISION fecha_emision, i.FECHA_PAGO,
                        decode(i.status,'PA','Pagada','VE','Vencida','VI','Vigente','PE','pendiente','CA','Cancelada','EX','Exenta',i.status) STATUS,v_cant_referencias as Cant_Referencias,
                        ' ' TOTAL_RECARGOS_FACTURA, ' ' TOTAL_INTERES_FACTURA, ' ' Total_Importe
                        FROM suirplus.sfc_liquidacion_infotep_t i, SRE_EMPLEADORES_T e
                        WHERE e.RNC_O_CEDULA = p_RNCoCedula
                        AND i.ID_REGISTRO_PATRONAL = e.id_registro_patronal
                        and i.status = p_Status
                        ORDER BY i.PERIODO_LIQUIDACION DESC, i.FECHA_EMISION DESC, i.STATUS
                    )y) select y.recordcount,x.*
                    from x,(select max(num) recordcount from x) y
                    where num between vDesde and vHasta
                    order by num;
                END;
                END IF;
            END IF;
       END IF;
       -- ------------------------------------------------------------------------------------------------------------------
       HASTA AQUI NO BORRAR NI DESCOMENTAR
       -- ------------------------------------------------------------------------------------------------------------------
    */
    p_resultnumber := '0';
  EXCEPTION
  
    WHEN OTHERS THEN
      v_bd_error     := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultnumber := Seg_Retornar_Cadena_Error(-1, v_bd_error, SQLCODE);
      RETURN;
    
  END;

  PROCEDURE SetFechaLimitePagoAcuerdo(p_id_referencia             in varchar2,
                                      p_fecha_limite_pago_acuerdo in date,
                                      p_resultnumber              OUT VARCHAR2) is
    conteo number(9);
  begin
    select count(*)
      into conteo
      from suirplus.sfc_facturas_t f
     where f.id_referencia = p_id_referencia;
  
    if (conteo = 0) then
      p_resultnumber := '16|El No. Referencia especificado no existe.';
    else
      select count(*)
        into conteo
        from sfc_facturas_t f
       where f.id_referencia = p_id_referencia
         and f.status in ('VI', 'VE')
         and f.no_autorizacion is null
         and f.id_tipo_factura = 'Y';
      if (conteo = 0) then
        p_resultnumber := '503|Referencia inválida';
      else
        -- hasta aqui todo bien, actualizar
        update suirplus.sfc_facturas_t a
           set a.fecha_limite_acuerdo_pago = p_fecha_limite_pago_acuerdo
         where a.id_referencia = p_id_referencia;
        commit;
        p_resultNumber := '0';
      end if;
    end if;
  exception
    when others then
      p_resultNumber := '650|Error al actualizar Fecha Limite de Pago Acuerdo: ' ||
                        sqlerrm;
  end;

  ------------------------------------------------------------
  -- Devuelve un cursor con las referencias pendientes de pago
  -- Autor: Roberto Jaquez
  ------------------------------------------------------------
  Procedure LasRefsDisponiblesParaPago(p_rnc_o_cedula     in suirplus.sre_empleadores_t.rnc_o_cedula%type,
                                       p_concepto         in varchar2,
                                       p_razon_social     out suirplus.sre_empleadores_t.razon_social%type,
                                       p_nombre_comercial out suirplus.sre_empleadores_t.nombre_comercial%type,
                                       p_IOCursor         out t_Cursor,
                                       p_resultnumber     out varchar2) is
    v_conteo number(9);
    v_regpat number(9);
    v_pervig number(6);
  
    --  qry varchar2(32000);
    min_per    number(6);
    conteo     number(6);
    FormaParte number(6);
  begin
    v_pervig       := suirplus.parm.periodo_vigente();
    p_resultnumber := '0';
  
    select count(*)
      into v_conteo
      from suirplus.sre_empleadores_t r
     where rnc_o_cedula = p_rnc_o_cedula
       and r.id_registro_patronal not in
           (Select a.id_registro_patronal
              from lgl_acuerdos_t a
             where a.status in (1, 2));
  
    if (v_conteo = 0) then
      p_resultnumber := '64|Este Rnc o Cédula  no existe o no esta registrado';
    else
      select id_registro_patronal, razon_social, nombre_comercial
        into v_regpat, p_razon_social, p_nombre_comercial
        from suirplus.sre_empleadores_t
       where rnc_o_cedula = p_rnc_o_cedula;
    
      if p_concepto = v_tt_SDSS then
        -- v_tt_SDSS
        identificar_refs_para_pago(v_regpat);
      
        open p_IOCursor for
          select id_referencia   as referencia,
                 periodo_factura as periodo,
                 total_general,
                 nomina_des      as Nomina,
                 sino            as puede_pagar
            from sfc_acuerdo_pago
           where id_registro_patronal = v_regpat
           order by nomina_des, periodo_factura;
      
      elsif p_concepto = v_tt_ISR then
        -- v_tt_ISR
        open p_IOCursor for
          with mas_vieja as
           (select min(f.periodo_liquidacion) periodo
              from suirplus.sfc_liquidacion_isr_v f
             where f.id_registro_patronal = v_regpat
               and f.status not in ('CA', 'PA', 'EX', 'PE')
               and f.NO_AUTORIZACION is null)
          select f.ID_REFERENCIA_ISR referencia,
                 f.PERIODO_LIQUIDACION periodo,
                 'NOMINA GENERAL' nomina,
                 f.TOTAL_A_PAGAR total_general,
                 case
                   when j.periodo = f.periodo_liquidacion then
                    'S'
                   else
                    'S'
                 end puede_pagar
            from suirplus.sfc_liquidacion_isr_v f
            left join mas_vieja j
              on j.periodo = f.periodo_liquidacion
           where f.id_registro_patronal = v_regpat
             and f.status not in ('CA', 'PA', 'EX', 'PE')
             and f.NO_AUTORIZACION is null;
      elsif p_concepto = v_tt_IR17 then
        -- v_tt_IR17
        open p_IOCursor for
          select f.ID_REFERENCIA_IR17 referencia,
                 f.PERIODO_LIQUIDACION periodo,
                 'NOMINA GENERAL' nomina,
                 f.LIQUIDACION total_general,
                 'S' puede_pagar
            from suirplus.sfc_liquidacion_ir17_v f
           where f.id_registro_patronal = v_regpat
             and f.status = 'VI'
             and f.NO_AUTORIZACION is null;
      elsif p_concepto = v_tt_DGII then
        -- v_tt_DGII
        open p_IOCursor for
          with mas_vieja as
           (select min(f.periodo_liquidacion) periodo
              from suirplus.sfc_liquidacion_isr_v f
             where f.id_registro_patronal = v_regpat
               and f.status not in ('CA', 'PA', 'EX', 'PE')
               and f.NO_AUTORIZACION is null)
          select f.ID_REFERENCIA_ISR referencia,
                 f.PERIODO_LIQUIDACION periodo,
                 'NOMINA GENERAL' nomina,
                 f.TOTAL_A_PAGAR total_general,
                 case
                   when j.periodo = f.periodo_liquidacion then
                    'S'
                   else
                    'S'
                 end puede_pagar
            from suirplus.sfc_liquidacion_isr_v f
            left join mas_vieja j
              on j.periodo = f.periodo_liquidacion
           where f.id_registro_patronal = v_regpat
             and f.status not in ('CA', 'PA', 'EX', 'PE')
             and f.NO_AUTORIZACION is null
          union all
          select f.ID_REFERENCIA_IR17 referencia,
                 f.PERIODO_LIQUIDACION periodo,
                 'NOMINA GENERAL' nomina,
                 f.LIQUIDACION total_general,
                 'S' puede_pagar
            from suirplus.sfc_liquidacion_ir17_v f
           where f.id_registro_patronal = v_regpat
             and f.status = 'VI'
             and f.NO_AUTORIZACION is null;
      elsif p_concepto = v_tt_INF then
        -- v_tt_INF
        open p_IOCursor for
          with mas_vieja as
           (select min(f.periodo_liquidacion) periodo
              from suirplus.sfc_liquidacion_infotep_t f
             where f.id_registro_patronal = v_regpat
               and f.status in ('VI', 'VE')
               and f.NO_AUTORIZACION is null)
          select f.id_referencia_infotep referencia,
                 f.periodo_liquidacion periodo,
                 'NOMINA GENERAL' nomina,
                 f.total_pago_infotep total_general,
                 case
                   when j.periodo = f.periodo_liquidacion then
                    'S'
                   else
                    'N'
                 end puede_pagar
            from suirplus.sfc_liquidacion_infotep_t f
            left join mas_vieja j
              on j.periodo = f.periodo_liquidacion
           where f.id_registro_patronal = v_regpat
             and f.status in ('VI', 'VE')
             and f.NO_AUTORIZACION is null;
      
        /*rj 8/apr/2008
                select f.id_referencia_infotep referencia,
                       f.periodo_liquidacion periodo,
                       'NOMINA GENERAL' nomina,
                       f.total_pago_infotep total_general,
                       'S' puede_pagar
                from suirplus.sfc_liquidacion_infotep_t f
                where f.id_registro_patronal=v_regpat
                and f.status in ('VI','VE')
                and f.NO_AUTORIZACION is null;
        rj 8/apr/2008 */
      end if;
    end if;
  end;

  ------------------------------------------------------------
  -- Devuelve un cursor con las referencias pendientes de pago
  -- Autor: Roberto Jaquez y Gregorio Herrera
  ------------------------------------------------------------
  Procedure LasRefsDisponiblesParaPagoWS(p_rnc_o_cedula in suirplus.sre_empleadores_t.rnc_o_cedula%type,
                                         p_concepto     in varchar2,
                                         p_IOCursor     out t_Cursor,
                                         p_resultnumber out varchar2) is
    v_conteo number(9);
    v_regpat number(9);
  
    qry     varchar2(32000);
    min_per number(6);
    conteo  number(6);
  
    /*
      procedure add(referencia varchar2) is
        vPer    suirplus.sfc_facturas_v.periodo_factura%type;
        vTot    suirplus.sfc_facturas_v.TOTAL_GENERAL_FACTURA%type;
        vNomDes suirplus.sre_nominas_t.nomina_des%type;
        vidNom  suirplus.sre_nominas_t.id_nomina%type;
        vRazon  suirplus.sre_empleadores_t.razon_social%type;
        vRNC    suirplus.sre_empleadores_t.rnc_o_cedula%type;
      begin
        select f.PERIODO_FACTURA, f.TOTAL_GENERAL_FACTURA, f.ID_NOMINA, n.nomina_des, e.razon_social, e.rnc_o_cedula
        into vPer, vTot, vidNom, vNomDes, vRazon, vRNC
        from suirplus.sfc_facturas_v f
        join suirplus.sre_nominas_t n
        on n.id_registro_patronal=f.ID_REGISTRO_PATRONAL and n.ID_NOMINA=f.ID_NOMINA
        join suirplus.sre_empleadores_t e
        on e.id_registro_patronal = f.ID_REGISTRO_PATRONAL
        where f.ID_REFERENCIA = referencia;
    
        if (qry is not null) then
          qry := qry||' union all';
        end if;
        qry := qry||' select '''||referencia||''' id_referencia,'||
                   vidNom ||' id_nomina,'''||
                   vNomDes||''' nomina_des,'||
                   vPer   ||' periodo_factura,'||
                   vTot   ||' total_general,'''||
                   vRazon ||''' razon_social,'''||
                   vRNC   ||''' rnc_o_cedula from dual ';
      end;
    */
  begin
    p_resultnumber := '0';
  
    select count(*)
      into v_conteo
      from suirplus.sre_empleadores_t
     where rnc_o_cedula = p_rnc_o_cedula;
  
    if (v_conteo = 0) then
      p_resultnumber := '64|Este Rnc o Cédula  no existe o no esta registrado';
    else
    
      select id_registro_patronal
        into v_regpat
        from suirplus.sre_empleadores_t
       where rnc_o_cedula = p_rnc_o_cedula;
    
      if p_concepto = v_tt_SDSS then
        -- v_tt_SDSS
        /*
              for facturas in (select f.id_referencia,f.status,f.id_tipo_factura,id_nomina,
                                      f.periodo_factura,f.fecha_limite_pago
                               from suirplus.sfc_facturas_t f
                               where f.id_registro_patronal=v_regpat
                               and f.status in('VI','VE')
                               and f.no_autorizacion is null
                               and f.id_referencia not in (
                                 select f.id_referencia  -- que no salgan facturas de acuedos que no han sido aprobados
                                 from suirplus.lgl_acuerdos_t a
                                 join suirplus.sfc_facturas_t f
                                 on f.ID_REGISTRO_PATRONAL=a.id_registro_patronal
                                 and f.ID_TIPO_FACTURA='Y'
                                 where a.id_registro_patronal=v_regpat
                                 and a.status not in(3,4)
                               ))
              loop
                if (facturas.status='VE') then
                  -- si esta vencida
                  if (facturas.id_tipo_factura='Y') then
                    -- es de acuerdo de pago
                    select min(f.PERIODO_FACTURA)
                    into min_per
                    from suirplus.sfc_facturas_v f
                    where f.id_registro_patronal=v_regpat
                    and f.id_nomina=facturas.id_nomina
                    and f.status in ('VE','VI')
                    and f.id_tipo_factura='Y'
                    and f.NO_AUTORIZACION is null;
                  else
                    -- no es de acuerdo de pago
                    select min(f.PERIODO_FACTURA)
                    into min_per
                    from suirplus.sfc_facturas_v f
                    where f.id_registro_patronal=v_regpat
                    and f.id_nomina=facturas.id_nomina
                    and f.status in ('VE','VI')
                    and f.id_tipo_factura<>'Y'
                    and f.NO_AUTORIZACION is null;
                  end if;
        
                  -- si es la primera de dicha nomina, mostrarla
                  if facturas.periodo_factura = min_per then
                    add(facturas.id_referencia);
                  end if;
                else
                  -- es una factura vigente, mostrar si pagaron las cuotas del mes
                  select count(*) into conteo
                  from sfc_facturas_t f
                  where f.id_registro_patronal =v_regpat
                  and f.id_nomina = facturas.id_nomina
                  and f.id_tipo_factura='Y'
                  and f.status='VE'
                  and f.no_autorizacion is null
                  and f.fecha_limite_acuerdo_pago = facturas.fecha_limite_pago;
        
                  if conteo=0 then
                    add(facturas.id_referencia);
                  end if;
                end if;
              end loop;
        
        */
        -- si esta nulo, preparar qry con los mismos campos que no devuelva datos (from duakl whwre 1=2)
        identificar_refs_para_pago(v_regpat);
      
        select count(*)
          into conteo
          from sfc_acuerdo_pago
         where id_registro_patronal = v_regpat;
      
        If conteo = 0 then
          open p_IOCursor for
            select ' ' referencia,
                   ' ' id_nomina,
                   ' ' nomina_des,
                   ' ' periodo_factura,
                   ' ' total_general,
                   ' ' razon_social,
                   ' ' rnc_o_cedula
              from dual;
        else
          open p_IOCursor for
            select f.ID_REFERENCIA,
                   f.ID_NOMINA,
                   n.nomina_des,
                   f.PERIODO_FACTURA,
                   f.TOTAL_GENERAL_FACTURA TOTAL_GENERAL,
                   e.razon_social,
                   e.rnc_o_cedula
              from suirplus.sfc_facturas_v f
              join suirplus.sre_empleadores_t e
                on e.id_registro_patronal = f.ID_REGISTRO_PATRONAL
              join suirplus.sre_nominas_t n
                on n.id_registro_patronal = f.ID_REGISTRO_PATRONAL
               and n.id_nomina = f.ID_NOMINA
             where f.ID_REFERENCIA in
                   (select a.id_referencia
                      from suirplus.sfc_acuerdo_pago a
                     where a.id_registro_patronal = v_regpat
                       and a.sino = 'S');
        End if;
      elsif p_concepto = v_tt_ISR then
        -- v_tt_ISR
        open p_IOCursor for
          select f.ID_REFERENCIA_ISR referencia,
                 f.PERIODO_LIQUIDACION periodo,
                 'NOMINA GENERAL' nomina,
                 f.TOTAL_A_PAGAR total_general,
                 'S' puede_pagar
            from suirplus.sfc_liquidacion_isr_v f
           where f.id_registro_patronal = v_regpat
             and f.status not in ('CA', 'PA', 'EX', 'PE')
             and f.NO_AUTORIZACION is null;
      elsif p_concepto = v_tt_IR17 then
        -- v_tt_IR17
        open p_IOCursor for
          select f.ID_REFERENCIA_IR17 referencia,
                 f.PERIODO_LIQUIDACION periodo,
                 'NOMINA GENERAL' nomina,
                 f.LIQUIDACION total_general,
                 'S' puede_pagar
            from suirplus.sfc_liquidacion_ir17_v f
           where f.id_registro_patronal = v_regpat
             and f.status = 'VI'
             and f.NO_AUTORIZACION is null;
      elsif p_concepto = v_tt_DGII then
        -- v_tt_DGII
        open p_IOCursor for
          select f.ID_REFERENCIA_ISR referencia,
                 f.PERIODO_LIQUIDACION periodo,
                 'NOMINA GENERAL' nomina,
                 f.TOTAL_A_PAGAR total_general,
                 'S' puede_pagar
            from suirplus.sfc_liquidacion_isr_v f
           where f.id_registro_patronal = v_regpat
             and f.status not in ('CA', 'PA', 'EX', 'PE')
             and f.NO_AUTORIZACION is null
             and f.periodo_liquidacion =
                 (select min(periodo_liquidacion)
                    from suirplus.sfc_liquidacion_isr_v f
                   where f.id_registro_patronal = v_regpat
                     and f.status not in ('CA', 'PA', 'EX', 'PE')
                     and f.NO_AUTORIZACION is null)
          union all
          select f.ID_REFERENCIA_IR17 referencia,
                 f.PERIODO_LIQUIDACION periodo,
                 'NOMINA GENERAL' nomina,
                 f.LIQUIDACION total_general,
                 'S' puede_pagar
            from suirplus.sfc_liquidacion_ir17_v f
           where f.id_registro_patronal = v_regpat
             and f.status = 'VI'
             and f.NO_AUTORIZACION is null;
      elsif p_concepto = v_tt_INF then
        -- v_tt_INF
        open p_IOCursor for
          select f.id_referencia_infotep referencia,
                 f.periodo_liquidacion periodo,
                 'NOMINA GENERAL' nomina,
                 f.total_pago_infotep total_general,
                 'S' puede_pagar
            from suirplus.sfc_liquidacion_infotep_t f
           where f.id_registro_patronal = v_regpat
             and f.status = 'VI'
             and f.NO_AUTORIZACION is null;
      elsif p_concepto = v_tt_MDT then
        -- v_tt_MDT
        open p_IOCursor for
          select f.id_referencia_planilla referencia,
                 f.periodo_liquidacion periodo,
                 f.total_pago total_general,
                 'S' puede_pagar
            from suirplus.sfc_planilla_mdt_t f
           where f.id_registro_patronal = v_regpat
             and f.status = 'VI'
             and f.NO_AUTORIZACION is null;
      end if;
    end if;
  end;

  ---***********************************************
  --- Mayreni Vargas
  --- Procedure para validar que una referencia exista
  ---***********************************************
  procedure isValidaReferencia(p_referencia   IN SFC_FACTURAS_T.ID_REFERENCIA%TYPE,
                               p_concepto     IN VARCHAR2,
                               p_resultnumber OUT VARCHAR2) is
    v_bd_error VARCHAR(1000);
  BEGIN
  
    IF NOT Sfc_Factura_Pkg.isExisteNoReferencia(p_concepto, p_referencia) THEN
      p_resultnumber := 1;
      RETURN;
    END IF;
  
    p_resultnumber := 0;
    RETURN;
  EXCEPTION
    WHEN OTHERS THEN
      v_bd_error     := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultNumber := Seg_Retornar_Cadena_Error(-1, v_bd_error, SQLCODE);
      RETURN;
  end;

  procedure getMontoTotalAjuste(p_NoReferencia IN sfc_det_ajustes_t.id_referencia%TYPE,
                                p_IOCursor     IN OUT t_Cursor,
                                p_resultnumber OUT VARCHAR2) is
    v_bd_error VARCHAR(1000);
    c_cursor   t_cursor;
  begin
  
    OPEN c_cursor FOR
      select b.descripcion as Tipo, sum(a.monto) as Monto
        from sfc_det_ajustes_t a
        join sfc_tipo_ajustes_t b
          on b.id_tipo_ajuste = a.tipo_ajuste
       where a.id_referencia = p_NoReferencia
       group by b.descripcion;
  
    p_IOCursor     := c_cursor;
    p_resultnumber := 0;
  exception
  
    when others then
      v_bd_error     := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultNumber := Seg_Retornar_Cadena_Error(-1, v_bd_error, SQLCODE);
  end getMontoTotalAjuste;

  /*Detalle de Ajuste*/
  PROCEDURE ConsPage_Detalle_Ajuste(p_NoReferencia IN sfc_det_ajustes_t.id_referencia%TYPE,
                                    p_pagenum      in number,
                                    p_pagesize     in number,
                                    p_IOCursor     IN OUT t_Cursor,
                                    p_resultnumber OUT VARCHAR2) is
    e_invalidNoReferencia EXCEPTION;
    v_bd_error VARCHAR(1000);
    c_cursor   t_cursor;
    vDesde     integer := (p_pagesize * (p_pagenum - 1)) + 1;
    vHasta     integer := p_pagesize * p_pagenum;
  begin
    IF p_NoReferencia IS NOT NULL THEN
      OPEN c_cursor FOR
        with x as
         (select rownum num, y.*
            from (
                  
                  Select *
                    from (select a.*,
                                  c.no_documento,
                                  InitCap((c.nombres || ' ' ||
                                          NVL(c.primer_apellido, '') || ' ' ||
                                          NVL(c.segundo_apellido, ''))) nombre,
                                  t.descripcion
                             from sfc_det_ajustes_t a
                             left join sre_ciudadanos_t c
                               on a.id_nss = c.id_nss
                             join sfc_tipo_ajustes_t t
                               on a.tipo_ajuste = t.id_tipo_ajuste
                            where a.id_referencia = p_NoReferencia) e
                   order by e.TIPO_AJUSTE DESC, e.nombre ASC, e.MONTO DESC
                  
                  ) y)
        select y.recordcount, x.*
          from x, (select max(num) recordcount from x) y
         where num between vDesde and vHasta
         order by num;
    
      p_resultnumber := 0;
      p_IOCursor     := c_cursor;
    
    END IF;
  EXCEPTION
    WHEN e_invalidNoReferencia THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(16, NULL, NULL);
      RETURN;
    
    WHEN OTHERS THEN
      v_bd_error     := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultNumber := Seg_Retornar_Cadena_Error(-1, v_bd_error, SQLCODE);
      RETURN;
  end;

  --------------------------------------------------------------------------------------------------------
  -- Get_Det_Liquidacion_ISR
  -- by Kerlin de la cruz
  -- 09-02-2012
  -- Para mostrar el detalle de las Liquidaciones ISR del 201201 en adelante
  --------------------------------------------------------------------------------------------------------
  procedure Get_Det_Liquidacion_ISR(p_rnc_o_cedula     in sre_empleadores_t.rnc_o_cedula%type,
                                    p_periodo          in sfc_liquidacion_isr_v.periodo_liquidacion%type,
                                    p_tipo_liquidacion in sfc_liquidacion_isr_v.id_tipo_factura%type,
                                    p_pagenum          in number,
                                    p_pagesize         in number,
                                    p_io_cursor        IN OUT t_cursor,
                                    p_resultnumber     OUT VARCHAR2) is
  
    v_id_registro_patronal sre_empleadores_t.id_registro_patronal%type;
    v_bderror              varchar2(500);
    vDesde                 integer := (p_pagesize * (p_pagenum - 1)) + 1;
    vHasta                 integer := p_pagesize * p_pagenum;
    v_cursor               t_cursor;
    e_errorRegPatronal exception;
  
  BEGIN
  
    -- Buscamos el R.P del correspondiente a este  RNC --
    select e.id_registro_patronal
      into v_id_registro_patronal
      from sre_empleadores_t e
     where e.rnc_o_cedula = p_rnc_o_cedula;
  
    if not
        sre_empleadores_pkg.Existeregistropatronal(v_id_registro_patronal) then
      raise e_errorRegPatronal;
    end if;
  
    open v_cursor for
      with x as
       (select rownum num, y.*
          from (select c.no_documento,
                       trim(initcap(c.primer_apellido)) || ' ' ||
                       trim(initcap(c.segundo_apellido)) || ',' || ' ' ||
                       trim(initcap(c.nombres)) Nombre,
                       dl.salario_isr,
                       dl.otros_ingresos_isr,
                       dl.ingresos_exentos_isr,
                       dl.remuneracion_isr_otros,
                       (dl.salario_isr + dl.otros_ingresos_isr +
                       dl.ingresos_exentos_isr + dl.remuneracion_isr_otros) Total_pagado,
                       dl.retencion_ss,
                       (dl.salario_isr + dl.otros_ingresos_isr +
                       dl.remuneracion_isr_otros - dl.retencion_ss) Total_sujeto_retencion,
                       dl.saldo_favor_del_periodo
                  from suirplus.dgii_det_liquidacion_isr_v dl
                  join suirplus.sre_ciudadanos_t c
                    on c.id_nss = dl.id_nss
                 where dl.rnc_o_cedula = p_rnc_o_cedula
                   and dl.periodo_aplicacion = p_periodo
                   and dl.id_tipo_factura = p_tipo_liquidacion
                 order by 2 asc) y)
      select y.recordcount, x.*
        from x, (select max(num) recordcount from x) y
       where num between (vdesde) and (vhasta)
       order by num;
  
    p_io_cursor    := v_cursor;
    p_resultnumber := '0';
  
  exception
    when e_errorRegPatronal then
      p_resultnumber := seg_retornar_cadena_error(3, null, null);
    WHEN OTHERS THEN
      v_bderror      := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultnumber := Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
  END;

  --------------------------------------------------------------------------------------------------------
  -- Get_Liquidacion_ISR
  -- by Kerlin de la cruz
  -- 09-02-2012
  -- Para mostrar el detalle de las Liquidaciones ISR del 201201 en adelante
  --------------------------------------------------------------------------------------------------------
  procedure Get_Liquidacion_ISR(p_rnc_o_cedula     in sre_empleadores_t.rnc_o_cedula%type,
                                p_periodo          in sfc_liquidacion_isr_v.periodo_liquidacion%type,
                                p_tipo_liquidacion in sfc_liquidacion_isr_v.id_tipo_factura%type,
                                p_io_cursor        IN OUT t_cursor,
                                p_resultnumber     OUT VARCHAR2) is
  
    v_id_registro_patronal sre_empleadores_t.id_registro_patronal%type;
    v_bderror              varchar2(500);
    v_cursor               t_cursor;
    e_errorRegPatronal exception;
  
  BEGIN
  
    -- Buscamos el R.P del correspondiente a este  RNC --
    select e.id_registro_patronal
      into v_id_registro_patronal
      from sre_empleadores_t e
     where e.rnc_o_cedula = p_rnc_o_cedula;
  
    if not
        sre_empleadores_pkg.Existeregistropatronal(v_id_registro_patronal) then
      raise e_errorRegPatronal;
    end if;
  
    open v_cursor for
      select d.periodo_aplicacion periodo,
             count(distinct(d.id_nss)) Total_asalariados,
             case d.id_tipo_factura
               when 'O' Then
                'Ordinaria'
               when 'R' Then
                'Regenerada por Novedad'
               when 'T' Then
                'Rectificativa'
             end tipo_liquidacion,
             sum(d.salario_isr) Sueldos_Pag_Ag_Re,
             sum(d.ingresos_exentos_isr) Ingresos_exentos,
             sum(d.remuneracion_isr_otros) Rem_otros_agentes,
             sum(d.otros_ingresos_isr) Otras_remuneraciones,
             sum(d.salario_isr + d.otros_ingresos_isr +
                 d.ingresos_exentos_isr + d.remuneracion_isr_otros) Total_pagado,
             sum(d.salario_isr + d.otros_ingresos_isr +
                 d.remuneracion_isr_otros - d.retencion_ss) pago_total_ret,
             sum(d.retencion_ss) retencion_ss
        from suirplus.dgii_det_liquidacion_isr_v d
       where d.rnc_o_cedula = p_rnc_o_cedula
         and d.periodo_aplicacion = p_periodo
         and d.id_tipo_factura = p_tipo_liquidacion
       group by d.periodo_aplicacion, d.id_tipo_factura;
  
    p_io_cursor    := v_cursor;
    p_resultnumber := '0';
  
  exception
    when e_errorRegPatronal then
      p_resultnumber := seg_retornar_cadena_error(3, null, null);
    WHEN OTHERS THEN
      v_bderror      := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultnumber := Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
  END;

  -- **************************************************************************************************
  -- Program:     MarcarReferenciaAuditoriaDefinitiva
  -- Description: Para marcar una referencia de auditoria definitiva
  -- **************************************************************************************************
  PROCEDURE MarcarRefAuditoriaDefinitiva(p_NoReferencia IN SFC_FACTURAS_T.id_referencia%TYPE,
                                         p_idusuario    IN SFC_FACTURAS_T.id_usuario_desautoriza%TYPE,
                                         p_resultnumber OUT VARCHAR2)
  
   IS
    e_invaliduser EXCEPTION;
    e_invalidNoReferencia EXCEPTION;
    v_bd_error VARCHAR(1000);
  
  BEGIN
  
    IF NOT Seg_Usuarios_Pkg.isExisteUsuario(p_idusuario) THEN
      RAISE e_invaliduser;
    END IF;
  
    IF NOT Sfc_Factura_Pkg.isExisteNoReferencia('SDSS', p_NoReferencia) THEN
      RAISE e_invalidNoReferencia;
    END IF;
  
    UPDATE SFC_FACTURAS_T f
       SET f.status_generacion = 'D',
           f.ult_usuario_act   = p_idusuario,
           f.ult_fecha_act     = sysdate
     WHERE f.id_referencia = p_NoReferencia;
  
    p_resultnumber := 0;
  
  EXCEPTION
  
    WHEN e_invaliduser THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(1, NULL, NULL);
      RETURN;
    
    WHEN e_invalidNoReferencia THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(16, NULL, NULL);
      RETURN;
    
    WHEN OTHERS THEN
      v_bd_error     := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultnumber := Seg_Retornar_Cadena_Error(-1, v_bd_error, SQLCODE);
      RETURN;
    
  END MarcarRefAuditoriaDefinitiva;

  ---***********************************************
  --- Eury Vallejo
  --- Procedure para validar que una referencia de tipo Pre-CalculoMDT
  ---***********************************************
  procedure isValidaReferenciaPreCalculo(p_referencia   IN SFC_FACTURAS_T.ID_REFERENCIA%TYPE,
                                         p_resultnumber OUT VARCHAR2) is
    v_bd_error VARCHAR(1000);
    Cant       integer;
    e_errorReferencia exception;
  BEGIN
  
    SELECT count(i.ID_REFERENCIA_PLANILLA)
      into Cant
      FROM suirplus.sfc_planilla_mdt_t i
     WHERE I.ID_REFERENCIA_PLANILLA = p_referencia
       and i.id_tipo_factura = 'P';
  
    if Cant <> 0 then
      raise e_errorReferencia;
    end if;
  
    p_resultnumber := 0;
  
  EXCEPTION
    WHEN e_errorReferencia THEN
      p_resultnumber := Seg_Retornar_Cadena_Error('T31', NULL, NULL);
      RETURN;
    
    WHEN OTHERS THEN
      v_bd_error     := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultNumber := Seg_Retornar_Cadena_Error(-1, v_bd_error, SQLCODE);
      RETURN;
  end;
  
  
  -- **************************************************************************************************
  -- Program:     Cons_Detalle_SIPEN
  -- evallejo:
  --
  -- **************************************************************************************************
/*
  PROCEDURE Cons_Detalle_Sipen(p_NoReferencia IN SFC_FACTURAS_T.id_referencia%TYPE,
                                   p_IOCursor     IN OUT t_Cursor,
                                   p_resultnumber OUT VARCHAR2) IS
    e_invalidNoReferencia EXCEPTION;
    v_bd_error VARCHAR(1000);
    c_cursor   t_cursor;
  BEGIN
  
    IF p_NoReferencia IS NOT NULL THEN
      OPEN c_cursor FOR
        with mov as
         (select z.id_referencia,
                 z.id_nss,
                 nvl(z.periodo_aplicacion, y.periodo_factura) periodo,
                 sum(z.salario_ss) pa_salario_ss,
                 sum(z.aporte_voluntario) pa_aporte_voluntario
            from suirplus.sfc_facturas_v x
            join suirplus.sfc_det_facturas_t w
              on w.id_referencia = x.id_referencia
            join suirplus.sfc_facturas_v y
              on y.id_registro_patronal = x.id_registro_patronal
             and y.periodo_factura = w.periodo_aplicacion
             and y.status = 'PA'
             and y.id_referencia <> x.id_referencia
             and y.fecha_emision <= x.fecha_emision
             and y.fecha_pago <= x.fecha_emision
            join suirplus.sfc_det_facturas_t z
              on z.id_referencia = y.id_referencia
             and z.id_nss = w.id_nss
           where x.id_referencia = p_NoReferencia
           group by z.id_referencia,
                    z.id_nss,
                    nvl(z.periodo_aplicacion, y.periodo_factura))
        SELECT DET.ID_NSS,
               CIU.PRIMER_APELLIDO || ' ' || CIU.SEGUNDO_APELLIDO || ', ' ||
               CIU.NOMBRES NOMBRES,
               DET.PERIODO_APLICACION,
               det.SALARIO_SS AS SALARIO_REPORTADO,
               DET.APORTE_AFILIADOS_SVDS,
               DET.APORTE_EMPLEADOR_SVDS,
               (DET.APORTE_AFILIADOS_SVDS + DET.APORTE_EMPLEADOR_SVDS +
               DET.APORTE_SRL + DET.APORTE_AFILIADOS_SFS +
               DET.APORTE_EMPLEADOR_SFS) AS NUEVO_IMPORTE,
               DET.TOTAL_GENERAL_DET_FACTURA
          FROM suirplus.SFC_FACTURAS_V FAC
          join suirplus.SFC_DET_FACTURAS_V DET
            on det.id_referencia = fac.ID_REFERENCIA
          join suirplus.SRE_CIUDADANOS_T CIU
            on ciu.id_nss = det.id_nss
          left join mov
            on mov.id_nss = det.id_nss
           and mov.periodo = det.periodo_aplicacion
         WHERE FAC.ID_REFERENCIA = p_NoReferencia
         ORDER BY DET.ID_NSS, DET.PERIODO_APLICACION;
    
      p_resultnumber := 0;
      p_IOCursor     := c_cursor;
    
    END IF;
  
  EXCEPTION
  
    WHEN e_invalidNoReferencia THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(16, NULL, NULL);
      RETURN;
    
    WHEN OTHERS THEN
      v_bd_error     := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultNumber := Seg_Retornar_Cadena_Error(-1, v_bd_error, SQLCODE);
      RETURN;
    
  END;
*/  
--**********************************************************
--Asignacion a constantes a utilizar --*
BEGIN
  v_tt_SDSS := 'SDSS';
  v_tt_ISR  := 'ISR';
  v_tt_IR17 := 'IR17';
  v_tt_DGII := 'DGII';
  v_tt_INF  := 'INF';
  v_tt_MDT  := 'MDT';
  v_tt_ISRP := 'ISRP';

END SFC_FACTURA_PKG;
