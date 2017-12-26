using System;
using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201611171030)]
    public class _201611171030_update_srp_procesos_pkg : FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "srp_procesos_body_pkg.sql");
        }

        public override void Down()
        {
            Execute.Sql("DROP PACKAGE SRP_PROCESOS_BODY_PKG");
        }
    }
}
