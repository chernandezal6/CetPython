using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201704201007)]
    public class _201704201007_nss_get_solicitud: FluentMigrator.Migration
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
