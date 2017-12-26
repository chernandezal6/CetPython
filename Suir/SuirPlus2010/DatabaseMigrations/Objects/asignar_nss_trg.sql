CREATE OR REPLACE TRIGGER SUIRPLUS.ASIGNAR_NSS_TRG BEFORE UPDATE OR INSERT ON SUIRPLUS.SRE_CIUDADANOS_T FOR EACH ROW
BEGIN
  -- asignacion del NSS
  if (inserting) then
    DECLARE
      v_nss    VARCHAR2(8);
      v_digito INTEGER;
      function tiene_letras(p_numero in varchar2) return boolean is
        res boolean;
        let number;
      begin
        res := false;
        for let in 1 .. length(p_numero) loop
          if substr(p_numero, let, 1) not in
             ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9') then
            res := true;
          end if;
        end loop;
        return res;
      end;
    BEGIN
      IF :NEW.tipo_documento IN ('N', 'P', 'C', 'U', 'E','T') THEN
        IF :NEW.tipo_documento IN ('C', 'N', 'U', 'E') THEN
          SELECT trim(TO_CHAR(sre_nss_ciudadanos_seq.NEXTVAL, '00000000'))
          INTO v_nss
          FROM dual;
        ELSIF :NEW.tipo_documento IN ('P') THEN
          SELECT trim(TO_CHAR(sre_nss_extranjeros_seq.NEXTVAL, '00000000'))
          INTO v_nss
          FROM dual;
        ELSIF :NEW.tipo_documento IN ('T') THEN
          SELECT trim(TO_CHAR(sre_nss_titular_seq.NEXTVAL, '00000000'))
          INTO v_nss
          FROM dual;          
        END IF;   

        SELECT MOD(SUBSTR(v_nss, 1, 1) * 4 + SUBSTR(v_nss, 2, 1) * 5 +
                   SUBSTR(v_nss, 3, 1) * 2 + SUBSTR(v_nss, 4, 1) * 3 +
                   SUBSTR(v_nss, 5, 1) * 7 + SUBSTR(v_nss, 6, 1) * 9 +
                   SUBSTR(v_nss, 7, 1) * 2 + SUBSTR(v_nss, 8, 1) * 6,
                   9)
          INTO v_digito
          FROM dual;

        :NEW.id_nss := v_nss || v_digito;
      END IF;
    END;
  end if;

  --asignacion de la secuencia sipen
  declare
    v_secuencia number(9) := 0;
  begin
    if inserting then
      :new.fecha_registro := sysdate;
      select suirplus.sre_ciudadanos_sipen_seq.nextval
        into v_secuencia
        from dual;
      :new.secuencia_sipen := v_secuencia;
    elsif updating then
      :new.fecha_registro := :old.fecha_registro;
    end if;
  end;

  -- ultima fecha de actualizacion
  :new.ult_fecha_act := sysdate;

  -- quitar el character 0
  :new.nombres              := replace(:new.nombres, chr(0), '');
  :new.primer_apellido      := replace(:new.primer_apellido, chr(0), '');
  :new.segundo_apellido     := replace(:new.segundo_apellido, chr(0), '');
  :new.estado_civil         := replace(:new.estado_civil, chr(0), '');
  :new.no_documento         := UPPER(replace(:new.no_documento, chr(0), ''));
  :new.tipo_documento       := UPPER(replace(:new.tipo_documento, chr(0), ''));
  :new.sexo                 := replace(:new.sexo, chr(0), '');
  :new.id_provincia         := replace(:new.id_provincia, chr(0), '');
  :new.id_tipo_sangre       := replace(:new.id_tipo_sangre, chr(0), '');
  :new.id_causa_inhabilidad := replace(:new.id_causa_inhabilidad, chr(0), '');
  :new.id_nacionalidad      := replace(:new.id_nacionalidad, chr(0), '');
  :new.nombre_padre         := replace(:new.nombre_padre, chr(0), '');
  :new.nombre_madre         := replace(:new.nombre_madre, chr(0), '');
  :new.municipio_acta       := replace(:new.municipio_acta, chr(0), '');
  :new.ano_acta             := replace(:new.ano_acta, chr(0), '');
  :new.numero_acta          := replace(:new.numero_acta, chr(0), '');
  :new.folio_acta           := replace(:new.folio_acta, chr(0), '');
  :new.libro_acta           := replace(:new.libro_acta, chr(0), '');
  :new.oficialia_acta       := replace(:new.oficialia_acta, chr(0), '');
  :new.cedula_anterior      := replace(:new.cedula_anterior, chr(0), '');
  :new.status               := replace(:new.status, chr(0), '');
  :new.tipo_causa           := replace(:new.tipo_causa, chr(0), '');
  :new.cotizacion           := replace(:new.cotizacion, chr(0), '');

  -- hacer backup del registro ANTES
  if (updating) then
    delete from suirplus.sre_ciudadanos_ult_t where id_nss = :old.id_nss;

    insert into suirplus.sre_ciudadanos_ult_t
      (id_nss,
       nombres,
       primer_apellido,
       segundo_apellido,
       estado_civil,
       fecha_nacimiento,
       no_documento,
       tipo_documento,
       sexo,
       id_provincia,
       id_tipo_sangre,
       id_causa_inhabilidad,
       id_nacionalidad,
       nombre_padre,
       nombre_madre,
       fecha_registro,
       municipio_acta,
       ano_acta,
       numero_acta,
       folio_acta,
       libro_acta,
       oficialia_acta,
       cedula_anterior,
       status,
       ult_fecha_act,
       ult_usuario_act,
       tipo_causa,
       fecha_expedicion,
       cotizacion)
    values
      (:old.id_nss,
       :old.nombres,
       :old.primer_apellido,
       :old.segundo_apellido,
       :old.estado_civil,
       :old.fecha_nacimiento,
       :old.no_documento,
       :old.tipo_documento,
       :old.sexo,
       :old.id_provincia,
       :old.id_tipo_sangre,
       :old.id_causa_inhabilidad,
       :old.id_nacionalidad,
       :old.nombre_padre,
       :old.nombre_madre,
       :old.fecha_registro,
       :old.municipio_acta,
       :old.ano_acta,
       :old.numero_acta,
       :old.folio_acta,
       :old.libro_acta,
       :old.oficialia_acta,
       :old.cedula_anterior,
       :old.status,
       :old.ult_fecha_act,
       :old.ult_usuario_act,
       :old.tipo_causa,
       :old.fecha_expedicion,
       :old.cotizacion);
    
    -- Guardar los cambios en el tipo de documento o numero de documento de un ciudadano para compartir con UNIPAGO
    IF (:OLD.tipo_documento IN ('C','U')) AND 
       (:NEW.tipo_documento IN ('C','U')) AND
       (TRIM(:OLD.no_documento) IS NOT NULL) AND 
       (TRIM(:NEW.no_documento) IS NOT NULL) AND 
       ( 
         (:OLD.no_documento != :NEW.no_documento) OR (:OLD.tipo_documento != :NEW.tipo_documento)
       ) THEN
      INSERT INTO SUIRPLUS.SRE_HISTORICO_DOCUMENTOS_T
      (
        ID,
        ID_NSS,
        TIPO_DOCUMENTO,
        NO_DOCUMENTO,
        ULT_FECHA_ACT
      )
      VALUES
      (
       SUIRPLUS.SRE_HISTORICO_DOCUMENTOS_SEQ.NEXTVAL,
       :OLD.ID_NSS,
       :OLD.TIPO_DOCUMENTO,
       :OLD.NO_DOCUMENTO,
       SYSDATE
      );      
    END IF;     
  end if;
END;