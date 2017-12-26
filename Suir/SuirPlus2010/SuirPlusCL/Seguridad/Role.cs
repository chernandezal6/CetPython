using Oracle.ManagedDataAccess.Client;
using System.Data;
using System;
using SuirPlus.DataBase;

namespace SuirPlus.Seguridad
{
	/// <summary>
	/// Clase para manejar los Roles que agrupan los permisos para asignarselos a los usuarios.
	/// </summary>
	public class Role: FrameWork.Objetos
	{
		private int myID_Role;
		private string myDescripcion;
		private string myStatus;

		public int ID_Role
		{
			get {return this.myID_Role;}
		}
		public string Descripcion
		{
			set {this.myDescripcion = value;}
			get {return this.myDescripcion;}
		}
		public string Status
		{
			set{this.myStatus = value;}
			get{return this.myStatus;}
		}
		
		
		public Role(int ID_Role)
		{

			this.myID_Role = ID_Role;
			this.CargarDatos();

		}

		
		public static DataTable getRolesNoTienePermiso(int IDPermiso)
		{
			OracleParameter[] arrParam  = new OracleParameter[3];

			arrParam[0] = new OracleParameter("p_id_permiso", OracleDbType.Decimal);
			arrParam[0].Value = IDPermiso;

			arrParam[1] = new OracleParameter("p_io_cursor", OracleDbType.RefCursor);
			arrParam[1].Direction = ParameterDirection.Output;

			arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
			arrParam[2].Direction = ParameterDirection.Output;

			String cmdStr= "seg_roles_pkg.get_roles_sin_per";

			try
			{
				return DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam).Tables[0];
			}
			catch(Exception ex)
			{
				throw ex;
			}
		}
		public static DataTable getRolesNoTieneUsuario(string UserName)
		{
			OracleParameter[] arrParam  = new OracleParameter[3];

			arrParam[0] = new OracleParameter("p_id_usuario", OracleDbType.NVarchar2, 22);
			arrParam[0].Value = UserName;

			arrParam[1] = new OracleParameter("p_io_cursor", OracleDbType.RefCursor);
			arrParam[1].Direction = ParameterDirection.Output;

			arrParam[2] = new OracleParameter("p_ResultNumber", OracleDbType.NVarchar2, 200);
			arrParam[2].Direction = ParameterDirection.Output;

			String cmdStr= "seg_roles_pkg.get_roles_sin_usr";

			try
			{
				return DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam).Tables[0];
			}
			catch(Exception ex)
			{
				throw ex;
			}
		}
		public static DataTable getRoles(int IDRole)
		{
			OracleParameter[] arrParam  = new OracleParameter[3];

			arrParam[0] = new OracleParameter("p_id_role", OracleDbType.Decimal);
			arrParam[0].Value = Utilitarios.Utils.verificarNulo(IDRole);

			arrParam[1] = new OracleParameter("p_io_cursor", OracleDbType.RefCursor);
			arrParam[1].Direction = ParameterDirection.Output;

			arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 150);
			arrParam[2].Direction = ParameterDirection.Output;

			String cmdStr= "seg_roles_pkg.get_roles";

			try
			{
				return DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam).Tables[0];
			}
			catch(Exception ex)
			{
				throw ex;
			}
		}

		public static string nuevoRole(string Descripcion, string UsuarioResponsable)
		{
			OracleParameter[] orParam = new OracleParameter[3];
			
			orParam[0] = new OracleParameter("p_role_des", OracleDbType.NVarchar2,40);
			orParam[0].Value = Descripcion;

			orParam[1] = new OracleParameter("p_ult_usuario_act",OracleDbType.NVarchar2,20);
			orParam[1].Value = UsuarioResponsable;

			orParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
			orParam[2].Direction = ParameterDirection.Output;

			try
			{
				OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure,"seg_roles_pkg.role_crear",orParam);
				return orParam[2].Value.ToString();
			}

			catch(Exception ex)
			{
				return ex.ToString();
			}

		}

        public static string InsertarRolCertificacion(int IdRol, string IdCertificacion, string Usuario)
        {
            OracleParameter[] orParam = new OracleParameter[4];

            orParam[0] = new OracleParameter("p_id_role", OracleDbType.Int32, 5);
            orParam[0].Value = IdRol;

            orParam[1] = new OracleParameter("p_id_tipo_certificacion", OracleDbType.NVarchar2, 2);
            orParam[1].Value = IdCertificacion;

            orParam[2] = new OracleParameter("p_ult_usuario_act", OracleDbType.NVarchar2, 40);
            orParam[2].Value = Usuario;

            orParam[3] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            orParam[3].Direction = ParameterDirection.Output;

            try
            {
                OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, "seg_roles_pkg.InsertarRolCertificacion", orParam);
                return orParam[3].Value.ToString();
            }

            catch (Exception ex)
            {
                return ex.ToString();
            }

        }

        public static string borrarRole(int IDRole)
		{
			OracleParameter[] arrParam  = new OracleParameter[2];

			arrParam[0] = new OracleParameter("p_id_role", OracleDbType.Decimal);
			arrParam[0].Value = IDRole;

			arrParam[1] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
			arrParam[1].Direction = ParameterDirection.Output;

			try
			{
				OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure,"seg_roles_pkg.role_borrar",arrParam);	
				return arrParam[1].Value.ToString();
			}

			catch(Exception ex)
			{
				return ex.ToString();
			}

		}


		public DataTable getUsuariosTienenRole()
		{
		
			OracleParameter[] arrParam  = new OracleParameter[3];

			arrParam[0] = new OracleParameter("p_id_role", OracleDbType.Decimal);
			arrParam[0].Value = this.myID_Role;

			arrParam[1] = new OracleParameter("p_io_cursor", OracleDbType.RefCursor);
			arrParam[1].Direction = ParameterDirection.Output;

			arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
			arrParam[2].Direction = ParameterDirection.Output;

			String cmdStr= "seg_usuarios_pkg.Usuarios_Role";

			try
			{
				return DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam).Tables[0];
			}
			catch(Exception ex)
			{
				throw ex;
			}
		}
		
		public DataTable getPermisosTienenRole()
		{
			
			OracleParameter[] arrParam  = new OracleParameter[3];

			arrParam[0] = new OracleParameter("p_id_role", OracleDbType.Decimal);
			arrParam[0].Value = this.myID_Role;

			arrParam[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
			arrParam[1].Direction = ParameterDirection.Output;

			arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
			arrParam[2].Direction = ParameterDirection.Output;

			String cmdStr= "seg_permisos_pkg.permisos_role";

			try
			{
				return DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam).Tables[0];
			}
			catch(Exception ex)
			{
				throw ex;
			}
		}


		public string AgregarUsuario(string UserName, string UsuarioResponsable)
		{
			return Seg.AsociarPermisoRoleAlUsuario(UserName, this.myID_Role, -1, UsuarioResponsable);
		}
		public string RemoverUsuario(string UserName, string UsuarioResponsable)
		{
			return Seg.QuitarPermisoRoleAlUsuario(UserName, this.myID_Role, -1, UsuarioResponsable);
		}
		
		
		public string AgregarPermiso(int IDPermiso, string UsuarioResponsable)
		{
			return Seg.AsociarRolePermiso(IDPermiso, this.myID_Role, UsuarioResponsable);
		}
		public string RemoverPermiso(int IDPermiso, string UsuarioResponsable)
		{
			return Seg.DesasociarRolePermiso(IDPermiso, this.myID_Role, UsuarioResponsable);
		}

		
		public override void CargarDatos()
		{
			DataTable dt;

			dt = getRoles(this.myID_Role);

			this.myDescripcion = dt.Rows[0]["Roles_Des"].ToString();
			this.myStatus = dt.Rows[0]["status"].ToString();

			dt.Dispose();
		}

		public override String GuardarCambios(string UsuarioResponsable)
		{

			OracleParameter[] orParam = new OracleParameter[5];

			orParam[0] = new OracleParameter("p_id_role", OracleDbType.Decimal);
			orParam[0].Value = this.myID_Role;
			
			orParam[1] = new OracleParameter("p_roles_des", OracleDbType.NVarchar2,40);
			orParam[1].Value = this.myDescripcion;

			orParam[2] = new OracleParameter("p_estatus", OracleDbType.NVarchar2,1);
			orParam[2].Value = this.myStatus;

			orParam[3] = new OracleParameter("p_ult_usuario_act",OracleDbType.NVarchar2,35);
			orParam[3].Value = UsuarioResponsable;

			orParam[4] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
			orParam[4].Direction = ParameterDirection.Output;

			try
			{
				OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure,"seg_roles_pkg.role_editar",orParam);	
				return orParam[4].Value.ToString();
			}

			catch(Exception ex)
			{
				return ex.ToString();
			}

		}


	}
}
