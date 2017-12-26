create or replace package body suirplus.Wss_servicios_pkg is
  -- Author  : CMHA
  -- Created : 20/4/2017
  -- Purpose : MANEJO DE CASOS RELACIONADOS AL WEBSERVICES
  --*************************************************************
  --*************************************************************
  -- Muestra la informacion del afiliado para una empresa en espesifico
  -- by charile pena
  --*************************************************************
  PROCEDURE getAfiliado(p_rnc_o_cedula IN sre_empleadores_t.rnc_o_cedula%type,
                        p_cedula          in sre_ciudadanos_t.no_documento%type,
                        p_iocursor     IN OUT t_cursor,
                        p_resultnumber OUT VARCHAR2) is
    c_cursor  t_cursor;
    v_bderror varchar(1000);
    v_nss  sre_ciudadanos_t.id_nss%type;
    e_rnc_cedula EXCEPTION;
    e_nss        EXCEPTION;
  Begin
    -- realiza validaciones.
    IF NOT Sre_Empleadores_Pkg.isRncOCedulaValida(p_rnc_o_cedula) THEN
      RAISE e_rnc_cedula;
    End if;
    select c.id_nss
      into v_nss
      from suirplus.sre_ciudadanos_t c
     where c.no_documento = p_cedula;
    IF NOT sre_trabajador_pkg.isexisteidnss(v_nss) THEN
      RAISE e_nss;
    End if;
    Open c_cursor for
      select n.id_nomina,
             n.nomina_des,
             t.id_nss,
             c.no_documento,
             initCap(trim(c.nombres || ' ' || nvl(c.primer_apellido, '') || ' ' ||
                          nvl(c.segundo_apellido, ''))) nombres,
             e.rnc_o_cedula,
             initCap(e.razon_social) razon_social,
             t.fecha_registro,
             t.fecha_ingreso,
             t.fecha_salida,
             t.fecha_ult_reintegro,
             t.salario_ss,
             decode(t.status, 'A', 'Alta', 'B', 'Baja') Estatus
        from sre_trabajadores_t t
        join sre_nominas_t n
          on n.id_registro_patronal = t.id_registro_patronal
         and n.id_nomina = t.id_nomina
        join sre_empleadores_t e
          on e.id_registro_patronal = t.id_registro_patronal
        join sre_ciudadanos_t c
          on c.id_nss = t.id_nss
       where t.id_nss = v_nss
         and e.rnc_o_cedula = p_rnc_o_cedula;
    p_iocursor     := c_cursor;
    p_resultnumber := 0;
  EXCEPTION
    WHEN e_rnc_cedula THEN
      p_resultnumber := Seg_Retornar_Cadena_Error('WS011', NULL, NULL);
      RETURN;
    When e_nss then
      p_resultnumber := seg_retornar_cadena_error('WS018', null, null);
      Return;
    when others then
      v_bderror      := (substr('error ' || to_char(sqlcode) || ': ' ||
                                sqlerrm,
                                1,
                                255));
      p_resultnumber := seg_retornar_cadena_error(-1, v_bderror, sqlcode);
  end getAfiliado;
  
  --*************************************************************
  -- muestra el historico de descuento del afiliado
  -- create by charile pena
  --*************************************************************
  PROCEDURE getHistoricoDescuento(p_rnc_o_cedula IN sre_empleadores_t.rnc_o_cedula%type,
                                  p_nss          IN sre_trabajadores_t.id_nss%type,
                                  p_cedula       in sre_ciudadanos_t.no_documento%type,
                                  p_ano          in varchar2,
                                  p_iocursor     IN OUT t_cursor,
                                  p_resultnumber OUT VARCHAR2) is
    c_cursor  t_cursor;
    v_bderror varchar(1000);
    v_nss  sre_ciudadanos_t.id_nss%type;
    e_rnc_cedula EXCEPTION;
    e_nss        EXCEPTION;
    e_cedula        EXCEPTION;
    v_nombre varchar2(100);
    v_fecha_nacimiento date;
    v_cedula varchar(11);
    v_documento varchar2(1);
    
    
 /*Se realizaron cambios requeridos en el el Task 7390
   by kerlin de la cruz*/
  Begin
    -- realiza validaciones.
    If p_rnc_o_cedula is not null then
       IF NOT Sre_Empleadores_Pkg.isRncOCedulaValida(p_rnc_o_cedula) THEN
             RAISE e_rnc_cedula;
       End if;
    End if;
    
    if p_cedula is not null then
      suirplus.sre_ciudadano_pkg.IsExisteCiudadano(p_cedula, 'C', v_documento);
     IF  v_documento = 0 THEN      
        RAISE e_cedula;
     End if;     

      select c.id_nss,c.nombres ||' '|| c.primer_apellido ||' '|| c.segundo_apellido nombre, c.fecha_nacimiento,c.no_documento
             into v_nss,v_nombre,v_fecha_nacimiento,v_cedula
     from suirplus.sre_ciudadanos_t c
     where c.no_documento = p_cedula;          
          
    ELSE
     
    IF NOT sre_trabajador_pkg.isexisteidnss(p_nss) THEN
        RAISE e_nss;
     End if;   
    
     select c.id_nss,c.nombres ||' '|| c.primer_apellido ||' '|| c.segundo_apellido nombre, c.fecha_nacimiento,c.no_documento
             into v_nss,v_nombre,v_fecha_nacimiento,v_cedula
     from suirplus.sre_ciudadanos_t c
     where c.id_nss = p_nss;
     
    End if;      
      
    Open c_cursor for
      select  e.rnc_o_cedula,
             initcap(e.razon_social) razon_social  ,
             f.id_referencia Referencia,
             decode(f.id_tipo_factura,
                    'U',
                    d.PERIODO_APLICACION,
                    f.periodo_factura) Periodo,
             f.id_tipo_factura Tipo,
             srp_mantenimiento_pkg.Get_FechaFinPeriodo(to_char(to_date(f.periodo_factura || '01',
                                                                       'yyyymmdd'),
                                                               'MM/DD/YYYY')) as Limite,
             f.fecha_pago Pagada,
             case
               when f.fecha_pago >
                    srp_mantenimiento_pkg.Get_FechaFinPeriodo(to_char(to_date(f.periodo_factura || '01',
                                                                              'yyyymmdd'),
                                                                      'MM/DD/YYYY')) then
                'SI'
               else
                'NO'
             end Retrasado,
             d.salario_ss Salario,
             v_cedula Cedula,
             v_nss NSS,
             v_nombre Nombre,
             v_fecha_nacimiento Fecha_Nacimiento           
        from sfc_facturas_t f
              join sre_empleadores_t e 
          on e.id_registro_patronal = f.id_registro_patronal
          and (p_rnc_o_cedula is null or e.rnc_o_cedula = p_rnc_o_cedula)
        join sfc_det_facturas_t d
          on f.id_referencia = d.id_referencia
         and d.id_nss = v_nss
       where f.status = 'PA'
       and (p_ano is null or substr(f.periodo_factura,1,4) = p_ano)
       order by periodo_factura desc;
    p_iocursor     := c_cursor;
    p_resultnumber := 0;
  EXCEPTION
    WHEN e_rnc_cedula THEN
      p_resultnumber := Seg_Retornar_Cadena_Error('WS011', NULL, NULL);
      RETURN;
    When e_nss then
      p_resultnumber := seg_retornar_cadena_error('WS022', null, null);
      Return;
    when others then
      v_bderror      := (substr('error ' || to_char(sqlcode) || ': ' ||
                                sqlerrm,
                                1,
                                255));
      p_resultnumber := seg_retornar_cadena_error(-1, v_bderror, sqlcode);
  end getHistoricoDescuento;
  
  -- **************************************************************************************************
  -- PROCEDURE: ValidarPYMES
  -- DESCRIPTION: Se valida que la empresa este al dia en TSS y la cantidad de trabajadores activos 
  -- DATE: 27/04/2017
  -- BY: Kerlin De La Cruz             
  -- **************************************************************************************************
  PROCEDURE ValidarPYMES(p_rnc_o_cedula  in sel_registro_emp_t.rnc_o_cedula%type, 
                         p_iocursor      IN OUT t_cursor,                            
                         p_resultnumber  out varchar2) IS
                         
  c_cursor  t_cursor;
  v_bderror varchar(1000);
  v_status varchar2(1);
  
  BEGIN 
    Open c_cursor for   
   with a as
   (
     select e.razon_social,
      suirplus.sre_empleadores_pkg.isempleadoraldia(p_rnc_o_cedula) as Al_dia,
      c.sexo,
      t.salario_ss,
      t.id_nss 
      from suirplus.sre_empleadores_t e
      join suirplus.sre_trabajadores_t t on t.id_registro_patronal = e.id_registro_patronal
                                         and t.status = 'A'
      join suirplus.sre_ciudadanos_t c on c.id_nss = t.id_nss                          
      where e.rnc_o_cedula = p_rnc_o_cedula
   )   
    select razon_social,
	        Al_dia,
           sexo,
           round(avg(salario_ss),2) as Salario_Promedio,
           sum(salario_ss) as Total_Salarios,
           count(distinct(id_nss)) as Cant_NSS                    
      from a
  group by razon_social,sexo,Al_dia;
  
  p_iocursor     := c_cursor;
   p_resultnumber := '0';   
  
  EXCEPTION    
    WHEN OTHERS THEN
      v_bderror      := (substr('error ' || to_char(sqlcode) || ': ' ||sqlerrm,1,255));
      p_resultnumber := '1|' || seg_retornar_cadena_error(-1, v_bderror, sqlcode);      
      Return;
  END;
  
 --------------------------------------------------------------------------------------------------------
  -- PROCEDURE: Get_Tipo_Referencia
  -- DESCRIPTION: Para mostrar los diferentes tipos de referencias
  -- BY: Kerlin de la cruz
  -- DATE: 20-01-2015  
  --------------------------------------------------------------------------------------------------------
  procedure Get_Tipos_Referencias(p_io_cursor        IN OUT t_cursor,
                                 p_resultnumber     OUT VARCHAR2) is 
   
 v_bderror              varchar2(500);
 v_cursor               t_cursor;   
  
  BEGIN     
  open v_cursor for
    select t.id_tipo_factura,
           initcap(t.tipo_factura_des) Descripcion 
      from sfc_tipo_facturas_t t;        
  
    p_io_cursor    := v_cursor;
    p_resultnumber := '0';
  
  exception    
    WHEN OTHERS THEN
      v_bderror      := (SUBSTR('error ' || TO_CHAR(SQLCODE) || ': ' || SQLERRM,1, 255));
      p_resultnumber := Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
  END; 
  
-- **************************************************************************************************
-- Program:  MarcarPagada
-- Description:Para marcar una liquidacion como pagada
--Autor: Eury Vallejo
-- **************************************************************************************************
procedure MarcarPagada(p_usuario in seg_usuario_t.id_usuario%type,
                       p_liquidacion in sfc_liquidacion_infotep_t.id_referencia_infotep%type,
                       p_fecha_pago in sfc_liquidacion_infotep_t.fecha_pago%type,
                       p_entidad_recaudadora in sfc_liquidacion_infotep_t.id_entidad_recaudadora%type,
                       p_resultado OUT VARCHAR2) Is
counter integer;
v_fechaEmision date;
v_status varchar2(2) default null;
v_EntidadRecaudadora integer;
e_fechapagoInvalida exception; 
e_entidadRecaudadora exception; 
e_liquidacionNoexiste exception;
e_liquidacionPagada exception;
e_liquidacionCancelada exception;
e_liquidacionVencida exception;
e_liquidacionInhabilidataPago exception;
e_fechafutura exception;
v_bderror           VARCHAR(1000);

BEGIN
 
select count(*)
  into counter
  from sfc_liquidacion_infotep_t t 
  where t.id_referencia_infotep = p_liquidacion;

if counter > 0 then 
/*Validamos que la liquidacion este con un estatus valido para pagarse*/ 
  select t.status
    into v_status
    from sfc_liquidacion_infotep_t t 
   where t.id_referencia_infotep = p_liquidacion; 

  if v_status is null then
     raise e_liquidacionNoexiste;
  else
    if v_status = 'PA' then
       raise e_liquidacionPagada;
    end if;
    if v_status = 'CA' then
       raise e_liquidacionCancelada;
    end if;
    if v_status = 'IN' then
       raise  e_liquidacionInhabilidataPago;
    end if;
  end if;
  
 /*Validamos que la fecha de pago no sea futura*/ 
if p_fecha_pago > sysdate then
raise e_fechafutura;
end if;

/*Validamos que la fecha pago sea mayor o igual a la fecha emision*/
select li.fecha_emision
into v_fechaEmision
from suirplus.sfc_liquidacion_infotep_t li
where li.id_referencia_infotep = p_liquidacion;

if v_fechaEmision > p_fecha_pago then
raise e_fechapagoInvalida;
end if;

/*Validamos que la entidad recaudadora exista en nuestra base de datos*/
select count(*) 
into v_EntidadRecaudadora
from sfc_entidad_recaudadora_t en 
where en.id_entidad_recaudadora = p_entidad_recaudadora
and en.bancosrecaudadoresinf = 1;

if v_EntidadRecaudadora = 0 then
raise e_entidadRecaudadora;
end if;

/*Actualizamos a marcar la liqudacion como pagada*/
update suirplus.sfc_liquidacion_infotep_t l
   set l.status             = 'PA',
       l.id_entidad_recaudadora = p_entidad_recaudadora,                            
       l.fecha_pago             = p_fecha_pago,
       l.ult_usuario_act        = upper(p_usuario),
       l.ult_fecha_act          = sysdate
 where l.id_referencia_infotep = p_liquidacion;
commit;
p_resultado := 'OK';
ELSE
    raise e_liquidacionNoexiste;
END IF;

EXCEPTION
WHEN e_liquidacionNoexiste THEN
   p_resultado := Seg_Retornar_Cadena_Error('WS001', NULL, NULL); 
WHEN e_liquidacionPagada THEN
     p_resultado := Seg_Retornar_Cadena_Error('WS002', NULL, NULL);
WHEN e_liquidacionCancelada THEN
     p_resultado := Seg_Retornar_Cadena_Error('WS003', NULL, NULL);
WHEN e_liquidacionInhabilidataPago THEN
     p_resultado := Seg_Retornar_Cadena_Error('WS005', NULL, NULL);
WHEN e_fechapagoInvalida THEN
     p_resultado := Seg_Retornar_Cadena_Error('WS006', NULL, NULL);
WHEN e_entidadRecaudadora THEN
     p_resultado := Seg_Retornar_Cadena_Error('WS007', NULL, NULL);
WHEN e_fechafutura THEN
     p_resultado := Seg_Retornar_Cadena_Error('WS012', NULL, NULL);
WHEN OTHERS THEN
 v_bderror := (SUBSTR('error '||TO_CHAR(SQLCODE)||': '||SQLERRM, 1, 255));
 p_resultado := Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
END;

-- **************************************************************************************************
-- Program:  MarcarCancelada
-- Description:Para marcar una liquidacion como Cancelada
--Autor: Eury Vallejo
-- **************************************************************************************************
procedure MarcarCancelada(p_usuario in seg_usuario_t.id_usuario%type,
                          p_liquidacion in sfc_liquidacion_infotep_t.id_referencia_infotep%type,
                          p_resultado OUT VARCHAR2) Is
counter integer;
v_status varchar(2);
v_fecha_desautorizacion suirplus.sfc_liquidacion_isr_t.fecha_desautorizacion%type;
v_fecha_autorizacion suirplus.sfc_liquidacion_isr_t.fecha_autorizacion%type;
v_autorizacion suirplus.sfc_liquidacion_infotep_t.no_autorizacion%type;
v_bderror           VARCHAR(1000);
e_liquidacionNoexiste exception;
e_liquidacionCancelada exception;
e_liquidacionPagada exception;
BEGIN


select count(*)
into counter
from sfc_liquidacion_infotep_t t 
where t.id_referencia_infotep = p_liquidacion;

if counter > 0 then

/*Validamos que la liquidacion este con un estatus valido para cancelarse*/
select t.status,t.fecha_autorizacion,t.fecha_desautorizacion,t.no_autorizacion
into v_status,v_fecha_autorizacion,v_fecha_desautorizacion,v_autorizacion
from sfc_liquidacion_infotep_t t 
where t.id_referencia_infotep = p_liquidacion
group by t.status,t.fecha_autorizacion,t.fecha_desautorizacion,t.no_autorizacion;

IF (v_status <> 'PA' and v_status <> 'CA' and v_autorizacion is null) THEN
 update suirplus.sfc_liquidacion_infotep_t l
    set l.status = 'CA',
        l.fecha_cancela = sysdate,
        l.ult_fecha_act = sysdate,
        l.ult_usuario_act = upper(p_usuario)
  where l.id_referencia_infotep = p_liquidacion;
  commit;
  p_resultado := 'OK';


ELSIF (v_status = 'PA' and (v_fecha_desautorizacion is not null and v_fecha_desautorizacion > v_fecha_autorizacion )) THEN
update suirplus.sfc_liquidacion_infotep_t l
       set l.status = 'CA',
            l.fecha_cancela = sysdate,
            l.ult_fecha_act = sysdate,
            l.ult_usuario_act = upper(p_usuario)
where l.id_referencia_infotep = p_liquidacion;
COMMIT;
p_resultado := 'OK';

ELSIF (v_status = 'CA') THEN
 raise e_liquidacionCancelada;

ELSIF v_autorizacion is not null THEN
 raise e_liquidacionPagada; 
END IF;

ELSE
    raise e_liquidacionNoexiste;
END IF;

EXCEPTION
WHEN e_liquidacionNoexiste THEN
   p_resultado := Seg_Retornar_Cadena_Error('WS001', NULL, NULL); 
WHEN e_liquidacionCancelada THEN
     p_resultado := Seg_Retornar_Cadena_Error('WS003', NULL, NULL);   
WHEN e_liquidacionPagada THEN
    p_resultado := Seg_Retornar_Cadena_Error('WS002', NULL, NULL);        
WHEN OTHERS THEN
 v_bderror := (SUBSTR('error '||TO_CHAR(SQLCODE)||': '||SQLERRM, 1, 255));
 p_resultado := Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
END;

-- **************************************************************************************************
-- Program:  NoPagaInfotep
-- Description:Para marcar una empresa, indicando que No paga infotep
--Autor: Eury Vallejo
-- **************************************************************************************************
procedure NoPagaInfotep(p_usuario in seg_usuario_t.id_usuario%type,
                       p_rnc in sre_empleadores_t.rnc_o_cedula%type,
                       p_resultado OUT VARCHAR2) Is
e_rncInvalido exception;
v_bderror           VARCHAR(1000);
e_empleadorNoPagaInfotep exception;
v_status varchar(1);
v_pagaNoInfotep varchar(1);
e_rncBaja exception;
e_rncSuspendido exception;
e_rncNoExiste exception;
v_count number;
BEGIN

select count(*)
into v_count
from sre_empleadores_t e
where e.rnc_o_cedula = p_rnc;

if v_count > 0 then

v_status := suirplus.sre_empleadores_pkg.isrncocedularetornarestatus(p_rnc);
IF v_status = 'A' THEN  

select e.paga_infotep
into v_pagaNoInfotep
from SRE_EMPLEADORES_T e
where e.rnc_o_cedula = p_rnc;

IF v_pagaNoInfotep is not null THEN

update suirplus.sre_empleadores_t e 
               set e.paga_infotep = null,
                   e.ult_fecha_act = sysdate,
                   e.ult_usuario_act = upper(p_usuario)
             where e.rnc_o_cedula = p_rnc;
commit;
p_resultado := 'OK';
ELSE
  raise e_empleadorNoPagaInfotep;
END IF;
ELSIF v_status = 'B' THEN
   raise e_rncBaja;
ELSIF v_status = 'S' THEN
 raise e_rncSuspendido;
 
ELSE
  raise e_rncInvalido;
END IF;
ELSE
 raise e_rncNoExiste;  
END IF;

EXCEPTION
WHEN e_rncInvalido THEN
   p_resultado := Seg_Retornar_Cadena_Error('WS011', NULL, NULL); 
WHEN e_empleadorNoPagaInfotep THEN
   p_resultado := Seg_Retornar_Cadena_Error('WS008', NULL, NULL); 
    WHEN e_rncBaja THEN
   p_resultado := Seg_Retornar_Cadena_Error('WS015', NULL, NULL); 
   WHEN e_rncSuspendido THEN
   p_resultado := Seg_Retornar_Cadena_Error('WS016', NULL, NULL); 
    WHEN e_rncNoExiste THEN
   p_resultado := Seg_Retornar_Cadena_Error('WS017', NULL, NULL); 
WHEN OTHERS THEN
 v_bderror := (SUBSTR('error '||TO_CHAR(SQLCODE)||': '||SQLERRM, 1, 255));
 p_resultado := Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
END;

-- **************************************************************************************************
-- Program:  PagaInfotep
-- Description:Para marcar una empresa, indicando que paga infotep
--Autor: Eury Vallejo
-- **************************************************************************************************
procedure PagaInfotep(p_usuario in seg_usuario_t.id_usuario%type,
                       p_rnc in sre_empleadores_t.rnc_o_cedula%type,
                       p_resultado OUT VARCHAR2) Is
e_rncInvalido exception;
v_bderror           VARCHAR(1000);
e_empleadorPagaInfotep exception;
v_status varchar(1);
v_pagainfotep varchar(1);
e_rncBaja exception;
e_rncSuspendido exception;
e_rncNoExiste exception;
v_count number;
BEGIN

select count(*)
into v_count
from sre_empleadores_t e
where e.rnc_o_cedula = p_rnc;

if v_count > 0 then


v_status := suirplus.sre_empleadores_pkg.isrncocedularetornarestatus(p_rnc);

IF v_status = 'A' THEN
  
select e.paga_infotep
into v_pagainfotep
from SRE_EMPLEADORES_T e
where e.rnc_o_cedula = p_rnc;

IF v_pagainfotep is null THEN
  
update suirplus.sre_empleadores_t e 
set e.paga_infotep = 'S',
e.ult_fecha_act = sysdate,
e.ult_usuario_act = upper(p_usuario)
where e.rnc_o_cedula = p_rnc;
commit;
p_resultado := 'OK';

ELSE
raise e_empleadorPagaInfotep;
END IF;

ELSIF v_status = 'B' THEN
   raise e_rncBaja;
ELSIF v_status = 'S' THEN
 raise e_rncSuspendido;
ELSE
 raise e_rncInvalido;
END IF;

ELSE
 raise e_rncNoExiste;  
END IF;


EXCEPTION
WHEN e_rncInvalido THEN
   p_resultado := Seg_Retornar_Cadena_Error('WS011', NULL, NULL); 
WHEN e_empleadorPagaInfotep THEN
p_resultado := Seg_Retornar_Cadena_Error('WS009', NULL, NULL); 
WHEN e_rncBaja THEN
p_resultado := Seg_Retornar_Cadena_Error('WS015', NULL, NULL); 
WHEN e_rncSuspendido THEN
p_resultado := Seg_Retornar_Cadena_Error('WS016', NULL, NULL); 
WHEN e_rncNoExiste THEN
p_resultado := Seg_Retornar_Cadena_Error('WS017', NULL, NULL); 
   
WHEN OTHERS THEN
 v_bderror := (SUBSTR('error '||TO_CHAR(SQLCODE)||': '||SQLERRM, 1, 255));
 p_resultado := Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
END;

-- **************************************************************************************************
-- Procedure: GetCiudadano
-- Description: Buscar la informacion del ciudadano en base a su numero de cedula
-- By: Kerlin De La Cruz
-- Date: 08/05/2017
-- **************************************************************************************************
procedure GetCiudadano(p_cedula in sre_ciudadanos_t.no_documento%type,  
                       p_iocursor     IN OUT t_cursor,                     
                       p_resultado OUT VARCHAR2) Is
 
 c_cursor  t_cursor;
 v_bderror varchar(1000);
  e_ciudadano_no_existe exception; 
 counter number;
                     
Begin
  
 select count(*)
   into counter
   from sre_ciudadanos_t c
  where c.no_documento = p_cedula;

  If counter = 0 then
     raise e_ciudadano_no_existe;     
  end if;   

  Open c_cursor for
      select c.id_nss,
             c.no_documento,
             upper(c.nombres) as Nombres,
             upper(c.primer_apellido) as Primer_Apellido,
             nvl(upper(c.segundo_apellido), '') as Segundo_Apellido,
             c.fecha_nacimiento,
             n.nacionalidad_des as Nacionalidad,
             c.sexo,
             c.estado_civil,
             i.cancelacion_des as Inhabilidad,
             c.fecha_fallecimiento
        from sre_ciudadanos_t c
        join sre_nacionalidad_t n on n.id_nacionalidad = c.id_nacionalidad
        left join sre_inhabilidad_jce_t i on i.id_causa_inhabilidad = c.id_causa_inhabilidad
       where c.no_documento = p_cedula;       
  
   p_iocursor  := c_cursor;
   p_resultado := '0';
   
EXCEPTION  
  WHEN e_ciudadano_no_existe THEN
   p_resultado := Seg_Retornar_Cadena_Error('WS018', NULL, NULL); 
  when others then
    v_bderror      := (substr('error ' || to_char(sqlcode) || ': ' || sqlerrm,1, 255));
    p_resultado := seg_retornar_cadena_error(-1, v_bderror, sqlcode);
end GetCiudadano; 

-- **************************************************************************************************
-- Procedure: GetTrabajador
-- Description: Buscar la informacion del trabajador en base a su numero de cedula
-- By: Kerlin De La Cruz
-- Date: 08/05/2017
-- **************************************************************************************************
procedure GetTrabajador(p_cedula in sre_ciudadanos_t.no_documento%type,  
                        p_iocursor     IN OUT t_cursor,                     
                        p_resultado OUT VARCHAR2) Is
 
 c_cursor  t_cursor;
 v_bderror varchar(1000);
 e_ciudadano_no_existe exception; 
 v_counter number;
 v_id_nss  number;
 
                     
Begin
  
 select count(*), c.id_nss
   into v_counter,v_id_nss
   from sre_ciudadanos_t c
  where c.no_documento = p_cedula;

  If v_counter = 0 then
     raise e_ciudadano_no_existe;     
  end if;   

  Open c_cursor for
      select e.rnc_o_cedula, t.id_nss
        from sre_trabajadores_t t
        join sre_ciudadanos_t c on c.id_nss = t.id_nss
        join sre_empleadores_t e on e.id_registro_patronal = t.id_registro_patronal
       where c.no_documento = p_cedula;       
  
   p_iocursor  := c_cursor;
   p_resultado := '0';
   
EXCEPTION  
  WHEN e_ciudadano_no_existe THEN
   p_resultado := Seg_Retornar_Cadena_Error('WS018', NULL, NULL); 
  when others then
    v_bderror      := (substr('error ' || to_char(sqlcode) || ': ' || sqlerrm,1, 255));
    p_resultado := seg_retornar_cadena_error(-1, v_bderror, sqlcode);
end GetTrabajador;  

-- **************************************************************************************************
-- Procedure: GetEmpleadorRep
-- Description: Buscar la informacion de la empresa y sus represen activos
-- By: Kerlin De La Cruz
-- Date: 08/05/2017
-- **************************************************************************************************
procedure GetEmpleadorRep(p_rnc_cedula in sre_empleadores_t.rnc_o_cedula%type,  
                          p_iocursor   IN OUT t_cursor,                     
                          p_resultado  OUT VARCHAR2) Is
 
 c_cursor  t_cursor;
 v_bderror varchar(1000);
 e_empleador_no_existe exception; 
 v_counter number; 
                     
Begin
  
 select count(*)
   into v_counter
   from sre_empleadores_t e
  where e.rnc_o_cedula = p_rnc_cedula;

  If v_counter = 0 then
     raise e_empleador_no_existe;     
  end if;   

  Open c_cursor for
      select e.nombre_comercial, 
             e.razon_social,
             ae.actividad_eco_des as Actividad_Economica,
             decode(e.tipo_empresa, 'PR','PRIVADA', 'PU','PUBLICA NO CENTRALIZADA','PC','PUBLICA NO CENTRALIZADA') as Tipo_Empresa,
             upper(cr.riesgo_des) as Categoria_Riesgo,
             e.telefono_1,
             e.telefono_2,
             e.calle || ' '|| e.numero || ' '|| e.edificio as Direccion,
             e.sector,
             upper(m.municipio_des) as Municipio,
             c.id_nss,
             c.no_documento,
             upper(c.nombres) as nombres,
             upper(c.primer_apellido) as Primer_Apellido,
             upper(c.segundo_apellido) as Segundo_Apellido,
             decode(r.tipo_representante, 'N', 'NORMAL', 'A', 'ADMINISTRATIVO') as Tipo_Representante,
             r.telefono_1,
             r.telefono_2,
             decode(r.status, 'A', 'ACTIVO', 'I', 'INACTIVO') as status            
        from sre_empleadores_t e
        join sre_actividad_economica_t ae on ae.id_actividad_eco = e.id_actividad_eco
        join sre_categoria_riesgo_t cr on cr.id_riesgo = e.id_riesgo
        join sre_municipio_t m on m.id_municipio = e.id_municipio               
        join sre_representantes_t r on r.id_registro_patronal = e.id_registro_patronal
                                   and r.status = 'A'                                
        join sre_ciudadanos_t c on c.id_nss = r.id_nss                                  
       where e.rnc_o_cedula = p_rnc_cedula;       
  
   p_iocursor  := c_cursor;
   p_resultado := '0';
   
EXCEPTION  
  WHEN e_empleador_no_existe THEN
   p_resultado := Seg_Retornar_Cadena_Error('WS011', NULL, NULL); 
  when others then
    v_bderror      := (substr('error ' || to_char(sqlcode) || ': ' || sqlerrm,1, 255));
    p_resultado := seg_retornar_cadena_error(-1, v_bderror, sqlcode);
end GetEmpleadorRep;

-- **************************************************************************************************
-- Procedure: ActualizarCategoriaRiesgo
-- Description: Para actualizar la categoria riesgo de un empleador
-- By: Kerlin De La Cruz
-- Date: 09/05/2017
-- **************************************************************************************************
procedure ActualizarCategoriaRiesgo(p_rnc_cedula in sre_empleadores_t.rnc_o_cedula%type,
                                    p_categoria_riesgo in sre_categoria_riesgo_t.id_riesgo%type,
                                    p_usuario in seg_usuario_t.id_usuario%type,
                                    p_resultado OUT VARCHAR2) Is

v_bderror VARCHAR(1000);
v_counter number;
v_counter1 number;
e_categoria_riesgo exception;
e_empleador_no_existe exception;
e_usuario_no_existe exception;


BEGIN
  /*Validamos que sea un empleador valido*/
  select count(*)
    into v_counter
    from sre_empleadores_t e 
   where e.rnc_o_cedula = p_rnc_cedula;
  
  if v_counter = 0 then
    raise e_empleador_no_existe;
  end if;
  
  /*Validamos que sea una categoria de riesgo valida*/
  select count(*)
    into v_counter1
    from sre_categoria_riesgo_t c 
   where c.id_riesgo = p_categoria_riesgo;
  
  if v_counter1 = 0 then
    raise e_categoria_riesgo;
  end if;
  /*Validamos que sea un usuario valido*/
  if not seg_usuarios_pkg.isExisteUsuario(upper(p_usuario)) then
    raise e_usuario_no_existe;
  end if;
  
  /*Actualizamos la categoria de riesgo del empleador*/
  update suirplus.sre_empleadores_t e
     set e.id_riesgo = p_categoria_riesgo,
         e.ult_usuario_act = p_usuario,
         e.ult_fecha_act = sysdate
  where e.rnc_o_cedula = p_rnc_cedula;
  commit;
  
   p_resultado := '0';
  
EXCEPTION  
WHEN e_empleador_no_existe THEN
     p_resultado := Seg_Retornar_Cadena_Error('WS011', NULL, NULL);
WHEN e_categoria_riesgo THEN
     p_resultado := Seg_Retornar_Cadena_Error('WS020', NULL, NULL);  
WHEN e_usuario_no_existe THEN
     p_resultado := Seg_Retornar_Cadena_Error('WS010', NULL, NULL);         
when others then  
     v_bderror := (SUBSTR('error '||TO_CHAR(SQLCODE)||': '||SQLERRM, 1, 255));
     p_resultado := Seg_Retornar_Cadena_Error(-1, v_bderror, SQLCODE);
END ActualizarCategoriaRiesgo;                   

-- **************************************************************************************************
-- Procedure: GetExtranjero
-- Description: Buscar la informacion del extranjero en base a su numero de documento
-- By: Kerlin De La Cruz
-- Date: 09/05/2017
-- **************************************************************************************************
procedure GetExtranjero(p_nro_carnet in nss_maestro_extranjeros_t.id_expediente%type,  
                        p_iocursor   IN OUT t_cursor,                     
                        p_resultado  OUT VARCHAR2) Is
 
 c_cursor  t_cursor;
 v_bderror varchar(1000);
 e_documento_invalido exception; 
 counter number;
 v_id_nss number;
                     
Begin
  
 select count(*)
   into counter
   from nss_maestro_extranjeros_t ex
  where upper(ex.id_expediente) = upper(p_nro_carnet);

  If counter = 0 then
     raise e_documento_invalido; 
  else    
      select m.id_nss
          into v_id_nss
          from nss_maestro_extranjeros_t m
         where m.id_expediente = p_nro_carnet; 
         
      if v_id_nss is null then         
          Open c_cursor for 
              select m.id_expediente,
                     m.id_tipo_documento as Id_Tipo_Documento,
                     upper(td.descripcion) as Tipo_Documento,
                     m.id_nss,
                     m.cedula,
                     m.nombres,
                     m.primer_apellido,
                     m.segundo_apellido,
                     m.fecha_nacimiento,
                     upper(n.nacionalidad_des) as Nacionalidad,
                     m.sexo,
                     c.estado_civil,
                     m.fecha_expedicion,
                     m.fecha_expiracion             
              from nss_maestro_extranjeros_t m
              join sre_tipo_documentos_t td on td.id_tipo_documento = m.id_tipo_documento
              left join sre_ciudadanos_t c on c.id_nss = m.id_nss
              join sre_nacionalidad_t n on n.id_nacionalidad = m.id_nacionalidad
              where upper(m.id_expediente) = upper(p_nro_carnet);  
              
              p_iocursor  := c_cursor;
              p_resultado := '0';
              
             else  
                Open c_cursor for 
                   select m.id_expediente,
                           m.id_tipo_documento as Id_Tipo_Documento,
                           upper(td.descripcion) as Tipo_Documento,
                           c.id_nss,
                           c.no_documento,
                           c.nombres,
                           c.primer_apellido,
                           c.segundo_apellido,
                           c.fecha_nacimiento,
                           upper(n.nacionalidad_des) Nacionalidad,
                           c.sexo,
                           c.estado_civil,
                           m.fecha_expedicion,
                           m.fecha_expiracion             
                    from nss_maestro_extranjeros_t m
                    join sre_tipo_documentos_t td on td.id_tipo_documento = m.id_tipo_documento
                    left join sre_ciudadanos_t c on c.id_nss = m.id_nss
                    join sre_nacionalidad_t n on n.id_nacionalidad = m.id_nacionalidad
                    where upper(m.id_expediente) = upper(p_nro_carnet); 
                      
                     p_iocursor  := c_cursor;
                     p_resultado := '0';
            
             End if;                     
    end if;  
   
EXCEPTION  
WHEN e_documento_invalido THEN
  p_resultado := Seg_Retornar_Cadena_Error('WS021', NULL, NULL); 
when others then
  v_bderror      := (substr('error ' || to_char(sqlcode) || ': ' || sqlerrm,1, 255));
  p_resultado := seg_retornar_cadena_error(-1, v_bderror, sqlcode);
end GetExtranjero; 

end WSS_Servicios_pkg;
