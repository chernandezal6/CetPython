using System;
using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201709251532)]
    public class _201709251532_insert_into_sub_errores_sisalril_t:FluentMigrator.Migration
    {
      public override void Up()
        {
            if (Schema.Schema("SUIRPLUS").Table("SUB_ERRORES_SISALRIL_T").Exists())
            {
                Insert.IntoTable("SUIRPLUS.SUB_ERRORES_SISALRIL_T").Row(new { Id_Error = "4002", Descripcion = "Trabajadora posee una solicitud activa para este Empleador", Ult_Fecha_Act = DateTime.Now, Definitivo = "N" });
            }
        }

        public override void Down()
        {
            if (Schema.Schema("SUIRPLUS").Table("SUB_ERRORES_SISALRIL_T").Exists())
            {
                Delete.FromTable("SUIRPLUS.SUB_ERRORES_SISALRIL_T").Row(new { Id_Error = "4002" });
            }
        }
    }
}
