CREATE OR REPLACE PACKAGE BODY SUIRPLUS.sfc_c_ss_pkg IS
-- *****************************************************************************************************
-- Program:		sfc_c_ss_pkg
-- Descripcion: Cursores a usar en las Facturas SS
--
-- Modification history
-- -----------------------------------------------------------------------------------------------------
-- Date	  By Remark
-- -----------------------------------------------------------------------------------------------------
-- 080910 dp Creation de metodos para usar en cursores.
-- 300813 dp Cambios para cambiar el concepto de las NP de SS de CANCELADAS (CA) a RECALCULADAS (RE).
-- 290615 dp Cambios en manejo sre_empleadores_t.escalar_salario: 'E' - Escalar, 'N' - NO escalar,  
--           'X' - Excluir del detalle trabajadores por debajo del salario minimo del grupo.
-- 090817 dp Task #11555: Validar NP: salario_ss > parámetro OR aporte_voluntario > 0
--
-- (dp - David Pineda)
-- *****************************************************************************************************

g_periodo_inicio_SRL             			sfc_facturas_t.periodo_factura%type;	--dp250913

FUNCTION is_trab_activo(
	p_status             		 			sre_trabajadores_t.status%type,
	p_fecha_salida             				sre_trabajadores_t.fecha_salida%type,
	p_periodo_factura             		 	sfc_facturas_t.periodo_factura%type,
	p_fecha_ult_reintegro             		sre_trabajadores_t.fecha_salida%type DEFAULT NULL,
	p_fecha_ingreso             			sre_trabajadores_t.fecha_salida%type DEFAULT NULL
) RETURN CHAR IS

	v_return								CHAR;
	v_YYYYMM_ingreso             			NUMBER;

BEGIN

	v_return := 'N';

	IF p_status = 'A' OR
		(	p_status = 'B' AND
			p_fecha_salida > TO_DATE (TO_CHAR (p_periodo_factura) || '01', 'YYYYMMDD')
		 )
	THEN
		v_return := 'Y';
	END IF;

	if v_return = 'N' then goto is_ta_exit; end if;

	if p_fecha_ult_reintegro is null and p_fecha_ingreso is null then
		goto is_ta_exit;
	end if;

	v_YYYYMM_ingreso := TO_NUMBER(TO_CHAR(nvl(p_fecha_ult_reintegro, p_fecha_ingreso), 'YYYYMM'));
	if v_YYYYMM_ingreso > p_periodo_factura then
		v_return := 'N';
		goto is_ta_exit;
	end if;

<<is_ta_exit>>

	return v_return;

EXCEPTION WHEN OTHERS THEN Errorpkg.HandleAll(FALSE); RAISE;
END is_trab_activo;

-- *****************************************************************************************************

FUNCTION is_escalar_salario(
	p_escalar_salario             		 	sre_empleadores_t.escalar_salario%type,
	p_tipo_nomina             				sre_nominas_t.tipo_nomina%type
) RETURN CHAR
RESULT_CACHE
IS

	v_return								CHAR := 'N';

BEGIN

   	--if not nvl(p_escalar_salario, 'N') = 'S' then
   	--	goto is_es_exit; end if;

--dp290615
	--if p_tipo_nomina = 'N' then v_return := 'Y'; end if;
	v_return := p_escalar_salario;
	if nvl(p_escalar_salario, 'N') = 'E' then 
		if p_tipo_nomina != 'N' then 
			v_return := 'N';
		end if;
	end if;
--enddp290615

<<is_es_exit>>

	return v_return;

EXCEPTION WHEN OTHERS THEN Errorpkg.HandleAll(FALSE); RAISE;
END is_escalar_salario;

-- *****************************************************************************************************

FUNCTION get_salario_ss_raised(
	p_is_raise             		 		    CHAR,
	p_cod_ingreso             		 		sre_trabajadores_t.cod_ingreso%type,
	p_salario_ss             		 		sre_det_movimiento_t.salario_ss%type,
	p_salario_minimo         		 		sre_det_movimiento_t.salario_ss%type
) RETURN sre_det_movimiento_t.salario_ss%type
RESULT_CACHE RELIES_ON (sre_escala_salarial_t)
IS

	v_salario_ss_raised             		sre_det_movimiento_t.salario_ss%type;
    v_salario_minimo                       	sre_det_movimiento_t.salario_ss%type;

BEGIN

    v_salario_minimo := nvl(p_salario_minimo, 0);

   --dpqd cod_ingreso = 1 and tipo_nomina normal escala

--dp290615
/*
    IF p_is_raise = 'N' THEN
		v_salario_ss_raised := p_salario_ss;
   	else
		IF p_cod_ingreso = 1 and p_salario_ss < v_salario_minimo THEN
			v_salario_ss_raised := v_salario_minimo;
		--ELSIF p_salario_ss > v_salario_minimo THEN
		--	v_salario_ss_raised := p_salario_ss;
		--ELSE
			--v_salario_ss_raised := v_salario_minimo;
            else
            v_salario_ss_raised := p_salario_ss;
		END IF;
   	end if;
*/

	v_salario_ss_raised := p_salario_ss;
	IF p_is_raise= 'E' THEN
      	IF p_cod_ingreso = 1 THEN
        	IF p_salario_ss < v_salario_minimo THEN
          		v_salario_ss_raised := v_salario_minimo;
        	END IF;
      	END IF;
   	END IF;

--enddp290615

	RETURN v_salario_ss_raised;

EXCEPTION WHEN OTHERS THEN Errorpkg.HandleAll(FALSE); RAISE;
END get_salario_ss_raised;

-- *****************************************************************************************************

FUNCTION get_salario_ss_raised(
	p_is_raise             		 			CHAR,
	p_cod_ingreso             		 		sre_trabajadores_t.cod_ingreso%type,
	p_salario_ss             		 		sre_det_movimiento_t.salario_ss%type,
	p_cod_sector             		 		sre_escala_salarial_t.cod_sector%type,
	p_periodo_aplicacion             		sre_det_movimiento_t.periodo_aplicacion%type
) RETURN sre_det_movimiento_t.salario_ss%type
RESULT_CACHE RELIES_ON (sre_escala_salarial_t)
IS

	v_salario_minimo                		sre_det_movimiento_t.salario_ss%type;

	CURSOR c_esc (
		p_cod_sector             		 	sre_escala_salarial_t.cod_sector%type,
		p_periodo_aplicacion             	sre_det_movimiento_t.periodo_aplicacion%type
	) IS
		SELECT MAX (salario_minimo) salario_minimo
		  FROM sre_escala_salarial_t
		 WHERE cod_sector = p_cod_sector
		   AND srp_pkg.fecha_inicio_periodo(p_periodo_aplicacion)
	   BETWEEN fecha_inicio AND NVL(fecha_fin, sfc_c_ss_pkg.LAST_DAY);

BEGIN

	OPEN c_esc(p_cod_sector, p_periodo_aplicacion);
	FETCH c_esc INTO v_salario_minimo;
	CLOSE c_esc;

   	v_salario_minimo := nvl(v_salario_minimo, 0);

	RETURN get_salario_ss_raised(p_is_raise, p_cod_ingreso, p_salario_ss, v_salario_minimo);

EXCEPTION WHEN OTHERS THEN Errorpkg.HandleAll(FALSE); RAISE;
END get_salario_ss_raised;

-- *****************************************************************************************************

FUNCTION get_salario_ss(
	p_sum_salario_ss             		 	sre_det_movimiento_t.salario_ss%type,
	p_salario_ss_raised         		 	sre_det_movimiento_t.salario_ss%type,
	p_salario_ss                		 	sre_det_movimiento_t.salario_ss%type,
    p_sum_salario_pa                        sre_det_movimiento_t.salario_ss%type default 0
) RETURN sre_det_movimiento_t.salario_ss%type IS

	v_salario_ss                		 	sre_det_movimiento_t.salario_ss%type;

BEGIN

	if p_sum_salario_ss is null then
		v_salario_ss := p_salario_ss_raised;
    elsif  p_sum_salario_ss > p_salario_ss_raised then
        v_salario_ss := p_salario_ss;
	elsif p_salario_ss < nvl(p_sum_salario_ss, 0) then
		v_salario_ss := (p_salario_ss_raised - nvl(p_sum_salario_pa,0)) * (p_salario_ss / p_sum_salario_ss);
	else
		v_salario_ss := p_salario_ss;
	end if;

	return v_salario_ss;

EXCEPTION WHEN OTHERS THEN Errorpkg.HandleAll(FALSE); RAISE;
END get_salario_ss;

-- *****************************************************************************************************

FUNCTION get_sum_salario_ss(
	p_salario_ss_raised             		sre_det_movimiento_t.salario_ss%type,
	p_sum_salario_ss                 		sre_det_movimiento_t.salario_ss%type
) RETURN sre_det_movimiento_t.salario_ss%type IS

	v_sum_salario_ss_reportado              sre_det_movimiento_t.salario_ss%type;
	v_sum_salario_ss                 		sre_det_movimiento_t.salario_ss%type;

BEGIN

	v_sum_salario_ss_reportado := nvl(p_sum_salario_ss, 0);

	if p_salario_ss_raised > v_sum_salario_ss_reportado THEN
		v_sum_salario_ss := p_salario_ss_raised;
	else
		v_sum_salario_ss := v_sum_salario_ss_reportado;
	end if;

	return v_sum_salario_ss;

EXCEPTION WHEN OTHERS THEN Errorpkg.HandleAll(FALSE); RAISE;
END get_sum_salario_ss;

--******************************************************************************************************

--dp250913
FUNCTION is_parm_zero(
	p_periodo_factura 		    			sfc_facturas_t.periodo_factura%type,
	p_id_tipo_nomina             			sre_nominas_t.tipo_nomina%type
) RETURN CHAR
RESULT_CACHE
IS

	v_sum_parm              				number := 0;
	v_return                				char;
  	a                              			varchar2(16); 						-- id_aplicacion
  	r                              			varchar2(16); 						-- id_renglon
	n                            			sre_nominas_t.tipo_nomina%TYPE; 	-- id nomina
  	t                              			sfc_pkg.t_nomina_parm_tbl; 			-- tabla parm nomina

	-- RENGLONES:
  	-- svds = Seguro Vejez, Discapacidad y Sobrevivencia (Pension)
  	-- sfs  = Seguro Familiar de Salud (Salud)
  	-- srl  = Seguro Riesgo Laboral (Riesgo)

BEGIN

  	a := 'SS';
	t := sfc_pkg.get_nomina_parm_tbl(p_periodo_factura);
  	n := p_id_tipo_nomina;

  	-- Valores SVDS (Pension)
  	r := 'SVDS';
  	if sfc_pkg.is_nom_aplica(a, r, n) then
		v_sum_parm :=
			t(a)(r)(n)('APORTE_EMPLEADOR') +
    		t(a)(r)(n)('APORTE_AFILIADO') +
    		t(a)(r)(n)('CUENTA_PERSONAL') +
    		t(a)(r)(n)('SEGURO_VIDA_AFILIADO') +
    		t(a)(r)(n)('FONDO_SOLIDARIDAD_SOCIAL') +
    		t(a)(r)(n)('OPERACION_SIPEN') +
    		t(a)(r)(n)('COMISION_AFP');
  	end if;

  	-- Valores SFS (Salud)
  	r := 'SFS';
  	if sfc_pkg.is_nom_aplica(a, r, n) then
		v_sum_parm :=
			v_sum_parm +
    		t(a)(r)(n)('APORTE_EMPLEADOR') +
    		t(a)(r)(n)('APORTE_AFILIADO') +
    		t(a)(r)(n)('CUIDADO_SALUD') +
    		t(a)(r)(n)('ESTANCIAS_INFANTILES') +
    		t(a)(r)(n)('SUBSIDIOS') +
    		t(a)(r)(n)('OPERACION_SISALRIL');
  	end if;

  	-- Valores SRL (Riesgo)
  	r := 'SRL';
  	if sfc_pkg.is_nom_aplica(a, r, n) then
    	if p_periodo_factura >= g_periodo_inicio_SRL then
			v_sum_parm :=
				v_sum_parm +
      			t(a)(r)(n)('OPERACION_SISALRIL');
    	end if;
  	end if;

	if v_sum_parm = 0 then
		v_return := 'Y';
	else
		v_return := 'N';
	end if;

	return v_return;

EXCEPTION WHEN OTHERS THEN Errorpkg.HandleAll(FALSE); RAISE;
END is_parm_zero;

--******************************************************************************************************

--dp290615
FUNCTION is_excluir_salario_X (
  	p_escalar_salario               		sre_empleadores_t.escalar_salario%type,
  	p_sum_salario_ss                		sre_det_movimiento_t.salario_ss%type,
  	p_salario_minimo                  		sre_det_movimiento_t.salario_ss%type
) RETURN CHAR
RESULT_CACHE
IS

	v_return								CHAR := 'N';

BEGIN

	if p_escalar_salario = 'X' and
	   p_sum_salario_ss < p_salario_minimo 
	then
	   v_return := 'Y';
	end if;

	return v_return;

EXCEPTION WHEN OTHERS THEN Errorpkg.HandleAll(FALSE); RAISE;
END is_excluir_salario_X;
--end dp290615

--******************************************************************************************************

BEGIN -- initialization

	g_periodo_inicio_SRL := Parm.get_parm_number('22');  			--dpqd
	g_salario_ss := Parm.get_parm_number('354');  --dp090817   		--dpqd

--end dp250913

END sfc_c_ss_pkg;