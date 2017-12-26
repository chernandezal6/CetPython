using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201610041034)]
    public class _201610041034_nss_cargar_solicitudes_menores: FluentMigrator.Migration
    {
        public override void Up()
        {
            //Execute.Script(Framework.Configuration.ScriptDirectory() + "nss_cargar_solicitudes_menores.sql");
        }

        public override void Down()
        {
            //Execute.Sql("DROP PROCEDURE NSS_CARGAR_SOLICITUDES_MENORES");
        }

    }
}
