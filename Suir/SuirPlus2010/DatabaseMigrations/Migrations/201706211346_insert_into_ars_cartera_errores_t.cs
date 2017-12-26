using System;
using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201706211346)]
    public class _201706211346_insert_into_ars_cartera_errores_t :FluentMigrator.Migration
    {
        public override void Up()
        {
            if (Schema.Schema("SUIRPLUS").Table("ARS_CARTERA_ERRORES_T").Exists())
            {
                Insert.IntoTable("SUIRPLUS.ARS_CARTERA_ERRORES_T").Row(new { Id_error = "75", Error_des = "Trabajador activo en nómina." });                
            }

        }
        public override void Down()
        {
            if (Schema.Schema("SUIRPLUS").Table("ARS_CARTERA_ERRORES_T").Exists())
            {
                Delete.FromTable("SUIRPLUS.ARS_CARTERA_ERRORES_T").Row(new { Id_error = "75" });                
            }
        }
    }
}
