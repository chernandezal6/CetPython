using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using Oracle.ManagedDataAccess.Client;


namespace SuirPlus.MDT
{
    public class General
    {
        #region Variables Publicas y Privadas
        Int32 v_id_registro_patronal;
        public Int32 registro_patronal
        {
            get { return v_id_registro_patronal; }
            set { v_id_registro_patronal = value; }
        }
        Int32 v_id_nss;
        public Int32 id_nss
        {
            get { return v_id_nss; }
            set { v_id_nss = value; }
        }
        string v_id_planilla;
        public string id_planilla
        {
            get { return v_id_planilla; }
            set { v_id_planilla = value; }
        }
        string v_id_novedad;
        public string id_novedad
        {
            get { return v_id_novedad; }
            set { v_id_novedad = value; }
        }
        Int32 v_id_localidad;
        public Int32 id_localidad
        {
            get { return v_id_localidad; }
            set { v_id_localidad = value; }
        }

        string v_localidad_descripcion;
        public string localidad_descripcion
        {
            get { return v_localidad_descripcion; }
            set { v_localidad_descripcion = value; }
        }
        Int32 v_id_turno;
        public Int32 id_turno
        {
            get { return v_id_turno; }
            set { v_id_turno = value; }
        }

        string v_turno_descripcion;
        public string turno_descripcion
        {
            get { return v_turno_descripcion; }
            set { v_turno_descripcion = value; }
        }

        Int32 v_id_ocupacion;
        public Int32 id_ocupacion
        {
            get { return v_id_ocupacion; }
            set { v_id_ocupacion = value; }
        }

        DateTime v_vacaciones_desde;
        public DateTime vacaciones_desde
        {
            get { return v_vacaciones_desde; }
            set { v_vacaciones_desde = value; }
        }
        DateTime v_vacaciones_hasta;
        public DateTime vacaciones_hasta
        {
            get { return v_vacaciones_hasta; }
            set { v_vacaciones_hasta = value; }
        }
        string v_observacion;
        public string observacion
        {
            get { return v_observacion; }
            set { v_observacion = value; }
        }
        decimal v_salario;
        public decimal salario
        {
            get { return v_salario; }
            set { v_salario = value; }
        }

        Int32 v_periodo;
        public Int32 periodo
        {
            get { return v_periodo; }
            set { v_periodo = value; }
        }
        DateTime v_fecha_ingreso;
        public DateTime fecha_ingreso
        {
            get { return v_fecha_ingreso; }
            set { v_fecha_ingreso = value; }
        }
        string v_ocupacion_des;
        public string ocupacion_des
        {
            get { return v_ocupacion_des; }
            set { v_ocupacion_des = value; }
        }

        string v_ocupacion_catalogo;
        public string ocupacion_catalogo
        {
            get { return v_ocupacion_catalogo; }
            set { v_ocupacion_catalogo = value; }
        }
        string v_ult_usuario_act;
        public string ult_usuario_act
        {
            get { return v_ult_usuario_act; }
            set { v_ult_usuario_act = value; }
        }
        #endregion

        public General() { }

        /// <summary>
        /// Constructor de la clase utilizada obtener toda la informacion concerniente a un Trabajador.
        /// </summary>
        public General(string no_documento, string tipoDoc, Int32 id_registro_patronal)
        {

            OracleParameter[] arrParam = new OracleParameter[5];

            arrParam[0] = new OracleParameter("p_no_documento", OracleDbType.NVarchar2);
            arrParam[0].Value = no_documento;

            arrParam[1] = new OracleParameter("p_tipo_documento", OracleDbType.Varchar2);
            arrParam[1].Value = tipoDoc;

            arrParam[2] = new OracleParameter("p_id_registro_patronal", OracleDbType.Int32);
            arrParam[2].Value = id_registro_patronal;

            arrParam[3] = new OracleParameter("p_io_cursor", OracleDbType.RefCursor);
            arrParam[3].Direction = ParameterDirection.Output;

            arrParam[4] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[4].Direction = ParameterDirection.Output;

            string metodo = "sre_mdt_pkg.GetInformacionTrabajadorMDT";
            DataTable dt = new DataTable();

            try
            {
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, metodo, arrParam);
                if (ds.Tables[0].Rows.Count > 0)
                {
                    dt = ds.Tables[0];
                    v_id_registro_patronal = Convert.ToInt32(dt.Rows[0]["id_registro_patronal"]);
                    v_id_nss = Convert.ToInt32(dt.Rows[0]["id_nss"]);
                    v_periodo = Convert.ToInt32(dt.Rows[0]["periodo_factura"]);
                    v_id_planilla = dt.Rows[0]["id_planilla"].ToString();
                    v_id_novedad = dt.Rows[0]["id_novedad"].ToString();
                    v_id_localidad = Convert.ToInt32(dt.Rows[0]["id_localidad"]);
                    v_localidad_descripcion = dt.Rows[0]["localidad_descripcion"].ToString();
                    v_id_turno = Convert.ToInt32(dt.Rows[0]["id_turno"]);
                    v_turno_descripcion = dt.Rows[0]["turno_descripcion"].ToString();
                    v_id_ocupacion = Convert.ToInt32(dt.Rows[0]["id_ocupacion"]);
                  

                    if (dt.Rows[0]["salario_mdt"].ToString() != "")
                    {
                        v_salario = Convert.ToDecimal(dt.Rows[0]["salario_mdt"]);

                    }
                 
                    if (dt.Rows[0]["fecha_ingreso"].ToString() != "")
                    {
                        v_fecha_ingreso = Convert.ToDateTime(dt.Rows[0]["fecha_ingreso"]);

                    }

                    if (dt.Rows[0]["vacaciones_desde"].ToString() != "")
                    {
                        v_vacaciones_desde =  Convert.ToDateTime(dt.Rows[0]["vacaciones_desde"]);
                    }
                    if (dt.Rows[0]["vacaciones_hasta"].ToString() != "")
                    {
                        v_vacaciones_hasta = Convert.ToDateTime(dt.Rows[0]["vacaciones_hasta"]);
                    }

                    v_observacion = dt.Rows[0]["observacion"].ToString();
                    v_ocupacion_des = dt.Rows[0]["ocupacion_desc"].ToString();
                    v_ocupacion_catalogo = dt.Rows[0]["ocupacion_catalogo"].ToString();


                }
                else
                {
                    throw new Exception("error");
                }

            }

            catch (OracleException oEx)
            {
                throw new Exception(oEx.Message);
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }

        public static DataTable getPuestos(string Criterio, Int32 pageNum, Int32 pageSize)
        {

            OracleParameter[] arrParam;
            String cmdStr = "SRE_MDT_PKG.get_catalogo_ocupaciones";

            DataTable dt = new DataTable();

            //Definimos nuestro arreglo de parametros.
            arrParam = new OracleParameter[5];

            arrParam[0] = new OracleParameter("p_criterio", OracleDbType.Varchar2);
            arrParam[0].Value = Criterio;

            arrParam[1] = new OracleParameter("p_pagenum", OracleDbType.Int32);
            arrParam[1].Value = pageNum;

            arrParam[2] = new OracleParameter("p_pagesize", OracleDbType.Int32);
            arrParam[2].Value = pageSize;

            arrParam[3] = new OracleParameter("p_io_cursor", OracleDbType.RefCursor);
            arrParam[3].Direction = ParameterDirection.Output;

            arrParam[4] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[4].Direction = ParameterDirection.Output;



            try
            {
                //Ejecuamos el commando.
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

        public static string getCiudadano(string documento, string tipoDoc)
        {
            OracleParameter[] arrParam;
            String cmdStr = "sre_mdt_pkg.getCiudadano";

            DataTable dt = new DataTable();

            //Definimos nuestro arreglo de parametros.
            arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_nro_documento", OracleDbType.Varchar2);
            arrParam[0].Value = documento;

            arrParam[1] = new OracleParameter("p_tipo_documento", OracleDbType.Varchar2);
            arrParam[1].Value = tipoDoc;

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

        public static string getTrabajador(Int32 id_registro_patronal, string documento, string tipoDoc)
        {
            OracleParameter[] arrParam;
            String cmdStr = "sre_trabajador_pkg.gettrabajador";

            DataTable dt = new DataTable();

            //Definimos nuestro arreglo de parametros.
            arrParam = new OracleParameter[4];

            arrParam[0] = new OracleParameter("p_id_registro_patronal", OracleDbType.Int32);
            arrParam[0].Value = id_registro_patronal;

            arrParam[1] = new OracleParameter("p_nro_documento", OracleDbType.Varchar2);
            arrParam[1].Value = documento;

            arrParam[2] = new OracleParameter("p_tipo_documento", OracleDbType.Varchar2);
            arrParam[2].Value = tipoDoc;

            arrParam[3] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[3].Direction = ParameterDirection.Output;


            string result = string.Empty;
            try
            {

                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                result = arrParam[3].Value.ToString();

                return result;
            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;
            }
        }

        public static string getContactoLocalidad(string id_localidad, string documento, string tipoDoc)
        {
            OracleParameter[] arrParam;
            String cmdStr = "sre_mdt_pkg.getcontactolocalidad";

            //Definimos nuestro arreglo de parametros.
            arrParam = new OracleParameter[4];
            arrParam[0] = new OracleParameter("p_id_localidad", OracleDbType.Int32);
            if (id_localidad != string.Empty)
            {
                arrParam[0].Value = Convert.ToInt32(id_localidad);
            }
            else
            {
                arrParam[0].Value = DBNull.Value;
            }
            arrParam[1] = new OracleParameter("p_nro_documento", OracleDbType.Varchar2);
            arrParam[1].Value = documento;
            arrParam[2] = new OracleParameter("p_tipo_documento", OracleDbType.Varchar2);
            arrParam[2].Value = tipoDoc;
            arrParam[3] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[3].Direction = ParameterDirection.Output;

            //DataTable dt = new DataTable();
            string result = string.Empty;
            try
            {

                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                result = arrParam[3].Value.ToString();

                return result;
            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;
            }
        }

        public static DataTable getPuestoList(string Puesto)
        {
            string strCmd = "SRE_MDT_PKG.getOcupacionesAutocomplete";

            OracleParameter[] arrParam = new OracleParameter[2];

            arrParam[0] = new OracleParameter("p_puesto", Puesto);
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

        public static DataTable getCarteraMDT(int idRegistroPatronal)
        {

            OracleParameter[] arrParam;
            String cmdStr = "SRE_MDT_PKG.getCartera_MDT";

            DataTable dt = new DataTable();

            //Definimos nuestro arreglo de parametros.
            arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_id_registro_patronal", OracleDbType.Int32);
            arrParam[0].Value = idRegistroPatronal;

            arrParam[1] = new OracleParameter("p_io_cursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;



            try
            {
                //Ejecuamos el commando.
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);



                if (arrParam[2].Value.ToString() != "0")
                {
                    throw new Exception(arrParam[2].Value.ToString());
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

        public static DataTable getDetCartera_MDT(int idRegistroPatronal, string tipo_planilla, int periodo_factura, Int32 pageNum, Int32 pageSize)
        {

            OracleParameter[] arrParam;
            String cmdStr = "SRE_MDT_PKG. getDetCartera_MDT";

            DataTable dt = new DataTable();

            //Definimos nuestro arreglo de parametros.
            arrParam = new OracleParameter[7];

            arrParam[0] = new OracleParameter("p_id_registro_patronal", OracleDbType.Int32);
            arrParam[0].Value = idRegistroPatronal;

            arrParam[1] = new OracleParameter("p_tipo_planilla ", OracleDbType.NVarchar2, 4);
            arrParam[1].Value = tipo_planilla;

            arrParam[2] = new OracleParameter("p_periodo_factura", OracleDbType.Int32);
            arrParam[2].Value = periodo_factura;

            arrParam[3] = new OracleParameter("p_pagenum", OracleDbType.Int32);
            arrParam[3].Value = pageNum;

            arrParam[4] = new OracleParameter("p_pagesize", OracleDbType.Int32);
            arrParam[4].Value = pageSize;

            arrParam[5] = new OracleParameter("p_io_cursor", OracleDbType.RefCursor);
            arrParam[5].Direction = ParameterDirection.Output;

            arrParam[6] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[6].Direction = ParameterDirection.Output;


            try
            {
                //Ejecuamos el commando.
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);



                if (arrParam[6].Value.ToString() != "0")
                {
                    throw new Exception(arrParam[6].Value.ToString());
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

        public static string IngresoTrabajadorMDT(int id_registro_patronal, int id_nss, string id_planilla, int id_localidad, int id_turno, int id_ocupacion, string segundo_puesto, string vacaciones_desde, string vacaciones_hasta, string observacion, string salario, string periodo, string fecha_ingreso, string ocupacion_des, string ult_usuario_act)
        {
            OracleParameter[] arrParam;
            String cmdStr = "sre_mdt_pkg.IngresoTrabajadorMDT";

            //Definimos nuestro arreglo de parametros.
            arrParam = new OracleParameter[17];

            arrParam[0] = new OracleParameter("p_id_registro_patronal", OracleDbType.Int32);
            arrParam[0].Value = id_registro_patronal;

            arrParam[1] = new OracleParameter("p_id_nss", OracleDbType.Int32);
            arrParam[1].Value = id_nss;

            arrParam[2] = new OracleParameter("p_id_planilla", OracleDbType.NVarchar2, 4);
            arrParam[2].Value = id_planilla;

            arrParam[3] = new OracleParameter("p_id_localidad", OracleDbType.Int32);
            arrParam[3].Value = id_localidad;

            arrParam[4] = new OracleParameter("p_id_turno", OracleDbType.Int32);
            arrParam[4].Value = id_turno;

            arrParam[5] = new OracleParameter("p_id_ocupacion", OracleDbType.Int32);
            if (id_ocupacion > 0)
            {
                arrParam[5].Value = id_ocupacion;
            }

            arrParam[6] = new OracleParameter("p_segundo_puesto", OracleDbType.NVarchar2, 150);
            arrParam[6].Value = segundo_puesto;

            arrParam[7] = new OracleParameter("p_vacaciones_desde", OracleDbType.Date);
            if (vacaciones_desde != "")
            {
                arrParam[7].Value = Convert.ToDateTime(vacaciones_desde);
            }

            arrParam[8] = new OracleParameter("p_vacaciones_hasta", OracleDbType.Date);
            if (vacaciones_hasta != "")
            {
                arrParam[8].Value = Convert.ToDateTime(vacaciones_hasta);
            }

            arrParam[9] = new OracleParameter("p_observacion", OracleDbType.Varchar2);
            arrParam[9].Value = observacion;

            arrParam[10] = new OracleParameter("p_salario", OracleDbType.Decimal);
            if (salario == "" || salario == "0.00")
            {
                arrParam[10].Value = 0.00;
            }
            else
            {
                arrParam[10].Value = Convert.ToDecimal(salario);
            }
            arrParam[11] = new OracleParameter("p_periodo", OracleDbType.Int32);
            if (periodo != "0")
            {
                arrParam[11].Value = Convert.ToInt32(periodo);
            }

            arrParam[12] = new OracleParameter("p_fecha_ingreso", OracleDbType.Date);
            if (fecha_ingreso != "")
            {
                arrParam[12].Value = Convert.ToDateTime(fecha_ingreso);
            }

            arrParam[13] = new OracleParameter("p_status", OracleDbType.Varchar2);
            arrParam[13].Value = "P";

            arrParam[14] = new OracleParameter("p_ocupacion_des", OracleDbType.Varchar2);
            arrParam[14].Value = ocupacion_des;

            arrParam[15] = new OracleParameter("p_ult_usuario_act", OracleDbType.NVarchar2, 25);
            arrParam[15].Value = ult_usuario_act;

            arrParam[16] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[16].Direction = ParameterDirection.Output;

            string result = string.Empty;
            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                result = Utilitarios.Utils.sacarMensajeDeError(arrParam[16].Value.ToString());
                return result;
            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;
            }
        }

        public static string SalidaTrabajadorMDT(int id_registro_patronal, int id_nss, string id_planilla, int id_localidad, int id_turno, int id_ocupacion, string segundo_puesto, string vacaciones_desde, string vacaciones_hasta, string observacion, string salario, string periodo, string fecha_salida, string ocupacion_des, string ult_usuario_act)
        {
            OracleParameter[] arrParam;
            String cmdStr = "sre_mdt_pkg.SalidaTrabajadorMDT";

            //Definimos nuestro arreglo de parametros.......
            arrParam = new OracleParameter[17];

            arrParam[0] = new OracleParameter("p_id_registro_patronal", OracleDbType.Int32);
            arrParam[0].Value = id_registro_patronal;

            arrParam[1] = new OracleParameter("p_id_nss", OracleDbType.Int32);
            arrParam[1].Value = id_nss;

            arrParam[2] = new OracleParameter("p_id_planilla", OracleDbType.NVarchar2, 4);
            arrParam[2].Value = id_planilla;

            arrParam[3] = new OracleParameter("p_id_localidad", OracleDbType.Int32);
            arrParam[3].Value = id_localidad;

            arrParam[4] = new OracleParameter("p_id_turno", OracleDbType.Int32);
            arrParam[4].Value = id_turno;

            arrParam[5] = new OracleParameter("p_id_ocupacion", OracleDbType.Int32);
            if (id_ocupacion > 0)
            {
                arrParam[5].Value = id_ocupacion;
            }

            arrParam[6] = new OracleParameter("p_segundo_puesto", OracleDbType.NVarchar2, 150);
            arrParam[6].Value = segundo_puesto;

            arrParam[7] = new OracleParameter("p_vacaciones_desde", OracleDbType.Date);
            if (vacaciones_desde != "")
            {
                arrParam[7].Value = Convert.ToDateTime(vacaciones_desde);
            }

            arrParam[8] = new OracleParameter("p_vacaciones_hasta", OracleDbType.Date);
            if (vacaciones_hasta != "")
            {
                arrParam[8].Value = Convert.ToDateTime(vacaciones_hasta);
            }


            arrParam[9] = new OracleParameter("p_observacion", OracleDbType.Varchar2);
            arrParam[9].Value = observacion;

            arrParam[10] = new OracleParameter("p_salario", OracleDbType.Decimal);
            if (salario == "" || salario == "0.00")
            {
                arrParam[10].Value = 0.00;
            }
            else
            {
                arrParam[10].Value = Convert.ToDecimal(salario);
            }
            arrParam[11] = new OracleParameter("p_periodo", OracleDbType.Int32);
            if (periodo != "0")
            {
                arrParam[11].Value = Convert.ToInt32(periodo);
            }

            arrParam[12] = new OracleParameter("p_status", OracleDbType.Varchar2);
            arrParam[12].Value = "P";

            arrParam[13] = new OracleParameter("p_fecha_salida", OracleDbType.Date);
            if (fecha_salida != "")
            {
                arrParam[13].Value = Convert.ToDateTime(fecha_salida);
            }

            arrParam[14] = new OracleParameter("p_ocupacion_des", OracleDbType.Varchar2);
            arrParam[14].Value = ocupacion_des;

            arrParam[15] = new OracleParameter("p_ult_usuario_act", OracleDbType.NVarchar2, 25);
            arrParam[15].Value = ult_usuario_act;

            arrParam[16] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[16].Direction = ParameterDirection.Output;


            string result = string.Empty;
            try
            {

                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                result = Utilitarios.Utils.sacarMensajeDeError(arrParam[16].Value.ToString());

                return result;
            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;
            }
        }

        public static string CambioTrabajadorMDT(int id_registro_patronal, int id_nss, string id_planilla, int id_localidad, int id_turno, int id_ocupacion, string segundo_puesto, string vacaciones_desde, string vacaciones_hasta, string observacion, string salario, string periodo, string ocupacion_des, string ult_usuario_act)
        {
            OracleParameter[] arrParam;
            String cmdStr = "sre_mdt_pkg.CambioTrabajadorMDT";

            //Definimos nuestro arreglo de parametros.......
            arrParam = new OracleParameter[16];

            arrParam[0] = new OracleParameter("p_id_registro_patronal", OracleDbType.Int32);
            arrParam[0].Value = id_registro_patronal;

            arrParam[1] = new OracleParameter("p_id_nss", OracleDbType.Int32);
            arrParam[1].Value = id_nss;

            arrParam[2] = new OracleParameter("p_id_planilla", OracleDbType.NVarchar2, 4);
            arrParam[2].Value = id_planilla;

            arrParam[3] = new OracleParameter("p_id_localidad", OracleDbType.Int32);
            arrParam[3].Value = id_localidad;

            arrParam[4] = new OracleParameter("p_id_turno", OracleDbType.Int32);
            arrParam[4].Value = id_turno;

            arrParam[5] = new OracleParameter("p_id_ocupacion", OracleDbType.Int32);
            if (id_ocupacion > 0)
            {
                arrParam[5].Value = id_ocupacion;
            }

            arrParam[6] = new OracleParameter("p_segundo_puesto", OracleDbType.NVarchar2, 150);
            arrParam[6].Value = segundo_puesto;

            arrParam[7] = new OracleParameter("p_vacaciones_desde", OracleDbType.Date);
            if (vacaciones_desde != "")
            {
                arrParam[7].Value = Convert.ToDateTime(vacaciones_desde);
            }

            arrParam[8] = new OracleParameter("p_vacaciones_hasta", OracleDbType.Date);
            if (vacaciones_hasta != "")
            {
                arrParam[8].Value = Convert.ToDateTime(vacaciones_hasta);
            }


            arrParam[9] = new OracleParameter("p_observacion", OracleDbType.Varchar2);
            arrParam[9].Value = observacion;

            arrParam[10] = new OracleParameter("p_salario", OracleDbType.Decimal);
            if (salario == "" || salario == "0.00")
            {
                arrParam[10].Value = 0.00;
            }
            else
            {
                arrParam[10].Value = Convert.ToDecimal(salario);
            }
            arrParam[11] = new OracleParameter("p_periodo", OracleDbType.Int32);
            if (periodo != "0")
            {
                arrParam[11].Value = Convert.ToInt32(periodo);
            }

            arrParam[12] = new OracleParameter("p_status", OracleDbType.Varchar2);
            arrParam[12].Value = "P";

            arrParam[13] = new OracleParameter("p_ocupacion_des", OracleDbType.Varchar2);
            arrParam[13].Value = ocupacion_des;

            arrParam[14] = new OracleParameter("p_ult_usuario_act", OracleDbType.NVarchar2, 25);
            arrParam[14].Value = ult_usuario_act;

            arrParam[15] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[15].Direction = ParameterDirection.Output;


            string result = string.Empty;
            try
            {

                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                result = Utilitarios.Utils.sacarMensajeDeError(arrParam[15].Value.ToString());

                return result;
            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;
            }
        }

        public static string CambioTrabajadorMDT2(int id_registro_patronal, int id_nss, string id_planilla, int id_localidad, int id_turno, int id_ocupacion, string segundo_puesto, string vacaciones_desde, string vacaciones_hasta, string observacion, string salario, string periodo, string ocupacion_des, string tipo_cambio, string fecha_cambio, string ult_usuario_act)
        {
            OracleParameter[] arrParam;
            String cmdStr = "sre_mdt2_pkg.CambioTrabajadorMDT";

            //Definimos nuestro arreglo de parametros.......
            arrParam = new OracleParameter[18];

            arrParam[0] = new OracleParameter("p_id_registro_patronal", OracleDbType.Int32);
            arrParam[0].Value = id_registro_patronal;


            arrParam[1] = new OracleParameter("p_id_nss", OracleDbType.Int32);
            arrParam[1].Value = id_nss;

            arrParam[2] = new OracleParameter("p_id_planilla", OracleDbType.NVarchar2, 4);
            arrParam[2].Value = id_planilla;

            arrParam[3] = new OracleParameter("p_id_localidad", OracleDbType.Int32);
            if (id_localidad == 0)
            {
                arrParam[3].Value = DBNull.Value;
            }
            else{
            arrParam[3].Value = id_localidad;
            }

            arrParam[4] = new OracleParameter("p_id_turno", OracleDbType.Int32);
            
            if (id_turno == 0 ){
               arrParam[4].Value = DBNull.Value;
            }
            else{
            arrParam[4].Value = id_turno;
            }

            
            arrParam[5] = new OracleParameter("p_id_ocupacion", OracleDbType.Int32);

            if (id_ocupacion > 0)
            {
                arrParam[5].Value = id_ocupacion;
            }
            else
            {
                arrParam[5].Value = DBNull.Value;
            }

            arrParam[6] = new OracleParameter("p_segundo_puesto", OracleDbType.NVarchar2, 150);
            arrParam[6].Value = segundo_puesto;

            arrParam[7] = new OracleParameter("p_vacaciones_desde", OracleDbType.Date);
            if (vacaciones_desde != "")
            {
                arrParam[7].Value = Convert.ToDateTime(vacaciones_desde);
            }

            arrParam[8] = new OracleParameter("p_vacaciones_hasta", OracleDbType.Date);
            if (vacaciones_hasta != "")
            {
                arrParam[8].Value = Convert.ToDateTime(vacaciones_hasta);
            }


            arrParam[9] = new OracleParameter("p_observacion", OracleDbType.Varchar2);
            arrParam[9].Value = observacion;

            arrParam[10] = new OracleParameter("p_salario", OracleDbType.Decimal);
            if (salario == "" || salario == "0.00")
            {
                arrParam[10].Value = 0.00;
            }
            else
            {
                arrParam[10].Value = Convert.ToDecimal(salario);
            }
            arrParam[11] = new OracleParameter("p_periodo", OracleDbType.Int32);
            if (periodo != "0")
            {
                arrParam[11].Value = Convert.ToInt32(periodo);
            }

            arrParam[12] = new OracleParameter("p_status", OracleDbType.Varchar2);
            arrParam[12].Value = "P";

            arrParam[13] = new OracleParameter("p_ocupacion_des", OracleDbType.Varchar2);
            arrParam[13].Value = ocupacion_des;

            arrParam[14] = new OracleParameter("p_tipo_cambio", OracleDbType.Varchar2);
            arrParam[14].Value = tipo_cambio;

            arrParam[15] = new OracleParameter("p_fecha_cambio", OracleDbType.Date);
            if (fecha_cambio != "")
            {
                arrParam[15].Value = Convert.ToDateTime(fecha_cambio);
            }
            arrParam[16] = new OracleParameter("p_ult_usuario_act", OracleDbType.NVarchar2, 25);
            arrParam[16].Value = ult_usuario_act;

            arrParam[17] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[17].Direction = ParameterDirection.Output;


            string result = string.Empty;
            try
            {

                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                result = Utilitarios.Utils.sacarMensajeDeError(arrParam[17].Value.ToString());

                return result;
            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;
            }
        }

        public static string IngresoExtranjeroMDT(string p_nombres, string p_primer_apellido, string p_segundo_apellido, string p_fecha_nacimiento, string p_sexo, string p_no_documento, string p_tipo_documento, int p_id_nacionalidad, string ult_usuario_act)
        {
            OracleParameter[] arrParam;
            String cmdStr = "sre_mdt_pkg.IngresoExtranjeroMDT";

            //Definimos nuestro arreglo de parametros.
            arrParam = new OracleParameter[10];

            arrParam[0] = new OracleParameter("p_nombres", OracleDbType.Varchar2);
            arrParam[0].Value = p_nombres;

            arrParam[1] = new OracleParameter("p_primer_apellido", OracleDbType.Varchar2);
            arrParam[1].Value = p_primer_apellido;

            arrParam[2] = new OracleParameter("p_segundo_apellido", OracleDbType.Varchar2);
            arrParam[2].Value = p_segundo_apellido;

            arrParam[3] = new OracleParameter("p_fecha_nacimiento", OracleDbType.Varchar2);
            arrParam[3].Value = p_fecha_nacimiento;

            arrParam[4] = new OracleParameter("p_sexo", OracleDbType.Varchar2);
            arrParam[4].Value = p_sexo;

            arrParam[5] = new OracleParameter("p_no_documento", OracleDbType.Varchar2);
            arrParam[5].Value = p_no_documento;
            arrParam[6] = new OracleParameter("p_tipo_documento", OracleDbType.Varchar2);
            arrParam[6].Value = p_tipo_documento;

            arrParam[7] = new OracleParameter("p_id_nacionalidad", OracleDbType.Varchar2);
            if (p_id_nacionalidad > 0)
            {
                arrParam[7].Value = p_id_nacionalidad;
            }
            arrParam[8] = new OracleParameter("p_ult_usuario_act", OracleDbType.NVarchar2, 35);
            arrParam[8].Value = ult_usuario_act;

            arrParam[9] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[9].Direction = ParameterDirection.Output;


            string result = string.Empty;
            try
            {

                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                result = Utilitarios.Utils.sacarMensajeDeError(arrParam[9].Value.ToString());

                return result;

            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;
            }
        }

        public static string ActualizarExtranjeroMDT(string p_no_documento, string p_tipo_documento, int p_id_nacionalidad, string ult_usuario_act)
        {
            OracleParameter[] arrParam;
            String cmdStr = "sre_mdt_pkg.ActualizarExtranjeroMDT";

            //Definimos nuestro arreglo de parametros.
            arrParam = new OracleParameter[5];

            arrParam[0] = new OracleParameter("p_no_documento", OracleDbType.Varchar2);
            arrParam[0].Value = p_no_documento;
            arrParam[1] = new OracleParameter("p_tipo_documento", OracleDbType.Varchar2);
            arrParam[1].Value = p_tipo_documento;

            arrParam[2] = new OracleParameter("p_id_nacionalidad", OracleDbType.Varchar2);
            if (p_id_nacionalidad > 0)
            {
                arrParam[2].Value = p_id_nacionalidad;
            }
            arrParam[3] = new OracleParameter("p_ult_usuario_act", OracleDbType.NVarchar2, 35);
            arrParam[3].Value = ult_usuario_act;

            arrParam[4] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[4].Direction = ParameterDirection.Output;


            string result = string.Empty;
            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                result = Utilitarios.Utils.sacarMensajeDeError(arrParam[4].Value.ToString());

                return result;
            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;
            }
        }

        public static string InactivarCartera(int nss, int periodo, string planilla, int idRegistroPatronal, string nroReferencia, string status)
        {

            OracleParameter[] arrParam = new OracleParameter[7];

            arrParam[0] = new OracleParameter("p_status", OracleDbType.Varchar2);
            arrParam[0].Value = status;
            arrParam[1] = new OracleParameter("p_id_nss", OracleDbType.Decimal);
            arrParam[1].Value = nss;
            arrParam[2] = new OracleParameter("p_periodo_factura", OracleDbType.Varchar2);
            arrParam[2].Value = periodo;
            arrParam[3] = new OracleParameter("p_id_planilla", OracleDbType.Varchar2);
            arrParam[3].Value = planilla;
            arrParam[4] = new OracleParameter("p_id_registro_patronal", OracleDbType.Decimal);
            arrParam[4].Value = idRegistroPatronal;
            arrParam[5] = new OracleParameter("p_nroReferencia", OracleDbType.Varchar2);
            arrParam[5].Value = nroReferencia;
            arrParam[6] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[6].Direction = ParameterDirection.Output;

            String cmdStr = "sre_mdt_pkg.InactivarCartera";

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

        public static DataTable listadoPeriodos()
        {

            //DataSet ds = new DataSet;
            String cmdStr = "sre_mdt_pkg.listarperiodoingreso";

            //Definimos nuestro arreglo de parametros.
            OracleParameter[] arrParam = new OracleParameter[1];

            arrParam[0] = new OracleParameter("p_io_cursor", OracleDbType.RefCursor);
            arrParam[0].Direction = ParameterDirection.Output;

            try
            {

                string result = string.Empty;

                //Ejecuamos el commando.
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

        public static DataTable listarActividad()
        {

            OracleParameter[] arrParam;

            DataTable dt = new DataTable();

            //Definimos nuestro arreglo de parametros.
            arrParam = new OracleParameter[2];

            arrParam[0] = new OracleParameter("p_io_cursor", OracleDbType.RefCursor);
            arrParam[0].Direction = ParameterDirection.Output;

            arrParam[1] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[1].Direction = ParameterDirection.Output;

            String cmdStr = "SRE_MDT_PKG.listarActividad";
            try
            {
                //Ejecuamos el commando.
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);

                if (arrParam[1].Value.ToString() != "0")
                {
                    throw new Exception(arrParam[1].Value.ToString());
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

        public static DataTable listarParqueZonaFranca()
        {

            OracleParameter[] arrParam;

            DataTable dt = new DataTable();

            //Definimos nuestro arreglo de parametros.
            arrParam = new OracleParameter[2];

            arrParam[0] = new OracleParameter("p_io_cursor", OracleDbType.RefCursor);
            arrParam[0].Direction = ParameterDirection.Output;

            arrParam[1] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[1].Direction = ParameterDirection.Output;

            String cmdStr = "SRE_MDT_PKG.listarParqueZonaFranca";
            try
            {
                //Ejecuamos el commando.
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);

                if (arrParam[1].Value.ToString() != "0")
                {
                    throw new Exception(arrParam[1].Value.ToString());
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

        public static DataTable listarRepresentacionLocal()
        {

            //DataSet ds = new DataSet;
            String cmdStr = "sre_mdt_pkg.ListarRepresentacionLocal";

            //Definimos nuestro arreglo de parametros.
            OracleParameter[] arrParam = new OracleParameter[2];

            arrParam[0] = new OracleParameter("p_io_cursor", OracleDbType.RefCursor);
            arrParam[0].Direction = ParameterDirection.Output;

            arrParam[1] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[1].Direction = ParameterDirection.Output;
            try
            {

                string result = string.Empty;

                //Ejecuamos el commando.
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

        public static DataTable getPinMDT(int idRegistroPatronal)
        {

            OracleParameter[] arrParam;
            String cmdStr = "SRE_MDT_PKG.getPinMDT";

            DataTable dt = new DataTable();

            //Definimos nuestro arreglo de parametros.
            arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_id_registro_patronal", OracleDbType.Int32);
            arrParam[0].Value = idRegistroPatronal;

            arrParam[1] = new OracleParameter("p_io_cursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;



            try
            {
                //Ejecuamos el commando.
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);



                if (arrParam[2].Value.ToString() != "0")
                {
                    throw new Exception(arrParam[2].Value.ToString());
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

        public static DataTable getDetPinMDT(int idRegistroPatronal, Int32 pageNum, Int32 pageSize)
        {

            OracleParameter[] arrParam;
            String cmdStr = "SRE_MDT_PKG.getDetPinMDT";

            DataTable dt = new DataTable();

            //Definimos nuestro arreglo de parametros.
            arrParam = new OracleParameter[5];

            arrParam[0] = new OracleParameter("p_id_registro_patronal", OracleDbType.Int32);
            arrParam[0].Value = idRegistroPatronal;

            arrParam[1] = new OracleParameter("p_pagenum", OracleDbType.Int32);
            arrParam[1].Value = pageNum;

            arrParam[2] = new OracleParameter("p_pagesize", OracleDbType.Int32);
            arrParam[2].Value = pageSize;

            arrParam[3] = new OracleParameter("p_io_cursor", OracleDbType.RefCursor);
            arrParam[3].Direction = ParameterDirection.Output;

            arrParam[4] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[4].Direction = ParameterDirection.Output;



            try
            {
                //Ejecuamos el commando.
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

        public static string ValidarPIN(int idRegistroPatronal, string PIN, string CodigoAutorizacion, string Descripcion)
        {

            OracleParameter[] arrParam;
            String cmdStr = "SRE_MDT_PKG.validarPin";

            //Definimos nuestro arreglo de parametros.
            arrParam = new OracleParameter[5];

            arrParam[0] = new OracleParameter("p_id_registro_patronal", OracleDbType.Int32);
            arrParam[0].Value = idRegistroPatronal;

            arrParam[1] = new OracleParameter("p_no_recibo", OracleDbType.Int32);
            if (PIN == "")
            {
                arrParam[1].Value = 0;
            }
            else
            {
                Convert.ToInt32(arrParam[1].Value = PIN);
            }

            arrParam[2] = new OracleParameter("p_no_autorizacion", OracleDbType.Int32);
            if (CodigoAutorizacion == "")
            {
                arrParam[2].Value = 0;
            }
            else
            {
                Convert.ToInt32(arrParam[2].Value = CodigoAutorizacion);
            }

            arrParam[3] = new OracleParameter("p_descripcion", OracleDbType.NVarchar2, 50);
            arrParam[3].Value = Descripcion;

            arrParam[4] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[4].Direction = ParameterDirection.Output;

            string result = string.Empty;
            try
            {

                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                result = Utilitarios.Utils.sacarMensajeDeError(arrParam[4].Value.ToString());

                return result;
            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;
            }

        }

        public static string procesar_PlanillasMDT(string id_referencia, string no_recibo, string observacion, string ult_usuario_act)
        {

            OracleParameter[] arrParam;
            String cmdStr = "sre_mdt_pkg.procesar_PlanillasMDT";

            //Definimos nuestro arreglo de parametros.......
            arrParam = new OracleParameter[5];

            arrParam[0] = new OracleParameter("p_id_referencia", OracleDbType.NVarchar2);
            arrParam[0].Value = id_referencia;

            arrParam[1] = new OracleParameter("p_no_recibo", OracleDbType.NVarchar2);
            arrParam[1].Value = no_recibo;

            arrParam[2] = new OracleParameter("p_ult_usuario_act", OracleDbType.NVarchar2, 25);
            arrParam[2].Value = ult_usuario_act;

            arrParam[3] = new OracleParameter("p_observacion", OracleDbType.NVarchar2, 500);
            arrParam[3].Value = observacion;

            arrParam[4] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[4].Direction = ParameterDirection.Output;


            string result = string.Empty;
            try
            {

                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                result = Utilitarios.Utils.sacarMensajeDeError(arrParam[4].Value.ToString());

                return result;
            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;
            }

        }

        public static DataTable getNovedadesPendientes(int idRegistroPatronal)
        {

            OracleParameter[] arrParam;
            String cmdStr = "SRE_MDT_PKG.getNovedadesMDT";

            DataTable dt = new DataTable();

            //Definimos nuestro arreglo de parametros.
            arrParam = new OracleParameter[3];


            arrParam[0] = new OracleParameter("p_id_registro_patronal", OracleDbType.Int32);
            arrParam[0].Value = idRegistroPatronal;

            arrParam[1] = new OracleParameter("p_io_cursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;
            try
            {
                //Ejecuamos el commando.
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);



                if (arrParam[2].Value.ToString() != "0")
                {
                    throw new Exception(arrParam[2].Value.ToString());
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

        public static DataTable getNovedadesPendientesaCambio(int idRegistroPatronal)
        {

            OracleParameter[] arrParam;
            String cmdStr = "SRE_MDT2_PKG.getNovedadesMDT";

            DataTable dt = new DataTable();

            //Definimos nuestro arreglo de parametros.
            arrParam = new OracleParameter[3];


            arrParam[0] = new OracleParameter("p_id_registro_patronal", OracleDbType.Int32);
            arrParam[0].Value = idRegistroPatronal;

            arrParam[1] = new OracleParameter("p_io_cursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;
            try
            {
                //Ejecuamos el commando.
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);



                if (arrParam[2].Value.ToString() != "0")
                {
                    throw new Exception(arrParam[2].Value.ToString());
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


        public static string AplicarNovedadesPendientesMDT(int p_id_registro_patronal, string p_ult_usuario_act)
        {

            OracleParameter[] arrParam;
            String cmdStr = "sre_mdt_pkg.AplicarNovedadesMDT";

            //Definimos nuestro arreglo de parametros.......
            arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_id_registro_patronal ", OracleDbType.NVarchar2);
            arrParam[0].Value = p_id_registro_patronal;

            arrParam[1] = new OracleParameter("p_ult_usuario_act", OracleDbType.NVarchar2, 25);
            arrParam[1].Value = p_ult_usuario_act;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;


            string result = string.Empty;
            try
            {

                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                result = Utilitarios.Utils.sacarMensajeDeError(arrParam[2].Value.ToString());

                return result;
            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;
            }


        }

        public static string EliminarNovedadesPendientesMDT(int p_id_registro_patronal, int p_id_nss)
        {

            OracleParameter[] arrParam;
            String cmdStr = "sre_mdt_pkg.EliminarNovedadesMDT";

            //Definimos nuestro arreglo de parametros.......
            arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_id_registro_patronal ", OracleDbType.NVarchar2);
            arrParam[0].Value = p_id_registro_patronal;

            arrParam[1] = new OracleParameter("p_id_nss", OracleDbType.Int32);
            arrParam[1].Value = p_id_nss;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;


            string result = string.Empty;
            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                result = Utilitarios.Utils.sacarMensajeDeError(arrParam[2].Value.ToString());

                return result;
            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;
            }


        }

        public static string EliminarNovedadesPendientesMDT2(int p_id_registro_patronal, int p_id_nss, string tipo_cambio, string fecha_cambio)
        {

        

            OracleParameter[] arrParam;
            String cmdStr = "sre_mdt2_pkg.EliminarNovedadesMDT";

            //Definimos nuestro arreglo de parametros.......
            arrParam = new OracleParameter[5];

            arrParam[0] = new OracleParameter("p_id_registro_patronal ", OracleDbType.NVarchar2);
            arrParam[0].Value = p_id_registro_patronal;

            arrParam[1] = new OracleParameter("p_id_nss", OracleDbType.Int32);
            arrParam[1].Value = p_id_nss;
        
            arrParam[2] = new OracleParameter("p_tipo_cambio", OracleDbType.NVarchar2);
            arrParam[2].Value = tipo_cambio;

            arrParam[3] = new OracleParameter("p_fecha_cambio", OracleDbType.Date);
          
            if (fecha_cambio != string.Empty) {
            arrParam[3].Value = Convert.ToDateTime( fecha_cambio);
            }

            
            arrParam[4] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[4].Direction = ParameterDirection.Output;


            string result = string.Empty;
            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                result = Utilitarios.Utils.sacarMensajeDeError(arrParam[4].Value.ToString());

                return result;
            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;
            }


        }

        public static DataTable getInformacionPin(int nro_recibo, int codigo_aprobacion, int representacion_local)
        {

            OracleParameter[] arrParam;
            String cmdStr = "SRE_MDT_PKG.GetInformacionPin";

            DataTable dt = new DataTable();

            //Definimos nuestro arreglo de parametros.
            arrParam = new OracleParameter[5];

            arrParam[0] = new OracleParameter("p_nro_recibo", OracleDbType.Int32);
            arrParam[0].Value = nro_recibo;

            arrParam[1] = new OracleParameter("p_codigo_aprobacion ", OracleDbType.Int32);
            arrParam[1].Value = codigo_aprobacion;

            arrParam[2] = new OracleParameter("p_representacion_local", OracleDbType.Int32);
            arrParam[2].Value = representacion_local;


            arrParam[3] = new OracleParameter("p_io_cursor", OracleDbType.RefCursor);
            arrParam[3].Direction = ParameterDirection.Output;

            arrParam[4] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[4].Direction = ParameterDirection.Output;


            try
            {
                //Ejecuamos el commando.
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

        public static DataTable getHistorialPin(int nro_recibo, int codigo_aprobacion)
        {

            OracleParameter[] arrParam;
            String cmdStr = "SRE_MDT_PKG.GetHistorialPin";

            DataTable dt = new DataTable();

            //Definimos nuestro arreglo de parametros.
            arrParam = new OracleParameter[4];

            arrParam[0] = new OracleParameter("p_nro_recibo", OracleDbType.Int32);
            arrParam[0].Value = nro_recibo;

            arrParam[1] = new OracleParameter("p_codigo_aprobacion ", OracleDbType.Int32);
            arrParam[1].Value = codigo_aprobacion;

            arrParam[2] = new OracleParameter("p_io_cursor", OracleDbType.RefCursor);
            arrParam[2].Direction = ParameterDirection.Output;

            arrParam[3] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[3].Direction = ParameterDirection.Output;


            try
            {
                //Ejecuamos el commando.
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);



                if (arrParam[3].Value.ToString() != "0")
                {
                    throw new Exception(arrParam[3].Value.ToString());
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

        public static string ValidarNovedadesPendientes(int idRegistroPatronal)
        {

            OracleParameter[] arrParam;
            String cmdStr = "SRE_MDT_PKG.ValidarNovedadesPendientes";

            //Definimos nuestro arreglo de parametros.
            arrParam = new OracleParameter[2];

            arrParam[0] = new OracleParameter("p_id_registro_patronal", OracleDbType.Int32);
            arrParam[0].Value = idRegistroPatronal;

            arrParam[1] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[1].Direction = ParameterDirection.Output;

            string result = string.Empty;
            try
            {

                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                result = Utilitarios.Utils.sacarMensajeDeError(arrParam[1].Value.ToString());

                return result;
            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;
            }

        }

        public static DataTable ConsultaDGT3(string RNC)
        {
            OracleParameter[] arrParam;
            String cmdStr = "SRE_MDT_PKG.ConsultaDGT3PorAño";

            DataTable dt = new DataTable();

            //Definimos nuestro arreglo de parametros.
            arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_rnc", OracleDbType.NVarchar2);
            arrParam[0].Value = RNC;

            arrParam[1] = new OracleParameter("p_io_cursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;


            try
            {
                //Ejecuamos el commando.
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);

                var Resultado = arrParam[2].Value.ToString().Split(new char[] { '|' });

                if (Resultado[0] != "0")
                {

                }
                else
                {
                    if (ds.Tables.Count > 0)
                    {
                        return ds.Tables[0];
                    }

                }

                return new DataTable(Resultado[1]);
            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;
            }
        }

        public static DataTable getNovedadesTrabajador(string nro_documento, string tipo_planilla, Int32 pageNum, Int32 pageSize)
        {

            OracleParameter[] arrParam;
            String cmdStr = "SRE_MDT_PKG.GetNovedadesTrabajador";

            DataTable dt = new DataTable();

            //Definimos nuestro arreglo de parametros.
            arrParam = new OracleParameter[6];

            arrParam[0] = new OracleParameter("p_nro_documento", OracleDbType.Varchar2);
            arrParam[0].Value = nro_documento;

            arrParam[1] = new OracleParameter("p_tipo_planilla", OracleDbType.Varchar2);
            arrParam[1].Value = tipo_planilla;

            arrParam[2] = new OracleParameter("p_pagenum", OracleDbType.Int32);
            arrParam[2].Value = pageNum;

            arrParam[3] = new OracleParameter("p_pagesize", OracleDbType.Int32);
            arrParam[3].Value = pageSize;

            arrParam[4] = new OracleParameter("p_io_cursor", OracleDbType.RefCursor);
            arrParam[4].Direction = ParameterDirection.Output;

            arrParam[5] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[5].Direction = ParameterDirection.Output;



            try
            {
                //Ejecuamos el commando.
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


        public static DataTable getPlanillaTrabajador(string nro_documento, string tipo_planilla, Int32 pageNum, Int32 pageSize)
        {

            OracleParameter[] arrParam;
            String cmdStr = "SRE_MDT_PKG.GetPlanillaTrabajador";

            DataTable dt = new DataTable();

            //Definimos nuestro arreglo de parametros.
            arrParam = new OracleParameter[6];

            arrParam[0] = new OracleParameter("p_nro_documento", OracleDbType.Varchar2);
            arrParam[0].Value = nro_documento;

            arrParam[1] = new OracleParameter("p_tipo_planilla", OracleDbType.Varchar2);
            arrParam[1].Value = tipo_planilla;

            arrParam[2] = new OracleParameter("p_pagenum", OracleDbType.Int32);
            arrParam[2].Value = pageNum;

            arrParam[3] = new OracleParameter("p_pagesize", OracleDbType.Int32);
            arrParam[3].Value = pageSize;

            arrParam[4] = new OracleParameter("p_io_cursor", OracleDbType.RefCursor);
            arrParam[4].Direction = ParameterDirection.Output;

            arrParam[5] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[5].Direction = ParameterDirection.Output;

            try
            {
                //Ejecuamos el commando.
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

        public static DataTable getHistoricoError(string nro_documento, Int32 pageNum, Int32 pageSize)
        {

            OracleParameter[] arrParam;
            String cmdStr = "SRE_MDT_PKG.GetHistoricoError";

            DataTable dt = new DataTable();

            //Definimos nuestro arreglo de parametros.
            arrParam = new OracleParameter[5];

            arrParam[0] = new OracleParameter("p_nro_documento", OracleDbType.Varchar2);
            arrParam[0].Value = nro_documento;
            
            arrParam[1] = new OracleParameter("p_pagenum", OracleDbType.Int32);
            arrParam[1].Value = pageNum;

            arrParam[2] = new OracleParameter("p_pagesize", OracleDbType.Int32);
            arrParam[2].Value = pageSize;

            arrParam[3] = new OracleParameter("p_io_cursor", OracleDbType.RefCursor);
            arrParam[3].Direction = ParameterDirection.Output;

            arrParam[4] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[4].Direction = ParameterDirection.Output;



            try
            {
                //Ejecuamos el commando.
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


    }


}


