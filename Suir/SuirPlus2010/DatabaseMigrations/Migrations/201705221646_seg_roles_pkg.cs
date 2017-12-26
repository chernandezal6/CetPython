using FluentMigrator;
namespace DatabaseMigrations.Migrations
{
    [Migration(201705211646)]
    public class _201705221646_seg_roles_pkg: FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "seg_roles_spec_pkg.sql");
            Execute.Script(Framework.Configuration.ScriptDirectory() + "seg_roles_body_pkg.sql");
        }

        public override void Down()
        {
            Execute.Sql("DROP PACKAGE SUIRPLUS.SEG_ROLES_PKG");
        }
    }
}
