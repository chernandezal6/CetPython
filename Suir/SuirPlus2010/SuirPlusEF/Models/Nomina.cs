using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace SuirPlusEF.Models
{
    [Table("SRE_NOMINAS_T")]
    public class Nomina         
    {
        [Key,Column("ID_REGISTRO_PATRONAL", Order = 0)]
        public Int32 IdRegistroPatronal { get; set; }

        [Key, Column("ID_NOMINA", Order = 1)]
        public Int32 IdNomina { get; set; }

        [Column("NOMINA_DES")]
        public string Descripcion { get; set; }

        [Column("STATUS")]
        public string Estatus { get; set; }

        [Column("FECHA_REGISTRO")]
        public DateTime? FechaRegistro { get; set; }

        [Column("TIPO_NOMINA")]
        public string Tipo { get; set; }

        [Column("ULT_FECHA_ACT")]
        public DateTime? UltimaFechaActualiza { get; set; }

        [ForeignKey("Usuario") ,Column("ULT_USUARIO_ACT")]
        public string UltimoUsuarioActualiza { get; set; }

        public virtual Usuario Usuario { get; set; }
        public virtual Empresa RegistroPatronal { get; set; }
    }
}
