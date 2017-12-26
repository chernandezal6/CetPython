using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201707121522)]
    public class _201707121522_nss_validar_solicitud_nui : FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "nss_validar_solicitud_nui.sql");
        }

        public override void Down()
        {
            Execute.Sql("DROP PROCEDURE SUIRPLUS.NSS_VALIDAR_SOLICITUD_NUI");
        }
    }
}
