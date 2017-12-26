using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SuirPlusEF.Models
{
    [Table("SFC_DET_LIQUIDACION_ISR_T")]
    public class DetalleLiquidacionISR
    {
        [Key, ForeignKey("LiquidacionISR"), Column("ID_REFERENCIA_ISR")]
        public string IdReferenciaISR { get; set; }

        [ForeignKey("IdNss"), Column("ID_NSS")]
        public Int32 IdNSS { get; set; }

        [Column("SECUENCIA_LIQUIDACION")]
        public Int32 SecuenciaLiquidacion { get; set; }

        [ForeignKey("AgenteRetencion"), Column("AGENTE_RETENCION_ISR")]
        public Int32 ? AgenteRetencionISR { get; set; }

        [Column("OTROS_INGRESOS_ISR")]
        public decimal OtrosIngresosISR { get; set; }

        [Column("PERIODO_APLICACION")]
        public Int32 ? PeriodoAplicacion { get; set; }

        [Column("REMUNERACION_ISR_OTROS")]
        public decimal RemuneracionIsrOtros { get; set; }

        [Column("SALARIO_ISR")]
        public decimal SalarioISR { get; set; }

        [Column("SALDO_FAVOR_DEL_PERIODO")]
        public decimal SaldoFavorPeriodo { get; set; }

        [Column("SALDO_COMPENSADO")]
        public decimal SaldoCompensado { get; set; }

        [Column("SALDO_POR_COMPENSAR")]
        public decimal SaldoPorCompensar { get; set; }

        [Column("ULT_FECHA_ACT")]
        public DateTime ? UltimaFechaActualizacion { get; set; }

        [ForeignKey("Usuario"),Column("ULT_USUARIO_ACT")]
        public string UltimoUsuarioActualizo { get; set; }

        [Column("ISR")]
        public decimal ? ISR { get; set; }

        [Column("RETENCION_SS")]
        public decimal ? RetencionSS { get; set; }

        [Column("INGRESOS_EXENTOS_ISR")]
        public decimal ? IngresosExentosISR { get; set; }

        [Column("TIPO_NOMINA")]
        public string TipoNomina { get; set; }

        public virtual Ciudadano IdNss { get; set; }
        public virtual LiquidacionISR LiquidacionISR { get; set; }
        public virtual Empresa AgenteRetencion { get; set; }
        public virtual Usuario Usuario { get; set; }

    }
}
