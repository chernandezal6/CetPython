using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201609270521)]
    public class _201609270521_nss_get_solicitud_rnc: FluentMigrator.Migration
    {
        public override void Up()
        {
            //Execute.Script(Framework.Configuration.ScriptDirectory() + "nss_get_solicitud_rnc.sql");
        }

        public override void Down()
        {
            //Execute.Sql("DROP PROCEDURE NSS_GET_SOLICITUD_RNC");
        }

    }
}
