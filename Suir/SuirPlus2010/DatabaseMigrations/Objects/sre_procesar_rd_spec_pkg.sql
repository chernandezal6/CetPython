CREATE OR REPLACE PACKAGE SUIRPLUS.SRE_PROCESAR_RD_PKG IS
  -- Author  : ROBERTO_JAQUEZ
  -- Created : 06/05/2005 10:48:10 a.m.
  -- Purpose : Procesamiento de Archivos de Registro de Dependientes

  h_RNC         varchar2(011);
  v_fecha_fac   date;
  v_periodo_fac number(6);

  procedure procesar;
  function pre_validaciones return boolean;
  procedure head_statement;
  procedure body_statement;
  procedure foot_statement;

  procedure crear_movimiento_dependientes(pId_recepcion    in number,
                                          pPeriodo_factura in number,
                                          pMovimiento      out number);

  procedure Validar_Dependiente(pTipo_mov             in varchar2,
                                pId_Registro_Patronal in number,
                                pId_Nomina            in number,
                                pId_Nss_Titular       in number,
                                pId_Nss_Dependiente   in number,
                                pResult               out varchar2);

  procedure procesar_rd(p_recepcion IN sre_archivos_t.id_recepcion%TYPE);

END;
