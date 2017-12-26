using System;
using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201703151007)]
    public class _201703151007_insert_into_sfc_procesos_t: FluentMigrator.Migration
    {
        public override void Up()
        {
            if (Schema.Table("SFC_PROCESOS_T").Exists())
            {
                Insert.IntoTable("SFC_PROCESOS_T").Row(
                    new
                    {
                        Id_Proceso = "93",
                        Proceso_Des = "Resumen diario de solicitudes asignacion nss procesadas y rechazadas",
                        Proceso_Ejecutar = "reporte_proceso_sol_diarias",
                        Lista_OK = "_divisionadministraciondeincidentes@mail.tss2.gov.do,hector_mota@mail.tss2.gov.do",
                        Lista_ERROR = "_divisionadministraciondeincidentes@mail.tss2.gov.do,hector_mota@mail.tss2.gov.do",
                        Ult_Fecha_Act = DateTime.Now,
                        Ult_Usuario_Act = "MHERNANDEZ",
                        Is_Bitacora = "S",
                        Status = "A",
                        Lanzador = "S",
                        Registros = 5
                    }
                );

                Insert.IntoTable("SFC_PROCESOS_T").Row(
                    new
                    {
                           Id_Proceso = "94",
                           Proceso_Des = "Resumen general de solicitudes asignaciones pendientes y en evaluacion visual",
                           Proceso_Ejecutar = "reporte_general_sol_pendientes",
                           Lista_OK = "_divisionadministraciondeincidentes@mail.tss2.gov.do,hector_mota@mail.tss2.gov.do",
                           Lista_ERROR = "_divisionadministraciondeincidentes@mail.tss2.gov.do,hector_mota@mail.tss2.gov.do",
                           Ult_Fecha_Act = DateTime.Now,
                           Ult_Usuario_Act = "MHERNANDEZ",
                           Is_Bitacora = "S",
                           Status = "A",
                           Lanzador = "S",
                           Registros = 5
                       }
                   );
            }
        }

        public override void Down()
        {
            if (Schema.Table("SFC_PROCESOS_T").Exists())
            {
                Delete.FromTable("SFC_PROCESOS_T").Row(new { Id_Proceso = "93" });
                Delete.FromTable("SFC_PROCESOS_T").Row(new { Id_Proceso = "94" });
            }
        }

    }
}
