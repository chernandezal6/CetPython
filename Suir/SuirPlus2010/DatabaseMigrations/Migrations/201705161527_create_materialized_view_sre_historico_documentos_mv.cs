using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201705161527)]
    public class _201705161527_create_materialized_view_sre_historico_documentos_mv: FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "create_sre_historico_documentos_mv.sql");
        }
        public override void Down()
        {
            Execute.Sql("DROP MATERIALIZED VIEW UNIPAGO.SRE_HISTORICO_DOCUMENTOS_MV");
        }
    }
}
