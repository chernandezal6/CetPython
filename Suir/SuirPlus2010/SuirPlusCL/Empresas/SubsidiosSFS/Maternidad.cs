using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using Oracle.ManagedDataAccess.Client;

namespace SuirPlus.Empresas.SubsidiosSFS
{
    public class Maternidad : FrameWork.Objetos
    {

        #region "Atributos de la Clase"
        private string cuentaBanco;
        /// <summary>
        /// Cuenta receptora del subsidio por maternidad.
        /// </summary>
        public string CuentaBanco
        {
            get { return cuentaBanco; }
            set { cuentaBanco = value; }
        }

        private int idNss;
        /// <summary>
        /// NSS de la trabajadora
        /// </summary>
        public int IdNss
        {
            get { return idNss; }
            set { idNss = value; }
        }

        private int secuenciaParto;
        /// <summary>
        /// Clave para diferenciar los partos
        /// </summary>
        public int SecuenciaParto
        {
            get { return secuenciaParto; }
            set { secuenciaParto = value; }
        }

        private DateTime fechaDiagnostico;
        /// <summary>
        /// Fecha de diagnostico del embarazo
        /// </summary>
        public DateTime FechaDiagnostico
        {
            get { return fechaDiagnostico; }
            set { fechaDiagnostico = value; }
        }

        private DateTime fechaEstimadaParto;
        /// <summary>
        /// Fecha estimada del parto
        /// </summary>
        public DateTime FechaEstimadaParto
        {
            get { return fechaEstimadaParto; }
            set { fechaEstimadaParto = value; }
        }

        private DateTime fechaPerdida;
        /// <summary>
        /// Fecha de perdida del embarazo
        /// </summary>
        public DateTime FechaPerdida
        {
            get { return fechaPerdida; }
            set { fechaPerdida = value; }
        }

        private DateTime fechaParto;
        /// <summary>
        /// Fecha del parto
        /// </summary>
        public DateTime FechaParto
        {
            get { return fechaParto; }
            set { fechaParto = value; }
        }

        private DateTime fechaDefuncionMadre;
        /// <summary>
        /// Fecha de muerte de la madre
        /// </summary>
        public DateTime FechaDefuncionMadre
        {
            get { return fechaDefuncionMadre; }
            set { fechaDefuncionMadre = value; }
        }

        private string status;
        /// <summary>
        /// AC=Activo, In=Invalidado por el empleador, FA=Fallecida
        /// </summary>
        public string Status
        {
            get { return status; }
            set { status = value; }
        }

        private DateTime ultimaFechaAct;
        /// <summary>
        /// Fecha ultima actualizacion del registro
        /// </summary>
        public DateTime UltimaFechaAct
        {
            get { return ultimaFechaAct; }
            set { ultimaFechaAct = value; }
        }

        private string ultimoUsuarioAct;
        /// <summary>
        /// Ultimo usuario que tocó este registro.
        /// </summary>
        public string UltimoUsuarioAct
        {
            get { return ultimoUsuarioAct; }
            set { ultimoUsuarioAct = value; }
        }

        private string empleadorRegistroEmbarazo;
        /// <summary>
        /// Razon Social que registro el embarazo
        /// </summary>
        public string EmpleadorRegistroEmbarazo
        {
            get { return this.empleadorRegistroEmbarazo; }
            set { this.empleadorRegistroEmbarazo = value; }
        }

        private DateTime fechaRegistroRE;
        /// <summary>
        /// Fecha en que se registro el embarazo
        /// </summary>
        public DateTime FechaRegistroRegistroEmbarazo
        {
            get { return fechaRegistroRE; }
            set { fechaRegistroRE = value; }
        }

        private string usuarioRE;
        /// <summary>
        /// Usuario que registra el embarazo
        /// </summary>
        public string UsuarioRegistroEmbarazo
        {
            get { return usuarioRE; }
            set { usuarioRE = value; }
        }

        private string empleadorPerdidaEmbarazo;
        /// <summary>
        /// Razon Social que registro la perdida del Embarazo
        /// </summary>
        public string EmpleadorPerdidaEmbarazo
        {
            get { return this.empleadorPerdidaEmbarazo; }
            set { this.empleadorPerdidaEmbarazo = value; }
        }

        private DateTime fechaRegistroPE;
        /// <summary>
        /// Fecha en que se registro la perdida del embarazo
        /// </summary>
        public DateTime FechaRegistroPerdidaEmbarazo
        {
            get { return fechaRegistroPE; }
            set { fechaRegistroPE = value; }
        }

        private string usuarioPE;
        /// <summary>
        /// Usuario que registra la perdida del embarazo
        /// </summary>
        public string UsuarioPerdidaEmbarazo
        {
            get { return usuarioPE; }
            set { usuarioPE = value; }
        }

        private string empleadorNacimiento;
        /// <summary>
        /// Razon Social que registro el Nacimiento
        /// </summary>
        public string EmpleadorNacimiento
        {
            get { return this.empleadorNacimiento; }
            set { this.empleadorNacimiento = value; }
        }

        private DateTime fechaRegistroNC;
        /// <summary>
        /// Fecha en que se registro el nacimiento
        /// </summary>
        public DateTime FechaRegistroNacimiento
        {
            get { return fechaRegistroNC; }
            set { fechaRegistroNC = value; }
        }

        private string usuarioNC;
        /// <summary>
        /// Usuario que registra el nacimiento
        /// </summary>
        public string UsuarioNacimiento
        {
            get { return usuarioNC; }
            set { usuarioNC = value; }
        }

        private string empleadorMuerteMadre;
        /// <summary>
        /// Razon Social que registro la muerte de la madre
        /// </summary>
        public string EmpleadorMuerteMadre
        {
            get { return this.empleadorMuerteMadre; }
            set { this.empleadorMuerteMadre = value; }
        }

        private DateTime fechaRegistroMM;
        /// <summary>
        /// Fecha en que se registro la muerte de la madre
        /// </summary>
        public DateTime FechaRegistroMuerteMadre
        {
            get { return fechaRegistroMM; }
            set { fechaRegistroMM = value; }
        }

        private string usuarioMM;
        /// <summary>
        /// Usuario que registra la muerte de la madre
        /// </summary>
        public string UsuarioMuerteMadre
        {
            get { return usuarioMM; }
            set { usuarioMM = value; }
        }

        private string cedula;
        /// <summary>
        /// Numero del identificacion ( pasaporte, rnc, etc.)  requerido para los ciudadano extranjeros.
        /// </summary>
        public string Cedula
        {
            get { return cedula; }
            set { cedula = value; }
        }

        private string nombres;
        /// <summary>
        /// Nombres
        /// </summary>
        public string Nombres
        {
            get { return nombres; }
            set { nombres = value; }
        }

        private string primerApellido;
        /// <summary>
        /// Primer apellido
        /// </summary>
        public string PrimerApellido
        {
            get { return primerApellido; }
            set { primerApellido = value; }
        }

        private string segundoApellido;
        /// <summary>
        /// Segundo apellido
        /// </summary>
        public string SegundoApellido
        {
            get { return segundoApellido; }
            set { segundoApellido = value; }
        }

        private string celular;
        /// <summary>
        /// Segundo apellido
        /// </summary>
        public string Celular
        {
            get { return celular; }
            set { celular = value; }
        }

        private string telefono;
        /// <summary>
        /// Segundo apellido
        /// </summary>
        public string Telefono
        {
            get { return telefono; }
            set { telefono = value; }
        }

        private string email;
        /// <summary>
        /// Segundo apellido
        /// </summary>
        public string Email
        {
            get { return email; }
            set { email = value; }
        }

        // Se vaaaaaaaaaaaaaaa
        private Tutor tutorActivo;
        public Tutor TutorActivo
        {
            get { return tutorActivo; }
            set { tutorActivo = value; }
        }
        #endregion

        #region "Metodos de la Clase"
        //Construtor que invoca el cargar datos de la clase
        public Maternidad(int Nss)
        {
            this.idNss = Nss;
            CargarDatos();
        }

        public Maternidad(string Cedula)
        {
            int Nss;

            DataTable dt;

            dt = Utilitarios.TSS.getConsultaNss(Cedula, string.Empty, string.Empty, string.Empty, string.Empty, 1, 9999);

            Nss = Convert.ToInt32(dt.Rows[0]["id_nss"].ToString());

            this.idNss = Nss;
            CargarDatos();
        }

        public static string ValidarRegistroEmbarazo(String NroDocumento, Int32 RegistroPatronal)
        {
            // NroDocumento Sea valido
            // Sexo, debe ser F
            // Este activa en Nomina para esa empresa
            // No debe estar registrado este embarazo previamente

            OracleParameter[] parameters = new OracleParameter[3];

            parameters[0] = new OracleParameter("NroDocumento", OracleDbType.Varchar2);
            parameters[0].Value = NroDocumento;
            parameters[1] = new OracleParameter("RegistroPatronal", OracleDbType.Int32);
            parameters[1].Value = RegistroPatronal;
            parameters[2] = new OracleParameter("ResultNumber", OracleDbType.NVarchar2, 200);
            parameters[2].Direction = ParameterDirection.Output;

            String cmdStr = "SFS_NOV_PKG.ValidarRegistroEmbarazo";

            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, parameters);

                return Utilitarios.Utils.sacarMensajeDeError(parameters[2].Value.ToString());
            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                return ex.Message;
            }

            //Salida: 0. - Mens. Error
            // return string.Empty;
        }

        public static string ValidarReporteLicencia(String NroDocumento, Int32 RegistroPatronal)
        {
            // NroDocumento Sea valido
            // Sexo, debe ser F
            // Este activa en Nomina para esa empresa
            // La licencia no debe estar reportada para esa empresa
            // La trabajadora debe estar afiliada al SFS: tss_dependientes_ok_pe_mv , tss_titulares_ars_ok_pe_mv 
            // El registro de embarazo debe estar reportado previamente
            OracleParameter[] parameters = new OracleParameter[3];

            parameters[0] = new OracleParameter("p_NroDocumento", OracleDbType.Varchar2);
            parameters[0].Value = NroDocumento;
            parameters[1] = new OracleParameter("RegistroPatronal", OracleDbType.Int32);
            parameters[1].Value = RegistroPatronal;
            parameters[2] = new OracleParameter("ResultNumber", OracleDbType.NVarchar2, 200);
            parameters[2].Direction = ParameterDirection.Output;

            String cmdStr = "SFS_NOV_PKG.ValidarReporteLicencia";

            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, parameters);

                return Utilitarios.Utils.sacarMensajeDeError(parameters[2].Value.ToString());
            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                return ex.Message;

            }

            //return string.Empty;

            //Salida: 0. - Mens. Error
        }

        public static string ValidarReporteNacimiento(String NroDocumento, Int32 RegistroPatronal, ref string CantidadLactantes)
        {
            OracleParameter[] parameters = new OracleParameter[4];

            parameters[0] = new OracleParameter("NroDocumento", OracleDbType.Varchar2);
            parameters[0].Value = NroDocumento;
            parameters[1] = new OracleParameter("RegistroPatronal", OracleDbType.Int32);
            parameters[1].Value = RegistroPatronal;
            parameters[2] = new OracleParameter("CantidadLactantes", OracleDbType.NVarchar2, 1);
            parameters[2].Direction = ParameterDirection.Output;
            parameters[3] = new OracleParameter("ResultNumber", OracleDbType.NVarchar2, 200);
            parameters[3].Direction = ParameterDirection.Output;


            String cmdStr = "SFS_NOV_PKG.ValidarReporteNacimiento";

            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, parameters);

                CantidadLactantes = parameters[2].Value.ToString();

                if (CantidadLactantes == "null")
                {
                    CantidadLactantes = "0";
                }

                return Utilitarios.Utils.sacarMensajeDeError(parameters[3].Value.ToString());
            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                return ex.Message;
            }

        }

        public static string ValidarRegistroTutor(String NroDocumento)
        {
            OracleParameter[] parameters = new OracleParameter[2];

            parameters[0] = new OracleParameter("NroDocumento", OracleDbType.Varchar2);
            parameters[0].Value = NroDocumento;
            parameters[1] = new OracleParameter("ResultNumber", OracleDbType.NVarchar2, 200);
            parameters[1].Direction = ParameterDirection.Output;

            String cmdStr = "SFS_NOV_PKG.ValidarRegistroTutor";

            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, parameters);

                return Utilitarios.Utils.sacarMensajeDeError(parameters[1].Value.ToString());
            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                return ex.Message;
            }
        }

        public static string ValidarMadreRegistroTutor(String NroDocumento, Int32 RegistroPatronal)
        {
            OracleParameter[] parameters = new OracleParameter[3];

            parameters[0] = new OracleParameter("NroDocumento", OracleDbType.Varchar2);
            parameters[0].Value = NroDocumento;
            parameters[1] = new OracleParameter("RegistroPatronal", OracleDbType.Int32);
            parameters[1].Value = RegistroPatronal;
            parameters[2] = new OracleParameter("ResultNumber", OracleDbType.NVarchar2, 200);
            parameters[2].Direction = ParameterDirection.Output;

            String cmdStr = "SFS_NOV_PKG.ValidarMadreRegistroTutor";

            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, parameters);

                return Utilitarios.Utils.sacarMensajeDeError(parameters[2].Value.ToString());
            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                return ex.Message;
            }
        }

        public static string ValidarMuerteMadre(String NroDocumento, Int32 RegistroPatronal)
        {
            OracleParameter[] parameters = new OracleParameter[3];

            parameters[0] = new OracleParameter("NroDocumento", OracleDbType.Varchar2);
            parameters[0].Value = NroDocumento;
            parameters[1] = new OracleParameter("RegistroPatronal", OracleDbType.Int32);
            parameters[1].Value = RegistroPatronal;
            parameters[2] = new OracleParameter("ResultNumber", OracleDbType.NVarchar2, 200);
            parameters[2].Direction = ParameterDirection.Output;

            String cmdStr = "SFS_NOV_PKG.ValidarMuerteMadre";

            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, parameters);

                return Utilitarios.Utils.sacarMensajeDeError(parameters[2].Value.ToString());
            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                return ex.Message;
            }
        }

        public static string ValidarConsultaNovedades(String NroDocumento, Int32 RegistroPatronal)
        {
            OracleParameter[] parameters = new OracleParameter[3];

            parameters[0] = new OracleParameter("NroDocumento", OracleDbType.Varchar2);
            parameters[0].Value = NroDocumento;
            parameters[1] = new OracleParameter("RegistroPatronal", OracleDbType.Int32);
            parameters[1].Value = RegistroPatronal;
            parameters[2] = new OracleParameter("ResultNumber", OracleDbType.NVarchar2, 200);
            parameters[2].Direction = ParameterDirection.Output;

            String cmdStr = "SFS_NOV_PKG.ValidarConsultaNovedades";

            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, parameters);

                return Utilitarios.Utils.sacarMensajeDeError(parameters[2].Value.ToString());
            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                return ex.Message;
            }
        }

        public static string ValidarMuerteLactante(String NroDocumento, Int32 RegistroPatronal)
        {
            OracleParameter[] parameters = new OracleParameter[3];

            parameters[0] = new OracleParameter("NroDocumento", OracleDbType.Varchar2);
            parameters[0].Value = NroDocumento;
            parameters[1] = new OracleParameter("RegistroPatronal", OracleDbType.Int32);
            parameters[1].Value = RegistroPatronal;
            parameters[2] = new OracleParameter("ResultNumber", OracleDbType.NVarchar2, 200);
            parameters[2].Direction = ParameterDirection.Output;

            String cmdStr = "SFS_NOV_PKG.ValidarMuerteLactante";

            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, parameters);

                return Utilitarios.Utils.sacarMensajeDeError(parameters[2].Value.ToString());
            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                return ex.Message;
            }
        }

        public static string ValidarPerdidaEmbarazo(String NroDocumento, Int32 RegistroPatronal)
        {
            OracleParameter[] parameters = new OracleParameter[3];

            parameters[0] = new OracleParameter("NroDocumento", OracleDbType.Varchar2);
            parameters[0].Value = NroDocumento;
            parameters[1] = new OracleParameter("RegistroPatronal", OracleDbType.Int32);
            parameters[1].Value = RegistroPatronal;
            parameters[2] = new OracleParameter("ResultNumber", OracleDbType.NVarchar2, 200);
            parameters[2].Direction = ParameterDirection.Output;

            String cmdStr = "SFS_NOV_PKG.ValidarPerdidaEmbarazo";

            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, parameters);

                return Utilitarios.Utils.sacarMensajeDeError(parameters[2].Value.ToString());
            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                return ex.Message;
            }
        }

        public static string ValidarCambioCuentaMadre(String NroDocumento, Int32 RegistroPatronal)
        {
            OracleParameter[] parameters = new OracleParameter[3];

            parameters[0] = new OracleParameter("NroDocumento", OracleDbType.Varchar2);
            parameters[0].Value = NroDocumento;
            parameters[1] = new OracleParameter("RegistroPatronal", OracleDbType.Int32);
            parameters[1].Value = RegistroPatronal;
            parameters[2] = new OracleParameter("ResultNumber", OracleDbType.NVarchar2, 200);
            parameters[2].Direction = ParameterDirection.Output;

            String cmdStr = "SFS_NOV_PKG.ValidarCambioCuentaMadre";

            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, parameters);

                return Utilitarios.Utils.sacarMensajeDeError(parameters[2].Value.ToString());
            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                return ex.Message;
            }
        }

        public static string ValidarCambioCuentaTutor(String NroDocumento, Int32 RegistroPatronal)
        {
            OracleParameter[] parameters = new OracleParameter[3];

            parameters[0] = new OracleParameter("NroDocumento", OracleDbType.Varchar2);
            parameters[0].Value = NroDocumento;
            parameters[1] = new OracleParameter("RegistroPatronal", OracleDbType.Int32);
            parameters[1].Value = RegistroPatronal;
            parameters[2] = new OracleParameter("ResultNumber", OracleDbType.NVarchar2, 200);
            parameters[2].Direction = ParameterDirection.Output;

            String cmdStr = "SFS_NOV_PKG.ValidarCambioCuentaTutor";

            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, parameters);

                return Utilitarios.Utils.sacarMensajeDeError(parameters[2].Value.ToString());
            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                return ex.Message;
            }
        }

        public static string ValidarTutorCuenta(String NroDocumentoMadre, String NroDocumentoTutor)
        {
            OracleParameter[] parameters = new OracleParameter[3];

            parameters[0] = new OracleParameter("NroDocumentoMadre", OracleDbType.Varchar2);
            parameters[0].Value = NroDocumentoMadre;

            parameters[1] = new OracleParameter("NroDocumentoTutor", OracleDbType.Varchar2);
            parameters[1].Value = NroDocumentoTutor;

            parameters[2] = new OracleParameter("ResultNumber", OracleDbType.NVarchar2, 200);
            parameters[2].Direction = ParameterDirection.Output;

            String cmdStr = "SFS_NOV_PKG.ValidarTutorCuenta";

            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, parameters);
                return Utilitarios.Utils.sacarMensajeDeError(parameters[2].Value.ToString());
            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                return ex.Message;
            }
        }

        public static DataTable getLicencias(string NroDocumento)
        {
            OracleParameter[] parameters = new OracleParameter[3];

            parameters[0] = new OracleParameter("p_no_documento", OracleDbType.Varchar2);
            parameters[0].Value = NroDocumento;

            parameters[1] = new OracleParameter("p_io_cursor", OracleDbType.RefCursor);
            parameters[1].Direction = ParameterDirection.Output;

            parameters[2] = new OracleParameter("p_result_number", OracleDbType.Varchar2, 200);
            parameters[2].Direction = ParameterDirection.Output;

            string cmdStr = "SFS_SUBSIDIOS_PKG.getlicenciasbynrodcoumento";
            string res = string.Empty;
            try
            {
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, parameters);
                if (ds.Tables.Count > 0)
                {
                    return ds.Tables[0];
                }

                res = parameters[2].Value.ToString();
                throw new Exception(res);
            }

            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                return null;
            }

        }

        public static DataTable getLicencia()
        {
            OracleParameter[] parameters = new OracleParameter[2];

            parameters[0] = new OracleParameter("p_io_cursor", OracleDbType.RefCursor);
            parameters[0].Direction = ParameterDirection.Output;

            parameters[1] = new OracleParameter("p_result_number", OracleDbType.Varchar2, 200);
            parameters[1].Direction = ParameterDirection.Output;

            string cmdStr = "SFS_SUBSIDIOS_PKG.getlicencias";
            string res = string.Empty;

            try
            {
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, parameters);
                if (ds.Tables.Count > 0)
                {
                    return ds.Tables[0];
                }

                res = parameters[1].Value.ToString();
                throw new Exception(res);
            }

            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                return null;
            }
        }

        public static DataView getLicenciaEmpleador(string NroDocumento, string razonSocial)
        {
            DataTable dt = new DataTable();
            dt = getLicencias(NroDocumento);

            DataView dv = new DataView(dt);
            dv.RowFilter = "RAZON_SOCIAL = '" + razonSocial + "'";

            return dv;
        }

        public static DataView getLicenciaActivaEmpleador(string NroDocumento, string razonSocial)
        {
            DataTable dt = new DataTable();
            dt = getLicencias(NroDocumento);

            DataView dv = new DataView(dt);
            dv.RowFilter = "RAZON_SOCIAL = '" + razonSocial + "' AND STATUS= 'AC'";

            return dv;
        }

        public DataView getLactantesFallecidos()
        {
            DataTable dt = new DataTable();
            dt = getLactantes();

            DataView dv = new DataView(dt);
            dv.RowFilter = "STATUS = 'Fallecido'";


            return dv;
        }

        public DataView getLactantesVivos()
        {
            DataTable dt = new DataTable();
            DataView dv = new DataView();
            dt = getLactantes();

            if (dt.Rows.Count > 0)
            {
                dv = new DataView(dt);
                dv.RowFilter = "STATUS = 'Activo' OR STATUS = 'Pendiente Aprobación'";
            }

            return dv;
        }

        public DataTable getLactantes()
        {
            OracleParameter[] parameters = new OracleParameter[3];

            parameters[0] = new OracleParameter("p_Id_Nss_Madre", OracleDbType.Int32);
            parameters[0].Value = this.idNss;

            parameters[1] = new OracleParameter("p_io_cursor", OracleDbType.RefCursor);
            parameters[1].Direction = ParameterDirection.Output;

            parameters[2] = new OracleParameter("p_result_number", OracleDbType.Varchar2, 200);
            parameters[2].Direction = ParameterDirection.Output;

            string cmdStr = "SFS_SUBSIDIOS_PKG.getlactantes";
            string res = string.Empty;
            try
            {
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, parameters);
                if (ds.Tables.Count > 0)
                {
                    return ds.Tables[0];
                }

                res = parameters[2].Value.ToString();
                throw new Exception(res);
            }

            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                return null;
            }



        }

        public DataView getTutorActivo()
        {

            // Crear un DataView,. Filtrar por campo STATUS 
            // Devuevle el DT con solamente el Activo....
            DataTable dt = new DataTable();
            DataView dv = new DataView(dt);
            dt = this.getTutores();
            dv.RowFilter = "Status = 'AC'";
            return dv;
        }

        public DataTable getTutores()
        {
            OracleParameter[] parameters = new OracleParameter[3];

            parameters[0] = new OracleParameter("p_IdNssMadre", OracleDbType.Int32);
            parameters[0].Value = this.idNss;

            parameters[1] = new OracleParameter("p_io_cursor", OracleDbType.RefCursor);
            parameters[1].Direction = ParameterDirection.Output;

            parameters[2] = new OracleParameter("p_result_number", OracleDbType.Varchar2, 200);
            parameters[2].Direction = ParameterDirection.Output;

            string cmdStr = "SFS_SUBSIDIOS_PKG.gettutores";
            string res = string.Empty;

            try
            {
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, parameters);
                if (ds.Tables.Count > 0)
                {
                    return ds.Tables[0];
                }

                res = parameters[2].Value.ToString();
                throw new Exception(res);
            }

            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                return null;
            }
        }

        public DataTable getEventos()
        {
            OracleParameter[] parameters = new OracleParameter[3];

            parameters[0] = new OracleParameter("p_Id_Nss_Madre", OracleDbType.Int32);
            parameters[0].Value = this.idNss;

            parameters[1] = new OracleParameter("p_io_cursor", OracleDbType.RefCursor);
            parameters[1].Direction = ParameterDirection.Output;

            parameters[2] = new OracleParameter("p_result_number", OracleDbType.Varchar2, 200);
            parameters[2].Direction = ParameterDirection.Output;

            string cmdStr = "SFS_SUBSIDIOS_PKG.geteventos";
            string res = string.Empty;
            try
            {
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, parameters);
                if (ds.Tables.Count > 0)
                {
                    return ds.Tables[0];
                }

                res = parameters[2].Value.ToString();
                throw new Exception(res);
            }

            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                return null;
            }
        }

        public static DataTable getNovedades(string NroDocumento, int id_nss, Int32 id_registro_patronal)
        {
            OracleParameter[] parameters = new OracleParameter[5];

            parameters[0] = new OracleParameter("p_no_documento", OracleDbType.Varchar2);
            parameters[0].Value = NroDocumento;

            parameters[1] = new OracleParameter("p_id_nss", OracleDbType.Decimal);
            parameters[1].Value = id_nss;

            parameters[2] = new OracleParameter("p_id_registro_patronal", OracleDbType.Int32);
            parameters[2].Value = id_registro_patronal;

            parameters[3] = new OracleParameter("p_io_cursor", OracleDbType.RefCursor);
            parameters[3].Direction = ParameterDirection.Output;

            parameters[4] = new OracleParameter("p_result_number", OracleDbType.Varchar2, 200);
            parameters[4].Direction = ParameterDirection.Output;

            string cmdStr = "sfs_nov_pkg.ConsNovedades";
            string res = string.Empty;
            try
            {
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, parameters);
                if (ds.Tables.Count > 0)
                {
                    return ds.Tables[0];
                }

                res = parameters[3].Value.ToString();

                throw new Exception(res);
            }

            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                return null;
            }
        }

        public static DataTable getElegibilidad(string NroDocumento)
        {
            OracleParameter[] parameters = new OracleParameter[3];

            parameters[0] = new OracleParameter("p_no_documento", OracleDbType.Varchar2);
            parameters[0].Value = NroDocumento;

            parameters[1] = new OracleParameter("p_io_cursor", OracleDbType.RefCursor);
            parameters[1].Direction = ParameterDirection.Output;

            parameters[2] = new OracleParameter("p_result_number", OracleDbType.Varchar2, 200);
            parameters[2].Direction = ParameterDirection.Output;

            string cmdStr = "SFS_SUBSIDIOS_PKG.getelegibilidad";
            string res = string.Empty;
            try
            {
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, parameters);
                if (ds.Tables.Count > 0)
                {
                    return ds.Tables[0];
                }

                res = parameters[2].Value.ToString();

                throw new Exception(res);
            }

            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                return null;
            }
        }

        /// <summary>
        /// Crea un registro de embarazo.
        /// </summary>
        /// <param name="CedulaEmbarazada">Cédula de la embarazada.</param>
        /// <param name="IdRegistroPatronal">Registro patronal del empleador que está registrando el embarazo.</param>
        /// <param name="FechaDiagnostico">Fecha en que el parámetro fué diagnosticado.</param>
        /// <param name="FechaEstimadaParto">Fecha aproximada del parto.</param>
        /// <param name="IDEntidadRecaudadora">Banco donde está la cuenta donde se depositarán los fondos del subsidio por embarazo.</param>
        /// <param name="CuentaBanco">Cuenta bancaria donde se depositarán los fondos del subsidio por embarazo.</param>
        /// <param name="Usuario">Usuario que ejecutó este movimiento.</param>
        /// <returns>0 en caso de no haber errores</returns>
        public static string RegistroEmbarazo(string CedulaEmbarazada, int IdRegistroPatronal, DateTime FechaDiagnostico, DateTime FechaEstimadaParto, string CedulaTutor, string Telefono, string Celular, string Email, string Usuario)
        {
            OracleParameter[] parameters = new OracleParameter[10];


            parameters[0] = new OracleParameter("p_no_documento", CedulaEmbarazada);
            parameters[1] = new OracleParameter("p_id_registro_patronal", IdRegistroPatronal);
            parameters[2] = new OracleParameter("p_fecha_diagnostico", FechaDiagnostico);
            parameters[3] = new OracleParameter("p_fecha_posible_parto", FechaEstimadaParto);
            parameters[4] = new OracleParameter("p_no_documento_tutor", CedulaTutor);
            parameters[5] = new OracleParameter("p_telefono", Telefono);
            parameters[6] = new OracleParameter("p_celular", Celular);
            parameters[7] = new OracleParameter("p_email", Email);
            parameters[8] = new OracleParameter("p_id_usuario", Usuario);

            parameters[9] = new OracleParameter("p_ResultNumber", OracleDbType.NVarchar2, 200);
            parameters[9].Direction = ParameterDirection.InputOutput;

            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, "SFS_NOV_PKG.RegistroEmbarazo", parameters);
                return Utilitarios.Utils.sacarMensajeDeError(parameters[9].Value.ToString());
            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;
            }
        }

        /// <summary>
        /// Crea un registro de pérdida de embarazo.
        /// </summary>
        /// <param name="CedulaEmbarazada">Cédula de la embarazada.</param>
        /// <param name="IdRegistroPatronal">Registro patronal del empleador que está registrando la pérdida del embarazo.</param>
        /// <param name="FechaPerdida">Fecha en que la embarazada perdió la criatura.</param>
        /// <param name="Usuario">Usuario que ejecutó este movimiento.</param>
        /// <returns>0 en caso de no haber errores</returns>
        public static string PerdidaEmbarazo(string CedulaEmbarazada, int IdRegistroPatronal, DateTime FechaPerdida, string Usuario)
        {
            OracleParameter[] parameters = new OracleParameter[5];

            parameters[0] = new OracleParameter("p_no_documento", CedulaEmbarazada);
            parameters[1] = new OracleParameter("p_id_registro_patronal", IdRegistroPatronal);
            parameters[2] = new OracleParameter("P_fecha_perdida", FechaPerdida);
            parameters[3] = new OracleParameter("p_id_usuario", Usuario);

            parameters[4] = new OracleParameter("p_ResultNumber", OracleDbType.NVarchar2, 200);
            parameters[4].Direction = ParameterDirection.InputOutput;

            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, "SFS_NOV_PKG.PerdidaEmbarazo", parameters);
                return Utilitarios.Utils.sacarMensajeDeError(parameters[4].Value.ToString());
            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;
            }
        }

        /// <summary>
        /// Crea un registro de reporte de licencia por embarazo.
        /// </summary>
        /// <param name="CedulaEmbarazada">Cédula de la embarazada.</param>
        /// <param name="IdRegistroPatronal">Registro patronal del empleador que está registrando la pérdida del embarazo.</param>
        /// <param name="FechaInicioLicencia">Fecha de suspención de la actividad laboral.</param>
        /// <param name="Usuario">Usuario que ejecutó este movimiento.</param>
        /// <returns>0 en caso de no haber errores</returns>
        public static string ReporteLicencia(string CedulaEmbarazada, int IdRegistroPatronal, DateTime FechaInicioLicencia, string Usuario)
        {
            OracleParameter[] parameters = new OracleParameter[5];

            parameters[0] = new OracleParameter("p_no_documento", CedulaEmbarazada);
            parameters[1] = new OracleParameter("p_id_registro_patronal", IdRegistroPatronal);
            parameters[2] = new OracleParameter("p_fecha_inicio_licencia", FechaInicioLicencia);
            parameters[3] = new OracleParameter("p_id_usuario", Usuario);

            parameters[4] = new OracleParameter("p_ResultNumber", OracleDbType.NVarchar2, 200);
            parameters[4].Direction = ParameterDirection.InputOutput;
            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, "SFS_NOV_PKG.ReporteLicencia", parameters);
                return Utilitarios.Utils.sacarMensajeDeError(parameters[4].Value.ToString());
            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;
            }
        }

        /// <summary>
        /// Registra un nacimiento.
        /// </summary>
        /// <param name="CedulaEmbarazada">Cédula de la embarazada.</param>
        /// <param name="IdRegistroPatronal">Registro patronal del empleador que está registrando la pérdida del embarazo.</param>
        /// <param name="FechaNacimiento">Fecha de nacimiento de la criatura.</param>
        /// <param name="IdNSSLactante">Número de seguridad social del lactante</param>
        /// <param name="Nombres">Nombres del lactante.</param>
        /// <param name="PrimerApellido">Primer apellido del lactante</param>
        /// <param name="SegundoApellido">Segundo apellido del lactante</param>
        /// <param name="Sexo">Sexo del lactante</param>
        /// <param name="NUI">Número único de identidad</param>
        /// <param name="Usuario">Usuario que ejecutó este movimiento.</param>
        /// <returns>0 en caso de no haber errores</returns>
        public static string ReporteNacimiento(string CedulaEmbarazada, int IdRegistroPatronal, DateTime FechaNacimiento, int? IdNSSLactante, string Nombres, string PrimerApellido, string SegundoApellido, string Sexo, string NUI, string Usuario, int CantidadLactantes)
        {
            OracleParameter[] parameters = new OracleParameter[11];

            parameters[0] = new OracleParameter("p_no_documento", CedulaEmbarazada);
            parameters[1] = new OracleParameter("p_id_registro_patronal", IdRegistroPatronal);
            parameters[2] = new OracleParameter("p_fecha_nacimiento", FechaNacimiento);
            parameters[3] = new OracleParameter("p_nombres", Nombres);
            parameters[4] = new OracleParameter("p_primer_apellido", PrimerApellido);
            parameters[5] = new OracleParameter("p_segundo_apellido", SegundoApellido);
            parameters[6] = new OracleParameter("p_sexo", Sexo);
            parameters[7] = new OracleParameter("P_id_nss_lactante", IdNSSLactante);
            parameters[8] = new OracleParameter("P_cantidad_lactantes", CantidadLactantes);
            parameters[9] = new OracleParameter("p_id_usuario", Usuario);

            parameters[10] = new OracleParameter("p_ResultNumber", OracleDbType.NVarchar2, 200);
            parameters[10].Direction = ParameterDirection.InputOutput;
            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, "SFS_NOV_PKG.ReporteNacimiento", parameters);
                return Utilitarios.Utils.sacarMensajeDeError(parameters[10].Value.ToString());
            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;
            }
        }

        /// <summary>
        /// Registra la muerte de la mujer embarazada.
        /// </summary>
        /// <param name="CedulaEmbarazada">Cédula de la embarazada.</param>
        /// <param name="IdRegistroPatronal">Registro patronal del empleador que está registrando la pérdida del embarazo.</param>
        /// <param name="FechaDefuncion">Fecha de fallecimiento/defunción.</param>
        /// <param name="Usuario">Usuario que ejecutó este movimiento.</param>
        /// <returns>0 en caso de no haber errores</returns>
        public static string ReporteMuerteMadre(string CedulaEmbarazada, int IdRegistroPatronal, DateTime FechaDefuncion, string Usuario)
        {
            OracleParameter[] parameters = new OracleParameter[5];

            parameters[0] = new OracleParameter("p_no_documento", CedulaEmbarazada);
            parameters[1] = new OracleParameter("p_id_registro_patronal", IdRegistroPatronal);
            parameters[2] = new OracleParameter("p_fecha_inicio", FechaDefuncion);
            parameters[3] = new OracleParameter("p_id_usuario", Usuario);

            parameters[4] = new OracleParameter("p_ResultNumber", OracleDbType.NVarchar2, 200);
            parameters[4].Direction = ParameterDirection.InputOutput;
            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, "SFS_NOV_PKG.MuerteMadre", parameters);
                return Utilitarios.Utils.sacarMensajeDeError(parameters[4].Value.ToString());
            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;
            }
        }

        /// <summary>
        /// Registra el tutor de la(s) criatura(s) por nacer.
        /// </summary>
        /// <param name="CedulaEmbarazada">Cédula de la embarazada.</param>
        /// <param name="IdRegistroPatronal">Registro patronal del empleador que está registrando la pérdida del embarazo.</param>
        /// <param name="IDEntidadRecaudadora">Banco donde está la cuenta donde se depositarán los fondos del subsidio por embarazo.</param>
        /// <param name="CuentaBanco">Cuenta bancaria donde se depositarán los fondos del subsidio por embarazo.</param>
        /// <param name="CedulaTutor">Cédula del tutor.</param>
        /// <param name="Usuario">Usuario que ejecutó este movimiento.</param>
        /// <returns>0 en caso de no haber errores</returns>
        public static string RegistroTutor(string CedulaEmbarazada, int IdRegistroPatronal, string CedulaTutor, string Usuario)
        {
            OracleParameter[] parameters = new OracleParameter[5];

            parameters[0] = new OracleParameter("p_no_documento", CedulaEmbarazada);
            parameters[1] = new OracleParameter("p_id_registro_patronal", IdRegistroPatronal);
            parameters[2] = new OracleParameter("p_no_documento_tutor", CedulaTutor);
            parameters[3] = new OracleParameter("p_id_usuario", Usuario);

            parameters[4] = new OracleParameter("p_ResultNumber", OracleDbType.NVarchar2, 200);
            parameters[4].Direction = ParameterDirection.InputOutput;
            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, "SFS_NOV_PKG.RegistroTutor", parameters);
                return Utilitarios.Utils.sacarMensajeDeError(parameters[4].Value.ToString());
            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="CedulaEmbarazada"></param>
        /// <param name="RegistroPatronal"></param>
        /// <param name="NSSLactante"></param>
        /// <param name="SecuenciaLactante"></param>
        /// <param name="FechaDefuncionLactante"></param>
        /// <param name="Usuario"></param>
        /// <returns></returns>
        public static string ReporteMuerteLactante(string CedulaEmbarazada, int IdRegistroPatronal, int NSSLactante, int SecuenciaLactante, DateTime FechaDefuncionLactante, string Usuario)
        {
            OracleParameter[] parameters = new OracleParameter[7];

            parameters[0] = new OracleParameter("p_no_documento", CedulaEmbarazada);
            parameters[1] = new OracleParameter("p_id_registro_patronal", IdRegistroPatronal);
            parameters[2] = new OracleParameter("p_id_nss_lactante", NSSLactante);
            parameters[3] = new OracleParameter("p_secuencia_lactante", SecuenciaLactante);
            parameters[4] = new OracleParameter("p_fecha_defuncion", FechaDefuncionLactante);
            parameters[5] = new OracleParameter("p_id_usuario", Usuario);

            parameters[6] = new OracleParameter("p_ResultNumber", OracleDbType.NVarchar2, 200);
            parameters[6].Direction = ParameterDirection.InputOutput;
            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, "SFS_NOV_PKG.MuerteLactante", parameters);
                return Utilitarios.Utils.sacarMensajeDeError(parameters[6].Value.ToString());
            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;
            }
        }

        public static string CambioCuentaMadre(string CedulaEmbarazada, string NroCuenta, string Comentario, string Usuario)
        {
            OracleParameter[] parameters = new OracleParameter[5];

            parameters[0] = new OracleParameter("p_no_documento", CedulaEmbarazada);
            parameters[1] = new OracleParameter("p_cuenta_banco", NroCuenta);
            parameters[2] = new OracleParameter("p_comentario", Comentario);
            parameters[3] = new OracleParameter("p_id_usuario", Usuario);

            parameters[4] = new OracleParameter("p_ResultNumber", OracleDbType.NVarchar2, 200);
            parameters[4].Direction = ParameterDirection.InputOutput;
            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, "SFS_NOV_PKG.CambioCuentaMadre", parameters);
                return Utilitarios.Utils.sacarMensajeDeError(parameters[4].Value.ToString());
            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;
            }
        }

        public static string CambioCuentaTutor(string CedulaEmbarazada, string CedulaTutor, string NroCuenta, string Comentario, string Usuario)
        {
            OracleParameter[] parameters = new OracleParameter[6];

            parameters[0] = new OracleParameter("p_no_documento", CedulaEmbarazada);
            parameters[1] = new OracleParameter("p_no_documento_tutor", CedulaTutor);
            parameters[2] = new OracleParameter("p_cuenta_banco", NroCuenta);
            parameters[3] = new OracleParameter("p_comentario", Comentario);
            parameters[4] = new OracleParameter("p_id_usuario", Usuario);

            parameters[5] = new OracleParameter("p_ResultNumber", OracleDbType.NVarchar2, 200);
            parameters[5].Direction = ParameterDirection.InputOutput;
            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, "SFS_NOV_PKG.CambioCuentaTutor", parameters);
                return Utilitarios.Utils.sacarMensajeDeError(parameters[5].Value.ToString());
            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;
            }
        }

        public override void CargarDatos()
        {

            DataTable dt = getMaternidad(this.idNss);
            try
            {
                if (dt.Rows.Count > 0)
                {

                    this.cuentaBanco = dt.Rows[0]["cuenta_banco"].ToString();
                    this.idNss = Convert.ToInt32(dt.Rows[0]["id_nss"]);
                    this.secuenciaParto = Convert.ToInt32(dt.Rows[0]["secuencia"]);
                    if (!(dt.Rows[0]["fecha_diagnostico"] is DBNull))
                        this.fechaDiagnostico = Convert.ToDateTime(dt.Rows[0]["fecha_diagnostico"]);
                    if (!(dt.Rows[0]["fecha_estimada_parto"] is DBNull))
                        this.fechaEstimadaParto = Convert.ToDateTime(dt.Rows[0]["fecha_estimada_parto"]);
                    if (!(dt.Rows[0]["fecha_parto"] is DBNull))
                        this.fechaParto = Convert.ToDateTime(dt.Rows[0]["fecha_parto"]);
                    if (!(dt.Rows[0]["fecha_perdida"] is DBNull))
                        this.fechaPerdida = Convert.ToDateTime(dt.Rows[0]["fecha_perdida"]);
                    if (!(dt.Rows[0]["fecha_defuncion_madre"] is DBNull))
                        this.fechaDefuncionMadre = Convert.ToDateTime(dt.Rows[0]["fecha_defuncion_madre"]);
                    this.status = dt.Rows[0]["status"].ToString();
                    if (!(dt.Rows[0]["ult_fecha_act"] is DBNull))
                        this.ultimaFechaAct = Convert.ToDateTime(dt.Rows[0]["ult_fecha_act"]);
                    this.ultimoUsuarioAct = dt.Rows[0]["ult_usuario_act"].ToString();
                    if (!(dt.Rows[0]["id_registro_patronal_re"] is DBNull))
                    this.empleadorRegistroEmbarazo = dt.Rows[0]["id_registro_patronal_re"].ToString();
                    if (!(dt.Rows[0]["fecha_registro_re"] is DBNull))
                        this.fechaRegistroRE = Convert.ToDateTime(dt.Rows[0]["fecha_registro_re"]);
                    this.usuarioRE = dt.Rows[0]["usuario_re"].ToString();
                    this.empleadorPerdidaEmbarazo = dt.Rows[0]["id_registro_patronal_pe"].ToString();
                    if (!(dt.Rows[0]["fecha_registro_pe"] is DBNull))
                        this.fechaRegistroPE = Convert.ToDateTime(dt.Rows[0]["fecha_registro_pe"]);
                    this.usuarioPE = dt.Rows[0]["usuario_pe"].ToString();
                    this.empleadorNacimiento = dt.Rows[0]["RAZON_SOCIAL"].ToString();
                    if (!(dt.Rows[0]["fecha_registro_nc"] is DBNull))
                        this.fechaRegistroNC = Convert.ToDateTime(dt.Rows[0]["fecha_registro_nc"]);
                    this.usuarioNC = dt.Rows[0]["usuario_nc"].ToString();
                    this.empleadorMuerteMadre = dt.Rows[0]["id_registro_patronal_mm"].ToString();
                    if (!(dt.Rows[0]["fecha_registro_mm"] is DBNull))
                        this.fechaRegistroMM = Convert.ToDateTime(dt.Rows[0]["fecha_registro_mm"]);
                    this.usuarioMM = dt.Rows[0]["usuario_mm"].ToString();
                    this.cedula = dt.Rows[0]["no_documento"].ToString();
                    this.nombres = dt.Rows[0]["nombres"].ToString();
                    this.primerApellido = dt.Rows[0]["primer_apellido"].ToString();
                    this.segundoApellido = dt.Rows[0]["segundo_apellido"].ToString();
                    this.celular = dt.Rows[0]["celular"].ToString();
                    this.telefono = dt.Rows[0]["telefono"].ToString();
                    this.email = dt.Rows[0]["email"].ToString();
                    this.tutorActivo = new Tutor(this.idNss);
                    

                }
                else
                {
                    throw new Exception("No existe registros para este ciudadano(a)");
                }
            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;
            }
        }

        public static DataTable getMaternidad(int id_nss)
        {

            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_id_nss", OracleDbType.Decimal);
            arrParam[0].Value = id_nss;

            arrParam[1] = new OracleParameter("io_cursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;

            string cmdStri = "SFS_SUBSIDIOS_PKG.cargardatos";

            try
            {
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStri, arrParam);
                if (ds.Tables.Count > 0)
                {
                    return ds.Tables[0];
                }
                else
                {
                    throw new Exception("No hay Data");
                }

            }

            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;
            }
        }

        public override string GuardarCambios(string UsuarioResponsable)
        {
            throw new NotImplementedException();
        }
        #endregion

        #region "Metodos para menejar las novedades de cambios y bajas "
        public static string CambioReporteEmbarazo(string CedulaEmbarazada, int IdRegistroPatronal, DateTime FechaDiagnostico, DateTime FechaEstimadaParto, string Usuario)
        {
            OracleParameter[] parameters = new OracleParameter[6];

            parameters[0] = new OracleParameter("p_no_documento", CedulaEmbarazada);
            parameters[1] = new OracleParameter("p_id_registro_patronal", IdRegistroPatronal);
            parameters[2] = new OracleParameter("p_fecha_diagnostico", FechaDiagnostico);
            parameters[3] = new OracleParameter("p_fecha_posible_parto", FechaEstimadaParto);
            parameters[4] = new OracleParameter("p_id_usuario", Usuario);

            parameters[5] = new OracleParameter("p_ResultNumber", OracleDbType.NVarchar2, 200);
            parameters[5].Direction = ParameterDirection.InputOutput;

            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, "SFS_NOV_PKG.CambioReporteEmbarazo", parameters);
                return Utilitarios.Utils.sacarMensajeDeError(parameters[5].Value.ToString());
            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;
            }
        }

        public static string BajaReporteEmbarazo(string CedulaEmbarazada, int IdRegistroPatronal, string Usuario)
        {
            OracleParameter[] parameters = new OracleParameter[4];

            parameters[0] = new OracleParameter("p_no_documento", CedulaEmbarazada);
            parameters[1] = new OracleParameter("p_id_registro_patronal", IdRegistroPatronal);
            parameters[2] = new OracleParameter("p_id_usuario", Usuario);

            parameters[3] = new OracleParameter("p_ResultNumber", OracleDbType.NVarchar2, 200);
            parameters[3].Direction = ParameterDirection.InputOutput;

            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, "SFS_NOV_PKG.BajaReporteEmbarazo", parameters);
                return Utilitarios.Utils.sacarMensajeDeError(parameters[3].Value.ToString());
            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;
            }
        }

        public static string CambioReporteLicencia(string CedulaEmbarazada, int IdRegistroPatronal, DateTime FechaInicioLicencia, string Usuario)
        {
            OracleParameter[] parameters = new OracleParameter[5];

            parameters[0] = new OracleParameter("p_no_documento", CedulaEmbarazada);
            parameters[1] = new OracleParameter("p_id_registro_patronal", IdRegistroPatronal);
            parameters[2] = new OracleParameter("p_fecha_inicio_licencia", FechaInicioLicencia);
            parameters[3] = new OracleParameter("p_id_usuario", Usuario);

            parameters[4] = new OracleParameter("p_ResultNumber", OracleDbType.NVarchar2, 200);
            parameters[4].Direction = ParameterDirection.InputOutput;
            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, "SFS_NOV_PKG.CambioReporteLicencia", parameters);
                return Utilitarios.Utils.sacarMensajeDeError(parameters[4].Value.ToString());
            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;
            }
        }

        public static string BajaReporteLicencia(string CedulaEmbarazada, int IdRegistroPatronal, string Usuario)
        {
            OracleParameter[] parameters = new OracleParameter[4];

            parameters[0] = new OracleParameter("p_no_documento", CedulaEmbarazada);
            parameters[1] = new OracleParameter("p_id_registro_patronal", IdRegistroPatronal);
            parameters[2] = new OracleParameter("p_id_usuario", Usuario);

            parameters[3] = new OracleParameter("p_ResultNumber", OracleDbType.NVarchar2, 200);
            parameters[3].Direction = ParameterDirection.InputOutput;

            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, "SFS_NOV_PKG.BajaReporteLicencia", parameters);
                return Utilitarios.Utils.sacarMensajeDeError(parameters[3].Value.ToString());
            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;
            }
        }

        public static string CambioReporteNacimiento(string CedulaEmbarazada, int IdRegistroPatronal, DateTime FechaNacimiento, int SecuenciaLactante, string Usuario)
        {
            OracleParameter[] parameters = new OracleParameter[6];

            parameters[0] = new OracleParameter("p_no_documento", CedulaEmbarazada);
            parameters[1] = new OracleParameter("p_id_registro_patronal", IdRegistroPatronal);
            parameters[2] = new OracleParameter("p_fecha_nacimiento", FechaNacimiento);
            parameters[3] = new OracleParameter("P_secuencia_lactante", SecuenciaLactante);
            parameters[4] = new OracleParameter("p_id_usuario", Usuario);

            parameters[5] = new OracleParameter("p_ResultNumber", OracleDbType.NVarchar2, 200);
            parameters[5].Direction = ParameterDirection.InputOutput;
            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, "SFS_NOV_PKG.CambioReporteNacimiento", parameters);
                return Utilitarios.Utils.sacarMensajeDeError(parameters[5].Value.ToString());
            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;
            }
        }

        public static string BajaReporteNacimiento(string CedulaEmbarazada, int IdRegistroPatronal, int SecuenciaLactante, string Usuario)
        {
            OracleParameter[] parameters = new OracleParameter[5];

            parameters[0] = new OracleParameter("p_no_documento", CedulaEmbarazada);
            parameters[1] = new OracleParameter("p_id_registro_patronal", IdRegistroPatronal);
            parameters[2] = new OracleParameter("p_id_usuario", Usuario);
            parameters[3] = new OracleParameter("p_secuencia_lactante", SecuenciaLactante);

            parameters[4] = new OracleParameter("p_ResultNumber", OracleDbType.NVarchar2, 200);
            parameters[4].Direction = ParameterDirection.InputOutput;

            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, "SFS_NOV_PKG.BajaReporteNacimiento", parameters);
                return Utilitarios.Utils.sacarMensajeDeError(parameters[4].Value.ToString());
            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;
            }
        }

        public static string CambioPerdidaEmbarazo(string CedulaEmbarazada, int IdRegistroPatronal, DateTime FechaPerdida, string Usuario)
        {
            OracleParameter[] parameters = new OracleParameter[5];

            parameters[0] = new OracleParameter("p_no_documento", CedulaEmbarazada);
            parameters[1] = new OracleParameter("p_id_registro_patronal", IdRegistroPatronal);
            parameters[2] = new OracleParameter("P_fecha_perdida", FechaPerdida);
            parameters[3] = new OracleParameter("p_id_usuario", Usuario);

            parameters[4] = new OracleParameter("p_ResultNumber", OracleDbType.NVarchar2, 200);
            parameters[4].Direction = ParameterDirection.InputOutput;

            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, "SFS_NOV_PKG.CambioPerdidaEmbarazo", parameters);
                return Utilitarios.Utils.sacarMensajeDeError(parameters[4].Value.ToString());
            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;
            }
        }

        public static string BajaPerdidaEmbarazo(string CedulaEmbarazada, int IdRegistroPatronal, string Usuario)
        {
            OracleParameter[] parameters = new OracleParameter[4];

            parameters[0] = new OracleParameter("p_no_documento", CedulaEmbarazada);
            parameters[1] = new OracleParameter("p_id_registro_patronal", IdRegistroPatronal);
            parameters[2] = new OracleParameter("p_id_usuario", Usuario);


            parameters[3] = new OracleParameter("p_ResultNumber", OracleDbType.NVarchar2, 200);
            parameters[3].Direction = ParameterDirection.InputOutput;

            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, "SFS_NOV_PKG.BajaPerdidaEmbarazo", parameters);
                return Utilitarios.Utils.sacarMensajeDeError(parameters[3].Value.ToString());
            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;
            }
        }

        public static string CambioReporteMuerteLactante(string CedulaEmbarazada, int IdRegistroPatronal, int SecuenciaLactante, DateTime FechaDefuncionLactante, string Usuario)
        {
            OracleParameter[] parameters = new OracleParameter[6];

            parameters[0] = new OracleParameter("p_no_documento", CedulaEmbarazada);
            parameters[1] = new OracleParameter("p_id_registro_patronal", IdRegistroPatronal);
            parameters[2] = new OracleParameter("p_secuencia_lactante", SecuenciaLactante);
            parameters[3] = new OracleParameter("p_fecha_defuncion", FechaDefuncionLactante);
            parameters[4] = new OracleParameter("p_id_usuario", Usuario);

            parameters[5] = new OracleParameter("p_ResultNumber", OracleDbType.NVarchar2, 200);
            parameters[5].Direction = ParameterDirection.InputOutput;
            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, "SFS_NOV_PKG.CambioMuerteLactante", parameters);
                return Utilitarios.Utils.sacarMensajeDeError(parameters[5].Value.ToString());
            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;
            }
        }

        public static string BajaReporteMuerteLactante(string CedulaEmbarazada, int IdRegistroPatronal, int SecuenciaLactante, string Usuario)
        {
            OracleParameter[] parameters = new OracleParameter[5];

            parameters[0] = new OracleParameter("p_no_documento", CedulaEmbarazada);
            parameters[1] = new OracleParameter("p_id_registro_patronal", IdRegistroPatronal);
            parameters[2] = new OracleParameter("p_id_usuario", Usuario);
            parameters[3] = new OracleParameter("p_secuencia_lactante", SecuenciaLactante);

            parameters[4] = new OracleParameter("p_ResultNumber", OracleDbType.NVarchar2, 200);
            parameters[4].Direction = ParameterDirection.InputOutput;

            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, "SFS_NOV_PKG.BajaMuerteLactante", parameters);
                return Utilitarios.Utils.sacarMensajeDeError(parameters[4].Value.ToString());
            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;
            }
        }

        public static string CambioReporteMuerteMadre(string CedulaEmbarazada, int IdRegistroPatronal, DateTime FechaDefuncion, string Usuario)
        {
            OracleParameter[] parameters = new OracleParameter[5];

            parameters[0] = new OracleParameter("p_no_documento", CedulaEmbarazada);
            parameters[1] = new OracleParameter("p_id_registro_patronal", IdRegistroPatronal);
            parameters[2] = new OracleParameter("p_fecha_inicio", FechaDefuncion);
            parameters[3] = new OracleParameter("p_id_usuario", Usuario);

            parameters[4] = new OracleParameter("p_ResultNumber", OracleDbType.NVarchar2, 200);
            parameters[4].Direction = ParameterDirection.InputOutput;
            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, "SFS_NOV_PKG.CambioMuerteMadre", parameters);
                return Utilitarios.Utils.sacarMensajeDeError(parameters[4].Value.ToString());
            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;
            }
        }

        public static string BajaReporteMuerteMadre(string CedulaEmbarazada, int IdRegistroPatronal, string Usuario)
        {
            OracleParameter[] parameters = new OracleParameter[4];

            parameters[0] = new OracleParameter("p_no_documento", CedulaEmbarazada);
            parameters[1] = new OracleParameter("p_id_registro_patronal", IdRegistroPatronal);
            parameters[2] = new OracleParameter("p_id_usuario", Usuario);

            parameters[3] = new OracleParameter("p_ResultNumber", OracleDbType.NVarchar2, 200);
            parameters[3].Direction = ParameterDirection.InputOutput;

            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, "SFS_NOV_PKG.BajaMuerteMadre", parameters);
                return Utilitarios.Utils.sacarMensajeDeError(parameters[3].Value.ToString());
            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;
            }
        }
        #endregion

        #region "Metodos para manejar la lactacia y maternidad extraordinaria."
        
        /// <summary>
        ///  Registro Maternidad Extraordinaria
        /// </summary>
        /// <param name="tipo_noveda">tipo de novedad que desea hacer.</param>
        /// <param name="CedulaEmbarazada">Cédula de la embarazada.</param>
        /// <param name="IdRegistroPatronal">Registro patronal del empleador que está registrando el embarazo.</param>
        /// <param name="FechaDiagnostico">Fecha en que el parámetro fué diagnosticado.</param>
        /// <param name="FechaEstimadaParto">Fecha aproximada del parto.</param>
        /// <param name="Usuario">Usuario que ejecutó este movimiento.</param>
        /// <param name="fecha_licencia">Fecha de la licencia</param>
        /// <param name="destinatario">destinatario a quien se le va a pagar MADRE, EMPRESA, TUTOR</param>
        /// <param name="tipo_cuenta">Tipo de cuenta donde se va a realizar el pago Cuenta Banco, Cuenta Corriente</param>
        /// <param name="nro_cuenta">Cuenta bancaria donde se depositarán los fondos del subsidio por embarazo</param>
        /// <param name="entidad_recaudadora">Banco donde está la cuenta donde se depositarán los fondos del subsidio por embarazo.</param>
        /// <param name="nro_solicutud">Nro de la solicitud que es retornado desde el procedimiento</param>
        /// <returns></returns>
        public static string ReporteMaternidadExtraordinaria(string tipo_noveda, string CedulaEmbarazada, int IdRegistroPatronal, DateTime FechaDiagnostico, DateTime FechaEstimadaParto,
                                                             string CedulaTutor, string Telefono, string Celular, string Email, string Usuario, DateTime? fecha_licencia,
                                                             string destinatario, string tipo_cuenta, string nro_cuenta, int entidad_recaudadora, out string nro_solicutud)
        {
            OracleParameter[] parameters = new OracleParameter[17];

            parameters[0] = new OracleParameter("p_tipo_novedad", tipo_noveda);
            parameters[1] = new OracleParameter("p_no_documento", CedulaEmbarazada);
            parameters[2] = new OracleParameter("p_id_registro_patronal", IdRegistroPatronal);
            parameters[3] = new OracleParameter("p_fecha_diagnostico", FechaDiagnostico);
            parameters[4] = new OracleParameter("p_fecha_posible_parto", FechaEstimadaParto);
            parameters[5] = new OracleParameter("p_no_documento_tutor", CedulaTutor);
            parameters[6] = new OracleParameter("p_telefono", Telefono);
            parameters[7] = new OracleParameter("p_celular", Celular);
            parameters[8] = new OracleParameter("p_email", Email);
            parameters[9] = new OracleParameter("p_id_usuario", Usuario);
            parameters[10] = new OracleParameter("p_fecha_inicio_licencia", fecha_licencia);
            parameters[11] = new OracleParameter("p_destinatario", destinatario);
            parameters[12] = new OracleParameter("p_tipo_cuenta", tipo_cuenta);
            parameters[13] = new OracleParameter("p_nro_cuenta", nro_cuenta);
            parameters[14] = new OracleParameter("p_id_entidad_recaudadora", entidad_recaudadora);

            parameters[15] = new OracleParameter("p_nro_solicitud", OracleDbType.NVarchar2, 200);
            parameters[15].Direction = ParameterDirection.Output;

            parameters[16] = new OracleParameter("p_ResultNumber", OracleDbType.NVarchar2, 200);
            parameters[16].Direction = ParameterDirection.InputOutput;

            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, "SFS_NOV_PKG.ReporteMaternidadExt", parameters);
                nro_solicutud = parameters[15].Value.ToString();

                return Utilitarios.Utils.sacarMensajeDeError(parameters[16].Value.ToString());
            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;
            }
        }
        /// <summary>
        /// Registro de Lactancia Extraordinaria
        /// </summary>
        /// <param name="CedulaEmbarazada">Cédula de la embarazada</param>
        /// <param name="FechaNacimiento">Fecha de nacimiento del lactante</param>
        /// <param name="IdNSSLactante">Nss del lactante</param>
        /// <param name="Nombres">Nombres del lactante</param>
        /// <param name="PrimerApellido">Primer apellido del lactante</param>
        /// <param name="SegundoApellido">Segundo apellido del lactante</param>
        /// <param name="Sexo">Sexo del lactante</param>
        /// <param name="NUI">Numero unico de identidad del lactante</param>
        /// <param name="Usuario">Usuario que registra el nacimiento del lactante</param>
        /// <param name="CantidadLactantes">Cantidad de Lactantes que tiene la madre.</param>
        /// <param name="nro_solicitud">Nro de la solicitud que es retornado desde el procedimiento</param>
        /// <returns></returns>
        public static string ReporteLactanciaExtraordinaria(string CedulaEmbarazada, string RegistroPatronal, DateTime FechaNacimiento, int? IdNSSLactante, string Nombres, string PrimerApellido, 
                                                            string SegundoApellido, string Sexo, string NUI, string Usuario, int CantidadLactantes, ref string solicitud)
        {
            OracleParameter[] parameters = new OracleParameter[12];

            parameters[0] = new OracleParameter("p_no_documento", CedulaEmbarazada);
            parameters[1] = new OracleParameter("p_id_registro_patronal", RegistroPatronal);
            parameters[2] = new OracleParameter("p_fecha_nacimiento", FechaNacimiento);
            parameters[3] = new OracleParameter("p_nombres", Nombres);
            parameters[4] = new OracleParameter("p_primer_apellido", PrimerApellido);
            parameters[5] = new OracleParameter("p_segundo_apellido", SegundoApellido);
            parameters[6] = new OracleParameter("p_sexo", Sexo);
            parameters[7] = new OracleParameter("P_id_nss_lactante", IdNSSLactante);
            parameters[8] = new OracleParameter("P_cantidad_lactantes", CantidadLactantes);
            parameters[9] = new OracleParameter("p_id_usuario", Usuario);
            
            parameters[10] = new OracleParameter("p_nro_solicitud", OracleDbType.Int32, 200);
            parameters[10].Direction = ParameterDirection.InputOutput;
            if (solicitud.Equals(string.Empty))
            {
                parameters[10].Value = DBNull.Value;
            }
            else
            {
                parameters[10].Value = solicitud;
            }

            parameters[11] = new OracleParameter("p_ResultNumber", OracleDbType.NVarchar2, 200);
            parameters[11].Direction = ParameterDirection.InputOutput;

            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, "SFS_NOV_PKG.ReporteLactanciaExt", parameters);
                solicitud = parameters[10].Value.ToString();
                return Utilitarios.Utils.sacarMensajeDeError(parameters[11].Value.ToString());
            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;
            }
        }
        /// <summary>
        ///  Metodo para darle de baja al subsidio de lactancia extraordinario.
        /// </summary>
        /// <param name="nro_docuemtno">cedula de la afiliada.</param>
        /// <param name="IdRegistroPatronal">Registro Patronal del empleador.</param>
        /// <param name="Usuario">usuario que le dara de baja.</param>
        /// <param name="NroSolicitud">Nro de la solicutud que desea dar de baja.</param>
        /// <returns></returns>
        public static string BajaRepLactanciaExtraordinario(string nro_docuemtno, int IdRegistroPatronal, string Usuario, string NroSolicitud)
        {
            OracleParameter[] parameters = new OracleParameter[5];

            parameters[0] = new OracleParameter("p_no_documento", nro_docuemtno);
            parameters[1] = new OracleParameter("p_id_registro_patronal", IdRegistroPatronal);
            parameters[2] = new OracleParameter("p_id_usuario", Usuario);
            parameters[3] = new OracleParameter("p_nro_solicitud", NroSolicitud);
            parameters[4] = new OracleParameter("p_ResultNumber", OracleDbType.NVarchar2, 200);
            parameters[4].Direction = ParameterDirection.InputOutput;

            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, "SFS_NOV_PKG.BajaRepLactanciaExt", parameters);
                return Utilitarios.Utils.sacarMensajeDeError(parameters[4].Value.ToString());
            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;
            }
        }
        /// <summary>
        /// Metodo para darle de baja al Subsidio Extraordinario de Maternidad.
        /// </summary>
        /// <param name="nro_docuemtno">cedula de la afiliada.</param>
        /// <param name="IdRegistroPatronal">registro patronal del empleador.</param>
        /// <param name="Usuario">usuario quien realizo la baja.</param>
        /// <param name="NroSolicitud">Numero de solicitud que se le va a dar de baja.</param>
        /// <returns></returns>
        public static string BajaRepMaternidadExtraordinaria(string nro_documento, int IdRegistroPatronal, string Usuario, string NroSolicitud)
        {
            OracleParameter[] parameters = new OracleParameter[5];

            parameters[0] = new OracleParameter("p_no_documento", nro_documento);
            parameters[1] = new OracleParameter("p_id_registro_patronal", IdRegistroPatronal);
            parameters[2] = new OracleParameter("p_id_usuario", Usuario);
            parameters[3] = new OracleParameter("p_nro_solicitud", NroSolicitud);
            parameters[4] = new OracleParameter("p_ResultNumber", OracleDbType.NVarchar2, 200);
            parameters[4].Direction = ParameterDirection.InputOutput;

            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, "SFS_NOV_PKG.BajaRepMaternidadExt", parameters);
                return Utilitarios.Utils.sacarMensajeDeError(parameters[4].Value.ToString());
            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;
            }
        }
        /// <summary>
        /// Metodo para obtener los Subsidios Extraordinarios
        /// </summary>
        /// <param name="desde">fecha desde cuando desea ver el reporte</param>
        /// <param name="hasta">fecha hasta cuando desea ver el reporte</param>
        /// <param name="tipoSubsidio">El Tipo de Subsidio(Maternidad o Lactancia) que desea ver el reporte</param>
        /// <param name="registroPatronal">Registro Patronal</param>
        /// <param name="message"></param>
        /// <returns></returns>
        public static DataTable GetSubsidiosExtraordinarios(string desde, string hasta, string tipoSubsidio, string registroPatronal, out string message, Int16 pageNum, Int16 pageSize )
        {
            OracleParameter[] parameters = new OracleParameter[8];

            parameters[0] = new OracleParameter("p_desde", OracleDbType.Date);
            if (desde.Equals(string.Empty))
            {
                parameters[0].Value = DBNull.Value;
            }
            else
            {
                parameters[0].Value = Convert.ToDateTime(desde);
            }

            parameters[1] = new OracleParameter("p_hasta", OracleDbType.Date);
            if (hasta.Equals(string.Empty))
            {
                parameters[1].Value = DBNull.Value;
            }
            else
            {
                parameters[1].Value = Convert.ToDateTime(hasta);
            }

            parameters[2] = new OracleParameter("p_tipo_subsidio", OracleDbType.Varchar2);
            if (tipoSubsidio.Equals(string.Empty))
            {
                parameters[2].Value = DBNull.Value;
            }
            else
            {
                parameters[2].Value = tipoSubsidio;
            }

            parameters[3] = new OracleParameter("p_ID_REGISTRO_PATRONAL", OracleDbType.Int32);
            if (registroPatronal.Equals(string.Empty))
            {
                parameters[3].Value = DBNull.Value;
            }
            else
            {
                parameters[3].Value = registroPatronal;
            }

            parameters[4] = new OracleParameter("p_pagenum", OracleDbType.Int16);
            parameters[4].Value = pageNum;

            parameters[5] = new OracleParameter("p_pagesize", OracleDbType.Int16);
            parameters[5].Value = pageSize;

            parameters[6] = new OracleParameter("p_resultnumber", OracleDbType.Varchar2, 200);
            parameters[6].Direction = ParameterDirection.Output;

            parameters[7] = new OracleParameter("p_io_cursor", OracleDbType.RefCursor);
            parameters[7].Direction = ParameterDirection.Output;


            string cmdStr = "SFS_NOV_PKG.getSubsidiosExtraordinarios";
            try
            {
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, parameters);
                message = parameters[6].Value.ToString();
                if (ds.Tables.Count > 0)
                {
                    return ds.Tables[0];
                }
                else
                {
                    return null;
                }
            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                message = ex.Message;
                return null;
            }
        }

        public static string RegistroEmbarazoLactanciaExt(string CedulaEmbarazada, DateTime FechaDiagnostico, DateTime FechaEstimadaParto, string CedulaTutor, string Telefono, string Celular, string Email, string Usuario)
        {
            OracleParameter[] parameters = new OracleParameter[9];

            parameters[0] = new OracleParameter("p_no_documento", CedulaEmbarazada);
            parameters[1] = new OracleParameter("p_fecha_diagnostico", FechaDiagnostico);
            parameters[2] = new OracleParameter("p_fecha_estimada_parto", FechaEstimadaParto);
            parameters[3] = new OracleParameter("p_no_documento_tutor", CedulaTutor);
            parameters[4] = new OracleParameter("p_telefono", Telefono);
            parameters[5] = new OracleParameter("p_celular", Celular);
            parameters[6] = new OracleParameter("p_email", Email);
            parameters[7] = new OracleParameter("p_id_usuario", Usuario);

            parameters[8] = new OracleParameter("p_ResultNumber", OracleDbType.NVarchar2, 200);
            parameters[8].Direction = ParameterDirection.InputOutput;

            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, "SFS_NOV_PKG.ReporteEmbarazoLactanciaExt", parameters);
                return Utilitarios.Utils.sacarMensajeDeError(parameters[8].Value.ToString());
            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;
            }
        }
        #endregion


    }
}
