using SuirPlusEF.Framework;
using SuirPlusEF.GenericModels;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SuirPlusEF.Models
{
    [Table("SRE_CIUDADANOS_T")]
    public class Ciudadano:BaseModel
    {
        public Ciudadano()
        {}
        public override int AssignId(int id)
        {
            return 0;
        }
        //Primary Key
        [DatabaseGenerated(DatabaseGeneratedOption.None)]
        [Key, Column("ID_NSS")]
        public Int32 IdNSS { get; set; }

        //Foreign Keys
        [ForeignKey("Provincia"), Column("ID_PROVINCIA")]
        public string IdProvincia { get; set; }

        [ForeignKey("TipoSangre"), Column("ID_TIPO_SANGRE")]
        public string IdTipoSangre { get; set; }

        [ForeignKey("InhabilidadJCE"), Column("ID_CAUSA_INHABILIDAD", Order = 0)]
        public Int32 ? IdCausaInhabilidad { get; set; }
        
        [ForeignKey("Nacionalidad"), Column("ID_NACIONALIDAD")]
        public string IdNacionalidad { get; set; }

        [ForeignKey("Municipio"), Column("MUNICIPIO_ACTA")]
        public string IdMunicipio { get; set; }               

        //Columnas adicionales
        [Column("NOMBRES")]
        public string Nombres { get; set; }

        [Column("PRIMER_APELLIDO")]
        public string PrimerApellido { get; set; }

        [Column("SEGUNDO_APELLIDO")]
        public string SegundoApellido { get; set; }

        [Column("ESTADO_CIVIL")]
        public string EstadoCivil { get; set; }

        [Column("FECHA_NACIMIENTO")]
        public DateTime  FechaNacimiento { get; set; }

        [Column("NO_DOCUMENTO")]
        public string NroDocumento { get; set; }

        [Column("TIPO_DOCUMENTO")]
        public string TipoDocumento { get; set; }

        [Column("SEXO")]
        public string Sexo { get; set; }

        [Column("NOMBRE_PADRE")]
        public string NombrePadre { get; set; }

        [Column("NOMBRE_MADRE")]
        public string NombreMadre { get; set; }

        [Column("FECHA_REGISTRO")]
        public DateTime? FechaRegistro { get; set; }

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

        [Column("CEDULA_ANTERIOR")]
        public string CedulaAnterior { get; set; }

        [Column("STATUS")]
        public string Estatus { get; set; }

        [Column("ULT_FECHA_ACT")]
        public DateTime? UltimaFechaActualizacion { get; set; }

        [ForeignKey("Usuario"),Column("ULT_USUARIO_ACT")]
        public string UltimoUsuarioActualizacion { get; set; }
       
        [ForeignKey("InhabilidadJCE"), Column("TIPO_CAUSA",Order = 1)]
        public string TipoCausa { get; set; }

        [Column("FECHA_EXPEDICION")]
        public DateTime? FechaExpedicion { get; set; }

        [Column("COTIZACION")]
        public string Cotizacion { get; set; }

        [Column("SECUENCIA_SIPEN")]
        public Int32? SecuenciaSipen { get; set; }

        [Column("IMAGEN_ACTA")]
        public byte[] ImagenActa { get; set; }

        [Column("TIPO_LIBRO_ACTA")]
        public string TipoLibroActa { get; set; }

        [Column("LITERAL_ACTA")]
        public string LiteralActa { get; set; }

        [Column("FECHA_FALLECIMIENTO")]
        public DateTime? FechaFallecimiento { get; set; }

        [ForeignKey("tipoNSS"), Column("ID_TIPO_NSS")]
        public Int32? Id_Tipo_NSS { get; set; }

        //Relaciones de las Foreign Key
        public virtual Provincia Provincia { get; set; }
        public virtual TipoSangre TipoSangre { get; set; }
        [ForeignKey("IdCausaInhabilidad,TipoCausa")]
        public virtual InhabilidadJCE InhabilidadJCE { get; set; }
        public virtual Nacionalidad Nacionalidad { get; set; }
        public virtual Municipio Municipio { get; set; }
        public virtual Usuario Usuario { get; set; }
        public virtual TipoNSS tipoNSS { get; set; }
           public DocumentoNSS DocumentoNSS {
            get {
                return new DocumentoNSS(this.IdNSS.ToString());
            }
        }

 
    }
}
