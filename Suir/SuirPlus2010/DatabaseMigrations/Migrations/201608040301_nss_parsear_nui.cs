using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201608040301)]
    public class _201608040301_201608040301_nss_parsear_nui : FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "nss_parsear_nui.sql");
        }

        public override void Down()
        {
            Execute.Sql("DROP FUNCTION NSS_PARSEAR_NUI");
        }
    }
}