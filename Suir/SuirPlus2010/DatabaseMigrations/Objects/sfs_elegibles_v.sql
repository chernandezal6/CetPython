create or replace view suirplus.sfs_elegibles_v as
select ele.registro_patronal id_registro_patronal,
       sol.nss id_nss,
       sol.tipo_subsidio,
       est.descripcion status,
       (
        select max(fecha_licencia)
        from suirplus.sub_sfs_maternidad_t mat
        where mat.nro_solicitud = ele.nro_solicitud
          and mat.id_registro_patronal = ele.registro_patronal
          and mat.id_estatus = ele.id_estatus
       ) fecha_licencia,
       sol.padecimiento,
       sol.secuencia,
        (
         select fecha_inicio_hos
           from suirplus.sub_enfermedad_comun_t
          where id_enfermedad_comun =
                (select max(enf.id_enfermedad_comun)
                   from suirplus.sub_enfermedad_comun_t enf
                  where enf.nro_solicitud = ele.nro_solicitud)
           ) fecha_inicio_hos,
         (select fecha_inicio_amb
           from suirplus.sub_enfermedad_comun_t
          where id_enfermedad_comun =
                (select max(enf.id_enfermedad_comun)
                   from suirplus.sub_enfermedad_comun_t enf
                  where enf.nro_solicitud = ele.nro_solicitud)
           ) fecha_inicio_amb,
       (
        select min(cuo.periodo)
        from suirplus.sub_cuotas_t cuo
        where cuo.nro_solicitud = ele.nro_solicitud
          and cuo.id_registro_patronal = ele.registro_patronal
       ) periodo_inicio,
       (
        select max(cuo.periodo)
        from suirplus.sub_cuotas_t cuo
        where cuo.nro_solicitud = ele.nro_solicitud
          and cuo.id_registro_patronal = ele.registro_patronal
       ) periodo_fin,
       ele.error id_error,
       ele.ult_fecha_act,
       sol.nro_solicitud
from suirplus.sub_elegibles_t ele
join suirplus.sub_solicitud_t sol on sol.nro_solicitud = ele.nro_solicitud
join suirplus.sub_estatus_t est on est.id_estatus = ele.id_estatus
where ele.id_elegibles = (
                          Select max(id_elegibles)
                          From suirplus.sub_elegibles_t e1
                          Where nro_solicitud = ele.nro_solicitud
                            and nvl(e1.registro_patronal,0) = nvl(ele.registro_patronal, 0)
                         )