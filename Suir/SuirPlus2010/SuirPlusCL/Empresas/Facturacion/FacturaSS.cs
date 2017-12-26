using System;
using System.Data;
using SuirPlus;
using Oracle.ManagedDataAccess.Client;

namespace SuirPlus.Empresas.Facturacion
{

	public class FacturaSS : Factura
	{
        public FacturaSS(string NroReferencia)
		{
			this.myConcepto = Factura.eConcepto.SDSS;
			this.myInstitucion = Factura.eInstitucion.Tesoreria;
			this.myNroReferencia = NroReferencia;
			this.CargarDatos();

		}

		public FacturaSS(Int64 NroAutorizacion)
		{
			this.myConcepto = Factura.eConcepto.SDSS;
			this.myInstitucion = Factura.eInstitucion.Tesoreria;
			this.myNroAutorizacion = NroAutorizacion;
			this.CargarDatos();
		}
        		
		#region Propiedades Internas
			
			internal decimal myRetencionTrabajadoresSFS;
			internal decimal myContribucionEmpleadorSFS;
			internal decimal myRetencionTrabajadoresPension;
			internal decimal myContribucionEmpleadorPension;
			internal decimal mySRL;
			internal decimal myPagosPerCapitaAdicional;
			internal decimal myAportesVoluntariosOrdinarios;
			internal decimal myInteresesSFS;
			internal decimal myRecargoSFS;
			internal decimal myInteresPension;
			internal decimal myRecargoPension;
			internal decimal myInteresesSRL;
			internal decimal myRecargoSRL;
            internal decimal myMontoAjuste;

		#endregion

		#region Propiedades Publicas
		
		/// <summary>
		/// Total aporte del afiliado al Seguro Familiar de Salud.
		/// </summary>
		public decimal RetencionTrabajadoresSFS
		{
			get{return this.myRetencionTrabajadoresSFS;}
		}

		/// <summary>
		/// Total aporte del empleador al Seguro Familiar de Salud.
		/// </summary>
		public decimal ContribucionEmpleadorSFS
		{
			get{return this.myContribucionEmpleadorSFS;}
		}

		/// <summary>
		/// Total aporte del empleador al Seguro de Vida.
		/// </summary>
		public decimal RetencionTrabajadoresPension
		{
			get{return this.myRetencionTrabajadoresPension;}
		}

		/// <summary>
		/// Total aporte del afiliado al Seguro de Vida.
		/// </summary>
		public decimal ContribucionEmpleadorPension
		{
			get{return this.myContribucionEmpleadorPension;}
		}

		/// <summary>
		/// Total de aporte al seguro de riesgo laborales.
		/// </summary>
		public decimal SRL
		{
			get{return this.mySRL;}
		}

		/// <summary>
		///	Total de aporte del pago per capita adicional.
		/// </summary>
		public decimal PagosPerCapitaAdicional
		{
			get{return this.myPagosPerCapitaAdicional;}
		}

		/// <summary>
		/// Total de aportes voluntario ordinarios.
		/// </summary>
		public decimal AportesVoluntariosOrdinarios
		{
			get{return this.myAportesVoluntariosOrdinarios;}
		}
		/// <summary>
		/// Total de intereses para el seguro familiar de salud.
		/// </summary>
		public decimal InteresesSFS
		{
			get{return this.myInteresesSFS;}
		}
		/// <summary>
		/// Total de los recargos para el seguro familiar de salud.
		/// </summary>
		public decimal RecargosSFS
		{
			get{return this.myRecargoSFS;}
		}
		/// <summary>
		/// Total intereses para el seguro de vida.
		/// </summary>
		public decimal InteresPension
		{
			get{return this.myInteresPension;}
		}
		/// <summary>
		/// Total de los recargos para el seguro de vida.
		/// </summary>
		public decimal RecargoPension
		{
			get{return this.myRecargoPension;}
		}
		/// <summary>
		/// Total intereses del seguro de riesgo laboral
		/// </summary>
		public decimal InteresSRL
		{
			get{return this.myInteresesSRL;}
		}
		/// <summary>
		/// Total de recargos del seguro de riesgo laboral.
		/// </summary>
		public decimal RecargoSRL
		{
			get{return this.myRecargoSRL;}
		}
        /// <summary>
        /// Total de los Creditos de Subsidios y Maternidad
        /// </summary>
        public decimal MontoAjuste
        {
            get { return this.myMontoAjuste; }
        }


		#endregion

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
				DataTable dtOficio;
				dtOficio = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, "SFC_FACTURA_PKG.Cons_OficiosVencidas", arrParam).Tables[0];

				if (dt.Rows.Count > 0)
				{

					//this.myCantReferencia = dt.Rows[0]["cant_referencia"].ToString();
					this.myNroReferencia = dt.Rows[0]["id_referencia"].ToString();
					this.myFechaAutorizacion = dt.Rows[0]["fecha_autorizacion"].ToString();
					this.myFechaDesAutorizacion = dt.Rows[0]["fecha_desautorizacion"].ToString();//Convert.ToDateTime(dt.Rows[0]["fecha_desautorizacion"]);					
					this.myUsuarioDesAutorizo = dt.Rows[0]["id_usuario_desautoriza"].ToString();
					this.myFechaPago = dt.Rows[0]["fecha_pago"].ToString();
					this.myFechaEmision = Convert.ToDateTime(dt.Rows[0]["fecha_emision"]);
					this.myFechaLimitePago = Convert.ToDateTime(dt.Rows[0]["fecha_limite_pago"]);
					this.myPeriodo = dt.Rows[0]["periodo_factura"].ToString();
					this.myNroAutorizacion = Convert.ToInt64(dt.Rows[0]["no_autorizacion"].ToString());
					this.myTotalGeneral = Convert.ToDecimal(dt.Rows[0]["total_general_factura"]);
					this.myPeriodo = dt.Rows[0]["periodo_factura"].ToString();
					this.myRNC = dt.Rows[0]["rnc_o_cedula"].ToString();
					this.myRegistroPatronal = Convert.ToInt32(dt.Rows[0]["id_registro_patronal"].ToString());				
					this.myRazonSocial = dt.Rows[0]["razon_social"].ToString();
					this.myNombreComercial = dt.Rows[0]["nombre_comercial"].ToString();
					this.myIDNomina = dt.Rows[0]["id_nomina"].ToString();
					this.myNomina = dt.Rows[0]["nomina_des"].ToString();
					this.myTotalAsalariados  = Convert.ToInt32(dt.Rows[0]["total_trabajadores"]);
					this.myIDTipoFactura = dt.Rows[0]["id_tipo_factura"].ToString();
					this.myTipoFactura = dt.Rows[0]["tipo_factura_des"].ToString();
					this.myUsuarioAutorizo = dt.Rows[0]["id_usuario_autoriza"].ToString();  
					this.myTipoNomina= dt.Rows[0]["Tipo_Nomina"].ToString();//ch
					this.myEstatus = dt.Rows[0]["Status"].ToString();
					this.myEntidadRecaudadora = dt.Rows[0]["entidad_recaudadora_des"].ToString();
					this.myFechaReportePago = (dt.Rows[0]["fecha_reporte_pago"] != System.DBNull.Value ? Convert.ToDateTime(dt.Rows[0]["fecha_reporte_pago"]):new DateTime());
					this.myFechaReporte = dt.Rows[0]["fecha_reporte_pago"].ToString();

					//Seccion de los totales de la factura.
					this.myRetencionTrabajadoresSFS = Convert.ToDecimal(dt.Rows[0]["total_aporte_afiliados_sfs"]);
					this.myContribucionEmpleadorSFS = Convert.ToDecimal(dt.Rows[0]["total_aporte_empleador_sfs"]);
					this.myRetencionTrabajadoresPension = Convert.ToDecimal(dt.Rows[0]["total_aporte_afiliados_svds"]);
					this.myContribucionEmpleadorPension = Convert.ToDecimal(dt.Rows[0]["total_aporte_empleador_svds"]);
					this.mySRL = Convert.ToDecimal(dt.Rows[0]["total_aporte_srl"]);
					this.myPagosPerCapitaAdicional = Convert.ToDecimal(dt.Rows[0]["total_per_capita_adicional"]);
					this.myAportesVoluntariosOrdinarios = Convert.ToDecimal(dt.Rows[0]["total_aporte_voluntario"]);
					this.myInteresesSFS = Convert.ToDecimal(dt.Rows[0]["total_interes_sfs"]);
					this.myRecargoSFS = Convert.ToDecimal(dt.Rows[0]["total_recargo_sfs"]);
					this.myInteresPension = Convert.ToDecimal(dt.Rows[0]["total_interes_pension"]);
					this.myRecargoPension = Convert.ToDecimal(dt.Rows[0]["total_recargo_svds"]);
					this.myInteresesSRL = Convert.ToDecimal(dt.Rows[0]["total_interes_srl"]);
					this.myRecargoSRL = Convert.ToDecimal(dt.Rows[0]["total_recargo_srl"]);
                    this.myMontoAjuste = Convert.ToDecimal(dt.Rows[0]["monto_ajuste"]);
					this.myTotalGeneral = Convert.ToDecimal(dt.Rows[0]["total_general_factura"]);
					this.myOrigenPago = dt.Rows[0]["OrigenPago"].ToString();
                    this.myStatusGeneracion = dt.Rows[0]["status_generacion"].ToString();

					if (dtOficio.Rows.Count > 0)
					{
					this.myIDOficio =  dtOficio.Rows[0]["id_oficio"].ToString();
					this.myMotivoDesc  =  dtOficio.Rows[0]["texto_motivo"].ToString();
					}

                   
				
					dtOficio.Dispose();
				
				}
				else
				{
					throw new Exception("Nro. de Referencia Inválido");
				}
				
				dt.Dispose();

			}
			catch(Exception ex)
			{
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;
			}
		}

		public override String GuardarCambios(string UsuarioResponsable)
		{
			return "";
		}
        
        public static string setFechaLimitePagoAcuerdo(string p_id_referencia, System.DateTime p_fecha_limite_pago_acuerdo)
        {
            string result;
            string strCmd = "SFC_FACTURA_PKG.SetFechaLimitePagoAcuerdo";
            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_id_referencia", OracleDbType.NVarchar2, 16);
            arrParam[0].Value = p_id_referencia;

            arrParam[1] = new OracleParameter("p_fecha_limite_pago_acuerdo", OracleDbType.Date);
            arrParam[1].Value = p_fecha_limite_pago_acuerdo;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;

            try
            {
               SuirPlus.DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, strCmd, arrParam);
               result = arrParam[2].Value.ToString();
            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;
            }

            return result;
        }

        /// <summary>
        /// Funcion utilizada para obtener las facturas pendientes de un empleador.
        /// </summary>
        /// <param name="rnc">El rnc o cédula del empleador</param>
        /// <returns>Un datatable con las facturas pendientes.</returns>
        /// 
        public static DataTable getFacturaPendientes(string rnc)
		{
            
			DataTable dtFacturas;
			string strCmd = "SFC_FACTURA_PKG.get_facturas_pendientes";
			OracleParameter[] arrParam = new OracleParameter[2];

			arrParam[0] = new OracleParameter("p_RNCoCedula", OracleDbType.NVarchar2,11);
			arrParam[0].Value = rnc;

			arrParam[1] = new OracleParameter("p_IOCursor", OracleDbType.RefCursor);
			arrParam[1].Direction = ParameterDirection.Output;
            DataSet ds = new DataSet();
            
			try
			{
			ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, strCmd,arrParam);
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
		/// Funcion utilizada para traer las facturar pendientes de un empleador
		/// desde el punto de vista de la ARL
		/// </summary>
		/// <param name="rnc">El RNC del empleador</param>
		/// <remarks>By Ronny Carreras</remarks>
		/// <returns>Un datatable con los resultados</returns>
		public static DataTable getConsultaDeudaARL(string rnc)
		{
            
			DataTable dtFacturas;
			string strCmd = "SFC_FACTURA_PKG.get_ConsultaDeuda_ARL";
			OracleParameter[] arrParam = new OracleParameter[2];

			arrParam[0] = new OracleParameter("p_RNCoCedula", OracleDbType.NVarchar2,11);
			arrParam[0].Value = rnc;

			arrParam[1] = new OracleParameter("p_IOCursor", OracleDbType.RefCursor);
			arrParam[1].Direction = ParameterDirection.Output;

			try
			{
				DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, strCmd,arrParam);
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
		/// Funcion utilizada para recalular la factura SS apartir de un nuevo salario.
		/// </summary>
		/// <param name="idReferencia">No. de factura que se quiere recalcular</param>
		/// <param name="Documento">Cedula del trabajador.</param>
		/// <param name="Salario">Salario con el que se va a recalcular.</param>
		/// <param name="aporteVoluntario">Aporte Voluntario del trabajador</param>
		/// <returns></returns>
		public static DataTable getNotificacionRecalculada(string idReferencia, string documento, decimal salario, decimal aporteVoluntario)
		{

			DataTable dtFactura;
			string strCmd = "Sfc_Pkg.recalcula_ss";
			string resultado = string.Empty;

			OracleParameter[] arrParam = new OracleParameter[8];

			arrParam[0] = new OracleParameter("p_id_referencia", OracleDbType.NVarchar2,16);
			arrParam[0].Value = idReferencia;

			arrParam[1] = new OracleParameter("p_documento_o_nss", OracleDbType.NVarchar2,11);
			arrParam[1].Value = documento;

			arrParam[2] = new OracleParameter("p_salario_ss", OracleDbType.Decimal);
			arrParam[2].Value = salario;

			arrParam[3] = new OracleParameter("p_aporte_voluntario", OracleDbType.Decimal);
			arrParam[3].Value = aporteVoluntario;

			arrParam[4] = new OracleParameter("p_tipo_diferencia", OracleDbType.Decimal);	
			arrParam[4].Value = 1;

			arrParam[5] = new OracleParameter("p_fecha_hasta", OracleDbType.Date);
			arrParam[5].Value = System.DBNull.Value;

			arrParam[6] = new OracleParameter("p_io_cursor", OracleDbType.RefCursor);
			arrParam[6].Direction = ParameterDirection.Output;

			arrParam[7] = new OracleParameter("p_return", OracleDbType.NVarchar2, 200);
			arrParam[7].Direction = ParameterDirection.Output;

			try
			{
				DataSet ds = SuirPlus.DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, strCmd,arrParam);				
				resultado = Utilitarios.Utils.sacarMensajeDeError(arrParam[7].Value.ToString());

				if (!(resultado).Equals("OK"))
				{
					throw new Exception(resultado);
				}

                return ds.Tables[0];
			}
			catch(Exception ex)
			{
                Exepciones.Log.LogToDB(ex.ToString());
				throw ex;
			}

         }
		
		/// <summary>
		/// Funcion utilizada para recalcular el monto del seguro de riesgo laboral de una factura.
		/// </summary>
		/// <param name="idReferencia">No. de referencia de la notificación.</param>
		/// <param name="idRiesgo">ID del Riesgo al que se desea recalcular.</param>
		/// <returns></returns>
		public static DataTable getSrlRecalculado(string idReferencia, string idRiesgo)
		{
			DataTable dtSRL;
			string strCmd = "Sfc_Pkg.recalcula_srl";

			OracleParameter[] arrParam = new OracleParameter[3];

			arrParam[0] = new OracleParameter("p_id_referencia", OracleDbType.NVarchar2,16);
			arrParam[0].Value = idReferencia;
			
			arrParam[1] = new OracleParameter("p_id_riesgo", OracleDbType.NVarchar2,3);
			arrParam[1].Value = idRiesgo;

			arrParam[2] = new OracleParameter("p_io_cursor", OracleDbType.RefCursor);
			arrParam[2].Direction = ParameterDirection.Output;
			
			try
			{
				DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, strCmd,arrParam);
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
		/// Se obtiene el detalle de una factura de auditoria.
		/// </summary>
		/// <param name="nroReferencia">El no. de referencia de la factura</param>
		/// <returns>Un datatable que contiene el detalle de la factura.</returns>
		public DataTable getDetalleAuditoria()
		{
			OracleParameter[] arrParam  = new OracleParameter[4];

			arrParam[0] = new OracleParameter("p_NoReferencia", OracleDbType.NVarchar2, 16);
			arrParam[0].Value = this.myNroReferencia;

			arrParam[1] = new OracleParameter("p_IOCursor", OracleDbType.RefCursor);
			arrParam[1].Direction = ParameterDirection.Output;

			arrParam[2] = new OracleParameter("p_ResultNumber", OracleDbType.NVarchar2, 200);
			arrParam[2].Direction = ParameterDirection.Output;

			String cmdStr= "SFC_FACTURA_PKG.Cons_Detalle_Auditoria";

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
		/// Function tulizada para retornar de manera resumida una notificacion.
		/// </summary>
		/// <param name="idReferencia">El Nro. de Referencia que se desea consultar</param>
		/// <returns>Un Datatable con los rubros resumidos de la notificacion</returns>
		public static DataTable getResumenNotificacion(string idReferencia)
		{
			OracleParameter[] arrParam = new OracleParameter[3];
			
			arrParam[0] = new OracleParameter("p_IdReferencia", OracleDbType.NVarchar2, 16);
			arrParam[0].Value = idReferencia;

			arrParam[1] = new OracleParameter("p_IOCursor", OracleDbType.RefCursor);
			arrParam[1].Direction = ParameterDirection.Output;

			arrParam[2] = new OracleParameter("p_Resultnumber", OracleDbType.NVarchar2, 100);
			arrParam[2].Direction = ParameterDirection.Output;

			string cmdStr = "SFC_FACTURA_PKG.get_ResumenFactura";

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


        public static string MarcarRefAuditoriaDefinitiva(string id_referencia, string usuario)
        {
            string result;
            string strCmd = "Sfc_Factura_Pkg.MarcarRefAuditoriaDefinitiva";
            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_NoReferencia", OracleDbType.NVarchar2, 16);
            arrParam[0].Value = id_referencia;

            arrParam[1] = new OracleParameter("p_idusuario", OracleDbType.NVarchar2);
            arrParam[1].Value = usuario;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;

            try
            {
                SuirPlus.DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, strCmd, arrParam);
                result = arrParam[2].Value.ToString();
            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;
            }

            return result;
        }

        public static string errorReferenciaPreCalculo(string p_referencia){
            string result;
            string strCmd = "Sfc_Factura_Pkg.isValidaReferenciaPreCalculo";
            OracleParameter[] arrParam = new OracleParameter[2];

            arrParam[0] = new OracleParameter("p_referencia", OracleDbType.NVarchar2, 16);
            arrParam[0].Value = p_referencia;

            arrParam[1] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[1].Direction = ParameterDirection.Output;

            try
            {
                SuirPlus.DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, strCmd, arrParam);
                result = Utilitarios.Utils.sacarMensajeDeError(arrParam[1].Value.ToString());
            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;
            }

            return result;
        }

        /// <summary>
        /// Funcion utilizada para obtener los diferentes tipos de referencias disponibles.
        /// </summary>
        /// <returns>Un datatable con los diferentes tipos de referencias disponibles.</returns>
        /// 
        public static DataTable getTiposReferencias()
        {

            string strCmd = "ARL_PKG.get_tipos_referencias";
            OracleParameter[] arrParam = new OracleParameter[2];

            arrParam[0] = new OracleParameter("p_io_cursor", OracleDbType.RefCursor);
            arrParam[0].Direction = ParameterDirection.Output;
            arrParam[1] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[1].Direction = ParameterDirection.Output;
            DataSet ds = new DataSet();

            try
            {
                ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, strCmd, arrParam);
                if (arrParam[1].Value.ToString() != "0")
                {
                    throw new Exception(arrParam[1].Value.ToString());
                }
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
