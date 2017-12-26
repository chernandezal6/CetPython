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
    [Table("ARS_PARENTESCOS_T")]
    public class Parentesco
    {
        [DatabaseGenerated(DatabaseGeneratedOption.None)]
        [Key, Column("ID_PARENTESCO")]
        public string IdParentesco { get; set; }

        [Column("PARENTESCO_DESC")]
        public string DESCRIPCION { get; set; }

        [Column("SEXO")]
        public string Sexo { get; set; }
    }
}
