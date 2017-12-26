using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SuirPlusEF.Models
{
    [Table("SFC_APLICACIONES_T")]
    public class Aplicacion
    {
        [Key, Column("ID_APLICACION")]
        public string IdAplicacion { get; set; }

        [Column("DESCRIPCION")]
        public string Descripcion { get; set; }

        [Column("ULT_FECHA_ACT")]
        public DateTime? UltimaFechaActualiza { get; set; }

        [ForeignKey("Usuario"),Column("ULT_USUARIO_ACT")]
        public string UltimoUsuarioActualiza { get; set; }

        public virtual Usuario Usuario { get; set; }
    }
}
