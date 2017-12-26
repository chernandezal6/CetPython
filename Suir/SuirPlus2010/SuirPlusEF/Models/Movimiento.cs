using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace SuirPlusEF.Models
{
    [Table("SRE_MOVIMIENTO_T")]
    public class Movimiento
    {
        [Key, Column("ID_MOVIMIENTO")]
        public Int32 IdMovimiento { get; set; }

        [ForeignKey("Empresa"), Column("ID_REGISTRO_PATRONAL")]
        public Int32 IdRegistroPatronal { get; set; }

        [ForeignKey("UsuarioMovimiento"), Column("ID_USUARIO")]
        public string IdUsuario { get; set; }

        [ForeignKey("TipoMovimiento"), Column("ID_TIPO_MOVIMIENTO")]
        public string IdTipoMovimiento { get; set; }

        [Column("STATUS")]
        public string Estatus { get; set; }

        [Column("FECHA_REGISTRO")]
        public DateTime? FechaRegistro { get; set; }

        [Column("PERIODO_FACTURA")]
        public Int32 PeriodoFactura { get; set; }

        [Column("ULT_FECHA_ACT")]
        public DateTime UltimaFechaActualiza { get; set; }

        [ForeignKey("UsuarioActualiza"), Column("ULT_USUARIO_ACT")]
        public string UltimoUsuarioActualiza { get; set; }

        [Column("ID_RECEPCION")]
        public Int32? Id_Recepcion { get; set; }

        [Column("FECHA_ENVIO")]
        public DateTime? FechaEnvio { get; set; }

        [Column("FECHA_TERMINO")]
        public DateTime? FechaTermino { get; set; }

        [Column("MENSAJE")]
        public string Mensaje { get; set; }

        [Column("IP_ADDRESS")]
        public string IpAddress { get; set; }

        public virtual Empresa Empresa { get; set; }
        public virtual Usuario UsuarioMovimiento { get; set; }
        public virtual Usuario UsuarioActualiza { get; set; }
        public virtual TipoMovimiento TipoMovimiento { get; set; }
    }
}
