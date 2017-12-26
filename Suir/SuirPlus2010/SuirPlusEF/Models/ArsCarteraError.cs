using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SuirPlusEF.Models
{
    [Table("ARS_CARTERA_ERRORES_T")]
    public class ArsCarteraError
    {
        [Key, Column("ID_ERROR")]
        public Int32 IdError { get; set; }

        [Column("ERROR_DES")]
        public string Descripcion { get; set; }

    }
}
