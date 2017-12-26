using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201610101138)]
    public class _201610101138_nss_webservice_jce_ced: FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "nss_webservice_jce_ced.sql");
        }

        public override void Down()
        {
            Execute.Sql("DROP FUNCTION NSS_WEBSERVICE_JCE_CED");
        }
    }
}
