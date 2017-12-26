using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201705181758)]
    public class _201705181758_nss_actualizar_solicitud: FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "nss_actualizar_solicitud.sql");
        }

        public override void Down()
        {
            Execute.Sql("DROP PROCEDURE SUIRPLUS.NSS_ACTUALIZAR_SOLICITUD");
        }
    }
}
