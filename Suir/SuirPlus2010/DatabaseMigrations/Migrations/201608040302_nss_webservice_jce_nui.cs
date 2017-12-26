using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201608040302)]
    public class _201608040302_nss_webservice_jce_nui : FluentMigrator.Migration
    {
        public override void Up()
        {
            //Execute.Script(Framework.Configuration.ScriptDirectory() + "nss_webservice_jce_nui.sql");
        }

        public override void Down()
        {
            //Execute.Sql("DROP FUNCTION NSS_WEBSERVICE_JCE_NUI");
        }
    }
}
