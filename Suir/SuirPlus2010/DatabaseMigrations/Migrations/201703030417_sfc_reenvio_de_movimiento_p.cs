using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201703030417)]
    public class _201703030417_sfc_reenvio_de_movimiento_p:FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "sfc_reenvio_de_movimiento_p.sql");

        }

        public override void Down()
        {
            Execute.Sql("DROP PROCEDURE sfc_reenvio_de_movimiento_p");
        }
    }
}
