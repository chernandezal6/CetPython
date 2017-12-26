using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201609050501)]
    public class _201609050501_set_value_firma_tesorero_to_module_certificac_in_srp_config_t : FluentMigrator.Migration
    {
        public override void Up()
        {
            if (Schema.Table("SRP_CONFIG_T").Column("ID_MODULO").Exists())
            {
                Update.Table("SRP_CONFIG_T").Set(new { FTP_PASS = "10", FTP_PORT = "10 = ID_FIRMA DEL TESORERO" }).Where(new { ID_MODULO = "CERTIFICAC" });
            }
        }

        public override void Down()
        {
            if (Schema.Table("SRP_CONFIG_T").Column("ID_MODULO").Exists())
            {
                Update.Table("SRP_CONFIG_T").Set(new { FTP_PASS = "", FTP_PORT = "" }).Where(new { ID_MODULO = "CERTIFICAC" });
            }
        }
    }
}
