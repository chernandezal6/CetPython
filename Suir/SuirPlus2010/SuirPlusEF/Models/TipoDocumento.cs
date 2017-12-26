using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace SuirPlusEF.Models
{
    [Table("SRE_TIPO_DOCUMENTOS_T")]
    public class TipoDocumento
    {
        [Key, Column("ID_TIPO_DOCUMENTO")]
        public string IdTipoDocumento { get; set; }

        [Column("USO_CIUDADANO")]
        public string SolicitudExtranjero { get; set; }

        [Column("DESCRIPCION")]
        public string Descripcion { get; set; }        

        [ForeignKey("Entidad"), Column("ID_ENTIDAD")]
        public Int32 IdEntidad { get; set; }

        [Column("MASCARA")]
        public string Mascara { get; set; }

        [Column("VISIBLE_EMPLEADOR")]
        public string VisibleEmpleador { get; set; }

        public virtual Entidad Entidad { get; set; }
    }

}
