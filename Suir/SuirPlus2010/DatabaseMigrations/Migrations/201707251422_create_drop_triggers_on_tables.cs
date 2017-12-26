using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201707251422)]
    public class _201707251422_create_drop_triggers_on_tables: FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "create_triggers_on_tables.sql");
        }

        public override void Down()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "drop_triggers_on_tables.sql");
        }
    }
}
