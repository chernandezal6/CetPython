using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SuirPlusEF.Models
{
    [Table("DGI_ADMINISTRACION_LOCAL_T")]
    public class AdministracionLocal
    {
        [Key, Column("ID_ADMINISTRACION_LOCAL")]
        public string IdAdministracionLocal { get; set; }

        [Column("ADMINISTRACION_LOCAL_DES")]
        public string Descripcion { get; set; }

        [Column("ULT_FECHA_ACT")]
        public DateTime? UltimaFechaActualiza { get; set; }

        [ForeignKey("Usuario"), Column("ULT_USUARIO_ACT")]
        public string UltimoUsuarioActualiza { get; set; }

        public virtual Usuario Usuario { get; set; }
    }
}
