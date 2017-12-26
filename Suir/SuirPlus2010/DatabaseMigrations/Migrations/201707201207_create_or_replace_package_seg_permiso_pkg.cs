using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201707201207)]
    public class _201707201207_create_or_replace_package_seg_permiso_pkg : FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "seg_permiso_spec_pkg.sql");
            Execute.Script(Framework.Configuration.ScriptDirectory() + "seg_permiso_body_pkg.sql");
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
                               And object_name = 'SEG_PERMISO_PKG'
                               And object_type = 'PACKAGE';

                           --Si el objeto exite, lo borramos
                            If v_conteo > 0 Then
                              EXECUTE IMMEDIATE('DROP PACKAGE SUIRPLUS.SEG_PERMISO_PKG');
                            End if;                          
                         END;");
        }
    }
}
