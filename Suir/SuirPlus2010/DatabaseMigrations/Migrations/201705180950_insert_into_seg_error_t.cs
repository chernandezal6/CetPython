using FluentMigrator;
using System;

namespace DatabaseMigrations.Migrations
{
    [Migration(201705180950)]
    public class _201705180950_insert_into_seg_error_t: FluentMigrator.Migration
    {        
        public override void Up()
        {
            if (Schema.Schema("SUIRPLUS").Table("SEG_ERROR_T").Exists())
            {
                Insert.IntoTable("SEG_ERROR_T").InSchema("SUIRPLUS").Row(new { Id_Error = "430", Error_Des = "Usuario inactivo, favor comunicarse con nuestra área de mesa de ayuda o <br>contactar a la Dirección de atención al empleador DAE al 809-472-6363.", Ult_Fecha_Act = DateTime.Now, Ult_Usuario_Act = "OPERACIONES" });
            }
        }

        public override void Down()
        {
            if (Schema.Schema("SUIRPLUS").Table("SEG_ERROR_T").Exists())
            {
                Delete.FromTable("SEG_ERROR_T").InSchema("SUIRPLUS").Row(new { Id_error = "430" });
            }
        }
    }
}
