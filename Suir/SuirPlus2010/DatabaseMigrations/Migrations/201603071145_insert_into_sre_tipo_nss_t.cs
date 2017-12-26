using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201603071145)]
    public class _201603071145_insert_into_sre_tipo_nss_t : FluentMigrator.Migration
    {
        public override void Up()
        {
            if (Schema.Table("SRE_TIPO_NSS_T").Exists())
            {
                Insert.IntoTable("SRE_TIPO_NSS_T").Row(new { Id_Tipo_NSS = 1, Descripcion = "NSS para extranjeros" });
                Insert.IntoTable("SRE_TIPO_NSS_T").Row(new { Id_Tipo_NSS = 2, Descripcion = "NSS Policias" });
            }
        }

        public override void Down()
        {
            if (Schema.Table("SRE_TIPO_NSS_T").Exists())
            {
                Delete.FromTable("SRE_TIPO_NSS_T").Row(new {Id_Tipo_NSS = 1 });
                Delete.FromTable("SRE_TIPO_NSS_T").Row(new {Id_Tipo_NSS = 2 });
            }
        }
    }
}
