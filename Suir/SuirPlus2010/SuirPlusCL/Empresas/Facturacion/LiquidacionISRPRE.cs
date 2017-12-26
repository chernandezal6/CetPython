using System;
using System.Data;
using Oracle.ManagedDataAccess.Client;

namespace SuirPlus.Empresas.Facturacion
{

	public class LiquidacionISRPRE : Factura
	{
		public LiquidacionISRPRE(string Periodo,string RNC, string Tipo)
		{
			this.myConcepto = Factura.eConcepto.ISRP;
			this.myInstitucion = Factura.eInstitucion.DGII;
            this.myPeriodo = Periodo;
            this.myRNC = RNC;
            this.myTipo = Tipo;
            this.CargarDatos();
		}

             
		public static string HabilPagar()
		{
			string Valor;				
			Valor = Factura.getHabilParaPagar(Empresas.Facturacion.Factura.eConcepto.ISRP); 
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

            arrParam[0] = new OracleParameter("p_rnc_o_cedula", OracleDbType.NVarchar2, 16);
			arrParam[0].Value = this.myRNC;

            arrParam[1] = new OracleParameter("p_periodo", OracleDbType.Double);
			arrParam[1].Value = this.myPeriodo;

            arrParam[2] = new OracleParameter("p_tipo_liquidacion", OracleDbType.NVarchar2);
            arrParam[2].Value = this.myTipo;

            arrParam[3] = new OracleParameter("p_io_cursor", OracleDbType.RefCursor);
			arrParam[3].Direction = ParameterDirection.Output;

            arrParam[4] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
			arrParam[4].Direction = ParameterDirection.Output;

            try
            {
                DataTable dt;
                DataSet ds;

                ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, "SFC_FACTURA_PKG.Get_Liquidacion_ISR", arrParam);

                if (ds.Tables.Count > 0)
                {
                    dt = ds.Tables[0];
                    if (dt.Rows.Count > 0)
                    {
                        this.myPeriodo = dt.Rows[0]["Periodo"].ToString();
                        this.myTipoFactura = dt.Rows[0]["tipo_liquidacion"].ToString();
                        this.myTotalAsalariados = Convert.ToInt32(dt.Rows[0]["Total_asalariados"].ToString());
                        this.mySueldosPagadosAgenteRetencion = Convert.ToDecimal(dt.Rows[0]["Sueldos_Pag_Ag_Re"]);
                        this.myTotalSujetoRetencion = Convert.ToDecimal(dt.Rows[0]["pago_total_ret"].ToString());
                        this.myTotalIngresosExtentosISR = Convert.ToDecimal(dt.Rows[0]["Ingresos_exentos"]);
                        this.myRemuneracionesOtrosAgentes = Convert.ToDecimal(dt.Rows[0]["Rem_otros_agentes"].ToString());
                        this.myOtrasRemuneraciones = Convert.ToDecimal(dt.Rows[0]["Otras_remuneraciones"].ToString());
                        this.myTotalPagado = Convert.ToDecimal(dt.Rows[0]["Total_pagado"].ToString());
                        this.myTotalRetencionSS = Convert.ToDecimal(dt.Rows[0]["RETENCION_SS"].ToString());
                       
                                               
                    }
                }		
				
                }
            catch (Exception ex)
                {
                    Exepciones.Log.LogToDB(ex.ToString());
                    throw ex;
                 }     
		}

        public static DataTable CargarDetalle(string rnc,string periodo,string tipo,int pagenum,int pagesize)
        {
            OracleParameter[] arrParam = new OracleParameter[7];

            arrParam[0] = new OracleParameter("p_rnc_o_cedula", OracleDbType.NVarchar2, 16);
            arrParam[0].Value = rnc;

            arrParam[1] = new OracleParameter("p_periodo", OracleDbType.Double);
            arrParam[1].Value = periodo;

            arrParam[2] = new OracleParameter("p_tipo_liquidacion", OracleDbType.NVarchar2);
            arrParam[2].Value = tipo;

            arrParam[3] = new OracleParameter("p_pagenum", OracleDbType.Double);
            arrParam[3].Value = pagenum;

            arrParam[4] = new OracleParameter("p_pagesize", OracleDbType.Double);
            arrParam[4].Value = pagesize;

            arrParam[5] = new OracleParameter("p_io_cursor", OracleDbType.RefCursor);
            arrParam[5].Direction = ParameterDirection.Output;

            arrParam[6] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[6].Direction = ParameterDirection.Output;


            try
            {
                
                DataSet ds;

                ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, "SFC_FACTURA_PKG.Get_Det_Liquidacion_ISR", arrParam);

                if (ds.Tables.Count > 0)
                {
                   
                    return ds.Tables[0];
                   
                }

            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;
            }

            return new DataTable();
        }

		public override String GuardarCambios(string UsuarioResponsable)
		{
			return "";
		}
				
		

	}
}
