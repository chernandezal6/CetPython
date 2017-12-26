using FluentMigrator;

namespace DatabaseMigrations.Migrations
{[Migration(201703210156)]
    public class _201703210156_resumen_solicitudes_diarias_asignacion_nss:FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "resumen_solicitudes_diarias_asignacion_nss.sql");
        }

        public override void Down()
        {
            Execute.Sql("DROP PROCEDURE reporte_proceso_sol_diarias");
        }

    }
}
