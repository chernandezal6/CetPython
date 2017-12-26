using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SuirPlusEF.Models
{
     [Table("SFC_PROCESOS_T")]
    public class Proceso
    {
         [Key, Column("ID_PROCESO")]
         public string IdProceso { get; set; }

         [Column("PROCESO_DES")]
         public string Descripcion { get; set; }

         [Column("PROCESO_EJECUTAR")]
         public string ProcesoEjecutar { get; set; }
        
         [Column("ULT_FECHA_ACT")]
         public DateTime ? UltimaFechaActualizacion { get; set; }

         [Column("ULT_USUARIO_ACT")]
         public string UltimoUsuarioActualizo { get; set; }

         [Column("LISTA_OK")]
         public string ListaOk { get; set; }

         [Column("LISTA_ERROR")]
         public string ListaError { get; set; }

         [Column("AUTOMATIZADO")]
         public string Automatizado { get; set; }

         [Column("PROCESO_VALIDAR")]
         public string ProcesoValidar { get; set; }

         [Column("IS_BITACORA")]
         public string IsBitacora { get; set; }

         [Column("LANZADOR")]
         public string Lanzador { get; set; }


         
    }
}
