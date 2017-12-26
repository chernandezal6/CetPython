using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201703030419)]
   public class _201703030419_sfc_nacha_p:FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "sfc_nacha_p.sql");

        }

        public override void Down()
        {
            Execute.Sql("DROP PROCEDURE sfc_nacha_p");
        }
    }
}
