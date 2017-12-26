using System.Data;
using System;
using Oracle.ManagedDataAccess.Client;
using SuirPlus.DataBase;

namespace SuirPlus.Seguridad
{
	/// <summary>
	/// Summary description for Autorizacion.
	/// </summary>
	public sealed class Autorizacion
	{
		private Usuario myUsuario;

		public Autorizacion(String UserName)
		{

			this.myUsuario = new Usuario(UserName);

		}

		public string getRoles()
		{
			System.Text.StringBuilder sb = new System.Text.StringBuilder();

			DataTable dt = this.myUsuario.getRolesActivos();
			foreach(DataRow dtRow in dt.Rows)
			{
				sb.Append(dtRow["ID_ROLE"].ToString());
				sb.Append("|");
			}

			sb.Append("EndStringBuilder");
			sb.Replace("|EndStringBuilder", "");

			dt.Dispose();

			return sb.ToString();
		}

		public string getPermisos()
		{
			System.Text.StringBuilder sb = new System.Text.StringBuilder();

			DataTable dt = this.myUsuario.getPermisosActivos();
			foreach(DataRow dtRow in dt.Rows)
			{
				sb.Append(dtRow["ID_PERMISO"].ToString());
				sb.Append("|");
			}

			sb.Append("EndStringBuilder");
			sb.Replace("|EndStringBuilder", "");

			dt.Dispose();

			return sb.ToString();
		}

        public static DataSet getMenuItems(String UserName)
        {
            DataSet ds = new DataSet("MenuItems");

            OracleParameter[] arrParam = new OracleParameter[4];

            arrParam[0] = new OracleParameter("p_id_usuario", OracleDbType.NVarchar2, 35);
            arrParam[0].Value = Utilitarios.Utils.verificarNulo(UserName);

            arrParam[1] = new OracleParameter("p_cursor1", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_cursor2", OracleDbType.RefCursor);
            arrParam[2].Direction = ParameterDirection.Output;

            arrParam[3] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[3].Direction = ParameterDirection.Output;

            String cmdStr = "seg_usuarios_pkg.getMenuItems";

            try
            {
                ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);
                return ds;
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }

        public static Boolean isUsuarioAutorizado(string UserName, string URL)
        {
            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_id_usuario", OracleDbType.NVarchar2, 35);
            arrParam[0].Value = UserName;

            arrParam[1] = new OracleParameter("p_url", OracleDbType.NVarchar2, 200);
            arrParam[1].Value = URL;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;

            try
            {
                OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, "seg_usuarios_pkg.isUsuarioAutorizado", arrParam);
                String res = arrParam[2].Value.ToString();

                if (res != "0")
                {
                    return true;
                }
                else
                {
                    return false;
                }

            }

            catch (Exception ex)
            {
                throw new Exception(ex.ToString());
            }
        }

        public static Boolean isInPermiso(string UserName, string Permiso)
        {
            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_id_usuario", OracleDbType.NVarchar2, 35);
            arrParam[0].Value = UserName;

            arrParam[1] = new OracleParameter("p_permiso", OracleDbType.Int32);
            arrParam[1].Value = Permiso;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;

            try
            {
                OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, "seg_usuarios_pkg.isInPermiso", arrParam);
                String res = arrParam[2].Value.ToString();

                if (res != "0")
                {
                    return true;
                }
                else
                {
                    return false;
                }

            }

            catch (Exception ex)
            {
                throw new Exception(ex.ToString());
            }
        }

        public static Boolean isInRol(string UserName, string Role)
        {
            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_id_usuario", OracleDbType.NVarchar2, 35);
            arrParam[0].Value = UserName;

            arrParam[1] = new OracleParameter("p_id_role", OracleDbType.Int32);
            arrParam[1].Value = Role;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;
                
            try
            {
                OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, "seg_usuarios_pkg.isInRole", arrParam);
                String res = arrParam[2].Value.ToString();

                if (res != "0")
                {
                    return true;
                }
                else
                {
                    return false;
                }

            }

            catch (Exception ex)
            {
                throw new Exception(ex.ToString());
            }
        }
	}
}
