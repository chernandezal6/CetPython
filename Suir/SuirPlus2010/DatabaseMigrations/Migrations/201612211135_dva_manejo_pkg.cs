using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201612211135)]
    public class _201612211135_dva_manejo_pkg : FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "dva_manejo_spec_pkg.sql");
            Execute.Script(Framework.Configuration.ScriptDirectory() + "dva_manejo_body_pkg.sql");
        }

        public override void Down()
        {
            Execute.Sql("DROP PACKAGE DVA_MANEJO_PKG");
        }
    }
}
