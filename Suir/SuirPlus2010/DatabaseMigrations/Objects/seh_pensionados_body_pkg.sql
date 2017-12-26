create or replace package body suirplus.SEH_PENSIONADOS_PKG is
  m_id_bitacora SFC_BITACORA_T.id_bitacora%TYPE;

  TYPE t_error IS TABLE OF seg_error_t%ROWTYPE index by binary_integer;
  m_error t_error;

  -- ==============================================
  -- Insertar el registro en la maestra de bitacora
  -- ==============================================
  PROCEDURE bitacora(p_id_bitacora IN OUT SUIRPLUS.SFC_BITACORA_T.id_bitacora%TYPE,
                     p_accion      IN VARCHAR2 DEFAULT 'INI',
                     p_id_proceso  IN SUIRPLUS.SFC_BITACORA_T.id_proceso%TYPE,
                     p_mensage     IN SUIRPLUS.SFC_BITACORA_T.mensage%TYPE DEFAULT NULL,
                     p_status      IN SUIRPLUS.SFC_BITACORA_T.status%TYPE DEFAULT NULL,
                     p_id_error    IN SUIRPLUS.SEG_ERROR_T.id_error%TYPE DEFAULT NULL,
                     p_seq_number  IN SUIRPLUS.ERRORS.seq_number%TYPE DEFAULT NULL,
                     p_periodo     IN SUIRPLUS.SFC_BITACORA_T.periodo%TYPE DEFAULT NULL) IS
  BEGIN
    CASE p_accion
      WHEN 'INI' THEN
        SELECT SUIRPLUS.sfc_bitacora_seq.NEXTVAL
          INTO p_id_bitacora
          FROM dual;
        INSERT INTO SUIRPLUS.SFC_BITACORA_T
          (id_proceso,
           id_bitacora,
           fecha_inicio,
           fecha_fin,
           mensage,
           status,
           periodo)
        VALUES
          (p_id_proceso,
           p_id_bitacora,
           SYSDATE,
           NULL,
           p_mensage,
           'P',
           p_periodo);

      WHEN 'FIN' THEN
        UPDATE SUIRPLUS.SFC_BITACORA_T
           SET fecha_fin  = SYSDATE,
               mensage    = p_mensage,
               status     = p_status,
               seq_number = p_seq_number,
               id_error   = p_id_error
         WHERE id_bitacora = p_id_bitacora;
      ELSE
        RAISE_APPLICATION_ERROR(010, 'Parámetro invalido');
    END CASE;
    COMMIT;
  END;
  
  -- --------------------------------------------------------------------------------------------------
  -- Objetivo: lleva en memoria, los errores encontrados en la validación que se le hace a los registros
  --           luego estos errores son enviados por correo como el resultado del proceso
  --    Autor: Gregorio Herrera.
  --    Fecha: 05/06/2009
  -- --------------------------------------------------------------------------------------------------
  procedure anotar_error(p_id_error suirplus.seg_error_t.id_error%type,
                         p_desc_error suirplus.seg_error_t.error_des%type) is
    l_existe boolean := false;
    l_index  binary_integer;
  begin
    if (m_error.count() = 0) then
      m_error(1).id_error        := p_id_error;
      m_error(1).error_des       := p_desc_error;
      m_error(1).codigo_error_bd := '1';
    else
      for r in m_error.first..m_error.last loop
        if (m_error(r).error_des = p_desc_error) then
          m_error(r).codigo_error_bd := to_char(to_number(m_error(r).codigo_error_bd) + 1);
          l_existe := true;
          exit;
        end if;
      end loop;
      if (not l_existe) then
        l_index := m_error.count()+1;
        m_error(l_index).id_error        := p_id_error;
        m_error(l_index).error_des       := p_desc_error;
        m_error(l_index).codigo_error_bd := '1';
      end if;
    end if;
  end;

  -- --------------------------------------------------------------------------------------------------
  -- Objetivo: enviar por email el resultado de las validaciones de los registros y la corrida del proceso
  --    Autor: Gregorio Herrera.
  --    Fecha: 05/06/2009
  -- --------------------------------------------------------------------------------------------------
  procedure enviar_email is
    mensaje clob;
    conteo  integer := 0;
    PROCEDURE ADD(TEXTO IN VARCHAR2) AS
    BEGIN
      dbms_lob.writeAppend(mensaje, length(texto), texto);
    END;
  begin
    dbms_lob.createtemporary(mensaje, TRUE);
    dbms_lob.open(mensaje, dbms_lob.lob_readwrite);
    mensaje := ' ';

    if m_error.count() > 0 then
      mensaje := mensaje ||
                 '<html><head><title></title><STYLE TYPE="text/css"><!--.smallfont{font-size:xx-small; font-family:verdana}--></STYLE></head><body>' ||
                 '<table cellpadding="0" cellspacing="1" CLASS="smallfont"><tr><th bgcolor="silver">id error</th><th bgcolor="silver">Descripcion</th><th bgcolor="silver">cantidad</th></tr>';
      -- buscar los errores
      for r_index in m_error.FIRST .. m_error.LAST loop
        add('<tr><td align="center">' || m_error(r_index).id_error ||
            '</td>' || '<td align="left">' ||
            trim(m_error(r_index).error_des) || '</td>' ||
            '<td align="right">' ||
            trim(to_char(to_number(m_error(r_index).codigo_error_bd),
                         '99,999')) || '</td></tr>');
        conteo := conteo + to_number(m_error(r_index).codigo_error_bd);
      end loop;
      add('</table><br>');
      add('<span class="smallfont"><b>' || conteo ||
          ' registros.</b></span></body></html>');
    end if;

    system.html_mail(v_mail_from,
                     v_mail_to,
                     'Retroalimentacion novedades bajas pensionados',
                     mensaje);
    m_error.DELETE();
    dbms_lob.freetemporary(mensaje);
  exception
    when others then
      m_error.DELETE();
      dbms_lob.freetemporary(mensaje);
      system.html_mail(v_mail_from,
                       v_mail_to,
                       'Error en Retroalimentacion novedades bajas pensionados',
                       sqlerrm);
  end;

  --------------------------------------------------------------------------------------------------
  -- Milciades Hernandez
  -- 26/05/2009
  -- GetArchivosPage
  --------------------------------------------------------------------------------------------------
  PROCEDURE GetArchivosPage(P_Tipo_Archivo in SEH_ARCHIVOS_T.TIPO%TYPE,
                            P_Fecha_Desde  in DATE,
                            P_Fecha_Hasta  in DATE,
                            P_IdARS        in SEH_ARCHIVOS_T.ID_ARS%TYPE,
                            p_pagenum      in number,
                            p_pagesize     in number,
                            p_resultnumber OUT varchar2,
                            p_io_cursor    in OUT t_cursor) IS
    v_cursor t_cursor;
    vDesde   integer := (p_pagesize * (p_pagenum - 1)) + 1;
    vhasta   integer := p_pagesize * p_pagenum;
  BEGIN

    OPEN v_cursor FOR
      with x as
       (select rownum num, y.*
          from (SELECT ID_ARCHIVO,
                       TIPO,
                       NOMBRE,
                       FECHA_GENERACION,
                       PERIODO,
                       B.DESCRIPCION
                  FROM SEH_ARCHIVOS_T A
                  JOIN SRE_TIPO_ARCHIVOS_T B
                    ON B.id_tipo_archivo = A.tipo
                 WHERE A.TIPO =
                       decode(p_TIPO_ARCHIVO, null, A.TIPO, p_TIPO_ARCHIVO)
                   and id_ARS = P_IdARS
                   and trunc(FECHA_GENERACION) between
                       decode(p_fecha_desde,
                              null,
                              trunc(FECHA_GENERACION),
                              p_fecha_desde) and
                       decode(P_Fecha_Hasta,
                              null,
                              trunc(FECHA_GENERACION),
                              P_Fecha_Hasta)

                ) y)
      select y.recordcount, x.*
        from x, (select max(num) recordcount from x) y
       where num between (vDesde) and (vHasta)
       order by num;

    p_io_cursor    := v_cursor;
    p_resultnumber := 0;

  EXCEPTION
    WHEN OTHERS THEN
      v_bderror      := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultnumber := Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
      RETURN;

  END GetArchivosPage;

  --------------------------------------------------------------------------------------------------
  -- Milciades Hernandez
  -- 26/05/2009
  -- GETARCHIVO
  --------------------------------------------------------------------------------------------------
  PROCEDURE GETARCHIVO(P_IDARCHIVO    in SEH_ARCHIVOS_T.ID_ARCHIVO%TYPE,
                       p_resultnumber OUT varchar2,
                       p_io_cursor    in OUT t_cursor) IS
    v_cursor t_cursor;

  BEGIN

    OPEN v_cursor FOR
      SELECT ARCHIVO FROM SEH_ARCHIVOS_T A WHERE ID_ARCHIVO = P_IDARCHIVO;

    p_io_cursor    := v_cursor;
    p_resultnumber := 0;

  EXCEPTION
    WHEN OTHERS THEN
      v_bderror      := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultnumber := Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
      RETURN;

  END GETARCHIVO;

  -----------------------------------------------------------------------------------------
  -- Milciades Hernandez
  -- 26/05/2009
  -- GetInfoPensionado
  -----------------------------------------------------------------------------------------
  PROCEDURE GetInfoPensionado(P_CEDULA         IN SEH_PENSIONADOS_T.NO_DOCUMENTO%TYPE,
                              P_NRO_PENSIONADO IN SEH_PENSIONADOS_T.PENSIONADO%TYPE,
                              p_resultnumber   OUT varchar2,
                              p_io_cursor      in OUT t_cursor) IS
    v_cursor t_cursor;

  BEGIN

    OPEN v_cursor FOR
      With det_nov as
       (Select Max(id_novedad) id_novedad, id_pensionado
          From suirplus.seh_det_nov_t n
         Group by id_pensionado)
      Select P.PENSIONADO,
             P.INSTITUCION,
             P.NO_DOCUMENTO,
             NOMBRE,
             P.FECHA_NACIMIENTO,
             P.DIRECCION,
             P.TELEFONO,
             P.STATUS,
             p.FECHA_AFILIACION,
             p.FECHA_BAJA_SEH,
             p.FECHA_DESAFILIACION,
             p.FECHA_REGISTRO,
             decode(P.status,
                    'OK',
                    'ACTIVO',
                    'BA',
                    'BAJA',
                    'PE',
                    'PENDIENTE DE COMPLETAR DOC',
                    'AF',
                    'PENDIENTE DE SER AFILIADO',
                    'CA',
                    'CANCELADO') desc_status,
             P.ID_NSS,
             DOCUMENTACION,
             P.ID_ARS,
             C.ARS_DES,
             D.ID_MOTIVO_BAJA ||
             Decode(E.Error_Des, null, '', ' - ' || E.ERROR_DES) ID_MOTIVO_BAJA
        From SEH_pensionados_t p,
             ars_catalogo_t    c,
             SEH_DET_NOV_T     D,
             DET_NOV           N,
             SEG_ERROR_T       E
       where P.PENSIONADO =
             decode(P_NRO_PENSIONADO, null, P.pensionado, P_NRO_PENSIONADO)
         AND P.NO_DOCUMENTO =
             decode(P_CEDULA, null, P.no_documento, P_CEDULA)
         AND N.ID_PENSIONADO(+) = P.PENSIONADO
         AND D.ID_NOVEDAD(+) = N.ID_NOVEDAD
         AND D.ID_PENSIONADO(+) = N.ID_PENSIONADO
         AND C.ID_ARS(+) = P.ID_ARS
         AND E.ID_ERROR(+) = D.ID_MOTIVO_BAJA;

    p_io_cursor    := v_cursor;
    p_resultnumber := 0;

  EXCEPTION
    WHEN OTHERS THEN
      v_bderror      := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultnumber := Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
      RETURN;
  END GetInfoPensionado;

  -----------------------------------------------------------------------------------------
  -- Milciades Hernandez
  -- 26/05/2009
  -- getDocumentoInvalido
  -----------------------------------------------------------------------------------------
  PROCEDURE getDocumentoInvalido(P_Fecha_Desde  in DATE,
                                 P_Fecha_Hasta  in DATE,
                                 p_idars        IN SEH_NOV_T.ID_ARS%TYPE,
                                 p_pagenum      in number,
                                 p_pagesize     in number,
                                 p_resultnumber OUT varchar2,
                                 p_io_cursor    in OUT t_cursor) IS
    v_cursor t_cursor;
    vDesde   integer := (p_pagesize * (p_pagenum - 1)) + 1;
    vhasta   integer := p_pagesize * p_pagenum;

  BEGIN

    OPEN v_cursor FOR
      with x as
       (select rownum num, y.*
          from (SELECT a.id,
                       a.id_ars,
                       a.nombre,
                       a.codigo_error,
                       e.error_des,
                       a.fecha_registro
                  FROM SEH_DOC_INVALIDOS_T A, SEG_ERROR_T E
                 WHERE a.id_ars = p_idars
                   and e.id_error = ltrim(rtrim(a.codigo_error))
                   and trunc(a.fecha_registro) between
                       decode(p_fecha_desde,
                              null,
                              trunc(a.fecha_registro),
                              p_fecha_desde) and
                       decode(P_Fecha_Hasta,
                              null,
                              trunc(a.fecha_registro),
                              P_Fecha_Hasta)

                ) y)
      select y.recordcount, x.*
        from x, (select max(num) recordcount from x) y
       where num between (vDesde) and (vHasta)
       order by num;

    p_io_cursor    := v_cursor;
    p_resultnumber := 0;

  EXCEPTION
    WHEN OTHERS THEN
      v_bderror      := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultnumber := Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
      RETURN;

  END getDocumentoInvalido;

  -------------------------------------------------------------------------------------------------------------
  -- Milciades Hernandez
  -- 27/05/09
  -- getAfiliacionesPendiente
  -------------------------------------------------------------------------------------------------------------
  PROCEDURE getAfiliacionesPendiente(p_idars        IN SEH_NOV_T.ID_ARS%TYPE,
                                     p_pagenum      in number,
                                     p_pagesize     in number,
                                     p_resultnumber OUT varchar2,
                                     p_io_cursor    in OUT t_cursor) IS
    v_cursor t_cursor;
    vDesde   integer := (p_pagesize * (p_pagenum - 1)) + 1;
    vhasta   integer := p_pagesize * p_pagenum;

  BEGIN

    OPEN v_cursor FOR
      with x as
       (select rownum num, y.*
          from (select p.pensionado as id_pensionado,
                       P.NOMBRE,
                       p.id_ars,
                       a.ars_des
                  from SEH_PENSIONADOS_T P, ARS_CATALOGO_T A
                 where p.id_ars = a.id_ars
                   and p.status = 'PE'
                   and p.id_ars = p_idars) y)
      select y.recordcount, x.*
        from x, (select max(num) recordcount from x) y
       where num between (vDesde) and (vHasta)
       order by num;

    p_io_cursor    := v_cursor;
    p_resultnumber := 0;

  EXCEPTION
    WHEN OTHERS THEN
      v_bderror      := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultnumber := Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
      RETURN;

  END getAfiliacionesPendiente;

  -------------------------------------------------------------------------------------------------------------
  -- Milciades Hernandez
  -- 27/05/09
  -- AgregarDocInvalidados
  -- Inserta los registros de los Documentos Invalidos
  -------------------------------------------------------------------------------------------------------------
  procedure AgregarDocInvalidados(p_ID_ARS       SEH_DOC_INVALIDOS_T.ID_ARS%type,
                                  p_NOMBRE       SEH_DOC_INVALIDOS_T.Nombre%type,
                                  p_CODIGO_ERROR SEH_DOC_INVALIDOS_T.Codigo_Error%type,
                                  p_resultnumber OUT varchar2) is
    V_SEC_ID NUMBER;
  begin
    SELECT IDARSS_SEQ.NEXTVAL INTO V_SEC_ID FROM DUAL;

    insert into SEH_DOC_INVALIDOS_T
    values
      (V_SEC_ID, p_ID_ARS, p_NOMBRE, p_CODIGO_ERROR, SYSDATE);

    commit;
    p_resultnumber := 0;

  EXCEPTION

    WHEN OTHERS THEN
      v_bderror      := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultnumber := Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
      RETURN;

  end AgregarDocInvalidados;

  -------------------------------------------------------------------------------------------------------------
  -- AUTOR: YACELL BORGES
  -- FECHA: 15/5/2015
  -- NOMBRE: AgregarDocValidados
  -- OBJETIVO: Inserta informacion sobre las imagenes validadas de pensionados
  -------------------------------------------------------------------------------------------------------------
  procedure AgregarDocValidados  (p_ID_ARS        SEH_DOC_VALIDOS_T.ID_ARS%type,
                                  p_NOMBRE_IMAGEN SEH_DOC_VALIDOS_T.NOMBRE_IMAGEN%type,
                                  p_resultnumber  OUT varchar2) is
    V_SEC_ID NUMBER;
  begin
    SELECT ID_DOCVAL_SEQ.NEXTVAL INTO V_SEC_ID FROM DUAL;

    insert into SEH_DOC_VALIDOS_T
    values
      (V_SEC_ID, p_ID_ARS, p_NOMBRE_IMAGEN,SYSDATE);

    commit;
    p_resultnumber := 0;

  EXCEPTION

    WHEN OTHERS THEN
      v_bderror      := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultnumber := Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
      RETURN;

  end AgregarDocValidados;

  ---------------------------------------------------------------------------------------------------------------
  -- Milciades Hernandez
  --27/05/2009
  -- validarPensionado
  -----------------------------------------------------------------------------------------------------------------
  procedure validarPensionado(p_idars         in seh_pensionados_t.id_ars%type,
                              p_nropensionado in seh_pensionados_t.pensionado%type,
                              p_resultnumber  OUT varchar2) is

    v_idars         number;
    v_nropensionado number;
    v_status        varchar2(2);

    e_idarserror    exception;
    e_nropensionado exception;
    e_statuserror   exception;

  BEGIN

    select ID_ARS, PENSIONADO, status
      into v_idars, v_nropensionado, v_status
      from seh_pensionados_t p
     where PENSIONADO = p_nropensionado;

    if (v_idars is null) then
      raise e_idarserror;
    elsif (v_idars <> p_idars) then
      raise e_idarserror;
    end if;

    if v_status not in ('PE', 'OK') then
      raise e_statuserror;
    end if;

    p_resultnumber := 0;

  EXCEPTION

    WHEN e_idarserror THEN
      p_resultnumber := Seg_Retornar_Cadena_Error('P07', NULL, NULL);
      RETURN;

    WHEN e_nropensionado THEN
      p_resultnumber := Seg_Retornar_Cadena_Error('P02', NULL, NULL);
      RETURN;

    WHEN e_statuserror THEN
      p_resultnumber := '00';
      RETURN;

    WHEN NO_DATA_FOUND THEN
      p_resultnumber := Seg_Retornar_Cadena_Error('P02', NULL, NULL);
      RETURN;

    WHEN OTHERS THEN
      v_bderror      := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultnumber := Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
      RETURN;

  end validarPensionado;

  ------------------------------------------------------------------------------------
  -- 02/06/2009
  -- Milciades Hernandez
  -- MarcarStatusPens
  -- ---------------------------------------------------------------------------------
  procedure MarcarStatusPens(p_nropensionado in SEH_PENSIONADOS_T.Pensionado%type,
                             p_imagen        in seh_pensionados_t.documentacion%type,
                             p_resultnumber  OUT varchar2) is
  begin
    update SEH_PENSIONADOS_T
       set status           = 'OK',
           documentacion    = p_imagen,
           fecha_afiliacion = decode(status, 'PE', sysdate, fecha_afiliacion)
     where PENSIONADO = p_nropensionado;
    p_resultnumber := 0;
    commit;

  EXCEPTION

    WHEN OTHERS THEN
      v_bderror      := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultnumber := Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);

  end MarcarStatusPens;

  ------------------------------------------------------------------------------------
  -- 02/06/2009
  -- Milciades Hernandez
  -- getpensionado
  -- ---------------------------------------------------------------------------------
  procedure getpensionado(p_no_documento   IN seh_pensionados_t.no_documento%type,
                          p_nro_pensionado IN seh_pensionados_t.pensionado%type,
                          p_resultnumber   OUT varchar2,
                          p_io_cursor      IN OUT t_cursor) IS
    v_cursor t_cursor;
  begin
    OPEN v_cursor FOR
      select c.nombres || ' ' || rtrim(ltrim(c.primer_apellido)) || ' ' ||
             rtrim(ltrim(c.segundo_apellido)) nombre_ciu,
             p.nombre,
             p.no_documento,
             c.fecha_nacimiento fecha_nac_ciu,
             p.fecha_nacimiento,
             p.direccion,
             p.telefono,
             p.pensionado,
             p.id_ars,
             c.status,
             p.institucion,
             p.fecha_afiliacion,
             p.fecha_baja_seh,
             p.fecha_desafiliacion,
             p.fecha_registro,
             p.status,
             p.documentacion,
             ar.ars_des,
             decode(P.status,
                    'OK',
                    'ACTIVO',
                    'BA',
                    'BAJA',
                    'PE',
                    'PENDIENTE DE COMPLETAR DOC',
                    'AF',
                    'PENDIENTE DE SER AFILIADO',
                    'CA',
                    'CANCELADO') desc_status
        from seh_pensionados_t p, sre_ciudadanos_t c, ars_catalogo_t ar
       where p.no_documento = c.no_documento(+)
         and ar.id_ars = p.id_ars
         and c.no_documento =
             decode(p_no_documento, null, p.no_documento, p_no_documento)
         and p.pensionado =
             decode(p_nro_pensionado, null, p.pensionado, p_nro_pensionado);

    p_io_cursor    := v_cursor;
    p_resultnumber := 0;

  EXCEPTION

    WHEN OTHERS THEN
      v_bderror      := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultnumber := Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
      RETURN;

  END getpensionado;

  -- --------------------------------------------------------------------------------------------------
  -- Objetivo: devuelve recordset con los archivos cargados de acuerdo a los parametros indicados
  --    Autor: Gregorio Herrera.
  --    Fecha: 05/06/2009
  -- --------------------------------------------------------------------------------------------------
  procedure get_Info_Archivo(p_id_recepcion  sre_archivos_t.id_recepcion%type,
                             p_fecha_desde   sre_archivos_t.fecha_carga%type,
                             p_fecha_hasta   sre_archivos_t.fecha_carga%type,
                             p_idars         IN SEH_NOV_T.ID_ARS%TYPE,
                             p_result_number out varchar,
                             io_cursor       out t_cursor) is
  begin
    open io_cursor for
      select a.id_recepcion,
             t.tipo_movimiento_des,
             t.id_tipo_movimiento,
             decode(a.status,
                    'N',
                    'No Procesado',
                    'P',
                    'Procesado',
                    'S',
                    'Sometido',
                    'R',
                    'Rechazado',
                    'E',
                    'En proceso') status,
             e.error_des error_des,
             a.ult_fecha_act fecha_carga,
             a.registros_ok,
             a.registros_bad,
             (a.registros_ok + a.registros_bad) Total_Registros,
             seg_usuarios_pkg.getNombreUsuario(a.usuario_carga) Usuario_Carga
        from sre_archivos_t a, sre_tipo_movimiento_t t, seg_error_t e
       where a.id_recepcion =
             decode(p_id_recepcion, null, a.id_recepcion, p_id_recepcion)
         and a.id_entidad_recaudadora = p_idars
         and trunc(a.ult_fecha_act) between
             decode(p_fecha_desde,
                    null,
                    trunc(a.ult_fecha_act),
                    p_fecha_desde) and
             decode(p_fecha_hasta,
                    null,
                    trunc(a.ult_fecha_act),
                    p_fecha_hasta)
         and t.id_tipo_movimiento(+) = a.id_tipo_movimiento
         and e.id_error(+) = a.id_error;

    p_result_number := Seg_Retornar_Cadena_Error(0, null, null);
    return;
  end get_Info_Archivo;

  -- --------------------------------------------------------------------------------------------------
  -- Objetivo: devuelve recordset con los archivos cargados de acuerdo a los parametros indicados
  --    Autor: Gregorio Herrera.
  --    Fecha: 05/06/2009
  -- --------------------------------------------------------------------------------------------------
  procedure getPage_Detalle_Archivo(p_id_recepcion sre_archivos_t.id_recepcion%type,
                                    p_pagenum      in number,
                                    p_pagesize     in number,
                                    io_cursor      out t_cursor) is
    vDesde integer := (p_pagesize * (p_pagenum - 1)) + 1;
    vHasta integer := p_pagesize * p_pagenum;
  begin
    open io_cursor for
      with x as
       (select rownum num, y.*
          from (select m.id_pensionado,
                       m.id_error,
                       decode(m.id_error,'PY1',m.observacion,e.error_des)error_des,
                       trim(m.nombres) || ' ' || trim(m.primer_apellido) ||
                       case nvl(trim(m.segundo_apellido), ' ')
                         when ' ' then
                          ''
                         else
                          ' ' || trim(m.segundo_apellido)
                       end nombre
                  from seh_det_nov_tmp_t m, seg_error_t e
                 where m.id_recepcion = p_id_recepcion
                   and m.id_error <> '0'
                   and m.id_error <> '000'
                   and e.id_error(+) = m.id_error) y)
      select y.recordcount, x.*
        from x, (select max(num) recordcount from x) y
       where num between vDesde and vHasta
       order by num;
    return;
  end getPage_Detalle_Archivo;

  ------------------------------------------------------------------------------------
  -- 02/06/2009
  -- Milciades Hernandez
  -- getnovedadespensionado
  -- ---------------------------------------------------------------------------------
  procedure getnovedadespensionado(p_nro_pensionado IN seh_det_nov_t.id_pensionado%type,
                                   p_resultnumber   OUT varchar2,
                                   p_io_cursor      IN OUT t_cursor)

   IS
    v_cursor t_cursor;

  begin
    open v_cursor for
      select n.id_ars,
             d.id_novedad,
             d.estatus,
             n.fecha_carga,
             ar.ars_des,
             D.ID_MOTIVO_BAJA ||
             Decode(E.Error_Des, null, '', ' - ' || E.ERROR_DES) ID_MOTIVO_BAJA,
             Case d.tipo_novedad
               When 'A' Then
                'Alta'
               When 'B' Then
                'Baja'
               Else
                'Indefinido'
             End TIPO_NOVEDAD
        from seh_det_nov_t d, seh_nov_t n, ars_catalogo_t ar, seg_error_t e
       where n.id_novedad = d.id_novedad
         and d.id_pensionado = decode(p_nro_pensionado,
                                      null,
                                      d.id_pensionado,
                                      p_nro_pensionado)
         and ar.id_ars(+) = n.id_ars
         and e.id_error(+) = d.id_motivo_baja;

    p_io_cursor    := v_cursor;
    p_resultnumber := 0;

  EXCEPTION

    WHEN OTHERS THEN
      v_bderror      := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultnumber := Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
      RETURN;

  end getnovedadespensionado;

  ----------------------------------------------------------------------------------------
  -- Autor   : Gregorio Herrera
  -- Fecha   : 03/06/2009
  -- Objetivo: Generar el contenido del archivo de notificacion de afiliacion para las ARS
  -- -------------------------------------------------------------------------------------
  procedure generar_notificacion_alta(p_fecha in date default sysdate) is
    v_id_archivo     number(10);
    v_mensaje        blob;
    v_conteo         number(10);
    v_archivos       number(10) := 0;
    v_registros      number(10) := 0;
    v_periodo        varchar2(6);
    v_total_archivos varchar2(100);
    procedure ADD(texto in varchar2) as
    begin
      dbms_lob.writeAppend(v_mensaje,
                           length(texto),
                           UTL_RAW.CAST_TO_RAW(texto));
    end;
  begin
    -- Insetamos el registro en la bitacora
    BITACORA(m_id_bitacora, 'INI', '58');

    --Para saber a cual periodo cargar las novedades
    if to_number(to_char(trunc(p_fecha) - 1, 'DD')) <= 10 then
      v_periodo := to_char(p_fecha, 'YYYYMM');
    else
      v_periodo := to_char(add_months(trunc(p_fecha) - 1, 1), 'YYYYMM');
    end if;

    --Data agrupada por ARS y Fecha
    for c_main in (select id_ars, trunc(fecha_afiliacion) fecha
                     from suirplus.seh_pensionados_t
                    where status = 'OK'
                      and trunc(fecha_afiliacion) = trunc(p_fecha - 1)
                    group by id_ars, trunc(fecha_afiliacion)) loop
      dbms_lob.createtemporary(v_mensaje, TRUE);
      dbms_lob.open(v_mensaje, dbms_lob.lob_readwrite);

      v_conteo   := 0;
      v_archivos := v_archivos + 1;

      --Formamos el registro del encabezado del archivo
      add('EPA' || LPAD(c_main.id_ars, 2, '0') ||
          to_char(c_main.fecha, 'YYYYMMDD') || v_periodo || chr(13) ||
          chr(10));

      --Data para una ARS
      for c_pen in (select pensionado, id_nss
                      from suirplus.seh_pensionados_t
                     where id_ars = c_main.id_ars
                       and status = 'OK'
                       and trunc(fecha_afiliacion) = c_main.fecha
                     order by id_ars, pensionado) loop
        --Formamos los registros detalle del archivo
        add('D' || LPAD(c_pen.pensionado, 10, '0') ||
            LPAD(nvl(c_pen.id_nss, 0), 10, '0') || chr(13) || chr(10));
        v_conteo    := v_conteo + 1;
        v_registros := v_registros + 1;
      end loop;

      -- formamos el registro del sumario del archivo
      add('S' || LPAD(v_conteo + 2, 6, '0'));

      --procedemos a actualizar o a crear el registro en la tabla SEH_ARCHIVOS_T
      if (v_conteo > 0) then
        select count(*)
        into v_conteo
        from suirplus.seh_archivos_t a
        where id_ars  = c_main.id_ars
          and tipo    = 'PA'
          and periodo = v_periodo
          and trunc(fecha_generacion) = trunc(sysdate);

        if v_conteo > 0 then
          update suirplus.seh_archivos_t a
             set a.nombre           = 'PA_' || to_char(c_main.fecha, 'YYYYMMDD') || '.TXT',
                 a.fecha_generacion = sysdate,
                 a.periodo          = v_periodo,
                 a.archivo          = v_mensaje
          where id_ars = c_main.id_ars
            and tipo = 'PA'
            and trunc(fecha_generacion) = trunc(sysdate);
        else
          --creamos el registro
          select nvl(max(id_archivo), 0) + 1
            into v_id_archivo
            from suirplus.seh_archivos_t;

          insert into suirplus.seh_archivos_t
            (id_archivo,
             tipo,
             id_ars,
             nombre,
             fecha_generacion,
             periodo,
             archivo)
          values
            (v_id_archivo,
             'PA',
             c_main.id_ars,
             'PA_' || to_char(c_main.fecha, 'YYYYMMDD') || '.TXT',
             sysdate,
             v_periodo,
             v_mensaje);

          if (v_total_archivos is null) then
            v_total_archivos := v_id_archivo;
          else
            v_total_archivos := v_total_archivos || ', ' || v_id_archivo;
          end if;
        end if;
        commit;
      end if;

      dbms_lob.close(v_mensaje);
      dbms_lob.freetemporary(v_mensaje);
    end loop;

    -- Si llegó hasta aqui, no hubo errores de excepciones
    BITACORA(m_id_bitacora,
             'FIN',
             '58',
             'OK. archivos nro=' || v_total_archivos,
             'O',
             '000');
  Exception
    when others then
      --Lista de correos a enviar el mensaje
      BEGIN
        SELECT p.lista_error
          INTO v_mail_to
          FROM suirplus.sfc_procesos_t p
         WHERE p.id_proceso = '58';
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          v_mail_to := v_mail_error;
      END;
      dbms_lob.close(v_mensaje);
      dbms_lob.freetemporary(v_mensaje);
      BITACORA(m_id_bitacora,
               'FIN',
               '58',
               substr(sqlerrm, 1, 255),
               'E',
               '650');
      system.html_mail(v_mail_from,
                       v_mail_to,
                       'ERROR Generando Notificación Novedades Afiliación SEH',
                       'Error en la generación notificación novedades afiliación SEH, nro. archivo=' ||
                       v_id_archivo || '<br>Error=' || sqlerrm);
  End;

  -------------------------------------------------------------------------------------------
  -- Autor   : Gregorio Herrera
  -- Fecha   : 04/06/2009
  -- Objetivo: Generar el contenido del archivo de notificacion de afiliacion para la ARS SEH
  -- ----------------------------------------------------------------------------------------
  procedure generar_notificacion_alta_SEH(p_fecha in date default sysdate) is
    v_id_archivo number(10);
    v_mensaje    blob;
    v_registros  number(10) := 0;
    v_periodo    varchar2(6);
    procedure ADD(texto in varchar2) as
    begin
      dbms_lob.writeAppend(v_mensaje,
                           length(texto),
                           UTL_RAW.CAST_TO_RAW(texto));
    end;
  begin
    -- Insetamos el registro en la bitacora
    BITACORA(m_id_bitacora, 'INI', '58');

    dbms_lob.createtemporary(v_mensaje, TRUE);
    dbms_lob.open(v_mensaje, dbms_lob.lob_readwrite);

    --Para saber a cual periodo cargar las novedades
    if to_number(to_char(trunc(p_fecha) - 1, 'DD')) <= 10 then
      v_periodo := to_char(p_fecha, 'YYYYMM');
    else
      v_periodo := to_char(add_months(trunc(p_fecha) - 1, 1), 'YYYYMM');
    end if;

    --Formamos el registro del encabezado del archivo
    add('EPA' || to_char(trunc(p_fecha) - 1, 'YYYYMMDD') || v_periodo ||
        chr(13) || chr(10));

    --Data para las ARS
    for c_pen in (select id_ars, pensionado, id_nss
                    from suirplus.seh_pensionados_t
                   where status = 'OK'
                     and trunc(fecha_afiliacion) = trunc(p_fecha - 1)
                   order by id_ars, pensionado) loop
      --Formamos los registros detalle del archivo
      add('D' || LPAD(c_pen.id_ars, 2, '0') ||
          LPAD(c_pen.pensionado, 10, '0') ||
          LPAD(nvl(c_pen.id_nss, 0), 10, '0') || chr(13) || chr(10));
      v_registros := v_registros + 1;
    end loop;

    -- formamos el registro del sumario del archivo
    add('S' || LPAD(v_registros + 2, 6, '0'));

    --procedemos a actualizar o a crear el registro en la tabla SEH_ARCHIVOS_T
    if (v_registros > 0) then
      select count(*)
      into v_registros
      from suirplus.seh_archivos_t a
      where id_ars  = 98 --ID ARS de SEH
        and tipo    = 'PA'
        and periodo = v_periodo
        and trunc(fecha_generacion) = trunc(sysdate);

      if v_registros > 0 then
        update suirplus.seh_archivos_t a
           set a.nombre           = 'PA_' || to_char(trunc(p_fecha) - 1, 'YYYYMMDD') || '.TXT',
               a.fecha_generacion = sysdate,
               a.periodo          = v_periodo,
               a.archivo          = v_mensaje
         where id_ars = 98 --ID ARS de SEH
           and tipo = 'PA'
           and trunc(fecha_generacion) = trunc(sysdate);
      else
        --creamos el registro
        select nvl(max(id_archivo), 0) + 1
          into v_id_archivo
          from suirplus.seh_archivos_t;

        insert into suirplus.seh_archivos_t
          (id_archivo,
           tipo,
           id_ars,
           nombre,
           fecha_generacion,
           periodo,
           archivo)
        values
          (v_id_archivo,
           'PA',
           98,
           'PA_' || to_char(trunc(p_fecha) - 1, 'YYYYMMDD') || '.TXT',
           sysdate,
           v_periodo,
           v_mensaje);
      end if;
      commit;
    end if;

    dbms_lob.close(v_mensaje);
    dbms_lob.freetemporary(v_mensaje);

    -- Si llegó hasta aqui, no hubo errores de excepciones
    BITACORA(m_id_bitacora,
             'FIN',
             '58',
             'OK. archivo nro=' || v_id_archivo,
             'O',
             '000');
  Exception
    when others then
      dbms_lob.close(v_mensaje);
      dbms_lob.freetemporary(v_mensaje);

      --Lista de correos a enviar el mensaje
      BEGIN
        SELECT p.lista_error
          INTO v_mail_to
          FROM suirplus.sfc_procesos_t p
         WHERE p.id_proceso = '58';
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          v_mail_to := v_mail_error;
      END;

      BITACORA(m_id_bitacora,
               'FIN',
               '58',
               substr(sqlerrm, 1, 255),
               'E',
               '650');
      system.html_mail(v_mail_from,
                       v_mail_to,
                       'ERROR Generando Notificación Novedades Afiliación SEH',
                       'Error en la generación notificación novedades afiliación consolidado SEH, nro. archivo=' ||
                       v_id_archivo || '<br>Error=' || sqlerrm);
  End;

  ----------------------------------------------------------------------------------
  -- Autor   : Gregorio Herrera
  -- Fecha   : 04/06/2009
  -- Objetivo: Generar el contenido del archivo de notificacion de baja para las ARS
  -- -------------------------------------------------------------------------------
  procedure generar_notificacion_baja(p_fecha in date default sysdate) is
    v_id_archivo     number(10);
    v_mensaje        blob;
    v_conteo         number(10);
    v_archivos       number(10) := 0;
    v_registros      number(10) := 0;
    v_periodo        varchar2(6);
    v_total_archivos varchar2(100);
    v_id_motivo_baja suirplus.seh_det_nov_t.id_motivo_baja%type;
    procedure ADD(texto in varchar2) as
    begin
      dbms_lob.writeAppend(v_mensaje,
                           length(texto),
                           UTL_RAW.CAST_TO_RAW(texto));
    end;
  begin
    -- Insetamos el registro en la bitacora
    BITACORA(m_id_bitacora, 'INI', '59');

    --Para saber a cual periodo cargar las novedades
    if to_number(to_char(trunc(p_fecha) - 1, 'DD')) <= 10 then
      v_periodo := to_char(p_fecha, 'YYYYMM');
    else
      v_periodo := to_char(add_months(trunc(p_fecha) - 1, 1), 'YYYYMM');
    end if;

    --Data agrupada por ARS y Fecha
    --Necesario genera desde aqui y no desde la maestra de pensionado
    --ya que los traspaso sobreescriben la ARS en la que se dio la baja
    --la única manera de conseguir la ARS de baja en estos casos es yendo
    --al detalle de la novedad
    for c_main in (select id_ars, trunc(fecha_carga) fecha
                     from suirplus.seh_nov_t h
                    where trunc(fecha_carga) = trunc(p_fecha - 1)
                      and exists (select 1
                             from suirplus.seh_det_nov_t d
                            where d.id_novedad = h.id_novedad
                              and d.tipo_novedad = 'B')
                    group by id_ars, trunc(fecha_carga)) loop
      dbms_lob.createtemporary(v_mensaje, TRUE);
      dbms_lob.open(v_mensaje, dbms_lob.lob_readwrite);

      v_conteo   := 0;
      v_archivos := v_archivos + 1;

      --Formamos el registro del encabezado del archivo
      add('EPB' || LPAD(c_main.id_ars, 2, '0') ||
          to_char(c_main.fecha, 'YYYYMMDD') || v_periodo || chr(13) ||
          chr(10));

      --Data para una ARS
      for c_pen in (select distinct d.id_pensionado, p.id_nss
                      from suirplus.seh_nov_t h
                      join suirplus.seh_det_nov_t d
                        on d.id_novedad = h.id_novedad
                       and d.tipo_novedad = 'B'
                      join suirplus.seh_pensionados_t p
                        on p.pensionado = d.id_pensionado
                     where h.id_ars = c_main.id_ars
                       and trunc(h.fecha_carga) = c_main.fecha
                     order by d.id_pensionado, p.id_nss) loop
        --Para buscar el último motivo de baja
        Begin
          Select id_motivo_baja
            Into v_id_motivo_baja
            From suirplus.seh_det_nov_t
           Where id_novedad = (select max(id_novedad)
                                 from suirplus.seh_det_nov_t m
                                where m.id_pensionado = c_pen.id_pensionado
                                  and m.tipo_novedad = 'B')
             and id_pensionado = c_pen.id_pensionado
             and tipo_novedad = 'B';

          --Formamos los registros detalle del archivo
          add('D' || LPAD(c_pen.id_pensionado, 10, '0') ||
              LPAD(nvl(c_pen.id_nss, 0), 10, '0') ||
              RPAD(v_id_motivo_baja, 3, ' ') || chr(13) || chr(10));
          v_conteo    := v_conteo + 1;
          v_registros := v_registros + 1;
        Exception
          When Others Then
            v_id_motivo_baja := Null;
        End;
      end loop;

      -- formamos el registro del sumario del archivo
      add('S' || LPAD(v_conteo + 2, 6, '0'));

      --procedemos a actualizar o a crear el registro en la tabla SEH_ARCHIVOS_T
      if (v_conteo > 0) then
        select count(*)
        into v_conteo
        from suirplus.seh_archivos_t a
        where id_ars  = c_main.id_ars
          and tipo    = 'PB'
          and periodo = v_periodo
          and trunc(fecha_generacion) = trunc(sysdate);

        if v_conteo > 0 then
          update suirplus.seh_archivos_t a
             set a.nombre           = 'PB_' || to_char(c_main.fecha, 'YYYYMMDD') || '.TXT',
                 a.fecha_generacion = sysdate,
                 a.periodo          = v_periodo,
                 a.archivo          = v_mensaje
           where id_ars = c_main.id_ars
             and tipo = 'PB'
             and trunc(fecha_generacion) = trunc(sysdate);
        else
          --creamos el registro
          select nvl(max(id_archivo), 0) + 1
            into v_id_archivo
            from suirplus.seh_archivos_t;

          insert into suirplus.seh_archivos_t
            (id_archivo,
             tipo,
             id_ars,
             nombre,
             fecha_generacion,
             periodo,
             archivo)
          values
            (v_id_archivo,
             'PB',
             c_main.id_ars,
             'PB_' || to_char(c_main.fecha, 'YYYYMMDD') || '.TXT',
             sysdate,
             v_periodo,
             v_mensaje);

          if (v_total_archivos is null) then
            v_total_archivos := v_id_archivo;
          else
            v_total_archivos := v_total_archivos || ', ' || v_id_archivo;
          end if;
        end if;
        commit;
      end if;

      dbms_lob.close(v_mensaje);
      dbms_lob.freetemporary(v_mensaje);
    end loop;

    -- Si llegó hasta aqui, no hubo errores de excepciones
    BITACORA(m_id_bitacora,
             'FIN',
             '59',
             'OK. archivos nro=' || v_total_archivos,
             'O',
             '000');
  Exception
    when others then
      dbms_lob.close(v_mensaje);
      dbms_lob.freetemporary(v_mensaje);

      --Lista de correos a enviar el mensaje
      BEGIN
        SELECT p.lista_error
          INTO v_mail_to
          FROM suirplus.sfc_procesos_t p
         WHERE p.id_proceso = '59';
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          v_mail_to := v_mail_error;
      END;

      BITACORA(m_id_bitacora,
               'FIN',
               '59',
               substr(sqlerrm, 1, 255),
               'E',
               '650');
      system.html_mail(v_mail_from,
                       v_mail_to,
                       'ERROR Generando Notificación de Bajas SEH',
                       'Error en la generación notificación de bajas SEH, nro. archivo=' ||
                       v_id_archivo || '<br>Error=' || sqlerrm);
  End;

  -------------------------------------------------------------------------------------
  -- Autor   : Gregorio Herrera
  -- Fecha   : 04/06/2009
  -- Objetivo: Generar el contenido del archivo de notificacion de baja para la ARS SEH
  -- ----------------------------------------------------------------------------------
  procedure generar_notificacion_baja_SEH(p_fecha in date default sysdate) is
    v_id_archivo number(10);
    v_mensaje    blob;
    v_registros  number(10) := 0;
    v_motivo     suirplus.seh_det_nov_t.id_motivo_baja%type;
    procedure ADD(texto in varchar2) as
    begin
      dbms_lob.writeAppend(v_mensaje,
                           length(texto),
                           UTL_RAW.CAST_TO_RAW(texto));
    end;
  begin
    -- Insetamos el registro en la bitacora
    BITACORA(m_id_bitacora, 'INI', '59');

    dbms_lob.createtemporary(v_mensaje, TRUE);
    dbms_lob.open(v_mensaje, dbms_lob.lob_readwrite);

    --Formamos el registro del encabezado del archivo
    add('E 401514682' ||
        RPAD('CONSEJO NACIONAL DE SEGURIDAD SOCIAL', 50, ' ') ||
        to_char(p_fecha, 'YYYYMMDD') || RPAD('Seguro Salud', 250, ' ') ||
        chr(13) || chr(10));

    --Data restando la cartera anterior menos la cartera actual
    for c_pen in (select p.no_documento, p.nombre, p.pension, c.pensionado
                    from suirplus.seh_cartera_t c
                    join suirplus.seh_pensionados_t p
                      on p.pensionado = c.pensionado
                    join suirplus.seh_det_nov_t n --de todas las bajas para este pencionado, tomar la mas reciente
                      on n.id_novedad =
                         (select max(id_novedad)
                            from suirplus.seh_det_nov_t m
                           where m.id_pensionado = c.pensionado
                             and m.tipo_novedad = 'B')
                     and n.id_pensionado = c.pensionado
                   where c.periodo_cartera =
                         to_char(add_months(p_fecha, -1), 'YYYYMM')
                  MINUS
                  select p.no_documento, p.nombre, p.pension, c.pensionado
                    from suirplus.seh_cartera_t c
                    join suirplus.seh_pensionados_t p
                      on p.pensionado = c.pensionado
                   where c.periodo_cartera = to_char(p_fecha, 'YYYYMM')
                   order by 4) loop
      --Para obtener el id del motivo de la baja, tomando la baja mas reciente del pensionado
      Begin
        select n.id_motivo_baja
          into v_motivo
          from suirplus.seh_det_nov_t n
         where n.id_novedad = (select max(id_novedad)
                                 from suirplus.seh_det_nov_t m
                                where m.id_pensionado = c_pen.pensionado
                                  and m.tipo_novedad = 'B')
           and n.id_pensionado = c_pen.pensionado;
      Exception
        when no_data_found then
          v_motivo := ' ';
      End;
      --Formamos los registros detalle del archivo
      add('D' || LPAD(c_pen.no_documento, 11, ' ') ||
          RPAD(c_pen.nombre, 50, ' ') || LPAD('0', 23, '0') ||
          to_char(p_fecha, 'YYYYMM') || '01' ||
          to_char(LAST_DAY(p_fecha), 'YYYYMMDD') ||
          LPAD(c_pen.pension, 8, '0') || RPAD(v_motivo, 3, ' ') || chr(13) ||
          chr(10));
      v_registros := v_registros + 1;
    end loop;

    -- formamos el registro del sumario del archivo
    add('T' || LPAD(v_registros, 5, '0') || LPAD('0', 15, '0') || '.0000');

    --procedemos a actualizar o a crear el registro en la tabla SEH_ARCHIVOS_T
    if (v_registros > 0) then
      select count(*)
      into v_registros
      from suirplus.seh_archivos_t a
      where id_ars  = 98 --ID ARS de SEH
        and tipo    = 'PB'
        and periodo = to_char(p_fecha, 'YYYYMM')
        and trunc(fecha_generacion) = trunc(sysdate);
      
      if v_registros > 0 then
        update suirplus.seh_archivos_t a
           set a.nombre           = 'PB_' || to_char(p_fecha, 'YYYYMMDD') || '.TXT',
               a.fecha_generacion = sysdate,
               a.periodo          = to_char(p_fecha, 'YYYYMM'),
               a.archivo          = v_mensaje
         where id_ars = 98 --ID ARS de SEH
           and tipo = 'PB'
           and trunc(fecha_generacion) = trunc(sysdate);
      else
        --creamos el registro
        select nvl(max(id_archivo), 0) + 1
          into v_id_archivo
          from suirplus.seh_archivos_t;

        insert into suirplus.seh_archivos_t
          (id_archivo,
           tipo,
           id_ars,
           nombre,
           fecha_generacion,
           periodo,
           archivo)
        values
          (v_id_archivo,
           'PB',
           98,
           'PB_' || to_char(p_fecha, 'YYYYMMDD') || '.TXT',
           sysdate,
           to_char(p_fecha, 'YYYYMM'),
           v_mensaje);
      end if;
      commit;
    end if;

    dbms_lob.close(v_mensaje);
    dbms_lob.freetemporary(v_mensaje);

    -- Si llegó hasta aqui, no hubo errores de excepciones
    BITACORA(m_id_bitacora,
             'FIN',
             '59',
             'OK. archivo nro=' || v_id_archivo,
             'O',
             '000');
  Exception
    when others then
      dbms_lob.close(v_mensaje);
      dbms_lob.freetemporary(v_mensaje);

      --Lista de correos a enviar el mensaje
      BEGIN
        SELECT p.lista_error
          INTO v_mail_to
          FROM suirplus.sfc_procesos_t p
         WHERE p.id_proceso = '59';
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          v_mail_to := v_mail_error;
      END;

      BITACORA(m_id_bitacora,
               'FIN',
               '59',
               substr(sqlerrm, 1, 255),
               'E',
               '650');
      system.html_mail(v_mail_from,
                       v_mail_to,
                       'ERROR Generando Notificación de Bajas consolidado SEH',
                       'Error en la generación notificación de bajas SEH, nro. archivo=' ||
                       v_id_archivo || '<br>Error=' || sqlerrm);
  End;

  -- --------------------------------------------------------------------------------------------------
  -- Objetivo: insertar un registro en las tablas suirplus.seh_nov_t y suirplus.seh_det_nov_t, basado en
  --           las validaciones realizadas
  --    Autor: Gregorio Herrera.
  --    Fecha: 05/06/2009
  -- --------------------------------------------------------------------------------------------------
  function getDescError ( p_id_error suirplus.seg_error_t.id_error%type) return varchar is
    v_descerror suirplus.seg_error_t.error_des%type;
  begin
    select s.error_des into v_descerror from seg_error_t s
    where s.id_error = p_id_error;

    return v_descerror;
  end;

  -- --------------------------------------------------------------------------------------------------
  -- Objetivo: insertar un registro en la tabla suirplus.seh_nov_t por ARS y uno o varios registros en la
  --           tabla suirplus.seh_det_nov_t con todos los pensionados de esa ARS,
  --           basado en las validaciones realizadas.
  --    Autor: Gregorio Herrera.
  --    Fecha: 05/06/2009
  -- --------------------------------------------------------------------------------------------------
  procedure generar_movimientos_baja(p_fecha in date default sysdate) is
    v_ErrorDetalle varchar2(3);
    v_Conteo       number(12);
    v_OK           number(12);
    v_Novedad      number(12);
    v_secuencia    number(12);
    v_dummy        varchar2(50);
  begin
    --Tomamos las distintas ARS con pensionados en ALTA
    For c_ars in (select distinct id_ars
                    from suirplus.seh_pensionados_t
                   where status = 'OK') loop
                  
      v_OK := 0;
                  
      --Trabajamos con los pensionados de una ARS en particular
      For c_pen in (select a.rowid id, a.*
                    from suirplus.seh_pensionados_t a
                   where a.id_ars = c_ars.id_ars
                     and a.status = 'OK'
                   order by a.pensionado) loop  
        v_ErrorDetalle := '0';

        if (c_pen.id_nss is not null) then
          -- Para buscar el NSS como trabajador y con un salario mayor de 5.00 pesos
          select count(*)
            into v_Conteo
            from suirplus.sre_trabajadores_t t
            join suirplus.sre_nominas_t n
              on n.id_registro_patronal = t.id_registro_patronal
             and n.id_nomina = t.id_nomina
             and n.tipo_nomina != 'P'
           where t.id_nss = c_pen.id_nss
             and t.status != 'B'
             and t.salario_ss > 5;

          if (v_conteo > 0) then
            v_ErrorDetalle := 'P01';
--          anotar_error(v_ErrorDetalle, getDescError(v_ErrorDetalle));
            goto insertar_baja;
          end if;

          --El NSS debe existir en el repositorio ciudadanos y con estatus válido
          --En dos bit trabajeremos las validaciones de la existencia del NSS y su estatus
          --Inicialmente: N=No existe y S=Está inactivo
          v_dummy := 'NS';
          for r in (select 1
                      from suirplus.sre_ciudadanos_t
                     where id_nss = c_pen.id_nss) loop
            --Existe el NSS y no está inactivo
            v_dummy := 'SN';
            --Solo considerar el tipo de causa: Ticket #6513
            if SUIRPLUS.SRE_CIUDADANO_INACTIVO_F(c_pen.id_nss) = 'N' then -- No se debe pagar la capita
              --Existe el NSS y está inactivo
              v_dummy := 'SS';
            end if;
          end loop;

          --Respondemos por posición, la primera posición evalua el NSS y la segunda posición evalua el estado del NSS
          if (substr(v_dummy, 1, 1) = 'N') then
            --Hasta ahora no tomamos ninguna acción por el momento si no existe el NSS
            null;
          elsif (substr(v_dummy, 2, 1) = 'S') then
            v_ErrorDetalle := 'P03';
--          anotar_error(v_ErrorDetalle, getDescError(v_ErrorDetalle));
            goto insertar_baja;
          end if;

          -- Para buscar el NSS en la dispersión del regimen contributivo en cualquiera de los dos ultimos períodos anteriores
          select count(*)
            into v_Conteo
            from dual
           where exists (select 1
                         from suirplus.ars_cartera_t
                         where periodo_factura_ars >=
                           to_char(add_months(p_fecha, -2), 'YYYYMM')
                           and nss_titular = c_pen.id_nss
                           and NVL(registro_dispersado, 'N') = 'S')
                or exists
               (select 1
                  from suirplus.ars_cartera_t
                 where periodo_factura_ars >=
                       to_char(add_months(p_fecha, -2), 'YYYYMM')
                   and nss_dependiente = c_pen.id_nss
                   and NVL(registro_dispersado, 'N') = 'S');
 
          if (v_conteo > 0) then
            v_ErrorDetalle := 'P04';
--          anotar_error(v_ErrorDetalle, getDescError(v_ErrorDetalle));
            goto insertar_baja;
          end if;
 
          -- Para buscar el NSS en una referencia de pago en el período anterior
          select count(*)
            into v_Conteo
            from suirplus.sfc_det_facturas_t
           where id_nss = c_pen.id_nss
             and substr(id_referencia, 1, 6) =
                 to_char(add_months(p_fecha, -1), 'MMYYYY');
 
          if (v_conteo > 0) then
            v_ErrorDetalle := 'P05';
--          anotar_error(v_ErrorDetalle, getDescError(v_ErrorDetalle));
            goto insertar_baja;
          end if;

          -- Para buscar el NSS en la dispersión del regimen subsidiado de SENASA en el período anterior
          select count(*)
            into v_Conteo
            from dual
           where exists (select 1
                         from suirplus.ars_cartera_senasa_t
                         where periodo_factura =
                           to_char(add_months(p_fecha, -1), 'YYYYMM')
                           and nss_titular = c_pen.id_nss)
                 or exists
                 (select 1
                  from suirplus.ars_cartera_senasa_t
                  where periodo_factura =
                        to_char(add_months(p_fecha, -1), 'YYYYMM')
                    and nss_dependiente = c_pen.id_Nss);
 
          if (v_conteo > 0) then
            v_ErrorDetalle := 'P06';
--          anotar_error(v_ErrorDetalle, getDescError(v_ErrorDetalle));
            goto insertar_baja;
          end if;

          -- Para buscar al pensionado como dependiente adicional de un trabajador en el regimen contributivo
          select count(*)
            into v_Conteo
            from suirplus.sre_dependiente_t
           where id_nss_dependiente = c_pen.id_nss
             and status = 'A';
 
          if (v_conteo > 0) then
            v_ErrorDetalle := 'P08';
--          anotar_error(v_ErrorDetalle, getDescError(v_ErrorDetalle));
            goto insertar_baja;
          end if;
        end if;

        <<insertar_baja>>
        if (v_ErrorDetalle != '0') then
          -- hubo bajas aplicadas
          v_OK := v_OK + 1;
 
          --Con esto agrupo una sola transaccion por ARS en el encabezado
          --Y todos los pensionados de dicha ARS en el detalle.
          BEGIN
            SELECT x.id_novedad
              INTO v_Novedad
              FROM suirplus.seh_nov_t x
             WHERE Nvl(x.id_ars, 0) = c_ars.id_ars
               AND x.tipo = 'T'
               AND Trunc(x.fecha_carga) = Trunc(sysdate)
               AND NVL(x.status,'N') = 'N';
          EXCEPTION WHEN NO_DATA_FOUND Then
            v_Novedad := 0;
          END;
       
          -- No existe la novedad de BAJA para la ARS en cuestion
          If NVL(v_Novedad, 0) = 0 Then
            select nvl(max(id_novedad), 0) + 1
              into v_Novedad
              from suirplus.seh_nov_t;
            
            v_secuencia := 1;
 
            -- insertar el movimiento
            insert into suirplus.seh_nov_t
              (id_novedad, id_ars, tipo, fecha_carga)
            values
              (v_Novedad, c_ars.id_ars, 'T', sysdate);
            commit;
          Else
            --Buscamos la proxima secuencia en el detalle de la novedad
            select nvl(max(secuencia), 0) + 1
              into v_secuencia
              from suirplus.seh_det_nov_t
             where id_novedad = v_Novedad;
          End if;

          -- insertar en el detalle de movimiento
          insert into suirplus.seh_det_nov_t
          (id_novedad,
           secuencia,
           tipo_novedad,
           estatus,
           nro_formulario,
           id_pensionado,
           id_ars_inscrito,
           id_motivo_baja)
          values
          (v_Novedad,
           v_secuencia,
           'B',
           'OK',
           0,
           c_pen.pensionado,
           c_pen.id_ars,
           v_ErrorDetalle);
          commit;
        End if;
      End loop; --Terminamos con los pensionados de una ARS

      -- Aplicamos los movimientos de los registros sin errores
      if (v_OK > 0) then
        SRE_PROCESAR_PN_PKG.aplica_movimientos(v_Novedad, p_fecha);
      end if;
     
      -- para actualizar la fecha de termino del proceso
      update suirplus.seh_nov_t
         set fecha_termino = sysdate,
             status = 'P'
       where id_novedad = v_Novedad;
      commit;
    End loop;
    -- Retroalimentación por email del resultado de la corrida del proceso
    -- enviar_email;
  exception
    when others then
      --Lista de correos a enviar el mensaje
      BEGIN
        SELECT p.lista_error
          INTO v_mail_to
          FROM suirplus.sfc_procesos_t p
         WHERE p.id_proceso = '59';
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          v_mail_to := v_mail_error;
      END;

      system.html_mail(v_mail_from,
                       v_mail_to,
                       'Error al insertar movimientos bajas, procedimiento SEH_PENSIONADOS_PKG.generar_movimientos_baja. Novedad # ' ||
                       v_Novedad,
                       sqlerrm);
  end;

  -- --------------------------------------------------------------------------------------------------
  -- Objetivo: genera la cartera de pensionados SEH para las ARS
  --    Autor: Gregorio Herrera.
  --    Fecha: 08/06/2009
  -- --------------------------------------------------------------------------------------------------
  procedure generar_cartera(p_fecha in date default sysdate) is
  begin
   -- Insetamos el registro en la bitacora
   BITACORA(m_id_bitacora, 'INI', '60');

   delete from suirplus.seh_cartera_t
    where periodo_cartera = to_char(p_fecha, 'YYYYMM');
   commit;

   -- insertamos en la cartera de forma grupal
  /*   insert into suirplus.seh_cartera_t
     (periodo_cartera,
      id_ars,
      pensionado,
      registro_dispersado,
      fecha_registro)
     select to_char(p_fecha, 'YYYYMM'), ID_ARS, PENSIONADO, 'N', sysdate
       from suirplus.seh_pensionados_t a
      where a.status = 'OK'
        and trunc(a.fecha_afiliacion) <= trunc(p_fecha - 1)
        --Considerar el tipo de causa y algunas causas de inhabilidad: Ticket #6513
        and exists
           (
            select 1
              from suirplus.sre_ciudadanos_t c
             where c.no_documento = a.no_documento
               and (
                    (c.tipo_causa is null) or (c.tipo_causa = 'I') or
                    (c.tipo_causa = 'C' and c.id_causa_inhabilidad = 2
                     and to_char(c.ult_fecha_act, 'yyyymm') >= to_char(p_fecha, 'yyyymm')
                     ) or
                     (c.tipo_causa = 'C' and c.id_causa_inhabilidad not in (114, 116))
                    )
            )
      order by id_ars, pensionado;
  */
   insert into suirplus.seh_cartera_t
     (periodo_cartera,
      id_ars,
      pensionado,
      registro_dispersado,
      fecha_registro
     )
     select to_char(p_fecha, 'YYYYMM'), ID_ARS, PENSIONADO, 'N', sysdate
     from suirplus.seh_pensionados_t a
     left join suirplus.sre_ciudadanos_t c
        on c.no_documento = a.no_documento 
       --Considerar el tipo de causa y algunas causas de inhabilidad: Ticket #6513
       and SUIRPLUS.SRE_CIUDADANO_INACTIVO_F(c.id_nss) = 'S' -- Se debe pagar la capita
     where a.status = 'OK'
       and trunc(a.fecha_afiliacion) <= trunc(p_fecha - 1)
     order by a.id_ars, a.pensionado;
   commit;

   -- para pasar la data al esquema SISALRIL_SUIR
   SEH_DTS_PKG.copiar_cartera;

   -- Si llegó hasta aqui, no hubo errores de excepciones
   BITACORA(m_id_bitacora, 'FIN', '60', 'OK.', 'O', '000');
  Exception
   when others then
     --Lista de correos a enviar el mensaje
     BEGIN
       SELECT p.lista_error
         INTO v_mail_to
         FROM suirplus.sfc_procesos_t p
        WHERE p.id_proceso = '60';
     EXCEPTION
       WHEN NO_DATA_FOUND THEN
         v_mail_to := v_mail_error;
     END;

     BITACORA(m_id_bitacora,
              'FIN',
              '60',
              substr(sqlerrm, 1, 255),
              'E',
              '650');
     system.html_mail(v_mail_from,
                      v_mail_to,
                      'ERROR Generando Cartera Pensionado SEH',
                      'Error en la generación de cartera SEH<br>Error=' ||
                      sqlerrm);
  end;

  -------------------------------------------------------------------------------------
  -- Autor   : Gregorio Herrera
  -- Fecha   : 08/06/2009
  -- Objetivo: Generar el contenido del archivo de notificacion de cartera para las ARS
  -- ----------------------------------------------------------------------------------
  procedure generar_notificacion_cartera(p_fecha in date default sysdate) is
   v_id_archivo     number(10);
   v_mensaje        blob;
   v_conteo         number(10);
   v_archivos       number(10) := 0;
   v_registros      number(10) := 0;
   v_total_archivos varchar2(100);
   procedure ADD(texto in varchar2) as
   begin
     dbms_lob.writeAppend(v_mensaje,
                          length(texto),
                          UTL_RAW.CAST_TO_RAW(texto));
   end;
  begin
   -- Insetamos el registro en la bitacora
   BITACORA(m_id_bitacora, 'INI', '61');

   --Data agrupada por ARS y Fecha
   for c_main in (select id_ars, periodo_cartera
                  from suirplus.seh_cartera_t
                  where periodo_cartera = to_char(p_fecha,'YYYYMM')
                  group by id_ars, periodo_cartera) loop
  /*     (select id_ars
                    from suirplus.seh_pensionados_t
                   where status = 'OK'
                     and trunc(fecha_afiliacion) <= trunc(p_fecha - 1)
                   group by id_ars) loop
  */  
     dbms_lob.createtemporary(v_mensaje, TRUE);
     dbms_lob.open(v_mensaje, dbms_lob.lob_readwrite);

     v_conteo   := 0;
     v_archivos := v_archivos + 1;

     --Formamos el registro del encabezado del archivo
     add('EPC' || LPAD(c_main.id_ars, 2, '0') ||
         to_char(trunc(p_fecha) - 1, 'YYYYMMDD') ||
         c_main.periodo_cartera || chr(13) || chr(10));

     --Data para una ARS
     for c_pen in (select c.pensionado, p.id_nss
                     from suirplus.seh_cartera_t c
                     join suirplus.seh_pensionados_t p
                       on p.pensionado = c.pensionado
                    where c.periodo_cartera = c_main.periodo_cartera
                      and c.id_ars = c_main.id_ars
                    order by c.id_ars, c.pensionado) loop
  /*       (select pensionado, id_nss
                     from suirplus.seh_pensionados_t
                    where id_ars = c_main.id_ars
                      and status = 'OK'
                      and trunc(fecha_afiliacion) <= trunc(p_fecha - 1)
                    order by id_ars, pensionado) loop
  */
       --Formamos los registros detalle del archivo
       add('D' || LPAD(c_pen.pensionado, 10, '0') ||
           LPAD(nvl(c_pen.id_nss, 0), 10, '0') || chr(13) || chr(10));
       v_conteo    := v_conteo + 1;
       v_registros := v_registros + 1;
     end loop;

     -- formamos el registro del sumario del archivo
     add('S' || LPAD(v_conteo + 2, 6, '0'));

     --procedemos a actualizar o a crear el registro en la tabla SEH_ARCHIVOS_T
     if (v_conteo > 0) then
       select count(*)
       into v_conteo
       from suirplus.seh_archivos_t a
       where id_ars  = c_main.id_ars
         and tipo    = 'PC'
         and periodo = c_main.periodo_cartera
         and trunc(fecha_generacion) = trunc(sysdate);
         
       if v_conteo > 0 then  
         update suirplus.seh_archivos_t a
            set a.nombre           = 'PC_' || to_char(trunc(p_fecha) - 1, 'YYYYMMDD') || '.TXT',
                a.fecha_generacion = sysdate,
                a.periodo          = c_main.periodo_cartera,
                a.archivo          = v_mensaje
          where id_ars = c_main.id_ars
            and tipo = 'PC'
            and trunc(fecha_generacion) = trunc(sysdate);
       else
         --creamos el registro
         select nvl(max(id_archivo), 0) + 1
           into v_id_archivo
           from suirplus.seh_archivos_t;

         insert into suirplus.seh_archivos_t
           (id_archivo,
            tipo,
            id_ars,
            nombre,
            fecha_generacion,
            periodo,
            archivo)
         values
           (v_id_archivo,
            'PC',
            c_main.id_ars,
            'PC_' || to_char(trunc(p_fecha) - 1, 'YYYYMMDD') || '.TXT',
            sysdate,
            c_main.periodo_cartera,
            v_mensaje);

         if (v_total_archivos is null) then
           v_total_archivos := v_id_archivo;
         else
           v_total_archivos := v_total_archivos || ', ' || v_id_archivo;
         end if;
       end if;
       commit;
     end if;

     dbms_lob.close(v_mensaje);
     dbms_lob.freetemporary(v_mensaje);
   end loop;

   -- Si llegó hasta aqui, no hubo errores de excepciones
   BITACORA(m_id_bitacora,
            'FIN',
            '61',
            'OK. archivos nro=' || v_total_archivos,
            'O',
            '000');
  Exception
   when others then
     dbms_lob.close(v_mensaje);
     dbms_lob.freetemporary(v_mensaje);
     BITACORA(m_id_bitacora,
              'FIN',
              '61',
              substr(sqlerrm, 1, 255),
              'E',
              '650');

     --Lista de correos a enviar el mensaje
     BEGIN
       SELECT p.lista_error
         INTO v_mail_to
         FROM suirplus.sfc_procesos_t p
        WHERE p.id_proceso = '61';
     EXCEPTION
       WHEN NO_DATA_FOUND THEN
         v_mail_to := v_mail_error;
     END;

     system.html_mail(v_mail_from,
                      v_mail_to,
                      'ERROR Generando Notificación Cartera Pensionados SEH',
                      'Error en la generación notificación cartera pensionados SEH, nro. archivo=' ||
                      v_id_archivo || '<br>Error=' || sqlerrm);
  End;

  ----------------------------------------------------------------------------------------
  -- Autor   : Gregorio Herrera
  -- Fecha   : 09/06/2009
  -- Objetivo: Generar el contenido del archivo de notificacion de cartera para la ARS SEH
  -- -------------------------------------------------------------------------------------
  procedure generar_notifiacion_carteraSEH(p_fecha in date default sysdate) is
   v_id_archivo number(10);
   v_mensaje    blob;
   v_registros  number(10) := 0;
   procedure ADD(texto in varchar2) as
   begin
     dbms_lob.writeAppend(v_mensaje,
                          length(texto),
                          UTL_RAW.CAST_TO_RAW(texto));
   end;
  begin
   -- Insetamos el registro en la bitacora
   BITACORA(m_id_bitacora, 'INI', '61');

   dbms_lob.createtemporary(v_mensaje, TRUE);
   dbms_lob.open(v_mensaje, dbms_lob.lob_readwrite);

   --Formamos el registro del encabezado del archivo
   add('EPC' || to_char(trunc(p_fecha) - 1, 'YYYYMMDD') ||
       to_char(p_fecha, 'YYYYMM') || chr(13) || chr(10));

   --Data para las ARS
   for c_pen in (select c.id_ars, c.pensionado, p.id_nss
                   from suirplus.seh_cartera_t c
                   join suirplus.seh_pensionados_t p
                     on p.pensionado = c.pensionado
                  where c.periodo_cartera = to_char(p_fecha,'YYYYMM')
                 order by c.id_ars, c.pensionado) loop 
  /*     (select id_ars, pensionado, id_nss
                   from suirplus.seh_pensionados_t
                  where status = 'OK'
                    and trunc(fecha_afiliacion) <= trunc(p_fecha - 1)
                  order by id_ars, pensionado) loop
  */ 
     --Formamos los registros detalle del archivo
     add('D' || LPAD(c_pen.id_ars, 2, '0') ||
         LPAD(c_pen.pensionado, 10, '0') ||
         LPAD(nvl(c_pen.id_nss, 0), 10, '0') || chr(13) || chr(10));
     v_registros := v_registros + 1;
   end loop;

   -- formamos el registro del sumario del archivo
   add('S' || LPAD(v_registros + 2, 6, '0'));

   --procedemos a actualizar o a crear el registro en la tabla SEH_ARCHIVOS_T
   if (v_registros > 0) then
     select count(*)
     into v_registros
     from suirplus.seh_archivos_t a
     where id_ars  = 98 --ID ARS de SEH
       and tipo    = 'PC'
       and periodo = to_char(p_fecha, 'YYYYMM')
       and trunc(fecha_generacion) = trunc(sysdate);
         
     if v_registros > 0 then 
       update suirplus.seh_archivos_t a
          set a.nombre           = 'PC_' || to_char(trunc(p_fecha) - 1, 'YYYYMMDD') || '.TXT',
              a.fecha_generacion = sysdate,
              a.periodo          = to_char(p_fecha, 'YYYYMM'),
              a.archivo          = v_mensaje
        where id_ars = 98 --ID ARS de SEH
          and tipo = 'PC'
          and trunc(fecha_generacion) = trunc(sysdate);
     else
       --creamos el registro
       select nvl(max(id_archivo), 0) + 1
         into v_id_archivo
         from suirplus.seh_archivos_t;

       insert into suirplus.seh_archivos_t
         (id_archivo,
          tipo,
          id_ars,
          nombre,
          fecha_generacion,
          periodo,
          archivo)
       values
         (v_id_archivo,
          'PC',
          98,
          'PC_' || to_char(trunc(p_fecha) - 1, 'YYYYMMDD') || '.TXT',
          sysdate,
          to_char(p_fecha, 'YYYYMM'),
          v_mensaje);
     end if;
     commit;
   end if;

   dbms_lob.close(v_mensaje);
   dbms_lob.freetemporary(v_mensaje);

   -- Si llegó hasta aqui, no hubo errores de excepciones
   BITACORA(m_id_bitacora,
            'FIN',
            '61',
            'OK. archivo nro=' || v_id_archivo,
            'O',
            '000');
  Exception
   when others then
     dbms_lob.close(v_mensaje);
     dbms_lob.freetemporary(v_mensaje);
     BITACORA(m_id_bitacora,
              'FIN',
              '61',
              substr(sqlerrm, 1, 255),
              'E',
              '650');

     --Lista de correos a enviar el mensaje
     BEGIN
       SELECT p.lista_error
         INTO v_mail_to
         FROM suirplus.sfc_procesos_t p
        WHERE p.id_proceso = '61';
     EXCEPTION
       WHEN NO_DATA_FOUND THEN
         v_mail_to := v_mail_error;
     END;

     system.html_mail(v_mail_from,
                      v_mail_to,
                      'ERROR Generando Notificación Cartera Pensionado SEH',
                      'Error en la generación notificación cartera pensionado consolidado SEH, nro. archivo=' ||
                      v_id_archivo || '<br>Error=' || sqlerrm);
  End;

  ----------------------------------------------------------------------------------------
  -- Autor   : Gregorio Herrera
  -- Fecha   : 09/06/2009
  -- Objetivo: Generar el contenido del archivo de notificacion de cartera para la ARS SEH
  --           con la estructura de SIJUPEN
  -- -------------------------------------------------------------------------------------
  procedure notifiacion_cartera_SIJUPEN(p_fecha in date default sysdate) is
    v_id_archivo number(10);
    v_mensaje    blob;
    v_registros  number(10) := 0;
    procedure ADD(texto in varchar2) as
    begin
      dbms_lob.writeAppend(v_mensaje,
                           length(texto),
                           UTL_RAW.CAST_TO_RAW(texto));
    end;
  begin
    -- Insetamos el registro en la bitacora
    BITACORA(m_id_bitacora, 'INI', '61');

    dbms_lob.createtemporary(v_mensaje, TRUE);
    dbms_lob.open(v_mensaje, dbms_lob.lob_readwrite);

    --Formamos el registro del encabezado del archivo
    add('E 401514682' ||
        RPAD('CONSEJO NACIONAL DE SEGURIDAD SOCIAL', 50, ' ') ||
        to_char(p_fecha, 'YYYYMMDD') || RPAD('Seguro Salud', 250, ' ') ||
        chr(13) || chr(10));

    --Data para las ARS
    for c_pen in (select p.no_documento, p.nombre, p.pension, c.periodo_cartera
                  from suirplus.seh_cartera_t c
                  join suirplus.seh_pensionados_t p
                    on p.pensionado = c.pensionado
                  where c.periodo_cartera = to_char(p_fecha, 'YYYYMM')
                  order by c.pensionado) loop    
    /*     (select no_documento, nombre, pension
                    from suirplus.seh_pensionados_t
                   where status = 'OK'
                     and trunc(fecha_afiliacion) <= trunc(p_fecha - 1)
                   order by pensionado) loop
    */ 
      --Formamos los registros detalle del archivo
      add('D' || LPAD(c_pen.no_documento, 11, ' ') ||
          RPAD(c_pen.nombre, 50, ' ') || LPAD('0', 23, '0') ||
          c_pen.periodo_cartera || '01' ||
          to_char(LAST_DAY(p_fecha), 'YYYYMMDD') ||
          LPAD(c_pen.pension, 8, '0') || chr(13) || chr(10));
      v_registros := v_registros + 1;
    end loop;

    -- formamos el registro del sumario del archivo
    add('T' || LPAD(v_registros, 5, '0') || LPAD('0', 15, '0') || '.0000');

    --procedemos a actualizar o a crear el registro en la tabla SEH_ARCHIVOS_T
    if (v_registros > 0) then
      select count(*)
      into v_registros
      from suirplus.seh_archivos_t a
      where id_ars  = 98 --ID ARS de SEH
        and tipo    = 'PS'
        and periodo = to_char(p_fecha, 'YYYYMM')
        and trunc(fecha_generacion) = trunc(sysdate);

      if v_registros > 0 then    
        update suirplus.seh_archivos_t a
           set a.nombre           = 'PS_' || to_char(trunc(sysdate) - 1, 'YYYYMMDD') || '.TXT',
               a.fecha_generacion = sysdate,
               a.periodo          = to_char(p_fecha, 'YYYYMM'),
               a.archivo          = v_mensaje
         where id_ars = 98 --ID ARS de SEH
           and tipo = 'PS'
           and trunc(fecha_generacion) = trunc(sysdate);
      else
        --creamos el registro
        select nvl(max(id_archivo), 0) + 1
          into v_id_archivo
          from suirplus.seh_archivos_t;

        insert into suirplus.seh_archivos_t
          (id_archivo,
           tipo,
           id_ars,
           nombre,
           fecha_generacion,
           periodo,
           archivo)
        values
          (v_id_archivo,
           'PS',
           98,
           'PS_' || to_char(trunc(p_fecha) - 1, 'YYYYMMDD') || '.TXT',
           sysdate,
           to_char(p_fecha, 'YYYYMM'),
           v_mensaje);
      end if;
      commit;
    end if;

    dbms_lob.close(v_mensaje);
    dbms_lob.freetemporary(v_mensaje);

    -- Si llegó hasta aqui, no hubo errores de excepciones
    BITACORA(m_id_bitacora,
             'FIN',
             '61',
             'OK. archivo nro=' || v_id_archivo,
             'O',
             '000');
  Exception
  when others then
    dbms_lob.close(v_mensaje);
    dbms_lob.freetemporary(v_mensaje);
    BITACORA(m_id_bitacora,
             'FIN',
             '61',
             substr(sqlerrm, 1, 255),
             'E',
             '650');

    --Lista de correos a enviar el mensaje
    BEGIN
      SELECT p.lista_error
        INTO v_mail_to
        FROM suirplus.sfc_procesos_t p
       WHERE p.id_proceso = '61';
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        v_mail_to := v_mail_error;
    END;

    system.html_mail(v_mail_from,
                     v_mail_to,
                     'ERROR Generando Notificación Cartera Pensionado SIJUPEN',
                     'Error en la generación notificación cartera pensionado consolidado SIJUPEN, nro. archivo=' ||
                     v_id_archivo || '<br>Error=' || sqlerrm);
  End;

  -- -----------------------------------------------------------------------------------
  -- Objetivo: genera la dispersion de las ARS a partir de la cartera de pensionados SEH
  --    Autor: Gregorio Herrera.
  --    Fecha: 12/06/2009
  -- -----------------------------------------------------------------------------------
  procedure generar_dispersion(p_fecha in date default sysdate) is
   v_id_archivo number(10);
   v_mensaje    blob;
   v_conteo     number(10);
   v_archivos   number(10) := 0;
   v_registros  number(10) := 0;
   v_result     varchar2(1000);

   --v_percapita  number(10,2);

   TYPE t_ars IS TABLE OF suirplus.sfc_det_parametro_t.valor_numerico%type index by binary_integer;

   m_ars t_ars;

   procedure ADD(texto in varchar2) as
   begin
     dbms_lob.writeAppend(v_mensaje,
                          length(texto),
                          UTL_RAW.CAST_TO_RAW(texto));
   end;
  begin
   -- PER CAPITA ARS SALUD SEGURA
   select valor_numerico
     into m_ars(2)
     from suirplus.sfc_det_parametro_t
    where id_parametro = 150
      and fecha_fin is null;

   -- PER CAPITA ARS SEMMA
   select valor_numerico
     into m_ars(42)
     from suirplus.sfc_det_parametro_t
    where id_parametro = 153
      and fecha_fin is null;

   -- PER CAPITA ARS SENASA
   select valor_numerico
     into m_ars(52)
     from suirplus.sfc_det_parametro_t
    where id_parametro = 154
      and fecha_fin is null;

   -- Insetamos el registro en la bitacora
   BITACORA(m_id_bitacora, 'INI', '62');

   -- Per capita para regimen de pensiones SEH
   -- v_percapita := parm.get_parm_number(150);

   -- iteramos en la cartera de pensionados agrupado por ARS
   for c_main in (select id_ars
                    from suirplus.seh_cartera_t
                   where periodo_cartera = to_char(p_fecha, 'YYYYMM')
                   group by id_ars) loop
     dbms_lob.createtemporary(v_mensaje, TRUE);
     dbms_lob.open(v_mensaje, dbms_lob.lob_readwrite);

     v_conteo   := 0;
     v_archivos := v_archivos + 1;

     --Formamos el registro del encabezado del archivo
     add('EPD' || LPAD(c_main.id_ars, 2, '0') ||
         to_char(p_fecha - 1, 'YYYYMMDD') || to_char(p_fecha, 'YYYYMM') ||
         chr(13) || chr(10));

     --Data para una ARS
     for c_car in (select c.periodo_cartera,
                          c.id_ars,
                          c.pensionado,
                          p.id_nss,
                          c.rowid fila
                     from suirplus.seh_cartera_t c
                     join suirplus.seh_pensionados_t p
                       on p.pensionado = c.pensionado
                    where c.periodo_cartera = to_char(p_fecha, 'YYYYMM')
                      and c.id_ars = c_main.id_ars
                    order by pensionado) loop
       --Marcamos como dispersado el registro
       update suirplus.seh_cartera_t
          set monto_dispersar     = m_ars(c_car.id_ars), --v_percapita,
              fecha_dispersion    = sysdate,
              registro_dispersado = 'S'
        where rowid = c_car.fila;
       commit;

       --Formamos los registros detalle del archivo
       --add('D'||LPAD(c_car.pensionado,10,'0')||LPAD(nvl(c_car.id_nss,0),10,'0')||LPAD(v_percapita,7,'0')||chr(13)||chr(10));
       add('D' || LPAD(c_car.pensionado, 10, '0') ||
           LPAD(nvl(c_car.id_nss, 0), 10, '0') ||
           LPAD(m_ars(c_car.id_ars), 7, '0') || chr(13) || chr(10));
       v_conteo    := v_conteo + 1;
       v_registros := v_registros + 1;
     end loop;

     -- formamos el registro del sumario del archivo
     add('S' || LPAD(v_conteo + 2, 6, '0'));

     --procedemos a actualizar o a crear el registro en la tabla SEH_ARCHIVOS_T
     if (v_conteo > 0) then
       select count(*)
        into v_conteo
        from suirplus.seh_archivos_t a
       where id_ars  = c_main.id_ars
         and tipo    = 'PD'
         and periodo = to_char(p_fecha, 'YYYYMM')
         and trunc(fecha_generacion) = trunc(sysdate);
   
       if v_conteo > 0 then       
         update suirplus.seh_archivos_t a
            set a.nombre           = 'PD_' || to_char(p_fecha - 1, 'YYYYMMDD') || '.TXT',
                a.fecha_generacion = sysdate,
                a.periodo          = to_char(p_fecha, 'YYYYMM'),
                a.archivo          = v_mensaje
          where id_ars = c_main.id_ars
            and tipo = 'PD'
            and trunc(fecha_generacion) = trunc(sysdate);

       else
         --creamos el registro
         select nvl(max(id_archivo), 0) + 1
           into v_id_archivo
           from suirplus.seh_archivos_t;

         insert into suirplus.seh_archivos_t
           (id_archivo,
            tipo,
            id_ars,
            nombre,
            fecha_generacion,
            periodo,
            archivo)
         values
           (v_id_archivo,
            'PD',
            c_main.id_ars,
            'PD_' || to_char(p_fecha - 1, 'YYYYMMDD') || '.TXT',
            sysdate,
            to_char(p_fecha, 'YYYYMM'),
            v_mensaje);
       end if;
       commit;
     end if;

     dbms_lob.close(v_mensaje);
     dbms_lob.freetemporary(v_mensaje);
   end loop;

   -- para actualizar la dispersión en el esquema SISALRIL_SUIR
   SEH_DTS_PKG.actualizar_dispersion;

   -- Si llegó hasta aqui, no hubo errores de excepciones
   BITACORA(m_id_bitacora, 'FIN', '62', 'OK.', 'O', '000');

   --Carga resumen Dispersion
   cargar_resumen_pensionados(v_result);

  Exception
   when others then
     dbms_lob.close(v_mensaje);
     dbms_lob.freetemporary(v_mensaje);
     BITACORA(m_id_bitacora,
              'FIN',
              '62',
              substr(sqlerrm, 1, 255),
              'E',
              '650');

     --Lista de correos a enviar el mensaje
     BEGIN
       SELECT p.lista_error
         INTO v_mail_to
         FROM suirplus.sfc_procesos_t p
        WHERE p.id_proceso = '62';
     EXCEPTION
       WHEN NO_DATA_FOUND THEN
         v_mail_to := v_mail_error;
     END;

     system.html_mail(v_mail_from,
                      v_mail_to,
                      'ERROR Generando Dispersion Pensionado SEH',
                      'Error en la generación de la dispersion SEH<br>Error=' ||
                      sqlerrm);
  end;

  --------------------------------------------------------------------------
  -- Procedure: getHistoricoPensionado
  -- Objetivo : Muestra el historico de un Pensionado
  -- Fecha    : 30/07/2009
  -- Autor    : Mayreni Vargas
  --------------------------------------------------------------------------
  procedure getHistoricoPensionado(p_idpensionado in seh_pensionados_t.pensionado%type,
                                   p_iocursor     out t_cursor,
                                   p_resultNumber out varchar2)

   is
    v_bderror VARCHAR(1000);
  Begin

    Open p_iocursor For
      select c.pensionado,
             c.periodo_cartera,
             p.id_ars,
             n.ars_des,
             p.nombre,
             c.monto_dispersar,
             c.fecha_dispersion,
             c.registro_dispersado
        from seh_pensionados_t p
        join seh_cartera_t c
          on p.pensionado = c.pensionado
        join ars_catalogo_t n
          on c.id_ars = n.id_ars
       where p.pensionado = p_idpensionado;

    p_resultNumber := '0';
  Exception
    When others then
      v_bderror      := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultnumber := Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
  End;
  
  -- -----------------------------------------------------------------------
  -- cargar_resumen_dispersion_pensionados: resumen de dispersion
  -- Greiman_Garcia
  -- 18/11/2009
  -- -----------------------------------------------------------------------
  procedure cargar_resumen_pensionados(p_result out varchar2) is

    m_result       varchar2(32000) := 'ok';
    v_registros    number := 0;
    v_periodo      varchar2(6);
    v_texto        varchar2(32767);
    v_total_reg    number := 0;
    v_total_pago   number := 0;
    mail_to        varchar2(1000);
    mail_err       varchar2(1000);
  begin
    -- trae el periodo a dispersar
    select max(periodo_cartera) into v_periodo from suirplus.seh_cartera_t;

    -- verificar si hay un resumen previo
    select count(*)
      into v_registros
      from suirplus.seh_resumen_pensionados_t
     where periodo_cartera =v_periodo;

    -- si no encontro registros, poner en cero
    v_registros := nvl(v_registros, 0);

    -- si existen registros, entonces, es un reproceso, eliminar el resumen previo
    if v_registros > 0 then
       delete suirplus.seh_resumen_pensionados_t where periodo_cartera = v_periodo;
    end if;

    -- insertar registros en resumen
    insert into suirplus.seh_resumen_pensionados_t
      (periodo_cartera, id_ars, ars_des, pensionados_disp, pago, fecha_dispersion)
      select c.periodo_cartera,
             c.id_ars,
             a.ars_des,
             count(*) pensionados,
             sum(c.monto_dispersar) pago,
             sysdate fecha_dispersion
        from suirplus.seh_cartera_t c
        join suirplus.ars_catalogo_t a on a.id_ars = c.id_ars
       where c.periodo_cartera = v_periodo
         and c.registro_dispersado = 'S'
       group by c.periodo_cartera, c.id_ars, a.ars_des;
      commit;

     p_result := m_result;

     v_texto := '<html><head><title></title><STYLE TYPE="text/css">
                   <!--.smallfont{font-size:xx-small; font-family:verdana; border-collapse:collapse;}-->
                   </STYLE>
                   </head>
                  <body>
                  Resumen de dispersi&oacute;n de pensionado del per&iacute;odo:'||v_periodo||'
                  <table cellpadding="2" cellspacing="1" border="1" CLASS="smallfont">
                  <tr><th bgcolor="silver">ID ARS</th>
                  <th bgcolor="silver">Descripci</th><th bgcolor="silver">Pensionados</th>
                  <th bgcolor="silver">Per C</th><th bgcolor="silver">Pago</th></tr>';

     for r in (select c.periodo_cartera,
                c.id_ars,
                a.ars_des,
                count(*) pensionados,
                c.monto_dispersar per_capita,
                sum(c.monto_dispersar) pago,
                sysdate fecha_dispersion
                from suirplus.seh_cartera_t c
                join suirplus.ars_catalogo_t a on a.id_ars = c.id_ars
                where c.periodo_cartera = v_periodo
                  and c.registro_dispersado = 'S'
                group by c.periodo_cartera, c.id_ars, a.ars_des, c.monto_dispersar)

      loop

        v_texto := v_texto ||'<tr><td align="right">'||r.id_ars||'</td>'||
                           '<td>'||r.ars_des||'</td>'||
                           '<td align="right">'||to_char(r.pensionados,'999,999')||'</td>'||
                           '<td align="right">'||to_char(r.per_capita,'999,999,990.00')||'</td>'||
                           '<td align="right">'||to_char(r.pago,'999,999,990.00')||'</td></tr>';
        v_total_reg  := v_total_reg  + r.pensionados;
        v_total_pago := v_total_pago + r.pago;

      end loop;
      v_texto := v_texto ||'<tr><td colspan="2" align="center" color="silver"><b>Totales</b></td>'
                    ||'<td align="right" bgcolor="silver"><font color="green">' || to_char(v_total_reg ,'999,999,990') ||'</td>'
                    ||'<td bgcolor="silver"></td>'
                    ||'<td align="right" bgcolor="silver"><font color="green">' || to_char(v_total_pago,'999,999,990.00') ||'</td></tr>';

      v_texto := v_texto || '</table></body></html>';

      --Sacamos la lista de correos de la tabla de procesos
      Begin
        Select p.lista_ok
        Into mail_to
        From suirplus.sfc_procesos_t p
        Where p.id_proceso = '17';
      Exception when no_data_found then
        mail_to := '_operaciones@mail.tss2.gov.do';
      End;

      system.html_mail('info@mail.tss2.gov.do', mail_to,'Resumen Dispersi&oacute;n de Pensionados del per&iacute;odo:'||v_periodo, v_texto);
  exception When others then
    --Sacamos la lista de correos de la tabla de procesos
    Begin
      Select p.lista_error
      Into mail_err
      From suirplus.sfc_procesos_t p
      Where p.id_proceso = '17';
    Exception when no_data_found then
      mail_err := '_operaciones@mail.tss2.gov.do';
    End;

    p_result := 'error al procesar resumen de dispersi&oacute;n de pensionados.';

    system.html_mail('info@mail.tss2.gov.do',mail_err,p_result,sqlerrm);
  end;

  --*********************************************************************************************---
  --CMHA
  --24/11/2010
  --RESUMEN DISPENSION PENSIONADO
  --*********************************************************************************************---
  procedure getResumePensionado(p_periodo      in seh_resumen_pensionados_t.periodo_cartera%type,
                                p_iocursor     out t_cursor,
                                p_resultnumber out varchar2) is
    v_cursor  t_cursor;
    v_bderror varchar2(1000);
  begin
    OPEN v_cursor for
      select a.id_ars           codigo_ars,
             a.ars_des          Descripcion,
             a.pensionados_disp Cantidad_Pensionados,
             a.pago
        from seh_resumen_pensionados_t a
       where a.periodo_cartera = p_periodo
       order by id_ars asc;

    p_resultnumber := 0;
    p_iocursor     := v_cursor;

  exception
    when others then
      v_bderror      := (substr('error ' || to_char(sqlcode) || ': ' ||
                                sqlerrm,
                                1,
                                255));
      p_resultnumber := seg_retornar_cadena_error(-1, v_bderror, sqlcode);

  end;

  ---************************************************************************************--
  -- prog = getPeriodosDispersion
  -- by charile peña
  -- trae una lista de los distintos periodos que existen en dispersion.
  ---************************************************************************************--
  procedure getPeriodosDispPensionado(p_iocursor     in out t_cursor,
                                     p_resultnumber out Varchar2) is
   v_cursor  t_cursor;
   v_bderror varchar2(1000);

  begin

   open v_cursor for
     select distinct a.periodo_cartera
       from suirplus.seh_resumen_pensionados_t a
      order by a.periodo_cartera desc;

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

  -- -------------------------------------------------------------------------
  -- generar_notificacion_traslados: informe de pensionados pendientes por ARS
  -- Gregorio Herrera
  -- 04/08/2011
  -- -------------------------------------------------------------------------
  procedure generar_notificacion_traspasos(p_fecha in date default trunc(sysdate - 1)) is
    v_texto          clob;
    v_total_reg      number := 0;
    v_error          varchar2(3000);
    v_titulo_proceso varchar2(100);
    v_fecha          date;
    v_ARS            varchar2(200) := ' ';

    PROCEDURE ADD(TEXTO IN VARCHAR2) AS
    BEGIN
      dbms_lob.writeAppend(v_texto, length(texto), texto);
    END;

  begin
    v_titulo_proceso := 'Notificaci&oacute;n autom&aacute;tica de pensionados pendientes de afiliaci&oacute;n.';
    v_fecha          := p_fecha;

    -- Buscar listas de correos
    Begin
      Select p.lista_ok, p.lista_error
        Into v_mail_to, v_mail_error
        From suirplus.sfc_procesos_t p
       Where p.id_proceso = '17';
    Exception
      when no_data_found then
        v_mail_to    := '_operaciones@mail.tss2.gov.do';
        v_mail_error := '_operaciones@mail.tss2.gov.do';
    End;

    -- las ARS que tienen registros pendientes de afiliacion
    for r_ars in (select distinct p.id_ars,
                                  c.ars_des,
                                  c.lista_pendiente_afiliacion -- Lista de Correo
                    from suirplus.sre_archivos_t b
                    join suirplus.seh_nov_t n
                      on n.id_recepcion = b.id_recepcion
                    join suirplus.seh_det_nov_t dn
                      on dn.id_novedad = n.id_novedad
                    join suirplus.seh_pensionados_t p
                      on p.pensionado = dn.id_pensionado
                    join suirplus.ars_catalogo_t c
                      on c.id_ars = p.id_ars
                     and c.lista_pendiente_afiliacion is not null
                   where b.id_tipo_movimiento = 'PT'
                     and b.status = 'P' -- Traspaso Procesado
                     and dn.tipo_novedad = 'C' -- Novedad Final de Traspaso
                     and b.fecha_carga > v_fecha -- Fecha de la Transaccion
                     and p.status = 'AF' -- Pendiente de Afiliacion
                   order by 1) loop
      v_total_reg := 0;

      if r_ars.id_ars = 52 then
        v_ARS := 'ARS SENASA'; -- En el catologo "el nombre real" no aplica para este caso.
      else
        v_ARS := r_ars.ars_des;
      end if;

      v_texto := '<html><head><title></title><STYLE TYPE="text/css">
                   <!--.smallfont{font-size:xx-small; font-family:verdana; border-collapse:collapse;}-->
                   </STYLE>
                   </head>
                  <body>
                  Notificaci&oacute;n pensionados pendientes de afiliaci&oacute;n ARS: ' ||
                 v_ARS || '<table cellpadding="2" cellspacing="1" border="1" CLASS="smallfont">
                  <tr>
                      <th bgcolor="silver">ID Pensionado        </th>
                      <th bgcolor="silver">Instituci&oacute;n   </th>
                      <th bgcolor="silver">No. Documento        </th>
                      <th bgcolor="silver">Nombre del Pensionado</th>
                      <th bgcolor="silver">Direcci&oacute;      </th>
                      <th bgcolor="silver">Telefono             </th>
                      <th bgcolor="silver">Status               </th>
                      <th bgcolor="silver">ID ARS               </th>
                      <th bgcolor="silver">pensi&oacute;n       </th>
                  </tr>';

      -- los pensionados pendientes de afiliacion de cada ARS
      for r in (select distinct p.pensionado,
                                p.institucion,
                                p.no_documento,
                                p.nombre,
                                p.direccion,
                                p.telefono,
                                p.status,
                                p.id_ars,
                                p.pension
                  from suirplus.sre_archivos_t b
                  join suirplus.seh_nov_t n
                    on n.id_recepcion = b.id_recepcion
                  join suirplus.seh_det_nov_t dn
                    on dn.id_novedad = n.id_novedad
                  join suirplus.seh_pensionados_t p
                    on p.pensionado = dn.id_pensionado
                  join suirplus.ars_catalogo_t c
                    on c.id_ars = p.id_ars
                   and c.lista_pendiente_afiliacion is not null
                 where b.id_tipo_movimiento = 'PT'
                   and b.status = 'P' -- Traspaso Procesado
                   and dn.tipo_novedad = 'C' -- Novedad Final de Traspaso
                   and b.fecha_carga > v_fecha -- Fecha de la Transaccion
                   and p.status = 'AF' -- Pendiente de Afiliacion
                   and p.id_ars = r_ars.id_ars
                 order by p.pensionado) loop
        ADD('<tr><td align="right">' || r.pensionado || '</td>' || '<td>' ||
            r.institucion || '</td>' || '<td>' || r.no_documento ||
            '</td>' || '<td>' || r.nombre || '</td>' || '<td>' ||
            r.direccion || '</td>' || '<td>' || r.telefono || '</td>' ||
            '<td>' || r.status || '</td>' || '<td>' || r.id_ars || '</td>' ||
            '<td>' || r.pension || '</td>' || '</td></tr>');

        v_total_reg := v_total_reg + 1;
      end loop;

      ADD('</table><b>Total pensionados: ' ||
          to_char(v_total_reg, '999,999,990') || '</b><br></body></html>');

      system.html_mail('info@mail.tss2.gov.do',
                       r_ars.lista_pendiente_afiliacion,
                       v_titulo_proceso || ' ' || v_ARS,
                       v_texto);
    end loop;
  Exception
    When others then
      v_error := 'Error: ' || sqlerrm;
      system.html_mail('info@mail.tss2.gov.do',
                       v_mail_error,
                       'Error procesando ' || v_titulo_proceso || ' ' ||
                       v_ARS,
                       v_error);
  End;

end SEH_PENSIONADOS_PKG;
