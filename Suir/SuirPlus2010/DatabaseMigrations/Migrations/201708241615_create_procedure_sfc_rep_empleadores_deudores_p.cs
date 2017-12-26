using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201708241615)]
    public class _201708241615_create_procedure_sfc_rep_empleadores_deudores_p : FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "sfc_rep_empleadores_deudores_p.sql");
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
                               And object_name = 'SFC_REP_EMPLEADORES_DEUDORES_P'
                               And object_type = 'PROCEDURE';

                          --Si el objeto exite, lo borramos
                            If v_conteo > 0 Then
                              EXECUTE IMMEDIATE('DROP PROCEDURE SUIRPLUS.SFC_REP_EMPLEADORES_DEUDORES_P');
                            End if;                          
                         END;");
        }
    }
}
