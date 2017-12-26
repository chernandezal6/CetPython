using FluentMigrator;

namespace DatabaseMigrations.Migrations
{ 
    [Migration(201610030501)]
    public class _201610030501_nss_get_ciudadano: FluentMigrator.Migration
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
