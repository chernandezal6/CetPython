using System;
using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201705171109)]
    public class _201705171109_sre_load_movimiento_pkg : FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "sre_load_movimiento_pkg.sql");
        }

        public override void Down()
        {
            Execute.Sql("DROP PACKAGE SUIRPLUS.SRE_LOAD_MOVIMIENTO_PKG");
        }
    }
}
