using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201705021755)]
    public class _201705021755_nss_validar_sol_extranjeros: FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "nss_validar_sol_extranjeros.sql");
        }

        public override void Down()
        {
            Execute.Sql("DROP PROCEDURE SUIRPLUS.NSS_VALIDAR_SOL_EXTRANJEROS");
        }
    }
}
