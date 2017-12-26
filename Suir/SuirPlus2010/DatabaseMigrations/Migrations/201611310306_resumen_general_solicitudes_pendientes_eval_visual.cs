using FluentMigrator;

namespace DatabaseMigrations.Migrations
{    
    [Migration(201611310306)]
    public class _201611310306_resumen_general_solicitudes_pendientes_eval_visual: FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "resumen_general_solicitudes_asignacion_nss_pendientes_eval_visual.sql");
        }

        public override void Down()
        {
            Execute.Sql("DROP PROCEDURE reporte_general_sol_pendientes");
        }
    }
}
