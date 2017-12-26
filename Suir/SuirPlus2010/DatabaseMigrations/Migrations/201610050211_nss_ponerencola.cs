using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201610050211)]
    public class _201610050211_nss_ponerencola: FluentMigrator.Migration
    {
        public override void Up()
        {
            //Execute.Script(Framework.Configuration.ScriptDirectory() + "nss_ponerencola.sql");
        }

        public override void Down()
        {
            //Execute.Sql("DROP PROCEDURE NSS_PONERENCOLA");
        }
    }
}
