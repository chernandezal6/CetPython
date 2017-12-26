using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SuirPlusEF.Models
{
    [Table("ARS_CARGA_T")]
    public class ArsCarga
    {
        [Key, Column("ID_CARGA")]
        public Int32 IdCarga { get; set; }

        [Column("FECHA")]
        public DateTime? Fecha { get; set; }

        [Column("STATUS")]
        public string Estatus { get; set; }

        [Column("VISTA")]
        public string Vista { get; set; }
        
        [Column("REGISTROS_OK")]
        public Int32? RegistrosOk { get; set; }

        [Column("REGISTROS_ERROR")]
        public Int32? RegistrosError { get; set; }

    }
}
