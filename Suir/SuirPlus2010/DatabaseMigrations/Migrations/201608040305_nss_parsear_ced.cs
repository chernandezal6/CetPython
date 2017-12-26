using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201608040305)]
    public class _201608040305_nss_parsear_ced : FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "nss_parsear_ced.sql");
        }

        public override void Down()
        {
            Execute.Sql("DROP FUNCTION NSS_PARSEAR_CED");
        }
    }
}
