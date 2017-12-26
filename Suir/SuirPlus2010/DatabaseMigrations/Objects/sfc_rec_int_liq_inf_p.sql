CREATE OR REPLACE PROCEDURE SUIRPLUS.SFC_REC_INT_LIQ_INF_P(
  p_return out                    suirplus.seg_error_t.id_error%type,
  p_error_seq out                 number,
  p_periodo_procesar              suirplus.sfc_liquidacion_infotep_t.periodo_liquidacion%type,
  p_is_bitacora                   boolean default true,
  p_is_commit                     boolean default true
) is
  v_id_bitacora suirplus.sfc_bitacora_t.id_bitacora%type;
  v_ID_PROCESO 	CONSTANT suirplus.sfc_procesos_t.id_proceso%type := '54';
  v_MODULE     	CONSTANT suirplus.errors.module%type := upper('SFC_REC_INT_LIQ_INF_P');
  e_Houston     exception;
  v_ErrorSeq 	number;
  v_error_mesg	suirplus.errors.error_mesg%type;
Begin
 	If p_is_bitacora then
    suirplus.srp_pkg.bitacora(v_id_bitacora, 'INI', v_ID_PROCESO);
  End if;

  UPDATE suirplus.sfc_liquidacion_infotep_t
  SET status = 'VE'
  WHERE status = 'VI';
--  and periodo_liquidacion = p_periodo_procesar;

 	If p_is_bitacora then
    suirplus.srp_pkg.bitacora(v_id_bitacora, 'FIN', v_ID_PROCESO, 'OK', 'O');
  End if;

  If p_is_commit then
    commit work;
  End if;
  p_return := 0;
EXCEPTION
  WHEN e_Houston then
	  if p_is_bitacora then      
      suirplus.srp_pkg.bitacora(v_id_bitacora, 'FIN', v_ID_PROCESO, 'E', p_return, p_Error_Seq);
	    suirplus.srp_pkg.notifica_ejecucion(v_id_bitacora);
    end if;
  WHEN OTHERS THEN
 	  rollback;
    
    suirplus.ErrorPkg.HandleAll(TRUE);
    suirplus.ErrorPkg.StoreStacks(v_MODULE, v_ErrorSeq, TRUE);
    suirplus.ErrorPkg.PrintStacks(v_MODULE, v_ErrorSeq);
  	
    if p_is_bitacora then
      select error_mesg 
      into v_error_mesg 
      from suirplus.errors 
      where module = v_MODULE 
        and seq_number = v_ErrorSeq;
    
      p_return := '650';
  	  suirplus.srp_pkg.bitacora(v_id_bitacora, 'FIN', v_ID_PROCESO, v_error_mesg, 'E', p_return, v_ErrorSeq);
  		suirplus.srp_pkg.notifica_ejecucion(v_id_bitacora);
    end if;
END SFC_REC_INT_LIQ_INF_P;