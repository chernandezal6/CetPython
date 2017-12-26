using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201703230457)]
    public class _201703230457_sre_novedades_pkg:FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "sre_novedades_pkg.sql");
            Execute.Script(Framework.Configuration.ScriptDirectory() + "sre_novedades_body_pkg.sql");
        }

        public override void Down()
        {
            Execute.Sql("DROP PACKAGE sre_novedades_pkg");
        }

    }
}
