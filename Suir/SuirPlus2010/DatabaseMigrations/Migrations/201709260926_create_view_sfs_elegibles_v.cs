using FluentMigrator;
namespace DatabaseMigrations.Migrations
{
    [Migration(201709260926)]
    public class _201709260926_create_view_sfs_elegibles_v: FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "sfs_elegibles_v.sql");
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
                               And object_name = 'SFS_ELEGIBLES_V'
                               And object_type = 'VIEW';

                           --Si el objeto exite, lo borramos
                            If v_conteo > 0 Then
                              EXECUTE IMMEDIATE('DROP VIEW SUIRPLUS.SFS_ELEGIBLES_V');
                            End if;                          
                         END;");
        }
    }
}
