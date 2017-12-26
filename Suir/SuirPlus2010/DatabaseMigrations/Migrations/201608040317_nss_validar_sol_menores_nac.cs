using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201608040317)]
    public class _201608040317_nss_validar_sol_menores_nac : FluentMigrator.Migration
    {
        public override void Up()
        {
            //Execute.Script(Framework.Configuration.ScriptDirectory() + "nss_validar_sol_menores_nac.sql");
        }

        public override void Down()
        {
            //Execute.Sql("DROP PROCEDURE NSS_VALIDAR_SOL_MENORES_NAC");
        }
    }
}
