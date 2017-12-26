CREATE OR REPLACE PACKAGE SUIRPLUS.SRE_NOVEDADES_PKG IS

  -- *****************************************************************************************************
  -- program:     SRE_NOVEDADES_PKG
  -- descripcion: procedimientos y funciones
  --
  -- modification historyL
  -- -----------------------------------------------------------------------------------------------------
  -- date         by              remark
  -- -----------------------------------------------------------------------------------------------------
  -- 11/23/2004 Ronny Carreras  creation
  -- *****************************************************************************************************
  v_FacturaPaga BOOLEAN;
  TYPE t_cursor IS REF CURSOR;
  e_InvalidMovimiento EXCEPTION;
  e_InvalidTipoMovimiento EXCEPTION;
  e_InvalidTipoNovedad EXCEPTION;
  e_InvalidRegistropatronal EXCEPTION;
  e_InvalidUser EXCEPTION;
  e_IvalidNSS EXCEPTION;
  e_IvalidFecha EXCEPTION;
  e_InvalidRepresentante EXCEPTION;
  e_InvalidMovPendiente EXCEPTION;
  e_InvalidNomina EXCEPTION;
  e_InvalidSalarioSS EXCEPTION;
  e_InvalidTrabajador EXCEPTION;
  e_InvalidDepTrabajador EXCEPTION;
  e_IvalidAporteVoluntario EXCEPTION;
  e_InvalidSalarioISR EXCEPTION;
  e_InvalidOtrasRemunIsr EXCEPTION;
  e_InvalidRemunOtroEmp EXCEPTION;
  e_InvalidAgenteRetencion EXCEPTION;
  e_InvalidRemuneracionIsr EXCEPTION;
  e_InvalidExisteTrabajador EXCEPTION;
  e_ParametrosNulos EXCEPTION;
  e_FacturaAutorizadaNoPaga EXCEPTION;
  e_InvalidNovedad EXCEPTION;
  e_InvalidInhabilidad EXCEPTION;
  e_InvalidAgenteIgual EXCEPTION;
  e_InvalidAgenteDif EXCEPTION;
  e_InvalidDependiente EXCEPTION;
  e_DependienteTitular EXCEPTION;
  e_InvalidTitular EXCEPTION;
  e_InvalidDepTitularAC EXCEPTION;
  e_InvalidDepNucleo EXCEPTION;

  FUNCTION Get_ID_Movimiento(p_RegistroPatronal  SRE_EMPLEADORES_T.id_registro_patronal%TYPE,
                             p_Usuario           SRE_MOVIMIENTO_T.id_usuario%TYPE,
                             p_id_TipoMovimiento SRE_MOVIMIENTO_T.id_tipo_movimiento%TYPE,
                             p_UltUsuarioAct     SRE_MOVIMIENTO_T.ult_usuario_act%TYPE,
                             p_IPAddress         SRE_MOVIMIENTO_T.Ip_Address%TYPE)
    RETURN NUMBER;

  FUNCTION Get_Id_Linea(p_id_movimiento SRE_MOVIMIENTO_T.id_movimiento%TYPE)
    RETURN NUMBER;

  Function get_id_linea_enf(p_id_movimiento SRE_MOVIMIENTO_T.id_movimiento%TYPE)
    Return Number;

  FUNCTION isTipoNovedadValido(p_id_TipoNovedad SRE_DET_MOVIMIENTO_T.id_tipo_novedad%TYPE)
    RETURN BOOLEAN;

  FUNCTION isFacturaDelPeriodoPaga(p_id_registro_patronal SRE_EMPLEADORES_T.id_registro_patronal%TYPE,
                                   p_id_nomina            SRE_NOMINAS_T.id_nomina%TYPE,
                                   p_PeriodoFactura       SFC_FACTURAS_T.PERIODO_FACTURA%TYPE)
    RETURN BOOLEAN;

  FUNCTION isLiquidacionDelPeriodoPaga(p_id_registro_patronal SRE_EMPLEADORES_T.id_registro_patronal%TYPE,
                                       p_id_nomina            SRE_NOMINAS_T.id_nomina%TYPE,
                                       p_PeriodoLiquidacion   SFC_LIQUIDACION_ISR_T.PERIODO_LIQUIDACION%TYPE)
    RETURN BOOLEAN;

  FUNCTION isFacturaAutorizadaNoPaga(p_id_registro_patronal SRE_EMPLEADORES_T.id_registro_patronal%TYPE,
                                     p_PeriodoFactura       SFC_FACTURAS_T.periodo_factura%TYPE,
                                     p_id_nomina            SFC_FACTURAS_T.ID_NOMINA%TYPE)
    RETURN BOOLEAN;

  FUNCTION isLiquidacionAutorizadaNoPaga(p_id_registro_patronal SRE_EMPLEADORES_T.id_registro_patronal%TYPE,
                                         p_PeriodoLiquidacion   SFC_LIQUIDACION_ISR_T.PERIODO_LIQUIDACION%TYPE,
                                         p_id_nomina            SFC_FACTURAS_T.ID_NOMINA%TYPE)
    RETURN BOOLEAN;

  FUNCTION isAgenteEsEmpleador(p_agente_retencion_isr SRE_EMPLEADORES_T.id_registro_patronal%TYPE,
                               p_id_registro_patronal SRE_EMPLEADORES_T.ID_REGISTRO_PATRONAL%TYPE,
                               P_RemunOtroEmp         SRE_DET_MOVIMIENTO_T.REMUNERACION_ISR_OTROS%TYPE)
    RETURN BOOLEAN;

  FUNCTION isAporteVoluntario(p_AporteVoluntario SRE_DET_MOVIMIENTO_T.aporte_voluntario%TYPE)
    RETURN BOOLEAN;

  FUNCTION getPeriodoSiguiente(p_periodo_vigente IN VARCHAR,
                               v_FacturaPaga     IN BOOLEAN) RETURN VARCHAR2;

  FUNCTION isAgenteExtranjero(p_id_nss SRE_CIUDADANOS_T.ID_NSS%TYPE)
    RETURN BOOLEAN;
  FUNCTION isDependienteValido(p_id_RegistroPatronal SRE_EMPLEADORES_T.id_registro_patronal%TYPE,
                               p_id_Nomina           SRE_NOMINAS_T.id_nomina%TYPE,
                               p_id_NSS              SRE_TRABAJADORES_T.id_nss%TYPE,
                               p_id_NSS_Dependiente  SRE_TRABAJADORES_T.id_nss%TYPE)
    RETURN BOOLEAN;

  FUNCTION isMovimientoValido(p_id_movimiento SRE_MOVIMIENTO_T.id_movimiento%TYPE)
    RETURN BOOLEAN;

  FUNCTION isTipoMovimientoValido(p_id_TipoMovimiento SRE_MOVIMIENTO_T.id_tipo_movimiento%TYPE)
    RETURN BOOLEAN;

  FUNCTION isActivoTrabajadores(p_id_nss               SRE_TRABAJADORES_T.id_nss%TYPE,
                                p_id_registro_patronal SRE_EMPLEADORES_T.ID_REGISTRO_PATRONAL%TYPE,
                                p_id_nomina            SRE_TRABAJADORES_T.id_nomina%TYPE)
    RETURN BOOLEAN;

  FUNCTION isInactivoTrabajadores(p_id_nss               SRE_TRABAJADORES_T.id_nss%TYPE,
                                  p_id_registro_patronal SRE_EMPLEADORES_T.ID_REGISTRO_PATRONAL%TYPE,
                                  p_id_nomina            SRE_TRABAJADORES_T.id_nomina%TYPE)
    RETURN BOOLEAN;

  FUNCTION isExisteMovimiento(p_id_nss               SRE_TRABAJADORES_T.id_nss%TYPE,
                              p_id_registro_patronal SRE_REPRESENTANTES_T.id_registro_patronal%TYPE,
                              p_id_tipo_novedad      SRE_DET_MOVIMIENTO_T.Id_Tipo_Novedad%TYPE,
                              p_id_nomina            SRE_TRABAJADORES_T.id_nomina%TYPE)
    RETURN BOOLEAN;

  FUNCTION isExisteMovimiento(p_id_nss               SRE_TRABAJADORES_T.id_nss%TYPE,
                              p_id_nss_dependiente   SRE_TRABAJADORES_T.id_nss%TYPE,
                              p_id_registro_patronal SRE_REPRESENTANTES_T.id_registro_patronal%TYPE,
                              p_id_tipo_novedad      SRE_DET_MOVIMIENTO_T.Id_Tipo_Novedad%TYPE,
                              p_id_nomina            SRE_TRABAJADORES_T.id_nomina%TYPE)
    RETURN BOOLEAN;

  /*-----------------------------------------------------------------------
  Objetivo: Funcion que verifica el Salario SS para validar los rangos en el cual debe estar dicho Salario.
  Autor   : Yacell Borges
  Fecha   : 24-08-2011
  --------------------------------------------------------------------------*/
  Function isSalarioSSValido(p_SalarioSS varchar2) return boolean;

  PROCEDURE Borrar_Novedad(p_IDMovimiento SRE_MOVIMIENTO_T.id_movimiento%TYPE,
                           p_IDLinea      SRE_DET_MOVIMIENTO_T.id_linea%TYPE,
                           p_resultnumber OUT VARCHAR2);

  PROCEDURE Aplicar_Movimientos(p_id_registro_patronal SRE_EMPLEADORES_T.id_registro_patronal%TYPE,
                                p_Usuario              SRE_MOVIMIENTO_T.ult_usuario_act%TYPE,
                                p_resultnumber         OUT VARCHAR2);

  /*PROCEDURE get_Novedades_Pendientes(p_id_registro_patronal SRE_EMPLEADORES_T.id_registro_patronal%TYPE,
  p_id_Usuario           SEG_USUARIO_T.id_usuario%TYPE,
  p_id_TipoMovimiento    SRE_MOVIMIENTO_T.id_tipo_movimiento%TYPE,
  p_id_TipoNovedad       SRE_DET_MOVIMIENTO_T.id_tipo_novedad%TYPE,
  p_io_cursor            OUT t_cursor,
  p_resultnumber         OUT VARCHAR2);*/
  PROCEDURE get_Novedades_Pendientes(p_id_registro_patronal SRE_EMPLEADORES_T.id_registro_patronal%TYPE,
                                     p_id_Usuario           SEG_USUARIO_T.id_usuario%TYPE,
                                     p_id_TipoMovimiento    SRE_MOVIMIENTO_T.id_tipo_movimiento%TYPE,
                                     p_id_TipoNovedad       SRE_DET_MOVIMIENTO_T.id_tipo_novedad%TYPE,
                                     p_categoria            SRE_TIPO_NOVEDAD_T.CATEGORIA%TYPE,
                                     p_io_cursor            OUT t_cursor,
                                     p_resultnumber         OUT VARCHAR2);

  procedure getNovedadesPendientesSFS(p_id_registro_patronal SRE_EMPLEADORES_T.id_registro_patronal%TYPE,
                                      p_io_cursor            OUT t_cursor,
                                      p_resultnumber         OUT VARCHAR2);

  PROCEDURE get_Dependientes(p_id_registro_patronal SRE_EMPLEADORES_T.id_registro_patronal%TYPE,
                             p_id_Nomina            SRE_NOMINAS_T.id_nomina%TYPE,
                             p_id_NSS               SRE_TRABAJADORES_T.id_nss%TYPE,
                             p_io_cursor            OUT t_cursor,
                             p_resultnumber         OUT VARCHAR2);

  /*-- **************************************************************************************************
  -- Program:     Get_Parentesco
  -- Description: para traer el parentesco para los dependientes adicionales
  -- **************************************************************************************************

      PROCEDURE Get_Parentesco(
          p_idParentesco        IN ars_parentescos_t.id_parentesco%TYPE,
          p_sexoDepAdicional    in ars_parentescos_t.sexo%TYPE,
          p_iocursor            IN OUT t_cursor,
          p_resultnumber        OUT VARCHAR2);

    -- **************************************************************************************************
  -- Function:     Function isExisteParentesco
  -- DESCRIPCION:       Funcion que retorna la existencia de un Parentesco.
  --                     Recibe : el parametro p_idParentessco.
  --                     Devuelve: un valor booleano (0,1) . 0 = no existe  1 = existe

  -- **************************************************************************************************
      function isExisteParentesco(p_idParentesco varchar2) return boolean; */

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
                                    p_ResultNumber        OUT VARCHAR2);

  PROCEDURE Novedades_Ingreso_Dep_Crear(p_id_RegistroPatronal SRE_EMPLEADORES_T.id_registro_patronal%TYPE,
                                        p_id_Nomina           SRE_NOMINAS_T.id_nomina%TYPE,
                                        p_id_NSS              SRE_TRABAJADORES_T.id_nss%TYPE,
                                        p_id_NSS_Dependiente  SRE_TRABAJADORES_T.id_nss%TYPE,
                                        p_ID_Usuario          SRE_MOVIMIENTO_T.ult_usuario_act%TYPE,
                                        p_IPAddress           SRE_MOVIMIENTO_T.Ip_Address%TYPE,
                                        p_ResultNumber        OUT VARCHAR2);

  PROCEDURE Novedades_Baja_Dep_Crear(p_id_RegistroPatronal SRE_EMPLEADORES_T.id_registro_patronal%TYPE,
                                     p_id_Nomina           SRE_NOMINAS_T.id_nomina%TYPE,
                                     p_id_NSS              SRE_TRABAJADORES_T.id_nss%TYPE,
                                     p_id_NSS_Dependiente  SRE_TRABAJADORES_T.id_nss%TYPE,
                                     p_ID_Usuario          SRE_MOVIMIENTO_T.ult_usuario_act%TYPE,
                                     p_IPAddress           SRE_MOVIMIENTO_T.Ip_Address%TYPE,
                                     p_ResultNumber        OUT VARCHAR2);

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
                                     p_resultnumber        OUT VARCHAR2);

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
                                   p_FechaEgreso         SRE_DET_MOVIMIENTO_T.fecha_inicio%TYPE,
                                   p_ID_Usuario          SRE_MOVIMIENTO_T.ult_usuario_act%TYPE,
                                   p_tipo_ingreso        number,
                                   p_IPAddress           SRE_MOVIMIENTO_T.Ip_Address%TYPE,
                                   p_ResultNumber        OUT VARCHAR2);

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
                                    p_resultnumber        OUT VARCHAR2);

  PROCEDURE Novedades_Licencia_Crear(p_RegistroPatronal SRE_EMPLEADORES_T.id_registro_patronal%TYPE,
                                     p_IDNSS            SRE_TRABAJADORES_T.id_nss%TYPE,
                                     p_id_nomina        SRE_NOMINAS_T.id_nomina%TYPE,
                                     p_TipoLicencia     SRE_DET_MOVIMIENTO_T.id_tipo_novedad%TYPE,
                                     p_FechaInicio      SRE_DET_MOVIMIENTO_T.fecha_inicio%TYPE,
                                     p_FechaFin         SRE_DET_MOVIMIENTO_T.fecha_fin%TYPE,
                                     --  p_AgenteRetencionIsr  SRE_EMPLEADORES_T.Rnc_o_Cedula%TYPE,
                                     p_UltUsuarioAct SRE_MOVIMIENTO_T.ult_usuario_act%TYPE,
                                     p_IPAddress     SRE_MOVIMIENTO_T.Ip_Address%TYPE,
                                     p_resultnumber  OUT VARCHAR2);

  PROCEDURE Novedades_Licencia_Editar(p_IDMovimiento       SRE_DET_MOVIMIENTO_T.id_movimiento%TYPE,
                                      p_IDLinea            SRE_DET_MOVIMIENTO_T.id_linea%TYPE,
                                      p_IDNSS              SRE_TRABAJADORES_T.id_nss%TYPE,
                                      p_id_nomina          SRE_NOMINAS_T.id_nomina%TYPE,
                                      p_AgenteRetencionIsr SRE_DET_MOVIMIENTO_T.agente_retencion_isr%TYPE,
                                      p_TipoLicencia       SRE_DET_MOVIMIENTO_T.id_tipo_novedad%TYPE,
                                      p_FechaInicio        SRE_DET_MOVIMIENTO_T.fecha_inicio%TYPE,
                                      p_FechaFin           SRE_DET_MOVIMIENTO_T.fecha_fin%TYPE,
                                      p_UltUsuarioAct      SRE_MOVIMIENTO_T.ult_usuario_act%TYPE,
                                      p_resultnumber       OUT VARCHAR2);

  PROCEDURE Novedades_Vacaciones_Crear(p_RegistroPatronal   SRE_EMPLEADORES_T.id_registro_patronal%TYPE,
                                       p_IDNSS              SRE_TRABAJADORES_T.id_nss%TYPE,
                                       p_id_nomina          SRE_NOMINAS_T.id_nomina%TYPE,
                                       p_FechaInicio        SRE_DET_MOVIMIENTO_T.fecha_inicio%TYPE,
                                       p_FechaFin           SRE_DET_MOVIMIENTO_T.fecha_fin%TYPE,
                                       p_AgenteRetencionIsr SRE_DET_MOVIMIENTO_T.agente_retencion_isr%TYPE,
                                       p_UltUsuarioAct      SRE_MOVIMIENTO_T.ult_usuario_act%TYPE,
                                       p_IPAddress          SRE_MOVIMIENTO_T.Ip_Address%TYPE,
                                       p_resultnumber       OUT VARCHAR2);

  PROCEDURE Novedades_Vacaciones_Editar(p_IDMovimiento       SRE_DET_MOVIMIENTO_T.id_movimiento%TYPE,
                                        p_IDLinea            SRE_DET_MOVIMIENTO_T.id_linea%TYPE,
                                        p_IDNSS              SRE_TRABAJADORES_T.id_nss%TYPE,
                                        p_id_nomina          SRE_NOMINAS_T.id_nomina%TYPE,
                                        p_AgenteRetencionIsr SRE_DET_MOVIMIENTO_T.agente_retencion_isr%TYPE,
                                        p_FechaInicio        SRE_DET_MOVIMIENTO_T.fecha_inicio%TYPE,
                                        p_FechaFin           SRE_DET_MOVIMIENTO_T.fecha_fin%TYPE,
                                        p_UltUsuarioAct      SRE_MOVIMIENTO_T.ult_usuario_act%TYPE,
                                        p_resultnumber       OUT VARCHAR2);

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
                                           p_ResultNumber        OUT VARCHAR2);

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
                                           p_resultnumber       OUT VARCHAR2);

  PROCEDURE get_novedades(p_tipo_novedad IN SRE_TIPO_NOVEDAD_T.id_tipo_novedad%TYPE,
                          p_categoria    IN SRE_TIPO_NOVEDAD_T.categoria%TYPE,
                          io_cursor      IN OUT t_cursor);
  -- Procedimiento
  PROCEDURE Get_DatosTrabajadores(p_id_registro_patronal IN SRE_TRABAJADORES_T.id_registro_patronal%TYPE,
                                  p_id_nomina            IN SRE_TRABAJADORES_T.id_nomina%TYPE,
                                  p_id_nss               IN SRE_TRABAJADORES_T.id_nss%TYPE,
                                  p_io_cursor            IN OUT t_cursor);
  -- Funcion que proporciona el Periodo Salvo Favor.
  FUNCTION isPeriodoSaldoFavor(p_id_registro_patronal SRE_EMPLEADORES_T.id_registro_patronal%TYPE,
                               p_id_nomina            SRE_NOMINAS_T.id_nomina%TYPE)
    RETURN VARCHAR;

  -- Procedure para obtener el Periodo del Saldo.
  PROCEDURE Get_PeriodoSaldo(p_id_registro_patronal IN SRE_TRABAJADORES_T.id_registro_patronal%TYPE,
                             p_id_nomina            IN SRE_NOMINAS_T.id_nomina%TYPE,
                             p_resultnumber         OUT VARCHAR2);

  FUNCTION isExisteTrabajador(p_id_nss               SRE_TRABAJADORES_T.id_nss%TYPE,
                              p_id_registro_patronal SRE_EMPLEADORES_T.ID_REGISTRO_PATRONAL%TYPE,
                              p_id_nomina            SRE_TRABAJADORES_T.id_nomina%TYPE)
    RETURN BOOLEAN;

  -- *****************************************************************************************************
  -- Funcion utilizada para verificar si un id_movimiento tiene detalle.
  -- *****************************************************************************************************
  FUNCTION isExisteMovimientoDetalle(p_IDMovimiento SRE_DET_MOVIMIENTO_T.id_movimiento%TYPE)
    RETURN BOOLEAN;

  procedure aplicar_movimientos_pendientes(p_registro_patronal in number);

  -- *****************************************************************************************************
  -- Function :   isTitular
  -- Descripcion: Verifica que un titular o conyugue valido
  --
  -- --------------------------------------------------------------------------------------------------
  Function isTitular_Conyuge(p_nss_titular sre_ciudadanos_t.id_nss%type)
    Return Boolean;

  -- *****************************************************************************************************
  -- Function :   isDependienteTitularAC
  -- Descripcion: validamos que el dependiente adicional que se quiere registrar no exista como titular AC
  -- --------------------------------------------------------------------------------------------------
  Function isDependienteTitularAC(p_nss_dep sre_ciudadanos_t.id_nss%type)
    Return Boolean;

  -- *****************************************************************************************************
  -- Function :   IsDepNucleoValido
  -- Descripcion: Verifica que un dependiente adicional existe activo en otro nucleo familiar
  --
  -- --------------------------------------------------------------------------------------------------
  Function IsDepNucleoValido(p_nss_titular sre_ciudadanos_t.id_nss%type,
                             p_nss_dep     sre_ciudadanos_t.id_nss%type)
    Return Boolean;
  /*    -- *****************************************************************************************************
  -- Function :   isDependienteDelTitular
  -- Descripcion: Verifica que un dependiente adicional existe en cobertura para un titular especificado
  --
  -- --------------------------------------------------------------------------------------------------

  Function isDependienteDelTitular(
         p_nss_titular sre_ciudadanos_t.id_nss%type,
         p_nss_dep sre_ciudadanos_t.id_nss%type) Return Boolean ;*/

  -- *****************************************************************************************************
  --- *****************************************************************************************************
  -- -----------------------------------------------------------------------------------------------------

  PROCEDURE Novedades_SVDS_Crear(p_RegistroPatronal SRE_EMPLEADORES_T.id_registro_patronal%TYPE,
                                 p_IDNSS            SRE_TRABAJADORES_T.id_nss%TYPE,
                                 p_id_nomina        SRE_NOMINAS_T.id_nomina%TYPE,
                                 p_salarioss        sre_det_movimiento_t.salario_ss%TYPE,
                                 p_UltUsuarioAct    SRE_MOVIMIENTO_T.ult_usuario_act%TYPE,
                                 p_IPAddress        SRE_MOVIMIENTO_T.Ip_Address%TYPE,
                                 p_resultnumber     OUT VARCHAR2);

  -- **************************************************************************************************
  -- FUNCION:     function PuedeRegistrarNovedades
  -- DESCRIPCION: Verifica si el empleador puede realizar novedades interactivas
  -- **************************************************************************************************
  procedure PuedeRegistrarNovedades(p_registro_patronal varchar2,
                                    p_resultnumber      out varchar2);

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
                                      p_ResultNumber        OUT VARCHAR2);

-- *****************************************************************************************************
 /*
   EVALLEJO - 2/7/2014
   Metodo Creado para aplicar el registro de la novedad de discapacitados por enfermedad no Labora
 */
 -- --------------------------------------------------------------------------------------------------
  procedure Aplicar_mov_enf_nolaboral(p_id_RegistroPatronal SRE_EMPLEADORES_T.id_registro_patronal%TYPE,
                                      p_ID_Usuario SRE_MOVIMIENTO_T.ult_usuario_act%TYPE);
/**/
/*Funcion que verifica si existe un movimiento con periodos iguales para un mismo regPatronal, Nss, Novedad 'PRE'*/
  FUNCTION isExisteMovPeriodo(p_id_nss               SRE_TRABAJADORES_T.id_nss%TYPE,
                              p_id_tipo_movimiento   SRE_MOVIMIENTO_T.ID_TIPO_MOVIMIENTO%TYPE,
                              p_id_registro_patronal SRE_REPRESENTANTES_T.id_registro_patronal%TYPE,
                              p_periodo_desde sre_det_movimiento_t.periodo_aplicacion%type,
                              p_periodo_hasta sre_det_movimiento_t.sfs_secuencia%type)
                                 Return Boolean;

END Sre_Novedades_Pkg;