using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace SuirPlusEF.Models
{
    [Table("SRE_CARNET_DGM_T")]
    public class CarnetDGM
    {
        [DatabaseGenerated(DatabaseGeneratedOption.None)]
        [Key, Column("ID")]
        public Int32 Id { get; set; }

        [Column("DESCRIPCION")]
        public string Descripcion { get; set; }
    }
}
