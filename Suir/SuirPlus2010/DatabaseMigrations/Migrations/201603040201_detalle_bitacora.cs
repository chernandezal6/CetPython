using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201603040201)]
    public class _201603040201_detalle_bitacora : FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "detalle_bitacora.sql");
        }

        public override void Down()
        {
            Execute.Sql("DROP PROCEDURE DETALLE_BITACORA");
        }
    }
}
