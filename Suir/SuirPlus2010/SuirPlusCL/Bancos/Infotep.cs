
using System;
using SuirPlus;
using System.Data;
using Oracle.ManagedDataAccess.Client;
using SuirPlus.DataBase;

namespace SuirPlus.Bancos
{
    /// <summary>
    /// Summary description for Infotep.
    /// </summary>
    public class Infotep
    {
        public Infotep()
        {
            //
            // TODO: Add constructor logic here
            //
        }

        /// <summary>
        /// Metodo utilizado para la consuta de Referencia por Envio del Infotep
        /// </summary>
        /// <param name="IDRecepcion">El No. de Envio que le retorno el archivo enviado</param>
        /// <returns>Un datatable con los resultados arrojados por el No. de envio.</returns>
        /// <remarks>Autor: Charlie Pe�a</remarks>
        /// 

        public static DataTable getReferenciaXEnvio(int IDRecepcion)
        {


            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_idrecepcion", OracleDbType.Decimal, 10);
            arrParam[0].Value = IDRecepcion;

            arrParam[1] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[2].Direction = ParameterDirection.Output;

            string cmdStr = "Sfc_Infotep_Pkg.Liquidacion_NoEnvio_Inf";

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
            finally
            {
                string myResultado = arrParam[1].Value.ToString();
                if (!Utilitarios.Utils.sacarMensajeDeError(myResultado).Equals("OK"))
                {
                    throw new Exception(Utilitarios.Utils.sacarMensajeDeError(myResultado));
                }
            }

        }

        public static DataTable getResumenRecaudacion(DateTime fechaIni, DateTime fechaFin, string requerimiento)
        {
            OracleParameter[] arrParam = new OracleParameter[5];

            arrParam[0] = new OracleParameter("p_fechaini", OracleDbType.Date);
            arrParam[0].Value = fechaIni;
            arrParam[1] = new OracleParameter("p_fechafin", OracleDbType.Date);
            arrParam[1].Value = fechaFin;
            arrParam[2] = new OracleParameter("p_requerimiento", OracleDbType.NVarchar2, 200);
            arrParam[2].Value = requerimiento;
            arrParam[3] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[3].Direction = ParameterDirection.Output;
            arrParam[4] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[4].Direction = ParameterDirection.Output;

            String cmdStr = "SFC_INFOTEP_PKG.Get_ResumenRecaudacion";

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

        public static DataTable getDetalleRecaudoPagos(Int64 entidad, DateTime fechaIni, DateTime fechaFin)
        {

            OracleParameter[] arrParam = new OracleParameter[5];

            arrParam[0] = new OracleParameter("p_identidad_rec", OracleDbType.Decimal);
            arrParam[0].Value = entidad;
            arrParam[1] = new OracleParameter("p_fechaini", OracleDbType.Date);
            arrParam[1].Value = fechaIni;
            arrParam[2] = new OracleParameter("p_fechafin", OracleDbType.Date);
            arrParam[2].Value = fechaFin;
            arrParam[3] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[3].Direction = ParameterDirection.Output;
            arrParam[4] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[4].Direction = ParameterDirection.Output;

            String cmdStr = "SFC_INFOTEP_PKG.Get_DetallesRecaudacionPago";

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

        public static DataTable getCuentaPagos(Int64 numeroentidad, DateTime fechaIni, DateTime fechaFin)
        {

            //throw new Exception(numerolote.ToString() + fechaIni.ToString() + fechaFin.ToString());

            OracleParameter[] arrParam = new OracleParameter[5];

            arrParam[0] = new OracleParameter("p_entidad", OracleDbType.Decimal);
            arrParam[0].Value = numeroentidad;
            arrParam[1] = new OracleParameter("p_fechaini", OracleDbType.Date);
            arrParam[1].Value = fechaIni;
            arrParam[2] = new OracleParameter("p_fechafin", OracleDbType.Date);
            arrParam[2].Value = fechaFin;
            arrParam[3] = new OracleParameter("p_result_number", OracleDbType.NVarchar2, 200);
            arrParam[3].Direction = ParameterDirection.Output;
            arrParam[4] = new OracleParameter("io_cursor", OracleDbType.RefCursor);
            arrParam[4].Direction = ParameterDirection.Output;

            String cmdStr = "SFC_INFOTEP_PKG.get_cuenta_pagos";

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

        public static DataTable getCuentaAclaraciones(Int64 numeroentidad, DateTime fechaIni, DateTime fechaFin)
        {

            //throw new Exception(numerolote.ToString() + fechaIni.ToString() + fechaFin.ToString());

            OracleParameter[] arrParam = new OracleParameter[5];

            arrParam[0] = new OracleParameter("p_entidad", OracleDbType.Decimal);
            arrParam[0].Value = numeroentidad;
            arrParam[1] = new OracleParameter("p_fechaini", OracleDbType.Date);
            arrParam[1].Value = fechaIni;
            arrParam[2] = new OracleParameter("p_fechafin", OracleDbType.Date);
            arrParam[2].Value = fechaFin;
            arrParam[3] = new OracleParameter("p_result_number", OracleDbType.NVarchar2, 200);
            arrParam[3].Direction = ParameterDirection.Output;
            arrParam[4] = new OracleParameter("io_cursor", OracleDbType.RefCursor);
            arrParam[4].Direction = ParameterDirection.Output;

            String cmdStr = "SFC_INFOTEP_PKG.get_cuenta_aclaraciones";

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

        public static DataTable getResumenAclaraciones()
        {
            OracleParameter[] arrParam = new OracleParameter[2];

            arrParam[0] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[0].Direction = ParameterDirection.Output;
            arrParam[1] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[1].Direction = ParameterDirection.Output;

            String cmdStr = "SFC_INFOTEP_PKG.Get_Aclaraciones";

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

        public static DataTable getResumenAclaracionesDet(int entRec)
        {
            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_identidad_rec", OracleDbType.Decimal);
            arrParam[0].Value = Utilitarios.Utils.verificarNulo(entRec);
            arrParam[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;
            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;

            String cmdStr = "SFC_INFOTEP_PKG.Get_DetallesAclaraciones";

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

        public static string insert_infotep_ext(string Rnc, int periodoLiquidacion, int monto)
        {

            OracleParameter[] arrParam = new OracleParameter[4];

            arrParam[0] = new OracleParameter("p_Rnc_o_Cedula", OracleDbType.NVarchar2, 16);
            arrParam[0].Value = Rnc;
            arrParam[1] = new OracleParameter("p_periodo_liquidacion", OracleDbType.Int32, 6);
            arrParam[1].Value = periodoLiquidacion;
            arrParam[2] = new OracleParameter("p_monto", OracleDbType.Int32, 6);
            arrParam[2].Value = monto;
            arrParam[3] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[3].Direction = ParameterDirection.Output;

            String cmdStr = "sfc_infotep_pkg.insert_infotep_ext";

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