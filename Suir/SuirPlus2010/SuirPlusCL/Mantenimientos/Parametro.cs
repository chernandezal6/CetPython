using SuirPlus;
using System;
using SuirPlus.DataBase;
using Oracle.ManagedDataAccess.Client;
using System.Data;
using System.Xml;
using System.IO;

namespace SuirPlus.Mantenimientos
{
	/// <summary>
	/// 
	/// </summary>
	public class Parametro : SuirPlus.FrameWork.Objetos
	{
		private int myIDParametro;
		private String myDescripcion;
		private String myTipoParametro;
		private String myTipoCalculo;

		public int IDParametro
		{
			get {return this.myIDParametro;}
		}
		public String Descripcion
		{
			get {return this.myDescripcion;}
			set {this.myDescripcion = value;}
		}
		public String TipoParametro
		{
			get {return this.myTipoParametro;}
			set {this.myTipoParametro = value;}
		}
		public String TipoCalculo
		{
			get {return this.myTipoCalculo;}
			set {this.myTipoCalculo = value;}
		}

		
		
		public Parametro(int ID_Parametro)
		{
			this.myIDParametro = ID_Parametro;
			this.CargarDatos();
		}
			
		/// <summary>
		/// Procedimiento utilizado para crear un nuevo parametro.
		/// </summary>
		/// <param name="descripcion">lo que describe el parametro</param>
		/// <param name="tipoParametro">el tipo de parametro</param>
		/// <param name="tipoCalculo">el tipo de calculo que hara el parametro.</param>
		/// <remarks>Creado por Ronny J. Carreras</remarks>
		public static string nuevoParametro(string descripcion, string tipoParametro, string tipoCalculo, string usuarioCrea)
		{
				OracleParameter[] arrParam = new OracleParameter[5];

					arrParam[0] = new OracleParameter("p_descripcion", OracleDbType.NVarchar2,100);
					arrParam[0].Value = descripcion;

					arrParam[1] = new OracleParameter("p_tipoparametro", OracleDbType.NVarchar2, 1);
					arrParam[1].Value = tipoParametro;
						
					arrParam[2] = new OracleParameter("p_tipocalculo", OracleDbType.NVarchar2, 1);
					arrParam[2].Value = tipoCalculo;

					arrParam[3] = new OracleParameter("p_ult_usuarioact", OracleDbType.NVarchar2, 35);
					arrParam[3].Value = usuarioCrea;

					arrParam[4] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 100);
					arrParam[4].Direction = ParameterDirection.Output;

			String cmdStr= "SRP_MANTENIMIENTO_PKG.NuevoParametro";
			string result = string.Empty;

			try
			{
				DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr,arrParam);
				result = arrParam[4].Value.ToString();

				if(result.Substring(0,1) != "0" )
											  throw new Exception(result.Replace("0",""));											 
								
			}
			catch(Exception ex)
			{
				throw ex;
			}

			return result.Substring(2,3).ToString();

		}

	
		/// <summary>
		/// Procedimiento utilizado para crear y actualizar un nuevo detalle de parametro.
		/// </summary>
		/// <param name="idParametro">ID del parametro que se le creara un detalle.</param>
		/// <param name="fechaInicio">Fecha de inicio de la vigencia del parametro.</param>
		/// <param name="fechaFin">Fecha fin de la vigencia del parametro.</param>
		/// <param name="valorFecha">Valor de fecha del parametro</param>
		/// <param name="valorNumerico">Valor numerico del parametro</param>
		/// <param name="valorTexto">Valor alfanumerico del parametro</param>
		/// <param name="isAutorizado">Si esta autorizado</param>
		/// <param name="usuarioCrea">Usuario que crea al detalle.</param>
		/// <remarks>Si el detalle no esta creado lo inserta, si esta creado entonces lo actualiza. Creado por Ronny J. Carreras,</remarks>
		public static void nuevoDetParametro(string idParametro, string fechaInicio, string fechaFin, 
																string valorFecha, decimal valorNumerico, string valorTexto, 
																string autorizado, string usuarioCrea)
		{

					
			OracleParameter[] arrParam  = new OracleParameter[9];

			arrParam[0] = new OracleParameter("p_id_parametro", OracleDbType.Decimal, 3);
			arrParam[0].Value = idParametro;

			arrParam[1] = new OracleParameter("p_fecha_ini", OracleDbType.NVarchar2, 10);
			arrParam[1].Value = fechaInicio;
			
			arrParam[2] = new OracleParameter("p_fecha_fin", OracleDbType.NVarchar2, 10);
			arrParam[2].Value = fechaFin;

			arrParam[3] = new OracleParameter("p_valor_fecha", OracleDbType.NVarchar2, 10);
			arrParam[3].Value = valorFecha;

			arrParam[4] = new OracleParameter("p_valor_numerico", OracleDbType.Decimal, 13);
			arrParam[4].Value = valorNumerico;

			arrParam[5] = new OracleParameter("p_valor_texto", OracleDbType.NVarchar2, 50);
			arrParam[5].Value =valorTexto;

			arrParam[6] = new OracleParameter("p_autorizado", OracleDbType.NVarchar2, 1);
			arrParam[6].Value = autorizado;

			arrParam[7] = new OracleParameter("p_ult_usuarioact", OracleDbType.NVarchar2, 35);
			arrParam[7].Value = usuarioCrea;

			arrParam[8] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 100);
			arrParam[8].Direction = ParameterDirection.Output;
						
			String cmdStr= "SRP_MANTENIMIENTO_PKG.NuevoDetParametro";
			string result = "0";

			try
			{
				DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr,arrParam);				
				result = arrParam[8].Value.ToString();		
				if(result != "0" )
					throw new Exception(result.Replace("-1",""));
			}
			catch(Exception ex)
			{
					throw ex;
			}

		}
		
		public static DataTable getParametros(int ID_Parametro)
		{
			OracleParameter[] arrParam  = new OracleParameter[3];

			arrParam[0] = new OracleParameter("p_id_parametro", OracleDbType.Decimal);
			arrParam[0].Value = Utilitarios.Utils.verificarNulo(ID_Parametro);

			arrParam[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
			arrParam[1].Direction = ParameterDirection.Output;

			arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
			arrParam[2].Direction = ParameterDirection.Output;

			String cmdStr= "SRP_MANTENIMIENTO_PKG.GetParametros";

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

		public static DataTable getDetalleParametros(int ID_Parametro)
		{
			OracleParameter[] arrParam  = new OracleParameter[3];

			arrParam[0] = new OracleParameter("p_id_parametro", OracleDbType.Decimal);
			arrParam[0].Value = Utilitarios.Utils.verificarNulo(ID_Parametro);

			arrParam[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
			arrParam[1].Direction = ParameterDirection.Output;

			arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
			arrParam[2].Direction = ParameterDirection.Output;

			String cmdStr= "SRP_MANTENIMIENTO_PKG.GetDetalleParametrosMant";

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

        public static DataTable getParametrosForName(string ID_Name)
        {
            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_id_name", OracleDbType.NVarchar2);
            arrParam[0].Value = Utilitarios.Utils.verificarNulo(ID_Name);

            arrParam[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;

            String cmdStr = "SRP_MANTENIMIENTO_PKG.GetParametroForName";

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

        public static DataTable getParametrosDetalleForName(string ID_Name)
        {
            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_id_name", OracleDbType.NVarchar2);
            arrParam[0].Value = Utilitarios.Utils.verificarNulo(ID_Name);

            arrParam[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;

            String cmdStr = "SRP_MANTENIMIENTO_PKG.GetParametroDetalleForName";

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




		public static DataTable getDetalleParametros(int ID_Parametro, string fechaInicio)
		{
			OracleParameter[] arrParam  = new OracleParameter[4];

			arrParam[0] = new OracleParameter("p_id_parametro", OracleDbType.Decimal);
			arrParam[0].Value = Utilitarios.Utils.verificarNulo(ID_Parametro);

			arrParam[1] = new OracleParameter("p_fecha_ini", OracleDbType.NVarchar2);
			arrParam[1].Value =  fechaInicio;
			
			arrParam[2] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
			arrParam[2].Direction = ParameterDirection.Output;

			arrParam[3] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 1000);
			arrParam[3].Direction = ParameterDirection.Output;

			String cmdStr= "SRP_MANTENIMIENTO_PKG.GetDetalleParametros";

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
		/// 
		/// </summary>
		/// <returns></returns>
		public static DataSet getParametrosActuales()
		{
			
			DataSet dsParam = new DataSet();
            DataTable dtRangosISR = new DataTable();
			DataTable dtRangosPEN = new DataTable();
            
			StringReader readerISR;
			StringReader readerPEN;
		
			OracleParameter[] arrParam = new OracleParameter[4];

			arrParam[0] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 100);
			arrParam[0].Direction = ParameterDirection.Output;

/*			arrParam[1] = new OracleParameter("p_rangos_isr", OracleDbType.NVarchar2, 2000);
			arrParam[1].Direction = ParameterDirection.Output;

			arrParam[2] = new OracleParameter("p_rangos_pen", OracleDbType.NVarchar2, 2000);
			arrParam[2].Direction = ParameterDirection.Output;*/

            arrParam[1] = new OracleParameter("p_rangos_isr", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_rangos_pen", OracleDbType.RefCursor);
            arrParam[2].Direction = ParameterDirection.Output;

            arrParam[3] = new OracleParameter("p_parametros", OracleDbType.RefCursor);
			arrParam[3].Direction = ParameterDirection.Output;

			string cmdStr = "Sfc_Pkg.Parametros_Actuales";	

			try
			{
                //Insertamos el cursor en el dataset
                dsParam = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);

                //Insertamos el xml en el dataset ISR                
                /*readerISR = new StringReader(arrParam[1].Value.ToString());
                dtRangosISR.ReadXml(readerISR);
                readerISR.Close();

                //Agregamos el datatable al dataset de Parametros
                dsParam.Tables.Add(dtRangosISR);

                //insertamos el xml de Pensionado en el dataset
                //dsRangosPEN = new DataSet();
                readerPEN = new StringReader(arrParam[2].Value.ToString());
                dtRangosPEN.ReadXml(readerPEN);
                readerPEN.Close();

               //Agregamos el datatable al dataset de parametros
                dsParam.Tables.Add(dtRangosPEN);*/
    
				return dsParam;

			}
			catch(Exception ex)
			{
				throw ex;
			}	
			


		}

		/// <summary>
		/// Funcion utilizada para obtener las categoria de riesgo.
		/// </summary>
		/// <returns>un datatable con los siguientes campos: id_riesgo, riesgo_des y factor_riesgo</returns>
		public static DataTable getCategoriaRiesgo()
		{
				
			OracleParameter[] arrParam  = new OracleParameter[1];

			arrParam[0] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
			arrParam[0].Direction = ParameterDirection.Output;


			String cmdStr= "SRP_MANTENIMIENTO_PKG.getCategoriaRiesgo";

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
		}

		public override void CargarDatos()
		{
			DataTable dt = new DataTable();

			dt = getParametros(this.myIDParametro);

			this.myDescripcion = dt.Rows[0]["parametro_des"].ToString();
			this.myTipoParametro = dt.Rows[0]["tipo_parametro"].ToString();
			this.myTipoCalculo = dt.Rows[0]["tipo_calculo"].ToString();

			dt.Dispose();
		}
		
		public override String GuardarCambios(string usuarioActualiza)
		{

			OracleParameter[] arrParam = new OracleParameter[6];

			arrParam[0] = new OracleParameter("p_id_parametro", OracleDbType.Decimal);
			arrParam[0].Value = this.IDParametro;

			arrParam[1] = new OracleParameter("p_descripcion", OracleDbType.NVarchar2,100);
			arrParam[1].Value = this.Descripcion;

			arrParam[2] = new OracleParameter("p_tipoparametro", OracleDbType.NVarchar2, 1);
			arrParam[2].Value = this.TipoParametro;
						
			arrParam[3] = new OracleParameter("p_tipocalculo", OracleDbType.NVarchar2, 1);
			arrParam[3].Value = this.TipoCalculo;

			arrParam[4] = new OracleParameter("p_ult_usuarioact", OracleDbType.NVarchar2, 35);
			arrParam[4].Value = usuarioActualiza;

			arrParam[5] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 100);
			arrParam[5].Direction = ParameterDirection.Output;

			String cmdStr= "SRP_MANTENIMIENTO_PKG.GuardarCambios";
			string result = string.Empty;
			
			try
			{
				DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr,arrParam);
				result = arrParam[5].Value.ToString();

				if(result.Substring(0,1) != "0" )
					throw new Exception(result.Replace("0",""));											 
								
			}
			catch(Exception ex)
			{
				throw ex;
			}

			return result;

		}

	}
}
