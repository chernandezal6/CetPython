using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SuirPlusEF.Models
{
     [Table("SEG_PERMISO_T")]
    public class Permiso
    {
         [Key, Column("ID_PERMISO")]
         public Int32 IdPermiso { get; set; }

         [Column("ID_SECCION")]
         public Int32 ? IdSeccion { get; set; }

         [Column("PERMISO_DES")]
         public string Descripcion { get; set; }
         
         [Column("DIRECCION_ELECTRONICA")]
         public string Email { get; set; }

         [Column("TIPO_PERMISO")]
         public string TipoPermiso { get; set; }
       
         [Column("STATUS")]
         public string Estatus { get; set; }

         [Column("ULT_USUARIO_ACT")]
         public string UltimoUsuarioActualizo { get; set; }

         [Column("ULT_FECHA_ACT")]
         public DateTime ? UltimaFechaActualizacion { get; set; }

         [Column("ORDEN_MENU")]
         public Int32 ? OrdenMenu { get; set; }
    }
}
