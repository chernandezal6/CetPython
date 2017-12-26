using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace SuirPlusEF.Models
{
    [Table("SRE_MUNICIPIO_T")]
    public class Municipio
    {
        [Key, Column("ID_MUNICIPIO")]
        public string IdMunicipio { get; set; }

        [Column("MUNICIPIO_DES")]
        public string Descripcion { get; set; }

        [ForeignKey("Provincia"), Column("ID_PROVINCIA")]
        public string IdProvincia { get; set; }

        [ForeignKey("Usuario"), Column("ULT_USUARIO_ACT")]
        public string UltimoUsuarioActualiza { get; set; }

        [Column("ULT_FECHA_ACT")]
        public DateTime ? UltimaFechaActualizacion { get; set; }

        public virtual Provincia Provincia { get; set; }
        public virtual Usuario Usuario { get; set; }
    }
}
