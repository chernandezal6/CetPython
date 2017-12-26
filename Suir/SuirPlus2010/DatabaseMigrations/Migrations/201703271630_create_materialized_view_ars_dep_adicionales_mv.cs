using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201703271630)]
    public class _201703271630_create_materialized_view_ars_dep_adicionales_mv: FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "ars_dep_adicionales_mv.sql");
        }
        public override void Down()
        {
            Execute.Sql(@"DECLARE
                            v_conteo pls_integer;
                          BEGIN
                            --Buscamos el objeto para ver si existe
                            Select count(*)
                              Into v_conteo
                              From all_objects
                             Where owner       = 'SUIRPLUS'
                               And object_name = 'ARS_DEP_ADICIONALES_MV'
                               And object_type = 'MATERIALIZED VIEW';
                           --Si el objeto exite, lo borramos
                            If v_conteo > 0 Then
                              EXECUTE IMMEDIATE('DROP MATERIALIZED VIEW SUIRPLUS.ARS_DEP_ADICIONALES_MV');
                            End if;                          
                         END;");

        }
    }
}