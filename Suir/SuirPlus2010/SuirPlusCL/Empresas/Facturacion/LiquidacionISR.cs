using System;
using System.Data;
using Oracle.ManagedDataAccess.Client;

namespace SuirPlus.Empresas.Facturacion
{

	public class LiquidacionISR : Factura
	{
		public LiquidacionISR(string NroReferencia)
		{
			this.myConcepto = Factura.eConcepto.ISR;
			this.myInstitucion = Factura.eInstitucion.DGII;
			this.myNroReferencia = NroReferencia;
			this.CargarDatos();
		}

		public LiquidacionISR(Int64 NroAutorizacion)
		{
			this.myConcepto = Factura.eConcepto.ISR;
			this.myInstitucion = Factura.eInstitucion.DGII;
			this.myNroAutorizacion = NroAutorizacion;
			this.CargarDatos();
		}
        
		public static string HabilPagar()
		{
			string Valor;				
			Valor = Factura.getHabilParaPagar(Empresas.Facturacion.Factura.eConcepto.ISR); 
			return Valor;
		}

		#region Propiedades Internas
		
		internal decimal myTotalPagado;		
		//internal decimal myTotalRetencionHonorarios;
		internal decimal myTotalSaldoFavor;
		internal decimal myTotalRetencionSS;
		internal decimal myTotalIngresosExtentosISR;
		internal decimal myTotalImporte;
		internal Int32 myAsalariadosSujetoRetencion;
		internal decimal myCreditoAplicado;
		internal decimal mySueldosPagadosAgenteRetencion;
		internal decimal myImpuestoSobreLaRenta;
		internal decimal myTotalSujetoRetencion;
		internal decimal myRemuneracionesOtrosAgentes;
		internal decimal myOtrasRemuneraciones;
		internal decimal mySaldoCompensado;
		internal decimal mySaldoPorCompensar;

		

		#endregion

		#region Propiedades Publicas
		
		/// <summary>
		/// Total pagado en salario ISR
		/// </summary>
		public decimal TotalPagado
		{
			get{return this.myTotalPagado;}
		}
		public String UsuarioDesAutorizo
		{
			get{return this.myUsuarioDesAutorizo;}
		}
        //public String UsuarioAutorizo
        //{
        //    get{return this.myUsuarioAutorizo;}
        //}
				
		public decimal TotalSaldoFavor
		{
			get{return this.myTotalSaldoFavor;}
		}

		public decimal TotalRetencionSS
		{
			get{return this.myTotalRetencionSS;}
		}

		public decimal TotalIngresosExtentosISR
		{
			get{return this.myTotalIngresosExtentosISR;}
		}

		public decimal CreditoAplicado
		{
			get{return this.myCreditoAplicado;}
		}
		/// <summary>
		/// Total de trabajadores sujetos a retencion.
		/// </summary>
		public Int32 AsalariadosSujetoRetencion
		{
			get{return this.myAsalariadosSujetoRetencion;}
		}

		/// <summary>
		/// Total de salario que son sujetos a retenciones del ISR.
		/// </summary>
		public decimal TotalSujetoRetencion
		{
			get{return this.myTotalSujetoRetencion;}
		}
	
		/// <summary>
		/// Total de remuneraciones de otros empleadores.
		/// </summary>
		public decimal RemuneracionesOtrosAgentes
		{
			get{return this.myRemuneracionesOtrosAgentes;}
		}
		
		/// <summary>
		/// Total de otras remuneraciones.
		/// </summary>
		public decimal OtrasRemuneraciones
		{
			get{return this.myOtrasRemuneraciones;}
		}
		
		/// <summary>
		/// Total ISR compensado en el periodo.
		/// </summary>
		public decimal SaldoCompensado
		{
			get{return this.mySaldoCompensado;}
		}

		/// <summary>
		/// Total saldo a favor en el periodo.
		/// </summary>
		public decimal SaldoPorCompensar
		{
			get{return this.mySaldoPorCompensar;}
		}
		
		/// <summary>
		/// Sueldo pagados por el agente de retencion.
		/// </summary>
		public decimal SueldoPagadosAgenteRetencion
		{
			get {return this.mySueldosPagadosAgenteRetencion;}
		}
		
		/// <summary>
		/// Impuesto Sobre la Renta.
		/// </summary>
		public decimal ImpuestoSobreLaRenta
		{
			get{return this.myImpuestoSobreLaRenta;}
		}

		public String NroAutorizacionFormateado
		{
			get 
			{
				return this.myNroAutorizacion.ToString().PadLeft(10, Convert.ToChar("0"));
				}
		}
		#endregion

//		public override string AutorizarFactura(Int64 NroReferencia)
//		{
//			return AutorizarFactura(NroReferencia, this.myTipo);
//		}

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
                DataSet ds;
                
				ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, "SFC_FACTURA_PKG.Cargar_Datos", arrParam);

                if (ds.Tables.Count > 0)
                {
                    dt = ds.Tables[0];
                    if (dt.Rows.Count > 0)
                    {

                        this.myRNC = dt.Rows[0]["rnc_o_cedula"].ToString();
                        this.myRegistroPatronal = Convert.ToInt32(dt.Rows[0]["id_registro_patronal"].ToString());
                        this.myRazonSocial = dt.Rows[0]["razon_social"].ToString();
                        //this.myNomina = dt.Rows[0]["nomina_des"].ToString();
                        this.myNomina = "Liquidación ISR";
                        this.myTipoFactura = dt.Rows[0]["tipo_factura_des"].ToString();
                        this.myEstatus = dt.Rows[0]["status"].ToString();

                        //this.myCantReferencia = dt.Rows[0]["cant_referencia"].ToString();
                        this.myNroReferencia = dt.Rows[0]["id_referencia_isr"].ToString();
                        this.myFechaAutorizacion = dt.Rows[0]["fecha_autorizacion"].ToString();
                        this.myFechaDesAutorizacion = dt.Rows[0]["fecha_desautorizacion"].ToString();
                        this.myFechaEmision = Convert.ToDateTime(dt.Rows[0]["fecha_emision"]);
                        this.myFechaReportePago = (dt.Rows[0]["fecha_reporte_pago"] != System.DBNull.Value ? Convert.ToDateTime(dt.Rows[0]["fecha_reporte_pago"]) : new DateTime());
                        this.myFechaReporte = dt.Rows[0]["fecha_reporte_pago"].ToString();

                        this.myFechaLimitePago = Convert.ToDateTime(dt.Rows[0]["fecha_limite_pago"]);
                        this.myNroAutorizacion = Convert.ToInt64(dt.Rows[0]["no_autorizacion"].ToString());
                        this.myTotalAsalariados = Convert.ToInt32(dt.Rows[0]["total_trabajadores"].ToString());
                        this.myAsalariadosSujetoRetencion = Convert.ToInt32(dt.Rows[0]["total_trabajadores_retencion"].ToString());
                        this.mySueldosPagadosAgenteRetencion = Convert.ToDecimal(dt.Rows[0]["Total_Salario_Isr"]);
                        this.myRemuneracionesOtrosAgentes = Convert.ToDecimal(dt.Rows[0]["total_remuneracion_otros"].ToString());
                        this.myOtrasRemuneraciones = Convert.ToDecimal(dt.Rows[0]["total_otras_remuneraciones"].ToString());
                        this.myTotalPagado = Convert.ToDecimal(dt.Rows[0]["total_Pagado"].ToString());
                        this.myTotalSujetoRetencion = Convert.ToDecimal(dt.Rows[0]["total_sujeto_retencion"].ToString());
                        this.myImpuestoSobreLaRenta = Convert.ToDecimal(dt.Rows[0]["Total_Isr"]);
                        this.mySaldoCompensado = Convert.ToDecimal(dt.Rows[0]["total_saldo_compensado"].ToString());
                        this.mySaldoPorCompensar = Convert.ToDecimal(dt.Rows[0]["total_por_compensar"].ToString());
                        this.myTotalRecargos = Convert.ToDecimal(dt.Rows[0]["Total_Recargo"]);
                        this.myTotalIntereses = Convert.ToDecimal(dt.Rows[0]["Total_Interes"]);
                        this.myTotalGeneral = Convert.ToDecimal(dt.Rows[0]["total_general_factura"].ToString());
                        this.myUsuarioDesAutorizo = dt.Rows[0]["id_usuario_desautoriza"].ToString();
                        this.myUsuarioAutorizo = dt.Rows[0]["id_usuario_autoriza"].ToString();
                        this.myFechaPago = dt.Rows[0]["fecha_pago"].ToString(); //Convert.ToDateTime(dt.Rows[0]["fecha_pago"]);
                        this.myCreditoAplicado = Convert.ToDecimal(dt.Rows[0]["CREDITO_APLICADO"]);



                        this.myEntidadRecaudadora = dt.Rows[0]["entidad_recaudadora_des"].ToString();
                        //this.myTotalRetencionHonorarios = Convert.ToDecimal(dt.Rows[0]["Total_Retencion_Honorarios"]);
                        this.myTotalSaldoFavor = Convert.ToDecimal(dt.Rows[0]["Total_Saldo_Favor"]);
                        this.myTotalRetencionSS = Convert.ToDecimal(dt.Rows[0]["TOTAL_RETENCION_SS"]);
                        this.myTotalIngresosExtentosISR = Convert.ToDecimal(dt.Rows[0]["total_ingresos_exentos_isr"]);
                        this.myTotalImporte = Convert.ToDecimal(dt.Rows[0]["Total_Importe"]);
                        this.myPeriodo = dt.Rows[0]["periodo_factura"].ToString();
                        this.myOrigenPago = dt.Rows[0]["OrigenPago"].ToString();
                    }
                }		
				
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
				
		public DataTable getEnvios()
		{

			OracleParameter[] arrParam  = new OracleParameter[3];
	
			arrParam[0] = new OracleParameter("p_NoReferencia", OracleDbType.NVarchar2, 16);
			arrParam[0].Value = this.myNroReferencia;
			arrParam[1] = new OracleParameter("p_IOCursor", OracleDbType.RefCursor);
			arrParam[1].Direction = ParameterDirection.Output;
			arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
			arrParam[2].Direction = ParameterDirection.Output;

			String cmdStr= "Sfc_Factura_Pkg.Cons_AnalisisRecaudoRef";

			try
			    {
				    DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);
                    if (ds.Tables.Count > 0)
                    {
                        return ds.Tables[0];
                    }

                    return new DataTable("No Hay Data");

                }

            catch (Exception ex)
                {
                    SuirPlus.Exepciones.Log.LogToDB(ex.ToString());
                    throw ex;
                }
		}

		public DataTable getAut()
		{

			OracleParameter[] arrParam  = new OracleParameter[3];
	
			arrParam[0] = new OracleParameter("p_NoAutorizacion", OracleDbType.NVarchar2, 16);
			arrParam[0].Value = this.NroAutorizacion;
			arrParam[1] = new OracleParameter("p_IOCursor", OracleDbType.RefCursor);
			arrParam[1].Direction = ParameterDirection.Output;
			arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
			arrParam[2].Direction = ParameterDirection.Output;

			String cmdStr= "Sfc_Factura_Pkg.Cons_AnalisisRecaudoAut";

			try
			    {
				    DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);
                    if (ds.Tables.Count > 0)
                    {
                        return ds.Tables[0];
                    }

                    return new DataTable("No Hay Data");
                }

            catch (Exception ex)
                {
                    Exepciones.Log.LogToDB(ex.ToString());
                    throw ex;
                }
		}

		/// <summary>
		/// Metodo utilizado para la consuta de Referencia por Envio de la DGII
		/// </summary>
		/// <param name="IDRecepcion">El No. de Envio que le retorno el archivo enviado</param>
		/// <returns>Un datatable con los resultados arrojados por el No. de envio.</returns>
		/// <remarks>Autor: Ronny Carreras</remarks>
		public static DataTable getReferenciaXEnvio(int IDRecepcion)
		{
			
			OracleParameter[] arrParam = new OracleParameter[3];

			arrParam[0] = new OracleParameter("p_idrecepcion", OracleDbType.Decimal,10);
			arrParam[0].Value = IDRecepcion;	

			arrParam[1] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
			arrParam[1].Direction = ParameterDirection.Output;

			arrParam[2] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
			arrParam[2].Direction = ParameterDirection.Output;
		
			string cmdStr = "Sfc_Factura_Pkg.Liquidacion_NoEnvio";

			try
			    {
				    DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr,arrParam);
                    if (ds.Tables.Count > 0)
                    {
                        return ds.Tables[0];
                    }

                    return new DataTable("No Hay Data");
                }

            catch (Exception ex)
                {
                    Exepciones.Log.LogToDB(ex.ToString());
                    throw ex;
                }
			
            finally
			{
				string myResultado = arrParam[1].Value.ToString();
				if(! Utilitarios.Utils.sacarMensajeDeError(myResultado).Equals("OK"))
				{
					throw new Exception(Utilitarios.Utils.sacarMensajeDeError(myResultado));
				}
			}
			
		}

		/// <summary>
		/// Metodo utilizado para la consulta de Referencia x Envio de la DGII
		/// </summary>
		/// <param name="idReferencia">El ID referencia de la notificacion</param>
		/// <returns>Un datatable con los valores retornado por la consulta.</returns>
		/// <remarks>Autor: Ronny J. Carreras</remarks>
		public static DataTable getEnvioXReferencia(string idReferencia)
		{
			
			OracleParameter[] arrParam = new OracleParameter[3];

			arrParam[0] = new OracleParameter("p_NoReferencia", OracleDbType.NVarchar2, 16);
			arrParam[0].Value = idReferencia;	

			arrParam[1] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
			arrParam[1].Direction = ParameterDirection.Output;

			arrParam[2] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
			arrParam[2].Direction = ParameterDirection.Output;

			string cmdStr = "Sfc_Factura_Pkg.Liquidacion_NoReferencia";

			try
			    {
				    DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr,arrParam);
                    if (ds.Tables.Count > 0)
                    {
                        return ds.Tables[0];
                    }

                    return new DataTable("No Hay Data");
                }

            catch (Exception ex)
                {
                    Exepciones.Log.LogToDB(ex.ToString());
                    throw ex;
                }
			finally
			{
				string myResultado = arrParam[1].Value.ToString();
				if(! Utilitarios.Utils.sacarMensajeDeError(myResultado).Equals("OK"))
				{
					throw new Exception(Utilitarios.Utils.sacarMensajeDeError(myResultado));
				}
			}

		}

	}
}
