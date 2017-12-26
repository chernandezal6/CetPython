using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201612201018)]
    public class _201612201018_create_package_srp_procesos_pkg: FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "srp_procesos_spec_pkg.sql");
            Execute.Script(Framework.Configuration.ScriptDirectory() + "srp_procesos_body_pkg.sql");
        }

        public override void Down()
        {
            Execute.Sql("DROP PACKAGE SRP_PROCESOS_PKG");
        }
    }
}
