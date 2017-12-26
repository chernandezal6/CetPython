using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201611021126)]
    public class _201611021126_nss_parsear_nui: FluentMigrator.Migration
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
