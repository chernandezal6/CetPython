using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SuirPlusEF.Models
{
    [Table("OFC_ACCIONES_T")]
    public class Accion
    {
        [Key, Column("ID_ACCION")]
        public Int32 IdAccion { get; set; }

        [Column("ACCION_DES")]
        public string Descripcion { get; set; }

        [Column("TEXTO_ACCION")]
        public string Texto { get; set; }

        [Column("SELECCIONA_NOTIFICACIONES")]
        public string Notificaciones { get; set; }

        [Column("STATUS")]
        public string Estatus { get; set; }
    }
}
