using FluentMigrator;
using System;

namespace DatabaseMigrations.Migrations
{
    [Migration(201612211005)]
    public class _201612211005_insert_into_seg_det_captcha_t : FluentMigrator.Migration
    {
        public override void Up()
        {
            if (Schema.Table("SEG_DET_CAPTCHA_T").Exists())
            {
                Insert.IntoTable("SEG_DET_CAPTCHA_T").Row(new {
                    ID = 1,
                    ID_MASTER = "1",
                    PREGUNTA = "¿CUAL ES SU FECHA DE NACIMIENTO?",
                    TIPO_INPUT = "D",
                    ESTATUS = "A",
                    ORIGEN_RESPUESTA ="SRE_CIUDADANOS_T",
                    CAMPO_RESPUESTA = "FECHA_NACIMIENTO",
                    COLETILLA = "OPERACIONES" + "," + DateTime.Now
                });

                 Insert.IntoTable("SEG_DET_CAPTCHA_T").Row(new {
                     ID = 2,
                     ID_MASTER = "1",
                    PREGUNTA = "¿CUAL ES SU PRIMER APELLIDO?",
                    TIPO_INPUT = "C",
                    ESTATUS = "A",
                    ORIGEN_RESPUESTA ="SRE_CIUDADANOS_T",
                    CAMPO_RESPUESTA = "PRIMER_APELLIDO",
                    COLETILLA = "OPERACIONES" + "," + DateTime.Now
                });
            }
        }
        public override void Down()
        {

            if (Schema.Table("SEG_DET_CAPTCHA_T").Exists())
            {
                Delete.FromTable("SEG_DET_CAPTCHA_T").Row(new { Id = "1" });
                Delete.FromTable("SEG_DET_CAPTCHA_T").Row(new { Id = "2" });

            }
        }
    }
}
