create or replace package body suirplus.ars_validaciones_pkg is
  -- ------------------------------------------------------------------------------------------------------------------------------------
  m_codigos_ars           varchar2(32000);
  m_codigos_ars_inactivas varchar2(32000);

  m_registros                  integer := 0;
  m_hoy                        date := sysdate;
  m_validacion                 integer := 0; -- Se utiliza para indicar la validacion que presenta excepcion, al enviar email.
  m_per_desde                  varchar2(6) := 200708;
  m_per_hasta                  varchar2(6) := Parm.Periodo_Vigente(sysdate);
  m_per_actual                 varchar2(6) := TO_Char(add_months(SYSDATE, -1), 'YYYYMM'); -- Periodo Mes anterior
  m_carga_seq                  ars_carga_t.id_carga%type;
  m_registros_procesados_ok    integer := 0;
  m_registros_procesados_error integer := 0;
  m_proceso                    varchar2(255) := ' ';

  v_Proximo_Job                Number(9);
  v_Comando                    Varchar(1000);
  m_hora_inicio                date;
  m_hora_termina               date; 

  
  procedure debug(p_texto in varchar2) is
    m_Texto suirplus.ars_log_t.texto%type;
  begin
    m_debug := m_debug + 1;
    m_Texto := to_char(m_debug, '00000000000') || ' ' || p_texto;

    insert into suirplus.ars_log_t values (sysdate, m_Texto);
    commit;
  end;

  function old_monto_valido( p_periodo in varchar2, p_campo in int, p_monto number ) return integer
  is
    v_monto_dep_adicional    number(13, 2);
    v_monto_titular_directo  number(13, 2);
    v_monto_capita_fonamat   number(13, 2);
    v_monto                  number(13, 2) := -1;
    v_return                 Integer := -1;
  begin
    select sum(decode(dp.id_parametro, 349, dp.valor_numerico, 0)) monto_capita_fonamat,
           sum(decode(dp.id_parametro, 349, dp.valor_numerico, 350, dp.valor_numerico, 0)) monto_dep_adicional,
           sum(decode(dp.id_parametro, 349, dp.valor_numerico, 351, dp.valor_numerico, 0)) monto_titular_directo
      into v_monto_capita_fonamat, v_monto_dep_adicional, v_monto_titular_directo
      from suirplus.sfc_det_parametro_t dp
     where dp.id_parametro in (349, 350, 351)
       and to_date( p_periodo || '18', 'yyyymmdd' )between dp.fecha_ini and dp.fecha_fin
     group by dp.fecha_ini, dp.fecha_fin
      order by 1, 2 ;

    if    p_campo = 1 then
       v_monto := v_monto_capita_fonamat;
    elsif p_campo = 2 then
       v_monto := v_monto_dep_adicional;
    elsif p_campo = 3 then
       v_monto := v_monto_titular_directo;
    end if;

    if p_monto =  v_monto then
       v_return := 0;
    end if;

    Return v_return;

	exception when others then
      return -1;
  end;

  function monto_valido( p_nss in integer, p_periodo in varchar2, p_campo in int, p_monto number ) return integer
  is
    v_return Integer;
    v_monto  suirplus.sfc_det_parametro_t.valor_numerico%type;

    function parm_val(m_parm in number, m_per in number) return number is
      m_result number;
    begin
      begin
        select dp.valor_numerico
        into m_result
        from suirplus.sfc_det_parametro_t dp
        where dp.id_parametro=m_parm
        and to_date( m_per || '18', 'yyyymmdd' ) between dp.fecha_ini and dp.fecha_fin;
      exception when others then
        m_result := 0;
      end;

      return m_result;
    end;
  begin
    if (p_campo=1) then
      v_monto := parm_val(349,p_periodo); --percapita_adicional
    elsif (p_campo=2) then
      v_monto := parm_val(349,p_periodo)  --percapita_adicional
               + parm_val(350,p_periodo); --completivo_adicional
    elsif (p_campo=3) then
      v_monto := parm_val(372,p_periodo)  --percapita_directos
               + parm_val(351,p_periodo); --completivo_directos
    elsif (p_campo=4) then
      v_monto := parm_val(372,p_periodo); --percapita_directos
    end if;

    if p_monto =  v_monto then
       v_return := 0;
    else
       v_return := -1;
    end if;

    -- dbms_output.put_line( ' NSS/Periodo/Campo/Monto<>MontoParm: ' || p_nss || '/' || p_periodo || '/' ||
    -- p_campo  || '/' || p_monto || '<>' || v_monto);

    Return v_return;

	exception when others then
    return -1;
  end;

  -- -----------------------------------------------------------------------
  -- Cargar_Resumen_Dispersion: Resumen de Dispersion
  -- -----------------------------------------------------------------------
  procedure Cargar_Resumen_Dispersion(p_Carga  ars_carga_t.id_carga%type,
                                      p_tipo   in integer,
                                      p_result out varchar2) is

    m_result varchar2(32000) := 'OK';
    e_InvalidCiclo exception;
    v_registros number := 0;
  begin
    -- Verificar si hay un resumen previo
    select count(*)
      into v_registros
      from ars_dispersion_resumen_t
     where id_carga_dispersion = p_Carga;

    -- si no encontro registros, poner en cero
    v_registros := nvl(v_registros, 0);

    -- Si existen registros, entonces, es un reproceso, eliminar el resumen previo
    if v_registros > 0 then
      delete ars_dispersion_resumen_t where id_carga_dispersion = p_Carga;
    end if;

    -- Identifica si el tipo de dispersion es de Ars (1) o de Fonamat (2)
    if p_tipo = 1 then
      -- Insertar registros en Resumen
      insert into ars_dispersion_resumen_t
        (id_carga_dispersion,
         id_ars_dispersada,
         periodo_dispersion,
         titulares,
         dependientes,
         adicionales,
         monto_titulares,
         monto_dependientes,
         monto_adicionales,
         pago)
        Select a.id_carga_dispersion,
               b.id_ars,
               to_char(ca.fecha, 'YYYYMM') Periodo,
               sum(decode(a.tipo_afiliado, 'T', 1, 0)) titulares,
               sum(decode(a.tipo_afiliado, 'D', 1, 0)) dependientes,
               sum(decode(a.tipo_afiliado, 'A', 1, 0)) adicionales,
               sum(decode(a.tipo_afiliado, 'T', a.monto_dispersar, 0)) monto_titulares,
               sum(decode(a.tipo_afiliado, 'D', a.monto_dispersar, 0)) monto_dependientes,
               sum(decode(a.tipo_afiliado, 'A', a.monto_dispersar, 0)) monto_adicionales,
               sum(a.monto_dispersar) pago
          from suirplus.ars_carga_t ca
          left join suirplus.ars_cartera_t a
            on a.id_carga_dispersion = ca.id_carga
          left join suirplus.ars_catalogo_t b
            on b.id_ars = a.id_ars_dispersada
         where ca.id_carga = p_Carga -- ID de dispersion.
         group by a.id_carga_dispersion,
                  b.id_ars,
                  to_char(ca.fecha, 'YYYYMM');
    else
      insert into suirplus.ars_dispersion_resumen_t
        (id_carga_dispersion,
         id_ars_dispersada,
         periodo_dispersion,
         titulares,
         dependientes,
         adicionales,
         monto_titulares,
         monto_dependientes,
         monto_adicionales,
         pago)
        Select ca.id_carga,
               b.id_ars,
               to_char(ca.fecha, 'YYYYMM') Periodo,
               sum(decode(a.tipo_afiliado, 'T', 1, 0)) titulares,
               sum(decode(a.tipo_afiliado, 'D', 1, 0)) dependientes,
               sum(decode(a.tipo_afiliado, 'A', 1, 0)) adicionales,
               sum(decode(a.tipo_afiliado, 'T', a.monto_fonamat, 0)) monto_titulares,
               sum(decode(a.tipo_afiliado, 'D', a.monto_fonamat, 0)) monto_dependientes,
               sum(decode(a.tipo_afiliado, 'A', a.monto_fonamat, 0)) monto_adicionales,
               sum(a.monto_fonamat) pago
          from suirplus.ars_carga_t ca
          left join suirplus.ars_cartera_t a
            on a.id_carga_fonamat = ca.id_carga
          left join suirplus.ars_catalogo_t b
            on b.id_ars = a.id_ars_fonamat
         where ca.id_carga = p_Carga -- ID de dispersion.
         group by ca.id_carga, b.id_ars, to_char(ca.fecha, 'YYYYMM');

         --notificar a la CERSS que ya se completó el mes pasado -------------------------
         declare
          m_from    varchar2(100) := 'info@mail.tss2.gov.do';
          m_to      varchar2(100);
          m_subject varchar2(100);
          m_message varchar2(1000);
          m_periodo varchar2(100);
         begin
          Begin
            select a.lista_ok
            into m_to
            from suirplus.sfc_procesos_t a
            where a.id_proceso = '89';
             
            select max(periodo_factura_ars)
            into m_periodo
            from suirplus.ars_cartera_t;

            m_subject := 'Finalización de cartera del regimen contributivo';
            m_message := 'Se les informa que ha sido cargada la cartera del regimen contributivo correspondiente al período '
                         ||m_periodo||'.'
                         ||'<br><br>Pueden proceder con la carga de archivos de validación.<br>';             
          Exception
            when no_data_found then
              m_to      := '_divisionadministraciondeincidentes@mail.tss2.gov.do';
              m_subject := 'Proceso ''89'' no encontrado.';
              m_message := 'Proceso ''89'' no encontrado en ' ||
                           'ars_validaciones_pkg.Cargar_Resumen_Dispersion';
          End;

          system.html_mail(p_sender    => m_from,p_recipient => m_to,p_subject   => m_subject,p_message   => m_message);
         end;
         -- hasta aqui la notificacion a la CERSS ----------------------------------------
    end if;
    -- actualiza el status de la carga de Dispercion de T a C
    update suirplus.ars_carga_t cart
       set cart.status = 'C'
     WHERE cart.id_carga = p_Carga;

    Commit;
    p_result := m_result;
  exception
    when e_InvalidCiclo then
      p_result := 'ERROR. Procesar Resumen de Dispersion de ARS.';
    when others then
      p_result := 'ERROR. Procesar Resumen de Dispersion de ARS.' ||sqlerrm;
  end;

  -- ------------------------------------------------------------------------------------------------------------------------------------
  procedure validar_cartera(p_result out varchar2) is
  begin
    --Para crear las particiones, sino existen    
    FOR r in (SELECT DISTINCT v.periodo_factura periodo
              FROM suirplus.ars_carga_cartera_v v
              MINUS
              SELECT to_char(to_date(substr(Partition_name, 2, 6), 'mmyyyy'),'yyyymm') periodo
              FROM ALL_TAB_PARTITIONS a
              WHERE a.TABLE_NAME = 'ARS_CARTERA_T') LOOP
      suirplus.job_ejecuciones_pkg.mohave_Crea_Partition(r.periodo, 'ARS_CARTERA_T');     
    END LOOP;          
  
    m_hora_inicio := sysdate;
    debug('Total de registros a procesar cartera - iniciado a las '||to_char(m_hora_inicio,'dd/mm/yyyy hh:mi:ss am'));
    p_result     := 'ERROR'; -- Se asume error hasta tanto no halla pasado TODAS las validaciones.
    m_validacion := 0;

    --obtener el total de registros a procesar
    select count(*) into m_registros from ars_carga_cartera_v a;

    m_hora_termina := sysdate;
    debug('Total de registros a procesar cartera - terminado a las '||to_char(m_hora_termina,'dd/mm/yyyy hh:mi:ss am')||
          ' - Tiempo total: ('||
          TRIM(TO_CHAR(EXTRACT(HOUR FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
          TRIM(TO_CHAR(EXTRACT(MINUTE FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
          TRIM(TO_CHAR(EXTRACT(SECOND FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||
          ') - registros a procesar: ' || m_registros);

    -- validar ars
    m_validacion := 1;

    m_hora_inicio := sysdate;
    debug('Cartera: validacion #'||m_validacion||' - iniciada a las '||to_char(m_hora_inicio,'dd/mm/yyyy hh:mi:ss'));

    insert into suirplus.ars_cartera_con_errores_t
      select codigo_ars,
             periodo_factura,
             tipo_afiliado,
             cedula_titular,
             nss_titular,
             cedula_dependiente,
             nss_dependiente,
             estatus_afiliado,
             codigo_parentesco,
             discapacitado,
             estudiante,
             m_validacion,
             m_hoy,
             m_carga_seq
        from ars_carga_cartera_v a
       where m_codigos_ars not like '%,' || nvl(a.codigo_ars, 0) || ',%';

    m_hora_termina := sysdate;
    debug('Cartera: validacion #'||m_validacion||' - terminada a las '||to_char(m_hora_termina,'dd/mm/yyyy hh:mi:ss')||
          ' - Tiempo total: ('||
          TRIM(TO_CHAR(EXTRACT(HOUR FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
          TRIM(TO_CHAR(EXTRACT(MINUTE FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
          TRIM(TO_CHAR(EXTRACT(SECOND FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||
          ') - total registros: '|| sql%rowcount);
          
    commit;

    -- validar periodo menor que la fecha de nacimiento del afiliado
    m_validacion := 2;

    m_hora_inicio := sysdate;
    debug('Cartera: validacion #'||m_validacion||' - iniciada a las '||to_char(m_hora_inicio,'dd/mm/yyyy hh:mi:ss'));

    insert into suirplus.ars_cartera_con_errores_t
      select codigo_ars,
             periodo_factura,
             tipo_afiliado,
             cedula_titular,
             nss_titular,
             cedula_dependiente,
             nss_dependiente,
             estatus_afiliado,
             codigo_parentesco,
             discapacitado,
             estudiante,
             m_validacion,
             m_hoy,
             m_carga_seq
        from ars_carga_cartera_v a
        join sre_ciudadanos_t b
          on b.id_nss = nss_dependiente
       where a.ciclo != '3'
         and a.periodo_factura < to_char(add_months(b.fecha_nacimiento, -1), 'YYYYMM');

    m_hora_termina := sysdate;
    debug('Cartera: validacion #'||m_validacion||' - terminada a las '||to_char(m_hora_termina,'dd/mm/yyyy hh:mi:ss')||
          ' - Tiempo total: ('||
          TRIM(TO_CHAR(EXTRACT(HOUR FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
          TRIM(TO_CHAR(EXTRACT(MINUTE FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
          TRIM(TO_CHAR(EXTRACT(SECOND FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||
          ') - total registros: '|| sql%rowcount);

    commit;

    -- validar ars inactivas
    m_validacion := 25;
    
    m_hora_inicio := sysdate;
    debug('Cartera: validacion #'||m_validacion||' - iniciada a las '||to_char(m_hora_inicio,'dd/mm/yyyy hh:mi:ss'));
    
    insert into suirplus.ars_cartera_con_errores_t
      select codigo_ars,
             periodo_factura,
             tipo_afiliado,
             cedula_titular,
             nss_titular,
             cedula_dependiente,
             nss_dependiente,
             estatus_afiliado,
             codigo_parentesco,
             discapacitado,
             estudiante,
             m_validacion,
             m_hoy,
             m_carga_seq
        from ars_carga_cartera_v a
       where m_codigos_ars_inactivas like
             '%,' || nvl(a.codigo_ars, 0) || ',%';

    m_hora_termina := sysdate;
    debug('Cartera: validacion #'||m_validacion||' - terminada a las '||to_char(m_hora_termina,'dd/mm/yyyy hh:mi:ss')||
          ' - Tiempo total: ('||
          TRIM(TO_CHAR(EXTRACT(HOUR FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
          TRIM(TO_CHAR(EXTRACT(MINUTE FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
          TRIM(TO_CHAR(EXTRACT(SECOND FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||
          ') - total registros: '|| sql%rowcount);

    commit;

    -- validar tipo de afiliado
    m_validacion := 3;

    m_hora_inicio := sysdate;
    debug('Cartera: validacion #'||m_validacion||' - iniciada a las '||to_char(m_hora_inicio,'dd/mm/yyyy hh:mi:ss'));

    insert into suirplus.ars_cartera_con_errores_t
      select codigo_ars,
             periodo_factura,
             tipo_afiliado,
             cedula_titular,
             nss_titular,
             cedula_dependiente,
             nss_dependiente,
             estatus_afiliado,
             codigo_parentesco,
             discapacitado,
             estudiante,
             m_validacion,
             m_hoy,
             m_carga_seq
        from ars_carga_cartera_v a
       where nvl(a.tipo_afiliado, 'X') not in ('T', 'D', 'A');

    m_hora_termina := sysdate;
    debug('Cartera: validacion #'||m_validacion||' - terminada a las '||to_char(m_hora_termina,'dd/mm/yyyy hh:mi:ss')||
          ' - Tiempo total: ('||
          TRIM(TO_CHAR(EXTRACT(HOUR FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
          TRIM(TO_CHAR(EXTRACT(MINUTE FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
          TRIM(TO_CHAR(EXTRACT(SECOND FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||
          ') - total registros: '|| sql%rowcount);

    commit;

    -- validar estatus afiliado
    m_validacion := 6;

    m_hora_inicio := sysdate;
    debug('Cartera: validacion #'||m_validacion||' - iniciada a las '||to_char(m_hora_inicio,'dd/mm/yyyy hh:mi:ss'));

    insert into suirplus.ars_cartera_con_errores_t
      select codigo_ars,
             periodo_factura,
             tipo_afiliado,
             cedula_titular,
             nss_titular,
             cedula_dependiente,
             nss_dependiente,
             estatus_afiliado,
             codigo_parentesco,
             discapacitado,
             estudiante,
             m_validacion,
             m_hoy,
             m_carga_seq
        from ars_carga_cartera_v a
       where nvl(a.estatus_afiliado, 'X') not in ('AC', 'PE');

    m_hora_termina := sysdate;
    debug('Cartera: validacion #'||m_validacion||' - terminada a las '||to_char(m_hora_termina,'dd/mm/yyyy hh:mi:ss')||
          ' - Tiempo total: ('||
          TRIM(TO_CHAR(EXTRACT(HOUR FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
          TRIM(TO_CHAR(EXTRACT(MINUTE FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
          TRIM(TO_CHAR(EXTRACT(SECOND FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||
          ') - total registros: '|| sql%rowcount);

    commit;

    -- validar discapacitado
    m_validacion := 7;

    m_hora_inicio := sysdate;
    debug('Cartera: validacion #'||m_validacion||' - iniciada a las '||to_char(m_hora_inicio,'dd/mm/yyyy hh:mi:ss'));

    insert into suirplus.ars_cartera_con_errores_t
      select codigo_ars,
             periodo_factura,
             tipo_afiliado,
             cedula_titular,
             nss_titular,
             cedula_dependiente,
             nss_dependiente,
             estatus_afiliado,
             codigo_parentesco,
             discapacitado,
             estudiante,
             m_validacion,
             m_hoy,
             m_carga_seq
        from ars_carga_cartera_v a
       where nvl(a.discapacitado, 'X') not in ('S', 'N');

    m_hora_termina := sysdate;
    debug('Cartera: validacion #'||m_validacion||' - terminada a las '||to_char(m_hora_termina,'dd/mm/yyyy hh:mi:ss')||
          ' - Tiempo total: ('||
          TRIM(TO_CHAR(EXTRACT(HOUR FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
          TRIM(TO_CHAR(EXTRACT(MINUTE FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
          TRIM(TO_CHAR(EXTRACT(SECOND FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||
          ') - total registros: '|| sql%rowcount);

    commit;

    -- validar estudiante
    m_validacion := 8;

    m_hora_inicio := sysdate;
    debug('Cartera: validacion #'||m_validacion||' - iniciada a las '||to_char(m_hora_inicio,'dd/mm/yyyy hh:mi:ss'));

    insert into suirplus.ars_cartera_con_errores_t
      select codigo_ars,
             periodo_factura,
             tipo_afiliado,
             cedula_titular,
             nss_titular,
             cedula_dependiente,
             nss_dependiente,
             estatus_afiliado,
             codigo_parentesco,
             discapacitado,
             estudiante,
             m_validacion,
             m_hoy,
             m_carga_seq
        from ars_carga_cartera_v a
       where nvl(a.estudiante, 'X') not in ('S', 'N');

    m_hora_termina := sysdate;
    debug('Cartera: validacion #'||m_validacion||' - terminada a las '||to_char(m_hora_termina,'dd/mm/yyyy hh:mi:ss')||
          ' - Tiempo total: ('||
          TRIM(TO_CHAR(EXTRACT(HOUR FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
          TRIM(TO_CHAR(EXTRACT(MINUTE FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
          TRIM(TO_CHAR(EXTRACT(SECOND FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||
          ') - total registros: '|| sql%rowcount);

    commit;

    -- validar parentesco
    m_validacion := 9;

    m_hora_inicio := sysdate;
    debug('Cartera: validacion #'||m_validacion||' - iniciada a las '||to_char(m_hora_inicio,'dd/mm/yyyy hh:mi:ss'));

    insert into suirplus.ars_cartera_con_errores_t
      select codigo_ars,
             periodo_factura,
             tipo_afiliado,
             cedula_titular,
             nss_titular,
             cedula_dependiente,
             nss_dependiente,
             estatus_afiliado,
             codigo_parentesco,
             discapacitado,
             estudiante,
             m_validacion,
             m_hoy,
             m_carga_seq
        from ars_carga_cartera_v a
       where not ((a.tipo_afiliado = 'T' and a.codigo_parentesco = '0') or
              (a.tipo_afiliado = 'A' and
               a.codigo_parentesco in ('1',
                                       '01',
                                       '2',
                                       '02',
                                       '5',
                                       '05',
                                       '6',
                                       '06',
                                       '17',
                                       '18',
                                       '21',
                                       '22')) or
              (a.tipo_afiliado = 'D' and
               a.codigo_parentesco in ('3',
                                       '03',
                                       '4',
                                       '04',
                                       '5',
                                       '05',
                                       '6',
                                       '06',
                                       '17',
                                       '18',
                                       '19',
                                       '20')));

    m_hora_termina := sysdate;
    debug('Cartera: validacion #'||m_validacion||' - terminada a las '||to_char(m_hora_termina,'dd/mm/yyyy hh:mi:ss')||
          ' - Tiempo total: ('||
          TRIM(TO_CHAR(EXTRACT(HOUR FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
          TRIM(TO_CHAR(EXTRACT(MINUTE FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
          TRIM(TO_CHAR(EXTRACT(SECOND FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||
          ') - total registros: '|| sql%rowcount);

    commit;

    -- validar "conyuge divorcio"
    -- GHERRERA: 06-MAY-2013
    m_validacion := 9;

    m_hora_inicio := sysdate;
    debug('Cartera: validacion #'||m_validacion||' - iniciada a las '||to_char(m_hora_inicio,'dd/mm/yyyy hh:mi:ss'));

    insert into suirplus.ars_cartera_con_errores_t
      select codigo_ars,
             periodo_factura,
             tipo_afiliado,
             cedula_titular,
             nss_titular,
             cedula_dependiente,
             nss_dependiente,
             estatus_afiliado,
             codigo_parentesco,
             discapacitado,
             estudiante,
             m_validacion,
             m_hoy,
             m_carga_seq
        from suirplus.ars_carga_cartera_v a
       where a.tipo_afiliado = 'D'
         and a.codigo_parentesco = '20'
         and (--Existe previamente en cartera como "conyuge divorcio"
              --No cambiar por la setencia NOT EXISTS, el count es mas rapido
              0 < (select count(*)
                     from suirplus.ars_cartera_t b
                     where b.nss_titular=a.nss_titular
                       and b.nss_dependiente=a.nss_dependiente
                       and b.tipo_afiliado=a.tipo_afiliado
                       and b.codigo_parentesco=a.codigo_parentesco
                   )
              OR
              --Esta duplicado en este envío
              1 < (select count(*)
                   from suirplus.ars_carga_cartera_v c
                   where c.nss_titular=a.nss_titular
                     and c.nss_dependiente=a.nss_dependiente
                     and c.tipo_afiliado=a.tipo_afiliado
                     and c.codigo_parentesco=a.codigo_parentesco
                   )
              );

    m_hora_termina := sysdate;
    debug('Cartera: validacion #'||m_validacion||' - terminada a las '||to_char(m_hora_termina,'dd/mm/yyyy hh:mi:ss')||
          ' - Tiempo total: ('||
          TRIM(TO_CHAR(EXTRACT(HOUR FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
          TRIM(TO_CHAR(EXTRACT(MINUTE FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
          TRIM(TO_CHAR(EXTRACT(SECOND FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||
          ') - total registros: '|| sql%rowcount);

    commit;

    -- si codigo parentesco es 1, el sexo del Padre (Adicional) debe ser masculino
    -- GHERRERA: 23-APR-2014
    m_validacion := 41;

    m_hora_inicio := sysdate;
    debug('Cartera: validacion #'||m_validacion||' - iniciada a las '||to_char(m_hora_inicio,'dd/mm/yyyy hh:mi:ss'));

    insert into suirplus.ars_cartera_con_errores_t
      select codigo_ars,
             periodo_factura,
             tipo_afiliado,
             cedula_titular,
             nss_titular,
             cedula_dependiente,
             nss_dependiente,
             estatus_afiliado,
             codigo_parentesco,
             discapacitado,
             estudiante,
             m_validacion,
             m_hoy,
             m_carga_seq
        from suirplus.ars_carga_cartera_v a
       where a.codigo_parentesco = '1'
         --debe ser masculino
         and 0 < (select count(*)
                    from suirplus.sre_ciudadanos_t c
                   where c.id_nss = a.nss_dependiente
                     and NVL(c.sexo,'~') != 'M' );

    m_hora_termina := sysdate;
    debug('Cartera: validacion #'||m_validacion||' - terminada a las '||to_char(m_hora_termina,'dd/mm/yyyy hh:mi:ss')||
          ' - Tiempo total: ('||
          TRIM(TO_CHAR(EXTRACT(HOUR FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
          TRIM(TO_CHAR(EXTRACT(MINUTE FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
          TRIM(TO_CHAR(EXTRACT(SECOND FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||
          ') - total registros: '|| sql%rowcount);

    commit;

    -- validacion 7.1
    -- que rechace cualquier ciudadano cancelado (excepto por muerte)
    m_validacion := 37;

    m_hora_inicio := sysdate;
    debug('Cartera: validacion #'||m_validacion||' - iniciada a las '||to_char(m_hora_inicio,'dd/mm/yyyy hh:mi:ss'));

    insert into suirplus.ars_cartera_con_errores_t
      select codigo_ars,
             periodo_factura,
             tipo_afiliado,
             cedula_titular,
             nss_titular,
             cedula_dependiente,
             nss_dependiente,
             estatus_afiliado,
             codigo_parentesco,
             discapacitado,
             estudiante,
             m_validacion,
             m_hoy,
             m_carga_seq
        from ars_carga_cartera_v a
       where SUIRPLUS.SRE_CIUDADANO_INACTIVO_F(nvl(a.nss_dependiente, a.nss_titular), TO_NUMBER(a.periodo_factura)) = 'N'; -- No se debe pagar la cápita

    m_hora_termina := sysdate;
    debug('Cartera: validacion #'||m_validacion||' - terminada a las '||to_char(m_hora_termina,'dd/mm/yyyy hh:mi:ss')||
          ' - Tiempo total: ('||
          TRIM(TO_CHAR(EXTRACT(HOUR FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
          TRIM(TO_CHAR(EXTRACT(MINUTE FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
          TRIM(TO_CHAR(EXTRACT(SECOND FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||
          ') - total registros: '|| sql%rowcount);

    commit;

    -- validar dependiente
    m_validacion := 5;

    m_hora_inicio := sysdate;
    debug('Cartera: validacion #'||m_validacion||' - iniciada a las '||to_char(m_hora_inicio,'dd/mm/yyyy hh:mi:ss'));

    insert into suirplus.ars_cartera_con_errores_t
      select codigo_ars,
             periodo_factura,
             tipo_afiliado,
             cedula_titular,
             nss_titular,
             cedula_dependiente,
             nss_dependiente,
             estatus_afiliado,
             codigo_parentesco,
             discapacitado,
             estudiante,
             m_validacion,
             m_hoy,
             m_carga_seq
        from ars_carga_cartera_v a
       where a.tipo_afiliado <> 'T'
         AND NOT EXISTS
         (Select 1
            From suirplus.sre_ciudadanos_t c
           Where c.id_nss = a.nss_dependiente
             And (
                  -- No validar los conyuges directos
                  (a.tipo_afiliado = 'D' and NVL(a.codigo_parentesco, 0) IN(19, 20, 3, 4) ) OR 
                  -- No validar los abuelos adicionales
                  (a.tipo_afiliado = 'A' and NVL(a.codigo_parentesco, 0) IN(1, 2, 21, 22) ) OR 
                  -- No validar los discapacitados directos
                  (a.tipo_afiliado = 'D' and NVL(a.discapacitado, 'N') = 'S') OR
                  -- Si es Estudiante directo debe ser menor de 21 de edad
                  (
                   a.tipo_afiliado = 'D' and 
                   MONTHS_BETWEEN(TO_DATE(a.periodo_factura,'yyyymm'), c.fecha_nacimiento ) / 12 < 22 and 
                   NVL(a.estudiante, 'N') = 'S'
                  ) OR
                  -- Si no es Estudiante directo debe ser Menor de 18 de Edad
                  (
                   a.tipo_afiliado = 'D' and 
                   MONTHS_BETWEEN(TO_DATE(a.periodo_factura,'yyyymm'), c.fecha_nacimiento ) / 12 < 18 and
                   NVL(a.estudiante, 'N') = 'N'
                  ) OR
                  -- Adicional mayor de 18 de edad    
                  (
                   a.tipo_afiliado = 'A' and 
                   MONTHS_BETWEEN(TO_DATE(a.periodo_factura,'yyyymm'), c.fecha_nacimiento ) / 12 > 18 and 
                   NVL(a.estudiante, 'N') = 'N'
                  )
                 )
         );

    m_hora_termina := sysdate;
    debug('Cartera: validacion #'||m_validacion||' - terminada a las '||to_char(m_hora_termina,'dd/mm/yyyy hh:mi:ss')||
          ' - Tiempo total: ('||
          TRIM(TO_CHAR(EXTRACT(HOUR FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
          TRIM(TO_CHAR(EXTRACT(MINUTE FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
          TRIM(TO_CHAR(EXTRACT(SECOND FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||
          ') - total registros: '|| sql%rowcount);

    commit;

    -- validar dependiente tengan titular
    m_validacion := 11;

    m_hora_inicio := sysdate;
    debug('Cartera: validacion #'||m_validacion||' - iniciada a las '||to_char(m_hora_inicio,'dd/mm/yyyy hh:mi:ss'));

    insert into suirplus.ars_cartera_con_errores_t
      select codigo_ars,
             periodo_factura,
             tipo_afiliado,
             cedula_titular,
             nss_titular,
             cedula_dependiente,
             nss_dependiente,
             estatus_afiliado,
             codigo_parentesco,
             discapacitado,
             estudiante,
             m_validacion,
             m_hoy,
             m_carga_seq
        from ars_carga_cartera_v a
       where a.tipo_afiliado in ('D', 'A')
      minus
      -- Buscar solo en este envio
      select a.codigo_ars,
             a.periodo_factura,
             a.tipo_afiliado,
             a.cedula_titular,
             a.nss_titular,
             a.cedula_dependiente,
             a.nss_dependiente,
             a.estatus_afiliado,
             a.codigo_parentesco,
             a.discapacitado,
             a.estudiante,
             m_validacion,
             m_hoy,
             m_carga_seq
        from ars_carga_cartera_v a
        join ars_carga_cartera_v b
          on b.codigo_ars = a.codigo_ars
         and b.tipo_afiliado = 'T'
         and b.nss_titular = a.nss_titular
       where a.tipo_afiliado in ('D', 'A')
      -- Buscar en este envio y en la cartera (por ars, periodo y titular)
      minus
      select codigo_ars,
             periodo_factura,
             tipo_afiliado,
             cedula_titular,
             nss_titular,
             cedula_dependiente,
             nss_dependiente,
             estatus_afiliado,
             codigo_parentesco,
             discapacitado,
             estudiante,
             m_validacion,
             m_hoy,
             m_carga_seq
        from ars_carga_cartera_v a
       where exists (select 1
                from suirplus.ars_cartera_t c
               where c.id_ars = a.codigo_ars
                 and c.periodo_factura_ars = a.periodo_factura
                 and c.nss_titular = a.nss_titular
                 and c.tipo_afiliado = 'T')
         and a.tipo_afiliado in ('D', 'A');

    m_hora_termina := sysdate;
    debug('Cartera: validacion #'||m_validacion||' - terminada a las '||to_char(m_hora_termina,'dd/mm/yyyy hh:mi:ss')||
          ' - Tiempo total: ('||
          TRIM(TO_CHAR(EXTRACT(HOUR FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
          TRIM(TO_CHAR(EXTRACT(MINUTE FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
          TRIM(TO_CHAR(EXTRACT(SECOND FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||
          ') - total registros: '|| sql%rowcount);

    commit;

    -- validar titular no pueder ser dependiente
    m_validacion := 13;

    m_hora_inicio := sysdate;
    debug('Cartera: validacion #'||m_validacion||' - iniciada a las '||to_char(m_hora_inicio,'dd/mm/yyyy hh:mi:ss'));

    insert into suirplus.ars_cartera_con_errores_t
    -- Buscar solo en este envio
      select a.codigo_ars,
             a.periodo_factura,
             a.tipo_afiliado,
             a.cedula_titular,
             a.nss_titular,
             a.cedula_dependiente,
             a.nss_dependiente,
             a.estatus_afiliado,
             a.codigo_parentesco,
             a.discapacitado,
             a.estudiante,
             m_validacion,
             m_hoy,
             m_carga_seq
        from ars_carga_cartera_v a
        join ars_carga_cartera_v b
          on a.tipo_afiliado = 'T'
         and b.tipo_afiliado in ('A', 'D')
         and a.nss_titular = b.nss_dependiente
         and a.periodo_factura = b.periodo_factura
      union
      -- Buscar en este envio y en la cartera (Buscar los dependientes por periodo y NSS de los titulares)
      select /*+ FIRST_ROWS */
       codigo_ars,
       periodo_factura,
       tipo_afiliado,
       cedula_titular,
       nss_titular,
       cedula_dependiente,
       nss_dependiente,
       estatus_afiliado,
       codigo_parentesco,
       discapacitado,
       estudiante,
       m_validacion,
       m_hoy,
       m_carga_seq
        from ars_carga_cartera_v c
       where exists (select 1
                from suirplus.ars_cartera_t cartera
               where cartera.periodo_factura_ars = c.periodo_factura
                 and cartera.nss_dependiente = c.nss_dependiente
                 and cartera.tipo_afiliado = 'T')
         and c.tipo_afiliado in ('A', 'D')
      union
      -- Buscar en este envio y en la cartera (Buscar los titulares por Periodo y NSS de los Dependiente)
      select /*+ FIRST_ROWS */
       codigo_ars,
       periodo_factura,
       tipo_afiliado,
       cedula_titular,
       nss_titular,
       cedula_dependiente,
       nss_dependiente,
       estatus_afiliado,
       codigo_parentesco,
       discapacitado,
       estudiante,
       m_validacion,
       m_hoy,
       m_carga_seq
        from ars_carga_cartera_v c
       where exists (select 1
                from suirplus.ars_cartera_t cartera
               where cartera.periodo_factura_ars = c.periodo_factura
                 and cartera.nss_dependiente = c.nss_dependiente
                 and cartera.tipo_afiliado in ('A', 'D'))
         and c.tipo_afiliado = 'T';

    m_hora_termina := sysdate;
    debug('Cartera: validacion #'||m_validacion||' - terminada a las '||to_char(m_hora_termina,'dd/mm/yyyy hh:mi:ss')||
          ' - Tiempo total: ('||
          TRIM(TO_CHAR(EXTRACT(HOUR FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
          TRIM(TO_CHAR(EXTRACT(MINUTE FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
          TRIM(TO_CHAR(EXTRACT(SECOND FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||
          ') - total registros: '|| sql%rowcount);

    commit;

    -- validar nucleo familiar en unica ars
    m_validacion := 12;

    m_hora_inicio := sysdate;
    debug('Cartera: validacion #'||m_validacion||' - iniciada a las '||to_char(m_hora_inicio,'dd/mm/yyyy hh:mi:ss'));

    insert into suirplus.ars_cartera_con_errores_t
    -- Buscar solo en este envio
      select codigo_ars,
             periodo_factura,
             tipo_afiliado,
             cedula_titular,
             nss_titular,
             cedula_dependiente,
             nss_dependiente,
             estatus_afiliado,
             codigo_parentesco,
             discapacitado,
             estudiante,
             m_validacion,
             m_hoy,
             m_carga_seq
        from ars_carga_cartera_v a
       where (a.nss_titular, a.periodo_factura) in
             (select b.nss_titular, b.periodo_factura
                from ars_carga_cartera_v b
               group by b.nss_titular, b.periodo_factura
              having count(distinct b.codigo_ars) > 1)
      union
      -- Buscar en este envio y en la cartera (por periodo y titular)
      select codigo_ars,
             periodo_factura,
             tipo_afiliado,
             cedula_titular,
             nss_titular,
             cedula_dependiente,
             nss_dependiente,
             estatus_afiliado,
             codigo_parentesco,
             discapacitado,
             estudiante,
             m_validacion,
             m_hoy,
             m_carga_seq
        from ars_carga_cartera_v a
       where (a.nss_titular, a.periodo_factura) in
             (select b.nss_titular, b.periodo_factura
                from ars_carga_cartera_v b, suirplus.ars_cartera_t c
               where c.periodo_factura_ars = b.periodo_factura
                 and c.nss_titular = b.nss_titular
               group by b.nss_titular, b.periodo_factura
              having count(distinct b.codigo_ars) > 1);

    m_hora_termina := sysdate;
    debug('Cartera: validacion #'||m_validacion||' - terminada a las '||to_char(m_hora_termina,'dd/mm/yyyy hh:mi:ss')||
          ' - Tiempo total: ('||
          TRIM(TO_CHAR(EXTRACT(HOUR FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
          TRIM(TO_CHAR(EXTRACT(MINUTE FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
          TRIM(TO_CHAR(EXTRACT(SECOND FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||
          ') - total registros: '|| sql%rowcount);

    commit;

    -- RP: 2008-11-04
    -- NSS Cancelado o con 777 en municipio.
    -- C13: Resolucion 192-04 CNSS
    m_validacion := 26;

    m_hora_inicio := sysdate;
    debug('Cartera: validacion #'||m_validacion||' - iniciada a las '||to_char(m_hora_inicio,'dd/mm/yyyy hh:mi:ss'));

    insert into suirplus.ars_cartera_con_errores_t
      select codigo_ars,
             periodo_factura,
             tipo_afiliado,
             cedula_titular,
             nss_titular,
             cedula_dependiente,
             nss_dependiente,
             estatus_afiliado,
             codigo_parentesco,
             discapacitado,
             estudiante,
             m_validacion,
             m_hoy,
             m_carga_seq
        from ars_carga_cartera_v a
       where exists
       (
        select 1
          from suirplus.sre_ciudadanos_t c
         where c.id_nss = nvl(a.nss_dependiente, a.nss_titular)
           and c.municipio_acta = 777
       );

    m_hora_termina := sysdate;
    debug('Cartera: validacion #'||m_validacion||' - terminada a las '||to_char(m_hora_termina,'dd/mm/yyyy hh:mi:ss')||
          ' - Tiempo total: ('||
          TRIM(TO_CHAR(EXTRACT(HOUR FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
          TRIM(TO_CHAR(EXTRACT(MINUTE FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
          TRIM(TO_CHAR(EXTRACT(SECOND FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||
          ') - total registros: '|| sql%rowcount);

    commit;

    -- validar registros duplicados
    m_validacion := 10;

    m_hora_inicio := sysdate;
    debug('Cartera: validacion #'||m_validacion||' - iniciada a las '||to_char(m_hora_inicio,'dd/mm/yyyy hh:mi:ss'));

    insert into suirplus.ars_cartera_con_errores_t
    -- Verificar si para este envio esta repetido
    -- Modificado 27-08-2008
      with duplicados as
       (select b.periodo_factura,
               nvl(b.nss_dependiente, b.nss_titular) nss_dependiente
          from ars_carga_cartera_v b
         group by b.periodo_factura, nvl(b.nss_dependiente, b.nss_titular)
        having count(*) > 1)
      select /*+ first_rows */
       a.codigo_ars,
       a.periodo_factura,
       a.tipo_afiliado,
       a.cedula_titular,
       a.nss_titular,
       a.cedula_dependiente,
       a.nss_dependiente,
       a.estatus_afiliado,
       a.codigo_parentesco,
       a.discapacitado,
       a.estudiante,
       m_validacion,
       m_hoy,
       m_carga_seq
        from ars_carga_cartera_v a
        left join duplicados
          on duplicados.periodo_factura = a.periodo_factura
         and duplicados.nss_dependiente =
             nvl(a.nss_dependiente, a.nss_titular)
        left join suirplus.ars_cartera_t c
          on c.periodo_factura_ars = a.periodo_factura
         and c.nss_dependiente =
             decode(a.tipo_afiliado, 'T', a.nss_titular, a.nss_dependiente)
       where duplicados.periodo_factura is not null
          or c.periodo_factura_ars is not null;

    m_hora_termina := sysdate;
    debug('Cartera: validacion #'||m_validacion||' - terminada a las '||to_char(m_hora_termina,'dd/mm/yyyy hh:mi:ss')||
          ' - Tiempo total: ('||
          TRIM(TO_CHAR(EXTRACT(HOUR FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
          TRIM(TO_CHAR(EXTRACT(MINUTE FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
          TRIM(TO_CHAR(EXTRACT(SECOND FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||
          ') - total registros: '|| sql%rowcount);

    commit;

    -- para recien nacidos. TODOS LOS CICLOS
    -- Evaluar los 60 dias de cobertura. considerar 59 dias ya que se incluye en dia de nacimiento.
    m_validacion := 34;

    m_hora_inicio := sysdate;
    debug('Cartera: validacion #'||m_validacion||' - iniciada a las '||to_char(m_hora_inicio,'dd/mm/yyyy hh:mi:ss'));

    insert into suirplus.ars_cartera_con_errores_t
      select codigo_ars,
             periodo_factura,
             tipo_afiliado,
             cedula_titular,
             nss_titular,
             cedula_dependiente,
             nss_dependiente,
             estatus_afiliado,
             codigo_parentesco,
             discapacitado,
             estudiante,
             m_validacion,
             m_hoy,
             m_carga_seq
        from ars_carga_cartera_v a
        join sre_ciudadanos_t b
          on b.id_nss = nss_dependiente
         and a.periodo_factura not between
             to_char(add_months(b.fecha_nacimiento, -1), 'YYYYMM') and
             to_char(add_months(b.fecha_nacimiento + 59, -1), 'YYYYMM')
       where a.ciclo = '3'
         and not exists
       (select 1
                from suirplus.ars_cartera_t c
               where c.nss_dependiente = a.nss_dependiente);

    m_hora_termina := sysdate;
    debug('Cartera: validacion #'||m_validacion||' - terminada a las '||to_char(m_hora_termina,'dd/mm/yyyy hh:mi:ss')||
          ' - Tiempo total: ('||
          TRIM(TO_CHAR(EXTRACT(HOUR FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
          TRIM(TO_CHAR(EXTRACT(MINUTE FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
          TRIM(TO_CHAR(EXTRACT(SECOND FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||
          ') - total registros: '|| sql%rowcount);

    commit;

    -- si codigo parentesco es 2, el sexo de la Madre (Adicional) debe ser femenino
    -- GHERRERA: 23-APR-2014
    m_validacion := 42;

    m_hora_inicio := sysdate;
    debug('Cartera: validacion #'||m_validacion||' - iniciada a las '||to_char(m_hora_inicio,'dd/mm/yyyy hh:mi:ss'));

    insert into suirplus.ars_cartera_con_errores_t
      select codigo_ars,
             periodo_factura,
             tipo_afiliado,
             cedula_titular,
             nss_titular,
             cedula_dependiente,
             nss_dependiente,
             estatus_afiliado,
             codigo_parentesco,
             discapacitado,
             estudiante,
             m_validacion,
             m_hoy,
             m_carga_seq
        from suirplus.ars_carga_cartera_v a
       where a.codigo_parentesco = '2'
         --debe ser femenino
         and 0 < (select count(*)
                    from suirplus.sre_ciudadanos_t c
                   where c.id_nss = a.nss_dependiente
                     and NVL(c.sexo,'~') != 'F'
                  );

    m_hora_termina := sysdate;
    debug('Cartera: validacion #'||m_validacion||' - terminada a las '||to_char(m_hora_termina,'dd/mm/yyyy hh:mi:ss')||
          ' - Tiempo total: ('||
          TRIM(TO_CHAR(EXTRACT(HOUR FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
          TRIM(TO_CHAR(EXTRACT(MINUTE FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
          TRIM(TO_CHAR(EXTRACT(SECOND FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||
          ') - total registros: '|| sql%rowcount);

    commit;

    -- si codigo parentesco = 3, Sexo del Conyuge - Esposo debe ser masculino y el del titular debe ser femenino
    -- GHERRERA: 23-APR-2014
    m_validacion := 43;

    m_hora_inicio := sysdate;
    debug('Cartera: validacion #'||m_validacion||' - iniciada a las '||to_char(m_hora_inicio,'dd/mm/yyyy hh:mi:ss'));

    insert into suirplus.ars_cartera_con_errores_t
      select codigo_ars,
             periodo_factura,
             tipo_afiliado,
             cedula_titular,
             nss_titular,
             cedula_dependiente,
             nss_dependiente,
             estatus_afiliado,
             codigo_parentesco,
             discapacitado,
             estudiante,
             m_validacion,
             m_hoy,
             m_carga_seq
        from suirplus.ars_carga_cartera_v a
       where a.codigo_parentesco = '3'
         --dependiente debe ser masculino
         and 1 > (select count(*)
                    from suirplus.sre_ciudadanos_t c
                   where c.id_nss = a.nss_dependiente
                     and NVL(c.sexo,'~') = 'M'
                  )
         --titular debe ser femenino 
         and 1 > (select count(*)
                    from suirplus.sre_ciudadanos_t c
                   where c.id_nss = a.nss_titular
                     and NVL(c.sexo,'~') = 'F'
                  );

    m_hora_termina := sysdate;
    debug('Cartera: validacion #'||m_validacion||' - terminada a las '||to_char(m_hora_termina,'dd/mm/yyyy hh:mi:ss')||
          ' - Tiempo total: ('||
          TRIM(TO_CHAR(EXTRACT(HOUR FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
          TRIM(TO_CHAR(EXTRACT(MINUTE FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
          TRIM(TO_CHAR(EXTRACT(SECOND FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||
          ') - total registros: '|| sql%rowcount);

    commit;

    -- si codigo parentesco = 4, sexo del Conyuge - Esposa debe ser femenino y el del titular debe ser masculino
    -- GHERRERA: 23-APR-2014
    m_validacion := 44;

    m_hora_inicio := sysdate;
    debug('Cartera: validacion #'||m_validacion||' - iniciada a las '||to_char(m_hora_inicio,'dd/mm/yyyy hh:mi:ss'));

    insert into suirplus.ars_cartera_con_errores_t
      select codigo_ars,
             periodo_factura,
             tipo_afiliado,
             cedula_titular,
             nss_titular,
             cedula_dependiente,
             nss_dependiente,
             estatus_afiliado,
             codigo_parentesco,
             discapacitado,
             estudiante,
             m_validacion,
             m_hoy,
             m_carga_seq
        from suirplus.ars_carga_cartera_v a
       where a.codigo_parentesco = '4'
         --dependiente debe ser masculino
         and 1 > (select count(*)
                    from suirplus.sre_ciudadanos_t c
                   where c.id_nss = a.nss_dependiente
                     and NVL(c.sexo,'~') = 'F'
                  )
         --titular debe ser femenino 
         and 1 > (select count(*)
                    from suirplus.sre_ciudadanos_t c
                   where c.id_nss = a.nss_titular
                     and NVL(c.sexo,'~') = 'M'
                  );

    m_hora_termina := sysdate;
    debug('Cartera: validacion #'||m_validacion||' - terminada a las '||to_char(m_hora_termina,'dd/mm/yyyy hh:mi:ss')||
          ' - Tiempo total: ('||
          TRIM(TO_CHAR(EXTRACT(HOUR FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
          TRIM(TO_CHAR(EXTRACT(MINUTE FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
          TRIM(TO_CHAR(EXTRACT(SECOND FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||
          ') - total registros: '|| sql%rowcount);

    commit;

    -- si codigo parentesco es 5, el sexo del Hijo debe ser masculino
    -- GHERRERA: 23-APR-2014
    m_validacion := 45;

    m_hora_inicio := sysdate;
    debug('Cartera: validacion #'||m_validacion||' - iniciada a las '||to_char(m_hora_inicio,'dd/mm/yyyy hh:mi:ss'));

    insert into suirplus.ars_cartera_con_errores_t
      select codigo_ars,
             periodo_factura,
             tipo_afiliado,
             cedula_titular,
             nss_titular,
             cedula_dependiente,
             nss_dependiente,
             estatus_afiliado,
             codigo_parentesco,
             discapacitado,
             estudiante,
             m_validacion,
             m_hoy,
             m_carga_seq
        from suirplus.ars_carga_cartera_v a
       where a.codigo_parentesco = '5'
         --debe ser masculino
         and 0 < (select count(*)
                    from suirplus.sre_ciudadanos_t c
                   where c.id_nss = a.nss_dependiente
                     and NVL(c.sexo,'~') != 'M'
                  );

    m_hora_termina := sysdate;
    debug('Cartera: validacion #'||m_validacion||' - terminada a las '||to_char(m_hora_termina,'dd/mm/yyyy hh:mi:ss')||
          ' - Tiempo total: ('||
          TRIM(TO_CHAR(EXTRACT(HOUR FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
          TRIM(TO_CHAR(EXTRACT(MINUTE FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
          TRIM(TO_CHAR(EXTRACT(SECOND FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||
          ') - total registros: '|| sql%rowcount);

    commit;

    -- si codigo parentesco es 6, el sexo de la Hija debe ser femenino
    -- GHERRERA: 23-APR-2014
    m_validacion := 46;

    m_hora_inicio := sysdate;
    debug('Cartera: validacion #'||m_validacion||' - iniciada a las '||to_char(m_hora_inicio,'dd/mm/yyyy hh:mi:ss'));

    insert into suirplus.ars_cartera_con_errores_t
      select codigo_ars,
             periodo_factura,
             tipo_afiliado,
             cedula_titular,
             nss_titular,
             cedula_dependiente,
             nss_dependiente,
             estatus_afiliado,
             codigo_parentesco,
             discapacitado,
             estudiante,
             m_validacion,
             m_hoy,
             m_carga_seq
        from suirplus.ars_carga_cartera_v a
       where a.codigo_parentesco = '6'
         --debe ser femenino
         and 0 < (select count(*)
                    from suirplus.sre_ciudadanos_t c
                   where c.id_nss = a.nss_dependiente
                     and NVL(c.sexo,'~') != 'F'
                  );

    m_hora_termina := sysdate;
    debug('Cartera: validacion #'||m_validacion||' - terminada a las '||to_char(m_hora_termina,'dd/mm/yyyy hh:mi:ss')||
          ' - Tiempo total: ('||
          TRIM(TO_CHAR(EXTRACT(HOUR FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
          TRIM(TO_CHAR(EXTRACT(MINUTE FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
          TRIM(TO_CHAR(EXTRACT(SECOND FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||
          ') - total registros: '|| sql%rowcount);

    commit;

    -- si codigo parentesco es 7, el sexo del Hermano debe ser masculino
    -- GHERRERA: 23-APR-2014
    m_validacion := 47;

    m_hora_inicio := sysdate;
    debug('Cartera: validacion #'||m_validacion||' - iniciada a las '||to_char(m_hora_inicio,'dd/mm/yyyy hh:mi:ss'));

    insert into suirplus.ars_cartera_con_errores_t
      select codigo_ars,
             periodo_factura,
             tipo_afiliado,
             cedula_titular,
             nss_titular,
             cedula_dependiente,
             nss_dependiente,
             estatus_afiliado,
             codigo_parentesco,
             discapacitado,
             estudiante,
             m_validacion,
             m_hoy,
             m_carga_seq
        from suirplus.ars_carga_cartera_v a
       where a.codigo_parentesco = '7'
         --debe ser masculino
         and 0 < (select count(*)
                    from suirplus.sre_ciudadanos_t c
                   where c.id_nss = a.nss_dependiente
                     and NVL(c.sexo,'~') != 'M'
                  );

    m_hora_termina := sysdate;
    debug('Cartera: validacion #'||m_validacion||' - terminada a las '||to_char(m_hora_termina,'dd/mm/yyyy hh:mi:ss')||
          ' - Tiempo total: ('||
          TRIM(TO_CHAR(EXTRACT(HOUR FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
          TRIM(TO_CHAR(EXTRACT(MINUTE FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
          TRIM(TO_CHAR(EXTRACT(SECOND FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||
          ') - total registros: '|| sql%rowcount);

    commit;

    -- si codigo parentesco es 8, el sexo de la Hermana debe ser femenino
    -- GHERRERA: 23-APR-2014
    m_validacion := 48;

    m_hora_inicio := sysdate;
    debug('Cartera: validacion #'||m_validacion||' - iniciada a las '||to_char(m_hora_inicio,'dd/mm/yyyy hh:mi:ss'));

    insert into suirplus.ars_cartera_con_errores_t
      select codigo_ars,
             periodo_factura,
             tipo_afiliado,
             cedula_titular,
             nss_titular,
             cedula_dependiente,
             nss_dependiente,
             estatus_afiliado,
             codigo_parentesco,
             discapacitado,
             estudiante,
             m_validacion,
             m_hoy,
             m_carga_seq
        from suirplus.ars_carga_cartera_v a
       where a.codigo_parentesco = '8'
         --debe ser femenino
         and 0 < (select count(*)
                    from suirplus.sre_ciudadanos_t c
                   where c.id_nss = a.nss_dependiente
                     and NVL(c.sexo,'~') != 'F'
                  );

    m_hora_termina := sysdate;
    debug('Cartera: validacion #'||m_validacion||' - terminada a las '||to_char(m_hora_termina,'dd/mm/yyyy hh:mi:ss')||
          ' - Tiempo total: ('||
          TRIM(TO_CHAR(EXTRACT(HOUR FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
          TRIM(TO_CHAR(EXTRACT(MINUTE FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
          TRIM(TO_CHAR(EXTRACT(SECOND FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||
          ') - total registros: '|| sql%rowcount);

    commit;

    -- si codigo parentesco es 9, el sexo del Abuelo debe ser masculino
    -- GHERRERA: 23-APR-2014
    m_validacion := 49;

    m_hora_inicio := sysdate;
    debug('Cartera: validacion #'||m_validacion||' - iniciada a las '||to_char(m_hora_inicio,'dd/mm/yyyy hh:mi:ss'));

    insert into suirplus.ars_cartera_con_errores_t
      select codigo_ars,
             periodo_factura,
             tipo_afiliado,
             cedula_titular,
             nss_titular,
             cedula_dependiente,
             nss_dependiente,
             estatus_afiliado,
             codigo_parentesco,
             discapacitado,
             estudiante,
             m_validacion,
             m_hoy,
             m_carga_seq
        from suirplus.ars_carga_cartera_v a
       where a.codigo_parentesco = '9'
         --debe ser masculino
         and 0 < (select count(*)
                    from suirplus.sre_ciudadanos_t c
                   where c.id_nss = a.nss_dependiente
                     and NVL(c.sexo,'~') != 'M'
                  );

    m_hora_termina := sysdate;
    debug('Cartera: validacion #'||m_validacion||' - terminada a las '||to_char(m_hora_termina,'dd/mm/yyyy hh:mi:ss')||
          ' - Tiempo total: ('||
          TRIM(TO_CHAR(EXTRACT(HOUR FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
          TRIM(TO_CHAR(EXTRACT(MINUTE FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
          TRIM(TO_CHAR(EXTRACT(SECOND FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||
          ') - total registros: '|| sql%rowcount);

    commit;

    -- si codigo parentesco es 10, el sexo de la Abuela debe ser femenino
    -- GHERRERA: 23-APR-2014
    m_validacion := 50;

    m_hora_inicio := sysdate;
    debug('Cartera: validacion #'||m_validacion||' - iniciada a las '||to_char(m_hora_inicio,'dd/mm/yyyy hh:mi:ss'));

    insert into suirplus.ars_cartera_con_errores_t
      select codigo_ars,
             periodo_factura,
             tipo_afiliado,
             cedula_titular,
             nss_titular,
             cedula_dependiente,
             nss_dependiente,
             estatus_afiliado,
             codigo_parentesco,
             discapacitado,
             estudiante,
             m_validacion,
             m_hoy,
             m_carga_seq
        from suirplus.ars_carga_cartera_v a
       where a.codigo_parentesco = '10'
         --debe ser femenino
         and 0 < (select count(*)
                    from suirplus.sre_ciudadanos_t c
                   where c.id_nss = a.nss_dependiente
                     and NVL(c.sexo,'~') != 'F'
                  );

    m_hora_termina := sysdate;
    debug('Cartera: validacion #'||m_validacion||' - terminada a las '||to_char(m_hora_termina,'dd/mm/yyyy hh:mi:ss')||
          ' - Tiempo total: ('||
          TRIM(TO_CHAR(EXTRACT(HOUR FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
          TRIM(TO_CHAR(EXTRACT(MINUTE FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
          TRIM(TO_CHAR(EXTRACT(SECOND FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||
          ') - total registros: '|| sql%rowcount);

    commit;

    -- si codigo parentesco es 11, el sexo del Sobrino debe ser masculino
    -- GHERRERA: 23-APR-2014
    m_validacion := 51;

    m_hora_inicio := sysdate;
    debug('Cartera: validacion #'||m_validacion||' - iniciada a las '||to_char(m_hora_inicio,'dd/mm/yyyy hh:mi:ss'));

    insert into suirplus.ars_cartera_con_errores_t
      select codigo_ars,
             periodo_factura,
             tipo_afiliado,
             cedula_titular,
             nss_titular,
             cedula_dependiente,
             nss_dependiente,
             estatus_afiliado,
             codigo_parentesco,
             discapacitado,
             estudiante,
             m_validacion,
             m_hoy,
             m_carga_seq
        from suirplus.ars_carga_cartera_v a
       where a.codigo_parentesco = '11'
         --debe ser masculino
         and 0 < (select count(*)
                    from suirplus.sre_ciudadanos_t c
                   where c.id_nss = a.nss_dependiente
                     and NVL(c.sexo,'~') != 'M'
                  );

    m_hora_termina := sysdate;
    debug('Cartera: validacion #'||m_validacion||' - terminada a las '||to_char(m_hora_termina,'dd/mm/yyyy hh:mi:ss')||
          ' - Tiempo total: ('||
          TRIM(TO_CHAR(EXTRACT(HOUR FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
          TRIM(TO_CHAR(EXTRACT(MINUTE FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
          TRIM(TO_CHAR(EXTRACT(SECOND FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||
          ') - total registros: '|| sql%rowcount);

    commit;

    -- si codigo parentesco es 12, el sexo de la Sobrina debe ser femenino
    -- GHERRERA: 23-APR-2014
    m_validacion := 52;

    m_hora_inicio := sysdate;
    debug('Cartera: validacion #'||m_validacion||' - iniciada a las '||to_char(m_hora_inicio,'dd/mm/yyyy hh:mi:ss'));

    insert into suirplus.ars_cartera_con_errores_t
      select codigo_ars,
             periodo_factura,
             tipo_afiliado,
             cedula_titular,
             nss_titular,
             cedula_dependiente,
             nss_dependiente,
             estatus_afiliado,
             codigo_parentesco,
             discapacitado,
             estudiante,
             m_validacion,
             m_hoy,
             m_carga_seq
        from suirplus.ars_carga_cartera_v a
       where a.codigo_parentesco = '12'
         --debe ser femenino
         and 0 < (select count(*)
                    from suirplus.sre_ciudadanos_t c
                   where c.id_nss = a.nss_dependiente
                     and NVL(c.sexo,'~') != 'F'
                  );

    m_hora_termina := sysdate;
    debug('Cartera: validacion #'||m_validacion||' - terminada a las '||to_char(m_hora_termina,'dd/mm/yyyy hh:mi:ss')||
          ' - Tiempo total: ('||
          TRIM(TO_CHAR(EXTRACT(HOUR FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
          TRIM(TO_CHAR(EXTRACT(MINUTE FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
          TRIM(TO_CHAR(EXTRACT(SECOND FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||
          ') - total registros: '|| sql%rowcount);

    commit;

    -- si codigo parentesco es 13, el sexo del Tio debe ser masculino
    -- GHERRERA: 23-APR-2014
    m_validacion := 53;

    m_hora_inicio := sysdate;
    debug('Cartera: validacion #'||m_validacion||' - iniciada a las '||to_char(m_hora_inicio,'dd/mm/yyyy hh:mi:ss'));

    insert into suirplus.ars_cartera_con_errores_t
      select codigo_ars,
             periodo_factura,
             tipo_afiliado,
             cedula_titular,
             nss_titular,
             cedula_dependiente,
             nss_dependiente,
             estatus_afiliado,
             codigo_parentesco,
             discapacitado,
             estudiante,
             m_validacion,
             m_hoy,
             m_carga_seq
        from suirplus.ars_carga_cartera_v a
       where a.codigo_parentesco = '13'
         --debe ser masculino
         and 0 < (select count(*)
                    from suirplus.sre_ciudadanos_t c
                   where c.id_nss = a.nss_dependiente
                     and NVL(c.sexo,'~') != 'M'
                  );

    m_hora_termina := sysdate;
    debug('Cartera: validacion #'||m_validacion||' - terminada a las '||to_char(m_hora_termina,'dd/mm/yyyy hh:mi:ss')||
          ' - Tiempo total: ('||
          TRIM(TO_CHAR(EXTRACT(HOUR FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
          TRIM(TO_CHAR(EXTRACT(MINUTE FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
          TRIM(TO_CHAR(EXTRACT(SECOND FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||
          ') - total registros: '|| sql%rowcount);

    commit;

    -- si codigo parentesco es 14, el sexo de la Tia debe ser femenino
    -- GHERRERA: 23-APR-2014
    m_validacion := 54;

    m_hora_inicio := sysdate;
    debug('Cartera: validacion #'||m_validacion||' - iniciada a las '||to_char(m_hora_inicio,'dd/mm/yyyy hh:mi:ss'));

    insert into suirplus.ars_cartera_con_errores_t
      select codigo_ars,
             periodo_factura,
             tipo_afiliado,
             cedula_titular,
             nss_titular,
             cedula_dependiente,
             nss_dependiente,
             estatus_afiliado,
             codigo_parentesco,
             discapacitado,
             estudiante,
             m_validacion,
             m_hoy,
             m_carga_seq
        from suirplus.ars_carga_cartera_v a
       where a.codigo_parentesco = '14'
         --debe ser femenino
         and 0 < (select count(*)
                    from suirplus.sre_ciudadanos_t c
                   where c.id_nss = a.nss_dependiente
                     and NVL(c.sexo,'~') != 'F'
                  );

    m_hora_termina := sysdate;
    debug('Cartera: validacion #'||m_validacion||' - terminada a las '||to_char(m_hora_termina,'dd/mm/yyyy hh:mi:ss')||
          ' - Tiempo total: ('||
          TRIM(TO_CHAR(EXTRACT(HOUR FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
          TRIM(TO_CHAR(EXTRACT(MINUTE FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
          TRIM(TO_CHAR(EXTRACT(SECOND FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||
          ') - total registros: '|| sql%rowcount);

    commit;

    -- si codigo parentesco es 15, el sexo del Nieto debe ser masculino
    -- GHERRERA: 23-APR-2014
    m_validacion := 55;

    m_hora_inicio := sysdate;
    debug('Cartera: validacion #'||m_validacion||' - iniciada a las '||to_char(m_hora_inicio,'dd/mm/yyyy hh:mi:ss'));

    insert into suirplus.ars_cartera_con_errores_t
      select codigo_ars,
             periodo_factura,
             tipo_afiliado,
             cedula_titular,
             nss_titular,
             cedula_dependiente,
             nss_dependiente,
             estatus_afiliado,
             codigo_parentesco,
             discapacitado,
             estudiante,
             m_validacion,
             m_hoy,
             m_carga_seq
        from suirplus.ars_carga_cartera_v a
       where a.codigo_parentesco = '15'
         --debe ser masculino
         and 0 < (select count(*)
                    from suirplus.sre_ciudadanos_t c
                   where c.id_nss = a.nss_dependiente
                     and NVL(c.sexo,'~') != 'M'
                  );

    m_hora_termina := sysdate;
    debug('Cartera: validacion #'||m_validacion||' - terminada a las '||to_char(m_hora_termina,'dd/mm/yyyy hh:mi:ss')||
          ' - Tiempo total: ('||
          TRIM(TO_CHAR(EXTRACT(HOUR FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
          TRIM(TO_CHAR(EXTRACT(MINUTE FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
          TRIM(TO_CHAR(EXTRACT(SECOND FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||
          ') - total registros: '|| sql%rowcount);

    commit;

    -- si codigo parentesco es 16, el sexo de la Nieta debe ser femenino
    -- GHERRERA: 23-APR-2014
    m_validacion := 56;

    m_hora_inicio := sysdate;
    debug('Cartera: validacion #'||m_validacion||' - iniciada a las '||to_char(m_hora_inicio,'dd/mm/yyyy hh:mi:ss'));

    insert into suirplus.ars_cartera_con_errores_t
      select codigo_ars,
             periodo_factura,
             tipo_afiliado,
             cedula_titular,
             nss_titular,
             cedula_dependiente,
             nss_dependiente,
             estatus_afiliado,
             codigo_parentesco,
             discapacitado,
             estudiante,
             m_validacion,
             m_hoy,
             m_carga_seq
        from suirplus.ars_carga_cartera_v a
       where a.codigo_parentesco = '16'
         --debe ser femenino
         and 0 < (select count(*)
                    from suirplus.sre_ciudadanos_t c
                   where c.id_nss = a.nss_dependiente
                     and NVL(c.sexo,'~') != 'F'
                  );

    m_hora_termina := sysdate;
    debug('Cartera: validacion #'||m_validacion||' - terminada a las '||to_char(m_hora_termina,'dd/mm/yyyy hh:mi:ss')||
          ' - Tiempo total: ('||
          TRIM(TO_CHAR(EXTRACT(HOUR FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
          TRIM(TO_CHAR(EXTRACT(MINUTE FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
          TRIM(TO_CHAR(EXTRACT(SECOND FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||
          ') - total registros: '|| sql%rowcount);

    commit;

    -- si codigo parentesco es 17, el sexo del Hijastro debe ser masculino
    -- GHERRERA: 23-APR-2014
    m_validacion := 57;

    m_hora_inicio := sysdate;
    debug('Cartera: validacion #'||m_validacion||' - iniciada a las '||to_char(m_hora_inicio,'dd/mm/yyyy hh:mi:ss'));

    insert into suirplus.ars_cartera_con_errores_t
      select codigo_ars,
             periodo_factura,
             tipo_afiliado,
             cedula_titular,
             nss_titular,
             cedula_dependiente,
             nss_dependiente,
             estatus_afiliado,
             codigo_parentesco,
             discapacitado,
             estudiante,
             m_validacion,
             m_hoy,
             m_carga_seq
        from suirplus.ars_carga_cartera_v a
       where a.codigo_parentesco = '17'
         --debe ser masculino
         and 0 < (select count(*)
                    from suirplus.sre_ciudadanos_t c
                   where c.id_nss = a.nss_dependiente
                     and NVL(c.sexo,'~') != 'M'
                  );

    m_hora_termina := sysdate;
    debug('Cartera: validacion #'||m_validacion||' - terminada a las '||to_char(m_hora_termina,'dd/mm/yyyy hh:mi:ss')||
          ' - Tiempo total: ('||
          TRIM(TO_CHAR(EXTRACT(HOUR FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
          TRIM(TO_CHAR(EXTRACT(MINUTE FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
          TRIM(TO_CHAR(EXTRACT(SECOND FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||
          ') - total registros: '|| sql%rowcount);

    commit;

    -- si codigo parentesco es 18, el sexo de la Hijastra debe ser femenino
    -- GHERRERA: 23-APR-2014
    m_validacion := 58;

    m_hora_inicio := sysdate;
    debug('Cartera: validacion #'||m_validacion||' - iniciada a las '||to_char(m_hora_inicio,'dd/mm/yyyy hh:mi:ss'));

    insert into suirplus.ars_cartera_con_errores_t
      select codigo_ars,
             periodo_factura,
             tipo_afiliado,
             cedula_titular,
             nss_titular,
             cedula_dependiente,
             nss_dependiente,
             estatus_afiliado,
             codigo_parentesco,
             discapacitado,
             estudiante,
             m_validacion,
             m_hoy,
             m_carga_seq
        from suirplus.ars_carga_cartera_v a
       where a.codigo_parentesco = '18'
         --debe ser femenino
         and 0 < (select count(*)
                    from suirplus.sre_ciudadanos_t c
                   where c.id_nss = a.nss_dependiente
                     and NVL(c.sexo,'~') != 'F'
                  );

    m_hora_termina := sysdate;
    debug('Cartera: validacion #'||m_validacion||' - terminada a las '||to_char(m_hora_termina,'dd/mm/yyyy hh:mi:ss')||
          ' - Tiempo total: ('||
          TRIM(TO_CHAR(EXTRACT(HOUR FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
          TRIM(TO_CHAR(EXTRACT(MINUTE FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
          TRIM(TO_CHAR(EXTRACT(SECOND FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||
          ') - total registros: '|| sql%rowcount);

    commit;

    -- si codigo parentesco es 21, el sexo del Padre del Conyuge debe ser masculino
    -- GHERRERA: 23-APR-2014
    m_validacion := 59;

    m_hora_inicio := sysdate;
    debug('Cartera: validacion #'||m_validacion||' - iniciada a las '||to_char(m_hora_inicio,'dd/mm/yyyy hh:mi:ss'));

    insert into suirplus.ars_cartera_con_errores_t
      select codigo_ars,
             periodo_factura,
             tipo_afiliado,
             cedula_titular,
             nss_titular,
             cedula_dependiente,
             nss_dependiente,
             estatus_afiliado,
             codigo_parentesco,
             discapacitado,
             estudiante,
             m_validacion,
             m_hoy,
             m_carga_seq
        from suirplus.ars_carga_cartera_v a
       where a.codigo_parentesco = '21'
         --debe ser masculino
         and 0 < (select count(*)
                    from suirplus.sre_ciudadanos_t c
                   where c.id_nss = a.nss_dependiente
                     and NVL(c.sexo,'~') != 'M'
                  );

    m_hora_termina := sysdate;
    debug('Cartera: validacion #'||m_validacion||' - terminada a las '||to_char(m_hora_termina,'dd/mm/yyyy hh:mi:ss')||
          ' - Tiempo total: ('||
          TRIM(TO_CHAR(EXTRACT(HOUR FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
          TRIM(TO_CHAR(EXTRACT(MINUTE FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
          TRIM(TO_CHAR(EXTRACT(SECOND FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||
          ') - total registros: '|| sql%rowcount);

    commit;

    -- si codigo parentesco es 22, el sexo de la Madre del Conyuge debe ser femenino
    -- GHERRERA: 23-APR-2014
    m_validacion := 60;

    m_hora_inicio := sysdate;
    debug('Cartera: validacion #'||m_validacion||' - iniciada a las '||to_char(m_hora_inicio,'dd/mm/yyyy hh:mi:ss'));

    insert into suirplus.ars_cartera_con_errores_t
      select codigo_ars,
             periodo_factura,
             tipo_afiliado,
             cedula_titular,
             nss_titular,
             cedula_dependiente,
             nss_dependiente,
             estatus_afiliado,
             codigo_parentesco,
             discapacitado,
             estudiante,
             m_validacion,
             m_hoy,
             m_carga_seq
        from suirplus.ars_carga_cartera_v a
       where a.codigo_parentesco = '22'
         --debe ser femenino
         and 0 < (select count(*)
                    from suirplus.sre_ciudadanos_t c
                   where c.id_nss = a.nss_dependiente
                     and NVL(c.sexo,'~') != 'F'
                  );

    m_hora_termina := sysdate;
    debug('Cartera: validacion #'||m_validacion||' - terminada a las '||to_char(m_hora_termina,'dd/mm/yyyy hh:mi:ss')||
          ' - Tiempo total: ('||
          TRIM(TO_CHAR(EXTRACT(HOUR FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
          TRIM(TO_CHAR(EXTRACT(MINUTE FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
          TRIM(TO_CHAR(EXTRACT(SECOND FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||
          ') - total registros: '|| sql%rowcount);

    commit;

    -- codigos paretenscos 3,4,19,20 no pueden estar en un mismo nucleo familiar para un mismo periodo 
    -- GHERRERA: 23-APR-2014    
    m_validacion := 61;

    m_hora_inicio := sysdate;
    debug('Cartera: validacion #'||m_validacion||' - iniciada a las '||to_char(m_hora_inicio,'dd/mm/yyyy hh:mi:ss'));

    insert into suirplus.ars_cartera_con_errores_t
      select codigo_ars,
             periodo_factura,
             tipo_afiliado,
             cedula_titular,
             nss_titular,
             cedula_dependiente,
             nss_dependiente,
             estatus_afiliado,
             codigo_parentesco,
             discapacitado,
             estudiante,
             m_validacion,
             m_hoy,
             m_carga_seq
        from suirplus.ars_carga_cartera_v a
       where a.codigo_parentesco in ('3', '4', '19', '20')--Conyugue: esposo, esposa, divorcio, companero de vida
         and exists
             (select c.nss_titular
                from suirplus.ars_carga_cartera_v c --EN LA VISTA
               where c.periodo_factura=a.periodo_factura
                 and c.nss_titular=a.nss_titular
                 and c.nss_dependiente <> a.nss_dependiente -- Otro conyuge
                 and c.codigo_parentesco in('3', '4', '19', '20')--Conyugue: esposo, esposa, divorcio, companero de vida
             )
    UNION
      select codigo_ars,
             periodo_factura,
             tipo_afiliado,
             cedula_titular,
             nss_titular,
             cedula_dependiente,
             nss_dependiente,
             estatus_afiliado,
             codigo_parentesco,
             discapacitado,
             estudiante,
             m_validacion,
             m_hoy,
             m_carga_seq
        from suirplus.ars_carga_cartera_v a
       where a.codigo_parentesco in ('3', '4', '19', '20')--Conyugue: esposo, esposa, divorcio, companero de vida
         and exists
             (select c.nss_titular
                from suirplus.ars_cartera_t c  --EN CARTERA
               where c.periodo_factura_ars=a.periodo_factura
                 and c.nss_titular=a.nss_titular
                 and c.nss_dependiente <> a.nss_dependiente -- Otro conyuge
                 and c.codigo_parentesco in('3', '4', '19', '20')--Conyugue: esposo, esposa, divorcio, companero de vida
             );

    m_hora_termina := sysdate;
    debug('Cartera: validacion #'||m_validacion||' - terminada a las '||to_char(m_hora_termina,'dd/mm/yyyy hh:mi:ss')||
          ' - Tiempo total: ('||
          TRIM(TO_CHAR(EXTRACT(HOUR FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
          TRIM(TO_CHAR(EXTRACT(MINUTE FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
          TRIM(TO_CHAR(EXTRACT(SECOND FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||
          ') - total registros: '|| sql%rowcount);

    commit;

    -- si codigo parentesco es 19 o 20, sexo del dependiente debe ser diferente al sexo del titular
    -- GHERRERA: 23-APR-2014
    m_validacion := 62;

    m_hora_inicio := sysdate;
    debug('Cartera: validacion #'||m_validacion||' - iniciada a las '||to_char(m_hora_inicio,'dd/mm/yyyy hh:mi:ss'));

    insert into suirplus.ars_cartera_con_errores_t
      select codigo_ars,
             periodo_factura,
             tipo_afiliado,
             cedula_titular,
             nss_titular,
             cedula_dependiente,
             nss_dependiente,
             estatus_afiliado,
             codigo_parentesco,
             discapacitado,
             estudiante,
             m_validacion,
             m_hoy,
             m_carga_seq
        from suirplus.ars_carga_cartera_v a
       where a.codigo_parentesco in ('19','20')
         --sexo del dependiente y del titular deben ser diferente
         and 0 < (select count(*)
                    from suirplus.sre_ciudadanos_t c, 
                         suirplus.sre_ciudadanos_t c1
                   where c.id_nss = a.nss_dependiente
                     and c1.id_nss = a.nss_titular
                     and NVL(c.sexo,'~') = NVL(c1.sexo,'~')
                  );

    m_hora_termina := sysdate;
    debug('Cartera: validacion #'||m_validacion||' - terminada a las '||to_char(m_hora_termina,'dd/mm/yyyy hh:mi:ss')||
          ' - Tiempo total: ('||
          TRIM(TO_CHAR(EXTRACT(HOUR FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
          TRIM(TO_CHAR(EXTRACT(MINUTE FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
          TRIM(TO_CHAR(EXTRACT(SECOND FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||
          ') - total registros: '|| sql%rowcount);

    commit;

    -- si codigo parentesco es 3,4,19,20, debe ser cedulado (tipo_documento='C')
    -- GHERRERA: 23-APR-2014
    m_validacion := 63;

    m_hora_inicio := sysdate;
    debug('Cartera: validacion #'||m_validacion||' - iniciada a las '||to_char(m_hora_inicio,'dd/mm/yyyy hh:mi:ss'));

    insert into suirplus.ars_cartera_con_errores_t
      select codigo_ars,
             periodo_factura,
             tipo_afiliado,
             cedula_titular,
             nss_titular,
             cedula_dependiente,
             nss_dependiente,
             estatus_afiliado,
             codigo_parentesco,
             discapacitado,
             estudiante,
             m_validacion,
             m_hoy,
             m_carga_seq
        from suirplus.ars_carga_cartera_v a
       where a.codigo_parentesco in ('3','4','19','20')
         --debe ser cedulado
         and 0 < (select count(*)
                    from suirplus.sre_ciudadanos_t c 
                   where c.id_nss = a.nss_dependiente
                     and NVL(c.tipo_documento,'~') != 'C'
                  );

    m_hora_termina := sysdate;
    debug('Cartera: validacion #'||m_validacion||' - terminada a las '||to_char(m_hora_termina,'dd/mm/yyyy hh:mi:ss')||
          ' - Tiempo total: ('||
          TRIM(TO_CHAR(EXTRACT(HOUR FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
          TRIM(TO_CHAR(EXTRACT(MINUTE FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
          TRIM(TO_CHAR(EXTRACT(SECOND FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||
          ') - total registros: '|| sql%rowcount);

    commit;

    -- si el titular tiene error, tambien sus dependientes
    -- ESTA DEBE SER LA ULTIMA VALIDACION
    m_validacion := 21;

    m_hora_inicio := sysdate;
    debug('Cartera: validacion #'||m_validacion||' - iniciada a las '||to_char(m_hora_inicio,'dd/mm/yyyy hh:mi:ss'));

    insert into suirplus.ars_cartera_con_errores_t
      select codigo_ars,
             periodo_factura,
             tipo_afiliado,
             cedula_titular,
             nss_titular,
             cedula_dependiente,
             nss_dependiente,
             estatus_afiliado,
             codigo_parentesco,
             discapacitado,
             estudiante,
             m_validacion,
             m_hoy,
             m_carga_seq
        from ars_carga_cartera_v a
       where a.tipo_afiliado <> 'T'
         and exists (select 1
                from suirplus.ars_cartera_con_errores_t b
               where b.codigo_ars = a.codigo_ars
                 and b.periodo_factura = a.periodo_factura
                 and b.nss_titular = a.nss_titular
                 and b.tipo_afiliado = 'T'
                 and b.id_carga = m_carga_seq -- Validar solo para este envio(carga)
              );

    m_hora_termina := sysdate;
    debug('Cartera: validacion #'||m_validacion||' - terminada a las '||to_char(m_hora_termina,'dd/mm/yyyy hh:mi:ss')||
          ' - Tiempo total: ('||
          TRIM(TO_CHAR(EXTRACT(HOUR FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
          TRIM(TO_CHAR(EXTRACT(MINUTE FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
          TRIM(TO_CHAR(EXTRACT(SECOND FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||
          ') - total registros: '|| sql%rowcount);

    commit;

    m_hora_inicio := sysdate;
    debug('Cartera: conteo registros rechazadas - iniciado a las '||to_char(m_hora_inicio,'dd/mm/yyyy hh:mi:ss'));

    -- Buscar los registros con errores y los ok.
    with registros as
     (select distinct codigo_ars,
                      periodo_factura,
                      nss_titular,
                      nss_dependiente
        from suirplus.ars_cartera_con_errores_t a
       where a.id_carga = m_carga_seq)
    select count(*) into m_registros_procesados_error from registros a;

    m_hora_termina := sysdate;
    debug('Cartera: conteo registros rechazados - terminado a las '||to_char(m_hora_termina,'dd/mm/yyyy hh:mi:ss')||
          ' - Tiempo total: ('||
          TRIM(TO_CHAR(EXTRACT(HOUR FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
          TRIM(TO_CHAR(EXTRACT(MINUTE FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
          TRIM(TO_CHAR(EXTRACT(SECOND FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||
          ') - total registros: '|| sql%rowcount);

    m_registros_procesados_ok := m_registros - m_registros_procesados_error;

    p_result := 'OK';

    -- Enviar email indicando corrida satisfactoria
    -- enviar_email('C',m_carga_seq);
    --debug('fin validaciones');

  exception
    when others then
      rollback;
      debug('Cartera: error validaciones:' || sqlerrm);
      p_result := 'ERROR. ' || m_proceso || ' validacion=' || m_validacion || '. ' ||
                  sqlerrm;
  end;

  -- ------------------------------------------------------------------------------------------------------------------------------------
  procedure validar_dispersion(p_ciclo in number, p_result out varchar2) is
    m_mayor_periodo_factura varchar2(6);
    m_parm                  Parm;
  begin
    --Para crear las particiones, sino existen
    FOR r in (SELECT DISTINCT v.periodo_factura periodo
              FROM suirplus.ars_dispersion v
              MINUS
              SELECT to_char(to_date(substr(Partition_name, 2, 6), 'mmyyyy'),'yyyymm') periodo
              FROM ALL_TAB_PARTITIONS a
              WHERE a.TABLE_NAME = 'ARS_DISPERSION_CON_ERRORES_T') LOOP
      suirplus.job_ejecuciones_pkg.mohave_Crea_Partition(r.periodo, 'ARS_DISPERSION_CON_ERRORES_T');     
    END LOOP;          
  
    p_result := 'ERROR'; -- Se asume error hasta tanto no halla pasado TODAS las validaciones.

    If (p_ciclo = 1) Then
      m_validacion := 0;

      -- El periodo inicial es "6 meses antes de la fecha de vigencia".
      m_per_desde := To_char(add_months(to_date(m_per_hasta || '01',
                            'yyyymmdd'), -6), 'yyyymm');

      m_hora_inicio := sysdate;
      debug('Total registros a procesar dispersion ciclo '||p_ciclo||' - iniciado a las '||to_char(m_hora_inicio,'dd/mm/yyyy hh:mi:ss'));

      -- obtener el total de registros a procesar y el mayor periodo enviado
      select count(*), max(a.periodo_factura)
        into m_registros, m_mayor_periodo_factura
        from suirplus.ars_dispersion a;

      m_hora_termina := sysdate;
      debug('Total de registros a procesar dispersion ciclo '||p_ciclo||' - terminado a las '||to_char(m_hora_termina,'dd/mm/yyyy hh:mi:ss')||
            ' - Tiempo total: ('||
            TRIM(TO_CHAR(EXTRACT(HOUR FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
            TRIM(TO_CHAR(EXTRACT(MINUTE FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
            TRIM(TO_CHAR(EXTRACT(SECOND FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||
            ') - registros a procesar: ' || m_registros);

      -- borrar todos los registros de errores de la corrida anterior
      --delete ars_dispersion_con_errores dce;
      --commit;

      -- validar ars en catalogo
      m_validacion := 1;

      m_hora_inicio := sysdate;
      debug('Dispersion: ciclo '||p_ciclo||' validacion #'||m_validacion||' - iniciada a las '||to_char(m_hora_inicio,'dd/mm/yyyy hh:mi:ss'));

      insert into suirplus.ars_dispersion_con_errores_t
        (codigo_ars,
         periodo_factura,
         nss_titular,
         nss_afiliado_pagado,
         nss_dispara_pago,
         id_referencia,
         nombre_nacha,
         fecha_envio_nacha,
         id_error,
         fecha_registro,
         id_carga)
        select a.codigo_ars,
               a.periodo_factura,
               a.nss_titular,
               a.nss_afiliado_pagado,
               a.nss_dispara_pago,
               a.id_referencia,
               a.monto_dispersar,
               a.fecha_consolidado,
               m_validacion,
               m_hoy,
               m_carga_seq
          from suirplus.ars_dispersion a
         where a.codigo_ars is null
            or m_codigos_ars not like '%,' || a.codigo_ars || ',%';

      m_hora_termina := sysdate;
      debug('Dispersion: ciclo '||p_ciclo||' validacion #'||m_validacion||' - terminada a las '||to_char(m_hora_termina,'dd/mm/yyyy hh:mi:ss')||
            ' - Tiempo total: ('||
            TRIM(TO_CHAR(EXTRACT(HOUR FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
            TRIM(TO_CHAR(EXTRACT(MINUTE FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
            TRIM(TO_CHAR(EXTRACT(SECOND FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||
            ') - total registros: '|| sql%rowcount);

--      debug('validar_dispersion: ' || m_validacion ||', total registros: '|| sql%rowcount);
      commit;

    -- validar periodo dispersion menor que la fecha de nacimiento del afiliado
      m_validacion := 2;

      m_hora_inicio := sysdate;
      debug('Dispersion: ciclo '||p_ciclo||' validacion #'||m_validacion||' - iniciada a las '||to_char(m_hora_inicio,'dd/mm/yyyy hh:mi:ss'));

      insert into suirplus.ars_dispersion_con_errores_t
        (codigo_ars,
         periodo_factura,
         nss_titular,
         nss_afiliado_pagado,
         nss_dispara_pago,
         id_referencia,
         nombre_nacha,
         fecha_envio_nacha,
         id_error,
         fecha_registro,
         id_carga)
        select a.codigo_ars,
               a.periodo_factura,
               a.nss_titular,
               a.nss_afiliado_pagado,
               a.nss_dispara_pago,
               a.id_referencia,
               a.monto_dispersar,
               a.fecha_consolidado,
               m_validacion,
               m_hoy,
               m_carga_seq
          from suirplus.ars_dispersion a
          join sre_ciudadanos_t b
            on b.id_nss = NVL(a.nss_afiliado_pagado,0)
         where a.periodo_factura < to_char(add_months(b.fecha_nacimiento, -1), 'YYYYMM');

      m_hora_termina := sysdate;
      debug('Dispersion: ciclo '||p_ciclo||' validacion #'||m_validacion||' - terminada a las '||to_char(m_hora_termina,'dd/mm/yyyy hh:mi:ss')||
            ' - Tiempo total: ('||
            TRIM(TO_CHAR(EXTRACT(HOUR FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
            TRIM(TO_CHAR(EXTRACT(MINUTE FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
            TRIM(TO_CHAR(EXTRACT(SECOND FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||
            ') - total registros: '|| sql%rowcount);

--      debug('validar_dispersion: ' || m_validacion ||', total registros: '|| sql%rowcount);
      commit;

      -- validar ars inactivas
      m_validacion := 25;

      m_hora_inicio := sysdate;
      debug('Dispersion: ciclo '||p_ciclo||' validacion #'||m_validacion||' - iniciada a las '||to_char(m_hora_inicio,'dd/mm/yyyy hh:mi:ss'));

      insert into suirplus.ars_cartera_con_errores_t
        select codigo_ars,
               periodo_factura,
               tipo_afiliado,
               cedula_titular,
               nss_titular,
               cedula_dependiente,
               nss_dependiente,
               estatus_afiliado,
               codigo_parentesco,
               discapacitado,
               estudiante,
               m_validacion,
               m_hoy,
               m_carga_seq
          from ars_carga_cartera_v a
         where m_codigos_ars_inactivas like
               '%,' || nvl(a.codigo_ars, 0) || ',%';

      m_hora_termina := sysdate;
      debug('Dispersion: ciclo '||p_ciclo||' validacion #'||m_validacion||' - terminada a las '||to_char(m_hora_termina,'dd/mm/yyyy hh:mi:ss')||
            ' - Tiempo total: ('||
            TRIM(TO_CHAR(EXTRACT(HOUR FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
            TRIM(TO_CHAR(EXTRACT(MINUTE FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
            TRIM(TO_CHAR(EXTRACT(SECOND FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||
            ') - total registros: '|| sql%rowcount);

--      debug('validar_dispersion: ' || m_validacion ||', total registros: '|| sql%rowcount);
      commit;

      -- que rechace cualquier ciudadano cancelado (excepto por muerte)

      m_validacion := 37;

      m_hora_inicio := sysdate;
      debug('Dispersion: ciclo '||p_ciclo||' validacion #'||m_validacion||' - iniciada a las '||to_char(m_hora_inicio,'dd/mm/yyyy hh:mi:ss'));

      insert into suirplus.ars_dispersion_con_errores_t
        (codigo_ars,
         periodo_factura,
         nss_titular,
         nss_afiliado_pagado,
         nss_dispara_pago,
         id_referencia,
         nombre_nacha,
         fecha_envio_nacha,
         id_error,
         fecha_registro,
         id_carga)
      -- Todos los registros de Dispersion
        select a.codigo_ars,
               a.periodo_factura,
               a.nss_titular,
               a.nss_afiliado_pagado,
               a.nss_dispara_pago,
               a.id_referencia,
               a.monto_dispersar,
               a.fecha_consolidado,
               m_validacion,
               m_hoy,
               m_carga_seq
          from suirplus.ars_dispersion a
         where SUIRPLUS.SRE_CIUDADANO_INACTIVO_F(nvl(a.nss_afiliado_pagado, a.nss_titular), TO_NUMBER(a.periodo_factura)) = 'N'; -- No se debe pagar la capita

      m_hora_termina := sysdate;
      debug('Dispersion: ciclo '||p_ciclo||' validacion #'||m_validacion||' - terminada a las '||to_char(m_hora_termina,'dd/mm/yyyy hh:mi:ss')||
            ' - Tiempo total: ('||
            TRIM(TO_CHAR(EXTRACT(HOUR FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
            TRIM(TO_CHAR(EXTRACT(MINUTE FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
            TRIM(TO_CHAR(EXTRACT(SECOND FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||
            ') - total registros: '|| sql%rowcount);

--      debug('validar_dispersion: ' || m_validacion ||', total registros: '|| sql%rowcount);
      commit;

      -- nss_afiliado_pagado debe ser un ciudadano
      m_validacion := 14;

      m_hora_inicio := sysdate;
      debug('Dispersion: ciclo '||p_ciclo||' validacion #'||m_validacion||' - iniciada a las '||to_char(m_hora_inicio,'dd/mm/yyyy hh:mi:ss'));

      insert into suirplus.ars_dispersion_con_errores_t
        (codigo_ars,
         periodo_factura,
         nss_titular,
         nss_afiliado_pagado,
         nss_dispara_pago,
         id_referencia,
         nombre_nacha,
         fecha_envio_nacha,
         id_error,
         fecha_registro,
         id_carga)
        select a.codigo_ars,
               a.periodo_factura,
               a.nss_titular,
               a.nss_afiliado_pagado,
               a.nss_dispara_pago,
               a.id_referencia,
               a.monto_dispersar,
               a.fecha_consolidado,
               m_validacion,
               m_hoy,
               m_carga_seq
          from suirplus.ars_dispersion a
        minus
        select a.codigo_ars,
               a.periodo_factura,
               a.nss_titular,
               a.nss_afiliado_pagado,
               a.nss_dispara_pago,
               a.id_referencia,
               a.monto_dispersar,
               a.fecha_consolidado,
               m_validacion,
               m_hoy,
               m_carga_seq
          from suirplus.ars_dispersion a
          join suirplus.sre_ciudadanos_t c
            on c.id_nss = a.nss_afiliado_pagado;

      m_hora_termina := sysdate;
      debug('Dispersion: ciclo '||p_ciclo||' validacion #'||m_validacion||' - terminada a las '||to_char(m_hora_termina,'dd/mm/yyyy hh:mi:ss')||
            ' - Tiempo total: ('||
            TRIM(TO_CHAR(EXTRACT(HOUR FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
            TRIM(TO_CHAR(EXTRACT(MINUTE FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
            TRIM(TO_CHAR(EXTRACT(SECOND FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||
            ') - total registros: '|| sql%rowcount);

--      debug('validar_dispersion: ' || m_validacion ||', total registros: '|| sql%rowcount);
      commit;

      -- nss_dispara_pago debe ser un ciudadano.
      -- No validar los registros con referencia = '5555555555555550' (Persona sin trabajo);
      -- pues, para este caso el campo nss_dispara_pago viene nulo.
      m_validacion := 15;

      m_hora_inicio := sysdate;
      debug('Dispersion: ciclo '||p_ciclo||' validacion #'||m_validacion||' - iniciada a las '||to_char(m_hora_inicio,'dd/mm/yyyy hh:mi:ss'));

      insert into suirplus.ars_dispersion_con_errores_t
        (codigo_ars,
         periodo_factura,
         nss_titular,
         nss_afiliado_pagado,
         nss_dispara_pago,
         id_referencia,
         nombre_nacha,
         fecha_envio_nacha,
         id_error,
         fecha_registro,
         id_carga)
        select a.codigo_ars,
               a.periodo_factura,
               a.nss_titular,
               a.nss_afiliado_pagado,
               a.nss_dispara_pago,
               a.id_referencia,
               a.monto_dispersar,
               a.fecha_consolidado,
               m_validacion,
               m_hoy,
               m_carga_seq
          from suirplus.ars_dispersion a
         where NVL(a.id_referencia, '1') NOT IN
               ('5555555555555550', '4444444444444444') -- No sean personas sin trabajo.
        minus
        select a.codigo_ars,
               a.periodo_factura,
               a.nss_titular,
               a.nss_afiliado_pagado,
               a.nss_dispara_pago,
               a.id_referencia,
               a.monto_dispersar,
               a.fecha_consolidado,
               m_validacion,
               m_hoy,
               m_carga_seq
          from suirplus.ars_dispersion a
          join suirplus.sre_ciudadanos_t c
            on c.id_nss = NVL(a.nss_dispara_pago, 0)
           and c.tipo_documento = 'C'
         where NVL(a.id_referencia, '1') NOT IN
               ('5555555555555550', '4444444444444444'); -- No sean personas sin trabajo.

      m_hora_termina := sysdate;
      debug('Dispersion: ciclo '||p_ciclo||' validacion #'||m_validacion||' - terminada a las '||to_char(m_hora_termina,'dd/mm/yyyy hh:mi:ss')||
            ' - Tiempo total: ('||
            TRIM(TO_CHAR(EXTRACT(HOUR FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
            TRIM(TO_CHAR(EXTRACT(MINUTE FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
            TRIM(TO_CHAR(EXTRACT(SECOND FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||
            ') - total registros: '|| sql%rowcount);

--      debug('validar_dispersion: ' || m_validacion ||', total registros: '|| sql%rowcount);
      commit;

      -- la referencia debe estar pagada
      m_validacion := 16;

      m_hora_inicio := sysdate;
      debug('Dispersion: ciclo '||p_ciclo||' validacion #'||m_validacion||' - iniciada a las '||to_char(m_hora_inicio,'dd/mm/yyyy hh:mi:ss'));

      insert into suirplus.ars_dispersion_con_errores_t
        (codigo_ars,
         periodo_factura,
         nss_titular,
         nss_afiliado_pagado,
         nss_dispara_pago,
         id_referencia,
         nombre_nacha,
         fecha_envio_nacha,
         id_error,
         fecha_registro,
         id_carga)
        select a.codigo_ars,
               a.periodo_factura,
               a.nss_titular,
               a.nss_afiliado_pagado,
               a.nss_dispara_pago,
               a.id_referencia,
               a.monto_dispersar,
               a.fecha_consolidado,
               m_validacion,
               m_hoy,
               m_carga_seq
          from suirplus.ars_dispersion a
         where NVL(a.id_referencia, '1') NOT IN
               ('5555555555555550', '4444444444444444') -- No sean personas sin trabajo.
        minus
        -- Menos las referencias de factura validas.
        select a.codigo_ars,
               a.periodo_factura,
               a.nss_titular,
               a.nss_afiliado_pagado,
               a.nss_dispara_pago,
               a.id_referencia,
               a.monto_dispersar,
               a.fecha_consolidado,
               m_validacion,
               m_hoy,
               m_carga_seq
          from suirplus.ars_dispersion a
          join suirplus.sfc_facturas_v f
            on f.ID_REFERENCIA = NVL(a.id_referencia, '1')
           and f.status = 'PA'
         where NVL(a.id_referencia, '1') NOT IN
               ('5555555555555550', '4444444444444444'); -- No sean personas sin trabajo.

      m_hora_termina := sysdate;
      debug('Dispersion: ciclo '||p_ciclo||' validacion #'||m_validacion||' - terminada a las '||to_char(m_hora_termina,'dd/mm/yyyy hh:mi:ss')||
            ' - Tiempo total: ('||
            TRIM(TO_CHAR(EXTRACT(HOUR FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
            TRIM(TO_CHAR(EXTRACT(MINUTE FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
            TRIM(TO_CHAR(EXTRACT(SECOND FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||
            ') - total registros: '|| sql%rowcount);

--      debug('validar_dispersion: ' || m_validacion ||', total registros: '|| sql%rowcount);
      commit;

      -- NSS afiliado pagado debe de existir en la tabla cartera
      m_validacion := 18;

      m_hora_inicio := sysdate;
      debug('Dispersion: ciclo '||p_ciclo||' validacion #'||m_validacion||' - iniciada a las '||to_char(m_hora_inicio,'dd/mm/yyyy hh:mi:ss'));

      insert into suirplus.ars_dispersion_con_errores_t
        (codigo_ars,
         periodo_factura,
         nss_titular,
         nss_afiliado_pagado,
         nss_dispara_pago,
         id_referencia,
         nombre_nacha,
         fecha_envio_nacha,
         id_error,
         fecha_registro,
         id_carga)
      -- Traer todos los registros de Dispersion
        select a.codigo_ars,
               a.periodo_factura,
               a.nss_titular,
               a.nss_afiliado_pagado,
               a.nss_dispara_pago,
               a.id_referencia,
               a.monto_dispersar,
               a.fecha_consolidado,
               m_validacion,
               m_hoy,
               m_carga_seq
          from suirplus.ars_dispersion a
        minus
        -- Restarle los que estan en cartera
        select a.codigo_ars,
               a.periodo_factura,
               a.nss_titular,
               a.nss_afiliado_pagado,
               a.nss_dispara_pago,
               a.id_referencia,
               a.monto_dispersar,
               a.fecha_consolidado,
               m_validacion,
               m_hoy,
               m_carga_seq
          from suirplus.ars_dispersion a
          join suirplus.ars_cartera_t c
            on c.periodo_factura_ars = a.periodo_factura
           and c.nss_titular = a.nss_titular
           and c.nss_dependiente = a.nss_afiliado_pagado
           and c.id_ars = a.codigo_ars
        minus
        -- Restarle los que fueron adquiridos por Otra ARS
        select a.codigo_ars,
               a.periodo_factura,
               a.nss_titular,
               a.nss_afiliado_pagado,
               a.nss_dispara_pago,
               a.id_referencia,
               a.monto_dispersar,
               a.fecha_consolidado,
               m_validacion,
               m_hoy,
               m_carga_seq
          from suirplus.ars_dispersion a
          join suirplus.ars_cartera_t c
            on c.id_ars in
               (select id_ars_anterior id_ars
                  from suirplus.ars_cat_inactiva_t ci
                 where ci.id_ars_actual = a.codigo_ars)
           and c.periodo_factura_ars = a.periodo_factura
           and c.nss_titular = a.nss_titular
           and c.nss_dependiente = a.nss_afiliado_pagado;

      m_hora_termina := sysdate;
      debug('Dispersion: ciclo '||p_ciclo||' validacion #'||m_validacion||' - terminada a las '||to_char(m_hora_termina,'dd/mm/yyyy hh:mi:ss')||
            ' - Tiempo total: ('||
            TRIM(TO_CHAR(EXTRACT(HOUR FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
            TRIM(TO_CHAR(EXTRACT(MINUTE FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
            TRIM(TO_CHAR(EXTRACT(SECOND FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||
            ') - total registros: '|| sql%rowcount);

--      debug('validar_dispersion: ' || m_validacion ||', total registros: '|| sql%rowcount);
      commit;

      -- Registros previamente dispersados
      m_validacion := 22;

      m_hora_inicio := sysdate;
      debug('Dispersion: ciclo '||p_ciclo||' validacion #'||m_validacion||' - iniciada a las '||to_char(m_hora_inicio,'dd/mm/yyyy hh:mi:ss'));

      insert into suirplus.ars_dispersion_con_errores_t
        (codigo_ars,
         periodo_factura,
         nss_titular,
         nss_afiliado_pagado,
         nss_dispara_pago,
         id_referencia,
         nombre_nacha,
         fecha_envio_nacha,
         id_error,
         fecha_registro,
         id_carga)
        select a.codigo_ars,
               a.periodo_factura,
               a.nss_titular,
               a.nss_afiliado_pagado,
               a.nss_dispara_pago,
               a.id_referencia,
               a.monto_dispersar,
               a.fecha_consolidado,
               m_validacion,
               m_hoy,
               m_carga_seq
          from suirplus.ars_dispersion a
        /* Pichardo - 19-09-2008: Quitar ID ARS del join.
        No es necesario; pues, los otros 3 campos cumplen. */
        /*
        join suirplus.ars_cartera_t c on c.id_ars = a.codigo_ars
                                     and c.periodo_factura_ars = a.periodo_factura
                                     and c.nss_titular         = a.nss_titular
                                     and c.nss_dependiente     = a.nss_afiliado_pagado
                                     and c.id_carga_dispersion is not null
        */
          join suirplus.ars_cartera_t c
            on c.periodo_factura_ars = a.periodo_factura
           and c.nss_dependiente = a.nss_afiliado_pagado
           and c.nss_titular = a.nss_titular
           and c.id_carga_dispersion is not null;

      m_hora_termina := sysdate;
      debug('Dispersion: ciclo '||p_ciclo||' validacion #'||m_validacion||' - terminada a las '||to_char(m_hora_termina,'dd/mm/yyyy hh:mi:ss')||
            ' - Tiempo total: ('||
            TRIM(TO_CHAR(EXTRACT(HOUR FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
            TRIM(TO_CHAR(EXTRACT(MINUTE FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
            TRIM(TO_CHAR(EXTRACT(SECOND FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||
            ') - total registros: '|| sql%rowcount);

--      debug('validar_dispersion: ' || m_validacion ||', total registros: '|| sql%rowcount);
      commit;

      -- Validar los desempleados con menos de "6 periodos anteriores consecutivos pagados".
      -- GHERRERA: 06-MAY-2013, quitar las referencias '4444444444444444'
      m_validacion := 23;

      m_hora_inicio := sysdate;
      debug('Dispersion: ciclo '||p_ciclo||' validacion #'||m_validacion||' - iniciada a las '||to_char(m_hora_inicio,'dd/mm/yyyy hh:mi:ss'));

      insert into suirplus.ars_dispersion_con_errores_t
        (codigo_ars,
         periodo_factura,
         nss_titular,
         nss_afiliado_pagado,
         nss_dispara_pago,
         id_referencia,
         nombre_nacha,
         fecha_envio_nacha,
         id_error,
         fecha_registro,
         id_carga)
        select a.codigo_ars,
               a.periodo_factura,
               a.nss_titular,
               a.nss_afiliado_pagado,
               a.nss_dispara_pago,
               a.id_referencia,
               a.monto_dispersar,
               a.fecha_consolidado,
               m_validacion,
               m_hoy,
               m_carga_seq
          from suirplus.ars_dispersion a
         where NVL(a.id_referencia, '1') = '5555555555555550'
           and exists
              (select 1
               from suirplus.ars_cartera_t b
               where b.nss_dependiente = a.nss_dispara_pago -- nss_dispara_pago debe tener 6 pagos previos
                 and b.periodo_factura_ars Between
                     to_char(add_months(to_date(to_char(a.periodo_factura) || '01',
                            'YYYYMMDD'), -6), 'YYYYMM')
                 and to_char(add_months(to_date(to_char(a.periodo_factura) || '01',
                            'YYYYMMDD'), -1), 'YYYYMM')
                 and nvl(b.id_referencia_dispersion, '5555555555555550') <> '5555555555555550'
               having count(distinct b.periodo_factura_ars) < 6);

      m_hora_termina := sysdate;
      debug('Dispersion: ciclo '||p_ciclo||' validacion #'||m_validacion||' - terminada a las '||to_char(m_hora_termina,'dd/mm/yyyy hh:mi:ss')||
            ' - Tiempo total: ('||
            TRIM(TO_CHAR(EXTRACT(HOUR FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
            TRIM(TO_CHAR(EXTRACT(MINUTE FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
            TRIM(TO_CHAR(EXTRACT(SECOND FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||
            ') - total registros: '|| sql%rowcount);

--      debug('validar_dispersion: ' || m_validacion ||', total registros: '|| sql%rowcount);
      commit;

      -- Validar los NSS en transacciones de Ajustes de Lactancia.
      m_validacion := 33;

      m_hora_inicio := sysdate;
      debug('Dispersion: ciclo '||p_ciclo||' validacion #'||m_validacion||' - iniciada a las '||to_char(m_hora_inicio,'dd/mm/yyyy hh:mi:ss'));

      insert into suirplus.ars_dispersion_con_errores_t
        (codigo_ars,
         periodo_factura,
         nss_titular,
         nss_afiliado_pagado,
         nss_dispara_pago,
         id_referencia,
         nombre_nacha,
         fecha_envio_nacha,
         id_error,
         fecha_registro,
         id_carga)
        select a.codigo_ars,
               a.periodo_factura,
               a.nss_titular,
               a.nss_afiliado_pagado,
               a.nss_dispara_pago,
               a.id_referencia,
               a.monto_dispersar,
               a.fecha_consolidado,
               m_validacion,
               m_hoy,
               m_carga_seq
          from suirplus.ars_dispersion a
         where NVL(a.id_referencia, '1') = '4444444444444444'
           and 0 = (select count(*)
                    from suirplus.sfc_trans_ajustes_t b
                   where b.id_nss = NVL(a.nss_dispara_pago, 0)
                     and b.periodo_aplicacion = to_number(a.periodo_factura)
                     and b.id_tipo_ajuste = '2'
                     and b.estatus <> 'CA'
                    );
         
/*           and not exists
         (select 1
                  from suirplus.sfc_trans_ajustes_t b
                 where b.id_nss = NVL(a.nss_dispara_pago, 0)
                   and b.periodo_aplicacion = to_number(a.periodo_factura)
                   and b.id_tipo_ajuste = '2'
                   and b.estatus = 'AP');
*/
      m_hora_termina := sysdate;
      debug('Dispersion: ciclo '||p_ciclo||' validacion #'||m_validacion||' - terminada a las '||to_char(m_hora_termina,'dd/mm/yyyy hh:mi:ss')||
            ' - Tiempo total: ('||
            TRIM(TO_CHAR(EXTRACT(HOUR FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
            TRIM(TO_CHAR(EXTRACT(MINUTE FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
            TRIM(TO_CHAR(EXTRACT(SECOND FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||
            ') - total registros: '|| sql%rowcount);

--      debug('validar_dispersion: ' || m_validacion ||', total registros: '|| sql%rowcount);
      commit;

      -- validar "conyuge divorcio" en carteras anteriores o duplicado en esta dispersion
      m_validacion := 9;

      m_hora_inicio := sysdate;
      debug('Dispersion: ciclo '||p_ciclo||' validacion #'||m_validacion||' - iniciada a las '||to_char(m_hora_inicio,'dd/mm/yyyy hh:mi:ss'));

      insert into suirplus.ars_dispersion_con_errores_t
        (codigo_ars,
         periodo_factura,
         nss_titular,
         nss_afiliado_pagado,
         nss_dispara_pago,
         id_referencia,
         nombre_nacha,
         fecha_envio_nacha,
         id_error,
         fecha_registro,
         id_carga)
      select a.codigo_ars,
             a.periodo_factura,
             a.nss_titular,
             a.nss_afiliado_pagado,
             a.nss_dispara_pago,
             a.id_referencia,
             a.monto_dispersar,
             a.fecha_consolidado,
             m_validacion,
             m_hoy,
             m_carga_seq
      from suirplus.ars_dispersion a
      join suirplus.ars_cartera_t c
        on c.periodo_factura_ars=a.periodo_factura
       and c.nss_titular=a.nss_titular
       and c.nss_dependiente=a.nss_afiliado_pagado
       and c.tipo_afiliado='D'
       and c.codigo_parentesco='20'
      where --Existe previamente en cartera como "conyuge divorcio" para un periodo
            --distinto al que se está dispersando
            --No cambiar por la setencia NOT EXISTS, el count es mas rapido
            0 < (select count(*)
                 from suirplus.ars_cartera_t b
                 where b.periodo_factura_ars != a.periodo_factura
                   and b.nss_titular=a.nss_titular
                   and b.nss_dependiente=a.nss_afiliado_pagado
                   and b.tipo_afiliado='D'
                   and b.codigo_parentesco='20'
                 )
            OR
            --Esta duplicado en este envío
            1 <= (select count(*)
                  from suirplus.ars_dispersion d
                  join suirplus.ars_cartera_t c1
                    on c1.periodo_factura_ars=d.periodo_factura
                   and c1.nss_titular=d.nss_titular
                   and c1.nss_dependiente=d.nss_afiliado_pagado
                   and c1.tipo_afiliado='D'
                   and c1.codigo_parentesco='20'
                  where d.nss_titular=a.nss_titular
                    and d.nss_afiliado_pagado=a.nss_afiliado_pagado
                    and d.periodo_factura<>a.periodo_factura
                    and d.codigo_ars=a.codigo_ars
                  );

      m_hora_termina := sysdate;
      debug('Dispersion: ciclo '||p_ciclo||' validacion #'||m_validacion||' - terminada a las '||to_char(m_hora_termina,'dd/mm/yyyy hh:mi:ss')||
            ' - Tiempo total: ('||
            TRIM(TO_CHAR(EXTRACT(HOUR FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
            TRIM(TO_CHAR(EXTRACT(MINUTE FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
            TRIM(TO_CHAR(EXTRACT(SECOND FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||
            ') - total registros: '|| sql%rowcount);

--      debug('validar_dispersion: ' || m_validacion ||', total registros: '|| sql%rowcount);
      commit;

      -- 1ra. Dispersion fuera de Periodo
      -- para recien nacidos. TODOS LOS CICLOS
      -- Evaluar los 60 dias de cobertura. considerar 59 d?as ya que se incluye en d?a de nacimiento.
      /*
      ---------------------------------------
      GH 18-oct-2012
      Comentada para cumplir con el requerimiento del ticket 5238
      ---------------------------------------
      m_validacion := 24;
      insert into suirplus.ars_dispersion_con_errores_t
      -- Si la 1ra Dispersion esta fuera de periodo y el pago no es del periodo en Proceso,
      --  entonces, es un registro invalido
        select a.codigo_ars,
               a.periodo_factura,
               a.nss_titular,
               a.nss_afiliado_pagado,
               a.nss_dispara_pago,
               a.id_referencia,
               a.monto_dispersar,
               a.fecha_consolidado,
               m_validacion,
               m_hoy,
               m_carga_seq
          from (select a.codigo_ars,
                       a.periodo_factura,
                       a.nss_titular,
                       a.nss_afiliado_pagado,
                       a.nss_dispara_pago,
                       a.id_referencia,
                       a.monto_dispersar,
                       a.fecha_consolidado
                  from suirplus.ars_dispersion a
                 where (a.codigo_ars, a.periodo_factura, a.nss_titular,
                        a.nss_afiliado_pagado) in
                       (
                        --  Buscar TODOS los registros en Dispersion que no se han dispersado antes:
                        --  1.- Que el periodo en dispersion no sea al actual (TO_Char( add_months(SYSDATE, -1), 'YYYYMM')).
                        --  2.- Que el Monto Dispersado en cartera sea igual a cero.
                        --      2.1.- Sumar "Monto Dispersado" para todos los periodos en cartera,
                        --            menos el periodo actual y el periodo a dispersar.
                        select a.codigo_ars,
                                a.periodo_factura,
                                a.nss_titular,
                                a.nss_afiliado_pagado
                          from suirplus.ars_dispersion a
                          join suirplus.ars_cartera_t c
                            on c.id_ars = a.codigo_ars
                           and c.periodo_factura_ars != m_per_actual
                           and c.periodo_factura_ars != a.periodo_factura
                           and c.nss_titular = a.nss_titular
                           and c.nss_dependiente = a.nss_afiliado_pagado
                         where a.periodo_factura != m_per_actual
                         group by a.codigo_ars,
                                   a.periodo_factura,
                                   a.nss_titular,
                                   a.nss_afiliado_pagado
                        having sum(nvl(c.monto_dispersar, 0)) = 0
                        Union all
                        select a.codigo_ars,
                               a.periodo_factura,
                               a.nss_titular,
                               a.nss_afiliado_pagado
                          from suirplus.ars_dispersion a
                          join suirplus.ars_cat_inactiva_t x
                            on x.id_ars_actual = a.codigo_ars
                           and x.periodo_factura <= m_per_actual
                          join suirplus.ars_cartera_t c
                            on c.id_ars = x.id_ars_anterior
                           and c.periodo_factura_ars != m_per_actual
                           and c.periodo_factura_ars != a.periodo_factura
                           and c.nss_titular = a.nss_titular
                           and c.nss_dependiente = a.nss_afiliado_pagado
                         where a.periodo_factura != m_per_actual
                         group by a.codigo_ars,
                                  a.periodo_factura,
                                  a.nss_titular,
                                  a.nss_afiliado_pagado
                        having sum(nvl(c.monto_dispersar, 0)) = 0)) a
          join suirplus.sfc_facturas_v f
            on f.id_referencia = NVL(a.id_referencia, '1')
           and to_Char(f.fecha_pago, 'YYYYMM') != m_per_actual
        minus
        -- Descatamos los registros que vengan por la vista de recien nacidos.
        select a.codigo_ars,
               a.periodo_factura,
               a.nss_titular,
               a.nss_afiliado_pagado,
               a.nss_dispara_pago,
               a.id_referencia,
               a.monto_dispersar,
               a.fecha_consolidado,
               m_validacion,
               m_hoy,
               m_carga_seq
          from suirplus.ars_dispersion a
          join ars_cartera_t c
            on c.periodo_factura_ars = a.periodo_factura
           and c.nss_titular = a.nss_titular
           and c.nss_dependiente = a.nss_afiliado_pagado
          join ars_carga_t m
            on m.id_carga = c.id_carga_cartera
           and m.vista = 'ARS_RECLAMO_RECIEN_NACIDOS_MV';
      debug('validar_dispersion: ' || m_validacion ||', total registros: '|| sql%rowcount);
      commit;

      ---------------------------------------
      --GH 27-dec-2012
      --Para corregir interpretacion del requerimiento del ticket 5238
      ---------------------------------------
      m_validacion := 24;
      insert into suirplus.ars_dispersion_con_errores_t
      -- Si el periodo reportado es mayor a 12 meses rechazamo el registro
        select a.codigo_ars,
               a.periodo_factura,
               a.nss_titular,
               a.nss_afiliado_pagado,
               a.nss_dispara_pago,
               a.id_referencia,
               a.monto_dispersar,
               a.fecha_consolidado,
               m_validacion,
               m_hoy,
               m_carga_seq
          from suirplus.ars_dispersion a
          where months_between(to_date(m_per_actual,'YYYYMM'), to_date(a.periodo_factura,'YYYYMM')) > 12
        minus
        -- Descartamos los registros que vengan por la vista de recien nacidos.
        select a.codigo_ars,
               a.periodo_factura,
               a.nss_titular,
               a.nss_afiliado_pagado,
               a.nss_dispara_pago,
               a.id_referencia,
               a.monto_dispersar,
               a.fecha_consolidado,
               m_validacion,
               m_hoy,
               m_carga_seq
          from suirplus.ars_dispersion a
          join ars_cartera_t c
            on c.periodo_factura_ars = a.periodo_factura
           and c.nss_titular = a.nss_titular
           and c.nss_dependiente = a.nss_afiliado_pagado
          join ars_carga_t m
            on m.id_carga = c.id_carga_cartera
           and m.vista = 'ARS_RECLAMO_RECIEN_NACIDOS_MV';
      debug('validar_dispersion: ' || m_validacion ||', total registros: '|| sql%rowcount);
      commit;
*/
      -- RP: 2008-11-04
      -- NSS Cancelado o con 777 en municipio.
      -- C13: Resolucion 192-04 CNSS
      m_validacion := 26;

      m_hora_inicio := sysdate;
      debug('Dispersion: ciclo '||p_ciclo||' validacion #'||m_validacion||' - iniciada a las '||to_char(m_hora_inicio,'dd/mm/yyyy hh:mi:ss'));

      insert into suirplus.ars_dispersion_con_errores_t
        select a.codigo_ars,
               a.periodo_factura,
               a.nss_titular,
               a.nss_afiliado_pagado,
               a.nss_dispara_pago,
               a.id_referencia,
               a.monto_dispersar,
               a.fecha_consolidado,
               m_validacion,
               m_hoy,
               m_carga_seq
          from suirplus.ars_dispersion a
          join suirplus.sre_ciudadanos_t c
            on c.id_nss = a.nss_afiliado_pagado
           and c.municipio_acta = 777;

      m_hora_termina := sysdate;
      debug('Dispersion: ciclo '||p_ciclo||' validacion #'||m_validacion||' - terminada a las '||to_char(m_hora_termina,'dd/mm/yyyy hh:mi:ss')||
            ' - Tiempo total: ('||
            TRIM(TO_CHAR(EXTRACT(HOUR FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
            TRIM(TO_CHAR(EXTRACT(MINUTE FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
            TRIM(TO_CHAR(EXTRACT(SECOND FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||
            ') - total registros: '|| sql%rowcount);

--      debug('validar_dispersion: ' || m_validacion ||', total registros: '|| sql%rowcount);
      commit;

      /*
          -- 777 fuera de los periodo validos.
          m_validacion := 26;
          insert into suirplus.ars_dispersion_con_errores_t
            select a.codigo_ars, a.periodo_factura, a.nss_titular, a.nss_afiliado_pagado,
                   a.nss_dispara_pago, a.id_referencia, a.monto_dispersar,
                   a.fecha_consolidado, m_validacion, m_hoy, m_carga_seq
              from suirplus.ars_dispersion a
                   join suirplus.sre_ciudadanos_t c on c.id_nss= a.nss_afiliado_pagado
                                                   and c.municipio_acta=777
             where a.periodo_factura >= '200807';
      */

      -- NSS dispara pago no es del tipo apropiado
      m_validacion := 20;

      m_hora_inicio := sysdate;
      debug('Dispersion: ciclo '||p_ciclo||' validacion #'||m_validacion||' - iniciada a las '||to_char(m_hora_inicio,'dd/mm/yyyy hh:mi:ss'));

      insert into suirplus.ars_dispersion_con_errores_t
        with registros as
         (select d.*, 20 id_error, c.tipo_afiliado, c.codigo_parentesco
            from ars_cartera_t c, ars_dispersion d
           where c.id_ars = d.codigo_ars
             and c.periodo_factura_ars = d.periodo_factura
             and c.nss_titular = d.nss_titular
             and c.nss_dependiente = NVL(d.nss_dispara_pago, 0))
        --  tomar todos los registros a dispersar que existan en cartera
        select codigo_ars,
               periodo_factura,
               nss_titular,
               nss_afiliado_pagado,
               nss_dispara_pago,
               id_referencia,
               monto_dispersar,
               fecha_consolidado,
               id_error,
               m_hoy,
               m_carga_seq
          from registros r1
        minus
        --  restarle todos los registros que son dependientes y estan correcto
        select codigo_ars,
               periodo_factura,
               nss_titular,
               nss_afiliado_pagado,
               nss_dispara_pago,
               id_referencia,
               monto_dispersar,
               fecha_consolidado,
               id_error,
               m_hoy,
               m_carga_seq
          from registros r2
         where r2.tipo_afiliado = 'D'
           and r2.codigo_parentesco in ('3', '03', '4', '04', '19', '20')
        minus
        --  restarle todos los registros que son titulares o adicionales
        select codigo_ars,
               periodo_factura,
               nss_titular,
               nss_afiliado_pagado,
               nss_dispara_pago,
               id_referencia,
               monto_dispersar,
               fecha_consolidado,
               id_error,
               m_hoy,
               m_carga_seq
          from registros r3
         where r3.tipo_afiliado = 'T'
        minus
        --  restarle todos los registros que son titulares o adicionales
        select codigo_ars,
               periodo_factura,
               nss_titular,
               nss_afiliado_pagado,
               nss_dispara_pago,
               id_referencia,
               monto_dispersar,
               fecha_consolidado,
               id_error,
               m_hoy,
               m_carga_seq
          from registros r4
         where r4.tipo_afiliado = 'A'
           and NVL(r4.nss_dispara_pago, 0) != nss_afiliado_pagado;

      m_hora_termina := sysdate;
      debug('Dispersion: ciclo '||p_ciclo||' validacion #'||m_validacion||' - terminada a las '||to_char(m_hora_termina,'dd/mm/yyyy hh:mi:ss')||
            ' - Tiempo total: ('||
            TRIM(TO_CHAR(EXTRACT(HOUR FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
            TRIM(TO_CHAR(EXTRACT(MINUTE FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
            TRIM(TO_CHAR(EXTRACT(SECOND FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||
            ') - total registros: '|| sql%rowcount);

--      debug('validar_dispersion: ' || m_validacion ||', total registros: '|| sql%rowcount);
      commit;

      -- registros duplicados
      m_validacion := 10;

      m_hora_inicio := sysdate;
      debug('Dispersion: ciclo '||p_ciclo||' validacion #'||m_validacion||' - iniciada a las '||to_char(m_hora_inicio,'dd/mm/yyyy hh:mi:ss'));

      insert into suirplus.ars_dispersion_con_errores_t
        select a.*, m_validacion, m_hoy, m_carga_seq
          from suirplus.ars_dispersion a
         where (a.codigo_ars, a.periodo_factura, a.nss_titular,
                a.nss_afiliado_pagado) in
               (select a.codigo_ars,
                       a.periodo_factura,
                       a.nss_titular,
                       a.nss_afiliado_pagado
                  from suirplus.ars_dispersion a
                 group by a.codigo_ars,
                          a.periodo_factura,
                          a.nss_titular,
                          a.nss_afiliado_pagado
                having count(*) > 1);

      m_hora_termina := sysdate;
      debug('Dispersion: ciclo '||p_ciclo||' validacion #'||m_validacion||' - terminada a las '||to_char(m_hora_termina,'dd/mm/yyyy hh:mi:ss')||
            ' - Tiempo total: ('||
            TRIM(TO_CHAR(EXTRACT(HOUR FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
            TRIM(TO_CHAR(EXTRACT(MINUTE FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
            TRIM(TO_CHAR(EXTRACT(SECOND FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||
            ') - total registros: '|| sql%rowcount);

--      debug('validar_dispersion: ' || m_validacion ||', total registros: '|| sql%rowcount);
      commit;

      -- el nss_dispara_pago debe existir en el detalle de la referencia
      m_validacion := 19;

      m_hora_inicio := sysdate;
      debug('Dispersion: ciclo '||p_ciclo||' validacion #'||m_validacion||' - iniciada a las '||to_char(m_hora_inicio,'dd/mm/yyyy hh:mi:ss'));

      insert into suirplus.ars_dispersion_con_errores_t
        with registros as
         (select d.*, 19 id_error, c.tipo_afiliado
            from ars_cartera_t c, ars_dispersion d
           where c.id_ars = d.codigo_ars
             and c.periodo_factura_ars = d.periodo_factura
             and c.nss_titular = d.nss_titular
             and c.nss_dependiente = d.nss_dispara_pago
             and NVL(d.id_referencia, '1') NOT IN
                 ('5555555555555550', '4444444444444444'))
        --  tomar todos los registros a dispersar que existan en cartera
        select codigo_ars,
               periodo_factura,
               nss_titular,
               nss_afiliado_pagado,
               nss_dispara_pago,
               id_referencia,
               monto_dispersar,
               fecha_consolidado,
               id_error,
               m_hoy,
               m_carga_seq
          from registros r1
        minus
        --  restarle todos los registros que son titular o dependientes y estan en sfc_det_facturas_t
        select codigo_ars,
               periodo_factura,
               nss_titular,
               nss_afiliado_pagado,
               nss_dispara_pago,
               id_referencia,
               monto_dispersar,
               fecha_consolidado,
               id_error,
               m_hoy,
               m_carga_seq
          from registros r2
         where r2.tipo_afiliado in ('T', 'D')
           and exists
         (Select 1
                  from sfc_det_facturas_t f
                 where NVL(r2.id_referencia, '1') = f.id_referencia
                   and NVL(r2.nss_dispara_pago, 0) = f.id_nss)
        minus
        --  restarle todos los registros que son adicionales y estan en sfc_det_dependientes_factura_t
        select codigo_ars,
               periodo_factura,
               nss_titular,
               nss_afiliado_pagado,
               nss_dispara_pago,
               id_referencia,
               monto_dispersar,
               fecha_consolidado,
               id_error,
               m_hoy,
               m_carga_seq
          from registros r3
         where r3.tipo_afiliado = 'A'
           and exists (Select 1
                  from sfc_det_dependientes_factura_t s
                 where r3.id_referencia = s.id_referencia
                   and NVL(r3.nss_dispara_pago, 0) =
                       s.id_nss_dependiente_adic);

      m_hora_termina := sysdate;
      debug('Dispersion: ciclo '||p_ciclo||' validacion #'||m_validacion||' - terminada a las '||to_char(m_hora_termina,'dd/mm/yyyy hh:mi:ss')||
            ' - Tiempo total: ('||
            TRIM(TO_CHAR(EXTRACT(HOUR FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
            TRIM(TO_CHAR(EXTRACT(MINUTE FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
            TRIM(TO_CHAR(EXTRACT(SECOND FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||
            ') - total registros: '|| sql%rowcount);

--      debug('validar_dispersion: ' || m_validacion ||', total registros: '|| sql%rowcount);
      commit;

      -- Per Capita SFS Regimen Contributivo
      -- Tipo dependientes titulares y dependientes hijos
      
      m_hora_inicio := sysdate;
      debug('Dispersion: ciclo '||p_ciclo||' validaciones #27 & 28'||m_validacion||' - iniciada a las '||to_char(m_hora_inicio,'dd/mm/yyyy hh:mi:ss'));
      
      For c_periodo in (select distinct periodo_factura
                        from ars_dispersion
                        order by periodo_factura desc) Loop
        m_parm := Parm(to_number(c_periodo.periodo_factura));

        m_validacion := 27;
        insert into suirplus.ars_dispersion_con_errores_t
          (codigo_ars,
           periodo_factura,
           nss_titular,
           nss_afiliado_pagado,
           nss_dispara_pago,
           id_referencia,
           nombre_nacha,
           fecha_envio_nacha,
           id_error,
           fecha_registro,
           id_carga)
          select a.codigo_ars,
                 a.periodo_factura,
                 a.nss_titular,
                 a.nss_afiliado_pagado,
                 a.nss_dispara_pago,
                 a.id_referencia,
                 a.monto_dispersar,
                 a.fecha_consolidado,
                 m_validacion,
                 m_hoy,
                 m_carga_seq
            from suirplus.ars_dispersion a
            join suirplus.ars_cartera_t c
              on c.periodo_factura_ars = a.periodo_factura
             and c.nss_titular = a.nss_titular
             and c.nss_dependiente = a.nss_afiliado_pagado
             and c.tipo_afiliado in ('T', 'D')
           Where a.periodo_factura = c_periodo.periodo_factura
             and a.monto_dispersar != m_parm.sfs_per_capita_contributivo;
        debug('validar_dispersion: ' || m_validacion ||
              ', periodo: '||c_periodo.periodo_factura||
              ', total registros: '|| sql%rowcount);
        commit;

        -- Per Capita SFS Dependiente Adicional Regimen Contributivo
        -- Tipo dependientes adicionales (padres, madres, hermanos, etc.)
        m_validacion := 28;
        insert into suirplus.ars_dispersion_con_errores_t
          (codigo_ars,
           periodo_factura,
           nss_titular,
           nss_afiliado_pagado,
           nss_dispara_pago,
           id_referencia,
           nombre_nacha,
           fecha_envio_nacha,
           id_error,
           fecha_registro,
           id_carga)
          select a.codigo_ars,
                 a.periodo_factura,
                 a.nss_titular,
                 a.nss_afiliado_pagado,
                 a.nss_dispara_pago,
                 a.id_referencia,
                 a.monto_dispersar,
                 a.fecha_consolidado,
                 m_validacion,
                 m_hoy,
                 m_carga_seq
            from suirplus.ars_dispersion a
            join suirplus.ars_cartera_t c
              on c.periodo_factura_ars = a.periodo_factura
             and c.nss_titular = a.nss_titular
             and c.nss_dependiente = a.nss_afiliado_pagado
             and c.tipo_afiliado = 'A'
           Where a.periodo_factura = c_periodo.periodo_factura
             and a.monto_dispersar != m_parm.sfs_per_capita_adicional;
        debug('validar_dispersion: ' || m_validacion ||
              ', periodo: '||c_periodo.periodo_factura||
              ', total registros: '|| sql%rowcount);
        commit;
      End Loop;

      m_hora_termina := sysdate;
      debug('Dispersion: ciclo '||p_ciclo||' validaciones 27 & 28 #'||m_validacion||' - terminada a las '||to_char(m_hora_termina,'dd/mm/yyyy hh:mi:ss')||
            ' - Tiempo total: ('||
            TRIM(TO_CHAR(EXTRACT(HOUR FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
            TRIM(TO_CHAR(EXTRACT(MINUTE FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
            TRIM(TO_CHAR(EXTRACT(SECOND FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||
            ')');

      -- 16-OCT-2012  G. Herrera
      -- Pagos en exceso por dependientes Adicional pagados no dispersados en ARS
      m_validacion := 38;

      m_hora_inicio := sysdate;
      debug('Dispersion: ciclo '||p_ciclo||' validacion #'||m_validacion||' - iniciada a las '||to_char(m_hora_inicio,'dd/mm/yyyy hh:mi:ss'));

      insert into suirplus.ars_dispersion_con_errores_t
        (codigo_ars,
         periodo_factura,
         nss_titular,
         nss_afiliado_pagado,
         nss_dispara_pago,
         id_referencia,
         nombre_nacha,
         fecha_envio_nacha,
         id_error,
         fecha_registro,
         id_carga)
      select a.codigo_ars,
             a.periodo_factura,
             a.nss_titular,
             a.nss_afiliado_pagado,
             a.nss_dispara_pago,
             a.id_referencia,
             a.monto_dispersar,
             a.fecha_consolidado,
             m_validacion,
             m_hoy,
             m_carga_seq
      from suirplus.ars_dispersion a
      join suirplus.ars_adic_paga_no_disp_t b
        on b.id_nss_dependiente = a.nss_afiliado_pagado
       and b.id_nss_titular = a.nss_titular
       and b.id_referencia = a.id_referencia
      join suirplus.ars_cartera_t c
        on c.periodo_factura_ars = a.periodo_factura
       and c.nss_titular = a.nss_titular
       and c.nss_dependiente = a.nss_afiliado_pagado
       and c.tipo_afiliado = 'A';

      m_hora_termina := sysdate;
      debug('Dispersion: ciclo '||p_ciclo||' validacion #'||m_validacion||' - terminada a las '||to_char(m_hora_termina,'dd/mm/yyyy hh:mi:ss')||
            ' - Tiempo total: ('||
            TRIM(TO_CHAR(EXTRACT(HOUR FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
            TRIM(TO_CHAR(EXTRACT(MINUTE FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
            TRIM(TO_CHAR(EXTRACT(SECOND FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||
            ') - total registros: '|| sql%rowcount);

--      debug('validar_dispersion: ' || m_validacion ||', total registros: '|| sql%rowcount);
      commit;

      -- 1ra. Dispersion fuera de Periodo
      -- GHERRERA: 06-MAY-2013
      m_validacion := 24;

      m_hora_inicio := sysdate;
      debug('Dispersion: ciclo '||p_ciclo||' validacion #'||m_validacion||' - iniciada a las '||to_char(m_hora_inicio,'dd/mm/yyyy hh:mi:ss'));
      
      Declare
          m_periodo_desde varchar2(6) := to_char(add_months(to_date(m_per_actual, 'YYYYMM'), -12), 'YYYYMM');
      Begin
        --Los que nunca han sido dispersados en cartera con mas de 12 meses anteriores
        --y que no halla venido por la vista de recien nacidos
        insert into suirplus.ars_dispersion_con_errores_t
          select x.codigo_ars,
                 x.periodo_factura,
                 x.nss_titular,
                 x.nss_afiliado_pagado,
                 x.nss_dispara_pago,
                 x.id_referencia,
                 x.monto_dispersar,
                 x.fecha_consolidado,
                 m_validacion,
                 m_hoy,
                 m_carga_seq
           from suirplus.ars_dispersion x
           join suirplus.sfc_facturas_t f
             on f.id_referencia = x.id_referencia
          where x.periodo_factura not between m_periodo_desde and CASE WHEN to_char(f.fecha_pago, 'YYYYMM') < m_periodo_desde THEN m_periodo_desde ELSE to_char(f.fecha_pago, 'YYYYMM') END
            and 0 = (select count(*)
                       from suirplus.ars_cartera_t c
                      where c.nss_dependiente = x.nss_afiliado_pagado
                        and NVL(c.registro_dispersado, 'N') = 'S')
            and 0 = (select count(*)
                     from suirplus.ars_cartera_t c
                     join ars_carga_t m
                       on m.id_carga = c.id_carga_cartera
                      and m.vista = 'ARS_RECLAMO_RECIEN_NACIDOS_MV'
                    where c.periodo_factura_ars = x.periodo_factura
                      and c.nss_titular = x.nss_titular
                      and c.nss_dependiente = x.nss_afiliado_pagado);

        m_hora_termina := sysdate;
        debug('Dispersion: ciclo '||p_ciclo||' validacion #'||m_validacion||' - terminada a las '||to_char(m_hora_termina,'dd/mm/yyyy hh:mi:ss')||
              ' - Tiempo total: ('||
              TRIM(TO_CHAR(EXTRACT(HOUR FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
              TRIM(TO_CHAR(EXTRACT(MINUTE FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
              TRIM(TO_CHAR(EXTRACT(SECOND FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||
              ') - total registros: '|| sql%rowcount);

--        debug('validar_dispersion: ' || m_validacion ||', total registros: '|| sql%rowcount);
        commit;
      End;

      -- si el titular tiene error, no dispersar sus dependientes
      -- ESTA DEBE SER LA ULTIMA VALIDACION
      m_validacion := 21;

      m_hora_inicio := sysdate;
      debug('Dispersion: ciclo '||p_ciclo||' validacion #'||m_validacion||' - iniciada a las '||to_char(m_hora_inicio,'dd/mm/yyyy hh:mi:ss'));

      insert into suirplus.ars_dispersion_con_errores_t
        (codigo_ars,
         periodo_factura,
         nss_titular,
         nss_afiliado_pagado,
         nss_dispara_pago,
         id_referencia,
         nombre_nacha,
         fecha_envio_nacha,
         id_error,
         fecha_registro,
         id_carga)
        select a.codigo_ars,
               a.periodo_factura,
               a.nss_titular,
               a.nss_afiliado_pagado,
               a.nss_dispara_pago,
               a.id_referencia,
               a.monto_dispersar,
               a.fecha_consolidado,
               m_validacion,
               m_hoy,
               m_carga_seq
          from suirplus.ars_dispersion a
          join suirplus.ars_dispersion_con_errores_t e
            on e.codigo_ars = a.codigo_ars
           and e.periodo_factura = a.periodo_factura
           and e.nss_titular = a.nss_titular
           and e.nss_afiliado_pagado = a.nss_titular
           and e.id_carga = m_carga_seq
         where a.nss_titular <> a.nss_afiliado_pagado;

      m_hora_termina := sysdate;
      debug('Dispersion: ciclo '||p_ciclo||' validacion #'||m_validacion||' - terminada a las '||to_char(m_hora_termina,'dd/mm/yyyy hh:mi:ss')||
            ' - Tiempo total: ('||
            TRIM(TO_CHAR(EXTRACT(HOUR FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
            TRIM(TO_CHAR(EXTRACT(MINUTE FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
            TRIM(TO_CHAR(EXTRACT(SECOND FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||
            ') - total registros: '|| sql%rowcount);

--      debug('validar_dispersion: ' || m_validacion ||', total registros: '|| sql%rowcount);
      commit;

      -- Enviar email indicando corrida satisfactoria
      -- enviar_email('D',m_carga_seq);

    Elsif (p_ciclo = 2) Then
      --Esto es para FONOMAT
      DECLARE
        --Para declarar las variables propias de este proceso
        --v_monto_dep_adicional    number(13, 2);
        --v_monto_titular_directo  number(13, 2);
        --v_monto_capita_fonamat   number(13, 2);
        v_periodo_inicio_fonamat varchar2(6);
      BEGIN
        -- obtener el total de registros a procesar
        select count(*)
          into m_registros
          from suirplus.ars_dispersion_fonamat;

        debug('validacion dispersion ciclo 2: total registros a procesar: ' ||m_registros);

        --Para validar que el periodo de la dispersion sea mayor o igual al parametro que marca
        --el inicio de FONAMAT para titulares y dependientes directos
        --Tambien se incluye que el periodo de la dispersion no sea menor que la fecha de nacimiento del afiliado
        v_periodo_inicio_fonamat := TO_CHAR(Parm.get_parm_number(352));
        m_validacion             := 2;

        m_hora_inicio := sysdate;
        debug('Dispersion: ciclo '||p_ciclo||' validacion #'||m_validacion||' - iniciada a las '||to_char(m_hora_inicio,'dd/mm/yyyy hh:mi:ss'));
        
        insert into suirplus.ars_dispersion_con_errores_t
          (codigo_ars,
           periodo_factura,
           nss_titular,
           nss_afiliado_pagado,
           nss_dispara_pago,
           id_referencia,
           nombre_nacha,
           fecha_envio_nacha,
           id_error,
           fecha_registro,
           id_carga)
        -- Todos los registros de Dispersion
          select a.codigo_ars,
                 a.periodo_factura,
                 a.nss_titular,
                 a.nss_afiliado_pagado,
                 a.nss_dispara_pago,
                 a.id_referencia,
                 a.monto_dispersar,
                 a.fecha_consolidado,
                 m_validacion,
                 m_hoy,
                 m_carga_seq
            from suirplus.ars_dispersion_fonamat a

          MINUS

          -- Menos registros con periodos anteriores al inicio de FONAMAT para titulares y dependientes directos.
          select a.codigo_ars,
                 a.periodo_factura,
                 a.nss_titular,
                 a.nss_afiliado_pagado,
                 a.nss_dispara_pago,
                 a.id_referencia,
                 a.monto_dispersar,
                 a.fecha_consolidado,
                 m_validacion,
                 m_hoy,
                 m_carga_seq
            from suirplus.ars_dispersion_fonamat a
            join suirplus.ars_cartera_t c
              on c.periodo_factura_ars = a.periodo_factura
             and c.nss_titular = NVL(a.nss_titular, 0)
             and c.nss_dependiente = NVL(a.nss_afiliado_pagado, 0)
             and c.tipo_afiliado in ('T', 'D') --Titulares y dependientes directos
             and c.id_ars = NVL(a.codigo_ars, 0)
           where a.periodo_factura >= v_periodo_inicio_fonamat

          MINUS

          -- Menos registros con periodos anteriores al inicio de FONAMAT para dependientes adicionales.
          select a.codigo_ars,
                 a.periodo_factura,
                 a.nss_titular,
                 a.nss_afiliado_pagado,
                 a.nss_dispara_pago,
                 a.id_referencia,
                 a.monto_dispersar,
                 a.fecha_consolidado,
                 m_validacion,
                 m_hoy,
                 m_carga_seq
            from suirplus.ars_dispersion_fonamat a
            join suirplus.ars_cartera_t c
              on c.periodo_factura_ars = NVL(a.periodo_factura, '0')
             and c.nss_titular = NVL(a.nss_titular, 0)
             and c.nss_dependiente = NVL(a.nss_afiliado_pagado, 0)
             and c.tipo_afiliado = 'A' --Dependientes adicionales
             and c.id_ars = NVL(a.codigo_ars, 0)
           where a.periodo_factura >= v_periodo_inicio_fonamat
/*                 to_number(to_char(ADD_MONTHS(to_date(v_periodo_inicio_fonamat,
                                                      'yyyymm'),
                                              1),
                                   'yyyymm'))
*/                                   
          MINUS
          
          -- Menos registros con periodos anteriores a la fecha de nacimiento del afiliado
          select a.codigo_ars,
                 a.periodo_factura,
                 a.nss_titular,
                 a.nss_afiliado_pagado,
                 a.nss_dispara_pago,
                 a.id_referencia,
                 a.monto_dispersar,
                 a.fecha_consolidado,
                 m_validacion,
                 m_hoy,
                 m_carga_seq
            from suirplus.ars_dispersion_fonamat a
            join sre_ciudadanos_t b
              on b.id_nss = NVL(a.nss_afiliado_pagado,0)
           where a.periodo_factura < to_char(b.fecha_nacimiento, 'YYYYMM');
                                             
--        debug('validacion_dispersion: ' || m_validacion||', total registros: '||sql%rowcount);
        m_hora_termina := sysdate;
        debug('Dispersion: ciclo '||p_ciclo||' validacion #'||m_validacion||' - terminada a las '||to_char(m_hora_termina,'dd/mm/yyyy hh:mi:ss')||
              ' - Tiempo total: ('||
              TRIM(TO_CHAR(EXTRACT(HOUR FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
              TRIM(TO_CHAR(EXTRACT(MINUTE FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
              TRIM(TO_CHAR(EXTRACT(SECOND FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||
              ') - total registros: '|| sql%rowcount);

        commit;

        -- que rechace cualquier ciudadano cancelado (excepto por muerte)
		m_validacion := 37;

		m_hora_inicio := sysdate;
		debug('Dispersion: ciclo '||p_ciclo||' validacion #'||m_validacion||' - iniciada a las '||to_char(m_hora_inicio,'dd/mm/yyyy hh:mi:ss'));

		insert into suirplus.ars_dispersion_con_errores_t
		(codigo_ars,
         periodo_factura,
         nss_titular,
         nss_afiliado_pagado,
         nss_dispara_pago,
         id_referencia,
         nombre_nacha,
         fecha_envio_nacha,
         id_error,
         fecha_registro,
         id_carga)
		-- Todos los registros de Dispersion
        select a.codigo_ars,
               a.periodo_factura,
               a.nss_titular,
               a.nss_afiliado_pagado,
               a.nss_dispara_pago,
               a.id_referencia,
               a.monto_dispersar,
               a.fecha_consolidado,
               m_validacion,
               m_hoy,
               m_carga_seq
          from suirplus.ars_dispersion a
         where SUIRPLUS.SRE_CIUDADANO_INACTIVO_F(nvl(a.nss_afiliado_pagado, a.nss_titular), TO_NUMBER(a.periodo_factura)) = 'N'; -- No se debe pagar la capita

		m_hora_termina := sysdate;
		debug('Dispersion: ciclo '||p_ciclo||' validacion #'||m_validacion||' - terminada a las '||to_char(m_hora_termina,'dd/mm/yyyy hh:mi:ss')||
			' - Tiempo total: ('||
			TRIM(TO_CHAR(EXTRACT(HOUR FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
			TRIM(TO_CHAR(EXTRACT(MINUTE FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
			TRIM(TO_CHAR(EXTRACT(SECOND FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||
			') - total registros: '|| sql%rowcount);

		commit;

        -- Para obtener los montos para FONOMAT
        --v_monto_capita_fonamat  := Parm.get_parm_number(349);
        --v_monto_dep_adicional   := Parm.get_parm_number(349) + Parm.get_parm_number(350);
        --v_monto_titular_directo := Parm.get_parm_number(349) + Parm.get_parm_number(351);

        -- validar el monto a dispersar contra el valor del parametro 349 y el 350
        -- para los titulares, dependientes directos y dependientes adicionales.
        m_validacion := 35;

        m_hora_inicio := sysdate;
        debug('Dispersion: ciclo '||p_ciclo||' validacion #'||m_validacion||' - iniciada a las '||to_char(m_hora_inicio,'dd/mm/yyyy hh:mi:ss'));

        insert into suirplus.ars_dispersion_con_errores_t
          (codigo_ars,
           periodo_factura,
           nss_titular,
           nss_afiliado_pagado,
           nss_dispara_pago,
           id_referencia,
           nombre_nacha,
           fecha_envio_nacha,
           id_error,
           fecha_registro,
           id_carga)
          select a.codigo_ars,
                 a.periodo_factura,
                 a.nss_titular,
                 a.nss_afiliado_pagado,
                 a.nss_dispara_pago,
                 a.id_referencia,
                 a.monto_dispersar,
                 a.fecha_consolidado,
                 m_validacion,
                 m_hoy,
                 m_carga_seq
            from suirplus.ars_dispersion_fonamat a

          MINUS

          -- Menos las referencias de factura validas, sin recargo en SFS, el dependiente debe
          -- existir en la factura y debe traer el mismo monto que tiene en la factura
          select a.codigo_ars,
                 a.periodo_factura,
                 a.nss_titular,
                 a.nss_afiliado_pagado,
                 a.nss_dispara_pago,
                 a.id_referencia,
                 a.monto_dispersar,
                 a.fecha_consolidado,
                 m_validacion,
                 m_hoy,
                 m_carga_seq
            from suirplus.ars_dispersion_fonamat a
            join suirplus.ars_cartera_t c
              on c.periodo_factura_ars = NVL(a.periodo_factura, 0)
             and c.nss_titular = NVL(a.nss_titular, 0)
             and c.nss_dependiente = NVL(a.nss_afiliado_pagado, 0)
             and c.tipo_afiliado = 'A' --Dependientes Adicionales
             and c.id_ars = NVL(a.codigo_ars, 0)
            join suirplus.sfc_facturas_v f
              on f.ID_REFERENCIA = a.id_referencia
             and f.status = 'PA'
             and NVL(f.total_recargo_sfs, 0) = 0
            join sfc_det_dependientes_factura_t d
              on d.id_referencia = a.id_referencia
             and d.id_nss_dependiente_adic = NVL(a.nss_afiliado_pagado, 0)
             and NVL(d.per_capita_fonamat, 0) = NVL(a.monto_dispersar, 0)
           where NVL(a.id_referencia, '1') != '4444444444444444'
             and a.periodo_factura >= v_periodo_inicio_fonamat
/*                 to_number(to_char(ADD_MONTHS(to_date(v_periodo_inicio_fonamat,
                                                      'yyyymm'),
                                              1),
                                   'yyyymm')) --Inicio FONAMAT + 1
*/
          MINUS

          --Menos los registros '4444444444444444' que no existan para los meses Enero-Febrero-Marzo
          --y el monto a dispersar sea igual al per capita de fonomat
          select a.codigo_ars,
                 a.periodo_factura,
                 a.nss_titular,
                 a.nss_afiliado_pagado,
                 a.nss_dispara_pago,
                 a.id_referencia,
                 a.monto_dispersar,
                 a.fecha_consolidado,
                 m_validacion,
                 m_hoy,
                 m_carga_seq
            from suirplus.ars_dispersion_fonamat a
            join suirplus.ars_cartera_t c
              on c.periodo_factura_ars = NVL(a.periodo_factura, 0)
             and c.nss_titular = NVL(a.nss_titular, 0)
             and c.nss_dependiente = NVL(a.nss_afiliado_pagado, 0)
             and c.tipo_afiliado = 'A' --Dependientes Adicionales
             and c.id_ars = NVL(a.codigo_ars, 0)
           where NVL(a.id_referencia, '1') = '4444444444444444'
             and Not Exists
           (Select 1
                    From suirplus.SRE_ADICIONALES_RES_265_01_T r
                   Where r.id_nss_afiliado = NVL(a.nss_afiliado_pagado, 0))
             and monto_valido(a.nss_afiliado_pagado, a.periodo_factura, 1, a.monto_dispersar) = 0
             -- and NVL(a.monto_dispersar, 0) = v_monto_capita_fonamat -- 6 pesos
             and a.periodo_factura >= v_periodo_inicio_fonamat
/*                 to_number(to_char(ADD_MONTHS(to_date(v_periodo_inicio_fonamat,
                                                      'yyyymm'),
                                              1),
                                   'yyyymm')) --Inicio FONAMAT + 1
*/
          MINUS

          --Menos los registros '4444444444444444' que existan para los meses Enero-Febrero-Marzo
          --y el monto a dispersar sea igual a la suma de los valores de los parametros 349 y 350.
          select a.codigo_ars,
                 a.periodo_factura,
                 a.nss_titular,
                 a.nss_afiliado_pagado,
                 a.nss_dispara_pago,
                 a.id_referencia,
                 a.monto_dispersar,
                 a.fecha_consolidado,
                 m_validacion,
                 m_hoy,
                 m_carga_seq
            from suirplus.ars_dispersion_fonamat a
            join suirplus.ars_cartera_t c
              on c.periodo_factura_ars = NVL(a.periodo_factura, 0)
             and c.nss_titular = NVL(a.nss_titular, 0)
             and c.nss_dependiente = NVL(a.nss_afiliado_pagado, 0)
             and c.tipo_afiliado = 'A' --Dependientes Adicionales
             and c.id_ars = NVL(a.codigo_ars, 0)
            join suirplus.SRE_ADICIONALES_RES_265_01_T r
              on r.id_nss_afiliado = a.nss_afiliado_pagado
           where NVL(a.id_referencia, '1') = '4444444444444444'
             and monto_valido(a.nss_afiliado_pagado, a.periodo_factura, 2, a.monto_dispersar) = 0
             -- and NVL(a.monto_dispersar, 0) = v_monto_dep_adicional -- 8 pesos
             and a.periodo_factura >= v_periodo_inicio_fonamat
/*                 to_number(to_char(ADD_MONTHS(to_date(v_periodo_inicio_fonamat,
                                                      'yyyymm'),
                                              1),
                                   'yyyymm')) --Inicio FONAMAT + 1
*/
          MINUS

          -- Menos las referencias de factura validas, sin recargo en SFS, el titular o dependiente directo NO debe
          -- existir para los meses Enero-Febrero, y que el monto reportado sea igual
          -- al valor del parametro 349.
          select a.codigo_ars,
                 a.periodo_factura,
                 a.nss_titular,
                 a.nss_afiliado_pagado,
                 a.nss_dispara_pago,
                 a.id_referencia,
                 a.monto_dispersar,
                 a.fecha_consolidado,
                 m_validacion,
                 m_hoy,
                 m_carga_seq
            from suirplus.ars_dispersion_fonamat a
            join suirplus.ars_cartera_t c
              on c.periodo_factura_ars = NVL(a.periodo_factura, 0)
             and c.nss_titular = NVL(a.nss_titular, 0)
             and c.nss_dependiente = NVL(a.nss_afiliado_pagado, 0)
             and c.id_ars = NVL(a.codigo_ars, 0)
             and c.tipo_afiliado in ('T', 'D') --Titulares o Dependientes Directos
            join suirplus.sfc_facturas_v f
              on f.ID_REFERENCIA = NVL(a.id_referencia, '1')
             and f.status = 'PA'
             and NVL(f.total_recargo_sfs, 0) = 0
           where NVL(a.id_referencia, '1') != '4444444444444444'
             and Not Exists
           (Select 1
              From suirplus.SRE_ADICIONALES_RES_265_02_T r
             Where r.id_nss_afiliado = NVL(a.nss_afiliado_pagado, 0))
             and monto_valido(a.nss_afiliado_pagado, a.periodo_factura, 4, a.monto_dispersar) = 0
             -- and NVL(a.monto_dispersar, 0) = v_monto_capita_fonamat -- 6 pesos
             and a.periodo_factura >= v_periodo_inicio_fonamat --Inicio FONAMAT

          MINUS

          --Menos los registros '4444444444444444' que no existan para los meses Enero-Febrero
          --y el monto a dispersar sea igual al per capita de fonomat
          select a.codigo_ars,
                 a.periodo_factura,
                 a.nss_titular,
                 a.nss_afiliado_pagado,
                 a.nss_dispara_pago,
                 a.id_referencia,
                 a.monto_dispersar,
                 a.fecha_consolidado,
                 m_validacion,
                 m_hoy,
                 m_carga_seq
            from suirplus.ars_dispersion_fonamat a
            join suirplus.ars_cartera_t c
              on c.periodo_factura_ars = NVL(a.periodo_factura, 0)
             and c.nss_titular = NVL(a.nss_titular, 0)
             and c.nss_dependiente = NVL(a.nss_afiliado_pagado, 0)
             and c.id_ars = NVL(a.codigo_ars, 0)
             and c.tipo_afiliado in ('T', 'D') --Titulares o Dependientes Directos
           where NVL(a.id_referencia, '1') = '4444444444444444'
             and Not Exists
           (Select 1
              From suirplus.SRE_ADICIONALES_RES_265_02_T r
             Where r.id_nss_afiliado = NVL(a.nss_afiliado_pagado, 0))
             and monto_valido(a.nss_afiliado_pagado, a.periodo_factura, 4, a.monto_dispersar) = 0
             --and NVL(a.monto_dispersar, 0) = v_monto_capita_fonamat -- 6 pesos
             and a.periodo_factura >= v_periodo_inicio_fonamat --Inicio FONAMAT

          MINUS

          -- Menos las referencias de factura validas, sin recargo en SFS, el titular o dependiente directo debe
          -- existir para los meses Enero-Febrero, y que el monto reportado sea igual
          -- a la suma de los valores de los parametros 349 y 351.
          select a.codigo_ars,
                 a.periodo_factura,
                 a.nss_titular,
                 a.nss_afiliado_pagado,
                 a.nss_dispara_pago,
                 a.id_referencia,
                 a.monto_dispersar,
                 a.fecha_consolidado,
                 m_validacion,
                 m_hoy,
                 m_carga_seq
            from suirplus.ars_dispersion_fonamat a
            join suirplus.ars_cartera_t c
              on c.periodo_factura_ars = NVL(a.periodo_factura, 0)
             and c.nss_titular = NVL(a.nss_titular, 0)
             and c.nss_dependiente = NVL(a.nss_afiliado_pagado, 0)
             and c.id_ars = NVL(a.codigo_ars, 0)
             and c.tipo_afiliado in ('T', 'D') --Titulares o Dependientes Directos
            join suirplus.sfc_facturas_v f
              on f.ID_REFERENCIA = NVL(a.id_referencia, '1')
             and f.status = 'PA'
             and NVL(f.total_recargo_sfs, 0) = 0
            join suirplus.SRE_ADICIONALES_RES_265_02_T r
              on r.id_nss_afiliado = a.nss_afiliado_pagado
           where NVL(a.id_referencia, '1') != '4444444444444444'
             --and NVL(a.monto_dispersar, 0) = v_monto_titular_directo -- 7.20 pesos
             and monto_valido(a.nss_afiliado_pagado, a.periodo_factura, 3, a.monto_dispersar) = 0
             and a.periodo_factura >= v_periodo_inicio_fonamat --Inicio FONAMAT

          MINUS

          --Menos los registros '4444444444444444' que existan para los meses Enero-Febrero
          --y el monto a dispersar sea igual a la suma de los valores de los parametros 349 y 351.
          select a.codigo_ars,
                 a.periodo_factura,
                 a.nss_titular,
                 a.nss_afiliado_pagado,
                 a.nss_dispara_pago,
                 a.id_referencia,
                 a.monto_dispersar,
                 a.fecha_consolidado,
                 m_validacion,
                 m_hoy,
                 m_carga_seq
            from suirplus.ars_dispersion_fonamat a
            join suirplus.ars_cartera_t c
              on c.periodo_factura_ars = NVL(a.periodo_factura, 0)
             and c.nss_titular = NVL(a.nss_titular, 0)
             and c.nss_dependiente = NVL(a.nss_afiliado_pagado, 0)
             and c.id_ars = NVL(a.codigo_ars, 0)
             and c.tipo_afiliado in ('T', 'D') --Titulares o Dependientes Directos
            join suirplus.SRE_ADICIONALES_RES_265_02_T r
              on r.id_nss_afiliado = a.nss_afiliado_pagado
           where NVL(a.id_referencia, '1') = '4444444444444444'
             --and NVL(a.monto_dispersar, 0) = v_monto_titular_directo -- 7.20 pesos
             and monto_valido(a.nss_afiliado_pagado, a.periodo_factura, 3, a.monto_dispersar) = 0
             and a.periodo_factura >= v_periodo_inicio_fonamat; --Inicio de FONAMAT

        m_hora_termina := sysdate;
        debug('Dispersion: ciclo '||p_ciclo||' validacion #'||m_validacion||' - terminada a las '||to_char(m_hora_termina,'dd/mm/yyyy hh:mi:ss')||
              ' - Tiempo total: ('||
              TRIM(TO_CHAR(EXTRACT(HOUR FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
              TRIM(TO_CHAR(EXTRACT(MINUTE FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
              TRIM(TO_CHAR(EXTRACT(SECOND FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||
              ') - total registros: '|| sql%rowcount);

--        debug('validacion_dispersion: ' || m_validacion||', total registros: '||sql%rowcount);
        commit;

        -- registros duplicados
        m_validacion := 10;

        m_hora_inicio := sysdate;
        debug('Dispersion: ciclo '||p_ciclo||' validacion #'||m_validacion||' - iniciada a las '||to_char(m_hora_inicio,'dd/mm/yyyy hh:mi:ss'));

        insert into suirplus.ars_dispersion_con_errores_t
          select a.*, m_validacion, m_hoy, m_carga_seq
            from suirplus.ars_dispersion_fonamat a
           where (a.codigo_ars, a.periodo_factura, a.nss_titular,
                  a.nss_afiliado_pagado) in
                 (select a.codigo_ars,
                         a.periodo_factura,
                         a.nss_titular,
                         a.nss_afiliado_pagado
                    from suirplus.ars_dispersion_fonamat a
                   group by a.codigo_ars,
                            a.periodo_factura,
                            a.nss_titular,
                            a.nss_afiliado_pagado
                  having count(*) > 1);

        m_hora_termina := sysdate;
        debug('Dispersion: ciclo '||p_ciclo||' validacion #'||m_validacion||' - terminada a las '||to_char(m_hora_termina,'dd/mm/yyyy hh:mi:ss')||
              ' - Tiempo total: ('||
              TRIM(TO_CHAR(EXTRACT(HOUR FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
              TRIM(TO_CHAR(EXTRACT(MINUTE FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
              TRIM(TO_CHAR(EXTRACT(SECOND FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||
              ') - total registros: '|| sql%rowcount);

--        debug('validacion_dispersion: ' || m_validacion||', total registros: '||sql%rowcount);
        commit;

        -- nss_afiliado_pagado debe ser un ciudadano
        m_validacion := 14;

        m_hora_inicio := sysdate;
        debug('Dispersion: ciclo '||p_ciclo||' validacion #'||m_validacion||' - iniciada a las '||to_char(m_hora_inicio,'dd/mm/yyyy hh:mi:ss'));

        insert into suirplus.ars_dispersion_con_errores_t
          (codigo_ars,
           periodo_factura,
           nss_titular,
           nss_afiliado_pagado,
           nss_dispara_pago,
           id_referencia,
           nombre_nacha,
           fecha_envio_nacha,
           id_error,
           fecha_registro,
           id_carga)
          select a.codigo_ars,
                 a.periodo_factura,
                 a.nss_titular,
                 a.nss_afiliado_pagado,
                 a.nss_dispara_pago,
                 a.id_referencia,
                 a.monto_dispersar,
                 a.fecha_consolidado,
                 m_validacion,
                 m_hoy,
                 m_carga_seq
            from suirplus.ars_dispersion_fonamat a
          MINUS
          select a.codigo_ars,
                 a.periodo_factura,
                 a.nss_titular,
                 a.nss_afiliado_pagado,
                 a.nss_dispara_pago,
                 a.id_referencia,
                 a.monto_dispersar,
                 a.fecha_consolidado,
                 m_validacion,
                 m_hoy,
                 m_carga_seq
            from suirplus.ars_dispersion_fonamat a
            join suirplus.sre_ciudadanos_t c
              on c.id_nss = a.nss_afiliado_pagado;

        m_hora_termina := sysdate;
        debug('Dispersion: ciclo '||p_ciclo||' validacion #'||m_validacion||' - terminada a las '||to_char(m_hora_termina,'dd/mm/yyyy hh:mi:ss')||
              ' - Tiempo total: ('||
              TRIM(TO_CHAR(EXTRACT(HOUR FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
              TRIM(TO_CHAR(EXTRACT(MINUTE FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
              TRIM(TO_CHAR(EXTRACT(SECOND FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||
              ') - total registros: '|| sql%rowcount);

--        debug('validacion_dispersion: ' || m_validacion||', total registros: '||sql%rowcount);
        commit;

        -- nss_dispara_pago debe ser un ciudadano.
        -- No validar los registros con referencia = '4444444444444444' (Persona sin trabajo);
        -- pues, para este caso el campo nss_dispara_pago viene nulo.
        m_validacion := 15;

        m_hora_inicio := sysdate;
        debug('Dispersion: ciclo '||p_ciclo||' validacion #'||m_validacion||' - iniciada a las '||to_char(m_hora_inicio,'dd/mm/yyyy hh:mi:ss'));

        insert into suirplus.ars_dispersion_con_errores_t
          (codigo_ars,
           periodo_factura,
           nss_titular,
           nss_afiliado_pagado,
           nss_dispara_pago,
           id_referencia,
           nombre_nacha,
           fecha_envio_nacha,
           id_error,
           fecha_registro,
           id_carga)
          select a.codigo_ars,
                 a.periodo_factura,
                 a.nss_titular,
                 a.nss_afiliado_pagado,
                 a.nss_dispara_pago,
                 a.id_referencia,
                 a.monto_dispersar,
                 a.fecha_consolidado,
                 m_validacion,
                 m_hoy,
                 m_carga_seq
            from suirplus.ars_dispersion_fonamat a
           where NVL(a.id_referencia, '1') != '4444444444444444'
          MINUS
          select a.codigo_ars,
                 a.periodo_factura,
                 a.nss_titular,
                 a.nss_afiliado_pagado,
                 a.nss_dispara_pago,
                 a.id_referencia,
                 a.monto_dispersar,
                 a.fecha_consolidado,
                 m_validacion,
                 m_hoy,
                 m_carga_seq
            from suirplus.ars_dispersion_fonamat a
            join suirplus.sre_ciudadanos_t c
              on c.id_nss = NVL(a.nss_dispara_pago, 0)
             and c.tipo_documento = 'C'
           where NVL(a.id_referencia, '1') != '4444444444444444'; -- No sean personas sin trabajo.

        m_hora_termina := sysdate;
        debug('Dispersion: ciclo '||p_ciclo||' validacion #'||m_validacion||' - terminada a las '||to_char(m_hora_termina,'dd/mm/yyyy hh:mi:ss')||
              ' - Tiempo total: ('||
              TRIM(TO_CHAR(EXTRACT(HOUR FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
              TRIM(TO_CHAR(EXTRACT(MINUTE FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
              TRIM(TO_CHAR(EXTRACT(SECOND FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||
              ') - total registros: '|| sql%rowcount);

--        debug('validacion_dispersion: ' || m_validacion||', total registros: '||sql%rowcount);
        commit;

        -- la referencia debe estar pagada y sin recargo
        m_validacion := 16;

        m_hora_inicio := sysdate;
        debug('Dispersion: ciclo '||p_ciclo||' validacion #'||m_validacion||' - iniciada a las '||to_char(m_hora_inicio,'dd/mm/yyyy hh:mi:ss'));

        insert into suirplus.ars_dispersion_con_errores_t
          (codigo_ars,
           periodo_factura,
           nss_titular,
           nss_afiliado_pagado,
           nss_dispara_pago,
           id_referencia,
           nombre_nacha,
           fecha_envio_nacha,
           id_error,
           fecha_registro,
           id_carga)
          select a.codigo_ars,
                 a.periodo_factura,
                 a.nss_titular,
                 a.nss_afiliado_pagado,
                 a.nss_dispara_pago,
                 a.id_referencia,
                 a.monto_dispersar,
                 a.fecha_consolidado,
                 m_validacion,
                 m_hoy,
                 m_carga_seq
            from suirplus.ars_dispersion_fonamat a
          MINUS
          -- Menos las referencias de factura validas.
          select a.codigo_ars,
                 a.periodo_factura,
                 a.nss_titular,
                 a.nss_afiliado_pagado,
                 a.nss_dispara_pago,
                 a.id_referencia,
                 a.monto_dispersar,
                 a.fecha_consolidado,
                 m_validacion,
                 m_hoy,
                 m_carga_seq
            from suirplus.ars_dispersion_fonamat a
            join suirplus.sfc_facturas_v f
              on f.ID_REFERENCIA = NVL(a.id_referencia, '1')
             and f.status = 'PA'
             and NVL(f.total_recargo_sfs, 0) = 0
           where NVL(a.id_referencia, '1') != '4444444444444444';

        m_hora_termina := sysdate;
        debug('Dispersion: ciclo '||p_ciclo||' validacion #'||m_validacion||' - terminada a las '||to_char(m_hora_termina,'dd/mm/yyyy hh:mi:ss')||
              ' - Tiempo total: ('||
              TRIM(TO_CHAR(EXTRACT(HOUR FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
              TRIM(TO_CHAR(EXTRACT(MINUTE FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
              TRIM(TO_CHAR(EXTRACT(SECOND FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||
              ') - total registros: '|| sql%rowcount);

--        debug('validacion_dispersion: ' || m_validacion||', total registros: '||sql%rowcount);
        commit;

        -- NSS afiliado pagado debe de existir en la tabla cartera
        m_validacion := 18;

        m_hora_inicio := sysdate;
        debug('Dispersion: ciclo '||p_ciclo||' validacion #'||m_validacion||' - iniciada a las '||to_char(m_hora_inicio,'dd/mm/yyyy hh:mi:ss'));

        insert into suirplus.ars_dispersion_con_errores_t
          (codigo_ars,
           periodo_factura,
           nss_titular,
           nss_afiliado_pagado,
           nss_dispara_pago,
           id_referencia,
           nombre_nacha,
           fecha_envio_nacha,
           id_error,
           fecha_registro,
           id_carga)
        -- Traer todos los registros de Dispersion
          select a.codigo_ars,
                 a.periodo_factura,
                 a.nss_titular,
                 a.nss_afiliado_pagado,
                 a.nss_dispara_pago,
                 a.id_referencia,
                 a.monto_dispersar,
                 a.fecha_consolidado,
                 m_validacion,
                 m_hoy,
                 m_carga_seq
            from suirplus.ars_dispersion_fonamat a
          MINUS
          -- Restarle los que estan en cartera
          Select a.codigo_ars,
                 a.periodo_factura,
                 a.nss_titular,
                 a.nss_afiliado_pagado,
                 a.nss_dispara_pago,
                 a.id_referencia,
                 a.monto_dispersar,
                 a.fecha_consolidado,
                 m_validacion,
                 m_hoy,
                 m_carga_seq
            from suirplus.ars_dispersion_fonamat a
            join suirplus.ars_cartera_t c
              on c.periodo_factura_ars = NVL(a.periodo_factura, '0')
             and c.nss_titular = NVL(a.nss_titular, 0)
             and c.nss_dependiente = NVL(a.nss_afiliado_pagado, 0)
             and c.id_ars = NVL(a.codigo_ars, 0);

        m_hora_termina := sysdate;
        debug('Dispersion: ciclo '||p_ciclo||' validacion #'||m_validacion||' - terminada a las '||to_char(m_hora_termina,'dd/mm/yyyy hh:mi:ss')||
              ' - Tiempo total: ('||
              TRIM(TO_CHAR(EXTRACT(HOUR FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
              TRIM(TO_CHAR(EXTRACT(MINUTE FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
              TRIM(TO_CHAR(EXTRACT(SECOND FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||
              ') - total registros: '|| sql%rowcount);

--        debug('validacion_dispersion: ' || m_validacion||', total registros: '||sql%rowcount);
        commit;

        -- Registros previamente dispersados en FONAMAT
        m_validacion := 22;

        m_hora_inicio := sysdate;
        debug('Dispersion: ciclo '||p_ciclo||' validacion #'||m_validacion||' - iniciada a las '||to_char(m_hora_inicio,'dd/mm/yyyy hh:mi:ss'));

        insert into suirplus.ars_dispersion_con_errores_t
          (codigo_ars,
           periodo_factura,
           nss_titular,
           nss_afiliado_pagado,
           nss_dispara_pago,
           id_referencia,
           nombre_nacha,
           fecha_envio_nacha,
           id_error,
           fecha_registro,
           id_carga)
          select a.codigo_ars,
                 a.periodo_factura,
                 a.nss_titular,
                 a.nss_afiliado_pagado,
                 a.nss_dispara_pago,
                 a.id_referencia,
                 a.monto_dispersar,
                 a.fecha_consolidado,
                 m_validacion,
                 m_hoy,
                 m_carga_seq
            from suirplus.ars_dispersion_fonamat a
          MINUS
          --Restarle todos los que no esten dispersados en FONAMAT
          select a.codigo_ars,
                 a.periodo_factura,
                 a.nss_titular,
                 a.nss_afiliado_pagado,
                 a.nss_dispara_pago,
                 a.id_referencia,
                 a.monto_dispersar,
                 a.fecha_consolidado,
                 m_validacion,
                 m_hoy,
                 m_carga_seq
            from suirplus.ars_dispersion_fonamat a
            join suirplus.ars_cartera_t c
              on c.periodo_factura_ars = NVL(a.periodo_factura, 0)
             and c.nss_titular = a.nss_titular
             and c.nss_dependiente = a.nss_afiliado_pagado
             and c.id_carga_fonamat is null;

        m_hora_termina := sysdate;
        debug('Dispersion: ciclo '||p_ciclo||' validacion #'||m_validacion||' - terminada a las '||to_char(m_hora_termina,'dd/mm/yyyy hh:mi:ss')||
              ' - Tiempo total: ('||
              TRIM(TO_CHAR(EXTRACT(HOUR FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
              TRIM(TO_CHAR(EXTRACT(MINUTE FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
              TRIM(TO_CHAR(EXTRACT(SECOND FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||
              ') - total registros: '|| sql%rowcount);

--        debug('validacion_dispersion: ' || m_validacion||', total registros: '||sql%rowcount);
        commit;

        -- Registros no previamente dispersados en ARS
        m_validacion := 36;

        m_hora_inicio := sysdate;
        debug('Dispersion: ciclo '||p_ciclo||' validacion #'||m_validacion||' - iniciada a las '||to_char(m_hora_inicio,'dd/mm/yyyy hh:mi:ss'));

        insert into suirplus.ars_dispersion_con_errores_t
          (codigo_ars,
           periodo_factura,
           nss_titular,
           nss_afiliado_pagado,
           nss_dispara_pago,
           id_referencia,
           nombre_nacha,
           fecha_envio_nacha,
           id_error,
           fecha_registro,
           id_carga)
          select a.codigo_ars,
                 a.periodo_factura,
                 a.nss_titular,
                 a.nss_afiliado_pagado,
                 a.nss_dispara_pago,
                 a.id_referencia,
                 a.monto_dispersar,
                 a.fecha_consolidado,
                 m_validacion,
                 m_hoy,
                 m_carga_seq
            from suirplus.ars_dispersion_fonamat a
          MINUS
          --Restarles todos los que no esten dispersados en ARS
          select a.codigo_ars,
                 a.periodo_factura,
                 a.nss_titular,
                 a.nss_afiliado_pagado,
                 a.nss_dispara_pago,
                 a.id_referencia,
                 a.monto_dispersar,
                 a.fecha_consolidado,
                 m_validacion,
                 m_hoy,
                 m_carga_seq
            from suirplus.ars_dispersion_fonamat a
            join suirplus.ars_cartera_t c
              on c.periodo_factura_ars = NVL(a.periodo_factura, '0')
             and c.nss_titular = NVL(a.nss_titular, 0)
             and c.nss_dependiente = NVL(a.nss_afiliado_pagado, 0)
             and c.id_carga_dispersion is not null;

        m_hora_termina := sysdate;
        debug('Dispersion: ciclo '||p_ciclo||' validacion #'||m_validacion||' - terminada a las '||to_char(m_hora_termina,'dd/mm/yyyy hh:mi:ss')||
              ' - Tiempo total: ('||
              TRIM(TO_CHAR(EXTRACT(HOUR FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
              TRIM(TO_CHAR(EXTRACT(MINUTE FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
              TRIM(TO_CHAR(EXTRACT(SECOND FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||
              ') - total registros: '|| sql%rowcount);

--        debug('validacion_dispersion: ' || m_validacion||', total registros: '||sql%rowcount);
        commit;
      END;
    End if;

    -- Buscar los registros con errores y los ok.

    m_hora_inicio := sysdate;
    debug('Dispersion: ciclo '||p_ciclo||' conteo registros rechazados - iniciado a las '||to_char(m_hora_inicio,'dd/mm/yyyy hh:mi:ss'));
    
    with registros as
     (select distinct codigo_ars,
                      periodo_factura,
                      nss_titular,
                      nss_afiliado_pagado
        from suirplus.ars_dispersion_con_errores_t a
       where a.id_carga = m_carga_seq)
    select count(*) into m_registros_procesados_error from registros a;

    m_hora_termina := sysdate;
    debug('Dispersion: ciclo '||p_ciclo||' conteo registros rechazados - terminado a las '||to_char(m_hora_termina,'dd/mm/yyyy hh:mi:ss')||
          ' - Tiempo total: ('||
          TRIM(TO_CHAR(EXTRACT(HOUR FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
          TRIM(TO_CHAR(EXTRACT(MINUTE FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
          TRIM(TO_CHAR(EXTRACT(SECOND FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||
          ') - total registros: '|| sql%rowcount);

    m_registros_procesados_ok := m_registros - m_registros_procesados_error;

    p_result := 'OK'; -- Paso todas las validaciones

  exception
    when others then
      rollback;
      p_result := 'ERROR. periodo=' ||
                  nvl(m_mayor_periodo_factura, m_per_hasta) || '. ' ||
                  m_proceso || ' validacion=' || m_validacion || '.' ||
                  sqlerrm;
      system.html_mail(c_mail_from,
                       c_mail_error,
                       'Error en ' || c_mail_subject,
                       '<br>Error=' || sqlerrm || '<br>Carga=' ||
                       m_carga_seq);
  end;

  -- ------------------------------------------------------------------------------------------------------------------------------------
  procedure validar_dispersion_comp(p_result out varchar2) is
    m_mayor_periodo_factura varchar2(6);
    m_parm                  Parm;
  begin
    p_result     := 'ERROR'; -- Se asume error hasta tanto no halla pasado TODAS las validaciones.
    m_validacion := 0;

    -- El periodo inicial es "6 meses antes de la fecha de vigencia".
    m_per_desde := To_char(add_months(to_date(m_per_hasta || '01',
                                              'yyyymmdd'),
                                      -6),
                           'yyyymm');

    -- obtener el total de registros a procesar y el mayor periodo enviado
    select count(*), max(a.periodo_factura)
      into m_registros, m_mayor_periodo_factura
      from suirplus.ars_dispersion a;

    -- validar registro en la dispersion
    m_validacion := 29;
    insert into suirplus.ars_dispersion_con_errores_t
      (codigo_ars,
       periodo_factura,
       nss_titular,
       nss_afiliado_pagado,
       nss_dispara_pago,
       id_referencia,
       nombre_nacha,
       fecha_envio_nacha,
       id_error,
       fecha_registro,
       id_carga)
      select a.codigo_ars,
             a.periodo_factura,
             a.nss_titular,
             a.nss_afiliado_pagado,
             a.nss_dispara_pago,
             a.id_referencia,
             a.monto_dispersar,
             a.fecha_consolidado,
             m_validacion,
             m_hoy,
             m_carga_seq
        from suirplus.ars_dispersion a
       where not exists (select 1
                from ars_cartera_t c
               where c.periodo_factura_ars = a.periodo_factura
                 and c.nss_titular = a.nss_titular
                 and c.nss_dependiente = a.nss_afiliado_pagado
                 and c.id_ars = a.codigo_ars);
    commit;

    -- validar que el registro este dispersado en la cartera
    m_validacion := 30;
    insert into suirplus.ars_dispersion_con_errores_t
      (codigo_ars,
       periodo_factura,
       nss_titular,
       nss_afiliado_pagado,
       nss_dispara_pago,
       id_referencia,
       nombre_nacha,
       fecha_envio_nacha,
       id_error,
       fecha_registro,
       id_carga)
      select a.codigo_ars,
             a.periodo_factura,
             a.nss_titular,
             a.nss_afiliado_pagado,
             a.nss_dispara_pago,
             a.id_referencia,
             a.monto_dispersar,
             a.fecha_consolidado,
             m_validacion,
             m_hoy,
             m_carga_seq
        from suirplus.ars_dispersion a
       where not exists
       (select 1
                from ars_cartera_t c
               where c.periodo_factura_ars = a.periodo_factura
                 and c.nss_titular = a.nss_titular
                 and c.nss_dependiente = a.nss_afiliado_pagado
                 and c.id_ars = a.codigo_ars
                 and NVL(c.registro_dispersado, 'N') = 'S');
    commit;

    -- validar que el registro no tenga un completivo previo
    m_validacion := 31;
    insert into suirplus.ars_dispersion_con_errores_t
      (codigo_ars,
       periodo_factura,
       nss_titular,
       nss_afiliado_pagado,
       nss_dispara_pago,
       id_referencia,
       nombre_nacha,
       fecha_envio_nacha,
       id_error,
       fecha_registro,
       id_carga)
      select a.codigo_ars,
             a.periodo_factura,
             a.nss_titular,
             a.nss_afiliado_pagado,
             a.nss_dispara_pago,
             a.id_referencia,
             a.monto_dispersar,
             a.fecha_consolidado,
             m_validacion,
             m_hoy,
             m_carga_seq
        from suirplus.ars_dispersion a
       where exists (select 1
                from ars_cartera_t c
               where c.periodo_factura_ars = a.periodo_factura
                 and c.nss_titular = a.nss_titular
                 and c.nss_dependiente = a.nss_afiliado_pagado
                 and c.id_ars = a.codigo_ars
                 and NVL(c.registro_dispersado, 'N') = 'S'
                 and NVL(c.monto_completivo, 0) > 0);
    commit;

    -- Per Capita y completivos SFS Regimen Contributivo para titulares y dependientes directos
    -- no deden exceder el per capita del periodo
    For c_periodo in (select distinct periodo_factura from ars_dispersion) Loop
      m_parm := Parm(to_number(c_periodo.periodo_factura));

      m_validacion := 32;
      insert into suirplus.ars_dispersion_con_errores_t
        (codigo_ars,
         periodo_factura,
         nss_titular,
         nss_afiliado_pagado,
         nss_dispara_pago,
         id_referencia,
         nombre_nacha,
         fecha_envio_nacha,
         id_error,
         fecha_registro,
         id_carga)
        select a.codigo_ars,
               a.periodo_factura,
               a.nss_titular,
               a.nss_afiliado_pagado,
               a.nss_dispara_pago,
               a.id_referencia,
               a.monto_dispersar,
               a.fecha_consolidado,
               m_validacion,
               m_hoy,
               m_carga_seq
          from suirplus.ars_dispersion a
          join suirplus.ars_cartera_t c
            on c.periodo_factura_ars = a.periodo_factura
           and c.nss_titular = a.nss_titular
           and c.nss_dependiente = a.nss_afiliado_pagado
           and c.tipo_afiliado in ('T', 'D')
           and NVL(c.registro_dispersado, 'N') = 'S'
           and NVL(c.monto_dispersar, 0) + NVL(a.monto_dispersar, 0) !=
               m_parm.sfs_per_capita_contributivo
         Where a.periodo_factura = c_periodo.periodo_factura;
      commit;
    End Loop;

    -- Buscar los registros con errores y los ok.
    with registros as
     (select distinct codigo_ars,
                      periodo_factura,
                      nss_titular,
                      nss_afiliado_pagado
        from suirplus.ars_dispersion_con_errores_t a
       where a.id_carga = m_carga_seq)
    select count(*) into m_registros_procesados_error from registros a;

    m_registros_procesados_ok := m_registros - m_registros_procesados_error;

    p_result := 'OK'; -- Paso todas las validaciones

    -- Enviar email indicando corrida satisfactoria
    -- enviar_email('D',m_carga_seq);

  exception
    when others then
      rollback;
      p_result := 'ERROR. periodo=' ||
                  nvl(m_mayor_periodo_factura, m_per_hasta) || '. ' ||
                  m_proceso || ' validacion=' || m_validacion || '.' ||
                  sqlerrm;
      system.html_mail(c_mail_from,
                       c_mail_error,
                       'Error en ' || c_mail_subject,
                       '<br>Error=' || sqlerrm || '<br>Carga=' ||
                       m_carga_seq);
  end;

  -- -----------------------------------------------------------------------------------------------
  procedure enviar_email(p_proceso in varchar2, p_id_carga in number) is
    v_registros_ok    integer := 0;
    v_registros_error integer := 0;

    procedure add(id_error   in number,
                  validacion in varchar,
                  resultado  in integer) is
    begin
      -- Task 1119 - inicio
      -- v_html := v_html || '<tr><td>'||validacion||'</td><td align="center">';
      v_html := v_html || '<tr><td align="center">' || id_error ||
                '</td><td>' || validacion || '</td><td align="right">';
      -- Task 1119 - fin
      if (resultado = 0) then
        v_html := v_html || '<font color="green">0</font>';
      else
        v_html := v_html || '<font color="red">' ||
                  trim(to_char(resultado, '999,999,999')) || '</font>';
      end if;
      v_html := v_html || '</td></tr>';
    end;
  begin
    --encabezado
    v_html := '<html>
               <head>
                <STYLE TYPE="text/css"><!--
                body
                {
                  font-family:Tahoma, Verdana,Arial;
                  font-size:9px;
                }
                .smallfont
                {
                  font-size:9pt;
                }
                .subHeader
                {
                  font-family:Tahoma, Verdana,Arial;
                  font-size:12px;
                  font-weight:bold;
                  color: #FFFFFF;
                }--></STYLE>
               </head>
               <body>
                <table border="1" cellpadding=3 cellspacing=0 CLASS="smallfont" style="border-collapse: collapse">'

             -- Task 1119 - inicio
             --      || '<tr><td colspan="2" bgcolor="silver" align="center"><b>Resultado de las validaciones</b></td></tr>'
              || '<tr><td colspan="3" bgcolor=#60A322" class="subHeader" align="center"><b>Registros con Error</b></td></tr>
                     <tr><td><b>Codigo</b></td>
                         <td><b>Descripcion</b></td>
                         <td><b>Cantidad de Registro</b></td>
                     </tr>';
    -- Task 1119 - fin

    --codigos de error
    for errores in (
                    -- Dispersion
                    select a.id_error,
                            a.error_des,
                            Nvl(count(b.id_error), 0) total
                      from suirplus.ars_dispersion_con_errores_t b
                      join ars_cartera_errores_t a
                        on b.id_error = a.id_error
                     where b.id_carga = p_id_carga
                       and p_proceso = 'D'
                     group by a.id_error, a.error_des

                    union all

                    -- Cartera
                    select a.id_error,
                           a.error_des,
                           Nvl(count(b.id_error), 0) total
                      from suirplus.ars_cartera_con_errores_t b
                      join ars_cartera_errores_t a
                        on b.id_error = a.id_error
                     where b.id_carga = p_id_carga
                       and p_proceso = 'C'
                     group by a.id_error, a.error_des) loop
      add(errores.id_error, errores.error_des, errores.total);
    end loop;

    -- Task 1119 - inicio
    -- Verificar la cantida de registros procesados
    v_registros_ok    := m_registros_procesados_ok;
    v_registros_error := m_registros_procesados_error;

    -- Si estan en Cero (0), buscar en la tabla de control de carga.
    if (v_registros_ok = 0) and (v_registros_error = 0) then
      select t.registros_ok, t.registros_error
        into v_registros_ok, v_registros_error
        from ars_carga_t t
       where t.id_carga = p_id_carga;

      m_registros := nvl(v_registros_ok, 0) + NVL(v_registros_error, 0);
    end if;

    --Si no hay error imprimos que no hay registros con errores
    if (v_registros_error = 0) then
      add(0, 'No hay registros con errores', 0);
    end if;
    -- Task 1119 - fin

    -- fin

    -- Task 1119 - inicio
    --    v_html := v_html||'<tr><td colspan="2" bgcolor="silver"><b>Registros procesados: '||trim(to_char(m_registros,'999,999,990'))
    --              ||' en '|| trim(to_char((sysdate-m_hoy)*24*60,'999,999,990')) ||' mins. </b></td></tr>';
    v_html := v_html ||
              '<tr><td colspan="2" bgcolor="silver"><b>Registros OK</b></td>' ||
              '<td align="right" bgcolor="silver"><font color="green">' ||
              trim(to_char(v_registros_ok, '999,999,990')) || '</td></tr>';

    v_html := v_html ||
              '<tr><td colspan="2" bgcolor="silver"><b>Registros con Errores</b></td>' ||
              '<td align="right" bgcolor="silver"><font color="red">' ||
              trim(to_char(v_registros_error, '999,999,990')) ||
              '</td></tr>';

    v_html := v_html ||
              '<tr><td colspan="2" bgcolor="silver"><b>Total Registros procesados</b></td>' ||
              '<td align="right" bgcolor="silver">' ||
              trim(to_char(m_registros, '999,999,990')) || '</td></tr>';

    --    v_html := v_html||'<tr><td colspan="2" bgcolor="silver"><b>Registros procesados: '||trim(to_char(m_registros,'999,999,990'))
    --              ||' en '|| trim(to_char((sysdate-m_hoy)*24*60,'999,999,990')) ||' mins. </b></td></tr>';
    -- Task 1119 - fin

    v_html := v_html || '</table></body></html>';

    --Subject del mensaje
    select c_mail_subject || ' de ' ||
           decode(p_proceso, 'C', 'Cartera', 'Dispersion') || '. Vista=' ||
           m_vista || ' de ARS - de fecha ' || to_char(sysdate, 'YYYYMM') ||
           ' - Carga #' || p_id_carga -- to_char(p_id_carga,'999,999')
      into c_mail_subject
      from dual;

    -- enviar email
    system.html_mail(c_mail_from, c_mail_to, c_mail_subject, v_html);
    -- html_mail(c_mail_from, c_mail_to,c_mail_subject, v_html);
  end;

  -- ------------------------------------------------------------------------------------------------------------------------------------
  procedure Actualizar_cartera(p_carga in ars_carga_t.id_carga%type, p_terminal in number, p_job in suirplus.seg_job_t.id_job%type, p_result out varchar2) is
    m_sqlerrm varchar2(32000) := 'X';
  begin
    p_result := 'OK';
    m_hora_inicio := sysdate;
    debug('actualizar cartera: TERMINAL NSS='|| p_terminal ||' iniciada a las '||to_char(m_hora_inicio,'dd/mm/yyyy hh:mi:ss am'));
    
    --Esto es para llenar la variable cuando este método es llamado desde la SERIALIZACION. Ticket 6479
    if m_carga_seq is null then
      m_carga_seq := p_carga;
    end if;

    -- insertar en cartera los registros que estan ok para esta carga
    insert into ars_cartera_t
      (id_ars,
       periodo_factura_ars,
       tipo_afiliado,
       nss_titular,
       nss_dependiente,
       codigo_parentesco,
       discapacitado,
       estudiante,
       fecha_registro,
       id_carga_cartera)
      select codigo_ars,
             periodo_factura,
             tipo_afiliado,
             nss_titular,
             decode(tipo_afiliado, 'T', nss_titular, nss_dependiente) nss_dependiente,
             codigo_parentesco,
             discapacitado,
             estudiante,
             m_hoy,
             m_carga_seq
        from (select codigo_ars,
                     periodo_factura,
                     tipo_afiliado,
                     nss_titular,
                     nss_dependiente,
                     estatus_afiliado,
                     codigo_parentesco,
                     discapacitado,
                     estudiante
                from suirplus.ars_carga_cartera_v a
               where SUBSTR(a.nss_titular,-1,1) = P_TERMINAL --Para tomar solo los NSS que terminan como el parametro P_TERMINAL
              minus
              select b.codigo_ars,
                     b.periodo_factura,
                     b.tipo_afiliado,
                     to_number(b.nss_titular) nss_titular,
                     to_number(b.nss_dependiente) nss_dependiente,
                     b.estatus_afiliado,
                     nvl(b.codigo_parentesco, '0') codigo_parentesco,
                     b.discapacitado,
                     b.estudiante
                from suirplus.ars_cartera_con_errores_t b
               where b.id_carga = m_carga_seq) a;

    m_hora_termina := sysdate;
    debug('actualizar cartera: TERMINAL NSS='|| p_terminal ||' terminada a las '||to_char(m_hora_termina,'dd/mm/yyyy hh:mi:ss am')||
          ' - Tiempo total: ('||
          TRIM(TO_CHAR(EXTRACT(HOUR FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
          TRIM(TO_CHAR(EXTRACT(MINUTE FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
          TRIM(TO_CHAR(EXTRACT(SECOND FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||
          ') - total registros: '|| sql%rowcount);

    commit;

    -- completar job
    UPDATE suirplus.seg_job_t
      SET status = 'P', fecha_termino = SYSDATE
    WHERE id_job = p_job;
    commit;
  exception
    when others then
      rollback;
      m_sqlerrm := sqlerrm;
      p_result  := Substr('ERROR. ' || m_proceso || ' Actualizar Cartera. ' ||
                          m_sqlerrm,
                          1,
                          200);
      -- completar job
      UPDATE suirplus.seg_job_t j
         SET status = 'P', 
             fecha_termino = SYSDATE,
             j.resultado = p_result
       WHERE id_job = p_job;
       commit;

      debug('error actualizar cartera: TERMINAL NSS='|| p_terminal ||' - '|| m_sqlerrm);
  end;

  -- ------------------------------------------------------------------------------------------------------------------------------------
  procedure Actualizar_dispersion(p_ciclo in number, p_result out varchar2) is
    m_sqlerrm varchar2(32000) := 'X';
  begin
    p_result := 'OK';

    -- Actualizar la cartera con la dispersion
    if p_ciclo = 1 Then
      m_hora_inicio := sysdate;
      debug('actualizar dispersion ciclo '||p_ciclo||': iniciada a las '||to_char(m_hora_inicio,'dd/mm/yyyy hh:mi:ss am'));
      
      for registros in ( -- Buscar todos los registros de dispersion
                        select nvl(c.id_ars, a.codigo_ars) id_ars,
                                a.CODIGO_ARS ID_ARS_DISPERSADA,
                                a.PERIODO_FACTURA,
                                a.NSS_TITULAR,
                                a.NSS_AFILIADO_PAGADO,
                                a.NSS_DISPARA_PAGO,
                                a.ID_REFERENCIA,
                                a.MONTO_DISPERSAR,
                                a.FECHA_CONSOLIDADO
                          from suirplus.ars_dispersion a
                          left join suirplus.ars_cartera_t c
                            on c.id_ars in
                               (select id_ars_anterior id_ars
                                  from suirplus.ars_cat_inactiva_t ci
                                 where ci.id_ars_actual = a.codigo_ars)
                           and c.periodo_factura_ars = a.periodo_factura
                           and c.nss_titular = a.nss_titular
                           and c.nss_dependiente = a.nss_afiliado_pagado
                         where not exists
                         (select 1
                                  from suirplus.ars_dispersion_con_errores_t e
                                 where e.codigo_ars = a.codigo_ars
                                   and e.periodo_factura = a.periodo_factura
                                   and e.nss_titular = a.nss_titular
                                   and e.nss_afiliado_pagado =
                                       a.nss_afiliado_pagado
                                   and e.id_carga = m_carga_seq))
      loop

        update ars_cartera_t c
           set c.id_referencia_dispersion = registros.id_referencia,
               c.nss_dispara_pago         = registros.nss_dispara_pago,
               c.id_carga_dispersion      = m_carga_seq,
               c.monto_dispersar          = registros.monto_dispersar,
               c.id_ars_dispersada        = registros.id_ars_dispersada,
               c.Registro_Dispersado      = 'S'
         where c.periodo_factura_ars = registros.periodo_factura
           and c.nss_titular = registros.nss_titular
           and c.nss_dependiente = registros.nss_afiliado_pagado
           and c.id_ars = registros.id_ars;

      end loop;
      m_hora_termina := sysdate;
      debug('actualizar dispersion ciclo '||p_ciclo||': terminada a las '||to_char(m_hora_termina,'dd/mm/yyyy hh:mi:ss am')||
            ' - Tiempo total: ('||
            TRIM(TO_CHAR(EXTRACT(HOUR FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
            TRIM(TO_CHAR(EXTRACT(MINUTE FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
            TRIM(TO_CHAR(EXTRACT(SECOND FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||
            ') - total registros: '|| sql%rowcount);
    elsif p_ciclo = 2 Then
      m_hora_inicio := sysdate;
      debug('actualizar dispersion ciclo '||p_ciclo||': iniciada a las '||to_char(m_hora_inicio,'dd/mm/yyyy hh:mi:ss am'));

      for registros in ( -- Buscar todos los registros de dispersion
                        select nvl(c.id_ars, a.codigo_ars) id_ars,
                                a.CODIGO_ARS ID_ARS_DISPERSADA,
                                a.PERIODO_FACTURA,
                                a.NSS_TITULAR,
                                a.NSS_AFILIADO_PAGADO,
                                a.NSS_DISPARA_PAGO,
                                a.ID_REFERENCIA,
                                a.MONTO_DISPERSAR,
                                a.FECHA_CONSOLIDADO
                          from suirplus.ars_dispersion_fonamat a
                          left join suirplus.ars_cartera_t c
                            on c.id_ars in
                               (select id_ars_anterior id_ars
                                  from suirplus.ars_cat_inactiva_t ci
                                 where ci.id_ars_actual = a.codigo_ars)
                           and c.periodo_factura_ars = a.periodo_factura
                           and c.nss_titular = a.nss_titular
                           and c.nss_dependiente = a.nss_afiliado_pagado
                         where not exists
                         (select 1
                                  from suirplus.ars_dispersion_con_errores_t e
                                 where e.codigo_ars = a.codigo_ars
                                   and e.periodo_factura = a.periodo_factura
                                   and e.nss_titular = a.nss_titular
                                   and e.nss_afiliado_pagado =
                                       a.nss_afiliado_pagado
                                   and e.id_carga = m_carga_seq))
      loop

        update ars_cartera_t c
           set c.id_referencia_fonamat    = registros.id_referencia,
               c.nss_dispara_pago_fonamat = registros.nss_dispara_pago,
               c.id_carga_fonamat         = m_carga_seq,
               c.monto_fonamat            = registros.monto_dispersar,
               c.id_ars_fonamat           = registros.id_ars_dispersada
         where c.periodo_factura_ars = registros.periodo_factura
           and c.nss_titular = registros.nss_titular
           and c.nss_dependiente = registros.nss_afiliado_pagado
           and c.id_ars = registros.id_ars;

      end loop;
      m_hora_termina := sysdate;
      debug('actualizar dispersion ciclo '||p_ciclo||': terminada a las '||to_char(m_hora_termina,'dd/mm/yyyy hh:mi:ss am')||
            ' - Tiempo total: ('||
            TRIM(TO_CHAR(EXTRACT(HOUR FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
            TRIM(TO_CHAR(EXTRACT(MINUTE FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
            TRIM(TO_CHAR(EXTRACT(SECOND FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||
            ') - total registros: '|| sql%rowcount);
    end if;
    commit;

  exception
    when others then
      rollback;
      m_sqlerrm := sqlerrm;
      p_result  := Substr('ERROR. ' || m_proceso ||
                          ' Actualizar Dispersion. ' || m_sqlerrm,
                          1,
                          200);
  end;

  -- ------------------------------------------------------------------------------------------------------------------------------------
  procedure procesar_cartera(p_ciclo in number, p_result out varchar2) is
    m_result varchar2(32000) := 'OK';
    e_InvalidCiclo exception; -- validacion del ciclo

    m_bitacora_return    SEG_ERROR_T.id_error%TYPE;
    m_bitacora_error_seq NUMBER;
    m_bitacora_sec       integer;
    m_ult_fecha_unipago  date;
    m_ult_fecha_tss      date;
  begin

    -- Limpiar tabla de Log
    --delete from suirplus.ars_log_t;
    --commit;
    m_debug := 0;
    debug('inicio proceso cartera');
    ------------------------------------

    p_result                     := 'OK';
    m_registros_procesados_ok    := 0;
    m_registros_procesados_error := 0;
    m_proceso                    := 'ciclo=' || nvl(p_ciclo, 0) || '.';
    debug('CARTERA: Ciclo a validar: m_proceso=' || m_proceso);

    -- Insertar el registro en la bitacora de procesos
    select suirplus.sfc_bitacora_seq.nextval into m_bitacora_sec from dual;

    insert into suirplus.sfc_bitacora_t
      (ID_PROCESO, ID_BITACORA, FECHA_INICIO, STATUS)
    values
      ('VC', m_bitacora_sec, sysdate, 'P');
    commit;
    debug('bitacora insertada #' || m_bitacora_sec || ' tipo=VC');

    -- validar el ciclo sea 1er o 2do envio o sea 3 (para recien nacidos).
    if (nvl(p_ciclo, 0) not in (1, 2, 3, 4)) then
      raise e_InvalidCiclo;
    end if;

    --Tomo los nombres de las vistas en una variable
    Select Decode(p_ciclo,
                  1,
                  'ARS_CARTERA_ACEPTADA',
                  2,
                  'ARS_NUEVOS_OK_PERIODO',
                  3,
                  'ARS_RECLAMO_RECIEN_NACIDOS_MV',
                  4,
                  'ARS_NUEVOS_OK_PERIODO_TMP')
      into m_vista
      from dual;

    -- Refrescamos las vistas en base al ciclo a correr
    if p_ciclo = 1 then
      m_hora_inicio := sysdate;
      debug('CARTERA: p_ciclo=1: Refrescamiento vista - iniciado a las '||to_char(m_hora_inicio,'dd/mm/yyyy hh:mi:ss am'));

      --Para buscar la fecha de actualizacion de la vista desde UNIPAGO.
      --Esta forma me permite compilar en ambientes donde no est? disponible el DBLINK con UNIPAGO.
      execute immediate 'select last_refresh from user_snapshots@unipro_dbl where name = ''ARS_CARTERA_ACEPTADA_MV'''
        into m_ult_fecha_unipago;

      --Para obtener la fecha de la ultima de corrida del proceso para la vista ARS_CARTERA_ACEPTADA
      Begin
        select ult_fecha_act
          into m_ult_fecha_tss
          from suirplus.ars_actualizacion_vistas_t
         where nombre_vista = m_vista;
      Exception
        When No_Data_Found Then
          m_ult_fecha_tss := sysdate;
      End;

      --Si las fechas son identicas cancelo el proceso
      if (m_ult_fecha_tss = m_ult_fecha_unipago) then
        update suirplus.sfc_bitacora_t b
           set b.fecha_fin = sysdate,
               b.mensage   = 'La fecha de actualizacion de la vista ' ||
                             m_vista ||
                             ' no ha sufrido cambio desde la ultima corrida.',
               b.status    = 'E'
         where b.id_bitacora = m_bitacora_sec;
        commit;
        
        m_hora_termina := sysdate;
        debug('CARTERA: p_ciclo=1: Refrescamiento vista - terminado a las '||to_char(m_hora_termina,'dd/mm/yyyy hh:mi:ss am')||
              ' - Tiempo total: ('||
              TRIM(TO_CHAR(EXTRACT(HOUR FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
              TRIM(TO_CHAR(EXTRACT(MINUTE FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
              TRIM(TO_CHAR(EXTRACT(SECOND FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||
              ')');
        return;
      end if;

      execute immediate 'begin sys.dbms_snapshot.refresh(''suirplus.' ||
                        m_vista || '''); end;';

      m_hora_termina := sysdate;
      debug('CARTERA: p_ciclo=1: Refrescamiento vista - terminado a las '||to_char(m_hora_termina,'dd/mm/yyyy hh:mi:ss am')||
            ' - Tiempo total: ('||
            TRIM(TO_CHAR(EXTRACT(HOUR FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
            TRIM(TO_CHAR(EXTRACT(MINUTE FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
            TRIM(TO_CHAR(EXTRACT(SECOND FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||
            ')');
    elsif p_ciclo = 2 then
      m_hora_inicio := sysdate;
      debug('CARTERA: p_ciclo=2: Refrescamiento vista - iniciado a las '||to_char(m_hora_inicio,'dd/mm/yyyy hh:mi:ss am'));

      --Para buscar la fecha de actualizacion de la vista desde UNIPAGO.
      --Esta forma me permite compilar en ambientes donde no est? disponible el DBLINK con UNIPAGO.
      execute immediate 'select last_refresh from user_snapshots@unipro_dbl where name = ''' ||
                        m_vista || ''''
        into m_ult_fecha_unipago;

      --Para obtener la fecha de la ultima de corrida del proceso para la vista ARS_NUEVOS_OK_PERIODO
      Begin
        select ult_fecha_act
          into m_ult_fecha_tss
          from suirplus.ars_actualizacion_vistas_t
         where nombre_vista = m_vista;
      Exception
        When No_Data_Found Then
          m_ult_fecha_tss := sysdate;
      End;

      --Si las fechas son identicas cancelo el proceso
      if (m_ult_fecha_tss = m_ult_fecha_unipago) then
        update suirplus.sfc_bitacora_t b
           set b.fecha_fin = sysdate,
               b.mensage   = 'La fecha de actualizacion de la vista ' ||
                             m_vista ||
                             ' no ha sufrido cambio desde la ultima corrida.',
               b.status    = 'E'
         where b.id_bitacora = m_bitacora_sec;
        commit;

        m_hora_termina := sysdate;
        debug('CARTERA: p_ciclo=2: Refrescamiento vista - terminado a las '||to_char(m_hora_termina,'dd/mm/yyyy hh:mi:ss am')||
              ' - Tiempo total: ('||
              TRIM(TO_CHAR(EXTRACT(HOUR FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
              TRIM(TO_CHAR(EXTRACT(MINUTE FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
              TRIM(TO_CHAR(EXTRACT(SECOND FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||
              ')');
        return;
      end if;

      execute immediate 'begin sys.dbms_snapshot.refresh(''suirplus.' ||
                        m_vista || '''); end;';

      m_hora_termina := sysdate;
      debug('CARTERA: p_ciclo=2: Refrescamiento vista - terminado a las '||to_char(m_hora_termina,'dd/mm/yyyy hh:mi:ss am')||
            ' - Tiempo total: ('||
            TRIM(TO_CHAR(EXTRACT(HOUR FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
            TRIM(TO_CHAR(EXTRACT(MINUTE FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
            TRIM(TO_CHAR(EXTRACT(SECOND FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||
            ')');
    elsif p_ciclo = 3 then
      m_hora_inicio := sysdate;
      debug('CARTERA: p_ciclo=3: Refrescamiento vista - iniciado a las '||to_char(m_hora_inicio,'dd/mm/yyyy hh:mi:ss am'));

      --Para buscar la fecha de actualizacion de la vista desde UNIPAGO.
      --Esta forma me permite compilar en ambientes donde no est? disponible el DBLINK con UNIPAGO.
      execute immediate 'select last_refresh from user_snapshots@unipro_dbl where name = ''' ||
                        m_vista || ''''
        into m_ult_fecha_unipago;

      --Para obtener la fecha de la ultima de corrida del proceso para la vista ARS_RECLAMO_RECIEN_NACIDOS_MV
      Begin
        select ult_fecha_act
          into m_ult_fecha_tss
          from suirplus.ars_actualizacion_vistas_t
         where nombre_vista = m_vista;
      Exception
        When No_Data_Found Then
          m_ult_fecha_tss := sysdate;
      End;

      --Si las fechas son identicas cancelo el proceso
      if (m_ult_fecha_tss = m_ult_fecha_unipago) then
        update suirplus.sfc_bitacora_t b
           set b.fecha_fin = sysdate,
               b.mensage   = 'La fecha de actualizacion de la vista ' ||
                             m_vista ||
                             ' no ha sufrido cambio desde la ultima corrida.',
               b.status    = 'E'
         where b.id_bitacora = m_bitacora_sec;
        commit;

        m_hora_termina := sysdate;
        debug('CARTERA: p_ciclo=3: Refrescamiento vista - terminado a las '||to_char(m_hora_termina,'dd/mm/yyyy hh:mi:ss am')||
              ' - Tiempo total: ('||
              TRIM(TO_CHAR(EXTRACT(HOUR FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
              TRIM(TO_CHAR(EXTRACT(MINUTE FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
              TRIM(TO_CHAR(EXTRACT(SECOND FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||
              ')');
        return;
      end if;

      execute immediate 'begin sys.dbms_snapshot.refresh(''suirplus.' ||
                        m_vista || '''); end;';

      m_hora_termina := sysdate;
      debug('CARTERA: p_ciclo=3: Refrescamiento vista - terminado a las '||to_char(m_hora_termina,'dd/mm/yyyy hh:mi:ss am')||
            ' - Tiempo total: ('||
            TRIM(TO_CHAR(EXTRACT(HOUR FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
            TRIM(TO_CHAR(EXTRACT(MINUTE FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
            TRIM(TO_CHAR(EXTRACT(SECOND FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||
            ')');
    elsif p_ciclo = 4 then
      m_hora_inicio := sysdate;
      debug('CARTERA: p_ciclo=4: Refrescamiento vista - iniciado a las '||to_char(m_hora_inicio,'dd/mm/yyyy hh:mi:ss am'));

      --Para buscar la fecha de actualizacion de la vista desde UNIPAGO.
      --Esta forma me permite compilar en ambientes donde no est? disponible el DBLINK con UNIPAGO.
      Begin
        execute immediate 'select last_refresh from user_snapshots@unipro_dbl where name = ''' ||
                          m_vista || ''''
          into m_ult_fecha_unipago;
      Exception
        When No_Data_Found Then
          m_ult_fecha_unipago := sysdate;
      End;

      --Para obtener la fecha de la ultima de corrida del proceso para la vista ARS_NUEVOS_OK_PERIODO
      Begin
        select ult_fecha_act
          into m_ult_fecha_tss
          from suirplus.ars_actualizacion_vistas_t
         where nombre_vista = m_vista;
      Exception
        When No_Data_Found Then
          m_ult_fecha_tss := sysdate;
      End;

      --Si las fechas son identicas cancelo el proceso
      if (m_ult_fecha_tss = m_ult_fecha_unipago) then
        update suirplus.sfc_bitacora_t b
           set b.fecha_fin = sysdate,
               b.mensage   = 'La fecha de actualizacion de la vista ' ||
                             m_vista ||
                             ' no ha sufrido cambio desde la ultima corrida.',
               b.status    = 'E'
         where b.id_bitacora = m_bitacora_sec;
        commit;

        m_hora_termina := sysdate;
        debug('CARTERA: p_ciclo=4: Refrescamiento vista - terminado a las '||to_char(m_hora_termina,'dd/mm/yyyy hh:mi:ss am')||
              ' - Tiempo total: ('||
              TRIM(TO_CHAR(EXTRACT(HOUR FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
              TRIM(TO_CHAR(EXTRACT(MINUTE FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
              TRIM(TO_CHAR(EXTRACT(SECOND FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||
              ')');
        return;
      end if;

      execute immediate 'begin sys.dbms_snapshot.refresh(''suirplus.' ||
                        m_vista || '''); end;';

      m_hora_termina := sysdate;
      debug('CARTERA: p_ciclo=4: Refrescamiento vista - terminado a las '||to_char(m_hora_termina,'dd/mm/yyyy hh:mi:ss am')||
            ' - Tiempo total: ('||
            TRIM(TO_CHAR(EXTRACT(HOUR FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
            TRIM(TO_CHAR(EXTRACT(MINUTE FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
            TRIM(TO_CHAR(EXTRACT(SECOND FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||
            ')');
    end if;
--    debug('vista refrescada');

    -- Actualizar parametro para la corrida actual.
    update sfc_det_parametro_t d
       set d.valor_numerico = p_ciclo
     where d.id_parametro = 204
       and d.fecha_ini in (select max(d.fecha_ini)
                             from sfc_det_parametro_t d
                            where d.id_parametro = 204);
    commit;
    debug('CARTERA: parametro actualizado');

    -- Insertar el registro en historico de cargas
    select suirplus.ars_carga_seq.nextval into m_carga_seq from dual;
    m_proceso := m_proceso || ' carga=' || m_carga_seq || '.';

    insert into suirplus.ars_carga_t
      (ID_CARGA, FECHA, STATUS, VISTA, REGISTROS_OK, REGISTROS_ERROR)
    values
      (m_carga_seq, sysdate, 'P', m_vista, null, null);
    commit;
    debug('CARTERA: carga creada #' || m_carga_seq);

    -- Validar la cartera
    validar_cartera(m_result);
    debug('cartera validada: resultado=' || m_result);

    -- Actualizar la cartera, si no hubo problemas (excepciones, etc.)
    if m_result = 'OK' Then
      Declare
        v_Proximo_Job number(10);
      Begin
        --Llamamos la actualizacion de cartera SERIALIZADA. Ticket 6479
        For terminal in 0..9 Loop
          Select suirplus.Seg_Job_Seq.Nextval Into v_Proximo_Job From Dual;

          v_Comando := 'DECLARE v_result varchar2(500); BEGIN suirplus.ars_validaciones_pkg.actualizar_cartera('||m_carga_seq||', '||terminal ||', '|| v_Proximo_Job||', v_result); END;';
      
          Insert Into suirplus.Seg_Job_t(Id_Job, Nombre_Job, Status, Fecha_Envio)
          Values(v_Proximo_Job, v_Comando, 'S', Sysdate);
          Commit;
          
          --actualizar_cartera(m_result);
        End Loop;
        debug('cartera actualizada: resultado=' || m_result);
      End;  
    end if;

    -- Actualizar historico de cargas y Bitacora
    if m_result = 'OK' Then
      debug('bitacora insertada=OK');
      -- Actualizar el registro en historico de cargas con el resultado
      update suirplus.ars_carga_t
         set STATUS          = 'C',
             REGISTROS_OK    = m_registros_procesados_ok,
             REGISTROS_ERROR = m_registros_procesados_error
       where ID_CARGA = m_carga_seq;
      debug('bitacora insertada=OK update1');

      -- Actualizar el resultado del proceso en la bitacora
      update suirplus.sfc_bitacora_t b
         set b.fecha_fin = sysdate,
             b.mensage   = 'OK. ' || m_proceso,
             b.status    = 'O',
             b.id_error  = '000'
       where b.id_bitacora = m_bitacora_sec;
      debug('bitacora insertada=OK update2');

      -- Enviar email indicando corrida satisfactoria
      enviar_email('C', m_carga_seq);
    else
      debug('bitacora insertada<>OK');
      -- Actualizar el registro en historico de cargas con el resultado
      update suirplus.ars_carga_t
         set STATUS = 'E'
       where ID_CARGA = m_carga_seq;
      debug('bitacora insertada=OK update1');

      -- Actualizar el resultado del proceso en la bitacora
      m_bitacora_return    := 650;
      m_bitacora_error_seq := 0;

      update suirplus.sfc_bitacora_t b
         set b.fecha_fin  = sysdate,
             b.mensage    = SubStr(m_result, 1, 200),
             b.status     = 'E',
             b.id_error   = m_bitacora_return,
             b.seq_number = m_bitacora_error_seq
       where b.id_bitacora = m_bitacora_sec;
      debug('bitacora insertada=OK update2');
    end if;
    commit;

    p_result := m_result;
    debug('fin normal execution');

    --Actualizo la ultima fecha de actualizacion de la vista tal como esta en UNIPAGO
    Update suirplus.ars_actualizacion_vistas_t
       set ult_fecha_act = m_ult_fecha_unipago
     Where nombre_vista = m_vista;
    Commit;
    debug('actualiza vista unipago: ' || m_vista || ' = ' ||
          m_ult_fecha_unipago);
  exception
    when e_InvalidCiclo then
      debug('excepcion:' || substr(sqlerrm, 1, 950));
      p_result := 'ERROR. ' || m_proceso ||
                  ' Procesar cartera. ciclo invalido.';

      -- Actualizar el resultado del proceso en la bitacora
      m_bitacora_return    := 650;
      m_bitacora_error_seq := 0;

      update suirplus.sfc_bitacora_t b
         set b.fecha_fin  = sysdate,
             b.mensage    = SubStr(p_result, 1, 200),
             b.status     = 'E',
             b.id_error   = m_bitacora_return,
             b.seq_number = m_bitacora_error_seq
       where b.id_bitacora = m_bitacora_sec;
      commit;

    when others then
      rollback;
      debug('excepcion:' || substr(sqlerrm, 1, 950));

      p_result := substr('ERROR. ' || m_proceso || ' ' || sqlerrm, 1, 200);

      -- Actualizar el registro en historico de cargas con el resultado
      update suirplus.ars_carga_t
         set STATUS = 'E'
       where ID_CARGA = m_carga_seq;
      commit;
      debug('excepcion update1');

      -- Actualizar el resultado del proceso en la bitacora
      m_bitacora_return    := 650;
      m_bitacora_error_seq := 0;

      update suirplus.sfc_bitacora_t b
         set b.fecha_fin  = sysdate,
             b.mensage    = SubStr(p_result, 1, 200),
             b.status     = 'E',
             b.id_error   = m_bitacora_return,
             b.seq_number = m_bitacora_error_seq
       where b.id_bitacora = m_bitacora_sec;
      debug('excepcion update2');
      commit;

      system.html_mail(c_mail_from,
                       c_mail_error,
                       'Error en ' || c_mail_subject,
                       'p_ciclo=' || p_ciclo || '<br>carga=' || m_carga_seq -- indicar la carga que se estaba procesando
                       || '<br>Error=' || substr(sqlerrm, 1, 200));
      debug('fin exception');
  end;

  -- ------------------------------------------------------------------------------------------------------------------------------------
  procedure procesar_dispersion(p_ciclo in number, p_result out varchar2) is

    m_result             varchar2(32000) := 'OK';
    m_bitacora_return    SEG_ERROR_T.id_error%TYPE;
    m_bitacora_error_seq NUMBER;
    m_bitacora_sec       integer;
    m_ult_fecha_unipago  date := sysdate - 10;
    m_ult_fecha_tss      date;
    m_ejecutar           varchar2(1);
    m_ciclo              number;
  begin
    p_result                     := 'OK';
    m_registros_procesados_ok    := 0;
    m_registros_procesados_error := 0;

    m_ciclo := nvl(p_ciclo, 1);
    --debug('ars_validaciones_pkg2. Procesar dispersion:1');

    --Para reconsiderar los ciclos fuera de 1 y 2
    If nvl(m_ciclo, 1) > 2 Then
      m_ciclo := 1;
    End if;

    --Tomo los nombres de las vistas en una variable
    Select Case m_ciclo
             When 1 Then
              'ARS_DISPERSION_MV'
             When 2 Then
              'ARS_DISPERSION_FONAMAT_MV'
           End
      into m_vista
      From dual;

    --debug('procesar dispersion:2');
    
    m_hora_inicio := sysdate;
    debug('DISPERSION: p_ciclo='||m_ciclo||' Refrescamiento vista - iniciado a las '||to_char(m_hora_inicio,'dd/mm/yyyy hh:mi:ss am'));
    
    -- Insertar el registro en la bitacora de procesos
    select suirplus.sfc_bitacora_seq.nextval into m_bitacora_sec from dual;

    insert into suirplus.sfc_bitacora_t
      (ID_PROCESO, ID_BITACORA, FECHA_INICIO, STATUS)
    values
      ('UD', m_bitacora_sec, sysdate, 'P');
    commit;

--    debug('procesar dispersion:3a');
    --Para buscar la fecha de actualizacion de la vista desde UNIPAGO.
    --Esta forma me permite compilar en ambientes donde no est? disponible el DBLINK con UNIPAGO.
-- xxxxxxxxxxxxxx
    execute immediate 'select last_refresh from user_snapshots@unipro_dbl where name = ''' ||m_vista || '''' into m_ult_fecha_unipago;
-- xxxxxxxxxxxxxx
--    debug('procesar dispersion:3b');

    --Para obtener la fecha de la ultima de corrida del proceso para la vista ARS_DISPERSION
    Begin
--      debug('procesar dispersion:3c');
      select ult_fecha_act, ejecutar
        into m_ult_fecha_tss, m_ejecutar
        from suirplus.ars_actualizacion_vistas_t
       where nombre_vista = m_vista;
    Exception
      When No_Data_Found Then
--        debug('procesar dispersion:3d');
        m_ult_fecha_tss := sysdate;
    End;

--    debug('procesar dispersion:4');
    --Si las fechas son identicas o si el campo ejecutar dice 'N' cancelo el proceso
-- xxxxxxxxxxxxxx
--    m_ult_fecha_tss := sysdate;
--    m_ult_fecha_unipago := sysdate -1;
-- xxxxxxxxxxxxxx

    if (m_ult_fecha_tss = m_ult_fecha_unipago) or (m_ejecutar = 'N') then
      update suirplus.sfc_bitacora_t b
         set b.fecha_fin = sysdate,
             b.mensage   = 'La fecha de actualizacion de la vista ' ||
                           m_vista ||
                           ' no ha sufrido cambio desde la ultima corrida.',
             b.status    = 'E'
       where b.id_bitacora = m_bitacora_sec;
       
      m_hora_termina := sysdate;
      debug('DISPERSION: p_ciclo='||m_ciclo||' Refrescamiento vista - terminado a las '||to_char(m_hora_termina,'dd/mm/yyyy hh:mi:ss am')||
            ' - Tiempo total: ('||
            TRIM(TO_CHAR(EXTRACT(HOUR FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
            TRIM(TO_CHAR(EXTRACT(MINUTE FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
            TRIM(TO_CHAR(EXTRACT(SECOND FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||
            ')');       
      commit;
    Else
--      debug('procesar dispersion:5');
      -- Refrescamos la vista
-- xxxxxxxxxxxxxx
      execute immediate 'begin sys.dbms_snapshot.refresh(''suirplus.' || replace(m_vista, '_MV', '') || '''); end;';
-- xxxxxxxxxxxxxx
--      debug('procesar dispersion:6');
      m_hora_termina := sysdate;
      debug('DISPERSION: p_ciclo='||m_ciclo||' Refrescamiento vista - terminado a las '||to_char(m_hora_termina,'dd/mm/yyyy hh:mi:ss am')||
            ' - Tiempo total: ('||
            TRIM(TO_CHAR(EXTRACT(HOUR FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
            TRIM(TO_CHAR(EXTRACT(MINUTE FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||':'||
            TRIM(TO_CHAR(EXTRACT(SECOND FROM NUMTODSINTERVAL(m_hora_termina - m_hora_inicio, 'DAY')),'00'))||
            ')');       

      -- Insertar el registro en historico de cargas
      select suirplus.ars_carga_seq.nextval into m_carga_seq from dual;
      m_proceso := 'carga=' || m_carga_seq || '.';

      insert into suirplus.ars_carga_t
        (ID_CARGA, FECHA, STATUS, VISTA, REGISTROS_OK, REGISTROS_ERROR)
      values
        (m_carga_seq, sysdate, 'P', m_vista, null, null);
      commit;
--      debug('procesar dispersion:7');
      debug('DISPERSION: carga creada #' || m_carga_seq);
  
    -- Validar la dispersion
      validar_dispersion(m_ciclo, m_result);
--      debug('procesar dispersion:8');

      -- Dispersar la cartera, si no hubo problemas (excepciones, etc.)
      if (m_result = 'OK') Then
--        debug('actualizar_dispersion:1');
        actualizar_dispersion(m_ciclo, m_result);
--        debug('actualizar_dispersion:2');
      end if;

      -- Actualizar historico de cargas y Bitacora
      if m_result = 'OK' Then
        -- Actualizar el registro en historico de cargas con el resultado
        update suirplus.ars_carga_t
           set STATUS          = 'C', -- Modificado por: Cethy Hernandez - 10-8-2016: Dispersion Preliminar
               REGISTROS_OK    = m_registros_procesados_ok,
               REGISTROS_ERROR = m_registros_procesados_error
         where ID_CARGA = m_carga_seq;

        -- Carga resumen dispersion
        Cargar_Resumen_Dispersion(m_carga_seq, m_ciclo, p_result);

        -- Actualizar el resultado del proceso en la bitacora
        update suirplus.sfc_bitacora_t b
           set b.fecha_fin = sysdate,
               b.mensage   = 'OK. ' || m_proceso,
               b.status    = 'O',
               b.id_error  = '000'
         where b.id_bitacora = m_bitacora_sec;

        -- Enviar email indicando corrida satisfactoria
        enviar_email('D', m_carga_seq);
      else
        -- Actualizar el registro en historico de cargas con el resultado
        update suirplus.ars_carga_t
           set STATUS = 'E'
         where ID_CARGA = m_carga_seq;

        -- Actualizar el resultado del proceso en la bitacora
        m_bitacora_return    := 650;
        m_bitacora_error_seq := 0;

        update suirplus.sfc_bitacora_t b
           set b.fecha_fin  = sysdate,
               b.mensage    = SubStr(m_result, 1, 200),
               b.status     = 'E',
               b.id_error   = m_bitacora_return,
               b.seq_number = m_bitacora_error_seq
         where b.id_bitacora = m_bitacora_sec;
      end if;
      commit;

      p_result := SubStr(m_result, 1, 200);

      --Actualizo la ultima fecha de actualizacion de la vista tal como esta en UNIPAGO
      Update suirplus.ars_actualizacion_vistas_t
         set ult_fecha_act = m_ult_fecha_unipago
       Where nombre_vista = m_vista;
      Commit;
    End if;
  exception
    when others then
      rollback;
      p_result := substr('ERROR. ' || m_proceso || ' Procesar dispersion. ' ||
                         sqlerrm,
                         1,
                         200);
      m_result := p_result;

      -- Actualizar el registro en historico de cargas con el resultado
      update suirplus.ars_carga_t
         set STATUS = 'E'
       where ID_CARGA = m_carga_seq;
      commit;

      -- Actualizar el resultado del proceso en la bitacora
      m_bitacora_return    := 650;
      m_bitacora_error_seq := 0;

      update suirplus.sfc_bitacora_t b
         set b.fecha_fin  = sysdate,
             b.mensage    = SubStr(m_result, 1, 200),
             b.status     = 'E',
             b.id_error   = m_bitacora_return,
             b.seq_number = m_bitacora_error_seq
       where b.id_bitacora = m_bitacora_sec;
      commit;
  end;
  -- ------------------------------------------------------------------------------------------------------------------------------------

  -- ------------------------------------------------------------------------------------------------------------------------------------
  procedure procesar_dispersion_comp(p_result out varchar2) is

    m_result varchar2(32000) := 'OK';
    m_vista  suirplus.ars_carga_t.vista%type := 'ARS_DISPERSION';

    m_bitacora_return    SEG_ERROR_T.id_error%TYPE;
    m_bitacora_error_seq NUMBER;
    m_bitacora_sec       integer;
  begin
    p_result                     := 'OK';
    m_registros_procesados_ok    := 0;
    m_registros_procesados_error := 0;

    -- Insertar el registro en la bitacora de procesos
    select suirplus.sfc_bitacora_seq.nextval into m_bitacora_sec from dual;

    insert into suirplus.sfc_bitacora_t
      (ID_PROCESO, ID_BITACORA, FECHA_INICIO, STATUS)
    values
      ('DC', m_bitacora_sec, sysdate, 'P');
    commit;

    -- Insertar el registro en historico de cargas
    select suirplus.ars_carga_seq.nextval into m_carga_seq from dual;
    m_proceso := 'carga=' || m_carga_seq || '.';

    insert into suirplus.ars_carga_t
      (ID_CARGA, FECHA, STATUS, VISTA, REGISTROS_OK, REGISTROS_ERROR)
    values
      (m_carga_seq, sysdate, 'P', m_vista, null, null);
    commit;

    -- Validar la dispersion
    validar_dispersion_comp(m_result);

    -- Actualizar historico de cargas y Bitacora
    if m_result = 'OK' Then
      -- Actualizar la cartera con los registros aceptados de la dispersion
      For registros in (select a.codigo_ars,
                               a.periodo_factura,
                               a.nss_titular,
                               a.nss_afiliado_pagado,
                               a.nss_dispara_pago,
                               a.id_referencia,
                               a.monto_dispersar
                          from ars_dispersion a
                        MINUS
                        select b.codigo_ars,
                               b.periodo_factura,
                               b.nss_titular,
                               b.nss_afiliado_pagado,
                               b.nss_dispara_pago,
                               b.id_referencia,
                               to_number(NVL(b.nombre_nacha, 0)) monto_dispersar
                          from ars_dispersion_con_errores_t b
                         where b.id_carga = m_carga_seq) Loop
        Update ars_cartera_t c
           Set c.monto_completivo    = registros.monto_dispersar,
               c.id_carga_completivo = m_carga_seq
         Where c.periodo_factura_ars = registros.periodo_factura
           and c.nss_titular = registros.nss_titular
           and c.nss_dependiente = registros.nss_afiliado_pagado
           and c.id_ars = registros.codigo_ars;
      End Loop;
      Commit;

      -- Actualizar el registro en historico de cargas con el resultado
      update suirplus.ars_carga_t
         set STATUS          = 'C',
             REGISTROS_OK    = m_registros_procesados_ok,
             REGISTROS_ERROR = m_registros_procesados_error
       where ID_CARGA = m_carga_seq;

      -- Actualizar el resultado del proceso en la bitacora
      update suirplus.sfc_bitacora_t b
         set b.fecha_fin = sysdate,
             b.mensage   = 'OK. ' || m_proceso,
             b.status    = 'O',
             b.id_error  = '000'
       where b.id_bitacora = m_bitacora_sec;

      -- Enviar email indicando corrida satisfactoria
      enviar_email('D', m_carga_seq);
    else
      -- Actualizar el registro en historico de cargas con el resultado
      update suirplus.ars_carga_t
         set STATUS = 'E'
       where ID_CARGA = m_carga_seq;

      -- Actualizar el resultado del proceso en la bitacora
      m_bitacora_return    := 650;
      m_bitacora_error_seq := 0;

      update suirplus.sfc_bitacora_t b
         set b.fecha_fin  = sysdate,
             b.mensage    = SubStr(m_result, 1, 200),
             b.status     = 'E',
             b.id_error   = m_bitacora_return,
             b.seq_number = m_bitacora_error_seq
       where b.id_bitacora = m_bitacora_sec;
    end if;
    commit;

    p_result := SubStr(m_result, 1, 200);
  exception
    when others then
      rollback;
      p_result := substr('ERROR. ' || m_proceso ||
                         ' Procesar dispersion completivo. ' || sqlerrm,
                         1,
                         200);
      m_result := p_result;

      -- Actualizar el registro en historico de cargas con el resultado
      update suirplus.ars_carga_t
         set STATUS = 'E'
       where ID_CARGA = m_carga_seq;
      commit;

      -- Actualizar el resultado del proceso en la bitacora
      m_bitacora_return    := 650;
      m_bitacora_error_seq := 0;

      update suirplus.sfc_bitacora_t b
         set b.fecha_fin  = sysdate,
             b.mensage    = SubStr(m_result, 1, 200),
             b.status     = 'E',
             b.id_error   = m_bitacora_return,
             b.seq_number = m_bitacora_error_seq
       where b.id_bitacora = m_bitacora_sec;
      commit;
  end;
  -- ------------------------------------------------------------------------------------------------------------------------------------

  ---************************************************************************************--
  -- Milciades Hernandez
  -- 25/08/2010
  -- saca el resumen de un consolidado para una primera o segunda dispersi?n de acuerdo al periodo.
  ---************************************************************************************--
  procedure ResumenConsol1raDispersion(p_periodo      in ars_dispersion_resumen_t.periodo_dispersion%type,
                                       p_ciclo        in pls_integer,
                                       p_tipo         in integer,
                                       p_iocursor     in out t_cursor,
                                       p_resultnumber out Varchar2) is
    v_cursor  t_cursor;
    v_bderror varchar2(1000);
    e_existPeriodo exception;
    v_max   number;
    v_min   number;
    m_vista varchar2(10000);

  begin
    if p_tipo = 1 then
      m_vista := 'ARS_DISPERSION_MV';
    else
      m_vista := 'ARS_DISPERSION_FONAMAT_MV';
    end if;
    select max(a.id_carga), min(a.id_carga)
      into v_max, v_min
      from ars_carga_t a, ars_dispersion_resumen_t d
     where a.id_carga = d.id_carga_dispersion
       and a.status = 'C'
       and a.vista = m_vista
       and d.periodo_dispersion = p_periodo;

    if v_max = v_min then
      v_max := -1;
    end if;

    open v_cursor for

      Select b.id_ars ID,
             b.ars_des ARS,
             sum(a.titulares) titulares,
             sum(a.dependientes) dependientes,
             sum(a.adicionales) adicionales,
             sum(a.monto_titulares) monto_titulares,
             sum(a.monto_dependientes) monto_dependientes,
             sum(a.monto_adicionales) monto_adicionales,
             sum(a.pago) pago
        from suirplus.ars_carga_t ca
        left join suirplus.ars_dispersion_resumen_t a
          on a.id_carga_dispersion = ca.id_carga
        left join suirplus.ars_catalogo_t b
          on b.id_ars = a.id_ars_dispersada
       where a.periodo_dispersion = p_periodo
         and ca.vista = m_vista
         and a.id_carga_dispersion =
             decode(p_ciclo, 1, v_min, 2, v_max, a.id_carga_dispersion)
         and ca.status = 'C'
       group by b.id_ars, b.ars_des
       order by b.id_ars, b.ars_des;

    p_resultnumber := 0;
    p_iocursor     := v_cursor;
  exception
    when others then
      v_bderror      := (substr('error ' || to_char(sqlcode) || ':' ||
                                sqlerrm,
                                1,
                                255));
      p_resultnumber := seg_retornar_cadena_error(-1, v_bderror, sqlcode);
  end;

  ---************************************************************************************--
  -- prog = getPeriodosDispersion
  -- by charile pe?a
  -- trae una lista de los distintos periodos que existen en dispersion.
  ---************************************************************************************--
  procedure getPeriodosDispersion(p_iocursor     in out t_cursor,
                                  p_resultnumber out Varchar2) is
    v_cursor  t_cursor;
    v_bderror varchar2(1000);

  begin

    open v_cursor for
      select distinct a.periodo_dispersion
        from ars_dispersion_resumen_t a
       order by a.periodo_dispersion desc;

    p_resultnumber := 0;
    p_iocursor     := v_cursor;

  exception

    when others then
      v_bderror      := (substr('error ' || to_char(sqlcode) || ':' ||
                                sqlerrm,
                                1,
                                255));
      p_resultnumber := seg_retornar_cadena_error(-1, v_bderror, sqlcode);
  end;

  -- -----------------------------------------------------------------------
  -- Reversar_dispersion
  -- GREIMAN GARCIA
  -- 20/10/201010
  -- -----------------------------------------------------------------------
  procedure Reversar_dispersion(p_Carga  suirplus.ars_cartera_t.id_carga_dispersion%type,
                                p_result out varchar2) is
    m_result varchar2(32000) := 'OK';
    e_InvalidCiclo exception;
    e_InvaliCarga  exception;
    v_cantidad integer;
  begin
    --valida que el id_carga no sea nulo
    if p_Carga is null then
      raise e_InvalidCiclo;
    end if;
    -- valida que el id_carga exista en la tabla
    select count(*)
      into v_cantidad
      from suirplus.ars_cartera_t a
     where a.id_carga_dispersion = p_carga;

    if v_cantidad <= 0 then
      raise e_InvaliCarga;
    end if;

    for registros in ( -- Buscar todos los registros de dispersion
                      select rowid id
                        from suirplus.ars_cartera_t a
                       where a.id_carga_dispersion = p_carga) loop
      update suirplus.ars_cartera_t c
         set c.id_referencia_dispersion = null,
             c.nss_dispara_pago         = null,
             c.id_carga_dispersion      = null,
             c.monto_dispersar          = null,
             c.id_ars_dispersada        = null,
             c.Registro_Dispersado      = 'N'
       where rowid = registros.id;

      update suirplus.ars_carga_t ca
         set ca.status = 'E'
       where ca.id_carga = p_carga;

      delete from suirplus.ars_dispersion_resumen_t dr
       where dr.id_carga_dispersion = p_carga;

      p_result := m_result;
    end loop;
  exception
    when e_InvalidCiclo then
      p_result := 'ERROR. El parametro de ID_CARGA no puede estar nulo.';
    when e_InvaliCarga then
      p_result := 'ERROR. No existe un ID_CARGA para reversar.';
  end;

Procedure Procesar_job (p_proceso in varchar2, p_tipo in integer, p_job IN suirplus.seg_job_t.id_job%TYPE) is
  c_resultado varchar2(1024);
  p_result    varchar2(1024);
  begin
    debug('ARS Carga: Inicio.' );

    if nvl(p_proceso, 'X') in ('C','D') then
       if nvl(p_tipo, 0) in (1,2,3,4) then
         -- -----------------------------
         -- Correr procesos
         -- -----------------------------
         if p_proceso = 'C' and p_tipo in (1,2,3,4) then
            suirplus.ars_validaciones_pkg.procesar_cartera(p_tipo, p_result);
            debug( 'Resultado de la Corrida de Cartera: ' ||p_result);
         elsif p_proceso = 'D' and p_tipo in (1,2) then
            suirplus.ars_validaciones_pkg.procesar_dispersion(p_tipo, p_result);
            debug( 'Resultado de la Corrida de Dispersion: ' ||p_result);
         else
            debug( 'Parametros Invalidos.' );
         end if;
         -- -----------------------------

       else
         debug('Tipo Carga Invalido.  Debe ser 1, 2, 3 o 4.' );
       end if;
    else
      debug('Tipo Proceso Invalido. Debe ser C o D.' );
    end if;

    -- completar job
    UPDATE suirplus.seg_job_t
       SET status = 'P',
           fecha_termino = SYSDATE
     WHERE id_job = p_job;
    commit;
    debug('ARS Carga: Fin.' );

  EXCEPTION
    WHEN OTHERS THEN
      c_resultado := SUBSTR('Job Ejecutado con Error: ' || SQLERRM, 1, 400);
      debug(c_resultado);

      UPDATE suirplus.seg_job_t j
         SET status = 'P',
             fecha_termino = SYSDATE,
             j.resultado = c_resultado
       WHERE id_job = p_job;
       commit;
  end;

  Procedure Crear_job (p_proceso in varchar2, p_tipo in integer, p_result out varchar2) is
  begin
    p_result := 'Incompleto';
    debug('ARS JOB: Inicio.' );

    if nvl(p_proceso, 'X') not in ('C','D') then
      p_result := 'Tipo Proceso Invalido. Debe ser C o D.';
      debug(p_result);
      return;
    end if;

    if  nvl(p_tipo, 0) not in (1,2,3,4) then
      p_result := 'Tipo Carga Invalido.  Debe ser 1, 2, 3 o 4.';
      debug(p_result);
      return;
    end if;

    begin
      Select suirplus.Seg_Job_Seq.Nextval Into v_Proximo_Job From Dual;

      v_Comando := 'suirplus.ars_validaciones_pkg.Procesar_job(''' || p_proceso || ''', ' || p_tipo || ', ' || v_Proximo_Job || ');';
      dbms_output.put_line( 'Job: ' || v_Comando);

      Insert Into suirplus.Seg_Job_t(Id_Job, Nombre_Job, Status, Fecha_Envio)
      Values(v_Proximo_Job, v_Comando, 'S', Sysdate);
      commit;

      p_result := 'OK';
    debug('ARS JOB: Fin.  Job: ' || v_Proximo_Job );

    exception
      when others then
      p_result := sqlerrm;
    end;
  end;

-- -----------------------------------------------------------------------------------------------
-- Anonymous Block
-- -----------------------------------------------------------------------------------------------
begin
  -- obtener lista de codigos de ars (para ambos casos)
  m_codigos_ars := ',';
  for ars in (select id_ars from suirplus.ars_catalogo_t) loop
    m_codigos_ars := m_codigos_ars || ars.id_ars || ',';
  end loop;

  m_codigos_ars_inactivas := ',';
  for ars in (select id_ars_anterior id_ars from suirplus.ars_cat_inactiva_t) loop
    m_codigos_ars_inactivas := m_codigos_ars_inactivas || ars.id_ars || ',';
  end loop;

  Begin
    select a.lista_ok, a.lista_error
      into c_mail_to, c_mail_error
      from suirplus.sfc_procesos_t a
     where a.id_proceso = 'VC';
  Exception
    when no_data_found then
      c_mail_to    := '_divisionadministraciondeincidentes@mail.tss2.gov.do';
      c_mail_error := '_divisionadministraciondeincidentes@mail.tss2.gov.do';
  End;  

end ars_validaciones_pkg;
