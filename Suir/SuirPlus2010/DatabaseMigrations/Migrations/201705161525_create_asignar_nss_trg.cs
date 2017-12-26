using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201705161525)]
    public class _201705161525_create_asignar_nss_trg: FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "asignar_nss_trg.sql");
        }

        public override void Down()
        {
            Execute.Sql("DROP TRIGGER SUIRPLUS.ASIGNAR_NSS_TRG");
        }
    }
}
