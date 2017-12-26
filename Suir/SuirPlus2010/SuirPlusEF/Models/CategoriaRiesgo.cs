using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace SuirPlusEF.Models
{
    [Table("SRE_CATEGORIA_RIESGO_T")]
    public class CategoriaRiesgo
    {
        [Key, Column("ID_RIESGO")]
        public string IdRiesgo { get; set; }

        [Column("RIESGO_DES")]
        public string Descripcion { get; set; }

        [Column("FACTOR_RIESGO")]
        public decimal? FactorRiesgo { get; set; }

        [Column("ULT_FECHA_ACT")]
        public DateTime? UltimaFechaActualiza { get; set; }

        [ForeignKey("Usuario"),Column("ULT_USUARIO_ACT")]
        public string UltimoUsuarioActualiza { get; set; }

        [ForeignKey("Parametro"),Column("ID_PARAMETRO")]
        public Int32? IdParametro { get; set; }

        public virtual Usuario Usuario { get; set; }
        public virtual Parametro Parametro { get; set; }
    }
}
