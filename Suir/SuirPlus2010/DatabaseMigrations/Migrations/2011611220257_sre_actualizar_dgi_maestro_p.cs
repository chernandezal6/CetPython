using FluentMigrator;
namespace DatabaseMigrations.Migrations
{
    [Migration(201611220257)]
    public class _2011611220257_sre_actualizar_dgi_maestro_p: FluentMigrator.Migration
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
