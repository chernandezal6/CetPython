using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using Oracle.ManagedDataAccess.Client;
using SuirPlus;
using SuirPlus.DataBase;
using System.Globalization;


namespace SuirPlus.OficinaVirtual
{
    public class OficinaVirtual
    {
        public static DataTable getCiudadanoValidoOFC(string no_documento, string tipo_documento)
        {

            OracleParameter[] arrParam = new OracleParameter[4];

            arrParam[0] = new OracleParameter("p_documento", OracleDbType.Varchar2);
            arrParam[0].Value = no_documento;

            arrParam[1] = new OracleParameter("p_tipodocumento", OracleDbType.Varchar2);
            arrParam[1].Value = tipo_documento;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;

            arrParam[3] = new OracleParameter("p_io_cursor", OracleDbType.RefCursor);
            arrParam[3].Direction = ParameterDirection.Output;


            string cmdStri = " oficina_virtual_pkg.getciudadanosvalido";
            try
            {
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStri, arrParam);
                string result = arrParam[2].Value.ToString();
                    if (ds.Tables.Count > 0)
                    {
                        return ds.Tables[0];
                    }
                    else
                    {
                        return new DataTable();
                    } 
            }

            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;
            }
        }
        public static String getCiudadanoValidoOFV(string no_documento, string tipo_documento)
        {

            OracleParameter[] arrParam = new OracleParameter[4];

            arrParam[0] = new OracleParameter("p_documento", OracleDbType.Varchar2);
            arrParam[0].Value = no_documento;

            arrParam[1] = new OracleParameter("p_tipodocumento", OracleDbType.Varchar2);
            arrParam[1].Value = tipo_documento;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;

            arrParam[3] = new OracleParameter("p_io_cursor", OracleDbType.RefCursor);
            arrParam[3].Direction = ParameterDirection.Output;


            string cmdStri = " oficina_virtual_pkg.getciudadanosvalido";

            try
            {
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStri, arrParam);
                string result = arrParam[2].Value.ToString();
                return result;

            }

            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;
            }
        }

        public static string CrearUsuarioOFC(String no_documento, string password, string email, string tipo_documento, string valido)
        {

            OracleParameter[] arrParam = new OracleParameter[7];


            arrParam[0] = new OracleParameter("p_documento", OracleDbType.Varchar2);
            arrParam[0].Value = no_documento;

            arrParam[1] = new OracleParameter("p_password", OracleDbType.Varchar2);
            arrParam[1].Value = password;

            arrParam[2] = new OracleParameter("p_email", OracleDbType.Varchar2);
            arrParam[2].Value = email;

            arrParam[3] = new OracleParameter("p_TipoDocumento", OracleDbType.Varchar2);
            arrParam[3].Value = tipo_documento;

            arrParam[4] = new OracleParameter("p_valido", OracleDbType.Varchar2);
            arrParam[4].Value = valido;

            arrParam[5] = new OracleParameter("p_ultusuarioact", OracleDbType.Varchar2);
            arrParam[5].Value = "OPERACIONES";

            arrParam[6] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[6].Direction = ParameterDirection.Output;

            String cmdStr = "oficina_virtual_pkg.Crear_UsuarioOficVirtual ";

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

        //Para uso de la Oficina Virtual
        public static string ConfirmarEmailOFC(string usuario, string email, string link_params, string accion)
        {
            OracleParameter[] arrParam = new OracleParameter[5];

            arrParam[0] = new OracleParameter("p_idusuario", OracleDbType.Varchar2, 300);
            arrParam[0].Value = usuario;
            arrParam[1] = new OracleParameter("p_email", OracleDbType.Varchar2, 300);
            arrParam[1].Value = email;
            arrParam[2] = new OracleParameter("p_link_params", OracleDbType.Varchar2, 4000);
            arrParam[2].Value = link_params;
            arrParam[3] = new OracleParameter("p_accion", OracleDbType.Varchar2, 1);
            arrParam[3].Value = accion;
            arrParam[4] = new OracleParameter("p_resultnumber", OracleDbType.Varchar2, 200);
            arrParam[4].Direction = ParameterDirection.Output;

            String cmdStr = "oficina_virtual_pkg.ConfirmacionEmailOFC";

            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                return arrParam[4].Value.ToString();
            }
            catch (Exception ex)
            {
                return ex.ToString();
            }

        }

        //Valida que exista el usuario tipo 4 de oficina virtual en base a la cedula y password
        public static string isValidarUsuarioOFC(string Id_Usuario, string pass)
        {

            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_usuario", OracleDbType.NVarchar2, 50);
            arrParam[0].Value = Id_Usuario;

            arrParam[1] = new OracleParameter("p_class", OracleDbType.NVarchar2, 50);
            arrParam[1].Value = pass;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;

            string cmdStr = "Oficina_Virtual_pkg.isExisteUsuarioOFC";
            string result = string.Empty;

            try
            {
                OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                result = arrParam[2].Value.ToString();
                return result;

            }
            catch (Exception ex)
            {
                throw ex;
            }

        }

        //Valida que exista el usuario tipo 4 de oficina virtual en base a la cedula.
        public static string isValidarUsuarioOFV(string no_cedula)
        {

            OracleParameter[] arrParam = new OracleParameter[2];

            arrParam[0] = new OracleParameter("p_usuario", OracleDbType.NVarchar2, 50);
            arrParam[0].Value = no_cedula;

            arrParam[1] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[1].Direction = ParameterDirection.Output;

            string cmdStr = "oficina_virtual_pkg.isExisteUsuarioOfV";
            string result = string.Empty;

            try
            {
                OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                result = arrParam[1].Value.ToString();
                if (result == "0")
                {
                    return result;
                }
                else if (result == "1")
                {
                    return result;
                }
                else
                {
                    throw new Exception(arrParam[1].Value.ToString());
                }

            }
            catch (Exception ex)
            {
                throw ex;
            }

        }

        //Valida que exista el usuario tipo 4 de oficina virtual en base al correo electronico.
        public static string isValidarUsuarioEmailOFV(string correo)
        {

            OracleParameter[] arrParam = new OracleParameter[2];

            arrParam[0] = new OracleParameter("p_email", OracleDbType.NVarchar2, 50);
            arrParam[0].Value = correo;

            arrParam[1] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[1].Direction = ParameterDirection.Output;

            string cmdStr = "oficina_virtual_pkg.isExisteUsuarioEmailOfV";
            string result = string.Empty;

            try
            {
                OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                result = arrParam[1].Value.ToString();
                if (result == "0")
                {
                    return result;
                }
                else if (result == "1")
                {
                    return result;
                }
                else
                {
                    throw new Exception(arrParam[1].Value.ToString());
                }

            }
            catch (Exception ex)
            {
                throw ex;
            }

        }

        public static Object CambiarClaveOFV(string cedula)
        {

            OracleParameter[] arrParam = new OracleParameter[2];

            arrParam[0] = new OracleParameter("p_email", OracleDbType.NVarchar2, 50);
            arrParam[0].Value = cedula;

            arrParam[1] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[1].Direction = ParameterDirection.Output;

            string cmdStr = " oficina_virtual_pkg.resetclassofv";
            string result = string.Empty;

            try
            {
                OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                result = arrParam[1].Value.ToString();
                if (result == "0")
                {
                    return result;
                }
                else if (result == "1")
                {
                    return result;
                }
                else
                {
                    throw new Exception(arrParam[1].Value.ToString());
                }

            }
            catch (Exception ex)
            {
                throw new Exception(arrParam[1].Value.ToString());
            }
        }

        //Para poner activo el usuario una vez haya confirmado su cuenta a traves del correo elctronico
        public static String ActualizarEstatusOFV(string cedula)
        {
            String valido = "C";

            OracleParameter[] arrParam = new OracleParameter[4];

            arrParam[0] = new OracleParameter("p_cedula", OracleDbType.Varchar2);
            arrParam[0].Value = cedula;

            arrParam[1] = new OracleParameter("p_valido", OracleDbType.Varchar2);
            arrParam[1].Value = valido;

            arrParam[2] = new OracleParameter("p_email", OracleDbType.Varchar2);
            arrParam[2].Value = "";

            arrParam[3] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[3].Direction = ParameterDirection.Output;

            string cmdStr = " oficina_virtual_pkg.actualizarstatusOFV";
            string result = string.Empty;

            try
            {
                OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                return result = arrParam[3].Value.ToString();
            }
            catch (Exception ex)
            {
                throw new Exception(arrParam[3].Value.ToString());
            }
        }

        public static DataTable getPReguntasRegistro(int id_nss)
        {

            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_idnss", OracleDbType.NVarchar2, 25);
            arrParam[0].Value = id_nss;
            arrParam[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;
            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;

            String cmdStr = "oficina_virtual_pkg.getPreguntasRegistro";

            try
            {
                return DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam).Tables[0];
            }

            catch (Exception ex)
            {
                throw ex;
            }

        }


        public static String CambiarClassUserOFV(string usuario, string oldPassword,string newPassword)
        {
           
            OracleParameter[] arrParam = new OracleParameter[4];

            arrParam[0] = new OracleParameter("p_usuario", OracleDbType.Varchar2);
            arrParam[0].Value = usuario;

            arrParam[1] = new OracleParameter("p_oldClass", OracleDbType.Varchar2);
            arrParam[1].Value = oldPassword;

            arrParam[2] = new OracleParameter("p_newClass", OracleDbType.Varchar2);
            arrParam[2].Value = newPassword;

            arrParam[3] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[3].Direction = ParameterDirection.Output;

            string cmdStr = " oficina_virtual_pkg.CambiarClassOFV";
            string result = string.Empty;

            try
            {
                OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                return result = arrParam[3].Value.ToString();
            }
            catch (Exception ex)
            {
                throw new Exception(arrParam[3].Value.ToString());
            }
        }


        public static String CambiarEmailOFV(string usuario, string oldEmail, string newEmail)
        {

            OracleParameter[] arrParam = new OracleParameter[4];

            arrParam[0] = new OracleParameter("p_usuario", OracleDbType.Varchar2);
            arrParam[0].Value = usuario;

            arrParam[1] = new OracleParameter("p_oldClass", OracleDbType.Varchar2);
            arrParam[1].Value = oldEmail;

            arrParam[2] = new OracleParameter("p_newClass", OracleDbType.Varchar2);
            arrParam[2].Value = newEmail;

            arrParam[3] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[3].Direction = ParameterDirection.Output;

            string cmdStr = " oficina_virtual_pkg.ResetEmailOFV";
            string result = string.Empty;

            try
            {
                OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                return result = arrParam[3].Value.ToString();
            }
            catch (Exception ex)
            {
                throw new Exception(arrParam[3].Value.ToString());
            }
        }

    }
}
