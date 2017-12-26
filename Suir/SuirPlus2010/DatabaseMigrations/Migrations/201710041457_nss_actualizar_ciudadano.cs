using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201710041457)]
    public class _201710041457_nss_actualizar_ciudadano: FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "nss_actualizar_ciudadano.sql");
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
                               And object_name = 'NSS_ACTUALIZAR_CIUDADANO'
                               And object_type = 'PROCEDURE';

                            --Si el objeto exite, lo borramos
                            If v_conteo > 0 Then
                              EXECUTE IMMEDIATE('DROP PACKAGE SUIRPLUS.NSS_ACTUALIZAR_CIUDADANO');
                            End if;                          
                          END;");
        }
    }
}
