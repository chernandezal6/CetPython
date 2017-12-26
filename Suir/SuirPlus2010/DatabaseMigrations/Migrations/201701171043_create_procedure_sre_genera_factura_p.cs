using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201701171043)]
    public class _201701171043_create_procedure_sre_genera_factura_p: FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "sre_genera_factura_p.sql");
        }

        public override void Down()
        {
            Execute.Sql("DROP PROCEDURE SRE_GENERA_FACTURA_P");
        }
    }
}
