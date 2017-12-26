using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SuirPlusEF.Models
{
   [Table("SEG_ERROR_T")]
   public class Error
    {
         [Key,Column("ID_ERROR")]
         public string IdError { get; set; }
         [Column("ERROR_DES")]
         public string Descripcion { get; set; }

         [Column("CODIGO_ERROR_BD")]
         public string CodigoErrorDb { get; set; }
         
         [Column("ULT_FECHA_ACT")]
         public DateTime ? UltimaFechaActualizacion { get; set; }

         [Column("ULT_USUARIO_ACT")]
         public string UltimoUsuarioActualizo { get; set; }
    }
}
