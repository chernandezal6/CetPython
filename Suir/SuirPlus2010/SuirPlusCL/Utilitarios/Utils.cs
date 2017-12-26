using System.Globalization;
using System.Threading;
using System.Text;
using System;
using System.Web;
using System.Data;
using Oracle.ManagedDataAccess.Client;
using System.Text.RegularExpressions;
using System.Runtime.InteropServices;
using System.IO;

namespace SuirPlus.Utilitarios
{
    /// <summary>
    /// Clase estatica de utilitarios.
    /// </summary>
    public class Utils
    {
        private Utils()
        {
            // No hay necesidad de hacer una instancia de esta clase.
        }


        public static String LimpiarParametro(String Parametro)
        {
            Parametro = Parametro.Trim();
            Parametro = Parametro.Replace("'", "");
            return Parametro;
        }
        public static Int32 LimpiarParametro(Int32 Parametro)
        {
            return Parametro;
        }
        public static decimal LimpiarParametro(decimal Parametro)
        {
            return Parametro;
        }
        public static string LimpiarParametro(String Parametro, int LongitudMaxima)
        {


            StringBuilder retVal = new StringBuilder();

            // check incoming parameters for null or blank string
            if ((Parametro != null) && (Parametro != String.Empty))
            {
                Parametro = Parametro.Trim();

                //chop the string incase the client-side max length
                //fields are bypassed to prevent buffer over-runs
                if (Parametro.Length > LongitudMaxima)
                    Parametro = Parametro.Substring(0, LongitudMaxima);

                //convert some harmful symbols incase the regular
                //expression validators are changed
                for (int i = 0; i < Parametro.Length; i++)
                {
                    switch (Parametro[i])
                    {
                        case '"':
                            retVal.Append("&quot;");
                            break;
                        case '<':
                            retVal.Append("&lt;");
                            break;
                        case '>':
                            retVal.Append("&gt;");
                            break;
                        default:
                            retVal.Append(Parametro[i]);
                            break;
                    }
                }

                // Replace single quotes with white space
                retVal.Replace("'", " ");
            }

            return retVal.ToString();

        }

        public static bool validaDigitoVerificadorCedula(String cedula)
        {

            //return (cedula.Length == 11?true:false);
            int num2 = 0;
            if (cedula == null)
            {
                return false;
                //throw new Exception("Parámetro cédula no puede ser nulo.");
            }
            if (cedula.Length != 11)
            {
                return false;
                //throw new Exception("La longitud de la cédula no se corresponde con una cedula válida");
            }
            try
            {
                Convert.ToInt32(cedula);
            }
            catch (Exception exception1)
            {
                return false;
                //throw new Exception("la cédula solo puede contener números");
            }

            int start = 0;
            do

            {

                if ((Convert.ToInt32(cedula.Substring(start, 1)) * Convert.ToInt32("1212121212".Substring(start, 1))) > 9)
                {
                    num2 += ((Convert.ToInt32(cedula.Substring(start, 1)) * Convert.ToInt32("1212121212".Substring(start, 1))) % 10) + 1;
                }
                else
                {
                    num2 += Convert.ToInt32(cedula.Substring(start, 1)) * Convert.ToInt32("1212121212".Substring(start, 1));
                }
                start++;
            }
            while (start < 10);

            int num3 = (int)Math.Round((Convert.ToDouble((((num2 / 10)) * 10) + 10) - num2));
            if (num3 == 10)
            {
                num3 = 0;
            }
            //return (StringType.StrCmp(num3, cedula.Substring(0, 1)), false) == 0);
            return (Convert.ToString(num3) == cedula.Substring(10, 1));
            //return (System.String.Compare(Convert.ToString(num3), cedula.Substring(0, 1), false) == 0);

        }

        public static String CambiarMesFecha(String fecha)
        {

            fecha = fecha.Replace("ENE", "JAN");
            fecha = fecha.Replace("FEB", "FEB");
            fecha = fecha.Replace("MAR", "MAR");
            fecha = fecha.Replace("ABR", "APR");
            fecha = fecha.Replace("MAY", "MAY");
            fecha = fecha.Replace("JUN", "JUN");
            fecha = fecha.Replace("JUL", "JUL");
            fecha = fecha.Replace("AGO", "AUG");
            fecha = fecha.Replace("SEP", "SEP");
            fecha = fecha.Replace("OCT", "OCT");
            fecha = fecha.Replace("NOV", "NOV");
            fecha = fecha.Replace("DIC", "DEC");

            return fecha;
        }

        /// <summary>
        /// Funcion para convertir un string a datetime en los formatos "MM/dd/yyyy", "MM/dd/yy", "ddMMMyyyy", "dMMMyyyy"
        /// </summary>
        /// <param name="Fecha">Fecha que desea convertir a datetime</param>
        /// <returns>Retorna la fecha formatiada</returns>
        public static DateTime FormatearFecha(string Fecha)
        {
            String[] formatos = new String[] { "dd/MM/yyyy", "d/M/yyyy" };
            try
            {
                var mifecha = DateTime.ParseExact(Fecha, formatos, CultureInfo.CurrentCulture, DateTimeStyles.None);
                return mifecha;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public static String FormatearNSS(String NSS)
        {
            NSS = NSS.PadLeft(9, '0');
            if (NSS.Length.Equals(9))
            { NSS = NSS.Substring(0, 8) + "-" + NSS.Substring(8, 1); }
            return NSS;
        }
        /// <summary>
        /// Retorna un RNC o cedula formateado en la forma
        /// N-NN-NNNNN-N
        /// </summary>
        /// <param name="rncCedula">RNC o Cedula a formatear</param>
        /// <returns></returns>
        public static string FormatearRNCCedula(string rncCedula)
        {

            //Limpiando String
            rncCedula = rncCedula.Trim();

            //Si el rncCedula enviado tiene mas de 9 caracteres es considerado como una cedula.
            if (rncCedula.Length > 9) return Utils.FormatearCedula(rncCedula);

            //completando con ceros el RNC
            rncCedula = rncCedula.PadLeft(9, '0');

            return rncCedula.Substring(0, 1) + "-" + rncCedula.Substring(1, 2) + "-" + rncCedula.Substring(3, 5) + "-" + rncCedula.Substring(8);

        }
        /// <summary>
        /// Retorna una Cedula formateada en la forma
        /// NNN-NNNNNNN-N
        /// </summary>
        /// <param name="cedula"></param>
        /// <returns></returns>
        public static string FormatearCedula(string cedula)
        {

            //Limpiando String
            cedula = cedula.Trim();

            //Completando cadena numerica con ceros a la izquierda hasta llegar a 11 digitos.
            cedula = cedula.PadLeft(11, '0');

            return cedula.Substring(0, 3) + "-" + cedula.Substring(3, 7) + "-" + cedula.Substring(10);

        }

        /// <summary>
        /// Funcion utilizada para formatear un periodo.
        /// </summary>
        /// <param name="periodo">un periodo en formato yyyymm</param>
        /// <returns>un periodo formateado mm-yyyy</returns>
        public static string FormateaPeriodo(string periodo)
        {
            if (periodo != string.Empty)
            {
                if (periodo.Length == 6)
                {
                    return periodo.Substring(4, 2) + "-" + periodo.Substring(0, 4);
                }
            }
            return periodo;
        }
        public static string FormateaReferencia(string nroRef)
        {
            try
            {
                if (nroRef == string.Empty)
                {
                    return string.Empty;
                }

                nroRef = nroRef.Substring(0, 4) + "-" + nroRef.Substring(4, 4) + "-" + nroRef.Substring(8, 4) + "-" + nroRef.Substring(12, 4);
                return nroRef;
            }
            catch (Exception)
            {
                return nroRef;
            }
        }

        public static String CortarString(String texto, Int32 Longitud)
        {
            if (texto.Length > Longitud)
            {
                return texto.Substring(0, Longitud - 3) + " ...";
            }
            else
            {
                return texto;
            }

        }

        /// <summary>
        /// Metodo para verificar si un parametro es nulo.
        /// </summary>
        /// <param name="Parametro">Parametro</param>
        /// <returns>En caso de que sea nulo retorna System.DBNull.Value, en caso contrario retorna lo mismo que recibe.</returns>
        public static Object verificarNulo(int Parametro)
        {
            if (Parametro == -1 || Parametro == 0)
            {
                return DBNull.Value;
            }
            else
            {
                return Parametro;
            }
        }
        /// <summary>
        /// Metodo para verificar si un parametro es nulo.
        /// </summary>
        /// <param name="Parametro">Parametro</param>
        /// <returns>En caso de que sea nulo retorna System.DBNull.Value, en caso contrario retorna lo mismo que recibe.</returns>
        public static Object verificarNulo(Int64 Parametro)
        {
            if (Parametro == -1)
            {
                return DBNull.Value;
            }
            else
            {
                return Parametro;
            }
        }
        /// <summary>
        /// Metodo para verificar si un parametro es nulo.
        /// </summary>
        /// <param name="Parametro">Parametro</param>
        /// <returns>En caso de que sea nulo retorna System.DBNull.Value, en caso contrario retorna lo mismo que recibe.</returns>		
        public static Object verificarNulo(String Parametro)
        {
            if (Parametro == "")
            {
                return DBNull.Value;
            }
            else
            {
                return Parametro;
            }
        }

        public static DateTime convertirFecha(Object Parametro)
        {
            if (Parametro == System.DBNull.Value)
            {
                //return Convert.ToDateTime(System.DBNull.Value);
                return DateTime.MinValue;
            }
            else
            {
                return Convert.ToDateTime(Parametro);
            }
        }

        /// <summary>
        /// Metodo estatico que se debe utilizar para leer el resultado de los procedimientos. Este separa el mensaje
        /// de error del codigo.
        /// </summary>
        /// <param name="Mensaje">string que retorna el stored procedure.</param>
        /// <returns>El mensaje de error en caso de que haya o de lo contrarion un OK.</returns>
        public static string sacarMensajeDeError(string mensaje)
        {
            string[] retorno = new string[2];
            retorno = mensaje.Split(new char[] { '|' });
            if (retorno[0] == "0")
            {
                return "OK";
            }
            else
            {
                try
                {
                    return retorno[1].ToString();
                }
                catch (Exception e)
                {
                    return retorno[0];
                }
            }
        }

        /// <summary>
        /// Agrega un mensaje de error a un dataTable para poder leer este mensaje desde el lado de la pagina. No devuelve nada.
        /// </summary>
        /// <param name="Mensaje">Mensaje de error</param>
        /// <param name="dt">dataTable a procesar</param>
        public static void agregarMensajeError(String Mensaje, ref DataTable dt)
        {
            DataColumn myColumn;
            DataRow myRow;

            myColumn = new DataColumn("Mensaje");
            dt.Columns.Add(myColumn);

            myRow = dt.NewRow();
            myRow["Mensaje"] = sacarMensajeDeError(Mensaje);
            dt.Rows.Add(myRow);
            dt.TableName = "Error";

        }
        /// <summary>
        /// Extrae un mensaje de error que viene dentro de una tabla. Debe utilizarse en conjunto con el metodo HayErrorEnDataTable
        /// </summary>
        /// <param name="dt">El dataTable</param>
        /// <returns>Retorna una cadena con el mensaje de error.</returns>
        public static string sacarMensajeDeErrorDesdeTabla(DataTable dt)
        {
            return dt.Rows[0][0].ToString();
        }
        /// <summary>
        /// Verifica si un DataTable vino con Data o con un Error.
        /// </summary>
        /// <param name="dt">Recibe un Datatable</param>
        /// <returns>Si viene con un mensaje de error devuelve True, de lo contrario devuelve False</returns>
        public static bool HayErrorEnDataTable(DataTable dt)
        {
            if (dt.TableName == "Error")
            {
                return true;
            }
            else
            {
                return false;
            }

        }

        public static String ProperCase(String Mensaje)
        {
            //return System.Threading.Thread.CurrentThread.CurrentCulture.TextInfo.ToTitleCase(Mensaje);
            //System.Globalization.TextInfo.ToTitleCase(Mensaje);
            return System.Globalization.CultureInfo.CurrentCulture.TextInfo.ToTitleCase(Mensaje.ToLower());


        }

        public static String FormatearTelefono(String telefono)
        {

            if (telefono == null)
            {
                return "";
            }
            else
            {


                if (telefono.Trim() == "") return "";

                if (telefono.Length > 7)
                {
                    telefono = telefono.PadLeft(10, ' ');
                    return "(" + telefono.Substring(0, 3) + ") " + telefono.Substring(3, 3) + "-" + telefono.Substring(6, 4);
                }
                else
                {
                    try
                    {
                        return telefono.Substring(0, 3) + "-" + telefono.Substring(3, 4);
                    }

                    catch (Exception ex)
                    {

                        return telefono;
                    }

                }
            }
        }
        public static String FormatearTelefonoDB(String telefono)
        {
            if (!String.IsNullOrEmpty(telefono))
            {
                return telefono.Replace("(", "").Replace(")", "").Replace("-", "");
            }
            else { return String.Empty; }
        }
        public static string getPeriodoActual()
        {
            return DateTime.Now.Year.ToString() + DateTime.Now.Month.ToString().PadLeft(2, '0');
        }

        public static string getPeriodoActualFormat()
        {
            return DateTime.Now.Month.ToString().PadLeft(2, '0') + "-" + DateTime.Now.Year.ToString();
        }

        public static string getProximoPeriodo(string periodo)
        {

            Int32 mes = Convert.ToInt16(periodo.Substring(4, 2));
            Int32 ano = Convert.ToInt16(periodo.Substring(0, 4));

            if (mes == 12)
            {
                ano += 1;
                mes = 1;
            }
            else
            {
                mes += 1;
            }

            return (ano.ToString() + mes.ToString().PadLeft(2, '0'));

        }

        public static string getPeriodoAnterior(string periodo)
        {

            Int32 mes = Convert.ToInt16(periodo.Substring(4, 2));
            Int32 ano = Convert.ToInt16(periodo.Substring(0, 4));

            if (mes == 1)
            {
                ano -= 1;
                mes = 12;
            }
            else
            {
                mes -= 1;
            }

            return (ano.ToString() + mes.ToString().PadLeft(2, '0'));

        }

        /// <summary>
        /// Utilizado para obtener el perido de la declaracion IR13
        /// </summary>
        /// <returns>El periodo actual del IR13</returns>
        /// <remarks>By Ronny Carreras</remarks>
        public static string getPeriodoIR13()
        {
            int anio = DateTime.Now.Year;
            int periodo = anio - 1;
            return periodo.ToString();
        }

        /// <summary>
        /// Metodo utilizado para verificar si un valor es numerico.
        /// </summary>
        /// <param name="valor">una cadena que representa un valor.</param>
        /// <returns>True si la cadena contiene valor numerico, false de lo contrario.</returns>
        /// <remarks>Create by Ronny Carreras</remarks>
        public static bool esValorNumerico(string valor)
        {
            try
            {
                Convert.ToInt64(valor);
                return true;
            }
            catch (FormatException exF)
            {
                return false;
            }
        }

        public static DataTable getPeriodos()
        {
            OracleParameter[] arrParam = new OracleParameter[1];

            arrParam[0] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[0].Direction = ParameterDirection.Output;

            string cmdStr = "sfc_estadistica_procesos_pkg.getPeriodos";

            try
            {
                return DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam).Tables[0];
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }

        public static DataTable getRangoPeriodos(int p_periodo_desde, int p_periodo_hasta)
        {
            OracleParameter[] arrParam = new OracleParameter[4];
            arrParam[0] = new OracleParameter("p_periodo_desde", OracleDbType.Int32);
            arrParam[0].Value = p_periodo_desde;
            arrParam[1] = new OracleParameter("p_periodo_hasta", OracleDbType.Int32);
            arrParam[1].Value = p_periodo_hasta;
            arrParam[2] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[2].Direction = ParameterDirection.Output;
            arrParam[3] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[3].Direction = ParameterDirection.Output;

            String cmdStr = "sfc_pkg.getrangoperiodos";

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
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;
            }
        }
        public static bool isNroAutorizacionValido(string autorizacion)
        {
            if (autorizacion != null)
            {
                if (autorizacion.Length > 9)
                    return false;

            }
            else
            {
                return false;
            }

            return true;
        }

        public static bool isNroReferenciaValido(string referencia, Empresas.Facturacion.Factura.eConcepto concepto)
        {
            bool isValido = true;
            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_referencia", OracleDbType.NVarchar2, 16);
            arrParam[0].Value = referencia;

            arrParam[1] = new OracleParameter("p_concepto", OracleDbType.NVarchar2, 11);
            arrParam[1].Value = concepto;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;

            string Package = "sfc_factura_pkg.isValidaReferencia";


            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, Package, arrParam);
                if (arrParam[2].Value.ToString() == "1")
                {
                    isValido = false;
                }

            }
            catch (Exception ex)
            {
                throw ex;
            }

            return isValido;

        }

        public static string ObtenerEdad(DateTime fecha1, DateTime fecha2)
        {
            Int32 ano; Int32 mes; Int32 semana; Int32 dia = 0;
            TimeSpan diff = fecha2 - fecha1;
            ano = diff.Days / 365;
            DateTime workingDate = fecha1.AddYears(ano);

            while (workingDate.AddYears(1) <= fecha2)
            {
                workingDate = workingDate.AddYears(1);
                ano++;
            }

            //mes
            diff = fecha2 - workingDate;
            mes = diff.Days / 31;
            workingDate = workingDate.AddMonths(mes);

            while (workingDate.AddMonths(1) <= fecha2)
            {
                workingDate = workingDate.AddMonths(1);
                mes++;
            }

            //semana y dia
            diff = fecha2 - workingDate;
            semana = diff.Days / 7;
            dia = diff.Days % 7;

            var EdadCompleta = ano.ToString() + " años " + mes.ToString() + " meses " + semana.ToString() + " semana " + dia.ToString() + " dia";
            var Resultado = ano.ToString() + " años ";
            return Resultado;
        }

        /// <summary>
        /// Metodo utilizado para sombrear un texto luego de relizado una busqueda.
        /// </summary>
        /// <param name="searchWord">Palabra a buscar</param>
        /// <param name="inputText">Texto donde se debe buscar si existe la palabra a sombrear</param>
        /// <returns>Una cadena que representa la expresion de sombreado en HTML</returns>
        /// <remarks>By Ronny Carreras</remarks>
        public static string HighlightText(string searchWord, string inputText)
        {

            Regex expression = new Regex(searchWord.Replace(" ", "|"), RegexOptions.IgnoreCase);
            return expression.Replace(inputText, new MatchEvaluator(ReplaceKeywords));

        }

        public static string ReplaceKeywords(Match m)
        {
            return "<span class='highlight'>" + m.Value + "</span>";
        }

        public static DataTable getTipoSangre()
        {

            OracleParameter[] arrParam = new OracleParameter[2];

            arrParam[0] = new OracleParameter("p_IOCURSOR", OracleDbType.RefCursor);
            arrParam[0].Direction = ParameterDirection.Output;
            arrParam[1] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[1].Direction = ParameterDirection.Output;

            String cmdStr = "Sre_Ciudadano_Pkg.getTipoSangre";

            try
            {
                return DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam).Tables[0];
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }

        public static DataTable getNacionalidad()
        {

            OracleParameter[] arrParam = new OracleParameter[2];

            arrParam[0] = new OracleParameter("p_IOCURSOR", OracleDbType.RefCursor);
            arrParam[0].Direction = ParameterDirection.Output;
            arrParam[1] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[1].Direction = ParameterDirection.Output;

            String cmdStr = "Sre_Ciudadano_Pkg.getNacionalidad";

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

                Exepciones.Log.LogToDB(ex.ToString());

                throw ex;

            }

        }

        public static string getMes(int mes)
        {
            string Resultado;
            switch (mes)
            {
                case 1:
                    Resultado = "Enero";
                    break;
                case 2:
                    Resultado = "Febrero";
                    break;
                case 3:
                    Resultado = "Marzo";
                    break;
                case 4:
                    Resultado = "Abril";
                    break;
                case 5:
                    Resultado = "Mayo";
                    break;
                case 6:
                    Resultado = "Junio";
                    break;
                case 7:
                    Resultado = "Julio";
                    break;
                case 8:
                    Resultado = "Agosto";
                    break;
                case 9:
                    Resultado = "Septiembre";
                    break;
                case 10:
                    Resultado = "Octubre";
                    break;
                case 11:
                    Resultado = "Noviembre";
                    break;
                case 12:
                    Resultado = "Diciembre";
                    break;
                default:
                    Resultado = "";
                    break;
            }
            return Resultado;

        }

        public static bool ImagenValida(string contentType)
        {
            switch (contentType)
            {
                case "image/pjpeg":
                    return true;
                case "image/jpeg":
                    return true;
                case "image/jpg":
                    return true;
                case "image/tif":
                    return true;
                case "image/tiff":
                    return true;
                case "application/pdf":
                    return true;
                default:
                    return false;
            }
        }

        public static bool ImagenValidaJPG(string contentType)
        {
            switch (contentType)
            {
                case "image/pjpeg":
                    return true;
                case "image/jpeg":
                    return true;
                case "image/jpg":
                    return true;
                default:
                    return false;
            }
        }

        public static bool procesarPY(string tipoArchivo)
        {
            OracleParameter[] arrParam = new OracleParameter[2];

            arrParam[0] = new OracleParameter("p_id_tipo_Archivo", OracleDbType.Varchar2);
            arrParam[0].Value = tipoArchivo;

            arrParam[1] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[1].Direction = ParameterDirection.Output;

            string Package = "sre_archivos_pkg.isProcesarPY";
            bool result;
            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, Package, arrParam);
                if (arrParam[1].Value.ToString() == "S")
                {
                    result = true;
                }
                else { result = false; }

            }
            catch (Exception ex)
            {
                throw ex;
            }

            return result;

        }

        //**************************Para obtener

        [DllImport(@"urlmon.dll", CharSet = CharSet.Auto)]
        private extern static System.UInt32 FindMimeFromData(
            System.UInt32 pBC,
            [MarshalAs(UnmanagedType.LPStr)] System.String pwzUrl,
            [MarshalAs(UnmanagedType.LPArray)] byte[] pBuffer,
            System.UInt32 cbSize,
            [MarshalAs(UnmanagedType.LPStr)] System.String pwzMimeProposed,
            System.UInt32 dwMimeFlags,
            out System.UInt32 ppwzMimeOut,
            System.UInt32 dwReserverd
        );
        public static string getMimeFromFile(byte[] buffer)
        {
            //if (!File.Exists(filename))
            //    throw new Exception(filename + " not found");
            //byte[] buffer = new byte[256];
            //using (FileStream fs = new FileStream(filename, FileMode.Open))
            //{
            //    if (fs.Length >= 256)
            //        fs.Read(buffer, 0, 256);
            //    else
            //        fs.Read(buffer, 0, (int)fs.Length);
            //}
            try
            {
                System.UInt32 mimetype;
                FindMimeFromData(0, null, buffer, 256, null, 0, out mimetype, 0);
                System.IntPtr mimeTypePtr = new IntPtr(mimetype);
                string mime = Marshal.PtrToStringUni(mimeTypePtr);
                Marshal.FreeCoTaskMem(mimeTypePtr);
                return mime;
            }
            catch (Exception e)
            {
                SuirPlus.Exepciones.Log.LogToDB(e.ToString());
                return "unknown/unknown";
            }
        }

        public static bool IsDateTimeValid(string txtDate)
        {
            DateTime tempDate;

            return DateTime.TryParse(txtDate, out tempDate) ? true : false;
        }

        public static string InsertarMensajeInbox(int regpatronal, string mensaje, string asunto, string usuario)
        {

            OracleParameter[] arrParam = new OracleParameter[5];

            arrParam[0] = new OracleParameter("p_id_registro_patronal", OracleDbType.Int32);
            arrParam[0].Value = regpatronal;
            arrParam[1] = new OracleParameter("p_mensaje", OracleDbType.NVarchar2, 4000);
            arrParam[1].Value = mensaje;
            arrParam[2] = new OracleParameter("p_asunto", OracleDbType.NVarchar2, 40);
            arrParam[2].Value = asunto;
            arrParam[3] = new OracleParameter("p_usuario", OracleDbType.NVarchar2, 35);
            arrParam[3].Value = usuario;
            arrParam[4] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[4].Direction = ParameterDirection.Output;

            String cmdStr = "InsertarMensajeInbox";

            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                return arrParam[4].Value.ToString();
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }

        public static string LimpiarUrlWebSites(string url)
        {
            var resultado = url.Replace("/", "");
            resultado = resultado.Replace(".asmx", "");
            return resultado;
        }
    }
}
