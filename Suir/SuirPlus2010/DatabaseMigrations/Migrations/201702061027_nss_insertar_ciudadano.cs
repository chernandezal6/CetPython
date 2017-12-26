using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201702061027)]
    public class _201702061027_nss_insertar_ciudadano: FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "nss_insertar_ciudadano.sql");
        }

        public override void Down()
        {
            Execute.Sql("DROP PROCEDURE NSS_INSERTAR_CIUDADANO");
        }
    }
}
