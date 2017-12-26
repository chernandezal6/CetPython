using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201612201014)]
    public class _201612201014_create_sfc_rec_int_liq_inf_p: FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "sfc_rec_int_liq_inf_p.sql");
        }

        public override void Down()
        {
            Execute.Sql("DROP PROCEDURE SFC_REC_INT_LIQ_INF_P");
        }
    }
}
