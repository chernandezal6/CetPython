using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201610250414)]
    public class _201610250414_nss_cargar_sol_cedulados: FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "nss_cargar_sol_cedulados.sql");
        }

        public override void Down()
        {
            Execute.Sql("DROP PROCEDURE NSS_CARGAR_SOL_CEDULADOS");
        }
    }
}
