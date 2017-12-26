using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201701240844)]
    public class _201701240844_seg_usuarios_pkg : FluentMigrator.Migration
    {        
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "seg_usuarios_pkg.sql");
            Execute.Script(Framework.Configuration.ScriptDirectory() + "seg_usuarios_body_pkg.sql");
        }

        public override void Down()
        {
            Execute.Sql("DROP PACKAGE SEG_USUARIOS_PKG");
        }
    }
}
