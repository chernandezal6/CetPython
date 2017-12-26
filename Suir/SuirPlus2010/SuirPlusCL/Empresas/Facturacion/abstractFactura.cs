using System;
using System.Data;
using SuirPlus.DataBase;
using SuirPlus.Utilitarios;
using System.Collections;
using System.Collections.Generic;
using Oracle.ManagedDataAccess.Client;

namespace SuirPlus.Empresas.Facturacion
{
	/// <summary>
	/// Clase abstracta de la cual deben heredar las Facturas.
	/// </summary>
	public abstract class Factura : SuirPlus.FrameWork.Objetos
	{
		/// <summary>
		/// Enumerador para distiguir las facturas.
		/// </summary>
		public enum eInstitucion{Tesoreria, DGII, INFOTEP, MDT}
		
        public enum eConcepto{SDSS, ISR, IR17, DGII, INF, MDT,ISRP}

		#region Propiedades Internas
        internal string myIdPlanilla;
		internal string myCantReferencia;
		internal string myNroReferencia;
		internal string myTipo;
		internal Int64 myNroAutorizacion;
		internal Int32 myIDEntidadRecaudadora;
		internal string myEntidadRecaudadora;

		internal decimal myTotalGeneral;
		internal decimal myTotalRecargos;
		internal decimal myTotalIntereses;
		internal Int32 myTotalAsalariados;
        internal Int32 myTotalLocalidades;
		internal decimal myTotalTrabajadoresRetencion;

		internal string myPeriodo;
		internal string myRNC;
		internal Int32 myRegistroPatronal;
		internal string myRazonSocial;
		internal string myNombreComercial;
		internal string myIDNomina;
		internal string myNomina;
		internal string myIDTipoFactura;
		internal string myTipoFactura;
		internal string myEstatus;
		internal string myOrigenPago;
		
		internal eInstitucion myInstitucion;
		internal eConcepto myConcepto;
		internal string myFechaAutorizacion;
		internal string myUsuarioDesAutorizo;
		internal string myUsuarioAutorizo;
		internal string myEntidadDesautorizo;
		internal string myFechaDesAutorizacion;
		internal DateTime myFechaEmision;
		internal string myFechaReporte;
		internal DateTime myFechaReportePago;
		internal DateTime myFechaLimitePago;
		internal string myFechaPago;
		internal string myIDError;
		internal string myIDOficio;
		internal string myMotivoDesc;
		internal string myFechaCancelacion;
		internal string myTipoReporteBanco;

		internal string myTipoNomina;
        internal string myStatusGeneracion;

        internal string myObservacion;
		//internal string myImpuestoSobreLaRenta;

		#endregion

		#region Propiedades Publicas


        /// <summary>
        /// ID de Planilla de MDT para la factura
        /// </summary>
        /// 
        public string IdPlanilla
        {
            get { return this.myIdPlanilla; }
            
        }
        /// <summary>
        /// Numero de Referencia de la factura
        /// </summary>
        /// 
		public string CantReferencia
		{
			get {return this.myCantReferencia;}
		}

		public string NroReferencia
		{
			get {return this.myNroReferencia;}
		}
		/// <summary>
		/// Numero de Referencia con el formato que utilizan los bancos
		/// </summary>
		public string NroReferenciaFormateado
		{
			get 
			{
				string nroRef = this.myNroReferencia.ToString();
				nroRef = nroRef.Substring(0, 4) + "-" + nroRef.Substring(4, 4) + "-" + nroRef.Substring(8, 4) + "-" + nroRef.Substring(12, 4);
				return nroRef;
			}
		}
		/// <summary>
		/// Numero de autorizacion de la factura
		/// </summary>
		public Int64 NroAutorizacion
		{
			get {return this.myNroAutorizacion;}
		}
		/// <summary>
		/// Codigo de la entidad recaudadora donde fue pagada la factura.
		/// </summary>
		public Int32 IDEntidadRecaudadora
		{
			get {return this.myIDEntidadRecaudadora;}
		}
		
		/// <summary>
		/// Entidad recaudadora donde fue pagada la factura.
		/// </summary>
		public string EntidadRecaudadora
		{
			get {return this.myEntidadRecaudadora;}
		}
		/// <summary>
		/// Registro Patronal de la Empresa
		/// </summary>
		public int RegistroPatronal
		{
            get {return this.myRegistroPatronal;}
		}
		
		/// <summary>
		/// Total general de la factura. Esto incluye los recargos e intereses.
		/// </summary>
		public decimal TotalGeneral
		{
			get {return this.myTotalGeneral;}
		}
		public string TotalGeneralFormateadoC
		{
			get {return "RD$" + System.String.Format("{0:n}", this.myTotalGeneral);}
		}
		/// <summary>
		/// Total de todos los renglones de Recargo.
		/// </summary>
		public decimal TotalRecargos
		{
			get {return this.myTotalRecargos;}
		}
		/// <summary>
		/// Total de todos los renglones de Intereses.
		/// </summary>
		public decimal TotalIntereses
		{
			get {return this.myTotalIntereses;}
		}
		
		/// <summary>
		/// Total de los trabajadores de la nómina.
		/// </summary>
		public Int32 TotalAsalariados
		{
			get{return this.myTotalAsalariados;}
		}

        public Int32 TotalLocalidades
        {
            get { return this.myTotalLocalidades; }
        }
		/// <summary>
		/// Total de las rentenciones de los trabajadores de la nómina.
		/// </summary>
		public decimal TotalTrabajadoresRetencion
		{
			get{return this.myTotalTrabajadoresRetencion;}
		}

		/// <summary>
		/// Periodo de la Factura
		/// </summary>
		public string Periodo
		{
			get {return this.myPeriodo;}
		}
		/// <summary>
		/// Periodo en el formato MM-AAAA
		/// </summary>
		public string PeriodoFormateado
		{
			get 
			{
				if(this.Periodo != null)
				{
					return this.myPeriodo.Substring(4,2) + "-" + this.myPeriodo.Substring(0,4);
				}
				else
				{
					return null;
				}
			}
		}
		/// <summary>
		/// RNC de la Empresa
		/// </summary>
		public string RNC
		{
			get {return this.myRNC;}
		}
		public string Tipo
		{
			get {return this.myTipo;}
		}


		public string IdOficio
		{
			get {return this.myIDOficio;}
		}
		public string Motivo
		{
			get {return this.myMotivoDesc;}
		}
		/// <summary>
		/// Razon Social de la Empresa
		/// </summary>
		public string RazonSocial
		{
			get {return this.myRazonSocial;}
		}
		/// <summary>
		/// Nombre Comercial de la Empresa
		/// </summary>
		public string NombreComercial
		{
			get {return this.myNombreComercial;}
		}
		/// <summary>
		/// Codigo de la Nomina
		/// </summary>
		public string IDNomina
		{
			get {return this.myIDNomina;}
		}
		/// <summary>
		/// Descripcion de la Nomina
		/// </summary>
		public string Nomina
		{
			get {return this.myNomina;}
		}

		/// <summary>
		/// ID Tipo factura
		/// </summary>
		public string IDTipoFacura
		{
			get{return this.myIDTipoFactura;}
		}

		/// <summary>
		/// Tipo de Factura/Liquidacion
		/// </summary>
		public string TipoFactura
		{
			get { return this.myTipoFactura;}
		}
		
		public string Estatus
		{
			get{return this.myEstatus;}
		}

		/// <summary>
		/// Utilizado para vrificar el origen de pago de la factura.
		/// </summary>
		public string OrigenPago
		{
			get {return this.myOrigenPago;}
		}

		public string UsuarioAutorizo
		{
			get{return this.myUsuarioAutorizo;}
		}
		public string UsuarioDesautorizo
		{
			get{return this.myUsuarioDesAutorizo;}
		}
		/// <summary>
		/// Enumerador que indica nos dice el Concepto (SDSS, ISR, IR17)
		/// </summary>
		public eConcepto Concepto
		{
			get {return this.Concepto;}
		}
		/// <summary>
		/// Enumerador que indica si es de la DGII o de la TSS
		/// </summary>
		public eInstitucion Institucion
		{
			get {return this.myInstitucion;}
		}
		/// <summary>
		/// Fecha en que fue autorizada la factura
		/// </summary>
		public string FechaAutorizacion
		{
			get {return this.myFechaAutorizacion;}
		}
	
		/// <summary>
		/// Fecha en que fue desautorizada la factura
		/// </summary>
		public string FechaDesAutorizacion
		{
			get {return this.myFechaDesAutorizacion;}
		}

		public string FechaReporte
		{
			get {return this.myFechaReporte;}
		}
		public string FechaPago
		{
			get {return this.myFechaPago;}
		}
		
		/// <summary>
		/// Fecha de emision de la factura.
		/// </summary>
		public DateTime FechaEmision
		{
			get{return this.myFechaEmision;}
		}

		public DateTime FechaReportePago
		{
			get{return this.myFechaReportePago;}
		}

		/// <summary>
		/// Fecha limite de pago de la factura.
		/// </summary>
		public DateTime FechaLimitePago
		{
			get{return this.myFechaLimitePago;}
		}
		
		/// <summary>
		/// El tipo de nomina al cual pertenece la factura
		/// </summary>
		public string TipoNomina
		{
			get {return this.myTipoNomina;}
		}

        public string StatusGeneracion
        {
            get { return myStatusGeneracion; }
        }

        public string Observacion
        {
            get { return this.myObservacion; }
        }

		#endregion
		
		internal static string getHabilParaPagar(eConcepto Concepto)
		{
			OracleParameter[] arrParam  = new OracleParameter[2];

			arrParam[0] = new OracleParameter("p_concepto", OracleDbType.NVarchar2, 4);
			arrParam[0].Value = Concepto;
			arrParam[1] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
			arrParam[1].Direction = ParameterDirection.Output;

			String cmdStr= "SFC_FACTURA_PKG.Esta_En_FechaPago";

			try
			{
			
				DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);
				return (arrParam[1].Value.ToString());
			}
			catch(Exception ex)
			{
				throw ex;
			}
		}
        
		public static bool isReferenciaAutorizada(eConcepto Concepto, string NroReferencia)
		{
			OracleParameter[] arrParam  = new OracleParameter[3];

			arrParam[0] = new OracleParameter("p_concepto", OracleDbType.NVarchar2,5);
			arrParam[0].Value= Concepto;	

			arrParam[1]= new OracleParameter("p_NoReferencia", OracleDbType.NVarchar2,16);
			arrParam[1].Value=NroReferencia;

			arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 100);
			arrParam[2].Direction = ParameterDirection.Output;

			String cmdStr= "SFC_FACTURA_PKG.isReferenciaAutorizada";
			string result = string.Empty;

			try
			{
				OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure,cmdStr,arrParam);	
				result = arrParam[2].Value.ToString();

				if (result == "0")
				{
					return true;
				}
				else
				{
					return false;
				}
			}
			catch(Exception ex)
			{
				throw ex;
			}
		}
        
		internal string AutorizarFactura(eConcepto Concepto, string UsuarioBanco)
		{
			OracleParameter[] orParam = new OracleParameter[5];
			
			orParam[0] = new OracleParameter("p_NoReferencia", OracleDbType.NVarchar2, 22);
			orParam[0].Value = this.myNroReferencia;

			orParam[1] = new OracleParameter("p_idusuario",OracleDbType.NVarchar2,20);
			orParam[1].Value = UsuarioBanco;

			orParam[2] = new OracleParameter("p_concepto",OracleDbType.NVarchar2,4);
			orParam[2].Value = Concepto;

			orParam[3] = new OracleParameter("p_nro_aut",OracleDbType.NVarchar2,50);
			orParam[3].Direction = ParameterDirection.Output;

			orParam[4] = new OracleParameter("p_ResultNumber", OracleDbType.NVarchar2, 200);
			orParam[4].Direction = ParameterDirection.Output;

			try
			{
				OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure,"SFC_FACTURA_PKG.Aut_Referencia",orParam);
				return orParam[4].Value.ToString();
			}

			catch(Exception ex)
			{
				return ex.ToString();
			}
		}
        
		public string AutorizarFactura(string UsuarioBanco)
		{
				return this.AutorizarFactura(this.myConcepto, UsuarioBanco);
		}
				
        public static bool isReferenciaValida(string NroReferencia, string RNC)
		{
			OracleParameter[] arrParam  = new OracleParameter[4];

			arrParam[0] = new OracleParameter("p_referencia", OracleDbType.NVarchar2,16);
			arrParam[0].Value = NroReferencia;
			
			arrParam[1]= new OracleParameter("p_rnc", OracleDbType.NVarchar2,11);
			arrParam[1].Value=RNC;

			arrParam[2] = new OracleParameter("p_concepto", OracleDbType.NVarchar2,5);
			arrParam[2].Value= eConcepto.SDSS.ToString();		

			arrParam[3] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 100);
			arrParam[3].Direction = ParameterDirection.Output;

			String cmdStr= "SFC_FACTURA_PKG.isReferenciaValida";
			string result = string.Empty;

			try
			{
				OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure,cmdStr,arrParam);	
				result = arrParam[3].Value.ToString();

				if (result == "1")
				{
					return true;
				}
				else
				{
					return false;
				}
			}
			catch(Exception ex)
			{
				throw ex;
			}
		}
        
        internal string DesAutorizarFactura(eConcepto Concepto, string UsuarioBanco, DateTime FechaCaja)
		{
			OracleParameter[] orParam = new OracleParameter[5];
			
			orParam[0] = new OracleParameter("p_NoReferencia", OracleDbType.NVarchar2, 22);
			orParam[0].Value = this.myNroReferencia;

			orParam[1] = new OracleParameter("p_idusuario",OracleDbType.NVarchar2,20);
			orParam[1].Value = UsuarioBanco;

			orParam[2] = new OracleParameter("p_concepto",OracleDbType.NVarchar2,4);
			orParam[2].Value = Concepto;

			orParam[3] = new OracleParameter("p_fecha_caja", OracleDbType.Date ,40);
			orParam[3].Value = FechaCaja;

			orParam[4] = new OracleParameter("p_ResultNumber", OracleDbType.NVarchar2, 200);
			orParam[4].Direction = ParameterDirection.Output;

			try
			{
				OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure,"SFC_FACTURA_PKG.Cancelar_Autorizacion", orParam);
				return orParam[4].Value.ToString();
			}

			catch(Exception ex)
			{
				return ex.ToString();
			}
		}
        
		public string DesAutorizarFactura(string UsuarioBanco, DateTime FechaCaja)
		{
			return this.DesAutorizarFactura(this.myConcepto, UsuarioBanco, FechaCaja);
		}

        public static string ValidarReferenciaAntigua(string Noreferencia)
        {
            OracleParameter[] orParam = new OracleParameter[2];

            orParam[0] = new OracleParameter("p_NoReferencia", OracleDbType.NVarchar2, 22);
            orParam[0].Value = Noreferencia;

            orParam[1] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            orParam[1].Direction = ParameterDirection.Output;

            try
            {
                OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, "SFC_FACTURA_PKG.ValidarReferenciaAntigua", orParam);
                return orParam[1].Value.ToString();
            }

            catch (Exception ex)
            {
                return ex.ToString();
            }
        }

        /// <summary>
        /// Metodo utilizado en la consulta de Notificaciones por RNC, para mostrar los totales de facturas de un empleador.
        /// </summary>
        /// <param name="concepto">Tipo de Notificacion: SDSS, IR13, IR17, </param>
        /// <param name="rncCedula">RNC o Cedula que identifica al empleador.</param>
        /// <param name="codigoNomina">Codigo de la nomina para las notificaciones del SDSS</param>
        /// <param name="status">Estatus de las notificaciones.</param>
        /// <returns>Un datatable con los totales de los parametros establecidos.</returns>
        /// <remarks>Create By Ronny Carreras at 11/07/2007</remarks>
        public static List<string> getTotalesNotificacion(eConcepto concepto, string rncCedula, Int16 codigoNomina, string status)
        {
            string resultado = "0";
            String cmdStr = "SFC_FACTURA_PKG.EncabezadoConsultaRNC";

            OracleParameter[] arrParam;
            arrParam = new OracleParameter[12];

            arrParam[0] = new OracleParameter("p_RNCoCedula", OracleDbType.NVarchar2, 11);
            arrParam[0].Value = rncCedula;

            arrParam[1] = new OracleParameter("p_concepto", OracleDbType.NVarchar2, 4);
            arrParam[1].Value = concepto.ToString();

            arrParam[2] = new OracleParameter("p_CodigoNomina", OracleDbType.NVarchar2, 10);
            arrParam[2].Value = codigoNomina;

            arrParam[3] = new OracleParameter("p_status", OracleDbType.NVarchar2, 5);
            arrParam[3].Value = status;

            arrParam[4] = new OracleParameter("p_Razon_Social", OracleDbType.NVarchar2, 150);
            arrParam[4].Direction = ParameterDirection.Output;

            arrParam[5] = new OracleParameter("p_Nombre_Comercial", OracleDbType.NVarchar2, 150);
            arrParam[5].Direction = ParameterDirection.Output;

            arrParam[6] = new OracleParameter("p_Total_de_Referencia", OracleDbType.NVarchar2, 25);
            arrParam[6].Direction = ParameterDirection.Output;

            arrParam[7] = new OracleParameter("p_Total_Importe", OracleDbType.NVarchar2, 25);
            arrParam[7].Direction = ParameterDirection.Output;

            arrParam[8] = new OracleParameter("p_Total_Recargo", OracleDbType.NVarchar2, 25);
            arrParam[8].Direction = ParameterDirection.Output;

            arrParam[9] = new OracleParameter("p_Total_Intereses", OracleDbType.NVarchar2, 25);
            arrParam[9].Direction = ParameterDirection.Output;

            arrParam[10] = new OracleParameter("p_Total_General", OracleDbType.NVarchar2, 25);
            arrParam[10].Direction = ParameterDirection.Output;

            arrParam[11] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 500);
            arrParam[11].Direction = ParameterDirection.Output;

            List<string> resumen = new List<string>();

            try
            {
                OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                resultado = arrParam[11].Value.ToString();


                if (resultado == "0")
                {
                   // if (!arrParam[4].IsNullable)
                    if (arrParam[4].Value.ToString() != string.Empty)
                    {
                        resumen.Add(arrParam[4].Value.ToString());
                        resumen.Add(arrParam[5].Value.ToString());
                        resumen.Add(arrParam[6].Value.ToString());
                        resumen.Add(arrParam[7].Value.ToString());
                        resumen.Add(arrParam[8].Value.ToString());
                        resumen.Add(arrParam[9].Value.ToString());
                        resumen.Add(arrParam[10].Value.ToString());
                    }
                }
                else
                {
                    string res = string.Empty;
                    res = resultado.Split('|')[1].ToString();
                    throw new Exception(res);
                }

            }
            catch (Exception ex)
            {
                throw ex;
            }

            return resumen;

        }
        
        /// <summary>
        /// 
        /// </summary>
        /// <param name="Concepto"></param>
        /// <param name="RNCoCedula"></param>
        /// <param name="CodigoNomina"></param>
        /// <param name="Status"></param>
        /// <param name="pageSize"></param>
        /// <param name="pageNum"></param>
        /// <returns></returns>
        public static DataTable getConsultaNotificaionesPorRNC(eConcepto Concepto, string RNCoCedula,int CodigoNomina, string Status,Int16 pageSize, int pageNum)
        {

            OracleParameter[] arrParam;
            String cmdStr = "SFC_FACTURA_PKG.ConsPage_Facturas";
            string result = null;
            DataTable dt = new DataTable();

            //Definimos nuestro arreglo de parametros.
            arrParam = new OracleParameter[8];

            arrParam[0] = new OracleParameter("p_RNCoCedula", OracleDbType.NVarchar2, 11);
            arrParam[0].Value = RNCoCedula;

            arrParam[1] = new OracleParameter("p_CodigoNomina", OracleDbType.Int32);
            arrParam[1].Value = CodigoNomina;

            arrParam[2] = new OracleParameter("p_Status", OracleDbType.NVarchar2, 20);
            arrParam[2].Value = Status;

            arrParam[3] = new OracleParameter("p_concepto", OracleDbType.NVarchar2, 4);
            arrParam[3].Value = Concepto;

            arrParam[4] = new OracleParameter("p_pagenum", OracleDbType.Int32);
            arrParam[4].Value = pageNum;

            arrParam[5] = new OracleParameter("p_pagesize", OracleDbType.Int32);
            arrParam[5].Value = pageSize;

            arrParam[6] = new OracleParameter("p_IOCursor", OracleDbType.RefCursor);
            arrParam[6].Direction = ParameterDirection.Output;

            arrParam[7] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[7].Direction = ParameterDirection.Output;

            try
                {
                    //Ejecuamos el commando.
                    DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);
                    
                    result = arrParam[7].Value.ToString();

                    //Si el resultado es diferente de 0, entonces agregamos el error en el datatable para retornarlo.
                    //de los contratario asignamos el datatable que viene en el dataset.
                    if (result != "0")
                    {
                        Utilitarios.Utils.agregarMensajeError(result, ref dt);
                    }
                    else
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
        
		public static DataTable getNotificaciones(eConcepto Concepto, string RNCoCedula, string CodigoNomina, string Status)
		{
			OracleParameter[] arrParam;

			arrParam  = new OracleParameter[6];

			arrParam[0] = new OracleParameter("p_RNCoCedula", OracleDbType.NVarchar2, 11);
			arrParam[0].Value = RNCoCedula;

			arrParam[1] = new OracleParameter("p_CodigoNomina", OracleDbType.Double);
			arrParam[1].Value = CodigoNomina;

			arrParam[2] = new OracleParameter("p_Status", OracleDbType.NVarchar2, 20);
			arrParam[2].Value = Status;

			arrParam[3] = new OracleParameter("p_concepto", OracleDbType.NVarchar2, 4);
			arrParam[3].Value = Concepto;

			arrParam[4] = new OracleParameter("p_IOCursor", OracleDbType.RefCursor);
			arrParam[4].Direction = ParameterDirection.Output;

			arrParam[5] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
			arrParam[5].Direction = ParameterDirection.Output;

			String cmdStr= "SFC_FACTURA_PKG.Cons_Facturas";

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

     	public static DataTable getNotificaciones(eConcepto Concepto, Int32 RegistroPatronal, string UsuarioRepresentante, string Status)
		{
			OracleParameter[] arrParam;

			arrParam  = new OracleParameter[6];

			arrParam[0] = new OracleParameter("p_RegistroPatronal", OracleDbType.Decimal);
			arrParam[0].Value = RegistroPatronal;

			arrParam[1] = new OracleParameter("p_idusuario", OracleDbType.NVarchar2, 36);
			arrParam[1].Value = UsuarioRepresentante;

			arrParam[2] = new OracleParameter("p_concepto", OracleDbType.NVarchar2, 4);
			arrParam[2].Value = Concepto;

			arrParam[3] = new OracleParameter("p_status", OracleDbType.NVarchar2, 4);
			arrParam[3].Value = Status;

			arrParam[4] = new OracleParameter("p_IOCursor", OracleDbType.RefCursor);
			arrParam[4].Direction = ParameterDirection.Output;

			arrParam[5] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
			arrParam[5].Direction = ParameterDirection.Output;

            String cmdStr = "SFC_FACTURA_PKG.Cons_Facturas";

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

        public static DataTable getNotificacionesPendientePago(eConcepto Concepto, string RNCoCedula)
        {
            OracleParameter[] arrParam;

            arrParam = new OracleParameter[5];

            arrParam[0] = new OracleParameter("p_RNCoCedula", OracleDbType.NVarchar2, 11);
            arrParam[0].Value = RNCoCedula;

            arrParam[1] = new OracleParameter("p_concepto", OracleDbType.Char);
            arrParam[1].Value = Concepto.ToString();

            arrParam[2] = new OracleParameter("p_algo", OracleDbType.NVarchar2, 1);
            arrParam[2].Value = "A";

            arrParam[3] = new OracleParameter("p_IOCursor", OracleDbType.RefCursor);
            arrParam[3].Direction = ParameterDirection.Output;

            arrParam[4] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[4].Direction = ParameterDirection.Output;

            String cmdStr = "SFC_FACTURA_PKG.Cons_Facturas";
            String Resultado = "";
                try
             {
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);

                Resultado = arrParam[4].Value.ToString();

                if (Resultado != "0")
                {
                    DataTable dt = new DataTable();
                    Utilitarios.Utils.agregarMensajeError(Resultado, ref dt);

                    if (ds.Tables.Count > 0)
                    {
                        return ds.Tables[0];
                    }

                    return new DataTable("No Hay Data");
                }

                return ds.Tables[0];
             }
                
                catch (Exception ex)
                {
                    Exepciones.Log.LogToDB(ex.ToString());

                    throw ex;
                }
        }
        public static DataTable ConsultarPorReferenciaISR(string nroReferencia, string usuario, string pass)
        {
            OracleParameter[] arrParam;

            arrParam = new OracleParameter[5];

            arrParam[0] = new OracleParameter("p_NoReferencia", OracleDbType.NVarchar2,22);
            arrParam[0].Value = nroReferencia.ToString();

            arrParam[1] = new OracleParameter("p_idusuario", OracleDbType.NVarchar2);
            arrParam[1].Value = usuario.ToString();

            arrParam[2] = new OracleParameter("p_class", OracleDbType.NVarchar2);
            arrParam[2].Value = pass.ToString();

            arrParam[3] = new OracleParameter("p_IOCursor", OracleDbType.RefCursor);
            arrParam[3].Direction = ParameterDirection.Output;

            arrParam[4] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[4].Direction = ParameterDirection.Output;

            String cmdStr = "SFC_FACTURA_PKG.ConsultarPorReferenciaISR";
            String Resultado = "";
            try
            {
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);

                Resultado = arrParam[4].Value.ToString();

                if (Resultado != "0")
                {
                    DataTable dt = new DataTable(Resultado);
                    DataColumn myColumn;
                    DataRow myRow;

                    myColumn = new DataColumn("Mensaje");
                    dt.Columns.Add(myColumn);

                    myRow = dt.NewRow();
                    myRow["Mensaje"] = Resultado;
                    dt.Rows.Add(myRow);
                    dt.TableName = "Error";

                    return dt;
                }

                return ds.Tables[0];
            }

            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());

                throw ex;
            }
        }
        public static string AutorizarReferencia(string nroReferencia, string usuario, string pass, out string nroAutorizacion)
        {
            OracleParameter[] arrParam;

            arrParam = new OracleParameter[5];

            arrParam[0] = new OracleParameter("p_NoReferencia", OracleDbType.NVarchar2,22);
            arrParam[0].Value = nroReferencia.ToString();

            arrParam[1] = new OracleParameter("p_idusuario", OracleDbType.NVarchar2);
            arrParam[1].Value = usuario.ToString();

            arrParam[2] = new OracleParameter("p_class", OracleDbType.NVarchar2);
            arrParam[2].Value = pass.ToString();

            arrParam[3] = new OracleParameter("p_nro_autorizacion", OracleDbType.Decimal);
            arrParam[3].Direction = ParameterDirection.Output;

            arrParam[4] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[4].Direction = ParameterDirection.Output;

            try
            {
                OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, "SFC_FACTURA_PKG.AutorizarReferencia", arrParam);
                nroAutorizacion = arrParam[3].Value.ToString();
                return arrParam[4].Value.ToString();
            }

            catch (Exception ex)
            {
                nroAutorizacion = "0";
                return ex.ToString();
            }
        }
        public static DataTable getNotificacionesPendientePago(eConcepto Concepto, string RNCoCedula, string CodigoNomina)
		{
			return getNotificacionesPendientePago(Concepto, RNCoCedula, "", CodigoNomina);
		}
		
        public static DataTable getNotificacionesPendientePago(eConcepto Concepto, string RNCoCedula, string NroReferencia, string CodigoNomina)
		{
			OracleParameter[] arrParam;

			if (NroReferencia != "")
			{
				arrParam  = new OracleParameter[4];

				arrParam[0] = new OracleParameter("p_concepto", OracleDbType.NVarchar2, 4);
				arrParam[0].Value = Concepto;

                arrParam[1] = new OracleParameter("p_NoReferencia", OracleDbType.NVarchar2, 16);
                arrParam[1].Value = NroReferencia;
                
                arrParam[2] = new OracleParameter("p_IOCursor", OracleDbType.RefCursor);
				arrParam[2].Direction = ParameterDirection.Output;

				arrParam[3] = new OracleParameter("p_ResultNumber", OracleDbType.NVarchar2, 200);
				arrParam[3].Direction = ParameterDirection.Output;
			}
			else
			{
				arrParam  = new OracleParameter[5];

				arrParam[0] = new OracleParameter("p_RNCoCedula", OracleDbType.NVarchar2, 11);
				arrParam[0].Value = RNCoCedula;

				arrParam[1] = new OracleParameter("p_CodigoNomina", OracleDbType.Decimal);
				arrParam[1].Value = CodigoNomina;

				arrParam[2] = new OracleParameter("p_concepto", OracleDbType.NVarchar2, 4);
				arrParam[2].Value = Concepto;

				arrParam[3] = new OracleParameter("p_IOCursor", OracleDbType.RefCursor);
				arrParam[3].Direction = ParameterDirection.Output;

				arrParam[4] = new OracleParameter("p_ResultNumber", OracleDbType.NVarchar2, 200);
				arrParam[4].Direction = ParameterDirection.Output;
			}


			String cmdStr= "SFC_FACTURA_PKG.Cons_Facturas";

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

        public static DataTable getReferenciasDisponiblesParaPago(eConcepto Concepto, string RNCoCedula, string CodigoNomina,SuirPlus.Legal.eTiposAcuerdos tipo, ref string RazonSocial, ref string NombreComercial)
        {
            OracleParameter[] arrParam;

            arrParam = new OracleParameter[8];

            arrParam[0] = new OracleParameter("p_rnc_o_cedula", OracleDbType.NVarchar2, 11);
            arrParam[0].Value = RNCoCedula;

            arrParam[1] = new OracleParameter("p_concepto", OracleDbType.NVarchar2, 4);
            arrParam[1].Value = Concepto;

            arrParam[2] = new OracleParameter("p_id_nomina", OracleDbType.Decimal);
            arrParam[2].Value = CodigoNomina;

            arrParam[3] = new OracleParameter("p_tipoAcuerdo", OracleDbType.Double,2);
            arrParam[3].Value = tipo;

            arrParam[4] = new OracleParameter("p_razon_social", OracleDbType.NVarchar2, 150);
            arrParam[4].Direction = ParameterDirection.Output;

            arrParam[5] = new OracleParameter("p_nombre_comercial", OracleDbType.NVarchar2, 150);
            arrParam[5].Direction = ParameterDirection.Output;

            arrParam[6] = new OracleParameter("p_IOCursor", OracleDbType.RefCursor);
            arrParam[6].Direction = ParameterDirection.Output;

            arrParam[7] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[7].Direction = ParameterDirection.Output;

            String cmdStr = "SFC_FACTURA_PKG.ReferenciasDisponiblesParaPago";
            String Resultado = "";


            try
            {
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);

                Resultado = arrParam[7].Value.ToString();

                if (Resultado != "0")
                {
                    DataTable dt = new DataTable();
                    Utilitarios.Utils.agregarMensajeError(Resultado, ref dt);

                    if (ds.Tables.Count > 0)
                    {
                        RazonSocial = arrParam[4].Value.ToString();
                        NombreComercial = arrParam[5].Value.ToString();

                        return ds.Tables[0];
                    }
                    return new DataTable("No Hay Data");
                }

                return ds.Tables[0];
            }
            catch (Exception ex)
            {

                SuirPlus.Exepciones.Log.LogToDB(ex.ToString());

                throw ex;

            }


        }
        //return dt;
        //    }

        //    RazonSocial = arrParam[4].Value.ToString();
        //    NombreComercial = arrParam[5].Value.ToString();

        //    return ds.Tables[0];
            
        //}

        public static DataTable getRefsDisponiblesParaPago(string RNCoCedula,eConcepto Concepto, ref string RazonSocial, ref string NombreComercial)
        {
            OracleParameter[] arrParam;

            arrParam = new OracleParameter[6];

            arrParam[0] = new OracleParameter("p_rnc_o_cedula", OracleDbType.NVarchar2, 11);
            arrParam[0].Value = RNCoCedula;

            arrParam[1] = new OracleParameter("p_concepto", OracleDbType.NVarchar2, 4);
            arrParam[1].Value = Concepto;

            arrParam[2] = new OracleParameter("p_razon_social", OracleDbType.NVarchar2, 150);
            arrParam[2].Direction = ParameterDirection.Output;

            arrParam[3] = new OracleParameter("p_nombre_comercial", OracleDbType.NVarchar2, 150);
            arrParam[3].Direction = ParameterDirection.Output;

            arrParam[4] = new OracleParameter("p_IOCursor", OracleDbType.RefCursor);
            arrParam[4].Direction = ParameterDirection.Output;

            arrParam[5] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[5].Direction = ParameterDirection.Output;

            String cmdStr = "SFC_FACTURA_PKG.LasRefsDisponiblesParaPago";
            string Resultado = "";

            try
            {

                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);

                Resultado = arrParam[5].Value.ToString();

                if (Resultado == "0")
                {
                    RazonSocial = arrParam[2].Value.ToString();
                    NombreComercial = arrParam[3].Value.ToString();
                    return ds.Tables[0];
                }
                else
                {
                    RazonSocial = "";
                    NombreComercial = "";
                    return new DataTable("No Hay Data");
                }               
                
            }

            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());

                throw ex;
            }
        }
         //        return dt;
        //    }

        //    RazonSocial = arrParam[2].Value.ToString();
        //    NombreComercial = arrParam[3].Value.ToString();

        //    return ds.Tables[0];
            
        //}

        public static DataTable getRefsDisponiblesParaPagoWS(string RNCoCedula, eConcepto Concepto)
        {
            OracleParameter[] arrParam;

            arrParam = new OracleParameter[4];

            arrParam[0] = new OracleParameter("p_rnc_o_cedula", OracleDbType.NVarchar2, 11);
            arrParam[0].Value = RNCoCedula;

            arrParam[1] = new OracleParameter("p_concepto", OracleDbType.NVarchar2, 4);
            arrParam[1].Value = Concepto;

            arrParam[2] = new OracleParameter("p_IOCursor", OracleDbType.RefCursor);
            arrParam[2].Direction = ParameterDirection.Output;

            arrParam[3] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[3].Direction = ParameterDirection.Output;

            String cmdStr = "SFC_FACTURA_PKG.LasRefsDisponiblesParaPagoWS";
            String Resultado = "";
            try
            {
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);

                Resultado = arrParam[3].Value.ToString();
                
                if (Resultado != "0")              
                {                    
                    if (ds.Tables.Count > 0)
                    {

                        return ds.Tables[0];

                    }

                    return new DataTable("No Hay Data");
                }

                 return ds.Tables[0];
            }
        
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());

                throw ex;
            }
        }
    
        public static DataTable getAutorizaciones(string UsuarioBanco, string NroReferencia, eConcepto Concepto)
		{
			OracleParameter[] arrParam  = new OracleParameter[5];

			arrParam[0] = new OracleParameter("p_idusuario", OracleDbType.NVarchar2, 35);
			arrParam[0].Value = UsuarioBanco.Trim();

			arrParam[1] = new OracleParameter("p_NoReferencia", OracleDbType.NVarchar2, 16);
			arrParam[1].Value = Utilitarios.Utils.verificarNulo(NroReferencia);

			arrParam[2] = new OracleParameter("p_concepto", OracleDbType.NVarchar2, 4);
			arrParam[2].Value = Concepto;

			arrParam[3] = new OracleParameter("p_IOCursor", OracleDbType.RefCursor);
			arrParam[3].Direction = ParameterDirection.Output;

			arrParam[4] = new OracleParameter("p_ResultNumber", OracleDbType.NVarchar2, 200);
			arrParam[4].Direction = ParameterDirection.Output;

			String cmdStr= "SFC_FACTURA_PKG.Cons_Autorizacion";

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
				
		public static DataTable getNominas(string RNCoCedula)
		{

			OracleParameter[] arrParam  = new OracleParameter[3];

			arrParam[0] = new OracleParameter("p_RNCoCedula", OracleDbType.NVarchar2, 11);
			arrParam[0].Value = RNCoCedula;

			arrParam[1] = new OracleParameter("p_IOCursor", OracleDbType.RefCursor);
			arrParam[1].Direction = ParameterDirection.Output;

			arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
			arrParam[2].Direction = ParameterDirection.Output;

			String cmdStr= "SFC_FACTURA_PKG.Get_Nominas";
			
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
		
		public static DataTable getStatusFacturas()
		{
			DataTable dt = new DataTable("StatusFacturas");
					
			DataColumn dtC = new DataColumn("Status");
			dt.Columns.Add(dtC);
			dtC = new DataColumn("Descripcion");
			dt.Columns.Add(dtC);

			DataRow dtR = null;

			dtR = dt.NewRow();
			dtR["Descripcion"] = "Pagada";
			dtR["Status"] = "PA";
			dt.Rows.Add(dtR);

			dtR = dt.NewRow();
            dtR["Descripcion"] = "Revocada";
			dtR["Status"] = "CA";
			dt.Rows.Add(dtR);

            dtR = dt.NewRow();
            dtR["Descripcion"] = "Recalculada";
            dtR["Status"] = "RE";
            dt.Rows.Add(dtR);

			dtR = dt.NewRow();
			dtR["Descripcion"] = "Vigente";
			dtR["Status"] = "VI";
			dt.Rows.Add(dtR);

			dtR = dt.NewRow();
			dtR["Descripcion"] = "Vencida";
			dtR["Status"] = "VE";
			dt.Rows.Add(dtR);

            dtR = dt.NewRow();
            dtR["Descripcion"] = "Exenta";
            dtR["Status"] = "EX";
            dt.Rows.Add(dtR);

            dtR = dt.NewRow();
            dtR["Descripcion"] = "Pendiente";
            dtR["Status"] = "PE";
            dt.Rows.Add(dtR);

            dtR = dt.NewRow();
            dtR["Descripcion"] = "Inhabilitada para pago";
            dtR["Status"] = "IN";
            dt.Rows.Add(dtR);

			dtR = dt.NewRow();
			dtR["Descripcion"] = "Todos";
			dtR["Status"] = "TODOS";
			dt.Rows.Add(dtR);

			return dt;
		}

		public static DataTable getConceptos()
		{
		
			
			DataTable dt = new DataTable("Conceptos");
					
			DataColumn dtC = new DataColumn("Concepto");
			dt.Columns.Add(dtC);
			dtC = new DataColumn("Valor");
			dt.Columns.Add(dtC);

			DataRow dtR = null;

			dtR = dt.NewRow();
			dtR["Concepto"] = "TSS";
			dtR["Valor"] = "TSS";
			dt.Rows.Add(dtR);

			dtR = dt.NewRow();
			dtR["Concepto"] = "ISR";
			dtR["Valor"] = "ISR";
			dt.Rows.Add(dtR);

			dtR = dt.NewRow();
			dtR["Concepto"] = "IR17";
			dtR["Valor"] = "IR17";
			dt.Rows.Add(dtR);

			dtR = dt.NewRow();
			dtR["Concepto"] = "INFOTEP";
			dtR["Valor"] = "INF";
			dt.Rows.Add(dtR);

            dtR = dt.NewRow();
            dtR["Concepto"] = "MDT";
            dtR["Valor"] = "MDT";
            dt.Rows.Add(dtR);

			return dt;
			
		}

		public static DataTable consultaPago(eConcepto Concepto, string noReferencia, int noAutorizacion)
		{
			OracleParameter[] arrParam;

			arrParam  = new OracleParameter[5];

			arrParam[0] = new OracleParameter("p_NoReferencia", OracleDbType.NVarchar2,16);
			arrParam[0].Value = SuirPlus.Utilitarios.Utils.verificarNulo(noReferencia);

			arrParam[1] = new OracleParameter("p_NoAutorizacion", OracleDbType.Decimal);
			arrParam[1].Value = SuirPlus.Utilitarios.Utils.verificarNulo(noAutorizacion);

			arrParam[2] = new OracleParameter("p_concepto", OracleDbType.NVarchar2, 4);
			arrParam[2].Value = Concepto;

			arrParam[3] = new OracleParameter("p_IOCursor", OracleDbType.RefCursor);
			arrParam[3].Direction = ParameterDirection.Output;

			arrParam[4] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
			arrParam[4].Direction = ParameterDirection.Output;

			String cmdStr= "SFC_FACTURA_PKG.Cons_Pagos";

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

		public static DataTable consultaEnvios(string noReferencia)
		{
			OracleParameter[] arrParam;

			arrParam  = new OracleParameter[3];

			arrParam[0] = new OracleParameter("p_NoReferencia", OracleDbType.NVarchar2,16);
			arrParam[0].Value = SuirPlus.Utilitarios.Utils.verificarNulo(noReferencia);

			arrParam[1] = new OracleParameter("p_IOCursor", OracleDbType.RefCursor);
			arrParam[1].Direction = ParameterDirection.Output;

			arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
			arrParam[2].Direction = ParameterDirection.Output;

			String cmdStr= "SFC_FACTURA_PKG.Cons_Envios";

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

		public static DataTable getAutAnalisisRecaudo(string nroAutorizacion)
		{

			OracleParameter[] arrParam  = new OracleParameter[3];
	
			arrParam[0] = new OracleParameter("p_NoAutorizacion", OracleDbType.NVarchar2, 16);
			arrParam[0].Value = nroAutorizacion;

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

                SuirPlus.Exepciones.Log.LogToDB(ex.ToString());

                throw ex;

            }
		}

		public static DataTable getEnviosAnalisisRecaudo(string nroReferencia)
		{

			OracleParameter[] arrParam  = new OracleParameter[3];

			arrParam[0] = new OracleParameter("p_NoReferencia", OracleDbType.NVarchar2, 16);
			arrParam[0].Value = nroReferencia;

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

        public static DataTable getMensajesNacha(string NroReferencia)
        {
            //throw new Exception(NroReferencia.ToString());
            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_idreferencia", OracleDbType.NVarchar2, 16);
            arrParam[0].Value = NroReferencia;
            arrParam[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;
            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;

            String cmdStr = "SFC_DGII_PKG.Get_Archivo_Nacha";

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

        internal DataTable getDetalle(eConcepto Concepto)
        {
            if (Concepto == eConcepto.IR17)
            {
                throw new Exception("El IR17 No tiene detalle");
            }

            OracleParameter[] arrParam = new OracleParameter[4];

            arrParam[0] = new OracleParameter("p_NoReferencia", OracleDbType.NVarchar2, 16);
            arrParam[0].Value = this.myNroReferencia;

            arrParam[1] = new OracleParameter("p_concepto", OracleDbType.NVarchar2, 4);
            arrParam[1].Value = Concepto;

            arrParam[2] = new OracleParameter("p_IOCursor", OracleDbType.RefCursor);
            arrParam[2].Direction = ParameterDirection.Output;

            arrParam[3] = new OracleParameter("p_ResultNumber", OracleDbType.NVarchar2, 200);
            arrParam[3].Direction = ParameterDirection.Output;

            String cmdStr = "SFC_FACTURA_PKG.Cons_Detalle";

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

        public DataTable getDetalle()
        {
            return this.getDetalle(this.myConcepto);
        }

        ///<sumary>
        ///Metodo utilizado para obtener el detalle de una factura por su concepto y su numero de referencia con paginación
        ///</summary>
        ///<param name="Noreferencia">Número de referencia</param>
        ///<param name="pageNum">Numero de la pagina utilizado para el paging</param>
        ///<param name="pageSize">Tamaño de la pagina, utilizado para el paging</param>
        ///<returns>Un datatable con el detalle de la nomina especificada</returns>
        ///<remarks>By Charlie Pena</remarks> 
        public static DataTable getDetalleFactura(string Noreferencia, string Concepto, Int16 pageNum, Int32 pageSize)
        {
            OracleParameter[] arrParam = new OracleParameter[6];

            arrParam[0] = new OracleParameter("p_NoReferencia", OracleDbType.NVarchar2, 16);
            arrParam[0].Value = Noreferencia;

            arrParam[1] = new OracleParameter("p_concepto", OracleDbType.NVarchar2, 4);
            arrParam[1].Value = Concepto;

            arrParam[2] = new OracleParameter("p_pagenum", OracleDbType.Int16);
            arrParam[2].Value = pageNum;

            arrParam[3] = new OracleParameter("p_pagesize", OracleDbType.Int32);
            arrParam[3].Value = pageSize;

            arrParam[4] = new OracleParameter("p_IOCursor", OracleDbType.RefCursor);
            arrParam[4].Direction = ParameterDirection.Output;

            arrParam[5] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 100);
            arrParam[5].Direction = ParameterDirection.Output;

            string cmdStr = "SFC_FACTURA_PKG.ConsPage_Detalle_v2";

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

        ///<sumary>
        ///Metodo utilizado para obtener el detalle de una factura por su concepto y su numero de referencia sin paginacion
        ///</summary>
        ///<param name="Noreferencia">Número de referencia</param>
        ///<returns>Un datatable con el detalle de la nomina especificada</returns>
        ///<remarks>By Charlie Pena</remarks> 
        public static DataTable getDetFacturaNoPaging(string Noreferencia, string Concepto)
        {
            OracleParameter[] arrParam = new OracleParameter[4];

            arrParam[0] = new OracleParameter("p_NoReferencia", OracleDbType.NVarchar2, 16);
            arrParam[0].Value = Noreferencia;

            arrParam[1] = new OracleParameter("p_concepto", OracleDbType.NVarchar2, 4);
            arrParam[1].Value = Concepto;

            arrParam[2] = new OracleParameter("p_IOCursor", OracleDbType.RefCursor);
            arrParam[2].Direction = ParameterDirection.Output;

            arrParam[3] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 100);
            arrParam[3].Direction = ParameterDirection.Output;

            string cmdStr = "SFC_FACTURA_PKG.Cons_Detalle";

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

        /// <summary>
        /// 
        /// </summary>
        /// <param name="NroReferencia"></param>
        /// <returns></returns>
        public static DataTable getDetalleFacturaAuditoriaNoPaging(string NroReferencia)
        {

            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_NoReferencia", OracleDbType.NVarchar2, 16);
            arrParam[0].Value = NroReferencia;

            arrParam[1] = new OracleParameter("p_IOCursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 100);
            arrParam[2].Direction = ParameterDirection.Output;

            string cmdStr = "SFC_FACTURA_PKG.Cons_Detalle_Auditoria";

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


        /// <summary>
        /// 
        /// </summary>
        /// <param name="NroReferencia"></param>
        /// <returns></returns>
        public static DataTable getDetalleFacturaSipenNoPaging(string NroReferencia)
        {

            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_NoReferencia", OracleDbType.NVarchar2, 16);
            arrParam[0].Value = NroReferencia;

            arrParam[1] = new OracleParameter("p_IOCursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 100);
            arrParam[2].Direction = ParameterDirection.Output;

            string cmdStr = "SFC_FACTURA_PKG.Cons_Detalle_Sipen";

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

        ///<sumary>
        ///Metodo utilizado para obtener el detalle de una factura de auditoria de la TSS
        ///</summary>
        ///<param name="Noreferencia">Número de referencia</param>
        ///<param name="pageNum">Numero de la pagina utilizado para el paging</param>
        ///<param name="pageSize">Tamaño de la pagina, utilizado para el paging</param>
        ///<returns>Un datatable con el detalle de una factura de auditoria especificada</returns>
        ///<remarks>By Ronny Carreras</remarks>         
        public static DataTable getDetalleFacturaAuditoria(string Noreferencia, Int16 pageNum, Int16 pageSize)
        {
            OracleParameter[] arrParam = new OracleParameter[5];

            arrParam[0] = new OracleParameter("p_NoReferencia", OracleDbType.NVarchar2, 16);
            arrParam[0].Value = Noreferencia;

            arrParam[1] = new OracleParameter("p_pagenum", OracleDbType.Int16);
            arrParam[1].Value = pageNum;

            arrParam[2] = new OracleParameter("p_pagesize", OracleDbType.Int16);
            arrParam[2].Value = pageSize;

            arrParam[3] = new OracleParameter("p_IOCursor", OracleDbType.RefCursor);
            arrParam[3].Direction = ParameterDirection.Output;

            arrParam[4] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 100);
            arrParam[4].Direction = ParameterDirection.Output;

            string cmdStr = "SFC_FACTURA_PKG.ConsPage_Detalle_Auditoria";

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


        public static DataTable getDetalleAjuste(string Noreferencia, Int16 pageNum, Int16 pageSize)
        {
            OracleParameter[] arrParam = new OracleParameter[5];

            arrParam[0] = new OracleParameter("p_NoReferencia", OracleDbType.NVarchar2, 16);
            arrParam[0].Value = Noreferencia;

            arrParam[1] = new OracleParameter("p_pagenum", OracleDbType.Int16);
            arrParam[1].Value = pageNum;

            arrParam[2] = new OracleParameter("p_pagesize", OracleDbType.Int16);
            arrParam[2].Value = pageSize;

            arrParam[3] = new OracleParameter("p_IOCursor", OracleDbType.RefCursor);
            arrParam[3].Direction = ParameterDirection.Output;

            arrParam[4] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 100);
            arrParam[4].Direction = ParameterDirection.Output;

            string cmdStr = "SFC_FACTURA_PKG.ConsPage_Detalle_Ajuste";

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


        public static DataTable getMontoTotalAjuste(string Noreferencia)
        {
            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_NoReferencia", OracleDbType.NVarchar2, 16);
            arrParam[0].Value = Noreferencia;

            arrParam[1] = new OracleParameter("p_IOCursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 100);
            arrParam[2].Direction = ParameterDirection.Output;

            string cmdStr = "SFC_FACTURA_PKG.getMontoTotalAjuste";

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

       

	}
}
