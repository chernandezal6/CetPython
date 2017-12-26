using FluentMigrator;
namespace DatabaseMigrations.Migrations
{
    [Migration(201704251146)]
    public class _201704251146_seg_usuarios_pkg:FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "seg_usuarios_body_pkg.sql");
        }

        public override void Down()
        {
            Execute.Sql("DROP PACKAGE SEG_USUARIOS_PKG");
        }
    }
}
