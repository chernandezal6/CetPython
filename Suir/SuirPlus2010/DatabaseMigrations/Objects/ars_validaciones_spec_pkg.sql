create or replace package suirplus.ars_validaciones_pkg as
  -- Author  : roberto jaquez
  -- Created : 08/03/2007
  -- Purpose : Validacion de carteras de ARS
  --
  -- Modificaciones:
  -- Fecha        Persona      Razon
  -- 11-MAR-2008  R. Pichardo  Agregar Update de Dispersion enviado por H. Minaya
  -- 12-MAR-2008  R. Pichardo  Agregar validacion de la vista "ARS_RECLAMO_RECIEN_NACIDOS_MV" en carga de cartera.
  --                           - Se agrego el parametro "204" ('CICLO CARGA DE CARTERA.')
  --                           - Se creo la vista "ars_carga_cartera_v" para presentar los datos segun el parametro periodo.
  -- 12-MAR-2008  R. Pichardo  Agregar validacion 22 "Registros previamente dispersados".
  -- 12-MAR-2008  R. Pichardo  Mover el llamado a "enviar_email" desde "validar_cartera" hasta "Actualizar_cartera".
  -- 12-MAR-2008  R. Pichardo  Mover el llamado a "enviar_email" desde "validar_dispersion" hasta "Actualizar_dispersion".
  -- 11-JUL-2008  R. Pichardo  Activar validacion 23 (desempleados)
  -- 10-SEP-2008  R. Pichardo  Agregar email de Greiman
  -- 04-DIC-2008  R. Pichardo  Modificar error 26 para Dispersion y Agregar Error 26 en Carga de Cartera
  -- 14-OCT-2009  G. Herrera   Agregar funcionalidad para procesar dispersion completivas
  -- 01-SEP-2010  G. Herrera   Agregar funcionalidad para no procesar varias veces la misma dispersion o cartera mas de una vez
  -- 25-MAY-2011  G. Herrera   Agregar funcionalidad para procesar distintos ciclo, esto a raiz de la dispersion de FONAMAT
  -- 16-OCT-2012  G. Herrera   Agregar funcionalidad para pagos en exceso por dependientes Adicional pagados no dispersados en ARS

  TYPE t_cursor IS REF CURSOR;
  c_mail_from    varchar2(250) := 'info@mail.tss2.gov.do';
  c_mail_to      varchar2(250);
  c_mail_error   varchar2(250);
  c_mail_subject varchar2(1000) := 'proceso de validacion';
  v_html         varchar2(32000);
  m_vista        suirplus.ars_carga_t.vista%type;
  m_debug        integer := 0;

  procedure Cargar_Resumen_Dispersion(p_Carga  ars_carga_t.id_carga%type,
                                      p_tipo   in integer,
                                      p_result out varchar2);
  --function monto_valido( p_periodo in varchar2, p_campo in int, p_monto number ) return integer;
  function monto_valido( p_nss in integer, p_periodo in varchar2, p_campo in int, p_monto number ) return integer;

  procedure Actualizar_cartera(p_carga in ars_carga_t.id_carga%type, p_terminal in number, p_job in suirplus.seg_job_t.id_job%type, p_result out varchar2);
    
  procedure procesar_cartera(p_ciclo in number, p_result out varchar2);

  procedure procesar_dispersion(p_ciclo in number, p_result out varchar2);

  procedure procesar_dispersion_comp(p_result out varchar2);

  procedure enviar_email(p_proceso in varchar2, p_id_carga in number);

  ---************************************************************************************--
  -- Milciades Hernandez
  -- 25/08/2010
  -- saca el resumen de un consolidado para una primera o segunda dispersi?n.
  ---************************************************************************************--
  procedure ResumenConsol1raDispersion(p_periodo      in ars_dispersion_resumen_t.periodo_dispersion%type,
                                       p_ciclo        in pls_integer,
                                       p_tipo         in integer,
                                       p_iocursor     in out t_cursor,
                                       p_resultnumber out Varchar2);

  ---************************************************************************************--
  -- prog = getPeriodosDispersion
  -- by charile pe?a
  -- trae una lista de los distintos periodos que existen en dispersion.
  ---************************************************************************************--
  procedure getPeriodosDispersion(p_iocursor     in out t_cursor,
                                  p_resultnumber out Varchar2);
  -- -----------------------------------------------------------------------
  -- Reversar_dispersion
  -- GREIMAN GARCIA
  -- 20/10/201010
  -- -----------------------------------------------------------------------
  procedure Reversar_dispersion(p_Carga  suirplus.ars_cartera_t.id_carga_dispersion%type,
                                p_result out varchar2);

  Procedure Procesar_job (p_proceso in varchar2, p_tipo in integer, p_job IN suirplus.seg_job_t.id_job%TYPE);

  Procedure Crear_job (p_proceso in varchar2, p_tipo in integer, p_result out varchar2); 

end ars_validaciones_pkg;
