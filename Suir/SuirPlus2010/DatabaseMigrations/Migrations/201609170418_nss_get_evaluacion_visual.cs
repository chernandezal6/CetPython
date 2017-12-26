using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201609170418)]
    public class _201609170418_nss_get_evaluacion_visual: FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "nss_get_evaluacion_visual.sql");
        }

        public override void Down()
        {
            Execute.Sql("DROP PROCEDURE NSS_GET_EVALUACION_VISUAL");
        }
    }
}
