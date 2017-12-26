using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using SuirPlus.DataBase;
using Oracle.ManagedDataAccess.Client;
using System.Data;
namespace SuirPlus.XMLBC
{
    public class ArchivosBC
    {
        /// <summary>
        /// Metodo para obtener todos los archivos recibidos
        /// </summary>
        /// <param name="tipoarchivo">Tipo de Archivo "Concentracion", "Liquidacion", "Todos"</param>
        /// <param name="desde">Fecha desde</param>
        /// <param name="hasta">Fecha hasta</param>
        /// <param name="pageNum">numero de paginas</param>
        /// <param name="pageSize">tamaño de la pagina</param>
        /// <returns></returns>
        public static DataTable getArchivosRecibidos(string tipoarchivo, string desde, string hasta, Int16 pageNum, Int16 pageSize)
        {

            OracleParameter[] parameters = new OracleParameter[7];

            parameters[0] = new OracleParameter("p_tipo_archivo",  OracleDbType.Varchar2);
            parameters[0].Value = tipoarchivo;

            parameters[1] = new OracleParameter("p_fecha_ini", OracleDbType.Date);
            if (desde.Equals(string.Empty))
            {
                parameters[1].Value = DBNull.Value;
            }
            else
            {
                parameters[1].Value = Convert.ToDateTime(desde);
            }

            parameters[2] = new OracleParameter("p_fecha_fin", OracleDbType.Date);
            if (hasta.Equals(string.Empty))
            {
                parameters[2].Value = DBNull.Value;
            }
            else
            {
                parameters[2].Value = Convert.ToDateTime(hasta);
            }
            
            parameters[3] = new OracleParameter("p_pagenum", OracleDbType.Int16);
            parameters[3].Value = pageNum;

            parameters[4] = new OracleParameter("p_pagesize", OracleDbType.Int16);
            parameters[4].Value = pageSize;

            parameters[5] = new OracleParameter("p_resultnumber", OracleDbType.Varchar2, 200);
            parameters[5].Direction = ParameterDirection.Output;

            parameters[6] = new OracleParameter("p_io_cursor", OracleDbType.RefCursor);
            parameters[6].Direction = ParameterDirection.Output;


            string cmdStr = "bc_manejoarchivoxml_pkg.getArchivos";
            DataTable dt;
            try
            {
                dt = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, parameters).Tables[0];

                if (parameters[5].Value.ToString()!= "0" )
                {
                    throw new Exception(parameters[5].Value.ToString()); 
 
                }
              
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message); 
            }
            return dt;
        }
    }
}
