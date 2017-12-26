CREATE OR REPLACE PACKAGE BODY SUIRPLUS.srp_procesos_pkg IS
 -- ------------------------------------------------------------------------------------------------------------------------------------
 FUNCTION validar(p_proceso IN VARCHAR2,p_parametros IN VARCHAR2) RETURN VARCHAR2 IS
  v_result CHAR(1);
  v_proceso VARCHAR2(100);
 BEGIN
  SELECT proceso_validar
  INTO v_proceso
  FROM sfc_procesos_t
  WHERE id_proceso=p_proceso;
  BEGIN
   IF LENGTH(NVL(p_parametros,'')||'1')=1 THEN
    EXECUTE IMMEDIATE 'select '||v_proceso||' from dual' INTO v_result;
   ELSE
    EXECUTE IMMEDIATE 'select '||v_proceso||'('|| NVL(p_parametros,'')||') from dual' INTO v_result;
   END IF;
  EXCEPTION WHEN OTHERS THEN
   v_result  := 'N';
  END;
  RETURN(v_result);
 END validar;
 -- ------------------------------------------------------------------------------------------------------------------------------------
 PROCEDURE ejecutar(p_proceso IN VARCHAR2,p_usuario IN VARCHAR2,p_parametros IN VARCHAR2) IS
  v_proceso    VARCHAR2(100);
  v_proximo_job INTEGER;
  v_bitacora INTEGER;
  v_status sfc_bitacora_t.status%TYPE;
  v_id_error sfc_bitacora_t.id_error%TYPE;
 BEGIN
  SELECT SFC_BITACORA_SEQ.NEXTVAL
  INTO v_bitacora
  FROM dual;
  INSERT INTO sfc_bitacora_t (
   ID_PROCESO,ID_BITACORA,FECHA_INICIO,STATUS,ULT_FECHA_ACT,ULT_USUARIO_ACT
  ) VALUES (
   p_proceso ,v_bitacora ,SYSDATE     ,'E'   ,SYSDATE      ,p_usuario
  );
  SELECT lanzador
  INTO v_proceso
  FROM sfc_procesos_t
  WHERE id_proceso=p_proceso;
  SELECT seg_job_seq.NEXTVAL INTO v_proximo_job FROM dual;
  BEGIN
   IF LENGTH(NVL(p_parametros,'')||'1')=1 THEN
    INSERT INTO seg_job_T (ID_JOB,NOMBRE_JOB,STATUS,FECHA_ENVIO)
    VALUES (v_proximo_job,v_proceso||'('||v_proximo_job||');','S',SYSDATE);
   ELSE
    INSERT INTO seg_job_T (ID_JOB,NOMBRE_JOB,STATUS,FECHA_ENVIO)
    VALUES (v_proximo_job,v_proceso||'('||p_parametros||','||v_proximo_job||');','S',SYSDATE);
   END IF;
   v_status := 'P';
   v_id_error := '000';
  EXCEPTION WHEN OTHERS THEN
   v_status := 'E';
   v_id_error := '650';
  END;
  UPDATE sfc_bitacora_t
  SET fecha_fin=SYSDATE,
   id_error=v_id_error,
      status=v_status,
      mensage='JOB# '||v_proximo_job
  WHERE id_bitacora=v_bitacora;
 END ejecutar;
    -- -------------------------------------------------------------------------------------------
    procedure ejecutarFacturacion is
        v_r number;
        v_return  VARCHAR2(1000);
        v_error_seq  number;
        v_proceso char(2) := '22';
        v_status  char(1);
        v_next_job integer;
    begin
      Select to_char(sysdate, 'yyyymm') into v_r
      from dual;
/*      Select valor_texto
      into v_r
      from sfc_det_parametro_t
      where id_parametro = 106;
*/
      begin
        select status
        into v_status
        from sfc_bitacora_t b
        where b.id_bitacora=(
          select max(id_bitacora)
          from sfc_bitacora_t b
          where b.id_proceso=v_proceso
          and b.periodo=v_r
        );
      exception when no_data_found then
        v_status := 'N';
      end;
      if (v_status='N') then
        /*by RJ 06/04/2006*/
    		select seg_job_seq.nextval into v_next_job from dual;
        insert into seg_job_t (
          ID_JOB,NOMBRE_JOB,STATUS,FECHA_ENVIO
        ) values (
          v_next_job,'srp_procesos.job_facturacion('||v_next_job||','||v_r||');','S',sysdate
        );
        --v_result := sfc_mes_fac_liq_ordinaria_f(
        --  p_return          => v_return,
        --  p_error_seq       => v_error_seq,
        --  p_periodo_factura => v_r
        --);
        /*end RJ 06/04/2006*/
      elsif (v_status='P') then
        v_error_seq := 650;

        v_return    := 'El proceso de facturación para el periodo '||v_r||' ya está ejecutandose actualmente.';
      else
        -- retornar error y mensaje del proceso finalizado
        select b.id_error, e.error_des
        into v_error_seq,v_return
        from sfc_bitacora_t b
        left join seg_error_t e on e.id_error=b.id_error
        where b.id_bitacora=(
          select max(id_bitacora)
          from sfc_bitacora_t b
          where b.id_proceso=v_proceso
          and b.periodo=v_r
        );
      end if;
    end ejecutarFacturacion;
    -- -------------------------------------------------------------------------------------------
    procedure ejectutarRecargosTSS is
        v_r varchar2(100);
        v_proceso char(2) := '06';
        v_status  char(1);
        v_return          seg_error_t.id_error%type;
        v_error_seq       number;
        v_next_job integer;
    begin
    Select to_char(add_months(sysdate,-1), 'yyyymm') into v_r from dual;
/*      Select d.valor_texto into  v_r
      from sfc_parametros_t p, sfc_det_parametro_t d
      where p.id_parametro = d.id_parametro
      and p.id_parametro = 105;*/
      begin
        select status
        into v_status
        from sfc_bitacora_t b
        where b.id_bitacora=(
          select max(id_bitacora)
          from sfc_bitacora_t b
          where b.id_proceso=v_proceso
          and b.periodo=v_r
        );
      exception when no_data_found then
        v_status := 'N';
      end;
      if (v_status='N') then
         v_return := '000';
         /*by RJ 06/04/2006*/
     		 select seg_job_seq.nextval into v_next_job from dual;
         insert into seg_job_t (
           ID_JOB,NOMBRE_JOB,STATUS,FECHA_ENVIO
         ) values (
           v_next_job,'sre_procesos_pkg.Job_RecargosTSS('||v_next_job||','||v_r||');','S',sysdate
         );
         --sfc_rec_int_ord_fac_ss_p(v_return,v_error_seq,v_r);
         /*end RJ 06/04/2006*/
      elsif (v_status='P') then
        v_error_seq := 650;
        v_return    := 'El proceso de Recargo TSS para el periodo '||v_r||' ya está ejecutandose actualmente.';
      else
        -- retornar error y mensaje del proceso finalizado
        select b.id_error, e.error_des
        into v_error_seq,v_return
        from sfc_bitacora_t b
        left join seg_error_t e on e.id_error=b.id_error
        where b.id_bitacora=(
          select max(id_bitacora)
          from sfc_bitacora_t b
          where b.id_proceso=v_proceso
          and b.periodo=v_r
        );
      end if;
    end ejectutarRecargosTSS;
    -- -------------------------------------------------------------------------------------------
    procedure ejectutarRecargosDGII is
        v_r varchar2(100);
        v_proceso char(2) := '07';
        v_status  char(1);
        v_return          seg_error_t.id_error%type;
        v_error_seq       number;
        v_next_job integer;
    begin
    Select to_char(add_months(sysdate,-1), 'yyyymm') into v_r from dual;
    /*
      Select d.valor_texto into v_r
      from sfc_parametros_t p, sfc_det_parametro_t d
      where p.id_parametro = d.id_parametro
      and p.id_parametro = 105;
*/
      begin
        select status
        into v_status
        from sfc_bitacora_t b
        where b.id_bitacora=(
          select max(id_bitacora)
          from sfc_bitacora_t b
          where b.id_proceso=v_proceso
          and b.periodo=v_r
        );
      exception when no_data_found then
        v_status := 'N';
      end;
      if (v_status='N') then
        v_return := '000';
        /*by RJ 06/04/2006*/
    		select seg_job_seq.nextval into v_next_job from dual;
        insert into seg_job_t (
          ID_JOB,NOMBRE_JOB,STATUS,FECHA_ENVIO
        ) values (
          v_next_job,'sre_procesos_pkg.Job_RecargosDGII('||v_next_job||','||v_r||');','S',sysdate
        );
        --sfc_rec_int_ord_liq_isr_call_p(v_r);
        --sfc_rec_int_ord_liq_isr_p(v_return, v_error_seq, v_r);
        /*end RJ 06/04/2006*/
      elsif (v_status='P') then
        v_error_seq := 650;
        v_return    := 'El proceso de Recargo TSS para el periodo '||v_r||' ya está ejecutandose actualmente.';
      else
        -- retornar error y mensaje del proceso finalizado
        select b.id_error, e.error_des
        into v_error_seq,v_return
        from sfc_bitacora_t b
        left join seg_error_t e on e.id_error=b.id_error
        where b.id_bitacora=(
          select max(id_bitacora)
          from sfc_bitacora_t b
          where b.id_proceso=v_proceso
          and b.periodo=v_r
        );
      end if;
    end ejectutarRecargosDGII;
    -- -------------------------------------------------------------------------------------------
-- **************************************************************************************************
-- Program:     getListadoprocesos
-- Description: devuelve un listado de los procesos que se encuentren en la tabla sfc_procesos_t
--cuyo campo de automatizado = 'S'.
-- **************************************************************************************************
 PROCEDURE getListadoprocesos(
        p_iocursor            OUT t_cursor,
        p_resultnumber        OUT VARCHAR2)
    IS
        v_bderror                 VARCHAR(1000);
        c_cursor t_cursor;
    BEGIN
        OPEN c_cursor FOR
        SELECT  p.id_proceso, p.proceso_des, p.proceso_ejecutar, p.ult_fecha_act, p.ult_usuario_act,
        p.lista_ok, p.lista_error, p.proceso_validar, p.automatizado
        FROM sfc_procesos_t p
        WHERE p.automatizado = 'S';
        p_resultnumber := 0;
        p_iocursor := c_cursor;
    EXCEPTION
        WHEN OTHERS THEN
            v_bderror := (SUBSTR('error '||TO_CHAR(SQLCODE)||': '||sqlerrm, 1, 255));
    	    p_resultnumber := seg_retornar_cadena_error(-1, v_bderror, SQLCODE);
        RETURN;
    END;
-- **************************************************************************************************
-- Program:     gethistorialproceso
-- Description: devuelve un historial de las veces que se ha ejecutado un proceso.
-- **************************************************************************************************
    PROCEDURE gethistorialproceso(
        p_id_proceso          IN sfc_bitacora_t.id_proceso%TYPE,
        p_iocursor            OUT t_cursor,
        p_resultnumber        OUT VARCHAR2)
    IS
        e_invalidproceso    EXCEPTION;
        v_bderror           VARCHAR(1000);
        c_cursor t_cursor;
    BEGIN
        IF NOT srp_procesos_pkg.isExisteidproceso(p_id_proceso) THEN
            RAISE e_invalidproceso;
        END IF;
        if p_id_proceso = 22 then
            OPEN c_cursor FOR
                SELECT b.id_proceso, p.proceso_des, b.id_bitacora, b.fecha_inicio, b.fecha_fin, b.mensage,
                decode(b.status,'E','Error','O','OK','P','En Proceso')status, b.id_error, b.seq_number, b.ult_fecha_act,
                b.ult_usuario_act, b.periodo, b.seq_periodo
                FROM sfc_bitacora_t b, sfc_procesos_t p
                WHERE b.id_proceso = p.id_proceso
                and b.id_proceso in ('06','07','22','23','24','25','26','LM','FM')
                and to_char(b.fecha_inicio,'MM')= to_char(sysdate, 'MM')
                and to_char(b.fecha_inicio,'YY')= to_char(sysdate, 'YY')
                ORDER BY b.fecha_inicio desc, p.proceso_des desc, b.fecha_fin, b.status DESC;
        else
            OPEN c_cursor FOR
                SELECT b.id_proceso, p.proceso_des, b.id_bitacora, b.fecha_inicio, b.fecha_fin, b.mensage,
                decode(b.status,'E','Error','O','OK','P','En Proceso')status, b.id_error, b.seq_number, b.ult_fecha_act,
                b.ult_usuario_act, b.periodo, b.seq_periodo
                FROM sfc_bitacora_t b, sfc_procesos_t p
                WHERE b.id_proceso = p.id_proceso
                AND b.id_proceso = p_id_proceso
                and to_char(b.fecha_inicio,'MM')= to_char(sysdate, 'MM')
                ORDER BY b.fecha_fin DESC;
        end if;
        p_resultnumber := 0;
        p_iocursor := c_cursor;
    EXCEPTION
        WHEN e_invalidproceso THEN
            p_resultnumber := seg_retornar_cadena_error(40, NULL, NULL);
        RETURN;
        WHEN OTHERS THEN
            v_bderror := (SUBSTR('error '||TO_CHAR(SQLCODE)||': '||sqlerrm, 1, 255));
    	    p_resultnumber := seg_retornar_cadena_error(-1, v_bderror, SQLCODE);
        RETURN;
    END;
-- **************************************************************************************************
-- Program:     gethistorialproceso_Total
-- Description:
-- **************************************************************************************************
    PROCEDURE gethistorialproceso_Total(
        p_id_proceso          IN sfc_bitacora_t.id_proceso%TYPE,
        p_iocursor            OUT t_cursor,
        p_resultnumber        OUT VARCHAR2)
    IS
        e_invalidproceso    EXCEPTION;
        v_bderror           VARCHAR(1000);
        c_cursor t_cursor;
    BEGIN
        IF NOT srp_procesos_pkg.isExisteidproceso(p_id_proceso) THEN
            RAISE e_invalidproceso;
        END IF;
        if p_id_proceso = 22 then
            OPEN c_cursor FOR
                SELECT b.id_proceso, p.proceso_des, b.id_bitacora, b.fecha_inicio, b.fecha_fin, b.mensage,
                decode(b.status,'E','Error','O','OK','P','En Proceso')status, b.id_error, b.seq_number, b.ult_fecha_act,
                b.ult_usuario_act, b.periodo, b.seq_periodo
                FROM sfc_bitacora_t b, sfc_procesos_t p
                WHERE b.id_proceso = p.id_proceso
                and b.id_proceso in ('06','07','22','23','24','25','26','LM','FM')
                ORDER BY b.fecha_inicio desc, p.proceso_des desc, b.fecha_fin, b.status DESC;
        else
            OPEN c_cursor FOR
                SELECT b.id_proceso, p.proceso_des, b.id_bitacora, b.fecha_inicio, b.fecha_fin, b.mensage,
                decode(b.status,'E','Error','O','OK','P','En Proceso')status, b.id_error, b.seq_number, b.ult_fecha_act,
                b.ult_usuario_act, b.periodo, b.seq_periodo
                FROM sfc_bitacora_t b, sfc_procesos_t p
                WHERE b.id_proceso = p.id_proceso
                AND b.id_proceso = p_id_proceso
                ORDER BY b.fecha_fin DESC;
        end if;
        p_resultnumber := 0;
        p_iocursor := c_cursor;
    EXCEPTION
        WHEN e_invalidproceso THEN
            p_resultnumber := seg_retornar_cadena_error(40, NULL, NULL);
        RETURN;
        WHEN OTHERS THEN
            v_bderror := (SUBSTR('error '||TO_CHAR(SQLCODE)||': '||sqlerrm, 1, 255));
    	    p_resultnumber := seg_retornar_cadena_error(-1, v_bderror, SQLCODE);
        RETURN;
    END;
-- **************************************************************************************************
-- Program:     CargarDatos
-- Description: devolve un cursor con todos los datos de ese proceso.
-- **************************************************************************************************
    PROCEDURE CargarDatos(
        p_id_proceso          IN sfc_procesos_t.id_proceso%TYPE,
        p_iocursor            OUT t_cursor,
        p_resultnumber        OUT VARCHAR2)
    IS
        e_invalidproceso    EXCEPTION;
        v_bderror           VARCHAR(1000);
        c_cursor t_cursor;
    BEGIN
        IF NOT srp_procesos_pkg.isExisteidproceso(p_id_proceso) THEN
            RAISE e_invalidproceso;
        END IF;
        OPEN c_cursor FOR
        SELECT  p.id_proceso, p.proceso_des, p.proceso_ejecutar, p.ult_fecha_act, p.ult_usuario_act,
        p.lista_ok, p.lista_error, p.proceso_validar, p.automatizado
        FROM sfc_procesos_t p
        WHERE p.id_proceso = p_id_proceso;
        p_resultnumber := 0;
        p_iocursor := c_cursor;
    EXCEPTION
        WHEN e_invalidproceso THEN
            p_resultnumber := seg_retornar_cadena_error(40, NULL, NULL);
        RETURN;
        WHEN OTHERS THEN
            v_bderror := (SUBSTR('error '||TO_CHAR(SQLCODE)||': '||sqlerrm, 1, 255));
    	    p_resultnumber := seg_retornar_cadena_error(-1, v_bderror, SQLCODE);
        RETURN;
    END;
-- **************************************************************************************************
-- Program:     isExisteidproceso
-- Description: Verifica si un id_proceso existe.
-- **************************************************************************************************
    FUNCTION isExisteidproceso(p_id_proceso VARCHAR2) RETURN BOOLEAN
    IS
    CURSOR c_Existeidproceso IS
        SELECT p.id_proceso FROM sfc_procesos_t p
        WHERE p.id_proceso = p_id_proceso;
    returnvalue BOOLEAN;
    v_idproceso VARCHAR(100);
    BEGIN
        OPEN c_Existeidproceso;
            FETCH c_Existeidproceso INTO v_idproceso;
            returnvalue := c_Existeidproceso%FOUND;
            CLOSE c_Existeidproceso;
    RETURN(returnvalue);
    END isExisteidproceso ;
  PROCEDURE getSessionesActual(
        p_iocursor            OUT t_cursor)
    IS
        v_bderror           VARCHAR(1000);
        c_cursor t_cursor;
    BEGIN
            OPEN c_cursor FOR
        Select sid, status, schemaname, osuser, machine, terminal, program, type, action
        from v$session
        where username is not null
        order by status, osuser, program;
        --p_resultnumber := 0;
        p_iocursor := c_cursor;
    EXCEPTION
        WHEN OTHERS THEN
            v_bderror := (SUBSTR('error '||TO_CHAR(SQLCODE)||': '||sqlerrm, 1, 255));
    	    --p_resultnumber := seg_retornar_cadena_error(-1, v_bderror, SQLCODE);
        RETURN;
    END;
 --**************************************************************************
 --**************************************************************************
    PROCEDURE Archivo_Factura_TSS (
	      pperiodo   SFC_FACTURAS_T.periodo_factura%TYPE)
     --   p_resultnumber  OUT VARCHAR2)
   IS
        v_codigo_registro_H            varchar(2);
        v_codigo_registro_D            varchar(2);
    --    v_bderror           varchar(1000);
        --********************************
        v_ID_PROCESO 						    	 CONSTANT SFC_PROCESOS_T.id_proceso%TYPE := '25';
        v_MODULE     						       CONSTANT ERRORS.MODULE%TYPE :=
        											         UPPER('SRE_ARCHIVO_FACTURA_P');
        v_ErrorSeq 								     NUMBER;
        v_error_mesg								   ERRORS.error_mesg%TYPE;
        v_id_bitacora       				   SFC_BITACORA_T.id_bitacora%TYPE;
        v_mensage               			 SFC_BITACORA_T.mensage%TYPE DEFAULT NULL;
        e_Houston 		    					   EXCEPTION;
        v_return 									     SEG_ERROR_T.id_error%TYPE;
        v_error_seq  								   NUMBER;
        vfile                 					UTL_FILE.FILE_TYPE;
        vfname               						VARCHAR2(50) := 'IMPRIMESS.'||TO_CHAR(SYSDATE,'DDMMYYYY')||'.'||PPERIODO;
        v_registro_Encabezado           VARCHAR2(904);
        v_registro_Detalle       				VARCHAR2(138);
        Total_SE             						NUMBER:=0;
        Total_monto_SE       						NUMBER(20,2):=0;
        total_SD             						NUMBER:=0;
        vcuerpo        								  VARCHAR2(500);
    begin
    BEGIN
    	v_return := '000';
    	Srp_Pkg.bitacora(v_id_bitacora, 'INI', v_ID_PROCESO, p_periodo => pperiodo);
    	--vfile := UTL_FILE.FOPEN('IMPRESION_FACTURAS',vfname ,'W',32767);
        vfile := UTL_FILE.FOPEN('IMPRESION_FACTURAS', vfname ,'W');
        UTL_FILE.FCLOSE(vfile);
    	--vfile := UTL_FILE.FOPEN('IMPRESION_FACTURAS',vfname ,'A',32767);
        vfile := UTL_FILE.FOPEN('IMPRESION_FACTURAS', vfname ,'A');
            v_codigo_registro_D:= 'D';
            v_codigo_registro_H:= 'H';
            for i in(select e.rnc_o_cedula, f.ID_RIESGO,replace(e.razon_social,'|', '')razon_social, replace(e.nombre_comercial,'|', '')nombre_comercial, replace(e.calle,'|', '')calle, replace(e.numero,'|', '')numero,
                replace(e.edificio,'|', '')edificio, replace(e.piso,'|', '')piso, replace(e.apartamento,'|', '')apartamento,  replace(e.sector,'|', '')sector, replace(e.localizacion,'|', '')localizacion,
                replace(m.municipio_des,'|', '')municipio_des, replace(p.provincia_des,'|', '')provincia_des ,
                DECODE(TRIM(LENGTH(E.TELEFONO_1)),10,substr(e.telefono_1,1,3)||'-'||substr(e.telefono_1,4,3)||'-'||substr(e.telefono_1,7,4),E.TELEFONO_1)TELEFONO,
                F.ID_REFERENCIA, SUBSTR(f.ID_REFERENCIA,1,4)||'-'||SUBSTR(f.ID_REFERENCIA,5,4)||'-'||SUBSTR(f.ID_REFERENCIA,9,4)||'-'||SUBSTR(f.ID_REFERENCIA,13,4) No_REFERENCIA,
                n.id_nomina, decode(n.tipo_nomina,'N','NORMAL','P','PENSIONADOS','C','CONTRATADOS','D','DISCAPACITADOS',n.tipo_nomina)TIPO_NOMINA,  replace(n.nomina_des,'|', '')nomina_des,
                to_char(to_date(F.FECHA_EMISION),'DD/MM/YYYY','NLS_DATE_LANGUAGE = spanish')FECHA_EMISION,
                to_char(to_date(f.FECHA_LIMITE_PAGO),'DD/MM/YYYY','NLS_DATE_LANGUAGE = spanish')FECHA_LIMITE_PAGO,
                SUBSTR(f.PERIODO_FACTURA,5,2)||'-'||SUBSTR(f.PERIODO_FACTURA,1,4) MES_NOTIFICACION, f.TOTAL_TRABAJADORES,
                DECODE(((f.TOTAL_APORTE_AFILIADOS_SVDS)+ (f.TOTAL_APORTE_AFILIADOS_SFS)),0,'0.00',(TRIM(TO_CHAR(((f.TOTAL_APORTE_AFILIADOS_SVDS)+ (f.TOTAL_APORTE_AFILIADOS_SFS)),'999,999,999,999.99')))) RETENCION_TRABAJADORES,
                DECODE(((F.TOTAL_APORTE_EMPLEADOR_SVDS)+ (F.TOTAL_APORTE_EMPLEADOR_SFS)),0,'0.00',(TRIM(TO_CHAR(((F.TOTAL_APORTE_EMPLEADOR_SVDS)+ (F.TOTAL_APORTE_EMPLEADOR_SFS)),'999,999,999,999.99')))) CONTRIBUCION_EMPLEADOR,
                DECODE((F.TOTAL_APORTE_SRL),0,'0.00',TRIM(TO_CHAR((F.TOTAL_APORTE_SRL),'999,999,999,999.99')))SEGURO_RIESGO_LABORAL,
                DECODE((F.TOTAL_PER_CAPITA_ADICIONAL),0,'0.00',TRIM(TO_CHAR((F.TOTAL_PER_CAPITA_ADICIONAL),'999,999,999,999.99'))) TOTAL_PER_CAPITA_ADICIONAL,
                DECODE((F.TOTAL_APORTE_VOLUNTARIO),0,'0.00',TRIM(TO_CHAR((F.TOTAL_APORTE_VOLUNTARIO),'999,999,999,999.99'))) TOTAL_APORTE_VOLUNTARIO,
                DECODE((F.CREDITO_SRL),0,'0.00',TRIM(TO_CHAR((F.CREDITO_SRL),'999,999,999,999.99'))) CREDITO_SRL,
                DECODE((F.TOTAL_GENERAL_FACTURA),0,'0.00',TRIM(TO_CHAR((F.TOTAL_GENERAL_FACTURA),'999,999,999,999.99'))) TOTAL_GENERAL_FACTURA,
                DECODE((a.ATRASO),0,'0.00',TRIM(TO_CHAR((a.ATRASO),'999,999,999,999.99')))ATRASO,
                DECODE(((F.TOTAL_GENERAL_FACTURA)+ (a.ATRASO)),0,'0.00',TRIM(TO_CHAR(((F.TOTAL_GENERAL_FACTURA)+ (a.ATRASO)),'999,999,999,999.99'))) TOTAL_DEUDA
                from sfc_facturas_v f, sre_empleadores_t e, sre_nominas_t n, sre_municipio_t m, sre_provincias_t p,
                    (
                    select fv.ID_NOMINA, fv.ID_REGISTRO_PATRONAL, sum(fv.TOTAL_GENERAL_FACTURA) ATRASO
                    FROM sfc_facturas_v fv
                    where fv.STATUS = 'VE'
                    group by fv.ID_NOMINA, fv.ID_REGISTRO_PATRONAL
                    )a
                where e.id_registro_patronal = f.ID_REGISTRO_PATRONAL
                and f.ID_REGISTRO_PATRONAL = n.id_registro_patronal
                and f.ID_NOMINA = n.id_nomina
                and e.id_municipio = m.id_municipio
                and m.id_provincia = p.id_provincia
                and f.ID_TIPO_FACTURA = 'O'
                and f.STATUS = 'VI'
                and e.id_motivo_no_impresion = 00
                and f.PERIODO_FACTURA = pperiodo
                and n.id_nomina = a.ID_NOMINA(+)
                and n.id_registro_patronal = a.ID_REGISTRO_PATRONAL(+)
                order by e.area asc, e.zona asc)
            loop
              v_registro_Encabezado :=NULL;
           		Total_SE := Total_SE +1;
                v_registro_Encabezado:= v_codigo_registro_H||'|'||i.rnc_o_cedula||'|'||i.id_riesgo||'|'||i.razon_social||'|'||i.nombre_comercial||'|'||i.calle||'|'||
                i.numero||'|'||i.edificio||'|'||i.piso||'|'||i.apartamento||'|'||i.sector||'|'||i.localizacion||'|'||i.municipio_des||'|'||i.provincia_des||'|'||i.telefono||'|'||i.No_Referencia||'|'||
                i.id_nomina||'|'||i.tipo_nomina||'|'||i.nomina_des||'|'||i.fecha_emision||'|'||i.fecha_limite_pago||'|'||i.Mes_Notificacion||'|'||i.total_trabajadores||'|'||
                i.retencion_trabajadores||'|'||i.contribucion_empleador||'|'||i.seguro_riesgo_laboral||'|'||i.total_per_capita_adicional||'|'||i.total_aporte_voluntario||'|'||i.credito_srl||'|'||
                i.total_general_factura||'|'||i.atraso||'|'||i.total_deuda;
                UTL_FILE.PUT_LINE(vfile, v_registro_Encabezado );
                if i.total_trabajadores <= 40 then
                   for j in(
                        select c.no_documento, SUBSTR(c.no_documento,1,3)||'-'||SUBSTR(c.no_documento,4,7)||'-'||SUBSTR(c.no_documento,11,1)CEDULA,
                        substr(LPAD(c.id_nss,9,0),1,8)||'-'||substr(LPAD(c.id_nss,9,0),9,1)NSS,
                        replace(c.primer_apellido,'|', '')||' '||nvl(replace(c.segundo_apellido,'|', ''),'')Apellidos, replace(c.nombres,'|', '')nombres,
                        DECODE((d.SALARIO_SS),0,'0.00', TRIM(TO_CHAR((d.SALARIO_SS),'999,999,999,999.99'))) SALARIO_SS,
                        DECODE(((d.APORTE_AFILIADOS_SVDS)+ (d.APORTE_AFILIADOS_SFS)),0,'0.00',TRIM(TO_CHAR(((d.APORTE_AFILIADOS_SVDS)+ (d.APORTE_AFILIADOS_SFS)),'999,999,999,999.99'))) RETENCION,
                        DECODE(((D.APORTE_EMPLEADOR_SVDS)+ (D.APORTE_EMPLEADOR_SFS)),0,'0.00',TRIM(TO_CHAR(((D.APORTE_EMPLEADOR_SVDS)+ (D.APORTE_EMPLEADOR_SFS)),'999,999,999,999.99'))) CONTRIBUCION,
                        DECODE((D.PER_CAPITA_ADICIONAL),0,'0.00',TRIM(TO_CHAR((D.PER_CAPITA_ADICIONAL),'999,999,999,999.99')))PER_CAPITA,
                        DECODE((D.APORTE_VOLUNTARIO),0,'0.00',TRIM(TO_CHAR((D.APORTE_VOLUNTARIO),'999,999,999,999.99')))APORTE_VOLUNTARIO,
                        DECODE((((d.APORTE_AFILIADOS_SVDS) + (d.APORTE_AFILIADOS_SFS) + (D.APORTE_EMPLEADOR_SVDS) +
                        (D.APORTE_EMPLEADOR_SFS) + (D.PER_CAPITA_ADICIONAL) + (D.APORTE_VOLUNTARIO))),0,'0.00',(TRIM(TO_CHAR((((d.APORTE_AFILIADOS_SVDS) + (d.APORTE_AFILIADOS_SFS) + (D.APORTE_EMPLEADOR_SVDS) +
                        (D.APORTE_EMPLEADOR_SFS) + (D.PER_CAPITA_ADICIONAL) + (D.APORTE_VOLUNTARIO))),'999,999,999,999.99')))) TOTAL
                        from sfc_facturas_v p, sfc_det_facturas_v d, sre_ciudadanos_t c, sre_empleadores_t e
                        where p.ID_REFERENCIA = d.ID_REFERENCIA
                        and d.ID_NSS = c.id_nss
                        and p.ID_REGISTRO_PATRONAL = e.id_registro_patronal
                        and e.rnc_o_cedula = i.rnc_o_cedula
                        and d.ID_REFERENCIA = i.id_referencia
                        and c.tipo_documento = 'C'
                        )
                    loop
                    v_registro_Detalle:= null;
                    Total_SD:= Total_SD +1;
                        v_registro_Detalle:= v_codigo_registro_D||'|'||j.Cedula||'|'||j.nss||'|'||j.apellidos||'|'||j.nombres||'|'||j.salario_ss||'|'||
                        j.retencion||'|'||j.contribucion||'|'||j.per_capita||'|'||j.aporte_voluntario||'|'||j.total;
                        UTL_FILE.PUT_LINE(vfile ,v_registro_Detalle );
                    end loop;--j
                end if;
        end loop;--i
        UTL_FILE.FCLOSE_ALL;
	IF total_SE > 0 THEN
   vcuerpo:=' ------------------------------------------------------
| Nombre_Archivo               Cantidad de Factura      Cantidad Detalle       Monto_Total_Generado    |
 --------------------------------------------------------------------------------------------------------
|'|| substr(vfname,1,30)||to_char(Total_SE,'99999999')||'            '||to_char(Total_SD,'99999999' )||'          '|| Total_monto_SE ||'
'||'--------------------------------------------------------------------------------------------------------';
   	Sre_Envia_Email_P( '25',vcuerpo , 'OK' );
  	END IF;
	  Srp_Pkg.bitacora(v_id_bitacora, 'FIN', v_ID_PROCESO, v_mensage, 'O', v_return);
    EXCEPTION WHEN OTHERS THEN Errorpkg.HandleAll(FALSE); RAISE;
    END; -- Anonymous block
    EXCEPTION
      	WHEN e_Houston THEN
      		IF v_mensage IS NULL THEN v_mensage := 'Houston'; END IF;
    		Srp_Pkg.bitacora(v_id_bitacora, 'FIN', v_ID_PROCESO, v_mensage, 'E', v_return, v_error_seq);
      	WHEN OTHERS THEN
       		ROLLBACK;
       		Errorpkg.HandleAll(TRUE);
        	Errorpkg.StoreStacks(v_MODULE, v_ErrorSeq, TRUE);
        	Errorpkg.PrintStacks(v_MODULE, v_ErrorSeq);
    		v_return := '650';
    		Srp_Pkg.bitacora(v_id_bitacora, 'FIN', v_ID_PROCESO, v_error_mesg, 'E', v_return, v_ErrorSeq);
    end;
    -- ----------------------------------------------------------------------
    procedure Job_Facturacion(p_job in integer, p_mes in integer) is
     v_error  number;
     v_return number;
    begin
      -- ejecutar y recibir parametros de salida
      if sfc_mes_fac_liq_ordinaria_f(
           p_return => v_return,
           p_error_seq => v_error,
           p_periodo_factura => p_mes)
      then
        -- marcar job como terminado
        update seg_job_t k
        set k.status='T',
            k.resultado=v_error||'-'||v_return,
            k.fecha_termino=sysdate
        where id_job=p_job;
      else
        --si devolvio falso, algo está mal
        raise_application_error(-20000,'sfc_mes_fac_liq_ordinaria_f retornó falso y '||v_return||'-'||v_error);
      end if;
    exception when others then
      -- marcar job como erroneo
      update seg_job_t
      set status='E',
          fecha_termino=sysdate
      where id_job=p_job;
      -- enviar email a los incumbentes
      system.html_mail('info@mail.tss2.gov.do','_operaciones@mail.tss2.gov.do, dba@mail.tss2.gov.do','Error en sfc_mes_fac_liq_ordinaria_f',substr(sqlerrm,1,250));
    end;
    -- ----------------------------------------------------------------------
    procedure refrescar_vista_sipen is
      mail_from    varchar2(100)   := 'info@mail.tss2.gov.do';
      mail_ok      varchar2(100)   := 'dba@mail.tss2.gov.do, acruz@sipen.gov.do';
      mail_err     varchar2(100)   := 'dba@mail.tss2.gov.do, _operaciones@mail.tss2.gov.do';
      mail_subject varchar2(100)   := 'Actualizacion de vistas de Empleadores y Trabajadores';
      mail_data    varchar2(32000) := '';
    begin
      mail_data := mail_data||'<html><head><title>'||mail_subject||'</title></head><body>';
      mail_data := mail_data||'Se les informa que la vistas de Empleadores y Trabajadores han sido refrescadas al '||to_char(sysdate,'dd/mm/yyyy hh:mi:ss am');
      mail_data := mail_data||'</body></html>';

      execute immediate 'begin sys.dbms_refresh.refresh(''SUIRPLUS.SUIR_SIPEN_RG''); end;';

      system.html_mail(mail_from,mail_ok,mail_subject,mail_data);
    exception when others then
      system.html_mail(mail_from,mail_err,'Error en '||mail_subject,sqlerrm);
    end;
    -- ----------------------------------------------------------------------
    procedure Job_RecargosTSS(p_job in integer, p_mes in integer) is
     v_error  number;
     v_return number;
    begin
      -- ejecutar y recibir parametros de salida
      sfc_rec_int_ord_fac_ss_p(
        pp_return => v_error,
       	pp_error_seq => v_error,
       	pp_periodo => p_mes
      );
      -- marcar job como terminado
      update seg_job_t k
      set k.status='T',
          k.resultado=v_error||'-'||v_return,
          k.fecha_termino=sysdate
      where id_job=p_job;
    exception when others then
      -- marcar job como erroneo
      update seg_job_t k
      set k.status='E',
          k.fecha_termino=sysdate
      where id_job=p_job;
      -- enviar email a los incumbentes
      system.html_mail('info@mail.tss2.gov.do','dba@mail.tss2.gov.do, _operaciones@mail.tss2.gov.do','Error en sfc_mes_fac_liq_ordinaria_f',substr(sqlerrm,1,250));
    end;
    -- ----------------------------------------------------------------------
   /*
    procedure Job_RecargosDGII(p_job in integer, p_mes in integer) is
     v_error  number;
     v_return number;
    begin
      -- ejecutar y recibir parametros de salida
      sfc_rec_int_ord_liq_isr_p(
        p_return => v_return,
        p_error_seq => v_error,
       	p_periodo_procesar => p_mes
      );

      -- marcar job como terminado
      update seg_job_t k
      set k.status='T',
          k.resultado=v_error||'-'||v_return,
          k.fecha_termino=sysdate
      where id_job=p_job;
    exception when others then
      -- marcar job como erroneo
      update seg_job_t k
      set k.status='E',
          k.fecha_termino=sysdate
      where id_job=p_job;
      -- enviar email a los incumbentes
      system.html_mail('info@mail.tss2.gov.do','dba@mail.tss2.gov.do,hector_minaya@mail.tss2.gov.do,roberto_jaquez@mail.tss2.gov.do','Error en sfc_mes_fac_liq_ordinaria_f','sqlerrm');
    end;
	*/
    -- ----------------------------------------------------------------------
    procedure Job_RecargosINFOTEP(p_job in integer, p_mes in integer) is
     v_error  number;
     v_return number;
    begin
      -- ejecutar y recibir parametros de salida
      sfc_rec_int_liq_inf_p(
        p_return => v_return,
        p_error_seq => v_error,
       	p_periodo_procesar => p_mes
      );

      -- marcar job como terminado
      update seg_job_t k
      set k.status='T',
          k.resultado=v_error||'-'||v_return,
          k.fecha_termino=sysdate
      where id_job=p_job;
    exception when others then
      -- marcar job como erroneo
      update seg_job_t k
      set k.status='E',
          k.fecha_termino=sysdate
      where id_job=p_job;
      -- enviar email a los incumbentes
      system.html_mail('info@mail.tss2.gov.do','_operaciones@mail.tss2.gov.do, dba@mail.tss2.gov.do', 'Error en sfc_mes_fac_liq_ordinaria_f','sqlerrm');
    end;
    -- ----------------------------------------------------------------------
    procedure fac_liq_rec_automatico is
      valor_fecha       date ;
      valor_mes         number(6);
      v_hora_inicio     date    := sysdate;
      par_facturacion   integer := 40; --FECHA FACTURACION DEL PERIODO
      par_recargos_ss   integer := 32; --SVDS INTERES
      mail_from         varchar2(1000) := 'info@mail.tss2.gov.do';
      mail_error        varchar2(1000) := '_operaciones@mail.tss2.gov.do, dba@mail.tss2.gov.do';
      mail_ok           varchar2(1000) := '_operaciones@mail.tss2.gov.do';
      html              varchar2(32000);
      v_resultNumber    varchar2(1000);
      -- ------------------------------------------------------------------------------
      procedure html_header(titulo in varchar2) is
      begin
        v_hora_inicio := sysdate;
        html := '<html><head><title>'||titulo||'</title></head><body><table border=1>'
             || '<tr><td>Hora inicio</td><td>'||to_char(v_hora_inicio,'dd/mm/yyyy hh24:mi:ss')||'</td></tr>';
      end;
      -- ------------------------------------------------------------------------------
      procedure html_line(col1 in varchar2, col2 in varchar2) is
      begin
        html := html||'<tr><td>'||col1||'</td><td>'||col2||'</td></tr>';
      end;
      -- ------------------------------------------------------------------------------
      procedure html_footer is
      begin
        html := html
             || '<tr><td>Hora fin</td><td>'||to_char(sysdate,'dd/mm/yyyy hh24:mi:ss')||'</td></tr>'
             || '<tr><td>Tiempo Transcurrido</td><td>'||trim(to_char((sysdate-v_hora_inicio)*24*60,'999,999,999.99'))||' mins.</td></tr>'
             || '</table></body></html>';
        system.html_mail(mail_from,mail_ok,substr(substr(html,1,instr(html,'</title>')-1),20,999),html);
      end;
    begin
      /* Facturacion -------------------------------------------------------------------- */
      begin
        html_header('Proceso automatico de facturacion mensual');
        select max(valor_fecha)
        into valor_fecha
        from sfc_det_parametro_t
        where id_parametro=par_facturacion;
        valor_mes := to_number(to_char(sysdate,'yyyymm'));
        html_line('Max valor_fecha parametro '||par_facturacion,valor_fecha);
        if trunc(sysdate) = trunc(valor_fecha) then
          job_facturacion(-1,valor_mes);
          html_line('sfc_mes_fac_liq_ordinaria_f '||valor_mes,'OK');
          html_footer();
        end if;
      exception when others then
        system.html_mail(mail_from,mail_error,'Error en '||substr(substr(html,1,instr(html,'</title>')-1),20,999),substr(sqlerrm,1,250));
      end;
      /* Recargos SS -------------------------------------------------------------------- */
      declare
        /*
        Task #587: Revisión de valor fecha en parámetro 40 para que ponga 24 de cada mes
        proxima_facturacion date := to_date('15'||to_char(sysdate,'mmyyyy'),'ddmmyyyy');
        */
        proxima_facturacion date := to_date('20'||to_char(sysdate,'mmyyyy'),'ddmmyyyy');
      begin
        html_header('Proceso automatico de recargos ss');
        select max(fecha_ini)
        into valor_fecha
        from sfc_det_parametro_t
        where id_parametro=par_recargos_ss;
        valor_mes := to_number(to_char(add_months(valor_fecha,-1),'yyyymm'));
        html_line('Max valor_fecha parametro '||par_recargos_ss,valor_fecha);

        if trunc(sysdate) = trunc(valor_fecha) then
          srp_procesos_pkg.Job_RecargosTSS(-1,valor_mes);
          html_line('sfc_rec_int_ord_fac_ss_p '||valor_mes,'OK');
          update sfc_det_parametro_t
          set valor_fecha = proxima_facturacion
          where id_parametro=par_facturacion;
          commit;
          html_line('Nuevo valor_fecha parametro '||par_facturacion,proxima_facturacion);
          html_footer;

          --otros procesos despues de recargos
          refrescar_vista_sipen;

          --Procesos que generan las carteras de cobro y legal
          suirplus.cob_cobro_pkg.generar_cartera('C', v_resultNumber);
          suirplus.cob_cobro_pkg.generar_cartera('L', v_resultNumber);

          -- Para refrescar la vista de trabajadores de baja a UNIPAGO
          refrescar_vista_emp_baja;
        end if;
      exception when others then
        system.html_mail(mail_from,mail_error,'Error en '||substr(substr(html,1,instr(html,'</title>')-1),20,999),substr(sqlerrm,1,250));
      end;

      /* Recargos DGII ------------------------------------------------------------------ */
     /* declare
        fecha_recargos_isr  date;
        par Parm;
        PER INTEGER;
      begin
        html_header('Proceso automatico de recargos dgii');
        per := to_char(add_months(sysdate,-1),'YYYYMM');
       	par := Parm(per);
      	IF per >= par.periodo_inicio_isr THEN
  	    	Srp_Pkg.initialize_isr_parm(par, per);
    	  END IF;
        fecha_recargos_isr := par.fecha_limite_pago_isr; --Srp_pkg.fecha_limite_pago_isr(Parm.periodo_vigente_isr(trunc(sysdate)))+1;
        fecha_recargos_isr := fecha_recargos_isr+1;
        html_line('fecha_corrida_recargos_isr + 1',fecha_recargos_isr);
        if trunc(sysdate) = fecha_recargos_isr then
          Job_RecargosDGII(-1,valor_mes);
          html_line('sfc_rec_int_ord_liq_isr_p '||valor_mes,'OK');
          html_footer;
        end if;
      exception when others then
        system.html_mail(mail_from,mail_error,'Error en '||substr(substr(html,1,instr(html,'</title>')-1),20,999),substr(sqlerrm,1,250));
      end;*/

      /* Recargos INFOTEP ------------------------------------------------------------------ */
      declare
        fecha_recargos_inf  date;
        par Parm;
        PER INTEGER;
      begin
        html_header('Proceso automatico de recargos INFOTEP');
        per := to_char(add_months(sysdate,-1),'YYYYMM');
        fecha_recargos_inf := Srp_Pkg.fecha_limite_pago_isr(per);
        fecha_recargos_inf := fecha_recargos_inf + 1;
        html_line('fecha_corrida_recargos_infotep + 1',fecha_recargos_inf);
        if trunc(sysdate) = fecha_recargos_inf then
          Job_RecargosINFOTEP(-1, valor_mes);
          html_line('sfc_rec_int_liq_inf_p '||valor_mes,'OK');
          html_footer;
        end if;
      exception when others then
        system.html_mail(mail_from,mail_error,'Error en '||substr(substr(html,1,instr(html,'</title>')-1),20,999),substr(sqlerrm,1,250));
      end;
    exception when others then
      system.html_mail(mail_from,mail_error,'Error en proceso automatico de facturacion y recargos',substr(sqlerrm,1,250));
    end fac_liq_rec_automatico;

    -- ----------------------------------------------------------------------
    --Para refrescar la vista de trabajadores de baja
    -- ----------------------------------------------------------------------    
    procedure refrescar_vista_emp_baja is
      mail_from    varchar2(100)   := 'info@mail.tss2.gov.do';
      mail_ok      varchar2(100)   := 'dba@mail.tss2.gov.do, _operaciones@mail.tss2.gov.do';
      mail_err     varchar2(100)   := 'dba@mail.tss2.gov.do, _operaciones@mail.tss2.gov.do';
      mail_subject varchar2(100)   := 'Actualizacion de vistas Empleadores de baja';
      mail_data    varchar2(32000) := '';
    begin  
      mail_data := mail_data||'<html><head><title>'||mail_subject||'</title></head><body>';
      mail_data := mail_data||'Se les informa que la vistas de Empleadores de baja ha sido refrescada al '||to_char(sysdate,'dd/mm/yyyy hh:mi:ss am');
      mail_data := mail_data||'</body></html>';

      -- Para refrescar la vista de trabajadores de baja a UNIPAGO
      dbms_mview.refresh('unipago.SRE_TRABAJADORES_BAJA_MV');

      system.html_mail(mail_from,mail_ok,mail_subject,mail_data);
    exception when others then
      system.html_mail(mail_from,mail_err,'Error en '||mail_subject,sqlerrm);
    end;  
END srp_procesos_pkg;