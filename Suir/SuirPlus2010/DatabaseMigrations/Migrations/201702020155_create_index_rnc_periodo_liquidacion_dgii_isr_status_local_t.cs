using FluentMigrator;

namespace DatabaseMigrations.Migrations
{   
    [Migration(201702020155)]
    public class _201702020155_create_index_rnc_periodo_liquidacion_dgii_isr_status_local_t: FluentMigrator.Migration
    {
        public override void Up()
        {
            if (Schema.Table("DGII_ISR_STATUS_LOCAL_T").Exists())
            {
                Create.Index("IDX_RNC_DGII_ISR_STS_LOCAL_T").OnTable("DGII_ISR_STATUS_LOCAL_T").OnColumn("RNC");
                Create.Index("IDX_PERIODO_DGII_ISR_STS_LOCAL").OnTable("DGII_ISR_STATUS_LOCAL_T").OnColumn("PERIODO_LIQUIDACION");
            }
        }

        public override void Down()
        {
            if (Schema.Table("DGII_ISR_STATUS_LOCAL_T").Exists())
            {
                Delete.Index("IDX_RNC_DGII_ISR_STS_LOCAL_T").OnTable("DGII_ISR_STATUS_LOCAL_T");
                Delete.Index("IDX_PERIODO_DGII_ISR_STS_LOCAL").OnTable("DGII_ISR_STATUS_LOCAL_T");
            }
        }
    }
}