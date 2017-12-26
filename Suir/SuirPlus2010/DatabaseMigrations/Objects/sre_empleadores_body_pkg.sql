CREATE OR REPLACE PACKAGE BODY suirplus.Sre_Empleadores_Pkg IS
  -- *****************************************************************************************************
  -- program:   sre_empleadores_pkg
  -- descripcion: Edita o actualiza los Empleadores.
  --
  -- modification history
  -- -----------------------------------------------------------------------------------------------------
  -- date     by          remark
  -- -----------------------------------------------------------------------------------------------------
  -- 11/11/2004 Elinor Rodriguez  creation
  -- *****************************************************************************************************
  PROCEDURE empleadores_editar(p_id_registro_patronal   SRE_EMPLEADORES_T.id_registro_patronal%TYPE,
                               p_id_motivo_no_impresion SRE_EMPLEADORES_T.id_motivo_no_impresion%TYPE,
                               p_id_sector_economico    SRE_EMPLEADORES_T.id_sector_economico%TYPE,
                               p_id_oficio              SRE_EMPLEADORES_T.id_oficio%TYPE,
                               p_id_actividad_eco       SRE_EMPLEADORES_T.id_actividad_eco%TYPE,
                               p_id_riesgo              SRE_EMPLEADORES_T.id_riesgo%TYPE,
                               p_id_municipio           SRE_EMPLEADORES_T.id_municipio%TYPE,
                               p_rnc_o_cedula           SRE_EMPLEADORES_T.rnc_o_cedula%TYPE,
                               p_razon_social           SRE_EMPLEADORES_T.razon_social%TYPE,
                               p_nombre_comercial       SRE_EMPLEADORES_T.nombre_comercial%TYPE,
                               p_status                 SRE_EMPLEADORES_T.status%TYPE,
                               p_calle                  SRE_EMPLEADORES_T.calle%TYPE,
                               p_numero                 SRE_EMPLEADORES_T.numero%TYPE,
                               p_edificio               SRE_EMPLEADORES_T.edificio%TYPE,
                               p_piso                   SRE_EMPLEADORES_T.piso%TYPE,
                               p_apartamento            SRE_EMPLEADORES_T.apartamento%TYPE,
                               p_sector                 SRE_EMPLEADORES_T.sector%TYPE,
                               p_telefono_1             SRE_EMPLEADORES_T.telefono_1%TYPE,
                               p_ext_1                  SRE_EMPLEADORES_T.ext_1%TYPE,
                               p_telefono_2             SRE_EMPLEADORES_T.telefono_2%TYPE,
                               p_ext_2                  SRE_EMPLEADORES_T.ext_2%TYPE,
                               p_fax                    SRE_EMPLEADORES_T.fax%TYPE,
                               p_email                  SRE_EMPLEADORES_T.email%TYPE,
                               p_tipo_empresa           SRE_EMPLEADORES_T.tipo_empresa%TYPE,
                               p_descuento_penalidad    SRE_EMPLEADORES_T.descuento_penalidad%TYPE,
                               p_ruta_distribucion      SRE_EMPLEADORES_T.ruta_distribucion%TYPE,
                               p_no_paga_idss           SRE_EMPLEADORES_T.no_paga_idss%TYPE,
                               p_completo_encuesta      SRE_EMPLEADORES_T.completo_encuesta%TYPE,
                               p_ult_usuario_act        SRE_EMPLEADORES_T.ult_usuario_act%TYPE,
                               p_resultnumber           IN OUT VARCHAR2)

   IS
    v_longitud VARCHAR(500);

  BEGIN

    -- compara la longitud de los valores enviados con la de los campos.
    IF (LENGTH(p_razon_social)) >
       (Seg_Get_Largo_Columna('SRE_EMPLEADORES_T', 'RAZON_SOCIAL')) THEN
      v_longitud := 'Razon Social';
      RAISE e_excedelogintud;
    END IF;

    IF (LENGTH(p_nombre_comercial)) >
       (Seg_Get_Largo_Columna('SRE_EMPLEADORES_T', 'NOMBRE_COMERCIAL')) THEN
      v_longitud := 'Nombre Comercial';
      RAISE e_excedelogintud;
    END IF;
    IF (LENGTH(p_calle)) >
       (Seg_Get_Largo_Columna('SRE_EMPLEADORES_T', 'CALLE')) THEN
      v_longitud := 'Calle';
      RAISE e_excedelogintud;
    END IF;
    IF (LENGTH(p_numero)) >
       (Seg_Get_Largo_Columna('SRE_EMPLEADORES_T', 'NUMERO')) THEN
      v_longitud := 'Numero';
      RAISE e_excedelogintud;
    END IF;
    IF (LENGTH(p_edificio)) >
       (Seg_Get_Largo_Columna('SRE_EMPLEADORES_T', 'EDIFICIO')) THEN
      v_longitud := 'Edificio';
      RAISE e_excedelogintud;
    END IF;
    IF (LENGTH(p_piso)) >
       (Seg_Get_Largo_Columna('SRE_EMPLEADORES_T', 'PISO')) THEN
      v_longitud := 'Piso';
      RAISE e_excedelogintud;
    END IF;
    IF (LENGTH(p_apartamento)) >
       (Seg_Get_Largo_Columna('SRE_EMPLEADORES_T', 'APARTAMENTO')) THEN
      v_longitud := 'Apartamento';
      RAISE e_excedelogintud;
    END IF;
    IF (LENGTH(p_sector)) >
       (Seg_Get_Largo_Columna('SRE_EMPLEADORES_T', 'SECTOR')) THEN
      v_longitud := 'Sector';
      RAISE e_excedelogintud;
    END IF;
    IF (LENGTH(p_email)) >
       (Seg_Get_Largo_Columna('SRE_EMPLEADORES_T', 'EMAIL')) THEN
      v_longitud := 'Email';
      RAISE e_excedelogintud;
    END IF;

    IF (LENGTH(p_descuento_penalidad)) >
       (Seg_Get_Largo_Columna('SRE_EMPLEADORES_T', 'DESCUENTO_PENALIDAD')) THEN
      v_longitud := 'Descuento Penalidad';
      RAISE e_excedelogintud;
    END IF;
    IF (LENGTH(p_ruta_distribucion)) >
       (Seg_Get_Largo_Columna('SRE_EMPLEADORES_T', 'RUTA_DISTRIBUCION')) THEN
      v_longitud := 'Ruta Distribucion';
      RAISE e_excedelogintud;
    END IF;

    -- realiza validaciones.
    IF NOT
        Sre_Empleadores_Pkg.Existeregistropatronal(p_id_registro_patronal) THEN
      RAISE e_invalidregistropatronal;
    End if;
    IF p_ult_usuario_act IS NOT NULL then
      if not (sre_empleadores_pkg.isexisteusuario(p_ult_usuario_act)) THEN
        RAISE e_invaliduser;
      end if;
    else
      RAISE e_invaliduser;
    END IF;

    -- realiza la actualizacion o edicion del empleador.
    UPDATE SRE_EMPLEADORES_T tr
       SET tr.id_motivo_no_impresion = p_id_motivo_no_impresion,
           tr.id_sector_economico    = p_id_sector_economico,
           tr.id_oficio              = p_id_oficio,
           tr.id_actividad_eco       = p_id_actividad_eco,
           tr.id_riesgo              = p_id_riesgo,
           tr.id_municipio           = p_id_municipio,
           tr.rnc_o_cedula           = p_rnc_o_cedula,
           tr.razon_social           = UPPER(p_razon_social),
           tr.nombre_comercial       = UPPER(p_nombre_comercial),
           tr.status                 = UPPER(p_status),
           tr.calle                  = UPPER(p_calle),
           tr.numero                 = p_numero,
           tr.edificio               = UPPER(p_edificio),
           tr.piso                   = p_piso,
           tr.apartamento            = UPPER(p_apartamento),
           tr.sector                 = UPPER(p_sector),
           tr.telefono_1             = p_telefono_1,
           tr.ext_1                  = p_ext_1,
           tr.telefono_2             = p_telefono_2,
           tr.ext_2                  = p_ext_2,
           tr.fax                    = p_fax,
           tr.email                  = UPPER(p_email),
           tr.tipo_empresa           = UPPER(p_tipo_empresa),
           tr.descuento_penalidad    = UPPER(p_descuento_penalidad),
           tr.ruta_distribucion      = UPPER(p_ruta_distribucion),
           tr.no_paga_idss           = UPPER(p_no_paga_idss),
           tr.ult_usuario_act        = UPPER(p_ult_usuario_act),
           tr.completo_encuesta      = UPPER(p_completo_encuesta),
           tr.ult_fecha_act          = SYSDATE
     WHERE tr.id_registro_patronal = p_id_registro_patronal
        or tr.rnc_o_cedula = p_rnc_o_cedula;

    p_resultnumber := 0; -- empleador modificado.
    COMMIT;
    RETURN;

  EXCEPTION
    WHEN e_excedelogintud THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(15, NULL, NULL) ||
                        v_longitud;
      RETURN;
    WHEN e_invalidmotivoimpresion THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(10, NULL, NULL);
      RETURN;
    WHEN e_invalidsectoreconomico THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(10, NULL, NULL);
      RETURN;
    WHEN e_invalidoficios THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(10, NULL, NULL);
      RETURN;
    WHEN e_invalidregistropatronal THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(10, NULL, NULL);
      RETURN;
    WHEN e_invalidactividadeconomica THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(10, NULL, NULL);
      RETURN;
    WHEN e_invalidriesgo THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(10, NULL, NULL);
      RETURN;
    WHEN e_invalidmunicipio THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(10, NULL, NULL);
      RETURN;
    WHEN e_invaliduser THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(1, NULL, NULL);
      RETURN;
    WHEN OTHERS THEN
      v_bderror      := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultnumber := Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
      RETURN;
  END;
  --*******************************************************************************
  -- Crea los Empleadores.
  --*******************************************************************************
  PROCEDURE empleadores_crear(p_id_sector_economico SRE_EMPLEADORES_T.id_sector_economico%TYPE,
                              p_id_municipio        SRE_EMPLEADORES_T.id_municipio%TYPE,
                              p_rnc_o_cedula        SRE_EMPLEADORES_T.rnc_o_cedula%TYPE,
                              p_razon_social        SRE_EMPLEADORES_T.razon_social%TYPE,
                              p_nombre_comercial    SRE_EMPLEADORES_T.nombre_comercial%TYPE,
                              p_calle               SRE_EMPLEADORES_T.calle%TYPE,
                              p_numero              SRE_EMPLEADORES_T.numero%TYPE,
                              p_edificio            SRE_EMPLEADORES_T.edificio%TYPE,
                              p_piso                SRE_EMPLEADORES_T.piso%TYPE,
                              p_apartamento         SRE_EMPLEADORES_T.apartamento%TYPE,
                              p_sector              SRE_EMPLEADORES_T.sector%TYPE,
                              p_telefono_1          SRE_EMPLEADORES_T.telefono_1%TYPE,
                              p_ext_1               SRE_EMPLEADORES_T.ext_1%TYPE,
                              p_telefono_2          SRE_EMPLEADORES_T.telefono_2%TYPE,
                              p_ext_2               SRE_EMPLEADORES_T.ext_2%TYPE,
                              p_fax                 SRE_EMPLEADORES_T.fax%TYPE,
                              p_email               SRE_EMPLEADORES_T.email%TYPE,
                              p_tipo_empresa        SRE_EMPLEADORES_T.tipo_empresa%TYPE,
                              p_sector_salarial     SRE_EMPLEADORES_T.Cod_Sector%type,
                              p_documentos_registro SRE_EMPLEADORES_T.Documentos_Registro%TYPE,
                              p_Id_Actividad        SRE_EMPLEADORES_T.Id_Actividad%TYPE,
                              p_Id_Zona_Franca      SRE_EMPLEADORES_T.Id_Zona_Franca%TYPE,
                              p_Es_Zona_Franca      SRE_EMPLEADORES_T.Es_Zona_Franca%TYPE,
                              p_tipo_zona_franca    SRE_EMPLEADORES_T.TIPO_ZONA_FRANCA%TYPE,
                              p_ult_usuario_act     SRE_EMPLEADORES_T.ult_usuario_act%TYPE,
                              p_resultnumber        IN OUT VARCHAR2) IS

    v_registropatronal         NUMBER;
    v_longitud                 VARCHAR(500);
    v_rnc_o_cedula             VARCHAR(20);
    v_adm_local                VARCHAR(3);
    valor_local                VARCHAR(3);
    v_fecha_inicio_actividades VARCHAR(15);
    v_fecha_nac_const          VARCHAR(15);
    fechainicioactividades     VARCHAR(15);
    fechanacconst              VARCHAR(15);
    v_fechanacimiento          VARCHAR(15);
    v_id_zona_franca           varchar(1);

    CURSOR c_existeempleador IS
      SELECT tp.rnc_o_cedula
        INTO v_rnc_o_cedula
        FROM SRE_EMPLEADORES_T tp
       WHERE tp.rnc_o_cedula = p_rnc_o_cedula;

    CURSOR c_empleadorciudadano IS
      SELECT tp.id_administracion_local,
             tp.fecha_inicio_actividades,
             tp.fecha_nac_const
        INTO v_adm_local, v_fecha_inicio_actividades, v_fecha_nac_const
        FROM DGI_MAESTRO_EMPLEADORES_T tp
       WHERE tp.rnc_cedula = p_rnc_o_cedula;

    --*** Cursor para Ciudadanos.
    CURSOR c_ciudadano IS
      SELECT ci.fecha_nacimiento
        INTO v_fechanacimiento
        FROM SRE_CIUDADANOS_T ci
       WHERE ci.no_documento = p_rnc_o_cedula;
  BEGIN

    OPEN c_existeempleador;

    FETCH c_existeempleador
      INTO v_rnc_o_cedula;
    IF c_existeempleador%FOUND THEN
      CLOSE c_existeempleador;
      RAISE e_invalidrncocedula;
    ELSE
      CLOSE c_existeempleador;
    END IF;

    -- Este es para guardar en la tabla el registro de ciudadano.
    /*    OPEN c_empleadorciudadano;

      FETCH c_empleadorciudadano INTO v_adm_local, v_fecha_inicio_actividades , v_fecha_nac_const;
    IF c_empleadorciudadano%FOUND THEN
        valor_local:= v_adm_local;
        fechainicioactividades:= v_fecha_inicio_actividades;
        fechanacconst:= v_fecha_nac_const;
      ELSE
       valor_local:= NULL;
    END IF;*/

    -- Estos son los datos de ciudadanos.
    OPEN c_ciudadano;

    FETCH c_ciudadano
      INTO v_fechanacimiento;
    IF c_ciudadano%FOUND THEN
      fechanacconst := v_fechanacimiento;
    ELSE
      OPEN c_empleadorciudadano;

      FETCH c_empleadorciudadano
        INTO v_adm_local, v_fecha_inicio_actividades, v_fecha_nac_const;
      IF c_empleadorciudadano%FOUND THEN
        valor_local            := v_adm_local;
        fechainicioactividades := v_fecha_inicio_actividades;
        fechanacconst          := v_fecha_nac_const;
      ELSE
        valor_local := NULL;
      END IF;

    END IF;
    --**********************************************

    IF (LENGTH(p_razon_social)) >
       (Seg_Get_Largo_Columna('SRE_EMPLEADORES_T', 'RAZON_SOCIAL')) THEN
      v_longitud := 'Razon Social';
      RAISE e_excedelogintud;
    END IF;

    IF (LENGTH(p_nombre_comercial)) >
       (Seg_Get_Largo_Columna('SRE_EMPLEADORES_T', 'NOMBRE_COMERCIAL')) THEN
      v_longitud := 'Nombre Comercial';
      RAISE e_excedelogintud;
    END IF;
    IF (LENGTH(p_calle)) >
       (Seg_Get_Largo_Columna('SRE_EMPLEADORES_T', 'CALLE')) THEN
      v_longitud := 'Calle';
      RAISE e_excedelogintud;
    END IF;
    IF (LENGTH(p_numero)) >
       (Seg_Get_Largo_Columna('SRE_EMPLEADORES_T', 'NUMERO')) THEN
      v_longitud := 'Numero';
      RAISE e_excedelogintud;
    END IF;
    IF (LENGTH(p_edificio)) >
       (Seg_Get_Largo_Columna('SRE_EMPLEADORES_T', 'EDIFICIO')) THEN
      v_longitud := 'Edificio';
      RAISE e_excedelogintud;
    END IF;
    IF (LENGTH(p_piso)) >
       (Seg_Get_Largo_Columna('SRE_EMPLEADORES_T', 'PISO')) THEN
      v_longitud := 'Piso';
      RAISE e_excedelogintud;
    END IF;
    IF (LENGTH(p_apartamento)) >
       (Seg_Get_Largo_Columna('SRE_EMPLEADORES_T', 'APARTAMENTO')) THEN
      v_longitud := 'Apartamento';
      RAISE e_excedelogintud;
    END IF;
    IF (LENGTH(p_sector)) >
       (Seg_Get_Largo_Columna('SRE_EMPLEADORES_T', 'SECTOR')) THEN
      v_longitud := 'Sector';
      RAISE e_excedelogintud;
    END IF;
    IF (LENGTH(p_email)) >
       (Seg_Get_Largo_Columna('SRE_EMPLEADORES_T', 'EMAIL')) THEN
      v_longitud := 'Email';
      RAISE e_excedelogintud;
    END IF;

    IF p_ult_usuario_act IS NOT NULL AND
       NOT Seg_Usuarios_Pkg.isexisteusuario(p_ult_usuario_act) THEN
      RAISE e_invaliduser;
    END IF;

    if p_Id_Zona_Franca = 0 then
      v_id_zona_franca := null;
      end if;

    --CMHA
    --03/05/2010
    --Nota: se agrego el campo cod_sector para registro del sector salariar

    INSERT INTO SRE_EMPLEADORES_T
      (id_registro_patronal,
       id_sector_economico,
       id_municipio,
       rnc_o_cedula,
       razon_social,
       nombre_comercial,
--       status,
       calle,
       numero,
       edificio,
       piso,
       apartamento,
       sector,
       telefono_1,
       ext_1,
       telefono_2,
       ext_2,
       fax,
       email,
       tipo_empresa,
       cod_sector,
       fecha_registro,
       ult_usuario_act,
       ult_fecha_act,
       id_administracion_local,
       completo_encuesta,
       fecha_inicio_actividades,
       fecha_nac_const,
       documentos_registro,
       usuario_registro,
       Id_Actividad,
       Id_Zona_Franca,
       Es_Zona_Franca,
       tipo_zona_franca)
    VALUES
      (sre_empleadores_seq.NEXTVAL,
       p_id_sector_economico,
       p_id_municipio,
       p_rnc_o_cedula,
       upper(p_razon_social),
       upper(p_nombre_comercial),
--       'I',
       p_calle,
       p_numero,
       p_edificio,
       p_piso,
       p_apartamento,
       p_sector,
       p_telefono_1,
       p_ext_1,
       p_telefono_2,
       p_ext_2,
       p_fax,
       p_email,
       p_tipo_empresa,
       p_sector_salarial,
       SYSDATE(),
       p_ult_usuario_act,
       SYSDATE(),
       valor_local,
       'N',
       fechainicioactividades,
       fechanacconst,
       p_documentos_registro,
       p_ult_usuario_act,
       p_Id_Actividad,
       v_id_zona_franca,
       p_Es_Zona_Franca,
       p_tipo_zona_franca);
    COMMIT;
    SELECT TO_CHAR(sre_empleadores_seq.CURRVAL)
      INTO v_registropatronal
      FROM dual;

    -- Insertando nomina 999
    INSERT INTO SRE_NOMINAS_T
      (id_registro_patronal,
       id_nomina,
       nomina_des,
       status,
       tipo_nomina,
       ult_fecha_act,
       ult_usuario_act)
    VALUES
      (v_registropatronal,
       '999',
       'Nomina para facturas de auditoria',
       'A', --       'B',
       'N',
       SYSDATE,
       p_ult_usuario_act);
    COMMIT;

    -- Insertando nomina 888 - Nomina de Rectificacion de Pensionado
    INSERT INTO SRE_NOMINAS_T
      (id_registro_patronal,
       id_nomina,
       nomina_des,
       status,
       tipo_nomina,
       ult_fecha_act,
       ult_usuario_act)
    VALUES
      (v_registropatronal,
       '888',
       'Nomina de Rectificacion de Pensionado ',
       'A', -- 'B',
       'N',
       SYSDATE,
       p_ult_usuario_act);
    COMMIT;

-- Comentado por solicitud ticket #6604
-- Gregorio Herrera
-- 14-03/2014

/*    -- Insertando (444) – Nomina de Pensionados por Enfermedad Común
    INSERT INTO SRE_NOMINAS_T
      (id_registro_patronal,
       id_nomina,
       nomina_des,
       status,
       tipo_nomina,
       ult_fecha_act,
       ult_usuario_act)
    VALUES
      (v_registropatronal,
       '444',
       'Nomina de Pensionados por Enfermedad Común',
       'A',
       'E',
       SYSDATE,
       p_ult_usuario_act);
    COMMIT;

    -- Insertando (333) – Nomina de Pensionados por Accidente de Trabajo y/o Enfermedad Profesional
    INSERT INTO SRE_NOMINAS_T
      (id_registro_patronal,
       id_nomina,
       nomina_des,
       status,
       tipo_nomina,
       ult_fecha_act,
       ult_usuario_act)
    VALUES
      (v_registropatronal,
       '333',
       'Nomina de Pensionados por Accidente de Trabajo y/o Enfermedad Profesional',
       'A',
       'T',
       SYSDATE,
       p_ult_usuario_act);
    COMMIT;*/

    --Insertamos el registro en CRM
    Suirplus.Emp_crm_pkg.CrearEmp_Crm(v_registropatronal,
                                      'Registro Inicial',
                                      8,
                                      null,
                                      Null,
                                      'Creación del Empleador en el Sistema Dominicano de Seguridad Social.',
                                      p_ult_usuario_act,
                                      Null,
                                      p_email,
                                      Null,
                                      p_resultNumber);
    Commit;

    p_resultnumber := 0 || '|' || v_registropatronal;

  EXCEPTION

    WHEN e_invalidrncocedula THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(210, NULL, NULL) ||
                        v_longitud;
      RETURN;
    WHEN e_excedelogintud THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(15, NULL, NULL) ||
                        v_longitud;
      RETURN;
    WHEN e_invalidmotivoimpresion THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(10, NULL, NULL);
      RETURN;
    WHEN e_invalidsectoreconomico THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(10, NULL, NULL);
      RETURN;
    WHEN e_invalidregistropatronal THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(10, NULL, NULL);
      RETURN;
    WHEN e_invalidsectoreconomicodes THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(10, NULL, NULL);
      RETURN;
    WHEN e_invalidprovincias THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(10, NULL, NULL);
      RETURN;
    WHEN e_invalidoficios THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(10, NULL, NULL);
      RETURN;
    WHEN e_invalidactividadeconomica THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(10, NULL, NULL);
      RETURN;
    WHEN e_invalidriesgo THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(10, NULL, NULL);
      RETURN;
    WHEN e_invalidmunicipio THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(10, NULL, NULL);
      RETURN;
    WHEN e_invaliduser THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(1, NULL, NULL);
      RETURN;
    WHEN OTHERS THEN
      v_bderror      := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultnumber := Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
      RETURN;
  END;
  --************************************************************************-*-****

  --********************************************************************************************
  --CMHA
  --06/02/2012
  --Verifica si exite motivo en empresa
  --********************************************************************************************
  PROCEDURE isExisteMovimiento(p_id_registro_patronal SRE_REPRESENTANTES_T.id_registro_patronal%TYPE,
                               p_resultnumber         IN OUT VARCHAR2) IS
    v_is_valido            VARCHAR(2);
    v_id_registro_patronal VARCHAR(50);

    CURSOR c_existe_movimiento IS
      SELECT m.id_registro_patronal
        FROM SRE_DET_MOVIMIENTO_T t, SRE_MOVIMIENTO_T m
       WHERE m.id_movimiento = t.id_movimiento
         AND m.id_registro_patronal = p_id_registro_patronal
         AND m.status NOT IN ('P', 'R');

  BEGIN

    OPEN c_existe_movimiento;
    FETCH c_existe_movimiento
      INTO v_id_registro_patronal;

    IF (c_existe_movimiento%NOTFOUND) THEN
      v_is_valido := 'No';
    ELSE
      v_is_valido := 'Si';
    END IF;
    CLOSE c_existe_movimiento;

    p_resultnumber := v_is_valido;

  EXCEPTION

    WHEN OTHERS THEN
      v_bderror      := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultnumber := Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
      RETURN;
  END;

  -- **************************************************************************************************
  -- CHA  06/02/2012
  -- Program:     TieneMovimientosPendientes
  -- Description: Metodo para verificar si tiene movimeintos pendientes
  -- **************************************************************************************************

  PROCEDURE Permitir_Pago(p_id_registro_patronal IN SRE_EMPLEADORES_T.id_registro_patronal%TYPE,
                          p_resultnumber         IN OUT VARCHAR2) is
    result varchar2(1);
    conteo number(9);
  begin
    -- ver si el empleador especificado existe
    select count(*)
      into conteo
      from sre_empleadores_t e
     where e.id_registro_patronal = p_id_registro_patronal;

    if (conteo = 0) then
      -- no existe el empleador, no permitir_pago
      result := 'N';
    else
      -- existe, ver si tiene movimientos que no esten en P ó R
      select count(*)
        into conteo
        from sre_movimiento_t m
       where m.id_registro_patronal = p_id_registro_patronal
         and m.status not in ('P', 'R');

      if (conteo = 0) then
        -- no tiene movimientos que no sean P ó R
        result := 'S';
      else
        -- tiene movimientos que no son P ó R
        result := 'N';
      end if;
    end if;

    p_resultnumber := result;
  EXCEPTION

    WHEN OTHERS THEN
      v_bderror      := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultnumber := Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
      RETURN;

  end;

  --*******************************************************************************
  -- Selecciona los Empleadores.
  -- CHA 06/02/2012
  -- Se removieron los join con tipo de motivo y la funcion isExisteMovimiento.
  --*******************************************************************************
  PROCEDURE empleadores_select(p_id_registro_patronal IN SRE_EMPLEADORES_T.id_registro_patronal%TYPE,
                               p_rnc_o_cedula         IN SRE_EMPLEADORES_T.rnc_o_cedula%TYPE,
                               io_cursor              IN OUT t_cursor) IS
    mRP integer;    
    v_periodo number := Parm.periodo_vigente();   
    v_fecha   date   := TRUNC(srp_pkg.fecha_inicio_periodo(v_periodo));
  BEGIN
    if (p_id_registro_patronal is not null) then
      mRP := p_id_registro_patronal;
    elsif (p_rnc_o_cedula is not null) then
      begin
        select id_registro_patronal
          into mRP
          from sre_empleadores_t
         where rnc_o_cedula = p_rnc_o_cedula;
      exception
        when no_data_found then
          mRP := -1;
      end;
    else
      mRP := -1;
    end if;

    OPEN io_cursor FOR

      SELECT e.id_registro_patronal,
             c.factor_riesgo as factor_riesgo,
             e.id_motivo_no_impresion,
             e.ruta_distribucion,
             e.id_sector_economico,
             e.fecha_inicio_actividades,
             e.fecha_nac_const,
             e.id_actividad_eco,
             e.id_riesgo,
             e.id_municipio,
             initcap(m.municipio_des) municipio_des,
             e.rnc_o_cedula,
             e.razon_social,
             e.completo_encuesta,
             NVL(e.nombre_comercial, ' ') AS nombre_comercial,
             e.status,
             initcap(e.calle) calle,
             e.numero,
             initcap(e.edificio) edificio,
             e.piso,
             e.apartamento,
             initcap(e.sector) sector,
             NVL(e.telefono_1, ' ') AS telefono_1,
             NVL(e.ext_1, ' ') AS ext_1,
             NVL(e.telefono_2, ' ') AS telefono_2,
             NVL(e.ext_2, ' ') AS ext_2,
             NVL(e.fax, ' ') AS fax,
             lower(e.email) email,
             e.tipo_empresa,
             e.id_oficio,
             e.descuento_penalidad,
             e.no_paga_idss,
             e.fecha_registro,
             initcap(P.provincia_des) provincia_des,
             initcap(s.sector_economico_des) sector_economico_des,
             initcap(a.administracion_local_des) administracion_local_des,
             initcap(ae.actividad_eco_des) actividad_eco_des,
             m.id_provincia,
             IsEmpleadorEnLegal(e.id_registro_patronal) status_cobro,--respaldado por ticket 6837
             e.paga_infotep,
             e.capital,
            (
             SELECT salario_minimo
               FROM sre_escala_salarial_t
              WHERE cod_sector = e.cod_sector
                AND v_fecha BETWEEN fecha_inicio AND NVL(fecha_fin, v_fecha)
             ) salario_minimo_vigente,            
             INITCAP(des.descripcion) sector_salarial,
             e.id_sector_economico,
             e.cod_sector,
             NVL(e.capital, 0) capital,
             NVL(e.paga_mdt, 'N') paga_mdt,
             e.pago_discapacidad,
             (
              select case count(*) when 0 then 'N' else 'S' end
              from suirplus.lgl_acuerdos_t a
              where a.id_registro_patronal = mRP
                and a.status in (1,2,3,4)
             ) Tiene_acuerdo
        FROM SRE_EMPLEADORES_T e
        left join SRE_MUNICIPIO_T m
          on m.id_municipio = e.id_municipio
        left join SRE_PROVINCIAS_T P
          on P.id_provincia = m.id_provincia
        left join SRE_SECTOR_ECONOMICO_T s
          on s.id_sector_economico = e.id_sector_economico
        left join DGI_ADMINISTRACION_LOCAL_T a
          on a.id_administracion_local = e.id_administracion_local
        left join SRE_CATEGORIA_RIESGO_T c
          on c.id_riesgo = e.id_riesgo
        left join SRE_ACTIVIDAD_ECONOMICA_T ae
          on ae.id_actividad_eco = e.id_actividad_eco
        left join sre_escala_salarial_t es
          on es.cod_sector = e.cod_sector
         and es.fecha_fin is null
        left join sre_sectores_salariales_t des
          on des.cod_sector = e.cod_sector
       WHERE e.id_registro_patronal = mRP
      --and (es.fecha_fin is null and es.fecha_inicio = (select max(fecha_inicio) from sre_escala_salarial_t esc where esc.cod_sector = e.cod_sector ))
       ORDER BY e.razon_social ASC;
  END;

  --*******************************************************************************
  --**************************** Empleadores por RNC ******************************

  PROCEDURE empleadores_rnc_select(p_rnc_o_cedula IN SRE_EMPLEADORES_T.rnc_o_cedula%TYPE,
                                   p_resultnumber IN OUT VARCHAR2,
                                   io_cursor      IN OUT t_cursor)

   IS
    v_cursor t_cursor;
    --v_movimiento_pendiente VARCHAR(2);
    v_movimiento_pendiente_2 VARCHAR(2);
    v_registropatronal       VARCHAR(20);

  BEGIN
    IF (p_rnc_o_cedula IS NOT NULL) THEN
      v_registropatronal       := Sre_Empleadores_Pkg.get_registropatronal(p_rnc_o_cedula);
      v_movimiento_pendiente_2 := Sre_Empleadores_Pkg.isExisteMovimiento(v_registropatronal);

      OPEN v_cursor FOR
        SELECT e.id_registro_patronal,
               c.factor_riesgo,
               e.id_motivo_no_impresion,
               e.ruta_distribucion,
               e.id_sector_economico,
               e.fecha_inicio_actividades,
               e.fecha_nac_const,
               e.id_actividad_eco,
               e.id_riesgo,
               e.id_municipio,
               m.municipio_des,
               e.rnc_o_cedula,
               e.razon_social,
               NVL(e.nombre_comercial, ' ') AS nombre_comercial,
               e.status,
               e.calle,
               e.numero,
               e.edificio,
               e.piso,
               e.apartamento,
               e.sector,
               NVL(e.telefono_1, ' ') AS telefono_1,
               NVL(e.ext_1, ' ') AS ext_1,
               NVL(e.telefono_2, ' ') AS telefono_2,
               NVL(e.ext_2, ' ') AS ext_2,
               NVL(e.fax, ' ') AS fax,
               e.email,
               e.tipo_empresa,
               e.id_oficio,
               e.descuento_penalidad,
               e.no_paga_idss,
               e.fecha_registro,
               e.acuerdo_pago,
               P.provincia_des,
               s.sector_economico_des,
               a.administracion_local_des,
               ae.actividad_eco_des,
               v_movimiento_pendiente_2 AS movimientos,
               e.fecha_inicio_actividades,
               e.fecha_nac_const
          FROM SRE_EMPLEADORES_T          e,
               SRE_MUNICIPIO_T            m,
               SRE_PROVINCIAS_T           P,
               SRE_SECTOR_ECONOMICO_T     s,
               DGI_ADMINISTRACION_LOCAL_T a,
               SRE_CATEGORIA_RIESGO_T     c,
               SRE_ACTIVIDAD_ECONOMICA_T  ae
         WHERE e.id_municipio = m.id_municipio
           AND e.id_actividad_eco = ae.id_actividad_eco(+)
           AND P.id_provincia = m.id_provincia
           AND e.id_sector_economico = s.id_sector_economico(+)
           AND e.id_riesgo = c.id_riesgo
           AND e.id_administracion_local = a.id_administracion_local(+)
           AND e.rnc_o_cedula = p_rnc_o_cedula
         ORDER BY e.razon_social ASC;

      io_cursor := v_cursor;
      RETURN;
    END IF;

  END;
  --*******************************************************************************
  -- Verifica que el Empleador Existe.
  --*******************************************************************************
  PROCEDURE empleadores_verificar_existe(

                                         p_rnc_cedula       IN DGI_MAESTRO_EMPLEADORES_T.rnc_cedula%TYPE,
                                         p_razon_social     OUT DGI_MAESTRO_EMPLEADORES_T.razon_social%TYPE,
                                         p_nombre_comercial OUT DGI_MAESTRO_EMPLEADORES_T.nombre_comercial%TYPE,
                                         p_calle            OUT DGI_MAESTRO_EMPLEADORES_T.calle%TYPE,
                                         p_numero           OUT DGI_MAESTRO_EMPLEADORES_T.numero%TYPE,
                                         p_edificio         OUT DGI_MAESTRO_EMPLEADORES_T.edificio%TYPE,
                                         p_piso             OUT DGI_MAESTRO_EMPLEADORES_T.piso%TYPE,
                                         p_apartamento      OUT DGI_MAESTRO_EMPLEADORES_T.apartamento%TYPE,
                                         p_telefono_1       OUT DGI_MAESTRO_EMPLEADORES_T.telefono_1%TYPE,
                                         p_email            OUT DGI_MAESTRO_EMPLEADORES_T.email%TYPE,
                                         p_cod_municipio    OUT DGI_MAESTRO_EMPLEADORES_T.cod_municipio%TYPE,
                                         p_id_provincia     OUT SRE_MUNICIPIO_T.id_provincia%TYPE,
                                         p_tipo_empresa     OUT SRE_EMPLEADORES_T.tipo_empresa%TYPE,
                                         p_resultnumber     OUT VARCHAR2)

   AS

    v_rnc_cedula DGI_MAESTRO_EMPLEADORES_T.rnc_cedula%TYPE;
    CURSOR c_existetss IS
      SELECT rnc_o_cedula
        FROM SRE_EMPLEADORES_T emp
       WHERE emp.rnc_o_cedula = p_rnc_cedula;
    CURSOR c_existedgi IS
      SELECT rnc_cedula
        FROM DGI_MAESTRO_EMPLEADORES_T dgi
       WHERE dgi.rnc_cedula = p_rnc_cedula;
    --CURSOR c_existejce IS SELECT ciu.no_documento FROM  SRE_CIUDADANOS_T ciu WHERE ciu.no_documento = p_rnc_cedula;
    CURSOR c_existejce2 IS
      SELECT ciu.no_documento
        FROM SRE_CIUDADANOS_T ciu
       WHERE ciu.no_documento = p_rnc_cedula;

  BEGIN
    --***  Si existe en la TSS
    OPEN c_existetss;
    FETCH c_existetss
      INTO v_rnc_cedula;
    IF c_existetss%FOUND THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(26, NULL, NULL);
      CLOSE c_existetss;
      RETURN;
    ELSE
      CLOSE c_existetss;
    END IF;
    --**** Hasta aqui TSS.

    -- *** Buscar si existe en ciudadanos para negar el registro
    /*OPEN c_existejce2;

    FETCH c_existejce2 INTO v_rnc_cedula;
    IF c_existejce2%FOUND THEN

       p_resultnumber := Seg_Retornar_Cadena_Error(12, NULL, NULL);
       CLOSE c_existejce2;
       RETURN;

     ELSE
           CLOSE c_existejce2;
    END IF;*/

    --*** Si existe en la DGII
    OPEN c_existedgi;

    FETCH c_existedgi
      INTO v_rnc_cedula;

    IF c_existedgi%FOUND THEN
      SELECT Initcap(dgi.razon_social),
             (dgi.nombre_comercial),
             dgi.calle,
             dgi.numero,
             dgi.edificio,
             dgi.piso,
             dgi.apartamento,
             dgi.telefono_1,
             dgi.email,
             LPAD(dgi.cod_municipio, 3, '0') cod_municio,
             NVL(m.id_provincia, ''),
             dgi.tipo_empresa
        INTO p_razon_social,
             p_nombre_comercial,
             p_calle,
             p_numero,
             p_edificio,
             p_piso,
             p_apartamento,
             p_telefono_1,
             p_email,
             p_cod_municipio,
             p_id_provincia,
             p_tipo_empresa
        FROM DGI_MAESTRO_EMPLEADORES_T dgi, SRE_MUNICIPIO_T m
       WHERE dgi.cod_municipio = m.id_municipio(+)
         AND dgi.rnc_cedula = p_rnc_cedula
         AND dgi.TIPO_EMPRESA IS NOT NULL;

      p_resultnumber := 0;
      CLOSE c_existedgi;
      RETURN;
    ELSE
      CLOSE c_existedgi;
    END IF;
    --**** Hasta aqui DGII
    /*
    -- **** Si existe en la Ciudadanos
     OPEN c_existejce;

     FETCH c_existejce INTO v_rnc_cedula;
     IF c_existejce%FOUND THEN
        SELECT ciu.nombres || ' ' ||ciu.primer_apellido || ' ' || ciu.segundo_apellido ,
             ciu.nombres || ' ' ||ciu.primer_apellido || ' ' || ciu.segundo_apellido ,
                   'PR'
             INTO
             p_razon_social,
             p_nombre_comercial,
                   p_tipo_empresa

             FROM SRE_CIUDADANOS_T ciu WHERE ciu.no_documento = p_rnc_cedula;
             p_resultnumber := 0;
            -- CLOSE c_existejce;
               RETURN;
     ELSE
       CLOSE c_existejce;
     END IF;
    -- **** Hasta aqui Ciudadanos
    */
    p_resultnumber := Seg_Retornar_Cadena_Error(220, NULL, NULL);
    RETURN;

  END;
  --***************************************************************************************************
  -- Selecciona los Empleadores.
  --***************************************************************************************************

  PROCEDURE Consulta_Empleadores(p_id_registro_patronal IN SRE_EMPLEADORES_T.id_registro_patronal%TYPE,
                                 p_rnc_o_cedula         SRE_EMPLEADORES_T.rnc_o_cedula%TYPE,
                                 p_nombre_comercial     SRE_EMPLEADORES_T.nombre_comercial%TYPE,
                                 p_razon_Social         SRE_EMPLEADORES_T.razon_social%TYPE,
                                 p_telefono             IN SRE_EMPLEADORES_T.telefono_1%TYPE,
                                 io_cursor              IN OUT t_cursor)

   IS
    v_cursor t_cursor;

  BEGIN

    IF (p_rnc_o_cedula IS NOT NULL) THEN
      OPEN v_cursor FOR

        SELECT e.id_registro_patronal,
               e.rnc_o_cedula,
               e.razon_social,
               e.telefono_1,
               e.ext_1,
               e.telefono_2,
               e.ext_2,
               e.nombre_comercial,
               e.fecha_inicio_actividades,
               e.fecha_nac_const
          FROM SRE_EMPLEADORES_T e
         WHERE e.rnc_o_cedula = p_rnc_o_cedula;

      io_cursor := v_cursor;
      RETURN;
    ELSIF (p_id_registro_patronal IS NOT NULL) THEN
      OPEN v_cursor FOR

        SELECT e.id_registro_patronal,
               e.rnc_o_cedula,
               e.razon_social,
               e.telefono_1,
               e.ext_1,
               e.telefono_2,
               e.ext_2,
               e.nombre_comercial,
               e.fecha_inicio_actividades,
               e.fecha_nac_const
          FROM SRE_EMPLEADORES_T e
         WHERE e.id_registro_patronal = p_id_registro_patronal;

      io_cursor := v_cursor;
      RETURN;

    ELSIF (p_nombre_comercial IS NOT NULL) THEN

      OPEN v_cursor FOR
        SELECT e.id_registro_patronal,
               e.rnc_o_cedula,
               e.razon_social,
               e.telefono_1,
               e.ext_1,
               e.telefono_2,
               e.ext_2,
               e.nombre_comercial,
               e.fecha_inicio_actividades,
               e.fecha_nac_const
          FROM SRE_EMPLEADORES_T e
         WHERE e.nombre_comercial LIKE
               '%' || UPPER(p_nombre_comercial) || '%';

      io_cursor := v_cursor;
      RETURN;

    ELSIF (p_razon_Social IS NOT NULL) THEN

      OPEN v_cursor FOR
        SELECT e.id_registro_patronal,
               e.rnc_o_cedula,
               e.razon_social,
               e.telefono_1,
               e.ext_1,
               e.telefono_2,
               e.ext_2,
               e.nombre_comercial,
               e.fecha_inicio_actividades,
               e.fecha_nac_const
          FROM SRE_EMPLEADORES_T e
         WHERE e.razon_social LIKE '%' || UPPER(p_razon_Social) || '%';

      io_cursor := v_cursor;
      RETURN;

    ELSIF (p_telefono IS NOT NULL) THEN

      OPEN v_cursor FOR
        SELECT e.id_registro_patronal,
               e.rnc_o_cedula,
               e.razon_social,
               e.telefono_1,
               e.ext_1,
               e.telefono_2,
               e.ext_2,
               e.nombre_comercial,
               e.fecha_inicio_actividades,
               e.fecha_nac_const
          FROM SRE_EMPLEADORES_T e
         WHERE e.telefono_1 LIKE '%' || p_telefono || '%'
            OR e.telefono_2 LIKE '%' || p_telefono || '%';

      io_cursor := v_cursor;
      RETURN;

    ELSIF (p_nombre_comercial IS NOT NULL) AND (p_razon_Social IS NOT NULL) THEN

      OPEN v_cursor FOR
        SELECT e.id_registro_patronal,
               e.rnc_o_cedula,
               e.razon_social,
               e.telefono_1,
               e.ext_1,
               e.telefono_2,
               e.ext_2,
               e.nombre_comercial,
               e.fecha_inicio_actividades,
               e.fecha_nac_const
          FROM SRE_EMPLEADORES_T e
         WHERE e.nombre_comercial LIKE
               '%' || UPPER(p_nombre_comercial) || '%'
           AND e.razon_social LIKE '%' || UPPER(p_razon_Social) || '%';

      io_cursor := v_cursor;
      RETURN;

    ELSIF (p_nombre_comercial IS NOT NULL) AND (p_razon_Social IS NOT NULL) AND
          (p_telefono IS NOT NULL) THEN

      OPEN v_cursor FOR
        SELECT e.id_registro_patronal,
               e.rnc_o_cedula,
               e.razon_social,
               e.telefono_1,
               e.ext_1,
               e.telefono_2,
               e.ext_2,
               e.nombre_comercial,
               e.fecha_inicio_actividades,
               e.fecha_nac_const
          FROM SRE_EMPLEADORES_T e
         WHERE e.nombre_comercial LIKE
               '%' || UPPER(p_nombre_comercial) || '%'
           AND e.razon_social LIKE '%' || UPPER(p_razon_Social) || '%'
           AND e.telefono_1 LIKE '%' || p_telefono || '%'
            OR e.telefono_2 LIKE '%' || p_telefono || '%';

      io_cursor := v_cursor;
      RETURN;

    END IF;

  END;

  --- **************************************************************************************************
  -- PROCEDIMIENTO:     Get_MotivoNoImpresion
  -- DESCRIPCION:       Para traer el contenido de la tabla "sre_motivo_no_impresion_t"
  -- **************************************************************************************************

  PROCEDURE Get_MotivoNoImpresion(p_iocursor     IN OUT t_cursor,
                                  p_resultnumber OUT VARCHAR2)

   IS

    v_bderror VARCHAR(1000);

    c_cursor t_cursor;

  BEGIN

    OPEN c_cursor FOR
      SELECT m.id_motivo_no_impresion,
             m.motivo_no_impresion_des,
             m.ult_fecha_act,
             m.ult_usuario_act
        FROM SRE_MOTIVO_NO_IMPRESION_T m;

    p_iocursor     := c_cursor;
    p_resultnumber := 0;

  EXCEPTION

    WHEN OTHERS THEN
      v_bderror      := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultnumber := Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
      RETURN;
  END;

  --******************************************************************************************************
  /* procedure getregistropatronal(p_rncocedula in sre_empleadores_t.rnc_o_cedula%type,
                                  p_registropatronal out sre_empleadores_t.id_registro_patronal%type)
  is
      v_registropatronal number;
  begin

      select id_registro_patronal into v_registropatronal
      from sre_empleadores_t t
      where t.rnc_o_cedula = p_rncocedula;

      p_registropatronal := p_registropatronal;

  end;*/

  --**************************
  -- Funcion Rnc Cedula
  --***************************

  FUNCTION isRncOCedulaValida(p_rnc_o_cedula SRE_EMPLEADORES_T.rnc_o_cedula%TYPE)
    RETURN BOOLEAN IS

    CURSOR c_existe_rnccedula IS

      SELECT t.rnc_o_cedula
        FROM SRE_EMPLEADORES_T t
       WHERE t.rnc_o_cedula = p_rnc_o_cedula;
    returnValue  BOOLEAN;
    p_RncOCedula VARCHAR(22);

  BEGIN
    OPEN c_existe_rnccedula;
    FETCH c_existe_rnccedula
      INTO p_RncOCedula;
    returnValue := c_existe_rnccedula%FOUND;
    CLOSE c_existe_rnccedula;

    RETURN(returnValue);

  END isRncOCedulaValida;

  -- Procedure que devuelve si el rnc_o_cedula está activo en la tabla SRE_EMPLEADORES_T
  PROCEDURE isRncOCedulaInactiva(p_rnc_o_cedula  SRE_EMPLEADORES_T.rnc_o_cedula%TYPE,
                                 p_result_number out varchar2) IS

    CURSOR c_existe_rnccedula IS

      SELECT t.rnc_o_cedula
        FROM SRE_EMPLEADORES_T t
       WHERE t.rnc_o_cedula = p_rnc_o_cedula
         and t.status = 'B';
    returnValue  BOOLEAN;
    p_RncOCedula VARCHAR(22);

  BEGIN
    OPEN c_existe_rnccedula;
    FETCH c_existe_rnccedula
      INTO p_RncOCedula;
    returnValue := c_existe_rnccedula%FOUND;
    CLOSE c_existe_rnccedula;

    If returnValue Then
      p_result_number := Seg_Retornar_Cadena_Error(34, NULL, NULL);
      p_result_number := substr(p_result_number,
                                instr(p_result_number, '|') + 1,
                                length(p_result_number));
    Else
      p_result_number := 'OK';
    End if;
  END isRncOCedulaInactiva;

  --*************************************************
  -- Procedure que devuelve el Registro Patronal a partir del RnC
  --*************************************************
  /*procedure get_registropatronal(
                   p_rnc_o_cedula              in varchar2 ,
                   p_resultnumber             in out varchar2)
  is
  v_registropatronal number;

  begin
  if (p_rnc_o_cedula is not null) then

       select e.id_registro_patronal into v_registropatronal from sre_empleadores_t e where e.rnc_o_cedula = p_rnc_o_cedula ;
       p_resultnumber := v_registropatronal;
       commit;
       return;

  end if;

  end;*/

  --***********************************************************
  -- Funcion que devuelve el Registro Patronal a partir del RnC
  --**************************************************************
  FUNCTION get_registropatronal(p_rnc_o_cedula SRE_EMPLEADORES_T.rnc_o_cedula%TYPE)
    RETURN varchar2 IS

    v_registropatronal varchar2(25);

  BEGIN
    v_registropatronal := '-1';

    SELECT e.id_registro_patronal
      into v_registropatronal
      FROM SRE_EMPLEADORES_T e
     WHERE e.rnc_o_cedula = p_rnc_o_cedula;

    RETURN v_registropatronal;

  exception

    when no_data_found then
      return v_registropatronal;

  END get_registropatronal;

  --************************************************************
  -- Procedure que devuelve el Registro Patronal a partir del RnC
  --**************************************************************
  procedure getRegistroPatronal(p_rnc_o_cedula in SRE_EMPLEADORES_T.rnc_o_cedula%TYPE,
                                p_resultnumber OUT VARCHAR2) IS
    v_resultado varchar2(500);
    e_InvalidRNC exception;

  BEGIN

    if not suirplus.sre_empleadores_pkg.isRncOCedulaValida(p_rnc_o_cedula) then
      raise e_InvalidRNC;
    end if;

    SELECT e.id_registro_patronal
      INTO v_resultado
      FROM SRE_EMPLEADORES_T e
     WHERE e.rnc_o_cedula = p_rnc_o_cedula;

    p_resultnumber := v_resultado;

  EXCEPTION

    WHEN e_InvalidRNC THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(150, NULL, NULL);
      RETURN;

    WHEN OTHERS THEN
      v_bderror      := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultnumber := Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
      RETURN;

  END getRegistroPatronal;

  --******************************************************************************
  -- Procedure que devuelve el Registro Patronal a partir del RnC en estatus = A
  --*******************************************************************************
  procedure getRegistroPatronalActivo(p_rnc_o_cedula in SRE_EMPLEADORES_T.rnc_o_cedula%TYPE,
                                      p_resultnumber OUT VARCHAR2) IS
    v_resultado varchar2(10);
    e_InvalidRNC exception;

  BEGIN
    begin
      SELECT e.id_registro_patronal
        INTO v_resultado
        FROM SRE_EMPLEADORES_T e
       WHERE e.rnc_o_cedula = p_rnc_o_cedula
       and e.status = 'A';
     EXCEPTION
       WHEN NO_DATA_FOUND THEN
         return;
    end;
    p_resultnumber := v_resultado;

  EXCEPTION

    WHEN OTHERS THEN
      v_bderror      := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultnumber := Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
      RETURN;

  END getRegistroPatronalActivo;
  --*********************************************************************
  -- Funcion que devuelve el Rnc_o_Cedula a partir del Registro Patronal
  --*********************************************************************
  FUNCTION get_rncocedula(p_id_registro_patronal SRE_EMPLEADORES_T.id_registro_patronal%TYPE)
    RETURN VARCHAR2 IS
    v_rnccedula VARCHAR2(11);
  BEGIN

    SELECT e.rnc_o_cedula
      INTO v_rnccedula
      FROM SRE_EMPLEADORES_T e
     WHERE e.id_registro_patronal = p_id_registro_patronal;
    RETURN v_rnccedula;

  END get_rncocedula;
  --****************************************************************
  FUNCTION Existeregistropatronal(p_Id_Registro_Patronal VARCHAR2)
    RETURN BOOLEAN IS
    /*
    DESCRIPCION : Funcion que retorna la existencia de un Registro Patronal.

    PARAMS: ID_REGISTRO_PATRONAL => Identificador del Registro Patronal.

    */
    CURSOR c_existe_registro_patronal IS

      SELECT t.Id_Registro_Patronal
        FROM SRE_EMPLEADORES_T t
       WHERE t.ID_registro_patronal = p_Id_Registro_patronal;
    returnValue          BOOLEAN;
    p_IdRegistroPatronal VARCHAR(22);
  BEGIN
    OPEN c_existe_registro_patronal;
    FETCH c_existe_registro_patronal
      INTO p_IdRegistroPatronal;
    returnValue := c_existe_registro_patronal%FOUND;
    CLOSE c_existe_registro_patronal;

    RETURN(returnValue);

  END Existeregistropatronal;
  --***************************************************************************************************
  -- Funcion para determinar si un empleador tiene movimientos pendientes.
  --***************************************************************************************************
  FUNCTION isExisteMovimiento(p_id_registro_patronal SRE_REPRESENTANTES_T.id_registro_patronal%TYPE)
    RETURN VARCHAR IS
    v_is_valido            VARCHAR(2);
    v_id_registro_patronal VARCHAR(50);

    CURSOR c_existe_movimiento IS
      SELECT m.id_registro_patronal
        FROM SRE_DET_MOVIMIENTO_T t, SRE_MOVIMIENTO_T m
       WHERE m.id_movimiento = t.id_movimiento
         AND m.id_registro_patronal = p_id_registro_patronal
         AND m.status NOT IN ('P', 'R');

  BEGIN

    OPEN c_existe_movimiento;
    FETCH c_existe_movimiento
      INTO v_id_registro_patronal;

    IF (c_existe_movimiento%NOTFOUND) THEN
      v_is_valido := 'No';
    ELSE
      v_is_valido := 'Si';
    END IF;
    CLOSE c_existe_movimiento;
    RETURN(v_is_valido);
  END isExisteMovimiento;

  --***************************************************************************************************
  -- Funcion para determinar si un empleador esta en Legal.
  --***************************************************************************************************
  procedure IsEmpleadorEnLegal(p_RNC          in sre_empleadores_t.rnc_o_cedula%type,
                               p_resultnumber out varchar2)

   is
    v_status_acuerdo varchar2(1);

    --Respaldado por ticket 6837
    cursor c_StatusAcuerdo is
      select IsEmpleadorEnLegal(e.id_registro_patronal)
        from suirplus.sre_empleadores_t e
       where e.rnc_o_cedula = p_RNC;
  begin

    open c_StatusAcuerdo;
    fetch c_StatusAcuerdo
      into v_status_acuerdo;
    p_resultnumber := 0;
    close c_StatusAcuerdo;

    if v_status_acuerdo is not null then

      if v_status_acuerdo = 'L' then
        p_resultnumber := 1;
      else
        p_resultnumber := 0;
      end if;
    end if;

  end;

  --===================================================================================================
  -- Funcion para determinar en linea si un empleador esta en Legal .
  -- Buscando un acuerdo de pago activo o una referencia de tres o mas periodos vencidos.
  -- Creada por Gregorio U. Herrera
  -- 22/07/2014
  -- Ticket #6837
  --===================================================================================================
  Function IsEmpleadorEnLegal(p_id_registro_patronal in sre_empleadores_t.id_registro_patronal%type)
  Return Char
  Is
    v_tiene           pls_integer;
    v_periodo_vencido suirplus.sfc_facturas_t.periodo_factura%type;
  Begin
    --Si tiene el oficio aplicado
    Select count(*)
    Into v_tiene
    From suirplus.ofc_oficios_t o
    where o.id_registro_patronal = p_id_registro_patronal
      and o.id_accion = 14 --Permitir envio novedades retroactivas
      and trunc(o.fecha_procesa) = trunc(sysdate)
      and o.status = 'A';

    If v_tiene > 0 Then
      Return 'N';
    Else
      --Si tiene al menos un acuerdo de pago en estatus activo
      Select count(*)
      Into v_tiene
      From suirplus.lgl_acuerdos_t a
      Where a.id_registro_patronal = p_id_registro_patronal
        and a.status in (1,2,3,4);

      If v_tiene > 0 Then
        Return 'L';
      Else
        -- Se saca el periodo vencido a partir de la fecha actual.
        Select to_number(to_char(add_months(to_date(suirplus.parm.periodo_vigente(sysdate),
                                          'yyyymm'), -3), 'yyyymm'))
        Into v_periodo_vencido
        From dual;

        --Buscamos si al menos una referencia de pago de tres o mas periodos vencidos
        Select count(*)
        Into v_tiene
        From suirplus.sfc_facturas_t f
        Where f.id_registro_patronal = p_id_registro_patronal
          and f.status = 'VE'
          and f.no_autorizacion is null
          and f.periodo_factura <= v_periodo_vencido
          and (
               (f.id_tipo_factura<>'U')
                or
               (f.id_tipo_factura='U' and nvl(f.status_generacion, 'P')<>'P')
              );

        --Si tiene referencias pendientes de pago en los ultimos tres meses
        If v_tiene > 0 Then
          Return 'L';
        Else
           Return 'N';
        End if;
      End if;
    End if;
  End;

  --***************************************************************************************************
  -- Funcion para determinar si un empleador tiene acuerdo de pago en status 1,2,3,4
  -- Creada por charlie pena
  -- 15/12/2014
  -- Ticket #7271
  --***************************************************************************************************
  function IsTieneAcuerdodePago(p_regPatronal in sre_empleadores_t.id_registro_patronal%type)
    return integer

   is
    v_tiene_acuerdo integer(1);
  begin
       select count(*) into v_tiene_acuerdo
       from lgl_acuerdos_t a
       where a.id_registro_patronal = p_regPatronal
       and a.status in(1,2,3,4);

       return v_tiene_acuerdo;

  end;
  --**********************
  --**********************
  PROCEDURE Get_Representantes(p_id_registro_patronal IN SRE_EMPLEADORES_T.id_registro_patronal%TYPE,
                               io_cursor              IN OUT t_cursor)

   IS
    v_cursor t_cursor;

  BEGIN

    IF (p_id_registro_patronal IS NOT NULL) THEN
      OPEN v_cursor FOR

        SELECT c.no_documento,
               Srp_Pkg.ProperCase(c.nombres || '  ' || c.primer_apellido || '  ' ||
                                  c.segundo_apellido) AS nombre,
               r.telefono_1 AS telefono,
               LOWER(u.email) AS email,
               r.ext_1 AS extension1,
               r.telefono_2 AS telefono2,
               r.ext_2 AS extension2
          FROM SRE_REPRESENTANTES_T r, SRE_CIUDADANOS_T c, SEG_USUARIO_T u
         WHERE r.id_nss = c.id_nss
           AND r.status = 'A'
           AND u.id_nss = r.id_nss
           AND u.id_nss = c.id_nss
           AND u.id_registro_patronal = r.id_registro_patronal
           AND r.id_registro_patronal = p_id_registro_patronal;

      io_cursor := v_cursor;
      RETURN;
    ELSIF (p_id_registro_patronal IS NULL) THEN
      OPEN v_cursor FOR

        SELECT c.no_documento,
               Srp_Pkg.ProperCase(c.nombres || '  ' || c.primer_apellido || '  ' ||
                                  c.segundo_apellido) AS nombre,
               r.telefono_1 AS telefono,
               LOWER(u.email) AS email,
               r.ext_1 AS extension1,
               r.telefono_2 AS telefono2,
               r.ext_2 AS extension2
          FROM SRE_REPRESENTANTES_T r, SRE_CIUDADANOS_T c, SEG_USUARIO_T u
         WHERE r.id_nss = c.id_nss
           AND r.status = 'A'
           AND u.id_nss = r.id_nss
           AND u.id_nss = c.id_nss
           AND u.id_registro_patronal = r.id_registro_patronal
           AND u.id_nss = c.id_nss
           AND u.id_registro_patronal = r.id_registro_patronal;

      io_cursor := v_cursor;
      RETURN;
    END IF;

  END;
  --**********
  -- **************************************************************************************************
  -- Program:    Empleadores_Con_AcuerdoPago
  -- Description:
  -- **************************************************************************************************

  PROCEDURE Empleadores_Con_AcuerdoPago(p_iocursor     IN OUT t_cursor,
                                        p_resultnumber OUT VARCHAR2) IS

    v_periodoact NUMBER(6);
    v_periodoant NUMBER(6);
    v_bderror    VARCHAR(1000);
    c_cursor     t_cursor;

  BEGIN
    --para obtener el periodo actual--
    SELECT TO_CHAR(TRUNC(SYSDATE), 'YYYYMM') INTO v_periodoact FROM dual;
    --para obtener el periodo anterior--
    SELECT TO_CHAR(TRUNC(SYSDATE), 'YYYYMM') - 1
      INTO v_periodoant
      FROM dual;

    --valores temporales
    --  v_periodoact:='200309';
    --  v_periodoant:='200306';

    OPEN c_cursor FOR
      SELECT e.rnc_o_cedula RNC,
             Srp_Pkg.ProperCase(e.razon_social) "Razon social",
             NVL(e.telefono_1, ' ') || ' ' || NVL(e.ext_1, ' ') AS "Telefono 1",
             NVL(e.telefono_2, ' ') || ' ' || NVL(e.ext_2, ' ') AS "Telefono 2",
             (SELECT COUNT(*)
                FROM sfc_facturas_v f
               WHERE STATUS = 'PA'
                 AND TO_CHAR(TRUNC(f.FECHA_PAGO), 'YYYYMM') = v_periodoact
                 AND f.ID_REGISTRO_PATRONAL = e.id_registro_patronal) "Pagos Este Mes",
             (SELECT trim(TO_CHAR(SUM(f.TOTAL_GENERAL_FACTURA),
                                  '999,999,990.00'))
                FROM sfc_facturas_v f
               WHERE e.id_registro_patronal = f.ID_REGISTRO_PATRONAL
                 AND f.STATUS = 'PA'
                 AND TO_CHAR(TRUNC(f.FECHA_PAGO), 'YYYYMM') = v_periodoact
               GROUP BY f.ID_REGISTRO_PATRONAL) AS "Total Pagado Este Mes",
             (SELECT COUNT(*)
                FROM sfc_facturas_v f
               WHERE STATUS = 'PA'
                 AND TO_CHAR(TRUNC(f.FECHA_PAGO), 'YYYYMM') = v_periodoant
                 AND f.ID_REGISTRO_PATRONAL = e.id_registro_patronal) "Pagos Mes Pasado",
             (SELECT trim(TO_CHAR(SUM(f.TOTAL_GENERAL_FACTURA),
                                  '999,999,990.00'))
                FROM sfc_facturas_v f
               WHERE e.id_registro_patronal = f.ID_REGISTRO_PATRONAL
                 AND f.STATUS = 'PA'
                 AND TO_CHAR(TRUNC(f.FECHA_PAGO), 'YYYYMM') = v_periodoant
               GROUP BY f.ID_REGISTRO_PATRONAL) AS "Total Pagado Mes Pasado"

        FROM SRE_EMPLEADORES_T e
       WHERE e.acuerdo_pago = 'S'
         AND e.status = 'A'

       ORDER BY e.razon_social ASC;

    p_iocursor     := c_cursor;
    p_resultnumber := 0;

  EXCEPTION

    WHEN OTHERS THEN
      v_bderror      := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultnumber := Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
      RETURN;
  END;

  ------------------------------------------------------------------------------------------------------
  -- **************************************************************************************************
  -- Program:    Cambiar_Rnc
  -- Description:
  -- **************************************************************************************************

  PROCEDURE Cambiar_Rnc(p_Rnc_viejo    in sre_empleadores_t.rnc_o_cedula%type,
                        p_Rnc_Nuevo    in sre_empleadores_t.rnc_o_cedula%type,
                        p_resultnumber in OUT VARCHAR2)

   IS
    v_bderror VARCHAR(1000);

  BEGIN
    if (p_Rnc_viejo is not null) and (p_Rnc_Nuevo is not null) then

      --SEG_USUARIO_T
      UPDATE SEG_USUARIO_T U
         SET U.ID_USUARIO = REPLACE(U.ID_USUARIO, p_Rnc_viejo, p_Rnc_Nuevo)
       WHERE U.ID_USUARIO LIKE p_Rnc_viejo || '%'
         AND U.ID_TIPO_USUARIO = 2;
      COMMIT;

      --SEG_USUARIO_PERMISOS_T
      UPDATE SEG_USUARIO_PERMISOS_T P
         SET P.ID_USUARIO = REPLACE(P.ID_USUARIO, p_Rnc_viejo, p_Rnc_Nuevo)
       WHERE P.ID_USUARIO LIKE p_Rnc_viejo || '%';
      COMMIT;

      --SRE_ARCHIVOS_T
      UPDATE SRE_ARCHIVOS_T A
         SET A.USUARIO_CARGA = REPLACE(A.USUARIO_CARGA,
                                       p_Rnc_viejo,
                                       p_Rnc_Nuevo)
       WHERE A.USUARIO_CARGA LIKE p_Rnc_viejo || '%';
      COMMIT;

      --SFC_FACTURAS_T
      UPDATE SFC_FACTURAS_T F
         SET F.ID_USUARIO_CANCELA = REPLACE(F.ID_USUARIO_CANCELA,
                                            p_Rnc_viejo,
                                            p_Rnc_Nuevo)
       WHERE F.ID_USUARIO_CANCELA LIKE p_Rnc_viejo || '%';
      COMMIT;

      --SFC_FACTURAS_T
      UPDATE SFC_FACTURAS_T F
         SET F.ULT_USUARIO_ACT = REPLACE(F.ULT_USUARIO_ACT,
                                         p_Rnc_viejo,
                                         p_Rnc_Nuevo)
       WHERE F.ULT_USUARIO_ACT LIKE p_Rnc_viejo || '%';
      COMMIT;

      --SFC_LIQUIDACION_ISR_T
      UPDATE SFC_LIQUIDACION_ISR_T L
         SET L.ULT_USUARIO_ACT = REPLACE(L.ULT_USUARIO_ACT,
                                         p_Rnc_viejo,
                                         p_Rnc_Nuevo)
       WHERE L.ULT_USUARIO_ACT LIKE p_Rnc_viejo || '%';
      COMMIT;

      --CRM_REGISTRO_T
      UPDATE CRM_REGISTRO_T C
         SET C.ID_USUARIO = REPLACE(C.ID_USUARIO, p_Rnc_viejo, p_Rnc_Nuevo)
       WHERE C.ID_USUARIO LIKE p_Rnc_viejo || '%';
      COMMIT;

      --CER_CERTIFICACIONES_T

      UPDATE CER_CERTIFICACIONES_T CER
         SET CER.ID_USUARIO = REPLACE(CER.ID_USUARIO,
                                      p_Rnc_viejo,
                                      p_Rnc_Nuevo)
       WHERE CER.ID_USUARIO LIKE p_Rnc_viejo || '%';
      COMMIT;

      --CER_SOL_CERTIFICACIONES_T
      UPDATE CER_SOL_CERTIFICACIONES_T S
         SET S.USUARIO_PROCESA = REPLACE(S.USUARIO_PROCESA,
                                         p_Rnc_viejo,
                                         p_Rnc_Nuevo)
       WHERE S.USUARIO_PROCESA LIKE p_Rnc_viejo || '%';
      COMMIT;

      --SRE_EMPLEADORES_T
      UPDATE SRE_EMPLEADORES_T E
         SET e.rnc_o_cedula = p_Rnc_Nuevo
       WHERE E.rnc_o_cedula = p_Rnc_viejo;
      COMMIT;

      p_resultnumber := 0;

    else
      p_resultnumber := 'REVISAR PARAMETROS';
    end if;

  EXCEPTION

    WHEN OTHERS THEN
      v_bderror      := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultnumber := Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
      RETURN;
  END;

  -- --------------------------------------------------------------------------------------------------------------
  procedure get_Empleadores_byRazon(p_criterio  in sre_empleadores_t.razon_social%type,
                                    p_registros in number,
                                    p_iocursor  IN OUT t_cursor) is
    c_cursor t_cursor;
  begin

    OPEN c_cursor FOR
      select razon_social
        from (select distinct razon_social
                from sre_empleadores_t
               where upper(razon_social) like upper(p_criterio) || '%'
               order by upper(razon_social)) a
       where rownum <= p_registros;
    p_iocursor := c_cursor;
  exception
    when others then
      v_bderror := SUBSTR(SQLERRM, 1, 255);
  end;
  -- --------------------------------------------------------------------------------------------------------------
  procedure get_Empleadores_byNombre(p_criterio  in sre_empleadores_t.nombre_comercial%type,
                                     p_registros in number,
                                     p_iocursor  OUT t_cursor) is
  begin
    OPEN p_iocursor FOR
      select nombre_comercial
        from (select distinct nombre_comercial
                from sre_empleadores_t
               where upper(nombre_comercial) like upper(p_criterio) || '%'
               order by upper(nombre_comercial)) a
       where rownum <= p_registros;
  exception
    when others then
      v_bderror := SUBSTR(SQLERRM, 1, 255);
      commit;
  end;
  -- --------------------------------------------------------------------------------------------------------------
  PROCEDURE pageConsulta_Empleadores(p_id_registro_patronal IN SRE_EMPLEADORES_T.id_registro_patronal%TYPE,
                                     p_rnc_o_cedula         SRE_EMPLEADORES_T.rnc_o_cedula%TYPE,
                                     p_nombre_comercial     SRE_EMPLEADORES_T.nombre_comercial%TYPE,
                                     p_razon_Social         SRE_EMPLEADORES_T.razon_social%TYPE,
                                     p_telefono             IN SRE_EMPLEADORES_T.telefono_1%TYPE,
                                     p_pagenum              in number,
                                     p_pagesize             in number,
                                     io_cursor              IN OUT t_cursor) IS
    v_cursor t_cursor;
    vDesde   integer := (p_pagesize * (p_pagenum - 1)) + 1;
    vhasta   integer := p_pagesize * p_pagenum;
  BEGIN
    OPEN v_cursor FOR
      with x as
       (select rownum num, y.*
          from (SELECT e.id_registro_patronal,
                       e.rnc_o_cedula,
                       e.razon_social,
                       e.telefono_1,
                       e.ext_1,
                       e.telefono_2,
                       e.ext_2,
                       e.nombre_comercial,
                       e.fecha_inicio_actividades,
                       e.fecha_nac_const
                  FROM SRE_EMPLEADORES_T e
                 WHERE (p_rnc_o_cedula is null or
                       e.rnc_o_cedula = p_rnc_o_cedula)
                   and (p_id_registro_patronal is null or
                       e.id_registro_patronal = p_id_registro_patronal)
                   and (p_nombre_comercial is null or
                       upper(e.nombre_comercial) LIKE
                       '%' || UPPER(p_nombre_comercial) || '%')
                   and (p_razon_Social is null or
                       upper(e.razon_social) LIKE
                       '%' || UPPER(p_razon_Social) || '%')
                   and (p_nombre_comercial is null or
                       e.nombre_comercial LIKE
                       '%' || UPPER(p_nombre_comercial) || '%')
                   and (p_telefono is null or
                       e.telefono_1 || ',' || e.telefono_2 LIKE
                       '%' || p_telefono || '%')
                 Order by upper(e.razon_social)) y)
      select y.recordcount, x.*
        from x, (select max(num) recordcount from x) y
       where num between vDesde and vHasta
       order by num;

    io_cursor := v_cursor;
    RETURN;
  END;

  -- **************************************************************************************************
  -- Program:     function usuarioexiste
  -- Description: funcion que retorna la existencia de un usuario y que el mismo
  --              se encuentre activo en el registro.

  -- **************************************************************************************************

  function isExisteUsuario(p_idusuario varchar2) return boolean

   is

    cursor existe_usuario is
      select t.id_usuario
        from seg_usuario_t t
       where t.id_usuario = upper(p_idusuario);

    returnvalue boolean;
    pidusuario  varchar(22);

  begin
    open existe_usuario;
    fetch existe_usuario
      into pidusuario;
    returnvalue := existe_usuario%found;
    close existe_usuario;

    return(returnvalue);

  end isexisteusuario;

  -- **************************************************************************************************
  -- Program:     TieneMovimientosPendientes
  -- Description: funcion para verificar si tiene movimeintos pendientes
  -- **************************************************************************************************
  function Permitir_Pago(p_id_registro_patronal IN SRE_EMPLEADORES_T.id_registro_patronal%TYPE)
    return varchar2 is
    result varchar2(1);
    conteo number(9);
  begin
    -- ver si el empleador especificado existe
    select count(*)
      into conteo
      from sre_empleadores_t e
     where e.id_registro_patronal = p_id_registro_patronal;

    if (conteo = 0) then
      -- no existe el empleador, no permitir_pago
      result := 'N';
    else
      -- existe, ver si tiene movimientos que no esten en P ó R
      select count(*)
        into conteo
        from sre_movimiento_t m
       where m.id_registro_patronal = p_id_registro_patronal
         and m.status not in ('P', 'R');

      if (conteo = 0) then
        -- no tiene movimientos que no sean P ó R
        result := 'S';
      else
        -- tiene movimientos que no son P ó R
        result := 'N';
      end if;
    end if;

    return result;
  end;

  -- **************************************************************************************************
  -- Program:     CuentaBancaria
  -- Description: Procedimiento para obtener los datos de la cuenta actual de un Empleador
  -- **************************************************************************************************
  procedure Get_Cuenta_Bancaria(p_id_registro_patronal in SRE_EMPLEADORES_T.id_registro_patronal%TYPE,
                                p_rnc                  in SRE_EMPLEADORES_T.RNC_O_CEDULA%TYPE,
                                cuentas_cursor         in out t_cursor,
                                p_result_number        in out varchar2) is

    c_cursor t_cursor;
    v_error  varchar2(1000);
    e_NoTieneCuentas EXCEPTION;

  BEGIN

    OPEN c_cursor FOR
      SELECT /*+  first_rows */
       e.id_registro_patronal RegistroPatronal,
       e.Razon_social RazonSocial,
       b.entidad_recaudadora_des EntidadRecaudadora,
       e.cuenta_banco NroCuenta,
       decode(c.no_documento,
              null,
              nvl(e2.razon_social, 'Dato invalido'),
              c.nombres || ' ' || c.primer_apellido || ' ' ||
              nvl(c.segundo_apellido, '')) RNCoCedulaDuenoCuenta,
       e.rnc_o_cedula RNC,
       decode(e.tipo_cuenta,
              1,
              'Cuenta Corriente',
              2,
              'Cuenta de Ahorro',
              e.tipo_cuenta) TipoCuenta
        FROM sre_empleadores_t         e,
             sfc_entidad_recaudadora_t b,
             sre_ciudadanos_t          c,
             sre_empleadores_t         e2
       WHERE b.id_entidad_recaudadora = e.id_entidad_recaudadora
         AND c.no_documento(+) = e.sfs_rnc_o_cedula
         AND e2.rnc_o_cedula(+) = e.sfs_rnc_o_cedula
         AND e.id_registro_patronal =
             decode(p_id_registro_patronal,
                    0,
                    e.id_registro_patronal,
                    p_id_registro_patronal,
                    p_id_registro_patronal)
         AND e.rnc_o_cedula = nvl(p_rnc, e.rnc_o_cedula);

    cuentas_cursor  := c_cursor;
    p_result_number := 0;

  EXCEPTION

    WHEN e_NoTieneCuentas THEN
      p_result_number := Seg_Retornar_Cadena_Error(25, NULL, NULL);
      RETURN;

    WHEN OTHERS THEN
      v_error         := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                 SQLERRM,
                                 1,
                                 255));
      p_result_number := Seg_Retornar_Cadena_Error(-1, v_error, SQLCODE);
      RETURN;

  END;

  -- **************************************************************************************************
  -- Program:     CuentaBancaria
  -- Description: Procedimiento para obtener el listado de cuentas bancarias de un Empleador
  -- **************************************************************************************************
  procedure Get_Historico_Cuentas(p_id_registro_patronal   in SRE_EMPLEADORES_T.id_registro_patronal%TYPE,
                                  historico_cuentas_cursor in out t_cursor,
                                  p_result_number          in out varchar2) is

    c_cursor t_cursor;
    v_error  varchar2(1000);
    e_NoTieneCuentasHistoricas EXCEPTION;

  BEGIN

    OPEN c_cursor FOR

      SELECT id_registro_patronal,
             h.ult_fecha_act,
             cuenta_banco,
             tipo_cuenta,
             h.id_entidad_recaudadora,
             b.entidad_recaudadora_des EntidadRecaudadora
        FROM sfs_historico_cuentas_t h, sfc_entidad_recaudadora_t b
       WHERE h.id_entidad_recaudadora = b.id_entidad_recaudadora
         AND h.id_registro_patronal =
             decode(p_id_registro_patronal,
                    0,
                    h.id_registro_patronal,
                    p_id_registro_patronal,
                    p_id_registro_patronal)
       ORDER BY ult_fecha_act DESC;

    historico_cuentas_cursor := c_cursor;
    p_result_number          := 0;

  EXCEPTION

    WHEN e_NoTieneCuentasHistoricas THEN
      p_result_number := Seg_Retornar_Cadena_Error(25, NULL, NULL);
      RETURN;

    WHEN OTHERS THEN
      v_error         := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                 SQLERRM,
                                 1,
                                 255));
      p_result_number := Seg_Retornar_Cadena_Error(-1, v_error, SQLCODE);
      RETURN;

  END;
  -- **************************************************************************************************
  -- Program:     CuentaBancaria
  -- Description: Procedimiento para crear una cuenta bancaria nueva de un Empleador
  -- **************************************************************************************************
  procedure Actualizar_Cuenta_Bancaria(p_id_entidad_recaudadora in SRE_EMPLEADORES_T.Id_Entidad_Recaudadora%TYPE,
                                       p_rnc_o_cedula           in SRE_EMPLEADORES_T.Sfs_Rnc_o_Cedula%TYPE,
                                       p_cuenta_bancaria        in SRE_EMPLEADORES_T.Cuenta_Banco%TYPE,
                                       p_id_registro_patronal   in SRE_EMPLEADORES_T.ID_REGISTRO_PATRONAL%TYPE,
                                       p_tipo_cuenta            in Sre_Empleadores_t.Tipo_Cuenta%TYPE,
                                       p_usuario                in sfs_historico_cuentas_t.ult_usuario_act%TYPE,
                                       p_result_number          in out varchar2) is

    v_error varchar2(1000);

  BEGIN

    -- que sea un rnc o cedula Activa
    isRncOCedulaInactiva(p_rnc_o_cedula, p_result_number);
    if p_result_number != 'OK' Then
      RETURN;
    end if;

    INSERT INTO sfs_historico_cuentas_t
      (Id_registro_patronal,
       ult_Usuario_Act,
       ult_Fecha_Act,
       Tipo_Registro,
       Cuenta_Banco,
       id_entidad_recaudadora,
       FECHA_CAMBIO,
       tipo_cuenta)
    VALUES
      (p_id_registro_patronal,
       p_usuario,
       Sysdate(),
       'E',
       p_cuenta_bancaria,
       p_id_entidad_recaudadora,
       SYSDATE(),
       p_tipo_cuenta);
    -- commit;

    IF SQL%ROWCOUNT > 0 THEN

      UPDATE sre_empleadores_t e
         SET e.Id_Entidad_Recaudadora = p_id_entidad_recaudadora,
             e.sfs_rnc_o_cedula       = p_rnc_o_cedula,
             e.cuenta_banco           = p_cuenta_bancaria,
             e.tipo_cuenta            = p_tipo_cuenta
       WHERE e.id_registro_patronal = p_id_registro_patronal;

      IF SQL%ROWCOUNT > 0 THEN
        --commit;
        p_result_number := 0;
      END IF;

    END IF;

    /*
    EXCEPTION

       WHEN e_NoTieneCuentasHistoricas THEN
          p_result_number := Seg_Retornar_Cadena_Error(25, NULL, NULL);
          RETURN;

        WHEN OTHERS THEN
          v_error      := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                    SQLERRM,
                                    1,
                                    255));
          p_result_number := Seg_Retornar_Cadena_Error(-1, v_error, SQLCODE);
          RETURN;
          */
  END;
  procedure get_PSS_byNombre(p_criterio  in sfs_prestadoras_t.prestadora_nombre%type,
                             p_registros in number,
                             p_iocursor  IN OUT t_cursor) is
    c_cursor t_cursor;
  begin

    OPEN c_cursor FOR
      select prestadora_nombre
        from (select distinct prestadora_nombre
                from sfs_prestadoras_t
               where upper(prestadora_nombre) like upper(p_criterio) || '%'
               order by upper(prestadora_nombre)) a
       where rownum <= p_registros;
    p_iocursor := c_cursor;
  exception
    when others then
      v_bderror := SUBSTR(SQLERRM, 1, 255);
  end;
  procedure getPagosExcesoExterno(p_Nro_Documento sre_ciudadanos_t.no_documento%type,
                                  p_IOCursor      OUT t_cursor)

   is
    c_cursor       T_CURSOR;
    v_NroDocumento sre_ciudadanos_t.no_documento%type;
    e_NroDocumento exception;
    v_Nss sre_ciudadanos_t.id_nss%type;
  begin

    /*    if not Suirplus.Sfs_Subsidios_Pkg.NroDocumentoValido(p_Nro_Documento, v_NroDocumento) then
         raise e_NroDocumento;
    end if;*/

    if not Suirplus.Sub_Sfs_Validaciones.NroDocumentoValido(p_Nro_Documento) then
      raise e_NroDocumento;
    end if;

    v_NroDocumento := p_Nro_Documento;

    --     v_Nss := sfs_nov_pkg.getNSS(v_NroDocumento);
    v_Nss := suirplus.SUB_SFS_NOVEDADES.getNSS(v_NroDocumento);

    OPEN c_cursor FOR
      Select ep.razon_social as Razon_Social,
             aj.ID_REFERENCIA,
             ci.no_documento as Cedula_Dependiente,
             INITCAP(nvl(ci.nombres, '')) || ' ' ||
             INITCAP(nvl(ci.primer_apellido, '')) || ' ' ||
             INITCAP(nvl(ci.segundo_apellido, '')) Nombre_Dependiente,
             ci2.no_documento as Cedula_Titular,
             INITCAP(nvl(ci2.nombres, '')) || ' ' ||
             INITCAP(nvl(ci2.primer_apellido, '')) || ' ' ||
             INITCAP(nvl(ci2.segundo_apellido, '')) Nombre_Titular,
             pr.PERIODO_PAGO_EXCESO as Periodo,
             Decode(aj.estatus,
                    'PE',
                    'Pendiente',
                    'GE',
                    'Generado',
                    'AP',
                    'Aplicado',
                    'CA',
                    'Cancelado') Estatus,
             aj.fecha_aplicacion as Fecha_Pago,
             pr.monto_del_percapita as Monto
        from suirplus.sfs_pagos_ad_exceso_t pr
        join suirplus.sfc_trans_ajustes_t aj
          on pr.id_ajuste = aj.id_ajuste
        join suirplus.sre_empleadores_t ep
          on pr.id_registro_patronal = ep.id_registro_patronal
        join suirplus.sre_ciudadanos_t ci
          on pr.id_nss_dependiente = ci.id_nss
        join SUIRPLUS.sre_ciudadanos_t ci2
          on pr.id_nss_titular = ci2.id_nss
       Where pr.id_nss_titular = v_Nss
          or pr.id_nss_dependiente = v_Nss
       order by PR.PERIODO_PAGO_EXCESO desc;

    p_IOCursor := c_cursor;
  Exception
    when e_NroDocumento then
      null;
  end getPagosExcesoExterno;

 procedure getPagosExcesoRepresentante(p_id_registro_patronal SRE_EMPLEADORES_T.ID_REGISTRO_PATRONAL%TYPE,
                                       p_referencia sfs_pagos_ad_exceso_t.id_referencia%type,
                                        p_IOCursor             OUT t_cursor) is
    c_cursor T_CURSOR;
  begin
 IF p_referencia is not null then

    OPEN c_cursor FOR
      Select aj.ID_REFERENCIA,
             pr.id_referencia id_referencia_exceso,
             ci.no_documento as Cedula_Dependiente,
             INITCAP(nvl(ci.nombres, '')) || ' ' ||
             INITCAP(nvl(ci.primer_apellido, '')) || ' ' ||
             INITCAP(nvl(ci.segundo_apellido, '')) Nombre_Dependiente,
             ci2.no_documento as Cedula_Titular,
             INITCAP(nvl(ci2.nombres, '')) || ' ' ||
             INITCAP(nvl(ci2.primer_apellido, '')) || ' ' ||
             INITCAP(nvl(ci2.segundo_apellido, '')) Nombre_Titular,
             Decode(aj.estatus,
                    'PE',
                    'Pendiente',
                    'GE',
                    'Generado',
                    'AP',
                    'Aplicado',
                    'CA',
                    'Cancelado') Estatus,
             pr.periodo_pago_exceso as Periodo,
             aj.fecha_aplicacion as Fecha_Pago,
             pr.monto_del_percapita as Monto
        from suirplus.sfs_pagos_ad_exceso_t pr
        join suirplus.sfc_trans_ajustes_t aj
          on pr.id_ajuste = aj.id_ajuste
        join suirplus.sre_ciudadanos_t ci
          on pr.id_nss_dependiente = ci.id_nss
        join SUIRPLUS.sre_ciudadanos_t ci2
          on pr.id_nss_titular = ci2.id_nss
       where aj.id_referencia = p_referencia
       order by pr.periodo_pago_exceso desc;
  else
        OPEN c_cursor FOR
      Select aj.ID_REFERENCIA,
             pr.id_referencia id_referencia_exceso,
             ci.no_documento as Cedula_Dependiente,
             INITCAP(nvl(ci.nombres, '')) || ' ' ||
             INITCAP(nvl(ci.primer_apellido, '')) || ' ' ||
             INITCAP(nvl(ci.segundo_apellido, '')) Nombre_Dependiente,
             ci2.no_documento as Cedula_Titular,
             INITCAP(nvl(ci2.nombres, '')) || ' ' ||
             INITCAP(nvl(ci2.primer_apellido, '')) || ' ' ||
             INITCAP(nvl(ci2.segundo_apellido, '')) Nombre_Titular,
             Decode(aj.estatus,
                    'PE',
                    'Pendiente',
                    'GE',
                    'Generado',
                    'AP',
                    'Aplicado',
                    'CA',
                    'Cancelado') Estatus,
             pr.periodo_pago_exceso as Periodo,
             aj.fecha_aplicacion as Fecha_Pago,
             pr.monto_del_percapita as Monto
        from suirplus.sfs_pagos_ad_exceso_t pr
        join suirplus.sfc_trans_ajustes_t aj
          on pr.id_ajuste = aj.id_ajuste
        join suirplus.sre_ciudadanos_t ci
          on pr.id_nss_dependiente = ci.id_nss
        join SUIRPLUS.sre_ciudadanos_t ci2
          on pr.id_nss_titular = ci2.id_nss
       where pr.id_registro_patronal = p_id_registro_patronal
       order by pr.periodo_pago_exceso desc;
  end if;

    p_IOCursor := c_cursor;

  end getPagosExcesoRepresentante;

  -----------------------------------------------------------------------------------------------------------------
  -- --------------------------------------------------------------------------------------------------------------
  PROCEDURE ConsEmpleadorSinSectorSalarial(p_rnc_o_cedula SRE_EMPLEADORES_T.rnc_o_cedula%TYPE,
                                           p_razon_Social SRE_EMPLEADORES_T.razon_social%TYPE,
                                           io_cursor      IN OUT t_cursor) IS
    v_cursor t_cursor;
  BEGIN
    OPEN v_cursor FOR
      select *
        from (SELECT e.id_registro_patronal,
                     e.rnc_o_cedula,
                     e.razon_social,
                     e.telefono_1,
                     e.ext_1,
                     e.telefono_2,
                     e.ext_2,
                     e.nombre_comercial,
                     e.fecha_inicio_actividades,
                     e.fecha_nac_const
                FROM SRE_EMPLEADORES_T e
               WHERE (p_rnc_o_cedula is null or
                     e.rnc_o_cedula = p_rnc_o_cedula)
                 and (p_razon_Social is null or
                     upper(e.razon_social) LIKE
                     '%' || UPPER(p_razon_Social) || '%')
                 and e.cod_sector is null
                 and e.status <> 'B'
               ORDER BY dbms_random.value)
       WHERE rownum <= 15;

    io_cursor := v_cursor;
    RETURN;

  END;

  -- *****************************************************************************************************
  -- program:   sre_empleadores_pkg
  -- descripcion: Edita o actualiza el sector salarial.
  --
  -- modification history
  -- -----------------------------------------------------------------------------------------------------
  -- date     by          remark
  -- -----------------------------------------------------------------------------------------------------
  -- 14/04/2010 Mayreni Vargas  creation
  -- *****************************************************************************************************
  PROCEDURE empleadores_edit_cod_salarial(p_id_registro_patronal SRE_EMPLEADORES_T.id_registro_patronal%TYPE,
                                          p_id_sector_salarial   SRE_EMPLEADORES_T.Cod_Sector%TYPE,
                                          p_ult_usuario_act      SRE_EMPLEADORES_T.ult_usuario_act%TYPE,
                                          p_resultnumber         IN OUT VARCHAR2)

   IS

    v_sector varchar2(200);

  BEGIN

    -- realiza validaciones.
    IF NOT
        Sre_Empleadores_Pkg.Existeregistropatronal(p_id_registro_patronal) THEN
      RAISE e_invalidregistropatronal;
    End if;

    IF p_ult_usuario_act IS NOT NULL then
      if not (sre_empleadores_pkg.isexisteusuario(p_ult_usuario_act)) THEN
        RAISE e_invaliduser;
      end if;
    else
      RAISE e_invaliduser;
    END IF;

    -- realiza la actualizacion o edicion del empleador.
    UPDATE SRE_EMPLEADORES_T tr
       SET tr.cod_sector      = p_id_sector_salarial,
           tr.ult_usuario_act = UPPER(p_ult_usuario_act),
           tr.ult_fecha_act   = SYSDATE
     WHERE tr.id_registro_patronal = p_id_registro_patronal;

    select sec.descripcion
      into v_sector
      from sre_sectores_salariales_t sec
     where sec.cod_sector = p_id_sector_salarial;

    --CRM
    Suirplus.Emp_Crm_Pkg.CrearEmp_Crm(p_id_registro_patronal,
                                      null,
                                      11,
                                      null,
                                      null,
                                      'Se le asignó el sector salarial ' ||
                                      v_sector,
                                      p_ult_usuario_act,
                                      null,
                                      null,
                                      null,
                                      p_resultNumber);

    p_resultnumber := 0; -- empleador modificado.

    COMMIT;
    RETURN;

  EXCEPTION

    WHEN e_invalidregistropatronal THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(10, NULL, NULL);
      RETURN;
    WHEN e_invaliduser THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(1, NULL, NULL);
      RETURN;
    WHEN OTHERS THEN
      v_bderror      := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultnumber := Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
      RETURN;
  END;
  -- **************************************************************************************************
  -- Program:     ConsEmpleador
  -- Description: Procedimiento para cargar los documentos de un Empleador
  -- **************************************************************************************************
  Procedure getDocumentoEmpleador(p_id_registro_patronal in sre_empleadores_t.id_registro_patronal%type,
                                  p_iocursor             out t_cursor,
                                  p_resultnumber         out Varchar2) is
    v_bderror varchar2(1000);
  Begin

    Open p_iocursor for
      Select e.documentos_registro
        From suirplus.sre_empleadores_t e
       Where e.id_registro_patronal = p_id_registro_patronal;

    p_resultnumber := '0';

  Exception

    When others then
      v_bderror      := (substr('error ' || to_char(sqlcode) || ': ' ||
                                sqlerrm,
                                1,
                                255));
      p_resultnumber := seg_retornar_cadena_error(-1, v_bderror, sqlcode);
  End;
  -- **************************************************************************************************
  -- Program:     ConsEmpleador
  -- Description: Procedimiento para guardar un documento para un empleador
  -- **************************************************************************************************
  Procedure setDocumentoEmpleador(p_id_registro_patronal in sre_empleadores_t.id_registro_patronal%type,
                                  p_documento            in sre_empleadores_t.documentos_registro%type,
                                  p_usuario              in sre_empleadores_t.ult_usuario_act%type,
                                  p_resultnumber         out Varchar2) is
    v_bderror varchar2(1000);
  Begin

    Update sre_empleadores_t
       set documentos_registro = p_documento,
           ult_usuario_act     = p_usuario,
           ult_fecha_act       = sysdate
     where id_registro_patronal = p_id_registro_patronal;

  -- insertar CRM para este empleador
        insert into suirplus.crm_registro_t
        (
          id_registro_crm,id_registro_patronal,asunto,id_tipo_registro,registro_des,id_usuario,fecha_registro
        )
        values
        (
          suirplus.emp_crm_seq.nextval,p_id_registro_patronal,'Anexar documentos o reemplazar los existentes',8,'Se anexaron documentos o se reemplazaron los existentes para este empleador',p_usuario,sysdate
        );
    commit;
    p_resultnumber := '0';

  Exception
    When others then
      v_bderror      := (substr('error ' || to_char(sqlcode) || ': ' ||
                                sqlerrm,
                                1,
                                255));
      p_resultnumber := seg_retornar_cadena_error(-1, v_bderror, sqlcode);
  End;

  --**************************************************************************************************
  --CMHA
  --03/05/2010
  --
  --**************************************************************************************************
  Procedure getClaseEmpresa(p_iocursor     out t_cursor,
                            p_resultnumber out Varchar2) is
    v_bderror varchar2(1000);
  Begin

    Open p_iocursor for
      Select e.id_clase_emp id,
             e.descripcion,
             e.estatus,
             e.ult_fecha_act,
             e.ult_usuario_act
        From suirplus.sre_clase_empresa_t e;

    p_resultnumber := '0';

  Exception

    When others then
      v_bderror      := (substr('error ' || to_char(sqlcode) || ': ' ||
                                sqlerrm,
                                1,
                                255));
      p_resultnumber := seg_retornar_cadena_error(-1, v_bderror, sqlcode);
  End;

  --**************************************************************************************************
  --CMHA
  --03/05/2010
  --
  --**************************************************************************************************
  Procedure getDocClaseEmpresa(p_id_clase_empresa in sre_clase_empresa_t.id_clase_emp%type,
                               p_iocursor         out t_cursor,
                               p_resultnumber     out Varchar2) is
    v_bderror varchar2(1000);
  Begin

    Open p_iocursor for
      Select e.id_seq,
             e.id_clase_emp,
             INITCAP(e.descripcion) descripcion,
             decode(e.obligatorio,'S', 'SI', 'N', 'NO') obligatorio,
             e.estatus,
             e.ult_fecha_act,
             e.ult_usuario_act
        From suirplus.sre_clase_emp_docs_t e, sre_clase_empresa_t c
       where e.id_clase_emp = c.id_clase_emp
         and C.id_clase_emp = p_id_clase_empresa;

    p_resultnumber := '0';

  Exception

    When others then
      v_bderror      := (substr('error ' || to_char(sqlcode) || ': ' ||
                                sqlerrm,
                                1,
                                255));
      p_resultnumber := seg_retornar_cadena_error(-1, v_bderror, sqlcode);
  End;

  --******************************************************************************************
  --CMHA
  --03/05/2010
  --******************************************************************************************
  procedure getDgiiEmpleador(p_rnc_emp      in dgi_maestro_empleadores_t.rnc_cedula%type,
                             p_iocursor     out t_cursor,
                             p_resultnumber out Varchar2) is

    v_cursor   t_cursor;
    v_bderror  varchar2(1000);
    vExisteRnc varchar2(11);
    e_existernc exception;

    CURSOR c_existetss IS
      SELECT rnc_o_cedula
        FROM SRE_EMPLEADORES_T emp
       WHERE emp.rnc_o_cedula = p_rnc_emp;
  begin

    --***  Si existe en la TSS
    OPEN c_existetss;
    FETCH c_existetss
      INTO vExisteRnc;

    IF c_existetss%FOUND THEN
      p_resultnumber := Seg_Retornar_Cadena_Error(26, NULL, NULL);
      CLOSE c_existetss;
      RETURN;
    ELSE
      CLOSE c_existetss;
    END IF;

    -- valida si el RNC existe
    select count(*)
      into vExisteRnc
      from dgi_maestro_empleadores_t d
     where d.rnc_cedula = p_rnc_emp;

    if vExisteRnc = 0 then
      p_resultnumber := Seg_Retornar_Cadena_Error(220, NULL, NULL);
      return;
    end if;

    p_resultnumber := 0;
    --Busca la razon social y sus actividades economico
    open v_cursor for
      select d.rnc_cedula,
             d.razon_social,
             d.id_actividad_eco,
             d.tipo_persona,
             d.nombre_comercial,
             d.tipo_empresa
        from dgi_maestro_empleadores_t d
       where d.rnc_cedula = p_rnc_emp;

    p_iocursor := v_cursor;

  exception
    when others then
      v_bderror      := (substr('error ' || to_char(sqlcode) || ': ' ||
                                sqlerrm,
                                1,
                                255));
      p_resultnumber := seg_retornar_cadena_error(-1, v_bderror, sqlcode);
  end;
  --********************************************************************************************
  --CMHA
  --04/05/2010
  --Actualiza los resgistros de la Empresa
  --********************************************************************************************
  procedure ActualizaRegistroEmpresa(p_idRegPatronal       in sre_representantes_t.id_registro_patronal%type,
                                     p_razon_social        in sre_empleadores_t.razon_social%TYPE,
                                     p_nombre_comercial    in sre_empleadores_t.nombre_comercial%TYPE,
                                     p_cod_sector          in sre_empleadores_t.cod_sector%TYPE,
                                     p_id_sector_economico in sre_empleadores_t.id_sector_economico%TYPE,
                                     p_capital             in sre_empleadores_t.Capital%TYPE,
                                     p_tipo_empresa        in sre_empleadores_t.Tipo_Empresa%TYPE,
                                     p_resultnumber        out varchar2) is

    vRepresentante varchar2(200);
    v_bderror      varchar2(2000);
    e_ExisteRepresentante exception;

  begin
    update sre_empleadores_t e
       set e.razon_social        = p_razon_social,
           e.nombre_comercial    = p_nombre_comercial,
           e.cod_sector          = p_cod_sector,
           e.id_sector_economico = p_id_sector_economico,
           e.capital             = p_capital,
           e.tipo_empresa        = p_tipo_empresa
     where e.id_registro_patronal = p_idRegPatronal;

    commit;
    p_resultnumber := 0;

  exception
    when others then
      v_bderror      := (substr('error ' || to_char(sqlcode) || ': ' ||
                                sqlerrm,
                                1,
                                255));
      p_resultnumber := seg_retornar_cadena_error(-1, v_bderror, sqlcode);

  end;
 --********************************************************************************************
  --Eury Vallejo
  --04/05/2010
  --Obtiene la informacion de Pagos en exceso de forma filtrada
  --********************************************************************************************

procedure FiltrarDatosPagosExceso(p_id_registro_patronal in sre_empleadores_t.id_registro_patronal%type,
                                  p_referencia_ajustes in sfc_trans_ajustes_t.id_referencia%type,
                                  p_referencia_exceso in sfs_pagos_ad_exceso_t.id_referencia%type,
                                  p_cedula_titular in sre_ciudadanos_t.no_documento%type,
                                  p_cedula_dependiente in sre_ciudadanos_t.no_documento%type,
                                  p_IOCursor             OUT t_cursor )
                                  is

c_cursor T_CURSOR;

begin

OPEN c_cursor FOR
   Select aj.ID_REFERENCIA,
             pr.id_referencia id_referencia_exceso,
             ci.no_documento as Cedula_Dependiente,
             INITCAP(nvl(ci.nombres, '')) || ' ' ||
             INITCAP(nvl(ci.primer_apellido, '')) || ' ' ||
             INITCAP(nvl(ci.segundo_apellido, '')) Nombre_Dependiente,
             ci2.no_documento as Cedula_Titular,
             INITCAP(nvl(ci2.nombres, '')) || ' ' ||
             INITCAP(nvl(ci2.primer_apellido, '')) || ' ' ||
             INITCAP(nvl(ci2.segundo_apellido, '')) Nombre_Titular,
             Decode(aj.estatus,
                    'PE',
                    'Pendiente',
                    'GE',
                    'Generado',
                    'AP',
                    'Aplicado',
                    'CA',
                    'Cancelado') Estatus,
             pr.periodo_pago_exceso as Periodo,
             aj.fecha_aplicacion as Fecha_Pago,
             pr.monto_del_percapita as Monto
        from suirplus.sfs_pagos_ad_exceso_t pr
        join suirplus.sfc_trans_ajustes_t aj
          on pr.id_ajuste = aj.id_ajuste
        join suirplus.sre_ciudadanos_t ci
          on pr.id_nss_dependiente = ci.id_nss
        join SUIRPLUS.sre_ciudadanos_t ci2
          on pr.id_nss_titular = ci2.id_nss
          where  pr.id_registro_patronal = p_id_registro_patronal
          and pr.id_referencia = p_referencia_exceso or
          aj.id_referencia =p_referencia_ajustes or
          ci.no_documento = p_cedula_dependiente or
          ci2.no_documento = p_cedula_titular
    order by pr.periodo_pago_exceso desc;

   p_IOCursor := c_cursor;
end;

  --***************************************************************************************************
  --12/12/2013
  --procedure: IsSectorEconomico
  --verifica si el id de sector economico es válido contra el catálogo
  --by charlie peña
  --***************************************************************************************************
  procedure IsSectorEconomico(p_Id in sre_sector_economico_t.id_sector_economico%type,
                              p_resultnumber out varchar2)
   is
    v_resultado integer;
  begin

    select count(*) into v_resultado
    from sre_sector_economico_t t
    where t.id_sector_economico = p_Id;

    p_resultnumber := v_resultado;

  end;
  --***************************************************************************************************
  --12/12/2013
  --procedure: IsSectorSalarial
  --verifica si el id de sector salarial es válido contra el catálogo
  --by charlie peña
  --***************************************************************************************************
  procedure IsSectorSalarial(p_Id in sre_sectores_salariales_t.cod_sector%type,
                              p_resultnumber out varchar2)
   is
    v_resultado integer;
  begin

    select count(*) into v_resultado
    from sre_sectores_salariales_t t
    where t.cod_sector = p_Id;

    p_resultnumber := v_resultado;

  end;

  --***************************************************************************************************
  --12/12/2013
  --procedure: IsZonaFranca
  --verifica si el id de zona franca es válido contra el catálogo
  --by charlie peña
  --***************************************************************************************************
  procedure IsZonaFranca(p_Id in mdt_parques_zona_franca_t.id_zona_franca%type,
                              p_resultnumber out varchar2)
   is
    v_resultado integer;
  begin

    select count(*) into v_resultado
    from mdt_parques_zona_franca_t t
    where t.id_zona_franca = p_Id;

    p_resultnumber := v_resultado;

  end;
  --***************************************************************************************************
  --12/12/2013
  --procedure: IsMunicipio
  --verifica si el id de municipio es válido contra el catálogo
  --by charlie peña
  --***************************************************************************************************
  procedure IsMunicipio(p_Id in sre_municipio_t.id_municipio%type,
                        p_resultnumber out varchar2)
   is
    v_resultado integer;
  begin

    select count(*) into v_resultado
    from sre_municipio_t t
    where t.id_municipio = p_Id;

    p_resultnumber := v_resultado;

  end;

  --**************************************************************************************************
  --evallejo
  --18/07/2014
  --
  --**************************************************************************************************
  /*Procedure getRequisitoEmpresas(p_Id_Clase_Emp in sre_clase_emp_docs_t.id_clase_emp%type,
                                  p_iocursor     out t_cursor,
                                  p_resultnumber out Varchar2) is
    v_bderror varchar2(1000);
  Begin

    Open p_iocursor for
      Select e.descripcion,
             e.obligatorio
        From sre_clase_emp_docs_t e;

    p_resultnumber := '0';

  Exception

    When others then
      v_bderror      := (substr('error ' || to_char(sqlcode) || ': ' ||
                                sqlerrm,
                                1,
                                255));
      p_resultnumber := seg_retornar_cadena_error(-1, v_bderror, sqlcode);
  End;*/



 --**************************************************************************************************
  --evallejo
  --18/07/2014
  --
  --**************************************************************************************************
  /*Procedure getListadoTipoEmpresas(p_id_clase_empresa in sre_clase_empresa_t.id_clase_emp%type,
                                   p_pagenum      in number,
                                   p_pagesize     in number,
                                   p_iocursor         out t_cursor,
                                   p_resultnumber     out Varchar2) is
    v_bderror varchar2(1000);
     v_cursor t_cursor;
    vdesde   integer := (p_pagesize * (p_pagenum - 1)) + 1;
   vhasta   integer := p_pagesize * p_pagenum;
  Begin


         open v_cursor for
     with x as
      (select rownum num, y.*
         from (Select e.id_seq,
             e.id_clase_emp,
             INITCAP(e.descripcion) descripcion,
             e.obligatorio,
             e.estatus,
             e.ult_fecha_act,
             e.ult_usuario_act
        From suirplus.sre_clase_emp_docs_t e, sre_clase_empresa_t c
       where e.id_clase_emp = c.id_clase_emp
         and C.id_clase_emp = p_id_clase_empresa) y)
     select y.recordcount, x.*
       from x, (select max(num) recordcount from x) y
      where num between (vdesde) and (vhasta)
      order by num;

   p_iocursor    := v_cursor;

    p_resultnumber := '0';

  Exception

    When others then
      v_bderror      := (substr('error ' || to_char(sqlcode) || ': ' ||
                                sqlerrm,
                                1,
                                255));
      p_resultnumber := seg_retornar_cadena_error(-1, v_bderror, sqlcode);
  End;*/



  PROCEDURE Get_Mensajes(p_id_registro_patronal IN SRE_EMPLEADORES_T.id_registro_patronal%TYPE,
                         io_cursor              IN OUT t_cursor)

   IS
    v_cursor t_cursor;

  BEGIN

    OPEN v_cursor FOR

      select *
        from sre_mensajes_t e
        where e.id_registro_patronal = p_id_registro_patronal
        and e.status = 'L';

    io_cursor := v_cursor;

  end;


   --***************************************************************************************************
  --30/09/2014
  --procedure: GET_MENSAJES_SIN_LEER
  --Devuelve la cantidad de mensajes que tenga sin leer un empleador en especifico
  --Author: Yacell Borges
  --***************************************************************************************************


  PROCEDURE Get_Mensajes_sin_leer(p_id_registro_patronal IN SRE_EMPLEADORES_T.id_registro_patronal%TYPE,
                                  p_resultnumber         OUT number)

   IS

   v_resultado integer;

  BEGIN
      select count(e.id_mensaje)
      into v_resultado
        from sre_mensajes_t e
        where e.id_registro_patronal = p_id_registro_patronal
        and e.status = 'P';

    --v_result := trim(v_resultado);
    p_resultnumber := v_resultado ;


  end;


   --***************************************************************************************************
  --30/09/2014
  --procedure: GET_MENSAJES_EMPLEADOR
  --Obtiene todos los mensajes del empleador sin importar el status del mensaje
  --Author: Yacell Borges
  --***************************************************************************************************


  PROCEDURE Get_Mensajes_Empleador(p_id_registro_patronal IN SRE_EMPLEADORES_T.id_registro_patronal%TYPE,
                                   io_cursor              IN OUT t_cursor)

   IS
    v_cursor t_cursor;

  BEGIN

    OPEN v_cursor FOR

      select e.id_mensaje,e.asunto, e.id_registro_patronal, e.mensaje, e.fecha_registro, decode(e.status,'P','Pendiente', 'L', 'Leído', 'A', 'Archivado') status, e.fecha_leido, m.razon_social
        from sre_mensajes_t e
        join sre_empleadores_t m on e.id_registro_patronal = m.id_registro_patronal
        where e.id_registro_patronal = p_id_registro_patronal;

    io_cursor := v_cursor;


  end;

   --***************************************************************************************************
  --21/10/2014
  --procedure: GET_MENSAJES_LEIDOS_PENDIENTES
  --Obtiene todos los mensajes del empleador sin importar el status del mensaje
  --Author: Yacell Borges
  --***************************************************************************************************
  PROCEDURE Get_Mensajes_Leidos_Pendientes(p_id_registro_patronal IN SRE_EMPLEADORES_T.id_registro_patronal%TYPE,
                                           p_pagenum      in number,
                                           p_pagesize     in number,
                                           io_cursor      IN OUT t_cursor)

   IS
    v_cursor t_cursor;
    vdesde   integer := (p_pagesize * (p_pagenum - 1)) + 1;
    vhasta   integer := p_pagesize * p_pagenum;

  BEGIN

    OPEN v_cursor FOR

       with x as
      (select rownum num, y.*
         from (select e.id_mensaje,e.asunto, e.id_registro_patronal, e.mensaje,e.usuario_leido, case when e.status='P' then ' ' else (c.nombres ||' '|| c.primer_apellido) end leido_por ,e.fecha_registro, decode(e.status,'P','Pendiente', 'L', 'Leído', 'A', 'Archivado') status, e.fecha_leido, m.razon_social
        from sre_mensajes_t e
        join sre_empleadores_t m on e.id_registro_patronal = m.id_registro_patronal
        left join seg_usuario_t u on u.id_usuario=e.usuario_leido
        left join sre_ciudadanos_t c on c.id_nss=u.id_nss
        where e.id_registro_patronal = p_id_registro_patronal and (e.status = 'P' or e.status='L')
        order by e.fecha_registro desc) y)
     select y.recordcount, x.*
       from x, (select max(num) recordcount from x) y
      where num between (vdesde) and (vhasta)
      order by num;


    io_cursor := v_cursor;


  end;

   --***************************************************************************************************
  --21/10/2014
  --procedure: GET_MENSAJES_ARCHIVADOS
  --Obtiene todos los mensajes del empleador sin importar el status del mensaje
  --Author: Yacell Borges
  --***************************************************************************************************


  PROCEDURE Get_Mensajes_Archivados(p_id_registro_patronal IN SRE_EMPLEADORES_T.id_registro_patronal%TYPE,
                                    p_pagenum      in number,
                                    p_pagesize     in number,
                                    io_cursor      IN OUT t_cursor)

   IS
    v_cursor t_cursor;
    vdesde   integer := (p_pagesize * (p_pagenum - 1)) + 1;
    vhasta   integer := p_pagesize * p_pagenum;

  BEGIN

    OPEN v_cursor FOR

        with x as
      (select rownum num, y.*
         from ( select e.id_mensaje,e.asunto, e.id_registro_patronal, e.mensaje, e.fecha_registro, decode(e.status,'P','Pendiente', 'L', 'Leído', 'A', 'Archivado') status, e.fecha_leido, m.razon_social
        from sre_mensajes_t e
        join sre_empleadores_t m on e.id_registro_patronal = m.id_registro_patronal
        where e.id_registro_patronal = p_id_registro_patronal and e.status='A'
        order by e.fecha_registro desc) y)
     select y.recordcount, x.*
       from x, (select max(num) recordcount from x) y
      where num between (vdesde) and (vhasta)
      order by num;

    io_cursor := v_cursor;


  end;


  --***************************************************************************************************
  --30/09/2014
  --procedure: GET_MENSAJE_LEER
  --Obtiene un mensaje en especifico para un empleador a partirde un id y un registro patronal.
  --Author: Yacell Borges
  --***************************************************************************************************


  PROCEDURE Get_Mensaje_Leer(p_id_registro_patronal IN SRE_EMPLEADORES_T.id_registro_patronal%TYPE,
                              p_id_mensaje           in sre_mensajes_t.id_mensaje%TYPE,
                              io_cursor              IN OUT t_cursor)

   IS
    v_cursor t_cursor;

  BEGIN

    OPEN v_cursor FOR

      select e.id_mensaje,e.asunto, m.razon_social, e.mensaje descripcion_mensaje, e.fecha_registro, e.status, e.fecha_leido
        from sre_mensajes_t e
        join sre_empleadores_t m on e.id_registro_patronal = m.id_registro_patronal
         where e.id_registro_patronal = p_id_registro_patronal and e.id_mensaje = p_id_mensaje ;

    io_cursor := v_cursor;

  end;


  --***************************************************************************************************
  --03/10/2014
  --procedure: Actualizar_mensaje_empleador
  --Actualiza un mensaje en especifico para un empleador a partir de un id y un registro patronal.
  --Author: Yacell Borges
  --***************************************************************************************************



 PROCEDURE Actualizar_Mensaje_Empleador(p_id_registro_patronal   IN SRE_EMPLEADORES_T.id_registro_patronal%TYPE,
                                        p_id_mensaje             in sre_mensajes_t.id_mensaje%type,
                                        p_usuario                in seg_usuario_t.id_usuario%type,
                                        p_resultnumber           out Varchar2)

   IS

  BEGIN

    update sre_mensajes_t e
       set e.status        = 'L',
           e.fecha_leido   = sysdate,
           e.usuario_leido = p_usuario
     where e.id_registro_patronal = p_id_registro_patronal and e.id_mensaje = p_id_mensaje
     and e.status = 'P' ;

     commit;

    p_resultnumber := '0';

  end;


  --***************************************************************************************************
  --16/10/2014
  --Procedure: Marcar_Mensaje_Archivado
  --Actualiza un mensaje en especifico para un empleador a partir de un id y un registro patronal.
  --Author: Yacell Borges
  --***************************************************************************************************



 PROCEDURE Marcar_Mensaje_Archivado(p_id_registro_patronal   IN SRE_EMPLEADORES_T.id_registro_patronal%TYPE,
                                        p_id_mensaje             in sre_mensajes_t.id_mensaje%type,
                                        p_usuario                in seg_usuario_t.id_usuario%type,
                                        p_resultnumber           out Varchar2)

   IS

  BEGIN

    update sre_mensajes_t e
       set e.status        = 'A',
           e.fecha_leido   = sysdate,
           e.usuario_archivado = p_usuario
     where e.id_registro_patronal = p_id_registro_patronal and e.id_mensaje = p_id_mensaje
     and (e.status = 'P' or e.status='L') ;

  commit;

    p_resultnumber := '0';

  end;



  PROCEDURE Actualizar_Mensaje(p_id_registro_patronal   IN SRE_EMPLEADORES_T.id_registro_patronal%TYPE,
                               p_usuario      in seg_usuario_t.id_usuario%type,
                               p_resultnumber out Varchar2)

   IS

  BEGIN

    update sre_mensajes_t e
       set e.status        = 'L',
           e.fecha_leido   = sysdate,
           e.usuario_leido = p_usuario
     where e.id_registro_patronal = p_id_registro_patronal
     and e.status = 'P' ;

  commit;

    p_resultnumber := '0';

  end;


/*
  --***************************************************************************************************
  --28/11/2014
  --Procedure: ActualizarEmpleador
  --Actualiza el status de los nuevos empleadores registrados en TSS, actualiza el nuevo representante creado,
  -- Actualiza las nuevas nominas creadas
  --Author: Kerlin De La Cruz
  --***************************************************************************************************


 PROCEDURE ActualizarEmpleador (p_id_registro_patronal   IN SRE_EMPLEADORES_T.id_registro_patronal%TYPE,
                                p_usuario                in seg_usuario_t.id_usuario%type,
                                p_resultnumber           out Varchar2)

   IS

   begin

   \*Actualizamos el status del empleador al autorizar la solicitud*\

     update suirplus.sre_empleadores_t e
         set e.status = 'A',
             e.ult_usuario_act = p_usuario
     where e.id_registro_patronal = p_id_registro_patronal;

     \*Actualizamos el status del nuevo usuario creado para dicho empleador*\

     update suirplus.seg_usuario_t u
        set u.status = 'A',
            u.ult_fecha_act = sysdate,
            u.ult_usuario_act = p_usuario
      where u.id_usuario = p_id_registro_patronal;

      \*Actualizamos las nuevas nominas creadas para dicho empleador*\

      update suirplus.sre_nominas_t n
         set n.status = 'A',
             n.ult_fecha_act = sysdate,
             n.ult_usuario_act = p_usuario
       where n.id_registro_patronal = p_id_registro_patronal;

       commit;

     p_resultnumber := '0';

     end;
*/

/*------------------------------------------------------------------------------------------------------*/ 
--Nombre: Procedure que retorna el estatus del empleador como se encuentre en la table de SRE_EMPLEADOR_T
--Autor:  Eury Vallejo
/*------------------------------------------------------------------------------------------------------*/ 

FUNCTION isRncOCedulaRetornarEstatus(p_rnc_o_cedula  SRE_EMPLEADORES_T.rnc_o_cedula%TYPE) return varchar2 is
e_rncInvalido exception;
v_status varchar2(5);
BEGIN
IF suirplus.sre_empleadores_pkg.isRncOCedulaValida(p_rnc_o_cedula) THEN 
SELECT t.Status
INTO v_status
FROM SRE_EMPLEADORES_T t
WHERE t.rnc_o_cedula = p_rnc_o_cedula;

ELSE
 raise e_rncInvalido;
END IF;

return v_status;

Exception
WHEN e_rncInvalido THEN
   return Seg_Retornar_Cadena_Error('WS011', NULL, NULL); 
   
END isRncOCedulaRetornarEstatus;

/*------------------------------------------------------------------------------------------------------*/ 
-- Function: isEmpleadorAlDia
-- Description : Validamos si el empleador esta al dia con respeto a las facturas 
-- By: Kerlin De La Cruz
-- Fecha : 27/07/2017
/*------------------------------------------------------------------------------------------------------*/ 

FUNCTION isEmpleadorAlDia(p_rnc_o_cedula  SRE_EMPLEADORES_T.rnc_o_cedula%TYPE) return varchar2 is
  
e_rncInvalido exception;
v_conteo number;
v_status varchar2(5);
v_reg_patronal suirplus.sre_empleadores_t.id_registro_patronal%type;

BEGIN
  IF suirplus.sre_empleadores_pkg.isRncOCedulaValida(p_rnc_o_cedula) THEN 
        
     select e.id_registro_patronal
       into v_reg_patronal
     from suirplus.sre_empleadores_t e 
     where e.rnc_o_cedula = p_rnc_o_cedula;
     
     select count(*)
      into v_conteo
     from suirplus.sfc_facturas_t f 
     where f.id_registro_patronal = v_reg_patronal 
       and f.status = 'VE'
       and trunc(nvl(f.fecha_limite_acuerdo_pago,fecha_limite_pago)) < trunc(sysdate);
       
  ELSE
   raise e_rncInvalido;
  END IF;
  
  if v_conteo > 0 then
    v_status := 'N';
  else
    v_status := 'S';
  end if;

return v_status;

Exception
WHEN e_rncInvalido THEN
   return Seg_Retornar_Cadena_Error('WS011', NULL, NULL);  
END isEmpleadorAlDia;


END Sre_Empleadores_Pkg;
