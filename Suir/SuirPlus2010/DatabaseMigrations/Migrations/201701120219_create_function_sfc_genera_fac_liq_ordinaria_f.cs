using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201701120219)]
    public class _201701120219_create_function_sfc_genera_fac_liq_ordinaria_f: FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "sfc_genera_fac_liq_ordinaria_f.sql");
        }

        public override void Down()
        {
            Execute.Sql("DROP FUNCTION SFC_GENERA_FAC_LIQ_ORDINARIA_F");
        }
    }
}
