using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201705171705)]
    public class _201705171705_alter_table_sisalril_sfs_subs_maternidad_t : FluentMigrator.Migration
    {
        public override void Up()
        {
            if (Schema.Table("SISALRIL_SUIR.SFS_SUBS_MATERNIDAD_T").Column("PERIODO").Exists())
            {
                Execute.Sql("ALTER TABLE SISALRIL_SUIR.SFS_SUBS_MATERNIDAD_T MODIFY (PERIODO NULL)");
            }
        }

        public override void Down()
        {
            if (Schema.Table("SISALRIL_SUIR.SFS_SUBS_MATERNIDAD_T").Column("PERIODO").Exists())
            {
                Execute.Sql("ALTER TABLE SISALRIL_SUIR.SFS_SUBS_MATERNIDAD_T MODIFY (PERIODO NOT NULL)");
            }
        }
    }
}
