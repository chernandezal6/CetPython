using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201702141258)]
    public class _201702141258_seg_usuarios_pkg : FluentMigrator.Migration
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
