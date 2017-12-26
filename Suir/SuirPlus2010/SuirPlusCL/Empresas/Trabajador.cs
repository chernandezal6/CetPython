using System;
using System.Data;
using Oracle.ManagedDataAccess.Client;

namespace SuirPlus.Empresas
{
    /// <summary>
    /// 
    /// </summary>
    public class Trabajador
    {

        #region Miembros internos y propiedades publicas

        int myNSS;
        string myNombres;
        string myPrimerApellido;
        string mySegundoApellido;
        string myEstadoCivil;
        DateTime myFechaNacimiento;
        string myTipoDocumento;
        string myDocumento;
        string mySexo;
        int registropatronal;
        //add fausto
        string myStatus;

        public int NSS
        {
            get
            {
                return myNSS;
            }
        }

        public string Nombres
        {
            get
            {
                return myNombres;
            }
        }

        public string PrimerApellido
        {
            get
            {
                return myPrimerApellido;
            }
        }

        public string SegundoApellido
        {
            get
            {
                return mySegundoApellido;
            }
        }

        public string EstadoCivil
        {
            get
            {
                return myEstadoCivil;
            }
        }

        public DateTime FechaNacimiento
        {
            get
            {
                return myFechaNacimiento;
            }
        }

        public string TipoDocumento
        {
            get
            {
                return myTipoDocumento;
            }
        }

        public string Documento
        {
            get
            {
                return myDocumento;
            }
        }

        public string Sexo
        {
            get
            {
                return mySexo;
            }
        }

        //add fausto
        /// <summary>
        /// Retorna el valor del estatus en base al id_nss del trabajador
        /// </summary>
        public string Estatus
        {
            get
            {
                return myStatus;
            }
        }
        public int RegistroPatronal
        {
            get { return registropatronal; }
            set { registropatronal = value; }
        }


        #endregion

        public Trabajador(int nss)
        {

            this.myNSS = nss;
            this.CargarDatos();

        }


        public Trabajador(TrabajadorDocumentoType tipoDocumento, string documento)
        {
            if (tipoDocumento == TrabajadorDocumentoType.Pasaporte)
            {
                this.myTipoDocumento = "P";
            }
            else
            {
                this.myTipoDocumento = "C";
            }

            this.myDocumento = documento;
            this.CargarDatos();
        }


        public void CargarDatos()
        {

            DataTable dtTrabajador = this.getTrabajador();

            if (dtTrabajador.Rows.Count > 0)
            {
                try
                {
                    this.myNSS = Convert.ToInt32(dtTrabajador.Rows[0]["ID_NSS"]);
                    this.myNombres = dtTrabajador.Rows[0]["NOMBRES"].ToString();
                    this.myPrimerApellido = dtTrabajador.Rows[0]["PRIMER_APELLIDO"].ToString();
                    this.mySegundoApellido = dtTrabajador.Rows[0]["SEGUNDO_APELLIDO"].ToString();
                    this.myEstadoCivil = dtTrabajador.Rows[0]["ESTADO_CIVIL"].ToString();
                    this.myFechaNacimiento = Convert.ToDateTime(dtTrabajador.Rows[0]["FECHA_NACIMIENTO"]);
                    this.myTipoDocumento = dtTrabajador.Rows[0]["TIPO_DOCUMENTO"].ToString();
                    this.myDocumento = dtTrabajador.Rows[0]["NO_DOCUMENTO"].ToString();
                    this.mySexo = dtTrabajador.Rows[0]["SEXO"].ToString();
                    this.myStatus = dtTrabajador.Rows[0]["status"].ToString();

                    if (dtTrabajador.Rows[0]["ID_REGISTRO_PATRONAL"].ToString() != "")
                    {
                        this.RegistroPatronal = Convert.ToInt32(dtTrabajador.Rows[0]["ID_REGISTRO_PATRONAL"]);
                    }

                }

                catch (Exception ex)
                {
                    throw ex;
                }
            }
            else
            {
                throw new Exception("No existen registros para este trabajador.");
            }

        }


        public DataTable getTrabajador()
        {
            DataTable dtTrabajador;
            string cmdStr = "SRE_TRABAJADOR_PKG.Cargar_Datos";
            string result = "0";
            if (this.myNSS != 0)
            {
                OracleParameter[] arrParam = new OracleParameter[3];

                arrParam[0] = new OracleParameter("p_id_nss", OracleDbType.Decimal);
                arrParam[0].Value = this.myNSS;

                arrParam[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
                arrParam[1].Direction = ParameterDirection.Output;

                arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 1000);
                arrParam[2].Direction = ParameterDirection.Output;

                try
                {
                    DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);
                    result = arrParam[2].Value.ToString();

                    if (result != "0")
                    {
                        string[] ErrorMsg = result.Split('|');
                        throw new Exception(ErrorMsg[1]);
                    }

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

            else
            {

                OracleParameter[] arrParam = new OracleParameter[4];

                arrParam[0] = new OracleParameter("p_tipo_doc", OracleDbType.NVarchar2, 1);
                arrParam[0].Value = this.myTipoDocumento;

                arrParam[1] = new OracleParameter("p_doc", OracleDbType.NVarchar2, 25);
                arrParam[1].Value = this.myDocumento;

                arrParam[2] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
                arrParam[2].Direction = ParameterDirection.Output;

                arrParam[3] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 1000);
                arrParam[3].Direction = ParameterDirection.Output;

                try
                {
                    DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);
                    result = arrParam[3].Value.ToString();

                    if (result != "0")
                    {
                        string[] ErrorMsg = result.Split('|');
                        throw new Exception(ErrorMsg[1]);
                    }

                    if (ds.Tables.Count > 0)
                    {
                        return ds.Tables[0];
                    }
                    dtTrabajador = new DataTable("No Hay Data");

                }
                catch (Exception ex)
                {
                    Exepciones.Log.LogToDB(ex.ToString());
                    throw ex;
                }

            }

            return dtTrabajador;

        }


        public DataTable getInfoNominaEmpleador(int regPatronal, int idNomina)
        {

            string cmdStr = "sre_trabajador_pkg.Get_Info_Nomina";
            OracleParameter[] arrParam = new OracleParameter[5];

            arrParam[0] = new OracleParameter("p_id_nss", OracleDbType.Decimal);
            arrParam[0].Value = this.NSS;

            arrParam[1] = new OracleParameter("p_reg_patronal", OracleDbType.Decimal);
            arrParam[1].Value = regPatronal;

            arrParam[2] = new OracleParameter("p_id_nomina", OracleDbType.Decimal);
            arrParam[2].Value = idNomina;

            arrParam[3] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[3].Direction = ParameterDirection.Output;

            arrParam[4] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 1000);
            arrParam[4].Direction = ParameterDirection.Output;

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


        public DataTable getEmpleadorAfiliadosActivos()
        {

            string cmdStr = "sre_trabajador_pkg.Get_Emp_Afiliados_Activo";
            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_id_nss", OracleDbType.Decimal);
            arrParam[0].Value = this.NSS;

            arrParam[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 1000);
            arrParam[2].Direction = ParameterDirection.Output;

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


        public DataTable getEmpleadorAfiliadosInactivos()
        {

            string cmdStr = "sre_trabajador_pkg.Get_Emp_Afiliados_Inactivo";
            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_id_nss", OracleDbType.Decimal);
            arrParam[0].Value = this.NSS;

            arrParam[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 1000);
            arrParam[2].Direction = ParameterDirection.Output;

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


        public DataTable getAportes(string rncEmpleador, string ano)
        {

            string cmdStr = "sre_trabajador_pkg.Get_Aportes_Trabajadores";
            OracleParameter[] arrParam = new OracleParameter[5];

            arrParam[0] = new OracleParameter("p_id_nss", OracleDbType.Decimal);
            arrParam[0].Value = this.NSS;

            arrParam[1] = new OracleParameter("p_rnc_cedula", OracleDbType.NVarchar2, 11);
            arrParam[1].Value = rncEmpleador;

            arrParam[2] = new OracleParameter("p_ano", OracleDbType.NVarchar2, 4);
            arrParam[2].Value = ano;

            arrParam[3] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[3].Direction = ParameterDirection.Output;

            arrParam[4] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 1000);
            arrParam[4].Direction = ParameterDirection.Output;

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


        public static DataTable getDependientes(string rncEmpleador, int Nomina)
        {
            string cmdStr = "sre_trabajador_pkg.Get_Dependientes";
            OracleParameter[] arrParam = new OracleParameter[4];

            arrParam[0] = new OracleParameter("p_reg_patronal", OracleDbType.NVarchar2, 11);
            arrParam[0].Value = rncEmpleador;

            arrParam[1] = new OracleParameter("p_id_nomina", OracleDbType.Decimal);
            arrParam[1].Value = Nomina;

            arrParam[2] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[2].Direction = ParameterDirection.Output;

            arrParam[3] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 1000);
            arrParam[3].Direction = ParameterDirection.Output;

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

        public static DataTable getDependientes(int idNss)
        {
            string cmdStr = "sre_trabajador_pkg.Get_Dependientes";
            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_id_nss", OracleDbType.Decimal);
            arrParam[0].Value = idNss;

            arrParam[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 1000);
            arrParam[2].Direction = ParameterDirection.Output;

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

        public static DataTable getDependientes(string idReferencia)
        {
            string cmdStr = "sre_trabajador_pkg.Get_Dependientes";
            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_referencia", OracleDbType.NVarchar2, 16);
            arrParam[0].Value = idReferencia;

            arrParam[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 1000);
            arrParam[2].Direction = ParameterDirection.Output;

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


        //Metodo para la Consulta de Dependientes Adicionales : Representantes

        public static DataTable getDependienteAdicional(int registro_patronal, int pageNum, int pageSize)
        {
            string cmdStr = "sre_trabajador_pkg.get_DependienteAdicional";
            OracleParameter[] arrParam = new OracleParameter[5];

            arrParam[0] = new OracleParameter("p_id_registro_patronal", OracleDbType.Decimal);
            arrParam[0].Value = registro_patronal;

            arrParam[1] = new OracleParameter("p_pagenum", OracleDbType.Decimal);
            arrParam[1].Value = pageNum;

            arrParam[2] = new OracleParameter("p_pagesize", OracleDbType.Decimal);
            arrParam[2].Value = pageSize;

            arrParam[3] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[3].Direction = ParameterDirection.Output;

            arrParam[4] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 1000);
            arrParam[4].Direction = ParameterDirection.Output;


            try
            {
                //Ejecutamos el commando.
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);



                if (arrParam[4].Value.ToString() != "0")
                {
                    throw new Exception(arrParam[4].Value.ToString());
                }

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
        //Metodo para la Consulta de Dependientes Adicionales : Representantes para filtrar la busqueda por nombre de dependiente
        //o nombre del titular.

        public static DataTable BuscarDependienteAdicional(string nombre, int registro_patronal, int pageNum, int pageSize)
        {
            string cmdStr = "sre_trabajador_pkg.get_BuscarDepenAdicional";
            OracleParameter[] arrParam = new OracleParameter[6];

            arrParam[0] = new OracleParameter("p_nombres", OracleDbType.NVarchar2, 1000);
            arrParam[0].Value = nombre;

            arrParam[1] = new OracleParameter("p_id_registro_patronal", OracleDbType.Decimal);
            arrParam[1].Value = registro_patronal;

            arrParam[2] = new OracleParameter("p_pagenum", OracleDbType.Decimal);
            arrParam[2].Value = pageNum;

            arrParam[3] = new OracleParameter("p_pagesize", OracleDbType.Decimal);
            arrParam[3].Value = pageSize;

            arrParam[4] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[4].Direction = ParameterDirection.Output;

            arrParam[5] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 1000);
            arrParam[5].Direction = ParameterDirection.Output;


            try
            {
                //Ejecutamos el commando.
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);



                if (arrParam[5].Value.ToString() != "0")
                {
                    throw new Exception(arrParam[5].Value.ToString());
                }

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




        //Metodo para paginacion por registro patronal y nomina
        //Creado por Gregorio Herrera
        public static DataTable getDependientes(int regPatronal, int idNomina, string tipoCriterio, string criterio, int pageNum, Int16 pageSize)
        {
            string cmdStr = "SRE_TRABAJADOR_PKG.GetPage_Dependientes";
            OracleParameter[] arrParam = new OracleParameter[8];

            arrParam[0] = new OracleParameter("p_reg_patronal", OracleDbType.Decimal);
            arrParam[0].Value = regPatronal;

            arrParam[1] = new OracleParameter("p_id_nomina", OracleDbType.Decimal);
            arrParam[1].Value = idNomina;

            arrParam[2] = new OracleParameter("p_tipo", OracleDbType.NVarchar2, 1);
            arrParam[2].Value = tipoCriterio;

            arrParam[3] = new OracleParameter("p_criterio", OracleDbType.NVarchar2, 30);
            arrParam[3].Value = criterio;

            arrParam[4] = new OracleParameter("p_pagenum", OracleDbType.Decimal);
            arrParam[4].Value = pageNum;

            arrParam[5] = new OracleParameter("p_pagesize", OracleDbType.Decimal);
            arrParam[5].Value = pageSize;

            arrParam[6] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[6].Direction = ParameterDirection.Output;

            arrParam[7] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 1000);
            arrParam[7].Direction = ParameterDirection.Output;

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

        //Metodo para paginacion por referencia
        //Creado por Gregorio Herrera
        public static DataTable getDependientes(string referencia, string tipoCriterio, string criterio, int pageNum, Int16 pageSize)
        {
            string cmdStr = "SRE_TRABAJADOR_PKG.GetPage_Dependientes";
            OracleParameter[] arrParam = new OracleParameter[7];

            arrParam[0] = new OracleParameter("p_referencia", OracleDbType.NVarchar2, 16);
            arrParam[0].Value = referencia;

            arrParam[1] = new OracleParameter("p_tipo", OracleDbType.NVarchar2, 1);
            arrParam[1].Value = tipoCriterio;

            arrParam[2] = new OracleParameter("p_criterio", OracleDbType.NVarchar2, 30);
            arrParam[2].Value = criterio;

            arrParam[3] = new OracleParameter("p_pagenum", OracleDbType.Decimal);
            arrParam[3].Value = pageNum;

            arrParam[4] = new OracleParameter("p_pagesize", OracleDbType.Decimal);
            arrParam[4].Value = pageSize;

            arrParam[5] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[5].Direction = ParameterDirection.Output;

            arrParam[6] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 1000);
            arrParam[6].Direction = ParameterDirection.Output;

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


        //PAra la pantalla de consulta de historico de salarios para la SIPEN
        public static DataTable getConsultasRealizadas(int id_entidad_recaudadora, int pageNum, Int16 pageSize)
        {
            string cmdStr = "SFC_ENTIDAD_RECAUDADORA_PKG.GetConsultasRealizadas";
            OracleParameter[] arrParam = new OracleParameter[5];

            arrParam[0] = new OracleParameter("p_entidad_recaudadora", OracleDbType.Int32);
            arrParam[0].Value = id_entidad_recaudadora;

            arrParam[1] = new OracleParameter("p_pagenum", OracleDbType.Decimal);
            arrParam[1].Value = pageNum;

            arrParam[2] = new OracleParameter("p_pagesize", OracleDbType.Decimal);
            arrParam[2].Value = pageSize;

            arrParam[3] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[3].Direction = ParameterDirection.Output;

            arrParam[4] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 1000);
            arrParam[4].Direction = ParameterDirection.Output;

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


        //PAra la pantalla de consulta de historico de salarios para la SIPEN
        public static DataTable getHistoricoSalarios(string cedula, int pageNum, Int16 pageSize)
        {
            string cmdStr = "SFC_ENTIDAD_RECAUDADORA_PKG.getHistoricoSalarios";
            OracleParameter[] arrParam = new OracleParameter[5];

            arrParam[0] = new OracleParameter("p_cedula", OracleDbType.Varchar2);
            arrParam[0].Value = cedula;

            arrParam[1] = new OracleParameter("p_pagenum", OracleDbType.Decimal);
            arrParam[1].Value = pageNum;

            arrParam[2] = new OracleParameter("p_pagesize", OracleDbType.Decimal);
            arrParam[2].Value = pageSize;

            arrParam[3] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[3].Direction = ParameterDirection.Output;

            arrParam[4] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 1000);
            arrParam[4].Direction = ParameterDirection.Output;

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

        //PAra la pantalla de consulta de historico de salarios para la SIPEN
        public static String InsertarHistoricoSalarios(string cedula, int id_usuario, int id_entidad_recaudadora_afil, int id_entidad_rec_cons, string aprobado, Byte[] archivos)
        {
            string cmdStr = "SFC_ENTIDAD_RECAUDADORA_PKG.insertarhistorico";
            OracleParameter[] arrParam = new OracleParameter[6];

            arrParam[0] = new OracleParameter("p_cedula", OracleDbType.Varchar2);
            arrParam[0].Value = cedula;

            arrParam[1] = new OracleParameter("p_id_usuario", OracleDbType.Decimal);
            arrParam[1].Value = id_usuario;

            arrParam[2] = new OracleParameter("p_id_entidad_rec_afiliado", OracleDbType.Decimal);
            arrParam[2].Value = id_entidad_recaudadora_afil;

            arrParam[3] = new OracleParameter("p_id_entidad_rec_cons", OracleDbType.Decimal);
            arrParam[3].Value = id_entidad_rec_cons;

            arrParam[4] = new OracleParameter("p_aprobado", OracleDbType.Varchar2 );
            arrParam[4].Value = aprobado;

            arrParam[5] = new OracleParameter("p_archivo", OracleDbType.Clob);
            arrParam[5].Value = archivos;


            try
            {
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);
                return "0";

            }

            catch (Exception ex)
            {

                Exepciones.Log.LogToDB(ex.ToString());

                throw ex;


            }

        }



        //PAra la pantalla de consulta de historico de salarios para la SIPEN
        public static DataTable getInfoConsultasRealizadas(int id_consulta)
        {
            string cmdStr = "SFC_ENTIDAD_RECAUDADORA_PKG.getInfoConsultasRealizadas";
            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_id_consulta", OracleDbType.Int32);
            arrParam[0].Value = id_consulta;

            arrParam[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 1000);
            arrParam[2].Direction = ParameterDirection.Output;

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


        public static string isUsuarioAFP(int id_entidad_recaudadora, string usuario)
        {
            OracleParameter[] arrParam;
            String cmdStr = "SFC_Entidad_Recaudadora_PKG.isUsuarioAFP";

            DataTable dt = new DataTable();

            //Definimos nuestro arreglo de parametros.
            arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_id_entidad_recaudadora", OracleDbType.Int16);
            arrParam[0].Value = id_entidad_recaudadora;

            arrParam[1] = new OracleParameter("p_id_usuario", OracleDbType.Varchar2);
            arrParam[1].Value = usuario;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;


            string result = string.Empty;
            try
            {

                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                result = arrParam[2].Value.ToString();

                return result;
            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;
            }
        }




        public static string TrabajadorActivoNominaEmpleador(int regPatronal, string no_documento)
        {

            OracleParameter[] arrParam = new OracleParameter[3];
            string cmdStr = "Sre_Trabajador_Pkg.isActivoNominaEmpleador";
          
            arrParam[0] = new OracleParameter("p_registro_patronal", OracleDbType.Int32);
            arrParam[0].Value = regPatronal;

            arrParam[1] = new OracleParameter("p_no_documento", OracleDbType.Varchar2);
            arrParam[1].Value = no_documento;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 500);
            arrParam[2].Direction = ParameterDirection.Output;

            string result = string.Empty;
            try
            {

                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                result = arrParam[2].Value.ToString();

                return result;
            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;
            }
        }


        /// <summary>
        /// Tipo de documento del trabajador
        /// </summary>

        public enum TrabajadorDocumentoType
        {
            Cedula,
            Pasaporte
        }


        #region "  Funciones Estaticas de Validacion, Busqueda y Actualizaciones "

        /**
		 * Ejecuta la novedad de actualizacion de datos
		 * */
        public static string novedadActDatos(int registroPatronal,
                                            int idNomina,
                                            int nss,
                                            double salarioSS,
                                            double aporteVoluntario,
                                            double salarioIsr,
                                            double salarioINF,
                                            string agenteRetencion,
                                            double otrasRemuneraciones,
                                            double remuneracionOtroEmpleador,
                                            DateTime fechaIngreso,
                                            double ingresosExentos,
                                            double saldoFavor,
                                            String usuario,
                                            int tipoIngreso, string IPAddress)
        {

            OracleParameter[] arrParam = new OracleParameter[17];

            arrParam[0] = new OracleParameter("p_id_RegistroPatronal", OracleDbType.Decimal);
            arrParam[0].Value = registroPatronal;
            arrParam[1] = new OracleParameter("p_id_Nomina", OracleDbType.Decimal);
            arrParam[1].Value = idNomina;
            arrParam[2] = new OracleParameter("p_id_NSS", OracleDbType.Decimal);
            arrParam[2].Value = nss;
            arrParam[3] = new OracleParameter("p_SalarioSS", OracleDbType.Decimal);
            arrParam[3].Value = salarioSS;
            arrParam[4] = new OracleParameter("p_AporteVoluntario", OracleDbType.Decimal);
            arrParam[4].Value = aporteVoluntario;
            arrParam[5] = new OracleParameter("p_SalarioIsr", OracleDbType.Decimal);
            arrParam[5].Value = salarioIsr;
            arrParam[6] = new OracleParameter("p_SalarioINF", OracleDbType.Decimal);
            arrParam[6].Value = salarioINF;

            arrParam[7] = new OracleParameter("p_AgenteRetencionIsr", OracleDbType.NVarchar2, 11);
            arrParam[7].Value = agenteRetencion;
            arrParam[8] = new OracleParameter("p_OtrasRemunIsr", OracleDbType.Decimal);
            arrParam[8].Value = otrasRemuneraciones;
            arrParam[9] = new OracleParameter("p_RemunOtroEmp", OracleDbType.Decimal);
            arrParam[9].Value = remuneracionOtroEmpleador;
            arrParam[10] = new OracleParameter("p_IngresosExentos", OracleDbType.Decimal);
            arrParam[10].Value = ingresosExentos;
            arrParam[11] = new OracleParameter("p_SaldoFavor", OracleDbType.Decimal);
            arrParam[11].Value = saldoFavor;
            arrParam[12] = new OracleParameter("p_FechaIngreso", OracleDbType.Date);
            arrParam[12].Value = fechaIngreso;
            arrParam[13] = new OracleParameter("p_ID_Usuario", OracleDbType.NVarchar2, 35);
            arrParam[13].Value = usuario;
            arrParam[14] = new OracleParameter("p_tipo_ingreso", OracleDbType.Decimal);
            arrParam[14].Value = tipoIngreso;
            arrParam[15] = new OracleParameter("p_IPAddress", OracleDbType.NVarchar2, 16);
            arrParam[15].Value = IPAddress;
            arrParam[16] = new OracleParameter("p_ResultNumber", OracleDbType.NVarchar2, 200);
            arrParam[16].Direction = ParameterDirection.Output;

            String cmdStr = "SRE_NOVEDADES_PKG.Novedades_ActualizaDatos_Crear";

            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                return arrParam[16].Value.ToString();
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }


        /**
         * Ejecuta la novedad de alta de empleado
         * */
        public static string novedadIngreso(int registroPatronal,
                                            int idNomina,
                                            int nss,
                                            double salarioSS,
                                            double aporteVoluntario,
                                            double salarioIsr,
                                            double salarioINF,
                                            string agenteRetencion,
                                            double otrasRemuneraciones,
                                            double remuneracionOtroEmpleador,
                                            DateTime fechaIngreso,
                                            double ingresosExentos,
                                            double saldoFavor,
                                            String usuario,
                                            int tipoIngreso,
                                            string IPAddress)
        {

            OracleParameter[] arrParam = new OracleParameter[17];

            arrParam[0] = new OracleParameter("p_id_RegistroPatronal", OracleDbType.Decimal);
            arrParam[0].Value = registroPatronal;
            arrParam[1] = new OracleParameter("p_id_Nomina", OracleDbType.Decimal);
            arrParam[1].Value = idNomina;
            arrParam[2] = new OracleParameter("p_id_NSS", OracleDbType.Decimal);
            arrParam[2].Value = nss;
            arrParam[3] = new OracleParameter("p_SalarioSS", OracleDbType.Decimal);
            arrParam[3].Value = salarioSS;
            arrParam[4] = new OracleParameter("p_AporteVoluntario", OracleDbType.Decimal);
            arrParam[4].Value = aporteVoluntario;
            arrParam[5] = new OracleParameter("p_SalarioIsr", OracleDbType.Decimal);
            arrParam[5].Value = salarioIsr;
            arrParam[6] = new OracleParameter("p_SalarioINF", OracleDbType.Decimal);
            arrParam[6].Value = salarioINF;
            arrParam[7] = new OracleParameter("p_AgenteRetencionIsr", OracleDbType.NVarchar2, 11);
            arrParam[7].Value = SuirPlus.Utilitarios.Utils.verificarNulo(agenteRetencion);
            arrParam[8] = new OracleParameter("p_OtrasRemunIsr", OracleDbType.Decimal);
            arrParam[8].Value = otrasRemuneraciones;
            arrParam[9] = new OracleParameter("p_RemunOtroEmp", OracleDbType.Decimal);
            arrParam[9].Value = remuneracionOtroEmpleador;
            arrParam[10] = new OracleParameter("p_FechaIngreso", OracleDbType.Date);
            arrParam[10].Value = fechaIngreso;
            arrParam[11] = new OracleParameter("p_IngresosExentos", OracleDbType.Decimal);
            arrParam[11].Value = ingresosExentos;
            arrParam[12] = new OracleParameter("p_SaldoFavor", OracleDbType.Decimal);
            arrParam[12].Value = saldoFavor;
            arrParam[13] = new OracleParameter("p_ID_Usuario", OracleDbType.NVarchar2, 35);
            arrParam[13].Value = usuario;
            arrParam[14] = new OracleParameter("p_tipo_ingreso", OracleDbType.Decimal);
            arrParam[14].Value = tipoIngreso;
            arrParam[15] = new OracleParameter("p_IPAddress", OracleDbType.NVarchar2, 16);
            arrParam[15].Value = IPAddress;
            arrParam[16] = new OracleParameter("p_ResultNumber", OracleDbType.NVarchar2, 200);
            arrParam[16].Direction = ParameterDirection.Output;

            String cmdStr = "SRE_NOVEDADES_PKG.Novedades_Ingreso_Crear";

            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                return arrParam[16].Value.ToString();
            }
            catch (Exception ex)
            {
                throw ex;
            }


        }

        /**
         * Ejecuta la novedad de discapacitados por enfermedad no laboral
         * */
        public static string novedadEnfNoLaboral(int registroPatronal,
                                            int idNomina,
                                            int nss,
                                            double salarioSS,
                                            double aporteVoluntario,
                                            double salarioIsr,
                                            double salarioINF,
                                            string agenteRetencion,
                                            double otrasRemuneraciones,
                                            double remuneracionOtroEmpleador,
                                            DateTime fechaIngreso,
                                            string periodo_desde,
                                            string periodo_hasta,
                                            double ingresosExentos,
                                            double saldoFavor,
                                            String usuario,
                                            int tipoIngreso,
                                            string IPAddress)
        {

            OracleParameter[] arrParam = new OracleParameter[19];

            arrParam[0] = new OracleParameter("p_id_RegistroPatronal", OracleDbType.Decimal);
            arrParam[0].Value = registroPatronal;
            arrParam[1] = new OracleParameter("p_id_Nomina", OracleDbType.Decimal);
            arrParam[1].Value = idNomina;
            arrParam[2] = new OracleParameter("p_id_NSS", OracleDbType.Decimal);
            arrParam[2].Value = nss;
            arrParam[3] = new OracleParameter("p_SalarioSS", OracleDbType.Decimal);
            arrParam[3].Value = salarioSS;
            arrParam[4] = new OracleParameter("p_AporteVoluntario", OracleDbType.Decimal);
            arrParam[4].Value = aporteVoluntario;
            arrParam[5] = new OracleParameter("p_SalarioIsr", OracleDbType.Decimal);
            arrParam[5].Value = salarioIsr;
            arrParam[6] = new OracleParameter("p_SalarioINF", OracleDbType.Decimal);
            arrParam[6].Value = salarioINF;
            arrParam[7] = new OracleParameter("p_AgenteRetencionIsr", OracleDbType.NVarchar2, 11);
            arrParam[7].Value = SuirPlus.Utilitarios.Utils.verificarNulo(agenteRetencion);
            arrParam[8] = new OracleParameter("p_OtrasRemunIsr", OracleDbType.Decimal);
            arrParam[8].Value = otrasRemuneraciones;
            arrParam[9] = new OracleParameter("p_RemunOtroEmp", OracleDbType.Decimal);
            arrParam[9].Value = remuneracionOtroEmpleador;
            arrParam[10] = new OracleParameter("p_FechaIngreso", OracleDbType.Date);
            arrParam[10].Value = fechaIngreso;
            arrParam[11] = new OracleParameter("p_Periodo_desde", OracleDbType.NVarchar2, 10);
            arrParam[11].Value = periodo_desde;
            arrParam[12] = new OracleParameter("p_Periodo_hasta", OracleDbType.NVarchar2, 10);
            arrParam[12].Value = periodo_hasta;
            arrParam[13] = new OracleParameter("p_IngresosExentos", OracleDbType.Decimal);
            arrParam[13].Value = ingresosExentos;
            arrParam[14] = new OracleParameter("p_SaldoFavor", OracleDbType.Decimal);
            arrParam[14].Value = saldoFavor;
            arrParam[15] = new OracleParameter("p_ID_Usuario", OracleDbType.NVarchar2, 35);
            arrParam[15].Value = usuario;
            arrParam[16] = new OracleParameter("p_tipo_ingreso", OracleDbType.Decimal);
            arrParam[16].Value = tipoIngreso;
            arrParam[17] = new OracleParameter("p_IPAddress", OracleDbType.NVarchar2, 16);
            arrParam[17].Value = IPAddress;
            arrParam[18] = new OracleParameter("p_ResultNumber", OracleDbType.NVarchar2, 200);
            arrParam[18].Direction = ParameterDirection.Output;

            String cmdStr = "SRE_NOVEDADES_PKG.Novedades_enf_Nolaboral";

            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                return arrParam[18].Value.ToString();
            }
            catch (Exception ex)
            {
                throw ex;
            }


        }




        /** Milciades 21/12/2009 
         *Ejecuta la novedad de registro de los ciudadanos a actualizar
         * **/

        public static string novedadIngresoAct(int registroPatronal,
                                               int idNomina,
                                               int nss,
            //double remuneracionOtroEmpleador,
                                               DateTime fechaIngreso,
                                               String usuario)
        {

            OracleParameter[] arrParam = new OracleParameter[6];

            arrParam[0] = new OracleParameter("p_id_RegistroPatronal", OracleDbType.Decimal);
            arrParam[0].Value = registroPatronal;
            arrParam[1] = new OracleParameter("p_id_Nomina", OracleDbType.Decimal);
            arrParam[1].Value = idNomina;
            arrParam[2] = new OracleParameter("p_id_NSS", OracleDbType.Decimal);
            arrParam[2].Value = nss;
            arrParam[3] = new OracleParameter("p_FechaIngreso", OracleDbType.Date);
            arrParam[3].Value = fechaIngreso;
            arrParam[4] = new OracleParameter("p_ID_Usuario", OracleDbType.NVarchar2, 35);
            arrParam[4].Value = usuario;
            arrParam[5] = new OracleParameter("p_ResultNumber", OracleDbType.NVarchar2, 200);
            arrParam[5].Direction = ParameterDirection.Output;

            String cmdStr = "SRE_NOVEDADES_PKG.Nov_ACTUALIZACION_CIUD";

            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                return arrParam[5].Value.ToString();
            }
            catch (Exception ex)
            {
                throw ex;
            }


        }



        /**
        * Ejecuta la novedad de registro de dependiente adicional
        * */
        public static string novedadIngresoDependientes(int registroPatronal,
            int idNomina,
            int nss,
            int nssDependiente,
            String usuario, string IPAddress)
        {

            OracleParameter[] arrParam = new OracleParameter[7];

            arrParam[0] = new OracleParameter("p_id_RegistroPatronal", OracleDbType.Decimal);
            arrParam[0].Value = registroPatronal;

            arrParam[1] = new OracleParameter("p_id_Nomina", OracleDbType.Decimal);
            arrParam[1].Value = idNomina;

            arrParam[2] = new OracleParameter("p_id_NSS", OracleDbType.Decimal);
            arrParam[2].Value = nss;

            arrParam[3] = new OracleParameter("p_id_NSS_Dependiente", OracleDbType.Decimal);
            arrParam[3].Value = nssDependiente;

            arrParam[4] = new OracleParameter("p_ID_Usuario", OracleDbType.NVarchar2, 35);
            arrParam[4].Value = usuario;

            arrParam[5] = new OracleParameter("p_IPAddress", OracleDbType.NVarchar2, 16);
            arrParam[5].Value = IPAddress;

            arrParam[6] = new OracleParameter("p_ResultNumber", OracleDbType.NVarchar2, 200);
            arrParam[6].Direction = ParameterDirection.Output;

            String cmdStr = "SRE_NOVEDADES_PKG.Novedades_Ingreso_Dep_Crear";

            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                return arrParam[6].Value.ToString();
            }
            catch (Exception ex)
            {
                throw ex;
            }


        }

        /**
        * Ejecuta la novedad de baja de dependiente adicional
        * */
        public static string novedadBajaDependientes(int registroPatronal,
            int idNomina,
            int nss,
            int nssDependiente,
            String usuario, string IPAddress)
        {

            OracleParameter[] arrParam = new OracleParameter[7];

            arrParam[0] = new OracleParameter("p_id_RegistroPatronal", OracleDbType.Decimal);
            arrParam[0].Value = registroPatronal;
            arrParam[1] = new OracleParameter("p_id_Nomina", OracleDbType.Decimal);
            arrParam[1].Value = idNomina;
            arrParam[2] = new OracleParameter("p_id_NSS", OracleDbType.Decimal);
            arrParam[2].Value = nss;
            arrParam[3] = new OracleParameter("p_id_NSS_Dependiente", OracleDbType.Decimal);
            arrParam[3].Value = nssDependiente;
            arrParam[4] = new OracleParameter("p_ID_Usuario", OracleDbType.NVarchar2, 35);
            arrParam[4].Value = usuario;
            arrParam[5] = new OracleParameter("p_IPAddress", OracleDbType.NVarchar2, 16);
            arrParam[5].Value = IPAddress;
            arrParam[6] = new OracleParameter("p_ResultNumber", OracleDbType.NVarchar2, 200);
            arrParam[6].Direction = ParameterDirection.Output;

            String cmdStr = "SRE_NOVEDADES_PKG.Novedades_Baja_Dep_Crear";

            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                return arrParam[6].Value.ToString();
            }
            catch (Exception ex)
            {
                throw ex;
            }


        }


        /**
         * Ejecuta la novedad de baja de empleado
         * */
        public static string novedadBaja(int registroPatronal,
            int idNomina,
            int nss,
            double salarioSS,
            double aporteVoluntario,
            double salarioIsr,
            double salarioINF,
            string agenteRetencion,
            double otrasRemuneraciones,
            double remuneracionOtroEmpleador,
            DateTime fechaEgreso,
            double ingresosExentos,
            double saldoFavor,
            String usuario,
            int tipoIngreso,
            string IPAddress)
        {

            OracleParameter[] arrParam = new OracleParameter[17];

            arrParam[0] = new OracleParameter("p_id_RegistroPatronal", OracleDbType.Decimal);
            arrParam[0].Value = registroPatronal;
            arrParam[1] = new OracleParameter("p_id_Nomina", OracleDbType.Decimal);
            arrParam[1].Value = idNomina;
            arrParam[2] = new OracleParameter("p_id_NSS", OracleDbType.Decimal);
            arrParam[2].Value = nss;
            arrParam[3] = new OracleParameter("p_SalarioSS", OracleDbType.Decimal);
            arrParam[3].Value = salarioSS;
            arrParam[4] = new OracleParameter("p_AporteVoluntario", OracleDbType.Decimal);
            arrParam[4].Value = aporteVoluntario;
            arrParam[5] = new OracleParameter("p_SalarioIsr", OracleDbType.Decimal);
            arrParam[5].Value = salarioIsr;
            arrParam[6] = new OracleParameter("p_SalarioINF", OracleDbType.Decimal);
            arrParam[6].Value = salarioINF;
            arrParam[7] = new OracleParameter("p_AgenteRetencionIsr", OracleDbType.NVarchar2, 11);
            arrParam[7].Value = agenteRetencion;
            arrParam[8] = new OracleParameter("p_OtrasRemunIsr", OracleDbType.Decimal);
            arrParam[8].Value = otrasRemuneraciones;
            arrParam[9] = new OracleParameter("p_IngresosExentos", OracleDbType.Decimal);
            arrParam[9].Value = ingresosExentos;
            arrParam[10] = new OracleParameter("p_SaldoFavor", OracleDbType.Decimal);
            arrParam[10].Value = saldoFavor;
            arrParam[11] = new OracleParameter("p_RemunOtroEmp", OracleDbType.Decimal);
            arrParam[11].Value = remuneracionOtroEmpleador;
            arrParam[12] = new OracleParameter("p_FechaEgreso", OracleDbType.Date);
            arrParam[12].Value = fechaEgreso;
            arrParam[13] = new OracleParameter("p_ID_Usuario", OracleDbType.NVarchar2, 35);
            arrParam[13].Value = usuario;
            arrParam[14] = new OracleParameter("p_tipo_ingreso", OracleDbType.Decimal);
            arrParam[14].Value = tipoIngreso;
            arrParam[15] = new OracleParameter("p_IPAddress", OracleDbType.NVarchar2, 16);
            arrParam[15].Value = IPAddress;
            arrParam[16] = new OracleParameter("p_ResultNumber", OracleDbType.NVarchar2, 200);
            arrParam[16].Direction = ParameterDirection.Output;

            String cmdStr = "Sre_Novedades_Pkg.Novedades_Salida_Crear";

            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                return arrParam[16].Value.ToString();
            }
            catch (Exception ex)
            {
                throw ex;
            }


        }

        /**
        * Borra una novedad pendiente 
        * */
        public static string borraNovedad(int idMov, int idLinia)
        {

            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_IDMovimiento", OracleDbType.Decimal);
            arrParam[0].Value = idMov;
            arrParam[1] = new OracleParameter("p_IDLinea", OracleDbType.Decimal);
            arrParam[1].Value = idLinia;
            arrParam[2] = new OracleParameter("p_ResultNumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;

            String cmdStr = "Sre_Novedades_Pkg.Borrar_Novedad";

            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                return Utilitarios.Utils.sacarMensajeDeError(arrParam[2].Value.ToString());
            }
            catch (Exception ex)
            {
                throw ex;
            }


        }


        public static DataTable getNovedades(string tipoNovedad, string categoria)
        {

            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_tipo_novedad", OracleDbType.NVarchar2, 2);
            arrParam[0].Value = SuirPlus.Utilitarios.Utils.verificarNulo(tipoNovedad);

            arrParam[1] = new OracleParameter("p_categoria", OracleDbType.NVarchar2, 1);
            arrParam[1].Value = SuirPlus.Utilitarios.Utils.verificarNulo(categoria);

            arrParam[2] = new OracleParameter("io_cursor", OracleDbType.RefCursor);
            arrParam[2].Direction = ParameterDirection.Output;

            String cmdStr = "Sre_Novedades_Pkg.get_novedades";

            try
            {
                return DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam).Tables[0];
            }
            catch (Exception ex)
            {
                throw ex;
            }


        }


        /**
             * Ejecuta la novedad de baja de empleado
             * */
        public static string novedadLicencia(int registroPatronal,
            int idNomina,
            int nss,
            string tipoLicencia,
            string fechaIni,
            string fechaFin,
            string usuario, string IPAddress)
        {

            OracleParameter[] arrParam = new OracleParameter[9];

            arrParam[0] = new OracleParameter("p_RegistroPatronal", OracleDbType.Decimal);
            arrParam[0].Value = registroPatronal;
            arrParam[1] = new OracleParameter("p_IDNSS", OracleDbType.Decimal);
            arrParam[1].Value = nss;
            arrParam[2] = new OracleParameter("p_id_nomina", OracleDbType.Decimal);
            arrParam[2].Value = idNomina;
            arrParam[3] = new OracleParameter("p_TipoLicencia", OracleDbType.NVarchar2, 2);
            arrParam[3].Value = tipoLicencia;
            arrParam[4] = new OracleParameter("p_FechaInicio", OracleDbType.Date);
            arrParam[4].Value = fechaIni;
            arrParam[5] = new OracleParameter("p_FechaFin", OracleDbType.Date);
            arrParam[5].Value = fechaFin;
            arrParam[6] = new OracleParameter("p_UltUsuarioAct", OracleDbType.NVarchar2, 35);
            arrParam[6].Value = usuario;
            arrParam[7] = new OracleParameter("p_IPAddress", OracleDbType.NVarchar2, 16);
            arrParam[7].Value = IPAddress;
            arrParam[8] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[8].Direction = ParameterDirection.Output;

            String cmdStr = "Sre_Novedades_Pkg.Novedades_Licencia_Crear";

            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                return arrParam[8].Value.ToString();
            }
            catch (Exception ex)
            {
                throw ex;
            }


        }


        public static string novedadSVDS(int registroPatronal,
            int idNomina,
            int nss,
            decimal salarioss,
            string usuario, string IPAddress)
        {

            OracleParameter[] arrParam = new OracleParameter[7];

            arrParam[0] = new OracleParameter("p_RegistroPatronal", OracleDbType.Decimal);
            arrParam[0].Value = registroPatronal;
            arrParam[1] = new OracleParameter("p_IDNSS", OracleDbType.Decimal);
            arrParam[1].Value = nss;
            arrParam[2] = new OracleParameter("p_id_nomina", OracleDbType.Decimal);
            arrParam[2].Value = idNomina;
            arrParam[3] = new OracleParameter("p_salarioss", OracleDbType.Decimal);
            arrParam[3].Value = salarioss;
            arrParam[4] = new OracleParameter("p_UltUsuarioAct", OracleDbType.NVarchar2, 35);
            arrParam[4].Value = usuario;
            arrParam[5] = new OracleParameter("p_IPAddress", OracleDbType.NVarchar2, 16);
            arrParam[5].Value = IPAddress;
            arrParam[6] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[6].Direction = ParameterDirection.Output;

            String cmdStr = "Sre_Novedades_Pkg.Novedades_SVDS_Crear";

            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                return arrParam[6].Value.ToString();
            }
            catch (Exception ex)
            {
                throw ex;
            }


        }


        /**
                 * Ejecuta la novedad de baja de empleado
                 * */
        public static string aplicarMovimientos(int registroPatronal,
                                                string usuario)
        {

            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_id_registro_patronal", OracleDbType.Decimal);
            arrParam[0].Value = registroPatronal;
            arrParam[1] = new OracleParameter("p_Usuario", OracleDbType.NVarchar2, 35);
            arrParam[1].Value = usuario;
            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;

            String cmdStr = "Sre_Novedades_Pkg.Aplicar_Movimientos";

            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                return arrParam[2].Value.ToString() + "";
            }
            catch (Exception ex)
            {
                throw ex;
            }


        }


        public static string getPeriodo(int registroPatronal, int idNomina)
        {

            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_id_registro_patronal", OracleDbType.Decimal);
            arrParam[0].Value = registroPatronal;
            arrParam[1] = new OracleParameter("p_id_nomina", OracleDbType.Decimal);
            arrParam[1].Value = idNomina;
            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;

            String cmdStr = "Sre_Novedades_Pkg.Get_PeriodoSaldo";

            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                return arrParam[2].Value.ToString() + "";
            }
            catch (Exception ex)
            {
                throw ex;
            }


        }

        /// <summary>
        /// Trae los movimientos pendientes que pertenecen al SFS
        /// </summary>
        /// <param name="idRegistroPatronal">Registro patronal de la empresa</param>
        /// <returns>Un datatable con el resultado</returns>
        public static DataTable getMovimientosSFS(int idRegistroPatronal)
        {

            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_RegistroPatronal", OracleDbType.Decimal);
            arrParam[0].Value = idRegistroPatronal;

            arrParam[1] = new OracleParameter("p_io_cursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;

            try
            {
                return DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, "Sre_Novedades_Pkg.getNovedadesPendientesSFS", arrParam).Tables[0];
            }
            catch (Exception ex)
            {

                throw ex;
            }

        }
        public static DataTable getMovimientos(int idRegistroPatronal,
                                               String tipoMov,
                                               String tipoNov,
                                               String categoria,
                                               String usuario)
        {


            OracleParameter[] arrParam = new OracleParameter[7];

            arrParam[0] = new OracleParameter("p_id_registro_patronal", OracleDbType.Decimal);
            arrParam[0].Value = idRegistroPatronal;

            arrParam[1] = new OracleParameter("p_id_Usuario", OracleDbType.NVarchar2, 35);
            arrParam[1].Value = usuario;

            arrParam[2] = new OracleParameter("p_id_TipoMovimiento", OracleDbType.NVarchar2, 3);
            arrParam[2].Value = tipoMov;

            arrParam[3] = new OracleParameter("p_id_TipoNovedad", OracleDbType.NVarchar2, 2);
            arrParam[3].Value = SuirPlus.Utilitarios.Utils.verificarNulo(tipoNov);

            arrParam[4] = new OracleParameter("p_categoria", OracleDbType.NVarchar2, 1);
            arrParam[4].Value = categoria;

            arrParam[5] = new OracleParameter("p_io_cursor", OracleDbType.RefCursor);
            arrParam[5].Direction = ParameterDirection.Output;

            arrParam[6] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[6].Direction = ParameterDirection.Output;



            String cmdStr = "SRE_NOVEDADES_PKG.get_Novedades_Pendientes";

            try
            {
                return DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam).Tables[0];
            }
            catch (Exception ex)
            {
                throw new Exception(arrParam[6].Value.ToString() + " | " + ex.ToString());
            }


        }


        public static DataTable getDependientes(int idRegistroPatronal,
            int idNomina,
            int idNss)
        {

            OracleParameter[] arrParam = new OracleParameter[5];

            arrParam[0] = new OracleParameter("p_id_registro_patronal", OracleDbType.Decimal);
            arrParam[0].Value = idRegistroPatronal;

            arrParam[1] = new OracleParameter("p_id_Nomina", OracleDbType.Decimal);
            arrParam[1].Value = idNomina;

            arrParam[2] = new OracleParameter("p_id_NSS", OracleDbType.Decimal);
            arrParam[2].Value = idNss;

            arrParam[3] = new OracleParameter("p_io_cursor", OracleDbType.RefCursor);
            arrParam[3].Direction = ParameterDirection.Output;

            arrParam[4] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[4].Direction = ParameterDirection.Output;

            String cmdStr = "SRE_NOVEDADES_PKG.get_Dependientes";

            try
            {
                return DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam).Tables[0];
            }
            catch (Exception ex)
            {
                throw new Exception(arrParam[4].Value.ToString() + " | " + ex.ToString());
            }


        }


        public static DataTable getInfoTrabajador(int idRegistroPatronal,
                                                  int idNomina,
                                                  int idNss,
                                                  string periodo)
        {

            OracleParameter[] arrParam = new OracleParameter[4];

            arrParam[0] = new OracleParameter("p_id_registro_patronal", OracleDbType.Int32);
            arrParam[0].Value = idRegistroPatronal;

            arrParam[1] = new OracleParameter("p_id_nomina", OracleDbType.Int32);
            arrParam[1].Value = idNomina;

            arrParam[2] = new OracleParameter("p_id_nss", OracleDbType.Int32);
            arrParam[2].Value = idNss;

            arrParam[3] = new OracleParameter("p_io_cursor", OracleDbType.RefCursor);
            arrParam[3].Direction = ParameterDirection.Output;

            String cmdStr = "SRE_NOVEDADES_PKG.Get_DatosTrabajadores";

            try
            {
                return DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam).Tables[0];
            }
            catch (Exception ex)
            {
                throw ex;
            }


        }


        public static bool isDependienteValido(string TipoMovimiento, int regPatronal, int idNomina, int nssTitular, int nssDependiente, ref string mensaje)
        {

            OracleParameter[] arrParam = new OracleParameter[6];
            string cmdStr = "sre_procesar_RD_pkg.Validar_Dependiente";
            string msg = string.Empty;

            arrParam[0] = new OracleParameter("pTipo_mov", OracleDbType.Varchar2);
            arrParam[0].Value = TipoMovimiento;

            arrParam[1] = new OracleParameter("pId_Registro_Patronal", OracleDbType.Decimal);
            arrParam[1].Value = regPatronal;

            arrParam[2] = new OracleParameter("pId_Nomina", OracleDbType.Decimal);
            arrParam[2].Value = idNomina;

            arrParam[3] = new OracleParameter("pId_Nss_Titular", OracleDbType.Decimal);
            arrParam[3].Value = nssTitular;

            arrParam[4] = new OracleParameter("pId_Nss_Dependiente", OracleDbType.Decimal);
            arrParam[4].Value = nssDependiente;

            arrParam[5] = new OracleParameter("pResult", OracleDbType.NVarchar2, 100);
            arrParam[5].Direction = ParameterDirection.Output;

            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                msg = arrParam[5].Value.ToString();
                if (msg != "OK")
                {
                    mensaje = msg;
                    return false;
                }

            }
            catch (Exception ex)
            {
                throw ex;
            }

            return true;

        }


        public static string PuedeRegistrarNovedades(int regPatronal)
        {

            OracleParameter[] arrParam = new OracleParameter[2];
            string cmdStr = "Sre_Novedades_Pkg.PuedeRegistrarNovedades";
            string msg = "";

            arrParam[0] = new OracleParameter("p_registro_patronal", OracleDbType.Decimal);
            arrParam[0].Value = regPatronal;

            arrParam[1] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 500);
            arrParam[1].Direction = ParameterDirection.Output;

            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                msg = arrParam[1].Value.ToString();

                if (msg != "0")
                {
                    msg = msg.Split('|')[1].ToString();
                }

            }
            catch (Exception ex)
            {
                throw ex;
            }

            return msg;

        }

        /**
         * Ejecuta el metodo de opera_movimiento
         * */
        public static string opera_movimientos(int registroPatronal, string usuario)
        {

            OracleParameter[] arrParam = new OracleParameter[2];

            arrParam[0] = new OracleParameter("p_id_RegistroPatronal", OracleDbType.Decimal);
            arrParam[0].Value = registroPatronal;
            arrParam[1] = new OracleParameter("p_ID_Usuario", OracleDbType.NVarchar2, 35);
            arrParam[1].Value = usuario;


            String cmdStr = "Sre_Novedades_Pkg.Aplicar_mov_enf_nolaboral";

            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                return "";
            }
            catch (Exception ex)
            {
                throw ex;
            }


        }

        #endregion

    }
}
