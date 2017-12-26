using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using Oracle.ManagedDataAccess.Client;
using Microsoft.VisualBasic;

namespace SuirPlus.Empresas.SubsidiosSFS
{
    public class EnfermedadComun : FrameWork.Objetos
    {

        #region "Propiedades"

        private int idNss;
        public int IdNss
        {
            get { return idNss; }
            set { idNss = value; }
        }
       
        private int idPadecimiento;
        public int IdPadecimiento
        {
            get { return idPadecimiento; }
            set { idPadecimiento = value; }
        }

        private int secuencia;
        public int Secuencia
        {
            get { return secuencia; }
            set { secuencia = value; }
        }

        private string status;
        public string Status
        {
            get { return status; }
            set { status = value; }
        }

        private string direccion;
        public string Direccion
        {
            get { return direccion; }
            set { direccion = value; }
        }

        private string telefonoTrab;
        public string TelefonoTrab
        {
            get { return telefonoTrab; }
            set { telefonoTrab = value; }
        }

        private string emailTrab;
        public string EmailTrab
        {
            get { return emailTrab; }
            set { emailTrab = value; }
        }

        private string celularTrab;
        public string CelularTrab
        {
            get { return celularTrab; }
            set { celularTrab = value; }
        }

        private int idPssMedico;
        public int IdPssMedico
        {
            get { return idPssMedico; }
            set { idPssMedico = value; }
        }

        private string noDocumentoMedico;
        public string NoDocumentoMedico
        {
            get { return noDocumentoMedico; }
            set { noDocumentoMedico = value; }
        }

        private string nombreMedico;
        public string NombreMedico
        {
            get { return nombreMedico; }
            set { nombreMedico = value; }
        }

        private string direccionMedico;
        public string DireccionMedico
        {
            get { return direccionMedico; }
            set { direccionMedico = value; }
        }

        private string telefonoMedico;
        public string TelefonoMedico
        {
            get { return telefonoMedico; }
            set { telefonoMedico = value; }
        }

        private string emailMedico;
        public string EmailMedico
        {
            get { return emailMedico; }
            set { emailMedico = value; }
        }

        private string celularMedico;
        public string CelularMedico
        {
            get { return celularMedico; }
            set { celularMedico = value; }
        }

        private int idPssCentro;
        public int IdPssCentro
        {
            get { return idPssCentro; }
            set { idPssCentro = value; }
        }

        private string nombreCentro;
        public string NombreCentro
        {
            get { return nombreCentro; }
            set { nombreCentro = value; }
        }

        private string direccionCentro;
        public string DireccionCentro
        {
            get { return direccionCentro; }
            set { direccionCentro = value; }
        }

        private string telefonoCentro;
        public string TelefonoCentro
        {
            get { return telefonoCentro; }
            set { telefonoCentro = value; }
        }

        private string faxCentro;
        public string FaxCentro
        {
            get { return faxCentro; }
            set { faxCentro = value; }
        }

        private string emailCentro;
        public string EmailCentro
        {
            get { return emailCentro; }
            set { emailCentro = value; }
        }

        private string tipoDiscapacidad;
        public string TipoDiscapacidad
        {
            get { return tipoDiscapacidad; }
            set { tipoDiscapacidad = value; }
        }

        private string diagnostico;
        public string Diagnostico
        {
            get { return diagnostico;  }
            set { diagnostico = value; }
        }

        private string signoSintomas;
        public string SignoSintomas
        {
            get { return signoSintomas; }
            set { signoSintomas = value; }
        }

        private string procedimientos;
        public string Procedimientos
        {
            get { return procedimientos; }
            set { procedimientos = value; }
        }

        private string ambulatorio;
        public string Ambulatorio
        {
            get { return ambulatorio; }
            set { ambulatorio = value; }
        }

        private DateTime fechaInicioAmb;
        public DateTime FechaInicioAmb
        {
            get { return fechaInicioAmb; }
            set { fechaInicioAmb = value; }
        }

        private int diasCalendarioAmb;
        public int DiasCalendarioAmb
        {
            get { return diasCalendarioAmb; }
            set { diasCalendarioAmb = value; }
        }

        private string hospitalizacion;
        public string Hospitalizacion
        {
            get { return hospitalizacion; }
            set { hospitalizacion = value; }
        }

        private DateTime fechaInicioHos;
        public DateTime FechaInicioHos
        {
            get { return fechaInicioHos; }
            set { fechaInicioAmb = value; }
        }

        private int diasCalendarioHos;
        public int DiasCalendarioHos
        {
            get { return diasCalendarioHos; }
            set { diasCalendarioHos = value; }
        }

        private DateTime fechaDiagnostico;
        public DateTime FechaDiagnostico
        {
            get { return fechaDiagnostico; }
            set { fechaDiagnostico = value; }
        }

        private DateTime fechaRegistro;
        public DateTime FechaRegistro
        {
            get { return fechaRegistro; }
            set { fechaRegistro = value; }
        }

        private string usuarioRegistro;
        public string UsuarioRegistro
        {
            get { return usuarioRegistro; }
            set { usuarioRegistro = value; }
        }

        private int idRegistroPatronal;
        public int IdRegistroPatronal
        {
            get { return idRegistroPatronal; }
            set { idRegistroPatronal = value; }
        }

        private int pin;
        public int Pin
        {
            get { return pin; }
            set { pin = value; }
        }

        private string ultUsuarioAct;
        public string UltUsuarioAct
        {
            get { return ultUsuarioAct; }
            set { ultUsuarioAct = value; }
        }

        private DateTime ultFechaAct;
        public DateTime UltFechaAct
        {
            get { return ultFechaAct; }
            set { ultFechaAct = value; }
        }

        # endregion

        public static void ValidarRegEnfermedadComun(String NroDocumento, Int32 RegistroPatronal, ref string resultNumber, ref DataTable enfCursor)
        {
         
            OracleParameter[] parameters = new OracleParameter[4];
            
            parameters[0] = new OracleParameter("NroDocumento",OracleDbType.Varchar2);
            parameters[0].Value = NroDocumento;
            parameters[1] = new OracleParameter("RegistrosPatronal", OracleDbType.Int32);
            parameters[1].Value = RegistroPatronal;
            parameters[2] = new OracleParameter("p_io_cursor", OracleDbType.RefCursor);
            parameters[2].Direction = ParameterDirection.Output;
            parameters[3] = new OracleParameter("ResultNumber", OracleDbType.NVarchar2, 200);
            parameters[3].Direction = ParameterDirection.Output;

            String cmdStr = "SFS_NOV_PKG.ValidarRegEnfermedadComun";

            try
            {
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, parameters);
                resultNumber = Utilitarios.Utils.sacarMensajeDeError(parameters[3].Value.ToString());

                if (ds.Tables.Count > 0)
                {
                    enfCursor = ds.Tables[0];
                }
            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                resultNumber = ex.Message;
            }

        }
        public static DataTable PadecimientosRegistrados(int NSS, ref string direccion, ref string telefono, ref string celular, ref string correo)
        {
            OracleParameter[] arrParam = new OracleParameter[7];

            arrParam[0] = new OracleParameter("p_id_nss", OracleDbType.Decimal);
            arrParam[0].Value = NSS;
            arrParam[1] = new OracleParameter("p_direccion", OracleDbType.NVarchar2, 200);
            arrParam[1].Direction = ParameterDirection.Output;
            arrParam[2] = new OracleParameter("p_telefono", OracleDbType.NVarchar2, 10);
            arrParam[2].Direction = ParameterDirection.Output;
            arrParam[3] = new OracleParameter("p_correo", OracleDbType.NVarchar2, 200);
            arrParam[3].Direction = ParameterDirection.Output;
            arrParam[4] = new OracleParameter("p_celular", OracleDbType.NVarchar2, 10);
            arrParam[4].Direction = ParameterDirection.Output;
            arrParam[5] = new OracleParameter("p_cursor", OracleDbType.RefCursor);
            arrParam[5].Direction = ParameterDirection.Output;
            arrParam[6] = new OracleParameter("p_result", OracleDbType.NVarchar2, 200);
            arrParam[6].Direction = ParameterDirection.Output;

            string cmdStri = "SFS_NOV_PKG.getPadecimientos";

            try
            {
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStri, arrParam);
                if (ds.Tables.Count > 0)
                {
                    direccion = arrParam[1].Value.ToString();
                    telefono = arrParam[2].Value.ToString();
                    correo = arrParam[3].Value.ToString();
                    celular = arrParam[4].Value.ToString();

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
                throw ex;
            }
              
        }

        public static string CambiarDatosIniciales(string nroSolicitud, string direccion, string telefono, string correo, string celular, string usuario)
        {
            OracleParameter[] arrParam = new OracleParameter[7];
            string resultado = string.Empty;

            arrParam[0] = new OracleParameter("p_nro_solicitud", OracleDbType.NVarchar2, 20);
            arrParam[0].Value = nroSolicitud;
            arrParam[1] = new OracleParameter("p_direccion", OracleDbType.NVarchar2, 200);
            arrParam[1].Value = direccion;
            arrParam[2] = new OracleParameter("p_telefono", OracleDbType.NVarchar2, 10);
            arrParam[2].Value = telefono;
            arrParam[3] = new OracleParameter("p_correo", OracleDbType.NVarchar2, 200);
            arrParam[3].Value = correo;
            arrParam[4] = new OracleParameter("p_celular", OracleDbType.NVarchar2, 10);
            arrParam[4].Value = celular;
            arrParam[5] = new OracleParameter("p_usuario_act", OracleDbType.NVarchar2, 35);
            arrParam[5].Value = usuario;
            arrParam[6] = new OracleParameter("p_result", OracleDbType.NVarchar2, 200);
            arrParam[6].Direction = ParameterDirection.Output;

            string cmdStri = "SFS_NOV_PKG.ActDatosInicialesEnf";

            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStri, arrParam);

                resultado = Utilitarios.Utils.sacarMensajeDeError(arrParam[6].Value.ToString());
            }
            catch (Exception ex)
            {
                resultado = ex.Message;
            }

            return resultado;
              
        }
       
        public static void RegistrarDatosIniciales(int NSS, string tipoSolicitud, string numeroSolicitud, string direccion, string telefono, string correo, string celular, string usuario, ref string resultado, ref string nroSolicitud, ref string pin)
        {
            OracleParameter[] arrParam = new OracleParameter[10];

            arrParam[0] = new OracleParameter("p_id_nss", OracleDbType.Decimal);
            arrParam[0].Value = NSS;
            arrParam[1] = new OracleParameter("p_tipo_solicitud", OracleDbType.NVarchar2, 20);
            arrParam[1].Value = tipoSolicitud;
            arrParam[2] = new OracleParameter("p_direccion", OracleDbType.NVarchar2, 200);
            arrParam[2].Value = direccion;
            arrParam[3] = new OracleParameter("p_telefono", OracleDbType.NVarchar2, 10);
            arrParam[3].Value = telefono;
            arrParam[4] = new OracleParameter("p_correo", OracleDbType.NVarchar2, 200);
            arrParam[4].Value = correo;
            arrParam[5] = new OracleParameter("p_celular", OracleDbType.NVarchar2, 10);
            arrParam[5].Value = celular;
            arrParam[6] = new OracleParameter("p_usuario_registro", OracleDbType.NVarchar2, 35);
            arrParam[6].Value = usuario;
            arrParam[7] = new OracleParameter("p_pin", OracleDbType.NVarchar2, 4);
            arrParam[7].Direction = ParameterDirection.Output;
            arrParam[8] = new OracleParameter("p_nro_solicitud", OracleDbType.NVarchar2, 18);
            arrParam[8].Direction = ParameterDirection.InputOutput;
            
            if (!numeroSolicitud.Equals(string.Empty))
            {
                arrParam[8].Value = numeroSolicitud;
            }
            
            arrParam[9] = new OracleParameter("p_result", OracleDbType.NVarchar2, 200);
            arrParam[9].Direction = ParameterDirection.Output;
            

            string cmdStri = "SFS_NOV_PKG.RegistrarDatosInicialesEnf";

            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStri, arrParam);

                resultado = Utilitarios.Utils.sacarMensajeDeError(arrParam[9].Value.ToString());
                nroSolicitud = arrParam[8].Value.ToString();
                pin = arrParam[7].Value.ToString();
            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;
            }
              
        }
     
        public static DataTable getEnfermedad(int id_nss)
        {

            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_id_nss", OracleDbType.Decimal);
            arrParam[0].Value = id_nss;

            arrParam[1] = new OracleParameter("io_cursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;

            string cmdStri = "SFS_SUBSIDIOS_PKG.CargarEnfermedadComun";

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
        public static DataTable getPadecimiento(string nroSolicitud)
        {

            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_Nro_Solicitud", OracleDbType.NVarchar2);
            arrParam[0].Value = nroSolicitud;

            arrParam[1] = new OracleParameter("io_cursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;

            string cmdStri = "SFS_NOV_PKG.getPadecimiento";

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
        public override void CargarDatos()
        {

            DataTable dt = getEnfermedad(this.idNss);
            try
            {
                if (dt.Rows.Count > 0)
                {
                    this.idNss = Convert.ToInt32(dt.Rows[0]["id_NSS"]);
                    this.idPadecimiento = Convert.ToInt32(dt.Rows[0]["padecimiento"]);
                    this.secuencia = Convert.ToInt32(dt.Rows[0]["secuencia"]);
                    this.status = dt.Rows[0]["status"].ToString();
                    this.direccion = dt.Rows[0]["direccion"].ToString();
                    this.telefonoTrab = dt.Rows[0]["telefono"].ToString();
                    this.emailTrab = dt.Rows[0]["email"].ToString();    
                    this.celularTrab = dt.Rows[0]["celular"].ToString();
                    this.idPssMedico = Convert.ToInt32(dt.Rows[0]["id_pss_med"]);
                    this.noDocumentoMedico = dt.Rows[0]["no_documento_med"].ToString();
                    this.nombreMedico = dt.Rows[0]["nombre_med"].ToString();
                    this.direccionMedico = dt.Rows[0]["direccion_med"].ToString();
                    this.telefonoMedico = dt.Rows[0]["telefono_med"].ToString();
                    this.emailMedico = dt.Rows[0]["email_med"].ToString();
                    this.idPssCentro = Convert.ToInt32(dt.Rows[0]["id_pss_cen"]);
                    this.nombreCentro = dt.Rows[0]["nombre_cen"].ToString();
                    this.direccionCentro = dt.Rows[0]["direccion_cen"].ToString();
                    this.telefonoCentro = dt.Rows[0]["telefono_cen"].ToString();
                    this.faxCentro = dt.Rows[0]["fax_cen"].ToString();
                    this.emailCentro = dt.Rows[0]["email_cen"].ToString();
                    this.tipoDiscapacidad = dt.Rows[0]["tipo_discapacidad"].ToString();
                    this.diagnostico = dt.Rows[0]["diagnostico"].ToString();
                    this.signoSintomas = dt.Rows[0]["signo_sintomas"].ToString();
                    this.procedimientos = dt.Rows[0]["procedimientos"].ToString();
                    this.ambulatorio = dt.Rows[0]["ambulatorio"].ToString();
                    if (!(dt.Rows[0]["fechaInicioAmb"] is DBNull))
                        this.fechaInicioAmb = Convert.ToDateTime(dt.Rows[0]["fechaInicioAmb"]);
                    this.diasCalendarioAmb = Convert.ToInt32(dt.Rows[0]["dias_cal_amb"]);
                    this.hospitalizacion = dt.Rows[0]["hospitalizacion"].ToString();
                    if (!(dt.Rows[0]["fecha_inicio_hos"] is DBNull))
                        this.fechaInicioHos = Convert.ToDateTime(dt.Rows[0]["fecha_inicio_hos"]);
                    this.diasCalendarioHos = Convert.ToInt32(dt.Rows[0]["dias_cal_hos"]);
                    if (!(dt.Rows[0]["fecha_diagnostico"] is DBNull))
                        this.fechaDiagnostico = Convert.ToDateTime(dt.Rows[0]["fecha_diagnostico"]);
                    if (!(dt.Rows[0]["fecha_registro"] is DBNull))
                        this.fechaRegistro = Convert.ToDateTime(dt.Rows[0]["fecha_registro"]);
                    this.usuarioRegistro = dt.Rows[0]["usuario_registro"].ToString();
                    this.idRegistroPatronal = Convert.ToInt32(dt.Rows[0]["id_registro_patronal"]);
                    this.pin = Convert.ToInt32(dt.Rows[0]["pin"]);
                    this.ultUsuarioAct = dt.Rows[0]["ult_usuario_act"].ToString();
                    if (!(dt.Rows[0]["ult_fecha_act"] is DBNull))
                        this.UltFechaAct = Convert.ToDateTime(dt.Rows[0]["ult_fecha_act"]);
                    if (!(dt.Rows[0]["id_registro_patronal"] is DBNull))
                        this.idRegistroPatronal = Convert.ToInt32(dt.Rows[0]["id_registro_patronal"]);
                    if (!(dt.Rows[0]["ult_fecha_act"] is DBNull))
                        this.ultFechaAct = Convert.ToDateTime(dt.Rows[0]["ult_fecha_act"]);
                    this.ultUsuarioAct = dt.Rows[0]["ult_usuario_act"].ToString();
                
                   }
                else
                {
                    throw new Exception("No existe registros para este Trabajador(a)");
                }
            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;
            }
        }


        public static DataTable getPss(string p_razon)
        {

            //TODO verificar lo que se va hacer con el parametro p_resultnumber.
            //string strCmd = "SFS_SUBSIDIOS_PKG.getPss";
            string strCmd = "SUB_SFS_SUBSIDIOS.getPss";

            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_razon", OracleDbType.NVarchar2, 100);
            arrParam[0].Value = p_razon;
            arrParam[1] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 1000);
            arrParam[1].Direction = ParameterDirection.Output;
            arrParam[2] = new OracleParameter("p_io_cursor", OracleDbType.RefCursor);
            arrParam[2].Direction = ParameterDirection.Output;
            try
            {

                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, strCmd, arrParam);
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
        public static DataTable getMedico(string P_CEDULA_MED)
        {

            //TODO verificar lo que se va hacer con el parametro p_resultnumber.

            string strCmd = "SUB_SFS_NOVEDADES.getMedico";

            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("P_CEDULA_MED", OracleDbType.NVarchar2, 11);
            arrParam[0].Value = P_CEDULA_MED;
            arrParam[1] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 1000);
            arrParam[1].Direction = ParameterDirection.Output;
            arrParam[2] = new OracleParameter("p_io_cursor", OracleDbType.RefCursor);
            arrParam[2].Direction = ParameterDirection.Output;
            try
            {

                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, strCmd, arrParam);
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

        public static bool ExisteCodigoCie10(string codigocie)
        {

            //TODO verificar lo que se va hacer con el parametro p_resultnumber.
            string strCmd = "sfs_subsidios_pkg.exitecodigocie10";

            OracleParameter[] arrParam = new OracleParameter[2];

            arrParam[0] = new OracleParameter("p_codigocie", OracleDbType.NVarchar2, 100);
            arrParam[0].Value = codigocie;
            arrParam[1] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 1000);
            arrParam[1].Direction = ParameterDirection.Output;
            
            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, strCmd, arrParam);
                if (arrParam[1].Value.ToString().Equals("0"))
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
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;
            }

        }

        public static String RegistroEnfComun(String NroFormulario, String direccion, String telefono, String email, String celular, String ult_usuario_act, String id_pss_med, 
            String no_documento_med, String nombre_med, String direccion_med, String telefono_med, String celular_med, 
            String email_med, int id_pss_cen, String nombre_cen, String direccion_cen, String telefono_cen, String fax_cen, 
            String email_cen, String tipo_discapacidad, String diagnostico, String signos_sintomas, String procedimientos, 
            String ambulatorio, DateTime? fecha_inicio_amb, int dias_cal_amb, String hospitalizacion, DateTime? fecha_inicio_hos, 
            int dias_cal_hos, DateTime fecha_diagnostico, int id_registro_patronal, int pin, String usuario_registro,
            String codigocie10, String exequatur, int Id_Nomina,ref String id_movimiento,ref String id_linea)
        {
            OracleParameter[] parameters = new OracleParameter[38];
           
            parameters[0] = new OracleParameter("p_Nro_Solicitud", OracleDbType.NVarchar2,18);
            parameters[0].Direction = ParameterDirection.InputOutput;
            parameters[0].Value = NroFormulario;
            parameters[1] = new OracleParameter("p_Direccion", OracleDbType.NVarchar2, 200);
            parameters[1].Value = direccion;
            parameters[2] = new OracleParameter("p_Telefono", OracleDbType.NVarchar2,10);
            parameters[2].Value = telefono;
            parameters[3] = new OracleParameter("p_Email", OracleDbType.NVarchar2,200);
            parameters[3].Value = email;
            parameters[4] = new OracleParameter("p_Celular", OracleDbType.NVarchar2, 10);
            parameters[4].Value = celular;
            parameters[5] = new OracleParameter("p_ult_usuario", OracleDbType.NVarchar2,35);
            parameters[5].Value = ult_usuario_act;
            parameters[6] = new OracleParameter("p_id_pss_med", OracleDbType.Int32);
            parameters[6].Value = id_pss_med;
            parameters[7] = new OracleParameter("p_no_documento_med", OracleDbType.NVarchar2,35);
            parameters[7].Value = no_documento_med;
            parameters[8] = new OracleParameter("p_Nombre_med", OracleDbType.NVarchar2,200);
            parameters[8].Value = nombre_med;
            parameters[9] = new OracleParameter("p_Direccion_med", OracleDbType.NVarchar2,200);
            parameters[9].Value = direccion_med;
            parameters[10] = new OracleParameter("p_Telefono_med", OracleDbType.NVarchar2,10);
            parameters[10].Value = telefono_med;
            parameters[11] = new OracleParameter("p_celular_med", OracleDbType.NVarchar2,10);
            parameters[11].Value = celular_med;
            parameters[12] = new OracleParameter("p_Email_med", OracleDbType.NVarchar2,200);
            parameters[12].Value = email_med;
            parameters[13] = new OracleParameter("p_id_pss_cen", OracleDbType.Int32);
            parameters[13].Value = id_pss_cen;
            parameters[14] = new OracleParameter("p_nombre_cen", OracleDbType.NVarchar2,200);
            parameters[14].Value = nombre_cen;
            parameters[15] = new OracleParameter("p_Direccion_cen", OracleDbType.NVarchar2,200);
            parameters[15].Value = direccion_cen;
            parameters[16] = new OracleParameter("p_Telefono_cen", OracleDbType.NVarchar2,10);
            parameters[16].Value = telefono_cen;
            parameters[17] = new OracleParameter("p_Fax_cen" , OracleDbType.NVarchar2,10);
            parameters[17].Value = fax_cen;
            parameters[18] = new OracleParameter("p_Email_cen", OracleDbType.NVarchar2,200);
            parameters[18].Value = email_cen;
            parameters[19] = new OracleParameter("p_Tipo_Discapacidad", OracleDbType.NVarchar2,1);
            parameters[19].Value = tipo_discapacidad;
            parameters[20] = new OracleParameter("p_Diagnostico", OracleDbType.NVarchar2,600);
            parameters[20].Value = diagnostico;
            parameters[21] = new OracleParameter("p_Signos_Sintomas", OracleDbType.NVarchar2,600);
            parameters[21].Value = signos_sintomas;
            parameters[22] = new OracleParameter("p_Procedimientos", OracleDbType.NVarchar2,600);
            parameters[22].Value = procedimientos;
            parameters[23] = new OracleParameter("p_Ambulatorio", OracleDbType.NVarchar2,1);
            parameters[23].Value = ambulatorio;
            parameters[24] = new OracleParameter("p_Fecha_Inicio_amb", OracleDbType.Date);
            if (fecha_inicio_amb.Equals(DateTime.MinValue))
            {
                parameters[24].Value = DBNull.Value;
            }
            else
            {
                parameters[24].Value = fecha_inicio_amb;
            }
            parameters[25] = new OracleParameter("p_dias_cal_amb", OracleDbType.Int32);
            parameters[25].Value = dias_cal_amb;
            parameters[26] = new OracleParameter("p_Hospitalario", OracleDbType.NVarchar2,1);
            parameters[26].Value = hospitalizacion;
            parameters[27] = new OracleParameter("p_Fecha_inicio_hos", OracleDbType.Date);
            if (fecha_inicio_hos.Equals(DateTime.MinValue))
            {
                parameters[27].Value = DBNull.Value;
            }
            else
            {
                parameters[27].Value = fecha_inicio_hos;
            }
            parameters[28] = new OracleParameter("p_dias_cal_hos", OracleDbType.Int32);
            parameters[28].Value = dias_cal_hos;
            parameters[29] = new OracleParameter("p_Fecha_Diagnostico", OracleDbType.Date);
            parameters[29].Value = fecha_diagnostico;
            parameters[30] = new OracleParameter("p_id_registro_patronal", OracleDbType.Int32);
            parameters[30].Value = id_registro_patronal;
            parameters[31] = new OracleParameter("p_id_usuario", OracleDbType.NVarchar2,35);
            parameters[31].Value = usuario_registro;
            parameters[32] = new OracleParameter("p_Codigo_CIE10", OracleDbType.NVarchar2,4);
            parameters[32].Value = codigocie10;
            parameters[33] = new OracleParameter("p_Exequatur", OracleDbType.NVarchar2,35);
            parameters[33].Value = exequatur;
            parameters[34] = new OracleParameter("p_Id_Nomina", OracleDbType.Int32);
            parameters[34].Value = Id_Nomina;
            parameters[35] = new OracleParameter("p_id_movimiento", OracleDbType.NVarchar2, 200);
            parameters[35].Direction = ParameterDirection.InputOutput;
            parameters[36] = new OracleParameter("p_id_linea", OracleDbType.NVarchar2, 200);
            parameters[36].Direction = ParameterDirection.InputOutput;
            parameters[37] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            parameters[37].Direction = ParameterDirection.InputOutput;

            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, "SFS_NOV_PKG.RegistroEnfComun", parameters);
                string respuesta = Utilitarios.Utils.sacarMensajeDeError(parameters[37].Value.ToString());

                if (respuesta == "OK")
                {
                    id_movimiento = parameters[35].Value.ToString();
                    id_linea = parameters[36].Value.ToString();
                }
                else
                {
                    id_movimiento = "0";
                    id_linea = "0";
                }
                return respuesta;

            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;
            }
        }

        public static String CargaImagenFormulario(int id_movimiento, int id_linea, string nombreImagen, Byte[] Imagen)
        {
            string v_resul = string.Empty;
            try
            {


                string Query = "Update Suirplus.Sre_Det_Movimiento_Enf_t De Set De.Imagen = :1, De.Nombre_Archivo = :2  Where De.Id_Movimiento = :3  And De.Id_Linea = :4";

                OracleConnection conn = new OracleConnection(DataBase.OracleHelper.getConnString());
                OracleCommand comm = new OracleCommand(Query,conn);
                comm.CommandType = CommandType.Text;
                
                comm.Parameters.Add("p_Imagen", Oracle.ManagedDataAccess.Client.OracleDbType.Blob, ParameterDirection.Input).Value = Imagen;
                comm.Parameters.Add("p_nombre_archivo", Oracle.ManagedDataAccess.Client.OracleDbType.NVarchar2, ParameterDirection.Input).Value = nombreImagen;
                comm.Parameters.Add("p_id_movimiento", Oracle.ManagedDataAccess.Client.OracleDbType.Double, ParameterDirection.Input).Value = id_movimiento;
                comm.Parameters.Add("p_id_linea", Oracle.ManagedDataAccess.Client.OracleDbType.Double, ParameterDirection.Input).Value = id_linea;
                               
                comm.Connection.Open();
                comm.ExecuteNonQuery();
                comm.Connection.Close();

                v_resul = "OK";
            }

            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;
            }

            return v_resul; 
        

        }

        //cargarImagenFormulario by charlie pena
        public static string CargarImagen(int id_formulario,  Byte[] ImageFile,string nombreImagen)
        {

            OracleParameter[] arrParam = new OracleParameter[4];

            arrParam[0] = new OracleParameter("p_id_formulario", OracleDbType.Int32);
            arrParam[0].Value = id_formulario;            
            arrParam[1] = new OracleParameter("p_imagen", OracleDbType.Blob);
            arrParam[1].Value = ImageFile;
            arrParam[2] = new OracleParameter("p_nombre_archivo", OracleDbType.NVarchar2);
            arrParam[2].Value = nombreImagen;
            arrParam[3] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[3].Direction = ParameterDirection.Output;

            String cmdStr = "sub_sfs_novedades.cargarimagen";

            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                return arrParam[3].Value.ToString();
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

        public static DataTable GetSubsidiadoEmpresa(int registroPatronal, Int16 pageNum, Int16 pageSize, string cedula)
        {

            OracleParameter[] arrParam = new OracleParameter[6];

            arrParam[0] = new OracleParameter("P_RegistroPatronal", OracleDbType.Decimal);
            arrParam[0].Value = registroPatronal;

            arrParam[1] = new OracleParameter("p_pagenum", OracleDbType.Int16);
            arrParam[1].Value = pageNum;

            arrParam[2] = new OracleParameter("p_pagesize", OracleDbType.Int16);
            arrParam[2].Value = pageSize;

            arrParam[3] = new OracleParameter("p_cedula", OracleDbType.NVarchar2);
            if (cedula.Equals(string.Empty))
            {
                arrParam[3].Value = DBNull.Value;
            }
            else
            {
                arrParam[3].Value = cedula;
            }
            

            arrParam[4] = new OracleParameter("p_io_cursor", OracleDbType.RefCursor);
            arrParam[4].Direction = ParameterDirection.Output;

            arrParam[5] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[5].Direction = ParameterDirection.Output;

            string cmdStri = "SFS_SUBSIDIOS_PKG.GetSubsidiadoEmpresa";

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

        public static DataTable GetDetalleSubsidiadoEmpresa(string NroSolicitud,int registroPatronal)
        {

            OracleParameter[] arrParam = new OracleParameter[4];

            arrParam[0] = new OracleParameter("P_NroSolicitud", OracleDbType.NVarchar2,200);
            arrParam[0].Value = NroSolicitud;

            arrParam[1] = new OracleParameter("P_RegistroPatronal", OracleDbType.Decimal);
            arrParam[1].Value = registroPatronal;

            arrParam[2] = new OracleParameter("p_io_cursor", OracleDbType.RefCursor);
            arrParam[2].Direction = ParameterDirection.Output;

            arrParam[3] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[3].Direction = ParameterDirection.Output;

            string cmdStri = "SFS_SUBSIDIOS_PKG.GetDetSubsidiadoEmpresa";

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
        /// <summary>
        /// 
        /// </summary>
        /// <param name="NoFormulario"></param>
        /// <param name="Cedula"></param>
        /// <returns></returns>
        public static string hashValores(string NoFormulario, string Cedula)
        {
            string Valores = NoFormulario  + Cedula;
            string Pass = "13579";
            int i;
            int c;
            string strBuff = "";

            for (i = 1; i <= Valores.Length; i++)
            {
                c = Strings.Asc(Strings.Mid(Valores, i, 1));
                c = c + Strings.Asc(Strings.Mid(Pass, (i % Strings.Len(Pass)) + 1, 1));
                strBuff = strBuff + Strings.Chr(c & 0xff);
            }

            return Strings.UCase(strBuff);
        }
        public static string hashValores(string NoFormulario)
        {
            string Valores = NoFormulario;
            string Pass = "13579";
            int i;
            int c;
            string strBuff = "";

            for (i = 1; i <= Valores.Length; i++)
            {
                c = Strings.Asc(Strings.Mid(Valores, i, 1));
                c = c + Strings.Asc(Strings.Mid(Pass, (i % Strings.Len(Pass)) + 1, 1));
                strBuff = strBuff + Strings.Chr(c & 0xff);
            }

            return Strings.UCase(strBuff);


        }
       
        public static string unhashValores(string Valor)
        {
            int i;
            int c;
            string strBuff = "";
            string Pass = "13579";

            for (i = 1; i <= Valor.Length; i++)
            {
                c = Strings.Asc(Strings.Mid(Valor.ToLower(), i, 1));
                c = c - Strings.Asc(Strings.Mid(Pass, (i % Strings.Len(Pass)) + 1, 1));
                strBuff = strBuff + Strings.Chr(c & 0xff);
            }

            return strBuff;
        }


        public static DataTable GetReImpresionEnfComun(string Cedula, int PIN)
        {

            OracleParameter[] arrParam = new OracleParameter[4];

            arrParam[0] = new OracleParameter("P_CEDULA", OracleDbType.NVarchar2, 25);
            arrParam[0].Value = Cedula;

            arrParam[1] = new OracleParameter("P_PIN", OracleDbType.Decimal,4);
            arrParam[1].Value = PIN;

            arrParam[2] = new OracleParameter("p_io_cursor", OracleDbType.RefCursor);
            arrParam[2].Direction = ParameterDirection.Output;

            arrParam[3] = new OracleParameter("P_RESULTNUMBER", OracleDbType.NVarchar2, 200);
            arrParam[3].Direction = ParameterDirection.Output;

            string cmdStri = "sub_sfs_subsidios.getreimpresionenfcomun";

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

        //private static String getConnString()
        //{
        //    string connectionString = System.Configuration.ConfigurationSettings.AppSettings["oConnSuirPlus"];

        //    byte[] data = Convert.FromBase64String(connectionString);
        //    return System.Text.ASCIIEncoding.ASCII.GetString(data);
        //}

    }
    
    }
