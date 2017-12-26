create or replace package body suirplus.nss_validaciones_pkg is
  -- Author  : GREGORIO HERRERA
  -- Created : 16/06/2015 10:52:06 a.m.
  -- Purpose : Contiene todas las funciones utilizadas para validar los datos de un ciudadano

  -- Valida el sexo del ciudadano
  function validar_sexo(p_sexo in varchar2) return boolean is
  begin
    if NVL(p_sexo,'X') not in ('M','F') then
      return false;--107;
    end if;
    return true;--0;
  end;

    -- Valida el municipio en el catalogo de municipios
  function validar_municipio(p_mun in varchar2) return boolean is
  begin
    for c_mun in (select m.id_municipio
                    from suirplus.sre_municipio_t m
                   where m.id_municipio = p_mun)
    loop
      return true;
    end loop;

    return false;
  exception when others then
    return false;
  end;

  -- Valida el municipio(para caso 777)
  function validar_municipio_777(p_municipio in varchar2) return boolean is
  begin
    if p_municipio like '%777%' then
      return false;--418;
    else
      return true;--0;
    end if;
  end;

  -- Valida el municipio(combinado con la oficialia)
  function validar_municipio_oficialia (p_mun in varchar2, p_ofic in varchar2) return boolean is
    v_conteo integer;
  begin
    if (trim(p_mun) is not null) and (trim(p_ofic) is not null) then
      select count(*)
      into v_conteo
      from suirplus.sre_oficialias_t o
      where o.id_municipio <> '777'
        and o.id_municipio = nvl(p_mun ,'~')
        and o.id_oficialia = to_number(nvl(p_ofic,0));

      if v_conteo=0 then
        return false;
      end if;
    end if;
    return true;
  exception when others then
    return false;
  end;

  -- Valida el municipio y la provincia (opcional)
  function validar_municipio_provincia(p_mun in varchar2, p_prov in varchar2, p_result out varchar2) return boolean is
  begin
    if (trim(p_prov) is null) then
      for c_prov in (select p.id_provincia
                       from suirplus.sre_municipio_t m
                       join suirplus.sre_provincias_t p
                         on p.id_provincia = m.id_provincia
                      where m.id_municipio = p_mun)
      loop
        p_result := c_prov.id_provincia;
        return true;
      end loop;

      p_result := '99';
      return false;
    else
      for c_prov in (select p.id_provincia
                       from suirplus.sre_municipio_t m
                       join suirplus.sre_provincias_t p
                         on p.id_provincia = m.id_provincia
                      where m.id_municipio = p_mun
                        and m.id_provincia = p_prov)
      loop
        return true;
      end loop;
      return false;
    end if;
  exception when others then
    return false;
  end;

  -- Valida el tipo y causa de inhabilidad para la JCE
  function validar_inhabilidad_jce(p_causa in number, p_tipo in varchar2) return boolean is
  begin
    for c_inh in (select i.id_causa_inhabilidad
                    from suirplus.sre_inhabilidad_jce_t i
                   where i.id_causa_inhabilidad = p_causa
                     and i.tipo_causa = p_tipo)
    loop
      return true;
    end loop;

    return false;
  exception when others then
    return false;
  end;

  -- Valida el tipo y causa de inhabilidad para la TSS
  function validar_inhabilidad_tss(p_causa in number, p_tipo in varchar2) return char is
  begin
    for c_inh in (select i.id_causa_inhabilidad
                    from suirplus.sre_inhabilidad_jce_t i
                   where i.id_causa_inhabilidad = p_causa
                     and i.tipo_causa = p_tipo
                     and NVL(i.cancelada_suir, 'N') = 'S')
    loop
      return 'S';
    end loop;

    return 'N';
  exception when others then
    return 'N';
  end;
  
   -- Valida el tipo y causa de inhabilidad para la TSS
  function validar_inhabilidad_tss_act(p_causa in number, p_tipo in varchar2) return char is
  begin
    for c_inh in (select i.id_causa_inhabilidad
                    from suirplus.sre_inhabilidad_jce_t i
                   where i.id_causa_inhabilidad = p_causa
                     and i.tipo_causa = p_tipo                     
                     and i.id_causa_inhabilidad in 
                     (select i.id_causa_inhabilidad
                      from suirplus.sre_inhabilidad_jce_t i
                      where i.id_causa_inhabilidad < 100                                                
						    and i.tipo_causa = p_tipo)
                        or (i.id_causa_inhabilidad is null and i.tipo_causa is null))   
    loop
      return 'S';
    end loop;

    return 'N';
  exception when others then
    return 'N';
  end;

  -- Valida caracteres invalidos en la cadena recibida
  function validar_caracteres_invalidos(v_data in varchar2) return boolean is
    v_valid integer;
    v_letra char(1);
    v_pos   integer;
    v_res   boolean;
    p_data  varchar2(250);
  begin
    v_res   := true;
    p_data  := upper(trim(nvl(v_data,'ABC')));
    v_valid := 0;

    for v_pos in 1..length(p_data) loop
      v_letra := substr(p_data,v_pos,1);
      if instr('ABCDEFGHIJKLMNOPQRSTUVWXYZ ''ÑÁÉÍÓÚ.-',v_letra) > 0 then --existe en la lista
        v_valid := v_valid+1;
      else
        return false;
      end if;
    end loop;

    if v_valid <= 1 then
      v_res := false;
    end if;

    if (v_res) and (length(p_data)=2) and (substr(p_data,2,1)='.') then
      v_res := false;
    end if;

    return v_res;
  exception when others then
    return false;
  end;

  -- Valida si ciudadano existe por documento
  function validar_ciudadano_documento(p_doc in varchar2, p_tdoc in varchar2) return boolean is
  begin
    for c_ciu in (select c.id_nss
                    from suirplus.sre_ciudadanos_t c
                   where c.no_documento = p_doc
                     and c.tipo_documento = p_tdoc)
    loop
      return true;
    end loop;

    return false;
  exception when others then
    return false;
  end;

  -- Valida si ciudadano existe por documento para la JCE
  function validar_ciudadano_doc_JCE(p_doc       in varchar2,
                                     p_tdoc      in varchar2,
                                     p_count     out number,
                                     p_proceso   in varchar2,
                                     p_tipocausa out varchar2,
                                     p_idcausa   out number,
                                     p_id_nss    out number,
                                     p_estado    out boolean) return boolean is
    l_estado char(1);
  begin
    -- Para saber si esta encendida en la configuracion de funciones
    begin
      select upper(d.estado)
        into l_estado
        from suirplus.sre_ciudadanos_api_t c
        join suirplus.sre_det_ciudadanos_api_t d
          on d.id_ciu_api = c.id_ciu_api
         and d.id_proceso = p_proceso -- Vital
       where upper(c.nombre_api) = 'VALIDAR_CIUDADANO_DOC_JCE';

      -- Si la funcion esta apagada no realizamos nada
      if l_estado = 'N' then
        p_estado := false;
        return false;
      end if;

      p_estado := true;
    exception when no_data_found then
      -- Se asume que esta encendida y se toman valores default
      p_estado := true;
    end;

    for c_ciu in (select count(c.id_nss) total
                    from suirplus.sre_ciudadanos_t c
                   where c.no_documento = p_doc
                     and c.tipo_documento = p_tdoc)
    loop
      if c_ciu.total = 1 then
        select id_nss, tipo_causa, id_causa_inhabilidad, c_ciu.total
        into p_id_nss, p_tipocausa, p_idcausa, p_count
        from suirplus.sre_ciudadanos_t c
        where c.no_documento = p_doc
          and c.tipo_documento = p_tdoc;

        return true;
      else
        p_count := c_ciu.total;
        return true;
      end if;
    end loop;

    return false;
  exception when others then
    return false;
  end;

  -- Valida si ciudadano existe por NSS
  function validar_ciudadano_NSS(p_id_nss in number, p_tipo_doc char default null) return boolean is
  begin
    for c_ciu in (select c.id_nss
                    from suirplus.sre_ciudadanos_t c
                   where c.id_nss = nvl(p_id_nss, -1)
                     and (c.tipo_causa is null or c.tipo_causa <> 'I')
                     and c.tipo_documento = NVL(p_tipo_doc, c.tipo_documento))
    loop
      return true;
    end loop;

    return false;
  exception when others then
    return false;
  end;

  -- Valida el caracter como numero
  function validar_numero(p_numero in varchar2) return boolean is
    v_dummy number(10);
  begin
    if p_numero is not null then
      select to_number(trim(p_numero)) into v_dummy from dual;
      return true;
    else
      return false;
    end if;
  exception when others then
    return false;
  end;

  -- Valida el caracter como fecha a partir del 1/1/1900
  function validar_fecha(p_fecha in date) return boolean is
  begin
    if p_fecha is not null then
      begin
        if p_fecha not between to_date('01011900', 'ddmmyyyy') and trunc(sysdate) then
          return false;
        end if;
      exception when others then
        return false;
      end;
    end if;
    return true;
  end;

  -- Valida que la fecha no exceda la minoria de edad (17 anios)
  function validar_nacimiento(p_fecha in date) return boolean is
  begin
    if p_fecha <= trunc(add_months(sysdate,-18*12)) then
      return false;
    end if;
    return true;
  exception when others then
    return false;
  end;

  -- Valida el anio del acta de nacimiento
  function validar_ano_acta(p_ano in varchar2) return boolean is
  begin
    if (trim(p_ano) is not null) then
      if validar_numero(p_ano) = false then
        return false;
      elsif (length(trim(p_ano)) != 4) or (to_number(trim(p_ano)) not between 1900 and extract(year from sysdate)) then
        return false;
      end if;
    end if;
    return true;
  exception when others then
    return false;
  end;

  -- Valida el anio del acta de nacimiento combinada con la fecha de nacimiento
  function validar_ano_acta_fecha(p_ano in varchar2, p_fecha in date) return boolean is
  begin
    if (trim(p_ano) is not null) and (trim(p_fecha) is not null) then
      if ((validar_numero(p_ano) = false) or (validar_fecha(p_fecha) = false)) then
        return false;
      else
        if (length(p_ano) != 4) or (to_number(trim(p_ano)) not between 1900 and extract(year from sysdate)) then
          return false;
        elsif to_number(trim(p_ano)) < extract(year from p_fecha) then
          return false;
        end if;
      end if;
    end if;
    return true;
  exception when others then
    return false;
  end;

  -- Valida que todos los caracteres no sean ceros
  function validar_ceros(p_texto in varchar2) return boolean is
  begin
    if (p_texto is not null) then
      if trim(p_texto) = rpad('0',length(trim(p_texto)),'0') then
        return false;
      end if;
    end if;
    return true;
  exception when others then
    return false;
  end;

  -- Valida el numero del acta de nacimiento
  function validar_numero_acta(p_acta in varchar2) return boolean is
    v_letra char(1);
    v_pos   integer;
    v_acta  varchar2(250);
  begin
    if trim(p_acta) is not null then
      if validar_ceros(p_acta) then
        v_acta := trim(p_acta);
        if length(p_acta)>=1 then
          for v_pos in 1..length(v_acta) loop
            v_letra := substr(v_acta,v_pos,1);
            if instr('0123456789',v_letra)=0 then
              return false;
            end if;
          end loop;
        else
          return false;
        end if;
      else
        return false;
      end if;
    end if;
    return true;
  exception when others then
    return false;
  end;

  -- Valida el libro del acta de nacimiento
  function validar_libro_acta (p_libro in varchar2) return boolean is
    v_letra char(1);
    v_pos   integer;
    v_libro varchar2(250);
  begin
    if trim(p_libro) is not null then
      if validar_ceros(p_libro) then
        v_libro := trim(p_libro);
        if length(v_libro)>=1 then
          for v_pos in 1..length(v_libro) loop
            v_letra := substr(v_libro,v_pos,1);
            if instr('1234567890-ABCDEFGHIJKLMNOPQRSTUVWXYZ',v_letra)=0 then
              return false;
            end if;
          end loop;
        else
          return false;
        end if;
      else
        return false;
      end if;
    end if;
    return true;
  exception when others then
    return false;
  end;

  -- Valida el titular del ciudadano
  function validar_titular(p_titular in number) return boolean is
    v_conteo integer;
  begin
    select count(*)
    into v_conteo
    from suirplus.sre_ciudadanos_t
    where id_nss = p_titular
      and NVL(tipo_causa,'~') != 'C';

    if v_conteo=0 then
      return false;
    else
      return true;
    end if;
  exception when others then
    return false;
  end;

  -- Valida la ARS de la afiliacion
  function validar_ars(p_ars in suirplus.ars_catalogo_t.id_ars%type) return boolean is
    v_conteo integer;
  begin
    -- si el id_ARS no está nulo
    if NVL(p_ars,0) > 0 then
      -- determinar si la ars existe
      select count(*)
      into v_conteo
      from suirplus.ars_catalogo_t a
      where a.id_ars=NVL(p_ars,0)
        and a.status='A';

      if v_conteo = 0 then
        return false; --43;
      else
        return true; --0;
      end if;
    else
      return false; --43;
    end if;
  exception when others then
    return false;
  end;

  -- Valida el parentesco
  function validar_parentesco(p_id_parentesco in suirplus.ars_parentescos_t.id_parentesco%type) return boolean is
    v_conteo integer;
  begin
    -- determinar si la ars existe
    select count(*)
    into v_conteo
    from suirplus.ars_parentescos_t a
    where a.id_parentesco=NVL(p_id_parentesco,'~');

    if v_conteo = 0 then
      return false;
    else
      return true;
    end if;
  exception when others then
    return false;
  end;

  -- Valida si para esta ARS sus registros van al EV automaticamente
  function ars_evaluacion_visual(p_id_ars in varchar2,
                                 p_proceso in varchar2,
                                 p_id_estatus out number,
                                 p_id_error out varchar2) return boolean is
    l_conteo pls_integer;
    l_estatus char(1);
  begin
/*
    Validacion #9
    Se incluyen:
      El id_ars.
*/
    -- Testeamos por la ARS
    select count(*)
    into l_conteo
    from suirplus.ars_catalogo_t a
    where a.id_ars = p_id_ars
      and a.status = 'A'
      and a.en_evaluacion_visual = 'S';

    if l_conteo > 0 then --ARS EN EVALUACION VISUAL
      return true;
    else
      return false;
    end if;
  exception when others then
    return false;
  end;

  -- Devuelve una cadena conteniendo solo numeros sin los ceros a la izquierda
  function convertir_numero(p_texto in varchar2) return varchar2 is
    v_cadena       varchar2(500);
    v_nueva_cadena varchar2(500) := '';
    v_i            number;
    v_l            varchar2(2);
  begin
    v_cadena := Upper(Trim(leading '0' from p_texto)); --quita los ceros a la izquierda;
    If v_cadena is not null then
      For v_i in 1 .. length(v_cadena) Loop
        v_l := substr(v_cadena, v_i, 1);
        If v_l between '0' and '9' then --quita las letras y/o caracteres especiales
          v_nueva_cadena := v_nueva_cadena || v_l;
        End if;
      End loop;
    Else
      v_nueva_cadena := v_cadena;
    End if;
    return v_nueva_cadena;
  end;

  -- Devuelve una cadena solo con caracteres, sin ceros ni a la derecha ni a la izquierda
  function convertir_letra(p_texto in varchar2) return varchar2 is
    v_cadena       varchar2(500);
    v_nueva_cadena varchar2(500) := '';
    v_i            number;
    v_l            varchar2(2);
  begin
    v_cadena := Upper(Trim(p_texto));
    v_cadena := Trim(leading '0' from v_cadena); --quita los ceros a la izquierda;
    v_cadena := Trim(trailing '0' from v_cadena); --quita los ceros a la derecha;

    If v_cadena is not null then
      For v_i in 1 .. length(v_cadena) Loop
        v_l := substr(v_cadena, v_i, 1);
        If v_l not between '0' and '9' then --quita los numeros
          v_nueva_cadena := v_nueva_cadena || v_l;
        End if;
      End loop;
    Else
      v_nueva_cadena := v_cadena;
    End if;
    return v_nueva_cadena;
  end;

  -- Devuelve una cadena conteniendo los datos del acta en formato texto, sin ceros a la derecha ni a la izquierda
  function sinnumeros(p_nom in varchar2, p_ape in varchar2, p_sex in varchar2 default null)
  return varchar2 as
  Begin
    if p_sex IS NULL then
      return convertir_letra(primer_nombre(p_nom))||' '||convertir_letra(p_ape);
    else
      return convertir_letra(primer_nombre(p_nom))||' '||convertir_letra(p_ape)||' '||convertir_letra(p_sex);
    end if;
  End;

  -- Devuelve la primera palabra de una palabra compuesta separada por espacio, si no tiene espacion, devuelve la palabra completa.
  function primer_nombre(p_nombres suirplus.sre_ciudadanos_t.nombres%type)
  return varchar2 DETERMINISTIC is
  begin
    if instr(trim(p_nombres),' ') > 0 then
      return substr(trim(p_nombres),1, instr(trim(p_nombres),' ')-1);
    else
      return trim(p_nombres);
    end if;
  exception when others then
    return null;
  end;

  -- Valida acta de nacimiento duplicada
  function acta_duplicada(p_mun in varchar2,
                          p_ano in varchar2,
                          p_num in varchar2,
                          p_fol in varchar2,
                          p_lib in varchar2,
                          p_ofi in varchar2,
                          p_proceso in varchar2,
                          p_id_estatus out number,
                          p_id_error out varchar2,
                          p_cursor out sys_refcursor) return boolean is
    v_conteo  number;
    l_estatus char(1);
  begin
/*
    Validacion #1
    Se incluyen:
      Todos los datos del acta.
*/
    if upper(p_proceso) = '76' then -- ASIGNACION DE NSS A MENORES SIN DOCUMENTO NACIONALES
      OPEN p_cursor FOR
        select id_nss
          from suirplus.sre_ciudadanos_t
         where limpiar_municipio_acta(municipio_acta) = limpiar_municipio_acta(p_mun)
            --
           and limpiar_ano_acta(ano_acta) = limpiar_ano_acta(p_ano)
            --
           and limpiar_numero_acta(numero_acta) = limpiar_numero_acta(p_num)
            --
           and limpiar_folio_acta(folio_acta)= limpiar_folio_acta(p_fol)
            --
           and limpiar_libro_acta(libro_acta, ano_acta) = limpiar_libro_acta(p_lib, p_ano)
            --
           and limpiar_oficialia_acta(oficialia_acta) = limpiar_oficialia_acta(p_ofi)
            --
           and tipo_documento in ('C','P','U','N','E') --Cedulado, Pasaporte, Menor con o sin documento y Menor Extranjero
            --
           and validar_inhabilidad_tss(id_causa_inhabilidad, tipo_causa) = 'N' --no inhabilitado en TSS
         order by id_nss;

      return true;
    elsif upper(p_proceso) = '77' then -- ASIGNACION DE NSS A MENORES SIN DOCUMENTO EXTRANJEROS
      OPEN p_cursor FOR
        select id_nss
          from suirplus.sre_ciudadanos_t
         where limpiar_municipio_acta(municipio_acta) = limpiar_municipio_acta(p_mun)
            --
           and limpiar_ano_acta(ano_acta) = limpiar_ano_acta(p_ano)
            --
           and limpiar_numero_acta(numero_acta) = limpiar_numero_acta(p_num)
            --
           and limpiar_folio_acta(folio_acta)= limpiar_folio_acta(p_fol)
            --
           and limpiar_libro_acta(libro_acta, ano_acta) = limpiar_libro_acta(p_lib, p_ano)
            --
           and limpiar_oficialia_acta(oficialia_acta) = limpiar_oficialia_acta(p_ofi)
            --
           and tipo_documento in ('C','P','U','N','E') --Cedulado, Pasaporte, Menor con o sin documento y Menor Extranjero
            --
           and validar_inhabilidad_tss(id_causa_inhabilidad, tipo_causa) = 'N' --no inhabilitado en TSS
         order by id_nss;

      return true;
    elsif upper(p_proceso) = 'CN' then -- Actualizacion de NSS
      select count(*)
        into v_conteo
        from suirplus.sre_ciudadanos_t
       where limpiar_datos_acta(municipio_acta, ano_acta, numero_acta, folio_acta, libro_acta, oficialia_acta)
           = limpiar_datos_acta(p_mun, p_ano, p_num, p_fol, p_lib, p_ofi)
         --
         and nvl(tipo_causa,'!') <> 'C'
         --
         and tipo_documento = 'N'; --menor sin documento

      if v_conteo > 1 then
        return false;
      end if;
      return true;
    elsif upper(p_proceso) = 'J4' then -- Actualizacion de NSS via pagina
      select count(*)
        into v_conteo
        from suirplus.sre_ciudadanos_t
       where limpiar_datos_acta(municipio_acta, ano_acta, numero_acta, folio_acta, libro_acta, oficialia_acta)
           = limpiar_datos_acta(p_mun, p_ano, p_num, p_fol, p_lib, p_ofi)
         --
         and (tipo_causa is null or tipo_causa = 'I')
         --
         and tipo_documento in ('U','N','E'); --Menor con o sin documento y extranjero

      if v_conteo > 0 then
        return false;
      end if;
      return true;
    end if;

    return false;
  exception when others then
    return false;
  end;

  -- Valida nombre duplicado, toma en cuenta primer nombre, primer apellido, sexo y la fecha de nacimiento
  function nombre_duplicado(p_nom  in varchar2,
                            p_ape  in varchar2,
                            p_fec  in varchar2,
                            p_sex in varchar2,
                            p_proceso in varchar2,
                            p_id_estatus out number,
                            p_id_error out varchar2,
                            p_cursor out sys_refcursor) return boolean is
    v_conteo  number;
    l_estatus char(1);
  begin
/*
    Validacion #2
    Se incluyen:
      Datos del nombre, fecha nacimiento y el sexo.
*/
    if upper(p_proceso) = '76' then -- ASIGNACION DE NSS A MENORES SIN DOCUMENTO NACIONALES
      OPEN p_cursor FOR
        select id_nss
         from suirplus.sre_ciudadanos_t
        where sinNumeros(nombres, primer_apellido, sexo) = sinNumeros(p_nom, p_ape, p_sex)
           --
          and fecha_nacimiento = to_date(limpiar_fecha_nacimiento(p_fec),'ddmmyyyy')
           --
          and tipo_documento in ('C','P','U','N','E') --Cedulado, Pasaporte, Menor con o sin documento y Menor Extranjero
           --
          and validar_inhabilidad_tss(id_causa_inhabilidad, tipo_causa) = 'N' --no inhabilitado en TSS
        order by id_nss;

      return true;
    elsif upper(p_proceso) = '77' then -- ASIGNACION DE NSS A MENORES SIN DOCUMENTO EXTRANJEROS
      OPEN p_cursor FOR
        select id_nss
         from suirplus.sre_ciudadanos_t
        where sinNumeros(nombres, primer_apellido, sexo) = sinNumeros(p_nom, p_ape, p_sex)
           --
          and fecha_nacimiento = to_date(limpiar_fecha_nacimiento(p_fec),'ddmmyyyy')
           --
          and tipo_documento in ('C','P','U','N','E') --Cedulado, Pasaporte, Menor con o sin documento y Menor Extranjero
           --
          and validar_inhabilidad_tss(id_causa_inhabilidad, tipo_causa) = 'N' --no inhabilitado en TSS
        order by id_nss;

      return true;
    elsif upper(p_proceso) = 'CN' then -- Actualizacion de NSS
      select count(id_nss) into v_conteo
        from suirplus.sre_ciudadanos_t a
       where sinNumeros(a.nombres, a.primer_apellido, a.sexo)
           = sinNumeros(p_nom, p_ape, p_sex)
         --
         and a.fecha_nacimiento = to_date(limpiar_fecha_nacimiento(p_fec),'ddmmyyyy')
         --
         and nvl(a.tipo_causa,'!') <> 'C'
         --
         and a.tipo_documento = 'N'; --menor sin documento

      if v_conteo > 1 then
        return false;
      end if;

      return true;
    elsif upper(p_proceso) = 'J4' then -- Actualizacion de NSS via Pagina
      select count(id_nss) into v_conteo
        from suirplus.sre_ciudadanos_t a
       where sinNumeros(a.nombres, a.primer_apellido, a.sexo)
           = sinNumeros(p_nom, p_ape, p_sex)
         --
         and a.fecha_nacimiento = to_date(limpiar_fecha_nacimiento(p_fec),'ddmmyyyy')
         --
         and (a.tipo_causa is null or a.tipo_causa = 'I')
         --
         and a.tipo_documento in ('U','N','E'); --Menor con o sin documento y extranjero

      if v_conteo > 0 then
        return false;
      end if;

      return true;
    end if;

    return false;
  exception when others then
    return false;
  end;

  -- Valida acta de nacimiento duplicada combinada con el nombre
  function nombre_acta_duplicada(p_mun in varchar2,
                                 p_ano in varchar2,
                                 p_num in varchar2,
                                 p_fol in varchar2,
                                 p_lib in varchar2,
                                 p_ofi in varchar2,
                                 p_nom in varchar2,
                                 p_ape in varchar2,
                                 p_sex in varchar2,
                                 p_fec in varchar2,
                                 p_proceso in varchar2,
                                 p_id_estatus out number,
                                 p_id_error out varchar2,
                                 p_cursor out sys_refcursor) return boolean is
    v_conteo  number;
    l_estatus char(1);
  begin
/*
    Validacion #3
    Es la mas completa de todas, se incluyen:
      Primer nombre.
      Primer apellido.
      Todos los datos del acta.
      La fecha de nacimiento.
      El sexo
*/
    if upper(p_proceso) = '76' then -- Asignacion de NSS a MENOR SIN DOCUMENTO NACIONAL
      OPEN p_cursor FOR
        select id_nss
          from suirplus.sre_ciudadanos_t
         where limpiar_municipio_acta(municipio_acta) = limpiar_municipio_acta(p_mun)
            --
           and limpiar_ano_acta(ano_acta) = limpiar_ano_acta(p_ano)
            --
           and limpiar_numero_acta(numero_acta) = limpiar_numero_acta(p_num)
            --
           and limpiar_folio_acta(folio_acta)= limpiar_folio_acta(p_fol)
            --
           and limpiar_libro_acta(libro_acta, ano_acta) = limpiar_libro_acta(p_lib, p_ano)
            --
           and limpiar_oficialia_acta(oficialia_acta) = limpiar_oficialia_acta(p_ofi)
            --
           and sinnumeros(nombres, primer_apellido, sexo) = sinnumeros(p_nom, p_ape, p_sex)
            --
           and fecha_nacimiento = to_date(limpiar_fecha_nacimiento(p_fec),'ddmmyyyy')
            --
           and tipo_documento in ('C','P','U','N','E') --Cedulado, Pasaporte, Menor con o sin documento y Menor Extranjero
            --
           and validar_inhabilidad_tss(id_causa_inhabilidad, tipo_causa) = 'N' --no inhabilitado en TSS
         order by id_nss;

      return true;
    elsif upper(p_proceso) = '77' then -- Asignacion de NSS a MENOR SIN DOCUMENTO EXTRANJERO
      OPEN p_cursor FOR
        select id_nss
          from suirplus.sre_ciudadanos_t
         where limpiar_municipio_acta(municipio_acta) = limpiar_municipio_acta(p_mun)
            --
           and limpiar_ano_acta(ano_acta) = limpiar_ano_acta(p_ano)
            --
           and limpiar_numero_acta(numero_acta) = limpiar_numero_acta(p_num)
            --
           and limpiar_folio_acta(folio_acta)= limpiar_folio_acta(p_fol)
            --
           and limpiar_libro_acta(libro_acta, ano_acta) = limpiar_libro_acta(p_lib, p_ano)
            --
           and limpiar_oficialia_acta(oficialia_acta) = limpiar_oficialia_acta(p_ofi)
            --
           and sinnumeros(nombres, primer_apellido, sexo) = sinnumeros(p_nom, p_ape, p_sex)
            --
           and fecha_nacimiento = to_date(limpiar_fecha_nacimiento(p_fec),'ddmmyyyy')
            --
           and tipo_documento in ('C','P','U','N','E') --Cedulado, Pasaporte, Menor con o sin documento y Menor Extranjero
            --
           and validar_inhabilidad_tss(id_causa_inhabilidad, tipo_causa) = 'N' --no inhabilitado en TSS
         order by id_nss;

      return true;
    elsif upper(p_proceso) = '74' then -- Asignacion de NSS a MENOR CON CEDULA
      OPEN p_cursor FOR
        select id_nss,
              (
               select count(*)
               from suirplus.sre_ciudadanos_t
               where limpiar_municipio_acta(municipio_acta) = limpiar_municipio_acta(p_mun)
                  --
                 and limpiar_ano_acta(ano_acta) = limpiar_ano_acta(p_ano)
                  --
                 and limpiar_numero_acta(numero_acta) = limpiar_numero_acta(p_num)
                  --
                 and limpiar_folio_acta(folio_acta)= limpiar_folio_acta(p_fol)
                  --
                 and limpiar_libro_acta(libro_acta, ano_acta) = limpiar_libro_acta(p_lib, p_ano)
                  --
                 and limpiar_oficialia_acta(oficialia_acta) = limpiar_oficialia_acta(p_ofi)
                  --
                 and sinnumeros(nombres, primer_apellido, sexo) = sinnumeros(p_nom, p_ape, p_sex)
                  --
                 and fecha_nacimiento = to_date(limpiar_fecha_nacimiento(p_fec),'ddmmyyyy')
                  --
                 and tipo_documento = 'N' --Menor sin documento
                  --
                 and validar_inhabilidad_tss(id_causa_inhabilidad, tipo_causa) = 'N' --no inhabilitado en TSS
               ) conteo
          from suirplus.sre_ciudadanos_t
         where limpiar_municipio_acta(municipio_acta) = limpiar_municipio_acta(p_mun)
            --
           and limpiar_ano_acta(ano_acta) = limpiar_ano_acta(p_ano)
            --
           and limpiar_numero_acta(numero_acta) = limpiar_numero_acta(p_num)
            --
           and limpiar_folio_acta(folio_acta)= limpiar_folio_acta(p_fol)
            --
           and limpiar_libro_acta(libro_acta, ano_acta) = limpiar_libro_acta(p_lib, p_ano)
            --
           and limpiar_oficialia_acta(oficialia_acta) = limpiar_oficialia_acta(p_ofi)
            --
           and sinnumeros(nombres, primer_apellido, sexo) = sinnumeros(p_nom, p_ape, p_sex)
            --
           and fecha_nacimiento = to_date(limpiar_fecha_nacimiento(p_fec),'ddmmyyyy')
            --
           and tipo_documento = 'N' --Menor sin documento
            --
           and validar_inhabilidad_tss(id_causa_inhabilidad, tipo_causa) = 'N' --no inhabilitado en TSS
         order by id_nss;

      return true;
    elsif upper(p_proceso) = 'CN' then -- Actualizacion de NSS
      select count(*)
        into v_conteo
        from suirplus.sre_ciudadanos_t
       where limpiar_datos_acta(municipio_acta, ano_acta, numero_acta, folio_acta, libro_acta, oficialia_acta)
           = limpiar_datos_acta(p_mun, p_ano, p_num, p_fol, p_lib, p_ofi)
         --
         and sinnumeros(nombres, primer_apellido, sexo)
           = sinnumeros(p_nom, p_ape, p_sex)
         --
         and fecha_nacimiento = to_date(limpiar_fecha_nacimiento(p_fec),'ddmmyyyy')
         --
         and nvl(tipo_causa,'!') <> 'C'
         --
         and tipo_documento = 'N'; --menor sin documento

      if v_conteo > 1 then
        return false;
      end if;
      return true;
    elsif upper(p_proceso) = 'J4' then -- Actualizacion de NSS via Pagina
      select count(*)
        into v_conteo
        from suirplus.sre_ciudadanos_t
       where limpiar_datos_acta(municipio_acta, ano_acta, numero_acta, folio_acta, libro_acta, oficialia_acta)
           = limpiar_datos_acta(p_mun, p_ano, p_num, p_fol, p_lib, p_ofi)
         --
         and sinnumeros(nombres, primer_apellido, sexo)
           = sinnumeros(p_nom, p_ape, p_sex)
         --
         and fecha_nacimiento = to_date(limpiar_fecha_nacimiento(p_fec),'ddmmyyyy')
         --
         and (tipo_causa is null or tipo_causa = 'I')
         --
         and tipo_documento in ('U','N','E'); --Menor con o sin documento y extranjero

      if v_conteo > 0 then
        return false;
      end if;
      return true;
    end if;

    return false;
  exception when others then
    return false;
  end;

  -- Valida nombre y acta de nacimiento duplicada excluyendo la fecha nacimiento
  function nomacta_nofecha_duplicada(p_mun  in varchar2,
                                     p_ano  in varchar2,
                                     p_num  in varchar2,
                                     p_fol  in varchar2,
                                     p_lib  in varchar2,
                                     p_ofi in varchar2,
                                     p_nom  in varchar2,
                                     p_ape  in varchar2,
                                     p_sex in varchar2,
                                     p_proceso in varchar2,
                                     p_id_estatus out number,
                                     p_id_error out varchar2,
                                     p_cursor out sys_refcursor) return boolean is
    v_conteo number;
    l_estatus char(1);
  begin
/*
    Validacion #4
    se incluyen:
      Primer nombre.
      Primer apellido.
      Todos los datos del acta.
      El sexo.
      NO FECHA NACIMIENTO.
*/
    if upper(p_proceso) = '76' then -- ASIGNACION DE NSS A MENORES SIN DOCUMENTO NACIONALES
      OPEN p_cursor FOR
        select id_nss
          from suirplus.sre_ciudadanos_t
         where limpiar_municipio_acta(municipio_acta) = limpiar_municipio_acta(p_mun)
            --
           and limpiar_ano_acta(ano_acta) = limpiar_ano_acta(p_ano)
            --
           and limpiar_numero_acta(numero_acta) = limpiar_numero_acta(p_num)
            --
           and limpiar_folio_acta(folio_acta)= limpiar_folio_acta(p_fol)
            --
           and limpiar_libro_acta(libro_acta, ano_acta) = limpiar_libro_acta(p_lib, p_ano)
            --
           and limpiar_oficialia_acta(oficialia_acta) = limpiar_oficialia_acta(p_ofi)
            --
           and sinnumeros(nombres, primer_apellido, sexo) = sinnumeros(p_nom, p_ape, p_sex)
            --
           and tipo_documento in ('C','P','U','N','E') --Cedulado, Pasaporte, Menor con o sin documento y Menor Extranjero
            --
           and validar_inhabilidad_tss(id_causa_inhabilidad, tipo_causa) = 'N' --no inhabilitado en TSS
         order by id_nss;

      return true;
    elsif upper(p_proceso) = '77' then -- ASIGNACION DE NSS A MENORES SIN DOCUMENTO EXTRANJEROS
      OPEN p_cursor FOR
        select id_nss
          from suirplus.sre_ciudadanos_t
         where limpiar_municipio_acta(municipio_acta) = limpiar_municipio_acta(p_mun)
            --
           and limpiar_ano_acta(ano_acta) = limpiar_ano_acta(p_ano)
            --
           and limpiar_numero_acta(numero_acta) = limpiar_numero_acta(p_num)
            --
           and limpiar_folio_acta(folio_acta)= limpiar_folio_acta(p_fol)
            --
           and limpiar_libro_acta(libro_acta, ano_acta) = limpiar_libro_acta(p_lib, p_ano)
            --
           and limpiar_oficialia_acta(oficialia_acta) = limpiar_oficialia_acta(p_ofi)
            --
           and sinnumeros(nombres, primer_apellido, sexo) = sinnumeros(p_nom, p_ape, p_sex)
            --
           and tipo_documento in ('C','P','U','N','E') --Cedulado, Pasaporte, Menor con o sin documento y Menor Extranjero
            --
           and validar_inhabilidad_tss(id_causa_inhabilidad, tipo_causa) = 'N' --no inhabilitado en TSS
         order by id_nss;

      return true;
    elsif upper(p_proceso) = 'CN' then -- Actualizacion de NSS
      select count(*)
        into v_conteo
        from suirplus.sre_ciudadanos_t
       where limpiar_datos_acta(municipio_acta, ano_acta, numero_acta, folio_acta, libro_acta, oficialia_acta)
           = limpiar_datos_acta(p_mun, p_ano, p_num, p_fol, p_lib, p_ofi)
         --
         and sinnumeros(nombres, primer_apellido, sexo)
           = sinnumeros(p_nom, p_ape, p_sex)
         --
         and nvl(tipo_causa,'!') <> 'C'
         --
         and tipo_documento = 'N'; --menor sin documento

      if v_conteo > 1 then
        return false;
      end if;

      return true;
    elsif upper(p_proceso) = 'J4' then -- Actualizacion de NSS via Pagina
      select count(*)
        into v_conteo
        from suirplus.sre_ciudadanos_t
       where limpiar_datos_acta(municipio_acta, ano_acta, numero_acta, folio_acta, libro_acta, oficialia_acta)
           = limpiar_datos_acta(p_mun, p_ano, p_num, p_fol, p_lib, p_ofi)
         --
         and sinnumeros(nombres, primer_apellido, sexo)
           = sinnumeros(p_nom, p_ape, p_sex)
         --
         and (tipo_causa is null or tipo_causa = 'I')
         --
         and tipo_documento in ('U','N','E'); --Menor con o sin documento y extranjero

      if v_conteo > 0 then
        return false;
      end if;

      return true;
    end if;

    return false;
  exception when others then
    return false;
  end;

  -- Valida nombre duplicado con su acta. Esta validacion prospera solo si el libro es diferente
  function nomacta_diflibro_duplicada(p_mun  in varchar2,
                                      p_ano  in varchar2,
                                      p_num  in varchar2,
                                      p_fol  in varchar2,
                                      p_lib  in varchar2,
                                      p_ofi in varchar2,
                                      p_nom  in varchar2,
                                      p_ape  in varchar2,
                                      p_fec  in varchar2,
                                      p_sex in varchar2,
                                      p_proceso in varchar2,
                                      p_id_estatus out number,
                                      p_id_error out varchar2,
                                      p_cursor out sys_refcursor) return boolean is
    v_conteo number;
    l_estatus char(1);
  begin
/*
    Validacion #5
    se incluyen:
      Primer nombre.
      Primer apellido.
      Todos los datos del acta, PERO DIFERENTE LIBRO DEL ACTA.
      La fecha nacimiento.
*/
    if upper(p_proceso) = '76' then -- ASIGNACION DE NSS A MENORES SIN DOCUMENTO NACIONALES
      OPEN p_cursor FOR
        select id_nss
          from suirplus.sre_ciudadanos_t a
         where limpiar_municipio_acta(municipio_acta) = limpiar_municipio_acta(p_mun)
            --
           and limpiar_ano_acta(ano_acta) = limpiar_ano_acta(p_ano)
            --
           and limpiar_numero_acta(numero_acta) = limpiar_numero_acta(p_num)
            --
           and limpiar_folio_acta(folio_acta)= limpiar_folio_acta(p_fol)
            --
           and limpiar_libro_acta(libro_acta, ano_acta) != limpiar_libro_acta(p_lib, p_ano)
            --
           and limpiar_oficialia_acta(oficialia_acta) = limpiar_oficialia_acta(p_ofi)
            --
           and sinnumeros(a.nombres, a.primer_apellido, a.sexo) = sinnumeros(p_nom, p_ape, p_sex)
            --
           and a.fecha_nacimiento = to_date( limpiar_Fecha_nacimiento(p_fec),'ddmmyyyy')
            --
           and a.tipo_documento in ('C','P','U','N','E') --Cedulado, Pasaporte, Menor con o sin documento y Menor Extranjero
            --
           and validar_inhabilidad_tss(id_causa_inhabilidad, tipo_causa) = 'N' --no inhabilitado en TSS
         order by id_nss;

      return true;
    elsif upper(p_proceso) = '77' then -- ASIGNACION DE NSS A MENORES SIN DOCUMENTO EXTRANJEROS
      OPEN p_cursor FOR
        select id_nss
          from suirplus.sre_ciudadanos_t a
         where limpiar_municipio_acta(municipio_acta) = limpiar_municipio_acta(p_mun)
            --
           and limpiar_ano_acta(ano_acta) = limpiar_ano_acta(p_ano)
            --
           and limpiar_numero_acta(numero_acta) = limpiar_numero_acta(p_num)
            --
           and limpiar_folio_acta(folio_acta)= limpiar_folio_acta(p_fol)
            --
           and limpiar_libro_acta(libro_acta, ano_acta) != limpiar_libro_acta(p_lib, p_ano)
            --
           and limpiar_oficialia_acta(oficialia_acta) = limpiar_oficialia_acta(p_ofi)
            --
           and sinnumeros(a.nombres, a.primer_apellido, a.sexo) = sinnumeros(p_nom, p_ape, p_sex)
            --
           and a.fecha_nacimiento = to_date( limpiar_Fecha_nacimiento(p_fec),'ddmmyyyy')
            --
           and a.tipo_documento in ('C','P','U','N','E') --Cedulado, Pasaporte, Menor con o sin documento y Menor Extranjero
            --
           and validar_inhabilidad_tss(id_causa_inhabilidad, tipo_causa) = 'N' --no inhabilitado en TSS
         order by id_nss;

      return true;
    elsif upper(p_proceso) = 'CN' then -- Actualizacion de NSS
      select count(id_nss) into v_conteo
        from suirplus.sre_ciudadanos_t a
       where sinnumeros(a.nombres, a.primer_apellido, a.sexo)
           = sinnumeros(p_nom, p_ape, p_sex)
         --
         and a.fecha_nacimiento = to_date(limpiar_Fecha_nacimiento(p_fec),'ddmmyyyy')
         --
         and limpiar_datos_acta(municipio_acta, ano_acta, numero_acta, folio_acta, libro_acta, oficialia_acta, p_exc => 'L')
           = limpiar_datos_acta(p_mun, p_ano, p_num, p_fol, p_lib, p_ofi, p_exc => 'L')
         --
         and limpiar_libro_acta(a.libro_acta, a.ano_acta) != limpiar_libro_acta(p_lib, p_ano)
         --
         and nvl(a.tipo_causa,'!') <> 'C'
         --
         and a.tipo_documento = 'N'; --menor sin documento

      if v_conteo > 1 then
        return false;
      end if;

      return true;
    elsif upper(p_proceso) = 'J4' then -- Actualizacion de NSS via Pagina
      select count(id_nss) into v_conteo
        from suirplus.sre_ciudadanos_t a
       where sinnumeros(a.nombres, a.primer_apellido, a.sexo)
           = sinnumeros(p_nom, p_ape, p_sex)
         --
         and a.fecha_nacimiento = to_date(limpiar_Fecha_nacimiento(p_fec),'ddmmyyyy')
         --
         and limpiar_datos_acta(municipio_acta, ano_acta, numero_acta, folio_acta, libro_acta, oficialia_acta, p_exc => 'L')
           = limpiar_datos_acta(p_mun, p_ano, p_num, p_fol, p_lib, p_ofi, p_exc => 'L')
         --
         and limpiar_libro_acta(a.libro_acta, a.ano_acta) != limpiar_libro_acta(p_lib, p_ano)
         --
         and (tipo_causa is null or tipo_causa = 'I')
         --
         and tipo_documento in ('U','N','E'); --Menor con o sin documento y extranjero

      if v_conteo > 0 then
        return false;
      end if;

      return true;
    end if;

    return false;
  exception when others then
    return false;
  end;

  -- Valida nombre y acta de nacimiento duplicada excluyendo el sexo
  function nomacta_nosexo_duplicada(p_mun  in varchar2,
                                    p_ano  in varchar2,
                                    p_num  in varchar2,
                                    p_fol  in varchar2,
                                    p_lib  in varchar2,
                                    p_ofi in varchar2,
                                    p_nom  in varchar2,
                                    p_ape  in varchar2,
                                    p_fec  in varchar2,
                                    p_proceso in varchar2,
                                    p_id_estatus out number,
                                    p_id_error out varchar2,
                                    p_cursor out sys_refcursor) return boolean is
    v_conteo number;
    l_estatus char(1);
  begin
/*
    Validacion #6
    se incluyen:
      Primer nombre.
      Primer apellido.
      Todos los datos del acta.
      La fecha de nacimiento.
      NO SEXO.
*/
    if upper(p_proceso) = '76' then -- ASIGNACION DE NSS A MENORES SIN DOCUMENTO NACIONALES
      OPEN p_cursor FOR
        select id_nss
          from suirplus.sre_ciudadanos_t
         where limpiar_municipio_acta(municipio_acta) = limpiar_municipio_acta(p_mun)
            --
           and limpiar_ano_acta(ano_acta) = limpiar_ano_acta(p_ano)
            --
           and limpiar_numero_acta(numero_acta) = limpiar_numero_acta(p_num)
            --
           and limpiar_folio_acta(folio_acta)= limpiar_folio_acta(p_fol)
            --
           and limpiar_libro_acta(libro_acta, ano_acta) = limpiar_libro_acta(p_lib, p_ano)
            --
           and limpiar_oficialia_acta(oficialia_acta) = limpiar_oficialia_acta(p_ofi)
            --
           and sinnumeros(nombres, primer_apellido) = sinnumeros(p_nom, p_ape)
            --
           and fecha_nacimiento = to_date(limpiar_fecha_nacimiento(p_fec),'ddmmyyyy')
            --
           and tipo_documento in ('C','P','U','N','E') --Cedulado, Pasaporte, Menor con o sin documento y Menor Extranjero
            --
           and validar_inhabilidad_tss(id_causa_inhabilidad, tipo_causa) = 'N' --no inhabilitado en TSS
         order by id_nss;

      return true;
    elsif upper(p_proceso) = '77' then -- ASIGNACION DE NSS A MENORES SIN DOCUMENTO EXTRANJEROS
      OPEN p_cursor FOR
        select id_nss
          from suirplus.sre_ciudadanos_t
         where limpiar_municipio_acta(municipio_acta) = limpiar_municipio_acta(p_mun)
            --
           and limpiar_ano_acta(ano_acta) = limpiar_ano_acta(p_ano)
            --
           and limpiar_numero_acta(numero_acta) = limpiar_numero_acta(p_num)
            --
           and limpiar_folio_acta(folio_acta)= limpiar_folio_acta(p_fol)
            --
           and limpiar_libro_acta(libro_acta, ano_acta) = limpiar_libro_acta(p_lib, p_ano)
            --
           and limpiar_oficialia_acta(oficialia_acta) = limpiar_oficialia_acta(p_ofi)
            --
           and sinnumeros(nombres, primer_apellido) = sinnumeros(p_nom, p_ape)
            --
           and fecha_nacimiento = to_date(limpiar_fecha_nacimiento(p_fec),'ddmmyyyy')
            --
           and tipo_documento in ('C','P','U','N','E') --Cedulado, Pasaporte, Menor con o sin documento y Menor Extranjero
            --
           and validar_inhabilidad_tss(id_causa_inhabilidad, tipo_causa) = 'N' --no inhabilitado en TSS
         order by id_nss;

      return true;
    elsif upper(p_proceso) = 'CN' then -- Actualizacion de NSS
      select count(*)
        into v_conteo
        from suirplus.sre_ciudadanos_t
       where limpiar_datos_acta(municipio_acta, ano_acta, numero_acta, folio_acta, libro_acta, oficialia_acta)
           = limpiar_datos_acta(p_mun, p_ano, p_num, p_fol, p_lib, p_ofi)
         --
         and fecha_nacimiento = to_date(limpiar_fecha_nacimiento(p_fec),'ddmmyyyy')
         --
         and sinnumeros(nombres, primer_apellido) = sinnumeros(p_nom, p_ape)
         --
         and nvl(tipo_causa,'!') <> 'C'
         --
         and tipo_documento = 'N'; --menor sin documento

      if v_conteo > 1 then
        return false;
      end if;

      return true;
    elsif upper(p_proceso) = 'J4' then -- Actualizacion de NSS via Pagina
      select count(*)
        into v_conteo
        from suirplus.sre_ciudadanos_t
       where limpiar_datos_acta(municipio_acta, ano_acta, numero_acta, folio_acta, libro_acta, oficialia_acta)
           = limpiar_datos_acta(p_mun, p_ano, p_num, p_fol, p_lib, p_ofi)
         --
         and fecha_nacimiento = to_date(limpiar_fecha_nacimiento(p_fec),'ddmmyyyy')
         --
         and sinnumeros(nombres, primer_apellido) = sinnumeros(p_nom, p_ape)
         --
         and (tipo_causa is null or tipo_causa = 'I')
         --
         and tipo_documento in ('U','N','E'); --Menor con o sin documento y extranjero

      if v_conteo > 0 then
        return false;
      end if;

      return true;
    end if;

    return false;
  exception when others then
    return false;
  end;

  -- Valida nombre y acta de nacimiento duplicada excluyendo la fecha nacimiento y el sexo
  function nomacta_nosexofecha_duplicada(p_mun in varchar2,
                                         p_ano in varchar2,
                                         p_num in varchar2,
                                         p_fol in varchar2,
                                         p_lib in varchar2,
                                         p_ofi in varchar2,
                                         p_nom in varchar2,
                                         p_ape in varchar2,
                                         p_proceso in varchar2,
                                         p_id_estatus out number,
                                         p_id_error out varchar2,
                                         p_cursor out sys_refcursor) return boolean is
    v_conteo number;
    l_estatus char(1);
  begin
/*
    Validacion #7
    se incluyen:
      Primer nombre.
      Primer apellido.
      Todos los datos del acta.
      NO FECHA DE NACIMIENTO.
      NO SEXO.
*/
    if upper(p_proceso) = 'AN' then -- Asignacion de NSS
      OPEN p_cursor FOR
        select id_nss
          from suirplus.sre_ciudadanos_t
         where limpiar_municipio_acta(municipio_acta) = limpiar_municipio_acta(p_mun)
            --
           and limpiar_ano_acta(ano_acta) = limpiar_ano_acta(p_ano)
            --
           and limpiar_numero_acta(numero_acta) = limpiar_numero_acta(p_num)
            --
           and limpiar_folio_acta(folio_acta)= limpiar_folio_acta(p_fol)
            --
           and limpiar_libro_acta(libro_acta, ano_acta) = limpiar_libro_acta(p_lib, p_ano)
            --
           and limpiar_oficialia_acta(oficialia_acta) = limpiar_oficialia_acta(p_ofi)
            --
           and sinnumeros(nombres, primer_apellido) = sinnumeros(p_nom, p_ape)
            --
           and tipo_documento in ('C','P','U','N','E') --Cedulado, Pasaporte, Menor con o sin documento y Menor Extranjero
            --
           and validar_inhabilidad_tss(id_causa_inhabilidad, tipo_causa) = 'N' --no inhabilitado en TSS
         order by id_nss;

      return true;
    elsif upper(p_proceso) = 'CN' then -- Actualizacion de NSS
      select count(*)
        into v_conteo
        from suirplus.sre_ciudadanos_t
       where limpiar_datos_acta(municipio_acta, ano_acta, numero_acta, folio_acta, libro_acta, oficialia_acta)
           = limpiar_datos_acta(p_mun, p_ano, p_num, p_fol, p_lib, p_ofi)
         --
         and sinnumeros(nombres, primer_apellido) = sinnumeros(p_nom, p_ape)
         --
         and nvl(tipo_causa,'!') <> 'C'
         --
         and tipo_documento = 'N'; --menor sin documento

      if v_conteo > 1 then
        return false;
      end if;

      return true;
    elsif upper(p_proceso) = 'J4' then -- Actualizacion de NSS via Pagina
      select count(*)
        into v_conteo
        from suirplus.sre_ciudadanos_t
       where limpiar_datos_acta(municipio_acta, ano_acta, numero_acta, folio_acta, libro_acta, oficialia_acta)
           = limpiar_datos_acta(p_mun, p_ano, p_num, p_fol, p_lib, p_ofi)
         --
         and sinnumeros(nombres, primer_apellido) = sinnumeros(p_nom, p_ape)
         --
         and (tipo_causa is null or tipo_causa = 'I')
         --
         and tipo_documento in ('U','N','E'); --Menor con o sin documento y extranjero

      if v_conteo > 0 then
        return false;
      end if;

      return true;
    end if;

    return false;
  exception when others then
    return false;
  end;

  -- Valida nombre duplicado, toma en cuenta primer nombre, primer apellido y la fecha de nacimiento, deja el sexo
  function nombre_nosexo_duplicada(p_nom in varchar2,
                                   p_ape in varchar2,
                                   p_fec in varchar2,
                                   p_proceso in varchar2,
                                   p_id_estatus out number,
                                   p_id_error out varchar2,
                                   p_cursor out sys_refcursor) return boolean is
    v_conteo number;
    l_estatus char(1);
  begin
/*
    Validacion #8
    se incluyen:
      Primer nombre.
      Primer apellido.
      Todos los datos del acta.
      NO SEXO.
*/
    if upper(p_proceso) = '76' then -- ASIGNACION DE NSS A MENORES SIN DOCUMENTO NACIONALES
      OPEN p_cursor FOR
        select id_nss
         from suirplus.sre_ciudadanos_t
        where sinNumeros(nombres, primer_apellido) = sinNumeros(p_nom, p_ape)
           --
          and fecha_nacimiento = to_date(limpiar_fecha_nacimiento(p_fec),'ddmmyyyy')
           --
          and tipo_documento in ('C','P','U','N','E') --Cedulado, Pasaporte, Menor con o sin documento y Menor Extranjero
           --
          and validar_inhabilidad_tss(id_causa_inhabilidad, tipo_causa) = 'N' --no inhabilitado en TSS
        order by id_nss;

      return true;
    elsif upper(p_proceso) = '77' then -- ASIGNACION DE NSS A MENORES SIN DOCUMENTO EXTRANJEROS
      OPEN p_cursor FOR
        select id_nss
         from suirplus.sre_ciudadanos_t
        where sinNumeros(nombres, primer_apellido) = sinNumeros(p_nom, p_ape)
           --
          and fecha_nacimiento = to_date(limpiar_fecha_nacimiento(p_fec),'ddmmyyyy')
           --
          and tipo_documento in ('C','P','U','N','E') --Cedulado, Pasaporte, Menor con o sin documento y Menor Extranjero
           --
          and validar_inhabilidad_tss(id_causa_inhabilidad, tipo_causa) = 'N' --no inhabilitado en TSS
        order by id_nss;

      return true;
    elsif upper(p_proceso) = 'CN' then -- Actualizacion de NSS
      select count(id_nss) into v_conteo
        from suirplus.sre_ciudadanos_t a
       where sinNumeros(a.nombres, a.primer_apellido) = sinNumeros(p_nom, p_ape)
         --
         and a.fecha_nacimiento = to_date(limpiar_fecha_nacimiento(p_fec),'ddmmyyyy')
         --
         and nvl(a.tipo_causa,'!') <> 'C'
         --
         and a.tipo_documento = 'N'; --menor sin documento

      if v_conteo > 1 then
        return false;
      end if;

      return true;
    elsif upper(p_proceso) = 'J4' then -- Actualizacion de NSS via Pagina
      select count(id_nss) into v_conteo
        from suirplus.sre_ciudadanos_t a
       where sinNumeros(a.nombres, a.primer_apellido) = sinNumeros(p_nom, p_ape)
         --
         and a.fecha_nacimiento = to_date(limpiar_fecha_nacimiento(p_fec),'ddmmyyyy')
         --
         and (a.tipo_causa is null or a.tipo_causa = 'I')
         --
         and a.tipo_documento in ('U','N','E'); --Menor con o sin documento y extranjero

      if v_conteo > 0 then
        return false;
      end if;

      return true;
    end if;

    return false;
  exception when others then
    return false;
  end;

  -- Valida nombre, acta de nacimiento, tipo de documento y diferente nro documento duplicado
  function nombre_acta_tip_difdoc_dup(p_mun in varchar2,
                                      p_ano in varchar2,
                                      p_num in varchar2,
                                      p_fol in varchar2,
                                      p_lib in varchar2,
                                      p_ofi in varchar2,
                                      p_nom in varchar2,
                                      p_ape in varchar2,
                                      p_sex in varchar2,
                                      p_fec in varchar2,
                                      p_tip in varchar2,
                                      p_doc in varchar2,
                                      p_proceso in varchar2,
                                      p_id_estatus out number,
                                      p_id_error out varchar2,
                                      p_cursor out sys_refcursor) return boolean is
    l_estatus char(1);
  begin
/*
    Validacion #10
*/
    if upper(p_proceso) = '69' then -- Asignacion de NSS a MENOR CON NUI
      OPEN p_cursor FOR
        select id_nss,
              (
               select count(*)
               from suirplus.sre_ciudadanos_t
               where no_documento != p_doc --Documento diferente
                  -- 
                 and tipo_documento = p_tip
                  --
                 and limpiar_municipio_acta(municipio_acta) = limpiar_municipio_acta(p_mun)
                  --
                 and limpiar_ano_acta(ano_acta) = limpiar_ano_acta(p_ano)
                  --
                 and limpiar_numero_acta(numero_acta) = limpiar_numero_acta(p_num)
                  --
                 and limpiar_folio_acta(folio_acta)= limpiar_folio_acta(p_fol)
                  --
                 and limpiar_libro_acta(libro_acta, ano_acta) = limpiar_libro_acta(p_lib, p_ano)
                  --
                 and limpiar_oficialia_acta(oficialia_acta) = limpiar_oficialia_acta(p_ofi)
                  --
                 and sinnumeros(nombres, primer_apellido, sexo) = sinnumeros(p_nom, p_ape, p_sex)
                  --
                 and fecha_nacimiento = to_date(limpiar_fecha_nacimiento(p_fec),'ddmmyyyy')
                  --
                 and validar_inhabilidad_tss(id_causa_inhabilidad, tipo_causa) = 'N' --no inhabilitado en TSS
               ) conteo
          from suirplus.sre_ciudadanos_t
         where no_documento != p_doc --Documento diferente
            -- 
           and tipo_documento = p_tip
            --
           and limpiar_municipio_acta(municipio_acta) = limpiar_municipio_acta(p_mun)
            --
           and limpiar_ano_acta(ano_acta) = limpiar_ano_acta(p_ano)
            --
           and limpiar_numero_acta(numero_acta) = limpiar_numero_acta(p_num)
            --
           and limpiar_folio_acta(folio_acta)= limpiar_folio_acta(p_fol)
            --
           and limpiar_libro_acta(libro_acta, ano_acta) = limpiar_libro_acta(p_lib, p_ano)
            --
           and limpiar_oficialia_acta(oficialia_acta) = limpiar_oficialia_acta(p_ofi)
            --
           and sinnumeros(nombres, primer_apellido, sexo) = sinnumeros(p_nom, p_ape, p_sex)
            --
           and fecha_nacimiento = to_date(limpiar_fecha_nacimiento(p_fec),'ddmmyyyy')
            --
           and validar_inhabilidad_tss(id_causa_inhabilidad, tipo_causa) = 'N' --no inhabilitado en TSS
         order by id_nss;

      return true;
    end if;
    return false;  
  exception when others then
    return false;
  end;

  -- Valida nombre, acta de nacimiento, tipo documento, nro documento duplicado
  function nombre_acta_tip_doc_dup(p_mun in varchar2,
                                   p_ano in varchar2,
                                   p_num in varchar2,
                                   p_fol in varchar2,
                                   p_lib in varchar2,
                                   p_ofi in varchar2,
                                   p_nom in varchar2,
                                   p_ape in varchar2,
                                   p_sex in varchar2,
                                   p_fec in varchar2,
                                   p_tip in varchar2,
                                   p_doc in varchar2,                                   
                                   p_proceso in varchar2,
                                   p_id_estatus out number,
                                   p_id_error out varchar2,
                                   p_cursor out sys_refcursor) return boolean is
    l_estatus char(1);
  begin
/*
    Validacion #11
*/
    if upper(p_proceso) = '74' then -- Asignacion de NSS a MENOR CON CEDULA
      OPEN p_cursor FOR
        select id_nss,
              (
               select count(*)
               from suirplus.sre_ciudadanos_t
               where no_documento = p_doc
                  -- 
                 and tipo_documento = p_tip
                  --
                 and limpiar_municipio_acta(municipio_acta) = limpiar_municipio_acta(p_mun)
                  --
                 and limpiar_ano_acta(ano_acta) = limpiar_ano_acta(p_ano)
                  --
                 and limpiar_numero_acta(numero_acta) = limpiar_numero_acta(p_num)
                  --
                 and limpiar_folio_acta(folio_acta)= limpiar_folio_acta(p_fol)
                  --
                 and limpiar_libro_acta(libro_acta, ano_acta) = limpiar_libro_acta(p_lib, p_ano)
                  --
                 and limpiar_oficialia_acta(oficialia_acta) = limpiar_oficialia_acta(p_ofi)
                  --
                 and sinnumeros(nombres, primer_apellido, sexo) = sinnumeros(p_nom, p_ape, p_sex)
                  --
                 and fecha_nacimiento = to_date(limpiar_fecha_nacimiento(p_fec),'ddmmyyyy')
                  --
                 and validar_inhabilidad_tss(id_causa_inhabilidad, tipo_causa) = 'N' --no inhabilitado en TSS
               ) conteo
          from suirplus.sre_ciudadanos_t
         where no_documento = p_doc
            -- 
           and tipo_documento = p_tip
            --
           and limpiar_municipio_acta(municipio_acta) = limpiar_municipio_acta(p_mun)
            --
           and limpiar_ano_acta(ano_acta) = limpiar_ano_acta(p_ano)
            --
           and limpiar_numero_acta(numero_acta) = limpiar_numero_acta(p_num)
            --
           and limpiar_folio_acta(folio_acta)= limpiar_folio_acta(p_fol)
            --
           and limpiar_libro_acta(libro_acta, ano_acta) = limpiar_libro_acta(p_lib, p_ano)
            --
           and limpiar_oficialia_acta(oficialia_acta) = limpiar_oficialia_acta(p_ofi)
            --
           and sinnumeros(nombres, primer_apellido, sexo) = sinnumeros(p_nom, p_ape, p_sex)
            --
           and fecha_nacimiento = to_date(limpiar_fecha_nacimiento(p_fec),'ddmmyyyy')
            --
           and validar_inhabilidad_tss(id_causa_inhabilidad, tipo_causa) = 'N' --no inhabilitado en TSS
         order by id_nss;

      return true;
    end if;
    return false;  
  exception when others then
    return false;
  end;

  -- Valida nombre, acta de nacimiento, tipo documento duplicado
  function nombre_acta_tip_dup(p_mun in varchar2,
                               p_ano in varchar2,
                               p_num in varchar2,
                               p_fol in varchar2,
                               p_lib in varchar2,
                               p_ofi in varchar2,
                               p_nom in varchar2,
                               p_ape in varchar2,
                               p_sex in varchar2,
                               p_fec in varchar2,
                               p_tip in varchar2,
                               p_proceso in varchar2,
                               p_id_estatus out number,
                               p_id_error out varchar2,
                               p_cursor out sys_refcursor) return boolean is
    l_estatus char(1);
  begin
/*
    Validacion #12
*/
    if upper(p_proceso) = '69' then -- Asignacion de NSS a MENOR CON NUI
      OPEN p_cursor FOR
        select id_nss,
              (
               select count(*)
               from suirplus.sre_ciudadanos_t
               where tipo_documento = p_tip
                  --
                 and limpiar_municipio_acta(municipio_acta) = limpiar_municipio_acta(p_mun)
                  --
                 and limpiar_ano_acta(ano_acta) = limpiar_ano_acta(p_ano)
                  --
                 and limpiar_numero_acta(numero_acta) = limpiar_numero_acta(p_num)
                  --
                 and limpiar_folio_acta(folio_acta)= limpiar_folio_acta(p_fol)
                  --
                 and limpiar_libro_acta(libro_acta, ano_acta) = limpiar_libro_acta(p_lib, p_ano)
                  --
                 and limpiar_oficialia_acta(oficialia_acta) = limpiar_oficialia_acta(p_ofi)
                  --
                 and sinnumeros(nombres, primer_apellido, sexo) = sinnumeros(p_nom, p_ape, p_sex)
                  --
                 and fecha_nacimiento = to_date(limpiar_fecha_nacimiento(p_fec),'ddmmyyyy')
                  --
                 and validar_inhabilidad_tss(id_causa_inhabilidad, tipo_causa) = 'N' --no inhabilitado en TSS
               ) conteo
          from suirplus.sre_ciudadanos_t
         where tipo_documento = p_tip
            --
           and limpiar_municipio_acta(municipio_acta) = limpiar_municipio_acta(p_mun)
            --
           and limpiar_ano_acta(ano_acta) = limpiar_ano_acta(p_ano)
            --
           and limpiar_numero_acta(numero_acta) = limpiar_numero_acta(p_num)
            --
           and limpiar_folio_acta(folio_acta)= limpiar_folio_acta(p_fol)
            --
           and limpiar_libro_acta(libro_acta, ano_acta) = limpiar_libro_acta(p_lib, p_ano)
            --
           and limpiar_oficialia_acta(oficialia_acta) = limpiar_oficialia_acta(p_ofi)
            --
           and sinnumeros(nombres, primer_apellido, sexo) = sinnumeros(p_nom, p_ape, p_sex)
            --
           and fecha_nacimiento = to_date(limpiar_fecha_nacimiento(p_fec),'ddmmyyyy')
            --
           and validar_inhabilidad_tss(id_causa_inhabilidad, tipo_causa) = 'N' --no inhabilitado en TSS
         order by id_nss;

      return true;
    elsif upper(p_proceso) = '74' then -- Asignacion de NSS a CEDULADO
      OPEN p_cursor FOR
        select id_nss,
              (
               select count(*)
               from suirplus.sre_ciudadanos_t
               where tipo_documento = p_tip
                  --
                 and limpiar_municipio_acta(municipio_acta) = limpiar_municipio_acta(p_mun)
                  --
                 and limpiar_ano_acta(ano_acta) = limpiar_ano_acta(p_ano)
                  --
                 and limpiar_numero_acta(numero_acta) = limpiar_numero_acta(p_num)
                  --
                 and limpiar_folio_acta(folio_acta)= limpiar_folio_acta(p_fol)
                  --
                 and limpiar_libro_acta(libro_acta, ano_acta) = limpiar_libro_acta(p_lib, p_ano)
                  --
                 and limpiar_oficialia_acta(oficialia_acta) = limpiar_oficialia_acta(p_ofi)
                  --
                 and sinnumeros(nombres, primer_apellido, sexo) = sinnumeros(p_nom, p_ape, p_sex)
                  --
                 and fecha_nacimiento = to_date(limpiar_fecha_nacimiento(p_fec),'ddmmyyyy')
                  --
                 and validar_inhabilidad_tss(id_causa_inhabilidad, tipo_causa) = 'N' --no inhabilitado en TSS
               ) conteo
          from suirplus.sre_ciudadanos_t
         where tipo_documento = p_tip
            --
           and limpiar_municipio_acta(municipio_acta) = limpiar_municipio_acta(p_mun)
            --
           and limpiar_ano_acta(ano_acta) = limpiar_ano_acta(p_ano)
            --
           and limpiar_numero_acta(numero_acta) = limpiar_numero_acta(p_num)
            --
           and limpiar_folio_acta(folio_acta)= limpiar_folio_acta(p_fol)
            --
           and limpiar_libro_acta(libro_acta, ano_acta) = limpiar_libro_acta(p_lib, p_ano)
            --
           and limpiar_oficialia_acta(oficialia_acta) = limpiar_oficialia_acta(p_ofi)
            --
           and sinnumeros(nombres, primer_apellido, sexo) = sinnumeros(p_nom, p_ape, p_sex)
            --
           and fecha_nacimiento = to_date(limpiar_fecha_nacimiento(p_fec),'ddmmyyyy')
            --
           and validar_inhabilidad_tss(id_causa_inhabilidad, tipo_causa) = 'N' --no inhabilitado en TSS
         order by id_nss;

      return true;
    end if;
    
    return false;  
  exception when others then
    return false;
  end;

  -- Valida nombre duplicado, toma en cuenta primer nombre, primer apellido, sexo y la fecha de nacimiento, deja fuera los cinco campos del acta
  function validar_nombre_duplicado_JCE(p_mun      in varchar2,
                                        p_ano      in varchar2,
                                        p_num      in varchar2,
                                        p_fol      in varchar2,
                                        p_lib      in varchar2,
                                        p_ofi      in varchar2,
                                        p_nom      in varchar2,
                                        p_ape      in varchar2,
                                        p_fec      in varchar2,
                                        p_nss      out number,
                                        p_count    out number,
                                        p_proceso  in varchar2,
                                        p_estado   out boolean) return boolean is
    l_estado char(1);
  begin
    -- Para saber si esta encendida en la configuracion de funciones
    begin
      select upper(d.estado)
        into l_estado
        from suirplus.sre_ciudadanos_api_t c
        join suirplus.sre_det_ciudadanos_api_t d
          on d.id_ciu_api = c.id_ciu_api
         and d.id_proceso = p_proceso -- Vital
       where upper(c.nombre_api) = 'VALIDAR_NOMBRE_DUPLICADO_JCE';

      -- Si la funcion esta apagada no realizamos nada
      if l_estado = 'N' then
        p_estado := false;
        return false;
      end if;

      p_estado := true;
    exception when no_data_found then
      -- Se asume que esta encendida y se toman valores default
      p_estado := true;
    end;

    select NVL(min(a.id_nss),0), count(a.id_nss)
     into p_nss, p_count
     from suirplus.sre_ciudadanos_t a
    where sinNumeros(a.nombres, a.primer_apellido) = sinNumeros(p_nom, p_ape) --Excluye el sexo
      --
     and limpiar_datos_acta(a.municipio_acta,a.ano_acta,a.numero_acta,a.folio_acta,a.libro_acta,a.oficialia_acta)
       = limpiar_datos_acta(p_mun,p_ano,p_num,p_fol,p_lib,p_ofi)
      --
      and a.fecha_nacimiento = to_date(limpiar_fecha_nacimiento(p_fec),'ddmmyyyy')
      --
      and a.tipo_documento = 'N'
      --
      and a.tipo_causa is null
      and a.id_causa_inhabilidad is null;

    if p_count = 0 then
      return false;
    end if;
    return true;
  exception when others then
    p_estado := false;
    return false;
  end;

  -- Valida datos del acta y datos del nombre en blanco
  function validar_acta_nombre_blanco(p_nom  in varchar2,
                                      p_ape1 in varchar2,
                                      p_ape2 in varchar2,
                                      p_mun  in varchar2,
                                      p_ano  in varchar2,
                                      p_num  in varchar2,
                                      p_fol  in varchar2,
                                      p_lib  in varchar2,
                                      p_ofic in varchar2,
                                      p_lit  in varchar2 default null) return boolean is
  begin
    if trim(p_nom)  is null and
       trim(p_ape1) is null and
       trim(p_ape2) is null and
       trim(p_mun)  is null and
       trim(p_ano)  is null and
       trim(p_num)  is null and
       trim(p_fol)  is null and
       trim(p_lib)  is null and
       trim(p_ofic) is null and
       trim(p_lit)  is null then
      return false;
    end if;

    return true;
  exception when others then
    return false;
  end;

  -- Valida si hay otro dependiente con el mismo nombre, apellido y fecha de nacimiento en el nucleo familiar
  function validar_nucleo_familiar(p_nss in suirplus.ars_cartera_t.nss_titular%type,
                                   p_nombres in suirplus.sre_ciudadanos_t.nombres%type,
                                   p_primer_apellido in suirplus.sre_ciudadanos_t.primer_apellido%type,
                                   p_fecha_nacimiento in varchar2,
                                   p_proceso in varchar2) return boolean is
    v_conteo  integer;
    v_periodo varchar2(6);
    v_titular suirplus.ars_cartera_t.nss_dependiente%type;
  begin
    if upper(p_proceso) = '77' then -- Asignacion de NSS
      --Busco el periodo mayor en cartera para el titular
      select nvl(max(to_number(periodo_factura_ars)),0)
      into v_periodo
      from suirplus.ars_cartera_t
      where nss_titular=p_nss;

      -- para saber si hay otro dependiente con el mismo nombre y apellido
      select count(*)
      into v_conteo
      from suirplus.ars_cartera_t car
      join suirplus.sre_ciudadanos_t ciu
        on ciu.id_nss = car.nss_dependiente
       and ciu.nombres = p_nombres
       and ciu.primer_apellido = p_primer_apellido
       and extract(year from ciu.fecha_nacimiento) = extract(year from to_date(p_fecha_nacimiento,'ddmmyyyy'))
      where car.periodo_factura_ars = v_periodo
        and car.nss_titular = p_nss;

      if v_conteo > 1 then
        return false;
      end if;
      return true;
    elsif upper(p_proceso) = 'CN' then -- Actualizacion de NSS
      --Busco el periodo mayor en cartera para el dependiente
      select nvl(max(to_number(periodo_factura_ars)),0)
      into v_periodo
      from suirplus.ars_cartera_t
      where nss_dependiente=p_nss;

      --Busco el titular en cartera para el dependiente
      begin
        select /*+ FIRST_ROWS */ nss_titular
        into v_titular
        from suirplus.ars_cartera_t
        where periodo_factura_ars = v_periodo
          and nss_dependiente = p_nss;
      exception when no_data_found then
        v_titular := 0;
      end;

      -- para saber si hay otro dependiente para el titular con el mismo nombre, apellido y año de nacimiento
      select count(*)
      into v_conteo
      from suirplus.ars_cartera_t car
      join suirplus.sre_ciudadanos_t ciu
        on ciu.id_nss = car.nss_dependiente
       and ciu.nombres = p_nombres
       and ciu.primer_apellido = p_primer_apellido
       and extract(year from ciu.fecha_nacimiento) = extract(year from to_date(p_fecha_nacimiento,'ddmmyyyy'))
      where car.periodo_factura_ars = v_periodo
        and car.nss_titular = v_titular;

      if v_conteo > 1 then
        return false; --1601;
      end if;
      return true; --0;
    end if;
    return false;
  exception when others then
    return false;
  end;

  -- Valida la nacionalidad en el catalogo de nacionalidades
  function validar_nacionalidad(p_nacionalidad in suirplus.sre_nacionalidad_t.id_nacionalidad%type) return boolean is
    v_conteo pls_integer;
  begin
    select count(*)
    into v_conteo
    from suirplus.sre_nacionalidad_t a
    where a.id_nacionalidad=p_nacionalidad;

    if v_conteo = 0 then
      return false;
    end if;
    return true;
  exception when others then
    return false;
  end;

  -- Valida la provincia en el catalogo de provincias
  function validar_provincia(p_provincia in suirplus.sre_provincias_t.id_provincia%type) return boolean is
  begin
    for c_prv in (select *
                  from suirplus.sre_provincias_t a
                  where a.id_provincia = p_provincia)
    loop
      -- Esto termina la funcion y devuelve TRUE
      return true;
    end loop;

    -- Si llega hasta aqui el cursor no encontro la provincia
    return false;
  exception when others then
    return false;
  end;

  -- Valida el flag de extranjero
  function validar_extranjero(p_extranjero in varchar2) return boolean is
  begin
    if p_extranjero not in ('S','N') then
      return false;
    end if;
    return true;
  end;

  -- Valida la longitud de la imagen
  function validar_imagen(p_imagen in blob) return boolean is
  begin
    if NVL(DBMS_LOB.GETLENGTH(p_imagen), 0) = 0 then
      return false;
    end if;
    return true;
  exception when others then
    return false;
  end;

  -- Valida la conformacion correcta del nombre (incluyendo los apellidos)
  function validar_nombre_correcto(p_nombres in varchar2,
                                   p_primer_apellido in varchar2,
                                   p_segundo_apellido in varchar2) return boolean is
  begin
    if trim(p_nombres) is not null and
       trim(p_primer_apellido) is null and
       trim(p_segundo_apellido) is null then
      return false;
    elsif trim(p_primer_apellido) is not null and
          trim(p_nombres) is null and
          trim(p_segundo_apellido) is null then
      return false;
    elsif trim(p_segundo_apellido) is not null and
          trim(p_nombres) is null and
          trim(p_primer_apellido) is null then
      return false;
    end if;
    return true;
  exception when others then
    return false;
  end;

  -- Valida la conformacion correcta del acta (siete campos del acta)
  function validar_acta_correcta(p_mun in varchar2,
                                 p_ano in varchar2,
                                 p_num in varchar2,
                                 p_fol in varchar2,
                                 p_lib in varchar2,
                                 p_ofi in varchar2,
                                 p_lit in varchar2 default null) return boolean is

  begin
    if (trim(p_mun) is not null) and
       (trim(p_ano) is null or
        trim(p_num) is null or
        trim(p_fol) is null or
        trim(p_lib) is null or
        trim(p_ofi) is null) then
      return false;
    elsif (trim(p_ano) is not null) and
          (trim(p_mun) is null or
           trim(p_num) is null or
           trim(p_fol) is null or
           trim(p_lib) is null or
           trim(p_ofi) is null) then
      return false;
    elsif (trim(p_num) is not null) and
          (trim(p_mun) is null or
           trim(p_ano) is null or
           trim(p_fol) is null or
           trim(p_lib) is null or
           trim(p_ofi) is null) then
      return false;
    elsif (trim(p_fol) is not null) and
          (trim(p_ano) is null or
           trim(p_num) is null or
           trim(p_mun) is null or
           trim(p_lib) is null or
           trim(p_ofi) is null) then
      return false;
    elsif (trim(p_lib) is not null) and
          (trim(p_ano) is null or
           trim(p_num) is null or
           trim(p_fol) is null or
           trim(p_mun) is null or
           trim(p_ofi) is null) then
      return false;
    elsif (trim(p_ofi) is not null) and
          (trim(p_ano) is null or
           trim(p_num) is null or
           trim(p_fol) is null or
           trim(p_lib) is null or
           trim(p_mun) is null) then
      return false;
    elsif trim(p_ofi) is null and
          trim(p_ano) is null and
          trim(p_num) is null and
          trim(p_fol) is null and
          trim(p_lib) is null and
          trim(p_mun) is null then
      return false;
    end if;
    return true;
  exception when others then
    return false;
  end;

  -- Limpiar el municipio del acta, debe terminar con numeros
  function limpiar_municipio_acta(p_mun in varchar2) return varchar2 is
  begin
    /*
      segun comunicado:
        * Convertir los NULL en CERO, cuando no se tenga, el campo va a tener TRES CERO (000),
          tal como lo devuelve el webservice la JCE.
    */
    if trim(p_mun) is null then
      return '000';
    else
      return NVL(LPAD(convertir_numero(p_mun),3,'0'),'000');
    end if;
  end;

  -- Limpiar el ano del acta, debe terminar con numeros
  function limpiar_ano_acta(p_ano in varchar2) return varchar2 is
  begin
    /*
      segun comunicado:
        * Cuando no se tenga (sea: 0, 00, 000, etc). Debe convertirse en CUATRO CERO 0000.
        * Rellenar con 0 a la izquierda hasta 4 posiciones
    */
    if trim(p_ano) is null then
      return '0000';
    elsif trim(p_ano) in ('0','00','000') then
      return '0000';
    else
      return NVL(convertir_numero(p_ano),'0000');
    end if;
  end;

  -- Limpiar el numero del acta, debe terminar con numeros
  function limpiar_numero_acta(p_num in varchar2) return varchar2 is
  begin
    /*
      segun comunicado:
        * Quitar los 0 a la izquierda
        * Quitar todo lo que no sea numero
        * Convertir los NULL en CERO, cuando no se tenga, el campo va a tener UN CERO (0),
          tal como lo devuelve el webservice la JCE.
    */
    if trim(p_num) is null then
      return '0';
    else
      return NVL(convertir_numero(p_num),'0');
    end if;
  end;

  -- Limpiar el folio del acta, debe terminar con numeros
  function limpiar_folio_acta(p_fol in varchar2) return varchar2 is
  begin
    /*
      segun comunicado:
        * Quitar los 0 a la izquierda
        * Quitar todo lo que no sea numero
        * Convertir los NULL en CERO, cuando no se tenga, el campo va a tener UN CERO (0),
          tal como lo devuelve el webservice la JCE.
    */
    if trim(p_fol) is null then
      return '0';
    else
      return NVL(convertir_numero(p_fol),'0');
    end if;
  end;

  -- Limpiar el libro del acta, debe terminar con numeros
  function limpiar_libro_acta(p_lib in varchar2, p_ano in varchar2, p_lit in out varchar2) return varchar2 is
    v_lib  varchar2(10);
    v_ano  varchar2(4);
    v_cant pls_integer;
  begin
    /*
      segun comunicado:
        * Quitar los 0 a la izquierda
        * Quitar todo lo que no sea numero
        * Si el libro_acta termina en –XX y XX = a los últimos dos dígitos del ano_acta, se lo quitamos.
          Ejemplo:
            Libro_acta: 2-98 | ano_acta: 1998. Se convierte en:
            Libro_acta: 2
        * Si en el libro_acta está contenido el ano_acta al final del campo, se lo quitamos.
          Ejemplo:
            Ejemplo #1
              Libro_acta: 12000 | ano_acta: 2000. Se convierte en:
              Libro_acta: 1
            Ejemplo #2
              Libro_acta: 1H2000 | ano_acta: 2000. Se convierte en:
              Libro_acta: 1H (El H se le quita con la otra regla más abajo)
        * Cuando termine con letras, se van a tomar las letras (sin el guion) y se van a grabar en el literal_acta.
            Ejemplo:
              Libro_acta: 00002-UM. Se convierte en
              libro_acta: 2
              literal_acta: UM
    */
    v_ano := limpiar_ano_acta(p_ano);
    v_lib := trim(p_lib);

    --Para quitar el ano del libro, si lo trae
    if instr(v_lib, '-') > 0 then
      v_cant := length(v_lib) - instr(v_lib, '-');
      -- si caracteres despues del guion estan en el ano de atras hacia delante
      if substr(v_lib, instr(v_lib, '-')+1, v_cant) = substr(v_ano,-v_cant, v_cant) then
        v_lib := substr(v_lib, 1, length(v_lib) - v_cant); --voto los caracteres despues del guion
      end if;
    elsif length(v_lib) > 4 then
      -- si los ultimos digitos del libro contiene el ano del acta
      if substr(v_lib, -4, 4) = v_ano then
        v_lib := replace(v_lib,v_ano,''); --quito el ano del libro
      end if;
    end if;

    --Para quitar el literal del libro
    begin
      select to_number(v_lib) into v_cant from dual;
      p_lit := '';
    exception when others then
      --Probablemente el libro tiene un guion, lo reemplazamos
      p_lit := replace(convertir_letra(v_lib), '-', '');
    end;

    return NVL(convertir_numero(v_lib),'0');
  end;

  -- Limpiar el libro del acta, debe terminar con numeros, sobrecarga que no toma en cuenta el literal
  function limpiar_libro_acta(p_lib in varchar2, p_ano in varchar2) return varchar2 is
    v_lib  varchar2(10);
    v_ano  varchar2(4);
    v_cant pls_integer;
  begin
    /*
      segun comunicado:
        * Quitar los 0 a la izquierda
        * Quitar todo lo que no sea numero
        * Si el libro_acta termina en –XX y XX = a los últimos dos dígitos del ano_acta, se lo quitamos.
          Ejemplo:
            Libro_acta: 2-98 | ano_acta: 1998. Se convierte en:
            Libro_acta: 2
        * Si en el libro_acta está contenido el ano_acta al final del campo, se lo quitamos.
          Ejemplo:
            Ejemplo #1
              Libro_acta: 12000 | ano_acta: 2000. Se convierte en:
              Libro_acta: 1
            Ejemplo #2
              Libro_acta: 1H2000 | ano_acta: 2000. Se convierte en:
              Libro_acta: 1H (El H se le quita con la otra regla más abajo)
        * Cuando termine con letras, se van a tomar las letras (sin el guion) y se van a grabar en el literal_acta.
            Ejemplo:
              Libro_acta: 00002-UM. Se convierte en
              libro_acta: 2
              literal_acta: UM
    */
    v_ano := limpiar_ano_acta(p_ano);
    v_lib := trim(p_lib);

    --Para quitar el ano del libro, si lo trae
    if instr(v_lib, '-') > 0 then
      v_cant := length(v_lib) - instr(v_lib, '-');
      -- si caracteres despues del guion estan en el ano de atras hacia delante
      if substr(v_lib, instr(v_lib, '-')+1, v_cant) = substr(v_ano,-v_cant, v_cant) then
        v_lib := substr(v_lib, 1, length(v_lib) - v_cant); --voto los caracteres despues del guion
      end if;
    elsif length(v_lib) > 4 then
      -- si los ultimos digitos del libro contiene el ano del acta
      if substr(v_lib, -4, 4) = v_ano then
        v_lib := replace(v_lib,v_ano,''); --quito el ano del libro
      end if;
    end if;

    --Para quitar el literal del libro
    begin
      select to_number(v_lib) into v_cant from dual;
    exception when others then
      --Probablemente el libro tiene un guion, lo reemplazamos
      v_lib := replace(v_lib, '-', '');
    end;
    return NVL(convertir_numero(v_lib),'0');
  end;

  -- Limpiar la oficialia del acta, debe terminar con numeros
  function limpiar_oficialia_acta(p_ofi in varchar2) return varchar2 is
  begin
    /*
      segun comunicado:
        * Quitar los 0 a la izquierda
        * Quitar todo lo que no sea numero
        * Convertir los NULL en CERO, cuando no se tenga, el campo va a tener UN CERO (0),
          tal como lo devuelve el webservice la JCE.
    */
    if trim(p_ofi) is null then
      return '0';
    else
      return NVL(convertir_numero(p_ofi),'0');
    end if;
  end;

  -- Limpiar el literal del acta, debe terminar con letras
  function limpiar_literal_acta(p_lit in varchar2) return varchar2 is
  begin
    return convertir_letra(p_lit);
  end;

  -- Limpiar los datos del acta
  function limpiar_datos_acta(p_mun in varchar2, p_ano in varchar2, p_num in varchar2, p_fol in varchar2, p_lib in varchar2, p_ofi in varchar2, p_lit in varchar2, p_exc in varchar2 default null)
    return varchar2 DETERMINISTIC is
  begin
    if upper(NVL(p_exc,'~')) = 'M' then --excluye el municipio del acta
      return limpiar_ano_acta(p_ano)||' '||limpiar_numero_acta(p_num)||' '||limpiar_folio_acta(p_fol)||' '||limpiar_libro_acta(p_lib, p_ano)||' '||limpiar_oficialia_acta(p_ofi)||' '||limpiar_literal_acta(p_lit);
    elsif upper(NVL(p_exc,'~')) = 'A' then --excluye el ano del acta
      return limpiar_municipio_acta(p_mun)||' '||limpiar_numero_acta(p_num)||' '||limpiar_folio_acta(p_fol)||' '||limpiar_libro_acta(p_lib, p_ano)||' '||limpiar_oficialia_acta(p_ofi)||' '||limpiar_literal_acta(p_lit);
    elsif upper(NVL(p_exc,'~')) = 'N' then --excluye el numero del acta
      return limpiar_municipio_acta(p_mun)||' '||limpiar_ano_acta(p_ano)||' '||limpiar_folio_acta(p_fol)||' '||limpiar_libro_acta(p_lib, p_ano)||' '||limpiar_oficialia_acta(p_ofi)||' '||limpiar_literal_acta(p_lit);
    elsif upper(NVL(p_exc,'~')) = 'F' then --excluye el folio del acta
      return limpiar_municipio_acta(p_mun)||' '||limpiar_ano_acta(p_ano)||' '||limpiar_numero_acta(p_num)||' '||limpiar_libro_acta(p_lib, p_ano)||' '||limpiar_oficialia_acta(p_ofi)||' '||limpiar_literal_acta(p_lit);
    elsif upper(NVL(p_exc,'~')) = 'L' then --excluye el libro del acta
      return limpiar_municipio_acta(p_mun)||' '||limpiar_ano_acta(p_ano)||' '||limpiar_numero_acta(p_num)||' '||limpiar_folio_acta(p_fol)||' '||limpiar_oficialia_acta(p_ofi)||' '||limpiar_literal_acta(p_lit);
    elsif upper(NVL(p_exc,'~')) = 'O' then --excluye la oficialia del acta
      return limpiar_municipio_acta(p_mun)||' '||limpiar_ano_acta(p_ano)||' '||limpiar_numero_acta(p_num)||' '||limpiar_folio_acta(p_fol)||' '||limpiar_libro_acta(p_lib, p_ano)||' '||limpiar_literal_acta(p_lit);
    elsif upper(NVL(p_exc,'~')) = 'LT' then --excluye el literal del acta
      return limpiar_municipio_acta(p_mun)||' '||limpiar_ano_acta(p_ano)||' '||limpiar_numero_acta(p_num)||' '||limpiar_folio_acta(p_fol)||' '||limpiar_libro_acta(p_lib, p_ano)||' '||limpiar_oficialia_acta(p_ofi);
    else
      return limpiar_municipio_acta(p_mun)||' '||limpiar_ano_acta(p_ano)||' '||limpiar_numero_acta(p_num)||' '||limpiar_folio_acta(p_fol)||' '||limpiar_libro_acta(p_lib, p_ano)||' '||limpiar_oficialia_acta(p_ofi)||' '||limpiar_literal_acta(p_lit);
    end if;
  end;

  -- Limpiar los datos del acta, sobrecarga que no toma en cuenta el literal
  function limpiar_datos_acta(p_mun in varchar2, p_ano in varchar2, p_num in varchar2, p_fol in varchar2, p_lib in varchar2, p_ofi in varchar2, p_exc in varchar2 default null)
    return varchar2 DETERMINISTIC is
  begin
    if upper(NVL(p_exc,'~')) = 'M' then --excluye el municipio del acta
      return limpiar_ano_acta(p_ano)||' '||limpiar_numero_acta(p_num)||' '||limpiar_folio_acta(p_fol)||' '||limpiar_libro_acta(p_lib, p_ano)||' '||limpiar_oficialia_acta(p_ofi);
    elsif upper(NVL(p_exc,'~')) = 'A' then --excluye el ano del acta
      return limpiar_municipio_acta(p_mun)||' '||limpiar_numero_acta(p_num)||' '||limpiar_folio_acta(p_fol)||' '||limpiar_libro_acta(p_lib, p_ano)||' '||limpiar_oficialia_acta(p_ofi);
    elsif upper(NVL(p_exc,'~')) = 'N' then --excluye el numero del acta
      return limpiar_municipio_acta(p_mun)||' '||limpiar_ano_acta(p_ano)||' '||limpiar_folio_acta(p_fol)||' '||limpiar_libro_acta(p_lib, p_ano)||' '||limpiar_oficialia_acta(p_ofi);
    elsif upper(NVL(p_exc,'~')) = 'F' then --excluye el folio del acta
      return limpiar_municipio_acta(p_mun)||' '||limpiar_ano_acta(p_ano)||' '||limpiar_numero_acta(p_num)||' '||limpiar_libro_acta(p_lib, p_ano)||' '||limpiar_oficialia_acta(p_ofi);
    elsif upper(NVL(p_exc,'~')) = 'L' then --excluye el libro del acta
      return limpiar_municipio_acta(p_mun)||' '||limpiar_ano_acta(p_ano)||' '||limpiar_numero_acta(p_num)||' '||limpiar_folio_acta(p_fol)||' '||limpiar_oficialia_acta(p_ofi);
    elsif upper(NVL(p_exc,'~')) = 'O' then --excluye la oficialia del acta
      return limpiar_municipio_acta(p_mun)||' '||limpiar_ano_acta(p_ano)||' '||limpiar_numero_acta(p_num)||' '||limpiar_folio_acta(p_fol)||' '||limpiar_libro_acta(p_lib, p_ano);
    else
      return limpiar_municipio_acta(p_mun)||' '||limpiar_ano_acta(p_ano)||' '||limpiar_numero_acta(p_num)||' '||limpiar_folio_acta(p_fol)||' '||limpiar_libro_acta(p_lib, p_ano)||' '||limpiar_oficialia_acta(p_ofi);
    end if;
  end;

  -- Limpiar los datos del acta, sobrecarga que no toma en cuenta el literal
  function limpiar_fecha_nacimiento(p_fecha in varchar2)
    return varchar2 DETERMINISTIC is
    p_fec   Varchar2(32000);
    m_fecha date;
  begin
    p_fec := p_fecha;
    if instr(p_fec, '/') > 0 then
       m_fecha := to_date(p_fec,'mm/dd/yyyy');
       p_fec := to_char(m_fecha, 'ddmmyyyy');
    end if;

   return p_fec;
  end;

end;
