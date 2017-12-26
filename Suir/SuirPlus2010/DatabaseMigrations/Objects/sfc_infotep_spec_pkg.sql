create or replace package suirplus.sfc_infotep_pkg is

  -- Author  : GREGORIO_HERRERA
  -- Created : 3/1/2007 9:04:22 AM
  -- Purpose : Para incluir todos los procedimientos y funciones para el manejo de los procesos de INFOTEP
  
  -- Public type declarations
  type t_cursor is ref cursor;
  
  
  -- Objetivo: Verificar en la tabla de facturas de INFOTEP si hay una factura de bonificacion creada para el RNC y periodo que se envia con estatus PA o con un Nro. De Autorizacion.
  -- Autor: Gregorio U. Herrera
  -- Fecha: 01/03/2007
  Procedure ExisteFactBonificacion(p_rnc_o_cedula in sre_empleadores_t.rnc_o_cedula%type,
                                   p_periodo sfc_facturas_t.periodo_factura%type,
                                   p_result out char);
                                   
                                   
-- **************************************************************************************************
-- Program:     Liquidacion_NoEnvio_Inf
-- Description: Utilizado para consulta de liquidacion del Infotep
-- **************************************************************************************************

    PROCEDURE Liquidacion_NoEnvio_Inf(
        p_idrecepcion         IN SRE_DET_MOVIMIENTO_RECAUDO_T.id_recepcion%TYPE,
        p_resultnumber        OUT VARCHAR2,
        p_iocursor            IN OUT t_cursor);   
        
--**************************************************************************************************
-- Program:  Get_DetallesRecaudacionPago
-- Description:
--**************************************************************************************************
    PROCEDURE Get_DetallesRecaudacionPago (
        p_identidad_rec     IN SRE_ARCHIVOS_T.id_entidad_recaudadora%TYPE,
        p_fechaini          IN DATE,
        p_fechafin          IN DATE,
        p_iocursor          IN OUT t_cursor,
        p_resultnumber      OUT VARCHAR2);
        
--*************************************************************
-- Conocer la cantidad total de Pagos.
--*************************************************************
    procedure get_cuenta_pagos( 
        p_entidad sfc_liquidacion_isr_v.ID_REFERENCIA_ISR%type,
        p_fechaini          IN DATE,
        p_fechafin          IN DATE,
        p_result_number out varchar,
        io_cursor       out t_cursor);
                            
--*************************************************************
-- Conocer la cantidad total de Aclaraciones.
--*************************************************************
    procedure get_cuenta_aclaraciones( 
        p_entidad sfc_liquidacion_isr_v.ID_REFERENCIA_ISR%type,
        p_fechaini          IN DATE,
        p_fechafin          IN DATE,
        p_result_number out varchar,
        io_cursor       out t_cursor);
        
-- **************************************************************************************************
-- Program:  Get_ResumenRecaudacion
-- Description:
-- **************************************************************************************************          
               
    PROCEDURE Get_ResumenRecaudacion(
        p_fechaini      IN DATE,
        p_fechafin      IN DATE,
        p_requerimiento IN VARCHAR,
        p_iocursor      IN OUT t_cursor,
        p_resultnumber  OUT VARCHAR2);
        
        
-- **************************************************************************************************
-- Program:  Resumen Aclaraciones Pendientes
-- Description: Trae el todas las aclaraciones pendientes existentes.
-- **************************************************************************************************        

    PROCEDURE Get_Aclaraciones (
        p_iocursor       IN OUT t_cursor,
        p_resultnumber   OUT VARCHAR2); 
        
-- **************************************************************************************************
-- Program:  Get_DetallesAclaraciones
-- Description:Trae el detalle de las aclaraciones pendientes por banco
-- **************************************************************************************************
PROCEDURE Get_DetallesAclaraciones (
        p_identidad_rec     IN SRE_ARCHIVOS_T.id_entidad_recaudadora%TYPE,
        p_iocursor          IN OUT t_cursor,
        p_resultnumber      OUT VARCHAR2);                                                                                                               
-- **************************************************************************************************
-- Program:  validarLiquidacion
-- Description:Verifica el status de una liquidacion de infotep
-- **************************************************************************************************
function validarLiquidacion(p_liquidacion in sfc_liquidacion_infotep_t.id_referencia_infotep%type) RETURN VARCHAR;

-- **************************************************************************************************
-- Program:  MarcarPagada
-- Description:Para marcar una liquidacion como pagada
--Autor: Eury Vallejo
-- **************************************************************************************************
procedure MarcarPagada(p_usuario in seg_usuario_t.id_usuario%type,
                       p_liquidacion in sfc_liquidacion_infotep_t.id_referencia_infotep%type,
                       p_fecha_pago in sfc_liquidacion_infotep_t.fecha_pago%type,
                       p_entidad_recaudadora in sfc_liquidacion_infotep_t.id_entidad_recaudadora%type,
                       p_resultado OUT VARCHAR2);
                       
-- **************************************************************************************************
-- Program:  MarcarCancelada
-- Description:Para marcar una liquidacion como Cancelada
--Autor: Eury Vallejo
-- **************************************************************************************************
procedure MarcarCancelada(p_usuario in seg_usuario_t.id_usuario%type,
                       p_liquidacion in sfc_liquidacion_infotep_t.id_referencia_infotep%type,
                       p_resultado OUT VARCHAR2);
                       
-- **************************************************************************************************
-- Program:  PagaINFOTEP
-- Description:Para marcar una empresa, indicando que paga infotep
--Autor: Eury Vallejo
-- **************************************************************************************************
procedure PagaInfotep(p_usuario in seg_usuario_t.id_usuario%type,
                       p_rnc in sre_empleadores_t.rnc_o_cedula%type,
                       p_resultado OUT VARCHAR2);
                       
-- **************************************************************************************************
-- Program:  NoPagaINFOTEP
-- Description:Para marcar una empresa, indicando que No paga infotep
--Autor: Eury Vallejo
-- **************************************************************************************************
procedure NoPagaInfotep(p_usuario in seg_usuario_t.id_usuario%type,
                       p_rnc in sre_empleadores_t.rnc_o_cedula%type,
                       p_resultado OUT VARCHAR2);   
                                   
end sfc_infotep_pkg;