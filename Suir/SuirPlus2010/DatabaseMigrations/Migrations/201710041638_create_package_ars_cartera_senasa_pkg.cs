using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201710041638)]
    public class _201710041638_create_package_ars_cartera_senasa_pkg: FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "ars_cartera_senasa_spec_pkg.sql");
            Execute.Script(Framework.Configuration.ScriptDirectory() + "ars_cartera_senasa_body_pkg.sql");
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
                               And object_name = 'ARS_CARTERA_SENASA_PKG'
                               And object_type = 'PACKAGE';

                            --Si el objeto exite, lo borramos
                            If v_conteo > 0 Then
                              EXECUTE IMMEDIATE('DROP PACKAGE SUIRPLUS.ARS_CARTERA_SENASA_PKG');
                            End if;                          
                          END;");
        }
    }
}
