using System;
using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201701201058)]
    public class _201701201058_insert_into_sfc_procesos_t: FluentMigrator.Migration
    {
        public override void Up()
        {
            if (Schema.Table("SFC_PROCESOS_T").Exists())
            {
                Insert.IntoTable("SFC_PROCESOS_T").Row(new { ID_PROCESO = "AD", PROCESO_DES = "Actualizar dgi maestro", PROCESO_EJECUTAR = "sre_actualizar_dgi_maestro_p", ULT_FECHA_ACT = DateTime.Now, ULT_USUARIO_ACT = "OPERACIONES", LISTA_OK = "roberto_jaquez@mail.tss2.gov.do,ramon_pichardo@mail.tss2.gov.do,AVT@dgii.gov.do,dba@mail.tss2.gov.do,_DivisiondeControldeOperaciones@mail.tss2.gov.do", LISTA_ERROR = "_DivisiondeControldeOperaciones@mail.tss2.gov.do", IS_BITACORA = "S", STATUS = "A" });
            }
        }

        public override void Down()
        {
            if (Schema.Table("SFC_PROCESOS_T").Exists())
            {
                Delete.FromTable("SFC_PROCESOS_T").Row(new { ID_PROCESO = "AD" });
            }
        }
    }
}
