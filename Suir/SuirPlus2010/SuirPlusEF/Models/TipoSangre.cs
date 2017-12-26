using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace SuirPlusEF.Models
{
    [Table("SRE_TIPO_SANGRE_T")]
    public class TipoSangre
    {
        [Key, Column("ID_TIPO_SANGRE")]
        public string IdTipoSangre { get; set; }

        [Column("TIPO_SANGRE_DES")]
        public string Descripcion { get; set; }

        [ForeignKey("Usuario") ,Column("ULT_USUARIO_ACT")]
        public string UltimoUsuarioActualiza { get; set; }

        [Column("ULT_FECHA_ACT")]
        public DateTime ? UltimaFechaActualizacion { get; set; }

        public virtual Usuario Usuario{ get; set; }
    }
}
