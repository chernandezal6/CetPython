using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201610250410)]
    public class _201610250410_nss_actualizar_ciudadano: FluentMigrator.Migration
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
