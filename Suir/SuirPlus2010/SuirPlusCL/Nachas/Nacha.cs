using SuirPlus.DataBase;
using Oracle.ManagedDataAccess.Client;
using System.Data;
using System;

namespace SuirPlus.Nachas
{
	/// <summary>
	/// Summary description for Nacha.
	/// </summary>
	public class Nacha 
	{
		public Nacha()
		{
			//
			// TODO: Add constructor logic here
			//
		}

		public static DataTable getArchivosCargadosDelDia(DateTime fechadesde, DateTime fechahasta) 
		{
			DataTable dt = new DataTable() ;
			string cmdStr = "NCH_PKG.get_archivos_del_dia";
			OracleParameter[] arrParam = new OracleParameter[4];

            arrParam[0] = new OracleParameter("p_fechadesde", OracleDbType.Date);
            arrParam[0].Value = fechadesde;

            arrParam[1] = new OracleParameter("p_fechahasta", OracleDbType.Date);
            arrParam[1].Value = fechahasta;
 
			arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 1000);
			arrParam[2].Direction = ParameterDirection.Output;

			arrParam[3] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
			arrParam[3].Direction = ParameterDirection.Output;
			
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

        public static string CargarNachasFaltantes()
        { 
            
			
			OracleParameter[] arrParam = new OracleParameter[1];

			arrParam[0] = new OracleParameter("p_return", OracleDbType.NVarchar2, 1000);
			arrParam[0].Direction = ParameterDirection.Output;
            string cmdStr = "nch_pkg.carga";
            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                return arrParam[0].Value.ToString();
            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;

            }
        }
	}
}
