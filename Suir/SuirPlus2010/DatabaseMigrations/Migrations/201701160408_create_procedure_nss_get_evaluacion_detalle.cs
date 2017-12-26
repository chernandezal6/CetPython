using FluentMigrator;
namespace DatabaseMigrations.Migrations
{
    [Migration(201701160408)]
    public class _201701160408_create_procedure_nss_get_evaluacion_detalle : FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "nss_get_evaluacion_det.sql");
        }

        public override void Down()
        {
            Execute.Sql("DROP PROCEDURE NSS_GET_EVALUACION_DET");
        }
    }
}
