using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201706061210)]
    public class _201706061210_sre_novedades_pkg: FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "sre_novedades_pkg.sql");
            Execute.Script(Framework.Configuration.ScriptDirectory() + "sre_novedades_body_pkg.sql");
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
                               And object_name = 'SRE_NOVEDADES_PKG'
                               And object_type = 'PACKAGE';
                           --Si el objeto exite, lo borramos
                            If v_conteo > 0 Then
                              EXECUTE IMMEDIATE('DROP PACKAGE SUIRPLUS.SRE_NOVEDADES_PKG');
                            End if;                          
                         END;");
        }
    }
}
