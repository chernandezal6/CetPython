using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201705041113)]
    public class _201705041113_create_nss_cambiar_estatus_solicitud: FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "nss_cambiar_estatus_solicitud.sql");
        }

        public override void Down()
        {
            Execute.Sql("DROP PROCEDURE NSS_CAMBIAR_ESTATUS_SOLICITUD");
        }
    }
}
