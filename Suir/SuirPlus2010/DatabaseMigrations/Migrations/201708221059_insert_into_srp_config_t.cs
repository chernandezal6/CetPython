using System;
using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201708221059)]
    public class _201708221059_insert_into_srp_config_t : FluentMigrator.Migration
    {
        public override void Up()
        {
            if (Schema.Schema("SUIRPLUS").Table("SRP_CONFIG_T").Exists())
            {
                Insert.IntoTable("SUIRPLUS.SRP_CONFIG_T").Row(new { ID_MODULO = "HIST_DEUDA", FIELD1 = "6.00", FIELD2 = "1000000.00", FIELD3 = "30.00" });
                //Este modulo ha sido creado para el historico de deudores. El valor del field1 es la cantidad de periodos a evaluar, el field2 es el monto de referencia adeudado y el field3 es el porcentaje de reduccion de la deuda
            }
        }

        public override void Down()
        {
            if (Schema.Schema("SUIRPLUS").Table("SRP_CONFIG_T").Exists())
            {
                Delete.FromTable("SUIRPLUS.SRP_CONFIG_T").Row(new { ID_MODULO = "HIST_DEUDA" });
            }
        }
    }
}
