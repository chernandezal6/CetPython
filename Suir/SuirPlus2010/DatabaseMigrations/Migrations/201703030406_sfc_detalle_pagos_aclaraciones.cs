using FluentMigrator;

namespace DatabaseMigrations.Migrations
{[Migration(201703030406)]
    public class _201703030406_sfc_detalle_pagos_aclaraciones:FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "sfc_detalle_pagos_aclaraciones.sql");
            
        }

        public override void Down()
        {
            Execute.Sql("DROP PROCEDURE sfc_detalle_pagos_aclaraciones");
        }
    }
}
