using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201705021757)]
    public class _201705021757_nss_validar_sol_menores_nac: FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "nss_validar_sol_menores_nac.sql");
        }

        public override void Down()
        {
            Execute.Sql("DROP PROCEDURE SUIRPLUS.NSS_VALIDAR_SOL_MENORES_NAC");
        }
    }
}
