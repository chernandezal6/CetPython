using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201610211126)]
    public class _201610211126_nss_validar_sol_cedulados: FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "nss_validar_sol_cedulados.sql");
        }

        public override void Down()
        {
            Execute.Sql("DROP PROCEDURE NSS_VALIDAR_SOL_CEDULADOS");
        }
    }
}
