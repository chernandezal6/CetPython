using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SuirPlusEF.Models
{
    [Table("SRE_TIPO_MOVIMIENTO_T")]
    public class TipoMovimiento
    {
        [Key, Column("ID_TIPO_MOVIMIENTO")]
        public string IdTipoMovimiento { get; set; }

        [ForeignKey("Proceso"), Column("ID_PROCESO")]
        public string IdProceso { get; set; }

        [Column("TIPO_MOVIMIENTO_DES")]
        public string Descripcion { get; set; }

        [Column("ULT_FECHA_ACT")]
        public DateTime? UltimaFechaActualiza { get; set; }

        [ForeignKey("Usuario"), Column("ULT_USUARIO_ACT")]
        public string UltimoUsuarioActualiza { get; set; }

        [Column("ID_TIPO_FACTURA")]
        public string TipoFactura { get; set; }

        [Column("CANCELA_FACTURA_SS")]
        public string CancelaFacturaSS { get; set; }

        [Column("CANCELA_LIQUIDACION_ISR")]
        public string CancelaLiquidacionIsr { get; set; }

        [Column("GENERA_FACTURA_SS")]
        public string GeneraFacturaSS { get; set; }

        [Column("GENERA_LIQUIDACION_ISR")]
        public string GeneraLiquidacionIsr { get; set; }

        [Column("FUENTE_LECTURA")]
        public string Origen { get; set; }

        [Column("GENERA_RECARGO_SS")]
        public string GeneraRecargoSS { get; set; }

        [Column("GENERA_RECARGO_ISR")]
        public string GeneraRecargoIsr { get; set; }

        [Column("CANCELA_LIQUIDACION_INFOTEP")]
        public string CancelaLiquidacionInfotep { get; set; }

        [Column("GENERA_FACTURA_INFOTEP")]
        public string GeneraFacturaInfotep { get; set; }

        [Column("GENERA_RECARGO_INFOTEP")]
        public string GeneraRecargoInfotep { get; set; }


        public virtual Usuario Usuario { get; set; }
        public virtual Proceso Proceso { get; set; }

        
    }
}
