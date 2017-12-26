using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;


namespace SuirPlusEF.Models
{
    [Table("NSS_ENTIDADES_T")]
    public class Entidad
    {
        [Key, Column("ID_ENTIDAD")]
        public Int32 IdEntidad { get; set; }

        [Column("DESCRIPCION")]
        public string Descripcion { get; set; }

    }

}
