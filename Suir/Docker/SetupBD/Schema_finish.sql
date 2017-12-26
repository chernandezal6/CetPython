set define off

CREATE OR REPLACE PROCEDURE SYSTEM.text_Mail ( p_sender    IN VARCHAR2,
   p_recipient IN LONG,
   p_subject   IN VARCHAR2,
   p_message   CLOB)
  AS
     l_mailhost VARCHAR2(255) := 'prius'; --172.16.5.2';
     l_temp     CLOB;
     l_mail_conn utl_smtp.connection;
     g_crlf CHAR(2) DEFAULT CHR(13)||CHR(10);
     l_offset        NUMBER;
     l_ammount       NUMBER;
     v_inicio NUMBER := 1;
     v_ultimo NUMBER;
     m_id integer;
  BEGIN
    --primero guardamos el registro
    insert into suirplus.html_mail_t (
      id, create_date, sender, recipient, subject, message, message_type
    ) values (
      suirplus.html_mail_seq.nextval, sysdate, p_sender, p_recipient, p_subject, p_message, 'T'
    ) returning id into m_id;
    begin
      commit;
    exception when others then
      null;
    end;  
 /* 
    l_mail_conn := utl_smtp.open_connection(l_mailhost, 25);
    utl_smtp.helo(l_mail_conn, l_mailhost);
    utl_smtp.mail(l_mail_conn, p_sender);

-- Para enviar a multiples direcciones de e-mail
    FOR i IN 1 .. LENGTH(p_recipient)
    LOOP
      IF SUBSTR(p_recipient,i,1) IN (',',';') THEN
        utl_smtp.rcpt(l_mail_conn, SUBSTR(p_recipient, v_inicio,i-v_inicio));
        v_inicio := i+1;
        v_ultimo := i+1;
      END IF;
    END LOOP;
    IF v_inicio  = 1 THEN
       utl_smtp.rcpt(l_mail_conn, p_recipient);
    ELSE
       utl_smtp.rcpt(l_mail_conn, SUBSTR(p_recipient, v_ultimo));
    END IF;

    utl_smtp.open_data(l_mail_conn );

    utl_smtp.write_data(l_mail_conn, 'From: ' ||p_sender||g_crlf );
    utl_smtp.write_data(l_mail_conn, 'To: ' ||p_recipient||g_crlf );
    utl_smtp.write_data(l_mail_conn, 'Subject: ' ||p_subject||g_crlf );

    -- Write the HTML boundary
    --l_temp   := 'content-type: text/html;' ||
    --            CHR(13) || CHR(10) || CHR(13) || CHR(10)||p_message;
    l_temp   := p_message;
    l_offset  := 1;
    l_ammount := 1900;

    WHILE l_offset < dbms_lob.getlength(l_temp) LOOP
        utl_smtp.write_data(l_mail_conn,
                            dbms_lob.SUBSTR(l_temp,l_ammount,l_offset));
        l_offset  := l_offset + l_ammount ;
        l_ammount := LEAST(1900,dbms_lob.getlength(l_temp) - l_ammount);
    END LOOP;

    utl_smtp.close_data(l_mail_conn);
    utl_smtp.quit(l_mail_conn);
    dbms_lob.freetemporary(l_temp);
    
    --si no da error lo marcamos como procesado
    update suirplus.html_mail_t
    set status='P',
        send_date=sysdate
    where id = m_id;
    begin
      commit;
    exception when others then
      null;
    end;*/
END; 

/

CREATE OR REPLACE PROCEDURE SYSTEM.Html_Mail ( p_sender    IN VARCHAR2,
   p_recipient IN LONG,
   p_subject   IN VARCHAR2,
   p_message   CLOB)
  AS
     l_mailhost VARCHAR2(255) := '172.16.5.2';
     l_temp     CLOB;
     l_mail_conn utl_smtp.connection;
     g_crlf CHAR(2) DEFAULT CHR(13)||CHR(10);
     l_offset        NUMBER;
     l_ammount       NUMBER;
     v_inicio NUMBER := 1;
     v_ultimo NUMBER;

     db varchar2(100) := 'DESARROLLO';

     m_id integer;
BEGIN
  --primero guardamos el registro
  insert into suirplus.html_mail_t (
    id, create_date, sender, recipient, subject, message, message_type
  ) values (
    suirplus.html_mail_seq.nextval, sysdate, p_sender, p_recipient, p_subject, p_message, 'H'
  ) returning id into m_id;
  begin
    commit;
  exception when others then
    null;
  end;

 /* if (p_sender is not null and p_recipient is not null) then
    begin

    l_mail_conn := utl_smtp.open_connection(l_mailhost, 25);
    utl_smtp.helo(l_mail_conn, l_mailhost);
    utl_smtp.mail(l_mail_conn, p_sender);

  -- Para enviar a multiples direcciones de e-mail
      FOR i IN 1 .. LENGTH(p_recipient)
      LOOP
        IF SUBSTR(p_recipient,i,1) IN (',',';') THEN
          utl_smtp.rcpt(l_mail_conn, SUBSTR(p_recipient, v_inicio,i-v_inicio));
          v_inicio := i+1;
          v_ultimo := i+1;
        END IF;
      END LOOP;
      IF v_inicio  = 1 THEN
         utl_smtp.rcpt(l_mail_conn, p_recipient);
      ELSE
         utl_smtp.rcpt(l_mail_conn, SUBSTR(p_recipient, v_ultimo));
      END IF;

      utl_smtp.open_data(l_mail_conn );

      utl_smtp.write_data(l_mail_conn, 'From: ' ||p_sender||g_crlf );
      utl_smtp.write_data(l_mail_conn, 'To: ' ||p_recipient||g_crlf );
      if (upper(db)='PRODUCCION') then
        utl_smtp.write_data(l_mail_conn, 'Subject: ' ||p_subject||g_crlf );
      else
        utl_smtp.write_data(l_mail_conn, 'Subject: ' ||p_subject||' ('||db||')'||g_crlf );
      end if;

      -- Write the HTML boundary
      l_temp   := 'content-type: text/html;' ||
                   CHR(13) || CHR(10) || CHR(13) || CHR(10)||p_message;
      l_offset  := 1;
      l_ammount := 1900;

      WHILE l_offset < dbms_lob.getlength(l_temp) LOOP
          utl_smtp.write_data(l_mail_conn,
                              dbms_lob.SUBSTR(l_temp,l_ammount,l_offset));
          l_offset  := l_offset + l_ammount ;
          l_ammount := LEAST(1900,dbms_lob.getlength(l_temp) - l_ammount);
      END LOOP;

      utl_smtp.close_data(l_mail_conn);
      utl_smtp.quit(l_mail_conn);
      dbms_lob.freetemporary(l_temp);

      --si no da error lo marcamos como procesado
      update suirplus.html_mail_t
      set status='P',
          send_date=sysdate
      where id = m_id;
      begin
        commit;
      exception when others then
        null;
      end;
    exception when others then
      --si da error, no hacemos nada y se quedara como no procesado
      null;
    end;
  end if;*/
END;
/

CREATE OR REPLACE PACKAGE  SYSTEM.SENDMAIL_PKG IS
  TYPE ATTACHMENTS_LIST IS TABLE OF VARCHAR2(4000);

  procedure send_email (
    p_recipient       varchar2,
    p_subject         varchar2,
    p_mensaje         varchar2,
    p_sender          varchar2,
    p_attachments     ATTACHMENTS_LIST default null,
    p_cc              varchar2  default null,
    pmensaje_retorno  OUT varchar2,
    pnumero_retorno   OUT number,
    pvalidar_attachment varchar2  default 'N'
  );
END SENDMAIL_PKG;
/

CREATE OR REPLACE PACKAGE BODY SYSTEM.SENDMAIL_PKG IS
  -- Implementa los procedures para envio de mensajes
  procedure send_email (
    p_recipient       varchar2,
    p_subject         varchar2,
    p_mensaje         varchar2,
    p_sender          varchar2,
    p_attachments     ATTACHMENTS_LIST default null,
    p_cc              varchar2 default null,
    pmensaje_retorno  OUT varchar2,
    pnumero_retorno   OUT number,
    pvalidar_attachment  varchar2  default 'N'
  ) IS
  /*
     programador: m.marenco
  */
    conn            utl_smtp.connection;
    in_file         utl_file.FILE_TYPE;
    linebuf         varchar2(2000);
    email_host      varchar2(25) := '172.16.5.2';
    email_port      PLS_INTEGER  := 25;
    --
    v_ruta         all_directories.directory_name%type;
    v_path         all_directories.directory_path%type;
    v_filename     varchar2(100);
    vattachment_ok boolean;
    m_id           integer;
    v_message_type  suirplus.html_mail_t.message_type%type;

    --
    FUNCTION get_local_binary_data (
        p_dir                      IN       VARCHAR2,
        p_file                     IN       VARCHAR2 )
        RETURN BLOB
     IS
     -- --------------------------------------------------------------------------
        l_bfile                       BFILE;
        l_data                        BLOB;
        l_dbdir                       VARCHAR2 ( 100 ) := p_dir;
     BEGIN
        dbms_lob.createtemporary ( lob_loc =>                       l_data,
                                  CACHE =>                         TRUE,
                                  dur =>                           dbms_lob.CALL );
        l_bfile := BFILENAME ( l_dbdir, p_file );
        dbms_lob.fileopen ( l_bfile, dbms_lob.file_readonly );
        dbms_lob.loadfromfile ( l_data,
                               l_bfile,
                               dbms_lob.getlength ( l_bfile ));
        dbms_lob.fileclose ( l_bfile );
        RETURN l_data;
     EXCEPTION
        WHEN OTHERS
        THEN
           RAISE;
     END get_local_binary_data;
  BEGIN
    --
    if p_attachments is not null and p_attachments.count > 0 then
      /* Abre los archivos attachment */
      begin
        for i in p_attachments.first .. p_attachments.last loop
          if p_attachments(i) is not null and upper(substr(p_attachments(i),length(p_attachments(i))-3)) IN ('.TXT', '.SQL', '.CSV', '.ASC', '.BAT', '.RAR', '.PDF', '.XML') then
            /* Abre el archivo ASCII */
            v_path := TRIM(lower(substr(p_attachments(i), 1, instr(p_attachments(i),'/',-1)-1)));

            Select d.directory_name
            Into v_ruta
            From all_directories d
            Where lower(d.directory_path) = v_path;

            v_filename := substr(p_attachments(i), instr(p_attachments(i),'/',-1)+1, length(p_attachments(i)));
           -- in_file    := utl_file.fopen(v_ruta, v_filename, 'r');
          end if;
        end loop;
        vattachment_ok := TRUE;
      exception
          when others then
          pmensaje_retorno := 'SEND_EMAIL_ATTCH1: ' || sqlerrm ;
        pnumero_retorno  := -1;
        dbms_output.put_line (pmensaje_retorno);
        /*  vattachment_ok := FALSE;
          if pvalidar_attachment = 'S' then
            raise_application_error(-20125, 'ERROR: No se pudo abrir archivo indicado como attachment.');
          end if; */
      end;
    else
      vattachment_ok := FALSE;
    end if;
    --
/*    conn := mail_helper_pkg.begin_mail(
      sender     => p_sender,
      recipients => p_recipient,
      cc         => p_cc,
      subject    => p_subject,
      mime_type  => mail_helper_pkg.MULTIPART_MIME_TYPE,
      host       => email_host,
      port       => email_port,
      domain     => email_host);

    --
    mail_helper_pkg.attach_text(
      conn      => conn,
      data      => p_mensaje,
      mime_type => 'text/html');
   dbms_output.put_line('ATT');*/
   --

   -- Verificamos si el contenido es texto o html

   if p_mensaje is not null then
    if regexp_instr(p_mensaje, '<.*?>')> 0 then
       v_message_type := 'H';
     else
       v_message_type := 'T';
     end if;
 end if;

   --primero guardamos el registro en la cabezera
   insert into suirplus.html_mail_t (
    id, create_date, sender, recipient, carboncopy, subject, message, message_type
   ) values (
    suirplus.html_mail_seq.nextval, sysdate, p_sender, p_recipient, p_cc, p_subject, p_mensaje, v_message_type
   ) returning id into m_id;
   begin
    commit;
   exception when others then
    null;
   end;

   --
    /**********************/
    /* Seccion Attachment */
    /**********************/
    if vattachment_ok then
      for i in p_attachments.first .. p_attachments.last loop
        if p_attachments(i) is not null then
          v_path := TRIM(lower(substr(p_attachments(i), 1, instr(p_attachments(i),'/',-1)-1)));

          Select d.directory_name
          Into v_ruta
          From all_directories d
          Where lower(d.directory_path) = v_path;

          v_filename := substr(p_attachments(i), instr(p_attachments(i),'/',-1)+1, length(p_attachments(i)));

          declare
            v_data BLOB;
          begin
            v_data := get_local_binary_data(v_ruta, v_filename);

            --Atacha el archivo al correo
            --mail_helper_pkg.attach_base64(conn => conn, data => v_data, mime_type => 'application/octet', inline => FALSE, filename => v_filename, last => FALSE);

            --guardamos el registro en el detalle de la tabla
            insert into suirplus.html_mail_det_t (
             id, id_det, file_name, file_content
            ) values (
             m_id, suirplus.html_mail_det_seq.nextval, v_filename, v_data
            );
            begin
             commit;
            exception when others then
             null;
            end;
          end;

end if;
      end loop;
      --
    end if;  --  Si vattachment_ok = TRUE
    /**************************/
    /* Fin Seccion Attachment */
    /**************************/
    --
   -- mail_helper_pkg.end_mail( conn => conn );
    --

    --si no da error lo marcamos como procesado
 /*   update suirplus.html_mail_t
    set status='P',
        send_date=sysdate
    where id = m_id;
    begin
      commit;
    exception when others then
      null;
    end;
  EXCEPTION
    WHEN utl_smtp.transient_error OR utl_smtp.permanent_error THEN
      mail_helper_pkg.end_mail( conn => conn );
      pmensaje_retorno := 'Send_email_attch: ' || sqlerrm;
      pnumero_retorno  := -1;
      dbms_output.put_line (pmensaje_retorno);
    when others then
      pmensaje_retorno := 'SEND_EMAIL_ATTCH: ' || sqlerrm;
      pnumero_retorno  := -1;
      dbms_output.put_line (pmensaje_retorno);
  END; -- Procedure SEND_EMAIL_ATTACHMENT
  Procedure SEND_EMAIL  (
    p_recipient          varchar2,
    p_subject            varchar2,
    p_mensaje            varchar2,
    p_sender             varchar2,
    pmensaje_retorno OUT varchar2,
    p_cc                 varchar2  default null
  ) IS

    --- PROGRAMADOR:    Carlos Joa

    c_timezone    constant varchar2(10) := '-0400';
    c             utl_smtp.connection;
    v_sender      varchar2(100);
    v_rcpt        varchar2(100);
    v_cc          varchar2(100);
    v_smtp_client varchar2(100);
    v_smtp_server varchar2(100);
    resp          utl_smtp.reply;
    resps         utl_smtp.replies;
    procedure parse_email_addr(email_addr IN  varchar2,
                               username   OUT varchar2,
                               hostname   OUT varchar2) is
      i    pls_integer;
    begin
      i := nvl(instr(email_addr, '@', 1), 0);
      if (i > 0) then
        if (i-i > 100 or length(email_addr)-i > 100) then
           raise_application_error(-20117,
              'NOT_SEND_EMAIL_P: direccion email <' || email_addr || '> excede capacidad del string declarado');
        end if;
        username := substr(email_addr, 1, i-1);
        hostname := substr(email_addr, i+1);
      else
        raise_application_error(-20117,
           'NOT_SEND_EMAIL_P: direccion email <' || email_addr || '> no contiene simbolo @');
      end if;
      if username is null then
         raise_application_error(-20115,
            'NOT_SEND_EMAIL_P: direccion email <' || email_addr || '> no especifica el usuario.');
      end if;
      if hostname is null then
         raise_application_error(-20116,
            'NOT_SEND_EMAIL_P: direccion email <' || email_addr || '> no especifica el hostname.');
      end if;
    end;
  BEGIN
    dbms_output.put_line('Inicio');
    --
    parse_email_addr(p_sender,    v_sender, v_smtp_client);
    parse_email_addr(p_recipient, v_rcpt,   v_smtp_server);
    --
    dbms_output.put_line('<Inicio> ');
    --
    resp := utl_smtp.open_connection(mail_helper_pkg.smtp_host, mail_helper_pkg.smtp_port, c);
    dbms_output.put_line('open_connection Reply> '||to_char(resp.code)||':'||substr(resp.text,1,100));
    --
    resps := utl_smtp.ehlo(c, v_smtp_client);
    for i in 1..resps.last loop
      dbms_output.put_line('Helo Reply <'||to_char(i)||'> '||to_char(resps(i).code)||':'||substr(resps(i).text,1,100));
    end loop;
    --
    resp := utl_smtp.mail(c, p_sender);
    dbms_output.put_line('Mail Reply> '||to_char(resp.code)||':'||substr(resp.text,1,100));
    --

    resp := utl_smtp.rcpt(c, p_recipient);
    dbms_output.put_line('Rcpt Reply> '||to_char(resp.code)||':'||substr(resp.text,1,100));
    --
    if p_cc is not null then
      resp := utl_smtp.rcpt(c, p_cc);
      v_cc := 'Cc: <'     || p_cc || '>' || utl_tcp.CRLF;
      dbms_output.put_line('Rcpt Reply> '||to_char(resp.code)||':'||substr(resp.text,1,100));
    else
      v_cc := null;
    end if;
    --
    resp := utl_smtp.open_data(c);
    dbms_output.put_line('Open_Data Reply> '||to_char(resp.code)||':'||substr(resp.text,1,100));
    --
    utl_smtp.write_data(c, 'From: <'   || p_sender || '>'      || utl_tcp.CRLF ||
                           'To: <'     || p_recipient || '>' || utl_tcp.CRLF ||
                           v_cc||
                           'Date: '    || to_char(sysdate, 'Dy, DD Mon YYYY HH24:MI:SS')
                                       || ' ' || c_timezone || utl_tcp.CRLF ||
                           'Subject: ' || p_subject                || utl_tcp.CRLF ||
                           utl_tcp.CRLF);
    utl_smtp.write_data(c, p_mensaje);
    resp := utl_smtp.close_data(c);
    dbms_output.put_line('Close_Data Reply> '||to_char(resp.code)||':'||substr(resp.text,1,100));
    --
    utl_smtp.quit(c);
    dbms_output.put_line('Lo envie');
  EXCEPTION
    WHEN utl_smtp.transient_error OR utl_smtp.permanent_error THEN
      utl_smtp.quit(c);
      pmensaje_retorno := 'SEND_EMAIL: ' || sqlerrm;
    when others then
      pmensaje_retorno := 'SEND_EMAIL: ' || sqlerrm;
 */ END; -- Procedure SEND_EMAIL

END SENDMAIL_PKG; 
/

CREATE OR REPLACE PROCEDURE SYSTEM.ENVIA_EMAIL  (sender_p        IN VARCHAR2,
                             recipient_p     IN VARCHAR2,
                             ccrecipient_p   IN VARCHAR2,
                             bccrecipient_p  IN VARCHAR2,
                             subject_p       IN VARCHAR2,
                             body_p          IN VARCHAR2,
                             despedida_p     IN VARCHAR2,
                             attachment1_p   IN VARCHAR2,
                             attachment2_p   IN VARCHAR2,
                             errormessage_p OUT VARCHAR2,
                             errorstatus_p  OUT VARCHAR2) IS
ErrorMessage            VARCHAR2(4000);
ErrorStatus             NUMBER;
-- MODIFICATION HISTORY
-- Person           Date        Comments
-- ---------        ----------  -------------------------------------------
-- Celso Ramirez    31/01/2003  Procedimiento Almacenado Para el envio de Emails.
-- Gregorio Herrera 02/11/2009  Descartar la llamada al programa JAVA para enviar Emails.
BEGIN
   sendmail_pkg.send_email(
                   p_recipient => recipient_p,
                   p_subject => subject_p,
                   p_mensaje => body_p || utl_tcp.CRLF ||' '|| utl_tcp.CRLF || despedida_p,
                   p_sender => sender_p,
                   p_attachments => sendmail_pkg.ATTACHMENTS_LIST(attachment1_p,attachment2_p),
                   p_cc => ccrecipient_p,
                   pmensaje_retorno => ErrorMessage,
                   pnumero_retorno => ErrorStatus,
                   pvalidar_attachment => 'S'
                   );

/*
   ErrorStatus := Sendmailjpkg.SendMail(
                SMTPServerName => '172.16.5.8',
                Sender    => sender_p,
                Recipient => recipient_p,
                CcRecipient => ccrecipient_p,
                BccRecipient => bccrecipient_p,
                Subject   => subject_p,
                BODY => body_p || Sendmailjpkg.EOL || ' '||Sendmailjpkg.EOL || despedida_p,
                ErrorMessage => ErrorMessage,
                Attachments  => Sendmailjpkg.ATTACHMENTS_LIST(attachment1_p,attachment2_p)
    );
*/
   Errormessage_p := errormessage;
   Errorstatus_p  := errorstatus;
END;
/

DECLARE
  SnapArray SYS.DBMS_UTILITY.UNCL_ARRAY;
BEGIN
  SnapArray(1) := 'SUIRPLUS.TSS_DEPENDIENTES_OK_PE_MV';
  SnapArray(2) := 'SUIRPLUS.TSS_TITULARES_ARS_OK_PE_MV';
  SnapArray(3) := NULL;
  SYS.DBMS_REFRESH.MAKE (
    name => 'SUIRPLUS.ARS_TIT_DEP_RG'
    ,tab  => SnapArray
    ,next_date => TO_DATE('01/01/4000 00:00:00', 'MM/DD/YYYY HH24:MI:SS')
    ,interval  => '/*24:Hr*/ sysdate + 24/24'
    ,implicit_destroy => FALSE
    ,lax => TRUE
    ,job => 0
    ,rollback_seg => NULL
    ,push_deferred_rpc => FALSE
    ,refresh_after_errors => FALSE
    ,purge_option => 1
    ,parallelism => 0
    ,heap_size => 0
  );
Commit;
END;
/

DECLARE
  SnapArray SYS.DBMS_UTILITY.UNCL_ARRAY;
BEGIN
  SnapArray(1) := 'SUIRPLUS.DGI_EMPLEADORES_DIARIOS_MV';
  SnapArray(2) := NULL;
  SYS.DBMS_REFRESH.MAKE (
    name => 'SUIRPLUS.DGI_EMPLEADORES_DIARIOS_MV'
    ,tab  => SnapArray
    ,next_date => TO_DATE('11/22/2016 16:33:34', 'MM/DD/YYYY HH24:MI:SS')
    ,interval  => 'SYSDATE + 1 '
    ,implicit_destroy => TRUE
    ,lax => TRUE
    ,job => 0
    ,rollback_seg => NULL
    ,push_deferred_rpc => TRUE
    ,refresh_after_errors => FALSE
    ,purge_option => 1
    ,parallelism => 0
    ,heap_size => 0
  );
Commit;
END;
/

DECLARE
 SnapArray SYS.DBMS_UTILITY.UNCL_ARRAY;
BEGIN
 SnapArray(1) := 'SUIRPLUS.DGI_ACTIVIDADES_ECONOMICAS_MV';
 SnapArray(2) := 'SUIRPLUS.DGI_ADMINISTRACION_LOCAL_MV';
 SnapArray(3) := NULL;
 SYS.DBMS_REFRESH.MAKE (
   name => 'SUIRPLUS.DGII_EMPLEADORES_RG'
   ,tab  => SnapArray
   ,next_date => TO_DATE('01/01/4000 00:00:00', 'MM/DD/YYYY HH24:MI:SS')
   ,interval  => '/*1:Days*/ sysdate + 1'
   ,implicit_destroy => FALSE
   ,lax => TRUE
   ,job => 0
   ,rollback_seg => NULL
   ,push_deferred_rpc => FALSE
   ,refresh_after_errors => FALSE
   ,purge_option => 1
   ,parallelism => 0
   ,heap_size => 0
 );
Commit;
END;
/

DECLARE
  SnapArray SYS.DBMS_UTILITY.UNCL_ARRAY;
BEGIN
  SnapArray(1) := 'SUIRPLUS.DGII_ISR_STATUS_LOCAL_V';
  SnapArray(2) := NULL;
  SYS.DBMS_REFRESH.MAKE (
    name => 'SUIRPLUS.DGII_ISR_STATUS_LOCAL_V'
    ,tab  => SnapArray
    ,next_date => TO_DATE('02/23/2020 11:13:24', 'MM/DD/YYYY HH24:MI:SS')
    ,interval  => NULL
    ,implicit_destroy => TRUE
    ,lax => TRUE
    ,job => 0
    ,rollback_seg => NULL
    ,push_deferred_rpc => TRUE
    ,refresh_after_errors => FALSE
    ,purge_option => 1
    ,parallelism => 0
    ,heap_size => 0
  );
Commit;
END;
/

DECLARE
  SnapArray SYS.DBMS_UTILITY.UNCL_ARRAY;
BEGIN
  SnapArray(1) := 'SUIRPLUS.DGII_PAGOS_IR3_MV';
  SnapArray(2) := NULL;
  SYS.DBMS_REFRESH.MAKE (
    name => 'SUIRPLUS.DGII_PAGOS_IR3_RG'
    ,tab  => SnapArray
    ,next_date => TO_DATE('01/01/4000 00:00:00', 'MM/DD/YYYY HH24:MI:SS')
    ,interval  => '/*24:Hr*/ sysdate + 24/24'
    ,implicit_destroy => FALSE
    ,lax => TRUE
    ,job => 0
    ,rollback_seg => NULL
    ,push_deferred_rpc => FALSE
    ,refresh_after_errors => FALSE
    ,purge_option => 1
    ,parallelism => 0
    ,heap_size => 0
  );
Commit;
END;
/

DECLARE
  SnapArray SYS.DBMS_UTILITY.UNCL_ARRAY;
BEGIN
  SnapArray(1) := 'SUIRPLUS.SFC_PAGOS_DIARIA_MV';
  SnapArray(2) := NULL;
  SYS.DBMS_REFRESH.MAKE (
    name => 'SUIRPLUS.SFC_PAGOS_RG'
    ,tab  => SnapArray
    ,next_date => TO_DATE('02/07/2050 09:00:00', 'MM/DD/YYYY HH24:MI:SS')
    ,interval  => '/*24:Hr*/ sysdate + 24/24'
    ,implicit_destroy => FALSE
    ,lax => TRUE
    ,job => 0
    ,rollback_seg => NULL
    ,push_deferred_rpc => FALSE
    ,refresh_after_errors => FALSE
    ,purge_option => 1
    ,parallelism => 0
    ,heap_size => 0
  );
Commit;
END;
/

DECLARE
  SnapArray SYS.DBMS_UTILITY.UNCL_ARRAY;
BEGIN
  SnapArray(1) := 'SUIRPLUS.SRE_EMPLEADORES_SIPEN_MV';
  SnapArray(2) := 'SUIRPLUS.SRE_TRABAJADORES_SIPEN_MV';
  SnapArray(3) := NULL;
  SYS.DBMS_REFRESH.MAKE (
    name => 'SUIRPLUS.SUIR_SIPEN_RG'
    ,tab  => SnapArray
    ,next_date => TO_DATE('01/01/4000 00:00:00', 'MM/DD/YYYY HH24:MI:SS')
    ,interval  => '/*24:Hr*/ sysdate + 24/24'
    ,implicit_destroy => FALSE
    ,lax => TRUE
    ,job => 0
    ,rollback_seg => NULL
    ,push_deferred_rpc => FALSE
    ,refresh_after_errors => FALSE
    ,purge_option => 1
    ,parallelism => 0
    ,heap_size => 0
  );
Commit;
END;
/

DECLARE
  SnapArray SYS.DBMS_UTILITY.UNCL_ARRAY;
BEGIN
  SnapArray(1) := 'SUIRPLUS.CS_C_RUBROS';
  SnapArray(2) := 'SUIRPLUS.CS_R_ENTRADAS';
  SnapArray(3) := 'SUIRPLUS.SUIR_C_ENTIDAD';
  SnapArray(4) := 'SUIRPLUS.SUIR_C_TIPO_ENTIDAD';
  SnapArray(5) := NULL;
  SYS.DBMS_REFRESH.MAKE (
    name => 'SUIRPLUS.TSS_CONTABILIDAD_RG'
    ,tab  => SnapArray
    ,next_date => TO_DATE('07/25/2182 17:58:24', 'MM/DD/YYYY HH24:MI:SS')
    ,interval  => '/*24:HR*/ SYSDATE + 24/24'
    ,implicit_destroy => FALSE
    ,lax => TRUE
    ,job => 0
    ,rollback_seg => NULL
    ,push_deferred_rpc => FALSE
    ,refresh_after_errors => FALSE
    ,purge_option => 1
    ,parallelism => 0
    ,heap_size => 0
  );
Commit;
END;
/

DECLARE
  SnapArray SYS.DBMS_UTILITY.UNCL_ARRAY;
BEGIN
  SnapArray(1) := 'SUIRPLUS.TSS_SENASA_DEPENDIENTES_MV';
  SnapArray(2) := 'SUIRPLUS.TSS_SENASA_TITULARES_MV';
  SnapArray(3) := NULL;
  SYS.DBMS_REFRESH.MAKE (
    name => 'SUIRPLUS.TSS_SENASA_TIT_DEP_RG'
    ,tab  => SnapArray
    ,next_date => TO_DATE('04/10/2200 12:42:29', 'MM/DD/YYYY HH24:MI:SS')
    ,interval  => 'SYSDATE+7'
    ,implicit_destroy => FALSE
    ,lax => TRUE
    ,job => 0
    ,rollback_seg => NULL
    ,push_deferred_rpc => FALSE
    ,refresh_after_errors => FALSE
    ,purge_option => 1
    ,parallelism => 0
    ,heap_size => 0
  );
Commit;
END;
/

DECLARE
  SnapArray SYS.DBMS_UTILITY.UNCL_ARRAY;
BEGIN
  SnapArray(1) := 'SUIRPLUS.SUIR_R_SOL_ACTA_NAC_MENORES_MV';
  SnapArray(2) := NULL;
  SYS.DBMS_REFRESH.MAKE (
    name => 'SUIRPLUS.TSS_SUIR_ASIG_NSS_RG'
    ,tab  => SnapArray
    ,next_date => TO_DATE('04/10/2200 12:42:29', 'MM/DD/YYYY HH24:MI:SS')
    ,interval  => 'SYSDATE+7'
    ,implicit_destroy => FALSE
    ,lax => TRUE
    ,job => 0
    ,rollback_seg => NULL
    ,push_deferred_rpc => FALSE
    ,refresh_after_errors => FALSE
    ,purge_option => 1
    ,parallelism => 0
    ,heap_size => 0
  );
Commit;
END;
/

DECLARE
  SnapArray SYS.DBMS_UTILITY.UNCL_ARRAY;
BEGIN
  SnapArray(1) := 'UNIPAGO.SRE_MUNICIPIO_MV';
  SnapArray(2) := 'UNIPAGO.SRE_PROVINCIAS_MV';
  SnapArray(3) := 'UNIPAGO.SRE_NACIONALIDAD_MV';
  SnapArray(4) := 'UNIPAGO.SRE_OFICIALIAS_MV';
  SnapArray(5) := 'UNIPAGO.SRE_INHABILIDAD_JCE_MV';
  SnapArray(6) := NULL;
  SYS.DBMS_REFRESH.MAKE (
    name => 'SUIRPLUS.UNIPAGO_RG'
    ,tab  => SnapArray
    ,next_date => TO_DATE('11/23/2016 08:58:17', 'MM/DD/YYYY HH24:MI:SS')
    ,interval  => 'sysdate + 24/24'
    ,implicit_destroy => FALSE
    ,lax => TRUE
    ,job => 0
    ,rollback_seg => NULL
    ,push_deferred_rpc => TRUE
    ,refresh_after_errors => FALSE
    ,purge_option => 1
    ,parallelism => 0
    ,heap_size => 0
  );
Commit;
END;
/

DECLARE
  X NUMBER;
BEGIN
  SYS.DBMS_JOB.SUBMIT
  ( job       => X 
   ,what      => 'lanza_job;'
   ,next_date => to_date('22/11/2016 10:01:17','dd/mm/yyyy hh24:mi:ss')
   ,interval  => '/*3:Secs*/ sysdate + 3/(60*60*24)'
   ,no_parse  => FALSE
  );
  SYS.DBMS_OUTPUT.PUT_LINE('Job Number is: ' || to_char(x));
COMMIT;
END;
/

DECLARE
  X NUMBER;
BEGIN
  SYS.DBMS_JOB.SUBMIT
  ( job       => X 
   ,what      => 'borra_job;'
   ,next_date => to_date('22/11/2016 10:01:36','dd/mm/yyyy hh24:mi:ss')
   ,interval  => '/*5:Secs*/ sysdate + 5/(60*60*24)'
   ,no_parse  => FALSE
  );
  SYS.DBMS_OUTPUT.PUT_LINE('Job Number is: ' || to_char(x));
COMMIT;
END;
/

CREATE OR REPLACE DIRECTORY IMPRESION_FACTURAS as '/archivos_recibidos';
CREATE OR REPLACE DIRECTORY XML_BC as '/archivos_recibidos';
CREATE OR REPLACE DIRECTORY ARCHIVOS as '/archivos_recibidos';
CREATE OR REPLACE DIRECTORY ARCHIVOS_NACHA as '/archivos_recibidos';
CREATE OR REPLACE DIRECTORY ARCHIVOS_PENSIONADOS as '/archivos_recibidos';
CREATE OR REPLACE DIRECTORY ARCHIVOS_RECIBIDOS as '/archivos_recibidos';
CREATE OR REPLACE DIRECTORY ARCHIVOS_RESPUESTAS as '/archivos_recibidos';
CREATE OR REPLACE DIRECTORY ARCHIVOS_SUBSIDIOS as '/archivos_recibidos';
CREATE OR REPLACE DIRECTORY DOCUMENTOS as '/archivos_recibidos';
CREATE OR REPLACE DIRECTORY SRE_LOGS as '/archivos_recibidos';

exit;