using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201710161402)]
    public class _201710161402_update_seg_error_t: FluentMigrator.Migration
    {
        public override void Up()
        {
            if (Schema.Schema("SUIRPLUS").Table("SEG_ERROR_T").Exists())
            {
                Update.Table("SUIRPLUS.SEG_ERROR_T").Set(new { Error_Des = "El dependiente adicional no está vinculado al núcleo familiar" }).Where(new { Id_Error = "195" });
            }
        }

        public override void Down()
        {
            if (Schema.Schema("SUIRPLUS").Table("SEG_ERROR_T").Exists())
            {
                /**/
            }
        }
    }
}
