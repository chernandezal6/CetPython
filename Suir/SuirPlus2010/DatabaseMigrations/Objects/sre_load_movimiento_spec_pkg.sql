create or replace package suirplus.sre_load_movimiento_pkg is
  -- Author  : ROBERTO_JAQUEZ
  -- Created : Julio 6, 2006
  -- Purpose : Carga de tmp_movimientos a movimientos

  procedure insertar_movimiento_archivo(p_recepcion in number);
  procedure someter_movimiento_web(p_movimiento in number);
  procedure poner_en_cola(p_movimiento in number);
  procedure serializar_ejecucion(p_registro_patronal in number,
                                 p_job               in number);

  function Is_Numero(p_texto in varchar2) return boolean;
  function Is_Dinero(p_texto in varchar2) return boolean;
  function Is_Fecha(p_texto in varchar2) return boolean;
  function Is_Nulo(p_texto in varchar2) return boolean;
  function Is_Nombre_Propio(p_texto in varchar2) return boolean;
  function Is_Documento(p_texto in varchar2) return boolean;

  -- wrapper para compatibilidad
  procedure seg_carga_movimiento_tmp_p(p_id_recepcion in number);

  function To_Fecha(p_texto in varchar2) return date;
  function To_Numero(p_texto in varchar2) return number;

  --
  procedure relanzar_movimientos_detenidos;

end sre_load_movimiento_pkg;
