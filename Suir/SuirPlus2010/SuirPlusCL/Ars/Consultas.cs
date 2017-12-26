using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using SuirPlus;
using SuirPlus.Exepciones;
using SuirPlus.DataBase;
using SuirPlus.FrameWork;
using Oracle.ManagedDataAccess.Client;
namespace SuirPlus.Ars
{
    public class Consultas : Objetos
    {
        static string puedeCambiarArs;
        public static string PuedeCambiarArs
        {
            get { return puedeCambiarArs; }
            set { puedeCambiarArs = value; }
        }

        #region "Contructor de la Clase"
        public Consultas() { }
        #endregion

        #region "Metodos de la Clase SuirPlus.Finanzas ARS"
        public static DataTable getHistoricoCiudadano(string nodocumento, string idnss)
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


            String cmdStr = "SRE_ARS_PKG.getHistoricoCiudadano";

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

        public static DataTable getPagosNoReferencia(string noRef, int pagenum, int pagesize)
        {

            OracleParameter[] arrParam = new OracleParameter[5];

            arrParam[0] = new OracleParameter("p_no_referencia", OracleDbType.NVarchar2, 16);
            arrParam[0].Value = noRef;

            arrParam[1] = new OracleParameter("p_pagenum", OracleDbType.Double);
            arrParam[1].Value = pagenum;

            arrParam[2] = new OracleParameter("p_pagesize", OracleDbType.Double);
            arrParam[2].Value = pagesize;

            arrParam[3] = new OracleParameter("p_cursor", OracleDbType.RefCursor);
            arrParam[3].Direction = ParameterDirection.Output;

            arrParam[4] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[4].Direction = ParameterDirection.Output;


            String cmdStr = "SRE_ARS_PKG.getPagosNoReferencia";

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

        public static DataTable getErroresCartera(int IDCarga)
        {

            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_idcarga", OracleDbType.Double, 10);
            arrParam[0].Value = IDCarga;

            arrParam[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_resultNumber", OracleDbType.Varchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;


            String cmdStr = "SRE_ARS_PKG.getErroresCartera";

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

        public static DataTable getErroresDipersion(int IDCarga)
        {

            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_idcarga", OracleDbType.Double, 10);
            arrParam[0].Value = IDCarga;

            arrParam[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_resultNumber", OracleDbType.Varchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;


            String cmdStr = "SRE_ARS_PKG.getErroresDispersion";

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

        public static DataTable getDetalleErroresCartera(int idError, int pagenum, int pagesize)
        {

            OracleParameter[] arrParam = new OracleParameter[5];

            arrParam[0] = new OracleParameter("p_id_error", OracleDbType.Double, 10);
            arrParam[0].Value = idError;

            arrParam[1] = new OracleParameter("p_pagenum", OracleDbType.Double);
            arrParam[1].Value = pagenum;

            arrParam[2] = new OracleParameter("p_pagesize", OracleDbType.Double);
            arrParam[2].Value = pagesize;

            arrParam[3] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[3].Direction = ParameterDirection.Output;

            arrParam[4] = new OracleParameter("p_resultNumber", OracleDbType.NVarchar2, 200);
            arrParam[4].Direction = ParameterDirection.Output;


            String cmdStr = "SRE_ARS_PKG.getDetallesErroresCartera";

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

        public static DataTable getDispersionesErrores(int pagenum, int pagesize)
        {

            OracleParameter[] arrParam = new OracleParameter[4];

            arrParam[0] = new OracleParameter("p_pagenum", OracleDbType.Double);
            arrParam[0].Value = pagenum;

            arrParam[1] = new OracleParameter("p_pagesize", OracleDbType.Double);
            arrParam[1].Value = pagesize;

            arrParam[2] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[2].Direction = ParameterDirection.Output;

            arrParam[3] = new OracleParameter("p_resultNumber", OracleDbType.NVarchar2, 200);
            arrParam[3].Direction = ParameterDirection.Output;


            String cmdStr = "SRE_ARS_PKG.getDispersionesErrores";

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

        public static DataTable getDetalleErroresDispersion(int idError, int pagenum, int pagesize)
        {

            OracleParameter[] arrParam = new OracleParameter[5];

            arrParam[0] = new OracleParameter("p_id_error", OracleDbType.Double, 10);
            arrParam[0].Value = idError;

            arrParam[1] = new OracleParameter("p_pagenum", OracleDbType.Double);
            arrParam[1].Value = pagenum;

            arrParam[2] = new OracleParameter("p_pagesize", OracleDbType.Double);
            arrParam[2].Value = pagesize;

            arrParam[3] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[3].Direction = ParameterDirection.Output;

            arrParam[4] = new OracleParameter("p_resultNumber", OracleDbType.NVarchar2, 200);
            arrParam[4].Direction = ParameterDirection.Output;


            String cmdStr = "SRE_ARS_PKG.getDetallesErroresDispersion";

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

        #endregion

        public static DataTable getResumenCartera(string periodo, int ciclo, int tipo)
        {

            OracleParameter[] arrParam = new OracleParameter[5];

            arrParam[0] = new OracleParameter("p_periodo", OracleDbType.Varchar2, 10);
            arrParam[0].Value = periodo;

            arrParam[1] = new OracleParameter("p_ciclo", OracleDbType.Double, 10);
            arrParam[1].Value = ciclo;

            arrParam[2] = new OracleParameter("p_Tipo", OracleDbType.Double, 10);
            arrParam[2].Value = tipo;

            arrParam[3] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[3].Direction = ParameterDirection.Output;

            arrParam[4] = new OracleParameter("p_resultNumber", OracleDbType.Varchar2, 200);
            arrParam[4].Direction = ParameterDirection.Output;


            String cmdStr = "ars_validaciones_pkg.ResumenConsol1raDispersion";

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

        public static DataTable getResumen(int periodo, int ciclo)
        {

            OracleParameter[] arrParam = new OracleParameter[4];

            arrParam[0] = new OracleParameter("p_periodo", OracleDbType.Double, 10);
            arrParam[0].Value = periodo;

            arrParam[1] = new OracleParameter("p_ciclo", OracleDbType.Double, 10);
            arrParam[1].Value = ciclo;

            arrParam[2] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[2].Direction = ParameterDirection.Output;

            arrParam[3] = new OracleParameter("p_resultNumber", OracleDbType.Varchar2, 200);
            arrParam[3].Direction = ParameterDirection.Output;


            String cmdStr = "ars_validaciones_pkg.ResumenConsolDispMens";

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


        public static DataTable getPeriodosDispersion()
        {

            OracleParameter[] arrParam = new OracleParameter[2];

            arrParam[0] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[0].Direction = ParameterDirection.Output;

            arrParam[1] = new OracleParameter("p_resultNumber", OracleDbType.Varchar2, 200);
            arrParam[1].Direction = ParameterDirection.Output;


            String cmdStr = "ars_validaciones_pkg.getperiodosdispersion";

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


        //
        // 24/11/2010      
        // Resumen DISPENSION PENSIONADO
        public static DataTable getResumenPensionados(int periodo)
        {

            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_periodo", OracleDbType.Double, 10);
            arrParam[0].Value = periodo;

            arrParam[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_resultNumber", OracleDbType.Varchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;


            String cmdStr = "SEH_PENSIONADOS_PKG.getResumePensionado";

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

        public static DataTable getPeriodosDispPensionados()
        {

            OracleParameter[] arrParam = new OracleParameter[2];

            arrParam[0] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[0].Direction = ParameterDirection.Output;

            arrParam[1] = new OracleParameter("p_resultNumber", OracleDbType.Varchar2, 200);
            arrParam[1].Direction = ParameterDirection.Output;


            String cmdStr = "SEH_PENSIONADOS_PKG.getPeriodosDispPensionado";

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

        // Milciades Hernandez  20/05/2011//
        public static DataTable getResumenEstanciaInfantiles(int Periodo)
        {

            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_Periodo", OracleDbType.Int32);
            arrParam[0].Value = Periodo;

            arrParam[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_result", OracleDbType.Varchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;


            String cmdStr = "est_infantiles_pkg.Resumen_Dispersion_inf";

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

        // Milciades Hernandez   //
        // 17/09/2010            //
        // Muestra el listado de las solicitudes que estan para Evaluación  //

        public static DataTable GetEvaluarDataActa(string Tipo,int pagenum, int pagesize)
        {

            OracleParameter[] arrParam = new OracleParameter[5];

            arrParam[0] = new OracleParameter("p_Tipo", OracleDbType.Varchar2);
            if (Tipo=="T")
            {arrParam[0].Value = null;}
            else
            { arrParam[0].Value = Tipo;}           

            arrParam[1] = new OracleParameter("p_pagenum", OracleDbType.Double);
            arrParam[1].Value = pagenum;

            arrParam[2] = new OracleParameter("p_pagesize", OracleDbType.Double);
            arrParam[2].Value = pagesize;

            arrParam[3] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[3].Direction = ParameterDirection.Output;

            arrParam[4] = new OracleParameter("p_resultNumber", OracleDbType.NVarchar2, 200);
            arrParam[4].Direction = ParameterDirection.Output;


            String cmdStr = "ars_solicitudes_pkg.get_pendientes";

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

        //Busca los registros a Asignarles NSS ( AsignacionNSS.aspx )  //
        public static DataTable getInfoAsignacionNss(int idsolicitud)
        {

            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_idsolicitud", OracleDbType.Int32);
            arrParam[0].Value = idsolicitud;

            arrParam[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_resultNumber", OracleDbType.Varchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;


            String cmdStr = "ars_solicitudes_pkg.getAsignacionNss";

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

        // Metodo para la Asignación Nss //
        public static string AsignacionNssCiudadanos(Int32 idsolicitud, string ult_usuario_act)
        {
            OracleParameter[] arrParam = new OracleParameter[7];

            arrParam[0] = new OracleParameter("p_id_solicitud", OracleDbType.Int32);
            arrParam[0].Value = idsolicitud;

            arrParam[1] = new OracleParameter("p_status", OracleDbType.NVarchar2, 200);
            arrParam[1].Value = "OK";

            arrParam[2] = new OracleParameter("p_motivo", OracleDbType.NVarchar2, 200);
            arrParam[2].Value = "0";

            arrParam[3] = new OracleParameter("p_dup_nss", OracleDbType.Int32);
            arrParam[3].Value = null;

            arrParam[4] = new OracleParameter("p_last_nss", OracleDbType.Int32);
            arrParam[4].Direction = ParameterDirection.Output;
            arrParam[5] = new OracleParameter("p_ult_usuario_act", OracleDbType.NVarchar2, 35);
            arrParam[5].Value = ult_usuario_act;
            arrParam[6] = new OracleParameter("p_resultNumber", OracleDbType.Varchar2, 1000);
            arrParam[6].Direction = ParameterDirection.Output;

            String cmdStr = "ars_solicitudes_pkg.AsignacionNssCiudadano";

            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                return arrParam[6].Value.ToString();
            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;

            }


        }

        //Rechaza las solicitudes de Asignación Nss colocandole el ID del Motivo Rechazo //

        public static string RechazarEvaluacionAsig(Int32 IdSolic, Int32 IdNssDup, string motivo, string ult_usuario_act)
        {
            OracleParameter[] arrParam = new OracleParameter[7];

            arrParam[0] = new OracleParameter("p_id_solicitud", OracleDbType.Int32);
            arrParam[0].Value = IdSolic;

            arrParam[1] = new OracleParameter("p_status", OracleDbType.NVarchar2, 200);
            arrParam[1].Value = "RE";

            arrParam[2] = new OracleParameter("p_motivo", OracleDbType.NVarchar2, 200);
            arrParam[2].Value = motivo;

            arrParam[3] = new OracleParameter("p_last_nss", OracleDbType.Int32);
            arrParam[3].Value = null;

            arrParam[4] = new OracleParameter("p_dup_nss", OracleDbType.Int32);
            if (IdNssDup > 0)
            {
                arrParam[4].Value = IdNssDup;
            }
            else {
                arrParam[4].Value = null; 
            }   
          
            arrParam[5] = new OracleParameter("p_ult_usuario_act", OracleDbType.NVarchar2, 35);
            arrParam[5].Value = ult_usuario_act;
            arrParam[6] = new OracleParameter("p_resultNumber", OracleDbType.Varchar2, 1000);
            arrParam[6].Direction = ParameterDirection.Output;

            String cmdStr = "ars_solicitudes_pkg.Aceptar_Rechazar_Evaluacion";
            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                return arrParam[6].Value.ToString();
            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;

            }
        }

        //Busca listado de Motivos por la cual a sido rechazada la solicitud  //
        public static DataTable GetMotivoRechazoAsignacion(string tipo_motivos)
        {

            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_tipo_motivos", OracleDbType.Varchar2);
            arrParam[0].Value = tipo_motivos;
            arrParam[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;
            arrParam[2] = new OracleParameter("p_resultNumber", OracleDbType.Varchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;


            String cmdStr = "ars_solicitudes_pkg.getMotivoRechazoAsig";

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

        //Busca listado de Motivos por la cual a sido rechazada la solicitud de asignacion de nss //
        public static DataTable GetMotivoRechazoNSS()
        {
            OracleParameter[] arrParam = new OracleParameter[2];
            arrParam[0] = new OracleParameter("p_cursor", OracleDbType.RefCursor);
            arrParam[0].Direction = ParameterDirection.Output;
            arrParam[1] = new OracleParameter("p_resultado", OracleDbType.Varchar2, 500);
            arrParam[1].Direction = ParameterDirection.Output;

            String cmdStr = "NSS_MOTIVO_RECHAZO";

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

        //Busca listado de NSS Duplicados  //
        public static DataTable GetNSSDuplicados(int idsolicitud)
        {

            OracleParameter[] arrParam = new OracleParameter[3];
            arrParam[0] = new OracleParameter("p_idsolicitud", OracleDbType.Int32);
            arrParam[0].Value = idsolicitud;

            arrParam[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_resultNumber", OracleDbType.Varchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;


            String cmdStr = "ars_solicitudes_pkg.getNSSDuplicados";

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

        //Busca los datos generales para un nss)  //
        public static DataTable getInfoNSSDuplicado(int idNSS)
        {
            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_id_nss", OracleDbType.Int32);
            arrParam[0].Value = idNSS;

            arrParam[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_resultNumber", OracleDbType.Varchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;


            String cmdStr = "ars_solicitudes_pkg.getInfoNSSDuplicado";

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

        //Busca la imagen acta de nacimiento para un nss)  //
        public static DataTable getImagenNSS(int idNSS)
        {
            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_id_nss", OracleDbType.Int32);
            arrParam[0].Value = idNSS;

            arrParam[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_resultNumber", OracleDbType.Varchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;


            String cmdStr = "sre_ciudadano_pkg.getImagenNSS";

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

        //Busca los registro que seran evaluado para ser Actualizado  //
        public static DataTable getInfoEvaluacionActa(string idrow)
        {

            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_rowid", OracleDbType.Varchar2);
            arrParam[0].Value = idrow;

            arrParam[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_resultNumber", OracleDbType.Varchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;


            String cmdStr = "ars_actualizacion_actas_pkg.getIDSolicitudEvaluacion";

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

        // Llena los datos para Evaluar Actualización Ciudadanos //
        public static DataTable getInfoEvaluacionActaCiudadanos(int idNSs)
        {

            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_id_nss", OracleDbType.Int32);
            arrParam[0].Value = idNSs;

            arrParam[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_resultNumber", OracleDbType.Varchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;

            String cmdStr = "ars_actualizacion_actas_pkg.getDatosCiudadanosActa";

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

        //  metodo para Actualizar los registros a ser Evaluado  //
        public static string ActualizarEvalnActaCiudadanos(string IdRow,string ult_usuario_act)
        {
            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_rowid", OracleDbType.Varchar2, 500);
            arrParam[0].Value = IdRow;
            arrParam[1] = new OracleParameter("p_ult_usuario_act", OracleDbType.NVarchar2, 35);
            arrParam[1].Value = ult_usuario_act;
            arrParam[2] = new OracleParameter("p_resultNumber", OracleDbType.Varchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;


            String cmdStr = "ars_actualizacion_actas_pkg.Actualizar_Ciudadano";
            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                return arrParam[2].Value.ToString();
            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;

            }
        }

        //   metedo para rechazar los registros de la Evaluación Visual //
        public static string RechazarEvaluacionActa(string IdRow, string Status, string motivo,string ult_usuario_act)
        {

            OracleParameter[] arrParam = new OracleParameter[5];

            arrParam[0] = new OracleParameter("p_rowid", OracleDbType.Varchar2, 200);
            arrParam[0].Value = IdRow;

            arrParam[1] = new OracleParameter("p_status", OracleDbType.Varchar2, 200);
            arrParam[1].Value = Status;
            arrParam[2] = new OracleParameter("p_motivo", OracleDbType.Varchar2, 200);
            arrParam[2].Value = motivo;
            arrParam[3] = new OracleParameter("p_ult_usuario_act", OracleDbType.NVarchar2, 35);
            arrParam[3].Value = ult_usuario_act;
            arrParam[4] = new OracleParameter("p_resultNumber", OracleDbType.Varchar2, 200);
            arrParam[4].Direction = ParameterDirection.Output;

            String cmdStr = "ars_actualizacion_actas_pkg.Aceptar_Rechazar_Evaluacion";
            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                return arrParam[4].Value.ToString();
            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;

            }
        }

        //muestra el listado de los motivos de rechazo de la solicitud //
        public static DataTable GetMotivoRechazoActa()
        {

            OracleParameter[] arrParam = new OracleParameter[2];

            arrParam[0] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[0].Direction = ParameterDirection.Output;

            arrParam[1] = new OracleParameter("p_resultNumber", OracleDbType.Varchar2, 200);
            arrParam[1].Direction = ParameterDirection.Output;


            String cmdStr = "ars_actualizacion_actas_pkg.getMotivoRechazo";

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

        //Actualiza un ciudadano duplicado y rechaza el registro en evaluacion visual
        public static string ActualizarCiudadanoDuplicado(Int32 IdSolic, Int32 idNssDuplicado, Int32 idMotivoRechazo, string ult_usuario_act)
        {
            OracleParameter[] arrParam = new OracleParameter[6];

            arrParam[0] = new OracleParameter("p_id_det_solicitud", OracleDbType.Int32);
            arrParam[0].Value = IdSolic;

            arrParam[1] = new OracleParameter("p_status", OracleDbType.NVarchar2, 200);
            arrParam[1].Value = "RE";

            arrParam[2] = new OracleParameter("p_motivo", OracleDbType.NVarchar2, 200);
            arrParam[2].Value = idMotivoRechazo;

            arrParam[3] = new OracleParameter("p_id_nss", OracleDbType.Int32);
            arrParam[3].Value = idNssDuplicado;

            arrParam[4] = new OracleParameter("p_ult_usuario_act", OracleDbType.NVarchar2, 35);
            arrParam[4].Value = ult_usuario_act;

            arrParam[5] = new OracleParameter("p_resultNumber", OracleDbType.Varchar2, 1000);
            arrParam[5].Direction = ParameterDirection.Output;

            String cmdStr = "ars_solicitudes_pkg.Actualizar_Ciudadano";
            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                if(arrParam[5].Value.ToString() != "0")
                {
                throw new Exception(arrParam[5].Value.ToString());
                }
                return arrParam[5].Value.ToString();
            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;

            }
        }


        //Muestra el listado de los casos para realizacion de elavuacion(NSS, Fallecidos, Actas, Pasaportes)
        public static DataTable getResumenCasosDuplicidad()
        {

            OracleParameter[] arrParam = new OracleParameter[2];
           

            arrParam[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_result", OracleDbType.Varchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;


            String cmdStr = "est_infantiles_pkg.Resumen_Dispersion_inf";

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

        //Muestra en un cursor el caso de evaluación visual seleccionado de un NO Extranjero de ID=4
        public static DataTable getMenorEvaluacionPadre(int idPadreEva)
        {
            OracleParameter[] arrParam = new OracleParameter[3];
            arrParam[0] = new OracleParameter("p_id_evaluacion", OracleDbType.Int32);
            arrParam[0].Value = idPadreEva;

            arrParam[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.Varchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;


            String cmdStr = "SRE_CIUDADANO_PKG.getPadreEvaluacion";
            try
            {
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);
                if (ds.Tables.Count > 0)
                {
                    return ds.Tables[0];
                }
                else
                {
                    return new DataTable("No Hay Data");
                }
            }
            catch (Exception ex)
            {
                SuirPlus.Exepciones.Log.LogToDB(ex.ToString());

                throw ex;
            }
        }

        //Muestra en un cursor las concidencias caso de evaluación visual seleccionado de un NO Extranjero de ID=4
        public static DataTable getMenorEvaluacionHijo(int idPadreEva)
        {
            OracleParameter[] arrParam = new OracleParameter[3];
            arrParam[0] = new OracleParameter("p_id_evaluacion", OracleDbType.Int32);
            arrParam[0].Value = idPadreEva;

            arrParam[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.Varchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;


            String cmdStr = "SRE_CIUDADANO_PKG.getMenorEvaluacion";
            try
            {
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);
                if (ds.Tables.Count > 0)
                {
                    return ds.Tables[0];
                }
                else
                {
                    return new DataTable("No Hay Data"); 
                }
            }
            catch (Exception ex)
            {
                SuirPlus.Exepciones.Log.LogToDB(ex.ToString());

                throw ex;
            }
        }

        //Realiza el cambio de estatus de alguna concidencia seleccionada en la pantalla MenorAMayorCedulado
        public static string gestionarConcidencia(int ? nss, string no_documento, string status, string usuario) {
            OracleParameter[] arrParam = new OracleParameter[5];

            arrParam[0] = new OracleParameter("p_id_nss", OracleDbType.Int32, 10);
            arrParam[0].Value = nss;

            arrParam[1] = new OracleParameter("p_documento", OracleDbType.NVarchar2, 25);
            arrParam[1].Value = no_documento;

            arrParam[2] = new OracleParameter("p_status", OracleDbType.NVarchar2);
            arrParam[2].Value = status;

            arrParam[3] = new OracleParameter("p_ULT_USUARIO_ACT", OracleDbType.NVarchar2);
            arrParam[3].Value = usuario;

            arrParam[4] = new OracleParameter("p_resultNumber", OracleDbType.Varchar2, 200);
            arrParam[4].Direction = ParameterDirection.Output;

            String cmdStr = "sre_ciudadano_pkg.ActualizarMenor";
            int inserResult;
            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                inserResult = arrParam[4].Value.ToString().IndexOf("|");

                if (inserResult != -1)
                {
                    string[] arr = arrParam[4].Value.ToString().Split('|');
                    if (arr[0] == "0")
                        return arrParam[4].Value.ToString();
                }
                else {
                    if (arrParam[4].Value.ToString() == "1")
                    {
                        //Si es menos 1 significa que la conincidencia hacido actualizada con exito!
                        return arrParam[4].Value.ToString();
                    }
                    else if (arrParam[4].Value.ToString() == "-1")
                    {
                        //Si es menos -1 significa que la conincidencia hacido cancelada con exito!
                        return arrParam[4].Value.ToString();
                    }
                }
                //Si lanza un error!
                throw new Exception(arrParam[4].Value.ToString());
            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;

            }
        }

        #region "Metodos para la evaluacion de las actas de defunción"

        public static DataTable GetFallecidos(int pagenum, int pagesize)
        {

            OracleParameter[] arrParam = new OracleParameter[4];

            arrParam[0] = new OracleParameter("p_pagenum", OracleDbType.Double);
            arrParam[0].Value = pagenum;

            arrParam[1] = new OracleParameter("p_pagesize", OracleDbType.Double);
            arrParam[1].Value = pagesize;

            arrParam[2] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[2].Direction = ParameterDirection.Output;

            arrParam[3] = new OracleParameter("p_resultNumber", OracleDbType.NVarchar2, 200);
            arrParam[3].Direction = ParameterDirection.Output;


            String cmdStr = "SRE_NOVEDADES_FALLECIDOS_PKG. getFallecidos";

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

        // Llena los datos para Evaluar Actualización Ciudadanos //
        public static DataTable getInfoEvaluacionActaFallecido()
        {

            OracleParameter[] arrParam = new OracleParameter[2];


            arrParam[0] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[0].Direction = ParameterDirection.Output;

            arrParam[1] = new OracleParameter("p_resultNumber", OracleDbType.Varchar2, 200);
            arrParam[1].Direction = ParameterDirection.Output;

            String cmdStr = "SRE_NOVEDADES_FALLECIDOS_PKG.getDatosCiudadanos";

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

        //  metodo para Actualizar los registros a ser Evaluado  //
        public static string ActualizarFallecimientoCiudadanos(int novedad, string usuario)
        {
            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_Novedad", OracleDbType.Int32);
            arrParam[0].Value = novedad;

            arrParam[1] = new OracleParameter("p_usuario", OracleDbType.Varchar2);
            arrParam[1].Value = usuario;

            arrParam[2] = new OracleParameter("p_resultNumber", OracleDbType.Varchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;


            String cmdStr = "SRE_NOVEDADES_FALLECIDOS_PKG.ActualizarCiudadano";
            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                return arrParam[2].Value.ToString();
            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;

            }
        }

        //   metedo para rechazar los registros de la Evaluación Visual //
        public static string RechazarEvaluacionFallecido(int novedad, string motivo, string usuario)
        {
            OracleParameter[] arrParam = new OracleParameter[4];

            arrParam[0] = new OracleParameter("p_Novedad", OracleDbType.Int32);
            arrParam[0].Value = novedad;

            arrParam[1] = new OracleParameter("p_motivo", OracleDbType.Varchar2, 200);
            arrParam[1].Value = motivo;

            arrParam[2] = new OracleParameter("p_usuario", OracleDbType.Varchar2, 200);
            arrParam[2].Value = usuario;

            arrParam[3] = new OracleParameter("p_resultNumber", OracleDbType.Varchar2, 200);
            arrParam[3].Direction = ParameterDirection.Output;

            String cmdStr = "SRE_NOVEDADES_FALLECIDOS_PKG.RechazarEvaluacion";
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

        //muestra el listado de los motivos de rechazo del fallecimiento //
        public static DataTable GetMotivosRechazoFallecimiento()
        {

            OracleParameter[] arrParam = new OracleParameter[2];

            arrParam[0] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[0].Direction = ParameterDirection.Output;

            arrParam[1] = new OracleParameter("p_resultNumber", OracleDbType.Varchar2, 200);
            arrParam[1].Direction = ParameterDirection.Output;


            String cmdStr = "SRE_NOVEDADES_FALLECIDOS_PKG.getMotivoRechazo";

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


        public static string ActStatusEvaluacion(string  status, int error, string usuario)
        {
            OracleParameter[] arrParam = new OracleParameter[4];

            arrParam[0] = new OracleParameter("p_status", OracleDbType.Int32);
            arrParam[0].Value = status;

            arrParam[1] = new OracleParameter("p_error", OracleDbType.Varchar2, 200);
            arrParam[1].Value = error;

            arrParam[2] = new OracleParameter("p_usuario", OracleDbType.Varchar2, 200);
            arrParam[2].Value = usuario;

            arrParam[3] = new OracleParameter("p_resultNumber", OracleDbType.Varchar2, 200);
            arrParam[3].Direction = ParameterDirection.Output;

            String cmdStr = "SRE_NOVEDADES_FALLECIDOS_PKG.RechazarEvaluacion";
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

        #endregion


        #region "Metodos de la Clase SuirPlus.Empresa ARS"

        public static DataTable consultaARS(string documento, ref string nombreTitular, ref string aRSTitular, ref string statusTitular, ref string tipoAfiliacionTitular, ref string fechaAfiliacionTitular)
        {

            OracleParameter[] arrParam = new OracleParameter[9];

            arrParam[0] = new OracleParameter("p_nss_cedula", OracleDbType.Varchar2, 11);
            arrParam[0].Value = documento;
            arrParam[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;
            arrParam[2] = new OracleParameter("p_sino", OracleDbType.Varchar2, 2);
            arrParam[2].Direction = ParameterDirection.Output;
            arrParam[3] = new OracleParameter("p_resultNumber", OracleDbType.Varchar2, 45);
            arrParam[3].Direction = ParameterDirection.Output;
            arrParam[4] = new OracleParameter("p_nombre_titular", OracleDbType.NVarchar2, 200);
            arrParam[4].Direction = ParameterDirection.Output;
            arrParam[5] = new OracleParameter("p_ars_titular", OracleDbType.NVarchar2, 200);
            arrParam[5].Direction = ParameterDirection.Output;
            arrParam[6] = new OracleParameter("p_estatus_titular", OracleDbType.NVarchar2, 200);
            arrParam[6].Direction = ParameterDirection.Output;
            arrParam[7] = new OracleParameter("p_tipo_afiliacion_titular", OracleDbType.NVarchar2, 200);
            arrParam[7].Direction = ParameterDirection.Output;
            arrParam[8] = new OracleParameter("p_Fecha_Afiliacion_titular", OracleDbType.NVarchar2, 15);
            arrParam[8].Direction = ParameterDirection.Output;


            String cmdStr = "SRE_ARS_PKG.getCambiosARS";

            try
            {
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);
                PuedeCambiarArs = arrParam[2].Value.ToString();

                if (arrParam[3].Value.ToString().StartsWith("0"))
                {
                    //Verificar si tiene titular///////////
                    nombreTitular = arrParam[4].Value.ToString().Equals("null") ? string.Empty : arrParam[4].Value.ToString();
                    aRSTitular = arrParam[5].Value.ToString().Equals("null") ? string.Empty : arrParam[5].Value.ToString();
                    statusTitular = arrParam[6].Value.ToString().Equals("null") ? string.Empty : arrParam[6].Value.ToString();

                    if (arrParam[8].Value.ToString() != "null")
                    {
                        tipoAfiliacionTitular = arrParam[7].Value.ToString();
                        fechaAfiliacionTitular = arrParam[8].Value.ToString();
                    }
                    else
                    {
                        tipoAfiliacionTitular = string.Empty;
                        fechaAfiliacionTitular = string.Empty;
                    }
                    ///////////////////////////////////////

                    if (ds.Tables.Count > 0)
                    {
                        return ds.Tables[0];
                    }
                    else
                    {
                        return null;
                    }
                }
                else
                {
                    PuedeCambiarArs = arrParam[3].Value.ToString().Split('|')[1].ToString();
                    return null;
                }

            }
            catch (Exception ex)
            {
                throw ex;
            }

        }

        public static DataTable consultaAfilado(string nroCedula, ref string Nombre, ref string ARS, ref string Status, ref string TipoAfiliacion, ref string FechaAfiliacion, ref string Resultado)
        {
            OracleParameter[] arrParam = new OracleParameter[8];

            arrParam[0] = new OracleParameter("p_cedula", OracleDbType.NVarchar2, 11);
            arrParam[0].Value = nroCedula;
            arrParam[1] = new OracleParameter("p_nombre", OracleDbType.NVarchar2, 200);
            arrParam[1].Direction = ParameterDirection.Output;
            arrParam[2] = new OracleParameter("p_ars", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;
            arrParam[3] = new OracleParameter("p_estatus", OracleDbType.NVarchar2, 200);
            arrParam[3].Direction = ParameterDirection.Output;
            arrParam[4] = new OracleParameter("p_tipo_afiliacion", OracleDbType.NVarchar2, 200);
            arrParam[4].Direction = ParameterDirection.Output;
            arrParam[5] = new OracleParameter("p_Fecha_Afiliacion", OracleDbType.NVarchar2, 15);
            arrParam[5].Direction = ParameterDirection.Output;
            arrParam[6] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[6].Direction = ParameterDirection.Output;
            arrParam[7] = new OracleParameter("p_resultNumber", OracleDbType.NVarchar2, 200);
            arrParam[7].Direction = ParameterDirection.Output;

            String cmdStr = "SRE_ARS_PKG.consultaAfiliados";
            try
            {
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);

                Resultado = arrParam[7].Value.ToString().Equals("null") ? string.Empty : arrParam[7].Value.ToString();
                Nombre = arrParam[1].Value.ToString().Equals("null") ? string.Empty : arrParam[1].Value.ToString();
                ARS = arrParam[2].Value.ToString().Equals("null") ? string.Empty : arrParam[2].Value.ToString();
                Status = arrParam[3].Value.ToString().Equals("null") ? string.Empty : arrParam[3].Value.ToString();


                if (arrParam[5].Value.ToString() != "null")
                { TipoAfiliacion = arrParam[4].Value.ToString(); }
                else
                { TipoAfiliacion = string.Empty; }

                if (arrParam[5].Value.ToString() != "null")
                { FechaAfiliacion = arrParam[5].Value.ToString(); }
                else
                {
                    FechaAfiliacion = string.Empty;
                }

                if (ds.Tables.Count > 0)
                {
                    return ds.Tables[0];
                }
                else
                {
                    return null;
                }

            }

            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                try
                {
                    Resultado = arrParam[7].Value.ToString();
                    Nombre = arrParam[1].Value.ToString();
                    ARS = arrParam[2].Value.ToString();
                    Status = arrParam[3].Value.ToString();
                    TipoAfiliacion = arrParam[4].Value.ToString();
                    FechaAfiliacion = arrParam[5].Value.ToString();
                }
                catch (Exception)
                {

                    throw;
                }

                throw ex;
            }
        }
        public static DataTable consultaAfiliadosPorEmpresa(int regPat, int pageNum, int pageSize)
        {
            OracleParameter[] arrParam = new OracleParameter[5];

            arrParam[0] = new OracleParameter("p_regPat", OracleDbType.Int32);
            arrParam[0].Value = regPat;
            arrParam[1] = new OracleParameter("p_pageNum", OracleDbType.Int32);
            arrParam[1].Value = pageNum;
            arrParam[2] = new OracleParameter("p_pageSize", OracleDbType.Int32);
            arrParam[2].Value = pageSize;
            arrParam[3] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[3].Direction = ParameterDirection.Output;
            arrParam[4] = new OracleParameter("p_resultNumber", OracleDbType.NVarchar2, 200);
            arrParam[4].Direction = ParameterDirection.Output;

            string cmdstr = "SRE_ARS_PKG.consultaAfiliadosPorEmpresa";
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

        //Metodo creado para formar el archivo que se exporta a excel
        //by Charlie L. Peña
        public static DataTable consAfiliadosPorEmpresaFull(int regPat)
        {
            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_regPat", OracleDbType.Int32);
            arrParam[0].Value = regPat;
            arrParam[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;
            arrParam[2] = new OracleParameter("p_resultNumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;

            string cmdstr = "SRE_ARS_PKG.consAfiliadosPorEmpresa";
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

        public static DataTable consultaNucleoFamiliar(int regPat)
        {
            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_idRegPat", OracleDbType.Int32);
            arrParam[0].Value = regPat;
            arrParam[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;
            arrParam[2] = new OracleParameter("p_resultNumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;
            string cdmstr = "SRE_ARS_PKG.consultaNucleoFamiliar";
            try
            {
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cdmstr, arrParam);
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

        public static DataTable getMenores(string nodocumento, string idnss)
        {
            string res = string.Empty;
            string Resultado = string.Empty;
            OracleParameter[] arrParam = new OracleParameter[4];

            arrParam[0] = new OracleParameter("p_no_documento", OracleDbType.NVarchar2, 20);
            arrParam[0].Value = SuirPlus.Utilitarios.Utils.verificarNulo(nodocumento);

            arrParam[1] = new OracleParameter("p_id_nss", OracleDbType.Int64);
            arrParam[1].Value = SuirPlus.Utilitarios.Utils.verificarNulo(idnss);

            arrParam[2] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[2].Direction = ParameterDirection.Output;

            arrParam[3] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 1000);
            arrParam[3].Direction = ParameterDirection.Output;


            String cmdStr = "ars_solicitudes_pkg.getMenores";

            try
            {
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);
                if (ds.Tables.Count > 0)

                    Resultado = arrParam[3].Value.ToString();
                {
                    if (Resultado != "0")
                    {
                        res = Resultado.Split('|')[1].ToString();
                        throw new Exception(res);

                    }

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

        public static DataTable getARS()
        {
            string res = string.Empty;
            string Resultado = string.Empty;
            OracleParameter[] arrParam = new OracleParameter[2];

            arrParam[0] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[0].Direction = ParameterDirection.Output;

            arrParam[1] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 1000);
            arrParam[1].Direction = ParameterDirection.Output;


            String cmdStr = "sre_ars_pkg.getARS";

            try
            {
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);
                if (ds.Tables.Count > 0)

                    Resultado = arrParam[1].Value.ToString();
                {
                    if (Resultado != "0")
                    {
                        res = Resultado.Split('|')[1].ToString();
                        throw new Exception(res);

                    }

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

        public override void CargarDatos()
        {
            throw new Exception("The method or operation is not implemented.");
        }

        public override string GuardarCambios(string UsuarioResponsable)
        {
            throw new Exception("The method or operation is not implemented.");
        }
        
        public static string consultaAfiliado(string nroCedula)
        {

            OracleParameter[] arrParam = new OracleParameter[2];

            arrParam[0] = new OracleParameter("p_nroCedula", OracleDbType.NVarchar2, 11);
            arrParam[0].Value = nroCedula;
            arrParam[1] = new OracleParameter("Res", OracleDbType.NVarchar2, 300);
            arrParam[1].Direction = ParameterDirection.Output;

            String cmdStr = "SRE_ARS_PKG.consultaAfiliado";

            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);

                return arrParam[1].Value.ToString();
            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;
            }

        }

        //Metodo Utilizado en la oficina Virtual (Empleadores Reportados)
        public static DataTable getEmpReportados(string nroCedula)
        {
            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_nroCedula", OracleDbType.NVarchar2, 11);
            arrParam[0].Value = nroCedula;
            arrParam[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;
            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 1000);
            arrParam[2].Direction = ParameterDirection.Output;

            String cmdStr = "OFICINA_VIRTUAL_PKG.getempresasreportan";
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
        #endregion


    }
}
