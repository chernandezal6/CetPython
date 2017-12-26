using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201703291233)]
    public class _201703291233_create_package_sre_load_movimiento_pkg: FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "sre_load_movimiento_pkg.sql");
        }

        public override void Down()
        {
            Execute.Sql("DROP PACKAGE SRE_LOAD_MOVIMIENTO_PKG");
        }
    }
}