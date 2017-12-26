using FluentMigrator;
using System;
using SuirPlusEF.Framework;

namespace DatabaseMigrations.Migrations
{
    [Migration(201612210937)]
   public class _201612210937_insert_into_seg_captcha_t : FluentMigrator.Migration
    {        
        public override void Up()
        {
            if (Schema.Table("SEG_CAPTCHA_T").Exists())
            {
                Insert.IntoTable("SEG_CAPTCHA_T").Row(new {
                    ID = 1,
                    DESCRIPCION = "CAPTCHA PARA LA CONSULTA DE PAGOS EN EXCESOS POR CIUDADANOS",
                    URL = "/SYS/CONSPAGOSEXCESOSCIUDADANOS",
                    ESTATUS = "A",
                    COLETILLA = "OPERACIONES" + "," + DateTime.Now
                });
            }
        }
        public override void Down()
        {

            if (Schema.Table("SEG_CAPTCHA_T").Exists())
            {
                Delete.FromTable("SEG_CAPTCHA_T").Row(new { Id = "1" });
            }
        }
    }
}
