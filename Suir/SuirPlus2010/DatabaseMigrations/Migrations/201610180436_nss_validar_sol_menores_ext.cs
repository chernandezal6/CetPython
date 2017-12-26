using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201610180436)]
    public class _201610180436_nss_validar_sol_menores_ext: FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "nss_validar_sol_menores_ext.sql");
        }

        public override void Down()
        {
            Execute.Sql("DROP PROCEDURE NSS_VALIDAR_SOL_MENORES_EXT");
        }
    }
}
