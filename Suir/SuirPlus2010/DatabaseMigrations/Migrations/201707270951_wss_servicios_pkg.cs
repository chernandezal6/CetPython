using FluentMigrator;
namespace DatabaseMigrations.Migrations
{
    [Migration(201707270951)]
    public class _201707270951_wss_servicios_pkg : FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "wss_servicios_pkg.sql");
            Execute.Script(Framework.Configuration.ScriptDirectory() + "wss_servicios_body_pkg.sql");
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
                               And object_name = 'WSS_SERVICIOS_PKG'
                               And object_type = 'PACKAGE';

                          --Si el objeto exite, lo borramos
                            If v_conteo > 0 Then
                              EXECUTE IMMEDIATE('DROP PACKAGE SUIRPLUS.WSS_SERVICIOS_PKG');
                            End if;                          
                         END;");
        }
    }
}
