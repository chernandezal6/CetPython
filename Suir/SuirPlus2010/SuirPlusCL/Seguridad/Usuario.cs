using System.Security.Principal;
using Oracle.ManagedDataAccess.Client;
using SuirPlus.DataBase;
using System.Data;
using SuirPlus;
using System;

namespace SuirPlus.Seguridad
{
    /// <summary>
    /// Usuario del Sistema
    /// </summary>
    [Serializable]
    public class Usuario : FrameWork.Objetos, IIdentity
    {
        #region " propiedades privadas "

        private string myIDUsuario;
        internal string myIDTipoUsuario;
        private string myNombres;
        private string myApellidos;
        private int myCantidadIntentos;
        private string myStatus;
        private string myEmail;
        private string myPassword;

        private bool myisAuthenticated;
        private string myAuthenticationType;
        private string[] myRoles;
        private string[] myPermisos;
        private DateTime myFechaLogin;

        private string myDepartamento;
        private string myComentario;
        private string myIDEntidadRecaudadora;

        //add fausto
        private string ip;
        private string cambiarClass;

        #endregion

        #region " propiedades publicas "

        /// <summary>
        /// El Nombre del Usuario o UserName
        /// </summary>
        public string UserName
        {
            get { return this.myIDUsuario; }
        }

        /// <summary>
        /// Tipo de Usuario (Representante, etc.)
        /// </summary>
        public string IDTipoUsuario
        {
            get { return this.myIDTipoUsuario; }
        }
        public string TipoUsuario
        {
            get
            {
                if (this.myIDTipoUsuario == "1")
                { return "Usuario"; }
                else if (this.myIDTipoUsuario == "2")
                { return "Representante"; }
                else { return "Error en el tipo de Usuario"; }
            }
        }
        /// <summary>
        /// Los nombres del usuario
        /// </summary>
        public string Nombres
        {
            get { return this.myNombres; }
            set { this.myNombres = value; }
        }
        /// <summary>
        /// Los apellidos del usuario
        /// </summary>
        public string Apellidos
        {
            get { return this.myApellidos; }
            set { this.myApellidos = value; }
        }

        /// <summary>
        /// El Nombre Completo del Usuario
        /// </summary>
        public string NombreCompleto
        {
            get { return this.myNombres + " " + this.myApellidos; }
        }

        /// <summary>
        /// La cantidad de intentos fallidos que lleva el usuario.
        /// </summary>
        public int CantidadIntentosFallidos
        {
            get { return this.myCantidadIntentos; }
        }

        /// <summary>
        /// Status del Usuario
        /// </summary>
        public string Status
        {
            get { return this.myStatus; }
            set { this.myStatus = value; }
        }

        public string Email
        {
            get { return this.myEmail; }
            set { this.myEmail = value; }
        }

        public string Password
        {
            set { this.myPassword = value; }
        }

        public string[] Roles
        {
            get { return this.myRoles; }
            set { this.myRoles = value; }
        }
        public string[] Permisos
        {
            get { return this.myPermisos; }
            set { this.myPermisos = value; }
        }
        public bool IsAuthenticated
        {
            get
            {
                return this.myisAuthenticated;
            }
        }

        public string AuthenticationType
        {
            get
            {
                return this.myAuthenticationType;
            }
        }

        public string Name
        {
            get
            {
                return this.myIDUsuario;
            }
        }

        public DateTime FechaLogin
        {
            get { return this.myFechaLogin; }
        }


        public string Departamento
        {
            get { return this.myDepartamento; }
            set
            {
                this.myDepartamento = value;
            }
        }

        public string Comentario
        {
            get { return myComentario; }
            set { this.myComentario = value; }
        }


        public string IDEntidadRecaudadora
        {
            get
            {
                return this.myIDEntidadRecaudadora;
            }
            set { this.myIDEntidadRecaudadora = value; }
        }
        public string IP
        {
            get
            {
                return ip;
            }
        }
        public string Cambiar_Class
        {
            get
            {
                return cambiarClass;
            }
        }

        #endregion

        public Usuario(string UserName)
        {

            if (UserName.Length == 0)
            {
                this.myisAuthenticated = false;
                return;
            }


            this.myisAuthenticated = true;
            this.myIDUsuario = UserName.ToUpper();

            /// Definir el AuthenticationType
            this.myAuthenticationType = "CustomAuthentication";

            // Tipo de Usuario : Usuario
            this.myIDTipoUsuario = "1";

            // Fecha de Entrada el Sistema
            this.myFechaLogin = DateTime.Now;

            /// CargarDatos
            this.CargarDatos();
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="IDPermiso"></param>
        /// <returns></returns>
        public static DataTable getUsuariosNoTienenPermiso(int IDPermiso)
        {
            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_idpermiso", OracleDbType.Int32);
            arrParam[0].Value = IDPermiso;

            arrParam[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;

            String cmdStr = "seg_usuarios_pkg.Usuarios_sin_Permiso";

            try
            {
                return DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam).Tables[0];
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public static DataTable getUsuariosNoTienenRole(int IDRole)
        {
            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_IDRole", OracleDbType.Decimal);
            arrParam[0].Value = IDRole;

            arrParam[1] = new OracleParameter("p_IOCursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_ResultNumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;

            String cmdStr = "seg_usuarios_pkg.Usuarios_sin_Role";

            try
            {
                return DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam).Tables[0];
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        private static DataTable getUsuario(string UserName)
        {
            return getUsuarios(UserName, "", "");
        }

        public static DataTable getUsuarios(string UserName, string Nombres, string Apellidos)
        {
            return getUsuarios(UserName, Nombres, Apellidos, "", "");
        }

        public static DataTable getUsuarios(string UserName, string Nombres, string Apellidos, string Role, string Entidad)
        {
            OracleParameter[] arrParam = new OracleParameter[6];

            arrParam[0] = new OracleParameter("p_IDUsuario", OracleDbType.NVarchar2, 35);
            arrParam[0].Value = Utilitarios.Utils.verificarNulo(UserName);

            arrParam[1] = new OracleParameter("p_Nombres", OracleDbType.NVarchar2, 40);
            arrParam[1].Value = Utilitarios.Utils.verificarNulo(Nombres);

            arrParam[2] = new OracleParameter("p_Apellidos", OracleDbType.NVarchar2, 40);
            arrParam[2].Value = Utilitarios.Utils.verificarNulo(Apellidos);

            arrParam[3] = new OracleParameter("p_role", OracleDbType.NVarchar2, 10);
            arrParam[3].Value = Utilitarios.Utils.verificarNulo(Role);

            arrParam[4] = new OracleParameter("p_idEntidad", OracleDbType.NVarchar2, 10);
            arrParam[4].Value = Utilitarios.Utils.verificarNulo(Entidad);

            arrParam[5] = new OracleParameter("p_IOCursor", OracleDbType.RefCursor);
            arrParam[5].Direction = ParameterDirection.Output;


            String cmdStr = "seg_usuarios_pkg.Get_Usuarios";

            try
            {
                return DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam).Tables[0];
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public static string inactivarUsuario(string IdUsuario, string UsuarioActualiza)
        {
            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_idusuario", OracleDbType.NVarchar2, 35);
            arrParam[0].Value = IdUsuario;

            arrParam[1] = new OracleParameter("p_ultusuarioact", OracleDbType.NVarchar2, 35);
            arrParam[1].Value = UsuarioActualiza;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;

            try
            {
                OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, "Seg_Usuarios_Pkg.inactivar_usuariorep", arrParam);
                return arrParam[2].Value.ToString();
            }

            catch (Exception ex)
            {
                return ex.ToString();
            }
        }
        /// <summary>
        /// Crea un nuevo Usurio
        /// </summary>
        /// <param name="UserName">Usuario</param>
        /// <param name="Password"></param>
        /// <param name="Nombres"></param>
        /// <param name="Apellidos"></param>
        /// <param name="Email"></param>
        /// <param name="Estatus"></param>
        /// <param name="UsuarioResponsable"></param>
        /// <returns>devuelve si o no</returns>
        ///         

        public static string nuevoUsuario(string UserName, string Password, string Nombres, string Apellidos, string Email, string Estatus, string UsuarioResponsable, string departamento, int entidad, string comentario)
        {
            OracleParameter[] orParam = new OracleParameter[11];

            orParam[0] = new OracleParameter("p_IDUsuario", OracleDbType.NVarchar2, 22);
            orParam[0].Value = Utilitarios.Utils.verificarNulo(UserName);

            orParam[1] = new OracleParameter("p_Password", OracleDbType.NVarchar2, 32);
            orParam[1].Value = Password;

            orParam[2] = new OracleParameter("p_NombreUsuario", OracleDbType.NVarchar2, 40);
            orParam[2].Value = Nombres;

            orParam[3] = new OracleParameter("p_ApellidosUsuario", OracleDbType.NVarchar2, 40);
            orParam[3].Value = Apellidos;

            orParam[4] = new OracleParameter("p_Email", OracleDbType.NVarchar2, 50);
            orParam[4].Value = Email;

            orParam[5] = new OracleParameter("p_Estatus", OracleDbType.NVarchar2, 20);
            orParam[5].Value = Estatus;

            orParam[6] = new OracleParameter("p_UltUsuarioAct", OracleDbType.NVarchar2, 20);
            orParam[6].Value = UsuarioResponsable;

            orParam[7] = new OracleParameter("p_departamento", OracleDbType.NVarchar2, 50);
            orParam[7].Value = departamento;

            orParam[8] = new OracleParameter("p_eRecaudadora", OracleDbType.Int32);
            orParam[8].Value = entidad;

            orParam[9] = new OracleParameter("p_comentario", OracleDbType.NVarchar2, 100);
            orParam[9].Value = comentario;

            orParam[10] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            orParam[10].Direction = ParameterDirection.Output;

            string valorRetorno = "0";

            try
            {
                OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, "seg_usuarios_pkg.Crear_Usuario", orParam);
                valorRetorno = orParam[10].Value.ToString();

                if (valorRetorno != "0")
                {
                    throw new Exception(valorRetorno);
                }
                return orParam[10].Value.ToString();
            }

            catch (Exception ex)
            {
                return ex.Message;
            }
        }

        public static string CrearUsuarioExterno(string UserName, string tipoUsuario, string Password, string Nombres, string Apellidos, string Email, string Estatus, string UsuarioResponsable)
        {
            OracleParameter[] orParam = new OracleParameter[9];

            orParam[0] = new OracleParameter("p_IDUsuario", OracleDbType.NVarchar2, 22);
            orParam[0].Value = Utilitarios.Utils.verificarNulo(UserName);

            orParam[1] = new OracleParameter("p_tipo_documento", OracleDbType.NVarchar2, 2);
            orParam[1].Value = tipoUsuario;

            orParam[2] = new OracleParameter("p_Password", OracleDbType.NVarchar2, 32);
            orParam[2].Value = Password;

            orParam[3] = new OracleParameter("p_NombreUsuario", OracleDbType.NVarchar2, 40);
            orParam[3].Value = Nombres;
            orParam[3].Direction = ParameterDirection.InputOutput;

            orParam[4] = new OracleParameter("p_ApellidosUsuario", OracleDbType.NVarchar2, 40);
            orParam[4].Value = Apellidos;
            orParam[4].Direction = ParameterDirection.InputOutput;


            orParam[5] = new OracleParameter("p_Email", OracleDbType.NVarchar2, 50);
            orParam[5].Value = Email;

            orParam[6] = new OracleParameter("p_Estatus", OracleDbType.NVarchar2, 20);
            orParam[6].Value = Estatus;

            orParam[7] = new OracleParameter("p_UltUsuarioAct", OracleDbType.NVarchar2, 20);
            orParam[7].Value = UsuarioResponsable;

            orParam[8] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            orParam[8].Direction = ParameterDirection.Output;

            string valorRetorno = "0";

            try
            {
                OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, "seg_usuarios_pkg.Crear_UsuarioExterno", orParam);
                valorRetorno = orParam[8].Value.ToString();

                if (valorRetorno != "0")
                {
                    throw new Exception(SuirPlus.Utilitarios.Utils.sacarMensajeDeError(valorRetorno));
                }
                return orParam[8].Value.ToString();
            }

            catch (Exception ex)
            {
                return ex.Message;
            }
        }

        public DataTable getRoles()
        {
            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_id_usuario", OracleDbType.NVarchar2, 22);
            arrParam[0].Value = this.myIDUsuario;

            arrParam[1] = new OracleParameter("p_io_cursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_ResultNumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;

            String cmdStr = "seg_roles_pkg.get_roles_usuario";

            try
            {
                return DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam).Tables[0];
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public DataTable getPermisos()
        {
            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_id_usuario", OracleDbType.NVarchar2, 22);
            arrParam[0].Value = this.myIDUsuario;

            arrParam[1] = new OracleParameter("p_io_cursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_ResultNumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;

            String cmdStr = "seg_permisos_pkg.permisos_usuario";

            try
            {
                return DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam).Tables[0];
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public DataTable getRolesActivos()
        {
            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_IDUsuario", OracleDbType.NVarchar2, 22);
            arrParam[0].Value = this.myIDUsuario;

            arrParam[1] = new OracleParameter("p_IOCursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_ResultNumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;

            String cmdStr = "seg_usuarios_pkg.Roles_Activos";

            try
            {
                return DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam).Tables[0];
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public DataTable getPermisosActivos()
        {
            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_IDUsuario", OracleDbType.NVarchar2, 22);
            arrParam[0].Value = this.myIDUsuario;

            arrParam[1] = new OracleParameter("p_IOCursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_ResultNumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;

            String cmdStr = "seg_usuarios_pkg.Permisos_Activos";

            try
            {
                return DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam).Tables[0];
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public string AgregarPermiso(int IDPermiso, string UsuarioResponsable)
        {
            return Seg.AsociarPermisoRoleAlUsuario(this.myIDUsuario, -1, IDPermiso, UsuarioResponsable);
        }

        public string AgregarRole(int IDRole, string UsuarioResponsable)
        {
            return Seg.AsociarPermisoRoleAlUsuario(this.myIDUsuario, IDRole, -1, UsuarioResponsable);
        }

        public string RemoverPermiso(int IDPermiso, string UsuarioResponsable)
        {
            return Seg.QuitarPermisoRoleAlUsuario(this.myIDUsuario, -1, IDPermiso, UsuarioResponsable);
        }

        public string RemoverRole(int IDRole, string UsuarioResponsable)
        {
            return Seg.QuitarPermisoRoleAlUsuario(this.myIDUsuario, IDRole, -1, UsuarioResponsable);
        }

        /// <summary>
        /// Verifica si el usuario tiene un rol asignado. - NO UTILIZAR 
        /// </summary>
        /// <param name="role">El ID del Rol</param>
        /// <returns>Retorna True o False</returns>
        public bool IsInRole(string role)
        {
            try
            {
                Array.Sort(this.myRoles);
                return Array.BinarySearch(this.myRoles, role) >= 0 ? true : false;
            }
            catch (Exception ex)
            {
                SuirPlus.Exepciones.Log.LogToDB(ex.ToString());
                return false;
            }
        }

        /// <summary>
        /// Verifica si el usuario tiene todos los roles asignados
        /// </summary>
        /// <param name="roles">Un arreglo que representa todos los roles que el usuario debe tener asignado</param>
        /// <returns>Retorna True o False</returns>
        public bool IsInAllRoles(params string[] roles)
        {
            try
            {
                Array.Sort(this.myRoles);
                foreach (string searchrole in roles)
                {
                    if (Array.BinarySearch(this.myRoles, searchrole) < 0)
                        return false;
                }
                return true;
            }
            catch (Exception ex)
            {
                SuirPlus.Exepciones.Log.LogToDB(ex.ToString());
                return false;
            }
        }

        /// <summary>
        /// Verifica si el usuario tiene cualquiera de los roles asignados
        /// </summary>
        /// <param name="roles">Un arreglo que representa los roles.</param>
        /// <returns>Retorna True o False</returns>
        public bool IsInAnyRole(params string[] roles)
        {
            try
            {
                Array.Sort(this.myRoles);
                foreach (string searchrole in roles)
                {
                    if (Array.BinarySearch(this.myRoles, searchrole) >= 0)
                        return true;
                }
                return false;
            }
            catch (Exception ex)
            {
                SuirPlus.Exepciones.Log.LogToDB(ex.ToString());
                return false;
            }
        }

        /// <summary>
        /// Verifica si el usuario tiene un permiso asignado
        /// </summary>
        /// <param name="permiso">El ID del Permiso</param>
        /// <returns>Retorna True o False</returns>
        public bool IsInPermiso(string permiso)
        {
            try
            {
                Array.Sort(this.myPermisos);
                return Array.BinarySearch(this.myPermisos, permiso) >= 0 ? true : false;
            }
            catch (Exception ex)
            {
                SuirPlus.Exepciones.Log.LogToDB(ex.ToString());
                return false;
            }
        }

        /// <summary>
        /// Verifica si el usuario tiene todos los permisos asignados
        /// </summary>
        /// <param name="permisos">Un arreglo que representa todos los permisos que el usuario debe tener asignado</param>
        /// <returns>Retorna True o False</returns>
        public bool IsInAllPermiso(params string[] permisos)
        {
            try
            {
                Array.Sort(this.myPermisos);
                foreach (string searchperm in permisos)
                {
                    if (Array.BinarySearch(this.myPermisos, searchperm) < 0)
                        return false;
                }
                return true;
            }
            catch (Exception ex)
            {
                SuirPlus.Exepciones.Log.LogToDB(ex.ToString());
                return false;
            }
        }

        /// <summary>
        /// Verifica si el usuario tiene cualquiera de los permisos asignados
        /// </summary>
        /// <param name="permisos">Un arreglo que representa los roles</param>
        /// <returns>Retorna True o False</returns>
        public bool IsInAnyPermiso(params string[] permisos)
        {
            try
            {
                Array.Sort(this.myPermisos);
                foreach (string searchperm in permisos)
                {
                    if (Array.BinarySearch(this.myPermisos, searchperm) >= 0)
                        return true;
                }
                return false;
            }
            catch (Exception ex)
            {
                SuirPlus.Exepciones.Log.LogToDB(ex.ToString());
                return false;
            }
        }

        /// <summary>
        /// OJO: Metodo utilizado exclusivamente para construir el menu.
        /// </summary>
        /// <returns>Retorna un DataTable</returns>
        public DataTable MenuGetSecciones()
        {
            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_IDUsuario", OracleDbType.NVarchar2, 22);
            arrParam[0].Value = this.myIDUsuario;

            arrParam[1] = new OracleParameter("p_IOCursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_ResultNumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;

            String cmdStr = "seg_usuarios_pkg.Menu_Get_Secciones";

            try
            {
                return DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam).Tables[0];
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        /// <summary>
        /// OJO: Metodo utilizado exclusivamente para construir el menu.
        /// </summary>
        /// <param name="IDSeccion">El ID de la seccion.</param>
        /// <returns>Retorna un DataTable</returns>
        public DataTable MenuGetPermisosPorSeccion(int IDSeccion)
        {
            OracleParameter[] arrParam = new OracleParameter[4];

            arrParam[0] = new OracleParameter("p_IDUsuario", OracleDbType.NVarchar2, 22);
            arrParam[0].Value = this.myIDUsuario;

            arrParam[1] = new OracleParameter("p_IDSeccion", OracleDbType.NVarchar2, 22);
            arrParam[1].Value = IDSeccion;

            arrParam[2] = new OracleParameter("p_IOCursor", OracleDbType.RefCursor);
            arrParam[2].Direction = ParameterDirection.Output;

            arrParam[3] = new OracleParameter("p_ResultNumber", OracleDbType.NVarchar2, 200);
            arrParam[3].Direction = ParameterDirection.Output;

            String cmdStr = "seg_usuarios_pkg.Menu_Permisos_Por_Seccion";

            try
            {
                return DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam).Tables[0];
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        /// <summary>
        /// Metodo estatico para Cambiarle el Class a un Usuario
        /// </summary>
        /// <param name="Usuario">ID del Usuario</param>
        /// <param name="ClassNuevo">El Class nuevo</param>
        /// <param name="ClassViejo">El Class viejo</param>
        /// <returns>Retorna un 0 si lo hace todo bien</returns>
        public static String CambiarClass(string Usuario, string ClassNuevo, string ClassViejo)
        {
            OracleParameter[] arrParam = new OracleParameter[4];

            arrParam[0] = new OracleParameter("p_idusuario", OracleDbType.NVarchar2, 35);
            arrParam[0].Value = Usuario;

            arrParam[1] = new OracleParameter("p_classNew", OracleDbType.NVarchar2, 32);
            arrParam[1].Value = ClassNuevo;

            arrParam[2] = new OracleParameter("p_classOld", OracleDbType.NVarchar2, 16);
            arrParam[2].Value = ClassViejo;

            arrParam[3] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[3].Direction = ParameterDirection.Output;

            try
            {
                OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, "seg_usuarios_pkg.CambioClass", arrParam);
                return arrParam[3].Value.ToString();
            }

            catch (Exception ex)
            {
                throw new Exception(ex.ToString());
            }
        }

        /// <summary>
        /// Reseta el CLASS de cualquier Usuario
        /// </summary>
        /// <param name="Usuario">El userName</param>
        /// <returns>El Nuevo CLASS</returns>
        public static String ResetearClass(string Usuario)
        {
            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_idusuario", OracleDbType.NVarchar2, 35);
            arrParam[0].Value = Usuario;

            arrParam[1] = new OracleParameter("p_classNew", OracleDbType.NVarchar2, 32);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;

            try
            {
                OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, "seg_usuarios_pkg.ReseteoClass", arrParam);
                return arrParam[2].Value.ToString();
            }

            catch (Exception ex)
            {
                throw new Exception(ex.ToString());

            }
        }

        public override void CargarDatos()
        {
            DataTable dt;

            dt = getUsuario(this.myIDUsuario);

            try
            {
                this.myApellidos = dt.Rows[0]["apellidos"].ToString();
                this.myCantidadIntentos = Convert.ToInt32(dt.Rows[0]["cantidad_intentos"].ToString());
                this.myEmail = dt.Rows[0]["email"].ToString();
                this.myNombres = dt.Rows[0]["nombre_usuario"].ToString();
                this.myStatus = dt.Rows[0]["status"].ToString();
                this.myIDEntidadRecaudadora = dt.Rows[0]["id_entidad_recaudadora"].ToString();
                //add fausto
                this.ip = dt.Rows[0]["ip"].ToString();
                this.cambiarClass = dt.Rows[0]["cambiar_class"].ToString();
                this.myComentario = dt.Rows[0]["comentario"].ToString();
                this.myDepartamento = dt.Rows[0]["departamento"].ToString();
                //this.utlFechaActualizacion = Convert.ToDateTime(dt.Rows[0]["ult_fecha_act"]);
                this.myUltimaFechaActualizacion = Convert.ToDateTime(dt.Rows[0]["ult_fecha_act"]);
                //this.ultUsuarioActualizo = dt.Rows[0]["ult_usuario_act"].ToString();
                this.myUltimoUsuarioActualizo = dt.Rows[0]["ult_usuario_act"].ToString();

                if (this.myIDTipoUsuario == "") { this.myIDTipoUsuario = dt.Rows[0]["id_tipo_usuario"].ToString(); }
            }
            catch (Exception ex)
            {
                throw new Exception("Este usuario no existe en la BD. " + this.myIDUsuario + " | " + ex.ToString());
            }

            dt.Dispose();
        }

        public override String GuardarCambios(string UsuarioResponsable)
        {
            OracleParameter[] orParam = new OracleParameter[11];

            orParam[0] = new OracleParameter("p_id_usuario", OracleDbType.NVarchar2, 35);
            orParam[0].Value = Utilitarios.Utils.verificarNulo(this.myIDUsuario);

            orParam[1] = new OracleParameter("p_password", OracleDbType.NVarchar2, 32);
            orParam[1].Value = this.myPassword;

            orParam[2] = new OracleParameter("p_nombre_usuario", OracleDbType.NVarchar2, 40);
            orParam[2].Value = this.myNombres;

            orParam[3] = new OracleParameter("p_apellidos_usuario", OracleDbType.NVarchar2, 40);
            orParam[3].Value = this.myApellidos;

            orParam[4] = new OracleParameter("p_email", OracleDbType.NVarchar2, 50);
            orParam[4].Value = this.myEmail;

            orParam[5] = new OracleParameter("p_estatus", OracleDbType.NVarchar2, 20);
            orParam[5].Value = this.myStatus;

            orParam[6] = new OracleParameter("p_ult_usuario_act", OracleDbType.NVarchar2, 20);
            orParam[6].Value = UsuarioResponsable;

            orParam[7] = new OracleParameter("p_departamento", OracleDbType.NVarchar2, 150);
            orParam[7].Value = this.myDepartamento;

            orParam[8] = new OracleParameter("p_eRecaudadora", OracleDbType.Int32);
            orParam[8].Value = Convert.ToInt32(this.myIDEntidadRecaudadora);

            orParam[9] = new OracleParameter("p_comentario", OracleDbType.NVarchar2, 150);
            orParam[9].Value = this.myComentario;

            orParam[10] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            orParam[10].Direction = ParameterDirection.Output;

            try
            {
                OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, "seg_usuarios_pkg.Editar_Usuario", orParam);
                return orParam[10].Value.ToString();
            }

            catch (Exception ex)
            {
                return ex.ToString();
            }
            
        }

        public static string RecuperarClass(string usuario, string email, string link_params, string accion)
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

            String cmdStr = " seg_usuarios_pkg.recuperarclass";

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

        public static string DesbloquearUsuario(string usuario, string status, string accion)
        {
            OracleParameter[] arrParam = new OracleParameter[4];

            arrParam[0] = new OracleParameter("p_idusuario", OracleDbType.Varchar2, 300);
            arrParam[0].Value = usuario;
            arrParam[1] = new OracleParameter("p_email", OracleDbType.Varchar2, 300);
            arrParam[1].Value = status;          
            arrParam[2] = new OracleParameter("p_accion", OracleDbType.Varchar2, 1);
            arrParam[2].Value = accion;
            arrParam[3] = new OracleParameter("p_resultnumber", OracleDbType.Varchar2, 200);
            arrParam[3].Direction = ParameterDirection.Output;

            String cmdStr = " seg_usuarios_pkg.DesbloquearUsuario";

            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                return arrParam[3].Value.ToString();
            }
            catch (Exception ex)
            {
                return ex.ToString();
            }

        }

        public static string ActualizarUsuario(string IdUsuario, string status, string link)
        {
            OracleParameter[] arrParam = new OracleParameter[4];

            arrParam[0] = new OracleParameter("p_usuario", OracleDbType.NVarchar2, 35);
            arrParam[0].Value = IdUsuario;

            arrParam[1] = new OracleParameter("p_status", OracleDbType.Char, 1);
            arrParam[1].Value = status;

            arrParam[2] = new OracleParameter("p_link_params", OracleDbType.NVarchar2, 200);
            arrParam[2].Value = link;

            arrParam[3] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[3].Direction = ParameterDirection.Output;

            try
            {
                OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, "Seg_Usuarios_Pkg.Actualizar_Usuario", arrParam);
                return arrParam[3].Value.ToString();
            }

            catch (Exception ex)
            {
                return ex.ToString();
            }
        }
        //********************Bloque de codigo dedicado al nuevo modulo de seguridad*************************//
        //by charlie pena

        public static DataTable listarUsuarios(string Criterio, Int32 pageNum, Int32 pageSize)
        {

            OracleParameter[] arrParam;

            //Definimos nuestro arreglo de parametros.
            arrParam = new OracleParameter[5];

            arrParam[0] = new OracleParameter("p_criterio", OracleDbType.Varchar2);
            arrParam[0].Value = Criterio;

            arrParam[1] = new OracleParameter("p_pagenum", OracleDbType.Int32);
            arrParam[1].Value = pageNum;

            arrParam[2] = new OracleParameter("p_pagesize", OracleDbType.Int32);
            arrParam[2].Value = pageSize;

            arrParam[3] = new OracleParameter("p_io_cursor", OracleDbType.RefCursor);
            arrParam[3].Direction = ParameterDirection.Output;

            arrParam[4] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[4].Direction = ParameterDirection.Output;

            String cmdStr = "seg_seguridad_pkg.listarUsuarios";

            DataTable dt = new DataTable();

            try
            {
                //Ejecuamos el commando.
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);



                if (arrParam[4].Value.ToString() != "0")
                {
                    throw new Exception(arrParam[4].Value.ToString());
                }

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



    }
}
