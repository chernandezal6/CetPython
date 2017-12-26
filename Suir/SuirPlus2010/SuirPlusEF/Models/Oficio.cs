using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SuirPlusEF.Models
{
    [Table("OFC_OFICIOS_T")]
    public class Oficio
    {
        [Key, Column("ID_OFICIO")]
        public Int32 IdOficio { get; set; }

        [ForeignKey("Accion"),Column("ID_ACCION")]
        public Int32? IdAccion { get; set; }

        [Column("ID_MOTIVO")]
        public Int32? IdMotivo { get; set; }

        [Column("ID_REGISTRO_PATRONAL")]
        public Int32? IdRegistroPatronal { get; set; }

        [Column("STATUS")]
        public string Estatus { get; set; }

        [ForeignKey("Usuario"), Column("USUARIO_SOLICITA")]
        public string UsuarioSolicita { get; set; }

        [Column("FECHA_SOLICITA")]
        public DateTime? FechaSolicita { get; set; }

        [Column("DESTINATARIO")]
        public string Destinatario { get; set; }

        [ForeignKey("UsuarioProcesar"), Column("USUARIO_PROCESA")]
        public string UsuarioProcesa { get; set; }

        [Column("FECHA_PROCESA")]
        public DateTime? FechaProcesa { get; set; }

        [Column("OBSERVACIONES_SOLICITA")]
        public string ObservacionesSolicita { get; set; }

        [Column("OBSERVACIONES_PROCESA")]
        public string ObservacionesProcesa { get; set; }

        [Column("PERIODO_FIN_PROCESO")]
        public Int32? PeriodoFinProceso { get; set; }

        [Column("FECHA_CANCELA")]
        public DateTime? FechaCancela { get; set; }

        [Column("ULT_FECHA_ACT")]
        public DateTime? UltimaFechaActualiza { get; set; }

        [Column("ID_JOB")]
        public Int32? IdJob { get; set; }

        [Column("COD_SECTOR")]
        public Int32? Codigo_Sector { get; set; }

        public virtual Accion Accion { get; set; }       
        public virtual Usuario Usuario { get; set; }
        public virtual Usuario UsuarioProcesar { get; set; }
    }
}
