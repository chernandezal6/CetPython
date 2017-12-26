using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using SuirPlusEF.Framework;

namespace SuirPlusEF.Models
{
    [Table("NSS_MAESTRO_EXTRANJEROS_T")]
    public class MaestroExtranjero : BaseModel
    {

        public MaestroExtranjero()
        {
            this.myOracleSequenceName = "NSS_MAESTRO_EXTRANJEROS_T_SEQ";
        }

        public override int AssignId(int id)
        {
            this.IdMaestroExtranjero = id;
            return id;
        }

        [DatabaseGenerated(DatabaseGeneratedOption.None)]
        [Key, Column("ID_MAESTRO_EXTRANJERO")]
        public Int32 IdMaestroExtranjero { get; set; }

        [Column("ID_EXPEDIENTE")]
        public string IdExpediente { get; set; }

        [ForeignKey("TipoDocumento") ,Column("ID_TIPO_DOCUMENTO")]
        public string IdTipoDocumento { get; set; }

        [Column("NOMBRES")]
        public string Nombres { get; set; }

        [Column("PRIMER_APELLIDO")]
        public string PrimerApellido { get; set; }

        [Column("SEGUNDO_APELLIDO")]
        public string SegundoApellido { get; set; }

        [Column("FECHA_NACIMIENTO")]
        public DateTime? FechaNacimiento { get; set; }

        [Column("SEXO")]
        public string Sexo { get; set; }

        [ForeignKey("nacionalidad") ,Column("ID_NACIONALIDAD")]
        public string IdNacionalidad { get; set; }

        [Column("CEDULA")]
        public string Cedula { get; set; }

        [Column("TIPO_PERMISO_RESIDENCIA")]
        public string TipoPermisoResidencia { get; set; }

        [Column("FECHA_EXPEDICION")]
        public DateTime? FechaExpedicion { get; set; }

        [Column("FECHA_EXPIRACION")]
        public DateTime? FechaExpiracion { get; set; }

        [ForeignKey("ciudadano"), Column("ID_NSS")]
        public Int32? IdNSSAsignado { get; set; } 

        public virtual TipoDocumento TipoDocumento { get; set; }
        public virtual Nacionalidad nacionalidad { get; set; }
        public virtual Ciudadano ciudadano { get; set; }

    }
}
