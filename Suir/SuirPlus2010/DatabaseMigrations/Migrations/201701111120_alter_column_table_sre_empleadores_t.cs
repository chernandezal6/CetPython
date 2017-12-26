using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201701111120)]
    public class _201701111120_alter_column_table_sre_empleadores_t : FluentMigrator.Migration
    {
        public override void Up()
        {
            if (Schema.Table("SRE_EMPLEADORES_T").Column("id_sector_economico").Exists())
            {
                Execute.Sql("ALTER TABLE SUIRPLUS.SRE_EMPLEADORES_T MODIFY (ID_SECTOR_ECONOMICO NOT NULL)");
            }
        }

        public override void Down()
        {
            if (Schema.Table("SRE_EMPLEADORES_T").Column("ID_SECTOR_ECONOMICO").Exists())
            {

            }
        }
    }
}

