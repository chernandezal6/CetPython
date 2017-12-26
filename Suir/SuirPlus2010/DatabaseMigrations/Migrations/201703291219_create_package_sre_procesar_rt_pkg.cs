using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201703291219)]
    public class _201703291219_create_package_sre_procesar_rt_pkg: FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "sre_procesar_rt_body_pkg.sql");
        }

        public override void Down()
        {
            Execute.Sql("DROP PACKAGE SRE_PROCESAR_RT_PKG");
        }
    }
}