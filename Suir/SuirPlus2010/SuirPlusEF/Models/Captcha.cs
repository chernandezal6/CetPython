using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SuirPlusEF.Framework;


namespace SuirPlusEF.Models
{
    [Table("SEG_CAPTCHA_T")]
    public class Captcha : BaseModel
    {
        public Captcha()
        {
            this.myOracleSequenceName = "SEG_CAPTCHA_T_SEQ";
        }

        public override int AssignId(int id)
        {
            this.ID = id;
            return id;
        }

        [DatabaseGenerated(DatabaseGeneratedOption.None)]
        [Key, Column("ID")]
        public Int32 ID { get; set; }

        [Column("DESCRIPCION")]
        public string Descripcion { get; set; }

        [Column("URL")]
        public string Url { get; set; }

        [Column("ESTATUS")]
        public string Estatus { get; set; }

        [Column("COLETILLA")]
        public string Coletilla { get; set; }
                      
    }
}
