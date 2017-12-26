using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201610190335)]
    public class _201610190335_update_id_nss_det_solicitudes_t: FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "update_id_nss_det_solicitudes_t.sql");
        }

        public override void Down()
        {
            //Execute.Script(Framework.Configuration.ScriptDirectory() + "update_id_nss_det_solicitudes_t.sql");
        }
    }
}