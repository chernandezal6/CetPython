CREATE OR REPLACE PACKAGE BODY SUIRPLUS.SUB_SFS_SUBSIDIOS IS

  Function getFechaInicioEnf Return Date Is
    v_fecha_inicio Sfc_Det_Parametro_t.Valor_Fecha%Type := Null;
  Begin
    Select Trunc(Valor_Fecha)
      Into v_fecha_inicio
      From Sfc_Det_Parametro_t
     Where Id_Parametro = 42
       And (Fecha_Fin Is Null Or
           Fecha_Fin = (Select Max(Fecha_Fin)
                           From Sfc_Det_Parametro_t
                          Where Id_Parametro = 42));

    Return v_fecha_inicio;
  End getFechaInicioEnf;

  PROCEDURE ObtenerDatosLactante(p_id_nss        SRE_CIUDADANOS_T.id_nss%TYPE,
                                 P_IOCURSOR      OUT T_CURSOR,
                                 p_result_number OUT VARCHAR2) IS
    c_cursor t_cursor;
  BEGIN
    OPEN C_CURSOR FOR
      SELECT ID_NSS           AS NSS,
             NOMBRES,
             PRIMER_APELLIDO,
             SEGUNDO_APELLIDO,
             SEXO,
             NO_DOCUMENTO     as NUI
        FROM SRE_CIUDADANOS_T
       WHERE ID_NSS = P_ID_NSS;

    P_RESULT_NUMBER := '0';
    P_IOCURSOR      := C_CURSOR;
  END ObtenerDatosLactante;

  procedure getNSS(P_NroDocumento IN SRE_CIUDADANOS_T.NO_DOCUMENTO%TYPE,
                   P_NSS          OUT SRE_CIUDADANOS_T.ID_NSS%TYPE) is
  Begin

    SELECT u.id_nss
      into P_NSS
      FROM sre_ciudadanos_t u
     WHERE no_documento = P_NroDocumento;

  End;

  procedure getPss(p_razon        in sfs_prestadoras_t.prestadora_nombre%TYPE,
                   p_resultnumber OUT varchar2,
                   p_io_cursor    IN OUT t_cursor) IS
    v_bderror varchar2(3000);
    e_exite_razon exception;
    v_cursor t_cursor;

  BEGIN
    --Validamos si existen
    IF (p_razon is null) THEN
      raise e_exite_razon;
    END IF;

    OPEN v_cursor FOR
      select prestadora_nombre,
             prestadora_numero,
             rnccedula,
             telefono,
             direccion
        from sfs_prestadoras_t
       where UPPER(prestadora_nombre) = UPPER(p_razon);

    p_resultnumber := 0;
    p_io_cursor    := v_cursor;

  EXCEPTION
    when e_exite_razon then
      p_resultnumber := 'No existe esta Prestadora o PSS'; --Seg_Retornar_Cadena_Error(223, NULL, NULL);
      RETURN;

    WHEN OTHERS THEN
      v_bderror      := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultnumber := Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
      RETURN;

  end getPss;

  procedure getPssList(p_prestadora_nombre IN sfs_prestadoras_t.prestadora_nombre%type,
                       p_iocursor          OUT t_cursor) is
    v_bderror varchar2(3000);
  begin
    OPEN p_iocursor FOR

      select *
        from (select distinct t.prestadora_nombre as PssNombre
                from sfs_prestadoras_t t
               where upper(prestadora_nombre) like
                     '%' || upper(p_prestadora_nombre) || '%')
       where rownum < 31;

  exception
    when others then
      v_bderror := SUBSTR(SQLERRM, 1, 255);
  end;

  -- ******************************************************************************************************
  -- PROCEDIMIENTO:     cargarImagen
  -- DESCRIPTION:       para subir una imagen a un formulario existente
  -- AUTOR:             charlie Pena
  -- Fecha:             25/01/2011
  -- ******************************************************************************************************
  PROCEDURE cargarImagen(p_nro_solicitud  in sub_solicitud_t.nro_solicitud%type,
                         p_imagen         in sub_solicitud_t.imagen%type,
                         p_nombre_archivo in sub_solicitud_t.nombre_archivo%type,
                         p_resultnumber   OUT VARCHAR2) Is
    v_bderror VARCHAR(1000);
  Begin

    Update sub_solicitud_t f
       Set f.imagen         = p_imagen,
           f.nombre_archivo = p_nombre_archivo,
           f.ult_fecha_act  = sysdate
     Where nro_solicitud = p_nro_solicitud;

    COMMIT;
    p_resultnumber := '0';

  EXCEPTION

    when others then
      v_bderror      := (substr('error ' || to_char(sqlcode) || ': ' ||
                                sqlerrm,
                                1,
                                255));
      p_resultnumber := seg_retornar_cadena_error(-1, v_bderror, sqlcode);
  End cargarImagen;

  -- ******************************************************************************************************
  -- PROCEDIMIENTO:     getSubsidiosSFS
  -- DESCRIPTION:       Trae un listado de solicitudes para un empleador
  -- AUTOR:             charlie Pena
  -- Fecha:             11/Feb/2011
  -- ******************************************************************************************************

 PROCEDURE getSubsidiosSFS(p_rnc          in sre_empleadores_t.rnc_o_cedula %type,
                            p_cedula       in sre_ciudadanos_t.no_documento%type,
                            p_Status       in sub_sfs_maternidad_t.id_estatus%type,
                            p_tipo         in sub_solicitud_t.tipo_subsidio%type,
                            p_fechaDesde   in sub_solicitud_t.fecha_registro%type,
                            p_fechaHasta   in sub_solicitud_t.fecha_registro%type,
                            p_pagenum      in number,
                            p_pagesize     in number,
                            p_iocursor     IN OUT t_cursor,
                            p_resultnumber OUT VARCHAR2)

   Is
    v_regPatronal sre_empleadores_t.id_registro_patronal %type;
    v_cedulaCount integer;
    v_bderror     VARCHAR(1000);
    vDesde        integer := (p_pagesize * (p_pagenum - 1)) + 1;
    vhasta        integer := p_pagesize * p_pagenum;

    e_regPatronalInvalido exception;
    e_cedulaInvalida      exception;
  Begin

    if p_rnc is not null then
      begin
        select e.id_registro_patronal
          into v_regPatronal
          from sre_empleadores_t e
         where e.rnc_o_cedula = p_rnc;
      Exception
        When No_Data_Found Then
          raise e_regPatronalInvalido;
      End;
    end if;

    if p_cedula is not null then
      select count(*)
        into v_cedulaCount
        from sre_ciudadanos_t c
       where c.no_documento = p_cedula;

      if (v_cedulaCount = 0) then
        raise e_cedulaInvalida;
      end if;
    end if;

    open p_iocursor for
      with x as
       (select rownum num, y.*
          from (
                -- Registro Embarazo aun sin licencia
                Select distinct tr.id_registro_patronal,
                                0 IdRegistro,
                                sol.nro_solicitud,
                                initCap(ciu.nombres || ' ' ||
                                        nvl(ciu.primer_apellido, '') || ' ' ||
                                        nvl(ciu.segundo_apellido, '')) Nombres,
                                decode(sol.tipo_subsidio,
                                       'M',
                                       'Maternidad',
                                       'L',
                                       'Lactancia',
                                       'E',
                                       'Enfermedad Comun') Tipo,
                                sol.tipo_subsidio id_tipo_subsidio,
                                'Registro Embarazo' descripcion,
                                sol.fecha_registro,
                                sol.nombre_archivo,
                                e.fecha_respuesta fecha_respuesta,
                                er.descripcion error_desc,
                                nvl(er.definitivo, 'N') definitivo
                  from sub_maternidad_t       mat,
                       sub_solicitud_t        sol,
                       sre_trabajadores_t     tr,
                       sre_ciudadanos_t       ciu,
                       sub_elegibles_t        e,
                       sub_errores_sisalril_t er
                 where mat.nro_solicitud = sol.nro_solicitud
                   and mat.id_maternidad = (select max(m.id_maternidad) 
                                                   from sub_maternidad_t m 
                                                   where m.nro_solicitud = sol.nro_solicitud)
                   and mat.nro_solicitud not in(select sm.nro_solicitud 
                                                 from sub_sfs_maternidad_t sm)
                                                  and sol.nro_solicitud = e.nro_solicitud(+)
                                                  and sol.tipo_subsidio = NVL(p_tipo, sol.tipo_subsidio)
                                                  and trunc(sol.fecha_registro) 
                                                  between NVL(p_fechaDesde, trunc(sol.fecha_registro)) 
                                                  and NVL(p_fechaHasta, trunc(sol.fecha_registro))
                   and tr.id_registro_patronal = v_regPatronal
                   and tr.id_nss = sol.nss
                   and tr.status = 'A'
                   and ciu.id_nss = sol.nss
                   and ciu.no_documento = NVL(p_cedula, ciu.no_documento)
                   and er.id_error(+) = e.error
                union all
                -- Subsidio Maternidad
                Select distinct m.id_registro_patronal,
                                m.id_sub_maternidad IdRegistro,
                                s.nro_solicitud,
                                initCap(c.nombres || ' ' ||
                                        nvl(c.primer_apellido, '') || ' ' ||
                                        nvl(c.segundo_apellido, '')) Nombres,
                                decode(s.tipo_subsidio,
                                       'M',
                                       'Maternidad',
                                       'L',
                                       'Lactancia',
                                       'E',
                                       'Enfermedad Comun') Tipo,
                                s.tipo_subsidio id_tipo_subsidio,
                                t.desc_estatus descripcion,
                                s.fecha_registro,
                                s.nombre_archivo,
                                e.fecha_respuesta,
                                er.descripcion error_desc,
                                nvl(er.definitivo, 'N') definitivo
                  from sub_sfs_maternidad_t   m,
                       Sub_Solicitud_t        s,
                       sub_estatus_t          t,
                       sre_ciudadanos_t       c,
                       sub_elegibles_t        e,
                       sub_errores_sisalril_t er
                 where m.id_registro_patronal = v_regPatronal
                   and s.nro_solicitud = m.nro_solicitud
                   and s.tipo_subsidio = NVL(p_tipo, s.tipo_subsidio)
                   and trunc(s.fecha_registro) between
                       nvl(p_fechaDesde, trunc(s.fecha_registro)) and
                       nvl(p_fechaHasta, trunc(s.fecha_registro))
                   and c.id_nss = s.nss
                   and c.no_documento = NVL(p_cedula, c.no_documento)
                   and t.id_estatus = m.id_estatus
                   and t.id_estatus = NVL(p_Status, t.id_estatus)
                   and e.nro_solicitud = m.nro_solicitud
                   and (e.id_estatus = m.id_estatus
                        or ( e.id_estatus = 2 and m.id_estatus = 4))                      
                   and e.id_elegibles in (select max(tt.id_elegibles) from sub_elegibles_t tt where tt.nro_solicitud = s.nro_solicitud)
                   and er.id_error(+) = e.error

                union all
                --Subsidio Lactancia
                select distinct tr.id_registro_patronal,
                                l.id_sub_lactancia IdRegistro,
                                s.nro_solicitud,
                                initCap(c.nombres || ' ' ||
                                        nvl(c.primer_apellido, '') || ' ' ||
                                        nvl(c.segundo_apellido, '')) Nombres,
                                decode(s.tipo_subsidio,
                                       'M',
                                       'Maternidad',
                                       'L',
                                       'Lactancia',
                                       'E',
                                       'Enfermedad Comun') Tipo,
                                s.tipo_subsidio id_tipo_subsidio,
                                t.desc_estatus descripcion,
                                s.fecha_registro,
                                s.nombre_archivo,
                                e.fecha_respuesta,
                                er.descripcion error_desc,
                                nvl(er.definitivo, 'N') definitivo
                  from sub_sfs_lactancia_t    l,
                       sub_solicitud_t        s,
                       sre_ciudadanos_t       c,
                       sub_estatus_t          t,
                       sre_trabajadores_t     tr,
                       sub_elegibles_t        e,
                       sub_errores_sisalril_t er,
                       sub_sfs_maternidad_t mm 
                 where s.nro_solicitud = l.nro_solicitud
                   and s.tipo_subsidio = NVL(p_tipo, s.tipo_subsidio)
                   and trunc(s.fecha_registro) between
                       nvl(p_fechaDesde, trunc(s.fecha_registro)) and
                       nvl(p_fechaHasta, trunc(s.fecha_registro))
                   and l.id_estatus = NVL(p_Status, l.id_estatus)
                   and l.id_estatus = t.id_estatus
                  and c.id_nss = s.nss
                   and c.no_documento = NVL(p_cedula, c.no_documento)
                   and tr.id_registro_patronal = v_regPatronal
                   and tr.id_nss = s.nss
                   and e.nro_solicitud(+) = s.nro_solicitud
                   and e.id_estatus = l.id_estatus
                   and e.id_elegibles in (select max(tt.id_elegibles) from sub_elegibles_t tt where tt.nro_solicitud = s.nro_solicitud)
                   and er.id_error(+) = e.error
                   and mm.nro_solicitud = l.nro_solicitud_mat
                   and mm.id_registro_patronal = tr.id_registro_patronal
                   --and trunc(nvl(tr.fecha_salida,sysdate+1)) > trunc(s.fecha_registro)
                union all
                -- Registro Enfermedad Comun aun sin licencia
                select distinct tr.id_registro_patronal,
                                0 IdRegistro,
                                sol.nro_solicitud,
                                initCap(ciu.nombres || ' ' ||
                                        nvl(ciu.primer_apellido, '') || ' ' ||
                                        nvl(ciu.segundo_apellido, '')) Nombres,
                                decode(sol.tipo_subsidio,
                                       'M',
                                       'Maternidad',
                                       'L',
                                       'Lactancia',
                                       'E',
                                       'Enfermedad Comun') Tipo,
                                sol.tipo_subsidio id_tipo_subsidio,
                                'Registro Enf. Comun' descripcion,
                                sol.fecha_registro,
                                sol.nombre_archivo,
                                e.fecha_respuesta,
                                er.descripcion error_desc,
                                nvl(er.definitivo, 'N') definitivo
                  from sub_enfermedad_comun_t enf,
                       sub_solicitud_t        sol,
                       sre_trabajadores_t     tr,
                       sre_ciudadanos_t       ciu,
                       sub_elegibles_t        e,
                       sub_errores_sisalril_t er
                 where enf.nro_solicitud = sol.nro_solicitud
                   and enf.id_enfermedad_comun =
                       (select max(en.id_enfermedad_comun)
                          from sub_enfermedad_comun_t en
                         where en.nro_solicitud = sol.nro_solicitud)

                   and enf.nro_solicitud not in
                       (select ec.nro_solicitud from sub_sfs_enf_comun_t ec)

                   and sol.nro_solicitud = e.nro_solicitud(+)
                   and sol.tipo_subsidio = NVL(p_tipo, sol.tipo_subsidio)
                   and trunc(sol.fecha_registro) between
                       nvl(p_fechaDesde, trunc(sol.fecha_registro)) and
                       nvl(p_fechaHasta, trunc(sol.fecha_registro))

                   and tr.id_registro_patronal = v_regPatronal
                   and tr.id_nss = sol.nss
                   and tr.status = 'A'

                   and ciu.id_nss = sol.nss
                   and ciu.no_documento = NVL(p_cedula, ciu.no_documento)

                   and er.id_error(+) = e.error

                union all
                -- Subsidio Enfermedad Comun
                select distinct ec.id_registro_patronal,
                                enf.id_enfermedad_comun IdRegistro,
                                s.nro_solicitud,
                                initCap(c.nombres || ' ' ||
                                        nvl(c.primer_apellido, '') || ' ' ||
                                        nvl(c.segundo_apellido, '')) Nombres,
                                decode(s.tipo_subsidio,
                                       'M',
                                       'Maternidad',
                                       'L',
                                       'Lactancia',
                                       'E',
                                       'Enfermedad Comun') Tipo,
                                s.tipo_subsidio id_tipo_subsidio,
                                t.desc_estatus descripcion,
                                s.fecha_registro,
                                s.nombre_archivo,
                                e.fecha_respuesta,
                                er.descripcion error_desc,
                                nvl(er.definitivo, 'N') definitivo
                  from sub_sfs_enf_comun_t    ec,
                       sub_solicitud_t        s,
                       sub_estatus_t          t,
                       sre_ciudadanos_t       c,
                       sub_enfermedad_comun_t enf,
                       sub_elegibles_t        e,
                       sub_errores_sisalril_t er
                 where s.nro_solicitud = ec.nro_solicitud
                   and s.tipo_subsidio = NVL(p_tipo, s.tipo_subsidio)
                   and trunc(s.fecha_registro) between
                       nvl(p_fechaDesde, trunc(s.fecha_registro)) and
                       nvl(p_fechaHasta, trunc(s.fecha_registro))

                   and ec.id_registro_patronal = v_regPatronal
                   and ec.id_estatus = NVL(p_Status, ec.id_estatus)
                   and ec.id_estatus = e.id_estatus

                   and enf.id_enfermedad_comun =
                       (select max(en.id_enfermedad_comun)
                          from sub_enfermedad_comun_t en
                         where en.nro_solicitud = s.nro_solicitud)
                   and enf.nro_solicitud = s.nro_solicitud

                   and c.id_nss = s.nss
                   and c.no_documento = NVL(p_cedula, c.no_documento)

                   and ec.id_estatus = t.id_estatus
                   and e.nro_solicitud(+) = s.nro_solicitud
                   and e.id_elegibles in (select max(tt.id_elegibles) from sub_elegibles_t tt where tt.nro_solicitud = s.nro_solicitud)
                   and er.id_error(+) = e.error

                ) y)
      select y.recordcount, x.*
        from x, (select max(num) recordcount from x) y
       where num between vDesde and vHasta
       order by num asc;

    p_resultnumber := '0';

  EXCEPTION

    when e_regPatronalInvalido then
      p_resultnumber := seg_retornar_cadena_error(150, null, null);
      return;

    when e_cedulaInvalida then
      p_resultnumber := seg_retornar_cadena_error(103, null, null);
      return;

    when others then
      v_bderror      := (substr('error ' || to_char(sqlcode) || ': ' ||
                                sqlerrm,
                                1,
                                255));
      p_resultnumber := seg_retornar_cadena_error(-1, v_bderror, sqlcode);
  End getSubsidiosSFS;


  -- ******************************************************************************************************
  -- PROCEDIMIENTO:     getDetSubsidiosSFS_M
  -- DESCRIPTION:       Trae el detalle de una solicitud de subsidio de maternidad para un empleador
  -- AUTOR:             charlie Pena
  -- Fecha:             16/Feb/2011
  -- ******************************************************************************************************
  PROCEDURE getDetSubsidiosSFS_M(p_nro_solicitud in sub_solicitud_t.nro_solicitud%type,
                                 p_regPatronal   in sre_empleadores_t.rnc_o_cedula %type,
                                 p_iocursor      IN OUT t_cursor,
                                 p_resultnumber  OUT VARCHAR2)

   Is
    v_contador int;
    v_bderror  VARCHAR(1000);
    e_InvialidSolicitud       exception;
    e_invalidregistropatronal exception;
  Begin

    if not sub_sfs_subsidios.existeSolicitud(p_nro_solicitud) then
      raise e_InvialidSolicitud;
    end if;

    if not sre_empleadores_pkg.ExisteRegistroPatronal(p_regPatronal) then
      raise e_invalidregistropatronal;
    end if;

    --*********para verificar si la solicitu existe tiene algun subsidio

    select count(*)
      into v_contador
      from sub_sfs_maternidad_t m
     where m.nro_solicitud = p_nro_solicitud;

    if v_contador > 0 then
      open p_iocursor for
        select s.nro_solicitud,
               decode(s.tipo_subsidio,
                      'M',
                      'Maternidad',
                      'L',
                      'Lactancia',
                      'E',
                      'Enfermedad Comun') tipo_subsidio,
               c.no_documento Documento_Solicitante,
               initCap(c.nombres || ' ' || nvl(c.primer_apellido, '') || ' ' ||
                       nvl(c.segundo_apellido, '')) Nombre_Solicitante,
               mat.fecha_diagnostico,
               mat.fecha_estimada_parto,
               e.salario_cotizable,
               c2.no_documento Documento_Tutor,
               mat.nss_tutor,
               initCap(c2.nombres || ' ' || nvl(c2.primer_apellido, '') || ' ' ||
                       nvl(c2.segundo_apellido, '')) Tutor,
               est.desc_estatus Estatus_Maternidad,
               substr(lpad(mat.nro_solicitud, 10, '0'), -4) pin,
               t.fecha_licencia,
               decode(t.tipo_licencia,
                      'PR',
                      'Pre-natal',
                      'PO',
                      'Post-natal') Tipo_Licencia,s.nombre_archivo
          from sub_solicitud_t s
          join sub_maternidad_t mat
            on mat.nro_solicitud = s.nro_solicitud
          join sub_sfs_maternidad_t t
            on t.nro_solicitud = s.nro_solicitud
          join sub_estatus_t est
            on t.id_estatus = est.id_estatus
          join sub_elegibles_t e
            on e.nro_solicitud = s.nro_solicitud
           and e.registro_patronal = t.id_registro_patronal
          join sre_ciudadanos_t c
            on c.id_nss = s.nss
          join sre_ciudadanos_t c2
            on c2.id_nss = mat.nss_tutor

         where s.nro_solicitud = p_nro_solicitud
           and t.id_registro_patronal = p_regPatronal;

      p_resultnumber := '0';

    else

      open p_iocursor for
        select sol.nro_solicitud,
               decode(sol.tipo_subsidio,
                      'M',
                      'Maternidad',
                      'L',
                      'Lactancia',
                      'E',
                      'Enfermedad Comun') tipo_subsidio,
               ciu.no_documento Documento_Solicitante,
               initCap(ciu.nombres || ' ' || nvl(ciu.primer_apellido, '') || ' ' ||
                       nvl(ciu.segundo_apellido, '')) Nombre_Solicitante,
               mat.fecha_diagnostico,
               mat.fecha_estimada_parto,
               '' salario_cotizable,
               ciu2.no_documento Documento_Tutor,
               mat.nss_tutor,
               initCap(ciu2.nombres || ' ' || nvl(ciu2.primer_apellido, '') || ' ' ||
                       nvl(ciu2.segundo_apellido, '')) Tutor,
               decode(mat.estatus,
                      'AC',
                      'Activo',
                      'IN',
                      'Inactivo',
                      'FA',
                      'Fallecida',
                      '') Estatus_Maternidad,
               '' fecha_licencia,
               '' Tipo_Licencia,
               substr(lpad(mat.nro_solicitud, 10, '0'), -4) pin,sol.nombre_archivo
          from sub_maternidad_t   mat,
               sub_solicitud_t    sol,
               sre_trabajadores_t tr,
               sre_ciudadanos_t   ciu,
               sre_ciudadanos_t   ciu2
         where mat.nro_solicitud = sol.nro_solicitud
           and sol.nss = tr.id_nss
           and tr.status = 'A'
           and sol.nss = ciu.id_nss
           and ciu2.id_nss = mat.nss_tutor
           and mat.nro_solicitud not in
               (select sm.nro_solicitud from sub_sfs_maternidad_t sm)
           and sol.nro_solicitud = p_nro_solicitud
           and tr.id_registro_patronal = p_regPatronal;

      p_resultnumber := '0';
    end if;

  EXCEPTION

    when e_invalidregistropatronal then
      p_resultnumber := seg_retornar_cadena_error(10, null, null);
      return;
    when e_InvialidSolicitud then
      p_resultnumber := Seg_Retornar_Cadena_Error(181, NULL, NULL);
      return;
    when others then
      v_bderror      := (substr('error ' || to_char(sqlcode) || ': ' ||
                                sqlerrm,
                                1,
                                255));
      p_resultnumber := seg_retornar_cadena_error(-1, v_bderror, sqlcode);
  End getDetSubsidiosSFS_M;

  -- ******************************************************************************************************
  -- PROCEDIMIENTO:     getDetSubsidiosSFS_L
  -- DESCRIPTION:       Trae el detalle de una solicitud de subsidio de lactancia para un empleador
  -- AUTOR:             charlie Pena
  -- Fecha:             16/Feb/2011
  -- ******************************************************************************************************
  PROCEDURE getDetSubsidiosSFS_L(p_nro_solicitud in sub_solicitud_t.nro_solicitud%type,
                                 p_regPatronal   in sre_empleadores_t.rnc_o_cedula %type,
                                 p_iocursor      IN OUT t_cursor,
                                 p_resultnumber  OUT VARCHAR2)

   Is
    v_bderror VARCHAR(1000);
    e_InvialidSolicitud       exception;
    e_invalidregistropatronal exception;
  Begin

    if not sub_sfs_subsidios.existeSolicitud(p_nro_solicitud) then
      raise e_InvialidSolicitud;
    end if;

    if not sre_empleadores_pkg.ExisteRegistroPatronal(p_regPatronal) then
      raise e_invalidregistropatronal;
    end if;

    open p_iocursor for
    --Lactancia
      Select s.nro_solicitud,
             decode(s.tipo_subsidio,
                    'M',
                    'Maternidad',
                    'L',
                    'Lactancia',
                    'E',
                    'Enfermedad Comun') tipo_subsidio,
             c.no_documento Documento_Solicitante,
             initCap(c.nombres || ' ' || nvl(c.primer_apellido, '') || ' ' ||
                     nvl(c.segundo_apellido, '')) Nombre_Solicitante,
             l.cant_lactantes,
             l.fecha_nacimiento,
             l.id_estatus Estatus_Lacancia,
             l2.fecha_registro_nc,
             l2.id_lactante,
             l2.id_nss_lactante,
             l2.nui,
             initCap(l2.nombres || ' ' || nvl(l2.primer_apellido, '') || ' ' ||
                     nvl(l2.segundo_apellido, '')) Nombre_Lactante,
             decode(l2.sexo, 'M', 'Masculino', 'F', 'Femenino') sexo,
             est.desc_estatus Estatus_Lactante
        from sub_solicitud_t s
        join sre_ciudadanos_t c
          on s.nss = c.id_nss
        join sub_sfs_lactancia_t l
          on l.nro_solicitud = s.nro_solicitud
        join sub_estatus_t est
          on l.id_estatus = est.id_estatus
        join sub_lactantes_t l2
          on l2.nro_solicitud = l.nro_solicitud
        join sre_trabajadores_t tr
          on tr.id_nss = s.nss
       where s.nro_solicitud = p_nro_solicitud
         and tr.status = 'A'
         and tr.id_registro_patronal = p_regPatronal;

    p_resultnumber := '0';

  EXCEPTION

    when e_invalidregistropatronal then
      p_resultnumber := seg_retornar_cadena_error(10, null, null);
      return;
    when e_InvialidSolicitud then
      p_resultnumber := Seg_Retornar_Cadena_Error(181, NULL, NULL);
      return;
    when others then
      v_bderror      := (substr('error ' || to_char(sqlcode) || ': ' ||
                                sqlerrm,
                                1,
                                255));
      p_resultnumber := seg_retornar_cadena_error(-1, v_bderror, sqlcode);
  End getDetSubsidiosSFS_L;

  --*********
  -- ******************************************************************************************************
  -- PROCEDIMIENTO:     getDetSubsidiosSFS_E
  -- DESCRIPTION:       Trae el detalle de una solicitud de subsidio de Enfermedad Comun para un empleador
  -- AUTOR:             charlie Pena
  -- Fecha:             16/Feb/2011
  -- ******************************************************************************************************
  PROCEDURE getDetSubsidiosSFS_E(p_nro_solicitud in sub_solicitud_t.nro_solicitud%type,
                                 p_regPatronal   in sre_empleadores_t.rnc_o_cedula %type,
                                 p_iocursor      IN OUT t_cursor,
                                 p_resultnumber  OUT VARCHAR2)

   Is
    v_contador int;
    v_bderror  VARCHAR(1000);
    e_InvialidSolicitud       exception;
    e_invalidregistropatronal exception;
  Begin

    if not sub_sfs_subsidios.existeSolicitud(p_nro_solicitud) then
      raise e_InvialidSolicitud;
    end if;

    if not sre_empleadores_pkg.ExisteRegistroPatronal(p_regPatronal) then
      raise e_invalidregistropatronal;
    end if;

    --*********para verificar si la solicitu existe tiene algun subsidio

    select count(*)
      into v_contador
      from sub_sfs_enf_comun_t ec
     where ec.nro_solicitud = p_nro_solicitud;

    if v_contador > 0 then
      open p_iocursor for
      -- EnfermedadComun

        Select s.nro_solicitud,
               decode(s.tipo_subsidio,
                      'M',
                      'Maternidad',
                      'L',
                      'Lactancia',
                      'E',
                      'Enfermedad Comun') tipo_subsidio,
               c.no_documento Documento_Solicitante,
               initCap(c.nombres || ' ' || nvl(c.primer_apellido, '') || ' ' ||
                       nvl(c.segundo_apellido, '')) Nombre_Solicitante,
               decode(e2.tipo_discapacidad,
                      'E',
                      'Enfermedad Comun',
                      'A',
                      'Accidente no laboral',
                      'D',
                      'Discapacidad por Embarazo') tipo_discapacidad,
               decode(e2.ambulatorio, 'S', 'Si', 'N', 'No') ambulatorio,
               e2.fecha_inicio_amb,
               e2.dias_cal_amb,
               decode(e2.hospitalizacion, 'S', 'Si', 'N', 'No') hospitalizacion,
               e2.fecha_inicio_hos,
               e2.dias_cal_hos,
               s.fecha_registro,
               e2.pin,
               e2.codigocie10 Id_codCIE,
               cod.descripcion codigocie10,
               est.desc_estatus Estatus_Registro,
               r.fecha_reintegro,s.nombre_archivo
          from sub_solicitud_t s
          join sre_ciudadanos_t c
            on s.nss = c.id_nss
          join sub_sfs_enf_comun_t e
            on e.nro_solicitud = s.nro_solicitud
          join sub_estatus_t est
            on e.id_estatus = est.id_estatus
          join sub_enfermedad_comun_t e2
            on e2.nro_solicitud = e.nro_solicitud
          left join sfs_cie10_t cod
            on e2.codigocie10 = cod.codigocie
          left join sub_reintegro_t r
            on s.nro_solicitud = r.nro_solicitud

         where s.nro_solicitud = p_nro_solicitud
           and e.id_registro_patronal = p_regPatronal;

      p_resultnumber := '0';
    else
      open p_iocursor for
        Select s.nro_solicitud,
               decode(s.tipo_subsidio,
                      'M',
                      'Maternidad',
                      'L',
                      'Lactancia',
                      'E',
                      'Enfermedad Comun') tipo_subsidio,
               c.no_documento Documento_Solicitante,
               initCap(c.nombres || ' ' || nvl(c.primer_apellido, '') || ' ' ||
                       nvl(c.segundo_apellido, '')) Nombre_Solicitante,
               decode(e2.tipo_discapacidad,
                      'E',
                      'Enfermedad Comun',
                      'A',
                      'Accidente no laboral',
                      'D',
                      'Discapacidad por Embarazo') tipo_discapacidad,
               decode(e2.ambulatorio, 'S', 'Si', 'N', 'No') ambulatorio,
               e2.fecha_inicio_amb,
               e2.dias_cal_amb,
               decode(e2.hospitalizacion, 'S', 'Si', 'N', 'No') hospitalizacion,
               e2.fecha_inicio_hos,
               e2.dias_cal_hos,
               e2.fecha_registro,
               e2.pin,
               e2.codigocie10 Id_codCIE,
               cod.descripcion codigocie10,
               decode(e2.completado,
                      'S',
                      'Completado',
                      'N',
                      'No Completado') Estatus_Registro,
               r.fecha_reintegro,s.nombre_archivo
          from sub_solicitud_t s
          join sre_ciudadanos_t c
            on s.nss = c.id_nss
          join sre_trabajadores_t tr
            on s.nss = tr.id_nss
           and tr.status = 'A'
          join sub_enfermedad_comun_t e2
            on s.nro_solicitud = e2.nro_solicitud
           and e2.nro_solicitud not in
               (select ec.nro_solicitud from sub_sfs_enf_comun_t ec)
          left join sfs_cie10_t cod
            on e2.codigocie10 = cod.codigocie
          left join sub_reintegro_t r
            on s.nro_solicitud = r.nro_solicitud

         where s.nro_solicitud = p_nro_solicitud
           and tr.id_registro_patronal = p_regPatronal;

      p_resultnumber := '0';

    end if;
  EXCEPTION

    when e_invalidregistropatronal then
      p_resultnumber := seg_retornar_cadena_error(10, null, null);
      return;
    when e_InvialidSolicitud then
      p_resultnumber := Seg_Retornar_Cadena_Error(181, NULL, NULL);
      return;
    when others then
      v_bderror      := (substr('error ' || to_char(sqlcode) || ': ' ||
                                sqlerrm,
                                1,
                                255));
      p_resultnumber := seg_retornar_cadena_error(-1, v_bderror, sqlcode);
  End getDetSubsidiosSFS_E;

  -- ******************************************************************************************************
  -- PROCEDIMIENTO:     getCuotasSubsidios
  -- DESCRIPTION:       Trae las cuotas asociadas a un subsidio
  -- AUTOR:             charlie Pena
  -- Fecha:             1/Mar/2011
  -- ******************************************************************************************************
  PROCEDURE getCuotasSubsidios(p_nro_solicitud in sub_solicitud_t.nro_solicitud%type,
                               p_regPatronal   in sre_empleadores_t.rnc_o_cedula %type,
                               p_tipo_Subsidio in sub_solicitud_t.tipo_subsidio%type,
                               p_iocursor      IN OUT t_cursor,
                               p_resultnumber  OUT VARCHAR2)

   Is
    v_bderror VARCHAR(1000);
    e_InvialidSolicitud       exception;
    e_invalidregistropatronal exception;
  Begin
    if p_nro_solicitud is not null and p_tipo_Subsidio is not null then

      if p_tipo_Subsidio <> 'L' then
        if not sre_empleadores_pkg.ExisteRegistroPatronal(p_regPatronal) then
          raise e_invalidregistropatronal;
        end if;
      end if;

      if not sub_sfs_subsidios.existeSolicitud(p_nro_solicitud) then
        raise e_InvialidSolicitud;
      end if;

      open p_iocursor for

        select distinct s.nro_solicitud,
                        decode(s.tipo_subsidio,
                               'M',
                               'Maternidad',
                               'L',
                               'Lactancia',
                               'E',
                               'Enfermedad Comun') tipo_subsidio,
                        c.nro_pago,
                        c.periodo,
                        decode(c.tipo_cuenta,
                               '1',
                               'Corriente',
                               '2',
                               'Ahorro') Tipo_cuenta,
                        c.cuenta_banco,
                        initCap(t.entidad_recaudadora_des) entidad_recaudadora_des,
                        c.nro_referencia,
                        c.monto_subsidio,
                        c.status_pago id_status_pago,
                        decode(c.status_pago,
                               'N',
                               'No Pagado',
                               'P',
                               'Pagado',
                               'R',
                               'El pago fue rechazado por el banco') Status_Pago,
                        c.fecha_pago
          from sub_solicitud_t s
          join sub_cuotas_t c
            on c.nro_solicitud = s.nro_solicitud
          left join sfc_entidad_recaudadora_t t
            on t.id_entidad_recaudadora = c.id_entidad_recaudadora
         where s.nro_solicitud = p_nro_solicitud
           and s.tipo_subsidio = p_tipo_Subsidio
           and (p_regPatronal is null or
               c.id_registro_patronal = p_regPatronal)
         order by c.periodo asc;

      p_resultnumber := '0';
    else
      p_resultnumber := 'El numero de solicitud y el tipo no pueden estar nulos';
    end if;

  EXCEPTION

    when e_invalidregistropatronal then
      p_resultnumber := seg_retornar_cadena_error(10, null, null);
      return;
    when e_InvialidSolicitud then
      p_resultnumber := Seg_Retornar_Cadena_Error(181, NULL, NULL);
      return;
    when others then
      v_bderror      := (substr('error ' || to_char(sqlcode) || ': ' ||
                                sqlerrm,
                                1,
                                255));
      p_resultnumber := seg_retornar_cadena_error(-1, v_bderror, sqlcode);
  End getCuotasSubsidios;

  -- ******************************************************************************************************
  -- PROCEDIMIENTO:     getImagenSubSFS
  -- DESCRIPTION:       Devuelve la imagen correspondiente a un numero de solicitud especifico.
  -- AUTOR:             charlie Pena
  -- FECHA:             15-02-2011
  -- ******************************************************************************************************
  procedure getImagenSubSFS(p_nro_solicitud in sub_solicitud_t.nro_solicitud%type,
                            p_iocursor      IN OUT t_cursor,
                            p_resultnumber  OUT VARCHAR2) is
    e_InvialidSolicitud exception;
    c_cursor  t_cursor;
    v_bderror VARCHAR(1000);
  Begin
    if not sub_sfs_subsidios.existeSolicitud(p_nro_solicitud) then
      raise e_InvialidSolicitud;
    end if;

    open c_cursor for
      Select s.imagen
        From Sub_Solicitud_t s
       where s.nro_solicitud = p_nro_solicitud;

    p_iocursor     := c_cursor;
    p_resultnumber := 0;

  EXCEPTION
    when e_InvialidSolicitud then
      p_resultnumber := Seg_Retornar_Cadena_Error(181, NULL, NULL);
      return;
    when others then
      v_bderror      := (substr('error ' || to_char(sqlcode) || ': ' ||
                                sqlerrm,
                                1,
                                255));
      p_resultnumber := seg_retornar_cadena_error(-1, v_bderror, sqlcode);
  End getImagenSubSFS;

  -- ******************************************************************************************************
  -- PROCEDIMIENTO:     getEstatusSubSFS
  -- DESCRIPTION:       Devuelve la lista de estatus para los subsidios SFS.
  -- AUTOR:             charlie Pena
  -- FECHA:             15-02-2011
  -- ******************************************************************************************************
  PROCEDURE getEstatusSubSFS(p_iocursor     IN OUT t_cursor,
                             p_resultnumber OUT VARCHAR2) is
    c_cursor  t_cursor;
    v_bderror varchar(1000);
  Begin
    Open c_cursor for
      Select s.id_estatus Id, s.desc_estatus descripcion
        From sub_estatus_t s
       order by 2;

    p_iocursor     := c_cursor;
    p_resultnumber := 0;
  EXCEPTION
    when others then
      v_bderror      := (substr('error ' || to_char(sqlcode) || ': ' ||
                                sqlerrm,
                                1,
                                255));
      p_resultnumber := seg_retornar_cadena_error(-1, v_bderror, sqlcode);

  end getEstatusSubSFS;

  -- ******************************************************************************************************
  -- PROCEDIMIENTO:     existeSolicitud
  -- DESCRIPTION:       Devuelve "true" si la solicitud existe, "false" si la solicitud no existe.
  -- AUTOR:             charlie Pena
  -- FECHA:             15-02-2011
  -- ******************************************************************************************************
  function existeSolicitud(p_nroSolicitud in number) return boolean is
    v_count INTEGER := 0;
  begin

    select count(*)
      into v_count
      from sub_solicitud_t s
     where s.nro_solicitud = p_nroSolicitud;

    if (v_count = 0) then
      return false;
    end if;
    return true;

  end existeSolicitud;
  procedure getNominaDiscapacitados(p_idnss              in sre_trabajadores_t.id_nss%type,
                                    p_idRegistroPatronal in sre_trabajadores_t.id_registro_patronal%type,
                                    p_resultnumber       OUT varchar2,
                                    p_io_cursor          OUT t_cursor) IS
    e_Existe_IdNss                 exception;
    e_Existe_IdRegistroPatronal    exception;
    e_Existe_IdNssRegistroPatronal exception;
    e_Existe_NominaDiscapcidad     exception;
    v_cursor  t_cursor;
    v_bderror varchar2(1000);
  BEGIN

    --Validamos si existen
    IF (p_idnss is not null) and (p_idRegistroPatronal is null) THEN
      raise e_Existe_IdRegistroPatronal;
    END IF;

    IF (p_idnss is null) and (p_idRegistroPatronal is not null) THEN
      raise e_Existe_IdNss;
    END IF;

    IF (p_idnss is null) and (p_idRegistroPatronal is null) THEN
      raise e_Existe_IdNssRegistroPatronal;
    END IF;

    OPEN v_cursor FOR
      SELECT t.id_nss, n.id_nomina, n.nomina_des, t.id_registro_patronal
        FROM sre_trabajadores_t t, sre_nominas_t n
       WHERE t.id_nomina = n.id_nomina
         and t.id_registro_patronal = n.id_registro_patronal
         and t.id_nss = p_idnss
         and t.id_registro_patronal = p_idRegistroPatronal
         and t.status = 'A'
       ORDER BY n.nomina_des DESC;

    p_io_cursor    := v_cursor;
    p_resultnumber := 0;

  EXCEPTION

    WHEN e_Existe_IdRegistroPatronal THEN
      p_resultnumber := 'Debe digitar Registro Patronal'; --Seg_Retornar_Cadena_Error(223, NULL, NULL);
      RETURN;

    WHEN e_Existe_IdNss THEN
      p_resultnumber := 'Debe digitar Id Nss'; --Seg_Retornar_Cadena_Error(223, NULL, NULL);
      RETURN;

    WHEN e_Existe_IdNssRegistroPatronal THEN
      p_resultnumber := 'Debe seleccionar el Id Nss y el Registro Patronal'; --Seg_Retornar_Cadena_Error(223, NULL, NULL);
      RETURN;

    WHEN e_Existe_NominaDiscapcidad THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(223, NULL, NULL);
      RETURN;

    WHEN OTHERS THEN
      v_bderror      := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultnumber := Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
      RETURN;

  END getNominaDiscapacitados;

  ------------------------------------------------------------------
  -- Obtener los datos iniciales del una enfermedad comun
  -----------------------------------------------------------------
  procedure ObtenerDatosIniciales(p_nro_solicitud IN sub_solicitud_t.nro_solicitud%TYPE,
                                  p_resultnumber  OUT varchar2,
                                  p_io_cursor     OUT t_cursor) IS
    v_bderror varchar2(1000);
  Begin
    Open p_io_cursor For
      Select direccion, telefono, email, celular
        From sub_enfermedad_comun_t e
       Where e.nro_solicitud = p_nro_solicitud;

    p_resultnumber := '0';
  Exception
    When Others Then
      v_bderror      := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultnumber := Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
  End;

  --****************************************************************************************************************
  PROCEDURE GetReImpresionEnfComun(P_CEDULA       IN SRE_CIUDADANOS_T.NO_DOCUMENTO%type,
                                   P_PIN          IN SFS_ENFERMEDAD_COMUN_T.PIN%TYPE,
                                   p_io_cursor    OUT T_CURSOR,
                                   P_RESULTNUMBER OUT VARCHAR2) IS

    V_CURSOR T_CURSOR;

  BEGIN
    OPEN V_CURSOR FOR
      SELECT lpad(s.nss, 10, 0) || '' || lpad(s.padecimiento, 5, 0) || '' ||
             lpad(s.secuencia, 3, 0) nroformulario,
             s.nss id_nss,
             s.secuencia,
             rtrim(ltrim(c.nombres)) || ' ' ||
             rtrim(ltrim(c.primer_apellido)) || ' ' ||
             rtrim(ltrim(c.segundo_apellido)) nombre_afiliado,
             c.no_documento cedula,
             e.pin,
             c.sexo

        from sub_solicitud_t s
        join sub_enfermedad_comun_t e
          on s.nro_solicitud = e.nro_solicitud
        join sre_ciudadanos_t c
          on s.nss = c.id_nss
       where c.no_documento = P_CEDULA
         and e.pin = P_PIN;

    P_RESULTNUMBER := 0;
    p_io_cursor    := v_cursor;

  EXCEPTION
    WHEN OTHERS THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(-1,
                                                  SUBSTR('error ' ||
                                                         TO_CHAR(SQLCODE) || ': ' ||
                                                         SQLERRM,
                                                         1,
                                                         255),
                                                  SQLCODE);
  end GetReImpresionEnfComun;

  --***************************************************************************************
  PROCEDURE GetReImpresionMaternidad(P_CEDULA       IN SUIRPLUS.SRE_CIUDADANOS_T.NO_DOCUMENTO%type,
                                     P_PIN          IN SUIRPLUS.SUB_SOLICITUD_T.NRO_SOLICITUD%TYPE,
                                     p_io_cursor    OUT T_CURSOR,
                                     P_RESULTNUMBER OUT VARCHAR2) IS

    V_CURSOR T_CURSOR;

  BEGIN
    OPEN V_CURSOR FOR
      SELECT lpad(s.nss, 10, 0) || '' ||
             lpad(m.id_registro_patronal_re, 5, 0) || '' ||
             lpad(s.secuencia, 3, 0) nroformulario,
             s.nss id_nss,
             s.secuencia,
             rtrim(ltrim(c.nombres)) || ' ' ||
             rtrim(ltrim(c.primer_apellido)) || ' ' ||
             rtrim(ltrim(c.segundo_apellido)) nombre_afiliado,
             c.no_documento cedula,
             substr(lpad(m.nro_solicitud, 10, '0'), -4) pin,
             c.sexo

        from sub_solicitud_t s
        join sub_maternidad_t m
          on m.nro_solicitud = s.nro_solicitud
        join sre_ciudadanos_t c
          on s.nss = c.id_nss
       where c.no_documento = P_CEDULA
         and substr(lpad(m.nro_solicitud, 10, '0'), -4) = P_PIN;

    P_RESULTNUMBER := 0;
    p_io_cursor    := v_cursor;

  EXCEPTION
    WHEN OTHERS THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(-1,
                                                  SUBSTR('error ' ||
                                                         TO_CHAR(SQLCODE) || ': ' ||
                                                         SQLERRM,
                                                         1,
                                                         255),
                                                  SQLCODE);
  end GetReImpresionMaternidad;

/*
-- ===================================================
-- Para traer las cuotas de las subsidios pendientes
-- Gregorio Herrera
-- 03/nov/2011
-- ===================================================
*/
PROCEDURE GetDetSubsidioEmpresa (
               P_NroSolicitud     in varchar2,
               P_RegistroPatronal IN SUB_SFS_ENF_COMUN_T.id_registro_patronal%type,
               p_io_cursor        OUT sys_refcursor,
               p_resultnumber     OUT VARCHAR2) IS

  v_fnEmpleado sys_refcursor;
  curSalida sys_refcursor;
  resultado VARCHAR2(1000);

  v_resultado varchar2(5);
  v_RegPat    integer;
  v_NumCouta  integer;
  v_Monto     Number(12,2);
  v_periodo   Date;

  v_FECHA_INICIO_AMB  sub_enfermedad_comun_t.fecha_inicio_amb%type;
  v_DIAS_CAL_AMB      sub_enfermedad_comun_t.dias_cal_amb%type;
  v_FECHA_INICIO_HOS  sub_enfermedad_comun_t.fecha_inicio_hos%type;
  v_DIAS_CAL_HOS      sub_enfermedad_comun_t.dias_cal_hos%type;
  v_select            varchar2(8000) := null;
  v_parm_date         date;
  v_periodo_fac       sfc_facturas_t.periodo_factura%type; -- Igual a p_fecha_inicio

-- Para grabar la data de entrada y salida en la funcion de TKL
-- v_tkl_cur_entrada tkl_cursor_entrada;
-- v_tkl_cur_salida  tkl_cursor_salida;
/*
  v_salario_1       number(12,2);
  v_salario_2       number(12,2);
  v_salario_3       number(12,2);
  v_salario_4       number(12,2);
  v_salario_5       number(12,2);
  v_salario_6       number(12,2);
  v_salario_7       number(12,2);
  v_salario_8       number(12,2);
  v_salario_9       number(12,2);
  v_salario_10      number(12,2);
  v_salario_11      number(12,2);
  v_salario_12      number(12,2);
*/
  v_fecha_subsidio suirplus.sub_enfermedad_comun_t.fecha_inicio_amb%type;
  v_periodo_subsidio suirplus.sfc_facturas_t.periodo_factura%type;
  v_salario_minimo_nacional  sfs_elegibles_t.salario_cotizable%type;
  v_parm Parm;
BEGIN

  p_resultnumber := '-1';

-- Busca el estatus para subsidio enfermedad comun donde estatus = 'OK'
  FOR i in (
            select MAX(ele.ID_estatus), sol.nss, sol.secuencia, sol.padecimiento
            from suirplus.SUB_SOLICITUD_T sol
            join suirplus.SUB_ELEGIBLES_T ele
              on ele.nro_solicitud = sol.nro_solicitud
            join suirplus.sub_sfs_enf_comun_t sub
              on sub.nro_solicitud = sol.nro_solicitud
             and sub.id_registro_patronal = P_RegistroPatronal
            where sol.nro_solicitud = p_NroSolicitud
              and sol.TIPO_SUBSIDIO = 'E'
            Group by sol.nss, sol.secuencia, sol.padecimiento
            )
  LOOP
    select e.fecha_inicio_amb,e.dias_cal_amb,e.fecha_inicio_hos,e.dias_cal_hos
      into v_FECHA_INICIO_AMB ,v_DIAS_CAL_AMB, v_FECHA_INICIO_HOS, v_DIAS_CAL_HOS
    from suirplus.sub_enfermedad_comun_t e
    where e.nro_solicitud = p_NroSolicitud;


      If (nvl(v_FECHA_INICIO_AMB,sysdate+3000) <  nvl(v_FECHA_INICIO_HOS,sysdate+3000)) Then
          v_fecha_subsidio := v_FECHA_INICIO_AMB;
      Else
          v_fecha_subsidio := v_FECHA_INICIO_HOS;
      End If;


    v_periodo_fac := suirplus.parm.periodo_vigente(nvl(v_fecha_subsidio,sysdate)); --'200806';

    open v_fnEmpleado for
      select DISTINCT f.id_registro_patronal,
                nvl(sum(decode(f.periodo_factura, srp_pkg.add_periodo(v_periodo_fac,-12),d.salario_ss)),0) "salario1",
                nvl(sum(decode(f.periodo_factura, srp_pkg.add_periodo(v_periodo_fac,-11),d.salario_ss)),0) "salario2",
                nvl(sum(decode(f.periodo_factura, srp_pkg.add_periodo(v_periodo_fac,-10),d.salario_ss)),0) "salario3",
                nvl(sum(decode(f.periodo_factura, srp_pkg.add_periodo(v_periodo_fac, -9),d.salario_ss)),0) "salario4",
                nvl(sum(decode(f.periodo_factura, srp_pkg.add_periodo(v_periodo_fac, -8),d.salario_ss)),0) "salario5",
                nvl(sum(decode(f.periodo_factura, srp_pkg.add_periodo(v_periodo_fac, -7),d.salario_ss)),0) "salario6",
                nvl(sum(decode(f.periodo_factura, srp_pkg.add_periodo(v_periodo_fac, -6),d.salario_ss)),0) "salario7",
                nvl(sum(decode(f.periodo_factura, srp_pkg.add_periodo(v_periodo_fac, -5),d.salario_ss)),0) "salario8",
                nvl(sum(decode(f.periodo_factura, srp_pkg.add_periodo(v_periodo_fac, -4),d.salario_ss)),0) "salario9",
                nvl(sum(decode(f.periodo_factura, srp_pkg.add_periodo(v_periodo_fac, -3),d.salario_ss)),0) "salario10",
                nvl(sum(decode(f.periodo_factura, srp_pkg.add_periodo(v_periodo_fac, -2),d.salario_ss)),0) "salario11",
                nvl(sum(decode(f.periodo_factura, srp_pkg.add_periodo(v_periodo_fac, -1),d.salario_ss)),0) "salario12"
      from sfc_facturas_t f, sfc_det_facturas_t d
      where f.status = 'PA'
        and f.id_tipo_factura <> 'AU'
        and d.id_referencia = f.id_referencia
        and d.id_nss = i.nss
      group by f.id_registro_patronal
      order by 1 desc;



      --Calcular el periodo--
      --FR 2010-01-23--
      v_periodo_subsidio := suirplus.parm.periodo_vigente(v_fecha_subsidio);

      --Determinar el salario minimo nacional a partir del constructor--
      --FR 2010-02-23--
      v_parm := suirplus.parm(v_periodo_subsidio);

      --Obtener el salario minimo nacional--
      --FR 2010-02-23--
      v_salario_minimo_nacional := v_parm.salario_minimo_nacional;

      v_resultado := fn_empleados(v_fnEmpleado,v_FECHA_INICIO_HOS,v_DIAS_CAL_HOS,v_FECHA_INICIO_AMB,v_DIAS_CAL_AMB,v_salario_minimo_nacional,curSalida,resultado);

      v_parm_date := Parm.get_parm_date(40);

      if (trunc(sysdate) < trunc(v_parm_date)) then
        v_periodo := trunc(sysdate);
      else
        v_periodo := ADD_MONTHS(trunc(sysdate),1);
      end if;
/*
    -- Para inicializar tablas para fines de debugger
    open v_fnEmpleado for
      select DISTINCT f.id_registro_patronal,
                nvl(sum(decode(f.periodo_factura, srp_pkg.add_periodo(v_periodo_fac,-12),d.salario_ss)),0) "salario1",
                nvl(sum(decode(f.periodo_factura, srp_pkg.add_periodo(v_periodo_fac,-11),d.salario_ss)),0) "salario2",
                nvl(sum(decode(f.periodo_factura, srp_pkg.add_periodo(v_periodo_fac,-10),d.salario_ss)),0) "salario3",
                nvl(sum(decode(f.periodo_factura, srp_pkg.add_periodo(v_periodo_fac, -9),d.salario_ss)),0) "salario4",
                nvl(sum(decode(f.periodo_factura, srp_pkg.add_periodo(v_periodo_fac, -8),d.salario_ss)),0) "salario5",
                nvl(sum(decode(f.periodo_factura, srp_pkg.add_periodo(v_periodo_fac, -7),d.salario_ss)),0) "salario6",
                nvl(sum(decode(f.periodo_factura, srp_pkg.add_periodo(v_periodo_fac, -6),d.salario_ss)),0) "salario7",
                nvl(sum(decode(f.periodo_factura, srp_pkg.add_periodo(v_periodo_fac, -5),d.salario_ss)),0) "salario8",
                nvl(sum(decode(f.periodo_factura, srp_pkg.add_periodo(v_periodo_fac, -4),d.salario_ss)),0) "salario9",
                nvl(sum(decode(f.periodo_factura, srp_pkg.add_periodo(v_periodo_fac, -3),d.salario_ss)),0) "salario10",
                nvl(sum(decode(f.periodo_factura, srp_pkg.add_periodo(v_periodo_fac, -2),d.salario_ss)),0) "salario11",
                nvl(sum(decode(f.periodo_factura, srp_pkg.add_periodo(v_periodo_fac, -1),d.salario_ss)),0) "salario12"
      from sfc_facturas_t f, sfc_det_facturas_t d
      where f.status = 'PA'
        and f.id_tipo_factura <> 'AU'
        and d.id_referencia = f.id_referencia
        and d.id_nss = v_idnss
      group by f.id_registro_patronal
      order by 1 desc;
*/
    If resultado = '0' then
/*       -- Iteramos el cursor de entrada
      v_tkl_cur_entrada := tkl_cursor_entrada();
      Loop
        Fetch v_fnEmpleado into
        v_reg_pat,
        v_salario_1,
        v_salario_2,
        v_salario_3,
        v_salario_4,
        v_salario_5,
        v_salario_6,
        v_salario_7,
        v_salario_8,
        v_salario_9,
        v_salario_10,
        v_salario_11,
        v_salario_12;
        Exit When v_fnEmpleado%NotFound;
        v_tkl_cur_entrada.extend();
        v_tkl_cur_entrada(v_tkl_cur_entrada.last) := tkl_record_entrada();
        v_tkl_cur_entrada(v_tkl_cur_entrada.last).id_reg_pat := v_reg_pat;
        v_tkl_cur_entrada(v_tkl_cur_entrada.last).salario_1  := v_salario_1;
        v_tkl_cur_entrada(v_tkl_cur_entrada.last).salario_2  := v_salario_2;
        v_tkl_cur_entrada(v_tkl_cur_entrada.last).salario_3  := v_salario_3;
        v_tkl_cur_entrada(v_tkl_cur_entrada.last).salario_4  := v_salario_4;
        v_tkl_cur_entrada(v_tkl_cur_entrada.last).salario_5  := v_salario_5;
        v_tkl_cur_entrada(v_tkl_cur_entrada.last).salario_6  := v_salario_6;
        v_tkl_cur_entrada(v_tkl_cur_entrada.last).salario_7  := v_salario_7;
        v_tkl_cur_entrada(v_tkl_cur_entrada.last).salario_8  := v_salario_8;
        v_tkl_cur_entrada(v_tkl_cur_entrada.last).salario_9  := v_salario_9;
        v_tkl_cur_entrada(v_tkl_cur_entrada.last).salario_10 := v_salario_10;
        v_tkl_cur_entrada(v_tkl_cur_entrada.last).salario_11 := v_salario_11;
        v_tkl_cur_entrada(v_tkl_cur_entrada.last).salario_12 := v_salario_12;
      End Loop;
*/
      -- iteramos el cursor de salida
--        v_tkl_cur_salida := tkl_cursor_salida();
      loop
        fetch curSalida into v_RegPat, v_NumCouta, v_Monto;
        exit when curSalida%notfound;

        if (v_RegPat = P_RegistroPatronal) then
            if (v_select is null) then
              v_select := 'select '||v_NumCouta||' Cuota,'''||extract(year from v_periodo)||'-'||lpad(extract(month from v_periodo),2,'0')||''' Periodo,'||v_Monto||' Monto, ''Pendiente de Pago'' status, ''Preliminar'' Tipo_Calculo from dual';
            else
              v_periodo := trunc(ADD_MONTHS(v_periodo,1));
              v_select := v_select || ' union select '||v_NumCouta||' Cuota,'''||extract(year from v_periodo)||'-'||lpad(extract(month from v_periodo),2,'0')||''' Periodo,'||v_Monto||' Monto, ''Pendiente de Pago'' status, ''Preliminar'' Tipo_Calculo from dual';
            end if;
        end if;

        -- Para llenar la tabla que sera grabada para fines de debugger
/*
        v_tkl_cur_salida.extend();
        v_tkl_cur_salida(v_tkl_cur_salida.last) := tkl_record_salida();
        v_tkl_cur_salida(v_tkl_cur_salida.last).id_reg_pat := v_RegPat;
        v_tkl_cur_salida(v_tkl_cur_salida.last).num_cuotas := v_NumCouta;
        v_tkl_cur_salida(v_tkl_cur_salida.last).monto_total:= v_Monto;
*/
      end loop;

      -- Insertamos en la tabla debugger
/*
      Insert into tkl_table_t
      (
       ID_REGISTRO_PATRONAL,
       ID_NSS,
       NRO_SOLICITUD,
       FECHA_INICIO_HOS,
       DIAS_CAL_HOS,
       FECHA_INICIO_AMB,
       DIAS_CAL_AMB,
       CURSOR_ENTRADA,
       CURSOR_SALIDA,
       ULT_FEC_ACT
      )
      values
      (P_RegistroPatronal,
       v_idnss,
       P_NroSolicitud,
       v_FECHA_INICIO_HOS,
       v_DIAS_CAL_HOS,
       v_FECHA_INICIO_AMB,
       v_DIAS_CAL_AMB,
       v_tkl_cur_entrada,
       v_tkl_cur_salida,
       sysdate
      );
      commit;
*/
      open p_io_cursor for v_select;
      if p_io_cursor%NOTFOUND then
        p_resultnumber := '-1';
      end if;
    Else
      p_resultnumber := resultado;
    End if;
  END LOOP;
EXCEPTION
 WHEN OTHERS THEN
   p_resultnumber := Seg_Retornar_Cadena_Error(-1, SUBSTR('error '||TO_CHAR(SQLCODE)||': '||SQLERRM, 1, 255), SQLCODE);
END GetDetSubsidioEmpresa;

  -- ******************************************************************************************************
  -- PROCEDIMIENTO:     GetPagosSubsidiosSFS
  -- DESCRIPTION:       Trae el reporte de los pagos de los subsidios del SFS realizados por un registro patronal.
  -- AUTOR:             Yacell Borges
  -- FECHA:             9-4-2012
  -- ******************************************************************************************************

PROCEDURE GetPagosSubsidiosSFS(P_RegistroPatronal IN sub_cuotas_t.id_registro_patronal%type,
                                                  p_cedula in Sre_Ciudadanos_t.No_Documento%type,
                                                  p_tiposubsidio in sub_solicitud_t.tipo_subsidio%type,
                                                  p_fechadesde in sub_solicitud_t.fecha_registro%type,
                                                  p_fechahasta in sub_solicitud_t.fecha_registro%type,
                                                  p_fechapagodesde in sub_cuotas_t.fecha_pago%type,
                                                  p_fechapagohasta in sub_cuotas_t.fecha_pago%type,
                                                  p_pagenum  in number,
                                                  p_pagesize in number,
                                                  p_io_cursor        OUT T_CURSOR,
                                                  p_resultnumber     OUT VARCHAR2) IS

  c_cursor t_cursor;
  v_bderror varchar2(3000);
  vDesde integer := (p_pagesize *(p_pagenum-1))+1;
  vHasta integer := p_pagesize*p_pagenum;
  V_Nss integer;


Begin

   if p_cedula is not null then
    select c.id_nss
      into v_Nss
      from sre_ciudadanos_t c
     where c.no_documento = p_cedula;
     end if;

  open c_cursor for

   with x as (select rownum num, y .* from
         (Select
      su.no_documento,
     su.id_nss,
    initcap(su.nombres||' '||su.primer_apellido||' '|| su.segundo_apellido) nombres,
     decode(sc.tipo_subsidio,'M','Maternidad','L','Lactancia','E', 'Enfermedad Comun')tipo_subsidio,
     sc.nro_pago,
     decode(sc.status_pago,'N', 'No pagado', 'P', 'Pagado', 'R', 'Rechazado') status_pago,
     sc.monto_subsidio,
     decode(sc.via,'NP','Notificacion de pago', 'CB', 'Cuenta Bancaria', 'CU', '')via_pago,
     sc.nro_referencia,
     sc.cuenta_banco,
     srp_pkg.fmt_periodo(sc.periodo)periodo,
     sc.fecha_pago,
     ss.fecha_registro
      from sub_cuotas_t sc, sub_solicitud_t ss, sre_ciudadanos_t su
      where sc.id_registro_patronal = P_RegistroPatronal
        and ss.nro_solicitud = sc.nro_solicitud
        and ss.tipo_subsidio = nvl(p_tiposubsidio, ss.tipo_subsidio)
        and trunc(ss.fecha_registro) between
                 NVL(p_fechadesde, trunc(ss.fecha_registro)) and
                 NVL(p_fechahasta, trunc(ss.fecha_registro))
                 and trunc(sc.fecha_pago) between
                 NVL(p_fechapagodesde, trunc(sc.fecha_pago)) and
                 NVL(p_fechapagohasta, trunc(sc.fecha_pago))
        and su.id_nss = ss.nss
        and su.id_nss = nvl(V_Nss, su.id_nss)
      order by ss.fecha_registro, sc.nro_pago)y)select y.recordcount, x.*
         from x,(select max(num)recordcount from x)y
         where num between (vDesde) and (vHasta)
         order by num;

  P_RESULTNUMBER := 0;
  p_io_cursor    := c_cursor;

EXCEPTION
  when others then
      v_bderror      := (substr('error ' || to_char(sqlcode) || ': ' ||
                                sqlerrm,
                                1,
                                255));
      p_resultnumber := seg_retornar_cadena_error(-1, v_bderror, sqlcode);

end ;


 -- ******************************************************************************************************
 -- PROCEDIMIENTO:     getCuotasSubsidios
 -- DESCRIPTION:       Trae las cuotas asociadas a un subsidio
 -- AUTOR:             Mayreni Vargas
 -- Fecha:             1/Jun/2013
 -- ******************************************************************************************************
PROCEDURE getCuotasSubsidios(p_fechaDesde   in sub_solicitud_t.fecha_registro%type,
                             p_fechaHasta   in sub_solicitud_t.fecha_registro%type,
                             p_tipoempresa  in sre_empleadores_t.tipo_empresa%type,
                             p_pagenum      in number,
                             p_pagesize     in number,
                             p_iocursor     IN OUT t_cursor,
                             p_resultnumber OUT VARCHAR2)

 Is
  v_bderror VARCHAR(1000);
  v_periododesde number(6);
  v_periodohasta number(6);
  vDesde        integer := (p_pagesize * (p_pagenum - 1)) + 1;
  vhasta        integer := p_pagesize * p_pagenum;
Begin


   v_periododesde := parm.periodo_vigente(p_fechaDesde);
   v_periodohasta := parm.periodo_vigente(p_fechaHasta);


  open p_iocursor for
    with x as
       (select rownum num, y.*
          from (
    select distinct s.nro_solicitud,
                    decode(s.tipo_subsidio,
                           'M',
                           'Maternidad',
                           'L',
                           'Lactancia',
                           'E',
                           'Enfermedad Comun') tipo_subsidio,
                    c.nro_pago,
                    c.periodo,
                    decode(c.tipo_cuenta, '1', 'Corriente', '2', 'Ahorro') Tipo_cuenta,
                    c.cuenta_banco,
                    initCap(t.entidad_recaudadora_des) entidad_recaudadora_des,
                    c.nro_referencia,
                    c.monto_subsidio,
                    c.status_pago id_status_pago,
                    decode(c.status_pago,
                           'N',
                           'No Pagado',
                           'P',
                           'Pagado',
                           'R',
                           'El pago fue rechazado por el banco') Status_Pago,
                    c.fecha_pago,
                    e.razon_social,
                    e.rnc_o_cedula,
                    ci.nombres || ' ' || ci.primer_apellido || ' ' ||
                    ci.segundo_apellido Nombre,
                    ci.no_documento
      from sub_solicitud_t s
      join sub_cuotas_t c
        on c.nro_solicitud = s.nro_solicitud
           join sre_ciudadanos_t ci
        on ci.id_nss = s.nss
     join sre_empleadores_t e
        on e.id_registro_patronal  = c.id_registro_patronal
      left join sfc_entidad_recaudadora_t t
        on t.id_entidad_recaudadora = c.id_entidad_recaudadora
     where c.tipo_subsidio != 'L'
      and c.periodo >= v_periododesde and c.periodo <= v_periodohasta
       and e.tipo_empresa = nvl(p_tipoempresa,e.tipo_empresa)
       and c.status_pago = 'P'
     order by c.periodo asc
  ) y)
      select y.recordcount, x.*
        from x, (select max(num) recordcount from x) y
       where num between vDesde and vHasta
       order by num asc;
  p_resultnumber := '0';


EXCEPTION


when others then v_bderror := (substr('error ' || to_char(sqlcode) || ': ' || sqlerrm, 1, 255)); p_resultnumber := seg_retornar_cadena_error(-1, v_bderror, sqlcode);

End getCuotasSubsidios;

end SUB_SFS_SUBSIDIOS;