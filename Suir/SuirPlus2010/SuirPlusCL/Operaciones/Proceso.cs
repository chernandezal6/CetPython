using SuirPlus.DataBase;
using Oracle.ManagedDataAccess.Client;
using System.Data;
using System;

namespace SuirPlus.Operaciones
{
	/// <summary>
	/// Procesos del SUIRPLUS
	/// </summary>
	public class Proceso : FrameWork.Objetos	
	{
		private string myIDProceso;
		private string myParametros;
		private string myUsuarioEjecuta;
		public string IDProceso
		{
			get {return this.myIDProceso;}
		}
		public string Parametros
		{
			get {return this.myParametros;}
			set {this.myParametros = value;}
		}
		public string UsuarioEjecuta
		{
			get {return this.myUsuarioEjecuta;}
			set {this.myUsuarioEjecuta = value;}
		}
		public Proceso(string IDProceso)
		{
			this.myIDProceso = IDProceso;
		}


		public static void EjecutarFacturacion()
		{
			String cmdStr= "srp_procesos_pkg.ejecutarFacturacion";
			
			try
			{
				DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr);									 
								
			}
			catch(Exception ex)
			{
				throw ex;
			}		
		}

		public static void EjecutarRecargoTSS()
		{
			String cmdStr= "srp_procesos_pkg.ejectutarRecargosTSS";
			
			try
			{
				DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr);									 
								
			}
			catch(Exception ex)
			{
				throw ex;
			}
		}

		public static void EjecutarRecargoDGII()
		{
			String cmdStr= "srp_procesos_pkg.ejectutarRecargosDGII";
			
			try
			{
				DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr);									 
								
			}
			catch(Exception ex)
			{
				throw ex;
			}		
		}

		
		public void EjecutarProceso()
		{

			OracleParameter[] arrParam = new OracleParameter[6];

			arrParam[1] = new OracleParameter("p_proceso", OracleDbType.NVarchar2,50);
			arrParam[1].Value = this.IDProceso;

			arrParam[2] = new OracleParameter("p_usuario", OracleDbType.NVarchar2, 50);
			arrParam[2].Value = this.myUsuarioEjecuta;
						
			arrParam[3] = new OracleParameter("p_parametros", OracleDbType.NVarchar2, 200);
			arrParam[3].Value = this.myParametros;

			String cmdStr= "srp_procesos_pkg.ejecutar";
			
			try
			{
				DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr,arrParam);									 
								
			}
			catch(Exception ex)
			{
				throw ex;
			}
		}

		public DataTable getHistorial()
		{
			OracleParameter[] arrParam  = new OracleParameter[3];

			arrParam[0] = new OracleParameter("p_id_proceso", OracleDbType.NVarchar2, 2);
			arrParam[0].Value = this.myIDProceso;

			arrParam[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
			arrParam[1].Direction = ParameterDirection.Output;

			arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
			arrParam[2].Direction = ParameterDirection.Output;

			String cmdStr= "srp_procesos_pkg.getHistorialProceso";

			try
			{
				return DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr,arrParam).Tables[0];
			}
			catch(Exception ex)
			{
				throw ex;
			}
		}

		public DataTable getProcesosBD()
		{
			OracleParameter[] arrParam  = new OracleParameter[1];

			arrParam[0] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
			arrParam[0].Direction = ParameterDirection.Output;

			String cmdStr= "srp_procesos_pkg.getSessionesActual";

			try
			{
				return DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr,arrParam).Tables[0];
			}
			catch(Exception ex)
			{
				throw ex;
			}
		}



	
		public static DataTable getProcesosAutomatizados()
		{
			OracleParameter[] arrParam  = new OracleParameter[2];

			arrParam[0] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
			arrParam[0].Direction = ParameterDirection.Output;

			arrParam[1] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
			arrParam[1].Direction = ParameterDirection.Output;

			String cmdStr= "srp_procesos_pkg.getListadoprocesos";

			try
			{
				return DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr,arrParam).Tables[0];
			}
			catch(Exception ex)
			{
				throw ex;
			}
		}
		public static void EjecutarArchivosNacha()
		{
		
			string cmdStr = "nch_pkg.job_lanzar";
					
//			try
//			{	
				OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr);
//			}
//			catch(Exception ex)
//			{
//				throw ex;
//			}
	
		}

		public override void CargarDatos()
		{

			OracleParameter[] arrParam  = new OracleParameter[3];

			arrParam[0] = new OracleParameter("p_id_proceso", OracleDbType.NVarchar2, 200);
			arrParam[0].Direction = ParameterDirection.Input;

			arrParam[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
			arrParam[1].Direction = ParameterDirection.Output;

			arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
			arrParam[2].Direction = ParameterDirection.Output;

			String cmdStr= "srp_procesos_pkg.CargarDatos";

			try
			{
				//DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr,arrParam).Tables[0];
			}
			catch(Exception ex)
			{
				throw ex;
			}
		}

		public override String GuardarCambios(string UsuarioResponsable)
		{
			return "";
		}



		public static DataTable getEstadisticaPeriodo(int periodo)
		{
		    OracleParameter[] arrParam = new OracleParameter [2];

			arrParam[0] = new OracleParameter("pPeriodo", OracleDbType.Decimal);
			arrParam[0].Value = periodo;

            arrParam[1] = new OracleParameter ("p_iocursor",OracleDbType.RefCursor);
			arrParam[1].Direction = ParameterDirection.Output;


            string cmdStr = "sfc_estadistica_procesos_pkg.getEstadisticaPeriodo";

			try
			{
				return DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr,arrParam).Tables[0];
			}
			catch(Exception ex)
			{
				throw ex;
			}
		
		
		}

        public DataTable Getproceso()
        {

            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_id_proceso", OracleDbType.NVarchar2, 200);
            arrParam[0].Value = this.myIDProceso;

            arrParam[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;

            String cmdStr = "srp_procesos_pkg.CargarDatos";

            try
            {
               return DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr,arrParam).Tables[0];
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

	}
}
