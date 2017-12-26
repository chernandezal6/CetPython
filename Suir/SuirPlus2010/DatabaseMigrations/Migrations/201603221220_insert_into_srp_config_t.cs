using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201603221220)]
    public class _201603221220_insert_into_srp_config_t : FluentMigrator.Migration
    {
        public override void Up()
        {
            if (Schema.Table("SRP_CONFIG_T").Exists())
            {
                Insert.IntoTable("SRP_CONFIG_T").Row(new { ID_MODULO = "WS_NUI_JCE", FIELD1 = "http://10.12.201.7:8090/Consulta/69c40cff-9890-4a72-8238-99cee35175a6", FIELD2 = "2" });
                Insert.IntoTable("SRP_CONFIG_T").Row(new { ID_MODULO = "WS_COLANSS", FTP_HOST = "172.16.5.20", FTP_PORT = "49204", FTP_USER = "172.16.5.6" }); //FTP_HOST y FTP_PORT = host y puerto del proyecto suir webservice. FTP_USER = host donde este instalado RABBITMQ
                Insert.IntoTable("SRP_CONFIG_T").Row(new { ID_MODULO = "NSS_RE", FTP_HOST = "NSS901,NSS902,NSS903,NSS904,NSS905,NSS906,NSS907,NSS908" }); 

            }
        }

        public override void Down()
        {
            if (Schema.Table("SRP_CONFIG_T").Exists())
            {
                Delete.FromTable("SRP_CONFIG_T").Row(new { ID_MODULO = "WS_NUI_JCE" });
                Delete.FromTable("SRP_CONFIG_T").Row(new { ID_MODULO = "WS_COLANSS" });
                Delete.FromTable("SRP_CONFIG_T").Row(new { ID_MODULO = "NSS_RE" });
                
            }
        }
    }
}
