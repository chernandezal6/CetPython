using FluentMigrator;
namespace DatabaseMigrations.Migrations
{
    [Migration(201611210316)]
    public class _201611210316_nss_insert_solicitudes :FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "nss_insert_solicitudes.sql");
        }

        public override void Down()
        {
            Execute.Sql("DROP PROCEDURE NSS_INSERT_SOLICITUDES");
        }
    }
}
