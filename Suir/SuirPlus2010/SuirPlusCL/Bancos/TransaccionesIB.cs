using System;
using System.Data;
using Oracle.ManagedDataAccess.Client;
using SuirPlus.DataBase;
using SuirPlus.Empresas.Facturacion;

namespace SuirPlus.Bancos
{

        public class TransaccionesIB
	{
		public TransaccionesIB()
		{

		}

		public static void InsertarTransaccionIB(string IdReferencia, Factura.eConcepto IdTipoReferencia, string IdUsuario, string Password, string Respuesta, string Resultado)

		{

			OracleParameter[] arrParam  = new OracleParameter[7];

			arrParam[0] = new OracleParameter("p_id_referencia", OracleDbType.NVarchar2, 16);
			arrParam[0].Value = IdReferencia;

			arrParam[1] = new OracleParameter("p_id_tipo_referencia", OracleDbType.NVarchar2, 4);
			arrParam[1].Value = IdTipoReferencia;

			arrParam[2] = new OracleParameter("p_id_usuario", OracleDbType.NVarchar2, 35);
			arrParam[2].Value = IdUsuario;

			arrParam[3] = new OracleParameter("p_password", OracleDbType.NVarchar2, 32);
			arrParam[3].Value = Password;

			arrParam[4] = new OracleParameter("p_respuesta", OracleDbType.NVarchar2, 1024);
			arrParam[4].Value = Respuesta;

			arrParam[5] = new OracleParameter("p_resultado", OracleDbType.Char, 1);
			arrParam[5].Value = Resultado;
	
			arrParam[6] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 100);
			arrParam[6].Direction = ParameterDirection.Output;
						
			String cmdStr= "SFC_RECAUDO_IBANKING_XML_PKG.Insert_Trans_IB";
			string result = "0";

			try
			{
				DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr,arrParam);				
				result = arrParam[6].Value.ToString();		
				if(result != "0" )
					throw new Exception(result);
			}
			catch(Exception ex)
			{
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;
			}

		
		}

        // Trae todas las transacciones por IBanking para un IdReferencia y tipo de referencia especifico
		public static DataTable getTransaccionesReferencia(string IdReferencia)

		{
			OracleParameter[] arrParam  = new OracleParameter[3];

			arrParam[0] = new OracleParameter("p_id_referencia", OracleDbType.NVarchar2, 16);
			arrParam[0].Value = IdReferencia;

			arrParam[1] = new OracleParameter("p_IOCursor", OracleDbType.RefCursor);
			arrParam[1].Direction = ParameterDirection.Output;
		
			arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 100);
			arrParam[2].Direction = ParameterDirection.Output;

			String cmdStr= "SFC_RECAUDO_IBANKING_XML_PKG.Cons_Trans_IB_Referencia";
			string result = "0";

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
        
		// Trae todas las transacciones por IBanking para una Entidad Recaudadora especifica
		public static DataTable getTransaccionesEntRecaudadora(string IdEntRecaudadora,string FechaDesde, string FechaHasta)

		{
			OracleParameter[] arrParam  = new OracleParameter[5];

			arrParam[0] = new OracleParameter("p_id_Entidad_Recaudadora", OracleDbType.NVarchar2, 16);
			arrParam[0].Value = IdEntRecaudadora;

			arrParam[1] = new OracleParameter("p_IOCursor", OracleDbType.RefCursor);
			arrParam[1].Direction = ParameterDirection.Output;

			arrParam[2] = new OracleParameter("p_fecha_desde", OracleDbType.NVarchar2, 100);
			arrParam[2].Value = FechaDesde;

			arrParam[3] = new OracleParameter("p_fecha_hasta", OracleDbType.NVarchar2, 100);
			arrParam[3].Value = FechaHasta;
		
			arrParam[4] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 100);
			arrParam[4].Direction = ParameterDirection.Output;

			String cmdStr= "SFC_RECAUDO_IBANKING_XML_PKG.Cons_Trans_IB_EntRecaudadora";
			string result = "0";

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

	}
}
