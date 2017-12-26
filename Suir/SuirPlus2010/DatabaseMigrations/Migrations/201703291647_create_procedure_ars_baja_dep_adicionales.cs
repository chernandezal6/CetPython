using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201703291647)]
    public class _201703291647_create_procedure_ars_baja_dep_adicionales: FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "ars_baja_dep_adicionales.sql");
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
                               And object_name = 'ARS_BAJA_DEP_ADICIONALES'
                               And object_type = 'PROCEDURE';
                           --Si el objeto exite, lo borramos
                            If v_conteo > 0 Then
                              EXECUTE IMMEDIATE('DROP PROCEDURE SUIRPLUS.ARS_BAJA_DEP_ADICIONALES');
                            End if;                          
                         END;");
        }
    }
}