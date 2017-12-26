using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
[Migration(201704211832)]
public class _201704211832_nss_call_actualizar_ciudadano: FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "nss_call_actualizar_ciudadano.sql");
        }

        public override void Down()
        {
            Execute.Sql("DROP PROCEDURE NSS_CALL_ACTUALIZAR_CIUDADANO.SQL");
        }
    }
}
