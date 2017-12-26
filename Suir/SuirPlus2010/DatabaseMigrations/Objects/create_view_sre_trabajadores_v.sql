 CREATE OR REPLACE VIEW SUIRPLUS.SRE_TRABAJADORES_V
 AS SELECT t.id_registro_patronal,
            t.id_nomina,
            t.id_nss,
            t.fecha_ingreso,
            t.fecha_salida,
            t.salario_ss,
            (CASE
                WHEN (t.salario_ss =0.00 and t.status = 'A') THEN 'B'
                WHEN (t.salario_ss < p.valor_numerico and t.status = 'A') THEN 'B'
                ELSE t.status 
             END) as status,
            t.fecha_inicio_vacaciones,
            t.fecha_final_vacaciones,
            t.fecha_inicio_licencia,
            t.fecha_termino_licencia,
            t.afiliado_idss,
            t.salario_isr,
            t.fecha_ult_reintegro,
            t.aporte_voluntario,
            t.aporte_afiliados_t3,
            t.aporte_empleador_t3,
            t.fecha_registro,
            t.saldo_favor_disponible,
            t.tipo_contratado,
            t.ult_usuario_act,
            t.ult_fecha_act,
            t.salario_infotep,
            t.cod_ingreso,
            t.id_ocupacion,
            t.id_localidad,
            t.id_turno,
            t.salario_mdt     
     FROM suirplus.sre_trabajadores_t t, 
	     (select valor_numerico from suirplus.sfc_det_parametro_t where id_parametro = 354 and fecha_fin is null ) p 