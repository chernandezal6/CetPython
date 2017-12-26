using System;
using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201706121450)]
   public class _201706121450_insert_into_sfc_procesos_t:FluentMigrator.Migration
    {
        public override void Up()
        {
            if (Schema.Schema("SUIRPLUS").Table("SFC_PROCESOS_T").Exists())
            {
                Insert.IntoTable("suirplus.sfc_procesos_t").Row(new { ID_PROCESO = "AF", PROCESO_DES = "Actualizacion ars cobertura fonamat ", PROCESO_EJECUTAR = "ars_cobertura_fono_senasa_p", ULT_FECHA_ACT = DateTime.Now, ULT_USUARIO_ACT = "MHERNANDEZ", LISTA_OK = "_divisionadministraciondeincidentes@mail.tss2.gov.do", LISTA_ERROR = "_divisionadministraciondeincidentes@mail.tss2.gov.do", IS_BITACORA = "S", STATUS = "A" });
            }
        }

        public override void Down()
        {
            if (Schema.Schema("SUIRPLUS").Table("SFC_PROCESOS_T").Exists())
            {
                Delete.FromTable("SUIRPLUS.SFC_PROCESOS_T").Row(new { Id_Proceso = "AF" });
            }
        }
    }
}
