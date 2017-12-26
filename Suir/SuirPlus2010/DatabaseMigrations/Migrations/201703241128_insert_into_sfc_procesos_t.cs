using System;
using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201703241128)]
    public class _201703241128_insert_into_sfc_procesos_t: FluentMigrator.Migration
    {
        public override void Up()
        {
            if (Schema.Table("SFC_PROCESOS_T").Exists())
            {
                Insert.IntoTable("SFC_PROCESOS_T").Row(new { Id_Proceso = "90", Proceso_Des = "SFC- VALIDAS LOS DETALLES DE PAGOS DE ACLARACIONES", Proceso_Ejecutar = "SFC_DETALLE_PAGOS_ACLARACIONES", Lista_OK = "_divisionadministraciondeincidentes@mail.tss2.gov.do,h.sahdala@mail.tss2.gov.do,h.mota@mail.tss.gov.do,marvin_pimentel@mail.tss2.gov.do,germontas@dgii.gov.do,hnoboa@dgii.gov.do",Lista_error = "_divisionadministraciondeincidentes@mail.tss2.gov.do", Ult_Fecha_Act = DateTime.Now, Ult_Usuario_Act = "MHERNANDEZ", Is_Bitacora = "S", Status = "A" });

                Insert.IntoTable("SFC_PROCESOS_T").Row(new { Id_Proceso = "91", Proceso_Des = "CREA EL ARCHIVO NACHA CORRESPONDIENTE A LA ENTIDAD RECAUDADORA", Proceso_Ejecutar = "SFC_NACHA_P", Lista_OK = "_divisionadministraciondeincidentes@mail.tss2.gov.do", Lista_error = "_divisionadministraciondeincidentes@mail.tss2.gov.do", Ult_Fecha_Act = DateTime.Now, Ult_Usuario_Act = "MHERNANDEZ", Is_Bitacora = "S", Status = "A" });

                Insert.IntoTable("SFC_PROCESOS_T").Row(new { Id_Proceso = "92", Proceso_Des = "SFC RE-ENVIO DE MOVIMIENTO", Proceso_Ejecutar = "SFC_REENVIO_DE_MOVIMIENTO_P", Lista_OK = "_divisionadministraciondeincidentes@mail.tss2.gov.do,dba@mail.tss2.gov.do", Lista_error = "_divisionadministraciondeincidentes@mail.tss2.gov.do", Ult_Fecha_Act = DateTime.Now, Ult_Usuario_Act = "MHERNANDEZ", Is_Bitacora = "S", Status = "A" });

            }
        }
        public override void Down()
        {
            if (Schema.Table("SFC_PROCESOS_T").Exists())
            {
                Delete.FromTable("SFC_PROCESOS_T").Row(new { Id_Proceso = "90" });
                Delete.FromTable("SFC_PROCESOS_T").Row(new { Id_Proceso = "91" });
                Delete.FromTable("SFC_PROCESOS_T").Row(new { Id_Proceso = "92" });
            }
        }
    }
}
