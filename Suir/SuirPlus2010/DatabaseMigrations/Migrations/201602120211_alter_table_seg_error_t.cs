using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201602120211)]
    public class _201602120211_alter_table_seg_error_t : FluentMigrator.Migration
    {
        public override void Up()
        {
            if (Schema.Table("SEG_ERROR_T").Column("ID_ERROR").Exists())
            {
                Alter.Table("SEG_ERROR_T")
                    .AlterColumn("ID_ERROR")
                    .AsCustom("VARCHAR2(10)")
                    .WithColumnDescription("ID de los errores definidos en la tabla SEG_ERRORR_T");
            }
        }

        public override void Down()
        {
            if (Schema.Table("SEG_ERROR_T").Column("ID_ERROR_T").Exists())
            {

            }
        }
    }
}
