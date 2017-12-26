CREATE OR REPLACE PACKAGE BODY Suirplus.Srp_Pkg AS

-- *****************************************************************************************************
-- Program:		srp_pkg
-- Descripcion: Subprogramas de miscelaneos en general.
--
-- Modification History
-- -----------------------------------------------------------------------------------------------------
-- date	  by remark
-- -----------------------------------------------------------------------------------------------------
-- 291104 dp Creation
-- 300305 rc Adición función getProximoPeriodo.
-- 300305 dp Modificación a la carga rangos anuales ISR de Pensionados.
-- 130405 dp Adición función fecha_limite_pago_ss.
-- 130405 dp Adición función fecha_limite_pago_isr.
-- 050505 dp Correcion funcion is_holiday (trunc en las fechas).
-- 060505 dp Se corrigió incompatibilidad en tab y rec.
-- 270605 dp Inclusión variable p_parm para procesos llamados desde Parm.
-- 280605 dp Bitacora se puso que obtuviera de sfc_procesos_t el parámetro is_bitacora.
-- 260705 dp Sustitucion de envia_mail por text_mail (hab[ia problema para instalar el paquete anterior
--           en el nuevo servidor).
-- 090905 dp Inclusion de inizializar_recargos_ss_parm exclusión de los parametros de Recargoes e
--           Intereses SS en inicializar Parm
-- 130905 dp Se truncaron todas las fechas que se retornan en funciones y se comparan en querry.
-- 221105 dp En caso que no exista el periodo en tabla de rangos de ISR, toma el último año existente.
-- 010306 dp Se corrigio variablea en notifica_msg
-- 041206 dp Inclusion get_periodo_vigente
-- 170706 dp Inclusion get_fecha_facturacion
-- 300107 dp Corrección cursor para carga rango ISR en initialize_isr_parm   Se incluyó el ORDER BY.
--           Si los parametros no se insertaban en orden, el programa abortaba.
-- 190207 dp Inclusion is_YYYYMM para validar periodo en ese formato.
-- 220207 dp Inclusion initialize_parm_infotep.
-- 240707 dp Cambio en carga tabla de rangos anuales de ISR. Antes era por año, ahora es por rango de
--           periodo.
-- 080807 dp Inclusion fecha_efectiva_pago_ss.
-- 130807 dp Inclusion initialize_lfp_parm.
-- 201107 dp Inclusion DB_NAME en el mail para determinal si es de Prueba o Produccion.
-- 010510 dp Replace procedure initialize_parm by function get_parm_tbl
-- 131212 dp Inclusion de p_dia en fecha_limite_de_pago 
--
-- (dp - David Pineda, rc - Ronny Carreras)
-- *****************************************************************************************************

FUNCTION is_holiday (
	p_day 									DATE
) RETURN BOOLEAN IS

	v_return   								BOOLEAN := FALSE;
	v_dummy    								VARCHAR2(5);

	CURSOR c_fer IS
		SELECT 'DUMMY'
		  FROM SCO_DIAS_FERIADOS_T
		 WHERE TRUNC(dia_feriado) = TRUNC(p_day); --dp050505

BEGIN

	OPEN c_fer;
	FETCH c_fer INTO v_dummy;
	IF c_fer%FOUND THEN
	   v_return := TRUE;
	ELSE
	   v_return := FALSE;
	END IF;
	CLOSE c_fer;

	RETURN v_return;

END is_holiday;

-- *****************************************************************************************************

FUNCTION business_date (
	p_start_date 							DATE,
	p_Days2Add 								NUMBER
) RETURN DATE IS

	v_Counter  								NATURAL := 0;
	v_CurDate  								DATE := p_start_date;
	v_DayNum   								POSITIVE;
	v_SkipCntr 								NATURAL := 0;

BEGIN
  	WHILE v_Counter < p_Days2Add LOOP
  		v_CurDate := v_CurDate + 1;
    	v_DayNum := TO_CHAR(v_CurDate, 'D');

    	IF (v_DayNum BETWEEN 2 AND 6) AND NOT is_holiday(v_CurDate) THEN
    	  	v_Counter := v_Counter + 1;
    	ELSE
      		v_SkipCntr := v_SkipCntr + 1;
    	END IF;
  	END LOOP;
  	RETURN p_start_date + v_Counter + v_SkipCntr;
END business_date;

-- *****************************************************************************************************

FUNCTION fday_of_month(
	value_in 								DATE
) RETURN DATE IS

	v_Mo 									VARCHAR2(2);
	v_Yr 									VARCHAR2(4);

BEGIN
  	v_Mo := TO_CHAR(value_in, 'MM');
  	v_Yr := TO_CHAR(value_in, 'YYYY');
  	RETURN TO_DATE(v_Mo || '-01-' || v_Yr, 'MM-DD-YYYY');

EXCEPTION
  	WHEN OTHERS THEN
    	RETURN TO_DATE('01-01-1900', 'MM-DD-YYYY');

END fday_of_month;

-- *****************************************************************************************************

FUNCTION fecha_inicio_periodo(
	p_periodo 								NUMBER
) RETURN DATE IS

BEGIN
 	RETURN TRUNC(business_date(LAST_DAY(ADD_MONTHS(TO_DATE('01'||TO_CHAR(p_periodo),
 		'DDYYYYMM'), -1)), 3) + 1); --dp130905
END fecha_inicio_periodo;

-- *****************************************************************************************************

FUNCTION fecha_fin_periodo(
	p_periodo 								NUMBER
) RETURN DATE IS

BEGIN
   	RETURN TRUNC(business_date( LAST_DAY(TO_DATE('01'||TO_CHAR(p_periodo), 'DDYYYYMM')), 3)); --dp130905
END fecha_fin_periodo;

-- *****************************************************************************************************

FUNCTION fecha_limite_pago_ss(
-- Descripcion: Dado un periodo retorna la fecha límite pago SS de éste.
-- 13/04/2005	David Pineda 	Creation
	p_periodo 								NUMBER
) RETURN DATE IS

BEGIN
	-- Tercer día hábil del mes siguiente
	RETURN TRUNC(business_date(LAST_DAY(TO_DATE('01'||TO_CHAR(p_periodo), 'DDYYYYMM')), 3)); --dp130905
END fecha_limite_pago_ss;

-- *****************************************************************************************************

FUNCTION fecha_limite_pago_isr(
-- Descripcion: Dado un periodo retorna la fecha límite pago ISR de éste.
-- 13/04/2005	David Pineda 	Creation
	p_periodo 								NUMBER,
	p_dia 									NUMBER DEFAULT 10 --dp131212
) RETURN DATE IS

	v_date    								DATE;
	v_dia    								VARCHAR(2);

BEGIN

	-- El día 10 del mes siguiente ó el siguiente día hábil si el 10 es no laborable
	--RETURN TRUNC(business_date(ADD_MONTHS(TO_DATE('09'||TO_CHAR(p_periodo), 'DDYYYYMM'), 1), 1)); --dp130905 --dp131212
	v_dia := TO_CHAR(p_dia - 1);
	if LENGTH(v_dia) = 1 then
		v_dia := '0'||v_dia;
	end if;
	RETURN TRUNC(business_date(ADD_MONTHS(TO_DATE(v_dia||TO_CHAR(p_periodo), 'DDYYYYMM'), 1), 1)); --dp130905

END fecha_limite_pago_isr;

-- *****************************************************************************************************

FUNCTION add_periodo(
	p_periodo								NUMBER,
	p_mes 								    NUMBER
) RETURN NUMBER IS

BEGIN
   RETURN TO_NUMBER(TO_CHAR(ADD_MONTHS(TO_DATE('01'||TO_CHAR(p_periodo), 'DDYYYYMM'), p_mes), 'YYYYMM'));
END add_periodo;

-- *****************************************************************************************************

FUNCTION periodo_YYYYMM(
	p_periodo_MMYYYY							VARCHAR2
) RETURN NUMBER IS

BEGIN
   RETURN TO_NUMBER(SUBSTR(p_periodo_MMYYYY,3,4) || SUBSTR(p_periodo_MMYYYY,1,2));
END periodo_YYYYMM;

-- *****************************************************************************************************

FUNCTION periodo_MMYYYY(
	p_periodo_YYYYMM							NUMBER
) RETURN VARCHAR IS

BEGIN
   RETURN SUBSTR(TO_CHAR(p_periodo_YYYYMM),5,2) || SUBSTR(TO_CHAR(p_periodo_YYYYMM),1,4);
END periodo_MMYYYY;

FUNCTION mmyyyy_like (
	p_yyyymm									varchar2
) RETURN VARCHAR2 IS

BEGIN
   RETURN SUBSTR(p_YYYYMM,5,2) || SUBSTR(p_YYYYMM,1,4) || '%';
END mmyyyy_like;

-- *****************************************************************************************************

FUNCTION fecha_corrida_recargo_ss(
	p_periodo								NUMBER
) RETURN DATE IS

	v_fecha_corrida_recargo_ss				DATE;

	CURSOR c_rec IS
		  SELECT   fecha_ini
			FROM SFC_DET_PARAMETRO_T
		   WHERE id_parametro = 32
			 AND fecha_ini >=
						Srp_Pkg.fecha_inicio_periodo (Srp_Pkg.add_periodo (p_periodo, 1))
			 AND autorizado = 'S'
		ORDER BY fecha_ini;

BEGIN

	OPEN c_rec;
	FETCH c_rec INTO v_fecha_corrida_recargo_ss;
	CLOSE c_rec;

	RETURN TRUNC(v_fecha_corrida_recargo_ss); --dp130905

END fecha_corrida_recargo_ss;

-- *****************************************************************************************************

--dp080807
FUNCTION fecha_limite_acuerdo_pago (
	p_periodo								NUMBER
) RETURN DATE IS

	v_fecha_efectiva_pago_ss				DATE;

	CURSOR c_rec IS
		  SELECT max(fecha_fin)
			FROM SFC_DET_PARAMETRO_T
		   WHERE id_parametro = 32
			 AND autorizado = 'S';

BEGIN

	OPEN c_rec;
	FETCH c_rec INTO v_fecha_efectiva_pago_ss;
	CLOSE c_rec;

	RETURN TRUNC(v_fecha_efectiva_pago_ss);

END fecha_limite_acuerdo_pago;
--end dp080807

-- *****************************************************************************************************

PROCEDURE bitacora (
	p_id_bitacora IN OUT				    SFC_BITACORA_T.id_bitacora%TYPE,
	p_accion  IN						    VARCHAR2 DEFAULT 'INI',
	p_id_proceso IN    				    	SFC_BITACORA_T.id_proceso%TYPE,
	p_mensage IN						    SFC_BITACORA_T.mensage%TYPE DEFAULT NULL,
	p_status IN							    SFC_BITACORA_T.status%TYPE DEFAULT NULL,
	p_id_error IN							SEG_ERROR_T.id_error%TYPE DEFAULT NULL,
	p_seq_number IN							ERRORS.seq_number%TYPE DEFAULT NULL,
	p_periodo IN							SFC_BITACORA_T.periodo%TYPE DEFAULT NULL
) IS
PRAGMA AUTONOMOUS_TRANSACTION;

	v_seq_periodo 							SFC_BITACORA_T.periodo%TYPE;
	v_is_bitacora1 							SFC_PROCESOS_T.is_bitacora%TYPE; --dp050628
	v_is_bitacora 							BOOLEAN; --dp050628
	CURSOR c_bit IS
	    SELECT is_bitacora
		  FROM SFC_PROCESOS_T
	     WHERE id_proceso = p_id_proceso;

BEGIN

	OPEN c_bit;
	FETCH c_bit INTO v_is_bitacora1;
	IF v_is_bitacora1 = 'S' THEN
	   v_is_bitacora := TRUE;
	ELSE
	   v_is_bitacora := FALSE;
	END IF;
	CLOSE c_bit;
	IF NOT v_is_bitacora THEN RETURN; END IF; --dp050628

	IF p_periodo IS NOT NULL THEN v_seq_periodo := 0; END IF;

	CASE p_accion
	WHEN 'INI' THEN
		SELECT sfc_bitacora_seq.NEXTVAL INTO p_id_bitacora FROM dual;
		INSERT INTO SFC_BITACORA_T
			(id_proceso, id_bitacora, fecha_inicio, fecha_fin, mensage, status, periodo)
		VALUES
			(p_id_proceso, p_id_bitacora, SYSDATE, NULL, NULL, 'P', p_periodo);
	WHEN 'FIN' THEN
		UPDATE SFC_BITACORA_T
			SET fecha_fin = (SELECT SYSDATE FROM dual),
				mensage = p_mensage,
				status = p_status,
			    seq_number = p_seq_number,
			    id_error = p_id_error
		 WHERE id_bitacora = p_id_bitacora;
	ELSE
		RAISE_APPLICATION_ERROR(010, 'Parámetro invalido');
	END CASE;

	COMMIT WORK;

END bitacora;

-- *****************************************************************************************************

FUNCTION is_proceso_ejecutado (
	p_id_proceso IN    				    	SFC_BITACORA_T.id_proceso%TYPE,
	p_periodo IN						    SFC_BITACORA_T.periodo%TYPE
) RETURN BOOLEAN IS

	v_status								SFC_BITACORA_T.status%TYPE;
	v_return 								BOOLEAN := FALSE;

	CURSOR c_pro IS
	    SELECT status
		  FROM SFC_BITACORA_T
	     WHERE id_proceso = p_id_proceso
	       AND periodo = p_periodo
  	      --dpqd and seq_periodo = 0
	       AND status = 'O';

BEGIN

	OPEN c_pro;
	FETCH c_pro INTO v_status;
	IF c_pro%FOUND THEN v_return := TRUE; END IF;
	CLOSE c_pro;

	RETURN v_return;

END is_proceso_ejecutado;

-- *****************************************************************************************************

FUNCTION is_continua_proceso (
	p_periodo IN						    SFC_BITACORA_T.periodo%TYPE,
	p_id_proceso IN    				    	SFC_BITACORA_T.id_proceso%TYPE,
	p_id_proceso_previo IN    				SFC_BITACORA_T.id_proceso%TYPE
) RETURN BOOLEAN IS

BEGIN

	IF NOT is_proceso_ejecutado(p_id_proceso,p_periodo) AND
	  	is_proceso_ejecutado(p_id_proceso_previo, p_periodo)
	THEN
		RETURN TRUE;
	ELSE
		RETURN FALSE;
	END IF;

END is_continua_proceso;

-- *****************************************************************************************************

PROCEDURE is_proceso_ok (
	p_id_proceso IN    				    	SFC_BITACORA_T.id_proceso%TYPE,
	p_periodo IN						    SFC_BITACORA_T.periodo%TYPE,
	p_respuesta OUT						   	VARCHAR2
) IS

BEGIN

	IF NOT is_proceso_ejecutado(p_id_proceso, p_periodo) THEN
		p_respuesta := 'S';
	ELSE
		p_respuesta := 'N';
	END IF;

END is_proceso_ok;

-- *****************************************************************************************************

FUNCTION get_mensage (
	p_id_error IN    				    	SEG_ERROR_T.id_error%TYPE
) RETURN SEG_ERROR_T.error_des%TYPE IS

	v_mensage								SEG_ERROR_T.error_des%TYPE;

	CURSOR c_msg IS
	    SELECT error_des
		  FROM SEG_ERROR_T
	     WHERE id_error = p_id_error;
BEGIN

	OPEN c_msg; FETCH c_msg INTO v_mensage; CLOSE c_msg;
	RETURN v_mensage;

END get_mensage;

-- *****************************************************************************************************

--PROCEDURE initialize_parm ( --dp010510
FUNCTION get_parm_tbl (
	p_periodo 							    SFC_FACTURAS_T.periodo_factura%TYPE
-- 	p_parm OUT 								t_parm_tbl --dp050627 --dp010510
) return t_parm_tbl 
RESULT_CACHE RELIES_ON (sfc_parametros_t, sfc_det_parametro_t)
IS 

   	v_parm_tbl 								t_parm_tbl; --dp010510
	v_periodo_fin 						    SFC_FACTURAS_T.periodo_factura%TYPE;
	v_date_fin								DATE;

	-- Parametros Interes
	CURSOR c_parm_1 IS
		SELECT b.fecha_fin, b.valor_fecha, b.valor_numerico, b.valor_texto, a.tipo_parametro,
				b.id_parametro
		  FROM SFC_PARAMETROS_T a,
		       SFC_DET_PARAMETRO_T b
	     WHERE a.id_parametro = b.id_parametro
	       AND TRUNC(NVL(b.fecha_fin, v_ultimo_dia )) >=
		       fecha_fin_periodo(add_periodo(p_periodo, 1)) --dp130905
	       AND b.autorizado = 'S'
	       AND a.tipo_calculo = '1'
	       AND a.id_parametro NOT IN (29,30,31,32,33,34) --dp090905
		   ORDER BY b.id_parametro, b.fecha_ini;

	-- Parametros Porcentajes Rubros y Topes
	CURSOR c_parm_2 IS
		SELECT b.fecha_fin, b.valor_fecha, b.valor_numerico, b.valor_texto, a.tipo_parametro,
				b.id_parametro
		  FROM SFC_PARAMETROS_T a,
		       SFC_DET_PARAMETRO_T b
	     WHERE a.id_parametro = b.id_parametro
	       AND TO_DATE ('01' || TO_CHAR (p_periodo), 'DDYYYYMM')
	           BETWEEN  b.fecha_ini
		       AND TRUNC(NVL(b.fecha_fin,v_ultimo_dia)) --dp130905
	       AND b.autorizado = 'S'
	       AND a.tipo_calculo = '2'
	       AND a.id_parametro NOT IN (29,30,31,32,33,34) --dp090905
		    ORDER BY b.id_parametro, b.fecha_ini;

	-- Parametros Recargos
	CURSOR c_parm_3 IS
		SELECT b.fecha_fin, b.valor_fecha, b.valor_numerico, b.valor_texto, a.tipo_parametro,
				b.id_parametro
		  FROM SFC_PARAMETROS_T a,
		       SFC_DET_PARAMETRO_T b
	     WHERE a.id_parametro = b.id_parametro
		   AND fecha_inicio_periodo(add_periodo(p_periodo, 1))
			BETWEEN TRUNC(b.fecha_ini) AND TRUNC(NVL(b.fecha_fin, v_ultimo_dia))
	       AND b.autorizado = 'S'
	       AND a.tipo_calculo = '3'
	       AND a.id_parametro NOT IN (29,30,31,32,33,34) --dp090905
		   ORDER BY b.id_parametro, b.fecha_ini;

BEGIN

	FOR i IN c_parm_1 LOOP
		IF NOT v_parm_tbl.EXISTS(i.id_parametro) THEN
			v_parm_tbl(i.id_parametro).valor_fecha		:= i.valor_fecha;
			v_parm_tbl(i.id_parametro).valor_numerico	:= i.valor_numerico;
			v_parm_tbl(i.id_parametro).valor_texto		:= i.valor_texto;
			v_parm_tbl(i.id_parametro).tipo_parametro	:= i.tipo_parametro;
		END IF;
	END LOOP;
	FOR i IN c_parm_2 LOOP
		IF NOT v_parm_tbl.EXISTS(i.id_parametro) THEN
			v_parm_tbl(i.id_parametro).valor_fecha		:= i.valor_fecha;
			v_parm_tbl(i.id_parametro).valor_numerico	:= i.valor_numerico;
			v_parm_tbl(i.id_parametro).valor_texto		:= i.valor_texto;
			v_parm_tbl(i.id_parametro).tipo_parametro	:= i.tipo_parametro;
		END IF;
	END LOOP;
	FOR i IN c_parm_3 LOOP
		IF NOT v_parm_tbl.EXISTS(i.id_parametro) THEN
			v_parm_tbl(i.id_parametro).valor_fecha		:= i.valor_fecha;
			v_parm_tbl(i.id_parametro).valor_numerico	:= i.valor_numerico;
			v_parm_tbl(i.id_parametro).valor_texto		:= i.valor_texto;
			v_parm_tbl(i.id_parametro).tipo_parametro	:= i.tipo_parametro;
		END IF;
	END LOOP;

	return v_parm_tbl; 

--END initialize_parm;
END get_parm_tbl;

-- *****************************************************************************************************

-- Descripcion: Inicializa tabla de parametros de Recargos SS
-- 09/09/2005	David Pineda 	Creation
PROCEDURE initialize_recargos_ss_parm (
	p_periodo 							    SFC_FACTURAS_T.periodo_factura%TYPE,
 	p_parm OUT 								t_parm_tbl
) IS

	v_periodo_fin 						    SFC_FACTURAS_T.periodo_factura%TYPE;
	v_date_fin								DATE;

	-- Parametros Interes
	CURSOR c_parm_1 IS
		SELECT b.fecha_fin, b.valor_fecha, b.valor_numerico, b.valor_texto, a.tipo_parametro,
				b.id_parametro
		  FROM SFC_PARAMETROS_T a,
		       SFC_DET_PARAMETRO_T b
	     WHERE a.id_parametro = b.id_parametro
	       AND NVL(b.fecha_fin, v_ultimo_dia ) >=
		       fecha_fin_periodo(add_periodo(p_periodo, 1))
	       AND b.autorizado = 'S'
	       AND a.tipo_calculo = '1'
	       AND a.id_parametro IN (29,30,31,32,33,34)
		   ORDER BY b.id_parametro, b.fecha_ini;

	-- Parametros Recargos
	CURSOR c_parm_3 IS
		SELECT b.fecha_fin, b.valor_fecha, b.valor_numerico, b.valor_texto, a.tipo_parametro,
				b.id_parametro
		  FROM SFC_PARAMETROS_T a,
		       SFC_DET_PARAMETRO_T b
	     WHERE a.id_parametro = b.id_parametro
		   AND fecha_inicio_periodo(add_periodo(p_periodo, 1))
			BETWEEN TRUNC(b.fecha_ini) AND TRUNC(NVL(b.fecha_fin, v_ultimo_dia)) --dp130905
	       AND b.autorizado = 'S'
	       AND a.tipo_calculo = '3'
	       AND a.id_parametro IN (29,30,31,32,33,34)
		   ORDER BY b.id_parametro, b.fecha_ini;

BEGIN

	FOR i IN c_parm_1 LOOP
		IF NOT p_parm.EXISTS(i.id_parametro) THEN
			p_parm(i.id_parametro).valor_fecha		:= i.valor_fecha;
			p_parm(i.id_parametro).valor_numerico	:= i.valor_numerico;
			p_parm(i.id_parametro).valor_texto		:= i.valor_texto;
			p_parm(i.id_parametro).tipo_parametro	:= i.tipo_parametro;
		END IF;
	END LOOP;
	FOR i IN c_parm_3 LOOP
		IF NOT p_parm.EXISTS(i.id_parametro) THEN
			p_parm(i.id_parametro).valor_fecha		:= i.valor_fecha;
			p_parm(i.id_parametro).valor_numerico	:= i.valor_numerico;
			p_parm(i.id_parametro).valor_texto		:= i.valor_texto;
			p_parm(i.id_parametro).tipo_parametro	:= i.tipo_parametro;
		END IF;
	END LOOP;

END initialize_recargos_ss_parm;


PROCEDURE initialize_lfp_parm (
	p_periodo 							    SFC_FACTURAS_T.periodo_factura%TYPE,
 	p_parm OUT 								t_parm_tbl
) IS

	v_periodo_fin 						    SFC_FACTURAS_T.periodo_factura%TYPE;
	v_date_fin								DATE;

	-- Parametros Interes
	CURSOR c_parm_1 IS
		SELECT b.fecha_fin, b.valor_fecha, b.valor_numerico, b.valor_texto, a.tipo_parametro,
				b.id_parametro
		  FROM SFC_PARAMETROS_T a,
		       SFC_DET_PARAMETRO_T b
	     WHERE a.id_parametro = b.id_parametro
	       AND NVL(b.fecha_fin, v_ultimo_dia ) >=
		       fecha_fin_periodo(add_periodo(p_periodo, 1))
	       AND b.autorizado = 'S'
	       AND a.tipo_calculo = '1'
	       AND a.id_parametro = 132
		   ORDER BY b.id_parametro, b.fecha_ini;

BEGIN

	FOR i IN c_parm_1 LOOP
		IF NOT p_parm.EXISTS(i.id_parametro) THEN
			p_parm(i.id_parametro).valor_fecha		:= i.valor_fecha;
			p_parm(i.id_parametro).valor_numerico	:= i.valor_numerico;
			p_parm(i.id_parametro).valor_texto		:= i.valor_texto;
			p_parm(i.id_parametro).tipo_parametro	:= i.tipo_parametro;
		END IF;
	END LOOP;

END initialize_lfp_parm;

-- *****************************************************************************************************

--dp220207
PROCEDURE initialize_parm_infotep (
	p_periodo 							    SFC_FACTURAS_T.periodo_factura%TYPE,
 	p_parm OUT 								t_parm_tbl --dp050627
) IS

	v_periodo_fin 						    SFC_FACTURAS_T.periodo_factura%TYPE;
	v_date_fin								DATE;

	CURSOR c_parm_2 IS
		SELECT b.fecha_fin, b.valor_fecha, b.valor_numerico, b.valor_texto, a.tipo_parametro,
				b.id_parametro
		  FROM SFC_PARAMETROS_T a,
		       SFC_DET_PARAMETRO_T b
	     WHERE a.id_parametro = b.id_parametro
	       AND TO_DATE ('01' || TO_CHAR (p_periodo), 'DDYYYYMM')
	           BETWEEN  b.fecha_ini
		       AND TRUNC(NVL(b.fecha_fin,v_ultimo_dia))
	       AND b.autorizado = 'S'
	       -- AND a.tipo_calculo = '2'
	       AND a.id_parametro IN (200,201,202)
		    ORDER BY b.id_parametro, b.fecha_ini;

BEGIN

	FOR i IN c_parm_2 LOOP
		IF NOT p_parm.EXISTS(i.id_parametro) THEN
			p_parm(i.id_parametro).valor_fecha		:= i.valor_fecha;
			p_parm(i.id_parametro).valor_numerico	:= i.valor_numerico;
			p_parm(i.id_parametro).valor_texto		:= i.valor_texto;
			p_parm(i.id_parametro).tipo_parametro	:= i.tipo_parametro;
		END IF;
	END LOOP;

END initialize_parm_infotep;
--end dp220207

-- *****************************************************************************************************

PROCEDURE initialize_isr_parm (
	P         							    Parm,
	p_periodo 							    SFC_FACTURAS_T.periodo_factura%TYPE
) IS
	--v_ano   								NUMBER; --dp240707
	v_periodo   							NUMBER; --dp240707
	v_dummy       							NUMBER; --dp221105
	v_ndx     							    BINARY_INTEGER;
	v_ndx_next 							    BINARY_INTEGER;
	v_ndx_pens 							    BINARY_INTEGER;
	n          							    BINARY_INTEGER;
	l           	 					    BINARY_INTEGER;
	i          							    BINARY_INTEGER;
	f							    		BINARY_INTEGER;
	v_isr_tmp								t_isr_tbl;
	v_isr_hld								t_isr_rec; -- dp060504
--	v_isr_hld								t_isr_tbl; -- En una versión hubo incompativilidad con un
													   -- record y se tuvo que poner una tabla usandola
													   -- luego como indice 1 (v_isr_hld)

 	--dp221105
	CURSOR c_get_isr (
		--p_ano 							NUMBER  dp240707
		p_periodo 							NUMBER
	) IS
	    SELECT 1
		  FROM SFC_RANGOS_ANUALES_ISR_NEW_T
--		 WHERE ano = p_ano;  dp240707
 		 WHERE p_periodo between periodo_ini and periodo_fin;

	CURSOR c_isr (
		--p_ano 							NUMBER  dp240707
		p_periodo 							NUMBER
	) IS
	    SELECT rni_desde, rni_hasta, impuesto_fijo, porciento_excedente / 100, NULL
		  FROM SFC_RANGOS_ANUALES_ISR_NEW_T
--		 WHERE ano = p_ano  dp240707
 		 WHERE p_periodo between periodo_ini and periodo_fin
         ORDER BY rni_desde; -- dp300107
--dpqd
	CURSOR c_isr_pen (
		p_periodo 							NUMBER
	) IS
	    SELECT rni_desde, rni_hasta, impuesto_fijo, porciento_excedente / 100, NULL
		  FROM SFC_RANGOS_ANUALES_ISR_pen_T
 		 WHERE p_periodo between periodo_ini and periodo_fin
         ORDER BY rni_desde;
--end dpqd

BEGIN

	-- Carga tabla de rangos anuales de ISR
	--
 	--dp221105
	--v_ano := TO_NUMBER(SUBSTR(p_periodo,1,4));  dp240707
	--OPEN c_get_isr(v_ano);
	v_periodo := p_periodo;  --dp240707
	OPEN c_get_isr(p_periodo);
	FETCH c_get_isr INTO v_dummy;
	IF c_get_isr%NOTFOUND THEN
		SELECT MAX(periodo_ini) INTO v_periodo FROM SFC_RANGOS_ANUALES_ISR_NEW_T;
	END IF;
	CLOSE c_get_isr;
	IF v_periodo IS NULL THEN
		RAISE_APPLICATION_ERROR(010, 'Parámetro invalido: Tabla ISR vacia');
	END IF;
	--
	OPEN c_isr(v_periodo); --dp221105
	FETCH c_isr BULK COLLECT INTO v_isr;
	CLOSE c_isr;

	--dpqd
	OPEN c_isr_pen(v_periodo);
	FETCH c_isr_pen BULK COLLECT INTO v_isr_pens;
	CLOSE c_isr_pen;
	return;
	--end dpqd

	-- Carga tabla de rangos anuales de ISR para Pensionados y modifica información según parametros
	-- de salario mínimo

	OPEN c_isr(v_periodo); --dp221105
	FETCH c_isr BULK COLLECT INTO v_isr_tmp;
	CLOSE c_isr;

	--Actualiza nuevos rangos si son menores al tope exencion
	--
	-- Si el primer rango es mayor que el tope exencion, no hay nada que buscar
	v_ndx := v_isr_tmp.first;
	IF v_isr_tmp(v_ndx).rni_hasta >= P.isr_tope_exencion_pens THEN RETURN; END IF;
	--
	LOOP
		IF v_isr_tmp(v_ndx).rni_hasta < P.isr_tope_exencion_pens THEN
			v_ndx_next := v_isr_tmp.NEXT(v_ndx);
			v_isr_tmp(v_ndx_next).rni_desde := P.isr_tope_exencion_pens + 0.01;
			v_isr_tmp.extend;
			v_isr_tmp(v_isr_tmp.last).rni_desde := 0;
			v_isr_tmp(v_isr_tmp.last).rni_hasta := P.isr_tope_exencion_pens;
			v_isr_tmp(v_isr_tmp.last).impuesto_fijo := 0;
			v_isr_tmp(v_isr_tmp.last).porciento_excedente := 0;
		END IF;
		EXIT WHEN v_ndx = v_isr_tmp.last;
		v_ndx := v_isr_tmp.NEXT(v_ndx);
	END LOOP;
	--
	v_isr_pens := t_isr_tbl(); v_isr_pens.DELETE;
	FOR v_ndx IN v_isr_tmp.first..v_isr_tmp.last LOOP
		IF v_isr_tmp(v_ndx).rni_hasta >= P.isr_tope_exencion_pens THEN
			v_isr_pens.extend;
			v_isr_pens(v_isr_pens.last) := v_isr_tmp(v_ndx);
		END IF;
	END LOOP;

	--Sortea
	--v_isr_hld := t_isr_tbl(); --dp060505
	FOR n IN 2..v_isr_pens.last LOOP
		IF v_isr_pens(n).rni_desde < v_isr_pens(n - 1).rni_desde THEN
			--v_isr_hld(1) := v_isr_pens(n); --dp060505
			v_isr_hld := v_isr_pens(n); --dp060505
			i := v_isr_pens.first;
			WHILE v_isr_pens(n).rni_desde >= v_isr_pens(i).rni_desde LOOP
				i := v_isr_pens.NEXT(i);
			END LOOP;
			f := n - 1;	l := f + 1;
			LOOP
				l := l - 1;
				v_isr_pens(l + 1) := v_isr_pens(l);
				EXIT WHEN l = i;
			END LOOP;
			--v_isr_pens(i) := v_isr_hld(1); --dp060505
			v_isr_pens(i) := v_isr_hld; --dp060505
		END IF;
	END LOOP;

	--Calcula impuesto_fijo
	v_ndx := v_isr_pens.first;
	v_isr_pens(v_ndx).impuesto_fijo := 0;
	LOOP
		EXIT WHEN v_ndx = v_isr_pens.last;
		v_ndx_next := v_isr_pens.NEXT(v_ndx);
		v_isr_pens(v_ndx_next).impuesto_fijo :=
			((v_isr_pens(v_ndx).rni_hasta + 0.01 - v_isr_pens(v_ndx).rni_desde) *
			  v_isr_pens(v_ndx).porciento_excedente
			) + v_isr_pens(v_ndx).impuesto_fijo;
		v_ndx := v_ndx_next;
	END LOOP;


END initialize_isr_parm;

-- *****************************************************************************************************

FUNCTION numero (
	p_id_parametro 							SFC_DET_PARAMETRO_T.id_parametro%TYPE,
 	p_parm  								t_parm_tbl --dp050627
) RETURN SFC_DET_PARAMETRO_T.valor_numerico%TYPE IS
BEGIN
	IF p_parm.EXISTS(p_id_parametro) AND
	   p_parm(p_id_parametro).tipo_parametro = 'N'
	THEN
		RETURN p_parm(p_id_parametro).valor_numerico;
	ELSE
		RETURN 0;
	END IF;
END numero;

FUNCTION fecha (
	p_id_parametro 							SFC_DET_PARAMETRO_T.id_parametro%TYPE,
 	p_parm  								t_parm_tbl --dp050627
) RETURN SFC_DET_PARAMETRO_T.valor_fecha%TYPE IS
BEGIN
	IF p_parm.EXISTS(p_id_parametro) AND
	   p_parm(p_id_parametro).tipo_parametro = 'F'
	THEN
		RETURN TRUNC(p_parm(p_id_parametro).valor_fecha); --dp130905
	ELSE
		RETURN NULL;
	END IF;
END fecha;

-- *****************************************************************************************************

FUNCTION fmt_mnt (
	p_monto 								NUMBER,
	p_fmt 									varchar2 default '1'
) RETURN VARCHAR2 IS
	v_fmt_mnt 								varchar2(18);
BEGIN
	case p_fmt
	when '1' then
		v_fmt_mnt := 'RD'||LTRIM(TO_CHAR(NVL(p_monto,0), '$999,999,990.99'));
	when '2' then
		if p_monto = 0 then
		   v_fmt_mnt := '0.00';
		else
		   v_fmt_mnt := TRIM (TO_CHAR (p_monto, '999,999,999,999.99'));
		end if;
	end case;
	return v_fmt_mnt;
END fmt_mnt;


FUNCTION fmt_referencia (
	p_id_referencia 						SFC_FACTURAS_T.id_referencia%TYPE
) RETURN VARCHAR2 IS

BEGIN
	RETURN SUBSTR(p_id_referencia,1,4) || '-' || SUBSTR(p_id_referencia,5,4) || '-' ||
		   SUBSTR(p_id_referencia,9,4) || '-' || SUBSTR(p_id_referencia,13,4);
END fmt_referencia;


FUNCTION fmt_tel (
	p_telefono 								sre_empleadores_t.telefono_1%TYPE
) RETURN VARCHAR2 IS
	v_fmt_tel 								varchar2(12);
BEGIN
   	if LENGTH(p_telefono) = 10 then
		v_fmt_tel := SUBSTR (p_telefono, 1, 3) || '-' || SUBSTR (p_telefono, 4, 3)
                  || '-' || SUBSTR (p_telefono, 7, 4);
  	else
		v_fmt_tel := p_telefono;
  	end if;
	RETURN v_fmt_tel;
END fmt_tel;


FUNCTION fmt_periodo (
	p_periodo 								sfc_facturas_v.periodo_factura%TYPE
) RETURN VARCHAR2 IS
	v_fmt_periodo 							varchar2(07);
BEGIN
 	return SUBSTR (p_periodo, 5, 2) || '-' || SUBSTR (p_periodo, 1, 4);
END fmt_periodo;


FUNCTION fmt_no_documento (
	p_no_documento 							sre_ciudadanos_t.no_documento%TYPE
) RETURN VARCHAR2 IS
	v_fmt_no_documento 						varchar2(13);
BEGIN
   	return SUBSTR (p_no_documento, 1, 3) || '-' || SUBSTR (p_no_documento, 4, 7) || '-'
       || SUBSTR (p_no_documento, 11, 1);
END fmt_no_documento;


FUNCTION fmt_nss (
	p_id_nss 								sre_ciudadanos_t.id_nss%TYPE
) RETURN VARCHAR2 IS
	v_fmt_nss 								varchar2(13);
BEGIN
   	return SUBSTR(LPAD(p_id_nss, 9, 0), 1, 8) || '-' || SUBSTR(LPAD(p_id_nss, 9, 0), 9, 1);
END fmt_nss;


FUNCTION fmt_tipo_nomina (
	p_tipo_nomina 							sre_nominas_t.tipo_nomina%TYPE
) RETURN VARCHAR2 IS
	v_fmt_tipo_nomina 						varchar2(14);
BEGIN
	case p_tipo_nomina
	when 'N' then
		v_fmt_tipo_nomina := 'NORMAL';
	when 'P' then
		v_fmt_tipo_nomina := 'PENSIONADOS';
	when 'C' then
		v_fmt_tipo_nomina := 'CONTRATADOS';
	when 'D' then
		v_fmt_tipo_nomina := 'DISCAPACITADOS';
	else
		v_fmt_tipo_nomina := p_tipo_nomina;
	end case;

	return v_fmt_tipo_nomina;

END fmt_tipo_nomina;

-- *****************************************************************************************************

FUNCTION DescEstatus(
	p_status 		 						VARCHAR2
) RETURN VARCHAR2 IS
BEGIN
    IF p_status = 'A' THEN
        RETURN 'Activo';
    ELSIF p_status = 'B' THEN
      RETURN 'Bloqueado';
    ELSE
        RETURN 'InActivo';
    END IF;
END;

-- *****************************************************************************************************

FUNCTION DescEstatusFactura(
	p_status 		 						VARCHAR2
) RETURN VARCHAR2 IS
BEGIN
    IF p_status = 'PA' THEN
        RETURN 'Pagada';
    ELSIF p_status = 'RE' THEN
        RETURN 'Recalculada';
    ELSIF p_status = 'CA' THEN
        --RETURN 'Cancelada';
        RETURN 'Revocada';
    ELSIF p_status = 'VI' THEN
        RETURN 'Vigente';
    ELSIF p_status = 'VE' THEN
        RETURN 'Vencida';
    ELSE
        RETURN p_status;
    END IF;
END;

-- *****************************************************************************************************

FUNCTION is_ValidoEstatus(
	p_status 			  					VARCHAR2
) RETURN BOOLEAN IS
BEGIN
    IF p_status IN ('A', 'I') THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END;

-- *****************************************************************************************************

FUNCTION ProperCase(
	texto 									VARCHAR2
) RETURN VARCHAR2 IS
BEGIN
    IF LENGTH(texto) <=3 THEN
        RETURN texto;
    ELSE
        RETURN INITCAP(texto);
    END IF;
END;

-- *****************************************************************************************************

FUNCTION FormateaPeriodo(
	periodo 								SFC_FACTURAS_T.periodo_factura%TYPE
) RETURN VARCHAR2 IS
BEGIN
	RETURN SUBSTR(periodo,5,6) || '-' || SUBSTR(periodo, 1,4);
END;

-- *****************************************************************************************************

FUNCTION getProximoPeriodo(
-- Description: Dado un periodo retorna el periodo siguiente de éste.
-- 13/04/2005	Ronny J. Carreras Creation
    periodo 								SFC_FACTURAS_T.periodo_factura%TYPE
) RETURN VARCHAR2 IS
 	v_mes INT;
 	v_ano INT;
 	v_periodo VARCHAR(6);

BEGIN
 	v_mes:= SUBSTR(periodo,5,2);
 	v_ano:= SUBSTR(periodo,0,4);

 	IF (v_mes = 12) THEN
    	v_ano:= v_ano + 1;
    	v_mes:= 1;
 	ELSE
    	v_mes:= v_mes + 1;
 	END IF;

  	v_periodo:= TO_CHAR(v_ano) || LPAD(TO_CHAR(v_mes),2,'0');
  	RETURN v_periodo;

END getProximoPeriodo;

--*******************************************************************************************************

PROCEDURE merge_tables (
    p_table_1 IN OUT    					t_email_tbl,
    p_table_2 IN       						t_email_tbl
) IS
	v_ndx     							    BINARY_INTEGER;

BEGIN

	IF p_table_2 IS NOT NULL THEN
    	IF p_table_1 IS NULL THEN
    	    p_table_1 := p_table_2;
        ELSE
    		v_ndx := p_table_2.first;
        	WHILE v_ndx <= p_table_2.last LOOP
         		p_table_1.extend;
            	p_table_1(p_table_1.last + 1) := p_table_2(v_ndx);
         		v_ndx := p_table_2.NEXT(v_ndx);
        	END LOOP;
    	END IF;
	END IF;

END merge_tables;

-- *****************************************************************************************************

FUNCTION join_table (
    p_table IN           					t_email_tbl
) RETURN VARCHAR2 IS

	v_ndx     							    BINARY_INTEGER;
	v_return     							VARCHAR2(300);

BEGIN

	v_ndx := p_table.first;
	WHILE v_ndx <= p_table.last LOOP
		v_return := v_return || p_table(v_ndx) || ',';
		v_ndx := p_table.NEXT(v_ndx);
	END LOOP;

	RETURN v_return;

END join_table;

-- *****************************************************************************************************

FUNCTION get_module (
    p_id_proceso   IN      					SFC_PROCESOS_T.id_proceso%TYPE
) RETURN SFC_PROCESOS_T.proceso_ejecutar%TYPE IS

	v_proceso_ejecutar     					SFC_PROCESOS_T.proceso_ejecutar%TYPE;

	CURSOR c_pro IS
	    SELECT trim(proceso_ejecutar)
		  FROM SFC_PROCESOS_T
	     WHERE id_proceso = p_id_proceso;

BEGIN

	OPEN c_pro;
	FETCH c_pro INTO v_proceso_ejecutar;
	CLOSE c_pro;

	RETURN v_proceso_ejecutar;

END get_module;

-- *****************************************************************************************************

FUNCTION is_error_dba (
    p_module       IN      					ERROR_STACKS.MODULE%TYPE,
    p_seq_number   IN      					ERROR_STACKS.seq_number%TYPE
) RETURN BOOLEAN IS

    v_error_number         					SRP_ERRORES_DBA_A_NOTIFICAR_T.error_number%TYPE;
    v_dummy                					NUMBER;
	v_return 								BOOLEAN := FALSE;

 	CURSOR c_err IS
      	SELECT error_number
       	  FROM ERROR_STACKS
       	 WHERE MODULE = p_module
       	   AND seq_number = p_seq_number;

	CURSOR c_dba IS
	    SELECT error_number
		  FROM SRP_ERRORES_DBA_A_NOTIFICAR_T
	     WHERE error_number = v_error_number;

BEGIN

	OPEN c_err;
	FETCH c_err INTO v_error_number;
	IF c_err%FOUND THEN
		OPEN c_dba;
		FETCH c_dba INTO v_dummy;
		IF c_dba%FOUND THEN v_return := TRUE; END IF;
		CLOSE c_dba;
	END IF;
	CLOSE c_err;

	RETURN v_return;

END is_error_dba;

-- *****************************************************************************************************

--dp201107
PROCEDURE set_mail (
	p_subject in out   						varchar2
) IS

    v_db_name        						VARCHAR2(30);

begin

	SELECT SYS_CONTEXT ('USERENV', 'DB_NAME') INTO v_db_name FROM DUAL;

	if upper(trim(v_db_name)) != 'SUIR' then
		p_subject := '** PRUEBA/DESARROLLO ** - ';
	else
		p_subject := '';
	end if;
	p_subject := p_subject || upper(trim(v_db_name)) || ': ';

END set_mail;


PROCEDURE notifica_ejecucion (
	p_id_bitacora  		 	    			SFC_BITACORA_T.id_bitacora%TYPE,
	p_msg_adicional  		 	    		varchar2 default null
) IS

	TYPE t_bit_rec							IS RECORD (
		proceso_ejecutar                    SFC_PROCESOS_T.proceso_ejecutar%TYPE,
		proceso_des 						SFC_PROCESOS_T.proceso_des%TYPE,
		id_proceso          				SFC_BITACORA_T.id_proceso%TYPE,
		id_bitacora         				SFC_BITACORA_T.id_bitacora%TYPE,
		fecha_inicio						SFC_BITACORA_T.fecha_inicio%TYPE,
		fecha_fin							SFC_BITACORA_T.fecha_fin%TYPE,
		mensage								SFC_BITACORA_T.mensage%TYPE,
		status     							SFC_BITACORA_T.status%TYPE,
		id_error							SFC_BITACORA_T.id_error%TYPE,
		seq_number							SFC_BITACORA_T.seq_number%TYPE,
		lista_ok  							SFC_PROCESOS_T.lista_ok%TYPE,
		lista_error							SFC_PROCESOS_T.lista_error%TYPE
	);
	v_bit      	   							t_bit_rec;
	v_sender                     			CONSTANT VARCHAR2(28) := 'Notificacion@SuirPlus.gov.do';
    v_subject               				VARCHAR2(1000);
    v_body               					VARCHAR2(9000);
    v_ln   									VARCHAR2(2) := CHR(10);
    v_despedida              				VARCHAR2(100) := ' ';
    v_error_message  						VARCHAR2(4000);
    v_error_status   						NUMBER;
    v_recipient    							SFC_PROCESOS_T.lista_ok%TYPE;
    v_msg_error      						VARCHAR2(2000);

	CURSOR c_bit IS
	  	SELECT b.proceso_ejecutar, b.proceso_des, a.id_proceso, a.id_bitacora, a.fecha_inicio,
		  	   a.fecha_fin, a.mensage, a.status, a.id_error, a.seq_number,
		  	   b.lista_ok, b.lista_error
		  FROM SFC_BITACORA_T a,
		       SFC_PROCESOS_T b
	     WHERE a.id_proceso = b.id_proceso
		   AND id_bitacora = p_id_bitacora;

BEGIN

	OPEN c_bit;
	FETCH c_bit INTO v_bit;
	CLOSE c_bit;

	set_mail(v_subject);
 	IF v_bit.status = 'O' THEN
 		v_subject := v_subject || 'Fin Proceso ' || v_bit.proceso_ejecutar;
 		v_body := 'El Proceso ' || v_ln || v_ln ||
			   '     ' || TO_CHAR(v_bit.id_proceso) || ' - ' || v_bit.proceso_ejecutar || v_ln ||
			   '     ' || v_bit.proceso_des || v_ln || v_ln ||
 			   ' finalizó correctamente.' || v_ln || v_ln;
 		v_body := v_body || 'FECHA INICIO: ' || TO_CHAR(v_bit.fecha_inicio, 'DD-MON-YY HH24:MI:SS') || v_ln;
 		v_body := v_body || 'FECHA FIN   : ' || TO_CHAR(v_bit.fecha_fin, 'DD-MON-YY HH24:MI:SS') || v_ln;
		if p_msg_adicional is not null then
 			v_body := v_body || p_msg_adicional;
		end if;
 		v_recipient := v_bit.lista_ok;
 	ELSIF v_bit.status = 'E' THEN
		v_subject := v_subject || 'Cancelación Proceso ' || v_bit.proceso_ejecutar;
 		v_body := 'El Proceso ' || TO_CHAR(v_bit.id_proceso) || ' - ' || v_bit.proceso_ejecutar ||
 			' canceló.' || v_ln || v_ln;
 		v_body := v_body || 'FECHA INICIO     : ' || TO_CHAR(v_bit.fecha_inicio, 'DD-MON-YY HH24:MI:SS') || v_ln;
 		v_body := v_body || 'FECHA CANCELACION: ' || TO_CHAR(v_bit.fecha_fin, 'DD-MON-YY HH24:MI:SS') || v_ln;
 		v_body := v_body || 'MENSAGE ERROR    : ' || get_mensage(v_bit.id_error) || v_ln;
		IF v_bit.mensage IS NOT NULL THEN
 			v_body := v_body || 'COMENTARIO       : ' || v_ln;
 			v_body := v_body || v_bit.mensage || v_ln;
		END IF;
		IF v_bit.seq_number IS NOT NULL THEN
 			v_body := v_body || v_ln || 'DETALLE ERROR:';
			v_body := v_body || v_ln || '--------------' || v_ln || v_ln;
			Errorpkg.PrintStacks2(v_bit.proceso_ejecutar, v_bit.seq_number, v_msg_error);
			v_body := v_body || v_msg_error || v_ln;
		END IF;
 		v_recipient := v_bit.lista_error;
 	END IF;

	IF v_recipient IS NOT NULL THEN
		--dp260705
		--SYSTEM.envia_email( v_sender, v_recipient, NULL, NULL, v_subject, v_body, NULL,
		--	NULL, NULL, v_error_message, v_error_status);
		SYSTEM.text_mail( v_sender, v_recipient, v_subject, v_body);
	END IF;

END notifica_ejecucion;

-- *****************************************************************************************************

PROCEDURE notifica_msg (
	p_id_proceso                    		SFC_PROCESOS_T.id_proceso%TYPE, --dp010306
    p_subject               				VARCHAR2,
    p_body               					VARCHAR2,
	p_tipo                    				CHAR DEFAULT 'E'
) IS

	v_lista_ok  							SFC_PROCESOS_T.lista_ok%TYPE;
	v_lista_error							SFC_PROCESOS_T.lista_error%TYPE;
	v_sender                     			CONSTANT VARCHAR2(28) := 'Notificacion@SuirPlus.gov.do';
    v_ln   									VARCHAR2(1) := CHR(10);
    v_despedida              				VARCHAR2(100) := ' ';
    v_error_message  						VARCHAR2(4000);
    v_error_status   						NUMBER;
    v_recipient    							SFC_PROCESOS_T.lista_ok%TYPE;
    v_msg_error      						VARCHAR2(2000);
    v_subject               				VARCHAR2(1000);
	v_body               				    VARCHAR2(9000);

	CURSOR c_pro IS
	  	SELECT lista_ok, lista_error
		  FROM SFC_PROCESOS_T
	     WHERE id_proceso = p_id_proceso;

BEGIN

	OPEN c_pro;
	FETCH c_pro INTO v_lista_ok, v_lista_error;
	CLOSE c_pro;

	set_mail(v_subject);
	v_subject := v_subject || p_subject || v_ln;
 	IF p_tipo = 'O' THEN
 		v_recipient := v_lista_ok;
 	ELSIF p_tipo = 'E' THEN
 		v_recipient := v_lista_error;
 	END IF;
	v_body := p_body || v_ln;

	IF v_recipient IS NOT NULL THEN
		--dp260705
		--SYSTEM.envia_email( v_sender, v_recipient, NULL, NULL, p_subject, p_body, NULL,
		--	NULL, NULL, v_error_message, v_error_status);
		SYSTEM.text_mail( v_sender, v_recipient, v_subject, v_body);
	END IF;

END notifica_msg;

-- *****************************************************************************************************

FUNCTION Existenss(p_Id_Nss NUMBER) RETURN BOOLEAN
IS
/*
DESCRIPCION : Funcion que retorna la existencia del Nss en la tabla de Representantes.
PARAMS: pId_Nss => Identificador del Nss.
AUTORA: Elinor Rodríguez 02/Nov/2004
*/

	CURSOR c_existe_nss IS
		--SELECT t.Id_nss FROM SRE_REPRESENTANTES_T t WHERE t.ID_Nss = p_Id_Nss;
		SELECT t.id_nss FROM SRE_CIUDADANOS_T t WHERE t.ID_Nss = p_Id_Nss;

	returnValue 							BOOLEAN;
	pnss 									SRE_REPRESENTANTES_T.ID_NSS%TYPE;

BEGIN

	OPEN c_existe_nss;
	FETCH c_existe_nss INTO pnss;
	returnValue := c_existe_nss%FOUND;
	CLOSE c_existe_nss;

	RETURN(returnValue);

END Existenss;

-- *****************************************************************************************************

FUNCTION periodo_ult_facturacion RETURN SFC_FACTURAS_T.periodo_factura%TYPE IS

	CURSOR c_periodo IS
		SELECT MAX(periodo)
		  FROM SFC_BITACORA_T
		 WHERE status = 'O'
		   AND id_error = '000'
           AND periodo IS NOT NULL;

	v_periodo   							SFC_FACTURAS_T.periodo_factura%TYPE;

BEGIN

	OPEN c_periodo;
	FETCH c_periodo INTO v_periodo;
	CLOSE c_periodo;

	RETURN v_periodo;

END periodo_ult_facturacion;

-- *****************************************************************************************************

--dp041206
FUNCTION get_periodo_vigente(
	p_periodo		  				DATE,
	p_date		  					DATE,
	p_date_ini						DATE,
	p_date_fin						DATE,
	p_fmt		    		 		varchar default 'YYYYMM'
) RETURN NUMBER IS

	v_new_periodo					DATE;
	v_periodo_vigente				number;

BEGIN

	IF p_date between p_date_ini and p_date_fin then
		v_new_periodo := p_periodo;
	elsIF p_date < p_date_ini THEN
		v_new_periodo := add_months(p_periodo, -1);
	ELSIF p_date > p_date_fin THEN
		v_new_periodo := add_months(p_periodo, 1);
	END IF;

	if p_fmt = 'MMYYYY' then
		v_periodo_vigente := TO_NUMBER(to_char(v_new_periodo, 'MMYYYY'));
	else
		v_periodo_vigente := TO_NUMBER(to_char(v_new_periodo, 'YYYYMM'));
	end if;

	return v_periodo_vigente;

END get_periodo_vigente;

-- *****************************************************************************************************
--dp170706
FUNCTION get_fecha_facturacion
RETURN DATE AS

	v_fecha_facturacion 					DATE := NULL;

	CURSOR c_40 is
		SELECT trunc(valor_fecha)
		  FROM sfc_det_parametro_t
		 WHERE id_parametro = 40
		   AND ( fecha_fin IS NULL OR fecha_fin = ( SELECT MAX ( fecha_fin )
													 FROM sfc_det_parametro_t
													WHERE id_parametro = 40 ));
BEGIN

	OPEN c_40;
	FETCH c_40 INTO v_fecha_facturacion;
	CLOSE c_40;

	RETURN v_fecha_facturacion;

EXCEPTION WHEN OTHERS THEN Errorpkg.HandleAll(FALSE); RAISE;
END get_fecha_facturacion;
--enddp170706

-- *****************************************************************************************************

--dp190207
FUNCTION is_YYYYMM(
   	p_YYYYMM         						number
) RETURN BOOLEAN AS
 	v_rtn    								boolean;
 	v_date    								date;

BEGIN

	v_rtn := true;
 	begin
     	v_date := to_date(to_char(p_YYYYMM),'YYYYMM');
 	exception
     	when others then
			v_rtn := false;
 	end;

 	return v_rtn;

EXCEPTION WHEN OTHERS THEN Errorpkg.handleall(FALSE); RAISE;
END is_YYYYMM;
--end dp190207

-- *****************************************************************************************************
 procedure get_configuracion(p_id_modulo    in srp_config_t.id_modulo%type,
                             p_iocursor     in out t_cursor,
                             p_resultnumber out varchar2)

   is
    v_bderror varchar(1000);
    c_cursor  t_cursor;

  begin

    open c_cursor for
      select p.ID_MODULO, p.FTP_HOST, p.FTP_USER, p.FTP_PASS, p.FTP_PORT, p.FTP_DIR,
             p.ARCHIVES_DIR, p.ARCHIVES_OK_DIR, p.ARCHIVES_ERR_DIR, p.OTHER1_DIR, p.OTHER2_DIR,
             p.OTHER3_DIR, p.USER_MAILS, p.DBA_MAILS, p.PROG_MAILS, p.OTHER1_MAILS, p.OTHER2_MAILS,
             p.OTHER3_MAILS, p.FIELD1, p.FIELD2, p.FIELD3, p.FIELD4
        from srp_config_t p
       where p.id_modulo = p_id_modulo;

    p_iocursor     := c_cursor;
    p_resultnumber := 0;

  exception

    when others then
      v_bderror      := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultnumber := Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
      return;
  end;
-- *************************************************************************************
begin
 	v_ultimo_dia := TO_DATE ('31129999', 'DDMMYYYY');
END Srp_Pkg;