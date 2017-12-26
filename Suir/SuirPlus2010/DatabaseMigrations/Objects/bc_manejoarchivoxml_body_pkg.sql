CREATE OR REPLACE PACKAGE BODY SUIRPLUS.BC_ManejoArchivoXML_PKG is
  -------------------------------------
  -- variables privadas
  -------------------------------------
  v_result    varchar2(1000);
  v_fecha     date := sysdate;
  v_sec_log   bc_log_archivo_t.secuencia_log%type := 0;
  v_lista_ok  suirplus.sfc_procesos_t.lista_ok%type;
  v_lista_err suirplus.sfc_procesos_t.lista_error%type;
  c           suirplus.srp_config_t%rowtype;
  c_log_file  VARCHAR2(32000);
  c_log_title VARCHAR2(100) := 'Carga de Archivos XML para Concentracion y Liquidacion BC.';
  v_num_control suirplus.bc_archivos_tss_t.n_num_control%type;

  Type tmptabla_enc is table of suirplus.bc_encabezado_t%rowtype index by PLS_INTEGER;
  Type tmptabla_det is table of suirplus.bc_detalle_t%rowtype index by PLS_INTEGER;

  Type tmpTxtTabla_enc is table of suirplus.bc_co_encabezado_t%rowtype index by PLS_INTEGER;
  Type tmpTxtTabla_det is table of suirplus.bc_co_detalle_t%rowtype index by PLS_INTEGER;
  Type tmpTxtTabla_sum is table of suirplus.bc_co_sumario_t%rowtype index by PLS_INTEGER;

  v_tablaEnc tmptabla_enc;
  v_tablaDet tmptabla_det;

  v_tablaTxtEnc tmpTxtTabla_enc;
  v_tablaTxtDet tmpTxtTabla_det;
  v_tablaTxtSum tmpTxtTabla_sum;

  -- ==============================================
  -- Insertar el registro en la maestra de bitacora
  -- ==============================================
  PROCEDURE bitacora (
    p_id_bitacora IN OUT SUIRPLUS.SFC_BITACORA_T.id_bitacora%TYPE,
    p_accion      IN VARCHAR2 DEFAULT 'INI',
    p_id_proceso  IN SUIRPLUS.SFC_BITACORA_T.id_proceso%TYPE,
    p_mensage     IN SUIRPLUS.SFC_BITACORA_T.mensage%TYPE DEFAULT NULL,
    p_status      IN SUIRPLUS.SFC_BITACORA_T.status%TYPE DEFAULT NULL,
    p_id_error    IN SUIRPLUS.SEG_ERROR_T.id_error%TYPE DEFAULT NULL,
    p_seq_number  IN SUIRPLUS.ERRORS.seq_number%TYPE DEFAULT NULL,
    p_periodo     IN SUIRPLUS.SFC_BITACORA_T.periodo%TYPE DEFAULT NULL
  ) IS
  BEGIN
    CASE p_accion
    WHEN 'INI' THEN
      SELECT SUIRPLUS.sfc_bitacora_seq.NEXTVAL INTO p_id_bitacora FROM dual;
      INSERT INTO SUIRPLUS.SFC_BITACORA_T(id_proceso, id_bitacora, fecha_inicio, fecha_fin, mensage, status, periodo)
          VALUES(p_id_proceso, p_id_bitacora, SYSDATE, NULL, p_mensage, 'P', p_periodo);

    WHEN 'FIN' THEN
      UPDATE SUIRPLUS.SFC_BITACORA_T
         SET fecha_fin   = SYSDATE,
             mensage     = p_mensage,
             status      = p_status,
             seq_number  = p_seq_number,
             id_error    = p_id_error
       WHERE id_bitacora = p_id_bitacora;
    ELSE
      RAISE_APPLICATION_ERROR(010, 'Parametro invalido');
    END CASE;
    COMMIT;
  END;

  -------------------------------------------------
  --- Funcion para validar el nombre del archivo XML
  --- p_archivo nombre del archivo xml
  -------------------------------------------------
  function IsArchivoValido(p_archivo in bc_encabezado_t.nombrearchivo%type,
                           p_cod_bic_swith_cr in bc_encabezado_t.codigobicentidadcr%type,
                           p_cod_bic_swith_db in bc_encabezado_t.codigobicentidaddb%type,
                           p_trnopcrlbtr in bc_encabezado_t.trnopcrlbtr%type)
  return boolean
  is
    v_cod_bic_swith    varchar2(11);
    v_trn              varchar2(15);
    v_count_bic_swith  integer := 0;
    v_count_trn        integer := 0;
    v_trn_valido       bc_encabezado_t.trnopcrlbtr%type;
  begin
    -- Saco el codigo BIC SWIFT del archivo
    select substr(p_archivo, 0,11) into v_cod_bic_swith from dual;
    -- Saco el TRN del Archvio

    select substr(p_archivo, 13,14) into v_trn from dual;

    -- Agregarle el punto(.) al trn para luego ver si es valido
    select substr(v_trn, 0, 12) || '.' || substr(v_trn, 13, 12)
      into v_trn_valido
      from dual;

    -- busco el codigo BIC SWIFT en la tabla a ver si es v¿lido.
    select count(*)
      into v_count_bic_swith
      from sfc_entidad_recaudadora_t e
     where e.cod_bic_swift like '%' || v_cod_bic_swith || '%';

    if (v_count_bic_swith != 0 ) then
       -- validar si el codigobicentidadcr es diferente al
        -- cod bic swith que cotiene el archvio de ser asi
        -- se lanzara una exception con este error.
        if (p_cod_bic_swith_cr != v_cod_bic_swith) then
           return false;
        end if;

        -- validar que el p_cod_bic_swith_db es igual al v_cod_bic_swith del
        -- archivo de ser asi enviar una exception.
        if (p_cod_bic_swith_db = v_cod_bic_swith) then
           return false;
        end if;
   end if;

  -- busco el codigo TRN en la tabla a ver si es v¿lido.
  select count(*)
    into v_count_trn
    from bc_cod_trn_t t
   where t.codigo like '%' || v_trn || '%';

  if (v_count_trn != 0) then
     if (p_trnopcrlbtr != v_trn) then
        return false;
     end if;
  end if;

  return true;
end IsArchivoValido;

------------------------------------------------------------------
------Funcion para validar si el TRN es valido.
----- p_trnopcrLBTR : trn que desea validar.
------------------------------------------------------------------
function IsTrnValido(p_trnopcrLBTR in bc_encabezado_t.trnopcrlbtr%type)
return boolean
is
v_trnopcrLBTR integer := 0;
v_trn bc_cod_trn_t.codigo%type;
begin

   v_trn := substr(p_trnopcrLBTR,0,12);

   select count(*)
     into v_trnopcrLBTR
     from bc_cod_trn_t t
    where t.codigo = v_trn;

    if v_trnopcrLBTR = 0 then
       return false;
    end if;
    return true;

end IsTrnValido;

----------------------------------------------------------------
-- funcion para obtener la descripcion de una posible excepcion
------------------------------------------------------------------
function ObtenerExceptionDesc(p_idMsg bc_archivo_msg_t.id_msg%type)
return bc_archivo_msg_t.descripcion%type
is
v_descripcion bc_archivo_msg_t.descripcion%type;
begin
     select m.descripcion
       into v_descripcion
       from bc_archivo_msg_t m
      where m.id_msg = p_idmsg;

      return v_descripcion;
  end;
function EsArchivoValido(p_nombrearchivo bc_encabezado_t.nombrearchivo%type)
return bc_archivo_msg_t.descripcion%type
is
  v_bic sfc_entidad_recaudadora_t.cod_bic_swift%type;
  v_trn bc_cod_trn_t.codigo%type;
  v_count1 integer := 0;
  v_trn_valido bc_cod_trn_t.codigo%type;
  v_result  bc_archivo_msg_t.descripcion%type;
  e_logitudinvalid     exception;
  e_bicinvalid         exception;
  e_trninvalid         exception;
begin
    --Evaluo el length del archivo
    if (length(p_nombrearchivo) != 45) then
       raise e_logitudinvalid;
    end if;
    --Saco el Bic del archivo

    v_bic := substr(p_nombrearchivo,0,11);

   -- Ver si ese Bic es un Bic valido
    select count(*)
      into v_count1
      from sfc_entidad_recaudadora_t e
     where e.cod_bic_swift = v_bic;

     if (v_count1 = 0) then
        raise e_bicinvalid;
     end if;

     -- Sacar el Trn del archivo
     v_trn := substr(p_nombrearchivo, 13, 14);

     -- Agregarle el punto(.) al trn para luego ver si es valido
     v_trn_valido := substr(v_trn, 0, 12) || '.' || substr(v_trn, 13, 12);

     if not IsTrnValido(v_trn_valido) then
          raise e_trninvalid;
     end if;

     v_result := '0';
     return v_result;
exception
when e_logitudinvalid then
     v_result := '1';
     return v_result;
when e_bicinvalid then
     v_result := '3';
     return v_result;
when e_trninvalid then
    v_result := '3';
     return v_result;
end EsArchivoValido;

----------------------------------------------------------------------------
-- Funcion para validar el archivo de Concentracion.
--- p_nombrearchivo := Archivo a validar.
-------------------------------------------------------------------------
function EsArchivoConcentracion(p_nombrearchivo bc_co_encabezado_t.nombrearchivo%type)
return bc_archivo_msg_t.descripcion%type
is
e_logitudinvalid exception;
e_procesoinvalido exception;
e_subprocesoinvalido exception;
v_proceso nch_procesos_t.id_proceso%type;
v_sub_proceso nch_subprocesos_t.id_subproceso%type;
v_registros_proceso integer := 0;
v_registros_sub_proceso integer := 0;
v_result bc_archivo_msg_t.descripcion%type;
begin

if length(p_nombrearchivo)  != '26' then
   raise e_logitudinvalid;
end if;

v_proceso := substr(p_nombrearchivo,0,2);

v_sub_proceso := substr(p_nombrearchivo,3,2);

--Ver si el proceso es valido
select count(*)
  into v_registros_proceso
  from nch_procesos_t pr
 where pr.id_proceso = v_proceso;

 if (v_registros_proceso = 0) then
    raise e_procesoinvalido;
 end if;
 -- Ver si el sub_proceso es valido.
 select count(*)
   into v_registros_sub_proceso
   from nch_subprocesos_t sp
  where sp.id_subproceso = v_sub_proceso
    and sp.id_proceso = v_proceso;

if (v_registros_sub_proceso = 0) then
   raise e_subprocesoinvalido;
end if;
v_result := '0';
return v_result;
exception
when e_logitudinvalid then
     v_result := ObtenerExceptionDesc(1);
     return v_result;
when e_procesoinvalido then
      v_result := ObtenerExceptionDesc(31);
      return v_result;
when e_subprocesoinvalido then
      v_result := ObtenerExceptionDesc(32);
      return v_result;
end EsArchivoConcentracion;

--------------------------------------------------------------------------------------
--- Funcion para validar la fecha fechavalorcrlbtr no sea igual a la anterior
--- p_fechavalorcrlbtr : fechavalorcrlbtr que desea validar.
--------------------------------------------------------------------------------------
function IsFechaValorCrLbtr(p_fechavalorcrlbtr in bc_encabezado_t.fechavalorcrlbtr%type)
return boolean
is
v_fechaanterior date := trunc(sysdate - 1);
begin
     if trunc(p_fechavalorcrlbtr) = v_fechaanterior then
        return false;
     end if;
     return true;
end IsFechaValorCrLbtr;

-----------------------------------------------------------------------------------------
--- Funcion para validar el total de registros, como tambien el moto total del encabezado
--  sea igual al total de registros y el monto total del detalle del archvio.
--- p_totalregistroscontrol : tag del total de registros control del encabezado.
--- p_totalmontoscontrol : tag del monto total del monto a depositar del encabezado.
--  p_totalregistrodetalle : cantidad de registros que ahi en el detalle del elemento de <pago> archivo
--  p_montototalregistros : sumatoria del tag <montoaDepositar> del elemento de <pago> archivo
------------------------------------------------------------------------------------------
function IsValidTotalMontoRegistros( p_totalregistroscontrol bc_encabezado_t.totalregistroscontrol%type,
                                     p_totalmontoscontrol bc_encabezado_t.totalmontoscontrol%type,
                                     p_totalregistrodetalle bc_encabezado_t.totalregistroscontrol%type,
                                     p_montototalregistros  bc_encabezado_t.totalmontoscontrol%type)
 return boolean
 is
 begin
      if (p_totalregistroscontrol =  p_totalregistrodetalle) and (p_totalmontoscontrol  =  p_montototalregistros) then
          return true;
      end if;
      return false;
 end IsValidTotalMontoRegistros;

 function ObtenerValoresCaracter(p_carateres varchar2)
 return integer
 is
 v_caracter1 varchar2(1);
 v_caracter2 varchar2(1);
 v_caracter3 varchar2(1);
 v_caracter4 varchar2(1);
 v_valor1    integer := 0;
 v_valor2    integer := 0;
 v_valor3    integer := 0;
 v_valor4    integer := 0;
 v_resultado integer := 0;
 begin
      if length(p_carateres) = 2 then

      --obtener el primer caracter
          select substr(p_carateres,1,1) into v_caracter1
          from dual;

      -- buscar el valor correspondiente a 1er. caracter
         select ct.valores into v_valor1
         from bc_catalogo_caracteres_t ct where ct.caracter = v_caracter1;

      --obtener el segundo caracter
        select substr(p_carateres,2,1) into v_caracter2
        from dual;

        -- buscar el valor correspondiente al 2do caracter
         select ct.valores into v_valor2
         from bc_catalogo_caracteres_t ct where ct.caracter = v_caracter2;
         v_resultado := v_valor1 || v_valor2;
        goto fin;
      end if;

      --obtener el primer caracter
          select substr(p_carateres,1,1) into v_caracter1
          from dual;

      -- buscar el valor correspondiente a 1er. caracter
         select ct.valores into v_valor1
         from bc_catalogo_caracteres_t ct where ct.caracter = v_caracter1;

      --obtener el segundo caracter
        select substr(p_carateres,2,1) into v_caracter2
        from dual;

        -- buscar el valor correspondiente al 2do caracter
         select ct.valores into v_valor2
         from bc_catalogo_caracteres_t ct where ct.caracter = v_caracter2;

        -- obtener el tercer caracter
          select substr(p_carateres,3,1) into v_caracter3
          from dual;

         -- buscar el valor correspondiente al 3re caracter
         select ct.valores into v_valor3
         from bc_catalogo_caracteres_t ct where ct.caracter = v_caracter3;

         --obtener el Quarto caracter
           select substr(p_carateres,4,1) into v_caracter4
           from dual;

          -- buscar el valor correspondiente al 4to. caracter
         select ct.valores into v_valor4
         from bc_catalogo_caracteres_t ct where ct.caracter = v_caracter4;

         v_resultado := v_valor1 || v_valor2 || v_valor3 ||v_valor4;
         <<fin>>
         return  v_resultado;
 end;

-------------------------------------------------------------------------------------------
---- Funcion para validar el numero de cuenta estandar del tag <numeroCuentaEstandard>
---- p_NroCtaEstandarRd : Numero de cuenta que va hacer valida.
------------------------------------------------------------------------------------------
function IsValidNroCtaEstandarRd(p_NroCtaEstandarRd in bc_detalle_t.numerocuentaestandard%type)
return boolean
is
v_codpais            varchar2(2);
v_cod_bit_swith      varchar2(11);
v_nro_cuenta         varchar2(20);
v_digito_verificador integer := 0;
v_count              integer := 0;
v_valores            integer := 0;
v_valores1           integer := 0;
v_result             integer := 0;
v_dig_verificador    integer := 0;
begin
     --obtengo el codigo del pais.
     select substr(p_nroctaestandarrd, 0, 2) into v_codpais from dual;

     -- si el codigo del pais no es DO no es correcto.
     if v_codpais != 'DO' then
       return false;
     elsif v_codpais = 'DO' then
       v_valores1 := 1324;
     end if;

     --obtengo el cod bic swith.
     select substr(p_nroctaestandarrd, 5, 4)
       into v_cod_bit_swith
       from dual;

     -- validar si es un cod bic swith valido
     select count(*)
       into v_count
       from sfc_entidad_recaudadora_t e
      where e.cod_bic_swift like '%' || v_cod_bit_swith || '%';

     if v_count = 0 then
       return false;
     else
       v_valores := ObtenerValoresCaracter(v_cod_bit_swith);
     end if;

     --obtengo el nro de cuenta.
     select substr(p_nroctaestandarrd, 9, 20) into v_nro_cuenta from dual;
     -- si la longitud del nro de cuenta es diferente de 20 no es correcta.
     if length(v_nro_cuenta) != 20 then
       return false;
     end if;

     --obtengo el nro verificador.
     select substr(p_nroctaestandarrd, 3, 2)
       into v_digito_verificador
       from dual;

     v_result := v_valores || v_nro_cuenta || v_valores1 || '00';

     v_dig_verificador := 98 - mod(v_result, 97);

     if v_dig_verificador = v_digito_verificador then
       return true;
     end if;
     return false;
  end IsValidNroCtaEstandarRd;

  ------------------------------------------
  -- funcion para determinar si el encabezado ya esta registrado
  ----------------------------------------
  function ExisteEncabezado(p_nombrearchivo in bc_encabezado_t.nombrearchivo%type,
                            p_nombrelote    in bc_encabezado_t.nombrelote%type)
  return boolean
  is
  v_registro integer :=0;
  begin
    -- buscar en la tabla de encabezado haber si ya esta
    -- registrado
    If Substr(p_nombrearchivo,20,2) IN ('LQ','RV') Then
      select count(*) into v_registro
        from bc_encabezado_t ec
       where ec.nombrearchivo = p_nombrearchivo
         and ec.nombrelote = p_nombrelote;
    Else
      select count(*) into v_registro
        from bc_co_encabezado_t ec
       where ec.nombrearchivo = p_nombrearchivo;
    End if;

    if (v_registro = 0) then
        return false;
    end if;

    return true;
  end ExisteEncabezado;

-----------------------------------------------------------------------------------------------
-- Funcion para validar si la entidad destino es el banco central en el proceso
--  del Archivo de Concentracion de aportes.
-------------------------------------------------------------------------------------------------
function EsBancoCentral(p_entidad_destino bc_co_detalle_t.entidad_destino%type)
return boolean
 is
 v_bco_central integer := 0;
 begin

      select er.id_entidad_recaudadora into v_bco_central
       from sfc_entidad_recaudadora_t er
       where er.id_entidad_recaudadora = p_entidad_destino;

       if (v_bco_central != 10) then
          return false;
       end if;
       return true;
 end EsBancoCentral;

 function getProceso(p_trn in bc_cod_trn_t.codigo%type)
 return bc_cod_trn_t.proceso%type
 is
 v_proceso bc_cod_trn_t.proceso%type;
 begin
           select tr.proceso
             into v_proceso
             from bc_cod_trn_t tr
            where tr.codigo = p_trn;

            return v_proceso;

 end getProceso;

 procedure getNombreEntidad(p_id_entidad in sfc_entidad_recaudadora_t.id_entidad_recaudadora%type,
                             p_entidadnombre out sfc_entidad_recaudadora_t.entidad_recaudadora_des%type,
                             p_result out varchar2)
  is
  v_entidadnombre sfc_entidad_recaudadora_t.entidad_recaudadora_des%type;
  e_entidadnombre exception;
  e_id_entidadNull exception;
  v_errordb varchar2(1000);
  begin

       if (p_id_entidad is null) then
          raise e_id_entidadNull;
       end if;

       select ec.entidad_recaudadora_des
         into v_entidadnombre
         from sfc_entidad_recaudadora_t ec
        where ec.id_entidad_recaudadora = p_id_entidad;

        if (v_entidadnombre is null) then
           raise e_entidadnombre;
        end if;

    p_entidadnombre := v_entidadnombre;
    p_result := 0;
  exception
  when e_id_entidadNull then
       p_result := ObtenerExceptionDesc(35);
       ManejoExcepciones('EntidadRecaudadora', v_sec_log);
  when e_entidadnombre then
       p_result := ObtenerExceptionDesc(35);
       ManejoExcepciones('EntidadRecaudadora', v_sec_log);
  when others then
       v_errordb := 'Ocurrio el siguiente error obteniendo el nombre de la entidad' || '' || sqlerrm;
       p_result := v_errordb;
       ManejoExcepciones('EntidadRecaudadora', v_sec_log);
  end getNombreEntidad;

  procedure getDesProceso(p_trn in bc_cod_trn_t.codigo%type,
                          p_desproceso out bc_cod_trn_t.proceso%type,
                          p_result out varchar2)
  is
  v_desproceso bc_cod_trn_t.proceso%type;
  v_errordb varchar2(1000);
  v_trn bc_cod_trn_t.codigo%type;
  e_desproceso exception;
  e_trnNull exception;
  begin
       if (p_trn is null) then
          raise e_trnNull;
       end if;

       v_trn := substr(p_trn,0,12);

        select tr.proceso
         into v_desproceso
         from bc_cod_trn_t tr
        where tr.codigo = v_trn;

        if (v_desproceso is null)then
           raise e_desproceso;
        end if;
       p_desproceso := v_desproceso;
       p_result := '0';
 exception
 when e_trnNull then
     p_result := ObtenerExceptionDesc(62);
 when e_desproceso then
      p_result := ObtenerExceptionDesc(63);
 when others then
     v_errordb := 'Ocurrio el siguiente error obteniendo el proceso' || '' || sqlerrm;
     p_result := v_errordb;
  end getDesProceso;

 procedure getEntidadNombrePorBic(p_bic in sfc_entidad_recaudadora_t.cod_bic_swift%type,
                                   p_entidadnombre out sfc_entidad_recaudadora_t.entidad_recaudadora_des%type,
                                   p_result out varchar2)
  is
  v_entidadnombre sfc_entidad_recaudadora_t.entidad_recaudadora_des%type;
  e_entidadnombre exception;
  v_errordb varchar2(1000);
  begin
       select ec.entidad_recaudadora_des
         into v_entidadnombre
         from sfc_entidad_recaudadora_t ec
        where ec.cod_bic_swift = p_bic;

        if (v_entidadnombre is null) then
           raise e_entidadnombre;
        end if;
       p_result := '0';
       p_entidadnombre := v_entidadnombre;
  exception
  when e_entidadnombre then
      p_result := ObtenerExceptionDesc(61);
  when others then
      v_errordb := 'Ocurrio el siguiente error obteniendo el nombre de la entidad' || '' || sqlerrm;
       p_result := v_errordb;
  end getEntidadNombrePorBic;

procedure addarchivolog(p_nombrearchivo in bc_log_archivo_t.nombrearchivo%type,
                        p_tipo_archivo in varchar2,
                        p_sec out bc_log_archivo_t.secuencia_log%type,
                        p_result out bc_archivo_msg_t.descripcion%type)
is
  e_logitudinvalid      exception;
  e_bicinvalid          exception;
  e_trninvalid          exception;
  e_existetrn           exception;
  e_procesoinvalido     exception;
  e_subprocesoinvalido  exception;
  v_result bc_archivo_msg_t.descripcion%type;
begin
   select bc_log_id_seq.nextval into v_sec_log from dual;
   p_sec := v_sec_log;

   --Si el archivo es de Liquidacion(Archivo XML)
   if p_tipo_archivo IN ('LQ','RV') then
      v_result := EsArchivoValido(p_nombrearchivo);

      -- Longitud Invalidad
      if (v_result = '1') then
          raise e_logitudinvalid;
      end if;

      --Bic Invalido--
      if (v_result = '3') then
         raise e_bicinvalid;
      end if;

      insert into bc_log_archivo_t (nombrearchivo,mensaje_id,estatus,secuencia_log, fechaadd)
      values(p_nombrearchivo,44,'AG',v_sec_log, v_fecha);
      commit;
      p_result := v_result;
      -- Si el archivo es de Consentracion(Archivo TXT)
    else
      v_result := EsArchivoConcentracion(p_nombrearchivo);

      --Longitud Invalidad.
      if (v_result = '1') then
          raise e_logitudinvalid;
      end if;

      --Proceso Invalido.
      if (v_result = '31') then
         raise  e_procesoinvalido;
      end if;

      -- Sub_Proceso Invalido.
      if (v_result = '32') then
         raise e_subprocesoinvalido;
      end if;

      insert into bc_log_archivo_t (nombrearchivo,estatus,secuencia_log, fechaadd)
      values(p_nombrearchivo,'AG',v_sec_log, v_fecha);
      commit;

      p_result := v_result;
   end if;
exception
when e_logitudinvalid then
     p_result := '1';
     insert into bc_log_archivo_t (nombrearchivo,estatus,secuencia_log,Fechaerror,Mensaje_id,ocurrido,fechaadd)
     values(p_nombrearchivo,'ER',v_sec_log, v_fecha, p_result,'AR', v_fecha);
     commit;
when e_bicinvalid then
     p_result := '3';
     insert into bc_log_archivo_t (nombrearchivo,estatus,secuencia_log,Fechaerror,mensaje_id,ocurrido,fechaadd)
     values(p_nombrearchivo,'ER',v_sec_log, v_fecha, p_result,'AR', v_fecha);
     commit;
when e_trninvalid then
     p_result := '3';
     insert into bc_log_archivo_t (nombrearchivo,estatus,secuencia_log,Fechaerror,mensaje_id,ocurrido,fechaadd)
     values(p_nombrearchivo,'ER',v_sec_log, v_fecha, p_result,'AR', v_fecha);
     commit;
when e_existetrn then
     p_result := '3';
     insert into bc_log_archivo_t (nombrearchivo,estatus,secuencia_log,Fechaerror,mensaje_id,ocurrido,fechaadd)
     values(p_nombrearchivo,'ER',v_sec_log, v_fecha, p_result,'AR', v_fecha);
     commit;
when e_procesoinvalido then
     p_result := '31';
     insert into bc_log_archivo_t (nombrearchivo,estatus,secuencia_log,Fechaerror,mensaje_id,ocurrido,fechaadd)
     values(p_nombrearchivo,'ER',v_sec_log, v_fecha, p_result,'AR',v_fecha);
     commit;
when e_subprocesoinvalido then
     p_result := '32';
     insert into bc_log_archivo_t (nombrearchivo,estatus,secuencia_log,Fechaerror,mensaje_id,ocurrido,fechaadd)
     values(p_nombrearchivo,'ER',v_sec_log, v_fecha, p_result,'AR',v_fecha);
     commit;
when others then
     p_result := 'Ocurrio el siguiente error' || '' || sqlerrm;
     insert into bc_log_archivo_t (nombrearchivo,estatus,secuencia_log,Fechaerror,errordb,ocurrido,fechaadd)
     values(p_nombrearchivo,'ER',v_sec_log, v_fecha, p_result,'AR',v_fecha);
     commit;
end addarchivolog;

procedure set_archive_status(p_operacion in varchar2,
                             p_error_id in bc_log_archivo_t.mensaje_id%type,
                             p_sec in bc_log_archivo_t.secuencia_log%type,
                             p_nombre_archivo bc_log_archivo_t.nombrearchivo%type,
                             p_error_ap in bc_log_archivo_t.erroraplicacion%type default null,
                             p_error_db in bc_log_archivo_t.errordb%type default null)
is
begin
     case p_operacion
      when 'DES' then
        update bc_log_archivo_t lo
           set lo.estatus    = 'DE',
               lo.fechades   = v_fecha,
               lo.mensaje_id = p_error_id
         where lo.secuencia_log = p_sec
           and lo.nombrearchivo = p_nombre_archivo;

         update bc_log_archivo_t lo
            set lo.estatus     = 'MV',
                lo.fechamovido = v_fecha,
                lo.mensaje_id  = p_error_id
          where lo.secuencia_log = p_sec
            and lo.nombrearchivo = p_nombre_archivo;
      when 'ERR' then
         update bc_log_archivo_t lo
            set lo.estatus    = 'ER',
                lo.ocurrido   = 'AR',
                lo.fechaerror = v_fecha,
                lo.mensaje_id = p_error_id,
                lo.erroraplicacion = p_error_ap
          where lo.secuencia_log = p_sec
            and lo.nombrearchivo = p_nombre_archivo;
      when 'ENV' then
         update bc_log_archivo_t lo
            set lo.estatus         = 'EV',
                lo.fechaenvio      = v_fecha,
                lo.mensaje_id      = p_error_id,
                lo.fechaerror      = null,
                lo.errordb         = null,
                lo.erroraplicacion = null
          where lo.secuencia_log   = p_sec
            and lo.nombrearchivo   = p_nombre_archivo;
     when 'PRC' then
         update bc_log_archivo_t lo
            set lo.estatus         = 'PR',
                lo.fechaprocesado  = v_fecha,
                lo.mensaje_id      = p_error_id,
                lo.fechaerror      = null,
                lo.errordb         = null,
                lo.erroraplicacion = null
          where lo.secuencia_log   = p_sec
            and lo.nombrearchivo   = p_nombre_archivo;
     when 'EPR' then
         update bc_log_archivo_t lo
            set lo.estatus         = 'EP',
                lo.fechaenproceso  = v_fecha,
                lo.mensaje_id      = p_error_id,
                lo.fechaerror      = null,
                lo.errordb         = null,
                lo.erroraplicacion = null
          where lo.secuencia_log   = p_sec
            and lo.nombrearchivo   = p_nombre_archivo;
      when 'ERDB' then
         update bc_log_archivo_t lo
            set lo.estatus    = 'ER',
                lo.fechaerror = v_fecha,
                lo.errordb    = p_error_db,
                lo.mensaje_id = p_error_id
          where lo.secuencia_log = p_sec
            and lo.nombrearchivo = p_nombre_archivo;
       when 'ERAP' then
         update bc_log_archivo_t lo
            set lo.estatus         = 'ER',
                lo.fechaerror      = v_fecha,
                lo.erroraplicacion = p_error_ap,
                lo.mensaje_id      = p_error_id
          where lo.secuencia_log = p_sec
            and lo.nombrearchivo = p_nombre_archivo;
     end case;
end set_archive_status;

procedure MarcarArchivo(p_archivolog bc_log_archivo_t%rowtype)
is
begin
    if (p_archivolog.estatus = 'ER') then
       update bc_log_archivo_t lo
        set lo.estatus    = p_archivolog.estatus,
            lo.ocurrido   = p_archivolog.ocurrido,
            lo.fechaerror = p_archivolog.fechaerror,
            lo.mensaje_id = p_archivolog.mensaje_id,
            lo.errordb    = p_archivolog.errordb
       where lo.secuencia_log = p_archivolog.secuencia_log;
    else
       update bc_log_archivo_t lo
        set lo.estatus    = p_archivolog.estatus,
            lo.ocurrido   = p_archivolog.ocurrido,
            lo.fechaprocesado = p_archivolog.fechaprocesado,
            lo.mensaje_id = p_archivolog.mensaje_id,
            lo.errordb    = p_archivolog.errordb
       where lo.secuencia_log = p_archivolog.secuencia_log;
    end if;
    commit;

    --Para actualizar el estatus de la vista
    ActualizarVista(p_archivolog.mensaje_id);
end MarcarArchivo;

-------------------------------------------------------------------
-- procedure para menejar el tipo de exception que se dispar¿.
-------------------------------------------------------------------
procedure ManejoExcepciones(p_exceptiontype varchar2,
                            p_secuencia bc_encabezado_t.secuencia%type,
                            p_error_db varchar2 default null)
is
v_archivolog bc_log_archivo_t%rowtype;
begin
     case p_exceptiontype
    -----------------------------------------------
    --- Excepciones del Encabezdo del Archivo...
    -----------------------------------------------
          when 'ArchivoNull' then
              v_archivolog.estatus       := 'ER';
              v_archivolog.ocurrido      := 'EN';
              v_archivolog.Fechaerror    := v_fecha;
              v_archivolog.mensaje_id    := 1;
              v_archivolog.secuencia_log := p_secuencia;

              MarcarArchivo(v_archivolog);

           when 'EtiquetaArchivo' then
              v_archivolog.estatus       := 'ER';
              v_archivolog.ocurrido      := 'EN';
              v_archivolog.Fechaerror    := v_fecha;
              v_archivolog.mensaje_id    := 2;
              v_archivolog.secuencia_log := p_secuencia;

              MarcarArchivo(v_archivolog);

           when 'ArchivoInvalido' then
              v_archivolog.estatus       := 'ER';
              v_archivolog.ocurrido      := 'EN';
              v_archivolog.Fechaerror    := v_fecha;
              v_archivolog.mensaje_id    := 3;
              v_archivolog.secuencia_log := p_secuencia;

              MarcarArchivo(v_archivolog);

           when 'TipoNull' then
              v_archivolog.estatus       := 'ER';
              v_archivolog.ocurrido      := 'EN';
              v_archivolog.Fechaerror    := v_fecha;
              v_archivolog.mensaje_id    := 4;
              v_archivolog.secuencia_log := p_secuencia;

              MarcarArchivo(v_archivolog);

          when 'FechaGeneracionNull' then
              v_archivolog.estatus       := 'ER';
              v_archivolog.ocurrido      := 'EN';
              v_archivolog.Fechaerror    := v_fecha;
              v_archivolog.mensaje_id    := 5;
              v_archivolog.secuencia_log := p_secuencia;

              MarcarArchivo(v_archivolog);

           when 'HoraGeneracion' then
              v_archivolog.estatus       := 'ER';
              v_archivolog.ocurrido      := 'EN';
              v_archivolog.Fechaerror    := v_fecha;
              v_archivolog.mensaje_id    := 6;
              v_archivolog.secuencia_log := p_secuencia;

              MarcarArchivo(v_archivolog);

            when 'NombreLoteNull' then
              v_archivolog.estatus       := 'ER';
              v_archivolog.ocurrido      := 'EN';
              v_archivolog.Fechaerror    := v_fecha;
              v_archivolog.mensaje_id    := 7;
              v_archivolog.secuencia_log := p_secuencia;

              MarcarArchivo(v_archivolog);

            when 'ConceptoPagoNull' then
              v_archivolog.estatus       := 'ER';
              v_archivolog.ocurrido      := 'EN';
              v_archivolog.Fechaerror    := v_fecha;
              v_archivolog.mensaje_id    := 8;
              v_archivolog.secuencia_log := p_secuencia;

              MarcarArchivo(v_archivolog);

           when 'CodBicDBInvalido' then
              v_archivolog.estatus       := 'ER';
              v_archivolog.ocurrido      := 'EN';
              v_archivolog.Fechaerror    := v_fecha;
              v_archivolog.mensaje_id    := 9;
              v_archivolog.secuencia_log := p_secuencia;

              MarcarArchivo(v_archivolog);

           when 'CodBicCRInvalido' then
              v_archivolog.estatus       := 'ER';
              v_archivolog.ocurrido      := 'EN';
              v_archivolog.Fechaerror    := v_fecha;
              v_archivolog.mensaje_id    := 10;
              v_archivolog.secuencia_log := p_secuencia;

              MarcarArchivo(v_archivolog);

            when 'TRNNull' then
              v_archivolog.estatus       := 'ER';
              v_archivolog.ocurrido      := 'EN';
              v_archivolog.Fechaerror    := v_fecha;
              v_archivolog.mensaje_id    := 11;
              v_archivolog.secuencia_log := p_secuencia;

              MarcarArchivo(v_archivolog);

           when 'FechaValorNull' then
              v_archivolog.estatus       := 'ER';
              v_archivolog.ocurrido      := 'EN';
              v_archivolog.Fechaerror    := v_fecha;
              v_archivolog.mensaje_id    := 12;
              v_archivolog.secuencia_log := p_secuencia;

              MarcarArchivo(v_archivolog);

           when 'TotalRegistroNull' then
              v_archivolog.estatus       := 'ER';
              v_archivolog.ocurrido      := 'EN';
              v_archivolog.Fechaerror    := v_fecha;
              v_archivolog.mensaje_id    := 13;
              v_archivolog.secuencia_log := p_secuencia;

              MarcarArchivo(v_archivolog);

           when 'TotalMontoNull' then
              v_archivolog.estatus       := 'ER';
              v_archivolog.ocurrido      := 'EN';
              v_archivolog.Fechaerror    := v_fecha;
              v_archivolog.mensaje_id    := 14;
              v_archivolog.secuencia_log := p_secuencia;

              MarcarArchivo(v_archivolog);

           when 'MonedaNull' then
              v_archivolog.estatus       := 'ER';
              v_archivolog.ocurrido      := 'EN';
              v_archivolog.Fechaerror    := v_fecha;
              v_archivolog.mensaje_id    := 15;
              v_archivolog.secuencia_log := p_secuencia;

              MarcarArchivo(v_archivolog);

           when 'InformacionAdicional' then
             v_archivolog.estatus       := 'ER';
             v_archivolog.ocurrido      := 'EN';
             v_archivolog.Fechaerror    := v_fecha;
             v_archivolog.mensaje_id    := 16;
             v_archivolog.secuencia_log := p_secuencia;

             MarcarArchivo(v_archivolog);

           when 'estadoArchivo' then
              v_archivolog.estatus       := 'ER';
              v_archivolog.ocurrido      := 'EN';
              v_archivolog.Fechaerror    := v_fecha;
              v_archivolog.mensaje_id    := 17;
              v_archivolog.secuencia_log := p_secuencia;

              MarcarArchivo(v_archivolog);

           when 'cantidaddescarga' then
              v_archivolog.estatus       := 'ER';
              v_archivolog.ocurrido      := 'EN';
              v_archivolog.Fechaerror    := v_fecha;
              v_archivolog.mensaje_id    := 18;
              v_archivolog.secuencia_log := p_secuencia;

              MarcarArchivo(v_archivolog);

           when 'usuariodescarga' then
              v_archivolog.estatus       := 'ER';
              v_archivolog.ocurrido      := 'EN';
              v_archivolog.Fechaerror    := v_fecha;
              v_archivolog.mensaje_id    := 19;
              v_archivolog.secuencia_log := p_secuencia;

              MarcarArchivo(v_archivolog);

          -------------------------------------------
          ----excepciones del detalle de archivo.
          -------------------------------------------
          when 'NomBeneficiario' then
             v_archivolog.estatus       := 'ER';
             v_archivolog.ocurrido      := 'DE';
             v_archivolog.Fechaerror    := v_fecha;
             v_archivolog.mensaje_id    := 20;
             v_archivolog.secuencia_log := p_secuencia;

             MarcarArchivo(v_archivolog);

          when 'IdenBeneficiario' then
             v_archivolog.estatus       := 'ER';
             v_archivolog.ocurrido      := 'DE';
             v_archivolog.Fechaerror    := v_fecha;
             v_archivolog.mensaje_id    := 21;
             v_archivolog.secuencia_log := p_secuencia;

             MarcarArchivo(v_archivolog);

          when 'MontoDepositar' then
             v_archivolog.estatus       := 'ER';
             v_archivolog.ocurrido      := 'DE';
             v_archivolog.Fechaerror    := v_fecha;
             v_archivolog.mensaje_id    := 22;
             v_archivolog.secuencia_log := p_secuencia;

             MarcarArchivo(v_archivolog);

          when 'Nrocuenta' then
             v_archivolog.estatus       := 'ER';
             v_archivolog.ocurrido      := 'DE';
             v_archivolog.Fechaerror    := v_fecha;
             v_archivolog.mensaje_id    := 23;
             v_archivolog.secuencia_log := p_secuencia;

             MarcarArchivo(v_archivolog);

          when 'NrocuentaInvalido' then
             v_archivolog.estatus       := 'ER';
             v_archivolog.ocurrido      := 'DE';
             v_archivolog.Fechaerror    := v_fecha;
             v_archivolog.mensaje_id    := 24;
             v_archivolog.secuencia_log := p_secuencia;

             MarcarArchivo(v_archivolog);

          when 'TipoCuenta' then
             v_archivolog.estatus       := 'ER';
             v_archivolog.ocurrido      := 'DE';
             v_archivolog.Fechaerror    := v_fecha;
             v_archivolog.mensaje_id    := 24;
             v_archivolog.secuencia_log := p_secuencia;

             MarcarArchivo(v_archivolog);

          when 'ConceptoDetalle' then
             v_archivolog.estatus       := 'ER';
             v_archivolog.ocurrido      := 'DE';
             v_archivolog.Fechaerror    := v_fecha;
             v_archivolog.mensaje_id    := 25;
             v_archivolog.secuencia_log := p_secuencia;

             MarcarArchivo(v_archivolog);

          when 'InformAdicionalPago01' then
             v_archivolog.estatus       := 'ER';
             v_archivolog.ocurrido      := 'DE';
             v_archivolog.Fechaerror    := v_fecha;
             v_archivolog.mensaje_id    := 26;
             v_archivolog.secuencia_log := p_secuencia;

             MarcarArchivo(v_archivolog);

          when 'InformAdicionalPago02' then
             v_archivolog.estatus       := 'ER';
             v_archivolog.ocurrido      := 'DE';
             v_archivolog.Fechaerror    := v_fecha;
             v_archivolog.mensaje_id    := 27;
             v_archivolog.secuencia_log := p_secuencia;

             MarcarArchivo(v_archivolog);

          when 'DigitoControl' then
             v_archivolog.estatus       := 'ER';
             v_archivolog.ocurrido      := 'DE';
             v_archivolog.Fechaerror    := v_fecha;
             v_archivolog.mensaje_id    := 28;
             v_archivolog.secuencia_log := p_secuencia;

             MarcarArchivo(v_archivolog);

          -------------------------------------------
          ----excepciones del encabezado archivo TXT
          -------------------------------------------
          when 'LongitudLinea' then
             v_archivolog.estatus       := 'ER';
             v_archivolog.ocurrido      := 'EN';
             v_archivolog.Fechaerror    := v_fecha;
             v_archivolog.mensaje_id    := 29;
             v_archivolog.secuencia_log := p_secuencia;

             MarcarArchivo(v_archivolog);

          when 'TipoLinea' then
             v_archivolog.estatus       := 'ER';
             v_archivolog.ocurrido      := 'EN';
             v_archivolog.Fechaerror    := v_fecha;
             v_archivolog.mensaje_id    := 30;
             v_archivolog.secuencia_log := p_secuencia;

             MarcarArchivo(v_archivolog);

          when 'CodigoProceso' then
             v_archivolog.estatus       := 'ER';
             v_archivolog.ocurrido      := 'EN';
             v_archivolog.Fechaerror    := v_fecha;
             v_archivolog.mensaje_id    := 31;
             v_archivolog.secuencia_log := p_secuencia;

             MarcarArchivo(v_archivolog);

          when 'CodigoSubProceso' then
             v_archivolog.estatus       := 'ER';
             v_archivolog.ocurrido      := 'EN';
             v_archivolog.Fechaerror    := v_fecha;
             v_archivolog.mensaje_id    := 32;
             v_archivolog.secuencia_log := p_secuencia;

             MarcarArchivo(v_archivolog);

          when 'TamanoRegistro' then
             v_archivolog.estatus       := 'ER';
             v_archivolog.ocurrido      := 'EN';
             v_archivolog.Fechaerror    := v_fecha;
             v_archivolog.mensaje_id    := 33;
             v_archivolog.secuencia_log := p_secuencia;

             MarcarArchivo(v_archivolog);

          when 'TipoEntidadRecaudadora' then
             v_archivolog.estatus       := 'ER';
             v_archivolog.ocurrido      := 'EN';
             v_archivolog.Fechaerror    := v_fecha;
             v_archivolog.mensaje_id    := 34;
             v_archivolog.secuencia_log := p_secuencia;

             MarcarArchivo(v_archivolog);

          when 'EntidadRecaudadora' then
             v_archivolog.estatus       := 'ER';
             v_archivolog.ocurrido      := 'EN';
             v_archivolog.Fechaerror    := v_fecha;
             v_archivolog.mensaje_id    := 35;
             v_archivolog.secuencia_log := p_secuencia;

             MarcarArchivo(v_archivolog);

          when 'FechaTransmision' then
             v_archivolog.estatus       := 'ER';
             v_archivolog.ocurrido      := 'EN';
             v_archivolog.Fechaerror    := v_fecha;
             v_archivolog.mensaje_id    := 36;
             v_archivolog.secuencia_log := p_secuencia;

             MarcarArchivo(v_archivolog);

          when 'NumeroArchivo' then
             v_archivolog.estatus       := 'ER';
             v_archivolog.ocurrido      := 'EN';
             v_archivolog.Fechaerror    := v_fecha;
             v_archivolog.mensaje_id    := 37;
             v_archivolog.secuencia_log := p_secuencia;

             MarcarArchivo(v_archivolog);

          -------------------------------------------
          ----excepciones del detalle archivo TXT
          -------------------------------------------
          when 'FechaSolicitud' then
             v_archivolog.estatus       := 'ER';
             v_archivolog.ocurrido      := 'DE';
             v_archivolog.Fechaerror    := v_fecha;
             v_archivolog.mensaje_id    := 38;
             v_archivolog.secuencia_log := p_secuencia;

             MarcarArchivo(v_archivolog);

          when 'InstruccionConcentracion' then
             v_archivolog.estatus       := 'ER';
             v_archivolog.ocurrido      := 'DE';
             v_archivolog.Fechaerror    := v_fecha;
             v_archivolog.mensaje_id    := 39;
             v_archivolog.secuencia_log := p_secuencia;

             MarcarArchivo(v_archivolog);

          when 'ImporteConcentracion' then
             v_archivolog.estatus       := 'ER';
             v_archivolog.ocurrido      := 'DE';
             v_archivolog.Fechaerror    := v_fecha;
             v_archivolog.mensaje_id    := 40;
             v_archivolog.secuencia_log := p_secuencia;

             MarcarArchivo(v_archivolog);

          when 'CuentaOrigen' then
             v_archivolog.estatus       := 'ER';
             v_archivolog.ocurrido      := 'DE';
             v_archivolog.Fechaerror    := v_fecha;
             v_archivolog.mensaje_id    := 41;
             v_archivolog.secuencia_log := p_secuencia;

             MarcarArchivo(v_archivolog);

          when 'CuentaDestino' then
             v_archivolog.estatus       := 'ER';
             v_archivolog.ocurrido      := 'DE';
             v_archivolog.Fechaerror    := v_fecha;
             v_archivolog.mensaje_id    := 42;
             v_archivolog.secuencia_log := p_secuencia;

             MarcarArchivo(v_archivolog);

          when 'ClaveTipoEntidadDeposita' then
             v_archivolog.estatus       := 'ER';
             v_archivolog.ocurrido      := 'DE';
             v_archivolog.Fechaerror    := v_fecha;
             v_archivolog.mensaje_id    := 43;
             v_archivolog.secuencia_log := p_secuencia;

             MarcarArchivo(v_archivolog);

          when 'ClaveEntidadSolicita' then
             v_archivolog.estatus       := 'ER';
             v_archivolog.ocurrido      := 'DE';
             v_archivolog.Fechaerror    := v_fecha;
             v_archivolog.mensaje_id    := 44;
             v_archivolog.secuencia_log := p_secuencia;

             MarcarArchivo(v_archivolog);

          when 'ClaveEntidadEntrega' then
             v_archivolog.estatus       := 'ER';
             v_archivolog.ocurrido      := 'DE';
             v_archivolog.Fechaerror    := v_fecha;
             v_archivolog.mensaje_id    := 45;
             v_archivolog.secuencia_log := p_secuencia;

             MarcarArchivo(v_archivolog);

          -------------------------------------------
          ----excepciones del sumario archivo TXT
          -------------------------------------------
          when 'NumeroRegistros' then
             v_archivolog.estatus       := 'ER';
             v_archivolog.ocurrido      := 'SU';
             v_archivolog.Fechaerror    := v_fecha;
             v_archivolog.mensaje_id    := 46;
             v_archivolog.secuencia_log := p_secuencia;

             MarcarArchivo(v_archivolog);

          when 'TotalLiquidarAjuste' then
             v_archivolog.estatus       := 'ER';
             v_archivolog.ocurrido      := 'SU';
             v_archivolog.Fechaerror    := v_fecha;
             v_archivolog.mensaje_id    := 47;
             v_archivolog.secuencia_log := p_secuencia;

             MarcarArchivo(v_archivolog);

          when 'MontoAclarado' then
             v_archivolog.estatus       := 'ER';
             v_archivolog.ocurrido      := 'SU';
             v_archivolog.Fechaerror    := v_fecha;
             v_archivolog.mensaje_id    := 48;
             v_archivolog.secuencia_log := p_secuencia;

             MarcarArchivo(v_archivolog);

          when 'TotalAjustes' then
             v_archivolog.estatus       := 'ER';
             v_archivolog.ocurrido      := 'SU';
             v_archivolog.Fechaerror    := v_fecha;
             v_archivolog.mensaje_id    := 49;
             v_archivolog.secuencia_log := p_secuencia;

             MarcarArchivo(v_archivolog);

          when 'TotalLiquidar' then
             v_archivolog.estatus       := 'ER';
             v_archivolog.ocurrido      := 'SU';
             v_archivolog.Fechaerror    := v_fecha;
             v_archivolog.mensaje_id    := 50;
             v_archivolog.secuencia_log := p_secuencia;

             MarcarArchivo(v_archivolog);

          -------------------------------------------
          ---- otras excepciones
          -------------------------------------------
          when 'Procesado' then
              v_archivolog.estatus       := 'PR';
              v_archivolog.ocurrido      := null;
              v_archivolog.fechaprocesado:= v_fecha;
              v_archivolog.mensaje_id    := 0;
              v_archivolog.secuencia_log := p_secuencia;

              MarcarArchivo(v_archivolog);

          when 'Descifrado' then
             v_archivolog.estatus       := 'ER';
             v_archivolog.ocurrido      := 'AR';
             v_archivolog.Fechaerror    := v_fecha;
             v_archivolog.mensaje_id    := 51;
             v_archivolog.secuencia_log := p_secuencia;

             MarcarArchivo(v_archivolog);

          when 'OracleException' then
             v_archivolog.estatus       := 'ER';
             v_archivolog.ocurrido      := 'AR';
             v_archivolog.Fechaerror    := v_fecha;
             v_archivolog.mensaje_id    := 52;
             v_archivolog.errordb       := p_error_db;
             v_archivolog.secuencia_log := p_secuencia;

             MarcarArchivo(v_archivolog);
         end case;
end ManejoExcepciones;

procedure getMailAddress(p_listok out sfc_procesos_t.lista_ok%type,
                         p_listerror out sfc_procesos_t.lista_error%type)
is
v_listok sfc_procesos_t.lista_ok%type;
v_listerror sfc_procesos_t.lista_error%type;
begin
    select p.lista_ok, p.lista_error
      into v_listok, v_listerror
      from sfc_procesos_t p
     where p.id_proceso = 'BC';

     p_listok := v_listok;
     p_listerror := v_listerror;
end getMailAddress;

PROCEDURE get_llaves_XML (
  p_id_parametro          SFC_DET_PARAMETRO_T.id_parametro%TYPE,
  p_llave OUT                SFC_DET_PARAMETRO_T.valor_texto%type) AS

v_llave sfc_det_parametro_t.valor_texto%type;
v_vector sfc_det_parametro_t.valor_texto%type;
begin

if (p_id_parametro = 108) then

/*    select  dp.valor_texto as valor_texto
    into  v_llave from sfc_det_parametro_t dp
   where dp.id_parametro = p_id_parametro;
     p_llave := v_llave;
*/
   select Encryption.decrypt(dp.valor_texto) as valor_texto
    into  v_llave from sfc_det_parametro_t dp
   where dp.id_parametro = p_id_parametro;
     p_llave := v_llave;

else -- p_id_parametro = 107
 /*   select dp.valor_texto  as valor_texto
    into v_vector from sfc_det_parametro_t dp
   where dp.id_parametro = p_id_parametro;*/

   select Encryption.decrypt(dp.valor_texto) as valor_texto
    into v_vector from sfc_det_parametro_t dp
   where dp.id_parametro = p_id_parametro;

   p_llave := v_vector;
end if;
END get_llaves_XML;

procedure RunCmd(p_cmd in varchar2, p_result out number)
is
begin
  --p_result := run_cmd(p_cmd);
  select os_command.exec(p_cmd) into p_result from dual;
end RunCmd;

procedure getArchivos(p_tipo_archivo      in varchar2,
                                    p_fecha_ini          in bc_log_archivo_t.fechaadd%type,
                                    p_fecha_fin         in  bc_log_archivo_t.fechaadd%type,
                                    p_pagenum            in number,
                                    p_pagesize            in number,
                                    p_resultnumber      out varchar2,
                                    p_io_cursor           in out t_cursor)

is
e_Existe exception;
v_cursor  t_cursor;
vDesde integer := (p_pagesize*(p_pagenum-1))+1;
vhasta integer := p_pagesize*p_pagenum;
v_bderror varchar2(1000);
begin

 case p_tipo_archivo

      when 'Concentracion' then
           open v_cursor for
                         with x as (select rownum num,y.* from (
                                                                               select decode(upper(substr(trim(lo.nombrearchivo), -3)),'TXT','CONCENTRACION','XML', 'LIQUIDACION','TIPO NO DEFINIDO') tipoarchivo, lo.nombrearchivo,
                                                                                   decode(lo.estatus,
                                                                                          'EV',
                                                                                          'Archivo Enviado',
                                                                                          'ER',
                                                                                          'Archivo con Error',
                                                                                          'PR',
                                                                                          'Archivo Procesado',
                                                                                          'EP',
                                                                                          'Archvio En Proceso',
                                                                                          'AG',
                                                                                          'Archivo Agregado',
                                                                                          'MV',
                                                                                          'Movido de carpeta') estatus,
                                                                                   decode(m.descripcion, '', 'N/A', m.descripcion) as mensaje,
                                                                                   lo.fechaadd as FechaRecogido
                                                                              from bc_log_archivo_t lo
                                                                              left join bc_archivo_msg_t m on lo.mensaje_id = m.id_msg
                                                                             where lo.nombrearchivo like '%.TXT'
                                                                               and lo.fechaadd between decode(p_fecha_ini,null,lo.fechaadd,p_fecha_ini)
                                                                                and decode(p_fecha_fin,null,lo.fechaadd,p_fecha_fin)
                                                       )y) select y.recordcount,x.*
                                  from x,(select max(num) recordcount from x) y
                                  where num between vDesde and vHasta
                                  order by num;
     p_io_cursor := v_cursor;
     p_resultnumber := 0;

      when 'Liquidacion' then
            open v_cursor for
                         with x as (select rownum num,y.* from (
                                                                               select decode(upper(substr(trim(lo.nombrearchivo), -3)),'TXT','CONCENTRACION','XML', 'LIQUIDACION','TIPO NO DEFINIDO') tipoarchivo, lo.nombrearchivo,
                                                                                   decode(lo.estatus,
                                                                                          'EV',
                                                                                          'Archivo Enviado',
                                                                                          'ER',
                                                                                          'Archivo con Error',
                                                                                          'PR',
                                                                                          'Archivo Procesado',
                                                                                          'EP',
                                                                                          'Archvio En Proceso',
                                                                                          'AG',
                                                                                          'Archivo Agregado',
                                                                                          'MV',
                                                                                          'Movido de carpeta') estatus,
                                                                                   decode(m.descripcion, '', 'N/A', m.descripcion) as mensaje,
                                                                                   lo.fechaadd as FechaRecogido
                                                                              from bc_log_archivo_t lo
                                                                              left join bc_archivo_msg_t m on lo.mensaje_id = m.id_msg
                                                                             where lo.nombrearchivo like '%.xml'
                                                                               and lo.fechaadd between decode(p_fecha_ini,null,lo.fechaadd,p_fecha_ini)
                                                                                and decode(p_fecha_fin,null,lo.fechaadd,p_fecha_fin)
                                              )y) select y.recordcount,x.*
                                  from x,(select max(num) recordcount from x) y
                                  where num between vDesde and vHasta
                                  order by num;
    p_io_cursor := v_cursor;
     p_resultnumber := 0;

      when 'Todos' then
          open v_cursor for
                         with x as (select rownum num,y.* from (
                                                                               select decode(upper(substr(trim(lo.nombrearchivo), -3)),'TXT','CONCENTRACION','XML', 'LIQUIDACION','TIPO NO DEFINIDO') tipoarchivo,
                                                                                      lo.nombrearchivo,decode(lo.estatus,'EV','Archivo Enviado','ER','Archivo con Error','PR','Archivo Procesado','EP','Archvio En Proceso','AG','Archivo Agregado','MV','Movido de carpeta') estatus,
                                                                                      decode(m.descripcion,
                                                                                             '',
                                                                                             'N/A',
                                                                                             m.descripcion) as mensaje,
                                                                                      lo.fechaadd as fecharecogido
                                                                                 from bc_log_archivo_t lo
                                                                                 left join bc_archivo_msg_t m on lo.mensaje_id =
                                                                                                                 m.id_msg
                                                                                where lo.fechaadd between
                                                                                      nvl(p_fecha_ini,
                                                                                          lo.fechaadd) and
                                                                                      nvl(p_fecha_fin,
                                                                                          lo.fechaadd)
                                                                                order by lo.nombrearchivo asc
                                                       )y) select y.recordcount,x.*
                                  from x,(select max(num) recordcount from x) y
                                  where num between vDesde and vHasta
                                  order by num;
    p_io_cursor := v_cursor;
     p_resultnumber := 0;
  end case;
 exception
     when others then
      v_bderror := (substr('error '||to_char(sqlcode)||': '||sqlerrm, 1, 255));
      p_resultnumber := seg_retornar_cadena_error(-1, v_bderror,sqlcode);

end getArchivos;

procedure getArchivoEncConcentracion(p_nombre_archivo in bc_co_encabezado_t.nombrearchivo%type,
                                                             p_io_cursor            in out t_cursor,
                                                             p_result                 out varchar2)
is
v_cursor  t_cursor;
v_bderror varchar2(1000);
begin
     open v_cursor for
       select eco.nombrearchivo,
           eco.proceso,
           eco.sub_proceso,
           eco.fechatransmision,
           er.entidad_recaudadora_des entidadreceptora,
           eco.nro_archivo nrolote,
           su.numero_registros as totalregistros,
           su.total_liquidar_ajuste as liquidarsinajuste,
           su.monto_aclarado as montoaclarado,
           su.total_ajuste as totalajuste,
           su.total_liquidar as totalliquidar
      from bc_co_encabezado_t eco
      join bc_co_sumario_t su on su.secuencia = eco.secuencia
      join sfc_entidad_recaudadora_t er on er.id_entidad_recaudadora = eco.entidad_mov_fondos
      where eco.nombrearchivo = p_nombre_archivo;

 p_io_cursor := v_cursor;
 p_result := '0';
 exception
 when others  then
     v_bderror := (substr('error '||to_char(sqlcode)||': '||sqlerrm, 1, 255));
      p_result := seg_retornar_cadena_error(-1, v_bderror,sqlcode);
end;

procedure getArchvioDetConcentracion(p_nombre_archivo in bc_co_encabezado_t.nombrearchivo%type,
                                                             p_io_cursor          in out t_cursor,
                                                             p_result                out varchar2)
is
v_cursor  t_cursor;
v_bderror varchar2(1000);
begin
     open v_cursor for
          select dco.fecha_solicitud,
                 decode(dco.tipo_instruccion, 1,'Concentracion Referencias Validas', 2,'Concentracion  Referencias Aclaradas', 5, 'Ajustes') as tipo_instruccion,
                 dco.importe_instruccion as monto_instruccion,
                 dco.cuenta_origen as cuenta_origen,
                 dco.cuenta_destino,
                 er1.entidad_recaudadora_des as entidad_origen,
                 er.entidad_recaudadora_des as entidad_destino
            from bc_co_detalle_t dco
            join sfc_entidad_recaudadora_t er on er.id_entidad_recaudadora =
                                                 dco.entidad_destino
            join sfc_entidad_recaudadora_t er1 on er1.id_entidad_recaudadora =
                                                  dco.entidad_origen
            join bc_co_encabezado_t eco on eco.secuencia = dco.secuencia
           where eco.nombrearchivo = p_nombre_archivo;
  p_io_cursor := v_cursor;
 p_result := '0';
  exception
 when others  then
      v_bderror := (substr('error '||to_char(sqlcode)||': '||sqlerrm, 1, 255));
      p_result := seg_retornar_cadena_error(-1, v_bderror,sqlcode);
end;

procedure getArchivoEncLiquidacion(p_nombre_archivo in bc_encabezado_t.nombrearchivo%type,
                                                         p_io_cursor          in out t_cursor,
                                                         p_result                out varchar2)
is
v_cursor  t_cursor;
v_bderror varchar2(1000);
begin
      open v_cursor for
             select en.nombrearchivo,
                    getproceso(substr(en.trnopcrlbtr, 0, 12)) proceso,
                    en.trnopcrlbtr as trn,
                    en.tipo,
                    en.fechageneracion,
                    en.horageneracion,
                    en.nombrelote,
                    en.conceptopago,
                    en.codigobicentidaddb as entidaddebita,
                    en.codigobicentidadcr as entidadcredita,
                    en.fechavalorcrlbtr as fechaoperacion,
                    en.totalregistroscontrol as registrocontrol,
                    en.totalmontoscontrol as totalcontrol,
                    en.moneda
               from bc_encabezado_t en
              where en.nombrearchivo = p_nombre_archivo;
 p_io_cursor := v_cursor;
 p_result := '0';
  exception
 when others  then
     v_bderror := (substr('error '||to_char(sqlcode)||': '||sqlerrm, 1, 255));
      p_result := seg_retornar_cadena_error(-1, v_bderror,sqlcode);
end;

procedure getArchivoDetLiquidacion(p_nombre_archivo in bc_encabezado_t.nombrearchivo%type,
                                                         p_io_cursor          in out t_cursor,
                                                         p_result            out varchar2)
is
v_cursor  t_cursor;
v_bderror varchar2(1000);
begin
     open v_cursor for
           select de.nombrebeneficiario,
                  de.identificacionbeneficiario as idbeneficiario,
                  de.montoadepositar as monto,
                  de.numerocuentaestandard as cuentaestandarizado,
                  de.tipocuenta,
                  de.conceptodetallado as concepto,
                  de.informadicionalpago01 as infoadicional1,
                  de.informadicionalpago02 as infoadicional2,
                  de.digitoscontrol
             from bc_detalle_t de
             join bc_encabezado_t en on de.secuencia = en.secuencia
                                    and de.nombrelote = en.nombrelote
            where en.nombrearchivo = p_nombre_archivo;

 p_io_cursor := v_cursor;
 p_result := '0';
 exception
 when others  then
     v_bderror := (substr('error '||to_char(sqlcode)||': '||sqlerrm, 1, 255));
      p_result := seg_retornar_cadena_error(-1, v_bderror,sqlcode);
end;

  /* --------------------------------------------------------------------------
   Autor   : Gregorio Herrera
   Fecha   : 13-Oct-2009
   Objetivo: Llevar registro del estatus de la corrida del proceso
  */ --------------------------------------------------------------------------
  FUNCTION getDescError RETURN VARCHAR2 AS
  BEGIN
    If c_log_file is null Then
      Begin
        Select b.descripcion
        Into c_log_file
        From suirplus.bc_log_archivo_t a
        Join suirplus.bc_archivo_msg_t b on b.id_msg = a.mensaje_id
        Where a.secuencia_log = v_sec_log;
      Exception When No_Data_Found Then
        c_log_file := 'Excepcion tratando de obtener la descripcion del mensaje de error '||sqlerrm;
      End;
    End if;
    RETURN c_log_file;
  END getDescError;

  /* --------------------------------------------------------------------------
   Autor   : Gregorio Herrera
   Fecha   : 13-Oct-2009
   Objetivo: Enviar email con los archivos procesados correctamente
  */ --------------------------------------------------------------------------
  PROCEDURE Send_Email AS
    v_desproceso  suirplus.bc_cod_trn_t.proceso%type;
    v_desEntidad  suirplus.sfc_entidad_recaudadora_t.entidad_recaudadora_des%type;
    v_desEntidad1 suirplus.sfc_entidad_recaudadora_t.entidad_recaudadora_des%type;
    v_result      VARCHAR2(5);
    v_mensaje_ret VARCHAR2(2000);
    v_numero_ret  NUMBER(5);
  BEGIN
    If (v_tablaEnc.Count > 0) Then --Liquidacion (XML)
      getDesProceso(v_tablaEnc(1).trnopcrlbtr, v_desproceso, v_result);
      getEntidadNombrePorBic(v_tablaEnc(1).CodigoBicEntidadCR, v_desEntidad, v_result);

      c_log_title := 'Archivo de Liquidacion de Fondos del '|| v_desEntidad;
      c_log_file := '<!DOCTYPE html PUBLIC -//W3C//DTD XHTML 1.0 Transitional//ENhttp://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd>'||
                    '<html xmlns="http://www.w3.org/1999/xhtml">'||
                    '<head><title>Archivo de liquidacion</title>'||
                    '<style type="text/css">'||
                    '.style1 {width: 190px; font-weight: bold;} '||
                    '.style2 {text-align: center; font-weight: bold;} '||
                    '.style3 {width: 326px;} '||
                    '.style4 {width: 681px; text-align: center; font-weight: bold; font-size:22px; font-family: Calibri;} '||
                    '.style5 {width: 681px; text-align: center; font-weight: bold; font-size:18px; font-family: Calibri;}'||
                    '</style></head>'||
                    '<body>'||
                    '<table style="width:100%;">'||
                    '<tr>'||
                    '<td class="style3">'||
                    '<img src="http://www.tss2.gov.do/images/logoTSShorizontal.gif" /></td>'||
                    '<td class="style4">Tesoreria de la Seguridad Social<br /> Departamento de Operaciones & Tecnologia</td>'||
                    '<td>&nbsp;</td>'||
                    '</tr>'||
                    '</table>'||
                    '<table style="width:100%;">'||
                    '<tr>'||
                    '<td class="style3">&nbsp;</td>'||
                    '<td class="style5">Reporte de Liquidacion de Fondos del '|| v_desEntidad || '</td>'||
                    '<td>&nbsp;</td>'||
                    '</tr>'||
                    '</table>'||
                    '<br />'||
                    '<table style="font-family:Calibri; border-collapse:collapse; width:100%; font-size:smaller;">'||
                    '<tr>'||
                    '<td class="style1">Nombre del Archivo:</td>'||
                    '<td>'||v_tablaEnc(1).NombreArchivo||'&nbsp;</td>'||
                    '</tr>'||
                    '<tr>'||
                    '<td class="style1">Proceso:</td>'||
                    '<td>'||v_desproceso||'&nbsp;</td>'||
                    '</tr>'||
                    '<tr>'||
                    '<td class="style1">TRN:</td>'||
                    '<td>'||v_tablaEnc(1).TrnoPcrLbtr||'&nbsp;</td>'||
                    '</tr>'||
                    '<tr>'||
                    '<td class="style1">Tipo:</td>'||
                    '<td>'||v_tablaEnc(1).Tipo||'&nbsp;</td>'||
                    '</tr>'||
                    '<tr>'||
                    '<td class="style1">Fecha Generacion:</td>'||
                    '<td>'||To_Char(v_tablaEnc(1).FechaGeneracion,'dd/mm/yyyy')||'&nbsp;</td>'||
                    '</tr>'||
                    '<tr>'||
                    '<td class="style1">Hora Generacion:</td>'||
                    '<td>'||To_Char(v_tablaEnc(1).HoraGeneracion,'mi:hh:ss AM')||'&nbsp;</td>'||
                    '</tr>'||
                    '<tr>'||
                    '<td class="style1">Nombre Lote:</td>'||
                    '<td>'||v_tablaEnc(1).NombreLote||'&nbsp;</td>'||
                    '</tr>'||
                    '<tr>'||
                    '<td class="style1">Concepto Pago:</td>'||
                    '<td>'||v_tablaEnc(1).ConceptoPago||'&nbsp;</td>'||
                    '</tr>'||
                    '<tr>'||
                    '<td class="style1">Codigo BIC Entidad Debitada:</td>'||
                    '<td>'||v_tablaEnc(1).CodigoBicEntidadDB||'&nbsp;</td>'||
                    '</tr>'||
                    '<tr>'||
                    '<td class="style1">Codigo BIC Entidad Acreditada:</td>'||
                    '<td>'||v_tablaEnc(1).CodigoBicEntidadCR||'&nbsp;</td>'||
                    '</tr>'||
                    '<tr>'||
                    '<td class="style1">Fecha Operacion del Credito:</td>'||
                    '<td>'||To_Char(v_tablaEnc(1).FechaValorCRLBTR,'dd/mm/yyyy')||'&nbsp;</td>'||
                    '</tr>'||
                    '<tr>'||
                    '<td class="style1">Registros (Control):</td>'||
                    '<td>'||v_tablaEnc(1).TotalRegistroscontrol||'&nbsp;</td>'||
                    '</tr>'||
                    '<tr>'||
                    '<td class="style1">Total (Control):</td>'||
                    '<td>'||To_Char(v_tablaEnc(1).TotalMontosControl,'99,999,999,990.00')||'&nbsp;</td>'||
                    '</tr>'||
                    '<tr>'||
                    '<td class="style1">Moneda:</td>'||
                    '<td>'||v_tablaEnc(1).Moneda||'&nbsp;</td>'||
                    '</tr>'||
                    '<tr><td colspan="2">&nbsp;</td></tr>'||
                    '</table>'||
                    '<table style="font-family: Calibri; text-align :center; border-collapse: collapse; width: 100%; font-size:smaller;">'||
                    '<tr>'||
                    '<td class="style2">Nombre Beneficiario</td>'||
                    '<td class="style2">ID Beneficiario</td>'||
                    '<td class="style2">Monto</td>'||
                    '<td class="style2">Numero Cuenta Estandarizado</td>'||
                    '<td class="style2">Tipo Cuenta</td>'||
                    '<td class="style2">Concepto</td>'||
                    '<td class="style2">Info. Adicional 1</td>'||
                    '<td class="style2">Info. Adicional 2</td>'||
                    '<td class="style2">Digitos Control</td>'||
                    '</tr>';
        For i in v_tablaDet.First .. v_tablaDet.Last Loop
          c_log_file := c_log_file ||
                        '<tr>'||
                        '<td>'|| v_tablaDet(i).NOMBREBENEFICIARIO||'&nbsp;</td>'||
                        '<td>'|| v_tablaDet(i).IDENTIFICACIONBENEFICIARIO||'&nbsp;</td>'||
                        '<td>'|| To_Char(v_tablaDet(i).MONTOADEPOSITAR,'99,999,999,990.00')||'&nbsp;</td>'||
                        '<td>'|| v_tablaDet(i).NUMEROCUENTAESTANDARD||'&nbsp;</td>'||
                        '<td>'|| v_tablaDet(i).TIPOCUENTA||'&nbsp;</td>'||
                        '<td>'|| v_tablaDet(i).CONCEPTODETALLADO||'&nbsp;</td>'||
                        '<td>'|| v_tablaDet(i).INFORMADICIONALPAGO01||'&nbsp;</td>'||
                        '<td>'|| v_tablaDet(i).INFORMADICIONALPAGO02||'&nbsp;</td>'||
                        '<td>'|| v_tablaDet(i).DIGITOSCONTROL||'&nbsp;</td></tr>';
        End Loop;
        c_log_file := c_log_file || '</table></body></html>';
        system.Sendmail_Pkg.send_email(
                                        p_recipient => v_lista_ok,
                                        p_subject => c_log_title,
                                        p_mensaje => c_log_file,
                                        p_sender => 'info@mail.tss2.gov.do',
                                        p_attachments => system.Sendmail_Pkg.ATTACHMENTS_LIST(c.other1_dir||v_tablaEnc(1).NombreArchivo),
                                        pmensaje_retorno => v_mensaje_ret,
                                        pnumero_retorno => v_numero_ret,
                                        pvalidar_attachment => 'S'
                                       );
      Else -- Concentraci¿n
        getNombreEntidad(v_tablaTxtEnc(1).Entidad_Mov_Fondos, v_desEntidad, v_result);

        c_log_title := 'Archivo de Concentracion del '||v_desEntidad;
        c_log_file := '<!DOCTYPE html PUBLIC -//W3C//DTD XHTML 1.0 Transitional//ENhttp://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd>'||
                      '<html xmlns="http://www.w3.org/1999/xhtml">'||
                      '<head><title>Archivo de concentracion</title>'||
                      '<style type="text/css">'||
                      '.style1 {width: 190px; font-weight: bold;} '||
                      '.style2 {text-align: center; font-weight: bold;} '||
                      '.style3 {width: 326px;} '||
                      '.style4 {width: 681px; text-align: center; font-weight: bold; font-size:22px; font-family: Calibri;} '||
                      '.style5 {width: 681px; text-align: center; font-weight: bold; font-size:18px; font-family: Calibri;}'||
                      '</style></head>'||
                      '<body>'||
                      '<table style="width:100%;">'||
                      '<tr>'||
                      '<td class="style3">'||
                      '<img src="http://www.tss2.gov.do/images/logoTSShorizontal.gif" /></td>'||
                      '<td class="style4">Tesoreria de la Seguridad Social<br /> Departamento de Operaciones & Tecnologia</td>'||
                      '<td>&nbsp;</td>'||
                      '</tr>'||
                      '</table>'||
                      '<table style="width:100%;">'||
                      '<tr>'||
                      '<td class="style3">&nbsp;</td>'||
                      '<td class="style5">Reporte Concentracion de Aportes</td>'||
                      '<td>&nbsp;</td>'||
                      '</tr>'||
                      '</table>'||
                      '<br />'||
                      '<table style="font-family:Calibri; border-collapse:collapse; width:100%; font-size:smaller;">'||
                      '<tr>'||
                      '<td class="style1">Nombre del Archivo:</td>'||
                      '<td>'||v_tablaTxtEnc(1).NombreArchivo||'&nbsp;</td>'||
                      '</tr>'||
                      '<tr>'||
                      '<td class="style1">Proceso:</td>'||
                      '<td>'||v_tablaTxtEnc(1).Proceso||'&nbsp;</td>'||
                      '</tr>'||
                      '<tr>'||
                      '<td class="style1">Sub_Proceso:</td>'||
                      '<td>'||v_tablaTxtEnc(1).Sub_Proceso||'&nbsp;</td>'||
                      '</tr>'||
                      '<tr>'||
                      '<td class="style1">Fecha Transacion:</td>'||
                      '<td>'||To_Char(v_tablaTxtEnc(1).FechaTransmision,'dd/mm/yyyy')||'&nbsp;</td>'||
                      '</tr>'||
                      '<tr>'||
                      '<td class="style1">Entidad Receptora:</td>'||
                      '<td>'||v_desEntidad||'&nbsp;</td>'||
                      '</tr>'||
                      '<tr>'||
                      '<td class="style1">Nro. Lote:</td>'||
                      '<td>'||v_tablaTxtEnc(1).Nro_Archivo||'&nbsp;</td>'||
                      '</tr>'||
                      '<tr>'||
                      '<td class="style1">Total Registros:</td>'||
                      '<td>'||v_tablaTxtSum(1).Numero_Registros||'&nbsp;</td>'||
                      '</tr>'||
                      '<tr>'||
                      '<td class="style1">Total a liquidar Sin Ajuste:</td>'||
                      '<td>'||To_Char(v_tablaTxtSum(1).Total_Liquidar_Ajuste,'99,999,999,990.00')||'&nbsp;</td>'||
                      '</tr>'||
                      '<tr>'||
                      '<td class="style1">Monto Aclarado:</td>'||
                      '<td>'||To_Char(v_tablaTxtSum(1).Monto_Aclarado,'99,999,999,990.00')||'&nbsp;</td>'||
                      '</tr>'||
                      '<tr>'||
                      '<td class="style1">Total Ajuste:</td>'||
                      '<td>'||To_Char(v_tablaTxtSum(1).Total_Ajuste,'99,999,999,990.00')||'&nbsp;</td>'||
                      '</tr>'||
                      '<tr>'||
                      '<td class="style1">Total a Liquidar:</td>'||
                      '<td>'||To_Char(v_tablaTxtSum(1).Total_Liquidar,'99,999,999,990.00')||'&nbsp;</td>'||
                      '</tr>'||
                      '<tr><td colspan="2">&nbsp;</td></tr>'||
                      '</table>'||
                      '<table style="font-family: Calibri; text-align :center; border-collapse: collapse; width: 100%; font-size:smaller;">'||
                      '<tr>'||
                      '<td class="style2">Fecha Solicitud</td>'||
                      '<td class="style2">Tipo Instruccion</td>'||
                      '<td class="style2">Importe Instruccion</td>'||
                      '<td class="style2">Cuenta Origen</td>'||
                      '<td class="style2">Cuenta Destino</td>'||
                      '<td class="style2">Entidad Origen</td>'||
                      '<td class="style2">Entidad Destino</td>'||
                      '</tr>';
        For i in v_tablaTxtDet.First .. v_tablaTxtDet.Last Loop
          c_log_file := c_log_file ||
                        '<tr>'||
                        '<td>'|| To_Char(v_tablaTxtDet(i).FECHA_SOLICITUD,'dd/mm/yyyy')||'&nbsp;</td>'||
                        '<td>'|| CASE v_tablaTxtDet(i).TIPO_INSTRUCCION
                                 WHEN 1 THEN 'Concentracion Referencias Validas'
                                 WHEN 2 THEN 'Concentracion Referencias no Validas'
                                 WHEN 5 THEN 'AJUSTES'
                                 ELSE        'N/A'
                                 END ||'&nbsp;</td>'||
                        '<td>'|| To_Char(v_tablaTxtDet(i).IMPORTE_INSTRUCCION,'99,999,999,990.00')||'&nbsp;</td>'||
                        '<td>'|| v_tablaTxtDet(i).CUENTA_ORIGEN||'&nbsp;</td>'||
                        '<td>'|| v_tablaTxtDet(i).CUENTA_DESTINO||'&nbsp;</td>';

         getNombreEntidad(v_tablaTxtDet(i).Entidad_Origen, v_desEntidad1, v_result);
         c_log_file := c_log_file || '<td>'|| v_desEntidad1||'&nbsp;</td>';

         getNombreEntidad(v_tablaTxtDet(i).Entidad_Destino, v_desEntidad1, v_result);
         c_log_file := c_log_file || '<td>'||v_desEntidad1||'&nbsp;</td></tr>';
        End Loop;
        c_log_file := c_log_file || '</table></body></html>';
        system.Sendmail_Pkg.send_email(
                                        p_recipient => v_lista_ok,
                                        p_subject => c_log_title,
                                        p_mensaje => c_log_file,
                                        p_sender => 'info@mail.tss2.gov.do',
                                        p_attachments => system.Sendmail_Pkg.ATTACHMENTS_LIST(c.other1_dir||v_tablaTxtEnc(1).NombreArchivo),
                                        pmensaje_retorno => v_mensaje_ret,
                                        pnumero_retorno => v_numero_ret,
                                        pvalidar_attachment => 'S'
                                       );
      End if;
      dbms_output.put_line('v_lista_ok:'||v_lista_ok||' v_mensaje_ret:'||v_mensaje_ret||' v_numero_ret:'||v_numero_ret);
    END Send_Email;

    /* --------------------------------------------------------------------------
     Autor   : Gregorio Herrera
     Fecha   : 10-Nov-2009
     Objetivo: Calcular el calculo de los codigos ASCII por caracteres para ser
               comparados con el valor del campo "digito control"
    */ --------------------------------------------------------------------------
    FUNCTION Calcular_Digito_Control_XML(p_valores tmptabla_det, p_indice PLS_INTEGER) RETURN BOOLEAN AS
      v_digito_control   PLS_INTEGER := p_valores(p_indice).DigitosControl;
      v_digito_calculado PLS_INTEGER := 0;
      v_cadena           VARCHAR2(32767);
      v_longitud         PLS_INTEGER;
    BEGIN
      v_cadena := p_valores(p_indice).NombreBeneficiario ||
                  p_valores(p_indice).IdentificacionBeneficiario ||
                  TRIM(To_Char(p_valores(p_indice).MontoADepositar,'9999999990.00')) ||
                  p_valores(p_indice).NumeroCuentaEstandard ||
                  p_valores(p_indice).TipoCuenta ||
                  p_valores(p_indice).ConceptoDetallado ||
                  p_valores(p_indice).InformAdicionalPago01 ||
                  p_valores(p_indice).InformAdicionalPago02;

      v_longitud := Length( v_cadena );

      For i in 1 .. v_longitud Loop
        v_digito_calculado := v_digito_calculado + ( ASCII( SUBSTR(v_cadena, i, 1) ) * 13 );
      End Loop;

      Return (v_digito_control = v_digito_calculado);
    EXCEPTION WHEN OTHERS THEN
      Return FALSE;
    END;

    /* --------------------------------------------------------------------------
     Autor   : Gregorio Herrera
     Fecha   : 13-Oct-2009
     Objetivo: Leer el archivo XML desde disco y validarlo
    */ --------------------------------------------------------------------------
    FUNCTION Validar_Estructura_XML(p_archivo varchar2) RETURN BOOLEAN AS
      v_conteo      INTEGER;
      v_parser      dbms_xmlparser.parser;
      v_file        dbms_xmldom.DOMDocument;
      v_listanodo   dbms_xmldom.DOMNodeList;
      v_nodo        dbms_xmldom.DOMNode;
      v_cadena      VARCHAR2(2000) := '';
      v_posicion    PLS_INTEGER := 1;
      v_total_monto NUMBER(13,2):= 0;
    BEGIN
      v_tablaEnc(v_posicion).NombreArchivo := p_archivo;
      v_tablaEnc(v_posicion).Secuencia     := v_sec_log;
      c_Log_File := '';

      -- Creamos un manejador de XML
      v_parser := dbms_xmlparser.newParser;
      dbms_xmlparser.setBaseDir(v_parser, c.archives_dir);

      dbms_xmlparser.parse(v_parser, p_archivo);
      v_file := dbms_xmlparser.getDocument(v_parser);

      -- Libero el recurso, ya no es necesario
      dbms_xmlparser.freeParser(v_parser);

      -- Obtengo un listado de los nodos "Archivo/Encabezado" utilizando la sintaxi XPATH.
      -- Esto debe devolverme un nodo "Archivo/Encabezado" por archivo.
      v_listanodo := dbms_xslprocessor.selectNodes(dbms_xmldom.makeNode(v_file),'/ARCHIVO/ENCABEZADO');

      -- Itero en los campos del Encabezado
      For cur_rec in 0 .. dbms_xmldom.getLength(v_listanodo) - 1 Loop
        v_nodo := dbms_xmldom.item(v_listanodo, cur_rec);

        -- Longitud del Nombre del Archivo
        If length(p_archivo) != 45 Then
          ManejoExcepciones('LongitudArchivo', v_sec_log);
          RETURN FALSE;
        End if;

        -- Tipo de transaccion
        Begin
          If (NVL(dbms_xslprocessor.valueOf(v_nodo,'TIPO'),' ') = ' ') then
            ManejoExcepciones('TipoNull', v_sec_log);
            RETURN FALSE;
          Else
            v_tablaEnc(v_posicion).Tipo := dbms_xslprocessor.valueOf(v_nodo,'TIPO');
          End if;
        Exception When Others Then
          ManejoExcepciones('TipoNull', v_sec_log);
          RETURN FALSE;
        End;

        -- Fecha de Generacion
        Begin
          If (NVL(dbms_xslprocessor.valueOf(v_nodo,'FECHAGENERACION'),' ') = ' ') then
            ManejoExcepciones('FechaGeneracionNull', v_sec_log);
            RETURN FALSE;
          Else
            v_cadena := To_Char(To_Date(dbms_xslprocessor.valueOf(v_nodo,'FECHAGENERACION'),'DD/MM/YYYY'),'DD/MM/YYYY');
            v_tablaEnc(v_posicion).FechaGeneracion := To_Date(dbms_xslprocessor.valueOf(v_nodo,'FECHAGENERACION'),'DD/MM/YYYY');
          End if;
        Exception When Others Then
          ManejoExcepciones('FechaGeneracionNull', v_sec_log);
          RETURN FALSE;
        End;

        -- Hora de Generacion
        Begin
          If (NVL(dbms_xslprocessor.valueOf(v_nodo,'HORAGENERACION'),' ') = ' ') then
            ManejoExcepciones('HoraGeneracion', v_sec_log);
            RETURN FALSE;
          Else
            v_cadena := To_Char(To_Date(dbms_xslprocessor.valueOf(v_nodo,'HORAGENERACION'),'HH24:MI:SS'),'HH24:MI:SS');
            v_tablaEnc(v_posicion).HoraGeneracion := To_Date(dbms_xslprocessor.valueOf(v_nodo,'HORAGENERACION'),'HH24:MI:SS');
          End if;
        Exception When Others Then
          ManejoExcepciones('HoraGeneracion', v_sec_log);
          RETURN FALSE;
        End;

        -- Nombre del Lote
        Begin
          If (NVL(dbms_xslprocessor.valueOf(v_nodo,'NOMBRELOTE'),0) = 0) then
            ManejoExcepciones('NombreLoteNull', v_sec_log);
            RETURN FALSE;
          Else
            v_cadena := To_Char(To_Number(dbms_xslprocessor.valueOf(v_nodo,'NOMBRELOTE')));

            -- Validar si el archivo ya esta registrado.
            If ExisteEncabezado(p_archivo, v_cadena) then
              ManejoExcepciones('Archivoexiste', v_sec_log);
              RETURN FALSE;
            End if;

            v_tablaEnc(v_posicion).NombreLote := To_Number(dbms_xslprocessor.valueOf(v_nodo,'NOMBRELOTE'));
          End if;
        Exception When Others Then
          ManejoExcepciones('NombreLoteNull', v_sec_log);
          RETURN FALSE;
        End;

        -- Concepto del Pago
        Begin
          If (NVL(dbms_xslprocessor.valueOf(v_nodo,'CONCEPTOPAGO'),' ') = ' ') then
            ManejoExcepciones('ConceptoPagoNull', v_sec_log);
            RETURN FALSE;
          Else
            v_tablaEnc(v_posicion).ConceptoPago := dbms_xslprocessor.valueOf(v_nodo,'CONCEPTOPAGO');
          End if;
        Exception When Others Then
          ManejoExcepciones('ConceptoPagoNull', v_sec_log);
          RETURN FALSE;
        End;

        -- Codigo BIC de la Entidad Deudora
        Begin
          If (NVL(dbms_xslprocessor.valueOf(v_nodo,'CODIGOBICENTIDADDB'),' ') = ' ') then
            ManejoExcepciones('CodBicDBInvalido', v_sec_log);
            RETURN FALSE;
          Else
            v_cadena := dbms_xslprocessor.valueOf(v_nodo,'CODIGOBICENTIDADDB');
            Select count(*)
            Into v_conteo
            From sfc_entidad_recaudadora_t e
            Where e.cod_bic_swift = v_cadena;

            If v_conteo = 0 Then
              ManejoExcepciones('CodBicDBInvalido', v_sec_log);
              RETURN FALSE;
            Elsif v_cadena != 'TESLDOS1XXX' Then
              ManejoExcepciones('CodBicDBInvalido', v_sec_log);
              RETURN FALSE;
            Elsif Length(v_cadena) != 11 Then
              ManejoExcepciones('CodBicDBInvalido', v_sec_log);
              RETURN FALSE;
            Else
              v_tablaEnc(v_posicion).CodigoBicEntidadDB := v_cadena;
            End if;
          End if;
        Exception When Others Then
          ManejoExcepciones('CodBicDBInvalido', v_sec_log);
          RETURN FALSE;
        End;

      -- Codigo BIC de la Entidad Acreditadora
      Begin
        If (NVL(dbms_xslprocessor.valueOf(v_nodo,'CODIGOBICENTIDADCR'),' ') = ' ') then
          ManejoExcepciones('CodBicCRInvalido', v_sec_log);
          RETURN FALSE;
        Else
          v_cadena := dbms_xslprocessor.valueOf(v_nodo,'CODIGOBICENTIDADCR');
          Select count(*)
          Into v_conteo
          From sfc_entidad_recaudadora_t e
          Where e.cod_bic_swift = v_cadena;

          If v_conteo = 0 Then
            ManejoExcepciones('CodBicCRInvalido', v_sec_log);
            RETURN FALSE;
          Elsif Length(v_cadena) != 11 Then
            ManejoExcepciones('CodBicCRInvalido', v_sec_log);
            RETURN FALSE;
          Else
            v_tablaEnc(v_posicion).CodigoBicEntidadCR := v_cadena;
          End if;
        End if;
      Exception When Others Then
        ManejoExcepciones('CodBicCRInvalido', v_sec_log);
        RETURN FALSE;
      End;

      -- Codigo TRN
      Begin
        If NOT IsTrnValido(NVL(dbms_xslprocessor.valueOf(v_nodo,'TRNOPCRLBTR'),' ')) then
          ManejoExcepciones('TRNNull', v_sec_log);
          RETURN FALSE;
        Else
          -- Ver si el TRN esta registrado para la fecha del sistema.
          v_cadena := dbms_xslprocessor.valueOf(v_nodo,'TRNOPCRLBTR');
          select count(*)
          into v_conteo
          from bc_encabezado_t ec
          where ec.trnopcrlbtr = v_cadena
            and trunc(ec.fechavalorcrlbtr) = trunc(sysdate);

          If v_conteo > 0 then
            ManejoExcepciones('TRNNull', v_sec_log);
            RETURN FALSE;
          Elsif Length(v_cadena) != 15 Then
            ManejoExcepciones('TRNNull', v_sec_log);
            RETURN FALSE;
          Elsif Not IsTrnValido(v_cadena) Then
            ManejoExcepciones('TRNNull', v_sec_log);
            RETURN FALSE;
          Else
            v_tablaEnc(v_posicion).TrnopCrLbtr := v_cadena;
          End if;
        End if;
      Exception When Others Then
        ManejoExcepciones('TRNNull', v_sec_log);
        RETURN FALSE;
      End;

      -- Vamos a validar los datos que vienen como parte del nombre del archivo
      If Not IsArchivoValido(p_archivo, v_tablaEnc(v_posicion).CodigoBicEntidadCR, v_tablaEnc(v_posicion).CodigoBicEntidadDB, v_tablaEnc(v_posicion).TrnoPcrLbtr) Then
        ManejoExcepciones('ArchivoInvalido', v_sec_log);
        RETURN FALSE;
      End if;

      -- Fecha del valor de la operacion cr¿dito global
      Begin
        If (NVL(dbms_xslprocessor.valueOf(v_nodo,'FECHAVALORCRLBTR'),' ') = ' ') then
          ManejoExcepciones('FechaValorNull', v_sec_log);
          RETURN FALSE;
        Else
          v_cadena := To_Char(To_Date(dbms_xslprocessor.valueOf(v_nodo,'FECHAVALORCRLBTR'),'DD/MM/YYYY'),'DD/MM/YYYY');
          v_tablaEnc(v_posicion).FechaValorCrLbtr := To_Date(dbms_xslprocessor.valueOf(v_nodo,'FECHAVALORCRLBTR'),'DD/MM/YYYY');

          If not IsFechaValorCrLbtr(v_tablaEnc(v_posicion).FechaValorCrLbtr) Then
            ManejoExcepciones('FechaValorNull', v_sec_log);
            RETURN FALSE;
          End if;
        End if;
      Exception When Others Then
        ManejoExcepciones('FechaValorNull', v_sec_log);
        RETURN FALSE;
      End;

      -- Total Registros Control
      Begin
        If (NVL(dbms_xslprocessor.valueOf(v_nodo,'TOTALREGISTROSCONTROL'),0) <= 0) then
          ManejoExcepciones('TotalRegistroNull', v_sec_log);
          RETURN FALSE;
        Else
          v_cadena := To_Char(To_Number(dbms_xslprocessor.valueOf(v_nodo,'TOTALREGISTROSCONTROL')));
          v_tablaEnc(v_posicion).TotalRegistrosControl := To_Number(dbms_xslprocessor.valueOf(v_nodo,'TOTALREGISTROSCONTROL'));
        End if;
      Exception When Others Then
        ManejoExcepciones('TotalRegistroNull', v_sec_log);
        RETURN FALSE;
      End;

      -- Total Montos Control
      Begin
        v_cadena := dbms_xslprocessor.valueOf(v_nodo,'TOTALMONTOSCONTROL');
        If (NVL(v_cadena,0) = 0) then
          ManejoExcepciones('TotalMontoNull', v_sec_log);
          RETURN FALSE;
        Elsif (NVL(v_cadena,0) < 0) then
          ManejoExcepciones('TotalMontoNull', v_sec_log);
          RETURN FALSE;
        Else
          v_tablaEnc(v_posicion).TotalMontosControl := To_Number(v_cadena);
        End if;
      Exception When Others Then
        ManejoExcepciones('TotalMontoNull', v_sec_log);
        RETURN FALSE;
      End;

      -- Moneda del Pago
      Begin
        If (NVL(dbms_xslprocessor.valueOf(v_nodo,'MONEDA'),' ') = ' ') then
          ManejoExcepciones('MonedaNull', v_sec_log);
          RETURN FALSE;
        Else
          v_tablaEnc(v_posicion).Moneda := dbms_xslprocessor.valueOf(v_nodo,'MONEDA');
        End if;
      Exception When Others Then
        ManejoExcepciones('MonedaNull', v_sec_log);
        RETURN FALSE;
      End;

      -- Informacion Adicional del Pago
      Begin
        If (NVL(dbms_xslprocessor.valueOf(v_nodo,'INFORMADICIONALENC01'),' ') = ' ') then
          ManejoExcepciones('InformacionAdicional', v_sec_log);
          RETURN FALSE;
        Else
          v_tablaEnc(v_posicion).InformAdicionalEnc01 := dbms_xslprocessor.valueOf(v_nodo,'INFORMADICIONALENC01');
        End if;
      Exception When Others Then
        ManejoExcepciones('InformacionAdicional', v_sec_log);
        RETURN FALSE;
      End;

      -- Estado del Archivo en el portal
      Begin
        If (NVL(dbms_xslprocessor.valueOf(v_nodo,'ESTADOARCHIVOENPORTAL'),' ') = ' ') then
          ManejoExcepciones('estadoArchivo', v_sec_log);
          RETURN FALSE;
        Else
          v_tablaEnc(v_posicion).EstadoArchivoEnPortal := dbms_xslprocessor.valueOf(v_nodo,'ESTADOARCHIVOENPORTAL');
        End if;
      Exception When Others Then
        ManejoExcepciones('estadoArchivo', v_sec_log);
        RETURN FALSE;
      End;

      -- Cantidad Descarga del Archivo en el portal
      Begin
        If (NVL(dbms_xslprocessor.valueOf(v_nodo,'CANTDESCARGASARCHIVO'),' ') = ' ') then
          ManejoExcepciones('cantidaddescarga', v_sec_log);
          RETURN FALSE;
        Else
          v_tablaEnc(v_posicion).CantDescargasArchivo := dbms_xslprocessor.valueOf(v_nodo,'CANTDESCARGASARCHIVO');
        End if;
      Exception When Others Then
        ManejoExcepciones('cantidaddescarga', v_sec_log);
        RETURN FALSE;
      End;

      -- Usuario Descarg¿ Archivo en el portal
      Begin
        If (NVL(dbms_xslprocessor.valueOf(v_nodo,'USUARIODESCARGOARCHIVO'),' ') = ' ') then
          ManejoExcepciones('usuariodescarga', v_sec_log);
          RETURN FALSE;
        Else
          v_tablaEnc(v_posicion).UsuarioDescargoArchivo := dbms_xslprocessor.valueOf(v_nodo,'USUARIODESCARGOARCHIVO');
        End if;
      Exception When Others Then
        ManejoExcepciones('usuariodescarga', v_sec_log);
        RETURN FALSE;
      End;
    End Loop;

    -- Obtengo un listado de los nodos "ARCHIVO/PAGO" utilizando la sintaxi XPATH.
    -- Esto debe devolverme una o varias listas de nodos "ARCHIVO/PAGO" por archivo.
    v_listanodo := dbms_xslprocessor.selectNodes(dbms_xmldom.makeNode(v_file),'/ARCHIVO/PAGO');
    v_posicion  := 0;

    -- Itero en los campos del detalle del pago
    For cur_rec in 0 .. dbms_xmldom.getLength(v_listanodo) - 1 Loop
      v_nodo     := dbms_xmldom.item(v_listanodo, cur_rec);
      v_posicion := v_posicion + 1;

      -- Nombre del lote, aqui me sirve como campo enlace (Primary Key)
      v_tablaDet(v_posicion).NombreLote := v_tablaEnc(1).NombreLote;

      -- Nombre del beneficiario
      Begin
        If (NVL(dbms_xslprocessor.valueOf(v_nodo,'NOMBREBENEFICIARIO'),' ') = ' ') then
          ManejoExcepciones('NomBeneficiario', v_sec_log);
          RETURN FALSE;
        Else
          v_tablaDet(v_posicion).NombreBeneficiario := dbms_xslprocessor.valueOf(v_nodo,'NOMBREBENEFICIARIO');
        End if;
      Exception When Others Then
        ManejoExcepciones('NomBeneficiario', v_sec_log);
        RETURN FALSE;
      End;

      -- Identificcion del beneficiario
      Begin
        If (NVL(dbms_xslprocessor.valueOf(v_nodo,'IDENTIFICACIONBENEFICIARIO'),' ') = ' ') then
          ManejoExcepciones('IdenBeneficiario', v_sec_log);
          RETURN FALSE;
        Else
          v_tablaDet(v_posicion).IdentificacionBeneficiario := dbms_xslprocessor.valueOf(v_nodo,'IDENTIFICACIONBENEFICIARIO');
        End if;
      Exception When Others Then
        ManejoExcepciones('IdenBeneficiario', v_sec_log);
        RETURN FALSE;
      End;

      -- Monto a Depositar
      Begin
        If (NVL(dbms_xslprocessor.valueOf(v_nodo,'MONTOADEPOSITAR'),0) = 0) then
          ManejoExcepciones('MontoDepositar', v_sec_log);
          RETURN FALSE;
        Elsif NVL(dbms_xslprocessor.valueOf(v_nodo,'MONTOADEPOSITAR'),0) < 0 Then
          ManejoExcepciones('MontoDepositar', v_sec_log);
          RETURN FALSE;
        Else
          v_cadena := To_Char(To_Number(dbms_xslprocessor.valueOf(v_nodo,'MONTOADEPOSITAR')));
          v_total_monto := v_total_monto + To_Number(dbms_xslprocessor.valueOf(v_nodo,'MONTOADEPOSITAR'));
          v_tablaDet(v_posicion).MontoADepositar := To_Number(dbms_xslprocessor.valueOf(v_nodo,'MONTOADEPOSITAR'));
        End if;
      Exception When Others Then
        ManejoExcepciones('MontoDepositar', v_sec_log);
        RETURN FALSE;
      End;

      -- Numero de cuenta estandard
      Begin
        If NOT IsValidNroCtaEstandarRd(NVL(dbms_xslprocessor.valueOf(v_nodo,'NUMEROCUENTAESTANDARD'),'0')) Then
          ManejoExcepciones('Nrocuenta', v_sec_log);
          RETURN FALSE;
        Elsif Not IsValidNroCtaestandarRd(dbms_xslprocessor.valueOf(v_nodo,'NUMEROCUENTAESTANDARD')) then
          ManejoExcepciones('Nrocuenta', v_sec_log);
          RETURN FALSE;
        Else
          v_tablaDet(v_posicion).NumeroCuentaEstandard := dbms_xslprocessor.valueOf(v_nodo,'NUMEROCUENTAESTANDARD');
        End if;
      Exception When Others Then
        ManejoExcepciones('Nrocuenta', v_sec_log);
        RETURN FALSE;
      End;

      -- Tipo de Cuenta del beneficiario
      Begin
        If (NVL(dbms_xslprocessor.valueOf(v_nodo,'TIPOCUENTA'),' ') = ' ') then
          ManejoExcepciones('TipoCuenta', v_sec_log);
          RETURN FALSE;
        Else
          v_tablaDet(v_posicion).TipoCuenta := dbms_xslprocessor.valueOf(v_nodo,'TIPOCUENTA');
        End if;
      Exception When Others Then
        ManejoExcepciones('TipoCuenta', v_sec_log);
        RETURN FALSE;
      End;

      -- Concepto Detallado
      Begin
        If (NVL(dbms_xslprocessor.valueOf(v_nodo,'CONCEPTODETALLADO'),' ') = ' ') then
          ManejoExcepciones('ConceptoDetalle', v_sec_log);
          RETURN FALSE;
        Else
          v_tablaDet(v_posicion).ConceptoDetallado := dbms_xslprocessor.valueOf(v_nodo,'CONCEPTODETALLADO');
        End if;
      Exception When Others Then
        ManejoExcepciones('ConceptoDetalle', v_sec_log);
        RETURN FALSE;
      End;

      -- Informacion Adicional 01 del Pago
      Begin
        If (NVL(dbms_xslprocessor.valueOf(v_nodo,'INFORMADICIONALPAGO01'),' ') = ' ') then
          ManejoExcepciones('InformAdicionalPago01', v_sec_log);
          RETURN FALSE;
        Else
          v_tablaDet(v_posicion).InformAdicionalPago01 := dbms_xslprocessor.valueOf(v_nodo,'INFORMADICIONALPAGO01');
        End if;
      Exception When Others Then
        ManejoExcepciones('InformAdicionalPago01', v_sec_log);
        RETURN FALSE;
      End;

      -- Informacion Adicional 02 del Pago
      Begin
        If (NVL(dbms_xslprocessor.valueOf(v_nodo,'INFORMADICIONALPAGO02'),' ') = ' ') then
          ManejoExcepciones('InformAdicionalPago02', v_sec_log);
          RETURN FALSE;
        Else
          v_tablaDet(v_posicion).InformAdicionalPago02 := dbms_xslprocessor.valueOf(v_nodo,'INFORMADICIONALPAGO02');
        End if;
      Exception When Others Then
        ManejoExcepciones('InformAdicionalPago02', v_sec_log);
        RETURN FALSE;
      End;

      -- Numero de d¿gito control
      Begin
        If NVL(dbms_xslprocessor.valueOf(v_nodo,'DIGITOSCONTROL'),'0') = '0' Then
          ManejoExcepciones('DigitoControl', v_sec_log);
          RETURN FALSE;
        Else
          v_tablaDet(v_posicion).DigitosControl := dbms_xslprocessor.valueOf(v_nodo,'DIGITOSCONTROL');
        End if;
      Exception When Others Then
        ManejoExcepciones('DigitoControl', v_sec_log);
        RETURN FALSE;
      End;

      -- Para calcular el digito control
      If Not Calcular_Digito_Control_XML(v_tablaDet, v_posicion) Then
        ManejoExcepciones('DigitoControl', v_sec_log);
        RETURN FALSE;
      End if;
    End Loop;

    -- Para saber si alguna de las tabla no contiene registros
    -- Al devolver true, rompo la ejecucion y provoco que el proceso que invoca la llamada
    -- maneje esta exception y no permito que la logica se desvirtue
    If v_tablaEnc.Count = 0 Or v_tablaDet.Count = 0 Then
      RETURN TRUE;
    End If;

    -- Para comprobar que vinieron la cantidad de registros PAGOS que dice el encabezado
    If v_tablaEnc(1).TotalRegistrosControl != v_tablaDet.Count Then
       ManejoExcepciones('TotalRegistroNull', v_sec_log);
       RETURN FALSE;
    End if;

    -- Para comprobar que la sumatoria de los montos en los registros PAGOS coincide con lo que dice el encabezado
    If v_tablaEnc(1).TotalMontosControl != NVL(v_total_monto,0) Then
       ManejoExcepciones('TotalMontoNull', v_sec_log);
       RETURN FALSE;
    End if;

    RETURN TRUE;
  END Validar_Estructura_XML;

  /* --------------------------------------------------------------------------
   Autor   : Gregorio Herrera
   Fecha   : 13-Oct-2009
   Objetivo: Leer el archivo TXT desde disco y validarlo
  */ --------------------------------------------------------------------------
  FUNCTION Validar_Estructura_TXT(p_archivo varchar2) RETURN BOOLEAN AS
    v_file           UTL_FILE.FILE_TYPE;
    v_cadena         VARCHAR2(2000) := '';
    v_dummy          VARCHAR2(1000) := '';
    v_posicion       PLS_INTEGER    := 1;
    v_total_monto    NUMBER(13,2)   := 0;
    v_total_aclarado NUMBER(13,2)   := 0;
    v_total_ajuste   NUMBER(13,2)   := 0;
    v_nombre_entidad VARCHAR2(100);
  BEGIN
    v_tablaTxtEnc(v_posicion).NombreArchivo := p_archivo;
    v_tablaTxtEnc(v_posicion).Secuencia     := v_sec_log;
    v_tablaTxtEnc(v_posicion).Tipo_Registro := 'E';
    c_Log_File := '';

    -- Validar si el archivo ya esta registrado.
    If ExisteEncabezado(p_archivo, null) then
      ManejoExcepciones('Archivoexiste', v_sec_log);
      RETURN FALSE;
    End if;

    -- Leemos el archivo de concentracion
    v_file := UTL_FILE.FOPEN(c.archives_dir, p_archivo, 'r');
    Loop
      Begin
        utl_file.get_line(v_file, v_cadena);

        -- Longitud de linea incorrecta
        If length(v_cadena) != 106 Then
          ManejoExcepciones('LongitudLinea', v_sec_log);
          RETURN FALSE;
        End if;

        -- Tipo de Linea Incorrecta
        If Instr('EDS', Substr(v_cadena, 1, 1)) = 0 Then
          ManejoExcepciones('TipoLinea', v_sec_log);
          RETURN FALSE;
        End if;

        -- Procesamos el Registro Encabezado
        If Substr(v_cadena, 1, 1) = 'E' Then
          -- Validamos el codigo del proceso
          If Substr(v_cadena,2,2) != 'RE' Then
            ManejoExcepciones('CodigoProceso', v_sec_log);
            RETURN FALSE;
          Else
            v_tablaTxtEnc(1).Proceso := Substr(v_cadena,2,2);
          End if;

          -- Validamos el codigo del sub-proceso
          If Substr(v_cadena,4,2) != 'NC' Then
            ManejoExcepciones('CodigoSubProceso', v_sec_log);
            RETURN FALSE;
          Else
            v_tablaTxtEnc(1).Sub_Proceso := Substr(v_cadena,4,2);
          End if;

          -- Validamos el valor constante '106' para el tama¿o del registro
          If Substr(v_cadena,6,3) != '106' Then
            ManejoExcepciones('TamanoRegistro', v_sec_log);
            RETURN FALSE;
          Else
            v_tablaTxtEnc(1).Tamano_Registro := Substr(v_cadena,6,3);
          End if;

          -- Validamos el valor constante '04' para el tipo de entidad receptora
          If Substr(v_cadena,9,2) != '04' Then
            ManejoExcepciones('TipoEntidadRecaudadora', v_sec_log);
            RETURN FALSE;
          Else
            v_tablaTxtEnc(1).Tipo_Entidad_Receptora := Substr(v_cadena,9,2);
          End if;

          -- Validamos la clave de la entidad receptora
          getNombreEntidad(Substr(v_cadena,11,2), v_dummy, v_nombre_entidad);
          If v_nombre_entidad != '0' Then
            RETURN FALSE;
          Else
            v_tablaTxtEnc(1).Entidad_Mov_Fondos := Substr(v_cadena,11,2);
          End if;

          -- Validamos la fecha de transmision
          Begin
            v_dummy := To_Char(To_Date(Substr(p_archivo,9,8),'ddmmyyyy'),'ddmmyyyy');
            v_tablaTxtEnc(v_posicion).FechaTransmision := To_Date(Substr(p_archivo,9,8),'dd/mm/yyyy');
          Exception when others then
            ManejoExcepciones('FechaTransmision', v_sec_log);
            RETURN FALSE;
          End;

          -- Validamos el n¿mero de archivo
          Begin
            v_dummy := To_Char(To_number(Substr(p_archivo,17,6)));
            v_tablaTxtEnc(v_posicion).Nro_Archivo := Substr(p_archivo,17,6);
          Exception when others then
            ManejoExcepciones('NumeroArchivo', v_sec_log);
            RETURN FALSE;
          End;

        -- Procesamos los registros Detalles
        Elsif Substr(v_cadena, 1, 1) = 'D' Then
          v_tablaTxtDet(v_posicion).Secuencia     := v_sec_log;
          v_tablaTxtDet(v_posicion).Tipo_Registro := 'D';

          -- Validamos el codigo del proceso
          Begin
            v_dummy := To_Char(To_Date(Substr(v_cadena,2,8),'ddmmyyyy'),'ddmmyyyy');
            v_tablaTxtDet(v_posicion).Fecha_Solicitud := To_Date(Substr(v_cadena,2,8),'dd/mm/yyyy');
          Exception when others then
            ManejoExcepciones('FechaSolicitud', v_sec_log);
            RETURN FALSE;
          End;

          -- Validamos el concepto de la instruccion de concentracion
          If Instr('125',Trim(Substr(v_cadena,10,3))) = 0 Then
            ManejoExcepciones('InstruccionConcentracion', v_sec_log);
            RETURN FALSE;
          Else
            v_tablaTxtDet(v_posicion).Tipo_Instruccion := Substr(v_cadena,10,3);
          End if;

          -- Validamos el Importe de la instruccion de la concentracion
          If Length(Trim(Substr(v_cadena,13,25))) != 25 Then
            ManejoExcepciones('ImporteConcentracion', v_sec_log);
            RETURN FALSE;
          Else
            Begin
              v_dummy := to_char(to_number(substr(v_cadena,13,25)));
              v_tablaTxtDet(v_posicion).Importe_Instruccion := To_Number(substr(v_cadena,13,25));
              -- Para sumar por separado los tres tipos de importes
              If TRIM(v_tablaTxtDet(v_posicion).Tipo_Instruccion) = '1' Then
                v_total_monto := v_total_monto + v_tablaTxtDet(v_posicion).Importe_Instruccion;
              ElsIf TRIM(v_tablaTxtDet(v_posicion).Tipo_Instruccion) = '2' Then
                v_total_aclarado := v_total_aclarado + v_tablaTxtDet(v_posicion).Importe_Instruccion;
              ElsIf TRIM(v_tablaTxtDet(v_posicion).Tipo_Instruccion) = '5' Then
                v_total_ajuste := v_total_ajuste + v_tablaTxtDet(v_posicion).Importe_Instruccion;
              End if;
            Exception when others then
              ManejoExcepciones('ImporteConcentracion', v_sec_log);
              RETURN FALSE;
            End;
          End if;

          -- Validamos el Numero de Cuenta origen de la concentracion
          Begin
            v_dummy := to_char(to_number(substr(v_cadena,38,25)));
            v_tablaTxtDet(v_posicion).Cuenta_Origen := To_Number(substr(v_cadena,38,25));
          Exception when others then
            ManejoExcepciones('CuentaOrigen', v_sec_log);
            RETURN FALSE;
          End;

          -- Validamos el Numero de Cuenta destino de la concentracion
          Begin
            v_dummy := to_char(to_number(substr(v_cadena,63,25)));
            v_tablaTxtDet(v_posicion).Cuenta_Destino := To_Number(substr(v_cadena,63,25));
          Exception when others then
            ManejoExcepciones('CuentaDestino', v_sec_log);
            RETURN FALSE;
          End;

          -- Validamos la Clave del tipo de entidad que se le solicita que depositen los fondos
          Begin
            v_dummy := to_char(to_number(substr(v_cadena,88,2)));
            v_tablaTxtDet(v_posicion).Tipo_Entidad_Destino := To_Number(substr(v_cadena,88,2));
          Exception when others then
            ManejoExcepciones('ClaveTipoEntidadDeposita', v_sec_log);
            RETURN FALSE;
          End;

          -- Validamos la clave de la entidad que solicita los fondos (siempre debe ser el Banco Central)
          If Not EsBancoCentral(Substr(v_cadena,90,2)) Then
            ManejoExcepciones('ClaveEntidadSolicita', v_sec_log);
            RETURN FALSE;
          Else
            v_tablaTxtDet(v_posicion).Entidad_Destino := Substr(v_cadena,90,2);
          End if;

          -- Validamos la Clave del tipo de entidad que Entreg¿ los Fondos
          Begin
            v_dummy := to_char(to_number(substr(v_cadena,92,2)));
            v_tablaTxtDet(v_posicion).Tipo_Entidad_Origen := To_Number(substr(v_cadena,92,2));
          Exception when others then
            ManejoExcepciones('ClaveEntidadEntrega', v_sec_log);
            RETURN FALSE;
          End;

          -- Validamos la clave de la entidad receptora.
          -- En caso de haber error en el codigo de la entidad es validado con el codigo 35
          -- Por asunto de reutilizaacion
          getNombreEntidad(Substr(v_cadena,94,2), v_dummy, v_nombre_entidad);
          If v_nombre_entidad != '0' Then
            RETURN FALSE;
          Else
            v_tablaTxtDet(v_posicion).Entidad_Origen := Substr(v_cadena,94,2);
          End if;
          v_posicion := v_posicion + 1;
        -- Procesamos el registro Sumario
        Elsif Substr(v_cadena, 1, 1) = 'S' Then
          v_tablaTxtSum(1).Secuencia     := v_sec_log;
          v_tablaTxtSum(1).Tipo_Registro := 'S';

          -- Validamos el numero de registros que indica el archivo contra la cantidad de lineas
          If Length(Trim(Substr(v_cadena,2,5))) != 5 Then
            ManejoExcepciones('NumeroRegistros', v_sec_log);
            RETURN FALSE;
          Else
            Begin
              v_dummy := to_char(to_number(Substr(v_cadena,2,5)));
              If to_number(Substr(v_cadena,2,5)) != (v_tablaTxtEnc.Count + v_tablaTxtDet.Count + v_tablaTxtSum.Count) Then
                ManejoExcepciones('NumeroRegistros', v_sec_log);
                RETURN FALSE;
              Else
                v_tablaTxtSum(1).Numero_Registros := To_Number(Substr(v_cadena,2,5));
              End if;
            Exception When Others Then
              ManejoExcepciones('NumeroRegistros', v_sec_log);
              RETURN FALSE;
            End;
          End if;

/*          -- Validamos el total a liquidar sin ajuste que indica el archivo contra los montos del detalle
          If Length(Trim(Substr(v_cadena,7,25))) != 25 Then
            ManejoExcepciones('TotalLiquidarAjuste', v_sec_log);
            RETURN FALSE;
          Else
*/            Begin
              v_dummy := to_char(to_number(Substr(v_cadena,7,25)));
/*              If to_number(Substr(v_cadena,7,25)) != (v_total_monto) Then
                ManejoExcepciones('TotalLiquidarAjuste', v_sec_log);
                RETURN FALSE;
              Else
*/                v_tablaTxtSum(1).Total_Liquidar_Ajuste := To_Number(Substr(v_cadena,7,25));
--              End if;
            Exception When Others Then
              ManejoExcepciones('TotalLiquidarAjuste', v_sec_log);
              RETURN FALSE;
            End;
--          End if;

          -- Validamos el monto aclarado que indica el archivo
/*          If Length(Trim(Substr(v_cadena,32,25))) != 25 Then
            ManejoExcepciones('MontoAclarado', v_sec_log);
            RETURN FALSE;
          Else
*/            Begin
              v_dummy := to_char(to_number(Substr(v_cadena,32,25)));
/*              If to_number(Substr(v_cadena,32,25)) != (v_total_aclarado) Then
                ManejoExcepciones('MontoAclarado', v_sec_log);
                RETURN FALSE;
              Else
*/                v_tablaTxtSum(1).Monto_Aclarado := To_Number(Substr(v_cadena,32,25));
--              End if;
            Exception When Others Then
              ManejoExcepciones('MontoAclarado', v_sec_log);
              RETURN FALSE;
            End;
--          End if;

          -- Validamos el Total Ajuste que indica el archivo
/*          If Length(Trim(Substr(v_cadena,57,25))) != 25 Then
            ManejoExcepciones('TotalAjustes', v_sec_log);
            RETURN FALSE;
          Else
*/            Begin
              v_dummy := to_char(to_number(Substr(v_cadena,57,25)));
/*              If to_number(Substr(v_cadena,57,25)) != (v_total_ajuste) Then
                ManejoExcepciones('TotalAjustes', v_sec_log);
                RETURN FALSE;
              Else
*/                v_tablaTxtSum(1).Total_Ajuste := To_Number(Substr(v_cadena,57,25));
--              End if;
            Exception When Others Then
              ManejoExcepciones('TotalAjustes', v_sec_log);
              RETURN FALSE;
            End;
--          End if;

          -- Validamos el total a liquidar que indica el archivo contra los montos del detalle
/*          If Length(Trim(Substr(v_cadena,82,25))) != 25 Then
            ManejoExcepciones('TotalLiquidar', v_sec_log);
            RETURN FALSE;
          Else
*/            Begin
              v_dummy := to_char(to_number(Substr(v_cadena,82,25)));
/*              If to_number(Substr(v_cadena,82,25)) != (v_tablaTxtSum(1).Total_Liquidar_Ajuste + v_tablaTxtSum(1).Monto_Aclarado + v_tablaTxtSum(1).Total_Ajuste) Then
                ManejoExcepciones('TotalLiquidar', v_sec_log);
                RETURN FALSE;
              Else
*/                v_tablaTxtSum(1).Total_Liquidar := To_Number(Substr(v_cadena,82,25));
--              End if;
            Exception When Others Then
              ManejoExcepciones('TotalLiquidar', v_sec_log);
              RETURN FALSE;
            End;
--          End if;
        End if;
      Exception When No_Data_Found Then
        Exit;
      End;
    End Loop;

    RETURN TRUE;
  END Validar_Estructura_TXT;

  /* --------------------------------------------------------------------------
   Autor   : Gregorio Herrera
   Fecha   : 12-Ene-2010
   Objetivo: Actualizar el campo ID_ERROR de la vista para reflejar el resultado de la corrida.
  */ --------------------------------------------------------------------------
  Procedure ActualizarVista(p_id_error in varchar2) Is
  Begin
    Update suirplus.bc_archivos_tss_t x
    set x.n_id_error = p_id_error
    Where x.n_num_control = v_num_control
      And x.n_id_error is null;
    Commit;
  End;

  /* --------------------------------------------------------------------------
   Autor   : Gregorio Herrera
   Fecha   : 16-Nov-2009
   Objetivo: Insertar en las tablas BC_ENCABEZADOS_T, BC_CO_ENCABEZADOS_T,
             BC_DETALLE_T, BC_CO_DETALLE_T y BC_CO_SUMARIO_T dependiendo si es un archivo
             de Liquidaci¿n o un archivo de Concentaci¿n.
  */ --------------------------------------------------------------------------
  Procedure InsertLogArchivo(p_nombreArchivo in varchar2, p_result out bc_archivo_msg_t.descripcion%TYPE) Is
  Begin
    --El archivo es una liquidaci¿n
    If Substr(p_nombreArchivo,20,2) IN ('LQ','RV') Then
      --Insertamos en el encabezado
      Insert into Suirplus.Bc_Encabezado_t
      (nombrearchivo,
       tipo,
       fechageneracion,
       horageneracion,
       nombrelote,
       conceptopago,
       codigobicentidaddb,
       codigobicentidadcr,
       trnopcrlbtr,
       fechavalorcrlbtr,
       totalregistroscontrol,
       totalmontoscontrol,
       moneda,
       informadicionalenc01,
       estadoarchivoenportal,
       cantdescargasarchivo,
       usuariodescargoarchivo,
       archivo_xml,
       secuencia,
       archivo_xml_enc,
       id_error
      )
      Values
      (
       v_tablaEnc(1).NombreArchivo,
       v_tablaEnc(1).tipo,
       v_tablaEnc(1).fechageneracion,
       v_tablaEnc(1).horageneracion,
       v_tablaEnc(1).nombrelote,
       v_tablaEnc(1).conceptopago,
       v_tablaEnc(1).codigobicentidaddb,
       v_tablaEnc(1).codigobicentidadcr,
       v_tablaEnc(1).trnopcrlbtr,
       v_tablaEnc(1).fechavalorcrlbtr,
       v_tablaEnc(1).totalregistroscontrol,
       v_tablaEnc(1).totalmontoscontrol,
       v_tablaEnc(1).moneda,
       v_tablaEnc(1).informadicionalenc01,
       v_tablaEnc(1).estadoarchivoenportal,
       v_tablaEnc(1).cantdescargasarchivo,
       v_tablaEnc(1).usuariodescargoarchivo,
       v_tablaEnc(1).archivo_xml,
       v_tablaEnc(1).secuencia,
       v_tablaEnc(1).archivo_xml_enc,
       v_tablaEnc(1).id_error
      );

      --Insertamos en el detalle
      For i in v_tablaDet.First .. v_tablaDet.Last Loop
        Insert into bc_detalle_t
        (
         nombrelote,
         nombrebeneficiario,
         identificacionbeneficiario,
         montoadepositar,
         numerocuentaestandard,
         tipocuenta,
         conceptodetallado,
         informadicionalpago01,
         informadicionalpago02,
         digitoscontrol,
         secuencia
        )
        Values
        (
         v_tablaDet(i).nombrelote,
         v_tablaDet(i).nombrebeneficiario,
         v_tablaDet(i).identificacionbeneficiario,
         v_tablaDet(i).montoadepositar,
         v_tablaDet(i).numerocuentaestandard,
         v_tablaDet(i).tipocuenta,
         v_tablaDet(i).conceptodetallado,
         v_tablaDet(i).informadicionalpago01,
         v_tablaDet(i).informadicionalpago02,
         v_tablaDet(i).digitoscontrol,
         v_tablaEnc(1).secuencia
        );
      End loop;
      Commit;
      p_result := '0';
    Else
      --Insertamos en el encabezado
      Insert into Suirplus.Bc_co_Encabezado_t
      (secuencia,
       nombrearchivo,
       proceso,
       sub_proceso,
       tipo_entidad_receptora,
       entidad_mov_fondos,
       fechatransmision,
       nro_archivo,
       tipo_registro,
       tamano_registro,
       Archivo_Txt,
       Archivo_Txt_Enc,
       Id_Error
      )
      Values
      (
       v_tablaTxtEnc(1).Secuencia,
       v_tablaTxtEnc(1).NombreArchivo,
       v_tablaTxtEnc(1).proceso,
       v_tablaTxtEnc(1).sub_proceso,
       v_tablaTxtEnc(1).tipo_entidad_receptora,
       v_tablaTxtEnc(1).entidad_mov_fondos,
       v_tablaTxtEnc(1).fechatransmision,
       v_tablaTxtEnc(1).nro_archivo,
       v_tablaTxtEnc(1).tipo_registro,
       v_tablaTxtEnc(1).tamano_registro,
       v_tablaTxtEnc(1).archivo_txt,
       v_tablaTxtEnc(1).archivo_txt_enc,
       v_tablaTxtEnc(1).id_error
      );

      --Insertamos en el detalle
      For i in v_tablaTxtDet.First .. v_tablaTxtDet.Last Loop
        Insert into bc_co_detalle_t
        (
         secuencia,
         tipo_registro,
         fecha_solicitud,
         tipo_instruccion,
         importe_instruccion,
         cuenta_origen,
         cuenta_destino,
         tipo_entidad_destino,
         entidad_destino,
         tipo_entidad_origen,
         entidad_origen
        )
        Values
        (
         v_tablaTxtDet(i).secuencia,
         v_tablaTxtDet(i).tipo_registro,
         v_tablaTxtDet(i).fecha_solicitud,
         v_tablaTxtDet(i).tipo_instruccion,
         v_tablaTxtDet(i).importe_instruccion,
         v_tablaTxtDet(i).cuenta_origen,
         v_tablaTxtDet(i).cuenta_destino,
         v_tablaTxtDet(i).tipo_entidad_destino,
         v_tablaTxtDet(i).entidad_destino,
         v_tablaTxtDet(i).tipo_entidad_destino,
         v_tablaTxtDet(i).entidad_origen
        );
      End loop;

      --Insertamos en el Sumario
      Insert into Suirplus.Bc_co_Sumario_t
      (secuencia,
       tipo_registro,
       numero_registros,
       total_liquidar_ajuste,
       monto_aclarado,
       total_ajuste,
       total_liquidar
      )
      Values
      (
       v_tablaTxtSum(1).Secuencia,
       v_tablaTxtSum(1).Tipo_Registro,
       v_tablaTxtSum(1).Numero_Registros,
       v_tablaTxtSum(1).Total_Liquidar_Ajuste,
       v_tablaTxtSum(1).Monto_Aclarado,
       v_tablaTxtSum(1).Total_ajuste,
       v_tablaTxtSum(1).Total_Liquidar
      );

      Commit;
      p_result := '0';
    End if;
  Exception When Others Then
   Declare
     v_archivolog bc_log_archivo_t%rowtype;
   Begin
    c_Log_File := 'Error insertando log en archivo = '||p_NombreArchivo||chr(13)||chr(10)||sqlerrm;
    p_result := '-1';

    v_archivolog.estatus       := 'ER';
    v_archivolog.ocurrido      := 'EN';
    v_archivolog.Fechaerror    := sysdate;
    v_archivolog.mensaje_id    := 52;
    v_archivolog.errordb       := 'Error insertando log en archivo. '||sqlerrm;
    v_archivolog.secuencia_log := v_sec_log;

    MarcarArchivo(v_archivolog);
   End;
  End InsertLogArchivo;

  /* --------------------------------------------------------------------------
  Autor   : Gregorio Herrera
  Fecha   : 13-Oct-2009
  Objetivo: Leer el archivo XML desde disco y llenar las tabla Temporales
  */ --------------------------------------------------------------------------
  Procedure Llenar_Estructura_XML(p_archivo varchar2) AS
    v_parser      dbms_xmlparser.parser;
    v_file        dbms_xmldom.DOMDocument;
    v_listanodo   dbms_xmldom.DOMNodeList;
    v_nodo        dbms_xmldom.DOMNode;
    v_posicion    PLS_INTEGER := 1;
  BEGIN
    v_tablaEnc(v_posicion).NombreArchivo := p_archivo;
    v_tablaEnc(v_posicion).Secuencia     := v_sec_log;
    c_Log_File := '';

    -- Creamos un manejador de XML
    v_parser := dbms_xmlparser.newParser;
    dbms_xmlparser.setBaseDir(v_parser, c.archives_dir);

    dbms_xmlparser.parse(v_parser, p_archivo);
    v_file := dbms_xmlparser.getDocument(v_parser);

    -- Libero el recurso, ya no es necesario
    dbms_xmlparser.freeParser(v_parser);

    -- Obtengo un listado de los nodos "Archivo/Encabezado" utilizando la sintaxi XPATH.
    -- Esto debe devolverme un nodo "Archivo/Encabezado" por archivo.
    v_listanodo := dbms_xslprocessor.selectNodes(dbms_xmldom.makeNode(v_file),'/ARCHIVO/ENCABEZADO');

    -- Itero en los campos del Encabezado
    For cur_rec in 0 .. dbms_xmldom.getLength(v_listanodo) - 1 Loop
      v_nodo := dbms_xmldom.item(v_listanodo, cur_rec);

      v_tablaEnc(v_posicion).Tipo                   := dbms_xslprocessor.valueOf(v_nodo,'TIPO');
      v_tablaEnc(v_posicion).FechaGeneracion        := To_Date(dbms_xslprocessor.valueOf(v_nodo,'FECHAGENERACION'),'DD/MM/YYYY');
      v_tablaEnc(v_posicion).HoraGeneracion         := To_Date(dbms_xslprocessor.valueOf(v_nodo,'HORAGENERACION'),'HH24:MI:SS');
      v_tablaEnc(v_posicion).NombreLote             := To_Number(dbms_xslprocessor.valueOf(v_nodo,'NOMBRELOTE'));
      v_tablaEnc(v_posicion).ConceptoPago           := dbms_xslprocessor.valueOf(v_nodo,'CONCEPTOPAGO');
      v_tablaEnc(v_posicion).CodigoBicEntidadDB     := dbms_xslprocessor.valueOf(v_nodo,'CODIGOBICENTIDADDB');
      v_tablaEnc(v_posicion).CodigoBicEntidadCR     := dbms_xslprocessor.valueOf(v_nodo,'CODIGOBICENTIDADCR');
      v_tablaEnc(v_posicion).TrnopCrLbtr            := dbms_xslprocessor.valueOf(v_nodo,'TRNOPCRLBTR');
      v_tablaEnc(v_posicion).FechaValorCrLbtr       := To_Date(dbms_xslprocessor.valueOf(v_nodo,'FECHAVALORCRLBTR'),'DD/MM/YYYY');
      v_tablaEnc(v_posicion).TotalRegistrosControl  := To_Number(dbms_xslprocessor.valueOf(v_nodo,'TOTALREGISTROSCONTROL'));
      v_tablaEnc(v_posicion).TotalMontosControl     := To_Number(dbms_xslprocessor.valueOf(v_nodo,'TOTALMONTOSCONTROL'));
      v_tablaEnc(v_posicion).Moneda                 := dbms_xslprocessor.valueOf(v_nodo,'MONEDA');
      v_tablaEnc(v_posicion).InformAdicionalEnc01   := dbms_xslprocessor.valueOf(v_nodo,'INFORMADICIONALENC01');
      v_tablaEnc(v_posicion).EstadoArchivoEnPortal  := dbms_xslprocessor.valueOf(v_nodo,'ESTADOARCHIVOENPORTAL');
      v_tablaEnc(v_posicion).CantDescargasArchivo   := dbms_xslprocessor.valueOf(v_nodo,'CANTDESCARGASARCHIVO');
      v_tablaEnc(v_posicion).UsuarioDescargoArchivo := dbms_xslprocessor.valueOf(v_nodo,'USUARIODESCARGOARCHIVO');

      -- Obtengo un listado de los nodos "ARCHIVO/PAGO" utilizando la sintaxi XPATH.
      -- Esto debe devolverme una o varias listas de nodos "ARCHIVO/PAGO" por archivo.
      v_listanodo := dbms_xslprocessor.selectNodes(dbms_xmldom.makeNode(v_file),'/ARCHIVO/PAGO');
      v_posicion  := 0;

      -- Itero en los campos del detalle del pago
      For cur_rec in 0 .. dbms_xmldom.getLength(v_listanodo) - 1 Loop
        v_nodo     := dbms_xmldom.item(v_listanodo, cur_rec);
        v_posicion := v_posicion + 1;

        -- Nombre del lote, aqui me sirve como campo enlace (Primary Key)
        v_tablaDet(v_posicion).NombreLote                 := v_tablaEnc(1).NombreLote;
        v_tablaDet(v_posicion).NombreBeneficiario         := dbms_xslprocessor.valueOf(v_nodo,'NOMBREBENEFICIARIO');
        v_tablaDet(v_posicion).IdentificacionBeneficiario := dbms_xslprocessor.valueOf(v_nodo,'IDENTIFICACIONBENEFICIARIO');
        v_tablaDet(v_posicion).MontoADepositar            := To_Number(dbms_xslprocessor.valueOf(v_nodo,'MONTOADEPOSITAR'));
        v_tablaDet(v_posicion).NumeroCuentaEstandard      := dbms_xslprocessor.valueOf(v_nodo,'NUMEROCUENTAESTANDARD');
        v_tablaDet(v_posicion).TipoCuenta                 := dbms_xslprocessor.valueOf(v_nodo,'TIPOCUENTA');
        v_tablaDet(v_posicion).ConceptoDetallado          := dbms_xslprocessor.valueOf(v_nodo,'CONCEPTODETALLADO');
        v_tablaDet(v_posicion).InformAdicionalPago01      := dbms_xslprocessor.valueOf(v_nodo,'INFORMADICIONALPAGO01');
        v_tablaDet(v_posicion).InformAdicionalPago02      := dbms_xslprocessor.valueOf(v_nodo,'INFORMADICIONALPAGO02');
        v_tablaDet(v_posicion).DigitosControl             := dbms_xslprocessor.valueOf(v_nodo,'DIGITOSCONTROL');
      End Loop;
    End Loop;
  Exception When Others Then
    v_tablaEnc.Delete();
    v_tablaDet.Delete();
  END Llenar_Estructura_XML;

  /* --------------------------------------------------------------------------
  Autor   : Gregorio Herrera
  Fecha   : 22-Jun-2010
  Objetivo: Leer el archivo TXT desde disco y llenar las tabla Temporales
  */ --------------------------------------------------------------------------
  PROCEDURE Llenar_Estructura_TXT(p_archivo varchar2) AS
    v_file           UTL_FILE.FILE_TYPE;
    v_cadena         VARCHAR2(2000) := '';
    v_posicion       PLS_INTEGER    := 1;
  BEGIN
    v_tablaTxtEnc(1).NombreArchivo := p_archivo;
    v_tablaTxtEnc(1).Secuencia     := v_sec_log;
    v_tablaTxtEnc(1).Tipo_Registro := 'E';
    c_Log_File := '';

    -- Leemos el archivo de concentracion
    dbms_output.put_line(c.archives_dir||' '||p_archivo);
    v_file := UTL_FILE.FOPEN(c.archives_dir, p_archivo, 'r');
    Loop
      Begin
        utl_file.get_line(v_file, v_cadena);

        -- Procesamos el Registro Encabezado
        If Substr(v_cadena, 1, 1) = 'E' Then
          -- Obtenemos el codigo del proceso
          v_tablaTxtEnc(1).Proceso := Substr(v_cadena,2,2);

          -- Obtenemos el codigo del sub-proceso
          v_tablaTxtEnc(1).Sub_Proceso := Substr(v_cadena,4,2);

          -- Obtenemos el valor constante '106' para el tama¿o del registro
          v_tablaTxtEnc(1).Tamano_Registro := Substr(v_cadena,6,3);

          -- Obtenemos el valor constante '04' para el tipo de entidad receptora
          v_tablaTxtEnc(1).Tipo_Entidad_Receptora := Substr(v_cadena,9,2);

          -- Obtenemos la clave de la entidad receptora
          v_tablaTxtEnc(1).Entidad_Mov_Fondos := Substr(v_cadena,11,2);

          -- Obtenemos la fecha de transmision
          v_tablaTxtEnc(1).FechaTransmision := To_Date(Substr(p_archivo,9,8),'dd/mm/yyyy');

          -- Obtenemos el n¿mero de archivo
          v_tablaTxtEnc(1).Nro_Archivo := Substr(p_archivo,17,6);
        -- Procesamos los registros Detalles
        Elsif Substr(v_cadena, 1, 1) = 'D' Then
          v_tablaTxtDet(v_posicion).Secuencia     := v_sec_log;
          v_tablaTxtDet(v_posicion).Tipo_Registro := 'D';

          -- Obtenemos el codigo del proceso
          v_tablaTxtDet(v_posicion).Fecha_Solicitud := To_Date(Substr(v_cadena,2,8),'dd/mm/yyyy');

          -- Obtenemos el concepto de la instruccion de concentracion
          v_tablaTxtDet(v_posicion).Tipo_Instruccion := Substr(v_cadena,10,3);

          -- Obtenemos el Importe de la instruccion de la concentracion
          v_tablaTxtDet(v_posicion).Importe_Instruccion := To_Number(substr(v_cadena,13,25));

          -- Obtenemos el Numero de Cuenta origen de la concentracion
          v_tablaTxtDet(v_posicion).Cuenta_Origen := To_Number(substr(v_cadena,38,25));

          -- Obtenemos el Numero de Cuenta destino de la concentracion
          v_tablaTxtDet(v_posicion).Cuenta_Destino := To_Number(substr(v_cadena,63,25));

          -- Obtenemos la Clave del tipo de entidad que se le solicita que depositen los fondos
          v_tablaTxtDet(v_posicion).Tipo_Entidad_Destino := To_Number(substr(v_cadena,88,2));

          -- Obtenemos la clave de la entidad que solicita los fondos (siempre debe ser el Banco Central)
          v_tablaTxtDet(v_posicion).Entidad_Destino := Substr(v_cadena,90,2);

          -- Obtenemos la Clave del tipo de entidad que Entreg¿ los Fondos
          v_tablaTxtDet(v_posicion).Tipo_Entidad_Origen := To_Number(substr(v_cadena,92,2));

          -- Obtenemos la clave de la entidad receptora.
          v_tablaTxtDet(v_posicion).Entidad_Origen := Substr(v_cadena,94,2);
          v_posicion := v_posicion + 1;
        -- Procesamos el registro Sumario
        Elsif Substr(v_cadena, 1, 1) = 'S' Then
          v_tablaTxtSum(1).Secuencia     := v_sec_log;
          v_tablaTxtSum(1).Tipo_Registro := 'S';

          -- Obtenemos el numero de registros que indica el archivo contra la cantidad de lineas
          v_tablaTxtSum(1).Numero_Registros := To_Number(Substr(v_cadena,2,5));

          -- Obtenemos el total a liquidar sin ajuste que indica el archivo contra los montos del detalle
           v_tablaTxtSum(1).Total_Liquidar_Ajuste := To_Number(Substr(v_cadena,7,25));

          -- Obtenemos el monto aclarado que indica el archivo
          v_tablaTxtSum(1).Monto_Aclarado := To_Number(Substr(v_cadena,32,25));

          -- Obtenemos el Total Ajuste que indica el archivo
          v_tablaTxtSum(1).Total_Ajuste := To_Number(Substr(v_cadena,57,25));

          -- Obtenemos el total a liquidar que indica el archivo contra los montos del detalle
           v_tablaTxtSum(1).Total_Liquidar := To_Number(Substr(v_cadena,82,25));
        End if;
      Exception
        When No_Data_Found Then
          Exit;
        When Others Then
          v_tablaTxtEnc.Delete();
          v_tablaTxtDet.Delete();
          v_tablaTxtSum.Delete();
          Exit;
      End;
    End Loop;
  END Llenar_Estructura_TXT;

  /* --------------------------------------------------------------------------
   Autor   : Gregorio Herrera
   Fecha   : 30-Abr-2010
   Objetivo: Reenviar los email de los archivos procesados correctamente
  */ --------------------------------------------------------------------------
  PROCEDURE Reenviar_Email(p_fecha in date) AS
  BEGIN
    -- Para leer tabla de configuraci¿n para obtener la ruta de los archivos
    select * into c
    from suirplus.srp_config_t
    where id_modulo='XML_BC';

    -- Para llenar las variables de destinarios de correos ok y erroneos solo una vez.
    getMailAddress(v_lista_ok, v_lista_err);

    -- Para reenviar los correos con los XML procesados correctamente
      dbms_output.put_line('ini');
    For r_file in (select * from suirplus.bc_archivos_tss_t
                   where n_id_error = 0
                   and trunc(d_fecha) = trunc(p_fecha)) Loop
      dbms_output.put_line(r_file.c_nombre);

      -- Limpio el contenido de las tablas temporales para XML.
      v_tablaEnc.Delete();
      v_tablaDet.Delete();

      -- Limpio el contenido de las tablas temporales para TXT.
      v_tablaTxtEnc.Delete();
      v_tablaTxtDet.Delete();
      v_tablaTxtSum.Delete();

      If instr(lower(r_file.c_nombre), '.xml') > 0 Then
        -- Con esta llamada logro llenar las tablas temporales para enviar el email

        Llenar_Estructura_XML(r_file.c_nombre);
        If (v_tablaEnc.Count > 0 OR v_tablaDet.Count > 0) Then
          Send_Email;
        End if;
      Elsif instr(lower(r_file.c_nombre), '.txt') > 0 Then
        -- Con esta llamada logro llenar las tablas temporales para enviar el email
        Llenar_Estructura_TXT(r_file.c_nombre);
        If (v_tablaTxtEnc.Count > 0 OR v_tablaTxtDet.Count > 0 OR v_tablaTxtSum.Count > 0) Then
          Send_Email;
        End if;
      End if;
    End Loop;
      dbms_output.put_line('end');

    -- Para enviar el archivo zip y xls
    Enviar_ZIP_XLS(p_fecha);
  END;

  /* --------------------------------------------------------------------------
   Autor   : Gregorio Herrera
   Fecha   : 19-May-2010
   Objetivo: Enviar por correo el archivo ZIP y el XLS
  */ --------------------------------------------------------------------------
  Procedure Enviar_ZIP_XLS(p_fecha in date) Is
    v_pos          INTEGER;
    v_index        INTEGER;
    v_nombre       VARCHAR2(100);
    p_mensaje_ret  VARCHAR2(2000);
    p_numero_ret   NUMBER(5);
    v_existe_data  BOOLEAN := FALSE;
    v_lista        system.Sendmail_Pkg.ATTACHMENTS_LIST := system.Sendmail_Pkg.ATTACHMENTS_LIST();
    v_file         UTL_FILE.FILE_TYPE;
    v_total        NUMBER(15,2) := 0;
  Begin
    -- Si la variable que contiene la configuracion del proceso esta nula
    If (c.id_modulo is null) then
      select * into c
      from suirplus.srp_config_t
      where id_modulo='XML_BC';
    End if;

    -- Si las variables que contienen los recipientes de correos esta nula
    If (v_lista_ok is null or v_lista_err is null) Then
      getMailAddress(v_lista_ok, v_lista_err);
    End if;

    -- Creando el archivo ZIP
    v_pos    := 1;
    v_index  := 1;
    v_nombre := 'archivo_'||v_index||'_'||to_char(p_fecha,'ddmmyyyy')||'.zip';
    -- Para borrar el archivo en caso de existir
    --v_result := run_cmd('rm '||c.other1_dir||v_nombre);
    runcmd('rm '||c.other1_dir||v_nombre,v_result);
    
    v_lista.EXTEND;
    v_lista(v_index):= c.other1_dir||v_nombre;

    For r_file in (select *
                   from suirplus.bc_archivos_tss_t
                   where n_id_error = 0
                     and trunc(d_fecha) = trunc(p_fecha)
                     and instr(c_nombre, '.xml') > 0 ) Loop
      -- Para crear otro nombre de archivo, si pasan de 20 archivos
      If v_pos > c.field1 Then
        v_pos    := 1;
        v_index  := v_index + 1;
        v_nombre := 'archivo_'||v_index||'_'||to_char(p_fecha,'ddmmyyyy')||'.zip';
        --v_result := run_cmd('rm '||c.other1_dir||v_nombre);
        runcmd('rm '||c.other1_dir||v_nombre,v_result);
        
        v_lista.EXTEND;
        v_lista(v_index) := c.other1_dir||v_nombre;
      End if;

      --v_result      := run_cmd('/bin/zip -9jl '||c.other1_dir||v_nombre||' '||c.other1_dir||r_file.c_nombre);
      runcmd('/bin/zip -9jl '||c.other1_dir||v_nombre||' '||c.other1_dir||r_file.c_nombre,v_result);
      
      v_pos         := v_pos + 1;
      v_existe_data := TRUE;
    End Loop;

    If v_existe_data Then
      v_nombre := 'archivo_'||to_char(p_fecha,'ddmmyyyy')||'.xls';

      -- Para borrar el archivo en caso de existir
      --v_result := run_cmd('rm '||c.other1_dir||v_nombre);
      runcmd('rm '||c.other1_dir||v_nombre,v_result);

      -- creando el archivo XLS, lo creamos con estructura HTML pero con extensi¿n .xls, para EXCEL esto es transparente
      v_file := UTL_FILE.fopen(c.archives_dir, v_nombre, 'w');

      c_log_file := '<html>'||chr(13)||chr(10)||
                    '<head><title>Archivos de liquidacion</title></head>'||chr(13)||chr(10)||
                    '<body>'||chr(13)||chr(10)||
                    '<table>'||chr(13)||chr(10)||
                    '<tr><th>Secuencia</th><th>Nombre del Archivo</th><th>Codigo Bic</th><th>TRN</th><th>Total</th></tr>'||chr(13)||chr(10);

      UTL_FILE.put_line(v_file, c_log_file, TRUE);

      For r in (Select e.secuencia,
                       e.nombrearchivo,
                       substr(e.codigobicentidadcr||'XXXXXXXXXXXX',1,12) as BIC,
                       e.trnopcrlbtr as TRN,
                       e.totalmontoscontrol as Total
                From suirplus.bc_encabezado_t e
                Where trunc(e.fechavalorcrlbtr) = trunc(p_fecha)) Loop
        c_log_file := '<tr>'||
                      '<td>'||r.secuencia||'</td>'||
                      '<td>'||r.nombrearchivo||'</td>'||
                      '<td>'||r.bic||'</td>'||
                      '<td>'||r.trn||'</td>'||
                      '<td>'||TRIM(to_char(r.total,'$999,999,999,999,990.00'))||'</td>'||
                      '</tr>';

        UTL_FILE.put_line(v_file, c_log_file, TRUE);
        v_total := v_total + r.total;
      End Loop;
      c_log_file := '<tr>'||
                    '<td></td>'||
                    '<td></td>'||
                    '<td></td>'||
                    '<td></td>'||
                    '<td>'||TRIM(to_char(v_total,'$999,999,999,999,990.00'))||'</td>'||
                    '</tr>'||
                    '</table>'||
                    '</body>'||
                    '</html>';

      UTL_FILE.put_line(v_file, c_log_file, TRUE);

      -- Cerramos el archivo.
      UTL_FILE.fclose(v_file);
      UTL_FILE.fclose_all;

      -- Para agregar el archivo .xls en la lista a ser enviada por correo
      v_index := v_index + 1;
      v_lista.EXTEND;
      v_lista(v_index) := c.other1_dir||v_nombre;

      --Enviamos los ZIP y XLS como archivos adjuntos
      system.Sendmail_Pkg.send_email(
                                      p_recipient => v_lista_ok,
                                      p_subject => 'Archivos Liquidacion BANCO CENTRAL',
                                      p_mensaje => 'Adjunto archivos ZIP y XLS con los XML del proceso de liquidacion del BANCO CENTRAL.',
                                      p_sender => 'info@mail.tss2.gov.do',
                                      p_attachments => v_lista,
                                      pmensaje_retorno => p_mensaje_ret,
                                      pnumero_retorno => p_numero_ret,
                                      pvalidar_attachment => 'S'
                                     );
    End if;
  End Enviar_ZIP_XLS;

  /* --------------------------------------------------------------------------
   Autor   : Gregorio Herrera
   Fecha   : 08-Oct-2009
   Objetivo: Leer la vista ARCHIVOS_XML_MV proporcionada por UNIPAGO
             y descencriptar el campo b_xml.
             Pasar todos los registros de esta vista a la tabla ARCHIVOS_XML_BC
  */ --------------------------------------------------------------------------
  Procedure ProcesarDB(p_fecha in Date, p_result Out varchar2) Is
    v_comando      VARCHAR2(1000);
    v_file         UTL_FILE.FILE_TYPE;
    v_buffer       RAW(32767);
    v_amount       BINARY_INTEGER;
    v_pos          INTEGER;
    v_blob_len     INTEGER;
    v_clob         CLOB;
    v_encripted    CLOB;
    v_bfile        BFILE;
    v_nombre       VARCHAR2(100);
    v_llave        VARCHAR2(100);
    v_vector       VARCHAR2(100);
    v_resultado    suirplus.bc_archivo_msg_t.descripcion%TYPE;
    p_mensaje_ret  VARCHAR2(2000);
    p_numero_ret   NUMBER(5);
    v_existe_data  BOOLEAN := FALSE;
    v_id_bitacora  suirplus.sfc_bitacora_t.id_bitacora%type;

    e_manejo_archivo exception;
    v_mensaje_error varchar2(1000);
  Begin
    -- Insetamos el registro en la bitacora
    BITACORA(v_id_bitacora, 'INI', 'BC');

    --Para refrescar vista entregada por UNIPAGO
    EXECUTE IMMEDIATE 'begin sys.dbms_snapshot.refresh(''SUIRPLUS.BC_ARCHIVOS_TSS_MV''); end;';

    -- Para insertar los registros publicados por UNIPAGO
    Insert into Suirplus.bc_archivos_tss_t
    (n_num_control,
     c_cve_proceso,
     c_cve_subproceso,
     c_nombre,
     d_fecha,
     b_data
    )
    Select n_num_control,
           c_cve_proceso,
           c_cve_subproceso,
           c_nombre,
           d_fecha,
           b_data
    From Suirplus.bc_archivos_tss_mv bc
    Where Not Exists
    (
     Select 1
     From Suirplus.bc_archivos_tss_t bc1
     Where bc1.c_nombre = bc.c_nombre
       and bc1.d_fecha = bc.d_fecha
    );

    Commit;

    p_result := 'OK';

    select * into c
    from suirplus.srp_config_t
    where id_modulo='XML_BC';

    -- Para llenar las variables de destinarios de correos ok y erroneos solo una vez.
    getMailAddress(v_lista_ok, v_lista_err);

    For r_file in (select * from suirplus.bc_archivos_tss_t where n_id_error is null and trunc(d_fecha) = trunc(Nvl(p_fecha,Sysdate))) Loop
      Begin
        v_num_control := r_file.n_num_control;
        v_existe_data := true;
        v_fecha       := sysdate;
        v_pos         := 1;
        v_amount      := 32767;

        -- Limpio el contenido de las tablas temporales.
        v_tablaEnc.Delete();
        v_tablaDet.Delete();
        v_tablaTxtEnc.Delete();
        v_tablaTxtDet.Delete();
        v_tablaTxtSum.Delete();

        --Anotamos en la tabla de log
        addarchivolog(r_file.c_nombre, Substr(r_file.c_nombre, 20, 2), v_sec_log, v_resultado);

        --Si no hay error procedo a procesar el archivo
        If v_resultado = '0' Then
          v_blob_len := DBMS_LOB.getlength(r_file.b_data);
          -- Creamos en disco un archivo temporal vacio usando el mismo nombre
          -- que viene en la vista, pero con la extension cambiada de .xml a .tmp
          Begin
            v_file := UTL_FILE.fopen(c.archives_dir, Substr(r_file.c_nombre, 1, Instr(r_file.c_nombre, '.') -1)||'.tmp', 'wb', v_amount);
          Exception when others then
            v_mensaje_error := 'Error creando archivo vacio: '||Substr(r_file.c_nombre, 1, Instr(r_file.c_nombre, '.') -1)||'.tmp'||chr(13)||chr(10)||sqlerrm;
            RAISE e_manejo_archivo;
          End;

          utl_file.put_raw(v_file,r_file.b_data);
          utl_file.fflush(v_file);
          UTL_FILE.fclose(v_file);
          UTL_FILE.fclose_all;
/*
          WHILE v_pos < v_blob_len LOOP
            dbms_output.put_line('pos:'||v_pos);
            -- Leemos el campo BLOB en bloques de 32K
            Begin
              DBMS_LOB.read(r_file.b_data, v_amount, v_pos, v_buffer);
            Exception when others then
              v_mensaje_error := 'Error leyendo desde BC_ARCHIVOS_TSS_T.B_DATA'||chr(13)||chr(10)||sqlerrm;

              -- Cerramos el archivo.
              UTL_FILE.fclose(v_file);
              UTL_FILE.fclose_all;

              RAISE e_manejo_archivo;
            End;

            --Escribimos a disco bloques de 32K
            Begin
              UTL_FILE.put_raw(v_file, v_buffer, TRUE);
              UTL_FILE.fflush(v_file);
            Exception when others then
              v_mensaje_error := 'Error escribiendo en el archivo: '||Substr(r_file.c_nombre, 1, Instr(r_file.c_nombre, '.') -1)||'.tmp'||chr(13)||chr(10)||sqlerrm;

              -- Cerramos el archivo.
              UTL_FILE.fclose(v_file);
              UTL_FILE.fclose_all;

              RAISE e_manejo_archivo;
            End;
            v_pos := v_pos + v_amount;
          END LOOP;
          dbms_output.put_line('end pos:'||v_pos);
          -- Cerramos el archivo.
          UTL_FILE.fclose(v_file);
          UTL_FILE.fclose_all;
*/          

          -- Llamamos la aplicacion JAVA "cifrado" para descomprimir el contenido del archivo creado en disco
          v_nombre  := SUBSTR(c.other1_dir||r_file.c_nombre, 1, INSTR(c.other1_dir||r_file.c_nombre,'.')-1);
          get_llaves_XML('107', v_llave);
          get_llaves_XML('108', v_vector);
          v_comando := c.field3||' '||v_nombre||'.tmp'||' '||c.other1_dir||r_file.c_nombre||' '||v_llave||' '||v_vector;
          RunCmd(v_comando, p_result);

          -- Manejo de error descifrando el archivo
          If p_result > 0 Then
            -- Actualizamos el estatus del archivo a "En Proceso"
            set_archive_status(p_operacion => 'ERR', p_error_id => 51, p_sec => v_sec_log, p_nombre_archivo => r_file.c_nombre);
            commit;

            system.Sendmail_Pkg.send_email(
                                           p_recipient => v_lista_err,
                                           p_subject => 'Error Descifrando Archivo '||CASE Substr(r_file.c_nombre, 20, 2) WHEN 'LQ' THEN 'Liquidacion' WHEN 'RV' THEN 'Reverso' ELSE 'Concentracion' END,
                                           p_mensaje => 'Contenido del archivo '||r_file.c_nombre||' no pudo ser descifrado.',
                                           p_sender => 'info@mail.tss2.gov.do',
                                           pmensaje_retorno => p_mensaje_ret,
                                           pnumero_retorno => p_numero_ret,
                                           pvalidar_attachment => 'S'
                                          );
            --Para actualizar la vista
            ActualizarVista('51');
          Else
            -- Para sacar el contenido del archivo descifrado en una variable CLOB
            -- Esto sera guardado en un campo de la tabla Suirplus.Bc_Encabezado_t y Suirplus.Bc_Co_Encabezado_t
            Begin
              v_bfile := BFILENAME(c.archives_dir, r_file.c_nombre);
              DBMS_LOB.createtemporary(v_clob, true);
              DBMS_LOB.fileopen(v_bfile, Dbms_Lob.File_Readonly);
              DBMS_LOB.loadfromfile(v_clob, v_bfile, DBMS_LOB.getlength(v_bfile));
              DBMS_LOB.fileclose(v_bfile);
              DBMS_LOB.filecloseall;
            Exception When others then
              v_mensaje_error := 'Error abriendo el archivo: '||r_file.c_nombre||' para cargarlo a variable tipo CLOB.'||chr(13)||chr(10)||sqlerrm;
              DBMS_LOB.fileclose(v_bfile);
              DBMS_LOB.filecloseall;
              RAISE e_manejo_archivo;
            End;

            -- Para sacar el contenido del archivo cifrado en una variable CLOB
            -- Esto sera guardado en un campo de la tabla Suirplus.Bc_Encabezado_t y Suirplus.Bc_Co_Encabezado_t
            Begin
              v_bfile := BFILENAME(c.archives_dir, SUBSTR(r_file.c_nombre, 1, INSTR(r_file.c_nombre,'.')-1)||'.tmp' );
              DBMS_LOB.createtemporary(v_encripted, true);
              DBMS_LOB.fileopen(v_bfile, Dbms_Lob.File_Readonly);
              DBMS_LOB.loadfromfile(v_encripted, v_bfile, DBMS_LOB.getlength(v_bfile));
              DBMS_LOB.fileclose(v_bfile);
              DBMS_LOB.filecloseall;
            Exception when others then
              v_mensaje_error := 'Error abriendo el archivo: '||Substr(r_file.c_nombre, 1, Instr(r_file.c_nombre, '.') -1)||'.tmp'||
              ' para cargarlo a variable tipo CLOB.'||chr(13)||chr(10)||sqlerrm;
              DBMS_LOB.fileclose(v_bfile);
              DBMS_LOB.filecloseall;
              RAISE e_manejo_archivo;
            End;

            --Borramos el archivo temporal
            Begin
              utl_file.fremove(c.archives_dir, v_nombre||'.tmp');
            Exception when others then
              --No tomamos ninguna accion si no pudo borrar el temporal, esto no debe detener el proceso.
              NULL;
            End;

            -- Actualizamos el estatus del archivo a: "En Proceso"
            set_archive_status(p_operacion => 'EPR', p_error_id => 0, p_sec => v_sec_log, p_nombre_archivo => r_file.c_nombre);
            commit;

            --Si el archivo es de Liquidacion(Archivo XML)
            If Substr(r_file.c_nombre, 20, 2) IN ('LQ','RV') then
              c_log_title := 'Carga de Archivos XML para '||CASE Substr(r_file.c_nombre, 20, 2) WHEN 'LQ' THEN 'Liquidacion BC.' ELSE 'Reverso BC.' END;
              -- Validamos todos los campos del archivo, campo a campo
              If Validar_Estructura_XML(r_file.c_nombre) Then
                -- Asumo que si una de las tablas esta vacia es porque las etiquetas estan en minuscula
                -- o no se pudo leer el contenido del archivo.
                If v_tablaEnc.Count = 0 OR v_tablaDet.Count = 0 Then
                  ManejoExcepciones('EtiquetaArchivo', v_sec_log);

                  system.Sendmail_Pkg.send_email(
                                                 p_recipient => v_lista_err,
                                                 p_subject => 'Error en '||c_log_title,
                                                 p_mensaje => 'Favor revisar la conformacion de las etiquetas del archivo.',
                                                 p_sender => 'info@mail.tss2.gov.do',
                                                 p_attachments => system.Sendmail_Pkg.ATTACHMENTS_LIST(c.other1_dir||r_file.c_nombre),
                                                 pmensaje_retorno => p_mensaje_ret,
                                                 pnumero_retorno => p_numero_ret,
                                                 pvalidar_attachment => 'S'
                                                );
                  --Para actualizar la vista
                  ActualizarVista('2');
                Else
                  -- Actualizamos el estatus del archivo a "Procesado"
                  set_archive_status(p_operacion => 'PRC', p_error_id => 0, p_sec => v_sec_log, p_nombre_archivo => r_file.c_nombre);
                  commit;

                  v_tablaEnc(1).Archivo_Xml     := v_clob;
                  v_tablaEnc(1).Archivo_Xml_Enc := v_encripted;

                  -- Grabar en las tablas BC_ENCABEZADO_T y BC_DETALLE_T
                  InsertLogArchivo(v_tablaEnc(1).NombreArchivo, v_resultado);

                  -- Si hubo error, mandamos email informando del error y adjuntando el archivo donde se produjo.
                  If v_resultado != '0' Then
                    system.Sendmail_Pkg.send_email(
                                                   p_recipient => v_lista_err,
                                                   p_subject => 'Error en '||c_log_title,
                                                   p_mensaje => getDescError(),
                                                   p_sender => 'info@mail.tss2.gov.do',
                                                   p_attachments => system.Sendmail_Pkg.ATTACHMENTS_LIST(c.other1_dir||r_file.c_nombre),
                                                   pmensaje_retorno => p_mensaje_ret,
                                                   pnumero_retorno => p_numero_ret,
                                                   pvalidar_attachment => 'S'
                                                  );
                    --Para actualizar la vista
                    ActualizarVista(v_resultado);

                    p_result := v_resultado;
                  Else
                    -- Envio de email exitoso
                    Send_Email;

                    -- Actualizamos el estatus del archivo a "Enviando por Email"
                    set_archive_status(p_operacion => 'ENV', p_error_id => 0, p_sec => v_sec_log, p_nombre_archivo => r_file.c_nombre);
                    commit;

                    --Para actualizar la vista
                    ActualizarVista('0');
                  End if;
                End if;
                c_log_file := NULL;
              Else
                -- A este punto la vista queda actualizada con el ID_ERROR que nos conduce hasta aqui
                system.Sendmail_Pkg.send_email(
                                               p_recipient => v_lista_err,
                                               p_subject => 'Error en '||c_log_title,
                                               p_mensaje => getDescError(),
                                               p_sender => 'info@mail.tss2.gov.do',
                                               p_attachments => system.Sendmail_Pkg.ATTACHMENTS_LIST(c.other1_dir||r_file.c_nombre),
                                               pmensaje_retorno => p_mensaje_ret,
                                               pnumero_retorno => p_numero_ret,
                                               pvalidar_attachment => 'S'
                                              );
                p_result := '-1';
              End if;

            --Si el archivo es de Concentracion(Archivo TXT)
            Else
              c_log_title := 'Carga de Archivos XML para Concentracion BC.';
              If Validar_Estructura_TXT(r_file.c_nombre) Then
                -- Asumo que si una de las tablas esta vacia es porque las etiquetas estan en minuscula
                -- o no se pudo leer el contenido del archivo.
                If v_tablaTxtEnc.Count = 0 OR v_tablaTxtDet.Count = 0 OR v_tablaTxtSum.Count = 0 Then
                  system.Sendmail_Pkg.send_email(
                                                 p_recipient => v_lista_err,
                                                 p_subject => 'Error en '||c_log_title,
                                                 p_mensaje => 'Favor revisar la conformacion del archivo de concentracion.',
                                                 p_sender => 'info@mail.tss2.gov.do',
                                                 p_attachments => system.Sendmail_Pkg.ATTACHMENTS_LIST(c.other1_dir||r_file.c_nombre),
                                                 pmensaje_retorno => p_mensaje_ret,
                                                 pnumero_retorno => p_numero_ret,
                                                 pvalidar_attachment => 'S'
                                                );
                  --Para actualizar la vista
                  ActualizarVista('2');

                  p_result := '-1';
                Else
                  -- Actualizamos el estatus del archivo a "Procesado"
                  set_archive_status(p_operacion => 'PRC', p_error_id => 0, p_sec => v_sec_log, p_nombre_archivo => r_file.c_nombre);
                  commit;

                  v_tablaTxtEnc(1).Archivo_Txt     := v_clob;
                  v_tablaTxtEnc(1).Archivo_Txt_Enc := v_encripted;

                  -- Grabar en las tablas BC_CO_ENCABEZADO_T, BC_CO_DETALLE_T y BC_CO_SUMARIO_T
                  InsertLogArchivo(v_tablaTxtEnc(1).NombreArchivo, v_resultado);

                  -- Si hubo error, mandamos email informando del error y adjuntando el archivo donde se produjo.
                  If v_resultado != '0' Then
                    system.Sendmail_Pkg.send_email(
                                                   p_recipient => v_lista_err,
                                                   p_subject => 'Error en '||c_log_title,
                                                   p_mensaje => getDescError(),
                                                   p_sender => 'info@mail.tss2.gov.do',
                                                   p_attachments => system.Sendmail_Pkg.ATTACHMENTS_LIST(c.other1_dir||r_file.c_nombre),
                                                   pmensaje_retorno => p_mensaje_ret,
                                                   pnumero_retorno => p_numero_ret,
                                                   pvalidar_attachment => 'S'
                                                  );
                    --Para actualizar la vista
                    ActualizarVista(v_resultado);

                    p_result := v_resultado;
                  Else
                    -- Envio de email exitoso
                    Send_Email;

                    -- Actualizamos el estatus del archivo a "Enviando por Email"
                    set_archive_status(p_operacion => 'ENV', p_error_id => 0, p_sec => v_sec_log, p_nombre_archivo => r_file.c_nombre);
                    commit;

                    --Para actualizr la vista
                    ActualizarVista('0');
                  End if;
                End if;
                c_log_file := NULL;
              Else
                -- A este punto la vista queda actualizada con el ID_ERROR que nos conduce hasta aqui
                system.Sendmail_Pkg.send_email(
                                               p_recipient => v_lista_err,
                                               p_subject => 'Error en '||c_log_title,
                                               p_mensaje => getDescError(),
                                               p_sender => 'info@mail.tss2.gov.do',
                                               p_attachments => system.Sendmail_Pkg.ATTACHMENTS_LIST(c.other1_dir||r_file.c_nombre),
                                               pmensaje_retorno => p_mensaje_ret,
                                               pnumero_retorno => p_numero_ret,
                                               pvalidar_attachment => 'S'
                                              );
                p_result := '-1';
              End if;
            End if;
          End if;

          -- Para liberar las variables CLOBS
          DBMS_LOB.freetemporary(v_clob);
          DBMS_LOB.freetemporary(v_encripted);
        Else
          system.Sendmail_Pkg.send_email(
                                         p_recipient => v_lista_err,
                                         p_subject => 'Error en '||c_log_title,
                                         p_mensaje => getDescError(),
                                         p_sender => 'info@mail.tss2.gov.do',
                                         p_attachments => system.Sendmail_Pkg.ATTACHMENTS_LIST(c.other1_dir||r_file.c_nombre),
                                         pmensaje_retorno => p_mensaje_ret,
                                         pnumero_retorno => p_numero_ret,
                                         pvalidar_attachment => 'S'
                                        );
          --Para actualizar la vista
          ActualizarVista(v_resultado);

          p_result := '-1';
        End if;
      Exception
        When e_manejo_archivo then
          -- Actualizamos el estatus del archivo a "Oracle Exception"
          set_archive_status(p_operacion => 'ERR', p_error_id => 52, p_sec => v_sec_log, p_nombre_archivo => r_file.c_nombre, p_error_ap => v_mensaje_error);
          commit;

          system.Sendmail_Pkg.send_email(
                                         p_recipient => v_lista_err,
                                         p_subject => 'Error en '||c_log_title,
                                         p_mensaje => 'Ha ocurrido el siguente error en el archivo '||r_file.c_nombre||': '||chr(10)||chr(13)|| v_mensaje_error || sqlerrm,
                                         p_sender => 'info@mail.tss2.gov.do',
                                         pmensaje_retorno => p_mensaje_ret,
                                         pnumero_retorno => p_numero_ret,
                                         pvalidar_attachment => 'N'
                                        );
          --Para actualizar la vista
          ActualizarVista('52');

          p_result := '-1';
        When Others Then
          -- Actualizamos el estatus del archivo a "Oracle Exception"
          set_archive_status(p_operacion => 'ERDB', p_error_id => 52, p_sec => v_sec_log, p_nombre_archivo => r_file.c_nombre, p_error_db => sqlerrm);
          commit;

          system.Sendmail_Pkg.send_email(
                                         p_recipient => v_lista_err,
                                         p_subject => 'Error en '||c_log_title,
                                         p_mensaje => 'Ha ocurrido el siguente error en el archivo '||r_file.c_nombre||': '||chr(10)||chr(13)||sqlerrm,
                                         p_sender => 'info@mail.tss2.gov.do',
                                         pmensaje_retorno => p_mensaje_ret,
                                         pnumero_retorno => p_numero_ret,
                                         pvalidar_attachment => 'N'
                                        );
          --Para actualizar la vista
          ActualizarVista('52');

          p_result := '-1';
      End;
    End Loop;

    -- Grabamos en bitacora el resultado de la corrida
    BITACORA(v_id_bitacora, 'FIN', 'BC', 'OK.', 'O', '000');

    -- Si no hay data en la vista
    If Not v_existe_data Then
      System.Html_Mail('info@mail.tss2.gov.do', v_lista_err, 'Error en '||c_log_title, 'No Existen Registros Para ser Procesados.');
      p_result := '-1';
    Else
      -- Borramos ante de publicar
      Delete From Unipago.Archivos_Tss_t;

      -- Para insertar los registros publicados por UNIPAGO y procesados sin errores
      Insert into Unipago.Archivos_tss_t
      (n_num_control,
       c_cve_proceso,
       c_cve_subproceso,
       c_nombre,
       d_fecha,
       b_data,
       n_id_error
      )
      Select bc.n_num_control,
             bc.c_cve_proceso,
             bc.c_cve_subproceso,
             bc.c_nombre,
             bc.d_fecha,
             bc.b_data,
             bc.n_id_error
      From Suirplus.bc_archivos_tss_t bc
      Join Suirplus.bc_archivos_tss_mv mv
        on mv.n_num_control = bc.n_num_control;

      Commit;

      -- Para enviar el archivo zip y xls
      Enviar_ZIP_XLS(trunc(NVL(p_fecha,Sysdate)));
    End if;

  Exception When Others Then
    -- Grabamos en bitacora el resultado de la corrida
    BITACORA(v_id_bitacora, 'FIN', 'BC', SUBSTR(SQLERRM,1,200), 'E', '650');
  End ProcesarDB;

---------------------------------------------------------------------------
end BC_ManejoArchivoXML_PKG;