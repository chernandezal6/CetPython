CREATE OR REPLACE PACKAGE SUIRPLUS.Sfc_C_Ss_Pkg AS

-- *****************************************************************************************************
-- Program:    sfc_c_ss_pkg
-- Descripcion: Cursores a usar en sfc_ss_f.
--
-- Modification History
-- -----------------------------------------------------------------------------------------------------
-- Date   by Remark
-- -----------------------------------------------------------------------------------------------------
-- 080910 dp Version 2.0 del paquete SFC_C_SS.  Se normalizaron los select aplicando DRY (Don't Repeat
--           Yourself). El anterior se renombro con sfc_c_ss_pkg_v1, para documentacion.
-- 300813 dp Cambia el concepto de las NP de SS de CANCELADAS (CA) a RECALCULADAS (RE).
-- 250913 dp Si los parametros para un tipo de factura son igual a cero, no genera la factura.
-- 170214 dp Inclusion SRE_EMPLEADORES_T.pago_subsidios.
-- 130514 dp Version 2.5 del paquete SFC_C_SS.  Se quito el codigo redundante y se quito el codigo co-
--           mentado para mas claridad. El anterior se renombro sfc_c_ss_pkg_v2.
-- 130514 dp Version 2.5 del paquete SFC_C_SS.  Se quito el codigo redundante y se quito el codigo co-
-- 130815 dp Exclusión de trabajadores con TIPO_CAUSA='I' AND ID_CAUSA_INHABILIDAD=100.
-- 090817 dp Task #11555: Validar NP: salario_ss > parámetro OR aporte_voluntario > 0
--
-- dp - David Pineda
--
-- *****************************************************************************************************
--
--  (a)  Este paquete contine los cursores a ser usados para la generacion de las NOTIFICACIONES DE PAGO
--      (NP) en la funcion SFC_SS_F.  Este es el motor de las NP, ya que aqui se selecciona el universo
--      de todos los sregistros que componen los diferentes tipod de NP.  Cualquier edicion (determinar
--      asi que en caso que se necesite un cambio de edicion (cuales registros van y cuales no), este es
--      el miembro a modificar. La funcion SFC_SS_F es un simple programa de CONTROL BREAK que crea
--      las NP pasando en el input que le sumistren
--      estos cursores, funcionando igual para todo el mundo, lo que varia son los registros que se
--      determine por aqui.
--
--  (b)  El tipo T_SS_REC es donde deben de caer todos y cada uno de los cursores.
--
--  (c) Los cursores son tres y cada uno se usa para generar el tipo de NP que su nombre describe.
--      Estos son:
--
--        **  C_ORDINARIA_N
--        **  C_RETROACTIVA_N
--        **  C_AUDITORIA
--
--  (d) Se genera una NP por cada NOMINA, de cada REGISTRO PATRONAL. Cada cursor selecciona los
--      trabajadores de todas las NOMINAS, de cada REGISTRO PATRONAL en cuestion. Por ejemplo, si se
--      genera un movimiento que afecta solo a una NOMINA de un REGISTRO PATRONAL y este REGISTRO PATRONAL
--      tiene veinte nominas, pues se genera la informacion de todos los trabajadores de las veinte
--      nominas  aunque el movimiento haya sido para una sola de ellas.  Poniendolo mas grafico si se
--      le cambia el salario a un empleado de una empresa que tiene mil nominas, se selecciona la
--      informacion de las mil nominas, dejando fuera las nominas que hayan sido pagadas.
--
--  (e) Los cursores estan normalizados y la repeticon de codigo debe estar limitada a lo mas minimo
--       (Principio de DRY).  Los SELECT se van definiendo en grupos, que luego se van utilizando y
--       adicionandoles las condiciones que se vayan necesitando, para asi evitar repetir.
--
-- *****************************************************************************************************

TYPE t_ss_rec IS RECORD (
  	id_registro_patronal          			SRE_EMPLEADORES_T.id_registro_patronal%TYPE,
  	tipo_empresa              				SRE_EMPLEADORES_T.tipo_empresa%TYPE,
  	descuento_penalidad            			SRE_EMPLEADORES_T.descuento_penalidad%TYPE,
  	id_riesgo                				SRE_EMPLEADORES_T.id_riesgo%TYPE,
  	escalar_salario                			SRE_EMPLEADORES_T.escalar_salario%TYPE,	  --dp290615
  	id_nomina                				SRE_NOMINAS_T.id_nomina%TYPE,
  	tipo_nomina                				SRE_NOMINAS_T.tipo_nomina%TYPE,
  	id_nss                  				SRE_TRABAJADORES_T.id_nss%TYPE,
  	salario_ss                				SRE_TRABAJADORES_T.salario_ss%TYPE,
  	aporte_voluntario            			SRE_TRABAJADORES_T.aporte_voluntario%TYPE,
  	agente_retencion_ss            			SFC_IR13_T.agente_retencion_ss%TYPE,
  	cnt_dependientes            			NUMBER,
  	sum_salario_ss              			SRE_TRABAJADORES_T.salario_ss%TYPE,
  	periodo                      			SFC_FACTURAS_T.periodo_factura%TYPE,
  	pa_salario_ss              				SRE_TRABAJADORES_T.salario_ss%TYPE,
  	pa_aporte_voluntario          			SRE_TRABAJADORES_T.aporte_voluntario%TYPE,
  	salario_ss_reportado          			SRE_TRABAJADORES_T.salario_ss%TYPE,
    cod_sector                				SRE_EMPLEADORES_T.cod_sector%TYPE,
  	pago_subsidios                			SRE_EMPLEADORES_T.pago_subsidios%TYPE 	  --dp170214
);

TYPE t_fac_rec IS RECORD (
  	tipo_nomina                				SRE_NOMINAS_T.tipo_nomina%TYPE,
  	cnt_dependientes            			NUMBER,
  	id_riesgo                				sfc_facturas_t.id_riesgo%type,
  	descuento_penalidad            			SRE_EMPLEADORES_T.descuento_penalidad%TYPE
);

-- *****************************************************************************************************

FUNCTION is_trab_activo (
  	p_status                        		sre_trabajadores_t.status%type,
  	p_fecha_salida                  		sre_trabajadores_t.fecha_salida%type,
  	p_periodo_factura               		sfc_facturas_t.periodo_factura%type,
  	p_fecha_ult_reintegro           		sre_trabajadores_t.fecha_salida%type DEFAULT NULL,
  	p_fecha_ingreso                   		sre_trabajadores_t.fecha_salida%type DEFAULT NULL
) RETURN CHAR;

FUNCTION is_escalar_salario (
  	p_escalar_salario               		sre_empleadores_t.escalar_salario%type,
  	p_tipo_nomina                   		sre_nominas_t.tipo_nomina%type
) RETURN CHAR
RESULT_CACHE;

FUNCTION get_salario_ss (
  	p_sum_salario_ss               			sre_det_movimiento_t.salario_ss%type,
  	p_salario_ss_raised            			sre_det_movimiento_t.salario_ss%type,
	p_salario_ss                  			sre_det_movimiento_t.salario_ss%type,
	p_sum_salario_pa              			sre_det_movimiento_t.salario_ss%type default 0
) RETURN sre_det_movimiento_t.salario_ss%type;

FUNCTION get_sum_salario_ss (
  	p_salario_ss_raised             		sre_det_movimiento_t.salario_ss%type,
  	p_sum_salario_ss                		sre_det_movimiento_t.salario_ss%type
) RETURN sre_det_movimiento_t.salario_ss%type;

FUNCTION get_salario_ss_raised (
  	p_is_raise                        		CHAR,
  	p_cod_ingreso                   		sre_trabajadores_t.cod_ingreso%type,
  	p_salario_ss                      		sre_det_movimiento_t.salario_ss%type,
  	p_salario_minimo                  		sre_det_movimiento_t.salario_ss%type
) RETURN sre_det_movimiento_t.salario_ss%type
RESULT_CACHE;

FUNCTION get_salario_ss_raised(
  	p_is_raise                        		CHAR,
  	p_cod_ingreso                   		sre_trabajadores_t.cod_ingreso%type,
  	p_salario_ss                      		sre_det_movimiento_t.salario_ss%type,
  	p_cod_sector                      		sre_escala_salarial_t.cod_sector%type,
  	p_periodo_aplicacion            		sre_det_movimiento_t.periodo_aplicacion%type
) RETURN sre_det_movimiento_t.salario_ss%type
RESULT_CACHE;

FUNCTION is_parm_zero(
  	p_periodo_factura               		sfc_facturas_t.periodo_factura%type,
  	p_id_tipo_nomina                   		sre_nominas_t.tipo_nomina%TYPE
) RETURN CHAR
RESULT_CACHE;

--dp290615
FUNCTION is_excluir_salario_X (
  	p_escalar_salario               		sre_empleadores_t.escalar_salario%type,
  	p_sum_salario_ss                		sre_det_movimiento_t.salario_ss%type,
  	p_salario_minimo                  		sre_det_movimiento_t.salario_ss%type
) RETURN CHAR
RESULT_CACHE;
--end dp290615

-- *****************************************************************************************************

LAST_DAY                  					CONSTANT date := '31-DEC-9999';
g_salario_ss             					sre_trabajadores_t.salario_ss%type;			--dp090817

-- *****************************************************************************************************

-- =====================================================================================================
-- Cursor para las NP de cada nomina de un periodo, de un REGISTRO PATRONAL en especifico.  Este es
-- una variante del cursor C_MENSUAL.  A este le incluye la edicion por REGISTRO PATRONAL, y deja
-- fuera las nominas de las NP que hayan sido pagadas o autorizadas.
-- =====================================================================================================

CURSOR c_ordinaria_n (
  	p_periodo_factura               		SFC_FACTURAS_T.periodo_factura%TYPE,
  	p_fecha_inicio_periodo          		date,
  	p_id_registro_patronal             		SFC_FACTURAS_T.id_registro_patronal%TYPE default null
) RETURN t_ss_rec IS

  WITH
    -- *********************************************************************************************
    -- Valores de la escla salarial segun el periodo a procesar
    -- *********************************************************************************************
     escala_salarial AS (
       SELECT cod_sector, MAX (salario_minimo) salario_minimo
         FROM sre_escala_salarial_t
        WHERE p_fecha_inicio_periodo BETWEEN fecha_inicio
                                         AND NVL(fecha_fin, sfc_c_ss_pkg.LAST_DAY)
       GROUP BY cod_sector
        ),
    -- *********************************************************************************************
    -- Trabajadores a procesarse
    -- Determina de los trabajadores selecionados previamente, a cuales no se les debe aplicar
    -- escla salarial.
    -- Le aplica el alza salarial correspondiente a los trabajadores seleecionados, si aplican.
    -- *********************************************************************************************
     trabajadores AS (
       SELECT a.id_registro_patronal,
       		  a.tipo_empresa,
       		  a.descuento_penalidad,
              a.id_riesgo,
			  a.escalar_salario,												--dp290615
              b.id_nomina,
              b.tipo_nomina,
              c.id_nss,
              c.salario_ss,   													 
              c.aporte_voluntario,
              a.cod_sector,
              a.pago_subsidios, 												--dp170214
           	  sfc_c_ss_pkg.is_escalar_salario(a.escalar_salario, b.tipo_nomina) is_raise,
              sfc_c_ss_pkg.get_salario_ss_raised(
              	sfc_c_ss_pkg.is_escalar_salario(a.escalar_salario, b.tipo_nomina),
              	c.cod_ingreso, c.salario_ss, ee.salario_minimo) salario_ss_raised,
              ee.salario_minimo                                                 --dp290615
        FROM SRE_EMPLEADORES_T a,
             SRE_NOMINAS_T b,
             SRE_TRABAJADORES_T c,
             SRE_CIUDADANOS_T d,
             ESCALA_SALARIAL ee
       WHERE a.id_registro_patronal = b.id_registro_patronal
         --
         AND b.id_registro_patronal = c.id_registro_patronal
         /* AND b.id_registro_patronal in (497004,497005,496917,496918,489144,489061,493204,493167,492783,493216,493785,493599,
                                        496823,496827,496829,496834,496840,496845,496846,496848,496851,496855,496860,496761
                                        ) */ -- Solo descomentar para pruebas
         AND b.id_nomina = c.id_nomina
         --
         AND c.id_nss = d.id_nss
      -- AND c.salario_ss > 0                                              --dp090817
         AND (c.salario_ss > g_salario_ss OR c.aporte_voluntario > 0)      --dp090817                                          
         --
         AND a.cod_sector = ee.cod_sector(+)
         --
         AND a.id_inhabilidad_empleador IS NULL
         --
         AND a.status = 'A'
         AND b.status = 'A'
         AND sfc_c_ss_pkg.is_trab_activo(c.status, c.fecha_salida, p_periodo_factura,
             	c.fecha_ult_reintegro, c.fecha_ingreso) = 'Y'
         --
         AND b.id_nomina NOT IN (888,999)
         --
         AND b.tipo_nomina != 'L'
         --
         AND c.id_nss < 900000000              -- Extranjeros quedan fuera
         --
         AND NVL(d.tipo_causa, 'N') != 'C'
	       --
 	       AND NOT (nvl(d.tipo_causa,'~')='I' AND nvl(d.id_causa_inhabilidad,0)=100)  --dp130815
         --
         AND a.id_registro_patronal = NVL(p_id_registro_patronal, a.id_registro_patronal)
        ),
    -- *********************************************************************************************
    -- De la seleccion anterior, totaliza los salarios para poder hacer la proporcion en los casos
    -- de los empleados que esten en mas de una nomina.
    -- *********************************************************************************************
     sum_salarios_nom AS (
       SELECT id_registro_patronal,
              id_nss,
              SUM(salario_ss) sum_salario_ss
         FROM trabajadores
       GROUP BY id_registro_patronal, id_nss
       HAVING COUNT (*) > 1
    ),
    -- *********************************************************************************************
    -- Determina la cantidad de dependientes de cada trabajador
    -- *********************************************************************************************
     dependientes AS (
       SELECT a.id_registro_patronal,
              a.id_nomina,
              a.id_nss,
              COUNT (*) cnt_dependientes
         FROM SRE_DEPENDIENTE_T a,
              SRE_CIUDADANOS_T b
        WHERE a.id_nss_dependiente = b.id_nss
          AND a.status = 'A'
          --
          AND b.fecha_nacimiento < p_fecha_inicio_periodo
          --
          AND a.id_registro_patronal = NVL(p_id_registro_patronal, a.id_registro_patronal)
          --
       GROUP BY a.id_registro_patronal, a.id_nomina, a.id_nss
    ),
    -- *********************************************************************************************
    -- Nominas de las NP que hayan sido pagadas o autorizadas. Esto es para excluirlas y no gene-
    -- rarle NP. Esta exclusion se logra con la condicion: AND aa.id_nomina = ee.id_nomina(+)
    -- AND ee.id_nomina IS NULL.
    -- *********************************************************************************************
     nominas_pagadas AS (
       SELECT id_registro_patronal,
              id_nomina
         FROM SFC_FACTURAS_T
        WHERE (status = 'PA' OR no_autorizacion IS NOT NULL)
           --
          AND periodo_factura = p_periodo_factura
           --
          AND id_registro_patronal = NVL(p_id_registro_patronal, id_registro_patronal)
    ),
    -- *********************************************************************************************
    --  Valores IR13 del periodo
    -- *********************************************************************************************
     ir13 AS (
       SELECT id_registro_patronal,
              id_nss,
              agente_retencion_ss
         FROM SFC_IR13_T
        WHERE periodo = p_periodo_factura
         --
          AND id_registro_patronal = NVL(p_id_registro_patronal, id_registro_patronal)
        )
  -- *************************************************************************************************
  --   M A I N
  -- *************************************************************************************************
  SELECT aa.id_registro_patronal,
         aa.tipo_empresa,
         NVL (aa.descuento_penalidad / 100, 0),
       	 aa.id_riesgo,
         aa.escalar_salario, --dp290615
         aa.id_nomina,
         aa.tipo_nomina,
         aa.id_nss,
         sfc_c_ss_pkg.get_salario_ss(cc.sum_salario_ss, aa.salario_ss_raised, aa.salario_ss),
         aa.aporte_voluntario,
         dd.agente_retencion_ss,
         NVL (bb.cnt_dependientes, 0),
         sfc_c_ss_pkg.get_sum_salario_ss(aa.salario_ss_raised, cc.sum_salario_ss),
         NULL,
         NULL,
         NULL,
         aa.salario_ss,
         aa.cod_sector,
         aa.pago_subsidios --dp170214
    FROM trabajadores aa,
         dependientes bb,
         sum_salarios_nom cc,
         IR13 dd,
         nominas_pagadas ee
   WHERE aa.id_registro_patronal = bb.id_registro_patronal(+)
     AND aa.id_nomina = bb.id_nomina(+)
     AND aa.id_nss = bb.id_nss(+)
     --
     AND aa.id_registro_patronal = cc.id_registro_patronal(+)
     AND aa.id_nss = cc.id_nss(+)
     --
     AND aa.id_registro_patronal = dd.id_registro_patronal(+)
     AND aa.id_nss = dd.id_nss(+)
     --
     AND aa.id_registro_patronal = ee.id_registro_patronal(+)
     AND aa.id_nomina = ee.id_nomina(+)
     AND ee.id_nomina IS NULL
     --
     AND sfc_c_ss_pkg.is_excluir_salario_X( 								--dp290615
     	 	aa.escalar_salario,
         	sfc_c_ss_pkg.get_sum_salario_ss(aa.salario_ss_raised, cc.sum_salario_ss),
     	 	aa.salario_minimo) = 'N'  									   --enddp290615
  --
  ORDER BY aa.id_registro_patronal, aa.id_nomina;

-- *****************************************************************************************************

-- =====================================================================================================
-- Cursor para generar las NP despues de la fecha limite de pago.
-- =====================================================================================================

CURSOR c_retroactiva_n (
  	p_periodo_factura             			SFC_FACTURAS_T.periodo_factura%TYPE,
  	p_fecha_inicio_periodo          		date,
  	p_id_registro_patronal             		SFC_FACTURAS_T.id_registro_patronal%TYPE,
  	p_id_movimiento               			SRE_MOVIMIENTO_T.id_movimiento%TYPE
) RETURN t_ss_rec IS

  WITH
    -- *********************************************************************************************
    -- Movimientos que disparan la generacion de la NP
    -- *********************************************************************************************
     movimientos AS (
       SELECT a.id_registro_patronal,
              b.id_nomina,
              b.id_nss,
              b.agente_retencion_ss,
              b.salario_ss,  													 
              b.saldo_favor_isr,
              b.otros_ingresos_isr,
              b.remuneracion_isr_otros,
              b.ingresos_exentos_isr,
              b.aporte_voluntario,
              b.cod_ingreso
         FROM SRE_MOVIMIENTO_T a,
              SRE_DET_MOVIMIENTO_T b,
              SRE_CIUDADANOS_T C --RJ & GH  14/08/2015
        WHERE a.id_movimiento = b.id_movimiento
           --
          AND b.id_nss < 900000000                    -- Extranjeros quedan fuera
       -- AND b.salario_ss > 0                                              	--dp090817
          AND (b.salario_ss > g_salario_ss OR b.aporte_voluntario > 0)			--dp090817
          --
          and C.ID_NSS=B.ID_NSS                                                     --RJ & GH  14/08/2015
 	        AND NOT (nvl(C.tipo_causa,'~')='I' AND nvl(C.id_causa_inhabilidad,0)=100) --RJ & GH  14/08/2015
          --
          AND a.id_movimiento = p_id_movimiento
     ),
    -- *********************************************************************************************
    -- Informacion de los trabajadores del movimiento
    -- *********************************************************************************************
     trabajadores AS (
       SELECT a.id_registro_patronal,
              a.tipo_empresa,
              a.descuento_penalidad,
              a.id_riesgo,
			        a.escalar_salario,												--dp290615
              a.cod_sector,
              b.id_nomina,
              b.tipo_nomina,
              cc.id_nss,
              cc.salario_ss,
              cc.aporte_voluntario,
              cc.agente_retencion_ss,
              sfc_c_ss_pkg.is_escalar_salario(a.escalar_salario, b.tipo_nomina) is_raise,
              cc.cod_ingreso
         FROM SRE_EMPLEADORES_T a,
              SRE_NOMINAS_T b,
              movimientos cc
        WHERE a.id_registro_patronal = b.id_registro_patronal
           --
           AND b.id_registro_patronal = cc.id_registro_patronal
           AND b.id_nomina = cc.id_nomina
           --
           AND a.id_inhabilidad_empleador IS NULL
           --
           AND a.status = 'A'
           --
           AND b.tipo_nomina != 'L'
           --
           AND a.id_registro_patronal = p_id_registro_patronal
     ),
    -- *********************************************************************************************
    -- Las diferentes nominas que estan en los movimientos
    -- *********************************************************************************************
     nominas_movimiento AS (
       SELECT DISTINCT id_nomina
         FROM SRE_DET_MOVIMIENTO_T
        WHERE id_movimiento = p_id_movimiento
     ),
    -- *********************************************************************************************
    -- Se seleccionan las informaciones de las NP ya generadas del periodo, cuyas nominas
    -- NO SEAN una de las nominas que esten en los movimientos. Es una NP por cada nomina, y en los
    -- movimientos puede venir solo alguna de las nominas de un Registro Patronal, por lo que al
    -- final, el universo seleccionado sera: los registros de las nominas que vienen en el
    -- movimiento, mas los registros de las NP generadas de las nominas que no vinieron en el
    -- movimiento.
    -- *********************************************************************************************
     facturas AS (
       SELECT a.id_registro_patronal,
       		  a.id_nomina,
       		  a.tipo_nomina,
              b.id_nss
         FROM SFC_FACTURAS_T a,
              SFC_DET_FACTURAS_T b,
              nominas_movimiento cc
        WHERE a.id_referencia = b.id_referencia
          --
          AND a.id_nomina = cc.id_nomina(+)
          AND cc.id_nomina IS NULL
          --
          AND a.id_registro_patronal = p_id_registro_patronal
          AND a.periodo_factura = p_periodo_factura
          --
          AND a.status NOT IN ('RE', 'CA')
          --
          AND a.tipo_nomina != 'L'
     ),
    -- *********************************************************************************************
    -- Selecciona la informacion de escala salarial correspondiente al periodo.
    -- *********************************************************************************************
     escala_salarial AS (
       SELECT cod_sector,
              MAX (salario_minimo) salario_minimo
         FROM SRE_ESCALA_SALARIAL_T
        WHERE p_fecha_inicio_periodo
      BETWEEN fecha_inicio AND NVL(fecha_fin, sfc_c_ss_pkg.LAST_DAY)
       GROUP BY cod_sector
     ),
    -- *********************************************************************************************
    -- Aplica el alza salarial a los trabajadores que le corresponde
    -- *********************************************************************************************
     trab_con_escala AS (
       SELECT aa.*,
              sfc_c_ss_pkg.get_salario_ss_raised(aa.is_raise, aa.cod_ingreso, aa.salario_ss,
              	bb.salario_minimo) salario_ss_raised,
			  bb.salario_minimo   --dp290615
         FROM trabajadores aa,
              escala_salarial bb
        WHERE aa.cod_sector = bb.cod_sector(+)
    ),
    -- *********************************************************************************************
    -- De los trabajadores con alza salarial, totaliza los salarios para poder hacer la proporcion
    -- en los casos de los empleados que esten en mas de una nomina.
    -- *********************************************************************************************
     sum_salarios_nom AS (
       SELECT id_registro_patronal,
              id_nss,
              SUM(salario_ss) sum_salario_ss
         FROM trab_con_escala
       GROUP BY id_registro_patronal, id_nss
       HAVING COUNT (*) > 1
    ),
    -- *********************************************************************************************
    -- Determina la cantidad de dependientes de cada trabajador
    -- *********************************************************************************************
     dependientes AS (
       SELECT a.id_registro_patronal,
              a.id_nomina,
              a.id_nss,
              COUNT (*) cnt_dependientes
         FROM SRE_DEPENDIENTE_T a,
              SRE_CIUDADANOS_T b
        WHERE a.id_nss_dependiente = b.id_nss
          AND a.status = 'A'
           --
          AND b.fecha_nacimiento < p_fecha_inicio_periodo
           --
          AND a.id_registro_patronal = p_id_registro_patronal
           --
       GROUP BY a.id_registro_patronal, a.id_nomina, a.id_nss
    ),
    -- *********************************************************************************************
    -- Nominas de las NP que hayan sido pagadas o autorizadas. Esto es para excluirlas y no gene-
    -- rarle NP. Esta exclusion se logra con la condicion: AND aa.id_nomina = ee.id_nomina(+)
    -- AND ee.id_nomina IS NULL.
    -- *********************************************************************************************
     nominas_pagadas AS (
       SELECT id_nomina
         FROM SFC_FACTURAS_T
        WHERE (status = 'PA' OR no_autorizacion IS NOT NULL)
           --
          AND id_registro_patronal = p_id_registro_patronal
          AND periodo_factura = p_periodo_factura
     ),
    -- *********************************************************************************************
    -- Montos pagados de trabajadores que esten en mas de una nómina.
    -- *********************************************************************************************
     montos_pagados AS (
       SELECT a.id_registro_patronal,
              b.id_nss,
              sum(b.salario_ss) sum_salario_pa
         FROM SFC_FACTURAS_T a,
              SFC_DET_FACTURAS_T b
        WHERE a.id_referencia = b.id_referencia
          AND (a.status = 'PA' OR a.no_autorizacion IS NOT NULL)
           --
          AND a.id_registro_patronal = p_id_registro_patronal
          AND a.periodo_factura = p_periodo_factura
       GROUP BY a.id_registro_patronal, b.id_nss
     )
  -- *************************************************************************************************
  --   M A I N
  -- *************************************************************************************************
  SELECT aa.id_registro_patronal,
         aa.tipo_empresa,
         NVL (aa.descuento_penalidad / 100, 0),
         aa.id_riesgo,
         aa.escalar_salario, --dp290615
         aa.id_nomina,
         aa.tipo_nomina,
         aa.id_nss,
         sfc_c_ss_pkg.get_salario_ss(cc.sum_salario_ss, aa.salario_ss_raised,
         aa.salario_ss, sum_salario_pa),
         aa.aporte_voluntario,
         aa.agente_retencion_ss,
         NVL (bb.cnt_dependientes, 0),
         sfc_c_ss_pkg.get_sum_salario_ss(aa.salario_ss_raised, cc.sum_salario_ss),
         NULL,
         NULL,
         NULL,
         aa.salario_ss,
         aa.cod_sector,
         NULL           --dp170214
    FROM trab_con_escala aa,
         dependientes bb,
         sum_salarios_nom cc,
         nominas_pagadas dd,
         montos_pagados ee
   WHERE aa.id_registro_patronal = bb.id_registro_patronal(+)
     AND aa.id_nomina = bb.id_nomina(+)
     AND aa.id_nss = bb.id_nss(+)
     --
     AND aa.id_registro_patronal = cc.id_registro_patronal(+)
     AND aa.id_nss = cc.id_nss(+)
     --
     AND aa.id_nomina = dd.id_nomina(+)
     AND dd.id_nomina IS NULL
     --
     AND aa.id_registro_patronal = ee.id_registro_patronal(+)
     AND aa.id_nss = ee.id_nss(+)
	 --
     AND sfc_c_ss_pkg.is_excluir_salario_X( 								--dp290615
     	 	aa.escalar_salario,
         	sfc_c_ss_pkg.get_sum_salario_ss(aa.salario_ss_raised, cc.sum_salario_ss),
     	 	aa.salario_minimo) = 'N'  									   --enddp290615
  ORDER BY aa.id_registro_patronal, aa.id_nomina;

-- *****************************************************************************************************

-- =====================================================================================================
-- Cursor usado para generar las NP de Auditoria.
-- =====================================================================================================

CURSOR c_auditoria (
	p_periodo_factura    						SFC_FACTURAS_T.periodo_factura%TYPE,
    p_fecha_inicio_periodo                   	date,
    p_id_registro_patronal                   	SFC_FACTURAS_T.id_registro_patronal%TYPE,
    p_id_movimiento                          	SRE_MOVIMIENTO_T.id_movimiento%TYPE
) RETURN t_ss_rec IS

    WITH
    -- *********************************************************************************************
    -- Movimientos que disparan la generacion de la NP
    -- *********************************************************************************************
     movimientos AS (
       SELECT a.id_movimiento,
              a.id_registro_patronal,
              b.id_nomina,
              b.id_nss,
              b.aporte_voluntario,
              b.salario_ss,
              b.periodo_aplicacion,
              b.pa_salario_ss,
              b.pa_aporte_voluntario,
              b.cod_ingreso
         FROM SRE_MOVIMIENTO_T a,
              SRE_DET_MOVIMIENTO_T b
        WHERE a.id_movimiento = b.id_movimiento
           --
          AND b.id_nss < 900000000
       -- AND b.salario_ss > 0                                              	--dp090817
          AND (b.salario_ss > g_salario_ss OR b.aporte_voluntario > 0)			--dp090817
           --
          AND a.id_movimiento = p_id_movimiento
         ),
    -- *********************************************************************************************
    -- Informacion de los trabajadores del movimiento
    -- De los movimientos se selecionan los que NO APLICAN para alza salarial.
    -- Aplica el alza salarial a los trabajadores que le corresponde
    -- *********************************************************************************************
     trabajadores AS (
       SELECT b.id_registro_patronal,
              b.tipo_empresa,
              b.descuento_penalidad,
              b.id_riesgo,
         	  b.escalar_salario, --dp290615
              aa.id_nomina,
              DECODE(aa.id_nomina, 888, 'P', 'N') tipo_nomina,
              aa.id_nss,
              aa.salario_ss,
              aa.aporte_voluntario,
              aa.periodo_aplicacion,
              aa.pa_salario_ss,
              aa.pa_aporte_voluntario,
              b.cod_sector,
              sfc_c_ss_pkg.get_salario_ss_raised(
              	sfc_c_ss_pkg.is_escalar_salario(b.escalar_salario,
              		DECODE(aa.id_nomina, 888, 'P', 'N')), aa.cod_ingreso, aa.salario_ss,
              		b.cod_sector, aa.periodo_aplicacion
           	  ) salario_ss_raised
         FROM movimientos aa,
              SRE_EMPLEADORES_T b
        WHERE aa.id_registro_patronal = b.id_registro_patronal
          AND b.id_registro_patronal = p_id_registro_patronal
         --
          AND b.id_inhabilidad_empleador IS NULL
     ),
    -- *********************************************************************************************
    -- Determina la cantidad de dependientes de cada trabajador
    -- *********************************************************************************************
     dependientes AS (
       SELECT a.id_registro_patronal,
              a.id_nomina,
              a.id_nss,
           	  COUNT (*) cnt_dependientes
         FROM SRE_DEPENDIENTE_T a,
              SRE_CIUDADANOS_T b
        WHERE a.id_nss_dependiente = b.id_nss
          AND a.status = 'A'
           --
          AND b.fecha_nacimiento < p_fecha_inicio_periodo
           --
          AND a.id_registro_patronal = p_id_registro_patronal
           --
       GROUP BY a.id_registro_patronal, a.id_nomina, a.id_nss
     ),
    -- *********************************************************************************************
    --  Valores IR13 del periodo
    -- *********************************************************************************************
     ir13 AS (
       SELECT id_registro_patronal,
              id_nss,
              agente_retencion_ss
         FROM SFC_IR13_T c
        WHERE periodo = p_periodo_factura
          AND id_registro_patronal = p_id_registro_patronal
     )
  -- *************************************************************************************************
  --   M A I N
  -- *************************************************************************************************
  SELECT aa.id_registro_patronal,
		 aa.tipo_empresa,
		 NVL (aa.descuento_penalidad / 100, 0),
		 aa.id_riesgo,
         aa.escalar_salario,  --dp290615
		 aa.id_nomina,
		 aa.tipo_nomina,
		 aa.id_nss,
		 aa.salario_ss_raised,
		 aa.aporte_voluntario,
		 cc.agente_retencion_ss,
		 NVL (bb.cnt_dependientes, 0),
		 aa.salario_ss_raised,
		 aa.periodo_aplicacion,
		 aa.pa_salario_ss,
		 aa.pa_aporte_voluntario,
		 aa.salario_ss,
		 aa.cod_sector,
       	 NULL           --dp170214
    FROM trabajadores aa,
		 dependientes bb,
		 ir13 cc
   WHERE aa.id_registro_patronal = bb.id_registro_patronal(+)
	 AND aa.id_nss = bb.id_nss(+)
	  --
	 AND aa.id_registro_patronal = cc.id_registro_patronal(+)
	 AND aa.id_nss = cc.id_nss(+)
     --
  ORDER BY aa.periodo_aplicacion;

-- =====================================================================================================
-- Cursor usado para generar las NP de Discapacitados.
-- =====================================================================================================

CURSOR c_discapacitados (
	p_periodo_factura    						SFC_FACTURAS_T.periodo_factura%TYPE,
    p_fecha_inicio_periodo                   	date,
    p_id_registro_patronal                   	SFC_FACTURAS_T.id_registro_patronal%TYPE,
    p_id_movimiento                          	SRE_MOVIMIENTO_T.id_movimiento%TYPE
) RETURN t_ss_rec IS

    WITH
    -- *********************************************************************************************
    -- Informacion de los trabajadores del movimiento
    -- De los movimientos se selecionan los que NO APLICAN para alza salarial.
    -- Aplica el alza salarial a los trabajadores que le corresponde
    -- *********************************************************************************************
     trabajadores AS (
       SELECT b.id_registro_patronal,
              b.tipo_empresa,
              b.descuento_penalidad,
              b.id_riesgo,
         	  b.escalar_salario,  --dp290615
              a.id_nomina,
              'L' tipo_nomina,
              a.id_nss,
              a.salario_ss,
              a.aporte_voluntario,
              a.periodo_aplicacion,
              a.pa_salario_ss,
              a.pa_aporte_voluntario,
              b.cod_sector,
              sfc_c_ss_pkg.get_salario_ss_raised(
              	sfc_c_ss_pkg.is_escalar_salario(b.escalar_salario,
              		DECODE(a.id_nomina, 888, 'P', 'N')), a.cod_ingreso, a.salario_ss,
              		b.cod_sector, a.periodo_aplicacion
           	  ) salario_ss_raised
         FROM SRE_MOVIMIENTOS_DISCAP_TMP_T a,
              SRE_EMPLEADORES_T b
        WHERE a.id_registro_patronal = b.id_registro_patronal
          AND b.id_registro_patronal = p_id_registro_patronal
         --
          AND b.id_inhabilidad_empleador IS NULL
         --
          AND a.id_movimiento = p_id_movimiento
         --
          AND (a.salario_ss > g_salario_ss OR a.aporte_voluntario > 0)			--dp090817
     ),
    -- *********************************************************************************************
    -- Determina la cantidad de dependientes de cada trabajador
    -- *********************************************************************************************
     dependientes AS (
       SELECT a.id_registro_patronal,
              a.id_nomina,
              a.id_nss,
           	  COUNT (*) cnt_dependientes
         FROM SRE_DEPENDIENTE_T a,
              SRE_CIUDADANOS_T b
        WHERE a.id_nss_dependiente = b.id_nss
          AND a.status = 'A'
           --
          AND b.fecha_nacimiento < p_fecha_inicio_periodo
           --
          AND a.id_registro_patronal = p_id_registro_patronal
           --
       GROUP BY a.id_registro_patronal, a.id_nomina, a.id_nss
     ),
    -- *********************************************************************************************
    --  Valores IR13 del periodo
    -- *********************************************************************************************
     ir13 AS (
       SELECT id_registro_patronal,
              id_nss,
              agente_retencion_ss
         FROM SFC_IR13_T c
        WHERE periodo = p_periodo_factura
          AND id_registro_patronal = p_id_registro_patronal
     )
  -- *************************************************************************************************
  --   M A I N
  -- *************************************************************************************************
  SELECT aa.id_registro_patronal,
		 aa.tipo_empresa,
		 NVL (aa.descuento_penalidad / 100, 0),
		 aa.id_riesgo,
		 aa.escalar_salario,												--dp290615
		 aa.id_nomina,
		 aa.tipo_nomina,
		 aa.id_nss,
		 aa.salario_ss_raised,
		 aa.aporte_voluntario,
		 cc.agente_retencion_ss,
		 NVL (bb.cnt_dependientes, 0),
		 aa.salario_ss_raised,
		 aa.periodo_aplicacion,
		 aa.pa_salario_ss,
		 aa.pa_aporte_voluntario,
		 aa.salario_ss,
		 aa.cod_sector,
		 NULL
    FROM trabajadores aa,
		 dependientes bb,
		 ir13 cc
   WHERE aa.id_registro_patronal = bb.id_registro_patronal(+)
	 AND aa.id_nss = bb.id_nss(+)
	  --
	 AND aa.id_registro_patronal = cc.id_registro_patronal(+)
	 AND aa.id_nss = cc.id_nss(+)
    --
  ORDER BY aa.id_nss, aa.periodo_aplicacion;

-- *****************************************************************************************************

END Sfc_C_Ss_Pkg;
