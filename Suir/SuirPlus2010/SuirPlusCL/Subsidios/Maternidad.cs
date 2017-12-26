using System;
using System.Collections.Generic;
using System.Linq;
using SuirPlus.DataBase;
using System.Data;
using Oracle.ManagedDataAccess.Client;
using SuirPlus.Utilitarios;
using SuirPlus.Exepciones;
using System.Text;
namespace SuirPlus.Subsidios
{
    public class Maternidad : abstractNovedad
    {
     
        public DateTime FechaDiagnostico { get; set; }
        public DateTime? FechaEstimadaParto { get; set; }
        public DateTime? FechaDefuncionMadre { get; set; }

        public DateTime? FechaInicioLicencia { get; set; }
        public String TipoLicencia { get; set; }
        public String UsuarioRegistroLicencia { get; set; }

        public string CuentaBancoMadre { get; set; }

        public int? RegistroPatronalRegistroEmbarazo { get; set; }
        public DateTime? FechaRegistroEmbarazo { get; set; }
        public string UsuarioRegistroEmbarazo { get; set; }

        public int? RegistroPatronalPerdidaEmbarazo { get; set; }
        public DateTime? FechaPerdidaEmbarazo { get; set; }
        public string UsuarioPerdidaEmbarazo { get; set; }

        public int? RegistroPatronalMuerteMadre { get; set; }
        public DateTime? FechaMuerteMadre { get; set; }
        public string UsuarioMuerteMadre { get; set; }

        public decimal SalarioEstimado { get; set; }

        public DateTime? FechaRegistroModificacion { get; set; }
        public string UsuarioModificacion { get; set; }

        public string Telefono { get; set; }
        public string Celular { get; set; }
        public string Email { get; set; }
        public string Status { get; set; }


        #region "Metodos de la clase"
        /// <summary>
        /// Propiedad para hacer referencia al tutor.
        /// </summary>
        public Tutor Tutor { get; set; }
        /// <summary>
        /// Metodo para hacer el registro del embarazo
        /// </summary>
        /// <param name="maternidad">maternidad que desea agregar.</param>
        /// <returns></returns>
        public static String RegistrarEmbarazo(Maternidad maternidad, ref String nroformulario)
        {
            var result = String.Empty;


            //Validar datos de la maternidad

            if (!EsRegistroEmbarazoValido(maternidad, out result))
                return result;
         
                try
                {
                    OracleParameter[] parameters = new OracleParameter[15];
                    parameters[0] = new OracleParameter("p_NSS", maternidad.NSS);
                    parameters[1] = new OracleParameter("p_TELEFONO", maternidad.Telefono);
                    parameters[2] = new OracleParameter("p_CELULAR", maternidad.Celular);
                    parameters[3] = new OracleParameter("p_EMAIL", maternidad.Email);
                    parameters[4] = new OracleParameter("p_FECHA_DIAGNOSTICO", maternidad.FechaDiagnostico);
                    parameters[5] = new OracleParameter("p_FECHA_ESTIMADA_PARTO", maternidad.FechaEstimadaParto);
                    parameters[6] = new OracleParameter("p_NSS_TUTOR", maternidad.Tutor.NSS);
                    parameters[7] = new OracleParameter("p_TELEFONO_TUTOR", maternidad.Tutor.Telefono);
                    parameters[8] = new OracleParameter("p_EMAIL_TUTOR", maternidad.Tutor.Email);
                    parameters[9] = new OracleParameter("p_ULT_USUARIO_ACT", maternidad.UsuarioRegistroEmbarazo);
                    parameters[10] = new OracleParameter("p_ID_REGISTRO_PATRONAL_RE", maternidad.RegistroPatronalRegistroEmbarazo);
                    parameters[11] = new OracleParameter("p_esRetroativa", maternidad.Retroactiva);

                    parameters[12] = new OracleParameter("p_nroFormulario", OracleDbType.NVarchar2, 200);
                    parameters[12].Direction = ParameterDirection.InputOutput;

                    parameters[13] = new OracleParameter("P_NRO_SOLICITUD", OracleDbType.NVarchar2, 200);
                    parameters[13].Direction = ParameterDirection.InputOutput;

                    parameters[14] = new OracleParameter("p_ResultNumber", OracleDbType.NVarchar2, 200);
                    parameters[14].Direction = ParameterDirection.InputOutput;

                    DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, "SUB_SFS_NOVEDADES.crearEmbarazo", parameters);

                    result = Utilitarios.Utils.sacarMensajeDeError(parameters[14].Value.ToString());

                    nroformulario = parameters[12].Value.ToString();

                 
                    return result;
                }
                catch (Exception ex)
                {
                    Exepciones.Log.LogToDB(ex.ToString());
                    throw ex;
                }
        }
        /// <summary>
        /// Metodo para hacer el Registro de la Licencia
        /// </summary>
        /// <param name="RegistroPatronal">Registro Patronal que hizo el registro de la licencia.</param>
        /// <param name="NumeroSolicitud">Numero de la solicitud de la licencia.</param>
        /// <param name="TipoLicencia">Tipo de la Licencia, esta puede ser Pre o Post.</param>
        /// <param name="FechaInicioLicencia">Fecha de inicio de la licencia.</param>
        /// <param name="UsuarioRegistro">Usuario que hizo el registro de la licencia.</param>
        /// <returns></returns>
        public static String RegistroLicencia(Int32 NSS,
                                              DateTime FechaInicioLicencia,
                                              Int32 RegistroPatronal,
                                              String UsuarioRegistro,
                                              String TipoLicencia,
                                              String Retroactiva,
                                              Int32? NroSolicitud,
                                              Formulario formulario,
                                              String Modo)
        {

            OracleParameter[] parameters = new OracleParameter[30];

            parameters[0] = new OracleParameter("p_ID_NSS", NSS);

            parameters[1] = new OracleParameter("p_FECHA_LICENCIA", FechaInicioLicencia);

            parameters[2] = new OracleParameter("p_ID_REGISTRO_PATRONAL", RegistroPatronal);

            parameters[3] = new OracleParameter("p_USUARIO_REGISTRO", UsuarioRegistro);

            parameters[4] = new OracleParameter("p_TIPO_LICENCIA", TipoLicencia);

            parameters[5] = new OracleParameter("p_TIPO_FORMULARIO", formulario.TipoFormulario);

            parameters[6] = new OracleParameter("p_NRO_FORMULARIO", formulario.NroFormulario);

            parameters[7] = new OracleParameter("p_ID_PSS_MED", formulario.Medico.PSS_Med);

            parameters[8] = new OracleParameter("p_NO_DOCUMENTO_MED", formulario.Medico.NoDocumentoMedico);

            parameters[9] = new OracleParameter("p_NOMBRE_MED", formulario.Medico.NombreMedico);

            parameters[10] = new OracleParameter("p_DIRECCION_MED", formulario.Medico.DireccionMedico);

            parameters[11] = new OracleParameter("p_TELEFONO_MED", formulario.Medico.TelefonoMedico);

            parameters[12] = new OracleParameter("p_CELULAR_MED", formulario.Medico.celularMedico);

            parameters[13] = new OracleParameter("p_EMAIL_MED", formulario.Medico.emailMedico);

            parameters[14] = new OracleParameter("p_ID_PSS_CEN", formulario.PrestadoraSalud.idPssCentro);

            parameters[15] = new OracleParameter("p_NOMBRE_CEN", formulario.PrestadoraSalud.nombreCentro);

            parameters[16] = new OracleParameter("p_DIRECCION_CEN", formulario.PrestadoraSalud.DireccionCentro);

            parameters[17] = new OracleParameter("p_TELEFONO_CEN", formulario.PrestadoraSalud.TelefonoCentro);

            parameters[18] = new OracleParameter("p_FAX_CEN", formulario.PrestadoraSalud.faxCentro);

            parameters[19] = new OracleParameter("p_EMAIL_CEN", formulario.PrestadoraSalud.emailCentro);

            parameters[20] = new OracleParameter("p_EXEQUATUR", formulario.Medico.Exequatur);

            parameters[21] = new OracleParameter("p_ULT_USUARIO_ACT", formulario.UltimoUsrAct);

            parameters[22] = new OracleParameter("p_DIAGNOSTICO", formulario.diagnostico);

            parameters[23] = new OracleParameter("p_SIGNOS_SINTOMAS", formulario.signoSintomas);

            parameters[24] = new OracleParameter("p_PROCEDIMIENTOS", formulario.Procedimientos);

            parameters[25] = new OracleParameter("p_FECHA_DIAGNOSTICO", formulario.fechaDiagnostico);

            //Parametro para saber si la licencia es retroactiva. 
            parameters[26] = new OracleParameter("p_esRetroativa", Retroactiva);

            parameters[27] = new OracleParameter("p_NRO_SOLICITUD", NroSolicitud);

            parameters[28] = new OracleParameter("P_MODO", OracleDbType.Varchar2, 1);
            parameters[28].Value = Modo;

            parameters[29] = new OracleParameter("p_RESULTNUMBER", OracleDbType.NVarchar2, 200);
            parameters[29].Direction = ParameterDirection.Output;

            var result = String.Empty;

            try
            {
                OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, "SUB_SFS_NOVEDADES.crearLicencia", parameters);

                result = Utilitarios.Utils.sacarMensajeDeError(parameters[29].Value.ToString());

                return result;
            }
            catch (Exception ex)
            {

                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;
            }

        }


        /// <summary>
        /// Metodo que registra 
        /// </summary>
        /// <param name="NSS"></param>
        /// <param name="RegistroPatronalPerdida"></param>
        /// <param name="FechaPerdida"></param>
        /// <param name="UsuarioPerdida"></param>
        /// <returns></returns>
        public static String RegistrarPedidaEmbarazo(Int32 RegistroPatronalPerdida,
                                                     DateTime FechaPerdida, String UsuarioPerdida,
                                                     String Retroactiva, Int32 NroSolicitud)
        {

            OracleParameter[] parameters = new OracleParameter[6];

            parameters[0] = new OracleParameter("p_ID_REGISTRO_PATRONAL", RegistroPatronalPerdida);

            parameters[1] = new OracleParameter("p_FECHA_PERDIDA", FechaPerdida);

            parameters[2] = new OracleParameter("p_ULT_USUARIO_ACT", UsuarioPerdida);

            //Parametro que indica si esta perdida se esta registrando en un reporte de embarazo retroactivo
            parameters[3] = new OracleParameter("p_esRetroativa", Retroactiva);

            parameters[4] = new OracleParameter("p_NRO_SOLICITUD", NroSolicitud);

            parameters[5] = new OracleParameter("p_RESULTNUMBER", OracleDbType.Varchar2, 255);
            parameters[5].Direction = ParameterDirection.Output;


            try
            {
                OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, "SUB_SFS_NOVEDADES.crearPerdidaEmbarazo", parameters);

                var result = SuirPlus.Utilitarios.Utils.sacarMensajeDeError(Convert.ToString(parameters[5].Value));

                return result;
            }
            catch (Exception ex)
            {
                SuirPlus.Exepciones.Log.LogToDB(ex.Message);
                throw ex;
            }
        }
        /// <summary>
        /// Metodo para hacer el reporte de la muerte de la madre
        /// </summary>
        /// <param name="NSS">NSS de la trabajadora que se le va hacer el reporte</param>
        /// <param name="RegistroPatronalMuerte">Registro patronal que esta haciendo el reporte</param>
        /// <param name="FechaMuerte">Fecha que murio la trabajadora</param>
        /// <param name="UsuarioMuerteMadre">Usuario que esta haciendo el reporte de la muerte.</param>
        /// <returns></returns>
        public static String ReporteMuerteMadre(Int32 NSS, Int32 RegistroPatronalMuerte, DateTime FechaMuerte, String UsuarioMuerteMadre)
        {
            OracleParameter[] parameters = new OracleParameter[6];

            parameters[0] = new OracleParameter("p_ID_NSS", NSS);

            parameters[1] = new OracleParameter("p_ID_REGISTRO_PATRONAL", RegistroPatronalMuerte);

            parameters[2] = new OracleParameter("p_FECHA_MUERTE", FechaMuerte);

            parameters[3] = new OracleParameter("p_ULT_USUARIO_ACT", UsuarioMuerteMadre);

            //Parametro que indica si esta perdida se esta registrando en un reporte de embarazo retroactivo
            parameters[4] = new OracleParameter("p_esRetroativa", "NO");

            parameters[5] = new OracleParameter("p_RESULTNUMBER", OracleDbType.Varchar2, 255);
            parameters[5].Direction = ParameterDirection.Output;


            try
            {
                OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, "SUB_SFS_NOVEDADES.crearMuerteMadre", parameters);

                var result = SuirPlus.Utilitarios.Utils.sacarMensajeDeError(Convert.ToString(parameters[5].Value));

                return result;
            }
            catch (Exception ex)
            {
                SuirPlus.Exepciones.Log.LogToDB(ex.Message);
                throw ex;
            }

        }
        /// <summary>
        /// Metodo para hacer el registro de embarazo retroactivo
        /// </summary>
        /// <param name="maternidad">maternidad retroactiva que desea agregar.</param>
        /// <param name="latante">lactante que desea agregar</param>
        /// <returns></returns>
        public static String RegistrarEmbarazoRetroactivo(Maternidad maternidad, Formulario formulario, Lactante nacimiento, 
                                                          List<Lactante> lactates, String Modo, ref String nrosolicitud)
        {
            
            var result = String.Empty;

            if (!EsRegistroEmbarazoValido(maternidad, out result))
                return result;

            
            OracleParameter[] arrParam = new OracleParameter[41];

            //--Maternidad--//
            arrParam[0] = new OracleParameter("p_ID_NSS", OracleDbType.Int32);
            arrParam[0].Value = Utils.verificarNulo(maternidad.NSS);
            arrParam[1] = new OracleParameter("p_TELEFONO", OracleDbType.Varchar2, 12 );
            arrParam[1].Value = maternidad.Telefono;
            arrParam[2] = new OracleParameter("p_CELULAR", OracleDbType.Varchar2, 12);
            arrParam[2].Value = maternidad.Celular;
            arrParam[3] = new OracleParameter("p_EMAIL", OracleDbType.Varchar2, 50);
            arrParam[3].Value = maternidad.Email;
            arrParam[4] = new OracleParameter("p_FECHA_DIAGNOSTICO", OracleDbType.Date);
            arrParam[4].Value = maternidad.FechaDiagnostico;
            arrParam[5] = new OracleParameter("p_FECHA_ESTIMADA_PARTO", OracleDbType.Date);
            arrParam[5].Value = maternidad.FechaEstimadaParto;
            arrParam[6] = new OracleParameter("p_NSS_TUTOR", maternidad.Tutor.NSS);
            arrParam[7] = new OracleParameter("p_TELEFONO_TUTOR", OracleDbType.Varchar2, 12);
            arrParam[7].Value = maternidad.Tutor.Telefono;
            arrParam[8] = new OracleParameter("p_EMAIL_TUTOR", OracleDbType.Varchar2, 50);
            arrParam[8].Value = maternidad.Tutor.Email;
            arrParam[9] = new OracleParameter("p_ULT_USUARIO_ACT", OracleDbType.Varchar2, 35);
            arrParam[9].Value = maternidad.UsuarioRegistroEmbarazo;
            arrParam[10] = new OracleParameter("p_ID_REGISTRO_PATRONAL", maternidad.RegistroPatronalRegistroEmbarazo);
            arrParam[11] = new OracleParameter("p_esRetroativa", maternidad.Retroactiva);
            //--Maternidad--//

           
            //--Licencia--//
            arrParam[12] = new OracleParameter("p_FECHA_LICENCIA", OracleDbType.Date);
            arrParam[12].Value = maternidad.FechaInicioLicencia;
            arrParam[13] = new OracleParameter("p_TIPO_LICENCIA", maternidad.TipoLicencia);
            arrParam[14] = new OracleParameter("p_TIPO_FORMULARIO", formulario.TipoFormulario);
            arrParam[15] = new OracleParameter("p_ID_PSS_MED", formulario.Medico.PSS_Med);
            arrParam[16] = new OracleParameter("p_NO_DOCUMENTO_MED", OracleDbType.Varchar2, 11);
            arrParam[16].Value = formulario.Medico.NoDocumentoMedico;
            arrParam[17] = new OracleParameter("p_NOMBRE_MED", OracleDbType.Varchar2, 100);
            arrParam[17].Value = formulario.Medico.NombreMedico;
            arrParam[18] = new OracleParameter("p_DIRECCION_MED", OracleDbType.Varchar2, 400);
            arrParam[18].Value = formulario.Medico.DireccionMedico;
            arrParam[19] = new OracleParameter("p_TELEFONO_MED", OracleDbType.Varchar2, 12);
            arrParam[19].Value = formulario.Medico.TelefonoMedico;
            arrParam[20] = new OracleParameter("p_CELULAR_MED", OracleDbType.Varchar2, 12);
            arrParam[20].Value = formulario.Medico.celularMedico;
            arrParam[21] = new OracleParameter("p_EMAIL_MED", OracleDbType.Varchar2, 50);
            arrParam[21].Value = formulario.Medico.emailMedico;
            arrParam[22] = new OracleParameter("p_ID_PSS_CEN", formulario.PrestadoraSalud.idPssCentro);
            arrParam[23] = new OracleParameter("p_NOMBRE_CEN", OracleDbType.Varchar2, 100);
            arrParam[23].Value = formulario.PrestadoraSalud.nombreCentro;
            arrParam[24] = new OracleParameter("p_DIRECCION_CEN", OracleDbType.Varchar2, 400);
            arrParam[24].Value = formulario.PrestadoraSalud.DireccionCentro;
            arrParam[25] = new OracleParameter("p_TELEFONO_CEN", OracleDbType.Varchar2, 10);
            arrParam[25].Value = formulario.PrestadoraSalud.TelefonoCentro;
            arrParam[26] = new OracleParameter("p_FAX_CEN", OracleDbType.Varchar2, 10);
            arrParam[26].Value = formulario.PrestadoraSalud.faxCentro;
            arrParam[27] = new OracleParameter("p_EMAIL_CEN", OracleDbType.Varchar2, 200);
            arrParam[27].Value = formulario.PrestadoraSalud.emailCentro;
            arrParam[28] = new OracleParameter("p_EXEQUATUR", OracleDbType.Varchar2, 35);
            arrParam[28].Value = formulario.Medico.Exequatur;
            arrParam[29] = new OracleParameter("p_DIAGNOSTICO", OracleDbType.Varchar2, 600);
            arrParam[29].Value = formulario.diagnostico;
            arrParam[30] = new OracleParameter("p_SIGNOS_SINTOMAS", OracleDbType.Varchar2, 600);
            arrParam[30].Value = formulario.signoSintomas;
            arrParam[31] = new OracleParameter("p_PROCEDIMIENTOS", OracleDbType.Varchar2, 600);
            arrParam[31].Value = formulario.Procedimientos;
            arrParam[32] = new OracleParameter("p_FECHA_DIAGNOSTICO_LIC", formulario.fechaDiagnostico);
            //--Licencia--//

           
            //--Nacimiento--//
            arrParam[33] = new OracleParameter("p_cant_lactantes", nacimiento.CantidadLactante);
            arrParam[34] = new OracleParameter("p_fecha_nacimiento", nacimiento.FechaNacimiento);
            //--Nacimiento--//

            StringBuilder Todos = new StringBuilder();
            foreach (var lac in lactates)
            {
                Todos.Append(lac.NSSLactante + "|");
                Todos.Append(lac.NUI + "|");
                Todos.Append(lac.Nombres + "|");
                Todos.Append(lac.PrimerApellido + "|");
                Todos.Append(lac.SegundoApellido + "|");
                Todos.Append(lac.Sexo + "|");
            }

            arrParam[35] = new OracleParameter("p_DATOS_LACTANTES", OracleDbType.Varchar2, 3000);
            arrParam[35].Value = Todos.ToString() ;

            arrParam[36] = new OracleParameter("p_FECHA_MUERTE", maternidad.FechaMuerteMadre);
            arrParam[37] = new OracleParameter("p_FECHA_PERDIDA", maternidad.FechaPerdidaEmbarazo);

            arrParam[38] = new OracleParameter("p_nro_solicitud", OracleDbType.NVarchar2, 200);
            arrParam[38].Value = nrosolicitud;
            arrParam[38].Direction = ParameterDirection.InputOutput;


            arrParam[39] = new OracleParameter("P_MODO", OracleDbType.Varchar2, 1);
            arrParam[39].Value = Modo;


            arrParam[40] = new OracleParameter("p_RESULTNUMBER", OracleDbType.Varchar2, 500);
            arrParam[40].Direction = ParameterDirection.InputOutput;


            try
            {
                OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, "SUB_SFS_NOVEDADES.Registro_Embarazo_Rectroactivo", arrParam);

                 result = SuirPlus.Utilitarios.Utils.sacarMensajeDeError(Convert.ToString(arrParam[40].Value));

                nrosolicitud = arrParam[38].Value.ToString(); 

                return result;
            }
            catch (Exception ex)
            {
                SuirPlus.Exepciones.Log.LogToDB(ex.Message);
                throw ex;
            }
        }
        public static String RegistrarLicenciaPostNatal(Int32 NSS, DateTime fechalicencia, string usuario, Int32 registropatronal, Formulario formulario, Lactante nacimiento,
                                                          List<Lactante> lactates, ref String nrosolicitud)
        {
            var result = String.Empty;

            OracleParameter[] arrParam = new OracleParameter[27];
            //--Licencia--//
            arrParam[0] = new OracleParameter("p_ID_NSS", NSS);
            arrParam[1] = new OracleParameter("p_ULT_USUARIO_ACT", usuario);
            arrParam[2] = new OracleParameter("p_ID_REGISTRO_PATRONAL", registropatronal);
            arrParam[3] = new OracleParameter("p_FECHA_LICENCIA", fechalicencia);
            arrParam[4] = new OracleParameter("p_ID_PSS_MED", formulario.Medico.PSS_Med);
            arrParam[5] = new OracleParameter("p_NO_DOCUMENTO_MED", OracleDbType.Varchar2, 11);
            arrParam[5].Value = formulario.Medico.NoDocumentoMedico;
            arrParam[6] = new OracleParameter("p_NOMBRE_MED", OracleDbType.Varchar2, 100);
            arrParam[6].Value = formulario.Medico.NombreMedico;
            arrParam[7] = new OracleParameter("p_DIRECCION_MED", OracleDbType.Varchar2, 400);
            arrParam[7].Value = formulario.Medico.DireccionMedico;
            arrParam[8] = new OracleParameter("p_TELEFONO_MED", OracleDbType.Varchar2, 12);
            arrParam[8].Value = formulario.Medico.TelefonoMedico;
            arrParam[9] = new OracleParameter("p_CELULAR_MED", OracleDbType.Varchar2, 12);
            arrParam[9].Value = formulario.Medico.celularMedico;
            arrParam[10] = new OracleParameter("p_EMAIL_MED", OracleDbType.Varchar2, 50);
            arrParam[10].Value = formulario.Medico.emailMedico;
            arrParam[11] = new OracleParameter("p_ID_PSS_CEN", formulario.PrestadoraSalud.idPssCentro);
            arrParam[12] = new OracleParameter("p_NOMBRE_CEN", OracleDbType.Varchar2, 100);
            arrParam[12].Value = formulario.PrestadoraSalud.nombreCentro;
            arrParam[13] = new OracleParameter("p_DIRECCION_CEN", OracleDbType.Varchar2, 400);
            arrParam[13].Value = formulario.PrestadoraSalud.DireccionCentro;
            arrParam[14] = new OracleParameter("p_TELEFONO_CEN", OracleDbType.Varchar2, 10);
            arrParam[14].Value = formulario.PrestadoraSalud.TelefonoCentro;
            arrParam[15] = new OracleParameter("p_FAX_CEN", OracleDbType.Varchar2, 10);
            arrParam[15].Value = formulario.PrestadoraSalud.faxCentro;
            arrParam[16] = new OracleParameter("p_EMAIL_CEN", OracleDbType.Varchar2, 200);
            arrParam[16].Value = formulario.PrestadoraSalud.emailCentro;
            arrParam[17] = new OracleParameter("p_EXEQUATUR", OracleDbType.Varchar2, 35);
            arrParam[17].Value = formulario.Medico.Exequatur;
            arrParam[18] = new OracleParameter("p_DIAGNOSTICO", OracleDbType.Varchar2, 600);
            arrParam[18].Value = formulario.diagnostico;
            arrParam[19] = new OracleParameter("p_SIGNOS_SINTOMAS", OracleDbType.Varchar2, 600);
            arrParam[19].Value = formulario.signoSintomas;
            arrParam[20] = new OracleParameter("p_PROCEDIMIENTOS", OracleDbType.Varchar2, 600);
            arrParam[20].Value = formulario.Procedimientos;
            arrParam[21] = new OracleParameter("p_FECHA_DIAGNOSTICO_LIC", formulario.fechaDiagnostico);
            //--Licencia--//

            //--Nacimiento--//
            arrParam[22] = new OracleParameter("p_cant_lactantes", nacimiento.CantidadLactante);
            arrParam[23] = new OracleParameter("p_fecha_nacimiento", nacimiento.FechaNacimiento);

            StringBuilder Todos = new StringBuilder();
            foreach (var lac in lactates)
            {
                Todos.Append(lac.NSSLactante + "|");
                Todos.Append(lac.NUI + "|");
                Todos.Append(lac.Nombres + "|");
                Todos.Append(lac.PrimerApellido + "|");
                Todos.Append(lac.SegundoApellido + "|");
                Todos.Append(lac.Sexo + "|");
            }

            arrParam[24] = new OracleParameter("p_DATOS_LACTANTES", OracleDbType.Varchar2, 3000);
            arrParam[24].Value = Todos.ToString();
            //--Nacimiento--//


            arrParam[25] = new OracleParameter("p_nro_solicitud", OracleDbType.NVarchar2, 200);
            arrParam[25].Value = nrosolicitud;
            arrParam[25].Direction = ParameterDirection.InputOutput;

            arrParam[26] = new OracleParameter("p_RESULTNUMBER", OracleDbType.Varchar2, 500);
            arrParam[26].Direction = ParameterDirection.InputOutput;

            try
            {
                OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, "SUB_SFS_NOVEDADES.Registro_Licencia_Post_Natal", arrParam);

                result = SuirPlus.Utilitarios.Utils.sacarMensajeDeError(Convert.ToString(arrParam[26].Value));

                nrosolicitud = arrParam[25].Value.ToString();

                return result;
            }
            catch (Exception ex)
            {
                SuirPlus.Exepciones.Log.LogToDB(ex.Message);
                throw ex;
            }
        }

        public static DataTable TraerDatosMaternidad(Int32 IdMaternidad, Int32 registropatronal, out String result)
        {
            OracleParameter[] parameters = new OracleParameter[4];

            parameters[0] = new OracleParameter("p_id_sub_maternidad", IdMaternidad);

            parameters[1] = new OracleParameter("p_id_registropatronal", registropatronal);

            parameters[2] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            parameters[2].Direction = ParameterDirection.Output;

            parameters[3] = new OracleParameter("p_RESULTNUMBER", OracleDbType.Varchar2, 200);
            parameters[3].Direction = ParameterDirection.Output;

            try
            {
                var mat = OracleHelper.ExecuteDataset(System.Data.CommandType.StoredProcedure, "SUB_SFS_NOVEDADES.getMaternidad", parameters);

                result = Utilitarios.Utils.sacarMensajeDeError(parameters[3].Value.ToString());

                if (result.Equals("OK"))
                {
                    return mat.Tables[0];
                }

                return new DataTable("No hay datos que mostra."); 


            }
            catch (Exception ex)
            {

                throw ex;
            }

        } 

         #endregion

        #region "Validaciones del registro de embarazo y registro licencia"

        /// <summary>
        /// Funcion para determinar si la trabajadora tiene un Subsidio de Maternidad Inconcluso
        /// </summary>
        /// <param name="NSS">NSS de la trabajadora que se va a verificar si tiene un Subsidio de Maternidad Inconcluso </param>
        /// <returns>Devuelve true si la trabajadora tiene un Embarazo Inconcluso </returns>
        public static Boolean tieneEmbarazoInconcluso(Int32 NSS)
        {
            OracleParameter[] arrParam = new OracleParameter[2];

            arrParam[0] = new OracleParameter("p_idnss", OracleDbType.Int32);
            arrParam[0].Value = Utils.verificarNulo(NSS);

            arrParam[1] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[1].Direction = ParameterDirection.InputOutput;

            try
            {
                OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure,
                                             "SUB_SFS_VALIDACIONES.tieneEmbarazoInconcluso",
                                              arrParam);

                var resultado = arrParam[1].Value.ToString();

                if (resultado.Equals("1"))
                {
                    return true;
                }

                return false;

            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;
            }
        }
        /// <summary>
        /// Funcion para determinar si la trabajadora tiene un embarazo anterior 
        /// </summary>
        /// <param name="NSS">Nss de la trabajadora</param>
        /// <param name="FechaEstimadaParto">La fecha de parto del embararzo</param>
        /// <param name="result"></param>
        /// <returns></returns>
        //private static Boolean tieneEmbarazoAnterior(Int32 NSS, DateTime? FechaEstimadaParto)
        //{
        //    var miresult = String.Empty;

        //    OracleParameter[] arrParam = new OracleParameter[3];

        //    arrParam[0] = new OracleParameter("p_idnss", OracleDbType.Int32);
        //    arrParam[0].Value = Utils.verificarNulo(NSS);

        //    arrParam[1] = new OracleParameter("p_fechaestimadaparto", OracleDbType.Date);
        //    arrParam[1].Value = FechaEstimadaParto;

        //    arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
        //    arrParam[2].Direction = ParameterDirection.InputOutput;

        //    try
        //    {
        //        OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, "SUB_SFS_VALIDACIONES.tieneEmbarazoAnterior", arrParam);

        //        miresult = Convert.ToString(arrParam[2].Value);

        //        if (miresult.Equals("1"))
        //        {
        //            return true;
        //        }
        //        return false;
        //    }
        //    catch (Exception ex)
        //    {
        //        Log.LogToDB(ex.Message);
        //        throw ex;
        //    }
        //}
       
        private static Boolean EsRegistroEmbarazoValido(Maternidad maternidad, out String result)
        {
            //Validar datos de la maternidad
            if (maternidad.FechaDiagnostico > DateTime.Now)
            {
                result = "La fecha de diagnostico no puede ser futura";
                return false;
            }
            if (maternidad.FechaDiagnostico > maternidad.FechaEstimadaParto)
            {
                result = "La fecha de diagnostico debe de ser menor a la fecha estimado de parto.";
                return false;
            }
            else if (maternidad.FechaEstimadaParto > maternidad.FechaDiagnostico.AddMonths(9))
            {
                result = "La fecha estimado de parto no debe exceder a la fecha de diagnostico por mas de nueve meses.";
                return false;
            }
            // Validar datos del contacto de la madre
            else if (String.IsNullOrEmpty(maternidad.Telefono) && String.IsNullOrEmpty(maternidad.Celular))
            {
                result = "Debe de digitar el telefono o el celular de la afiliada";
                return false;
            }
            // Validaciones de los datos del tutor
            else if (maternidad.Tutor.NSS == maternidad.NSS)
            {
                result = "El tutor no puede ser la misma afiliada.";
                return false;
            }
            else if (String.IsNullOrEmpty(maternidad.Tutor.Email) && String.IsNullOrEmpty(maternidad.Tutor.Telefono))
            {
                result = "Debe de digitar el telefono o el correo del tutor";
                return false;
            }
            ////validar que La trabajadora este en una NP pagada para esta fecha estimada de parto o esta activa en nomina para este empleador.
            else if (!Validaciones.estaActivaNomina(maternidad.NSS, maternidad.FechaEstimadaParto, maternidad.RegistroPatronalRegistroEmbarazo, maternidad.FechaInicioLicencia, "M"))
            {
                result = "La trabajadora no esta en una NP pagada para esta fecha estimada de parto o esta no activa en nomina para este empleador.";
                return false;
            }
            result = "OK";
            return true;
        }

        public static DataTable GetReImpresionMaternidad(string Cedula, int PIN)
        {

            OracleParameter[] arrParam = new OracleParameter[4];

            arrParam[0] = new OracleParameter("P_CEDULA", OracleDbType.NVarchar2, 25);
            arrParam[0].Value = Cedula;

            arrParam[1] = new OracleParameter("P_PIN", OracleDbType.Decimal, 4);
            arrParam[1].Value = PIN;

            arrParam[2] = new OracleParameter("p_io_cursor", OracleDbType.RefCursor);
            arrParam[2].Direction = ParameterDirection.Output;

            arrParam[3] = new OracleParameter("P_RESULTNUMBER", OracleDbType.NVarchar2, 200);
            arrParam[3].Direction = ParameterDirection.Output;

            string cmdStri = "sub_sfs_subsidios.getreimpresionmaternidad";

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
        #endregion
        

      
    }
}
