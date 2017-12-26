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
    [Table("NSS_DET_SOLICITUDES_T")]
    public class DetalleSolicitudes : BaseModel
    {
        public DetalleSolicitudes()
        {
            this.myOracleSequenceName = "NSS_DET_SOLICITUDES_T_SEQ";
        }
        
        public override int AssignId(int id)
        {
            this.IdRegistro = id;
            return id;
        }

        [DatabaseGenerated(DatabaseGeneratedOption.None)]
        [Key, Column("ID_REGISTRO")]
        public Int32 IdRegistro { get; set; }

        [ForeignKey("solicitudNSS"), Column("ID_SOLICITUD")]
        public Int32 IdSolicitud { get; set; }

        [Column("SECUENCIA")]
        public Int32 Secuencia { get; set; }
        
        [ForeignKey("TipoDocumento") ,Column("ID_TIPO_DOCUMENTO")]
        public string IdTipoDocumento { get; set; }

        [Column("NO_DOCUMENTO_SOL")]
        public string Documento { get; set; }

        [ForeignKey("estatus"), Column("ID_ESTATUS")]
        public Int32 IdEstatus { get; set; }

        [ForeignKey("error"), Column("ID_ERROR")]
        public string IdError { get; set; }

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

        [ForeignKey("nacionalidad"), Column("ID_NACIONALIDAD")]
        public string IdNacionalidad { get; set; }

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

        [Column("TIPO_LIBRO_ACTA")]
        public string TipoLibro { get; set; }

        [Column("LITERAL_ACTA")]
        public string LiteralActa { get; set; }

        
        [Column(TypeName ="BLOB")]        
        public byte[] IMAGEN_SOLICITUD { get; set; }

        [Column(TypeName = "BLOB")]
        public byte[] IMAGEN_ACTA_DEFUNCION { get; set; }

        [Column("COMENTARIO")]
        public string Comentario { get; set; }

        [Column("EXTRANJERO")]
        public string Extranjero { get; set; }

        [ForeignKey("ciudadano"), Column("ID_NSS_TITULAR")]
        public Int32? IdNSSTitular { get; set; }

        [ForeignKey("parentesco"), Column("ID_PARENTESCO")]
        public string IdParentesco { get; set; }

        [Column("ID_ARS")]
        public string IdARS { get; set; }

        [Column("ID_NSS")]
        public Int32? IdNSSAsignado { get; set; }

        [Column("ID_CONTROL")]
        public Int32? IdControl { get; set; }

        [Column("NUM_CONTROL")]
        public Int64? NumControl{ get; set; }

        [ForeignKey("certificacion"), Column("ID_CERTIFICACION")]
        public Int32? IdCertificacion { get; set; }

        [ForeignKey("usuarioProcesa"), Column("USUARIO_PROCESA")]
        public string UsuarioProcesa { get; set; }

        [Column("FECHA_PROCESA")]
        public DateTime? FechaProcesa { get; set; }

        [Column("ULT_FECHA_ACT")]
        public DateTime? UltimaFechaActualizacion { get; set; }

        [ForeignKey("usuario"),Column("ULT_USUARIO_ACT")]
        public string UltimoUsuarioActualiza { get; set; }

        public virtual EstatusNSS estatus { get; set; }
        public virtual Parentesco parentesco { get; set; }
        public virtual Usuario usuario { get; set; }
        public virtual Usuario usuarioProcesa{ get; set; }
        public virtual SolicitudNSS solicitudNSS{ get; set; }
        public virtual TipoDocumento TipoDocumento { get; set; }
        public virtual Nacionalidad nacionalidad { get; set; }
        public virtual Ciudadano ciudadano { get; set; }
        public virtual Certificaciones certificacion { get; set; }
        public virtual Error error { get; set; }     
        
    }
}
