using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SuirPlusEF.Models
{
    [Table("SRE_INHABILIDAD_JCE_T")]
    public class InhabilidadJCE
    {
        [Key, Column("ID_CAUSA_INHABILIDAD", Order = 0)]
        public Int32 IdCausaInhabilidad{ get; set; }

        [Key, Column("TIPO_CAUSA", Order = 1)]
        public string Tipo { get; set; }

        [Column("CANCELACION_DES")]
        public string Descripcion { get; set; }

        [Column("ULT_FECHA_ACT")]
        public DateTime ? UltimaFechaActualizacion { get; set; }

        [ForeignKey("Usuario"),Column("ULT_USUARIO_ACT")]
        public string UltimoUsuarioActualiza { get; set; }

        [Column("CANCELADA_SUIR")]
        public string CanceladaSuir { get; set; }

        public virtual Usuario Usuario { get; set; }
    }
}
