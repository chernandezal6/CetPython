using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201705091540)]
    public class _201705091540_alter_constraint_maternidad_via : FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Sql("ALTER TABLE SISALRIL_SUIR.SFS_SUBS_MATERNIDAD_T DROP CONSTRAINT CK_SFS_SUBS_MAT_VIA");
            Execute.Sql("ALTER TABLE SISALRIL_SUIR.SFS_SUBS_MATERNIDAD_T ADD CONSTRAINT CK_SFS_SUBS_MAT_VIA CHECK (VIA  in ('NP','CB', 'CU'))");

        }

        public override void Down()
        {
            
        }
    }
}
