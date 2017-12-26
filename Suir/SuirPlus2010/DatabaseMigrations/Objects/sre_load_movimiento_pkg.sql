create or replace package body suirplus.sre_load_movimiento_pkg is

--
-- 241016 dp Valida que el pasaporte sea de 11 o 6 posiciones
--
 
  -- --------------------------------------------------------------------------------------------------
  v_Recepcion number(9);
  v_MailFrom constant varchar2(250) := 'info@mail.tss2.gov.do';
  v_MailTo varchar2(250);
  v_result  varchar2(4000);
  e_rechazo exception;
    -- --------------------------------------------------------------------------------------------------
  function Is_Numero(p_texto in varchar2) return boolean is
    v_num number(18, 2);
  begin
    begin
      v_num := to_number(trim(p_texto));
    exception
      when others then
        v_num := null;
    end;
    return(v_num is not null);
  end;
  -- --------------------------------------------------------------------------------------------------
  function Is_Dinero(p_texto in varchar2) return boolean is
  begin
    return(Is_Numero(p_Texto) and
           substr(p_texto, length(p_texto) - 2, 1) = '.' and
           to_numero(p_Texto) <= 99999999999.99
           -- esto es para filtrar cantidades con el punto corrido una posicion
           -- o cantidades con tres decimales, o numeros simplemente demasiado grandes
           );
  end;
  -- --------------------------------------------------------------------------------------------------
  function Is_Fecha(p_texto in varchar2) return boolean is
    v_fec date;
  begin
    begin
      v_fec := to_date(p_texto, 'ddmmyyyy');
    exception
      when others then
        v_fec := null;
    end;
    return(v_fec is not null);
  end;
  -- --------------------------------------------------------------------------------------------------
  function To_Fecha(p_texto in varchar2) return date is
    mfecha date;
  begin
    begin
      mFecha := to_date(p_texto, 'ddmmyyyy');
    exception
      when others then
        mFecha := null;
    end;
    return mfecha;
  end;
  -- --------------------------------------------------------------------------------------------------
  function To_Numero(p_texto in varchar2) return number is
    v_num number(18, 2);
  begin
    begin
      v_num := to_number(nvl(trim(p_texto), '0'));
    exception
      when others then
        v_num := 0;
    end;
    return v_num;
  end;
  -- --------------------------------------------------------------------------------------------------
  function Is_Nulo(p_texto in varchar2) return boolean is
  begin
    if p_texto is null or trim(p_texto) is null then
      return true;
    else
      return false;
    end if;
  end;
  -- --------------------------------------------------------------------------------------------------
  function Is_Nombre_Propio(p_texto in varchar2) return boolean is
    v_i   number(9);
    v_l   char(1);
    v_res boolean;
  begin
    v_res := true;
    for v_i in 1 .. length(p_texto) loop
      v_l := substr(upper(p_texto), v_i, 1);
      if instr('ABCDEFGHIJKLMNÑOPQRSTUVWXYZ ''AEIOU-', v_l) = 0 then
        v_res := false;
        exit;
      end if;
    end loop;
    return v_res;
  end;
  -- --------------------------------------------------------------------------------------------------
  function Is_Documento(p_texto in varchar2) return boolean is
    v_i   number(9);
    v_l   char(1);
    v_res boolean;
  begin
    v_res := true;
    for v_i in 1 .. length(p_texto) loop
      v_l := substr(upper(p_texto), v_i, 1);
      if instr('ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-', v_l) = 0 then
        v_res := false;
        exit;
      end if;
    end loop;
    return v_res;
  end;
  -- -------------------------------------------------------------------------------------------------
  procedure insertar_movimiento_archivo(p_recepcion in number) is
    v_ErrorDetalle     number(3);
    v_ErrorDetallePY   number(3);--para identificar los registros rechazados desde python por incumplimiento de layout del archivo
    v_ErrorArchivo     number(3);
    v_Conteo           number(12);
    v_OK               number(12);
    v_Err              number(12);
    v_RegistroPatronal number(12);
    v_PeriodoFactura   number(12);
    v_Movimiento       number(12);
    v_agente_ss        number(12);
    v_agente_isr       number(12);
    v_Nss              number(12);
    v_cantReg          number(12);
    v_no_documento     varchar2(25);
    v_tipo_documento    varchar2(1);
  begin
    v_cantReg   := 0;
    v_OK        := 0;
    v_Err       := 0;
    v_Recepcion := p_recepcion;
 
    select p.lista_error
      into v_MailTo
      from sfc_procesos_t p
      where p.id_proceso = '50';
 
    for archivo in (select a.rowid id, a.*
                      from suirplus.sre_archivos_t a
                     where id_recepcion = v_Recepcion
                       and id_tipo_movimiento in ('NV', 'AM', 'AR', 'BO')) loop
      v_ErrorArchivo := 0;
      for detalle in (select d.rowid id, d.*
                        from suirplus.sre_tmp_movimiento_t d
                       where id_recepcion = v_Recepcion) loop
        v_ErrorDetalle   := 0;
        v_ErrorDetallePY := 0;
        v_agente_ss      := null;
        v_agente_isr     := null;
        v_tipo_documento := detalle.tipo_documento;
        v_no_documento   := detalle.no_documento;
        
        begin
 
          --buscamos en tmp si tiene un id_error PY1 para que el registro no sea evaluado
          select count(*)into v_Conteo
            from suirplus.sre_tmp_movimiento_t
            where rowid = detalle.id and detalle.id_error='PY1';
              if v_Conteo > 0 then
               v_ErrorDetallePY := 999;
               goto fin_validaciones;
              end if;
 
          --Validacion dependiendo del tipo de Movimiento
          if (archivo.id_tipo_movimiento = 'NV') and
             (detalle.id_tipo_novedad not in
             ('IN', 'SA', 'VC', 'LV', 'LM', 'LD', 'AD')) then
            v_ErrorDetalle := 164;
            goto fin_validaciones;
          end if;
          --Ver que no este duplicado el empleado/nomina
          select count(*)
            into v_conteo
            from suirplus.sre_tmp_movimiento_t a
           where a.id_recepcion = detalle.id_recepcion
             and upper(a.tipo_documento) = upper(v_tipo_documento)
             and upper(a.no_documento) = upper(v_no_documento)
             and nvl(a.id_nomina, 0) = nvl(detalle.id_nomina, 0)
             and a.secuencia_movimiento <> detalle.secuencia_movimiento;
          if (v_conteo > 0) then
            v_ErrorDetalle := 422;
            goto fin_validaciones;
          end if;
          --El tipo de Documento debe ser P o C
          -- if (detalle.tipo_documento is null or detalle.tipo_documento not in ('N', 'P', 'C')) then  -- Task 2872
          if (v_tipo_documento is null or
             v_tipo_documento not in ('P','C','N')) then
            -- Task 2872
            v_ErrorDetalle := 101;
            goto fin_validaciones;
          end if;
          --ID_NOMINA debe ser numerico mayor que cero
          if (archivo.id_tipo_movimiento <> 'BO') then
            if (Is_Nulo(detalle.id_nomina)) or
               (Is_Numero(detalle.id_nomina) = false) or
               (To_Numero(detalle.id_nomina) < 0) then
              v_ErrorDetalle := 155;
              goto fin_validaciones;
            else

           --Conforme al ticket #2439, no permitir nominas 888 y 999 para tipo de movimientos 'AM' y 'AR'
            if (archivo.id_tipo_movimiento in ('AM', 'AR') and
                  detalle.id_nomina in (888, 999,000)) then
              v_ErrorDetalle := 155;
              goto fin_validaciones;
            end if;
          end if;
          
           --validar permiso nomina representante
              if not sre_archivos_pkg.isnominaRepresentante(archivo.usuario_carga,detalle.id_nomina)then
                v_ErrorDetalle := 116;
                goto fin_validaciones;
              end if;
            end if;
 
          --PERIODO_APLICACION debe ser numerico, no nulo
          if (Is_Nulo(detalle.periodo_aplicacion)) or
             (is_Numero(detalle.periodo_aplicacion) = false) or
             (length(detalle.periodo_aplicacion) <> 6) or
             (to_number(substr(detalle.periodo_aplicacion, 1, 2)) not between 1 and 12) or
             (to_number(substr(detalle.periodo_aplicacion, 3, 4)) not between 2003 and
             to_number(to_char(sysdate, 'yyyy')) + 1) then
            v_ErrorDetalle := 252;
            goto fin_validaciones;
          end if;

		      --Si los salarios ISR e INFOTEP vienen en cero, y el salario SS tiene valor, igualamos salario SS y salario infotep con salario SS
          --Modificado por el Task 11188
          If To_Numero(detalle.salario_ss) > 0 and To_Numero(detalle.salario_isr) = 0 Then
            Detalle.salario_isr := detalle.salario_ss;
          End if;

          If To_Numero(detalle.salario_ss) > 0 and To_Numero(detalle.salario_infotep) = 0 Then
            Detalle.salario_infotep := detalle.salario_ss;
          End if;

          --La combinacion de los campos: salario_ss, salario_isr y aporte_voluntario no pueden venir sin valor
          --Tickets: 5975 y 5976
          --Ampliado por el Task 11188
          if (
              (Is_Dinero(detalle.salario_ss) = false) or
              (To_Numero(detalle.salario_ss) <= 0)
             ) AND
             (
              (Is_Dinero(detalle.salario_isr) = false) or
              (To_Numero(detalle.salario_isr) <= 0)
             ) AND
             (
               (Is_Dinero(detalle.salario_infotep) = false) or
               (To_Numero(detalle.salario_infotep) <= 0)
             ) AND
             (
               (Is_Dinero(detalle.otros_ingresos_isr) = false) or
               (To_Numero(detalle.otros_ingresos_isr) <= 0)
             ) AND
             (
              (Is_Dinero(detalle.aporte_voluntario) = false) or
              (To_Numero(detalle.aporte_voluntario) <= 0)
             ) AND
             (
              (Is_Dinero(detalle.remuneracion_isr_otros) = false) or
              (To_Numero(detalle.remuneracion_isr_otros) <= 0)
             ) AND
             (
              (Is_Dinero(detalle.ingresos_exentos_isr) = false) or
              (To_Numero(detalle.ingresos_exentos_isr) <= 0)
             ) THEN
            v_ErrorDetalle := 188;
            goto fin_validaciones;
          end if;
 
          --SALARIO_SS debe ser numerico mayor que cero
          if (Is_Dinero(detalle.salario_ss) = false) or
             (To_Numero(detalle.salario_ss) <= 0) then
            --Solo debe rechazarse si el salario ISR es menor que cero,
            if (Is_Dinero(detalle.salario_isr) = false) or
               (To_Numero(detalle.salario_isr) < 0) then
              v_ErrorDetalle := 156;
              goto fin_validaciones;
            end if;
          end if;
 
          --APORTE_VOLUNTARIO debe ser numerico mayor o igual que cero
          if (archivo.id_tipo_movimiento <> 'BO') then
 
            --SALARIO_SS NO debe estar en los rangos declarados en la tabla de parametros
            if sre_novedades_pkg.isSalarioSSValido(detalle.salario_ss) =
               False then
              v_ErrorDetalle := 156;
              goto fin_validaciones;
            end if;
 
            if (Is_Dinero(detalle.aporte_voluntario) = false) or
               (To_Numero(detalle.aporte_voluntario) < 0) then
              v_ErrorDetalle := 157;
 
              goto fin_validaciones;
            end if;
 
            --SALARIO_ISR debe ser numerico mayor o igual que cero
            if (Is_Dinero(detalle.salario_isr) = false) or
               (To_Numero(detalle.salario_isr) < 0) then
              v_ErrorDetalle := 158;
              goto fin_validaciones;
            end if;
 
            --SALARIO_INFOTEP debe ser numerico mayor o igual que cero
            if (Is_Dinero(nvl(detalle.salario_infotep, '0.00')) = false) or
               (To_Numero(nvl(detalle.salario_infotep, '0.00')) < 0) then
              v_ErrorDetalle := 321;
              goto fin_validaciones;
            end if;
 
            -- si el campo remuneraciones_isr_otros es invalido
            if Is_Nulo(detalle.remuneracion_isr_otros) = false and
               Is_Dinero(detalle.remuneracion_isr_otros) = false then
              v_ErrorDetalle := 160;
              goto fin_validaciones;
            end if;
 
            -- si el campo otros_ingresos_isr es invalido
            if Is_Nulo(detalle.otros_ingresos_isr) = false and
               Is_Dinero(detalle.otros_ingresos_isr) = false then
              v_ErrorDetalle := 186;
              goto fin_validaciones;
            end if;
 
            --INGRESOS_EXENTOS debe ser numerico mayor o igual que cero o nulo
            if (Is_Dinero(nvl(detalle.ingresos_exentos_isr, '0')) = false) or
               (To_Numero(nvl(detalle.ingresos_exentos_isr, '0')) < 0) then
              v_ErrorDetalle := 176;
              goto fin_validaciones;
            end if;
          end if;
          
          -- Si el agente de retencion ISR es distinto al rnc_cedula
          if (Is_Nulo(detalle.agente_retencion_isr) = false) and
             (to_numero(detalle.agente_retencion_isr) <> 0) --que no este rellenado de ceros
             and (detalle.agente_retencion_isr <> archivo.id_rnc_cedula) and
             (Is_Dinero(detalle.remuneracion_isr_otros)) and
             (To_Numero(detalle.remuneracion_isr_otros) <> 0) then
            v_ErrorDetalle := 212;
            goto fin_validaciones;
          end if;
 
          -- Si el agente de retencion ISR es igual al rnc_cedula
          if (detalle.agente_retencion_isr = archivo.id_rnc_cedula or
             Is_Nulo(detalle.agente_retencion_isr) or
             to_numero(detalle.agente_retencion_isr) = 0) and
             (Is_Dinero(detalle.remuneracion_isr_otros)) and
             (To_Numero(detalle.remuneracion_isr_otros) < 0) then
            v_ErrorDetalle := 159;
            goto fin_validaciones;
          end if;
 
          --SALDO_FAVOR debe ser numerico mayor o igual que cero
          if Is_Nulo(detalle.saldo_favor_isr) = false and
             (Is_Dinero(detalle.saldo_favor_isr) = false or
              To_Numero(detalle.saldo_favor_isr) < 0) then
            v_ErrorDetalle := 177;
            goto fin_validaciones;
          end if;          
 
          --si el documento es P (Pasaporte)
     if upper(v_tipo_documento) = 'N' then
    -- Si el tipo_documento es N (representa un NSS desde la plantilla)
      if Is_Numero(v_no_documento) then
       --Verificamos que el nss pertenezca a un pasaporte o una cedula
          select count(*)
            into v_Conteo
            from suirplus.sre_ciudadanos_t  
           where id_nss = v_no_documento
             and tipo_documento in ('C', 'P'); 
                  
            if (v_Conteo = 0) then
              v_ErrorDetalle := 417;
              goto fin_validaciones;
            else
              select c.no_documento, c.tipo_documento
                into v_no_documento, v_tipo_documento
                from suirplus.sre_ciudadanos_t c
               where c.id_nss = v_no_documento;              
            end if; 
        else
          v_ErrorDetalle := 24;
          goto fin_validaciones;
        end if;  
      end if; 
 
      -- Task 2872: Begin
     if (upper(v_tipo_documento) = 'P') then
      --nombre no debe estar en blanco o contener caracteres invalidos
      if (Is_Nulo(detalle.nombres)) or
         (Is_Nombre_Propio(detalle.nombres) = false) then
        v_ErrorDetalle := 105;
        goto fin_validaciones;
      end if;
      --primer apellido no debe estar en blanco o contener caracteres invalidos
      if (Is_Nulo(detalle.primer_apellido)) or
         (Is_Nombre_Propio(detalle.primer_apellido) = false) then
        v_ErrorDetalle := 106;
        goto fin_validaciones;
      end if;
      --sexo debe ser M o F
      if (detalle.sexo not in ('M', 'F')) then
        v_ErrorDetalle := 107;
        goto fin_validaciones;
      end if;
      --Fecha nacimiento, no nulo, ni invalido, de 1900 hasta hace diez a?os
      if (Is_Nulo(detalle.fecha_nacimiento))
      or (Is_Fecha(detalle.fecha_nacimiento) = false)
      or (nvl(To_Fecha(detalle.fecha_nacimiento),sysdate) not between
         to_date('01011901', 'ddmmyyyy') and add_months(sysdate,-10*12)) then
        v_ErrorDetalle := 108;
        goto fin_validaciones;
      end if;
      -- No_documento, no nulo, A-Z,0-9,-
      if (Is_Nulo(v_no_documento)) or
         (Is_Documento(v_no_documento) = false) then
        v_ErrorDetalle := 101;
        goto fin_validaciones;
      end if;
 
      --Fecha inicio, no invalido
      if (Is_Nulo(detalle.fecha_inicio) = false) and
         (Is_Fecha(detalle.fecha_inicio) = false) then
        v_ErrorDetalle := 39;
        goto fin_validaciones;
      end if;
      --Fecha fin, no invalido
      if (Is_Nulo(detalle.fecha_fin) = false) and
         (Is_Fecha(detalle.fecha_fin) = false) then
        v_ErrorDetalle := 39;
        goto fin_validaciones;
      end if; 
 
      -- ver si existe como pasaporte
      select count(*)
        into v_Conteo
        from suirplus.sre_ciudadanos_t
       where upper(tipo_documento) = 'P'
         and upper(no_documento) = upper(v_no_documento);
      if (v_Conteo = 0) then
        -- si es un pasaporte y no existe, insertarlo
        -- pero primero veamos si existe con otro tipo de documento
 
  --dp241016
  --Valida que el pasaporte NO sea de 11 o 9 posiciones
  if LENGTH(v_no_documento) in (11, 9) then
    v_ErrorDetalle := 61;
    goto fin_validaciones;
  end if;
  --enddp241016
 
        select count(*)
          into v_Conteo
          from sre_ciudadanos_t
         where tipo_documento in ('C', 'N')
           and no_documento = v_no_documento;
        if (v_Conteo = 0) then
          insert into suirplus.sre_ciudadanos_t
            (nombres,
             primer_apellido,
             segundo_apellido,
             fecha_nacimiento,
             no_documento,
             tipo_documento,
             sexo,
             fecha_registro,
             ult_fecha_act,
             ult_usuario_act)
          values
            (upper(detalle.nombres),
             upper(detalle.primer_apellido),
             upper(detalle.segundo_apellido),
             to_fecha(detalle.fecha_nacimiento),
             upper(v_no_documento),
             upper(v_tipo_documento),
             detalle.sexo,
             sysdate,
             sysdate,
             archivo.usuario_carga);
          commit;
        else
          v_ErrorDetalle   := 24;
          v_cantReg := v_cantReg + 1;
          goto fin_validaciones;
        end if;
      end if;             
                
      -- Task 2872: End
    elsif upper(v_tipo_documento) = 'C' then
      -- si es una cedula
      -- ver si existe como cedula
      select count(*)
        into v_Conteo
        from suirplus.sre_ciudadanos_t
       where upper(tipo_documento) = 'C'
         and upper(no_documento) = upper(replace(v_no_documento, ' ', ''));
      if (v_Conteo = 0) then
        v_ErrorDetalle := 24;
        v_cantReg := v_cantReg + 1;
        goto fin_validaciones;
      end if;
    end if;
          -- ver si el agente_retencion_isr existe como rnc
          if (detalle.agente_retencion_isr is not null) and
             (to_numero(detalle.agente_retencion_isr) <> 0) then
            select count(*)
              into v_Conteo
              from suirplus.sre_empleadores_t
             where rnc_o_cedula = detalle.agente_retencion_isr;
            if (v_Conteo = 0) then
              v_ErrorDetalle := 161;
              goto fin_validaciones;
            end if;
          end if;
          -- ver si existe la nomina para ese empleador
          if (archivo.id_tipo_movimiento <> 'BO') then
            select count(*)
              into v_Conteo
              from suirplus.sre_empleadores_t e
              join suirplus.sre_nominas_t n
                on n.id_registro_patronal = e.id_registro_patronal
               and n.id_nomina = To_Numero(detalle.id_nomina)
             where e.rnc_o_cedula = archivo.id_rnc_cedula;
            if (v_Conteo = 0) then
              v_ErrorDetalle := 155;
              goto fin_validaciones;
            end if;
          end if;
 
          --Si el tipo de movimiento es 'AM' O 'NV', ver si existe la nomina ACTIVA para ese empleador--
          -- Y ver si el Tipo de Ingreso es válido
          if (archivo.id_tipo_movimiento in ('AM', 'NV')) then
            --ver si existe la nomina ACTIVA para ese empleador
            select count(*)
              into v_Conteo
              from suirplus.sre_empleadores_t e
              join suirplus.sre_nominas_t n
                on n.id_registro_patronal = e.id_registro_patronal
               and n.id_nomina = To_Numero(detalle.id_nomina)
               and n.status = 'A'
             where e.rnc_o_cedula = archivo.id_rnc_cedula;
 
            if (v_Conteo = 0) then
              v_ErrorDetalle := 194;
              goto fin_validaciones;
            end if;
 
            --ver si el Tipo de Ingreso es válido
            --FR 2010-05-06--
            select count(*)
              into v_Conteo
              from suirplus.sre_tipo_ingreso_t ti
             where ti.cod_ingreso = detalle.cod_ingreso;
 
            if (v_Conteo = 0) then
              v_ErrorDetalle := 572;
              goto fin_validaciones;
            end if;
 
          end if;
        exception
          when others then
            v_ErrorDetalle := 650;
            system.html_mail(v_mailfrom,
                             v_mailto,
                             'Error el Load_Movimiento: Archivo ' ||
                             v_Recepcion || ' Linea ' ||
                             detalle.secuencia_movimiento,
                             sqlerrm);
        end;
        <<fin_validaciones>>
        if (v_ErrorDetalle = 0) and (v_ErrorDetallePY = 0) then
          -- no hubo error
          v_OK             := v_OK + 1;
          v_PeriodoFactura := substr(detalle.periodo_aplicacion, 3, 4) ||
                              substr(detalle.periodo_aplicacion, 1, 2);
        else
          -- hubo error
          v_Err          := v_Err + 1;
          v_ErrorArchivo := 250;
        end if;
        -- actualizar
        if v_ErrorDetallePY = 0 then
          update suirplus.sre_tmp_movimiento_t
             set id_error = v_ErrorDetalle,
                 --salario isr puede tomar el valor del salario SS si viene orginalmente en cero
                 salario_isr = case when v_ErrorDetalle = 0 then detalle.salario_isr else salario_isr end,
                 --salario infotep puede tomar el valor del salario SS si viene orginalmente en cero 
                 salario_infotep = case when v_ErrorDetalle = 0 then detalle.salario_infotep else salario_infotep end,
                 status   = decode(v_ErrorDetalle, '0', 'P', 'R')
           where rowid = detalle.id;
          commit;
        end if;        
      end loop;
 
      -- actualizar los registros ok/bad del archivo
      update suirplus.sre_archivos_t a
         set a.status                 = Decode(v_OK,0,'R','P'),
             a.id_error               = Decode(v_OK,0,'301',v_ErrorArchivo),
             a.registros_ok           = v_OK,
             a.registros_bad          = v_Err
       where rowid = archivo.id;
      commit;
 
      --si hubo transacciones ok, insertar el movimiento, sino, rechazarlo
      if (v_OK > 0) then
        -- obtener el numero de movimiento
        select sre_movimientos_seq.nextval into v_Movimiento from dual;
        -- obtener el Reg. Pat.
        select id_registro_patronal
          into v_RegistroPatronal
          from suirplus.sre_empleadores_t
         where rnc_o_cedula = archivo.id_rnc_cedula;
        -- insertar el movimiento
        insert into suirplus.sre_movimiento_t
          (id_movimiento,
           id_registro_patronal,
           id_usuario,
           id_tipo_movimiento,
           status,
           fecha_registro,
           periodo_factura,
           ult_fecha_act,
           ult_usuario_act,
           id_recepcion)
        values
          (v_Movimiento,
           v_RegistroPatronal,
           archivo.usuario_carga,
           archivo.id_tipo_movimiento,
           'N',
           sysdate,
           v_PeriodoFactura,
           sysdate,
           archivo.usuario_carga,
           p_recepcion);
        commit;
        -- llenar los parametro de salida
        v_RegistroPatronal := v_RegistroPatronal;
        v_Movimiento       := v_Movimiento;
        --insertar los registros ok
        for OK in (select rownum, d.*
                     from suirplus.sre_tmp_movimiento_t d
                    where d.id_recepcion = archivo.id_recepcion
                      and d.id_error = '0'
                    order by d.secuencia_movimiento) loop
          if (ok.agente_retencion_isr is null) or
             (to_numero(ok.agente_retencion_isr) = 0) then
            v_agente_isr := null;
          else
            select id_registro_patronal
              into v_agente_isr
              from suirplus.sre_empleadores_t
             where rnc_o_cedula = ok.agente_retencion_isr;
          end if;
 
          if (upper(ok.tipo_documento) in ('C', 'P')) then
            select id_nss
              into v_Nss
              from suirplus.sre_ciudadanos_t
             where upper(tipo_documento) = upper(ok.tipo_documento)
               and upper(no_documento) = upper(trim(ok.no_documento));
          else
            select id_nss
              into v_Nss
              from suirplus.sre_ciudadanos_t
             where id_nss = upper(trim(ok.no_documento));
          end if;
 
          insert into suirplus.sre_det_movimiento_t
            (id_movimiento,
             id_linea,
             id_nss,
             periodo_aplicacion,
             id_nomina,
             salario_ss,
             salario_isr,
             salario_infotep,
             agente_retencion_isr,
             aporte_voluntario,
             aporte_afiliados_t3,
             aporte_empleador_t3,
             remuneracion_isr_otros,
             remuneracion_ss_otros,
             otros_ingresos_isr,
             ingresos_exentos_isr,
             saldo_favor_isr,
             id_tipo_novedad,
             pa_salario_ss,
             pa_aporte_voluntario,
             fecha_inicio,
             fecha_fin,
             ult_fecha_act,
             ult_usuario_act,
             cod_ingreso)
          values
            (v_Movimiento,
             ok.rownum,
             v_Nss,
             to_Numero(substr(ok.periodo_aplicacion, 3, 4) ||
                       substr(ok.periodo_aplicacion, 1, 2)), --no nulo, entre 200305 y proximo mes
             decode(archivo.id_tipo_movimiento,
                    'BO',
                    null,
                    to_Numero(ok.id_nomina)), --no nulo, numero,>0, existe en nominas_t
             to_Numero(ok.salario_ss), --numero,>0
             case when to_Numero(ok.salario_isr) > 0 then
             to_Numero(ok.salario_isr) else to_Numero(ok.salario_ss) end,
             case when to_Numero(ok.salario_infotep) > 0 then
             to_Numero(ok.salario_infotep) else to_Numero(ok.salario_ss) end,
             v_agente_isr, -- <> de empleador y sin remun o al reves
             to_Numero(ok.aporte_voluntario), -- numero, >=0
             to_Numero(ok.aporte_afiliados_t3),
             to_Numero(ok.aporte_empleador_t3),
             to_Numero(ok.remuneracion_isr_otros), --junto a agente retencion
             to_Numero(ok.remuneracion_ss_otros),
             to_Numero(ok.otros_ingresos_isr), --tonumero
             to_Numero(ok.ingresos_exentos_isr), --numero,>=0
             to_Numero(ok.saldo_favor_isr), --numero,>=0
             trim(ok.id_tipo_novedad), --in IN,SA,VC,LV,LM,LD,AD
             0,
             0,
             To_Fecha(trim(ok.fecha_inicio)), --fecha valida o nulo
             To_Fecha(trim(ok.fecha_fin)), --fecha valida o nulo
             sysdate,
             archivo.usuario_carga,
             to_Numero(ok.cod_ingreso));
 
          commit;
        end loop;
        --ejecutar o poner en cola de ejecucion
        poner_en_cola(v_Movimiento);
      end if;
 
		---*************************************************************************************------ 
		 --Modificado por: CMHA
		 --Fecha: 07/11/2016 
		 -- upgrade Task #10512 -
		 --Task #10041 - llamamos el proceso para las cedula rechazadas por id_error = '24'          
         if (v_cantReg > 0 and archivo.id_tipo_movimiento in ('AM', 'AR','NV')) then       
            sre_procesar_cedula_rechazadas(p_recepcion, p_resultnumber => v_result );
            if v_result <> 'OK' then
              raise e_rechazo;
            end if;   
         end if;
    ---*************************************************************************************------
    end loop;
  exception
    when e_rechazo then
      system.html_mail(v_mailfrom, v_mailto, 'Error al insertar_movimiento_archivo ' || p_recepcion, SUBSTR(v_result, 1, 500));
                        
    when others then
      system.html_mail(v_mailfrom,
                       v_mailto,
                       'Error al insertar_movimiento_archivo ' ||
                       p_recepcion,
                       sqlerrm);
  end;
  -- --------------------------------------------------------------------------------------------------
  procedure someter_movimiento_web(p_movimiento in number) is
  begin
    poner_en_cola(p_movimiento);
    commit;
  EXCEPTION
    WHEN OTHERS THEN
      system.html_mail(v_mailfrom,
                       v_mailto,
                       'Error al someter movimento web ' || p_movimiento,
                       sqlerrm);
  end;
  -- --------------------------------------------------------------------------------------------------
  procedure seg_carga_movimiento_tmp_p(p_id_recepcion in number) is
  begin
    -- wrapper para compatibilidad
    insertar_movimiento_archivo(p_id_recepcion);
  end;
  -- --------------------------------------------------------------------------------------------------
  procedure poner_en_cola(p_movimiento in number) is
    v_rp     number(10);
    v_conteo number(9);
    v_next   number(9);
  begin
    -- buscar el registro patronal del movimiento
    select id_registro_patronal
      into v_rp
      from suirplus.sre_movimiento_t
     where id_movimiento = p_movimiento;
 
    -- ver si existe un registro E para dicho registro patronal
    select count(*)
      into v_conteo
      from suirplus.sre_movimiento_t m
     where m.id_registro_patronal = v_rp
       and m.status = 'E';
 
    if (v_conteo = 0) then
      -- actualziar el movimeinto a E
      update suirplus.sre_movimiento_t
         set status = 'E', fecha_envio = sysdate
       where id_movimiento = p_movimiento;
 
      select seg_job_seq.nextval into v_next from dual;
 
      -- insertar job de serializacion al registro patronal
      insert into suirplus.seg_job_t
        (id_job, nombre_job, status, fecha_envio)
      values
        (v_next,
         'sre_load_movimiento_pkg.serializar_ejecucion(' || v_rp || ',' ||
         v_next || ');',
         'S',
         sysdate);
    else
      --hay registro(s) en E, poner en cola
      update suirplus.sre_movimiento_t
         set status = 'C', fecha_envio = sysdate
       where id_movimiento = p_movimiento;
    end if;
    commit;
  exception
    when others then
      rollback;
      system.html_mail(v_mailfrom,
                       v_mailto,
                       'Error al poner en cola el movimiento ' ||
                       p_movimiento,
                       sqlerrm);
  end;
  -- --------------------------------------------------------------------------------------------------
  procedure serializar_ejecucion(p_registro_patronal in number,
                                 p_job               in number) is
    v_movimiento number(9);
    v_mensaje    varchar2(100);
 
    v_tipo_mov suirplus.sre_movimiento_t.id_tipo_movimiento%type;
    v_periodo  sre_movimiento_t.periodo_factura%type;
    v_usuario  sre_movimiento_t.ult_usuario_act%type;
 
    RetVal       BOOLEAN;
    PP_RETURN    VARCHAR2(200);
    PP_ERROR_SEQ NUMBER;
  begin
    -- buscar el E que disparo este proceso
    select min(m.id_movimiento)
      into v_movimiento
      from suirplus.sre_movimiento_t m
     where m.id_registro_patronal = p_registro_patronal
       and m.status in ('E', 'C');
 
    -- miestras haya algo C o E, aplicarlo
    while (v_movimiento is not null) loop
      -- solo poner el status en E si recojí algo sometivo web o en cola
      update suirplus.sre_movimiento_t
         set status = 'E'
       where id_movimiento = v_movimiento
         and status <> 'E';
      commit;
 
      v_mensaje := '!';
      declare
        mErrorReturn varchar2(1000);
        mErrorSeq    number(18);
        mRecepcion   number(9);
        mConteoDet   number(9);
      begin
        -- ver si tiene detalles
        select count(*)
          into mConteoDet
          from suirplus.sre_det_movimiento_t
         where id_movimiento = v_movimiento;
 
        if (mConteoDet = 0) Then
          --Ver si tiene detalle en sre_det_movimiento_enf_t--(Enf comun)--
          --FR 2009-08-27--
 
          Select Count(*)
            Into Mconteodet
            From suirplus.Sre_Det_Movimiento_Enf_t
           Where Id_Movimiento = v_Movimiento;
 
        End If;
 
        if (mConteoDet = 0) Then
 
          --si no tiene detalles, no ejecutar
          v_mensaje := 'No tiene registros detalles, no será aplicado.';
 
          Update suirplus.Sre_Movimiento_t
             Set Status = 'R', Ult_Fecha_Act = Sysdate
           Where Id_Movimiento = v_Movimiento;
          commit;
 
        else
          -- vamos a ejecutarlo, pero si un movimiento de un archivo de auditoria,
          -- en vez de llamar a sre_aplica movimientos, llamaremos a SFC_OPERA_MOVIMIENTO_F
          select m.id_tipo_movimiento, m.periodo_factura, m.ult_usuario_act
            into v_tipo_mov, v_periodo, v_usuario
            from suirplus.sre_movimiento_t m
           where m.id_movimiento = v_movimiento;
 
          -- Task 2872
          update suirplus.sre_movimiento_t m
             set m.fecha_envio = sysdate
           where id_movimiento = v_movimiento;
          commit;
 
          if (v_tipo_mov in ('RA', 'RC', 'PRE')) then
            -- es un movimiento de archivos de auditoria, llamar SFC_OPERA_MOVIMIENTO_F
            -- no quitar este commit, es requerido para llamar opera_movimiento
            commit;
 
            DECLARE
              PP_ID_MOVIMIENTO        NUMBER;
              PP_ID_NOMINA            NUMBER;
              PP_ID_REGISTRO_PATRONAL NUMBER;
              PP_ID_TIPO_MOVIMIENTO   VARCHAR2(200);
              PP_PERIODO_FACTURA      NUMBER;
              PP_USUARIO              VARCHAR2(200);
              PP_IS_BITACORA          BOOLEAN;
              PP_IS_COMMIT            BOOLEAN;
            BEGIN
              PP_RETURN               := NULL;
              PP_ERROR_SEQ            := NULL;
              PP_ID_MOVIMIENTO        := v_movimiento;
              PP_ID_NOMINA            := CASE v_tipo_mov WHEN 'PRE' THEN NULL ELSE 999 END;
              PP_ID_REGISTRO_PATRONAL := p_registro_patronal;
              PP_ID_TIPO_MOVIMIENTO   := v_tipo_mov;
              PP_PERIODO_FACTURA      := v_periodo;
              PP_USUARIO              := v_usuario;
              PP_IS_BITACORA          := true;
              PP_IS_COMMIT            := true;
              RetVal                  := SUIRPLUS.SFC_OPERA_MOVIMIENTO_F(PP_RETURN,
                                                                         PP_ERROR_SEQ,
                                                                         PP_ID_MOVIMIENTO,
                                                                         PP_ID_NOMINA,
                                                                         PP_ID_REGISTRO_PATRONAL,
                                                                         PP_ID_TIPO_MOVIMIENTO,
                                                                         PP_PERIODO_FACTURA,
                                                                         PP_USUARIO,
                                                                         PP_IS_BITACORA,
                                                                         PP_IS_COMMIT);
              COMMIT;
            END;
 
            if RetVal = false then
              update suirplus.sre_movimiento_t
                 set status        = 'R',
                     fecha_termino = sysdate,
                     ult_fecha_act = sysdate,
                     mensaje       = 'OPERA:False/' || PP_RETURN || '/' ||
                                     PP_ERROR_SEQ
               where id_movimiento = v_movimiento;
            else
              update suirplus.sre_movimiento_t
                 set status        = 'P',
                     fecha_termino = sysdate,
                     ult_fecha_act = sysdate,
                     mensaje       = 'OPERA:True/' || PP_RETURN || '/' ||
                                     PP_ERROR_SEQ
               where id_movimiento = v_movimiento;
            end if;
            commit;
          else
            -- es un movimiento de otro tipo, llamar SRE_APLICA MOVIMIENTOS
            begin
              RetVal := sre_aplica_movimientos_pkg.aplica(mErrorReturn,
                                                          mErrorSeq,
                                                          v_movimiento);
            exception
              when others then
                RetVal := false;
            end;
 
            if (RetVal = true) then
              --marcar el movimiento como P
              update suirplus.sre_movimiento_t
                 set status        = 'P',
                     fecha_termino = sysdate,
                     ult_fecha_act = sysdate,
                     mensaje       = 'APLICA:True/' || mErrorReturn || '/' ||
                                     mErrorSeq
               where id_movimiento = v_movimiento;
            else
              --marcar el movimiento como R
              update suirplus.sre_movimiento_t
                 set status        = 'R',
                     fecha_termino = sysdate,
                     ult_fecha_act = sysdate,
                     mensaje       = 'APLICA:False/' || mErrorReturn || '/' ||
                                     mErrorSeq
               where id_movimiento = v_movimiento;
            end if;
          end if;
          commit;
 
          /* Comentado por el Task 10995
          -- en este punto ya se aplico el movimiento, si se genero una LIQ de ISR haremos declaracion de IR13
          declare
            mConteo        integer;
            mAno           integer;
            mPeriodo       integer;
            mUsuario       suirplus.seg_usuario_t.id_usuario%type;
            mUltimaEmision date;
            mRncCedula     suirplus.sre_empleadores_t.rnc_o_cedula%type;
            m_result       varchar2(1000);
          begin
            --buscar el a?o en cuestion
            select substr(periodo_factura, 1, 4),
                   periodo_factura,
                   id_usuario
              into mAno, mPeriodo, mUsuario
              from suirplus.sre_movimiento_t
             where id_movimiento = v_movimiento;
 
            --buscar el rnc
            select rnc_o_cedula
              into mRncCedula
              from suirplus.sre_empleadores_t
             where id_registro_patronal = p_registro_patronal;
 
            --ver si existe la declaracion
            select count(*)
              into mConteo
              from suirplus.sfc_resumen_ir13_t r
             where r.id_registro_patronal = p_registro_patronal
               and r.ano_fiscal = mAno;
 
            if (mConteo = 0) then
              begin
                insert into sfc_resumen_ir13_t
                  (ID_REGISTRO_PATRONAL,
                   ANO_FISCAL,
                   TIPO_DECLARACION,
                   STATUS,
                   ult_fecha_act)
                values
                  (p_registro_patronal,
                   mAno,
                   'N',
                   'E',
                   sysdate - 1 --con fecha de ayer a proposito
                   );
                commit;
              exception
                when others then
                  system.html_mail('info@mail.tss2.gov.do',
                                   '_operaciones@mail.tss2.gov.do',
                                   'error al insertar declaracion via movimiento ' ||
                                   v_movimiento,
                                   sqlerrm);
              end;
            end if;
 
            -- buscar la ultima fecha de actualizacion
            begin
              select max(l.fecha_emision)
                into mUltimaEmision
                from suirplus.sfc_resumen_ir13_t a
                join suirplus.sre_empleadores_t e
                  on e.id_registro_patronal = a.id_registro_patronal
                join suirplus.sfc_liquidacion_isr_t l
                  on l.id_registro_patronal = a.id_registro_patronal
                 and l.periodo_liquidacion = mPeriodo
                 and l.status <> 'CA'
                 and l.fecha_emision > a.ult_fecha_act
               where a.id_registro_patronal = p_registro_patronal
                 and a.ano_fiscal = mAno;
            exception
              when no_data_found then
                mUltimaEmision := null;
            end;
 
            -- si hay datos, declarar
            if (mUltimaEmision is not null) then
              begin
                --declarar
                suirplus.sre_procesar_rt_pkg.declaracion_regular(mAno,
                                                                 mRncCedula,
                                                                 mUsuario,
                                                                 m_result);
                -- actualizar la ultima NP considerada
                update suirplus.sfc_resumen_ir13_t a
                   set a.ult_fecha_act = mUltimaEmision
                 where a.id_registro_patronal = p_registro_patronal
                   and a.ano_fiscal = mAno;
                commit;
              exception
                when others then
                  system.html_mail('info@mail.tss2.gov.do',
                                   '_operaciones@mail.tss2.gov.do',
                                   'error al declarar ir13 via movimiento ' ||
                                   v_movimiento,
                                   sqlerrm);
              end;
            end if;
          exception
            when others then
              system.html_mail('info@mail.tss2.gov.do',
                               '_operaciones@mail.tss2.gov.do',
                               'error en proceso de declarar ir13 via movimiento ' ||
                               v_movimiento,
                               sqlerrm);
          end;
          -- hasta aqui
          */

          --ver si el movimiento viene de un archivo
          begin
            select id_recepcion
              into mRecepcion
              from suirplus.sre_movimiento_t
             where id_movimiento = v_movimiento;
          exception
            when others then
              mRecepcion := null;
          end;
 
          -- si viene de archivo marcarlo como procesado
          if mRecepcion is not null then
            update suirplus.sre_archivos_t
               set status        = 'P',
                   id_error      = decode(registros_bad, '0', '0', '250'),
                   ult_fecha_act = sysdate
             where id_recepcion = mRecepcion;
            commit;
          end if;
        end if;
      exception
        when others then
          v_mensaje := substr(sqlerrm, 1, 100);
          system.html_mail(v_mailfrom,
                           v_mailto,
                           'Error al aplicar movimiento ' || v_movimiento,
                           sqlerrm);
      end;
 
      -- tomar el minimo movimiento que no este procesado (un E o C)
      begin
        select min(m.id_movimiento)
          into v_movimiento
          from suirplus.sre_movimiento_t m
         where m.id_registro_patronal = p_registro_patronal
           and m.status in ('E', 'C');
      exception
        when others then
          v_movimiento := null;
      end;
    end loop;
 
    update seg_job_t set status = 'P' where id_job = p_job;
    commit;
  exception
    when others then
      rollback;
      update seg_job_t set status = 'P' where id_job = p_job;
      commit;
      system.html_mail(v_mailfrom,
                       v_mailto,
                       'Error al serializar ejecucion empleador ' ||
                       p_registro_patronal,
                       sqlerrm);
  end;
  -- --------------------------------------------------------------------------------------------------
  procedure relanzar_movimientos_detenidos
  -- Determinar si hay movimientos detenidos por mas de 24 horas (1 dia) y lo marca como Rechazado.
    -- Si hay movimientos pendientes de procesar ('C'), los serializas para su ejecucion.
   is
    v_next      number(9);
    v_resultado varchar2(32000);
 
    v_id_proceso CONSTANT SFC_PROCESOS_T.id_proceso%TYPE := 'RM'; -- Relanzar Movimiento.
    v_id_bitacora_1 SFC_BITACORA_T.id_bitacora%TYPE; -- Bitacora del Proceso General.
    v_id_bitacora_2 SFC_BITACORA_T.id_bitacora%TYPE; -- Bitacora por cada movimiento en 'E'.
    v_mensage       SFC_BITACORA_T.mensage%TYPE DEFAULT NULL;
    v_Proceso       suirplus.sre_movimiento_t.id_movimiento%TYPE := 0;
    v_Error         Varchar2(200);
  begin
    -- Grabar en Bitacora el Proceso General
    Srp_Pkg.bitacora(v_id_bitacora_1, 'INI', v_ID_PROCESO);
 
    -- movimientos en cola con un movimiento ejecutandose por mas de 24 horas (1 dia)
    for movs_detenidos in (select m.id_movimiento
                             from suirplus.sre_movimiento_t m
                            where m.status = 'E'
                              and trunc(sysdate - m.fecha_registro, 0) >= 1) loop
 
      -- Grabar en Bitacora por cada movimiento en 'E': uno registro por Registro Patronal.
      Srp_Pkg.bitacora(v_id_bitacora_2, 'INI', v_ID_PROCESO);
 
      v_mensage := 'ID Movimiento: ' || movs_detenidos.id_movimiento;
      v_Proceso := 1;
      v_Proceso := movs_detenidos.id_movimiento;
 
      update sre_movimiento_t
         set status = 'R' -- Marcar movimiento como Rechazado
       where id_movimiento = movs_detenidos.id_movimiento;
 
      commit;
 
      Srp_Pkg.bitacora(v_id_bitacora_2,
                       'FIN',
                       v_ID_PROCESO,
                       'Detail. ' || v_mensage,
                       'O',
                       '000');
      v_Proceso := 0;
 
    end loop;
 
    -- Si hay movimientos pendientes de procesar, los serializas para su ejecucion.
    for movs_detenidos in (select distinct m.id_registro_patronal
                             from suirplus.sre_movimiento_t m
                            where m.status = 'C'
                              and not exists
                            (select 1
                                     from suirplus.sre_movimiento_t x
                                    where x.id_registro_patronal =
                                          m.id_registro_patronal
                                      and x.status = 'E')) loop
      v_resultado := v_resultado || movs_detenidos.id_registro_patronal || ', ';
      select seg_job_seq.nextval into v_next from dual;
 
      -- insertar job de serializacion al registro patronal
      insert into seg_job_t
        (id_job, nombre_job, status, fecha_envio)
      values
        (v_next,
         'sre_load_movimiento_pkg.serializar_ejecucion(' ||
         movs_detenidos.id_registro_patronal || ',' || v_next || ');',
         'S',
         sysdate);
      commit;
    end loop;
 
    if (v_resultado is not null) then
      system.html_mail('info@mail.tss2.gov.do',
                       'roberto_jaquez@mail.tss2.gov.do',
                       'Relanzado de movimientos',
                       v_resultado);
    end if;
 
    Srp_Pkg.bitacora(v_id_bitacora_1,
                     'FIN',
                     v_ID_PROCESO,
                     'Header. OK.',
                     'O',
                     '000');
 
  exception
    when others then
      v_Error := SubStr('Error: ' || SQLERRM, 1, 200);
      system.html_mail('info@mail.tss2.gov.do',
                       'roberto_jaquez@mail.tss2.gov.do',
                       'Error en Relanzado de movimientos',
                       sqlerrm || '<br>' || v_resultado);
      Srp_Pkg.bitacora(v_id_bitacora_1,
                       'FIN',
                       v_ID_PROCESO,
                       SubStr('Header. ' || v_Error, 1, 200),
                       'E',
                       '000');
 
      if not (v_Proceso = 0) or (v_Proceso is null) then
        Srp_Pkg.bitacora(v_id_bitacora_2,
                         'FIN',
                         v_ID_PROCESO,
                         SubStr('Detail. ' || v_mensage || '.  ' || v_Error,
                                1,
                                200),
                         'E',
                         '000');
      end if;
 
  end;
  ----------------------------------------------------------------------------------------
end sre_load_movimiento_pkg;
