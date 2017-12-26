using System;
using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201706261700)]
    public class _201706261700_insert_into_sfc_det_parametro_t:FluentMigrator.Migration
    {
        public override void Up()
        {
            if (Schema.Schema("SUIRPLUS").Table("SFC_DET_PARAMETRO_T").Exists())
            {
                Insert.IntoTable("SUIRPLUS.SFC_DET_PARAMETRO_T").Row(new { ID_PARAMETRO = "615", FECHA_INI = "01-nov-2016", VALOR_FECHA = "", VALOR_NUMERICO = "6.3", VALOR_TEXTO = "", AUTORIZADO = "S", ULT_FECHA_ACT = DateTime.Now, ULT_USUARIO_ACT = "MHERNANDEZ", MOTIVO_PRORROGA = "" });
                Insert.IntoTable("SUIRPLUS.SFC_DET_PARAMETRO_T").Row(new { ID_PARAMETRO = "616", FECHA_INI = "16-dec-2016", VALOR_FECHA = "", VALOR_NUMERICO = "6.4", VALOR_TEXTO = "", AUTORIZADO = "S", ULT_FECHA_ACT = DateTime.Now, ULT_USUARIO_ACT = "MHERNANDEZ", MOTIVO_PRORROGA = "" });
                Insert.IntoTable("SUIRPLUS.SFC_DET_PARAMETRO_T").Row(new { ID_PARAMETRO = "617", FECHA_INI = "11-may-2017", VALOR_FECHA = "", VALOR_NUMERICO = "6.3", VALOR_TEXTO = "", AUTORIZADO = "S", ULT_FECHA_ACT = DateTime.Now, ULT_USUARIO_ACT = "MHERNANDEZ", MOTIVO_PRORROGA = "" });
                Insert.IntoTable("SUIRPLUS.SFC_DET_PARAMETRO_T").Row(new { ID_PARAMETRO = "618", FECHA_INI = "01-nov-2016", VALOR_FECHA = "", VALOR_NUMERICO = "700.00", VALOR_TEXTO = "", AUTORIZADO = "S", ULT_FECHA_ACT = DateTime.Now, ULT_USUARIO_ACT = "MHERNANDEZ", MOTIVO_PRORROGA = "" });
                Insert.IntoTable("SUIRPLUS.SFC_DET_PARAMETRO_T").Row(new { ID_PARAMETRO = "619", FECHA_INI = "16-dec-2016", VALOR_FECHA = "", VALOR_NUMERICO = "1200.00", VALOR_TEXTO = "", AUTORIZADO = "S", ULT_FECHA_ACT = DateTime.Now, ULT_USUARIO_ACT = "MHERNANDEZ", MOTIVO_PRORROGA = "" });
                Insert.IntoTable("SUIRPLUS.SFC_DET_PARAMETRO_T").Row(new { ID_PARAMETRO = "620", FECHA_INI = "11-may-2017", VALOR_FECHA = "", VALOR_NUMERICO = "700.00", VALOR_TEXTO = "", AUTORIZADO = "S", ULT_FECHA_ACT = DateTime.Now, ULT_USUARIO_ACT = "MHERNANDEZ", MOTIVO_PRORROGA = "" });
                Insert.IntoTable("SUIRPLUS.SFC_DET_PARAMETRO_T").Row(new { ID_PARAMETRO = "621", FECHA_INI = "01-nov-2016", VALOR_FECHA = "", VALOR_NUMERICO = "700.00", VALOR_TEXTO = "", AUTORIZADO = "S", ULT_FECHA_ACT = DateTime.Now, ULT_USUARIO_ACT = "MHERNANDEZ", MOTIVO_PRORROGA = "" });
                Insert.IntoTable("SUIRPLUS.SFC_DET_PARAMETRO_T").Row(new { ID_PARAMETRO = "622", FECHA_INI = "16-dec-2016", VALOR_FECHA = "", VALOR_NUMERICO = "700.00", VALOR_TEXTO = "", AUTORIZADO = "S", ULT_FECHA_ACT = DateTime.Now, ULT_USUARIO_ACT = "MHERNANDEZ", MOTIVO_PRORROGA = "" });
                Insert.IntoTable("SUIRPLUS.SFC_DET_PARAMETRO_T").Row(new { ID_PARAMETRO = "623", FECHA_INI = "11-may-2017", VALOR_FECHA = "", VALOR_NUMERICO = "700.00", VALOR_TEXTO = "", AUTORIZADO = "S", ULT_FECHA_ACT = DateTime.Now, ULT_USUARIO_ACT = "MHERNANDEZ", MOTIVO_PRORROGA = "" });
                Insert.IntoTable("SUIRPLUS.SFC_DET_PARAMETRO_T").Row(new { ID_PARAMETRO = "624", FECHA_INI = "01-nov-2016", VALOR_FECHA = "", VALOR_NUMERICO = "700.00", VALOR_TEXTO = "", AUTORIZADO = "S", ULT_FECHA_ACT = DateTime.Now, ULT_USUARIO_ACT = "MHERNANDEZ", MOTIVO_PRORROGA = "" });
                Insert.IntoTable("SUIRPLUS.SFC_DET_PARAMETRO_T").Row(new { ID_PARAMETRO = "625", FECHA_INI = "16-dec-2016", VALOR_FECHA = "", VALOR_NUMERICO = "700.00", VALOR_TEXTO = "", AUTORIZADO = "S", ULT_FECHA_ACT = DateTime.Now, ULT_USUARIO_ACT = "MHERNANDEZ", MOTIVO_PRORROGA = "" });
                Insert.IntoTable("SUIRPLUS.SFC_DET_PARAMETRO_T").Row(new { ID_PARAMETRO = "626", FECHA_INI = "11-may-2017", VALOR_FECHA = "", VALOR_NUMERICO = "700.00", VALOR_TEXTO = "", AUTORIZADO = "S", ULT_FECHA_ACT = DateTime.Now, ULT_USUARIO_ACT = "MHERNANDEZ", MOTIVO_PRORROGA = "" });
            }
        }
        public override void Down()
        {
            if (Schema.Schema("SUIRPLUS").Table("SFC_DET_PARAMETRO_T").Exists())
            {
                Delete.FromTable("SUIRPLUS.SFC_DET_PARAMETRO_T").Row(new { ID_PARAMETRO = "615" });
                Delete.FromTable("SUIRPLUS.SFC_DET_PARAMETRO_T").Row(new { ID_PARAMETRO = "616" });
                Delete.FromTable("SUIRPLUS.SFC_DET_PARAMETRO_T").Row(new { ID_PARAMETRO = "617" });
                Delete.FromTable("SUIRPLUS.SFC_DET_PARAMETRO_T").Row(new { ID_PARAMETRO = "618" });
                Delete.FromTable("SUIRPLUS.SFC_DET_PARAMETRO_T").Row(new { ID_PARAMETRO = "619" });
                Delete.FromTable("SUIRPLUS.SFC_DET_PARAMETRO_T").Row(new { ID_PARAMETRO = "620" });
                Delete.FromTable("SUIRPLUS.SFC_DET_PARAMETRO_T").Row(new { ID_PARAMETRO = "621" });
                Delete.FromTable("SUIRPLUS.SFC_DET_PARAMETRO_T").Row(new { ID_PARAMETRO = "622" });
                Delete.FromTable("SUIRPLUS.SFC_DET_PARAMETRO_T").Row(new { ID_PARAMETRO = "623" });
                Delete.FromTable("SUIRPLUS.SFC_DET_PARAMETRO_T").Row(new { ID_PARAMETRO = "624" });
                Delete.FromTable("SUIRPLUS.SFC_DET_PARAMETRO_T").Row(new { ID_PARAMETRO = "625" });
                Delete.FromTable("SUIRPLUS.SFC_DET_PARAMETRO_T").Row(new { ID_PARAMETRO = "626" });

            }
        }
    }
}
