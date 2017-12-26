using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SuirPlusEF.Models
{
    [Table("SRE_TRABAJADORES_T")]
    public class Trabajador
    {
        [Key, ForeignKey("Nomina"), Column("ID_REGISTRO_PATRONAL", Order = 0)]
        public Int32 RegistroPatronal { get; set; }

        [Key, ForeignKey("Nomina"), Column("ID_NOMINA", Order = 1)]
        public Int32 IdNomina { get; set; }

        [Key, ForeignKey("Ciudadano"), Column("ID_NSS", Order = 2)]
        public Int32 Nss { get; set; }

        [Column("FECHA_INGRESO")]
        public DateTime? FechaIngreso { get; set; }

        [Column("FECHA_SALIDA")]
        public DateTime? FechaSalida { get; set; }

        [Column("SALARIO_SS")]
        public decimal SalarioSS { get; set; }

        [Column("STATUS")]
        public string Estatus { get; set; }

        [Column("FECHA_INICIO_VACACIONES")]
        public DateTime? FechaInicioVacaciones { get; set; }

        [Column("FECHA_FINAL_VACACIONES")]
        public DateTime? FechaFinalVacaciones { get; set; }

        [Column("FECHA_INICIO_LICENCIA")]
        public DateTime? FechaInicioLicencia { get; set; }

        [Column("FECHA_TERMINO_LICENCIA")]
        public DateTime? FechaTerminoLicencia { get; set; }

        [Column("AFILIADO_IDSS")]
        public string AfiliadoIDSS { get; set; }

        [Column("SALARIO_ISR")]
        public decimal SalarioISR { get; set; }

        [Column("FECHA_ULT_REINTEGRO")]
        public DateTime? FechaUltimoReintegro { get; set; }

        [Column("APORTE_VOLUNTARIO")]
        public decimal AporteVoluntario { get; set; }

        [Column("APORTE_AFILIADOS_T3")]
        public decimal AporteAfiliadosT3 { get; set; }

        [Column("APORTE_EMPLEADOR_T3")]
        public decimal AporteEmpleadorT3 { get; set; }

        [Column("FECHA_REGISTRO")]
        public DateTime? FechaRegistro { get; set; }

        [Column("SALDO_FAVOR_DISPONIBLE")]
        public decimal SaldoFavorDisponible { get; set; }

        [Column("TIPO_CONTRATADO")]
        public string TipoContratado { get; set; }

        [Column("ULT_USUARIO_ACT")]
        public string UltimoUsuarioActualiza { get; set; }

        [Column("ULT_FECHA_ACT")]
        public DateTime? UltimaFechaActualiza { get; set; }

        [Column("SALARIO_INFOTEP")]
        public decimal SalarioInfotep { get; set; }

        [Column("COD_INGRESO")]
        public Int32? CodIngrego { get; set; }

        [Column("ID_OCUPACION")]
        public Int32? IdOcupacion { get; set; }

        [Column("ID_LOCALIDAD")]
        public Int32? IdLocalidad { get; set; }

        [Column("ID_TURNO")]
        public Int32? IdTurno { get; set; }

        [Column("SALARIO_MDT")]
        public decimal? SalarioMDT { get; set; }


        public virtual Nomina Nomina { get; set; }
        public virtual Ciudadano Ciudadano { get; set; }

    }
}
