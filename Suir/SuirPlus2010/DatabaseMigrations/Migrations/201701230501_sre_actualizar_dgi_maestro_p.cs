using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201701230501)]
    public class _201701230501_sre_actualizar_dgi_maestro_p : FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "sre_actualizar_dgi_maestro_p.sql");
        }

        public override void Down()
        {
            Execute.Sql("DROP PROCEDURE SRE_ACTUALIZAR_DGI_MAESTRO_P");
        }
    }
}
