using FluentMigrator;
namespace DatabaseMigrations.Migrations
{
    [Migration(201704181137)]
    public class _201704181137_create_or_replace_unipago_sfc_det_dependiente_facturas_mv : FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "vista_unipago_sfc_det_dependiente_factura_mv.sql");                     
        }

        public override void Down()
        {
            
        }
    }
}
