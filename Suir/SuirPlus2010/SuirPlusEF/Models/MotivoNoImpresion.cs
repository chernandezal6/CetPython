using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SuirPlusEF.Models
{
    [Table("SRE_MOTIVO_NO_IMPRESION_T")]
    public class MotivoNoImpresion
    {
        [Key, Column("ID_MOTIVO_NO_IMPRESION")]
        public string IdMotivoNoImpresion { get; set; }

        [Column("MOTIVO_NO_IMPRESION_DES")]
        public string Descripcion { get; set; }

        [Column("ULT_FECHA_ACT")]
        public DateTime? UltimaFechaActualiza { get; set; }

        [ForeignKey("Usuario") ,Column("ULT_USUARIO_ACT")]
        public String UltimoUsuarioActualiza { get; set; }

        public virtual Usuario Usuario { get; set; }
    }
}
