using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201702020635)]
    public class _201702020635_create_procedure_dgii_isr_status_prc: FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "dgii_isr_status_local_prc.sql");
        }

        public override void Down()
        {
            Execute.Sql("DROP PROCEDURE DGII_ISR_STATUS_LOCAL_PRC");
        }
    }
}
