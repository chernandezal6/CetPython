using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SuirPlusEF.Framework;

namespace SuirPlusEF.Models
{
    [Table("SEG_ROLES_T")]
    public class Rol : BaseModel
    {
        public Rol() {            
            this.myOracleSequenceName = "SEG_ROLES_SEQ";
        }

        public override int AssignId(int id)
        {
            this.IdRole = id;
            return id;
        }

         [DatabaseGenerated(DatabaseGeneratedOption.None)]
         [Key, Column("ID_ROLE")]
         public Int32 IdRole { get; set; }

         [Column("ROLES_DES")]
         public string Descripcion { get; set; }

         [Column("STATUS")]
         public string Estatus { get; set; }

         [Column("ULT_USUARIO_ACT")]
         public string UltimoUsuarioActualizo { get; set; }

         [Column("ULT_FECHA_ACT")]
         public DateTime ? UltimaFechaActualizacion { get; set; }

         [Column("TIPO_ROLE")]
         public string TipoRole { get; set; }

    }
    
}
