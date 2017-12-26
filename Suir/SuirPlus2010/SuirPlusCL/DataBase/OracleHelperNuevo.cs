using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using Oracle.ManagedDataAccess.Client;
namespace SuirPlus.DataBase
{
    public sealed class OracleHelper
    {
        /// <summary>
        /// Metodo para extraer el ConnectionString a la base de datos desde el Web.Config
        /// </summary>
        /// <returns>Devuelve un String con el ConnectionString a la Base de Datos</returns>
        internal static String getConnString()
        {
            //string connectionString = System.Configuration.ConfigurationSettings.AppSettings["oConnSuirPlus"];
            //string connectionString = System.Configuration.ConfigurationSettings.AppSettings["oConnMD"];
            string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["OracleDbContext"].ConnectionString;

            //byte[] data = Convert.FromBase64String(connectionString);
            //return System.Text.ASCIIEncoding.ASCII.GetString(data);
            return connectionString;
        }

        /// <summary>
        /// Metodo para llenar un dataset desde la base de datos.
        /// </summary>
        /// <param name="commandType">Tipo de Objeto, generalmente es un StoredProcedure</param>
        /// <param name="commandText">Nombre del Objeto</param>
        /// <param name="commandParameters">Parametros que recibe</param>
        /// <returns>Un DataSet con la información solicitada</returns>
        public static DataSet ExecuteDataset(CommandType commandType, string commandText, params OracleParameter[] commandParameters)
        {
            
            using (OracleConnection oConn = new OracleConnection(getConnString()))
            {

                using (OracleDataAdapter oDA = new OracleDataAdapter())
                {
                    oDA.SelectCommand = new OracleCommand();
                    oDA.SelectCommand.CommandType = commandType;
                    oDA.SelectCommand.CommandText = commandText;
                    oDA.SelectCommand.Connection = oConn;
                    oDA.SelectCommand.Parameters.AddRange(commandParameters);

                    DataSet ds = new DataSet();

                    oDA.SelectCommand.Connection.Open();
                    oDA.Fill(ds);
                    oDA.SelectCommand.Connection.Close();

                    return ds;
 
                }
 
            }

            //OracleConnection oConn = new OracleConnection(getConnString());
            //oConn.Open();

            //OracleDataAdapter oDA = new OracleDataAdapter();
            //OracleCommand oComm = new OracleCommand();

            //oComm.CommandType = commandType;
            //oComm.CommandText = commandText;
            //oComm.Connection = oConn;
            //oComm.Parameters.AddRange(commandParameters);

            //oDA.SelectCommand = oComm;

            //DataSet ds = new DataSet();

            //oDA.Fill(ds);

            //oConn.Close();

            //return ds;            
        }
        
        /// <summary>
        /// Ejecuta una sentencia u objeto en la base de datos
        /// </summary>
        /// <param name="commandType">Tipo de Objeto, generalmente es un StoredProcedure</param>
        /// <param name="commandText">Nombre del Objeto</param>
        /// <param name="commandParameters">Parametros que recibe</param>
        /// <returns>La cantidad de filas que fueron modificadas por esta operacion.</returns>
        public static int ExecuteNonQuery(CommandType commandType, string commandText, params OracleParameter[] commandParameters)
        {

           ///Environment.SetEnvironmentVariable("ORA_DEBUG_JDWP", "host=172.16.4.42;port=49153", EnvironmentVariableTarget.Process);

            using (OracleConnection oConn = new OracleConnection(getConnString()))
            {
                using (OracleCommand oCommand = new OracleCommand())
                {
                    oConn.Open();
                    oCommand.Connection = oConn;
                    oCommand.CommandType = commandType;
                    oCommand.CommandText = commandText;
                    oCommand.Parameters.AddRange(commandParameters);

                    int Resultado = oCommand.ExecuteNonQuery();

                    oCommand.Connection.Close();

                    return Resultado;
                }
            }
            //OracleConnection oConn = new OracleConnection(getConnString());
            //oConn.Open();

            //OracleCommand oCommand = new OracleCommand();

            //oCommand.Connection = oConn;
            //oCommand.CommandType = commandType;
            //oCommand.CommandText = commandText;
            //oCommand.Parameters.AddRange(commandParameters);

            //int Resultado = oCommand.ExecuteNonQuery();
            //oConn.Close();

            /////Environment.SetEnvironmentVariable("ORA_DEBUG_JDWP", "", EnvironmentVariableTarget.Process);

            //return Resultado;
        }

        /// <summary>
        /// Ejecuta un procedimiento de la base de datos. Hay que llamar el metodo .Close del Data Reader
        /// cuando se haya terminado de utilizarlo para poder cerrar la conexion a la base de datos.
        /// </summary>
        /// <param name="commandType">Tipo de Objeto, generalmente es un StoredProcedure</param>
        /// <param name="commandText">Nombre del Objeto</param>
        /// <param name="commandParameters">Parametros que recibe</param>
        /// <returns>Devuelve un objeto del tipo OracleDataReader</returns>
        public static OracleDataReader ExecuteDataReader(CommandType commandType, string commandText, params OracleParameter[] commandParameters)
        {
            OracleConnection oConn = new OracleConnection(getConnString());
            oConn.Open();

            OracleCommand oCommand = new OracleCommand();

            oCommand.Connection = oConn;
            oCommand.CommandType = commandType;
            oCommand.CommandText = commandText;
            oCommand.Parameters.AddRange(commandParameters);

            OracleDataReader oRead = oCommand.ExecuteReader(CommandBehavior.CloseConnection);

            return oRead;
        }
    }
}
