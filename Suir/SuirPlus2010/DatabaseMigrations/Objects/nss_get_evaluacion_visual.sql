CREATE OR REPLACE PROCEDURE SUIRPLUS.NSS_GET_EVALUACION_VISUAL
(
 P_ID_SOLICITUD in VARCHAR2,
 P_ID_TIPO in VARCHAR2, 
 P_PAGENUM  in NUMBER,
 P_PAGESIZE in NUMBER,
 P_CURSOR out SYS_REFCURSOR,
 P_RESULTADO out VARCHAR2
) IS
  vDesde integer := (p_pagesize * (p_pagenum - 1)) + 1;
  vhasta integer := p_pagesize * p_pagenum;
BEGIN
  OPEN P_CURSOR FOR
    with pages as
     (Select rownum num, y.*
      from (SELECT S.ID_SOLICITUD AS SOLICITUD,
                   D.ID_REGISTRO AS REGISTRO,
                   S.FECHA_SOLICITUD AS FECHASOLICITUD,
                   TS.DESCRIPCION AS TIPOSOLICITUD,
                   ER.ERROR_DES AS MOTIVORECHAZO,
                   TD.DESCRIPCION AS TIPODOC,
                   D.ID_NACIONALIDAD,
                   NA.NACIONALIDAD_DES,
                   D.NO_DOCUMENTO_SOL,
                   D.NOMBRES||' '||D.PRIMER_APELLIDO||CASE WHEN D.SEGUNDO_APELLIDO IS NOT NULL THEN ' '||D.SEGUNDO_APELLIDO ELSE '' END NOMBRES,
                   D.ID_PARENTESCO,
                   PA.PARENTESCO_DESC,
                   D.ID_NSS_TITULAR,
                   CI.NO_DOCUMENTO
            FROM suirplus.NSS_SOLICITUDES_T S
            JOIN suirplus.NSS_DET_SOLICITUDES_T D
              ON D.ID_SOLICITUD = S.ID_SOLICITUD
             AND D.ID_ESTATUS = 4 
            JOIN suirplus.NSS_EVALUACION_VISUAL_T EV
              ON EV.ID_REGISTRO = D.ID_REGISTRO
            JOIN suirplus.NSS_TIPO_SOLICITUDES_T TS
              ON TS.ID_TIPO = S.ID_TIPO
            LEFT JOIN suirplus.SRE_TIPO_DOCUMENTOS_T TD
              ON TD.ID_TIPO_DOCUMENTO = D.ID_TIPO_DOCUMENTO
            LEFT JOIN suirplus.SEG_ERROR_T ER
              ON ER.ID_ERROR = D.ID_ERROR
            LEFT JOIN suirplus.ARS_PARENTESCOS_T PA
              ON PA.ID_PARENTESCO = D.ID_PARENTESCO
            LEFT JOIN suirplus.SRE_CIUDADANOS_T CI
              ON CI.ID_NSS = D.ID_NSS              
            LEFT JOIN suirplus.SRE_NACIONALIDAD_T NA
              ON NA.ID_NACIONALIDAD = D.ID_NACIONALIDAD
           WHERE NVL(S.ID_SOLICITUD,-1) = CASE WHEN P_ID_SOLICITUD IS NULL THEN NVL(S.ID_SOLICITUD,-1) ELSE TO_NUMBER(P_ID_SOLICITUD) END
             AND NVL(S.ID_TIPO,-1) = CASE WHEN P_ID_TIPO IS NULL THEN NVL(S.ID_TIPO,-1) ELSE TO_NUMBER(P_ID_TIPO) END
           ORDER BY S.ID_SOLICITUD) y
        )
    Select y.recordcount, pages.*
      from pages, (Select max(num) recordcount from pages) y
     where num between vDesde and vhasta
     order by num;

   p_resultado := 'OK';
EXCEPTION
  WHEN OTHERS THEN
    p_resultado := SQLERRM;
END;
