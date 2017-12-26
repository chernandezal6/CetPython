using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201610190308)]
    public class _201610190308_nss_get_ciudadano: FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "nss_get_ciudadano.sql");
        }

        public override void Down()
        {
            Execute.Sql("DROP PROCEDURE NSS_GET_CIUDADANO");
        }
    }
}
