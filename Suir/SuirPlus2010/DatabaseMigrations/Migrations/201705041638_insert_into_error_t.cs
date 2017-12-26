using FluentMigrator;
using System;
namespace DatabaseMigrations.Migrations
{
    [Migration(201705041638)]
    public class _201705041638_insert_into_error_t: FluentMigrator.Migration
    {        
        public override void Up()
        {
            if (Schema.Table("SEG_ERROR_T").Exists())
            {
                Insert.IntoTable("SEG_ERROR_T").Row(new { Id_Error = "WS018", Error_Des = "Cédula inválida.", Ult_Fecha_Act = DateTime.Now, Ult_Usuario_Act = "OPERACIONES" });
                Insert.IntoTable("SEG_ERROR_T").Row(new { Id_Error = "WS019", Error_Des = "Año inválido", Ult_Fecha_Act = DateTime.Now, Ult_Usuario_Act = "OPERACIONES" });
                Insert.IntoTable("SEG_ERROR_T").Row(new { Id_Error = "WS020", Error_Des = "Categoría riesgo inválida", Ult_Fecha_Act = DateTime.Now, Ult_Usuario_Act = "OPERACIONES" });
                Insert.IntoTable("SEG_ERROR_T").Row(new { Id_Error = "WS021", Error_Des = "Documento inválido", Ult_Fecha_Act = DateTime.Now, Ult_Usuario_Act = "OPERACIONES" });
            }
        }
        public override void Down()
        {
            if (Schema.Table("SEG_ERROR_T").Exists())
            {
                Delete.FromTable("SEG_ERROR_T").Row(new { Id_error = "WS018" });
                Delete.FromTable("SEG_ERROR_T").Row(new { Id_error = "WS019" });
                Delete.FromTable("SEG_ERROR_T").Row(new { Id_error = "WS020" });
                Delete.FromTable("SEG_ERROR_T").Row(new { Id_error = "WS021" });
            }
        }
    }
}
