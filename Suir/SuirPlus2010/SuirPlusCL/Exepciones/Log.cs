using System;
using System.Collections.Generic;
using System.Text;
using SuirPlus.DataBase;
using Oracle.ManagedDataAccess.Client;
using System.Diagnostics;

namespace SuirPlus.Exepciones
{
    public class Log
    {
        /// <summary>
        /// Metodo para grabar un error en el EventViewer del servidor donde se ejecuta la aplicación. 
        /// Normalmente se debe utilizar el metodo LogToDB en vez de este, pero si NO hay conexion a la
        /// base de datos debe grabarse en el EventViewer utilizando este metodo.
        /// </summary>
        /// <param name="MensajeDeError">El Mensaje de error que se va a grabar</param>
        public static void LogToEventViewer(string MensajeDeError)
        {
            /*LogToDB(MensajeDeError);
            if (!(EventLog.SourceExists("SuirPlus", ".")))
            {
                EventLog.CreateEventSource("SuirPlus", "SuirPlus");
            }

            EventLog eLog = new System.Diagnostics.EventLog("SuirPlus", ".");

            eLog.Source = "SuirPlus";
            eLog.WriteEntry(MensajeDeError, System.Diagnostics.EventLogEntryType.Error);
            eLog.Close();
            */
        }

        /// <summary>
        /// Metodo para grabar un error en la base de datos. Esto se utiliza en el metodo 
        /// Application_Error del Global.asax. No es necesario invocarlo desde otro sitio.
        /// </summary>
        /// <param name="MensajeDeError">El Mensaje de error que se va a grabar</param>
        public static void LogToDB(string MensajeDeError)
        {

            LogToDB(MensajeDeError, "");

        }
        /// <summary>
        /// SobreCarga del Metodo para grabar un error en la base de datos. Esto se utiliza en el metodo 
        /// Application_Error del Global.asax. No es necesario invocarlo desde otro sitio.
        /// Con este metodo se graba tambien el usuario al cual le ocurrio el error.
        /// </summary>
        /// <param name="MensajeDeError">El Mensaje de error que se va a grabar</param>
        /// <param name="Usuario">El usuario al cual le ocurrio el error.</param>
        public static void LogToDB(string MensajeDeError, string Usuario)
        {
            OracleParameter[] orParam = new OracleParameter[2];

            orParam[0] = new OracleParameter("p_mensaje", OracleDbType.NVarchar2, 4000);
            orParam[0].Value = MensajeDeError;

            orParam[1] = new OracleParameter("p_usuario", OracleDbType.NVarchar2, 60);
            orParam[1].Value = Usuario;

            try
            {
                OracleHelper.ExecuteNonQuery(System.Data.CommandType.StoredProcedure, "seg_usuarios_pkg.LogError", orParam);
                LogToEventViewer(MensajeDeError);
            }

            catch (Exception ex)
            {
                LogToEventViewer(MensajeDeError);
                LogToEventViewer(ex.ToString());
            }
        }
    }
}
