using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201609120503)]
    public class _201609120503_nss_get_solicitud: FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "nss_get_solicitud.sql");
        }

        public override void Down()
        {
            Execute.Sql("DROP PROCEDURE NSS_GET_SOLICITUD");
        }
    }
}
