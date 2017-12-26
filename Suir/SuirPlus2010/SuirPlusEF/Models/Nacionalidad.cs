using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace SuirPlusEF.Models
{
    [Table("SRE_NACIONALIDAD_T")]
    public class Nacionalidad
    {
        [Key, Column("ID_NACIONALIDAD")]
        public string IdNacionalidad { get; set; }

        [Column("NACIONALIDAD_DES")]
        public string Descripcion { get; set; }

        [Column("PAIS_NACIONALIDAD")]
        public string Pais{ get; set; }

        [ForeignKey("Usuario") ,Column("ULT_USUARIO_ACT")]
        public string UltimoUsuarioActualiza { get; set; }

        [Column("ULT_FECHA_ACT")]
        public DateTime ? UltimaFechaActualizacion { get; set; }

        public virtual Usuario Usuario { get; set; }
    }
}