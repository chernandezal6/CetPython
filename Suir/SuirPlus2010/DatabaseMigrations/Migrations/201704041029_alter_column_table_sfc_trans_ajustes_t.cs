using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201704041029)]
    public class _201704041029_alter_column_table_sfc_trans_ajustes_t : FluentMigrator.Migration
    {
        public override void Up()
        {
            if (Schema.Table("SFC_TRANS_AJUSTES_T").Column("unico").Exists())
            {
                Execute.Sql("ALTER TABLE SUIRPLUS.SFC_TRANS_AJUSTES_T MODIFY (UNICO VARCHAR2(50))");
            }
        }

        public override void Down()
        {
            if (Schema.Table("SFC_TRANS_AJUSTES_T").Column("unico").Exists())
            {

            }
        }
    }
}

