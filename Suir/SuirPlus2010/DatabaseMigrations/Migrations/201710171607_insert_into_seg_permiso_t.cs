using FluentMigrator;
using System;

namespace DatabaseMigrations.Migrations
{  
    [Migration(201710171607)]
    public class _201710171607_insert_into_seg_permiso_t  : FluentMigrator.Migration
    {
        public override void Up()
        {
            if (Schema.Schema("SUIRPLUS").Table("SEG_PERMISO_T").Exists())
            {                
                Insert.IntoTable("SUIRPLUS.SEG_PERMISO_T").Row(new { ID_PERMISO = 535, ID_SECCION = 34, PERMISO_DES = "Gestión de Cuotas por Servicios", DIRECCION_ELECTRONICA = "Mantenimientos/CuotaWebServices.aspx", TIPO_PERMISO = "M", STATUS = "A", ULT_USUARIO_ACT = "OPERACIONES", ULT_FECHA_ACT = DateTime.Now, ORDEN_MENU = 0 });
            }
        }

        public override void Down()
        {
            if (Schema.Table("SUIRPLUS.SEG_PERMISO_T").Exists())
            {
              /**/
            }
        }
    }
}