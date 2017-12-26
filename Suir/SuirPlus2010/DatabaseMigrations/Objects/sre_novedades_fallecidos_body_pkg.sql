create or replace package body suirplus.SRE_NOVEDADES_FALLECIDOS_PKG is
  -----------------------------------------------------------------------------------------------------------------------------
  --Procesos de carga de datos de la vista a UNIPAGO
  -- Objetivo: Refrescar la informacion de los fallecidos recibidos desde UNIPAGO.
  -- Autor: Yacell Borges, Gregorio Herrera
  -- Fecha: 3/7/2012
  -----------------------------------------------------------------------------------------------------------------------------

  c_mail_to      varchar2(250);
  c_mail_error   varchar2(250);
  v_html         clob;
  v_errores      varchar2(32000);
  
  -----------------------------------------------------------------------------------------------------------------------------
  -- Insertar el registro en la maestra de bitacora
  -----------------------------------------------------------------------------------------------------------------------------
  PROCEDURE bitacora (
    p_id_bitacora IN OUT SUIRPLUS.SFC_BITACORA_T.id_bitacora%TYPE,
    p_accion      IN VARCHAR2 DEFAULT 'INI',
    p_id_proceso  IN SUIRPLUS.SFC_BITACORA_T.id_proceso%TYPE,
    p_mensage     IN SUIRPLUS.SFC_BITACORA_T.mensage%TYPE DEFAULT NULL,
    p_status      IN SUIRPLUS.SFC_BITACORA_T.status%TYPE DEFAULT NULL,
    p_id_error    IN SUIRPLUS.SEG_ERROR_T.id_error%TYPE DEFAULT NULL,
    p_seq_number  IN SUIRPLUS.ERRORS.seq_number%TYPE DEFAULT NULL,
    p_periodo     IN SUIRPLUS.SFC_BITACORA_T.periodo%TYPE DEFAULT NULL
  ) IS
  BEGIN
    CASE p_accion
    WHEN 'INI' THEN
      SELECT SUIRPLUS.sfc_bitacora_seq.NEXTVAL INTO p_id_bitacora FROM dual;
      INSERT INTO SUIRPLUS.SFC_BITACORA_T(id_proceso, id_bitacora, fecha_inicio, fecha_fin, mensage, status, periodo)
          VALUES(p_id_proceso, p_id_bitacora, SYSDATE, NULL, p_mensage, 'P', p_periodo);

    WHEN 'FIN' THEN
      UPDATE SUIRPLUS.SFC_BITACORA_T
         SET fecha_fin   = SYSDATE,
             mensage     = p_mensage,
             status      = p_status,
             seq_number  = p_seq_number,
             id_error    = p_id_error
       WHERE id_bitacora = p_id_bitacora;
    ELSE
      RAISE_APPLICATION_ERROR(010, 'Parametro invalido');
    END CASE;
    COMMIT;
  END;

  -- ------------------------------------------------------------------------------------------------------------------------------------
  procedure html_add(texto in varchar2) as
  begin
    dbms_lob.writeAppend( v_html, length(texto), texto );
  end;

  -- ------------------------------------------------------------------------------------------------------------------------------------
  procedure refrescar_vista as
  begin
    execute immediate 'begin sys.DBMS_SNAPSHOT.refresh(''suirplus.suir_ciudadano_fallecido_mv''); end;';
  exception when others then
    rollback;
    system.html_mail('info@mail.tss2.gov.do',c_mail_error,'Error al refrescar la vista SUIRPLUS.SUIR_CIUDADANO_FALLECIDO_MV', sqlerrm);
  end;

	-- ------------------------------------------------------------------------------------------------------------------------------------
  procedure cargar_lotes as
    m_conteo  integer;
    m_proximo integer;
  begin
    for lotes in (select a.n_num_control lote,count(*) registros
                  from suirplus.suir_ciudadano_fallecido_mv a
                  where dbms_lob.getlength(a.b_imagen_acta_defuncion) > 0
                  group by a.n_num_control)
    loop
      -- verificar que dicho lote ho haya sido cargado antes
      select count(*)
      into m_conteo
      from sre_novedades_fallecidos_t s
      where s.nro_lote=lotes.lote;

      if m_conteo=0 then
        -- determinar el proximo numero de solicitud
        begin
          select nvl(max(nf.id_novedad_fallecido),0)+1
          into m_proximo
          from sre_novedades_fallecidos_t nf;


        -- crear el registro del lote
        insert into sre_novedades_fallecidos_t (
          ID_NOVEDAD_FALLECIDO,
          NRO_LOTE,
          fecha_carga,
          status,
          registros_ok,
          registros_err,
          ult_usuario_act,
          ult_fecha_act
        ) values (
          m_proximo,
          lotes.lote,
          sysdate,
          'N',
          0,
          0,
          'UNIPAGO',
          sysdate
        );
        end;
      end if;
    end loop;
  end;

	-- ------------------------------------------------------------------------------------------------------------------------------------
  procedure cargar_fallecidos as
    m_det_novedad integer;
  begin
    -- recojer los fallecidos de dichos lotes
    for fallecidos in (select b.id_novedad_fallecido, a.*
                       from suirplus.suir_ciudadano_fallecido_mv a
                       join suirplus.sre_novedades_fallecidos_t b
                         on b.nro_lote=a.n_num_control
                        and b.status='N'
                       where dbms_lob.getlength(a.b_imagen_acta_defuncion) > 0)
    loop
      Begin
        select nvl(max(df.id_det_novedad_fallecido),0)+1
        into m_det_novedad
        from sre_det_novedades_fallecidos_t df;

        insert into suirplus.sre_det_novedades_fallecidos_t (
          ID_DET_NOVEDAD_FALLECIDO,
          ID_NOVEDAD_FALLECIDO,
          TIPO_ENTIDAD_NOTIFICACION,
          ENTIDAD_NOTIFICACION,
          ID_REGISTRO,
          TIPO_NOVEDAD,
          ID_NSS,
          NUM_CEDULA,
          FECHA_DEFUNCION,
          IMAGEN_ACTA_DEFUNCION,
          TIPO_IMAGEN_ACTA_DEFUNCION,
          ESTADO_ID,
          FECHA_ACTUALIZACION,
          STATUS,
          MOTIVO_ID,
          ULT_USUARIO_ACT,
          ULT_FECHA_ACT
        ) values (
          m_det_novedad,
          fallecidos.id_novedad_fallecido,
          fallecidos.n_tipo_entidad_notificacion,
          fallecidos.n_entidad_notificacion,
          fallecidos.n_id_registro,
          fallecidos.c_tipo_novedad,
          fallecidos.n_nss,
          fallecidos.c_num_cedula,
          fallecidos.d_fecha_defuncion,
          fallecidos.b_imagen_acta_defuncion,
          fallecidos.c_tipo_imagen_acta_defuncion,
          fallecidos.n_estado_id,
          fallecidos.d_fecha_actualizacion,
          'N',
          null,
          'UNIPAGO',
          sysdate
        );
       Exception when others then
         v_errores := v_errores||'<br>'||fallecidos.n_num_control||'-'||fallecidos.n_nss||':'||sqlerrm;
       End;
    end loop;
  end;

  -- ------------------------------------------------------------------------------------------------------------------------------------
  procedure evaluar_fallecidos as
    v_conteo  integer;
    m_ok      integer;
    m_re      integer;
    v_id_motivo suirplus.sre_motivos_fallecidos_t.id_motivo%type;
  begin
   for lotes in (select a.id_novedad_fallecido, a.nro_lote, count(b.id_novedad_fallecido) registros
                 from suirplus.sre_novedades_fallecidos_t a
                 join suirplus.sre_det_novedades_fallecidos_t b
                   on a.id_novedad_fallecido=b.id_novedad_fallecido
                  and b.status='N'
                 group by a.id_novedad_fallecido,a.nro_lote)
   loop
     for fallecidos in (select a.rowid id, a.*
                        from suirplus.sre_det_novedades_fallecidos_t a
                        where a.id_novedad_fallecido=lotes.id_novedad_fallecido
                          and a.status='N')
     loop
       begin
        v_id_motivo := 0; --Aceptado

        if NOT sre_trabajador_pkg.isexisteidnss(fallecidos.id_nss) then
          v_id_motivo := 1; --Ciudadano no Existe
        end if;

        if v_id_motivo = 0 then
          select count(*) into v_conteo
          from suirplus.sre_det_novedades_fallecidos_t a
          where a.ID_NOVEDAD_FALLECIDO     = fallecidos.ID_NOVEDAD_FALLECIDO
            and a.TIPO_ENTIDAD_NOTIFICACION= fallecidos.TIPO_ENTIDAD_NOTIFICACION
            and a.ENTIDAD_NOTIFICACION     = fallecidos.ENTIDAD_NOTIFICACION
            and a.TIPO_NOVEDAD             = fallecidos.TIPO_NOVEDAD
            and a.ID_NSS                   = fallecidos.ID_NSS;

          if (v_conteo > 1) then
            v_id_motivo := 2; --Envío duplicado
          else
            --Para saber si está previamente fallecido
            Select count(c.id_nss)
            Into v_conteo
            From sre_ciudadanos_t c
            Where c.id_nss               = fallecidos.ID_NSS
              And c.id_causa_inhabilidad = 2
              And c.tipo_causa           = 'C';

            if (v_conteo > 1) then
              v_id_motivo := 2; --lo tratamos como "Envío duplicado"
            end if;
          end if;
        end if;

        update suirplus.sre_det_novedades_fallecidos_t x
        set x.status = decode(v_id_motivo,0,'PE','RE'),
            x.motivo_id = v_id_motivo,
            x.ult_fecha_act = sysdate
        where x.id_det_novedad_fallecido = fallecidos.id_det_novedad_fallecido;
        commit;
      exception when others then
        v_errores := v_errores||'<br>'||lotes.nro_lote||'-'||fallecidos.id_nss||':'||sqlerrm;
      end;
   end loop;

   -- obtener el total de registros aceptados, rechazados y pendientes
   for r in (select sum(decode(a.motivo_id,0,1,0)) e0,
                    sum(decode(a.motivo_id,1,1,0)) e1,
                    sum(decode(a.motivo_id,2,1,0)) e2
             from suirplus.sre_det_novedades_fallecidos_t a
             where a.id_novedad_fallecido=lotes.id_novedad_fallecido)
    loop
      html_add('<tr>');
      html_add('<td>'||lotes.nro_lote||'</td>');
      html_add('<td align=center>'||lotes.registros||'</td>');
      html_add(replace('<td align=center <font color="green">'||r.e0||'</font></td>','>0<','>&nbsp;<'));
      html_add(replace('<td align=center><font color="red">'  ||r.e1||'</font></td>','>0<','>&nbsp;<'));
      html_add(replace('<td align=center><font color="red">'  ||r.e2||'</font></td>','>0<','>&nbsp;<'));
      html_add('</tr>');
    end loop;

    -- obtener el total de registros aceptados, rechazados y pendientes
    select sum(decode(a.status,'PE',1,0)),
           sum(decode(a.status,'RE',1,0))
    into m_ok, m_re
    from suirplus.sre_det_novedades_fallecidos_t a
    where a.id_novedad_fallecido=lotes.id_novedad_fallecido;

    --actualizar el resultado del lote
    update suirplus.sre_novedades_fallecidos_t a
    set a.registros_ok    = m_ok,
        a.registros_err   = m_re,
        a.ult_usuario_act = 'UNIPAGO',
        a.ult_fecha_act   = sysdate,
        a.status          ='P'
    where a.id_novedad_fallecido=lotes.id_novedad_fallecido;
   end loop;
  end;

  --------------------------------------------------------------------------------------------------------------------
  procedure procesar as
   v_id_bitacora  suirplus.sfc_bitacora_t.id_bitacora%type;
  begin
    -- Insetamos el registro en la bitacora
    BITACORA(v_id_bitacora, 'INI', 'PF');
    
    select p.lista_ok,p.lista_error
    into c_mail_to,c_mail_error
    from sfc_procesos_t p
    where p.id_proceso = 'PF';
  
    v_errores := '';
	  dbms_lob.createtemporary(v_html,TRUE);
 	  dbms_lob.open(v_html, dbms_lob.lob_readwrite);

    html_add('<html><head><title>sample</title><STYLE TYPE="text/css"><!--.smallfont {font-size:9pt;}--></STYLE></head><body>');
    html_add('<table border="1" cellpadding=3 cellspacing=0 CLASS="smallfont" style="border-collapse: collapse">');
    html_add(' <tr bgcolor=#E0E0E0>');
    html_add('  <th rowspan=2><br>Lote</th>');
    html_add('  <th rowspan=2><br>Registros</th>');
    html_add('  <th rowspan=2><br>OK</th>');
    html_add('  <th colspan=2 align=center>Rechazados</th>');
    html_add(' </tr>');
    html_add(' <tr bgcolor=#E0E0E0>');
    html_add('  <th>1</th>');
    html_add('  <th>2</th>');
    html_add(' </tr>');
    begin
      refrescar_vista;
      cargar_lotes;
      cargar_fallecidos;
      evaluar_fallecidos;
      commit;
      -- Grabamos en bitacora el resultado de la corrida
      BITACORA(v_id_bitacora, 'FIN', 'PF', 'OK.', 'O', '000');
    exception when others then
      rollback;
      v_errores := v_errores||'<br>'||sqlerrm;
    
      -- Grabamos en bitacora el resultado de la corrida
      BITACORA(v_id_bitacora, 'FIN', 'PF', SUBSTR(SQLERRM,1,200), 'E', '650');
    end;
    html_add('</table>');

    if length(v_errores)>0 then
      html_add('<font size=1><b>Errores encontrados durante la carga</b>');
      html_add(v_errores);
      html_add('</font>');
    end if;
    html_add('</body></html>');

    if length(v_errores)>0 then
      SYSTEM.Html_Mail(
        p_sender    => 'info@tss2.gov.do',
        p_recipient => c_mail_error,
        p_subject   => 'Error en Procesamento de Lotes de fallecidos'||trunc(sysdate),
        p_message   => v_html
      );
    else
      SYSTEM.Html_Mail(
        p_sender    => 'info@tss2.gov.do',
        p_recipient => c_mail_to,
        p_subject   => 'Procesamento de Lotes de fallecidos '||trunc(sysdate),
        p_message   => v_html
      );
    end if;
		dbms_lob.freetemporary(v_html);
  exception when others then
    -- Grabamos en bitacora el resultado de la corrida
    BITACORA(v_id_bitacora, 'FIN', 'PF', SUBSTR(SQLERRM,1,200), 'E', '650');

    system.html_mail('info@mail.tss2.gov.do',c_mail_error,'Error al procesar novedades fallecidos',sqlerrm);    
  end;

  --------------------------------------------------------------------------------------------------------------------------------------
  -- Autor: Yacell Borges
  -- Fecha: 5/7/2012
  -- Descripcion: Busca los datos de los ciudadanos para la evaluacion visual
  --------------------------------------------------------------------------------------------------------------------------------------
  procedure getDatosCiudadanos (p_iocursor     in out t_cursor,
                                p_resultnumber out varchar2) is
  v_bderror varchar2(2000);
  BEGIN
    OPEN p_iocursor FOR
        SELECT d.id_det_novedad_fallecido,
               c.id_nss,
               c.no_documento,
               c.nombres,
               c.primer_apellido,
               c.segundo_apellido,
               c.sexo,
               c.nombre_padre,
               c.nombre_madre,
               c.id_tipo_sangre,
               c.fecha_nacimiento,
               c.municipio_acta,
               c.ano_acta,
               c.numero_acta,
               c.folio_acta,
               c.libro_acta,
               c.oficialia_acta,
               d.imagen_acta_defuncion,
               d.fecha_defuncion
         FROM SRE_CIUDADANOS_T c, sre_det_novedades_fallecidos_t d
        where d.status = 'PE'
          and d.motivo_id = 0
          and c.id_nss = d.id_nss;

    p_resultnumber := 0;
  EXCEPTION WHEN OTHERS THEN
    v_bderror := (SUBSTR('error '||TO_CHAR(SQLCODE)||': '||SQLERRM, 1, 255));
    p_resultnumber := Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
  end;

  --------------------------------------------------------------------------------------------------------------------------------------
  -- Autor: Yacell Borges
  -- Fecha: 5/7/2012
  -- Descripcion: Busca los motivos de rechazo de un fallecimiento en la tabla sre_motivos_fallecidos_t
  --------------------------------------------------------------------------------------------------------------------------------------
  procedure getMotivoRechazo(p_iocursor  in out t_cursor,
                             p_resultnumber out Varchar2) is
    v_bderror varchar2(2000);
  begin
    open p_iocursor for
    select m.id_motivo, m.descripcion
      from sre_motivos_fallecidos_t m
      where m.id_motivo > 0 and m.status = 'A'
     order by m.descripcion desc;
    p_resultnumber:=0;

  exception when others then
    v_bderror := (SUBSTR('error '||TO_CHAR(SQLCODE)||': '||SQLERRM, 1, 255));
    p_resultnumber := Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
  end;
  
  --------------------------------------------------------------------------------------------------------------------------------------
  -- Autor: Yacell Borges
  -- Fecha: 5/7/2012
  -- Descripcion: Rechaza la evaluacion de un fallecido cambiandole el estatus a 'R'
  --------------------------------------------------------------------------------------------------------------------------------------
  procedure RechazarEvaluacion (p_Novedad in sre_det_novedades_fallecidos_t.id_det_novedad_fallecido%type,
                                p_motivo in varchar2,
                                p_usuario in sre_det_novedades_fallecidos_t.ult_usuario_act%type,
                                p_resultnumber out varchar2) is
  begin
    if  p_motivo = '0'  then
      --Actualiza el estatus en el detalle del fallecimiento como Procesado = 'OK'
      update suirplus.sre_det_novedades_fallecidos_t s
      set s.status = 'OK',
       s.motivo_id = p_motivo, s.ult_usuario_act = p_usuario, s.ult_fecha_act = sysdate
      where s.id_det_novedad_fallecido = p_Novedad;
      P_resultnumber:=0;
      commit;
    else
      --Cambia el Estatus del registro Como Rechazado = 'RE'
      update suirplus.sre_det_novedades_fallecidos_t d
         set d.status = 'RE',
             d.motivo_id = p_motivo, d.ult_usuario_act = p_usuario, d.ult_fecha_act = sysdate
       where d.id_det_novedad_fallecido = p_Novedad;
      P_resultnumber:=0;
    end if;
  End;
  
  --------------------------------------------------------------------------------------------------------------------------------------
  -- Autor: Yacell Borges
  -- Fecha: 5/7/2012
  -- Descripcion: Actualiza los datos del ciudadano fallecido con los datos de la evaluacion visual.
  -------------------------------------------------------------------------------------------------------------------------------------
  Procedure ActualizarCiudadano(p_Novedad in sre_det_novedades_fallecidos_t.id_det_novedad_fallecido%type,
                                p_usuario in sre_det_novedades_fallecidos_t.ult_usuario_act%type,
                                P_resultnumber out varchar2) is
  Begin
    for i in (select l.*
              from sre_det_novedades_fallecidos_t l
              where l.id_det_novedad_fallecido = p_Novedad
                and l.status = 'PE') loop

      --Actualiza los registro del ciudadano con los datos de la Evaluación Visual
      update suirplus.sre_ciudadanos_t c
      set
        ID_CAUSA_INHABILIDAD  = 2,
        TIPO_CAUSA            = 'C',
        FECHA_CANCELACION_TSS = sysdate,
        FECHA_FALLECIMIENTO   = i.fecha_defuncion,
        ULT_FECHA_ACT         = sysdate,        
        ULT_USUARIO_ACT       = p_usuario
      where id_nss = i.id_nss;
      commit;
      sre_ciudadano_pkg.Insertar_Ciudadano_Cancelado(null, i.id_nss, 'C', 2, sysdate, p_usuario);
    end loop;

    --Cambia el Estatus del registro como procesado = 'OK'
    update suirplus.sre_det_novedades_fallecidos_t d
    set d.status = 'OK', d.motivo_id = 0, d.ult_usuario_act = p_usuario, d.ult_fecha_act = sysdate
    where d.id_det_novedad_fallecido = p_Novedad;

    P_resultnumber:=0;
    commit;
  End;
 
end SRE_NOVEDADES_FALLECIDOS_PKG;