using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201705091515)]
    public class _201705091515_alter_constraint_maternidad_status_dispersion : FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Sql("ALTER TABLE SISALRIL_SUIR.SFS_SUBS_MATERNIDAD_T DROP CONSTRAINT CK_SFS_SUBS_MAT_STATUS_DISP");
            Execute.Sql("ALTER TABLE SISALRIL_SUIR.SFS_SUBS_MATERNIDAD_T ADD CONSTRAINT CK_SFS_SUBS_MAT_STATUS_DISP CHECK (STATUS_DISPERSION  in ('C','G','D','R'))");

        }

        public override void Down()
        {
            
        }
    }
}
