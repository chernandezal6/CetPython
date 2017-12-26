using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using Oracle.ManagedDataAccess.Client;

namespace SuirPlus.Afiliacion
{
    public class Afiliaciones
    {

        public static DataTable getArchivosPaginados(string Tipo, DateTime ? FechaDesde, DateTime ? FechaHasta, Int16 IdArs, int pageSize, int pageNum)
        {

            OracleParameter[] arrParam;
            String cmdStr = "SEH_PENSIONADOS_PKG.GetArchivosPage";
            string result = null;
            DataTable dt = new DataTable();

            //Definimos nuestro arreglo de parametros.
            arrParam = new OracleParameter[8];

            arrParam[0] = new OracleParameter("P_Tipo_Archivo", OracleDbType.NVarchar2, 2);
            if (Tipo != "0")
            {
                arrParam[0].Value = Tipo;
            }
            else
            {
                arrParam[0].Value = DBNull.Value;
            }



            arrParam[1] = new OracleParameter("P_Fecha_Desde", OracleDbType.Date);
            if (FechaDesde != null)
            {
                arrParam[1].Value = FechaDesde;
            }
            else
            {
                arrParam[1].Value = DBNull.Value;
            }

            arrParam[2] = new OracleParameter("P_Fecha_Hasta", OracleDbType.Date);
            if (FechaHasta != null)
            {
                arrParam[2].Value = FechaHasta;
            }
            else
            {
                arrParam[2].Value = DBNull.Value;
            }


            arrParam[3] = new OracleParameter("P_IdARS", OracleDbType.Double);
            arrParam[3].Value = IdArs;

            arrParam[4] = new OracleParameter("p_pagenum", OracleDbType.Int32);
            arrParam[4].Value = pageNum;

            arrParam[5] = new OracleParameter("p_pagesize", OracleDbType.Int32);
            arrParam[5].Value = pageSize;

            arrParam[6] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[6].Direction = ParameterDirection.Output;

            arrParam[7] = new OracleParameter("p_io_cursor", OracleDbType.RefCursor);
            arrParam[7].Direction = ParameterDirection.Output;

            try
            {
                //Ejecuamos el commando.
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);

                result = arrParam[6].Value.ToString();

                //Si el resultado es diferente de 0, entonces agregamos el error en el datatable para retornarlo.
                //de los contratario asignamos el datatable que viene en el dataset.
                if (result != "0")
                {
                    Utilitarios.Utils.agregarMensajeError(result, ref dt);
                }
                else
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


        public static Byte[] getArchivo(int IdArchivo)
        {
            byte[] img = null;
            OracleDataReader odr = null;
            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("P_IDARCHIVO", OracleDbType.Int32);
            arrParam[0].Value = IdArchivo;
     
            arrParam[1] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_io_cursor", OracleDbType.RefCursor);
            arrParam[2].Direction = ParameterDirection.Output;

            String cmdStr = "SEH_PENSIONADOS_PKG.GETARCHIVO";

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


        public static DataTable getInfoPensionado(string Cedula,string NoPensionado)
        {

            OracleParameter[] arrParam;
            String cmdStr = "SEH_PENSIONADOS_PKG.GetInfoPensionado";
            string result = null;
            DataTable dt = new DataTable();

            //Definimos nuestro arreglo de parametros.
            arrParam = new OracleParameter[4];

            arrParam[0] = new OracleParameter("P_CEDULA", OracleDbType.NVarchar2, 25);
            arrParam[0].Value = Cedula;

            arrParam[1] = new OracleParameter("P_NRO_PENSIONADO", OracleDbType.Double);
            if (!string.IsNullOrEmpty(NoPensionado))
            {
                arrParam[1].Value = NoPensionado;
            }
            else
            {
                arrParam[1].Value = DBNull.Value;
            }
            

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;

            arrParam[3] = new OracleParameter("p_io_cursor", OracleDbType.RefCursor);
            arrParam[3].Direction = ParameterDirection.Output;

            try
            {
                //Ejecuamos el commando.
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);

                result = arrParam[2].Value.ToString();

                //Si el resultado es diferente de 0, entonces agregamos el error en el datatable para retornarlo.
                //de los contratario asignamos el datatable que viene en el dataset.
                if (result != "0")
                {
                    Utilitarios.Utils.agregarMensajeError(result, ref dt);
                }
                else
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

        public static DataTable getPensionado(string Cedula, string NoPensionado)
        {

            OracleParameter[] arrParam;
            String cmdStr = "SEH_PENSIONADOS_PKG.getpensionado";
            string result = null;
            DataTable dt = new DataTable();

            //Definimos nuestro arreglo de parametros.
            arrParam = new OracleParameter[4];

            arrParam[0] = new OracleParameter("p_no_documento", OracleDbType.NVarchar2, 25);
           
            if (!string.IsNullOrEmpty(Cedula))
            {
                arrParam[0].Value = Cedula;
            }
            else
            {
                arrParam[0].Value = DBNull.Value;
            }



            arrParam[1] = new OracleParameter("p_nro_pensionado", OracleDbType.Double);
            if (!string.IsNullOrEmpty(NoPensionado))
            {
                arrParam[1].Value = NoPensionado;
            }
            else
            {
                arrParam[1].Value = DBNull.Value;
            }


            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;

            arrParam[3] = new OracleParameter("p_io_cursor", OracleDbType.RefCursor);
            arrParam[3].Direction = ParameterDirection.Output;

            try
            {
                //Ejecuamos el commando.
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);

                result = arrParam[2].Value.ToString();

                //Si el resultado es diferente de 0, entonces agregamos el error en el datatable para retornarlo.
                //de los contratario asignamos el datatable que viene en el dataset.
                if (result != "0")
                {
                    Utilitarios.Utils.agregarMensajeError(result, ref dt);
                }
                else
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

        public static DataTable getDocumentosInvalidos(DateTime FechaDesde, DateTime FechaHasta, Int16 IdArs, Int16 pageSize, int pageNum)
        {

            OracleParameter[] arrParam;
            String cmdStr = "SEH_PENSIONADOS_PKG.GetDocumentoInvalido";
            string result = null;
            DataTable dt = new DataTable();

            //Definimos nuestro arreglo de parametros.
            arrParam = new OracleParameter[7];
            
            arrParam[0] = new OracleParameter("P_Fecha_Desde", OracleDbType.Date);
            arrParam[0].Value = FechaDesde;
            
            arrParam[1] = new OracleParameter("P_Fecha_Hasta", OracleDbType.Date);
            arrParam[1].Value = FechaHasta;

            arrParam[2] = new OracleParameter("p_idars", OracleDbType.Double);
            arrParam[2].Value = IdArs;
           
            arrParam[3] = new OracleParameter("p_pagenum", OracleDbType.Int32);
            arrParam[3].Value = pageNum;

            arrParam[4] = new OracleParameter("p_pagesize", OracleDbType.Int32);
            arrParam[4].Value = pageSize;

            arrParam[5] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[5].Direction = ParameterDirection.Output;

            arrParam[6] = new OracleParameter("p_io_cursor", OracleDbType.RefCursor);
            arrParam[6].Direction = ParameterDirection.Output;

            try
            {
                //Ejecuamos el commando.
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);

                result = arrParam[5].Value.ToString();

                //Si el resultado es diferente de 0, entonces agregamos el error en el datatable para retornarlo.
                //de los contratario asignamos el datatable que viene en el dataset.
                if (result != "0")
                {
                    Utilitarios.Utils.agregarMensajeError(result, ref dt);
                }
                else
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

        public static DataTable getAfiliacionesPendientes(int IdARS, Int16 pageSize, int pageNum)
        {

            OracleParameter[] arrParam;
            String cmdStr = "SEH_PENSIONADOS_PKG.getAfiliacionesPendiente";
            string result = null;
            DataTable dt = new DataTable();

            //Definimos nuestro arreglo de parametros.
            arrParam = new OracleParameter[5];
                       
            arrParam[0] = new OracleParameter("p_idars", OracleDbType.Double);
            arrParam[0].Value = IdARS;

            arrParam[1] = new OracleParameter("p_pagenum", OracleDbType.Int32);
            arrParam[1].Value = pageNum;

            arrParam[2] = new OracleParameter("p_pagesize", OracleDbType.Int32);
            arrParam[2].Value = pageSize;

            arrParam[3] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[3].Direction = ParameterDirection.Output;

            arrParam[4] = new OracleParameter("p_io_cursor", OracleDbType.RefCursor);
            arrParam[4].Direction = ParameterDirection.Output;

            try
            {
                //Ejecuamos el commando.
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);

                result = arrParam[3].Value.ToString();

                //Si el resultado es diferente de 0, entonces agregamos el error en el datatable para retornarlo.
                //de los contratario asignamos el datatable que viene en el dataset.
                if (result != "0")
                {
                    Utilitarios.Utils.agregarMensajeError(result, ref dt);
                }
                else
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

        public static DataTable getNovedadesPensionado(int noPensionado)
        {

            OracleParameter[] arrParam;
            String cmdStr = "SEH_PENSIONADOS_PKG.getnovedadespensionado";
            string result = null;
            DataTable dt = new DataTable();

            //Definimos nuestro arreglo de parametros.
            arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_nro_pensionado", OracleDbType.Double);
            arrParam[0].Value = noPensionado;

            arrParam[1] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_io_cursor", OracleDbType.RefCursor);
            arrParam[2].Direction = ParameterDirection.Output;

            try
            {
                //Ejecuamos el commando.
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);

                result = arrParam[1].Value.ToString();

                //Si el resultado es diferente de 0, entonces agregamos el error en el datatable para retornarlo.
                //de los contratario asignamos el datatable que viene en el dataset.
                if (result != "0")
                {
                    Utilitarios.Utils.agregarMensajeError(result, ref dt);
                }
                else
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

        public static DataTable getInfoArchivo(int IdRecepcion, DateTime? FechaDesde, DateTime? FechaHasta, int IdArs)
        {

            OracleParameter[] arrParam;
            String cmdStr = "SEH_PENSIONADOS_PKG.get_Info_Archivo";
            string result = null;
            DataTable dt = new DataTable();

            //Definimos nuestro arreglo de parametros.
            arrParam = new OracleParameter[6];

            arrParam[0] = new OracleParameter("p_id_recepcion", OracleDbType.Double);
            if (IdRecepcion != 0)
            {
                arrParam[0].Value = IdRecepcion;
            }
            else
            {
                arrParam[0].Value = DBNull.Value;
            }



            arrParam[1] = new OracleParameter("p_fecha_desde", OracleDbType.Date);
            if (FechaDesde != null)
            {
                arrParam[1].Value = FechaDesde;
            }
            else
            {
                arrParam[1].Value = DBNull.Value;
            }

            arrParam[2] = new OracleParameter("p_fecha_hasta", OracleDbType.Date);
            if (FechaHasta != null)
            {
                arrParam[2].Value = FechaHasta;
            }
            else
            {
                arrParam[2].Value = DBNull.Value;
            }

            arrParam[3] = new OracleParameter("p_idars", OracleDbType.Double);
            arrParam[3].Value = IdArs;

            arrParam[4] = new OracleParameter("p_result_number", OracleDbType.NVarchar2, 200);
            arrParam[4].Direction = ParameterDirection.Output;

            arrParam[5] = new OracleParameter("io_cursor", OracleDbType.RefCursor);
            arrParam[5].Direction = ParameterDirection.Output;

            try
            {
                //Ejecuamos el commando.
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);

                result = arrParam[4].Value.ToString().Split('|')[0].ToString(); ;

                //Si el resultado es diferente de 0, entonces agregamos el error en el datatable para retornarlo.
                //de los contratario asignamos el datatable que viene en el dataset.
                if (result != "0")
                {
                    Utilitarios.Utils.agregarMensajeError(result, ref dt);
                }
                else
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


        public static DataTable getDetalleArchivoPage(int IdRecepcion, Int16 pageSize, int pageNum)
        {

            OracleParameter[] arrParam;
            String cmdStr = "SEH_PENSIONADOS_PKG.getPage_Detalle_Archivo";
            string result = null;
            DataTable dt = new DataTable();

            //Definimos nuestro arreglo de parametros.
            arrParam = new OracleParameter[4];

            arrParam[0] = new OracleParameter("p_id_recepcion", OracleDbType.Double);
            arrParam[0].Value = IdRecepcion;

            arrParam[1] = new OracleParameter("p_pagenum", OracleDbType.Int32);
            arrParam[1].Value = pageNum;

            arrParam[2] = new OracleParameter("p_pagesize", OracleDbType.Int32);
            arrParam[2].Value = pageSize;          

            arrParam[3] = new OracleParameter("io_cursor", OracleDbType.RefCursor);
            arrParam[3].Direction = ParameterDirection.Output;

            try
            {
                //Ejecuamos el commando.
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);
                               
                return ds.Tables[0];
               
                
            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;
            }


        }

        public static DataTable getHistoricoPensionado(int noPensionado)
        {

            OracleParameter[] arrParam;
            String cmdStr = "SEH_PENSIONADOS_PKG.getHistoricoPensionado";
            string result = null;
            DataTable dt = new DataTable();

            //Definimos nuestro arreglo de parametros.
            arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_idpensionado", OracleDbType.Double);
            arrParam[0].Value = noPensionado;

            arrParam[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_resultNumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;

            try
            {
                //Ejecuamos el commando.
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);

                result = arrParam[2].Value.ToString();

                //Si el resultado es diferente de 0, entonces agregamos el error en el datatable para retornarlo.
                //de los contratario asignamos el datatable que viene en el dataset.
                if (result != "0")
                {
                    Utilitarios.Utils.agregarMensajeError(result, ref dt);
                }
                else
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

            string cmdStr = "arl_pkg.getafiliado";
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

        public static DataTable getAfiliadoARL(string RNC, Int64 Nss)
        {
            OracleParameter[] arrParam;

            arrParam = new OracleParameter[4];

            arrParam[0] = new OracleParameter("p_rnc_o_cedula", OracleDbType.Varchar2 );
            arrParam[0].Value = RNC;

            arrParam[1] = new OracleParameter("p_Nss", OracleDbType.Int64);
            arrParam[1].Value = Nss;

            arrParam[2] = new OracleParameter("p_IOCursor", OracleDbType.RefCursor);
            arrParam[2].Direction = ParameterDirection.Output;

            arrParam[3] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[3].Direction = ParameterDirection.Output;

            string cmdStr = "arl_pkg.getafiliado";
            string Resultado = "";

            try
            {
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);

                Resultado = arrParam[3].Value.ToString();

                if (Resultado != "0")
                {
                    throw new Exception(arrParam[3].Value.ToString());
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


        public static DataTable getMovimientosAfiliadoARL(string RNC, Int64 Nss, int pagenum, int pagesize)
        {
            OracleParameter[] arrParam;

            arrParam = new OracleParameter[6];

            arrParam[0] = new OracleParameter("p_rnc_o_cedula", OracleDbType.Varchar2 );
            arrParam[0].Value = RNC;

            
            arrParam[1] = new OracleParameter("p_Nss", OracleDbType.Int64);
            arrParam[1].Value = Nss;

            arrParam[2] = new OracleParameter("p_pagenum", OracleDbType.Int32);
            arrParam[2].Value = pagenum;

            arrParam[3] = new OracleParameter("p_pagesize", OracleDbType.Int32);
            arrParam[3].Value = pagesize;

            arrParam[4] = new OracleParameter("p_IOCursor", OracleDbType.RefCursor);
            arrParam[4].Direction = ParameterDirection.Output;

            arrParam[5] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[5].Direction = ParameterDirection.Output;

            string cmdStr = "arl_pkg.getPageMovimientosAfiliado";
            string Resultado = "";

            try
            {
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);

                Resultado = arrParam[5].Value.ToString();

                if (Resultado != "0")
                {
                    throw new Exception(arrParam[5].Value.ToString());
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

        public static DataTable getHistoricoDescuento(string RNC, string Cedula,string Ano)
        {
            OracleParameter[] arrParam;

            arrParam = new OracleParameter[5];

            arrParam[0] = new OracleParameter("p_rnc_o_cedula", OracleDbType.Varchar2);
            arrParam[0].Value = RNC;

            arrParam[1] = new OracleParameter("p_cedula", OracleDbType.Varchar2);
            arrParam[1].Value = Cedula;

            arrParam[2] = new OracleParameter("p_ano", OracleDbType.Varchar2);
            arrParam[2].Value = Ano;

            arrParam[3] = new OracleParameter("p_IOCursor", OracleDbType.RefCursor);
            arrParam[3].Direction = ParameterDirection.Output;

            arrParam[4] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[4].Direction = ParameterDirection.Output;

            string cmdStr = "arl_pkg.getHistoricoDescuento";
            string Resultado = "";

            try
            {
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);

                Resultado = arrParam[4].Value.ToString();

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

        public static DataTable getMovimientosAfiliado(string RNC, int Nss)
        {
            OracleParameter[] arrParam;

            arrParam = new OracleParameter[4];

            arrParam[0] = new OracleParameter("p_rnc_o_cedula", OracleDbType.Varchar2);
            arrParam[0].Value = RNC;

            arrParam[1] = new OracleParameter("p_Nss", OracleDbType.Int32);
            arrParam[1].Value = Nss;

            arrParam[2] = new OracleParameter("p_IOCursor", OracleDbType.RefCursor);
            arrParam[2].Direction = ParameterDirection.Output;

            arrParam[3] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[3].Direction = ParameterDirection.Output;

            string cmdStr = "arl_pkg.getMovimientosAfiliado";
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

                return ds.Tables[0];
            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw;
            }

        }


    
    }
    
}
