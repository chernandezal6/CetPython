//using Oracle.ManagedDataAccess.Client;
using Oracle.ManagedDataAccess.Client;
using System.Data;
using System;
using SuirPlus.DataBase;

namespace SuirPlus.Seguridad
{
    /// <summary>
    /// Clase para manejar los permisos que se le otorgan a los Roles y los Usuarios.
    /// </summary>
    public class Permiso : FrameWork.Objetos
    {
        private int myID_Permiso;
        private string myDescripcion;
        private string myURL;
        private string mySeccion;
        private string myOrdenMenu;
        private string myStatus;
        private string myTipo;
        private string myMarcaCuota;

        public int ID_Permiso
        {
            get { return this.myID_Permiso; }
        }
        public string Descripcion
        {
            set { this.myDescripcion = value; }
            get { return this.myDescripcion; }
        }
        public string URL
        {
            set { this.myURL = value; }
            get { return this.myURL; }
        }
        public string Seccion
        {
            set { this.mySeccion = value; }
            get { return this.mySeccion; }
        }
        public string OrdenMenu
        {
            set { this.myOrdenMenu = value; }
            get { return this.myOrdenMenu; }
        }
        public string Status
        {
            set { this.myStatus = value; }
            get { return this.myStatus; }
        }
        public string Tipo
        {
            set { this.myTipo = value; }
            get { return this.myTipo; }
        }

        public string MarcaCuota
        {
            set { this.myMarcaCuota = value; }
            get { return this.myMarcaCuota; }
        }

        public Permiso(int ID_Permiso)
        {
            this.myID_Permiso = ID_Permiso;
            this.CargarDatos();
        }


        public static DataTable getPermisosNoTieneRole(int IDRole)
        {
            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_IDRole", OracleDbType.Decimal);
            arrParam[0].Value = IDRole;

            arrParam[1] = new OracleParameter("p_IOCursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 100);
            arrParam[2].Direction = ParameterDirection.Output;

            String cmdStr = "seg_permisos_pkg.get_permisos_sin_role";

            try
            {
                return DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam).Tables[0];
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public static DataTable getPermisosNoTieneUsuario(string UserName)
        {
            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_IdUsuario", OracleDbType.NVarchar2, 22);
            arrParam[0].Value = UserName;

            arrParam[1] = new OracleParameter("p_IOCursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_ResultNumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;

            String cmdStr = "seg_permisos_pkg.get_permisos_sin_usuario";

            try
            {
                return DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam).Tables[0];
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public static DataTable getPermisos(int IDPermiso)
        {
            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_id_permiso", OracleDbType.Decimal);
            arrParam[0].Value = Utilitarios.Utils.verificarNulo(IDPermiso);

            arrParam[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 150);
            arrParam[2].Direction = ParameterDirection.Output;

            String cmdStr = "seg_permisos_pkg.get_permisos";

            try
            {
                return DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam).Tables[0];
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public static string nuevoPermiso(string Descripcion, int IDSeccion, string OrdenMenu, string URL, string UsuarioResponsable, string TipoPermiso, string MarcaCuota_p)
        {
            OracleParameter[] orParam = new OracleParameter[8];

            orParam[0] = new OracleParameter("p_permiso_des", OracleDbType.Varchar2, 40);
            orParam[0].Value = Descripcion;

            orParam[1] = new OracleParameter("p_id_seccion", OracleDbType.Int32);
            orParam[1].Value = IDSeccion;

            if (OrdenMenu != "")
            {
                orParam[2] = new OracleParameter("p_orden_menu", OracleDbType.Int32);
                orParam[2].Value = Convert.ToInt32(OrdenMenu);
            }
            else
            {
                orParam[2] = new OracleParameter("p_orden_menu", OracleDbType.Int32);
                orParam[2].Value = 0;
            }


            orParam[3] = new OracleParameter("p_direccion_electronica", OracleDbType.Varchar2, 200);
            orParam[3].Value = URL;

            orParam[4] = new OracleParameter("p_tipo_permiso", OracleDbType.Varchar2, 1);
            orParam[4].Value = TipoPermiso;

            orParam[5] = new OracleParameter("p_marca_cuota", OracleDbType.Varchar2, 1);
            orParam[5].Value = MarcaCuota_p;

            orParam[6] = new OracleParameter("p_ult_usuario_act", OracleDbType.Varchar2, 20);
            orParam[6].Value = UsuarioResponsable;

            orParam[7] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            orParam[7].Direction = ParameterDirection.Output;

            try
            {
                OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, "seg_permisos_pkg.permiso_crear", orParam);
                return orParam[7].Value.ToString();
            }

            catch (Exception ex)
            {
                return ex.ToString();
            }
        }
        public static string borrarPermiso(int IDPermiso)
        {
            OracleParameter[] arrParam = new OracleParameter[2];

            arrParam[0] = new OracleParameter("p_id_permiso", OracleDbType.Int32);
            arrParam[0].Value = IDPermiso;

            arrParam[1] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[1].Direction = ParameterDirection.Output;

            try
            {
                OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, "seg_permisos_pkg.permiso_borrar", arrParam);
                return arrParam[1].Value.ToString();
            }

            catch (Exception ex)
            {
                return ex.ToString();
            }
        }


        public DataTable getUsuariosTienenPermiso()
        {
            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_id_permiso", OracleDbType.Decimal);
            arrParam[0].Value = this.myID_Permiso;

            arrParam[1] = new OracleParameter("p_io_cursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;

            String cmdStr = "seg_usuarios_pkg.Usuarios_Permiso";

            try
            {
                return DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam).Tables[0];
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public DataTable getRolesTienenPermiso()
        {
            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_id_permiso", OracleDbType.Decimal);
            arrParam[0].Value = this.myID_Permiso;

            arrParam[1] = new OracleParameter("p_io_cursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;

            String cmdStr = "seg_roles_pkg.get_roles_permiso";

            try
            {
                return DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam).Tables[0];
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


        public string AgregarUsuario(string UserName, string UsuarioResponsable)
        {
            return Seg.AsociarPermisoRoleAlUsuario(UserName, -1, this.myID_Permiso, UsuarioResponsable);
        }
        public string RemoverUsuario(string UserName, string UsuarioResponsable)
        {
            return Seg.QuitarPermisoRoleAlUsuario(UserName, -1, this.myID_Permiso, UsuarioResponsable);
        }


        public string AgregarRole(int Role, string UsuarioResponsable)
        {
            return Seg.AsociarRolePermiso(this.myID_Permiso, Role, UsuarioResponsable);
        }

        public string RemoverRole(int Role, string UsuarioResponsable)
        {
            return Seg.DesasociarRolePermiso(this.myID_Permiso, Role, UsuarioResponsable);
        }


        public override void CargarDatos()
        {
            DataTable dt;

            dt = getPermisos(this.myID_Permiso);

            this.myDescripcion = dt.Rows[0]["Permiso_Des"].ToString();
            this.mySeccion = dt.Rows[0]["ID_Seccion"].ToString();
            this.myOrdenMenu = dt.Rows[0]["Orden_Menu"].ToString();
            this.myStatus = dt.Rows[0]["status"].ToString();
            this.myURL = dt.Rows[0]["direccion_electronica"].ToString();
            this.myTipo = dt.Rows[0]["tipo_permiso"].ToString();
            this.myMarcaCuota = dt.Rows[0]["marca_cuota"].ToString();

            dt.Dispose();
        }

        public override String GuardarCambios(string UsuarioResponsable)
        {
            OracleParameter[] orParam = new OracleParameter[10];

            orParam[0] = new OracleParameter("p_id_permiso", OracleDbType.Int32);
            orParam[0].Value = this.myID_Permiso;

            orParam[1] = new OracleParameter("p_permiso_des", OracleDbType.Varchar2, 40);
            orParam[1].Value = this.myDescripcion;

            orParam[2] = new OracleParameter("p_direccion_elec", OracleDbType.Varchar2, 200);
            orParam[2].Value = this.myURL;

            orParam[3] = new OracleParameter("p_ult_usuario_act", OracleDbType.Varchar2, 20);
            orParam[3].Value = UsuarioResponsable;

            orParam[4] = new OracleParameter("p_estatus", OracleDbType.Varchar2, 20);
            orParam[4].Value = this.myStatus;

            orParam[5] = new OracleParameter("p_id_seccion", OracleDbType.Int32);
            orParam[5].Value = this.mySeccion;

            if (this.myOrdenMenu != "")
            {
                orParam[6] = new OracleParameter("p_orden_menu", OracleDbType.Int32);
                orParam[6].Value = this.myOrdenMenu;
            }
            else
            {
                orParam[6] = new OracleParameter("p_orden_menu", OracleDbType.Int32);
                orParam[6].Value = 0;
            }


            orParam[7] = new OracleParameter("p_tipo_permiso", OracleDbType.Varchar2, 1);
            orParam[7].Value = this.myTipo;

            orParam[8] = new OracleParameter("p_marca_cuota", OracleDbType.Varchar2, 1);
            orParam[8].Value = this.myMarcaCuota;

            orParam[9] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            orParam[9].Direction = ParameterDirection.Output;

            try
            {
                OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, "seg_permisos_pkg.permiso_editar", orParam);
                return orParam[9].Value.ToString();
            }

            catch (Exception ex)
            {
                return ex.ToString();
            }
        }

        public static string PermisoWebService(string usuario, string permiso_descripcion)
        {

            OracleParameter[] orParam = new OracleParameter[3];

            orParam[0] = new OracleParameter("p_id_usuario", OracleDbType.Varchar2, 35);
            orParam[0].Value = usuario;

            orParam[1] = new OracleParameter("p_permiso_des", OracleDbType.Varchar2, 200);
            orParam[1].Value = permiso_descripcion;

            orParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            orParam[2].Direction = ParameterDirection.Output;
            try
            {
                OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, "seg_usuarios_pkg.UsuarioWebServicesAutorizado", orParam);
                return SuirPlus.Utilitarios.Utils.sacarMensajeDeError(orParam[2].Value.ToString());
            }

            catch (Exception ex)
            {
                return ex.ToString();
            }

        }

        public static DataTable GetServicios_Cuotas()
        {

            OracleParameter[] arrParam = new OracleParameter[2];

            arrParam[0] = new OracleParameter("p_io_cursor", OracleDbType.RefCursor);
            arrParam[0].Direction = ParameterDirection.Output;

            arrParam[1] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[1].Direction = ParameterDirection.Output;

            String cmdStr = "seg_permisos_pkg.get_ServicioCuota";

            try
            {
                return DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam).Tables[0];
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }

        public static DataTable DataServiciosCuotas()
        {

            OracleParameter[] arrParam = new OracleParameter[2];

            arrParam[0] = new OracleParameter("p_io_cursor", OracleDbType.RefCursor);
            arrParam[0].Direction = ParameterDirection.Output;

            arrParam[1] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[1].Direction = ParameterDirection.Output;

            String cmdStr = "seg_permisos_pkg.DatasetServiciosCuotas";

            try
            {
                return DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam).Tables[0];
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }


        public static string InsertCuota(int IDPermiso, string usuario, decimal Cuota,string UsuarioLogueado)
        {

            OracleParameter[] arrParam = new OracleParameter[5];

            arrParam[0] = new OracleParameter("p_id_permiso", OracleDbType.Decimal);
            arrParam[0].Value = Utilitarios.Utils.verificarNulo(IDPermiso);

            arrParam[1] = new OracleParameter("p_id_usuario", OracleDbType.Varchar2, 35);
            arrParam[1].Value = usuario;

            arrParam[2] = new OracleParameter("p_cuota", OracleDbType.Decimal, 6);
            arrParam[2].Value = Cuota;

            arrParam[3] = new OracleParameter("p_usuario_act", OracleDbType.Varchar2, 20);
            arrParam[3].Value = UsuarioLogueado;

            arrParam[4] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[4].Direction = ParameterDirection.Output;

            try
            {
                OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, "seg_permisos_pkg.InsertarCuota", arrParam);
                return SuirPlus.Utilitarios.Utils.sacarMensajeDeError(arrParam[4].Value.ToString());
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


        public static string BorrarCuota(int IDPermiso, string usuario)
        {

            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_id_permiso", OracleDbType.Decimal);
            arrParam[0].Value = Utilitarios.Utils.verificarNulo(IDPermiso);

            arrParam[1] = new OracleParameter("p_id_usuario", OracleDbType.Varchar2, 35);
            arrParam[1].Value = usuario;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;


            try
            {
                OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, "seg_permisos_pkg.BorrarCuota", arrParam);
                return SuirPlus.Utilitarios.Utils.sacarMensajeDeError(arrParam[2].Value.ToString());
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


        public static string ActualizarCuota(int IDPermiso, string usuario)
        {

            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_id_permiso", OracleDbType.Decimal);
            arrParam[0].Value = Utilitarios.Utils.verificarNulo(IDPermiso);

            arrParam[1] = new OracleParameter("p_id_usuario", OracleDbType.Varchar2, 35);
            arrParam[1].Value = usuario;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;

            try
            {
                OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, "seg_permisos_pkg.ActualizarCuota", arrParam);
                return SuirPlus.Utilitarios.Utils.sacarMensajeDeError(arrParam[2].Value.ToString());
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public static string ValidarCuota(int IDPermiso, string usuario)
        {

            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_id_permiso", OracleDbType.Decimal);
            arrParam[0].Value = Utilitarios.Utils.verificarNulo(IDPermiso);

            arrParam[1] = new OracleParameter("p_id_usuario", OracleDbType.Varchar2, 35);
            arrParam[1].Value = usuario;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;

            try
            {
                OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, "seg_permisos_pkg.ValidarCuotasConsumidas", arrParam);
                return arrParam[2].Value.ToString();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public static string BuscarIdPermisoPorDireccionURL(string Permiso_URL)
        {

            OracleParameter[] arrParam = new OracleParameter[2];

            arrParam[0] = new OracleParameter("p_permiso_url", OracleDbType.Varchar2);
            arrParam[0].Value = Permiso_URL;

            arrParam[1] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[1].Direction = ParameterDirection.Output;

            try
            {
                OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, "seg_permisos_pkg.BuscarIdPermiso", arrParam);
                return SuirPlus.Utilitarios.Utils.sacarMensajeDeError(arrParam[1].Value.ToString());
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

    }
}
