using System;
using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
   

    [Migration(201704051450)]
    public class _201704051450_insert_into_seg_permiso_t  : FluentMigrator.Migration
    {
        public override void Up()
        {
            if (Schema.Table("SEG_PERMISO_T").Exists())
            {
                Insert.IntoTable("SEG_PERMISO_T").Row(new { ID_PERMISO = 470, ID_SECCION = 76, PERMISO_DES = "Servicios_INFOTEP", DIRECCION_ELECTRONICA = "Servicios_INFOTEP.asmx", TIPO_PERMISO = "O", STATUS = "A", ULT_USUARIO_ACT = "OPERACIONES", ULT_FECHA_ACT = DateTime.Now, ORDEN_MENU = DBNull.Value });
            }
        }

        public override void Down()
        {
            if (Schema.Table("SEG_PERMISO_T").Exists())
            {
              
            }
        }
    }
}