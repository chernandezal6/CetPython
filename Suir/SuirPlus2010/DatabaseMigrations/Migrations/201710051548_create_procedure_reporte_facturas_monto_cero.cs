using FluentMigrator;
namespace DatabaseMigrations.Migrations
{
    [Migration(201710051548)]
    public class _201710051548_create_procedure_reporte_facturas_monto_cero : FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "reporte_facturas_monto_cero.sql");
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
                               And object_name = 'REPORTE_FACTURAS_MONTO_CERO'
                               And object_type = 'PROCEDURE';
                          --Si el objeto exite, lo borramos
                            If v_conteo > 0 Then
                              EXECUTE IMMEDIATE('DROP PROCEDURE SUIRPLUS.REPORTE_FACTURAS_MONTO_CERO');
                            End if;                          
                         END;");
        }
    }
}
