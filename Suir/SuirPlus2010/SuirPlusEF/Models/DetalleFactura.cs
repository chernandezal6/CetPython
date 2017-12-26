using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SuirPlusEF.Models
{
    [Table("SFC_DET_FACTURAS_T")]
    public class DetalleFactura
    {
        [Key, ForeignKey("Factura"), Column("ID_REFERENCIA")]
        public string IdReferencia { get; set; }

        [ForeignKey("IdNss"), Column("ID_NSS")]
        public Int32 IdNSS { get; set; }

        [Column("SECUENCIA")]
        public Int32 Secuencia { get; set; }

        [Column("PERIODO_APLICACION")]
        public Int32 ? PeriodoAplicacion { get; set; }

        [Column("SALARIO_SS")]
        public decimal SalarioSS { get; set; }

        [Column("APORTE_VOLUNTARIO")]
        public decimal AporteVoluntario { get; set; }

        [Column("PER_CAPITA_ADICIONAL")]
        public decimal PerCapitaAdicional { get; set; }

        [Column("APORTE_AFILIADOS_SVDS")]
        public decimal AporteAfiliadosSVDS { get; set; }

        [Column("APORTE_EMPLEADOR_SVDS")]
        public decimal AporteEmpleadorSVDS { get; set; }

        [Column("RECARGO_SVDS")]
        public decimal RecargoSVDS { get; set; }

        [Column("INTERES_APO")]
        public decimal ? InteresAPO { get; set; }

        [Column("INTERES_SEGURO_VIDA")]
        public decimal InteresSeguroVida { get; set; }

        [Column("INTERES_AFP")]
        public decimal InteresAFP { get; set; }

        [Column("INTERES_CPE")]
        public decimal InteresCPE { get; set; }

        [Column("INTERES_FSS")]
        public decimal InteresFSS { get; set; }

        [Column("INTERES_OSIPEN")]
        public decimal InteresOSIPEN { get; set; }

        [Column("APORTE_AFILIADOS_SFS")]
        public decimal AporteAfiliadosSFS { get; set; }

        [Column("APORTE_EMPLEADOR_SFS")]
        public decimal AporteEmpleadorSFS { get; set; }

        [Column("RECARGO_SFS")]
        public decimal RecargoSFS { get; set; }

        [Column("INTERES_SFS")]
        public decimal InteresSFS { get; set; }

        [Column("APORTE_SRL")]
        public decimal AporteSRL { get; set; }

        [Column("RECARGO_SRL")]
        public decimal RecargoSRL { get; set; }

        [Column("INTERES_SRL")]
        public decimal InteresSRL { get; set; }

        [Column("APORTE_AFILIADOS_T3")]
        public decimal AporteAfiliadosT3 { get; set; }

        [Column("APORTE_EMPLEADOR_T3")]
        public decimal AporteEmpleadorT3 { get; set; }

        [Column("APORTE_AFILIADOS_IDSS")]
        public decimal AporteAfiliadosIDSS { get; set; }

        [Column("APORTE_EMPLEADOR_IDSS")]
        public decimal AporteEmpleadorIDSS { get; set; }

        [Column("INTERES_IDSS")]
        public decimal InteresIDSS { get; set; }

        [Column("RECARGO_IDSS")]
        public decimal RecargoIDSS { get; set; }

        [Column("CUENTA_PERSONAL")]
        public decimal CuentaPersonal { get; set; }

        [Column("SEGURO_VIDA")]
        public decimal SeguroVida { get; set; }

        [Column("FONDO_SOLIDARIDAD")]
        public decimal FondoSolidaridad { get; set; }

        [Column("COMISION_AFP")]
        public decimal ComisionAFP { get; set; }

        [Column("OPERACION_SIPEN")]
        public decimal OperacionSIPEN { get; set; }

        [Column("CUIDADO_SALUD")]
        public decimal CuidadoSalud { get; set; }

        [Column("ESTANCIAS_INFANTILES")]
        public decimal EstanciasInfantiles { get; set; }

        [Column("SUBSIDIOS_SALUD")]
        public decimal SubsidiosSalud { get; set; }

        [Column("OPERACION_SISALRIL_SRL")]
        public decimal OperacionSisalrilSRL { get; set; }

        [Column("PROPORCION_ARL_SRL")]
        public decimal ProporcionArlSRL { get; set; }

        [Column("OPERACION_SISALRIL_SFS")]
        public decimal OperacionSisalrilSFS { get; set; }

        [Column("MONTO_AJUSTE")]
        public decimal ? MontoAjuste { get; set; }

        [Column("SALARIO_SS_REPORTADO")]
        public decimal ? SalarioSSReportado { get; set; }

        [Column("PER_CAPITA_FONAMAT")]
        public decimal PerCapitaFonamat { get; set; }

        [Column("PER_CAPITA_FONAMAT_BACKUP")]
        public decimal PerCapitaFonamatBackup { get; set; }

        public virtual Ciudadano IdNss { get; set; }
        public virtual Factura Factura { get; set; }
    }
}
