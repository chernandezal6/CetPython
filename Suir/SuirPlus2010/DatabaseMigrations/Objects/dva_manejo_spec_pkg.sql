CREATE OR REPLACE PACKAGE DVA_MANEJO_PKG AS

 TYPE t_cursor IS REF CURSOR ;
 v_bderror  varchar2(1000);
 
 
 
-- ==============================================
-- Insertar el registro en la maestra de bitacora
-- ==============================================
  procedure bitacora (
    p_id_bitacora IN OUT SFC_BITACORA_T.id_bitacora%TYPE,
    p_accion      IN VARCHAR2 DEFAULT 'INI',
    p_id_proceso  IN SFC_BITACORA_T.id_proceso%TYPE,
    p_mensage     IN SFC_BITACORA_T.mensage%TYPE DEFAULT NULL,
    p_status      IN SFC_BITACORA_T.status%TYPE DEFAULT NULL,
    p_id_error    IN SEG_ERROR_T.id_error%TYPE DEFAULT NULL,
    p_seq_number  IN ERRORS.seq_number%TYPE DEFAULT NULL,
  	p_periodo     IN SFC_BITACORA_T.periodo%TYPE DEFAULT NULL
  );
 
 ---**********************************************************************************************----
-- Milciades Hernandez
-- 24-Abril-2009
-- get_Reclamaciones
--Busca las reclamaciones de acuerdo a los parametros especificados..
---**********************************************************************************************----
 Procedure get_Reclamaciones (
        p_desde            IN date,
        p_hasta            IN date,
        p_rnc              IN sre_empleadores_t.rnc_o_cedula%type,
        p_nro_reclamacion  IN dva_registros_t.nro_reclamacion%TYPE,
        p_estatus          IN dva_registros_t.id_status%type,
        p_pagenum          in number,
        p_pagesize         in number,
        p_resultnumber     OUT varchar2,
        p_io_cursor        IN OUT t_cursor);

---**********************************************************************************************----
-- Milciades Hernandez
-- 24-Abril-2009
-- get_Det_Reclamacion
-- Busca los detalles las Reclamaiones de acuerdo a los parametros especificados.
---**********************************************************************************************----
 Procedure get_Det_Reclamacion (
        p_nro_reclamacion  IN dva_registros_t.nro_reclamacion%TYPE,
        p_estatus          IN dva_registros_t.id_status%type,
        p_pagenum          in number,
        p_pagesize         in number,
        p_resultnumber     OUT varchar2,
        p_io_cursor        IN OUT t_cursor);

 -- ==============================================
 -- Insertar el registro en el esquema UNIPAGO
 -- ==============================================
 procedure enviar_UNIPAGO(p_nro_reclamacion dva_registros_t.nro_reclamacion%type, p_result out varchar2);

  --**********************************************************************************************----
  -- Gregorio Hererra
  -- Recibir respuesta desde UNIPAGO para una reclamacion
  -- 01-Septiembre-2010
  --**********************************************************************************************----
  procedure recibir_repuesta_UNIPAGO(p_result out varchar2);

 --**********************************************************************************************----
  -- Gregorio Hererra
  -- Recibir rechazos desde UNIPAGO para una reclamacion en la tabla TSS_RESP_SOLICITUD_DEV_MV
  -- 14-Octubre-2010
  --**********************************************************************************************----
  procedure recibir_rechazos_UNIPAGO(p_result out varchar2);

---**********************************************************************************************----
-- Milciades Hernandez
-- MarcarReclamacion
-- 24-Abril-2009
-- Modifica el estatus de las Reclamacion
---**********************************************************************************************----
procedure MarcarReclamacion (
                             p_nro_reclamacion  in dva_registros_t.nro_reclamacion%TYPE,
                             p_status           in varchar2,
                             p_resultnumber     OUT varchar2) ;

---**********************************************************************************************----
-- Milciades Hernandez
-- IsExisteReclamacion
-- 24-Abril-2009
-- Verifica si el Numero de Reclamacion existe
---**********************************************************************************************----
 FUNCTION IsExisteReclamacion(p_Nro_Reclamacion  IN  dva_registros_t.nro_reclamacion%type) RETURN BOOLEAN;

PROCEDURE GetPagosExceso(
               P_cedula IN SRE_CIUDADANOS_T.NO_DOCUMENTO%type,
               p_io_cursor     IN OUT T_CURSOR,
               p_resultnumber OUT VARCHAR2 );

               PROCEDURE GetPagosExcesoEmpresa(
                  P_RNC          IN sre_empleadores_t.rnc_o_cedula%type,
                  p_io_cursor    OUT T_CURSOR,
                  p_resultnumber OUT VARCHAR2 );

---**********************************************************************************************----
-- charlie pena
-- 31/08/2010
-- getNachas
-- Busca los archivos nacha pendientes de aprobacion.
---**********************************************************************************************----
 Procedure getNachas (
        p_resultnumber     OUT varchar2,
        p_io_cursor        IN OUT t_cursor);

---**********************************************************************************************----
-- Gregorio Herrera
-- 21/09/2010
-- Busca las reclamaciones para un archivo nacha
---**********************************************************************************************----
 Procedure getDetNachas (
        p_archivo_nacha IN suirplus.dva_solicitudes_proc_t.archivo_nacha%type,
        p_pagenum       in number,
        p_pagesize      in number,
        p_resultnumber  OUT varchar2,
        p_io_cursor     IN OUT t_cursor);

---**********************************************************************************************----
-- charlie pena
-- 31/08/2010
-- getNachas
-- Marcar como aprobado el archivo nacha pendiente de aprobacion.
---**********************************************************************************************----
procedure aprobarNacha (
     p_nacha  in dva_det_registros_t.nombre_archivo_nacha%TYPE,
     p_usuario in seg_usuario_t.id_usuario%type,
     p_resultnumber     out varchar2
     );

---**********************************************************************************************----
-- Gregorio Herrera
-- 23/09/2010
-- Marcar como rechazado el archivo nacha
---**********************************************************************************************----
procedure rechazarNacha (
     p_nacha  in dva_det_registros_t.nombre_archivo_nacha%TYPE,
     p_usuario in seg_usuario_t.id_usuario%type,
     p_resultnumber     out varchar2
     );

FUNCTION IsExisteNacha(p_Nacha  IN dva_det_registros_t.nombre_archivo_nacha%type) RETURN BOOLEAN;

  -- **************************************************************************************************
  -- Para saber si un empleador tiene Facturas pagadas
  -- **************************************************************************************************
  Procedure TieneFactPagadas(p_registro_patronal in varchar2, p_result out varchar2);


 ---------------------------------------------------------------------------
  -- Objetivo: Traer los diferentes estatus de devolucion de aportes
  -- Autor: charlie Pe?a
  -- Fecha: 15/10/2010
  ---------------------------------------------------------------------------
  Procedure getStatus
  (
   p_iocursor     out t_cursor,
   p_resultnumber out varchar2
  );

  ---------------------------------------------------------------------------
  -- Objetivo: Obtener el monto a devolver a cada ciudadano con cedulas validas.
  -- Autor: Eury Vallejo
  ---------------------------------------------------------------------------
PROCEDURE GetPagosExcesoCiudadanos(
               P_cedula         IN SRE_CIUDADANOS_T.NO_DOCUMENTO%type,
               p_io_cursor      IN OUT T_CURSOR,
               p_resultnumber   OUT VARCHAR2 );

procedure EntregarFondos (
     p_nro_reclamacion  in dva_registros_t.nro_reclamacion%TYPE,
     P_tipodoc          in dva_registros_t.Tipo_documento%TYPE,
     P_nro_documento     in dva_registros_t.Nro_documento%TYPE,
     P_nro_cheque        in dva_registros_t.Nro_Cheque%TYPE,
     P_status          in dva_registros_t.id_status%TYPE,
     P_entregado_por     in dva_registros_t.entregado_por%TYPE,
     p_resultnumber     out varchar2
     )  ;

---**********************************************************************************************----
-- Kerlin De La Cruz
-- ValidaCiudadano
-- 15/02/2013
-- Verifica si el ciudadano  se encuentra cancelado o inhabilitado en la tabla sre_ciudadanos_t
---**********************************************************************************************----
Procedure ValidaCiudadano(p_no_documento   in sre_ciudadanos_t.no_documento%type,
                       p_tipo_documento in sre_ciudadanos_t.tipo_documento%type,
                       p_resultnumber   OUT VARCHAR2);



END DVA_MANEJO_PKG;