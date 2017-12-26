using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201608040311)]
    public class _201608040311_nss_actualizar_ciudadano : FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "nss_actualizar_ciudadano.sql");
        }

        public override void Down()
        {
            Execute.Sql("DROP PROCEDURE NSS_ACTUALIZAR_CIUDADANO");
        }
    }
}
