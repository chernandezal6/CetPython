using FluentMigrator;
namespace DatabaseMigrations.Migrations
{
    [Migration(201705021526)]
    public class _201705021526_sre_ciudadano_pkg: FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "sre_ciudadano_body_pkg.sql");
            Execute.Script(Framework.Configuration.ScriptDirectory() + "sre_ciudadano_spec_pkg.sql");
        }

        public override void Down()
        {
            Execute.Sql("DROP PACKAGE SUIRPLUS.SRE_CIUDADANO_PKG");
        }
    }
}
