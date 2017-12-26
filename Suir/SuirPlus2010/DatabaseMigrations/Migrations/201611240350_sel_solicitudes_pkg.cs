using System;
using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201611240350)]
    public class _201611240350_update_sel_solicitudes_pkg : FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "sel_solicitudes_spec_pkg.sql");
            Execute.Script(Framework.Configuration.ScriptDirectory() + "sel_solicitudes_body_pkg.sql");
        }

        public override void Down()
        {
            Execute.Sql("DROP PACKAGE SEL_SOLICITUDES_PKG");
        }
    }
}
