using System;
using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
   

    [Migration(201704051114)]
    public class _201704051114_insert_into_seg_seccion_t : FluentMigrator.Migration
    {
        public override void Up()
        {
            if (Schema.Table("SEG_SECCION_T").Exists())
            {
                Insert.IntoTable("SEG_SECCION_T").Row(new { ID_SECCION = 76, SECCION_DES = "WebServices", ULT_FECHA_ACT = DateTime.Now, ULT_USUARIO_ACT = "OPERACIONES" });

            }
        }

        public override void Down()
        {
            if (Schema.Table("SEG_SECCION_T").Exists())
            {
              
            }
        }
    }
}