using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201704200449)]
    public class _201704200449_wss_servicios_pkg:FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "wss_servicios_pkg.sql");
            Execute.Script(Framework.Configuration.ScriptDirectory() + "wss_servicios_body_pkg.sql");
        }

        public override void Down()
        {
            Execute.Sql("DROP PACKAGE WSS_SERVICIOS_PKG");
        }
    }
}
