using System;
using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201710101033)]
    public class _201710101033_update_seg_error_t:FluentMigrator.Migration
    {
      public override void Up()
        {
            if (Schema.Schema("SUIRPLUS").Table("SEG_ERROR_T").Exists())
            {
                Update.Table("SUIRPLUS.SEG_ERROR_T").Set(new { Error_Des = "La fecha estimada de parto es inválida con relación a un embarazo previamente reportado en esta u otra empresa." }).Where(new { Id_Error = "44" });
            }
        }

        public override void Down()
        {
            if (Schema.Schema("SUIRPLUS").Table("SEG_ERROR_T").Exists())
            {
                /**/
            }
        }
    }
}
