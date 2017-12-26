using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using SuirPlus;
using System.Data;
using Oracle.ManagedDataAccess.Client;

namespace SuirPlus.Utilitarios
{
    public class Info
    {
        // Consulta de Nss
        public static DataTable ConsultaCiudadanos(string nodocumento, string idnss, string nombres, string primerapellido, string segundoapellido)
        {


            //throw new Exception(numerolote.ToString() + fechaIni.ToString() + fechaFin.ToString());

            OracleParameter[] arrParam = new OracleParameter[7]; 

            arrParam[0] = new OracleParameter("p_no_documento", OracleDbType.NVarchar2, 20);
            arrParam[0].Value = SuirPlus.Utilitarios.Utils.verificarNulo(nodocumento);

            arrParam[1] = new OracleParameter("p_id_nss", OracleDbType.Int32);
            arrParam[1].Value = SuirPlus.Utilitarios.Utils.verificarNulo(idnss);

            arrParam[2] = new OracleParameter("p_nombres", OracleDbType.NVarchar2, 50);
            arrParam[2].Value = nombres;

            arrParam[3] = new OracleParameter("p_primer_apellido", OracleDbType.NVarchar2, 50);
            arrParam[3].Value = primerapellido;

            arrParam[4] = new OracleParameter("p_segundo_apellido", OracleDbType.NVarchar2, 50);
            arrParam[4].Value = segundoapellido;

            arrParam[5] = new OracleParameter("p_ResultNumber", OracleDbType.NVarchar2, 1000);
            arrParam[5].Direction = ParameterDirection.Output;

            arrParam[6] = new OracleParameter("io_cursor", OracleDbType.RefCursor);
            arrParam[6].Direction = ParameterDirection.Output;


            String cmdStr = "INFO_PKG.ConsultaCiudadano";

            try
            {
                return DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam).Tables[0];
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public static DataTable HistoricoDescuento(string nss,string rncEmpleador, string ano)
        {

            string cmdStr = "INFO_PKG.HistoricoDescuento";
            OracleParameter[] arrParam = new OracleParameter[5];

            arrParam[0] = new OracleParameter("p_id_nss", OracleDbType.NVarchar2, 11);
            arrParam[0].Value = nss;

            arrParam[1] = new OracleParameter("p_rnc_cedula", OracleDbType.NVarchar2, 11);
            arrParam[1].Value = rncEmpleador;

            arrParam[2] = new OracleParameter("p_ano", OracleDbType.NVarchar2, 4);
            arrParam[2].Value = ano;

            arrParam[3] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[3].Direction = ParameterDirection.Output;

            arrParam[4] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 1000);
            arrParam[4].Direction = ParameterDirection.Output;

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

        public static DataTable AfiliadoARL(int nss)
        {

            string cmdStr = "INFO_PKG.AfiliadoARL";
            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_id_nss", OracleDbType.Decimal);
            arrParam[0].Value = nss;

            arrParam[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 1000);
            arrParam[2].Direction = ParameterDirection.Output;

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

        public static DataTable ARSPorPeriodo(string nodocumento, string idnss)
        {

            OracleParameter[] arrParam = new OracleParameter[4];

            arrParam[0] = new OracleParameter("p_no_documento", OracleDbType.NVarchar2, 20);
            arrParam[0].Value = SuirPlus.Utilitarios.Utils.verificarNulo(nodocumento);

            arrParam[1] = new OracleParameter("p_id_nss", OracleDbType.Int32);
            arrParam[1].Value = SuirPlus.Utilitarios.Utils.verificarNulo(idnss);


            arrParam[2] = new OracleParameter("p_cursor", OracleDbType.RefCursor);
            arrParam[2].Direction = ParameterDirection.Output;

            arrParam[3] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[3].Direction = ParameterDirection.Output;


            String cmdStr = "INFO_PKG.ARSPorPeriodo";

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
                SuirPlus.Exepciones.Log.LogToDB(ex.ToString());

                throw ex;
            }
        }
        
        public static DataTable ConsultaSFS(string rnc, string cedula, string status, string tipo, string desde, string hasta)
        {

            OracleParameter[] arrParam = new OracleParameter[8];

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

            arrParam[6] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[6].Direction = ParameterDirection.Output;

            arrParam[7] = new OracleParameter("p_resultnumber", OracleDbType.Varchar2, 200);
            arrParam[7].Direction = ParameterDirection.Output;

            string cmdStr = "INFO_PKG.ConsultaSFS";
            string res = string.Empty;
            try
            {
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);
                if (ds.Tables.Count > 0)
                {
                    return ds.Tables[0];
                }

                res = arrParam[7].Value.ToString();
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

        public static DataTable DetalleSFS(int registropatronal, int nrosolicitud, string tipo)
        {

            OracleParameter[] arrParam = new OracleParameter[5];

            arrParam[0] = new OracleParameter("p_nro_solicitud", OracleDbType.Double);
            arrParam[0].Value = nrosolicitud;

            arrParam[1] = new OracleParameter("p_tipo", OracleDbType.Varchar2);
            arrParam[1].Value = tipo;

            arrParam[2] = new OracleParameter("p_regPatronal", OracleDbType.Double);
            arrParam[2].Value = registropatronal;

            arrParam[3] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[3].Direction = ParameterDirection.Output;

            arrParam[4] = new OracleParameter("p_resultnumber", OracleDbType.Varchar2, 200);
            arrParam[4].Direction = ParameterDirection.Output;

            string cmdStr = "INFO_PKG.getDetSubsidiosSFS";
            string res = string.Empty;
            try
            {
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);
                if (ds.Tables.Count > 0)
                {
                    return ds.Tables[0];
                }

                res = arrParam[4].Value.ToString();
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

        public static DataTable ConsultaEmpleador(int registroPatronal, string rncCedula, string nombreComercial, string razonSocial, string telefono)
        {
            OracleParameter[] arrParam = new OracleParameter[6];

            arrParam[0] = new OracleParameter("p_id_registro_patronal", OracleDbType.Int32);
            arrParam[0].Value = Utilitarios.Utils.verificarNulo(registroPatronal);

            arrParam[1] = new OracleParameter("p_rnc_o_cedula", OracleDbType.NVarchar2, 11);
            arrParam[1].Value = Utilitarios.Utils.verificarNulo(rncCedula);

            arrParam[2] = new OracleParameter("p_nombre_comercial", OracleDbType.NVarchar2, 150);
            arrParam[2].Value = Utilitarios.Utils.verificarNulo(nombreComercial);

            arrParam[3] = new OracleParameter("p_razon_Social", OracleDbType.NVarchar2, 150);
            arrParam[3].Value = Utilitarios.Utils.verificarNulo(razonSocial);

            arrParam[4] = new OracleParameter("p_telefono", OracleDbType.NVarchar2, 10);
            arrParam[4].Value = Utilitarios.Utils.verificarNulo(telefono);

            arrParam[5] = new OracleParameter("io_cursor", OracleDbType.RefCursor);
            arrParam[5].Direction = ParameterDirection.Output;

            String cmdStr = "INFO_PKG.ConsultaEmpleadores";

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

                SuirPlus.Exepciones.Log.LogToDB(ex.ToString());

                throw ex;

            }
        }

    }
}
