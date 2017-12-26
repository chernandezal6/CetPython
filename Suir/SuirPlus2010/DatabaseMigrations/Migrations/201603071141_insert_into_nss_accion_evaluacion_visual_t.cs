using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using FluentMigrator;
namespace DatabaseMigrations
{
    [Migration(201603071141)]
    public class _201603071141_insert_into_nss_accion_evaluacion_visual_t: FluentMigrator.Migration
    {
        public override void Up()
        {
            if (Schema.Table("NSS_ACCION_EVALUACION_VISUAL_T").Exists())
            {
                Insert.IntoTable("NSS_ACCION_EVALUACION_VISUAL_T").Row(new { ID_ACCION_EV = "1", DESCRIPCION = "Asignar" });
                Insert.IntoTable("NSS_ACCION_EVALUACION_VISUAL_T").Row(new { ID_ACCION_EV = "2", DESCRIPCION = "Actualizar" });
                Insert.IntoTable("NSS_ACCION_EVALUACION_VISUAL_T").Row(new { ID_ACCION_EV = "3", DESCRIPCION = "Rechazar" });
            }
        }

        public override void Down()
        {
            if (Schema.Table("NSS_ACCION_EVALUACION_VISUAL_T").Exists())
            {
                Delete.FromTable("NSS_ACCION_EVALUACION_VISUAL_T").Row(new { ID_ACCION_EV = "1" });
                Delete.FromTable("NSS_ACCION_EVALUACION_VISUAL_T").Row(new { ID_ACCION_EV = "2" });
                Delete.FromTable("NSS_ACCION_EVALUACION_VISUAL_T").Row(new { ID_ACCION_EV = "3" });
            }
        }

    }
}
