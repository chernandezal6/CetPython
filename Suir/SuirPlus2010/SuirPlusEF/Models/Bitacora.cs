using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SuirPlusEF.Models
{
    [Table("SFC_BITACORA_T")]
    public class Bitacora
    {
        [Key, Column("ID_BITACORA")]
        public Int32 IdBitacora { get; set; }

        [ForeignKey("Proceso"), Column("ID_PROCESO")]
        public string IdProceso { get; set; }

        [Column("FECHA_INICIO")]
        public DateTime FechaInicio { get; set; }

        [Column("FECHA_FIN")]
        public DateTime ? FechaFin { get; set; }

        [Column("MENSAGE")]
        public string Mensaje { get; set; }

        [Column("STATUS")]
        public string Estatus { get; set; }

        [ForeignKey("Error"), Column("ID_ERROR")]
        public string IdError { get; set; }

        [Column("SEQ_NUMBER")]
        public Int32 ? Secuencia{ get; set; }

        [Column("ULT_FECHA_ACT")]
        public DateTime ? UltimaFechaActualizacion { get; set; }

        [ForeignKey("Usuario"),Column("ULT_USUARIO_ACT")]
        public string UltimoUsuarioActualizo { get; set; }

        [Column("PERIODO")]
        public Int32 ? Periodo { get; set; }

        [Column("SEQ_PERIODO")]
        public Int32 ? SecuenciaPeriodo { get; set; }

        public virtual Proceso Proceso { get; set; }
        public virtual Error Error { get; set; }
        public virtual Usuario Usuario { get; set; }
    }
}
