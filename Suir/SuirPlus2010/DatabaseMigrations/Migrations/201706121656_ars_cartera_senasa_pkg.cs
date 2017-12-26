using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201706121656)]
    public class _201706121656_ars_cartera_senasa_pkg:FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "ars_cartera_senasa_pkg.sql");
        }

        public override void Down()
        {
            Execute.Sql("DROP PROCEDURE SUIRPLUS.ARS_CARTERA_SENASA_PKG");
        }
    }
}
