using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201703021019)]
    public class _201703021019_create_materialized_view_rpn_cartera_pensionados_mv : FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "rpn_cartera_pensionados_mv.sql");
        }
        public override void Down()
        {
            Execute.Sql("DROP MATERIALIZED VIEW RPN_CARTERA_PENSIONADOS_MV");
        }
    }
}