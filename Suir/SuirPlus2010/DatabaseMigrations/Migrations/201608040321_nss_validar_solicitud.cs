using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201608040321)]
    public class _201608040321_nss_validar_solicitud : FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "nss_validar_solicitud.sql");
        }

        public override void Down()
        {
            Execute.Sql("DROP PROCEDURE NSS_VALIDAR_SOLICITUD");
        }
    }
}
