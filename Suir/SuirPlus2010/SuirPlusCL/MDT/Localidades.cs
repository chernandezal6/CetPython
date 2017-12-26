using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using SuirPlus;
using System.Data;
using Oracle.ManagedDataAccess.Client;
using System.Configuration;

namespace SuirPlus.MDT
{
    public class Localidades
    {

        #region Variables Privadas y Propiedades

        int v_id_localidad; 
        public int id_localidad 
        { 
            get { return v_id_localidad; } 
        }
        string v_nombre_localidad;
        public string nombre_localidad
        {
            get { return v_nombre_localidad; }
            set { v_nombre_localidad = value; }
        }
        int v_id_registro_patronal;
        public int id_registro_patronal
        {
            get { return v_id_registro_patronal; }
            set { v_id_registro_patronal = value; }
        }
        string v_rnl;
        public string rnl
        {
            get { return v_rnl; }
            set { v_rnl = value; }
        }
        string v_status;
        public string status
        {
            get { return v_status; }
            set { v_status = value; }
        }        
        string v_calle;
        public string calle
        {
            get { return v_calle; }
            set { v_calle = value; }
        }
        string v_edificio;
        public string edificio 
        {
            get { return v_edificio; }
            set { v_edificio = value; }
        }
        string v_sector;
        public string sector
        {
            get { return v_sector; }
            set { v_sector = value; }
        }
        string v_ano_ini_operaciones;
        public string ano_ini_operaciones
        {
            get { return v_ano_ini_operaciones; }
            set { v_ano_ini_operaciones = value; }
        }

        string v_id_provincia;
        public string id_provincia
        {
            get { return v_id_provincia; }
            set { v_id_provincia = value; }
        }

        string v_id_municipio;
        public string id_municipio
        {
            get { return v_id_municipio; }
            set { v_id_municipio = value; }
        }
        string v_correo_electronico;
        public string correo_electronico
        {
            get { return v_correo_electronico; }
            set { v_correo_electronico = value; }
        }

        string v_fax_contacto;
        public string fax_contacto
        {
            get { return v_fax_contacto; }
            set { v_fax_contacto = value; }
        }
        string v_telefono_contacto;
        public string telefono_contacto
        {
            get { return v_telefono_contacto; }
            set { v_telefono_contacto = value; }
        }
        string v_no_documento;
        public string no_documento
        {
            get { return v_no_documento; }
            set { v_no_documento = value; }
        }

        DateTime v_fecha_registro;
        public DateTime fecha_registro
        {
            get { return v_fecha_registro; }
        }
        Double v_valor_instalacion;
        public Double valor_instalacion
        {
            get { return v_valor_instalacion; }
            set { v_valor_instalacion = value; }
        }
        string v_ult_usuario_act;
        public string ult_usuario_act
        {
            get { return v_ult_usuario_act; }
            set { v_ult_usuario_act = value; }
        }

        string v_id_actividad;
        public string id_actividad
        {
            get { return v_id_actividad; }
            set { v_id_actividad = value; }
        }
        string v_a_que_se_dedica;
        public string a_que_se_dedica
        {
            get { return v_a_que_se_dedica; }
            set { v_a_que_se_dedica = value; }
        }

        string v_es_zona_franca;
        public string es_zona_franca
        {
            get { return v_es_zona_franca; }
            set { v_es_zona_franca = value; }
        }
        string v_tipo_zona_franca;
        public string tipo_zona_franca
        {
            get { return v_tipo_zona_franca; }
            set { v_tipo_zona_franca = value; }
        }

        string v_id_zona_franca;
        public string id_zona_franca
        {
            get { return v_id_zona_franca; }
            set { v_id_zona_franca = value; }
        }
        string v_no_documento_representante;
        public string no_documento_representante
        {
            get { return v_no_documento_representante; }
            set { v_no_documento_representante = value; }
        }

  		#endregion

        
		/// <summary>
		/// Constructor de la clase utilizada para crear una Localidades.
		/// </summary>
		public Localidades()
		{

		}

		/// <summary>
        /// Constructor de la clase utilizada obtener toda la informacion concerniente a una Localidad.
		/// </summary>
        /// <param name="Numero">ID de la localidad que se desea consultar.</param>
        public Localidades(int idLocalidad)
        {

            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_id_localidad", OracleDbType.Int32);
            arrParam[0].Value = idLocalidad;

            arrParam[1] = new OracleParameter("p_io_cursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;

            string metodo = "sre_mdt_pkg.getlocalidad";
            DataTable dt = new DataTable();

            try
            {
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, metodo, arrParam);
                if (ds.Tables.Count > 0)
                {
                    dt = ds.Tables[0];
                    v_id_localidad = Convert.ToInt32(dt.Rows[0]["id_localidad"]);
                    nombre_localidad = dt.Rows[0]["descripcion"].ToString();
                    id_registro_patronal = Convert.ToInt32(dt.Rows[0]["id_registro_patronal"]);
                    rnl = dt.Rows[0]["localidad"].ToString();
                    status = dt.Rows[0]["status"].ToString();
                    calle = dt.Rows[0]["calle"].ToString();
                    edificio = dt.Rows[0]["edificio"].ToString();
                    sector = dt.Rows[0]["sector"].ToString();
                    id_provincia= dt.Rows[0]["id_provincia"].ToString();
                    id_municipio= dt.Rows[0]["id_municipio"].ToString();
                    correo_electronico= dt.Rows[0]["correo_electronico"].ToString();
                    fax_contacto= dt.Rows[0]["fax_contacto"].ToString();
                    telefono_contacto= dt.Rows[0]["telefono_contacto"].ToString();
                    no_documento= dt.Rows[0]["no_documento"].ToString();
                    ano_ini_operaciones = dt.Rows[0]["anio_ini_operaciones"].ToString();
                    v_fecha_registro = Convert.ToDateTime(dt.Rows[0]["fecha_registro"].ToString());
                    valor_instalacion = Convert.ToDouble(dt.Rows[0]["valor_instalacion"].ToString());
                    ult_usuario_act = dt.Rows[0]["ult_usuario_act"].ToString();
                    id_actividad = dt.Rows[0]["id_actividad"].ToString();
                    a_que_se_dedica = dt.Rows[0]["a_que_se_dedica"].ToString();
                    es_zona_franca = dt.Rows[0]["es_zona_franca"].ToString();
                    tipo_zona_franca = dt.Rows[0]["tipo_zona_franca"].ToString();
                    id_zona_franca = dt.Rows[0]["id_zona_franca"].ToString();
                    no_documento_representante = dt.Rows[0]["no_documento_representante"].ToString();
                  
                }
                else
                {
                    throw new Exception("No hay Data.");
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

        public static DataTable getLocalidades(Int32 pIdRegistroPatronal, Int32 pageNum, Int32 pageSize)
        {

            OracleParameter[] arrParam;
            String cmdStr = "SRE_MDT_PKG.getLocalidades";

            DataTable dt = new DataTable();

            //Definimos nuestro arreglo de parametros.
            arrParam = new OracleParameter[5];

            arrParam[0] = new OracleParameter("p_id_registro_patronal", OracleDbType.Int32);
            arrParam[0].Value = pIdRegistroPatronal;

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

        public static string procesarLocalidad(string id_localidad, int id_registro_patronal, string descripcion, 
                                                string status, string calle, string edificio, string sector,
                                                string id_provincia, string id_municipio, string correo_electronico, string fax_contacto, string telefono_contacto, string no_documento,
                                                string ano_ini_operaciones, string valor_instalacion, string ult_usuario_act,
                                                string id_actividad, string a_que_se_dedica, string es_zona_franca, string tipo_zona_franca,string id_zona_franca, string no_documento_rep)
        {
            OracleParameter[] arrParam = new OracleParameter[23];
            try
            {
                arrParam[0] = new OracleParameter("p_id_localidad", OracleDbType.Int32);
                if (id_localidad != string.Empty)
                {
                    arrParam[0].Value = Convert.ToInt32(id_localidad);
                }
                else
                {
                    arrParam[0].Value = DBNull.Value;
                }
                arrParam[1] = new OracleParameter("p_id_registro_patronal", OracleDbType.Int32);
                arrParam[1].Value = id_registro_patronal;
                arrParam[2] = new OracleParameter("p_DESCRIPCION", OracleDbType.Varchar2,150);
                arrParam[2].Value = descripcion;               
                arrParam[3] = new OracleParameter("p_status", OracleDbType.Varchar2,1);
                arrParam[3].Value = status;
                arrParam[4] = new OracleParameter("p_calle", OracleDbType.Varchar2,150);
                arrParam[4].Value = calle;
                arrParam[5] = new OracleParameter("p_edificio", OracleDbType.Varchar2,100); 
                arrParam[5].Value = edificio;
                arrParam[6] = new OracleParameter("p_sector", OracleDbType.Varchar2,150);
                arrParam[6].Value = sector;
                arrParam[7] = new OracleParameter("p_id_provincia", OracleDbType.Varchar2);
                arrParam[7].Value = id_provincia;
                arrParam[8] = new OracleParameter("p_id_municipio", OracleDbType.Varchar2);
                arrParam[8].Value = id_municipio;
                arrParam[9] = new OracleParameter("p_correo_electronico", OracleDbType.Varchar2,150);
                arrParam[9].Value = correo_electronico;
                arrParam[10] = new OracleParameter("p_fax_contacto", OracleDbType.Varchar2,15);
                arrParam[10].Value = fax_contacto;
                arrParam[11] = new OracleParameter("p_telefono_contacto", OracleDbType.Varchar2,15);
                arrParam[11].Value = telefono_contacto;
                
                arrParam[12] = new OracleParameter("p_no_documento", OracleDbType.Varchar2, 11);
                arrParam[12].Value = no_documento;
                arrParam[13] = new OracleParameter("p_fecha_ini_operaciones", OracleDbType.Varchar2,4);
                arrParam[13].Value = ano_ini_operaciones;
                arrParam[14] = new OracleParameter("p_valor_instalacion", OracleDbType.Decimal,18);
                if (valor_instalacion != string.Empty)
                {
                    arrParam[14].Value = Convert.ToDouble(valor_instalacion);
                }
                else
                {
                    arrParam[14].Value = 0.0;
                } 
                arrParam[15] = new OracleParameter("p_ult_usuario_act", OracleDbType.Varchar2);
                arrParam[15].Value = ult_usuario_act;

                arrParam[16] = new OracleParameter("p_id_actividad", OracleDbType.Varchar2);
                arrParam[16].Value = id_actividad;
                arrParam[17] = new OracleParameter("p_a_que_se_dedica", OracleDbType.Varchar2);
                arrParam[17].Value = a_que_se_dedica;
                arrParam[18] = new OracleParameter("p_es_zona_franca", OracleDbType.Varchar2);
                arrParam[18].Value = es_zona_franca;
                arrParam[19] = new OracleParameter("p_tipo_zona_franca", OracleDbType.Varchar2);
                arrParam[19].Value = tipo_zona_franca;
                arrParam[20] = new OracleParameter("p_id_zona_franca", OracleDbType.Varchar2);
                arrParam[20].Value = id_zona_franca;
                arrParam[21] = new OracleParameter("p_no_documento_rep", OracleDbType.Varchar2);
                arrParam[21].Value = no_documento_rep;

                arrParam[22] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2,200);
                arrParam[22].Direction = ParameterDirection.Output;
                
                String cmdStr = "sre_mdt_pkg.actualizarlocalidad";
                string result = string.Empty;

                    DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                    result = arrParam[22].Value.ToString();

                    if (result.Split('|')[0].ToString() != "0")
                    {
                        throw new Exception(result.Split('|')[1].ToString());
                    }

                    return result.Split('|')[0].ToString();

            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;

            }
            
        }

        public static string bajaLocalidad(int id_localidad, string ult_usuario_act)
        {
            OracleParameter[] arrParam = new OracleParameter[3];

            try
            {
                arrParam[0] = new OracleParameter("p_id_localidad", OracleDbType.Int32);
                arrParam[0].Value = id_localidad;
                arrParam[1] = new OracleParameter("p_ult_usuario_act", OracleDbType.Varchar2);
                arrParam[1].Value = ult_usuario_act;
                arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
                arrParam[2].Direction = ParameterDirection.Output;

                String cmdStr = "SRE_MDT_PKG.bajaLocalidad";
                string result = string.Empty;

                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                result = arrParam[2].Value.ToString();

                if (result != "0")
                {
                    throw new Exception(result);
                }

                return result;

            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;

            }

        }

        public static DataTable listarLocalidades(Int32 pIdRegistroPatronal)
        {

            OracleParameter[] arrParam;            

            DataTable dt = new DataTable();

            //Definimos nuestro arreglo de parametros.
            arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_id_registro_patronal", OracleDbType.Int32);
            arrParam[0].Value = pIdRegistroPatronal;

            arrParam[1] = new OracleParameter("p_io_cursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;

            String cmdStr = "SRE_MDT_PKG.listarLocalidades";
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

       

    }
}
