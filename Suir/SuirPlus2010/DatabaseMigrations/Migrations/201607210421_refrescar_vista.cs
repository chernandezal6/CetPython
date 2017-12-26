using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201607210421)]
    public class _201607210421_refrescar_vista : FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "refrescar_vista.sql");
        }

        public override void Down()
        {
            Execute.Sql("DROP FUNCTION REFRESCAR_VISTA");
        }
    }
}
