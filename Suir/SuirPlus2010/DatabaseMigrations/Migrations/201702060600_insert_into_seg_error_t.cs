using FluentMigrator;
using System;

namespace DatabaseMigrations.Migrations
{
    [Migration(201702060600)]
    public class _201702060600_insert_into_seg_error_t: FluentMigrator.Migration
    {
        public override void Up()
        {
            if (Schema.Table("SEG_ERROR_T").Exists())
            {
                Insert.IntoTable("SEG_ERROR_T").Row(new { Id_Error = "MON001", Error_Des = "El salario reportado es mayor al máximo permitido.", Ult_Fecha_Act = DateTime.Now, Ult_Usuario_Act = "OPERACIONES" });
            }
        }

        public override void Down()
        {
            if (Schema.Table("SEG_ERROR_T").Exists())
            {
                Delete.FromTable("SEG_ERROR_T").Row(new { Id_error = "MON001" });
            }
        }
    }
}