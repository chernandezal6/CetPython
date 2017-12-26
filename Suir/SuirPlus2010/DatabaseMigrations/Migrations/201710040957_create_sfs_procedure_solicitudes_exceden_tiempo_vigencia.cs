using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201710040957)]
    public class _201710040957_create_sfs_procedure_solicitudes_exceden_tiempo_vigencia : FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "sfs_solicitudes_exceden_tiempo.sql");
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
                               And object_name = 'SFS_SOLICITUDES_EXCEDEN_TIEMPO'
                               And object_type = 'PROCEDURE';

                            --Si el objeto exite, lo borramos
                            If v_conteo > 0 Then
                              EXECUTE IMMEDIATE('DROP PROCEDURE SUIRPLUS.SFS_SOLICITUDES_EXCEDEN_TIEMPO');
                            End if;                          
                          END;");
        }
    }
}
