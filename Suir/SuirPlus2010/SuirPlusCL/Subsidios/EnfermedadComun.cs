
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Oracle.ManagedDataAccess.Client;
using SuirPlus.Utilitarios;
using SuirPlus.Exepciones;
using SuirPlus.DataBase;
using Oracle.ManagedDataAccess;
using System.Data;

namespace SuirPlus.Subsidios
{
    /// <summary>
    /// Objeto para manejar las operaciones sobre una entidad Enfermedad Comun
    /// </summary>
    public class EnfermedadComun : abstractNovedad
    {
        
        public int NroSolicitud { get; set; }
       
        //Datos Generales
        public String Direccion { get; set; }
        public String Telefono { get; set; }
        public String Correo { get; set; }
        public String Celular { get; set; }
       
        public String TipoDiscapacidad { get; set; }
        
        // Datos Ambulatorio//
        public String Ambulatorio { get; set; }
        public DateTime FechaInicioAmbulatorio { get; set; }
        public Int32 DiasCalendarioAmbulatorio { get; set; }
        
        // Datos Hospitalario//
        public String Hospitalizado { get; set; }
        public DateTime FechaInicioHospitalizado { get; set; }
        public Int32 DiasCalendarioHospitalizado { get; set; }


        public String CodigoCie10 { get; set; }
        public Int32? Pin { get; set; }
        public String Completado { get; set; }
        public Int32? Padecimiento { get; set; }
        public String CategoriaSalario { get; set; }
        public String NoDocumento { get; set; }
      

        /// <summary>
        /// 
        /// </summary>
        /// <param name="nroSolicitud"></param>
        public EnfermedadComun(Int32 nroSolicitud) 
        {
            NroSolicitud = nroSolicitud;
            this.CargarDatosIniciales();
        }

        public EnfermedadComun() { }

        /// <summary>
        /// Metodo para registrar los datos iniciales de un Subsidio de ENF. Comun.
        /// </summary>
        /// <param name="Direccion">Direccion</param>
        /// <param name="Telefono">Telefono</param>
        /// <param name="Correo">Correo</param>
        /// <param name="Celular">Celular</param>
        /// <returns>Un String con el resultado.</returns>
        public static String RegistrarDatosIniciales(Int32 Nss, String TipoSolicitud, String numeroSolicitud, String Direccion, String Telefono, String Correo, String Celular, String Usuario,
                                                     ref String Pin, ref String NroSolicitud, ref String NroFormulario) 
        {
            var resultado = String.Empty;

            OracleParameter[] arrParam = new OracleParameter[11];

            arrParam[0] = new OracleParameter("p_id_nss", OracleDbType.Int32);
            arrParam[0].Value = Nss;

            arrParam[1] = new OracleParameter("p_tipo_solicitud", OracleDbType.NVarchar2, 20);
            arrParam[1].Value = TipoSolicitud;

            arrParam[2] = new OracleParameter("p_direccion", OracleDbType.NVarchar2, 200);
            arrParam[2].Value = Direccion;

            arrParam[3] = new OracleParameter("p_telefono", OracleDbType.NVarchar2, 10);
            arrParam[3].Value = Telefono;

            arrParam[4] = new OracleParameter("p_correo", OracleDbType.NVarchar2, 200);
            arrParam[4].Value = Correo;

            arrParam[5] = new OracleParameter("p_celular", OracleDbType.NVarchar2, 10);
            arrParam[5].Value = Celular;

            arrParam[6] = new OracleParameter("p_usuario_registro", OracleDbType.NVarchar2, 35);
            arrParam[6].Value = Usuario;

            arrParam[7] = new OracleParameter("p_pin", OracleDbType.NVarchar2, 4);
            arrParam[7].Direction = ParameterDirection.Output;

            arrParam[8] = new OracleParameter("p_nro_solicitud", OracleDbType.NVarchar2, 10);
            arrParam[8].Direction = ParameterDirection.InputOutput;

            if (!numeroSolicitud.Equals(string.Empty))
            {
                arrParam[8].Value = numeroSolicitud;
            }

            arrParam[9] = new OracleParameter("p_nro_formulario", OracleDbType.NVarchar2, 18);
            arrParam[9].Direction = ParameterDirection.InputOutput;

            arrParam[10] = new OracleParameter("p_result", OracleDbType.NVarchar2, 200);
            arrParam[10].Direction = ParameterDirection.Output;


            string cmdStri = "SUB_SFS_NOVEDADES.RegistrarDatosInicialesEnf";

            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStri, arrParam);

                resultado = Utilitarios.Utils.sacarMensajeDeError(arrParam[10].Value.ToString());

                Pin = arrParam[7].Value.ToString();

                NroSolicitud = arrParam[8].Value.ToString();
          
                NroFormulario = arrParam[9].Value.ToString(); 

                return resultado;
            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                return ex.ToString(); 
            }
        }

        /// <summary>
        /// Metodo para completar los datos del registro.
        /// </summary>
        /// <param name="enfComun">Objeto de Enfermedad Común que va hacer completado</param>
        /// <param name="formulario">Objeto formulario relacionado con este registro de Enfermedad Común</param>
        /// <returns></returns>
        public static String CompletarRegistro(EnfermedadComun enfComun, Formulario formulario, String Modo) 
        {
            OracleParameter[] parameters = new OracleParameter[38];

            parameters[0] = new OracleParameter("p_id_nss", enfComun.NSS);

            parameters[1] = new OracleParameter("p_Nro_Solicitud", enfComun.Solicitud.NroSolicitud);

            parameters[2] = new OracleParameter("p_Direccion", enfComun.Direccion);
            
            parameters[3] = new OracleParameter("p_Telefono", enfComun.Telefono);
            
            parameters[4] = new OracleParameter("p_Email", enfComun.Correo);
           
            parameters[5] = new OracleParameter("p_Celular", enfComun.Celular);
        
            parameters[6] = new OracleParameter("p_ult_usuario",enfComun.UltimoUsrAct);
         
            parameters[7] = new OracleParameter("p_id_pss_med", formulario.Medico.PSS_Med);
           
            parameters[8] = new OracleParameter("p_no_documento_med", formulario.Medico.NoDocumentoMedico);
          
            parameters[9] = new OracleParameter("p_Nombre_med", formulario.Medico.NombreMedico);
           
            parameters[10] = new OracleParameter("p_Direccion_med",formulario.Medico.DireccionMedico);
           
            parameters[11] = new OracleParameter("p_Telefono_med",formulario.Medico.TelefonoMedico);
         
            parameters[12] = new OracleParameter("p_celular_med", formulario.Medico.celularMedico);
           
            parameters[13] = new OracleParameter("p_Email_med",formulario.Medico.emailMedico);
            
            parameters[14] = new OracleParameter("p_id_pss_cen", formulario.PrestadoraSalud.idPssCentro);

            parameters[15] = new OracleParameter("p_nombre_cen", formulario.PrestadoraSalud.nombreCentro);
          
            parameters[16] = new OracleParameter("p_Direccion_cen", formulario.PrestadoraSalud.DireccionCentro);
            
            parameters[17] = new OracleParameter("p_Telefono_cen", formulario.PrestadoraSalud.TelefonoCentro);
            
            parameters[18] = new OracleParameter("p_Fax_cen", formulario.PrestadoraSalud.faxCentro);

            parameters[19] = new OracleParameter("p_Email_cen", formulario.PrestadoraSalud.emailCentro);
            
            parameters[20] = new OracleParameter("p_Tipo_Discapacidad", enfComun.TipoDiscapacidad);
            
            parameters[21] = new OracleParameter("p_Diagnostico", formulario.diagnostico);
            
            parameters[22] = new OracleParameter("p_Signos_Sintomas", formulario.signoSintomas);

            parameters[23] = new OracleParameter("p_Procedimientos", formulario.Procedimientos);
            
            parameters[24] = new OracleParameter("p_Ambulatorio", enfComun.Ambulatorio);

            parameters[25] = new OracleParameter("p_Fecha_Inicio_amb", OracleDbType.Date);

            if ( enfComun.FechaInicioAmbulatorio.Equals(DateTime.MinValue))
                parameters[25].Value = DBNull.Value;
            else 
                parameters[25].Value = enfComun.FechaInicioAmbulatorio;  
	       
	       
            parameters[26] = new OracleParameter("p_dias_cal_amb", enfComun.DiasCalendarioAmbulatorio);
                                
            parameters[27] = new OracleParameter("p_Hospitalario", enfComun.Hospitalizado);

            parameters[28] = new OracleParameter("p_Fecha_inicio_hos", OracleDbType.Date);

            if (enfComun.FechaInicioHospitalizado.Equals(DateTime.MinValue))
                parameters[28].Value = DBNull.Value;
            else
                parameters[28].Value = enfComun.FechaInicioHospitalizado;

            
            parameters[29] = new OracleParameter("p_dias_cal_hos", enfComun.DiasCalendarioHospitalizado);
            
            parameters[30] = new OracleParameter("p_Fecha_Diagnostico", formulario.fechaDiagnostico);

            parameters[31] = new OracleParameter("p_id_registro_patronal", enfComun.RegistroPatronal);
                     
            parameters[32] = new OracleParameter("p_id_usuario", enfComun.UltimoUsrAct);
            
            parameters[33] = new OracleParameter("p_Codigo_CIE10", enfComun.CodigoCie10);

            parameters[34] = new OracleParameter("p_Exequatur", formulario.Medico.Exequatur);
         
            parameters[35] = new OracleParameter("p_Id_Nomina", enfComun.Solicitud.Nomina);

            parameters[36] = new OracleParameter("p_modo", Modo);
          
            parameters[37] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            parameters[37].Direction = ParameterDirection.InputOutput;

            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, "SUB_SFS_NOVEDADES.RegistroEnfComun", parameters);
                
                string respuesta = Utilitarios.Utils.sacarMensajeDeError(parameters[37].Value.ToString());

                return respuesta;

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
        public void CargarDatosIniciales()
        {
            OracleParameter[] parameters = new OracleParameter[3];

            parameters[0] = new OracleParameter("p_nro_solicitud", this.NroSolicitud);

            parameters[1] = new OracleParameter("p_resultnumber", OracleDbType.Varchar2, 200);
            parameters[1].Direction = ParameterDirection.InputOutput;

            parameters[2] = new OracleParameter("p_io_cursor", OracleDbType.RefCursor);
            parameters[2].Direction = ParameterDirection.InputOutput;

            try
            {
                var ds = OracleHelper.ExecuteDataset(System.Data.CommandType.StoredProcedure, "SUB_SFS_SUBSIDIOS.ObtenerDatosIniciales", parameters);
                
                if (ds.Tables[0].Rows.Count > 0)
	            {
                    this.Direccion = ds.Tables[0].Rows[0]["direccion"].ToString();
                    this.Telefono = ds.Tables[0].Rows[0]["telefono"].ToString();
                    this.Celular = ds.Tables[0].Rows[0]["celular"].ToString();
                    this.Correo = ds.Tables[0].Rows[0]["email"].ToString();
	            }
            }
            catch (Exception ex)
            {
                SuirPlus.Exepciones.Log.LogToDB(ex.ToString());  
                throw ex;
            }
        }

        /// <summary>
        /// Metodo para obtener los padecimientos completados de un afiliado(a)
        /// </summary>
        /// <param name="nss">nss de la afiliado(a)</param>
        /// <param name="registropatronal">registro patronal del empleador.</param>
        /// <returns></returns>
        public static List<DetalleEnfermedadComun> ObtenerPadecimientosCompletados(Int32 nss, Int32 registropatronal) 
        {
            var result = new List<DetalleEnfermedadComun>();

            OracleParameter[] parameters = new OracleParameter[4];

            parameters[0] = new OracleParameter("p_id_nss", nss);

            parameters[1] = new OracleParameter("p_id_registro_patronal", registropatronal);

            parameters[2] = new OracleParameter("p_io_cursor", OracleDbType.RefCursor);
            parameters[2].Direction = ParameterDirection.Output;

            parameters[3] = new OracleParameter("p_resultnumber", OracleDbType.Varchar2, 200);
            parameters[3].Direction = ParameterDirection.Output;

           
            //try
            //{


                var nominas = OracleHelper.ExecuteDataset(System.Data.CommandType.StoredProcedure, "SUB_SFS_NOVEDADES.ObtenerPadecimientoCompletado", parameters).Tables[0].AsEnumerable();

                foreach (var item in nominas)
                {
                    result.Add(new DetalleEnfermedadComun()
                    {
                        NroSolicitud = Convert.ToDecimal(item.Field<Int64>("nro_solicitud")),
                        NroFormulario = item.Field<String>("nro_formulario"),
                        FechaRegistro = item.Field<DateTime>("fecha_registro"),
                        Diagnostico = item.Field<String>("diagnostico"),
                    });
                }


                return result;
            //}
            //catch (Exception ex)
            //{
            //    SuirPlus.Exepciones.Log.LogToDB(ex.ToString());
            //    throw ex;
            //}
        }

        public static DatosReitengo MostrarDatosReintegro(Int32 NroSolicitud)
        {
            
           
            OracleParameter[] parameters = new OracleParameter[3];

            parameters[0] = new OracleParameter("p_nro_solicitud", NroSolicitud);

            parameters[1] = new OracleParameter("p_io_cursor", OracleDbType.RefCursor);
            parameters[1].Direction = ParameterDirection.Output;

            parameters[2] = new OracleParameter("p_resultnumber", OracleDbType.Varchar2, 200);
            parameters[2].Direction = ParameterDirection.Output;

            try
            {

                var datosreitengo = OracleHelper.ExecuteDataset(System.Data.CommandType.StoredProcedure, "SUB_SFS_NOVEDADES.MostrarDatosReintegro", parameters).Tables[0];


                var result = new DatosReitengo()
                    {
                        NroFormulario = datosreitengo.Rows[0].Field<String>("nro_formulario"),
                        DiasCalendario = datosreitengo.Rows[0].Field<Decimal>("dias_calendario"),
                        FechaInicioLicencia = datosreitengo.Rows[0].Field<DateTime>("fecha_inicio"),
                        FechaFinLicencia = datosreitengo.Rows[0].Field<DateTime>("fecha_fin")

                    };
                               
                return result;
            }
            catch (Exception ex)
            {

                throw ex;
            }

        }


        public static String RecibirDatosReintegro(Int32 NroSolicitud, DateTime FechaReintegro, String Usuario, Int32 RegistroPatronal) 
        {
            OracleParameter[] parameters = new OracleParameter[5];

            parameters[0] = new OracleParameter("p_nro_solicitud", NroSolicitud);

            parameters[1] = new OracleParameter("p_fecha_reintegro", FechaReintegro);

            parameters[2] = new OracleParameter("p_usuario", Usuario);

            parameters[3] = new OracleParameter("p_id_reg_pat", RegistroPatronal);

            parameters[4] = new OracleParameter("p_resultnumber", OracleDbType.Varchar2, 200);
            parameters[4].Direction = ParameterDirection.Output;


            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, "SUB_SFS_NOVEDADES.RecibirDatosReintegro", parameters);

                var result = Utilitarios.Utils.sacarMensajeDeError(parameters[4].Value.ToString());

                return result;
            }
            catch (Exception ex)
            {

                throw ex;
            }
        }
       

        public static String ConvalidarPadecimiento(Int32 NroSolicitud, Int32 RegistroPatronal, String Usuario, Int32 IdNomina) 
        {
           
            OracleParameter[] parameters = new OracleParameter[5];

            parameters[0] = new OracleParameter("p_nro_solicitud", NroSolicitud);

            parameters[1] = new OracleParameter("p_id_registro_patronal", RegistroPatronal);

            parameters[2] = new OracleParameter("p_Id_Nomina", IdNomina);
            
            parameters[3] = new OracleParameter("p_usuario", Usuario);
               
            parameters[4] = new OracleParameter("p_resultnumber", OracleDbType.Varchar2, 200);
            parameters[4].Direction = ParameterDirection.Output;

            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, "SUB_SFS_NOVEDADES.ConvalidarPadecimiento", parameters);

                var result = Utilitarios.Utils.sacarMensajeDeError(parameters[4].Value.ToString());

                return result;
            }
            catch (Exception ex)
            {
                SuirPlus.Exepciones.Log.LogToDB(ex.ToString());
                throw ex;
            }
        }

      

         public static List<DetalleEnfermedadComun> PadecimientosAConvalidar(Int32 nss, Int32 registropatronal)
        {
            var result = new List<DetalleEnfermedadComun>();

            OracleParameter[] parameters = new OracleParameter[4];

            parameters[0] = new OracleParameter("p_id_nss", nss);

            parameters[1] = new OracleParameter("p_id_registro_patronal", registropatronal);

            parameters[2] = new OracleParameter("p_io_cursor", OracleDbType.RefCursor);
            parameters[2].Direction = ParameterDirection.Output;

            parameters[3] = new OracleParameter("p_resultnumber", OracleDbType.Varchar2, 200);
            parameters[3].Direction = ParameterDirection.Output;


            try
            {


                var nominas = OracleHelper.ExecuteDataset(System.Data.CommandType.StoredProcedure, "SUB_SFS_NOVEDADES.PadecimientosaConvalidar", parameters).Tables[0];

                foreach (DataRow p in nominas.Rows)
                {
                    result.Add(new DetalleEnfermedadComun()
                    {
                        NroSolicitud = Convert.ToDecimal(p.Field<Object>("nro_solicitud")),
                        NroFormulario = p.Field<String>("nro_formulario"),
                        FechaRegistro = p.Field<DateTime>("fecha_registro"),
                        Diagnostico =   p.Field<String>("diagnostico"),
                    });
                }

                return result;

            }
            catch (Exception ex)
            {
                SuirPlus.Exepciones.Log.LogToDB(ex.ToString());
                throw ex;
            }
        }

        /// <summary>
        /// Metodo para obtener el detalle de un subsidio de enfermedad comun
        /// </summary>
        /// <param name="IdEnfermedadComun">id de la enf. comun.</param>
        /// <returns></returns>
         public static DataTable TraerEnfermedadComun(Int32 IdEnfermedadComun, Int32 registropatronal, out String result) 
         {
             OracleParameter[] parameters = new OracleParameter[4];

             parameters[0] = new OracleParameter("p_id_enfermedad_comun", IdEnfermedadComun);

             parameters[1] = new OracleParameter("p_id_registropatronal", registropatronal);

             parameters[2] = new OracleParameter("p_io_cursor", OracleDbType.RefCursor);
             parameters[2].Direction = ParameterDirection.Output;

             parameters[3] = new OracleParameter("p_resultnumber", OracleDbType.Varchar2, 200);
             parameters[3].Direction = ParameterDirection.Output;

             try
             {


                 var enf = OracleHelper.ExecuteDataset(System.Data.CommandType.StoredProcedure, "SUB_SFS_NOVEDADES.getEnfermedadComun", parameters);

                 result = Utilitarios.Utils.sacarMensajeDeError(parameters[3].Value.ToString());

                 if (result.Equals("OK"))
	                {
		               return enf.Tables[0];     
	                }
                 
                  return new DataTable("No hay datos que mostra."); 
                 
                 
             }
             catch (Exception ex)
             {

                 throw ex;
             }
         }

         }

    }

    public struct DetalleEnfermedadComun 
    {
        public Decimal NroSolicitud { get; set; }
        public String NroFormulario { get; set; }
        public DateTime FechaRegistro { get; set; }
        public String Diagnostico { get; set; }
    }
    public struct DatosReitengo
    {
        public string NroFormulario { get; set; }
        public DateTime FechaInicioLicencia { get; set; }
        public DateTime FechaFinLicencia { get; set; }
        public Decimal DiasCalendario { get; set; }
    }

