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
    [Table("NSS_DET_EVALUACION_VISUAL_T")]
    public class DetalleEvaluacionVisual : BaseModel
    {
        public DetalleEvaluacionVisual()
        {
            this.myOracleSequenceName = "NSS_DET_EV_SEQ";
        }

        public override int AssignId(int id)
        {
            this.IdDetalleEvaluacionVisual = id;
            return id;
        }
        [DatabaseGenerated(DatabaseGeneratedOption.None)]

        [Key, Column("ID_DET_EVALUACION")]
        public Int32 IdDetalleEvaluacionVisual { get; set; }
        
        [ForeignKey("EvaluacionVisual"), Column("ID_EVALUACION")]
        public Int32 IdEvaluacionVisual { get; set; }

        [ForeignKey("ciudadano"),Column("ID_NSS")]
        public Int32? IdNSS { get; set; }

        [Column("ID_EXPEDIENTE")]
        public Int32 IdExpediente { get; set; }

        [Column("ID_ACCION_EV")]
        public Int32? IdAccionEvaluacion { get; set; }

        //Colección para guardar los multiples casos de evaluación visual que apuntan a un mismo NSS.
        [ForeignKey("IdEvaluacionVisual")]
        public virtual EvaluacionVisual EvaluacionVisual { get; set; }
        public virtual Ciudadano ciudadano { get; set; }
    }
}
