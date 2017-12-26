using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201703061029)]
    public class _201703061029_nss_insertar_ciudadano: FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "nss_insertar_ciudadano.sql");
        }

        public override void Down()
        {
            Execute.Sql("DROP PROCEDURE NSS_INSERTAR_CIUDADANO");
        }
    }
}
