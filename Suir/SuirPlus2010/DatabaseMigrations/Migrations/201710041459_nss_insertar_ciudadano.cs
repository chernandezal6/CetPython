using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201710041459)]
    public class _201710041459_nss_insertar_ciudadano: FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "nss_insertar_ciudadano.sql");
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
                               And object_name = 'NSS_INSERTAR_CIUDADANO'
                               And object_type = 'PROCEDURE';

                            --Si el objeto exite, lo borramos
                            If v_conteo > 0 Then
                              EXECUTE IMMEDIATE('DROP PACKAGE SUIRPLUS.NSS_INSERTAR_CIUDADANO');
                            End if;                          
                          END;");
        }
    }
}
