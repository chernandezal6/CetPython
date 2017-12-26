using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201708241125)]
    public class _201708241125_create_or_replace_package_sub_sfs_dispersion_pkg : FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "sub_sfs_dispersion_spec_pkg.sql");
            Execute.Script(Framework.Configuration.ScriptDirectory() + "sub_sfs_dispersion_body_pkg.sql");
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
                               And object_name = 'SUB_SFS_DISPERSION_PKG'
                               And object_type = 'PACKAGE';

                           --Si el objeto exite, lo borramos
                            If v_conteo > 0 Then
                              EXECUTE IMMEDIATE('DROP PACKAGE SUIRPLUS.SUB_SFS_DISPERSION_PKG');
                            End if;                          
                         END;");
        }
    }
}
