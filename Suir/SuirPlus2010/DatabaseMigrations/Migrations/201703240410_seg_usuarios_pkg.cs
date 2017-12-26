using FluentMigrator;
namespace DatabaseMigrations.Migrations
{
    [Migration(201703240410)]
    public class _201703240410_seg_usuarios_pkg:FluentMigrator.Migration
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
