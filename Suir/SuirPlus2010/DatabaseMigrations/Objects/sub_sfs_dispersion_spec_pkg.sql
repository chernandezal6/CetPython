create or replace package SUIRPLUS.SUB_SFS_DISPERSION is


  -- Author  : MAYRENI_VARGAS
  -- Created : 2/3/2011 4:13:28 PM
  -- Purpose :

  -- Public type declarations
  type t_cursor is ref cursor;

  procedure EnviarPorFTP(p_secuencia_archivo in sfs_archivos_log_t.secuencia%type,
                         p_tiposubsidio      in sfs_archivos_log_t.tipo_subsidio%type);

  function GetProximoNumeroCuotaRe return INTEGER;

  function GetProximoNumeroCuota return INTEGER;

  Procedure RecibirLactantes(p_result out varchar2);

  Procedure RecibirElegibles(p_result out varchar2);

  Procedure RecibirCuentasBancarias(p_result out varchar2);

  procedure GenerarDispersionLactancia(p_periodo in sub_cuotas_t.periodo%type,
                                       p_result  out varchar2);

  procedure GenerarDispersionMaternidad(p_periodo in sub_cuotas_t.Periodo%type,
                                        p_result  out varchar2);

  Procedure GenerarDispersionEnfComun(p_periodo in suirplus.sub_cuotas_t.Periodo%type,
                                      p_result  out varchar2);

  Procedure PublicarDispersionLactancia(p_result out varchar2);

  Procedure PublicarDispersionMaternidad(p_result out varchar2);

  Procedure PublicarDispersionEnfComun(p_result out varchar2);

  Procedure RecibirDispersionLactancia(p_Result Out Varchar2);

  Procedure RecibirDispersionMaternidad(p_Result Out Varchar2);

  Procedure RecibirDispersionEnfComun(p_Result Out Varchar2);

  procedure ProcesarArchivoLactancia(p_Result out varchar2);

  procedure ProcesarArchivoMaternidad(p_Result out varchar2);

  Procedure ProcesarArchivoEnfComun(p_Result out varchar2);

  Procedure RecibirSubsLactancia(p_Result Out Varchar2);

  Procedure RecibirSubsmaternidad(p_Result Out Varchar2);

  Procedure RecibirSubsEnfComun(p_Result Out Varchar2);

  procedure PublicarNP(p_fecha  in suirplus.sfc_facturas_t.fecha_registro_pago%type,
                       p_Result Out Varchar2);

  /* ------------------------------------------------------------------------
     Procedure: RecibirDebitosNP
     Objetivo: Recibir los Debitos desde SISALRIL para colocarlo como ajustes
  */ ------------------------------------------------------------------------
  Procedure RecibirDebitosNP(p_result out varchar2);

  Procedure RecibirCancelaciones(p_result out varchar2);
  
    --------------------------------------------------------------------------------------------------------------------
  --- Funcion para validar ajustes duplicados, si el ajuste existe retorna true, si no existe retorna false
  --Autor: Eury Vallejo
  --15/5/2017
  --------------------------------------------------------------------------------------------------------------------
  Function ValidarAjustesDuplicados(p_unico in nvarchar2)
    return boolean;

end SUB_SFS_DISPERSION;