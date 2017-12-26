using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SuirPlusEF.Models
{
    [Table("ARS_CARTERA_T")]
    public class ArsCartera
    {
        [Key, Column("PERIODO_FACTURA_ARS",Order = 0)]
        public string PeriodoFacturaArs { get; set; }

        [Column("NSS_TITULAR")]
        public Int32 NssTitular { get; set; }
        
        [Column("NSS_DEPENDIENTE")]
        public Int32 NssDependiente { get; set; }

        [Key, ForeignKey("Ars"),Column("ID_ARS", Order = 1)]
        public Int32? IdArs { get; set; }
        
        [Column("TIPO_AFILIADO")]
        public string TipoAfiliado { get; set; }
        
        [Column("CODIGO_PARENTESCO")]
        public string CodigoParentesco { get; set; }
        
        [Column("DISCAPACITADO")]
        public string Discapacitado { get; set; }

        [Column("ESTUDIANTE")]
        public string Estudiante { get; set; }
        
        [Column("ID_REFERENCIA_DISPERSION")]
        public string IdReferenciaDispersion { get; set; }
       
        [Column("NSS_DISPARA_PAGO")]
        public Int32? NssDisparaPago { get; set; }
        
        [Column("FECHA_REGISTRO")]
        public DateTime? FechaRegistro { get; set; }
       
        [Column("ULT_FECHA_ACT")]
        public DateTime? UltimaFechaActualizacion { get; set; }

        [Key,  ForeignKey("CargaDispersion"), Column("ID_CARGA_DISPERSION", Order = 2)]
        public Int32? IdCargaDispersion { get; set; }

        [Column("ID_CARGA_CARTERA")]
        public Int32? IdCargaCartera { get; set; }

        [Column("MONTO_DISPERSAR")]
        public decimal? MontoDispersar { get; set; }
      
        [Column("ID_ARS_DISPERSADA")]
        public Int32? IdArsDispersada { get; set; }

        [Column("REGISTRO_DISPERSADO")]
        public string RegistroDispersado { get; set; }

        [Column("MONTO_COMPLETIVO")]
        public decimal? MontoCompletivo { get; set; }

        [Column("ID_CARGA_COMPLETIVO")]
        public Int32? IdCargaCompletivo { get; set; }

        [Column("ID_REFERENCIA_FONAMAT")]
        public string IdReferenciaFonamat { get; set; }

        [Column("NSS_DISPARA_PAGO_FONAMAT")]
        public Int32? NssDisparaPagoFonamat { get; set; }
      
        [Column("ID_CARGA_FONAMAT")]
        public Int32? IdCargaFonamat { get; set; }

        [Column("MONTO_FONAMAT")]
        public decimal? MontoFonamat { get; set; }

        [Column("ID_ARS_FONAMAT")]
        public Int32? IdArsFomamat { get; set; }

        public virtual ArsCatalogo Ars { get; set; }
        public virtual ArsCarga CargaDispersion { get; set; }
    }
}
