CREATE OR REPLACE VIEW SUIRPLUS.SFC_FACTURAS_V AS
SELECT a.id_referencia,
          a.id_tipo_factura,
          a.id_registro_patronal,
          a.id_nomina,
          a.id_riesgo,
          a.id_entidad_recaudadora,
          a.fecha_emision,
          a.fecha_limite_pago,
          a.periodo_factura,
          a.fecha_cancela,
          a.id_referencia_origen,
          a.no_autorizacion,
          a.fecha_autorizacion,
          a.fecha_desautorizacion,
          a.id_usuario_autoriza,
          a.id_usuario_desautoriza,
          a.descuento_penalidad,
          a.total_salario_ss,
          a.total_aporte_afiliados_sfs,
          a.total_aporte_empleador_sfs,
          a.total_aporte_afiliados_svds,
          a.total_aporte_empleador_svds,
          a.total_aporte_srl,
          a.total_per_capita_adicional,
          a.total_recargo_svds,
          a.total_interes_srl,
          a.total_interes_afp,
          a.total_interes_cpe,
          a.total_interes_fss,
          a.total_interes_osipen,
          a.total_interes_seguro_vida,
          a.total_recargo_sfs,
          a.total_interes_sfs,
          a.total_recargo_srl,
          a.total_trabajadores,
          a.total_aporte_afiliados_t3,
          a.total_aporte_empleador_t3,
          a.total_aporte_afiliados_idss,
          a.total_recargo_idss,
          a.total_intereses_idss,
          a.total_aporte_empleador_idss,
          a.total_aporte_voluntario,
          a.total_cuenta_personal,
          a.total_seguro_vida,
          a.total_fondo_solidaridad,
          a.total_comision_afp,
          a.total_operacion_sipen,
          a.total_interes_apo,
          a.total_operacion_sisalril_srl,
          a.total_proporcion_arl_srl,
          a.total_cuidado_salud,
          a.total_estancias_infantiles,
          a.total_subsidios_salud,
          a.fecha_pago,
          a.total_operacion_sisalril_sfs,
          a.ult_fecha_act,
          a.ult_usuario_act,
          id_usuario_cancela,
          (a.total_recargo_svds + a.total_recargo_sfs + a.total_recargo_srl)
             total_recargos_factura,
          (  a.total_interes_srl
           + a.total_interes_afp
           + a.total_interes_cpe
           + a.total_interes_fss
           + a.total_interes_osipen
           + a.total_interes_seguro_vida
           + a.total_interes_sfs
           + a.total_interes_apo)
             total_interes_factura,
          (a.total_aporte_afiliados_sfs + a.total_aporte_empleador_sfs)
             total_aporte_sfs,
          (  a.total_aporte_afiliados_svds
           + a.total_aporte_empleador_svds
           + a.total_aporte_afiliados_t3
           + a.total_aporte_empleador_t3
           + a.total_aporte_voluntario)
             total_aporte_svds,
          (  a.total_interes_apo
           + a.total_interes_cpe
           + a.total_interes_fss
           + a.total_interes_seguro_vida
           + a.total_interes_osipen
           + a.total_interes_afp)
             total_interes_pension,
          (  a.total_aporte_afiliados_sfs
           + a.total_aporte_empleador_sfs
           + a.total_aporte_afiliados_svds
           + a.total_aporte_empleador_svds
           + a.total_aporte_srl
           + a.total_per_capita_adicional
           + a.total_aporte_afiliados_t3
           + a.total_aporte_empleador_t3
           + a.total_aporte_voluntario)
             total_importe,
          NVL (a.monto_ajuste, 0) monto_ajuste,
          (  a.total_aporte_afiliados_sfs
           + a.total_aporte_empleador_sfs
           + a.total_aporte_afiliados_svds
           + a.total_aporte_empleador_svds
           + a.total_aporte_srl
           + a.total_per_capita_adicional
           + a.total_aporte_voluntario
           + a.total_recargo_svds
           + a.total_recargo_sfs
           + a.total_recargo_srl
           + a.total_interes_srl
           + a.total_interes_afp
           + a.total_interes_cpe
           + a.total_interes_fss
           + a.total_interes_osipen
           + a.total_interes_seguro_vida
           + a.total_interes_sfs
           + a.total_interes_apo
           + NVL (a.monto_ajuste, 0))
             total_general_factura,
          a.fecha_reporte_pago,
          a.tipo_reporte_banco,
          id_movimiento,
          a.tipo_empresa,
          a.credito_srl,
          a.tipo_nomina,
          a.origen,
          a.fecha_efectiva_pago,
          a.fecha_limite_acuerdo_pago,
          /*            CASE
                         WHEN (a.no_autorizacion IS NOT NULL
                               AND a.status IN ('VI', 'VE')
                               AND UPPER (NVL (a.id_usuario_autoriza, '!')) IN (select id_usuario from suirplus.seg_usuario_ibanking_t where status='A'))
                         THEN 'PA'
                         ELSE a.status
                      END status,
          */
          A.status,
          CASE
             /*               WHEN (a.no_autorizacion IS NOT NULL
                                  AND a.status IN ('VI', 'VE')
                                  AND UPPER (NVL (a.id_usuario_autoriza, '!')) IN (select id_usuario from suirplus.seg_usuario_ibanking_t where status='A'))
                            THEN 'Pagada'
             */
             WHEN (a.status = 'PA') THEN 'Pagada'
             WHEN (a.status = 'VE') THEN 'Vencida'
             WHEN (a.status = 'VI') THEN 'Vigente'
             WHEN (a.status = 'CA') THEN 'Revocada'
             WHEN (a.status = 'RE') THEN 'Recalculada'
          END
             status_des,
          a.status_generacion, 
          a.fecha_registro_pago
     FROM suirplus.sfc_facturas_t a
    WHERE (  a.total_aporte_afiliados_sfs
           + a.total_aporte_empleador_sfs
           + a.total_aporte_afiliados_svds
           + a.total_aporte_empleador_svds
           + a.total_aporte_srl
           + a.total_per_capita_adicional
           + a.total_aporte_voluntario
           + a.total_recargo_svds
           + a.total_recargo_sfs
           + a.total_recargo_srl
           + a.total_interes_srl
           + a.total_interes_afp
           + a.total_interes_cpe
           + a.total_interes_fss
           + a.total_interes_osipen
           + a.total_interes_seguro_vida
           + a.total_interes_sfs
           + a.total_interes_apo
           + NVL (a.monto_ajuste, 0)) > 0
