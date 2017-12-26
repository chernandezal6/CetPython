using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201705181832)]
    public class _201705181832_nss_validar_sol_cedulados: FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "nss_validar_sol_cedulados.sql");
        }

        public override void Down()
        {
            Execute.Sql("DROP PROCEDURE SUIRPLUS.NSS_VALIDAR_SOL_CEDULADOS");
        }
    }
}
