CREATE OR REPLACE PROCEDURE SUIRPLUS.SFS_SOLICITUDES_EXCEDEN_TIEMPO AS
	p_resultNumber varchar2(200);
	v_bd_error     varchar2(1000);
BEGIN
	/*Buscamos las Solicitudes de maternidad consideradas vencidas, Porque no han generado licensias en 9 meses*/
		UPDATE SUIRPLUS.SUB_MATERNIDAD_T MA
		SET MA.ESTATUS = 'IN'
		WHERE MA.NRO_SOLICITUD IN(SELECT SOL.NRO_SOLICITUD
								  FROM SUIRPLUS.SUB_SOLICITUD_T SOL
								  WHERE SOL.TIPO_SUBSIDIO ='M' 
								  AND NOT EXISTS(SELECT * FROM SUIRPLUS.SUB_SFS_MATERNIDAD_T T 
								  WHERE T.NRO_SOLICITUD = SOL.NRO_SOLICITUD) 
								  AND ABS(MONTHS_BETWEEN(SOL.FECHA_REGISTRO,SYSDATE)) >= 9);


	/*Buscamos las Solicitudes de enfermedad comun consideradas vencidas, Porque no han generado licensias en 26 semanas, equivalentes a 6.5 meses*/
	  UPDATE SUIRPLUS.SUB_ENFERMEDAD_COMUN_T EF
	  SET EF.ESTATUS = 'IN'
	  WHERE EF.NRO_SOLICITUD IN(SELECT SOL.NRO_SOLICITUD
						      FROM SUIRPLUS.SUB_SOLICITUD_T SOL
							  WHERE SOL.TIPO_SUBSIDIO ='E' 
							  AND NOT EXISTS(SELECT * FROM SUIRPLUS.SUB_SFS_ENF_COMUN_T T 
							  WHERE T.NRO_SOLICITUD = SOL.NRO_SOLICITUD) 
							  AND ABS(MONTHS_BETWEEN(SOL.FECHA_REGISTRO,SYSDATE)) >= 6.5);
	
	COMMIT;
	p_resultNumber:=0;
	
EXCEPTION
		When Others Then
			 v_bd_error  := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
								SQLERRM,
								1,
								255));
								p_resultNumber := Seg_Retornar_Cadena_Error(-1, v_bd_error, SQLCODE);
	  ROLLBACK;
END;