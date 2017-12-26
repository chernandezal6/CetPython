using System;
using System.Data;
using SuirPlus;
using Oracle.ManagedDataAccess.Client;

namespace SuirPlus.Empresas.Facturacion
{
	/// <summary>
	/// 
	/// </summary>
	public class LiquidacionIR17 : Factura
	{
		#region Propiedades Internas
		internal decimal myAlquileres;
		internal decimal myHonorariosServicios;
		internal decimal myPremios;
		internal decimal myTransferenciaTitulos;
		internal decimal myDividendos;
		internal decimal myInteresExterior;
		internal decimal myRemesasExterior;
		internal decimal myProvedorEstado;
		internal decimal myOtrasRentas;
        internal decimal myOtrasRetenciones;
		internal decimal myRetencionesComplementarias;
		internal decimal mySaldosCompensables;
		internal decimal mySaldoFavorAnterior;
		internal decimal myPagosComputablesCuenta;
		internal decimal myTotalOtrasRetenciones;
		internal decimal myImpuesto;
		#endregion

		#region Propiedades Publicas
		public decimal Alquileres
		{
			get {return this.myAlquileres;}
		}
		public decimal HonorariosServicios
		{
			get {return this.myHonorariosServicios;}
		}
		public decimal Premios
		{
			get {return this.myPremios;}
		}
		public decimal TransferenciaTitulos
		{
		get {return this.myTransferenciaTitulos;}
		}
		public decimal Dividendos
		{
		get {return this.myDividendos;}
		}
		public decimal InteresExterior
		{
		get {return this.myInteresExterior;}
}
		public decimal RemesesExterior
		{
		get {return this.myRemesasExterior;}
}
		public decimal ProvedorEstado
		{
		get {return this.myProvedorEstado;}
}
		public decimal OtrasRentas
		{
		get {return this.myOtrasRentas;}
}
        public decimal OtrasRetenciones
        {
            get { return myOtrasRetenciones; }
        }
		public decimal RetencionesComplementarias
		{
		get {return this.myRetencionesComplementarias;}
}
		public decimal SaldosCompensables
		{
		get {return this.mySaldosCompensables;}
}

		public decimal SaldoFavorAnterior
		{
		get {return this.mySaldoFavorAnterior;}
}		
		public decimal PagosComputablesCuenta
		{
		get {return this.myPagosComputablesCuenta;}
}		
		public decimal TotalOtrasRetenciones
		{
		get {return this.myTotalOtrasRetenciones;}
}		
		public decimal Impuesto
		{
		get {return this.myImpuesto;}
}

				#endregion

		public LiquidacionIR17(string NroReferencia)
		{
			this.myConcepto = Factura.eConcepto.IR17;
			this.myInstitucion = Factura.eInstitucion.DGII;
			this.myNroReferencia = NroReferencia;
			this.CargarDatos();
		}

		public LiquidacionIR17(Int64 NroAutorizacion)
		{
			this.myConcepto = Factura.eConcepto.IR17;
			this.myInstitucion = Factura.eInstitucion.DGII;
			this.myNroAutorizacion = NroAutorizacion;
			this.CargarDatos();
		}

		public static string HabilPagar()
		{
			string Valor;				
			Valor = Factura.getHabilParaPagar(Empresas.Facturacion.Factura.eConcepto.IR17); 
			return Valor;
		}

		public override void CargarDatos()
		{
			OracleParameter[] arrParam = new OracleParameter[5];

			arrParam[0] = new OracleParameter("p_NoReferencia", OracleDbType.NVarchar2, 16);
			arrParam[0].Value = this.myNroReferencia;

			arrParam[1] = new OracleParameter("p_NoAutorizacion", OracleDbType.Decimal);
			arrParam[1].Value = this.myNroAutorizacion;

			arrParam[2] = new OracleParameter("p_concepto", OracleDbType.NVarchar2, 4);
			arrParam[2].Value = this.myConcepto;

			arrParam[3] = new OracleParameter("p_IOCursor", OracleDbType.RefCursor);
			arrParam[3].Direction = ParameterDirection.Output;

			arrParam[4] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
			arrParam[4].Direction = ParameterDirection.Output;
            try
			    {
			DataTable dt;
			dt = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, "SFC_FACTURA_PKG.Cargar_Datos", arrParam).Tables[0];
				
			if (dt.Rows.Count > 0)
			{
				//Cargar los Datos de la Clase.
				this.myRNC = dt.Rows[0]["rnc_o_cedula"].ToString();
				this.myRegistroPatronal = Convert.ToInt32(dt.Rows[0]["id_registro_patronal"].ToString());				
				this.myRazonSocial = dt.Rows[0]["razon_social"].ToString();
				this.myNomina = "Liquidación ISR";
				this.myEstatus = dt.Rows[0]["status"].ToString();

				//this.myCantReferencia = dt.Rows[0]["cant_referencia"].ToString();
				this.myNroReferencia = dt.Rows[0]["id_referencia_ir17"].ToString();
				this.myFechaAutorizacion = dt.Rows[0]["fecha_autorizacion"].ToString();
				this.myFechaDesAutorizacion = dt.Rows[0]["fecha_desautorizacion"].ToString();
				this.myFechaEmision = Convert.ToDateTime(dt.Rows[0]["fecha_emision"]);
				this.myFechaReportePago = (dt.Rows[0]["fecha_reporte_pago"] != System.DBNull.Value ? Convert.ToDateTime(dt.Rows[0]["fecha_reporte_pago"]):new DateTime());
				this.myFechaReporte = dt.Rows[0]["fecha_reporte_pago"].ToString();
				this.myNroAutorizacion = Convert.ToInt32(dt.Rows[0]["no_autorizacion"].ToString());	
				this.myTotalGeneral = Convert.ToDecimal(dt.Rows[0]["liquidacion"].ToString());		
				this.myUsuarioDesAutorizo  = dt.Rows[0]["id_usuario_desautoriza"].ToString();
				this.myUsuarioAutorizo = dt.Rows[0]["id_usuario_autoriza"].ToString(); 
				this.myFechaPago  = dt.Rows[0]["fecha_pago"].ToString();
				this.myEntidadRecaudadora = dt.Rows[0]["entidad_recaudadora_des"].ToString();
				this.myPeriodo = dt.Rows[0]["periodo_liquidacion"].ToString();	
				this.myFechaLimitePago = Convert.ToDateTime(dt.Rows[0]["fecha_limite_pago"]);
		
				//this.myIDEntidadRecaudadora = Convert.ToInt32(dt.Rows[0]["id_entidad_recaudadora"]);
				this.myAlquileres = Convert.ToDecimal(dt.Rows[0]["alquileres"]);
				this.myHonorariosServicios = Convert.ToDecimal(dt.Rows[0]["honorarios_servicios"]);
				this.myPremios= Convert.ToDecimal(dt.Rows[0]["premios"]);
				this.myTransferenciaTitulos= Convert.ToDecimal(dt.Rows[0]["transferencia_titulos"]);
				this.myDividendos= Convert.ToDecimal(dt.Rows[0]["dividendos"]);
				this.myInteresExterior= Convert.ToDecimal(dt.Rows[0]["interes_exterior"]);
				this.myRemesasExterior= Convert.ToDecimal(dt.Rows[0]["remesas_exterior"]);
				this.myProvedorEstado= Convert.ToDecimal(dt.Rows[0]["provedor_estado"]);
				this.myOtrasRentas= Convert.ToDecimal(dt.Rows[0]["otras_rentas"]);
                this.myOtrasRetenciones = Convert.ToDecimal(dt.Rows[0]["Otras_Retenciones"]);
				this.myRetencionesComplementarias= Convert.ToDecimal(dt.Rows[0]["ret_complementarias"]);
				this.mySaldosCompensables= Convert.ToDecimal(dt.Rows[0]["saldos_compensables"]);
				this.mySaldoFavorAnterior= Convert.ToDecimal(dt.Rows[0]["saldo_favor_anterior"]);
				this.myTotalRecargos = Convert.ToDecimal(dt.Rows[0]["recargo"]);
				this.myTotalIntereses = Convert.ToDecimal(dt.Rows[0]["intereses"]);
				this.myFechaCancelacion = dt.Rows[0]["fecha_cancela"].ToString();
				this.myTipoReporteBanco = dt.Rows[0]["tipo_reporte_banco"].ToString();
				this.myPagosComputablesCuenta = Convert.ToDecimal(dt.Rows[0]["pagos_computables_cuenta"]);
				this.myTotalOtrasRetenciones = Convert.ToDecimal(dt.Rows[0]["total_otras_retenciones"]);
				this.myImpuesto = Convert.ToDecimal(dt.Rows[0]["impuesto"]);
				this.myOrigenPago = dt.Rows[0]["OrigenPago"].ToString();
			
			}

				dt.Dispose();
                }
            catch (Exception ex)
                {
                    Exepciones.Log.LogToDB(ex.ToString());
                    throw ex;
                 }       
        }

		public override String GuardarCambios(string UsuarioResponsable)
		{
			return "";
		}
		
		
	}
}
