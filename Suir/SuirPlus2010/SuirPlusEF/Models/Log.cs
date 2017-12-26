using SuirPlusEF.Framework;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SuirPlusEF.Models
{
    [Table("SEG_LOG_T")]
    public class Log : BaseModel
    {
        [DatabaseGenerated(DatabaseGeneratedOption.None)]
        [Key, Column("ID_LOG")]
        public Int32 Id { get; set; }

        [Column("ID_TIPO")]
        public Int32? IdTipo { get; set; }

        [Column("ID_REGISTRO_PATRONAL")]
        public Int32? RegistroPatronal { get; set; }

        [Column("USUARIO_REPRESENTANTE")]
        public string UsuarioRepresentante { get; set; }

        [Column("FECHA_REGISTRO")]
        public DateTime? FechaRegistro { get; set; }

        [Column("IP_PC")]
        public string IpPC { get; set; }

        [Column("USUARIO_CAE")]
        public string UsuarioNormal { get; set; }

        [Column("COMENTARIO")]
        public string Comentario { get; set; }

        [Column("SERVIDOR")]
        public string Servidor { get; set; }

        public Log() {
            this.myOracleSequenceName = "SEG_LOG_SEQ";
        }

        public override int AssignId(int id)
        {
            this.Id = id;
            return id;
        }
        
    }

    public enum EnumLog
    {
        BloqueoDesbloqueoNotificationesRetroactivas = 1,
        ReseteoClass = 2,
        DetalleNomina = 3,
        DetalleFactura = 4,
        CambioEmailRepresentante = 5,
        Login = 6
    }
}
