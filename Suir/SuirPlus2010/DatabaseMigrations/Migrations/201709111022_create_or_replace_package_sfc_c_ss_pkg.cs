using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201709111022)]
    public class _201709111022_create_or_replace_package_sfc_c_ss_pkg: FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "sfc_c_ss_spec_pkg.sql");
            Execute.Script(Framework.Configuration.ScriptDirectory() + "sfc_c_ss_body_pkg.sql");
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
                               And object_name = 'SFC_C_SS_PKG'
                               And object_type = 'PACKAGE';

                           --Si el objeto exite, lo borramos
                            If v_conteo > 0 Then
                              EXECUTE IMMEDIATE('DROP PACKAGE SUIRPLUS.SFC_C_SS_PKG');
                            End if;                          
                         END;");
        }
    }
}
