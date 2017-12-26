using System;
using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201702281130)]
    public class _201702281130_insert_into_sfc_procesos_t: FluentMigrator.Migration
    {
        public override void Up()
        {
            if (Schema.Table("SFC_PROCESOS_T").Exists())
            {
                Insert.IntoTable("SFC_PROCESOS_T").Row(
                    new
                    {
                        Id_Proceso = "RP",
                        Proceso_Des = "Proceso de validacion Cartera Regimen Pensionados",
                        Proceso_Ejecutar = "RPN_PROC_CARTERA_PENSIONADOS_P",
                        Lista_OK = "_operaciones@mail.tss2.gov.do",
                        Lista_ERROR = "_operaciones@mail.tss2.gov.do",
                        Ult_Fecha_Act = DateTime.Now,
                        Ult_Usuario_Act = "GHERRERA",
                        Is_Bitacora = "S",
                        Status = "A",
                        Lanzador = "S",
                        Proceso_validar = "#operaciones",
                        Registros = 5
                    }
                );
            }
        }

        public override void Down()
        {
            if (Schema.Table("SFC_PROCESOS_T").Exists())
            {
                Delete.FromTable("SFC_PROCESOS_T").Row(new { Id_Proceso = "RP" });
            }
        }
    }
}