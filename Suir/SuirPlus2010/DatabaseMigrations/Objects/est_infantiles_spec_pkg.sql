CREATE OR REPLACE PACKAGE SUIRPLUS.EST_INFANTILES_PKG IS

  -- Author  : GREGORIO_HERRERA
  -- Created : 4/17/2009 2:10:46 PM
  -- Purpose : Manejo de todos los procesos relativo a estancias infantiles
  -- Version : 1.0
  -- ======================================================================

  -- Public type declarations
  c_mail_from    varchar2(250) := 'info@mail.tss2.gov.do';
  c_mail_to      varchar2(250);
  c_mail_error   varchar2(250) := '_DivisiondeControldeOperaciones@mail.tss2.gov.do';
  c_mail_subject varchar2(100) := 'Proceso de Validacion Dispersion Estancias Infantiles';
  v_html         varchar(32000);

  -- Public function and procedure declarations
  PROCEDURE procesar( p_result OUT VARCHAR2 );

  -- -----------------------------------------------------------------------
  -- Cargar_Resumen_Dispersion_Estancias_Infantiles: Resumen de Dispersion
  -- GREIMAN GARCIA
  -- 26/05/2009
  -- -----------------------------------------------------------------------
  procedure Resumen_Estancias_Infantiles(p_Carga  suirplus.est_carga_t.id_carga%type,
                                         p_result out varchar2);

  -- ======================================================
  -- Para enviar email con el resultado del proceso
  -- ======================================================
  PROCEDURE enviar_email(p_id_carga IN NUMBER );
  -- -----------------------------------------------------------------------
  -- Reversar_dispersion
  -- GREIMAN GARCIA
  -- 20/10/201010
  -- -----------------------------------------------------------------------
  procedure Reversar_dispersion( p_Carga  suirplus.est_carga_t.id_carga%type,
                                 p_result out varchar2);

  -- -----------------------------------------------------------------------
  -- Inserta las estancias que no estan del lado de TSS
  -- GREIMAN GARCIA
  -- 19/05/2011
  -- -----------------------------------------------------------------------
  procedure Insert_Estancia_uni(p_result out varchar2);

  -- -----------------------------------------------------------------------
  -- Milciades Hernandez
  -- 25/08/2010
  -- saca el resumen de dispersión Estancia Infantiles de acuerdo al periodo.
  -- -----------------------------------------------------------------------
  procedure Resumen_Dispersion_inf(p_periodo      in suirplus.est_dispersion_resumen_t.periodo_dispersion%type,
                                   p_iocursor     out sys_refcursor,
                                   p_resultnumber out Varchar2);

END EST_INFANTILES_PKG;
