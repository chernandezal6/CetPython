using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using Oracle.ManagedDataAccess.Client;
using Oracle.ManagedDataAccess.Types;
using SuirPlus.DataBase;
namespace SuirPlus.Subsidios
{
    public class Lactante : abstractNovedad
    {
        public Int32? NSSLactante {get; set;}

        public String  NUI {get; set;}

        public Int32  SecuenciaLactante { get; set; }

        public string Nombres { get; set; }
        
        public String PrimerApellido {get; set;}

        public String SegundoApellido {get; set; }

        public String Sexo { get; set; }

        public DateTime? FechaNacimiento { get; set; }

        public Int32  CantidadLactante { get; set; }
        
        public DateTime? FechaCancelacion { get; set; }
        
        public DateTime? fechaDefuncion { get; set; }

        public Int32 RegistroPatronalNC { get; set; }
        public String usuarioNC { get; set; }
        public DateTime fechaRegistroNC { get; set; }


        public Int32? RegistroPatronalML { get; set; }
        public String usuarioML { get; set; }
        public DateTime? fechaRegistroML { get; set; }

        public String modo { get; set; }

        /// <summary>
        /// Metodo para registrar el Subsidio de lactancia
        /// </summary>
        /// <param name="NSS">NSS de la madre</param>
        /// <param name="RegistroPatronal">Registro Patronal que esta haciendo el registro</param>
        /// <param name="CantidadLactante">Cantidad de niños nacidos en el reporte de nacimiento</param>
        /// <param name="FechaNacimiento">Fecha de nacimiento del reporte de nacimiento</param>
        /// <returns></returns>
        public static String RegistrarNacimiento(Int32 NSS, 
                                                 Int32 RegistroPatronal,
                                                 Int32 CantidadLactante, 
                                                 DateTime FechaNacimiento,
                                                 String retroactiva, 
                                                 String NroSolicitudMat,
                                                 String Modo,
                                                 ref String NroSolicitud) 

        {


           if (!Validaciones.esValidoNSS(NSS))
            {
                return "NSS Invalido";
            }

            if (FechaNacimiento > DateTime.Now)
            {
                return "La fecha de nacimiento no puede ser futura.";
            }
            if (CantidadLactante > 8)
            {
                return "La cantidad de lactante debe ser menor o igual a 8.";
            }

            OracleParameter[] parameters = new OracleParameter[9];

            parameters[0] = new OracleParameter("p_ID_NSS", NSS);

            parameters[1] = new OracleParameter("p_ID_REGISTRO_PATRONAL", RegistroPatronal);

            parameters[2] = new OracleParameter("p_cant_lactantes", CantidadLactante);

            parameters[3] = new OracleParameter("p_fecha_nacimiento", FechaNacimiento);

            //Parametro que indica si esta perdida se esta registrando en un reporte de embarazo retroactivo
            parameters[4] = new OracleParameter("p_esRetroativa", retroactiva);

            //Nro de Solicitud correspondiente a la maternidad.
            parameters[5] = new OracleParameter("P_NRO_SOLICITUD_MAT", NroSolicitudMat);

            parameters[6] = new OracleParameter("p_nro_solicitud", OracleDbType.Varchar2,200);
            parameters[6].Value = NroSolicitud;
            parameters[6].Direction = ParameterDirection.InputOutput;


            parameters[7] = new OracleParameter("P_MODO", OracleDbType.Varchar2, 1);
            parameters[7].Value = Modo;

            parameters[8] = new OracleParameter("p_RESULTNUMBER", OracleDbType.Varchar2, 200);
            parameters[8].Direction = ParameterDirection.InputOutput;

            try
            {
                OracleHelper.ExecuteNonQuery(System.Data.CommandType.StoredProcedure, "SUB_SFS_NOVEDADES.crearNacimiento", parameters);

                var result = Utilitarios.Utils.sacarMensajeDeError(parameters[8].Value.ToString());

                NroSolicitud = parameters[6].Value.ToString();

                return result;

            }
            catch (Exception ex)
            {

                SuirPlus.Exepciones.Log.LogToDB(ex.Message);
                return ex.ToString() + "Error:" + parameters[5].Value.ToString(); 
            } 

        }
        /// <summary>
        /// Metodo para crear los lactantes
        /// </summary>
        /// <param name="lactate">Lactante que desea agregar.</param>
        /// <returns>Retorna "OK" si el lactante se registro correctamente en caso contrario devolvera el mensaje de error.</returns>
        /// 
        public static String crearLactantes(Lactante lactate) 
        {
            if (!Validaciones.esValidoNSS(lactate.NSS))
            {
                return "NSS Invalido";
            }
            if (String.IsNullOrEmpty(lactate.Nombres))
            {
                return "El nombre del lactate es requerido.";
            }

            if (String.IsNullOrEmpty(lactate.PrimerApellido ))
	        {
		        return "El primer apellido del lactante es requerido";
	        }

            
            OracleParameter[] parameters = new OracleParameter[12];

            parameters[0] = new OracleParameter("p_ID_NSS_LACTANTE", lactate.NSSLactante);

            parameters[1] = new OracleParameter("p_NUI", lactate.NUI);

            parameters[2] = new OracleParameter("p_NOMBRES", lactate.Nombres);

            parameters[3] = new OracleParameter("p_PRIMER_APELLIDO", lactate.PrimerApellido);

            parameters[4] = new OracleParameter("p_SEGUNDO_APELLIDO", lactate.SegundoApellido);

            parameters[5] = new OracleParameter("p_SEXO", lactate.Sexo);

            parameters[6] = new OracleParameter("p_ULT_USUARIO_ACT", lactate.UltimoUsrAct);

            parameters[7] = new OracleParameter("p_ID_REGISTRO_PATRONAL_NC", lactate.RegistroPatronalNC);

            //Parametro que indica si esta perdida se esta registrando en un reporte de embarazo retroactivo
            parameters[8] = new OracleParameter("p_esRetroativa", lactate.Retroactiva);

            parameters[9] = new OracleParameter("p_nro_solicitud ", lactate.Solicitud.NroSolicitud);

            parameters[10] = new OracleParameter("p_Modo", lactate.modo);
            
            parameters[11] = new OracleParameter("p_RESULTNUMBER", OracleDbType.Varchar2, 200);
            parameters[11].Direction = ParameterDirection.InputOutput;

            try 
	        {	        
		        OracleHelper.ExecuteNonQuery(System.Data.CommandType.StoredProcedure,"SUB_SFS_NOVEDADES.crearLactantes",parameters);  

                var result = Utilitarios.Utils.sacarMensajeDeError(parameters[11].Value.ToString());
 
                return result;
	        }
	        catch (Exception ex)
	        {
		
		        SuirPlus.Exepciones.Log.LogToDB(ex.Message);
                return ex.Message;
	        }

      }

        /// <summary>
        /// Metodo para hacer el registro de la muerte del lactante
        /// </summary>
        /// <param name="NSS">NSS de la madre que le falleció el lactante</param>
        /// <param name="RegistroPatronalMuerte">Registro Patronal que esta registrando la muerte de lactante</param>
        /// <param name="FechaMuerte">Fecha en que murio el lacante</param>
        /// <param name="UsuarioMuerteLactante">Usuario que esta registrando la muerte de lactante </param>
        /// <returns></returns>
        public static String RegistrarMuerteLactante(Int32 NSS, Int32 RegistroPatronalMuerte, DateTime FechaMuerte, Int32 IdLactante, String UsuarioMuerteLactante) 
        {
            
            OracleParameter[] parameters = new OracleParameter[6];

            parameters[0] = new OracleParameter("p_ID_NSS", NSS);

            parameters[1] = new OracleParameter("p_ID_REGISTRO_PATRONAL", RegistroPatronalMuerte);

            parameters[2] = new OracleParameter("p_IdLactante", IdLactante);
            
            parameters[3] = new OracleParameter("p_fecha_muerte_lactante", FechaMuerte);
            
            parameters[4] = new OracleParameter("p_ULT_USUARIO_ACT", UsuarioMuerteLactante);

            parameters[5] = new OracleParameter("p_RESULTNUMBER", OracleDbType.Varchar2, 255);
            parameters[5].Direction = ParameterDirection.Output;


            try
            {
                OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, "SUB_SFS_NOVEDADES.crearMuerteLactante", parameters);

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
        /// Metodo para obtener los datos generales de un lactante
        /// </summary>
        /// <param name="NSSLactante">NSS del lactante del que desea ver los datos generales</param>
        /// <returns></returns>
        public static Lactante ObtenerDatosLactate(Int32 NSSLactante) 
        {
                        
            OracleParameter[] parameters = new OracleParameter[3];  
            
            parameters[0] = new OracleParameter("p_id_nss", NSSLactante);

            parameters[1] = new OracleParameter("P_IOCURSOR", OracleDbType.RefCursor);
            parameters[1].Direction = ParameterDirection.Output;

            parameters[2] = new OracleParameter("p_result_number",OracleDbType.Varchar2,200);
            parameters[2].Direction = ParameterDirection.Output;

            try
            {
                var lactante = OracleHelper.ExecuteDataset(CommandType.StoredProcedure,"SUB_SFS_SUBSIDIOS.ObtenerDatosLactante",parameters).Tables[0];

                if (lactante.Rows.Count > 0)
                {
                    var milactante = new Lactante()
                    {
                        Nombres = lactante.Rows[0].Field<String>("NOMBRES"),
                        PrimerApellido = lactante.Rows[0].Field<String>("PRIMER_APELLIDO"),
                        SegundoApellido = lactante.Rows[0].Field<String>("SEGUNDO_APELLIDO"),
                        NSSLactante = Convert.ToInt32(lactante.Rows[0]["NSS"]),
                        NUI = lactante.Rows[0].Field<String>("NUI"),
                        Sexo = lactante.Rows[0].Field<String>("SEXO")
                    };
                    return milactante;
                }
                
                    SuirPlus.Subsidios.Lactante lac = null;

                    return lac;

               
            }
            catch (Exception ex)
            {
                SuirPlus.Exepciones.Log.LogToDB(ex.Message);  
                throw ex;
            }
        }

        /// <summary>
        /// Metodo para Deshacer el nacimiento si ocurre un error durante el registro de los lactantes
        /// </summary>
        /// <param name="NroSolicitud">Nro de la solicitud del nacimiento que desea deshacer</param>
        /// <returns></returns>
        public static String DeshacerNacimiento(Int32 NroSolicitud) 
        {
            OracleParameter[] parameters = new OracleParameter[2];

            parameters[0] = new OracleParameter("p_nroSolicitud", NroSolicitud);

            parameters[1] = new OracleParameter("p_RESULTNUMBER", OracleDbType.Varchar2, 200);
            parameters[1].Direction = ParameterDirection.Output;

            try
            {
                OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, "SUB_SFS_NOVEDADES.EliminarLactancia", parameters);
                
                var result = SuirPlus.Utilitarios.Utils.sacarMensajeDeError(Convert.ToString(parameters[1].Value));

                return result;

            }
            catch (Exception ex)
            {
                SuirPlus.Exepciones.Log.LogToDB(ex.Message);  
                throw ex;
            }
        }

        
               
        public static DataTable ObtenerLactantes(Int32 nss) 
        {
            OracleParameter[] parameters = new OracleParameter[3];

            parameters[0] = new OracleParameter("p_ID_NSS", nss);

            parameters[1] = new OracleParameter("p_ioursor", OracleDbType.RefCursor);
            parameters[1].Direction = ParameterDirection.Output;

            parameters[2] = new OracleParameter("p_RESULTNUMBER", OracleDbType.Varchar2, 200);
            parameters[2].Direction = ParameterDirection.Output;

            try
            {
                var dt = OracleHelper.ExecuteDataset(CommandType.StoredProcedure, "SUB_SFS_NOVEDADES.getLactantes", parameters).Tables[0];

                return dt;
     
            }
            catch (Exception ex)
            {
                SuirPlus.Exepciones.Log.LogToDB(ex.Message); 
                throw ex;
            }
        }


        public static DataTable getLactates(Int32 IdLactancia, out String result)
        {
            OracleParameter[] parameters = new OracleParameter[3];

            parameters[0] = new OracleParameter("p_id_sub_lactancia", IdLactancia);

            parameters[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            parameters[1].Direction = ParameterDirection.Output;

            parameters[2] = new OracleParameter("p_RESULTNUMBER", OracleDbType.Varchar2, 200);
            parameters[2].Direction = ParameterDirection.Output;

            try
            {
                var mat = OracleHelper.ExecuteDataset(System.Data.CommandType.StoredProcedure, "SUB_SFS_NOVEDADES.getLactancia", parameters);

                result = Utilitarios.Utils.sacarMensajeDeError(parameters[2].Value.ToString());

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

                        
      
   }

    public struct DetalleLactante
    {
        public Int32 IdLactante { get; set; }

        public Int32? NSSLactante {get; set;}

        public Int32 NroSolicitud { get; set; }

        public String NUI {get; set;}

        public Int32  SecuenciaLactante { get; set; }

        public string Nombres { get; set; }

        public DateTime? FechaNacimiento { get; set; }
        
        public String PrimerApellido {get; set;}

        public String SegundoApellido {get; set; }

        public String Sexo { get; set; }

        public Int32 CantidadLactante { get; set; }
                
        public String UltUsuarioAct { get; set; }

        public Int32 RegistroPatronal { get; set; }

        public String Estatus { get; set; }

        public String NroDocumentoMadre { get; set; }

        public Int32 NroSolicitudMaternidad  { get; set; }


    }
}
