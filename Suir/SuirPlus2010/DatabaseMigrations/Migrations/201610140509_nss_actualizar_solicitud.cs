using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201610140509)]
    public class _201610140509_nss_actualizar_solicitud: FluentMigrator.Migration
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
