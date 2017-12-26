using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace SuirPlusEF.Models
{
    [Table("NSS_TIPO_SOLICITUDES_T")]
    public class TipoSolicitudNSS
    {
        [Key, Column("ID_TIPO")]
        public Int32 IdTipo { get; set; }

        [Column("CODIGO")]
        public string Codigo { get; set; }

        [Column("DESCRIPCION")]
        public string Descripcion { get; set; }

    }
}
