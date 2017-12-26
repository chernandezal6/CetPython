using System;
using FluentMigrator;
namespace DatabaseMigrations.Migrations
{
    [Migration(201710191503)]
    public class _201710191503_insert_into_seg_error_t : FluentMigrator.Migration
    {
        public override void Up()
        {
            if (Schema.Schema("SUIRPLUS").Table("SEG_ERROR_T").Exists())
            {
                Insert.IntoTable("SUIRPLUS.SEG_ERROR_T").Row(new { Id_Error = "442", Error_Des = "Trabajadora posee una solicitud activa para este Empleador", Ult_Fecha_Act = DateTime.Now, Ult_Usuario_Act = "OPERACIONES" });
            }
        }
        public override void Down()
        {
            if (Schema.Schema("SUIRPLUS").Table("SEG_ERROR_T").Exists())
            {
                Delete.FromTable("SUIRPLUS.SEG_ERROR_T").Row(new { Id_error = "442" });
            }
        }
    }
}
