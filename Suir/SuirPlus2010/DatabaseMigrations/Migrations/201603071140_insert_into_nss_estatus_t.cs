using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using FluentMigrator;
namespace DatabaseMigrations.Migrations
{
    [Migration(201603071140)]
    public class _201603071140_insert_into_nss_estatus_t:FluentMigrator.Migration
    {
        public override void Up()
        {
            if (Schema.Table("NSS_ESTATUS_T").Exists())
            {
                Insert.IntoTable("NSS_ESTATUS_T").Row(new { ID_ESTATUS = "1", DESCRIPCION = "Pendiente" });
                Insert.IntoTable("NSS_ESTATUS_T").Row(new { ID_ESTATUS = "2", DESCRIPCION = "NSS asignado" });
                Insert.IntoTable("NSS_ESTATUS_T").Row(new { ID_ESTATUS = "3", DESCRIPCION = "NSS existe" });
                Insert.IntoTable("NSS_ESTATUS_T").Row(new { ID_ESTATUS = "4", DESCRIPCION = "Registro enviado a evaluación visual" });
                Insert.IntoTable("NSS_ESTATUS_T").Row(new { ID_ESTATUS = "5", DESCRIPCION = "Número de documento no encontrado" });
                Insert.IntoTable("NSS_ESTATUS_T").Row(new { ID_ESTATUS = "6", DESCRIPCION = "Regristro rechazado"});
                Insert.IntoTable("NSS_ESTATUS_T").Row(new { ID_ESTATUS = "7", DESCRIPCION = "Regristro actualizado" });
            }
        }

        public override void Down()
        {
            if (Schema.Table("NSS_ESTATUS_T").Exists())
            {
                Delete.FromTable("NSS_ESTATUS_T").Row(new { ID_ESTATUS = "1" });
                Delete.FromTable("NSS_ESTATUS_T").Row(new { ID_ESTATUS = "2" });
                Delete.FromTable("NSS_ESTATUS_T").Row(new { ID_ESTATUS = "3" });
                Delete.FromTable("NSS_ESTATUS_T").Row(new { ID_ESTATUS = "4" });
                Delete.FromTable("NSS_ESTATUS_T").Row(new { ID_ESTATUS = "5" });
                Delete.FromTable("NSS_ESTATUS_T").Row(new { ID_ESTATUS = "6" });
                Delete.FromTable("NSS_ESTATUS_T").Row(new { ID_ESTATUS = "7" });
            }
        }
    }
}
