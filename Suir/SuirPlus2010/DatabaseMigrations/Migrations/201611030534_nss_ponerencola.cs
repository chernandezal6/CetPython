using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201611030534)]
    public class _201611030534_nss_ponerencola: FluentMigrator.Migration
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
