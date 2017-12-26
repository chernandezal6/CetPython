CREATE OR REPLACE PACKAGE BODY SUIRPLUS.SRE_NOVEDADES_PKG IS

  -- *****************************************************************************************************
  -- program:     SRE_NOVEDADES_PKG
  -- descripcion: procedimientos y funciones
  --
  -- modification history
  -- -----------------------------------------------------------------------------------------------------
  -- date         by              remark
  -- -----------------------------------------------------------------------------------------------------
  -- 11/23/2004 Ronny Carreras  creation
  -- *****************************************************************************************************

  FUNCTION Get_ID_Movimiento(p_RegistroPatronal  SRE_EMPLEADORES_T.id_registro_patronal%TYPE,
                             p_Usuario           SRE_MOVIMIENTO_T.id_usuario%TYPE,
                             p_id_TipoMovimiento SRE_MOVIMIENTO_T.id_tipo_movimiento%TYPE,
                             p_UltUsuarioAct     SRE_MOVIMIENTO_T.ult_usuario_act%TYPE,
                             p_IPAddress         SRE_MOVIMIENTO_T.Ip_Address%TYPE)
    RETURN NUMBER IS

    -- *****************************************************************************************************
    -- Esta funcion es utilizada obtener el id_movimiento para una novedad, si existe una novedad pendiente
    -- retorna el mismo id_movimiento, de lo contrario genera uno y lo inserta en la tabla sre_movimiento_t
    --******************************************************************************************************

    v_periodo_vigente VARCHAR(6);
    v_idmovimiento    NUMBER;

    CURSOR c_cursor IS
      SELECT MAX(t.id_movimiento)
        FROM SRE_MOVIMIENTO_T t
       WHERE t.id_registro_patronal = p_RegistroPatronal
         AND t.id_tipo_movimiento = p_id_TipoMovimiento
         AND t.status = 'N';

  BEGIN
    v_periodo_vigente := Parm.periodo_vigente;
    IF p_id_TipoMovimiento = 'NA' or p_id_TipoMovimiento = 'CCI' or p_id_TipoMovimiento = 'PRE' THEN
      OPEN c_cursor;
      FETCH c_cursor
        INTO v_idmovimiento;
      IF v_idmovimiento IS NULL THEN
        SELECT sre_movimientos_seq.NEXTVAL INTO v_idmovimiento FROM dual;
        INSERT INTO SRE_MOVIMIENTO_T
          (id_movimiento,
           id_registro_patronal,
           id_usuario,
           id_tipo_movimiento,
           fecha_registro,
           periodo_factura,
           ult_usuario_act,
           Ip_Address)
        VALUES
          (v_idmovimiento,
           p_RegistroPatronal,
           p_Usuario,
           p_id_TipoMovimiento,
           SYSDATE,
           v_periodo_vigente,
           p_UltUsuarioAct,
           p_IPAddress);
        COMMIT;
      END IF;
      CLOSE c_cursor;
    ELSE
      OPEN c_cursor;
      FETCH c_cursor
        INTO v_idmovimiento;
      IF v_idmovimiento IS NULL THEN
        SELECT sre_movimientos_seq.NEXTVAL INTO v_idmovimiento FROM dual;
        INSERT INTO SRE_MOVIMIENTO_T
          (id_movimiento,
           id_registro_patronal,
           id_usuario,
           id_tipo_movimiento,
           fecha_registro,
           periodo_factura,
           ult_usuario_act,
           Ip_Address)
        VALUES
          (v_idmovimiento,
           p_RegistroPatronal,
           p_Usuario,
           'NV',
           SYSDATE,
           v_periodo_vigente,
           p_UltUsuarioAct,
           p_IPAddress);
        CLOSE c_cursor;
        COMMIT;
      END IF;
    END IF;

    RETURN v_idmovimiento;
  END Get_ID_Movimiento;

  -- *****************************************************************************************************
  -- Esta funcion es utilizada para obtener el id_linea que se insertara en la tabla sre_det_movimiento_enf_t
  -- si no existe un id_linea retorna 1, de lo contrario retorna el numero maximo + 1.
  -- FR 2008-08-28--
  --******************************************************************************************************
  Function get_id_linea_enf(p_id_movimiento SRE_MOVIMIENTO_T.id_movimiento%TYPE)
    Return Number Is
    v_idlinea Integer := 0;
  Begin

    Select Nvl(Max(Id_Linea) + 1, 1)
      Into v_Idlinea
      From Sre_Det_Movimiento_enf_t t
     Where Id_Movimiento = p_Id_Movimiento;

    RETURN v_idlinea;

  End get_id_linea_enf;
  -- *****************************************************************************************************
  FUNCTION Get_Id_Linea(p_id_movimiento SRE_MOVIMIENTO_T.id_movimiento%TYPE)
    RETURN NUMBER IS

    -- *****************************************************************************************************
    -- Esta funcion es utilizada para obtener el id_linea que se insertara en la tabla sre_det_movimiento_t
    -- si no existe un id_linea retorna 1, de lo contrario retorna el numero maximo + 1.
    --******************************************************************************************************
    v_idlinea NUMBER;

  BEGIN

    SELECT NVL(MAX(id_linea) + 1, 1)
      INTO v_idlinea
      FROM SRE_DET_MOVIMIENTO_T t
     WHERE id_movimiento = p_id_movimiento;

    RETURN v_idlinea;

  END Get_Id_Linea;

  -- *****************************************************************************************************
  FUNCTION isMovimientoValido(p_id_movimiento SRE_MOVIMIENTO_T.id_movimiento%TYPE)
    RETURN BOOLEAN IS

    -- *****************************************************************************************************
    -- Funcion utilizada para verificar si un id_movimiento dado es valido.
    -- *****************************************************************************************************

    v_is_valido    BOOLEAN;
    v_idmovimiento SRE_MOVIMIENTO_T.id_movimiento%TYPE;
    CURSOR c_existe_movimiento IS
      SELECT id_movimiento
        FROM SRE_MOVIMIENTO_T
       WHERE id_movimiento = p_id_movimiento;

  BEGIN

    OPEN c_existe_movimiento;
    FETCH c_existe_movimiento
      INTO v_idmovimiento;
    v_is_valido := c_existe_movimiento%FOUND;
    CLOSE c_existe_movimiento;
    RETURN(v_is_valido);

  END isMovimientoValido;

  --******************************************************************************************************

  -- *****************************************************************************************************
  FUNCTION isDependienteValido(p_id_RegistroPatronal SRE_EMPLEADORES_T.id_registro_patronal%TYPE,
                               p_id_Nomina           SRE_NOMINAS_T.id_nomina%TYPE,
                               p_id_NSS              SRE_TRABAJADORES_T.id_nss%TYPE,
                               p_id_NSS_Dependiente  SRE_TRABAJADORES_T.id_nss%TYPE)

   RETURN BOOLEAN IS

    -- *****************************************************************************************************
    -- Funcion utilizada para verificar si un dependiente dado es valido.
    -- *****************************************************************************************************

    v_is_valido            BOOLEAN;
    v_id_registro_patronal SRE_EMPLEADORES_T.ID_REGISTRO_PATRONAL%TYPE;
    CURSOR c_existe_dependiente IS
      SELECT d.ID_REGISTRO_PATRONAL
        FROM SRE_DEPENDIENTE_T d
       WHERE d.ID_REGISTRO_PATRONAL = p_id_RegistroPatronal
         AND d.ID_NOMINA = p_id_Nomina
         AND d.ID_NSS = p_id_NSS
         AND d.ID_NSS_DEPENDIENTE = p_id_NSS_Dependiente;

  BEGIN

    OPEN c_existe_dependiente;
    FETCH c_existe_dependiente
      INTO v_id_registro_patronal;
    v_is_valido := c_existe_dependiente%FOUND;
    CLOSE c_existe_dependiente;
    RETURN(v_is_valido);

  END isDependienteValido;

  --******************************************************************************************************

  FUNCTION isMovimientoValido(p_IDMovimiento SRE_DET_MOVIMIENTO_T.id_movimiento%TYPE,
                              p_IDLinea      SRE_DET_MOVIMIENTO_T.id_linea%TYPE)
    RETURN BOOLEAN IS

    -- *****************************************************************************************************
    -- Funcion utilizada para verificar si un id_movimiento y un id_linea dado son valido.
    -- *****************************************************************************************************

    v_is_valido    BOOLEAN;
    v_idmovimiento SRE_MOVIMIENTO_T.id_movimiento%TYPE;
    CURSOR existe_movimiento IS
      Select Id_Movimiento
        From Sre_Det_Movimiento_t t
       Where t.Id_Movimiento = p_IDMovimiento
         And t.Id_Linea = p_IDLinea
      Union All
      Select Id_Movimiento
        From Sre_Det_Movimiento_Enf_t Dm
       Where Dm.Id_Movimiento = p_IDMovimiento
         And Dm.Id_Linea = p_IDLinea;

  BEGIN

    OPEN existe_movimiento;
    FETCH existe_movimiento
      INTO v_idmovimiento;
    v_is_valido := existe_movimiento%FOUND;
    CLOSE existe_movimiento;
    RETURN(v_is_valido);

  END isMovimientoValido;

  -- *****************************************************************************************************

  -- *****************************************************************************************************
  -- Funcion utilizada para verificar que un salario es valido.
  -- *****************************************************************************************************
  FUNCTION isTipoMovimientoValido(p_id_TipoMovimiento SRE_MOVIMIENTO_T.id_tipo_movimiento%TYPE)
    RETURN BOOLEAN IS

    v_TipoMovimiento SRE_MOVIMIENTO_T.id_tipo_movimiento%TYPE;
    v_is_valido      BOOLEAN;
    CURSOR c_existe_TipoMovimiento IS
      SELECT id_tipo_movimiento
        FROM SRE_TIPO_MOVIMIENTO_T
       WHERE id_tipo_movimiento = p_id_TipoMovimiento;

  BEGIN

    OPEN c_existe_TipoMovimiento;
    FETCH c_existe_TipoMovimiento
      INTO v_TipoMovimiento;
    v_is_valido := c_existe_TipoMovimiento%FOUND;
    CLOSE c_existe_TipoMovimiento;
    RETURN(v_is_valido);

  END isTipoMovimientoValido;

  -- *****************************************************************************************************

  -- *****************************************************************************************************
  -- Funcion utilizada para verificar que un salario es valido.
  -- *****************************************************************************************************
  FUNCTION isTipoNovedadValido(p_id_TipoNovedad SRE_DET_MOVIMIENTO_T.id_tipo_novedad%TYPE)
    RETURN BOOLEAN IS

    v_TipoNovedad SRE_DET_MOVIMIENTO_T.id_tipo_novedad%TYPE;
    v_is_valido   BOOLEAN;
    CURSOR c_existe_TipoNovedad IS
      SELECT d.id_tipo_novedad
        FROM SRE_TIPO_NOVEDAD_T d
       WHERE d.id_tipo_novedad = p_id_TipoNovedad;

  BEGIN

    OPEN c_existe_TipoNovedad;
    FETCH c_existe_TipoNovedad
      INTO v_TipoNovedad;
    --v_is_valido := c_existe_TipoNovedad%FOUND;
    IF (v_TipoNovedad IS NULL) AND (c_existe_TipoNovedad%NOTFOUND) THEN
      --v_is_valido := c_activo_trabajadores%FOUND;
      v_is_valido := FALSE;
    ELSE
      v_is_valido := TRUE;
    END IF;
    CLOSE c_existe_TipoNovedad;
    RETURN(v_is_valido);

  END isTipoNovedadValido;

  -- *****************************************************************************************************

  --- *****************************************************************************************************
  -- FUNCTION:    isFacturaDelPeriodoPaga
  -- Descripcion: Funcion utilizada para verificar si el periodo que se esta haciendo la novedad
  --              tiene factura paga TSS.
  --  Parametros IN:
  --             p_id_registro_patronal
  --             p_PeriodoFactura
  --
  --  Parametros OUT:
  --             v_is_valido
  --
  -- isFacturaDelPeriodoPaga
  -- -----------------------------------------------------------------------------------------------------

  FUNCTION isFacturaDelPeriodoPaga(p_id_registro_patronal SRE_EMPLEADORES_T.id_registro_patronal%TYPE,
                                   p_id_nomina            SRE_NOMINAS_T.id_nomina%TYPE,
                                   p_PeriodoFactura       SFC_FACTURAS_T.PERIODO_FACTURA%TYPE)
    RETURN BOOLEAN

   IS

    v_id_referencia SFC_FACTURAS_T.id_referencia%TYPE;
    v_is_valido     BOOLEAN;

    CURSOR c_existe_factura IS
      SELECT id_referencia
        FROM SFC_FACTURAS_T t
       WHERE t.id_registro_patronal = p_id_registro_patronal
         AND t.id_nomina = p_id_nomina
         AND t.periodo_factura = p_PeriodoFactura
         AND t.status = 'PA';

  BEGIN

    OPEN c_existe_factura;
    FETCH c_existe_factura
      INTO v_id_referencia;
    v_is_valido := c_existe_factura%FOUND;
    CLOSE c_existe_factura;

    RETURN(v_is_valido);
    v_FacturaPaga := v_is_valido;

  END isFacturaDelPeriodoPaga;

  -- *****************************************************************************************************

  --- *****************************************************************************************************
  -- FUNCTION:    isFacturaAutorizadaNoPaga
  -- Descripcion: Funcion utilizada para si la factura esta autorizada y no paga para la TSS.
  --
  --  Parametros IN:
  --             p_id_registro_patronal
  --             p_PeriodoFactura
  --
  --  Parametros OUT:
  --             v_is_valido
  --
  -- isFacturaAutorizadaNoPaga
  -- -----------------------------------------------------------------------------------------------------

  FUNCTION isFacturaAutorizadaNoPaga(p_id_registro_patronal SRE_EMPLEADORES_T.id_registro_patronal%TYPE,
                                     p_PeriodoFactura       SFC_FACTURAS_T.periodo_factura%TYPE,
                                     p_id_nomina            SFC_FACTURAS_T.ID_NOMINA%TYPE)
    RETURN BOOLEAN IS

    v_id_referencia SFC_FACTURAS_T.id_referencia%TYPE;
    v_is_valido     BOOLEAN;
    CURSOR c_existe_factura IS
      SELECT id_referencia
        FROM SFC_FACTURAS_T t
       WHERE t.id_registro_patronal = p_id_registro_patronal
         AND t.periodo_factura = p_PeriodoFactura
         AND t.id_nomina = p_id_nomina
         AND no_autorizacion IS NOT NULL
            /*AND status != 'PA'
            or status != 'CA'*/
         AND status = 'VI';
  BEGIN

    OPEN c_existe_factura;
    FETCH c_existe_factura
      INTO v_id_referencia;
    v_is_valido := c_existe_factura%FOUND;
    CLOSE c_existe_factura;
    RETURN(v_is_valido);

  END isFacturaAutorizadaNoPaga;

  -- *****************************************************************************************************

  -- *****************************************************************************************************
  -- Funcion que verifica si el periodo que se esta haciendo la novedad tiene factura paga en la DGI.
  -- *****************************************************************************************************
  --- *****************************************************************************************************
  -- FUNCTION:    isFacturaAutorizadaNoPaga
  -- Descripcion: Funcion que verifica si el periodo que se esta haciendo la novedad tiene factura
  --              paga en la DGI.
  --  Parametros IN:
  --             p_id_registro_patronal
  --             p_PeriodoLiquidacion
  --
  --  Parametros OUT:
  --             v_is_valido
  --
  -- isFacturaAutorizadaNoPaga
  -- -----------------------------------------------------------------------------------------------------

  FUNCTION isLiquidacionDelPeriodoPaga(p_id_registro_patronal SRE_EMPLEADORES_T.id_registro_patronal%TYPE,
                                       p_id_nomina            SRE_NOMINAS_T.id_nomina%TYPE,
                                       p_PeriodoLiquidacion   SFC_LIQUIDACION_ISR_T.PERIODO_LIQUIDACION%TYPE)
    RETURN BOOLEAN IS

    v_id_referencia SFC_LIQUIDACION_ISR_T.ID_REFERENCIA_ISR%TYPE;
    v_is_valido     BOOLEAN;
    CURSOR c_existe_liquidacion IS
      SELECT id_referencia_isr
        FROM SFC_LIQUIDACION_ISR_T t
       WHERE t.id_registro_patronal = p_id_registro_patronal
         AND t.id_nomina = p_id_nomina
         AND t.periodo_liquidacion = p_PeriodoLiquidacion
         AND t.status = 'PA';
  BEGIN

    OPEN c_existe_liquidacion;
    FETCH c_existe_liquidacion
      INTO v_id_referencia;
    v_is_valido := c_existe_liquidacion%FOUND;
    CLOSE c_existe_liquidacion;
    RETURN(v_is_valido);
    v_FacturaPaga := v_is_valido;
  END isLiquidacionDelPeriodoPaga;

  -- *****************************************************************************************************

  --- *****************************************************************************************************
  -- FUNCTION:    isLiquidacionAutorizadaNoPaga
  -- Descripcion: Funcion utilizada para si la factura esta autorizada y no paga para la DGI.
  --
  --  Parametros IN:
  --             p_id_registro_patronal
  --             p_PeriodoLiquidacion
  --
  --  Parametros OUT:
  --             v_is_valido
  --
  -- isLiquidacionAutorizadaNoPaga
  -- -----------------------------------------------------------------------------------------------------

  FUNCTION isLiquidacionAutorizadaNoPaga(p_id_registro_patronal SRE_EMPLEADORES_T.id_registro_patronal%TYPE,
                                         p_PeriodoLiquidacion   SFC_LIQUIDACION_ISR_T.PERIODO_LIQUIDACION%TYPE,
                                         p_id_nomina            SFC_FACTURAS_T.ID_NOMINA%TYPE)
    RETURN BOOLEAN IS

    v_id_referencia SFC_LIQUIDACION_ISR_T.ID_REFERENCIA_ISR%TYPE;
    v_is_valido     BOOLEAN;
    CURSOR c_existe_liquidacion IS
      SELECT id_referencia_isr
        FROM SFC_LIQUIDACION_ISR_T t
       WHERE id_registro_patronal = p_id_registro_patronal
         AND periodo_liquidacion = p_PeriodoLiquidacion
            --       AND t.id_nomina =  p_id_nomina
         AND no_autorizacion IS NOT NULL
            /* AND status != 'PA'
            or status != 'CA' */
         AND status = 'VI';
  BEGIN

    OPEN c_existe_liquidacion;
    FETCH c_existe_liquidacion
      INTO v_id_referencia;
    v_is_valido := c_existe_liquidacion%FOUND;
    CLOSE c_existe_liquidacion;
    RETURN(v_is_valido);
  END isLiquidacionAutorizadaNoPaga;

  -- *****************************************************************************************************

  --- *****************************************************************************************************
  -- FUNCTION:    isAgenteEsEmpleador
  -- Descripcion: Funcion utilizada para saber si un agente de retencion es el mismo Empleador.
  --
  --  Parametros IN:
  --             p_agente_retencion_isr
  --             P_RemunOtroEmp
  --             p_id_registro_patronal
  --
  --  Parametros OUT:
  --             v_is_valido
  --
  -- isAgenteEsEmpleador
  -- -----------------------------------------------------------------------------------------------------

  FUNCTION isAgenteEsEmpleador(p_agente_retencion_isr SRE_EMPLEADORES_T.id_registro_patronal%TYPE,
                               p_id_registro_patronal SRE_EMPLEADORES_T.ID_REGISTRO_PATRONAL%TYPE,
                               P_RemunOtroEmp         SRE_DET_MOVIMIENTO_T.REMUNERACION_ISR_OTROS%TYPE)
    RETURN BOOLEAN IS

    v_is_valido BOOLEAN;

  BEGIN
    IF (p_agente_retencion_isr = p_id_registro_patronal) AND
       (P_RemunOtroEmp = 0) THEN
      v_is_valido := TRUE;
    ELSE
      v_is_valido := FALSE;
    END IF;

    RETURN(v_is_valido);
  END isAgenteEsEmpleador;

  -- *****************************************************************************************************

  --- *****************************************************************************************************
  -- FUNCTION:    isAgenteExtranjero
  -- Descripcion: Funcion utilizada para saber si el Agente de Retencion es Extranjero o no.
  --
  --  Parametros IN:
  --             p_id_nss
  --
  --  Parametros OUT:
  --             v_is_valido
  --
  -- isAgenteExtranjero
  -- -----------------------------------------------------------------------------------------------------

  FUNCTION isAgenteExtranjero(p_id_nss SRE_CIUDADANOS_T.ID_NSS%TYPE)
    RETURN BOOLEAN IS

    v_is_valido BOOLEAN;
    v_id_nss    SRE_CIUDADANOS_T.ID_NSS%TYPE;

    CURSOR c_existe_extranjero IS
      SELECT t.id_nss
        FROM SRE_CIUDADANOS_T t
       WHERE t.id_nss = p_id_nss
         AND t.tipo_documento = 'P';

  BEGIN

    OPEN c_existe_extranjero;
    FETCH c_existe_extranjero
      INTO v_id_nss;
    v_is_valido := c_existe_extranjero%FOUND;
    CLOSE c_existe_extranjero;
    RETURN(v_is_valido);
  END isAgenteExtranjero;

  -- *****************************************************************************************************
  -- *****************************************************************************************************

  --- *****************************************************************************************************
  -- FUNCTION:    isActivoTrabajadores
  -- Descripcion: Funcion utilizada si el tranajador esta activo para esa nomina.
  --
  --  Parametros IN:
  --             p_id_nss
  --             p_id_registro_patronal
  --             p_id_nomina
  --
  --  Parametros OUT:
  --             v_is_valido
  --
  -- isAgenteExtranjero
  -- -----------------------------------------------------------------------------------------------------

  FUNCTION isActivoTrabajadores(p_id_nss               SRE_TRABAJADORES_T.id_nss%TYPE,
                                p_id_registro_patronal SRE_EMPLEADORES_T.ID_REGISTRO_PATRONAL%TYPE,
                                p_id_nomina            SRE_TRABAJADORES_T.id_nomina%TYPE)
    RETURN BOOLEAN IS

    v_is_valido BOOLEAN;
    -- v_id_nss    SRE_CIUDADANOS_T.ID_NSS%TYPE;
    -- v_id_registro_patronal  sre_trabajadores_t.id_registro_patronal%type;
    -- v_id_nomina    sre_trabajadores_t.id_nomina%type;

    v_id_nss               VARCHAR2(20);
    v_id_registro_patronal VARCHAR2(20);
    v_id_nomina            VARCHAR2(20);

    CURSOR c_activo_trabajadores IS
      SELECT t.id_nss, t.id_registro_patronal, t.id_nomina
        FROM SRE_TRABAJADORES_T t
       WHERE t.id_nss = p_id_nss
         AND t.id_registro_patronal = p_id_registro_patronal
         AND t.id_nomina = p_id_nomina
         AND t.status = 'A';

  BEGIN

    OPEN c_activo_trabajadores;
    FETCH c_activo_trabajadores
     INTO v_id_nss, v_id_registro_patronal, v_id_nomina;

    v_is_valido := c_activo_trabajadores%FOUND;

    CLOSE c_activo_trabajadores;

    RETURN(v_is_valido);
  END isActivoTrabajadores;

  ------------------------------------------------------------------------------
  -- Para saber si existe como trabajador está activo sin importar el empleador
  ------------------------------------------------------------------------------
  FUNCTION isActivoTrabajadores(p_id_nss SRE_TRABAJADORES_T.id_nss%TYPE) RETURN BOOLEAN IS
   v_conteo pls_integer;
  BEGIN
    SELECT count(*)
	  INTO v_conteo
      FROM suirplus.SRE_TRABAJADORES_T t
     WHERE t.id_nss = p_id_nss
       AND t.status = 'A';
    
	IF v_conteo > 0 THEN
      RETURN TRUE;
    ELSE
      RETURN FALSE;
    END IF;
  END isActivoTrabajadores;

  -- *****************************************************************************************************
  -- *****************************************************************************************************

  --- *****************************************************************************************************
  -- FUNCTION:    isInactivoTrabajadores
  -- Descripcion: Funcion utilizada si el tranajador esta activo para esa nomina.
  --
  --  Parametros IN:
  --             p_id_nss
  --             p_id_registro_patronal
  --             p_id_nomina
  --
  --  Parametros OUT:
  --             v_is_valido
  --
  -- isAgenteExtranjero
  -- -----------------------------------------------------------------------------------------------------

  FUNCTION isInactivoTrabajadores(p_id_nss               SRE_TRABAJADORES_T.id_nss%TYPE,
                                  p_id_registro_patronal SRE_EMPLEADORES_T.ID_REGISTRO_PATRONAL%TYPE,
                                  p_id_nomina            SRE_TRABAJADORES_T.id_nomina%TYPE)
    RETURN BOOLEAN IS

    v_is_valido            BOOLEAN;
    v_id_nss               SRE_CIUDADANOS_T.ID_NSS%TYPE;
    v_id_registro_patronal SRE_TRABAJADORES_T.id_registro_patronal%TYPE;
    v_id_nomina            SRE_TRABAJADORES_T.id_nomina%TYPE;

    CURSOR c_activo_trabajadores IS
      SELECT t.id_nss, t.id_registro_patronal, t.id_nomina
        FROM SRE_TRABAJADORES_T t
       WHERE t.id_nss = p_id_nss
         AND t.id_registro_patronal = p_id_registro_patronal
         AND t.id_nomina = p_id_nomina
         AND t.status = 'B';

  BEGIN

    OPEN c_activo_trabajadores;
    FETCH c_activo_trabajadores
      INTO v_id_nss, v_id_registro_patronal, v_id_nomina;
    -- v_is_valido := c_activo_trabajadores%FOUND;
    IF (c_activo_trabajadores%NOTFOUND) THEN
      --v_is_valido := c_activo_trabajadores%FOUND;
      v_is_valido := FALSE;
    ELSE
      v_is_valido := TRUE;
    END IF;

    CLOSE c_activo_trabajadores;
    RETURN(v_is_valido);
  END isInactivoTrabajadores;

  -- *****************************************************************************************************

  -- *****************************************************************************************************

  --- *****************************************************************************************************
  -- FUNCTION:    isExisteMovimiento
  -- Descripcion: Funcion utilizada si existe un movimiento previo no procesado para el mismo trabajador.
  --
  --  Parametros IN:
  --             p_id_nss
  --             p_id_registro_patronal
  --             p_id_nomina
  --
  --  Parametros OUT:
  --             v_is_valido
  --
  -- isAgenteExtranjero
  -- -----------------------------------------------------------------------------------------------------

  FUNCTION isExisteMovimiento(p_id_nss               SRE_TRABAJADORES_T.id_nss%TYPE,
                              p_id_registro_patronal SRE_REPRESENTANTES_T.id_registro_patronal%TYPE,
                              p_id_tipo_novedad      SRE_DET_MOVIMIENTO_T.Id_Tipo_Novedad%TYPE,
                              p_id_nomina            SRE_TRABAJADORES_T.id_nomina%TYPE)
    RETURN BOOLEAN IS

    v_is_valido       BOOLEAN;
    v_id_nss          VARCHAR(50);
    v_id_tipo_novedad VARCHAR(50);
    v_id_nomina       VARCHAR(50);

    CURSOR c_existe_movimiento IS
    /*SELECT t.id_nss, t.id_tipo_novedad, t.id_nomina
                 FROM SRE_DET_MOVIMIENTO_T t
                 WHERE t.id_nss = p_id_nss
                 and   t.id_nomina = p_id_nomina
                 and   t.id_tipo_novedad = p_id_tipo_novedad; */
      SELECT t.id_nss, t.id_tipo_novedad, t.id_nomina
        FROM SRE_DET_MOVIMIENTO_T t, SRE_MOVIMIENTO_T m
       WHERE m.id_movimiento = t.id_movimiento
         AND t.id_nss = p_id_nss
         AND t.id_nomina = p_id_nomina
         AND t.id_tipo_novedad = p_id_tipo_novedad
         AND m.id_registro_patronal = p_id_registro_patronal
         AND m.status NOT IN ('P', 'R');

  BEGIN

    OPEN c_existe_movimiento;
    FETCH c_existe_movimiento
      INTO v_id_nss, v_id_tipo_novedad, v_id_nomina;
    v_is_valido := c_existe_movimiento%FOUND;
    CLOSE c_existe_movimiento;
    RETURN(v_is_valido);
  END isExisteMovimiento;

  FUNCTION isExisteMovimiento(p_id_nss               SRE_TRABAJADORES_T.id_nss%TYPE,
                              p_id_nss_dependiente   SRE_TRABAJADORES_T.id_nss%TYPE,
                              p_id_registro_patronal SRE_REPRESENTANTES_T.id_registro_patronal%TYPE,
                              p_id_tipo_novedad      SRE_DET_MOVIMIENTO_T.Id_Tipo_Novedad%TYPE,
                              p_id_nomina            SRE_TRABAJADORES_T.id_nomina%TYPE)
    RETURN BOOLEAN IS

    v_is_valido       BOOLEAN;
    v_id_nss          VARCHAR(50);
    v_id_tipo_novedad VARCHAR(50);
    v_id_nomina       VARCHAR(50);

    CURSOR c_existe_movimiento IS

      SELECT t.id_nss, t.id_tipo_novedad, t.id_nomina
        FROM SRE_DET_MOVIMIENTO_T t, SRE_MOVIMIENTO_T m
       WHERE m.id_movimiento = t.id_movimiento
         AND t.id_nss = p_id_nss
         AND t.ID_NSS_DEPENDIENTE = p_id_nss_dependiente
         AND t.id_nomina = p_id_nomina
         AND t.id_tipo_novedad = p_id_tipo_novedad
         AND m.id_registro_patronal = p_id_registro_patronal
         AND m.status NOT IN ('P', 'R');

  BEGIN

    OPEN c_existe_movimiento;
    FETCH c_existe_movimiento
      INTO v_id_nss, v_id_tipo_novedad, v_id_nomina;
    v_is_valido := c_existe_movimiento%FOUND;
    CLOSE c_existe_movimiento;
    RETURN(v_is_valido);
  END isExisteMovimiento;

  -- *****************************************************************************************************

  --- *****************************************************************************************************
  -- FUNCTION:    isAporteVoluntario
  -- Descripcion: Funcion utilizada saber Rango de valor en el campo Aporte voluntario.
  --
  --  Parametros IN:
  --             p_AporteVoluntario
  --
  --  Parametros OUT:
  --             v_is_valido
  --
  -- isAporteVoluntario
  -- -----------------------------------------------------------------------------------------------------

  FUNCTION isAporteVoluntario(p_AporteVoluntario SRE_DET_MOVIMIENTO_T.aporte_voluntario%TYPE)
    RETURN BOOLEAN IS

    v_is_valido BOOLEAN;

  BEGIN
    IF (p_AporteVoluntario < 0) OR (p_AporteVoluntario > 10000000) THEN
      v_is_valido := TRUE;
    ELSE
      v_is_valido := FALSE;
    END IF;

    RETURN(v_is_valido);
  END isAporteVoluntario;

  /*-----------------------------------------------------------------------
  Objetivo: Funcion que verifica el Salario SS para validar los rangos
            en el cual debe estar dicho Salario.
  Autor   : Yacell Borges
  Fecha   : 24-08-2011
  --------------------------------------------------------------------------*/
  Function isSalarioSSValido(p_SalarioSS varchar2) return boolean is
    V_valorinicial NUMBER;
    V_valorfinal   NUMBER;
    v_valortope    number;
    V_SalarioSS    number;
  Begin
    V_SalarioSS := to_Number(p_SalarioSS);

    --para obtener el rango inicial contra el cual se validará el salario SS
    begin
      select valor_numerico
        into V_valorinicial
        from suirplus.sfc_det_parametro_t
       where id_parametro = 356
         and nvl(fecha_fin, sysdate) =
             (SELECT MAX(nvl(fecha_fin, sysdate))
                FROM sfc_det_parametro_t
               WHERE id_parametro = 356);
    exception
      when others then
        v_valorinicial := 0.01;
    end;

    --para obtener el rango final contra el cual se validará el salario SS
    begin
      select valor_numerico
        into V_valorfinal
        from suirplus.sfc_det_parametro_t
       where id_parametro = 354
         and nvl(fecha_fin, sysdate) =
             (SELECT MAX(nvl(fecha_fin, sysdate))
                FROM sfc_det_parametro_t
               WHERE id_parametro = 354);
    exception
      when others then
        v_valorfinal := 200;
    end;

    --para obtener el valor máximo aceptable para el salario SS
    begin
      select valor_numerico
        into v_valortope
        from suirplus.sfc_det_parametro_t
       where id_parametro = 355
         and nvl(fecha_fin, sysdate) =
             (SELECT MAX(nvl(fecha_fin, sysdate))
                FROM sfc_det_parametro_t
               WHERE id_parametro = 355);
    exception
      when others then
        v_valortope := 99;
    end;

    --Verificacion del Salario SS contra el rango permitido.
    If (V_SalarioSS between v_valorinicial and v_valorfinal) then
      Return false;
    Else
      --Para validar el valor tope del salario SS
      If V_SalarioSS > v_valortope then
        Return false;
      Else
        Return true;
      End if;
    End if;
  Exception
    when others then
      return false;
  End;

  -- *****************************************************************************************************

  --- *****************************************************************************************************
  -- FUNCTION:    getPeriodoSiguiente
  -- Descripcion: Funcion que asigna el periodo siguiente si la factura esta paga.
  --
  --  Parametros IN:
  --             p_periodo_vigente
  --             v_FacturaPaga
  --
  --  Parametros OUT:
  --             v_is_valido
  --
  -- getPeriodoSiguiente
  -- -----------------------------------------------------------------------------------------------------

  FUNCTION getPeriodoSiguiente(p_periodo_vigente IN VARCHAR,
                               v_FacturaPaga     IN BOOLEAN) RETURN VARCHAR2 IS
    v_PeriodoSiguienteMes VARCHAR2(10);
    v_PeriodoSiguienteAno VARCHAR2(10);
    v_Periodo             VARCHAR2(10);
    v_mes                 VARCHAR2(2);
    v_ano                 VARCHAR2(4);
    v_cero                VARCHAR2(4);

  BEGIN

    v_mes := SUBSTR(TO_CHAR(p_periodo_vigente), 5, 6);
    v_ano := SUBSTR(TO_CHAR(p_periodo_vigente), 1, 4);

    /* if (v_FacturaPaga = False) then
       p_mensaje:= 'No pagada';
    End if;*/

    IF TO_NUMBER(v_mes) = 12 THEN
      v_mes := '0';
      v_ano := TO_NUMBER(v_ano) + 1;
    END IF;

    v_PeriodoSiguienteMes := TO_NUMBER(v_mes) + 1;
    v_PeriodoSiguienteAno := TO_NUMBER(v_ano);

    IF (v_PeriodoSiguienteMes < 10) THEN
      v_cero := 0 || v_PeriodoSiguienteMes;
    ELSE
      v_cero := v_PeriodoSiguienteMes;
    END IF;

    IF (v_FacturaPaga = TRUE) THEN
      --v_Periodo := v_PeriodoSiguienteMes || v_PeriodoSiguienteAno;
      v_Periodo := v_PeriodoSiguienteAno || v_cero;
    END IF;
    RETURN v_Periodo;

  END getPeriodoSiguiente;
  --  ******************************************************************************
  --- ******************************************************************************

  FUNCTION FormateaFecha(p_fecha VARCHAR2) RETURN DATE IS
  BEGIN

    RETURN TO_DATE(p_fecha, 'MM/DD/YYYY');

  END;
  --funcion para determinar si existe un detalle para ese movimiento----
  --fr 2009-08-27--
  -----------------------------------------------------------------------------
  Function isExisteMovimientoDetalleEnf(p_IDMovimiento SRE_DET_MOVIMIENTO_T.id_movimiento%TYPE)
    Return Boolean Is
    v_registros Integer := 0;
  Begin

    Select Count(*)
      Into v_Registros
      From Sre_Det_Movimiento_Enf_t Ef
     Where Ef.Id_Movimiento = p_Idmovimiento;

    If (v_registros = 0) Then
      Return False;
    End If;
    Return True;
  End isExisteMovimientoDetalleEnf;

  -- *****************************************************************************************************

  -- *****************************************************************************************************
  -- Procedimiento utilizado para eliminar una novedad(movimiento) en la tabla de sre_det_movimiento.
  -- *****************************************************************************************************

  PROCEDURE Borrar_Novedad(p_IDMovimiento SRE_MOVIMIENTO_T.id_movimiento%TYPE,
                           p_IDLinea      SRE_DET_MOVIMIENTO_T.id_linea%TYPE,
                           p_resultnumber OUT VARCHAR2) IS

    v_bd_error VARCHAR(1000);

  BEGIN

    IF NOT Ismovimientovalido(p_IDMovimiento, p_IDLinea) THEN
      RAISE e_invalidmovimiento;
    END IF;

    DELETE FROM SRE_DET_MOVIMIENTO_T
     WHERE id_movimiento = p_IDMovimiento
       AND id_linea = p_IDLinea;

    --Eliminar el registro del detalle de ENF Comun--
    Delete From sre_det_movimiento_enf_t ef
     Where ef.id_movimiento = p_IDMovimiento
       And ef.id_linea = p_IDLinea;

    IF NOT isExisteMovimientoDetalle(p_IDMovimiento) then
      Update sre_movimiento_t m
         set m.status = 'R'
       where m.id_movimiento = p_IDMovimiento;
    end if;

    p_resultnumber := 0;
    COMMIT;

  EXCEPTION

    WHEN e_invalidmovimiento THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(151, NULL, NULL);
      RETURN;

    WHEN OTHERS THEN
      v_bd_error := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' || SQLERRM,
                            1,
                            255));
      RETURN;

  END Borrar_Novedad;

  -----------------------------------------------------------------------------

  -- *****************************************************************************************************
  -- Procedimiento utilizado para aplicar los movimientos pendientes de un empleador.
  -- *****************************************************************************************************

  PROCEDURE Aplicar_Movimientos(p_id_registro_patronal SRE_EMPLEADORES_T.id_registro_patronal%TYPE,
                                p_Usuario              SRE_MOVIMIENTO_T.ult_usuario_act%TYPE,
                                p_resultnumber         OUT VARCHAR2)

   IS

    --v_id_movimiento sre_empleadores_t.id_registro_patronal%TYPE;
    v_registro BOOLEAN;
    v_resul    boolean;

    CURSOR c_existe_registro IS
      SELECT m.id_movimiento
        FROM SRE_MOVIMIENTO_T m
       WHERE id_registro_patronal = p_id_registro_patronal
         AND id_tipo_movimiento in('NV','PRE')
         AND status = 'N';
    --not in ('P','S','E','W'); --no procesado, sometido ni ejecutandose ni aplicado-WEB
    --and ULT_USUARIO_ACT = p_Usuario ;

  BEGIN

    FOR I IN c_existe_registro LOOP
      v_registro := TRUE;
      sre_load_movimiento_pkg.someter_movimiento_web(I.id_movimiento); --Sre_Somete_Movimientos_Pkg(I.id_movimiento);

    /*Esto es temporal para poder probar
                 v_resul := sfs_subsidios_pkg.AplicaNovedadesSFS(I.id_movimiento);
                 */
    END LOOP;
    IF v_registro THEN
      p_resultnumber := 'Cambio Realizado';
    ELSE
      p_resultnumber := 'Movimiento no encontrado';
    END IF;
  END Aplicar_Movimientos;

  --***************************************************************************************************
  -- Retorna los dependientes registrados de un empleado de una nomina especifica.
  --***************************************************************************************************
  PROCEDURE get_Dependientes(p_id_registro_patronal SRE_EMPLEADORES_T.id_registro_patronal%TYPE,
                             p_id_Nomina            SRE_NOMINAS_T.id_nomina%TYPE,
                             p_id_NSS               SRE_TRABAJADORES_T.id_nss%TYPE,
                             p_io_cursor            OUT t_cursor,
                             p_resultnumber         OUT VARCHAR2) IS
    c_cursor  t_cursor;
    v_bderror VARCHAR(1000);

  BEGIN

    IF NOT Existeregistropatronal(p_id_registro_patronal) THEN
      RAISE e_InvalidRegistropatronal;
    END IF;

    --Validacion de la nomina
    IF NOT
        Sre_Nominas_Pkg.isNominaValida(p_id_registro_patronal, p_id_nomina) THEN
      RAISE e_InvalidNomina;
    END IF;

    --Validacion del NSS
    IF NOT Srp_Pkg.Existenss(p_id_nss) THEN
      RAISE e_IvalidNSS;
    END IF;

    /* OPEN c_cursor FOR
      SELECT d.ID_REGISTRO_PATRONAL, d.ID_NOMINA, d.ID_NSS,
                   d.ID_NSS_DEPENDIENTE, d.FECHA_REGISTRO,
             Srp_Pkg.ProperCase((c.nombres || ' ' || c.primer_apellido || ' ' || c.segundo_apellido)) AS NombreDep, c.no_documento documentoDep,
             DECODE(mm.ID_MOVIMIENTO,NULL,'N','S') pendienteBaja,mm.ID_MOVIMIENTO
        FROM SRE_DEPENDIENTE_T d,
                SRE_CIUDADANOS_T c,
             (
                     SELECT m.ID_REGISTRO_PATRONAL id_registro_patronal, dm.ID_NOMINA id_nomina, dm.ID_NSS id_nss, dm.ID_NSS_DEPENDIENTE id_nss_dependiente,m.ID_MOVIMIENTO
                    FROM SRE_MOVIMIENTO_T  m, SRE_DET_MOVIMIENTO_T dm
                    WHERE m.ID_MOVIMIENTO = dm.ID_MOVIMIENTO
                    AND m.STATUS = 'N'
                    AND dm.ID_TIPO_NOVEDAD = 'BD'
            ) mm
        WHERE d.ID_REGISTRO_PATRONAL = p_id_registro_patronal
        AND d.ID_NOMINA=p_id_Nomina
        AND d.ID_NSS = p_id_NSS
        AND d.ID_NSS_DEPENDIENTE = c.ID_NSS
     AND mm.id_nss (+)= d.ID_NSS
     AND d.status='A'
    AND mm.ID_NOMINA (+)= d.ID_NOMINA
        AND mm.ID_REGISTRO_PATRONAL(+) = d.ID_REGISTRO_PATRONAL;*/

    OPEN c_cursor FOR
      SELECT d.ID_REGISTRO_PATRONAL,
             d.ID_NOMINA,
             d.ID_NSS,
             d.ID_NSS_DEPENDIENTE,
             d.FECHA_REGISTRO,
             suirplus.Srp_Pkg.ProperCase((c.nombres || ' ' ||
                                         c.primer_apellido || ' ' ||
                                         c.segundo_apellido)) AS NombreDep,
             c.no_documento documentoDep
        FROM SRE_DEPENDIENTE_T d, SRE_CIUDADANOS_T c

       WHERE not exists (select *
                from sre_movimiento_t m, sre_det_movimiento_t dm
               where m.id_movimiento = dm.id_movimiento
                 and dm.id_tipo_novedad = 'SD'
                 and m.status = 'N'
                 and d.id_nss_dependiente = dm.id_nss_dependiente)

         and d.status = 'A'
         AND d.ID_NSS_DEPENDIENTE = c.ID_NSS
         AND d.ID_REGISTRO_PATRONAL = p_id_registro_patronal
         AND d.ID_NOMINA = p_id_Nomina
         AND d.ID_NSS = p_id_NSS;

    p_resultnumber := 0;
    p_io_cursor    := c_cursor;

  EXCEPTION

    WHEN e_InvalidNomina THEN
      p_ResultNumber := Seg_Retornar_Cadena_Error(155, NULL, NULL);
      RETURN;

    WHEN e_IvalidNSS THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(24, NULL, NULL);
      RETURN;

    WHEN e_InvalidRegistropatronal THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(3, NULL, NULL);
      RETURN;

    WHEN OTHERS THEN
      v_bderror      := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultnumber := Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
      RETURN;

  END get_Dependientes;

  --*************************************************************************************************
  -- Selecciona las Novedades Pendientes.
  --*************************************************************************************************
  PROCEDURE get_Novedades_Pendientes(p_id_registro_patronal SRE_EMPLEADORES_T.id_registro_patronal%TYPE,
                                     p_id_Usuario           SEG_USUARIO_T.id_usuario%TYPE,
                                     p_id_TipoMovimiento    SRE_MOVIMIENTO_T.id_tipo_movimiento%TYPE,
                                     p_id_TipoNovedad       SRE_DET_MOVIMIENTO_T.id_tipo_novedad%TYPE,
                                     p_categoria            SRE_TIPO_NOVEDAD_T.CATEGORIA%TYPE,
                                     p_io_cursor            OUT t_cursor,
                                     p_resultnumber         OUT VARCHAR2) IS
    c_cursor  t_cursor;
    v_bderror VARCHAR(1000);

  BEGIN

    IF NOT Existeregistropatronal(p_id_registro_patronal) THEN
      RAISE e_InvalidRegistropatronal;
    END IF;

    IF NOT Seg_Usuarios_Pkg.isExisteUsuario(p_ID_Usuario) THEN
      RAISE e_invaliduser;
    END IF;

    IF NOT Istipomovimientovalido(p_id_TipoMovimiento) THEN
      RAISE e_InvalidTipoMovimiento;
    END IF;

    /*   IF NOT Istiponovedadvalido(p_id_TipoNovedad) THEN
        RAISE e_InvalidTipoNovedad;
    END IF;*/

    IF NOT Seg_Usuarios_Pkg.isExisteRepresentante(p_ID_Usuario) THEN
      RAISE e_InvalidRepresentante;
    END IF;

    OPEN c_cursor For
    --modificado --
    --framirez--
    --2009-08-26--
      With NovedadesPendientes As
       (SELECT mov.id_movimiento,
               det.id_linea,
               mov.id_tipo_movimiento,
               mov.id_registro_patronal,
               det.id_tipo_novedad,
               det.id_nss,
               det.id_nss_dependiente,
               e.rnc_o_cedula,
               Srp_Pkg.ProperCase((ciu.nombres || ' ' || ciu.primer_apellido || ' ' ||
                                  ciu.segundo_apellido)) AS Nombre,
               ciu.no_documento,
               Srp_Pkg.ProperCase((ciuDep.nombres || ' ' ||
                                  ciuDep.primer_apellido || ' ' ||
                                  ciuDep.segundo_apellido)) AS NombreDep,
               ciuDep.no_documento no_documentoDep,
               TO_CHAR(det.fecha_inicio, 'DD/MM/YYYY') AS Fecha_Inicio,
               TO_CHAR(det.fecha_fin, 'DD/MM/YYYY') AS Fecha_Fin,
               det.agente_retencion_isr,
               det.aporte_voluntario,
               det.remuneracion_isr_otros,
               det.salario_isr,
               det.salario_ss,
               det.salario_infotep,
               n.tipo_novedad_des,
               det.ingresos_exentos_isr,
               det.saldo_favor_isr,
               det.periodo_aplicacion,
               det.otros_ingresos_isr,
               det.id_nomina,
               Srp_Pkg.ProperCase(nom.nomina_des) as nomina_des,
               det.ult_fecha_act,
               det.SFS_SECUENCIA

          FROM SRE_MOVIMIENTO_T     mov,
               SRE_DET_MOVIMIENTO_T det,
               SRE_CIUDADANOS_T     ciu,
               SRE_CIUDADANOS_T     ciuDep,
               SEG_USUARIO_T        usu,
               SRE_TIPO_NOVEDAD_T   n,
               SRE_EMPLEADORES_T    e,
               SRE_NOMINAS_T        nom
         WHERE mov.id_movimiento = det.id_movimiento
           AND det.agente_retencion_isr = e.id_registro_patronal(+)
           AND det.id_nss = ciu.id_nss
           AND det.ID_NSS_DEPENDIENTE = ciuDep.id_nss(+)
           AND mov.id_registro_patronal = nom.id_registro_patronal
           AND det.id_nomina = nom.id_nomina
           AND usu.id_usuario = p_ID_Usuario
           AND mov.id_registro_patronal = p_id_registro_patronal
           AND mov.status = 'N'
           AND mov.id_tipo_movimiento = p_id_TipoMovimiento
           AND det.id_tipo_novedad = p_id_TipoNovedad
           AND det.id_tipo_novedad = n.id_tipo_novedad
           AND n.categoria = p_categoria
           AND det.id_nomina IN (SELECT nom.id_nomina
                                   FROM SRE_ACCESO_NOMINA nom
                                  WHERE nom.id_nss = usu.id_nss
                                    and nom.status = 'A')

        Union All

        SELECT mov.id_movimiento,
               detenf.id_linea,
               mov.id_tipo_movimiento,
               mov.id_registro_patronal,
               '' As id_tipo_novedad,
               detenf.id_nss,
               0 As id_nss_dependiente,
               e.rnc_o_cedula,
               Srp_Pkg.ProperCase((ciu.nombres || ' ' || ciu.primer_apellido || ' ' ||
                                  ciu.segundo_apellido)) AS Nombre,
               ciu.no_documento,
               '' As NombreDep,
               '' As no_documentoDep,
               '' As Fecha_Inicio,
               '' As Fecha_Fin,
               0 As agente_retencion_isr,
               0 As aporte_voluntario,
               0 As remuneracion_isr_otros,
               0 As salario_isr,
               0 As salario_ss,
               0 As salario_infotep,
               n.tipo_novedad_des,
               0 As ingresos_exentos_isr,
               0 As saldo_favor_isr,
               0 As periodo_aplicacion,
               0 As otros_ingresos_isr,
               detenf.id_nomina,
               Srp_Pkg.ProperCase(nom.nomina_des) as nomina_des,
               detenf.ult_fecha_act,
               0 as SFS_SECUENCIA

          FROM SRE_MOVIMIENTO_T         mov,
               SRE_DET_MOVIMIENTO_ENF_T detenf,
               SRE_CIUDADANOS_T         ciu,
               SEG_USUARIO_T            usu,
               SRE_TIPO_NOVEDAD_T       n,
               SRE_EMPLEADORES_T        e,
               SRE_NOMINAS_T            nom
         WHERE mov.id_movimiento = detenf.id_movimiento
           AND detenf.id_nss = ciu.id_nss
           AND mov.id_registro_patronal = nom.id_registro_patronal
           AND detenf.id_nomina = nom.id_nomina
           AND detenf.id_nomina IN
               (SELECT nom.id_nomina
                  FROM SRE_ACCESO_NOMINA nom
                 WHERE nom.id_nss = usu.id_nss
                   and nom.status = 'A')
           AND mov.status = 'N'
           And n.id_tipo_novedad = 'LD' --Licencia por discapacidad--
           AND usu.id_usuario = p_ID_Usuario
           AND mov.id_registro_patronal = p_id_registro_patronal
           AND mov.id_tipo_movimiento = p_id_TipoMovimiento
           AND n.categoria = p_categoria)

      Select Id_Movimiento,
             Id_Linea,
             Id_Tipo_Movimiento,
             Id_Registro_Patronal,
             Id_Tipo_Novedad,
             Id_Nss,
             Id_Nss_Dependiente,
             Rnc_o_Cedula,
             Nombre,
             No_Documento,
             Nombredep,
             No_Documentodep,
             Fecha_Inicio,
             Fecha_Fin,
             Agente_Retencion_Isr,
             Aporte_Voluntario,
             Remuneracion_Isr_Otros,
             Salario_Isr,
             Salario_Ss,
             Salario_Infotep,
             Tipo_Novedad_Des,
             Ingresos_Exentos_Isr,
             Saldo_Favor_Isr,
             Periodo_Aplicacion,
             Otros_Ingresos_Isr,
             Id_Nomina,
             Nomina_Des,
             Ult_Fecha_Act,
             SFS_SECUENCIA
        From Novedadespendientes
       Order By Ult_Fecha_Act;

    p_resultnumber := 0;
    p_io_cursor    := c_cursor;

  EXCEPTION

    WHEN e_InvalidRegistropatronal THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(3, NULL, NULL);
      RETURN;

    WHEN e_InvalidUser THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(1, NULL, NULL);
      RETURN;

    WHEN e_InvalidTipoMovimiento THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(162, NULL, NULL);
      RETURN;

    WHEN e_InvalidTipoNovedad THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(164, NULL, NULL);
      RETURN;

    WHEN e_InvalidRepresentante THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(154, NULL, NULL);
      RETURN;

    WHEN OTHERS THEN
      v_bderror      := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultnumber := Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
      RETURN;

  END get_Novedades_Pendientes;

  procedure getNovedadesPendientesSFS(p_id_registro_patronal SRE_EMPLEADORES_T.id_registro_patronal%TYPE,
                                      p_io_cursor            OUT t_cursor,
                                      p_resultnumber         OUT VARCHAR2) is
    c_cursor t_cursor;
  BEGIN
    OPEN c_cursor FOR
      With NovedadesPendientesSFS As
       (Select m.id_movimiento,
               d.id_linea,
               d.id_nss,
               c.nombres || ' ' || c.primer_apellido || ' ' ||
               nvl(c.segundo_apellido, '') Nombres,
               n.tipo_novedad_des,
               case n.id_tipo_novedad
                 when 'RE' then
                  'Fecha Estimada de Parto: ' || d.fecha_fin || ', ' ||
                  'Fecha de Diagnóstico: ' || d.fecha_inicio
                 when 'LM' then
                  'Fecha de Licencia: ' || d.fecha_inicio
                 when 'PE' then
                  'Fecha de Perdida: ' || d.fecha_inicio
                 when 'NC' then
                  'Fecha de Nacimiento: ' || d.fecha_inicio || ', Lactante: ' ||
                  d.nombres || ' ' || d.primer_apellido || ' ' ||
                  d.segundo_apellido
                 when 'MM' then
                  'Fecha de Muerte: ' || d.fecha_inicio
                 when 'ML' then
                  'Fecha de Muerte Lactante: ' || d.fecha_inicio
               -- Cambios
                 when 'CR' then
                  'Fecha Estimada de Parto: ' || d.fecha_fin || ', ' ||
                  'Fecha de Diagnóstico: ' || d.fecha_inicio
                 when 'CI' then
                  'Fecha de Licencia: ' || d.fecha_inicio
                 when 'CP' then
                  'Fecha de Perdida: ' || d.fecha_inicio
                 when 'CN' then
                  'Fecha de Nacimiento: ' || d.fecha_inicio || ', Lactante: ' ||
                  l.nombres || ' ' || l.primer_apellido || ' ' ||
                  l.segundo_apellido
                 when 'CM' then
                  'Fecha de Muerte: ' || d.fecha_inicio
                 when 'CL' then
                  'Fecha de Muerte Lactante:' || d.fecha_inicio
               -- Bajas
                 when 'BR' then
                  'Fecha Estimada de Parto: ' || sm.fecha_estimada_parto || ', ' ||
                  'Fecha de Diagnóstico: ' || sm.fecha_diagnostico
                 when 'BI' then
                  'Fecha de Licencia: ' || sl.fecha_licencia
                 when 'BP' then
                  'Fecha de Perdida: ' || sm.fecha_perdida
                 when 'BN' then
                  'Fecha de Nacimiento: ' || l.fecha_nacimiento ||
                  ', Lactante: ' || l.nombres || ' ' || l.primer_apellido || ' ' ||
                  l.segundo_apellido
                 when 'BM' then
                  'Fecha de Muerte: ' || sm.fecha_defuncion_madre
                 when 'BL' then
                  'Fecha de Muerte: ' || l.fecha_registro_ml
               end InfoNovedad
          from sre_det_movimiento_t d,
               sre_movimiento_t     m,
               sre_ciudadanos_t     c,
               sre_tipo_novedad_t   n,
               sfs_maternidad_t     sm,
               sfs_licencia_t       sl,
               sfs_lactantes_t      l
         where m.id_movimiento = d.id_movimiento
           and m.id_registro_patronal = p_id_registro_patronal
           and d.id_nss = c.id_nss
           and n.id_tipo_novedad = d.id_tipo_novedad
           and n.id_tipo_novedad in ('RE',
                                     'CR',
                                     'BR',
                                     'LM',
                                     'CI',
                                     'BI',
                                     'NC',
                                     'CN',
                                     'BN',
                                     'PE',
                                     'CP',
                                     'BP',
                                     'MM',
                                     'CM',
                                     'BM')
           and m.status = 'N'
           and sm.id_nss(+) = d.id_nss
           and sm.secuencia(+) = d.sfs_secuencia
              --and sm.status(+) IN( 'AC', 'FA' )
           and sl.id_registro_patronal(+) = p_id_registro_patronal
           and sl.id_nss(+) = d.id_nss
           and sl.secuencia(+) = d.sfs_secuencia
           and sl.status(+) = 'AC'
           and l.id_nss_madre(+) = d.id_nss
           and l.secuencia(+) = d.sfs_secuencia
           and l.secuencia_lactante(+) = d.secuencia_lactante
           and l.status(+) = 'AC'
           and (d.id_nss, m.id_registro_patronal, sm.secuencia,
                l.secuencia_lactante) not in
               (select t.id_nss,
                       t.id_registro_patronal,
                       t.secuencia,
                       t.secuencia_lactante
                  from sfs_subs_ext_t t
                 where t.id_nss = d.id_nss
                   and t.id_registro_patronal = m.id_registro_patronal
                   and t.secuencia = sm.secuencia
                   and t.secuencia_lactante = l.secuencia_lactante)
        union all

        Select m.id_movimiento,
               d.id_linea,
               d.id_nss,
               c.nombres || ' ' || c.primer_apellido || ' ' ||
               nvl(c.segundo_apellido, '') Nombres,
               n.tipo_novedad_des,
               case n.id_tipo_novedad
                 when 'BL' then
                  'Fecha de Muerte: ' || l.fecha_defuncion || ', Lactante: ' ||
                  l.nombres || ' ' || l.primer_apellido || ' ' ||
                  nvl(l.segundo_apellido, '')
                 else
                  'Fecha de Muerte: ' || d.fecha_inicio || ', Lactante: ' ||
                  l.nombres || ' ' || l.primer_apellido || ' ' ||
                  nvl(l.segundo_apellido, '')
               end InfoNovedad
          from sre_det_movimiento_t d,
               sre_movimiento_t     m,
               sre_tipo_novedad_t   n,
               sre_ciudadanos_t     c,
               sfs_lactantes_t      l --, sfs_maternidad_t ma
         where m.id_movimiento = d.id_movimiento
           and m.id_registro_patronal = p_id_registro_patronal
           and d.id_nss = c.id_nss
           and d.id_nss = l.id_nss_madre
           and d.sfs_secuencia = l.secuencia
           and d.secuencia_lactante = l.secuencia_lactante
           and n.id_tipo_novedad = d.id_tipo_novedad
           and n.id_tipo_novedad in ('ML', 'CL', 'BL')
           and m.status = 'N'
           and (d.id_nss, m.id_registro_patronal, l.secuencia_lactante) not in
               (select t.id_nss, t.id_registro_patronal, t.secuencia_lactante
                  from sfs_subs_ext_t t
                 where t.id_nss = d.id_nss
                   and t.id_registro_patronal = m.id_registro_patronal
                   and t.secuencia_lactante = l.secuencia_lactante)

        Union All
        Select m.id_movimiento,
               de.id_linea,
               de.id_nss,
               c.nombres || ' ' || c.primer_apellido || ' ' ||
               nvl(c.segundo_apellido, '') Nombres,
               n.tipo_novedad_des,
               '' As InfoNovedad
          from sre_det_movimiento_enf_t de,
               sre_movimiento_t         m,
               sre_tipo_novedad_t       n,
               sre_ciudadanos_t         c
         where m.id_movimiento = de.id_movimiento
           And de.id_registro_patronal = m.id_registro_patronal
           and m.id_registro_patronal = p_id_registro_patronal
           and de.id_nss = c.id_nss
           and n.id_tipo_novedad = 'LD'
           and m.status = 'N'

        )
      Select id_movimiento,
             id_linea,
             id_nss,
             nombres,
             tipo_novedad_des,
             InfoNovedad
        From NovedadesPendientesSFS
       order by tipo_novedad_des, nombres;
    p_resultnumber := 0;
    p_io_cursor    := c_cursor;
  END;

  procedure getNovedadesPendientesSFS_Old(p_id_registro_patronal SRE_EMPLEADORES_T.id_registro_patronal%TYPE,
                                          p_io_cursor            OUT t_cursor,
                                          p_resultnumber         OUT VARCHAR2) is
    c_cursor t_cursor;
  BEGIN
    OPEN c_cursor FOR
      Select id_movimiento,
             id_linea,
             id_nss,
             nombres,
             tipo_novedad_des,
             InfoNovedad
        from (Select m.id_movimiento,
                     d.id_linea,
                     d.id_nss,
                     c.nombres || ' ' || c.primer_apellido || ' ' ||
                     nvl(c.segundo_apellido, '') Nombres,
                     n.tipo_novedad_des,
                     'Fecha Estimada de Parto: ' || d.fecha_fin || ', ' ||
                     'Fecha de Diagnóstico: ' || d.fecha_inicio InfoNovedad
                from sre_det_movimiento_t d,
                     sre_movimiento_t     m,
                     sre_ciudadanos_t     c,
                     sre_tipo_novedad_t   n
               where m.id_movimiento = d.id_movimiento
                 and m.id_registro_patronal = p_id_registro_patronal
                 and d.id_nss = c.id_nss
                 and n.id_tipo_novedad = d.id_tipo_novedad
                 and n.id_tipo_novedad = 'RE'
                 and m.status = 'N'

              union all

              Select m.id_movimiento,
                     d.id_linea,
                     d.id_nss,
                     c.nombres || ' ' || c.primer_apellido || ' ' ||
                     nvl(c.segundo_apellido, '') Nombres,
                     n.tipo_novedad_des,
                     'Fecha de Licencia: ' || d.fecha_inicio InfoNovedad
                from sre_det_movimiento_t d,
                     sre_movimiento_t     m,
                     sre_ciudadanos_t     c,
                     sre_tipo_novedad_t   n
               where m.id_movimiento = d.id_movimiento
                 and m.id_registro_patronal = p_id_registro_patronal
                 and d.id_nss = c.id_nss
                 and n.id_tipo_novedad = d.id_tipo_novedad
                 and n.id_tipo_novedad = 'LM'
                 and m.status = 'N'

              union all

              Select m.id_movimiento,
                     d.id_linea,
                     d.id_nss,
                     c.nombres || ' ' || c.primer_apellido || ' ' ||
                     nvl(c.segundo_apellido, '') Nombres,
                     n.tipo_novedad_des,
                     'Fecha de Perdida: ' || d.fecha_inicio InfoNovedad
                from sre_det_movimiento_t d,
                     sre_movimiento_t     m,
                     sre_ciudadanos_t     c,
                     sre_tipo_novedad_t   n
               where m.id_movimiento = d.id_movimiento
                 and m.id_registro_patronal = p_id_registro_patronal
                 and d.id_nss = c.id_nss
                 and n.id_tipo_novedad = d.id_tipo_novedad
                 and n.id_tipo_novedad = 'PE'
                 and m.status = 'N'

              union all

              Select m.id_movimiento,
                     d.id_linea,
                     d.id_nss,
                     c.nombres || ' ' || c.primer_apellido || ' ' ||
                     nvl(c.segundo_apellido, '') Nombres,
                     n.tipo_novedad_des,
                     'Fecha de Nacimiento: ' || d.fecha_inicio ||
                     ', Lactante: ' || d.nombres || ' ' || d.primer_apellido || ' ' ||
                     d.segundo_apellido InfoNovedad
                from sre_det_movimiento_t d,
                     sre_movimiento_t     m,
                     sre_ciudadanos_t     c,
                     sre_tipo_novedad_t   n
               where m.id_movimiento = d.id_movimiento
                 and m.id_registro_patronal = p_id_registro_patronal
                 and d.id_nss = c.id_nss
                 and n.id_tipo_novedad = d.id_tipo_novedad
                 and n.id_tipo_novedad = 'NC'
                 and m.status = 'N'

              union all

              Select m.id_movimiento,
                     d.id_linea,
                     d.id_nss,
                     c.nombres || ' ' || c.primer_apellido || ' ' ||
                     nvl(c.segundo_apellido, '') Nombres,
                     n.tipo_novedad_des,
                     'Fecha de Muerte: ' || d.fecha_inicio InfoNovedad
                from sre_det_movimiento_t d,
                     sre_movimiento_t     m,
                     sre_ciudadanos_t     c,
                     sre_tipo_novedad_t   n
               where m.id_movimiento = d.id_movimiento
                 and m.id_registro_patronal = p_id_registro_patronal
                 and d.id_nss = c.id_nss
                 and n.id_tipo_novedad = d.id_tipo_novedad
                 and n.id_tipo_novedad = 'MM'
                 and m.status = 'N'

              union all

              Select m.id_movimiento,
                     d.id_linea,
                     d.id_nss,
                     c.nombres || ' ' || c.primer_apellido || ' ' ||
                     nvl(c.segundo_apellido, '') Nombres,
                     n.tipo_novedad_des,
                     'Fecha de Muerte: ' || d.fecha_inicio || ', Lactante: ' ||
                     l.nombres || ' ' || l.primer_apellido || ' ' ||
                     nvl(l.segundo_apellido, '') InfoNovedad
                from sre_det_movimiento_t d,
                     sre_movimiento_t     m,
                     sre_tipo_novedad_t   n,
                     sre_ciudadanos_t     c,
                     sfs_lactantes_t      l --, sfs_maternidad_t ma
               where m.id_movimiento = d.id_movimiento
                 and m.id_registro_patronal = p_id_registro_patronal
                 and d.id_nss = c.id_nss
                 and d.id_nss = l.id_nss_madre
                 and d.secuencia_lactante = l.secuencia_lactante
                 and n.id_tipo_novedad = d.id_tipo_novedad
                 and n.id_tipo_novedad = 'ML'
                 and m.status = 'N')
       order by tipo_novedad_des, nombres;

    p_resultnumber := 0;
    p_io_cursor    := c_cursor;
  END;
  --******************************************************************************************************

  -- *****************************************************************************************************
  -- PROCEDURE:   Novedades_Ingreso_Dependientes_Crear
  -- Descripcion: Inserta en la tabla SRE_DET_MOVIMIENTO_T, la informacion concermiente a una
  --              Novedad Nueva de Ingreso de Dependiente Adicional.

  --  Parametros IN:
  --             p_id_RegistroPatronal
  --             p_id_Nomina
  --             p_id_NSS
  --             p_ID_Usuario

  --  Parametros OUT:
  --             p_ResultNumber
  --
  -- Novedades_Ingreso_Dependientes_Crear
  PROCEDURE Novedades_Ingreso_Dep_Crear(p_id_RegistroPatronal SRE_EMPLEADORES_T.id_registro_patronal%TYPE,
                                        p_id_Nomina           SRE_NOMINAS_T.id_nomina%TYPE,
                                        p_id_NSS              SRE_TRABAJADORES_T.id_nss%TYPE,
                                        p_id_NSS_Dependiente  SRE_TRABAJADORES_T.id_nss%TYPE,
                                        p_ID_Usuario          SRE_MOVIMIENTO_T.ult_usuario_act%TYPE,
                                        p_IPAddress           SRE_MOVIMIENTO_T.Ip_Address%TYPE,
                                        p_ResultNumber        OUT VARCHAR2) IS
    v_conteo          integer;
    v_bderror         VARCHAR(1000);
    v_IDMovimiento    SRE_MOVIMIENTO_T.id_movimiento%TYPE;
    v_IDLinea         SRE_DET_MOVIMIENTO_T.id_linea%TYPE;
    v_periodo_vigente VARCHAR(6);
    v_PeriodoSigue    VARCHAR(6);
    v_facturaPaga     BOOLEAN;
    v_inhabilidad     VARCHAR2(1);
  BEGIN

    v_periodo_vigente := Parm.periodo_vigente;

    --Validacion de los parametros nulos.
    IF (p_ID_RegistroPatronal IS NULL) OR (p_ID_Nomina IS NULL) OR
       (p_ID_NSS IS NULL) OR (p_ID_Usuario IS NULL) OR
       (p_id_NSS_Dependiente IS NULL) THEN
      RAISE e_ParametrosNulos;
    END IF;

    --Validacion del registro patronal
    IF NOT Sre_Empleadores_Pkg.Existeregistropatronal(p_id_registroPatronal) THEN
      RAISE e_InvalidRegistropatronal;
    END IF;

    --Validacion de la nomina
    IF NOT
        Sre_Nominas_Pkg.isNominaValida(p_id_RegistroPatronal, p_id_nomina) THEN
      RAISE e_InvalidNomina;
    END IF;

    --Validacion del NSS
    IF NOT Srp_Pkg.Existenss(p_id_nss) THEN
      RAISE e_IvalidNSS;
    END IF;

    --Validacion del NSS del Dependiente
    IF NOT Srp_Pkg.Existenss(p_id_NSS_Dependiente) THEN
      RAISE e_IvalidNSS;
    END IF;

    --Validacion del usuario
    IF NOT Seg_Usuarios_Pkg.isExisteUsuario(p_ID_Usuario) THEN
      RAISE e_invaliduser;
    END IF;

    -- Validacion para el titular, si no esta activo como Trabajador.
    IF NOT isActivoTrabajadores(p_id_NSS, p_id_RegistroPatronal, p_id_nomina) THEN
      RAISE e_InvalidTrabajador;
    END IF;

    -- Validacion para el dependiente, si esta activo como Trabajador.
    IF isActivoTrabajadores(p_id_NSS_Dependiente) THEN
      RAISE e_InvalidDepTrabajador;
    END IF;

    -- Validacion de Movimiento sin procesar. (8) **********************************
    IF isExisteMovimiento(p_id_nss,
                          p_id_NSS_Dependiente,
                          p_ID_RegistroPatronal,
                          'ID',
                          p_id_nomina) THEN
      RAISE e_InvalidMovPendiente;
    ELSE
      v_IDMovimiento := get_id_movimiento(p_ID_RegistroPatronal,
                                          p_ID_Usuario,
                                          'NV',
                                          p_ID_Usuario,
                                          p_IPAddress);
      v_IDLinea      := Get_Id_Linea(v_IDMovimiento);
    END IF;

    -- Si el individuo tiene una factura paga del periodo para esa misma Nomina TSS.
    IF isFacturaDelPeriodoPaga(p_id_RegistroPatronal,
                               p_id_nomina,
                               v_periodo_vigente) AND
       isLiquidacionDelPeriodoPaga(p_id_RegistroPatronal,
                                   p_id_nomina,
                                   v_periodo_vigente) THEN
      v_facturaPaga     := TRUE;
      v_PeriodoSigue    := getPeriodoSiguiente(v_periodo_vigente,
                                               v_facturaPaga);
      v_periodo_vigente := v_PeriodoSigue;
    END IF;

    -- Si la factura esta Autorizada y No Paga TSS.
    IF isFacturaAutorizadaNoPaga(p_id_RegistroPatronal,
                                 v_periodo_vigente,
                                 p_id_nomina) /*or*/
       AND isLiquidacionAutorizadaNoPaga(p_id_RegistroPatronal,
                                         v_periodo_vigente,
                                         p_id_nomina) THEN
      RAISE e_InvalidNovedad;
    END IF;

    --validar si existe para otro empleador/nomina/trabajador
    select count(*)
      into v_conteo
      from suirplus.sre_dependiente_t d
     where d.id_nss_dependiente = p_id_NSS_Dependiente
       and d.status = 'A'
       and (d.id_registro_patronal <> p_id_RegistroPatronal or
           d.id_nomina <> p_id_Nomina or d.id_nss <> p_id_NSS);
    if (v_conteo > 0) then
      raise e_InvalidDependiente;
    end if;

    --validar que solo los titulares y/o conyuges puedan agregar un dependiente adiconal
--    if not sre_novedades_pkg.isTitular_Conyuge(p_id_NSS) then
--      raise e_InvalidTitular;
--    end if;

    --validar  que el dependiente adicional a registrar no exista como titular AC en la vista diaria
--    if sre_novedades_pkg.isDependienteTitularAC(p_id_NSS_Dependiente) then
--      raise e_InvalidDepTitularAC;
--    end if;

    --validar que un dependiente adicional existe activo dentro del mismo núcleo familiar de la persona que lo va a pagar
    if NOT sre_novedades_pkg.IsDepNucleoValido(p_id_NSS ,p_id_NSS_Dependiente) then
      raise e_InvalidDepNucleo;
    end if;
    --
    /* if not sre_novedades_pkg.isDependienteDelTitular(p_id_NSS ,p_id_NSS_Dependiente) then
        raise e_DependienteTitular;
    end if;*/

    INSERT INTO SRE_DET_MOVIMIENTO_T
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
      (v_IDMovimiento,
       v_IDLinea,
       p_id_NSS,
       p_id_NSS_Dependiente,
       'ID',
       p_id_Nomina,
       v_periodo_vigente,
       SYSDATE,
       SYSDATE,
       p_ID_Usuario);

    p_ResultNumber := 0;
    COMMIT;

  EXCEPTION

    WHEN e_InvalidRegistropatronal THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(3, NULL, NULL);
      RETURN;

    WHEN e_InvalidAgenteIgual THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(211, NULL, NULL);
      RETURN;

    WHEN e_InvalidAgenteDif THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(212, NULL, NULL);
      RETURN;

    WHEN e_InvalidNomina THEN
      p_ResultNumber := Seg_Retornar_Cadena_Error(155, NULL, NULL);
      RETURN;

    WHEN e_IvalidNSS THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(24, NULL, NULL);
      RETURN;

    WHEN e_InvalidAgenteRetencion THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(161, NULL, NULL);
      RETURN;

    WHEN e_InvalidUser THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(1, NULL, NULL);
      RETURN;

    WHEN e_InvalidSalarioSS THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(156, NULL, NULL);
      RETURN;

    WHEN e_InvalidMovPendiente THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(169, NULL, NULL);
      RETURN;

    WHEN e_InvalidTrabajador THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(170, NULL, NULL);
      RETURN;

    WHEN e_InvalidDepTrabajador THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(120, NULL, NULL);
      RETURN;

    WHEN e_InvalidRemunOtroEmp THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(160, NULL, NULL);
      RETURN;

    WHEN e_IvalidAporteVoluntario THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(157, NULL, NULL);
      RETURN;

    WHEN e_InvalidRemuneracionIsr THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(513, NULL, NULL);
      RETURN;

    WHEN e_InvalidNovedad THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(166, NULL, NULL);
      RETURN;

    WHEN e_ParametrosNulos THEN
      p_ResultNumber := Seg_Retornar_Cadena_Error(8, NULL, NULL);
      RETURN;

    WHEN e_InvalidInhabilidad THEN
      p_ResultNumber := Seg_Retornar_Cadena_Error(651, NULL, NULL);
      RETURN;

    WHEN e_InvalidDependiente THEN
      p_ResultNumber := Seg_Retornar_Cadena_Error(191, NULL, NULL);
      RETURN;

/*    WHEN e_DependienteTitular THEN
      p_ResultNumber := Seg_Retornar_Cadena_Error(195, NULL, NULL);
      RETURN;
*/
/*    WHEN e_InvalidDepTitularAC THEN
      p_ResultNumber := Seg_Retornar_Cadena_Error(198, NULL, NULL);
      RETURN;
*/
/*    WHEN e_InvalidTitular THEN
      p_ResultNumber := Seg_Retornar_Cadena_Error(199, NULL, NULL);
      RETURN;
*/
    WHEN e_InvalidDepNucleo THEN
      p_ResultNumber := Seg_Retornar_Cadena_Error(195, NULL, NULL);
      RETURN;

    WHEN OTHERS THEN
      v_bderror      := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultnumber := Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
      RETURN;

  END Novedades_Ingreso_Dep_Crear;
  -- *****************************************************************************************************

  -- *****************************************************************************************************
  -- PROCEDURE:   Novedades_Ingreso_Dependientes_Crear
  -- Descripcion: Inserta en la tabla SRE_DET_MOVIMIENTO_T, la informacion concermiente a una
  --              Novedad Nueva de Ingreso de Dependiente Adicional.

  --  Parametros IN:
  --             p_id_RegistroPatronal
  --             p_id_Nomina
  --             p_id_NSS
  --             p_ID_Usuario

  --  Parametros OUT:
  --             p_ResultNumber
  --
  -- Novedades_Baja_Dependientes_Crear
  PROCEDURE Novedades_Baja_Dep_Crear(p_id_RegistroPatronal SRE_EMPLEADORES_T.id_registro_patronal%TYPE,
                                     p_id_Nomina           SRE_NOMINAS_T.id_nomina%TYPE,
                                     p_id_NSS              SRE_TRABAJADORES_T.id_nss%TYPE,
                                     p_id_NSS_Dependiente  SRE_TRABAJADORES_T.id_nss%TYPE,
                                     p_ID_Usuario          SRE_MOVIMIENTO_T.ult_usuario_act%TYPE,
                                     p_IPAddress           SRE_MOVIMIENTO_T.Ip_Address%TYPE,
                                     p_ResultNumber        OUT VARCHAR2) IS

    v_bderror         VARCHAR(1000);
    v_IDMovimiento    SRE_MOVIMIENTO_T.id_movimiento%TYPE;
    v_IDLinea         SRE_DET_MOVIMIENTO_T.id_linea%TYPE;
    v_periodo_vigente VARCHAR(6);
    v_PeriodoSigue    VARCHAR(6);
    v_facturaPaga     BOOLEAN;
    v_inhabilidad     VARCHAR2(1);

  BEGIN

    v_periodo_vigente := Parm.periodo_vigente;

    --Validacion de los parametros nulos.
    IF (p_ID_RegistroPatronal IS NULL) OR (p_ID_Nomina IS NULL) OR
       (p_ID_NSS IS NULL) OR (p_ID_Usuario IS NULL) OR
       (p_id_NSS_Dependiente IS NULL) THEN
      RAISE e_ParametrosNulos;
    END IF;

    --Validando el dependiente
    IF NOT Sre_Novedades_Pkg.isDependienteValido(p_id_RegistroPatronal,
                                                 p_id_Nomina,
                                                 p_id_NSS,
                                                 p_id_NSS_Dependiente) THEN
      RAISE e_InvalidDependiente;
    END IF;

    --Validacion del registro patronal
    IF NOT Sre_Empleadores_Pkg.Existeregistropatronal(p_id_registroPatronal) THEN
      RAISE e_InvalidRegistropatronal;
    END IF;

    --Validacion de la nomina
    IF NOT
        Sre_Nominas_Pkg.isNominaValida(p_id_RegistroPatronal, p_id_nomina) THEN
      RAISE e_InvalidNomina;
    END IF;

    --Validacion del NSS
    IF NOT Srp_Pkg.Existenss(p_id_nss) THEN
      RAISE e_IvalidNSS;
    END IF;

    --Validacion del NSS del Dependiente
    IF NOT Srp_Pkg.Existenss(p_id_NSS_Dependiente) THEN
      RAISE e_IvalidNSS;
    END IF;

    --Validacion del usuario
    IF NOT Seg_Usuarios_Pkg.isExisteUsuario(p_ID_Usuario) THEN
      RAISE e_invaliduser;
    END IF;

    -- Validacion de Trabajador Activo.(8)
    IF NOT
        isActivoTrabajadores(p_id_NSS, p_id_RegistroPatronal, p_id_nomina) THEN
      RAISE e_InvalidTrabajador;
    END IF;

    -- Validacion de Movimiento sin procesar. (8) **********************************
    IF isExisteMovimiento(p_id_nss,
                          p_id_NSS_Dependiente,
                          p_ID_RegistroPatronal,
                          'SD',
                          p_id_nomina) THEN
      RAISE e_InvalidMovPendiente;
    ELSE
      v_IDMovimiento := get_id_movimiento(p_ID_RegistroPatronal,
                                          p_ID_Usuario,
                                          'NV',
                                          p_ID_Usuario,
                                          p_IPAddress);
      v_IDLinea      := Get_Id_Linea(v_IDMovimiento);
    END IF;

    -- Si el individuo tiene una factura paga del periodo para esa misma Nomina TSS.
    IF isFacturaDelPeriodoPaga(p_id_RegistroPatronal,
                               p_id_nomina,
                               v_periodo_vigente) AND
       isLiquidacionDelPeriodoPaga(p_id_RegistroPatronal,
                                   p_id_nomina,
                                   v_periodo_vigente) THEN
      v_facturaPaga     := TRUE;
      v_PeriodoSigue    := getPeriodoSiguiente(v_periodo_vigente,
                                               v_facturaPaga);
      v_periodo_vigente := v_PeriodoSigue;
    END IF;

    -- Si la factura esta Autorizada y No Paga TSS.
    IF isFacturaAutorizadaNoPaga(p_id_RegistroPatronal,
                                 v_periodo_vigente,
                                 p_id_nomina) /*or*/
       AND isLiquidacionAutorizadaNoPaga(p_id_RegistroPatronal,
                                         v_periodo_vigente,
                                         p_id_nomina) THEN
      RAISE e_InvalidNovedad;
    END IF;

    INSERT INTO SRE_DET_MOVIMIENTO_T
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
      (v_IDMovimiento,
       v_IDLinea,
       p_id_NSS,
       p_id_NSS_Dependiente,
       'SD',
       p_id_Nomina,
       v_periodo_vigente,
       SYSDATE,
       SYSDATE,
       p_ID_Usuario);

    p_ResultNumber := 0;
    COMMIT;

  EXCEPTION

    WHEN e_InvalidRegistropatronal THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(3, NULL, NULL);
      RETURN;

    WHEN e_InvalidDependiente THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(175, NULL, NULL);
      RETURN;

    WHEN e_InvalidAgenteIgual THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(211, NULL, NULL);
      RETURN;

    WHEN e_InvalidAgenteDif THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(212, NULL, NULL);
      RETURN;

    WHEN e_InvalidNomina THEN
      p_ResultNumber := Seg_Retornar_Cadena_Error(155, NULL, NULL);
      RETURN;

    WHEN e_IvalidNSS THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(24, NULL, NULL);
      RETURN;

    WHEN e_InvalidAgenteRetencion THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(161, NULL, NULL);
      RETURN;

    WHEN e_InvalidUser THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(1, NULL, NULL);
      RETURN;

    WHEN e_InvalidSalarioSS THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(156, NULL, NULL);
      RETURN;

    WHEN e_InvalidMovPendiente THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(169, NULL, NULL);
      RETURN;

    WHEN e_InvalidTrabajador THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(167, NULL, NULL);
      RETURN;

    WHEN e_InvalidRemunOtroEmp THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(160, NULL, NULL);
      RETURN;

    WHEN e_IvalidAporteVoluntario THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(157, NULL, NULL);
      RETURN;

    WHEN e_InvalidRemuneracionIsr THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(513, NULL, NULL);
      RETURN;

    WHEN e_InvalidNovedad THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(166, NULL, NULL);
      RETURN;

    WHEN e_ParametrosNulos THEN
      p_ResultNumber := Seg_Retornar_Cadena_Error(8, NULL, NULL);
      RETURN;

    WHEN e_InvalidInhabilidad THEN
      p_ResultNumber := Seg_Retornar_Cadena_Error(651, NULL, NULL);
      RETURN;

    WHEN OTHERS THEN
      v_bderror      := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultnumber := Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
      RETURN;

  END Novedades_Baja_Dep_Crear;

  -- *****************************************************************************************************
  -- PROCEDURE:   Novedades_Ingreso_Crear
  -- Descripcion: Inserta en la tabla SRE_DET_MOVIMIENTO_T, la informacion concermiente a una
  --              Novedad Nueva de Ingreso.
  --
  --  Parametros IN:
  --             p_id_RegistroPatronal
  --             p_id_Nomina
  --             p_id_NSS
  --             p_SalarioSS
  --             p_AporteVoluntario
  --             p_SalarioIsr
  --             p_AgenteRetencionIsr
  --             p_OtrasRemunIsr
  --             p_RemunOtroEmp
  --             p_FechaIngreso
  --             p_ID_Usuario
  --  Parametros OUT:
  --             p_ResultNumber
  --
  -- Novedades_Ingreso_Crear
  -- -----------------------------------------------------------------------------------------------------
  PROCEDURE Novedades_Ingreso_Crear(p_id_RegistroPatronal SRE_EMPLEADORES_T.id_registro_patronal%TYPE,
                                    p_id_Nomina           SRE_NOMINAS_T.id_nomina%TYPE,
                                    p_id_NSS              SRE_TRABAJADORES_T.id_nss%TYPE,
                                    p_SalarioSS           SRE_DET_MOVIMIENTO_T.salario_ss%TYPE,
                                    p_AporteVoluntario    SRE_DET_MOVIMIENTO_T.aporte_voluntario%TYPE,
                                    p_SalarioIsr          SRE_DET_MOVIMIENTO_T.salario_isr%TYPE,
                                    p_SalarioINF          SRE_DET_MOVIMIENTO_T.Salario_Infotep%TYPE,
                                    p_AgenteRetencionIsr  SRE_EMPLEADORES_T.Rnc_o_Cedula%TYPE,
                                    p_OtrasRemunIsr       SRE_DET_MOVIMIENTO_T.otros_ingresos_isr%TYPE,
                                    p_RemunOtroEmp        SRE_DET_MOVIMIENTO_T.remuneracion_isr_otros%TYPE,
                                    p_FechaIngreso        SRE_DET_MOVIMIENTO_T.fecha_inicio%TYPE,
                                    p_IngresosExentos     SRE_DET_MOVIMIENTO_T.Ingresos_Exentos_Isr%TYPE,
                                    p_SaldoFavor          SRE_DET_MOVIMIENTO_T.Saldo_Favor_Isr%TYPE,
                                    p_ID_Usuario          SRE_MOVIMIENTO_T.ult_usuario_act%TYPE,
                                    p_tipo_ingreso        number,
                                    p_IPAddress           SRE_MOVIMIENTO_T.Ip_Address%TYPE,
                                    p_ResultNumber        OUT VARCHAR2)

   IS

    v_bderror           VARCHAR(1000);
    v_IDMovimiento      SRE_MOVIMIENTO_T.id_movimiento%TYPE;
    v_IDLinea           SRE_DET_MOVIMIENTO_T.id_linea%TYPE;
    v_periodo_vigente   VARCHAR(6);
    v_RegPatAgRetencion SRE_DET_MOVIMIENTO_T.AGENTE_RETENCION_SS%TYPE;
    -- v_mensaje           varchar(1000);
    v_PeriodoSigue VARCHAR(6);
    v_facturaPaga  BOOLEAN;
    v_SalarioIsr   VARCHAR(100);
    v_inhabilidad  VARCHAR2(1);

    --cursor c_existeinhabilidad is select tp.tipo_causa into v_inhabilidad from sre_ciudadanos_t tp where tp.id_nss = p_id_NSS;
  BEGIN

    v_SalarioISR := p_SalarioIsr;

    v_periodo_vigente := Parm.periodo_vigente;
    --v_RegPatAgRetencion := SRE_EMPLEADORES_PKG.get_registropatronal(p_AgenteRetencionIsr);

    /* fetch c_existeinhabilidad into v_inhabilidad;
    if (v_inhabilidad is not null) then
         if  v_inhabilidad = 'C' then
            close c_existeinhabilidad;
          raise e_InvalidInhabilidad;
        End if;
      elsif  v_inhabilidad is null then
      close c_existeinhabilidad;
    end if;     */

    --Validacion de los parametros nulos.
    IF (p_ID_RegistroPatronal IS NULL) OR (p_ID_Nomina IS NULL) OR
       (p_ID_NSS IS NULL) OR (p_SalarioSS IS NULL) OR
       (p_ID_Usuario IS NULL) OR (p_FechaIngreso IS NULL) THEN
      RAISE e_ParametrosNulos;
    END IF;

    --Validacion del registro patronal
    IF NOT Sre_Empleadores_Pkg.Existeregistropatronal(p_id_registroPatronal) THEN
      RAISE e_InvalidRegistropatronal;
    END IF;

    --Validacion de la nomina
    IF NOT
        Sre_Nominas_Pkg.isNominaValida(p_id_RegistroPatronal, p_id_nomina) THEN
      RAISE e_InvalidNomina;
    END IF;

    --Validacion del NSS
    IF NOT Srp_Pkg.Existenss(p_id_nss) THEN
      RAISE e_IvalidNSS;
    END IF;

    --Validacion del agente de retencion.(7-A)
    IF (p_AgenteRetencionIsr IS NOT NULL) THEN
      v_RegPatAgRetencion := Sre_Empleadores_Pkg.get_registropatronal(p_AgenteRetencionIsr);

      if v_RegPatAgRetencion = '-1' then
        RAISE e_InvalidAgenteRetencion;
      end if;

      /*  if NOT Sre_Empleadores_Pkg.isRncOCedulaValida(v_RegPatAgRetencion) and (p_RemunOtroEmp <= 0) THEN
          RAISE e_InvalidAgenteRetencion;
      end if;*/
    ELSIF (p_AgenteRetencionIsr IS NULL) THEN
      v_RegPatAgRetencion := NULL;
    END IF;

    -- Fue puesta ultimamente.
    IF (v_RegPatAgRetencion = p_id_RegistroPatronal) AND
       (p_RemunOtroEmp <= 0) THEN
      RAISE e_InvalidAgenteIgual;
    END IF;

    -- Fue puesta ultimamente.
    IF (v_RegPatAgRetencion <> p_id_RegistroPatronal) AND
       (p_RemunOtroEmp <> 0) THEN
      RAISE e_InvalidAgenteDif;
    END IF;

    --Validacion del usuario
    IF NOT Seg_Usuarios_Pkg.isExisteUsuario(p_ID_Usuario) THEN
      RAISE e_invaliduser;
    END IF;

    /*if (p_SalarioSS <= 0) and (p_SalarioIsr <= 0) then
      RAISE e_InvalidSalarioSS;
    end if;*/

    /* correction by RJ 25/04/2011
    IF (p_SalarioSS <= 0) and (p_SalarioIsr <= 0) THEN
       --Validacion del salario de la seguridad social, solo en caso de que sea extrabjero puede ser cero.
      IF NOT isAgenteExtranjero(p_id_NSS) AND (p_SalarioSS <= 0) THEN
          RAISE e_InvalidSalarioSS;
      END IF;


      IF (p_SalarioSS <= 0) THEN
          RAISE e_InvalidSalarioSS;
      END IF;
    END IF;
    */

    --Verificacion del Salario SS contra el rango permitido.
    IF isSalarioSSValido(p_SalarioSS) = False then
      RAISE e_InvalidSalarioSS;
    end if;

    --Validacion del salario de la seguridad ISR (5).
/*    IF (p_SalarioIsr <= 0) THEN
      v_SalarioIsr := p_SalarioSS;
    END IF;*/

    -- Validacion de Trabajador Activo.(8)
    IF isActivoTrabajadores(p_id_NSS, p_id_RegistroPatronal, p_id_nomina) THEN
      RAISE e_InvalidTrabajador;
    END IF;

    -- Validacion de Movimiento sin procesar. (8) **********************************
    IF isExisteMovimiento(p_id_nss,
                          p_ID_RegistroPatronal,
                          'IN',
                          p_id_nomina) THEN
      RAISE e_InvalidMovPendiente;
    ELSE
      v_IDMovimiento := get_id_movimiento(p_ID_RegistroPatronal,
                                          p_ID_Usuario,
                                          'NV',
                                          p_ID_Usuario,
                                          p_IPAddress);
      v_IDLinea      := Get_Id_Linea(v_IDMovimiento);
    END IF;

    -- Validacion Remuneracion Otros Empleados, en el caso de que el agente sea el mismo empleador. (7-B)
    IF isAgenteEsEmpleador(v_RegPatAgRetencion,
                           p_id_RegistroPatronal,
                           P_RemunOtroEmp) THEN
      RAISE e_InvalidRemunOtroEmp;
    END IF;

    -- Validacion del Campo Aporte Voluntario, Rango especificado.
    IF isAporteVoluntario(p_AporteVoluntario) THEN
      RAISE e_IvalidAporteVoluntario;
    END IF;

    /*   -- Si el individuo tiene una factura paga del periodo para esa misma Nomina TSS.
    IF isFacturaDelPeriodoPaga(p_id_RegistroPatronal, p_id_nomina, v_periodo_vigente) THEN
        v_facturaPaga     := True;
        v_PeriodoSigue    := getPeriodoSiguiente(v_periodo_vigente,
                                                 v_facturaPaga);
        v_periodo_vigente := v_PeriodoSigue;
    END IF;

    -- Si el individuo tiene una factura paga del periodo para esa misma Nomina DGI.
    IF isLiquidacionDelPeriodoPaga(p_id_RegistroPatronal, p_id_nomina,
                                   v_periodo_vigente) THEN
        v_facturaPaga     := True;
        v_PeriodoSigue    := getPeriodoSiguiente(v_periodo_vigente,
                                                 v_facturaPaga);
        v_periodo_vigente := v_PeriodoSigue;
    END IF;*/

    -- Si el individuo tiene una factura paga del periodo para esa misma Nomina TSS.
    IF isFacturaDelPeriodoPaga(p_id_RegistroPatronal,
                               p_id_nomina,
                               v_periodo_vigente) AND
       isLiquidacionDelPeriodoPaga(p_id_RegistroPatronal,
                                   p_id_nomina,
                                   v_periodo_vigente) THEN
      v_facturaPaga     := TRUE;
      v_PeriodoSigue    := getPeriodoSiguiente(v_periodo_vigente,
                                               v_facturaPaga);
      v_periodo_vigente := v_PeriodoSigue;
    END IF;

    -- Si la factura esta Autorizada y No Paga TSS.
    IF isFacturaAutorizadaNoPaga(p_id_RegistroPatronal,
                                 v_periodo_vigente,
                                 p_id_nomina) /*or*/
       AND isLiquidacionAutorizadaNoPaga(p_id_RegistroPatronal,
                                         v_periodo_vigente,
                                         p_id_nomina) THEN
      RAISE e_InvalidNovedad;
    END IF;

    -- Si la factura esta Autorizada y No Paga DGI.
    /*  IF isLiquidacionAutorizadaNoPaga(p_id_RegistroPatronal,
                                     v_periodo_vigente, p_id_nomina) THEN
        RAISE e_InvalidNovedad;
    END IF;*/

    INSERT INTO SRE_DET_MOVIMIENTO_T
      (id_movimiento,
       id_linea,
       agente_retencion_isr,
       id_nss,
       id_tipo_novedad,
       id_nomina,
       periodo_aplicacion,
       fecha_inicio,
       aporte_voluntario,
       otros_ingresos_isr,
       remuneracion_isr_otros,
       salario_isr,
       SALARIO_INFOTEP,
       SALARIO_SS,
       Ingresos_Exentos_Isr,
       Saldo_Favor_Isr,
       ult_fecha_act,
       ult_usuario_act,
       cod_ingreso --se usa para almacenar el tipo de ingreso para esta novedad
       )
    VALUES
      (v_IDMovimiento,
       v_IDLinea,
       v_RegPatAgRetencion,
       p_id_NSS,
       'IN',
       p_id_Nomina,
       v_periodo_vigente,
       p_FechaIngreso,
       p_AporteVoluntario,
       p_OtrasRemunIsr,
       p_RemunOtroEmp,
       p_SalarioIsr,
       p_SalarioINF,
       p_salarioss,
       p_IngresosExentos,
       p_SaldoFavor,
       SYSDATE,
       p_ID_Usuario,
       p_tipo_ingreso);

    p_ResultNumber := 0;
    COMMIT;

  EXCEPTION

    WHEN e_InvalidRegistropatronal THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(3, NULL, NULL);
      RETURN;

    WHEN e_InvalidAgenteIgual THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(211, NULL, NULL);
      RETURN;

    WHEN e_InvalidAgenteDif THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(212, NULL, NULL);
      RETURN;

    WHEN e_InvalidNomina THEN
      p_ResultNumber := Seg_Retornar_Cadena_Error(155, NULL, NULL);
      RETURN;

    WHEN e_IvalidNSS THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(24, NULL, NULL);
      RETURN;

    WHEN e_InvalidAgenteRetencion THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(161, NULL, NULL);
      RETURN;

    WHEN e_InvalidUser THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(1, NULL, NULL);
      RETURN;

    WHEN e_InvalidSalarioSS THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(156, NULL, NULL);
      RETURN;

    WHEN e_InvalidMovPendiente THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(169, NULL, NULL);
      RETURN;

    WHEN e_InvalidTrabajador THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(167, NULL, NULL);
      RETURN;

    WHEN e_InvalidRemunOtroEmp THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(160, NULL, NULL);
      RETURN;

    WHEN e_IvalidAporteVoluntario THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(157, NULL, NULL);
      RETURN;

    WHEN e_InvalidRemuneracionIsr THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(513, NULL, NULL);
      RETURN;

    WHEN e_InvalidNovedad THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(166, NULL, NULL);
      RETURN;

    WHEN e_ParametrosNulos THEN
      p_ResultNumber := Seg_Retornar_Cadena_Error(8, NULL, NULL);
      RETURN;

    WHEN e_InvalidInhabilidad THEN
      p_ResultNumber := Seg_Retornar_Cadena_Error(651, NULL, NULL);
      RETURN;

    WHEN OTHERS THEN
      v_bderror      := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultnumber := Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
      RETURN;

  END Novedades_Ingreso_Crear;

  -- *****************************************************************************************************

  -- *****************************************************************************************************
  -- PROCEDURE:   Novedades_Ingreso_Editar
  -- Descripcion: Edita / Modifica en la tabla SRE_DET_MOVIMIENTO_T, la informacion concermiente a una
  --              Novedad Nueva de Ingreso.
  --
  --  Parametros IN:
  --             p_id_RegistroPatronal
  --             p_id_Nomina
  --             p_id_NSS
  --             p_SalarioSS
  --             p_AporteVoluntario
  --             p_SalarioIsr
  --             p_AgenteRetencionIsr
  --             p_OtrasRemunIsr
  --             p_RemunOtroEmp
  --             p_FechaIngreso
  --             p_ID_Usuario
  --  Parametros OUT:
  --             p_ResultNumber
  --
  -- Novedades_Ingreso_Editar
  -- -----------------------------------------------------------------------------------------------------

  PROCEDURE Novedades_Ingreso_Editar(p_id_movimiento       SRE_DET_MOVIMIENTO_T.id_movimiento%TYPE,
                                     p_id_linea            SRE_DET_MOVIMIENTO_T.id_linea%TYPE,
                                     p_id_nomina           SRE_NOMINAS_T.id_nomina%TYPE,
                                     p_id_RegistroPatronal SRE_EMPLEADORES_T.id_registro_patronal%TYPE,
                                     p_id_nss              SRE_TRABAJADORES_T.id_nss%TYPE,
                                     p_salarioSS           SRE_DET_MOVIMIENTO_T.salario_ss%TYPE,
                                     p_AporteVoluntario    SRE_DET_MOVIMIENTO_T.aporte_voluntario%TYPE,
                                     p_SalarioIsr          SRE_DET_MOVIMIENTO_T.salario_isr%TYPE,
                                     p_AgenteRetencionIsr  SRE_DET_MOVIMIENTO_T.agente_retencion_isr%TYPE,
                                     p_OtrasRemunIsr       SRE_DET_MOVIMIENTO_T.otros_ingresos_isr%TYPE,
                                     p_RemunOtroEmp        SRE_DET_MOVIMIENTO_T.remuneracion_isr_otros%TYPE,
                                     p_FechaIngreso        SRE_DET_MOVIMIENTO_T.fecha_inicio%TYPE,
                                     p_ID_Usuario          SRE_MOVIMIENTO_T.ult_usuario_act%TYPE,
                                     p_resultnumber        OUT VARCHAR2) IS

    v_bderror           VARCHAR(1000);
    v_periodo_vigente   VARCHAR(6);
    v_RegPatAgRetencion VARCHAR(6);
    v_PeriodoSigue      VARCHAR(6);
    v_facturaPaga       BOOLEAN;
    v_SalarioIsr        VARCHAR(100);
  BEGIN
    --v_RegPatAgRetencion := SRE_EMPLEADORES_PKG.get_registropatronal(p_AgenteRetencionIsr);
    v_PeriodoSigue := getPeriodoSiguiente(v_periodo_vigente, v_FacturaPaga);

    --Validacion de los parametros nulos.
    IF (p_ID_RegistroPatronal IS NULL) OR (p_ID_Nomina IS NULL) OR
       (p_ID_NSS IS NULL) OR (p_SalarioSS IS NULL) OR
       (p_ID_Usuario IS NULL) OR (p_FechaIngreso IS NULL) THEN
      RAISE e_ParametrosNulos;
    END IF;

    --Validacion del registro patronal
    IF NOT Sre_Empleadores_Pkg.Existeregistropatronal(p_id_registroPatronal) THEN
      RAISE e_InvalidRegistropatronal;
    END IF;

    --Validacion de la nomina
    IF NOT
        Sre_Nominas_Pkg.isNominaValida(p_id_RegistroPatronal, p_id_nomina) THEN
      RAISE e_InvalidNomina;
    END IF;

    --Validacion del NSS
    IF NOT Srp_Pkg.Existenss(p_id_nss) THEN
      RAISE e_IvalidNSS;
    END IF;

    --Validacion del agente de retencion.(7-A)
    IF (p_AgenteRetencionIsr IS NOT NULL) THEN
      v_RegPatAgRetencion := Sre_Empleadores_Pkg.get_registropatronal(p_AgenteRetencionIsr);
      /* if NOT Sre_Empleadores_Pkg.isRncOCedulaValida(p_AgenteRetencionIsr) THEN
          RAISE e_InvalidAgenteRetencion;
      end if;*/
    ELSIF (p_AgenteRetencionIsr IS NULL) THEN
      v_RegPatAgRetencion := 0;

    END IF;

    --Validacion del usuario
    IF NOT Seg_Usuarios_Pkg.isExisteUsuario(p_ID_Usuario) THEN
      RAISE e_invaliduser;
    END IF;

    /*if (p_SalarioSS <= 0) and (p_SalarioIsr <= 0) then
      RAISE e_InvalidSalarioSS;
    end if;*/
    /*
            IF (p_SalarioIsr <= 0) and (p_SalarioIsr <= 0) THEN
              --Validacion del salario de la seguridad social, solo en caso de que sea extrabjero puede ser cero.
              IF NOT isAgenteExtranjero(p_id_NSS) AND (p_SalarioSS <= 0) THEN
                  RAISE e_InvalidSalarioSS;
              END IF;

              --Validacion del salario de la seguridad ISR y SS (2).
              IF (p_SalarioSS <= 0) THEN
                  RAISE e_InvalidSalarioSS;
              END IF;
            END IF;
    */

    --Verificacion del Salario SS contra el rango permitido.
    IF isSalarioSSValido(p_SalarioSS) = False then
      RAISE e_InvalidSalarioSS;
    end if;

    --Validacion del salario de la seguridad ISR (5).
   /* IF (p_SalarioIsr <= 0) THEN
      v_SalarioIsr := p_SalarioSS;
    END IF;*/

    -- Validacion de Trabajador Activo.(8)
    IF isActivoTrabajadores(p_id_NSS, p_id_RegistroPatronal, p_id_nomina) THEN
      RAISE e_InvalidTrabajador;
    END IF;

    -- Validacion Remuneracion Otros Empleados, en el caso de que el agente sea el mismo empleador. (7-B)
    IF isAgenteEsEmpleador(p_AgenteRetencionIsr,
                           p_id_RegistroPatronal,
                           P_RemunOtroEmp) THEN
      RAISE e_InvalidRemunOtroEmp;
    END IF;

    -- Validacion del Campo Aporte Voluntario, Rango especificado.
    IF isAporteVoluntario(p_AporteVoluntario) THEN
      RAISE e_IvalidAporteVoluntario;
    END IF;

    -- Si el individuo tiene una factura paga del periodo para esa misma Nomina TSS.
    IF isFacturaDelPeriodoPaga(p_id_RegistroPatronal,
                               p_id_nomina,
                               v_periodo_vigente) THEN
      v_facturaPaga     := TRUE;
      v_PeriodoSigue    := getPeriodoSiguiente(v_periodo_vigente,
                                               v_facturaPaga);
      v_periodo_vigente := v_PeriodoSigue;
    END IF;

    -- Si el individuo tiene una factura paga del periodo para esa misma Nomina DGI.
    IF isLiquidacionDelPeriodoPaga(p_id_RegistroPatronal,
                                   p_id_nomina,
                                   v_periodo_vigente) THEN
      v_facturaPaga     := TRUE;
      v_PeriodoSigue    := getPeriodoSiguiente(v_periodo_vigente,
                                               v_facturaPaga);
      v_periodo_vigente := v_PeriodoSigue;
    END IF;

    -- Si la factura esta Autorizada y No Paga TSS.
    IF isFacturaAutorizadaNoPaga(p_id_RegistroPatronal,
                                 v_periodo_vigente,
                                 p_id_nomina) THEN
      RAISE e_InvalidNovedad;
    END IF;

    -- Si la factura esta Autorizada y No Paga DGI.
    IF isLiquidacionAutorizadaNoPaga(p_id_RegistroPatronal,
                                     v_periodo_vigente,
                                     p_id_nomina) THEN
      RAISE e_InvalidNovedad;
    END IF;

    UPDATE SRE_DET_MOVIMIENTO_T det
       SET det.id_nomina              = p_ID_Nomina,
           det.id_nss                 = p_ID_NSS,
           det.salario_ss             = p_SalarioSS,
           det.aporte_voluntario      = p_AporteVoluntario,
           det.salario_isr            = p_SalarioIsr,
           det.agente_retencion_isr   = v_RegPatAgRetencion,
           det.remuneracion_isr_otros = p_OtrasRemunIsr,
           det.otros_ingresos_isr     = p_RemunOtroEmp,
           det.fecha_inicio           = p_FechaIngreso,
           det.ult_fecha_act          = SYSDATE,
           det.ult_usuario_act        = p_ID_Usuario
     WHERE det.id_movimiento = p_id_movimiento
       AND id_linea = p_id_linea
       AND id_tipo_novedad = 'IN';

    p_ResultNumber := 0;
    COMMIT;

  EXCEPTION

    WHEN e_InvalidRegistropatronal THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(3, NULL, NULL);
      RETURN;

    WHEN e_InvalidNomina THEN
      p_ResultNumber := Seg_Retornar_Cadena_Error(155, NULL, NULL);
      RETURN;

    WHEN e_IvalidNSS THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(24, NULL, NULL);
      RETURN;

    WHEN e_InvalidAgenteRetencion THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(161, NULL, NULL);
      RETURN;

    WHEN e_InvalidUser THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(1, NULL, NULL);
      RETURN;

    WHEN e_InvalidSalarioSS THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(156, NULL, NULL);
      RETURN;

    WHEN e_InvalidRemunOtroEmp THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(160, NULL, NULL);
      RETURN;

    WHEN e_IvalidAporteVoluntario THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(157, NULL, NULL);
      RETURN;

    WHEN e_InvalidNovedad THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(158, NULL, NULL);
      RETURN;

    WHEN e_ParametrosNulos THEN
      p_ResultNumber := Seg_Retornar_Cadena_Error(8, NULL, NULL);
      RETURN;

    WHEN OTHERS THEN
      v_bderror      := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultnumber := Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
      RETURN;

  END Novedades_Ingreso_Editar;

  -- *****************************************************************************************************
  -- *****************************************************************************************************
  -- PROCEDURE:   Novedades_Salida_Crear
  -- Descripcion: Inserta en la tabla SRE_DET_MOVIMIENTO_T, la informacion concermiente a una
  --              Novedad Nueva de Salida (Baja).
  --
  --  Parametros IN:
  --             p_id_RegistroPatronal
  --             p_id_Nomina
  --             p_id_NSS
  --             p_SalarioSS
  --             p_AporteVoluntario
  --             p_SalarioIsr
  --             p_AgenteRetencionIsr
  --             p_OtrasRemunIsr
  --             p_RemunOtroEmp
  --             p_FechaIngreso
  --             p_ID_Usuario
  --  Parametros OUT:
  --             p_ResultNumber
  --
  -- Novedades_Salida_Crear
  -- -----------------------------------------------------------------------------------------------------
  PROCEDURE Novedades_Salida_Crear(p_id_RegistroPatronal SRE_EMPLEADORES_T.id_registro_patronal%TYPE,
                                   p_id_Nomina           SRE_NOMINAS_T.id_nomina%TYPE,
                                   p_id_NSS              SRE_TRABAJADORES_T.id_nss%TYPE,
                                   p_SalarioSS           SRE_DET_MOVIMIENTO_T.salario_ss%TYPE,
                                   p_AporteVoluntario    SRE_DET_MOVIMIENTO_T.aporte_voluntario%TYPE,
                                   p_SalarioIsr          SRE_DET_MOVIMIENTO_T.salario_isr%TYPE,
                                   p_SalarioINF          SRE_DET_MOVIMIENTO_T.SALARIO_INFOTEP%TYPE,
                                   p_AgenteRetencionIsr  SRE_EMPLEADORES_T.Rnc_o_Cedula%TYPE,
                                   p_OtrasRemunIsr       SRE_DET_MOVIMIENTO_T.otros_ingresos_isr%TYPE,
                                   p_IngresosExentos     SRE_DET_MOVIMIENTO_T.Ingresos_Exentos_Isr%TYPE,
                                   p_SaldoFavor          SRE_DET_MOVIMIENTO_T.Saldo_Favor_Isr%TYPE,
                                   p_RemunOtroEmp        SRE_DET_MOVIMIENTO_T.remuneracion_isr_otros%TYPE,
                                   p_FechaEgreso         SRE_DET_MOVIMIENTO_T.fecha_inicio%type,
                                   p_ID_Usuario          SRE_MOVIMIENTO_T.ult_usuario_act%TYPE,
                                   p_tipo_ingreso        number,
                                   p_IPAddress           SRE_MOVIMIENTO_T.Ip_Address%TYPE,
                                   p_ResultNumber        OUT VARCHAR2) IS

    v_bderror           VARCHAR(1000);
    v_IDMovimiento      SRE_MOVIMIENTO_T.id_movimiento%TYPE;
    v_IDLinea           SRE_DET_MOVIMIENTO_T.id_linea%TYPE;
    v_periodo_vigente   VARCHAR(6);
    v_SalarioIsr        SRE_DET_MOVIMIENTO_T.Salario_Isr%TYPE;
    v_SalarioINF        SRE_DET_MOVIMIENTO_T.SALARIO_INFOTEP%TYPE;
    v_RegPatAgRetencion SRE_DET_MOVIMIENTO_T.AGENTE_RETENCION_SS%TYPE;
    v_mensaje           VARCHAR(1000);
    v_PeriodoSigue      VARCHAR(6);
    v_facturaPaga       BOOLEAN;

  BEGIN

    v_SalarioISR      := p_SalarioIsr;
    v_SalarioINF      := p_SalarioINF;
    v_periodo_vigente := Parm.periodo_vigente;
    -- v_RegPatAgRetencion := SRE_EMPLEADORES_PKG.get_registropatronal(p_AgenteRetencionIsr);
    v_PeriodoSigue := getPeriodoSiguiente(v_periodo_vigente, v_FacturaPaga);

    --Validacion de los parametros nulos.
    IF (p_ID_RegistroPatronal IS NULL) OR (p_ID_Nomina IS NULL) OR
       (p_ID_NSS IS NULL) OR (p_SalarioSS IS NULL) OR
       (p_ID_Usuario IS NULL) OR (p_FechaEgreso IS NULL) THEN
      RAISE e_ParametrosNulos;
    END IF;

    --Validacion del registro patronal
    IF NOT Sre_Empleadores_Pkg.Existeregistropatronal(p_id_registroPatronal) THEN
      RAISE e_InvalidRegistropatronal;
    END IF;

    --Validacion de la nomina
    IF NOT
        Sre_Nominas_Pkg.isNominaValida(p_id_RegistroPatronal, p_id_nomina) THEN
      RAISE e_InvalidNomina;
    END IF;

    --Validacion del NSS
    IF NOT Srp_Pkg.Existenss(p_id_nss) THEN
      RAISE e_IvalidNSS;
    END IF;

    --Validacion del agente de retencion.
    /*  IF NOT Sre_Empleadores_Pkg.isRncOCedulaValida(p_AgenteRetencionIsr) THEN
        RAISE e_InvalidAgenteRetencion;
    END IF;*/

    --Validacion del agente de retencion.(7-A)
    IF (p_AgenteRetencionIsr IS NOT NULL) THEN
      v_RegPatAgRetencion := Sre_Empleadores_Pkg.get_registropatronal(p_AgenteRetencionIsr);

      if v_RegPatAgRetencion = '-1' then
        RAISE e_InvalidAgenteRetencion;
      end if;

      /* if NOT Sre_Empleadores_Pkg.isRncOCedulaValida(v_RegPatAgRetencion) and (p_RemunOtroEmp <= 0) THEN
          RAISE e_InvalidAgenteRetencion;
      end if;*/
    ELSIF (p_AgenteRetencionIsr IS NULL) THEN
      v_RegPatAgRetencion := NULL;

    END IF;

    -- Fue puesta ultimamente.
    IF (v_RegPatAgRetencion = p_id_RegistroPatronal) AND
       (p_RemunOtroEmp <= 0) THEN
      RAISE e_InvalidAgenteIgual;
    END IF;

    -- Fue puesta ultimamente.
    IF (v_RegPatAgRetencion <> p_id_RegistroPatronal) AND
       (p_RemunOtroEmp <> 0) THEN
      RAISE e_InvalidAgenteDif;
    END IF;

    --Validacion del usuario
    IF NOT Seg_Usuarios_Pkg.isExisteUsuario(p_ID_Usuario) THEN
      RAISE e_invaliduser;
    END IF;

   /* if (p_SalarioSS <= 0) and (p_SalarioIsr <= 0) then
      RAISE e_InvalidSalarioSS;
    end if;*/

    /*
            IF (p_SalarioIsr <= 0) and (p_SalarioIsr <= 0) THEN
                --Validacion del salario de la seguridad social, solo en caso de que sea extrabjero puede ser cero.
                IF isAgenteExtranjero(p_id_NSS) AND (p_SalarioSS <= 0) THEN
                    RAISE e_InvalidSalarioSS;
                END IF;

                --Validacion del salario de la seguridad social.
                IF (p_SalarioSS <= 0) THEN
                    RAISE e_InvalidSalarioSS;
                END IF;
             END IF;
    */

    --Verificacion del Salario SS contra el rango permitido.
    IF isSalarioSSValido(p_SalarioSS) = False then
      RAISE e_InvalidSalarioSS;
    end if;

    --Validacion del salario de ISR .
   /* IF (v_SalarioIsr <= 0) THEN
      v_SalarioIsr := p_SalarioSS;
    END IF;*/

   /* --Validacion del salario de ISR .
    IF (v_SalarioINF <= 0) THEN
      v_SalarioINF := p_SalarioSS;
    END IF;*/

    -- Validacion de Trabajador Activo.(8)
    IF isInactivoTrabajadores(p_id_NSS, p_id_RegistroPatronal, p_id_nomina) THEN
      RAISE e_InvalidTrabajador;
    END IF;

    -- Existe en trabajadores.(8)
    IF NOT isExisteTrabajador(p_id_NSS, p_id_RegistroPatronal, p_id_nomina) THEN
      RAISE e_InvalidExisteTrabajador;
    END IF;

    -- Validacion de Movimiento sin procesar. (8)
    IF isExisteMovimiento(p_id_NSS,
                          p_id_RegistroPatronal,
                          'SA',
                          p_id_nomina) THEN
      RAISE e_InvalidMovPendiente;
    ELSE
      v_IDMovimiento := get_id_movimiento(p_ID_RegistroPatronal,
                                          p_ID_Usuario,
                                          'NV',
                                          p_ID_Usuario,
                                          p_IPAddress);
      v_IDLinea      := Get_Id_Linea(v_IDMovimiento);
    END IF;

    -- Validacion Remuneracion Otros Empleados, en el caso de que el agente sea el mismo empleador.
    IF isAgenteEsEmpleador(v_RegPatAgRetencion,
                           p_id_RegistroPatronal,
                           P_RemunOtroEmp) THEN
      RAISE e_InvalidRemunOtroEmp;
    END IF;

    -- Validacion del Campo Aporte Voluntario, Rango especificado.
    IF isAporteVoluntario(p_AporteVoluntario) THEN
      RAISE e_IvalidAporteVoluntario;
    END IF;

    /* -- Si el individuo tiene una factura paga del periodo para esa misma Nomina TSS.
    IF isFacturaDelPeriodoPaga(p_id_RegistroPatronal, p_ID_Nomina, v_periodo_vigente) THEN
        v_facturaPaga     := True;
        v_PeriodoSigue    := getPeriodoSiguiente(v_periodo_vigente,
                                                 v_facturaPaga);
        v_periodo_vigente := v_PeriodoSigue;
    END IF;

    -- Si el individuo tiene una factura paga del periodo para esa misma Nomina DGI.
    IF isLiquidacionDelPeriodoPaga(p_id_RegistroPatronal, p_ID_Nomina,
                                   v_periodo_vigente) THEN
        v_facturaPaga     := True;
        v_PeriodoSigue    := getPeriodoSiguiente(v_periodo_vigente,
                                                 v_facturaPaga);
        v_periodo_vigente := v_PeriodoSigue;
    END IF;*/

    -- Si el individuo tiene una factura paga del periodo para esa misma Nomina TSS.
    IF isFacturaDelPeriodoPaga(p_id_RegistroPatronal,
                               p_ID_Nomina,
                               v_periodo_vigente) AND
       isLiquidacionDelPeriodoPaga(p_id_RegistroPatronal,
                                   p_ID_Nomina,
                                   v_periodo_vigente) THEN
      v_facturaPaga     := TRUE;
      v_PeriodoSigue    := getPeriodoSiguiente(v_periodo_vigente,
                                               v_facturaPaga);
      v_periodo_vigente := v_PeriodoSigue;
    END IF;

    -- Si la factura esta Autorizada y No Paga TSS.
    IF isFacturaAutorizadaNoPaga(p_id_RegistroPatronal,
                                 v_periodo_vigente,
                                 p_id_nomina) OR
       isLiquidacionAutorizadaNoPaga(p_id_RegistroPatronal,
                                     v_periodo_vigente,
                                     p_id_nomina) THEN
      RAISE e_InvalidNovedad;
    END IF;

    -- Si la factura esta Autorizada y No Paga DGI.

    INSERT INTO SRE_DET_MOVIMIENTO_T
      (id_movimiento,
       id_linea,
       agente_retencion_isr,
       id_nss,
       id_tipo_novedad,
       id_nomina,
       periodo_aplicacion,
       fecha_inicio,
       aporte_voluntario,
       otros_ingresos_isr,
       remuneracion_isr_otros,
       salario_isr,
       SALARIO_INFOTEP,
       SALARIO_SS,
       Ingresos_Exentos_Isr,
       Saldo_Favor_Isr,
       ult_fecha_act,
       ult_usuario_act,
       cod_ingreso)
    VALUES
      (v_IDMovimiento,
       v_IDLinea,
       v_RegPatAgRetencion,
       p_id_NSS,
       'SA',
       p_id_Nomina,
       v_periodo_vigente,
       p_FechaEgreso,
       p_AporteVoluntario,
       p_OtrasRemunIsr,
       p_RemunOtroEmp,
       v_SalarioIsr,
       v_SalarioINF,
       p_SalarioSS,
       p_IngresosExentos,
       p_SaldoFavor,
       SYSDATE,
       p_ID_Usuario,
       p_tipo_ingreso);

    p_ResultNumber := 0;
    COMMIT;

  EXCEPTION

    WHEN e_InvalidRegistropatronal THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(3, NULL, NULL);
      RETURN;

    WHEN e_InvalidAgenteIgual THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(211, NULL, NULL);
      RETURN;

    WHEN e_InvalidAgenteDif THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(212, NULL, NULL);
      RETURN;

    WHEN e_InvalidNomina THEN
      p_ResultNumber := Seg_Retornar_Cadena_Error(155, NULL, NULL);
      RETURN;

    WHEN e_IvalidNSS THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(24, NULL, NULL);
      RETURN;

    WHEN e_InvalidAgenteRetencion THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(161, NULL, NULL);
      RETURN;

    WHEN e_InvalidUser THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(1, NULL, NULL);
      RETURN;

    WHEN e_InvalidSalarioSS THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(156, NULL, NULL);
      RETURN;

    WHEN e_InvalidExisteTrabajador THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(514, NULL, NULL);
      RETURN;

    WHEN e_InvalidRemunOtroEmp THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(160, NULL, NULL);
      RETURN;

    WHEN e_IvalidAporteVoluntario THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(157, NULL, NULL);
      RETURN;

    WHEN e_InvalidMovPendiente THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(169, NULL, NULL);
      RETURN;

    WHEN e_InvalidTrabajador THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(170, NULL, NULL);
      RETURN;

    WHEN e_InvalidNovedad THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(166, NULL, NULL);
      RETURN;

    WHEN e_ParametrosNulos THEN
      p_ResultNumber := Seg_Retornar_Cadena_Error(8, NULL, NULL);
      RETURN;

    WHEN OTHERS THEN
      v_bderror      := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultnumber := Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
      RETURN;
  END;

  -- *****************************************************************************************************
  -- *****************************************************************************************************
  -- PROCEDURE:   Novedades_Salida_Editar
  -- Descripcion: Edita / Modifica en la tabla SRE_DET_MOVIMIENTO_T, la informacion concermiente a una
  --              Novedad Nueva de Salida (Baja).
  --
  --  Parametros IN:
  --             p_id_RegistroPatronal
  --             p_id_Nomina
  --             p_id_NSS
  --             p_SalarioSS
  --             p_AporteVoluntario
  --             p_SalarioIsr
  --             p_AgenteRetencionIsr
  --             p_OtrasRemunIsr
  --             p_RemunOtroEmp
  --             p_FechaIngreso
  --             p_ID_Usuario
  --  Parametros OUT:
  --             p_ResultNumber
  --
  -- Novedades_Salida_Editar
  -- -----------------------------------------------------------------------------------------------------

  PROCEDURE Novedades_Salida_Editar(p_id_RegistroPatronal SRE_EMPLEADORES_T.id_registro_patronal%TYPE,
                                    p_IDMovimiento        SRE_DET_MOVIMIENTO_T.id_movimiento%TYPE,
                                    p_IDLinea             SRE_DET_MOVIMIENTO_T.id_linea%TYPE,
                                    p_id_nomina           SRE_NOMINAS_T.id_nomina%TYPE,
                                    p_IDNSS               SRE_TRABAJADORES_T.id_nss%TYPE,
                                    p_SalarioSS           SRE_DET_MOVIMIENTO_T.salario_ss%TYPE,
                                    p_AporteVoluntario    SRE_DET_MOVIMIENTO_T.aporte_voluntario%TYPE,
                                    p_SalarioIsr          SRE_DET_MOVIMIENTO_T.salario_isr%TYPE,
                                    p_AgenteRetencionIsr  SRE_DET_MOVIMIENTO_T.agente_retencion_isr%TYPE,
                                    p_OtrasRemunIsr       SRE_DET_MOVIMIENTO_T.otros_ingresos_isr%TYPE,
                                    p_RemunOtroEmp        SRE_DET_MOVIMIENTO_T.remuneracion_isr_otros%TYPE,
                                    p_FechaEgreso         SRE_DET_MOVIMIENTO_T.fecha_inicio%TYPE,
                                    p_UltUsuarioAct       SRE_MOVIMIENTO_T.ult_usuario_act%TYPE,
                                    p_resultnumber        OUT VARCHAR2) IS
    v_bderror           VARCHAR(1000);
    v_RegPatAgRetencion VARCHAR(6);
    v_PeriodoSigue      VARCHAR(6);
    v_periodo_vigente   VARCHAR(6);
    v_facturaPaga       BOOLEAN;
    v_SalarioIsr        VARCHAR(100);
  BEGIN
    -- v_RegPatAgRetencion := SRE_EMPLEADORES_PKG.get_registropatronal(p_AgenteRetencionIsr);
    v_periodo_vigente := Parm.periodo_vigente;
    v_PeriodoSigue    := getPeriodoSiguiente(v_periodo_vigente,
                                             v_FacturaPaga);

    --Validacion de los parametros nulos.
    IF (p_ID_RegistroPatronal IS NULL) OR (p_ID_Nomina IS NULL) OR
       (p_IDNSS IS NULL) OR (p_SalarioSS IS NULL) OR
       (p_AgenteRetencionIsr IS NULL) OR (p_UltUsuarioAct IS NULL) OR
       (p_FechaEgreso IS NULL) THEN
      RAISE e_ParametrosNulos;
    END IF;

    --Validacion del registro patronal
    IF NOT Sre_Empleadores_Pkg.Existeregistropatronal(p_id_registroPatronal) THEN
      RAISE e_InvalidRegistropatronal;
    END IF;

    --Validacion de la nomina
    IF NOT
        Sre_Nominas_Pkg.isNominaValida(p_id_RegistroPatronal, p_id_nomina) THEN
      RAISE e_InvalidNomina;
    END IF;

    --Validacion del NSS
    IF NOT Srp_Pkg.Existenss(p_IDNSS) THEN
      RAISE e_IvalidNSS;
    END IF;

    --Validacion del agente de retencion.
    /* IF NOT Sre_Empleadores_Pkg.isRncOCedulaValida(p_AgenteRetencionIsr) THEN
        RAISE e_InvalidAgenteRetencion;
    END IF;*/

    IF (p_AgenteRetencionIsr IS NOT NULL) THEN
      v_RegPatAgRetencion := Sre_Empleadores_Pkg.get_registropatronal(p_AgenteRetencionIsr);
      /*if NOT Sre_Empleadores_Pkg.isRncOCedulaValida(p_AgenteRetencionIsr) THEN
          RAISE e_InvalidAgenteRetencion;
      end if;*/
    ELSIF (p_AgenteRetencionIsr IS NULL) THEN
      v_RegPatAgRetencion := NULL;

    END IF;

    --Validacion del usuario
    IF NOT Seg_Usuarios_Pkg.isExisteUsuario(p_UltUsuarioAct) THEN
      RAISE e_invaliduser;
    END IF;

    /*if (p_SalarioSS <= 0) and (p_SalarioIsr <= 0) then
      RAISE e_InvalidSalarioSS;
    end if;*/
    /*
            IF (p_SalarioIsr <= 0) and (p_SalarioIsr <= 0) THEN
              --Validacion del salario de la seguridad social, solo en caso de que sea extrabjero puede ser cero.
              IF isAgenteExtranjero(p_IDNSS) AND (p_SalarioSS <= 0) THEN
                  RAISE e_InvalidSalarioSS;
              END IF;

               --Validacion del salario de la seguridad ISR y SS.
              IF (p_SalarioIsr <= 0) THEN
                  v_SalarioIsr := p_SalarioSS ;
              END IF;
            END IF;
    */

    --Verificacion del Salario SS contra el rango permitido.
    IF isSalarioSSValido(p_SalarioSS) = False then
      RAISE e_InvalidSalarioSS;
    end if;

    --Validacion del salario de la seguridad ISR y SS (2).
   /* IF (p_SalarioSS <= 0) THEN
      RAISE e_InvalidSalarioSS;
    END IF;*/

    -- Validacion de Trabajador Activo.(8)
    IF NOT
        isInactivoTrabajadores(p_IDNSS, p_id_RegistroPatronal, p_id_nomina) THEN
      RAISE e_InvalidTrabajador;
    END IF;

    -- Validacion Remuneracion Otros Empleados, en el caso de que el agente sea el mismo empleador.
    IF isAgenteEsEmpleador(p_AgenteRetencionIsr,
                           p_id_RegistroPatronal,
                           P_RemunOtroEmp) THEN
      RAISE e_InvalidRemunOtroEmp;
    END IF;

    -- Validacion del Campo Aporte Voluntario, Rango especificado.
    IF isAporteVoluntario(p_AporteVoluntario) THEN
      RAISE e_IvalidAporteVoluntario;
    END IF;

    -- Si el individuo tiene una factura paga del periodo para esa misma Nomina TSS.
    IF isFacturaDelPeriodoPaga(p_id_RegistroPatronal,
                               p_id_nomina,
                               v_periodo_vigente) THEN
      v_facturaPaga     := TRUE;
      v_PeriodoSigue    := getPeriodoSiguiente(v_periodo_vigente,
                                               v_facturaPaga);
      v_periodo_vigente := v_PeriodoSigue;
    END IF;

    -- Si el individuo tiene una factura paga del periodo para esa misma Nomina DGI.
    IF isLiquidacionDelPeriodoPaga(p_id_RegistroPatronal,
                                   p_id_nomina,
                                   v_periodo_vigente) THEN
      v_facturaPaga     := TRUE;
      v_PeriodoSigue    := getPeriodoSiguiente(v_periodo_vigente,
                                               v_facturaPaga);
      v_periodo_vigente := v_PeriodoSigue;
    END IF;

    -- Si la factura esta Autorizada y No Paga TSS.
    IF isFacturaAutorizadaNoPaga(p_id_RegistroPatronal,
                                 v_periodo_vigente,
                                 p_id_nomina) THEN
      RAISE e_InvalidNovedad;
    END IF;

    -- Si la factura esta Autorizada y No Paga DGI.
    IF isLiquidacionAutorizadaNoPaga(p_id_RegistroPatronal,
                                     v_periodo_vigente,
                                     p_id_nomina) THEN
      RAISE e_InvalidNovedad;
    END IF;

    UPDATE SRE_DET_MOVIMIENTO_T det
       SET det.id_nomina              = p_id_nomina,
           det.id_nss                 = p_IDNSS,
           det.salario_ss             = p_SalarioSS,
           det.aporte_voluntario      = p_AporteVoluntario,
           det.salario_isr            = p_SalarioIsr,
           det.agente_retencion_isr   = v_RegPatAgRetencion,
           det.remuneracion_isr_otros = p_OtrasRemunIsr,
           det.otros_ingresos_isr     = p_RemunOtroEmp,
           det.fecha_inicio           = p_FechaEgreso,
           det.ult_fecha_act          = SYSDATE,
           det.ult_usuario_act        = p_UltUsuarioAct
     WHERE det.id_movimiento = p_IDMovimiento
       AND id_linea = p_IDLinea
       AND id_tipo_novedad = 'SA';

    p_ResultNumber := 0;
    COMMIT;

  EXCEPTION

    WHEN e_InvalidRegistropatronal THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(3, NULL, NULL);
      RETURN;

    WHEN e_InvalidNomina THEN
      p_ResultNumber := Seg_Retornar_Cadena_Error(155, NULL, NULL);
      RETURN;

    WHEN e_IvalidNSS THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(24, NULL, NULL);
      RETURN;

    WHEN e_InvalidAgenteRetencion THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(161, NULL, NULL);
      RETURN;

    WHEN e_InvalidUser THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(1, NULL, NULL);
      RETURN;

    WHEN e_InvalidSalarioSS THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(156, NULL, NULL);
      RETURN;

    WHEN e_InvalidRemunOtroEmp THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(160, NULL, NULL);
      RETURN;

    WHEN e_IvalidAporteVoluntario THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(157, NULL, NULL);
      RETURN;

    WHEN e_InvalidMovPendiente THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(169, NULL, NULL);
      RETURN;

    WHEN e_InvalidTrabajador THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(167, NULL, NULL);
      RETURN;

    WHEN e_InvalidNovedad THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(166, NULL, NULL);
      RETURN;

    WHEN e_ParametrosNulos THEN
      p_ResultNumber := Seg_Retornar_Cadena_Error(8, NULL, NULL);
      RETURN;

    WHEN OTHERS THEN
      v_bderror      := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultnumber := Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
      RETURN;

  END;

  -- *****************************************************************************************************
  -- *****************************************************************************************************
  -- PROCEDURE: Novedades_ActualizaDatos_Crear
  -- Descripcion: Inserta en la tabla SRE_DET_MOVIMIENTO_T, la informacion concermiente a una
  --              Novedad Nueva de Actualiza Datos.
  --
  --  Parametros IN:
  --             p_id_RegistroPatronal
  --             p_id_Nomina
  --             p_id_NSS
  --             p_SalarioSS
  --             p_AporteVoluntario
  --             p_SalarioIsr
  --             p_AgenteRetencionIsr
  --             p_OtrasRemunIsr
  --             p_RemunOtroEmp
  --             p_FechaIngreso
  --             p_ID_Usuario
  --  Parametros OUT:
  --             p_ResultNumber
  --
  -- Novedades_ActualizaDatos_Crear
  -- -----------------------------------------------------------------------------------------------------
  PROCEDURE Novedades_ActualizaDatos_Crear(p_id_RegistroPatronal SRE_EMPLEADORES_T.id_registro_patronal%TYPE,
                                           p_id_Nomina           SRE_NOMINAS_T.id_nomina%TYPE,
                                           p_id_NSS              SRE_TRABAJADORES_T.id_nss%TYPE,
                                           p_SalarioSS           SRE_DET_MOVIMIENTO_T.salario_ss%TYPE,
                                           p_AporteVoluntario    SRE_DET_MOVIMIENTO_T.aporte_voluntario%TYPE,
                                           p_SalarioIsr          SRE_DET_MOVIMIENTO_T.salario_isr%TYPE,
                                           p_SalarioINF          SRE_DET_MOVIMIENTO_T.SALARIO_INFOTEP%TYPE,
                                           p_AgenteRetencionIsr  SRE_EMPLEADORES_T.Rnc_o_Cedula%TYPE,
                                           p_OtrasRemunIsr       SRE_DET_MOVIMIENTO_T.otros_ingresos_isr%TYPE,
                                           p_RemunOtroEmp        SRE_DET_MOVIMIENTO_T.remuneracion_isr_otros%TYPE,
                                           p_IngresosExentos     SRE_DET_MOVIMIENTO_T.Ingresos_Exentos_Isr%TYPE,
                                           p_SaldoFavor          SRE_DET_MOVIMIENTO_T.Saldo_Favor_Isr%TYPE,
                                           p_FechaIngreso        SRE_DET_MOVIMIENTO_T.fecha_inicio%TYPE,
                                           p_ID_Usuario          SRE_MOVIMIENTO_T.ult_usuario_act%TYPE,
                                           p_tipo_ingreso        number,
                                           p_IPAddress           SRE_MOVIMIENTO_T.Ip_Address%TYPE,
                                           p_ResultNumber        OUT VARCHAR2) IS

    v_bderror           VARCHAR(1000);
    v_IDMovimiento      SRE_MOVIMIENTO_T.id_movimiento%TYPE;
    v_IDLinea           SRE_DET_MOVIMIENTO_T.id_linea%TYPE;
    v_periodo_vigente   VARCHAR(6);
    v_SalarioIsr        SRE_DET_MOVIMIENTO_T.salario_isr%TYPE;
    v_SalarioINF        SRE_DET_MOVIMIENTO_T.SALARIO_INFOTEP%TYPE;
    v_RegPatAgRetencion SRE_DET_MOVIMIENTO_T.AGENTE_RETENCION_SS%TYPE;
    v_mensaje           VARCHAR(1000);
    v_PeriodoSigue      VARCHAR(6);
    v_facturaPaga       BOOLEAN;

  BEGIN

    v_SalarioISR      := p_SalarioIsr;
    v_SalarioINF      := p_SalarioINF;
    v_periodo_vigente := Parm.periodo_vigente;
    v_PeriodoSigue    := getPeriodoSiguiente(v_periodo_vigente,
                                             v_FacturaPaga);

    --Validacion de los parametros nulos.
    IF (p_ID_RegistroPatronal IS NULL) OR (p_ID_Nomina IS NULL) OR
       (p_ID_NSS IS NULL) OR (p_SalarioSS IS NULL) OR
       (p_ID_Usuario IS NULL) OR (p_FechaIngreso IS NULL) THEN
      RAISE e_ParametrosNulos;
    END IF;

    --Validacion del registro patronal
    IF NOT Sre_Empleadores_Pkg.Existeregistropatronal(p_id_registroPatronal) THEN
      RAISE e_InvalidRegistropatronal;
    END IF;

    --Validacion de la nomina
    IF NOT
        Sre_Nominas_Pkg.isNominaValida(p_id_RegistroPatronal, p_id_nomina) THEN
      RAISE e_InvalidNomina;
    END IF;

    --Validacion del NSS
    IF NOT Srp_Pkg.Existenss(p_id_nss) THEN
      RAISE e_IvalidNSS;
    END IF;

    --Validacion del agente de retencion.
    IF (p_AgenteRetencionIsr IS NOT NULL) THEN
      v_RegPatAgRetencion := Sre_Empleadores_Pkg.get_registropatronal(p_AgenteRetencionIsr);

      if v_RegPatAgRetencion = '-1' then
        RAISE e_InvalidAgenteRetencion;
      end if;

      /*  if NOT Sre_Empleadores_Pkg.isRncOCedulaValida(v_RegPatAgRetencion) and (p_RemunOtroEmp <= 0) THEN
          RAISE e_InvalidAgenteRetencion;
      end if;*/
    ELSIF (p_AgenteRetencionIsr IS NULL) THEN
      v_RegPatAgRetencion := NULL;

    END IF;

    -- Fue puesta ultimamente.
    IF (v_RegPatAgRetencion = p_id_RegistroPatronal) AND
       (p_RemunOtroEmp <= 0) THEN
      RAISE e_InvalidAgenteIgual;
    END IF;

    -- Fue puesta ultimamente.
    IF (v_RegPatAgRetencion <> p_id_RegistroPatronal) AND
       (p_RemunOtroEmp <> 0) THEN
      RAISE e_InvalidAgenteDif;
    END IF;

    --Validacion del usuario
    IF NOT Seg_Usuarios_Pkg.isExisteUsuario(p_ID_Usuario) THEN
      RAISE e_invaliduser;
    END IF;

    --Validacion del salario de la seguridad social, solo en caso de que sea extrabjero puede ser cero.
 /*   IF isAgenteExtranjero(p_id_NSS) AND (p_SalarioSS <= 0) THEN
      RAISE e_InvalidSalarioSS;
    END IF;

    if (p_SalarioSS <= 0) and (p_SalarioIsr <= 0) then
      RAISE e_InvalidSalarioSS;
    end if;*/

    /*
            --Validacion del salario de la seguridad ISR y SS (2).
            IF (p_SalarioSS <= 0) THEN
                RAISE e_InvalidSalarioSS;
            END IF;
    */

    --Verificacion del Salario SS contra el rango permitido.
    IF isSalarioSSValido(p_SalarioSS) = False then
      RAISE e_InvalidSalarioSS;
    end if;

    --Validacion del salario de la seguridad ISR.
  /*  IF (v_SalarioIsr <= 0) THEN
      v_SalarioIsr := p_SalarioSS;
    END IF;*/

    --Validacion del salario de INFOTEP.
  /*  IF (v_SalarioINF <= 0) THEN
      v_SalarioINF := p_SalarioSS;
    END IF;*/

    -- Validacion de Trabajador Activo.(8)
    IF NOT
        isActivoTrabajadores(p_id_NSS, p_id_RegistroPatronal, p_id_nomina) THEN
      RAISE e_InvalidTrabajador;
    END IF;

    -- Validacion de Movimiento sin procesar. (8)
    IF isExisteMovimiento(p_id_NSS,
                          p_id_RegistroPatronal,
                          'AD',
                          p_id_nomina) THEN
      RAISE e_InvalidMovPendiente;
    ELSE
      v_IDMovimiento := get_id_movimiento(p_ID_RegistroPatronal,
                                          p_ID_Usuario,
                                          'NV',
                                          p_ID_Usuario,
                                          p_IPAddress);
      v_IDLinea      := Get_Id_Linea(v_IDMovimiento);

    END IF;

    -- Validacion Remuneracion Otros Empleados, en el caso de que el agente sea el mismo empleador.
    IF isAgenteEsEmpleador(v_RegPatAgRetencion,
                           p_id_RegistroPatronal,
                           P_RemunOtroEmp) THEN
      RAISE e_InvalidRemunOtroEmp;
    END IF;

    -- Validacion del Campo Aporte Voluntario, Rango especificado.
    IF isAporteVoluntario(p_AporteVoluntario) THEN
      RAISE e_IvalidAporteVoluntario;
    END IF;

    /*  -- Si el individuo tiene una factura paga del periodo para esa misma Nomina TSS.
    IF isFacturaDelPeriodoPaga(p_id_RegistroPatronal, p_ID_Nomina, v_periodo_vigente) THEN
        v_facturaPaga     := True;
        v_PeriodoSigue    := getPeriodoSiguiente(v_periodo_vigente,
                                                 v_facturaPaga);
        v_periodo_vigente := v_PeriodoSigue;
    END IF;

    -- Si el individuo tiene una factura paga del periodo para esa misma Nomina DGI.
    IF isLiquidacionDelPeriodoPaga(p_id_RegistroPatronal, p_ID_Nomina,
                                   v_periodo_vigente) THEN
        v_facturaPaga     := True;
        v_PeriodoSigue    := getPeriodoSiguiente(v_periodo_vigente,
                                                 v_facturaPaga);
        v_periodo_vigente := v_PeriodoSigue;
    END IF;*/

    -- Si el individuo tiene una factura paga del periodo para esa misma Nomina TSS.
    IF isFacturaDelPeriodoPaga(p_id_RegistroPatronal,
                               p_ID_Nomina,
                               v_periodo_vigente) AND
       isLiquidacionDelPeriodoPaga(p_id_RegistroPatronal,
                                   p_ID_Nomina,
                                   v_periodo_vigente) THEN
      v_facturaPaga     := TRUE;
      v_PeriodoSigue    := getPeriodoSiguiente(v_periodo_vigente,
                                               v_facturaPaga);
      v_periodo_vigente := v_PeriodoSigue;
    END IF;

    -- Si la factura esta Autorizada y No Paga TSS.
    IF isFacturaAutorizadaNoPaga(p_id_RegistroPatronal,
                                 v_periodo_vigente,
                                 p_id_nomina) THEN
      RAISE e_InvalidNovedad;
    END IF;

    -- Si la factura esta Autorizada y No Paga DGI.
    IF isLiquidacionAutorizadaNoPaga(p_id_RegistroPatronal,
                                     v_periodo_vigente,
                                     p_id_nomina) THEN
      RAISE e_InvalidNovedad;
    END IF;

    INSERT INTO SRE_DET_MOVIMIENTO_T
      (id_movimiento,
       id_linea,
       agente_retencion_isr,
       id_nss,
       id_tipo_novedad,
       id_nomina,
       periodo_aplicacion,
       fecha_inicio,
       aporte_voluntario,
       otros_ingresos_isr,
       remuneracion_isr_otros,
       salario_isr,
       salario_infotep,
       salario_ss,
       Ingresos_Exentos_Isr,
       Saldo_Favor_Isr,
       ult_fecha_act,
       ult_usuario_act,
       cod_ingreso)
    VALUES
      (v_IDMovimiento,
       v_IDLinea,
       v_RegPatAgRetencion,
       p_id_NSS,
       'AD',
       p_id_Nomina,
       v_periodo_vigente,
       p_FechaIngreso,
       p_AporteVoluntario,
       p_OtrasRemunIsr,
       p_RemunOtroEmp,
       v_SalarioIsr,
       v_SalarioINF,
       p_SalarioSS,
       p_IngresosExentos,
       p_SaldoFavor,
       SYSDATE,
       p_ID_Usuario,
       p_tipo_ingreso);

    p_ResultNumber := 0;
    COMMIT;

  EXCEPTION

    WHEN e_InvalidRegistropatronal THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(3, NULL, NULL);
      RETURN;

    WHEN e_InvalidAgenteIgual THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(211, NULL, NULL);
      RETURN;

    WHEN e_InvalidAgenteDif THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(212, NULL, NULL);
      RETURN;

    WHEN e_InvalidNomina THEN
      p_ResultNumber := Seg_Retornar_Cadena_Error(155, NULL, NULL);
      RETURN;

    WHEN e_IvalidNSS THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(24, NULL, NULL);
      RETURN;

    WHEN e_InvalidAgenteRetencion THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(161, NULL, NULL);
      RETURN;

    WHEN e_InvalidUser THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(1, NULL, NULL);
      RETURN;

    WHEN e_InvalidSalarioSS THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(156, NULL, NULL);
      RETURN;

    WHEN e_InvalidRemunOtroEmp THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(160, NULL, NULL);
      RETURN;

    WHEN e_InvalidMovPendiente THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(169, NULL, NULL);
      RETURN;

    WHEN e_InvalidTrabajador THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(167, NULL, NULL);
      RETURN;

    WHEN e_IvalidAporteVoluntario THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(157, NULL, NULL);
      RETURN;

    WHEN e_InvalidNovedad THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(166, NULL, NULL);
      RETURN;

    WHEN e_ParametrosNulos THEN
      p_ResultNumber := Seg_Retornar_Cadena_Error(8, NULL, NULL);
      RETURN;

    WHEN OTHERS THEN
      v_bderror      := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultnumber := Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
      RETURN;

  END;
  --****************************************************************************************************
  -- *****************************************************************************************************
  -- PROCEDURE: Novedades_ActualizaDatos_Edita
  -- Descripcion: Edita / Modifica en la tabla SRE_DET_MOVIMIENTO_T, la informacion concermiente a una
  --              Novedad Nueva de Ingreso.
  --
  --  Parametros IN:
  --             p_id_RegistroPatronal
  --             p_id_Nomina
  --             p_id_NSS
  --             p_SalarioSS
  --             p_AporteVoluntario
  --             p_SalarioIsr
  --             p_AgenteRetencionIsr
  --             p_OtrasRemunIsr
  --             p_RemunOtroEmp
  --             p_FechaIngreso
  --             p_ID_Usuario
  --  Parametros OUT:
  --             p_ResultNumber
  --
  -- Novedades_ActualizaDatos_Edita
  -- -----------------------------------------------------------------------------------------------------

  PROCEDURE Novedades_ActualizaDatos_Edita(p_IDMovimiento     SRE_DET_MOVIMIENTO_T.id_movimiento%TYPE,
                                           p_IDLinea          SRE_DET_MOVIMIENTO_T.id_linea%TYPE,
                                           p_id_nomina        SRE_NOMINAS_T.id_nomina%TYPE,
                                           p_IDNSS            SRE_TRABAJADORES_T.id_nss%TYPE,
                                           p_SalarioSS        SRE_DET_MOVIMIENTO_T.salario_ss%TYPE,
                                           p_AporteVoluntario SRE_DET_MOVIMIENTO_T.aporte_voluntario%TYPE,
                                           -- p_id_RegistroPatronal   SRE_EMPLEADORES_T.id_registro_patronal%TYPE,
                                           p_SalarioIsr         SRE_DET_MOVIMIENTO_T.salario_isr%TYPE,
                                           p_AgenteRetencionIsr SRE_DET_MOVIMIENTO_T.agente_retencion_isr%TYPE,
                                           p_OtrasRemunIsr      SRE_DET_MOVIMIENTO_T.otros_ingresos_isr%TYPE,
                                           p_RemunOtroEmp       SRE_DET_MOVIMIENTO_T.remuneracion_isr_otros%TYPE,
                                           p_FechaEgreso        SRE_DET_MOVIMIENTO_T.fecha_inicio%TYPE,
                                           p_UltUsuarioAct      SRE_MOVIMIENTO_T.ult_usuario_act%TYPE,
                                           p_resultnumber       OUT VARCHAR2) IS
    v_bderror           VARCHAR(1000);
    v_IDMovimiento      SRE_MOVIMIENTO_T.id_movimiento%TYPE;
    v_IDLinea           SRE_DET_MOVIMIENTO_T.id_linea%TYPE;
    v_periodo_vigente   VARCHAR(6);
    v_RegPatAgRetencion SRE_DET_MOVIMIENTO_T.AGENTE_RETENCION_SS%TYPE;
    v_mensaje           VARCHAR(1000);
    v_PeriodoSigue      VARCHAR(6);
    v_facturaPaga       BOOLEAN;
    v_SalarioIsr        VARCHAR(100);

  BEGIN

    -- v_RegPatAgRetencion := SRE_EMPLEADORES_PKG.get_registropatronal(p_AgenteRetencionIsr);
    v_periodo_vigente := Parm.periodo_vigente;
    v_PeriodoSigue    := getPeriodoSiguiente(v_periodo_vigente,
                                             v_FacturaPaga);

    --Validacion de los parametros nulos.
    IF (p_ID_Nomina IS NULL) OR (p_IDNSS IS NULL) OR (p_SalarioSS IS NULL) OR
       (p_AgenteRetencionIsr IS NULL) OR (p_UltUsuarioAct IS NULL) OR
       (p_FechaEgreso IS NULL) THEN
      RAISE e_ParametrosNulos;
    END IF;

    --Validacion de la nomina
    IF NOT Sre_Nominas_Pkg.isNominaValida(v_RegPatAgRetencion, p_id_nomina) THEN
      RAISE e_InvalidNomina;
    END IF;

    --Validacion del NSS
    IF NOT Srp_Pkg.Existenss(p_IDNSS) THEN
      RAISE e_IvalidNSS;
    END IF;

    --Validacion del agente de retencion.
    IF (p_AgenteRetencionIsr IS NOT NULL) THEN
      v_RegPatAgRetencion := Sre_Empleadores_Pkg.get_registropatronal(p_AgenteRetencionIsr);
      /* if NOT Sre_Empleadores_Pkg.isRncOCedulaValida(p_AgenteRetencionIsr) THEN
          RAISE e_InvalidAgenteRetencion;
      end if;*/
    ELSIF (p_AgenteRetencionIsr IS NULL) THEN
      v_RegPatAgRetencion := 0;

    END IF;

    --Validacion del usuario
    IF NOT Seg_Usuarios_Pkg.isExisteUsuario(p_UltUsuarioAct) THEN
      RAISE e_invaliduser;
    END IF;

    --Validacion del salario de la seguridad social, solo en caso de que sea extrabjero puede ser cero.
   /* IF isAgenteExtranjero(p_IDNSS) AND (p_SalarioSS <= 0) THEN
      RAISE e_InvalidSalarioSS;
    END IF;*/

    --Verificacion del Salario SS contra el rango permitido.
    IF isSalarioSSValido(p_SalarioSS) = False then
      RAISE e_InvalidSalarioSS;
    end if;

    --Validacion del salario de la seguridad ISR y SS.
    /*IF (p_SalarioIsr <= 0) THEN
      v_SalarioIsr := p_SalarioSS;
    END IF;*/

    --Validacion del salario de la seguridad ISR y SS (2).
   /* IF (p_SalarioSS <= 0) THEN
      RAISE e_InvalidSalarioSS;
    END IF;*/

    -- Validacion de Trabajador Activo.(8)
    IF NOT isActivoTrabajadores(p_IDNSS, v_RegPatAgRetencion, p_id_nomina) THEN
      RAISE e_InvalidTrabajador;
    END IF;

    -- Validacion Remuneracion Otros Empleados, en el caso de que el agente sea el mismo empleador.
    IF isAgenteEsEmpleador(p_AgenteRetencionIsr,
                           v_RegPatAgRetencion,
                           P_RemunOtroEmp) THEN
      RAISE e_InvalidRemunOtroEmp;
    END IF;

    -- Validacion del Campo Aporte Voluntario, Rango especificado.
    IF isAporteVoluntario(p_AporteVoluntario) THEN
      RAISE e_IvalidAporteVoluntario;
    END IF;

    -- Si el individuo tiene una factura paga del periodo para esa misma Nomina TSS.
    IF isFacturaDelPeriodoPaga(v_RegPatAgRetencion,
                               p_id_nomina,
                               v_periodo_vigente) THEN
      v_facturaPaga     := TRUE;
      v_PeriodoSigue    := getPeriodoSiguiente(v_periodo_vigente,
                                               v_facturaPaga);
      v_periodo_vigente := v_PeriodoSigue;
    END IF;

    -- Si el individuo tiene una factura paga del periodo para esa misma Nomina DGI.
    IF isLiquidacionDelPeriodoPaga(v_RegPatAgRetencion,
                                   p_id_nomina,
                                   v_periodo_vigente) THEN
      v_facturaPaga     := TRUE;
      v_PeriodoSigue    := getPeriodoSiguiente(v_periodo_vigente,
                                               v_facturaPaga);
      v_periodo_vigente := v_PeriodoSigue;
    END IF;

    -- Si la factura esta Autorizada y No Paga TSS.
    IF isFacturaAutorizadaNoPaga(v_RegPatAgRetencion,
                                 v_periodo_vigente,
                                 p_id_nomina) THEN
      RAISE e_InvalidNovedad;
    END IF;

    -- Si la factura esta Autorizada y No Paga DGI.
    IF isLiquidacionAutorizadaNoPaga(v_RegPatAgRetencion,
                                     v_periodo_vigente,
                                     p_id_nomina) THEN
      RAISE e_InvalidNovedad;
    END IF;

    UPDATE SRE_DET_MOVIMIENTO_T det
       SET det.id_nomina              = p_ID_Nomina,
           det.id_nss                 = p_IDNSS,
           det.salario_ss             = p_SalarioSS,
           det.aporte_voluntario      = p_AporteVoluntario,
           det.salario_isr            = p_SalarioIsr,
           det.agente_retencion_isr   = p_AgenteRetencionIsr,
           det.remuneracion_isr_otros = p_OtrasRemunIsr,
           det.otros_ingresos_isr     = p_RemunOtroEmp,
           det.fecha_inicio           = p_FechaEgreso,
           det.ult_usuario_act        = p_UltUsuarioAct

     WHERE det.id_movimiento = p_IDMovimiento
       AND id_linea = p_IDLinea
       AND id_tipo_novedad = 'AD';

    p_ResultNumber := 0;
    COMMIT;
  EXCEPTION

    WHEN e_InvalidRegistropatronal THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(3, NULL, NULL);
      RETURN;

    WHEN e_InvalidNomina THEN
      p_ResultNumber := Seg_Retornar_Cadena_Error(155, NULL, NULL);
      RETURN;

    WHEN e_IvalidNSS THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(24, NULL, NULL);
      RETURN;

    WHEN e_InvalidAgenteRetencion THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(161, NULL, NULL);
      RETURN;

    WHEN e_InvalidUser THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(1, NULL, NULL);
      RETURN;

    WHEN e_InvalidSalarioSS THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(156, NULL, NULL);
      RETURN;

    WHEN e_InvalidRemunOtroEmp THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(160, NULL, NULL);
      RETURN;

    WHEN e_IvalidAporteVoluntario THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(157, NULL, NULL);
      RETURN;

    WHEN e_InvalidNovedad THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(158, NULL, NULL);
      RETURN;

    WHEN e_ParametrosNulos THEN
      p_ResultNumber := Seg_Retornar_Cadena_Error(8, NULL, NULL);
      RETURN;

    WHEN OTHERS THEN
      v_bderror      := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultnumber := Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
      RETURN;

  END;

  -- *****************************************************************************************************
  --- *****************************************************************************************************
  -- PROCEDURE: Novedades_Licencia_Crear
  -- Descripcion: Inserta en la tabla SRE_DET_MOVIMIENTO_T, la informacion concermiente a una
  --              Novedad Nueva de Licencia.
  --
  --  Parametros IN:
  --             p_id_RegistroPatronal
  --             p_IDNSS
  --             p_id_nomina
  --             p_TipoLicencia
  --             p_FechaInicio
  --             p_FechaFin
  --             p_AgenteRetencionIsr
  --             p_UltUsuarioAct
  --  Parametros OUT:
  --             p_ResultNumber
  --
  -- Novedades_Licencia_Crear
  -- -----------------------------------------------------------------------------------------------------

  PROCEDURE Novedades_Licencia_Crear(p_RegistroPatronal SRE_EMPLEADORES_T.id_registro_patronal%TYPE,
                                     p_IDNSS            SRE_TRABAJADORES_T.id_nss%TYPE,
                                     p_id_nomina        SRE_NOMINAS_T.id_nomina%TYPE,
                                     p_TipoLicencia     SRE_DET_MOVIMIENTO_T.id_tipo_novedad%TYPE,
                                     p_FechaInicio      SRE_DET_MOVIMIENTO_T.fecha_inicio%TYPE,
                                     p_FechaFin         SRE_DET_MOVIMIENTO_T.fecha_fin%TYPE,
                                     -- p_AgenteRetencionIsr  SRE_EMPLEADORES_T.Rnc_o_Cedula%TYPE,
                                     -- p_IngresosExentos     Sre_Det_Movimiento_t.Ingresos_Exentos_Isr%type,
                                     -- p_SaldoFavor         SRE_DET_MOVIMIENTO_T.Saldo_Favor_Isr%type,
                                     p_UltUsuarioAct SRE_MOVIMIENTO_T.ult_usuario_act%TYPE,
                                     p_IPAddress     SRE_MOVIMIENTO_T.Ip_Address%TYPE,
                                     p_resultnumber  OUT VARCHAR2) IS
    v_bderror         VARCHAR(1000);
    v_IDMovimiento    SRE_MOVIMIENTO_T.id_movimiento%TYPE;
    v_IDLinea         SRE_DET_MOVIMIENTO_T.id_linea%TYPE;
    v_periodo_vigente VARCHAR(6);
    v_SalarioISR      SRE_DET_MOVIMIENTO_T.salario_isr%TYPE;
    -- v_RegPatAgRetencion SRE_DET_MOVIMIENTO_T.AGENTE_RETENCION_SS%TYPE;
    v_facturaPaga BOOLEAN;

  BEGIN
    /*v_IDMovimiento      := get_id_movimiento(p_RegistroPatronal,
    p_UltUsuarioAct,
    'NV',
    p_UltUsuarioAct);*/
    v_IDLinea         := Get_Id_Linea(v_IDMovimiento);
    v_periodo_vigente := Parm.periodo_vigente;
    -- v_RegPatAgRetencion := SRE_EMPLEADORES_PKG.get_registropatronal(p_AgenteRetencionIsr);

    --Validacion de los parametros nulos.
    IF (p_id_nomina IS NULL) OR (p_IDNSS IS NULL) OR
       (p_FechaInicio IS NULL) OR (p_UltUsuarioAct IS NULL) OR
       (p_FechaFin IS NULL) THEN
      RAISE e_ParametrosNulos;
    END IF;

    --Validacion del registro patronal
    IF NOT Sre_Empleadores_Pkg.Existeregistropatronal(p_RegistroPatronal) THEN
      RAISE e_InvalidRegistropatronal;
    END IF;

    --Validacion de la nomina
    IF NOT Sre_Nominas_Pkg.isNominaValida(p_RegistroPatronal, p_id_nomina) THEN
      RAISE e_InvalidNomina;
    END IF;

    --Validacion del NSS
    IF NOT Srp_Pkg.Existenss(p_IDNSS) THEN
      RAISE e_IvalidNSS;
    END IF;

    -- Existe en trabajadores.(8)
    IF NOT isExisteTrabajador(p_IDNSS, p_RegistroPatronal, p_id_nomina) THEN
      RAISE e_InvalidExisteTrabajador;
    END IF;
    /*
     --Validacion del agente de retencion.(7-A)
    IF (p_AgenteRetencionIsr is not null) then
             v_RegPatAgRetencion := SRE_EMPLEADORES_PKG.get_registropatronal(p_AgenteRetencionIsr);
           \* if NOT Sre_Empleadores_Pkg.isRncOCedulaValida(p_AgenteRetencionIsr) THEN
                RAISE e_InvalidAgenteRetencion;
            end if;*\
    elsif (p_AgenteRetencionIsr is null) then
        v_RegPatAgRetencion:= null;

    END IF;*/

    -- Movimiento
    IF isExisteMovimiento(p_IDNSS,
                          p_RegistroPatronal,
                          p_TipoLicencia,
                          p_id_nomina) THEN
      RAISE e_InvalidMovPendiente;
    ELSE
      v_IDMovimiento := get_id_movimiento(p_RegistroPatronal,
                                          p_UltUsuarioAct,
                                          'NV',
                                          p_UltUsuarioAct,
                                          p_IPAddress);
      v_IDLinea      := Get_Id_Linea(v_IDMovimiento);
    END IF;

    -- Validacion de Trabajador Activo.(8)
    IF NOT isActivoTrabajadores(p_IDNSS, p_RegistroPatronal, p_id_nomina) THEN
      RAISE e_InvalidTrabajador;
    END IF;

    --Validacion del usuario
    IF NOT Seg_Usuarios_Pkg.isExisteUsuario(p_UltUsuarioAct) THEN
      RAISE e_invaliduser;
    END IF;

    INSERT INTO SRE_DET_MOVIMIENTO_T
      (id_movimiento,
       id_linea,
       -- agente_retencion_isr,
       id_nss,
       id_nomina,
       id_tipo_novedad,
       periodo_aplicacion,
       fecha_inicio,
       fecha_fin,
       ult_fecha_act,
       ult_usuario_act)
    VALUES
      (v_IDMovimiento,
       v_IDLinea,
       --  v_RegPatAgRetencion,
       p_IDNSS,
       p_id_nomina,
       p_TipoLicencia,
       v_periodo_vigente,
       p_FechaInicio,
       p_FechaFin,
       SYSDATE,
       p_UltUsuarioAct);

    p_ResultNumber := 0;
    COMMIT;

  EXCEPTION

    WHEN e_InvalidNomina THEN
      p_ResultNumber := Seg_Retornar_Cadena_Error(155, NULL, NULL);
      RETURN;

    /* WHEN e_IvalidFecha THEN
    p_ResultNumber := Seg_Retornar_Cadena_Error(168, NULL, NULL);
    RETURN;   */

    WHEN e_InvalidRegistropatronal THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(3, NULL, NULL);
      RETURN;

    WHEN e_InvalidTrabajador THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(170, NULL, NULL);
      RETURN;

    WHEN e_InvalidMovPendiente THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(169, NULL, NULL);
      RETURN;

    WHEN e_IvalidNSS THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(24, NULL, NULL);
      RETURN;
      /*
      WHEN e_InvalidAgenteRetencion THEN
          p_resultnumber := Seg_Retornar_Cadena_Error(161, NULL, NULL);
          RETURN;*/

    WHEN e_InvalidExisteTrabajador THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(514, NULL, NULL);
      RETURN;

    WHEN e_InvalidUser THEN
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

  -- *****************************************************************************************************
  --- *****************************************************************************************************
  -- PROCEDURE: Novedades_Licencia_Editar
  -- Descripcion: Edita / Modifica en la tabla SRE_DET_MOVIMIENTO_T, la informacion concermiente a una
  --              Novedad Nueva de Licencia.
  --
  --  Parametros IN:
  --             p_id_RegistroPatronal
  --             p_id_Nomina
  --             p_id_NSS
  --             p_SalarioSS
  --             p_AgenteRetencionIsr
  --             p_FechaIngreso
  --             p_FechaFin
  --             p_ID_Usuario
  --  Parametros OUT:
  --             p_ResultNumber
  --
  -- Novedades_Licencia_Editar
  -- -----------------------------------------------------------------------------------------------------

  PROCEDURE Novedades_Licencia_Editar(p_IDMovimiento       SRE_DET_MOVIMIENTO_T.id_movimiento%TYPE,
                                      p_IDLinea            SRE_DET_MOVIMIENTO_T.id_linea%TYPE,
                                      p_IDNSS              SRE_TRABAJADORES_T.id_nss%TYPE,
                                      p_id_nomina          SRE_NOMINAS_T.id_nomina%TYPE,
                                      p_AgenteRetencionIsr SRE_DET_MOVIMIENTO_T.agente_retencion_isr%TYPE,
                                      p_TipoLicencia       SRE_DET_MOVIMIENTO_T.id_tipo_novedad%TYPE,
                                      p_FechaInicio        SRE_DET_MOVIMIENTO_T.fecha_inicio%TYPE,
                                      p_FechaFin           SRE_DET_MOVIMIENTO_T.fecha_fin%TYPE,
                                      p_UltUsuarioAct      SRE_MOVIMIENTO_T.ult_usuario_act%TYPE,
                                      p_resultnumber       OUT VARCHAR2) IS
    v_Borrar            VARCHAR2(1);
    v_RegPatAgRetencion VARCHAR(6);
    v_facturaPaga       BOOLEAN;
    v_bderror           VARCHAR(1000);
  BEGIN
    v_RegPatAgRetencion := Sre_Empleadores_Pkg.get_registropatronal(p_AgenteRetencionIsr);

    --Validacion de los parametros nulos.
    IF (p_id_nomina IS NULL) OR (p_IDNSS IS NULL) OR
       (p_FechaInicio IS NULL) OR (p_AgenteRetencionIsr IS NULL) OR
       (p_UltUsuarioAct IS NULL) OR (p_FechaFin IS NULL) THEN
      RAISE e_ParametrosNulos;
    END IF;

    --Validacion de la nomina
    IF NOT Sre_Nominas_Pkg.isNominaValida(v_RegPatAgRetencion, p_id_nomina) THEN
      RAISE e_InvalidNomina;
    END IF;

    --Validacion del NSS
    IF NOT Srp_Pkg.Existenss(p_IDNSS) THEN
      RAISE e_IvalidNSS;
    END IF;

    --Validacion del agente de retencion.
    IF NOT Sre_Empleadores_Pkg.isRncOCedulaValida(p_AgenteRetencionIsr) THEN
      RAISE e_InvalidAgenteRetencion;
    END IF;

    --Validacion del usuario
    IF NOT Seg_Usuarios_Pkg.isExisteUsuario(p_UltUsuarioAct) THEN
      RAISE e_invaliduser;
    END IF;

    -- Validacion de Trabajador Activo.(8)
    IF NOT isActivoTrabajadores(p_IDNSS, v_RegPatAgRetencion, p_id_nomina) THEN
      RAISE e_InvalidTrabajador;
    END IF;

    UPDATE SRE_DET_MOVIMIENTO_T det
       SET det.id_nss               = p_IDNSS,
           det.id_nomina            = p_id_nomina,
           det.agente_retencion_isr = v_RegPatAgRetencion,
           det.id_tipo_novedad      = p_TipoLicencia,
           det.fecha_inicio         = p_FechaInicio,
           det.fecha_fin            = p_FechaFin,
           det.ult_fecha_act        = SYSDATE,
           det.ult_usuario_act      = p_UltUsuarioAct
     WHERE det.id_movimiento = p_IDMovimiento
       AND id_linea = p_IDLinea;

    p_ResultNumber := 0;
    COMMIT;

  EXCEPTION

    WHEN e_InvalidNomina THEN
      p_ResultNumber := Seg_Retornar_Cadena_Error(155, NULL, NULL);
      RETURN;

    WHEN e_IvalidNSS THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(24, NULL, NULL);
      RETURN;

    WHEN e_InvalidAgenteRetencion THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(161, NULL, NULL);
      RETURN;

    WHEN e_InvalidTrabajador THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(167, NULL, NULL);
      RETURN;

    WHEN e_InvalidUser THEN
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
  --****************************************Vacaciones****************************
  --- *****************************************************************************************************
  -- PROCEDURE: Novedades_Vacaciones_Crear
  -- Descripcion: Inserta en la tabla SRE_DET_MOVIMIENTO_T, la informacion concermiente a una
  --              Novedad Nueva de Vacaciones.
  --
  --  Parametros IN:
  --             p_id_RegistroPatronal
  --             p_id_Nomina
  --             p_id_NSS
  --             p_SalarioSS
  --             p_AporteVoluntario
  --             p_SalarioIsr
  --             p_AgenteRetencionIsr
  --             p_OtrasRemunIsr
  --             p_RemunOtroEmp
  --             p_FechaIngreso
  --             p_ID_Usuario
  --  Parametros OUT:
  --             p_ResultNumber
  --
  -- Novedades_Vacaciones_Crear
  -- -----------------------------------------------------------------------------------------------------

  PROCEDURE Novedades_Vacaciones_Crear(p_RegistroPatronal   SRE_EMPLEADORES_T.id_registro_patronal%TYPE,
                                       p_IDNSS              SRE_TRABAJADORES_T.id_nss%TYPE,
                                       p_id_nomina          SRE_NOMINAS_T.id_nomina%TYPE,
                                       p_FechaInicio        SRE_DET_MOVIMIENTO_T.fecha_inicio%TYPE,
                                       p_FechaFin           SRE_DET_MOVIMIENTO_T.fecha_fin%TYPE,
                                       p_AgenteRetencionIsr SRE_DET_MOVIMIENTO_T.agente_retencion_isr%TYPE,
                                       p_UltUsuarioAct      SRE_MOVIMIENTO_T.ult_usuario_act%TYPE,
                                       p_IPAddress          SRE_MOVIMIENTO_T.Ip_Address%TYPE,
                                       p_resultnumber       OUT VARCHAR2) IS

    v_bderror           VARCHAR(1000);
    v_IDMovimiento      SRE_MOVIMIENTO_T.id_movimiento%TYPE;
    v_IDLinea           SRE_DET_MOVIMIENTO_T.id_linea%TYPE;
    v_periodo_vigente   VARCHAR(6);
    v_SalarioISR        SRE_DET_MOVIMIENTO_T.salario_isr%TYPE;
    v_RegPatAgRetencion SRE_MOVIMIENTO_T.id_registro_patronal%TYPE;
    v_facturaPaga       BOOLEAN;

  BEGIN
    /*  v_IDMovimiento      := get_id_movimiento(p_RegistroPatronal,
    p_UltUsuarioAct,
    'NV',
    p_UltUsuarioAct);*/
    v_IDLinea           := Get_Id_Linea(v_IDMovimiento);
    v_periodo_vigente   := Parm.periodo_vigente;
    v_RegPatAgRetencion := Sre_Empleadores_Pkg.get_registropatronal(p_AgenteRetencionIsr);

    --Validacion de los parametros nulos.
    IF (p_id_nomina IS NULL) OR (p_IDNSS IS NULL) OR
       (p_FechaInicio IS NULL) OR (p_AgenteRetencionIsr IS NULL) OR
       (p_UltUsuarioAct IS NULL) OR (p_FechaFin IS NULL) THEN
      RAISE e_ParametrosNulos;
    END IF;

    --Validacion de la nomina
    IF NOT Sre_Nominas_Pkg.isNominaValida(v_RegPatAgRetencion, p_id_nomina) THEN
      RAISE e_InvalidNomina;
    END IF;

    --Validacion del NSS
    IF NOT Srp_Pkg.Existenss(p_IDNSS) THEN
      RAISE e_IvalidNSS;
    END IF;

    --Validacion del NSS
    IF NOT Srp_Pkg.Existenss(p_IDNSS) THEN
      RAISE e_IvalidNSS;
    END IF;

    -- Movimiento
    IF isExisteMovimiento(p_IDNSS, p_RegistroPatronal, 'VC', p_id_nomina) THEN
      RAISE e_InvalidMovPendiente;
    ELSE
      v_IDMovimiento := get_id_movimiento(p_RegistroPatronal,
                                          p_UltUsuarioAct,
                                          'NV',
                                          p_UltUsuarioAct,
                                          p_IPAddress);
      v_IDLinea      := Get_Id_Linea(v_IDMovimiento);
    END IF;

    -- Validacion de Trabajador Activo.(8)
    IF NOT isActivoTrabajadores(p_IDNSS, p_RegistroPatronal, p_id_nomina) THEN
      RAISE e_InvalidTrabajador;
    END IF;

    --Validacion del agente de retencion.
    IF NOT Sre_Empleadores_Pkg.isRncOCedulaValida(p_AgenteRetencionIsr) THEN
      RAISE e_InvalidAgenteRetencion;
    END IF;

    --Validacion del usuario
    IF NOT Seg_Usuarios_Pkg.isExisteUsuario(p_UltUsuarioAct) THEN
      RAISE e_invaliduser;
    END IF;

    INSERT INTO SRE_DET_MOVIMIENTO_T
      (id_movimiento,
       id_linea,
       agente_retencion_isr,
       id_nss,
       id_nomina,
       id_tipo_novedad,
       periodo_aplicacion,
       fecha_inicio,
       fecha_fin,
       ult_fecha_act,
       ult_usuario_act)
    VALUES
      (v_IDMovimiento,
       v_IDLinea,
       v_RegPatAgRetencion,
       p_IDNSS,
       p_id_nomina,
       'VC',
       v_periodo_vigente,
       p_FechaInicio,
       p_FechaFin,
       SYSDATE,
       p_UltUsuarioAct);

    p_ResultNumber := 0;
    COMMIT;

  EXCEPTION

    WHEN e_InvalidNomina THEN
      p_ResultNumber := Seg_Retornar_Cadena_Error(155, NULL, NULL);
      RETURN;

    WHEN e_IvalidFecha THEN

      p_ResultNumber := Seg_Retornar_Cadena_Error(155, NULL, NULL);
      RETURN;

    WHEN e_IvalidNSS THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(24, NULL, NULL);
      RETURN;

    WHEN e_InvalidAgenteRetencion THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(161, NULL, NULL);
      RETURN;

    WHEN e_InvalidMovPendiente THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(169, NULL, NULL);
      RETURN;

    WHEN e_InvalidTrabajador THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(167, NULL, NULL);
      RETURN;

    WHEN e_InvalidUser THEN
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

  -- *****************************************************************************************************
  --- *****************************************************************************************************
  -- PROCEDURE: Novedades_Vacaciones_Editar
  -- Descripcion: Edita / Modifica en la tabla SRE_DET_MOVIMIENTO_T, la informacion concermiente a una
  --              Novedad Nueva de Vacaciones.
  --
  --  Parametros IN:
  --             p_id_RegistroPatronal
  --             p_id_Nomina
  --             p_id_NSS
  --             p_SalarioSS
  --             p_AporteVoluntario
  --             p_SalarioIsr
  --             p_AgenteRetencionIsr
  --             p_OtrasRemunIsr
  --             p_RemunOtroEmp
  --             p_FechaIngreso
  --             p_ID_Usuario
  --  Parametros OUT:
  --             p_ResultNumber
  --
  -- Novedades_Vacaciones_Editar
  -- -----------------------------------------------------------------------------------------------------

  PROCEDURE Novedades_Vacaciones_Editar(p_IDMovimiento       SRE_DET_MOVIMIENTO_T.id_movimiento%TYPE,
                                        p_IDLinea            SRE_DET_MOVIMIENTO_T.id_linea%TYPE,
                                        p_IDNSS              SRE_TRABAJADORES_T.id_nss%TYPE,
                                        p_id_nomina          SRE_NOMINAS_T.id_nomina%TYPE,
                                        p_AgenteRetencionIsr SRE_DET_MOVIMIENTO_T.agente_retencion_isr%TYPE,
                                        p_FechaInicio        SRE_DET_MOVIMIENTO_T.fecha_inicio%TYPE,
                                        p_FechaFin           SRE_DET_MOVIMIENTO_T.fecha_fin%TYPE,
                                        p_UltUsuarioAct      SRE_MOVIMIENTO_T.ult_usuario_act%TYPE,
                                        p_resultnumber       OUT VARCHAR2) IS
    v_Borrar            VARCHAR2(1);
    v_RegPatAgRetencion VARCHAR(6);
    v_facturaPaga       BOOLEAN;
    v_bderror           VARCHAR(1000);
  BEGIN
    v_RegPatAgRetencion := Sre_Empleadores_Pkg.get_registropatronal(p_AgenteRetencionIsr);

    --Validacion de la nomina
    IF NOT Sre_Nominas_Pkg.isNominaValida(v_RegPatAgRetencion, p_id_nomina) THEN
      RAISE e_InvalidNomina;
    END IF;

    --Validacion del NSS
    IF NOT Srp_Pkg.Existenss(p_IDNSS) THEN
      RAISE e_IvalidNSS;
    END IF;

    --Validacion del agente de retencion.
    IF NOT Sre_Empleadores_Pkg.isRncOCedulaValida(p_AgenteRetencionIsr) THEN
      RAISE e_InvalidAgenteRetencion;
    END IF;

    --Validacion del usuario
    IF NOT Seg_Usuarios_Pkg.isExisteUsuario(p_UltUsuarioAct) THEN
      RAISE e_invaliduser;
    END IF;

    -- Validacion de Trabajador Activo.(8)
    IF NOT isActivoTrabajadores(p_IDNSS, v_RegPatAgRetencion, p_id_nomina) THEN
      RAISE e_InvalidTrabajador;
    END IF;

    UPDATE SRE_DET_MOVIMIENTO_T det
       SET det.id_nss               = p_IDNSS,
           det.id_nomina            = p_id_nomina,
           det.agente_retencion_isr = v_RegPatAgRetencion,
           det.fecha_inicio         = p_FechaInicio,
           det.fecha_fin            = p_FechaFin,
           det.ult_fecha_act        = SYSDATE,
           det.ult_usuario_act      = p_UltUsuarioAct
     WHERE det.id_movimiento = p_IDMovimiento
       AND det.id_linea = p_IDLinea
       AND det.id_tipo_novedad = 'VC';

    p_ResultNumber := 0;
    COMMIT;

  EXCEPTION

    WHEN e_InvalidNomina THEN
      p_ResultNumber := Seg_Retornar_Cadena_Error(155, NULL, NULL);
      RETURN;

    WHEN e_IvalidNSS THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(24, NULL, NULL);
      RETURN;

    WHEN e_InvalidAgenteRetencion THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(161, NULL, NULL);
      RETURN;

    WHEN e_InvalidUser THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(1, NULL, NULL);
      RETURN;

    WHEN e_InvalidTrabajador THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(167, NULL, NULL);
      RETURN;

    WHEN OTHERS THEN
      v_bderror      := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultnumber := Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
      RETURN;

  END;

  --*******************************************************************************

  --- *****************************************************************************************************
  -- PROCEDURE: get_novedades
  -- Descripcion: Selecciona las Novedades.
  --
  --  Parametros IN:
  --             p_tipo_novedad
  --             p_categoria
  --
  --  Parametros OUT:
  --             io_cursor
  --
  -- get_novedades
  -- -----------------------------------------------------------------------------------------------------
  PROCEDURE get_novedades(p_tipo_novedad IN SRE_TIPO_NOVEDAD_T.id_tipo_novedad%TYPE,
                          p_categoria    IN SRE_TIPO_NOVEDAD_T.categoria%TYPE,
                          io_cursor      IN OUT t_cursor) IS
    v_cursor       t_cursor;
    v_tipo_novedad VARCHAR(100);
    v_categoria    VARCHAR(100);

  BEGIN

    v_tipo_novedad := UPPER(p_tipo_novedad);
    v_categoria    := UPPER(p_categoria);

    IF (v_tipo_novedad IS NOT NULL) AND (v_categoria IS NULL) THEN
      OPEN v_cursor FOR
        SELECT n.id_tipo_novedad, n.tipo_novedad_des, n.categoria
          FROM SRE_TIPO_NOVEDAD_T n
         WHERE n.id_tipo_novedad = v_tipo_novedad;
      COMMIT;
      io_cursor := v_cursor;
      RETURN;

    ELSIF (v_categoria IS NOT NULL) AND (v_tipo_novedad IS NULL) THEN
      OPEN v_cursor FOR
        SELECT n.id_tipo_novedad, n.tipo_novedad_des, n.categoria
          FROM SRE_TIPO_NOVEDAD_T n
         WHERE n.categoria = v_categoria;
      COMMIT;
      io_cursor := v_cursor;
      RETURN;

    ELSIF (v_tipo_novedad IS NOT NULL) AND (v_categoria IS NOT NULL) THEN
      OPEN v_cursor FOR
        SELECT n.id_tipo_novedad, n.tipo_novedad_des, n.categoria
          FROM SRE_TIPO_NOVEDAD_T n
         WHERE n.id_tipo_novedad = v_tipo_novedad
           AND n.categoria = v_categoria;
      COMMIT;
      io_cursor := v_cursor;
      RETURN;

    ELSIF (v_tipo_novedad IS NULL) AND (v_categoria IS NULL) THEN
      OPEN v_cursor FOR
        SELECT n.id_tipo_novedad, n.tipo_novedad_des, n.categoria
          FROM SRE_TIPO_NOVEDAD_T n;
      COMMIT;
      io_cursor := v_cursor;
      RETURN;
    END IF;

  END;
  --************************************************************************************
  -- Para los datos de Trabajadores para Actualizacion de Datos.
  --************************************************************************************
  PROCEDURE Get_DatosTrabajadores(p_id_registro_patronal IN SRE_TRABAJADORES_T.id_registro_patronal%TYPE,
                                  p_id_nomina            IN SRE_TRABAJADORES_T.id_nomina%TYPE,
                                  p_id_nss               IN SRE_TRABAJADORES_T.id_nss%TYPE,
                                  p_io_cursor            IN OUT t_cursor) IS

    v_cursor          t_cursor;
    v_periodo         VARCHAR(20);
    v_periodo_vigente VARCHAR(6);

  BEGIN
    v_periodo_vigente := Parm.periodo_vigente;
    v_periodo         := isPeriodoSaldoFavor(p_id_registro_patronal,
                                             p_id_nomina);

    IF (p_id_registro_patronal IS not NULL) AND (p_id_nomina = 0) AND
       (p_id_nss IS not NULL) THEN
      OPEN v_cursor FOR
        SELECT e.rnc_o_cedula,
               t.FECHA_INGRESO,
               t.FECHA_SALIDA,
               NVL(t.SALARIO_SS, 0) AS SALARIO_SS,
               t.STATUS,
               t.FECHA_INICIO_VACACIONES,
               t.FECHA_FINAL_VACACIONES,
               t.FECHA_INICIO_LICENCIA,
               t.FECHA_TERMINO_LICENCIA,
               t.AFILIADO_IDSS,
               0 AS AGENTE_RETENCION_SS,
               0 ASAGENTE_RETENCION_ISR,
               NVL(t.SALARIO_ISR, 0) AS SALARIO_ISR,
               NVL(t.Salario_Infotep, 0) AS SALARIO_INFOTEP,
               0 AS SALDO_FAVOR_ISR,
               0 AS REMUNERACION_SS_OTROS,
               0 AS REMUNERACION_ISR_OTROS,
               t.FECHA_ULT_REINTEGRO,
               NVL(t.APORTE_VOLUNTARIO, 0) AS APORTE_VOLUNTARIO,
               NVL(t.APORTE_AFILIADOS_T3, 0) AS APORTE_AFILIADOS_T3,
               NVL(t.APORTE_EMPLEADOR_T3, 0) AS APORTE_EMPLEADOR_T3c,
               t.FECHA_REGISTRO,
               0 AS OTROS_INGRESOS_ISR,
               t.TIPO_CONTRATADO,
               t.ULT_USUARIO_ACT,
               t.ULT_FECHA_ACT,
               0 AS INGRESOS_EXENTOS,
               v_periodo AS Periodo,
               initcap(tin.descripcion) AS TipoIngreso,
               t.cod_ingreso as CodIngreso

          FROM SRE_EMPLEADORES_T  e,
               SRE_TRABAJADORES_T t,
               sre_tipo_ingreso_t tin
         WHERE e.id_registro_patronal = t.id_registro_patronal
           and t.status = 'A'
           and t.id_registro_patronal = p_id_registro_patronal
           AND t.id_nss = p_id_nss
           AND t.cod_ingreso = tin.cod_ingreso(+);

      p_io_cursor := v_cursor;
    ELSIF (p_id_registro_patronal IS NOT NULL) AND
          (p_id_nomina IS NOT NULL) AND (p_id_nss IS NOT NULL) THEN
      OPEN v_cursor FOR

        SELECT e.rnc_o_cedula,
               t.FECHA_INGRESO,
               t.FECHA_SALIDA,
               NVL(t.SALARIO_SS, 0) AS SALARIO_SS,
               t.STATUS,
               t.FECHA_INICIO_VACACIONES,
               t.FECHA_FINAL_VACACIONES,
               t.FECHA_INICIO_LICENCIA,
               t.FECHA_TERMINO_LICENCIA,
               t.AFILIADO_IDSS,
               i.AGENTE_RETENCION_SS,
               i.AGENTE_RETENCION_ISR,
               NVL(t.SALARIO_ISR, 0) AS SALARIO_ISR,
               NVL(t.Salario_Infotep, 0) AS SALARIO_INFOTEP,
               NVL(i.SALDO_FAVOR_ISR, 0) AS SALDO_FAVOR_ISR,
               NVL(i.REMUNERACION_SS_OTROS, 0) AS REMUNERACION_SS_OTROS,
               NVL(i.REMUNERACION_ISR_OTROS, 0) AS REMUNERACION_ISR_OTROS,
               t.FECHA_ULT_REINTEGRO,
               NVL(t.APORTE_VOLUNTARIO, 0) AS APORTE_VOLUNTARIO,
               NVL(t.APORTE_AFILIADOS_T3, 0) AS APORTE_AFILIADOS_T3,
               NVL(t.APORTE_EMPLEADOR_T3, 0) AS APORTE_EMPLEADOR_T3c,
               t.FECHA_REGISTRO,
               NVL(i.OTROS_INGRESOS_ISR, 0) AS OTROS_INGRESOS_ISR,
               t.TIPO_CONTRATADO,
               t.ULT_USUARIO_ACT,
               t.ULT_FECHA_ACT,
               NVL(i.ingresos_exentos_isr, 0) AS INGRESOS_EXENTOS,
               v_periodo AS Periodo,
               initcap(tin.descripcion) AS TipoIngreso,
               t.cod_ingreso as CodIngreso
          FROM SRE_EMPLEADORES_T e,
               SRE_TRABAJADORES_T t,
               sre_tipo_ingreso_t tin,
               (SELECT * FROM SFC_IR13_T WHERE periodo = v_periodo) i
         WHERE e.id_registro_patronal(+) = i.agente_retencion_isr
           AND i.id_registro_patronal(+) = t.id_registro_patronal
           AND i.id_nss(+) = t.id_nss
           AND t.id_registro_patronal = p_id_registro_patronal
           AND t.id_nomina = p_id_nomina
           AND t.id_nss = p_id_nss
           AND t.cod_ingreso = tin.cod_ingreso(+);

      p_io_cursor := v_cursor;
      RETURN;

    ELSIF (p_id_registro_patronal IS NULL) AND (p_id_nomina IS NULL) AND
          (p_id_nss IS NULL) THEN
      OPEN v_cursor FOR

        SELECT e.rnc_o_cedula,
               t.FECHA_INGRESO,
               t.FECHA_SALIDA,
               NVL(t.SALARIO_SS, 0) AS SALARIO_SS,
               t.STATUS,
               t.FECHA_INICIO_VACACIONES,
               t.FECHA_FINAL_VACACIONES,
               t.FECHA_INICIO_LICENCIA,
               t.FECHA_TERMINO_LICENCIA,
               t.AFILIADO_IDSS,
               i.AGENTE_RETENCION_SS,
               i.AGENTE_RETENCION_ISR,
               NVL(t.SALARIO_ISR, 0) AS SALARIO_ISR,
               NVL(t.Salario_Infotep, 0) AS SALARIO_INFOTEP,
               NVL(i.SALDO_FAVOR_ISR, 0) AS SALDO_FAVOR_ISR,
               NVL(i.REMUNERACION_SS_OTROS, 0) AS REMUNERACION_SS_OTROS,
               NVL(i.REMUNERACION_ISR_OTROS, 0) AS REMUNERACION_ISR_OTROS,
               t.FECHA_ULT_REINTEGRO,
               NVL(t.APORTE_VOLUNTARIO, 0) AS APORTE_VOLUNTARIO,
               NVL(t.APORTE_AFILIADOS_T3, 0) AS APORTE_AFILIADOS_T3,
               NVL(t.APORTE_EMPLEADOR_T3, 0) AS APORTE_EMPLEADOR_T3c,
               t.FECHA_REGISTRO,
               NVL(i.OTROS_INGRESOS_ISR, 0) AS OTROS_INGRESOS_ISR,
               t.TIPO_CONTRATADO,
               t.ULT_USUARIO_ACT,
               t.ULT_FECHA_ACT,
               NVL(i.ingresos_exentos_isr, 0) AS INGRESOS_EXENTOS,
               v_periodo AS Periodo,
               initcap(tin.descripcion) AS TipoIngreso,
               t.cod_ingreso as CodIngreso
          FROM SRE_EMPLEADORES_T  e,
               SRE_TRABAJADORES_T t,
               SFC_IR13_T         i,
               sre_tipo_ingreso_t tin
         WHERE e.id_registro_patronal(+) = i.agente_retencion_isr
           AND i.id_registro_patronal(+) = t.id_registro_patronal
           AND i.id_nss(+) = t.id_nss
           AND i.periodo = v_periodo
           AND t.cod_ingreso = tin.cod_ingreso(+);

      p_io_cursor := v_cursor;
      RETURN;
    END IF;
  END;
  --************************************************** Funcion Devuelve Periodo *************
  --*****************************************************************************************
  FUNCTION isPeriodoSaldoFavor(p_id_registro_patronal SRE_EMPLEADORES_T.id_registro_patronal%TYPE,
                               p_id_nomina            SRE_NOMINAS_T.id_nomina%TYPE)
    RETURN VARCHAR

   IS
    v_facturapaga     BOOLEAN;
    v_liquidacionpaga BOOLEAN;
    v_periodo         VARCHAR(20);
    v_periodo_vigente VARCHAR(6);

  BEGIN
    v_periodo_vigente := Parm.periodo_vigente;
    v_facturapaga     := isFacturaDelPeriodoPaga(p_id_registro_patronal,
                                                 p_id_nomina,
                                                 v_periodo_vigente);
    v_liquidacionpaga := isLiquidacionDelPeriodoPaga(p_id_registro_patronal,
                                                     p_id_nomina,
                                                     v_periodo_vigente);

    IF (v_facturapaga = TRUE) AND (v_liquidacionpaga = TRUE) THEN
      v_periodo := getPeriodoSiguiente(v_periodo_vigente, v_facturapaga);
    ELSE
      v_periodo := v_periodo_vigente;
    END IF;
    RETURN(v_periodo);

  END isPeriodoSaldoFavor;

  --******************************************************************
  -- Procedimiento que invoca la funcion para devlver el periodo.
  --******************************************************************
  PROCEDURE Get_PeriodoSaldo(p_id_registro_patronal IN SRE_TRABAJADORES_T.id_registro_patronal%TYPE,
                             p_id_nomina            IN SRE_NOMINAS_T.id_nomina%TYPE,
                             p_resultnumber         OUT VARCHAR2) IS

    v_periodo VARCHAR(20);
  BEGIN
    v_periodo      := isPeriodoSaldoFavor(p_id_registro_patronal,
                                          p_id_nomina);
    p_resultnumber := v_periodo;
    RETURN;
  END;

  -- *****************************************************************************************************

  --- *****************************************************************************************************
  -- FUNCTION:    isActivoTrabajadores
  -- Descripcion: Funcion utilizada si el tranajador esta activo para esa nomina.
  --
  --  Parametros IN:
  --             p_id_nss
  --             p_id_registro_patronal
  --             p_id_nomina
  --
  --  Parametros OUT:
  --             v_is_valido
  --
  -- isAgenteExtranjero
  -- -----------------------------------------------------------------------------------------------------

  FUNCTION isExisteTrabajador(p_id_nss               SRE_TRABAJADORES_T.id_nss%TYPE,
                              p_id_registro_patronal SRE_EMPLEADORES_T.ID_REGISTRO_PATRONAL%TYPE,
                              p_id_nomina            SRE_TRABAJADORES_T.id_nomina%TYPE)
    RETURN BOOLEAN IS

    v_is_valido            BOOLEAN;
    v_id_nss               VARCHAR2(20);
    v_id_registro_patronal VARCHAR2(20);
    v_id_nomina            VARCHAR2(20);

    CURSOR c_activo_trabajadores IS
      SELECT t.id_nss, t.id_registro_patronal, t.id_nomina
        FROM SRE_TRABAJADORES_T t
       WHERE t.id_nss = p_id_nss
         AND t.id_registro_patronal = p_id_registro_patronal
         AND t.id_nomina = p_id_nomina;

  BEGIN

    OPEN c_activo_trabajadores;
    FETCH c_activo_trabajadores
      INTO v_id_nss, v_id_registro_patronal, v_id_nomina;
    IF (v_id_nss IS NULL) AND (v_id_registro_patronal IS NULL) AND
       (v_id_nomina IS NULL) AND (c_activo_trabajadores%NOTFOUND) THEN
      v_is_valido := FALSE;
    ELSE
      v_is_valido := TRUE;
    END IF;
    CLOSE c_activo_trabajadores;

    RETURN(v_is_valido);
  END isExisteTrabajador;

  -- *****************************************************************************************************
  -- Funcion utilizada para verificar si un id_movimiento tiene detalle.
  -- *****************************************************************************************************

  FUNCTION isExisteMovimientoDetalle(p_IDMovimiento SRE_DET_MOVIMIENTO_T.id_movimiento%TYPE)
    RETURN BOOLEAN IS

    v_is_valido    BOOLEAN;
    v_idmovimiento SRE_MOVIMIENTO_T.id_movimiento%TYPE;

    CURSOR existe_movimiento IS
      SELECT id_movimiento
        FROM SRE_DET_MOVIMIENTO_T t
       WHERE t.id_movimiento = p_IDMovimiento
      Union All
      Select Id_Movimiento
        From Sre_Det_Movimiento_Enf_t Dm
       Where Dm.Id_Movimiento = p_IDMovimiento;

  BEGIN

    OPEN existe_movimiento;
    FETCH existe_movimiento
      INTO v_idmovimiento;
    v_is_valido := existe_movimiento%FOUND;
    CLOSE existe_movimiento;
    RETURN(v_is_valido);

  END isExisteMovimientoDetalle;
  -- --------------------------------------------------------------------------------------------------
  procedure aplicar_movimientos_pendientes(p_registro_patronal in number) is
  begin
    for no_aplicados in (select *
                           from sre_movimiento_t a
                          where a.id_registro_patronal = p_registro_patronal
                            and a.status = 'N'
                          order by id_movimiento) loop
      sre_load_movimiento_pkg.poner_en_cola(no_aplicados.id_movimiento);
    end loop;
  end;

  -- *****************************************************************************************************
  -- Function :   isTitular_Conyuge
  -- Descripcion: Verifica que es un dependiente adicional existe en cobertura para un titular o conyuge especificado
  --
  -- --------------------------------------------------------------------------------------------------
  Function isTitular_Conyuge(p_nss_titular sre_ciudadanos_t.id_nss%type)
    Return Boolean

   is

    v_nss_titular sre_ciudadanos_t.id_nss%type;
    v_Resultado   BOOLEAN;

    --titular

    Cursor ExisteTitular is
      Select t.nss
        from tss_titulares_ars_ok_pe_mv t
       where t.nss = p_nss_titular;

    --conyuge

    Cursor ExisteConyuge is
      Select c.nss_titular
        from tss_dependientes_ok_pe_mv c
       where c.nss_dependiente = p_nss_titular
         and c.cve_parentesco in (3, 4, 19, 20);

  Begin
    Open ExisteTitular;
    Fetch ExisteTitular
      into v_nss_titular;
    v_Resultado := ExisteTitular%FOUND;
    Close ExisteTitular;

    if not (v_Resultado) then
      Open ExisteConyuge;
      Fetch ExisteConyuge
        into v_nss_titular;
      v_Resultado := ExisteConyuge%FOUND;
      Close ExisteConyuge;
    end if;

    Return(v_Resultado);

  End isTitular_Conyuge;

  -- *****************************************************************************************************
  -- Function :   isDependienteTitularAC
  -- Descripcion: validamos que el dependiente adicional que se quiere registrar no exista como titular AC
  -- --------------------------------------------------------------------------------------------------
  Function isDependienteTitularAC(p_nss_dep sre_ciudadanos_t.id_nss%type)
    Return Boolean

   is

    v_nss_dep   sre_ciudadanos_t.id_nss%type;
    v_Resultado BOOLEAN;

    Cursor ExisteDep is
      Select c.nss
        from tss_titulares_ars_ok_pe_mv c
       where c.nss = p_nss_dep
         and c.c_status = 'AC';
  Begin
    Open ExisteDep;
    Fetch ExisteDep
      into v_nss_dep;
    v_Resultado := ExisteDep%FOUND;
    Close ExisteDep;

    Return(v_Resultado);

  End isDependienteTitularAC;

  -- *****************************************************************************************************
  -- Function :   IsDepNucleoValido
  -- Descripcion: Verifica que un dependiente adicional no existe activo en otro nucleo familiar
  --
  -- --------------------------------------------------------------------------------------------------
  Function IsDepNucleoValido(p_nss_titular sre_ciudadanos_t.id_nss%type,
                             p_nss_dep     sre_ciudadanos_t.id_nss%type)
    Return Boolean

   is

    v_nss_titular sre_ciudadanos_t.id_nss%type;
    v_Resultado   BOOLEAN;

    -- Buscar si el dependiente existe para el titular del nucleo
    -- o para el conjuge del titular
    Cursor ExisteDepTit is
      Select id_nss_titular
        from suirplus.ars_dep_adicionales_t
       where id_nss_dependiente = p_nss_dep -- Dependiente adicional a registrar
         and (
              id_nss_titular = p_nss_titular --Que el trabajador sea el titular del nucleo 
              OR
              NVL(id_nss_conyuge,-1) = p_nss_titular --Que el trabajador sea el conyuge del nucleo
             );
  Begin
    Open ExisteDepTit;
   Fetch ExisteDepTit
    into v_nss_titular;

    v_Resultado := ExisteDepTit%FOUND;

    Close ExisteDepTit;

    Return(v_Resultado);

  End IsDepNucleoValido;

  -- *****************************************************************************************************
  --- *****************************************************************************************************
  -- -----------------------------------------------------------------------------------------------------

  PROCEDURE Novedades_SVDS_Crear(p_RegistroPatronal SRE_EMPLEADORES_T.id_registro_patronal%TYPE,
                                 p_IDNSS            SRE_TRABAJADORES_T.id_nss%TYPE,
                                 p_id_nomina        SRE_NOMINAS_T.id_nomina%TYPE,
                                 p_salarioss        sre_det_movimiento_t.salario_ss%TYPE,
                                 p_UltUsuarioAct    SRE_MOVIMIENTO_T.ult_usuario_act%TYPE,
                                 p_IPAddress        SRE_MOVIMIENTO_T.Ip_Address%TYPE,
                                 p_resultnumber     OUT VARCHAR2) IS
    v_bderror         VARCHAR(1000);
    v_IDMovimiento    SRE_MOVIMIENTO_T.id_movimiento%TYPE;
    v_IDLinea         SRE_DET_MOVIMIENTO_T.id_linea%TYPE;
    v_periodo_vigente VARCHAR(6);

  BEGIN

    v_periodo_vigente := Parm.periodo_vigente;
    -- v_RegPatAgRetencion := SRE_EMPLEADORES_PKG.get_registropatronal(p_AgenteRetencionIsr);

    --Validacion de los parametros nulos.
    IF (p_id_nomina IS NULL) OR (p_IDNSS IS NULL) OR
       (p_UltUsuarioAct IS NULL) OR (p_salarioss IS NULL) THEN
      RAISE e_ParametrosNulos;
    END IF;

    --Validacion del registro patronal
    IF NOT Sre_Empleadores_Pkg.Existeregistropatronal(p_RegistroPatronal) THEN
      RAISE e_InvalidRegistropatronal;
    END IF;

    --Validacion de la nomina
    IF NOT Sre_Nominas_Pkg.isNominaValida(p_RegistroPatronal, p_id_nomina) THEN
      RAISE e_InvalidNomina;
    END IF;

    --Validacion del NSS
    IF NOT Srp_Pkg.Existenss(p_IDNSS) THEN
      RAISE e_IvalidNSS;
    END IF;

    /*  -- Existe en trabajadores.(8)
    IF NOT isExisteTrabajador(p_IDNSS, p_RegistroPatronal, p_id_nomina)THEN
       RAISE e_InvalidExisteTrabajador;
    END IF;*/

    --Validacion del usuario
    IF NOT Seg_Usuarios_Pkg.isExisteUsuario(p_UltUsuarioAct) THEN
      RAISE e_invaliduser;
    END IF;

    -- Movimiento

    v_IDMovimiento := get_id_movimiento(p_RegistroPatronal,
                                        p_UltUsuarioAct,
                                        'CCI',
                                        p_UltUsuarioAct,
                                        p_IPAddress);
    v_IDLinea      := Get_Id_Linea(v_IDMovimiento);

    INSERT INTO SRE_DET_MOVIMIENTO_T
      (id_movimiento,
       id_linea,
       SALARIO_SS,
       id_nss,
       id_nomina,
       periodo_aplicacion,
       ult_fecha_act,
       ult_usuario_act)
    VALUES
      (v_IDMovimiento,
       v_IDLinea,
       p_salarioss,
       p_IDNSS,
       p_id_nomina,
       v_periodo_vigente,
       SYSDATE,
       p_UltUsuarioAct);

    COMMIT;

    sre_load_movimiento_pkg.someter_movimiento_web(v_IDMovimiento);

    p_ResultNumber := 0;

  EXCEPTION

    WHEN e_InvalidNomina THEN
      p_ResultNumber := Seg_Retornar_Cadena_Error(155, NULL, NULL);
      RETURN;

    /* WHEN e_IvalidFecha THEN
    p_ResultNumber := Seg_Retornar_Cadena_Error(168, NULL, NULL);
    RETURN;   */

    WHEN e_InvalidRegistropatronal THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(3, NULL, NULL);
      RETURN;

    WHEN e_InvalidTrabajador THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(170, NULL, NULL);
      RETURN;

    WHEN e_InvalidMovPendiente THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(169, NULL, NULL);
      RETURN;

    WHEN e_IvalidNSS THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(24, NULL, NULL);
      RETURN;
      /*
      WHEN e_InvalidAgenteRetencion THEN
          p_resultnumber := Seg_Retornar_Cadena_Error(161, NULL, NULL);
          RETURN;*/

    WHEN e_InvalidExisteTrabajador THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(514, NULL, NULL);
      RETURN;

    WHEN e_InvalidUser THEN
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

  -- **************************************************************************************************
  -- FUNCION:     function PuedeRegistrarNovedades
  -- DESCRIPCION: Verifica si el empleador puede realizar novedades interactivas
  -- **************************************************************************************************
  procedure PuedeRegistrarNovedades(p_registro_patronal varchar2,
                                    p_resultnumber      out varchar2) is
    v_count  number;
    v_limite number;
  Begin
    p_resultnumber := Seg_Retornar_Cadena_Error(801, NULL, NULL);

    select count(t.id_nss)
      into v_count
      from sre_trabajadores_t t
     where t.id_registro_patronal = p_registro_patronal
       and t.status = 'A';

    Select d.valor_numerico
      Into v_limite
      From Sfc_Det_Parametro_t d
     Inner Join Sfc_Parametros_t p
        On d.Id_Parametro = p.Id_Parametro
     Where d.Id_Parametro = 370;

    if v_count < v_limite then
      p_resultnumber := '0';
    end if;

  End PuedeRegistrarNovedades;

/*-- *****************************************************************************************************
    -- Function :   isDependienteDelTitular
    -- Descripcion: Verifica que un dependiente adicional existe en cobertura para un titular especificado
    --
    -- --------------------------------------------------------------------------------------------------
    Function isDependienteDelTitular(
           p_nss_titular sre_ciudadanos_t.id_nss%type,
           p_nss_dep sre_ciudadanos_t.id_nss%type) Return Boolean

    is

    v_nss_titular    sre_ciudadanos_t.id_nss%type;
    v_Resultado      BOOLEAN;

    Cursor ExisteTitular is
          Select nss_titular
          from tss_dependientes_ok_pe_mv
          where nss_titular =  p_nss_titular
          and nss_dependiente = p_nss_dep;

    Cursor ExisteConyugue is
          Select c.nss_titular
          from tss_dependientes_ok_pe_mv c
          where c.nss_dependiente = p_nss_titular
          and c.cve_parentesco in(3,4,20);

    Begin
         Open ExisteTitular;
           Fetch ExisteTitular into v_nss_titular;
           v_Resultado := ExisteTitular%FOUND;
           Close ExisteTitular;

           if not(v_Resultado) then
             Open ExisteConyugue;
               Fetch ExisteConyugue into v_nss_titular;
               v_Resultado := ExisteConyugue%FOUND;
               Close ExisteConyugue;
           end if;

           Return(v_Resultado);

    End isDependienteDelTitular;*/

----------------------------------------------------------------------------------------------------------------------
--EVALLEJO - 2/6/2014
--Metodo Creado para el registro de la novedad de discapacitados por enfermedad no Laboral
-- -----------------------------------------------------------------------------------------------------
    PROCEDURE Novedades_enf_Nolaboral(p_id_RegistroPatronal SRE_EMPLEADORES_T.id_registro_patronal%TYPE,
                                      p_id_Nomina           SRE_NOMINAS_T.id_nomina%TYPE,
                                      p_id_NSS              SRE_TRABAJADORES_T.id_nss%TYPE,
                                      p_SalarioSS           SRE_DET_MOVIMIENTO_T.salario_ss%TYPE,
                                      p_AporteVoluntario    SRE_DET_MOVIMIENTO_T.aporte_voluntario%TYPE,
                                      p_SalarioIsr          SRE_DET_MOVIMIENTO_T.salario_isr%TYPE,
                                      p_SalarioINF          SRE_DET_MOVIMIENTO_T.Salario_Infotep%TYPE,
                                      p_AgenteRetencionIsr  SRE_EMPLEADORES_T.Rnc_o_Cedula%TYPE,
                                      p_OtrasRemunIsr       SRE_DET_MOVIMIENTO_T.otros_ingresos_isr%TYPE,
                                      p_RemunOtroEmp        SRE_DET_MOVIMIENTO_T.remuneracion_isr_otros%TYPE,
                                      p_FechaIngreso        SRE_DET_MOVIMIENTO_T.fecha_inicio%TYPE,
                                      p_Periodo_desde       sre_det_movimiento_t.periodo_aplicacion%TYPE,
                                      p_Periodo_hasta       sre_det_movimiento_t.sfs_secuencia%TYPE,
                                      p_IngresosExentos     SRE_DET_MOVIMIENTO_T.Ingresos_Exentos_Isr%TYPE,
                                      p_SaldoFavor         SRE_DET_MOVIMIENTO_T.Saldo_Favor_Isr%TYPE,
                                      p_ID_Usuario          SRE_MOVIMIENTO_T.ult_usuario_act%TYPE,
                                      p_tipo_ingreso        number,
                                      p_IPAddress         SRE_MOVIMIENTO_T.Ip_Address%TYPE,
                                      p_ResultNumber        OUT VARCHAR2)

     IS

        v_bderror           VARCHAR(1000);
        v_IDMovimiento      SRE_MOVIMIENTO_T.id_movimiento%TYPE;
        v_IDLinea           SRE_DET_MOVIMIENTO_T.id_linea%TYPE;
        v_RegPatAgRetencion SRE_DET_MOVIMIENTO_T.AGENTE_RETENCION_SS%TYPE;
       -- v_mensaje           varchar(1000);
        v_PeriodoSigue      VARCHAR(6);
        v_facturaPaga       BOOLEAN;
        v_SalarioIsr        VARCHAR(100);
        v_inhabilidad       VARCHAR2(1);
        e_periodoInvalidos exception;
          --cursor c_existeinhabilidad is select tp.tipo_causa into v_inhabilidad from sre_ciudadanos_t tp where tp.id_nss = p_id_NSS;
    BEGIN

        v_SalarioISR      := p_SalarioIsr;

        --Validacion de los parametros nulos.
        IF (p_ID_RegistroPatronal IS NULL) OR (p_ID_Nomina IS NULL) OR
           (p_ID_NSS IS NULL) OR (p_SalarioSS IS NULL) OR
            (p_ID_Usuario IS NULL) OR
           (p_FechaIngreso IS NULL) THEN
            RAISE e_ParametrosNulos;
        END IF;

        --Validacion del registro patronal
        IF NOT Sre_Empleadores_Pkg.Existeregistropatronal(p_id_registroPatronal) THEN
            RAISE e_InvalidRegistropatronal;
        END IF;

        --Validacion de la nomina
        IF NOT Sre_Nominas_Pkg.isNominaValida(p_id_RegistroPatronal,
                                              p_id_nomina) THEN
            RAISE e_InvalidNomina;
        END IF;

        --Validacion del NSS
        IF NOT Srp_Pkg.Existenss(p_id_nss) THEN
            RAISE e_IvalidNSS;
        END IF;

        --Validacion del agente de retencion.(7-A)
        IF (p_AgenteRetencionIsr IS NOT NULL) THEN
                 v_RegPatAgRetencion := Sre_Empleadores_Pkg.get_registropatronal(p_AgenteRetencionIsr);

                 if v_RegPatAgRetencion ='-1' then
                     RAISE e_InvalidAgenteRetencion;
                 end if;

              /*  if NOT Sre_Empleadores_Pkg.isRncOCedulaValida(v_RegPatAgRetencion) and (p_RemunOtroEmp <= 0) THEN
                    RAISE e_InvalidAgenteRetencion;
                end if;*/
        ELSIF (p_AgenteRetencionIsr IS NULL) THEN
            v_RegPatAgRetencion:= NULL;
        END IF;

         -- Fue puesta ultimamente.
        IF (v_RegPatAgRetencion = p_id_RegistroPatronal) AND (p_RemunOtroEmp <= 0)  THEN
            RAISE e_InvalidAgenteIgual;
        END IF;

               -- Fue puesta ultimamente.
        IF (v_RegPatAgRetencion <> p_id_RegistroPatronal) AND (p_RemunOtroEmp <> 0)  THEN
            RAISE e_InvalidAgenteDif;
        END IF;

        --Validacion del usuario
        IF NOT Seg_Usuarios_Pkg.isExisteUsuario(p_ID_Usuario) THEN
            RAISE e_invaliduser;
        END IF;

        if (p_SalarioSS <= 0) and (p_SalarioIsr <= 0) then
          RAISE e_InvalidSalarioSS;
        end if;


        --Verificacion del Salario SS contra el rango permitido.
        IF isSalarioSSValido(p_SalarioSS) = False then
          RAISE e_InvalidSalarioSS;
        end if;

        --Validacion del salario de la seguridad ISR (5).
        IF (p_SalarioIsr <= 0) THEN
            v_SalarioIsr := p_SalarioSS ;
        END IF;

             -- Validacion Remuneracion Otros Empleados, en el caso de que el agente sea el mismo empleador. (7-B)
        IF isAgenteEsEmpleador(v_RegPatAgRetencion,
                               p_id_RegistroPatronal,
                               P_RemunOtroEmp) THEN
            RAISE e_InvalidRemunOtroEmp;
        END IF;

        -- Validacion del Campo Aporte Voluntario, Rango especificado.
        IF isAporteVoluntario(p_AporteVoluntario) THEN
            RAISE e_IvalidAporteVoluntario;
        END IF;

IF isExisteMovPeriodo(p_id_NSS,'PRE',p_id_RegistroPatronal,p_Periodo_desde, p_Periodo_hasta)= false THEN
   RAISE e_periodoInvalidos;
END IF;



    v_IDMovimiento    := get_id_movimiento(p_ID_RegistroPatronal,
                                               p_ID_Usuario,
                                               'PRE',
                                               p_ID_Usuario,p_IPAddress);
    v_IDLinea         := Get_Id_Linea(v_IDMovimiento);


        INSERT INTO SRE_DET_MOVIMIENTO_T
            (id_movimiento,
             id_linea,
             agente_retencion_isr,
             id_nss,
             id_tipo_novedad,
             id_nomina,
             PERIODO_APLICACION,/*En esta novedad es utilizado para almacenar la fecha desde*/
             SFS_SECUENCIA,/*En esta novedad es utilizado para almacenar la fecha hasta*/
             fecha_inicio,
             aporte_voluntario,
             otros_ingresos_isr,
             remuneracion_isr_otros,
             salario_isr,
             SALARIO_INFOTEP,
             SALARIO_SS,
             Ingresos_Exentos_Isr,
             Saldo_Favor_Isr,
             ult_fecha_act,
             ult_usuario_act,
             cod_ingreso--se usa para almacenar el tipo de ingreso para esta novedad
             )
        VALUES
            (v_IDMovimiento,
             v_IDLinea,
             v_RegPatAgRetencion,
             p_id_NSS,
             'IN',
             p_id_Nomina,
             p_Periodo_desde,
             p_Periodo_hasta,
             p_FechaIngreso,
             p_AporteVoluntario,
             p_OtrasRemunIsr,
             p_RemunOtroEmp,
             p_SalarioIsr,
             p_SalarioINF,
             p_salarioss,
             p_IngresosExentos,
             p_SaldoFavor,
             SYSDATE,
             p_ID_Usuario,
             p_tipo_ingreso
             );

        p_ResultNumber := 0;
        COMMIT;

    EXCEPTION

        WHEN e_InvalidRegistropatronal THEN
            p_resultnumber := Seg_Retornar_Cadena_Error(3, NULL, NULL);
            RETURN;

        WHEN e_InvalidAgenteIgual THEN
            p_resultnumber := Seg_Retornar_Cadena_Error(211, NULL, NULL);
            RETURN;

        WHEN e_InvalidAgenteDif THEN
            p_resultnumber := Seg_Retornar_Cadena_Error(212, NULL, NULL);
            RETURN;


        WHEN e_InvalidNomina THEN
            p_ResultNumber := Seg_Retornar_Cadena_Error(155, NULL, NULL);
            RETURN;

        WHEN e_IvalidNSS THEN
            p_resultnumber := Seg_Retornar_Cadena_Error(24, NULL, NULL);
            RETURN;

        WHEN e_InvalidAgenteRetencion THEN
            p_resultnumber := Seg_Retornar_Cadena_Error(161, NULL, NULL);
            RETURN;

        WHEN e_InvalidUser THEN
            p_resultnumber := Seg_Retornar_Cadena_Error(1, NULL, NULL);
            RETURN;

        WHEN e_InvalidSalarioSS THEN
            p_resultnumber := Seg_Retornar_Cadena_Error(156, NULL, NULL);
            RETURN;

         WHEN e_InvalidMovPendiente THEN
            p_resultnumber := Seg_Retornar_Cadena_Error(169, NULL, NULL);
            RETURN;

        WHEN e_InvalidRemunOtroEmp THEN
            p_resultnumber := Seg_Retornar_Cadena_Error(160, NULL, NULL);
            RETURN;

        WHEN e_IvalidAporteVoluntario THEN
            p_resultnumber := Seg_Retornar_Cadena_Error(157, NULL, NULL);
            RETURN;

        WHEN e_InvalidRemuneracionIsr THEN
            p_resultnumber := Seg_Retornar_Cadena_Error(513, NULL, NULL);
            RETURN;

        WHEN e_InvalidNovedad THEN
            p_resultnumber := Seg_Retornar_Cadena_Error(166, NULL, NULL);
            RETURN;

        WHEN e_ParametrosNulos THEN
            p_ResultNumber := Seg_Retornar_Cadena_Error(8, NULL, NULL);
            RETURN;

         WHEN e_InvalidInhabilidad THEN
            p_ResultNumber := Seg_Retornar_Cadena_Error(651, NULL, NULL);
            RETURN;
        WHEN e_periodoInvalidos THEN
            p_ResultNumber := Seg_Retornar_Cadena_Error(87, NULL, NULL);
        RETURN;


        WHEN OTHERS THEN
            v_bderror      := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                      SQLERRM,
                                      1,
                                      255));
            p_resultnumber := Seg_Retornar_Cadena_Error(-1,
                                                        v_bderror,
                                                        SQLCODE);
            RETURN;

    END Novedades_enf_Nolaboral;

 -- *****************************************************************************************************
 /*
   EVALLEJO - 2/7/2014
   Metodo Creado para aplicar el registro de la novedad de discapacitados por enfermedad no Labora
 */
 -- --------------------------------------------------------------------------------------------------
  procedure Aplicar_mov_enf_nolaboral(p_id_RegistroPatronal SRE_EMPLEADORES_T.id_registro_patronal%TYPE,
                                      p_ID_Usuario SRE_MOVIMIENTO_T.ult_usuario_act%TYPE) is
  resultado boolean;
  g_return          varchar(1000);
  g_errorseq        varchar(1000);
  begin
    for nolaboral in (select *
                           from sre_movimiento_t a
                          where a.id_registro_patronal = p_id_RegistroPatronal
                            and a.status = 'N'
                            and a.id_tipo_movimiento = 'PRE'
                          order by id_movimiento) loop


  resultado := Sfc_Opera_Movimiento_F(g_return, g_errorseq, nolaboral.id_movimiento,
  null, nolaboral.id_registro_patronal, nolaboral.id_tipo_movimiento,
  nolaboral.periodo_factura,p_ID_Usuario);

 if resultado = true then
  commit;
  update sre_movimiento_t t set t.status = 'P' where t.id_movimiento = nolaboral.id_movimiento;

 end if;

    end loop;
end;

/*Funcion que verifica si existe un movimiento con periodos iguales para un mismo regPatronal, Nss, Novedad 'PRE'*/
  FUNCTION isExisteMovPeriodo(p_id_nss               SRE_TRABAJADORES_T.id_nss%TYPE,
                              p_id_tipo_movimiento   SRE_MOVIMIENTO_T.ID_TIPO_MOVIMIENTO%TYPE,
                              p_id_registro_patronal SRE_REPRESENTANTES_T.id_registro_patronal%TYPE,
                              p_periodo_desde sre_det_movimiento_t.periodo_aplicacion%type,
                              p_periodo_hasta sre_det_movimiento_t.sfs_secuencia%type)
    RETURN BOOLEAN IS

    v_is_valido           BOOLEAN;
    v_movimiento          VARCHAR(50);
    c_cursor  t_cursor;
    v_registros Integer := 0;



BEGIN


SELECT count(*)
  into v_registros
  FROM SRE_DET_MOVIMIENTO_T t, SRE_MOVIMIENTO_T m
 WHERE m.id_movimiento = t.id_movimiento
   AND t.id_nss = p_id_nss
   AND m.id_tipo_movimiento = p_id_tipo_movimiento
   AND m.id_registro_patronal = p_id_registro_patronal
   AND m.status = 'N'
/*   AND ((t.periodo_aplicacion <= p_periodo_desde and t.sfs_secuencia >= p_periodo_hasta) OR
       (t.periodo_aplicacion >= p_periodo_desde and t.sfs_secuencia >= p_periodo_hasta) OR
       (t.periodo_aplicacion <= p_periodo_desde and t.sfs_secuencia <= p_periodo_hasta) OR
       (t.periodo_aplicacion >= p_periodo_desde and t.sfs_secuencia <= p_periodo_hasta));
*/
  AND (
         (t.periodo_aplicacion <= p_periodo_desde and t.sfs_secuencia >= p_periodo_hasta)
         or
         (t.periodo_aplicacion <= p_periodo_hasta and t.sfs_secuencia >= p_periodo_desde)
       );

If (v_registros = 0) Then
 v_is_valido:= true;
ELSE
v_is_valido:= false;
End If;

  RETURN(v_is_valido);
END isExisteMovPeriodo;


END Sre_Novedades_Pkg;
