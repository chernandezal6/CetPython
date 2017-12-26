using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201610240522)]
    public class _201610240522_nss_ponerencola_cedulados: FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "nss_ponerencola_cedulados.sql");
        }

        public override void Down()
        {
            Execute.Sql("DROP PROCEDURE NSS_PONERENCOLA_CEDULADOS");
        }
    }
}
