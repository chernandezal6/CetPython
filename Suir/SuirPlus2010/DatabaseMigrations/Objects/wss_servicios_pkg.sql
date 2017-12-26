create or replace package suirplus.WSS_Servicios_pkg  is
  -- Author  : CMHA
  -- Public type declarations
  TYPE t_cursor IS REF CURSOR;
  --*************************************************************
  -- Muestra la informacion del afiliado para una empresa en espesifico
  -- by charile pena
  --*************************************************************
  PROCEDURE getAfiliado(p_rnc_o_cedula IN sre_empleadores_t.rnc_o_cedula%type,
                        p_cedula          in sre_ciudadanos_t.no_documento%type,
                        p_iocursor     IN OUT t_cursor,
                        p_resultnumber OUT VARCHAR2);
  --*************************************************************
  -- muestra el historico de descuento del afiliado
  -- create by charile pena
  --*************************************************************
  PROCEDURE getHistoricoDescuento(p_rnc_o_cedula IN sre_empleadores_t.rnc_o_cedula%type,
                                  p_nss IN sre_trabajadores_t.id_nss%type,
                                  p_cedula       in sre_ciudadanos_t.no_documento%type,
                                  p_ano          in varchar2,
                                  p_iocursor     IN OUT t_cursor,
                                  p_resultnumber OUT VARCHAR2);
                                  
  -- **************************************************************************************************
  -- PROCEDURE: ValidarPYMES
  -- DESCRIPTION: Se valida que la empresa este al dia en TSS y la cantidad de trabajadores activos 
  -- DATE: 27/04/2017
  -- BY: Kerlin De La Cruz             
  -- **************************************************************************************************
  PROCEDURE ValidarPYMES(p_rnc_o_cedula  in sel_registro_emp_t.rnc_o_cedula%type, 
                         p_iocursor      IN OUT t_cursor,                            
                         p_resultnumber  out varchar2);
                         
 --------------------------------------------------------------------------------------------------------
  -- PROCEDURE: Get_Tipo_Referencia
  -- DESCRIPTION: Para mostrar los diferentes tipos de referencias
  -- BY: Kerlin de la cruz
  -- DATE: 20-01-2015  
  --------------------------------------------------------------------------------------------------------
  procedure Get_Tipos_Referencias(p_io_cursor        IN OUT t_cursor,
                                  p_resultnumber     OUT VARCHAR2);  
                                 
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
-- Program:  NoPagaINFOTEP
-- Description:Para marcar una empresa, indicando que No paga infotep
--Autor: Eury Vallejo
-- **************************************************************************************************
  procedure NoPagaInfotep(p_usuario in seg_usuario_t.id_usuario%type,
                          p_rnc in sre_empleadores_t.rnc_o_cedula%type,
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
-- Procedure: GetCiudadano
-- Description: Buscar la informacion del ciudadano en base a su numero de cedula
-- By: Kerlin De La Cruz
-- Date: 08/05/2017
-- **************************************************************************************************
  procedure GetCiudadano(p_cedula in sre_ciudadanos_t.no_documento%type,  
                         p_iocursor     IN OUT t_cursor,                     
                         p_resultado OUT VARCHAR2); 
                         
-- **************************************************************************************************
-- Procedure: GetTrabajador
-- Description: Buscar la informacion del trabajador en base a su numero de cedula
-- By: Kerlin De La Cruz
-- Date: 08/05/2017
-- **************************************************************************************************
procedure GetTrabajador(p_cedula in sre_ciudadanos_t.no_documento%type,  
                        p_iocursor     IN OUT t_cursor,                     
                        p_resultado OUT VARCHAR2);
                        
-- **************************************************************************************************
-- Procedure: GetEmpleadorRep
-- Description: Buscar la informacion de la empresa y sus trabajadores activos
-- By: Kerlin De La Cruz
-- Date: 08/05/2017
-- **************************************************************************************************
procedure GetEmpleadorRep(p_rnc_cedula in sre_empleadores_t.rnc_o_cedula%type,  
                          p_iocursor     IN OUT t_cursor,                     
                          p_resultado OUT VARCHAR2); 
                          
-- **************************************************************************************************
-- Procedure: ActualizarCategoriaRiesgo
-- Description: Para actualizar la categoria riesgo de un empleador
-- By: Kerlin De La Cruz
-- Date: 09/05/2017
-- **************************************************************************************************
 procedure ActualizarCategoriaRiesgo(p_rnc_cedula in sre_empleadores_t.rnc_o_cedula%type,
                                     p_categoria_riesgo in sre_categoria_riesgo_t.id_riesgo%type,
                                     p_usuario in seg_usuario_t.id_usuario%type,
                                     p_resultado OUT VARCHAR2); 
                                     
-- **************************************************************************************************
-- Procedure: GetExtranjero
-- Description: Buscar la informacion del extranjero en base a su numero de documento
-- By: Kerlin De La Cruz
-- Date: 08/05/2017
-- **************************************************************************************************
 procedure GetExtranjero(p_nro_carnet in nss_maestro_extranjeros_t.id_expediente%type,  
                        p_iocursor   IN OUT t_cursor,                     
                        p_resultado  OUT VARCHAR2);  
                                                                                                                                                                                                                                                                                                          
end WSS_Servicios_pkg;
