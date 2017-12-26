using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SuirPlusEF.Models
{
    [Table("SRE_EMPLEADORES_T")]
    public class Empresa
    {
        [Key, Column("ID_REGISTRO_PATRONAL")]
        public Int32 IdRegistroPatronal { get; set; }

        [ForeignKey("MotivoNoImpresion"),Column("ID_MOTIVO_NO_IMPRESION")]
        public string IdMotivoNoImpresion { get; set; }

        [ForeignKey("SectorEconomico"),Column("ID_SECTOR_ECONOMICO")]
        public Int32 ? IdSectorEconomico { get; set; }

        [ForeignKey("Oficio"), Column("ID_OFICIO")]
        public Int32 ? IdOficio { get; set; }

        [ForeignKey("ActividadEconomica") ,Column("ID_ACTIVIDAD_ECO")]
        public string IdActividadEconomica { get; set; }

        [Column("ID_RIESGO")]
        public string IdRiesgo { get; set; }

        [ForeignKey("Municipio"), Column("ID_MUNICIPIO")]
        public string IdMunicipio { get; set; }

        [Column("RNC_O_CEDULA")]
        public string RncCedula{ get; set; }

        [Column("NOMBRE_COMERCIAL")]
        public string NombreComercial { get; set; }

        [Column("RAZON_SOCIAL")]
        public string RazonSocial { get; set; }

        [Column("STATUS")]
        public string Status { get; set; }

        [Column("CALLE")]
        public string Calle { get; set; }

        [Column("NUMERO")]
        public string Numero { get; set; }

        [Column("EDIFICIO")]
        public string Edificio { get; set; }

        [Column("PISO")]
        public string Piso { get; set; }

        [Column("APARTAMENTO")]
        public string Apartamento { get; set; }

        [Column("SECTOR")]
        public string Sector { get; set; }

        [Column("TELEFONO_1")]
        public string Telefono1 { get; set; }

        [Column("EXT_1")]
        public string Extencion1 { get; set; }

        [Column("TELEFONO_2")]
        public string Telefono2 { get; set; }

        [Column("EXT_2")]
        public string Extencion2 { get; set; }
        
        [Column("FAX")]
        public string Fax { get; set; }

        [Column("EMAIL")]
        public string Email { get; set; }

        [Column("TIPO_EMPRESA")]
        public string TipoEmpresa { get; set; }

        [Column("DESCUENTO_PENALIDAD")]
        public decimal DescuentoPenalidad { get; set; }

        [Column("RUTA_DISTRIBUCION")]
        public Int32 ? RutaDistribucion { get; set; }

        [Column("FECHA_REGISTRO")]
        public DateTime ? FechaRegistro { get; set; }

        [Column("NO_PAGA_IDSS")]
        public string NoPagaIDSS { get; set; }

        [Column("ULT_USUARIO_ACT")]
        public string UltimoUsuarioActualizacion { get; set; }

        [Column("ULT_FECHA_ACT")]
        public DateTime ? UltimaFechaActualizacion { get; set; }

        [Column("PERMITIR_PAGO")]
        public string PermitirPago { get; set; }

        [ForeignKey("AdministracionLocal") ,Column("ID_ADMINISTRACION_LOCAL")]
        public string IdAdministracionLocal { get; set; }

        [Column("ID_EJECUTIVO")]
        public string IdEjecutivo { get; set; }

        [Column("TIENE_MOVIMIENTO_PENDIENTE")]
        public string TieneMovimientosPendientes { get; set; }

        [Column("COMPLETO_ENCUESTA")]
        public string CompletoEncuesta { get; set; }

        [Column("FECHA_DE_BAJA")]
        public DateTime ? FechaDeBaja { get; set; }

        [Column("FECHA_INICIO_ACTIVIDADES")]
        public DateTime ? FechaInicioActividades { get; set; }

        [Column("FECHA_NAC_CONST")]
        public DateTime ? FechaNacimientoConst { get; set; }

        [Column("ACUERDO_PAGO")]
        public string AcuerdoPago { get; set; }

        [Column("LOCALIZACION")]
        public string Localizacion { get; set; }

        [Column("AREA")]
        public Int32 ? Area { get; set; }

        [Column("ZONA")]
        public Int32 ? Zona { get; set; }

        [Column("USUARIO_REGISTRO")]
        public string UsuarioRegistro { get; set; }

        [Column("SECUENCIA_SIPEN")]
        public Int32 ? SecuenciaSipen { get; set; }

        [Column("RNC_O_CEDULA_ANTERIOR")]
        public string RncCedulaAnterior { get; set; }

        [Column("PERIODO_RNC_O_CEDULA_ANTERIOR")]
        public Int32 ? PeriodoRncCedulaAnterior { get; set; }

        [Column("PAGA_INFOTEP")]
        public string PagoInfotep { get; set; }

        [Column("PAGA_VIA_TN")]
        public string PagaViaTN { get; set; }

        [Column("GRAN_CONTRIBUYENTE_DGII")]
        public string GranContribuyenteDGII { get; set; }

        [Column("STATUS_AUDITORIA")]
        public string EstatusAuditoria { get; set; }

        [Column("LEY_FACILIDADES_PAGO")]
        public string LeyFacilidadesPago { get; set; }

        [Column("ID_ENTIDAD_RECAUDADORA")]
        public Int32 ? IdEntidadRecaudadora { get; set; }

        [Column("CUENTA_BANCO")]
        public string CuentaBanco { get; set; }

        [Column("SFS_RNC_O_CEDULA")]
        public string SfsRncCedula { get; set; }

        [Column("SFS_TIPO_PAGO")]
        public string SfsTipoPago { get; set; }

        [Column("TIPO_CUENTA")]
        public Int32 ? TipoCuenta { get; set; }

        [ForeignKey("SectorSalarial") ,Column("COD_SECTOR")]
        public Int32 ? CodSector { get; set; }

        [Column("CAPITAL")]
        public decimal ? Capital { get; set; }

        [Column("DOCUMENTOS_REGISTRO")]
        public Object  DocumentosRegistro { get; set; }

        [Column("PAGA_RECARGOS_DGII")]
        public string PagaRecargosDGII { get; set; }

        [Column("ESCALAR_SALARIO")]
        public string EscalarSalario { get; set; }

        [Column("ID_INHABILIDAD_EMPLEADOR")]
        public Int32 ? IdInhabilidadEmpleador { get; set; }

        [Column("PAGA_DGII")]
        public string PagaDGII { get; set; }

        [Column("PAGA_MDT")]
        public string PagaMDT { get; set; }

        [Column("ID_ACTIVIDAD")]
        public string IdActividad { get; set; }
        
        [Column("TIPO_ZONA_FRANCA")]
        public string TipoZonaFranca { get; set; }

        [Column("ID_ZONA_FRANCA")]
        public string IdZonaFranca { get; set; }
        
        [Column("ES_ZONA_FRANCA")]
        public string EsZonaFranca { get; set; }

        [Column("CARTERA_LEGAL")]
        public string CarteraLegal { get; set; }

        [Column("PAGO_SUBSIDIOS")]
        public string PagoSubsidios { get; set; }

        [Column("PAGO_DISCAPACIDAD")]
        public string PagoDiscapacidad { get; set; }

        [Column("STATUS_MDT")]
        public string EstatusMDT { get; set; }

        public virtual SectorSalarial SectorSalarial { get; set; }
        public virtual AdministracionLocal AdministracionLocal { get; set; }
        public virtual SectorEconomico SectorEconomico { get; set; }
        public virtual Municipio Municipio { get; set; }
        public virtual ActividadEconomica ActividadEconomica { get; set; }
        public virtual MotivoNoImpresion MotivoNoImpresion { get; set; }
        public virtual Oficio Oficio { get; set; }

    }
}
