using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201703010512)]
    public class _201703010512_create_procedure_rpn_proc_cartera_pensionados: FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "rpn_proc_cartera_pensionados.sql");
        }

        public override void Down()
        {
            Execute.Sql("DROP PROCEDURE RPN_PROC_CARTERA_PENSIONADOS");
        }
    }
}