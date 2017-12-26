using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201710041639)]
    public class _201710041639_create_package_est_infantiles_pkg: FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "est_infantiles_spec_pkg.sql");
            Execute.Script(Framework.Configuration.ScriptDirectory() + "est_infantiles_body_pkg.sql");
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
                               And object_name = 'EST_INFANTILES_PKG'
                               And object_type = 'PACKAGE';

                            --Si el objeto exite, lo borramos
                            If v_conteo > 0 Then
                              EXECUTE IMMEDIATE('DROP PACKAGE SUIRPLUS.EST_INFANTILES_PKG');
                            End if;                          
                          END;");
        }
    }
}
