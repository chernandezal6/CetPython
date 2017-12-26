create or replace package suirplus.ars_cartera_senasa_pkg is
  procedure Refrescar_vista_senasa;
  Procedure Refrescar_vistas;
  Procedure enviar_email (p_mes in integer, p_id_carga in number);

  /* --------------------------------------------------------------------------
    Objetivo: procesar los registros de cartera del regimen subsidiado SENASA
    Fecha   : Reestructurado en Diciembre 2014
    Autor   : Gregorio U. Herrera
  */ --------------------------------------------------------------------------
  Procedure procesar (p_mes in integer, p_result out varchar2);

  /* --------------------------------------------------------------------------
    Objetivo: actualizar como completado el JOB que llama el metodo PROCESAR
              a sugerencia de operaciones
    Fecha   : 19 agosto 2015
    Autor   : Gregorio U. Herrera
  */ --------------------------------------------------------------------------
  Procedure carga_NO_paralelizada (p_mes in integer, p_terminal in integer, p_job IN suirplus.seg_job_t.id_job%TYPE);

  /* --------------------------------------------------------------------------
    Objetivo: poner en JOB la corrida del metodo PROCESAR, a sugerencia de operaciones
    Fecha   : 19 agosto 2015
    Autor   : Gregorio U. Herrera
  */ --------------------------------------------------------------------------
  Procedure Procesar_produccion (p_mes in integer);

end ars_cartera_senasa_pkg;