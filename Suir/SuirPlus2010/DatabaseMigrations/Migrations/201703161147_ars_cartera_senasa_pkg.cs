using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201703161147)]
    public class _201703161147_ars_cartera_senasa_pkg:FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "ars_cartera_senasa_pkg.sql");

        }

        public override void Down()
        {
            Execute.Sql("DROP PACKAGE ars_cartera_senasa_pkg");
        }
    }
}
