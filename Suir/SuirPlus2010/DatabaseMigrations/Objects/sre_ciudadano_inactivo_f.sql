CREATE OR REPLACE FUNCTION SUIRPLUS.SRE_CIUDADANO_INACTIVO_F
(
 p_id_nss suirplus.sre_ciudadanos_t.id_nss%type,
 p_id_periodo number DEFAULT NULL
) RETURN CHAR IS
  p_result char(1);
BEGIN
  SELECT CASE 
           -- Cancelado
           WHEN c.tipo_causa = 'C' THEN
             CASE 
               -- Si no considera la fecha de cancelacion, descartar
               WHEN p_id_periodo IS NULL THEN
                 'N'
               -- Por Fallecimiento antes del periodo, descartar
               WHEN id_causa_inhabilidad = 2 AND TO_NUMBER(TO_CHAR(NVL(c.fecha_fallecimiento, c.fecha_cancelacion_tss),'YYYYMM')) < p_id_periodo THEN
                 'N'
               -- Exceptuando Fallecimiento y antes del periodo, descartar
               WHEN NVL(id_causa_inhabilidad, 0) <> 2 AND TO_NUMBER(TO_CHAR(NVL(c.fecha_cancelacion_tss, c.ult_fecha_act),'YYYYMM')) < p_id_periodo THEN
                 'N'
               ELSE -- Se debe aceptar, estaba vivo para la fecha del evento
                 'S'
             END
           ELSE --No tiene estatus de cancelado, se debe aceptar
             'S'
         END      
    INTO P_Result
    FROM suirplus.sre_ciudadanos_t c
   WHERE c.id_nss = p_id_nss;
   
  RETURN (p_result);   
EXCEPTION 
  WHEN OTHERS THEN  
    p_result := 'N';
  RETURN (p_result);
END SRE_CIUDADANO_INACTIVO_F;