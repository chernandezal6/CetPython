using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SuirPlusEF.Models
{
     [Table("SFC_LIQUIDACION_INFOTEP_T")]
    public class LiquidacionInfotep
    {
        [Key, Column("ID_REFERENCIA_INFOTEP")]
        public string IdReferenciaInfotep { get; set; }

        [Column("ID_ENTIDAD_RECAUDADORA")]
        public Int32 ? IdEntidadRecaudadora { get; set; }

        [Column("ID_TIPO_FACTURA")]
        public string IdTipoFactura { get; set; }

        [Column("ID_REGISTRO_PATRONAL")]
        public Int32 IdRegistroPatronal { get; set; }

        [Column("NO_AUTORIZACION")]
        public Int32 ? NoAutorizacion { get; set; }

        [Column("FECHA_EMISION")]
        public DateTime FechaEmision { get; set; }

        [Column("FECHA_LIMITE_PAGO")]
        public DateTime FechaLimitePago { get; set; }

        [Column("PERIODO_LIQUIDACION")]
        public Int32 PeriodoLiquidacion { get; set; }

        [Column("STATUS")]
        public string Estatus { get; set; }

        [Column("FECHA_AUTORIZACION")]
        public DateTime ? FechaAutorizacion { get; set; }

        [Column("FECHA_DESAUTORIZACION")]
        public DateTime ? FechaDesautorizacion { get; set; }

        [Column("TOTAL_TRABAJADORES")]
        public Int32 TotalTrabajadores { get; set; }

        [Column("TOTAL_SALARIO_BONIFICACION")]
        public decimal TotalSalarioBonificacion { get; set; }

        [Column("TOTAL_PAGO_INFOTEP")]
        public decimal TotalPagoInfotep { get; set; }

        [Column("ID_USUARIO_AUTORIZA")]
        public string IdUsuarioAutoriza { get; set; }

        [Column("ID_USUARIO_DESAUTORIZA")]
        public string IdUsuarioDesautoriza { get; set; }

        [Column("FECHA_PAGO")]
        public DateTime ? FechaPago { get; set; }

        [Column("FECHA_CANCELA")]
        public DateTime ? FechaCancela { get; set; }

        [Column("FECHA_REPORTE_PAGO")]
        public DateTime ? FechaReportePago { get; set; }

        [Column("TIPO_REPORTE_BANCO")]
        public string TipoReporteBanco { get; set; }

        [Column("ORIGEN")]
        public string Origen { get; set; }

        [Column("FECHA_EFECTIVA_PAGO")]
        public DateTime ? FechaEfectivaPago { get; set; }

        [Column("FECHA_1RA_AUTORIZACION")]
        public DateTime ? FechaPrimeraAutorizacion { get; set; }

        [Column("ULT_FECHA_ACT")]
        public DateTime UltimaFechaActualizacion { get; set; }

        [Column("ULT_USUARIO_ACT")]
        public string UltimoUsuarioActualizo { get; set; }
    }
}
