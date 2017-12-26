using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201710041451)]
    public class _201710041451_create_function_sre_ciudadano_inactivo_f: FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "sre_ciudadano_inactivo_f.sql");
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
                               And object_name = 'SRE_CIUDADANO_INACTIVO_F'
                               And object_type = 'FUNCTION';

                            --Si el objeto exite, lo borramos
                            If v_conteo > 0 Then
                              EXECUTE IMMEDIATE('DROP FUNCTION SUIRPLUS.SRE_CIUDADANO_INACTIVO_F');
                            End if;                          
                          END;");
        }
    }
}
