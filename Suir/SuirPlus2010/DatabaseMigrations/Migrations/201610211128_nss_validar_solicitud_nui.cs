using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201610211128)]
    public class _201610211128_nss_validar_solicitud_nui: FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "nss_validar_solicitud_nui.sql");
        }

        public override void Down()
        {
            Execute.Sql("DROP PROCEDURE NSS_VALIDAR_SOLICITUD_NUI");
        }
    }
}
