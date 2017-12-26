using FluentMigrator;
namespace DatabaseMigrations.Migrations
{
    [Migration(201704181111)]
    public class _201704181111_create_or_replace_unipago_sfc_det_ajustes_mv : FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "vista_unipago_sfc_det_ajustes_mv.sql");                     
        }

        public override void Down()
        {
            
        }
    }
}
