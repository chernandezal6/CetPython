using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SuirPlusEF.Models
{
    [Table("CER_CERTIFICACIONES_T")]
    public class Certificaciones
    {
        [Key, Column("ID_CERTIFICACION")]
        public Int32 IdCertificacion { get; set; }

        [ForeignKey("usuario"), Column("ID_USUARIO")]
        public string IdUsuario { get; set; }

        [Column("ID_TIPO_CERTIFICACION")]
        public string IdTipoCertificacion { get; set; }

        [ForeignKey("empresa"), Column("ID_REGISTRO_PATRONAL")]
        public Int32? IdRegistroPatronal { get; set; }

        [Column("ID_NSS")]
        public Int32? IdNSS { get; set; }

        [Column("FECHA_DESDE")]
        public DateTime? FechaDesde { get; set; }

        [Column("FECHA_HASTA")]
        public DateTime? FechaHasta { get; set; }

        [Column("FIRMA")]
        public string Firma { get; set; }

        [Column("FECHA_CREACION")]
        public DateTime? FechaCreacion { get; set; }

        [Column("PUESTO_RESP_FIRMA")]
        public string PuestoRespFirma { get; set; }

        [Column("ID_STATUS_CERTIFICACION")]
        public Int32? IdStatusCertificacion { get; set; }

        [Column("DOCUMENTO")]
        public byte[] Documento { get; set; }

        [Column("ID_FIRMA")]
        public Int32? IdFirma { get; set; }

        [Column("ULT_FECHA_ACT")]
        public DateTime? UltimaFechaActualiza { get; set; }

        [ForeignKey("usuarioActualiza"), Column("ULT_USUARIO_ACT")]
        public string UltimoUsuarioActualiza { get; set; }

        [Column("COMENTARIO")]
        public string Comentario { get; set; }

        [Column("NO_CERTIFICACION")]
        public String NumeroCertificacion { get; set; }

        [Column("PIN")]
        public Int32 Pin { get; set; }

        [Column("PDF")]
        public byte[] PdfCertificacion { get; set; }

        public virtual Empresa empresa { get; set; }
        public virtual Usuario usuario { get; set; }
        public virtual Usuario usuarioActualiza { get; set; }

    }
}
