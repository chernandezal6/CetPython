using System;
using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
   

    [Migration(201703201150)]
    public class _201703201150_insert_into_seg_error_t : FluentMigrator.Migration
    {
        public override void Up()
        {
            if (Schema.Table("SEG_ERROR_T").Exists())
            {
                Insert.IntoTable("SEG_ERROR_T").Row(new { Id_Error = "WS001", Error_Des = "Liquidacion no existe.", Ult_Fecha_Act = DateTime.Now, Ult_Usuario_Act = "OPERACIONES" });
                Insert.IntoTable("SEG_ERROR_T").Row(new { Id_Error = "WS002", Error_Des = "Liquidacion con estatus pagada.", Ult_Fecha_Act = DateTime.Now, Ult_Usuario_Act = "OPERACIONES" });
                Insert.IntoTable("SEG_ERROR_T").Row(new { Id_Error = "WS003", Error_Des = "Liquidacion con estatus cancelada.", Ult_Fecha_Act = DateTime.Now, Ult_Usuario_Act = "OPERACIONES" });
                Insert.IntoTable("SEG_ERROR_T").Row(new { Id_Error = "WS004", Error_Des = "Liquidacion con estatus vencida.", Ult_Fecha_Act = DateTime.Now, Ult_Usuario_Act = "OPERACIONES" });
                Insert.IntoTable("SEG_ERROR_T").Row(new { Id_Error = "WS005", Error_Des = "Liquidacion inhabilitada para ser pagada", Ult_Fecha_Act = DateTime.Now, Ult_Usuario_Act = "OPERACIONES" });
                Insert.IntoTable("SEG_ERROR_T").Row(new { Id_Error = "WS006", Error_Des = "Fecha pago debe ser mayor a la fecha emision", Ult_Fecha_Act = DateTime.Now, Ult_Usuario_Act = "OPERACIONES" });
                Insert.IntoTable("SEG_ERROR_T").Row(new { Id_Error = "WS007", Error_Des = "Entidad recaudadora no existe", Ult_Fecha_Act = DateTime.Now, Ult_Usuario_Act = "OPERACIONES" });
                Insert.IntoTable("SEG_ERROR_T").Row(new { Id_Error = "WS008", Error_Des = "Este empleador no paga infotep", Ult_Fecha_Act = DateTime.Now, Ult_Usuario_Act = "OPERACIONES" });
                Insert.IntoTable("SEG_ERROR_T").Row(new { Id_Error = "WS009", Error_Des = "Este empleador paga infotep", Ult_Fecha_Act = DateTime.Now, Ult_Usuario_Act = "OPERACIONES" });
                Insert.IntoTable("SEG_ERROR_T").Row(new { Id_Error = "WS010", Error_Des = "Error en el Usuario o Password", Ult_Fecha_Act = DateTime.Now, Ult_Usuario_Act = "OPERACIONES" });
                Insert.IntoTable("SEG_ERROR_T").Row(new { Id_Error = "WS011", Error_Des = "RNC o Cédula del empleador inválido", Ult_Fecha_Act = DateTime.Now, Ult_Usuario_Act = "OPERACIONES" });
                Insert.IntoTable("SEG_ERROR_T").Row(new { Id_Error = "WS012", Error_Des = "La fecha no debe ser futura", Ult_Fecha_Act = DateTime.Now, Ult_Usuario_Act = "OPERACIONES" });
                Insert.IntoTable("SEG_ERROR_T").Row(new { Id_Error = "WS013", Error_Des = "Error el formato de la fecha no es valido", Ult_Fecha_Act = DateTime.Now, Ult_Usuario_Act = "OPERACIONES" });
                Insert.IntoTable("SEG_ERROR_T").Row(new { Id_Error = "WS014", Error_Des = "Usuario no tiene permisos para consumir este servicio", Ult_Fecha_Act = DateTime.Now, Ult_Usuario_Act = "OPERACIONES" });
                Insert.IntoTable("SEG_ERROR_T").Row(new { Id_Error = "WS015", Error_Des = "Empleador con estatus de baja", Ult_Fecha_Act = DateTime.Now, Ult_Usuario_Act = "OPERACIONES" });
                Insert.IntoTable("SEG_ERROR_T").Row(new { Id_Error = "WS016", Error_Des = "Empleador con estatus suspendido", Ult_Fecha_Act = DateTime.Now, Ult_Usuario_Act = "OPERACIONES" });
                Insert.IntoTable("SEG_ERROR_T").Row(new { Id_Error = "WS017", Error_Des = "RNC no encontrado", Ult_Fecha_Act = DateTime.Now, Ult_Usuario_Act = "OPERACIONES" });

            }
        }

        public override void Down()
        {
            if (Schema.Table("SEG_ERROR_T").Exists())
            {
                Delete.FromTable("SEG_ERROR_T").Row(new { Id_error = "WS001" });
                Delete.FromTable("SEG_ERROR_T").Row(new { Id_error = "WS002" });
                Delete.FromTable("SEG_ERROR_T").Row(new { Id_error = "WS003" });
                Delete.FromTable("SEG_ERROR_T").Row(new { Id_error = "WS004" });
                Delete.FromTable("SEG_ERROR_T").Row(new { Id_error = "WS005" });
                Delete.FromTable("SEG_ERROR_T").Row(new { Id_error = "WS006" });
                Delete.FromTable("SEG_ERROR_T").Row(new { Id_error = "WS007" });
                Delete.FromTable("SEG_ERROR_T").Row(new { Id_error = "WS008" });
                Delete.FromTable("SEG_ERROR_T").Row(new { Id_error = "WS009" });
                Delete.FromTable("SEG_ERROR_T").Row(new { Id_error = "WS010" });
                Delete.FromTable("SEG_ERROR_T").Row(new { Id_error = "WS011" });
                Delete.FromTable("SEG_ERROR_T").Row(new { Id_error = "WS012" });
                Delete.FromTable("SEG_ERROR_T").Row(new { Id_error = "WS013" });
                Delete.FromTable("SEG_ERROR_T").Row(new { Id_error = "WS014" });
                Delete.FromTable("SEG_ERROR_T").Row(new { Id_error = "WS015" });
                Delete.FromTable("SEG_ERROR_T").Row(new { Id_error = "WS016" });
                Delete.FromTable("SEG_ERROR_T").Row(new { Id_error = "WS017" });


            }
        }
    }
}