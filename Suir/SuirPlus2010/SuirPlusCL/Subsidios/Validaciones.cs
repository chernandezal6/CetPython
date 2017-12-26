using System;
using SuirPlus.DataBase;
using Oracle.ManagedDataAccess.Client;
using SuirPlus.Utilitarios;
using SuirPlus.Exepciones;
using System.Data;
namespace SuirPlus.Subsidios
{
    /// <summary>
    /// Clase para manejar las validaciones de los subsidios del SFS
    /// </summary>
    public class Validaciones
    {
    

        /// <summary>
        /// Funcion para validar documento
        /// </summary>
        /// <param name="nss">Nss que se va a validar</param>
        /// <param name="nrodocumento">Nro de documento que se va a validar</param>
        /// <returns></returns>
        public static String ValidarDocumento(Int32 nss, String nrodocumento) 
        {
            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_nss", OracleDbType.Int32);
            arrParam[0].Value = nss;

            arrParam[1] = new OracleParameter("p_nro_documento", OracleDbType.Varchar2, 25);
            arrParam[1].Value = nrodocumento;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.Varchar2, 200);
            arrParam[2].Direction = ParameterDirection.InputOutput;

            try
            {
                OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, "SUB_SFS_VALIDACIONES.ValidaDocumento", arrParam);

                var resutl = Convert.ToString(arrParam[2].Value);

                return resutl;
            }
            catch (Exception ex)
            {
                SuirPlus.Exepciones.Log.LogToDB(ex.Message);
                throw ex;
            }
        }


        #region "Validaciones para subsidio de Maternidad y Lactancia"
        /// <summary>
        /// Funcion que verifica si el empleador esta al dia con los aportes a la seguridad social
        /// </summary>
        /// <param name="RegistroPatronal">Registro Patronal que debe de estar al dia en los aportes</param>
        /// <returns>Devuelve true si este esta la dia en sus aportes.</returns>
        public static Boolean estaEmpleadorAlDia(int RegistroPatronal)
        {
            OracleParameter[] arrParam = new OracleParameter[2];

            arrParam[0] = new OracleParameter("p_idregistropatronal ", OracleDbType.Int32);
            arrParam[0].Value = Utils.verificarNulo(RegistroPatronal);

            arrParam[1] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[1].Direction = ParameterDirection.InputOutput;

            try
            {
                OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure,
                                             "SUB_SFS_VALIDACIONES.estaEmpleadorAlDia",
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
        /// Funcion para ver si el empleador tiene una cuenta bancaria registrada.
        /// </summary>
        /// <param name="RegistroPatronal">Registro Patronal que se va a verificar si tiene una cuenta registrada</param>
        /// <returns>Devuelve True si el empleador tiene una cuenta registra en caso contrario devuelve false</returns>
        public static Boolean tieneCuentaBancaria(int RegistroPatronal, out String result)
        {
            OracleParameter[] arrParam = new OracleParameter[2];

            arrParam[0] = new OracleParameter("p_idregistropatronal", OracleDbType.Int32);
            arrParam[0].Value = Utils.verificarNulo(RegistroPatronal);

            arrParam[1] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[1].Direction = ParameterDirection.InputOutput;

            try
            {
                OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure,
                                             "SUB_SFS_VALIDACIONES.tieneCuentaBancaria",
                                             arrParam);

                var resultado = arrParam[1].Value.ToString();

                if (resultado.Equals("1"))
                {
                    result = resultado;

                    return true;


                }
                result = Utilitarios.Utils.sacarMensajeDeError(resultado); ;
                return false;

            }

            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;
            }
        }
        /// <summary>
        /// Funcion para determinar si el o la trabajadora tiene movimientos pendientes
        /// </summary>
        /// <param name="NSS">NSS del o la trabajadora que se va a verificar si tiene movimientos pendientes.</param>
        /// <returns>Devuelve True si el o la trabajadora</returns>
        public static Boolean tieneMovimientosSFSPendientes(int NSS)
        {

            OracleParameter[] arrParam = new OracleParameter[2];

            arrParam[0] = new OracleParameter("p_idnss", OracleDbType.Int32);
            arrParam[0].Value = Utils.verificarNulo(NSS);

            arrParam[1] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[1].Direction = ParameterDirection.InputOutput;

            try
            {
                OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure,
                                             "SUB_SFS_VALIDACIONES.tieneMovimientosSFSPendientes",
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
        /// Funcion para determina si la trabajadora tiene contizaciones continuas
        /// </summary>
        /// <param name="NSS">NSS de la trabajadora</param>
        /// <param name="cotizaciones">Cantidad de Cotizaciones (-8 = 8 cotizaciones para el subsidio de maternidad, -12 = 12 cotizaciones para el subsidio de enfermedad comun)</param>
        /// <param name="fecha">Fecha a partir de donde se van a calcular las cotizaciones.</param>
        /// <returns>Devuelve True si la trabajadora tiene las contizaciones continuas</returns>
        public static Boolean tieneCotizacionesContinua(Int32 NSS, Int32 cotizaciones, DateTime fecha)
        {
            OracleParameter[] arrParam = new OracleParameter[4];

            arrParam[0] = new OracleParameter("p_idnss", OracleDbType.Int32);
            arrParam[0].Value = NSS;

            arrParam[1] = new OracleParameter("p_cotizaciones", OracleDbType.Int32);
            arrParam[1].Value = cotizaciones;

            arrParam[2] = new OracleParameter("p_fecha_inicio", OracleDbType.Date);
            arrParam[2].Value = fecha;

            arrParam[3] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[3].Direction = ParameterDirection.InputOutput;

            try
            {
                OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure,
                                            "SUB_SFS_VALIDACIONES.tieneCotizacionesContinua",
                                            arrParam);

                var resultado = arrParam[3].Value.ToString();

                if (resultado.Equals("1"))
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

        /// <summary>
        /// Function para determinar si la trabajadora esta activa en nomina para ese empleador
        /// </summary>
        /// <param name="NSS">NSS de la trabajadora</param>
        /// <param name="FechaEstimadaParto">Fecha estimada de parto</param>
        /// <param name="RegistroPatronal">Registro Patronal del empleador</param>
        /// <param name="FechaLiciencia">Fecha de la licencia</param>
        /// <param name="Tipo">Tipo (L= Licencia, M = Maternidad)</param>
        /// <returns></returns>
        public static Boolean estaActivaNomina(Int32 NSS, DateTime? FechaEstimadaParto, Int32? RegistroPatronal, DateTime? FechaLiciencia, String Tipo)
        {
            var miresult = String.Empty;

            OracleParameter[] arrParam = new OracleParameter[6];

            arrParam[0] = new OracleParameter("p_idnss", OracleDbType.Int32);
            arrParam[0].Value = Utils.verificarNulo(NSS);

            arrParam[1] = new OracleParameter("p_fechaestimadaparto", OracleDbType.Date);
            arrParam[1].Value = FechaEstimadaParto;

            arrParam[2] = new OracleParameter("p_idregistropatronal", OracleDbType.Int32);
            arrParam[2].Value = RegistroPatronal;

            arrParam[3] = new OracleParameter("p_fechainiciolicencia", OracleDbType.Date);
            arrParam[3].Value = FechaLiciencia;

            arrParam[4] = new OracleParameter("P_Tipo", OracleDbType.Varchar2);
            arrParam[4].Value = Tipo;

            arrParam[5] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[5].Direction = ParameterDirection.InputOutput;

            try
            {
                OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure,
                                             "SUB_SFS_VALIDACIONES.estaActivoNomina",
                                              arrParam);

                miresult = Convert.ToString(arrParam[5].Value);

                if (miresult == "1")
                {
                    return true;
                }
                return false;
            }
            catch (Exception ex)
            {
                Log.LogToDB(ex.Message);
                throw ex;
            }

        }

        public static Boolean esValidoNSS(Int32 NSS)
        {
            var miresult = String.Empty;

            OracleParameter[] arrParam = new OracleParameter[2];

            arrParam[0] = new OracleParameter("p_nss", OracleDbType.Int32);
            arrParam[0].Value = Utils.verificarNulo(NSS);

            arrParam[1] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[1].Direction = ParameterDirection.InputOutput;

            try
            {
                OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, "SUB_SFS_VALIDACIONES.esValidoElNss", arrParam);

                miresult = Convert.ToString(arrParam[1].Value);

                if (miresult.Equals("1"))
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

        public static Boolean tieneEmbarazoActivo(Int32 NSS, Int32 RegistroPatronal)
        {

            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_nss", OracleDbType.Int32);
            arrParam[0].Value = NSS;

            arrParam[1] = new OracleParameter("p_idregistropatronal", OracleDbType.Int32);
            arrParam[1].Value = RegistroPatronal;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.Varchar2, 200);
            arrParam[2].Direction = ParameterDirection.InputOutput;

            try
            {
                OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, "SUB_SFS_VALIDACIONES.tieneEmbarazo", arrParam);

                var result = Convert.ToString(arrParam[2].Value);

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


            return true;
        }

        public static Boolean tieneEmbarazoConNacimiento(Int32 NSS, Int32 RegistroPatronal)
        {
            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_nss", OracleDbType.Int32);
            arrParam[0].Value = NSS;

            arrParam[1] = new OracleParameter("p_idregistropatronal", OracleDbType.Int32);
            arrParam[1].Value = RegistroPatronal;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.Varchar2, 200);
            arrParam[2].Direction = ParameterDirection.InputOutput;

            try
            {
                OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, "SUB_SFS_VALIDACIONES.tieneEmbarazoConNacimiento", arrParam);

                var resutl = Convert.ToString(arrParam[2].Value);

                if (resutl.Equals("1"))
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

        public static Boolean tieneEmbarazoSinNacimiento(Int32 NSS, Int32 RegistroPatronal)
        {
            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_nss", OracleDbType.Int32);
            arrParam[0].Value = NSS;

            arrParam[1] = new OracleParameter("p_idregistropatronal", OracleDbType.Int32);
            arrParam[1].Value = RegistroPatronal;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.Varchar2, 200);
            arrParam[2].Direction = ParameterDirection.InputOutput;

            try
            {
                OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, "SUB_SFS_VALIDACIONES.tieneEmbarazoSinNacimiento", arrParam);

                var resutl = Convert.ToString(arrParam[2].Value);

                if (resutl.Equals("1"))
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

        public static Boolean existeFallecida(String NroDocumento)
        {
            try
            {
                var miresult = String.Empty;
                var detalletrabajadora = Novedades.ObtenerNssTrabajadora(NroDocumento);

                OracleParameter[] arrParam = new OracleParameter[2];

                arrParam[0] = new OracleParameter("p_nss", OracleDbType.Int32);
                arrParam[0].Value = detalletrabajadora.nss;

                arrParam[1] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
                arrParam[1].Direction = ParameterDirection.InputOutput;

                try
                {
                    OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, "SUB_SFS_VALIDACIONES.existeFallecida", arrParam);

                    miresult = Convert.ToString(arrParam[1].Value);

                    if (miresult.Equals("1"))
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
            catch (Exception)
            {

                return false;
            }

        }

        #endregion

        
        #region "Validaciones para el subsidio de Enfermedad Comun"

        /// <summary>
        /// Metodo para Validar el Registro de Enfermedad Comun
        /// </summary>
        /// <param name="NroDocumento">Nro Documento del afiliado(a)</param>
        /// <param name="RegistroPatronal">Registro Patronal del empleador que esta reportando</param>
        /// <param name="enfCursor">Datatable con el listado de padecimientos pendientes</param>
        /// <returns></returns>
        public static String ValidarRegEnfermedadComun(String NroDocumento, Int32 RegistroPatronal, ref DataTable enfCursor)
        {
            
            var resultNumber = String.Empty;


            resultNumber = Validaciones.ValidarDocumento(0, NroDocumento);

            if (!resultNumber.Equals(0))
            {
                return resultNumber.Replace("567", "");
            }

            OracleParameter[] parameters = new OracleParameter[4];

            parameters[0] = new OracleParameter("P_NroDocumento", OracleDbType.Varchar2);
            parameters[0].Value = NroDocumento;

            parameters[1] = new OracleParameter("P_RegistrosPatronal", OracleDbType.Int32);
            parameters[1].Value = RegistroPatronal;

            parameters[2] = new OracleParameter("p_io_cursor", OracleDbType.RefCursor);
            parameters[2].Direction = ParameterDirection.Output;

            parameters[3] = new OracleParameter("P_ResultNumber", OracleDbType.NVarchar2, 200);
            parameters[3].Direction = ParameterDirection.Output;

            String cmdStr = "SUB_SFS_VALIDACIONES.ValidarRegistroEnfermedadComun";

            try
            {
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, parameters);
                
                resultNumber = Utilitarios.Utils.sacarMensajeDeError(parameters[3].Value.ToString());

                if (ds.Tables.Count > 0)
                {
                    enfCursor = ds.Tables[0];
                }
                return resultNumber; 
            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                resultNumber = ex.Message;
                return resultNumber;
            }

        }

        #endregion


        #region "Validaciones de la cuenta bancaria"
        /// <summary>
        /// funcion para determinar si el RNC 0 CEDULA ES VALIDO.
        /// </summary>
        /// <param name="RNC">RNC O cedula que va hacer validado.</param>
        /// <returns></returns>
        public static String EsRncOCedulaInactiva(String RNC)
        {
            OracleParameter[] arrParam = new OracleParameter[2];

            arrParam[0] = new OracleParameter("p_rnc_o_cedula ", OracleDbType.Varchar2);
            arrParam[0].Value = Utils.verificarNulo(RNC);

            arrParam[1] = new OracleParameter("p_result_number", OracleDbType.NVarchar2, 200);
            arrParam[1].Direction = ParameterDirection.InputOutput;

            try
            {
                OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure,
                                             "Sre_Empleadores_Pkg.isRncOCedulaInactiva",
                                             arrParam);

                return arrParam[1].Value.ToString();
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
