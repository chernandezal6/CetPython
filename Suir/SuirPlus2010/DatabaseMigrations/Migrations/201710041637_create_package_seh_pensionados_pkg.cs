using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201710041637)]
    public class _201710041637_create_package_seh_pensionados_pkg: FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "seh_pensionados_spec_pkg.sql");
            Execute.Script(Framework.Configuration.ScriptDirectory() + "seh_pensionados_body_pkg.sql");
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
                               And object_name = 'SEH_PENSIONADOS_PKG'
                               And object_type = 'PACKAGE';

                            --Si el objeto exite, lo borramos
                            If v_conteo > 0 Then
                              EXECUTE IMMEDIATE('DROP PACKAGE SUIRPLUS.SEH_PENSIONADOS_PKG');
                            End if;                          
                          END;");
        }
    }
}
