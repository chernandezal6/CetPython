using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SuirPlusEF.Models
{
    [Table("ARS_CARTERA_SENASA_T")]
    public class ArsCarteraSenasa
    {
        [Key, ForeignKey("Ars"), Column("CODIGO_ARS")]
        public Int32 CodigoArs { get; set; }

        [Column("PERIODO_FACTURA")]
        public Int32 PeriodoFactura { get; set; }
        
        [Column("NSS_TITULAR")]
        public Int32 NssTitular { get; set; }
        
        [Column("NSS_DEPENDIENTE")]
        public Int32? NssDependiente { get; set; }

        [Column("TIPO_DEPENDENCIA")]
        public string TipoDependencia { get; set; }

        [Column("ESTUDIANTE")]
        public string Estudiante { get; set; }

        [Column("DISCAPACITADO")]
        public string Discapacitado { get; set; }

        [ForeignKey("Usuario"), Column("ULT_USUARIO_ACT")]
        public string UltimoUsuarioActualizo { get; set; }

        [Column("ULT_FECHA_AC")]
        public DateTime UltimaFechaActualizacion { get; set; }

        [Column("TIPO_FACTURABLE")]
        public Int32? TipoFacturable { get; set; }

        [Column("ID_CARGA")]
        public Int32? IdCarga { get; set; } 

        public virtual ArsCatalogo Ars { get; set; }
        public virtual Usuario Usuario { get; set; }


    }
}
