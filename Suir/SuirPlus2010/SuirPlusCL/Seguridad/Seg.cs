using System.Security.Principal;
using Oracle.ManagedDataAccess.Client;
using SuirPlus.DataBase;
using System.Data;
using System;

namespace SuirPlus.Seguridad
{
	/// <summary>
	/// Clase estatica que maneja algunos metodos del modulo de seguridad que no son propios de ningun objeto.
	/// </summary>
	internal sealed class Seg
	{
		/// <summary>
		/// Metodo para DesAsociar un Role y un Permiso
		/// </summary>
		/// <param name="IDPermiso">El ID del Permiso</param>
		/// <param name="IDRole">El ID del Role</param>
		/// <param name="UsuarioResponsable">El Usuario que esta haciendo la asociación.</param>
		/// <returns>En caso de que todo fue exitoso retorna un "0", en caso contrario devuelve el mensaje de error.</returns>
		internal static string DesasociarRolePermiso(int IDPermiso, int IDRole, string UsuarioResponsable)
		{
			OracleParameter[] arrParam  = new OracleParameter[4];

			arrParam[0] = new OracleParameter("p_id_permiso", OracleDbType.Decimal);
			arrParam[0].Value = IDPermiso;

			arrParam[1] = new OracleParameter("p_id_role", OracleDbType.Decimal);
			arrParam[1].Value = IDRole;

			arrParam[2] = new OracleParameter("p_ult_usuario_act", OracleDbType.NVarchar2, 22);
			arrParam[2].Value = UsuarioResponsable;

			arrParam[3] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
			arrParam[3].Direction = ParameterDirection.Output;

			try
			{
				OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure,"seg_permisos_pkg.deasignar_permiso",arrParam);	
				return arrParam[3].Value.ToString();
			}

			catch(Exception ex)
			{
				return ex.ToString();
			}
		}
		/// <summary>
		/// Metodo para Asociar un Role y un Permiso
		/// </summary>
		/// <param name="IDPermiso">El ID del Permiso</param>
		/// <param name="IDRole">El ID del Role</param>
		/// <param name="UsuarioResponsable">El Usuario que esta haciendo la asociación.</param>
		/// <returns>En caso de que todo fue exitoso retorna un "0", en caso contrario devuelve el mensaje de error.</returns>
		internal static string AsociarRolePermiso(int IDPermiso, int IDRole, string UsuarioResponsable)
		{
			OracleParameter[] arrParam  = new OracleParameter[4];

			arrParam[0] = new OracleParameter("p_id_permiso", OracleDbType.Decimal);
			arrParam[0].Value = IDPermiso;

			arrParam[1] = new OracleParameter("p_id_role", OracleDbType.Decimal);
			arrParam[1].Value = IDRole;

			arrParam[2] = new OracleParameter("p_ult_usuario_act", OracleDbType.NVarchar2, 35);
			arrParam[2].Value = UsuarioResponsable;

			arrParam[3] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
			arrParam[3].Direction = ParameterDirection.Output;

			try
			{
				OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure,"seg_roles_pkg.otorgar_permiso",arrParam);	
				return arrParam[3].Value.ToString();
			}

			catch(Exception ex)
			{
				return ex.ToString();
			}		
		}

		/// <summary>
		/// Metodo para Quitarle un permiso o un role a un usuario. Debe recibir solo uno de los dos parametros. 
		/// </summary>
		/// <param name="UserName">El Nombre de Usuario</param>
		/// <param name="IDRole">El ID del Role</param>
		/// <param name="IDPermiso">El ID del Permiso</param>
		/// <param name="UsuarioResponsable">El Usuario que esta quitando el permiso.</param>
		/// <returns>En caso de que todo fue exitoso retorna un "0", en caso contrario devuelve el mensaje de error.</returns>
		internal static string QuitarPermisoRoleAlUsuario(string UserName, int IDRole, int IDPermiso, string UsuarioResponsable)
		{
			OracleParameter[] arrParam  = new OracleParameter[5];

			arrParam[0] = new OracleParameter("p_id_permiso", OracleDbType.Decimal);
			arrParam[0].Value = Utilitarios.Utils.verificarNulo(IDPermiso);

			arrParam[1] = new OracleParameter("p_id_role", OracleDbType.Decimal);
			arrParam[1].Value = Utilitarios.Utils.verificarNulo(IDRole);

			arrParam[2] = new OracleParameter("p_id_usuario", OracleDbType.NVarchar2, 22);
			arrParam[2].Value = UserName;

			arrParam[3] = new OracleParameter("p_ult_usuario_act", OracleDbType.NVarchar2, 22);
			arrParam[3].Value = UsuarioResponsable;

			arrParam[4] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
			arrParam[4].Direction = ParameterDirection.Output;

			try
			{
				OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure,"seg_usuarios_pkg.Eliminar_Perm_Usuario",arrParam);	
				return arrParam[4].Value.ToString();
			}

			catch(Exception ex)
			{
				return ex.ToString();
			}
		}
		/// <summary>
		/// Metodo para darle un Permiso o un Role a un Usuario. Debe recibir solo uno de los dos parametros.
		/// </summary>
		/// <param name="UserName">El Nombre de Usuario</param>
		/// <param name="IDRole">El ID del Role</param>
		/// <param name="IDPermiso">El ID del Permiso</param>
		/// <param name="UsuarioResponsable">El Usuario que esta quitando el permiso.</param>
		/// <returns>En caso de que todo fue exitoso retorna un "0", en caso contrario devuelve el mensaje de error.</returns>
		internal static string AsociarPermisoRoleAlUsuario(string UserName, int IDRole, int IDPermiso, string UsuarioResponsable)
		{
			OracleParameter[] arrParam  = new OracleParameter[5];

			arrParam[0] = new OracleParameter("p_id_permiso", OracleDbType.Decimal);
			arrParam[0].Value = Utilitarios.Utils.verificarNulo(IDPermiso);

			arrParam[1] = new OracleParameter("p_id_role", OracleDbType.Decimal);
			arrParam[1].Value = Utilitarios.Utils.verificarNulo(IDRole);

			arrParam[2] = new OracleParameter("p_id_usuario", OracleDbType.NVarchar2, 22);
			arrParam[2].Value = UserName;

			arrParam[3] = new OracleParameter("p_ult_usuario_act", OracleDbType.NVarchar2, 22);
			arrParam[3].Value = UsuarioResponsable;

			arrParam[4] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
			arrParam[4].Direction = ParameterDirection.Output;

			try
			{
				OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure,"seg_usuarios_pkg.Asignar_Perm_Usuario",arrParam);	
				return arrParam[4].Value.ToString();
			}

			catch(Exception ex)
			{
				return ex.ToString();
			}
		}
	}


}
