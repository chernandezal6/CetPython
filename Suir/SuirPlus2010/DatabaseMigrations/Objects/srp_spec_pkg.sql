CREATE OR REPLACE PACKAGE Suirplus.Srp_Pkg AS

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
-- 080807 dp Inclusion fecha_limite_acuerdo_pago.
-- 130807 dp Inclusion initialize_lfp_parm.
-- 201107 dp Inclusion DB_NAME en el mail para determinal si es de Prueba o Produccion.
-- 131212 dp Inclusion de p_dia en fecha_limite_de_pago 
--
-- (dp - David Pineda, rc - Ronny Carreras)
-- *****************************************************************************************************

TYPE t_parm_rec 							IS RECORD (
	valor_fecha								SFC_DET_PARAMETRO_T.valor_fecha%TYPE,
	valor_numerico							SFC_DET_PARAMETRO_T.valor_numerico%TYPE,
	valor_texto								SFC_DET_PARAMETRO_T.valor_texto%TYPE,
	tipo_parametro							SFC_PARAMETROS_T.tipo_parametro%TYPE);
TYPE t_parm_tbl        						IS TABLE OF t_parm_rec INDEX
											BY BINARY_INTEGER;

TYPE t_isr_rec								IS RECORD (
	rni_desde								SFC_RANGOS_ANUALES_ISR_T.rni_desde%TYPE,
	rni_hasta								SFC_RANGOS_ANUALES_ISR_T.rni_hasta%TYPE,
	impuesto_fijo							SFC_RANGOS_ANUALES_ISR_T.impuesto_fijo%TYPE,
	porciento_excedente						SFC_RANGOS_ANUALES_ISR_T.porciento_excedente%TYPE,
	is_delete                               VARCHAR2(1)
);
TYPE t_isr_tbl								IS TABLE OF t_isr_rec;
v_isr_pens									t_isr_tbl;
v_isr                                       t_isr_tbl;


 TYPE t_cursor IS REF CURSOR ;

-- dp
-- Las tablas de ISR (v_isr_pens y v_isr) ahora mismo solo puede funcionar una sola por ejecucion
-- porque estan aquí en el pkg.  Si se desean que funcione más de una en un mismo programa (como en
-- el caso de los parametros Parm), deben ponerse en el programa en cuestion, llamarse en la inizia-
-- zación y modificar el get_isr para que reciba las tablas como parametros
-- Mientras no se vayan a utilizar así (como en caso que se hagan facturas de auditorias para ISR),
-- dejar como está ahora, ya que así tiene mejor performance.
TYPE t_email_tbl   						    IS TABLE OF VARCHAR2(50);
v_ultimo_dia                                DATE := TO_DATE ('31129999', 'DDMMYYYY');

FUNCTION is_holiday (
	p_day 									DATE
) RETURN BOOLEAN;
FUNCTION business_date (
	p_start_date 							DATE,
	p_Days2Add 								NUMBER
) RETURN DATE;
FUNCTION fday_of_month(
	value_in 								DATE
) RETURN DATE;
FUNCTION fecha_inicio_periodo(
	p_periodo 								NUMBER
) RETURN DATE;
FUNCTION fecha_fin_periodo(
	p_periodo 								NUMBER
) RETURN DATE;
FUNCTION fecha_limite_pago_ss(
-- Descripcion: Dado un periodo retorna la fecha límite pago SS de éste.
-- 13/04/2005	David Pineda 	Creation
	p_periodo 								NUMBER
) RETURN DATE;
FUNCTION fecha_limite_pago_isr(
-- Descripcion: Dado un periodo retorna la fecha límite pago ISR de éste.
-- 13/04/2005	David Pineda 	Creation
	p_periodo 								NUMBER,
	p_dia 									NUMBER DEFAULT 10 --dp131212
) RETURN DATE;
FUNCTION fecha_corrida_recargo_ss(
	p_periodo								NUMBER
) RETURN DATE;
--dp080807
FUNCTION fecha_limite_acuerdo_pago(
	p_periodo								NUMBER
) RETURN DATE;
FUNCTION add_periodo(
	p_periodo								NUMBER,
	p_mes 								    NUMBER
) RETURN NUMBER;
FUNCTION periodo_YYYYMM(
	p_periodo_MMYYYY							VARCHAR2
) RETURN NUMBER;
FUNCTION periodo_MMYYYY(
	p_periodo_YYYYMM							NUMBER
) RETURN VARCHAR;
FUNCTION mmyyyy_like (
	p_yyyymm									varchar2
) RETURN VARCHAR2;
PROCEDURE bitacora (
	p_id_bitacora IN OUT				    SFC_BITACORA_T.id_bitacora%TYPE,
	p_accion  IN						    VARCHAR2 DEFAULT 'INI',
	p_id_proceso IN    				    	SFC_BITACORA_T.id_proceso%TYPE,
	p_mensage IN						    SFC_BITACORA_T.mensage%TYPE DEFAULT NULL,
	p_status IN							    SFC_BITACORA_T.status%TYPE DEFAULT NULL,
	p_id_error IN							SEG_ERROR_T.id_error%TYPE DEFAULT NULL,
	p_seq_number IN							ERRORS.seq_number%TYPE DEFAULT NULL,
	p_periodo IN							SFC_BITACORA_T.periodo%TYPE DEFAULT NULL
);
FUNCTION is_proceso_ejecutado (
	p_id_proceso IN    				    	SFC_BITACORA_T.id_proceso%TYPE,
	p_periodo IN						    SFC_BITACORA_T.periodo%TYPE
) RETURN BOOLEAN;
FUNCTION is_continua_proceso (
	p_periodo IN						    SFC_BITACORA_T.periodo%TYPE,
	p_id_proceso IN    				    	SFC_BITACORA_T.id_proceso%TYPE,
	p_id_proceso_previo IN    				SFC_BITACORA_T.id_proceso%TYPE
) RETURN BOOLEAN;
PROCEDURE is_proceso_ok (
	p_id_proceso IN    				    	SFC_BITACORA_T.id_proceso%TYPE,
	p_periodo IN						    SFC_BITACORA_T.periodo%TYPE,
	p_respuesta OUT						   	VARCHAR2
);
FUNCTION get_mensage (
	p_id_error IN    				    	SEG_ERROR_T.id_error%TYPE
) RETURN SEG_ERROR_T.error_des%TYPE;
--PROCEDURE initialize_parm ( --dp010510
FUNCTION get_parm_tbl (
	p_periodo 							    SFC_FACTURAS_T.periodo_factura%TYPE
-- 	p_parm OUT 								t_parm_tbl --dp050627 --dp010510
) return t_parm_tbl 
RESULT_CACHE;
-- Descripcion: Inicializa tabla de parametros de Recargos SS
-- 09/09/2005	David Pineda 	Creation
PROCEDURE initialize_recargos_ss_parm (
	p_periodo 							    SFC_FACTURAS_T.periodo_factura%TYPE,
 	p_parm OUT 								t_parm_tbl
);
--dp130807
PROCEDURE initialize_lfp_parm (
	p_periodo 							    SFC_FACTURAS_T.periodo_factura%TYPE,
 	p_parm OUT 								t_parm_tbl
);
--dp220207
PROCEDURE initialize_parm_infotep (
	p_periodo 							    SFC_FACTURAS_T.periodo_factura%TYPE,
 	p_parm OUT 								t_parm_tbl --dp050627
);
--end dp220207
PROCEDURE initialize_isr_parm (
	P         							    Parm,
	p_periodo 							    SFC_FACTURAS_T.periodo_factura%TYPE
);
FUNCTION numero (
	p_id_parametro 							SFC_DET_PARAMETRO_T.id_parametro%TYPE,
 	p_parm     								t_parm_tbl --dp050627
) RETURN SFC_DET_PARAMETRO_T.valor_numerico%TYPE;
FUNCTION fecha (
	p_id_parametro 							SFC_DET_PARAMETRO_T.id_parametro%TYPE,
 	p_parm     								t_parm_tbl --dp050627
) RETURN SFC_DET_PARAMETRO_T.valor_fecha%TYPE;
FUNCTION fmt_mnt (
	p_monto 								NUMBER,
	p_fmt 									varchar2 default '1'
) RETURN VARCHAR2;
FUNCTION fmt_referencia (
	p_id_referencia 						SFC_FACTURAS_T.id_referencia%TYPE
) RETURN VARCHAR2;
FUNCTION fmt_tel (
	p_telefono 								sre_empleadores_t.telefono_1%TYPE
) RETURN VARCHAR2;
FUNCTION fmt_periodo (
	p_periodo 								sfc_facturas_v.periodo_factura%TYPE
) RETURN VARCHAR2;
FUNCTION fmt_no_documento (
	p_no_documento 							sre_ciudadanos_t.no_documento%TYPE
) RETURN VARCHAR2;
FUNCTION fmt_nss (
	p_id_nss 								sre_ciudadanos_t.id_nss%TYPE
) RETURN VARCHAR2;
FUNCTION fmt_tipo_nomina (
	p_tipo_nomina 							sre_nominas_t.tipo_nomina%TYPE
) RETURN VARCHAR2;
FUNCTION DescEstatus(
	p_status 		 						VARCHAR2
) RETURN VARCHAR2;
FUNCTION DescEstatusFactura(
	p_status 		 						VARCHAR2
) RETURN VARCHAR2;
FUNCTION is_ValidoEstatus(
	p_status 			  					VARCHAR2
) RETURN BOOLEAN;
FUNCTION ProperCase(
	texto 									VARCHAR2
) RETURN VARCHAR2;
FUNCTION FormateaPeriodo(
	periodo 								SFC_FACTURAS_T.periodo_factura%TYPE
) RETURN VARCHAR2;
FUNCTION getProximoPeriodo(
-- Description: Dado un periodo retorna el periodo siguiente de éste.
-- 13/04/2005	Ronny J. Carreras Creation
    periodo 								SFC_FACTURAS_T.periodo_factura%TYPE
) RETURN VARCHAR2;
PROCEDURE merge_tables (
    p_table_1 IN OUT    					t_email_tbl,
    p_table_2 IN       						t_email_tbl
);
FUNCTION get_module (
    p_id_proceso   IN      					SFC_PROCESOS_T.id_proceso%TYPE
) RETURN SFC_PROCESOS_T.proceso_ejecutar%TYPE;
FUNCTION join_table (
    p_table IN           					t_email_tbl
) RETURN VARCHAR2;
--dp201107
PROCEDURE set_mail (
	p_subject in out   						varchar2
);
PROCEDURE notifica_ejecucion (
	p_id_bitacora  		 	    			SFC_BITACORA_T.id_bitacora%TYPE,
	p_msg_adicional  		 	    		varchar2 default null
);
PROCEDURE notifica_msg (
	p_id_proceso                    		SFC_PROCESOS_T.id_proceso%TYPE, --dp010306
    p_subject               				VARCHAR2,
    p_body               					VARCHAR2,
	p_tipo                    				CHAR DEFAULT 'E'
);
FUNCTION Existenss(
	p_id_nss 	   							NUMBER
) RETURN BOOLEAN;
FUNCTION periodo_ult_facturacion RETURN SFC_FACTURAS_T.periodo_factura%TYPE;
--dp120406
FUNCTION get_periodo_vigente(
	p_periodo		  				DATE,
	p_date		  					DATE,
	p_date_ini						DATE,
	p_date_fin						DATE,
	p_fmt		    		 		varchar default 'YYYYMM'
) RETURN NUMBER;
--dp170706
FUNCTION get_fecha_facturacion
RETURN DATE;
FUNCTION is_YYYYMM(
   	p_YYYYMM         						number
) RETURN BOOLEAN;

-- *****************************************************************************************************
  procedure get_configuracion(p_id_modulo    in srp_config_t.id_modulo%type,
                                 p_iocursor     in out t_cursor,
                                 p_resultnumber out varchar2);


END Srp_Pkg;