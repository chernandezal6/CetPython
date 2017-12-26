using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using Oracle.ManagedDataAccess.Client;
using SuirPlus.DataBase;
namespace SuirPlus.Legal
{
    public class Cobro 
    {

        public static DataTable getCarteras(string Tipo, string status)
        {
            OracleParameter[] arrParam = new OracleParameter[4];
            arrParam[0] = new OracleParameter("p_Status", OracleDbType.Char);
            arrParam[0].Value = status;
            arrParam[1] = new OracleParameter("P_tipo", OracleDbType.Char);
            arrParam[1].Value = Tipo;
            arrParam[2] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[2].Direction = ParameterDirection.Output;
            arrParam[3] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[3].Direction = ParameterDirection.Output;

            String cmdStr = "cob_cobro_pkg.Get_Carteras";

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

        public static string Asigna_Cartera(int IDCartera, string IDUsuario)
        {

            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("P_Id_Cartera", OracleDbType.Double);
            arrParam[0].Value = IDCartera;
            arrParam[1] = new OracleParameter("p_id_Usuario", OracleDbType.NVarchar2, 35);
            arrParam[1].Value = IDUsuario;
            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;

            String cmdStr = "cob_cobro_pkg.Asigna_Cartera";

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

        public static DataTable getCarterasAsignadas(string status)
        {
            OracleParameter[] arrParam = new OracleParameter[3];
            arrParam[0] = new OracleParameter("p_status", OracleDbType.Char);
            arrParam[0].Value = status;           
            arrParam[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;
            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;

            String cmdStr = "cob_cobro_pkg.get_all_Cartera_Asignada";

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


        public static string DeAsignaCartera(int IDCartera, string IDUsuario)
        {

            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("P_Id_Cartera", OracleDbType.Double);
            arrParam[0].Value = IDCartera;
            arrParam[1] = new OracleParameter("p_id_Usuario", OracleDbType.NVarchar2, 35);
            arrParam[1].Value = IDUsuario;
            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;

            String cmdStr = "cob_cobro_pkg.Deasigna_Cartera";

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


        public static DataTable getCarteraAsignada(string Usuario)
        {
            OracleParameter[] arrParam = new OracleParameter[3];
            arrParam[0] = new OracleParameter("p_id_Usuario", OracleDbType.NVarchar2);
            arrParam[0].Value = Usuario;
            arrParam[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;
            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;

            String cmdStr = "cob_cobro_pkg.getCartera_Asignada";

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


        public static DataTable getEmpresasAsignadas(int IDCartera,string RNC,string RazonSocial, int NoSeguimiento, int pagenum, int pagesize)
        {
            OracleParameter[] arrParam = new OracleParameter[8];

            arrParam[0] = new OracleParameter("P_Id_Cartera", OracleDbType.Double);
            arrParam[0].Value = IDCartera;

            arrParam[1] = new OracleParameter("p_rnc_o_cedula", OracleDbType.Varchar2);
            arrParam[1].Value = RNC;

            arrParam[2] = new OracleParameter("p_razon_social", OracleDbType.Varchar2);
            arrParam[2].Value = RazonSocial;

            arrParam[3] = new OracleParameter("p_Nseguimiento", OracleDbType.Double);

            if (NoSeguimiento == -1)
            {
                arrParam[3].Value = DBNull.Value;
            }
            else
            {
                arrParam[3].Value = NoSeguimiento;
            }

            arrParam[4] = new OracleParameter("p_pagenum", OracleDbType.Double);
            arrParam[4].Value = pagenum;

            arrParam[5] = new OracleParameter("p_pagesize", OracleDbType.Double);
            arrParam[5].Value = pagesize;

            arrParam[6] = new OracleParameter("p_cursor", OracleDbType.RefCursor);
            arrParam[6].Direction = ParameterDirection.Output;

            arrParam[7] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[7].Direction = ParameterDirection.Output;


            String cmdStr = "cob_cobro_pkg.getEmpresa_por_Cartera";

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


        public static DataTable getStatusCobro()
        {
            OracleParameter[] arrParam = new OracleParameter[2];
            arrParam[0] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[0].Direction = ParameterDirection.Output;
            arrParam[1] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[1].Direction = ParameterDirection.Output;

            String cmdStr = "cob_cobro_pkg.Get_Status";

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

        public static DataTable getNotificacionesPendientes(string usuario, DateTime fechaNotifacion, int idCartera)
        {
            OracleParameter[] arrParam = new OracleParameter[5];

            arrParam[0] = new OracleParameter("p_id_Usuario", OracleDbType.NVarchar2);
            arrParam[0].Value = usuario;
            arrParam[1] = new OracleParameter("p_fechaNotifica", OracleDbType.Date);
            arrParam[1].Value = fechaNotifacion;
            arrParam[2] = new OracleParameter("p_id_Cartera", OracleDbType.Double);
            arrParam[2].Value = idCartera;          
            arrParam[3] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[3].Direction = ParameterDirection.Output;
            arrParam[4] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[4].Direction = ParameterDirection.Output;

            String cmdStr = "cob_cobro_pkg.GetNotificacionPendiente";

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

        //--- Por Milciades Hernandez 
        //--- 12/11/2009
        //--- Reporte_Cobro
        // Mod 03/29/2010 F.R.
        /// <summary>
        /// Metodo para obtener la cantidad de seguimientos por usuario.
        /// </summary>
        /// <param name="RNC">RNC de la empresa</param>
        /// <param name="Razon_Social">Nombre de la Razon Social</param>
        /// <param name="Usuario">Usuario</param>
        /// <param name="Nro_Seguimiento">Nro Seguimiento</param>
        /// <returns></returns>
        public static DataTable getReporteCobros(String Usuario)
        {

            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_usuario", OracleDbType.NVarchar2);
            arrParam[0].Value = Usuario.Equals("0") ? DBNull.Value.ToString() : Usuario;

            arrParam[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;

            String cmdStr = "cob_cobro_pkg.Reporte_cobranza";

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
        /// <summary>
        /// Muestra la cantidad de seguimientos por cartera
        /// </summary>
        /// <param name="Id_Cartera">La Cartera que desea ver los seguimientos.</param>
        /// <returns></returns>
        public static DataTable getReporteCobros(Int32 Id_Cartera)
        {
            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_id_cartera", OracleDbType.Int32);
            arrParam[0].Value = Id_Cartera;

            arrParam[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;

            String cmdStr = "cob_cobro_pkg.Reporte_cobranza_Usuario";

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
        /// <summary>
        /// Listado de CRMs por Cartera y usuario
        /// </summary>
        /// <param name="Id_Cartera">Cartera</param>
        /// <param name="Usuario">Usuario</param>
        /// <returns></returns>
        public static DataTable getReporteCobros(Int32 Id_Cartera, String Usuario, Int32 pagenum, Int32 pagesize) 
        {
            OracleParameter[] arrParam = new OracleParameter[6];

            arrParam[0] = new OracleParameter("p_id_cartera", OracleDbType.Int32);
            arrParam[0].Value = Id_Cartera;

            arrParam[1] = new OracleParameter("p_usuario", OracleDbType.NVarchar2);
            arrParam[1].Value = Usuario;

            arrParam[2] = new OracleParameter("pagenum ", OracleDbType.Int32);
            arrParam[2].Value = pagenum; 

            arrParam[3] = new OracleParameter("p_pagesize ", OracleDbType.Int32);
            arrParam[3].Value = pagesize; 


            arrParam[4] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[4].Direction = ParameterDirection.Output;

            arrParam[5] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[5].Direction = ParameterDirection.Output;

            String cmdStr = "cob_cobro_pkg.Usuarios_CRM_Cobros";

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

        /// <summary>
        /// Metodo para listar los usuarios con carteras asignadas de cobros
        /// </summary>
        /// <returns></returns>
        public static DataTable getUsuarios()
        {
            OracleParameter[] arrParam = new OracleParameter[2];

            arrParam[0] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[0].Direction = ParameterDirection.Output;

            arrParam[1] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[1].Direction = ParameterDirection.Output;

            String cmdStr = "cob_cobro_pkg.Usuarios_Cartera";

            try
            {
                return DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam).Tables[0]; 
                  
            }

            catch (Exception ex)
            {

                Exepciones.Log.LogToDB(ex.ToString());

                throw ex;

            }
        }
              
        public static DataTable listadoPeriodo ()
        {
            OracleParameter[] arrParam = new OracleParameter[2];
            arrParam[0] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[0].Direction = ParameterDirection.Output;
            arrParam[1] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[1].Direction = ParameterDirection.Output;

            String cmdStr = "cob_cobro_pkg.listadoPeriodoCob";

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

        //metodos utilizados para la gestion de cobros**********************************************************************************************
        //by Charlie Peña

        //Trae un listado de los usuarios asignadaos en las diferentes carteras de cobro
        public static DataTable getUsuariosCarteras()
        {
            OracleParameter[] arrParam = new OracleParameter[2];

            arrParam[0] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[0].Direction = ParameterDirection.Output;

            arrParam[1] = new OracleParameter("p_resultnumber", OracleDbType.Varchar2, 500);
            arrParam[1].Direction = ParameterDirection.Output;

            String cmdStr = "cob_cobro_pkg.getusuarioscarteras";

            try
            {
                return DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam).Tables[0];

            }

            catch (Exception ex)
            {

                Exepciones.Log.LogToDB(ex.ToString());

                throw ex;

            }
        }

        //Trae un resumen de la gestion de cobros realizada de acuerdos a los parametros especificados y un conjunto de estatus internos que indican el seguimiento brindado...
        //si no se pasan periodos, trae el resumen de la gestion de cobros basado en el periodo inmediatamente anterior al vigente
        public static DataTable getGestionCobros(string usuario, string periodoDesde,string periodoHasta)
        {
            OracleParameter[] arrParam = new OracleParameter[5];

            arrParam[0] = new OracleParameter("p_usuario", OracleDbType.Varchar2);
            arrParam[0].Value = usuario;
            arrParam[1] = new OracleParameter("p_periododesde", OracleDbType.Varchar2);
            arrParam[1].Value = periodoDesde;
            arrParam[2] = new OracleParameter("p_periodohasta", OracleDbType.Varchar2);
            arrParam[2].Value = periodoHasta;
            arrParam[3] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[3].Direction = ParameterDirection.Output;
            arrParam[4] = new OracleParameter("p_resultnumber", OracleDbType.Varchar2, 500);
            arrParam[4].Direction = ParameterDirection.Output;

            String cmdStr = "cob_cobro_pkg.gestioncobros";

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

        //Trae un detalle de la gestion de cobros por cartera , periodo y usuario especificado
        public static DataTable getDetGestionCobros(int idCartera, string usuario, int periodo, Int16 pageNum, Int16 pageSize)
        {
            OracleParameter[] arrParam = new OracleParameter[7];

            arrParam[0] = new OracleParameter("p_idcartera", OracleDbType.Int32);
            arrParam[0].Value = idCartera;
            arrParam[1] = new OracleParameter("p_usuario", OracleDbType.Varchar2);
            arrParam[1].Value = usuario;
            arrParam[2] = new OracleParameter("p_periodo", OracleDbType.Int32);
            arrParam[2].Value = periodo;
            arrParam[3] = new OracleParameter("p_pagenum", OracleDbType.Int16);
            arrParam[3].Value = pageNum;
            arrParam[4] = new OracleParameter("p_pagesize", OracleDbType.Int16);
            arrParam[4].Value = pageSize;
            arrParam[5] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[5].Direction = ParameterDirection.Output;
            arrParam[6] = new OracleParameter("p_resultnumber", OracleDbType.Varchar2, 500);
            arrParam[6].Direction = ParameterDirection.Output;

            String cmdStr = "cob_cobro_pkg.detgestioncobros";

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

        public static DataTable getGestionCobrosPorResultado()
        {
            OracleParameter[] arrParam = new OracleParameter[2];

            arrParam[0] = new OracleParameter("p_io_cursor", OracleDbType.RefCursor);
            arrParam[0].Direction = ParameterDirection.Output;
            arrParam[1] = new OracleParameter("p_resultnumber", OracleDbType.Varchar2, 500);
            arrParam[1].Direction = ParameterDirection.Output;

            String cmdStr = "cob_cobro_pkg.resultadogestioncobro";

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

