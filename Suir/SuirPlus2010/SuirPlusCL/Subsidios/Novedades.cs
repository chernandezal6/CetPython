using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using SuirPlus.Empresas;
using SuirPlus.DataBase;
using SuirPlus.Bancos;
using Oracle.ManagedDataAccess.Client;
namespace SuirPlus.Subsidios
{
    public class Novedades
    {
        /// <summary>
        /// Obtener un listado de las novedades que una afiliada tiene.
        /// </summary>
        /// <param name="NSS">NSS de la afiliada</param>
        /// <returns>Listado de novedades pendientes para ese NSS y ese registro patronal</returns>
        public static List<NovedadesPendientes> ObtenerOpcionesMenu(Int32 NSS, Int32 RegistroPatronal)
        {

            var result = new List<NovedadesPendientes>();

            OracleParameter[] parameters = new OracleParameter[4];

            parameters[0] = new OracleParameter("p_idnss", NSS);

            parameters[1] = new OracleParameter("p_idregistropatronal", RegistroPatronal);

            parameters[2] = new OracleParameter("p_resultnumber", OracleDbType.Varchar2, 200);
            parameters[2].Direction = ParameterDirection.InputOutput;

            parameters[3] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            parameters[3].Direction = ParameterDirection.InputOutput;

            try
            {
                var novedades = OracleHelper.ExecuteDataset(System.Data.CommandType.StoredProcedure, "SUB_SFS_NOVEDADES.getOpcionesMenu", parameters).Tables[0].AsEnumerable();


                foreach (var item in novedades)
                {
                    result.Add(new NovedadesPendientes()
                    {

                        Completado = item.Field<String>("Completado"),
                        Descripcion = item.Field<String>("Descripcion"),
                        Modificado = item.Field<String>("Modificado"),
                        TipoNovedad = item.Field<String>("TipoNovedad"),
                        Url = item.Field<String>("Url"),
                        NroSolicitud = item.Field<Decimal>("NroSolicitud") 
                    });

                }
                return result;

            }
            catch (Exception ex)
            {

                SuirPlus.Exepciones.Log.LogToDB(ex.Message);
                throw ex;
            }

        }


        /// <summary>
        /// Obtener un listado de las opciones que una afiliada tiene para el subsidio de Enfermedad Comun.
        /// </summary>
        /// <param name="NSS">NSS de la afiliada</param>
        /// <param name="RegistroPatronal">Registro Patronal de donde trabaja la trabajadora.</param>
        /// <returns></returns>
        public static List<NovedadesPendientes> ObtenerOpcionesMenuEnfermedadComun(Int32 NSS, Int32 RegistroPatronal) 
        {
            var result = new List<NovedadesPendientes>();


            OracleParameter[] parameters = new OracleParameter[4];

            parameters[0] = new OracleParameter("p_idnss", NSS);

            parameters[1] = new OracleParameter("p_idregistropatronal", RegistroPatronal);

            parameters[2] = new OracleParameter("p_resultnumber", OracleDbType.Varchar2, 200);
            parameters[2].Direction = ParameterDirection.InputOutput;

            parameters[3] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            parameters[3].Direction = ParameterDirection.InputOutput;

            try
            {


                var opciones = OracleHelper.ExecuteDataset(System.Data.CommandType.StoredProcedure, "SUB_SFS_NOVEDADES.getOpcionesMenuEC", parameters).Tables[0].AsEnumerable();

                foreach (var item in opciones)
                {
                    result.Add(new NovedadesPendientes()
                    {
                        Descripcion = item.Field<String>("Descripcion"),
                        Modificado = item.Field<String>("Modificado"),
                        Url = item.Field<String>("Url"),
                        NroSolicitud = item.Field<Decimal>("NroSolicitud"),
                        Completado = item.Field<String>("Completado")
                    });  
                }


                return result;
            }
            catch (Exception ex)
            {

                throw ex;
            }
        
        } 

        /// <summary>
        /// Funcion para Obtener el nro de formulario.
        /// </summary>
        /// <param name="NSS">NSS de la trabajadora</param>
        /// <param name="Tipo">Tipo de Subsidio M = Maternidad, E = Enfermedad Comun</param>
        /// <returns></returns>
        public static String obtenerNumeroFormulario(Int32 NSS, Int32 RegistroPatronal, TipoSubsidio Tipo)
        {
            var mitipo = String.Empty;

            if (Tipo == TipoSubsidio.Maternidad)
            {
                mitipo = "M";
            }
            else if (Tipo == TipoSubsidio.EnfermedadComun)
            {
                mitipo = "E";
            }


            OracleParameter[] parameters = new OracleParameter[5];

            parameters[0] = new OracleParameter("p_id_nss", NSS);

            parameters[1] = new OracleParameter("p_id_registro_patronal", RegistroPatronal);

            parameters[2] = new OracleParameter("p_tipo", mitipo);

            parameters[3] = new OracleParameter("p_nroformulario", OracleDbType.Varchar2, 200);
            parameters[3].Direction = ParameterDirection.Output;

            parameters[4] = new OracleParameter("p_resultnumber", OracleDbType.Varchar2, 200);
            parameters[4].Direction = ParameterDirection.Output;

            try
            {
                OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, "SUB_SFS_NOVEDADES.getNumeroFormulario", parameters);

                var nroformulario = Convert.ToString(parameters[3].Value);

                return nroformulario;

            }
            catch (Exception ex)
            {
                SuirPlus.Exepciones.Log.LogToDB(ex.Message);
                throw ex;
            }

        }
        /// <summary>
        /// Metodo que retorna los datos generales de un trabajador
        /// </summary>
        /// <param name="Cedula">Cedula de la trabajadora</param>
        /// <param name="RegistroPatronal">Registro Patronal donde esta laborando la trabajadora</param>
        /// <param name="result">Resultado de la Funcion</param>
        /// <returns>Retorna el detalle de la trabajadora</returns>
        public static DatosGeneralesTrabajadora ObtenerDetalleTrabajadora(String Cedula, Int32 RegistroPatronal, out String result)
        {

            var DatosTrabajadora = new DatosGeneralesTrabajadora();
            int? RegPatronal = RegistroPatronal;

            Trabajador tr = null;

            try
            {
                // Buscar por NSS // 
                if (Cedula.Length == 0)

                    tr = new SuirPlus.Empresas.Trabajador(Convert.ToInt32(Cedula));

                // Buscar por Cedula //
                else

                    tr = new SuirPlus.Empresas.Trabajador(Trabajador.TrabajadorDocumentoType.Cedula, Cedula);


                var empleada = tr.getTrabajador().AsEnumerable().FirstOrDefault(t => t.Field<Int32?>("ID_REGISTRO_PATRONAL") == RegPatronal);

                if(( empleada != null) && (tr.getTrabajador().Rows.Count > 0))
                {

                    DatosTrabajadora.nss = empleada.Field<long>("ID_NSS");

                    if (empleada.Field<String>("SEXO").Equals("F"))
                    {
                        DatosTrabajadora.sexo = "Femenino";
                    }
                    else if (empleada.Field<String>("SEXO").Equals("M"))
                    {
                        DatosTrabajadora.sexo = "Masculino";
                    }
                    
                    DatosTrabajadora.nombres = empleada.Field<String>("NOMBRES") + " " + empleada.Field<String>("PRIMER_APELLIDO") + " " + empleada.Field<String>("SEGUNDO_APELLIDO");
                    DatosTrabajadora.cedula = empleada.Field<String>("NO_DOCUMENTO");
                    DatosTrabajadora.fechanacimiento = empleada.Field<DateTime>("FECHA_NACIMIENTO").ToShortDateString();

                    result = "OK";
                }
                else
                {
                    result = "No existe este trabajador para este registro patronal";
                   return DatosTrabajadora;
                }
                return DatosTrabajadora;
            }
            catch (Exception ex)
            {
                result = ex.Message;
                SuirPlus.Exepciones.Log.LogToDB(ex.Message);
                return DatosTrabajadora;
            }

        }
        /// <summary>
        /// Metodo para obtener una lista de las Entidades Recuaudadoras del SFS.
        /// </summary>
        /// <returns></returns>
        public static List<EntidadRecaudadora> ObtenerEntidadesRecaudadoras()
        {
            var mientidad = new List<EntidadRecaudadora>();

            try
            {
                var entidadesrecaudadoras = EntidadRecaudadora.getEntidadesParaSFS().AsEnumerable();

                foreach (var item in entidadesrecaudadoras)
                {
                    mientidad.Add(new EntidadRecaudadora()
                    {
                        Cuenta = item.Field<String>("CUENTA_RECAUDADORA"),
                        Descripcion = item.Field<String>("ENTIDAD_RECAUDADORA_DES"),
                        IdEntidadRecaudadora = Convert.ToUInt32(item["ID_ENTIDAD_RECAUDADORA"])
                    });
                }

                return mientidad;
            }
            catch (Exception ex)
            {

                SuirPlus.Exepciones.Log.LogToDB(ex.Message);
                throw ex;
            }
        }


        public static DatosGeneralesTrabajadora ObtenerNssTrabajadora(String nrodocumento)
        {

            try
            {
                OracleParameter[] parameters = new OracleParameter[2];

                parameters[0] = new OracleParameter("P_NroDocumento ", nrodocumento);

                parameters[1] = new OracleParameter("P_NSS", OracleDbType.Int32, 200);
                parameters[1].Direction = ParameterDirection.Output;

                OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, "SUB_SFS_SUBSIDIOS.getNSS", parameters);


                var trabajadora = new DatosGeneralesTrabajadora() { nss = long.Parse(parameters[1].Value.ToString()) };

                return trabajadora;
            }
            catch (Exception ex)
            {

                throw ex;
            }


        }

        public static DataTable getPssList(string prestadora_nombre)
        {
            string strCmd = "SUB_SFS_SUBSIDIOS.getPssList";

            OracleParameter[] arrParam = new OracleParameter[2];

            arrParam[0] = new OracleParameter("p_prestadora_nombre ", prestadora_nombre);

            arrParam[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

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

        public static List<DetalleNomina> ObtenerNominaDiscapacitados(Int32 NSS, Int32 RegistroPatronal) 
        {
            var result = new List<DetalleNomina>();

            OracleParameter[] parameters = new OracleParameter[4];

            parameters[0] = new OracleParameter("p_idnss", NSS);

            parameters[1] = new OracleParameter("p_idRegistroPatronal", RegistroPatronal);

            parameters[2] = new OracleParameter("p_resultnumber", OracleDbType.Varchar2, 200);
            parameters[2].Direction = ParameterDirection.InputOutput;

            parameters[3] = new OracleParameter("p_io_cursor", OracleDbType.RefCursor);
            parameters[3].Direction = ParameterDirection.InputOutput;

            try
            {


                var nominas = OracleHelper.ExecuteDataset(System.Data.CommandType.StoredProcedure, "SUB_SFS_SUBSIDIOS.getNominaDiscapacitados", parameters).Tables[0].AsEnumerable();

                foreach (var item in nominas)
                {
                    result.Add(new DetalleNomina()
                    {
                        idnomina = item.Field<Int32>("id_nomina"),
                        nomina = item.Field<String>("nomina_des"),
                        NSS = item.Field<long>("id_nss"),
                        RegistroPatronal = item.Field<Int32>("id_registro_patronal") 
                         
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

       

    }
    /// <summary>
    /// 
    /// </summary>
    public struct DatosGeneralesTrabajadora
    {
        public long nss { get; set; }
        public string sexo { get; set; }
        public String nombres { get; set; }
        public String cedula { get; set; }
        public String fechanacimiento { get; set; }
    }
    
    /// <summary>
    /// Estructura con el detalle del menu de Maternidad y Lactancia.
    /// </summary>
    public struct NovedadesPendientes
    {
        public String Completado { get; set; }
        public String TipoNovedad { get; set; }
        public String Descripcion { get; set; }
        public String Modificado { get; set; }
        public String Url { get; set; }
        public Decimal NroSolicitud { get; set; }

    }
    /// <summary>
    /// Estructura con el detalle del menu para enfermedad comun
    /// </summary>
    public struct OpcionesEnfermedadComun
    {
        public String Descripcion { get; set; }
        public String Modificado { get; set; }
        public String Url { get; set; }
        public Decimal NroSolicitud { get; set; }
    }

    public struct DetalleNomina
    {
        public long NSS { get; set; }
        public int idnomina { get; set; }
        public String  nomina { get; set; }
        public Int32 RegistroPatronal { get; set; }
    }
}
