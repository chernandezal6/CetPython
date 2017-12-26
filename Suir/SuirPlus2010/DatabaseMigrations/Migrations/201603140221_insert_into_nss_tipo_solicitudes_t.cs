using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201603140221)]
    public class _201603140221_insert_into_nss_tipo_solicitudes_t : FluentMigrator.Migration
    {

        public override void Up()
        {
            if (Schema.Table("NSS_TIPO_SOLICITUDES_T").Exists())
            {
                Insert.IntoTable("NSS_TIPO_SOLICITUDES_T").Row(new { ID_TIPO = "1", CODIGO = "ACT", DESCRIPCION = "Menor nacional con acta" });
                Insert.IntoTable("NSS_TIPO_SOLICITUDES_T").Row(new { ID_TIPO = "2", CODIGO = "NUI", DESCRIPCION = "Menor con NUI"});
                Insert.IntoTable("NSS_TIPO_SOLICITUDES_T").Row(new { ID_TIPO = "3", CODIGO = "CED", DESCRIPCION = "Cedulado" });
                Insert.IntoTable("NSS_TIPO_SOLICITUDES_T").Row(new { ID_TIPO = "4", CODIGO = "EXT", DESCRIPCION = "Trabajador extranjero" });
                Insert.IntoTable("NSS_TIPO_SOLICITUDES_T").Row(new { ID_TIPO = "5", CODIGO = "DEP", DESCRIPCION = "Dependiente trabajador extranjero" });
            }
        }

        public override void Down()
        {
            if (Schema.Table("NSS_TIPO_SOLICITUDES_T").Exists())
            {
                Delete.FromTable("NSS_TIPO_SOLICITUDES_T").Row(new { ID_TIPO = "1" });
                Delete.FromTable("NSS_TIPO_SOLICITUDES_T").Row(new { ID_TIPO = "2" });
                Delete.FromTable("NSS_TIPO_SOLICITUDES_T").Row(new { ID_TIPO = "3" });
                Delete.FromTable("NSS_TIPO_SOLICITUDES_T").Row(new { ID_TIPO = "4" });
                Delete.FromTable("NSS_TIPO_SOLICITUDES_T").Row(new { ID_TIPO = "5" });
            }
        }
    }
}
