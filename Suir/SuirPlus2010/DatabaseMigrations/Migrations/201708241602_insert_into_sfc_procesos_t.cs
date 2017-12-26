using System;
using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201708241602)]
    public class _201708241602_insert_into_sfc_procesos_t : FluentMigrator.Migration
    {
        public override void Up()
        {
            if (Schema.Schema("SUIRPLUS").Table("SFC_PROCESOS_T").Exists())
            {
                Insert.IntoTable("SUIRPLUS.SFC_PROCESOS_T").Row(new { ID_PROCESO = "ED", PROCESO_DES = "Empleadores deudores con mas de 6 periodos vencidos ", PROCESO_EJECUTAR = "sfc_historico_deudores_p", ULT_FECHA_ACT = DateTime.Now, ULT_USUARIO_ACT = "OPERACIONES", LISTA_OK = "hector_mota@mail.tss2.gov.do", LISTA_ERROR = "_divisionadministraciondeincidentes@mail.tss2.gov.do", IS_BITACORA = "S", STATUS = "A" });
            }
        }

        public override void Down()
        {
            if (Schema.Schema("SUIRPLUS").Table("SFC_PROCESOS_T").Exists())
            {
                Delete.FromTable("SUIRPLUS.SFC_PROCESOS_T").Row(new { Id_Proceso = "ED" });
            }
        }
    }
}
