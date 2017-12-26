using Oracle.ManagedDataAccess.Client;
using System.Data;
using System;
using SuirPlus.DataBase;

namespace SuirPlus.Operaciones
{
    public class RegistroLogAuditoria : FrameWork.Objetos
    {


        /// <summary>
        /// Devuelve un listado de todos los registros de auditoria que se hayan grabado para ese empleador.
        /// </summary>
        /// <param name="RegistroPatronal">El Registro patronal</param>
        /// <returns>Devuelve un listado de todos los registros de auditoria que se hayan grabado para ese empleador.</returns>
        public static DataTable getRegistros(string RegistroPatronal, Int16 pageNum, Int16 pageSize)
        {
            OracleParameter[] arrParam = new OracleParameter[5];

            arrParam[0] = new OracleParameter("p_idRegPat", OracleDbType.NVarchar2);
            arrParam[0].Value = RegistroPatronal;
            arrParam[1] = new OracleParameter("p_pagenum", OracleDbType.Int16);
            arrParam[1].Value = pageNum;
            arrParam[2] = new OracleParameter("p_pagesize", OracleDbType.Int16);
            arrParam[2].Value = pageSize;
            arrParam[3] = new OracleParameter("p_ioCursor", OracleDbType.RefCursor);
            arrParam[3].Direction = ParameterDirection.Output;
            arrParam[4] = new OracleParameter("p_resultNumber", OracleDbType.NVarchar2,200);
            arrParam[4].Direction = ParameterDirection.Output;

            try
            {
                return DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, "seg_log_pkg.getLog", arrParam).Tables[0];
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        /// <summary>
        /// Metodo para crear un registro de auditoria sobre una acción tomada en el SuirPlus
        /// </summary>
        /// <param name="RegistroPatronal">El registro patronal de la empresa</param>
        /// <param name="UsuarioRepresentante">Es opcional, en el caso de que aplique el Usuario del Representante sobre el cual se tomo la accion</param>
        /// <param name="TipoRegistro">Esta es la acción que se va a tomar</param>
        /// <param name="IP">El IP de la pc desde donde se tomo la acción</param>
        /// <param name="NombrePC">El nombre de la pc desde donde se tomo la acción</param>
        /// <param name="comentario">Comentario sobre ...</param>
        /// <param name="servidor">IP del WebService que se utilizó</param>
        public static void CrearRegistro(int RegistroPatronal, string UsuarioRepresentante, string UsuarioCae, 
            int TipoRegistro, string IP, string NombrePC, string comentario, string servidor)
        {
            OracleParameter[] arrParam = new OracleParameter[9];

            arrParam[0] = new OracleParameter("p_idRegPat", OracleDbType.Int32);
            arrParam[0].Value = RegistroPatronal;
            arrParam[1] = new OracleParameter("p_idTipo", OracleDbType.Int32);
            arrParam[1].Value = TipoRegistro;
            arrParam[2] = new OracleParameter("p_idPC", OracleDbType.Varchar2, 16);
            arrParam[2].Value = IP;
            arrParam[3] = new OracleParameter("p_nombrePC", OracleDbType.Varchar2, 80);
            arrParam[3].Value = NombrePC;
            arrParam[4] = new OracleParameter("p_usuario_rep", OracleDbType.Varchar2, 35);
            arrParam[4].Value = UsuarioRepresentante;
            arrParam[5] = new OracleParameter("p_usuario_cae", OracleDbType.Varchar2, 35);
            arrParam[5].Value = UsuarioCae;
            arrParam[6] = new OracleParameter("p_comentario", OracleDbType.Varchar2, 1000);
            arrParam[6].Value = comentario;
            arrParam[7] = new OracleParameter("p_servidor", OracleDbType.NVarchar2, 16);
            arrParam[7].Value = servidor;
            arrParam[8] = new OracleParameter("p_resultNumber", OracleDbType.Varchar2, 1000);
            arrParam[8].Direction = ParameterDirection.Output;

            try
            {
                OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, "seg_log_pkg.crearLog", arrParam);               
            }

            catch (Exception ex)
            {
                throw ex;
            }        
        }

        public override void CargarDatos()
        {
            // por ahora no hay necesidad de hacer este metodo

        }
        public override String GuardarCambios(string UsuarioResponsable)
        {
            // por ahora no hay necesidad de hacer este metodo
            return "";
        }
 
    }
}
