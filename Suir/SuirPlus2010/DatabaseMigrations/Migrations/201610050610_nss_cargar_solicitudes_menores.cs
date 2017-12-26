using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201610050610)]
    public class _201610050610_nss_cargar_solicitudes_menores: FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "nss_cargar_solicitudes_menores.sql");
        }

        public override void Down()
        {
            Execute.Sql("DROP PROCEDURE NSS_CARGAR_SOLICITUDES_MENORES");
        }
    }
}
