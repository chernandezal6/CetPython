using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201705221019)]
    public class _201705221019_sre_empleadores_pkg: FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "sre_empleadores_body_pkg.sql");
        }

        public override void Down()
        {
            Execute.Sql("DROP PACKAGE SRE_EMPLEADORES_PKG");
        }
    }
}
