using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201609291122)]
    public class _201609291122_create_materialized_view_suir_r_sol_asig_nss_menores_mv: FluentMigrator.Migration
    {
        public override void Up()
        {
            Down();
            Execute.Script(Framework.Configuration.ScriptDirectory() + "create_suir_r_sol_asig_nss_menores_mv.sql");
        }

        public override void Down()
        {
            //Execute.Script(Framework.Configuration.ScriptDirectory() + "drop_suir_r_sol_asig_nss_menores_mv.sql");
        }
    }
}
