using System;
using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201703241201)]
    public class _201703241201_insert_into_sfc_procesos_t: FluentMigrator.Migration
    {
        public override void Up()
        {
            if (Schema.Schema("SUIRPLUS").Table("SFC_PROCESOS_T").Exists())
            {
                Insert.IntoTable("SFC_PROCESOS_T").InSchema("SUIRPLUS").Row(
                    new
                    {
                        Id_Proceso = "AA",
                        Proceso_Des = "Proceso de actualizacion Dependientes Adicionales",
                        Proceso_Ejecutar = "ARS_ACTUALIZA_DEP_ADICIONALES",
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

                Insert.IntoTable("SFC_PROCESOS_T").InSchema("SUIRPLUS").Row(
                    new
                    {
                        Id_Proceso = "BA",
                        Proceso_Des = "Proceso de baja Dependientes Adicionales",
                        Proceso_Ejecutar = "ARS_BAJA_DEP_ADICIONALES",
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
            if (Schema.Schema("SUIRPLUS").Table("SFC_PROCESOS_T").Exists())
            {
                Delete.FromTable("SFC_PROCESOS_T").InSchema("SUIRPLUS").Row(new { Id_Proceso = "AA" });
                Delete.FromTable("SFC_PROCESOS_T").InSchema("SUIRPLUS").Row(new { Id_Proceso = "BA" });
            }
        }
    }
}