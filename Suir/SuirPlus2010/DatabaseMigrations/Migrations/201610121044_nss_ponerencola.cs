using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201610121044)]
    public class _201610121044_nss_ponerencola: FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "nss_ponerencola.sql");
        }

        public override void Down()
        {
            Execute.Sql("DROP PROCEDURE NSS_PONERENCOLA");
        }
    }
}
