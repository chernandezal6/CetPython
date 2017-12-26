using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201608290421)]
    public class _201608290421_nss_ponerencola : FluentMigrator.Migration
    {
        public override void Up()
        {
            //Comentada porque será corrida nuevamente por 201610041120_nss_ponerencola
            //Execute.Script(Framework.Configuration.ScriptDirectory() + "nss_ponerencola.sql");
        }

        public override void Down()
        {
            //Comentada porque será corrida nuevamente por 201610041120_nss_ponerencola
            //Execute.Sql("DROP PROCEDURE NSS_PONERENCOLA");
        }
    }
}
