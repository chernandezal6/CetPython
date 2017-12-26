using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201608040300)]
    public class _201608040300_nss_cargar_solicitudes_menores : FluentMigrator.Migration
    {
        public override void Up()
        {
            //Comentada para que no corrar, sera ejecutada por: 201610041034_nss_cargar_solicitudes_menores
            //Execute.Script(Framework.Configuration.ScriptDirectory() + "nss_cargar_solicitudes_menores.sql");
        }

        public override void Down()
        {
            //Comentada para que no corrar, sera ejecutada por: 201610041034_nss_cargar_solicitudes_menores
            //Execute.Sql("DROP PROCEDURE NSS_CARGAR_SOLICITUDES_MENORES");
        }
    }
}