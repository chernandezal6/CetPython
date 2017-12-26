using FluentMigrator;
using System;

namespace DatabaseMigrations.Migrations
{
    [Migration(201711161056)]
    public class _201711161056_insert_into_sfc_procesos_t: FluentMigrator.Migration
    {
        public override void Up()
        {
            if (Schema.Schema("SUIRPLUS").Table("SFC_PROCESOS_T").Exists())
            {
                Insert.IntoTable("SUIRPLUS.SFC_PROCESOS_T").Row(
                    new { ID_PROCESO = "BT",
                          PROCESO_DES = "Baja a trabajadores activos de empleadores en estatus SUSPENDIDO",
                          PROCESO_EJECUTAR = "SRE_BAJA_TRABAJADORES_P",
                          ULT_FECHA_ACT = DateTime.Now,
                          ULT_USUARIO_ACT = "OPERACIONES",
                          LISTA_OK = "_divisionadministraciondeincidentes@mail.tss2.gov.do",
                          LISTA_ERROR = "_divisionadministraciondeincidentes@mail.tss2.gov.do",
                          IS_BITACORA = "S",
                          LANZADOR = 'S',
                          STATUS = "A"
                        }
                );
            }
        }

        public override void Down()
        {
            if (Schema.Schema("SUIRPLUS").Table("SFC_PROCESOS_T").Exists())
            {
                Delete.FromTable("SUIRPLUS.SFC_PROCESOS_T").Row(new { Id_Proceso = "BT" });
            }
        }
    }
}
