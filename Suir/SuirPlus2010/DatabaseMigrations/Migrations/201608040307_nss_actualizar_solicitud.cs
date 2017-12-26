using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201608040307)]
    public class _201608040307_nss_actualizar_solicitud : FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "nss_actualizar_solicitud.sql");
        }

        public override void Down()
        {
            Execute.Sql("DROP PROCEDURE NSS_ACTUALIZAR_SOLICITUD");
        }
    }
}
