using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201708241130)]
    public class _201708241130_alter_view_sfc_facturas_v : FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "sfc_facturas_v.sql");            
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
                               And object_name = 'SFC_FACTURAS_V'
                               And object_type = 'VIEW';

                          --Si el objeto exite, lo borramos
                            If v_conteo > 0 Then
                              EXECUTE IMMEDIATE('DROP VIEW SUIRPLUS.SFC_FACTURAS_V');
                            End if;                          
                         END;");
        }

    }
}
