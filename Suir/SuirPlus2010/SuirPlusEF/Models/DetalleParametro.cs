using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System;

namespace SuirPlusEF.Models
{
    [Table("SFC_DET_PARAMETRO_T")]
    public class DetalleParametro
    {
        [Key, ForeignKey("Parametro"),Column("ID_PARAMETRO")]
        public Int32 IdParametro { get; set; }

        [Column("FECHA_INI")]
        public DateTime FechaIni { get; set; }

        [Column("FECHA_FIN")]
        public DateTime? FechaFin { get; set; }

        [Column("VALOR_FECHA")]
        public DateTime? ValorFecha { get; set; }

        [Column("VALOR_NUMERICO")]
        public decimal ValorNumerico { get; set; }

        [Column("VALOR_TEXTO")]
        public string ValorTexto { get; set; }

        [Column("AUTORIZADO")]
        public string Autorizado { get; set; }

        [Column("ULT_FECHA_ACT")]
        public DateTime? UltimaFechaActualizacion { get; set; }

        [ForeignKey("Usuario"), Column("ULT_USUARIO_ACT")]
        public string UltimoUsuarioActualizo { get; set; }

        [Column("MOTIVO_PRORROGA")]
        public string MotivoProrroga { get; set; }

        public virtual Parametro Parametro { get; set; }
        public virtual Usuario Usuario { get; set; }
    }
}