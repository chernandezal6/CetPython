using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace SuirPlusEF.Models
{
    [Table("SRE_HIS_DOCUMENTOS_T")]
    public class HistoricoDocumento
    {
        [Key,Column("ID")]
        public Int32 Id { get; set;}

        [ForeignKey("Ciudadano"), Column("ID_NSS")]
        public Int32 IdNSS { get; set; }

        [ForeignKey("tipoDocumento"), Column("ID_TIPO_DOCUMENTO")]
        public string Tipo_Documento { get; set; }

        [Column("NO_DOCUMENTO")]
        public string No_Documento { get; set; }


        [Column("FECHA_EMISION")]
        public DateTime ? FechaEmision { get; set; }

        [Column("FECHA_EXPIRACION")]
        public DateTime ? FechaExpiracion { get; set; }

        [Column("ESTATUS")]
        public string Estatus { get; set; }

        [Column("MUNICIPIO_ACTA")]
        public string MunicipioActa { get; set; }

        [Column("ANO_ACTA")]
        public string AnoActa { get; set; }

        [Column("NUMERO_ACTA")]
        public string NumeroActa { get; set; }

        [Column("FOLIO_ACTA")]
        public string FolioActa { get; set; }

        [Column("LIBRO_ACTA")]
        public string LibroActa { get; set; }

        [Column("OFICIALIA_ACTA")]
        public string OficialiaActa { get; set; }

        [Column("TIPO_LIBRO")]
        public string TipoLibro { get; set; }

        [Column("LITERAL_ACTA")]
        public string LiteralActa { get; set; }

        [Column("IMAGEN_ACTA")]
        public object ImagenActa { get; set; }

        [Column("IMAGEN_ACTA_DEFUNCION")]
        public object ImagenActaDefuncion { get; set; }

        [Column("RECEPCION_DOCUMENTO")]
        public DateTime ? FechaRecepcionDocumento { get; set; }

        [Column("FECHA_EFECTIVIDAD")]
        public DateTime ? FechaEfectividad { get; set; }

       [ForeignKey("Usuario"), Column("REGISTRADO_POR")]
        public string RegistradoPor { get; set; }

        [Column("FECHA_REGISTRO")]
        public DateTime FechaRegistro { get; set; }

        [Column("ULT_FECHA_ACT")]
        public DateTime? UltimaFechaActualizacion { get; set; }

        [ForeignKey("UsuarioActualiza"),Column("ULT_USUARIO_ACT")]
        public string UltimoUsuarioActualizacion { get; set; }


        public virtual Usuario Usuario { get; set; }
        public virtual Usuario UsuarioActualiza { get; set; }
        public virtual Ciudadano Ciudadano { get; set; }
        public virtual TipoDocumento tipoDocumento { get; set; }


    }
}
