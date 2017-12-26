using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SuirPlusEF.Models
{
    [Table("OFC_MOTIVOS_T")]
    public  class Motivo
    {
        [Key, ForeignKey("Accion"), Column("ID_ACCION", Order = 0)]
        public Int32 IdAccion { get; set; }

        [Key,Column("ID_MOTIVO", Order = 1)]
        public Int32 IdMotivo { get; set; }

        [Column("TEXTO_MOTIVO")]
        public string Texto { get; set; }

        public virtual Accion Accion { get; set; }
    }
}
