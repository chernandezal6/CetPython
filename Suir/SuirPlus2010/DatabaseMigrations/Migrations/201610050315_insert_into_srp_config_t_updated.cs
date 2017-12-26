using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201610050315)]
    public class _201610050315_insert_into_srp_config_t_updated:FluentMigrator.Migration
    {
        public override void Up()
        {
            if (Schema.Table("SRP_CONFIG_T").Column("FTP_HOST").Exists())
            {
                Update.Table("SRP_CONFIG_T").Set(new { FTP_HOST = "172.16.5.16" }).Where(new { ID_MODULO = "WS_COLANSS" });                    
            }
            if (Schema.Table("SRP_CONFIG_T").Column("FTP_PORT").Exists())
            {
                Update.Table("SRP_CONFIG_T").Set(new { FTP_PORT = "80" }).Where(new { ID_MODULO = "WS_COLANSS" });
            }
         }

        public override void Down()
        {
            if (Schema.Table("SRP_CONFIG_T").Column("FTP_HOST").Exists())
            {
                Update.Table("SRP_CONFIG_T").Set(new { FTP_HOST = "" }).Where(new { ID_MODULO = "WS_COLANSS" });
            }
            if (Schema.Table("SRP_CONFIG_T").Column("FTP_PORT").Exists())
            {
                Update.Table("SRP_CONFIG_T").Set(new { FTP_PORT = "" }).Where(new { ID_MODULO = "WS_COLANSS" });
            }
        }
    }
}
