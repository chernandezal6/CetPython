using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SuirPlusEF.Models
{
    [Table("SRE_SECTOR_ECONOMICO_T")]
    public class SectorEconomico
    {
        [Key, Column("ID_SECTOR_ECONOMICO")]
        public Int32 IdSectorEconomico { get; set; }

        [Column("SECTOR_ECONOMICO_DES")]
        public string Descripcion { get; set; }

        [Column("ULT_FECHA_ACT")]
        public DateTime? UltimaFechaActualiza { get; set; }

        [ForeignKey("Usuario") ,Column("ULT_USUARIO_ACT")]
        public string UltimoUsuarioActualiza { get; set; }

        public virtual Usuario Usuario { get; set; }
    }
}
