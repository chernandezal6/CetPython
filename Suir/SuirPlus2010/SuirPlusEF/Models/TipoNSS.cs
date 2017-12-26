using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace SuirPlusEF.Models
{
    [Table("SRE_TIPO_NSS_T")]
    public class TipoNSS
    {
        [Key, Column("ID_TIPO_NSS")]
        public Int32 IdTipoNSS { get; set; }

        [Column("DESCRIPCION")]
        public string Descripcion { get; set; }

        [Column("COTIZA_SDSS")]
        public string CotizaSDSS { get; set; }

        [Column("COTIZA_DGII")]
        public string CotizaDGII { get; set; }

        [Column("COTIZA_INFOTEP")]
        public string CotizaINFOTEP { get; set; }
    }
}
