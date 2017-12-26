using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SuirPlusEF.Models
{
     [Table("ARS_CATALOGO_T")]
    public class ArsCatalogo
    {
         [Key, Column("ID_ARS")]
         public Int32 IdArs { get; set; }
         
         [Column("ARS_DES")]
         public string Descripcion { get; set; }

         [Column("RNC")]
         public string Rnc { get; set; }

         [Column("STATUS")]
         public string Estatus { get; set; }

         [Column("ULT_FECHA_ACT")]
         public DateTime? UltimaFechaActualizacion { get; set; }

         [Column("MOTIVO_BAJA")]
         public string MotivoBaja { get; set; }

         [Column("FECHA_BAJA")]
         public DateTime? FechaBaja { get; set; }

         [Column("ARS_NUEVA")]
         public Int32? ArsNueva { get; set; }
         
         [Column("FORMULARIO_PENSIONADOS")]
         public Int32? Formulario{ get; set; }

         [Column("LISTA_PENDIENTE_AFILIACION")]
         public string ListaPendienteAfiliacion { get; set; }

         [Column("EN_EVALUACION_VISUAL")]
         public string EvaluacionVisual { get; set; }



    }
}
