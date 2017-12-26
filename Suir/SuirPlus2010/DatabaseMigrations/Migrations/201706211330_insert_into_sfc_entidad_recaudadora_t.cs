using System;
using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201706211330)]
    public class _201706211330_insert_into_sfc_entidad_recaudadora_t : FluentMigrator.Migration
    {
        public override void Up()
        {
            if (Schema.Schema("SUIRPLUS").Table("SFC_ENTIDAD_RECAUDADORA_T").Exists())
            {
                Insert.IntoTable("SUIRPLUS.SFC_ENTIDAD_RECAUDADORA_T").Row(new { ID_ENTIDAD_RECAUDADORA = 71, ENTIDAD_RECAUDADORA_DES = "Jubilación y Pensión DGJP", ULT_FECHA_ACT = DateTime.Now, ULT_USUARIO_ACT ="OPERACIONES"});
                Insert.IntoTable("SUIRPLUS.SFC_ENTIDAD_RECAUDADORA_T").Row(new { ID_ENTIDAD_RECAUDADORA = 72, ENTIDAD_RECAUDADORA_DES = "Junta de Retiro Fuerzas Armadas JRFFAA", ULT_FECHA_ACT = DateTime.Now, ULT_USUARIO_ACT = "OPERACIONES" });
                Insert.IntoTable("SUIRPLUS.SFC_ENTIDAD_RECAUDADORA_T").Row(new { ID_ENTIDAD_RECAUDADORA = 73, ENTIDAD_RECAUDADORA_DES = "ARS CMD", ULT_FECHA_ACT = DateTime.Now, ULT_USUARIO_ACT = "OPERACIONES" });
                Insert.IntoTable("SUIRPLUS.SFC_ENTIDAD_RECAUDADORA_T").Row(new { ID_ENTIDAD_RECAUDADORA = 74, ENTIDAD_RECAUDADORA_DES = "ARS SENASA", ULT_FECHA_ACT = DateTime.Now, ULT_USUARIO_ACT = "OPERACIONES" });
            }
        }
        public override void Down()
        {
            if (Schema.Schema("SUIRPLUS").Table("SFC_ENTIDAD_RECAUDADORA_T").Exists())
            {
                Delete.FromTable("SUIRPLUS.SFC_ENTIDAD_RECAUDADORA_T").Row(new { ID_ENTIDAD_RECAUDADORA = 71 });
                Delete.FromTable("SUIRPLUS.SFC_ENTIDAD_RECAUDADORA_T").Row(new { ID_ENTIDAD_RECAUDADORA = 72 });
                Delete.FromTable("SUIRPLUS.SFC_ENTIDAD_RECAUDADORA_T").Row(new { ID_ENTIDAD_RECAUDADORA = 73 });
                Delete.FromTable("SUIRPLUS.SFC_ENTIDAD_RECAUDADORA_T").Row(new { ID_ENTIDAD_RECAUDADORA = 74 });
            }
        }
    }
}
