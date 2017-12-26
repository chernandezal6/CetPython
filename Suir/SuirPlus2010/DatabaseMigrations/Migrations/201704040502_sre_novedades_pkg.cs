using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201704040502)]
   public class _201704040502_sre_novedades_pkg:FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "sre_novedades_pkg.sql");
            Execute.Script(Framework.Configuration.ScriptDirectory() + "sre_novedades_body_pkg.sql");
        }

        public override void Down()
        {
            Execute.Sql("DROP PACKAGE SRE_NOVEDADES_PKG");
        }
    }
}
