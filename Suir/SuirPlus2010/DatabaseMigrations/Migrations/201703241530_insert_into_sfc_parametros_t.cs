using System;
using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201703241530)]
    public class _201703241530_insert_into_sfc_parametros_t: FluentMigrator.Migration
    {
        public override void Up()
        {
            if (Schema.Schema("SUIRPLUS").Table("SFC_PARAMETROS_T").Exists())
            {
                Insert.IntoTable("SFC_PARAMETROS_T").InSchema("SUIRPLUS").Row(
                    new
                    {
                        Id_Parametro = "407",
                        Parametro_Des = "REGISTROS MINIMOS PUBLICADOS EN VISTA DIARIA DEPENDIENTES ADICIONALES",
                        Tipo_Parametro = "N",
                        Ult_Fecha_Act = DateTime.Now,
                        Ult_Usuario_Act = "GHERRERA",
                        Id_Aplicacion = "SS",
                        Id_Renglon = "SFS",
                        Id_Name = "VISTA_DEPENDIENTE_ADICIONAL"
                    }
                );

                Insert.IntoTable("SFC_PARAMETROS_T").InSchema("SUIRPLUS").Row(
                    new
                    {
                        Id_Parametro = "408",
                        Parametro_Des = "DIA A PARTIR DEL CUAL SE REFRESCA LA VISTA DIARIA DEPENDIENTES ADICIONALES",
                        Tipo_Parametro = "N",
                        Ult_Fecha_Act = DateTime.Now,
                        Ult_Usuario_Act = "GHERRERA",
                        Id_Aplicacion = "SS",
                        Id_Renglon = "SFS",
                        Id_Name = "VISTA_DEPENDIENTE_ADICIONAL"
                    }
                );
            }
        }

        public override void Down()
        {
            if (Schema.Schema("SUIRPLUS").Table("SFC_PARAMETROS_T").Exists())
            {
                Delete.FromTable("SFC_PARAMETROS_T").InSchema("SUIRPLUS").Row(new { Id_Parametro = "407" });
                Delete.FromTable("SFC_PARAMETROS_T").InSchema("SUIRPLUS").Row(new { Id_Parametro = "408" });
            }
        }
    }
}