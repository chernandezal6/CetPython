using FluentMigrator;
namespace DatabaseMigrations.Migrations
{
     [Migration(201611210300)]
   public class _201611210300_nss_insert_det_solicitudes: FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "nss_insert_det_solicitudes.sql");
        }

        public override void Down()
        {
            Execute.Sql("DROP PROCEDURE NSS_INSERT_DET_SOLICITUDES");
        }
    }
}
