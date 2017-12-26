using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201608040900)]
    public class _201608040900_set_value_to_module_certificac_in_srp_config_t : FluentMigrator.Migration
    {
        public override void Up()
        {
            if (Schema.Table("SRP_CONFIG_T").Column("ID_MODULO").Exists())
            {
                Update.Table("SRP_CONFIG_T").Set(new { FTP_HOST = "12", FTP_USER = "12 = ID_FIRMA DE SAHADIA CRUZ" }).Where(new { ID_MODULO = "CERTIFICAC" });
            }
        }

        public override void Down()
        {
            if (Schema.Table("SRP_CONFIG_T").Column("ID_MODULO").Exists())
            {
                Update.Table("SRP_CONFIG_T").Set(new { FTP_HOST = "", FTP_USER = "" }).Where(new { ID_MODULO = "CERTIFICAC" });
            }
        }
    }
}
