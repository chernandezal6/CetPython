using FluentMigrator;
using System;
namespace DatabaseMigrations.Migrations
{
    [Migration(201705241029)]
    public class _201705241029_insert_into_seg_error_t : FluentMigrator.Migration
    {
        public override void Up()
        {
            if (Schema.Table("SEG_ERROR_T").Exists())
            {
                Insert.IntoTable("SEG_ERROR_T").InSchema("SUIRPLUS").Row(new { Id_Error = "573", Error_Des = "Este rol ya fue asignado a esta certificación", Ult_Fecha_Act = DateTime.Now, Ult_Usuario_Act = "OPERACIONES" });
            }
        }

        public override void Down()
        {
            if (Schema.Table("SEG_ERROR_T").Exists())
            {
                Delete.FromTable("SEG_ERROR_T").InSchema("SUIRPLUS").Row(new { Id_error = "573" });
            }
        }
    }
}
