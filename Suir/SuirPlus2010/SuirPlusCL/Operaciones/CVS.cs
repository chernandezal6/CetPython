using SuirPlus.DataBase;
using Oracle.ManagedDataAccess.Client;
using System.Data;
using System;

namespace SuirPlus.Operaciones
{
	/// <summary>
	/// Summary description for CVS.
	/// </summary>
	public class CVS
	{
		public CVS()
		{
			//
			// TODO: Add constructor logic here
			//
		}
		public static DataTable get_DataLog(string FechaDesde, string FechaHasta, string TipoObjeto, string NombreObjeto, string Usuario) 
		{
			DataTable dt = new DataTable() ;
			string cmdStr = "CVS_PKG.get_Data_Log";
			OracleParameter[] arrParam = new OracleParameter[7];
 
			arrParam[0] = new OracleParameter("p_desde", OracleDbType.NVarchar2 ,1000);
			arrParam[0].Value = FechaDesde;

			arrParam[1] = new OracleParameter("p_hasta", OracleDbType.NVarchar2 ,1000);
			arrParam[1].Value = FechaHasta;

			arrParam[2] = new OracleParameter("p_tipo", OracleDbType.NVarchar2 ,1000);
			arrParam[2].Value = TipoObjeto;

			arrParam[3] = new OracleParameter("p_objeto", OracleDbType.NVarchar2 ,1000);
			arrParam[3].Value = NombreObjeto;

			arrParam[4] = new OracleParameter("p_usuario", OracleDbType.NVarchar2 ,1000);
			arrParam[4].Value = Usuario;
			
			arrParam[5] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 1000);
			arrParam[5].Direction = ParameterDirection.Output;

			arrParam[6] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
			arrParam[6].Direction = ParameterDirection.Output;
			
			try
			{
				return DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam).Tables[0];
			}
			catch(Exception ex)
			{
				throw ex;
			}
		}

		//Para sacar los campos de los script
		public static string get_Script(string IDLog) 
		{
			string script = string.Empty;
			string cmdStr = "CVS_PKG.get_Script";
			OracleParameter[] arrParam = new OracleParameter[3];
 
			arrParam[0] = new OracleParameter("p_id_auditoria", OracleDbType.NVarchar2 ,1000);
			arrParam[0].Value = IDLog;

			arrParam[1] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 1000);
			arrParam[1].Direction = ParameterDirection.Output;

			arrParam[2] = new OracleParameter("p_salida", OracleDbType.NVarchar2, 4000);
			arrParam[2].Direction = ParameterDirection.Output;
			
			try
			{
				DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
				script = arrParam[2].Value.ToString();
			}
			catch(Exception ex)
			{
				throw ex;
			}

			return script;
		}

	}
}
