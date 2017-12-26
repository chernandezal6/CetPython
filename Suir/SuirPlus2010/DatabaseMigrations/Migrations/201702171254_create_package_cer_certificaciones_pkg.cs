using FluentMigrator;
namespace DatabaseMigrations.Migrations
{
    [Migration(201702171254)]
    public class _201702171254_create_package_cer_certificaciones_pkg : FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "cer_certificaciones_spec_pkg.sql");
            Execute.Script(Framework.Configuration.ScriptDirectory() + "cer_certificaciones_body_pkg.sql");
        }

        public override void Down()
        {
            Execute.Sql("DROP PACKAGE CER_CERTIFICACIONES_PKG");
        }
    }
}
