using FluentMigrator;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DatabaseMigrations.Migrations
{
    [Migration(201602120212)]
    public class _201602120212_insert_into_seg_error_t : FluentMigrator.Migration
    {    
        public override void Up()
        {
            if (Schema.Table("SEG_ERROR_T").Exists())
            {
                Insert.IntoTable("SEG_ERROR_T").Row(new { Id_Error = "236", Error_Des = "No se suministro valor para el ID del Proceso",                            Ult_Fecha_Act = DateTime.Now, Ult_Usuario_Act = "GHERRERA" });
                Insert.IntoTable("SEG_ERROR_T").Row(new { Id_Error = "237", Error_Des = "No se suministro el valor para el STATUS inicial del mensaje a notificar", Ult_Fecha_Act = DateTime.Now, Ult_Usuario_Act = "GHERRERA" });
                Insert.IntoTable("SEG_ERROR_T").Row(new { Id_Error = "238", Error_Des = "No se ha definido el valor del CANAL en la tabla SEC_PROCESOS_T",          Ult_Fecha_Act = DateTime.Now, Ult_Usuario_Act = "GHERRERA" });
                Insert.IntoTable("SEG_ERROR_T").Row(new { Id_Error = "239", Error_Des = "No se la definido la lista de USUARIOS que seran notificadas",             Ult_Fecha_Act = DateTime.Now, Ult_Usuario_Act = "GHERRERA" });
                Insert.IntoTable("SEG_ERROR_T").Row(new { Id_Error = "240", Error_Des = "El ID Proceso especificado no existe en la tabla SFC_PROCESOS_T",          Ult_Fecha_Act = DateTime.Now, Ult_Usuario_Act = "GHERRERA" });
                Insert.IntoTable("SEG_ERROR_T").Row(new { Id_Error = "241", Error_Des = "Error de prueba para la tabla nss_validaciones_t",                         Ult_Fecha_Act = DateTime.Now, Ult_Usuario_Act = "GHERRERA" });
            }
        }

        public override void Down()
        {
            if (Schema.Table("SEG_ERROR_T").Exists())
            {
                Delete.FromTable("SEG_ERROR_T").Row(new { Id_Error = "236" });
                Delete.FromTable("SEG_ERROR_T").Row(new { Id_Error = "237" });
                Delete.FromTable("SEG_ERROR_T").Row(new { Id_Error = "238" });
                Delete.FromTable("SEG_ERROR_T").Row(new { Id_Error = "239" });
                Delete.FromTable("SEG_ERROR_T").Row(new { Id_Error = "240" });
                Delete.FromTable("SEG_ERROR_T").Row(new { Id_Error = "241" });
            }
        }
    }
}
