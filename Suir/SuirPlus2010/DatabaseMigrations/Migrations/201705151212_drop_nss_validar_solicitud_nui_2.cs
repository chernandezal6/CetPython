using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201705151212)]
    public class _201705151212_drop_nss_validar_solicitud_nui_2: FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "drop_nss_validar_solicitud_nui_2.sql");
        }

        public override void Down()
        {

        }
    }
}
