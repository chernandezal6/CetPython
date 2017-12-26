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
    [Table("NSS_SOLICITUDES_T")]
    public class SolicitudNSS : BaseModel
    {
        public SolicitudNSS()
        {
            this.myOracleSequenceName = "NSS_SOLICITUDES_T_SEQ";
        }

        public override int AssignId(int id)
        {
            this.IdSolicitud = id;
            return id;
        }

        [DatabaseGenerated(DatabaseGeneratedOption.None)]
        [Key, Column("ID_SOLICITUD")]
        public Int32 IdSolicitud { get; set; }

        [ForeignKey("tipoSolicitudNSS"), Column("ID_TIPO")]
        public Int32 IdTipo { get; set; }

        [ForeignKey("Empleador"), Column("ID_REGISTRO_PATRONAL")]
        public Int32? IdRegPatronal { get; set; }

        [ForeignKey("usuarioSol"), Column("USUARIO_SOLICITA")]
        public string UsuarioSolicita { get; set; }

        [Column("FECHA_SOLICITUD")]
        public DateTime FechaSolicitud { get; set; }

        [Column("ULT_FECHA_ACT")]
        public DateTime? UltimaFechaActualizacion { get; set; }

        [ForeignKey("usuario"),Column("ULT_USUARIO_ACT")]
        public string UltimoUsuarioActualiza { get; set; }

        public virtual TipoSolicitudNSS tipoSolicitudNSS { get; set; } 
        public virtual Empresa Empleador { get; set; }      
        public virtual Usuario usuarioSol { get; set; }
        public virtual Usuario usuario { get; set; }       
    }
}
