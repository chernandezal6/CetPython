using Oracle.ManagedDataAccess.Client;
using System.Data;
using System;
using SuirPlus.DataBase;

namespace SuirPlus.SolicitudesEnLinea
{
    public class Reclamaciones
    {

        public static string crearSolicitud(int IdTipoSolicitud, string Rnc,string Cedula, string Representante, string Operador, string Comentarios,string IdCertificacion)
        {
            OracleParameter[] orParam = new OracleParameter[9];

            
            orParam[0] = new OracleParameter("p_ID_SOLICITUD", OracleDbType.Decimal);
            orParam[0].Direction = ParameterDirection.Output;

            orParam[1] = new OracleParameter("p_ID_TIPO_SOLICITUD", OracleDbType.Decimal);
            orParam[1].Value = IdTipoSolicitud;

            orParam[2] = new OracleParameter("p_RNC", OracleDbType.NVarchar2, 11);
            orParam[2].Value = Rnc;

            orParam[3] = new OracleParameter("p_CEDULA", OracleDbType.NVarchar2, 11);
            orParam[3].Value = Cedula;

            orParam[4] = new OracleParameter("p_representante", OracleDbType.NVarchar2, 20);
            orParam[4].Value = Representante;

            orParam[5] = new OracleParameter("p_operador", OracleDbType.NVarchar2, 35);
            orParam[5].Value = Operador;

            orParam[6] = new OracleParameter("p_comentarios", OracleDbType.NVarchar2, 4000);
            orParam[6].Value = Comentarios;

            orParam[7] = new OracleParameter("p_ID_TIPO_CERTIFICACION", OracleDbType.NVarchar2, 2);
            orParam[7].Value = IdCertificacion;

            orParam[8] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            orParam[8].Direction = ParameterDirection.Output;

            try
            {
                OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, "SER_SOLICITUDES_PKG.CrearSolicitude", orParam);
                return orParam[0].Value.ToString() + "|" + orParam[8].Value.ToString();
            }

            catch (Exception ex)
            {
                throw ex;
            }
        }

        public static string crearDetSolicitud(int IdSolicitud, string RncCedula, string IdReferencia)
        {


            OracleParameter[] orParam = new OracleParameter[4];

            orParam[0] = new OracleParameter("P_ID_SOLICITUD", OracleDbType.Decimal);
            orParam[0].Value = IdSolicitud;

            orParam[1] = new OracleParameter("P_RNC_O_CEDULA", OracleDbType.NVarchar2, 11);
            orParam[1].Value = RncCedula;

            orParam[2] = new OracleParameter("P_ID_REFERENCIA", OracleDbType.NVarchar2, 16);
            orParam[2].Value = IdReferencia;

            orParam[3] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            orParam[3].Direction = ParameterDirection.Output;

            try
            {
                OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, "SER_SOLICITUDES_PKG.CrearDetSolicitudes", orParam);
                return orParam[3].Value.ToString();
            }

            catch (Exception ex)
            {
                throw ex;
            }
        }

        public static DataTable getTiposSolicitudes()
        {

            OracleParameter[] arrParam = new OracleParameter[2];

            arrParam[0] = new OracleParameter("p_IOCursor", OracleDbType.RefCursor);
            arrParam[0].Direction = ParameterDirection.Output;

            arrParam[1] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[1].Direction = ParameterDirection.Output;

            String cmdStr = "sel_solicitudes_pkg.getTipoSolicitudes";//"SER_SOLICITUDES_PKG.getTipoSolicitudes";

            try
            {
                return DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam).Tables[0];
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }


        public static DataTable getSolicitud(int IDSolicitud)
        {

            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_IdSolicitud", OracleDbType.Double);
            arrParam[0].Value = IDSolicitud;

            arrParam[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;

            String cmdStr = "SER_SOLICITUDES_PKG.GetSolicitud";

            try
            {
                return DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam).Tables[0];
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }


        public static DataTable getDetalleSolicitud(int IDSolicitud)
        {

            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_ID_SOLICITUD", OracleDbType.Double);
            arrParam[0].Value = IDSolicitud;

            arrParam[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;

            String cmdStr = "SER_SOLICITUDES_PKG.GetDetalleSolicitud";

            try
            {
                return DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam).Tables[0];
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }

	

    }
}
