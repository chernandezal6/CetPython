using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201702150255)]
    public class _201702150255_create_sre_actualizar_dgi_maestro_p: FluentMigrator.Migration
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
