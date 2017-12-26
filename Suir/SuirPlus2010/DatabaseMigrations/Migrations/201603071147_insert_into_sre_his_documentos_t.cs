using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201603071147)]
    public class _201603071147_insert_into_sre_his_documentos_t : FluentMigrator.Migration 
    {
        public override void Up()
        {
            if (Schema.Table("SRE_HIS_DOCUMENTOS_T").Exists())
            {
                //Insert.IntoTable("SRE_HIS_DOCUMENTOS_T").Row(new { ID = "1", id_nss = 751737, no_documento = "00111941480", Id_Tipo_DOCUMENTO = "C", fecha_emision = DateTime.Now, Estatus = "A", registrado_por = "40151707800104137708", fecha_registro = DateTime.Now });
                //Insert.IntoTable("SRE_HIS_DOCUMENTOS_T").Row(new { ID = "2", id_nss = 751737, no_documento = "00201532900", Id_Tipo_DOCUMENTO = "C", fecha_emision = DateTime.Now, Estatus = "C", registrado_por = "40151707800104137708", fecha_registro = DateTime.Now });
            }
        }

        public override void Down()
        {
            if (Schema.Table("SRE_HIS_DOCUMENTOS_T").Exists())
            {
                //Delete.FromTable("SRE_HIS_DOCUMENTOS_T").Row(new { ID = "1" });
                //Delete.FromTable("SRE_HIS_DOCUMENTOS_T").Row(new { ID = "2" });
            }
        }
    }
}
