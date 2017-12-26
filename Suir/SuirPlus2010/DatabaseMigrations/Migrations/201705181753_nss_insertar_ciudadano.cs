using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201705181753)]
    public class _201705181753_nss_insertar_ciudadano: FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "nss_insertar_ciudadano.sql");
        }

        public override void Down()
        {
            Execute.Sql("DROP PROCEDURE SUIRPLUS.NSS_INSERTAR_CIUDADANO");
        }
    }
}
