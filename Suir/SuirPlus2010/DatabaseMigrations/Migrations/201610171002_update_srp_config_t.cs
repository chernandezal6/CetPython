using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201610171002)]
    public class _201610171002_update_srp_config_t: FluentMigrator.Migration
    {
        public override void Up()
        {
            if (Schema.Table("SRP_CONFIG_T").Column("FTP_HOST").Exists())
            {
                Update.Table("SRP_CONFIG_T").Set(new { FTP_HOST = "NSS902,NSS903,NSS904,NSS905,NSS906,NSS907,NSS908" }).Where(new { ID_MODULO = "NSS_RE" });
            }
        }

        public override void Down()
        {
            if (Schema.Table("SRP_CONFIG_T").Column("FTP_HOST").Exists())
            {
                Update.Table("SRP_CONFIG_T").Set(new { FTP_HOST = "" }).Where(new { ID_MODULO = "NSS_RE" });
            }
        }
    }
}
