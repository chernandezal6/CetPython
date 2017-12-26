using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using Oracle.ManagedDataAccess.Client;
namespace SuirPlus.Servicios
{
    public class WebServices
    {
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
        public static DataTable getAfiliado(string RNC, string Cedula)
        {
            OracleParameter[] arrParam;
            arrParam = new OracleParameter[4];
            arrParam[0] = new OracleParameter("p_rnc_o_cedula", OracleDbType.Varchar2);
            arrParam[0].Value = RNC;
            arrParam[1] = new OracleParameter("p_cedula", OracleDbType.Varchar2);
            arrParam[1].Value = Cedula;
            arrParam[2] = new OracleParameter("p_IOCursor", OracleDbType.RefCursor);
            arrParam[2].Direction = ParameterDirection.Output;
            arrParam[3] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[3].Direction = ParameterDirection.Output;
            string cmdStr = "WSS_Servicios_pkg.getafiliado";
            string Resultado = "";
            try
            {
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);
                Resultado = arrParam[3].Value.ToString();
                if (Resultado != "0")
                {
                    DataTable dt = new DataTable(Resultado);
                    DataColumn myColumn;
                    DataRow myRow;
                    myColumn = new DataColumn("Mensaje");
                    dt.Columns.Add(myColumn);
                    myRow = dt.NewRow();
                    myRow["Mensaje"] = Resultado;
                    dt.Rows.Add(myRow);
                    dt.TableName = "Error";
                    return dt;
                }
                else
                {
                    return ds.Tables[0];
                }
            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw;
            }
        }
        public static DataTable getHistoricoDescuento(string RNC, string Cedula, string Ano, string NSS)
        {
            OracleParameter[] arrParam;
            arrParam = new OracleParameter[6];
            arrParam[0] = new OracleParameter("p_rnc_o_cedula", OracleDbType.Varchar2);
            arrParam[0].Value = RNC;
            arrParam[1] = new OracleParameter("p_nss", OracleDbType.Varchar2);
            arrParam[1].Value = NSS;
            arrParam[2] = new OracleParameter("p_cedula", OracleDbType.Varchar2);
            arrParam[2].Value = Cedula;
            arrParam[3] = new OracleParameter("p_ano", OracleDbType.Varchar2);
            arrParam[3].Value = Ano;
            arrParam[4] = new OracleParameter("p_IOCursor", OracleDbType.RefCursor);
            arrParam[4].Direction = ParameterDirection.Output;
            arrParam[5] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[5].Direction = ParameterDirection.Output;
            string cmdStr = "WSS_Servicios_pkg.getHistoricoDescuento";
            string Resultado = "";
            try
            {
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);
                Resultado = arrParam[5].Value.ToString();
                if (Resultado != "0")
                {
                    DataTable dt = new DataTable(Resultado);
                    DataColumn myColumn;
                    DataRow myRow;
                    myColumn = new DataColumn("Mensaje");
                    dt.Columns.Add(myColumn);
                    myRow = dt.NewRow();
                    myRow["Mensaje"] = Resultado;
                    dt.Rows.Add(myRow);
                    dt.TableName = "Error";
                    return dt;
                }
                return ds.Tables[0];
            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw;
            }
        }
        public static DataTable ValidarPymes(string RNC)
        {
            OracleParameter[] arrParam;
            arrParam = new OracleParameter[3];
            arrParam[0] = new OracleParameter("p_rnc_o_cedula", OracleDbType.Varchar2);
            arrParam[0].Value = RNC;
            arrParam[1] = new OracleParameter("p_IOCursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;
            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;
            string cmdStr = "WSS_Servicios_pkg.ValidarPYMES";
            string Resultado = "";
            try
            {
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);
                Resultado = arrParam[2].Value.ToString();
                if (Resultado != "0")
                {
                    DataTable dt = new DataTable(Resultado);
                    DataColumn myColumn;
                    DataRow myRow;
                    myColumn = new DataColumn("Mensaje");
                    dt.Columns.Add(myColumn);
                    myRow = dt.NewRow();
                    myRow["Mensaje"] = Resultado;
                    dt.Rows.Add(myRow);
                    dt.TableName = "Error";
                    return dt;
                }
                return ds.Tables[0];
            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw;
            }
        }
        public static DataTable getCiudadano(string Cedula)
        {
            OracleParameter[] arrParam;
            arrParam = new OracleParameter[3];
            arrParam[0] = new OracleParameter("p_cedula", OracleDbType.Varchar2);
            arrParam[0].Value = Cedula;
            arrParam[1] = new OracleParameter("p_IOCursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;
            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;
            string cmdStr = "WSS_Servicios_pkg.GetCiudadano";
            string Resultado = "";
            try
            {
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);
                Resultado = arrParam[2].Value.ToString();
                if (Resultado != "0")
                {
                    DataTable dt = new DataTable(Resultado);
                    DataColumn myColumn;
                    DataRow myRow;
                    myColumn = new DataColumn("Mensaje");
                    dt.Columns.Add(myColumn);
                    myRow = dt.NewRow();
                    myRow["Mensaje"] = Resultado;
                    dt.Rows.Add(myRow);
                    dt.TableName = "Error";
                    return dt;
                }
                else
                {
                    return ds.Tables[0];
                }
            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw;
            }
        }
        public static DataTable getEmpleadorRep(string RNC)
        {
            OracleParameter[] arrParam;
            arrParam = new OracleParameter[3];
            arrParam[0] = new OracleParameter("p_cedula", OracleDbType.Varchar2);
            arrParam[0].Value = RNC;
            arrParam[1] = new OracleParameter("p_IOCursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;
            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;
            string cmdStr = "WSS_Servicios_pkg.GetEmpleadorRep";
            string Resultado = "";
            try
            {
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);
                Resultado = arrParam[2].Value.ToString();
                if (Resultado != "0")
                {
                    DataTable dt = new DataTable(Resultado);
                    DataColumn myColumn;
                    DataRow myRow;
                    myColumn = new DataColumn("Mensaje");
                    dt.Columns.Add(myColumn);
                    myRow = dt.NewRow();
                    myRow["Mensaje"] = Resultado;
                    dt.Rows.Add(myRow);
                    dt.TableName = "Error";
                    return dt;
                }
                else
                {
                    return ds.Tables[0];
                }
            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw;
            }
        }
        public static DataTable getExtranjero(string Nro_carnet)
        {
            OracleParameter[] arrParam;
            arrParam = new OracleParameter[3];
            arrParam[0] = new OracleParameter("p_nro_carnet", OracleDbType.Varchar2);
            arrParam[0].Value = Nro_carnet;
            arrParam[1] = new OracleParameter("p_IOCursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;
            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;
            string cmdStr = "WSS_Servicios_pkg.GetExtranjero";
            string Resultado = "";
            try
            {
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);
                Resultado = arrParam[2].Value.ToString();
                if (Resultado != "0")
                {
                    DataTable dt = new DataTable(Resultado);
                    DataColumn myColumn;
                    DataRow myRow;
                    myColumn = new DataColumn("Mensaje");
                    dt.Columns.Add(myColumn);
                    myRow = dt.NewRow();
                    myRow["Mensaje"] = Resultado;
                    dt.Rows.Add(myRow);
                    dt.TableName = "Error";
                    return dt;
                }
                else
                {
                    return ds.Tables[0];
                }
            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw;
            }
        }
        public static string ActualizarCategoriaRiesgo(string usuario, string rnc, string categoria)
        {

            OracleParameter[] arrParam = new OracleParameter[4];

            arrParam[0] = new OracleParameter("p_usuario", OracleDbType.NVarchar2, 35);
            arrParam[0].Value = usuario;
            arrParam[1] = new OracleParameter("p_rnc_cedula", OracleDbType.NVarchar2, 11);
            arrParam[1].Value = rnc;
            arrParam[2] = new OracleParameter("p_categoria_riesgo", OracleDbType.NVarchar2, 3);
            arrParam[2].Value = categoria;
            arrParam[3] = new OracleParameter("p_resultado", OracleDbType.NVarchar2, 200);
            arrParam[3].Direction = ParameterDirection.Output;

            String cmdStr = "sfc_infotep_pkg.ActualizarCategoriaRiesgo";

            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                return Utilitarios.Utils.sacarMensajeDeError(arrParam[3].Value.ToString());
            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;
            }

        }
        public static string LiquidacionMarcarPagada(string usuario, string liquidacion, DateTime fechapago, Int32 entidadrecaudadora)
        {

            OracleParameter[] arrParam = new OracleParameter[5];

            arrParam[0] = new OracleParameter("p_usuario", OracleDbType.NVarchar2, 35);
            arrParam[0].Value = usuario;
            arrParam[1] = new OracleParameter("p_liquidacion", OracleDbType.NVarchar2, 16);
            arrParam[1].Value = liquidacion;
            arrParam[2] = new OracleParameter("p_fecha_pago", OracleDbType.Date);
            arrParam[2].Value = fechapago;
            arrParam[3] = new OracleParameter("p_entidad_recaudadora", OracleDbType.Int32, 2);
            arrParam[3].Value = entidadrecaudadora;
            arrParam[4] = new OracleParameter("p_resultado", OracleDbType.NVarchar2, 200);
            arrParam[4].Direction = ParameterDirection.Output;

            String cmdStr = "sfc_infotep_pkg.MarcarPagada";

            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                return Utilitarios.Utils.sacarMensajeDeError(arrParam[4].Value.ToString());
            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;
            }


        }
        public static string LiquidacionMarcarCancelada(string usuario, string liquidacion)
        {

            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_usuario", OracleDbType.NVarchar2, 35);
            arrParam[0].Value = usuario;
            arrParam[1] = new OracleParameter("p_liquidacion", OracleDbType.NVarchar2, 16);
            arrParam[1].Value = liquidacion;
            arrParam[2] = new OracleParameter("p_resultado", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;

            String cmdStr = "sfc_infotep_pkg.MarcarCancelada";

            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                return Utilitarios.Utils.sacarMensajeDeError(arrParam[2].Value.ToString());
            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;
            }


        }
        public static string PagaInfotep(string usuario, string rnc)
        {

            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_usuario", OracleDbType.NVarchar2, 35);
            arrParam[0].Value = usuario;
            arrParam[1] = new OracleParameter("p_rnc", OracleDbType.NVarchar2, 11);
            arrParam[1].Value = rnc;
            arrParam[2] = new OracleParameter("p_resultado", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;

            String cmdStr = "sfc_infotep_pkg.PagaInfotep";

            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                return Utilitarios.Utils.sacarMensajeDeError(arrParam[2].Value.ToString());
            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;
            }


        }
        public static string NoPagaInfotep(string usuario, string rnc)
        {

            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_usuario", OracleDbType.NVarchar2, 35);
            arrParam[0].Value = usuario;
            arrParam[1] = new OracleParameter("p_rnc", OracleDbType.NVarchar2, 11);
            arrParam[1].Value = rnc;
            arrParam[2] = new OracleParameter("p_resultado", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;

            String cmdStr = "sfc_infotep_pkg.NoPagaInfotep";

            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                return Utilitarios.Utils.sacarMensajeDeError(arrParam[2].Value.ToString());
            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;
            }


        }
        
    }
}