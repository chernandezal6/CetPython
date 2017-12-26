using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201706121454)]
    public class _201706121454_ars_cobertura_fono_senasa_p:FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "ars_cobertura_fono_senasa_p.sql");
        }

        public override void Down()
        {
            Execute.Sql("DROP PROCEDURE SUIRPLUS.ARS_COBERTURA_FONO_SENASA_P");
        }
    }
}
