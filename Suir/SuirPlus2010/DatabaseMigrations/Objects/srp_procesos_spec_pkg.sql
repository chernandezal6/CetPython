create or replace package suirplus.srp_procesos_pkg as
 -- Author  : roberto jaquez
 -- Created : 10/02/2005
 -- Purpose : Objetos necesarios para el envio de procesos batch
    type t_cursor is ref cursor;
    function  validar (p_proceso in varchar2,p_parametros in varchar2) return varchar2;
    procedure ejecutar(p_proceso in varchar2,p_usuario in varchar2,p_parametros in varchar2);
    procedure getListadoprocesos(
        p_iocursor            out t_cursor,
        p_resultnumber        out varchar2);
    procedure ejecutarFacturacion;
    procedure ejectutarRecargosTSS;
    procedure ejectutarRecargosDGII;
    procedure gethistorialproceso(
        p_id_proceso     in sfc_bitacora_t.id_proceso%type,
        p_iocursor            out t_cursor,
        p_resultnumber        out varchar2);
    PROCEDURE gethistorialproceso_Total(
        p_id_proceso          IN sfc_bitacora_t.id_proceso%TYPE,
        p_iocursor            OUT t_cursor,
        p_resultnumber        OUT VARCHAR2);
    procedure CargarDatos(
        p_id_proceso          in sfc_procesos_t.id_proceso%type,
        p_iocursor            out t_cursor,
        p_resultnumber        out varchar2);
    function isExisteidproceso(p_id_proceso varchar2) return boolean;
    PROCEDURE getSessionesActual(p_iocursor            OUT t_cursor);
    PROCEDURE Archivo_Factura_TSS(pperiodo SFC_FACTURAS_T.periodo_factura%TYPE);

    procedure Job_Facturacion (p_job in integer, p_mes in integer);
    procedure Job_RecargosTSS (p_job in integer, p_mes in integer);
    --procedure Job_RecargosDGII(p_job in integer, p_mes in integer);
    procedure Job_RecargosINFOTEP(p_job in integer, p_mes in integer);
    procedure fac_liq_rec_automatico;
    procedure refrescar_vista_sipen;

    -- ----------------------------------------------------------------------
    --Para refrescar la vista de trabajadores de baja
    -- ----------------------------------------------------------------------    
    procedure refrescar_vista_emp_baja;
end srp_procesos_pkg;