using FluentMigrator;
namespace DatabaseMigrations.Migrations
{
    [Migration(201705161126)]
    public class _201705161126_update_seg_error_t : FluentMigrator.Migration
    {
        public override void Up()
        {
            Update.Table("SEG_ERROR_T").Set(new { ERROR_DES = "Liquidación no existe." }).Where(new { ID_ERROR = "WS001" });
            Update.Table("SEG_ERROR_T").Set(new { ERROR_DES = "Liquidación con estatus pagada." }).Where(new { ID_ERROR = "WS002" });
            Update.Table("SEG_ERROR_T").Set(new { ERROR_DES = "Liquidación con estatus cancelada." }).Where(new { ID_ERROR = "WS003" });
            Update.Table("SEG_ERROR_T").Set(new { ERROR_DES = "Liquidación con estatus vencida." }).Where(new { ID_ERROR = "WS004" });
            Update.Table("SEG_ERROR_T").Set(new { ERROR_DES = "Liquidación inhabilitada para ser pagada." }).Where(new { ID_ERROR = "WS005" });
        }

        public override void Down()
        {
           
        }
      
    }
}
