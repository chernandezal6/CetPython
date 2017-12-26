using System;
using SuirPlus;
using System.Collections.Generic;
using System.Text;
using System.Data;
using Oracle.ManagedDataAccess.Client;

namespace SuirPlus.Empresas
{
    /// <summary>
    /// Clase que agrupa los metodos que proveen la funcionalidad necesaria para el CRM
    /// </summary>
    public class CRM
    {
        /// <summary>
        /// Metodo para traer un listado de todos los CRM que se le a realizado a una persona.
        /// </summary>
        /// <param name="idRegistroPatronal">Registro Patronal</param>
        /// <returns>Un DataTable con todos los CRM realizados a ese empleador</returns>
        
        public static DataTable getCRMs(int idRegistroPatronal)
        {
            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_registro_patronal", OracleDbType.Decimal);
            arrParam[0].Value = idRegistroPatronal;
            arrParam[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;
            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;

            String cmdStr = "Emp_Crm_Pkg.GetRegistros";

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

        public static DataTable getReporteCRM(int idRegistroPatronal, int idTipoRegistro, DateTime fechaDesde, DateTime fechaHasta)
        {
            OracleParameter[] arrParam = new OracleParameter[6];

            arrParam[0] = new OracleParameter("p_id_registro_patronal", OracleDbType.Decimal);
            arrParam[0].Value = idRegistroPatronal;
            arrParam[1] = new OracleParameter("p_tipo_registro", OracleDbType.Decimal);
            arrParam[1].Value = SuirPlus.Utilitarios.Utils.verificarNulo(idTipoRegistro);
            arrParam[2] = new OracleParameter("p_fecha_ini", OracleDbType.Date);
            arrParam[2].Value = fechaDesde;
            arrParam[3] = new OracleParameter("p_fecha_fin", OracleDbType.Date);
            arrParam[3].Value = fechaHasta;
            arrParam[4] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[4].Direction = ParameterDirection.Output;
            arrParam[5] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[5].Direction = ParameterDirection.Output;

            String cmdStr = "Emp_Crm_Pkg.GetReg_rangofechas";

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

        public static DataTable getTiposCRM(int idTipo)
        {
            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_idtipo", OracleDbType.Decimal);
            arrParam[0].Value = Utilitarios.Utils.verificarNulo(idTipo);
            arrParam[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;
            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;

            String cmdStr = "Emp_Crm_Pkg.Get_Tipos_CRM";

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

        public static DataTable getUtimosCRM(int idRegistroPatronal)
        {
            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_registro_patronal", OracleDbType.Decimal);
            arrParam[0].Value = idRegistroPatronal;
            arrParam[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;
            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;

            String cmdStr = "Emp_Crm_Pkg.GetUltimosRegistros";

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


        public static DataTable getUtimosCRM(int idRegistroPatronal,int idCartera)
        {
            OracleParameter[] arrParam = new OracleParameter[4];

            arrParam[0] = new OracleParameter("p_registro_patronal", OracleDbType.Decimal);
            arrParam[0].Value = idRegistroPatronal;
            arrParam[1] = new OracleParameter("p_id_cartera", OracleDbType.Decimal);
            arrParam[1].Value = idCartera;
            arrParam[2] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[2].Direction = ParameterDirection.Output;
            arrParam[3] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[3].Direction = ParameterDirection.Output;

            String cmdStr = "Emp_Crm_Pkg.GetUltimosRegistros";

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
        /// Metodo utilizado para insertar un registro CRM
        /// </summary>
        /// <param name="registroPatronal">Registro patronal del empleador.</param>
        /// <param name="asunto">Asunto del Registro</param>
        /// <param name="tipoRegistro">Tipo de Registro</param>
        /// <param name="contacto">Persona de Contacto</param>
        /// <param name="registroDes">Descripcion del Registro</param>
        /// <param name="usuario">Usuario que hace el registro.</param>
        /// <param name="fechaNotificacion">Fecha de Notificacion</param>
        /// <param name="mailAdd1">Email de notificacion1</param>
        /// <param name="mailAdd2">Email de notificacion2</param>
        /// <returns></returns>
        public static string insertaRegistroCRM(Int32 registroPatronal,
            String asunto,
            Int32 tipoRegistro,
            Int32 tipoSolicitud,
            String contacto,
            String registroDes,
            String usuario,
            DateTime? fechaNotificacion,
            String mailAdd1,
            String mailAdd2)
        {
            //throw new Exception(registroPatronal.ToString() + " | " + asunto + " | " + tipoRegistro.ToString() + " | " + contacto + " | " + registroDes + " | " + usuario + " | " + fechaNotificacion.ToString());

            OracleParameter[] arrParam = new OracleParameter[11];
            String cmdStr = "Emp_CRM_PKG.CrearEmp_Crm";

            arrParam[0] = new OracleParameter("p_registro_patronal", OracleDbType.Decimal, 9);
            arrParam[0].Value = registroPatronal;

            arrParam[1] = new OracleParameter("p_asunto", OracleDbType.NVarchar2, 50);
            arrParam[1].Value = asunto;

            arrParam[2] = new OracleParameter("p_tipo_registro", OracleDbType.Decimal, 9);
            arrParam[2].Value = tipoRegistro;

            arrParam[3] = new OracleParameter("p_tipo_Solicitud", OracleDbType.Decimal, 9);
            arrParam[3].Value = tipoSolicitud;

            arrParam[4] = new OracleParameter("p_contacto", OracleDbType.NVarchar2, 50);
            arrParam[4].Value = contacto;

            arrParam[5] = new OracleParameter("p_registro_des", OracleDbType.NVarchar2, 4000);
            arrParam[5].Value = registroDes;

            arrParam[6] = new OracleParameter("p_usuario", OracleDbType.NVarchar2, 35);
            arrParam[6].Value = usuario;

            arrParam[7] = new OracleParameter("p_fecha_notificacion", OracleDbType.Date);
            if (fechaNotificacion.HasValue)
            {
                arrParam[7].Value = fechaNotificacion.Value;
            }
            else
            {
                arrParam[7].Value = DBNull.Value;
            }


            arrParam[8] = new OracleParameter("p_MAIL_ADICIONAL_1", OracleDbType.NVarchar2, 50);
            arrParam[8].Value = mailAdd1;

            arrParam[9] = new OracleParameter("p_MAIL_ADICIONAL_2", OracleDbType.NVarchar2, 50);
            arrParam[9].Value = mailAdd2;

            arrParam[10] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[10].Direction = ParameterDirection.Output;


            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                return arrParam[10].Value.ToString();
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }

        public static int getCrmCount(Int32 registroPatronal)
        {
            //throw new Exception(registroPatronal.ToString() + " | " + asunto + " | " + tipoRegistro.ToString() + " | " + contacto + " | " + registroDes + " | " + usuario + " | " + fechaNotificacion.ToString());

            OracleParameter[] arrParam = new OracleParameter[2];

            arrParam[0] = new OracleParameter("p_registro_patronal", OracleDbType.Decimal, 9);
            arrParam[0].Value = registroPatronal;
            arrParam[1] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[1].Direction = ParameterDirection.Output;

            try
            {
                String cmdStr = "Emp_CRM_PKG.Get_Registros";
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                return int.Parse(arrParam[1].Value.ToString());
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }


        public static string insertaRegistroCRMCobro(Int32 registroPatronal,
           String asunto,
           Int32 tipoRegistro,
           String contacto,
           String registroDes,
           String usuario,
           DateTime? fechaNotificacion,
           String mailAdd1,
           String mailAdd2,
           String StatusCobro,
           Int32 IDCartera)
        {
            

            OracleParameter[] arrParam = new OracleParameter[12];
            String cmdStr = "Emp_CRM_PKG.CrearEmp_Crm";

            arrParam[0] = new OracleParameter("p_registro_patronal", OracleDbType.Decimal, 9);
            arrParam[0].Value = registroPatronal;

            arrParam[1] = new OracleParameter("p_asunto", OracleDbType.NVarchar2, 50);
            arrParam[1].Value = asunto;

            arrParam[2] = new OracleParameter("p_tipo_registro", OracleDbType.Decimal, 9);
            arrParam[2].Value = tipoRegistro;

            arrParam[3] = new OracleParameter("p_contacto", OracleDbType.NVarchar2, 50);
            arrParam[3].Value = contacto;

            arrParam[4] = new OracleParameter("p_registro_des", OracleDbType.NVarchar2, 4000);
            arrParam[4].Value = registroDes;

            arrParam[5] = new OracleParameter("p_usuario", OracleDbType.NVarchar2, 35);
            arrParam[5].Value = usuario;

            arrParam[6] = new OracleParameter("p_fecha_notificacion", OracleDbType.Date);
            
            if (fechaNotificacion.HasValue)
            {
                arrParam[6].Value = fechaNotificacion.Value;
            }
            else
            {
                arrParam[6].Value = DBNull.Value;
            }


            arrParam[7] = new OracleParameter("p_MAIL_ADICIONAL_1", OracleDbType.NVarchar2, 50);
            arrParam[7].Value = mailAdd1;

            arrParam[8] = new OracleParameter("p_MAIL_ADICIONAL_2", OracleDbType.NVarchar2, 50);
            arrParam[8].Value = mailAdd2;

            arrParam[9] = new OracleParameter("P_status", OracleDbType.NVarchar2, 50);
            arrParam[9].Value = StatusCobro;

            arrParam[10] = new OracleParameter("p_id_cartera", OracleDbType.Double);
            arrParam[10].Value = IDCartera;

            arrParam[11] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[11].Direction = ParameterDirection.Output;


            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                return arrParam[11].Value.ToString();
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }
    }
}
