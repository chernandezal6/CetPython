using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(20160804030401)]
    public class _20160804030401_nss_cargar_sol_cedulados : FluentMigrator.Migration
    {
        public override void Up()
        {
            //Comentada porque la correrá la migracion 201610041040_nss_cargar_sol_cedulados
            //Execute.Script(Framework.Configuration.ScriptDirectory() + "nss_cargar_sol_cedulados.sql");
        }

        public override void Down()
        {
            //Comentada porque la correrá la migracion 201610041040_nss_cargar_sol_cedulados
            //Execute.Sql("DROP PROCEDURE NSS_CARGAR_SOL_CEDULADOS");
        }
    }
}