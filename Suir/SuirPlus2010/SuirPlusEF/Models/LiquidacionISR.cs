using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SuirPlusEF.Models
{
     [Table("SFC_LIQUIDACION_ISR_T")]
    public class LiquidacionISR
    {
        [Key, Column("ID_REFERENCIA_ISR")]
        public string IdReferenciaISR { get; set; }

        [Column("ID_ENTIDAD_RECAUDADORA")]
        public Int32 ? IdEntidadRecaudadora { get; set; }

        [Column("ID_TIPO_FACTURA")]
        public string IdTipoFactura { get; set; }

        [Column("ID_REGISTRO_PATRONAL")]
        public Int32 ? IdRegistroPatronal { get; set; }

        [Column("ID_NOMINA")]
        public Int32 ? IdNomina { get; set; }

        [Column("NO_AUTORIZACION")]
        public Int32 ? NoAutorizacion { get; set; }

        [Column("FECHA_EMISION")]
        public DateTime ? FechaEmision { get; set; }

        [Column("FECHA_LIMITE_PAGO")]
        public DateTime ? FechaLimitePago { get; set; }

        [Column("PERIODO_LIQUIDACION")]
        public Int32 ? PeriodoLiquidacion { get; set; }

        [Column("STATUS")]
        public string Estatus { get; set; }

        [Column("FECHA_AUTORIZACION")]
        public DateTime ? FechaAutorizacion { get; set; }

        [Column("FECHA_DESAUTORIZACION")]
        public DateTime ? FechaDesautorizacion { get; set; }

        [Column("TOTAL_TRABAJADORES")]
        public Int32 ? TotalTrabajadores { get; set; }

        [Column("TOTAL_TRABAJADORES_RETENCION")]
        public Int32 ? TotalTrabajadoresRetencion { get; set; }

        [Column("TOTAL_SALARIO_ISR")]
        public decimal TotalSalarioISR { get; set; }

        [Column("TOTAL_REMUNERACION_OTROS")]
        public decimal TotalRemuneracionOtros { get; set; }

        [Column("TOTAL_OTRAS_REMUNERACIONES")]
        public decimal TotalOtrasRemuneracioens { get; set; }

        [Column("TOTAL_ISR")]
        public decimal TotalISR { get; set; }

        [Column("TOTAL_SALDO_COMPENSADO")]
        public decimal TotalSaldoCompensado { get; set; }

        [Column("TOTAL_POR_COMPENSAR")]
        public decimal TotalPorCompensar { get; set; }

        [Column("TOTAL_SALDO_FAVOR")]
        public decimal TotalSaldoFavor { get; set; }

        [Column("TOTAL_RECARGO")]
        public decimal TotalRecargo { get; set; }

        [Column("TOTAL_INTERES")]
        public decimal TotalInteres { get; set; }

        [Column("ID_USUARIO_AUTORIZA")]
        public string IdUsuarioAutoriza { get; set; }

        [Column("ID_USUARIO_DESAUTORIZA")]
        public string IdUsuarioDesautoriza { get; set; }

        [Column("ULT_FECHA_ACT")]
        public DateTime ? UltimaFechaActualizacion { get; set; }

        [Column("ULT_USUARIO_ACT")]
        public string UltimoUsuarioActualizo { get; set; }

        [Column("TOTAL_RETENCION_SS")]
        public decimal TotalRetencionSS { get; set; }

        [Column("TOTAL_INGRESOS_EXENTOS_ISR")]
        public decimal TotalIngresosExentosISR { get; set; }

        [Column("FECHA_PAGO")]
        public DateTime ? FechaPago { get; set; }

        [Column("TOTAL_SUJETO_A_RETENCION_ISR")]
        public decimal TotalSujetoRetencionISR { get; set; }

        [Column("FECHA_CANCELA")]
        public DateTime ? FechaCancela { get; set; }

        [Column("FECHA_REPORTE_PAGO")]
        public DateTime ? FechaReportePago { get; set; }

        [Column("TOTAL_CREDITO_APLICADO")]
        public decimal TotalCreditoAplicado { get; set; }

        [Column("TIPO_REPORTE_BANCO")]
        public string TipoReporteBanco { get; set; }

        [Column("ORIGEN")]
        public string Origen { get; set; }

        [Column("FECHA_EFECTIVA_PAGO")]
        public DateTime ? FechaEfectivaPago { get; set; }
    }
}
