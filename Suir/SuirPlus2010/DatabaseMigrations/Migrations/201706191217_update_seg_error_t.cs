using System;
using FluentMigrator;

namespace DatabaseMigrations
{
    [Migration(201706191217)]
    public class _201706191217_update_seg_error_t: FluentMigrator.Migration
    {
        public override void Up()
        {
            Update.Table("SUIRPLUS.SEG_ERROR_T").Set(new { ERROR_DES = "Valor invalido o debe incluir valor en uno de los campos de Salario(SS, ISR, INFOTEP, OTROS INGRESOS, APORTE VOLUNTARIO, REMUNERACION OTROS EMPLEADORES, INGRESOS EXENTOS)" }).Where(new { ID_ERROR = "188" });
        }

        public override void Down()
        {
            Update.Table("SUIRPLUS.SEG_ERROR_T").Set(new { ERROR_DES = "Valor invalido o debe incluir valor en uno de los campos de Salario(SS, ISR o Aportes Voluntarios)" }).Where(new { ID_ERROR = "188" });
        }
    }
}
