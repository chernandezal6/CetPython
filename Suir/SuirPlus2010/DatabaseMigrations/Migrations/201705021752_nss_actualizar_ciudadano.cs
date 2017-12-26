using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201705021752)]
    public class _201705021752_nss_actualizar_ciudadano: FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "nss_actualizar_ciudadano.sql");
        }

        public override void Down()
        {
            Execute.Sql("DROP PROCEDURE SUIRPLUS.NSS_ACTUALIZAR_CIUDADANO");
        }
    }
}
