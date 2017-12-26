using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201711161145)]
    public class _201711161145_create_procedure_sre_baja_trabajadores_p: FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "sre_baja_trabajadores_p.sql");
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
                               And object_name = 'SRE_BAJA_TRABAJADORES_P'
                               And object_type = 'PROCEDURE';
                            --Si el objeto exite, lo borramos
                            If v_conteo > 0 Then
                              EXECUTE IMMEDIATE('DROP PROCEDURE SUIRPLUS.SRE_BAJA_TRABAJADORES_P');
                            End if;                          
                         END;");
        }
    }
}
