CREATE OR REPLACE PACKAGE BODY Suirplus.Sre_Nominas_Pkg IS
  --*******************************************************************
  -- Crea Nominas
  --*******************************************************************
  PROCEDURE nominas_crear(p_id_registro_patronal SRE_NOMINAS_T.id_registro_patronal%TYPE,
                          p_nomina_des           SRE_NOMINAS_T.nomina_des%TYPE,
                          p_status               SRE_NOMINAS_T.status%TYPE,
                          p_tipo_nomina          SRE_NOMINAS_T.tipo_nomina%TYPE,
                          p_ult_usuario_act      SRE_NOMINAS_T.ult_usuario_act%TYPE,
                          p_resultnumber         IN OUT VARCHAR2) IS
    v_longitud  VARCHAR(500);
    v_secuencia NUMBER;
  BEGIN
  
    v_secuencia := isNominaProxima(p_id_registro_patronal);
  
    IF (LENGTH(p_nomina_des)) >
       (Seg_Get_Largo_Columna('SRE_NOMINAS_T', 'NOMINA_DES')) THEN
      v_longitud := 'Descripcion Nomina';
      RAISE e_excedelogintud;
    END IF;
  
    IF NOT
        Sre_Empleadores_Pkg.Existeregistropatronal(p_id_registro_patronal) THEN
      RAISE e_invalidregistropatronal;
    END IF;
  
    -- todo quitar omision de usuario cuando se integre seguridad
    IF p_ult_usuario_act IS NOT NULL AND
       NOT Seg_Usuarios_Pkg.isexisteusuario(p_ult_usuario_act) THEN
      RAISE e_invaliduser;
    END IF;
  
    INSERT INTO SRE_NOMINAS_T
      (id_registro_patronal,
       id_nomina,
       nomina_des,
       status,
       fecha_registro,
       tipo_nomina,
       ult_fecha_act,
       ult_usuario_act)
    VALUES
      (
       -- p_id_registro_patronal, sre_nominas_seq.nextval, p_nomina_des, p_status, sysdate, p_tipo_nomina, sysdate, p_ult_usuario_act
       p_id_registro_patronal,
       v_secuencia,
       p_nomina_des,
       p_status,
       SYSDATE,
       p_tipo_nomina,
       SYSDATE,
       p_ult_usuario_act);
  
    --select '0|' || to_char(sre_nominas_seq.currval) into p_resultnumber from dual ; --nomina creada. retorna 0 para indicar.
    p_resultnumber := 0;
    COMMIT;
  
  EXCEPTION
    WHEN e_invalidregistropatronal THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(3, NULL, NULL);
    WHEN e_invaliduser THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(1, NULL, NULL);
      RETURN;
    WHEN e_excedelogintud THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(15, NULL, NULL) ||
                        v_longitud;
      RETURN;
    WHEN OTHERS THEN
      v_bderror      := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultnumber := Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
      RETURN;
  END;
  --*******************************************************************
  -- Actualiza o Edita Nominas
  --*******************************************************************
  PROCEDURE nominas_editar(p_id_registro_patronal SRE_NOMINAS_T.id_registro_patronal%TYPE,
                           p_id_nomina            SRE_NOMINAS_T.id_nomina%TYPE,
                           p_nomina_des           SRE_NOMINAS_T.nomina_des%TYPE,
                           p_status               SRE_NOMINAS_T.status%TYPE,
                           p_tipo_nomina          SRE_NOMINAS_T.tipo_nomina%TYPE,
                           p_ult_usuario_act      SRE_NOMINAS_T.ult_usuario_act%TYPE,
                           p_resultnumber         IN OUT VARCHAR2) IS
    v_longitud VARCHAR(500);
  BEGIN
  
    IF (LENGTH(p_nomina_des)) >
       (Seg_Get_Largo_Columna('SRE_NOMINAS_T', 'NOMINA_DES')) THEN
      v_longitud := 'Descripcion Nomina';
      RAISE e_excedelogintud;
    END IF;
    IF NOT
        Sre_Empleadores_Pkg.Existeregistropatronal(p_id_registro_patronal) THEN
      RAISE e_invalidregistropatronal;
    END IF;
    IF NOT Seg_Usuarios_Pkg.isexisteusuario(p_ult_usuario_act) THEN
      RAISE e_invaliduser;
    END IF;
  
    UPDATE SRE_NOMINAS_T tr
       SET tr.nomina_des      = p_nomina_des,
           tr.status          = p_status,
           tr.tipo_nomina     = p_tipo_nomina,
           tr.ult_fecha_act   = SYSDATE,
           tr.ult_usuario_act = p_ult_usuario_act
     WHERE tr.id_nomina = p_id_nomina
       AND tr.id_registro_patronal = p_id_registro_patronal;
  
    p_resultnumber := 0; --nomina modificada.
  
    COMMIT;
  
  EXCEPTION
    WHEN e_invalidregistropatronal THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(3, NULL, NULL);
    WHEN e_invaliduser THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(1, NULL, NULL);
      RETURN;
    WHEN e_excedelogintud THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(15, NULL, NULL) ||
                        v_longitud;
      RETURN;
    WHEN OTHERS THEN
      v_bderror      := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultnumber := Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
      RETURN;
  END;

  --*******************************************************************
  -- Borra Nominas
  --*******************************************************************
  PROCEDURE nominas_borrar(p_id_registro_patronal SRE_NOMINAS_T.id_registro_patronal%TYPE,
                           p_id_nomina            SRE_NOMINAS_T.id_nomina%TYPE,
                           p_ult_usuario_act      SRE_NOMINAS_T.ult_usuario_act%TYPE,
                           p_resultnumber         IN OUT VARCHAR2) IS
    CURSOR c_existeaccesonomina IS
      SELECT tp.id_nomina, tp.sre_id_registro_patronal
        FROM SRE_ACCESO_NOMINA tp
       WHERE tp.id_nomina = p_id_nomina
         AND tp.sre_id_registro_patronal = p_id_registro_patronal
         and tp.status = 'A';
    CURSOR c_existetrabajadores IS
      SELECT tp.id_nomina, tp.id_registro_patronal
        FROM SRE_TRABAJADORES_T tp
       WHERE tp.id_nomina = p_id_nomina
         AND tp.id_registro_patronal = p_id_registro_patronal;
  
  BEGIN
  
    OPEN c_existeaccesonomina;
    OPEN c_existetrabajadores;
  
    FETCH c_existeaccesonomina
      INTO v_existeidnomina, v_existeidregistropatronal;
    IF c_existeaccesonomina%FOUND THEN
      CLOSE c_existeaccesonomina;
      RAISE e_invalidnss;
    ELSE
      CLOSE c_existeaccesonomina;
    END IF;
  
    FETCH c_existetrabajadores
      INTO v_existeidnomina, v_existeidregistropatronal;
    IF c_existetrabajadores%FOUND THEN
      CLOSE c_existetrabajadores;
      RAISE e_invalidnss;
    ELSE
      CLOSE c_existetrabajadores;
    END IF;
  
    IF NOT Seg_Usuarios_Pkg.isexisteusuario(p_ult_usuario_act) THEN
      RAISE e_invaliduser;
    END IF;
  
    -- creamos el delete.
    DELETE SRE_NOMINAS_T t
     WHERE t.id_registro_patronal = p_id_registro_patronal
       AND t.id_nomina = p_id_nomina;
  
    p_resultnumber := 0; --nomina borrada. retorna 0 para indicar.
    --ejecutamos el delete
    COMMIT;
    RETURN;
    -- aplicamos las excepciones, y traemos los mensajes desde la tabla de errores.
  EXCEPTION
    WHEN e_invalidnss THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(9, NULL, NULL);
      RETURN;
    WHEN e_invaliduser THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(1, NULL, NULL);
      RETURN;
    WHEN OTHERS THEN
      v_bderror      := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultnumber := Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
      RETURN;
  END;
  --*******************************************************************
  -- Seleccion de Nominas
  --*******************************************************************
  PROCEDURE nominas_select(p_id_nomina            SRE_NOMINAS_T.id_nomina%TYPE,
                           p_id_registro_patronal SRE_NOMINAS_T.id_registro_patronal%TYPE,
                           io_cursor              IN OUT t_cursor)
  
   IS
    /*
    descripcion : paquete ejecuta el select de la tabla de nominas.
    
    params: pid_nomina => identificador de la nomina.
    params: pid_registro_patronal => identificador del registro patronal.
    
    creada ==> 03/nov/2004.
    */
    v_cursor t_cursor;
  BEGIN
  
    IF (p_id_nomina IS NOT NULL) AND (p_id_registro_patronal IS NULL) THEN
      OPEN v_cursor FOR
        SELECT n.id_registro_patronal,
               n.id_nomina,
               n.nomina_des,
               n.status,
               n.fecha_registro,
               n.tipo_nomina,
               t.descripcion tipo_des
          FROM SRE_NOMINAS_T n
          join sfc_tipo_nominas_t t
            on n.tipo_nomina = t.id_tipo_nomina
         WHERE n.id_nomina = p_id_nomina
           AND n.id_nomina NOT IN ('999', '888')
         ORDER BY n.NOMINA_DES;
    
      io_cursor := v_cursor;
      RETURN;
    ELSIF (p_id_registro_patronal IS NOT NULL) AND (p_id_nomina IS NULL) THEN
      OPEN v_cursor FOR
        SELECT n.id_registro_patronal,
               n.id_nomina,
               InitCap(n.nomina_des) nomina_des,
               n.status,
               n.fecha_registro,
               n.tipo_nomina,
               t.descripcion tipo_des
          FROM SRE_NOMINAS_T n
          join sfc_tipo_nominas_t t
            on n.tipo_nomina = t.id_tipo_nomina
         WHERE n.id_registro_patronal = p_id_registro_patronal
           AND n.id_nomina NOT IN ('999', '888')
           AND n.tipo_nomina <> 'L'
         ORDER BY n.id_nomina;
    
      io_cursor := v_cursor;
      RETURN;
    ELSIF (p_id_nomina IS NOT NULL) AND
          (p_id_registro_patronal IS NOT NULL) THEN
      OPEN v_cursor FOR
        SELECT n.id_registro_patronal,
               n.id_nomina,
               n.nomina_des,
               n.status,
               n.fecha_registro,
               n.tipo_nomina,
               t.descripcion tipo_des
          FROM SRE_NOMINAS_T n
          join sfc_tipo_nominas_t t
            on n.tipo_nomina = t.id_tipo_nomina
         WHERE n.id_registro_patronal = p_id_registro_patronal
           AND n.id_nomina = p_id_nomina
           AND n.id_nomina NOT IN ('999', '888')
             AND n.tipo_nomina <> 'L'
         ORDER BY n.NOMINA_DES;
    
      io_cursor := v_cursor;
      RETURN;
    ELSIF (p_id_nomina IS NULL) AND (p_id_registro_patronal IS NULL) THEN
      OPEN v_cursor FOR
        SELECT n.id_registro_patronal,
               n.id_nomina,
               n.nomina_des,
               n.status,
               n.fecha_registro,
               n.tipo_nomina,
               t.descripcion tipo_des
          FROM SRE_NOMINAS_T n
          join sfc_tipo_nominas_t t
            on n.tipo_nomina = t.id_tipo_nomina
         WHERE n.id_nomina NOT IN ('999', '888')
          AND n.tipo_nomina <> 'L'
         ORDER BY n.NOMINA_DES;
    
      io_cursor := v_cursor;
      RETURN;
    END IF;
  END;

  --***************************************************************

  --Procedimiento utilizado para obtener el detalle de una nomina

  --***************************************************************
  PROCEDURE get_Detalle_Nomina(p_id_nomina            SRE_NOMINAS_T.id_nomina%TYPE,
                               p_id_registro_patronal SRE_NOMINAS_T.id_registro_patronal%TYPE,
                               p_io_cursor            IN OUT t_cursor,
                               p_resultnumber         OUT VARCHAR2) IS
  
    c_cursor          t_cursor;
    v_bderror         VARCHAR(1000);
    v_periodo_vigente VARCHAR(6);
  
  BEGIN
  
    IF NOT
        Sre_Empleadores_Pkg.Existeregistropatronal(p_id_registro_patronal) THEN
      RAISE e_InvalidRegistropatronal;
    END IF;
  
    IF NOT isNominaValida(p_id_registro_patronal, p_id_nomina) THEN
      RAISE e_InvalidNomina;
    END IF;
  
    v_periodo_vigente := parm.periodo_vigente();
  
    OPEN c_cursor FOR
      SELECT nombre_completo,
             no_documento,
             id_nss,
             salario_ss,
             salario_isr,
             salario_infotep,
             saldo_favor_isr      AS saldo_a_favor_del_periodo,
             remuneracion_isr     AS remuneraciones_otros_agentes,
             otros_ingresos_isr   AS otras_remuneraciones,
             ingresos_exentos     AS ingresos_extentos_del_periodo,
             agente_retencion_isr
        FROM (SELECT Srp_Pkg.propercase(c.primer_apellido || ' ' ||
                                        c.segundo_apellido || ', ' ||
                                        c.nombres) nombre_completo,
                     c.no_documento,
                     ocultaNSS(c.tipo_documento, t.id_nss) id_nss,
                     t.salario_ss,
                     t.salario_isr,
                     t.salario_infotep,
                     NVL(i.saldo_favor_isr, 0.00) saldo_favor_isr,
                     NVL(i.remuneracion_isr_otros, 0.00) remuneracion_isr,
                     NVL(i.otros_ingresos_isr, 0.00) otros_ingresos_isr,
                     NVL(i.ingresos_exentos_isr, 0.00) ingresos_exentos,
                     i.agente_retencion_isr
                FROM SRE_TRABAJADORES_T t,
                     SRE_CIUDADANOS_T c,
                     (SELECT *
                        FROM SFC_IR13_T
                       WHERE periodo = v_periodo_vigente
                         AND id_registro_patronal = p_id_registro_patronal) i
               WHERE t.id_nss = c.id_nss
                 AND t.id_registro_patronal = i.id_registro_patronal(+)
                 AND t.id_nss = i.id_nss(+)
                 AND t.id_registro_patronal = p_id_registro_patronal
                 AND t.id_nomina = p_id_nomina
                 AND t.status <> 'B')
       ORDER BY nombre_completo;
  
    p_resultnumber := 0;
    p_io_cursor    := c_cursor;
  
  EXCEPTION
  
    WHEN e_InvalidRegistropatronal THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(3, NULL, NULL);
      RETURN;
    
    WHEN e_InvalidNomina THEN
      p_ResultNumber := Seg_Retornar_Cadena_Error(155, NULL, NULL);
      RETURN;
    
    WHEN OTHERS THEN
      v_bderror      := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultnumber := Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
    
  END get_Detalle_Nomina;
  --*************
  --***************************************************************

  --Procedimiento utilizado para obtener el detalle de una nomina

  --***************************************************************
  PROCEDURE get_Detalle_Ced_Cancelada(p_id_nomina            SRE_NOMINAS_T.id_nomina%TYPE,
                                      p_id_registro_patronal SRE_NOMINAS_T.id_registro_patronal%TYPE,
                                      p_io_cursor            IN OUT t_cursor,
                                      p_resultnumber         OUT VARCHAR2) IS
  
    c_cursor          t_cursor;
    v_bderror         VARCHAR(1000);
    v_periodo_vigente VARCHAR(6);
  
  BEGIN
  
    IF NOT
        Sre_Empleadores_Pkg.Existeregistropatronal(p_id_registro_patronal) THEN
      RAISE e_InvalidRegistropatronal;
    END IF;
  
    IF NOT isNominaValida(p_id_registro_patronal, p_id_nomina) THEN
      RAISE e_InvalidNomina;
    END IF;
  
    v_periodo_vigente := parm.periodo_vigente();
  
    OPEN c_cursor FOR
      SELECT nombre_completo,
             no_documento,
             id_nss,
             salario_ss,
             salario_isr,
             salario_infotep,
             saldo_favor_isr      AS saldo_a_favor_del_periodo,
             remuneracion_isr     AS remuneraciones_otros_agentes,
             otros_ingresos_isr   AS otras_remuneraciones,
             ingresos_exentos     AS ingresos_extentos_del_periodo,
             agente_retencion_isr
        FROM (SELECT Srp_Pkg.propercase(c.primer_apellido || ' ' ||
                                        c.segundo_apellido || ', ' ||
                                        c.nombres) nombre_completo,
                     c.no_documento,
                     ocultaNSS(c.tipo_documento, t.id_nss) id_nss,
                     t.salario_ss,
                     t.salario_isr,
                     t.salario_infotep,
                     NVL(i.saldo_favor_isr, 0.00) saldo_favor_isr,
                     NVL(i.remuneracion_isr_otros, 0.00) remuneracion_isr,
                     NVL(i.otros_ingresos_isr, 0.00) otros_ingresos_isr,
                     NVL(i.ingresos_exentos_isr, 0.00) ingresos_exentos,
                     i.agente_retencion_isr
                FROM SRE_TRABAJADORES_T t,
                     SRE_CIUDADANOS_T c,
                     (SELECT *
                        FROM SFC_IR13_T
                       WHERE periodo = v_periodo_vigente
                         AND id_registro_patronal = p_id_registro_patronal) i
               WHERE t.id_nss = c.id_nss
                 AND t.id_registro_patronal = i.id_registro_patronal(+)
                 AND t.id_nss = i.id_nss(+)
                 AND t.id_registro_patronal = p_id_registro_patronal
                 AND t.id_nomina = p_id_nomina
                 AND t.status <> 'B'
                 and c.tipo_documento = 'C'
                 and c.tipo_causa = 'C')
       ORDER BY nombre_completo;
  
    p_resultnumber := 0;
    p_io_cursor    := c_cursor;
  
  EXCEPTION
  
    WHEN e_InvalidRegistropatronal THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(3, NULL, NULL);
      RETURN;
    
    WHEN e_InvalidNomina THEN
      p_ResultNumber := Seg_Retornar_Cadena_Error(155, NULL, NULL);
      RETURN;
    
    WHEN OTHERS THEN
      v_bderror      := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultnumber := Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
    
  END get_Detalle_Ced_Cancelada;

  --********************************************************
  --**************
  --**************
  --********************************************************
  PROCEDURE Consulta_Trabajadores(p_id_registro_patronal SRE_ACCESO_NOMINA.id_registro_patronal%TYPE,
                                  io_cursor              OUT t_cursor) IS
    v_cursor t_cursor;
  
  BEGIN
  
    -- selecciona los datos por los valores de registro patronal y nss recibidos.
    OPEN v_cursor FOR
    
  SELECT trabajador.id_registro_patronal,nomina.id_nomina,
         initcap(nomina.nomina_des) Nomina_Des,
         (select count(t.id_nss) from sre_trabajadores_t t 
           where t.id_registro_patronal = p_id_registro_patronal
            and t.id_nomina = nomina.id_nomina
            and t.status <> 'B') trabajadores,
            
         Nvl((select count(d.id_nss_dependiente) 
         from sre_dependiente_t d
           where d.id_registro_patronal = p_id_registro_patronal
             and d.status = 'A' 
             and d.id_nomina = nomina.id_nomina),0) Dependientes,
             tipo.descripcion tipo_nomina,
                DECODE(nomina.status, 'B', 'De Baja', 'Activa') status_nomina

  FROM sre_trabajadores_t trabajador 
  inner join suirplus.SRE_NOMINAS_T nomina 
  on trabajador.id_registro_patronal = nomina.id_registro_patronal, sfc_tipo_nominas_t tipo

  WHERE trabajador.id_registro_patronal = p_id_registro_patronal
          AND trabajador.status <> 'B' 
          AND nomina.id_nomina NOT IN ('999', '888')
          AND nomina.tipo_nomina <> 'L' 
          AND trabajador.id_registro_patronal = nomina.id_registro_patronal
          AND tipo.id_tipo_nomina = nomina.tipo_nomina
  GROUP BY trabajador.id_registro_patronal,  
           nomina.id_nomina,
           nomina.nomina_des,
           tipo.descripcion,
           nomina.status
  order by nomina.id_nomina;         
    
/*      SELECT N.id_registro_patronal,
             N.id_nomina,
             initcap(n.nomina_des) Nomina_Des,
             N.trabajadores,
             Nvl(d.dependientes, 0) Dependientes,
             N.tipo_nomina,
             N.status_nomina status_nomina
        FROM (SELECT n.id_registro_patronal,
                     n.id_nomina,
                     n.nomina_des,
                     DECODE(n.tipo_nomina,
                            'N',
                            'Normal',
                            'P',
                            'Pensionado',
                            'D',
                            'Discapacitados') tipo_nomina,
                     COUNT(t.id_nss) AS Trabajadores,
                     DECODE(n.status, 'B', 'De Baja', 'Activa') status_nomina
                FROM suirplus.SRE_TRABAJADORES_T t, suirplus.SRE_NOMINAS_T n
               WHERE t.id_registro_patronal = n.id_registro_patronal
                 AND n.id_nomina = t.id_nomina
                 AND t.id_registro_patronal = p_id_registro_patronal
                 AND n.id_nomina NOT IN ('999', '888')
                 AND n.tipo_nomina <> 'L'
                 AND t.status <> 'B'
               GROUP BY n.id_registro_patronal,
                        n.id_nomina,
                        n.nomina_des,
                        n.tipo_nomina,
                        n.status
              UNION ALL
              SELECT n.id_registro_patronal,
                     n.id_nomina,
                     n.nomina_des,
                     DECODE(n.tipo_nomina,
                            'N',
                            'Normal',
                            'P',
                            'Pensionado',
                            'D',
                            'Discapacitados') tipo_nomina,
                     0,
                     DECODE(n.status, 'B', 'De Baja', 'Activa') status_nomina
                FROM suirplus.SRE_NOMINAS_T n
               WHERE NOT EXISTS
               (SELECT 1
                        FROM suirplus.SRE_TRABAJADORES_T t
                       WHERE t.id_registro_patronal = n.id_registro_patronal
                         AND t.id_registro_patronal = p_id_registro_patronal
                         AND n.id_nomina = t.id_nomina
                         AND n.id_nomina NOT IN ('999', '888')
                         AND t.status <> 'B')
                 AND n.id_registro_patronal = p_id_registro_patronal
                 AND n.id_nomina NOT IN ('999', '888')) N,
             (Select d.id_nomina, Count(d.id_nss_dependiente) Dependientes
                From SRE_DEPENDIENTE_T D, sre_trabajadores_t t
               Where t.id_registro_patronal = p_id_registro_patronal
                 and t.status = 'A'
                 and d.id_registro_patronal = t.id_registro_patronal
                 and d.id_nomina = t.id_nomina
                 and d.id_nss = t.id_nss
                 and d.status = 'A'
                 
                 group by d.id_nomina) D
       Where N.TIPO_NOMINA <> 'L' and  N.id_nomina = D.id_nomina(+)
       ORDER BY n.id_nomina;*/
  
    io_cursor := v_cursor;
    RETURN;
  
  END;

  PROCEDURE Consulta_Dependientes(p_id_registro_patronal SRE_ACCESO_NOMINA.id_registro_patronal%TYPE,
                                  io_cursor              OUT t_cursor) IS
    v_cursor t_cursor;
  
  BEGIN
  
    -- selecciona los datos por los valores de registro patronal y nss recibidos.
    OPEN v_cursor FOR
    
     SELECT N.id_registro_patronal,
             N.id_nomina,
             N.nomina_des,
             N.trabajadores,
             n.dependientes,
             N.tipo_nomina,
             N.status_nomina
        FROM (SELECT n.id_registro_patronal,
                     n.id_nomina,
                     n.nomina_des,
                    /* DECODE(n.tipo_nomina,
                            'N',
                            'NOR',
                            'P',
                            'PEN',
                            'D',
                            'DIS') tipo_nomina*/ ti.descripcion tipo_nomina,
                     COUNT(distinct t.id_nss) as Trabajadores,
                     count(d.id_nss_dependiente) as dependientes,
                     n.status as status_nomina
                FROM suirplus.SRE_TRABAJADORES_T t,
                     suirplus.SRE_NOMINAS_T      n,
                     sre_dependiente_t           d,
                     sfc_tipo_nominas_t ti
               
               WHERE t.id_registro_patronal = n.id_registro_patronal
                 AND n.id_nomina = t.id_nomina
                 AND t.id_registro_patronal = p_id_registro_patronal
                 AND n.id_nomina NOT IN ('999', '888')
                 AND t.status <> 'B'
                 and d.id_registro_patronal = t.id_registro_patronal(+)
                 and d.id_nomina = t.id_nomina(+)
                 and d.id_nss = t.id_nss
                 and d.status = 'A'
                 and n.tipo_nomina = ti.id_tipo_nomina
               GROUP BY n.id_registro_patronal,
                        n.id_nomina,
                        n.nomina_des,
                        /*n.tipo_nomina,*/
                        ti.descripcion,
                        n.status
              UNION ALL
              SELECT n.id_registro_patronal,
                     n.id_nomina,
                     n.nomina_des,
/*                     DECODE(n.tipo_nomina,
                            'N',
                            'NOR',
                            'P',
                            'PEN',
                            'D',
                            'DIS') tipo_nomina*/t.descripcion tipo_nomina,
                     0,
                     0,
                     n.status as status_nomina
                     
                FROM suirplus.SRE_NOMINAS_T n join suirplus.sfc_tipo_nominas_t t
                on n.tipo_nomina = t.id_tipo_nomina
               WHERE NOT EXISTS
               (SELECT 1
                        FROM suirplus.SRE_TRABAJADORES_T t
                       WHERE t.id_registro_patronal = n.id_registro_patronal
                         AND t.id_registro_patronal = p_id_registro_patronal
                         AND n.id_nomina = t.id_nomina
                         AND n.id_nomina NOT IN ('999', '888')
                         AND t.status <> 'B')
                 AND n.id_registro_patronal = p_id_registro_patronal
                 AND n.id_nomina NOT IN ('999', '888')) N
       ORDER BY id_nomina;       
/*      SELECT N.id_registro_patronal,
             N.id_nomina,
             N.nomina_des,
             N.trabajadores,
             n.dependientes,
             N.tipo_nomina,
             N.status_nomina
        FROM (SELECT n.id_registro_patronal,
                     n.id_nomina,
                     n.nomina_des,
                     DECODE(n.tipo_nomina,
                            'N',
                            'NOR',
                            'P',
                            'PEN',
                            'D',
                            'DIS') tipo_nomina,
                     COUNT(distinct t.id_nss) as Trabajadores,
                     count(d.id_nss_dependiente) as dependientes,
                     n.status as status_nomina
                FROM suirplus.SRE_TRABAJADORES_T t,
                     suirplus.SRE_NOMINAS_T      n,
                     sre_dependiente_t           d
               WHERE t.id_registro_patronal = n.id_registro_patronal
                 AND n.id_nomina = t.id_nomina
                 AND t.id_registro_patronal = p_id_registro_patronal
                 AND n.id_nomina NOT IN ('999', '888')
                 AND t.status <> 'B'
                 and d.id_registro_patronal = t.id_registro_patronal(+)
                 and d.id_nomina = t.id_nomina(+)
                 and d.id_nss = t.id_nss
                 and d.status = 'A'
               GROUP BY n.id_registro_patronal,
                        n.id_nomina,
                        n.nomina_des,
                        n.tipo_nomina,
                        n.status
              UNION ALL
              SELECT n.id_registro_patronal,
                     n.id_nomina,
                     n.nomina_des,
                     DECODE(n.tipo_nomina,
                            'N',
                            'NOR',
                            'P',
                            'PEN',
                            'D',
                            'DIS') tipo_nomina,
                     0,
                     0,
                     n.status as status_nomina
                FROM suirplus.SRE_NOMINAS_T n
               WHERE NOT EXISTS
               (SELECT 1
                        FROM suirplus.SRE_TRABAJADORES_T t
                       WHERE t.id_registro_patronal = n.id_registro_patronal
                         AND t.id_registro_patronal = p_id_registro_patronal
                         AND n.id_nomina = t.id_nomina
                         AND n.id_nomina NOT IN ('999', '888')
                         AND t.status <> 'B')
                 AND n.id_registro_patronal = p_id_registro_patronal
                 AND n.id_nomina NOT IN ('999', '888')) N
       ORDER BY nomina_des;*/
  
    io_cursor := v_cursor;
    RETURN;
  
  END;

  --**************************
  -- Funcion Nomina
  --***************************

  FUNCTION isNominaValida(p_Id_Registro_Patronal SRE_NOMINAS_T.id_registro_patronal%TYPE,
                          p_id_nomina            SRE_NOMINAS_T.id_nomina%TYPE)
    RETURN BOOLEAN IS
  
    CURSOR c_existe_nomina IS
    
      SELECT t.Id_Registro_Patronal, t.id_nomina
        FROM SRE_NOMINAS_T t
       WHERE t.ID_registro_patronal = p_Id_Registro_patronal
         AND t.id_nomina = p_id_nomina;
    returnValue          BOOLEAN;
    p_IdRegistroPatronal VARCHAR(22);
    p_IdNomina           VARCHAR(22);
  BEGIN
    OPEN c_existe_nomina;
    FETCH c_existe_nomina
      INTO p_IdRegistroPatronal, p_IdNomina;
    returnValue := c_existe_nomina%FOUND;
    CLOSE c_existe_nomina;
  
    RETURN(returnValue);
  
  END isNominaValida;

  --*********************************************************************
  -- Funcion que devuelve la ultima Nomina del Registro Patronal enviado
  --*********************************************************************
  FUNCTION isNominaProxima(p_Id_Registro_Patronal SRE_NOMINAS_T.id_registro_patronal%TYPE)
    RETURN VARCHAR IS
  
    v_maximo    NUMBER;
    v_id_nomina VARCHAR(22);
  
    CURSOR c_existe_nomina IS
      SELECT MAX(id_nomina)
        FROM SRE_NOMINAS_T t
       WHERE t.ID_registro_patronal = p_Id_Registro_Patronal
         AND id_nomina NOT IN ('999', '888', '444', '333');
  
  BEGIN
    v_maximo := 0;
  
    OPEN c_existe_nomina;
    FETCH c_existe_nomina
      INTO v_id_nomina;
    -- if (c_existe_nomina%notfound) then
    IF (v_id_nomina IS NULL) THEN
      v_maximo := 1;
    ELSE
      v_maximo := v_id_nomina + 1;
    END IF;
    CLOSE c_existe_nomina;
    RETURN(v_maximo);
  
  END isNominaProxima;
  --***********************************************************************
  --***********************************************************************
  FUNCTION ocultaNSS(p_tipoDocumento SRE_CIUDADANOS_T.tipo_documento%TYPE,
                     p_NSS           SRE_CIUDADANOS_T.id_nss%TYPE)
    RETURN NUMBER
  
   IS
  
    v_nss SRE_CIUDADANOS_T.id_nss%TYPE;
  
  BEGIN
    v_nss := NULL;
    IF p_tipoDocumento = 'C' THEN
      v_nss := p_NSS;
    END IF;
  
    RETURN v_nss;
  
  END;

  -- **************************************************************************************************
  -- PROCEDIMIENTO:  Cedulas_Canceladas
  -- DESCRIPCION:    Trae todos los trabajadores con cedulas canceladas por nomina.
  -- **************************************************************************************************

  PROCEDURE Cedulas_Canceladas(p_id_nomina            SRE_NOMINAS_T.id_nomina%TYPE,
                               p_id_registro_patronal SRE_NOMINAS_T.id_registro_patronal%TYPE,
                               p_io_cursor            IN OUT t_cursor,
                               p_resultnumber         OUT VARCHAR2) IS
  
    c_cursor  t_cursor;
    v_bderror VARCHAR(1000);
  
  BEGIN
  
    IF NOT
        Sre_Empleadores_Pkg.Existeregistropatronal(p_id_registro_patronal) THEN
      RAISE e_InvalidRegistropatronal;
    END IF;
  
    IF NOT isNominaValida(p_id_registro_patronal, p_id_nomina) THEN
      RAISE e_InvalidNomina;
    END IF;
  
    OPEN c_cursor FOR
    
      select c.nombres || ' ' || nvl(c.primer_apellido, '') || ' ' ||
             nvl(c.segundo_apellido, ' ') as "NOMBRE COMPLETO",
             c.no_documento,
             c.id_nss,
             t.salario_ss,
             i.cancelacion_des as MOTIVO
        from sre_ciudadanos_t      c,
             sre_inhabilidad_jce_t i,
             sre_trabajadores_t    t
       where c.id_causa_inhabilidad = i.id_causa_inhabilidad
         and t.id_nss = c.id_nss
         and t.status = 'A'
         and c.tipo_causa = 'C'
         and c.tipo_documento = 'C'
         and t.id_nomina = p_id_nomina
         and t.id_registro_patronal = p_id_registro_patronal;
  
    p_resultnumber := 0;
    p_io_cursor    := c_cursor;
  
  EXCEPTION
  
    WHEN e_InvalidRegistropatronal THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(3, NULL, NULL);
      RETURN;
    
    WHEN e_InvalidNomina THEN
      p_ResultNumber := Seg_Retornar_Cadena_Error(155, NULL, NULL);
      RETURN;
    
    WHEN OTHERS THEN
      v_bderror      := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultnumber := Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
    
  END Cedulas_Canceladas;

  /*
  //Procedimiento utilizado para obtener el listado de nomina de un empleador
  //Exceptuando la nomina inactivas
  //
  
  //Developed By Ronny Carreras
  
  */
  PROCEDURE getNominasPorRNC(p_rnc          sre_empleadores_t.rnc_o_cedula%TYPE,
                             p_io_cursor    OUT t_cursor,
                             p_resultnumber OUT VARCHAR2) IS
    c_cursor      t_cursor;
    v_regPatronal sre_empleadores_t.id_registro_patronal%TYPE;
    v_bderror     VARCHAR(1000);
  
  BEGIN
    v_regPatronal := suirplus.sre_empleadores_pkg.get_registropatronal(p_rnc);
  
    IF NOT Sre_Empleadores_Pkg.Existeregistropatronal(v_regPatronal) THEN
      RAISE e_InvalidRegistropatronal;
    END IF;
  
    OPEN c_cursor FOR
      SELECT n.id_nomina, initcap(n.nomina_des) nomina_des
        FROM SRE_NOMINAS_T n
       WHERE n.id_registro_patronal = v_regPatronal
         AND n.id_nomina NOT IN ('999', '888')
       ORDER BY n.NOMINA_DES;
  
    p_io_cursor := c_cursor;
  
  EXCEPTION
  
    WHEN e_InvalidRegistropatronal THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(3, NULL, NULL);
      RETURN;
    
    WHEN OTHERS THEN
      v_bderror      := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultnumber := Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
  END;

  /*****************************************************************************************/

  PROCEDURE getPage_Detalle_Nomina(p_id_nomina            SRE_NOMINAS_T.id_nomina%TYPE,
                                   p_id_registro_patronal SRE_NOMINAS_T.id_registro_patronal%TYPE,
                                   p_tipo                 in varchar2,
                                   p_criterio             in varchar2,
                                   p_pagenum              in number,
                                   p_pagesize             in number,
                                   p_io_cursor            OUT t_cursor,
                                   p_resultnumber         OUT VARCHAR2) IS
  
    c_cursor          t_cursor;
    v_bderror         VARCHAR(1000);
    v_periodo_vigente VARCHAR(6);
  
    vDesde integer := (p_pagesize * (p_pagenum - 1)) + 1;
    vhasta integer := p_pagesize * p_pagenum;
  BEGIN
    IF NOT
        Sre_Empleadores_Pkg.Existeregistropatronal(p_id_registro_patronal) THEN
      RAISE e_InvalidRegistropatronal;
    END IF;
  
    IF NOT isNominaValida(p_id_registro_patronal, p_id_nomina) THEN
      RAISE e_InvalidNomina;
    END IF;
  
    v_periodo_vigente := parm.periodo_vigente();
  
    OPEN c_cursor FOR
      with x as
       (select rownum num, y.*
          from (SELECT initcap(c.primer_apellido || ' ' || c.segundo_apellido || ', ' ||
                               c.nombres) nombre_completo,
                       c.no_documento,
                       decode(c.tipo_documento, 'C', t.id_nss, null) id_nss,
                       t.salario_ss,
                       t.salario_isr,
                       t.salario_infotep,
                       NVL(i.saldo_favor_isr, 0.00) saldo_a_favor_del_periodo,
                       NVL(i.remuneracion_isr_otros, 0.00) remuneraciones_otros_agentes,
                       NVL(i.otros_ingresos_isr, 0.00) otras_remuneraciones,
                       NVL(i.ingresos_exentos_isr, 0.00) ingresos_extentos_del_periodo,
                       i.agente_retencion_isr,
                       ti.descripcion tipo_ingreso,
                       t.fecha_ingreso
                  FROM SRE_TRABAJADORES_T t
                  join sre_ciudadanos_t c
                    on c.id_nss = t.id_nss
                   and (p_criterio is null or
                       (p_tipo = 'D' and c.no_documento = p_criterio) or
                       (p_tipo = 'A' and c.primer_apellido like
                       '%' || upper(p_criterio) || '%'))
                  left join SFC_IR13_T i
                    on i.id_registro_patronal = t.id_registro_patronal
                   and i.id_nss = t.id_nss
                   and i.periodo = v_periodo_vigente
                  left join sre_tipo_ingreso_t ti
                    on t.cod_ingreso = ti.cod_ingreso
                 WHERE t.id_registro_patronal = p_id_registro_patronal
                   AND t.id_nomina = p_id_nomina
                   AND t.status <> 'B'
                 order by c.primer_apellido, c.segundo_apellido, c.nombres) y)
      select y.recordcount, x.*
        from x, (select max(num) recordcount from x) y
       where num between vDesde and vHasta
       order by num;
  
    p_resultnumber := 0;
    p_io_cursor    := c_cursor;
  
  EXCEPTION
  
    WHEN e_InvalidRegistropatronal THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(3, NULL, NULL);
      RETURN;
    
    WHEN e_InvalidNomina THEN
      p_ResultNumber := Seg_Retornar_Cadena_Error(155, NULL, NULL);
      RETURN;
    
    WHEN OTHERS THEN
      v_bderror      := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultnumber := Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
    
  END getPage_Detalle_Nomina;
  procedure getNominaDiscapacitados(p_idnss              in sre_trabajadores_t.id_nss%type,
                                    p_idRegistroPatronal in sre_trabajadores_t.id_registro_patronal%type,
                                    p_resultnumber       OUT varchar2,
                                    p_io_cursor          OUT t_cursor) IS
    e_Existe_IdNss exception;
    e_Existe_IdRegistroPatronal exception;
    e_Existe_IdNssRegistroPatronal exception;
    e_Existe_NominaDiscapcidad exception;
    v_cursor t_cursor;
  
  BEGIN
  
    --Validamos si existen
    IF (p_idnss is not null) and (p_idRegistroPatronal is null) THEN
      raise e_Existe_IdRegistroPatronal;
    END IF;
  
    IF (p_idnss is null) and (p_idRegistroPatronal is not null) THEN
      raise e_Existe_IdNss;
    END IF;
  
    IF (p_idnss is null) and (p_idRegistroPatronal is null) THEN
      raise e_Existe_IdNssRegistroPatronal;
    END IF;
  
    OPEN v_cursor FOR
      SELECT t.id_nss, n.id_nomina, n.nomina_des, t.id_registro_patronal
        FROM sre_trabajadores_t t, sre_nominas_t n
       WHERE t.id_nomina = n.id_nomina
         and t.id_registro_patronal = n.id_registro_patronal
         and t.id_nss = p_idnss
         and t.id_registro_patronal = p_idRegistroPatronal
         and t.status = 'A'
       ORDER BY n.nomina_des DESC;
  
    p_io_cursor    := v_cursor;
    p_resultnumber := 0;
  
  EXCEPTION
  
    WHEN e_Existe_IdRegistroPatronal THEN
      p_resultnumber := 'Debe digitar Registro Patronal'; --Seg_Retornar_Cadena_Error(223, NULL, NULL);
      RETURN;
    
    WHEN e_Existe_IdNss THEN
      p_resultnumber := 'Debe digitar Id Nss'; --Seg_Retornar_Cadena_Error(223, NULL, NULL);
      RETURN;
    
    WHEN e_Existe_IdNssRegistroPatronal THEN
      p_resultnumber := 'Debe seleccionar el Id Nss y el Registro Patronal'; --Seg_Retornar_Cadena_Error(223, NULL, NULL);
      RETURN;
    
    WHEN e_Existe_NominaDiscapcidad THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(223, NULL, NULL);
      RETURN;
    
    WHEN OTHERS THEN
      v_bderror      := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultnumber := Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
      RETURN;
    
  END getNominaDiscapacitados;

  /*****************************************************************************************/
  PROCEDURE getTipoNominas(p_io_cursor    OUT t_cursor,
                           p_resultnumber OUT VARCHAR2) IS
    c_cursor  t_cursor;
    v_bderror VARCHAR(1000);
  
  BEGIN
  
    OPEN c_cursor FOR
      select t.id_tipo_nomina,
             t.descripcion,
             t.ult_fecha_act,
             t.ult_usuario_act
        from sfc_tipo_nominas_t t
       where t.id_tipo_nomina in ('D', 'P', 'N'); -- Temporal hasta que se habiliten estas nominas
  
    p_io_cursor := c_cursor;
  
  EXCEPTION
    WHEN OTHERS THEN
      v_bderror      := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultnumber := Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
  END;

/*****************************************************************************************/
--evallejo - 24/06/2014
--Metodo para obtener las distintas nominas de un empleador especificando, el Registro patronal 
--y el tipode nomina a obtener
/*****************************************************************************************/
  PROCEDURE getTipoNominasXEmpresas(p_id_registro_patronal SRE_NOMINAS_T.id_registro_patronal%TYPE,
                                    p_tipo_nomina sfc_tipo_nominas_t.id_tipo_nomina%type,
                                    p_io_cursor    OUT t_cursor,
                                    p_resultnumber OUT VARCHAR2) IS
    c_cursor      t_cursor;
    v_bderror     VARCHAR(1000);
  
  BEGIN
    
    IF NOT Sre_Empleadores_Pkg.Existeregistropatronal(p_id_registro_patronal) THEN
      RAISE e_InvalidRegistropatronal;
    END IF;
  
  
    OPEN c_cursor FOR
      SELECT n.id_nomina, initcap(n.nomina_des) nomina_des
        FROM SRE_NOMINAS_T n
       WHERE n.id_registro_patronal = p_id_registro_patronal
         AND n.tipo_nomina = p_tipo_nomina and n.status='A'
       ORDER BY n.NOMINA_DES;
  
    p_io_cursor := c_cursor;
  
  EXCEPTION
  
    WHEN e_InvalidRegistropatronal THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(3, NULL, NULL);
      RETURN;
    
    WHEN OTHERS THEN
      v_bderror      := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultnumber := Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
  END;

END;