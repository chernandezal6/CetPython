using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using SuirPlusEF.GenericModels;
using SuirPlusEF.Framework;

namespace SuirPlusEF.Models
{
    [Table("NSS_DET_SOL_DOCUMENTO_T")]

    public class DetSolicitudNSSDocumentos : BaseModel
    {
        public DetSolicitudNSSDocumentos()
        {
            this.myOracleSequenceName = "NSS_DET_SOL_DOCUMENTO_T_SEQ";
        }

        public override int AssignId(int id)
        {
            this.Id = id;
            return id;
        }

        [DatabaseGenerated(DatabaseGeneratedOption.None)]
        [Key, Column("ID")]
        public Int32 Id { get; set; }

        //[ForeignKey("SolicitudNSS"), Column("ID_SOLICITUD")]
        [ForeignKey("SolicitudNSS"), Column("ID_SOLICITUD")]
        public Int32  IdSolicitud { get; set; }

        [Column("NRO_DOCUMENTO")]
        public string NroDocumento { get; set; }

        public virtual SolicitudNSS SolicitudNSS { get; set; }

    }
}
