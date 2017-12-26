using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201702150248)]
   public class _201702150248_create_materialized_view_dgii_empleadores_general_mv: FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "dgii_empleadores_general_mv.sql");
        }
        public override void Down()
        {
            Execute.Sql("DROP MATERIALIZED VIEW DGII_EMPLEADORES_GENERAL_MV");
        }
    }
}
