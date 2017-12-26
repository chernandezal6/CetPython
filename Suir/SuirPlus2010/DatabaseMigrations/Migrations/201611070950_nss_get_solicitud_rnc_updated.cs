using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201611070950)]
    public class _201611070950_nss_get_solicitud_rnc_updated : FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "nss_get_solicitud_rnc.sql");
        }

        public override void Down()
        {
            Execute.Sql("DROP PROCEDURE NSS_GET_SOLICITUD_RNC");
        }

    }
}
