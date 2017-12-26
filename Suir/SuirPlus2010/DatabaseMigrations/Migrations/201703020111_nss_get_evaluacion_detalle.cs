using FluentMigrator;
namespace DatabaseMigrations.Migrations
{
    [Migration(201703020111)]
    public class _201703020111_nss_get_evaluacion_detalle: FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "nss_get_evaluacion_det.sql");
        }

        public override void Down()
        {
            Execute.Sql("DROP PROCEDURE NSS_GET_EVALUACION_DETALLE");
        }
    }
}
