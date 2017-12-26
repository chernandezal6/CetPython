using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;


namespace SuirPlusEF.Models
{
    [Table("SEG_DET_CAPTCHA_T")]
    public class DetalleCaptcha
    {
        [Key, Column("ID")]
        public Int32 ID { get; set; }

        [Column("ID_MASTER"), ForeignKey("Captcha")]
        public Int32 MaestroId { get; set; }

        [Column("PREGUNTA")]
        public string Pregunta { get; set; }

        [Column("TIPO_INPUT")]
        public string TipoInput { get; set; }

        [Column("ESTATUS")]
        public string Estatus { get; set; }

        [Column("ORIGEN_RESPUESTA")]
        public string OrigenRespuesta { get; set; }

        [Column("CAMPO_RESPUESTA")]
        public string CampoRespuesta { get; set; }

        [Column("COLETILLA")]
        public string Coletilla { get; set; }

        public virtual Captcha Captcha { get; set; }


    }
}
