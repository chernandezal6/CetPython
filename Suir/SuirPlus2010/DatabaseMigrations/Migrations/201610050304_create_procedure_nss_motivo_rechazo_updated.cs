using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201610050304)]
    public class _201610050304_create_procedure_nss_motivo_rechazo_updated:FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "nss_motivo_rechazo.sql");
        }

        public override void Down()
        {
            Execute.Sql("DROP PROCEDURE NSS_MOTIVO_RECHAZO");
        }
    }
}
