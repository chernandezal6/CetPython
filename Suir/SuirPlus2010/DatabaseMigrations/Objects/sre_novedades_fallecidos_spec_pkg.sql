create or replace package suirplus.SRE_NOVEDADES_FALLECIDOS_PKG is
  -- Author  : YACELL_BORGES
  -- Created : 6/28/2012 11:18:42 AM
  -- Purpose : Manejar la información relacionada con los fallecidos reportados desde  Unipago

  TYPE t_cursor  IS REF CURSOR;

  -----------------------------------------------------------------------------------------------------------------------------
  --Procesos de carga de datos de la vista a UNIPAGO
  -- Objetivo: Refrescar la informacion de los fallecidos recibidos desde UNIPAGO.
  -- Autor: Yacell Borges, Gregorio Herrera
  -- Fecha: 3/7/2012
  -----------------------------------------------------------------------------------------------------------------------------
  procedure cargar_lotes;

  procedure cargar_fallecidos;
  procedure evaluar_fallecidos;

  -----------------------------------------------------------------------------------------------------------------------------
  --Procesos de carga de la pantalla Evaluacion de Fallecidos
  -- Autor: Yacell Borges
  -- Fecha: 5/7/2012
  -----------------------------------------------------------------------------------------------------------------------------
  procedure procesar;

  -------------------------------------------------------------------------------------------------------------------------------------
  -- Autor: Yacell Borges
  -- Fecha: 5/7/2012
  -- Descripcion: Busca los datos de los ciudadanos para la evaluacion visual
  --------------------------------------------------------------------------------------------------------------------------------------
  procedure getDatosCiudadanos(p_iocursor     in out t_cursor,
                               p_resultnumber out varchar2);

  --------------------------------------------------------------------------------------------------------------------------------------
  -- Autor: Yacell Borges
  -- Fecha: 5/7/2012
  -- Descripcion: Busca los motivos de rechazo de un fallecimiento en la tabla sre_motivos_fallecidos_t
  --------------------------------------------------------------------------------------------------------------------------------------
  procedure getMotivoRechazo(p_iocursor  in out t_cursor,
                             p_resultnumber out Varchar2);

  --------------------------------------------------------------------------------------------------------------------------------------
  -- Autor: Yacell Borges
  -- Fecha: 5/7/2012
  -- Descripcion: Rechaza la evaluacion de un fallecido cambiandole el estatus a 'R'
  --------------------------------------------------------------------------------------------------------------------------------------
  procedure RechazarEvaluacion(p_Novedad in sre_det_novedades_fallecidos_t.id_det_novedad_fallecido%type,
                               p_motivo in varchar2,
                               p_usuario in sre_det_novedades_fallecidos_t.ult_usuario_act%type,
                               p_resultnumber out varchar2);

  --------------------------------------------------------------------------------------------------------------------------------------
  -- Autor: Yacell Borges
  -- Fecha: 5/7/2012
  -- Descripcion: Actualiza los datos del ciudadano fallecido con los datos de la evaluacion visual.
  -------------------------------------------------------------------------------------------------------------------------------------
  Procedure ActualizarCiudadano(p_Novedad in sre_det_novedades_fallecidos_t.id_det_novedad_fallecido%type,
                                p_usuario in sre_det_novedades_fallecidos_t.ult_usuario_act%type,
                                P_resultnumber out varchar2);

end SRE_NOVEDADES_FALLECIDOS_PKG;