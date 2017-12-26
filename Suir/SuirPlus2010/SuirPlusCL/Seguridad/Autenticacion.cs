using Oracle.ManagedDataAccess.Client;
using System.Data;
using SuirPlus.DataBase;
using System;

namespace SuirPlus.Seguridad
{
	/// <summary>
	/// Clase que maneja la Autenticacion en el Sistema.
	/// </summary>
	public sealed class Autenticacion
	{
              
		public static bool Login(String UserName, String Clave, String ip, String TipoUsuario, String servidor)
		{
			string Resultado;

			AuditarLogin(UserName, ip);

			OracleParameter[] arrParam  = new OracleParameter[6];

			arrParam[0] = new OracleParameter("p_idusuario", OracleDbType.NVarchar2, 35);
			arrParam[0].Value = UserName;

			arrParam[1] = new OracleParameter("p_class", OracleDbType.NVarchar2, 32);
			arrParam[1].Value = Clave;

			arrParam[2] = new OracleParameter("p_ip", OracleDbType.NVarchar2, 16);
			arrParam[2].Value = ip;

			arrParam[3] = new OracleParameter("p_tipousuario", OracleDbType.NVarchar2, 1);
			arrParam[3].Value = TipoUsuario;

            arrParam[4] = new OracleParameter("p_servidor", OracleDbType.NVarchar2, 1);
            arrParam[4].Value = servidor;

			arrParam[5] = new OracleParameter("p_ResultNumber", OracleDbType.NVarchar2, 200);
			arrParam[5].Direction = ParameterDirection.Output;

			try
            {
				OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure,"seg_usuarios_pkg.Login",arrParam);	
				Resultado = arrParam[5].Value.ToString();

				if (Resultado == "0") 
				{
					return true;
				}
				
                //Si es tipo 9 indica que el usuario debe cambiar el class.
                else if(Resultado == "9") 
				{

                    string user = string.Empty;
                    string rnc = string.Empty;

                    //Si el tipo de usuario es representante lo enviamos a cambiar el class pasando el parametro de RNC y Cedula por RNC.
                    if (TipoUsuario == "2")
                {
                switch (UserName.Length)
                    {   
                    case 22:
                        rnc = UserName.Substring(0, 11);
                        user = UserName.Substring(11, 11);
                        System.Web.HttpContext.Current.Response.Redirect("~/sys/segCambioClass.aspx?log=r&RNC=" + rnc + "&Cedula=" + user);
                        break;
                    case 20:
                        rnc = UserName.Substring(0, 9);
                        user = UserName.Substring(9, 11);
                        System.Web.HttpContext.Current.Response.Redirect("~/sys/segCambioClass.aspx?log=r&RNC=" + rnc + "&Cedula=" + user);
                        break;
                    default:
                        System.Web.HttpContext.Current.Response.Redirect("~/sys/segCambioClass.aspx?log=r");
                        break;
                
                    }
                }
                    else
                    {
                        //Enviamos a un usuario normal a cambiar el class pasandole el class.
                        System.Web.HttpContext.Current.Response.Redirect("~/sys/segCambioClass.aspx?user=" + UserName);
                    }
    				}

				else
 				{
                    throw new Exception(Resultado);
					return false;
				}

			}

			catch(Exception ex)
			{
				throw new Exception(ex.ToString());
			}

			return true;

		}
        
		private static void AuditarLogin(String UserName, String ip)
		{

		}
        
		public static string hashPass(string Valor)
		{
			Byte[] data = System.Text.ASCIIEncoding.ASCII.GetBytes(Valor.ToCharArray());
			String str = Convert.ToBase64String(data);

			return str;
		}

		public static string unhashPass(string Valor)
		{

			Byte[] data = Convert.FromBase64String(Valor);
			String str = System.Text.ASCIIEncoding.ASCII.GetString(data);

			return str;
		}


	}
}
