using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SuirPlusEF.Models
{
    [Table("SRE_ACTIVIDAD_ECONOMICA_T")]
    public class ActividadEconomica
    {
        [Key, Column("ID_ACTIVIDAD_ECO")]
        public string IdActividadEconomica { get; set; }

        [Column("ACTIVIDAD_ECO_DES")]
        public string Descripcion { get; set; }

        [Column("SALARIO_MINIMO")]
        public decimal SalarioMinimo { get; set; }
    }
}
