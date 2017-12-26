using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201611171037)]
    public class _201611171037_update_sfc_rec_int_ord_liq_isr_p: FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "sfc_rec_int_ord_liq_isr_p.sql");
        }

        public override void Down()
        {
            Execute.Sql("DROP PROCEDURE SFC_REC_INT_ORD_LIQ_ISR_P");
        }

    }
}
