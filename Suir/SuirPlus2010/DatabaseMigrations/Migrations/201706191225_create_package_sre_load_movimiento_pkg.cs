using System;
using FluentMigrator;

namespace DatabaseMigrations
{
    [Migration(201706191225)]
    public class _201706191225_create_package_sre_load_movimiento_pkg: FluentMigrator.Migration
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
