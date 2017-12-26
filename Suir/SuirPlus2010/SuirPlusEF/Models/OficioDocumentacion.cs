using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SuirPlusEF.Models
{
    [Table("OFC_DOCUMENTACION_T")]
    public class OficioDocumentacion
    {
        [Key, Column("ID_DOC")]
        public Int32 IdDocumento { get; set; }

        [ForeignKey("Oficio") ,Column("ID_OFICIO")]
        public Int32? IdOficio { get; set; }

        [Column("DOCUMENTO")]
        public object Documento { get; set; }

        [Column("DOCUMENTO_TIPO")]
        public string Tipo { get; set; }

        [Column("DOCUMENTO_NOMBRE")]
        public string Nombre { get; set; }

        [Column("ULT_FECHA_ACT")]
        public DateTime? UltimaFechaActualiza { get; set; }

        [ForeignKey("Usuario") ,Column("ULT_USUARIO_ACT")]
        public string UltimoUsuarioActualiza { get; set; }

        public virtual Usuario Usuario { get; set; }
        public virtual Oficio Oficio { get; set; }
    }
}
