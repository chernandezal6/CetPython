CREATE OR REPLACE PACKAGE BODY suirplus.Sre_Ciudadano_Pkg IS

  -- *****************************************************************************************************
  -- program:          SRE_CIUDADANO_PKG
  -- descripcion: Crea Ciudadanos.
  --
  -- modification history
  -- -----------------------------------------------------------------------------------------------------
  -- date                    by                                remark
  -- -----------------------------------------------------------------------------------------------------
  -- 11/29/2004 Elinor Rodriguez     creation
  -- *****************************************************************************************************

  --********************************************************************************************-- 
  --CMHA
  --23/10/2014
  --para registrar si el servicio de webservice JCE esta activo e inactivo.. 
  --********************************************************************************************--
  v_error varchar2(3);

  TYPE t_resultado is record(
    descripcion varchar2(100),
    error       varchar2(3),
    cantidad    number);

  type v_resultado is table of t_resultado index by binary_integer;
  m_resultado v_resultado;

  procedure add_estadistica(p_descripcion varchar2) is
    b_existe boolean := false;
    l_index  binary_integer;
  begin
    If m_resultado.count() = 0 Then
      m_resultado(1).error := v_error;
      m_resultado(1).descripcion := p_descripcion;
      m_resultado(1).cantidad := 1;
    Else
      For r in m_resultado.first .. m_resultado.last loop
        if (m_resultado(r).descripcion = p_descripcion) then
          m_resultado(r).cantidad := m_resultado(r).cantidad + 1;
          b_existe := true;
          exit;
        end if;
      End loop;
    
      If (not b_existe) then
        l_index := m_resultado.count() + 1;
        m_resultado(l_index).error := v_error;
        m_resultado(l_index).descripcion := p_descripcion;
        m_resultado(l_index).cantidad := 1;
      End if;
    end if;
  end;
  ----------------------------------------------------------------------------------
  ----------------------------------------------------------------------------------

  PROCEDURE ciudadano_crear(p_nombres          suirplus.SRE_CIUDADANOS_T.nombres%TYPE,
                            p_primer_apellido  suirplus.SRE_CIUDADANOS_T.primer_apellido%TYPE,
                            p_segundo_apellido suirplus.SRE_CIUDADANOS_T.segundo_apellido%TYPE,
                            p_fecha_nacimiento VARCHAR,
                            p_sexo             suirplus.SRE_CIUDADANOS_T.sexo%TYPE,
                            p_no_documento     suirplus.SRE_CIUDADANOS_T.no_documento%TYPE,
                            p_tipo_documento   suirplus.SRE_CIUDADANOS_T.tipo_documento%TYPE,
                            p_ult_usuario_act  suirplus.SRE_CIUDADANOS_T.ult_usuario_act%TYPE,
                            p_resultnumber     IN OUT VARCHAR)
  
   IS
  
    v_longitud        VARCHAR(500);
    v_idnss           VARCHAR(20);
    v_fechanacimiento VARCHAR(10);
    v_existeciudadano VARCHAR(100); 
    e_ciudadanoeexiste exception;
  
    CURSOR c_existeciudadano IS
      SELECT c.no_documento
        FROM suirplus.SRE_CIUDADANOS_T c
       WHERE c.no_documento = p_no_documento;
  
  BEGIN
  
    OPEN c_existeciudadano;
    FETCH c_existeciudadano
      INTO v_existeciudadano;
    IF c_existeciudadano%FOUND THEN
      CLOSE c_existeciudadano;
      RAISE e_ciudadanoeexiste;
    ELSE
      CLOSE c_existeciudadano;
    END IF;
  
     IF (p_tipo_documento = 'P') and ((LENGTH(P_NO_DOCUMENTO)) = 25) or
       ((LENGTH(P_NO_DOCUMENTO)) = 25) THEN
      RAISE e_no9no11;
    END IF;
  
    IF NOT p_ult_usuario_act IS NULL AND
       NOT suirplus.Seg_Usuarios_Pkg.isexisteusuario(p_ult_usuario_act) THEN
      RAISE e_invaliduser;
    END IF;
  
    IF (LENGTH(P_NOMBRES)) >
       (Seg_Get_Largo_Columna('SRE_CIUDADANOS_T', 'NOMBRES')) THEN
      v_longitud := 'Nombres';
      RAISE e_excedelogintud;
    END IF;
    IF (LENGTH(P_PRIMER_APELLIDO)) >
       (Seg_Get_Largo_Columna('SRE_CIUDADANOS_T', 'PRIMER_APELLIDO')) THEN
      v_longitud := 'Primer Apellido';
      RAISE e_excedelogintud;
    END IF;
    IF (LENGTH(P_SEGUNDO_APELLIDO)) >
       (Seg_Get_Largo_Columna('SRE_CIUDADANOS_T', 'SEGUNDO_APELLIDO')) THEN
      v_longitud := 'Segundo Apellido';
      RAISE e_excedelogintud;
    END IF;
  
    IF (LENGTH(P_NO_DOCUMENTO)) >
       (Seg_Get_Largo_Columna('SRE_CIUDADANOS_T', 'NO_DOCUMENTO')) THEN
      v_longitud := 'Numero Documento';
      RAISE e_excedelogintud;
    END IF;
	
    SELECT TO_DATE(p_fecha_nacimiento, 'DD/MM/YYYY')
      INTO v_fechanacimiento
      FROM dual;
  
    -- insertamos los datos del Ciudadano.
    INSERT INTO suirplus.SRE_CIUDADANOS_T
      (nombres,
       primer_apellido,
       segundo_apellido,
       fecha_nacimiento,
       no_documento,
       tipo_documento,
       sexo,
       ult_fecha_act,
       ult_usuario_act)
    VALUES
      (UPPER(p_nombres),
       UPPER(p_primer_apellido),
       UPPER(p_segundo_apellido),
       v_fechanacimiento,
       p_no_documento,
       p_tipo_documento,
       p_sexo,
       SYSDATE,
       p_ult_usuario_act);
  
    p_resultnumber := 0 || '|' || v_idnss;
    COMMIT;
   
  
  EXCEPTION
    WHEN e_no9no11 THEN
      p_resultnumber := suirplus.Seg_Retornar_Cadena_Error(61, NULL, NULL) || '' ||
                        v_longitud;
      RETURN;
    WHEN e_excedelogintud THEN
      p_resultnumber := suirplus.Seg_Retornar_Cadena_Error(15, NULL, NULL) || '' ||
                        v_longitud;
      RETURN;
    WHEN e_ciudadanoeexiste THEN
      p_resultnumber := suirplus.Seg_Retornar_Cadena_Error(23, NULL, NULL);
      RETURN;
    WHEN e_invaliduser THEN
      p_resultnumber := suirplus.Seg_Retornar_Cadena_Error(1, NULL, NULL);
      RETURN;
    WHEN OTHERS THEN
      v_bderror      := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultnumber := suirplus.Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
      RETURN;
  END;

--********************************************************************************
--ciudadano_tutor_crear
--para crear un nuevo tipo de ciudadano titular por excepcion para estancias infantiles 
--by Charlie pena
--*********************************************************************************
  PROCEDURE ciudadano_titular_crear(p_nombres    suirplus.SRE_EMPLEADORES_T.RAZON_SOCIAL%TYPE,
                            p_nombre_padre       suirplus.SRE_EMPLEADORES_T.RNC_O_CEDULA%TYPE,
                            p_ult_usuario_act    suirplus.SRE_CIUDADANOS_T.ult_usuario_act%TYPE,
                            p_resultnumber       IN OUT VARCHAR)
  
   IS
  
    v_longitud        VARCHAR(500);
    v_idnss           number(10);
    v_existeRNC       integer;
    v_fechanacimiento date;
    v_existeciudadano VARCHAR(100); 
    e_centroExiste    exception;
    e_no9no11         exception;
  
  BEGIN

    IF (LENGTH(P_NOMBRES)) >
       (Seg_Get_Largo_Columna('SRE_CIUDADANOS_T', 'NOMBRES')) THEN
      v_longitud := 'Nombres';
      RAISE e_excedelogintud;
    END IF;
    
/*    if ((length(trim(p_nombre_padre)))= 9 or (length(trim(p_nombre_padre)))= 11) then
       select count(*) into v_existeRNC from sre_ciudadanos_t c 
       where c.nombre_padre = p_nombre_padre and c.tipo_documento='T' and c.status='A'; 
         if v_existeRNC > 0 then
            raise e_centroExiste;
         end if;
    else
         raise e_no9no11;
    end if;*/
  
    IF NOT p_ult_usuario_act IS NULL AND
       NOT suirplus.Seg_Usuarios_Pkg.isexisteusuario(p_ult_usuario_act) THEN
      RAISE e_invaliduser;
    END IF;
  
    SELECT TO_DATE('01-JAN-1970') into v_fechanacimiento FROM DUAL;  
 
    -- insertamos los datos del Ciudadano.
    INSERT INTO suirplus.SRE_CIUDADANOS_T
      (nombres,
       primer_apellido,
       fecha_nacimiento,
       tipo_documento,
       sexo,
       status,      
       nombre_padre,
       ult_fecha_act,
       ult_usuario_act)
    VALUES
      (UPPER(trim(p_nombres)),
       UPPER(trim(p_nombres)),
       v_fechanacimiento,
       'T',
       'M',
       'A',
       UPPER(trim(p_nombre_padre)),       
       SYSDATE,
       p_ult_usuario_act)
        
       returning id_nss into v_idnss;
    COMMIT;    
    
    --insertamos el no_documento del nuevo ciudadano que es igual al nss generado
    update suirplus.sre_ciudadanos_t c
           set c.no_documento = v_idnss
           where c.id_nss = v_idnss;
    commit;
    --RETURN;
      p_resultnumber := 0;

  EXCEPTION
    WHEN e_no9no11 THEN
      p_resultnumber := suirplus.Seg_Retornar_Cadena_Error(61, NULL, NULL) || '' ||
                        v_longitud;
      RETURN;
    WHEN e_excedelogintud THEN
      p_resultnumber := suirplus.Seg_Retornar_Cadena_Error(15, NULL, NULL) || '' ||
                        v_longitud;
      RETURN;
    WHEN e_centroExiste THEN
      p_resultnumber := suirplus.Seg_Retornar_Cadena_Error(23, NULL, NULL);
      RETURN;
    WHEN e_invaliduser THEN
      p_resultnumber := suirplus.Seg_Retornar_Cadena_Error(1, NULL, NULL);
      RETURN;
    WHEN OTHERS THEN
      v_bderror      := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultnumber := suirplus.Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
      RETURN;
  END;
--********************
  --***********************************************************************************************
  -- Procedimiento que Verifica si el Ciudadano Existe.
  --***********************************************************************************************

  PROCEDURE verificar_ciudadano_existe(p_numerodocumento IN suirplus.SRE_CIUDADANOS_T.no_documento%TYPE,
                                       p_tipodocumento   IN suirplus.SRE_CIUDADANOS_T.tipo_documento%TYPE,
                                       p_nombres         OUT suirplus.SRE_CIUDADANOS_T.nombres%TYPE,
                                       p_apellidos       OUT VARCHAR,
                                       p_nss             OUT suirplus.SRE_CIUDADANOS_T.id_nss%TYPE,
                                       p_resultnumber    OUT VARCHAR)
  
   IS
  
    CURSOR c_ExisteCedula IS
      SELECT no_documento
        FROM suirplus.SRE_CIUDADANOS_T
       WHERE no_documento = p_NumeroDocumento
         AND tipo_documento = 'C';
    CURSOR c_ExistePasaporte IS
      SELECT NO_DOCUMENTO
        FROM suirplus.SRE_CIUDADANOS_T
       WHERE NO_DOCUMENTO = p_NumeroDocumento
         AND tipo_documento = 'P';
  
    v_tmpCedula VARCHAR(25);
  
  BEGIN
  
    IF p_TipoDocumento = 'C' THEN
      OPEN c_ExisteCedula;
      FETCH c_ExisteCedula
        INTO v_tmpCedula;
    
      IF c_ExisteCedula%FOUND THEN
      
        SELECT c.NOMBRES,
               c.PRIMER_APELLIDO || ' ' || c.SEGUNDO_APELLIDO,
               c.ID_NSS
          INTO p_Nombres, p_Apellidos, p_NSS
          FROM suirplus.SRE_CIUDADANOS_T c
         WHERE c.no_documento = p_NumeroDocumento; --and c.id_causa_inhabilidad
        
        CLOSE c_ExisteCedula;
        p_ResultNumber := 0;
        RETURN;
      ELSE
        CLOSE c_ExisteCedula;
        p_ResultNumber := suirplus.Seg_Retornar_Cadena_Error(14, NULL, NULL);
        RETURN;
      END IF;
    
    ELSIF p_TipoDocumento = 'P' THEN
      OPEN c_ExistePasaporte;
      FETCH c_ExistePasaporte
        INTO v_tmpCedula;
      IF c_ExistePasaporte%FOUND THEN
        SELECT NOMBRES, PRIMER_APELLIDO || ' ' || SEGUNDO_APELLIDO, ID_NSS
          INTO p_Nombres, p_Apellidos, p_NSS
          FROM suirplus.SRE_CIUDADANOS_T
         WHERE NO_DOCUMENTO = p_NumeroDocumento; --and c.id_causa_inhabilida
        
        CLOSE c_ExistePasaporte;
        p_ResultNumber := 0;
        RETURN;
      ELSE
        CLOSE c_ExistePasaporte;
        p_ResultNumber := suirplus.Seg_Retornar_Cadena_Error(14, NULL, NULL);
        RETURN;
      END IF;
   /* ELSE
      p_ResultNumber := suirplus.Seg_Retornar_Cadena_Error(13, NULL, NULL);*/
    END IF;
  
  END;

  /******************************************************************************/
  -- Procedimiento: IsExisteCiudadano
  -- Descripcion:   Validar si el ciudadano existe
  -- Creado por:    Gregorio Herrera
  /******************************************************************************/
  PROCEDURE IsExisteCiudadano(p_nrodocumento  IN suirplus.SRE_CIUDADANOS_T.no_documento%TYPE,
                              p_tipodocumento IN suirplus.SRE_CIUDADANOS_T.tipo_documento%TYPE,
                              p_resultnumber  OUT VARCHAR) IS
  
    v_idNss sre_ciudadanos_t.id_nss%type;
  
  BEGIN
    If p_TipoDocumento = 'C' Then
      v_idNss := null;
      /*Cursor para buscar la cedula*/
      For c_Ciudadano in (select id_nss
                            from suirplus.sre_ciudadanos_t
                           where no_documento = p_nrodocumento
                             and tipo_documento = p_tipodocumento) Loop
        v_idNss := c_Ciudadano.id_nss;
      End loop;
    
      If v_idNss is null Then
        p_ResultNumber := 0;
        Return;
      Else
        p_ResultNumber := 1;
      End if;
    Elsif p_TipoDocumento = 'P' THEN
      v_idNss := null;
      /*Cursor para buscar el pasaporte*/
      For c_Ciudadano in (select id_nss
                            from suirplus.sre_ciudadanos_t
                           where no_documento = p_nrodocumento
                             and tipo_documento = p_tipodocumento) Loop
        v_idNss := c_Ciudadano.id_nss;
      End loop;
    
      If v_idNss is null Then
        p_ResultNumber := 0;
        Return;
      Else
        p_ResultNumber := 1;
      End if;
    Elsif p_TipoDocumento = 'U' THEN
      v_idNss := null;
      /*Cursor para buscar los menores*/
      For c_Ciudadano in (select id_nss
                            from suirplus.sre_ciudadanos_t
                           where no_documento = p_nrodocumento) Loop
        v_idNss := c_Ciudadano.id_nss;
      End loop;
    
      If v_idNss is null Then
        p_ResultNumber := 0;
        Return;
      Else
        p_ResultNumber := 1;
      End if;
    End if;
  END;

  --/////////////////////evaluando procedimiento que estaba fuera de este paquete--*

  PROCEDURE SRE_VERIFICAR_CIUDADANO_EXISTE(p_NumeroDocumento IN suirplus.SRE_CIUDADANOS_T.no_documento%TYPE,
                                           p_TipoDocumento   IN suirplus.SRE_CIUDADANOS_T.tipo_documento%TYPE,
                                           p_Nombres         OUT suirplus.SRE_CIUDADANOS_T.nombres%TYPE,
                                           p_Apellidos       OUT VARCHAR,
                                           p_NSS             OUT suirplus.SRE_CIUDADANOS_T.id_nss%TYPE,
                                           p_ResultNumber    OUT VARCHAR)
  
   IS
  
    CURSOR c_ExisteCedula IS
      SELECT no_documento
        FROM suirplus.SRE_CIUDADANOS_T
       WHERE no_documento = p_NumeroDocumento
         AND tipo_documento = 'C';
    CURSOR c_ExistePasaporte IS
      SELECT NO_DOCUMENTO
        FROM suirplus.SRE_CIUDADANOS_T
       WHERE NO_DOCUMENTO = p_NumeroDocumento
         AND tipo_documento = 'P';
    v_tmpCedula VARCHAR(25);
  
  BEGIN
  
    IF p_TipoDocumento = 'C' THEN
      OPEN c_ExisteCedula;
      FETCH c_ExisteCedula
        INTO v_tmpCedula;
    
      IF c_ExisteCedula%FOUND THEN
      
        SELECT NOMBRES, PRIMER_APELLIDO || ' ' || SEGUNDO_APELLIDO, ID_NSS
          INTO p_Nombres, p_Apellidos, p_NSS
          FROM suirplus.SRE_CIUDADANOS_T
         WHERE TIPO_CAUSA <> 'C'
           AND no_documento = p_NumeroDocumento;
        CLOSE c_ExisteCedula;
        p_ResultNumber := 0;
        RETURN;
      ELSE
        CLOSE c_ExisteCedula;
        p_ResultNumber := suirplus.Seg_Retornar_Cadena_Error(14, NULL, NULL);
        RETURN;
      END IF;
    
    ELSIF p_TipoDocumento = 'P' THEN
      OPEN c_ExistePasaporte;
      FETCH c_ExistePasaporte
        INTO v_tmpCedula;
      IF c_ExistePasaporte%FOUND THEN
        SELECT NOMBRES, PRIMER_APELLIDO || ' ' || SEGUNDO_APELLIDO, ID_NSS
          INTO p_Nombres, p_Apellidos, p_NSS
          FROM suirplus.SRE_CIUDADANOS_T
         WHERE TIPO_CAUSA <> 'C'
           AND NO_DOCUMENTO = p_NumeroDocumento;
        CLOSE c_ExistePasaporte;
        p_ResultNumber := 0;
        RETURN;
      ELSE
        CLOSE c_ExistePasaporte;
        p_ResultNumber := suirplus.Seg_Retornar_Cadena_Error(14, NULL, NULL);
        RETURN;
      END IF;
    ELSE
      p_ResultNumber := suirplus.Seg_Retornar_Cadena_Error(13, NULL, NULL);
    END IF;
  
  END;
  --***************************************************************************************
  FUNCTION CancelacionCedula(p_NumeroDocumento IN suirplus.SRE_CIUDADANOS_T.no_documento%TYPE,
                             p_ResultNumber    OUT VARCHAR) RETURN VARCHAR2 IS
  
    v_causatipo       VARCHAR(50);
    v_cancelaciondesc VARCHAR(200);
  
  BEGIN
  
    SELECT c.tipo_causa, i.cancelacion_des
      INTO v_causatipo, v_cancelaciondesc
      FROM suirplus.SRE_CIUDADANOS_T c, suirplus.SRE_INHABILIDAD_JCE_T i
     WHERE c.id_causa_inhabilidad = i.id_causa_inhabilidad(+)
       AND c.no_documento = p_NumeroDocumento;
  
    IF (v_causatipo = 'C') OR (v_causatipo = 'I') THEN
      p_ResultNumber := v_causatipo;
      RETURN p_ResultNumber;
    ELSE
      p_ResultNumber := 0;
      RETURN p_ResultNumber;
    END IF;
  
  END CancelacionCedula;
  --**************************************************************************************
  FUNCTION CancelacionCedulaDesc(p_NumeroDocumento IN suirplus.SRE_CIUDADANOS_T.no_documento%TYPE,
                                 p_ResultNumber    OUT VARCHAR)
    RETURN VARCHAR2 IS
  
    v_causatipo       VARCHAR(50);
    v_cancelaciondesc VARCHAR(200);
  
  BEGIN
  
    SELECT c.tipo_causa, i.cancelacion_des
      INTO v_causatipo, v_cancelaciondesc
      FROM suirplus.SRE_CIUDADANOS_T c, suirplus.SRE_INHABILIDAD_JCE_T i
     WHERE c.id_causa_inhabilidad = i.id_causa_inhabilidad(+)
       AND c.no_documento = p_NumeroDocumento;
  
    IF (v_causatipo = 'C') OR (v_causatipo = 'I') THEN
      p_ResultNumber := v_cancelaciondesc;
      RETURN p_ResultNumber;
    ELSE
      p_ResultNumber := 0;
      RETURN p_ResultNumber;
    END IF;
  
  END CancelacionCedulaDesc;
  ---------------------------------------------------
  -- funcion para determinar si el Ciudadano extrangero
  -- ya existe en la tabla de Ciudadanos.
  -- FR 16/04/2009
  --------------------------------------------------
  function ExisteCiudadanoExtrangero(p_nombres        in suirplus.sre_ciudadanos_t.nombres%type,
                                     p_primerapellido in suirplus.sre_ciudadanos_t.primer_apellido%type,
                                     p_fechanac       in suirplus.sre_ciudadanos_t.fecha_nacimiento%type)
    return boolean is
    v_existe integer;
  begin
    select count(*)
      into v_existe
      from suirplus.sre_ciudadanos_t c
     where c.nombres = upper(p_nombres)
       and c.primer_apellido = upper(p_primerapellido)
       and c.tipo_causa <> 'C'
       and c.fecha_nacimiento = p_fechanac;
  
    if (v_existe > 0) then
      return true;
    end if;
    return false;
  end existeciudadanoextrangero;
  ---------------------------------------------------------------
  -- procedimiento para crear ciudadanos extrangeros.
  -- cha 16/04/2009
  ----------------------------------------------------------------
  procedure RegistroMenorExtranjero(p_nombres          in suirplus.sre_ciudadanos_t.nombres%type,
                                    p_primer_apellido  in suirplus.sre_ciudadanos_t.primer_apellido%type,
                                    p_segundo_apellido in suirplus.sre_ciudadanos_t.primer_apellido%type,
                                    p_fecha_nacimiento in suirplus.sre_ciudadanos_t.fecha_nacimiento%type,
                                    p_sexo             in suirplus.sre_ciudadanos_t.sexo%TYPE,
                                    p_id_nacionalidad  in suirplus.sre_ciudadanos_t.id_nacionalidad%type,
                                    p_nss_titular      in suirplus.sre_menores_ext_t.nss_titular%type,
                                    p_ult_usuario_act  in suirplus.sre_ciudadanos_t.ult_usuario_act%type,
                                    p_ImagenActa       in suirplus.sre_ciudadanos_t.imagen_acta%type,
                                    p_resultnumber     out varchar2) is
    e_ExisteCiudadano exception;
    e_longitud exception;
    e_usuarioinvalido exception;
    e_titular exception;
    v_longitud varchar(500);
    v_id_nss   number(10);
    v_ars      number;
  begin
    -- Verificar si el ciudadano que se esta agregando ya existe
    if ExisteCiudadanoExtrangero(p_nombres,
                                 p_primer_apellido,
                                 p_fecha_nacimiento) then
      raise e_ExisteCiudadano;
    end if;
  
    -- Verificar si el usuario que esta registrando existe
    if (p_nombres is not null) and (p_primer_apellido is not null) and
       (p_fecha_nacimiento is not null) and (p_sexo is not null) and
       (p_id_nacionalidad is not null) then
      if not p_ult_usuario_act is null and
         not suirplus.seg_usuarios_pkg.isexisteusuario(p_ult_usuario_act) then
        raise e_usuarioinvalido;
      end if;
    end if;
  
    --Verificar que el titular este en la la vista diaria de cobertura de unipago, tomar ARS de esta tabla,
    --si no existe registro, retornar error.
    Begin
      select ti.ars
        into v_ars
        from suirplus.tss_titulares_ars_ok_pe_mv ti
       where ti.nss = p_nss_titular
         and ti.c_status = 'AC';
    Exception
      when others Then
        raise e_titular;
    End;
  
    --- Agregar en Ciudadano
    insert into suirplus.sre_ciudadanos_t
      (nombres,
       primer_apellido,
       segundo_apellido,
       fecha_nacimiento,
       sexo,
       id_nacionalidad,
       ult_usuario_act,
       imagen_acta,
       tipo_documento,
       no_documento,
       estado_civil)
    values
      (p_nombres,
       p_primer_apellido,
       p_segundo_apellido,
       p_fecha_nacimiento,
       p_sexo,
       p_id_nacionalidad,
       p_ult_usuario_act,
       p_imagenacta,
       'E',
       null,
       'S')
    Returning id_nss into v_id_nss;
  
    --Insertar en tabla intermedia
    insert into suirplus.sre_menores_ext_t
      (NOMBRES,
       PRIMER_APELLIDO,
       SEGUNDO_APELLIDO,
       FECHA_NACIMIENTO,
       SEXO,
       ID_NACIONALIDAD,
       NSS_TITULAR,
       ID_ARS_REGISTRO,
       FECHA_REGISTRO,
       USUARIO_REGISTRO,
       IMAGEN_ACTA,
       ID_NSS)
    values
      (p_nombres,
       p_primer_apellido,
       p_segundo_apellido,
       p_fecha_nacimiento,
       p_sexo,
       p_id_nacionalidad,
       p_nss_titular,
       v_ARS,
       sysdate,
       p_ult_usuario_act,
       p_imagenacta,
       v_id_nss);
  
    --Insertar en tabla unipago
    insert into unipago.sre_menores_ext_t
      (NOMBRES,
       PRIMER_APELLIDO,
       SEGUNDO_APELLIDO,
       FECHA_NACIMIENTO,
       SEXO,
       ID_NACIONALIDAD,
       NSS_TITULAR,
       ID_ARS_REGISTRO,
       FECHA_REGISTRO,
       USUARIO_REGISTRO,
       IMAGEN_ACTA,
       ID_NSS)
    values
      (p_nombres,
       p_primer_apellido,
       p_segundo_apellido,
       p_fecha_nacimiento,
       p_sexo,
       p_id_nacionalidad,
       p_nss_titular,
       v_ARS,
       sysdate,
       p_ult_usuario_act,
       p_imagenacta,
       v_id_nss);
  
    commit;
    p_resultnumber := '0';
  exception
    when e_ExisteCiudadano then
      p_resultnumber := suirplus.Seg_Retornar_Cadena_Error(23, NULL, NULL);
    when e_usuarioinvalido then
      p_resultnumber := suirplus.Seg_Retornar_Cadena_Error(1, NULL, NULL);
    when e_titular then
      p_resultnumber := suirplus.Seg_Retornar_Cadena_Error(703, NULL, NULL);
    when others then
      v_bderror      := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultnumber := suirplus.Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
    
  end RegistroMenorExtranjero;

  ------------------------------------------------------
  -- procedimiento para obtener los menores extrangeres.
  --FR 16/04/2009
  ------------------------------------------------------
  procedure ObtenerMenorExtranjero(p_nombres          in suirplus.sre_ciudadanos_t.nombres%type,
                                   p_primer_apellido  in suirplus.sre_ciudadanos_t.primer_apellido%type,
                                   p_segundo_apellido in suirplus.sre_ciudadanos_t.primer_apellido%type,
                                   p_io_cursor        out t_cursor,
                                   p_result_number    IN OUT VARCHAR) is
  
  begin
    open p_io_cursor for
      select t.id_nss,
             t.nombres,
             t.primer_apellido,
             t.segundo_apellido,
             t.fecha_nacimiento
        from suirplus.sre_ciudadanos_t t
       where t.nombres = p_nombres
         and t.primer_apellido = p_primer_apellido
         and t.segundo_apellido = p_segundo_apellido
         and t.no_documento is null
         and t.tipo_documento = 'E';
  
  EXCEPTION
  
    WHEN OTHERS THEN
      v_bderror       := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                 SQLERRM,
                                 1,
                                 255));
      p_result_number := suirplus.Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
      RETURN;
  end;

  --***************************************************************************************
  PROCEDURE P_CancelacionCedula(p_NumeroDocumento IN suirplus.SRE_CIUDADANOS_T.no_documento%TYPE,
                                p_ResultNumber    OUT VARCHAR)
  
   IS
    v_causatipo       VARCHAR(50);
    v_cancelaciondesc VARCHAR(200);
  
  BEGIN
  
    SELECT c.tipo_causa, i.cancelacion_des
      INTO v_causatipo, v_cancelaciondesc
      FROM suirplus.SRE_CIUDADANOS_T c, suirplus.SRE_INHABILIDAD_JCE_T i
     WHERE c.id_causa_inhabilidad = i.id_causa_inhabilidad(+)
       AND c.no_documento = p_NumeroDocumento;
  
    IF (v_causatipo = 'C') OR (v_causatipo = 'I') THEN
      p_ResultNumber := v_causatipo;
    ELSE
      p_ResultNumber := 0;
    END IF;
    RETURN;
  
  END;
  --********************************************************************
  --
  --********************************************************************
  PROCEDURE CedulaCancelada(p_NumeroDocumento IN suirplus.SRE_CIUDADANOS_T.no_documento%TYPE,
                            io_cursor         OUT t_cursor)
  
   IS
    v_cursor t_cursor;
  
  BEGIN
    OPEN v_cursor FOR
    
      SELECT nvl(c.TIPO_CAUSA, 'H') AS tipo_causa, i.cancelacion_des
        FROM suirplus.SRE_CIUDADANOS_T c, suirplus.SRE_INHABILIDAD_JCE_T i
       WHERE c.id_causa_inhabilidad = i.id_causa_inhabilidad(+)
         AND c.no_documento = p_NumeroDocumento
         AND c.tipo_documento = 'C';
    io_cursor := v_cursor;
    RETURN;
  
  END;
  /*
  PROCEDURE CancelacionCedulaDesc(p_NumeroDocumento                    IN  SRE_CIUDADANOS_T.no_documento%TYPE,
                              p_ResultNumber                           OUT VARCHAR)
  
  
  
  
   IS
  v_causatipo varchar(50);
  v_cancelaciondesc varchar(200);
  
   BEGIN
  
  
      select c.tipo_causa, i.cancelacion_des into v_causatipo, v_cancelaciondesc from sre_ciudadanos_t c , sre_inhabilidad_jce_t i
      where c.id_causa_inhabilidad = i.id_causa_inhabilidad(+)
      and c.no_documento = p_NumeroDocumento;
  
     if (v_causatipo = 'C') or (v_causatipo = 'I')  then
      p_ResultNumber:= v_cancelaciondesc;
     else
      p_ResultNumber:= 0;
     end if;
     RETURN;
  
  
   END;*/
  --***************************************************************************************

  --///////////////////////////////////////////////////////// Consulta NSS ////////////////////////////////////
  --//////////////////////////////////////////////////////////////////////////////////////////////////////////
  PROCEDURE Consulta_Nss(p_no_documento     IN suirplus.SRE_CIUDADANOS_T.no_documento%TYPE,
                         p_id_nss           IN VARCHAR2,
                         p_nombres          IN suirplus.SRE_CIUDADANOS_T.nombres%TYPE,
                         p_primer_apellido  IN suirplus.SRE_CIUDADANOS_T.primer_apellido%TYPE,
                         p_segundo_apellido IN suirplus.SRE_CIUDADANOS_T.segundo_apellido%TYPE,
                         p_ResultNumber     OUT VARCHAR,
                         io_cursor          OUT t_cursor)
  
   IS
    v_cursor           t_cursor;
    v_numerodocumento  VARCHAR2(20);
    condicion          VARCHAR2(2);
    condiciondesc      VARCHAR2(200);
    var                VARCHAR2(200);
    V_NOMBRES          suirplus.SRE_CIUDADANOS_T.nombres%TYPE;
    V_PRIMER_APELLIDO  suirplus.SRE_CIUDADANOS_T.primer_apellido%TYPE;
    V_SEGUNDO_APELLIDO suirplus.SRE_CIUDADANOS_T.segundo_apellido%TYPE;
  
  BEGIN
  
    V_NOMBRES          := upper(p_nombres);
    V_PRIMER_APELLIDO  := upper(p_primer_apellido);
    V_SEGUNDO_APELLIDO := upper(p_segundo_apellido);
  
    IF (p_no_documento IS NOT NULL) THEN
      OPEN v_cursor FOR
      
        SELECT c.id_nss,
               c.no_documento,
               InitCap(c.nombres) nombres,
               InitCap(c.primer_apellido || ' ' || c.segundo_apellido) AS apellidos,
               c.fecha_nacimiento,
               c.TIPO_DOCUMENTO
          FROM suirplus.SRE_CIUDADANOS_T c
         WHERE c.no_documento = p_no_documento
           AND c.tipo_documento = 'C'
         ORDER BY c.primer_apellido,
                  c.segundo_apellido,
                  c.nombres,
                  c.fecha_nacimiento;
    
      io_cursor := v_cursor;
      RETURN;
    ELSIF (p_id_nss IS NOT NULL) THEN
      OPEN v_cursor FOR
      
        SELECT c.id_nss,
               c.no_documento,
               InitCap(c.nombres) nombres,
               InitCap(c.primer_apellido || ' ' || c.segundo_apellido) AS apellidos,
               c.fecha_nacimiento,
               c.TIPO_DOCUMENTO
          FROM suirplus.SRE_CIUDADANOS_T c
         WHERE c.id_nss = p_id_nss
           AND c.tipo_documento = 'C'
         ORDER BY c.primer_apellido,
                  c.segundo_apellido,
                  c.nombres,
                  c.fecha_nacimiento;
    
      io_cursor := v_cursor;
      RETURN;
    ELSIF (p_nombres IS NOT NULL) AND (p_primer_apellido IS NOT NULL) AND
          (p_segundo_apellido IS NOT NULL) THEN
    
      OPEN v_cursor FOR
        SELECT c.id_nss,
               c.no_documento,
               InitCap(c.nombres) nombres,
               InitCap(c.primer_apellido || ' ' || c.segundo_apellido) AS apellidos,
               c.fecha_nacimiento,
               c.TIPO_DOCUMENTO
          FROM suirplus.SRE_CIUDADANOS_T c
         WHERE c.nombres LIKE V_NOMBRES || '%'
           AND c.primer_apellido LIKE V_PRIMER_APELLIDO || '%'
           AND c.segundo_apellido LIKE V_SEGUNDO_APELLIDO || '%'
           AND c.tipo_documento = 'C'
         ORDER BY c.primer_apellido,
                  c.segundo_apellido,
                  c.nombres,
                  c.fecha_nacimiento;
    
      io_cursor := v_cursor;
      RETURN;
    
    ELSIF (p_nombres IS NOT NULL) AND (p_primer_apellido IS NOT NULL) THEN
    
      OPEN v_cursor FOR
        SELECT c.id_nss,
               c.no_documento,
               InitCap(c.nombres) nombres,
               InitCap(c.primer_apellido || ' ' || c.segundo_apellido) AS apellidos,
               c.fecha_nacimiento
          FROM suirplus.SRE_CIUDADANOS_T c
         WHERE c.nombres LIKE V_NOMBRES || '%'
           AND c.primer_apellido LIKE V_PRIMER_APELLIDO || '%'
           AND c.tipo_documento = 'C'
         ORDER BY c.primer_apellido,
                  c.segundo_apellido,
                  c.nombres,
                  c.fecha_nacimiento;
    
      io_cursor := v_cursor;
      RETURN;
    ELSIF (p_nombres IS NOT NULL) AND (p_segundo_apellido IS NOT NULL) THEN
    
      OPEN v_cursor FOR
        SELECT c.id_nss,
               c.no_documento,
               InitCap(c.nombres),
               InitCap(c.primer_apellido || ' ' || c.segundo_apellido) AS apellidos,
               c.fecha_nacimiento
          FROM suirplus.SRE_CIUDADANOS_T c
         WHERE c.nombres LIKE V_NOMBRES || '%'
           AND c.segundo_apellido LIKE V_SEGUNDO_APELLIDO || '%'
           AND c.tipo_documento = 'C'
         ORDER BY c.primer_apellido,
                  c.segundo_apellido,
                  c.nombres,
                  c.fecha_nacimiento;
    
      io_cursor := v_cursor;
      RETURN;
    ELSIF (p_primer_apellido IS NOT NULL) AND
          (p_segundo_apellido IS NOT NULL) THEN
    
      OPEN v_cursor FOR
        SELECT c.id_nss,
               c.no_documento,
               InitCap(c.nombres) nombres,
               InitCap(c.primer_apellido || ' ' || c.segundo_apellido) AS apellidos,
               c.fecha_nacimiento
          FROM suirplus.SRE_CIUDADANOS_T c
         WHERE c.primer_apellido LIKE V_PRIMER_APELLIDO || '%'
           AND c.segundo_apellido LIKE V_SEGUNDO_APELLIDO || '%'
           AND c.tipo_documento = 'C'
         ORDER BY c.primer_apellido,
                  c.segundo_apellido,
                  c.nombres,
                  c.fecha_nacimiento;
    
      io_cursor := v_cursor;
      RETURN;
    ELSIF (p_nombres IS NOT NULL) THEN
      OPEN v_cursor FOR
        SELECT c.id_nss,
               c.no_documento,
               InitCap(c.nombres) nombres,
               InitCap(c.primer_apellido || ' ' || c.segundo_apellido) AS apellidos,
               c.fecha_nacimiento
          FROM suirplus.SRE_CIUDADANOS_T c
         WHERE c.nombres LIKE V_NOMBRES || '%'
           AND c.tipo_documento = 'C'
         ORDER BY c.primer_apellido,
                  c.segundo_apellido,
                  c.nombres,
                  c.fecha_nacimiento;
    
      io_cursor := v_cursor;
      RETURN;
    ELSIF (p_primer_apellido IS NOT NULL) THEN
    
      OPEN v_cursor FOR
        SELECT c.id_nss,
               c.no_documento,
               InitCap(c.nombres),
               InitCap(c.primer_apellido || ' ' || c.segundo_apellido) AS apellidos,
               c.fecha_nacimiento
          FROM suirplus.SRE_CIUDADANOS_T c
         WHERE c.primer_apellido LIKE V_PRIMER_APELLIDO || '%'
           AND c.tipo_documento = 'C'
         ORDER BY c.primer_apellido,
                  c.segundo_apellido,
                  c.nombres,
                  c.fecha_nacimiento;
    
      io_cursor := v_cursor;
      RETURN;
    ELSIF (p_segundo_apellido IS NOT NULL) THEN
      OPEN v_cursor FOR
        SELECT c.id_nss,
               c.no_documento,
               InitCap(c.nombres) nombres,
               InitCap(c.primer_apellido || ' ' || c.segundo_apellido) AS apellidos,
               c.fecha_nacimiento
          FROM suirplus.SRE_CIUDADANOS_T c
         WHERE c.segundo_apellido LIKE V_SEGUNDO_APELLIDO || '%'
           AND c.tipo_documento = 'C'
         ORDER BY c.primer_apellido,
                  c.segundo_apellido,
                  c.nombres,
                  c.fecha_nacimiento;
    
      io_cursor := v_cursor;
      RETURN;
    END IF;
  
  END;

  function Get_Nombres(p_id_nss in number) return varchar2 is
    mNombre varchar2(250);
  begin
    begin
      select initcap(trim(c.nombres || ' ' || c.primer_apellido || ' ' ||
                          c.segundo_apellido))
        into mNombre
        from suirplus.sre_ciudadanos_t c
       where c.id_nss = p_id_nss;
    exception
      when no_data_found then
        mNombre := 'El NSS especificado no existe';
    end;
    return mNombre;
  end;

  PROCEDURE pageConsulta_Nss(p_no_documento     in suirplus.sre_ciudadanos_t.no_documento%TYPE,
                             p_id_nss           in suirplus.sre_ciudadanos_t.id_nss%type,
                             p_nombres          in suirplus.sre_ciudadanos_t.nombres%TYPE,
                             p_primer_apellido  in suirplus.sre_ciudadanos_t.primer_apellido%TYPE,
                             p_segundo_apellido in suirplus.sre_ciudadanos_t.segundo_apellido%TYPE,
                             p_ResultNumber     OUT VARCHAR,
                             p_pagenum          in number,
                             p_pagesize         in number,
                             io_cursor          out t_cursor) is
    qry    varchar2(32000);
    con    varchar2(10) := ' where ';
    vDesde integer := (p_pagesize * (p_pagenum - 1)) + 1;
    vhasta integer := p_pagesize * p_pagenum;
    vMadre varchar2(2);
  BEGIN
    if p_no_documento is null and p_id_nss is null and p_nombres is null and
       p_primer_apellido is null and p_segundo_apellido is null then
      p_ResultNumber := suirplus.Seg_Retornar_Cadena_Error(113, NULL, NULL);
    else
      select decode(count(*), 0, 'No', 'Si')
        into vMadre
        from suirplus.sre_ciudadanos_t c
        join suirplus.sfs_maternidad_t m
          on m.id_nss = c.id_nss
       where c.no_documento = decode(p_no_documento,
                                     null,
                                     c.no_documento,
                                     p_no_documento,
                                     p_no_documento)
         and m.id_nss =
             decode(p_id_nss, null, m.id_nss, p_id_nss, p_id_nss);
    
      qry := 'with x as (select rownum num, ' || '       c.id_nss,' ||
             '       suirplus.srp_pkg.fmt_no_documento(c.no_documento) no_documento,' ||
             '       InitCap(c.nombres) nombres,' ||
             '       InitCap(c.primer_apellido || '' '' || c.segundo_apellido) AS apellidos ,' ||
             '       c.fecha_nacimiento,' ||
             '       decode(c.TIPO_DOCUMENTO,''C'',''Cedula'',''P'',''Pasaporte'',''T'',''Titular'',''Menor'') tipo_documento,' ||
             '       c.sexo, ' ||
             '       decode(c.id_causa_inhabilidad, null, null, ''(''||c.id_causa_inhabilidad||'') ''||InitCap(inh.cancelacion_des)) id_causa_inhabilidad, ' ||
             '       decode(c.tipo_causa, ''I'', '' - INHABILIDAD PARA VOTAR'', ''C'', ''Cancelacion'') tipo_causa, ' ||
             '       c.Imagen_Acta ' || '       ,''' || vMadre ||
             ''' EsMadre ' || 'FROM suirplus.SRE_CIUDADANOS_T c ' ||
             'LEFT JOIN SUIRPLUS.SRE_INHABILIDAD_JCE_T INH ON INH.ID_CAUSA_INHABILIDAD = c.id_causa_inhabilidad and inh.tipo_causa = c.tipo_causa ';
    
      if (p_no_documento is not null) then
        qry := qry || con || 'c.no_documento=''' || p_no_documento || '''';
        con := ' and ';
      end if;
    
      if (p_id_nss is not null) then
        qry := qry || con || 'c.id_nss = ' || p_id_nss;
        con := ' and ';
      end if;
    
      if (p_nombres is not null) then
        qry := qry || con || 'nombres like ''' || upper(p_nombres) || '%''';
        con := ' and ';
      end if;
    
      if (p_primer_apellido is not null) then
        qry := qry || con || 'primer_apellido like ''' ||
               upper(p_primer_apellido) || '%''';
        con := ' and ';
      end if;
    
      if (p_segundo_apellido is not null) then
        qry := qry || con || 'segundo_apellido like ''' ||
               upper(p_segundo_apellido) || '%''';
      end if;
    
      qry := qry ||
             ' ORDER BY c.primer_apellido, c.segundo_apellido, c.nombres' ||
             ') select y.recordcount, x.* ' ||
             '    from x,(select max(num) recordcount from x) y ' ||
             '    where num between ' || nvl(vDesde, 1) || ' and ' ||
             nvl(vHasta, 10) || '    order by num';
    
      open io_cursor for qry;
    
      p_ResultNumber := '0';
    end if;
  END;

  -- *****************************************************************************************************
  PROCEDURE crearCiudadano(p_nombres          suirplus.SRE_CIUDADANOS_T.nombres%TYPE,
                           p_primer_apellido  suirplus.SRE_CIUDADANOS_T.primer_apellido%TYPE,
                           p_segundo_apellido suirplus.SRE_CIUDADANOS_T.segundo_apellido%TYPE,
                           p_estado_civil     suirplus.SRE_CIUDADANOS_T.Estado_Civil%TYPE,
                           p_fecha_nacimiento suirplus.SRE_CIUDADANOS_T.Fecha_Nacimiento%TYPE,
                           p_no_documento     suirplus.SRE_CIUDADANOS_T.no_documento%TYPE,
                           p_sexo             suirplus.SRE_CIUDADANOS_T.sexo%TYPE,
                           p_id_provincia     suirplus.SRE_CIUDADANOS_T.Id_Provincia%TYPE,
                           p_id_tipo_sangre   suirplus.SRE_CIUDADANOS_T.Id_Tipo_Sangre%TYPE,
                           p_id_nacionalidad  suirplus.SRE_CIUDADANOS_T.Id_Nacionalidad%TYPE,
                           p_nombre_padre     suirplus.SRE_CIUDADANOS_T.Nombre_Padre%TYPE,
                           p_nombre_madre     suirplus.SRE_CIUDADANOS_T.Nombre_Madre%TYPE,
                           p_municipio_acta   suirplus.SRE_CIUDADANOS_T.Municipio_Acta%TYPE,
                           p_oficialia_acta   suirplus.SRE_CIUDADANOS_T.Oficialia_Acta%TYPE,
                           p_libro_acta       suirplus.SRE_CIUDADANOS_T.Libro_Acta%TYPE,
                           p_folio_acta       suirplus.SRE_CIUDADANOS_T.Folio_Acta%TYPE,
                           p_numero_acta      suirplus.SRE_CIUDADANOS_T.Numero_Acta%TYPE,
                           p_ano_acta         suirplus.SRE_CIUDADANOS_T.Ano_Acta%TYPE,
                           p_cedula_anterior  suirplus.SRE_CIUDADANOS_T.Cedula_Anterior%TYPE,
                           p_ult_usuario_act  suirplus.SRE_CIUDADANOS_T.ULT_USUARIO_ACT%TYPE,
                           p_ImagenActa       suirplus.sre_ciudadanos_t.imagen_acta%type,
                           p_resultnumber     IN OUT VARCHAR)
  
   IS
  
    v_longitud        VARCHAR(500);
    v_idnss           VARCHAR(20);
    v_fechanacimiento VARCHAR(10);
    v_existeciudadano VARCHAR(100);
  
    CURSOR c_existeciudadano IS
      SELECT c.no_documento
        FROM suirplus.SRE_CIUDADANOS_T c
       WHERE c.no_documento = p_no_documento;
  
  BEGIN
  
    if (p_nombres is not null) and (p_primer_apellido is not null) and
       (p_fecha_nacimiento is not null) and (p_no_documento is not null) and
       (p_sexo is not null) and (p_id_nacionalidad is not null) then
    
      IF NOT p_ult_usuario_act IS NULL AND
         NOT suirplus.Seg_Usuarios_Pkg.isexisteusuario(p_ult_usuario_act) THEN
        RAISE e_invaliduser;
      END IF;
    
      OPEN c_existeciudadano;
      FETCH c_existeciudadano
        INTO v_existeciudadano;
      IF c_existeciudadano%FOUND THEN
        RAISE e_ciudadanoeexiste;
      END IF;
      CLOSE c_existeciudadano;
    
      IF (LENGTH(P_NOMBRES)) >
         (Seg_Get_Largo_Columna('SRE_CIUDADANOS_T', 'NOMBRES')) THEN
        v_longitud := 'Nombres';
        RAISE e_excedelogintud;
      END IF;
    
      IF (LENGTH(P_PRIMER_APELLIDO)) >
         (Seg_Get_Largo_Columna('SRE_CIUDADANOS_T', 'PRIMER_APELLIDO')) THEN
        v_longitud := 'Primer Apellido';
        RAISE e_excedelogintud;
      END IF;
    
      -- insertamos los datos del Ciudadano.
      INSERT INTO suirplus.SRE_CIUDADANOS_T
        (NOMBRES,
         PRIMER_APELLIDO,
         SEGUNDO_APELLIDO,
         ESTADO_CIVIL,
         FECHA_NACIMIENTO,
         NO_DOCUMENTO,
         TIPO_DOCUMENTO,
         SEXO,
         ID_PROVINCIA,
         ID_TIPO_SANGRE,
         ID_CAUSA_INHABILIDAD,
         ID_NACIONALIDAD,
         NOMBRE_PADRE,
         NOMBRE_MADRE,
         FECHA_REGISTRO,
         MUNICIPIO_ACTA,
         ANO_ACTA,
         NUMERO_ACTA,
         FOLIO_ACTA,
         LIBRO_ACTA,
         OFICIALIA_ACTA,
         CEDULA_ANTERIOR,
         STATUS,
         ULT_USUARIO_ACT,
         TIPO_CAUSA,
         FECHA_EXPEDICION,
         COTIZACION,
         SECUENCIA_SIPEN,
         imagen_acta)
      VALUES
        (UPPER(p_nombres),
         UPPER(p_primer_apellido),
         UPPER(p_segundo_apellido),
         UPPER(p_estado_civil),
         p_fecha_nacimiento,
         p_no_documento,
         'C',
         UPPER(p_sexo),
         p_id_provincia,
         p_id_tipo_sangre,
         null,
         p_id_nacionalidad,
         UPPER(p_nombre_padre),
         UPPER(p_nombre_madre),
         sysdate,
         p_municipio_acta,
         p_ano_acta,
         p_numero_acta,
         p_folio_acta,
         p_libro_acta,
         p_oficialia_acta,
         p_cedula_anterior,
         null,
         UPPER(p_ult_usuario_act),
         null,
         null,
         null,
         null,
         p_ImagenActa);
    
      p_resultnumber := 0;
      COMMIT;
      RETURN;
    
    end if;
  
  EXCEPTION
    WHEN e_excedelogintud THEN
      p_resultnumber := suirplus.Seg_Retornar_Cadena_Error(15, NULL, NULL) ||
                        v_longitud;
      RETURN;
    
    WHEN e_ciudadanoeexiste THEN
      p_resultnumber := suirplus.Seg_Retornar_Cadena_Error(23, NULL, NULL);
      RETURN;
    
    WHEN e_invaliduser THEN
      p_resultnumber := suirplus.Seg_Retornar_Cadena_Error(1, NULL, NULL);
      RETURN;
    
    WHEN OTHERS THEN
      v_bderror      := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultnumber := suirplus.Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
      RETURN;
  END;

  --********************************************************************************

  -- *****************************************************************************************************
  PROCEDURE getTipoSangre(p_iocursor     out t_cursor,
                          p_resultnumber IN OUT VARCHAR)
  
   IS
  
  BEGIN
    Open p_iocursor for
      select t.id_tipo_sangre, t.tipo_sangre_des from suirplus.sre_tipo_sangre_t t;
  
    p_resultnumber := 0;
  
  EXCEPTION
  
    WHEN OTHERS THEN
      v_bderror      := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultnumber := suirplus.Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
      RETURN;
  END;

  -- *****************************************************************************************************
  PROCEDURE getNacionalidad(p_iocursor     out t_cursor,
                            p_resultnumber IN OUT VARCHAR)
  
   IS
  
  BEGIN
    Open p_iocursor for
      select n.id_nacionalidad,
             initcap(n.nacionalidad_des) nacionalidad_des
        from suirplus.sre_nacionalidad_t n
       order by n.nacionalidad_des asc;
  
    p_resultnumber := 0;
  
  EXCEPTION
  
    WHEN OTHERS THEN
      v_bderror      := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultnumber := suirplus.Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
      RETURN;
  END;

  -- *****************************************************************************************************
  -- Procedimiento que Registrar un Acta de Nacimiento
  --*****************************************************************************************************
  PROCEDURE RegistrarActaNacimiento(p_nombres          suirplus.SRE_CIUDADANOS_T.nombres%TYPE,
                                    p_primer_apellido  suirplus.SRE_CIUDADANOS_T.primer_apellido%TYPE,
                                    p_segundo_apellido suirplus.SRE_CIUDADANOS_T.segundo_apellido%TYPE,
                                    p_fecha_nacimiento suirplus.SRE_CIUDADANOS_T.Fecha_Nacimiento%TYPE,
                                    p_no_documento     suirplus.SRE_CIUDADANOS_T.no_documento%TYPE,
                                    p_sexo             suirplus.SRE_CIUDADANOS_T.Sexo%TYPE,
                                    p_nombre_padre     suirplus.SRE_CIUDADANOS_T.Nombre_Padre%TYPE,
                                    p_nombre_madre     suirplus.SRE_CIUDADANOS_T.Nombre_Madre%TYPE,
                                    p_municipio_acta   suirplus.SRE_CIUDADANOS_T.Municipio_Acta%TYPE,
                                    p_oficialia_acta   suirplus.SRE_CIUDADANOS_T.Oficialia_Acta%TYPE,
                                    p_libro_acta       suirplus.SRE_CIUDADANOS_T.Libro_Acta%TYPE,
                                    p_folio_acta       suirplus.SRE_CIUDADANOS_T.Folio_Acta%TYPE,
                                    p_numero_acta      suirplus.SRE_CIUDADANOS_T.Numero_Acta%TYPE,
                                    p_ano_acta         suirplus.SRE_CIUDADANOS_T.Ano_Acta%TYPE,
                                    p_ult_usuario_act  suirplus.SRE_CIUDADANOS_T.ULT_USUARIO_ACT%TYPE,
                                    p_ImagenActa       suirplus.sre_ciudadanos_t.imagen_acta%type,
                                    p_resultnumber     IN OUT VARCHAR)
  
   IS
  
    v_longitud        VARCHAR(500);
    v_existeciudadano VARCHAR(100);
  
    CURSOR c_existeciudadano IS
      SELECT c.no_documento
        FROM suirplus.SRE_CIUDADANOS_T c
       WHERE c.no_documento = p_no_documento
         and c.tipo_causa <> 'C';
  
  BEGIN
  
    if (p_nombres is not null) and (p_primer_apellido is not null) and
       (p_fecha_nacimiento is not null) then
    
      IF NOT p_ult_usuario_act IS NULL AND
         NOT suirplus.Seg_Usuarios_Pkg.isexisteusuario(p_ult_usuario_act) THEN
        RAISE e_invaliduser;
      END IF;
    
      OPEN c_existeciudadano;
      FETCH c_existeciudadano
        INTO v_existeciudadano;
      IF c_existeciudadano%FOUND THEN
        RAISE e_ciudadanoeexiste;
      END IF;
      CLOSE c_existeciudadano;
    
      IF (LENGTH(P_NOMBRES)) >
         (Seg_Get_Largo_Columna('SRE_CIUDADANOS_T', 'NOMBRES')) THEN
        v_longitud := 'Nombres';
        RAISE e_excedelogintud;
      END IF;
    
      IF (LENGTH(P_PRIMER_APELLIDO)) >
         (Seg_Get_Largo_Columna('SRE_CIUDADANOS_T', 'PRIMER_APELLIDO')) THEN
        v_longitud := 'Primer Apellido';
        RAISE e_excedelogintud;
      END IF;
    
      -- insertamos los datos del Ciudadano.
      INSERT INTO suirplus.SRE_CIUDADANOS_T
        (NOMBRES,
         PRIMER_APELLIDO,
         SEGUNDO_APELLIDO,
         FECHA_NACIMIENTO,
         no_documento,
         SEXO,
         NOMBRE_PADRE,
         NOMBRE_MADRE,
         FECHA_REGISTRO,
         MUNICIPIO_ACTA,
         ANO_ACTA,
         NUMERO_ACTA,
         FOLIO_ACTA,
         LIBRO_ACTA,
         OFICIALIA_ACTA,
         STATUS,
         ULT_USUARIO_ACT,
         imagen_acta,
         TIPO_DOCUMENTO,
         estado_civil)
      VALUES
        (UPPER(p_nombres),
         UPPER(p_primer_apellido),
         UPPER(p_segundo_apellido),
         p_fecha_nacimiento,
         p_no_documento,
         p_sexo,
         UPPER(p_nombre_padre),
         UPPER(p_nombre_madre),
         sysdate,
         p_municipio_acta,
         p_ano_acta,
         p_numero_acta,
         p_folio_acta,
         p_libro_acta,
         p_oficialia_acta,
         null,
         UPPER(p_ult_usuario_act),
         p_ImagenActa,
         'U',
         'S');
    
      p_resultnumber := 0;
      COMMIT;
      RETURN;
    
    end if;
  
  EXCEPTION
    WHEN e_excedelogintud THEN
      p_resultnumber := suirplus.Seg_Retornar_Cadena_Error(15, NULL, NULL) ||
                        v_longitud;
      RETURN;
    
    WHEN e_ciudadanoeexiste THEN
      p_resultnumber := suirplus.Seg_Retornar_Cadena_Error(23, NULL, NULL);
      RETURN;
    
    WHEN e_invaliduser THEN
      p_resultnumber := suirplus.Seg_Retornar_Cadena_Error(1, NULL, NULL);
      RETURN;
    
    WHEN OTHERS THEN
      v_bderror      := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultnumber := suirplus.Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
      RETURN;
  END;

  ------------------------------------------------------------------------------------------------------------
  ----Procedimiento que Verifica si un ciudadano existe pasandole el nombre, apellido y la fecha de nacimiento
  ----Mayreni Vargas
  ------------------------------------------------------------------------------------------------------------
  PROCEDURE Validar_Existe_Ciudadano(p_Nombres         in suirplus.SRE_CIUDADANOS_T.nombres%TYPE,
                                     p_PrimerApellido  in suirplus.SRE_CIUDADANOS_T.Primer_Apellido%TYPE,
                                     p_SegundoApellido in suirplus.SRE_CIUDADANOS_T.Segundo_Apellido%TYPE,
                                     p_FechaNac        in suirplus.SRE_CIUDADANOS_T.Fecha_Nacimiento%TYPE,
                                     p_ResultNumber    OUT VARCHAR)
  
   IS
  
    v_existe number(10);
  
  BEGIN
  
    SELECT count(id_nss)
      into v_existe
      FROM suirplus.SRE_CIUDADANOS_T c
     WHERE c.nombres = upper(p_Nombres)
       AND c.primer_apellido = upper(p_PrimerApellido)
       AND c.segundo_apellido =
           nvl(upper(p_SegundoApellido), c.segundo_apellido)
       and c.fecha_nacimiento = p_FechaNac;
  
    if (v_existe > 0) then
    
      p_ResultNumber := 1;
    
    else
    
      p_ResultNumber := 0;
    
    end if;
  
  END;

  -- **************************************************************************************************
  -- Program:     function IsMadre
  -- Description: funcion que retorna la existencia de una madre.

  -- **************************************************************************************************

  function isMadre(p_idnss varchar2) return varchar2 is
  
    returnvalue varchar2(3);
    v_Madre     varchar2(3);
  
  begin
  
    select count(*)
      into v_Madre
      from suirplus.sre_ciudadanos_t c
      join suirplus.sfs_maternidad_t m
        on m.id_nss = c.id_nss
       and m.status = 'AC'
     where m.id_nss = p_idnss;
  
    if v_madre > 0 then
      returnvalue := 'Si';
    else
      returnvalue := 'No';
    end if;
  
    return(returnvalue);
  
  end isMadre;
  /*******************************************************************************************
  -- Milciades Hernández
  -- 14/01/2010
  -- Actualizar_Ciudadano
  -- Proceso que actualiza ciudadanos..
   *-******************************************************************************************/
  FUNCTION isActivoTrabajadores(p_id_nss               suirplus.SRE_TRABAJADORES_T.id_nss%TYPE,
                                p_id_registro_patronal suirplus.SRE_EMPLEADORES_T.ID_REGISTRO_PATRONAL%TYPE,
                                p_id_nomina            suirplus.SRE_TRABAJADORES_T.id_nomina%TYPE)
    RETURN BOOLEAN IS
  
    v_is_valido            BOOLEAN;
    v_id_nss               VARCHAR2(20);
    v_id_registro_patronal VARCHAR2(20);
    v_id_nomina            VARCHAR2(20);
  
    CURSOR c_activo_trabajadores IS
      SELECT t.id_nss, t.id_registro_patronal, t.id_nomina
        FROM suirplus.SRE_TRABAJADORES_T t
       WHERE t.id_nss = p_id_nss
         AND t.id_registro_patronal = p_id_registro_patronal
         AND t.id_nomina = p_id_nomina
         AND t.status = 'A';
  
  BEGIN
  
    OPEN c_activo_trabajadores;
    FETCH c_activo_trabajadores
      INTO v_id_nss, v_id_registro_patronal, v_id_nomina;
  
    IF (v_id_nss IS NULL) AND (v_id_registro_patronal IS NULL) AND
       (v_id_nomina IS NULL) AND (c_activo_trabajadores%NOTFOUND) THEN
      v_is_valido := FALSE;
    ELSE
      v_is_valido := TRUE;
    END IF;
    CLOSE c_activo_trabajadores;
  
    RETURN(v_is_valido);
  
  END isActivoTrabajadores;

  --**************************************************************************
  --Milciades Hernandez
  --Verifica si ciudadanos existe
  --se modifico el parametro del numero documento por el id nss
  --05/04/2010
  --**************************************************************************

  PROCEDURE getconsultaciudadanoact(p_id_nss       suirplus.SRE_CIUDADANOS_T.id_nss%TYPE,
                                    p_resultnumber OUT VARCHAR2,
                                    p_io_cursor    IN OUT T_CURSOR)
  
   IS
  
    CURSOR c_ExisteCedula IS
      SELECT no_documento
        FROM suirplus.SRE_CIUDADANOS_T
       WHERE id_nss = p_id_nss
         AND tipo_documento in ('N', 'U', 'E')
         or (tipo_documento = 'C' and no_documento like '88%');
  
    e_CiudadanoNoExiste EXCEPTION;
    e_ParametrosNulos EXCEPTION;
    e_IvalidNSS EXCEPTION;
  
    v_tmpCedula VARCHAR(25);
  
    c_cursor t_cursor;
  
  BEGIN
  
    --Validacion del NSS
    IF NOT suirplus.Srp_Pkg.Existenss(p_id_nss) THEN
      RAISE e_IvalidNSS;
    END IF;
  
    OPEN c_ExisteCedula;
    FETCH c_ExisteCedula
      INTO v_tmpCedula;
  
    IF c_ExisteCedula%FOUND THEN
    
      open c_cursor for
        SELECT c.no_documento,
               c.NOMBRES,
               c.PRIMER_APELLIDO,
               c.SEGUNDO_APELLIDO,
               c.ID_NSS,
               c.fecha_nacimiento,
               c.sexo,
               c.tipo_documento,
               c.ult_usuario_act
          FROM suirplus.SRE_CIUDADANOS_T c
         WHERE c.id_nss = p_id_nss
           and tipo_documento in ('N', 'U', 'E')
           or (tipo_documento = 'C' and no_documento like '88%');
    
      CLOSE c_ExisteCedula;
      p_ResultNumber := 0;
      p_io_cursor    := c_cursor;
      RETURN;
    
    ELSE
      CLOSE c_ExisteCedula;
      p_ResultNumber := suirplus.Seg_Retornar_Cadena_Error(14, NULL, NULL);
      RETURN;
    END IF;
  
  EXCEPTION
    WHEN e_CiudadanoNoExiste THEN
      p_resultnumber := suirplus.Seg_Retornar_Cadena_Error(151, NULL, NULL);
      RETURN;
    
    WHEN e_IvalidNSS THEN
      p_resultnumber := suirplus.Seg_Retornar_Cadena_Error(24, NULL, NULL);
      RETURN;
    
    WHEN e_ParametrosNulos THEN
      p_ResultNumber := suirplus.Seg_Retornar_Cadena_Error(8, NULL, NULL);
      RETURN;
    
  END;

  --********************************************************************************
  --Milciades Hernandez
  --metodo que valida los registros de los ciudadanos
  --********************************************************************************
  PROCEDURE getconsultaciudcambio(p_id_nss       suirplus.SRE_CIUDADANOS_T.id_nss%TYPE,
                                  p_resultnumber OUT VARCHAR2,
                                  p_io_cursor    IN OUT T_CURSOR)
  
   IS
  
    CURSOR c_ExisteCedula IS
      SELECT no_documento
        FROM suirplus.SRE_CIUDADANOS_T
       WHERE id_nss = p_id_nss
         AND tipo_documento in ('N', 'U', 'E')
         or (tipo_documento = 'C' and no_documento like '88%');
  
    e_CiudadanoNoExiste EXCEPTION;
    e_ParametrosNulos EXCEPTION;
    e_IvalidNSS EXCEPTION;
  
    v_tmpCedula VARCHAR(25);
  
    c_cursor t_cursor;
  
  BEGIN
  
    --Validacion del NSS
    IF NOT suirplus.Srp_Pkg.Existenss(p_id_nss) THEN
      RAISE e_IvalidNSS;
    END IF;
  
    OPEN c_ExisteCedula;
    FETCH c_ExisteCedula
      INTO v_tmpCedula;
  
    IF c_ExisteCedula%FOUND THEN
    
      open c_cursor for
        SELECT c.no_documento,
               c.NOMBRES,
               c.PRIMER_APELLIDO,
               c.SEGUNDO_APELLIDO,
               c.ID_NSS,
               c.fecha_nacimiento,
               c.sexo,
               c.tipo_documento,
               c.ult_usuario_act
          FROM suirplus.SRE_CIU_CAMBIOS_T c
         WHERE c.id_nss = p_id_nss
           and c.tipo_documento in ('N', 'U', 'E')
           or (tipo_documento = 'C' and no_documento like '88%');
    
      CLOSE c_ExisteCedula;
      p_ResultNumber := 0;
      p_io_cursor    := c_cursor;
      RETURN;
    
    ELSE
    
      CLOSE c_ExisteCedula;
      p_ResultNumber := suirplus.Seg_Retornar_Cadena_Error(14, NULL, NULL);
      RETURN;
    
    END IF;
  
  EXCEPTION
    WHEN e_CiudadanoNoExiste THEN
      p_resultnumber := suirplus.Seg_Retornar_Cadena_Error(151, NULL, NULL);
      RETURN;
    
    WHEN e_IvalidNSS THEN
      p_resultnumber := suirplus.Seg_Retornar_Cadena_Error(24, NULL, NULL);
      RETURN;
    
    WHEN e_ParametrosNulos THEN
      p_ResultNumber := suirplus.Seg_Retornar_Cadena_Error(8, NULL, NULL);
      RETURN;
    
  END;

  --********************************************************************************
  --********************************************************************************
  --Milciades Hernandez
  -- Inserta ciudadanos en SRE_CIU_CAMBIOS_T
  --********************************************************************************
  PROCEDURE Insertar_Ciudadano_act(p_id_nss           suirplus.SRE_CIUDADANOS_T.id_nss%TYPE,
                                   p_no_documento     suirplus.SRE_CIUDADANOS_T.no_documento%TYPE,
                                   p_nombres          suirplus.SRE_CIUDADANOS_T.nombres%TYPE,
                                   p_primer_apellido  suirplus.SRE_CIUDADANOS_T.primer_apellido%TYPE,
                                   p_segundo_apellido suirplus.SRE_CIUDADANOS_T.segundo_apellido%TYPE,
                                   p_fecha_nacimiento suirplus.SRE_CIUDADANOS_T.FECHA_NACIMIENTO%TYPE,
                                   p_sexo             suirplus.SRE_CIUDADANOS_T.sexo%TYPE,
                                   p_ult_usuario_act  suirplus.SRE_CIUDADANOS_T.ult_usuario_act%TYPE,
                                   p_resultnumber     IN OUT VARCHAR)
  
   IS
    v_longitud        VARCHAR(500);
    v_idnss           suirplus.sre_ciudadanos_t.id_nss%TYPE;
    v_tipo_doc        suirplus.sre_ciudadanos_t.tipo_documento%TYPE;
    v_existeciudadano VARCHAR(100);
    v_fecha_registro  date;
    v_sequence        number := 1;
    v_estatus         suirplus.sre_ciu_cambios_t.estatus%type;
    v_exite1          integer;
    v_exite2          integer;
  
    e_ExisteCiudadano exception;
  
  BEGIN
  
    IF NOT p_ult_usuario_act IS NULL AND
       NOT suirplus.Seg_Usuarios_Pkg.isexisteusuario(p_ult_usuario_act) THEN
      RAISE e_invaliduser;
    END IF;
  
    IF (LENGTH(P_NOMBRES)) >
       (Seg_Get_Largo_Columna('SRE_CIUDADANOS_T', 'NOMBRES')) THEN
      v_longitud := 'Nombres';
      RAISE e_excedelogintud;
    END IF;
  
    IF (LENGTH(P_PRIMER_APELLIDO)) >
       (Seg_Get_Largo_Columna('SRE_CIUDADANOS_T', 'PRIMER_APELLIDO')) THEN
      v_longitud := 'Primer Apellido';
      RAISE e_excedelogintud;
    END IF;
  
    IF (LENGTH(P_SEGUNDO_APELLIDO)) >
       (Seg_Get_Largo_Columna('SRE_CIUDADANOS_T', 'SEGUNDO_APELLIDO')) THEN
      v_longitud := 'Segundo Apellido';
      RAISE e_excedelogintud;
    END IF;
  
    IF (LENGTH(P_ID_NSS)) >
       (Seg_Get_Largo_Columna('SRE_CIUDADANOS_T', 'ID_NSS')) THEN
      v_longitud := 'ID NSS';
      RAISE e_excedelogintud;
    END IF;
  
    --/ VALIDAR QUE EL NRO DOCUMENTO EXISTA EN CIUDADANOS
    select count(*)
      into v_exite1
      from suirplus.sre_ciudadanos_t
     where id_nss = p_id_nss
       and tipo_documento in ('N', 'E', 'U')
       or (tipo_documento = 'C' and no_documento like '88%');
  
    if (v_exite1 = 0) then
      raise e_ExisteCiudadano;
    end if;
  
    if ExisteCiudadanoExtrangero(P_NOMBRES,
                                 P_PRIMER_APELLIDO,
                                 p_fecha_nacimiento) then
      raise e_ExisteCiudadano;
    end if;
  
    select id_nss, tipo_documento
      into v_idnss, v_tipo_doc
      from suirplus.sre_ciudadanos_t
     where id_nss = p_id_nss;
  
    --   Si no existe en Sre_Ciu_Cambios Insertamo.
    insert into suirplus.SRE_CIU_CAMBIOS_T
      (ID_SECUENCIA,
       ID_NSS,
       NOMBRES,
       PRIMER_APELLIDO,
       SEGUNDO_APELLIDO,
       FECHA_NACIMIENTO,
       NO_DOCUMENTO,
       TIPO_DOCUMENTO,
       SEXO,
       ESTATUS,
       FECHA_REGISTRO,
       ULT_FECHA_ACT,
       ULT_USUARIO_ACT)
    VALUES
      (ciu_cambios_seq.nexTval,
       v_idnss,
       upper(p_nombres),
       upper(p_primer_apellido),
       upper(p_segundo_apellido),
       p_fecha_nacimiento,
       p_no_documento,
       v_tipo_doc,
       p_sexo,
       'PE',
       sysdate,
       sysdate,
       p_ult_usuario_act);
  
    p_resultnumber := 0 || '|' || v_idnss;
    COMMIT;
  
  EXCEPTION
    WHEN e_ExisteCiudadano THEN
      p_resultnumber := suirplus.Seg_Retornar_Cadena_Error(24, NULL, NULL);
      RETURN;
    
    WHEN e_InvalidUser THEN
      p_resultnumber := suirplus.Seg_Retornar_Cadena_Error(1, NULL, NULL);
      RETURN;
    
    WHEN e_no9no11 THEN
      p_resultnumber := suirplus.Seg_Retornar_Cadena_Error(61, NULL, NULL) || '' ||
                        v_longitud;
      RETURN;
    
    WHEN e_excedelogintud THEN
      p_resultnumber := suirplus.Seg_Retornar_Cadena_Error(15, NULL, NULL) || '' ||
                        v_longitud;
      RETURN;
    
    WHEN TOO_MANY_ROWS THEN
      p_resultnumber := suirplus.Seg_Retornar_Cadena_Error(23, NULL, NULL);
      RETURN;
    
    WHEN OTHERS THEN
      v_bderror      := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultnumber := suirplus.Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
      RETURN;
    
  end Insertar_Ciudadano_act;

  --*****************************************************************************
  --Milciades Hernandez
  --Aplicar cambios a ciudadano en Sre_Ciu_Cambios_t
  --*****************************************************************************

  PROCEDURE Aplicar_Ciudadano(p_sequence     suirplus.SRE_CIU_CAMBIOS_T.ID_SECUENCIA%TYPE,
                              p_resultnumber IN OUT VARCHAR)
  
   IS
    v_cursor t_cursor;
  
    CURSOR c_aplciartodos is
      SELECT c.NOMBRES,
             c.PRIMER_APELLIDO,
             c.SEGUNDO_APELLIDO,
             c.fecha_nacimiento,
             c.sexo,
             c.fecha_registro,
             c.ult_usuario_act
        FROM suirplus.SRE_CIU_CAMBIOS_T c
       WHERE c.estatus = 'PE'
         and tipo_documento in ('N', 'U', 'E')
         or (tipo_documento = 'C' and no_documento like '88%');
  
    v_NOMBRES          suirplus.SRE_CIU_CAMBIOS_T.NOMBRES%type;
    v_PRIMER_APELLIDO  suirplus.SRE_CIU_CAMBIOS_T.PRIMER_APELLIDO%type;
    v_SEGUNDO_APELLIDO suirplus.SRE_CIU_CAMBIOS_T.SEGUNDO_APELLIDO%type;
    v_fecha_nacimiento suirplus.SRE_CIU_CAMBIOS_T.FECHA_NACIMIENTO%type;
    v_sexo             suirplus.SRE_CIU_CAMBIOS_T.SEXO%type;
    v_fecha_registro   suirplus.SRE_CIU_CAMBIOS_T.FECHA_REGISTRO%type;
    v_ult_usuario_act  suirplus.SRE_CIU_CAMBIOS_T.Ult_Usuario_Act%type;
  
  BEGIN
  
    P_RESULTNUMBER := 0;
  
    open c_aplciartodos;
  
    FETCH c_aplciartodos
      INTO v_NOMBRES,
           v_PRIMER_APELLIDO,
           v_SEGUNDO_APELLIDO,
           v_fecha_nacimiento,
           v_sexo,
           v_fecha_registro,
           v_ult_usuario_act;
  
    IF c_aplciartodos%FOUND THEN
      -- Actualizar en Sre_Ciudadanos_t
      update suirplus.sre_ciudadanos_t
         set nombres          = upper(V_nombres),
             primer_apellido  = upper(V_primer_apellido),
             segundo_apellido = upper(V_segundo_apellido),
             fecha_nacimiento = V_fecha_nacimiento,
             sexo             = V_sexo,
             fecha_registro   = V_fecha_registro,
             ult_fecha_act    = sysdate,
             ult_usuario_act  = V_ult_usuario_act
       where id_nss in (select id_nss
                          from suirplus.sre_ciu_cambios_t
                         where id_secuencia = p_sequence
                           and estatus = 'PE'
                           and tipo_documento in ('N', 'U', 'E')
                           or (tipo_documento = 'C' and no_documento like '88%'));
    
      update suirplus.sre_ciu_cambios_t t
         set t.estatus = 'OK'
       where t.Id_Secuencia = p_sequence;
    
    END IF;
    commit;
    CLOSE c_aplciartodos;
  
  EXCEPTION
    WHEN OTHERS THEN
      v_bderror      := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultnumber := suirplus.Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
      RETURN;
  END Aplicar_Ciudadano;

  --***************************************************************************************--
  --procesa un ciudadano, si no existe lo inserta..
  --by cmha
  --20/6/2012
  --***************************************************************************************--
  PROCEDURE procesarCiudadanoTSS(p_no_documento         suirplus.SRE_CIUDADANOS_T.no_documento%TYPE,
                                 p_nombres              suirplus.SRE_CIUDADANOS_T.nombres%TYPE,
                                 p_primer_apellido      suirplus.SRE_CIUDADANOS_T.primer_apellido%TYPE,
                                 p_segundo_apellido     suirplus.SRE_CIUDADANOS_T.segundo_apellido%TYPE,
                                 p_estado_civil         suirplus.SRE_CIUDADANOS_T.Estado_Civil%TYPE,
                                 p_fecha_nacimiento     suirplus.SRE_CIUDADANOS_T.Fecha_Nacimiento%TYPE,
                                 p_sexo                 suirplus.SRE_CIUDADANOS_T.sexo%TYPE,
                                 p_id_tipo_sangre       suirplus.SRE_CIUDADANOS_T.Id_Tipo_Sangre%TYPE,
                                 p_id_nacionalidad      suirplus.SRE_CIUDADANOS_T.Id_Nacionalidad%TYPE,
                                 p_nombre_padre         suirplus.SRE_CIUDADANOS_T.Nombre_Padre%TYPE,
                                 p_nombre_madre         suirplus.SRE_CIUDADANOS_T.Nombre_Madre%TYPE,
                                 p_municipio_acta       suirplus.SRE_CIUDADANOS_T.Municipio_Acta%TYPE,
                                 p_oficialia_acta       suirplus.SRE_CIUDADANOS_T.Oficialia_Acta%TYPE,
                                 p_libro_acta           suirplus.SRE_CIUDADANOS_T.Libro_Acta%TYPE,
                                 p_folio_acta           suirplus.SRE_CIUDADANOS_T.Folio_Acta%TYPE,
                                 p_numero_acta          suirplus.SRE_CIUDADANOS_T.Numero_Acta%TYPE,
                                 p_ano_acta             suirplus.SRE_CIUDADANOS_T.Ano_Acta%TYPE,
                                 p_tipo_causa           suirplus.SRE_CIUDADANOS_T.tipo_causa%TYPE,
                                 p_id_causa_inhabilidad suirplus.SRE_CIUDADANOS_T.id_causa_inhabilidad%TYPE,
                                 p_status               suirplus.SRE_CIUDADANOS_T.Status%TYPE,
                                 p_ult_usuario_act      suirplus.SRE_CIUDADANOS_T.ULT_USUARIO_ACT%TYPE,
                                 p_accion               in varchar,
                                 p_resultnumber         IN OUT VARCHAR)
  
   IS
    v_cedula               suirplus.SRE_CIUDADANOS_T.no_documento%TYPE;
    v_count                integer;
    v_municipio_acta       suirplus.sre_ciudadanos_t.MUNICIPIO_ACTA%type;
    v_provincia            suirplus.sre_ciudadanos_t.ID_PROVINCIA%type;
    v_sangre               suirplus.sre_ciudadanos_t.ID_TIPO_SANGRE%type;
    v_nacion               suirplus.sre_ciudadanos_t.ID_NACIONALIDAD%type;
    v_idInhabilidad        suirplus.sre_ciudadanos_t.id_causa_inhabilidad%type;
    v_tipoCausa            suirplus.sre_ciudadanos_t.tipo_causa%type;
    v_stadoCivilConstraint long;
    existe                 integer := 0;
  
  BEGIN
  
    -- verificamos municipio ------------------------------------------------------------------------------
    if p_municipio_acta is not null then
      begin
        select id_municipio
          into v_municipio_acta
          from suirplus.sre_municipio_t
         where id_municipio = replace(p_municipio_acta, chr(0), '');
      exception
        when no_data_found then
          p_resultnumber := 'El código de municipio no existe en TSS';
          return;
      end;
    else
      v_municipio_acta := null;
    end if;
    --verificamos sangre ---------------------------------------------------------------------------------
    if p_id_tipo_sangre is not null then
      begin
        select ID_TIPO_SANGRE
          into v_sangre
          from suirplus.sre_tipo_sangre_t
         where ID_TIPO_SANGRE = replace(p_id_tipo_sangre, chr(0), '');
      exception
        when no_data_found then
          p_resultnumber := 'El código de tipo de sangre no existe en TSS';
          return;
      end;
    else
      v_sangre := null;
    end if;
    --verificamos nacionalidad ---------------------------------------------------------------------------
    if p_id_nacionalidad is not null then
      begin
        select id_nacionalidad
          into v_nacion
          from suirplus.sre_nacionalidad_t
         where id_nacionalidad = replace(p_id_nacionalidad, chr(0), '');
      exception
        when no_data_found then
          p_resultnumber := 'El código de nacionalidad no existe en TSS';
          return;
      end;
    else
      v_nacion := null;
    end if;
  
    --verificamos la inhabilidad ---------------------------------------------------------------------------
  
    if (p_id_causa_inhabilidad is not null) and (p_tipo_causa is not null) then
      begin
        select i.id_causa_inhabilidad, i.tipo_causa
          into v_idInhabilidad, v_tipoCausa
          from suirplus.sre_inhabilidad_jce_t i
         where i.id_causa_inhabilidad =
               replace(p_id_causa_inhabilidad, chr(0), '')
           and i.tipo_causa = replace(p_tipo_causa, chr(0), '');
      exception
        when no_data_found then
          p_resultnumber := 'El código de inhabilidad no existe en TSS';
          return;
      end;
    else
      v_idInhabilidad := null;
      v_tipoCausa     := null;
    end if;
  
    --verificamos el stado civil
    begin
      for r1 in (select a.*
                   from all_constraints a
                  where a.table_name = 'SRE_CIUDADANOS_T'
                    and a.OWNER = 'SUIRPLUS') loop
        if (instr(lower(r1.search_condition), lower('ESTADO_CIVIL')) > 0) and
           (instr(lower(r1.search_condition),
                  lower('''' || p_estado_civil || '''')) > 0) then
          existe := existe + 1;
        end if;
      end loop;
      v_stadoCivilConstraint := existe;
    end;
  
    if v_stadoCivilConstraint = '0' then
      p_resultnumber := 'El estado civil del ciudadano no existe en TSS';
      return;
    end if;
  
    --if v_count = 0 then
    if p_accion = 'I' then
      --Insertamos el nuevo ciudadano -----------------------------------------------------------
      insert into suirplus.sre_ciudadanos_t
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
         id_nacionalidad,
         nombre_padre,
         nombre_madre,
         fecha_registro,
         fecha_expedicion,
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
         id_causa_inhabilidad)
      values
        (null,
         replace(p_nombres, chr(0), ''),
         replace(p_primer_apellido, chr(0), ''),
         replace(p_segundo_apellido, chr(0), ''),
         replace(nvl(p_estado_civil, 'S'), chr(0), ''),
         trunc(p_fecha_nacimiento),
         replace(p_no_documento, chr(0), ''),
         'C',
         replace(nvl(p_sexo, 'M'), chr(0), ''),
         null,
         v_sangre,
         v_nacion,
         replace(p_nombre_padre, chr(0), ''),
         replace(p_nombre_madre, chr(0), ''),
         sysdate,
         null,
         suirplus.sre_Validar_Ciudadano_pkg.limpiar_municipio_acta(replace(v_municipio_acta, chr(0), '')),   
         suirplus.sre_Validar_Ciudadano_pkg.limpiar_ano_acta(replace(p_ano_acta, chr(0), '')),
         suirplus.sre_Validar_Ciudadano_pkg.limpiar_numero_acta(replace(p_numero_acta, chr(0), '')),
         suirplus.sre_Validar_Ciudadano_pkg.limpiar_folio_acta( replace(p_folio_acta, chr(0), '')),
         suirplus.sre_Validar_Ciudadano_pkg.limpiar_libro_acta(replace(p_libro_acta, chr(0), ''),replace(p_ano_acta, chr(0), '')),
         suirplus.sre_Validar_Ciudadano_pkg.limpiar_oficialia_acta(replace(p_oficialia_acta,chr(0),'')),
         null,
         replace(p_status, chr(0), ''),
         sysdate,
         p_ult_usuario_act,
         replace(v_tipoCausa, chr(0), ''),
         replace(v_idInhabilidad, chr(0), ''));
      commit;
      p_resultnumber := '0';
    
    end if;
  
  EXCEPTION
  
    WHEN OTHERS THEN
      system.html_mail('info@mail.tss2.gov.do',
                       '_operaciones@mail.tss2.gov.do',
                       'error al insertar ciudadano via WS JCE',
                       sqlerrm);
      v_bderror      := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultnumber := suirplus.Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
      RETURN;
  END;

  --*********************************************************************
  --Milciades Hernandez
  --buscar ciudadanos de sre_ciud_cambios_t
  --*********************************************************************
  --*********************************************************************

  PROCEDURE buscarciudadanos(p_resultnumber out varchar2,
                             p_io_cursor    in out t_cursor)
  
   IS
    v_cursor t_cursor;
  
  begin
  
    open v_cursor for
      SELECT c.id_secuencia,
             c.No_documento,
             c.NOMBRES,
             c.PRIMER_APELLIDO,
             c.SEGUNDO_APELLIDO,
             c.ID_NSS,
             c.fecha_nacimiento,
             c.sexo,
             c.tipo_documento,
             c.ult_usuario_act
        FROM suirplus.SRE_CIU_CAMBIOS_T c
       WHERE c.estatus = 'PE'
         and tipo_documento in ('N', 'U', 'E', 'C');
  
    P_RESULTNUMBER := 0;
  
    p_io_cursor := v_cursor;
  
  EXCEPTION
    WHEN OTHERS THEN
      v_bderror      := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultnumber := suirplus.Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
      RETURN;
  end buscarciudadanos;

  --***************************************************************************************--
  --busca los datos de los ciudadanos
  --by charlie pena
  --26/07/2011
  --***************************************************************************************--
  procedure getCiudadano(p_no_documento     in suirplus.sre_ciudadanos_t.no_documento%type,
                         p_nombres          suirplus.SRE_CIUDADANOS_T.nombres%TYPE,
                         p_primer_apellido  suirplus.SRE_CIUDADANOS_T.primer_apellido%TYPE,
                         p_segundo_apellido suirplus.SRE_CIUDADANOS_T.segundo_apellido%TYPE,
                         p_fecha_nacimiento suirplus.SRE_CIUDADANOS_T.Fecha_Nacimiento%TYPE,
                         p_municipio_acta   suirplus.SRE_CIUDADANOS_T.Municipio_Acta%TYPE,
                         p_ano_acta         suirplus.SRE_CIUDADANOS_T.Ano_Acta%TYPE,
                         p_numero_acta      suirplus.SRE_CIUDADANOS_T.Numero_Acta%TYPE,
                         p_folio_acta       suirplus.SRE_CIUDADANOS_T.Folio_Acta%TYPE,
                         p_libro_acta       suirplus.SRE_CIUDADANOS_T.Libro_Acta%TYPE,
                         p_oficilia_acta    suirplus.SRE_CIUDADANOS_T.Oficialia_Acta%TYPE,
                         p_iocursor         out t_cursor,
                         p_resultnumber     out varchar2)
  
   is
    v_count      integer;
    v_count1     integer;
    v_nss        varchar2(10);
    v_bderror    varchar(1000);
    v_error      varchar2(3);
    v_error_desc varchar2(200);
    c_cursor     t_cursor;
  begin
  
    --virificamos si existe en ciudadanos con tipo de documento "C" sino lo buscamos por tipo de documento "U"
    select count(*)
      into v_count
      FROM suirplus.SRE_CIUDADANOS_T c
     WHERE c.no_documento = p_no_documento
       and c.tipo_documento = 'C';
  
    if v_count = 0 then
      --CASOS 7,8,9 Y 10
      --CASO 18,19,20,21 y 29,30,31,32
      
      --buscamos por documento y tipo = 'U' o 'P'
      select count(*)
        into v_count1
        FROM suirplus.SRE_CIUDADANOS_T c
       WHERE c.no_documento = p_no_documento
         and c.tipo_documento in ('P', 'U');
    
      if v_count1 > 0 then
        v_error        := 'J03';
        v_error_desc   := getMotivoRechazo(v_error);
        p_resultnumber := v_error_desc;
        return;
      else
        --buscamos por el acta si el tipo documento de la JCE es U o E
          IF p_municipio_acta is not null   AND p_ano_acta is not null
             AND p_numero_acta is not null   AND p_folio_acta is not null
             AND p_oficilia_acta is not null AND p_libro_acta is not null THEN
           
           select count(*)
              into v_count1
              FROM suirplus.SRE_CIUDADANOS_T c
             WHERE c.tipo_documento in ('U', 'E')
             /* --Modificado por: CHMA
                --Fecha: 02/06/2015
                --ticket 7875
              */
             and suirplus.sre_validar_ciudadano_pkg.limpiar_datos_acta(municipio_acta,ano_acta,numero_acta,folio_acta,libro_acta,oficialia_acta)
               = suirplus.sre_validar_ciudadano_pkg.limpiar_datos_acta(p_municipio_acta,p_ano_acta,p_numero_acta,p_folio_acta,p_libro_acta,p_oficilia_acta)
             and (c.tipo_causa is null or c.tipo_causa = 'I') ;
      
            if v_count1 > 0 then
              v_error        := 'J03';
              v_error_desc   := getMotivoRechazo(v_error);
              p_resultnumber := v_error_desc;
              return;
           end if;
         end if;
      end if;
    
      if v_count = 0 then
        --buscamos por nombre, primer apellido, segundo apellido, fecha nacimiento, tipo documento="N", tipo causa is null
       IF p_municipio_acta is not null   AND p_ano_acta is not null
         AND p_numero_acta is not null   AND p_folio_acta is not null
         AND p_oficilia_acta is not null AND p_libro_acta is not null THEN

         BEGIN
             select c.id_nss
              into v_nss
              FROM suirplus.SRE_CIUDADANOS_T c
             WHERE c.tipo_documento = 'N'
             /* --Modificado por: CHMA
                --Fecha: 02/06/2015
                --ticket 7875
             */
             and suirplus.sre_validar_ciudadano_pkg.limpiar_datos_acta(municipio_acta,ano_acta, numero_acta,folio_acta,libro_acta,oficialia_acta)
               = suirplus.sre_validar_ciudadano_pkg.limpiar_datos_acta(p_municipio_acta,p_ano_acta, p_numero_acta,p_folio_acta,p_libro_acta,p_oficilia_acta)
             and (c.tipo_causa is null or c.tipo_causa = 'I')
             and rownum <= 1 ;
           EXCEPTION
             WHEN no_data_found THEN
               v_nss := null;
           END ; 
       END IF; 
      end if;
    end if;

    open c_cursor for
      select c.id_nss,
             c.nombres,
             c.primer_apellido,
             c.segundo_apellido,
             c.estado_civil,
             trunc(c.fecha_nacimiento) fecha_nacimiento,
             c.no_documento,
             c.tipo_documento,
             c.sexo,
             decode(c.sexo, 'F', 'FEMENINO', 'M', 'MASCULINO') sexo_des,
             c.id_provincia,
             c.id_tipo_sangre,
             s.tipo_sangre_des,
             c.id_causa_inhabilidad,
             i.cancelacion_des,
             c.tipo_causa,
             c.id_nacionalidad,
             n.nacionalidad_des,
             c.nombre_padre,
             c.nombre_madre,
             c.fecha_registro,
             c.municipio_acta id_municipio,
             m.municipio_des,             
             c.ano_acta,
             c.numero_acta,
             c.folio_acta,
             c.libro_acta,
             c.oficialia_acta,
             c.cedula_anterior,
             c.status
        from suirplus.sre_ciudadanos_t c
        left join suirplus.sre_municipio_t m
          on c.municipio_acta = m.id_municipio
        left join suirplus.sre_tipo_sangre_t s
          on c.id_tipo_sangre = s.id_tipo_sangre
        left join suirplus.sre_nacionalidad_t n
          on c.id_nacionalidad = n.id_nacionalidad
        left join suirplus.sre_inhabilidad_jce_t i
          on c.id_causa_inhabilidad = i.id_causa_inhabilidad
         and c.tipo_causa = i.tipo_causa
       where c.no_documento = nvl(p_no_documento, null)
          or c.id_nss = nvl(v_nss, null);
  
    p_iocursor     := c_cursor;
    p_resultnumber := 0;
 
  exception
    
    when others then
      v_bderror      := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultnumber := suirplus.Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
      return;
  end;

  --***************************************************************************************--
  --busca los datos de un ciudadano a partir de su NSS
  --by Gregorio Herrera
  --30/06/2015
  --***************************************************************************************--
  procedure getCiudadanoNSS(p_id_nss       in suirplus.sre_ciudadanos_t.id_nss%type,
                            p_iocursor     out t_cursor,
                            p_resultnumber out varchar2)
   is
  begin
    open p_iocursor for
      select c.id_nss,
             c.nombres,
             c.primer_apellido,
             c.segundo_apellido,
             c.estado_civil,
             trunc(c.fecha_nacimiento) fecha_nacimiento,
             c.no_documento,
             c.tipo_documento,
             c.sexo,
             decode(c.sexo, 'F', 'FEMENINO', 'M', 'MASCULINO') sexo_des,
             c.id_provincia,
             c.id_tipo_sangre,
             s.tipo_sangre_des,
             c.id_causa_inhabilidad,
             i.cancelacion_des,
             c.tipo_causa,
             c.id_nacionalidad,
             n.nacionalidad_des,
             c.nombre_padre,
             c.nombre_madre,
             c.fecha_registro,
             c.municipio_acta id_municipio,
             m.municipio_des,             
             c.ano_acta,
             c.numero_acta,
             c.folio_acta,
             c.libro_acta,
             c.oficialia_acta,
             c.cedula_anterior,
             c.status
        from suirplus.sre_ciudadanos_t c
        left join suirplus.sre_municipio_t m
          on c.municipio_acta = m.id_municipio
        left join suirplus.sre_tipo_sangre_t s
          on c.id_tipo_sangre = s.id_tipo_sangre
        left join suirplus.sre_nacionalidad_t n
          on c.id_nacionalidad = n.id_nacionalidad
        left join suirplus.sre_inhabilidad_jce_t i
          on c.id_causa_inhabilidad = i.id_causa_inhabilidad
         and c.tipo_causa = i.tipo_causa
       where c.id_nss = p_id_nss;
  
    p_resultnumber := 0;
  exception
    
    when others then
      v_bderror      := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultnumber := suirplus.Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
      return;
  end;

  --***************************************************************************************--
  --busca los datos de los ciudadanos con coincidencia
  --by Gregorio Herrera
  --30/06/2015
  --***************************************************************************************--
  procedure getCiudadanoDup(p_no_documento     in suirplus.sre_ciudadanos_t.no_documento%type,
                            p_nombres          suirplus.SRE_CIUDADANOS_T.nombres%TYPE,
                            p_primer_apellido  suirplus.SRE_CIUDADANOS_T.primer_apellido%TYPE,
                            p_segundo_apellido suirplus.SRE_CIUDADANOS_T.segundo_apellido%TYPE,
                            p_fecha_nacimiento suirplus.SRE_CIUDADANOS_T.Fecha_Nacimiento%TYPE,
                            p_sexo             suirplus.SRE_CIUDADANOS_T.Sexo%TYPE,
                            p_municipio_acta   suirplus.SRE_CIUDADANOS_T.Municipio_Acta%TYPE,
                            p_ano_acta         suirplus.SRE_CIUDADANOS_T.Ano_Acta%TYPE,
                            p_numero_acta      suirplus.SRE_CIUDADANOS_T.Numero_Acta%TYPE,
                            p_folio_acta       suirplus.SRE_CIUDADANOS_T.Folio_Acta%TYPE,
                            p_libro_acta       suirplus.SRE_CIUDADANOS_T.Libro_Acta%TYPE,
                            p_oficilia_acta    suirplus.SRE_CIUDADANOS_T.Oficialia_Acta%TYPE,
                            p_iocursor         out t_cursor,
                            p_resultnumber     out varchar2)
   is
    v_bderror varchar(1000);
    v_total   pls_integer;
    v_proceso varchar2(2) := 'J4';
  begin
    --virificamos si existe en ciudadanos con tipo de documento "C" sino lo buscamos por tipo de documento "U"
    select count(id_nss)
    into v_total
    FROM suirplus.SRE_CIUDADANOS_T c
    WHERE c.no_documento = p_no_documento
      and c.tipo_documento = 'C';
    
    if v_total > 0 then
      open p_iocursor for 
        select id_nss
        FROM suirplus.SRE_CIUDADANOS_T c
        WHERE c.no_documento = p_no_documento
          and c.tipo_documento = 'C';
      
      p_resultnumber := 0;
      return;
    end if;
  
    --buscamos por documento y tipo = 'U' o 'P'
    select count(id_nss)
    into v_total
    FROM suirplus.SRE_CIUDADANOS_T c
    WHERE c.no_documento = p_no_documento
      and c.tipo_documento in ('P', 'U'); 
    
    if v_total > 0 then
      open p_iocursor for
        select id_nss
        FROM suirplus.SRE_CIUDADANOS_T c
        WHERE c.no_documento = p_no_documento
          and c.tipo_documento in ('P', 'U'); 
      
      p_resultnumber := 0;
      return;
    end if;

    --buscamos por el nombre, acta, fecha nacimiento, y sexo si el tipo documento de la JCE es U o E
    IF p_municipio_acta is not null   AND p_ano_acta is not null
      AND p_numero_acta is not null   AND p_folio_acta is not null
      AND p_oficilia_acta is not null AND p_libro_acta is not null THEN

      declare
        l_nss_dup   number;        
        l_encendida boolean;
        l_resultado boolean;
        l_estatus   suirplus.sre_det_ciudadanos_api_t.estatus%type;
        l_id_error  suirplus.sre_det_ciudadanos_api_t.id_error%type;
      begin
        --Validacion #0
        l_resultado := suirplus.sre_validar_ciudadano_pkg.validar_acta_duplicada(p_municipio_acta,
                                                                                 p_ano_acta,
                                                                                 p_numero_acta,
                                                                                 p_folio_acta,
                                                                                 p_libro_acta,
                                                                                 p_oficilia_acta,
                                                                                 l_nss_dup,
                                                                                 v_proceso,
                                                                                 l_encendida,
                                                                                 l_estatus,
                                                                                 l_id_error); 
                                                                                     
        -- si esta encendida y falla la validacion
        if (l_encendida) and (NOT l_resultado) then
          open p_iocursor for
            select id_nss
              from suirplus.sre_ciudadanos_t
             where suirplus.sre_validar_ciudadano_pkg.limpiar_datos_acta(municipio_acta, ano_acta, numero_acta, folio_acta, libro_acta, oficialia_acta)
                 = suirplus.sre_validar_ciudadano_pkg.limpiar_datos_acta(p_municipio_acta, p_ano_acta, p_numero_acta, p_folio_acta, p_libro_acta, p_oficilia_acta)
               --  
               and (tipo_causa is null or tipo_causa = 'I')
               --
               and tipo_documento in ('U','N','E'); --Menor con o sin documento y extranjero
               
          p_resultnumber := 0;     
          RETURN;     
        end if;
        
        --Validacion #1
        l_resultado := suirplus.sre_validar_ciudadano_pkg.validar_nombre_acta_duplicada(p_municipio_acta,
                                                                                        p_ano_acta,
                                                                                        p_numero_acta,
                                                                                        P_folio_acta,
                                                                                        p_libro_acta,
                                                                                        p_oficilia_acta,
                                                                                        p_nombres,
                                                                                        p_primer_apellido,
                                                                                        p_sexo,
                                                                                        to_char(p_fecha_nacimiento,'ddmmyyyy'),
                                                                                        l_nss_dup,
                                                                                        v_proceso,
                                                                                        l_encendida,
                                                                                        l_estatus,
                                                                                        l_id_error); 
                                                                                     
        -- si esta encendida y falla la validacion
        if (l_encendida) and (NOT l_resultado) then
          open p_iocursor for          
            select id_nss
              from suirplus.sre_ciudadanos_t
             where suirplus.sre_validar_ciudadano_pkg.limpiar_datos_acta(municipio_acta, ano_acta, numero_acta, folio_acta, libro_acta, oficialia_acta)
                 = suirplus.sre_validar_ciudadano_pkg.limpiar_datos_acta(p_municipio_acta, p_ano_acta, p_numero_acta, p_folio_acta, p_libro_acta, p_oficilia_acta)
               --   
               and suirplus.sre_validar_ciudadano_pkg.sinnumeros(nombres, primer_apellido, sexo)
                 = suirplus.sre_validar_ciudadano_pkg.sinnumeros(p_nombres, p_primer_apellido, p_sexo)
               --  
               and fecha_nacimiento = p_fecha_nacimiento
               --
               and (tipo_causa is null or tipo_causa = 'I')
               --
               and tipo_documento in ('U','N','E'); --Menor con o sin documento y extranjero

          p_resultnumber := 0;     
          RETURN;
        end if;
        
        --Validacion #2
        l_resultado := suirplus.sre_validar_ciudadano_pkg.validar_nomacta_nofecha_dup(p_municipio_acta,
                                                                                      p_ano_acta,
                                                                                      p_numero_acta,
                                                                                      p_folio_acta,
                                                                                      p_libro_acta,
                                                                                      p_oficilia_acta,
                                                                                      p_nombres,
                                                                                      p_primer_apellido,
                                                                                      p_sexo,
                                                                                      l_nss_dup,
                                                                                      v_proceso,
                                                                                      l_encendida,
                                                                                      l_estatus,
                                                                                      l_id_error); 
                                                                                     
        -- si esta encendida y falla la validacion
        if (l_encendida) and (NOT l_resultado) then
          open p_iocursor for          
            select id_nss
              from suirplus.sre_ciudadanos_t
             where suirplus.sre_validar_ciudadano_pkg.limpiar_datos_acta(municipio_acta, ano_acta, numero_acta, folio_acta, libro_acta, oficialia_acta)
                 = suirplus.sre_validar_ciudadano_pkg.limpiar_datos_acta(p_municipio_acta, p_ano_acta, p_numero_acta, p_folio_acta, p_libro_acta, p_oficilia_acta)
               --   
               and suirplus.sre_validar_ciudadano_pkg.sinnumeros(nombres, primer_apellido, sexo)
                 = suirplus.sre_validar_ciudadano_pkg.sinnumeros(p_nombres, p_primer_apellido, p_sexo)
               --
               and (tipo_causa is null or tipo_causa = 'I')
               --
               and tipo_documento in ('U','N','E'); --Menor con o sin documento y extranjero

          p_resultnumber := 0;     
          RETURN;
        end if;
        
        --Validacion #3
        l_resultado := suirplus.sre_validar_ciudadano_pkg.validar_nomacta_nolibro_dup(p_municipio_acta,
                                                                                      p_ano_acta,
                                                                                      p_numero_acta,
                                                                                      p_folio_acta,
                                                                                      p_libro_acta,
                                                                                      p_oficilia_acta,
                                                                                      p_nombres,
                                                                                      p_primer_apellido,
                                                                                      to_char(p_fecha_nacimiento, 'ddmmyyyy'),
                                                                                      p_sexo,
                                                                                      l_nss_dup,
                                                                                      v_proceso,
                                                                                      l_encendida,
                                                                                      l_estatus,
                                                                                      l_id_error);
                                                                                         
        -- si esta encendida y falla la validacion
        if (l_encendida) and (NOT l_resultado) then
          open p_iocursor for          
            select id_nss
              from suirplus.sre_ciudadanos_t a
             where suirplus.sre_validar_ciudadano_pkg.sinnumeros(a.nombres, a.primer_apellido, a.sexo)
                 = suirplus.sre_validar_ciudadano_pkg.sinnumeros(p_nombres, p_primer_apellido, p_sexo)
               --  
               and a.fecha_nacimiento = p_fecha_nacimiento
               --
               and suirplus.sre_validar_ciudadano_pkg.limpiar_datos_acta(municipio_acta, ano_acta, numero_acta, folio_acta, libro_acta, oficialia_acta, p_exc => 'L')
                 = suirplus.sre_validar_ciudadano_pkg.limpiar_datos_acta(p_municipio_acta, p_ano_acta, p_numero_acta, p_folio_acta, p_libro_acta, p_oficilia_acta, p_exc => 'L')
               --  
               and suirplus.sre_validar_ciudadano_pkg.limpiar_libro_acta(a.libro_acta, a.ano_acta)
                != suirplus.sre_validar_ciudadano_pkg.limpiar_libro_acta(p_libro_acta, p_ano_acta)
               --
               and (tipo_causa is null or tipo_causa = 'I')
               --
               and tipo_documento in ('U','N','E'); --Menor con o sin documento y extranjero

          p_resultnumber := 0;     
          RETURN;
        end if;
        
        --Validacion #4
        l_resultado := suirplus.sre_validar_ciudadano_pkg.validar_nomacta_nosexo_dup(p_municipio_acta,
                                                                                     p_ano_acta,
                                                                                     p_numero_acta,
                                                                                     p_folio_acta,
                                                                                     p_libro_acta,
                                                                                     p_oficilia_acta,
                                                                                     p_nombres,
                                                                                     p_primer_apellido,
                                                                                     to_char(p_fecha_nacimiento,'ddmmyyyy'),
                                                                                     l_nss_dup,
                                                                                     v_proceso,
                                                                                     l_encendida,
                                                                                     l_estatus,
                                                                                     l_id_error); 
                                                                                     
        -- si esta encendida y falla la validacion
        if (l_encendida) and (NOT l_resultado) then
          open p_iocursor for          
            select id_nss
              from suirplus.sre_ciudadanos_t
             where suirplus.sre_validar_ciudadano_pkg.limpiar_datos_acta(municipio_acta, ano_acta, numero_acta, folio_acta, libro_acta, oficialia_acta)
                 = suirplus.sre_validar_ciudadano_pkg.limpiar_datos_acta(p_municipio_acta, p_ano_acta, p_numero_acta, p_folio_acta, p_libro_acta, p_oficilia_acta)
               --  
               and fecha_nacimiento = p_fecha_nacimiento
               --   
               and suirplus.sre_validar_ciudadano_pkg.sinnumeros(nombres, primer_apellido, null, 'S')
                 = suirplus.sre_validar_ciudadano_pkg.sinnumeros(p_nombres, p_primer_apellido, null, 'S')
               --
               and (tipo_causa is null or tipo_causa = 'I')
               --
               and tipo_documento in ('U','N','E'); --Menor con o sin documento y extranjero
               
          p_resultnumber := 0;
          RETURN;
        end if;
        
        --Validacion #5
        l_resultado := suirplus.sre_validar_ciudadano_pkg.validar_nomacta_nosexofech_dup(p_municipio_acta,
                                                                                         p_ano_acta,
                                                                                         p_numero_acta,
                                                                                         p_folio_acta,
                                                                                         p_libro_acta,
                                                                                         p_oficilia_acta,
                                                                                         p_nombres,
                                                                                         p_primer_apellido,
                                                                                         l_nss_dup,
                                                                                         v_proceso,
                                                                                         l_encendida,
                                                                                         l_estatus,
                                                                                         l_id_error); 
                                                                                     
        -- si esta encendida y falla la validacion
        if (l_encendida) and (NOT l_resultado) then
          open p_iocursor for          
            select id_nss
              from suirplus.sre_ciudadanos_t
             where suirplus.sre_validar_ciudadano_pkg.limpiar_datos_acta(municipio_acta, ano_acta, numero_acta, folio_acta, libro_acta, oficialia_acta)
                 = suirplus.sre_validar_ciudadano_pkg.limpiar_datos_acta(p_municipio_acta, p_ano_acta, p_numero_acta, p_folio_acta, p_libro_acta, p_oficilia_acta)
               --   
               and suirplus.sre_validar_ciudadano_pkg.sinnumeros(nombres, primer_apellido, null, 'S')
                 = suirplus.sre_validar_ciudadano_pkg.sinnumeros(p_nombres, p_primer_apellido, null, 'S')
               --
               and (tipo_causa is null or tipo_causa = 'I')
               --
               and tipo_documento in ('U','N','E'); --Menor con o sin documento y extranjero

          p_resultnumber := 0;
          RETURN;
        end if;

        --Validacion #6        
        l_resultado := suirplus.sre_validar_ciudadano_pkg.validar_nombre_duplicado(p_nombres,
                                                                                   p_primer_apellido,
                                                                                   to_char(p_fecha_nacimiento,'ddmmyyyy'),
                                                                                   p_sexo,
                                                                                   l_nss_dup,
                                                                                   v_proceso,
                                                                                   l_encendida,
                                                                                   l_estatus,
                                                                                   l_id_error); 
                                                                                     
        -- si esta encendida y falla la validacion
        if (l_encendida) and (NOT l_resultado) then
          open p_iocursor for          
            select id_nss
              from suirplus.sre_ciudadanos_t a
             where suirplus.sre_validar_ciudadano_pkg.sinNumeros(a.nombres, a.primer_apellido, a.sexo)
                 = suirplus.sre_validar_ciudadano_pkg.sinNumeros(p_nombres, p_primer_apellido, p_sexo)
               --  
               and a.fecha_nacimiento = p_fecha_nacimiento
               --
               and (a.tipo_causa is null or a.tipo_causa = 'I')
               --
               and a.tipo_documento in ('U','N','E'); --Menor con o sin documento y extranjero

          p_resultnumber := 0;
          RETURN;
        end if;        
      end;
           
      select count(id_nss)
      into v_total
      FROM suirplus.SRE_CIUDADANOS_T c
      WHERE tipo_documento = 'N'
        and suirplus.sre_validar_ciudadano_pkg.sinnumeros(c.nombres, c.primer_apellido, c.sexo)
          = suirplus.sre_validar_ciudadano_pkg.sinnumeros(p_nombres, p_primer_apellido, p_sexo) 
         --
        and c.fecha_nacimiento = p_fecha_nacimiento
         --
        and suirplus.sre_validar_ciudadano_pkg.limpiar_datos_acta(municipio_acta,ano_acta,numero_acta,folio_acta,libro_acta,oficialia_acta)
          = suirplus.sre_validar_ciudadano_pkg.limpiar_datos_acta(p_municipio_acta,p_ano_acta,p_numero_acta,p_folio_acta,p_libro_acta,p_oficilia_acta)
         --                      
        and (tipo_causa is null or tipo_causa = 'I');

      if v_total > 0 then
        open p_iocursor for
          select id_nss
          FROM suirplus.SRE_CIUDADANOS_T c
          WHERE tipo_documento = 'N'
            and suirplus.sre_validar_ciudadano_pkg.sinnumeros(c.nombres, c.primer_apellido, c.sexo)
              = suirplus.sre_validar_ciudadano_pkg.sinnumeros(p_nombres, p_primer_apellido, p_sexo) 
             --
            and c.fecha_nacimiento = p_fecha_nacimiento
             --
            and suirplus.sre_validar_ciudadano_pkg.limpiar_datos_acta(municipio_acta,ano_acta,numero_acta,folio_acta,libro_acta,oficialia_acta)
              = suirplus.sre_validar_ciudadano_pkg.limpiar_datos_acta(p_municipio_acta,p_ano_acta,p_numero_acta,p_folio_acta,p_libro_acta,p_oficilia_acta)
             --                      
            and (tipo_causa is null or tipo_causa = 'I');
            
        p_resultnumber := 0;
        return;
      end if;
    end if;
    
    --Para la definicion del cursor en caso de NO coincidencia
    open p_iocursor for
      select id_nss
      from suirplus.sre_ciudadanos_t
      where id_nss = 0;
      
    p_resultnumber := 0;
  exception
    when others then
      v_bderror      := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultnumber := suirplus.Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
  end;

  --***************************************************************************************--
  --procesa un ciudadano, si no existe lo inserta, de lo contrario lo actualiza...
  --by charlie pena
  --02/ago/2011
  --modificado by: cmha
  --31/06/15
  --***************************************************************************************--
  PROCEDURE procesarCiudadano(p_no_documento         suirplus.SRE_CIUDADANOS_T.no_documento%TYPE,
                              p_nombres              suirplus.SRE_CIUDADANOS_T.nombres%TYPE,
                              p_primer_apellido      suirplus.SRE_CIUDADANOS_T.primer_apellido%TYPE,
                              p_segundo_apellido     suirplus.SRE_CIUDADANOS_T.segundo_apellido%TYPE,
                              p_estado_civil         suirplus.SRE_CIUDADANOS_T.Estado_Civil%TYPE,
                              p_fecha_nacimiento     suirplus.SRE_CIUDADANOS_T.Fecha_Nacimiento%TYPE,
                              p_sexo                 suirplus.SRE_CIUDADANOS_T.sexo%TYPE,
                              p_id_tipo_sangre       suirplus.SRE_CIUDADANOS_T.Id_Tipo_Sangre%TYPE,
                              p_id_nacionalidad      suirplus.SRE_CIUDADANOS_T.Id_Nacionalidad%TYPE,
                              p_nombre_padre         suirplus.SRE_CIUDADANOS_T.Nombre_Padre%TYPE,
                              p_nombre_madre         suirplus.SRE_CIUDADANOS_T.Nombre_Madre%TYPE,
                              p_municipio_acta       suirplus.SRE_CIUDADANOS_T.Municipio_Acta%TYPE,
                              p_oficialia_acta       suirplus.SRE_CIUDADANOS_T.Oficialia_Acta%TYPE,
                              p_libro_acta           suirplus.SRE_CIUDADANOS_T.Libro_Acta%TYPE,
                              p_folio_acta           suirplus.SRE_CIUDADANOS_T.Folio_Acta%TYPE,
                              p_numero_acta          suirplus.SRE_CIUDADANOS_T.Numero_Acta%TYPE,
                              p_ano_acta             suirplus.SRE_CIUDADANOS_T.Ano_Acta%TYPE,
                              p_tipo_causa           suirplus.SRE_CIUDADANOS_T.tipo_causa%TYPE,
                              p_id_causa_inhabilidad suirplus.SRE_CIUDADANOS_T.id_causa_inhabilidad%TYPE,
                              p_status               suirplus.SRE_CIUDADANOS_T.Status%TYPE,
                              p_ult_usuario_act      suirplus.SRE_CIUDADANOS_T.ULT_USUARIO_ACT%TYPE,
                              p_accion               in varchar, --I = insertar,A = actualizar
                              p_fecha_cancelacion    in suirplus.sre_ciudadanos_cancelados_t.fecha_de_cancelacion%type,
                              p_nss                  in out suirplus.SRE_CIUDADANOS_T.ID_NSS%TYPE,
                              p_resultnumber         IN OUT VARCHAR2)
  
   IS
    v_fallecido            integer;
    v_count                integer;
    v_municipio_acta       suirplus.sre_ciudadanos_t.MUNICIPIO_ACTA%type;
    v_sangre               suirplus.sre_ciudadanos_t.ID_TIPO_SANGRE%type;
    v_nacion               suirplus.sre_ciudadanos_t.ID_NACIONALIDAD%type;
    v_idInhabilidad        suirplus.sre_ciudadanos_t.id_causa_inhabilidad%type;
    v_tipoCausa            suirplus.sre_ciudadanos_t.tipo_causa%type;
    v_stadoCivilConstraint long;
    v_existe               integer := 0;
    v_nss                  number(9);
  BEGIN
  
    -- verificamos municipio ------------------------------------------------------------------------------
    if p_municipio_acta is not null then
      begin
        select id_municipio
          into v_municipio_acta
          from suirplus.sre_municipio_t
         where id_municipio = replace(p_municipio_acta, chr(0), '');
      exception
        when no_data_found then
          p_resultnumber := 'El código de municipio no existe en TSS';
          return;
      end;
    end if;
    --verificamos sangre ---------------------------------------------------------------------------------
    if p_id_tipo_sangre is not null then
      begin
        select ID_TIPO_SANGRE
          into v_sangre
          from suirplus.sre_tipo_sangre_t
         where ID_TIPO_SANGRE = replace(p_id_tipo_sangre, chr(0), '');
      exception
        when no_data_found then
          p_resultnumber := 'El código de tipo de sangre no existe en TSS';
          return;
      end;
    end if;
    --verificamos nacionalidad ---------------------------------------------------------------------------
    if p_id_nacionalidad is not null then
      begin
        select id_nacionalidad
          into v_nacion
          from suirplus.sre_nacionalidad_t
         where id_nacionalidad = replace(p_id_nacionalidad, chr(0), '');
      exception
        when no_data_found then
          p_resultnumber := 'El código de nacionalidad no existe en TSS';
          return;
      end;
    end if;
    --verificamos la inhabilidad ---------------------------------------------------------------------------
    if (p_id_causa_inhabilidad is not null) and (p_tipo_causa is not null) then
      begin
        select i.id_causa_inhabilidad, i.tipo_causa
          into v_idInhabilidad, v_tipoCausa
          from suirplus.sre_inhabilidad_jce_t i
         where i.id_causa_inhabilidad =
               replace(p_id_causa_inhabilidad, chr(0), '')
           and i.tipo_causa = replace(p_tipo_causa, chr(0), '');
      exception
        when no_data_found then
          p_resultnumber := 'El código de inhabilidad no existe en TSS';
          return;
      end;
    end if;
  
    --verificamos el estado civil
    begin
      for r1 in (select a.*
                   from all_constraints a
                  where a.table_name = 'SRE_CIUDADANOS_T'
                    and a.OWNER = 'SUIRPLUS') loop
        if (instr(lower(r1.search_condition), lower('ESTADO_CIVIL')) > 0) and
           (instr(lower(r1.search_condition),
                  lower('''' || p_estado_civil || '''')) > 0) then
          v_existe := v_existe + 1;
        end if;
      end loop;
      v_stadoCivilConstraint := v_existe;
    end;
  
    if v_stadoCivilConstraint = '0' then
      p_resultnumber := 'El estado civil del ciudadano no existe en TSS';
      return;
    end if;
  
    DECLARE
      r_TSS suirplus.sre_ciudadanos_t%ROWTYPE;
    BEGIN
      if p_accion = 'A' then
        select * into r_TSS from suirplus.sre_ciudadanos_t where id_nss = p_nss;
      
        --Si en TSS esta FALLECIDO
        select count(*)
          into v_fallecido
          from suirplus.sre_det_novedades_fallecidos_t f
         where f.num_cedula = replace(p_no_documento, chr(0), '')
           and f.status = 'OK';
       end if;    
         
      /*
         CASO 1
      */
      -- Viene de la JCE CANCELADO
      if NVL(p_tipo_causa, '~') = 'C' and p_accion = 'A' Then
        --Si en TSS esta CANCELADO POR CAUSA distinta a JCE y NO FALLECIDO
        if (NVL(r_TSS.tipo_causa, '~') <> NVL(p_tipo_causa, '~') OR
            NVL(r_TSS.ID_CAUSA_INHABILIDAD, 0) <> NVL(p_id_causa_inhabilidad, 0)) and
           (v_fallecido = 0) then
          --actualizamos segun la JCE e insertamos en el HISTORICO
          update suirplus.sre_ciudadanos_t
             set TIPO_DOCUMENTO       = 'C',
                 NO_DOCUMENTO         = replace(p_no_documento, chr(0), ''),
                 NOMBRES              = replace(p_nombres, chr(0), ''),
                 PRIMER_APELLIDO      = replace(p_primer_apellido, chr(0),''),
                 SEGUNDO_APELLIDO     = replace(p_segundo_apellido,chr(0),''),
                 ESTADO_CIVIL         = replace(nvl(p_estado_civil, 'S'),chr(0),''),
                 FECHA_NACIMIENTO     = trunc(p_fecha_nacimiento),
                 SEXO                 = replace(nvl(p_sexo, 'M'),chr(0),''),
                 ID_PROVINCIA         = null,
                 ID_TIPO_SANGRE       = v_sangre,
                 ID_NACIONALIDAD      = v_nacion,
                 NOMBRE_PADRE         = replace(nvl(p_nombre_padre,NOMBRE_PADRE),chr(0),''),
                 NOMBRE_MADRE         = replace(nvl(p_nombre_madre,NOMBRE_MADRE),chr(0),''),
                 MUNICIPIO_ACTA       = suirplus.sre_Validar_Ciudadano_pkg.limpiar_municipio_acta(replace(p_municipio_acta, chr(0), '')),   
                 ANO_ACTA             = suirplus.sre_Validar_Ciudadano_pkg.limpiar_ano_acta(replace(p_ano_acta, chr(0), '')),
                 NUMERO_ACTA          = suirplus.sre_Validar_Ciudadano_pkg.limpiar_numero_acta(replace(p_numero_acta, chr(0), '')),
                 FOLIO_ACTA           = suirplus.sre_Validar_Ciudadano_pkg.limpiar_folio_acta( replace(p_folio_acta, chr(0), '')),
                 LIBRO_ACTA           = suirplus.sre_Validar_Ciudadano_pkg.limpiar_libro_acta(replace(p_libro_acta, chr(0), ''),replace(p_ano_acta, chr(0), '')),
                 OFICIALIA_ACTA       = suirplus.sre_Validar_Ciudadano_pkg.limpiar_oficialia_acta(replace(p_oficialia_acta,chr(0),'')),
                 STATUS               = replace(p_status, chr(0), ''),
                 ULT_FECHA_ACT        = sysdate,
                 ULT_USUARIO_ACT      = p_ULT_USUARIO_ACT,
                 TIPO_CAUSA           = replace(p_tipo_Causa, chr(0), ''),
                 ID_CAUSA_INHABILIDAD = replace(p_id_causa_Inhabilidad, chr(0), '')
           where ID_NSS = replace(p_nss, chr(0), '');
          commit;
            
          --Debe insertar en historico
          suirplus.sre_ciudadano_pkg.Insertar_Ciudadano_Cancelado(null,
                                                         p_nss,
                                                         replace(p_tipo_causa,  chr(0), ''),
                                                         replace(p_id_causa_inhabilidad, Chr(0), ''),
                                                         nvl(p_fecha_cancelacion, sysdate),
                                                         p_ULT_USUARIO_ACT);

          p_resultnumber := '0';
          RETURN;
        end if;
      end if;
        
      /*
         CASO 2
      */
      -- Viene de la JCE CANCELADO
      if NVL(p_tipo_causa, '~') = 'C' and p_accion = 'A' Then
        --Si en TSS esta CANCELADO por JCE y NO FALLECIDO
        if NVL(r_TSS.tipo_causa, '~') = NVL(p_tipo_causa, '~') AND
           NVL(r_TSS.ID_CAUSA_INHABILIDAD, 0) =  NVL(p_id_causa_inhabilidad, 0) and
           (v_fallecido = 0) then
          --actualizamos segun la JCE
          update suirplus.sre_ciudadanos_t
             set TIPO_DOCUMENTO       = 'C',
                 NO_DOCUMENTO         = replace(p_no_documento, chr(0), ''),
                 NOMBRES              = replace(p_nombres, chr(0), ''),
                 PRIMER_APELLIDO      = replace(p_primer_apellido, chr(0),''),
                 SEGUNDO_APELLIDO     = replace(p_segundo_apellido,chr(0),''),
                 ESTADO_CIVIL         = replace(nvl(p_estado_civil, 'S'),chr(0),''),
                 FECHA_NACIMIENTO     = trunc(p_fecha_nacimiento),
                 SEXO                 = replace(nvl(p_sexo, 'M'), chr(0),''),
                 ID_PROVINCIA         = null,
                 ID_TIPO_SANGRE       = v_sangre,
                 ID_NACIONALIDAD      = v_nacion,
                 NOMBRE_PADRE         = replace(nvl(p_nombre_padre, NOMBRE_PADRE),chr(0),''),
                 NOMBRE_MADRE         = replace(nvl(p_nombre_madre, NOMBRE_MADRE),chr(0),''),
                 MUNICIPIO_ACTA       = suirplus.sre_Validar_Ciudadano_pkg.limpiar_municipio_acta(replace(p_municipio_acta, chr(0), '')),   
                 ANO_ACTA             = suirplus.sre_Validar_Ciudadano_pkg.limpiar_ano_acta(replace(p_ano_acta, chr(0), '')),
                 NUMERO_ACTA          = suirplus.sre_Validar_Ciudadano_pkg.limpiar_numero_acta(replace(p_numero_acta, chr(0), '')),
                 FOLIO_ACTA           = suirplus.sre_Validar_Ciudadano_pkg.limpiar_folio_acta( replace(p_folio_acta, chr(0), '')),
                 LIBRO_ACTA           = suirplus.sre_Validar_Ciudadano_pkg.limpiar_libro_acta(replace(p_libro_acta, chr(0), ''),replace(p_ano_acta, chr(0), '')),
                 OFICIALIA_ACTA       = suirplus.sre_Validar_Ciudadano_pkg.limpiar_oficialia_acta(replace(p_oficialia_acta,chr(0),'')),
                 STATUS               = replace(p_status, chr(0), ''),
                 ULT_FECHA_ACT        = sysdate,
                 ULT_USUARIO_ACT      = p_ULT_USUARIO_ACT,
                 TIPO_CAUSA           = replace(p_tipo_Causa, chr(0), ''),
                 ID_CAUSA_INHABILIDAD = replace(p_id_causa_Inhabilidad, chr(0),'')
           where ID_NSS = replace(p_nss, chr(0), '');
          commit;

          p_resultnumber := '0';
          RETURN;
        end if;
      end if;
        
      /*
         CASO 3
      */
      -- Viene de la JCE CANCELADO
      if NVL(p_tipo_causa, '~') = 'C' and p_accion = 'A' Then
        --Si en TSS esta CANCELADO Y NO FALLECIDO
        if NVL(r_TSS.tipo_causa, '~') = NVL(p_tipo_causa, '~') AND
           NVL(r_TSS.ID_CAUSA_INHABILIDAD, 0) >= 100 and
           (v_fallecido = 0) then
          --actualizamos segun la JCE e insertamos en el HISTORICO
          update suirplus.sre_ciudadanos_t
             set TIPO_DOCUMENTO       = 'C',
                 NO_DOCUMENTO         = replace(p_no_documento, chr(0), ''),
                 NOMBRES              = replace(p_nombres, chr(0), ''),
                 PRIMER_APELLIDO      = replace(p_primer_apellido, chr(0),''),
                 SEGUNDO_APELLIDO     = replace(p_segundo_apellido, chr(0),''),
                 ESTADO_CIVIL         = replace(nvl(p_estado_civil, 'S'), chr(0),''),
                 FECHA_NACIMIENTO     = trunc(p_fecha_nacimiento),
                 SEXO                 = replace(nvl(p_sexo, 'M'), chr(0),''),
                 ID_PROVINCIA         = null,
                 ID_TIPO_SANGRE       = v_sangre,
                 ID_NACIONALIDAD      = v_nacion,
                 NOMBRE_PADRE         = replace(nvl(p_nombre_padre,NOMBRE_PADRE),chr(0),''),
                 NOMBRE_MADRE         = replace(nvl(p_nombre_madre, NOMBRE_MADRE),chr(0),''),
                 MUNICIPIO_ACTA       = suirplus.sre_Validar_Ciudadano_pkg.limpiar_municipio_acta(replace(p_municipio_acta, chr(0), '')),   
                 ANO_ACTA             = suirplus.sre_Validar_Ciudadano_pkg.limpiar_ano_acta(replace(p_ano_acta, chr(0), '')),
                 NUMERO_ACTA          = suirplus.sre_Validar_Ciudadano_pkg.limpiar_numero_acta(replace(p_numero_acta, chr(0), '')),
                 FOLIO_ACTA           = suirplus.sre_Validar_Ciudadano_pkg.limpiar_folio_acta( replace(p_folio_acta, chr(0), '')),
                 LIBRO_ACTA           = suirplus.sre_Validar_Ciudadano_pkg.limpiar_libro_acta(replace(p_libro_acta, chr(0), ''),replace(p_ano_acta, chr(0), '')),
                 OFICIALIA_ACTA       = suirplus.sre_Validar_Ciudadano_pkg.limpiar_oficialia_acta(replace(p_oficialia_acta,chr(0),'')),
                 STATUS               = replace(p_status, chr(0), ''),
                 ULT_FECHA_ACT        = sysdate,
                 ULT_USUARIO_ACT      = p_ULT_USUARIO_ACT,
                 TIPO_CAUSA           = replace(p_tipo_Causa, chr(0), ''),
                 ID_CAUSA_INHABILIDAD = replace(p_id_causa_Inhabilidad,chr(0),'')
           where ID_NSS = replace(p_nss, chr(0), '');
          commit;
            
          --Debe insertar en historico
          suirplus.sre_ciudadano_pkg.Insertar_Ciudadano_Cancelado(null,
                                                         p_nss,
                                                         replace(p_tipo_causa, chr(0), ''),
                                                         replace(p_id_causa_inhabilidad, chr(0), ''),
                                                         nvl(p_fecha_cancelacion, sysdate),
                                                         p_ULT_USUARIO_ACT);

          p_resultnumber := '0';
          RETURN;                                               
        end if;
      end if;
          
     /*
      CASO 4
     */
       -- Viene de la JCE CANCELADO
      if NVL(p_tipo_causa, '~') = 'C' and p_accion = 'A' Then
        --Si en TSS esta INHABILIDATADO y NO FALLECIDO
        if NVL(r_TSS.tipo_causa, '~') = 'I' and (v_fallecido = 0) then
          --actualizamos segun la JCE e insertamos en el HISTORICO
          update suirplus.sre_ciudadanos_t
             set TIPO_DOCUMENTO       = 'C',
                 NO_DOCUMENTO         = replace(p_no_documento, chr(0), ''),
                 NOMBRES              = replace(p_nombres, chr(0), ''),
                 PRIMER_APELLIDO      = replace(p_primer_apellido, chr(0),''),
                 SEGUNDO_APELLIDO     = replace(p_segundo_apellido,chr(0),''),
                 ESTADO_CIVIL         = replace(nvl(p_estado_civil, 'S'),chr(0),''),
                 FECHA_NACIMIENTO     = trunc(p_fecha_nacimiento),
                 SEXO                 = replace(nvl(p_sexo, 'M'),chr(0),''),
                 ID_PROVINCIA         = null,
                 ID_TIPO_SANGRE       = v_sangre,
                 ID_NACIONALIDAD      = v_nacion,
                 NOMBRE_PADRE         = replace(nvl(p_nombre_padre,NOMBRE_PADRE),chr(0),''),
                 NOMBRE_MADRE         = replace(nvl(p_nombre_madre,NOMBRE_MADRE),chr(0),''),
                 MUNICIPIO_ACTA       = suirplus.sre_Validar_Ciudadano_pkg.limpiar_municipio_acta(replace(p_municipio_acta, chr(0), '')),   
                 ANO_ACTA             = suirplus.sre_Validar_Ciudadano_pkg.limpiar_ano_acta(replace(p_ano_acta, chr(0), '')),
                 NUMERO_ACTA          = suirplus.sre_Validar_Ciudadano_pkg.limpiar_numero_acta(replace(p_numero_acta, chr(0), '')),
                 FOLIO_ACTA           = suirplus.sre_Validar_Ciudadano_pkg.limpiar_folio_acta( replace(p_folio_acta, chr(0), '')),
                 LIBRO_ACTA           = suirplus.sre_Validar_Ciudadano_pkg.limpiar_libro_acta(replace(p_libro_acta, chr(0), ''),replace(p_ano_acta, chr(0), '')),
                 OFICIALIA_ACTA       = suirplus.sre_Validar_Ciudadano_pkg.limpiar_oficialia_acta(replace(p_oficialia_acta,chr(0),'')),
                 STATUS               = replace(p_status, chr(0), ''),
                 ULT_FECHA_ACT        = sysdate,
                 ULT_USUARIO_ACT      = p_ULT_USUARIO_ACT,
                 TIPO_CAUSA           = replace(p_tipo_Causa, chr(0), ''),
                 ID_CAUSA_INHABILIDAD = replace(p_id_causa_Inhabilidad, chr(0), '')
           where ID_NSS = replace(p_nss, chr(0), '');
          commit;
            
          --Debe insertar en historico
          suirplus.sre_ciudadano_pkg.Insertar_Ciudadano_Cancelado(null,
                                                         p_nss,
                                                         replace(p_tipo_causa, chr(0), ''),
                                                         replace(p_id_causa_inhabilidad, chr(0), ''),
                                                         nvl(p_fecha_cancelacion, sysdate),
                                                         p_ULT_USUARIO_ACT);

          p_resultnumber := '0';
          RETURN;                                               
        end if;
      end if;
          
      /*
       CASO 5
      */
      -- Viene de la JCE CANCELADO
      if NVL(p_tipo_causa, '~') = 'C' and p_accion = 'A' Then
        --Si en TSS esta NULO y NO FALLECIDO
        if NVL(r_TSS.tipo_causa, '~') = '~' and (v_fallecido = 0) then
          --actualizamos segun la JCE e insertamos en el HISTORICO
          update suirplus.sre_ciudadanos_t
             set TIPO_DOCUMENTO       = 'C',
                 NO_DOCUMENTO         = replace(p_no_documento, chr(0), ''),
                 NOMBRES              = replace(p_nombres, chr(0), ''),
                 PRIMER_APELLIDO      = replace(p_primer_apellido, chr(0),''),
                 SEGUNDO_APELLIDO     = replace(p_segundo_apellido,chr(0),''),
                 ESTADO_CIVIL         = replace(nvl(p_estado_civil, 'S'),chr(0),''),
                 FECHA_NACIMIENTO     = trunc(p_fecha_nacimiento),
                 SEXO                 = replace(nvl(p_sexo, 'M'),chr(0),''),
                 ID_PROVINCIA         = null,
                 ID_TIPO_SANGRE       = v_sangre,
                 ID_NACIONALIDAD      = v_nacion,
                 NOMBRE_PADRE         = replace(nvl(p_nombre_padre,NOMBRE_PADRE),chr(0),''),
                 NOMBRE_MADRE         = replace(nvl(p_nombre_madre,NOMBRE_MADRE),chr(0),''),
                 MUNICIPIO_ACTA       = suirplus.sre_Validar_Ciudadano_pkg.limpiar_municipio_acta(replace(p_municipio_acta, chr(0), '')),   
                 ANO_ACTA             = suirplus.sre_Validar_Ciudadano_pkg.limpiar_ano_acta(replace(p_ano_acta, chr(0), '')),
                 NUMERO_ACTA          = suirplus.sre_Validar_Ciudadano_pkg.limpiar_numero_acta(replace(p_numero_acta, chr(0), '')),
                 FOLIO_ACTA           = suirplus.sre_Validar_Ciudadano_pkg.limpiar_folio_acta( replace(p_folio_acta, chr(0), '')),
                 LIBRO_ACTA           = suirplus.sre_Validar_Ciudadano_pkg.limpiar_libro_acta(replace(p_libro_acta, chr(0), ''),replace(p_ano_acta, chr(0), '')),
                 OFICIALIA_ACTA       = suirplus.sre_Validar_Ciudadano_pkg.limpiar_oficialia_acta(replace(p_oficialia_acta,chr(0),'')),
                 STATUS               = replace(p_status, chr(0), ''),
                 ULT_FECHA_ACT        = sysdate,
                 ULT_USUARIO_ACT      = p_ULT_USUARIO_ACT,
                 TIPO_CAUSA           = replace(p_tipo_Causa, chr(0), ''),
                 ID_CAUSA_INHABILIDAD = replace(p_id_causa_Inhabilidad, chr(0), '')
           where ID_NSS = replace(p_nss, chr(0), '');
          commit;
            
          --Debe insertar en historico
          suirplus.sre_ciudadano_pkg.Insertar_Ciudadano_Cancelado(null,
                                                         p_nss,
                                                         replace(p_tipo_causa, chr(0), ''),
                                                         replace(p_id_causa_inhabilidad, chr(0), ''),
                                                         nvl(p_fecha_cancelacion, sysdate),
                                                         p_ULT_USUARIO_ACT);

          p_resultnumber := '0';
          RETURN;                                               
        end if;
      end if;        
        
      /*
       CASO 6
      */
      -- Viene de la JCE CANCELADO
      if NVL(p_tipo_causa, '~') = 'C' and p_accion = 'A' Then
        if v_fallecido > 0 then
          --actualizamos segun la JCE
          update suirplus.sre_ciudadanos_t
             set TIPO_DOCUMENTO       = 'C',
                 NO_DOCUMENTO         = replace(p_no_documento, chr(0), ''),
                 NOMBRES              = replace(p_nombres, chr(0), ''),
                 PRIMER_APELLIDO      = replace(p_primer_apellido, chr(0),''),
                 SEGUNDO_APELLIDO     = replace(p_segundo_apellido,chr(0),''),
                 ESTADO_CIVIL         = replace(nvl(p_estado_civil, 'S'),chr(0),''),
                 FECHA_NACIMIENTO     = trunc(p_fecha_nacimiento),
                 SEXO                 = replace(nvl(p_sexo, 'M'),chr(0),''),
                 ID_PROVINCIA         = null,
                 ID_TIPO_SANGRE       = v_sangre,
                 ID_NACIONALIDAD      = v_nacion,
                 NOMBRE_PADRE         = replace(nvl(p_nombre_padre,NOMBRE_PADRE),chr(0),''),
                 NOMBRE_MADRE         = replace(nvl(p_nombre_madre,NOMBRE_MADRE),chr(0),''),
                 MUNICIPIO_ACTA       = suirplus.sre_Validar_Ciudadano_pkg.limpiar_municipio_acta(replace(p_municipio_acta, chr(0), '')),   
                 ANO_ACTA             = suirplus.sre_Validar_Ciudadano_pkg.limpiar_ano_acta(replace(p_ano_acta, chr(0), '')),
                 NUMERO_ACTA          = suirplus.sre_Validar_Ciudadano_pkg.limpiar_numero_acta(replace(p_numero_acta, chr(0), '')),
                 FOLIO_ACTA           = suirplus.sre_Validar_Ciudadano_pkg.limpiar_folio_acta( replace(p_folio_acta, chr(0), '')),
                 LIBRO_ACTA           = suirplus.sre_Validar_Ciudadano_pkg.limpiar_libro_acta(replace(p_libro_acta, chr(0), ''),replace(p_ano_acta, chr(0), '')),
                 OFICIALIA_ACTA       = suirplus.sre_Validar_Ciudadano_pkg.limpiar_oficialia_acta(replace(p_oficialia_acta,chr(0),'')),
                 STATUS               = replace(p_status, chr(0), ''),
                 ULT_FECHA_ACT        = sysdate,
                 ULT_USUARIO_ACT      = p_ULT_USUARIO_ACT
           where ID_NSS = replace(p_nss, chr(0), '');
          commit;

          p_resultnumber := '0';
          RETURN;
        end if;
      end if;      
          
      /*
       CASO 7, 8, 9 y 10
       no se hace nada con estos casos en este metodo.
       estos se ejecuta en el metodo getciudadano.
      */
          
      /*
       CASO 11
      */
      -- Viene de la JCE CANCELADO
      if NVL(p_tipo_causa, '~') = 'C' and p_accion = 'A' Then
        --Si en TSS existe MENOR con igual acta que la JCE y NO FALLECIDO
        select count(*)
          into v_count
          from suirplus.sre_ciudadanos_t c
         where nvl(c.no_documento,'~') = '~' 
          and  suirplus.sre_Validar_Ciudadano_pkg.limpiar_datos_acta(c.municipio_acta, c.ano_acta,c.numero_acta,c.folio_acta, c.libro_acta,c.oficialia_acta) 
             = suirplus.sre_Validar_Ciudadano_pkg.limpiar_datos_acta(p_municipio_acta,p_ano_acta,p_numero_acta,p_folio_acta,p_libro_acta,p_oficialia_acta);
  
        if v_count > 0 and v_fallecido = 0 then
          --actualizamos segun la JCE e insertamos en el HISTORICO
          update suirplus.sre_ciudadanos_t
             set TIPO_DOCUMENTO       = 'C',
                 NO_DOCUMENTO         = replace(p_no_documento, chr(0), ''),
                 NOMBRES              = replace(p_nombres, chr(0), ''),
                 PRIMER_APELLIDO      = replace(p_primer_apellido, chr(0),''),
                 SEGUNDO_APELLIDO     = replace(p_segundo_apellido,chr(0),''),
                 ESTADO_CIVIL         = replace(nvl(p_estado_civil, 'S'),chr(0),''),
                 FECHA_NACIMIENTO     = trunc(p_fecha_nacimiento),
                 SEXO                 = replace(nvl(p_sexo, 'M'),chr(0),''),
                 ID_PROVINCIA         = null,
                 ID_TIPO_SANGRE       = v_sangre,
                 ID_NACIONALIDAD      = v_nacion,
                 NOMBRE_PADRE         = replace(nvl(p_nombre_padre,NOMBRE_PADRE),chr(0),''),
                 NOMBRE_MADRE         = replace(nvl(p_nombre_madre,NOMBRE_MADRE),chr(0),''),
                 MUNICIPIO_ACTA       = suirplus.sre_Validar_Ciudadano_pkg.limpiar_municipio_acta(replace(p_municipio_acta, chr(0), '')),   
                 ANO_ACTA             = suirplus.sre_Validar_Ciudadano_pkg.limpiar_ano_acta(replace(p_ano_acta, chr(0), '')),
                 NUMERO_ACTA          = suirplus.sre_Validar_Ciudadano_pkg.limpiar_numero_acta(replace(p_numero_acta, chr(0), '')),
                 FOLIO_ACTA           = suirplus.sre_Validar_Ciudadano_pkg.limpiar_folio_acta( replace(p_folio_acta, chr(0), '')),
                 LIBRO_ACTA           = suirplus.sre_Validar_Ciudadano_pkg.limpiar_libro_acta(replace(p_libro_acta, chr(0), ''),replace(p_ano_acta, chr(0), '')),
                 OFICIALIA_ACTA       = suirplus.sre_Validar_Ciudadano_pkg.limpiar_oficialia_acta(replace(p_oficialia_acta,chr(0),'')),
                 STATUS               = replace(p_status, chr(0), ''),
                 ULT_FECHA_ACT        = sysdate,
                 ULT_USUARIO_ACT      = p_ULT_USUARIO_ACT,
                 TIPO_CAUSA           = replace(P_tipo_causa, chr(0), ''),
                 ID_CAUSA_INHABILIDAD = replace(P_id_causa_inhabilidad, chr(0), '')
           where ID_NSS = replace(p_nss, chr(0), '');
          commit;
            
          --Debe insertar en historico
          suirplus.sre_ciudadano_pkg.Insertar_Ciudadano_Cancelado(null,
                                                         p_nss,
                                                         replace(p_tipo_causa, chr(0), ''),
                                                         replace(p_id_causa_inhabilidad, chr(0), ''),
                                                         nvl(p_fecha_cancelacion, sysdate),
                                                         p_ULT_USUARIO_ACT);

          p_resultnumber := '0';
          RETURN;                                               
        end if;
      end if;    

      /*
        CASO 12
      */
      -- Viene de la JCE CANCELADO
      if NVL(p_tipo_causa, '~') = 'C' and p_accion = 'I' then
        --Insertamos el nuevo ciudadano -----------------------------------------------------------
        insert into suirplus.sre_ciudadanos_t
          (nombres,
           primer_apellido,
           segundo_apellido,
           estado_civil,
           fecha_nacimiento,
           no_documento,
           tipo_documento,
           sexo,
           id_provincia,
           id_tipo_sangre,
           id_nacionalidad,
           nombre_padre,
           nombre_madre,
           fecha_registro,
           fecha_expedicion,
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
           id_causa_inhabilidad)
        values
          (replace(p_nombres, chr(0), ''),
           replace(p_primer_apellido, chr(0), ''),
           replace(p_segundo_apellido, chr(0), ''),
           replace(nvl(p_estado_civil, 'S'), chr(0), ''),
           trunc(p_fecha_nacimiento),
           replace(p_no_documento, chr(0), ''),
           'C',
           replace(nvl(p_sexo, 'M'), chr(0), ''),
           null,
           v_sangre,
           v_nacion,
           replace(p_nombre_padre, chr(0), ''),
           replace(p_nombre_madre, chr(0), ''),
           sysdate,
           null,
           suirplus.sre_Validar_Ciudadano_pkg.limpiar_municipio_acta(replace(p_municipio_acta, chr(0), '')),   
           suirplus.sre_Validar_Ciudadano_pkg.limpiar_ano_acta(replace(p_ano_acta, chr(0), '')),
           suirplus.sre_Validar_Ciudadano_pkg.limpiar_numero_acta(replace(p_numero_acta, chr(0), '')),
           suirplus.sre_Validar_Ciudadano_pkg.limpiar_folio_acta( replace(p_folio_acta, chr(0), '')),
           suirplus.sre_Validar_Ciudadano_pkg.limpiar_libro_acta(replace(p_libro_acta, chr(0), ''),replace(p_ano_acta, chr(0), '')),
           suirplus.sre_Validar_Ciudadano_pkg.limpiar_oficialia_acta(replace(p_oficialia_acta,chr(0),'')),
           null,
           replace(p_status, chr(0), ''),
           sysdate,
           p_ult_usuario_act,
           replace(p_tipo_Causa, chr(0), ''),
           replace(p_id_causa_Inhabilidad, chr(0), ''))
        returning id_nss into v_nss;
        commit;
        
        --Debe insertar en historico
        suirplus.sre_ciudadano_pkg.Insertar_Ciudadano_Cancelado(null,
                                                       p_nss,
                                                       replace(p_tipo_causa, chr(0), ''),
                                                       replace(p_id_causa_inhabilidad, chr(0), ''),
                                                       nvl(p_fecha_cancelacion, sysdate),
                                                       p_ULT_USUARIO_ACT);
        
        p_resultnumber := '0' ||'|'||v_nss;
        RETURN;
      end if;        

      /*
       CASO 13 y 24
      */
      -- Viene de la JCE INHABILITADO O NULO
      if NVL(p_tipo_causa, '~') IN ('I','~') and p_accion = 'A' Then
        --En TSS esta CANCELADO por la JCE y NO FALLECIDO
        if NVL(r_TSS.tipo_causa, '~') = 'C' AND NVL(r_TSS.id_causa_inhabilidad, 100) < 100  and
           v_fallecido = 0 then
          --actualizamos segun la JCE e insertamos en el HISTORICO
          update suirplus.sre_ciudadanos_t
             set TIPO_DOCUMENTO       = 'C',
                 NO_DOCUMENTO         = replace(p_no_documento, chr(0), ''),
                 NOMBRES              = replace(p_nombres, chr(0), ''),
                 PRIMER_APELLIDO      = replace(p_primer_apellido, chr(0),''),
                 SEGUNDO_APELLIDO     = replace(p_segundo_apellido,chr(0),''),
                 ESTADO_CIVIL         = replace(nvl(p_estado_civil, 'S'),chr(0),''),
                 FECHA_NACIMIENTO     = trunc(p_fecha_nacimiento),
                 SEXO                 = replace(nvl(p_sexo, 'M'),chr(0),''),
                 ID_PROVINCIA         = null,
                 ID_TIPO_SANGRE       = v_sangre,
                 ID_NACIONALIDAD      = v_nacion,
                 NOMBRE_PADRE         = replace(nvl(p_nombre_padre,NOMBRE_PADRE),chr(0),''),
                 NOMBRE_MADRE         = replace(nvl(p_nombre_madre,NOMBRE_MADRE),chr(0),''),
                 MUNICIPIO_ACTA       = suirplus.sre_Validar_Ciudadano_pkg.limpiar_municipio_acta(replace(p_municipio_acta, chr(0), '')),   
                 ANO_ACTA             = suirplus.sre_Validar_Ciudadano_pkg.limpiar_ano_acta(replace(p_ano_acta, chr(0), '')),
                 NUMERO_ACTA          = suirplus.sre_Validar_Ciudadano_pkg.limpiar_numero_acta(replace(p_numero_acta, chr(0), '')),
                 FOLIO_ACTA           = suirplus.sre_Validar_Ciudadano_pkg.limpiar_folio_acta( replace(p_folio_acta, chr(0), '')),
                 LIBRO_ACTA           = suirplus.sre_Validar_Ciudadano_pkg.limpiar_libro_acta(replace(p_libro_acta, chr(0), ''),replace(p_ano_acta, chr(0), '')),
                 OFICIALIA_ACTA       = suirplus.sre_Validar_Ciudadano_pkg.limpiar_oficialia_acta(replace(p_oficialia_acta,chr(0),'')),
                 STATUS               = replace(p_status, chr(0), ''),
                 ULT_FECHA_ACT        = sysdate,
                 ULT_USUARIO_ACT      = p_ULT_USUARIO_ACT,
                 TIPO_CAUSA           = replace(P_tipo_causa, chr(0), ''),
                 ID_CAUSA_INHABILIDAD = replace(P_id_causa_inhabilidad, chr(0), '')
           where ID_NSS = replace(p_nss, chr(0), '');
          commit;
            
          --Debe insertar en historico
          suirplus.sre_ciudadano_pkg.Insertar_Ciudadano_Cancelado(null,
                                                         p_nss,
                                                         replace(p_tipo_causa, chr(0), ''),
                                                         replace(p_id_causa_inhabilidad, chr(0), ''),
                                                         nvl(p_fecha_cancelacion, sysdate),
                                                         p_ULT_USUARIO_ACT);

          p_resultnumber := '0';
          RETURN;                                               
        end if;
      end if;    

      /*
       CASO 14,15 y 25,26
      */
      -- Viene de la JCE INHABILITADO O NULO
      if NVL(p_tipo_causa, '~') IN ('I','~') and p_accion = 'A' Then
        --En TSS esta INHABILITADO
        if NVL(r_TSS.tipo_causa, '~') IN ('I','~') and v_fallecido = 0 then
          --actualizamos segun la JCE y NO FALLECIDO
          update suirplus.sre_ciudadanos_t
             set TIPO_DOCUMENTO       = 'C',
                 NO_DOCUMENTO         = replace(p_no_documento, chr(0), ''),
                 NOMBRES              = replace(p_nombres, chr(0), ''),
                 PRIMER_APELLIDO      = replace(p_primer_apellido, chr(0),''),
                 SEGUNDO_APELLIDO     = replace(p_segundo_apellido,chr(0),''),
                 ESTADO_CIVIL         = replace(nvl(p_estado_civil, 'S'),chr(0),''),
                 FECHA_NACIMIENTO     = trunc(p_fecha_nacimiento),
                 SEXO                 = replace(nvl(p_sexo, 'M'),chr(0),''),
                 ID_PROVINCIA         = null,
                 ID_TIPO_SANGRE       = v_sangre,
                 ID_NACIONALIDAD      = v_nacion,
                 NOMBRE_PADRE         = replace(nvl(p_nombre_padre,NOMBRE_PADRE),chr(0),''),
                 NOMBRE_MADRE         = replace(nvl(p_nombre_madre,NOMBRE_MADRE),chr(0),''),
                 MUNICIPIO_ACTA       = suirplus.sre_Validar_Ciudadano_pkg.limpiar_municipio_acta(replace(p_municipio_acta, chr(0), '')),   
                 ANO_ACTA             = suirplus.sre_Validar_Ciudadano_pkg.limpiar_ano_acta(replace(p_ano_acta, chr(0), '')),
                 NUMERO_ACTA          = suirplus.sre_Validar_Ciudadano_pkg.limpiar_numero_acta(replace(p_numero_acta, chr(0), '')),
                 FOLIO_ACTA           = suirplus.sre_Validar_Ciudadano_pkg.limpiar_folio_acta( replace(p_folio_acta, chr(0), '')),
                 LIBRO_ACTA           = suirplus.sre_Validar_Ciudadano_pkg.limpiar_libro_acta(replace(p_libro_acta, chr(0), ''),replace(p_ano_acta, chr(0), '')),
                 OFICIALIA_ACTA       = suirplus.sre_Validar_Ciudadano_pkg.limpiar_oficialia_acta(replace(p_oficialia_acta,chr(0),'')),
                 STATUS               = replace(p_status, chr(0), ''),
                 ULT_FECHA_ACT        = sysdate,
                 ULT_USUARIO_ACT      = p_ULT_USUARIO_ACT,
                 TIPO_CAUSA           = replace(P_tipo_causa, chr(0), ''),
                 ID_CAUSA_INHABILIDAD = replace(P_id_causa_inhabilidad, chr(0), '')
           where ID_NSS = replace(p_nss, chr(0), '');
          commit;
          
          p_resultnumber := '0';          
          RETURN;                                               
        end if;
      end if;    

      /*
       CASO 16 y 27
      */
      -- Viene de la JCE INHABILITADO O NULO
      if NVL(p_tipo_causa, '~') IN ('I','~') and p_accion = 'A' Then
        --En TSS esta INHABILITADO y NO FALLECIDO
        if NVL(r_TSS.tipo_causa, '~') = 'C' AND NVL(r_TSS.id_causa_inhabilidad, 0) >= 100 and
           v_fallecido = 0 then
          --actualizamos segun la JCE
          update suirplus.sre_ciudadanos_t
             set TIPO_DOCUMENTO       = 'C',
                 NO_DOCUMENTO         = replace(p_no_documento, chr(0), ''),
                 NOMBRES              = replace(p_nombres, chr(0), ''),
                 PRIMER_APELLIDO      = replace(p_primer_apellido, chr(0),''),
                 SEGUNDO_APELLIDO     = replace(p_segundo_apellido,chr(0),''),
                 ESTADO_CIVIL         = replace(nvl(p_estado_civil, 'S'),chr(0),''),
                 FECHA_NACIMIENTO     = trunc(p_fecha_nacimiento),
                 SEXO                 = replace(nvl(p_sexo, 'M'),chr(0),''),
                 ID_PROVINCIA         = null,
                 ID_TIPO_SANGRE       = v_sangre,
                 ID_NACIONALIDAD      = v_nacion,
                 NOMBRE_PADRE         = replace(nvl(p_nombre_padre,NOMBRE_PADRE),chr(0),''),
                 NOMBRE_MADRE         = replace(nvl(p_nombre_madre,NOMBRE_MADRE),chr(0),''),
                 MUNICIPIO_ACTA       = suirplus.sre_Validar_Ciudadano_pkg.limpiar_municipio_acta(replace(p_municipio_acta, chr(0), '')),   
                 ANO_ACTA             = suirplus.sre_Validar_Ciudadano_pkg.limpiar_ano_acta(replace(p_ano_acta, chr(0), '')),
                 NUMERO_ACTA          = suirplus.sre_Validar_Ciudadano_pkg.limpiar_numero_acta(replace(p_numero_acta, chr(0), '')),
                 FOLIO_ACTA           = suirplus.sre_Validar_Ciudadano_pkg.limpiar_folio_acta( replace(p_folio_acta, chr(0), '')),
                 LIBRO_ACTA           = suirplus.sre_Validar_Ciudadano_pkg.limpiar_libro_acta(replace(p_libro_acta, chr(0), ''),replace(p_ano_acta, chr(0), '')),
                 OFICIALIA_ACTA       = suirplus.sre_Validar_Ciudadano_pkg.limpiar_oficialia_acta(replace(p_oficialia_acta,chr(0),'')),
                 STATUS               = replace(p_status, chr(0), ''),
                 ULT_FECHA_ACT        = sysdate,
                 ULT_USUARIO_ACT      = p_ULT_USUARIO_ACT
           where ID_NSS = replace(p_nss, chr(0), '');
          commit;

          p_resultnumber := '0';          
          RETURN;                                               
        end if;
      end if;    

      /*
       CASO 17 y 28
      */
      -- Viene de la JCE INHABILITADO O NULO
      if NVL(p_tipo_causa, '~') IN ('I','~') and p_accion = 'A' Then
        --Si en TSS esta FALLECIDO
        if v_fallecido > 0 then
          --actualizamos segun la JCE
          update suirplus.sre_ciudadanos_t
             set TIPO_DOCUMENTO       = 'C',
                 NO_DOCUMENTO         = replace(p_no_documento, chr(0), ''),
                 NOMBRES              = replace(p_nombres, chr(0), ''),
                 PRIMER_APELLIDO      = replace(p_primer_apellido, chr(0),''),
                 SEGUNDO_APELLIDO     = replace(p_segundo_apellido,chr(0),''),
                 ESTADO_CIVIL         = replace(nvl(p_estado_civil, 'S'),chr(0),''),
                 FECHA_NACIMIENTO     = trunc(p_fecha_nacimiento),
                 SEXO                 = replace(nvl(p_sexo, 'M'),chr(0),''),
                 ID_PROVINCIA         = null,
                 ID_TIPO_SANGRE       = v_sangre,
                 ID_NACIONALIDAD      = v_nacion,
                 NOMBRE_PADRE         = replace(nvl(p_nombre_padre,NOMBRE_PADRE),chr(0),''),
                 NOMBRE_MADRE         = replace(nvl(p_nombre_madre,NOMBRE_MADRE),chr(0),''),
                 MUNICIPIO_ACTA       = suirplus.sre_Validar_Ciudadano_pkg.limpiar_municipio_acta(replace(p_municipio_acta, chr(0), '')),   
                 ANO_ACTA             = suirplus.sre_Validar_Ciudadano_pkg.limpiar_ano_acta(replace(p_ano_acta, chr(0), '')),
                 NUMERO_ACTA          = suirplus.sre_Validar_Ciudadano_pkg.limpiar_numero_acta(replace(p_numero_acta, chr(0), '')),
                 FOLIO_ACTA           = suirplus.sre_Validar_Ciudadano_pkg.limpiar_folio_acta( replace(p_folio_acta, chr(0), '')),
                 LIBRO_ACTA           = suirplus.sre_Validar_Ciudadano_pkg.limpiar_libro_acta(replace(p_libro_acta, chr(0), ''),replace(p_ano_acta, chr(0), '')),
                 OFICIALIA_ACTA       = suirplus.sre_Validar_Ciudadano_pkg.limpiar_oficialia_acta(replace(p_oficialia_acta,chr(0),'')),
                 STATUS               = replace(p_status, chr(0), ''),
                 ULT_FECHA_ACT        = sysdate,
                 ULT_USUARIO_ACT      = p_ULT_USUARIO_ACT
           where ID_NSS = replace(p_nss, chr(0), '');
          commit;

          p_resultnumber := '0';
          RETURN;
        end if;
      end if;      

      /*
       CASO 18,19,20,21 y 29,30,31,32
       no se hace nada con estos casos en este metodo.
       estos se ejecuta en el metodo getciudadano.         
      */

      /*
       CASO 22 y 33
      */
      -- Viene de la JCE INHABILITADO O NULO
      if NVL(p_tipo_causa, '~') IN ('I','~') and p_accion = 'A' Then
        --Si en TSS existe MENOR con igual acta que la JCE y NO FALLECIDO
        select count(*)
          into v_count
          from suirplus.sre_ciudadanos_t c
         where nvl(c.no_documento,'~') = '~' 
          and  suirplus.sre_Validar_Ciudadano_pkg.limpiar_datos_acta(c.municipio_acta, c.ano_acta,c.numero_acta,c.folio_acta, c.libro_acta,c.oficialia_acta) 
             = suirplus.sre_Validar_Ciudadano_pkg.limpiar_datos_acta(p_municipio_acta,p_ano_acta,p_numero_acta,p_folio_acta,p_libro_acta,p_oficialia_acta);
         
           
        if v_count > 0 and v_fallecido = 0 then
          --actualizamos segun la JCE e insertamos en el HISTORICO
          update suirplus.sre_ciudadanos_t
             set TIPO_DOCUMENTO       = 'C',
                 NO_DOCUMENTO         = replace(p_no_documento, chr(0), ''),
                 NOMBRES              = replace(p_nombres, chr(0), ''),
                 PRIMER_APELLIDO      = replace(p_primer_apellido, chr(0),''),
                 SEGUNDO_APELLIDO     = replace(p_segundo_apellido,chr(0),''),
                 ESTADO_CIVIL         = replace(nvl(p_estado_civil, 'S'),chr(0),''),
                 FECHA_NACIMIENTO     = trunc(p_fecha_nacimiento),
                 SEXO                 = replace(nvl(p_sexo, 'M'),chr(0),''),
                 ID_PROVINCIA         = null,
                 ID_TIPO_SANGRE       = v_sangre,
                 ID_NACIONALIDAD      = v_nacion,
                 NOMBRE_PADRE         = replace(nvl(p_nombre_padre,NOMBRE_PADRE),chr(0),''),
                 NOMBRE_MADRE         = replace(nvl(p_nombre_madre,NOMBRE_MADRE),chr(0),''),
                 MUNICIPIO_ACTA       = suirplus.sre_Validar_Ciudadano_pkg.limpiar_municipio_acta(replace(p_municipio_acta, chr(0), '')),   
                 ANO_ACTA             = suirplus.sre_Validar_Ciudadano_pkg.limpiar_ano_acta(replace(p_ano_acta, chr(0), '')),
                 NUMERO_ACTA          = suirplus.sre_Validar_Ciudadano_pkg.limpiar_numero_acta(replace(p_numero_acta, chr(0), '')),
                 FOLIO_ACTA           = suirplus.sre_Validar_Ciudadano_pkg.limpiar_folio_acta( replace(p_folio_acta, chr(0), '')),
                 LIBRO_ACTA           = suirplus.sre_Validar_Ciudadano_pkg.limpiar_libro_acta(replace(p_libro_acta, chr(0), ''),replace(p_ano_acta, chr(0), '')),
                 OFICIALIA_ACTA       = suirplus.sre_Validar_Ciudadano_pkg.limpiar_oficialia_acta(replace(p_oficialia_acta,chr(0),'')),
                 STATUS               = replace(p_status, chr(0), ''),
                 ULT_FECHA_ACT        = sysdate,
                 ULT_USUARIO_ACT      = p_ULT_USUARIO_ACT,
                 TIPO_CAUSA           = replace(P_tipo_causa, chr(0), ''),
                 ID_CAUSA_INHABILIDAD = replace(P_id_causa_inhabilidad, chr(0), '')
           where ID_NSS = replace(p_nss, chr(0), '');
          commit;

          p_resultnumber := '0';
          RETURN;                                               
        end if;
      end if;    

      /*
        CASO 23 y 34
      */
      -- Viene de la JCE INHABILITADO O NULO
      if NVL(p_tipo_causa, '~') IN ('I','~') and p_accion = 'I' Then
        --Insertamos el nuevo ciudadano -----------------------------------------------------------
        insert into suirplus.sre_ciudadanos_t
          (nombres,
           primer_apellido,
           segundo_apellido,
           estado_civil,
           fecha_nacimiento,
           no_documento,
           tipo_documento,
           sexo,
           id_provincia,
           id_tipo_sangre,
           id_nacionalidad,
           nombre_padre,
           nombre_madre,
           fecha_registro,
           fecha_expedicion,
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
           id_causa_inhabilidad)
        values
          (replace(p_nombres, chr(0), ''),
           replace(p_primer_apellido, chr(0), ''),
           replace(p_segundo_apellido, chr(0), ''),
           replace(nvl(p_estado_civil, 'S'), chr(0), ''),
           trunc(p_fecha_nacimiento),
           replace(p_no_documento, chr(0), ''),
           'C',
           replace(nvl(p_sexo, 'M'), chr(0), ''),
           null,
           v_sangre,
           v_nacion,
           replace(p_nombre_padre, chr(0), ''),
           replace(p_nombre_madre, chr(0), ''),
           sysdate,
           null,
           suirplus.sre_Validar_Ciudadano_pkg.limpiar_municipio_acta(replace(p_municipio_acta, chr(0), '')),   
           suirplus.sre_Validar_Ciudadano_pkg.limpiar_ano_acta(replace(p_ano_acta, chr(0), '')),
           suirplus.sre_Validar_Ciudadano_pkg.limpiar_numero_acta(replace(p_numero_acta, chr(0), '')),
           suirplus.sre_Validar_Ciudadano_pkg.limpiar_folio_acta( replace(p_folio_acta, chr(0), '')),
           suirplus.sre_Validar_Ciudadano_pkg.limpiar_libro_acta(replace(p_libro_acta, chr(0), ''),replace(p_ano_acta, chr(0), '')),
           suirplus.sre_Validar_Ciudadano_pkg.limpiar_oficialia_acta(replace(p_oficialia_acta,chr(0),'')),
           null,
           replace(p_status, chr(0), ''),
           sysdate,
           p_ult_usuario_act,
           replace(p_tipo_Causa, chr(0), ''),
           replace(p_id_causa_Inhabilidad, chr(0), ''))
           returning id_nss into v_nss;
        commit;

        p_resultnumber := '0' ||'|'||v_nss;
        RETURN;
      end if;        
    END;
   
   EXCEPTION
  
    WHEN OTHERS THEN
      system.html_mail('info@mail.tss2.gov.do',
                       '_operaciones@mail.tss2.gov.do',
                       'error al insertar ciudadano via WS JCE','No_documento Error ->'||p_no_documento||','|| sqlerrm);
      v_bderror      := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultnumber := suirplus.Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
      RETURN;
  END;

  --***************************************************************************************--
  --busca los parametros de conección con el webservice de la jce
  --10/08/2011
  -- by charlie pena
  --***************************************************************************************--
  procedure getWS_JCE_Parametros(p_id_modulo    in suirplus.srp_config_t.id_modulo%type,
                                 p_iocursor     in out t_cursor,
                                 p_resultnumber out varchar2)
  
   is
    v_bderror varchar(1000);
    c_cursor  t_cursor;
  
  begin
  
    open c_cursor for
    
      select p.field1, p.field2
        from suirplus.srp_config_t p
       where p.id_modulo = p_id_modulo;
  
    p_iocursor     := c_cursor;
    p_resultnumber := 0;
  
  exception
  
    when others then
      v_bderror      := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultnumber := suirplus.Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
      return;
  end;

  ---------------------------------------------------
  -- Borra los ultimos 7 dias de data a partir de hoy
  ---------------------------------------------------
  procedure Borrar_Ult_7_Dias_Ciudadanos is
  Begin
    Delete from suirplus.sre_ciudadanos_ult_t
     where trunc(ult_fecha_act) < trunc(sysdate - 7);
  
    commit;
  Exception
    When others Then
      system.html_mail('info@mail.tss2.gov.do',
                       '_operaciones@mail.tss2.gov.do',
                       'error al tratar de borrar ultimos 7 dias de ciudadanos',
                       sqlerrm);
  End;

  /*
  ----------------------------------------------------------------------
  Procedure: Insertar_Ciudadano_Cancelado
  Autor    : Gregorio Herrera
  Objectivo: Insertar en la tabla SUIRPLUS.SRE_CIUDADANOS_CANCELADOS_T al
             momento de inhabilitar o habilitar nuevamente un ciudadano
  Fecha    : 19/07/2012
  -----------------------------------------------------------------------
  */
  Procedure Insertar_Ciudadano_Cancelado(p_id_oficio            suirplus.ofc_oficios_t.id_oficio%type,
                                         p_id_nss               suirplus.sre_ciudadanos_t.id_nss%type,
                                         p_tipo_causa           suirplus.sre_inhabilidad_jce_t.tipo_causa%type,
                                         p_id_causa_inhabilidad suirplus.sre_inhabilidad_jce_t.id_causa_inhabilidad%type,
                                         p_fecha_cancelacion    date,
                                         p_ult_usuario_act      suirplus.seg_usuario_t.id_usuario%type) is
    v_id_nss_canc suirplus.sre_ciudadanos_t.id_nss%type;
  Begin
    v_id_nss_canc := suirplus.sre_ciudadanos_cancelados_seq.nextval;
  
    -- Insertamos en la tabla de sre_ciudadanos_cancelados_t
    insert into suirplus.sre_ciudadanos_cancelados_t
      (id_canc_nss,
       id_oficio,
       id_nss,
       tipo_causa,
       id_causa_inhabilidad,
       fecha_de_cancelacion,
       ult_fecha_act,
       ult_usuario_act)
    values
      (v_id_nss_canc,
       p_id_oficio,
       p_id_nss,
       p_tipo_causa,
       p_id_causa_inhabilidad,
       p_fecha_cancelacion,
       sysdate,
       p_ult_usuario_act);
    COMMIT;
  End;

  /*
  ----------------------------------------------------------------------
  Procedure: Pasaporte_Crear
  Autor    : Eury Vallejo
  Objectivo: Insertar en la tabla SUIRPLUS.SRE_PASAPORTES_T al
             momento de inhabilitar o habilitar nuevamente un ciudadano
  Fecha    : 19/07/2012
  -----------------------------------------------------------------------
  */
  PROCEDURE Pasaporte_Crear(p_id_registro_patronal in decimal,
                            p_nro_pasaporte        suirplus.SRE_CIUDADANOS_T.No_Documento%TYPE,
                            p_nombres              suirplus.SRE_CIUDADANOS_T.nombres%TYPE,
                            p_primer_apellido      suirplus.SRE_CIUDADANOS_T.primer_apellido%TYPE,
                            p_segundo_apellido     suirplus.SRE_CIUDADANOS_T.segundo_apellido%TYPE,
                            p_fecha_nacimiento     suirplus.SRE_CIUDADANOS_T.FECHA_NACIMIENTO%TYPE,
                            p_sexo                 suirplus.SRE_CIUDADANOS_T.sexo%TYPE,
                            p_nacionalidad         suirplus.sre_ciudadanos_t.id_nacionalidad%TYPE,
                            p_status               suirplus.sre_pasaportes_t.status%TYPE,
                            p_ult_usuario_act      suirplus.SRE_CIUDADANOS_T.ult_usuario_act%TYPE,
                            p_imagen_p             suirplus.sre_pasaportes_t.imagen_p%TYPE,
                            p_fecha_registro       suirplus.sre_pasaportes_t.fecha_registro%TYPE,
                            p_resultnumber         IN OUT VARCHAR)
  
   IS
  
    v_longitud VARCHAR(500);
    --  v_idnss           VARCHAR(20);
    v_fechanacimiento VARCHAR(10);
    v_existeciudadano varchar(100);
    v_existepasaporte varchar(100);
    v_id_pasaporte    integer;
    e_ciudadanoeexiste exception;
   BEGIN
    
      SELECT count(*)
      Into v_existeciudadano
        FROM suirplus.sre_ciudadanos_t c
       WHERE c.no_documento = p_nro_pasaporte;
    --and c.id_registro_patronal = p_id_registro_patronal;
 
      IF v_existeciudadano > 0 THEN
         raise e_ciudadanoeexiste;
      END IF;
   
      SELECT count(*)
      Into v_existepasaporte
        FROM suirplus.SRE_PASAPORTES_T c
       WHERE c.Pasaporte = p_nro_pasaporte
         and c.status in ('AP', 'PE');
    --and c.id_registro_patronal = p_id_registro_patronal;
    IF v_existepasaporte > 0 THEN
        raise e_ciudadanoeexiste;
    END IF;

  
    IF NOT p_ult_usuario_act IS NULL AND
       NOT suirplus.Seg_Usuarios_Pkg.isexisteusuario(p_ult_usuario_act) THEN
      RAISE e_invaliduser;
    END IF;
  
    IF (LENGTH(P_NOMBRES)) >
       (Seg_Get_Largo_Columna('SRE_CIUDADANOS_T', 'NOMBRES')) THEN
      v_longitud := 'Nombres';
      RAISE e_excedelogintud;
    END IF;
    IF (LENGTH(P_PRIMER_APELLIDO)) >
       (Seg_Get_Largo_Columna('SRE_CIUDADANOS_T', 'PRIMER_APELLIDO')) THEN
      v_longitud := 'Primer Apellido';
      RAISE e_excedelogintud;
    END IF;
    IF (LENGTH(P_SEGUNDO_APELLIDO)) >
       (Seg_Get_Largo_Columna('SRE_CIUDADANOS_T', 'SEGUNDO_APELLIDO')) THEN
      v_longitud := 'Segundo Apellido';
      RAISE e_excedelogintud;
    END IF;
  
    IF (LENGTH(p_nro_pasaporte)) >
       (Seg_Get_Largo_Columna('SRE_CIUDADANOS_T', 'NO_DOCUMENTO')) THEN
      v_longitud := 'Numero Pasaporte';
      RAISE e_excedelogintud;
    END IF;
  
    SELECT TO_DATE(p_fecha_nacimiento, 'DD/MM/YYYY')
      INTO v_fechanacimiento
      FROM dual;
  
    SELECT suirplus.sre_pasaportes_seq.nextval
      INTO v_id_pasaporte
      FROM DUAL;
  
    -- insertamos los datos del pasaporte.
    INSERT INTO suirplus.SRE_PASAPORTES_T
      (ID_PASAPORTE,
       ID_REGISTRO_PATRONAL,
       PASAPORTE,
       NOMBRES,
       PRIMER_APELLIDO,
       SEGUNDO_APELLIDO,
       FECHA_NACIMIENTO,
       SEXO,
       ID_NACIONALIDAD,
       IMAGEN_P,
       STATUS,
       FECHA_REGISTRO,
       ULT_USUARIO_ACT
       
       )
    VALUES
      (v_id_pasaporte,
       p_id_registro_patronal,
       p_nro_pasaporte,
       p_nombres,
       p_primer_apellido,
       p_segundo_apellido,
       v_fechanacimiento,
       p_sexo,
       p_nacionalidad,
       p_imagen_p,
       p_status,
       p_fecha_registro,
       p_ult_usuario_act
       
       );
  
    p_resultnumber := 0;
    COMMIT;
    
  EXCEPTION
    WHEN e_excedelogintud THEN
      p_resultnumber := suirplus.Seg_Retornar_Cadena_Error(15, NULL, NULL) || '' ||
                        v_longitud;
      RETURN;
    WHEN e_ciudadanoeexiste THEN
      p_resultnumber := suirplus.Seg_Retornar_Cadena_Error(23, NULL, NULL);
      RETURN;
    
    WHEN e_invaliduser THEN
      p_resultnumber := suirplus.Seg_Retornar_Cadena_Error(1, NULL, NULL);
      RETURN;
    WHEN OTHERS THEN
      v_bderror      := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultnumber := suirplus.Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
      RETURN;
  END;

  /*
  ----------------------------------------------------------------------
  Procedure: Obtener_Pasaportes
  Autor    : Eury Vallejo
  Objectivo: Obtiene un resultado de pasaportes utilizando registro patronal y fecha_registro
  Fecha    : 19/07/2012
  -----------------------------------------------------------------------
  */

  procedure getPasaportes_registrados(p_id_registro_patronal suirplus.sre_pasaportes_t.id_registro_patronal%TYPE,
                                      p_fecha_desde          suirplus.sre_pasaportes_t.fecha_registro%TYPE,
                                      p_fecha_hasta          suirplus.sre_pasaportes_t.fecha_registro%TYPE,
                                      p_iocursor             in out t_cursor,
                                      p_resultnumber         out varchar2)
  
   is
    v_bderror varchar(1000);
    c_cursor  t_cursor;
  begin
  
    if p_fecha_desde is not null and p_fecha_hasta is not null then
      open c_cursor for
      
        select c.pasaporte,
               c.nombres,
               c.primer_apellido,
               c.segundo_apellido,
               c.fecha_nacimiento,
               decode(c.sexo, 'F', 'FEMENINO', 'M', 'MASCULINO') sexo_des,
               n.nacionalidad_des,
               decode(c.status,
                      'PE',
                      'PENDIENTE',
                      'AP',
                      'APROBADO',
                      'RE',
                      'RECHAZADO') status,
               c.fecha_registro
          from suirplus.sre_pasaportes_t c
          left join suirplus.sre_nacionalidad_t n
            on c.id_nacionalidad = n.id_nacionalidad
         where c.id_registro_patronal = p_id_registro_patronal
           and c.status = 'PE'
           and trunc(c.fecha_registro) between trunc(p_fecha_desde) and
               trunc(p_fecha_hasta);
    
      p_iocursor     := c_cursor;
      p_resultnumber := 0;
    
    else
      open c_cursor for
        select c.pasaporte,
               c.nombres,
               c.primer_apellido,
               c.segundo_apellido,
               c.fecha_nacimiento,
               decode(c.sexo, 'F', 'FEMENINO', 'M', 'MASCULINO') sexo_des,
               n.nacionalidad_des,
               decode(c.status,
                      'PE',
                      'PENDIENTE',
                      'AP',
                      'APROBADO',
                      'RE',
                      'RECHAZADO') status,
               c.fecha_registro
          from suirplus.sre_pasaportes_t c
          left join suirplus.sre_nacionalidad_t n
            on c.id_nacionalidad = n.id_nacionalidad
         where c.id_registro_patronal = p_id_registro_patronal
           and c.status = 'PE';
    
      p_iocursor     := c_cursor;
      p_resultnumber := 0;
    
    end if;
  
  exception
  
    when others then
      v_bderror      := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultnumber := suirplus.Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
      return;
  end;

  /*
    ----------------------------------------------------------------------
    Procedure: Get pasaportes registrados para evaluacion
    Autor    : Eury Vallejo
    Objectivo: Obtiene un resultado un listado de pasaportes
    Fecha    : 19/07/2012
    -----------------------------------------------------------------------
  */
  procedure getDatosPasaportesEvaluacion(p_iocursor     in out t_cursor,
                                         p_resultnumber out varchar2) is
  
  BEGIN
  
    OPEN p_iocursor FOR
      select c.pasaporte,
             c.nombres,
             c.primer_apellido,
             c.segundo_apellido,
             c.fecha_nacimiento,
             decode(c.sexo, 'F', 'FEMENINO', 'M', 'MASCULINO') sexo_des,
             n.nacionalidad_des,
             decode(c.status,
                    'PE',
                    'PENDIENTE',
                    'AP',
                    'APROBADO',
                    'RE',
                    'RECHAZADO') status,
             c.fecha_registro,
             c.imagen_p
        from suirplus.sre_pasaportes_t c
        left join suirplus.sre_nacionalidad_t n
          on c.id_nacionalidad = n.id_nacionalidad
       where c.status = 'PE';
  
    p_resultnumber := suirplus.Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
  end;

  /*
    ----------------------------------------------------------------------
    Procedure: Get Empleadores han creado pasaporte
    Autor    : Eury Vallejo
    Objectivo: obtiene un listado de empleadores que han creado pasaporte pendientes
    Fecha    : 19/07/2012
    -----------------------------------------------------------------------
  */
  procedure getEmpleadoresConPasaporte(p_iocursor     in out t_cursor,
                                       p_resultnumber out varchar2) is
  
  BEGIN
  
    OPEN p_iocursor FOR
      select c.pasaporte, n.nombre_comercial
        from suirplus.sre_pasaportes_t c
        left join suirplus.sre_empleadores_t n
          on c.id_registro_patronal = n.id_registro_patronal
       where c.status = 'PE';
  
    p_resultnumber := suirplus.Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
  end;
  /*
    ----------------------------------------------------------------------
    Procedure: Get Imagen pasaporte
    Autor    : Eury Vallejo
    Objectivo: obtiene una imagen del pasaporte creado
    Fecha    : 19/07/2012
    -----------------------------------------------------------------------
  */
  procedure getImagenPasaporte(p_nro_pasaporte suirplus.SRE_CIUDADANOS_T.No_Documento%TYPE,
                               p_iocursor      in out t_cursor,
                               p_resultnumber  out varchar2) is
  
  BEGIN
  
    OPEN p_iocursor FOR
      select c.imagen_p
        from suirplus.sre_pasaportes_t c
       where c.pasaporte = p_nro_pasaporte;
  
    p_resultnumber := suirplus.Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
  end;

/*
    ----------------------------------------------------------------------
    Procedure: getImagenNSS
    Autor    : Gregorio Herrera
    Objectivo: obtiene una imagen de un NSS
    Fecha    : 29/06/2015
    -----------------------------------------------------------------------
  */
  procedure getImagenNSS(p_id_nss       suirplus.SRE_CIUDADANOS_T.id_nss%TYPE,
                         p_iocursor     in out t_cursor,
                         p_resultnumber out varchar2) is
  BEGIN
    OPEN p_iocursor FOR
      select c.imagen_acta
        from suirplus.sre_ciudadanos_t c
       where c.id_nss = p_id_nss;
       
    p_resultnumber := '0'; 
  Exception when others then
    p_resultnumber := suirplus.Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
  end;

  /*
    ----------------------------------------------------------------------
    Procedure: Rechazar Pasaporte
    Autor    : Eury Vallejo
    Objectivo: obtiene una imagen del pasaporte creado
    Fecha    : 19/07/2012
    -----------------------------------------------------------------------
  */
  procedure RechazarPasaporte(p_nro_pasaporte suirplus.Sre_Pasaportes_t.Pasaporte%TYPE,
                              p_motivo        suirplus.Sre_Pasaportes_t.Id_Motivo%TYPE,
                              p_resultnumber  out varchar2)
  
   is
  
  BEGIN
    update suirplus.sre_pasaportes_t t
       set t.status = 'RE', t.id_motivo = p_motivo
     where t.pasaporte = p_nro_pasaporte;
  
    p_resultnumber := 0;
  
  Exception
    WHEN OTHERS THEN
      v_bderror      := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultnumber := suirplus.Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
      RETURN;
    
  end;

  /*
    ----------------------------------------------------------------------
    Procedure: Get Motivos rechazo pasaporte
    Autor    : Eury Vallejo
    Objectivo: --------------------------------------------
    Fecha    : 19/07/2012
    -----------------------------------------------------------------------
  */
  procedure getMotivosPasaporte(p_iocursor     in out t_cursor,
                                p_resultnumber out varchar2) is
  
  BEGIN
  
    OPEN p_iocursor FOR
      select c.id_motivo, c.descripcion
        from suirplus.sre_motivos_pasaportes_t c
       where c.status = 'A';
  
    p_resultnumber := suirplus.Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
  end;

  /*
    ----------------------------------------------------------------------
    Procedure: AprobarPasaporteCiudadano
    Autor    : Eury Vallejo
    Objectivo: aprueba el pasaporte y registra la informacion del pasaporte en sre_ciudadano_t
    Fecha    : 19/07/2012
    -----------------------------------------------------------------------
  */
  procedure AprobarPasaporteCiudadano(p_nro_pasaporte   suirplus.Sre_Pasaportes_t.Pasaporte%TYPE,
                                      p_ult_usuario_act suirplus.Sre_Pasaportes_t.Ult_Usuario_Act%TYPE,
                                      p_resultnumber    out varchar2) IS
  
    v_pasaporte        suirplus.sre_pasaportes_t.pasaporte%type;
    v_nombres          suirplus.sre_pasaportes_t.nombres%type;
    v_primer_apellido  suirplus.sre_pasaportes_t.primer_apellido%type;
    v_segundo_apellido suirplus.sre_pasaportes_t.segundo_apellido%type;
    v_fecha_nacimiento suirplus.sre_pasaportes_t.fecha_nacimiento%type;
    v_sexo             suirplus.sre_pasaportes_t.sexo%type;
    v_id_nacionalidad  suirplus.sre_pasaportes_t.id_nacionalidad%type;
    v_imagen_p         suirplus.sre_pasaportes_t.imagen_p%type;
    v_status           suirplus.sre_pasaportes_t.status%type;
    v_fecha_registro   suirplus.sre_pasaportes_t.fecha_registro%type;
  
    CURSOR v_cursor IS
      select t.pasaporte,
             t.nombres,
             t.primer_apellido,
             t.segundo_apellido,
             t.fecha_nacimiento,
             t.sexo,
             t.id_nacionalidad,
             t.imagen_p,
             t.fecha_registro
        from suirplus.sre_pasaportes_t t
       where t.pasaporte = p_nro_pasaporte
         and status = 'PE';
  
  BEGIN
  
    ----Llenamos el Cursor con la Informacion del Pasaporte Pendiente
  
    OPEN v_cursor;
  
    FETCH v_cursor
      INTO v_pasaporte,
           v_nombres,
           v_primer_apellido,
           v_segundo_apellido,
           v_fecha_nacimiento,
           v_sexo,
           v_id_nacionalidad,
           v_imagen_p,
           v_fecha_registro;
  
    CLOSE v_cursor;
  
    ----Insertamos la informacion en Ciudadano
    Insert Into suirplus.sre_ciudadanos_t
      (no_documento,
       tipo_documento,
       nombres,
       primer_apellido,
       segundo_apellido,
       FECHA_NACIMIENTO,
       sexo,
       id_nacionalidad,
       status,
       imagen_acta,
       ult_usuario_act,
       ult_fecha_act)
    Values
      (v_pasaporte,
       'P',
       v_nombres,
       v_primer_apellido,
       v_segundo_apellido,
       v_fecha_nacimiento,
       v_sexo,
       v_id_nacionalidad,
       'T',
       v_imagen_p,
       p_ult_usuario_act,
       sysdate);
  
    update suirplus.sre_pasaportes_t t
       set t.status          = 'AP',
           t.ult_usuario_act = p_ult_usuario_act,
           t.ult_fecha_act   = sysdate
     where t.pasaporte = p_nro_pasaporte;
  
    commit;
  
    p_resultnumber := 0;
  
  Exception
    WHEN OTHERS THEN
      v_bderror      := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultnumber := suirplus.Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
      RETURN;
    
  end;

  ----******************************************************************************---
  -- 15/10/2014
  -- verficamos de los catalogos las descriciones de los tipos causa inhabilidad, 
  -- tipo sangre, nacionalidad y municipio. 
  ----******************************************************************************---
  procedure getComplementoCiudadano(p_idMunicipio        in varchar2,
                                    p_idSangre           in varchar2,
                                    p_idNacionalidad     in varchar2,
                                    p_idCausaInhabilidad in varchar2,
                                    p_tipocausa          in varchar2,
                                    p_iocursor           in out t_cursor,
                                    p_resultnumber       out varchar2) is
    v_bderror            VARCHAR(1000);
    c_cursor             t_cursor;
    v_idCausaInhabilidad number;
    v_return             number;
    v_tipo_causa         varchar2(2);
  
  begin
    if p_idCausaInhabilidad is not null then
      v_return := is_number(p_idCausaInhabilidad);
      if v_return = 1 then
        v_idCausaInhabilidad := p_idCausaInhabilidad;
        v_tipo_causa         := p_tipocausa;
      else
        v_idCausaInhabilidad := '';
        v_tipo_causa         := '';
      end if;
    end if;
  
    open c_cursor for
      select (select i.cancelacion_des
                from suirplus.sre_inhabilidad_jce_t i
               where i.id_causa_inhabilidad < 100
                 and i.id_causa_inhabilidad = nvl(v_idCausaInhabilidad, '')
                 and i.tipo_causa = nvl(v_tipo_causa, '')) desc_CausaInhabilidad,
             
             (select s.tipo_sangre_des
                from suirplus.sre_tipo_sangre_t s
               where s.id_tipo_sangre = nvl(p_idSangre, '')) desc_Sangre,
             
             (select m.municipio_des
                from suirplus.sre_municipio_t m
               where m.id_municipio = nvl(p_idMunicipio, '')) desc_Municipio,
             
             (select n.nacionalidad_des
                from suirplus.sre_nacionalidad_t n
               where n.id_nacionalidad = nvl(p_idNacionalidad, '')) desc_Nacionalidad
        from dual;
  
    --******************************************************--
    p_iocursor     := c_cursor;
    p_resultnumber := 0;
  
  exception
    when others then
      v_bderror      := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' ||
                                SQLERRM,
                                1,
                                255));
      p_resultnumber := suirplus.Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
      RETURN;
  end;

  ---verfiicamos si el valor es numerico 
  FUNCTION is_number(p_string IN VARCHAR2) RETURN INT IS
    v_new_num NUMBER;
  BEGIN
    v_new_num := TO_NUMBER(p_string);
    RETURN 1;
  EXCEPTION
    WHEN VALUE_ERROR THEN
      RETURN 0;
  END is_number;

  ----------------------------------------------------------------------------------
  --CMHA
  --23/10/2014
  -- Actualizamos el limite de consulta JCE e insertamos en sre_trans_jce_t para ser llamado desde la pagina
  --*******************************************************************************--

  procedure prc_trans_limite(p_nro_documento  varchar2,
                             p_tipo_documento varchar2) is
  
    v_limite     varchar2(20) := '0';
    db_error     varchar2(1000);
    v_message    varchar2(1000);
    xml_data     XMLTYPE;
    v_req        utl_http.req;
    v_resp       utl_http.resp;
    v_msg        VARCHAR2(32767) := NULL;
    v_entire_msg VARCHAR2(32767) := NULL;
    v_url        VARCHAR2(1000);
    v_proxy      varchar2(150);
  
    v_mun_ced varchar2(3);
    v_seq_ced varchar2(7);
    v_ver_ced varchar2(1);
    v_success varchar2(50);
  
  BEGIN
    select other3_dir
      into v_limite
      from suirplus.srp_config_t
     where id_modulo = 'VTUNIPAGO';
  
    If v_limite > '0' then
      v_limite := v_limite - 1;
      update suirplus.srp_config_t
         set other3_dir = v_limite
       where id_modulo = 'VTUNIPAGO';
      commit;
    end if;
    --**********************************************************************************************--- 
  
    --buscamos en el webservice de la JCE, si existe nro_documento enviado por unipago
    v_mun_ced := substr(p_nro_documento, 1, 3);
    v_seq_ced := substr(p_nro_documento, 4, 7);
    v_ver_ced := substr(p_nro_documento, 11, 1);
  
    select 'http://' || ftp_dir || '\' || ftp_user || ':' || ftp_pass || '@' ||
           ftp_host || ':' || ftp_port
      into v_proxy
      from suirplus.srp_config_t
     where id_modulo = 'WS_USER';
  
    select field1 || field2
      into v_url
      from suirplus.srp_config_t
     where id_modulo = 'WS JCE';
  
    v_url := v_url || CHR(38) || 'ID1=' || v_mun_ced || CHR(38) || 'ID2=' ||
             v_seq_ced || CHR(38) || 'ID3=' || v_ver_ced;
  
    utl_http.set_proxy(v_proxy);
  
    v_req := utl_http.begin_request(url => v_url, method => 'GET');
  
    UTL_HTTP.set_header(v_req, 'Content-Type', 'text/xml; charset=utf-8');
  
    utl_http.set_header(v_req, 'User-Agent', 'Mozilla/4.0');
  
    v_resp := utl_http.get_response(r => v_req);
  
    BEGIN
      LOOP
        utl_http.read_text(r => v_resp, data => v_msg);
        v_entire_msg := v_msg;
      END LOOP;
    EXCEPTION
      WHEN utl_http.end_of_body THEN
        NULL;
    END;
    utl_http.end_response(r => v_resp);
  
    --HTTP_OK = 200
    if v_resp.status_code = 200 then
    
      insert into suirplus.sre_trans_jce_t d
        (nro_documento, tipo_documento, status_code, mensaje)
      values
        (p_nro_documento,
         p_tipo_documento,
         v_resp.status_code,
         v_resp.reason_phrase || ' ' || v_entire_msg);
      commit;
    
      begin
        xml_data := null;
        xml_data := XMLType(v_entire_msg);
      exception
        when others then
          add_estadistica('Servicio de la JCE Inactivo');
      end;
      --si el servicio del web service esta desabilitado mandamos el siguiente error..
      if (v_message = 'Serviceid Is Disabled!') then
        add_estadistica('Servicio de la JCE Inactivo');
      end if;
    end if;
  
  END;

  ----------------------------------------------------------------------------------
  ----------------------------------------------------------------------------------
  ---------------------------------------------------------------------------------
  --buscamo el motivo de error por la cual se rechazo el ciudadanos---
  ---------------------------------------------------------------------------------
  function getMotivoRechazo(p_error in varchar2) return varchar2 is
    v_error_desc suirplus.seg_error_t.error_des%type;
  begin
    select s.error_des
      into v_error_desc
      from suirplus.seg_error_t s
     where id_error = p_error
     order by s.error_des desc;
  
    return v_error_desc;
  
  end;

END Sre_Ciudadano_Pkg;
