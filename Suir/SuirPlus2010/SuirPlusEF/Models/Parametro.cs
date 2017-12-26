using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SuirPlusEF.Models
{
    [Table("SFC_PARAMETROS_T")]
    public class Parametro
    {
        [Key, Column("ID_PARAMETRO")]
        public Int32 IdParametro { get; set; }

        [Column("PARAMETRO_DES")]
        public string Descripcion { get; set; }

        [Column("TIPO_PARAMETRO")]
        public string TipoParametro { get; set; }

        [Column("ULT_FECHA_ACT")]
        public DateTime? UltimaFechaActualiza { get; set; }

        [ForeignKey("Usuario"), Column("ULT_USUARIO_ACT")]
        public string UltimoUsuarioActualiza { get; set; }

        [Column("TIPO_CALCULO")]
        public string TipoCalculo { get; set; }

        [ForeignKey("Renglon"), Column("ID_APLICACION", Order = 0)]
        public string IdAplicacion { get; set; }        

        [ForeignKey("Renglon") ,Column("ID_RENGLON", Order = 1)]
        public string IdRenglon { get; set; }

        [Column("ID_TIPO_NOMINA")]
        public string TipoNomina { get; set; }

        [Column("ID_NAME")]
        public string Nombre { get; set; }

        public virtual Usuario Usuario { get; set; }
        public virtual Aplicacion Aplicaciones { get; set; }
        [ForeignKey("IdAplicacion,IdRenglon")]
        public virtual Renglon Renglon { get; set; }
    }
}
