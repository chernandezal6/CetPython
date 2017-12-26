using System;
using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201705041029)]
    public class _201705041029_insert_into_sfc_procesos_t: FluentMigrator.Migration
    {
        public override void Up()
        {
            if (Schema.Table("SFC_PROCESOS_T").Exists())
            {
                Insert.IntoTable("SFC_PROCESOS_T").Row(
                    new
                    {
                        Id_Proceso = "78",
                        Proceso_Des = "Cambiar Estatus a Solicitud Asignacion NSS",
                        Proceso_Ejecutar = "NSS_CAMBIAR_STATUS_SOLICITUD",
                        Lista_OK = "@gherrera, @cpena, @kcruz",
                        Proceso_validar = "#desarrollo",
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
                Delete.FromTable("SFC_PROCESOS_T").Row(new { Id_Proceso = "78" });
            }
        }
    }
}
