using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201610121151)]
    public class _201610121151_nss_webservice_jce_nui: FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "nss_webservice_jce_nui.sql");
        }

        public override void Down()
        {
            Execute.Sql("DROP FUNCTION NSS_WEBSERVICE_JCE_NUI");
        }
    }
}
