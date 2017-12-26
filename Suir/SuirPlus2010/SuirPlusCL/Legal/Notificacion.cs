using System.Data;
using System;
using System.Collections.Generic;
using System.Text;
using Oracle.ManagedDataAccess.Client;

namespace SuirPlus.Legal
{
    public class Notificacion : FrameWork.Objetos
    {

        public static string CrearNuevaNotificacion(int RegistroPatronal, int TipoNotificacion, Byte[] Documento, string Comentario)
        {
            OracleParameter[] arrParam = new OracleParameter[5];

            arrParam[0] = new OracleParameter("p_idRegPat", OracleDbType.Int32);
            arrParam[0].Value = RegistroPatronal;
            arrParam[1] = new OracleParameter("p_idtipoNotificacion", OracleDbType.Int32);
            arrParam[1].Value = TipoNotificacion;
            arrParam[2] = new OracleParameter("p_documento", OracleDbType.Blob);
            arrParam[2].Value = Documento;
            arrParam[3] = new OracleParameter("p_comentario", OracleDbType.Varchar2, 200);
            arrParam[3].Value = Comentario;
            arrParam[4] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[4].Direction = ParameterDirection.Output;

            String cmdStr = "LGL_LEGAL_PKG.CrearNuevaNotificacion";

            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                return arrParam[4].Value.ToString();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public static DataTable getTiposNotificaciones()
        {
            OracleParameter[] arrParam = new OracleParameter[2];

            arrParam[0] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[0].Direction = ParameterDirection.Output;

            arrParam[1] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[1].Direction = ParameterDirection.Output;

            String cmdStr = "LGL_LEGAL_PKG.getTiposNotificaciones";

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

        public override string GuardarCambios(string UsuarioResponsable)
        {
            throw new Exception("The method or operation is not implemented.");
        }
                
        public override void CargarDatos()
        {
            throw new Exception("The method or operation is not implemented.");
        }


        public static Byte[] getImagenNotificacion(int idNotificacion)
        {
            byte[] img = null;
            OracleDataReader odr = null;
            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_idnotificacion", OracleDbType.Int32);
            arrParam[0].Value = idNotificacion;

            arrParam[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;

            String cmdStr = "lgl_legal_pkg.getimagennotificacion";

            try
            {
                odr = DataBase.OracleHelper.ExecuteDataReader(CommandType.StoredProcedure, cmdStr, arrParam);
                if (odr.HasRows)
                {
                    odr.Read();
                    if (!odr.IsDBNull(0))
                    {
                        img = new byte[(odr.GetBytes(0, 0, null, 0, int.MaxValue))];
                        odr.GetBytes(0, 0, img, 0, img.Length);
                    }

                }

                odr.Close();

            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;

            }

            return img;

        }


    
    }

}
