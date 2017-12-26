using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SuirPlusEF.Models
{
    [Table("SRE_PROVINCIAS_T")]
    public class Provincia
    {
        [Key, Column("ID_PROVINCIA")]
        public string IdProvincia { get; set; }

        [Column("PROVINCIA_DES")]
        public string Descripcion { get; set; }

        [ForeignKey("Usuario") ,Column("ULT_USUARIO_ACT")]
        public string UltimoUsuarioActualiza { get; set; }

        [Column("ULT_FECHA_ACT")]
        public DateTime? UltimaFechaActualizacion { get; set; }

        public virtual Usuario Usuario { get; set; }
    }
}
