using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201701270147)]
    public class _201701270147_create_sre_procesar_cedula_rechazadas : FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "sre_procesar_cedula_rechazadas.sql");
        }
        public override void Down()
        {
            Execute.Sql("DROP PROCEDURE SRE_PROCESAR_CEDULA_RECHAZADAS");
        }
    }
}
