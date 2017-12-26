using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SuirPlusEF.Models
{
    [Table("OFC_DET_OFICIOS_T")]
    public class DetalleOficios
    {
        [Key, ForeignKey("Oficio"), Column("ID_OFICIO", Order =0)]
        public Int32 IdOficio { get; set; }

        [Key, ForeignKey("Factura"), Column("ID_REFERENCIA", Order =1)]
        public string IdReferencia { get; set; }

        [Column("MONTO_ORIGINAL")]
        public decimal? MontoOriginal { get; set; }

        [Column("RECARGOS")]
        public decimal? Recargos { get; set; }

        [Column("NSS")]
        public Int32? Nss { get; set; }

        [Column("PERIODO")]
        public Int32? Periodo { get; set; } 

        public virtual Oficio Oficio { get; set; }
        public virtual Factura Factura { get; set; }
    }
}
