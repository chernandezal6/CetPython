using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SuirPlusEF.Models
{
    [Table("SRE_REPRESENTANTES_T")]
    public class Representante
    {
        [Key, ForeignKey("Ciudadano"), Column("ID_NSS", Order = 0)]
        public Int32? IdNSS { get; set; }

        [Key, ForeignKey("RegistroPatronal"), Column("ID_REGISTRO_PATRONAL", Order = 1)]
        public Int32? IdRegistroPatronal { get; set; }

        [Column("STATUS")]
        public string Status { get; set; }

        [Column("TIPO_REPRESENTANTE")]
        public string Tipo { get; set; }

        [Column("FACTURA_X_EMAIL")]
        public string FacturaEmail { get; set; }

        [Column("TELEFONO_1")]
        public string Telefono1 { get; set; }

        [Column("EXT_1")]
        public string Ext1 { get; set; }

        [Column("TELEFONO_2")]
        public string Telefono2 { get; set; }

        [Column("EXT_2")]
        public string Ext2 { get; set; }

        [ForeignKey("Usuario"), Column("ULT_USUARIO_ACT")]
        public string UltimoUsuarioActualiza { get; set; }

        [Column("ULT_FECHA_ACT")]
        public DateTime? UltimaFechaActualiza { get; set; }

        public virtual Ciudadano Ciudadano { get; set; }
        public virtual Empresa RegistroPatronal { get; set; }
        public virtual Usuario Usuario { get; set; }

    }
}
