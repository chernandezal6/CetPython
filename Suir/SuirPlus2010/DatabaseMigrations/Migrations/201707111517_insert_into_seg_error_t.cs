using System;
using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201707111517)]
    public class _201707111517_insert_into_seg_error_t:FluentMigrator.Migration
    {
      public override void Up()
        {
            if (Schema.Schema("SUIRPLUS").Table("SEG_ERROR_T").Exists())
            {
                Insert.IntoTable("SEG_ERROR_T").InSchema("SUIRPLUS").Row(new { Id_Error = "US001", Error_Des = "Los datos suministrados son incorrectos , favor verificar o contactar a la dirección de atención al empleador DAE al 809-472-6363", Ult_Fecha_Act = DateTime.Now, Ult_Usuario_Act = "MHERNANDEZ" });
            }
        }

        public override void Down()
        {
            if (Schema.Schema("SUIRPLUS").Table("SEG_ERROR_T").Exists())
            {
                Delete.FromTable("SEG_ERROR_T").InSchema("SUIRPLUS").Row(new { Id_Error = "US001" });
            }
        }
    }
}
