using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SuirPlusEF.Models
{
     [Table("SFC_DET_LIQUIDACION_INFOTEP_T")]
    public class DetalleLiquidacionInfotep
    {
        [Key, ForeignKey("Liquidacion"), Column("ID_REFERENCIA_INFOTEP", Order = 0)]
        public string IdReferenciaInfotep { get; set; }

        [Key,ForeignKey("IdNss"), Column ("ID_NSS", Order = 1)]
        public Int32 IdNSS { get; set; }

        [Key, Column("SECUENCIA_LIQUIDACION", Order = 2)]
        public Int32 SecuenciaLiquidacion { get; set; }

        [Column("PERIODO_APLICACION")]
        public Int32 ? PeriodoAplicacion { get; set; }

        [Column("SALARIO")]
        public decimal ? Salario { get; set; }

        [Column("PAGO_INFOTEP")]
        public decimal ? PagoInfotep { get; set; }

        [Column("TIPO_NOMINA")]
        public string TipoNomina { get; set; }

        public virtual Ciudadano IdNss { get; set; }
        public virtual LiquidacionInfotep Liquidacion { get; set; }
    }
}
