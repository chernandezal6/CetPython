using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Oracle.ManagedDataAccess.Client;
using SuirPlus.DataBase;
using System.Data;
using SuirPlus.Exepciones;

namespace SuirPlus.Empresas.SubsidiosSFS
{
    public class Consultas
    {
        
        public static DataTable getPagosExcesoRepresentante(int id_registro_patronal, string Referencia)
        {
            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_id_registro_patronal", OracleDbType.Int32);
            arrParam[0].Direction = ParameterDirection.Input;
            arrParam[0].Value = id_registro_patronal;

            arrParam[1] = new OracleParameter("p_referencia", OracleDbType.NVarchar2, 16);
            arrParam[1].Value = Referencia;


            arrParam[2] = new OracleParameter("p_IO_Cursor", OracleDbType.RefCursor);
            arrParam[2].Direction = ParameterDirection.Output;

            string cmdstr = "SRE_EMPLEADORES_PKG.getPagosExcesoRepresentante";

            try
            {
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdstr, arrParam);
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
        public static DataTable getPagosExcesoExterno(string documento)
        {
            OracleParameter[] arrParam = new OracleParameter[2];

            arrParam[0] = new OracleParameter("p_Nro_Documento", OracleDbType.NVarchar2);
            arrParam[0].Direction = ParameterDirection.Input;
            arrParam[0].Value = documento;

            arrParam[1] = new OracleParameter("p_IO_Cursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;


            string cmdstr = "sre_empleadores_pkg.getPagosExcesoExterno";

            try
            {
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdstr, arrParam);
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
        ///  Metodo para obtener los datos elegibles del subsidio de lactancia de un id_registro_patronal
        /// </summary>
        /// <param name="id_registro_patronal">Registro patronal del cual desean ver los datos elegibles.</param>
        /// <returns>Retorna un DataTable cargado con los datos elegibles del registro patronal especificado.</returns>
        public static DataTable getElegibilidadLactancia(int id_registro_patronal)
        {
            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_id_registro_patronal", OracleDbType.Int32);
            arrParam[0].Direction = ParameterDirection.Input;
            arrParam[0].Value = id_registro_patronal;

            arrParam[1] = new OracleParameter("p_IOCursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_result_number", OracleDbType.Varchar2, 500);
            arrParam[2].Direction = ParameterDirection.Output;
            arrParam[2].Size = 1024;

            string cmdstr = "sfs_subsidios_pkg.ConsultaLactancia";

            try
            {
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdstr, arrParam);
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
        /// Metodo para obtener los pagos realizados exitosamente via Cuenta Bancaria.
        /// </summary>
        /// <param name="id_registro_patronal">Registro Patronal que se desea ver los pagos realizados exitosamente via Cuenta Bancaria.</param>
        /// <returns>Retorna DataTable Cargado con los pagos realizados exitosamente via Cuenta Bancaria</returns>
        public static DataTable getPagoCuentaBancaria(int id_registro_patronal, Int16 pageNum, Int16 pageSize, string cedula)
        {
            OracleParameter[] arrParam = new OracleParameter[6];

            arrParam[0] = new OracleParameter("p_id_registro_patronal", OracleDbType.Int32);
            arrParam[0].Direction = ParameterDirection.Input;
            arrParam[0].Value = id_registro_patronal;

            arrParam[1] = new OracleParameter("p_pagenum", OracleDbType.Int16);
            arrParam[1].Value = pageNum;

            arrParam[2] = new OracleParameter("p_pagesize", OracleDbType.Int16);
            arrParam[2].Value = pageSize;

            arrParam[3] = new OracleParameter("p_cedula", OracleDbType.NVarchar2);
            if (cedula.Equals(string.Empty))
            {
                arrParam[3].Value = DBNull.Value;
            }
            else
            {
                arrParam[3].Value = cedula;
            }

            arrParam[4] = new OracleParameter("p_IOCursor", OracleDbType.RefCursor);
            arrParam[4].Direction = ParameterDirection.Output;

            arrParam[5] = new OracleParameter("p_result_number", OracleDbType.Varchar2, 500);
            arrParam[5].Direction = ParameterDirection.Output;
            arrParam[5].Size = 1024;
            string cmdstr = "SFS_SUBSIDIOS_PKG.ConsultaPagoCuentaBancaria";

            try
            {
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdstr, arrParam);
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
        public static DataTable getPagoEnfCuentaBancaria(int id_registro_patronal, Int16 pageNum, Int16 pageSize, string cedula)
        {
            OracleParameter[] arrParam = new OracleParameter[6];

            arrParam[0] = new OracleParameter("p_id_registro_patronal", OracleDbType.Int32);
            arrParam[0].Direction = ParameterDirection.Input;
            arrParam[0].Value = id_registro_patronal;

            arrParam[1] = new OracleParameter("p_pagenum", OracleDbType.Int16);
            arrParam[1].Value = pageNum;

            arrParam[2] = new OracleParameter("p_pagesize", OracleDbType.Int16);
            arrParam[2].Value = pageSize;

            arrParam[3] = new OracleParameter("p_cedula", OracleDbType.NVarchar2);
            if (cedula.Equals(string.Empty))
            {
                arrParam[3].Value = DBNull.Value;
            }
            else
            {
                arrParam[3].Value = cedula;
            }

            arrParam[4] = new OracleParameter("p_IOCursor", OracleDbType.RefCursor);
            arrParam[4].Direction = ParameterDirection.Output;

            arrParam[5] = new OracleParameter("p_result_number", OracleDbType.Varchar2, 500);
            arrParam[5].Direction = ParameterDirection.Output;
            arrParam[5].Size = 1024;
            string cmdstr = "SFS_SUBSIDIOS_PKG.ConsultaPagoEnfCuentaBancaria";

            try
            {
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdstr, arrParam);
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
        /// Metodo para obtener los pagos realizados exitosamente via Notificaciones de Pago. 
        /// </summary>
        /// <param name="id_registro_patronal">Registro Patronal que se desea ver los pagos realizados exitosamente via Notificaciones de Pago.</param>
        /// <returns>Retorna DataTable Cargado con los pagos realizados exitosamente via Notificaciones de Pago.</returns>
        public static DataTable getPagoNotificacionPago(int id_registro_patronal, Int16 pageNum, Int16 pageSize, string cedula)
        {
            OracleParameter[] arrParam = new OracleParameter[6];

            arrParam[0] = new OracleParameter("p_id_registro_patronal", OracleDbType.Int32);
            arrParam[0].Direction = ParameterDirection.Input;
            arrParam[0].Value = id_registro_patronal;

            arrParam[1] = new OracleParameter("p_pagenum", OracleDbType.Int16);
            arrParam[1].Value = pageNum;

            arrParam[2] = new OracleParameter("p_pagesize", OracleDbType.Int16);
            arrParam[2].Value = pageSize;

            arrParam[3] = new OracleParameter("p_cedula", OracleDbType.NVarchar2);
            if (cedula.Equals(string.Empty))
            {
                arrParam[3].Value = DBNull.Value;
            }
            else
            {
                arrParam[3].Value = cedula;
            }

            arrParam[4] = new OracleParameter("p_IOCursor", OracleDbType.RefCursor);
            arrParam[4].Direction = ParameterDirection.Output;

            arrParam[5] = new OracleParameter("p_result_number", OracleDbType.Varchar2, 500);
            arrParam[5].Direction = ParameterDirection.Output;
            arrParam[5].Size = 1024;

            string cdmStr = "SFS_SUBSIDIOS_PKG.ConsultaPagoNotificacionPago";
            try
            {
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cdmStr, arrParam);
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
        public static DataTable getPagoEnfNotificacionPago(int id_registro_patronal, Int16 pageNum, Int16 pageSize, string cedula)
        {
            OracleParameter[] arrParam = new OracleParameter[6];

            arrParam[0] = new OracleParameter("p_id_registro_patronal", OracleDbType.Int32);
            arrParam[0].Direction = ParameterDirection.Input;
            arrParam[0].Value = id_registro_patronal;

            arrParam[1] = new OracleParameter("p_pagenum", OracleDbType.Int16);
            arrParam[1].Value = pageNum;

            arrParam[2] = new OracleParameter("p_pagesize", OracleDbType.Int16);
            arrParam[2].Value = pageSize;

            arrParam[3] = new OracleParameter("p_cedula", OracleDbType.NVarchar2);
            if (cedula.Equals(string.Empty))
            {
                arrParam[3].Value = DBNull.Value;
            }
            else
            {
                arrParam[3].Value = cedula;
            }

            arrParam[4] = new OracleParameter("p_IOCursor", OracleDbType.RefCursor);
            arrParam[4].Direction = ParameterDirection.Output;

            arrParam[5] = new OracleParameter("p_result_number", OracleDbType.Varchar2, 500);
            arrParam[5].Direction = ParameterDirection.Output;
            arrParam[5].Size = 1024;

            string cdmStr = "SFS_SUBSIDIOS_PKG.ConsPagoEnfNotificacionPago";
            try
            {
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cdmStr, arrParam);
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
        ///  Metodo para obtener los pagos que dieron error. 
        /// </summary>
        /// <param name="id_registro_patronal">Registro Patronal el cual desea ver los pagos que dieron error.</param>
        /// <returns>Retornar DataTable Cargado con los pagos que dieron errores.</returns>
        public static DataTable getPagoError(int id_registro_patronal, Int16 pageNum, Int16 pageSize, string cedula)
        {
            OracleParameter[] arrParam = new OracleParameter[6];

            arrParam[0] = new OracleParameter("p_id_registro_patronal", OracleDbType.Int32);
            arrParam[0].Direction = ParameterDirection.Input;
            arrParam[0].Value = id_registro_patronal;

            arrParam[1] = new OracleParameter("p_pagenum", OracleDbType.Int16);
            arrParam[1].Value = pageNum;

            arrParam[2] = new OracleParameter("p_pagesize", OracleDbType.Int16);
            arrParam[2].Value = pageSize;

            arrParam[3] = new OracleParameter("p_cedula", OracleDbType.NVarchar2);
            if (cedula.Equals(string.Empty))
            {
                arrParam[3].Value = DBNull.Value;
            }
            else
            {
                arrParam[3].Value = cedula;
            }

            arrParam[4] = new OracleParameter("p_IOCursor", OracleDbType.RefCursor);
            arrParam[4].Direction = ParameterDirection.Output;

            arrParam[5] = new OracleParameter("p_result_number", OracleDbType.Varchar2, 500);
            arrParam[5].Direction = ParameterDirection.Output;
            arrParam[5].Size = 1024;

            string cmdStr = "SFS_SUBSIDIOS_PKG.ConsultaPagoError";
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
        public static DataTable getPagoEnfError(int id_registro_patronal, Int16 pageNum, Int16 pageSize, string cedula)
        {
            OracleParameter[] arrParam = new OracleParameter[6];

            arrParam[0] = new OracleParameter("p_id_registro_patronal", OracleDbType.Int32);
            arrParam[0].Direction = ParameterDirection.Input;
            arrParam[0].Value = id_registro_patronal;

            arrParam[1] = new OracleParameter("p_pagenum", OracleDbType.Int16);
            arrParam[1].Value = pageNum;

            arrParam[2] = new OracleParameter("p_pagesize", OracleDbType.Int16);
            arrParam[2].Value = pageSize;

            arrParam[3] = new OracleParameter("p_cedula", OracleDbType.NVarchar2);
            if (cedula.Equals(string.Empty))
            {
                arrParam[3].Value = DBNull.Value;
            }
            else
            {
                arrParam[3].Value = cedula;
            }

            arrParam[4] = new OracleParameter("p_IOCursor", OracleDbType.RefCursor);
            arrParam[4].Direction = ParameterDirection.Output;

            arrParam[5] = new OracleParameter("p_result_number", OracleDbType.Varchar2, 500);
            arrParam[5].Direction = ParameterDirection.Output;
            arrParam[5].Size = 1024;

            string cmdStr = "SFS_SUBSIDIOS_PKG.ConsultaPagoEnfError";
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
        public static DataTable getInfoSubs(int id_registro_patronal, Int16 pageNum, Int16 pageSize, string cedula)
        {
            OracleParameter[] arrParam = new OracleParameter[6];

            arrParam[0] = new OracleParameter("p_id_registro_patronal", OracleDbType.Int32);
            arrParam[0].Direction = ParameterDirection.Input;
            arrParam[0].Value = id_registro_patronal;

            arrParam[1] = new OracleParameter("p_pagenum", OracleDbType.Int16);
            arrParam[1].Value = pageNum;

            arrParam[2] = new OracleParameter("p_pagesize", OracleDbType.Int16);
            arrParam[2].Value = pageSize;

            arrParam[3] = new OracleParameter("p_cedula", OracleDbType.NVarchar2);
            if (cedula.Equals(string.Empty))
            {
                arrParam[3].Value = DBNull.Value;
            }
            else
            {
                arrParam[3].Value = cedula;
            }

            arrParam[4] = new OracleParameter("p_IOCursor", OracleDbType.RefCursor);
            arrParam[4].Direction = ParameterDirection.Output;

            arrParam[5] = new OracleParameter("p_result_number", OracleDbType.Varchar2, 500);
            arrParam[5].Direction = ParameterDirection.Output;
            arrParam[5].Size = 1024;
            string cmdStr = "SFS_SUBSIDIOS_PKG.getInfoSubs";
            try
            {
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);
                string Resultado = arrParam[5].Value.ToString();

                if (Resultado != "0")
                {
                    DataTable dt = new DataTable();
                    Utilitarios.Utils.agregarMensajeError(Resultado, ref dt);
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
                
        
        public static string validaRNCoCedula(string rnc_o_cedula)
        {
            string cmdStr = "SFS_SUBSIDIOS_PKG.IsExisteRnc_o_Cedula";
            int resValidacion;
            string Resultado = string.Empty;
            string res = string.Empty;

            OracleParameter[] arrParam = new OracleParameter[3];
            arrParam[0] = new OracleParameter("p_Rnc_o_Cedula", OracleDbType.Varchar2);
            arrParam[0].Value = rnc_o_cedula;

            arrParam[1] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 1000);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_nombre_razonsocial", OracleDbType.NVarchar2, 100);
            arrParam[2].Direction = ParameterDirection.Output;
            try
            {
                resValidacion = DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                Resultado = arrParam[1].Value.ToString();

                if (Resultado != "1")
                {
                    res = Resultado.Split('|')[1].ToString();
                    throw new Exception(res);
                }
                Resultado = arrParam[2].Value.ToString();
                return Resultado;
            }

            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;
            }


        }
        public static string ValidarRNCoCedula(string rnc_o_cedula)
        {
            string cmdStr = "Sre_Empleadores_Pkg.isRncOCedulaValida";
            int resValidacion;
            string Resultado = string.Empty;
            string res = string.Empty;

            OracleParameter[] arrParam = new OracleParameter[1];
            arrParam[0] = new OracleParameter("p_Rnc_o_Cedula", OracleDbType.Varchar2);
            arrParam[0].Value = rnc_o_cedula;




            try
            {
                resValidacion = DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                //Resultado = arrParam[1].Value.ToString();

                if (Resultado != "1")
                {
                    res = Resultado.ToString();
                    throw new Exception(res);
                }
                //Resultado = arrParam[1].Value.ToString();
                return resValidacion.ToString();
            }

            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;
            }


        }

        public static DataTable getCuentasPorPagar(String desde, String hasta, String rnc_o_cedula, String NoDocumentoM, String TipoSub, Int16 pageNum, Int16 pageSize)
        {
            OracleParameter[] arrParam = new OracleParameter[9];

            arrParam[0] = new OracleParameter("p_rnc_o_cedula", OracleDbType.Varchar2);
            arrParam[0].Value = rnc_o_cedula;

            arrParam[1] = new OracleParameter("p_cedula_madre", OracleDbType.Varchar2);
            arrParam[1].Value = NoDocumentoM;

            arrParam[2] = new OracleParameter("p_tipo_subsidio", OracleDbType.Varchar2);
            arrParam[2].Value = TipoSub;

            arrParam[3] = new OracleParameter("p_periodo_desde", OracleDbType.Int32);
            if (desde != string.Empty)
            {
                arrParam[3].Value = Convert.ToInt32(desde);
            }

            arrParam[4] = new OracleParameter("p_periodo_hasta", OracleDbType.Int32);
            if (hasta != string.Empty)
            {
                arrParam[4].Value = Convert.ToInt32(hasta);
            }

            arrParam[5] = new OracleParameter("p_pagenum", OracleDbType.Int16);
            arrParam[5].Value = pageNum;

            arrParam[6] = new OracleParameter("p_pagesize", OracleDbType.Int16);
            arrParam[6].Value = pageSize;

            arrParam[7] = new OracleParameter("p_io_cursor", OracleDbType.RefCursor);
            arrParam[7].Direction = ParameterDirection.Output;

            arrParam[8] = new OracleParameter("p_result_number", OracleDbType.Varchar2, 200);
            arrParam[8].Direction = ParameterDirection.Output;

            string cmdStr = "sfs_subsidios_pkg.getpagecuentasporpagar";
            string res = string.Empty;
            try
            {
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);
                if (ds.Tables.Count > 0)
                {
                    return ds.Tables[0];
                }

                res = arrParam[8].Value.ToString();
                throw new Exception(res);
            }

            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                return null;
            }

        }

        
        //////Reporte pago lactancia////// 

        public static DataTable getPagosLactancia(int registro_patronal, Int16 pageNum, Int16 pageSize, string cedula)
        {
            OracleParameter[] arrParam = new OracleParameter[6];

            arrParam[0] = new OracleParameter("p_id_registro_patronal", OracleDbType.Varchar2);
            arrParam[0].Value = registro_patronal;

            arrParam[1] = new OracleParameter("p_pagenum", OracleDbType.Int16);
            arrParam[1].Value = pageNum;

            arrParam[2] = new OracleParameter("p_pagesize", OracleDbType.Int16);
            arrParam[2].Value = pageSize;

            arrParam[3] = new OracleParameter("p_cedula", OracleDbType.NVarchar2);
            if (cedula.Equals(string.Empty))
            {
                arrParam[3].Value = DBNull.Value;
            }
            else
            {
                arrParam[3].Value = cedula;
            }

            arrParam[4] = new OracleParameter("p_io_cursor", OracleDbType.RefCursor);
            arrParam[4].Direction = ParameterDirection.Output;

            arrParam[5] = new OracleParameter("p_resultnumber", OracleDbType.Varchar2, 200);
            arrParam[5].Direction = ParameterDirection.Output;

            string cmdStr = "sfs_subsidios_pkg.getPagosLactancia";
            string res = string.Empty;
            try
            {
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);
                if (ds.Tables.Count > 0)
                {
                    return ds.Tables[0];
                }

                res = arrParam[5].Value.ToString();
                throw new Exception(res);
            }

            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                return null;
            }

        }

        public static DataTable getPagosLactanciaConError(int registro_patronal, Int16 pageNum, Int16 pageSize, string cedula)
        {
            OracleParameter[] arrParam = new OracleParameter[6];

            arrParam[0] = new OracleParameter("p_id_registro_patronal", OracleDbType.Varchar2);
            arrParam[0].Value = registro_patronal;

            arrParam[1] = new OracleParameter("p_pagenum", OracleDbType.Int16);
            arrParam[1].Value = pageNum;

            arrParam[2] = new OracleParameter("p_pagesize", OracleDbType.Int16);
            arrParam[2].Value = pageSize;

            arrParam[3] = new OracleParameter("p_cedula", OracleDbType.NVarchar2);
            if (cedula.Equals(string.Empty))
            {
                arrParam[3].Value = DBNull.Value;
            }
            else
            {
                arrParam[3].Value = cedula;
            }


            arrParam[4] = new OracleParameter("p_io_cursor", OracleDbType.RefCursor);
            arrParam[4].Direction = ParameterDirection.Output;

            arrParam[5] = new OracleParameter("p_resultnumber", OracleDbType.Varchar2, 200);
            arrParam[5].Direction = ParameterDirection.Output;

            string cmdStr = "sfs_subsidios_pkg.getPagosLactanciaConError";
            string res = string.Empty;
            try
            {
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);
                if (ds.Tables.Count > 0)
                {
                    return ds.Tables[0];
                }

                res = arrParam[5].Value.ToString();
                throw new Exception(res);
            }

            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                return null;
            }

        }

        #region "Metodos para consultar la lactancia y maternidad extraordinaria"

        /// <summary>
        /// Metodo para obtener una lista de los subsidios extraordinarios
        /// </summary>
        /// <param name="fechadesde">Fecha desde donde desea ver el listado</param>
        /// <param name="fechahasta">Fecha hasta donde desea ver el listado</param>
        /// <param name="tiposubidio">Tipo de subsidio que sea ver en el listado</param>
        /// <param name="pageNum">Numero de paginas que desea que contenga el listado</param>
        /// <param name="pageSize"></param>
        /// <returns></returns>
        public static DataTable getSubsidiosExtraordinarios(DateTime fechadesde, DateTime fechahasta, String tiposubidio, Int16 pageNum, Int16 pageSize)
        {
            return null;
        }

        #endregion

        #region CONSULTA DE SUBSIDIOS DEL SFS[EMPLEADOR] by Charlie Pena

        public static DataTable getSubsidiosSFS(string rnc, string cedula, string status, string tipo, string desde, string hasta, Int32 pageNum, Int32 pageSize)
        {

            OracleParameter[] arrParam = new OracleParameter[10];

            arrParam[0] = new OracleParameter("p_rnc", OracleDbType.Varchar2);
            arrParam[0].Value = rnc;

            arrParam[1] = new OracleParameter("p_cedula", OracleDbType.Varchar2);
            arrParam[1].Value = cedula;

            arrParam[2] = new OracleParameter("p_status", OracleDbType.Varchar2);
            arrParam[2].Value = status;

            arrParam[3] = new OracleParameter("p_tipo", OracleDbType.Varchar2);
            arrParam[3].Value = tipo;

            arrParam[4] = new OracleParameter("p_fechadesde", OracleDbType.Date);
            if (desde != string.Empty)
            {
                arrParam[4].Value = Convert.ToDateTime(desde);
            }

            arrParam[5] = new OracleParameter("p_fechahasta", OracleDbType.Date);
            if (hasta != string.Empty)
            {
                arrParam[5].Value = Convert.ToDateTime(hasta);
            }

            arrParam[6] = new OracleParameter("p_pagenum", OracleDbType.Int16);
            arrParam[6].Value = pageNum;

            arrParam[7] = new OracleParameter("p_pagesize", OracleDbType.Int16);
            arrParam[7].Value = pageSize;

            arrParam[8] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[8].Direction = ParameterDirection.Output;

            arrParam[9] = new OracleParameter("p_resultnumber", OracleDbType.Varchar2, 200);
            arrParam[9].Direction = ParameterDirection.Output;

            string cmdStr = "sub_sfs_subsidios.getsubsidiossfs";
            string res = string.Empty;
            try
            {
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);
                if (ds.Tables.Count > 0)
                {
                    return ds.Tables[0];
                }

                res = arrParam[9].Value.ToString();
                if (res != "0")
                {
                    throw new Exception(res.Split('|')[1].ToString());
                }
                return null;

            }

            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;

            }

        }

        public static DataTable getDetSubsidiosSFS_M(Int32 NroSolicitud, string regPatronal)
        {
            OracleParameter[] arrParam = new OracleParameter[4];

            arrParam[0] = new OracleParameter("p_nro_solicitud", OracleDbType.Varchar2);
            arrParam[0].Value = NroSolicitud;

            arrParam[1] = new OracleParameter("p_regPatronal", OracleDbType.Varchar2);
            arrParam[1].Value = regPatronal;

            arrParam[2] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[2].Direction = ParameterDirection.Output;

            arrParam[3] = new OracleParameter("p_resultnumber", OracleDbType.Varchar2, 200);
            arrParam[3].Direction = ParameterDirection.Output;

            string cmdStr = "sub_sfs_subsidios.getdetsubsidiossfs_m";
            string res = string.Empty;
            try
            {
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);
                if (ds.Tables.Count > 0)
                {
                    return ds.Tables[0];
                }

                res = arrParam[3].Value.ToString();
                throw new Exception(res);
            }

            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                return null;
            }

        }

        public static DataTable getDetSubsidiosSFS_L(Int32 NroSolicitud, string regPatronal)
        {
            OracleParameter[] arrParam = new OracleParameter[4];

            arrParam[0] = new OracleParameter("p_nro_solicitud", OracleDbType.Varchar2);
            arrParam[0].Value = NroSolicitud;

            arrParam[1] = new OracleParameter("p_regPatronal", OracleDbType.Varchar2);
            arrParam[1].Value = regPatronal;

            arrParam[2] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[2].Direction = ParameterDirection.Output;

            arrParam[3] = new OracleParameter("p_resultnumber", OracleDbType.Varchar2, 200);
            arrParam[3].Direction = ParameterDirection.Output;

            string cmdStr = "sub_sfs_subsidios.getdetsubsidiossfs_L";
            string res = string.Empty;
            try
            {
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);
                if (ds.Tables.Count > 0)
                {
                    return ds.Tables[0];
                }

                res = arrParam[3].Value.ToString();
                throw new Exception(res);
            }

            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                return null;
            }

        }

        public static DataTable getDetSubsidiosSFS_E(Int32 NroSolicitud, string regPatronal)
        {
            OracleParameter[] arrParam = new OracleParameter[4];

            arrParam[0] = new OracleParameter("p_nro_solicitud", OracleDbType.Varchar2);
            arrParam[0].Value = NroSolicitud;

            arrParam[1] = new OracleParameter("p_regPatronal", OracleDbType.Varchar2);
            arrParam[1].Value = regPatronal;

            arrParam[2] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[2].Direction = ParameterDirection.Output;

            arrParam[3] = new OracleParameter("p_resultnumber", OracleDbType.Varchar2, 200);
            arrParam[3].Direction = ParameterDirection.Output;

            string cmdStr = "sub_sfs_subsidios.getdetsubsidiossfs_E";
            string res = string.Empty;
            try
            {
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);
                if (ds.Tables.Count > 0)
                {
                    return ds.Tables[0];
                }

                res = arrParam[3].Value.ToString();
                throw new Exception(res);
            }

            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                return null;
            }

        }

        public static DataTable getCuotasSubsidios(Int32 NroSolicitud, string regPatronal, string tipoSubsidio)
        {
            OracleParameter[] arrParam = new OracleParameter[5];

            arrParam[0] = new OracleParameter("p_nro_solicitud", OracleDbType.Varchar2);
            arrParam[0].Value = NroSolicitud;

            arrParam[1] = new OracleParameter("p_regPatronal", OracleDbType.Varchar2);
            arrParam[1].Value = regPatronal;

            arrParam[2] = new OracleParameter("p_tipo_subsidio", OracleDbType.Varchar2);
            arrParam[2].Value = tipoSubsidio;

            arrParam[3] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[3].Direction = ParameterDirection.Output;

            arrParam[4] = new OracleParameter("p_resultnumber", OracleDbType.Varchar2, 200);
            arrParam[4].Direction = ParameterDirection.Output;

            string cmdStr = "sub_sfs_subsidios.getcuotassubsidios";
            string res = string.Empty;
            try
            {
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);
                if (ds.Tables.Count > 0)
                {
                    return ds.Tables[0];
                }

                res = arrParam[4].Value.ToString();
                throw new Exception(res);
            }

            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                return null;
            }

        }

        public static DataTable getCuotasEnfComunPreliminares(Int32 NroSolicitud, string regPatronal)
        {
            OracleParameter[] arrParam = new OracleParameter[4];

            arrParam[0] = new OracleParameter("p_nrosolicitud", OracleDbType.Varchar2);
            arrParam[0].Value = NroSolicitud;

            arrParam[1] = new OracleParameter("p_registropatronal", OracleDbType.Varchar2);
            arrParam[1].Value = regPatronal;

            arrParam[2] = new OracleParameter("p_io_cursor", OracleDbType.RefCursor);
            arrParam[2].Direction = ParameterDirection.Output;

            arrParam[3] = new OracleParameter("p_resultnumber", OracleDbType.Varchar2, 200);
            arrParam[3].Direction = ParameterDirection.Output;

            string cmdStr = "sub_sfs_subsidios.getdetsubsidioempresa";
            string res = string.Empty;
            try
            {
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);
                if (ds.Tables.Count > 0)
                {
                    return ds.Tables[0];
                }

                res = arrParam[3].Value.ToString();

                DataTable dt = new DataTable();

                Utilitarios.Utils.agregarMensajeError("No hay data para mostrar", ref dt);

                return dt;

            }

            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                return null;
            }

        }
        public static DataTable getStatusSubsidiosSFS()
        {
            OracleParameter[] arrParam = new OracleParameter[2];

            arrParam[0] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[0].Direction = ParameterDirection.Output;
            arrParam[1] = new OracleParameter("p_resultnumber", OracleDbType.Varchar2, 200);
            arrParam[1].Direction = ParameterDirection.Output;

            String cmdStr = "sub_sfs_subsidios.getestatussubsfs";

            try
            {
                return DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam).Tables[0];
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }

        public static Byte[] getImagenSubSFS(int idSolicitud)
        {
            byte[] img = null;
            OracleDataReader odr = null;
            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_nro_solicitud", OracleDbType.Int32);
            arrParam[0].Value = idSolicitud;

            arrParam[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;

            String cmdStr = "sub_sfs_subsidios.getimagensubsfs";

            try
            {
                odr = DataBase.OracleHelper.ExecuteDataReader(CommandType.StoredProcedure, cmdStr, arrParam);
                if (odr.HasRows)
                {
                    odr.Read();
                    if (!odr.IsDBNull(0))
                    {
                        img = new byte[(odr.GetBytes(0, 0, null, 0, int.MaxValue))];
                        odr.GetBytes(0, 0, img, 0, img.Length);
                    }

                }

                odr.Close();

            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;

            }

            return img;

        }

        //cargarImagenFormulario by charlie pena
        public static string CargarImagen(int id_formulario, Byte[] ImageFile, string nombreImagen)
        {

            OracleParameter[] arrParam = new OracleParameter[4];

            arrParam[0] = new OracleParameter("p_id_formulario", OracleDbType.Int32);
            arrParam[0].Value = id_formulario;
            arrParam[1] = new OracleParameter("p_imagen", OracleDbType.Blob);
            arrParam[1].Value = ImageFile;
            arrParam[2] = new OracleParameter("p_nombre_archivo", OracleDbType.NVarchar2);
            arrParam[2].Value = nombreImagen;
            arrParam[3] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[3].Direction = ParameterDirection.Output;

            String cmdStr = "sub_sfs_subsidios.cargarimagen";

            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                return arrParam[3].Value.ToString();
            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;

            }
        }

        // Trae el reporte de de los pagos de subsidios del SFS

        public static DataTable GetPagosSubsidiosSFS(int registro_patronal, string cedula, string tipo_subsidio, string fechadesde, string fechahasta, string fechapagodesde, string fechapagohasta, int pagenum, int pagesize)
        {
            OracleParameter[] arrParam = new OracleParameter[11];

            arrParam[0] = new OracleParameter("p_registro_patronal", OracleDbType.Int32);
            arrParam[0].Value = registro_patronal;
            arrParam[1] = new OracleParameter("p_cedula", OracleDbType.NVarchar2);
            arrParam[1].Value = cedula;
            arrParam[2] = new OracleParameter("p_tiposubsidio", OracleDbType.NVarchar2);
            arrParam[2].Value = tipo_subsidio;
            arrParam[3] = new OracleParameter("p_fechadesde", OracleDbType.Date);
            if (fechadesde != "")
            {
                arrParam[3].Value = DateTime.Parse(fechadesde);

            }
            arrParam[4] = new OracleParameter("p_fechahasta", OracleDbType.Date);

            if (fechahasta != "")
            {
                arrParam[4].Value = DateTime.Parse(fechahasta);
            }
            arrParam[5] = new OracleParameter("p_fechapagodesde", OracleDbType.Date);
            if (fechapagodesde != "")
            {
                arrParam[5].Value = DateTime.Parse(fechapagodesde);

            }
            arrParam[6] = new OracleParameter("p_fechapagohasta", OracleDbType.Date);

            if (fechapagohasta != "")
            {
                arrParam[6].Value = DateTime.Parse(fechapagohasta);
            }
            arrParam[7] = new OracleParameter("p_pagenum", OracleDbType.Int32);
            arrParam[7].Value = pagenum;
            arrParam[8] = new OracleParameter("p_pagesize", OracleDbType.Int32);
            arrParam[8].Value = pagesize;
            arrParam[9] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[9].Direction = ParameterDirection.Output;
            arrParam[10] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[10].Direction = ParameterDirection.Output;
            String cmdStr = "sub_sfs_subsidios.GetPagosSubsidiosSFS";

            string res = string.Empty;
            try
            {
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);
                if (ds.Tables.Count > 0)
                {
                    return ds.Tables[0];
                }

                res = arrParam[10].Value.ToString();
                throw new Exception(res);
            }

            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                return null;
            }

        }

        public static DataTable FiltrarPagosExceso(int registro_patronal, string ReferenciaCredito, string ReferenciaExceso, string CedulaTitular, string CedulaDependiente)
        {
            OracleParameter[] arrParam = new OracleParameter[6];

            arrParam[0] = new OracleParameter("p_id_registro_patronal", OracleDbType.Int32);
            arrParam[0].Value = registro_patronal;
            arrParam[1] = new OracleParameter("p_referencia_ajustes", OracleDbType.NVarchar2, 16);
            arrParam[1].Value = ReferenciaCredito;
            arrParam[2] = new OracleParameter("p_referencia_exceso", OracleDbType.NVarchar2, 16);
            arrParam[2].Value = ReferenciaExceso;
            arrParam[3] = new OracleParameter("p_cedula_titular", OracleDbType.NVarchar2);
            arrParam[3].Value = CedulaTitular;
            arrParam[4] = new OracleParameter("p_cedula_dependiente", OracleDbType.NVarchar2);
            arrParam[4].Value = CedulaDependiente;
            arrParam[5] = new OracleParameter("p_IO_Cursor", OracleDbType.RefCursor);
            arrParam[5].Direction = ParameterDirection.Output;

            string cmdstr = "SRE_EMPLEADORES_PKG.FiltrarDatosPagosExceso";

            try
            {
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdstr, arrParam);
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

        public static DataTable getCuotasSubsidios(DateTime fechadesde, DateTime fechahasta, string tipoempresa, int pagenum, int pagesize)
        {
            OracleParameter[] arrParam = new OracleParameter[7];

            arrParam[0] = new OracleParameter("p_fechaDesde", OracleDbType.Date);
            arrParam[0].Value = fechadesde;

            arrParam[1] = new OracleParameter("p_fechaHasta", OracleDbType.Date);
            arrParam[1].Value = fechahasta;

            arrParam[2] = new OracleParameter("p_tipoempresa", OracleDbType.Varchar2);
            if (String.IsNullOrEmpty(tipoempresa))
            {
                arrParam[2].Value = DBNull.Value;
            }
            else
            {
                arrParam[2].Value = tipoempresa;
            }

            arrParam[3] = new OracleParameter("p_pagenum", OracleDbType.Int32);
            arrParam[3].Value = pagenum;

            arrParam[4] = new OracleParameter("p_pagesize", OracleDbType.Int32);
            arrParam[4].Value = pagesize;

            arrParam[5] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[5].Direction = ParameterDirection.Output;

            arrParam[6] = new OracleParameter("p_resultnumber", OracleDbType.Varchar2, 200);
            arrParam[6].Direction = ParameterDirection.Output;

            string cmdStr = "sub_sfs_subsidios.getcuotassubsidios";
            string res = string.Empty;
            try
            {
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);
                res = arrParam[6].Value.ToString();

                if (res.Split('|')[0].ToString() != "0")
                {
                    throw new Exception(res.Split('|')[1].ToString());
                }
                return ds.Tables[0];
            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;
            }
        }


        #endregion


    }
}
