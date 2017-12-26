using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SuirPlusEF.Models
{
     [Table("SFC_ENTIDAD_RECAUDADORA_T")]
    public class EntidadRecaudadora
    {
         [Key, Column("ID_ENTIDAD_RECAUDADORA")]
         public Int32 IdEntidadRecaudadora { get; set; }
      
         [Column("ENTIDAD_RECAUDADORA_DES")]
         public string Descripcion { get; set; }
         
         [Column("ULT_FECHA_ACT")]
         public DateTime? UltimaFechaActualizacion { get; set; }

         [ForeignKey("Usuario") ,Column("ULT_USUARIO_ACT")]
         public string UltimoUsuarioActualizo { get; set; }

         [Column("CUENTA_RECAUDADORA")]
         public string CuentaRecaudadora { get; set; }

         [Column("RUTA_Y_TRANSITO")]
         public Int32? RutaTransito { get; set; }
         
         [Column("DIGITO_CHEQUEO")]
         public Int32? ChequearDigito { get; set; }

         [Column("CODIGO_ORIGEN_TRANSACCION")]
         public Int32? OrigenTransaccion { get; set; }

         [Column("TEXTO_ORIGEN")]
         public string OrigenTexto { get; set; }
        
         [Column("EMAIL_REPORTES")]
         public string EmailReportes { get; set; }

         [Column("EMAIL_RECAUDO_IBANKING")]
         public string EmailRecaudoIbanking { get; set; }

         [Column("CUENTA_RECAUDADORA_INFOTEP")]
         public string CuentaRecaudadoraInfotep { get; set; }
         
         [Column("TEXTO_ORIGEN_INFOTEP")]
         public string OrigenTextoInfotep { get; set; }

         [Column("CODIGO_ORIGEN_TRANSAC_INFOTEP")]
         public Int32? OrigenTransacInfotep { get; set; }

         [Column("SFS")]
         public string SFS { get; set; }

         [Column("BANCOSRECAUDADORESDGII")]
         public Int32 BancosRecaudadoresDGII { get; set; }

         [Column("BANCOSRECAUDADORESTSS")]
         public Int32 BancosRecaudadoresTSS { get; set; }

         [Column("BANCOSRECAUDADORESINF")]
         public Int32 BancosRecaudadoresINF { get; set; }

         [Column("RUTA_Y_TRANSITO_INFOTEP")]
         public Int32? RutaTransitoInfotep { get; set; }

         [Column("DIGITO_CHEQUEO_INFOTEP")]
         public Int32? DigitoChequeoInfotep { get; set; }

         [Column("COD_BIC_SWIFT")]
         public string BicSwift { get; set; }

         [Column("CUENTA_CONCENTRADORA")]
         public string CuentaConcentradora { get; set; }

        public virtual Usuario Usuario { get; set; }
    }
}
