using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201703291224)]
    public class _201703291224_create_package_sfc_ir13_pkg: FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "sfc_ir13_body_pkg.sql");
        }

        public override void Down()
        {
            Execute.Sql("DROP PACKAGE SFC_IR13_PKG");
        }
    }
}