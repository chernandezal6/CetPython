using FluentMigrator;
using System;
namespace DatabaseMigrations.Migrations
{
    [Migration(201706261705)]
    public class _201706261705_insert_into_rpn_regimen_t:FluentMigrator.Migration
    {
        public override void Up()
        {
            if (Schema.Schema("SUIRPLUS").Table("RPN_REGIMEN_T").Exists())
            {
                Insert.IntoTable("SUIRPLUS.RPN_REGIMEN_T").Row(new { Id_regimen = 1, Descripcion = "Pensionados Policia Nacional", Id_Param_Capita = "618", id_param_contribucion = "615", ID_PARAM_APORTE_DIRECTOS = "621", ID_PARAM_APORTE_ADICIONALES = "624", Ult_Fecha_Act = DateTime.Now, Ult_Usuario_Act = "OPERACIONES" });

                Insert.IntoTable("SUIRPLUS.RPN_REGIMEN_T").Row(new { Id_regimen = 2, Descripcion = "Pensionados Sector Salud", Id_Param_Capita = "619", id_param_contribucion = "616" , ID_PARAM_APORTE_DIRECTOS = "622", ID_PARAM_APORTE_ADICIONALES = "625", Ult_Fecha_Act = DateTime.Now, Ult_Usuario_Act = "OPERACIONES" });

                Insert.IntoTable("SUIRPLUS.RPN_REGIMEN_T").Row(new { Id_regimen = 3, Descripcion = "Pensionados Fuerzas Armadas", Id_Param_Capita = "620", id_param_contribucion = "617", ID_PARAM_APORTE_DIRECTOS = "623", ID_PARAM_APORTE_ADICIONALES = "626", Ult_Fecha_Act = DateTime.Now, Ult_Usuario_Act = "OPERACIONES" });
            }

        }
        public override void Down()
        {
            if (Schema.Schema("SUIRPLUS").Table("RPN_REGIMEN_T").Exists())
            {
                Delete.FromTable("SUIRPLUS.RPN_REGIMEN_T").Row(new { Id_regimen = 1 });

                Delete.FromTable("SUIRPLUS.RPN_REGIMEN_T").Row(new { Id_regimen = 2 });

                Delete.FromTable("SUIRPLUS.RPN_REGIMEN_T").Row(new { Id_regimen = 3 });
            }
        }
    }
}
