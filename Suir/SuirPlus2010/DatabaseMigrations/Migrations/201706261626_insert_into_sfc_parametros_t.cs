using System;
using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201706261626)]
    public class _201706261626_insert_into_sfc_parametros_t:FluentMigrator.Migration
    {
            public override void Up()
            {
                if (Schema.Schema("SUIRPLUS").Table("SFC_PARAMETROS_T").Exists())
                {
                    Insert.IntoTable("SUIRPLUS.SFC_PARAMETROS_T").Row(new { ID_PARAMETRO = "615", PARAMETRO_DES = "Contribucion Pensionados Policia Nacional", TIPO_PARAMETRO = "N", ULT_FECHA_ACT = DateTime.Now, ULT_USUARIO_ACT = "MHERNANDEZ" });
                    Insert.IntoTable("SUIRPLUS.SFC_PARAMETROS_T").Row(new { ID_PARAMETRO = "616", PARAMETRO_DES = "Contribucion Pensionados Sector Salud", TIPO_PARAMETRO = "N", ULT_FECHA_ACT = DateTime.Now, ULT_USUARIO_ACT = "MHERNANDEZ" });
                    Insert.IntoTable("SUIRPLUS.SFC_PARAMETROS_T").Row(new { ID_PARAMETRO = "617", PARAMETRO_DES = "Contribucion Pensionados Fuerzas Armadas", TIPO_PARAMETRO = "N", ULT_FECHA_ACT = DateTime.Now, ULT_USUARIO_ACT = "MHERNANDEZ" });
                    Insert.IntoTable("SUIRPLUS.SFC_PARAMETROS_T").Row(new { ID_PARAMETRO = "618", PARAMETRO_DES = "Capita Adicional Pensionados Policia Nacional", TIPO_PARAMETRO = "N", ULT_FECHA_ACT = DateTime.Now, ULT_USUARIO_ACT = "MHERNANDEZ" });
                    Insert.IntoTable("SUIRPLUS.SFC_PARAMETROS_T").Row(new { ID_PARAMETRO = "619", PARAMETRO_DES = "Capita Adicional Pensionados Sector Salud", TIPO_PARAMETRO = "N", ULT_FECHA_ACT = DateTime.Now, ULT_USUARIO_ACT = "MHERNANDEZ" });
                    Insert.IntoTable("SUIRPLUS.SFC_PARAMETROS_T").Row(new { ID_PARAMETRO = "620", PARAMETRO_DES = "Capita Adicional Pensionados Fuerzas Armadas", TIPO_PARAMETRO = "N", ULT_FECHA_ACT = DateTime.Now, ULT_USUARIO_ACT = "MHERNANDEZ" });
                    Insert.IntoTable("SUIRPLUS.SFC_PARAMETROS_T").Row(new { ID_PARAMETRO = "621", PARAMETRO_DES = "Aporte directo Pensionados Policia Nacional", TIPO_PARAMETRO = "N", ULT_FECHA_ACT = DateTime.Now, ULT_USUARIO_ACT = "MHERNANDEZ" });
                    Insert.IntoTable("SUIRPLUS.SFC_PARAMETROS_T").Row(new { ID_PARAMETRO = "622", PARAMETRO_DES = "Aporte directo Pensionados Sector Salud", TIPO_PARAMETRO = "N", ULT_FECHA_ACT = DateTime.Now, ULT_USUARIO_ACT = "MHERNANDEZ" });
                    Insert.IntoTable("SUIRPLUS.SFC_PARAMETROS_T").Row(new { ID_PARAMETRO = "623", PARAMETRO_DES = "Aporte directo Pensionados Fuerzas Armadas", TIPO_PARAMETRO = "N", ULT_FECHA_ACT = DateTime.Now, ULT_USUARIO_ACT = "MHERNANDEZ" });
                    Insert.IntoTable("SUIRPLUS.SFC_PARAMETROS_T").Row(new { ID_PARAMETRO = "624", PARAMETRO_DES = "Aporte dependiente Adicional Pensionados Policia Nacional", TIPO_PARAMETRO = "N", ULT_FECHA_ACT = DateTime.Now, ULT_USUARIO_ACT = "MHERNANDEZ" });
                    Insert.IntoTable("SUIRPLUS.SFC_PARAMETROS_T").Row(new { ID_PARAMETRO = "625", PARAMETRO_DES = "Aporte dependiente Adicional Pensionados Sector Salud", TIPO_PARAMETRO = "N", ULT_FECHA_ACT = DateTime.Now, ULT_USUARIO_ACT = "MHERNANDEZ" });
                    Insert.IntoTable("SUIRPLUS.SFC_PARAMETROS_T").Row(new { ID_PARAMETRO = "626", PARAMETRO_DES = "Aporte dependiente Adicional Pensionados Fuerzas Armadas", TIPO_PARAMETRO = "N", ULT_FECHA_ACT = DateTime.Now, ULT_USUARIO_ACT = "MHERNANDEZ" });
                    
            }
            }
        public override void Down()
        {
            if (Schema.Schema("SUIRPLUS").Table("SFC_PARAMETROS_T").Exists())
            {
                Delete.FromTable("SUIRPLUS.SFC_PARAMETROS_T").Row(new { ID_PARAMETRO = "615" });
                Delete.FromTable("SUIRPLUS.SFC_PARAMETROS_T").Row(new { ID_PARAMETRO = "616" });
                Delete.FromTable("SUIRPLUS.SFC_PARAMETROS_T").Row(new { ID_PARAMETRO = "617" });
                Delete.FromTable("SUIRPLUS.SFC_PARAMETROS_T").Row(new { ID_PARAMETRO = "618" });
                Delete.FromTable("SUIRPLUS.SFC_PARAMETROS_T").Row(new { ID_PARAMETRO = "619" });
                Delete.FromTable("SUIRPLUS.SFC_PARAMETROS_T").Row(new { ID_PARAMETRO = "620" });
                Delete.FromTable("SUIRPLUS.SFC_PARAMETROS_T").Row(new { ID_PARAMETRO = "621" });
                Delete.FromTable("SUIRPLUS.SFC_PARAMETROS_T").Row(new { ID_PARAMETRO = "622" });
                Delete.FromTable("SUIRPLUS.SFC_PARAMETROS_T").Row(new { ID_PARAMETRO = "623" });
                Delete.FromTable("SUIRPLUS.SFC_PARAMETROS_T").Row(new { ID_PARAMETRO = "624" });
                Delete.FromTable("SUIRPLUS.SFC_PARAMETROS_T").Row(new { ID_PARAMETRO = "625" });
                Delete.FromTable("SUIRPLUS.SFC_PARAMETROS_T").Row(new { ID_PARAMETRO = "626" });
            }
        }
    }
}
