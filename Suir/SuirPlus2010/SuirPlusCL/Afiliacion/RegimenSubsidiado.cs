using System;
using System.Data;
using Oracle.ManagedDataAccess.Client;
using SuirPlus.DataBase;

namespace SuirPlus.Afiliacion
{
    public class RegimenSubsidiado
    {

        private RegimenSubsidiado()
        {
            //No es necesario hacer una instancia de esta clase.
        }


        public static DataTable ConsultaSubsidiado(string no_documento, string id_nss)
        {


            string cmdStr = "SFS_SUBSIDIADOS_PKG.consultasubsidiado";

            OracleParameter[] arrParam = new OracleParameter[4];

            arrParam[0] = new OracleParameter("p_no_documento", OracleDbType.NVarchar2, 11);
            arrParam[0].Value = no_documento;

            arrParam[1] = new OracleParameter("p_id_nss", OracleDbType.NVarchar2, 9);
            arrParam[1].Value = id_nss;

            arrParam[2] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[2].Direction = ParameterDirection.Output;

            arrParam[3] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 1000);
            arrParam[3].Direction = ParameterDirection.Output;

            try
            {
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);
              //  resultnumber = arrParam[3].Value.ToString().Equals("null") ? string.Empty : arrParam[3].Value.ToString();
              
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
