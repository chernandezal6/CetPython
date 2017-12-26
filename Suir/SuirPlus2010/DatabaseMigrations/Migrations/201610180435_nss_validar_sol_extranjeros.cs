using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201610180435)]
    public class _201610180435_nss_validar_sol_extranjeros: FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "nss_validar_sol_extranjeros.sql");
        }

        public override void Down()
        {
            Execute.Sql("DROP PROCEDURE NSS_VALIDAR_SOL_EXTRANJEROS");
        }
    }
}
