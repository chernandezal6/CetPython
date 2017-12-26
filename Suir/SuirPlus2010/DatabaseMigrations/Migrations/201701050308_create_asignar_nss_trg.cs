using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201701050308)]
    public class _201701050308_create_asignar_nss_trg: FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "asignar_nss_trg.sql");
        }

        public override void Down()
        {
            Execute.Sql("DROP TRIGGER ASIGNAR_NSS_TRG");
        }
    }
}