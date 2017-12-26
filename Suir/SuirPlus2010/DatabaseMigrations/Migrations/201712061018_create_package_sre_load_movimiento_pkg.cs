using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201712061018)]
    public class _201712061018_create_package_sre_load_movimiento_pkg:FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "sre_load_movimiento_spec_pkg.sql");
            Execute.Script(Framework.Configuration.ScriptDirectory() + "sre_load_movimiento_pkg.sql");
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
                               And object_name = 'SRE_LOAD_MOVIMIENTO_PKG'
                               And object_type = 'PACKAGE';
                            --Si el objeto exite, lo borramos
                            If v_conteo > 0 Then
                              EXECUTE IMMEDIATE('DROP PACKAGE SUIRPLUS.SRE_LOAD_MOVIMIENTO_PKG');
                            End if;                          
                         END;");
        }
    }
}
