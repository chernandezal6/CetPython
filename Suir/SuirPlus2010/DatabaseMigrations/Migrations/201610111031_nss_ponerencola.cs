using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201610111031)]
    public class _201610111031_nss_ponerencola: FluentMigrator.Migration
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
