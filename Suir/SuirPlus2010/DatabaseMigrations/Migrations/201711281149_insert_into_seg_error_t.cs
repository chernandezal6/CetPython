using System;
using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201711281149)]
    public class _201711281149_insert_into_seg_error_t:FluentMigrator.Migration
    {
        public override void Up()
        {
            if (Schema.Schema("SUIRPLUS").Table("SEG_ERROR_T").Exists())
            {
                Insert.IntoTable("SUIRPLUS.SEG_ERROR_T").Row(new { Id_Error = "PY2", Error_Des = "Error procesando el archivo.", Ult_Fecha_Act = DateTime.Now, Ult_Usuario_Act = "OPERACIONES" });
            }
        }

        public override void Down()
        {
            if (Schema.Schema("SUIRPLUS").Table("SEG_ERROR_T").Exists())
            {
                Delete.FromTable("SUIRPLUS.SEG_ERROR_T").Row(new { Id_error = "PY2" });
             
            }
        }
    }
}
