using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201608040320)]
    public class _201608040320_nss_validar_solicitud_nui : FluentMigrator.Migration
    {
        public override void Up()
        {
            //Execute.Script(Framework.Configuration.ScriptDirectory() + "nss_validar_solicitud_nui.sql");
        }

        public override void Down()
        {
            //Execute.Sql("DROP PROCEDURE NSS_VALIDAR_SOLICITUD_NUI");
        }
    }
}
