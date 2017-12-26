CREATE OR REPLACE PACKAGE BODY SUIRPLUS.SFC_IR13 IS

--- **************************************************************************************************
-- PROCEDIMIENTO:   PageDetalleIR13
-- DESCRIPCION:     Resumen IR 13 Con Paginacion  
-- **************************************************************************************************
PROCEDURE PageDetalleIR13(
        p_rnc_o_cedula   in sre_empleadores_t.rnc_o_cedula%TYPE,
        p_ano_fiscal     in sfc_det_resumen_ir13_t.ano_fiscal%TYPE,
        p_pageNumero     in number,
        p_pageCantidad   in number,
        p_cursor         OUT t_cursor,  
        p_result         OUT VARCHAR2)
    IS
        v_reg_patronal        varchar2(20);
        v_bderror             VARCHAR(1000);
        c_cursor t_cursor;

        vDesde   integer;
        vHasta   integer;
        vRecords integer;
    BEGIN
    
    vDesde := (p_pageCantidad * ( p_pageNumero - 1 )) + 1;
    vHasta := p_pageCantidad * p_pageNumero;
    
    select e.id_registro_patronal into v_reg_patronal from sre_empleadores_t e
    where e.rnc_o_cedula = p_rnc_o_cedula;
    
       if v_reg_patronal is not null and p_ano_fiscal is not null then

           /*borrar la data que este*/
           delete from suirplus.tmp_reporte_ir13_t 
           where id_registro_patronal = v_reg_patronal;
           commit;
           
           insert into suirplus.tmp_reporte_ir13_t
           select rownum num,y.* 
           from (select  S.ID_REGISTRO_PATRONAL,S.ID_NSS,S.A_NOMBRES nombres ,S.A_APELLIDOS apellidos,S.CEDULA_PASAPORTE AS NO_DOCUMENTO,
                        sum(S.TOTAL_SALARIOS) as SALARIO_ISR ,sum(S.OTRAS_REMUN) as OTRAS_REMUN,sum(S.REMUN_OTROS) as REMUNERACION_ISR_OTROS,
                        sum(S.TOTAL_PAGADO) as TOTAL_PAGADO,sum(S.EXENTOS) as INGRESOS_EXENTOS_ISR, sum(S.RETENCION_SS) as RETENCION_SS,
                        sum(S.SUJETO_A_ISR) as TOTAL_SUJETO_RETENCION,sum(S.ISR_LIQUIDADO) as ISR,sum(S.SALDO_FAVOR_ANTERIOR) as SALDO_FAVOR_ANTERIOR,
                        sum(S.RETENIDO) as IMPUESTO_A_PAGAR,sum(S.SALDO_FAVOR_EMPLEADO)as SALDO_FAVOR_EMPLEADO,sum(S.SALDO_FAVOR_DGII) as SALDO_FAVOR_DGII      
                from    suirplus.sfc_saldos_favor_v S 
                where   s.id_registro_patronal = v_reg_patronal
                  and   s.ano_fiscal = p_ano_fiscal
                group   by S.ID_REGISTRO_PATRONAL, S.ID_NSS, S.A_NOMBRES, S.A_APELLIDOS, S.CEDULA_PASAPORTE
                ORDER   BY S.A_APELLIDOS, S.A_NOMBRES
               ) y;
               vRecords := SQL%ROWCOUNT;
           commit;
           
           OPEN c_cursor FOR
                select vRecords recordcount,a.*
                from suirplus.tmp_reporte_ir13_t a
                where a.id_registro_patronal = v_reg_patronal
                and num between vDesde and vHasta
                order by num;

            p_cursor := c_cursor;
            p_result := 0;
            
        end if;

    EXCEPTION
        WHEN OTHERS THEN
            v_bderror := (SUBSTR('error '||TO_CHAR(SQLCODE)||': '||SQLERRM, 1, 255));
            p_result := Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
        RETURN;
    END;

--- **************************************************************************************************
-- PROCEDIMIENTO:   Resumen_ir13  
-- DESCRIPCION:       
-- **************************************************************************************************

    PROCEDURE Resumen_ir13(
        p_rnc            IN sre_empleadores_t.rnc_o_cedula%TYPE,
        p_ano            in sfc_det_resumen_ir13_t.ano_fiscal%TYPE,
        p_iocursor       IN OUT t_cursor,
        p_resultnumber   OUT VARCHAR2)

    IS
        c_cursor t_cursor;
        v_reg_patronal        varchar2(20);
        v_bderror             VARCHAR(1000);
    BEGIN
    
    select e.id_registro_patronal into v_reg_patronal from sre_empleadores_t e
    where e.rnc_o_cedula = p_rnc;
    
       if v_reg_patronal is not null and p_ano is not null then
    
            OPEN c_cursor FOR
                select S.ID_REGISTRO_PATRONAL,S.ID_NSS,S.A_NOMBRES nombres ,S.A_APELLIDOS apellidos,S.CEDULA_PASAPORTE AS NO_DOCUMENTO,
                sum(S.TOTAL_SALARIOS) as SALARIO_ISR ,sum(S.OTRAS_REMUN) as OTRAS_REMUN,sum(S.REMUN_OTROS) as REMUNERACION_ISR_OTROS,
                sum(S.TOTAL_PAGADO) as TOTAL_PAGADO,sum(S.EXENTOS) as INGRESOS_EXENTOS_ISR, sum(S.RETENCION_SS) as RETENCION_SS,
                sum(S.SUJETO_A_ISR) as TOTAL_SUJETO_RETENCION,sum(S.ISR_LIQUIDADO) as ISR,sum(S.SALDO_FAVOR_ANTERIOR) as SALDO_FAVOR_ANTERIOR,
                sum(S.RETENIDO) as IMPUESTO_A_PAGAR,sum(S.SALDO_FAVOR_EMPLEADO)as SALDO_FAVOR_EMPLEADO,sum(S.SALDO_FAVOR_DGII) as SALDO_FAVOR_DGII      
                from suirplus.sfc_saldos_favor_v s 
                where s.id_registro_patronal = v_reg_patronal
                and s.ano_fiscal = p_ano
                group by S.ID_REGISTRO_PATRONAL,S.ID_NSS,S.A_NOMBRES,S.A_APELLIDOS,S.CEDULA_PASAPORTE
                ORDER BY S.A_APELLIDOS,S.A_NOMBRES;

            p_iocursor := c_cursor;
            p_resultnumber := 0;
        end if;

    EXCEPTION

        WHEN OTHERS THEN
            v_bderror := (SUBSTR('error '||TO_CHAR(SQLCODE)||': '||SQLERRM, 1, 255));
    	    p_resultnumber := Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
        RETURN;
    END;
    
--- **************************************************************************************************
-- PROCEDIMIENTO:   PageResumen_ir13  
-- DESCRIPCION:     Resumenir13ConPaginacion  
-- **************************************************************************************************

    PROCEDURE PageResumen_ir13(
        p_rnc            IN sre_empleadores_t.rnc_o_cedula%TYPE,
        p_ano            in sfc_det_resumen_ir13_t.ano_fiscal%TYPE,
        p_pageNum        in number,
        p_pageSize       in number,
        p_iocursor       IN OUT t_cursor,
        p_resultnumber   OUT VARCHAR2)

    IS
        v_reg_patronal        varchar2(20);
        v_bderror             VARCHAR(1000);
        c_cursor t_cursor;

        vDesde integer     := (p_pagesize*(p_pagenum-1))+1;
        vHasta integer     := p_pagesize*p_pagenum;
    BEGIN
    
    select e.id_registro_patronal into v_reg_patronal from sre_empleadores_t e
    where e.rnc_o_cedula = p_rnc;
    
       if v_reg_patronal is not null and p_ano is not null then
    
            OPEN c_cursor FOR
            with x as (select rownum num,y.* from (
                select S.ID_REGISTRO_PATRONAL,S.ID_NSS,S.A_NOMBRES nombres ,S.A_APELLIDOS apellidos,S.CEDULA_PASAPORTE AS NO_DOCUMENTO,
                sum(S.TOTAL_SALARIOS) as SALARIO_ISR ,sum(S.OTRAS_REMUN) as OTRAS_REMUN,sum(S.REMUN_OTROS) as REMUNERACION_ISR_OTROS,
                sum(S.TOTAL_PAGADO) as TOTAL_PAGADO,sum(S.EXENTOS) as INGRESOS_EXENTOS_ISR, sum(S.RETENCION_SS) as RETENCION_SS,
                sum(S.SUJETO_A_ISR) as TOTAL_SUJETO_RETENCION,sum(S.ISR_LIQUIDADO) as ISR,sum(S.SALDO_FAVOR_ANTERIOR) as SALDO_FAVOR_ANTERIOR,
                sum(S.RETENIDO) as IMPUESTO_A_PAGAR,sum(S.SALDO_FAVOR_EMPLEADO)as SALDO_FAVOR_EMPLEADO,sum(S.SALDO_FAVOR_DGII) as SALDO_FAVOR_DGII      
                from suirplus.sfc_saldos_favor_v s 
                where s.id_registro_patronal = v_reg_patronal
                and s.ano_fiscal = p_ano
                group by S.ID_REGISTRO_PATRONAL,S.ID_NSS,S.A_NOMBRES,S.A_APELLIDOS,S.CEDULA_PASAPORTE
                ORDER BY S.A_APELLIDOS,S.A_NOMBRES
            )y) select y.recordcount,x.*
            from x,(select max(num) recordcount from x) y
            where num between vDesde and vHasta
            order by num;

            p_iocursor := c_cursor;
            p_resultnumber := 0;
        end if;

    EXCEPTION

        WHEN OTHERS THEN
            v_bderror := (SUBSTR('error '||TO_CHAR(SQLCODE)||': '||SQLERRM, 1, 255));
    	    p_resultnumber := Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
        RETURN;
    END;    

--- **************************************************************************************************
-- PROCEDIMIENTO: SaldoDGII.
--   DESCRIPCION: Verifica si hay empleados con Saldo a Favor para la DGII. Task 1205.
--         Autor: Ramon Pichardo.
--         FECHA: 11-FEB-2008.
-- **************************************************************************************************

    PROCEDURE SaldoDGII(
        p_rnc            IN sre_empleadores_t.rnc_o_cedula%TYPE,
        p_ano            in sfc_det_resumen_ir13_t.ano_fiscal%TYPE,
        p_iocursor       IN OUT t_cursor,
        p_resultnumber   OUT VARCHAR2)

    IS
        v_reg_patronal        varchar2(20);
        v_bderror             VARCHAR(1000);
        c_cursor t_cursor;
        
        
    BEGIN
    
    select e.id_registro_patronal into v_reg_patronal from sre_empleadores_t e
    where e.rnc_o_cedula = p_rnc;
    
       if v_reg_patronal is not null and p_ano is not null then
    
            OPEN c_cursor FOR
                select S.ID_REGISTRO_PATRONAL,
                       S.ID_NSS,
                       S.A_NOMBRES nombres,
                       S.A_APELLIDOS apellidos,
                       S.CEDULA_PASAPORTE AS NO_DOCUMENTO,
                       sum(S.TOTAL_SALARIOS) as SALARIO_ISR,
                       sum(S.OTRAS_REMUN) as OTRAS_REMUN,
                       sum(S.REMUN_OTROS) as REMUNERACION_ISR_OTROS,
                       sum(S.TOTAL_PAGADO) as TOTAL_PAGADO,
                       sum(S.EXENTOS) as INGRESOS_EXENTOS_ISR,
                       sum(S.RETENCION_SS) as RETENCION_SS,
                       sum(S.SUJETO_A_ISR) as TOTAL_SUJETO_RETENCION,
                       sum(S.ISR_LIQUIDADO) as ISR,
                       sum(S.SALDO_FAVOR_ANTERIOR) as SALDO_FAVOR_ANTERIOR,
                       sum(S.RETENIDO) as IMPUESTO_A_PAGAR,
                       sum(S.SALDO_FAVOR_EMPLEADO) as SALDO_FAVOR_EMPLEADO,
                       sum(S.SALDO_FAVOR_DGII) as SALDO_FAVOR_DGII
                  from suirplus.sfc_saldos_favor_v s
                 where s.id_registro_patronal = v_reg_patronal
                   and s.ano_fiscal = p_ano
                 group by S.ID_REGISTRO_PATRONAL,
                          S.ID_NSS,
                          S.A_NOMBRES,
                          S.A_APELLIDOS,
                          S.CEDULA_PASAPORTE 
                 having sum(S.SALDO_FAVOR_DGII) >= 100  -- Solo con Saldo a Favor DGII
                 ORDER BY S.A_APELLIDOS, S.A_NOMBRES;

            p_iocursor := c_cursor;
            p_resultnumber := 0;
        end if;

    EXCEPTION

        WHEN OTHERS THEN
            v_bderror := (SUBSTR('error '||TO_CHAR(SQLCODE)||': '||SQLERRM, 1, 255));
    	    p_resultnumber := Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
        RETURN;
    END;

--- **************************************************************************************************
-- PROCEDIMIENTO:   Detalle_Periodo 
-- DESCRIPCION:       
-- **************************************************************************************************
    PROCEDURE Detalle_Periodo(
        p_rnc            IN sre_empleadores_t.rnc_o_cedula%TYPE,
        p_ano            in sfc_det_resumen_ir13_t.ano_fiscal%TYPE,
        p_periodo        in sfc_det_resumen_ir13_t.periodo%TYPE,
        p_iocursor       IN OUT t_cursor,
        p_resultnumber   OUT VARCHAR2)

    IS
        v_reg_patronal        varchar2(20);
        v_bderror             VARCHAR(1000);
        c_cursor t_cursor;
        
        
    BEGIN
    
    select e.id_registro_patronal into v_reg_patronal from sre_empleadores_t e
    where e.rnc_o_cedula = p_rnc;
    
       if v_reg_patronal is not null and p_ano is not null and p_periodo is not null then
    
            OPEN c_cursor FOR
                select C.NOMBRES, C.PRIMER_APELLIDO||' '||nvl(C.SEGUNDO_APELLIDO,'')as APELLIDOS, C.NO_DOCUMENTO,
                t.SALARIO_ISR as SALARIO_ISR, t.OTROS_INGRESOS_ISR as OTROS_INGRESOS_ISR, 
                t.remuneracion_isr_otros as REMUNERACION_ISR_OTROS, t.ingresos_exentos_isr as INGRESOS_EXENTOS_ISR,
                t.total_pagado as TOTAL_PAGADO,t.retencion_ss as RETENCION_SS,t.total_sujeto_retencion as TOTAL_SUJETO_RETENCION,
                t.isr as ISR ,t.impuesto_a_pagar AS IMPUESTO_A_PAGAR,
                t.tipo_trabajador
                from sfc_det_resumen_ir13_v t, sre_ciudadanos_t c
                where c.id_nss = t.ID_NSS
                and c.tipo_documento in('C','P')
                and t.ID_REGISTRO_PATRONAL = v_reg_patronal
                and t.ANO_FISCAL = p_ano
                and t.PERIODO = p_periodo
                ORDER BY APELLIDOS, C.NOMBRES;

            p_iocursor := c_cursor;
            p_resultnumber := 0;
        end if;

    EXCEPTION

        WHEN OTHERS THEN
            v_bderror := (SUBSTR('error '||TO_CHAR(SQLCODE)||': '||SQLERRM, 1, 255));
    	    p_resultnumber := Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
        RETURN;
    END;

--- **************************************************************************************************
-- PROCEDIMIENTO:   Detalle_Periodo 
-- DESCRIPCION:       
-- **************************************************************************************************
    PROCEDURE getPageDetalle_Periodo(
        p_rnc            IN sre_empleadores_t.rnc_o_cedula%TYPE,
        p_ano            in sfc_det_resumen_ir13_t.ano_fiscal%TYPE,
        p_periodo        in sfc_det_resumen_ir13_t.periodo%TYPE,
        p_pageNum        in number,
        p_pageSize       in number,
        p_iocursor       IN OUT t_cursor,
        p_resultnumber   OUT VARCHAR2)

    IS
        v_reg_patronal        varchar2(20);
        v_bderror             VARCHAR(1000);
        c_cursor t_cursor;
        
        vDesde integer     := (p_pagesize*(p_pagenum-1))+1;
        vHasta integer     := p_pagesize*p_pagenum;
    BEGIN
    
    select e.id_registro_patronal into v_reg_patronal from sre_empleadores_t e
    where e.rnc_o_cedula = p_rnc;
    
       if v_reg_patronal is not null and p_ano is not null and p_periodo is not null then
    
            OPEN c_cursor FOR
            with x as (select rownum num,y.* from (
                select C.NOMBRES, C.PRIMER_APELLIDO||' '||nvl(C.SEGUNDO_APELLIDO,'')as APELLIDOS, C.NO_DOCUMENTO,
                t.SALARIO_ISR as SALARIO_ISR, t.OTROS_INGRESOS_ISR as OTROS_INGRESOS_ISR, 
                t.remuneracion_isr_otros as REMUNERACION_ISR_OTROS, t.ingresos_exentos_isr as INGRESOS_EXENTOS_ISR,
                t.total_pagado as TOTAL_PAGADO,t.retencion_ss as RETENCION_SS,t.total_sujeto_retencion as TOTAL_SUJETO_RETENCION,
                t.isr as ISR ,t.impuesto_a_pagar AS IMPUESTO_A_PAGAR,
                t.tipo_trabajador
                from sfc_det_resumen_ir13_v t, sre_ciudadanos_t c
                where c.id_nss = t.ID_NSS
                and c.tipo_documento in('C','P')
                and t.ID_REGISTRO_PATRONAL = v_reg_patronal
                and t.ANO_FISCAL = p_ano
                and t.PERIODO = p_periodo
                ORDER BY APELLIDOS, C.NOMBRES
              )y) select y.recordcount,x.*
              from x,(select max(num) recordcount from x) y
              where num between vDesde and vHasta
              order by num;

            p_iocursor := c_cursor;
            p_resultnumber := 0;
        end if;

    EXCEPTION

        WHEN OTHERS THEN
            v_bderror := (SUBSTR('error '||TO_CHAR(SQLCODE)||': '||SQLERRM, 1, 255));
    	    p_resultnumber := Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
        RETURN;
    END;    
   
--- **************************************************************************************************
-- PROCEDIMIENTO:   Listado_Periodos
-- DESCRIPCION:       
-- **************************************************************************************************

    PROCEDURE Listado_Periodos(
        p_rnc            IN sre_empleadores_t.rnc_o_cedula%TYPE,
        p_ano            in sfc_det_resumen_ir13_t.ano_fiscal%TYPE,
        p_iocursor       IN OUT t_cursor,
        p_resultnumber   OUT VARCHAR2)

    IS
        v_reg_patronal        varchar2(20);
        v_bderror             VARCHAR(1000);
        c_cursor t_cursor;
        
        
    BEGIN
    
    select e.id_registro_patronal into v_reg_patronal from sre_empleadores_t e
    where e.rnc_o_cedula = p_rnc;
    
       if v_reg_patronal is not null and p_ano is not null then
    
            OPEN c_cursor FOR
                select DISTINCT(t.PERIODO) 
                from sfc_det_resumen_ir13_v t
                where t.ID_REGISTRO_PATRONAL = v_reg_patronal
                and t.ANO_FISCAL = p_ano;
            p_iocursor := c_cursor;
            p_resultnumber := 0;
        end if;

    EXCEPTION

        WHEN OTHERS THEN
            v_bderror := (SUBSTR('error '||TO_CHAR(SQLCODE)||': '||SQLERRM, 1, 255));
    	    p_resultnumber := Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
        RETURN;
    END;   

--- **************************************************************************************************
-- PROCEDIMIENTO:   Marcar_Procesado
-- DESCRIPCION:       
-- **************************************************************************************************

    PROCEDURE Marcar_Procesado(
        p_rnc            IN sre_empleadores_t.rnc_o_cedula%TYPE,
        p_ano            in sfc_resumen_ir13_t.ano_fiscal%TYPE,
        p_resultnumber   OUT VARCHAR2)

    IS
        v_reg_patronal        varchar2(20);
        v_bderror             VARCHAR(1000);
        
    BEGIN
    
    select e.id_registro_patronal into v_reg_patronal from sre_empleadores_t e
    where e.rnc_o_cedula = p_rnc;
    
       if v_reg_patronal is not null and p_ano is not null then

    
            update sfc_resumen_ir13_t r
                set r.status = 'P'
                where r.id_registro_patronal = v_reg_patronal
                and r.ano_fiscal = p_ano;
                
            p_resultnumber := 0;    
            commit;
                        
        end if;

    EXCEPTION

        WHEN OTHERS THEN
            v_bderror := (SUBSTR('error '||TO_CHAR(SQLCODE)||': '||SQLERRM, 1, 255));
    	    p_resultnumber := Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
        RETURN;
    END;  
    
--- **************************************************************************************************
-- PROCEDIMIENTO:   Cons_Status
-- DESCRIPCION:       
-- **************************************************************************************************

    PROCEDURE Cons_Status(
        p_rnc            IN sre_empleadores_t.rnc_o_cedula%TYPE,
        p_ano            in sfc_det_resumen_ir13_t.ano_fiscal%TYPE,
        p_iocursor       IN OUT t_cursor,
        p_resultnumber   OUT VARCHAR2)

    IS
    
        v_reg_patronal        NUMBER;    
        v_bderror             VARCHAR(1000);
        c_cursor t_cursor;
       
    BEGIN

    select e.id_registro_patronal into v_reg_patronal from sre_empleadores_t e
    where e.rnc_o_cedula = p_rnc;
    
       if v_reg_patronal is not null and p_ano is not null then
    
            OPEN c_cursor FOR
                select r.status 
                from sfc_resumen_ir13_t r
                where r.id_registro_patronal = v_reg_patronal
                and r.ano_fiscal = p_ano;
            p_iocursor := c_cursor;
            p_resultnumber := 0;
            
        end if;

    EXCEPTION

        WHEN OTHERS THEN
            v_bderror := (SUBSTR('error '||TO_CHAR(SQLCODE)||': '||SQLERRM, 1, 255));
    	    p_resultnumber := Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
        RETURN;
    END;   
      
--- **************************************************************************************************
-- PROCEDIMIENTO:   GET_IR13_HECHAS_EN_DGII  
-- DESCRIPCION:       
-- **************************************************************************************************

    PROCEDURE GET_IR13_HECHAS_EN_DGII(
        p_rnc            IN sre_empleadores_t.rnc_o_cedula%TYPE,
        p_ano            in sfc_det_resumen_ir13_t.ano_fiscal%TYPE,
        p_iocursor       IN OUT t_cursor,
        p_resultnumber   OUT VARCHAR2)

    IS
        v_reg_patronal        varchar2(20);    
        v_bderror             VARCHAR(1000);
        c_cursor t_cursor;
       
    BEGIN

    select e.id_registro_patronal into v_reg_patronal from sre_empleadores_t e
    where e.rnc_o_cedula = p_rnc;
    
       if v_reg_patronal is not null and p_ano is not null then
    
            OPEN c_cursor FOR
                select p.periodo_pago,DECODE(p.tipo_declaracion,'R','RETIFICADA','N','NORMAL')tipo_declaracion,p.status,p.fecha_presentacion,p.fecha_pago,p.total_pagado
                from dgii_pagos_ir3_T p
                where p.id_registro_patronal = v_reg_patronal
                and substr(p.periodo_pago,1,4)= p_ano
                and p.status is null;

            p_iocursor := c_cursor;
            p_resultnumber := 0;
            
        end if;

    EXCEPTION

        WHEN OTHERS THEN
            v_bderror := (SUBSTR('error '||TO_CHAR(SQLCODE)||': '||SQLERRM, 1, 255));
    	    p_resultnumber := Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
        RETURN;
    END;
    
--- **************************************************************************************************
-- PROCEDIMIENTO:   PROCESAR 
-- DESCRIPCION:       
-- **************************************************************************************************

    PROCEDURE PROCESAR(
        p_rnc            IN VARCHAR2,
        p_ano            in NUMBER,
        p_resultnumber   OUT VARCHAR2)

    IS
    
        e_RncInvalido    exception;
--        V_RESULT         VARCHAR2(20);
        v_bderror        VARCHAR(1000);
        i number;
      
    BEGIN
   -- SI P_RESULTNUMBER = O TODO ESTA BIEN, DE LO CONTRARIO P_RESULNUMBER = 650 
   /* Comentado por Task #10995
        if p_rnc is not null and p_ano is not null then
            if not sre_empleadores_pkg.isRncOCedulaValida(p_rnc) then
                raise e_RncInvalido;
            else
  
               -- SRE_PROCESAR_RT_PKG.declaracion_regular(p_rnc,p_ano,V_RESULT);
               -- p_resultnumber:= V_RESULT; 
                  -- Test statements here
              select seg_job_seq.nextval into i from dual;
              insert into seg_job_t (ID_JOB, NOMBRE_JOB, STATUS, FECHA_ENVIO) 
              values (i,'sre_procesar_rt_pkg.declaracion_regular_call('||p_ano||','''||p_rnc||''','||i||');',
               'S',   sysdate);
             commit;
           
            end if;         
        end if; */
		p_resultnumber := '0';
    EXCEPTION
    
        WHEN e_RncInvalido THEN
            p_resultnumber := Seg_Retornar_Cadena_Error(150, NULL, NULL);
        RETURN;    

        WHEN OTHERS THEN
            v_bderror := (SUBSTR('error '||TO_CHAR(SQLCODE)||': '||SQLERRM, 1, 255));
    	      p_resultnumber := Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
        RETURN;
    END;    
    
-- **************************************************************************************************
--  PROCEDIMIENTO:   GET_IR13_ESTATUS_NULO  
--  DESCRIPCION:       
-- **************************************************************************************************

    PROCEDURE GET_IR13_ESTATUS_NULO(
        p_rnc            IN sre_empleadores_t.rnc_o_cedula%TYPE,
        p_ano            in sfc_det_resumen_ir13_t.ano_fiscal%TYPE,
        p_iocursor       IN OUT t_cursor,
        p_resultnumber   OUT VARCHAR2)

    IS
        v_reg_patronal        varchar2(20);    
        v_bderror             VARCHAR(1000);
        c_cursor t_cursor;
       
    BEGIN

    select e.id_registro_patronal into v_reg_patronal from sre_empleadores_t e
    where e.rnc_o_cedula = p_rnc;
    
       if v_reg_patronal is not null and p_ano is not null then
    
            OPEN c_cursor FOR
                select D.PERIODO
                from SFC_DET_RESUMEN_IR13_T D
                where D.ID_REGISTRO_PATRONAL = v_reg_patronal
                and D.ANO_FISCAL= p_ano
                AND D.STATUS IS NULL
                GROUP BY D.PERIODO;

            p_iocursor := c_cursor;
            p_resultnumber := 0;
            
        end if;

    EXCEPTION

        WHEN OTHERS THEN
            v_bderror := (SUBSTR('error '||TO_CHAR(SQLCODE)||': '||SQLERRM, 1, 255));
    	      p_resultnumber := Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
        RETURN;
    END;
        
-- **************************************************************************************************
--  PROCEDIMIENTO:   GET_PERIODOS_VENCIDOS  
--  DESCRIPCION:       
-- **************************************************************************************************

    PROCEDURE GET_PERIODOS_VENCIDOS(
        p_rnc            IN sre_empleadores_t.rnc_o_cedula%TYPE,
        p_ano            in sfc_det_resumen_ir13_t.ano_fiscal%TYPE,
        p_iocursor       IN OUT t_cursor,
        p_resultnumber   OUT VARCHAR2)

    IS
        v_reg_patronal        varchar2(20);    
        v_bderror             VARCHAR(1000);
        c_cursor t_cursor;
       
    BEGIN

    select e.id_registro_patronal into v_reg_patronal from sre_empleadores_t e
    where e.rnc_o_cedula = p_rnc;
    
       if v_reg_patronal is not null and p_ano is not null then
    
            OPEN c_cursor FOR
                select D.PERIODO
                from SFC_DET_RESUMEN_IR13_T D
                where D.ID_REGISTRO_PATRONAL = v_reg_patronal
                and D.ANO_FISCAL= p_ano
                AND D.STATUS = 'V'
                GROUP BY D.PERIODO;

            p_iocursor := c_cursor;
            p_resultnumber := 0;
            
        end if;

    EXCEPTION

        WHEN OTHERS THEN
            v_bderror := (SUBSTR('error '||TO_CHAR(SQLCODE)||': '||SQLERRM, 1, 255));
    	      p_resultnumber := Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
        RETURN;
    END;
    
-- **************************************************************************************************
--  PROCEDIMIENTO:   GET_PERIODOS_OMISOS  
--  DESCRIPCION:       
-- **************************************************************************************************

    PROCEDURE GET_PERIODOS_OMISOS(
        p_rnc            IN sre_empleadores_t.rnc_o_cedula%TYPE,
        p_ano            in sfc_det_resumen_ir13_t.ano_fiscal%TYPE,
        p_iocursor       IN OUT t_cursor,
        p_resultnumber   OUT VARCHAR2)

    IS
        v_reg_patronal        varchar2(20);    
        v_bderror             VARCHAR(1000);
        c_cursor t_cursor;
        
    BEGIN
    
    select e.id_registro_patronal into v_reg_patronal from sre_empleadores_t e
    where e.rnc_o_cedula = p_rnc;
    
       if v_reg_patronal is not null and p_ano is not null then
    
            OPEN c_cursor FOR
                 select to_number(p_ano||'01') periodo from dual union all
                 select to_number(p_ano||'02') periodo from dual union all
                 select to_number(p_ano||'03') periodo from dual union all
                 select to_number(p_ano||'04') periodo from dual union all
                 select to_number(p_ano||'05') periodo from dual union all
                 select to_number(p_ano||'06') periodo from dual union all
                 select to_number(p_ano||'07') periodo from dual union all
                 select to_number(p_ano||'08') periodo from dual union all
                 select to_number(p_ano||'09') periodo from dual union all
                 select to_number(p_ano||'10') periodo from dual union all
                 select to_number(p_ano||'11') periodo from dual union all
                 select to_number(p_ano||'12') periodo from dual
                
                 minus
                (
                 select distinct a.periodo
                 from sfc_det_resumen_ir13_t a
                 where a.id_registro_patronal = v_reg_patronal
                 and a.ano_fiscal = p_ano
                );
                
            p_iocursor := c_cursor;
            p_resultnumber := 0;
            
        end if;

    EXCEPTION

        WHEN OTHERS THEN
            v_bderror := (SUBSTR('error '||TO_CHAR(SQLCODE)||': '||SQLERRM, 1, 255));
    	      p_resultnumber := Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
        RETURN;
    END;    


--- **************************************************************************************************
-- PROCEDIMIENTO:   Desmarcar_Procesado
-- DESCRIPCION:     Para anular la declaracion del IR-13
-- **************************************************************************************************

    PROCEDURE Desmarcar_Procesado(
        p_rnc            in sre_empleadores_t.rnc_o_cedula%TYPE,
        p_ano            in sfc_resumen_ir13_t.ano_fiscal%TYPE,
        p_idusuario      in suirplus.crm_registro_t.id_usuario%TYPE,
        p_resultnumber   OUT VARCHAR2)

    IS
        v_reg_patronal        varchar2(20);
        v_bderror             VARCHAR(1000);
        
    BEGIN
    
    select e.id_registro_patronal into v_reg_patronal from sre_empleadores_t e
    where e.rnc_o_cedula = p_rnc;
    
       if v_reg_patronal is not null and p_ano is not null then

            -- Insertar registro en CRM (tipo 8: Gestion del CAE)
            insert into suirplus.crm_registro_t (
              id_registro_crm, id_registro_patronal, asunto, id_tipo_registro,
              registro_des, id_usuario, fecha_registro
            ) values (
              suirplus.emp_crm_seq.nextval, v_reg_patronal, 'Habilitar IR-13.', 8, 
              'La declaración existente del IR-13 fue anulada y le fue habilitado de nuevo '||
              'la opción para que el empleador pueda hacer la declaración nuevamente.', 
              p_idusuario, sysdate
            );

            update sfc_resumen_ir13_t r
                set r.status = NULL   -- Descmarcar el estatus de procesado.
                where r.id_registro_patronal = v_reg_patronal
                and r.ano_fiscal = p_ano;
                
            p_resultnumber := 0;    
            commit;
                        
        end if;

    EXCEPTION

        WHEN OTHERS THEN
            v_bderror := (SUBSTR('error '||TO_CHAR(SQLCODE)||': '||SQLERRM, 1, 255));
    	    p_resultnumber := Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
        RETURN;
    END;  

end SFC_IR13; 