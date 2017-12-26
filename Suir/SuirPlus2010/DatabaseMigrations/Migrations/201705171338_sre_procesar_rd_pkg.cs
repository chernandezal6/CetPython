using FluentMigrator;
namespace DatabaseMigrations.Migrations
{
    [Migration(201705171338)]
    public class _201705171338_sre_procesar_rd_pkg: FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "sre_procesar_rd_body_pkg.sql");
        }

        public override void Down()
        {
            Execute.Sql("DROP PACKAGE SUIRPLUS.SRE_PROCESAR_RD_BODY_PKG");
        }
    }
}
