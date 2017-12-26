using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SuirPlusEF.Models
{
    [Table("SFC_RENGLONES_T")]
    public class Renglon
    {
        [Key, ForeignKey("Aplicaciones") ,Column("ID_APLICACION", Order = 0)]
        public string IdAplicacion { get; set; }

        [Key, Column("ID_RENGLON", Order = 1)]
        public string IdRenglon { get; set; }

        [Column("DESCRIPCION")]
        public string Descripcion { get; set; }

        [Column("ULT_FECHA_ACT")]
        public DateTime? UltimaFechaActualiza { get; set; }

        [ForeignKey("Usuario"),Column("ULT_USUARIO_ACT")]
        public string UltimoUsuarioActualiza { get; set; }

        public virtual Usuario Usuario { get; set; }
        [ForeignKey("IdAplicacion,IdRenglon")]
        public virtual Aplicacion Aplicaciones { get; set; }
    }
}
