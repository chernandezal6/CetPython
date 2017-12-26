using FluentMigrator;
namespace DatabaseMigrations.Migrations
{
    [Migration(201704181109)]
    public class _201704181109_borrar_vistas_materializadas_unipago : FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "borrar_vistas_materializadas.sql");                     
        }

        public override void Down()
        {
            
        }
    }
}
