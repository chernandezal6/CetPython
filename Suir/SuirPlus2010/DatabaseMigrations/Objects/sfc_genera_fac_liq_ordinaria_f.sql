CREATE OR REPLACE FUNCTION SUIRPLUS.SFC_GENERA_FAC_LIQ_ORDINARIA_F (
	pp_return out							seg_error_t.id_error%type,
	pp_error_seq out						number,
	pp_periodo_factura 		    			sfc_facturas_t.periodo_factura%type,
	pp_id_registro_patronal     			sfc_facturas_t.id_registro_patronal%type,
	pp_id_nomina 		    				sfc_facturas_t.id_nomina%type,
	pp_usuario                         		SFC_FACTURAS_T.ult_usuario_act%TYPE DEFAULT NULL,
	pp_is_bitacora							boolean default true,
	pp_is_commit  							boolean default true

) RETURN BOOLEAN AS

-- *****************************************************************************************************
-- Program    : sfc_genera_fac_liq_ordinaria_f
-- Descripcion: Genera de forma individual, una factura de la Seguridad Social una Liquidacion del ISR
--				dado los parámetros correspondientes. Su creación fue para que sea ejecutado por el
--				triger de cambio de tipo de factura.
--
-- Modification History
-- -----------------------------------------------------------------------------------------------------
-- Date	  by Remark
-- -----------------------------------------------------------------------------------------------------
-- 100117 dp Creation.  Se rehizo nuevamente desde cero, basado en sfc_opera_movimiento_f. El anterior 
--           se renombro como sfc_genera_fac_liq_ordinaria_f_v1.
--
-- dp - David Pineda
--
-- *****************************************************************************************************

-- *****************************************************************************************************
--                        Global variables
-- *****************************************************************************************************
--
ID_PROCESO                     				CONSTANT SFC_PROCESOS_T.id_proceso%TYPE := '02';
g_module                       				ERRORS.MODULE%TYPE;
g_ErrorSeq                     				NUMBER;
g_id_bitacora                     			SFC_BITACORA_T.id_bitacora%TYPE;
g_mensage                         			SFC_BITACORA_T.mensage%TYPE DEFAULT NULL;
e_Houston                     				EXCEPTION;
g_sysdate                         			DATE;
g_return                    				SEG_ERROR_T.id_error%TYPE;
g_periodo_ini_ley_amnistia            		SRE_MOVIMIENTO_T.periodo_factura%TYPE;  --dp190609

p                             				Parm;

TYPE t_mov_rec                				IS RECORD (
  id_tipo_movimiento                   			SRE_TIPO_MOVIMIENTO_T.id_tipo_movimiento%TYPE,
  id_tipo_factura                     			SRE_TIPO_MOVIMIENTO_T.id_tipo_factura%TYPE,
  fuente_lectura                     			SRE_TIPO_MOVIMIENTO_T.fuente_lectura%TYPE,
  cancela_factura_SS                   			SRE_TIPO_MOVIMIENTO_T.cancela_factura_SS%TYPE,
  cancela_liquidacion_ISR              			SRE_TIPO_MOVIMIENTO_T.cancela_liquidacion_ISR%TYPE,
  cancela_liquidacion_infotep         			SRE_TIPO_MOVIMIENTO_T.cancela_liquidacion_infotep%TYPE,
  genera_factura_SS                   			SRE_TIPO_MOVIMIENTO_T.genera_factura_SS%TYPE,
  genera_liquidacion_ISR               			SRE_TIPO_MOVIMIENTO_T.genera_liquidacion_ISR%TYPE,
  genera_factura_infotep                 		SRE_TIPO_MOVIMIENTO_T.genera_factura_infotep%TYPE,
  genera_recargo_SS                   			SRE_TIPO_MOVIMIENTO_T.genera_recargo_SS%TYPE,
  genera_recargo_ISR                   			SRE_TIPO_MOVIMIENTO_T.genera_recargo_ISR%TYPE,
  genera_recargo_infotep                 		SRE_TIPO_MOVIMIENTO_T.genera_recargo_infotep%TYPE
);

-- *****************************************************************************************************
--                      					  Local Process
-- *****************************************************************************************************

FUNCTION get_mov_values (
  p_periodo_factura               			SRE_MOVIMIENTO_T.periodo_factura%TYPE,
  p_id_registro_patronal             		SFC_LIQUIDACION_ISR_T.id_registro_patronal%TYPE,
  p_id_nomina                 				SRE_DET_MOVIMIENTO_T.id_nomina%TYPE,
  p_id_tipo_movimiento                   	SRE_TIPO_MOVIMIENTO_T.id_tipo_movimiento%TYPE,
  p_mov OUT                 				t_mov_rec,
  p_tipo_nomina OUT                  		SFC_FACTURAS_T.tipo_nomina%TYPE,
  p_is_ss_pagada OUT              			BOOLEAN,
  p_is_isr_pagada OUT             			BOOLEAN,
  p_is_infotep_pagada OUT           		BOOLEAN
) RETURN BOOLEAN IS

  v_is_ok        boolean;
  v_status_cobro char(1); --dp100912

  CURSOR c_mov (
    p_id_tipo_movimiento                 	SRE_TIPO_MOVIMIENTO_T.id_tipo_movimiento%TYPE
  )IS
    SELECT id_tipo_movimiento, id_tipo_factura, fuente_lectura, cancela_factura_SS,
         cancela_liquidacion_ISR, cancela_liquidacion_infotep, genera_factura_SS,
         genera_liquidacion_ISR, genera_factura_infotep, genera_recargo_SS,
         genera_recargo_ISR, genera_recargo_infotep
      FROM SRE_TIPO_MOVIMIENTO_T
       WHERE id_tipo_movimiento = p_id_tipo_movimiento;

  --dp100912
  CURSOR c_sc (
    p_id_registro_patronal        			SRE_MOVIMIENTO_T.id_movimiento%TYPE
  )IS
    --Cambiada por el ticket 6837
    SELECT suirplus.sre_empleadores_pkg.IsEmpleadorEnLegal(p_id_registro_patronal)
    FROM dual;

BEGIN

  v_is_ok := true;

  OPEN c_mov(p_id_tipo_movimiento);
  FETCH c_mov INTO p_mov;
  IF c_mov%NOTFOUND THEN
    CLOSE c_mov;
    g_return := '603';
    v_is_ok := FALSE;
    goto get_exit;
  END IF;
  CLOSE c_mov;

  --dp100912
  open c_sc(p_id_registro_patronal);
  fetch c_sc INTO v_status_cobro;
  if c_sc%notfound then
    CLOSE c_sc;
    g_return := '603';
    v_is_ok := FALSE;
    goto get_exit;
  end if;
  close c_sc;

    if p_id_tipo_movimiento = 'AR' and
       v_status_cobro = 'L'
    then
      p_mov.cancela_factura_ss := 'N';
    p_mov.genera_factura_ss := 'N';
    p_mov.genera_recargo_ss := 'N';
    end if;
  --end dp100912

  p_is_ss_pagada := Sfc_Pkg.is_fac_ss_pagada( p_periodo_factura, p_id_registro_patronal,
    p_id_nomina, p_tipo_nomina);
  p_is_isr_pagada := Sfc_Pkg.is_liq_isr_pagada( p_periodo_factura, p_id_registro_patronal);
  if p_id_tipo_movimiento = 'BO' then
    p_is_infotep_pagada := Sfc_Pkg.is_liq_infotep_bonif_pagada( p_periodo_factura,
      p_id_registro_patronal);
  else
    p_is_infotep_pagada := Sfc_Pkg.is_liq_infotep_pagada( p_periodo_factura,
      p_id_registro_patronal);
  end if;

<<get_exit>>

  RETURN v_is_ok;

EXCEPTION WHEN OTHERS THEN Errorpkg.HandleAll(FALSE); RAISE;
END get_mov_values;

-- *****************************************************************************************************

FUNCTION genera_factura_ss (
  p_periodo_factura               				SRE_MOVIMIENTO_T.periodo_factura%TYPE,
  p_id_registro_patronal             			SFC_facturas_T.id_registro_patronal%TYPE,
  p_id_nomina                 					SFC_facturas_T.id_nomina%TYPE,
  p_id_tipo_movimiento                   		SRE_TIPO_MOVIMIENTO_T.id_tipo_movimiento%TYPE,
  p_id_movimiento               				SRE_MOVIMIENTO_T.id_movimiento%TYPE,
  p_mov                     					t_mov_rec,
  p_id_ref_ss_origen             				SFC_FACTURAS_T.id_referencia_origen%TYPE,
  p_id_ref_ss_generadas OUT           			Sfc_Pkg.t_id_referencia_tbl,
  p_id_tipo_factura                   			sfc_facturas_t.id_tipo_factura%type
) RETURN BOOLEAN IS

  v_tipo_fac                             		VARCHAR2(02);
  v_return                  					SEG_ERROR_T.id_error%TYPE;
  v_error_seq                             		number;

  v_id_tipo_factura                   			sfc_facturas_t.id_tipo_factura%type;
  v_rtn                                  		BOOLEAN := TRUE;

BEGIN

  IF p_periodo_factura < g_periodo_ini_ley_amnistia THEN GOTO genera_exit; END IF; --dp190609

  IF p_id_tipo_movimiento IN ('RA','NA') THEN
    v_tipo_fac := srp_const.SS_F_AUDITORIA; -- AUDITORIA Y NOVEDADES ATRASADAS
    GOTO genera;
  ELSIF p_id_tipo_movimiento = 'PRE' THEN
    v_tipo_fac := srp_const.SS_F_DISCAPACITADOS; -- DISCAPACITADOS
    GOTO genera;
  END IF;

  CASE p_mov.fuente_lectura
  WHEN 'T' THEN -- ORDINARIA                 
   -- IF p_id_nomina IS NOT NULL THEN  dpqd
      -- Vino con una sola nomina
    --  v_tipo_fac := srp_const.SS_SS_F_ORDINARIA; -- ORDINARIA UNA NOMINA
   -- ELSE
      -- Vino sin nomina, eso quiere decir que hay que procesarlas todas las nominas de ese
      -- empleador
      v_tipo_fac := srp_const.SS_F_ORDINARIA_N; -- ORDINARIA VARIAS NOMINAS
   -- END IF;
  ELSE -- RETROACTIVA
    IF p_id_nomina IS NOT NULL THEN
      -- Vino con una sola nomina
      v_tipo_fac := srp_const.SS_F_RETROACTIVA; -- RETROACTIVA UNA NOMINA
    ELSE
      -- Vino sin nomina, eso quiere decir que hay que procesarlas todas las nominas de ese
      -- empleador
      v_tipo_fac := srp_const.SS_F_RETROACTIVA_N; -- RETROACTIVA VARIAS NOMINAS
    END IF;
  END CASE;

<<genera>>

  if p_id_tipo_factura = 'Y' then
    v_id_tipo_factura := p_id_tipo_factura;
  else
    v_id_tipo_factura := p_mov.id_tipo_factura;
  end if;

  IF NOT Sfc_Ss_F(v_tipo_fac, v_return, v_error_seq, p_id_ref_ss_generadas, p_periodo_factura,
    p_id_registro_patronal, p_id_nomina, v_id_tipo_factura, p_id_ref_ss_origen,
    p_id_movimiento, pp_is_bitacora, FALSE, pp_ult_usuario_act=>pp_usuario)
  THEN
    v_rtn := FALSE;
  END IF;

<<genera_exit>>  --dp190609

  RETURN v_rtn;

EXCEPTION WHEN OTHERS THEN Errorpkg.HandleAll(FALSE); RAISE;
END genera_factura_ss;

-- *****************************************************************************************************

FUNCTION genera_liquidacion_isr (
  p_periodo_factura               				SRE_MOVIMIENTO_T.periodo_factura%TYPE,
  p_id_registro_patronal             			SFC_LIQUIDACION_ISR_T.id_registro_patronal%TYPE,
  p_id_movimiento               				SRE_MOVIMIENTO_T.id_movimiento%TYPE,
  p_mov                     					t_mov_rec,
  p_id_ref_isr_generada OUT        				SFC_LIQUIDACION_ISR_T.id_referencia_isr%TYPE,
  p_id_tipo_movimiento             				SRE_MOVIMIENTO_T.id_tipo_movimiento%TYPE
) RETURN BOOLEAN IS

  v_tipo_liq                             		VARCHAR2(02);
  v_return                  					SEG_ERROR_T.id_error%TYPE;
  v_error_seq                             		number;

BEGIN

  IF p_id_tipo_movimiento = 'RT' THEN
    IF p_periodo_factura >= p.periodo_inicio_RECTIFICATIVA THEN
      v_tipo_liq := srp_const.ISR_F_RECTIFICATIVA; -- RECTIFICATIVA
    END IF;
  ELSE
    IF p_mov.fuente_lectura = 'T' THEN -- ORDINARIA
      -- En liquidacion ISR siempre se tienen que procesar todas las nóminas
      v_tipo_liq := srp_const.ISR_F_ORDINARIA;
    ELSE -- RETROACTIVA
      v_tipo_liq := srp_const.ISR_F_RETROACTIVA;
    END IF;
  END IF;

  IF NOT Sfc_Isr_F(v_tipo_liq, v_return, v_error_seq, p_id_ref_isr_generada,
    p_periodo_factura, p_id_registro_patronal, p_mov.id_tipo_factura, p_id_movimiento,
    pp_is_bitacora, FALSE)
  THEN
    RETURN FALSE;
  END IF;

  RETURN TRUE;

EXCEPTION WHEN OTHERS THEN Errorpkg.HandleAll(FALSE); RAISE;
END genera_liquidacion_isr;

-- *****************************************************************************************************

FUNCTION genera_liquidacion_infotep (
  p_periodo_factura               				SRE_MOVIMIENTO_T.periodo_factura%TYPE,
  p_id_registro_patronal             			SFC_LIQUIDACION_infotep_T.id_registro_patronal%TYPE,
  p_id_movimiento               				SRE_MOVIMIENTO_T.id_movimiento%TYPE,
  p_mov                     					t_mov_rec,
  p_id_ref_infotep_generada OUT      			SFC_LIQUIDACION_infotep_t.id_referencia_infotep%TYPE
) RETURN BOOLEAN IS

  v_tipo_liq                             		VARCHAR2(02);
  v_return                  					SEG_ERROR_T.id_error%TYPE;
  v_error_seq                             		number;

BEGIN

  case p_mov.id_tipo_movimiento
  when 'AR' then
    v_tipo_liq := srp_const.FAC_INFOTEP_RETROACTIVA;
  when 'BO' then
    v_tipo_liq := srp_const.FAC_INFOTEP_BONIFICACION;
  ELSE
    v_tipo_liq := srp_const.FAC_INFOTEP_ORDINARIA;
  end case;

  IF NOT Sfc_infotep_f(v_tipo_liq, v_return, v_error_seq, p_id_ref_infotep_generada,
    p_periodo_factura, p_id_registro_patronal, p_mov.id_tipo_factura, p_id_movimiento,
    pp_is_bitacora, FALSE)
  THEN
    RETURN FALSE;
  END IF;

  RETURN TRUE;

EXCEPTION WHEN OTHERS THEN Errorpkg.HandleAll(FALSE); RAISE;
END genera_liquidacion_infotep;

-- *****************************************************************************************************

FUNCTION recargos_int_ss (
  p_id_ref_ss_generadas              			Sfc_Pkg.t_id_referencia_tbl
) RETURN BOOLEAN IS

  v_ndx                       					BINARY_INTEGER;
  v_return                  					SEG_ERROR_T.id_error%TYPE;
  v_error_seq                             		number;

BEGIN

  FOR v_ndx IN p_id_ref_ss_generadas.FIRST..p_id_ref_ss_generadas.LAST LOOP
    IF NOT Sfc_Rec_Int_Retro_Fac_Ss_F(v_return, v_error_seq, p_id_ref_ss_generadas(v_ndx))
    THEN
      RETURN FALSE;
    END IF;
  END LOOP;

  RETURN TRUE;

EXCEPTION WHEN OTHERS THEN Errorpkg.HandleAll(FALSE); RAISE;
END recargos_int_ss;

-- *****************************************************************************************************

function do_process (
  p_periodo_factura               				SRE_MOVIMIENTO_T.periodo_factura%TYPE,
  p_id_registro_patronal             			SFC_LIQUIDACION_ISR_T.id_registro_patronal%TYPE,
  p_id_nomina                 					SRE_DET_MOVIMIENTO_T.id_nomina%TYPE,
  p_id_tipo_movimiento             				SRE_MOVIMIENTO_T.id_tipo_movimiento%TYPE,
  p_id_movimiento               				SRE_MOVIMIENTO_T.id_movimiento%TYPE,
  p_usuario                         			SFC_FACTURAS_T.ult_usuario_act%TYPE
) return boolean as

  v_is_ok                   					boolean;

  v_periodo_factura               				SRE_MOVIMIENTO_T.periodo_factura%TYPE;
  v_id_registro_patronal             			SFC_LIQUIDACION_ISR_T.id_registro_patronal%TYPE;
  v_id_tipo_movimiento             				SRE_MOVIMIENTO_T.id_tipo_movimiento%TYPE;

  v_mov                   						t_mov_rec;
  v_tipo_nomina               					SFC_FACTURAS_T.tipo_nomina%TYPE;

  v_is_ss_pagada                 				BOOLEAN := FALSE;
  v_is_isr_pagada                 				BOOLEAN := FALSE;
  v_is_infotep_pagada               			BOOLEAN := FALSE;

  v_id_ref_ss_origen             				SFC_FACTURAS_T.id_referencia_origen%TYPE;
  v_id_ref_isr_origen            				SFC_LIQUIDACION_ISR_T.id_referencia_isr%TYPE;
  v_id_ref_infotep_origen          				SFC_LIQUIDACION_infotep_T.id_referencia_infotep%TYPE;
  v_id_ref_ss_generadas              			Sfc_Pkg.t_id_referencia_tbl;
  v_id_ref_isr_generada          				SFC_LIQUIDACION_ISR_T.id_referencia_isr%TYPE;
  v_id_ref_infotep_generada        				SFC_LIQUIDACION_infotep_T.id_referencia_infotep%TYPE;


  -- *************************************************************************************************
  --dp141013
    function is_movimiento_SA(
        p_id_movimiento                   		SRE_MOVIMIENTO_T.id_movimiento%TYPE,
      p_id_oficio out                 			SFC_FACTURAS_T.id_oficio%TYPE,
      p_id_usuario_cancela out            		SFC_FACTURAS_T.id_usuario_cancela%TYPE
    ) return boolean as

    v_return                       				boolean := false;

    CURSOR c_sa(
        p_id_movimiento                   		SRE_MOVIMIENTO_T.id_movimiento%TYPE
     ) is
       SELECT b.sfs_secuencia, b.ult_usuario_act
          FROM sre_movimiento_t a,
               sre_det_movimiento_t b
         WHERE a.id_movimiento = b.id_movimiento
           AND a.id_movimiento = p_id_movimiento
           AND a.id_tipo_movimiento = 'NV'
           AND b.id_tipo_novedad = 'SA';

  BEGIN

      open c_sa(p_id_movimiento);
      fetch c_sa into p_id_oficio, p_id_usuario_cancela;
      if c_sa%FOUND then v_return := true; end if;
      close c_sa;

      return v_return;

    EXCEPTION WHEN OTHERS THEN Errorpkg.HandleAll(FALSE); RAISE;
    END is_movimiento_SA;
  --end dp141013

  -- *************************************************************************************************

  function do_cancela return boolean IS

    v_is_ok                 					boolean;
    v_return                					SEG_ERROR_T.id_error%TYPE;
    v_id_oficio             					SFC_FACTURAS_T.id_oficio%TYPE;             --dp141013
    v_usuario               					SFC_FACTURAS_T.id_usuario_cancela%TYPE;    --dp141013
    v_id_usuario_cancela         				SFC_FACTURAS_T.id_usuario_cancela%TYPE;    --dp141013

  BEGIN

    IF v_mov.cancela_factura_ss = 'S' AND NOT v_is_ss_pagada  THEN
      --dp141013
      if is_movimiento_SA(p_id_movimiento, v_id_oficio, v_usuario) then
        v_id_usuario_cancela := v_usuario;
      else
        v_id_usuario_cancela := p_usuario;
      end if;
      --end dp141013
      v_is_ok := Sfc_Pkg.cancela_factura_ss(v_periodo_factura, v_id_registro_patronal,
        -- p_id_nomina, g_sysdate, v_id_ref_ss_origen, v_return, p_usuario);
        NULL, g_sysdate, v_id_ref_ss_origen, v_return, v_id_usuario_cancela, --dp141013
        p_id_oficio => v_id_oficio);                           --dp141013
      if not v_is_ok then goto cancela_exit; end if;
    END IF;

    /*dp230410
    IF v_mov.cancela_liquidacion_ISR = 'S' AND
      NOT v_is_isr_pagada AND
      v_periodo_factura >= P.periodo_inicio_isr
    then
      v_is_ok := Sfc_Pkg.cancela_liquidacion_ISR(v_periodo_factura, v_id_registro_patronal,
      g_sysdate, v_id_ref_isr_origen, v_return);
      if not v_is_ok then goto cancela_exit; end if;
    elsif v_mov.id_tipo_movimiento = 'RT' and
        v_mov.cancela_liquidacion_ISR = 'S'
      --v_is_isr_pagada and                    --dp230410
      --v_periodo_factura >= p.periodo_inicio_rectificativa    --dp230410
    THEN
      v_is_ok := Sfc_Pkg.cancela_liquidacion_ISR(v_periodo_factura, v_id_registro_patronal,
        g_sysdate, v_id_ref_isr_origen, v_return, 'RT');
      if not v_is_ok then goto cancela_exit; end if;
    END IF;
    */
    IF v_mov.cancela_liquidacion_ISR = 'S' THEN
      IF v_mov.id_tipo_movimiento = 'RT' THEN
        v_is_ok := Sfc_Pkg.cancela_liquidacion_ISR(v_periodo_factura, v_id_registro_patronal,
          g_sysdate, v_id_ref_isr_origen, v_return, 'RT');
      ELSE
        IF NOT v_is_isr_pagada THEN
          v_is_ok := Sfc_Pkg.cancela_liquidacion_ISR(v_periodo_factura, v_id_registro_patronal,
          g_sysdate, v_id_ref_isr_origen, v_return);
        END IF;
      END IF;
    END IF;
    IF NOT v_is_ok THEN GOTO cancela_exit; END IF;
    --end dp230410

    IF v_mov.cancela_liquidacion_infotep = 'S' AND
      NOT v_is_infotep_pagada AND
      v_periodo_factura >= p.infotep_periodo_inicio
    THEN
      if v_id_tipo_movimiento = 'BO' then
        v_is_ok := Sfc_Pkg.cancela_liq_infotep_bonif(v_periodo_factura,
          v_id_registro_patronal, g_sysdate, v_id_ref_infotep_origen, v_return);
      else
        v_is_ok := Sfc_Pkg.cancela_liquidacion_infotep(v_periodo_factura,
          v_id_registro_patronal, g_sysdate, v_id_ref_infotep_origen, v_return);
      end if;
      if not v_is_ok then goto cancela_exit; end if;
    END IF;

  <<cancela_exit>>

    return v_is_ok;

  EXCEPTION WHEN OTHERS THEN Errorpkg.HandleAll(FALSE); RAISE;
  END do_cancela;

  -- *************************************************************************************************

  function do_facturas return boolean IS

    v_is_ok                 					boolean;
    v_id_tipo_factura                    		sfc_facturas_t.id_tipo_factura%type; --dp080707

  BEGIN

    IF v_mov.genera_factura_ss = 'S' THEN

      --dp300409
      if v_mov.Cancela_factura_ss = 'S' then
        --dp050907
        if v_id_ref_ss_origen is null then
          v_id_tipo_factura := sfc_pkg.get_id_tipo_factura(p_id_registro_patronal, p_periodo_factura);
        else
          v_id_tipo_factura := sfc_pkg.get_id_tipo_factura(v_id_ref_ss_origen);
        end if;
        --end dp050907
      else
        v_id_tipo_factura := v_mov.id_tipo_factura;
      end if;
      --end dp300409
                        --gh290409, incluir el tipo de factura en esta validación
      IF ((NOT v_is_ss_pagada) OR ( v_tipo_nomina = 'D') /*OR (v_id_tipo_factura ='U') by RJ & HM */) --gh290409
      THEN --dp260905
        v_is_ok := genera_factura_ss(v_periodo_factura, v_id_registro_patronal,
          p_id_nomina, v_id_tipo_movimiento, p_id_movimiento, v_mov, v_id_ref_ss_origen,
          v_id_ref_ss_generadas, v_id_tipo_factura);
        if not v_is_ok then goto facturas_exit; end if;
      END IF;

    END IF;

    IF (v_mov.genera_liquidacion_ISR = 'S' AND
      NOT v_is_isr_pagada AND
      v_periodo_factura >= P.periodo_inicio_isr)
      or
       (v_mov.id_tipo_movimiento = 'RT' and
        v_mov.genera_liquidacion_ISR = 'S' and
      v_is_isr_pagada and
      v_periodo_factura >= p.periodo_inicio_rectificativa)
    THEN
      v_is_ok := genera_liquidacion_isr(v_periodo_factura, v_id_registro_patronal,
        p_id_movimiento, v_mov, v_id_ref_isr_generada, v_id_tipo_movimiento);
      if not v_is_ok then goto facturas_exit; end if;
    END IF;

    IF v_mov.genera_factura_infotep = 'S' AND
      NOT v_is_infotep_pagada AND
      v_periodo_factura >= p.infotep_periodo_inicio
    THEN
      v_is_ok := genera_liquidacion_infotep(v_periodo_factura, v_id_registro_patronal,
          p_id_movimiento , v_mov, v_id_ref_infotep_generada);
      if not v_is_ok then goto facturas_exit; end if;
    END IF;

  <<facturas_exit>>

    return v_is_ok;

  EXCEPTION WHEN OTHERS THEN Errorpkg.HandleAll(FALSE); RAISE;
  END do_facturas;

  -- *************************************************************************************************

  --dp220610
  function is_recargo_empleador (
    p_id_referencia_isr         				SFC_liquidacion_isr_t.id_referencia_isr%TYPE
  )return boolean IS

    v_return                 					boolean;
    v_paga_recargos_dgii           				sre_empleadores_t.paga_recargos_dgii%type;

    CURSOR c_rec (
      p_id_movimiento                 			SRE_MOVIMIENTO_T.id_movimiento%TYPE
    )IS
      SELECT NVL (PAGA_RECARGOS_DGII, 'S')
        FROM sfc_liquidacion_isr_t a,
           sre_empleadores_t b
       WHERE a.id_referencia_isr = p_id_referencia_isr
         AND a.id_registro_patronal = b.id_registro_patronal;

  BEGIN

    open c_rec (p_id_referencia_isr);
    fetch c_rec into v_paga_recargos_dgii;
    if c_rec%notfound then
      v_paga_recargos_dgii := 'N';
    end if;
    close c_rec;

    if v_paga_recargos_dgii = 'S' then
      v_return := true;
    else
      v_return := false;
    end if;

    return v_return;

  EXCEPTION WHEN OTHERS THEN Errorpkg.HandleAll(FALSE); RAISE;
  END is_recargo_empleador;
  --end dp220610


  function do_recargos return boolean IS

  	v_is_ok                 					boolean;
  	v_return                					SEG_ERROR_T.id_error%TYPE;
  	v_error_seq                         		number;

  BEGIN

    IF v_mov.genera_recargo_ss = 'S' AND
    --  NOT v_is_ss_pagada AND --dp260905
      ((NOT v_is_ss_pagada) OR ( v_tipo_nomina = 'D')) AND --dp260905
      v_id_ref_ss_generadas.COUNT > 0
    THEN
      v_is_ok := recargos_int_ss(v_id_ref_ss_generadas);
      if not v_is_ok then goto recargos_exit; end if;
    END IF;

    --dp201009
    --IF v_mov.genera_recargo_isr = 'S' AND
    --  NOT v_is_isr_pagada AND
    --  v_periodo_factura >= P.periodo_inicio_isr AND
    --  v_id_ref_isr_generada IS NOT NULL
    IF (v_mov.genera_recargo_isr = 'S' AND
        is_recargo_empleador (v_id_ref_isr_generada) AND --dp220610
      v_periodo_factura >= P.periodo_inicio_isr AND
      v_id_ref_isr_generada IS NOT NULL)
      AND
       ((v_mov.id_tipo_movimiento = 'RT' AND
       v_is_isr_pagada AND
       v_periodo_factura >= p.periodo_inicio_rectificativa)
       OR
      (NOT v_is_isr_pagada))
    --end dp201009
    THEN
      v_is_ok := Sfc_Rec_Int_Retro_Liq_Isr_F( v_return, v_error_seq, v_id_ref_isr_generada);
      if not v_is_ok then goto recargos_exit; end if;
    END IF;

    -- Infotep no tiene recargos

  <<recargos_exit>>

    return v_is_ok;

  EXCEPTION WHEN OTHERS THEN Errorpkg.HandleAll(FALSE); RAISE;
  END do_recargos;

  -- *************************************************************************************************

BEGIN

	v_periodo_factura := p_periodo_factura;
	v_id_registro_patronal := p_id_registro_patronal;
	v_id_tipo_movimiento := p_id_tipo_movimiento;

	v_is_ok := get_mov_values(p_periodo_factura, p_id_registro_patronal, p_id_nomina,
	p_id_tipo_movimiento, v_mov, v_tipo_nomina, v_is_ss_pagada, v_is_isr_pagada, 
	v_is_infotep_pagada); 
	if not v_is_ok then goto opera_exit; end if;

  	v_is_ok := do_cancela;
  	if not v_is_ok then goto opera_exit; end if;
  	v_is_ok := do_facturas;
  	if not v_is_ok then goto opera_exit; end if;
  	v_is_ok := do_recargos;
  	if not v_is_ok then goto opera_exit; end if;

<<opera_exit>>

  return v_is_ok;

EXCEPTION WHEN OTHERS THEN Errorpkg.HandleAll(FALSE); RAISE;
END do_process;
--
-- *****************************************************************************************************
--
--                                     Main Procedure (Anonymous block)
--
-- *****************************************************************************************************

BEGIN

declare
    v_is_ok                 					boolean;
BEGIN

  g_mensage := 
    '|P:'  || TO_CHAR( pp_periodo_factura) || '|RP:' || TO_CHAR( pp_id_registro_patronal) || 
  	'|N:'  || TO_CHAR( pp_id_nomina) 	   || '|';

  g_module := Srp_Pkg.get_module(ID_PROCESO);
  g_return := '000';
  Srp_Pkg.bitacora(g_id_bitacora, 'INI', ID_PROCESO);
  P := Parm(pp_periodo_factura);
  p.set_infotep;
  SELECT SYSDATE INTO g_sysdate FROM dual;
  g_periodo_ini_ley_amnistia := Parm.get_parm_number(srp_const.PARM_PERIODO_INI_LEY_AMNISTIA);

  v_is_ok := do_process (pp_periodo_factura, pp_id_registro_patronal, pp_id_nomina, 
  	'AM', 0, pp_usuario);

  if not v_is_ok then g_return := '216'; raise e_Houston; end if;

  COMMIT WORK;
  Srp_Pkg.bitacora(g_id_bitacora, 'FIN', ID_PROCESO, g_mensage, 'O', g_return);
  RETURN TRUE;

EXCEPTION WHEN OTHERS THEN Errorpkg.HandleAll(FALSE); RAISE;
END; -- Anonymous block

EXCEPTION
    WHEN e_Houston THEN
    Srp_Pkg.bitacora(g_id_bitacora, 'FIN', ID_PROCESO, g_mensage, 'E', g_return);
    Srp_Pkg.notifica_ejecucion(g_id_bitacora);
    pp_return := g_return;
    RETURN FALSE;
    WHEN OTHERS THEN
    ROLLBACK;
    Errorpkg.HandleAll(TRUE);
    Errorpkg.StoreStacks(g_module, g_ErrorSeq, TRUE);
    Errorpkg.PrintStacks(g_module, g_ErrorSeq);
    g_return := '650';
    Sfc_Pkg.clean_up_mov(pp_periodo_factura, pp_id_registro_patronal); --dp130505
    Srp_Pkg.bitacora(g_id_bitacora, 'FIN', ID_PROCESO, g_mensage, 'E', g_return, g_ErrorSeq);
    Srp_Pkg.notifica_ejecucion(g_id_bitacora);
    pp_return := g_return;
    RETURN FALSE;

END Sfc_genera_fac_liq_ordinaria_f;