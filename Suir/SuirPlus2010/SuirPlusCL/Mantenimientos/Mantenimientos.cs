
using System;
using System.Data;
using Oracle.ManagedDataAccess.Client;
using System.Configuration;

namespace SuirPlus.Mantenimientos
{
    public class Mantenimientos
    {

        /// <summary>
        /// Procedimiento utilizado para registrar un ciudadano.
        /// </summary>

        /// <remarks>Creado por Charlie L. Peña</remarks>

        public static void RegistroCiudadano(string nombres, string primerApellido, string segundoApellido, string estadoCivil, string fechaNacimiento, string cedula, string sexo,
                                                  string idProvincia, string idTipoSangre, string idNacionalidad, string padre, string madre, string idMunicipio, string oficialia, string libro,
                                                  string folio, string nroActa, string anoActa, string cedulaAnt, string usuarioAct, Byte[] imagenActa)
        {
            OracleParameter[] arrParam = new OracleParameter[22];

            arrParam[0] = new OracleParameter("p_nombres", OracleDbType.NVarchar2, 50);
            arrParam[0].Value = nombres;

            arrParam[1] = new OracleParameter("p_primer_apellido", OracleDbType.NVarchar2, 40);
            arrParam[1].Value = primerApellido;

            arrParam[2] = new OracleParameter("p_segundo_apellido", OracleDbType.NVarchar2, 40);
            arrParam[2].Value = segundoApellido;

            arrParam[3] = new OracleParameter("p_estado_civil", OracleDbType.NVarchar2, 1);
            arrParam[3].Value = estadoCivil;

            arrParam[4] = new OracleParameter("p_fecha_nacimiento", OracleDbType.Date);
            arrParam[4].Value = Convert.ToDateTime(fechaNacimiento);

            arrParam[5] = new OracleParameter("p_no_documento", OracleDbType.NVarchar2, 11);
            arrParam[5].Value = cedula;

            arrParam[6] = new OracleParameter("p_sexo", OracleDbType.NVarchar2, 1);
            arrParam[6].Value = sexo;

            arrParam[7] = new OracleParameter("p_id_provincia", OracleDbType.NVarchar2, 6);
            arrParam[7].Value = idProvincia;

            arrParam[8] = new OracleParameter("p_id_tipo_sangre", OracleDbType.NVarchar2, 4);
            arrParam[8].Value = idTipoSangre;

            arrParam[9] = new OracleParameter("p_id_nacionalidad", OracleDbType.NVarchar2, 3);
            arrParam[9].Value = idNacionalidad;

            arrParam[10] = new OracleParameter("p_nombre_padre", OracleDbType.NVarchar2, 40);
            arrParam[10].Value = padre;

            arrParam[11] = new OracleParameter("p_nombre_madre", OracleDbType.NVarchar2, 40);
            arrParam[11].Value = madre;

            arrParam[12] = new OracleParameter("p_municipio_acta", OracleDbType.NVarchar2, 6);
            arrParam[12].Value = idMunicipio;

            arrParam[13] = new OracleParameter("p_oficialia_acta", OracleDbType.NVarchar2, 10);
            arrParam[13].Value = oficialia;

            arrParam[14] = new OracleParameter("p_libro_acta", OracleDbType.NVarchar2, 10);
            arrParam[14].Value = libro;

            arrParam[15] = new OracleParameter("p_folio_acta", OracleDbType.NVarchar2, 10);
            arrParam[15].Value = folio;

            arrParam[16] = new OracleParameter("p_numero_acta", OracleDbType.NVarchar2, 10);
            arrParam[16].Value = nroActa;

            arrParam[17] = new OracleParameter("p_ano_acta", OracleDbType.NVarchar2, 4);
            arrParam[17].Value = anoActa;

            arrParam[18] = new OracleParameter("p_cedula_anterior", OracleDbType.NVarchar2, 11);
            arrParam[18].Value = cedulaAnt;

            arrParam[19] = new OracleParameter("p_ult_usuario_act", OracleDbType.NVarchar2, 35);
            arrParam[19].Value = usuarioAct;

            arrParam[20] = new OracleParameter("p_ImagenActa", OracleDbType.Blob);
            arrParam[20].Value = imagenActa;

            
            arrParam[21] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[21].Direction = ParameterDirection.Output;

            String cmdStr = "Sre_Ciudadano_Pkg.crearCiudadano";
            string result = string.Empty;

            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                result = arrParam[21].Value.ToString();

                if (result != "0")
                {
                    string[] ErrorMsg = result.Split('|');
                    throw new Exception(ErrorMsg[1]);
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


        public static void RegistroCiudadano2(string nombres, string primerApellido, string segundoApellido, string fechaNacimiento, string sexo, string cedula,
                                                   string tipoDocumento, string usuario)
        {

            OracleParameter[] arrParam = new OracleParameter[9];

            arrParam[0] = new OracleParameter("p_nombres", OracleDbType.NVarchar2, 50);
            arrParam[0].Value = nombres;


            arrParam[1] = new OracleParameter("p_primer_apellido", OracleDbType.NVarchar2, 40);
            arrParam[1].Value = primerApellido;

            arrParam[2] = new OracleParameter("p_segundo_apellido", OracleDbType.NVarchar2, 40);
            arrParam[2].Value = segundoApellido;


            arrParam[3] = new OracleParameter("p_fecha_nacimiento", OracleDbType.Date);
            arrParam[3].Value = Convert.ToDateTime(fechaNacimiento);

            arrParam[4] = new OracleParameter("p_sexo", OracleDbType.NVarchar2, 1);
            arrParam[4].Value = sexo;

            arrParam[5] = new OracleParameter("p_no_documento", OracleDbType.NVarchar2, 25);
            arrParam[5].Value = cedula;

            arrParam[6] = new OracleParameter("p_tipo_documento", OracleDbType.NVarchar2, 1);
            arrParam[6].Value = tipoDocumento;

            arrParam[7] = new OracleParameter("p_ult_usuario_act", OracleDbType.NVarchar2, 35);
            arrParam[7].Value = usuario;


            arrParam[8] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[8].Direction = ParameterDirection.Output;

            String cmdStr = "Sre_Ciudadano_Pkg.ciudadano_crear";
            string result = string.Empty;

            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                result = arrParam[8].Value.ToString();
                result = result.Replace("|", "");
                if (result != "0")
                {
                    string[] ErrorMsg = result.Split('|');
                    throw new Exception(ErrorMsg[1]);
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public static void RegistroCiudadanoTitular(string nombres, string nombre_padre, string usuario)
        {

            OracleParameter[] arrParam = new OracleParameter[4];

            arrParam[0] = new OracleParameter("p_nombres", OracleDbType.NVarchar2, 50);
            arrParam[0].Value = nombres;
            arrParam[1] = new OracleParameter("p_nombre_padre", OracleDbType.NVarchar2, 40);
            arrParam[1].Value = nombre_padre;
            arrParam[2] = new OracleParameter("p_ult_usuario_act", OracleDbType.NVarchar2, 35);
            arrParam[2].Value = usuario;
            arrParam[3] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[3].Direction = ParameterDirection.Output;

            String cmdStr = "Sre_Ciudadano_Pkg.ciudadano_titular_crear";
            string result = string.Empty;

            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                result = arrParam[3].Value.ToString();
                if (result != "0")
                {
                    string[] ErrorMsg = result.Split('|');
                    throw new Exception(ErrorMsg[1]);
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public static void RegistroMenorExtranjero(string nombres, string primerApellido, string segundoApellido, string fechaNacimiento, string sexo,
                                                   string idNacionalidad, string nssTitular, string usuarioAct, Byte[] imagenActa)
        {
            OracleParameter[] arrParam = new OracleParameter[10];

            arrParam[0] = new OracleParameter("p_nombres", OracleDbType.NVarchar2, 50);
            arrParam[0].Value = nombres.ToUpper();

            arrParam[1] = new OracleParameter("p_primer_apellido", OracleDbType.NVarchar2, 40);
            arrParam[1].Value = primerApellido.ToUpper();

            arrParam[2] = new OracleParameter("p_segundo_apellido", OracleDbType.NVarchar2, 40);
            arrParam[2].Value = segundoApellido.ToUpper();

            arrParam[3] = new OracleParameter("p_fecha_nacimiento", OracleDbType.Date);
            arrParam[3].Value = Convert.ToDateTime(fechaNacimiento);

            arrParam[4] = new OracleParameter("p_sexo", OracleDbType.NVarchar2, 1);
            arrParam[4].Value = sexo;

            arrParam[5] = new OracleParameter("p_id_nacionalidad", OracleDbType.NVarchar2, 3);
            arrParam[5].Value = idNacionalidad;

            arrParam[6] = new OracleParameter("p_nss_titular", OracleDbType.NVarchar2, 40);
            arrParam[6].Value = nssTitular;

            arrParam[7] = new OracleParameter("p_ult_usuario_act", OracleDbType.NVarchar2, 35);
            arrParam[7].Value = usuarioAct;

            arrParam[8] = new OracleParameter("p_ImagenActa", OracleDbType.Blob);
            arrParam[8].Value = imagenActa;

            arrParam[9] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[9].Direction = ParameterDirection.Output;

            string result = string.Empty;

            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, "SRE_CIUDADANO_PKG.RegistroMenorExtranjero", arrParam);
                result = arrParam[9].Value.ToString();

                if (result != "0")
                {
                    string[] ErrorMsg = result.Split('|');
                    throw new Exception(ErrorMsg[1]);
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public static void RegistroActaNacimiento(string nombres, string primerApellido, string segundoApellido, string fechaNacimiento, string documento, string sexo, string padre, string madre, string idMunicipio,
                                            string oficialia, string libro, string folio, string nroActa, string anoActa, string usuarioAct, Byte[] imagenActa)
        {
            OracleParameter[] arrParam = new OracleParameter[17];

            arrParam[0] = new OracleParameter("p_nombres", OracleDbType.NVarchar2, 50);
            arrParam[0].Value = nombres;

            arrParam[1] = new OracleParameter("p_primer_apellido", OracleDbType.NVarchar2, 40);
            arrParam[1].Value = primerApellido;

            arrParam[2] = new OracleParameter("p_segundo_apellido", OracleDbType.NVarchar2, 40);
            arrParam[2].Value = segundoApellido;

            arrParam[3] = new OracleParameter("p_fecha_nacimiento", OracleDbType.Date);
            arrParam[3].Value = Convert.ToDateTime(fechaNacimiento);

            arrParam[4] = new OracleParameter("p_no_documento", OracleDbType.NVarchar2, 11);
            arrParam[4].Value = documento;

            arrParam[5] = new OracleParameter("p_sexo", OracleDbType.NVarchar2, 1);
            arrParam[5].Value = sexo;

            arrParam[6] = new OracleParameter("p_nombre_padre", OracleDbType.NVarchar2, 40);
            arrParam[6].Value = padre;

            arrParam[7] = new OracleParameter("p_nombre_madre", OracleDbType.NVarchar2, 40);
            arrParam[7].Value = madre;

            arrParam[8] = new OracleParameter("p_municipio_acta", OracleDbType.NVarchar2, 6);
            arrParam[8].Value = idMunicipio;

            arrParam[9] = new OracleParameter("p_oficialia_acta", OracleDbType.NVarchar2, 10);
            arrParam[9].Value = oficialia;

            arrParam[10] = new OracleParameter("p_libro_acta", OracleDbType.NVarchar2, 10);
            arrParam[10].Value = libro;

            arrParam[11] = new OracleParameter("p_folio_acta", OracleDbType.NVarchar2, 10);
            arrParam[11].Value = folio;

            arrParam[12] = new OracleParameter("p_numero_acta", OracleDbType.NVarchar2, 10);
            arrParam[12].Value = nroActa;

            arrParam[13] = new OracleParameter("p_ano_acta", OracleDbType.NVarchar2, 4);
            arrParam[13].Value = anoActa;

            arrParam[14] = new OracleParameter("p_ult_usuario_act", OracleDbType.NVarchar2, 35);
            arrParam[14].Value = usuarioAct;

            arrParam[15] = new OracleParameter("p_ImagenActa", OracleDbType.Blob);
            arrParam[15].Value = imagenActa;

            arrParam[16] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[16].Direction = ParameterDirection.Output;

            String cmdStr = "Sre_Ciudadano_Pkg.RegistrarActaNacimiento";
            string result = string.Empty;

            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                result = arrParam[16].Value.ToString();

                if (result != "0")
                {
                    string[] ErrorMsg = result.Split('|');
                    throw new Exception(ErrorMsg[1]);
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


       

        public static DataTable GetInfoNssDup(string cedula, string nombres, string primerApellido, string fechaNacimiento, string sexo, string idMunicipio, string oficialia,
                                            string libro, string folio, string nroActa, string anoActa)
        {
            OracleParameter[] arrParam = new OracleParameter[12];

            
            arrParam[0] = new OracleParameter("p_no_documento", OracleDbType.NVarchar2, 11);
            arrParam[0].Value = cedula;

            arrParam[0] = new OracleParameter("p_nombres", OracleDbType.NVarchar2, 50);
            arrParam[0].Value = nombres;

            arrParam[1] = new OracleParameter("p_primer_apellido", OracleDbType.NVarchar2, 40);
            arrParam[1].Value = primerApellido;

            arrParam[2] = new OracleParameter("p_fecha_nacimiento", OracleDbType.Date);
            arrParam[2].Value = Convert.ToDateTime(fechaNacimiento);

            arrParam[3] = new OracleParameter("p_sexo", OracleDbType.NVarchar2, 1);
            arrParam[3].Value = sexo;

            arrParam[4] = new OracleParameter("p_municipio_acta", OracleDbType.NVarchar2, 6);
            arrParam[4].Value = idMunicipio;

            arrParam[5] = new OracleParameter("p_oficialia_acta", OracleDbType.NVarchar2, 10);
            arrParam[5].Value = oficialia;

            arrParam[6] = new OracleParameter("p_libro_acta", OracleDbType.NVarchar2, 10);
            arrParam[6].Value = libro;

            arrParam[7] = new OracleParameter("p_folio_acta", OracleDbType.NVarchar2, 10);
            arrParam[7].Value = folio;

            arrParam[8] = new OracleParameter("p_numero_acta", OracleDbType.NVarchar2, 10);
            arrParam[8].Value = nroActa;

            arrParam[9] = new OracleParameter("p_ano_acta", OracleDbType.NVarchar2, 4);
            arrParam[9].Value = anoActa;

            arrParam[10] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[10].Direction = ParameterDirection.Output;

            arrParam[11] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[11].Direction = ParameterDirection.Output;

            String cmdStr = "Sre_Ciudadano_Pkg.getActaNacimientoDup";
            //'string result = string.Empty;

            try
            {
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);
                if (ds.Tables.Count > 0)
                {
                    return ds.Tables[0];
                }
                return new DataTable("No Hay Data");
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }

        public static bool Validar_ExisteCiudadano(string nombres, string primerApellido, string segundoApellido, string fechaNacimiento)
        {
            OracleParameter[] arrParam = new OracleParameter[5];

            arrParam[0] = new OracleParameter("p_nombres", OracleDbType.Varchar2, 50);
            arrParam[0].Value = nombres;

            arrParam[1] = new OracleParameter("p_PrimerApellido", OracleDbType.Varchar2, 40);
            arrParam[1].Value = primerApellido;

            arrParam[2] = new OracleParameter("p_SegundoApellido", OracleDbType.Varchar2, 40);
            arrParam[2].Value = segundoApellido;

            arrParam[3] = new OracleParameter("p_FechaNac", OracleDbType.Date);
            arrParam[3].Value = Convert.ToDateTime(fechaNacimiento);

            arrParam[4] = new OracleParameter("p_resultnumber", OracleDbType.Varchar2, 1000);
            arrParam[4].Direction = ParameterDirection.Output;

            String cmdStr = "Sre_Ciudadano_Pkg.Validar_Existe_Ciudadano";
            string result = string.Empty;

            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                result = arrParam[4].Value.ToString();

                if (result != "0")
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
                throw ex;
            }
        }

        public static void Validar_ExisteMenorExtranjero(out DataTable menores, string nombres, string primerApellido, string segundoApellido)
        {
            OracleParameter[] arrParam = new OracleParameter[5];

            arrParam[0] = new OracleParameter("p_nombres", OracleDbType.NVarchar2, 50);
            arrParam[0].Value = nombres;

            arrParam[1] = new OracleParameter("p_primer_apellido", OracleDbType.NVarchar2, 40);
            arrParam[1].Value = primerApellido;

            arrParam[2] = new OracleParameter("p_segundo_apellido", OracleDbType.NVarchar2, 40);
            arrParam[2].Value = segundoApellido;

            arrParam[3] = new OracleParameter("IO_CURSOR", OracleDbType.RefCursor);
            arrParam[3].Direction = ParameterDirection.Output;

            arrParam[4] = new OracleParameter("p_result_number", OracleDbType.Varchar2, 200);
            arrParam[4].Direction = ParameterDirection.Output;

            String cmdStr = "Sre_Ciudadano_Pkg.ObtenerMenorExtranjero";
            string result = string.Empty;

            try
            {
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);

                if (ds.Tables.Count > 0)
                {
                    menores = ds.Tables[0];
                }
                else
                {
                    menores = null;
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public static string CrearPasaporte(int regPat, string nro_pasaporte, string nombres, string primerApellido, string segundoApellido,
                                        string fechaNacimiento, string sexo, string idNacionalidad, string usuarioAct, string email, string numero_contacto, string user_name)
        {


            OracleParameter[] arrParam = new OracleParameter[15];

            arrParam[0] = new OracleParameter("p_id_registro_patronal", OracleDbType.Decimal);
            arrParam[0].Value = regPat;

            arrParam[1] = new OracleParameter("p_nro_pasaporte", OracleDbType.NVarchar2,25);
            arrParam[1].Value = nro_pasaporte;

            arrParam[2] = new OracleParameter("p_nombres", OracleDbType.NVarchar2, 50);
            arrParam[2].Value = nombres;

            arrParam[3] = new OracleParameter("p_primer_apellido", OracleDbType.NVarchar2, 40);
            arrParam[3].Value = primerApellido;

            arrParam[4] = new OracleParameter("p_segundo_apellido", OracleDbType.NVarchar2, 40);
            arrParam[4].Value = segundoApellido;

            arrParam[5] = new OracleParameter("p_fecha_nacimiento", OracleDbType.Date);
            arrParam[5].Value = Convert.ToDateTime(fechaNacimiento);

            arrParam[6] = new OracleParameter("p_sexo", OracleDbType.NVarchar2, 1);
            arrParam[6].Value = sexo;

            arrParam[7] = new OracleParameter("p_nacionalidad", OracleDbType.NVarchar2, 3);
            arrParam[7].Value = idNacionalidad;

            arrParam[8] = new OracleParameter("p_status", OracleDbType.NVarchar2, 2);
            arrParam[8].Value = "PE";
            
            arrParam[9] = new OracleParameter("p_ult_usuario_act", OracleDbType.NVarchar2, 35);
            arrParam[9].Value = usuarioAct;            

            arrParam[10] = new OracleParameter("p_fecha_registro", OracleDbType.Date);
            arrParam[10].Value = DateTime.Now;            

            arrParam[11] = new OracleParameter("p_email", OracleDbType.NVarchar2, 50);
            arrParam[11].Value = email;

            arrParam[12] = new OracleParameter("p_numero_contacto", OracleDbType.NVarchar2, 10);
            arrParam[12].Value = numero_contacto;

            arrParam[13] = new OracleParameter("p_user_name", OracleDbType.NVarchar2, 50);
            arrParam[13].Value = user_name; 
            
            arrParam[14] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[14].Direction = ParameterDirection.Output;

            String cmdStr = "Sre_Ciudadano_Pkg.Pasaporte_Crear";
            string result = string.Empty;

            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                result = arrParam[14].Value.ToString();

                string[] ErrorMsg = result.Split('|');


                if (ErrorMsg[0] != "0")
                {
                   throw new Exception(ErrorMsg[1]);
                }

                return result;
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }


       public static DataTable getPasaportes(string RegPat, string Pasaporte, string UserName, string Nombre, string PrimerApellido, string SegundoApellido, string fecha_desde, string fecha_hasta, string status, int pagenum, int pagesize)
        {
            OracleParameter[] arrParam = new OracleParameter[13];
             

            arrParam[0] = new OracleParameter("p_id_registro_patronal", OracleDbType.Decimal);
            arrParam[0].Value = RegPat;

            arrParam[1] = new OracleParameter("p_pasaporte", OracleDbType.NVarchar2);
            arrParam[1].Value = Pasaporte;

            arrParam[2] = new OracleParameter("p_username", OracleDbType.NVarchar2);
            arrParam[2].Value = UserName;

            arrParam[3] = new OracleParameter("p_nombre", OracleDbType.NVarchar2);
            arrParam[3].Value = Nombre;

            arrParam[4] = new OracleParameter("p_primer_apellido", OracleDbType.NVarchar2);
            arrParam[4].Value = PrimerApellido;

            arrParam[5] = new OracleParameter("p_segundo_apellido", OracleDbType.NVarchar2);
            arrParam[5].Value = SegundoApellido;

            arrParam[6] = new OracleParameter("p_fecha_desde", OracleDbType.Date);
            if (fecha_desde == string.Empty)
            {
                arrParam[6].Value = null;
            }

            else
            {
                arrParam[6].Value = Convert.ToDateTime(fecha_desde);
            }

            arrParam[7] = new OracleParameter("p_fecha_hasta", OracleDbType.Date);
            if (fecha_hasta == string.Empty)
            {
                arrParam[7].Value = null;
            }

            else
            {
                arrParam[7].Value = Convert.ToDateTime(fecha_hasta);
            }

            arrParam[8] = new OracleParameter("p_status", OracleDbType.NVarchar2);
            arrParam[8].Value = status;

            arrParam[9] = new OracleParameter("p_pagenum", OracleDbType.Double);
            arrParam[9].Value = pagenum;

            arrParam[10] = new OracleParameter("p_pagesize", OracleDbType.Double);
            arrParam[10].Value = pagesize;

            arrParam[11] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[11].Direction = ParameterDirection.Output;
                        
            arrParam[12] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[12].Direction = ParameterDirection.Output;

            String cmdStr = "Sre_Ciudadano_Pkg.getPasaportes_registrados";
            string result = string.Empty;

            try
            {
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);
                if (ds.Tables.Count > 0)
                {

                    return ds.Tables[0];

                }

                return new DataTable("No Hay Data");
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }

        static string FormatFecha(string Fecha)
        {
            var Resultado = "";
            return Resultado = "" + Fecha.Substring(3, 2) + "/" + Fecha.Substring(0, 2) + "/" + Fecha.Substring(6, 4);

        }

        public static DataTable getInfoEvaluacionPasaportes(string id_solicitud)
        {

            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_id_solicitud", OracleDbType.Decimal);
            arrParam[0].Value = Convert.ToInt32(id_solicitud);

            arrParam[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_resultNumber", OracleDbType.Varchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;

            String cmdStr = "sre_ciudadano_pkg.getdatospasaportesevaluacion";
            
            try
            {
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);
                if (ds.Tables.Count > 0)
                {
                    return ds.Tables[0];
                }
                return new DataTable("No Hay Data");
            }

            catch (Exception ex)
            {
                SuirPlus.Exepciones.Log.LogToDB(ex.ToString());

                throw ex;
            }
        }

        public static DataTable getEmpleadoresPasaporte()
        {

            OracleParameter[] arrParam = new OracleParameter[2];

            arrParam[0] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[0].Direction = ParameterDirection.Output;

            arrParam[1] = new OracleParameter("p_resultNumber", OracleDbType.Varchar2, 200);
            arrParam[1].Direction = ParameterDirection.Output;

            String cmdStr = "sre_ciudadano_pkg.getEmpleadoresConPasaporte";

            try
            {
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);
                if (ds.Tables.Count > 0)
                {
                    return ds.Tables[0];
                }
                return new DataTable("No Hay Data");
            }

            catch (Exception ex)
            {
                SuirPlus.Exepciones.Log.LogToDB(ex.ToString());

                throw ex;
            }
        }

        public static DataTable getImagenPasaporte(string pasaporte)
        {

            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_nro_pasaporte", OracleDbType.NVarchar2, 25);
            arrParam[0].Value = pasaporte;


            arrParam[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_resultNumber", OracleDbType.Varchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;

            String cmdStr = "sre_ciudadano_pkg.getImagenPasaporte";

            try
            {
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);
                if (ds.Tables.Count > 0)
                {
                    return ds.Tables[0];
                }
                return new DataTable("No Hay Data");
            }

            catch (Exception ex)
            {
                SuirPlus.Exepciones.Log.LogToDB(ex.ToString());

                throw ex;
            }
        }

        public static string RechazarPasaporte(string Pasaporte, string Motivo)
        {


            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_nro_pasaporte", OracleDbType.NVarchar2, 25);
            arrParam[0].Value = Pasaporte;

            arrParam[1] = new OracleParameter("p_motivo", OracleDbType.Decimal);
            arrParam[1].Value = Motivo;

            arrParam[2] = new OracleParameter("p_resultNumber", OracleDbType.Varchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;


            String cmdStr = "Sre_Ciudadano_Pkg.RechazarPasaporte";
            string result = string.Empty;

            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
             
                result = Utilitarios.Utils.sacarMensajeDeError(arrParam[2].Value.ToString());
             

                if (result != "OK")
                {
                    string[] ErrorMsg = result.Split('|');
                    return ErrorMsg[1];
                }
                else { 
                   return result;
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }

        public static DataTable getMotivosPasaportes()
        {

            OracleParameter[] arrParam = new OracleParameter[2];

            arrParam[0] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[0].Direction = ParameterDirection.Output;

            arrParam[1] = new OracleParameter("p_resultNumber", OracleDbType.Varchar2, 200);
            arrParam[1].Direction = ParameterDirection.Output;

            String cmdStr = "sre_ciudadano_pkg.getMotivosPasaporte";

            try
            {
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);
                if (ds.Tables.Count > 0)
                {
                    return ds.Tables[0];
                }
                return new DataTable("No Hay Data");
            }

            catch (Exception ex)
            {
                SuirPlus.Exepciones.Log.LogToDB(ex.ToString());

                throw ex;
            }
        }

        public static string AprobarPasaporte(string Pasaporte, string Motivo, string usuario)
        {


            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_nro_pasaporte", OracleDbType.NVarchar2, 25);
            arrParam[0].Value = Pasaporte;

            arrParam[1] = new OracleParameter("p_ult_usuario_act", OracleDbType.NVarchar2, 35);
            arrParam[1].Value = usuario;

            arrParam[2] = new OracleParameter("p_resultNumber", OracleDbType.Varchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;


            String cmdStr = "Sre_Ciudadano_Pkg.AprobarPasaporteCiudadano";
            string result = string.Empty;

            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                result = Utilitarios.Utils.sacarMensajeDeError(arrParam[2].Value.ToString());
                
                if (result != "OK")
                {
                    string[] ErrorMsg = result.Split('|');
                    return ErrorMsg[1];
                }
                else
                {
                    return result;
                }


            }
            catch (Exception ex)
            {
                throw ex;
            }

        }

        public static string CargarDocumentacion(string id_solicitud, int id_requisito, byte[] documento, string nombre_documento, string tipo_documento, string usuario)
        {
            OracleParameter[] arrParam = new OracleParameter[7];


            arrParam[0] = new OracleParameter("p_id_solicitud", OracleDbType.Decimal);
            arrParam[0].Value = Convert.ToInt32(id_solicitud);

            arrParam[1] = new OracleParameter("p_id_requisito", OracleDbType.Decimal);
            arrParam[1].Value = Convert.ToInt32(id_requisito);

            arrParam[2] = new OracleParameter("p_documento", OracleDbType.Blob);
            arrParam[2].Value = documento;

            arrParam[3] = new OracleParameter("p_DOCUMENTO_NOMBRE", OracleDbType.NVarchar2, 100);
            arrParam[3].Value = nombre_documento;

            arrParam[4] = new OracleParameter("p_DOCUMENTO_TIPO", OracleDbType.NVarchar2, 50);
            arrParam[4].Value = tipo_documento;

            arrParam[5] = new OracleParameter("p_ult_usuario_act", OracleDbType.NVarchar2, 50);
            arrParam[5].Value = usuario;

            arrParam[6] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[6].Direction = ParameterDirection.Output;

            String cmdStr = "Sre_Ciudadano_Pkg.cargarImgPasaporte";

            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);

                var result = Utilitarios.Utils.sacarMensajeDeError(arrParam[6].Value.ToString());
                return result;

            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;
            }


        }
        public static DataTable getImagenesPasaportes(int id_solicitud, int id_requisito)
        {

            OracleParameter[] arrParam = new OracleParameter[4];

            arrParam[0] = new OracleParameter("p_id_solicitud", OracleDbType.Decimal);
            arrParam[0].Value = Convert.ToInt32(id_solicitud);

            arrParam[1] = new OracleParameter("p_id_requisito", OracleDbType.Decimal);
            arrParam[1].Value = Convert.ToInt32(id_requisito);

            arrParam[2] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[2].Direction = ParameterDirection.Output;

            arrParam[3] = new OracleParameter("p_resultNumber", OracleDbType.Varchar2, 200);
            arrParam[3].Direction = ParameterDirection.Output;

            String cmdStr = "sre_ciudadano_pkg.GetImgPasaporte";

            try
            {
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);
                if (ds.Tables.Count > 0)
                {
                    return ds.Tables[0];
                }
                return new DataTable("No Hay Data");
            }

            catch (Exception ex)
            {
                SuirPlus.Exepciones.Log.LogToDB(ex.ToString());

                throw ex;
            }
        }

        public static DataTable getImagenesPasaportes(int id_solicitud)
        {

            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_id_solicitud", OracleDbType.Decimal);
            arrParam[0].Value = Convert.ToInt32(id_solicitud);

            arrParam[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_resultNumber", OracleDbType.Varchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;

            String cmdStr = "sre_ciudadano_pkg.GetImgPasaporte";

            try
            {
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);
                if (ds.Tables.Count > 0)
                {
                    return ds.Tables[0];
                }
                return new DataTable("No Hay Data");
            }

            catch (Exception ex)
            {
                SuirPlus.Exepciones.Log.LogToDB(ex.ToString());

                throw ex;
            }
        }

        public static DataTable getRequisitoPasaportes(int id_solicitud)
        {

            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_id_solicitud", OracleDbType.Decimal);
            arrParam[0].Value = Convert.ToInt32(id_solicitud);

            arrParam[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_resultNumber", OracleDbType.Varchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;

            String cmdStr = "sre_ciudadano_pkg.GetPasaporte_Requisito";

            try
            {
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);
                if (ds.Tables.Count > 0)
                {
                    return ds.Tables[0];
                }
                return new DataTable("No Hay Data");
            }

            catch (Exception ex)
            {
                SuirPlus.Exepciones.Log.LogToDB(ex.ToString());

                throw ex;
            }
        }

    }
}
