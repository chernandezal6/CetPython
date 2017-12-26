using System;
using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201710061425)]
    public class _201710061425_insert_into_sfc_procesos_t : FluentMigrator.Migration
    {
        public override void Up()
        {
            if (Schema.Schema("SUIRPLUS").Table("SFC_PROCESOS_T").Exists())
            {
                Insert.IntoTable("SUIRPLUS.SFC_PROCESOS_T").Row(new { ID_PROCESO = "N0", PROCESO_DES = "Reporte diario Nps con valor 0", PROCESO_EJECUTAR = "reporte_facturas_monto_0", ULT_FECHA_ACT = DateTime.Now, ULT_USUARIO_ACT = "OPERACIONES", LISTA_OK = "_divisionadministraciondeincidentes@mail.tss2.gov.do", LISTA_ERROR = "_divisionadministraciondeincidentes@mail.tss2.gov.do", IS_BITACORA = "S", STATUS = "A" });
            }
        }

        public override void Down()
        {
            if (Schema.Schema("SUIRPLUS").Table("SFC_PROCESOS_T").Exists())
            {
                Delete.FromTable("SUIRPLUS.SFC_PROCESOS_T").Row(new { Id_Proceso = "N0" });
            }
        }
    }
}
