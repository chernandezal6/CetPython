using FluentMigrator;
namespace DatabaseMigrations.Migrations
{
    [Migration(201706070942)]
    public class _201706070942_create_view_sre_trabajadores_v: FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "create_view_sre_trabajadores_v.sql");
        }

        public override void Down()
        {
            Execute.Sql("DROP VIEW SUIRPLUS.SRE_TRABAJADORES_V");
        }
    }
}
