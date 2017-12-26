using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201725051148)]
    public class _201725051148_cer_certificaciones_pkg: FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "cer_certificaciones_spec_pkg.sql");
            Execute.Script(Framework.Configuration.ScriptDirectory() + "cer_certificaciones_body_pkg.sql");
        }

        public override void Down()
        {
            Execute.Sql("DROP PACKAGE SUIRPLUS.CER_CERTIFICACIONES_PKG");
        }
    }
}
