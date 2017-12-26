using System;
using FluentMigrator;
namespace DatabaseMigrations.Migrations
{
    [Migration(201722091038)]
    public class _201722091038_insert_into_seg_error_t : FluentMigrator.Migration
    {
        public override void Up()
        {
            if (Schema.Schema("SUIRPLUS").Table("SEG_ERROR_T").Exists())
            {
                Insert.IntoTable("SUIRPLUS.SEG_ERROR_T").Row(new { Id_Error = "WS022", Error_Des = "NSS inválido", Ult_Fecha_Act = DateTime.Now, Ult_Usuario_Act = "OPERACIONES" });
            }
        }
        public override void Down()
        {
            if (Schema.Schema("SUIRPLUS").Table("SEG_ERROR_T").Exists())
            {
                Delete.FromTable("SUIRPLUS.SEG_ERROR_T").Row(new { Id_error = "WS022" });
            }
        }
    }
}
