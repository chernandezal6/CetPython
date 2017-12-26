using FluentMigrator;
using System;

namespace DatabaseMigrations.Migrations
{
    [Migration(201707261120)]
    public class _201707261120_insert_seg_error_t : FluentMigrator.Migration
    {
        public override void Up()
        {
            if (Schema.Schema("SUIRPLUS").Table("SEG_ERROR_T").Exists())
            {
                Insert.IntoTable("SUIRPLUS.SEG_ERROR_T").Row(new { Id_Error = "WS023", Error_Des = "Ha agotado las cuotas de consumo para este servicio.", Ult_Fecha_Act = DateTime.Now, Ult_Usuario_Act = "OPERACIONES" });
                Insert.IntoTable("SUIRPLUS.SEG_ERROR_T").Row(new { Id_Error = "WS024", Error_Des = "Este usuario tiene cuotas relacionadas con este servicio. ", Ult_Fecha_Act = DateTime.Now, Ult_Usuario_Act = "OPERACIONES" });
                Insert.IntoTable("SUIRPLUS.SEG_ERROR_T").Row(new { Id_Error = "WS025", Error_Des = "Este usuario no tiene cuotas de consumo relacionadas con este servicio. ", Ult_Fecha_Act = DateTime.Now, Ult_Usuario_Act = "OPERACIONES" });
            }
        }

        public override void Down()
        {
            if (Schema.Schema("SUIRPLUS").Table("SEG_ERROR_T").Exists())
            {
                Delete.FromTable("SUIRPLUS.SEG_ERROR_T").Row(new { Id_error = "WS023" });
                Delete.FromTable("SUIRPLUS.SEG_ERROR_T").Row(new { Id_error = "WS024" });
                Delete.FromTable("SUIRPLUS.SEG_ERROR_T").Row(new { Id_error = "WS025" });
            }
        }

    }
}
