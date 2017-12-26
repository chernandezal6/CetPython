using System;
using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201703241535)]
    public class _201703241535_insert_into_sfc_det_parametro_t: FluentMigrator.Migration
    {
        public override void Up()
        {
            if (Schema.Schema("SUIRPLUS").Table("SFC_DET_PARAMETRO_T").Exists())
            {
                Insert.IntoTable("SFC_DET_PARAMETRO_T").InSchema("SUIRPLUS").Row(
                    new
                    {
                        Id_Parametro = "407",
                        Fecha_Ini = DateTime.Now,
                        Valor_Numerico = 500000,
                        Autorizado = "S",
                        Ult_Fecha_Act = DateTime.Now,
                        Ult_Usuario_Act = "GHERRERA"
                    }
                );

                Insert.IntoTable("SFC_DET_PARAMETRO_T").InSchema("SUIRPLUS").Row(
                    new
                    {
                        Id_Parametro = "408",
                        Fecha_Ini = DateTime.Now,
                        Valor_Numerico = 5,
                        Autorizado = "S",
                        Ult_Fecha_Act = DateTime.Now,
                        Ult_Usuario_Act = "GHERRERA"
                    }
                );
            }
        }

        public override void Down()
        {
            if (Schema.Schema("SUIRPLUS").Table("SFC_DET_PARAMETRO_T").Exists())
            {
                Delete.FromTable("SFC_DET_PARAMETRO_T").InSchema("SUIRPLUS").Row(new { Id_Parametro = "407" });
                Delete.FromTable("SFC_DET_PARAMETRO_T").InSchema("SUIRPLUS").Row(new { Id_Parametro = "408" });
            }
        }
    }
}