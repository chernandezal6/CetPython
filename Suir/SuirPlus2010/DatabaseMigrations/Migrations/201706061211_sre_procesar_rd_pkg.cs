using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201706061211)]
    public class _201706061211_sre_procesar_rd_pkg: FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "sre_procesar_rd_spec_pkg.sql");
            Execute.Script(Framework.Configuration.ScriptDirectory() + "sre_procesar_rd_body_pkg.sql");
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
                               And object_name = 'SRE_PROCESAR_RD_PKG'
                               And object_type = 'PACKAGE';
                           --Si el objeto exite, lo borramos
                            If v_conteo > 0 Then
                              EXECUTE IMMEDIATE('DROP PACKAGE SUIRPLUS.SRE_PROCESAR_RD_PKG');
                            End if;                          
                         END;");
        }
    }
}
