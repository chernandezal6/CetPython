using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201706121522)]
    public class _201706121522_ars_validaciones_pkg:FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "ars_validaciones_body_pkg.sql");
        }

        public override void Down()
        {
            Execute.Sql("DROP PACKAGE SUIRPLUS.ARS_VALIDACIONES_PKG");
        }

    }
}
