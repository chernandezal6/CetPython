using System;
using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201612200906)]
    public class _201612200906_insert_into_sfc_procesos_t : Migration
    {
        public override void Up()
        {
            if (Schema.Table("SFC_PROCESOS_T").Exists())
            {
                Insert.IntoTable("SFC_PROCESOS_T").Row(
                    new
                    {
                        Id_Proceso = "54",
                        Proceso_Des = "Genera Recargos e Intereses para Liquidaciones del INFOTEP",
                        Proceso_Ejecutar = "SFC_REC_INT_LIQ_INF_P",
                        Lista_OK = "_operaciones@mail.tss2.gov.do, dba@mail.tss2.gov.do",
                        Lista_ERROR = "_operaciones@mail.tss2.gov.do, dba@mail.tss2.gov.do",
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
                Delete.FromTable("SFC_PROCESOS_T").Row(new { Id_Proceso = "54" });
            }
        }
    }
}
