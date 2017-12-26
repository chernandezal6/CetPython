using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using SuirPlusEF.Framework;

namespace SuirPlusEF.Models
{
    [Table("NSS_SOLICITUD_RESPUESTA_T")]
    public class SolicitudRespuesta
    {
        [Key, Column("ID_RESPUESTA")]
        public string IdRespuesta { get; set; }

        [Column("DESCRIPCION")]
        public string Descripcion { get; set; }
    }
}
