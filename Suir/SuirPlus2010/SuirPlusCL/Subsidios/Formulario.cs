using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using SuirPlus.DataBase;
using System.Data;
using Oracle.ManagedDataAccess.Client; 
namespace SuirPlus.Subsidios
{

    public class Formulario : abstractNovedad
    {
      
        public String TipoFormulario { get; set; }

        public String NroFormulario { get; set; }

        /// <summary>
        /// Propiedad que hace referencia al Medico
        /// </summary>
        public Medico Medico { get; set; }

        /// <summary>
        /// Propiedad que hace referencia a la prestadora de salud
        /// </summary>
        public Prestadora PrestadoraSalud { get; set; }

        public Int32 Pin { get; set; }

        public Byte[] Imagen { get; set; }

        public String diagnostico { get; set; }

        public String signoSintomas { get; set; }

        public String Procedimientos { get; set; }

        public DateTime fechaDiagnostico { get; set; }

        public Int32 registroPatronal { get; set; }

        public String NombreArchivo { get; set; }

        public override string GuardarCambios(string UsuarioResponsable)
        {
            throw new NotImplementedException();
        }

        public override void CargarDatos()
        {
            throw new NotImplementedException();
        }

        public static bool imprimioFormulario(Int32 NumeroSolicitud, Int32 RegistroPatronal)
        {

            OracleParameter[] parameters = new OracleParameter[3];

            parameters[0] = new OracleParameter("p_nrosolicitud", NumeroSolicitud);

            parameters[1] = new OracleParameter("p_idregistropatronal", RegistroPatronal);

            parameters[2] = new OracleParameter("p_resultnumber", OracleDbType.Varchar2, 200);
            parameters[2].Direction = ParameterDirection.InputOutput;

            var result = String.Empty;

            try
            {
                OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, "SUB_SFS_VALIDACIONES.imprimioFormulario", parameters);

                result = Convert.ToString(parameters[2].Value);

                //el formulario esta impreso//

                if (result.Equals("1"))
                {
                    return true;
                }

                return false;

            }
            catch (Exception ex)
            {

                SuirPlus.Exepciones.Log.LogToDB(ex.Message);
                throw ex;
            }
        }

        public static String RegistrarFormulario(Formulario formulario) 
        {

            OracleParameter[] parameters = new OracleParameter[23];

            parameters[0] = new OracleParameter("p_NRO_SOLICITUD", formulario.Solicitud.NroSolicitud);

            parameters[1] = new OracleParameter("p_TIPO_FORMULARIO", formulario.TipoFormulario);

            parameters[2] = new OracleParameter("p_NRO_FORMULARIO", formulario.NroFormulario);

            parameters[3] = new OracleParameter("p_ID_PSS_MED", formulario.Medico.PSS_Med);

            parameters[4] = new OracleParameter("p_NO_DOCUMENTO_MED", formulario.Medico.NoDocumentoMedico);

            parameters[5] = new OracleParameter("p_NOMBRE_MED", formulario.Medico.NombreMedico);

            parameters[6] = new OracleParameter("p_DIRECCION_MED", formulario.Medico.DireccionMedico);

            parameters[7] = new OracleParameter("p_TELEFONO_MED", formulario.Medico.TelefonoMedico);

            parameters[8] = new OracleParameter("p_CELULAR_MED", formulario.Medico.celularMedico);

            parameters[9] = new OracleParameter("p_EMAIL_MED", formulario.Medico.emailMedico);

            parameters[10] = new OracleParameter("p_ID_PSS_CEN", formulario.PrestadoraSalud.idPssCentro);

            parameters[11] = new OracleParameter("p_NOMBRE_CEN", formulario.PrestadoraSalud.nombreCentro);

            parameters[12] = new OracleParameter("p_DIRECCION_CEN", formulario.PrestadoraSalud.DireccionCentro);

            parameters[13] = new OracleParameter("p_TELEFONO_CEN", formulario.PrestadoraSalud.TelefonoCentro);

            parameters[14] = new OracleParameter("p_FAX_CEN", formulario.PrestadoraSalud.faxCentro);

            parameters[15] = new OracleParameter("p_EMAIL_CEN", formulario.PrestadoraSalud.emailCentro);

            parameters[16] = new OracleParameter("p_EXECUATUR", formulario.Medico.Exequatur);

            parameters[17] = new OracleParameter("p_ULT_USUARIO_ACT", formulario.UltimoUsrAct);

            parameters[18] = new OracleParameter("p_DIAGNOSTICO", formulario.diagnostico);

            parameters[19] = new OracleParameter("p_SIGNOS_SINTOMAS", formulario.signoSintomas);

            parameters[20] = new OracleParameter("p_PRODECIMIENTOS", formulario.Procedimientos);

            parameters[21] = new OracleParameter("p_FECHA_DIAGNOSTICO", formulario.fechaDiagnostico);

            parameters[22] = new OracleParameter("p_RESULTNUMBER", OracleDbType.Varchar2, 200);
            parameters[22].Direction = ParameterDirection.InputOutput;


            var result = String.Empty;
            var resulcargarimagen = String.Empty;

            try
            {
                OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, "SUB_SFS_NOVEDADES.crearFormulario", parameters);

                result = Utilitarios.Utils.sacarMensajeDeError(parameters[22].Value.ToString());

                return result;
            }
            catch (Exception ex)
            {
                SuirPlus.Exepciones.Log.LogToDB(ex.Message);
                return ex.Message;
            }

        }

        private static String CargaImagenFormulario(String TipoFormulario, Int32 Nro_Solicitud, Byte[] Imagen)
        {
            var v_resul = string.Empty;
            try
            {

                var Query = "Update Suirplus.SUB_FORMULARIOS_T fo Set fo.Imagen = :1 Where fo.Nro_Solicitud = :2 And Tipo_Formulario = :3;";

                OracleConnection conn = new OracleConnection(DataBase.OracleHelper.getConnString());
                OracleCommand comm = new OracleCommand(Query, conn);
                comm.CommandType = CommandType.Text;

                comm.Parameters.Add("p_Imagen", Oracle.ManagedDataAccess.Client.OracleDbType.Blob, ParameterDirection.Input).Value = Imagen;
                comm.Parameters.Add("p_nro_solicitud", Oracle.ManagedDataAccess.Client.OracleDbType.Int32, ParameterDirection.Input).Value = Nro_Solicitud;
                comm.Parameters.Add("p_tipo_formulario", Oracle.ManagedDataAccess.Client.OracleDbType.Varchar2, ParameterDirection.Input).Value = TipoFormulario;

                comm.Connection.Open();
                comm.ExecuteNonQuery();
                comm.Connection.Close();

                v_resul = "OK";
            }

            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                v_resul = ex.Message;

                return v_resul;
            }

            return v_resul;


        }
        
       
    }

}
