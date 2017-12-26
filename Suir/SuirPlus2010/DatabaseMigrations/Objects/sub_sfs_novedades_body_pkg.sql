CREATE OR REPLACE PACKAGE BODY SUIRPLUS.SUB_SFS_NOVEDADES is

  v_dias_calendario_enf Integer := 60;
  v_nro_solicitud       suirplus.sub_solicitud_t.nro_solicitud%type;
  v_nro_secuencia       suirplus.sub_solicitud_t.secuencia%type;

FUNCTION NominaActivaTrabajador(p_id_nss               IN SRE_CIUDADANOS_T.Id_Nss%TYPE,
                                p_id_registro_patronal IN Sre_Trabajadores_t.Id_Registro_Patronal%TYPE,
                                p_fecha in date)
  RETURN NUMBER IS
  v_nomina     NUMBER(6);
  v_Periodo    sfc_facturas_t.periodo_factura%Type;
  v_PeriodoVig sfc_facturas_t.periodo_factura%Type;
BEGIN

  v_Periodo    := Suirplus.Parm.Periodo_Vigente(p_fecha);
  v_PeriodoVig := Suirplus.Parm.Periodo_Vigente(sysdate);

  if (v_PeriodoVig = v_Periodo) then
    --- Si la licencia es para el mes vigente debe estar en nomina y haber ingresado antes de la licencia.
    --Buscar nomina activa del trabajador, o la nomina en donde obtenga el mayor salario,
    --o la nomina de menor numero secuencial
    select id_nomina
      into v_nomina
      from (Select id_nomina, r.salario_ss
              from sre_trabajadores_t r
             where r.id_nss = p_id_nss
               and r.id_registro_patronal = p_id_registro_patronal
               and status = 'A'
             order by r.salario_ss desc, r.id_nomina asc) a
     where rownum < 2;

  elsif (v_PeriodoVig > v_Periodo) then
    --- Si la licencia es retroactiva se verifica que este en una N.P.
    Begin
      select f.id_nomina
        into v_nomina
        from sfc_facturas_t f
        join sfc_det_facturas_t d on f.id_referencia = d.id_referencia
       where d.id_nss = p_id_nss
         and f.status = 'PA'
         and f.tipo_nomina <> 'U'
         and f.id_registro_patronal = p_id_registro_patronal
         and f.periodo_factura =
             to_Char(To_Date(v_Periodo, 'YYYYMM'), 'YYYYMM')
         and rownum < 2;
    Exception when no_data_found then
      Begin
        select f.id_nomina
          into v_nomina
          from sfc_facturas_t f
          join sfc_det_facturas_t d on f.id_referencia = d.id_referencia
         where d.id_nss = p_id_nss
           and f.status = 'PA'
           and f.tipo_nomina <> 'U'
           and f.id_registro_patronal = p_id_registro_patronal
           and f.periodo_factura =
               to_Char(Add_Months(To_Date(v_Periodo, 'YYYYMM'),-1), 'YYYYMM')
           and rownum < 2;
      Exception when no_data_found then     
        Begin
          select f.id_nomina
            into v_nomina
            from sfc_facturas_t f
            join sfc_det_facturas_t d on f.id_referencia = d.id_referencia
           where d.id_nss = p_id_nss
             and f.status = 'PA'
             and f.tipo_nomina <> 'U'
             and f.id_registro_patronal = p_id_registro_patronal
             and f.periodo_factura =
                 to_Char(Add_Months(To_Date(v_Periodo, 'YYYYMM'),-2), 'YYYYMM')
             and rownum < 2;
        Exception when no_data_found then     
          v_nomina := 0;  
        End;          
      End;  
   End;     

  elsif (v_PeriodoVig < v_Periodo) then
    --- Es Futura!!!!!
    --Buscar nomina activa del trabajador, o la nomina en donde obtenga el mayor salario,
    --o la nomina de menor numero secuencial
    select id_nomina
      into v_nomina
      from (Select id_nomina, r.salario_ss
              from sre_trabajadores_t r
             where r.id_nss = p_id_nss
               and r.id_registro_patronal = p_id_registro_patronal
               and status = 'A'
             order by r.salario_ss desc, r.id_nomina asc) a
     where rownum < 2;
  end if;

  RETURN v_nomina;

exception
  when no_data_found THEN
    v_nomina := 0;
    
    Insert into suirplus.sub_log_t
        (
         id_log,
         fecha,
         id_solicitud,
         mensaje
        )
        values
        (
         suirplus.sub_log_seq.nextval,
         sysdate,
         0,
         'NOMINA TRABAJADOR'||chr(13)||chr(10)||
         'ID_NSS: '||p_id_NSS||chr(13)||chr(10)||
         'REGISTRO PATRONAL: '||p_id_registro_patronal||chr(13)||chr(10)||
         'FECHA: '||p_fecha||chr(13)||chr(10)||
         'PERIODO: '||v_Periodo||chr(13)||chr(10)||
         'PERIODOVIGENTE: '||v_PeriodoVig
         );
        commit;

    RETURN v_nomina;

END;

Procedure EliminarLactancia(p_nroSolicitud in number,
                            p_RESULTNUMBER OUT VARCHAR2) is
  v_bd_error VARCHAR2(1000);
begin

  delete from suirplus.sub_lactantes_t l
   where l.nro_solicitud = p_nroSolicitud;

  delete from sisalril_suir.sfs_lactantes_t la
   where la.nro_solicitud = p_nroSolicitud;

  delete from suirplus.sub_elegibles_t e
   where e.nro_solicitud = p_nroSolicitud;

  delete from sisalril_suir.sfs_elegibles_t ef
   where ef.nro_solicitud = p_nroSolicitud;

  delete from suirplus.sub_sfs_lactancia_t f
   where f.nro_solicitud = p_nroSolicitud;

  delete from suirplus.sub_solicitud_t s
   where s.nro_solicitud = p_nroSolicitud;

  commit;

Exception
  When Others Then
    v_bd_error     := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                              SQLERRM,
                              1,
                              255));
    p_resultNumber := Seg_Retornar_Cadena_Error(-1, v_bd_error, SQLCODE);
  
end EliminarLactancia;

  -- Refactored procedure ExisteMuerteMadre
  function existeLicencia(p_nroSolicitud         in sub_solicitud_t.nro_solicitud%type,
                          p_id_resgitro_patronal in sre_empleadores_t.id_registro_patronal%type)
    return boolean is
    v_count INTEGER := 0;
  begin

    select count(*)
      into v_count
      from sub_sfs_maternidad_t m
     where m.nro_solicitud = p_nroSolicitud
       and m.id_registro_patronal = p_id_resgitro_patronal
       and m.id_estatus in (1, 2, 4,6,7,8,9);

    if (v_count = 0) then
      --Puede hacer RL
      return false;
    end if;

    return true;

  end existeLicencia;

  -- Refactored procedure ExisteMuerteMadre
  function existeMuerteMadre(p_nroSolicitud in number) return boolean is
    v_count INTEGER := 0;
  begin

    select count(*)
      into v_count
      from sub_solicitud_t s
      join sub_maternidad_t m
        on s.nro_solicitud = m.nro_solicitud
     where s.nro_solicitud = p_nroSolicitud
       and m.fecha_registro_mm is not null
       and m.id_registro_patronal_mm is not null
       and m.usuario_mm is not null
       and m.estatus = 'IC';

    if (v_count = 0) then
      --Puede hacer MM
      return false;
    end if;

    return true;

  end ExisteMuerteMadre;

  -- Refactored procedure existePerdidaLactante
  function existeLactante(p_nroSolicitud in number) return boolean is
    v_muertos   INTEGER;
    v_lactantes INTEGER;
  begin

    Begin
      --El nro de solicitud pasado en el parametro es de maternidad
      --Por eso vamos al subsidio de maternidad para obtener el nro de solicitud de lactancia
      select count(l.id_lactante), sum(decode(l.estatus, 'FA', 1, 0))
        into v_lactantes, v_muertos
        from sub_solicitud_t s
        join sub_sfs_lactancia_t sl
          on sl.nro_solicitud_mat = s.nro_solicitud
         and sl.id_estatus != 3
        join sub_lactantes_t l
          on l.nro_solicitud = sl.nro_solicitud
          and l.estatus = 'AC'
       where s.nro_solicitud = p_nroSolicitud;
    Exception
      When No_Data_Found Then
        v_lactantes := 1;
        v_muertos   := 0;
    End;

    if (v_lactantes > v_muertos) then
      --Puede hacer ML
      return true;
    end if;

    return false;

  end ExisteLactante;

  -- Refactored procedure existePerdidaEmbarazo
  function existePerdidaEmbarazo(p_nroSolicitud in number) return boolean is
    v_count INTEGER := 0;
  begin

    select count(*)
      into v_count
      from sub_solicitud_t s
      join sub_maternidad_t m
        on s.nro_solicitud = m.nro_solicitud
       and m.fecha_registro_pe is not null
       and m.id_registro_patronal_pe is not null
       and m.usuario_pe is not null
       and m.estatus = 'IN'
     where s.nro_solicitud = p_nroSolicitud;

    if (v_count = 0) then
      --Puede hacer PE
      return false;
    end if;

    return true;

  end existePerdidaEmbarazo;

  function existeNacimiento(p_nroSolicitud in number) return boolean is
    v_count INTEGER := 0;
  begin

    select count(*)
      into v_count
      from sub_solicitud_t s
      join sub_sfs_lactancia_t sl
        on sl.nro_solicitud_mat = s.nro_solicitud
      join sub_lactantes_t l
        on l.nro_solicitud = sl.nro_solicitud
     where s.nro_solicitud = p_nroSolicitud
       and s.tipo_subsidio = 'M';

    if (v_count = 0) then
      --Puede hacer RN
      return false;
    end if;

    return true;

  end existeNacimiento;

  function getMontoSubsidioMaternidad(Salario          in sub_elegibles_t.salario_cotizable%type,
                                      p_fecha_subsidio sub_sfs_maternidad_t.fecha_licencia%type)
    return sub_elegibles_t.salario_cotizable%type is

    v_Tope             sub_elegibles_t.salario_cotizable%type;
    v_periodo_subsidio sub_cuotas_t.periodo%type;
    v_param            suirplus.Parm;
  Begin

    --determinar el periodo vigente de la fecha de nacimiento--
    --FR 2010-02-23--
    v_periodo_subsidio := Suirplus.Parm.periodo_vigente(p_fecha_subsidio);

    --Determinar el salario minimo nacional a partir del constructor--
    --FR 2010-02-23--
    v_param := SUIRPLUS.Parm(v_periodo_subsidio);

    --Obtener el salario minimoc nacional--
    --FR 2010-02-23--

    v_Tope := v_param.sfs_salario_tope;

    if Salario > v_Tope then
      return v_Tope;
    else
      return Salario;
    end if;

  end;

  ---------------------------------------------------------------
  -- Devuelve el NSS en base a un Documento
  ---------------------------------------------------------------
  Function getNSS(NroDocumento IN SRE_CIUDADANOS_T.NO_DOCUMENTO%TYPE)
    return sre_ciudadanos_t.id_nss%type is
    v_NSS sre_ciudadanos_t.id_nss%type;
  Begin
    SELECT u.id_nss
      into v_NSS
      FROM sre_ciudadanos_t u
     WHERE no_documento = NroDocumento;
    RETURN v_NSS;
  Exception when others then
    RETURN NULL;
  End;

  ---------------------------------------------------------------
  -- Devuelve los datos de un m?dico
  ---------------------------------------------------------------
  PROCEDURE GetMedico(P_CEDULA_MED   IN SFS_MEDICOS_T.CEDULA%TYPE,
                      p_resultnumber OUT VARCHAR2,
                      p_io_cursor    OUT T_CURSOR) IS

    E_EXISTE_MEDICO EXCEPTION;
    v_cursor T_CURSOR;
  BEGIN
    OPEN V_CURSOR FOR
    --Heidi
    --Gregorio - quitar obligatoriedad con la tabla de medicos, poner CASE para los campos cedula y NSS
      SELECT M.PRESTADORA_NUMERO NRO_MEDICO,
             RTRIM(LTRIM(C.NOMBRES)) || ' ' ||
             RTRIM(LTRIM(C.PRIMER_APELLIDO)) || ' ' ||
             RTRIM(LTRIM(C.SEGUNDO_APELLIDO)) NOMBRES_MED,
             (CASE
               WHEN M.CEDULA IS NULL THEN
                C.NO_DOCUMENTO
               ELSE
                M.CEDULA
             END) CEDULA_MED,
             (CASE
               WHEN M.ID_NSS IS NULL THEN
                C.ID_NSS
               ELSE
                M.ID_NSS
             END) IDNSS_MED,
             M.TELEFONO TEL_MED,
             M.CELULAR CEL_MED,
             M.DIRECCION DIR_MED
        FROM SUIRPLUS.SRE_CIUDADANOS_T C
        LEFT JOIN SUIRPLUS.SFS_MEDICOS_T M
          ON M.CEDULA = C.NO_DOCUMENTO
         AND M.ID_NSS = C.ID_NSS
       WHERE C.NO_DOCUMENTO = P_CEDULA_MED;
    p_resultnumber := 0;
    p_io_cursor    := v_cursor;
  EXCEPTION
    when E_EXISTE_MEDICO then
      p_resultnumber := Seg_Retornar_Cadena_Error(55, NULL, NULL);
  END;

  ---------------------------------------------------------
  --Genera un numero Random de 4 posiciones
  ---------------------------------------------------------
  FUNCTION getPIN RETURN NUMBER IS
  BEGIN
    return rpad(abs(substr(dbms_random.random, 1, 4)), 4, '0');
  END;

  ---------------------------------------------------------
  --verifica que el pin no exista en la enfermedad comun
  ---------------------------------------------------------
  FUNCTION verificarPin(p_pin in sub_enfermedad_comun_t.pin%type,
                        p_id_nss in sre_ciudadanos_t.id_nss%type
                        ) RETURN Boolean IS
    v_count integer;
  BEGIN
      /*Verificamos si el pin generado ya existe en la tabla de enfermedad comun*/
     select count(*)
       into v_count
       from sub_enfermedad_comun_t e
       join sub_solicitud_t s on s.nro_solicitud = e.nro_solicitud
                             and s.nss = p_id_nss
      where e.pin = p_Pin; 
    
    if v_count > 0 then
       return true;
    else
        return false;      
    end if;   
   
  END;

  function getCategoriaSalario(p_id_nss               in sre_ciudadanos_t.id_nss%type,
                               p_id_registro_patronal in sub_elegibles_t.registro_patronal%TYPE,
                               p_TipoSubsidio         in sub_solicitud_t.tipo_subsidio%TYPE,
                               SalarioCotizable       out sub_elegibles_t.salario_cotizable%TYPE,
                               p_fecha_subsidio       in sub_sfs_maternidad_t.fecha_licencia%type)
    return sub_elegibles_t.categoria_salario%type is

    v_cat               sub_elegibles_t.categoria_salario%TYPE := 0;
    V_SALARIO_COTIZABLE sub_elegibles_t.salario_cotizable%TYPE := 0;
    v_smn               sub_elegibles_t.salario_cotizable%TYPE := 0;
  Begin

    -- Buscar en las Facturas Pagadas del Periodo Actual, el Salario Cotizable
    Select sum(df.salario_ss)
      into V_SALARIO_COTIZABLE
      from sfc_det_facturas_t df
      join sfc_facturas_t f
        on f.id_referencia = df.id_referencia
       and f.id_tipo_factura != 'U'
       and f.status = 'PA'
       and f.periodo_factura =
           (select suirplus.parm.periodo_vigente(p_fecha_subsidio) from dual)
     where df.id_nss = p_id_nss
       and ((p_TipoSubsidio = 'M' and
           f.id_registro_patronal = p_id_registro_patronal) -- Maternidad
           or (p_TipoSubsidio = 'L') -- Lactancia
           );

    V_SALARIO_COTIZABLE := NVL(V_SALARIO_COTIZABLE, 0);

    -- Si no lo encontr?, buscar en el Periodo Anterior
    if (V_SALARIO_COTIZABLE = 0) Then
      -- Periodo Anterior
      Select sum(df.salario_ss)
        into V_SALARIO_COTIZABLE
        from sfc_det_facturas_t df
        join sfc_facturas_t f
          on f.id_referencia = df.id_referencia
         and f.id_tipo_factura != 'U'
         and f.status = 'PA'
         and f.periodo_factura = (select suirplus.parm.periodo_vigente(add_months(p_fecha_subsidio,
                                                                                  -1))
                                    from dual)
       where df.id_nss = p_id_nss
         and ((p_TipoSubsidio = 'M' and
             f.id_registro_patronal = p_id_registro_patronal) -- Maternidad
             or (p_TipoSubsidio = 'L') -- Lactancia
             );
    End if;

    V_SALARIO_COTIZABLE := NVL(V_SALARIO_COTIZABLE, 0);

    -- Si no lo encontr?, buscar en Trabajadores
    if (V_SALARIO_COTIZABLE = 0) Then

      -- Calcular segun el Tipo de Subsidio
      if (p_TipoSubsidio = 'L') then
        SELECT SUM(T.SALARIO_SS)
          INTO V_SALARIO_COTIZABLE
          FROM SRE_TRABAJADORES_T T
          JOIN SRE_NOMINAS_T N
            ON T.ID_REGISTRO_PATRONAL = N.ID_REGISTRO_PATRONAL
           AND T.ID_NOMINA = N.ID_NOMINA
         WHERE N.STATUS = 'A'
           AND T.Status = 'A'
           AND T.ID_NSS = p_id_nss
           and n.tipo_nomina <> 'P';

      Else
        SELECT SUM(T.SALARIO_SS)
          INTO V_SALARIO_COTIZABLE
          FROM SRE_TRABAJADORES_T T
          JOIN SRE_NOMINAS_T N
            ON T.ID_REGISTRO_PATRONAL = N.ID_REGISTRO_PATRONAL
           AND T.ID_NOMINA = N.ID_NOMINA
         WHERE N.ID_REGISTRO_PATRONAL = p_id_registro_patronal
           AND T.STATUS = 'A'
           AND T.ID_NSS = p_id_nss;

      End if;
    End if;

    V_SALARIO_COTIZABLE := NVL(V_SALARIO_COTIZABLE, 0);

    V_SALARIO_COTIZABLE := getMontoSubsidioMaternidad(V_SALARIO_COTIZABLE,
                                                      p_fecha_subsidio);

    SalarioCotizable := V_SALARIO_COTIZABLE;

    -- Si es LActancia determinar Categoria
    If (p_TipoSubsidio = 'L') then
      --Para buscar el salario minimo nacional vigente para la fecha del subsidio
      Begin
        Select valor_numerico
          into v_smn
          from suirplus.sfc_det_parametro_t x
         where id_parametro = 97
           and trunc(p_fecha_subsidio) between trunc(x.fecha_ini) and
               nvl(x.fecha_fin, trunc(sysdate + 1));
      Exception
        when others then
          v_smn := 0;
      End;

      if (V_SALARIO_COTIZABLE > (v_smn * 3)) then
        v_cat := 0;
      end if;

      if (V_SALARIO_COTIZABLE <= (v_smn)) then
        v_cat := 3;
      end if;

      if (V_SALARIO_COTIZABLE > v_smn) and
         (V_SALARIO_COTIZABLE <= (v_smn * 2)) then
        v_cat := 2;
      end if;

      if (V_SALARIO_COTIZABLE > (v_smn * 2)) and
         (V_SALARIO_COTIZABLE <= (v_smn * 3)) then
        v_cat := 1;
      end if;

    End if;

    return v_cat;

  End;

  function MenorInicioSubsidios(Fecha in date) return boolean is

    v_FechaInicio date;

  Begin

    Select d.valor_fecha
      into v_FechaInicio
      from sfc_det_parametro_t d
     where d.id_parametro = 111 -- Incio de Subsidios--
       and d.fecha_fin is null;

    if Fecha < v_FechaInicio then
      return true;
    end if;

    return false;

  End;

  ----------------------------------------------------------------------------------------
  --- Metodo que devuelve las opciones del menu que el empleador puede acceder
  ----------------------------------------------------------------------------------------

  procedure getOpcionesMenu(p_idnss              sre_ciudadanos_t.id_nss%type,
                            p_idregistropatronal sre_empleadores_t.id_registro_patronal%type,
                            p_resultnumber       out varchar2,
                            p_iocursor           IN OUT t_cursor) is
    v_select             varchar2(8000) := null;
    v_bd_error           VARCHAR2(1000);
    v_nroSolicitud       number(10);
    v_Completo           Boolean;
    v_count              number(10) := 0;
    v_countLicencia      number(10) := 0;
    v_idregpatronal      sre_empleadores_t.id_registro_patronal%type;
    v_Embarazo           varchar2(500) := ', 1 Orden, ''Registro Embarazo'' TipoNovedad, ''Usuario'' Descripcion, ''RegistroEmbarazo.htm'' Url from dual';
    v_Licencia           varchar2(500) := ', 2 Orden, ''Reporte Licencia'' TipoNovedad, ''Usuario'' Descripcion, ''InicioReporteLicencia.htm'' Url from dual';
    v_LicenciaSecundario varchar2(500) := ', 3 Orden, ''Reporte Licencia'' TipoNovedad, ''Usuario'' Descripcion, ''ReporteLicencia.htm'' Url from dual';
    v_PerdidaEmbarazo    varchar2(500) := ', 5 Orden, ''Perdida Embarazo'' TipoNovedad, ''Usuario'' Descripcion, ''ReportePerdida.htm'' Url from dual';
    v_MuerteMadre        varchar2(500) := ', 6 Orden, ''Muerte Madre'' TipoNovedad, ''Usuario'' Descripcion, ''ReporteMuerteMadre.htm'' Url from dual';
    v_Nacimiento         varchar2(500) := ', 4 Orden, ''Reporte Nacimiento'' TipoNovedad, ''Usuario'' Descripcion, ''ReporteNacimiento.htm'' Url from dual';
    v_MuerteLactante     varchar2(500) := ', 7 Orden, ''Muerte Lactante'' TipoNovedad, ''Usuario'' Descripcion, ''ReporteMuerteLactante.aspx?nssMadre=' ||
                                          p_idnss || ''' Url from dual';
  begin

  --Verificar que no tiene rechazado
   select count(*)
     into v_count
     from sub_solicitud_t s
     join sub_sfs_maternidad_t m
       on m.nro_solicitud = s.nro_solicitud
       where s.nss = p_idnss
      and m.id_registro_patronal = p_idregistropatronal
      and m.id_estatus = 3
      and s.nro_solicitud =
          (select max(x.nro_solicitud)
             from sub_solicitud_t x
            where x.nss = s.nss
              and x.tipo_subsidio = s.tipo_subsidio);
  


   if v_count = 0 then

     --Verificar si tiene un embarazo pendiente de aprobacion
    select count(*)
      into v_count
      from sub_solicitud_t s
      join sub_sfs_maternidad_t m
        on m.nro_solicitud = s.nro_solicitud
       and m.id_estatus in(1,6,7,8,9)
     where s.nss = p_idnss;


    if v_count = 0 then
      --Verificar si esta madre tiene una solicitud de embarazo activa
      v_nroSolicitud := 0;
      v_Completo     := True;

      For R IN (select s.nro_solicitud, m.id_registro_patronal_re
                  from sub_solicitud_t s
                  join sub_maternidad_t m
                    on m.nro_solicitud = s.nro_solicitud
                 where s.nss = p_idnss
                   and s.tipo_subsidio = 'M'
                   and m.estatus = 'AC' order by s.nro_solicitud desc) Loop

        v_nroSolicitud  := r.nro_solicitud;
        v_idregpatronal := r.id_registro_patronal_re;

        --Si tiene la perdida del embarazo o el registro de nacimiento, procede un nuevo embarazo
        If (existePerdidaEmbarazo(r.nro_solicitud) or
           existeNacimiento(r.nro_solicitud)) Then
          v_Completo := True;
          exit;
        else
          v_Completo := False;
          exit;
        End if;
      End Loop;

      If (v_nroSolicitud = 0) then
        --Solo puede registrar el embarazo a esta madre
        v_select := 'select 0 NroSolicitud, ''N'' Modificado,''N'' Completado ' ||
                    v_Embarazo;
      Elsif v_Completo then
        --Puede registrar el embarazo, muerte madre y muerte lactante a esta madre
        v_select := 'select ' || v_nroSolicitud ||
                    ' NroSolicitud, ''N'' Modificado,''N'' Completado ' ||
                    v_Embarazo;

        if (v_idregpatronal <> p_idregistropatronal) then
          If (existeLicencia(v_nroSolicitud, p_idregistropatronal)) = false then
            v_select := v_select || ' union select ' || v_nroSolicitud ||
                        ' NroSolicitud, ''N'' Modificado,''N'' Completado ' ||
                        v_LicenciaSecundario;
          end if;
        end if;

        v_select := v_select || ' union select ' || v_nroSolicitud ||
                    ' NroSolicitud, ''N'' Modificado,''N'' Completado ' ||
                    v_MuerteMadre;
        If (existeLactante(v_nroSolicitud)) then
          v_select := v_select || ' union select ' || v_nroSolicitud ||
                      ' NroSolicitud, ''N'' Modificado,''N'' Completado ' ||
                      v_MuerteLactante;
        end if;
      Else
        --Si es una empresa diferente a la registro el embarazo
        if (v_idregpatronal <> p_idregistropatronal) then
          --Puede registrar el embarazo, muerte madre y muerte lactante a esta madre
          v_select := 'select ' || v_nroSolicitud ||
                      ' NroSolicitud, ''N'' Modificado,''N'' Completado ' ||
                      v_Embarazo;

          If (existeLicencia(v_nroSolicitud, p_idregistropatronal)) = false then
            v_select := v_select || ' union select ' || v_nroSolicitud ||
                        ' NroSolicitud, ''N'' Modificado,''N'' Completado ' ||
                        v_LicenciaSecundario;
          else
            v_countLicencia := 1;
          end if;
        else
          --No puede registrar el embarazo a esta solicitud
          v_select := 'select ' || v_nroSolicitud ||
                      ' NroSolicitud, ''S'' Modificado,''S'' Completado ' ||
                      v_Embarazo;

          --Verificar si no esta registrada la licencia para esta solicitud
          If (existeLicencia(v_nroSolicitud, p_idregistropatronal)) then
            --No Puede registrar la licencia a esta solicitud
            v_select        := v_select || ' union select ' ||
                               v_nroSolicitud ||
                               ' NroSolicitud, ''S'' Modificado,''S'' Completado ' ||
                               v_Licencia;
            v_countLicencia := 1;
          Else

            --No puede registrarle licencia a esta solicitud
            v_select := v_select || ' union select ' || v_nroSolicitud ||
                        ' NroSolicitud, ''N'' Modificado,''N'' Completado ' ||
                        v_Licencia;
          End if;

        end if;

        if (v_countLicencia = 1) then

          --Verificar si no esta registrado el nacimiento para esta solicitud
          If (existeNacimiento(v_nroSolicitud)) then
            -- No puede registrase el naciemiento para esta solicitud
            v_select := v_select || ' union select ' || v_nroSolicitud ||
                        ' NroSolicitud, ''S'' Modificado,''S'' Completado ' ||
                        v_Nacimiento;

            --Verificar si queda algun lactante por registrar como muerto
            If (existeLactante(v_nroSolicitud)) then
              --No puede registrase la muerte del lactante para esta solicitud
              v_select := v_select || ' union select ' || v_nroSolicitud ||
                          ' NroSolicitud, ''S'' Modificado,''S'' Completado ' ||
                          v_MuerteLactante;
            Else
              --Puede registrase la muerte del lactante para esta solicitud
              v_select := v_select || ' union select ' || v_nroSolicitud ||
                          ' NroSolicitud, ''N'' Modificado,''N'' Completado ' ||
                          v_MuerteLactante;
            End if;

            --Con el valor de esta variable determinamos si el embarazo lleg? a su final, el ni?o naci?.
            v_count := 1;
          Else
            --Puede registrase el naciemiento para esta solicitud
            v_select := v_select || ' union select ' || v_nroSolicitud ||
                        ' NroSolicitud, ''N'' Modificado,''N'' Completado ' ||
                        v_Nacimiento;
          End if;
        end if;
        If (v_count = 0) then
          --Verificar si esta solicitud no tiene registrada la perdida del embarazo
          If existePerdidaEmbarazo(v_nroSolicitud) then
            --Puede registrar la perdida del embarazo para esta solicitud
            v_select := 'select ' || v_nroSolicitud ||
                        ' NroSolicitud, ''N'' Modificado,''N'' Completado ' ||
                        v_Embarazo;
          Else
            v_select := v_select || ' union select ' || v_nroSolicitud ||
                        ' NroSolicitud, ''N'' Modificado,''N'' Completado ' ||
                        v_PerdidaEmbarazo;
          End if;
        End if;

        --Verificar si esta solicitud tiene registrada la muerte de la madre
        If existeMuerteMadre(v_nroSolicitud) then
          --Puede registrar la muerte de la madre para esta solicitud
          v_select := 'select ' || v_nroSolicitud ||
                      ' NroSolicitud, ''N'' Modificado,''N'' Completado ' ||
                      v_Embarazo;
        Else
          v_select := v_select || ' union select ' || v_nroSolicitud ||
                      ' NroSolicitud, ''N'' Modificado,''N'' Completado ' ||
                      v_MuerteMadre;
        End if;
      End if;
    else
       If v_select is null Then
        v_select := 'select 0 NroSolicitud,''N'' Modificado,''N'' Completado, 1 Orden, ''No puede realizar ningún registro por que tiene una solicitud pendiente, debe esperar que sea aprobada por la SISALRIL'' TipoNovedad, ''Usuario'' Descripcion, '''' Url from dual';

      end if;

    end if;

  else
    
       select count(*)
         into v_count
         from sub_solicitud_t s
         join sub_sfs_maternidad_t m
           on m.nro_solicitud = s.nro_solicitud
          and m.id_registro_patronal = p_idregistropatronal
         join suirplus.sub_elegibles_t e
           on e.nro_solicitud = m.nro_solicitud
          and e.registro_patronal = m.id_registro_patronal
        where s.nss = p_idnss
          and s.nro_solicitud =
              (select max(nro_solicitud)
                 from sub_solicitud_t x
                where x.nss = s.nss
                  and x.tipo_subsidio = s.tipo_subsidio)
          and e.id_elegibles =
              (select max(id_elegibles)
                 from suirplus.sub_elegibles_t x
                where x.nro_solicitud = e.nro_solicitud
                  and x.registro_patronal = e.registro_patronal)
          and e.error in (select ID_ERROR
                            from sub_errores_sisalril_t
                           where definitivo = 'S');
       
       if v_count > 0 then
         --Solo puede registrar el embarazo a esta madre
         v_select := 'select 0 NroSolicitud, ''N'' Modificado,''N'' Completado ' ||
                     v_Embarazo;
       else
         If v_select is null Then
           v_select := 'select 0 NroSolicitud,''N'' Modificado,''N'' Completado, 1 Orden, ''Esta solicitud fue rechazada debe realizar una reconsideración'' TipoNovedad, ''Usuario'' Descripcion, '''' Url from dual';
         end if;
       end if;
  end if;

   v_select := v_select || ' order by Orden';


    open p_iocursor for v_select;
    p_resultnumber := '0';
  exception

    WHEN OTHERS THEN
      v_bd_error     := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultNumber := Seg_Retornar_Cadena_Error(-1, v_bd_error, SQLCODE);
      RETURN;

  end;

  ----------------------------------------------------------------------------------------
  --- Metodo que devuelve las opciones del menu que el empleador puede acceder para E. C.
  ----------------------------------------------------------------------------------------
  procedure getOpcionesMenuEC(p_idnss              sre_ciudadanos_t.id_nss%type,
                              p_idregistropatronal sre_empleadores_t.id_registro_patronal%type,
                              p_resultnumber       out varchar2,
                              p_iocursor           IN OUT t_cursor) is
    v_select   varchar2(8000) := null;
    v_bd_error VARCHAR2(1000);
    v_Conteo   Integer;

    v_Registrar  varchar2(500) := ', 1 Orden, ''Registrar Padecimiento'' Descripcion, ''NuevoPadecimiento.htm'' Url from dual';
    v_completar  varchar2(500) := ', 2 Orden, ''Completar Padecimiento'' Descripcion, ''CompletarDatos.htm'' Url from dual';
    v_Renovar    varchar2(500) := ', 3 Orden, ''Renovar Padecimiento'' Descripcion, ''RenovarPadecimiento.htm'' Url from dual';
    v_Reintegro  varchar2(500) := ', 4 Orden, ''Reintegrar Padecimiento'' Descripcion, ''Reintegro.htm'' Url from dual';
    v_Convalidar varchar2(500) := ', 5 Orden, ''Convalidar Padecimiento'' Descripcion, ''ConvalidarPadecimiento.htm'' Url from dual';
  begin
    
  
  --Verificar que no tiene rechazado
   select count(*)
     into v_conteo
     From sub_solicitud_t s
     Join sub_sfs_enf_comun_t e
       on e.nro_solicitud = s.nro_solicitud
    where s.nss = p_idnss
      and e.id_registro_patronal = p_idregistropatronal
      and e.id_estatus = 3
      and s.nro_solicitud =
          (select max(x.nro_solicitud)
             from sub_solicitud_t x
            where x.nss = s.nss
              and x.tipo_subsidio = s.tipo_subsidio);
  
  if v_conteo = 0 then
       --Para saber si puede registrar padecimiento
    Select count(*)
      Into v_conteo
      From sub_solicitud_t s
      Join sub_enfermedad_comun_t e
        On e.nro_solicitud = s.nro_solicitud
       And Nvl(upper(e.completado), 'N') = 'S'
       And e.estatus = 'AC'
      Join sub_sfs_enf_comun_t ef
        On ef.nro_solicitud = s.nro_solicitud
       And ef.id_estatus not in (2, 3, 4, 5, 11, 13)
     Where s.nss = p_idnss
       And s.tipo_subsidio = 'E';

    If v_conteo > 0 Then

      Select count(*)
        Into v_conteo
        From sub_solicitud_t s
        Join sub_enfermedad_comun_t e
          On e.nro_solicitud = s.nro_solicitud
         And Nvl(upper(e.completado), 'N') = 'S'
         And e.estatus = 'AC'
        Join sub_sfs_enf_comun_t ef
          On ef.nro_solicitud = s.nro_solicitud
         And ef.id_estatus in (1, 6, 7, 8) --Se agregaron los estatus EV,EC,PD que estos son estatus pendientes.
         And ef.id_registro_patronal = p_idregistropatronal
       Where s.nss = p_idnss
         And s.tipo_subsidio = 'E';

      If v_conteo = 0 Then

        If v_select is null Then
          v_select := 'select 0 NroSolicitud, ''N'' Modificado, ''N'' Completado ' ||
                      v_Registrar;
        Else
          v_select := v_select ||
                      ' union select 0 NroSolicitud, ''N'' Modificado,''N'' Completado ' ||
                      v_Registrar;
        End if;
      end if;
    Else
      Select count(*)
        Into v_conteo
        From sub_solicitud_t s
        Join sub_enfermedad_comun_t e
          on e.nro_solicitud = s.nro_solicitud
       Where s.nss = p_idnss
         And s.tipo_subsidio = 'E'
         And Nvl(upper(e.completado), 'N') = 'N'
         And e.estatus = 'AC';

      If v_conteo = 0 Then
        If v_select is null Then
          v_select := 'select 0 NroSolicitud, ''N'' Modificado, ''N'' Completado ' ||
                      v_Registrar;
        Else
          v_select := v_select ||
                      ' union select 0 NroSolicitud, ''N'' Modificado,''N'' Completado ' ||
                      v_Registrar;
        End if;
      End if;
    End if;

    --Para saber si puede completar padecimiento
    Select Nvl(Min(s.nro_solicitud), 0)
      Into v_conteo
      From sub_solicitud_t s
      Join sub_enfermedad_comun_t e
        On e.nro_solicitud = s.nro_solicitud
       And Nvl(upper(e.completado), 'N') = 'N' And e.estatus = 'AC'
     Where s.nss = p_idnss
       And s.tipo_subsidio = 'E';

    If v_conteo > 0 Then
      --Tiene solicitudes pendientes, solo puede completar
      If v_select is null Then
        v_select := 'select ' || v_conteo ||
                    ' NroSolicitud, ''N'' Modificado, ''N'' Completado ' ||
                    v_completar;
      Else
        v_select := v_select || ' union select ' || v_conteo ||
                    ' NroSolicitud, ''N'' Modificado,''N'' Completado ' ||
                    v_completar;
      End if;
    End if;

    --Para saber si puede renovar padecimiento
    Select count(*)
      into v_conteo
      From sub_solicitud_t s
      Join sub_enfermedad_comun_t e
        On e.nro_solicitud = s.nro_solicitud
       And e.completado = 'S' -- Debe estar Completado en sub_enfermedad_comun_t
       And e.estatus = 'AC'
      Join sub_sfs_enf_comun_t m
        On m.nro_solicitud = s.nro_solicitud
       And m.id_estatus in (2, 4) -- Debe estar aprobada la solicitud por la SISALRIL
       And m.id_registro_patronal = p_idregistropatronal
     Where s.nss = p_idnss
       And s.tipo_subsidio = 'E'
       And Not Exists ( -- No debe tener ningun registro en sub_enfermedad_comun_t SIN COMPLETAR
            Select 1
              From sub_solicitud_t g
              Join sub_enfermedad_comun_t f
                On f.nro_solicitud = g.nro_solicitud
               And f.completado = 'N'
               And f.estatus = 'AC'
             Where g.nss = p_idnss
               And g.tipo_subsidio = 'E')
       And Not Exists
     ( -- No debe tener ningun registro en sub_solicitud_t que no haya sido aprobado por la SISALRIL
            Select 1
              From sub_solicitud_t g
              Join sub_enfermedad_comun_t f
                On f.nro_solicitud = g.nro_solicitud
               And f.completado = 'S'
               And f.estatus = 'AC'
              Join sub_sfs_enf_comun_t m
                On m.nro_solicitud = f.nro_solicitud
               And m.id_estatus not in (2, 4, 5)
               And m.id_registro_patronal = p_idregistropatronal
             Where g.nss = p_idnss
               And g.tipo_subsidio = 'E')
       And not exists
     (select 1
              from sub_reintegro_t r
             where r.nro_solicitud = s.nro_solicitud)
       And (s.padecimiento, s.secuencia) in
           (Select padecimiento, Max(secuencia)
              From sub_solicitud_t s
              Join sub_sfs_enf_comun_t sec
                On sec.nro_solicitud = s.nro_solicitud
               And sec.id_registro_patronal = p_idregistropatronal
             Where s.nss = p_idnss
               And s.tipo_subsidio = 'E'
             Group by padecimiento);

    If v_conteo > 0 Then
      If v_select is null Then
        v_select := 'select 0 NroSolicitud, ''N'' Modificado, ''N'' Completado ' ||
                    v_Renovar;
      Else
        v_select := v_select ||
                    ' union select 0 NroSolicitud, ''N'' Modificado,''N'' Completado ' ||
                    v_Renovar;
      End if;
    End if;

    --Para saber si puede reintegrar padecimiento
    Select count(*)
      into v_conteo
      from sub_solicitud_t s
      Join sub_enfermedad_comun_t e
        On e.nro_solicitud = s.nro_solicitud
       And e.completado = 'S' -- Debe estar Completado en sub_enfermedad_comun_t
       And e.estatus = 'AC'
      Join sub_sfs_enf_comun_t m
        On m.nro_solicitud = e.nro_solicitud
       And m.id_estatus in (2, 4) -- Debe estar aprobada la solicitud por la SISALRIL
       And m.id_registro_patronal = p_idregistropatronal
     Where s.nss = p_idnss
       And s.tipo_subsidio = 'E'
       And not exists
     (select 1
              from sub_reintegro_t r
             where r.nro_solicitud = s.nro_solicitud)
       And (s.padecimiento, s.secuencia) in
           (Select padecimiento, Max(secuencia)
              From sub_solicitud_t s
              Join sub_sfs_enf_comun_t sec
                On sec.nro_solicitud = s.nro_solicitud
               And sec.id_registro_patronal = p_idregistropatronal
             Where s.nss = p_idnss
               And s.tipo_subsidio = 'E'
             Group by padecimiento);

    If v_conteo > 0 Then
      If v_select is null Then
        v_select := 'select 0 NroSolicitud, ''N'' Modificado, ''N'' Completado ' ||
                    v_Reintegro;
      Else
        v_select := v_select ||
                    ' union select 0 NroSolicitud, ''N'' Modificado,''N'' Completado ' ||
                    v_Reintegro;
      End if;
    End if;

    -- Para saber si puede convalidar un padecimiento registrado por otro Empleador
    Select count(*)
      Into v_Conteo
      From sub_solicitud_t so
      Join sub_sfs_enf_comun_t ec
        On ec.nro_solicitud = so.nro_solicitud
       And ec.id_registro_patronal != p_idregistropatronal
     Where Nss = p_idnss
       And Tipo_subsidio = 'E'
       and id_estatus in (2, 4)
       And Not Exists
     (Select 1
              From sub_solicitud_t s
              Join sub_sfs_enf_comun_t e
                On e.nro_solicitud = s.nro_solicitud
               And e.id_registro_patronal = p_idregistropatronal
             Where s.nss = so.nss
               And s.secuencia = so.secuencia
               And s.padecimiento = so.padecimiento);

    If v_conteo > 0 Then
      If v_select is null Then
        v_select := 'select 0 NroSolicitud, ''N'' Modificado, ''N'' Completado ' ||
                    v_Convalidar;
      Else
        v_select := v_select ||
                    ' union select 0 NroSolicitud, ''N'' Modificado, ''N'' Completado ' ||
                    v_Convalidar;
      End if;
    End if;

    If v_select is null Then
      v_select := 'select 0 NroSolicitud, ''N'' Modificado, ''N'' Completado, 1 Orden, ''No puede realizar ning?n registro por que tiene una solicitud pendiente, debe esperar que sea aprobada por la SISALRIL'' Descripcion, '''' Url from dual';
    else
      v_select := v_select || ' order by Orden';
    end if;
  else  
   select count(*)
         into v_Conteo
         from sub_solicitud_t s
         join sub_sfs_enf_comun_t m
           on m.nro_solicitud = s.nro_solicitud
          and m.id_registro_patronal = p_idregistropatronal
         join suirplus.sub_elegibles_t e
           on e.nro_solicitud = m.nro_solicitud
          and e.registro_patronal = m.id_registro_patronal
        where s.nss = p_idnss
          and s.nro_solicitud =
              (select max(nro_solicitud)
                 from sub_solicitud_t x
                where x.nss = s.nss
                  and x.tipo_subsidio = s.tipo_subsidio)
          and e.id_elegibles =
              (select max(id_elegibles)
                 from suirplus.sub_elegibles_t x
                where x.nro_solicitud = e.nro_solicitud
                  and x.registro_patronal = e.registro_patronal)
          and e.error in (select ID_ERROR
                            from sub_errores_sisalril_t
                           where definitivo = 'S');
       
       if v_Conteo > 0 then
        
         v_select := 'select 0 NroSolicitud, ''N'' Modificado, ''N'' Completado ' ||
                      v_Registrar;
       else
         If v_select is null Then
           v_select := 'select 0 NroSolicitud, ''N'' Modificado, ''N'' Completado, 1 Orden, ''Esta solicitud fue rechazada debe realizar una reconsideración'' Descripcion, '''' Url from dual';
         end if;
       end if;
      
  end if;
    
   
  
  

    open p_iocursor for v_select;
    p_resultnumber := '0';
  exception

    WHEN OTHERS THEN
      v_bd_error     := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultNumber := Seg_Retornar_Cadena_Error(-1, v_bd_error, SQLCODE);
      RETURN;

  end;

  ----------------------------------------------------------------------------------------
  --- Metodo crea la solicitud
  ----------------------------------------------------------------------------------------
  PROCEDURE crearSolicitud(p_NSS               IN SUB_SOLICITUD_T.NSS%type,
                           p_PADECIMIENTO      IN SUB_SOLICITUD_T.PADECIMIENTO%type,
                           p_SECUENCIA         IN SUB_SOLICITUD_T.SECUENCIA%type,
                           p_CATEGORIA_SALARIO IN SUB_SOLICITUD_T.CATEGORIA_SALARIO%type,
                           p_TIPO_SUBSIDIO     IN SUB_SOLICITUD_T.TIPO_SUBSIDIO%type,
                           p_TIPO_SOLICITUD    IN SUB_SOLICITUD_T.TIPO_SOLICITUD%type,
                           p_ID_NOMINA         IN SUB_SOLICITUD_T.ID_NOMINA%type,
                           p_NRO_SOLICITUD_MAT IN SUB_SOLICITUD_T.NRO_SOLICITUD%type,
                           p_NRO_SOLICITUD     OUT SUB_SOLICITUD_T.NRO_SOLICITUD%type,
                           p_RESULTNUMBER      OUT VARCHAR2) IS
    v_nroSolicitud INTEGER;
    v_secuencia    SUB_SOLICITUD_T.SECUENCIA%type;
  BEGIN

    --Obtener el numero de solicitud
    SELECT sub_solicitud_seq.nextval INTO v_nroSolicitud FROM dual;
    
    If p_TIPO_SUBSIDIO = 'M' Then
      --Obtener la secuencia maxima de la afiliada en maternidad
      select nvl(max(s.secuencia), 0) + 1
        into v_secuencia
        from sub_solicitud_t s
       where s.nss = p_NSS
         and s.tipo_subsidio = 'M';
    Elsif p_TIPO_SUBSIDIO = 'L' Then
      --Obtener la secuencia de la solicitud
      select s.secuencia
        into v_secuencia
        from sub_solicitud_t s
       where s.nro_solicitud = p_NRO_SOLICITUD_MAT;
    Else
      --La enfermedad comun calcula la secuencia antes de crear la solicitud
      v_secuencia := p_SECUENCIA;
    End if;
    
    --Estas variables se utilizaran para registrarla en la excepcion de registro suplicado;
    v_nro_solicitud := v_nroSolicitud;
    v_nro_secuencia := v_secuencia;
    
    INSERT INTO SUB_SOLICITUD_T
      (NRO_SOLICITUD,
       NSS,
       SECUENCIA,
       PADECIMIENTO,
       CATEGORIA_SALARIO,
       TIPO_SUBSIDIO,
       TIPO_SOLICITUD,
       ID_NOMINA,
       FECHA_REGISTRO)
    VALUES
      (v_nroSolicitud,
       p_NSS,
       v_secuencia,
       p_PADECIMIENTO,
       p_CATEGORIA_SALARIO,
       p_TIPO_SUBSIDIO,
       p_TIPO_SOLICITUD,
       p_ID_NOMINA,
       sysdate);

    --    commit;

    p_resultNumber := '0';

    p_NRO_SOLICITUD := v_nroSolicitud;
    
  END;

  ----------------------------------------------------------------------------------------
  --- Metodo crea el evento
  ----------------------------------------------------------------------------------------
  PROCEDURE crearEvento(p_NRO_SOLICITUD   IN SUB_EVENTOS_T.NRO_SOLICITUD%type,
                        p_ID_TIPO_NOVEDAD IN SUB_EVENTOS_T.ID_TIPO_NOVEDAD%type,
                        p_FECHA_EVENTO    IN SUB_EVENTOS_T.FECHA_EVENTO%type,
                        p_ULT_FECHA_ACT   IN SUB_EVENTOS_T.ULT_FECHA_ACT%type,
                        p_RESULTNUMBER    OUT VARCHAR2) IS
    v_bd_error  VARCHAR(1000);
    v_nroEvento NUMBER;

  BEGIN

    --Obtener el numero del evento
    SELECT sub_eventos_seq.nextval INTO v_nroEvento FROM dual;

    INSERT INTO SUB_EVENTOS_T
      (ID_EVENTO,
       NRO_SOLICITUD,
       ID_TIPO_NOVEDAD,
       FECHA_EVENTO,
       ULT_FECHA_ACT)
    VALUES
      (v_nroEvento,
       p_NRO_SOLICITUD,
       p_ID_TIPO_NOVEDAD,
       p_FECHA_EVENTO,
       p_ULT_FECHA_ACT);

    p_resultNumber := '0';

  exception
    WHEN OTHERS THEN
      v_bd_error     := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultNumber := Seg_Retornar_Cadena_Error(-1, v_bd_error, SQLCODE);
      RETURN;

  END;

  PROCEDURE crearElegible(p_NRO_SOLICITUD     IN SUB_ELEGIBLES_T.NRO_SOLICITUD%type,
                          p_REGISTRO_PATRONAL IN SUB_ELEGIBLES_T.REGISTRO_PATRONAL%type,
                          p_SALARIO_COTIZABLE IN SUB_ELEGIBLES_T.SALARIO_COTIZABLE%type,
                          p_ESTATUS           IN SUB_ELEGIBLES_T.ID_ESTATUS%type,
                          p_CATEGORIA_SALARIO IN SUB_ELEGIBLES_T.CATEGORIA_SALARIO%type,
                          p_ID_NSS            in sub_solicitud_t.nss%type,
                          p_SECUENCIA         in sub_solicitud_t.secuencia%type,
                          P_ID_SUB_MATERNIDAD in sub_sfs_maternidad_t.id_sub_maternidad%type,
                          P_MODO              IN VARCHAR2,
                          P_FECHA             IN DATE,
                          p_RESULTNUMBER      OUT VARCHAR2) IS
    v_bd_error      VARCHAR2(1000);
    v_elegible      NUMBER;
    v_tipo_subsidio suirplus.sub_solicitud_t.tipo_subsidio%type;
    v_padecimiento  suirplus.sub_solicitud_t.padecimiento%type;
    v_nro_lote      sub_elegibles_t.nro_lote%type;
    v_nomina        sub_elegibles_t.id_nomina%type;
  BEGIN

    --Obtener el numero del elegible
    SELECT sub_elegibles_seq.nextval INTO v_elegible FROM dual;

    --Obtener el numero de lote para el elegible
    --SELECT sub_numero_lote_seq.nextval INTO v_nro_lote FROM dual;
    SELECT TO_NUMBER(TO_CHAR(SYSDATE, 'YYYYMMDD'))
      INTO v_nro_lote
      FROM dual;

    v_nomina := NominaActivaTrabajador(p_ID_NSS, p_REGISTRO_PATRONAL,P_FECHA);

    INSERT INTO SUB_ELEGIBLES_T
      (ID_ELEGIBLES,
       NRO_SOLICITUD,
       REGISTRO_PATRONAL,
       SALARIO_COTIZABLE,
       ULT_FECHA_ACT,
       FECHA_ENVIO,
       FECHA_REGISTRO,
       ID_ESTATUS,
       CATEGORIA_SALARIO,
       NRO_LOTE,
       TIPO,
       ID_NOMINA)
    VALUES
      (v_elegible,
       p_NRO_SOLICITUD,
       p_REGISTRO_PATRONAL,
       NVL(p_SALARIO_COTIZABLE, 0),
       sysdate,
       sysdate,
       sysdate,
       p_ESTATUS,
       p_CATEGORIA_SALARIO,
       v_nro_lote,
       decode(upper(P_MODO),'N','O',upper(P_MODO)),
       v_nomina);

    --Buscando el tipo de subsidio desde la solicitud antes de pasar el elegible a SISALRIL
    select s.tipo_subsidio, s.padecimiento
      into v_tipo_subsidio, v_padecimiento
      from sub_solicitud_t s
     where s.nro_solicitud = p_NRO_SOLICITUD;

    ---Insertar SISARIL
    insert into sisalril_suir.sfs_elegibles_t
      (id_registro_patronal,
       id_nss,
       secuencia,
       padecimiento,
       salario_cotizable,
       categoria_salario,
       tipo_subsidio,
       FECHA_REGISTRO,
       ult_fecha_act,
       tipo_solicitud,
       nro_solicitud,
       nro_lote,
       id_sub_maternidad,
       id_elegibles,
       fecha_envio,
       ID_NOMINA)
    values
      (p_REGISTRO_PATRONAL,
       p_ID_NSS,
       p_SECUENCIA,
       NVL(V_PADECIMIENTO, 0),
       NVL(p_SALARIO_COTIZABLE, 0),
       p_CATEGORIA_SALARIO,
       v_tipo_subsidio,
       sysdate,
       sysdate,
       decode(upper(P_MODO),'N','O',upper(P_MODO)),
       p_NRO_SOLICITUD,
       v_nro_lote,
       P_ID_SUB_MATERNIDAD,
       v_elegible,
       sysdate,
       v_nomina);

    p_resultNumber := '0';

  exception
    WHEN OTHERS THEN
      v_bd_error     := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultNumber := Seg_Retornar_Cadena_Error(-1, v_bd_error, SQLCODE);
  END;

  ----------------------------------------------------------------------------------------
  --- Metodo crea el historico de salario
  ----------------------------------------------------------------------------------------
  PROCEDURE crearHistoricoSalario(p_nro_solicitud  IN sub_solicitud_t.nro_solicitud%type,
                                  p_periodo_inicio IN sfc_facturas_t.periodo_factura%type,
                                  p_periodo_fin    IN sfc_facturas_t.periodo_factura%type,
                                  P_resultNumber   OUT varchar2) IS
    v_bd_error VARCHAR2(1000);
  BEGIN
    --buscar las cotizaciones de los utimos 12 meses--
    For sal In (Select sol.nss,
                       sol.padecimiento,
                       sol.secuencia,
                       f.Id_Registro_Patronal,
                       f.Periodo_Factura As Periodo,
                       Sum(d.Salario_Ss) Salario
                  From Sfc_Facturas_t     f,
                       Sfc_Det_Facturas_t d,
                       Sub_solicitud_t    sol
                 Where f.Id_Referencia = d.Id_Referencia
                   And d.Id_Nss = sol.Nss
                   And f.Status = 'PA'
                   And f.Id_Tipo_Factura <> 'U'
                   And f.Periodo_Factura Between p_periodo_inicio and
                       p_periodo_fin
                   And sol.nro_solicitud = p_nro_solicitud
                 Group By sol.Nss,
                          sol.Padecimiento,
                          sol.Secuencia,
                          f.Id_Registro_Patronal,
                          f.Periodo_Factura
                 Order By f.Periodo_Factura Desc) Loop
      --Insertar en SUB_HISTORICO_SAL_ las cotizaciones de los ?ltimos 12 meses
      Insert Into Suirplus.Sub_Historico_Sal_t
        (id_historico,
         Nro_solicitud,
         Id_Registro_Patronal,
         Periodo,
         Salario,
         Fecha_Registro)
      Values
        (sub_historico_sal_seq.NEXTVAL,
         P_nro_solicitud,
         sal.id_registro_patronal,
         sal.periodo,
         sal.Salario,
         sysdate);

    End Loop;

    P_resultNumber := '0';
  EXCEPTION
    WHEN OTHERS THEN
      v_bd_error     := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultNumber := Seg_Retornar_Cadena_Error(-1, v_bd_error, SQLCODE);
  END;

  ----------------------------------------------------------------------------------------
  --- Metodo crea el embarazo
  ----------------------------------------------------------------------------------------
  PROCEDURE crearEmbarazo(p_NSS                     IN SUB_SOLICITUD_T.NSS%type,
                          p_TELEFONO                IN SUB_MATERNIDAD_T.TELEFONO%type,
                          p_CELULAR                 IN SUB_MATERNIDAD_T.CELULAR%type,
                          p_EMAIL                   IN SUB_MATERNIDAD_T.EMAIL%type,
                          p_FECHA_DIAGNOSTICO       IN SUB_MATERNIDAD_T.FECHA_DIAGNOSTICO%type,
                          p_FECHA_ESTIMADA_PARTO    IN SUB_MATERNIDAD_T.FECHA_ESTIMADA_PARTO%type,
                          p_NSS_TUTOR               IN SUB_MATERNIDAD_T.NSS_TUTOR%type,
                          p_TELEFONO_TUTOR          IN SUB_MATERNIDAD_T.TELEFONO_TUTOR%type,
                          p_EMAIL_TUTOR             IN SUB_MATERNIDAD_T.EMAIL_TUTOR%type,
                          p_ULT_USUARIO_ACT         IN SUB_MATERNIDAD_T.ULT_USUARIO_ACT%type,
                          p_ID_REGISTRO_PATRONAL_RE IN SUB_MATERNIDAD_T.ID_REGISTRO_PATRONAL_RE%type,
                          p_esRetroativa            IN varchar2,
                          P_NROFORMULARIO           OUT VARCHAR2,
                          P_NRO_SOLICITUD           OUT SUB_SOLICITUD_T.NRO_SOLICITUD%type,
                          p_RESULTNUMBER            OUT VARCHAR2) IS

    v_bd_error       VARCHAR(1000);
    v_nroSolicitud   NUMBER;
    v_nroMaternidad  VARCHAR2(50);
    v_meses_embarazo Number(2) := Parm.get_parm_number(347);
    v_meses_parto    Number(2) := Parm.get_parm_number(348);
    v_embarazo_pend  number := 0;
    v_count          number(10) := 0;
    e_InicioSFS exception; -- Exception inicio Subsidio FR 2011-06-08

  BEGIN
    If ABS(MONTHS_BETWEEN(p_FECHA_DIAGNOSTICO, p_FECHA_ESTIMADA_PARTO)) >
       v_meses_parto Then
      p_RESULTNUMBER := Seg_Retornar_Cadena_Error(54, NULL, NULL);
      p_RESULTNUMBER := Substr(p_RESULTNUMBER,
                               Instr(p_RESULTNUMBER, '|') + 1,
                               Length(p_RESULTNUMBER));
      RETURN; --Sale del metodo
    End if;
    
    
    --Validamos el error definitivo
     select count(*)
         into v_count
         from sub_solicitud_t s
         join sub_sfs_maternidad_t m
           on m.nro_solicitud = s.nro_solicitud
          and m.id_registro_patronal = p_ID_REGISTRO_PATRONAL_RE
         join suirplus.sub_elegibles_t e
           on e.nro_solicitud = m.nro_solicitud
          and e.registro_patronal = m.id_registro_patronal
        where s.nss = p_NSS
         and s.nro_solicitud =
              (select max(nro_solicitud)
                 from sub_solicitud_t x
                where x.nss = s.nss
                  and x.tipo_subsidio = s.tipo_subsidio)
          and e.id_elegibles =
              (select max(id_elegibles)
                 from suirplus.sub_elegibles_t x
                where x.nro_solicitud = e.nro_solicitud
                  and x.registro_patronal = e.registro_patronal)
          and e.error in
              (select ID_ERROR from sub_errores_sisalril_t where definitivo = 'S');
       
if v_count = 0 then
          --Validamos el ultimo embarazo, sea por perdida o nacimiento
    For r in (Select s.nro_solicitud, m.fecha_perdida, l.fecha_nacimiento
                From sub_solicitud_t s
                Join sub_maternidad_t m
                  on m.nro_solicitud = s.nro_solicitud
                 and m.estatus = 'AC'
                Left Join sub_sfs_lactancia_t l
                  on l.nro_solicitud_mat = s.nro_solicitud
                 --and l.id_estatus != 3
                /*Left Join sub_sfs_maternidad_t sm
                  on sm.nro_solicitud = s.nro_solicitud
                 and sm.id_estatus != 3*/
               Where s.nss = p_NSS
                 and s.tipo_subsidio = 'M'
               Order by s.nro_solicitud) Loop
      If (r.fecha_perdida is not null or r.fecha_nacimiento is not null) Then
        If ABS(MONTHS_BETWEEN(p_FECHA_DIAGNOSTICO,
                              NVL(r.fecha_nacimiento, r.fecha_perdida))) <
           v_meses_embarazo Then
          p_RESULTNUMBER := Seg_Retornar_Cadena_Error(40, NULL, NULL);
          p_RESULTNUMBER := Substr(p_RESULTNUMBER,
                                   Instr(p_RESULTNUMBER, '|') + 1,
                                   Length(p_RESULTNUMBER));
          RETURN; --Sale del metodo
        End if;

        If ABS(MONTHS_BETWEEN(p_FECHA_ESTIMADA_PARTO,
                              NVL(r.fecha_nacimiento, r.fecha_perdida))) <
           v_meses_parto Then
          p_RESULTNUMBER := Seg_Retornar_Cadena_Error(44, NULL, NULL);
          p_RESULTNUMBER := Substr(p_RESULTNUMBER,
                                   Instr(p_RESULTNUMBER, '|') + 1,
                                   Length(p_RESULTNUMBER));
          RETURN; --Sale del metodo
        End if;
        --Si el embarazo no es retroactivo y no tiene ningun subsidio creado
      Elsif (UPPER(NVL(p_esRetroativa, 'NO')) = 'NO') and
            (r.fecha_perdida is null) and (r.fecha_nacimiento is null) Then
        v_embarazo_pend := v_embarazo_pend + 1;
      End if;
    End Loop;
    
     --Si el embarazo no es retroactivo y no tiene ningun subsidio creado
    If v_embarazo_pend > 0 Then
      p_RESULTNUMBER := Seg_Retornar_Cadena_Error(40, NULL, NULL);
      p_RESULTNUMBER := Substr(p_RESULTNUMBER,
                               Instr(p_RESULTNUMBER, '|') + 1,
                               Length(p_RESULTNUMBER));
      RETURN;
    End if;
         
end  if;
    
    --Validar si la fecha estimada de parto es menor a la fecha de inicio del Subsdio
    --FR 2011-06-08--
    if MenorInicioSubsidios(p_fecha_estimada_parto) then
      raise e_InicioSFS;
    end if;

    ---- SELECT
    ---- Cuantas maternidad (sub_maternidad_t) tienen registros SIN sub_sfs_lactancia_t y sub_sfs_maternidad_t

    ---- COUNT ()

    ---- IF (count > 0) AND (p_esRetroativa = NOOOOO!!!!) then
    ----    p_resultNumber := ErrorLike %Tiene otro embarazo pendiente%
    ----    Sal de aqui.
    ---- Else
    ----     Dejalo pasar.
    ---- end if

    --Crear la solicitud correspondiente a este subsidio--
    crearSolicitud(p_NSS,
                   NULL,
                   NULL,
                   NULL,
                   'M',
                   'O',
                   NULL,
                   NULL,
                   v_nroSolicitud,
                   p_RESULTNUMBER);

    --Obtener el numero de maternidad
    SELECT sub_maternidad_seq.nextval INTO v_nroMaternidad FROM dual;

    INSERT INTO SUB_MATERNIDAD_T
      (ID_MATERNIDAD,
       NRO_SOLICITUD,
       FECHA_DIAGNOSTICO,
       FECHA_ESTIMADA_PARTO,
       ULT_FECHA_ACT,
       ULT_USUARIO_ACT,
       ID_REGISTRO_PATRONAL_RE,
       FECHA_REGISTRO_RE,
       USUARIO_RE,
       TELEFONO,
       CELULAR,
       EMAIL,
       ESTATUS,
       NSS_TUTOR,
       EMAIL_TUTOR,
       TELEFONO_TUTOR,
       TIPO)
    VALUES
      (v_nroMaternidad,
       v_nroSolicitud,
       p_FECHA_DIAGNOSTICO,
       p_FECHA_ESTIMADA_PARTO,
       sysdate,
       p_ULT_USUARIO_ACT,
       p_ID_REGISTRO_PATRONAL_RE,
       sysdate,
       p_ULT_USUARIO_ACT,
       p_TELEFONO,
       p_CELULAR,
       p_EMAIL,
       'AC',
       p_NSS_TUTOR,
       p_EMAIL_TUTOR,
       p_TELEFONO_TUTOR,
       'O');

    --Crear el evento
    crearEvento(v_nroSolicitud, 'RE', sysdate, sysdate, p_RESULTNUMBER);

    if p_esRetroativa = 'NO' then
      commit;
    else
      getNumeroFormulario(p_NSS,
                          p_ID_REGISTRO_PATRONAL_RE,
                          'M',
                          p_nroFormulario,
                          p_RESULTNUMBER);
    end if;

    --Devolvemos el numero de solictud creado
    P_NRO_SOLICITUD := v_nroSolicitud;

    p_RESULTNUMBER := '0';

  exception

    WHEN DUP_VAL_ON_INDEX THEN
      DECLARE
        v_mensaje varchar2(4000) := sqlerrm;
      BEGIN
        ROLLBACK;
        p_resultNumber := Seg_Retornar_Cadena_Error(666, NULL, NULL);
 
        --Insertamos en la tabla de log SUB_LOG_T
        Insert into suirplus.sub_log_t
        (
         id_log,
         fecha,
         id_solicitud,
         mensaje
        )
        values
        (
         suirplus.sub_log_seq.nextval,
         sysdate,
         v_nro_solicitud,
         'CREACION DE EMBARAZO'||chr(13)||chr(10)||
         'ID_NSS: '||p_NSS||chr(13)||chr(10)||
         'SECUENCIA: '||v_nro_secuencia||chr(13)||chr(10)||
         'TIPO SUBSIDIO: M'||chr(13)||chr(10)||
         'USUARIO: '||p_ULT_USUARIO_ACT||chr(13)||chr(10)||
         'ERROR ORACLE: '||v_mensaje
        );
        commit;
      END;

    WHEN e_InicioSFS THEN
      p_resultNumber := Seg_Retornar_Cadena_Error(550, NULL, NULL);

    WHEN OTHERS THEN
      ROLLBACK;
      --Crear la solicitud correspondiente a este subsidio--
      --eliminarSolicitud(v_nroSolicitud, p_RESULTNUMBER);

      v_bd_error     := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultNumber := Seg_Retornar_Cadena_Error(-1, v_bd_error, SQLCODE);
  END;

  ----------------------------------------------------------------------------------------
  --- Metodo que crea una licencia
  ----------------------------------------------------------------------------------------
  PROCEDURE crearLicencia(p_ID_NSS               IN SUB_SOLICITUD_T.NSS%type,
                          p_FECHA_LICENCIA       IN SUB_SFS_MATERNIDAD_T.FECHA_LICENCIA%type,
                          p_ID_REGISTRO_PATRONAL IN SUB_SFS_MATERNIDAD_T.ID_REGISTRO_PATRONAL%type,
                          p_USUARIO_REGISTRO     IN SUB_SFS_MATERNIDAD_T.USUARIO_REGISTRO%type,
                          p_TIPO_LICENCIA        IN SUB_SFS_MATERNIDAD_T.TIPO_LICENCIA%type,
                          p_TIPO_FORMULARIO      IN SUB_FORMULARIOS_T.TIPO_FORMULARIO%type,
                          p_NRO_FORMULARIO       IN SUB_FORMULARIOS_T.NRO_FORMULARIO%type,
                          p_ID_PSS_MED           IN SUB_FORMULARIOS_T.ID_PSS_MED%type,
                          p_NO_DOCUMENTO_MED     IN SUB_FORMULARIOS_T.NO_DOCUMENTO_MED%type,
                          p_NOMBRE_MED           IN SUB_FORMULARIOS_T.NOMBRE_MED%type,
                          p_DIRECCION_MED        IN SUB_FORMULARIOS_T.DIRECCION_MED%type,
                          p_TELEFONO_MED         IN SUB_FORMULARIOS_T.TELEFONO_MED%type,
                          p_CELULAR_MED          IN SUB_FORMULARIOS_T.CELULAR_MED%type,
                          p_EMAIL_MED            IN SUB_FORMULARIOS_T.EMAIL_MED%type,
                          p_ID_PSS_CEN           IN SUB_FORMULARIOS_T.ID_PSS_CEN%type,
                          p_NOMBRE_CEN           IN SUB_FORMULARIOS_T.NOMBRE_CEN%type,
                          p_DIRECCION_CEN        IN SUB_FORMULARIOS_T.DIRECCION_CEN%type,
                          p_TELEFONO_CEN         IN SUB_FORMULARIOS_T.TELEFONO_CEN%type,
                          p_FAX_CEN              IN SUB_FORMULARIOS_T.FAX_CEN%type,
                          p_EMAIL_CEN            IN SUB_FORMULARIOS_T.EMAIL_CEN%type,
                          p_EXEQUATUR            IN SUB_FORMULARIOS_T.EXEQUATUR%type,
                          p_ULT_USUARIO_ACT      IN SUB_FORMULARIOS_T.ULT_USUARIO_ACT%type,
                          p_DIAGNOSTICO          IN SUB_FORMULARIOS_T.DIAGNOSTICO%type,
                          p_SIGNOS_SINTOMAS      IN SUB_FORMULARIOS_T.SIGNOS_SINTOMAS%type,
                          p_PROCEDIMIENTOS       IN SUB_FORMULARIOS_T.PROCEDIMIENTOS%type,
                          p_FECHA_DIAGNOSTICO    IN SUB_FORMULARIOS_T.FECHA_DIAGNOSTICO%type,
                          p_esRetroativa         IN varchar2,
                          p_NRO_SOLICITUD        IN SUB_SOLICITUD_T.NRO_SOLICITUD%type,
                          p_MODO                 IN VARCHAR2,
                          p_RESULTNUMBER         OUT VARCHAR2) IS
    v_bd_error          VARCHAR(1000);
    v_nroMaternidad     VARCHAR2(50);
    V_SALARIO_COTIZABLE SRE_TRABAJADORES_T.SALARIO_SS%TYPE := 0;
    v_cat               SFS_ELEGIBLES_T.CATEGORIA_SALARIO%TYPE;
    v_secuencia         sub_solicitud_t.secuencia%type;
    v_fecha_diagnostico sub_maternidad_t.fecha_diagnostico%type;
    v_nro_formulario    sub_formularios_t.nro_formulario%type;
    e_formulario exception;
    e_evento     exception;
    e_elegible   exception;
    e_existeLicencia   exception;
    e_InicioSFS  exception; -- Exception inicio Subsidio FR 2011-06-08

    v_meses_parto     Number(2) := Parm.get_parm_number(348); --Hasta ahora 9 meses
    v_tipo_licencia   sub_sfs_maternidad_t.tipo_licencia%type;
    v_tipo_formulario sub_formularios_t.tipo_formulario%type;

  BEGIN
    
    --validando que la madre no tenga actualmente una licencia creada para este empleador
    if sub_sfs_novedades.ValidarLicenciaMaternidad(p_ID_NSS,p_MODO,p_ID_REGISTRO_PATRONAL) = 'S' then
     raise e_existeLicencia;
    end if;
    
    --Buscando la fecha estimada de parto de la maternidad
    select m.fecha_diagnostico
      into v_fecha_diagnostico
      from sub_maternidad_t m
     where m.id_maternidad = (select max(m.id_maternidad) from sub_maternidad_t m where m.nro_solicitud = p_NRO_SOLICITUD);

    --Los meses entre la fecha diagnostico de embarazo y fecha de licencia no deben exceder los 9 meses
    If ABS(MONTHS_BETWEEN(p_FECHA_LICENCIA, v_fecha_diagnostico)) >
       v_meses_parto Then
      p_RESULTNUMBER := Seg_Retornar_Cadena_Error(45, NULL, NULL);
      RETURN; --Sale del metodo
    End if;

    --La fecha de diagnostico de la licencia fuera de la fecha de diagnostico del embarazo y la fecha de licencia
    If p_FECHA_DIAGNOSTICO NOT BETWEEN v_fecha_diagnostico and
       p_FECHA_LICENCIA Then
      p_RESULTNUMBER := Seg_Retornar_Cadena_Error(46, NULL, NULL);
      RETURN; --Sale del metodo
    End if;

    --Validar si la fecha de la licencia es menor a la fecha de inicio del Subsdio
    --FR 2011-06-08--
    if MenorInicioSubsidios(p_FECHA_LICENCIA) then
      raise e_InicioSFS;
    end if;

    -- Para validar que tenga las 8 cotizaciones reglamentarias
    If SUB_SFS_VALIDACIONES.Cotizaciones(p_ID_NSS, p_FECHA_LICENCIA) < 8 then
      p_RESULTNUMBER := Seg_Retornar_Cadena_Error(548, NULL, NULL);
      RETURN; --Sale del metodo
    End if;

    If (NVL(UPPER(P_MODO), 'N') = 'N') Then
      --Modo Normal, no es una Recondiseracion
      --Obtener el numero de maternidad
      SELECT sub_sfs_maternidad_seq.nextval INTO v_nroMaternidad FROM dual;

      INSERT INTO SUB_SFS_MATERNIDAD_T
        (ID_SUB_MATERNIDAD,
         NRO_SOLICITUD,
         FECHA_LICENCIA,
         ID_ESTATUS,
         ID_REGISTRO_PATRONAL,
         USUARIO_REGISTRO,
         FECHA_REGISTRO,
         ULT_FECHA_ACT,
         TIPO_LICENCIA)
      VALUES
        (v_nroMaternidad,
         p_NRO_SOLICITUD,
         p_FECHA_LICENCIA,
         1, --Pendiente
         p_ID_REGISTRO_PATRONAL,
         p_USUARIO_REGISTRO,
         sysdate,
         sysdate,
         NVL(p_TIPO_LICENCIA, v_tipo_licencia));


          --Creando el formulario
    If p_NRO_FORMULARIO is null Then
      getNumeroFormulario(p_ID_NSS,
                          p_ID_REGISTRO_PATRONAL,
                          'M',
                          v_nro_formulario,
                          p_RESULTNUMBER);
    End if;




    --Buscamos el tipo de formulario si el parametro P_TIPO_FORMULARIO llega nulo.
    --Se asume que si llega nulo es una reconsideracion
    If (TRIM(p_TIPO_FORMULARIO) is null) Then
      select f.tipo_formulario
        into v_tipo_formulario
        from sub_formularios_t f
       where f.id_formulario =
             (select max(id_formulario)
                from sub_formularios_t
               where nro_solicitud = p_NRO_SOLICITUD);
    End if;

    crearFormulario(p_NRO_SOLICITUD,
                    NVL(p_TIPO_FORMULARIO, v_tipo_formulario),
                    NVL(p_NRO_FORMULARIO, v_nro_formulario),
                    p_ID_PSS_MED,
                    p_NO_DOCUMENTO_MED,
                    p_NOMBRE_MED,
                    p_DIRECCION_MED,
                    p_TELEFONO_MED,
                    p_CELULAR_MED,
                    p_EMAIL_MED,
                    p_ID_PSS_CEN,
                    p_NOMBRE_CEN,
                    p_DIRECCION_CEN,
                    p_TELEFONO_CEN,
                    p_FAX_CEN,
                    p_EMAIL_CEN,
                    p_EXEQUATUR,
                    p_ULT_USUARIO_ACT,
                    p_DIAGNOSTICO,
                    p_SIGNOS_SINTOMAS,
                    p_PROCEDIMIENTOS,
                    p_FECHA_DIAGNOSTICO,
                    p_RESULTNUMBER);

    if (p_RESULTNUMBER != '0') then
      raise e_formulario;
    end if;

    Elsif UPPER(P_MODO) = 'R' Then
      --Reconsideracion, se actualiza el subsidio
      UPDATE SUB_SFS_MATERNIDAD_T
         SET ID_ESTATUS       = 1,
             USUARIO_REGISTRO = p_USUARIO_REGISTRO,
             ULT_FECHA_ACT    = sysdate,
             --TIPO_LICENCIA    = p_TIPO_LICENCIA,
             FECHA_LICENCIA = p_FECHA_LICENCIA,
             FECHA_REGISTRO = sysdate
       WHERE NRO_SOLICITUD = p_NRO_SOLICITUD
         AND ID_REGISTRO_PATRONAL = p_ID_REGISTRO_PATRONAL;

        Update Sub_Formularios_t fm
         Set Fm.Id_Pss_Med        = p_Id_Pss_Med,
             Fm.No_Documento_Med  = p_No_Documento_Med,
             Fm.Nombre_Med        = p_Nombre_Med,
             Fm.Direccion_Med     = p_Direccion_Med,
             Fm.Telefono_Med      = p_Telefono_Med,
             Fm.Celular_Med       = p_Celular_Med,
             Fm.Email_Med         = p_Email_Med,
             Fm.Id_Pss_Cen        = p_Id_Pss_Cen,
             Fm.Nombre_Cen        = p_Nombre_Cen,
             Fm.Direccion_Cen     = p_Direccion_Cen,
             Fm.Telefono_Cen      = p_Telefono_Cen,
             Fm.Fax_Cen           = p_Fax_Cen,
             Fm.Email_Cen         = p_Email_Cen,
             Fm.Exequatur         = p_Exequatur,
             Fm.Diagnostico       = p_Diagnostico,
             Fm.Signos_Sintomas   = p_Signos_Sintomas,
             Fm.Procedimientos    = p_Procedimientos,
             Fm.Fecha_Diagnostico = p_Fecha_Diagnostico,
             fm.ult_usuario_act   = p_ULT_USUARIO_ACT,
             fm.ult_fecha_act     = sysdate
       Where Fm.Nro_Solicitud = p_Nro_Solicitud;

    End if;

    --Crear el evento
    crearEvento(p_NRO_SOLICITUD, 'LM', sysdate, sysdate, p_RESULTNUMBER);

    if (p_RESULTNUMBER != '0') then
      raise e_evento;
    end if;

    -- Determinar el Salario Cotizable de Maternidad
    v_cat := getCategoriaSalario(p_ID_NSS,
                                 p_id_registro_patronal,
                                 'M',
                                 V_SALARIO_COTIZABLE,
                                 p_fecha_licencia);

    --Buscamos la secuencia de la solicitud
    select s.secuencia
      into v_secuencia
      from sub_solicitud_t s
     where s.nro_solicitud = p_NRO_SOLICITUD;

    --Creando el elegible
    crearElegible(p_NRO_SOLICITUD,
                  p_ID_REGISTRO_PATRONAL,
                  V_SALARIO_COTIZABLE,
                  1, --Pendiente
                  v_cat,
                  p_ID_NSS,
                  v_secuencia,
                  v_nroMaternidad,
                  UPPER(P_MODO),
                  p_FECHA_LICENCIA,
                  p_RESULTNUMBER);

    if (p_RESULTNUMBER != '0') then
      raise e_elegible;
    end if;

    --Creamos el historico de salario
    crearHistoricoSalario(p_nro_solicitud,
                          To_Number(to_char(ADD_MONTHS(p_FECHA_LICENCIA,
                                                       -12),
                                            'YYYYMM')),
                          To_Number(to_char(ADD_MONTHS(p_FECHA_LICENCIA, -1),
                                            'YYYYMM')),
                          p_RESULTNUMBER);

    If (p_RESULTNUMBER != '0') Then
      ROLLBACK;
      RETURN;
    End If;

    if NVL(p_esRetroativa, 'NO') = 'NO' then
      commit;
    end if;
    p_resultNumber := '0';
  exception

    when e_InicioSFS then
      ROLLBACK;
      p_resultNumber := Seg_Retornar_Cadena_Error(550, NULL, NULL);
    when e_formulario then
      ROLLBACK;
      p_resultNumber := 'Ocurrio un error insertando el formulario' || p_RESULTNUMBER;                        
    when e_existeLicencia then                        
      ROLLBACK;
      p_resultNumber := Seg_Retornar_Cadena_Error(442, NULL, NULL);                
    when e_evento then
      ROLLBACK;
      p_resultNumber := 'Ocurrio un error insertando el evento' || p_RESULTNUMBER;
    when e_elegible then
      ROLLBACK;
      p_resultNumber := 'Ocurrio un error insertando el elegible' || p_RESULTNUMBER;
    WHEN OTHERS THEN
      ROLLBACK;
      v_bd_error     := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultNumber := Seg_Retornar_Cadena_Error(-1, v_bd_error, SQLCODE);
  END;

  ----------------------------------------------------------------------------------------
  --- Metodo que crea un formulario
  ----------------------------------------------------------------------------------------
  PROCEDURE crearFormulario(p_NRO_SOLICITUD     IN SUB_FORMULARIOS_T.NRO_SOLICITUD%type,
                            p_TIPO_FORMULARIO   IN SUB_FORMULARIOS_T.TIPO_FORMULARIO%type,
                            p_NRO_FORMULARIO    IN SUB_FORMULARIOS_T.NRO_FORMULARIO%type,
                            p_ID_PSS_MED        IN SUB_FORMULARIOS_T.ID_PSS_MED%type,
                            p_NO_DOCUMENTO_MED  IN SUB_FORMULARIOS_T.NO_DOCUMENTO_MED%type,
                            p_NOMBRE_MED        IN SUB_FORMULARIOS_T.NOMBRE_MED%type,
                            p_DIRECCION_MED     IN SUB_FORMULARIOS_T.DIRECCION_MED%type,
                            p_TELEFONO_MED      IN SUB_FORMULARIOS_T.TELEFONO_MED%type,
                            p_CELULAR_MED       IN SUB_FORMULARIOS_T.CELULAR_MED%type,
                            p_EMAIL_MED         IN SUB_FORMULARIOS_T.EMAIL_MED%type,
                            p_ID_PSS_CEN        IN SUB_FORMULARIOS_T.ID_PSS_CEN%type,
                            p_NOMBRE_CEN        IN SUB_FORMULARIOS_T.NOMBRE_CEN%type,
                            p_DIRECCION_CEN     IN SUB_FORMULARIOS_T.DIRECCION_CEN%type,
                            p_TELEFONO_CEN      IN SUB_FORMULARIOS_T.TELEFONO_CEN%type,
                            p_FAX_CEN           IN SUB_FORMULARIOS_T.FAX_CEN%type,
                            p_EMAIL_CEN         IN SUB_FORMULARIOS_T.EMAIL_CEN%type,
                            p_EXEQUATUR         IN SUB_FORMULARIOS_T.EXEQUATUR%type,
                            p_ULT_USUARIO_ACT   IN SUB_FORMULARIOS_T.ULT_USUARIO_ACT%type,
                            p_DIAGNOSTICO       IN SUB_FORMULARIOS_T.DIAGNOSTICO%type,
                            p_SIGNOS_SINTOMAS   IN SUB_FORMULARIOS_T.SIGNOS_SINTOMAS%type,
                            p_PROCEDIMIENTOS    IN SUB_FORMULARIOS_T.PROCEDIMIENTOS%type,
                            p_FECHA_DIAGNOSTICO IN SUB_FORMULARIOS_T.FECHA_DIAGNOSTICO%type,
                            p_RESULTNUMBER      OUT VARCHAR2) IS
    v_bd_error      VARCHAR(1000);
    v_nroFormulario VARCHAR2(50);
  BEGIN

    --Obtener el numero de maternidad
    SELECT sub_formulario_seq.nextval INTO v_nroFormulario FROM dual;

    INSERT INTO SUB_FORMULARIOS_T
      (ID_FORMULARIO,
       NRO_SOLICITUD,
       TIPO_FORMULARIO,
       NRO_FORMULARIO,
       ID_PSS_MED,
       NO_DOCUMENTO_MED,
       NOMBRE_MED,
       DIRECCION_MED,
       TELEFONO_MED,
       CELULAR_MED,
       EMAIL_MED,
       ID_PSS_CEN,
       NOMBRE_CEN,
       DIRECCION_CEN,
       TELEFONO_CEN,
       FAX_CEN,
       EMAIL_CEN,
       EXEQUATUR,
       USUARIO_REGISTRO,
       FECHAREGISTRO,
       ULT_USUARIO_ACT,
       ULT_FECHA_ACT,
       DIAGNOSTICO,
       SIGNOS_SINTOMAS,
       PROCEDIMIENTOS,
       FECHA_DIAGNOSTICO)
    VALUES
      (v_nroFormulario,
       p_NRO_SOLICITUD,
       p_TIPO_FORMULARIO,
       p_NRO_FORMULARIO,
       p_ID_PSS_MED,
       p_NO_DOCUMENTO_MED,
       p_NOMBRE_MED,
       p_DIRECCION_MED,
       p_TELEFONO_MED,
       p_CELULAR_MED,
       p_EMAIL_MED,
       p_ID_PSS_CEN,
       p_NOMBRE_CEN,
       p_DIRECCION_CEN,
       p_TELEFONO_CEN,
       p_FAX_CEN,
       p_EMAIL_CEN,
       p_EXEQUATUR,
       p_ULT_USUARIO_ACT,
       sysdate,
       p_ULT_USUARIO_ACT,
       sysdate,
       p_DIAGNOSTICO,
       p_SIGNOS_SINTOMAS,
       p_PROCEDIMIENTOS,
       p_FECHA_DIAGNOSTICO);

  exception
    WHEN OTHERS THEN
      v_bd_error     := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultNumber := Seg_Retornar_Cadena_Error(-1, v_bd_error, SQLCODE);
      RETURN;
  END;

  function getSecuenciaLactante(p_nro_solicitud sub_solicitud_t.nro_solicitud%type)
    return sub_lactantes_t.secuencia_lactante%type is
    v_secuencia_lactante sfs_lactantes_t.secuencia_lactante%type;
  begin
    select nvl(max(l.secuencia_lactante), 0) + 1
      into v_secuencia_lactante
      from sub_lactantes_t l
      join sub_solicitud_t s
        on l.nro_solicitud = s.nro_solicitud
     where l.nro_solicitud = p_nro_solicitud;

    return v_secuencia_lactante;
  end;

  ----------------------------------------------------------------------------------------
  --- Metodo que crea el lactante
  ----------------------------------------------------------------------------------------
  PROCEDURE crearLactantes(p_ID_NSS_LACTANTE         IN SUB_LACTANTES_T.ID_NSS_LACTANTE%type,
                           p_NUI                     IN SUB_LACTANTES_T.NUI%type,
                           p_NOMBRES                 IN SUB_LACTANTES_T.NOMBRES%type,
                           p_PRIMER_APELLIDO         IN SUB_LACTANTES_T.PRIMER_APELLIDO%type,
                           p_SEGUNDO_APELLIDO        IN SUB_LACTANTES_T.SEGUNDO_APELLIDO%type,
                           p_SEXO                    IN SUB_LACTANTES_T.SEXO%type,
                           p_ULT_USUARIO_ACT         IN SUB_LACTANTES_T.ULT_USUARIO_ACT%type,
                           p_ID_REGISTRO_PATRONAL_NC IN SUB_LACTANTES_T.ID_REGISTRO_PATRONAL_NC%type,
                           p_esRetroativa            IN varchar2,
                           p_nro_solicitud           IN SUB_SOLICITUD_T.NRO_SOLICITUD%type,
                           p_Modo                    In Varchar2,
                           p_RESULTNUMBER            OUT VARCHAR2) IS
    v_bd_error           VARCHAR(1000);
    v_nroLactante        VARCHAR2(50);
    v_nss                sub_solicitud_t.nss%type;
    v_secuencia          sub_solicitud_t.secuencia%type;
    v_fecha_nacimiento   sub_sfs_lactancia_t.fecha_nacimiento%type;
    v_secuencia_lactante sub_lactantes_t.secuencia_lactante%TYPE;

  BEGIN   
  
  If UPPER(P_MODO) = 'R' Then
     --Borrando los lactantes
      Delete from sub_lactantes_t la
      Where la.nro_solicitud = P_NRO_SOLICITUD and la.estatus = 'RE';      
  End if;

    --Obtener el numero de lactante
    SELECT SUB_LACTANTES_SEQ.nextval INTO v_nroLactante FROM dual;

    -- Determinar el Salario Cotizable de Lactancia
    v_secuencia_lactante := getSecuenciaLactante(p_nro_solicitud);

    INSERT INTO SUB_LACTANTES_T
      (ID_LACTANTE,
       NRO_SOLICITUD,
       ID_NSS_LACTANTE,
       NUI,
       SECUENCIA_LACTANTE,
       NOMBRES,
       PRIMER_APELLIDO,
       SEGUNDO_APELLIDO,
       SEXO,
       ULT_FECHA_ACT,
       ULT_USUARIO_ACT,
       USUARIO_NC,
       FECHA_REGISTRO_NC,
       ID_REGISTRO_PATRONAL_NC,
       ESTATUS)
    VALUES
      (v_nroLactante,
       p_nro_solicitud,
       case p_ID_NSS_LACTANTE when 0 then null end,
       p_NUI,
       v_secuencia_lactante,
       p_NOMBRES,
       p_PRIMER_APELLIDO,
       p_SEGUNDO_APELLIDO,
       p_SEXO,
       sysdate,
       p_ULT_USUARIO_ACT,
       p_ULT_USUARIO_ACT,
       sysdate,
       p_ID_REGISTRO_PATRONAL_NC,
       'PE');

    select s.nss, s.secuencia
      into v_nss, v_secuencia
      from sub_solicitud_t s
     where s.nro_solicitud = p_NRO_SOLICITUD;

    select s.fecha_nacimiento
      into v_fecha_nacimiento
      from sub_sfs_lactancia_t s
     where s.nro_solicitud = p_NRO_SOLICITUD;

    ---Insertar SISARIL
    Update sisalril_suir.sfs_lactantes_t e
       set id_nss_lactante         = p_ID_NSS_LACTANTE,
           nombres                 = p_NOMBRES,
           primer_apellido         = p_PRIMER_APELLIDO,
           segundo_apellido        = p_SEGUNDO_APELLIDO,
           sexo                    = p_SEXO,
           fecha_nacimiento        = v_fecha_nacimiento,
           nui                     = p_NUI,
           fecha_registro          = sysdate,
           status                  = 'PE',
           ult_fecha_act           = sysdate,
           ult_usuario_act         = p_ULT_USUARIO_ACT,
           id_registro_patronal_nc = p_ID_REGISTRO_PATRONAL_NC,
           usuario_nc              = p_ULT_USUARIO_ACT,
           fecha_registro_nc       = sysdate,
           nro_solicitud           = p_NRO_SOLICITUD,
           TIPO_SOLICITUD                    = decode(upper(P_MODO),'N','O',upper(P_MODO))
     where e.id_nss_madre = v_nss
       and e.secuencia = v_secuencia
       and e.secuencia_lactante = v_secuencia_lactante;

    --Si no actualizo registro, entonces lo inserto
    If SQL%ROWCOUNT = 0 Then
      insert into sisalril_suir.sfs_lactantes_t
        (id_nss_madre,
         secuencia,
         secuencia_lactante,
         id_nss_lactante,
         nombres,
         primer_apellido,
         segundo_apellido,
         sexo,
         fecha_nacimiento,
         nui,
         fecha_registro,
         status,
         ult_fecha_act,
         ult_usuario_act,
         id_registro_patronal_nc,
         usuario_nc,
         fecha_registro_nc,
         nro_solicitud,
         TIPO_SOLICITUD)
      values
        (v_nss,
         v_secuencia,
         v_secuencia_lactante,
         p_ID_NSS_LACTANTE,
         p_NOMBRES,
         p_PRIMER_APELLIDO,
         p_SEGUNDO_APELLIDO,
         p_SEXO,
         v_fecha_nacimiento,
         p_NUI,
         sysdate,
         'PE',
         sysdate,
         p_ULT_USUARIO_ACT,
         p_ID_REGISTRO_PATRONAL_NC,
         p_ULT_USUARIO_ACT,
         sysdate,
         p_NRO_SOLICITUD,
         decode(upper(P_MODO),'N','O',upper(P_MODO)));
    End if;

    if p_esRetroativa = 'NO' then
      commit;
    end if;
    p_resultNumber := '0';
  exception
    WHEN DUP_VAL_ON_INDEX THEN
      DECLARE
        v_mensaje varchar2(4000) := SQLERRM;
      BEGIN
        p_resultNumber := Seg_Retornar_Cadena_Error(666, NULL, NULL);

        --Insertamos en la tabla de log SUB_LOG_T
        Insert into suirplus.sub_log_t
        (
         id_log,
         fecha,
         id_solicitud,
         mensaje
        )
        values
        (
         suirplus.sub_log_seq.nextval,
         sysdate,
         p_NRO_SOLICITUD,
         'CREACION DE LACTANTES'||chr(13)||chr(10)||
         'ID_NSS: '||v_NSS||chr(13)||chr(10)||
         'SECUENCIA: '||v_secuencia||chr(13)||chr(10)||
         'USUARIO: '||p_ULT_USUARIO_ACT||chr(13)||chr(10)||
         'ERROR ORACLE: '||v_mensaje
        );
        commit;
      END;
    
    WHEN OTHERS THEN
        ROLLBACK;
        
        --Eliminar Lactantes
        v_bd_error     := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                  SQLERRM,
                                  1,
                                  255));
       
        if p_esRetroativa = 'NO' then
          EliminarLactancia(p_nro_solicitud,p_resultNumber);
        end if;
        
        p_resultNumber := Seg_Retornar_Cadena_Error(-1, v_bd_error || ': ' || p_resultNumber, SQLCODE);
  END;

  ----------------------------------------------------------------------------------------
  --- Metodo que el numero del formulario
  ----------------------------------------------------------------------------------------
  procedure getNumeroFormulario(p_id_nss               sub_solicitud_t.nss%type,
                                p_id_registro_patronal sub_maternidad_t.id_registro_patronal_re%type,
                                p_tipo                 sub_solicitud_t.tipo_subsidio%type,
                                p_nroformulario        out varchar2,
                                p_resultnumber         out varchar2) is
    v_bd_error VARCHAR(1000);
  begin

    --Formulario de Maternidad
    if (p_tipo = 'M') then
      select Lpad(p_id_nss, 10, 0) || Lpad(p_id_registro_patronal, 5, 0) ||
             Lpad(nvl(max(s.secuencia), 0) + 1, 3, 0)
        into p_nroformulario
        from sub_solicitud_t s
       where s.nss = p_id_nss
         and s.tipo_subsidio = 'M';
    else
      --Aqui va el query de enfermedad comun
      select Lpad(s.nss, 10, 0) || Lpad(s.padecimiento, 5, 0) ||
             Lpad(s.secuencia, 3, 0)
        into p_nroformulario
        from sub_solicitud_t s
       where s.nss = p_id_nss
         and s.tipo_subsidio = 'E';
    end if;

    p_resultnumber := '0';
  exception
    WHEN OTHERS THEN
      v_bd_error     := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultNumber := Seg_Retornar_Cadena_Error(-1, v_bd_error, SQLCODE);
      RETURN;
  end;

  ----------------------------------------------------------------------------------------
  --- Metodo que crea el nacimiento
  ----------------------------------------------------------------------------------------
  PROCEDURE crearNacimiento(p_ID_NSS               in sub_solicitud_t.nss%type,
                            p_ID_REGISTRO_PATRONAL IN SUB_SFS_MATERNIDAD_T.ID_REGISTRO_PATRONAL%type,
                            p_cant_lactantes       in sub_sfs_lactancia_t.cant_lactantes%type,
                            p_fecha_nacimiento     in sub_sfs_lactancia_t.fecha_nacimiento%type,
                            p_esRetroativa         in varchar2,
                            P_NRO_SOLICITUD_MAT    IN SUB_SOLICITUD_T.NRO_SOLICITUD%TYPE,
                            P_NRO_SOLICITUD        in OUT sub_solicitud_t.nro_solicitud%type,
                            p_Modo                 In Varchar2,
                            p_RESULTNUMBER         OUT VARCHAR2) IS
    v_bd_error          VARCHAR(1000);
    v_lactancia         sub_sfs_lactancia_t.id_sub_lactancia%type;
    v_nrosolicitud      sub_solicitud_t.nro_solicitud%type;
    V_SALARIO_COTIZABLE SRE_TRABAJADORES_T.SALARIO_SS%TYPE := 0;
    v_cat               SFS_ELEGIBLES_T.CATEGORIA_SALARIO%TYPE;
    v_secuencia         sub_solicitud_t.secuencia%type;
    e_evento       exception;
    e_elegible     exception;
    e_disparaError exception;
    e_InicioSFS    exception; --Exception inicio Subsidio FR 2011-06-08

    v_id_error          number;
    v_fecha_diagnostico sub_maternidad_t.fecha_diagnostico%type;
    v_fecha_licencia    sub_sfs_maternidad_t.fecha_licencia%type;
    v_conteo            number;
    v_meses_parto       number(2) := Parm.get_parm_number(348);
  BEGIN

    -- Verificar que la fecha de nacimiento no sea futura
    If p_fecha_nacimiento > trunc(sysdate) then
      v_id_error := 108;
      RAISE e_disparaError;
    End if;

    -- Verificar que la fecha de nacimiento sea mayor o igual a la fecha del diagnostico del registro de embarazo
    select m.fecha_diagnostico
      into v_fecha_diagnostico
     from sub_maternidad_t m
    where m.id_maternidad = (select max(m.id_maternidad)
                               from sub_maternidad_t m
                              where m.nro_solicitud = P_NRO_SOLICITUD_MAT
                                and m.estatus = 'AC');

    If p_fecha_nacimiento < v_fecha_diagnostico then
      v_id_error := 52;
      RAISE e_disparaError;
    End if;

    -- Verificar que la fecha de nacimiento sea mayor o igual a la fecha de la licencia
    select max(m.fecha_licencia) - 5
      into v_fecha_licencia
      from sub_sfs_maternidad_t m
     where m.nro_solicitud = P_NRO_SOLICITUD_MAT
     and m.id_registro_patronal = p_ID_REGISTRO_PATRONAL
       and m.id_estatus != 3;

    If p_fecha_nacimiento < v_fecha_licencia then
      v_id_error := 535;
      RAISE e_disparaError;
    End if;

    -- Entre un nacimiento y otro debe haber nueve meses
    select count(*)
      into v_conteo
      from sub_sfs_lactancia_t m
     where m.nro_solicitud_mat = P_NRO_SOLICITUD_MAT
       and MONTHS_BETWEEN(m.fecha_nacimiento, p_fecha_nacimiento) <
           v_meses_parto
       and m.id_estatus != 3;

    If v_conteo > 0 then
      v_id_error := 108;
      RAISE e_disparaError;
    End if;

    --Validar si la fecha de nacimiento es menor a la fecha de inicio del Subsdio
    --FR 2011-06-08--
    if MenorInicioSubsidios(p_fecha_nacimiento) then
      raise e_InicioSFS;
    end if;

    -- Para validar que tenga las 8 cotizaciones reglamentarias
    If SUB_SFS_VALIDACIONES.Cotizaciones(p_ID_NSS, p_FECHA_NACIMIENTO) < 8 then
      p_RESULTNUMBER := Seg_Retornar_Cadena_Error(548, NULL, NULL);
      RETURN; --Sale del metodo
    End if;

    --Buscamos la categor?a de salario del lactante
    v_cat := getCategoriaSalario(p_ID_NSS,
                                 p_ID_REGISTRO_PATRONAL,
                                 'L',
                                 V_SALARIO_COTIZABLE,
                                 p_fecha_nacimiento);

    If (UPPER(NVL(P_MODO, 'N')) = 'N') then

      --Creamos una solicitud nueva de tipo 'L'
      crearSolicitud(p_ID_NSS,
                     NULL,
                     NULL,
                     v_cat,
                     'L',
                     'O',
                     NULL,
                     P_NRO_SOLICITUD_MAT,
                     v_nrosolicitud,
                     p_RESULTNUMBER);

      --Buscando la secuencia desde la solicitud
      select s.secuencia
        into v_secuencia
        from sub_solicitud_t s
       where s.nro_solicitud = v_nrosolicitud;

      -- Si la creaci?n de la solicitud dispara una excepcion abortamos el proceso
      if (p_RESULTNUMBER != '0') then
        raise e_evento;
      end if;

      --Obtener el numero de lactante
      SELECT sub_sfs_lactancia_seq.nextval INTO v_lactancia FROM dual;

      INSERT INTO sub_sfs_lactancia_t
        (ID_SUB_LACTANCIA,
         NRO_SOLICITUD,
         ID_ESTATUS,
         CANT_LACTANTES,
         FECHA_NACIMIENTO,
         NRO_SOLICITUD_MAT,
         TIPO)
      VALUES
        (v_lactancia,
         v_nroSolicitud,
         1, --Pendiente
         p_cant_lactantes,
         p_fecha_nacimiento,
         p_nro_solicitud_mat,
        decode(upper(P_MODO),'N','O',upper(P_MODO)));

      --Crear el evento
      crearEvento(v_nrosolicitud, 'NC', sysdate, sysdate, p_RESULTNUMBER);

      if (p_RESULTNUMBER != '0') then
        raise e_evento;
      end if;
    Elsif UPPER(P_MODO) = 'R' Then
      --Buscando la secuencia desde la solicitud
      select s.secuencia
        into v_secuencia
        from sub_solicitud_t s
       where s.nro_solicitud = P_NRO_SOLICITUD;

      -- Reconsideracion
      update sub_sfs_lactancia_t l
         set l.fecha_nacimiento = p_fecha_nacimiento,
             l.id_estatus       = 1,
             l.cant_lactantes   = p_cant_lactantes,
             l.tipo             =  upper(p_Modo)
       where l.nro_solicitud = P_NRO_SOLICITUD;
    

      v_nrosolicitud := P_NRO_SOLICITUD;
    end if;

    --Creando el elegible
    crearElegible(v_nrosolicitud,
                  p_ID_REGISTRO_PATRONAL,
                  V_SALARIO_COTIZABLE,
                  1, --Pendiente
                  v_cat,
                  p_ID_NSS,
                  v_secuencia,
                  NULL,
                  p_Modo,
                  p_fecha_nacimiento,
                  p_RESULTNUMBER);

    if (p_RESULTNUMBER != '0') then
      raise e_elegible;
    end if;

    if p_esRetroativa = 'NO' then
      commit;
    end if;

    p_resultNumber := '0';

    --El numero de solicitud que debe ser utilizada para crear los lactantes.
    p_nro_solicitud := v_nroSolicitud;

  exception
    WHEN DUP_VAL_ON_INDEX THEN
      DECLARE
        v_mensaje varchar2(4000) := SQLERRM;       
      BEGIN
        ROLLBACK;
        p_resultNumber := Seg_Retornar_Cadena_Error(666, NULL, NULL);

        --Insertamos en la tabla de log SUB_LOG_T
        Insert into suirplus.sub_log_t
        (
         id_log,
         fecha,
         id_solicitud,
         mensaje
        )
        values
        (
         suirplus.sub_log_seq.nextval,
         sysdate,
         v_nro_solicitud,
         'CREACION DE NACIMIENTO'||chr(13)||chr(10)||
         'ID_NSS: '||p_id_NSS||chr(13)||chr(10)||
         'SECUENCIA: '||v_nro_secuencia||chr(13)||chr(10)||
         'TIPO SUBSIDIO: L'||chr(13)||chr(10)||
         'ERROR ORACLE: '||v_mensaje
        );
        commit;
      END;
      
    when e_evento then
      ROLLBACK;

      p_resultNumber := 'Ocurrio un error insertando el evento' ||
                        p_RESULTNUMBER;
    when e_elegible then
      ROLLBACK;

      p_resultNumber := 'Ocurrio un error insertando el elegible' ||
                        p_RESULTNUMBER;
    when e_disparaError then
      ROLLBACK;
      p_resultNumber := Seg_Retornar_Cadena_Error(v_id_error, NULL, NULL);
    when e_InicioSFS then
      ROLLBACK;
      p_resultNumber := Seg_Retornar_Cadena_Error(550, NULL, NULL);
      return;

    WHEN OTHERS THEN
      rollback;

      --Eliminar Lactantes
      --eliminarLactantes(v_nroSolicitud, p_resultNumber);

      v_bd_error     := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultNumber := Seg_Retornar_Cadena_Error(-1, v_bd_error, SQLCODE);
  END;

  ----------------------------------------------------------------------------------------
  --- Metodo que crea un reporte de muerte madre
  ----------------------------------------------------------------------------------------
  PROCEDURE crearMuerteMadre(p_ID_NSS               IN SUB_SOLICITUD_T.NSS%type,
                             p_ID_REGISTRO_PATRONAL IN sub_maternidad_t.id_registro_patronal_mm%type,
                             p_FECHA_MUERTE         in sub_maternidad_t.fecha_defuncion_madre%type,
                             p_ULT_USUARIO_ACT      IN sub_maternidad_t.ult_usuario_act%type,
                             p_esRetroativa         IN varchar2,
                             p_RESULTNUMBER         OUT VARCHAR2) IS
    v_bd_error VARCHAR(1000);
    e_evento    exception;
    e_elegible  exception;
    e_InicioSFS exception; --Exception inicio Subsidio FR 2011-06-08

    v_nrosolicitud SUB_SOLICITUD_T.NRO_SOLICITUD%type;
  BEGIN

    --Validar si la fecha de la muerte de la madre es menor a la fecha de inicio del Subsdio
    --FR 2011-06-08--
    if MenorInicioSubsidios(p_FECHA_MUERTE) then
      raise e_InicioSFS;
    end if;

    --Buscando la mayor solicitud para este NSS
    select NVL(max(s.nro_solicitud), 0)
      into v_nrosolicitud
      from sub_solicitud_t s
     where s.nss = p_ID_NSS
       and s.tipo_subsidio = 'M';

    update sub_maternidad_t m
       set m.fecha_defuncion_madre   = p_FECHA_MUERTE,
           m.estatus                 = 'FA',
           m.id_registro_patronal_mm = p_ID_REGISTRO_PATRONAL,
           m.fecha_registro_mm       = sysdate,
           m.usuario_mm              = p_ULT_USUARIO_ACT,
           m.ult_fecha_act           = sysdate,
           m.ult_usuario_act         = p_ULT_USUARIO_ACT
     where m.nro_solicitud = v_nrosolicitud;

    --Crear el evento
    crearEvento(v_nrosolicitud, 'MM', sysdate, sysdate, p_RESULTNUMBER);

    if (p_RESULTNUMBER != '0') then
      RETURN; --Salgo, pero la variable de error ya esta llena
    end if;

    if p_esRetroativa = 'NO' then
      commit;
    end if;

    p_resultNumber := '0';
  exception
    when e_InicioSFS then
      ROLLBACK;
      p_resultNumber := Seg_Retornar_Cadena_Error(550, NULL, NULL);
      return;
    WHEN OTHERS THEN
      v_bd_error     := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultNumber := Seg_Retornar_Cadena_Error(-1, v_bd_error, SQLCODE);
  END;
  ----------------------------------------------------------------------------------------
  --- Metodo que crea la fecha perdida de embarazo
  ----------------------------------------------------------------------------------------
  PROCEDURE crearPerdidaEmbarazo(p_ID_REGISTRO_PATRONAL IN sub_maternidad_t.id_registro_patronal_pe%type,
                                 p_FECHA_PERDIDA        in sub_maternidad_t.fecha_perdida%type,
                                 p_ULT_USUARIO_ACT      IN sub_maternidad_t.ult_usuario_act%type,
                                 p_esRetroativa         in varchar2,
                                 p_NRO_SOLICITUD        IN SUB_SOLICITUD_T.NRO_SOLICITUD%type,
                                 p_RESULTNUMBER         OUT VARCHAR2) IS
    v_bd_error          VARCHAR(1000);
    v_fecha_diagnostico sub_maternidad_t.fecha_diagnostico%type;
    e_evento    exception;
    e_elegible  exception;
    e_InicioSFS exception; --Exception inicio Subsidio FR 2011-06-08

  BEGIN

    --Buscando el NSS
    select m.fecha_diagnostico
      into v_fecha_diagnostico
      from sub_maternidad_t m
     where m.nro_solicitud = p_NRO_SOLICITUD;

    --Compara la fecha de la perdida del embarazo y la fecha del diagnostico del embarazo.
    If p_FECHA_PERDIDA < v_fecha_diagnostico Then
      p_RESULTNUMBER := Seg_Retornar_Cadena_Error(47, NULL, NULL);
      p_RESULTNUMBER := Substr(p_RESULTNUMBER,
                               Instr(p_RESULTNUMBER, '|') + 1,
                               Length(p_RESULTNUMBER));
      RETURN;
    End if;

    --Validar si la fecha de perdida es menor a la fecha de inicio del Subsdio
    --FR 2011-06-08--
    if MenorInicioSubsidios(p_FECHA_PERDIDA) then
      raise e_InicioSFS;
    end if;

    update sub_maternidad_t m
       set m.fecha_perdida           = p_FECHA_PERDIDA,
           m.fecha_registro_pe       = sysdate,
           m.usuario_pe              = p_ULT_USUARIO_ACT,
           m.estatus                 = 'IN',
           m.id_registro_patronal_pe = p_ID_REGISTRO_PATRONAL,
           m.ult_fecha_act           = sysdate,
           m.ult_usuario_act         = p_ULT_USUARIO_ACT
     where m.nro_solicitud = p_NRO_SOLICITUD;

    --Crear el evento
    crearEvento(p_NRO_SOLICITUD, 'PE', sysdate, sysdate, p_RESULTNUMBER);

    if (p_RESULTNUMBER != '0') then
      RETURN; --Salgo, pero la variable de error ya esta llena
    end if;

    if p_esRetroativa = 'NO' then
      commit;
    end if;
    p_resultNumber := '0';
  exception
    when e_InicioSFS then
      ROLLBACK;
      p_resultNumber := Seg_Retornar_Cadena_Error(550, NULL, NULL);
      return;

    WHEN OTHERS THEN
      v_bd_error     := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultNumber := Seg_Retornar_Cadena_Error(-1, v_bd_error, SQLCODE);
  END;

  ----------------------------------------------------------------------------------------
  --- Metodo para registrar la muerte del lactante
  ----------------------------------------------------------------------------------------
  Procedure crearMuerteLactante(p_ID_NSS                IN SUB_SOLICITUD_T.NSS%type,
                                p_ID_REGISTRO_PATRONAL  IN SUB_LACTANTES_T.ID_REGISTRO_PATRONAL_ML%type,
                                p_ID_LACTANTE           IN SUB_LACTANTES_T.ID_LACTANTE%type,
                                p_FECHA_MUERTE_LACTANTE IN SUB_LACTANTES_T.FECHA_REGISTRO_ML%type,
                                p_ULT_USUARIO_ACT       IN SUB_LACTANTES_T.ULT_USUARIO_ACT%type,
                                p_RESULTNUMBER          OUT VARCHAR2) IS
    v_nrosolicitud suirplus.sub_solicitud_t.nro_solicitud%type;
    v_idlactante   suirplus.sub_lactantes_t.id_lactante%type;
    v_fecha_nac    suirplus.sub_lactantes_t.fecha_registro_nc%type;
    e_error     exception;
    e_InicioSFS exception; -- Exception inicio Subsidio FR 2011-06-08

    v_bd_error VARCHAR(1000);
  Begin
    --para obtener el numero de solicitud
    Begin
      Select sol.NRO_SOLICITUD, lac.id_lactante, lac.fecha_registro_nc
        Into v_nrosolicitud, v_idlactante, v_fecha_nac
        From sub_lactantes_t lac
        Join sub_solicitud_t sol
          on sol.nro_solicitud = lac.nro_solicitud
         And sol.nss = p_ID_NSS
         And sol.tipo_subsidio = 'L'
       Where lac.id_lactante = p_ID_LACTANTE
         And lac.estatus = 'AC';
    Exception
      When No_Data_Found Then
        p_RESULTNUMBER := Seg_Retornar_Cadena_Error(48, NULL, NULL);
        p_RESULTNUMBER := Substr(p_RESULTNUMBER,
                                 Instr(p_RESULTNUMBER, '|') + 1,
                                 Length(p_RESULTNUMBER));
        RETURN; --Salgo, pero la variable de error ya esta llena
    End;

    --Validamos si la madre esta activa en nomina
    If Not
        SUB_SFS_VALIDACIONES.IsActivaNomina(p_ID_NSS, p_ID_REGISTRO_PATRONAL) Then
      p_RESULTNUMBER := 'La madre no est? activa en n?mina';
      RETURN; --Salgo, pero la variable de error ya esta llena
    End if;

    /*   --Validamos si la madre esta activa en nomina
    If Not
        SUB_SFS_VALIDACIONES.estaEnUnaNP(p_ID_NSS, p_FECHA_MUERTE_LACTANTE) Then
      p_RESULTNUMBER := 'La madre no aparece en la NP de ese periodo';
      RETURN; --Salgo, pero la variable de error ya esta llena
    End if;*/

    --Validar la fecha de la muerte
    If (Trunc(p_FECHA_MUERTE_LACTANTE) < Trunc(v_fecha_nac)) Then
      p_RESULTNUMBER := Seg_Retornar_Cadena_Error(49, NULL, NULL);
      p_RESULTNUMBER := Substr(p_RESULTNUMBER,
                               Instr(p_RESULTNUMBER, '|') + 1,
                               Length(p_RESULTNUMBER));
      RETURN; --Salgo, pero la variable de error ya esta llena
    Elsif Trunc(p_FECHA_MUERTE_LACTANTE) > Trunc(sysdate) Then
      p_RESULTNUMBER := Seg_Retornar_Cadena_Error(50, NULL, NULL);
      p_RESULTNUMBER := Substr(p_RESULTNUMBER,
                               Instr(p_RESULTNUMBER, '|') + 1,
                               Length(p_RESULTNUMBER));
      RETURN; --Salgo, pero la variable de error ya esta llena
    End if;

    --Validar si la fecha de la muerte del lactante es menor a la fecha de inicio del Subsdio
    --FR 2011-06-08--
    if MenorInicioSubsidios(p_FECHA_MUERTE_LACTANTE) then
      raise e_InicioSFS;
    end if;

    --Actualizamos el lactante con los datos recibidos como parametros
    Update suirplus.sub_lactantes_t lac
       Set lac.id_registro_patronal_ml = p_ID_REGISTRO_PATRONAL,
           lac.fecha_registro_ml       = sysdate,
           lac.fecha_defuncion         = p_FECHA_MUERTE_LACTANTE,
           lac.ult_fecha_act           = sysdate,
           lac.ult_usuario_act         = p_ULT_USUARIO_ACT,
           lac.usuario_ml              = p_ULT_USUARIO_ACT,
           lac.estatus                 = 'FA'
     Where lac.id_lactante = v_idlactante;

    --Crear el evento de muerte del lactante
    crearEvento(v_nrosolicitud, 'ML', sysdate, sysdate, p_RESULTNUMBER);

    if (p_RESULTNUMBER != '0') then
      RETURN; --Salgo, pero la variable de error ya esta llena
    end if;

    COMMIT;
    p_RESULTNUMBER := '0';
  Exception
    when e_InicioSFS then
      ROLLBACK;
      p_resultNumber := Seg_Retornar_Cadena_Error(550, NULL, NULL);
      return;
    When Others Then
      v_bd_error     := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultNumber := Seg_Retornar_Cadena_Error(-1, v_bd_error, SQLCODE);
      ROLLBACK;
  End crearMuerteLactante;

  ----------------------------------------------------------------------------------------
  --- Metodo para llamar todos los que crean los registros de subsidios
  ----------------------------------------------------------------------------------------
  Procedure Registro_Embarazo_Rectroactivo(
                                           -- Parametros para registrar el Embarazo
                                           p_ID_NSS               IN SUB_SOLICITUD_T.NSS%type,
                                           p_TELEFONO             IN SUB_MATERNIDAD_T.TELEFONO%type,
                                           p_CELULAR              IN SUB_MATERNIDAD_T.CELULAR%type,
                                           p_EMAIL                IN SUB_MATERNIDAD_T.EMAIL%type,
                                           p_FECHA_DIAGNOSTICO    IN SUB_MATERNIDAD_T.FECHA_DIAGNOSTICO%type,
                                           p_FECHA_ESTIMADA_PARTO IN SUB_MATERNIDAD_T.FECHA_ESTIMADA_PARTO%type,
                                           p_NSS_TUTOR            IN SUB_MATERNIDAD_T.NSS_TUTOR%type,
                                           p_TELEFONO_TUTOR       IN SUB_MATERNIDAD_T.TELEFONO_TUTOR%type,
                                           p_EMAIL_TUTOR          IN SUB_MATERNIDAD_T.EMAIL_TUTOR%type,
                                           p_ULT_USUARIO_ACT      IN SUB_MATERNIDAD_T.ULT_USUARIO_ACT%type,
                                           p_ID_REGISTRO_PATRONAL IN SUB_MATERNIDAD_T.ID_REGISTRO_PATRONAL_RE%type,
                                           p_esRetroativa         IN VARCHAR2,
                                           -- Parametro para registrar la licencia
                                           p_FECHA_LICENCIA        IN SUB_SFS_MATERNIDAD_T.FECHA_LICENCIA%type,
                                           p_TIPO_LICENCIA         IN SUB_SFS_MATERNIDAD_T.TIPO_LICENCIA%type,
                                           p_TIPO_FORMULARIO       IN SUB_FORMULARIOS_T.TIPO_FORMULARIO%type,
                                           p_ID_PSS_MED            IN SUB_FORMULARIOS_T.ID_PSS_MED%type,
                                           p_NO_DOCUMENTO_MED      IN SUB_FORMULARIOS_T.NO_DOCUMENTO_MED%type,
                                           p_NOMBRE_MED            IN SUB_FORMULARIOS_T.NOMBRE_MED%type,
                                           p_DIRECCION_MED         IN SUB_FORMULARIOS_T.DIRECCION_MED%type,
                                           p_TELEFONO_MED          IN SUB_FORMULARIOS_T.TELEFONO_MED%type,
                                           p_CELULAR_MED           IN SUB_FORMULARIOS_T.CELULAR_MED%type,
                                           p_EMAIL_MED             IN SUB_FORMULARIOS_T.EMAIL_MED%type,
                                           p_ID_PSS_CEN            IN SUB_FORMULARIOS_T.ID_PSS_CEN%type,
                                           p_NOMBRE_CEN            IN SUB_FORMULARIOS_T.NOMBRE_CEN%type,
                                           p_DIRECCION_CEN         IN SUB_FORMULARIOS_T.DIRECCION_CEN%type,
                                           p_TELEFONO_CEN          IN SUB_FORMULARIOS_T.TELEFONO_CEN%type,
                                           p_FAX_CEN               IN SUB_FORMULARIOS_T.FAX_CEN%type,
                                           p_EMAIL_CEN             IN SUB_FORMULARIOS_T.EMAIL_CEN%type,
                                           p_EXEQUATUR             IN SUB_FORMULARIOS_T.EXEQUATUR%type,
                                           p_DIAGNOSTICO           IN SUB_FORMULARIOS_T.DIAGNOSTICO%type,
                                           p_SIGNOS_SINTOMAS       IN SUB_FORMULARIOS_T.SIGNOS_SINTOMAS%type,
                                           p_PROCEDIMIENTOS        IN SUB_FORMULARIOS_T.PROCEDIMIENTOS%type,
                                           p_FECHA_DIAGNOSTICO_LIC IN SUB_FORMULARIOS_T.FECHA_DIAGNOSTICO%type,
                                           -- Parametros para el nacimiento
                                           p_cant_lactantes   IN sub_sfs_lactancia_t.cant_lactantes%type,
                                           p_fecha_nacimiento IN sub_sfs_lactancia_t.fecha_nacimiento%type,
                                           -- Parametro para los lactantes
                                           p_DATOS_LACTANTES IN VARCHAR2,
                                           -- Parametro para la muerte de la madre
                                           p_FECHA_MUERTE IN sub_maternidad_t.fecha_defuncion_madre%type,
                                           -- Parametro para la perdida del embarazo
                                           p_FECHA_PERDIDA IN sub_maternidad_t.fecha_perdida%type,
                                           -- Numero de solicitud creado
                                           P_NRO_SOLICITUD IN OUT SUB_SOLICITUD_T.NRO_SOLICITUD%type,
                                           -- Parametro para indicar si es una reconsideracion o no
                                           P_MODO IN VARCHAR2,
                                           -- Parametro para retener el resultado de la corrida
                                           p_RESULTNUMBER OUT VARCHAR2) is
    v_bd_error          VARCHAR2(1000);
    v_ID_NSS_LACTANTE   SUB_LACTANTES_T.ID_NSS_LACTANTE%type;
    v_NUI               SUB_LACTANTES_T.NUI%type;
    v_NOMBRES           SUB_LACTANTES_T.NOMBRES%type;
    v_PRIMER_APELLIDO   SUB_LACTANTES_T.PRIMER_APELLIDO%type;
    v_SEGUNDO_APELLIDO  SUB_LACTANTES_T.SEGUNDO_APELLIDO%type;
    v_SEXO              SUB_LACTANTES_T.SEXO%type;
    v_DATOS_LACTANTES   VARCHAR2(4000) := p_DATOS_LACTANTES;
    v_nroFormulario     VARCHAR2(50);
    v_nro_solicitud     sub_solicitud_t.nro_solicitud%type;
    v_nro_solicitud_mat sub_solicitud_t.nro_solicitud%type;
    v_meses_parto       Number(2) := Parm.get_parm_number(348); --Hasta ahora 9 meses
    v_eliminamos_lactante  boolean := true;
  Begin

/*
    delete from dev;
    insert into dev
      (TEXTO)
    VALUES
      ('p_ID_NSS=' || p_ID_NSS || CHR(13) || 'p_TELEFONO=' || p_TELEFONO ||
       CHR(13) || 'p_CELULAR=' || p_CELULAR || CHR(13) || 'p_EMAIL=' ||
       p_EMAIL || CHR(13) || 'p_FECHA_DIAGNOSTICO=' || p_FECHA_DIAGNOSTICO ||
       CHR(13) || 'p_FECHA_ESTIMADA_PARTO=' || p_FECHA_ESTIMADA_PARTO ||
       CHR(13) || 'p_NSS_TUTOR=' || p_NSS_TUTOR || CHR(13) ||
       'p_TELEFONO_TUTOR=' || p_TELEFONO_TUTOR || CHR(13) ||
       'p_EMAIL_TUTOR=' || p_EMAIL_TUTOR || CHR(13) ||
       'p_ULT_USUARIO_ACT=' || p_ULT_USUARIO_ACT || CHR(13) ||
       'p_ID_REGISTRO_PATRONAL=' || p_ID_REGISTRO_PATRONAL || CHR(13) ||
       'p_esRetroativa=' || p_esRetroativa || CHR(13) ||
       'p_FECHA_LICENCIA=' || p_FECHA_LICENCIA || CHR(13) ||
       'p_TIPO_LICENCIA=' || p_TIPO_LICENCIA || CHR(13) ||
       'p_TIPO_FORMULARIO=' || p_TIPO_FORMULARIO || CHR(13) ||
       'p_ID_PSS_MED=' || p_ID_PSS_MED || CHR(13) || 'p_NO_DOCUMENTO_MED=' ||
       p_NO_DOCUMENTO_MED || CHR(13) || 'p_NOMBRE_MED=' || p_NOMBRE_MED ||
       CHR(13) || 'p_DIRECCION_MED=' || p_DIRECCION_MED || CHR(13) ||
       'p_TELEFONO_MED=' || p_TELEFONO_MED || CHR(13) || 'p_CELULAR_MED=' ||
       p_CELULAR_MED || CHR(13) || 'p_EMAIL_MED=' || p_EMAIL_MED ||
       CHR(13) || 'p_ID_PSS_CEN=' || p_ID_PSS_CEN || CHR(13) ||
       'p_NOMBRE_CEN=' || p_NOMBRE_CEN || CHR(13) || 'p_DIRECCION_CEN=' ||
       p_DIRECCION_CEN || CHR(13) || 'p_TELEFONO_CEN=' || p_TELEFONO_CEN ||
       CHR(13) || 'p_FAX_CEN=' || p_FAX_CEN || CHR(13) || 'p_EMAIL_CEN=' ||
       p_EMAIL_CEN || CHR(13) || 'p_EXECUATUR=' || p_EXEQUATUR || CHR(13) ||
       'p_DIAGNOSTICO=' || p_DIAGNOSTICO || CHR(13) ||
       'p_SIGNOS_SINTOMAS=' || p_SIGNOS_SINTOMAS || CHR(13) ||
       --'p_PRODECIMIENTOS='||p_PRODECIMIENTOS||CHR(13)||
       'p_FECHA_DIAGNOSTICO_LIC=' || p_FECHA_DIAGNOSTICO_LIC || CHR(13) ||
       'p_cant_lactantes=' || p_cant_lactantes || CHR(13) ||
       'p_fecha_nacimiento=' || p_fecha_nacimiento || CHR(13) ||
       'p_DATOS_LACTANTES=' || p_DATOS_LACTANTES || CHR(13) ||
       'p_FECHA_MUERTE=' || p_FECHA_MUERTE || CHR(13) ||
       'p_FECHA_PERDIDA=' || p_FECHA_PERDIDA);
    COMMIT;
*/
    -- Creamos el Embarazo
    If (UPPER(NVL(P_MODO, 'N')) = 'N') AND
       (p_FECHA_DIAGNOSTICO is not null) Then
      crearEmbarazo(p_ID_NSS,
                    p_TELEFONO,
                    p_CELULAR,
                    p_EMAIL,
                    p_FECHA_DIAGNOSTICO,
                    p_FECHA_ESTIMADA_PARTO,
                    p_NSS_TUTOR,
                    p_TELEFONO_TUTOR,
                    p_EMAIL_TUTOR,
                    p_ULT_USUARIO_ACT,
                    p_ID_REGISTRO_PATRONAL,
                    p_esRetroativa,
                    v_nroFormulario,
                    v_nro_solicitud_mat,
                    p_RESULTNUMBER);

      -- Evaluar el parametro de salida P_RESULTNUMBER para descartar la operacion en la base de datos
      If p_RESULTNUMBER != '0' Then
        Goto ABORTAR;
      End if;
    Elsif UPPER(P_MODO) = 'R' Then
      -- Reconsideracion
      -- Para actualizar la maternidad
     /* Update SUB_MATERNIDAD_T M
         Set M.FECHA_DIAGNOSTICO       = p_FECHA_DIAGNOSTICO,
             M.FECHA_ESTIMADA_PARTO    = p_FECHA_ESTIMADA_PARTO,
             M.ULT_USUARIO_ACT         = p_ULT_USUARIO_ACT,
             M.USUARIO_MOD             = p_ULT_USUARIO_ACT,
             M.FECHA_REGISTRO_MOD      = sysdate,
             M.TELEFONO                = p_TELEFONO,
             M.CELULAR                 = p_CELULAR,
             M.NSS_TUTOR               = p_NSS_TUTOR,
             M.EMAIL                   = p_EMAIL,
             M.EMAIL_TUTOR             = p_EMAIL_TUTOR,
             M.TELEFONO_TUTOR          = p_TELEFONO_TUTOR,
             M.ID_REGISTRO_PATRONAL_RE = p_ID_REGISTRO_PATRONAL,
             M.ESTATUS                 = 'AC',
             M.Tipo = 'R'
       Where M.NRO_SOLICITUD = P_NRO_SOLICITUD;*/

       SELECT sub_maternidad_seq.nextval INTO v_nro_solicitud_mat FROM dual;

       INSERT INTO SUB_MATERNIDAD_T
      (ID_MATERNIDAD,
       NRO_SOLICITUD,
       FECHA_DIAGNOSTICO,
       FECHA_ESTIMADA_PARTO,
       ULT_FECHA_ACT,
       ULT_USUARIO_ACT,
       ID_REGISTRO_PATRONAL_RE,
       FECHA_REGISTRO_RE,
       USUARIO_RE,
       TELEFONO,
       CELULAR,
       EMAIL,
       ESTATUS,
       NSS_TUTOR,
       EMAIL_TUTOR,
       TELEFONO_TUTOR,
       TIPO)
    VALUES
      (v_nro_solicitud_mat,
       P_NRO_SOLICITUD,
       p_FECHA_DIAGNOSTICO,
       p_FECHA_ESTIMADA_PARTO,
       sysdate,
       p_ULT_USUARIO_ACT,
       p_ID_REGISTRO_PATRONAL,
       sysdate,
       p_ULT_USUARIO_ACT,
       p_TELEFONO,
       p_CELULAR,
       p_EMAIL,
       'AC',
       p_NSS_TUTOR,
       p_EMAIL_TUTOR,
       p_TELEFONO_TUTOR,
       'R');

      v_nro_solicitud_mat := P_NRO_SOLICITUD;

      -- Si no se encuentra la solicitud
      If SQL%ROWCOUNT = 0 Then
        p_resultNumber := Seg_Retornar_Cadena_Error(181, NULL, NULL);
        Goto ABORTAR;
      End if;
    End if;

    -- Para crear el registro de la Licencia, aplica tanto para casos normales como para reconsideracion
    If (p_FECHA_LICENCIA is not null) Then
      crearLicencia(p_ID_NSS,
                    p_FECHA_LICENCIA,
                    p_ID_REGISTRO_PATRONAL,
                    p_ULT_USUARIO_ACT,
                    p_TIPO_LICENCIA,
                    p_TIPO_FORMULARIO,
                    v_NROFORMULARIO,
                    p_ID_PSS_MED,
                    p_NO_DOCUMENTO_MED,
                    p_NOMBRE_MED,
                    p_DIRECCION_MED,
                    p_TELEFONO_MED,
                    p_CELULAR_MED,
                    p_EMAIL_MED,
                    p_ID_PSS_CEN,
                    p_NOMBRE_CEN,
                    p_DIRECCION_CEN,
                    p_TELEFONO_CEN,
                    p_FAX_CEN,
                    p_EMAIL_CEN,
                    p_EXEQUATUR,
                    p_ULT_USUARIO_ACT,
                    p_DIAGNOSTICO,
                    p_SIGNOS_SINTOMAS,
                    p_PROCEDIMIENTOS,
                    p_FECHA_DIAGNOSTICO_LIC,
                    p_esRetroativa,
                    v_nro_solicitud_mat, --Se pasa aqui el nro_solicitud que se acaba de crear
                    p_MODO,
                    p_RESULTNUMBER --Se recibe el resultado de la corrida
                    );

      -- Evaluar el parametro de salida P_RESULTNUMBER para descartar la operacion en la base de datos
      If p_RESULTNUMBER != '0' Then
        Goto ABORTAR;
      End if;
    End If;

    -- Creamos el registro resumen del nacimiento solo en modo NORMAL
    If (UPPER(NVL(P_MODO, 'N')) = 'N') AND (p_FECHA_NACIMIENTO is not null) Then
      --Los meses entre la fecha diagnostico de embarazo y fecha de licencia no deben exceder los 9 meses
      If ABS(MONTHS_BETWEEN(p_FECHA_NACIMIENTO, p_FECHA_DIAGNOSTICO)) >
         v_meses_parto Then
        p_RESULTNUMBER := Seg_Retornar_Cadena_Error(52, NULL, NULL);
        Goto ABORTAR;
      End if;

      crearNacimiento(p_ID_NSS,
                      p_ID_REGISTRO_PATRONAL,
                      p_cant_lactantes,
                      p_fecha_nacimiento,
                      p_esRetroativa,
                      v_nro_solicitud_mat,
                      v_nro_solicitud,
                      'N',
                      p_RESULTNUMBER);

      -- Evaluar el parametro de salida P_RESULTNUMBER para descartar la operacion en la base de datos
      If p_RESULTNUMBER != '0' Then
        Goto ABORTAR;
      End if;
      
      -- Para iterar sobre la cadena que contiene la data de los lactantes
      Loop
        Exit When v_DATOS_LACTANTES is null;

        --Tomo desde la posicion 1 de la cadena hasta el caracter antes del PIPE
        v_ID_NSS_LACTANTE := Substr(v_datos_lactantes,
                                    1,
                                    instr(v_datos_lactantes, '|') - 1);
        -- Le resto a la cadena la data desde la posicion 1 hasta despues del PIPE
        v_DATOS_LACTANTES := substr(v_DATOS_LACTANTES,
                                    instr(v_datos_lactantes, '|') + 1,
                                    length(v_datos_lactantes));

        v_NUI             := Substr(v_datos_lactantes,
                                    1,
                                    instr(v_datos_lactantes, '|') - 1);
        v_DATOS_LACTANTES := substr(v_DATOS_LACTANTES,
                                    instr(v_datos_lactantes, '|') + 1,
                                    length(v_datos_lactantes));

        v_NOMBRES         := Substr(v_datos_lactantes,
                                    1,
                                    instr(v_datos_lactantes, '|') - 1);
        v_DATOS_LACTANTES := substr(v_DATOS_LACTANTES,
                                    instr(v_datos_lactantes, '|') + 1,
                                    length(v_datos_lactantes));

        v_PRIMER_APELLIDO := Substr(v_datos_lactantes,
                                    1,
                                    instr(v_datos_lactantes, '|') - 1);
        v_DATOS_LACTANTES := substr(v_DATOS_LACTANTES,
                                    instr(v_datos_lactantes, '|') + 1,
                                    length(v_datos_lactantes));

        v_SEGUNDO_APELLIDO := Substr(v_datos_lactantes,
                                     1,
                                     instr(v_datos_lactantes, '|') - 1);
        v_DATOS_LACTANTES  := substr(v_DATOS_LACTANTES,
                                     instr(v_datos_lactantes, '|') + 1,
                                     length(v_datos_lactantes));

        v_SEXO            := Substr(v_datos_lactantes,
                                    1,
                                    instr(v_datos_lactantes, '|') - 1);
        v_DATOS_LACTANTES := substr(v_DATOS_LACTANTES,
                                    instr(v_datos_lactantes, '|') + 1,
                                    length(v_datos_lactantes));


      /*Borramos los lactantes en caso de que sea una reconsideracion para re-insertarlos nuevamente*/
      If UPPER(P_MODO) = 'R' and v_eliminamos_lactante = true Then
       --Borrando los lactantes
         Delete from sub_lactantes_t la
         Where la.nro_solicitud = v_nro_solicitud;

         /*Asignamos el valor false a la variable para que no elimine nuevamente los lactantes*/
         v_eliminamos_lactante:= false;
      End if;

       -- descompuesta la cadena creamos el lactante
        CrearLactantes(v_id_nss_lactante,
                       v_nui,
                       v_nombres,
                       v_primer_apellido,
                       v_segundo_apellido,
                       v_sexo,
                       p_ult_usuario_act,
                       p_id_registro_patronal,
                       p_esRetroativa,
                       v_nro_solicitud,
                       P_MODO,
                       p_RESULTNUMBER);

        -- Evaluar el parametro de salida P_RESULTNUMBER para descartar la operacion en la base de datos
        If p_resultNumber != '0' Then
          goto ABORTAR;
        End if;
      End Loop;
    End if;

    -- Registramos la muerte de la madre solo en modo NORMAL
    If (UPPER(NVL(P_MODO, 'N')) = 'N') AND (p_FECHA_MUERTE is not null) Then
      crearMuerteMadre(p_ID_NSS,
                       p_ID_REGISTRO_PATRONAL,
                       p_FECHA_MUERTE,
                       p_ULT_USUARIO_ACT,
                       p_esRetroativa,
                       p_RESULTNUMBER);

      -- Evaluar el parametro de salida P_RESULTNUMBER para descartar la operacion en la base de datos
      If p_resultNumber != '0' Then
        goto ABORTAR;
      End if;
    End if;

    -- Registramos la perdida del embarazo solo en modo NORMAL
    If (UPPER(NVL(P_MODO, 'N')) = 'N') AND (p_FECHA_PERDIDA is not null) Then
      --Los meses entre la fecha diagnostico de embarazo y fecha de licencia no deben exceder los 9 meses
      If ABS(MONTHS_BETWEEN(p_FECHA_PERDIDA, p_FECHA_DIAGNOSTICO)) >
         v_meses_parto Then
        p_RESULTNUMBER := Seg_Retornar_Cadena_Error(53, NULL, NULL);
        Goto ABORTAR;
      End if;

      crearPerdidaEmbarazo(p_ID_REGISTRO_PATRONAL,
                           p_FECHA_PERDIDA,
                           p_ULT_USUARIO_ACT,
                           p_esRetroativa,
                           v_nro_solicitud_mat,
                           p_RESULTNUMBER);

      -- Evaluar el parametro de salida P_RESULTNUMBER para descartar la operacion en la base de datos
      If p_resultNumber != '0' Then
        goto ABORTAR;
      End if;
    End if;

    p_resultNumber  := '0';
    P_NRO_SOLICITUD := v_nro_solicitud_mat;
    COMMIT;

    -- Esto provoca que se rompa la ejecuci?n del paquete con la varia resultado llena
    -- y de pado no toca la instruccion que sigue al label "ABORTAR" donde se da un ROLLBACK
    -- inncesario si todo sali? bien.
    RETURN;

    <<ABORTAR>>
    ROLLBACK;
  Exception
    When Others Then
      v_bd_error     := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultNumber := Seg_Retornar_Cadena_Error(-1, v_bd_error, SQLCODE);
      ROLLBACK;
  End Registro_Embarazo_Rectroactivo;

  -----------------------------------------------------------------------------------------
  --- Metodo para traer todos los lactantes activos y pendientes de aprobacion de una madre
  -----------------------------------------------------------------------------------------
  Procedure getLactantes(p_ID_NSS       IN suirplus.sub_solicitud_t.nss%type,
                         p_iocursor     OUT t_cursor,
                         p_RESULTNUMBER OUT VARCHAR2) is
    v_bd_error VARCHAR2(1000);
  Begin
    open p_iocursor for
      Select lac.secuencia_lactante Secuencia,
             lac.id_nss_lactante NSS,
             Initcap(lac.Nombres) || ' ' || Initcap(lac.primer_apellido) || ' ' ||
             Initcap(lac.segundo_apellido) Nombres,
             lac.fecha_registro_nc FechaNacimiento,
             lac.id_lactante
        From suirplus.sub_solicitud_t sol
        Join suirplus.sub_sfs_lactancia_t sub
          on sub.nro_solicitud = sol.nro_solicitud
         and sub.id_estatus != 3
        Join suirplus.sub_lactantes_t lac
          on lac.nro_solicitud = sol.nro_solicitud
         and lac.estatus = 'AC'
       Where sol.nss = p_ID_NSS
         And sol.tipo_subsidio = 'L';

    p_RESULTNUMBER := '0';
  Exception
    When Others Then
      v_bd_error     := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultNumber := Seg_Retornar_Cadena_Error(-1, v_bd_error, SQLCODE);
  End;

  -----------------------------------------------------------------------------------------------
  --- Metodo para llamar todos los metodos que intevienen en la cracion de la licencia POST-NATAL
  -----------------------------------------------------------------------------------------------
  Procedure Registro_Licencia_Post_Natal(
                                         -- Parametros para registrar el Embarazo
                                         p_ID_NSS               IN SUB_SOLICITUD_T.NSS%type,
                                         p_ULT_USUARIO_ACT      IN SUB_SFS_MATERNIDAD_T.USUARIO_REGISTRO%type,
                                         p_ID_REGISTRO_PATRONAL IN SUB_SFS_MATERNIDAD_T.ID_REGISTRO_PATRONAL%type,
                                         -- Parametro para registrar la licencia
                                         p_FECHA_LICENCIA        IN SUB_SFS_MATERNIDAD_T.FECHA_LICENCIA%type,
                                         p_ID_PSS_MED            IN SUB_FORMULARIOS_T.ID_PSS_MED%type,
                                         p_NO_DOCUMENTO_MED      IN SUB_FORMULARIOS_T.NO_DOCUMENTO_MED%type,
                                         p_NOMBRE_MED            IN SUB_FORMULARIOS_T.NOMBRE_MED%type,
                                         p_DIRECCION_MED         IN SUB_FORMULARIOS_T.DIRECCION_MED%type,
                                         p_TELEFONO_MED          IN SUB_FORMULARIOS_T.TELEFONO_MED%type,
                                         p_CELULAR_MED           IN SUB_FORMULARIOS_T.CELULAR_MED%type,
                                         p_EMAIL_MED             IN SUB_FORMULARIOS_T.EMAIL_MED%type,
                                         p_ID_PSS_CEN            IN SUB_FORMULARIOS_T.ID_PSS_CEN%type,
                                         p_NOMBRE_CEN            IN SUB_FORMULARIOS_T.NOMBRE_CEN%type,
                                         p_DIRECCION_CEN         IN SUB_FORMULARIOS_T.DIRECCION_CEN%type,
                                         p_TELEFONO_CEN          IN SUB_FORMULARIOS_T.TELEFONO_CEN%type,
                                         p_FAX_CEN               IN SUB_FORMULARIOS_T.FAX_CEN%type,
                                         p_EMAIL_CEN             IN SUB_FORMULARIOS_T.EMAIL_CEN%type,
                                         p_EXEQUATUR             IN SUB_FORMULARIOS_T.EXEQUATUR%type,
                                         p_DIAGNOSTICO           IN SUB_FORMULARIOS_T.DIAGNOSTICO%type,
                                         p_SIGNOS_SINTOMAS       IN SUB_FORMULARIOS_T.SIGNOS_SINTOMAS%type,
                                         p_PROCEDIMIENTOS        IN SUB_FORMULARIOS_T.PROCEDIMIENTOS%type,
                                         p_FECHA_DIAGNOSTICO_LIC IN SUB_FORMULARIOS_T.FECHA_DIAGNOSTICO%type,
                                         -- Parametros para el nacimiento
                                         p_cant_lactantes   IN sub_sfs_lactancia_t.cant_lactantes%type,
                                         p_fecha_nacimiento IN sub_sfs_lactancia_t.fecha_nacimiento%type,
                                         -- Parametro para los lactantes
                                         p_DATOS_LACTANTES IN VARCHAR2,
                                         -- Numero de solicitud creado
                                         P_NRO_SOLICITUD IN OUT SUB_SOLICITUD_T.NRO_SOLICITUD%type,
                                         -- Parametro para retener el resultado de la corrida
                                         p_RESULTNUMBER OUT VARCHAR2) is
    v_bd_error         VARCHAR2(1000);
    v_ID_NSS_LACTANTE  SUB_LACTANTES_T.ID_NSS_LACTANTE%type;
    v_NUI              SUB_LACTANTES_T.NUI%type;
    v_NOMBRES          SUB_LACTANTES_T.NOMBRES%type;
    v_PRIMER_APELLIDO  SUB_LACTANTES_T.PRIMER_APELLIDO%type;
    v_SEGUNDO_APELLIDO SUB_LACTANTES_T.SEGUNDO_APELLIDO%type;
    v_SEXO             SUB_LACTANTES_T.SEXO%type;
    v_DATOS_LACTANTES  VARCHAR2(4000) := p_DATOS_LACTANTES;
    v_nroFormulario    VARCHAR2(50);
    v_nro_solicitud    sub_solicitud_t.nro_solicitud%type;
  Begin

    -- Para crear el registro de la Licencia, aplica tanto para casos normales como para reconsideracion
    If p_FECHA_LICENCIA is not null Then
      crearLicencia(p_ID_NSS,
                    p_FECHA_LICENCIA,
                    p_ID_REGISTRO_PATRONAL,
                    p_ULT_USUARIO_ACT,
                    'PO',
                    'M',
                    v_NROFORMULARIO,
                    p_ID_PSS_MED,
                    p_NO_DOCUMENTO_MED,
                    p_NOMBRE_MED,
                    p_DIRECCION_MED,
                    p_TELEFONO_MED,
                    p_CELULAR_MED,
                    p_EMAIL_MED,
                    p_ID_PSS_CEN,
                    p_NOMBRE_CEN,
                    p_DIRECCION_CEN,
                    p_TELEFONO_CEN,
                    p_FAX_CEN,
                    p_EMAIL_CEN,
                    p_EXEQUATUR,
                    p_ULT_USUARIO_ACT,
                    p_DIAGNOSTICO,
                    p_SIGNOS_SINTOMAS,
                    p_PROCEDIMIENTOS,
                    p_FECHA_DIAGNOSTICO_LIC,
                    'SI',
                    P_NRO_SOLICITUD, --Se pasa aqui el nro_solicitud que se acaba de crear
                    'N',
                    p_RESULTNUMBER --Se recibe el resultado de la corrida
                    );

      -- Evaluar el parametro de salida P_RESULTNUMBER para descartar la operacion en la base de datos
      If p_RESULTNUMBER != '0' Then
        Goto ABORTAR;
      End if;
    End If;

    -- Creamos el registro resumen del nacimiento solo en modo NORMAL
    If p_FECHA_NACIMIENTO is not null Then
      crearNacimiento(p_ID_NSS,
                      p_ID_REGISTRO_PATRONAL,
                      p_cant_lactantes,
                      p_fecha_nacimiento,
                      'SI',
                      p_NRO_SOLICITUD,
                      v_nro_solicitud,
                      'N',
                      p_RESULTNUMBER);

      -- Evaluar el parametro de salida P_RESULTNUMBER para descartar la operacion en la base de datos
      If p_RESULTNUMBER != '0' Then
        Goto ABORTAR;
      End if;

      -- Para iterar sobre la cadena que contiene la data de los lactantes
      Loop
        Exit When v_DATOS_LACTANTES is null;

        --Tomo desde la posicion 1 de la cadena hasta el caracter antes del PIPE
        v_ID_NSS_LACTANTE := Substr(v_datos_lactantes,
                                    1,
                                    instr(v_datos_lactantes, '|') - 1);
        -- Le resto a la cadena la data desde la posicion 1 hasta despues del PIPE
        v_DATOS_LACTANTES := substr(v_DATOS_LACTANTES,
                                    instr(v_datos_lactantes, '|') + 1,
                                    length(v_datos_lactantes));

        v_NUI             := Substr(v_datos_lactantes,
                                    1,
                                    instr(v_datos_lactantes, '|') - 1);
        v_DATOS_LACTANTES := substr(v_DATOS_LACTANTES,
                                    instr(v_datos_lactantes, '|') + 1,
                                    length(v_datos_lactantes));

        v_NOMBRES         := Substr(v_datos_lactantes,
                                    1,
                                    instr(v_datos_lactantes, '|') - 1);
        v_DATOS_LACTANTES := substr(v_DATOS_LACTANTES,
                                    instr(v_datos_lactantes, '|') + 1,
                                    length(v_datos_lactantes));

        v_PRIMER_APELLIDO := Substr(v_datos_lactantes,
                                    1,
                                    instr(v_datos_lactantes, '|') - 1);
        v_DATOS_LACTANTES := substr(v_DATOS_LACTANTES,
                                    instr(v_datos_lactantes, '|') + 1,
                                    length(v_datos_lactantes));

        v_SEGUNDO_APELLIDO := Substr(v_datos_lactantes,
                                     1,
                                     instr(v_datos_lactantes, '|') - 1);
        v_DATOS_LACTANTES  := substr(v_DATOS_LACTANTES,
                                     instr(v_datos_lactantes, '|') + 1,
                                     length(v_datos_lactantes));

        v_SEXO            := Substr(v_datos_lactantes,
                                    1,
                                    instr(v_datos_lactantes, '|') - 1);
        v_DATOS_LACTANTES := substr(v_DATOS_LACTANTES,
                                    instr(v_datos_lactantes, '|') + 1,
                                    length(v_datos_lactantes));

        -- descompuesta la cadena creamos el lactante
        CrearLactantes(v_id_nss_lactante,
                       v_nui,
                       v_nombres,
                       v_primer_apellido,
                       v_segundo_apellido,
                       v_sexo,
                       p_ult_usuario_act,
                       p_id_registro_patronal,
                       'SI',
                       v_nro_solicitud,
                       'N',
                       p_RESULTNUMBER);

        -- Evaluar el parametro de salida P_RESULTNUMBER para descartar la operacion en la base de datos
        If p_resultNumber != '0' Then
          goto ABORTAR;
        End if;
      End Loop;
    End if;

    p_resultNumber := '0';
    COMMIT;

    -- Esto provoca que se rompa la ejecuci?n del paquete con la varia resultado llena
    -- y de pado no toca la instruccion que sigue al label "ABORTAR" donde se da un ROLLBACK
    -- inncesario si todo sali? bien.
    RETURN;

    <<ABORTAR>>
    ROLLBACK;
  Exception
    When Others Then
      v_bd_error     := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultNumber := Seg_Retornar_Cadena_Error(-1, v_bd_error, SQLCODE);
      ROLLBACK;
  End Registro_Licencia_Post_Natal;

  ---------------------------------------------------------------------------------
  -- Procedure para hacer la pre-validacion del registro de Enfermedad Com?n
  ---------------------------------------------------------------------------------
  Procedure ValidarRegistroEnfermedadComun(p_NroDocumento     SRE_CIUDADANOS_T.NO_DOCUMENTO%TYPE,
                                           p_RegistroPatronal SRE_EMPLEADORES_T.ID_REGISTRO_PATRONAL%type,
                                           p_io_cursor        OUT t_cursor,
                                           p_ResultNumber     OUT varchar2) Is
    v_bd_error VARCHAR2(1000);
  Begin

    SUB_SFS_VALIDACIONES.ValidaDocumento(0, p_NroDocumento, p_ResultNumber);
    If p_ResultNumber != '0' Then
      RETURN;
    End if;

    If Not SUB_SFS_VALIDACIONES.IsActivaNomina(getNSS(p_NroDocumento),
                                               p_RegistroPatronal) then
      p_ResultNumber := Seg_Retornar_Cadena_Error(170, NULL, NULL);
      RETURN;
    End if;

    If SUB_SFS_VALIDACIONES.TieneSolicitudPendiente(p_NroDocumento) Then
      p_ResultNumber := Seg_Retornar_Cadena_Error(566, NULL, NULL);
      RETURN;
    End If;

    --Extraer los datos existen correspodiente a este Nro_Documento
    OPEN p_io_cursor For
      Select Sol.Nro_solicitud,
             Ec.Direccion,
             Ec.Telefono,
             Ec.Email,
             Ec.Celular
        From Sub_Solicitud_t Sol
        Join Sub_Enfermedad_Comun_t Ec
          On Ec.Nro_Solicitud = Sol.Nro_Solicitud
        Join Sub_Sfs_Enf_Comun_t sec
          On sec.nro_solicitud = Ec.Nro_Solicitud
         And sec.id_estatus = 1 --Pendiente
       Where Sol.Nss = getNSS(p_Nrodocumento);

    p_ResultNumber := '0';
  Exception
    When Others Then
      v_bd_error     := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultNumber := Seg_Retornar_Cadena_Error(-1, v_bd_error, SQLCODE);
  End;

  -- -------------------------------------------------------------------------
  -- Para registrar el registro en Sub_enfermedad_comun_t como pendiente
  ----------------------------------------------------------------------------
  Procedure RegistrarDatosInicialesEnf(p_id_nss           In sfs_enfermedad_comun_t.id_nss%Type Default 0,
                                       p_tipo_solicitud   In Varchar2,
                                       p_direccion        In sfs_enfermedad_comun_t.direccion%Type,
                                       p_telefono         In sfs_enfermedad_comun_t.telefono%Type,
                                       p_correo           In sfs_enfermedad_comun_t.email%Type,
                                       p_celular          In sfs_enfermedad_comun_t.celular%Type,
                                       p_usuario_registro In sfs_enfermedad_comun_t.usuario_registro%Type,
                                       p_Pin              Out Varchar2,
                                       p_nro_solicitud    In Out Varchar2,
                                       p_nro_formulario   Out sub_formularios_t.nro_formulario%type,
                                       p_resultNumber     Out Varchar2) Is
    v_registros    Integer := 0;
    v_padecimiento varchar2(10);
    v_sec          Integer := 0;
    v_bd_error     VARCHAR2(1000);
    v_nroSolicitud sub_solicitud_t.nro_solicitud%type;

  Begin
    If (UPPER(p_tipo_solicitud) = 'NUEVA') Then
      -- buscar el maximo padecimiento
      Select nvl(Max(Sol.Padecimiento), 0) + 1, 1 Sec
        Into v_Padecimiento, v_Sec
        From Sub_Solicitud_t Sol
       Where Sol.Nss = p_Id_Nss
         And Sol.Tipo_Subsidio = 'E';
    Elsif (UPPER(p_tipo_solicitud) = 'RENOVACION') Then
      Select Nvl(Sol.Padecimiento, 0)
        Into v_Padecimiento
        From Sub_Solicitud_t Sol
       Where Sol.Nro_Solicitud = p_nro_solicitud;

      Select Nvl(Max(Sol.Secuencia), 0) + 1
        Into v_Sec
        From Sub_Solicitud_t Sol
       Where Sol.Nss = p_id_nss
         And Sol.Padecimiento = v_padecimiento;
    End If;

    -- Ver si este Nss tiene algun registro pendiente.
    Select Count(*)
      Into v_Registros
      From sub_Solicitud_t Sol
      Join Sub_Sfs_Enf_Comun_t Ec
        On Ec.Nro_Solicitud = Sol.Nro_Solicitud
       And Ec.Id_estatus = 1 --'PE'
     Where Sol.Nss = p_Id_Nss;

    If (v_Registros > 0) Then
      p_ResultNumber := Seg_Retornar_Cadena_Error(558, NULL, NULL);
      RETURN;
    End If;

    --Crear la solicitud correspondiente a este subsidio--
    crearSolicitud(p_id_NSS,
                   v_padecimiento,
                   v_sec,
                   NULL,
                   'E',
                   'O',
                   NULL,
                   NULL,
                   v_nroSolicitud,
                   p_RESULTNUMBER);

    --Si no se pudo crear la solicitud abortamos el metodo
    If p_RESULTNUMBER != '0' Then
      RETURN;
    End if;

    --Creando el formulario
    crearFormulario(v_nroSolicitud,
                    'E',
                    LPAD(p_id_nss, 10, 0) || LPAD(v_padecimiento, 5, 0) ||
                    LPAD(v_sec, 3, 0),
                    NULL,
                    NULL,
                    NULL,
                    NULL,
                    NULL,
                    NULL,
                    NULL,
                    NULL,
                    NULL,
                    NULL,
                    NULL,
                    NULL,
                    NULL,
                    NULL,
                    NULL,
                    NULL,
                    NULL,
                    NULL,
                    NULL,
                    p_RESULTNUMBER);

    p_Pin := getPIN;

    WHILE verificarPin(p_Pin, p_id_nss) LOOP
       p_Pin := getPIN;
     END LOOP;

    --- Agregar el Registro de enfermedad comun ---
    Insert Into Sub_Enfermedad_Comun_t
      (id_enfermedad_comun,
       nro_solicitud,
       Direccion,
       Telefono,
       Email,
       Celular,
       Pin,
       fecha_registro,
       ult_usuario_act,
       ult_fecha_act)
    Values
      (sub_enfermedad_comun_seq.nextval,
       v_nroSolicitud,
       p_Direccion,
       p_Telefono,
       p_Correo,
       p_Celular,
       p_Pin,
       sysdate,
       p_usuario_registro,
       sysdate);

    v_registros := sql%rowcount;

    If (v_registros = 0) Then
      p_ResultNumber := Seg_Retornar_Cadena_Error(559, NULL, NULL);
      RETURN;
    End If;

    Commit;

    p_resultNumber   := '0';
    p_nro_formulario := LPAD(p_id_nss, 10, 0) || LPAD(v_padecimiento, 5, 0) ||
                        LPAD(v_sec, 3, 0);
  Exception
    When DUP_VAL_ON_INDEX THEN
      DECLARE
        v_mensaje varchar2(4000) := SQLERRM;
      BEGIN
        ROLLBACK;
        p_resultNumber := Seg_Retornar_Cadena_Error(666, NULL, NULL);          
        
        --Insertamos en la tabla de log SUB_LOG_T
        Insert into suirplus.sub_log_t
        (
         id_log,
         fecha,
         id_solicitud,
         mensaje
        )
        values
        (
         suirplus.sub_log_seq.nextval,
         sysdate,
         v_nro_solicitud,
         'CREACION DE ENFERMEDAD COMUN'||chr(13)||chr(10)||
         'ID_NSS: '||p_id_NSS||chr(13)||chr(10)||
         'SECUENCIA: '||v_nro_secuencia||chr(13)||chr(10)||
         'PADECIMIENTO: '||v_padecimiento||chr(13)||chr(10)||
         'TIPO SUBSIDIO: E'||chr(13)||chr(10)||
         'USUARIO: '||p_usuario_registro||chr(13)||chr(10)||
         'ERROR ORACLE: '||v_mensaje
        );
        commit;
      END;
      
    When Others Then
      v_bd_error     := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultNumber := Seg_Retornar_Cadena_Error(-1, v_bd_error, SQLCODE);
  End;

  -----------------------------------------------------------------------------
  -- Para registra el subsidio por efermedad comun
  ----------------------------------------------------------------------------
  Procedure RegistroEnfComun(p_id_nss               In sub_solicitud_t.nss%type,
                             p_Nro_Solicitud        In sub_enfermedad_comun_t.nro_solicitud%type,
                             p_Direccion            In sub_enfermedad_comun_t.direccion%Type,
                             p_Telefono             In sub_enfermedad_comun_t.telefono%Type,
                             p_Email                In sub_enfermedad_comun_t.email%Type,
                             p_Celular              In sub_enfermedad_comun_t.celular%Type,
                             p_ult_usuario          In sub_enfermedad_comun_t.ult_usuario_act%Type,
                             p_id_pss_med           In sub_formularios_t.id_pss_med%Type,
                             p_no_documento_med     In sub_formularios_t.no_documento_med%Type,
                             p_Nombre_med           In sub_formularios_t.nombre_med%Type,
                             p_Direccion_med        In sub_formularios_t.direccion_med%Type,
                             p_Telefono_med         In sub_formularios_t.telefono_med%Type,
                             p_celular_med          In sub_formularios_t.celular_med%Type,
                             p_Email_med            In sub_formularios_t.email_med%Type,
                             p_id_pss_cen           In sub_formularios_t.id_pss_cen%Type,
                             p_nombre_cen           In sub_formularios_t.nombre_cen%Type,
                             p_Direccion_cen        In sub_formularios_t.direccion_cen%Type,
                             p_Telefono_cen         In sub_formularios_t.telefono_cen%Type,
                             p_Fax_cen              In sub_formularios_t.fax_cen%Type,
                             p_Email_cen            In sub_formularios_t.email_cen%Type,
                             p_Tipo_Discapacidad    In sub_enfermedad_comun_t.tipo_discapacidad%Type,
                             p_Diagnostico          In sub_formularios_t.diagnostico%Type,
                             p_Signos_Sintomas      In sub_formularios_t.signos_sintomas%Type,
                             p_Procedimientos       In sub_formularios_t.procedimientos%Type,
                             p_Ambulatorio          In sub_enfermedad_comun_t.ambulatorio%Type,
                             p_Fecha_Inicio_amb     In sub_enfermedad_comun_t.fecha_inicio_amb%Type,
                             p_dias_cal_amb         In sub_enfermedad_comun_t.dias_cal_amb%Type,
                             p_Hospitalario         In sub_enfermedad_comun_t.hospitalizacion%Type,
                             p_Fecha_inicio_hos     In sub_enfermedad_comun_t.fecha_inicio_hos%Type,
                             p_dias_cal_hos         In sub_enfermedad_comun_t.dias_cal_hos%Type,
                             p_Fecha_Diagnostico    In sub_formularios_t.fecha_diagnostico%Type,
                             p_id_registro_patronal In sub_sfs_enf_comun_t.id_registro_patronal%type,
                             p_id_usuario           In sub_formularios_t.usuario_registro%type,
                             p_Codigo_CIE10         In sub_enfermedad_comun_t.codigocie10%Type,
                             p_Exequatur            In sub_formularios_t.exequatur%Type,
                             p_id_nomina            In sre_nominas_t.id_nomina%type,
                             p_Modo                 In Varchar2,
                             p_ResultNumber         Out varchar2) Is
    v_fecha_fin_licencia Date;
    v_fecha_termino_lic  Date;
    v_fecha_inicio       Date;

    v_fecha_ini_lic_ant Date;
    v_fecha_fin_lic_ant Date;

    v_padecimiento sub_solicitud_t.padecimiento%Type;
    v_sec_enf      sub_solicitud_t.secuencia%Type;
    v_Pin          sub_enfermedad_comun_t.pin%type;
    e_InicioSFS exception; -- Exception inicio Subsidio FR 2011-06-08
  Begin
    --Buscamos el padecimiento y la secuencia para esta solicitud--
    Select Sol.Padecimiento, Sol.Secuencia
      Into v_Padecimiento, v_Sec_Enf
      From Sub_Solicitud_t Sol
     Where Sol.Nro_Solicitud = p_Nro_Solicitud;

    --Validar si el NSS es valido
    If not SUB_SFS_VALIDACIONES.NroDocumentoValido(p_id_nss) then
      p_ResultNumber := Seg_Retornar_Cadena_Error(24, NULL, NULL);
      RETURN;
    End if;

    If Not
        SUB_SFS_VALIDACIONES.IsActivaNomina(p_id_nss, p_id_registro_patronal) then
      p_ResultNumber := Seg_Retornar_Cadena_Error(170, NULL, NULL);
      RETURN;
    End if;

    --Validar si el NroDocumento del medico es valido si este viene.
    If p_no_documento_med is not null then
      If not SUB_SFS_VALIDACIONES.NroDocumentoValido(p_no_documento_med) then
        p_ResultNumber := Seg_Retornar_Cadena_Error(562, NULL, NULL);
        RETURN;
      End if;
    End if;

    --Ambulatorio--
    If (p_Ambulatorio = 'S' And p_Hospitalario = 'N') then
      v_fecha_termino_lic  := p_Fecha_Inicio_amb + p_dias_cal_amb;
      v_fecha_fin_licencia := v_fecha_termino_lic + v_dias_calendario_enf;
      v_fecha_inicio       := p_Fecha_Inicio_amb;
      --Hospitalario--
    Elsif (p_Ambulatorio = 'N' And p_Hospitalario = 'S') then
      v_fecha_termino_lic  := p_Fecha_inicio_hos + p_dias_cal_hos;
      v_fecha_fin_licencia := v_fecha_termino_lic + v_dias_calendario_enf;
      v_fecha_inicio       := p_Fecha_inicio_hos;
      -- Ambos--
    Elsif (p_Ambulatorio = 'S' And p_Hospitalario = 'S') then
      --determinar la fecha de en que termina la licencia mas(+) los 60 dias calendario--
      If (p_Fecha_Inicio_amb > p_Fecha_inicio_hos) Then
        v_fecha_termino_lic  := p_Fecha_Inicio_amb + p_dias_cal_amb;
        v_fecha_fin_licencia := v_fecha_termino_lic + v_dias_calendario_enf;
      Else
        v_fecha_termino_lic  := p_Fecha_inicio_hos + p_dias_cal_hos;
        v_fecha_fin_licencia := v_fecha_termino_lic + v_dias_calendario_enf;
      End If;

      --determina la fecha de inicio de la licencia---
      --que es igual a la fecha menor de p_Fecha_Inicio_amb y p_Fecha_inicio_hos--
      If (nvl(p_Fecha_Inicio_amb, sysdate + 3000) <
         nvl(p_Fecha_inicio_hos, sysdate + 3000)) Then
        v_fecha_inicio := p_Fecha_Inicio_amb;
      Else
        v_fecha_inicio := p_Fecha_inicio_hos;
      End If;
    End if;

    --Validar si tiene 12 cotizaciones en los ultimo 12 meses anteriores al periodo anterior de la fecha de inicio de la licencia
    If SUB_SFS_VALIDACIONES.CotizacionesEnf(p_id_nss, v_fecha_inicio) < 12 then
      p_ResultNumber := Seg_Retornar_Cadena_Error(563, NULL, NULL);
      RETURN;
    End if;

    --Validar si se esta registrando durante la discapacidad o durante un plazo de sesenta dias calendarios
    --posteriores a la terminacion de la discapacidad.

    If (NVL(P_MODO, 'N') = 'N') then
        If (Trunc(Sysdate) >= Trunc(v_fecha_fin_licencia)) Then
           p_ResultNumber := Seg_Retornar_Cadena_Error(565, NULL, NULL);
           RETURN;
        End If;
    end if;



    --Validar si ese Trabajador tiene algun padecimeitno activo--
    If SUB_SFS_VALIDACIONES.TienePadecimientoActivo(p_id_nss,
                                                    p_id_registro_patronal) Then
      p_ResultNumber := Seg_Retornar_Cadena_Error(564, NULL, NULL);
      RETURN;
    End If;

    --Validar si este padecimeinto ya esta registrado--
    If (NVL(P_MODO, 'N') = 'N') AND
       (SUB_SFS_VALIDACIONES.ExistePadecimiento(p_id_nss,
                                                v_padecimiento,
                                                v_sec_enf,
                                                p_id_registro_patronal)) Then
      p_ResultNumber := Seg_Retornar_Cadena_Error(561, NULL, NULL);
      RETURN;
    End If;

    -- Validar si este registro esta pediente por completar----
    If SUB_SFS_VALIDACIONES.TienePadecimientoPendiente(p_Id_Nss,
                                                       v_Padecimiento,
                                                       v_Sec_Enf) Then
      p_ResultNumber := Seg_Retornar_Cadena_Error(571, NULL, NULL);
      RETURN;
    End If;

    --Validar si la fecha estimada de parto es menor a la fecha de inicio del Subsdio
    --FR 2011-06-08--
    If MenorInicioSubsidios(v_fecha_inicio) then
      raise e_InicioSFS;
    End if;

    -- Para evitar que se solapen con registros anteriores
    For r in (select e.*
                from sub_solicitud_t s
                join sub_sfs_enf_comun_t st
                  on st.nro_solicitud = s.nro_solicitud
                 and st.id_estatus != 3
                join sub_enfermedad_comun_t e
                  on e.nro_solicitud = s.nro_solicitud
                 and (e.fecha_inicio_amb is not null or
                     e.fecha_inicio_hos is not null)
               where s.nss = p_id_nss
                 and s.tipo_subsidio = 'E') Loop
      --Ambulatorio--
      If (r.Ambulatorio = 'S' And r.Hospitalizacion = 'N') then
        v_fecha_ini_lic_ant := r.Fecha_Inicio_amb;
        v_fecha_fin_lic_ant := (r.Fecha_Inicio_amb + r.dias_cal_amb) - 1;
        --Hospitalario--
      Elsif (r.Ambulatorio = 'N' And r.Hospitalizacion = 'S') then
        v_fecha_ini_lic_ant := r.Fecha_inicio_hos;
        v_fecha_fin_lic_ant := (r.Fecha_inicio_hos + r.dias_cal_hos) - 1;
        -- Ambos--
      Elsif (r.Ambulatorio = 'S' And r.Hospitalizacion = 'S') then
        --determinar la fecha de en que termina la licencia mas(+) los 60 dias calendario--
        If (r.Fecha_Inicio_amb > r.Fecha_inicio_hos) Then
          v_fecha_fin_lic_ant := (r.Fecha_Inicio_amb + r.dias_cal_amb) - 1;
        Else
          v_fecha_fin_lic_ant := (r.Fecha_inicio_hos + r.dias_cal_hos) - 1;
        End If;

        --determina la fecha de inicio de la licencia---
        --que es igual a la fecha menor de p_Fecha_Inicio_amb y p_Fecha_inicio_hos--
        If (nvl(r.Fecha_Inicio_amb, sysdate + 3000) <
           nvl(r.Fecha_inicio_hos, sysdate + 3000)) Then
          v_fecha_ini_lic_ant := r.Fecha_Inicio_amb;
        Else
          v_fecha_ini_lic_ant := r.Fecha_inicio_hos;
        End If;
      End if;

      If (v_fecha_inicio between v_fecha_ini_lic_ant and
         v_fecha_fin_lic_ant) or --inicio de la actual con la ya registrada
         (v_fecha_termino_lic between v_fecha_ini_lic_ant and
         v_fecha_fin_lic_ant) or -- fin de la actual con la ya registrada
         (v_fecha_ini_lic_ant between v_fecha_inicio and
         v_fecha_termino_lic) or --inicio de la anterior con la que se va a registrar
         (v_fecha_fin_lic_ant between v_fecha_inicio and
         v_fecha_termino_lic) Then
        --fin de la anterior con la que se va a registrar
        p_ResultNumber := Seg_Retornar_Cadena_Error(56, NULL, NULL);
        RETURN;
      End if;
    End Loop;

    --No es una Reconsideracion
    If Nvl(UPPER(p_Modo), 'N') = 'N' Then
      --Completamos la enfermedad com?n actualizando el estatus y los demas campos faltantes
      --al momento de la creaci?n del registro inicial
      Update Sub_Enfermedad_Comun_t Ec
         Set Ec.Completado        = 'S',
             Ec.Direccion         = p_Direccion,
             Ec.Telefono          = p_Telefono,
             Ec.Email             = p_Email,
             Ec.Celular           = p_Celular,
             Ec.Tipo_Discapacidad = p_Tipo_Discapacidad,
             Ec.Ambulatorio       = p_Ambulatorio,
             Ec.Fecha_Inicio_Amb  = p_Fecha_Inicio_amb,
             Ec.Dias_Cal_Amb      = p_dias_cal_amb,
             Ec.Hospitalizacion   = p_Hospitalario,
             Ec.Fecha_Inicio_Hos  = p_Fecha_inicio_hos,
             Ec.Dias_Cal_Hos      = p_dias_cal_hos,
             Ec.Codigocie10       = p_Codigo_CIE10,
             Ec.Fecha_Registro    = sysdate,
             Ec.Ult_Usuario_Act   = p_ult_usuario,
             Ec.Ult_Fecha_Act     = sysdate,
             Ec.tipo = 'O'
       Where Ec.Nro_Solicitud = p_Nro_Solicitud;

      If (SQL%ROWCOUNT = 0) Then
        p_ResultNumber := Seg_Retornar_Cadena_Error(559, NULL, NULL);
        ROLLBACK;
        RETURN;
      End If;
    Elsif UPPER(p_Modo) = 'R' Then
      --Reconsideracion
      v_Pin := getPIN;

    WHILE verificarPin(v_Pin, p_id_nss) LOOP
      v_Pin := getPIN;
     END LOOP;

      --- Agregar el Registro de enfermedad comun ---
      Insert Into Sub_Enfermedad_Comun_t
        (id_enfermedad_comun,
         nro_solicitud,
         Direccion,
         Telefono,
         Email,
         Celular,
         Pin,
         fecha_registro,
         ult_usuario_act,
         ult_fecha_act,
         Completado,
         Tipo_Discapacidad,
         Ambulatorio,
         Fecha_Inicio_Amb,
         Dias_Cal_Amb,
         Hospitalizacion,
         Fecha_Inicio_Hos,
         Dias_Cal_Hos,
         Codigocie10,
         Tipo)
      Values
        (sub_enfermedad_comun_seq.nextval,
         p_nro_Solicitud,
         p_Direccion,
         p_Telefono,
         p_Email,
         p_Celular,
         v_Pin,
         sysdate,
         p_id_usuario,
         sysdate,
         'S',
         p_Tipo_Discapacidad,
         p_Ambulatorio,
         p_Fecha_Inicio_amb,
         p_dias_cal_amb,
         p_Hospitalario,
         p_Fecha_inicio_hos,
         p_dias_cal_hos,
         p_Codigo_CIE10,
         'R');

      If (SQL%ROWCOUNT = 0) Then
        p_ResultNumber := Seg_Retornar_Cadena_Error(559, NULL, NULL);
        ROLLBACK;
        RETURN;
      End If;
    End if;

    --Completamos el formulario actualizando los demas campos faltantes
    --al momento de la creacion del registro inicial
    Update Sub_Formularios_t fm
       Set Fm.Id_Pss_Med        = p_Id_Pss_Med,
           Fm.No_Documento_Med  = p_No_Documento_Med,
           Fm.Nombre_Med        = p_Nombre_Med,
           Fm.Direccion_Med     = p_Direccion_Med,
           Fm.Telefono_Med      = p_Telefono_Med,
           Fm.Celular_Med       = p_Celular_Med,
           Fm.Email_Med         = p_Email_Med,
           Fm.Id_Pss_Cen        = p_Id_Pss_Cen,
           Fm.Nombre_Cen        = p_Nombre_Cen,
           Fm.Direccion_Cen     = p_Direccion_Cen,
           Fm.Telefono_Cen      = p_Telefono_Cen,
           Fm.Fax_Cen           = p_Fax_Cen,
           Fm.Email_Cen         = p_Email_Cen,
           Fm.Exequatur         = p_Exequatur,
           Fm.Diagnostico       = p_Diagnostico,
           Fm.Signos_Sintomas   = p_Signos_Sintomas,
           Fm.Procedimientos    = p_Procedimientos,
           Fm.Fecha_Diagnostico = p_Fecha_Diagnostico,
           Fm.Usuario_Registro  = p_id_usuario
     Where Fm.Nro_Solicitud = p_Nro_Solicitud;

    If (SQL%ROWCOUNT = 0) Then
      p_ResultNumber := Seg_Retornar_Cadena_Error(559, NULL, NULL);
      ROLLBACK;
      RETURN;
    End If;

    --Actualizamos la solicitud
    Update Sub_Solicitud_t Sol
       Set Sol.id_nomina = p_Id_Nomina
     Where Sol.Nro_Solicitud = p_Nro_Solicitud;

    If (SQL%ROWCOUNT = 0) Then
      p_ResultNumber := Seg_Retornar_Cadena_Error(559, NULL, NULL);
      ROLLBACK;
      RETURN;
    End If;

    --Creamos el elegible
    crearElegible(p_nro_solicitud,
                  p_ID_REGISTRO_PATRONAL,
                  NULL,
                  1, --Pendiente
                  NULL,
                  p_ID_NSS,
                  v_Sec_Enf,
                  NULL,
                  p_Modo,
                  v_fecha_inicio,
                  p_RESULTNUMBER);

    If (p_RESULTNUMBER != '0') Then
      ROLLBACK;
      RETURN;
    End If;

    --Creamos el historico de salario
    crearHistoricoSalario(p_nro_solicitud,
                          To_Number(to_char(ADD_MONTHS(v_fecha_inicio, -12),
                                            'YYYYMM')),
                          To_Number(to_char(ADD_MONTHS(v_fecha_inicio, -1),
                                            'YYYYMM')),
                          p_RESULTNUMBER);

    If (p_RESULTNUMBER != '0') Then
      ROLLBACK;
      RETURN;
    End If;

    If Nvl(UPPER(p_Modo), 'N') = 'N' Then
      --Creamos el subsidio para el elegible
      Insert Into Sub_Sfs_Enf_Comun_t a
        (id_sub_enf_comun,
         nro_solicitud,
         id_estatus,
         id_registro_patronal,
         ult_fecha_act,
         ult_usuario_act)
      Values
        (sub_sfs_enf_comun_seq.nextval,
         p_Nro_Solicitud,
         1,
         p_id_registro_patronal,
         sysdate,
         p_ult_usuario);
    Else
      --Actualizamos el subsidio conforme el estauts del elegible
      Update Sub_Sfs_Enf_Comun_t a
         Set id_estatus      = 1,
             ult_fecha_act   = sysdate,
             ult_usuario_act = p_ult_usuario
       Where nro_solicitud = p_Nro_Solicitud
         and id_registro_patronal = p_id_registro_patronal;
    End if;

    If (SQL%ROWCOUNT = 0) Then
      p_ResultNumber := Seg_Retornar_Cadena_Error(559, NULL, NULL);
      ROLLBACK;
      RETURN;
    End If;

    --Crear el evento
    crearEvento(p_nro_solicitud, 'LD', sysdate, sysdate, p_RESULTNUMBER);

    If (p_RESULTNUMBER != '0') Then
      ROLLBACK;
      RETURN;
    End If;

    Commit;

    p_ResultNumber := '0';
  Exception
    When e_InicioSFS then
      p_resultNumber := Seg_Retornar_Cadena_Error(550, NULL, NULL);

    When Others Then
      p_ResultNumber := 'Ocurrio el siguiente error : ' || ' ' || Sqlerrm;
  End;

  --------------------------------------------------------------
  --Devuelve todos los registros de enfermedad comun completados
  --------------------------------------------------------------
  procedure ObtenerPadecimientoCompletado(p_id_nss               IN sre_ciudadanos_t.id_nss%type,
                                          p_id_registro_patronal IN sre_empleadores_t.id_registro_patronal%type,
                                          p_io_cursor            OUT t_cursor,
                                          p_resultnumber         OUT VARCHAR2) IS
    v_bd_error VARCHAR2(1000);
  Begin
    Open p_io_cursor For
      Select distinct f.nro_formulario,
                      trunc(e.fecha_registro) fecha_registro,
                      f.diagnostico,
                      e.nro_solicitud
        From sub_solicitud_t s
        Join sub_enfermedad_comun_t e
          On e.nro_solicitud = s.nro_solicitud
         And NVL(e.completado, 'N') = 'S'
         And e.estatus = 'AC'
        Join sub_formularios_t f
          on f.nro_solicitud = e.nro_solicitud
        Join sub_sfs_enf_comun_t sec
          On sec.nro_solicitud = s.nro_solicitud
         And sec.id_registro_patronal = p_id_registro_patronal
         And sec.id_estatus in (4, 2)
       Where s.nss = p_id_nss
         And s.tipo_subsidio = 'E'
         And not exists
       (select 1
                from sub_reintegro_t r
               where r.nro_solicitud = s.nro_solicitud)
         And (s.padecimiento, s.secuencia) in
             (Select padecimiento, Max(secuencia)
                From sub_solicitud_t s
                Join sub_sfs_enf_comun_t sec
                  On sec.nro_solicitud = s.nro_solicitud
                 And sec.id_registro_patronal = p_id_registro_patronal
               Where s.nss = p_id_nss
                 And s.tipo_subsidio = 'E'
               Group by padecimiento);

    p_ResultNumber := '0';
  Exception
    When Others Then
      v_bd_error     := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultNumber := Seg_Retornar_Cadena_Error(-1, v_bd_error, SQLCODE);
  End;

  ---------------------------------------------------------------
  --Devuelve todos los registros de enfermedad comun a convalidar
  ---------------------------------------------------------------
  procedure PadecimientosaConvalidar(p_id_nss               IN sre_ciudadanos_t.id_nss%type,
                                     p_id_registro_patronal IN sre_empleadores_t.id_registro_patronal%type,
                                     p_io_cursor            OUT t_cursor,
                                     p_resultnumber         OUT VARCHAR2) IS
    v_bd_error VARCHAR2(1000);
  Begin
    Open p_io_cursor for
      Select mitabla.nro_solicitud,
             form.nro_formulario,
             form.diagnostico,
             form.fecharegistro fecha_registro
        From (with a as (Select distinct f.nro_formulario,
                                         trunc(e.fecha_registro) fecha_registro,
                                         f.diagnostico,
                                         e.nro_solicitud
                           From sub_solicitud_t s
                           Join sub_enfermedad_comun_t e
                             On e.nro_solicitud = s.nro_solicitud
                            And NVL(e.completado, 'N') = 'S'
                            And e.estatus = 'AC'
                           Join sub_formularios_t f
                             on f.nro_solicitud = e.nro_solicitud
                           Join sub_sfs_enf_comun_t sec
                             On sec.nro_solicitud = s.nro_solicitud
                            And sec.id_registro_patronal !=
                                p_id_registro_patronal
                            And sec.id_estatus in (4, 2)
                          Where s.nss = p_id_nss
                            And s.tipo_subsidio = 'E'
                            And Not Exists
                          (Select 1
                                   From sub_solicitud_t sol
                                   Join sub_sfs_enf_comun_t sec
                                     On sec.nro_solicitud = sol.nro_solicitud
                                    And sec.id_registro_patronal =
                                        p_id_registro_patronal
                                  Where sol.nss = p_id_nss
                                    And sol.tipo_subsidio = 'E'
                                    And sol.padecimiento = s.padecimiento
                                    And sol.secuencia = s.secuencia))
               select nro_formulario, max(nro_solicitud) nro_solicitud
                 from a
                group by nro_formulario) mitabla
                 Join sub_formularios_t form
                   on form.nro_solicitud = mitabla.nro_solicitud;
				   
    
    p_ResultNumber := '0';
  Exception
    When Others Then
      v_bd_error     := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultNumber := Seg_Retornar_Cadena_Error(-1, v_bd_error, SQLCODE);
  End;

  ------------------------------------------------------------------------
  --Devuelve todos los registros de enfermedad que pueden ser reintegrados
  ------------------------------------------------------------------------
  procedure MostrarDatosReintegro(p_nro_solicitud IN sub_solicitud_t.nro_solicitud%type,
                                  p_io_cursor     OUT t_cursor,
                                  p_resultnumber  OUT Varchar2) Is
    v_bd_error varchar2(1000);
  Begin
    OPEN p_io_cursor FOR
      Select f.nro_formulario,
             case
               when ec.fecha_inicio_amb is null then
                ec.fecha_inicio_hos
               when ec.fecha_inicio_hos is null then
                ec.fecha_inicio_amb
               when ec.fecha_inicio_amb < ec.fecha_inicio_hos then
                ec.fecha_inicio_amb
               else
                ec.fecha_inicio_hos
             end fecha_inicio,
             case
               when ec.fecha_inicio_amb is null then
                ec.fecha_inicio_hos + ec.dias_cal_hos
               when ec.fecha_inicio_hos is null then
                ec.fecha_inicio_amb + ec.dias_cal_amb
               when ec.fecha_inicio_amb > ec.fecha_inicio_hos then
                ec.fecha_inicio_amb + ec.dias_cal_amb
               else
                ec.fecha_inicio_hos + ec.dias_cal_hos
             end fecha_fin,
             case
               when ec.fecha_inicio_amb is null then
                ec.dias_cal_hos
               when ec.fecha_inicio_hos is null then
                ec.dias_cal_amb
               when ec.fecha_inicio_amb > ec.fecha_inicio_hos then
                ec.dias_cal_amb
               else
                ec.dias_cal_hos
             end dias_calendario
        From sub_enfermedad_comun_t ec
        Join sub_formularios_t f
          on f.nro_solicitud = ec.nro_solicitud
       Where ec.nro_solicitud = p_nro_solicitud;

    p_resultnumber := '0';
  Exception
    When No_Data_Found Then
      v_bd_error     := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultNumber := Seg_Retornar_Cadena_Error(-1, v_bd_error, SQLCODE);
  End;

  --------------------------------------------------------------
  --Recibe datos de un reintegro de enfermedad comun
  --------------------------------------------------------------
  procedure RecibirDatosReintegro(p_nro_solicitud   IN sub_solicitud_t.nro_solicitud%type,
                                  p_fecha_reintegro IN sub_reintegro_t.fecha_reintegro%type,
                                  p_usuario         IN seg_usuario_t.id_usuario%type,
                                  p_id_reg_pat      IN sre_empleadores_t.id_registro_patronal%type,
                                  p_resultnumber    OUT Varchar2) Is
    v_bd_error           varchar2(1000);
    v_Fecha_Inicio_amb   sub_enfermedad_comun_t.fecha_inicio_amb%type;
    v_Fecha_inicio_hos   sub_enfermedad_comun_t.fecha_inicio_hos%type;
    v_dias_cal_hos       sub_enfermedad_comun_t.dias_cal_hos%type;
    v_dias_cal_amb       sub_enfermedad_comun_t.dias_cal_amb%type;
    v_fecha_inicio       date;
    v_fecha_fin_licencia date;
  Begin
    --Evaluar la fecha de reintegro que no sea futura
    If (trunc(p_fecha_reintegro) > trunc(sysdate)) Then
      p_resultNumber := Seg_Retornar_Cadena_Error(33, NULL, NULL);
      RETURN;
    End If;

    Select e.fecha_inicio_amb,
           e.fecha_inicio_hos,
           e.dias_cal_amb,
           e.dias_cal_hos
      Into v_Fecha_Inicio_amb,
           v_Fecha_inicio_hos,
           v_dias_cal_amb,
           v_dias_cal_hos
      From sub_enfermedad_comun_t e
     Where e.id_enfermedad_comun =
           (select max(id_enfermedad_comun)
              from sub_enfermedad_comun_t
             where nro_solicitud = p_nro_solicitud);

    --Ambulatorio--
    If (v_fecha_inicio_amb is not null And v_fecha_inicio_hos is null) then
      v_fecha_fin_licencia := v_Fecha_Inicio_amb + v_dias_cal_amb;
      v_fecha_inicio       := v_Fecha_Inicio_amb;
      --Hospitalario--
    Elsif (v_fecha_inicio_amb is null And v_fecha_inicio_hos is not null) then
      v_fecha_fin_licencia := v_Fecha_inicio_hos + v_dias_cal_hos;
      v_fecha_inicio       := v_Fecha_inicio_hos;
      -- Ambos--
    Elsif (v_fecha_inicio_amb is not null And
          v_fecha_inicio_hos is not null) then
      --determinar la fecha fin de la licencia
      If (v_Fecha_Inicio_amb > v_Fecha_inicio_hos) Then
        v_fecha_fin_licencia := v_Fecha_Inicio_amb + v_dias_cal_amb;
      Else
        v_fecha_fin_licencia := v_Fecha_inicio_hos + v_dias_cal_hos;
      End If;

      --determina la fecha de inicio de la licencia---
      --que es igual a la fecha menor de p_Fecha_Inicio_amb y p_Fecha_inicio_hos--
      If (nvl(v_Fecha_Inicio_amb, sysdate + 3000) <
         nvl(v_Fecha_inicio_hos, sysdate + 3000)) Then
        v_fecha_inicio := v_Fecha_Inicio_amb;
      Else
        v_fecha_inicio := v_Fecha_inicio_hos;
      End If;
    End if;

    --Evaluar la fecha de reintegro contra el inicio y el final de la licencia
    If (p_fecha_reintegro Not Between v_Fecha_Inicio and
       v_fecha_fin_licencia) Then
      p_resultNumber := Seg_Retornar_Cadena_Error(33, NULL, NULL);
      RETURN;
    End If;

    Insert into sub_reintegro_t
      (id_reintegro,
       nro_solicitud,
       fecha_reintegro,
       fecha_registro,
       usuario,
       registro_patronal,
       ult_fecha_act)
    Values
      (SUB_REINTEGRO_SEQ.NEXTVAL,
       p_nro_solicitud,
       p_fecha_reintegro,
       sysdate,
       p_usuario,
       p_id_reg_pat,
       sysdate);

    Commit;
    p_resultnumber := '0';
  Exception
    When No_Data_Found Then
      v_bd_error     := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultNumber := Seg_Retornar_Cadena_Error(-1, v_bd_error, SQLCODE);
  End;

  --------------------------------------------------------------
  --Crear la convalidacion del padecimiento
  --------------------------------------------------------------
  Procedure ConvalidarPadecimiento(p_nro_solicitud        IN sub_solicitud_t.nro_solicitud%type,
                                   p_id_registro_patronal IN sre_empleadores_t.id_registro_patronal%type,
                                   p_id_nomina            IN sre_nominas_t.id_nomina%type,
                                   p_usuario              IN seg_usuario_t.id_usuario%type,
                                   p_resultnumber         OUT Varchar2) Is
    v_nro_solicitud      sub_solicitud_t.nro_solicitud%type;
    v_solicitud_t        sub_solicitud_t%rowtype;
    v_formularios_t      sub_formularios_t%rowtype;
    v_enfermedad_comun_t sub_enfermedad_comun_t%rowtype;
    v_elegibles_t        sub_elegibles_t%rowtype;
    v_sub_enf_comun_t    sub_sfs_enf_comun_t%rowtype;
  v_count    number;
    v_bd_error varchar2(1000);
  
  Begin
    --Buscamos los datos de la solicitud que recibimos como dato de entrada
    Select *
      Into v_solicitud_t
      From sub_solicitud_t
     Where nro_solicitud = p_nro_solicitud;
  
   --Buscamos los datos del elegible para la solicitud que recibimos como dato de entrada
    Select *
      Into v_elegibles_t
      From sub_elegibles_t
     Where id_elegibles =
           (select max(id_elegibles)
              from sub_elegibles_t
             where nro_solicitud = p_nro_solicitud);
  
    --Creamos el elegible
    crearElegible(p_nro_solicitud,
                  p_ID_REGISTRO_PATRONAL,
                  NVL(v_elegibles_t.salario_cotizable, 0),
                  1,
                  v_elegibles_t.categoria_salario,
                  v_solicitud_t.nss,
                  v_solicitud_t.secuencia,
                  NULL,
                  'O',
                  sysdate,
                  p_RESULTNUMBER);
  
    --Si no se pudo crear el elegible abortamos el metodo
    If p_RESULTNUMBER != '0' Then
      GOTO ABORTAR;
    End if;
  
    --Buscamos los datos del elegible para la solicitud que recibimos como dato de entrada
      select count(*)
      into v_count
      From sub_sfs_enf_comun_t t
     Where nro_solicitud = p_nro_solicitud and id_estatus = 2;
      

    if (v_count > 1) then
    
     Select *
      Into v_sub_enf_comun_t
      From sub_sfs_enf_comun_t t
     Where nro_solicitud = p_nro_solicitud and id_estatus = 2 and ROWNUM = 1;
     
     else
      Select *
      Into v_sub_enf_comun_t
      From sub_sfs_enf_comun_t t
     Where nro_solicitud = p_nro_solicitud and id_estatus = 2;
     
    end if;
             
  
    v_sub_enf_comun_t.id_sub_enf_comun     := sub_sfs_enf_comun_seq.nextval;
    v_sub_enf_comun_t.nro_solicitud        := p_nro_solicitud;
    v_sub_enf_comun_t.id_registro_patronal := p_id_registro_patronal;
    v_sub_enf_comun_t.ult_fecha_act        := sysdate;
    v_sub_enf_comun_t.id_estatus           := 1;
	v_sub_enf_comun_t.ult_usuario_act      := p_usuario;
  
    --Creamos el subsidio para el elegible
    Insert Into Sub_Sfs_Enf_Comun_t Values v_sub_enf_comun_t;
  
    --Crear el evento
    crearEvento(p_nro_solicitud, 'LD', sysdate, sysdate, p_RESULTNUMBER);
  
    --Si no se pudo crear el evento abortamos el metodo
    If p_RESULTNUMBER != '0' Then
      GOTO ABORTAR;
    End if;
  
    Commit;
    p_resultNumber := '0';
    RETURN;
  
    <<ABORTAR>>
    ROLLBACK;
  Exception
  
    When DUP_VAL_ON_INDEX THEN
      DECLARE
        v_mensaje varchar2(4000) := SQLERRM;
      BEGIN
        ROLLBACK;
        p_resultNumber := Seg_Retornar_Cadena_Error(666, NULL, NULL);
      
        --Insertamos en la tabla de log SUB_LOG_T
        Insert into suirplus.sub_log_t
          (id_log, fecha, id_solicitud, mensaje)
        values
          (suirplus.sub_log_seq.nextval,
           sysdate,
           p_nro_solicitud,
           'CREACION DE ENFERMEDAD COMUN' || chr(13) || chr(10) ||
           'ID_NSS: ' || v_solicitud_t.nss || chr(13) || chr(10) ||
           'SECUENCIA: ' || v_solicitud_t.secuencia || chr(13) || chr(10) ||
           'PADECIMIENTO: ' || v_solicitud_t.padecimiento || chr(13) ||
           chr(10) || 'TIPO SUBSIDIO: E' || chr(13) || chr(10) ||
           'USUARIO: ' || p_usuario || chr(13) || chr(10) ||
           'ERROR ORACLE: ' || v_mensaje);
        commit;
      END;
    
    When No_Data_Found Then
      v_bd_error     := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultNumber := Seg_Retornar_Cadena_Error(-1, v_bd_error, SQLCODE);
  End;

  -----------------------------------------------------------------------------------------
  --- Metodo que devuelve los datos de un registro de enfermad comun a partir de un id_enfermedad_comun
  -----------------------------------------------------------------------------------------
  Procedure getEnfermedadComun(p_id_enfermedad_comun  IN suirplus.sub_enfermedad_comun_t.id_enfermedad_comun%type,
                               p_id_registro_patronal in suirplus.sub_sfs_enf_comun_t.id_registro_patronal%type,
                               p_iocursor             OUT t_cursor,
                               p_RESULTNUMBER         OUT VARCHAR2) is
    v_bd_error VARCHAR2(1000);
    v_count    number;
  Begin

    select count(*)
      into v_count
      from sub_enfermedad_comun_t e
      join sub_sfs_enf_comun_t ef
        on ef.nro_solicitud = e.nro_solicitud
       and ef.id_registro_patronal = p_id_registro_patronal
       and ef.id_estatus = 3
     where e.id_enfermedad_comun = p_id_enfermedad_comun;

    if v_count > 0 then
      open p_iocursor for
        select e.ID_ENFERMEDAD_COMUN,
               e.NRO_SOLICITUD,
               e.DIRECCION,
               e.TELEFONO,
               e.EMAIL,
               e.CELULAR,
               e.TIPO_DISCAPACIDAD,
               e.AMBULATORIO,
               e.FECHA_INICIO_AMB,
               e.DIAS_CAL_AMB,
               e.HOSPITALIZACION,
               e.FECHA_INICIO_HOS,
               e.DIAS_CAL_HOS,
               e.CODIGOCIE10,
               e.FECHA_REGISTRO,
               e.ULT_USUARIO_ACT,
               e.ULT_FECHA_ACT,
               e.PIN,
               e.COMPLETADO,
               s.nss,
               c.no_documento,
               f.ID_FORMULARIO,
               f.NRO_FORMULARIO,
               nvl(f.ID_PSS_MED, 0) ID_PSS_MED,
               f.NO_DOCUMENTO_MED,
               f.NOMBRE_MED,
               f.DIRECCION_MED,
               f.TELEFONO_MED,
               f.CELULAR_MED,
               f.EMAIL_MED,
               nvl(f.ID_PSS_CEN, 0) ID_PSS_CEN,
               f.NOMBRE_CEN,
               f.DIRECCION_CEN,
               f.TELEFONO_CEN,
               f.FAX_CEN,
               f.EMAIL_CEN,
               f.EXEQUATUR,
               f.DIAGNOSTICO,
               f.SIGNOS_SINTOMAS,
               f.PROCEDIMIENTOS,
               f.FECHA_DIAGNOSTICO
          from sub_enfermedad_comun_t e
          join sub_solicitud_t s
            on s.nro_solicitud = e.nro_solicitud
          join sre_ciudadanos_t c
            on c.id_nss = s.nss
          join sub_formularios_t f
            on f.nro_solicitud = e.nro_solicitud
         where e.id_enfermedad_comun = p_id_enfermedad_comun;

      p_RESULTNUMBER := '0';
    else
      p_RESULTNUMBER := Seg_Retornar_Cadena_Error(51, null, null);
    end if;

  Exception
    When Others Then
      v_bd_error     := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultNumber := Seg_Retornar_Cadena_Error(-1, v_bd_error, SQLCODE);
  End;

  -----------------------------------------------------------------------------------------
  --- Metodo que devuelve los datos de un registro de maternidad a partir de un id_enfermedad_comun
  -----------------------------------------------------------------------------------------
  Procedure getMaternidad(p_id_sub_maternidad    IN suirplus.sub_sfs_maternidad_t.id_sub_maternidad%type,
                          p_id_registro_patronal in suirplus.sub_sfs_maternidad_t.id_registro_patronal%type,
                          p_iocursor             OUT t_cursor,
                          p_RESULTNUMBER         OUT VARCHAR2) is
    v_bd_error VARCHAR2(1000);
    v_count    number;
  Begin

    select count(*)
      into v_count
      from sub_sfs_maternidad_t m
     where m.id_sub_maternidad = p_id_sub_maternidad
       and m.id_registro_patronal = p_id_registro_patronal
       and m.id_estatus = 3;

    if v_count > 0 then

      open p_iocursor for
        select m.ID_MATERNIDAD,
               m.NRO_SOLICITUD,
               m.FECHA_DIAGNOSTICO,
               m.FECHA_ESTIMADA_PARTO,
               m.FECHA_PERDIDA,
               m.FECHA_DEFUNCION_MADRE,
               m.CUENTA_BANCO,
               m.ID_REGISTRO_PATRONAL_RE,
               m.FECHA_REGISTRO_RE,
               m.USUARIO_RE,
               m.ID_REGISTRO_PATRONAL_PE,
               m.FECHA_REGISTRO_PE,
               m.USUARIO_PE,
               m.ID_REGISTRO_PATRONAL_MM,
               m.FECHA_REGISTRO_MM,
               m.USUARIO_MM,
               m.SALARIO_ESTIMADO_L,
               m.SALARIO_ESTIMADO_M,
               m.FECHA_REGISTRO_MOD,
               m.USUARIO_MOD,
               m.TELEFONO,
               m.CELULAR,
               m.EMAIL,
               m.ESTATUS,
               m.NSS_TUTOR,
               m.CUENTA_TUTOR,
               m.FECHA_CANCELACION,
               m.CANTIDAD_DIAS,
               m.EMAIL_TUTOR,
               m.TELEFONO_TUTOR,
               s.nss,
               c.no_documento,
               c.nombres                 nombre_madre,
               c.primer_apellido         primer_apellido_madre,
               c.segundo_apellido        segundo_apellido_madre,
               c.sexo,
               c.fecha_nacimiento,
               l.FECHA_LICENCIA,
               l.ID_REGISTRO_PATRONAL,
               l.TIPO_LICENCIA,
               l.ID_ESTATUS,
               l.id_sub_maternidad,
               t.nombres                 nombre_tutor,
               t.primer_apellido         primer_apellido_tutor,
               t.segundo_apellido        segundo_apellido_tutor,
               t.fecha_nacimiento        fecha_nacimiento_tutor,
               t.sexo                    sexo_tutor,
               t.no_documento            no_documento_tutor,
               f.id_formulario,
               f.nro_formulario,
               f.id_pss_med,
               f.no_documento_med,
               f.nombre_med,
               f.direccion_med,
               f.telefono_med,
               f.celular_med,
               f.email_med,
               f.id_pss_cen,
               f.nombre_cen,
               f.direccion_cen,
               f.telefono_cen,
               f.fax_cen,
               f.email_cen,
               f.exequatur,
               f.diagnostico,
               f.signos_sintomas,
               f.procedimientos,
               f.fecha_diagnostico
          from sub_maternidad_t m
          join sub_solicitud_t s
            on s.nro_solicitud = m.nro_solicitud
          join sub_sfs_maternidad_t l
            on l.nro_solicitud = m.nro_solicitud
          join sub_formularios_t f
            on f.nro_solicitud = m.nro_solicitud
          join sre_ciudadanos_t c
            on s.nss = c.id_nss
          left join sre_ciudadanos_t t
            on s.nss = t.id_nss
         where l.id_sub_maternidad = p_id_sub_maternidad;

      p_RESULTNUMBER := '0';
    else
      p_RESULTNUMBER := Seg_Retornar_Cadena_Error(51, null, null);
    end if;
  Exception
    When Others Then
      v_bd_error     := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultNumber := Seg_Retornar_Cadena_Error(-1, v_bd_error, SQLCODE);
  End;

  -----------------------------------------------------------------------------------------
  --- Metodo que devuelve los datos de un registro de lactancia a partir de un p_id_sub_lactancia
  -----------------------------------------------------------------------------------------
  Procedure getLactancia(p_id_sub_lactancia IN suirplus.sub_sfs_lactancia_t.id_sub_lactancia%type,
                         p_iocursor         OUT t_cursor,
                         p_RESULTNUMBER     OUT VARCHAR2) is
    v_bd_error VARCHAR2(1000);
    v_count    number;
  Begin

    select count(*)
      into v_count
      from sub_sfs_lactancia_t l
     where l.id_sub_lactancia = p_id_sub_lactancia
       and l.id_estatus = 3;

    if v_count > 0 then

      open p_iocursor for
        select l.fecha_nacimiento,
               l.cant_lactantes,
               l.nro_solicitud_mat,
               la.ID_LACTANTE,
               la.NRO_SOLICITUD,
               la.ID_NSS_LACTANTE,
               la.NUI,
               la.SECUENCIA_LACTANTE,
               la.NOMBRES,
               la.PRIMER_APELLIDO,
               la.SEGUNDO_APELLIDO,
               la.SEXO,
               la.ESTATUS,
               c.no_documento
          from sub_sfs_lactancia_t l
          join sub_lactantes_t la
            on la.nro_solicitud = l.nro_solicitud
          join sub_solicitud_t s
            on s.nro_solicitud = l.nro_solicitud
          join sre_ciudadanos_t c
            on s.nss = c.id_nss
         where l.id_sub_lactancia = p_id_sub_lactancia;

      p_RESULTNUMBER := '0';
    else
      p_RESULTNUMBER := Seg_Retornar_Cadena_Error(51, null, null);
    end if;
  Exception
    When Others Then
      v_bd_error     := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultNumber := Seg_Retornar_Cadena_Error(-1, v_bd_error, SQLCODE);
  End;


/*------------------------------------------------------------------------------------------------------------*/
--Autor: Eury Vallejo
--Validar que la madre no tenga licencias activas con la empresa
/*------------------------------------------------------------------------------------------------------------*/
 FUNCTION ValidarLicenciaMaternidad(p_nss in suirplus.sub_solicitud_t.nss%type,
                                    p_modo in varchar2,
                                    p_id_registro_patronal in suirplus.sub_elegibles_t.registro_patronal%type)
                                    RETURN VARCHAR IS
v_bd_error VARCHAR2(1000);
v_count    number;
v_definitivo char(1);
v_resultado varchar(2):= 'N';
BEGIN

for c in(select e.id_estatus, e.error
from suirplus.sub_solicitud_t s
join suirplus.sub_elegibles_t e
on s.nro_solicitud = e.nro_solicitud
where s.nss=p_nss 
and e.registro_patronal = p_id_registro_patronal
and e.id_elegibles=(select max(id_elegibles)
                    from suirplus.sub_elegibles_t t
                    where t.nro_solicitud = e.nro_solicitud  
                    and t.registro_patronal = p_id_registro_patronal) 
and e.id_estatus not in(2,3,4,5))

Loop
   If c.id_estatus = 1 and UPPER(P_MODO) = 'R' Then
      v_resultado :='N';
   Else
     v_resultado :='S';
   End if;
End loop;

return v_resultado;

Exception
    When Others Then
      v_bd_error     := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      v_resultado := Seg_Retornar_Cadena_Error(-1, v_bd_error, SQLCODE);
END;               

end SUB_SFS_NOVEDADES;