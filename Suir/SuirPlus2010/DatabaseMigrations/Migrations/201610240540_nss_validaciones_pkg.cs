using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201610240540)]
    public class _201610240540_nss_validaciones_pkg: FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "nss_validaciones_body_pkg.sql");
        }

        public override void Down()
        {
            Execute.Sql("DROP PACKAGE NSS_VALIDACIONES_PKG");
        }
    }
}
