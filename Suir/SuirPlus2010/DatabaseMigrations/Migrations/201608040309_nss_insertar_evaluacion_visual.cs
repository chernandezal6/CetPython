using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201608040309)]
    public class _201608040309_nss_insertar_evaluacion_visual : FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "nss_insertar_evaluacion_visual.sql");
        }

        public override void Down()
        {
            Execute.Sql("DROP PROCEDURE NSS_INSERTAR_EVALUACION_VISUAL");
        }
    }
}
