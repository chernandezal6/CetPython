using System;
using System.Data;
using SuirPlus;
using Oracle.ManagedDataAccess.Client;
using SuirPlus.DataBase;

namespace SuirPlus.Finanzas
{
    public class DevolucionAportes
    {
/// <summary>
/// Busca las reclamaciones de acuerdo a los parametros especificados..
/// </summary>
/// <param name="desde"></param>
/// <param name="hasta"></param>
/// <param name="rnc"></param>
/// <param name="reclamacion"></param>
/// <param name="status"></param>
/// <param name="pageNum"></param>
/// <param name="pageSize"></param>
/// <returns></returns>
        public static DataTable getReclamaciones(string desde, string hasta, string rnc, string reclamacion,string status, int pageNum, int pageSize)
            
        {
            OracleParameter[] arrParam = new OracleParameter[9];

            arrParam[0] = new OracleParameter("p_desde", OracleDbType.Date);
            if (desde != string.Empty)
            {
                arrParam[0].Value = Convert.ToDateTime(desde);
            }
            arrParam[1] = new OracleParameter("p_hasta", OracleDbType.Date);
            if (hasta != string.Empty)
            {
                arrParam[1].Value = Convert.ToDateTime(hasta);
            }
            arrParam[2] = new OracleParameter("p_rnc", OracleDbType.Varchar2);
            arrParam[2].Value = rnc;

            arrParam[3] = new OracleParameter("p_nro_reclamacion", OracleDbType.Varchar2);
            arrParam[3].Value = reclamacion;

            arrParam[4] = new OracleParameter("p_estatus", OracleDbType.Varchar2);
            arrParam[4].Value = status;

            arrParam[5] = new OracleParameter("p_pagenum", OracleDbType.Int32);
            arrParam[5].Value = pageNum;

            arrParam[6] = new OracleParameter("p_pagesize", OracleDbType.Int32);
            arrParam[6].Value = pageSize;

            arrParam[7] = new OracleParameter("p_resultNumber", OracleDbType.NVarchar2, 200);
            arrParam[7].Direction = ParameterDirection.Output;
            
            arrParam[8] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[8].Direction = ParameterDirection.Output;

            String cmdStr = "dva_manejo_pkg.get_reclamaciones";

            try
            {
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);

                if (arrParam[7].Value.ToString() != "0")
                    
                {
                    throw new Exception(arrParam[7].Value.ToString().Split('|')[1]);
                }

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
/// Busca los detalles las Reclamaiones de acuerdo a los parametros especificados.
/// </summary>
/// <param name="reclamacion"></param>
/// <param name="status"></param>
/// <param name="pageNum"></param>
/// <param name="pageSize"></param>
/// <returns></returns>
        public static DataTable getDetReclamaciones(string reclamacion, string status, int pageNum, int pageSize)
        {
            OracleParameter[] arrParam = new OracleParameter[6];

            arrParam[0] = new OracleParameter("p_nro_reclamacion", OracleDbType.Varchar2);
            arrParam[0].Value = reclamacion;

            arrParam[1] = new OracleParameter("p_estatus", OracleDbType.Varchar2);
            arrParam[1].Value = status;

            arrParam[2] = new OracleParameter("p_pagenum", OracleDbType.Int32);
            arrParam[2].Value = pageNum;

            arrParam[3] = new OracleParameter("p_pagesize", OracleDbType.Int32);
            arrParam[3].Value = pageSize;
            
            arrParam[4] = new OracleParameter("p_resultNumber", OracleDbType.NVarchar2, 200);
            arrParam[4].Direction = ParameterDirection.Output;
            
            arrParam[5] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[5].Direction = ParameterDirection.Output;

            String cmdStr = "dva_manejo_pkg.get_Det_Reclamacion";

            try
            {
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);

                if (arrParam[4].Value.ToString() != "0")
                {
                    throw new Exception(arrParam[4].Value.ToString().Split('|')[1]);
                }

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
///  Modifica el estatus de las Reclamacion 
/// </summary>
/// <param name="reclamacion"></param>
/// <param name="status"></param>
        public static void MarcarReclamacion(string reclamacion, string status)
        {

            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_nro_reclamacion", OracleDbType.Varchar2);
            arrParam[0].Value = reclamacion;

            arrParam[1] = new OracleParameter("p_status", OracleDbType.Varchar2);
            arrParam[1].Value = status;

            arrParam[2] = new OracleParameter("p_resultNumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;


            string resultado = string.Empty;
            String cmdStr = "dva_manejo_pkg.MarcarReclamacion";
            try
            {
                OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                if (arrParam[2].Value.ToString() != "0")
                {
                    throw new Exception(arrParam[2].Value.ToString());
                }
                              
            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;
            }

        }

        public static void EnviarUNIPAGO(string reclamacion)
        {

            OracleParameter[] arrParam = new OracleParameter[2];

            arrParam[0] = new OracleParameter("p_nro_reclamacion", OracleDbType.Varchar2);
            arrParam[0].Value = reclamacion;

            arrParam[1] = new OracleParameter("p_result", OracleDbType.NVarchar2, 200);
            arrParam[1].Direction = ParameterDirection.Output;


            string resultado = string.Empty;
            String cmdStr = "dva_manejo_pkg.enviar_UNIPAGO";
            try
            {
                OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                if (arrParam[1].Value.ToString() != "OK")
                {
                    throw new Exception(arrParam[1].Value.ToString());
                }

            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;
            }

        }

        public static void EntregarFondos(string reclamacion, string TipoDoc, string NroDocumento, string NroCheque, string Status, string EntregadoPor)
        {

            OracleParameter[] arrParam = new OracleParameter[7];

            arrParam[0] = new OracleParameter("p_nro_reclamacion", OracleDbType.Varchar2);
            arrParam[0].Value = reclamacion;

            arrParam[1] = new OracleParameter("p_tipoDoc", OracleDbType.Varchar2);
            arrParam[1].Value = TipoDoc;

            arrParam[2] = new OracleParameter("p_nro_documento", OracleDbType.Varchar2);
            arrParam[2].Value = NroDocumento;

            arrParam[3] = new OracleParameter("p_nro_cheque", OracleDbType.Varchar2);
            arrParam[3].Value = NroCheque;

            arrParam[4] = new OracleParameter("p_status", OracleDbType.Varchar2);
            arrParam[4].Value = Status;

            arrParam[5] = new OracleParameter("p_entregado_por", OracleDbType.Varchar2);
            arrParam[5].Value = EntregadoPor;

            arrParam[6] = new OracleParameter("p_resultNumber", OracleDbType.NVarchar2, 200);
            arrParam[6].Direction = ParameterDirection.Output;


            string resultado = string.Empty;
            String cmdStr = "dva_manejo_pkg.entregarfondos";
            try
            {
                OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                if (arrParam[6].Value.ToString() != "0")
                {
                    throw new Exception(arrParam[6].Value.ToString());
                }

            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;
            }

        }

        public static string ValidaCiudadano(string p_no_documento, string p_tipo_documento)
        {

            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_no_documento", OracleDbType.Varchar2);
            arrParam[0].Value = p_no_documento;

            arrParam[1] = new OracleParameter("p_tipo_documento", OracleDbType.Varchar2);
            arrParam[1].Value = p_tipo_documento;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;

            string resultado = string.Empty;
            String cmdStr = "dva_manejo_pkg.ValidaCiudadano";
            try
            {
                OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                //if (arrParam[2].Value.ToString() != "0")
                //{

                //   // throw new Exception(arrParam[2].Value.ToString());
                //} 
                resultado = arrParam[2].Value.ToString();
                return resultado;
             
            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;
            }

        }

        public static DataTable GetPagosExceso(string Cedula)
        {

            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("P_cedula", OracleDbType.NVarchar2, 25);
            arrParam[0].Value = Cedula;

            arrParam[1] = new OracleParameter("p_io_cursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;

            string cmdStri = "DVA_MANEJO_PKG.GetPagosExceso";

            try
            {
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStri, arrParam);
                if (ds.Tables.Count > 0)
                {
                    return ds.Tables[0];
                }
                else
                {
                    throw new Exception("No hay Data");
                }

            }

            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;
            }
        }

        public static DataTable GetPagosExcesoCiudadano(string Cedula)
        {

            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("P_cedula", OracleDbType.NVarchar2, 25);
            arrParam[0].Value = Cedula;

            arrParam[1] = new OracleParameter("p_io_cursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;

            string cmdStri = "DVA_MANEJO_PKG.GetPagosExcesoCiudadanos";

            try
            {
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStri, arrParam);
                if (arrParam[2].Value.ToString() != "0")
                {
                    throw new Exception(arrParam[2].Value.ToString().Split('|')[1]);
                }

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
        public static DataTable GetPagosExcesoEmpresa(string RNC)
        {

            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("P_RNC", OracleDbType.NVarchar2, 25);
            arrParam[0].Value = RNC;

            arrParam[1] = new OracleParameter("p_io_cursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;

            string cmdStri = "DVA_MANEJO_PKG.GetPagosExcesoEmpresa";

            try
            {
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStri, arrParam);
                if (ds.Tables.Count > 0)
                {
                    return ds.Tables[0];
                }
                else
                {
                    throw new Exception("No hay Data");
                }

            }

            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;
            }
        }

        public static DataTable getNachasPendientes()
        {

            OracleParameter[] arrParam = new OracleParameter[2];

            arrParam[0] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[0].Direction = ParameterDirection.Output;

            arrParam[1] = new OracleParameter("p_io_cursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            string cmdStri = "dva_manejo_pkg.getnachas";

            try
            {
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStri, arrParam);
                if (ds.Tables.Count > 0)
                {
                    return ds.Tables[0];
                }
                else
                {
                    throw new Exception("No hay Data");
                }

            }

            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;
            }
        }

        public static void aprobarNachaPendiente(string archivoNacha, string usuarioAprueba)
        {

            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_nacha", OracleDbType.Varchar2);
            arrParam[0].Value = archivoNacha;

            arrParam[1] = new OracleParameter("p_usuario", OracleDbType.NVarchar2, 35);
            arrParam[1].Value = usuarioAprueba;

            arrParam[2] = new OracleParameter("p_resultNumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;


            string resultado = string.Empty;
            String cmdStr = "dva_manejo_pkg.aprobarnacha";
            try
            {
                OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                if (arrParam[2].Value.ToString() != "0")
                {
                    throw new Exception(arrParam[2].Value.ToString().Split('|')[1]);
                }

            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;
            }

        }

        public static void rechazarNachaPendiente(string archivoNacha, string usuarioRechaza)
        {

            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_nacha", OracleDbType.Varchar2);
            arrParam[0].Value = archivoNacha;

            arrParam[1] = new OracleParameter("p_usuario", OracleDbType.NVarchar2, 35);
            arrParam[1].Value = usuarioRechaza;

            arrParam[2] = new OracleParameter("p_resultNumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;


            string resultado = string.Empty;
            String cmdStr = "dva_manejo_pkg.rechazarNacha";
            try
            {
                OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                if (arrParam[2].Value.ToString() != "0")
                {
                    throw new Exception(arrParam[2].Value.ToString().Split('|')[1]);
                }

            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;
            }

        }

        public static DataTable getDetNachas(string archivoNacha, int pageNum, int pageSize)
        {
            OracleParameter[] arrParam = new OracleParameter[5];

            arrParam[0] = new OracleParameter("p_archivo_nacha", OracleDbType.Varchar2);
            arrParam[0].Value = archivoNacha;

            arrParam[1] = new OracleParameter("p_pagenum", OracleDbType.Int32);
            arrParam[1].Value = pageNum;

            arrParam[2] = new OracleParameter("p_pagesize", OracleDbType.Int32);
            arrParam[2].Value = pageSize;
            
            arrParam[3] = new OracleParameter("p_resultNumber", OracleDbType.NVarchar2, 200);
            arrParam[3].Direction = ParameterDirection.Output;
            
            arrParam[4] = new OracleParameter("p_io_cursor", OracleDbType.RefCursor);
            arrParam[4].Direction = ParameterDirection.Output;

            String cmdStr = "dva_manejo_pkg.getDetNachas";

            try
            {
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);

                if (arrParam[3].Value.ToString() != "0")
                {
                    throw new Exception(arrParam[4].Value.ToString().Split('|')[1]);
                }

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

        public static bool TieneFactPagadas(string registro_patronal)
        {
            OracleParameter[] arrParam = new OracleParameter[2];

            arrParam[0] = new OracleParameter("p_registro_patronal", OracleDbType.Varchar2);
            arrParam[0].Value = registro_patronal;

            arrParam[1] = new OracleParameter("p_result", OracleDbType.NVarchar2, 200);
            arrParam[1].Direction = ParameterDirection.Output;

            bool resultado = false;
            String cmdStr = "dva_manejo_pkg.tienefactpagadas";
            try
            {
                OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);

                if (arrParam[1].Value.ToString() == "N")
                {
                    resultado = false;
                }
                if (arrParam[1].Value.ToString() == "S")
                {
                    resultado = true;
                }

                return resultado;
            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;
            }

        }

        public static DataTable getStatusDA()
        {
            OracleParameter[] arrParam = new OracleParameter[2];


            arrParam[0] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[0].Direction = ParameterDirection.Output;

            arrParam[1] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[1].Direction = ParameterDirection.Output;

            String cmdStr = "dva_manejo_pkg.getstatus";

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

        public static DataTable getMsgPagosExceso(string modulo)
        {
            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_id_modulo", OracleDbType.Varchar2);
            arrParam[0].Value = modulo;

            arrParam[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;

            String cmdStr = "srp_pkg.get_configuracion";

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
