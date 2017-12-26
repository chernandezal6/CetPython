using FluentMigrator;
using System;

namespace DatabaseMigrations.Migrations
{
    [Migration(201702020509)]
    public class _201702020509_insert_into_sfc_procesos_t: FluentMigrator.Migration
    {
        public override void Up()
        {
            if (Schema.Table("SFC_PROCESOS_T").Exists())
            {
                Insert.IntoTable("SFC_PROCESOS_T").Row(
                    new
                    {
                        Id_Proceso = "52",
                        Proceso_Des = "Sincronizacion de dgii_isr_status_local_t",
                        Proceso_Ejecutar = "DGII_ISR_STATUS_PRC",
                        Lista_OK = "_operaciones@mail.tss2.gov.do",
                        Lista_ERROR = "_operaciones@mail.tss2.gov.do",
                        Ult_Fecha_Act = DateTime.Now,
                        Ult_Usuario_Act = "GHERRERA",
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
                Delete.FromTable("SFC_PROCESOS_T").Row(new { Id_Proceso = "52" });
            }
        }
    }
}
