using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SuirPlusEF.Models
{
    [Table("SFC_FACTURAS_T")]
    public class Factura
    {

        [Key,Column("ID_REFERENCIA")]
        public string IdReferencia { get; set; }

        [Column("ID_TIPO_FACTURA")]
        public string IdTipoFactura { get; set; }

        [Column("ID_REGISTRO_PATRONAL")]
        public Int32 ? IdRegistroPatronal { get; set; }

        [Column("ID_NOMINA")]
        public Int32 ? IdNomina { get; set; }

        [ForeignKey("Riesgo"), Column("ID_RIESGO")]
        public string IdRiesgo { get; set; }

        [ForeignKey("Entidad"), Column("ID_ENTIDAD_RECAUDADORA")]
        public Int32 ? IdEntidadRecaudadora { get; set; }

        [Column("FECHA_EMISION")]
        public DateTime FechaEmision { get; set; }

        [Column("FECHA_LIMITE_PAGO")]
        public DateTime FechaLimitePago { get; set; }
        
        [Column("PERIODO_FACTURA")]
        public Int32 PeriodoFactura { get; set; }
        
        [Column("FECHA_CANCELA")]
        public DateTime ? FechaCancelacion { get; set; }

        [Column("STATUS")]
        public string Estatus { get; set; }

        [Column("ID_REFERENCIA_ORIGEN")]
        public string IdReferenciaOrigen { get; set; }
       
        [Column("NO_AUTORIZACION")]
        public Int32 ? NumeroAutorizacion { get; set; }
      
        [Column("FECHA_AUTORIZACION")]
        public DateTime ? FechaAutorizacion { get; set; }
       
        [Column("FECHA_DESAUTORIZACION")]
        public DateTime ? FechaDesAutorizacion { get; set; }

        [Column("ID_USUARIO_AUTORIZA")]
        public string IdUsuarioAutoriza { get; set; }

        [Column("ID_USUARIO_DESAUTORIZA")]
        public string IdUsuarioDesAutoriza { get; set; }

        [Column("DESCUENTO_PENALIDAD")]
        public decimal DescuentoPenalidad { get; set; }

        [Column("TOTAL_SALARIO_SS")]
        public decimal SalarioSS { get; set; }
        
        [Column("TOTAL_APORTE_AFILIADOS_SFS")]
        public decimal AporteAfiliadoSFS { get; set; }

        [Column("TOTAL_APORTE_EMPLEADOR_SFS")]
        public decimal AporteEmpleadorSFS { get; set; }

        [Column("TOTAL_APORTE_AFILIADOS_SVDS")]
        public decimal AporteAfiliadoSVDS{ get; set; }

        [Column("TOTAL_APORTE_EMPLEADOR_SVDS")]
        public decimal AporteEmpleadorSVDS { get; set; }

        [Column("TOTAL_APORTE_SRL")]
        public decimal AporteSRL { get; set; }

        [Column("TOTAL_PER_CAPITA_ADICIONAL")]
        public decimal PerCapitaAdicional { get; set; }

        [Column("TOTAL_RECARGO_SVDS")]
        public decimal RecargoSVDS { get; set; }
        
        [Column("TOTAL_INTERES_SRL")]
        public decimal InteresSRL { get; set; }
       
        [Column("TOTAL_INTERES_AFP")]
        public decimal InteresAFP { get; set; }
       
        [Column("TOTAL_INTERES_CPE")]
        public decimal InteresCPE { get; set; }
       
        [Column("TOTAL_INTERES_FSS")]
        public decimal InteresFSS { get; set; }
       
        [Column("TOTAL_INTERES_OSIPEN")]
        public decimal InteresOSIPEN { get; set; }
        
        [Column("TOTAL_INTERES_SEGURO_VIDA")]
        public decimal InteresSeguroVida { get; set; }
        
        [Column("TOTAL_RECARGO_SFS")]
        public decimal RecargoSFS { get; set; }

        [Column("TOTAL_INTERES_SFS")]
        public decimal InteresSFS { get; set; }

        [Column("TOTAL_RECARGO_SRL")]
        public decimal RecargoSRL { get; set; }

        [Column("TOTAL_TRABAJADORES")]
        public Int32 TotalTrabajadores { get; set; }

        [Column("TOTAL_APORTE_AFILIADOS_T3")]
        public decimal AporteAfiliadosT3 { get; set; }

        [Column("TOTAL_APORTE_EMPLEADOR_T3")]
        public decimal AporteEmpleadorT3 { get; set; }

        [Column("TOTAL_APORTE_AFILIADOS_IDSS")]
        public decimal AporteAfiliadosIDSS { get; set; }

        [Column("TOTAL_RECARGO_IDSS")]
        public decimal TotalRecargoIDSS { get; set; }

        [Column("TOTAL_INTERESES_IDSS")]
        public decimal TotalInteresesIDSS { get; set; }

        [Column("TOTAL_APORTE_EMPLEADOR_IDSS")]
        public decimal AporteEmpleadorIDSS { get; set; }

        [Column("TOTAL_APORTE_VOLUNTARIO")]
        public decimal AporteVoluntario { get; set; }

        [Column("TOTAL_CUENTA_PERSONAL")]
        public decimal CuentaPersonal { get; set; }

        [Column("TOTAL_SEGURO_VIDA")]
        public decimal TotalSeguroVida { get; set; }

        [Column("TOTAL_FONDO_SOLIDARIDAD")]
        public decimal FondoSolidaridad { get; set; }

        [Column("TOTAL_COMISION_AFP")]
        public decimal TotalComisionAFP { get; set; }

        [Column("TOTAL_OPERACION_SIPEN")]
        public decimal TotalOperacionSIPEN { get; set; }

        [Column("TOTAL_INTERES_APO")]
        public decimal TotalInteresAPO { get; set; }

        [Column("TOTAL_OPERACION_SISALRIL_SRL")]
        public decimal OperacionSisalrilSRL { get; set; }

        [Column("TOTAL_PROPORCION_ARL_SRL")]
        public decimal ProporcionArlSRL { get; set; }

        [Column("TOTAL_CUIDADO_SALUD")]
        public decimal TotalCuidadoSalud { get; set; }

        [Column("TOTAL_ESTANCIAS_INFANTILES")]
        public decimal EstanciasInfantiles { get; set; }

        [Column("TOTAL_SUBSIDIOS_SALUD")]
        public decimal SubsidiosSalud { get; set; }

        [Column("FECHA_PAGO")]
        public DateTime ? FechaPago { get; set; }

        [Column("TOTAL_OPERACION_SISALRIL_SFS")]
        public decimal OperacionSisalrilSFS { get; set; }

        [Column("ULT_FECHA_ACT")]
        public DateTime ? UltimaFechaActualizacion { get; set; }

        [ForeignKey("UsuarioActualiza"),Column("ULT_USUARIO_ACT")]
        public string UltimoUsuarioActualizo { get; set; }

        [Column("FECHA_REPORTE_PAGO")]
        public DateTime ? FechaReportePago { get; set; }

        [Column("TIPO_REPORTE_BANCO")]
        public string TipoReporteBanco { get; set; }

        [Column("TIPO_EMPRESA")]
        public string TipoEmpresa { get; set; }

        [Column("TIPO_NOMINA")]
        public string TipoNomina { get; set; }

        [ForeignKey("Movimiento"), Column("ID_MOVIMIENTO")]
        public Int32 ? IdMovimiento { get; set; }

        [ForeignKey("Oficio"), Column("ID_OFICIO")]
        public Int32 ? IdOficio { get; set; }

        [Column("FECHA_REGISTRO_PAGO")]
        public DateTime ? FechaRegistroPago { get; set; }

        [Column("CREDITO_SRL")]
        public decimal CreditoSRL { get; set; }

        [Column("ID_USUARIO_CANCELA")]
        public string IdUsuarioCancela { get; set; }

        [Column("ORIGEN")]
        public string Origen { get; set; }

        [Column("FECHA_EFECTIVA_PAGO")]
        public DateTime ? FechaEfectivaPago { get; set; }

        [Column("FECHA_1RA_AUTORIZACION")]
        public DateTime ? Fecha1raAutorizacion { get; set; }

        [Column("FECHA_LIMITE_ACUERDO_PAGO")]
        public DateTime ? FechaLimiteAcuerdoPago { get; set; }

        [Column("MONTO_AJUSTE")]
        public decimal ? MontoAjuste { get; set; }

        [Column("COD_SECTOR")]
        public Int32 ? CodSector { get; set; }

        [Column("STATUS_GENERACION")]
        public string StatusGeneracion { get; set; }

        [Column("ESCALAR_SALARIO")]
        public string EscalarSalario { get; set; }

        public virtual Nomina Nomina { get; set; }         
        public virtual Usuario UsuarioActualiza { get; set; }         
        public virtual Oficio Oficio { get; set;}
        public virtual Movimiento Movimiento { get; set; }
        public virtual EntidadRecaudadora Entidad { get; set; }
        public virtual CategoriaRiesgo Riesgo { get; set; }        
        
    }
}
