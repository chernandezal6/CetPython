using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201607221125)]
    public class _201607221125_update_sfc_procesos_t: FluentMigrator.Migration
    {
        public override void Up()
        {
            if (Schema.Table("SFC_PROCESOS_T").Column("IS_BITACORA").Exists())
            {
                Update.Table("SFC_PROCESOS_T").Set(new { IS_BITACORA = "S" }).Where(new { ID_PROCESO = "AN" });
            }
        }

        public override void Down()
        {
            if (Schema.Table("SFC_PROCESOS_T").Column("IS_BITACORA").Exists())
            {
                Update.Table("SFC_PROCESOS_T").Set(new { IS_BITACORA = "N" }).Where(new { ID_PROCESO = "AN" });
            }
        }
    }
}