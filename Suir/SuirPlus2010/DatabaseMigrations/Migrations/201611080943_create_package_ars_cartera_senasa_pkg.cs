using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201611080943)]
    public class _201611080943_create_package_ars_cartera_senasa_pkg: FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "ars_cartera_senasa_body_pkg.sql");
            Execute.Script(Framework.Configuration.ScriptDirectory() + "ars_cartera_senasa_spec_pkg.sql");
        }

        public override void Down()
        {
            Execute.Sql("DROP PACKAGE ARS_CARTERA_SENASA_PKG");
        }
    }
}