using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SuirPlusEF.Models
{
    [Table("NSS_ACCION_EVALUACION_VISUAL_T")]
    public class AccionEvaluacionVisual
    {
        [Key, Column("ID_ACCION_EV")]
        public Int32 IdAccion { get; set; }

        [Column("DESCRIPCION")]
        public string Descripcion { get; set; }

    }
}
