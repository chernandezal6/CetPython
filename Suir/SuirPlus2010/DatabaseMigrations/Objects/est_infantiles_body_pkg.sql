CREATE OR REPLACE PACKAGE BODY SUIRPLUS.EST_INFANTILES_PKG is
  -- Author  : GREGORIO_HERRERA
  -- Created : 4/17/2009 2:10:46 PM
  -- Purpose : Manejo de todos los procesos relativo a estancias infantiles
  -- Version : 1.0
  -- ======================================================================
  -- Author  : GREGORIO_HERRERA
  -- Created : 6/01/2009 2:10:46 PM
  -- Purpose : Corregir validacion de quien dispara el pago de la factura
  -- Version : 1.1
  -- ======================================================================
  -- Author  : GREGORIO_HERRERA
  -- Created : 7/23/2009
  -- Purpose : Cambiar la validacion de la fecha de nacimiento del dependiente,
  --           tomar el ultimo dia del periodo a dispersar en lugar de la fecha de dispersion
  -- Version : 1.2
  -- ======================================================================
  -- Author  : GREGORIO_HERRERA
  -- Created : 10/29/2009
  -- Purpose : Agregar los códigos '05' y '06' como dependientes hijos o hijas
  --           en las validaciones para dependientes hijos o hijas
  --           Incluir los campos en todas las sentencias INSERT
  -- Version : 1.3
  -- ======================================================================
  -- Author  : GREGORIO_HERRERA
  -- Created : 31/03/2010
  -- Purpose : Agregar los códigos '18', '19, y '20' para manejos de perdida de empleo
  --           y periodos de carencias
  -- Version : 1.4
  -- ======================================================================
  -- Author  : GREGORIO_HERRERA
  -- Created : 22/07/2010
  -- Purpose : Refrescar la vista SUIRPLUS.tss_dispersion_aeiss_mv al ejecutar
  --           el método "procesar"
  -- Version : 1.5
  -- ======================================================================

  --Declaraciones de variables comunes del paquete
  m_id_carga        NUMBER(10);
  m_hoy             DATE := SYSDATE; --Para medir el tiempo que tomó el proceso
  m_id_bitacora     SUIRPLUS.SFC_BITACORA_T.id_bitacora%TYPE;
  m_registros       INTEGER := 0;
  m_registros_ok    INTEGER := 0;
  m_registros_error INTEGER := 0;

  -- Cursor para obtener el proximo numero de lote
  -- que servirá como primary key del registro a insertar
  -- en la tabla maestra de estancia infantiles
  CURSOR c_proximo_lote IS
    SELECT NVL(MAX(id_carga),0) + 1
    FROM suirplus.est_carga_t;

  -- Procedimientos y funciones comunes del paquete
  -- ==============================================
  -- Insertar el registro en la maestra de bitacora
  -- ==============================================
  PROCEDURE bitacora (
    p_id_bitacora IN OUT SUIRPLUS.SFC_BITACORA_T.id_bitacora%TYPE,
    p_accion      IN VARCHAR2 DEFAULT 'INI',
    p_id_proceso  IN SUIRPLUS.SFC_BITACORA_T.id_proceso%TYPE,
    p_mensage     IN SUIRPLUS.SFC_BITACORA_T.mensage%TYPE DEFAULT NULL,
    p_status      IN SUIRPLUS.SFC_BITACORA_T.status%TYPE DEFAULT NULL,
    p_id_error    IN SUIRPLUS.SEG_ERROR_T.id_error%TYPE DEFAULT NULL,
    p_seq_number  IN SUIRPLUS.ERRORS.seq_number%TYPE DEFAULT NULL,
    p_periodo     IN SUIRPLUS.SFC_BITACORA_T.periodo%TYPE DEFAULT NULL
  ) IS
  BEGIN
    CASE p_accion
    WHEN 'INI' THEN
      SELECT SUIRPLUS.sfc_bitacora_seq.NEXTVAL INTO p_id_bitacora FROM dual;
      INSERT INTO SUIRPLUS.SFC_BITACORA_T(id_proceso, id_bitacora, fecha_inicio, fecha_fin, mensage, status, periodo)
          VALUES(p_id_proceso, p_id_bitacora, SYSDATE, NULL, p_mensage, 'P', p_periodo);

    WHEN 'FIN' THEN
      UPDATE SUIRPLUS.SFC_BITACORA_T
         SET fecha_fin   = SYSDATE,
             mensage     = p_mensage,
             status      = p_status,
             seq_number  = p_seq_number,
             id_error    = p_id_error
       WHERE id_bitacora = p_id_bitacora;
    ELSE
      RAISE_APPLICATION_ERROR(010, 'Parámetro invalido');
    END CASE;
    COMMIT;
  END;

  -- ==============================================
  -- Insertar el registro en la maestra de carga
  -- ==============================================
  PROCEDURE insertar_carga (p_result OUT VARCHAR2) IS
  BEGIN
    p_result := 'OK';

    OPEN c_proximo_lote;
    FETCH c_proximo_lote INTO m_id_carga;
    CLOSE c_proximo_lote;

    INSERT INTO SUIRPLUS.est_carga_t
    (
      id_carga, fecha, status, vista, registros_ok, registros_error
    )
    VALUES
    (
      m_id_carga, SYSDATE, 'P', 'TSS_DISPERSION_AEISS_MV', 0, 0
    );
    COMMIT;
  EXCEPTION WHEN OTHERS THEN
    ROLLBACK;
    p_result := Substr('ERROR. Carga='||m_id_carga||' en la actualizar dispersion estancia infantiles. '||SQLERRM, 1, 200);
  END;

  -- ======================================================
  -- Insertar el registro en la tabla detalle de dispersion
  -- ======================================================
  PROCEDURE insertar_dispersion( p_result OUT VARCHAR2 ) IS
    v_periodo number(6) := parm.periodo_vigente();
  BEGIN
    p_result  := 'OK';

    INSERT INTO SUIRPLUS.est_dispersion_t
    (id_carga,
     secuencia,
     cve_administradora_ei,
     cve_estancia,
     nss_titular,
     nss_dependiente,
     fecha_generacion_consolidado,
     periodo,
     monto_dispersar,
     c_no_referencia,
     nss_reporta_pago,
     registro_dispersado,
     periodo_generado_consolidado,
     cve_clasificacion_pago
     )
    SELECT m_id_carga,
           secuencia,
           cve_administradora_ei,
           cve_estancia,
           nss_titular,
           nss_dependiente,
           fecha_generacion_consolidado,
           periodo,
           monto_dispersar,
           c_no_referencia,
           nss_reporta_pago,
           'S',
           v_periodo,1
    FROM SUIRPLUS.tss_dispersion_aeiss_mv
    MINUS
    SELECT id_carga,
           secuencia,
           cve_administradora_ei,
           cve_estancia,
           nss_titular,
           nss_dependiente,
           fecha_generacion_consolidado,
           periodo,
           monto_dispersar,
           c_no_referencia,
           nss_reporta_pago,
           'S',
           v_periodo,
           cve_clasificacion_pago
    FROM SUIRPLUS.est_dispersion_con_errores_t
    WHERE id_carga = m_id_carga;
    COMMIT;
  EXCEPTION WHEN OTHERS THEN
    ROLLBACK;
    p_result := Substr('ERROR en la actualizar dispersion estancia infantiles. Carga='||m_id_carga||', '||SQLERRM, 1, 200);
  END;

  -- ======================================================
  -- Validar el registro en la vista antes de insertarlo en
  -- la tabla detalle de dispersion
  -- ======================================================
  PROCEDURE validar_registros_dispersion( p_result OUT VARCHAR2 ) IS
    l_id_error         NUMBER(2);
    v_percapita        NUMBER(18,6) := parm.get_parm_number(151);
    v_ult_periodo_pago NUMBER(6);
    v_cant_periodos    pls_integer;
    v_error            BOOLEAN;
  BEGIN
    p_result := 'OK';


    l_id_error := 21;
   -- Para validar los registros no esten cancelados en el padron
   INSERT INTO SUIRPLUS.est_dispersion_con_errores_t
    (id_carga, secuencia, cve_administradora_ei, cve_estancia, nss_titular, nss_dependiente, fecha_generacion_consolidado, periodo, monto_dispersar, id_error, c_no_referencia, nss_reporta_pago, cve_clasificacion_pago)
    SELECT DISTINCT m_id_carga, secuencia, cve_administradora_ei, cve_estancia, nss_titular, nss_dependiente,
           fecha_generacion_consolidado, periodo, monto_dispersar, l_id_error, c_no_referencia, nss_reporta_pago,1
    FROM SUIRPLUS.tss_dispersion_aeiss_mv dis
    WHERE SUIRPLUS.SRE_CIUDADANO_INACTIVO_F(nvl(dis.nss_dependiente, dis.nss_titular), dis.periodo) = 'N'; -- No se debe pagar la capita

    commit;

    l_id_error := 1;
    -- Para validar que el campo secuencia no se repita en el envio
    -- Si da positivo lo inserto en la tabla de dispersion de errores
    INSERT INTO SUIRPLUS.est_dispersion_con_errores_t
    (id_carga, secuencia, cve_administradora_ei, cve_estancia, nss_titular, nss_dependiente, fecha_generacion_consolidado, periodo, monto_dispersar, id_error, c_no_referencia, nss_reporta_pago, cve_clasificacion_pago)
    SELECT DISTINCT m_id_carga, secuencia, cve_administradora_ei, cve_estancia, nss_titular, nss_dependiente,
           fecha_generacion_consolidado, periodo, monto_dispersar, l_id_error, c_no_referencia, nss_reporta_pago,1
    FROM SUIRPLUS.tss_dispersion_aeiss_mv dis
    WHERE dis.secuencia IN (SELECT secuencia
                            FROM est_dispersion_t
                            WHERE secuencia = dis.secuencia
                            GROUP BY secuencia
                            HAVING COUNT(secuencia) > 1
                           );
    COMMIT;

    l_id_error := 2;
    -- Para validar que la clave de la administradora de instancias sea diferente ser '1'
    -- Si da positivo lo inserto en la tabla de dispersion de errores
    INSERT INTO SUIRPLUS.est_dispersion_con_errores_t
    (id_carga, secuencia, cve_administradora_ei, cve_estancia, nss_titular, nss_dependiente, fecha_generacion_consolidado, periodo, monto_dispersar, id_error, c_no_referencia, nss_reporta_pago, cve_clasificacion_pago)
    SELECT DISTINCT m_id_carga, secuencia, cve_administradora_ei, cve_estancia, nss_titular, nss_dependiente,
           fecha_generacion_consolidado, periodo, monto_dispersar, l_id_error, c_no_referencia, nss_reporta_pago,1
    FROM SUIRPLUS.tss_dispersion_aeiss_mv dis
    WHERE dis.cve_administradora_ei is NULL OR dis.cve_administradora_ei != 1;
    COMMIT;

    l_id_error := 3;
    -- Para validar que la clave de la instancia no esté en el catalogo de instancias
    -- Si da positivo lo inserto en la tabla de dispersion de errores
    INSERT INTO SUIRPLUS.est_dispersion_con_errores_t
    (id_carga, secuencia, cve_administradora_ei, cve_estancia, nss_titular, nss_dependiente, fecha_generacion_consolidado, periodo, monto_dispersar, id_error, c_no_referencia, nss_reporta_pago, cve_clasificacion_pago)
    SELECT DISTINCT m_id_carga, secuencia, cve_administradora_ei, cve_estancia, nss_titular, nss_dependiente,
           fecha_generacion_consolidado, periodo, monto_dispersar, l_id_error, c_no_referencia, nss_reporta_pago,1
    FROM SUIRPLUS.tss_dispersion_aeiss_mv dis
    WHERE NOT EXISTS (SELECT cve_estancia
                      FROM SUIRPLUS.est_catalogo_ei_t
                      WHERE cve_estancia = dis.cve_estancia
                        AND estatus = 'AC'
                      );
    COMMIT;

    l_id_error := 4;
    -- Para validar que el periodo no esté nulo o sea igual a cero
    -- Si da positivo lo inserto en la tabla de dispersion de errores
    INSERT INTO SUIRPLUS.est_dispersion_con_errores_t
    (id_carga, secuencia, cve_administradora_ei, cve_estancia, nss_titular, nss_dependiente, fecha_generacion_consolidado, periodo, monto_dispersar, id_error, c_no_referencia, nss_reporta_pago, cve_clasificacion_pago)
    SELECT DISTINCT m_id_carga, secuencia, cve_administradora_ei, cve_estancia, nss_titular, nss_dependiente,
           fecha_generacion_consolidado, periodo, monto_dispersar, l_id_error, c_no_referencia, nss_reporta_pago,1
    FROM SUIRPLUS.tss_dispersion_aeiss_mv dis
    WHERE dis.periodo is NULL OR dis.periodo = 0;
    COMMIT;

    l_id_error := 5;
    -- Para validar que el NSS del titular no esté en la maestra de ciudadanos
    -- Si da positivo lo inserto en la tabla de dispersion de errores
    INSERT INTO SUIRPLUS.est_dispersion_con_errores_t
    (id_carga, secuencia, cve_administradora_ei, cve_estancia, nss_titular, nss_dependiente, fecha_generacion_consolidado, periodo, monto_dispersar, id_error, c_no_referencia, nss_reporta_pago, cve_clasificacion_pago)
    SELECT DISTINCT m_id_carga, secuencia, cve_administradora_ei, cve_estancia, nss_titular, nss_dependiente,
           fecha_generacion_consolidado, periodo, monto_dispersar, l_id_error, c_no_referencia, nss_reporta_pago, 1
    FROM SUIRPLUS.tss_dispersion_aeiss_mv dis
    WHERE NOT EXISTS (SELECT id_nss
                      FROM SUIRPLUS.sre_ciudadanos_t
                      WHERE id_nss = dis.nss_titular
                     );
    COMMIT;

    l_id_error := 6;
    -- Para validar que el NSS del dependiente no esté en la maestra de ciudadanos
    -- Si da positivo lo inserto en la tabla de dispersion de errores
    INSERT INTO SUIRPLUS.est_dispersion_con_errores_t
    (id_carga, secuencia, cve_administradora_ei, cve_estancia, nss_titular, nss_dependiente, fecha_generacion_consolidado, periodo, monto_dispersar, id_error, c_no_referencia, nss_reporta_pago, cve_clasificacion_pago)
    SELECT DISTINCT m_id_carga, secuencia, cve_administradora_ei, cve_estancia, nss_titular, nss_dependiente,
           fecha_generacion_consolidado, periodo, monto_dispersar, l_id_error, c_no_referencia, nss_reporta_pago,1
    FROM SUIRPLUS.tss_dispersion_aeiss_mv dis
    WHERE NOT EXISTS (SELECT id_nss
                      FROM SUIRPLUS.sre_ciudadanos_t
                      WHERE id_nss = dis.nss_dependiente
                     );
    COMMIT;

    l_id_error := 7;
    -- Para validar que el NSS del dependiente no esté registrado a más de un titular
    -- Si da positivo lo inserto en la tabla de dispersion de errores
    INSERT INTO SUIRPLUS.est_dispersion_con_errores_t
    (id_carga, secuencia, cve_administradora_ei, cve_estancia, nss_titular, nss_dependiente, fecha_generacion_consolidado, periodo, monto_dispersar, id_error, c_no_referencia, nss_reporta_pago, cve_clasificacion_pago)
    SELECT DISTINCT m_id_carga, secuencia, cve_administradora_ei, cve_estancia, nss_titular, nss_dependiente,
           fecha_generacion_consolidado, periodo, monto_dispersar, l_id_error, c_no_referencia, nss_reporta_pago,1
    FROM SUIRPLUS.tss_dispersion_aeiss_mv dis
    WHERE dis.nss_dependiente IN (SELECT nss_dependiente
                                  FROM SUIRPLUS.ars_cartera_t
                                  WHERE periodo_factura_ars = dis.periodo
                                    AND nss_dependiente = dis.nss_dependiente
                                    AND tipo_afiliado = 'D' --Que sea dependiente
                                    AND codigo_parentesco IN ('5','6','05','06','17','18') --Que sea dependiente (hijo o hija)
                                  GROUP BY nss_dependiente
                                  HAVING COUNT(nss_dependiente) > 1
                                 );
    COMMIT;

    l_id_error := 8;
    -- Para validar que el registro no se repita en este envío
    -- Si da positivo lo inserto en la tabla de dispersion de errores
    INSERT INTO SUIRPLUS.est_dispersion_con_errores_t
    (id_carga, secuencia, cve_administradora_ei, cve_estancia, nss_titular, nss_dependiente, fecha_generacion_consolidado, periodo, monto_dispersar, id_error, c_no_referencia, nss_reporta_pago, cve_clasificacion_pago)
    SELECT DISTINCT m_id_carga, secuencia, cve_administradora_ei, cve_estancia, nss_titular, nss_dependiente,
           fecha_generacion_consolidado, periodo, monto_dispersar, l_id_error, c_no_referencia, nss_reporta_pago,1
    FROM SUIRPLUS.tss_dispersion_aeiss_mv dis
    WHERE (dis.nss_titular, dis.nss_dependiente, dis.periodo) IN
      (SELECT nss_titular, nss_dependiente, periodo
       FROM SUIRPLUS.est_dispersion_t
       WHERE id_carga = m_id_carga
         AND nss_titular = dis.nss_titular
         AND nss_dependiente = dis.nss_dependiente
         AND periodo = dis.periodo
       GROUP BY nss_titular, nss_dependiente, periodo
       HAVING COUNT(*) > 1
      );
    COMMIT;

    l_id_error := 9;
    -- Para validar que el registro no se halla enviado anteriormente para el mismo periodo
    -- Si da positivo lo inserto en la tabla de dispersion de errores
    INSERT INTO SUIRPLUS.est_dispersion_con_errores_t
    (id_carga, secuencia, cve_administradora_ei, cve_estancia, nss_titular, nss_dependiente, fecha_generacion_consolidado, periodo, monto_dispersar, id_error, c_no_referencia, nss_reporta_pago, cve_clasificacion_pago)
    SELECT DISTINCT m_id_carga, secuencia, cve_administradora_ei, cve_estancia, nss_titular, nss_dependiente,
           fecha_generacion_consolidado, periodo, monto_dispersar, l_id_error, c_no_referencia, nss_reporta_pago,1
    FROM SUIRPLUS.tss_dispersion_aeiss_mv dis
    WHERE EXISTS (SELECT id_carga
                  FROM SUIRPLUS.est_dispersion_t
                  WHERE id_carga != m_id_carga
                    AND nss_titular = dis.nss_titular
                    AND nss_dependiente = dis.nss_dependiente
                    AND periodo = dis.periodo
                    AND NVL(registro_dispersado,'N') = 'S'
                 );
    COMMIT;

    l_id_error := 10;
    -- Para validar que el rubro estancia infantil no esté pago en la factura por el titular o por el conyuge
    -- Si da negativo lo inserto en la tabla de dispersion de errores
    INSERT INTO SUIRPLUS.est_dispersion_con_errores_t
    (id_carga, secuencia, cve_administradora_ei, cve_estancia, nss_titular, nss_dependiente, fecha_generacion_consolidado, periodo, monto_dispersar, id_error, c_no_referencia, nss_reporta_pago, cve_clasificacion_pago)
    SELECT DISTINCT m_id_carga, secuencia, cve_administradora_ei, cve_estancia, nss_titular, nss_dependiente,
           fecha_generacion_consolidado, periodo, monto_dispersar, l_id_error, c_no_referencia, nss_reporta_pago,1
    FROM SUIRPLUS.tss_dispersion_aeiss_mv dis
    WHERE dis.c_no_referencia != '5555555555555550'
      AND NOT EXISTS (-- Para buscar el rubro de estancia infantil pago en la factura del periodo para el titular
                      SELECT car.nss_titular
                      FROM SUIRPLUS.ars_cartera_t car,
                           SUIRPLUS.sfc_facturas_t fac,
                           SUIRPLUS.sfc_det_facturas_t det
                      WHERE car.periodo_factura_ars = to_char(dis.periodo)
                        AND car.nss_titular = dis.nss_reporta_pago
                        AND car.nss_dependiente = dis.nss_dependiente
                        AND car.tipo_afiliado = 'D' --Que sea dependiente
                        AND car.codigo_parentesco IN ('5','6','05','06','17','18') --Que sea hijo o hija (dependiente)
                        -- Facturas paga del periodo
                        AND fac.id_referencia = dis.c_no_referencia
                        AND fac.status = 'PA'
                        -- NSS del titular haciendo el aporte en la factura del periodo
                        AND det.id_referencia = fac.id_referencia
                        AND det.id_nss = dis.nss_reporta_pago
                        AND NVL(det.estancias_infantiles, 0) > 0
                     )
      AND NOT EXISTS (-- Para buscar el rubro de estancia infantil pago en la factura del periodo por el conyuge
                      SELECT tit.nss_dependiente
                      FROM SUIRPLUS.ars_cartera_t tit,
                           SUIRPLUS.ars_cartera_t dep,
                           SUIRPLUS.sfc_facturas_t fac,
                           SUIRPLUS.sfc_det_facturas_t det
                      WHERE tit.periodo_factura_ars = to_char(dis.periodo)
                        AND tit.nss_titular = dis.nss_titular
                        AND tit.nss_dependiente = dis.nss_reporta_pago --El que dispara el pago como dependiente
                        AND tit.tipo_afiliado = 'D' --Que sea dependiente
                        AND tit.codigo_parentesco IN ('3','4','03','04','19') --Que sea esposo o esposa (conyuge)
                        -- Buscamos el menor como dependiente del titular en la cartera
                        AND dep.periodo_factura_ars = to_char(dis.periodo)
                        AND dep.nss_titular = dis.nss_titular
                        AND dep.nss_dependiente = dis.nss_dependiente
                        AND dep.tipo_afiliado = 'D' --Que sea dependiente
                        AND dep.codigo_parentesco IN ('5','6','05','06','17','18') --Que sea hijo o hija (dependiente)
                        -- Facturas paga del periodo
                        AND fac.id_referencia = dis.c_no_referencia
                        AND fac.status = 'PA'
                        -- NSS del conyuge haciendo el aporte en la factura del periodo
                        AND det.id_referencia = fac.id_referencia
                        AND det.id_nss = dis.nss_reporta_pago
                        AND NVL(det.estancias_infantiles, 0) > 0
                     );
    COMMIT;

    l_id_error := 11;
    -- Para validar que el dependiente no se encuentre en el núcleo familiar del periodo
    -- Si da positivo lo inserto en la tabla de dispersion de errores
    INSERT INTO SUIRPLUS.est_dispersion_con_errores_t
    (id_carga, secuencia, cve_administradora_ei, cve_estancia, nss_titular, nss_dependiente, fecha_generacion_consolidado, periodo, monto_dispersar, id_error, c_no_referencia, nss_reporta_pago, cve_clasificacion_pago)
    SELECT DISTINCT m_id_carga, secuencia, cve_administradora_ei, cve_estancia, nss_titular, nss_dependiente,
           fecha_generacion_consolidado, periodo, monto_dispersar, l_id_error, c_no_referencia, nss_reporta_pago,1
    FROM SUIRPLUS.tss_dispersion_aeiss_mv dis
    WHERE NOT EXISTS (-- Para buscar el dependiente en el núcleo del titular
                      SELECT nss_titular
                      FROM SUIRPLUS.ars_cartera_t
                      WHERE periodo_factura_ars = to_char(dis.periodo)
                        AND nss_titular = dis.nss_titular
                        AND nss_dependiente = dis.nss_dependiente
                        AND tipo_afiliado = 'D' --Que sea dependiente
                        AND codigo_parentesco IN ('5','6','05','06','17','18') --Que sea hijo o hija (dependiente)
                     );
    COMMIT;

    l_id_error := 12;
    -- Para validar que la fecha de nacimiento del dependiente no esté entre 1.5 y 60 meses (45 días y 5 años)
    -- Si da positivo lo inserto en la tabla de dispersion de errores
    INSERT INTO SUIRPLUS.est_dispersion_con_errores_t
    (id_carga, secuencia, cve_administradora_ei, cve_estancia, nss_titular, nss_dependiente, fecha_generacion_consolidado, periodo, monto_dispersar, id_error, c_no_referencia, nss_reporta_pago, cve_clasificacion_pago)
    SELECT DISTINCT m_id_carga, dis.secuencia, dis.cve_administradora_ei, dis.cve_estancia, dis.nss_titular, dis.nss_dependiente,
           dis.fecha_generacion_consolidado, dis.periodo, dis.monto_dispersar, l_id_error, dis.c_no_referencia, dis.nss_reporta_pago,1
    FROM SUIRPLUS.tss_dispersion_aeiss_mv dis
    JOIN SUIRPLUS.sre_ciudadanos_t ciu
      ON ciu.id_nss = dis.nss_dependiente
     AND months_between(LAST_DAY(TO_DATE(dis.periodo,'YYYYMM')), TRUNC(ciu.fecha_nacimiento)) NOT BETWEEN 1.5 AND 60;
    COMMIT;

    l_id_error := 13;
    -- Para validar que el monto dispersado no coincidan con el parametro del per capita para estancia infantil
    -- Si da positivo lo inserto en la tabla de dispersion de errores
    INSERT INTO SUIRPLUS.est_dispersion_con_errores_t
    (id_carga, secuencia, cve_administradora_ei, cve_estancia, nss_titular, nss_dependiente, fecha_generacion_consolidado, periodo, monto_dispersar, id_error, c_no_referencia, nss_reporta_pago, cve_clasificacion_pago)
    SELECT DISTINCT m_id_carga, secuencia, cve_administradora_ei, cve_estancia, nss_titular, nss_dependiente,
           fecha_generacion_consolidado, periodo, monto_dispersar, l_id_error, c_no_referencia, nss_reporta_pago,1
    FROM SUIRPLUS.tss_dispersion_aeiss_mv dis
    WHERE dis.monto_dispersar != v_percapita;
    COMMIT;

    l_id_error := 14;
    -- Para validar que la referencia que dispara el pago no exista y que esté con estatus pagada
    -- Si da positivo lo inserto en la tabla de dispersion de errores
    INSERT INTO SUIRPLUS.est_dispersion_con_errores_t
    (id_carga, secuencia, cve_administradora_ei, cve_estancia, nss_titular, nss_dependiente, fecha_generacion_consolidado, periodo, monto_dispersar, id_error, c_no_referencia, nss_reporta_pago, cve_clasificacion_pago)
    SELECT DISTINCT m_id_carga, secuencia, cve_administradora_ei, cve_estancia, nss_titular, nss_dependiente,
           fecha_generacion_consolidado, periodo, monto_dispersar, l_id_error, c_no_referencia, nss_reporta_pago,1
    FROM SUIRPLUS.tss_dispersion_aeiss_mv dis
    WHERE dis.c_no_referencia != '5555555555555550'
      AND NOT EXISTS (SELECT id_referencia
                      FROM SUIRPLUS.sfc_facturas_t
                      WHERE id_referencia = dis.c_no_referencia
                        AND status = 'PA'
                     );
    COMMIT;

    l_id_error := 15;
    -- Para validar que el NSS que dispara pago no exista en la maestra de ciudadano
    -- Si da positivo lo inserto en la tabla de dispersion de errores
    INSERT INTO SUIRPLUS.est_dispersion_con_errores_t
    (id_carga, secuencia, cve_administradora_ei, cve_estancia, nss_titular, nss_dependiente, fecha_generacion_consolidado, periodo, monto_dispersar, id_error, c_no_referencia, nss_reporta_pago, cve_clasificacion_pago)
    SELECT DISTINCT m_id_carga, secuencia, cve_administradora_ei, cve_estancia, nss_titular, nss_dependiente,
           fecha_generacion_consolidado, periodo, monto_dispersar, l_id_error, c_no_referencia, nss_reporta_pago,1
    FROM SUIRPLUS.tss_dispersion_aeiss_mv dis
    WHERE NOT EXISTS (SELECT id_nss
                      FROM SUIRPLUS.sre_ciudadanos_t
                      WHERE id_nss = dis.nss_reporta_pago
                     );
    COMMIT;

    l_id_error := 16;
    -- Para valida que el NSS que dispara el pago no exista en la referencia pagada
    -- Si da positivo lo inserto en la tabla de dispersion de errores
    INSERT INTO SUIRPLUS.est_dispersion_con_errores_t
    (id_carga, secuencia, cve_administradora_ei, cve_estancia, nss_titular, nss_dependiente, fecha_generacion_consolidado, periodo, monto_dispersar, id_error, c_no_referencia, nss_reporta_pago, cve_clasificacion_pago)
    SELECT DISTINCT m_id_carga, secuencia, cve_administradora_ei, cve_estancia, nss_titular, nss_dependiente,
           fecha_generacion_consolidado, periodo, monto_dispersar, l_id_error, c_no_referencia, nss_reporta_pago,1
    FROM SUIRPLUS.tss_dispersion_aeiss_mv dis
    WHERE dis.c_no_referencia != '5555555555555550'
      AND NOT EXISTS (SELECT det.id_nss
                      FROM SUIRPLUS.sfc_facturas_t fac, SUIRPLUS.sfc_det_facturas_t det
                      WHERE fac.id_referencia = dis.c_no_referencia
                        AND fac.status = 'PA'
                        AND det.id_referencia = fac.id_referencia
                        AND det.id_nss = dis.nss_reporta_pago
                     );
    COMMIT;

    l_id_error := 17;
    -- Para validar que el NSS que dispara pago no exista en el núcleo familiar del titular
    -- Si da negativo lo inserto en la tabla de dispersion de errores
    INSERT INTO SUIRPLUS.est_dispersion_con_errores_t
    (id_carga, secuencia, cve_administradora_ei, cve_estancia, nss_titular, nss_dependiente, fecha_generacion_consolidado, periodo, monto_dispersar, id_error, c_no_referencia, nss_reporta_pago, cve_clasificacion_pago)
    SELECT DISTINCT m_id_carga, secuencia, cve_administradora_ei, cve_estancia, nss_titular, nss_dependiente,
           fecha_generacion_consolidado, periodo, monto_dispersar, l_id_error, c_no_referencia, nss_reporta_pago,1
    FROM SUIRPLUS.tss_dispersion_aeiss_mv dis
    WHERE NOT EXISTS (-- NSS dispara pago es el mismo titular en el núcelo familiar
                      SELECT car.nss_titular
                      FROM SUIRPLUS.ars_cartera_t car
                      WHERE car.periodo_factura_ars = to_char(dis.periodo)
                        AND car.nss_titular = dis.nss_reporta_pago
                     )
      AND NOT EXISTS (-- NSS dispara pago es un dependiente (conyuge) del titular en el núcleo familiar
                      SELECT car.nss_titular
                      FROM SUIRPLUS.ars_cartera_t car
                      WHERE car.periodo_factura_ars = to_char(dis.periodo)
                        AND car.nss_titular = dis.nss_titular
                        AND car.nss_dependiente = dis.nss_reporta_pago
                        AND car.tipo_afiliado = 'D' --Que sea dependiente
                        AND car.codigo_parentesco IN ('3','4','03','04','19') --Que sea esposo o esposa (conyuge)
                     );
    COMMIT;

    l_id_error := 18;
    ---para validar el numero de referencia cuya longitud debe ser de 16
    INSERT INTO SUIRPLUS.est_dispersion_con_errores_t
    (id_carga, secuencia, cve_administradora_ei, cve_estancia, nss_titular, nss_dependiente, fecha_generacion_consolidado, periodo, monto_dispersar, id_error, c_no_referencia, nss_reporta_pago, cve_clasificacion_pago)
    SELECT DISTINCT m_id_carga, secuencia, cve_administradora_ei, cve_estancia, nss_titular,
           nss_dependiente, fecha_generacion_consolidado, periodo, monto_dispersar, l_id_error, c_no_referencia, nss_reporta_pago,1
    FROM SUIRPLUS.tss_dispersion_aeiss_mv dis
    WHERE dis.c_no_referencia = '5555555555555550'
      AND length(dis.c_no_referencia)!= 16;
    COMMIT;

    l_id_error := 19;
    --para validar que el periodo anterior para un ciudadano desempleado fue dispersado
    INSERT INTO SUIRPLUS.est_dispersion_con_errores_t
    (id_carga, secuencia, cve_administradora_ei, cve_estancia, nss_titular, nss_dependiente, fecha_generacion_consolidado, periodo, monto_dispersar, id_error, c_no_referencia, nss_reporta_pago, cve_clasificacion_pago)
    SELECT DISTINCT m_id_carga, secuencia, cve_administradora_ei, cve_estancia, nss_titular,
           nss_dependiente, fecha_generacion_consolidado, periodo, monto_dispersar, l_id_error, c_no_referencia, nss_reporta_pago,1
    FROM SUIRPLUS.tss_dispersion_aeiss_mv dis
    WHERE dis.c_no_referencia = '5555555555555550'
      and not exists (select 1 from est_dispersion_t s
                      where s.nss_titular = dis.nss_titular
                        and s.nss_dependiente = dis.nss_dependiente
                        and s.periodo = to_char(add_months(to_date(to_char(dis.periodo)||'01','yyyymmdd'),-1),'yyyymm')
                        and NVL(s.registro_dispersado,'N') = 'S'
                      );
    COMMIT;

    l_id_error := 20;
    -- Para validar los registros en periodo de carencia
    -- primero buscamos todos los registros tipos 2
    For r1 in (select distinct nss_titular, nss_dependiente
               from suirplus.tss_dispersion_aeiss_mv dr1
               where 1 = 2) Loop
      --buscamos el ultimo pago sin atraso para el titular, dependiente
      Select NVL(max(periodo),190001) into v_ult_periodo_pago
      From suirplus.est_dispersion_t dis
      Where dis.nss_titular = r1.nss_titular
        and dis.nss_dependiente = r1.nss_dependiente
        and dis.periodo = dis.periodo_generado_consolidado
        and NVL(dis.registro_dispersado,'N') = 'S';

      --buscamos los periodos consecutivos con atrasos despues del ultimo periodo pago
      --Solo deben ser aceptados dos periodos, los demas hay que romperlos.
      v_cant_periodos := 1;
      v_error         := FALSE;

      For r2 in (select nss_titular, nss_dependiente, periodo
                 from suirplus.tss_dispersion_aeiss_mv dr2
                 where dr2.nss_titular = r1.nss_titular
                   and dr2.nss_dependiente = r1.nss_dependiente
                   and 1 = 2
                 order by dr2.periodo
                 ) Loop
         --El periodo es mayor de tres
         If months_between(to_date(to_char(r2.periodo)||'01','yyyymmdd'),to_date(to_char(v_ult_periodo_pago)||'01','yyyymmdd')) >= 3 then
           v_error := TRUE;
           v_ult_periodo_pago := r2.periodo;
           EXIT;
         --Hay salto en el primer periodo
         ElsIf v_cant_periodos = 1 and months_between(to_date(to_char(r2.periodo)||'01','yyyymmdd'),to_date(to_char(v_ult_periodo_pago)||'01','yyyymmdd')) > 1 Then
           v_error := TRUE;
           v_ult_periodo_pago := r2.periodo;
           EXIT;
         End if;

         v_cant_periodos := v_cant_periodos + 1;
      End Loop;

      IF v_error Then
        INSERT INTO SUIRPLUS.est_dispersion_con_errores_t
        (id_carga, secuencia, cve_administradora_ei, cve_estancia, nss_titular, nss_dependiente, fecha_generacion_consolidado, periodo, monto_dispersar, id_error, c_no_referencia, nss_reporta_pago, cve_clasificacion_pago)
        SELECT DISTINCT m_id_carga, secuencia, cve_administradora_ei, cve_estancia, nss_titular,
               nss_dependiente, fecha_generacion_consolidado, periodo, monto_dispersar, l_id_error, c_no_referencia, nss_reporta_pago,1
        FROM SUIRPLUS.tss_dispersion_aeiss_mv dis
        WHERE dis.nss_titular = r1.nss_titular
          AND dis.nss_dependiente = r1.nss_dependiente
          AND dis.periodo >= v_ult_periodo_pago
          AND 1 = 2;
        COMMIT;
      End if;
    End Loop;
  EXCEPTION WHEN OTHERS THEN
    ROLLBACK;
    p_result := Substr('ERROR en la actualizar dispersion estancia infantiles. Carga='||m_id_carga||', '||SQLERRM, 1, 200);
  END;

  -- ======================================================
  -- Para enviar email con el resultado del proceso
  -- ======================================================
  PROCEDURE enviar_email(p_id_carga IN NUMBER ) is
    PROCEDURE add(id_error IN NUMBER, validacion IN VARCHAR2,  resultado IN INTEGER) IS
    BEGIN
      v_html := v_html || '<tr><td align="center">'|| id_error ||'</td><td>'||validacion||'</td><td align="center">';
      IF (resultado = 0) THEN
        v_html := v_html || '<font color="green">OK</font>';
      ELSE
        v_html := v_html || '<font color="red">'||trim(to_char(resultado, '999,999,999'))||'</font>';
      end IF;
      v_html := v_html || '</td></tr>';
    END;
  BEGIN
    --encabezado
    v_html := '<html>
               <head>
                <STYLE TYPE="text/css"><!--.smallfont {font-size:9pt;}--></STYLE>
               </head>
               <body>
                <table border="1" cellpadding=3 cellspacing=0 CLASS="smallfont" style="border-collapse: collapse">'
                 || '<tr><td colspan="3" bgcolor="silver" align="center"><b>Resultado de las validaciones</b></td></tr>
                     <tr><td><b>Codigo</b></td>
                         <td><b>Descripcion</b></td>
                         <td align="center"><font color="green">OK</font><font color="red">/Error</font></td>
                     </tr>';

    --codigos de error
    FOR errores IN (
        SELECT a.id_error, a.error_des, NVL(COUNT(b.id_error),0) total
        FROM SUIRPLUS.est_catalogo_errores_t a
        JOIN SUIRPLUS.est_dispersion_con_errores_t b
          ON b.id_carga=p_id_carga
         AND b.id_error=a.id_error
        GROUP BY a.id_error, a.error_des
        ORDER BY a.id_error) LOOP
      add(errores.id_error, errores.error_des, errores.total);
    END LOOP;

    -- Contamos los registros rechazados
    SELECT COUNT(DISTINCT secuencia) INTO m_registros_error
    FROM SUIRPLUS.est_dispersion_con_errores_t
    WHERE id_carga = p_id_carga;

    -- Contamos los registros aceptados
    SELECT COUNT(secuencia) INTO m_registros_ok
    FROM SUIRPLUS.est_dispersion_t
    WHERE id_carga = p_id_carga
    MINUS
    SELECT COUNT(DISTINCT secuencia)
    FROM SUIRPLUS.est_dispersion_con_errores_t
    WHERE id_carga = p_id_carga;

    m_registros := nvl(m_registros_ok, 0) + NVL(m_registros_error, 0);

    v_html := v_html||'<tr><td colspan="2" bgcolor="silver"><b>Registros OK</b></td>'
                    ||'<td align="right" bgcolor="silver"><font color="green">' || trim(to_char(m_registros_ok,'999,999,990')) ||'</td></tr>';

    v_html := v_html||'<tr><td colspan="2" bgcolor="silver"><b>Registros con Errores</b></td>'
                    ||'<td align="right" bgcolor="silver"><font color="red">' || trim(to_char(m_registros_error,'999,999,990')) ||'</td></tr>';

    v_html := v_html||'<tr><td colspan="2" bgcolor="silver"><b>Total Registros procesados ('
                    ||'en '|| trim(to_char((sysdate-m_hoy)*24*60,'999,999,990')) ||' minutos) </b></td>'
                    ||'<td align="right" bgcolor="silver">' || trim(to_char(m_registros,'999,999,990')) ||'</td></tr>';

    v_html := v_html||'</table></body></html>';

    --Subject del mensaje
    BEGIN
      SELECT c_mail_subject||' - Carga #' || p_id_carga, p.lista_ok
      INTO c_mail_subject, c_mail_to
      FROM suirplus.sfc_procesos_t p
      WHERE p.id_proceso = 'EI';
    EXCEPTION WHEN NO_DATA_FOUND THEN
      c_mail_subject := c_mail_subject||' - Carga #' || p_id_carga;
      c_mail_to      := c_mail_error;
    END;
    -- enviar email
     system.html_mail(c_mail_from, c_mail_to, c_mail_subject, v_html);
  END;

  -- ======================================================
  -- Este es el punto de arranque del paquete
  -- ======================================================
  PROCEDURE procesar( p_result OUT VARCHAR2 ) IS
  BEGIN
    --Actualiza el catalogo de Estancias
    Insert_Estancia_uni(p_result);
    -- Insetamos el registro en la bitacora
    BITACORA(m_id_bitacora, 'INI', 'EI');
    -- Insertamos el registro de las estancias
    Insert_Estancia_uni( p_result );
    -- Insertamos el registro maestro de la carga
    INSERTAR_CARGA( p_result );

    IF (p_result = 'OK') THEN
      -- Refrescamos la vista con los registros que vienen desde UNIPAGO
      EXECUTE IMMEDIATE 'begin sys.dbms_snapshot.refresh(''suirplus.TSS_DISPERSION_AEISS_MV''); end;';

      -- Validamos los registros de acuerdo al catalogo de errores
      VALIDAR_REGISTROS_DISPERSION( p_result );

      IF (p_result != 'OK') THEN
        GOTO errores;
      ELSE
        INSERTAR_DISPERSION ( p_result );

        IF (p_result != 'OK') THEN
          GOTO errores;
        ELSE
          -- Si llegó hasta aqui, no hubo errores de excepciones
          BITACORA(m_id_bitacora, 'FIN', 'EI', 'OK. carga='||m_id_carga, 'O', '000');

          -- Enviar email indicando corrida satisfactoria
          enviar_email( m_id_carga );

          -- Actualizar la maestra de carga
          UPDATE SUIRPLUS.est_carga_t
          SET status = 'C',
              registros_ok = m_registros_ok,
              registros_error = m_registros_error
          WHERE id_carga = m_id_carga;
          --Carga de resumen de dispersión de estancias
           Resumen_Estancias_Infantiles(m_id_carga,p_result);
          COMMIT;

          --Para refrescar vista entregada a UNIPAGO
          EXECUTE IMMEDIATE 'begin sys.dbms_snapshot.refresh(''UNIPAGO.EST_DISPERSION_CON_ERRORES_MV''); end;';

          RETURN;
        END IF;
      END IF;
    ELSE
      GOTO errores;
    END IF;

    <<errores>>
      UPDATE SUIRPLUS.est_carga_t
      SET status = 'E'
      WHERE id_carga = m_id_carga;
      COMMIT;

      BITACORA(m_id_bitacora, 'FIN', 'EI', p_result, 'E', '650');
      --Lista de correos a enviar el mensaje
      BEGIN
        SELECT p.lista_error
        INTO c_mail_to
        FROM suirplus.sfc_procesos_t p
        WHERE p.id_proceso = 'EI';
      EXCEPTION WHEN NO_DATA_FOUND THEN
        c_mail_to := c_mail_error;
      END;

      system.html_mail(c_mail_from, c_mail_error, 'Error en '||c_mail_subject, 'carga='||m_id_carga ||'<br>Error='||p_result);
  EXCEPTION WHEN OTHERS THEN
    UPDATE SUIRPLUS.est_carga_t
    SET status = 'E'
    WHERE id_carga = m_id_carga;
    COMMIT;

    p_result := substr(SQLERRM,1,200);
    BITACORA(m_id_bitacora, 'FIN', 'EI', p_result, 'E', '650');

    --Lista de correos a enviar el mensaje
    BEGIN
      SELECT p.lista_error
      INTO c_mail_to
      FROM suirplus.sfc_procesos_t p
      WHERE p.id_proceso = 'EI';
    EXCEPTION WHEN NO_DATA_FOUND THEN
      c_mail_to := c_mail_error;
    END;

    system.html_mail(c_mail_from, c_mail_error, 'Error en '||c_mail_subject, 'carga='||m_id_carga ||'<br>Error='||p_result);
  END;

-- -----------------------------------------------------------------------
  -- Resumen_Dispersion_Estancias_Infantiles: Resumen de Dispersion
  -- GREIMAN GARCIA
  -- 26/05/2009
-- -----------------------------------------------------------------------
  procedure Resumen_Estancias_Infantiles( p_Carga  suirplus.est_carga_t.id_carga%type,
                                                            p_result out varchar2)
  is
    m_result       varchar2(32000) := 'OK';
    e_InvalidCiclo exception;
    v_registros  number := 0;
    begin
    -- Verificar si hay un resumen previo
    select count(*)
      into v_registros
      from EST_DISPERSION_RESUMEN_T
     where id_carga_dispersion = p_Carga;

    -- si no encontro registros, poner en cero
    v_registros := nvl(v_registros, 0);

    -- Si existen registros, entonces, es un reproceso, eliminar el resumen previo
    if v_registros > 0 then
       delete EST_DISPERSION_RESUMEN_T where ID_CARGA_DISPERSION = p_Carga;
    end if;

    -- Insertar registros en Resumen
       insert into suirplus.est_dispersion_resumen_t(
            ID_CARGA_DISPERSION
            ,ID_EST_DISPERSADA
            ,PERIODO_DISPERSION
            ,TITULARES
            ,DEPENDIENTES
            ,PAGO
          )
       Select a.id_carga,
              a.cve_estancia,
              to_char(ca.fecha, 'YYYYMM') Periodo,
              count(distinct a.nss_titular) titulares,
              count(a.nss_dependiente) dependientes,
              sum(a.monto_dispersar) pago
         from suirplus.est_carga_t ca
         left join suirplus.est_dispersion_t a on a.id_carga = ca.id_carga
         left join SUIRPLUS.est_catalogo_ei_t b on b.cve_estancia =
                                                   a.cve_estancia
        where ca.id_carga = p_Carga
        group by a.id_carga,
                 a.cve_estancia,
                 b.descripcion_estancia,
                 to_char(ca.fecha, 'YYYYMM');
     Commit;
     p_result := m_result;
     exception
    when e_InvalidCiclo then
      p_result := 'ERROR. Procesar Resumen de Dispersion de Estancias Infantiles.';
   end;
-- -----------------------------------------------------------------------
  -- Reversar_dispersion
  -- GREIMAN GARCIA
  -- 20/10/201010
-- -----------------------------------------------------------------------
    procedure Reversar_dispersion( p_Carga  suirplus.est_carga_t.id_carga%type,
                                   p_result out varchar2)
      is
        m_result       varchar2(32000) := 'OK';
        e_InvalidCiclo exception;
        e_InvaliCarga  exception;
        v_cantidad     integer;
        begin
         --valida que el id_carga no sea nulo
         if p_Carga is null then
         raise e_InvalidCiclo;
         end if;
         -- valida que el id_carga exista en la tabla
         select count(*)
         into v_cantidad
         from suirplus.est_dispersion_t a
         where a.id_carga = p_carga;

         if v_cantidad <=0 then
         raise e_InvaliCarga;
         end if;
         --Elimina los registros insertados en la tabla est_dispersion_t
         Delete from suirplus.est_dispersion_t a
         where  a.id_carga=p_carga;

         --Actualiza el maestro de carga
         update suirplus.est_carga_t ca
            set ca.status            = 'E'
          where ca.id_carga      = p_carga;

          commit;

         p_result := m_result;
         exception
        when e_InvalidCiclo then
          p_result := 'ERROR. El parametro de ID_CARGA no puede estar nulo.';
        when e_InvaliCarga then
          p_result := 'ERROR. No existe un ID_CARGA para reversar.';
       end;
  -- -----------------------------------------------------------------------
  -- Inserta las estancias que no estan del lado de TSS
  -- GREIMAN GARCIA
  -- 19/05/2011
  -- -----------------------------------------------------------------------
  procedure Insert_Estancia_uni(p_result out varchar2) is
  begin
   p_result :='OK';
   execute immediate 'begin sys.dbms_snapshot.refresh(''SUIRPLUS.SUIR_C_ESTANCIAS_INFANTILES''); end;';
     for est in (
                 select un.n_cve_estancia, un.c_nombre_estancia, un.c_estatus
                   from suirplus.suir_c_estancias_infantiles un
                   left join suirplus.est_catalogo_ei_t tss on tss.cve_estancia = un.n_cve_estancia
                  where tss.rowid is null
              )
           loop
           insert into suirplus.est_catalogo_ei_t
             (cve_estancia, descripcion_estancia, estatus)
           values
             (est.n_cve_estancia, est.c_nombre_estancia, est.c_estatus);
           end loop;
           commit;
  exception when others then
       rollback;
        p_result := 'ERROR. No se insertaron nuevas Estancias Infantiles.';
  end;
  
  ---************************************************************************************--
  -- Milciades Hernandez
  -- 25/08/2010
  -- saca el resumen de dispersión Estancia Infantiles de acuerdo al periodo.
  ---************************************************************************************--
  procedure Resumen_Dispersion_inf(p_periodo      in suirplus.est_dispersion_resumen_t.periodo_dispersion%type,
                                   p_iocursor     out sys_refcursor,
                                   p_resultnumber out Varchar2) is
    v_bderror varchar2(1000);
  begin
    open p_iocursor for

      select r.id_est_dispersada     ID_ESTANCIA,
             ce.descripcion_estancia Estancia_Infantil,
             r.titulares,
             r.dependientes,
             r.pago
        from suirplus.est_dispersion_resumen_t r
        join suirplus.est_catalogo_ei_t ce
          on ce.cve_estancia = r.id_est_dispersada
       where r.periodo_dispersion = p_periodo
       group by r.id_est_dispersada,
                ce.descripcion_estancia,
                r.titulares,
                r.dependientes,
                r.pago
       order by r.id_est_dispersada asc;

    p_resultnumber := 0;
  exception
    when others then
      v_bderror      := (substr('error ' || to_char(sqlcode) || ':' ||
                                sqlerrm,
                                1,
                                255));
      p_resultnumber := seg_retornar_cadena_error(-1, v_bderror, sqlcode);
  end;
END EST_INFANTILES_PKG;
