using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201612010423)]
    public class _201612010423_alter_trigger_tr_nomina_t: FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "tr_nomina_t.sql");
        }

        public override void Down()
        {
            Execute.Sql("DROP TRIGGER TR_NOMINA_T");
        }
    }
}
