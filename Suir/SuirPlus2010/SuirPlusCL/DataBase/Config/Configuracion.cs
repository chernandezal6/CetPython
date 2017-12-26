using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Oracle.ManagedDataAccess.Client;
using System.Data;

namespace SuirPlus.Config
{
    public class Configuracion
    {

        public ModuloEnum modulo;
        public string IDModulo;
        public string FTPHost;
        public string FTPUser;
        public string FTPPass;
        public string FTPPort;
        public string FTPDir;
        public string ArchivesDir;
        public string Archives_OK_DIR;
        public string Archives_ERR_DIR;
        public string Other1_DIR;
        public string Other2_DIR;
        public string Other3_DIR;
        public string User_Mails;
        public string DBA_Mails;
        public string PROG_Mails;
        public string Other1_Mails;
        public string Other2_Mails;
        public string Other3_Mails;
        public string Field1;
        public string Field2;
        public string Field3;
        public string Field4;

        public Configuracion(ModuloEnum modulo) {

            OracleParameter[] arrParam = new OracleParameter[3];
            arrParam[0] = new OracleParameter("p_id_modulo", OracleDbType.NVarchar2, 11);
            arrParam[0].Value = StringValueAttribute.GetStringValue(modulo);
            arrParam[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;
            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;


            string cmdStri = "Srp_Pkg.get_configuracion";

            try
            {
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStri, arrParam);
                string result = arrParam[2].Value.ToString();
                if (result == "0")
                {
                    if (ds.Tables.Count > 0)
                    {
                        if (ds.Tables[0].Rows.Count > 0)
                        {
                             
                             IDModulo = ds.Tables[0].Rows[0]["ID_MODULO"].ToString();
                             FTPHost = ds.Tables[0].Rows[0]["FTP_HOST"].ToString();
                             FTPUser = ds.Tables[0].Rows[0]["FTP_USER"].ToString();
                             FTPPass = ds.Tables[0].Rows[0]["FTP_PASS"].ToString();
                             FTPPort = ds.Tables[0].Rows[0]["FTP_PORT"].ToString();
                             FTPDir = ds.Tables[0].Rows[0]["FTP_DIR"].ToString();
                             ArchivesDir = ds.Tables[0].Rows[0]["ARCHIVES_DIR"].ToString();
                             Archives_OK_DIR = ds.Tables[0].Rows[0]["ARCHIVES_OK_DIR"].ToString();
                             Archives_ERR_DIR = ds.Tables[0].Rows[0]["ARCHIVES_ERR_DIR"].ToString();
                             Other1_DIR = ds.Tables[0].Rows[0]["OTHER1_DIR"].ToString();
                             Other2_DIR = ds.Tables[0].Rows[0]["OTHER2_DIR"].ToString();
                             Other3_DIR = ds.Tables[0].Rows[0]["OTHER3_DIR"].ToString();
                             User_Mails = ds.Tables[0].Rows[0]["USER_MAILS"].ToString();
                             DBA_Mails = ds.Tables[0].Rows[0]["DBA_MAILS"].ToString();
                             PROG_Mails = ds.Tables[0].Rows[0]["PROG_MAILS"].ToString();
                             Other1_Mails = ds.Tables[0].Rows[0]["OTHER1_MAILS"].ToString();
                             Other2_Mails = ds.Tables[0].Rows[0]["OTHER2_MAILS"].ToString();
                             Other3_Mails = ds.Tables[0].Rows[0]["OTHER3_MAILS"].ToString();
                             Field1 = ds.Tables[0].Rows[0]["FIELD1"].ToString();
                             Field2 = ds.Tables[0].Rows[0]["FIELD2"].ToString();
                             Field3 = ds.Tables[0].Rows[0]["FIELD3"].ToString();
                             Field4 = ds.Tables[0].Rows[0]["FIELD4"].ToString();
                            
                        }
                        else
                        {
                            throw new Exception("No hay data");
                        }
                    }
                    else
                    {
                        throw new Exception("No hay data");
                    }

                    
                }
                else
                {
                    throw new Exception(result);
                }

            }

            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;
            }

        }




    }
}
