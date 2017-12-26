using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201707111532)]
    public class _201707111532_create_package_seg_usuarios_pkg:FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "seg_usuarios_pkg.sql");
            Execute.Script(Framework.Configuration.ScriptDirectory() + "seg_usuarios_body_pkg.sql");
        }

        public override void Down()
        {
            Execute.Sql("DROP PACKAGE SUIRPLUS.SEG_USUARIOS_PKG");
        }
    }
}
