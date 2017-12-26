using System;
using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201704040449)]
    public class _201704040449_insert_into_seg_error_t: FluentMigrator.Migration
    {
        public override void Up()
        {
            if (Schema.Table("SEG_ERROR_T").Exists())
            {
                Insert.IntoTable("SEG_ERROR_T").Row(new { ID_ERROR = "NOV001", ERROR_DES = "La fecha de la novedad no debe ser mayor a 30 dias calendario", ULT_FECHA_ACT = DateTime.Now, ULT_USUARIO_ACT = "CHERNANDEZ" });
            }
        }

        public override void Down()
        {
            if (Schema.Table("SEG_ERROR_T").Exists())
            {
                Delete.FromTable("SEG_ERROR_T").Row(new { ID_ERROR = "NOV001" });
            }
        }
    }
}
