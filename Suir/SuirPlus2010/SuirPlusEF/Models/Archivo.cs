using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace SuirPlusEF.Models
{
    [Table("SRE_ARCHIVOS_T")]
    public class Archivo
    {
        [Key, Column("ID_RECEPCION")]
        public Int32 IdRecepcion { get; set; }

        [ForeignKey("EntidadRecaudadora"), Column("ID_ENTIDAD_RECAUDADORA")]
        public Int32? IdEntidadRecaudadora { get; set; }

        [ForeignKey("TipoMovimiento"),Column("ID_TIPO_MOVIMIENTO")]
        public string IdTipoMovimiento { get; set; }

        [ForeignKey("Error"), Column("ID_ERROR")]
        public string IdError { get; set; }

        [Column("STATUS")]
        public string Estatus { get; set; }

        [Column("ID_RNC_CEDULA")]
        public string RncCedula { get; set; }

        [Column("NUMERO_HASH")]
        public string NumeroHash { get; set; }

        [Column("NOMBRE_ARCHIVO")]
        public string NombreArchivo { get; set; }

        [Column("NOMBRE_ARCHIVO_NACHA")]
        public string NombreArchivoNacha { get; set; }

        [Column("NOMBRE_ARCHIVO_RESPUESTA")]
        public string NombreArchivoRespuesta { get; set; }

        [Column("REGISTROS_OK")]
        public Int32 RegistrosOk { get; set; }

        [Column("REGISTROS_BAD")]
        public Int32 RegistrosBad { get; set; }

        [Column("ULT_FECHA_ACT")]
        public DateTime? UltimaFechaActualiza { get; set; }

        [ForeignKey("UsuarioActualiza"), Column("ULT_USUARIO_ACT")]
        public string UltimoUsuarioActualiza { get; set; }

        [Column("TIPO_ENTIDAD_RECAUDADORA")]
        public Int32? TipoEntidadRecaudadora { get; set; }

        [Column("TOTAL_PAGADO")]
        public decimal? TotalPagado { get; set; }

        [Column("FECHA_CARGA")]
        public DateTime? FechaCarga { get; set; }

        [ForeignKey("UsuarioModifica"), Column("USUARIO_CARGA")]
        public string UsuarioCarga { get; set; }

        [Column("NOMBRE_ARCHIVO_RESPUESTA_NE")]
        public string NombreArchivoRespuestaNE { get; set; }

        [Column("NOMBRE_ARCHIVO_NACHA_NE")]
        public string NombreArchivoNachaNE { get; set; }

        [Column("STATUS_CRYPTO_NACHA")]
        public string EstatusCryptoNacha { get; set; }

        [Column("STATUS_CRYPTO_RESPUESTA")]
        public string EstatusCryptoRespuesta { get; set; }

        [Column("IP_ADDRESS")]
        public string IpAddress { get; set; }

        [Column("ARCHIVO_RESPUESTA")]
        public Object ArchivoRespuesta { get; set; }

        [Column("ARCHIVO_RESPUESTA_NACHA")]
        public Object ArchivoRespuestaNacha { get; set; }

        public virtual Usuario UsuarioActualiza { get; set; }
        public virtual Usuario UsuarioModifica { get; set; }
        public virtual EntidadRecaudadora EntidadRecaudadora { get; set; }
        public virtual TipoMovimiento TipoMovimiento { get; set; }
        public virtual Error Error { get; set; }

    }
}
