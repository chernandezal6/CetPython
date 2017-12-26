using SuirPlusEF.Framework;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SuirPlusEF.Models
{
    [Table("NSS_EVALUACION_VISUAL_T")]
    public class EvaluacionVisual: BaseModel
    {
        public EvaluacionVisual() {
            this.myOracleSequenceName = "NSS_EVALUACION_VISUAL_T_SEQ";
        }

        public override int AssignId(int id)
        {
            this.IdEvaluacionVisual = id;
            return id;
        }
        [DatabaseGenerated(DatabaseGeneratedOption.None)]
        [Key, Column("ID_EVALUACION")]
        public Int32 IdEvaluacionVisual { get; set; }
        
        [ForeignKey("detalleSolicitudes"), Column("ID_REGISTRO")]
        public Int32 ? IdRegistro { get; set; }

        [Column("FECHA_REGISTRO")]
        public DateTime FechaRegistro { get; set; }

        [Column("FECHA_RESPUESTA")]
        public DateTime FechaRespuesta { get; set; }

        [Column("ESTATUS")]
        public string Estatus { get; set; }

        [ForeignKey("usuarioProcesa"), Column("USUARIO_PROCESA")]
        public string UsuarioProcesa { get; set; }

        [Column("ULT_FECHA_ACT")]
        public DateTime? UltimaFechaActualizacion { get; set; }

        [ForeignKey("usuario"),Column("ULT_USUARIO_ACT")]
        public string UltimoUsuarioActualiza { get; set; }

        public virtual DetalleSolicitudes detalleSolicitudes { get; set; }
        public virtual Usuario usuario { get; set; }
        public virtual Usuario usuarioProcesa { get; set; }

    }
}
