CREATE OR REPLACE TRIGGER "SFS_ELEGIBLES_UPDATE_TRG" BEFORE UPDATE ON SISALRIL_SUIR.SFS_ELEGIBLES_T FOR EACH ROW 
DECLARE
   v_username varchar2(50);
BEGIN

 SELECT user INTO v_username
 FROM dual;


  if v_username = 'SISALRIL_SUIR' and ((:old.ID_REGISTRO_PATRONAL <> :new.ID_REGISTRO_PATRONAL) or
    (:old.ID_NSS <> :new.ID_NSS) or
    (:old.SECUENCIA <> :new.SECUENCIA) or
    (:old.TIPO_SUBSIDIO <> :new.TIPO_SUBSIDIO) or
    (:old.PERIODO_INICIO <> :new.PERIODO_INICIO) or
    (:old.PERIODO_FIN <> :new.PERIODO_FIN) or
    (:old.CATEGORIA_SALARIO <> :new.CATEGORIA_SALARIO) or
    (:old.ID_ERROR <> :new.ID_ERROR) or
    (:old.FECHA_ERROR <> :new.FECHA_ERROR) or
    (:old.ULT_FECHA_ACT <> :new.ULT_FECHA_ACT) or
    (:old.FECHA_ENVIO <> :new.FECHA_ENVIO) or
    (:old.FECHA_RESPUESTA <> :new.FECHA_RESPUESTA) or
    (:old.NRO_LOTE <> :new.NRO_LOTE) or
    (:old.FECHA_REGISTRO <> :new.FECHA_REGISTRO) or
    (:old.TIPO_SOLICITUD <> :new.TIPO_SOLICITUD) or
    (:old.ID_NOMINA <> :new.ID_NOMINA) or
    (:old.PADECIMIENTO <> :new.PADECIMIENTO) or
    (:old.NRO_SOLICITUD <> :new.NRO_SOLICITUD) or
    (:old.ID_SUB_MATERNIDAD <> :new.ID_SUB_MATERNIDAD) or
    (:old.ID_ELEGIBLES <> :new.ID_ELEGIBLES) or
    (:old.CUOTA <> :new.CUOTA)) then
    
     RAISE_APPLICATION_ERROR(-20010,'SOLO LES ESTA PERMITIDO MODIFICAR EL CAMPO ESTATUS');
    
  end if;

  
END;
