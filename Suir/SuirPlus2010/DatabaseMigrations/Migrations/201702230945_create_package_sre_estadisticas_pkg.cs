using FluentMigrator;
namespace DatabaseMigrations.Migrations
{
    [Migration(201702230945)]
    public class _201702230945_create_package_sre_estadisticas_pkg : FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "sre_estadisticas_spec_pkg.sql");
            Execute.Script(Framework.Configuration.ScriptDirectory() + "sre_estadisticas_body_pkg.sql");
        }

        public override void Down()
        {
            Execute.Sql("DROP PACKAGE SRE_ESTADISTICAS_PKG");
        }
    }
}
