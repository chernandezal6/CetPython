using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201610121000)]
    public class _201610121000_nss_cargar_solicitudes_nui: FluentMigrator.Migration
    {
        public override void Up()
        {
            Down();
            //Execute.Script(Framework.Configuration.ScriptDirectory() + "nss_cargar_solicitudes_nui.sql");
        }

        public override void Down()
        {
            Execute.Sql("DROP PROCEDURE NSS_CARGAR_SOLICITUDES_NUI");
        }

    }
}
