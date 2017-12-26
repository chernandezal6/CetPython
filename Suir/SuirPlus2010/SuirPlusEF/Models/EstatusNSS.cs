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
    [Table("NSS_ESTATUS_T")]
    public class EstatusNSS
    {
        [DatabaseGenerated(DatabaseGeneratedOption.None)]
        [Key, Column("ID_ESTATUS")]
        public Int32 IdEstatus { get; set; }

        [Column("DESCRIPCION")]
        public string DESCRIPCION { get; set; }

    }
}
